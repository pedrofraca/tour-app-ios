//
//  ContentView.swift
//  TourApp
//
//  Created by Pedro Fraca Tarancon on 27.03.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import SwiftUI
import data
import CoreData
import RxSwift


enum LoadingState {
       case loading, done, error
   }

class TourStageViewModel: ObservableObject {
    let concurrentBackground = ConcurrentDispatchQueueScheduler.init(qos: .background)
    let main = MainScheduler.instance
    @Published var state : LoadingState = .loading
    @Published var stages : [TourStage] = []
    
    var theContext : NSManagedObjectContext
    let disposeBag = DisposeBag()
    
    init(context : NSManagedObjectContext) {
        theContext = context
        updateStages()
    }
    
    func updateStages() {
        state = .loading
        let repo = StagesRepositoryFactory().build(apiDataSource: TourApiDataSource(), databaseDataSource: StageDatabaseSource(context: theContext))
        
        let networkObservable = Observable<[TourStage]>.create { observer in
            observer.onNext(repo.refresh().map { a in TourStage(id: a.stage, name: a.name, winner: a.winner ?? "", leader: a.leader ?? "", kms: a.km ?? "") })
            observer.onCompleted()
            return Disposables.create()
        }
        
        let databaseObservable = Observable<[TourStage]>.create { observer in
            observer.onNext(repo.stages.map { a in TourStage(id: a.stage,name: a.name, winner: a.winner ?? "", leader: a.leader ?? "", kms: a.km ?? "") })
            observer.onCompleted()
            return Disposables.create()
        }
        
        Observable.concat(databaseObservable, networkObservable)
            .filter { it in it.count>0 }
            .first()
            .asObservable()
            .subscribeOn(concurrentBackground)
            .observeOn(main)
            .subscribe(onNext: { it in self.stages = it ?? []},
                       onCompleted: { [weak self] in
                self?.state = .done
            }).disposed(by: disposeBag)
    }
}

struct ContentView: View {
    @ObservedObject public var viewModel  = TourStageViewModel(context: (UIApplication.shared.delegate as! AppDelegate).updateContext)
    
    var body: some View {
        Group {
            if viewModel.state == .loading {
                LoadingView()
            } else if viewModel.state == .done {
                DoneView(stages: viewModel.stages)
            }
        }
    }
}

struct LoadingView : View {
    var body : some View {
         Text("Loading")
    }
}

struct DoneView : View {
    
    let stages: [TourStage]
    
    var body : some View {
         NavigationView {
             List {
                 ForEach(stages, id:\.self) { stage in
                    ZStack{
                        TourStageRowView(stage: stage).listStyle(PlainListStyle())
                        NavigationLink(destination: StageDetailView(stage: stage)) {
                            EmptyView()
                        }
                        }
                 }
             }.navigationBarTitle(Text("Tour App Stages(\(stages.count))"))
         }
    }
}



struct TourStageRowView : View {
    let stage : TourStage
      var body: some View {
        VStack(alignment: .leading) {
            Image("stage_1")
                .resizable()
            HStack {
                Text("Winner: " + stage.winner).frame(maxWidth: .infinity)
                Spacer()
                Text("Leader: " + stage.leader).frame(maxWidth: .infinity)
            }.background(Color.yellow)
            HStack {
                Text(stage.name)
                Spacer()
                Text("KMs " +  stage.kms)
            }.background(Color("RowStageSection"))
        }.padding(.horizontal, -15)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let stage = TourStage(id: 0, name: "",winner: "",leader: "",kms: "")
        return TourStageRowView(stage: stage)
    }
}
