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
   
    @State private var isImagePickerPresented = false
        @State private var selectedImage: UIImage?
    @AppStorage("profilePhoto") var profilePhotoData: Data?
    
    
     @State private var isTrue = true
     @State private var isFalse = false
    
//    @EnvironmentObject var router: Router
    
    func saveProfilePhoto() {
            if let selectedImage = selectedImage,
               let profilePhotoData = selectedImage.jpegData(compressionQuality: 0.8) {
                self.profilePhotoData = profilePhotoData
            }
        }
    
    var body: some View {
        VStack(){
            if(!taskManager.isDashboard){
                VocalRangesTestResultView()
            }else if(taskManager.isSong){
                SongRecomendationView(isSinger: $isFalse)
            }else if(taskManager.isSinger){
                SongRecomendationView(isSinger: $isTrue)
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
                                VStack(){
                                    
                                    HStack(){
                                        Button(
                                            action:{
                                                taskManager.isEditTrue()
                                            }
                                        ){
                                        if let profilePhotoData = profilePhotoData, let profilePhoto = UIImage(data: profilePhotoData) {
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
                                        
                                            Image(systemName:"pencil").font(.body).foregroundColor(.white)
                                        }
                                        Spacer()
                                    }.padding(.top,10)
                                        .sheet(isPresented: $taskManager.isEdit) {
                                            VStack(alignment:.leading, spacing:20){
                                                
                                                HStack(){
                                                    Button(
                                                        action:{
                                                            taskManager.isEditFalse()
                                                        }){
                                                            Text("Cancel").font(.body).foregroundColor(.red)
                                                    }
                                                    Spacer()
                                                    Text("Edit Profile").font(.body).bold()
                                                    Spacer()
                                                    if(taskManager.isLoading){
                                                        ProgressView()
                                                            .progressViewStyle(CircularProgressViewStyle(tint: .black)).padding(0).font(.title).fontWeight(.none)
                                                    }else{
                                                        Button(
                                                            action:{
                                                                
                                                                taskManager.isEditFalse()
                                                            }){
                                                            Text("Done").font(.body)
                                                        }
                                                    }
                                                    
                                                }.padding(.horizontal,20)
                                                
                                                Rectangle().foregroundColor(.black.opacity(0.2)).frame(height:0.5)
                                                
                                                VStack(){
                                                    VStack(alignment:.center){
                                                   
                                                        if let profilePhotoData = profilePhotoData, let profilePhoto = UIImage(data: profilePhotoData) {
                                                                        Image(uiImage: profilePhoto)
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                            .frame(width: 100, height: 100)
                                                                            .clipShape(Circle())
                                                                    } else {
                                                                        Circle().foregroundColor(Color("Orange"))
                                                                            .frame(width: 100, height: 100)
                                                                            .clipShape(Circle())
                                                                    }
                                                        
                                                        
                                                        Button(
                                                            action :{
                                                                isImagePickerPresented = true
                                                            }
                                                        ){
                                                            Text("Edit picture or avatar").font(.callout)
                                                        }
                                                    }.padding(.bottom,20).sheet(isPresented: $isImagePickerPresented, onDismiss: saveProfilePhoto) {
                                                        ImagePicker(selectedImage: $selectedImage)
                                                    }
                                                  
                                                    
                                                    
                                                    HStack(){
                                                        Text("Full Name").foregroundColor(.black).font(.body)
                                                        Spacer()
                                                    }.padding(.bottom,3)
                                                    TextField("", text: $taskManager.fullName).font(.body).padding()
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(.black, lineWidth: 1.5)
                                                        ).foregroundColor(.black).accentColor(.black)
                                                    
                                                }.padding(.horizontal,20)
                                                Spacer()
                                                
                                            }.padding(.vertical,20).frame(maxHeight:.infinity).background(.white).presentationDetents(
                                                [.large, .large]
                                            ).cornerRadius(10)
                                        }
                                    
                                    HStack(){
                                        Text("Dashboard").font(.title2).foregroundColor(.white).bold()
                                        Spacer()
                                    }.padding(.top,10)
                                    Button(
                                        action:{
                                                taskManager.isMenuFalse()
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
                                                    Button(
                                                        action:{
                                                            musicManager.openAppleMusicSongV2(song: item)
                                                        }
                                                    ){
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
                                                        }
                                                    }.foregroundColor(.black)
                                                }.frame(width:100)
                                                
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
                                                    Button(
                                                        action:{
                                                            musicManager.openAppleMusicSingerV2(artist: item)
                                                        }
                                                    ){
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
                                                    }.foregroundColor(.black)
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
                    taskManager.isMenuTrue()
                    print("***")
                    print(taskManager.isMenu)
                    taskManager.isTestFalse()
                    taskManager.isSkipTrue()
                    musicManager.getSongV2()
                    
//                    print("***")
//                    print(router.path)
//                    print(router.path.count)
                    //                    musicManager.getSong(limit:5)
                    //                    musicManager.getSinger(limit:5)
                }
            }
        }.onAppear{
            taskManager.isDashboardTrue()
//            taskManager.vocalType = "Bass"
//            taskManager.vocalRange = "E2 - E4"
        }
    }
    
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
