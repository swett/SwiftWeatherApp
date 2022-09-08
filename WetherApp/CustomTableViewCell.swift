//
//  CustomTableViewCell.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 24.08.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var containerView: UIView!
    var photoLable: UIImageView!
    var textedLabel: UILabel!
    var tempText: UILabel!
    var currentTime: UILabel!
    var photoLabel:  UIImageView!
    var weatherDescription: UILabel!
    let networkManager = WeatherNetworkManager()
    var coldColor = UIColor(named: "ColdColor")
    var defColor = UIColor(named: "DefColor")
    var hotColor = UIColor(named: "HotColor")
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        containerView = UIView().then({ container in
            contentView.addSubview(container)
            container.layer.cornerRadius = 10
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.black.cgColor
            container.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview().inset(30)
                make.height.equalTo(100)
                make.bottom.equalToSuperview().inset(10)
            }
        })
        
        textedLabel = UILabel().then({ textedLabel in
            containerView.addSubview(textedLabel)
            textedLabel.textColor = .black
            textedLabel.numberOfLines = 0
            textedLabel.adjustsFontSizeToFitWidth = true
            textedLabel.backgroundColor = .clear
            textedLabel.textAlignment = .center
            textedLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
            }
        })
        
        tempText = UILabel().then({ tempText in
            containerView.addSubview(tempText)
            tempText.textColor = .black
            tempText.numberOfLines = 0
            tempText.adjustsFontSizeToFitWidth = true
            tempText.backgroundColor = .clear
            tempText.textAlignment = .center
            tempText.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalTo(textedLabel.snp.right).offset(20)
            }
        })
        
        photoLabel = UIImageView().then({ tempImage in
            containerView.addSubview(tempImage)
            tempImage.contentMode = .scaleAspectFit
            tempImage.image = UIImage(systemName: "cloud.fill")
            tempImage.snp.makeConstraints { make in
                make.top.equalTo(tempText.snp.bottom).offset(5)
            }
        })
        
        
    }

    func loadData(weather: WeatherModel){
            let icon_URL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let stringToDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            self.textedLabel.text = "\( weather.name ?? ""), \(weather.sys.country ?? "")"
            self.photoLabel.sd_setImage(with: URL(string: icon_URL), completed: nil)
            self.tempText.text = String(format: "%.0f", weather.main.temp - 273) + " C"
//            self.currentTime.text = stringToDate
//            self.weatherDescription.text = weather.weather[0].description
            self.changeBackgroundColor(temp: weather.main.temp)
            
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
