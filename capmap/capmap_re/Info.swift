import SwiftUI

struct Info: View {
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack
            {
                
                Text("Cap Map에 관한\nInfoView 입니다. ")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding()
                Text("🍻")
                    .font(.system(size: 70))
            }
        }
                        
        /*
         Cap Map에 관한
         InfoView 입니다.
         
         서울여자대학교 [SwiftUI 앱 개발] 기말 프로젝트

         프로젝트 기간: 24.05.20 ~ 24.06.21
         팀원: 이루시아, 최윤영

         iPhone 15 Pro (17.5)에서 simulation하길 권장드리고
         HomeView(첫 화면)부터 시작하세요.
         
         Minimum Deployments: iOS 16.0
        */
    }
}

#Preview {
    Info()
}
