//
//  CoreDataHandler.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    var context : NSManagedObjectContext!
    var container : NSPersistentContainer!
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        container = appDelegate.persistentContainer
    }
   
    //MARK: - Updates an Object
    func update(objectNeedToUpdate : WeatherData,changedObject : Json4Swift_Base){
        
        setManageobjectData(newRecord: objectNeedToUpdate, setObject: changedObject)
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    //MARK: - Save result in core data
    func saveResult(weatherList : [Json4Swift_Base],completion : @escaping (_ saveMsg : String) ->Void) {
        
        container.performBackgroundTask() { (context) in
            for i in 0...weatherList.count-1{
                let entity = NSEntityDescription.entity(forEntityName: "WeatherData", in: context)
                let newRecord = NSManagedObject(entity: entity!, insertInto: context) as! WeatherData
                self.setManageobjectData(newRecord: newRecord, setObject: weatherList[i])
            }
            do {
                try context.save()
                completion("save sucessfully")
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    func setManageobjectData(newRecord:WeatherData, setObject:Json4Swift_Base){
        newRecord.city = setObject.name!
        
        let wArr = setObject.weather![0] as Weather
        if let str =  wArr.description{
            newRecord.weatherDescription = str
        }
        
        if let hu = setObject.main!.humidity{
            newRecord.humidity = hu as NSNumber
        }
        
        if let temp = setObject.main!.temp{
            newRecord.temp = temp as NSNumber
        }
        
        if let tempMax = setObject.main!.temp_max{
            newRecord.tempMax = tempMax as NSNumber
        }
        
        if let tempMin = setObject.main!.temp_min{
            newRecord.tempMin = tempMin as NSNumber
        }
        if let windSpeed = setObject.wind!.speed{
            newRecord.wind = windSpeed as NSNumber
        }
        if let id = setObject.id{
            newRecord.cityID = id as NSNumber
        }
        if let type = setObject.weather![0].main{
            newRecord.weatherType = type
        }
        if let visibility = setObject.visibility{
            newRecord.visibility = visibility as NSNumber
        }
        if let sunset = setObject.sys!.sunset{
            newRecord.sunset = sunset as NSNumber
        }
        if let sunrise = setObject.sys!.sunrise{
            newRecord.sunrise = sunrise as NSNumber
        }
        
    }
    //MARK: - Fetch data from core data
    func fetchResult(completion:@escaping (_ fetchData : [WeatherData]) ->Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            DispatchQueue.global(qos: .userInitiated).async {
                var fetchData = [WeatherData]()
                for data in result as! [WeatherData] {
                    fetchData.append(data)
                }
                DispatchQueue.main.async {
                    completion(fetchData)
                }
            }
            
            
        } catch {
            print("Failed to fetch data")
        }
    }

}
