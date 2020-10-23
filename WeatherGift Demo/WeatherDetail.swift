//
//  WeatherDetail.swift
//  WeatherGift Demo
//
//  Created by Alex Golden on 10/12/20.
//

import Foundation

private let dateFormatter: DateFormatter = {
    print("one date formatter2 weather detail.swift")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
} ()

struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
    
}


class WeatherDetail: WeatherLocation{
    private struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
    }
    private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    private struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
    
    
    
    
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var timezone = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    
    func getData(completed: @escaping () -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        print("accessing url \(urlString)")
        
        //create url
        guard let url = URL(string: urlString) else {
            print("could not create a url from urlstring")
            completed()
            return
        }
        let session = URLSession.shared
        
        //get data with .datatask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
            
        //dealing with the data
            do {
   //             let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let result = try JSONDecoder().decode(Result.self, from: data!)
                print("\(result)")
                print("the timezone of \(self.name) is \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("day: \(dailyWeekday) high: \(dailyHigh) low: \(dailyLow)")
                }
            } catch {
                print(" json error \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
    private func fileNameForIcon(icon: String) -> String {
        var newFileName = ""
        switch icon {
        case "01d":
            newFileName = "clearday"
        case "01n":
            newFileName = "clearnight"
        case "02d":
            newFileName = "partlycloudyday"
        case "02n":
            newFileName = "partlycloudynight"
        case "03d", "03n", "04d", "04n" :
            newFileName = "cloudy"
        case "09d", "09n", "10d", "10n" :
            newFileName = "rain"
        case "11d", "11n":
            newFileName = "storm"
        case "13d", "13n":
            newFileName = "snow"
        case "50d", "50n":
            newFileName = "fog"
        default:
            newFileName = ""
        }
    
    }

}
