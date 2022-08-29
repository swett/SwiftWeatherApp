//
//  NetworkManagerProtocol.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 01.08.2022.
//

import UIKit

protocol NetworkManagerProtocol {
//    typealias Completion = (_ success:Bool) -> Void

    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
//    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping Completion)
//    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}

