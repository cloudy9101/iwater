//
//  Constants.swift
//  iWater
//
//  Created by cloudy on 2018/5/12.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

struct Constants {
    static let apiBaseUrl = "http://localhost:4000"
    // static let apiBaseUrl = "https://iwater.175mod.com"
    static let userEndpoint = apiBaseUrl + "/user.json"
    static let usersEndpoint = apiBaseUrl + "/users"
    static let drinkLogEndpoint = apiBaseUrl + "/users/drink_logs"
    static let tokenEndpoint = apiBaseUrl + "/oauth/token"
}
