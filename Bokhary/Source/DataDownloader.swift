//
//  DataDownloader.swift
//  Bokhary
//
//  Created by Elsayed Hussein on 6/8/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import Foundation

/**
 DataDownloader is type of operation to handle
 parllel request calling.
 */
class DataDownloader: Operation {
    
    var url: URL
    var completionDataHandler: ((Data?, URLResponse?, Error?) -> Void)?
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let completionDataHandler = self.completionDataHandler {
                completionDataHandler(data, response, error)
            }
        })
        
        dataTask?.resume()
    }
}
