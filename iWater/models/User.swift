//
//  user.swift
//  iWater
//
//  Created by cloudy on 2018/1/6.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

class User {
    public var userMode: UserMode?
    var currentVolumeNumber: Int!
    var accessToken: String?
    
    
    init(_ token: String) {
        self.accessToken = token
        Utils.shared.getData(url: Constants.userEndpoint, params: ["access_token": token], success: {(data) in
            do {
                let userData = try JSONDecoder().decode(UserMode.self, from: data)
                
                DispatchQueue.main.async {
                    self.userMode = userData
                    self.currentVolumeNumber = userData.currentVolumeNumber

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetUser"), object: self)
                }
                
            } catch let jsonError {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
                print(jsonError)
            }
        }, failure: {(error) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
            print(error)
        })
    }
    
    func incrCurrentVolumeNumber(volume: Int) {
        self.currentVolumeNumber = self.currentVolumeNumber + volume
        syncData(volume)
    }
    
    func syncData(_ volume: Int) {
        Utils.shared.postData(url: Constants.drinkLogEndpoint, params: ["volume": volume, "access_token": accessToken! ], success: {(data) in
            
        }, failure: {(error) in
            
        })
    }
    
    
    func drink(_ gap: Int) {
        self.incrCurrentVolumeNumber(volume: gap)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "volumeChanged"), object: self)
    }
}
