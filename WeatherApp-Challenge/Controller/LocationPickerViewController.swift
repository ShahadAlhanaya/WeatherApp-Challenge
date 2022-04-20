//
//  LocationPickerViewController.swift
//  WeatherApp-Challenge
//
//  Created by Shahad Nasser on 19/04/2022.
//

import Foundation
import UIKit

class LocationPickerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //delegate
    var locationTableDelegate: LocationTableDelegate?
    
    //static list of cities
    var locationList = [Location(cityName: "Riyadh", woeid: "1939753"), Location(cityName: "New York", woeid: "2459115"), Location(cityName: "Cairo", woeid: "1521894")]

    //outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var locationListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in Location Picker Controller")
        
        //delegates
        locationListTableView.delegate = self
        locationListTableView.dataSource = self
        
        //set back button color
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")! as! LocationTableViewCell
        cell.cityLabel.text = locationList[indexPath.row].cityName
        cell.configureCell(location: locationList[indexPath.row], currentCity: UserDefaults.standard.getCurrentCity())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setCurrentCity(value: locationList[indexPath.row].woeid)
        locationListTableView.reloadData()
        locationTableDelegate?.updateCurrentCity()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        showAddAlert()
    }
    
    //not working yet
    func showAddAlert(){
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "WOEID"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
            let woeid = alert.textFields![0].text ?? ""
            if woeid.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                self.locationList.append(Location(cityName: woeid, woeid: woeid))
                self.locationListTableView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
