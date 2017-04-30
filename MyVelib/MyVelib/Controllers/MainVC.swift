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

class MainVC: UIViewController  {
    
    //MARK: - VARIABLES & CONSTANTES
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userInitialPosition: CLLocation?
    
    var contracts = [Contract]()
    var screenType = ScreenType.home
    
    // FIXME: Favoris éventuellement sauvegardés à exploiter
    var favoritesIds = [Int]()
    
    var stations = [Station]() {
        didSet {
            if screenType == .home && oldValue.count < stations.count {
                self.tableView.reloadData()
            }
        }
    }
    
    // Création d'un Pull To Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainVC.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        
        // Récupération des favoris si disponibles
        if let favoritesIds = PersistanceManager.getFavoriteIds() {
            self.favoritesIds = favoritesIds
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        if stations.count >= 0 {
            self.tableView.reloadData()
        }
        
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
    
    
    //MARK: - SEGUES
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
    
    //MARK:- AUTRES FONCTIONS
    
    // Pour le Pull-To-Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.stations.removeAll()
        
        if let parentVC = self.parent as? PageViewVC {
            print("Calling on parent vc")
            parentVC.getStationInfo(station: "Paris")
        }
        refreshControl.endRefreshing()
    }
    
}

// MARK: - GESTION DE LA TABLEVIEW
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
