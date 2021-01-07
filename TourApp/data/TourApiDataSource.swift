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
    var leader: String
    var km : String
    var stage : String
    var imgs : [String]
    
    enum CodingKeys: String, CodingKey {
        case date, name, winner = "stage-winner", leader = "stage-leader", km, stage
        case imgs = "stage-images"
    }
    
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

public class TourApiDataSource : ReadOnlyDataSource {
    
    public func getAll() -> [Any] {
        var data : [DomainStageModel] = []
        
        guard let url = URL(string: "https://tourscraping.appspot.com/tour") else {
            print("Invalid URL")
            return data
        }

        let request = URLRequest(url: url)
        
        let d =  URLSession.shared.sendSynchronousRequest(request: request)
        do {
            if(d.0 != nil) {
                let decodedResponse = try JSONDecoder().decode([StageApiModel].self, from: d.0!)
                    
                data = decodedResponse.map { DomainStageModel.init(name: $0.name,
                                                                   winner: $0.winner,
                                                                   leader: $0.leader,
                                                                   images: $0.imgs,
                                                                   description: "",
                                                                   km: $0.km,
                                                                   imgUrl: "",
                                                                   date: "",
                                                                   stage: Int32($0.stage) ?? 0,
                                                                   averageSpeed: "",
                                                                   startFinish: "")}
            }
        } catch  {
            debugPrint("Error while decoding response")
        }
        debugPrint("Network")
        return data
    }
    
}
