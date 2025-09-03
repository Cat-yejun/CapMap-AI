import SwiftUI

struct SlideOverCard<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                Color.clear
                    .frame(height: 1000)
                    .background(Color.black.opacity(0.2))
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .offset(y: 190) 

                
                VStack {
                    Spacer()
                    self.content
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 20)
                        .frame(maxWidth: .infinity)
                }
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
    }
}
