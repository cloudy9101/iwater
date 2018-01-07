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
        pointSize = zeroVolume.frame.origin.y - targetVolume.frame.origin.y
        
        setUser()
        setUserInfo()
        setTargetVolume()
        setCurrentVolume()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IndexViewController.hiddenDrinkView(gestureRecognize:)))
        tapGesture.delegate = self
        drinkView.addGestureRecognizer(tapGesture)
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
        currentVolume.frame.origin.y = targetVolume.frame.origin.y + CGFloat(CGFloat(user!.targetVolumeNumber - user!.currentVolumeNumber) * pointSize! / CGFloat(user!.targetVolumeNumber))
        currentVolume.text = String(user!.currentVolumeNumber) + " ML"
    }
    
    func riseCurrentVolume(_ gap: Int) {
        if user!.currentVolumeNumber >= user!.targetVolumeNumber {
            return
        }
        currentVolume.frame = CGRect(x: currentVolume.frame.origin.x, y: currentVolume.frame.origin.y - CGFloat(CGFloat(gap) * pointSize! / CGFloat(user!.targetVolumeNumber)), width: currentVolume.frame.width, height: currentVolume.frame.height)
    }
    
    func setUser() {
        user = User(id: 1, date: Date())
    }
    
    func setUserInfo() {
        name.text = user!.name
        age.text = String(user!.age)
        setAvatar()
    }
    
    func setAvatar() {
        getDataFromUrl(url: URL(string: user!.avatar)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.avatar.image = UIImage(data: data)
            }
        }
    }
    
    func setTargetVolume() {
        targetVolume.text = String(user!.targetVolumeNumber) + " ML"
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drinkCustomSugue" {
            let controller = segue.destination as? DrinkCustomViewController
            controller!.indexViewController = self
        }
    }
}

