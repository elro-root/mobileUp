//
//  CollectionViewCell.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let cache = NSCache<NSURL, UIImage>()

    let networkService = Network()
    var imageUrl: URL? {
        didSet {
            imageView?.image = nil
            updateUI()
        }
    }

    func updateUI() {
        if let url = imageUrl {
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInteractive).async {
                let contentsOfUrl = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageUrl {
                        guard let uri = NSURL(string: "\(url)") else { return }
                        if let cachedImage = self.cache.object(forKey: uri) {
                            self.imageView.image = cachedImage
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        } else if let imageData = contentsOfUrl {
                            guard let image = UIImage(data: imageData) else { return }
                            self.imageView.image = image
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            DispatchQueue.global(qos: .utility).async {
                                self.cache.setObject(image, forKey: uri)
                            }
                        }
                    }
                }
            }
        }
    }
}
