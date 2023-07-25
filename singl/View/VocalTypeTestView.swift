//
//  ContentView.swift
//  singerhero
//
//  Created by Aang Muammar Zein on 04/07/23.
//

import SwiftUI

struct VocalTypeTestView: View {
    
    @StateObject var taskManager:TaskManager = TaskManager()
    @StateObject var tunerManager:TunerManager = TunerManager()
    
    @State var isVoicing = false
    var animation: Animation {
        return .easeInOut
    }
    
    var body: some View {
        
        
        if(taskManager.isBack){
            UseHeadphonesViews()
        }else if(taskManager.isNext){
            VocalTypeTestResultViews()
        }else{
            VStack(alignment:.center){
                HStack(spacing:0){
                    Button(
                        action:{
                            taskManager.isBackTrue()
                        }){
                            Image(systemName:"chevron.left").foregroundColor(.white).font(.title3).fontWeight(.bold)
                            Text("Back").font(.body).foregroundColor(.white).fontWeight(.bold)
                        }
                    Spacer()
                }.padding(.top,10)
                
                Spacer()
                if(taskManager.isActive){
                    Text("Great! in 3 seconds you will be redirected to the vocal range test menu").foregroundColor(.white).font(.title3).bold()
                        .multilineTextAlignment(.center)
                }else{
                    Text("Start singing any song you like using your highest and lowest notes for 15 seconds").foregroundColor(.white).font(.title3).bold()
                        .multilineTextAlignment(.center)
                }
                Spacer()
                
                if(tunerManager.data.inputLevel > 0.2){
                    HStack(spacing:12){
                        Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-75) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-50) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-25) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-25) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-50) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                               Rectangle().foregroundColor(.white).frame(width:12,height: isVoicing ? CGFloat(50+(80 * tunerManager.data.inputLevel)-75) : 20).cornerRadius(20).animation(animation.speed(1), value: isVoicing)
                                           }
                                           .onAppear{
                                               isVoicing.toggle()
                                           }
                                           .onDisappear{
                                               isVoicing.toggle()
                                           }.frame(maxHeight:130)
                }else{
                    HStack(spacing:12){
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                        Rectangle().foregroundColor(.white).frame(width:12,height:20).cornerRadius(20)
                    } .onAppear{
                        isVoicing.toggle()
                    }
                    .onDisappear{
                        isVoicing.toggle()
                    }.frame(maxHeight:130)
                }
                
                Spacer()
                
                InputDevicePicker(device: tunerManager.initialDevice).opacity(0).frame(maxHeight:0)
               
                if(taskManager.isTimer){
                    VStack(){
                        Text(String(taskManager.timeRemaining)).foregroundColor(.white).font(.title3).padding(.bottom,3).padding(.top,0)
                        ZStack(){
                            Circle().frame(width:CGFloat(80+(40 * tunerManager.data.inputLevel))).foregroundColor(.white.opacity(0.3))
                            VStack(){
                                ZStack(){
                                    Circle().frame(width:80).foregroundColor(.white)
                                    Image(systemName: "mic.fill").foregroundColor(.black) .font(.system(size: 45))
                                }
                            }
                        }.frame(height:120).opacity(taskManager.isActive ? 0 : 1)
                    }
                }else{
                    Button(
                        action:{
                            tunerManager.start()
                            taskManager.isTimerTrue()
                            taskManager.timeRemaining = tunerManager.data.singingDuration
                        }
                    ){
                        VStack(){
                            Text("Tap to start").foregroundColor(.white).font(.title3).padding(.bottom,3).padding(.top,0)
                            ZStack(){
                                Circle().frame(width:120).foregroundColor(.white)
                                Image(systemName: "mic.fill").foregroundColor(.black)  .font(.system(size: 45))
                            }
                        }
                    }
                }
                
                
            }.padding(.horizontal,30).padding(.bottom,130).frame(maxWidth:.infinity, maxHeight:.infinity).background(Color("Blue")).onAppear{
                
            }
            .onDisappear {
                tunerManager.stop()
            }.onReceive(taskManager.timer) { time in
                if(taskManager.isTimer){
                    if (taskManager.timeRemaining > 0) {
                        taskManager.timeRemaining -= 1
                    } else {
                        print(tunerManager.data)
                        taskManager.timer.upstream.connect().cancel()
                        taskManager.isActiveTrue()
                        tunerManager.stop()
                        taskManager.vocalType = tunerManager.data.vocalType
                        taskManager.vocalRange = tunerManager.data.vocalRange
                        taskManager.vocalMinNote = tunerManager.data.minNote
                        taskManager.vocalMaxNote = tunerManager.data.maxNote
                        if(tunerManager.data.minOctave < 0){
                            tunerManager.data.minOctave = 0
                            taskManager.vocalMinOctave = tunerManager.data.minOctave
                        }else{
                            taskManager.vocalMinOctave = tunerManager.data.minOctave
                        }
                        taskManager.vocalMaxOctave = tunerManager.data.maxOctave
                        taskManager.vocalMinFrequency = tunerManager.data.minFrequency
                        taskManager.vocalMaxFrequency = tunerManager.data.maxFrequency
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            taskManager.isTimerFalse()
                            taskManager.isNextTrue()
                        }
                        
                    }
                }
            }
        }
        
    }
}

struct VocalTypeTestView_Previews: PreviewProvider {
    static var previews: some View {
        VocalTypeTestView()
    }
}
