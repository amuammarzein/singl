//
//  ConverterManager.swift
//  singl
//
//  Created by Aang Muammar Zein on 21/08/23.
//
import Foundation
import UniformTypeIdentifiers
import AVFoundation
import MediaPlayer
import AudioKit
class ConverterManager: ObservableObject {
    @Published var taskManager: TaskManager = TaskManager()
    @Published var audioPlayer: AVAudioPlayer?
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    let audioUnitTimePitch = AVAudioUnitTimePitch()
    @Published var isNext: Bool = false
    @Published var isBack: Bool = false
    @Published var isPitchShifter: Bool = false
    @Published var isRemoveVocal: Bool = true
    @Published var isProcess: Bool = false
    @Published var isProcessConverter: Bool = false
    @Published var isDone: Bool = false
    @Published var frequencySelected: Double = 0
    @Published var isStop = false
    @Published var isShowingFilePicker = false
    @Published var selectedFile: URL?
    @Published var fileEncoded: String = ""
    @Published var fileName: String = ""
    @Published var fileSize: Int64 = 0
    @Published var vocalFile: String = ""
    @Published var musicFile: String = ""
    @Published var sourceFile: String = ""
    @Published var vocalName: String = ""
    @Published var musicName: String = ""
    @Published var sourceName: String = ""
    @Published var convertedFile: String = ""
    @Published var vocalFileDownloaded: String = ""
    @Published var musicFileDownloaded: String = ""
    @Published var sourceFileDownloaded: String = ""
    @Published var convertedFileDownloaded: String = ""
    @Published var sign: String = ""
    @Published var isAlert: Bool = false
    @Published var isDownload: Bool = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    func increase() {
        frequencySelected += 1
        signCheck()
    }
    func decrease() {
        frequencySelected -= 1
        signCheck()
    }
    func signCheck() {
        if frequencySelected > 0 {
            sign = "+"
        } else {
            sign = ""
        }
        convert()
    }
    func signCheck2() {
        if frequencySelected > 0 {
            sign = "+"
        } else {
            sign = ""
        }
    }
    func convert() {
        isProcessConverter = true
        var selectedName = sourceName
        if isRemoveVocal==true {
            selectedName = musicName
        }
        let parameters = "{\n   \"fileName\": \""+selectedName+"\",\n   \"pitch\": "+String(frequencySelected)+"\n}"
        print(parameters)
        let postData = parameters.data(using: .utf8)
        print(taskManager.converterURL+""+taskManager.endpointConverter)
        var request = URLRequest(url: URL(string: taskManager.converterURL+""+taskManager.endpointConverter)!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            let decoder = JSONDecoder()
            if let data = data {
                print("Server Response")
                print(String(data: data, encoding: .utf8)!)
                do {
                    let data = try decoder.decode(ResponseModelConverter.self, from: data)
                    self.convertedFile = data.data.output
                    self.isPitchShifter = true
                    self.downloadMP3Converter()
                } catch {
                    print(error)
                }
            } else if let error = error {
                // Handle the error if there was one during the network request
                print("Network request error: ", error)
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Failed to make the network request.")
                }
                self.isProcessConverter = false
            } else {
                // Handle the case where both data and error are nil (e.g., server not found)
                print("Unknown error: no data and no error.")
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Server endpoint not found.")
                }
                self.isProcessConverter = false
            }
        }
        task.resume()
    }
    func downloadMP3Converter() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(convertedFile)
        let fileURL = documentsDirectory.appendingPathComponent("converted.mp3")
        let downloadURL = URL(string: convertedFile)! // Replace with your MP3 file URL
        convertedFileDownloaded = fileURL.path
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, _, error in
            if let location = location {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    print("Error removing existing file: \(error.localizedDescription)")
                }
                do {
                    try FileManager.default.moveItem(at: location, to: fileURL)
                    print("File downloaded successfully.")
                    self.isDone = true
                    self.isProcessConverter = false
                    self.playAudio()
                } catch {
                    print("Move file error: \(error.localizedDescription)")
                    self.isProcessConverter = false
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                self.isProcessConverter = false
            }
        }
        downloadTask.resume()
    }
    func uploadFile() {
        isProcess = true
        guard selectedFile!.startAccessingSecurityScopedResource() else {
            print("Can't access security scoped resource")
            return
        }
        do {
            let dataX = try Data(contentsOf: selectedFile!)
            fileEncoded = dataX.base64EncodedString()
        } catch {
            print(error)
        }
        let parameters = "{\n   \"file\": \""+fileEncoded+"\"\n}"
        let postData = parameters.data(using: .utf8)
        print(taskManager.converterURL+""+taskManager.endpoint)
        var request = URLRequest(url: URL(string: taskManager.converterURL+""+taskManager.endpoint)!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            let decoder = JSONDecoder()
            if let data = data {
                print("Server Response")
                print(String(data: data, encoding: .utf8)!)
                do {
                    let data = try decoder.decode(ResponseModel.self, from: data)
                    print(data.data.sourceFile)
                    print(data.data.musicFile)
                    print(data.data.vocalFile)
                    self.vocalFile = data.data.vocalFile
                    self.musicFile = data.data.musicFile
                    self.sourceFile = data.data.sourceFile
                    self.vocalName = data.data.vocalName
                    self.musicName = data.data.musicName
                    self.sourceName = data.data.sourceName
                    if data.data.musicFile != "" {
                        self.downloadMP3Music()
                    } else {
                        self.isDone = true
                        self.isProcess = false
                    }
                } catch {
                    print(error)
                }
            } else if let error = error {
                // Handle the error if there was one during the network request
                print("Network request error: ", error)
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Failed to make the network request.")
                }
                self.isProcess = false
            } else {
                // Handle the case where both data and error are nil (e.g., server not found)
                print("Unknown error: no data and no error.")
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Server endpoint not found.")
                }
                self.isProcess = false
            }
        }
        task.resume()
    }
    func showAlert(title: String, message: String) {
        // Update the alertTitle and alertMessage to show the appropriate content in the alert
        alertTitle = title
        alertMessage = message
        // Set showAlert to true to trigger the presentation of the alert
        showAlert = true
    }
    func downloadMP3Music() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(musicFile)
        let fileURL = documentsDirectory.appendingPathComponent("music-file.mp3")
        let downloadURL = URL(string: musicFile)! // Replace with your MP3 file URL
        musicFileDownloaded = fileURL.path
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, _, error in
            if let location = location {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    print("Error removing existing file: \(error.localizedDescription)")
                }
                do {
                    try FileManager.default.moveItem(at: location, to: fileURL)
                    print("File downloaded successfully.")
                    self.downloadMP3Source()
                } catch {
                    print("Move file error: \(error.localizedDescription)")
                    self.isProcess = false
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                self.isProcess = false
            }
        }
        downloadTask.resume()
    }
    func downloadMP3Source() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(sourceFile)
        let fileURL = documentsDirectory.appendingPathComponent("source-file.mp3")
        let downloadURL = URL(string: sourceFile)! // Replace with your MP3 file URL
        sourceFileDownloaded = fileURL.path
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, _, error in
            if let location = location {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    print("Error removing existing file: \(error.localizedDescription)")
                }
                do {
                    try FileManager.default.moveItem(at: location, to: fileURL)
                    print("File downloaded successfully.")
                    self.isDone = true
                    self.isProcess = false
                } catch {
                    print("Move file error: \(error.localizedDescription)")
                    self.isProcess = false
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                self.isProcess = false
            }
        }
        downloadTask.resume()
    }
    func playAudio() {
        if !isProcess && !isProcessConverter {
            resetAudio()
            var selectedSource = ""
            if isPitchShifter {
                selectedSource = convertedFileDownloaded
            } else {
                selectedSource = sourceFileDownloaded
                if isRemoveVocal==true {
                    selectedSource = musicFileDownloaded
                }
            }
            // 1: load the file
            let url = URL(fileURLWithPath: selectedSource)
            do {
                let audioFile = try AVAudioFile(forReading: url)
                // Schedule the audio file for playback
                audioPlayerNode.scheduleFile(audioFile, at: nil)
                // Start the player node
                audioPlayerNode.play()
            } catch {
                print("Error playing audio file: \(error.localizedDescription)")
            }
        }
    }
    func resetAudio() {
        audioPlayerNode.stop()
        //            audioPlayerNode.currentTime = 0
        //            audioPlayerNode = nil
    }
    func setupAudioEngine() {
        // Connect audio player node to time pitch effect
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(audioUnitTimePitch)
        audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
        audioEngine.connect(audioUnitTimePitch, to: audioEngine.mainMixerNode, format: nil)
        // Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    func downloadMP3Final() {
        isDownload = true
        var selectedSource = ""
        if isPitchShifter {
            selectedSource = convertedFileDownloaded
        } else {
            selectedSource = sourceFileDownloaded
            if isRemoveVocal==true {
                selectedSource = musicFileDownloaded
            }
        }
        let audioURL = URL(fileURLWithPath: selectedSource)
        let destinationURL = getDocumentsDirectory().appendingPathComponent("singl-converted.mp3")
        URLSession.shared.downloadTask(with: audioURL) { (tempURL, _, error) in
            if let error = error {
                print("Download error: \(error.localizedDescription)")
                return
            }
            guard let tempURL = tempURL else {
                print("Temporary URL not found")
                return
            }
            do {
                try FileManager.default.removeItem(at: destinationURL)
            } catch {
                print("Error removing existing file: \(error.localizedDescription)")
            }
            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                self.resetAudio()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isDownload = false
                    self.shareLink(url: destinationURL)
                }
            } catch {
                print("Move file error: \(error.localizedDescription)")
            }
        }.resume()
    }
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    func shareLink(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
