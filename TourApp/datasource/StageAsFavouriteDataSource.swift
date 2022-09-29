//
//  StageAsFavouriteDataSource.swift
//  TourApp
//
//  Created by pedrofraca on 29/09/2022.
//  Copyright © 2022 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import usecase

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
        let itemToBeSaved = item as! SetStageAsFavoriteParam
        
        let json: [String: Any] = ["stageId": itemToBeSaved.stageId,"username": itemToBeSaved.username,"favouriteState":itemToBeSaved.favouriteState]
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod="PATCH"
        request.httpBody=jsonData
        
        let d =  URLSession.shared.sendSynchronousRequest(request: request)
        
        let responseData = String(data: d.0!, encoding: String.Encoding.utf8)
        debugPrint(responseData)
        
        if let httpResponse = d.1 as? HTTPURLResponse {
              print("statusCode: \(httpResponse.statusCode)")
            if(httpResponse.statusCode==500) {
                return false
            }
            return true
          }
        return false
    }
    
}
