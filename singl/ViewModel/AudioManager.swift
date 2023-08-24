//
//  AudioManager.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//
import Foundation
import SwiftUI
import AVFAudio
class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    func playAudio() {
        let fileName = "Sounds/UseHeadphones.mp3"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sound file \(fileName) not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    func stopAudio() {
        audioPlayer?.stop()
    }
}
