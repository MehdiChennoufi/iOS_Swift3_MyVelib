//
//  StationPin.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    fileprivate var coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    var pinColor: UIColor?
    var title: String?
    var subtitle: String?
    var station: Station?
    var type: StationType = .standard
    
    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
    
    func setType(type: StationType) {
        self.type = type
    }
    
    // Création d'une annotation vis-à-vis de l'item
    func buildFromItem (_ station: Station) {
        self.setCoordinate(CLLocationCoordinate2D(latitude: station.position.lat, longitude: station.position.long))
        self.title = station.name
        self.subtitle = station.adress
        self.station = station
        
        if station.status == "OPEN" {
            self.pinColor = UIColor.red
        }
        else {
            self.pinColor = UIColor(hex: 0xA244D1)
        }
    }    
}

enum StationType {
    
    case standard
    
    case favorite
    
    case home
    
    case work
}
