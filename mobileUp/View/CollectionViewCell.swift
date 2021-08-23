//
//  CollectionViewCell.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let networkService = Network()
//    var links: [Photo]? = nil
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
                        if let imageData = contentsOfUrl {
                            self.imageView.image = UIImage(data: imageData)
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    }
                }
            }
        }
    }
}
