//
//  SongRecomendationView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct SongRecomendationView: View {
    
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var musicManager:MusicManager = MusicManager()
    
    @State var isTab1:Bool = true
    
    var body: some View {
        VStack(){
            HStack(){
                if let profilePhotoData = taskManager.profilePhotoData, let profilePhoto = UIImage(data: taskManager.profilePhotoData!) {
                    Image(uiImage: profilePhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle().foregroundColor(Color("Orange"))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                Text(taskManager.fullName).font(.body).foregroundColor(.white)
                Spacer()
                Button(
                    action:{
                        
                    }
                ){
                    Image(systemName:"square.and.arrow.up").font(.title3).foregroundColor(.white)
                }
            }.padding(.top,10)
            HStack(){
                HStack(){
                    Text("Singers like You").font(.callout).bold().foregroundColor(isTab1 ? .black : .white).padding(10)
                }.background(isTab1 ? .white : .clear).cornerRadius(13).padding(2).onTapGesture{
                    isTab1 = true
                    musicManager.getSongV2()
                    //                    musicManager.getSong(limit: 25)
                }
                HStack(){
                    Text("Songs for You").font(.callout).bold().foregroundColor(!isTab1 ? .black : .white).padding(10)
                }.background(!isTab1 ? .white : .clear).cornerRadius(13).padding(2).onTapGesture{
                    isTab1 = false
                    musicManager.getSongV2()
                    //                    musicManager.getSinger(limit: 5)
                }
            }.background(.black.opacity(0.3)).cornerRadius(15).padding(.top,30)
            
            Text(isTab1 ? "Singers with a vocal range similar to yours:" : "Songs that match your vocal range:").foregroundColor(.white).font(.title3).bold()
                .multilineTextAlignment(.center).padding(.top,20)
            
            if(isTab1){
                ScrollView(.vertical, showsIndicators: false) {
                    if(musicManager.isLoading){
                        
                        HStack(spacing:5){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .font(.body)
                        }.frame(height:20)
                    }else{
                        
                        VStack(spacing: 10) {
                            ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                VStack(){
                                    HStack(){
                                        AsyncImage(url: item.imgSinger) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit).frame(width:80,height:80).cornerRadius(15)
                                        } placeholder: {
                                            ShimmerView().frame(width:80,height:80).cornerRadius(15)
                                        }
                                        
                                        VStack(alignment:.leading,spacing:5){
                                            Text(item.singer).lineLimit(1).font(.title3).bold().foregroundColor(Color("Blue"))
                                            HStack(){
                                                Text(item.desc).lineLimit(1).font(.body).foregroundColor(Color("Blue"))
                                                Spacer()
                                                Button(
                                                    action:{
                                                        musicManager.openAppleMusicSingerV2(artist: item)
                                                    }
                                                ){
                                                    HStack(spacing:3){
                                                        Text("Play").font(.body).foregroundColor(.white)
                                                        Image(systemName:"play.fill").font(.title3).foregroundColor(.white)
                                                    }.padding(.horizontal,10).padding(.vertical,5)
                                                }.background(Color("Blue")).cornerRadius(15)
                                            }
                                        }
                                    }.padding(5)
                                }.frame(maxWidth:.infinity).background(.white).cornerRadius(15)
                                
                                
                            }
                            
                            
                        }.padding(.bottom,130)
                        
                        
                    }
                    
                    
                }.refreshable{
                    musicManager.getSongV2()
                    //                    musicManager.getSong(limit: 25)
                }.padding(.top,20)
            }else{
                ScrollView(.vertical, showsIndicators: false) {
                    if(musicManager.isLoading){
                        
                        HStack(spacing:5){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .font(.body)
                        }.frame(height:20)
                    }else{
                        
                        VStack(spacing: 10) {
                            ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                VStack(){
                                    HStack(){
                                        AsyncImage(url: item.imgSong) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit).frame(width:80,height:80).cornerRadius(15)
                                        } placeholder: {
                                            ShimmerView().frame(width:80,height:80).cornerRadius(15)
                                        }
                                        
                                        VStack(alignment:.leading,spacing:5){
                                            Text(item.title).lineLimit(1).font(.title3).bold().foregroundColor(Color("Blue"))
                                            HStack(){
                                                Text(item.singer).lineLimit(1).font(.body).foregroundColor(Color("Blue"))
                                                Spacer()
                                                Button(
                                                    action:{
                                                        musicManager.openAppleMusicSongV2(song: item)
                                                    }
                                                ){
                                                    HStack(spacing:3){
                                                        Text("Play").font(.body).foregroundColor(.white)
                                                        Image(systemName:"play.fill").font(.title3).foregroundColor(.white)
                                                    }.padding(.horizontal,10).padding(.vertical,5)
                                                }.background(Color("Blue")).cornerRadius(15)
                                            }
                                        }
                                    }.padding(5)
                                }.frame(maxWidth:.infinity).background(.white).cornerRadius(15)
                                
                                
                            }
                            
                            
                        }.padding(.bottom,130)
                        
                        
                    }
                    
                    
                }.refreshable{
                    musicManager.getSongV2()
                    //                    musicManager.getSong(limit: 25)
                }.padding(.top,20)
            }
            
            
            
        }.padding(.horizontal,30).frame(maxWidth:.infinity, maxHeight:.infinity).background(Color("Blue")).onAppear{
        }.onAppear{
            if(isTab1){
                musicManager.getSongV2()
                //                musicManager.getSong(limit: 25)
            }else{
                musicManager.getSongV2()
                //                musicManager.getSinger(limit: 5)
            }
        }
    }
}

struct SongRecomendationView_Previews: PreviewProvider {
    @State var mode:Int = 1
    static var previews: some View {
        SongRecomendationView()
    }
}
