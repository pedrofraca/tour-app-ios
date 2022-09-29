//
//  TourApiDataSource.swift
//  TourApp
//
//  Created by Pedro Fraca on 31.05.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import data

struct StageApiModel: Codable {
    var date: String
    var name: String
    var winner: String
    var km : String
    var stage : Int32
    var images : [String]
    
}

extension URLSession {
    func sendSynchronousRequest(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: (data: Data?, response: URLResponse?, error: Error?)
        let task = self.dataTask(with: request) {
            result = (data: $0, response: $1, error: $2)
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return result
    }
}

public class TourApiDataSource : ReadOnlyDataSourceWithFilter {
    
    public func get(param: Any?) -> Any? {
        var data = getAll().map {$0 as! DomainStage}
        return data.filter { $0.stage == param as! Int32 }
    }
    
    
    public func getAll() -> [Any] {
        var data : [DomainStage] = []
        
        guard let url = URL(string: "https://api.atool.ws/api/stage") else {
            print("Invalid URL")
            return data
        }

        let request = URLRequest(url: url)
        
        let d =  URLSession.shared.sendSynchronousRequest(request: request)
        debugPrint(d)
        do {
            if(d.0 != nil) {
                let decodedResponse = try JSONDecoder().decode([StageApiModel].self, from: d.0!)
                    
                data = decodedResponse.map { DomainStage.init(name: $0.name,
                                                                   stage: $0.stage,
                                                                   winner: $0.winner,
                                                                   leader: "",
                                                                   images: $0.images,
                                                                   description: "",
                                                                   km: $0.km,
                                                                   imgUrl: $0.images[0],
                                                                   profileImgUrl: $0.images[1],
                                                                   date: "",
                                                                   averageSpeed: "",
                                                                   startFinish: "")}
            }
        } catch  {
            debugPrint("Error while decoding response \(error)")
        }
        return data
    }
    
}
