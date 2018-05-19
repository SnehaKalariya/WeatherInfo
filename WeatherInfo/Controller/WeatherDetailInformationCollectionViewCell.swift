//
//  WeatherDetailInformationCollectionViewCell.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit

class WeatherDetailInformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewWeatherDetail: UIImageView!
    @IBOutlet weak var labelWeatherDetail: UILabel!
    
    
    func configureCellWithData(detailText : String, imageName: String)
    {
        labelWeatherDetail.text = detailText
        imageViewWeatherDetail.image = UIImage(named: imageName)
    }
}
