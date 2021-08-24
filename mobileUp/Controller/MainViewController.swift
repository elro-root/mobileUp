//
//  MainViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class MainViewController: UIViewController {
    // MARK: - Property
    
    private var mainView: MainView! {
        guard isViewLoaded else { return nil}
        guard let view = view as? MainView else { return nil }
        return view
    }
    
    private let reuseIdentifier = "imageCell"
    private let itemsPerRow: CGFloat = 2
    let networkService = Network()
    var photos: [Photo]? = nil {
        didSet {
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLinks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Mobile Up Gallery"
        mainView.navigationBar.titleLabel.text = self.title
        mainView.navigationBar.leftButton.isHidden = true
        mainView.navigationBar.rightButton.setTitle("Выход", for: .normal)
        mainView.navigationBar.rightButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func exit() {
        VK.sessions.default.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(LoginViewController)
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController =
                storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        guard let photos = photos else { return }
        viewController.title = "\(photos[indexPath.row].date)"
        viewController.photo = photos[indexPath.row].photo
        viewController.date = photos[indexPath.row].date
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.activityIndicator.startAnimating()
            cell.imageUrl = photos?[indexPath.row].photoLink
        }
        return cell
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
        let paddingSpace = CGFloat(2)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(2)
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

