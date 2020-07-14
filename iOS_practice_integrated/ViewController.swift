//
//  ViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/2.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    
    var practicePages = ["Slider Bar", "Second Page", "Realm database"]
    var filteredPracticePages: [String] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 (取代右鍵拖曳 delegate 及 dataSource 的方法)
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.placeholder = "搜尋練習的功能"
        
        // 更改 Navigation bar 的 title
        self.title = "Chaos"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("sss")
        self.searchBar.endEditing(true)
    }

    // tableview 的 numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.searchTextField.text != ""{
            return filteredPracticePages.count
         }else{
            return practicePages.count
        }
    }
    
    
    
    // tableview 的 cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
        
            if searchBar.searchTextField.text != "" {
                cell.textLabel?.text = filteredPracticePages[indexPath.row]
            } else {
                cell.textLabel?.text = practicePages[indexPath.row]
            }
            
            return cell
    }
    
    // 按下 tableView cell 的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

        let segueName: String;
        switch indexPath.row {
        case 0:
            segueName = "SliderBarSegue"
            break
        case 1:
            segueName = "SecondPageSegue"
        case 2:
            segueName = "DatabasePageSegue"
        default:
            segueName = "SliderBarSegue"
        }
        performSegue(withIdentifier: segueName, sender: cell)
    }

    
    // 搜尋列 文字改變
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 將搜尋文字與 practicePages 的做比對，並將符合的結果存回 filteredPracticePages
        filteredPracticePages = practicePages.filter{ (name) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
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
}

