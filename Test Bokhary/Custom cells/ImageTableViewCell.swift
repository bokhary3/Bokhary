//
//  ImageTableViewCell.swift
//  Test Bokhary
//
//  Created by Elsayed Hussein on 6/8/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import UIKit
import Bokhary

class ImageTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var urlImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Methods
    func configure(imagePath: String) {
        
        if let url = URL(string: imagePath) {
        activityIndicator.startAnimating()
            Bokhary.load(url: url) { [weak self] (result) in
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let imageData):
                    self?.urlImageView.image = UIImage(data: imageData)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
