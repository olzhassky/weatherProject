//
//  WeatherStruct.swift
//  weatherProject
//
//  Created by Olzhas Zhakan on 17.09.2023.
//

import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temp: Double
    let weather: [WeatherCondition]
}

struct WeatherCondition: Codable {
    let description: String
}
