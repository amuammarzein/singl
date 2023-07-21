import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import Keyboard
import SoundpipeAudioKit
import SwiftUI
import Tonic

struct TunerData2 {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteNameWithSharps = "-"
    var noteNameWithFlats = "-"
}

class TunerConductor: ObservableObject, HasAudioEngine {
    @Published var data = TunerData2()

    let engine = AudioEngine()
    let initialDevice: Device

    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader

    var tracker: PitchTap!

    let noteFrequencies = [16.00, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

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
    }

    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }

        data.pitch = pitch
        data.amplitude = amp

        var frequency = pitch
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
    }
}

class InstrumentEXSConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var instrument = MIDISampler(name: "Instrument 1")

    func noteOn(pitch: Pitch, point _: CGPoint) {
        instrument.play(noteNumber: MIDINoteNumber(pitch.midiNoteNumber), velocity: 90, channel: 0)
    }

    func noteOff(pitch: Pitch) {
        instrument.stop(noteNumber: MIDINoteNumber(pitch.midiNoteNumber), channel: 0)
    }

    init() {
        engine.output = instrument

        // Load EXS file (you can also load SoundFonts and WAV files too using the AppleSampler Class)
        do {
            if let fileURL = Bundle.main.url(forResource: "Sounds/Sampler Instruments/sawPiano1", withExtension: "exs") {
                try instrument.loadInstrument(url: fileURL)
            } else {
                Log("Could not find file")
            }
        } catch {
            Log("Could not load instrument")
        }
        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start!")
        }
    }
}


struct CookbookKeyboard: View {
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch) -> Void
    var body: some View {
        Keyboard(layout: .piano(pitchRange: Pitch(48) ... Pitch(64)),
                 noteOn: noteOn, noteOff: noteOff)
    }
}

struct TunerView: View {
    @StateObject var conductor = TunerConductor()
    @StateObject var keyboard = InstrumentEXSConductor()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack {
                Text("Frequency")
                Spacer()
                Text("\(conductor.data.pitch, specifier: "%0.1f")")
            }.padding()

            HStack {
                Text("Amplitude")
                Spacer()
                Text("\(conductor.data.amplitude, specifier: "%0.1f")")
            }.padding()

            HStack {
                Text("Note Name")
                Spacer()
                Text("\(conductor.data.noteNameWithSharps) / \(conductor.data.noteNameWithFlats)")
            }.padding()

            InputDevicePicker2(device: conductor.initialDevice)
//
//            NodeRollingView(conductor.tappableNodeA).clipped()
//
//            NodeOutputView(conductor.tappableNodeB).clipped()
//
//            NodeFFTView(conductor.tappableNodeC).clipped()
            
            
            NodeOutputView(keyboard.instrument)
            CookbookKeyboard(noteOn: keyboard.noteOn,
                             noteOff: keyboard.noteOff)
            
        }
    
        .onAppear {
            conductor.start()
            keyboard.start()
        }
        .onDisappear {
            conductor.stop()
            keyboard.start()
        }
    }
}

struct InputDevicePicker2: View {
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
