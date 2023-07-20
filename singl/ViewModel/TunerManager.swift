import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

class TunerManager: ObservableObject, HasAudioEngine {
    @Published var data = TunerData()
    
    var taskManager:TaskManager = TaskManager()
    
    let engine = AudioEngine()
    let initialDevice: Device
    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader
    
    var tracker: PitchTap!
    
    let noteFrequencies = [16.00, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    var answerNoteMonitoring:[String] = ["-","-","-"]
    
    var frequencyNow:Double = 0.0
    var noteNow:String = ""
    
    var notes = [NoteData]()
    
    var clock:Int = 0
    
    
   
    
    init() {
        guard let input = engine.input else { fatalError() }
        
        guard let device = engine.inputDevice else { fatalError() }
        
        initialDevice = device
        
        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        
        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        tracker.start()
        
        let startNote = NoteData(name: "C", octave: 1,nameFull:"",minFrequency:0,maxFrequency:0)
        let endNote = NoteData(name: "B", octave: 6,nameFull:"",minFrequency:0,maxFrequency:0)
        
        getNotesBetween(startNote: startNote, endNote: endNote)
        
        data.arrNote.removeAll()
        for i in 0..<notes.count{
            data.arrNote.append(notes[notes.count-1-i])
        }
        
        data.questionNote = taskManager.vocalMaxNote+""+String(taskManager.vocalMaxOctave)
        data.questionNoteTmp = data.questionNote
        data.questionMaxFrequency = taskManager.vocalMaxFrequency
        
        data.noteName = taskManager.vocalMaxNote
        data.noteOctave = taskManager.vocalMaxOctave
        
        data.questionMessage = "Sing the note for "+data.questionNote+" in 2 seconds"
        
    }
    
    func getNotesBetween(startNote: NoteData, endNote: NoteData) {
            
            
            let noteNames = noteNamesWithSharps
            
            var currentOctave = startNote.octave
            var currentNoteIndex = noteNames.firstIndex(of: startNote.name)!
            
            while currentOctave < endNote.octave || (currentOctave == endNote.octave && currentNoteIndex <= noteNames.firstIndex(of: endNote.name)!) {
                var x = 1
                if(currentOctave==0){
                    x = 1
                }else if(currentOctave==1){
                    x = 2
                }else if(currentOctave==2){
                    x = 4
                }else if(currentOctave==3){
                    x = 8
                }else if(currentOctave==4){
                    x = 16
                }else if(currentOctave==5){
                    x = 32
                }else if(currentOctave==6){
                    x = 64
                }else if(currentOctave==7){
                    x = 128
                }else if(currentOctave==8){
                    x = 256
                }else if(currentOctave==9){
                    x = 512
                }else if(currentOctave==10){
                    x = 1024
                }
                let min = noteFrequencies[currentNoteIndex] * Double(x)
                
                var note = NoteData(name: noteNames[currentNoteIndex], octave: currentOctave,nameFull:noteNames[currentNoteIndex]+""+String(currentOctave),minFrequency:min, maxFrequency: 0)
                
                let noteAbove = getNoteAbove(note: note)
                
                let currentOctaveAbove = noteAbove.octave
                
                x = 1
                if(currentOctaveAbove==0){
                    x = 1
                }else if(currentOctaveAbove==1){
                    x = 2
                }else if(currentOctaveAbove==2){
                    x = 4
                }else if(currentOctaveAbove==3){
                    x = 8
                }else if(currentOctaveAbove==4){
                    x = 16
                }else if(currentOctaveAbove==5){
                    x = 32
                }else if(currentOctaveAbove==6){
                    x = 64
                }else if(currentOctaveAbove==7){
                    x = 128
                }else if(currentOctaveAbove==8){
                    x = 256
                }else if(currentOctaveAbove==9){
                    x = 512
                }else if(currentOctaveAbove==10){
                    x = 1024
                }
                
                let aboveNoteIndex = noteNames.firstIndex(of: noteAbove.name)!
                
                let max = noteFrequencies[aboveNoteIndex] * Double(x)
                
                note = NoteData(name: noteNames[currentNoteIndex], octave: currentOctave,nameFull:noteNames[currentNoteIndex]+""+String(currentOctave),minFrequency:min, maxFrequency: max)
                
                notes.append(note)
                
                
                currentNoteIndex += 1
                
                if currentNoteIndex >= noteNames.count {
                    currentNoteIndex = 0
                    currentOctave += 1
                }
            }
            
            data.arrNote = notes
            
            data.arrNote.removeAll()
            for i in 0..<notes.count{
                data.arrNote.append(notes[notes.count-1-i])
            }
        
        
        }
        
        func getNoteAbove(note: NoteData) -> NoteData {
            let noteNames = noteNamesWithSharps
            let nextNoteIndex = (noteNames.firstIndex(of: note.name)! + 1) % noteNames.count
            var nextOctave = note.octave
            
            if nextNoteIndex == 0 {
                nextOctave += 1
            }
            
            let nextNoteName = noteNames[nextNoteIndex]
            return NoteData(name: nextNoteName, octave: nextOctave, nameFull:nextNoteName+""+String(nextOctave), minFrequency:0,maxFrequency:0)
        }
        
        func getNoteBelow(note: NoteData) -> NoteData {
            let noteNames = noteNamesWithSharps
            let previousNoteIndex = (noteNames.firstIndex(of: note.name)! - 1 + noteNames.count) % noteNames.count
            var previousOctave = note.octave
            
            if previousNoteIndex == noteNames.count - 1 {
                previousOctave -= 1
            }
            
            let previousNoteName = noteNames[previousNoteIndex]
            return NoteData(name: previousNoteName, octave: previousOctave, nameFull:previousNoteName+""+String(previousOctave),  minFrequency: 0, maxFrequency: 0)
        }
    
    func isAllElementsSame<T: Equatable>(in array: [T]) -> Bool {
        guard let firstElement = array.first else {
            return true
        }
        return array.allSatisfy { $0 == firstElement }
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        
        data.answerNote = ""
        
        var inputLvl:Float = 0
        if(amp > 0.1){
            inputLvl = amp + 0.6
            if(inputLvl >= 1){
                inputLvl = 1
            }
        }
        data.inputLevel = inputLvl
        
        
        clock += 1
                
                
        if(data.questionStatus == .play){
            data.questionColor = .white
        }
        
        if(data.questionStatus == .done){
            var noteFinal:NoteData = NoteData(name: "", octave: 0, nameFull: "", minFrequency: 0, maxFrequency: 0)
            if(data.questionType == "Up"){
                var index = 0
                var indexSelected = 0
                for _ in 0..<data.arrNote.count-1 {
                    if(data.arrNote[index].nameFull == data.questionNote){
                        indexSelected = index
                    }
                    index += 1
                }
                data.questionNoteTmp = data.arrNote[indexSelected+1].nameFull
                data.questionMaxFrequency = data.arrNote[indexSelected+1].maxFrequency
                noteFinal = data.arrNote[indexSelected+1]
            }else{
                var index = 0
                var indexSelected = 0
                for _ in 0..<data.arrNote.count-1 {
                    print(data.arrNote[index].nameFull+" - "+data.questionNote)
                    if(data.arrNote[index].nameFull == data.questionNote){
                        indexSelected = index
                    }
                    index += 1
                }
                data.questionNoteTmp = data.arrNote[indexSelected].nameFull
                data.questionMaxFrequency = data.arrNote[indexSelected].maxFrequency
                noteFinal = data.arrNote[indexSelected]
            }
            print(data.questionType)
            print(data.questionNote)
            print(data.questionNoteTmp)
            data.questionMaxFrequency -= 1
            print(data.questionMaxFrequency)
            data.questionMessage = "Test done! your max note range is "+data.questionNoteTmp+". In a moment you will be redirected to the test result"
            
           
            if(data.questionMaxFrequency > 1046.50){
                data.vocalType = "> Soprano"
            }else if(data.questionMaxFrequency <= 329.63){
                // E2 – E4
                data.vocalType = "Bass"
            }else if(data.questionMaxFrequency <= 440.00){
                // A2 – A4
                data.vocalType = "Bariton"
            }else if(data.questionMaxFrequency <= 523.25){
                // C3 – C5
                data.vocalType = "Tenor"
            }else if(data.questionMaxFrequency <= 659.26){
                // E3 - E5
                data.vocalType = "Counter Tenor"
            }else if(data.questionMaxFrequency <= 698.46){
                // F3 - F5
                data.vocalType = "Alto"
            }else if(data.questionMaxFrequency <= 880.00){
                // A3 – A5
                data.vocalType = "Mezzo-Soprano"
            }else if(data.questionMaxFrequency <= 1046.50){
                //C4 – C6
                data.vocalType = "Soprano"
            }else{
                data.vocalType = "-"
            }
            
            
            taskManager.vocalType = data.vocalType
            taskManager.vocalMaxNote = noteFinal.name
            taskManager.vocalMaxOctave = noteFinal.octave
            taskManager.vocalMaxFrequency = noteFinal.maxFrequency
            data.maxNote = noteFinal.name+""+String(noteFinal.octave)
            data.vocalRange = taskManager.vocalMinNote+String(taskManager.vocalMinOctave)+" - "+(data.maxNote)
            taskManager.vocalRange = data.vocalRange
            
            
        }else if(data.questionStatus == .delay){
            if(clock > data.questionDelay * 10){
               
                if(data.questionType == "Up"){
                    let note:NoteData = NoteData(name: data.noteName, octave: data.noteOctave, nameFull:data.noteName+""+String(data.noteOctave),  minFrequency: 0, maxFrequency: 0)
                    let noteAbove = getNoteAbove(note: note)
                    data.questionNote = noteAbove.name+""+String(noteAbove.octave)
                    data.noteName = noteAbove.name
                    data.noteOctave = noteAbove.octave
                }else{
                    let note:NoteData = NoteData(name: data.noteName, octave: data.noteOctave, nameFull:data.noteName+""+String(data.noteOctave),  minFrequency: 0, maxFrequency: 0)
                    let noteBelow = getNoteBelow(note: note)
                    data.questionNote = noteBelow.name+""+String(noteBelow.octave)
                    data.noteName = noteBelow.name
                    data.noteOctave = noteBelow.octave
                }
                data.questionStatus = .play
                data.questionColor = .white
                data.isCorrect = false
                data.questionMessage = "Sing the note for "+data.questionNote+" in 2 seconds"
                clock = 0
                data.renewTime = true
                
            }
        }else if(data.questionStatus == .play){
            if(clock > data.questionUpCountdown * 10){
                if(data.questionType == "Up"){
                    clock = 0
                    data.questionStatus = .done
                    print("Done Up!")
                    data.renewTime = true
                }else if(data.questionUpLimit-1 < 1){
                    clock = 0
                    data.questionStatus = .done
                    print("Done Down!")
                    data.renewTime = true
                }else{
                    data.questionUpLimit -= 1
                    data.questionType = "Down"
                    data.questionMessage = "Looks like you can't hit those notes! in 3 seconds we'll will drop a note for you"
                    clock = 0
                    data.questionStatus = .delay
                    print("Limit "+String(data.questionUpLimit))
                    data.renewTime = true
                }
            }
        }
        
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }
        
        data.pitch = pitch
        data.amplitude = amp
        
        var frequency = pitch
        
        frequencyNow = Double(String(format: "%.2f", pitch)) ?? 0
        
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }
        
