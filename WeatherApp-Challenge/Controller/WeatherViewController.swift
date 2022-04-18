//
//  WeatherViewController.swift
//  WeatherApp-Challenge
//
//  Created by Shahad Nasser on 17/04/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var consolidatedWeatherCollectionView: UICollectionView!
    
    
    var consolidatedWeatherList : [ConsolidatedWeather]?
    var city: String?
    var currentDate: String?
    var currentDescription: String?
    var currentWeather: Double?
    
    
    private var pendingWorkItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "GetWeather")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("heeeey")
        customizeCollectionViews()
        consolidatedWeatherCollectionView.dataSource = self
        fetch()
    }
    
    func fetch(){
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem {
             self.getWeather()
        }
        pendingWorkItem = newWorkItem
        queue.sync(execute: newWorkItem)
    }
    
    func getWeather(){
        WeatherModel.getWeather(location: "1939753",completionHandler: { [self]data,response,error in
            guard let weatherData = data else { return }
            do{
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(WeatherResponse.self, from: weatherData)
                
                print(jsonResult)
                self.consolidatedWeatherList = jsonResult.consolidatedWeather
                self.city = jsonResult.title
                self.currentDate = self.consolidatedWeatherList?[0].applicableDate
                self.currentWeather = self.consolidatedWeatherList?[0].theTemp
                self.currentDescription = self.consolidatedWeatherList?[0].weatherStateName
                
                
                print(city)
                print(formatdate(currentDate: currentDate, format: "EEEE, MMM d, yyyy"))
                print(formatTempreture(temp: currentWeather , to: .celsius))
                print(currentDescription)
                
                DispatchQueue.main.async {
                self.consolidatedWeatherCollectionView.reloadData()
                }

            }catch{
                print(error)
            }
        })
    }
    
    func customizeCollectionViews(){
        let consolidatedWeatherCollectionViewLayout = UICollectionViewFlowLayout()
        consolidatedWeatherCollectionViewLayout.scrollDirection = .horizontal
        consolidatedWeatherCollectionViewLayout.minimumInteritemSpacing = 8
        consolidatedWeatherCollectionViewLayout.itemSize = CGSize(width: 200, height: 200)
        consolidatedWeatherCollectionView.collectionViewLayout = consolidatedWeatherCollectionViewLayout
        consolidatedWeatherCollectionView.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consolidatedWeatherList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsolidatedWeatherCell", for: indexPath as IndexPath) as! ConsolidatedWeatherCollectionViewCell
        print(indexPath)
        let currentItem = consolidatedWeatherList?[indexPath.row]
        cell.dateLabel.text = formatdate(currentDate: currentItem?.applicableDate, format: "dd EEEE")
        cell.dateDescriptionLabel.text = currentItem?.weatherStateName
        cell.minTempLabel.text = formatTempreture(temp: currentItem?.minTemp , to: .celsius)
        cell.maxTempLabel.text = formatTempreture(temp: currentItem?.maxTemp , to: .celsius)
        cell.setUrlImage(from: URL(string: "https://www.metaweather.com//static/img/weather/png/64/\(currentItem?.weatherStateAbbr ?? "c").png")!)
        return cell
    }
    
    func formatTempreture(temp: Double?, to outputTempType: UnitTemperature)-> String{
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
            mf.unitOptions = .providedUnit
            let output = Measurement(value: temp ?? 0, unit: UnitTemperature.celsius).converted(to: outputTempType)
            return mf.string(from: output)
    }
    
    func formatdate(currentDate: String?, format: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        let dateString = dateFormatter.date(from: currentDate ?? "2022-01-01")
        let dateTimeStamp  = dateString!.timeIntervalSince1970
        let date = Date(timeIntervalSince1970: Double(dateTimeStamp))
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }


}

