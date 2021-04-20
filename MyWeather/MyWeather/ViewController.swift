//
//  ViewController.swift
//  MyWeather
//
//  Created by Farhana Azman on 31/03/2021.
//

import UIKit
import CoreLocation
//Location: CoreLocation
//table view for weather list
//custom cell : collection view
//API / request to get the data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var table:UITableView!
    
    //MARK: Actions
    @IBAction func goBackToFirstPage(_ sender: Any) {
        self.performSegue(withIdentifier: "WeatherHomeSergue", sender: self)
    }
    @IBAction func goToGraphPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "WeatherWithGraph", sender: self)
    }
    
    var Models = [DailyWeather]()
    var hourlyModels = [HourlyWeather]()
    
    let locationManager = CLLocationManager()
    //to capture current coordinate of the user
    var currentLocation: CLLocation?
    var current: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        //Register 2 cells
//        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        self.table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        self.table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        table.delegate=self
        table.dataSource=self
        
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupLocation()
    }
    
    //Location
    func setupLocation(){
        locationManager.delegate=self
        //to allow location when the apps is in use
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()//to save battery life
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation(){
//        guard let currentLocation = currentLocation else{
//            return
//        }
//        let long = currentLocation.coordinate.longitude
//        let lat = currentLocation.coordinate.latitude
        //API url
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=3.1516964&lon=101.6942371&exclude=minutely,alerts&units=metric&appid=56b8d825a9fca36f51971140f0de174c"
        //this let u to use current location
        //let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&units=metric&appid=56b8d825a9fca36f51971140f0de174c"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            //Validation
            guard let data = data, error == nil else{
                print("Something went wrong please contact your manager.")
                return
            }
            
            //Convert data to models/ object
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
            }
            catch{
                print("error after decoding weatherResponse: \(error)")
            }
            
            guard let result = json else{
                return
            }
            
            // get daily weather data
            let entries = result.daily
            self.Models.append(contentsOf: entries)
            //assign the current data so that we can use it
            let currentData = result.current
            self.current = currentData
            
            //self.hourlyModels = result.hourly
            self.hourlyModels.append(contentsOf: result.hourly)
            
            //Update user interface
            DispatchQueue.main.async { [self] in
                //using dispatchqueue is to tell that makesure to execute on the main thread
                // makesure to wrap the table in it to reload
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
                
            }
            
        }).resume()
        //print out longitude and latitude
        //print("\(long)|\(lat)")
    }
    
    //Table functionality
    //Table Header
    func createTableHeader() -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:350))
        
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))

        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Current Location"

//        guard let currentWeather = self.current else {
//            print("no data")
//            return UIView()
//        }
        tempLabel.text = "\(String(describing: self.current!.temp))°c"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        
        let summary = [self.current!.weather][0]
        
        for case let data in summary{
            summaryLabel.text = String(describing: data.main)
        }
        
        return headerView
    }
    
    //Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return Models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: Models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//codable is used to enable json decoder decode the data
struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [WeatherDecission]
    let rain: HourlyRain?
}

struct WeatherDecission: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct DailyWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: DailyTempreture
    let feels_like: DailyFeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let wind_speed: Float
    let wind_deg:Int
    let weather: [WeatherDecission]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double
}

struct DailyTempreture: Codable{
    let day: Float
    let min: Float
    let max: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct DailyFeelsLike: Codable {
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Float
    let wind_gust:Double
    let weather: [WeatherDecission]
    let pop: Double
    let rain: HourlyRain?
}

struct  HourlyRain: Codable {
    let _1h:Double
    //to map your variable to your actual data using 'CodingKey'
    private enum CodingKeys : String, CodingKey { case _1h = "1h"}
}
