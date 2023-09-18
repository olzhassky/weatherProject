//
//  ViewController.swift
//  weatherProject
//
//  Created by Olzhas Zhakan on 15.09.2023.
//

import UIKit
import Alamofire
import SnapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var lastApiRequestTime: Date?
    let locationManager = CLLocationManager()
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 56)
        label.textColor = .white
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    let apiKey = "215e8357c64536d2060333d77a8097b9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(cityLabel)
        makeConstraints()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func makeConstraints() {
        tempLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentTime = Date()
            if let lastRequestTime = lastApiRequestTime, currentTime.timeIntervalSince(lastRequestTime) < 300 {
                return
            }
            //  let latitude = location.coordinate.latitude
            //  let longitude = location.coordinate.longitude
            let latitude = 43.2566700
            let longitude = 76.9286100
            
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            AF.request(url).responseJSON { response in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        print(weatherData)
                        self.updateUI(with: weatherData)
                    } catch {
                        print("Ошибка декодирования данных: \(error)")
                    }
                }
            }
        }
    }
    
    func updateUI(with weather: WeatherData) {
        let temperatureInKelvin = weather.current.temp
        let temperatureInCelsius = temperatureInKelvin - 273.15
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        if let temperatureText = numberFormatter.string(from: NSNumber(value: temperatureInCelsius)) {
            let formattedTemperatureText = "\(temperatureText)°C"
            let descriptionText = weather.current.weather[0].description
            
            tempLabel.text = formattedTemperatureText
            descriptionLabel.text = descriptionText
        }
        let weatherDescription = weather.current.weather[0].description.lowercased()
        let isRainy = weatherDescription.contains("rain")
        let isCloudy = weatherDescription.contains("cloudy") || weatherDescription.contains("clear")
        if isRainy {
            if let rainyImage = UIImage(named: "rain") {
                view.backgroundColor = UIColor(patternImage: rainyImage)
            }
        } else if isCloudy {
            if let sunnyImage = UIImage(named: "cloudy1") {
                view.backgroundColor = UIColor(patternImage: sunnyImage)
            }
        } else {
            if let defaultImage = UIImage(named: "sunny") {
                view.backgroundColor = UIColor(patternImage: defaultImage)
            }
        }
        
    }
    
    
    
}

