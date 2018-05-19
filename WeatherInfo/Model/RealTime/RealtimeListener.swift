//
//  RealtimeListener.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class RealtimeListener {
    var timer : Timer?
    let coreDataModel = CoreDataHandler()
    var updateModelObject : WeatherData!
    var fetchDataArray :[WeatherData]!
    // MARK : - Start Real Time Listner
    func startRealtimeListener() {
        if timer == nil {
            //set timer for every 5 min
            timer = Timer.scheduledTimer(timeInterval:300, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        }
    }
    // MARK : Timer Handler
    @objc func timerHandler(){
        apiCall(isFirst: false)
    }
    // MARK : API call
    func apiCall(isFirst:Bool)
    {
        let handlerObject = WebServiceHandler()
        handlerObject.weatherAPICall { (resultData) in
            if isFirst{
                //save result as it is in core data
                self.coreDataModel.saveResult(weatherList: resultData, completion: { (saveMsg) in
                    UserDefaults.standard.set(true, forKey: "isDataSaved")
                    NotificationCenter.default.post(name: Notification.Name("getDataNotification"), object: nil)
                })
            }else{
                self.coreDataModel.fetchResult { (fetchData) in
                    self.fetchDataArray = fetchData
                    for i in 0...resultData.count-1
                    {
                        if(!self.isSameWithModel(result: resultData[i]))
                        {
                            self.coreDataModel.update(objectNeedToUpdate: self.updateModelObject, changedObject: resultData[i])
                            
                        }
                    }
                }
                
            }
            
        }
    }
    
    private func isSameWithModel(result: Json4Swift_Base) -> Bool
    {
        let cityId = result.id!;
        let temp = result.main!.temp!;
        
        for weatherDataObj in fetchDataArray{
            if(cityId == weatherDataObj.cityID as! Int)
            {
                if(temp == weatherDataObj.temp as! Double)
                {
                    return true
                }else{
                    updateModelObject = weatherDataObj
                    return false
                }
            }
        }
        return true
        
    }
}
