//
//  MusicModel.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import Foundation
import MusicKit

struct SongData: Identifiable, Hashable {
    var id = UUID()
    let name : String
    let artist : String
    let imageUrl: URL?
    let albumName: String
    let idSong: String
}

struct SingerData: Identifiable, Hashable {
    var id:String = ""
    let name : String
    let description : String
    let genre : [String]
    let imageUrl: URL?
}

struct MasterModel:Identifiable,Hashable {
    var id = UUID()
    var vocalType: String = ""
    var vocalRange: String = ""
    var frequency: String = ""
    var singer: String = ""
    var title: String = ""
    var idx: Int = 0
}
