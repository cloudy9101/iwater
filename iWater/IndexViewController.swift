//
//  IndexViewController.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UIGestureRecognizerDelegate {

    var user: User?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var targetVolume: UILabel!
    @IBOutlet weak var currentVolume: UILabel!
    @IBOutlet weak var zeroVolume: UILabel!
    var pointSize: CGFloat?
    @IBOutlet weak var drinkBtn: UIButton!
    @IBOutlet weak var drinkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // let delegate = UIApplication.shared.delegate as? AppDelegate
        // delegate?.scheduleNotification(date: Date(timeIntervalSinceNow: 20))
        pointSize = zeroVolume.frame.origin.y - targetVolume.frame.origin.y
        
        initUser()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IndexViewController.hiddenDrinkView(gestureRecognize:)))
        tapGesture.delegate = self
        drinkView.addGestureRecognizer(tapGesture)
    }
    
    func initUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.user = appDelegate.user
        if user == nil {
            setDefaultUser()
        }
        setUserInfo()
        setTargetVolume()
        setCurrentVolume()
    }
    
    func setDefaultUser() {
        self.user = User()
    }
    
    @objc func hiddenDrinkView(gestureRecognize: UIGestureRecognizer) {
        drinkView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drinkClick(_ sender: Any) {
        drinkView.isHidden = false
    }
    
    @IBAction func drinkAShot(_ sender: Any) {
        drink(100)
    }
    
    @IBAction func drinkACup(_ sender: Any) {
        drink(400)
    }
    
    func drink(_ gap: Int) {
        user!.incrCurrentVolumeNumber(volume: gap)
        currentVolume.text = String(user!.currentVolumeNumber) + " ML"
        riseCurrentVolume(gap)
    }
    
    func setCurrentVolume() {
        currentVolume.frame.origin.x = targetVolume.frame.origin.x
        currentVolume.frame.origin.y = targetVolume.frame.origin.y + CGFloat(CGFloat(user!.userMode!.targetVolumeNumber! - user!.currentVolumeNumber) * pointSize! / CGFloat(user!.userMode!.targetVolumeNumber!))
        currentVolume.text = String(user!.currentVolumeNumber) + " ML"
    }
    
    func riseCurrentVolume(_ gap: Int) {
        if user!.currentVolumeNumber >= user!.userMode!.targetVolumeNumber! {
            return
        }
        currentVolume.frame = CGRect(x: currentVolume.frame.origin.x, y: currentVolume.frame.origin.y - CGFloat(CGFloat(gap) * pointSize! / CGFloat(user!.userMode!.targetVolumeNumber!)), width: currentVolume.frame.width, height: currentVolume.frame.height)
    }
    
    func setUserInfo() {
        name.text = user!.userMode!.name
        age.text = String(user!.userMode!.age)
        setAvatar()
    }
    
    func setAvatar() {
        let avatar = user?.userMode?.avatar
        if avatar == nil {
            self.avatar.image = UIImage(contentsOfFile: "default_avatar")
        } else {
            getDataFromUrl(url: URL(string: user!.userMode!.avatar!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.avatar.image = UIImage(data: data)
                }
            }
        }
    }
    
    func setTargetVolume() {
        targetVolume.text = String(describing: user!.userMode!.targetVolumeNumber!) + " ML"
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drinkCustomSegue" {
            let controller = segue.destination as? DrinkCustomViewController
            controller!.indexViewController = self
        }
    }
}

