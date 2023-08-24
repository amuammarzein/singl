//
//  SongRecomendationShareView.swift
//  singl
//
//  Created by Aang Muammar Zein on 23/07/23.
//
import SwiftUI
struct SongRecomendationShareView: View {
    @EnvironmentObject var router: Router
    var isSinger: Bool
    @StateObject var taskManager: TaskManager = TaskManager()
    @StateObject var musicManager: MusicManager = MusicManager()
    @State var items: [Any] = []
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Image("SongShareTop").resizable().scaledToFit().frame(width: 150)
                    }
                    Spacer()
                    HStack {
                        Image("SongShareBottom").resizable().scaledToFit().frame(width: 150)
                        Spacer()
                        Image("LogoWhite").resizable().scaledToFit().frame(width: 60).padding(.trailing, 30).padding(.bottom, 150)
                    }
                }.ignoresSafeArea()
                VStack {
                    HStack(spacing: 0) {
                        Button(
                            action: {
                                taskManager.isMenuTrue()
                                router.path.removeLast(1)
                            }) {
                                Image(systemName: "chevron.left").foregroundColor(.white).font(.title3).fontWeight(.bold)
                                Text("Back").font(.body).foregroundColor(.white).fontWeight(.bold)
                            }
                        Spacer()
                    }.padding(.top, 10)
                    HStack {
                        Text(isSinger ? "Singers who share the same vocal type like me: " : "Song that match my vocal range: ").foregroundColor(.white).font(.title3).bold()
                            .multilineTextAlignment(.leading).padding(.top, 20).frame(maxWidth: CGFloat(screenWidth*0.5))
                        Spacer()
                    }
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
                                                    Text(item.singer).lineLimit(1).font(.title3).bold().foregroundColor(.white)
                                                    HStack {
                                                        Text(item.desc).lineLimit(1).font(.body).foregroundColor(.white)
                                                        Spacer()
                                                    }
                                                }
                                            }.padding(.bottom, 5)
                                        }.frame(maxWidth: .infinity)
                                    }
                                }.padding(.bottom, 0)
                            }
                            VStack {
                                Button(
                                    action: {
                                        self.items.removeAll()
                                        guard let resultImage = ImageRenderer(content: shareView).uiImage else {
                                            return
                                        }
                                        self.items.append(resultImage)
                                        taskManager.isShareTrue()
                                    }) {
                                        Text("Share to your story!").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                                    }.frame(maxWidth: .infinity).background(.white).cornerRadius(30)
                                    .sheet(isPresented: $taskManager.isShare) {
                                        ShareSheetView(items: items).edgesIgnoringSafeArea(.all)
                                    }
                            }.padding(.top, 30)
                        }.refreshable {
                            musicManager.getSongV2()
                        }.padding(.top, 20)
                    } else {
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
                                                    Text(item.title).lineLimit(1).font(.title3).bold().foregroundColor(.white)
                                                    HStack {
                                                        Text(item.singer).lineLimit(1).font(.body).foregroundColor(.white)
                                                        Spacer()
                                                    }
                                                }
                                            }.padding(.bottom, 5)
                                        }.frame(maxWidth: .infinity)
                                    }
                                }.padding(.bottom, 0)
                            }
                            VStack {
                                Button(
                                    action: {
                                        self.items.removeAll()
                                        guard let resultImage = ImageRenderer(content: shareView).uiImage else {
                                            return
                                        }
                                        self.items.append(resultImage)
                                        taskManager.isShareTrue()
                                    }) {
                                        Text("Share to your story!").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                                    }.frame(maxWidth: .infinity).background(.white).cornerRadius(30)
                                    .sheet(isPresented: $taskManager.isShare) {
                                        ShareSheetView(items: items).edgesIgnoringSafeArea(.all)
                                    }
                            }.padding(.top, 30)
                        }.refreshable {
                            musicManager.getSongV2()
                        }.padding(.top, 20)
                    }
                }.padding(.horizontal, 30)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Blue"))
        .navigationBarBackButtonHidden(true)
            .onAppear {
                musicManager.getSongV2()
            }
    }
    @State var screenWidthShare: CGFloat = 2000
    @State var screenHeightShare: CGFloat = 4330.18
    @State var fontSizeTitle: CGFloat = 2000/18
    @State var fontSizeTitleSub: CGFloat = 2000/20
    @State var fontSizeBody: CGFloat = 2000/25
    @State var fontSizeDesc: CGFloat = 2000/26.5
    @State var fontSizeCallout: CGFloat = 2000/45
    @State var padding: CGFloat = 2000/45
    var shareView: some View {
        VStack {
            ZStack {
                Image("SongShareFrame").resizable().scaledToFit().frame(maxWidth: .infinity).padding(0)
                VStack(spacing: padding) {
                    HStack(spacing: padding) {
                        if (taskManager.profilePhotoData != nil), let profilePhoto = UIImage(data: taskManager.profilePhotoData!) {
                            Image(uiImage: profilePhoto)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidthShare/10, height: screenWidthShare/10)
                                .clipShape(Circle())
                        } else {
                            Circle().foregroundColor(Color("Orange"))
                                .frame(width: screenWidthShare/10, height: screenWidthShare/10)
                                .clipShape(Circle())
                        }
                        Text(taskManager.fullName).font(.system(size: fontSizeDesc)).foregroundColor(.white).lineLimit(1)
                        Spacer()
                    }.padding(.bottom, padding * 6)
                    HStack {
                        Text(isSinger ? "Singers who share the same vocal type like me: " : "Song that match my vocal range: ").foregroundColor(.white).font(.system(size: fontSizeTitle)).bold()
                            .multilineTextAlignment(.leading).padding(.top, 20)
                        Spacer()
                    }.padding(.bottom, padding*2)
                    VStack(spacing: padding*2) {
                        ForEach(musicManager.arrSongsV2, id: \.self) { item in
                            if isSinger {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(item.singer).lineLimit(1).font(.system(size: fontSizeTitleSub)).bold().foregroundColor(.white).padding(.bottom, padding*0.5)
                                            HStack {
                                                Text(item.desc).lineLimit(1).font(.system(size: fontSizeBody)).foregroundColor(.white)
                                                Spacer()
                                            }
                                        }
                                    }.padding(.bottom, padding*0.5)
                                }.frame(maxWidth: .infinity)
                            } else {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(item.title).lineLimit(1).font(.system(size: fontSizeTitleSub)).bold().foregroundColor(.white).padding(.bottom, padding*0.5)
                                            HStack {
                                                Text(item.singer).lineLimit(1).font(.system(size: fontSizeBody)).foregroundColor(.white)
                                                Spacer()
                                            }
                                        }
                                    }.padding(.bottom, padding*0.5)
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }.padding(.bottom, 0)
                    Spacer()
                }.padding(.horizontal, CGFloat(screenWidthShare*0.1)).padding(.vertical, screenWidthShare*0.2)
            }
        }.frame(width: screenWidthShare, height: screenHeightShare).background(Color("Blue"))
    }
}
struct SongRecomendationShareView_Previews: PreviewProvider {
    static var previews: some View {
        let isSinger: Bool = true
        SongRecomendationShareView(isSinger: isSinger)
    }
}
