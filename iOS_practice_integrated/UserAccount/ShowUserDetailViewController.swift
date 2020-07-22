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
    
    var receivedIndexPathInTableView: Int? = nil
    var receivedUUID: String? = nil
    var receivedPassword: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        

        userIconImageView.layer.cornerRadius = userIconImageView.frame.size.height / 2
        userIconImageView.layer.masksToBounds = true
        userIconImageView.layer.borderWidth = 2
        
        testLabel.text = "\(receivedIndexPathInTableView!)"

        
        dataTypeTextView.text = """
        UUID:
        
        Create Date:
        
        Account:
        Password:
        Name:
        Birthday:
        Email:
        Phone Number:
        National ID:
        """
        
        let accountDatabase = AccountDatabase()
        let data = accountDatabase.loadSingleUserFullData(UUID: receivedUUID!, password: receivedPassword!)
        dataContentTextView.text = """
        \(data.uuid)
        \(data.createDate)
        \(data.account)
        \(data.password)
        \(data.name)
        \(data.birthday)
        \(data.email)
        \(data.phoneNumber)
        \(data.nationalID)
        """
        
        userIconImageView.image = UIImage(data:data.pictureData as Data, scale:1.0)
    }
    



}
