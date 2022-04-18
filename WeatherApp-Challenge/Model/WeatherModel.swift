//
//  WeatherModel.swift
//  WeatherApp-Challenge
//
//  Created by Shahad Nasser on 17/04/2022.
//

import Foundation
class WeatherModel {
    static func getWeather(location: String,completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "https://www.metaweather.com/api/location/\(location)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
}
