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
    
    //threading
    private var pendingWorkItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "GetWeather")
    
    //coredata
    var locations = [Location]()
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        //coredata
        fetchLocations()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return locationList.count
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")! as! LocationTableViewCell
        cell.cityLabel.text = locations[indexPath.row].cityName
        cell.configureCell(location: locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setCurrentCity(value: locations[indexPath.row].woeid!)
        locationListTableView.reloadData()
        locationTableDelegate?.updateCurrentCity()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        showAddAlert()
    }
    
    func showAddAlert(){
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "WOEID"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
            let woeid = alert.textFields![0].text ?? ""
            if woeid.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                
                self.fetch(woeid)
                

            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetch(_ woeid: String){
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem {
            self.getWeather(woeid)
        }
        pendingWorkItem = newWorkItem
        queue.sync(execute: newWorkItem)
    }
    
    func getWeather(_ woeid: String){
        WeatherModel.getWeather(location: woeid,completionHandler: { [self]data,response,error in
            
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    
                    guard let weatherData = data else { return }
                    do{
                        let decoder = JSONDecoder()
                        let jsonResult = try decoder.decode(WeatherResponse.self, from: weatherData)
                        let cityName = jsonResult.title.capitalized
                    
                        DispatchQueue.main.async {
                            let newLocation = Location(context: self.managedObjectContext)
                            newLocation.cityName = cityName
                            newLocation.woeid = woeid
                            saveLocation()
                            self.locationListTableView.reloadData()
                        }
                    
                    }catch{
                        print(error)
                    }
                   
                }else {
                    print("not good!")
                    return
                }
            }
            
        })
    }
    
    func saveLocation() {
        do {
            try managedObjectContext.save()
            print("Successfully saved")
        } catch {
            print("Error when saving: \(error)")
        }
        fetchLocations()
    }
    
    func fetchLocations() {
        do {
            locations = try managedObjectContext.fetch(Location.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        locationListTableView.reloadData()
    }
    
    
}
