//
//  StageDetailView.swift
//  TourApp
//
//  Created by Pedro Fraca on 06.06.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import SwiftUI
import usecase

struct StageDetailView: View {
    
    var stage : TourStage
    @State var tag:Int? = nil
    @State var result:Bool? = nil
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .top) {
                ImageView(url : stage.imgUrl).frame(maxHeight: 300).clipped()
                LinearGradient(gradient: Gradient(colors:[.clear, .black]), startPoint: .top, endPoint: .bottom)
                VStack(alignment: .leading){
                    Spacer()
                    Button(action: {
                        let stageAsFavouriteRepo = FavouritesRepositoryImpl(setFavouriteApi: StageAsFavouriteWriteDataSource(), favouritesListApi: TourApiDataSource())
                        
                        let stageRepo = StagesRepositoryFactory().build(apiDataSource: TourApiDataSource(), databaseDataSource: StageDatabaseSource(context: (UIApplication.shared.delegate as! AppDelegate).updateContext))

                        
                        let a = SetStageAsFavoriteUseCaseImpl(repository: stageAsFavouriteRepo, stageRepository: stageRepo)
                        
                        let param = SetStageAsFavoriteParam(username: "aoeuaoeuaoeuaoe", stageId: 44, favouriteState: true)
                        result = a.invoke(param: param)
                    }) {
                        Text("Mark Favourite").foregroundColor(.white).bold()
                        if(result != nil) {
                            if(!result!) {
                                Text("Error").foregroundColor(.red).bold()
                            } else {
                                Text("Success").foregroundColor(.green).bold()
                            }
                        }
                        
                        
                    }
                    Text(stage.name).foregroundColor(.white).bold()
                }.padding()
               
                }.frame(minWidth: 0, maxWidth: UIScreen.main.bounds.size.width, minHeight: 0, maxHeight: 300)
            VStack(alignment: .leading) {
                Text("Stage Profile").foregroundColor(.black).bold().padding()
                ImageView(url : stage.profileUrl).frame(height: 150).padding()
            }.background(Color.white).padding()
            
            VStack {
                Text("Stage Winner").foregroundColor(.black).bold().padding()
                Text(stage.winner).foregroundColor(.gray).padding()
            }.frame(maxWidth: .infinity).background(Color.white).padding()
            
            NavigationLink(destination: ClassificationView(),tag: 1, selection: $tag) {
            }
            Button(action: {
                self.tag = 1
            }) {
                Text("Show Classification").foregroundColor(.black).bold().padding()
            }
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.yellow)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct StageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StageDetailView(stage : TourStage.init(id: 1, name: "Test Stage", winner : "", leader: "", kms : "", imgUrl: "", profileUrl: ""), result: true)
    }
}
