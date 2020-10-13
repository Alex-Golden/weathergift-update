//
//  WeatherDetail.swift
//  WeatherGift Demo
//
//  Created by Alex Golden on 10/12/20.
//

import Foundation

class WeatherDetail: WeatherLocation{
    struct Result: Codable {
        var timezone: String
        var current: Current
    }
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var timezone = ""
    var dailyIcon = ""
    
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
                self.dailyIcon = result.current.weather[0].icon
            } catch {
                print(" json error \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }


}
