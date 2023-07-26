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
    @StateObject var pianoManager:PianoManager = PianoManager()
    
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    @State var barHeight: Float = 0
    
    @State var isVoicing = false
    var animation: Animation {
        return .easeInOut
    }
    
    func setup(){
        barHeight = Float(screenHeight) / Float(tunerManager.data.arrNote.count) / 4.5
    }
    
    var body: some View {
        if(taskManager.isBack){
            UseHeadphonesViews()
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
                    
                    Text("Follow the notes we play and you Sing “AAAAA”").font(.title3).bold().foregroundColor(.white).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true).padding(.horizontal,30).padding(.top,30)
                    
                    Spacer()
                    
                    
                }.frame(maxWidth:.infinity, maxHeight:.infinity).background(Color("Blue")).onAppear{
                    
                    taskManager.isTestTrue()
                    tunerManager.start()
                    pianoManager.start()
                    setup()
                    
                    taskManager.timeRemaining = tunerManager.data.questionUpCountdown
                    
//                    print("Play MIDI")
                    
                    let noteNumber:Int = pianoManager.noteNumber(noteName: tunerManager.data.questionNoteName, octave: tunerManager.data.questionNoteOctave)!
//                    print("***")
//                    print(tunerManager.data.questionNoteName)
//                    print(String(tunerManager.data.questionNoteOctave))
//                    print(noteNumber)
                    pianoManager.noteOn(noteNumber:noteNumber)
                    
                }.onDisappear{
                    tunerManager.stop()
                    pianoManager.stop()
                }.onReceive(taskManager.timer) { time in
                    
                    if(tunerManager.data.renewTime){
//                        print(tunerManager.data.renewTime)
//                        print(tunerManager.data.questionStatus)
                        if(tunerManager.data.questionStatus == .delay){
                            taskManager.timeRemaining = tunerManager.data.questionDelay
                        }else if(tunerManager.data.questionStatus == .play){
                            taskManager.timeRemaining = tunerManager.data.questionUpCountdown
                        }
                        if(taskManager.timeRemaining  == tunerManager.data.questionUpCountdown){
//                            print("Play MIDI")
                            
                            let noteNumber:Int = pianoManager.noteNumber(noteName: tunerManager.data.questionNoteName, octave: tunerManager.data.questionNoteOctave)!
//                            print("***")
//                            print(tunerManager.data.questionNoteName)
//                            print(String(tunerManager.data.questionNoteOctave))
//                            print(noteNumber)
                            pianoManager.noteOn(noteNumber:noteNumber)
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
                                            }.animation(animation.speed(1), value: isVoicing)
                                        }.onAppear{
                                            isVoicing.toggle()
                                        }
                                        .onDisappear{
                                            isVoicing.toggle()
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
                                        
                                        Button(
                                            action:{
                                                let noteNumber:Int = pianoManager.noteNumber(noteName: item.name, octave: item.octave)!
//                                                print("***")
//                                                print(item.nameFull)
//                                                print(String(noteNumber))
                                                pianoManager.noteOn(noteNumber:noteNumber)
                                            }
                                        ){
                                            ZStack(){
                                                Rectangle().foregroundColor(tunerManager.data.questionColor).frame(width:70,height:CGFloat(barHeight*10)).cornerRadius(15)
                                                Text(item.nameFull).font(.body).foregroundColor(.black)
                                            }
                                        }
                                        
                                        
                                    }
                                    Spacer()
                                }.padding(.bottom,CGFloat(barHeight))
                            }
                        }.padding(.leading,70)
                        
                        
                    }.padding(.horizontal,0)
                    
                    
                    VStack(){
                        Text(String(taskManager.timeRemaining)).foregroundColor(.white).font(.title3).padding(.bottom,1).padding(.top,0)
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
