//
//  SongConverterView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AVFoundation
import MediaPlayer

struct SongConverterView: View {
    
    @StateObject var taskManager:TaskManager = TaskManager()
    
    @State var audioPlayer: AVAudioPlayer?
    
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    let audioUnitTimePitch = AVAudioUnitTimePitch()
    
    
    
    @State private var isNext:Bool = false
    @State private var isBack:Bool = false
    
    @State var isPitchShifter:Bool = false
    
    @State var isRemoveVocal: Bool = true
    @State var isProcess:Bool = false
    @State var isProcessConverter:Bool = false
    @State var isDone:Bool = false
    @State var frequencySelected:Double = 0
    
    @State private var isStop = false
    
    @State private var isShowingFilePicker = false
    @State private var selectedFile: URL?
    @State private var fileEncoded:String = ""
    
    @State private var fileName: String = ""
    @State private var fileSize: Int64 = 0
    
    
    @State private var vocalFile:String = ""
    @State private var musicFile:String = ""
    @State private var sourceFile:String = ""
    
    @State private var vocalName:String = ""
    @State private var musicName:String = ""
    @State private var sourceName:String = ""
    
    @State private var convertedFile:String = ""
    
    
    @State private var vocalFileDownloaded:String = ""
    @State private var musicFileDownloaded:String = ""
    @State private var sourceFileDownloaded:String = ""
    @State private var convertedFileDownloaded:String = ""
    
    @State private var sign:String = ""
    
    
    @State var isAlert:Bool = false
    @State var isDownload:Bool = false
    
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    func increase(){
        frequencySelected += 1
        signCheck()
    }
    
    func decrease(){
        frequencySelected -= 1
        signCheck()
    }
    
    func signCheck(){
        changePitch()
        if(frequencySelected > 0){
            sign = "+"
        }else{
            sign = ""
        }
        
        convert()
        
    }
    
