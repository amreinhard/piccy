//
//  imgurImage.swift
//  piccy
//
//  Created by Amanda Reinhard on 7/12/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit

struct ImgurImageUpload: Codable {
    var image: Data
    var title: String
    var description: String
    var fileName: String
}

struct ImgurImageResponse: Codable {
    var data: ImgurPost?
    var success: Bool?
    var status: Int?
}

struct ImgurPost: Codable {
    var id: String?
    var title: String?
    var description: String?
    var width: Int?
    var height: Int?
    var deletehash: String?
    var name: String?
    var link: String?
    var error: String?
}
