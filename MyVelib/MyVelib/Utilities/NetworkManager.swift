//
//  NetworkManager.swift
//  MyVelib
//
//  Created by Mehdi Chennoufi on 3/27/17.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias ServiceResponse = ((JSON?, Error?) -> Void)
class NetworkManager {
    
    
    static let sharedInstance = NetworkManager()
    fileprivate init() {}
    
    // Récupération d'un Contrat
    func getContract(_ completion: @escaping ServiceResponse) {
        
        let finalEndpoint = Params.baseEndpoint+Params.contracts
        let headers = ["Accept": "application/json"]
        let params = [ "apiKey" : Params.apiKey ]
        
        Alamofire.request(finalEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(self.finalEndpoint)
                    //print("DATA \(json)")
                    completion(json, nil)
                }
            case .failure(let error):
                print(error)
                print(finalEndpoint)
                completion(nil, error)
            }
        }
    }
    
    // Récupération d'une Station
    func getStation(station: String, completion: @escaping ServiceResponse) {
        
        let finalEndpoint = Params.baseEndpoint+Params.stations
        let headers = ["Accept": "application/json"]
        let params = ["contract" : station, "apiKey": Params.apiKey]
        
        Alamofire.request(finalEndpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Getting data")
                    print("Data is \(json)")
                    
                    completion(json, nil)
                }
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}




