//
//  FileStore.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 10.02.2022.
//

import Foundation
import UIKit

public func LocalizedString(_ key: String) -> String {
    let bundle = Bundle(for: FileStore.self)
    return bundle.localizedString(forKey: key, value: "", table: nil)
}

class FileStore{
    static private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(from str: String, complition: ((_ image: UIImage?) -> Void)?) {
        if let url = URL(string: str){
            downloadImage(from: url, complition: complition)
        }else{
            complition?(nil)
        }
    }
    
    static func downloadImage(from url: URL, complition: ((_ image: UIImage?) -> Void)?) {
        if let loadedImage = loadImage(url: url) {
            complition?(loadedImage)
        }else{
            getData(from: url, completion: { data, response, error in
                let image: UIImage?
                if let data = data{
                    image = UIImage(data: data)
                    if let _ = image{
                        saveImage(url: url, data: data)
                    }
                }else{
                    image = nil
                }
                complition?(image)
            })
        }
    }
    
    static func getImageStoreDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDir = paths[0]
        let ImageStoreDir = docDir.appendingPathComponent("ImageStore")
        if !FileManager.default.fileExists(atPath: ImageStoreDir.path) {
            do {
                try FileManager.default.createDirectory(atPath: ImageStoreDir.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
            }
        }
        return ImageStoreDir
    }
    
    static func createPathUrl(url: URL) -> URL{
        let hash = Hashes.md5(url.absoluteString) + ".png"
        let imageStoreDirectory = getImageStoreDirectory()
        let filenameUrl = imageStoreDirectory.appendingPathComponent(hash)
        return filenameUrl
    }
    
    static func loadImage(url: URL) -> UIImage?{
        let filenameUrl = createPathUrl(url: url)
        do {
            let imageData = try Data(contentsOf: filenameUrl)
            return UIImage(data: imageData)
        } catch {
        }
        return nil
    }
    
    static func saveImage(url: URL, data: Data){
        let filenameUrl = createPathUrl(url: url)
        try? data.write(to: filenameUrl)
    }
}
