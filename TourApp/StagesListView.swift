//
//  ContentView.swift
//  TourApp
//
//  Created by Pedro Fraca Tarancon on 27.03.20.
//  Copyright © 2020 Pedro Fraca Tarancon. All rights reserved.
//

import SwiftUI
import data
import usecase
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
        
        let repo = StagesRepositoryFactory().build(apiDataSource: TourApiDataSource(), databaseDataSource: StageDatabaseSource(context: theContext))
        
        let networkObservable = Observable<[TourStage]>.create { observer in
            observer.onNext(repo.refresh().map { a in TourStage(id: a.stage, name: a.name, winner: a.winner ?? "", leader: a.leader ?? "", kms: a.km ?? "", imgUrl: a.imgUrl ?? "", profileUrl: a.profileImgUrl ?? "") })
            observer.onCompleted()
            return Disposables.create()
        }
        
        let databaseObservable = Observable<[TourStage]>.create { observer in
            observer.onNext(repo.stages.map { a in TourStage(id: a.stage,name: a.name, winner: a.winner ?? "", leader: a.leader ?? "", kms: a.km ?? "", imgUrl: a.imgUrl ?? "", profileUrl: a.profileImgUrl ?? "") })
            observer.onCompleted()
            return Disposables.create()
        }
        
        Observable.concat(databaseObservable, networkObservable)
            .filter { it in !it.isEmpty }
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

struct StagesListView: View {
    @ObservedObject public var viewModel  = TourStageViewModel(context: (UIApplication.shared.delegate as! AppDelegate).updateContext)
    
    var body: some View {
        Group {
            if viewModel.state == .loading {
                LoadingView()
            } else if viewModel.state == .done {
                if(viewModel.stages.isEmpty) {
                    EmptyView()
                } else {
                    DoneView(stages: viewModel.stages)
                }
            }
        }
    }
}

struct LoadingView : View {
    var body : some View {
        VStack{
            Text("Loading").foregroundColor(.white).font(Font.title).bold()
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.yellow).edgesIgnoringSafeArea(.all)
        
    }
}

struct EmptyView : View {
    var body : some View {
        VStack{
            Text("No Results").foregroundColor(.white).font(Font.title).bold()
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.yellow).edgesIgnoringSafeArea(.all)
    }
}

struct DoneView : View {
    
    let stages: [TourStage]
    
    var body : some View {
        NavigationView {
            ScrollView {
                ForEach(stages, id:\.self) { stage in
                    ZStack{
                        TourStageRowView(stage: stage)
                    }
                }.padding()
            }.padding(.top, 50).background(Color.yellow).edgesIgnoringSafeArea(.all)
        }.accentColor( .white).preferredColorScheme(.dark) // white tint on status bar
    }
}



struct TourStageRowView : View {
    let stage : TourStage
    @State var active : Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            UrlImageView(url : stage.imgUrl, stageId: stage.id).onTapGesture {                
                self.active = true
            }
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(stage.name + " " +  stage.kms + "Kms").foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text("Winner: " + stage.winner).foregroundColor(.white).font(Font.title).bold()
                }.padding()
            }
            NavigationLink(destination: StageDetailView(stage: stage), isActive: self.$active) {
                //EmptyView()
            }
        }
    }
}

struct UrlImageView : View {
    let stageId : Int32
    
    @ObservedObject var imageLoader = ImageLoader()
    @State var image:UIImage = UIImage()
    
    init(url : String, stageId : Int32) {
        self.stageId = stageId
        self.imageLoader.load(urlString: url)
    }
    
    var body : some View {
        ZStack {
            Text("")
                .frame(width:UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.65).background(Color.white)
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width:UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.65 , alignment: .center)
                .clipped()
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
            }
            LinearGradient(gradient: Gradient(colors:[.clear, .black]), startPoint: .top, endPoint: .bottom)
        }.frame(width:UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.65 , alignment: .center).cornerRadius(30)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let stage = TourStage(id: 0, name: "",winner: "",leader: "",kms: "", imgUrl: "")
//        return TourStageRowView(stage: stage, isExpand: false, activeStage: 1)
//    }
//}
