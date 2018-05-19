//
//  Service.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class Service: NSObject {
    var threadStarted : Bool = false
    func fetchData() {
        if !threadStarted{
            
            //set Timer call
            let timeListener = RealtimeListener()
            
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "isDataSaved") == false{
                timeListener.apiCall(isFirst: true)
            }else{
                timeListener.apiCall(isFirst: false)
            }
            
            
            timeListener.startRealtimeListener()
        }
    }
}
