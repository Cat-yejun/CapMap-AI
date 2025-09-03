import SwiftUI
import AVFoundation


struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isReviewViewPresented = false
    @State private var isCameraButtonPressed = false  // @State 변수를 body 외부에 선언

    var body: some View {

        ZStack {
            viewModel.cameraPreview.ignoresSafeArea()
                .onAppear {
                    viewModel.configure()
                }
            
//            Image("test")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .edgesIgnoringSafeArea(.all)

            CameraOverlayView()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left") // 화살표 Image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.03)
                            .foregroundColor(.white)
                        Text("")
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top, UIScreen.main.bounds.height * -0.01)

                Spacer()
            }
            
            VStack {
//                Spacer()
                
//                ZStack {
//                    
//                   
//                    VStack {
//                        Text("Scanning...")
//                            .font(Font.custom("NanumSquareRoundOTFEB", size: 20))
//                            .foregroundColor(.white)
//                        ProgressView(value: scanProgress, total: 100)
//                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
//                            .frame(width: 150)
//                    }
//                    .offset(y: 270)
//                }
                
//                Spacer()
                
                if isCameraButtonPressed {
                    
                    Button(action: {
                        // 현재 뷰를 닫고 리뷰 시트를 표시
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
                        .padding(.bottom, 0)
                    }
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $isReviewViewPresented) {
                ReviewView()
            }
            
            VStack {
                Spacer()
                
                HStack{
                    Spacer()
                    
                    // 사진찍기 버튼
                    Button(action: {
                        viewModel.capturePhoto()
                        isCameraButtonPressed = true
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.01)
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
        }
    }
}

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    let cameraPreview: AnyView

    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    func switchFlash() {
        isFlashOn.toggle()
    }
    
    func switchSilent() {
        isSilentModeOn.toggle()
    }
    
    func capturePhoto() {
        print("[CameraViewModel]: Photo captured!")
    }
    
    func changeCamera() {
        print("[CameraViewModel]: Camera changed!")
    }
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
    }
}

class Camera: ObservableObject {
    var session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    
    func setUpCamera() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back) {
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    output.isHighResolutionCaptureEnabled = true
                    output.maxPhotoQualityPrioritization = .quality
                }
                session.startRunning()
            } catch {
                print(error)
            }
        }
    }
    
    func requestAndCheckPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            setUpCamera()
        default:
            print("Permission declined")
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
   
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct CameraOverlayView: View {
    var body: some View {
        ZStack {
            // 전체 화면을 어둡게 처리
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .mask(
                    GeometryReader { geometry in
                        ZStack {
                            // 전체 화면 마스크
                            Color.black
                            
                            // 중앙의 사각형 부분을 제외한 나머지 부분을 어둡게 만듭니다.
                            RoundedRectangle(cornerRadius: 21)
                                .frame(width: geometry.size.width * 0.5,
                                       height: geometry.size.width * 0.5)
                                .blendMode(.destinationOut)
                                .padding(.top, UIScreen.main.bounds.height * -0.03)
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                )

            
            GeometryReader { geometry in
                let rectWidth = geometry.size.width * 0.5
                let rectHeight = geometry.size.width * 0.5
                let rectX = (geometry.size.width - rectWidth) / 2
                let rectY = (geometry.size.height - rectHeight) / 2
                
                CornerShape(cornerRadius: 21)
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: rectWidth, height: rectHeight)
                    .offset(x: rectX, y: rectY - 12)
            }
            .padding(.top, UIScreen.main.bounds.height * -0.03)

            
            // 화면 상단에 설명 텍스트 추가
            VStack {
                
                Text("네모칸 안에 맥주 라벨이 위치하도록 해주세요.")
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .font(.system(size:12))
                
            }
            .padding(.top, UIScreen.main.bounds.height * 0.21)

        }
    }
}

struct CornerShape: Shape {
    var cornerRadius: CGFloat = 21  // 원하는 반지름을 설정하세요

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let lineLength: CGFloat = rect.width * 0.6
        let cornerRadius = min(cornerRadius, lineLength / 2)
        
        // 상단 왼쪽 모서리
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius + lineLength * 0.2, y: rect.minY))
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius + lineLength * 0.2))
        
        // 상단 오른쪽 모서리
        path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false)
        path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius - lineLength * 0.2, y: rect.minY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius + lineLength * 0.2))
        
        // 하단 왼쪽 모서리
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius + lineLength * 0.2, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius - lineLength * 0.2))
        
        // 하단 오른쪽 모서리
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius - lineLength * 0.2, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius - lineLength * 0.2))

        return path
    }
}
