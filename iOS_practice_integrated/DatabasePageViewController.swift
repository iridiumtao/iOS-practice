//
//  DatabasePageViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/7.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class DatabasePageViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var changeSortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let userDataType = ["name", "age", "address"]
    var sort = "name"
    var isUpdateButtonUpdateMode = false
    var isSearchMode = false
    var editingIndex: Int? = nil
    var editingDataUUID: String? = nil
    var searchText: String = ""
    var filteredUserData: [(UUID:String, name: String, age: Int, address: String)] = []
    
    var realmDatabase = RealmDatabase()
    
    var timeStart:CFAbsoluteTime = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.searchBar.delegate = self
        
        updateButton.isEnabled = false
        
        updateButton.setTitle("Add", for: .normal)
        //pickerView.isHidden = true
        pickerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
    }
    
    
    // 新增 & 更新的按鈕
    @IBAction func buttonClicked(_ sender: Any) {
        let name = (nameTextField.text != "") ? nameTextField.text! : "blank"
        let age:Int = Int(ageTextField.text ?? "0") ?? 0
        let address = (addressTextField.text != "") ? addressTextField.text! : "blank"
        
        if !isUpdateButtonUpdateMode {
            realmDatabase.writeData(name, age, address)
        } else {
            if editingDataUUID != nil {
                //realmDatabase.updateData(indexPath: editingIndex!, sort: sort, name, age, address)
                realmDatabase.updateData(UUID: editingDataUUID!, name, age, address)
                filteredUserData = realmDatabase.searchData(searchText, sort: sort)
                updateButton.setTitle("Add", for: .normal)
                isUpdateButtonUpdateMode = false
            } else {
                print("ERROR: editedIndex = nil when editButton clicked")
            }
            changeSortButton.isEnabled = true

        }
        updateButton.isEnabled = false
        
        reloadDataForTableViewAndLocalData()
        
        // 按下按鈕後 textField 的閃爍那條可以被復原(收起鍵盤)
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        
        nameTextField.text = ""
        ageTextField.text = ""
        addressTextField.text = ""
    }
    
    
    
    // 更改排序的按鈕
    @IBAction func changeSortButtonClicked(_ sender: Any) {
        let thePicker = UIPickerView()
        thePicker.delegate = self
        //pickerView.isHidden = false
        changeSortButton.isEnabled = false
        
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            self.pickerView.frame = self.pickerView.frame.offsetBy(dx: 0, dy: -200)
        })
    }
    
    // PickerView 相關
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // 搜尋列 文字改變
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.searchTextField.text != "" {
            filteredUserData = realmDatabase.searchData(searchText, sort: sort)
            self.searchText = searchText
        }
        
        //let timeStart = CFAbsoluteTimeGetCurrent()
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
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldsTextChanged(_ sender: Any) {
        if (nameTextField.text != "" && ageTextField.text != "" && addressTextField.text != "") {
            updateButton.isEnabled = true
        } else {
            updateButton.isEnabled = false
        }
    }
    
    func reloadDataForTableViewAndLocalData() {
        print("Called: reloadDataForTableViewAndLocalData()")
        realmDatabase.clearLocalUserData()
        tableView.reloadData()
    }
}

// MARK: -  tableView
extension DatabasePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.searchTextField.text == "" {
            return realmDatabase.getUserCount()
        } else {
            return filteredUserData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let text: String
        if searchBar.searchTextField.text == "" {

            //let userData = realmDatabase.getData(indexPath: indexPath.row, sort: sort)
            // text = userData
            let userData = realmDatabase.loadData(indexPath: indexPath.row, sort: sort)
            
            text = """
            \(userData.name)
            \(userData.age)
            \(userData.address)
            """
        
        } else {
            text = """
            \(filteredUserData[indexPath.row].name)
            \(filteredUserData[indexPath.row].age)
            \(filteredUserData[indexPath.row].address)
            """
        }
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 3
        
        //todo 把readResult的東西弄到這裡面
        return cell
    }
    
    /**
     * 實作TableView方法，自動出現左滑功能  編輯 ＆ 刪除
    **/
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 刪除
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.realmDatabase.deleteData(indexPath: indexPath.row, sort: self.sort)
            self.reloadDataForTableViewAndLocalData()
        }
        // 編輯
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.updateButton.setTitle("Save", for: .normal)
            
            self.isUpdateButtonUpdateMode = true
            
            let dataOfTheRow: (UUID: String, name: String, age: Int, address: String)
            if self.searchBar.searchTextField.text == "" {
                
                dataOfTheRow = self.realmDatabase.loadData(indexPath: indexPath.row, sort: self.sort)
            } else {
                
                dataOfTheRow =
                    self.filteredUserData[indexPath.row]
            }
            
            self.editingDataUUID = dataOfTheRow.UUID
            self.nameTextField.text = dataOfTheRow.name
            self.ageTextField.text = "\(dataOfTheRow.age)"
            self.addressTextField.text = dataOfTheRow.address
            
            //self.changeSortButton.isEnabled = false
            self.updateButton.isEnabled = true
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        return swipeActions
    }
}

// MARK: - PickerView
extension DatabasePageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userDataType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userDataType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 叫realm更改排序方式
        sort = userDataType[row]
        if self.searchBar.searchTextField.text == "" {
            reloadDataForTableViewAndLocalData()
        } else {
            filteredUserData = realmDatabase.searchData(searchText, sort: sort)
            tableView.reloadData()
        }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            self.pickerView.frame = self.pickerView.frame.offsetBy(dx: 0, dy: 200)
        })
        //pickerView.isHidden = true
        changeSortButton.isEnabled = true
    }
}
