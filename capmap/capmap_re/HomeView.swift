import SwiftUI

struct HomeView2: View {
    @State private var isCameraViewPresented = false

    
    var body: some View {
        TabView {
            
            NavigationView {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 800, height: 800)
                            .offset(y: 400)
                            .foregroundColor(.orange)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 330, height: 140)
                            .offset(y: 230)
                        
                        
                        VStack {
                            Button(action: {
                                isCameraViewPresented.toggle()
                            }) {
                                Image("Empty_Bottle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 450)
                                    .foregroundColor(.yellow)
                                    .offset(x: 5, y: -90)
                            }
                        }
                        
                        VStack {
                            Text("You Collected")
                                .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 0) {
                                Text("369")
                                    .font(Font.custom("NanumSquareRoundOTFEB", size: 25))
                                    .bold()
                                    .foregroundColor(.black)
                                
                                Text(" caps!")
                                    .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                    .bold()
                                    .foregroundColor(.black)
                            }
                        }
                        .offset(y: -120)
                        
                      
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 40)
                                .offset(x: -125, y: 200)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange)
                                .frame(width: 80, height: 15)
                                .offset(x: -50, y: 190)
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray .opacity(0.4))
                                .offset(x: -125, y: 200)
                            Text("전설의 맥주왕")
                                .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                .foregroundColor(.white)
                                .offset(x: -50, y: 190)
                            Text("Lv. 6")
                                .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                .foregroundColor(.orange)
                                .offset(x: 10, y: 190)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3) { _ in
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: 20)
                                    .offset(x: -50, y: 220)
                            }
                        }
                        .padding(.horizontal)
                        
                        ZStack(alignment: .leading) {
                           
                            ZStack {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 290, height: 30)
                                
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 280, height: 20)
                                        .alignmentGuide(.leading) { _ in 0 }
                                    Capsule()
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                        .frame(width: 200, height: 20)
                                }
                            }
                            .offset(y: 260)
                            
                            Text("80/100")
                                .font(Font.custom("NanumSquareRoundOTFEB", size: 10))
                                .foregroundColor(.white)
                                .offset(x: 125, y: 260)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                           
                                Text("Cap Map")
                                    .font(Font.custom("NanumSquareRoundOTFEB", size: 20))
                                    .bold()
                                    .foregroundStyle(.orange)
                    
                                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Search button tapped")
                        }) {
                            Image(systemName: "person.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isCameraViewPresented) {
                CameraView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("홈")
            }
            
            ContentView()
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("보관함")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("지도")
                }

            Text("친구")
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("친구")
                }

            Text("챌린지")
                .tabItem {
                    Image(systemName: "flag.fill")
                    Text("챌린지")
                }

            

        }
        .accentColor(.orange)
    }
    
}




#Preview {
    HomeView2()
}
