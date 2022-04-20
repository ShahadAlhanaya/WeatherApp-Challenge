//
//  SavedUserDefaults.swift
//  WeatherApp-Challenge
//
//  Created by Shahad Nasser on 20/04/2022.
//

import Foundation
extension UserDefaults{
    
    func setLightMode(value: Bool){
        set(value, forKey: UserDefaultsKeys.lightMode.rawValue)
    }
    func getLightMode() -> Bool{
        return bool(forKey: UserDefaultsKeys.lightMode.rawValue)
    }
    
    func setCurrentCity(value: String){
        set(value, forKey: UserDefaultsKeys.currentCity.rawValue)
    }
    func getCurrentCity() -> String{
        return string(forKey: UserDefaultsKeys.currentCity.rawValue) ?? "1939753" //Riyadh is the default
    }
}

enum UserDefaultsKeys : String {
    case lightMode
    case currentCity
}
