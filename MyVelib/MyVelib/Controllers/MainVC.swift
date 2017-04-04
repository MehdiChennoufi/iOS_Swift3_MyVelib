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
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate  {
    
    //MARK: - VARIABLES & CONSTANTES
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var contracts = [Contract]()
    var screenType = ScreenType.home
    
    var locationManager = CLLocationManager()
    var userInitialPosition: CLLocation?
    
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(MainVC.handleRefresh), for: UIControlEvents.valueChanged)
//        
//        return refreshControl
//    }()
    
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
        self.locationManager.delegate = self
        //self.tableView.addSubview(self.refreshControl)
        
        // Récupération des stations
        self.getStationInfo(station: "Paris")
        
        // Récupération de la position de l'utilisateur selon son autorisation
        initUSerLocation()
        requestLocationAccess()        
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
    
    // Demande de l'autorisation d'utiliser la localisation
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }        
    }
    // Initialisation de la localisation
    func initUSerLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAccess()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userInitialPosition = location
        }
    }
    
    // Récupérations des Contrats
    func getContratcInfo() {
        // Appel réseau
        NetworkManager.sharedInstance.getContract { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error occurs")
                return
            }
            if let json = json {
                let jsonArray = json.arrayValue
                
                // Traitement des données
                for element in jsonArray {
                    let currentElement = Contract(json: element)
                    self.contracts.append(currentElement)
                    print(self.contracts)
                }
            }
        }
    }
    
    // Récupération des Stations et trie par distance si possible
    func getStationInfo(station: String) {
        // Appel réseau
        NetworkManager.sharedInstance.getStation(station: station) { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error when getting station")
                return
            }
            if let json = json {
                let jsonArray = json.arrayValue
                
                // Traitement des données
                for element in jsonArray {
                    var currentElement = Station(json: element)
                    // Si nous avons la localisation de l'utilisateur alors nous définissons la distance de la station par rapport à lui
                    if self.userInitialPosition != nil {
                        currentElement.setDistanceToUser(userPosition: self.userInitialPosition!)
                    }
                    self.stations.append(currentElement)
                    // Trie du tableau par la distance
                    self.stations.sort{$0.distanceToUser < $1.distanceToUser}
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
                // Envoi de la Station et de la position de l'utilisateur (optionnelle)
                destinationVC.stations = self.stations
                if self.userInitialPosition != nil {
                    destinationVC.initialUserLocation = self.userInitialPosition!
                }
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
        cell.distanceNumberLabel.text = "\(stationToDisplay.distanceToUser.toFormattedString(0)!) m"
        
        return cell
    }
    

    
}
