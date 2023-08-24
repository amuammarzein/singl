import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import SoundpipeAudioKit
import SwiftUI
import Tonic
class PianoManager: ObservableObject, HasAudioEngine {
    var taskManager: TaskManager = TaskManager()
    let engine = AudioEngine()
    var instrument = MIDISampler(name: "Instrument 1")
    func noteNumber(noteName: String, octave: Int) -> Int? {
        let noteNamesWithSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        guard let noteIndex = noteNamesWithSharps.firstIndex(of: noteName) else {
            return nil // Invalid note
        }
        return noteIndex + (octave + 1) * 12
    }
    func noteOn(noteNumber: Int) {
        instrument.volume = 1
        if noteNumber >= 0 {
            taskManager.isPiano = true
            instrument.play(noteNumber: MIDINoteNumber(noteNumber), velocity: 90, channel: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.taskManager.isPiano = false
            }
        }
    }
    func noteOff(noteNumber: Int) {
        instrument.stop(noteNumber: MIDINoteNumber(noteNumber), channel: 0)
    }
    init() {
        engine.stop()
        engine.output = instrument
        // Load EXS file (you can also load SoundFonts and WAV files too using the AppleSampler Class)
        do {
            if let fileURL = Bundle.main.url(forResource: "Sounds/Sampler Instruments/sawPiano1", withExtension: "exs") {
                try instrument.loadInstrument(url: fileURL)
                print("Loaded!")
            } else {
              print("Could not find file")
            }
        } catch {
            print("Could not load instrument")
        }
        do {
            try engine.start()
        } catch {
            print("AudioKit did not start!")
        }
    }
}
