//
//  Utilities.swift
//  MyVelib
//
//  Created by etudiant-06 on 27/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation

extension String {
    var translate :String {
        return NSLocalizedString(self, comment: "")
    }
    
    func trimBefore(_ needle: String)->String {
        var output = self
        if let position = self.range(of: needle) {
            output.removeSubrange(self.startIndex..<position.upperBound)
        }
        return output
    }
    
    /**
     Supprime le numéro et le tiret pour un nom de station
     */
    var getStationName : String? {
        if let index = self.characters.index(of: "-") {
            return self.substring(from: self.index(index, offsetBy: 2))
        } else {
            return nil
        }
    }
}

extension Double {
    func toFormattedString(_ digits : Int) -> String? {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = digits
        
        if let output = formatter.string(from: NSNumber.init(value:self)) {
            return output
        } else {
            return nil
        }
    }
}
