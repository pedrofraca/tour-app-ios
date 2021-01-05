//
//  StageDetailView.swift
//  TourApp
//
//  Created by Pedro Fraca on 06.06.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import SwiftUI

struct StageDetailView: View {
    
    var stage : TourStage
    
    var body: some View {
        VStack {
            Spacer()
            Text(stage.name)
            Spacer()
        }.background(Color.yellow)
        
    }
}

struct StageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StageDetailView(stage : TourStage.init(id: 1, name: "Test Stage", winner : "", leader: "", kms : ""))
    }
}
