//
//  imgurAPI.swift
//  piccy
//
//  Created by Amanda Reinhard on 7/12/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit

class imgurAPI {

    var description: String = ""
    
    var baseURL = URL(string: "https://api.imgur.com/3/")
    
    func image(for hash: String, completion: @escaping (ImgurImageResponse) -> Void) {
        let path = "/image/\(hash)"
        let url = baseURL?.appendingPathComponent(path)
        var request = URLRequest(url: url!)
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(ImgurImageResponse.self, from: data)
                completion(decoded)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func upload(image: ImgurImageUpload, completion: @escaping (ImgurImageResponse) -> Void) {
        let path = "/image"
        let data = image.image
        var components = URLComponents(url: baseURL!, resolvingAgainstBaseURL: false)
        components?.path += path
        var request = URLRequest(url: (components?.url)!)
        let multiPart = try? MultipartFormData.Builder.build(with: [(name: "image",
                                                                     filename: nil,
                                                                     mimeType: nil,
                                                                     data: data),
                                                                    (name: "title",
                                                                     filename: nil,
                                                                     mimeType: nil,
                                                                     data: image.title.data(using: .utf8)!),
                                                                    (name: "description",
                                                                     filename: nil,
                                                                     mimeType: nil,
                                                                     data: image.description.data(using: .utf8)!),
                                                                    (name: "name",
                                                                     filename: nil,
                                                                     mimeType: nil,
                                                                     data: image.fileName.data(using: .utf8)!)],
                                                            willSeparateBy: RandomBoundaryGenerator.generate())
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.addValue((multiPart!.contentType), forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = multiPart!.body
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            guard let responseData = responseData else { return }
            do {
                let decoded = try JSONDecoder().decode(ImgurImageResponse.self, from: responseData)
                completion(decoded)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func deleteImage(with hash: String, completion: () -> Void) {
        
    }
    
    func updateImageInfo(with hash: String, completion: () -> Void) {
        
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

// MARK: - Text view changes

//func textViewDidChange(_ textView: UITextView) {
//    let newAlpha = textView.text.isEmpty ? 1.0 : 0.0
//
//    return
//}
