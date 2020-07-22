//
//  UserAccountTableViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/20.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UIViewController, UISearchBarDelegate {

    var filteredPracticePages: [String] = []
    var isSearchMode = false
    var searchText: String = ""
    var filteredUserData: [(UUID:String, account: String)] = []
    var selectedIndexPath: Int? = nil
    
    var accountDatabase = AccountDatabase()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 (取代右鍵拖曳 delegate 及 dataSource 的方法)
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.placeholder = "搜尋使用者"
        
        // 更改 Navigation bar 的 title
        self.title = "使用者資料列表"
    }
    
    // 搜尋列 文字改變
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.searchTextField.text != "" {
            filteredUserData = accountDatabase.searchData(searchText)
            self.searchText = searchText
        }
        
        // 更新表格
        tableView.reloadData()
    }
    
    // 按下鍵盤上的「搜尋」後收起鍵盤
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
    }
    
    // 捲動 tableView 時收起鍵盤
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    

    func reloadDataForTableViewAndLocalData() {
        print("Called: reloadDataForTableViewAndLocalData()")
        accountDatabase.clearLocalUserData()
        tableView.reloadData()
    }

}

// MARK: -  tableView
extension UserAccountTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.searchTextField.text == "" {
            return accountDatabase.getUserCount()
        } else {
            return filteredUserData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let text: String
        if searchBar.searchTextField.text == "" {

            let userData = accountDatabase.loadData(indexPath: indexPath.row)
            
            text = "\(userData.account)"
        
        } else {
            text = "\(filteredUserData[indexPath.row].account)"
        }
        cell.textLabel?.text = text
        
        //todo 把readResult的東西弄到這裡面
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        self.performSegue(withIdentifier: "ShowUserDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowUserDetailSegue" {

            let showUserDetailVC = segue.destination as! ShowUserDetailViewController

            showUserDetailVC.receivedIndexPathInTableView = selectedIndexPath
            showUserDetailVC.receivedUUID = accountDatabase.getUUID(indexPath: selectedIndexPath!)
            showUserDetailVC.receivedPassword = "test"

        }
    }
}

