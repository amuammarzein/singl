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
    
    @Published var arrSongsV2:[MasterModel] = []
    @Published var arrSingersV2:[MasterModel] = []
    
    @Published var arrSongs:[SongData] = []
    @Published var arrSingers:[SingerData] = []
    
    @Published var isLoading = true
    
    @Published var items:[MasterModel] = []
    @Published var master:[MasterModel] = [
        MasterModel(vocalType:"Sopran" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5 " , singer:"Agnez Mo" , idSinger:"716032350" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/5e/f5/bd/5ef5bdbf-2a45-d51a-0ad1-e358674cbb74/714fe883-9841-4130-8d08-85e45c98669c_file_cropped.png/380x380cc.webp")! , title:"Just Give Me A Reason - P!nk ft. Nate Ruess" , idSong:"545728467" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/2c/b0/de/2cb0de7b-4559-d885-36f8-271c950cba34/886443562097.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Sopran" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5 " , singer:"Ariana Grande" , idSinger:"412778295" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/b0/c1/95/b0c19533-8c69-6911-dba4-2770331a56e8/pr_source.png/380x380cc.webp")! , title:"Bang Bang - Ariana Grande, Jessie J, Nicki Minaj" , idSong:"1444896442" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/ce/81/a0/ce81a0d7-6beb-16bc-2b98-a6b6a9b0faff/14UMGIM31140.rgb.jpg/592x592bb.webp")! , desc:"Pop "),
        MasterModel(vocalType:"Sopran" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5 " , singer:"Isyana Sarasvati" , idSinger:"929562709" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/4c/77/1d/4c771d26-7f7c-1758-11e6-924b6ebbeb69/Jobc2dc6d23-38e9-4d45-88aa-4af2d13d404b-151248485-PreviewImage_preview_image_nonvideo_sdr-Time1686337955007.png/632x632bb.webp")! , title:"Cinta Luar Biasa - Andmesh" , idSong:"1483031827" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music113/v4/16/03/44/160344ed-9ce4-6338-8f8a-c88cb651f277/cover.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Sopran" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5 " , singer:"Kelly Clarkson" , idSinger:"316265" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video116/v4/5c/e8/6c/5ce86cf3-84e4-3cd2-7947-0978adb12d9d/Job9437c3bf-05b0-47e7-8292-ba2721adf319-151515181-PreviewImage_preview_image_nonvideo_sdr-Time1686849478588.png/2400x1350mv.webp")! , title:"Because of You - Kelly Clarkson" , idSong:"572528772" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/e3/7e/c5/e37ec5d7-725b-695c-333c-ee0deb5adcc6/dj.mveioodu.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Sopran" , vocalRange:"C4-C6" , frequency:"261.60 - 1046.5 " , singer:"Wendy of Redvelvet" , idSinger:"840523045" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages123/v4/dd/fd/36/ddfd3602-8541-adf9-1cea-45fff50e881e/7b413e6c-4a12-446c-be9f-b5a283d69c3a_ami-identity-317399b0b4ac8355018eb2b0ac198a38-2023-01-12T02-52-36.859Z_cropped.png/380x380cc.webp")! , title:"Feel My Rhythm - Red Velvet" , idSong:"1614179710" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video116/v4/52/69/ef/5269ef49-03c6-11f8-0387-853201745eb6/Job84311a79-226d-4855-9e82-c8d6769a2600-129778461-PreviewImage_preview_image_nonvideo_sdr-Time1647364761699.png/592x592bb.webp")! , desc:"Ballad"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Beyonce" , idSinger:"1419227" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video115/v4/53/eb/21/53eb21a9-922d-17cc-5520-a854319d5603/Job7c99ec90-f597-4f69-933a-c010d41e11d3-116418691-PreviewImage_preview_image_nonvideo_sdr-Time1625150847288.png/592x592bf.webp")! , title:"Halo - Beyonce" , idSong:"332706961" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/35/0f/55/350f55da-2104-162a-5872-cb35fef30410/mzi.morbeoaw.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Dua Lipa" , idSinger:"1031397873" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/d8/8f/4b/d88f4b28-d500-03e2-adc0-62dba9342ea6/190295092665.jpg/592x592bb.webp")! , title:"IDGAF - Dua Lipa" , idSong:"1228739604" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/34/d4/89/34d489f5-3066-d89e-ad44-6e28d6dd067e/190295807870.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Huh Yunjin of Le Sserafim" , idSinger:"1660901646" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages113/v4/c4/92/a7/c492a7ec-801f-f24e-7b27-601f1242b639/c919ab2b-2997-40e7-a648-0bdc4f1a8590_ami-identity-4025193d2f6cf1d3a6cc3cab1d5e3a12-2023-01-09T09-40-46.615Z_cropped.png/380x380cc.webp")! , title:"Love You Twice - Huh Yunjin" , idSong:"1676135273" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/22/98/e0/2298e07c-3663-7f98-f61c-1487e093ded7/196922396649_Cover.jpg/592x592bb.webp")! , desc:"R&B"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Jisoo of Blackpink" , idSinger:"1548008317" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/61/13/1f/61131f6c-d12a-19cb-333c-9c34eec0f23e/23UMGIM29712.rgb.jpg/592x592cc.webp")! , title:"Flower - Jisoo" , idSong:"1678664649" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/52/82/96/528296ca-3623-2b55-d8de-01c70eed7ab9/Jobf68a5174-ae5d-48ff-8b52-0a296f9dd800-148017739-PreviewImage_preview_image_nonvideo_sdr-Time1680538701091.png/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"A3-A5" , frequency:"220.0 - 880.0" , singer:"Olivia Rodrigo" , idSinger:"979458609" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/03/72/ac/0372ac58-0803-aa88-fc1e-b0d3694fee52/Jobbf18fd71-208e-429e-a261-b52065eb939a-152142469-PreviewImage_preview_image_nonvideo_sdr-Time1688074425860.png/2400x1350mv.webp")! , title:"Drivers License - Olivia Rodrigo" , idSong:"1560735480" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/f0/19/d6/f019d61e-6bd3-d936-1214-22b732083ef0/20UM1IM14285.rgb.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Adele" , idSinger:"262836961" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/a2/2d/df/a22ddf71-9254-043c-c162-11fbc25c5ff3/mzl.ilbjswky.jpg/380x380cc.webp")! , title:"Set Fire To The Rain - Adele" , idSong:"403037888" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/62/82/a5/6282a515-c95c-9e5e-3eef-4ef7b75639ca/191404113868.png/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Alicia Keys" , idSinger:"316069" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/07/d6/64/07d66459-66ee-d3f7-22bf-79b61e9df037/Job85870431-061f-44ea-9284-b177ddc6be48-148891620-PreviewImage_preview_image_nonvideo_sdr-Time1681932734147.png/592x592bb.webp")! , title:"If I Ain’t Got You - Alicia Keys" , idSong:"255343130" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/07/d6/64/07d66459-66ee-d3f7-22bf-79b61e9df037/Job85870431-061f-44ea-9284-b177ddc6be48-148891620-PreviewImage_preview_image_nonvideo_sdr-Time1681932734147.png/592x592bb.webp")! , desc:"R&B"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Fatin Shidqia Lubis" , idSinger:"469495225" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features116/v4/14/e7/18/14e71877-bda3-91e7-74a5-539a9543cee9/mzl.nqtniiui.jpg/380x380cc.webp")! , title:"Untuk Perempuan yang Sedang di Pelukan - Payung Teduh" , idSong:"936241611" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/23/1f/27/231f27f0-5396-f80b-fce1-7c8cd2c5a9d0/cover.jpg/592x592bb.webp")! , desc:"Indie"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Lorde" , idSinger:"602767352" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video115/v4/77/5c/fe/775cfe87-89b0-6472-0cf9-ea956f636d0a/Job7b5f2bf4-3e97-4f33-9d35-23869cb5252f-124113740-PreviewImage_preview_image_nonvideo_sdr-Time1632146473952.png/2400x1350mv.webp")! , title:"Royal - Lorde" , idSong:"1440818664" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/e1/d3/23/e1d323d6-a7e4-6d5e-e6f6-5105c76db133/13UAAIM68691.rgb.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Mezzo-Soprano" , vocalRange:"F3-F5" , frequency:"174.61 - 698.46" , singer:"Taylor Swift" , idSinger:"159260351" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/ae/28/6a/ae286a2f-06d0-ca72-6a05-3e5a7e2f5845/78d51110-6858-4d4c-912f-345313013400_ami-identity-994af5c375f4c3aa96cd6ced4a700799-2023-07-07T00-27-41.141Z_cropped.png/380x380cc.webp")! , title:"Enchanted - Taylor Swift" , idSong:"1440724801" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/24/86/bf/2486bf84-c38e-74f3-46d7-b3666a65d03b/10UMDIM00487.rgb.jpg/592x592bb.webp")! , desc:"Country"),
        MasterModel(vocalType:"Countertenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Adam Levine" , idSinger:"16053191" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features114/v4/33/b3/a6/33b3a666-77eb-4fac-83f8-1f3d620c183d/mzl.qblcmwcg.jpg/380x380cc.webp")! , title:"Payphone - Maroon 5" , idSong:"1440806731" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/1b/5b/95/1b5b95d1-b7f2-f2e9-acb2-22f558017056/12UMGIM26178.rgb.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Countertenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Charlie Puth" , idSinger:"336249253" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video112/v4/69/c2/23/69c223cf-1b97-8f02-81e1-54f13034c903/Jobb3243dad-5c44-4031-9489-91f45c67d8dc-133810727-PreviewImage_preview_image_nonvideo_sdr-Time1657289708009.png/592x592bb.webp")! , title:"One Call Away - Charlie Puth" , idSong:"1041127298" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/7e/05/fd/7e05fd3e-597b-db52-5d87-3ed146d2e2bb/mzm.omtrmqdi.jpg/592x592bb.webp")! , desc:"Soul"),
        MasterModel(vocalType:"Countertenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Dimash Qudaibergen" , idSinger:"1230538404" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/85/78/b0/8578b0e0-980d-1180-336d-7e2ca618a435/Jobe5afe42a-9426-49d0-9c12-c144544167ff-146858882-PreviewImage_preview_image_nonvideo_sdr-Time1679340628460.png/2400x1350mv.webp")! , title:"Lay Me Down - Sam Smith" , idSong:"1440838335" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/f2/59/8a/f2598a7e-945a-3cb6-24e1-9c3ead873760/15UMGIM50961.rgb.jpg/592x592bb.webp")! , desc:"Soul "),
        MasterModel(vocalType:"Countertenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Mitch Grassi of Pentatonix" , idSinger:"466047278" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/e8/8a/25/e88a2587-b241-7ebb-d823-904f13736ff1/pr_source.png/380x380cc.webp")! , title:"I AM - Ive" , idSong:"1680047366" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/8f/ef/eb/8fefeba8-07a1-96cc-4fb5-c4870526a288/Jobbd403b8e-6e3f-42a7-9d0e-264cad696d2f-148892937-PreviewImage_preview_image_nonvideo_sdr-Time1681934398996.png/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Countertenor" , vocalRange:"E3-E5" , frequency:"164.81 - 659.26" , singer:"Zayn Malik" , idSinger:"973181994" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/15/54/30/155430d1-1348-37cc-0c55-0033197d5925/a8aa25cd-ae65-4560-a5d6-5a5ee7170739_file_cropped.png/380x380cc.webp")! , title:"A Whole New World - Zayn Malik & Zhavia Ward" , idSong:"1462702887" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/d5/13/8f/d5138f37-6b5d-ddbc-1d36-b4b3433f62f1/19UMGIM38402.rgb.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Bruno Mars" , idSinger:"278873078" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/6d/ad/28/6dad2828-52c4-01dc-8e33-3ad3c05b73fd/pr_source.png/380x380cc.webp")! , title:"Just The Way You Are - Bruno Mars" , idSong:"576670459" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video115/v4/1a/e3/eb/1ae3eb3c-e5dc-bf37-88ef-64445c23ce9b/Jobd1844031-fc96-45f8-8029-eb7e248499d4-112739422-PreviewImage_preview_image_nonvideo_sdr-Time1620078591842.png/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Jongho of Ateez" , idSinger:"1439301205" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features126/v4/6c/94/93/6c949323-3e3c-45a8-0996-99ac22f22b5a/mzl.hxovjkxb.jpg/380x380cc.webp")! , title:"Set Me Free - Twice" , idSong:"1669081591" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/b8/43/cd/b843cd4f-33d2-9f12-c197-0cffae64c947/Job4152b600-ac90-4f9e-ae05-28fc1944791e-146370429-PreviewImage_preview_image_nonvideo_sdr-Time1678476123042.png/592x592bb.webp")! , desc:"Dance"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Ed Sheeran" , idSinger:"183313439" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features116/v4/24/2a/47/242a479e-5eac-fa17-5db1-5937b226ac04/mza_16354820982611288829.png/380x380cc.webp")! , title:"Photograph - Ed Sheeran" , idSong:"858517168" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/2d/36/f9/2d36f9a7-2c3e-ce0f-7fb6-036feecb221f/825646974450.jpg/592x592bb.webp")! , desc:"Ballad"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Judika" , idSinger:"311178669" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/c8/ce/71/c8ce715e-cb92-51dc-30b7-45d5993b9d20/mzl.wymwacke.jpg/380x380cc.webp")! , title:"Terimakasih Cinta - Afgan" , idSong:"1449847765" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/3e/f6/78/3ef678dd-821e-4e57-d19b-3a7fec525677/cover.jpg/592x592bb.webp")! , desc:"Jazz"),
        MasterModel(vocalType:"Tenor" , vocalRange:"C3-C5" , frequency:"13.81 - 523.25" , singer:"Jungkook of BTS" , idSinger:"785052275" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/ab/8d/ae/ab8dae8e-63d4-5b1e-07f2-f9a1fd2b4951/71d3737f-6855-4b3f-8e0e-69ee8f6e537e_ami-identity-be4a2146ef9622e76e6ab86b3c394556-2023-07-14T04-00-29.368Z_cropped.png/380x380cc.webp")! , title:"Dreamers - Jungkook" , idSong:"1655441868" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/03/c2/c0/03c2c0d5-bb76-e143-847f-52ff6c4c808f/197089992972.png/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Baritone" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Harry Styles" , idSinger:"471260289" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/FuseSocial123/v4/d5/b3/f2/d5b3f2a3-9433-7cea-874b-7faabe5a98df/Joba4c56afd-04f5-4547-a63d-23ea1e8e72cb-105965527-PreviewImage_preview_image_nonvideo_sdr-Time1584702089889.png/590x332sr.webp")! , title:"As It Was - Harry Styles" , idSong:"1615585008" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/2a/19/fb/2a19fb85-2f70-9e44-f2a9-82abe679b88e/886449990061.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Baritone" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Joji" , idSinger:"1258279972" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video128/v4/ed/01/9f/ed019fce-db73-3c90-4323-697b3349cd5a/ZZOPM1800595.sca1.jpg/400x226mv.webp")! , title:"Glimpse of Us - Joji" , idSong:"1625328892" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/f0/45/85/f0458570-7306-662e-01aa-a6bc3bded675/054391890016.jpg/592x592bb.webp")! , desc:"Alternative/Indie"),
        MasterModel(vocalType:"Baritone" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Troye Sivan" , idSinger:"396295677" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features126/v4/29/a6/7e/29a67ede-0004-7401-c388-d255c84dc40b/mzl.ejngdavp.jpg/220x220bb.webp")! , title:"Angel Baby - Troye Sivan" , idSong:"1584605492" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/9d/8b/a2/9d8ba26b-b1ae-0ea9-f911-b5e5a622a6db/21UMGIM85807.rgb.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Baritone" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"Tulus" , idSinger:"1001681665" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/6a/43/1b/6a431bb9-f901-02a3-8b38-91d901c54237/pr_source.png/380x380cc.webp")! , title:"Pamit - Tulus" , idSong:"1137907636" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music69/v4/3a/02/e9/3a02e9fa-adfe-fa30-4361-a7d68383ae74/cover.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Baritone" , vocalRange:"A2-A4" , frequency:"110.00 - 440.00" , singer:"V of BTS" , idSinger:"1191852113" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages113/v4/7a/c6/da/7ac6dab6-d20d-f1ea-e2e6-8f6cf6cc5c75/ced8a330-37c1-4606-8afd-4e939e91f2d9_ami-identity-f8ea6f27583bac896cb72f7438bef845-2022-12-27T04-59-31.370Z_cropped.png/380x380cc.webp")! , title:"Sial - Tiara Andini" , idSong:"1667204896" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music113/v4/ee/3c/96/ee3c9611-4be3-c95d-831a-1b85048c545f/cover.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Bebi Romeo" , idSinger:"292757061" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/7f/d5/4b/7fd54ba1-eb32-cd6d-13d6-ab7f441943d5/pr_source.png/220x220bb.webp")! , title:"Summertime Sadness - Lana Del Rey" , idSong:"1440830261" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5f/d9/63/5fd96387-45fa-6b94-afd8-7b2c4a24a93b/11UMGIM38959.rgb.jpg/592x592bb.webp")! , desc:"Alternative/Indie"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Felix of Stray Kids" , idSinger:"1304823362" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/00/6d/fe/006dfeff-d0cb-5917-402b-84bf16ad567e/pr_source.png/220x220bb.webp")! , title:"Deep End - Felix of Stray Kids" , idSong:"1657538114" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/b8/74/c0/b874c02b-4014-56cd-8a6c-ba456bd7cba7/738676860429_Cover.jpg/592x592bb.webp")! , desc:"Pop"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Giveon" , idSinger:"1070668868" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video112/v4/f1/e8/d7/f1e8d7d6-4aa1-10a9-2a8a-592507394239/Job75ba7c3e-141f-4bbb-afc2-2b7c652ef542-133280342-PreviewImage_preview_image_nonvideo_sdr-Time1656012783197.png/592x592bb.webp")! , title:"Heartbreak Anniversary - Giveon" , idSong:"1499127838" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/79/2a/75/792a75c1-1898-cb68-6988-123ade03d546/886448298816.jpg/592x592bb.webp")! , desc:"R&B"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"Luke Chiang" , idSinger:"1458311979" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/4b/c4/84/4bc48462-d11d-6496-fad7-3ea19416cc17/pr_source.png/380x380cc.webp")! , title:"Shouldn’t Be - Luke Chiang" , idSong:"1645603143" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/93/3a/8c/933a8cee-4501-b221-a949-86e189e15bd8/40038.jpg/632x632bb.webp")! , desc:"R&B"),
        MasterModel(vocalType:"Bass" , vocalRange:"E2-E4" , frequency:"82.407 - 329.63" , singer:"RM of BTS" , idSinger:"1439549457" , imgSinger:URL(string:"https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages112/v4/64/93/ce/6493ce6d-78be-2611-ec92-b00519bae188/c3630096-ccf9-4cab-ac92-ee3b3dd5fff2_ami-identity-06a2c233dad4e1410b8685c9abd4ab33-2022-12-02T09-57-04.230Z_cropped.png/380x380cc.webp")! , title:"Wild Flower - RM of BTS" , idSong:"1654548658" , imgSong: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/d4/1a/9c/d41a9c41-969b-7028-f987-04330aacf5f8/196922267253_Cover.jpg/632x632bb.webp")! , desc:"HipHop"),
    ]
    
    var taskManager:TaskManager = TaskManager()
    
    func getSongV2(){
        isLoading = true
        arrSongsV2.removeAll()
        for i in 0..<master.count {
            if(master[i].vocalType == taskManager.vocalType){
                arrSongsV2.append(master[i])
            }
        }
        isLoading = false
    }
    
    func getSingerV2(){
        isLoading = true
        arrSingersV2.removeAll()
        for i in 0..<master.count {
            if(master[i].vocalType == taskManager.vocalType){
                arrSingersV2.append(master[i])
            }
        }
        isLoading = false
    }
    
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
    
    func openAppleMusicSongV2(song: MasterModel) {
        print("https://music.apple.com/id/song/\(song.idSong)")
        let appleMusicURL = URL(string: "https://music.apple.com/id/song/\(song.idSong)")
        if let url = appleMusicURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func openAppleMusicSingerV2(artist: MasterModel) {
        print("https://music.apple.com/id/artist/\(artist.idSinger)")
        let appleMusicURL = URL(string: "https://music.apple.com/id/artist/\(artist.idSinger)")
        if let url = appleMusicURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
