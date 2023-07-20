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
    @AppStorage("isTest") var isTest: Bool = false
    @AppStorage("fullName") var fullName: String = "Singing Enthusiast"
    @AppStorage("imageURL") var imageURL: String = ""
    @AppStorage("vocalType") var vocalType: String = ""
    @AppStorage("vocalRange") var vocalRange: String = ""
    @AppStorage("vocalMinNote") var vocalMinNote: String = "C"
    @AppStorage("vocalMaxNote") var vocalMaxNote: String = "C"
    @AppStorage("vocalMinOctave") var vocalMinOctave: Int = 1
    @AppStorage("vocalMaxOctave") var vocalMaxOctave: Int = 1
    @AppStorage("vocalMinFrequency") var vocalMinFrequency: Double = 0
    @AppStorage("vocalMaxFrequency") var vocalMaxFrequency: Double = 0
    
    
//    @AppStorage("isMenu") var isMenu: Bool = true {
//            didSet {
//                objectWillChange.send()
//            }
//        }
//
    @Published var isMenu:Bool = true
    @Published var isShare:Bool = false
    @Published var isActive:Bool = false
    @Published var isDashboard:Bool = false
    @Published var isNext:Bool = false
    @Published var isBack:Bool = false
    @Published var isTimer:Bool = false
    @Published var timeRemaining:Int = 0
    @Published var isSong:Bool = false
    @Published var isSinger:Bool = false
    @Published var isDone:Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   
    func isSkipTrue(){
        isSkip = true
    }
    func isSkipFalse(){
        isSkip = false
    }
    
    func isTestTrue(){
        isTest = true
    }
    func isTestFalse(){
        isTest = false
    }
    
    func isDoneTrue(){
        isDone = true
    }
    func isDoneFalse(){
        isDone = false
    }
    
    func isSongTrue(){
        isSong = true
    }
    func isSongFalse(){
        isSong = false
    }
    
    func isSingerTrue(){
        isSinger = true
    }
    func isSingerFalse(){
        isSinger = false
    }
    
    func isMenuTrue(){
        isMenu = true
    }
    func isMenuFalse(){
        isMenu = false
    }
    
    func isShareTrue(){
        isShare = true
    }
    func isShareFalse(){
        isShare = false
    }
    func isDashboardTrue(){
        isDashboard = true
    }
    func isDashboardFalse(){
        isDashboard = false
    }
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
    func isTimerTrue(){
        isTimer = true
    }
    func isTimerFalse(){
        isTimer = false
    }

}
