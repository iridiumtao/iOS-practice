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
    let realm = try! Realm()
    

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
    
    // 編輯資料
    func updataData(indexPath userIndexInTableView:Int, sort: String, _ name: String, _ age: Int, _ address: String) {

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
    // 搜尋
    // todo 用 realm 的搜尋 把搜尋的結果存成陣列的tuple型態回傳至ViewController
    // 像這樣：let myInfo = [("Kevin Chang", 25, 178.25), ("Kevin", 22, 179.25)]

    func searchData(_ searchText: String) -> [(name: String, age: Int, address: String)] {
        var searchResults: [(name: String, age: Int, address: String)] = []
        let results = realm.objects(RLM_User.self).filter("name CONTAINS '\(searchText)'")
        for result in results {
            searchResults.append((result.name, result.age, result.address))
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

