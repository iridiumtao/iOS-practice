
//
//  AccountDatabase.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/16.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

struct AccountDatabase {
    private struct Users {
        var UUID: String
        var createDate: Date
        
        var account: String
        var password: String
        var name: String
        var birthday: String
        var email: String
        var phoneNumber: String
        var nationalID: String
        var pictureData: NSData
    }
    
    let realm = try! Realm()
    private var users: [Users]? = nil

    func writeData(account: String,
                   password: String,
                   name: String,
                   birthday: String,
                   email: String,
                   phoneNumber: String,
                   nationalID: String,
                   pictureData: NSData) {
        
        let user = RLM_UserAccount()
        user.account = account
        user.password = password
        user.name = name
        user.birthday = birthday
        user.email = email
        user.phoneNumber = phoneNumber
        user.nationalID = nationalID
        user.pictureData = pictureData

        try! realm.write {
            realm.add(user)
        }
        print(user)
        print("\(realm.configuration.fileURL!)")
    }

//
//
//    /*
//     為了使用UUID來回傳database並優化效能
//     使用struct存資料，並透過tuple回傳
//
//     新的 tableView loadData操作流程：
//     1. tableView cellForRowAt 丟出 indexPath
//     2. 呼叫 loadData() ，給予 indexPath 及 sort 來透過排序方法取得資料，並透過檢查確認 userData 存在與否。不存在 -> 從資料庫存資料到 userData 中。
//     3. 透過 userData(indexPath) 回傳單筆資料給tableView
//     */
//    mutating func loadData(indexPath userIndexInTableView: Int, sort: String) -> (UUID: String, name: String, age: Int, address: String) {
//        if users == nil {
//            loadDataFromDatabase(sort: sort)
//
//            print("Local data not found. Getting data from database")
//            return loadData(indexPath: userIndexInTableView, sort: sort)
//        } else {
//
//            let data: (UUID: String, name: String, age: Int, address: String) = (users![userIndexInTableView].UUID, users![userIndexInTableView].name, users![userIndexInTableView].age, users![userIndexInTableView].address)
//            return data
//        }
//    }
//
//    mutating func loadDataFromDatabase(sort: String) {
//        users = []
//        let usersFromDatebase = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
//        for user in usersFromDatebase {
//            users!.append(Users(UUID: <#T##String#>, createDate: <#T##Date#>, account: <#T##String#>, password: <#T##String#>, name: <#T##String#>, birthday: <#T##String#>, email: <#T##String#>, phoneNumber: <#T##String#>, nationalID: <#T##String#>, age: <#T##Int#>, address: <#T##String#>))
//        }
//    }
//
//    mutating func clearLocalUserData() {
//        users = nil
//    }
//
//
//
//
//
//    // 取得資料數量
//    func getUserCount() -> Int {
//        let users = realm.objects(RLM_User.self)
//        return users.count
//    }
//
//    // 刪除資料
//    func deleteData(indexPath userIndexInTableView: Int, sort: String) {
//
//        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
//        let uuid = users[userIndexInTableView].uuid
//        let user = realm.objects(RLM_User.self).filter("uuid = %@", uuid)
//        try! realm.write {
//            realm.delete(user)
//        }
//    }
//
//    // MARK: 舊的
//    // 編輯資料
//    func updateData(indexPath userIndexInTableView:Int, sort: String, _ name: String, _ age: Int, _ address: String) {
//
//        let users = realm.objects(RLM_User.self).sorted(byKeyPath: sort, ascending: true)
//        let uuid = users[userIndexInTableView].uuid
//        let user = RLM_User()
//        user.uuid = uuid
//        user.name = name
//        user.age = age
//        user.address = address
//        try! realm.write {
//            realm.add(user, update: .all)
//        }
//    }
//
//    func updateData(UUID: String, _ name: String, _ age: Int, _ address: String) {
//        let user = RLM_User()
//        user.uuid = UUID
//        user.name = name
//        user.age = age
//        user.address = address
//        try! realm.write {
//            realm.add(user, update: .modified)
//        }
//    }
//
//    func getUUID(indexPath userIndexInTableView:Int) -> String {
//        return users![userIndexInTableView].UUID
//    }
//
//    // 搜尋
//    // todo 用 realm 的搜尋 把搜尋的結果存成陣列的tuple型態回傳至ViewController
//    // 像這樣：let myInfo = [("Kevin Chang", 25, 178.25), ("Kevin", 22, 179.25)]
//
//    func searchData(_ searchText: String, sort: String) -> [(UUID:String, name: String, age: Int, address: String)] {
//        var searchResults: [(UUID:String, name: String, age: Int, address: String)] = []
//
//        let results: Results<RLM_User>
//        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: searchText)) {
//            results =  realm.objects(RLM_User.self).filter(String(format: "name CONTAINS[c] '%@' || age == %d || address CONTAINS[c] '%@'",searchText, Int(searchText)!, searchText)).sorted(byKeyPath: sort, ascending: true)
//        } else {
//            results = realm.objects(RLM_User.self).filter(String(format: "name CONTAINS[c] '%@' || address CONTAINS[c] '%@'", searchText, searchText)).sorted(byKeyPath: sort, ascending: true)
//        }
//        for result in results {
//            searchResults.append((result.uuid, result.name, result.age, result.address))
//        }
//
//        return searchResults
//    }
}

class RLM_UserAccount : Object {

    // 自動產生UUID
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var createDate = Date()
    
    @objc dynamic var account: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var nationalID: String = ""
    @objc dynamic var pictureData = NSData()
    
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
}


