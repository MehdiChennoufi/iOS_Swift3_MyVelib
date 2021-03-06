//
//  MapViewVC.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewVC: UIViewController {

    // MARK: - VARIABLES & CONSTANTES
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var stations: [Station]?
    let locationManager = CLLocationManager()
    var initialUserLocation: CLLocation?
    
    // Favoris éventuellement sauvegardés
    var favoritesIds = [Int]()
    
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        //Changement de la couleur du Pin de localisation
        self.mapView.tintColor = UIColor.cyan

        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let favoritesIds = PersistanceManager.getFavoriteIds() {
            self.favoritesIds = favoritesIds
        }
        print("\(favoritesIds)")
        addAllAnnotations()
        
        setRadius(location: CLLocation(latitude: (self.stations?.first?.position.lat)!, longitude: (self.stations?.first?.position.long)!))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PersistanceManager.saveFavoritesIds(stationIds: favoritesIds)
        print("\(favoritesIds)")
    }
    
    
    //MARK: - AUTRES FONCTIONS SUR LES ANNOTATIONS ET LA MAP
    
    // Ajout d'une annotation à l'écran
    func addAnnotation(name: String, station: Station, type: StationType) {
        let annotation = Annotation()
        
        annotation.setType(type: type)
        
        annotation.buildFromItem(station)
        mapView.addAnnotation(annotation)
    }
    
    // Ajout de toutes les annotations à l'écran
    func addAllAnnotations() {
        
        print("adding annotations")
        // Supprime les annotations qu'il pourrait déjà y avoir
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Parcours de la liste des stations fournit par l'appel de l'API
        for station in self.stations! {
            if (self.favoritesIds.contains(station.number)) {
                addAnnotation(name: station.name, station: station, type: .favorite)
            }
            else {
                addAnnotation(name: station.name, station: station, type: .standard)
            }
        }
    }

    // Fonction permettant un zoom de la Map à l'affichage
    func setRadius(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        addAllAnnotations()
    }
  
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - FONCTIONS SUR LA LOCALISATION DE L UTILISATEUR
extension MapViewVC: CLLocationManagerDelegate {
    
    //Demande de l'autorisation
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
    // Activation de la localisation par le bouton sur l'écran
    @IBAction func showUserPosition(_ sender: UIButton) {
        requestLocationAccess()
        initUSerLocation()
        self.mapView.showsUserLocation = true
    }
    // Suivi de MAJ de la localisation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location status updated")
        if let lastPosition = locations.last {
            setRadius(location: lastPosition)
            locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: FONCTIONS LIEES AU FONCTIONNEMENT DE LA MAP
extension MapViewVC: MKMapViewDelegate {
    
    // Fonctions pour créer une annotation (pin) personnalisée
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("calling view for")
        if let annotation = annotation as? Annotation {
            
            // Création d'un bouton personnalisé
            let rightButton = UIButton(type: .custom)
            
            rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            // Création d'un label Personnalisé
            let bikeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 28, height: 20))
            bikeLabel.text = ""
            bikeLabel.textColor = UIColor.white
            bikeLabel.textAlignment = .center
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pinView") ?? MKAnnotationView()
            // Identification de l'annotation tappée
            annotationView.annotation = annotation
            
            // Le texte à afficher lors du clic sur l'annotation
            annotationView.canShowCallout = true
            // Affichage du bouton (i) pour le détail, personnalisé en rightButton
            annotationView.rightCalloutAccessoryView = rightButton
            
            
            switch annotation.type {
                
            case .standard:
                rightButton.setImage(#imageLiteral(resourceName: "fleche_creuse"), for: .normal)
                // Image de l'annotation
                annotationView.image = UIImage(named: "station_grise")
            
            case .favorite:
                rightButton.setImage(#imageLiteral(resourceName: "fleche_pleine"), for: .normal)
                annotationView.image = UIImage(named: "station_orange")
                
//            case .home:
//                rightButton.setImage(#imageLiteral(resourceName: "home"), for: .normal)
//                annotationView.image = UIImage(named: "geolocx2")
//            
//            case .work:
//                rightButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
//                annotationView.image = UIImage(named: "geolocx2")
            default:
                rightButton.setImage(#imageLiteral(resourceName: "fleche_creuse"), for: .normal)
                annotationView.image = UIImage(named: "station_grise")
            }
        
            switch segmentedControl.selectedSegmentIndex {
                
            case 0:
                bikeLabel.text = "\(annotation.station!.availableBikeStands)"
            case 1:
                bikeLabel.text = "\(annotation.station!.availableBikes)"
            default :
                bikeLabel.text = ""
            }
            // Dimension de l'image de l'annotation
            annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            annotationView.addSubview(bikeLabel)
            
            return annotationView
            
        } else {
            return nil
        }
    }
    
    // Prends en paramètre l'annotation qui a été cliquée
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotationInView = view.annotation as? Annotation {
            
            if annotationInView.type == .standard {
                self.mapView.removeAnnotation(annotationInView)
                self.addAnnotation(name: annotationInView.title!, station: annotationInView.station!, type: .favorite)
                favoritesIds.append((annotationInView.station?.number)!)
                
            } else if annotationInView.type == .favorite {
                self.mapView.removeAnnotation(annotationInView)
                self.addAnnotation(name: annotationInView.title!, station: annotationInView.station!, type: .standard)
                let indexToDelete = favoritesIds.index(of: annotationInView.station!.number)
                favoritesIds.remove(at: indexToDelete!)
                
            }
        }
    }
}
