//
//  UserTableViewCell.swift
//  Test Bokhary
//
//  Created by Elsayed Hussein on 6/8/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import UIKit
import Bokhary

class UserTableViewCell: UITableViewCell {
        
    //MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Methods
    fileprivate func loadUserImage(_ user: User) {
        if let url = URL(string: user.profileImage.medium) {
            activityIndicator.startAnimating()
            Bokhary.load(url: url) { [weak self] (result) in
                
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        self?.profileImageView.image = image
                    }
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        } else {
            profileImageView.image = nil
        }
    }
    
    func configure(user: User) {
        loadUserImage(user)
        userNameLabel.text = "@\(user.username)"
        nameLabel.text = user.name
    }
}
