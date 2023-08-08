//
//  WeatherData.swift
//  weather_app
//
//  Created by Rustam Aliyev on 07.07.2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}
struct Main: Codable {
    let temp: Double
    let humidity: Int
}
struct Weather: Codable {
    let description: String
    let id: Int
}
struct Wind: Codable {
    let speed: Double
}
