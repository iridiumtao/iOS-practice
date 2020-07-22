//
//  ShowUserDetailViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/20.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ShowUserDetailViewController: UIViewController {
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var dataTypeTextView: UITextView!
    @IBOutlet weak var dataContentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var receivedIndexPathInTableView: Int? = nil
    var receivedUUID: String? = nil
    var receivedPassword: String? = nil
    var userInfoArrayKey: [String] = []
    var userInfoArrayValue: [String] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        userIconImageView.layer.cornerRadius = userIconImageView.frame.size.height / 2
        userIconImageView.layer.masksToBounds = true
        userIconImageView.layer.borderWidth = 2
        
        testLabel.text = "\(receivedIndexPathInTableView!)"

        let accountDatabase = AccountDatabase()
        let data = accountDatabase.loadSingleUserFullData(UUID: receivedUUID!, password: receivedPassword!)
        
        userInfoArrayKey = data.userInfo.keys
        userInfoArrayValue = data.userInfo.values
        
        userIconImageView.image = UIImage(data:data.pictureData as Data, scale:1.0)
        
        print(data.userInfo)
    }
}

// MARK: - TableView
extension ShowUserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShowUserDetailTableViewCell
        
        cell.titleLabel.text = userInfoArrayKey[indexPath.row]
        cell.dataLabel.text = userInfoArrayValue[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 66
        } else {
        return 44
        }
    }
}
