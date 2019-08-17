//
//  SettingsController.swift
//  iWater
//
//  Created by cloudy on 2018/5/27.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var targetVolume: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var alertStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerObservers()
        Utils.shared.get_user()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(renderUser), name: NSNotification.Name(rawValue: "GetUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginIn), name: NSNotification.Name(rawValue: "NoUser"), object: nil)
    }
    
    @objc func renderUser(n: Notification) {
        let user = n.object as! User
        let userMode = user.userMode
        setAvatar(user)
        if userMode != nil {
            nickname.text = userMode!.name
            email.text = userMode!.email
            targetVolume.text = String(userMode!.targetVolumeNumber!)
            age.text = String(userMode!.age)
            bio.text = userMode!.bio
        }
    }
    
    func setAvatar(_ user: User) {
        let avatar = user.userMode?.avatar
        if avatar == nil {
            self.avatarImage.image = UIImage(contentsOfFile: "default_avatar")
        } else {
            Utils.shared.getDataFromUrl(url: URL(string: user.userMode!.avatar!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.avatarImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    @objc func loginIn(n: Notification) {
        performSegue(withIdentifier: "loginFromSettings", sender: self)
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
