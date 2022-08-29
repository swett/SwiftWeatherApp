//
//  CustomHeaderView.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 26.08.2022.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    var containerView: UIView!
    var cityName: UILabel!
    var tempImage: UIImageView!
    var tempText: UILabel!
    var currentTime: UILabel!
    var weatherDescription: UILabel!
    var networkManager = WeatherNetworkManager()
    var coldColor = UIColor(named: "ColdColor")
    var defColor = UIColor(named: "DefColor")
    var hotColor = UIColor(named: "HotColor")
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadData(city: "Kharkov")
        containerView = UIView().then({ containerView in
            contentView.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(300)
            }
        })
        
        currentTime = UILabel().then({ currentTime in
            containerView.addSubview(currentTime)
            currentTime.numberOfLines = 0
            currentTime.text = "load date"
            currentTime.font = .monospacedDigitSystemFont(ofSize: 16, weight: .light)
            currentTime.textColor = .black
            currentTime.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(10)
            }
        })
        
        
        cityName = UILabel().then({ city in
            containerView.addSubview(city)
            city.numberOfLines = 0
            city.text = "Loading Location..."
            city.font = .monospacedDigitSystemFont(ofSize: 45, weight: .light)
            city.textColor = .black.withAlphaComponent(0.9)
            city.snp.makeConstraints { make in
                make.top.equalTo(currentTime.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(10)
            }
        })
        
        
        tempText = UILabel().then({ tempText in
            containerView.addSubview(tempText)
            tempText.numberOfLines = 0
            tempText.text = "Loading Temp"
            tempText.font = .monospacedDigitSystemFont(ofSize: 55, weight: .light)
            tempText.textColor = .black
            tempText.snp.makeConstraints { make in
                make.top.equalTo(cityName.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(10)
            }
        })
        
        weatherDescription = UILabel().then({ weatherDescription in
            containerView.addSubview(weatherDescription)
            weatherDescription.numberOfLines = 0
            weatherDescription.text = "Loading description"
            weatherDescription.font = .monospacedDigitSystemFont(ofSize: 25, weight: .light)
            weatherDescription.textColor = .black
            weatherDescription.snp.makeConstraints { make in
                make.top.equalTo(tempText.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(80)
                
            }
        })
        
        tempImage = UIImageView().then({ tempImage in
            containerView.addSubview(tempImage)
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
    
    }
    
    
    
    
    
    func loadData(city:String){
        networkManager.fetchCurrentWeather(city: city, completion: {
            (weather) in
            let icon_URL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let stringToDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            self.cityName.text = "\( weather.name ?? ""), \(weather.sys.country ?? "")"
            self.tempImage.sd_setImage(with: URL(string: icon_URL), completed: nil)
            self.tempText.text = String(format: "%.0f", weather.main.temp - 273) + " C"
            self.currentTime.text = stringToDate
            self.weatherDescription.text = weather.weather[0].description
            self.changeBackgroundColor(temp: weather.main.temp)
            
        })
    }
    
    func changeBackgroundColor (temp: Float){
        
        let convertedTemp = temp - 273
        print(convertedTemp)
        switch convertedTemp {
        case -100.0...12.0:
            containerView.backgroundColor = coldColor
            contentView.backgroundColor = coldColor
        case 12.01...22.0:
            containerView.backgroundColor = defColor
            contentView.backgroundColor = defColor
        case 22.01...55.0:
            containerView.backgroundColor = hotColor
            contentView.backgroundColor = hotColor
        default:
            containerView.backgroundColor = hotColor
            contentView.backgroundColor = hotColor
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
