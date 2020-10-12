
//  WeatherLocation.swift
//  WeatherGift Demo

//  Created by Alex Golden on 10/6/20.

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    func getData() {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        print("accessing url \(urlString)")
        
        //create url
        guard let url = URL(string: urlString) else {
            print("could not create a url from urlstring")
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("\(json)")
            } catch {
                print(" json error \(error.localizedDescription)")
            }
        }
        task.resume()
    }



}
