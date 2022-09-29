//
//  StageAsFavouriteDataSource.swift
//  TourApp
//
//  Created by pedrofraca on 29/09/2022.
//  Copyright © 2022 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import data

public class StageAsFavouriteWriteDataSource : WriteDataSource {
    
    public func getAll() -> [Any] {
        //We don't need to implement this at the moment
        return []
    }
    
    
    public func save(item: Any?) -> Bool {
        guard let url = URL(string: "https://api.atool.ws/api/stage") else {
            print("Invalid URL")
            return false
        }

        let json: [String: Any] = ["stageId": 2,"username": "Shervin1","favouriteState":true]
        var request = URLRequest(url: url)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod="PATCH"
        request.httpBody=jsonData
        
        let d =  URLSession.shared.sendSynchronousRequest(request: request)
        
        guard(d.2==nil) else {
            return false
        }
        
        return true
    }
    
}
