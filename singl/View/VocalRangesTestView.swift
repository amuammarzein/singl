//
//  VocalRangesTestView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct VocalRangesTestView: View {
    
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var tunerManager:TunerManager = TunerManager()
    
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    @State var barHeight: Float = 0
    
    func setup(){
        barHeight = Float(screenHeight) / Float(tunerManager.data.arrNote.count) / 4.5
    }
    
    var body: some View {
        if(taskManager.isBack){
                DashboardView()
        }else if(taskManager.isNext){
                VocalRangesTestResultView()
            }else{
                ZStack(){
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
                        }.padding(.top,10).padding(.horizontal,30)
                        
                        Text("And now, let’s find out your vocal range, follow the notes we play and you sing “aaa”").font(.title3).bold().foregroundColor(.white).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true).padding(.horizontal,30).padding(.top,30)
                       
                        Spacer()
                        
                        
                    }.frame(maxWidth:.infinity, maxHeight:.infinity).background(Color("Blue")).onAppear{
                        
                        taskManager.isTestTrue()
                        tunerManager.start()
                        setup()
                        
                        taskManager.timeRemaining = tunerManager.data.questionUpCountdown
                        
                    }.onDisappear{
                        tunerManager.stop()
                    }.onReceive(taskManager.timer) { time in
                        
                        if(tunerManager.data.renewTime){
                            print(tunerManager.data.renewTime)
                            print(tunerManager.data.questionStatus)
                            if(tunerManager.data.questionStatus == .delay){
                                taskManager.timeRemaining = tunerManager.data.questionDelay
                            }else if(tunerManager.data.questionStatus == .play){
                                taskManager.timeRemaining = tunerManager.data.questionUpCountdown
                            }
                            tunerManager.data.renewTime = false
                        }
                            if taskManager.timeRemaining > 0 {
                                taskManager.timeRemaining -= 1
                                                } else {
//                                                    taskManager.timer.upstream.connect().cancel()
                                                }
                        
                        if (!taskManager.isDone) {
                            if(tunerManager.data.questionStatus == .done){
                                print("Done!")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        taskManager.isNextTrue()
                                    }
                                }
                                taskManager.isDoneTrue()
                                
                            }                    }
                    }
                    
                    VStack(){
                     
                        ZStack(){
                            
                            VStack(spacing:0){
                                ForEach(Array(tunerManager.data.arrNote.enumerated()), id: \.element.id) {  i, item in
                                    HStack(){
                                        HStack(){
                                            Rectangle().foregroundColor(.white).frame(width:30,height:CGFloat(barHeight))
                                            Spacer()
                                        }.frame(width:70)
                                        Spacer()
                                        
                                    }.padding(.bottom,CGFloat(barHeight))
                                }
                            }
                            
                            VStack(spacing:0){
                                ForEach(Array(tunerManager.data.arrNote.enumerated()), id: \.element.id) {  i, item in
                                    HStack(){
                                        if(item.nameFull != tunerManager.data.answerNote
                                        ){
                                            HStack(){
                                                Rectangle().foregroundColor(.white).frame(width:30,height:CGFloat(barHeight))
                                                Spacer()
                                            }.frame(width:70).opacity(0).padding(.bottom,CGFloat(barHeight))
                                        }else if(tunerManager.data.questionStatus == .play){
                                            ZStack(){
                                                VStack(spacing:0){
                                                    HStack(){
                                                        Rectangle().foregroundColor(Color("Orange")).frame(width:40,height:CGFloat(barHeight))
                                                        Spacer()
                                                    }.frame(width:70).opacity(1).padding(.bottom,CGFloat(barHeight))
                                                    HStack(){
                                                        Rectangle().foregroundColor(Color("Orange")).frame(width:50,height:CGFloat(barHeight))
                                                        Spacer()
                                                    }.frame(width:70).opacity(1).padding(.bottom,CGFloat(barHeight))
                                                    HStack(){
                                                        Rectangle().foregroundColor(Color("Orange")).frame(width:60,height:CGFloat(barHeight))
                                                        Spacer()
                                                    }.frame(width:70).opacity(1).padding(.bottom,CGFloat(barHeight))
                                                    HStack(){
                                                        Rectangle().foregroundColor(Color("Orange")).frame(width:50,height:CGFloat(barHeight))
                                                        Spacer()
                                                    }.frame(width:70).opacity(1).padding(.bottom,CGFloat(barHeight))
                                                    HStack(){
                                                        Rectangle().foregroundColor(Color("Orange")).frame(width:40,height:CGFloat(barHeight))
                                                        Spacer()
                                                    }.frame(width:70).opacity(1).padding(.bottom,CGFloat(barHeight))
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        Spacer()
                                        
                                    }
                                }
                            }
                            
                            VStack(spacing:0){
                                ForEach(Array(tunerManager.data.arrNote.enumerated()), id: \.element.id) {  i, item in
                                    HStack(){
                                        HStack(){
                                            Rectangle().foregroundColor(.white).frame(width:70,height:CGFloat(barHeight)).opacity(item.nameFull==tunerManager.data.questionNote  ? 1 : 0)
                                            Spacer()
                                        }.frame(width:80)
                                        if(item.nameFull==tunerManager.data.questionNote){
                                            ZStack(){
                                                Rectangle().foregroundColor(tunerManager.data.questionColor).frame(width:70,height:CGFloat(barHeight*10)).cornerRadius(15)
                                                Text(item.nameFull).font(.body)
                                            }
                                        }
                                        Spacer()
                                    }.padding(.bottom,CGFloat(barHeight))
                                }
                            }.padding(.leading,70)
                            
                            
                        }.padding(.horizontal,0)
                        
                        
                        VStack(){
                            Text(String(taskManager.timeRemaining)).foregroundColor(.white).font(.title).padding(.bottom,1).padding(.top,0)
                            Text(tunerManager.data.questionMessage).font(.callout).foregroundColor(Color("Yellow")).multilineTextAlignment(.center) .padding(.horizontal,30)
                            Spacer()
                        }.frame(height:150)
                    }.padding(.top,150)
                    
                }
                
            }
            
        }
        
        
    }

    struct VocalRangesTestView_Previews: PreviewProvider {
        static var previews: some View {
            VocalRangesTestView()
        }
    }