        var minDistance: Float = 10000.0
        var index = 0
        
        for possibleIndex in 0 ..< noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        let octave = Int(log2f(pitch / frequency))
        data.noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
        data.noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"
        
        noteNow = noteNamesWithSharps[index]
        
        answerNoteMonitoring.removeFirst()
        answerNoteMonitoring.append(data.noteNameWithSharps)
        print("***")
        print(answerNoteMonitoring)
        if(isAllElementsSame(in: answerNoteMonitoring) && answerNoteMonitoring[0] != "-"){
            print(true)
            if(frequencyNow > data.maxFrequency){
                data.maxFrequency = frequencyNow
                data.maxNote = data.noteNameWithSharps
                data.maxNote = noteNow
                data.maxOctave = octave
            }
            if(data.minFrequency > 0){
                if(frequencyNow < data.minFrequency){
                    data.minFrequency = frequencyNow
                    data.minNote = data.noteNameWithSharps
                    data.minNote = noteNow
                    data.minOctave = octave
                }
            }else{
                data.minFrequency = frequencyNow
                data.minNote = data.noteNameWithSharps
                data.minNote = noteNow
                data.minOctave = octave
            }
            data.vocalRange = "\(data.minNote)\(data.minOctave) - \(data.maxNote)\(data.maxOctave)"
            
            if(data.maxFrequency > 1046.50){
               data.vocalType = "> Soprano"
           }else if(data.maxFrequency <= 329.63){
               data.vocalType = "Bass"
           }else if(data.maxFrequency <= 440.00){
               data.vocalType = "Bariton"
           }else if(data.maxFrequency <= 523.25){
               data.vocalType = "Tenor"
           }else if(data.maxFrequency <= 659.26){
               data.vocalType = "Counter Tenor"
           }else if(data.maxFrequency <= 698.46){
               data.vocalType = "Alto"
           }else if(data.maxFrequency <= 880.00){
               data.vocalType = "Mezzo-Soprano"
           }else if(data.maxFrequency <= 1046.50){
               data.vocalType = "Soprano"
           }else{
               data.vocalType = "-"
           }
        }else{
            print(false)
        }
        
