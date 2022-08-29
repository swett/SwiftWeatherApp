//
//  CityViewController.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 26.08.2022.
//

import UIKit

class CityViewController: UIViewController {

    
    var weather: WeatherModel!
    var cityName: UILabel!
    var tempImage: UIImageView!
    var tempText: UILabel!
    var currentTime: UILabel!
    var weatherDescription: UILabel!
    var coldColor = UIColor(named: "ColdColor")
    var defColor = UIColor(named: "DefColor")
    var hotColor = UIColor(named: "HotColor")
    
    
    convenience init(weather: WeatherModel) {
        self.init()
        self.weather = weather
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let stringToDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = true
        
        currentTime = UILabel().then({ currentTime in
                    view.addSubview(currentTime)
                    currentTime.numberOfLines = 0
                    currentTime.text = stringToDate
                    currentTime.font = .monospacedDigitSystemFont(ofSize: 16, weight: .light)
                    currentTime.textColor = .black
                    currentTime.snp.makeConstraints { make in
                        make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
                        make.left.equalToSuperview().offset(10)
                    }
                })
        cityName = UILabel().then({ city in
                    view.addSubview(city)
                    city.numberOfLines = 0
                    city.text = weather.name
                    city.font = .monospacedDigitSystemFont(ofSize: 45, weight: .light)
                    city.textColor = .black.withAlphaComponent(0.9)
                    city.snp.makeConstraints { make in
                        make.top.equalTo(currentTime.snp.bottom).offset(10)
                        make.left.equalToSuperview().offset(10)
                    }
                })
        tempText = UILabel().then({ tempText in
                    view.addSubview(tempText)
                    tempText.numberOfLines = 0
                    tempText.text = String(format: "%.0f", weather.main.temp - 273) + " C"
                    tempText.font = .monospacedDigitSystemFont(ofSize: 55, weight: .light)
                    tempText.textColor = .black
                    tempText.snp.makeConstraints { make in
                        make.top.equalTo(cityName.snp.bottom).offset(10)
                        make.left.equalToSuperview().offset(10)
                    }
                })
        weatherDescription = UILabel().then({ weatherDescription in
                    view.addSubview(weatherDescription)
                    weatherDescription.numberOfLines = 0
                    weatherDescription.text = weather.weather[0].description
                    weatherDescription.font = .monospacedDigitSystemFont(ofSize: 25, weight: .light)
                    weatherDescription.textColor = .black
                    weatherDescription.snp.makeConstraints { make in
                        make.top.equalTo(tempText.snp.bottom).offset(20)
                        make.left.equalToSuperview().offset(80)
        
                    }
                })
        tempImage = UIImageView().then({ tempImage in
                    view.addSubview(tempImage)
                    tempImage.image = UIImage(systemName: "cloud.fill")
                    tempImage.contentMode = .scaleAspectFit
        //            tempImage.tintColor = .gray
                    tempImage.snp.makeConstraints { make in
                        make.top.equalTo(tempText.snp.bottom).offset(10)
                        make.left.equalToSuperview().offset(10)
                        make.height.equalTo(60)
                        make.width.equalTo(60)
        
                    }
                })
        let icon_URL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
        self.tempImage.sd_setImage(with: URL(string: icon_URL), completed: nil)
        changeBackgroundColor(temp: weather.main.temp)
    }
    
    func changeBackgroundColor (temp: Float){
        
        let convertedTemp = temp - 273
        print(convertedTemp)
        switch convertedTemp {
        case -100.0...12.0:
            view.backgroundColor = coldColor
        case 12.01...22.0:
            view.backgroundColor = defColor
        case 22.01...55.0:
            view.backgroundColor = hotColor
        default:
            view.backgroundColor = hotColor
        }
        
        
    }

}
