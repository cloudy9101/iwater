//
//  UserAuth.swift
//  iWater
//
//  Created by cloudy on 2018/1/13.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

struct UserAccessToken: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    let created_at: Int
}
