//
//  UseHeadphonesViews.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

import AVFoundation

struct GetStartedView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var audioManager:AudioManager = AudioManager()
    var body: some View {
        if(taskManager.isNext){
            UseHeadphonesViews()
        }else if(taskManager.isDashboard){
            HomeView()
        }else{
            ZStack(){
                VStack(){
                    HStack(){
                        Spacer()
                        Image("GetStartedTop").resizable().scaledToFit().frame(width:200)
                    }
                    Spacer()
                    HStack(){
                        Image("GetStartedBottom").resizable().scaledToFit().frame(width:150)
                        Spacer()
                    }
                }
                VStack(alignment:.center){
                    
                    Spacer()
                    HStack(){
                        Image("LogoText").resizable().scaledToFit().frame(width:70)
                        Spacer()
                    }.padding(.leading,30)
                    Spacer()
                    VStack(){
                        HStack(){
                            Text("Know your\nvoice,\nLet’s start\nsing with us.").font(.largeTitle).bold()
                            Spacer()
                        }
                    }.padding(30)
                    Spacer()
                    HStack(){
                        Spacer()
                        Button(
                            action:{
                                taskManager.isNextTrue()
                            }
                        ){
                            HStack(){
                                Text("Get Started")
                                    .font(.body).bold()
                                    .foregroundColor(.white)
                                Image(systemName:"arrow.right").foregroundColor(.white)
                                HStack(){}.frame(width:45)
                            }.padding(20)
                        }.background(Color("Blue"))
                            .cornerRadius(30).offset(x:+45).padding(.bottom,90)
                    }
                    HStack(){
                        Spacer()
                        Button(
                            action:{
                                taskManager.isDashboardTrue()
                            }
                        ){
                            HStack(){
                                Text("Go to dashboard")
                                    .font(.callout).underline()
                                    .foregroundColor(Color("Blue"))
                                HStack(){}.frame(width:45)
                            }.padding(20)
                        }
                            .cornerRadius(30).offset(x:+45).padding(.bottom,30)
                    }
                    
                }
            }
            .background(.white).frame(maxWidth:.infinity, maxHeight:.infinity).ignoresSafeArea()
        }
        
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
