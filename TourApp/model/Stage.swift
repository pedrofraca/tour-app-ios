//
//  Stage.swift
//  TourApp
//
//  Created by Pedro Fraca on 07.06.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation
import CoreData

public class Stage: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var winner: String?
    @NSManaged public var images: [String]?
}
