//
//  DetailViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    
    var photo: UIImage?
    var date: Int?
    
    private var detailView: DetailView! {
        guard isViewLoaded else { return nil}
        guard let view = view as? DetailView else { return nil }
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.imageView.image = photo
        if let date = date {
            detailView.navigationBar.titleLabel.text = convertDate(unixtime: date)
        } else {
            detailView.navigationBar.titleLabel.text = ""
        }
        detailView.navigationBar.rightButton.setImage(UIImage(named: "shareButton"), for: .normal)
        detailView.navigationBar.leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        detailView.navigationBar.leftButton.addTarget(self, action: #selector(backButton), for: .touchUpInside)
    }
    
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDate(unixtime date: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.dateFormat = "dd MMMM yy"
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
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
