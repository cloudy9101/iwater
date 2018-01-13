//
//  TabBarViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/13.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUser()
        if appDelegate.user == nil {
            self.popLandingView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popLandingView() {
        let landingViewController = storyboard?.instantiateViewController(withIdentifier: "landingView") as! LandingViewController
        landingViewController.tabBarViewController = self
        self.view.insertSubview(landingViewController.view, at: 99)
        present(landingViewController, animated: true)
    }
    
    func setUser() {
        
    }
    
    func initUser() {
        var indexViewController: IndexViewController?
        for i in self.childViewControllers {
            if i is IndexViewController {
                indexViewController = i as? IndexViewController
            }
        }
        indexViewController!.initUser()
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
