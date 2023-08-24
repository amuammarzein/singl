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
    @EnvironmentObject var router: Router
    @StateObject var converterManager: ConverterManager = ConverterManager()
    var body: some View {
        if converterManager.isBack {
            HomeView()
        } else {
            VStack(alignment: .center, spacing: 0) {
                ScrollView {
                    Text("Song Instrument Converter").foregroundColor(.white).font(.title2).bold()
                        .multilineTextAlignment(.center).padding(.bottom, 50)
                    VStack {
                        if converterManager.isProcess {
                            ProcessView()
                        } else if converterManager.isDone {
                            VStack {
                                HStack {
                                    Image(systemName: "checkmark.circle").foregroundColor(.white)
                                    Text(converterManager.fileName)
                                        .font(.body).bold()
                                        .foregroundColor(.white).padding(.leading, 0).lineLimit(1)
                                    Text(String(format: "%.2fMB", Double(converterManager.fileSize)/1000000))
                                        .font(.body).bold()
                                        .foregroundColor(.white).padding(.leading, 0).lineLimit(1)
                                    Spacer()
                                    Button(
                                        action: {
                                            converterManager.isAlert = true
                                        }) {
                                            Image(systemName: "xmark").foregroundColor(.white)
                                        }.alert(isPresented: $converterManager.isAlert) {
                                            Alert(
                                                title: Text("Confirmation"),
                                                message: Text("Are you sure you want to delete this song?"),
                                                primaryButton: .default(Text("Delete Song").foregroundColor(.red), action: {
                                                    converterManager.isDone = false
                                                    converterManager.isProcess = false
                                                    converterManager.isProcessConverter = false
                                                    converterManager.resetAudio()
                                                    converterManager.frequencySelected = 0
                                                    converterManager.signCheck2()
                                                }),
                                                secondaryButton: .default(Text("Cancel"))
                                            )
                                        }
                                }.padding(20)
                            }.frame(maxWidth: .infinity).background( Color("Success")).cornerRadius(30).padding(.leading, 30).padding(.trailing, 30)
                        } else {
                            Button(action: {
                                converterManager.isShowingFilePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Upload Your Song")
                                        .font(.body).bold()
                                        .foregroundColor(Color("Blue")).padding(.leading, 0)
                                }.padding(20)
                            }.frame(maxWidth: .infinity).background( .white).cornerRadius(30).padding(.horizontal, 30).alert(isPresented: $converterManager.showAlert) {
                                Alert(title: Text(converterManager.alertTitle), message: Text(converterManager.alertMessage), dismissButton: .default(Text("OK")))
                            }.fileImporter(isPresented: $converterManager.isShowingFilePicker, allowedContentTypes: [.audio], allowsMultipleSelection: false, onCompletion: { result in
                                switch result {
                                case .success(let urls):
                                    if urls.first != nil {
                                        converterManager.selectedFile = urls.first
                                        converterManager.uploadFile()
                                    }
                                    guard let url = urls.first else { return }
                                    do {
                                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
                                        converterManager.fileName = url.lastPathComponent
                                        converterManager.fileSize = fileAttributes[FileAttributeKey.size] as? Int64 ?? 0
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                case .failure(let error):
                                    print("Error selecting file \(error.localizedDescription)")
                                }
                            })
                        }
                    }
                    VStack(spacing: 20) {
                        Text("Set the pitch of the instrument to the pitch you need").foregroundColor(Color(.white)).font(.callout)
                            .multilineTextAlignment(.center).padding(.vertical, 5).padding(.top, 20).opacity(converterManager.isDone ? 1 : 0.5)
                        VStack {
                            Button(
                                action: {
                                    converterManager.increase()
                                }) {
                                    Image(systemName: "triangle.fill").foregroundColor(Color("Yellow")).font(.system(size: 50)).fontWeight(.bold)
                                }.opacity(!converterManager.isProcessConverter ? 1 : 0.5).disabled(converterManager.isProcessConverter ? true : false)
                            if converterManager.isProcessConverter {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).font(.largeTitle).frame(height: 50)
                            } else {
                                Text(converterManager.sign+"\(String(format: "%.0f", converterManager.frequencySelected))").foregroundColor(Color(.white)).font(.largeTitle).padding(.vertical, 0).frame(height: 50)
                            }
                            Button(
                                action: {
                                    converterManager.decrease()
                                }) {
                                    Image(systemName: "triangle.fill").foregroundColor(Color("Yellow")).font(.system(size: 50)).fontWeight(.bold).scaleEffect(CGSize(width: 1.0, height: -1.0))
                                }.opacity(!converterManager.isProcessConverter ? 1 : 0.5).disabled(converterManager.isProcessConverter ? true : false)
                        }.disabled(converterManager.isDone ? false : true).padding(.vertical, 10).opacity(converterManager.isDone ? 1 : 0.5)
                        HStack {
                            Toggle("Remove Vocals", isOn: $converterManager.isRemoveVocal)
                                .padding().foregroundColor(.white).font(.callout).frame(width: 200).onChange(of: converterManager.isRemoveVocal) { _ in
                                    converterManager.resetAudio()
                                    converterManager.convert()
                                }
                        }
                        .padding(.top, -10)
                        .opacity(converterManager.isDone ? 1 : 0.5).disabled(converterManager.isDone ? false : true)
                    }.padding(.top, 20)
                    HStack(spacing: 10) {
                        Button(
                            action: {
                                converterManager.playAudio()
                            }
                        ) {
                            Text("Play").font(.callout).foregroundColor(.white).underline()
                        }.opacity(converterManager.isDone ? 1 : 0.5).disabled(converterManager.isDone ? false : true)
                        Button(
                            action: {
                                converterManager.frequencySelected = 0
                                converterManager.signCheck()
                                converterManager.resetAudio()
                            }
                        ) {
                            Text("Reset").font(.callout).foregroundColor(.white).underline()
                        }.opacity(converterManager.isDone ? 1 : 0.5).disabled(converterManager.isDone ? false : true)
                    }.padding(.bottom, 25)
                    if converterManager.isDownload {
                        DownloadView()
                    } else {
                        Button(action: {
                            print("download file")
                            converterManager.downloadMP3Final()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Download Your Song")
                                    .font(.body).bold()
                                    .foregroundColor(Color("Blue")).padding(.leading, 0)
                            }.padding(20)
                        }.frame(maxWidth: .infinity).background(.white.opacity(converterManager.isDone ? 1 : 0.5)).cornerRadius(30).padding(.leading, 30).padding(.trailing, 30).cornerRadius(30).disabled(converterManager.isDone ? false : true)
                    }
                }.padding(30).padding(.top, 30).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Blue")).ignoresSafeArea().onAppear {
                    converterManager.setupAudioEngine()
                }.onDisappear {
                    // Dibungkus menjadi 1 fungsi yang meaningful yg menjalankan task di bawah ini
                    converterManager.resetAudio()
                    converterManager.audioEngine.stop()
                    converterManager.audioPlayerNode.stop()
                }
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
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black)).padding(0).font(.title).fontWeight(.none)
                Text("Uploading")
                    .font(.body).bold().padding(.leading, 5)
            }.padding(20)
                .foregroundColor(Color.black.opacity(0.5)).frame(maxWidth: .infinity).background(.white.opacity(0.5)).cornerRadius(30)
        }.disabled(true).padding(.trailing, 30).padding(.leading, 30)
    }
}
struct DownloadView: View {
    var body: some View {
        Button(action: {
        }) {
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black)).padding(0).font(.title).fontWeight(.none)
                Text("Downloading")
                    .font(.body).bold().padding(.leading, 5)
            }.padding(20)
                .foregroundColor(Color.black.opacity(0.5)).frame(maxWidth: .infinity).background(.white.opacity(0.5)).cornerRadius(30)
        }.disabled(true).padding(.trailing, 30).padding(.leading, 30)
    }
}
