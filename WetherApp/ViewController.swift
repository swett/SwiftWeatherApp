//
//  ViewController.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 31.07.2022.
//

import UIKit
import Then
import SnapKit
import SDWebImage
//import SpriteKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    let networkManager = WeatherNetworkManager()
    var cityName: UILabel!
    var tempImage: UIImageView!
    var tempText: UILabel!
    var currentTime: UILabel!
    var weatherDescription: UILabel!
    var photoView: UIImageView!
    var photoView2: UIImageView!
    var maskView: UIImageView!
    var maskView2: UIImageView!
    var theImageViews = [UIImageViewWithMask]()
    var secondPhoto: UIImageView?
    var mask: CALayer!
    var tableview: UITableView!
    var coldColor = UIColor(named: "ColdColor")
    var defColor = UIColor(named: "DefColor")
    var hotColor = UIColor(named: "HotColor")
    var refreshControl = UIRefreshControl()
//    var skView: SKView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .red
         mask = CALayer()
        mask.contents =  [ UIImage(named: "cloud4")?.cgImage] as Any

//        cloudViews(photoName: AppData.shared.photoArray)
        
        
        tableview = UITableView(frame: CGRect(), style: .plain).then({ tableview in
            view.addSubview(tableview)
            tableview.delegate = self
            tableview.dataSource = self
            tableview.separatorStyle = .none
            tableview.showsVerticalScrollIndicator = false
            tableview.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
            tableview.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
            tableview.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                
            }
        })
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableview.addSubview(refreshControl)

        AppData.shared.loadData {
            self.tableview.reloadData()
            self.changeBackgroundColor(temp: AppData.shared.cityWeatherArray[0].main.temp)
//            self.cloudViews(photoName: AppData.shared.photoArray)
//            self.weatherAnimation(id: AppData.shared.cityWeatherArray[0].weather[0].id)
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        AppData.shared.loadData {
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func loadData(city:String){
        networkManager.fetchCurrentWeather(city: city, completion: {
            (weather) in
//            let icon_URL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd MMM yyyy"
//            let stringToDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
//            self.cityName.text = "\( weather.name ?? ""), \(weather.sys.country ?? "")"
//            self.tempImage.sd_setImage(with: URL(string: icon_URL), completed: nil)
//            self.tempText.text = String(format: "%.0f", weather.main.temp - 273) + " C"
//            self.currentTime.text = stringToDate
//            self.weatherDescription.text = weather.weather[0].description
            self.changeBackgroundColor(temp: weather.main.temp)
        })
    }
    
    func changeBackgroundColor (temp: Float){
        
        let convertedTemp = temp - 273
        print(convertedTemp)
        switch convertedTemp {
        case -100.0...12.0:
            view.backgroundColor = coldColor
            tableview.backgroundColor = coldColor
        case 12.01...22.0:
            view.backgroundColor = defColor
            tableview.backgroundColor = defColor
        case 22.01...55.0:
            view.backgroundColor = hotColor
            tableview.backgroundColor = hotColor
        default:
            view.backgroundColor = hotColor
            tableview.backgroundColor = hotColor
        }
        
        
    }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.cityWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
//        print(AppData.shared.cities[indexPath.row])
//        let city = AppData.shared.cities[indexPath.row]
//        print(city)
        cell.loadData(weather: AppData.shared.cityWeatherArray[indexPath.row])
        
//        cell.textedLabel.text = AppData.shared.cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeaderView
        
        return view
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityScreen = CityViewController(weather: AppData.shared.cityWeatherArray[indexPath.row])
        self.navigationController?.pushViewController(cityScreen, animated: true)
    }
}

class UIImageViewWithMask: UIImageView {
    var maskImageView = UIImageView()

    @IBInspectable
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            updateView()
        }
    }

    // This updates mask size when changing device orientation (portrait/landscape)
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    func updateView() {
        if maskImageView.image != nil {
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }
}
