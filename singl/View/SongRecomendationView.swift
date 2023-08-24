//
//  SongRecomendationView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI

struct SongRecomendationView: View {
    @EnvironmentObject var router: Router
    @StateObject var taskManager: TaskManager = TaskManager()
    @StateObject var musicManager: MusicManager = MusicManager()
    @State var isSinger: Bool
    var body: some View {
        VStack {
            HStack {
                if (taskManager.profilePhotoData != nil), let profilePhoto = UIImage(data: taskManager.profilePhotoData!) {
                    Image(uiImage: profilePhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Circle().foregroundColor(Color("Orange"))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                Text(taskManager.fullName).font(.body).foregroundColor(.white)
                Spacer()
                Button(
                    action: {
                        taskManager.isMenuFalse()
                        router.path.append(Destination.songRecomendationShareView(isSinger))
                    }
                ) {
                    Image(systemName: "square.and.arrow.up").font(.title3).foregroundColor(.white)
                }
            }.padding(.top, 10)
            HStack {
                HStack {
                    Text("Singers like You").font(.callout).bold().foregroundColor(isSinger ? .black : .white).padding(10)
                }.background(isSinger ? .white : .clear).cornerRadius(13).padding(2).onTapGesture {
                    isSinger = true
                    musicManager.getSongV2()
                }
                HStack {
                    Text("Songs for You").font(.callout).bold().foregroundColor(!isSinger ? .black : .white).padding(10)
                }.background(!isSinger ? .white : .clear).cornerRadius(13).padding(2).onTapGesture {
                    isSinger = false
                    musicManager.getSongV2()
                }
            }.background(.black.opacity(0.3)).cornerRadius(15).padding(.top, 30)
            Text(isSinger ? "Singers with a vocal range similar to yours: " : "Songs that match your vocal range: ").foregroundColor(.white).font(.title3).bold()
                .multilineTextAlignment(.center).padding(.top, 20)
            if isSinger {
                ScrollView(.vertical, showsIndicators: false) {
                    if musicManager.isLoading {
                        HStack(spacing: 5) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .font(.body)
                        }.frame(height: 20)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                Button(
                                    action: {
                                        musicManager.openAppleMusicSingerV2(artist: item)
                                    }
                                ) {
                                    VStack {
                                        HStack {
                                            AsyncImage(url: item.imgSinger) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit).frame(width: 80, height: 80).cornerRadius(15)
                                            } placeholder: {
                                                ShimmerView().frame(width: 80, height: 80).cornerRadius(15)
                                            }
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(item.singer).lineLimit(1).font(.title3).bold().foregroundColor(Color("Blue"))
                                                HStack {
                                                    Text(item.desc).lineLimit(1).font(.body).foregroundColor(Color("Blue"))
                                                    Spacer()
                                                }
                                            }
                                        }.padding(5)
                                    }.frame(maxWidth: .infinity).background(.white).cornerRadius(15)
                                }.foregroundColor(.black)                                }
                        }.padding(.bottom, 130)
                    }
                }.refreshable {
                    musicManager.getSongV2()
                }.padding(.top, 20)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    if musicManager.isLoading {                            HStack(spacing: 5) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .font(.body)
                    }.frame(height: 20)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(musicManager.arrSongsV2, id: \.self) { item in
                                VStack {
                                    HStack {
                                        AsyncImage(url: item.imgSong) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit).frame(width: 80, height: 80).cornerRadius(15)
                                        } placeholder: {
                                            ShimmerView().frame(width: 80, height: 80).cornerRadius(15)
                                        }
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(item.title).lineLimit(1).font(.title3).bold().foregroundColor(Color("Blue"))
                                            HStack {
                                                Text(item.singer).lineLimit(1).font(.body).foregroundColor(Color("Blue"))
                                                Spacer()
                                                Button(
                                                    action: {
                                                        musicManager.openAppleMusicSongV2(song: item)
                                                    }
                                                ) {
                                                    HStack(spacing: 3) {
                                                        Text("Play").font(.body).foregroundColor(.white)
                                                        Image(systemName: "play.fill").font(.title3).foregroundColor(.white)
                                                    }.padding(.horizontal, 10).padding(.vertical, 5)
                                                }.background(Color("Blue")).cornerRadius(15)
                                            }
                                        }
                                    }.padding(5)
                                }.frame(maxWidth: .infinity).background(.white).cornerRadius(15)
                            }
                        }.padding(.bottom, 130)
                    }
                }.refreshable {
                    musicManager.getSongV2()
                }.padding(.top, 20)
            }
        }.padding(.horizontal, 30).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Blue")).onAppear {
            musicManager.getSongV2()
        }
    }
}
struct SongRecomendationView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isSinger: Bool = true
        SongRecomendationView(isSinger: isSinger)
    }
}
