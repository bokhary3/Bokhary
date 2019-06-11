//
//  ViewController.swift
//  Test Bokhary
//
//  Created by Elsayed Hussein on 6/7/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import UIKit
import Bokhary

class TableViewController: UITableViewController {
    
    //MARK: Variables
    var usersData: [ResponseModel]?
    
    //MARK: View lifcycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // handle refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // configure Bokhary cache
        Bokhary.cacheSize = 20
        
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    //MARK: Methods
    private func loadData() {
        guard let url = URL(string: "http://pastebin.com/raw/wgkJgazE") else {
            return
        }
        Bokhary.load(url: url) { [weak self] (result) in
            switch result {
            case .success(let data):
                do {
                    self?.usersData = try JSONDecoder().decode([ResponseModel].self, from: data)
                    self?.tableView.reloadData()
                    if let isRefreshing = self?.refreshControl?.isRefreshing, isRefreshing {
                        self?.refreshControl?.endRefreshing()
                    }
                } catch {
                    print("Error: \(error)")
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    @objc private func refreshData(_ refreshControl: UIRefreshControl) {
        guard var usersData = usersData else {
            return
        }
        
        usersData.removeAll()
        tableView.reloadData()
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserDetails" {
            let detailsTableVC = segue.destination as! DetailsTableViewController
            detailsTableVC.userData = sender as? ResponseModel
        }
    }
}

//MARK: UITableViewDataSource methods
extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usersData = usersData else {
            return 0
        }
        return usersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        if let userData = usersData?[indexPath.row] {
            cell.configure(user: userData.user)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let usersData = usersData else {
            return
        }
        let lastElement = usersData.count - 1
        if indexPath.row == lastElement {
            loadData()
        }
    }
}

//MARK: UITableViewDelegate methods

extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = usersData?[indexPath.row]
        performSegue(withIdentifier: "showUserDetails", sender: userData)
    }
}

