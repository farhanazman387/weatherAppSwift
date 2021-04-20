//
//  WeatherTableViewCell.swift
//  MyWeather
//
//  Created by Farhana Azman on 31/03/2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    //MARK: properties
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //always declare the identifier to call this table view with identifier
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    //ths function is to configure the cell
    func configure(with model: DailyWeather){
        //temperature text label properties
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(model.temp.min)) °c"
        self.highTempLabel.text = "\(Int(model.temp.max)) °c"
        
        //day/date text label properties
        //dt need to be converted because it is formatted in unix format
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: TimeInterval(model.dt)))
        
        //icon image properties
        //self.iconImageView.image = UIImage(named: "Sunny")
        //i got stuck here because i tried to find a way to get data from a nested array model
        //but debugging helps u to see clear where the data is going, and which part that gave u the error
        let weatherArray = [model.weather][0]
        for main in weatherArray{
            if main.main.contains("Clouds") {
                self.iconImageView.image = UIImage(named: "Sunny")
            }
            else if main.main.contains("Rain") {
                self.iconImageView.image = UIImage(named: "Rainy")
            }
        }
        self.iconImageView.contentMode = .scaleAspectFit
        
    }
    
    func getDayForDate(_ date:Date?) -> String{
        guard let inputDate = date else{
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"    //monday
        return formatter.string(from: inputDate)
    }
}
