//
//  Model.swift
//  MyVelib
//
//  Created by etudiant-06 on 29/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation

enum ScreenType {
    case home
    case work
    case geoloc
    
    var description: String {
        switch self {
        case .home:
            return "Home"
        case .work:
            return "Work"
        case .geoloc:
            return "Geoloc"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "home"
        case .work:
            return "work"
        case .geoloc:
            return "geoloc"
        }
    }
    
    // clé utilisée pour la persistance sur UserDefaults
    var userDefaultsKey: String {
        switch self {
        case .home :
            return "homeStations"
        case .work :
            return "workStations"
        case .geoloc :
            return "geolocStations"
        }
    }
}
