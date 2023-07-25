//
//  TunerModel.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import Foundation
import SwiftUI


enum QuestionStatus {
    case play
    case delay
    case done
}

struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var inputLevel: Float = 0.0
    var noteNameWithSharps: String = "-"
    var noteNameWithFlats: String = "-"
    var vocalRange: String = "-"
    var vocalType: String = "-"
    var minNote: String = "-"
    var maxNote: String = "-"
    var minOctave: Int = 1
    var maxOctave: Int = 1
    var minFrequency:Double = 0
    var maxFrequency:Double = 0
    var minNoteFull: String = "-"
    var maxNoteFull: String = "-"
    var arrNote:[NoteData] = []
    var singingDuration:Int = 15
    var questionColor:Color = .white
    var questionNote:String = "-"
    var questionNoteName:String = "-"
    var questionNoteOctave:Int = 1
    var questionNoteTmp:String = "-"
    var questionMaxFrequency:Double = 0.0
    var questionStatus:QuestionStatus = .play
    var isQuestion:Bool = false
    var isCorrect:Bool = false
    var questionType:String = ""
    var questionMessage:String = ""
    var questionUpLimit:Int = 3
    var questionUpCountdown:Int = 15
    var questionDownLimit:Int = 3
    var questionDownCountdown:Int = 15
    var questionDelay:Int = 3
    var answerNote:String = "-"
    var noteName: String = "-"
    var noteOctave: Int = 1
    var renewTime: Bool = false
    var answerNoteMonitoring:[String] = ["-","-","-","-","-","-","-","-","-","-",
                                         "-","-","-","-","-",]
}

struct NoteData {
    var id = UUID()
    var name: String = ""
    var octave: Int = 0
    var nameFull: String = ""
    var minFrequency: Double = 0.0
    var maxFrequency: Double = 0.0
    
    init(name: String, octave: Int, nameFull: String, minFrequency: Double, maxFrequency: Double) {
            self.name = name
            self.octave = octave
            self.nameFull = nameFull
            self.minFrequency = minFrequency
            self.maxFrequency = maxFrequency
        }
    
}
