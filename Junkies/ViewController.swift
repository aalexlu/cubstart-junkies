//
//  ViewController.swift
//  Junkies
//
//  Created by Alex Lu on 10/18/20.
//  Copyright © 2020 Alexandra Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /** Variable for location; set based on the button pressed by user; passed to corresponding var in MapVC */
    var locationName = ""

    override func viewDidAppear(_ animated: Bool) {
    }
    
    /** IBActions for each button; sets corresponding locationName and performs segue to MapVC */
    @IBAction func chipotlePressed(_ sender: Any) {
        locationName = "Chipotle"
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    @IBAction func tacoBellPressed(_ sender: Any) {
        locationName = "Taco Bell"
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    @IBAction func starbucksPressed(_ sender: Any) {
        locationName = "Starbucks"
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    @IBAction func mcdonaldsPressed(_ sender: Any) {
        locationName = "McDonalds"
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    /** Prepare for segue; passes location to be displayed on map */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapVC = segue.destination as! MapViewController
        mapVC.locationName = locationName
    }
}

