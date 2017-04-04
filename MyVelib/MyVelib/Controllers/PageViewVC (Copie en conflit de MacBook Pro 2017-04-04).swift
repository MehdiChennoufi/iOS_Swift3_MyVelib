//
//  PageViewVC.swift
//  MyVelib
//
//  Created by etudiant-06 on 30/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class PageViewVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource,CLLocationManagerDelegate {

    var pages = [UIViewController]()
    var contracts = [Contract]()
    var stations = [Station]()
    var locationManager = CLLocationManager()
    var userInitialPosition: CLLocation?
    
    // Favoris éventuellement sauvegardés
    var favoritesIds = [Int]()
    
    var p0 : MainVC?
    var p1 : MainVC?
    var p2 : MainVC?
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.locationManager.delegate = self
        
        // Lecture des favoris
        if let favoritesIds = PersistanceManager.getFavoriteIds() {
            self.favoritesIds = favoritesIds
        }
        
        // Récupération de la position de l'utilisateur selon son autorisation
        initUSerLocation()
        requestLocationAccess()
        getStationInfo(station: "Paris")
        
        p0 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p0!.screenType = .home
        
        p1 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p1!.screenType = .work
        
        p2 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p2!.screenType = .geoloc
        
        pages = [p0!, p1!, p2!]
        setViewControllers([p0!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

    }
    
    //MARK: - RECUPÉRATION DES DONNÉES
    
    // Les Contracts
    func getContratcInfo() {
        // Appel réseau
        // Mettre une animation
        NetworkManager.sharedInstance.getContract { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error occurs")
                return
            }
            // Arreter l'animation
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
    
    // Les Stations avec trie par distance si possible
    func getStationInfo(station: String) {
        self.stations.removeAll()
        // Appel réseau
        print("Appel réseau")
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
                    self.p0!.stations = self.stations
                    self.p1!.stations = self.stations
                    self.p2!.stations = self.stations
                }
            }
        }
    }
    
    //MARK: - LOCALISATION UTILISATEUR
    
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

    //MARK: - FONCTIONS POUR LA TABLEVIEW
    
    /*** Fonction pour renvoyer le ViewController situé AVANT le controller actuel. Renvoi Nil si
     c'est le premier ***/
    
    // recupère l'index du controller actuel dans le tableau
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == 0 {
            return nil
        }
        else {
            return pages[currentIndex-1]
        }
    }
    
    // Renvoi le ViewController situé APRES le controller actuel. Renvoi Nil si c'est le dernier.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == pages.count-1 {
            return nil
        }
        else {
            return pages[currentIndex+1]
        }
    }
    
    // MARK: - AFFICHAGE DES DOTS
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.pages.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
}
