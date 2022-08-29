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
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    let networkManager = WeatherNetworkManager()
    var cityName: UILabel!
    var tempImage: UIImageView!
    var tempText: UILabel!
    var currentTime: UILabel!
    var weatherDescription: UILabel!
    var rainLayer: CloudView!
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
//        rain()
        
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
    
    func runningCloud(view: UIImageView, photo: Int) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
//            view.snp.updateConstraints { make in
//                make.left.equalTo(200)
//            }
            if photo == 0 {
                view.center.x += 270
            }
            if photo == 1 {
                    view.center.x += 210
            }
            if photo == 2 {
                view.center.x += 200
            }

            
        } completion: { com in
            self.animateClouds(view: view, photo: photo)
        }
        
       
    }
    
    func animateClouds(view: UIImageView, photo: Int) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            view.alpha = 1
            if photo == 0 {
                
                view.center.x = 90
                view.frame.origin.x += 40
            } else if photo == 1 {
                view.center.x = 10
                view.frame.origin.x += 40
                
            } else {
                view.center.x = 70
                view.frame.origin.x += 140
                
            }
//                self.view.layoutIfNeeded()
        } completion: { com in
            if com {
                if photo == 0 {
                    self.runningCloud(view: view, photo: photo)
                }
                if photo == 1 {
                    self.runningCloud(view: view, photo: photo)
                }
                if photo == 2 {
                    self.runningCloud(view: view, photo: photo)
                }
                
            }
            
        }
    }
    
    func cloudViews (photoName: [String]){
        
        for photo in 0..<photoName.count {
            let imageView = UIImageViewWithMask().then({ photoView in
                view.addSubview(photoView)
                photoView.maskImage = UIImage(named: "cloud4")
                photoView.image = UIImage(named: photoName[photo])
                photoView.alpha = 0
                
//                photoView.layer.masksToBounds = true
//
                
                if photo == 0 {
                    photoView.frame = CGRect(x: 60, y: 260, width: 180, height: 145)
                } else if photo == 1 {
                    photoView.frame = CGRect(x: 10, y: 280, width: 250, height: 200)
                } else {
                    photoView.frame = CGRect(x: 120, y: 280, width: 250, height: 200)
                }
            })
            print(photo)
            animateClouds(view: imageView, photo: photo)

            self.theImageViews.append(imageView)
        }
    }
    
    func rain() {
       
        let emmiter = CloudView.get(with: UIImage(named: "rainn5")!)
        emmiter.emitterPosition = CGPoint(x: view.frame.width/2, y: 50)
        emmiter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emmiter)
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
