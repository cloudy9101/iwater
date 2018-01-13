//
//  LandingViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/12.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit
import CoreData

class LandingViewController: UIViewController {
    var indexViewController: IndexViewController!
    var tabBarViewController: TabBarViewController!
    var user: User?
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
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
        get_access_token({(token) in
            self.user = User(token) { user in
                self.appDelegate.user = user
                self.view.removeFromSuperview()
                self.tabBarViewController.initUser()
            }
        })
    }

    func get_access_token(_ completion: @escaping (_ token: String) -> ()) {
        let url = "http://localhost:4000/oauth/token"
        let username = usernameInput.text
        let password = passwordInput.text
        let grantType = "password"
        Utils.shared.postData(url: url,
                              params: ["username": username ?? "", "password": password ?? "", "grant_type": grantType],
                              success: {(result) in
                                do {
                                    let authData = try JSONDecoder().decode(UserAccessToken.self, from: result)
                                    completion(authData.access_token)

                                    let persistentController = NSPersistentContainer(name: "UserToken")
                                    persistentController.loadPersistentStores(completionHandler: {(description, error) in
                                        let context = persistentController.viewContext
                                        let entity = NSEntityDescription.entity(forEntityName: "UserTokens", in: context)
                                        let newAuth = NSManagedObject(entity: entity!, insertInto: context)
                                        newAuth.setValuesForKeys(authData.dictionary)
                                        
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Failed saving")
                                        }
                                    })
                                    
                                } catch let jsonError {
                                    print(jsonError)
                                }
        }, failure: {(error) in
            print(error)
        })
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
