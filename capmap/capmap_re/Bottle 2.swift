import SwiftUI


struct BottleView: View {
    @State private var selectedFilter = 0
    let filters = ["국가별", "종류별", "날짜별", "한정판"]
   
    
    var body: some View {
        VStack {
            // 국가,종류,날짜,한정판 필터 부분
            Picker(selection: $selectedFilter, label: Text("Filter")) {
                ForEach(0..<filters.count) { index in
                    Text(self.filters[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            //가운데 내용 부분
            ZStack {
                Rectangle()
                    .fill(Color(red: 1.0, green: 184.0/255.0, blue: 0.0)) // RGB 값을 사용한 색상
                    .frame(width: 400, height: 580)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                
                Image("nationcap2")
            }

            
            Spacer()
            
            // 하단 네비게이션 부분
            HStack {
                Spacer()
                Image(systemName: "archivebox.fill")
                Spacer()
                Image(systemName: "person.2.fill")
                Spacer()
                Image(systemName: "house.fill")
                Spacer()
                Image(systemName: "trophy.fill")
                Spacer()
                Image(systemName: "map.fill")
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
        }
    }
}

struct Bottle_Previews: PreviewProvider {
    static var previews: some View {
        BottleView()
    }
}
