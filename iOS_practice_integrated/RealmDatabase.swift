//
//  RealmDatabase.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/7.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmDatabase {
    private struct UserData {
        var UUID: String
        var name: String
        var age: Int
        var address: String
    }
    
    let realm = try! Realm()
    private var userData: [UserData]? = nil

    func writeData(_ name: String,_ age: Int, _ address: String) {
        print(name+"  \(age)  "+address)
        let user = RLM_User()
        user.name = name
        user.age = age
        user.address = address
        
        try! realm.write {
            realm.add(user)
        }
        print("\(realm.configuration.fileURL!)")
    }

    // MARK: 舊的，之後要棄用
    // 逐一取得資料
    func getData(indexPath userIndexInTableView:Int, sort:String, dataType:String) -> String{
        
        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
        switch dataType {
        case "name":
            return users[userIndexInTableView].name
        case "age":
            return "\(users[userIndexInTableView].age)"
        case "address":
            return users[userIndexInTableView].address
        default:
            return "Error dataType"
        }
    }
    
    
    // MARK: 舊的，之後要棄用
    // 全部取得資料
    func getData(indexPath userIndexInTableView: Int, sort: String) -> String{
        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
        
        let returnText = """
        \(users[userIndexInTableView].name)
        \(users[userIndexInTableView].age)
        \(users[userIndexInTableView].address)
        """
        return returnText
    }
    
    /*
     為了使用UUID來回傳database並優化效能
     使用struct存資料，並透過tuple回傳
     
     新的 tableView loadData操作流程：
     1. tableView cellForRowAt 丟出 indexPath
     2. 呼叫 loadData() ，給予 indexPath 及 sort 來透過排序方法取得資料，並透過檢查確認 userData 存在與否。不存在 -> 從資料庫存資料到 userData 中。
     3. 透過 userData(indexPath) 回傳單筆資料給tableView
     */
    mutating func loadData(indexPath userIndexInTableView: Int, sort: String) -> (UUID: String, name: String, age: Int, address: String) {
        if userData == nil {
            loadDataFromDatabase(sort: sort)
            
            print("Local data not found. Getting data from database")
            return loadData(indexPath: userIndexInTableView, sort: sort)
        } else {
            
            let data: (UUID: String, name: String, age: Int, address: String) = (userData![userIndexInTableView].UUID, userData![userIndexInTableView].name, userData![userIndexInTableView].age, userData![userIndexInTableView].address)
            return data
        }
    }
    
    mutating func loadDataFromDatabase(sort: String) {
        userData = []
        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
        for user in users {
            userData!.append(UserData(UUID: user.uuid, name: user.name, age: user.age, address: user.address))
        }
    }
    
    mutating func clearLocalUserData() {
        userData = nil
    }
    
   
    

    
    // 取得資料數量
    func getUserCount() -> Int {
        let users = realm.objects(RLM_User.self)
        return users.count
    }
    
    // 刪除資料
    func deleteData(indexPath userIndexInTableView: Int, sort: String) {
        
        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
        let uuid = users[userIndexInTableView].uuid
        let user = realm.objects(RLM_User.self).filter("uuid = %@", uuid)
        try! realm.write {
            realm.delete(user)
        }
    }
    
    // MARK: 舊的
    // 編輯資料
    func updateData(indexPath userIndexInTableView:Int, sort: String, _ name: String, _ age: Int, _ address: String) {

        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
        let uuid = users[userIndexInTableView].uuid
        let user = RLM_User()
        user.uuid = uuid
        user.name = name
        user.age = age
        user.address = address
        try! realm.write {
            realm.add(user, update: .all)
        }
    }
    
    func updateData(UUID: String, _ name: String, _ age: Int, _ address: String) {
        let user = RLM_User()
        user.uuid = UUID
        user.name = name
        user.age = age
        user.address = address
        try! realm.write {
            realm.add(user, update: .modified)
        }
    }
    
    func getUUID(indexPath userIndexInTableView:Int) -> String {
        return userData![userIndexInTableView].UUID
    }
    
    // 搜尋
    // todo 用 realm 的搜尋 把搜尋的結果存成陣列的tuple型態回傳至ViewController
    // 像這樣：let myInfo = [("Kevin Chang", 25, 178.25), ("Kevin", 22, 179.25)]

    func searchData(_ searchText: String, sort: String) -> [(UUID:String, name: String, age: Int, address: String)] {
        var searchResults: [(UUID:String, name: String, age: Int, address: String)] = []
        
        let results: Results<RLM_User>
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: searchText)) {
            results =  realm.objects(RLM_User.self).filter(String(format: "name CONTAINS[c] '%@' || age == %d || address CONTAINS[c] '%@'",searchText, Int(searchText)!, searchText)).sorted(byKeyPath: sort, ascending: true)
        } else {
            results = realm.objects(RLM_User.self).filter(String(format: "name CONTAINS[c] '%@' || address CONTAINS[c] '%@'", searchText, searchText)).sorted(byKeyPath: sort, ascending: true)
        }
        for result in results {
            searchResults.append((result.uuid, result.name, result.age, result.address))
        }

        return searchResults
    }
}

// 初始化 realm 資料庫
// MARK: 如果要修改 需要刪除模擬器的App以重建
class RLM_User : Object {

    // 自動產生UUID
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var address: String = ""
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
}

