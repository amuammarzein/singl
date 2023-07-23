//
//  VocalRangesTestResultView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct VocalRangesTestResultView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var musicManager:MusicManager = MusicManager()
    
    @State var items: [Any] = []
    
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if(taskManager.isNext){
            DashboardView()
        }else if(taskManager.isBack){
            if(taskManager.isTest){
                VocalRangesTestView()
            }else{
                DashboardView()
            }
        }else{
            VStack(){
                HStack(spacing:0){
                    Button(
                        action:{
                            taskManager.isMenuTrue()
                            taskManager.isBackTrue()
                        }){
                            Image(systemName:"chevron.left").foregroundColor(.white).font(.title3).fontWeight(.bold)
                            Text("Back").font(.body).foregroundColor(.white).fontWeight(.bold)
                        }
                    Spacer()
                    Button(
                        action:{
                            self.items.removeAll()
                            
                            guard let resultImage = ImageRenderer(content: shareView).uiImage else {
                                return
                            }
                            self.items.append(resultImage)
                            
                            taskManager.isShareTrue()
                        }
                    ){
                        Image(systemName:"square.and.arrow.up").font(.title3).foregroundColor(.white)
                    }
                }.padding(.top,10).padding(.horizontal,30)
                ScrollView(){
                    cardResultView
                    VStack(){
                        if(taskManager.isTest){
                            VStack(){
                                Button(
                                    action:{
                                        taskManager.selectedTabIndex = 0
                                        taskManager.isMenuTrue()
                                        taskManager.isNextTrue()
                                    }){
                                        Text("Explore More!").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                                    }.frame(maxWidth:.infinity).background(.white).cornerRadius(30)
                                
                                //                                Button(
                                //                                    action:{
                                //                                        taskManager.isBackTrue()
                                //                                    }){
                                //                                        Text("Test again").foregroundColor(.white).font(.body).bold().padding(20)
                                //                                    }.frame(maxWidth:.infinity)
                            }.padding(30)
                        }else{
                            VStack(){
                                Button(
                                    action:{
                                        self.items.removeAll()
                                        
                                        guard let resultImage = ImageRenderer(content: shareView).uiImage else {
                                            return
                                        }
                                        self.items.append(resultImage)
                                        
                                        taskManager.isShareTrue()
                                    }){
                                        Text("Share to your story!").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                                    }.frame(maxWidth:.infinity).background(.white).cornerRadius(30)
                                
                                    .sheet(isPresented: $taskManager.isShare) {
                                        ShareSheetView(items: items).edgesIgnoringSafeArea(.all)
                                    }
                                
                            }.padding(30)
                            
                        }
                    }.padding(.bottom,0)
                    
                }
            }.frame(maxWidth: .infinity,maxHeight:.infinity).background(Color("Blue")).onAppear{
                musicManager.getSongV2()
            }
        }
        
    }
    
    var cardResultView: some View {
        ZStack(){
            Image("CardShareFrame").resizable().scaledToFit().frame(maxWidth:.infinity).padding(0)
            VStack(spacing:7){
                Text("Your Vocal\n Range is:").font(.title3).bold().multilineTextAlignment(.center)
                Text(taskManager.vocalRange).font(.largeTitle).fontWeight(.heavy)
                Text("Your Vocal\n Type is:").font(.title3).bold().multilineTextAlignment(.center)
                Text(taskManager.vocalType).font(.largeTitle).fontWeight(.heavy)
                Text("Look, We’ve Found Similar Singers To You:").font(.title3).bold().multilineTextAlignment(.center)
                
                if(musicManager.arrSongsV2.count > 0){
                    HStack(){
                        ZStack(){
                            Rectangle().foregroundColor(Color("Navy")).frame(width:.infinity).cornerRadius(50).offset(x:+20)
                            HStack(){
                                Spacer()
                                Text(musicManager.arrSongsV2[0].singer).foregroundColor(.white).bold().padding(.trailing,0)
                            }
                        }.frame(width:CGFloat(screenWidth/2),height:40).background(Color("Navy"))
                        Spacer()
                    }
                }
                if(musicManager.arrSongsV2.count > 1){
                    HStack(){
                        ZStack(){
                            Rectangle().foregroundColor(Color("Blue")).frame(width:.infinity).cornerRadius(50).offset(x:+20)
                            HStack(){
                                Spacer()
                                Text(musicManager.arrSongsV2[1].singer).foregroundColor(.white).bold().padding(.trailing,0)
                            }
                        }.frame(width:CGFloat(screenWidth/2.3),height:40).background(Color("Blue"))
                        Spacer()
                    }
                }
                if(musicManager.arrSongsV2.count > 2){
                    HStack(){
                        ZStack(){
                            Rectangle().foregroundColor(Color("Green")).frame(width:.infinity).cornerRadius(50).offset(x:+20)
                            HStack(){
                                Spacer()
                                Text(musicManager.arrSongsV2[2].singer).foregroundColor(.white).bold().padding(.trailing,0)
                            }
                        }.frame(width:CGFloat(screenWidth/2.6),height:40).background(Color("Green"))
                        Spacer()
                    }
                }
                
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
                    Text(taskManager.fullName).font(.body).foregroundColor(.black)
                }
                
            }.padding(.horizontal,CGFloat(screenWidth/6.6)).padding(.top,10)
        }
    }
    
    @State var screenWidthShare:CGFloat = 2000
    @State var screenHeightShare:CGFloat = 4330.18
    @State var fontSizeTitle:CGFloat = 2000/15
    @State var fontSizeBody:CGFloat = 2000/25
    @State var fontSizeDesc:CGFloat = 2000/23
    @State var fontSizeCallout:CGFloat = 2000/45
    @State var padding:CGFloat = 2000/45
    
    var shareView: some View {
        VStack(){
            ZStack(){
                Image("CardShareFrame").resizable().scaledToFit().frame(maxWidth:.infinity).padding(0)
                VStack(spacing:padding){
                    Text("Your Vocal\n Range is:").font(.system(size: fontSizeBody)).bold().multilineTextAlignment(.center)
                    Text(taskManager.vocalRange).font(.system(size: fontSizeTitle)).fontWeight(.heavy).padding(.bottom,padding)
                    Text("Your Vocal\n Type is:").font(.system(size: fontSizeBody)).bold().multilineTextAlignment(.center)
                    Text(taskManager.vocalType).font(.system(size: fontSizeTitle)).fontWeight(.heavy).padding(.bottom,padding)
                    Text("Look, We’ve Found Similar Singers To You:").font(.system(size: fontSizeBody)).bold().multilineTextAlignment(.center)
                    
                    if(musicManager.arrSongsV2.count > 0){
                        HStack(){
                            ZStack(){
                                Rectangle().foregroundColor(Color("Navy")).frame(width:.infinity).cornerRadius(250).offset(x:+screenWidthShare/20)
                                HStack(){
                                    Spacer()
                                    Text(musicManager.arrSongsV2[0].singer).foregroundColor(.white).bold().padding(.trailing,0).lineLimit(1).font(.system(size: fontSizeDesc))
                                }
                            }.frame(width:CGFloat(screenWidthShare/2),height:CGFloat(screenWidthShare/10)).background(Color("Navy"))
                            Spacer()
                        }
                    }
                    if(musicManager.arrSongsV2.count > 1){
                        HStack(){
                            ZStack(){
                                Rectangle().foregroundColor(Color("Blue")).frame(width:.infinity).cornerRadius(250).offset(x:+screenWidthShare/20)
                                HStack(){
                                    Spacer()
                                    Text(musicManager.arrSongsV2[1].singer).foregroundColor(.white).bold().padding(.trailing,0).lineLimit(1).font(.system(size: fontSizeDesc))
                                }
                            }.frame(width:CGFloat(screenWidthShare/2.3),height:CGFloat(screenWidthShare/10)).background(Color("Blue"))
                            Spacer()
                        }
                    }
                    if(musicManager.arrSongsV2.count > 2){
                        HStack(){
                            ZStack(){
                                Rectangle().foregroundColor(Color("Green")).frame(width:.infinity).cornerRadius(250).offset(x:+screenWidthShare/20)
                                HStack(){
                                    Spacer()
                                    Text(musicManager.arrSongsV2[2].singer).foregroundColor(.white).bold().padding(.trailing,0).lineLimit(1).font(.system(size: fontSizeDesc))
                                }
                            }.frame(width:CGFloat(screenWidthShare/2.6),height:CGFloat(screenWidthShare/10)).background(Color("Green"))
                            Spacer()
                        }
                    }
                    
                    HStack(spacing:padding){
                        if let profilePhotoData = taskManager.profilePhotoData, let profilePhoto = UIImage(data: taskManager.profilePhotoData!) {
                            Image(uiImage: profilePhoto)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidthShare/10, height: screenWidthShare/10)
                                .clipShape(Circle())
                        } else {
                            Circle().foregroundColor(Color("Orange"))
                                .frame(width: screenWidthShare/10, height: screenWidthShare/10)
                                .clipShape(Circle())
                        }
                        Text(taskManager.fullName).font(.system(size: fontSizeDesc)).foregroundColor(.black)
                    }.padding(.top,padding)
                    
                }.padding(.horizontal,CGFloat(screenWidthShare/6.6)).padding(.vertical,10)
            }
        }.frame(width:screenWidthShare,height:screenHeightShare).background(Color("Blue")).onAppear{
            musicManager.getSongV2()
        }
    }
}


struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


struct VocalRangesTestResultView_Previews: PreviewProvider {
    static var previews: some View {
        VocalRangesTestResultView()
    }
}
