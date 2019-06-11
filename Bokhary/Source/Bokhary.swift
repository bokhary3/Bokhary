//
//  Bokhary.swift
//  Bokhary
//
//  Created by Elsayed Hussein on 6/6/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import Foundation

/**
 Bokhary is a simple library to handle network request, images or docments.
 */
public class Bokhary {

    //MARK: Variables
    fileprivate static var cachedData: [URL: Data] = Dictionary(minimumCapacity: cacheSize)
    fileprivate static var urlUsedTimes: [URL: Int] = [:]
    fileprivate static let loadingQueue = OperationQueue()
    fileprivate static var loadingOperations: [URL: DataDownloader] = [:]
    public static var cacheSize = 100
    
    //MARK: Methods
    
    fileprivate class func cash(data: Data, of url: URL) {
        while cachedData.count >= cacheSize {
            guard let leastURLUsed = urlUsedTimes.min(by: { (first, second) -> Bool in
                first.value > second.value
            }) else {
                break
            }
            
            cachedData.removeValue(forKey: leastURLUsed.key)
            urlUsedTimes.removeValue(forKey: leastURLUsed.key)
            
        }
        cachedData[url] = data
        urlUsedTimes[url, default: 0] += 1
    }
    
    /**
     request the url
     - parameters:
     - url : request URL
     - completion: to get the result
     */
    public class func load(url: URL, completion: @escaping (Result<Data,NetworkError>) -> ()) {
        
        if let data = cachedData[url] {
            urlUsedTimes[url, default: 0] += 1
            completion(.success(data))
            return
        }
        
        let dataDownloader = DataDownloader(url: url)
        
        loadingQueue.addOperation(dataDownloader)
        loadingOperations[url] = dataDownloader
        
        dataDownloader.completionDataHandler = { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.anErrorOccured))
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.anErrorOccured))
                }
                return
            }
    
            cash(data: data, of: url)
            loadingOperations.removeValue(forKey: url)
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
    
    /**
     Cancel the request of a certain url
     - parameters:
     - url : reuqest url
     */
    public class func cancelLoadingDataOf(url: URL) {
        if let operation = loadingOperations[url] {
            operation.cancel()
            loadingOperations.removeValue(forKey: url)
            urlUsedTimes.removeValue(forKey: url)
            cachedData.removeValue(forKey: url)
        }
    }
    
}
