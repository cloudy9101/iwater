//
//  SignupViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/14.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signup(_ sender: Any) {
        let email = emailInput.text!
        let password = passwordInput.text!
        let username = usernameInput.text!
        let age = ageInput.text!
        
        self.performSegue(withIdentifier: "signupin", sender: nil)
        Utils.shared.signup(email, password, username, age)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
