import SwiftUI

struct Nation2: View {
    let bottleCaps = [
        "beckscap", "heineken", "lion", "hoegaarden",
        "1664", "paulaner", "beer", "corona",
        "guinness", "miller", "cap1", "cap2", "cap3", "cap3", "cap3","cap3","cap3"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 400, height: 700)
                    .offset(y: 90)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(width: 50, height: 5)
                    .foregroundColor(.gray .opacity(0.3))
                    .offset(y: -240)
                
                VStack {
                    FilterView()
                    HStack {
                        Image("germany2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 80)
                            .offset(x: -100, y: 65)
                        
                        VStack(alignment: .leading) {
                            Text("독일")
                                .font(Font.custom("NanumSquareRoundOTFEB", size: 13))
                                .offset(x: -100, y: 65)
                            Text("Germany")
                                .foregroundColor(.gray)
                                .font(Font.custom("NanumSquareRoundOTFB", size: 13))
                                .offset(x: -100, y: 65)
                        }
                    }
                    .font(.title)
                    .padding(-30)
                    
                    ProgressBar(progress: 0.8)
                        .frame(height: 20)
                        .padding(10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
        
                            HStack(spacing: 10) {
                                Spacer()
                                ForEach(bottleCaps.prefix(4), id: \.self) { cap in
                                    if cap == "beckscap" {
                                        NavigationLink(destination: Bottle2()) {
                                            Image(cap)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        }
                                    } else {
                                        Image(cap)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    }
                                }
                                Spacer()
                            }

                           
                            HStack(spacing: 10) {
                                Spacer()
                                ForEach(bottleCaps.dropFirst(4).prefix(3), id: \.self) { cap in
                                    Image(cap)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            
                      
                            HStack(spacing: 10) {
                                Spacer()
                                ForEach(bottleCaps.dropFirst(7).prefix(4), id: \.self) { cap in
                                    Image(cap)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            
                       
                            HStack(spacing: 10) {
                                Spacer()
                                ForEach(bottleCaps.dropFirst(11).prefix(3), id: \.self) { cap in
                                    Image(cap)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                                }
                            
                            HStack(spacing: 10) {
                                Spacer()
                                ForEach(bottleCaps.dropFirst(12).prefix(4), id: \.self) { cap in
                                    Image(cap)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                                
                            }
                        }
                        .padding(60)
                    }
                }
            }
        }
    }
    
    struct ProgressBar: View {
        var progress: Float
        
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 9/15 * UIScreen.main.bounds.width, height: 20)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .offset(x: 40, y: 70)
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: CGFloat(progress) * 9/15 * UIScreen.main.bounds.width, height: 20)
                    .offset(x: 40, y: 70)
            }
            HStack{
                Text("12/15")
                    .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                    .foregroundColor(.orange)
                Text("caps")
                    .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                    .foregroundColor(.gray)
                    .offset(x: -4)
            }
            .offset(x: -120, y: 22)
        }
    }

struct Nation2_Previews: PreviewProvider {
    static var previews: some View {
        Nation2()
    }
}

