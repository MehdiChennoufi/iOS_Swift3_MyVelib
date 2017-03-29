//
//  ViewController.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController {
    
    //MARK: - VARIABLES & CONSTANTES
    var stations = [Station]()
    var contracts = [Contract]()
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        getStationInfo(station: "Paris")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - AUTRES FONCTIONS DU PROGRAMME
    
    // Récupérations des Contrats
    func getContratcInfo() {
        NetworkManager.sharedInstance.getContract { (json: JSON?, error: Error?) in
                        guard error == nil else {
                            print("error occurs")
                            return
                        }
            if let json = json {
                let jsonArray = json.arrayValue
                
                for element in jsonArray {
                    let currentElement = Contract(json: element)
                    self.contracts.append(currentElement)
                    print(self.contracts)
                    
                }
                //print("SUCCESS data is : \(self.stations) ")
            }
            }
    }
    // Récupération des Stations
    func getStationInfo(station: String) {
        NetworkManager.sharedInstance.getStation(station: station) { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error when getting station")
                return
            }
            if let json = json {
                let jsonArray = json.arrayValue
                
                for element in jsonArray {
                    let currentElement = Station(json: element)
                    self.stations.append(currentElement)
                    
                }
                //print("SUCCESS data is : \(self.stations) ")
            }
        }
        
    }
    
    // Segue vers la MapView
    @IBAction func toMapViewVC(_ sender: UIButton) {
       self.performSegue(withIdentifier: "toMapViewVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapViewVC" {
            if let destinationVC = segue.destination as? MapViewVC {
                destinationVC.stations = self.stations
            }
        }
    
}
}
