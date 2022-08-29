//
//  AppData.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 31.07.2022.
//

import UIKit

class AppData: NSObject {
    var cityWeatherArray: [WeatherModel] = []
    let photoArray = [ "SANYA","kurka", "vetas"]
    let cities = ["Kharkov", "Kiev", "London"]
    let networkManager = WeatherNetworkManager()
    
    func loadData(completion: @escaping ()->()){
        cityWeatherArray.removeAll()
        for (i,city) in cities.enumerated() {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(i)*0.6, execute: {
                self.networkManager.fetchCurrentWeather(city: city, completion: {
                    (weather) in
                    self.cityWeatherArray.append(weather)
                    if i == self.cities.count - 1 {
                        print(self.cityWeatherArray.count)
                        completion()
                    }
                })
            })
            
        }
        
    }
    
    
    
    static let shared: AppData = AppData()
}
