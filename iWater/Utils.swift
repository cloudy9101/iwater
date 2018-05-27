//
//  Utils.swift
//  iWater
//
//  Created by cloudy on 2018/1/13.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation
import CoreData

class Utils {
    static let shared = Utils()
    
    func postData(url: String, params: Dictionary<String,Any>?, success: @escaping ((_ result: Data) -> ()), failure: @escaping ((_ error:Error) -> ())) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params as Any, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                failure(error!)
            }
            
            success(data!)
            
        }.resume()
    }
    
    func getData(url: String, params: Dictionary<String,Any>?, success: @escaping ((_ result: Data) -> ()), failure: @escaping ((_ error:Error) -> ())) {
        var i = 0
        var address = url
        
        if params != nil {
            for (key,value) in params! {
                if i == 0 {
                    address += "?\(key)=\(value)"
                }else {
                    address += "&\(key)=\(value)"
                }
                i += 1
            }
        }
        
        let path = URL(string: address.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!)

        var request = URLRequest(url: path!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                failure(error!)
            }
            
            success(data!)
        }.resume()
    }
    
    
    func get_access_token(username: String, password: String) {
        let grantType = "password"
        
        Utils.shared.postData(url: Constants.tokenEndpoint,
                              params: ["username": username, "password": password, "grant_type": grantType],
                              success: {(result) in
                                do {
                                    let authData = try JSONDecoder().decode(UserAccessToken.self, from: result)
                                    let encoder = PropertyListEncoder()
                                    let data = try encoder.encode(authData)
                                    UserDefaults.standard.set(data, forKey: "AccessToken")
                                    User(authData.access_token)
                                } catch let jsonError {
                                    print(jsonError)
                                }
                              }, failure: {(error) in
                                print(error)
                              }
        )
    }
    
    func get_user() {
        do {
            let data = UserDefaults.standard.data(forKey: "AccessToken")
            let decoder = PropertyListDecoder()
            if data == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
            } else {
                let userAccessToken = try decoder.decode(UserAccessToken.self, from: data!)
                
                if Date(timeIntervalSince1970: TimeInterval(userAccessToken.created_at + userAccessToken.expires_in)) < Date() {
                    self.refreshToken(userAccessToken.refresh_token)
                } else {
                    User(userAccessToken.access_token)
                }
            }
        } catch let error {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
            print(error)
        }
    }
    
    func refreshToken(_ token: String) {
        Utils.shared.postData(url: Constants.tokenEndpoint,
                              params: ["grant_type": "refresh_token", "refresh_token": token],
                              success: { (result) in
                                do {
                                    let authData = try PropertyListDecoder().decode(UserAccessToken.self, from: result)
                                    
                                    UserDefaults.standard.set(authData, forKey: "AccessToken")
                                    User(authData.access_token)
                                } catch let jsonError {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
                                    print(jsonError)
                                }
                                
                              },
                              failure: {(error) in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
                                print(error)
                              }
        )
    }
    
    func signup(_ email: String, _ password: String, _ username: String, _ age: String) {
        Utils.shared.postData(url: Constants.usersEndpoint, params: ["email": email, "password": password, "name": username, "age": age], success: {(data) in
            do {
                let result = try JSONDecoder().decode(SignupData.self, from: data)
                
                if result.success == "true" {
                    Utils.shared.get_access_token(username: email, password: password)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
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
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "AccessToken")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoUser"), object: nil)
    }
    
    func getDrinkLog(on: Date) {
        let data = UserDefaults.standard.data(forKey: "AccessToken")
        let decoder = PropertyListDecoder()
        let isoFomatter = ISO8601DateFormatter()
        let startDate = Calendar.current.startOfDay(for: on)
        let startAt = isoFomatter.string(from: startDate)
        let endAt = isoFomatter.string(from: Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!)
        do {
            let userAccessToken = try decoder.decode(UserAccessToken.self, from: data!)
        
            getData(url: Constants.drinkLogEndpoint, params: ["start_at": startAt, "end_at": endAt, "access_token": userAccessToken.access_token], success: {(data) in
                    do {
                        let result = try JSONDecoder().decode(DrinkLogData.self, from: data)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetDrinkLog"), object: result)
                        }
                    } catch let jsonError {
                        print(jsonError)
                    }
            }, failure: {(error) in
                print(error)
            })
        } catch let jsonError {
            print(jsonError)
        }

    }
}


struct SignupData: Codable {
    let success: String
    let errors: [String: [String]]?
}

struct DrinkLogData: Codable {
    let total: Int?
    let logs: [DrinkLog]
}

struct DrinkLog: Codable {
    let time: String
    let volume: Int
}
