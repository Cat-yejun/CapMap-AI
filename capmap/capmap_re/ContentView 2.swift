import SwiftUI

struct ContentView: View {
    var body: some View {
        
            NavigationView {
                VStack {
                    FilterView()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                
                            NavigationLink(destination: Nation2()) {
                                CountryProgressView(countryName: "독일", progress: 80, englishName: "Germany", imageName: "ger")
                                           }
                            

                            .buttonStyle(PlainButtonStyle())

                            CountryProgressView(countryName: "영국", progress: 30, englishName: "United Kingdom", imageName: "uk")
                            CountryProgressView(countryName: "아르헨티나", progress: 10, englishName: "Argentina", imageName: "arg")
                            CountryProgressView(countryName: "스웨덴", progress: 70, englishName: "Sweden", imageName: "swe")
                            CountryProgressView(countryName: "노르웨이", progress: 50, englishName: "Norway", imageName: "nor")
                            CountryProgressView(countryName: "브라질", progress: 20, englishName: "Brazil", imageName: "bra")
                        }
                        .padding()
                        
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Collection")
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 20))
                            .bold()
                            .foregroundStyle(.orange)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Search button tapped")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            
    }
}

struct FilterView: View {
    var body: some View {
        HStack {
            Button(action: {
                print("국가별 tapped")
                }) {
                    ZStack {
                        Text("국가별")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.orange)
                            .cornerRadius(20)
                            .foregroundStyle(.white)
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 5, height: 5)
                            .padding(.top, 60)
                    }
                }
            Button(action: {
                print("종류별 tapped")
            }) {
                Text("종류별")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                            .background(Color.white)
                    .cornerRadius(20)
                    .foregroundStyle(Color.orange)
            }
            Button(action: {
                print("날짜별 tapped")
            }) {
                Text("날짜별")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                            .background(Color.white)
                    .cornerRadius(20)
                    .foregroundStyle(Color.orange)
            }
            Button(action: {
                print("한정판 tapped")
            }) {
                Text("한정판")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                            .background(Color.white)
                    .cornerRadius(20)
                    .foregroundStyle(Color.orange)
            }
        }
        .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
    }
}

struct CountryProgressView: View {
    let countryName: String
    let progress: Int
    let englishName: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.orange)
                    .opacity(0.3)
                    .frame(width: 170, height: 180)
                Image("80%")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .offset(x: 25, y: 0)
                FlagView(imageName: imageName)
            }
            .padding([.top, .horizontal])
            .offset(x: 0, y: 0)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(countryName)
                    .font(Font.custom("NanumSquareRoundOTFB", size: 17))
                    .padding(.bottom, 5)
                    .offset(x: 20, y: 5)
                
                Text(englishName)
                    .font(Font.custom("NanumSquareRoundOTFB", size: 15))
                    .foregroundColor(.gray)
                    .offset(x: 20, y: 0)
            }
        }
        .padding(1)
    }
}

struct FlagView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .offset(x: 136, y: -85)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
