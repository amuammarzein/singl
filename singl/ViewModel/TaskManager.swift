//
//  TaskManager.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import Foundation
import SwiftUI


class TaskManager:ObservableObject{
    
    @AppStorage("isSkip") var isSkip: Bool = false
    @AppStorage("vocalType") var vocalType: String = ""
    @AppStorage("vocalRange") var vocalRange: String = ""
    @AppStorage("vocalMinNote") var vocalMinNote: String = "C"
    @AppStorage("vocalMaxNote") var vocalMaxNote: String = "C"
    @AppStorage("vocalMinOctave") var vocalMinOctave: Int = 1
    @AppStorage("vocalMaxOctave") var vocalMaxOctave: Int = 1
    @AppStorage("vocalMinFrequency") var vocalMinFrequency: Double = 0
    @AppStorage("vocalMaxFrequency") var vocalMaxFrequency: Double = 0
    
    @Published var isActive:Bool = false
    @Published var isNext:Bool = false
    @Published var isBack:Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func isNextTrue(){
        isNext = true
    }
    func isNextFalse(){
        isNext = false
    }
    func isBackTrue(){
        isBack = true
    }
    func isBackFalse(){
        isBack = false
    }
    func isActiveTrue(){
        isActive = true
    }
    func isActiveFalse(){
        isActive = false
    }
    func getData(){
        
    }
    
}
