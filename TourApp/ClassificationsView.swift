//
//  ClassificationsView.swift
//  TourApp
//
//  Created by Pedro Fraca on 24.01.21.
//  Copyright © 2021 Pedro Fraca Tarancon. All rights reserved.
//

import Foundation

import SwiftUI

struct Classification: Identifiable {
    var id = UUID()
    var position: String
    var rider: String
    var time: String
    var country: String
    var team: String
}


struct ClassificationRow: View {
    var classification: Classification
    
    var body: some View {
        Text("\(classification.position) \(classification.rider) (\(classification.country)) \(classification.team) \(classification.time)")
    }
}

struct ClassificationList : View {
    var classification : [Classification]
    
    var body : some View {
        
        return List(classification) { classification in
            ClassificationRow(classification: classification)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.top, 100)
            .background(Color.yellow)
            .edgesIgnoringSafeArea(.all)
        //        ScrollView {
        //            Text("patata")
        ////            VStack{
        ////                EmptyView()
        ////            }.padding(.top, 100)
        ////            ForEach(classification) { classification in
        ////                ClassificationRow(classification: classification)
        ////            }.padding()
        //        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(Color.yellow).edgesIgnoringSafeArea(.all)
        
    }
}

struct ClassificationView : View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.yellow
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        let first = Classification(position: "1", rider: "Indurain", time: "30", country: "ESP", team: "Banesto")
        let second = Classification(position: "2", rider: "Indurain", time: "30", country: "ESP", team: "Banesto")
        let third = Classification(position: "3", rider: "Indurain", time: "30", country: "ESP", team: "Banesto")
        let classifications = [first, second, third]
        
        
        return
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                TabView {
                    ClassificationList(classification: classifications).tabItem {
                        Text("Stage")
                    }
                    
                    ClassificationList(classification: classifications).tabItem {
                        Text("General")
                    }
                    
                    ClassificationList(classification: classifications).tabItem {
                        Text("Mountain")
                    }
                    
                    ClassificationList(classification: classifications).tabItem {
                        Text("Regularity")
                    }
                    
                    ClassificationList(classification: classifications).tabItem {
                        Text("Team")
                    }
                    
                }}.edgesIgnoringSafeArea(.top)
        
    }
    
}
