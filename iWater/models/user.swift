//
//  user.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var date: Date
    var currentVolumeNumber: Int
    var targetVolumeNumber: Int
    
    var name: String
    var gender: String
    var age: Int
    var avatar: String
    
    init(id: Int, date: Date) {
        self.id = id
        self.date = date
        self.currentVolumeNumber = 1000
        self.targetVolumeNumber = 4000
        
        self.name = "查派"
        self.gender = "male"
        self.age = 25
        self.avatar = "https://l.ruby-china.org/user/avatar/10344.jpg"
    }
    
    func incrCurrentVolumeNumber(volume: Int) {
        self.currentVolumeNumber = self.currentVolumeNumber + volume
        syncData()
    }
    
    func syncData() {
        // TODO
    }
}
