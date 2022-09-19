//
//  AppData.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 31.07.2022.
//

import UIKit

class AppData: NSObject {
    var dispatchGroup = DispatchGroup()
    var cityWeatherArray: [WeatherModel] = []
    let photoArray = [ "SANYA","kurka", "vetas"]
    let cities = ["Kharkov", "Kiev", "London"]
    let networkManager = WeatherNetworkManager()
    
    func loadData(completion: @escaping ()->()){
        cityWeatherArray.removeAll()
        for (i,city) in cities.enumerated() {
            dispatchGroup.enter()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(i)*0.6, execute: {
                self.networkManager.fetchCurrentWeather(city: city, completion: {
                    (weather) in
                    self.cityWeatherArray.append(weather)
                    self.dispatchGroup.leave()
                })
            })
            
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
        
    }
    
    
    
    static let shared: AppData = AppData()
}