    func convert(){
        isProcessConverter = true
//        isDone = false
        var selectedName = sourceName
        if(isRemoveVocal==true){
            selectedName = musicName
        }
        let parameters = "{\n   \"file_name\":\""+selectedName+"\",\n   \"pitch\":"+String(frequencySelected)+"\n}"
        print(parameters)
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: taskManager.endpointConverter)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data{
                print("Server Response")
                print(String(data: data, encoding: .utf8)!)
                do {
                    let data = try decoder.decode(ResponseModelConverter.self, from: data)
                    
//                    print(data.data.pitch)
//                    print(data.data.file_name)
//                    print(data.data.output)
                    
                    
                    
                    convertedFile = data.data.output
                    isPitchShifter = true
                    
                    downloadMP3Converter()
                    
                } catch {
                    print(error)
                }
//                isDone = true
//                isProcess = false
            }else if let error = error {
                // Handle the error if there was one during the network request
                print("Network request error:", error)
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    showAlert(title: "Error", message: "Failed to make the network request.")
                }
            } else {
                // Handle the case where both data and error are nil (e.g., server not found)
                print("Unknown error: no data and no error.")
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    showAlert(title: "Error", message: "Server endpoint not found.")
                }
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
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, response, error in
            if let location = location {
                do {
                    // Replace the existing file if it exists
                    if fileManager.fileExists(atPath: fileURL.path) {
                        try fileManager.replaceItemAt(fileURL, withItemAt: location)
                    } else {
                        try fileManager.moveItem(at: location, to: fileURL)
                    }
                    print("File downloaded successfully.")
//                    isDone = true
                      isProcessConverter = false
                      playAudio()
                } catch {
                    print("Error moving/replacing file: \(error.localizedDescription)")
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        
        downloadTask.resume()
    }
    
    func uploadFile(){
        isProcess = true
        
//        print("Location")
//        print(selectedFile?.path)
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
        
     
        let parameters = "{\n   \"file\":\""+fileEncoded+"\"\n}"
        
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: taskManager.endpoint)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data{
                print("Server Response")
                print(String(data: data, encoding: .utf8)!)
                do {
                    let data = try decoder.decode(ResponseModel.self, from: data)
                    print(data.data.source_file)
                    print(data.data.music_file)
                    print(data.data.vocal_file)
                    vocalFile = data.data.vocal_file
                    musicFile = data.data.music_file
                    sourceFile = data.data.source_file
                    vocalName = data.data.vocal_name
                    musicName = data.data.music_name
                    sourceName = data.data.source_name
                    
                    if(data.data.music_file != ""){
                        downloadMP3Music()
                    }else{
                        isDone = true
                        isProcess = false
                    }
                    
                    
                } catch {
                    print(error)
                }
//                isDone = true
//                isProcess = false
            }else if let error = error {
                // Handle the error if there was one during the network request
                print("Network request error:", error)
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    showAlert(title: "Error", message: "Failed to make the network request.")
                }
            } else {
                // Handle the case where both data and error are nil (e.g., server not found)
                print("Unknown error: no data and no error.")
                // Notify the user about the error, e.g., using an alert
                DispatchQueue.main.async {
                    showAlert(title: "Error", message: "Server endpoint not found.")
                }
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
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, response, error in
            if let location = location {
                do {
                    // Replace the existing file if it exists
                    if fileManager.fileExists(atPath: fileURL.path) {
                        try fileManager.replaceItemAt(fileURL, withItemAt: location)
                    } else {
                        try fileManager.moveItem(at: location, to: fileURL)
                    }
                    print("File downloaded successfully.")
                    downloadMP3Source()
                } catch {
                    print("Error moving/replacing file: \(error.localizedDescription)")
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
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
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { location, response, error in
            if let location = location {
                do {
                    // Replace the existing file if it exists
                    if fileManager.fileExists(atPath: fileURL.path) {
                        try fileManager.replaceItemAt(fileURL, withItemAt: location)
                    } else {
                        try fileManager.moveItem(at: location, to: fileURL)
                    }
                    isDone = true
                    isProcess = false
                    print("File downloaded successfully.")
                } catch {
                    print("Error moving/replacing file: \(error.localizedDescription)")
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        
        downloadTask.resume()
    }
    
    func playAudio() {
        
        
        resetAudio()
        
        print("Play Audio")
        var selectedSource = ""
        
        if(isPitchShifter){
            selectedSource = convertedFileDownloaded
        }else{
            selectedSource = sourceFileDownloaded
            if(isRemoveVocal==true){
                selectedSource = musicFileDownloaded
            }
        }
        
        print(selectedSource)
        
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
    
    func downloadMP3Final(){
        
        isDownload = true
        //        resetAudio()
        
        print("Download Audio")
        var selectedSource = ""
        
        if(isPitchShifter){
            selectedSource = convertedFileDownloaded
        }else{
            selectedSource = sourceFileDownloaded
            if(isRemoveVocal==true){
                selectedSource = musicFileDownloaded
            }
        }
        
        print(selectedSource)
        
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
                
//                applyAudioEffect(to: destinationURL)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isDownload = false
                    shareLink(url: audioURL)
                    print("CONVERTED MP3")
                    print(destinationURL)
                }
                
            } catch {
                print("Move file error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    func applyAudioEffect(to audioURL: URL) {
        
        do {
            let audioFile = try AVAudioFile(forReading: audioURL)
            
            
            audioEngine.attach(audioPlayerNode)
            audioEngine.attach(audioUnitTimePitch)
            
            audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: audioFile.processingFormat)
            audioEngine.connect(audioUnitTimePitch, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
            
            audioPlayerNode.scheduleFile(audioFile, at: nil)
            
            audioUnitTimePitch.pitch = Float(frequencySelected)
            
            try audioEngine.start()
            
            audioPlayerNode.play()
            
            
            
        } catch {
            print("Audio effect error: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    
    func shareLink(url:URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func changePitch(){
        audioUnitTimePitch.pitch = Float(frequencySelected)
        print(frequencySelected)
    }
    
    var body: some View {
        if(isBack){
            HomeView()
        }else{
            VStack(alignment:.center,spacing:0){
                ScrollView(){
                    Text("Song Instrument Converter").foregroundColor(.white).font(.title2).bold()
                        .multilineTextAlignment(.center).padding(.bottom,50)
                    
                    
                    VStack {
                        
                        if(isProcess){
                            ProcessView()
                        }else if(isDone){
                            
                            VStack() {
                                HStack(){
                                    Image(systemName:"checkmark.circle").foregroundColor(.white)
                                    Text(fileName)
                                        .font(.body).bold()
                                        .foregroundColor(.white).padding(.leading,0).lineLimit(1)
                                    Text(String(format: "%.2fMB", Double(fileSize)/1000000))
                                        .font(.body).bold()
                                        .foregroundColor(.white).padding(.leading,0).lineLimit(1)
                                    Spacer()
                                    Button(
                                        action:{                                        isAlert = true
                                        }){
                                            Image(systemName:"xmark").foregroundColor(.white)
                                        }.alert(isPresented: $isAlert) {
                                            Alert(
                                                title: Text("Confirmation"),
                                                message: Text("Are you sure you want to delete this song?"),
                                                primaryButton: .default(Text("Delete Song").foregroundColor(.red), action: {
                                                    isDone = false
                                                    isProcess = false
                                                    isProcessConverter = false
                                                    resetAudio()
                                                    
                                                }),
                                                secondaryButton: .default(Text("Cancel"))
                                            )
                                            
                                        }
                                    
                                    
                                }.padding(20)
                            }.frame(maxWidth:.infinity).background( Color("Success")).cornerRadius(30).padding(.leading,30).padding(.trailing,30)
                            
                        }else{
                            Button(action: {
                                isShowingFilePicker = true
                            }) {
                                HStack(){
                                    
                                    Image(systemName:"square.and.arrow.up")
                                    Text("Upload Your Song")
                                        .font(.body).bold()
                                        .foregroundColor(Color("Blue")).padding(.leading,0)
                                    
                                    
                                }.padding(20)
                            }.frame(maxWidth:.infinity).background( .white).cornerRadius(30).padding(.horizontal,30) .fileImporter(isPresented: $isShowingFilePicker, allowedContentTypes: [.audio], allowsMultipleSelection: false, onCompletion: { result in
                                switch result {
                                case .success(let urls):
                                    if let unwrappedURL: URL = urls.first {
                                        
                                        selectedFile = urls.first
                                        uploadFile()
                                        
                                    }
                                    
                                    
                                    guard let url = urls.first else { return }
                                    
                                    do {
                                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
                                        fileName = url.lastPathComponent
                                        fileSize = fileAttributes[FileAttributeKey.size] as? Int64 ?? 0
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                    
                                case .failure(let error):
                                    print("Error selecting file \(error.localizedDescription)")
                                }
                                
                            })
                        }
                        
                        
                    }
                    
                    VStack(spacing:20){
                        
                        
                        Text("Set the pitch of the instrument to the pitch you need").foregroundColor(Color(.white)).font(.callout)
                            .multilineTextAlignment(.center).padding(.vertical,5).padding(.top,20).opacity(isDone ? 1 : 0.5)
                        
                        VStack(){
                            Button(
                                action:{
                                    increase()
                                }){
                                    Image(systemName:"triangle.fill").foregroundColor(Color("Yellow")).font(.system(size: 50)).fontWeight(.bold)
                                }.opacity(!isProcessConverter ? 1 : 0.5).disabled(isProcessConverter ? true : false)
                            Text(sign+"\(String(format: "%.0f", frequencySelected))").foregroundColor(Color(.white)).font(.largeTitle).padding(.vertical,5)
                            
                            Button(
                                action:{
                                    decrease()
                                }){
                                    Image(systemName:"triangle.fill").foregroundColor(Color("Yellow")).font(.system(size: 50)).fontWeight(.bold).scaleEffect(CGSize(width: 1.0, height: -1.0))
                                }.opacity(!isProcessConverter ? 1 : 0.5).disabled(isProcessConverter ? true : false)
                        }.disabled(isDone ? false : true).padding(.vertical,10).opacity(isDone ? 1 : 0.5)
                        
                        
                        
                        
                        
                        HStack(){
                            Toggle("Remove Vocals", isOn: $isRemoveVocal)
                                .padding().foregroundColor(.white).font(.callout).frame(width:200).onChange(of: isRemoveVocal) { value in
                                    resetAudio()
                                    convert()
                                }
                        }
                        .padding(.top,-10)
                        .opacity(isDone ? 1 : 0.5).disabled(isDone ? false : true)
                    }.padding(.top,20)
                    
                    HStack(spacing:10){
                        Button(
                            action:{
                                playAudio()
                            }
                        ){
                            Text("Play").font(.callout)
                        }.opacity(isDone ? 1 : 1).disabled(isDone ? false : true)
                        
                        Button(
                            action:{
                                frequencySelected = 0
                                signCheck()
                                changePitch()
                                resetAudio()
                            }
                        ){
                            Text("Reset").font(.callout)
                        }.opacity(isDone ? 1 : 1).disabled(isDone ? false : true)
                    }.padding(.bottom,25)
                    
                    if(isDownload){
                        DownloadView()
                    }else{
                        Button(action: {
                            print("download file")
                            downloadMP3Final()
                            
                        }) {
                            HStack(){
                                Image(systemName:"square.and.arrow.down")
                                Text("Download Your Song")
                                    .font(.body).bold()
                                    .foregroundColor(Color("Blue")).padding(.leading,0)
                            }.padding(20)
                        }.frame(maxWidth:.infinity).background(.white.opacity(isDone ? 1 : 0.5)).cornerRadius(30).padding(.leading,30).padding(.trailing,30).cornerRadius(30).disabled(isDone ? false : true)
                    }
                    
                    
                    
                }.padding(30).padding(.top,30).frame(maxWidth:.infinity, maxHeight:.infinity).background(Color("Blue")).ignoresSafeArea().onAppear{
                    setupAudioEngine()
                }.onDisappear{
                    audioEngine.stop()
                    audioPlayerNode.stop()
                }
            }.alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct SongConverterView_Previews: PreviewProvider {
    static var previews: some View {
        SongConverterView()
    }
}



struct ProcessView: View {
    var body: some View {
        Button(action: {
            
        }) {
            HStack(){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black)).padding(0).font(.title).fontWeight(.none)
                Text("Uploading")
                    .font(.body).bold().padding(.leading,5)
            }.padding(20)
                .foregroundColor(Color.black.opacity(0.5)).frame(maxWidth:.infinity).background(.white.opacity(0.5)).cornerRadius(30)
        }.disabled(true).padding(.trailing,30).padding(.leading,30)
        
    }
}



struct DownloadView: View {
    var body: some View {
        Button(action: {
            
        }) {
            HStack(){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black)).padding(0).font(.title).fontWeight(.none)
                Text("Downloading")
                    .font(.body).bold().padding(.leading,5)
            }.padding(20)
                .foregroundColor(Color.black.opacity(0.5)).frame(maxWidth:.infinity).background(.white.opacity(0.5)).cornerRadius(30)
        }.disabled(true).padding(.trailing,30).padding(.leading,30)
        
    }
}
