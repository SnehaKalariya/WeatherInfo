//
//  CommonAPICall.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class CommonAPICall: NSObject {

    func getApiCall(url:String,completion:@escaping (_ result : Data)-> Void,failure:@escaping ((_ getError: Error) -> Void)) {
        guard let serviceUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: serviceUrl) { (data, response, err) in
            
            guard let data = data else { return failure(err!) }
            completion(data)
            
            }.resume()
    }
}
//MARK:- UIView controller Extension
extension UIViewController{
    func showAlert(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
