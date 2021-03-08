//
//  ImageLoader.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 06.03.2021.
//

import UIKit

class ImageLoader {
    
    private var keys: [URL: IndexPath] = [:]
    
    func load(url: URL, loaded: ((UIImage) -> Void)? = .none) {
        DispatchQueue.global().async {  [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        loaded?(image)
                        self.save(image: image, url: url)
                    }
                }
            }
        }
    }
    
    func reusableLoad(url: URL, indexPath: IndexPath, loaded: ((UIImage?, IndexPath?) -> Void)? = .none) {
        keys[url] = indexPath
        DispatchQueue.global().async {  [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        loaded?(image, self.keys[url])
                        self.save(image: image, url: url)
                    }
                }
            } else {
                let image = self.readCahedImage(url: url)
                DispatchQueue.main.async { loaded?(image, self.keys[url]) }
            }
        }
    }
    
    private func save(image: UIImage?, url: URL?) {
        guard let fullPath = getPath(for: url) else { return }
        
        if !FileManager.default.fileExists(atPath: fullPath) {
            let data = image?.pngData()
            FileManager.default.createFile(atPath: fullPath, contents: data, attributes: .none)
        }
    }
    
    func readCahedImage(url: URL) -> UIImage? {
        guard let path = getPath(for: url) else { return .none }

        return UIImage(contentsOfFile: path)
    }
    
    private func getPath(for url: URL?) -> String? {
        guard let urlString = url?.absoluteString else { return .none }
        
        let array = urlString.split(separator: "/").map { String ($0) }
        let range = array.index(array.endIndex, offsetBy: -2) ..< array.endIndex
        let filename = Array(array[range]).joined(separator: "_")

        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let path = directory?.appendingPathComponent(filename).path
        
        return path
    }
}
