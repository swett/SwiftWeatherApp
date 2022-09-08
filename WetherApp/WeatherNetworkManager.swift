//
//  WeatherNetworkManager.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 01.08.2022.
//

import UIKit
import Alamofire

class WeatherNetworkManager:NSObject {
//    typealias Completion = (_ success:Bool) -> Void
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ()) {
        
        let formattedCity = city.replacingOccurrences(of: "", with: "+")
        let API_URL = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)"
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        AF.request(API_URL).responseDecodable(of: WeatherModel.self) { responseJson  in
            switch responseJson.result {
            case .success(let value):
                do{
                    let currentWeather = value
                    completion(currentWeather)
                        
                }
                catch{
                    
                }
                print(value)
                
            case .failure(let error):
                print(error)
                
                
            }
        }

    }
//    func fetchCurrentLocationWeather(lat: String, lon: String, completion: <<error type>>) {
//        <#code#>
//    }
//    func fetchNextFiveWeatherForecast(city: String, completion: <<error type>>) {
//        <#code#>
//    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Main: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}
struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
    let dt: Int
    let timezone: Int?
    let dt_txt: String?
    var capital: Bool?
}