        if(data.questionStatus != .done){
            data.answerNote = data.noteNameWithSharps
            
            
            data.answerNoteMonitoring.removeFirst()
            
            data.answerNoteMonitoring.append(data.answerNote)
            
            
            if(!data.isCorrect){
                if(data.questionNote == data.answerNote){
                    data.questionColor = Color("Warning")
                }else{
                    data.questionColor = .white
                }
            }
            
            if(isAllElementsSame(in: data.answerNoteMonitoring) && data.answerNote == data.questionNote){
                clock = 0
                data.questionType = "Up"
                data.questionStatus = .delay
                data.questionColor = Color("Success")
                data.questionMessage = "Great! in 3 seconds we'll raise the note for you"
                data.isCorrect = true
                data.renewTime = true
            }
        }

    }
}

struct InputDevicePicker: View {
    @State var device: Device
    
    var body: some View {
        Picker("Input: \(device.deviceID)", selection: $device) {
            ForEach(getDevices(), id: \.self) {
                Text($0.deviceID)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: device, perform: setInputDevice)
    }
    
    func getDevices() -> [Device] {
        AudioEngine.inputDevices.compactMap { $0 }
    }
    
    func setInputDevice(to device: Device) {
        do {
            try AudioEngine.setInputDevice(device)
        } catch let err {
            print(err)
        }
    }
}