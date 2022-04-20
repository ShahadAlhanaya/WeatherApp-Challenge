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
    
    func configureCell(location: Location){
        self.accessoryType = .none
        if location.woeid == UserDefaults.standard.getCurrentCity() {
            self.accessoryType = .checkmark
        }else{
            self.accessoryType = .none
        }
    }

}
