//
//  WeatherInfoDetailsViewController.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class WeatherInfoDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var collectionViewWeatherDetail: UICollectionView!
    @IBOutlet weak var imageViewTemperature: UIImageView!
    var numOfCell : Int = 6
    var weatherDetails : WeatherData!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setUpUI(){
        self.navigationItem.title = weatherDetails.city!
        let tempStr = String(describing: weatherDetails.temp!)
        labelTemperature.text = "\(tempStr)°"
        labelWeatherDescription.text = weatherDetails.weatherDescription!

//        //Set image according to temperature
        self.setTemperatureImage(weatherType: weatherDetails.weatherType!)
        collectionViewWeatherDetail.reloadData()
    }
    
    //Set image according to the temperature
    private func setTemperatureImage(weatherType : String)
    {
        var imageName : String = ""
        
        if(weatherType.contains("Clouds")){
            imageName = "CloudySky"
        }else if(weatherType.contains("Clear")){
            imageName = "ClearSky"
        }else if(weatherType.contains("Rain")){
            imageName = "RainSky"
        }else if(weatherType.contains("Squall")){
            imageName = "SquallSky"
        }else if(weatherType.contains("Drizzle")){
            imageName = "DrizzleSky"
        }else if(weatherType.contains("Snow")){
            imageName = "SnowSky"
        }else{
            imageName = "ClearSky"
        }
        
        imageViewTemperature.image = UIImage(named: imageName)
    }
    //MARK : - CollectionView Delegates and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height :CGFloat = 80.0
        let width = collectionView.frame.size.width/CGFloat(numOfCell/2)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : WeatherDetailInformationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDetailInformationCollectionViewCell", for: indexPath) as! WeatherDetailInformationCollectionViewCell
        let cellData = cellDataGenerate(row: indexPath.row)
        cell.configureCellWithData(detailText: cellData.detailText, imageName: cellData.nameOfImage)
        performCellAnimation(cell: cell)
        return cell
    }
    //Cell animation method
    private func performCellAnimation(cell:WeatherDetailInformationCollectionViewCell){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut,
                                       animations: {
                                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },
                                       completion: nil
                        )
        }
        )
    }
    private func cellDataGenerate(row : Int)-> (detailText:String,nameOfImage:String)
    {
        var dataText = ""
        var imageName = ""
        
        switch row {
        case 0:
            let humidityStr = String(describing: weatherDetails.humidity!)
            dataText = "\(humidityStr)%"
            imageName = "Humidity"
        case 1:
            let tempMaxStr = String(describing: weatherDetails.tempMax!)
            dataText = "\(tempMaxStr)° : \(String(describing: weatherDetails.tempMin!))°"
            imageName = "Temperature"
        case 2:
            let windSpeedStr = String(describing: weatherDetails.wind!)
            dataText = "\(windSpeedStr)m/s"
            imageName = "WindSpeed"
        case 3:
            let visibilityStr = String(describing: weatherDetails.visibility!)
            dataText = visibilityStr
            imageName = "Visibility"
        case 4:
            let date = NSDate(timeIntervalSince1970: TimeInterval(weatherDetails.sunrise!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "Sunrise"
        case 5:
            let date = NSDate(timeIntervalSince1970: TimeInterval(weatherDetails.sunset!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "Sunset"
        default:
            let humidityStr = String(describing: weatherDetails.humidity!)
            dataText = "\(humidityStr)%"
            imageName = "Humidity"
        }
        
        return (dataText,imageName)
    }
    
    private func getTimeStringFromDate(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dataString = dateFormatter.string(from: date)
        return dataString
    }
}
