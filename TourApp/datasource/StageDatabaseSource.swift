//
//  File.swift
//  TourApp
//
//  Created by Pedro Fraca on 31.05.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import data
import CoreData

class StageDatabaseSource : WriteDataSource {
    var theContext : NSManagedObjectContext
    
    init(context : NSManagedObjectContext) {
        theContext = context
    }
    
    func save(item: Any?) {
        let domainStage = item as! DomainStageModel
        let stage = Stage(context: theContext)
        stage.name = domainStage.name
        stage.id = domainStage.stage
        stage.winner = domainStage.winner
        stage.images = domainStage.images
        stage.kms = domainStage.km
        stage.leader = domainStage.leader
        do {
            try theContext.save()
        } catch {
            let nserror = error as NSError
            debugPrint(nserror)
        }
    }
    
     func getAll() -> [Any] {
        let fetchRequest = NSFetchRequest<Stage>(entityName: "Stage")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Stage.id), ascending: true)]
        let objects = try? theContext.fetch(fetchRequest)
        var data : [DomainStageModel] = []

        if let values = objects {
            data = values.map {
                DomainStageModel.init(name: $0.name ?? "",
                winner: $0.winner,
                leader: "",
                images: $0.images,
                description: "",
                km: $0.kms,
                imgUrl: $0.images?[0],
                profileImgUrl: $0.images?[1],
                date: "",
                stage: 0,
                averageSpeed: "",
                startFinish: "")
            }
        }
        return data
    }    
}
