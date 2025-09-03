import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var scanProgress: Double = 80.0
    
    @State private var isReviewViewPresented = false

    
    var body: some View {
        ZStack {
            
            Image("becks")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("X")
                            .fontWeight(.bold)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                    }
                    .frame(height: 20)
                    .offset(y: 50)
                }
                .padding([.top, .trailing])
                Spacer()
            }
            
           
            VStack {
                Spacer()
                
                ZStack {
                    
                   
                    VStack {
                        Text("Scanning...")
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 20))
                            .foregroundColor(.white)
                        ProgressView(value: scanProgress, total: 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .frame(width: 150)
                    }
                    .offset(y: 270)
                }
                
                Spacer()
                
                Button(action: {
                    isReviewViewPresented.toggle()
                }) {
                   
                    VStack(spacing: 10) {
                        HStack {
                            Text("벡스")
                                .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                                .foregroundColor(.black)
                            
                            Text("(BECK'S)")
                                .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                                .foregroundColor(.gray)
                                .offset(x: -5)
                        }
                        .offset(x: 15, y: 43)
                        
                        HStack(alignment: .top, spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray.opacity(0.15))
                                    .frame(width: 110, height: 110)
                                
                                Image("becks2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .offset(y: 5)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("독일, 브레멘")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                        .foregroundColor(.black)
                                        .offset(x: -4, y: 37)
                                    
                                    HStack(spacing: 2) {
                                        Text("(Germany, Bremen)")
                                            .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                            .foregroundColor(.gray)
                                            .offset(x: -8, y: 37)
                                        
                                        Image("germany2")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                            .offset(x: -6, y: 37)
                                    }
                                    
                                    Button(action: {
                                        isReviewViewPresented.toggle()
                                    }) { Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                        .offset(x: 3, y: 50) }.fullScreenCover(isPresented: $isReviewViewPresented) {
                                            ReviewView()
                                                .foregroundColor(.black)
                                        }
                                }
                                
                                Text("1873")
                                    .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                    .foregroundColor(.black)
                                    .offset(x: -5, y: 35)
                                
                                HStack {
                                    Text("라거, 필스너")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                        .foregroundColor(.black)
                                        .offset(x: -4, y: 23)
                                    
                                    Text("(Lager)")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                        .foregroundColor(.gray)
                                        .offset(x: -8, y: 22)
                                    
                                    Text("5% ABV")
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                                        .foregroundColor(.black)
                                        .offset(x: -104, y: 37)
                                    
                                    Spacer()
                                }
                                .offset(y: 10)
                            }
                        }
                        .padding(.bottom, 25)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .frame(height: 135)
                    )
                    .frame(width: 350)
                    .padding(.bottom, 40)
                }
            }
            .fullScreenCover(isPresented: $isReviewViewPresented) {
                ReviewView()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
