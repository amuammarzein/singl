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
                                                
                                            }
                                        ){
                                            Image(systemName:"pencil").font(.body).foregroundColor(.white)
                                        }
                                        Spacer()
                                    }.padding(.top,10)
                                    
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
                                                ForEach(musicManager.arrSongs, id: \.self) { item in
                                                    
                                                    VStack(){
                                                        
                                                        AsyncImage(url: item.imageUrl) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit).frame(width:100,height:100).cornerRadius(15)
                                                        } placeholder: {
                                                            ShimmerView().frame(width:100,height:100).cornerRadius(15)
                                                        }
                                                        
                                                        VStack(alignment:.leading){
                                                            Text(item.name).lineLimit(1).font(.body).foregroundColor(.white)
                                                            Text(item.artist).lineLimit(1).font(.body).foregroundColor(.white)
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
                                                ForEach(musicManager.arrSingers, id: \.self) { item in
                                                    
                                                    VStack(){
                                                        
                                                        AsyncImage(url: item.imageUrl) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit).frame(width:100,height:100).cornerRadius(15)
                                                        } placeholder: {
                                                            ShimmerView().frame(width:100,height:100).cornerRadius(15)
                                                        }
                                                        
                                                        VStack(alignment:.leading){
                                                            Text(item.name).lineLimit(1).font(.body).foregroundColor(.white)
                                                        }
                                                    }.frame(width:100)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }.padding(.horizontal,30).padding(.bottom,130)
                            
                            
                        }.padding(.top,0).refreshable(){
                            musicManager.getSong(limit:5)
                            musicManager.getSinger(limit:5)
                        }
                    }.background(Color("Blue")).frame(maxWidth:.infinity, maxHeight:.infinity)
                }.onAppear{
                    taskManager.isTestFalse()
                    taskManager.isSkipTrue()
                    musicManager.getSong(limit:5)
                    musicManager.getSinger(limit:5)
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
