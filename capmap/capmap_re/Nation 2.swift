import SwiftUI

struct NationView: View {
    @State private var selectedFilter = 0
    let filters = ["국가별", "종류별", "날짜별", "한정판"]
    
    
    var body: some View {
        VStack {
            // 국가,종류,날짜,한정판 필터 부분
            FilterView()
            .padding()
            
            //가운데 내용 부분
            ZStack{
                Rectangle()
                                .fill(Color.white)
                                .frame(width: 400, height: 580)
                                .cornerRadius(50)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -5)
                Image("nationcap")
            }
            
            Spacer()
            
            // 하단 네비게이션 부분
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("보관함")
                }
                Text("친구")
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("친구")
                    }
                HomeView() // 홈 화면을 HomeView로 대체
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("홈")
                    }
                Text("챌린지")
                    .tabItem {
                        Image(systemName: "flag.fill")
                        Text("챌린지")
                    }
                Text("지도")
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("지도")
                    }
        }
    }
}

struct NationView_Previews: PreviewProvider {
    static var previews: some View {
        NationView()
    }
}
