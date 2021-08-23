//
//  MainViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class MainViewController: UICollectionViewController {
    // MARK: - Property
    
    private let reuseIdentifier = "imageCell"
    private let sectionInsets = UIEdgeInsets(top: 2, left: 1, bottom: 0, right: 0)
    private let itemsPerRow: CGFloat = 2
    let networkService = Network()
    var photos: [Photo]? = nil {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadLinks()
    }
    
    @IBAction func exit(_ sender: Any) {
        VK.sessions.default.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(LoginViewController)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos?.count ?? 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell
        cell?.activityIndicator.startAnimating()
        cell?.imageUrl = photos?[indexPath.row].photoLink
        
        return cell ?? collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}

// MARK: - Network

extension MainViewController {
    func loadLinks() {
        networkService.getData { [weak self] photos, alert in
            if let photos = photos {
                self?.photos = photos
            } else if let alert = alert {
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 3
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
    //    5
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.top
    }
    
}
