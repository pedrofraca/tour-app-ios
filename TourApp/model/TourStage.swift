//
//  TourStage.swift
//  TourApp
//
//  Created by Pedro Fraca on 07.06.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation

struct TourStage : Identifiable, Hashable {
    let id : Int32
    let name, winner, leader, kms : String
}
