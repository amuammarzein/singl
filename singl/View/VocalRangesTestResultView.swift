//
//  VocalRangesTestResultView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct VocalRangesTestResultView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
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
                            taskManager.isBackTrue()
                        }){
                            Image(systemName:"chevron.left").foregroundColor(.white).font(.title3).fontWeight(.bold)
                            Text("Back").font(.body).foregroundColor(.white).fontWeight(.bold)
                        }
                    Spacer()
                }.padding(.top,10).padding(.leading,30)
                ScrollView(){
                    ZStack(){
                                            Image("TestResultCard").resizable().scaledToFit().frame(maxWidth:.infinity).padding(0)
                                            VStack(spacing:10){
                                                Text("Your Vocal Range").font(.title3).bold()
                                                Text(taskManager.vocalRange).font(.title).bold()
                                                Spacer()
                                                Text("Your Vocal Type").font(.title3).bold()
                                                Text(taskManager.vocalType).font(.title).bold()
                                            }.padding(30).padding(.vertical,CGFloat(UIScreen.main.bounds.width/3))
                                        }
                    VStack(){
                        if(taskManager.isTest){
                            VStack(){
                                Button(
                                    action:{
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
                                        taskManager.isShareTrue()
                                    }){
                                        Text("Share to your story!").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                                    }.frame(maxWidth:.infinity).background(.white).cornerRadius(30)
                                
                            }.padding(30)
                            
                        }
                    }.padding(.bottom,100)
                                        
                }
            }.frame(maxWidth: .infinity,maxHeight:.infinity).background(Color("Blue"))
        }
        
    }
}

struct VocalRangesTestResultView_Previews: PreviewProvider {
    static var previews: some View {
        VocalRangesTestResultView()
    }
}
