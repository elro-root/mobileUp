//
//  DetailViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit
import NotificationBannerSwift

class DetailViewController: UIViewController {

    var preview: UIImage?
    var date: Int?
    var url: URL?

    private var detailView: DetailView! {
        guard isViewLoaded else { return nil}
        guard let view = view as? DetailView else { return nil }
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.imageView.image = preview
        if let date = date {
            detailView.navigationBar.titleLabel.text = convertDate(unixtime: date)
        } else {
            detailView.navigationBar.titleLabel.text = ""
        }
        detailView.navigationBar.rightButton.setImage(UIImage(named: "shareButton"), for: .normal)
        detailView.navigationBar.rightButton.addTarget(self, action: #selector(shareButton), for: .touchUpInside)
        detailView.navigationBar.leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        detailView.navigationBar.leftButton.addTarget(self, action: #selector(backButton), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let url = self.url,
                let content = try? Data(contentsOf: url)
            else { return }
            let image = UIImage(data: content)
            DispatchQueue.main.async {
                self.detailView.imageView.image = image
            }
        }
    }

    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func shareButton() {
        let shareController = UIActivityViewController(
            activityItems: [detailView.imageView.image!],
            applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activity, success, _, error) in
            guard let activity = activity else { return }
            var banner = FloatingNotificationBanner()
            switch activity {
            case .saveToCameraRoll:
                if let error = error {
                    banner = FloatingNotificationBanner(
                        title: "Фотография не сохранена",
                        subtitle: error.localizedDescription,
                        style: .warning
                    )
                    banner.show()
                } else {
                    banner = FloatingNotificationBanner(
                        title: "Фотография успешно сохранена",
                        style: .success
                    )
                    banner.show()
                }
            default:
                print("")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                banner.dismiss()
            }
        }
        present(shareController, animated: true, completion: nil)
    }

    func convertDate(unixtime date: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }
}
