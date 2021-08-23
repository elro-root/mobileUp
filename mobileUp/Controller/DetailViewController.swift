//
//  DetailViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var photo: URL?
    
    private var detailView: DetailView! {
        guard isViewLoaded else { return nil}
        guard let view = view as? DetailView else { return nil }
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = try? Data(contentsOf: photo!)
        self.detailView.imageView.image = UIImage(data: data!)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
