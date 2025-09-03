//
//  CameraView.swift
//  SwiftUI_JJaseCam
//
//  Created by 이영빈 on 2021/09/22.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    @State private var isImagePickerPresented = false
    @State private var PhotoCaptured = false
    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            viewModel.cameraPreview.ignoresSafeArea()
                .onAppear {
                    viewModel.configure()
                }
            // ✅ 추가: 줌 기능
                .gesture(MagnificationGesture()
                            .onChanged { val in
                    viewModel.zoom(factor: val)
                }
                            .onEnded { _ in
                    viewModel.zoomInitialize()
                }
                )
            
            VStack {
               
            }
                        
            VStack {
                HStack {
                    // 셔터사운드 온오프
                    Button(action: {viewModel.switchSilent()}) {
                        Image(systemName: viewModel.isSilentModeOn ?
                              "speaker.fill" : "speaker")
                            .foregroundColor(viewModel.isSilentModeOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                    
                    // 플래시 온오프
                    Button(action: {viewModel.switchFlash()}) {
                        Image(systemName: viewModel.isFlashOn ?
                              "bolt.fill" : "bolt")
                            .foregroundColor(viewModel.isFlashOn ? .yellow : .white)
                    }
                    .padding(.horizontal, 30)
                }
                .font(.system(size:25))
                .padding()
                
                Spacer()
                
                Text("Classification: \(viewModel.classificationLabel)")
                    .font(.headline)
                    .padding()
                
                HStack{
                    // 찍은 사진 미리보기
                    Button(action: {                        
                        isImagePickerPresented = true
                    }) {
                        if let previewImage = viewModel.recentImage {
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .aspectRatio(1, contentMode: .fit)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .foregroundColor(.white)
                                .frame(width: 75, height: 75)
                        }

                    }
                    .padding()
                    
                    Spacer()
                    
                    // 사진찍기 버튼
                    Button(action: {viewModel.capturePhoto()
                                    PhotoCaptured = true}) {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: 75, height: 75)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // 전후면 카메라 교체
                    Button(action: {viewModel.changeCamera()}) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                    }
                    .frame(width: 75, height: 75)
                    .padding()
                }
                
            }
            .foregroundColor(.white)
            
        }
        .opacity(viewModel.shutterEffect ? 0 : 1)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $image)
        }
        
        .onChange(of: image) { _ in
            if let newImage = image {
                viewModel.classifyImageDirectly(image: newImage)
            }
        }
//        .onChange(of: PhotoCaptured) { newValue in
//            // When photoCaptured becomes true, classify the image
//            if newValue {
//                if let recentImage = viewModel.recentImage {
//                    viewModel.classifyImageDirectly(image: recentImage)
//                }
//                PhotoCaptured = false  // Reset the flag
//            }
//        }
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
