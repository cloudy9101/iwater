//
//  LandingViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/12.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signin(_ sender: Any) {
        let username = usernameInput.text
        let password = passwordInput.text
        
        performSegue(withIdentifier: "login", sender: nil)
        Utils.shared.get_access_token(username: username!, password: password!)
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
