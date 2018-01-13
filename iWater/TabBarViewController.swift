//
//  TabBarViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/13.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUser()
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
        let persistentController = NSPersistentContainer(name: "UserToken")
        persistentController.loadPersistentStores(completionHandler: {(description, error) in
            let context = persistentController.viewContext

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTokens")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                let data = result.last as! NSManagedObject?
                if data == nil {
                    self.popLandingView()
                } else {
                    let createdAt = data!.value(forKey: "created_at") as! Int
                    let expiresIn = data!.value(forKey: "expires_in") as! Int
                    if Date(timeIntervalSince1970: TimeInterval(createdAt + expiresIn)) < Date() {
                        self.refreshToken(data!.value(forKey: "refresh_token") as! String, context: context)
                    } else {
                        let accessToken = data!.value(forKey: "access_token") as! String
                        User(accessToken, completion: { (user) in
                            self.appDelegate.user = user
                            self.initUser()
                        })
                    }
                }
            } catch {
                print("Failed")
            }
        })
    }
    
    func refreshToken(_ token: String, context: NSManagedObjectContext) {
        let url = Utils.apiHost + "/oauth/token"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTokens")
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        }
        
        Utils.shared.postData(url: url, params: ["grant_type": "refresh_token", "refresh_token": token], success: { (result) in
            do {
                let authData = try JSONDecoder().decode(UserAccessToken.self, from: result)
                
                let entity = NSEntityDescription.entity(forEntityName: "UserTokens", in: context)
                let newAuth = NSManagedObject(entity: entity!, insertInto: context)
                newAuth.setValuesForKeys(authData.dictionary)
                let accessToken = authData.access_token
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
                User(accessToken, completion: { (user) in
                    self.appDelegate.user = user
                    self.initUser()
                })
            } catch let jsonError {
                print(jsonError)
            }
        }, failure: {(error) in
            print(error)
        })
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
