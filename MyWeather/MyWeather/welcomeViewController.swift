//
//  welcomeViewController.swift
//  MyWeather
//
//  Created by Farhana Azman on 12/04/2021.
//

import UIKit


@IBDesignable class welcomeViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Successfully connect with code"
        print("Hello you are now successfully created controller class for this view")
    }
    
    //MARK: Action
    //button action to go to next view
    @IBAction func goToNextView(_ sender: Any) {
        welcomeLabel.text = "next view clicked :) UI"
        self.performSegue(withIdentifier: "weatherSague", sender: self)
    }

}
