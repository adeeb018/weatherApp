//
//  WeatherData.swift
//  Clima
//
//  Created by Adeeb K on 13/12/24.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Float
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
 
