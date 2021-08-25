//
//  Network.swift
//  mobileUp
//
//  Created by Patrik Duksin on 23.08.2021.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftyVK

struct Network {
    func getData(completionHandler: @escaping (([Photo]?, UIAlertController? ) -> Void)) {
        VK.API.Photos.get([
            .ownerId: "-128666765",
            .albumId: "266276915"
        ])
        .configure(with: Config(apiVersion: "5.77"))
        .onSuccess { data in
            do {
                let jsonData = try JSON(data: data)
                var photos: [Photo] = []
                jsonData["items"].forEach {
                    let photo = $0.1
                    guard let date = photo["date"].int,
                          let identifier = photo["id"].int
                    else { return }
                    var previewUrl: URL?
                    var bigUrl: URL?
                    let links = photo["sizes"].filter {
                        $0.1["type"] == "x" || $0.1["type"] == "w"
                    }
                    links.forEach {
                        switch $0.1["type"] {
                        case "x":
                            previewUrl = $0.1["url"].url
                        case "w":
                            bigUrl = $0.1["url"].url
                        default:
                            print($0)
                        }
                    }
                    guard let bigUrl = bigUrl,
                          let previewUrl = previewUrl
                    else { return }
                    photos.append(Photo(photoId: identifier, previewPhotoLink: previewUrl, bigPhotoLink: bigUrl, date: date))
                }
            completionHandler(photos, nil)
        } catch {
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: NSLocalizedString("OK", comment: "Default action"),
                    style: .default, handler: nil)
            )
            completionHandler(nil, alert)
        }
    }
    .onError { error in
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(
    UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
    style: .default,
    handler: nil)
    )
    completionHandler(nil, alert)
    }
    .send()
}
}
