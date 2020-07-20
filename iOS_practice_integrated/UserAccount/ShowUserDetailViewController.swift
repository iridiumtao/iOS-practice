//
//  ShowUserDetailViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/20.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ShowUserDetailViewController: UIViewController {
    
    var receivedIndexPathInTableView: Int? = nil

    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "\(receivedIndexPathInTableView!)"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
