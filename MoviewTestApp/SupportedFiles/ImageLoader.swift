//
//  ImageLoader.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 06.03.2021.
//

import UIKit
import Kingfisher

class ImageLoader {
    
    var imageView: UIImageView?
    
    func load(url: URL, loaded: (() -> Void)? = .none) {
        
        let image = self.readImage(url: url)
        
        imageView?.kf.setImage(with: url, placeholder: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(info):
                loaded?()
                self.save(image: info.image, url: info.source.url)
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func save(image: UIImage?, url: URL?) {
        guard let path = getPath(for: url) else { return }
        
        if !FileManager.default.fileExists(atPath: path) {
            let data = image?.pngData()
            FileManager.default.createFile(atPath: path, contents: data, attributes: .none)
        }
    }
    
    private func readImage(url: URL) -> UIImage? {
        guard let path = getPath(for: url) else { return .none }
        return UIImage(contentsOfFile: path)
    }
    
    private func getPath(for url: URL?) -> String? {
        guard let urlString = url?.absoluteString else { return .none }
        guard let last = urlString.split(separator: "/").last else { return .none }
        let filename = String(last)
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let path = directory?.appendingPathComponent(filename).path
        
        return path
    }
}
