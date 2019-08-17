//
//  IndexViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit
import CoreData

class IndexViewController: UIViewController, UIGestureRecognizerDelegate {

    var user: User?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var targetVolume: UILabel!
    @IBOutlet weak var currentVolume: UILabel!
    @IBOutlet weak var zeroVolume: UILabel!
    let pointSize: CGFloat? = 360.0
    @IBOutlet weak var drinkBtn: UIButton!
    @IBOutlet weak var drinkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        registerObservers()
        registerDrinkViewTapRecognizer()
        if appDelegate.initial {
            Utils.shared.get_user()
            appDelegate.initial = false
        }
    }
    
    func registerDrinkViewTapRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hiddenDrinkView))
        drinkView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func hiddenDrinkView(rec: UITapGestureRecognizer) {
        drinkView.isHidden = true
    }
    
    @objc func volumeChanged(n: NSNotification) {
        let user = n.object as! User
        setCurrentVolume(user: user)
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(renderUserOrLogin), name: NSNotification.Name(rawValue: "NoUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(renderUserOrLogin), name: NSNotification.Name(rawValue: "GetUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged), name: NSNotification.Name(rawValue: "volumeChanged"), object: nil)
    }
    
    @objc func renderUserOrLogin(n: NSNotification) {
        let user = n.object as? User
        if(user == nil || n.name.rawValue == "NoUser") {
            performSegue(withIdentifier: "logout", sender: self)
        } else {
            self.user = user
            renderUser()
        }
    }
    
    func renderUser() {
        setUserInfo()
        setCurrentVolume(user: self.user!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func drinkClick(_ sender: Any) {
        drinkView.isHidden = false
    }
    
    @IBAction func drinkAShot(_ sender: Any) {
        user!.drink(100)
    }
    
    @IBAction func drinkACup(_ sender: Any) {
        user!.drink(400)
    }
    
    @IBAction func logout(_ sender: Any) {
        Utils.shared.logout()
    }
    
    func setCurrentVolume(user: User) {
        currentVolume.text = String(user.currentVolumeNumber) + " ML"

        if user.currentVolumeNumber >= user.userMode!.targetVolumeNumber! {
            return
        }
        
        currentVolume.frame.origin.x = targetVolume.frame.origin.x
        currentVolume.frame.origin.y = targetVolume.frame.origin.y + CGFloat(CGFloat(user.userMode!.targetVolumeNumber! - user.currentVolumeNumber) * pointSize! / CGFloat(user.userMode!.targetVolumeNumber!))
    }
    
    func setUserInfo() {
        name.text = user!.userMode!.name
        age.text = String(user!.userMode!.age)
        setAvatar()
        targetVolume.text = String(describing: user!.userMode!.targetVolumeNumber!) + " ML"
    }
    
    func setAvatar() {
        let avatar = user?.userMode?.avatar
        if avatar == nil {
            self.avatar.image = UIImage(contentsOfFile: "default_avatar")
        } else {
            Utils.shared.getDataFromUrl(url: URL(string: user!.userMode!.avatar!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.avatar.image = UIImage(data: data)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drinkCustomSegue" {
            let controller = segue.destination as? DrinkCustomViewController
            controller!.indexViewController = self
        }
    }
}

