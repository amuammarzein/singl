//
//  DashboardView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var musicManager:MusicManager = MusicManager()
    var body: some View {
        VStack(){
            if(!taskManager.isDashboard){
                VocalRangesTestResultView()
            }else if(taskManager.isSong){
                SongRecomendationView()
            }else if(taskManager.isSinger){
                SongRecomendationView()
            }else{
                VStack(){
                    ZStack(){
                        VStack(){
                            HStack(){
                                Spacer()
                                Image("HomeTop").resizable().scaledToFit().frame(width:250)
                            }
                            Spacer()
                        }.ignoresSafeArea()
                        ScrollView(){
                            
                            VStack(){
                                VStack(spacing:20){
                                    
                                    HStack(){
                                        Circle().foregroundColor(Color("Orange")).frame(width:40)
                                        Text(taskManager.fullName).font(.body).foregroundColor(.white)
                                        Button(
                                            action:{
                                                taskManager.isEditTrue()
                                            }
                                        ){
                                            Image(systemName:"pencil").font(.body).foregroundColor(.white)
                                        }
                                        Spacer()
                                    }.padding(.top,10)
                                        .sheet(isPresented: $taskManager.isEdit) {
                                            VStack(alignment:.leading, spacing:20){
                                                Text("Full Name").foregroundColor(.black).font(.body)
                                                TextField("", text: $taskManager.fullName).font(.body).padding()
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(.black, lineWidth: 1.5)
                                                    ).foregroundColor(.black).accentColor(.black)
                                               
                                                if(taskManager.isLoading){
                                                    //                                                                                        LoadingView()
                                                }else{
                                                    Button(action: {
                                                        //               updateData()
                                                    }) {
                                                        Text("Update Profile").font(.body).fontWeight(.none).foregroundColor(Color.black).padding(15).frame(maxWidth:.infinity).background(Color.white).cornerRadius(10)                                 }.alert(isPresented: $taskManager.isAlert) {
                                                            Alert(
                                                                title: Text("Notification"),
                                                                message: Text(taskManager.msg),
                                                                dismissButton: .default(Text("OK"))
                                                            )
                                                        }
                                                }
                                                Spacer()
                                                
                                            }.padding(20).frame(maxHeight:.infinity).background(.white).presentationDetents(
                                                [.large, .large]
                                            ).cornerRadius(10)
                                        }
                                    
                                    HStack(){
                                        Text("Dashboard").font(.title2).foregroundColor(.white).bold()
                                        Spacer()
                                    }.padding(.top,10)
                                    Button(
                                        action:{
                                            taskManager.isDashboardFalse()
                                        }
                                    ){
                                        VStack(){
                                            ZStack(){
                                                VStack(spacing:5){
                                                    HStack(){
                                                        Text("Your Vocal Range:").font(.body).foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                    HStack(){
                                                        Text(taskManager.vocalRange).font(.title).fontWeight(.heavy).foregroundColor(.black)
                                                        Spacer()
                                                    }.padding(.bottom,20)
                                                    HStack(){
                                                        Text("Your Vocal Type:").font(.body).foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                    HStack(){
                                                        Text(taskManager.vocalType).font(.title).fontWeight(.heavy).foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                }.padding(20).padding(.top,20).padding(.bottom,20)
                                                VStack(){
                                                    HStack(){
                                                        Spacer()
                                                        Image("LogoText").resizable().scaledToFit().frame(width:60)
                                                    }.padding(20)
                                                    Spacer()
                                                    HStack(){
                                                        Spacer()
                                                        Image("HomeCard").resizable().scaledToFit().frame(width:100)
                                                    }
                                                }
                                            }
                                        }.frame(maxWidth:.infinity).background(.white).cornerRadius(20)
                                    }
                                    
                                    HStack(){
                                        Text("Top 3 Song Recommendation").font(.body).bold().foregroundColor(.white)
                                        Spacer()
                                        Button(action:{
                                            taskManager.isSongTrue()
                                        }){
                                            Text("See All").font(.callout).foregroundColor(.white.opacity(0.6))
                                        }
                                    }.padding(.top,10)
                                    
                                    if(musicManager.isLoading){
                                        
                                        HStack(spacing:5){
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .font(.body)
                                        }.frame(height:170)
                                    }else{
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 10) {
                                                ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                                    
                                                    VStack(){
                                                        
                                                        AsyncImage(url: item.imgSong) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit).frame(width:100,height:100).cornerRadius(15)
                                                        } placeholder: {
                                                            ShimmerView().frame(width:100,height:100).cornerRadius(15)
                                                        }
                                                        
                                                        VStack(alignment:.leading){
                                                            Text(item.title).lineLimit(1).font(.body).foregroundColor(.white)
                                                            Text(item.singer).lineLimit(1).font(.body).foregroundColor(.white)
                                                        }
                                                    }.frame(width:100)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    HStack(){
                                        Text("Singers with similar vocals to yours").font(.body).bold().foregroundColor(.white)
                                        Spacer()
                                        Button(action:{
                                            taskManager.isSingerTrue()
                                        }){
                                            Text("See All").font(.callout).foregroundColor(.white.opacity(0.6))
                                        }
                                    }.padding(.top,10)
                                    
                                    if(musicManager.isLoading){
                                        
                                        HStack(spacing:5){
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .font(.body)
                                        }.frame(height:170)
                                    }else{
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 10) {
                                                ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                                    
                                                    VStack(){
                                                        
                                                        AsyncImage(url: item.imgSinger) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit).frame(width:100,height:100).cornerRadius(15)
                                                        } placeholder: {
                                                            ShimmerView().frame(width:100,height:100).cornerRadius(15)
                                                        }
                                                        
                                                        VStack(alignment:.leading){
                                                            Text(item.singer).lineLimit(1).font(.body).foregroundColor(.white)
                                                        }
                                                    }.frame(width:100)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }.padding(.horizontal,30).padding(.bottom,130)
                            
                            
                        }.padding(.top,0).refreshable(){
                            musicManager.getSongV2()
                            //                            musicManager.getSong(limit:5)
                            //                            musicManager.getSinger(limit:5)
                        }
                    }.background(Color("Blue")).frame(maxWidth:.infinity, maxHeight:.infinity)
                }.onAppear{
                    taskManager.isTestFalse()
                    taskManager.isSkipTrue()
                    musicManager.getSongV2()
                    //                    musicManager.getSong(limit:5)
                    //                    musicManager.getSinger(limit:5)
                }
            }
        }.onAppear{
            taskManager.isDashboardTrue()
        }
    }
    
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
