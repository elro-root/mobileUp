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
    func getData(completionHandler: @escaping (([Photo]?, UIAlertController? ) -> ())) {
        VK.API.Photos.get([
            .ownerId: "-128666765",
            .albumId: "266276915",
        ])
        .configure(with: Config(apiVersion: "5.77"))
        .onSuccess { data in
            do {
                let jsonData = try JSON(data: data)
                var photos: [Photo] = []
                jsonData["items"].forEach {
                    let photo = $0.1
                    photo["sizes"].forEach {
                        if $0.1["type"] == "z" {
                            guard let date = photo["date"].int,
                                  let id = photo["id"].int,
                                  let url = URL(string: $0.1["url"].string ?? ""),
                                  let contentsOfUrl = try? Data(contentsOf: url),
                                  let photo = UIImage(data: contentsOfUrl) else { return }
                            photos.append(Photo(photo: photo, photoId: id, photoLink: url, date: date))
                        }
                    }
                }
                completionHandler(photos, nil)
            } catch {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                completionHandler(nil, alert)
                
            }
        }
        .onError { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            completionHandler(nil, alert)
        }
        .send()
    }
}
