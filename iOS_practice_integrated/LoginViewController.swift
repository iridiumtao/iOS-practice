//
//  LoginViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/15.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController {
    let fullScreenSize = UIScreen.main.bounds.size


    @IBOutlet weak var textFirld: MDCFilledTextField!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        let textField = MDCFilledTextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        textField.label.text = "Phone number"
        textField.placeholder = "555-555-5555"
        textField.leadingAssistiveLabel.text = "This is helper text"
        textField.sizeToFit()
        self.view.addSubview(textField)
        
        
        textFirld.label.text = "測試"
        textFirld.placeholder = "555-555-5555"
        textFirld.leadingAssistiveLabel.text = "This is helper text"
        textFirld.sizeToFit()
        
        let textField2 = MDCOutlinedTextField(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
        textField2.label.text = "第二個測試"
        textField2.placeholder = "55ee555"
        textField2.leadingAssistiveLabel.text = "This ie安安text"
        textField2.sizeToFit()
        view.addSubview(textField2)
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
