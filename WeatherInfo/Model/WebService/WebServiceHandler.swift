//
//  WebServiceHandler.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class WebServiceHandler: NSObject {
    var weatherResult = [Json4Swift_Base]()
    var group : DispatchGroup!
    
    //MARK: - Wether api call
    func weatherAPICall(completion :@escaping (_ resultData : [Json4Swift_Base])-> Void) {
        let commonApiObj = CommonAPICall()
        let privateQueue = DispatchQueue(label: "privateQueue", qos: .utility, attributes: .concurrent)
        
        //API call concurrently
        group = DispatchGroup()
        group.enter()
        privateQueue.async(group: group){
            
            commonApiObj.getApiCall(url: "\(baseURL)?id=\(sydneyID)&units=metric&APPID=\(appID)", completion: { (result) in
                self.decodeJsonResponse(resultData: result)
                
            }, failure: {(getError)
                in
                print("error msg \(getError)")
                self.group.leave()
                
            })
        }
        group.enter()
        privateQueue.async(group: group){
            
            commonApiObj.getApiCall(url: "\(baseURL)?id=\(melbourneID)&units=metric&APPID=\(appID)", completion: { (result) in
                self.decodeJsonResponse(resultData: result)
                
            }, failure: {(getError)
                in
                print("error msg \(getError)")
                self.group.leave()
            })
        }
        group.enter()
        privateQueue.async(group: group){
            
            commonApiObj.getApiCall(url: "\(baseURL)?id=\(brisbaneID)&units=metric&APPID=\(appID)", completion: { (result) in
                self.decodeJsonResponse(resultData: result)
                
            }, failure: {(getError)
                in
                print("error msg \(getError)")
                self.group.leave()
                
            })
        }
        
        group.notify(queue: DispatchQueue.global(qos: .background)){
            completion(self.weatherResult)
        }
    }
    private func decodeJsonResponse(resultData:Data) {
        do{
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: resultData)
            self.weatherResult.append(responseModel)
            group.leave()
        }catch{
            print("does not parse")
        }
    }
}
