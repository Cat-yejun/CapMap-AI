import SwiftUI
import MapKit

struct MapView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                MapView2()
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        TextField("Search", text: $searchText)
                            .padding(7)
                        Button(action: {
                            print("Voice search button tapped")
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .padding()
                    Spacer()
                }
                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 400, height: 100)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.8), lineWidth: 0.9)
                    )
                    .offset(y: 405)
            }
            .navigationBarHidden(true)
        }
    }
}

struct MapView2: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
    )
    
    @State private var isCardPresented = false
    @State private var selectedCountry: String?

    struct BottleCap: Identifiable {
        var id = UUID()
        var country: String
        var collectedCount: Int
        var totalCount: Int
        var imageName: String?
    }

    let bottleCaps = [
        BottleCap(country: "USA", collectedCount: 10, totalCount: 20, imageName: "us"),
        BottleCap(country: "Germany", collectedCount: 12, totalCount: 15, imageName: "ger"),
        BottleCap(country: "Japan", collectedCount: 15, totalCount: 25, imageName: "jap"),
    ]

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: bottleCaps) { bottleCap in
                MapAnnotation(coordinate: coordinate(for: bottleCap.country)) {
                    Image(bottleCap.imageName!)
                        .font(.system(size: CGFloat(30 + bottleCap.collectedCount)))
                        .foregroundColor(.orange)
                        .bold()
                        .background(Color.white)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                selectedCountry = bottleCap.country
                                isCardPresented = true
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            SlideOverCard(isPresented: $isCardPresented) {
                VStack {
                    VStack {
                        Image("not")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .offset(x: -135, y: 22)
                        
                        Text("미수집")
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 10))
                            .foregroundStyle(.orange)
                            .offset(x: -135, y: 15)
                    }
                    
                    if let country = selectedCountry {
                        Text(country)
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 20))
                            .offset(y: -18)
                        
                        let collectedCount = bottleCaps.first { $0.country == country }?.collectedCount ?? 0
                        let totalCount = bottleCaps.first { $0.country == country }?.totalCount ?? 0
                        let notCollectedCount = totalCount - collectedCount
                        
                        VStack {
                            if country == "Japan" {
                                Image("not_ger")
                                    .offset(y: -10)
                                ZStack {
                                    Text("아사히 수퍼드라이")
                                        .foregroundStyle(.orange)
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .offset(x: -50, y: -18)
                                    
                                    Text("(Super Dry)")
                                        .foregroundStyle(.orange .opacity(0.8))
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .foregroundStyle(.gray)
                                        .offset(x: 77, y: -18)
                                    
                                    Text("일본, 도쿄\n1987\n드라이\n5% ABV")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .offset(x: -88, y: 32)
                                    
                                    Text("(Japan, Tokyo)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: -5, y: 9)
                                    
                                    Text(" (Dry)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: -59, y: 40)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: 140, y: -130)
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: -140, y: -130)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.orange)
                                        .opacity(0.15)
                                        .frame(width: 300, height: 130)
                                        .offset(y: 15)
                                }
                                
                            } else if country == "Germany" {
                                Image("not_ger")
                                    .offset(y: -10)
                                ZStack {
                                    Text("바이엔슈테판 비투스")
                                        .foregroundStyle(.orange)
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .offset(x: -34, y: -18)
                                    
                                    Text("(Vitus)")
                                        .foregroundStyle(.orange .opacity(0.8))
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .foregroundStyle(.gray)
                                        .offset(x: 77, y: -18)
                                    
                                    Text("독일, 바이에른\n2007\n바이젠복\n7.7% ABV")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .offset(x: -68, y: 32)
                                    
                                    Text("(Germany, Bayern)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: 44, y: 9)
                                    
                                    Text(" (Weizenbock)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: -9, y: 40)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: 140, y: -130)
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: -140, y: -130)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.orange)
                                        .opacity(0.15)
                                        .frame(width: 300, height: 130)
                                        .offset(y: 15)
                                }
                            } else if country == "USA" {
                                Image("not_ger")
                                    .offset(y: -10)
                                ZStack {
                                    Text("버드와이저")
                                        .foregroundStyle(.orange)
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .offset(x: -82, y: -18)
                                    
                                    Text("(Budweiser)")
                                        .foregroundStyle(.orange .opacity(0.8))
                                        .font(Font.custom("NanumSquareRoundOTFEB", size: 18))
                                        .foregroundStyle(.gray)
                                        .offset(x: 20, y: -18)
                                    
                                    Text("미국, 앤하이저부시\n1876\n라거\n5.0% ABV")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .offset(x: -68, y: 32)
                                    
                                    Text("(USA, ABI)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: 24, y: 9)
                                    
                                    Text(" (Larger)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 14))
                                        .foregroundStyle(.gray)
                                        .offset(x: -65, y: 40)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: 140, y: -130)
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                        .offset(x: -140, y: -130)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.orange)
                                        .opacity(0.15)
                                        .frame(width: 300, height: 130)
                                        .offset(y: 15)
                                }
                            }
                            
                            HStack {
                                Text("Collected: \(collectedCount)")
                                    .padding()
                                
                                Text("Not Collected: \(notCollectedCount)")
                                    .padding()
                                
                                Text("Total: \(totalCount)")
                                    .padding()
                            }
                            .font(Font.custom("NanumSquareRoundOTFB", size: 12))
                            .offset(y: 10)
                        }
                        
                        Spacer()
                    } else {
                        Text("Select a Country")
                            .font(.title)
                            .padding()
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: 350, maxHeight: 400)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .offset(y: -180)



        }
    }

    func coordinate(for country: String) -> CLLocationCoordinate2D {
        switch country {
        case "USA":
            return CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129)
        case "Germany":
            return CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515)
        case "Japan":
            return CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
        default:
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct MapView2_Previews: PreviewProvider {
    static var previews: some View {
        MapView2()
    }
}
