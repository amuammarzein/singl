//
//  MusicManager.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI
import MusicKit
import StoreKit
import MediaPlayer

class MusicManager: ObservableObject {
    
    @Published var songs:[SongData] = []
    @Published var singers:[SingerData] = []
    
    @Published var arrSongs:[SongData] = []
    @Published var arrSingers:[SingerData] = []
    @Published var isLoading = true
    
    @Published var items:[MasterModel] = []
    @State var master:[MasterModel] = [
        MasterModel(vocalType:"Soprano" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5" , singer:"Agnez Mo" , title:"Just Give Me A Reason - P!nk ft. Nate Ruess"),
        MasterModel(vocalType:"Soprano" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5" , singer:"Ariana Grande" , title:"Bang Bang - Ariana Grande, Jessie J, Nicki Minaj"),
        MasterModel(vocalType:"Soprano" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5" , singer:"Isyana Sarasvati" , title:"Cinta Luar Biasa - Andmesh"),
        MasterModel(vocalType:"Soprano" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5" , singer:"Kelly Clarkson" , title:"Because of You - Kelly Clarkson"),
        MasterModel(vocalType:"Soprano" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5" , singer:"Wendy of Redvelvet" , title:"Feel My Rhythm - Red Velvet"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Beyonce" , title:"Halo - Beyonce"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Dua Lipa" , title:"IDGAF - Dua Lipa"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Huh Yunjin of Le Sserafim" , title:"Love You Twice - Huh Yunjin"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Jisoo of Blackpink" , title:"Flower - Jisoo"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Olivia Rodrigo" , title:"Drivers License - Olivia Rodrigo"),
        MasterModel(vocalType:"Alto" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Adele" , title:"Set Fire To The Rain - Adele"),
        MasterModel(vocalType:"Alto" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Alicia Keys" , title:"If I Ain't Got You - Alicia Keys"),
        MasterModel(vocalType:"Alto" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Fatin Shidqia Lubis" , title:"Untuk Perempuan yang Sedang di Pelukan - Payung Teduh"),
        MasterModel(vocalType:"Alto" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Nicki Minaj" , title:"Fana Merah Jambu - Fourtwenty"),
        MasterModel(vocalType:"Alto" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Taylor Swift" , title:"Enchanted - Taylor Swift"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Danilla Riyadi" , title:"Dalam Nirvana - Danilla Riyadi"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Katy Perry" , title:"Dark Horse - Katy Perry"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Lady Gaga" , title:"Bad Romance - Lady Gaga"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Lana Del Rey" , title:"Born To Die - Lana Del Rey"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Lorde" , title:"Royal - Lorde"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"130.81 - 523.25" , singer:"Adam Levine" , title:"Payphone - Maroon 5"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"130.81 - 523.25" , singer:"Charlie Puth" , title:"One Call Away - Charlie Puth"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"130.81 - 523.25" , singer:"Dimash Qudaibergen" , title:"Lay Me Down - Sam Smith"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"130.81 - 523.25" , singer:"Mitch Grassi of Pentatonix" , title:"I AM - Ive"),
        MasterModel(vocalType:"Counter Tenor" , vocalRange:"E3-E5" , frequency:"130.81 - 523.25" , singer:"Zayn Malik" , title:"A Whole New World - Zayn Malik & Zhavia Ward"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Bruno Mars" , title:"Just The Way You Are - Bruno Mars"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Jongho of Ateez" , title:"Set Me Free - Twice"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Ed Sheeran" , title:"Photograph - Ed Sheeran"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Judika" , title:"Terimakasih Cinta - Afgan"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Jungkook of BTS" , title:"Dreamers - Jungkook"),
        MasterModel(vocalType:"Bariton" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Harry Styles" , title:"As It Was - Harry Styles"),
        MasterModel(vocalType:"Bariton" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Joji" , title:"Glimpse of Us - Joji"),
        MasterModel(vocalType:"Bariton" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Troye Sivan" , title:"Angel Baby - Troye Sivan"),
        MasterModel(vocalType:"Bariton" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Tulus" , title:"Pamit - Tulus"),
        MasterModel(vocalType:"Bariton" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"V of BTS" , title:"Sial - Tiara Andini"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Bebi Romeo" , title:"Summertime Sadness - Lana Del Rey"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Felix of Stray Kids" , title:"Deep End - Felix of Stray Kids"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Giveon" , title:"Heartbreak Anniversary - Giveon"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Luke Chiang" , title:"Shouldn't Be - Luke Chiang"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"RM of BTS" , title:"Wild Flower - RM of BTS"),
    ]
    
    var taskManager:TaskManager = TaskManager()
    
    
    func getSong(limit:Int){
        items.removeAll()
        for i in 0..<master.count {
            if(master[i].vocalType == taskManager.vocalType){
                items.append(master[i])
            }
        }
        arrSongs.removeAll()
        for i in 0..<items.count {
            print(items[i].singer)
            getMusic(singer: items[i].singer,limit:limit)
        }
    }
    
    func getSinger(limit:Int){
        items.removeAll()
        for i in 0..<master.count {
            if(master[i].vocalType == taskManager.vocalType){
                items.append(master[i])
            }
        }
        arrSingers.removeAll()
        for i in 0..<items.count {
            getSinger(singer: items[i].singer,limit:limit)
        }
    }
    
    func getSinger(singer:String,limit:Int) {
        isLoading = true
        
        let request: MusicCatalogSearchRequest = {
            var request = MusicCatalogSearchRequest(
                term: singer,
                types: [Artist.self]
            )
            request.limit = 1
            return request
        }()
        
        Task {
            // Request permission
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                // Request -> Response
                do {
                    let result = try await request.response()
                    //Assign songs
                    //                    DispatchQueue.main.async {
                    self.singers = result.artists.compactMap({
                        return .init(
                            name: $0.name,
                            description: $0.description,
                            genre: $0.genreNames ?? [""],
                            imageUrl: $0.artwork?.url(width: 250, height: 250)
                        )
                    })
                    //                    }
                    print(self.singers)
                    isLoading = false
                    self.arrSingers.append(contentsOf: singers)
                } catch {
                    print(String(describing: error))
                }
            default:
                break
            }
        }
    }
    
    func getMusic(singer:String,limit:Int) {
        isLoading = true
        
        let request: MusicCatalogSearchRequest = {
            var request = MusicCatalogSearchRequest(
                term: singer,
                types: [Song.self]
            )
            request.limit = limit
            return request
        }()
        
        Task {
            // Request permission
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                // Request -> Response
                do {
                    let result = try await request.response()
                    //Assign songs
                    //                    DispatchQueue.main.async {
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title, artist: $0.artistName, imageUrl: $0.artwork?.url(width: 250, height: 250),
                                     albumName: $0.albumTitle ?? "album",
                                     idSong: $0.id.rawValue)
                    })
                    //                    }
                    
                    isLoading = false
                    
                    self.arrSongs.append(contentsOf: songs)
                } catch {
                    print(String(describing: error))
                }
            default:
                break
            }
        }
    }
    
    func openAppleMusicSong(song: SongData) {
        print("https://music.apple.com/id/song/\(song.idSong)")
        let appleMusicURL = URL(string: "https://music.apple.com/id/song/\(song.idSong)")
        if let url = appleMusicURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func openAppleMusicSinger(artist: SingerData) {
        print("https://music.apple.com/id/artist/\(artist.id)")
        let appleMusicURL = URL(string: "https://music.apple.com/id/artist/\(artist.id)")
        if let url = appleMusicURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
