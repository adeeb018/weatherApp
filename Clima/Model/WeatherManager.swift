//
//  WeatherManager.swift
//  Clima
//
//  Created by Adeeb K on 12/12/24.
//
import AVFoundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d148582d72f10143af546c458095bf10&units=metric"
    
    var delegate: WeatherManagerDelegate?
        
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude lat: CLLocationDegrees,longitude lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // create URL
        if let url = URL(string: urlString) {
            // create a URL session
            let session = URLSession(configuration: .default)
            
            // Give session a task
            let task = session.dataTask(with: url) { data, URLResource, error in
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
            
            // start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weatherModel = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            
            return weatherModel
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
