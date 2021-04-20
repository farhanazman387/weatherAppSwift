//
//  weatherWithLineGraph.swift
//  MyWeather
//
//  Created by Farhana Azman on 14/04/2021.
//

import UIKit

class weatherWithLineGraph: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: Action
    @IBAction func backToWeather(_ sender: Any) {
        self.performSegue(withIdentifier: "BcakToWeatherOri", sender: self)
    }
    

}
