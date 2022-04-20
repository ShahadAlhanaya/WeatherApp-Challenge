//
//  LocationTableViewCell.swift
//  WeatherApp-Challenge
//
//  Created by Shahad Nasser on 19/04/2022.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    //outlets
    @IBOutlet weak var cityLabel: UILabel!
    
    func configureCell(location: Location, currentCity: String){
        self.accessoryType = .none
        if location.woeid == currentCity {
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }

}
