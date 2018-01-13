//
//  Utils.swift
//  iWater
//
//  Created by cloudy on 2018/1/13.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import Foundation

class Utils {
    static let apiHost = "http://localhost:4000"
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
}
