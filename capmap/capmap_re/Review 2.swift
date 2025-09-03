import SwiftUI

struct ReviewView: View {
    @State private var rating: Double = 4.5
    @State private var reviewText: String = ""
    @State private var date: Date = Date()
    @State private var selectedKeywords: Set<String> = ["깔끔함"]
    @State private var selectedSatisfactionIndex: Int?
    @State private var isNation2Presented = false


    let satisfactionImages = ["만족1", "보통1", "불만족1"]
        let nextSatisfactionImages = ["만족2", "보통2", "불만족2"]
        let keywords = ["달콤함", "부드러움", "깔끔함", "상큼함", "텁텁함", "쌉쌀함", "크리미", "신", "구수"]

        var body: some View {
            
            VStack(alignment: .center, spacing: 8) {
                Text("평점을 선택해주세요.")
                    .font(Font.custom("NanumSquareRoundOTFB", size: 20))
                    .font(.system(size: 20))
                    .padding(.bottom, 3)

                HStack {
                    Spacer()
                    ForEach(1..<6) { index in
                        Image(systemName: index <= Int(rating.rounded(.up)) ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                rating = Double(index)
                            }
                    }
                    Spacer()
                }
                .padding(.bottom, 50)

                VStack {
                    TextField("나의 21자 리뷰 입력하기", text: $reviewText)
                        .font(Font.custom("NanumSquareRoundOTFB", size: 15))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.bottom, 5)
                    
                    Text("\(reviewText.count)/21")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.custom("NanumSquareRoundOTFB", size: 15))
                }
                .padding(.bottom, 25)

                VStack(alignment: .leading, spacing: 8) {
                    VStack {
                        Text("날짜 입력")
                            .font(.headline)
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                        
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .font(.headline)
                            .datePickerStyle(CompactDatePickerStyle())
                            .offset(x: -210)
                    }
                }
                .padding(.leading, -270)
                .padding(.bottom, 25)


                VStack(alignment: .leading, spacing: 8) {
                    Text("만족도 입력")
                        .font(.headline)
                        .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                        .padding(.bottom, 8)
                    
                    HStack {
                        ForEach(satisfactionImages.indices, id: \.self) { index in
                            Button(action: {
                                if selectedSatisfactionIndex == index {
                                    selectedSatisfactionIndex = nil
                                } else {
                                    selectedSatisfactionIndex = index
                                }
                            }) {
                                Image(selectedSatisfactionIndex == index ? nextSatisfactionImages[index] : satisfactionImages[index])
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .padding()
                                    .background(selectedSatisfactionIndex == index ? Color.yellow : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .onTapGesture {
                                selectedSatisfactionIndex = (selectedSatisfactionIndex == index) ? (index + 1) % satisfactionImages.count : index
                            }
                        }
                    }
                    .padding(.bottom, 25)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("키워드 선택")
                            .font(.headline)
                            .font(Font.custom("NanumSquareRoundOTFEB", size: 15))

                        FlowLayout(mode: .scrollable, items: keywords, itemSpacing: 8) { keyword in
                            ZStack {
                                Button(action: {
                                    if selectedKeywords.contains(keyword) {
                                        selectedKeywords.remove(keyword)
                                    } else {
                                        selectedKeywords.insert(keyword)
                                    }
                                }) {
                                    Text(keyword)
                                        .foregroundColor(selectedKeywords.contains(keyword) ? Color(#colorLiteral(red: 1, green: 0.7215686275, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white.opacity(1))
                                        .cornerRadius(16)
                                        .font(Font.custom("NanumSquareRoundOTFB", size: 15))
                                }

                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedKeywords.contains(keyword) ? Color(#colorLiteral(red: 1, green: 0.7215686275, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)), lineWidth: 1.3)
                                    .padding(.horizontal, 1)
                                    .padding(.vertical, 10)
                            }
                        }
                        .padding(.bottom, 5)

                        HStack {
                            Spacer()
                            Button(action: {
                                selectedKeywords.removeAll()
                            }) {
                                Text("초기화")
                                    .font(Font.custom("NanumSquareRoundOTFB", size: 15))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 8)
                                    .background(Color.red)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.bottom, 35)

                }

                Spacer()

                Button(action: {
                    isNation2Presented = true
                }) {
                    Text("보관함에 추가")
                        .font(Font.custom("NanumSquareRoundOTFEB", size: 15))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(#colorLiteral(red: 1, green: 0.7215686275, blue: 0, alpha: 1)))
                        .cornerRadius(20)
                }
                .fullScreenCover(isPresented: $isNation2Presented) {
                    HomeView2()
                }

                
            }
            .padding(30)
        }
    }

struct FlowLayout<Content: View>: View {
    let mode: Mode
    let items: [String]
    let itemSpacing: CGFloat
    let content: (String) -> Content

    init(mode: Mode, items: [String], itemSpacing: CGFloat = 8, @ViewBuilder content: @escaping (String) -> Content) {
        self.mode = mode
        self.items = items
        self.itemSpacing = itemSpacing
        self.content = content
    }
    
    

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: itemSpacing) {
                ForEach(items, id: \.self) { item in
                    content(item)
                }
            }
            .padding(.horizontal, itemSpacing)
        }
    }

    enum Mode {
        case scrollable
        case fixed
    }
}

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}
