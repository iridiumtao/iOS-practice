
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
    private struct UsersInAccountTable {
        var UUID: String
        var account: String
    }
    
    let realm = try! Realm()
    private var usersInAccountTable: [UsersInAccountTable]? = nil

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



    ///
    /// 為了使用UUID來回傳database並優化效能
    /// 使用struct存資料，並透過tuple回傳
    ///
    /// 新的 tableView loadData操作流程：
    /// 1. tableView cellForRowAt 丟出 indexPath
    /// 2. 呼叫 loadData() ，
    /// 給予 indexPath 及 sort 來透過排序方法取得資料，
    /// 並透過檢查確認 userData 存在與否。
    /// 不存在 -> 從資料庫存資料到 userData 中。
    /// 3. 透過 userData(indexPath) 回傳單筆資料給tableView
    ///
    /// - Parameters:
    ///     - userIndexInTableView: TableView 中的 indexPath
    mutating func loadData(indexPath userIndexInTableView: Int) -> (UUID: String, account: String) {
        if usersInAccountTable == nil {
            loadDataFromDatabase()

            print("Local data not found. Getting data from database")
            return loadData(indexPath: userIndexInTableView)
        } else {

            let data: (UUID: String, account: String) = (usersInAccountTable![userIndexInTableView].UUID, usersInAccountTable![userIndexInTableView].account)
            return data
        }
    }

    mutating func loadDataFromDatabase() {
        usersInAccountTable = []
        let usersFromDatebase = realm.objects(RLM_UserAccount.self).sorted(byKeyPath: "account", ascending: true)
        for user in usersFromDatebase {
            usersInAccountTable?.append(UsersInAccountTable(UUID: user.uuid, account: user.account))
        }
    }

    mutating func clearLocalUserData() {
        usersInAccountTable = nil
    }
    
    func loadSingleUserFullData(UUID: String, password:String) ->
        (uuid: String,
        createDate: Date,
        account: String,
        password: String,
        name: String,
        birthday: String,
        email: String,
        phoneNumber: String,
        nationalID: String,
        pictureData: NSData) {
        let user = realm.objects(RLM_UserAccount.self).filter("uuid  CONTAINS '\(UUID)'").first
        var data: (uuid: String,
                   createDate: Date,
                   account: String,
                   password: String,
                   name: String,
                   birthday: String,
                   email: String,
                   phoneNumber: String,
                   nationalID: String,
                   pictureData: NSData)
        data = (user!.uuid,
                user!.createDate,
                user!.account,
                user!.password,
                user!.name,
                user!.birthday,
                user!.email,
                user!.phoneNumber,
                user!.nationalID,
                user!.pictureData)
        return data
    }


    /// 取得資料數量
    func getUserCount() -> Int {
        let users = realm.objects(RLM_UserAccount.self)
        return users.count
    }

    /// 刪除資料
    func deleteData(indexPath userIndexInTableView: Int) {

        let users = realm.objects(RLM_UserAccount.self).sorted(byKeyPath: "account", ascending: true)
        let uuid = users[userIndexInTableView].uuid
        let user = realm.objects(RLM_UserAccount.self).filter("uuid = %@", uuid)
        try! realm.write {
            realm.delete(user)
        }
    }

    /// 編輯資料
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
        return usersInAccountTable![userIndexInTableView].UUID
    }

    /// 搜尋
    func searchData(_ searchText: String) -> [(UUID:String, account: String)] {
        var searchResults: [(UUID:String, account: String)] = []

        let results =  realm.objects(RLM_UserAccount.self).filter("account CONTAINS[c] '\(searchText)'").sorted(byKeyPath: "account", ascending: true)
        for result in results {
            searchResults.append((result.uuid, result.account))
        }

        return searchResults
    }
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


