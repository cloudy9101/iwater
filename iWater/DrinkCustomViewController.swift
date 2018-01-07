//
//  DrinkCustomViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class DrinkCustomViewController: UIViewController {

    @IBOutlet weak var gapInput: UITextField!
    var indexViewController: IndexViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func drinkConfirm(_ sender: Any) {
        var gapInt: Int?
        let gapText = gapInput.text
        if gapText != nil {
            gapInt = Int(gapText!)
        }
        if gapInt != nil {
            indexViewController!.drink(gapInt!)
        }
        self.dismiss(animated: true, completion: {() -> Void in
            self.indexViewController!.drinkView.isHidden = true
            }
        )
    }
}
