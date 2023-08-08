//
//  WeatherManager.swift
//  weather_app
//
//  Created by Rustam Aliyev on 06.07.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=93d3e0ad32660af89b783c378f7d6709&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let city = cityName.components(separatedBy: " ").joined(separator: "+")
        let urlString = "\(weatherUrl)&q=\(city)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
            performRequest(with: urlString)
        }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let humidityInterface = decodeData.main.humidity
            let windSpeedInrerface = decodeData.wind.speed
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, humidityStr: humidityInterface, windSpeed: windSpeedInrerface)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
    

