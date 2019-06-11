//
//  DetailsTableViewController.swift
//  Test Bokhary
//
//  Created by Elsayed Hussein on 6/8/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import UIKit
import Bokhary

class DetailsTableViewController: UITableViewController {
    
    //MARK: Variables
    var userData: ResponseModel?
    private var images = [String]()
    
    //MARK: Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    //MARK: View lifcycle methods
    fileprivate func setProfileImage(_ user: User) {
        activityIndicator.startAnimating()
        if let url = URL(string: user.profileImage.medium) {
            Bokhary.load(url: url) { [weak self] (result) in
                self?.activityIndicator.stopAnimating()
                if let imageData = try? result.get() {
                    self?.userImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urls = userData?.urls, let user = userData?.user else {
            return
        }
        
        
        setProfileImage(user)
        nameLabel.text = user.name
        userNameLabel.text = "@\(user.username)"
        
        
        images = [urls.raw, urls.full, urls.regular, urls.small, urls.thumb]
    }
    
    //MARK: Methods
}

//MARK: UITableViewDataSource methods
extension DetailsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageTableViewCell
        cell.configure(imagePath: images[indexPath.row])
        
        return cell
    }
}

