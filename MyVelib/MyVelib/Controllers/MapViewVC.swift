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

    //MARK: - VARIABLES & CONSTANTES
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var stations: [Station]?
    let locationManager = CLLocationManager()
    
    //MARK: - FONCTIONS DE LA VUE
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        addAllAnnotations()
        
        setDiameter(location: CLLocation(latitude: (self.stations?.first?.position.lat)!, longitude: (self.stations?.first?.position.long)!))
    }
    
    //MARK: - AUTRES FONCTIONS DU PROGRAMME
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
    
    // Ajout d'une annotation à l'écran
    func addAnnotation(name: String, station: Station) {
        let annotation = StationPin()
        
        annotation.buildFromItem(station)
        mapView.addAnnotation(annotation)
        
    }
    
    // Ajout de toutes les annotations à l'écran
    func addAllAnnotations() {
        // Supprime les annotations qu'il pourrait déjà y avoir
        self.mapView.removeAnnotations(self.mapView.annotations)
        // Parcours de la liste des stations fournit par l'appel de l'API
        for station in self.stations! {
            addAnnotation(name: station.name, station: station)
        }
    }

    // Fonction permettant un zoom de la Map à l'affichage
    func setDiameter(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        addAllAnnotations()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let segue.identifier == "DetailVC" {
//            if let destinationVC = segue.destination as? DetailVC {
//                destinationVC.stationPin =
//            }
//        }
//    }
   
    
}

extension MapViewVC: MKMapViewDelegate {
    
    // Fonctions pour créer une annotation (pin) personnalisée
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? StationPin {
            
            // Création d'un bouton personnalisé
            let rightButton = UIButton(type: .custom)
            
            rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            switch annotation.type {
                
            case .standard:
                rightButton.setImage(#imageLiteral(resourceName: "fleche_creuse"), for: .normal)
            case .home:
                rightButton.setImage(#imageLiteral(resourceName: "home"), for: .normal)
            case .favorite:
                rightButton.setImage(#imageLiteral(resourceName: "fleche_pleine"), for: .normal)
            case .work:
                rightButton.setImage(#imageLiteral(resourceName: "work"), for: .normal)
            }
            
            // Création d'un label Personnalisé
            let bikeLabel = UILabel(frame: CGRect(x: 5, y: -2, width: 28, height: 30))
            bikeLabel.text = ""
            bikeLabel.textColor = UIColor.white
            bikeLabel.textAlignment = .center
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pinView") ?? MKAnnotationView()
            // Identification de l'annotation tappée
            annotationView.annotation = annotation
            // Image de l'annotation
            annotationView.image = UIImage(named: "station_orange")
            // Le texte à afficher lors du clic sur l'annotation
            annotationView.canShowCallout = true
            // Affichage du bouton (i) pour le détail, personnalisé en rightButton
            annotationView.rightCalloutAccessoryView = rightButton
            // Dimension de l'image de l'annotation
            annotationView.frame.size = CGSize(width: 40, height: 40)
            //Positionnement de l'annotation sur l'écran
            //annotationView.centerOffset = CGPoint(x: 0, y: -22)
            
        
            annotationView.addSubview(bikeLabel)
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                bikeLabel.text = "\(annotation.station!.availableBikeStands)"
            case 1:
                bikeLabel.text = "\(annotation.station!.availableBikes)"
            default :
                bikeLabel.text = ""
            }
            
            return annotationView
            
        } else {
            return nil
        }
    }
    
    // Prends en paramètre l'annotation qui a été cliquée
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegue(withIdentifier: "DetailVC", sender: self)
        }
    
    
    
}
