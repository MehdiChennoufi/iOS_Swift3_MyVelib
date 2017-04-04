//
//  Station.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

// Propriétés d'une Station
struct Station {
    var number: Int
    var name: String
    var contractName: String
    var adress: String
    var position: (long: Double, lat: Double)
    var availableBikeStands: Int
    var availableBikes: Int
    var status: String
    var distanceToUser: Double
    
    // Calcul pour la distance de la station par rapport à l'utilisateur
    mutating func setDistanceToUser (userPosition: CLLocation) {
        let position = CLLocation(latitude: self.position.lat, longitude: self.position.long)
        self.distanceToUser = userPosition.distance(from: position)
    }
    
    // Initialisation du JSON
    init(json: JSON) {
        self.number = json["number"].intValue
        self.name = json["name"].stringValue
        self.contractName = json["contract_name"].stringValue
        self.adress = json["adress"].stringValue
        self.position.lat = json["position"]["lat"].doubleValue
        self.position.long = json["position"]["lng"].doubleValue
        self.availableBikeStands = json["available_bike_stands"].intValue
        self.availableBikes = json["available_bikes"].intValue
        self.status = json["status"].stringValue
        self.distanceToUser = 0.0
    }
    
}
