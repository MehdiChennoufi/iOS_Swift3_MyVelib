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
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var contracts = [Contract]()
    var screenType = ScreenType.home
    
    var stations = [Station]() {
        didSet {
            if oldValue.count < stations.count {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Récupération des stations
        self.getStationInfo(station: "Paris")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // En fonction du ScreenType, la couleur du fond et les boutons vont changer (1seule vue pour trois fenêtres)
        switch self.screenType {
        case .home:
            self.homeButton.setImage(#imageLiteral(resourceName: "home"), for: .normal)
            view.backgroundColor = UIColor.lightGray
            
        case .work:
            self.homeButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
            view.backgroundColor = UIColor(hex: 0x2D8633)
        case .geoloc:
            self.homeButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
            view.backgroundColor = UIColor(hex: 0xDC0116)
        }
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

//MARK: - GESTION DE LA TABLEVIEW
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stationToDisplay = stations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        
        cell.stationNameLabel.text = "\(stationToDisplay.name)"
        cell.bikeStandsNumberLabel.text = "\(stationToDisplay.availableBikeStands)"
        cell.bikesNumberLabel.text = "\(stationToDisplay.availableBikes)"
        cell.distanceNumberLabel.text = "A remplir"
        
        return cell
    }
    
    
}
