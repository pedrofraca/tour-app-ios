//
//  ImageLoader.swift
//  TourApp
//
//  Created by Pedro Fraca on 07.01.21.
//  Copyright © 2021 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var imageCache = ImageCache.getImageCache()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        if let imageData = imageCache.get(forKey: urlString) {
            DispatchQueue.main.async {
                self.data = imageData.data
                return
            }
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageCache.set(forKey: urlString, image: ImageData(data: data))
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView : View {
    
    @ObservedObject var imageLoader = ImageLoader()
    @State var image:UIImage = UIImage()
    
    init(url : String) {
        self.imageLoader.load(urlString: url)
    }
    
    var body : some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipped()
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
            }
        }
    }
}

class ImageData {
    var data = Data()
    init( data : Data) {
        self.data = data
    }
    
}

class ImageCache {
    var cache = NSCache<NSString, ImageData>()

    func get(forKey: String) -> ImageData? {
        return cache.object(forKey: NSString(string: forKey))
    }

    func set(forKey: String, image: ImageData) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
