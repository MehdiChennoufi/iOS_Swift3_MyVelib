//
//  Contract.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import SwiftyJSON

// Propriétés d'un Contrat
struct Contract {
    var countryCode: String
    var name: String
    var commercialName: String
    //var cities: [String]
    
    init(json: JSON) {
        self.countryCode = json["country_code"].stringValue
        self.name = json["name"].stringValue
        self.commercialName = json["commercial_name"].stringValue
        //self.cities = json["cities"].arrayValue
        
    }
}
