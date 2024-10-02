//
//  URLCache.swift
//  Packages
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation

public class CustomExpiringURLCache: URLCache {
    
    //MARK: - Example initialisation
    
    //memoryCapacity - 10 MB, diskCapacity - 1 GB, 15 Days expiration time.
    public static let global: CustomExpiringURLCache = {
        var cache = CustomExpiringURLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 1 * 1024 * 1024 * 1024, directory: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0])
        cache.set(expirationTime: 15 * 24 * 60 * 60)
        return cache
    }()
    
    private var expirationTime: TimeInterval?
    
    private func set(expirationTime: TimeInterval) {
        self.expirationTime = expirationTime
    }
    
    func canStoreResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) -> Bool {
        
        guard request.httpMethod == HttpMethod.get.rawValue else { return false}
        
        guard let httpResponse = cachedResponse.response as? HTTPURLResponse else { return false }
        
        let statusCode = httpResponse.statusCode
        
        guard statusCode == 200 else { return false }
        
        return true
    }
    
    public override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        if canStoreResponse(cachedResponse, for: request) {
            super.storeCachedResponse(CustomExpiringURLCacheResponse(response: cachedResponse), for: request)
        }
    }
    
    func canReturnCachedResponse(_ response: CachedURLResponse) -> Bool {
        
        if let userInfo = response.userInfo,
            let cacheTime = userInfo["cache_time"] as? Date,
            let expirationTime {
            let cacheTimeInterval = abs(cacheTime.timeIntervalSinceNow)
            if cacheTimeInterval <= expirationTime {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    public override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        if let response = super.cachedResponse(for: request) {
            if canReturnCachedResponse(response) {
                return response
            }
        }
        return nil
    }
}

public class CustomExpiringURLCacheResponse: CachedURLResponse {
    public init(response: CachedURLResponse) {
        
        var userInfo: [AnyHashable: Any] = response.userInfo ?? [:]
        userInfo["cache_time"] = Date()
        
        super.init(response: response.response, data: response.data, userInfo: userInfo, storagePolicy: .allowed)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
