//
//  UserMode.swift
//  iWater
//
//  Created by cloudy on 2018/1/10.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

struct UserMode: Codable {
    let email: String?
    let mobile: String?
    let name: String
    let bio: String?
    let gender: Int
    let age: Int
    let currentVolumeNumber: Int?
    let avatar: String?
    let targetVolumeNumber: Int?
}
