//
//  WeatherData+CoreDataProperties.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var city: String?
    @NSManaged public var humidity: NSNumber?
    @NSManaged public var temp: NSNumber?
    @NSManaged public var tempMax: NSNumber?
    @NSManaged public var tempMin: NSNumber?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var wind: NSNumber?
    @NSManaged public var cityID: NSNumber?
    @NSManaged public var weatherType : String?
    @NSManaged public var visibility: NSNumber?
    @NSManaged public var sunrise: NSNumber?
    @NSManaged public var sunset: NSNumber?
}
