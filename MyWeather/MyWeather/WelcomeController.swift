//
//  WelcomeController.swift
//  MyWeather
//
//  Created by Farhana Azman on 09/04/2021.
//

import UIKit
@IBDesignable class WelcomeController : UIStackView{
    //MARK: Properties
    @IBOutlet weak var welcomeLabel:UILabel!
    
    //MARK: Button Action
    @IBAction func welcomeButton(_ sender: UIButton) {
        welcomeLabel.text = "Hello World"
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //call your function here if u want to create something when call this controller
        
        
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        //call your function here
    }
}
