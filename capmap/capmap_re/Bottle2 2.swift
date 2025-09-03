import SwiftUI

struct Bottle2: View {
    @State private var isLiked = false
    var body: some View {
        ZStack{
            
            
                
            Image("y_rec")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 670)
                        .clipped()
            Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .foregroundColor(isLiked ? .red : .white)
                            .frame(width: 20,height: 20)
                            
                            
                    }.offset(x: -140, y: -280)
                
            
            VStack(spacing: 16) {

                VStack {
                    Image("becksbottle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 220)
                        .offset(y:50)
                        .padding(.bottom, 90)
                    
                    Text("BECK'S")
                        .font(Font.custom("NanumSquareRoundOTFEB", size: 11))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, -20)

                    Text("벡스")
                        .font(Font.custom("NanumSquareRoundOTFEB", size: 22))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, -10)

                    
                    Text("독일, 브레멘 | 1873 | 라거, 필스너 | 5% ABV")
                        .font(Font.custom("NanumSquareRoundOTFB", size: 12))
                        .padding(.bottom, -5)
                        .padding(.top, -3)
                        .foregroundColor(.white.opacity(0.8))
                    

                    
                    HStack(spacing:3) {
                        Text("4.5")
                            .font(Font.custom("NanumSquareRoundOTFB", size: 18))
                            .offset(y: 2)
                            .padding(.trailing,5)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Image(systemName: "star.leadinghalf.filled")
                            .foregroundColor(.yellow)
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(60)
                    .frame(width: 300, height: 60)
                    .padding(.horizontal)
                    
                }

                
                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Image(systemName: "checkmark.seal.fill")
                                .offset(x: -13)
                            Text("Cap Tip")
                                .font(Font.custom("NanumSquareRoundOTFEB", size: 17))
                                .offset(x: -14)
                                
                                
                        }.padding(.top, -16)
                            .foregroundColor(.white)
                        
                        Text("벡스는 필스너 스타일의 맥주로 가벼운 바디와 깨끗한 맛이 특징으로\n청순한 홉의 맛이 두드러지며 상쾌하고 깔끔한 피니시를 자랑합니다.\n이러한 특징은 벡스를 세계적으로 사랑받게 만든 이유 중 하나입니다.")
                            .font(Font.custom("NanumSquareRoundOTFB", size: 11))
                            .foregroundColor(.white)
                            .padding(.horizontal, -10)
                            .lineSpacing(3.5)
                        
                        .multilineTextAlignment(.center)
                    }
                    .padding()
                    .cornerRadius(10)
                    .padding(.horizontal)


                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        Image(systemName: "face.smiling.inverse")
                        Text("나의 21자 리뷰")
                            .font(.headline)
                            
                    }.padding(.top, -10)
                        .foregroundColor(.white)
                    
                    ZStack{
                        Rectangle()
                            .fill(Color(red: 255/255, green: 234/255, blue: 178/255))
                            .cornerRadius(20)
                            .frame(width: 310, height: 30)
                        
                        Text("상쾌하고 여행하면서 마시니까 짱 좋다!")
                            .font(Font.custom("NanumSquareRoundOTFB", size: 12))
                            .foregroundColor(Color(red: 65/255, green:65/255, blue: 65/255))
                        
                        Image(systemName: "pencil")
                            .offset(x:120)
                            .foregroundColor(Color(red: 65/255, green:65/255, blue: 65/255))
                            
                    }
                    
                        Text("2024.03.22")
                        .font(Font.custom("NanumSquareRoundOTFB", size: 10))
                            .padding(.top,0)
                            .foregroundColor(.white)
                }
                
               
            }
            .padding()
           
        }
        .navigationBarBackButtonHidden(true)

    }
    
       }

#Preview {
    Bottle2()
}
