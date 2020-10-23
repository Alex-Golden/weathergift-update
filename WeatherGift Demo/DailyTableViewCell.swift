//
//  DailyTableViewCell.swift
//  WeatherGift Demo
//
//  Created by Alex Golden on 10/23/20.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyWeekdayLabel: UILabel!
    @IBOutlet weak var dailyHighLabel: UILabel!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var dailySummaryView: UITextView!
    
    var dailyWeather: DailyWeather! {
        didSet {
            dailyImageView.image = UIImage(named: dailyWeather.dailyIcon)
            dailyWeekdayLabel.text = dailyWeather.dailyWeekday
            dailyHighLabel.text = dailyWeather.dailySummary
            dailyLowLabel.text = "\(dailyWeather.dailyLow)°"
            dailyHighLabel.text = "\(dailyWeather.dailyHigh)°"
            dailySummaryView.text = dailyWeather.dailySummary
            
        }
    }
    
}
