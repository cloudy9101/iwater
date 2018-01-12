//
//  LandingViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/12.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    var indexViewController: IndexViewController!
    var tabBarViewController: TabBarViewController!
    var user: User?
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signin(_ sender: Any) {
        self.user = User("TOKEN") { user in
            self.appDelegate.user = user
            self.returnToTabBarView()
            self.tabBarViewController.initUser()
        }
    }
    
    func returnToTabBarView() {
        self.view.removeFromSuperview()
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
