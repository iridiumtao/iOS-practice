//
//  SliderBarViewController.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/2.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class SliderBarViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("過來了啦 齁")
        sliderBar.maximumValue = 20
        sliderBar.minimumValue = 0
        sliderBar.value = 20
        progressView.progress = 1
        
    }
    
    // sliderbar 數值改變時 依據sliderbar的值生成相應數量的隨機文字
    @IBAction func sliderBarValueChanged(_ sender: Any) {
        var randomText = ""
        for _ in 0...Int(sliderBar.value) {
            randomText += "\(Character(UnicodeScalar(Int.random(in: 65...122))!))"
        }
        label.text = "Sliderbar \(randomText)"
        
        // 改變 progressView 的值
        progressView.progress = (sliderBar.value / sliderBar.maximumValue)
    }
    
    


}
