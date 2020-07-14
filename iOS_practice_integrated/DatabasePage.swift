//
//  DatabasePage.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/7.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit
import RealmSwift

class RLM_User : Object {

    private(set) dynamic var uuid:String = UUID().uuidString //這樣的設置就是自動產生uuid
    dynamic var name:String = ""
    dynamic var age:Int = 0
    dynamic var address:String = ""
    
    //設置索引主鍵
    override static func primaryKey() -> String {
        return "uuid"
    }
    
}

class DatabasePage: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
