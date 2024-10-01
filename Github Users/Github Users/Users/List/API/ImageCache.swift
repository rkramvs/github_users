//
//  ImageCache.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation
import UIKit


public class ImageCache {
    
    public static let publicCache = ImageCache()
    var placeholderImage = UIImage(systemName: "rectangle")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(String, UIImage?) -> Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, key: String, completion: @escaping (String, UIImage?) -> Swift.Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(key, cachedImage)
            }
            return
        }
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // Go fetch the image.
        
        Task(priority: .background) {
            do {
                let data = try await UsersImageDownloadAPI(avatarURL: url as URL).downloadImage()
                
                guard let image = UIImage(data: data),  let blocks = self.loadingResponses[url] else {
                    DispatchQueue.main.async {
                        completion(key, nil)
                    }
                    return
                }
                
                self.cachedImages.setObject(image, forKey: url, cost: data.count)
                for block in blocks {
                    DispatchQueue.main.async {
                        block(key, image)
                    }
                    return
                }
                
            }catch {
                //TODO: Track Error
                DispatchQueue.main.async {
                    completion(key, nil)
                }
                return
            }
        }
    }
        
}
