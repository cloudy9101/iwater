//
//  user.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

class User {
    var userMode: UserMode?
    var currentVolumeNumber: Int!
    
    init(_ token: String, completion: @escaping (_ user: User) -> ()) {
        let urlString = "http://localhost:4000/user.json"
        Utils.shared.getData(url: urlString, params: ["access_token": token], success: {(data) in
            do {
                let userData = try JSONDecoder().decode(UserMode.self, from: data)
                
                DispatchQueue.main.async {
                    self.userMode = userData
                    self.currentVolumeNumber = userData.currentVolumeNumber
                    completion(self)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }, failure: {(error) in
            print(error)
        })
    }
    
    init() {
        self.userMode = UserMode(email: "iwater@iwater.com",
                                 mobile: nil,
                                 name: "iWater",
                                 bio: nil,
                                 gender: 0,
                                 age: 0,
                                 currentVolumeNumber: 0,
                                 avatar: nil,
                                 targetVolumeNumber: 3000)
        self.currentVolumeNumber = userMode?.currentVolumeNumber!
    }
    
    func incrCurrentVolumeNumber(volume: Int) {
        self.currentVolumeNumber = self.currentVolumeNumber + volume
        syncData()
    }
    
    func syncData() {
        // TODO
    }
}
