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
    var idSinger: String = "573962555"
    var imgSinger: URL = URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/4a/1f/f1/4a1ff100-6ae0-7bbf-1783-f8a1ae4497bb/Jobf1fd596f-1dec-42fe-82de-ec718f7ec16e-144310006-PreviewImage_preview_image_nonvideo_sdr-Time1675794870812.png/592x592bb.webp")!
    var title: String = ""
    var idSong: String = "278873078"
    var imgSong: URL = URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/6d/ad/28/6dad2828-52c4-01dc-8e33-3ad3c05b73fd/pr_source.png/380x380cc.webp")!
    var desc: String = "Member of Kpop Group"
    var idx: Int = 0
}
