//
//  LoginViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/15.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nationalIDTextField: UITextField!
    
    @IBOutlet weak var accountHintLabel: UILabel!
    @IBOutlet weak var passwordHintLabel: UILabel!
    @IBOutlet weak var emailHintLabel: UILabel!
    @IBOutlet weak var phoneNumberHintLabel: UILabel!
    @IBOutlet weak var nationalIDHintLabel: UILabel!
    
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    let fullScreenSize = UIScreen.main.bounds.size


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextFields()
        
    }
    
    func initializeTextFields() {
        accountTextField.placeholder = "帳號"
        passwordTextField.placeholder = "密碼"
        nameTextField.placeholder = "名字"
        birthdayTextField.placeholder = "生日"
        emailTextField.placeholder = "Email"
        phoneNumberTextField.placeholder = "手機號碼"
        nationalIDTextField.placeholder = "身分證字號"
    }
    

    @IBAction func clearAllButtonClicked(_ sender: Any) {
        accountTextField.text = ""
        passwordTextField.text = ""
        nameTextField.text = ""
        birthdayTextField.text = ""
        emailTextField.text = ""
        phoneNumberTextField.text = ""
        nationalIDTextField.text = ""
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        var errorMessenge = ""
        if !regexMatch(accountTextField.text!, "[A-Za-z0-9]{4,10}") {
            errorMessenge += "帳號只能輸入字母、數字，最少4個，最多10個字\n"
        }
        if !regexMatch(passwordTextField.text!, "[A-Z]\\w{4,9}") {
            errorMessenge += "密碼首字母為大寫，最少5個字，最多10個字\n"
        }
        if nameTextField.text == "" {
            errorMessenge += "名字不能為空白\n"
        }
        if !regexMatch(emailTextField.text!, "\\w+@\\w+") {
            errorMessenge += "Email無效\n"
        }
        if !regexMatch(phoneNumberTextField.text!, "09[0-9]{8}") {
            errorMessenge += "手機號碼無效\n"
        }
        if !checkID(nationalIDTextField.text!) {
            errorMessenge += "身分證字號無效\n"
        }
        
        if errorMessenge == "" {
            
            print("成功確認")
        } else {
            print(errorMessenge)
        }
        
    }
    
    func regexMatch(_ validateString:String, _ regex:String) -> Bool {
        if validateString == "" {
            return false
        }
        let regexResult = regularExpression(validateString: validateString, regex: regex)
        return (regexResult == validateString)
    }
    
    /// 正則匹配
    ///
    /// - Parameters:
    ///   - regex: 匹配規則
    ///   - validateString: 匹配對test象
    /// - Returns: 返回結果
    func regularExpression(validateString:String, regex:String) -> String{
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
            let matches = regex.matches(in: validateString, options: [], range: NSMakeRange(0, validateString.count))
            var data:String = ""
            for item in matches {
                let string = (validateString as NSString).substring(with: item.range)
                data += string
            }
            return data
        }
        catch {
            print("哭啊")
            return ""
        }
    }
    //A 台北市 J 新竹縣 S 高雄縣
    //B 台中市 K 苗栗縣 T 屏東縣
    //C 基隆市 L 台中縣 U 花蓮縣
    //D 台南市 M 南投縣 V 台東縣
    //E 高雄市 N 彰化縣 W 金門縣
    //F 台北縣 O 新竹市 X 澎湖縣
    //G 宜蘭縣 P 雲林縣 Y 陽明山
    //H 桃園縣 Q 嘉義縣 Z 連江縣
    //I 嘉義市 R 台南縣
    func checkID(_ source: String) -> Bool {
        
        /// 轉成小寫字母
        let lowercaseSource = source.lowercased()
        
        /// 檢查格式，是否符合 開頭是英文字母＋後面9個數字
        func validateFormat(str: String) -> Bool {
            let regex: String = "^[a-z]{1}[1-2]{1}[0-9]{8}$"
            let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
            return predicate.evaluate(with: str)
        }
        
        if validateFormat(str: lowercaseSource) {
            
            /// 判斷是不是真的，規則在這邊(http://web.htps.tn.edu.tw/cen/other/files/pp/)
            var cityAlphabets: [String: Int] =
                ["a":10,"b":11,"c":12,"d":13,"e":14,"f":15,"g":16,"h":17,"i":34,"j":18,
                 "k":19,"l":20,"m":21,"n":22,"o":35,"p":23,"q":24,"r":25,"s":26,"t":27,
                 "u":28,"v":29,"w":30,"x":31,"y":32,"z":33]

            /// 把 [Character] 轉換成 [Int] 型態
            var ints = lowercaseSource.compactMap{ Int(String($0)) }

            /// 拿取身分證第一位英文字母所對應當前城市的
            guard let key = lowercaseSource.first,
                let cityNumber = cityAlphabets[String(key)] else {
                return false
            }
     
            /// 經過公式計算出來的總和
            let firstNumberConvert = (cityNumber / 10) + ((cityNumber % 10) * 9)
            let section1 = (ints[0] * 8) + (ints[1] * 7) + (ints[2] * 6)
            let section2 = (ints[3] * 5) + (ints[4] * 4) + (ints[5] * 3)
            let section3 = (ints[6] * 2) + (ints[7] * 1) + (ints[8] * 1)
            let total = firstNumberConvert + section1 + section2 + section3

            /// 總和如果除以10是正確的那就是真的
            if total % 10 == 0 { return true }
        }
        
        return false
    }
    

}
