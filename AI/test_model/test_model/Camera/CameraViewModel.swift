//
//  CameraViewModel.swift
//  SwiftUI_JJaseCam
//
//  Created by 이영빈 on 2021/09/24.
//

import SwiftUI
import AVFoundation
import Combine
import CoreML

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    private let classificationModel = try? beer_classifier(configuration: MLModelConfiguration())

    
    let cameraPreview: AnyView
    let hapticImpact = UIImpactFeedbackGenerator()
    
    // ✅ 추가: 줌 기능
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0

    @Published var shutterEffect = false
    @Published var recentImage: UIImage?
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    @Published var classificationLabel: String = "No Classification"

    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    // 플래시 온오프
    func switchFlash() {
        isFlashOn.toggle()
        model.flashMode = isFlashOn == true ? .on : .off
    }
    
    // 무음모드 온오프
    func switchSilent() {
        isSilentModeOn.toggle()
        model.isSilentModeOn = isSilentModeOn
    }
    
    // 사진 촬영
    func capturePhoto() {
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            model.capturePhoto()
            print("[CameraViewModel]: Photo captured!")
            
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    
    func zoom(factor: CGFloat) {
        let delta = factor / lastScale
        lastScale = factor
        
        let newScale = min(max(currentZoomFactor * delta, 1), 5)
        model.zoom(newScale)
        currentZoomFactor = newScale
    }
    
    func zoomInitialize() {
        lastScale = 1.0
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        // ✅ 추가
        model.changeCamera()
        print("[CameraViewModel]: Camera changed!")
    }
    
    // Classification using CoreML model directly
    func classifyImageDirectly(image: UIImage) {
        guard let model = try? beer_classifier(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load model")
        }

        guard let pixelBuffer = preprocessImage(image) else {
            fatalError("Failed to preprocess image.")
        }

        do {
            let prediction = try model.prediction(x_1: pixelBuffer)
            let outputArray = prediction.linear_0

            // Convert MLMultiArray to [Double]
            let scores = try outputArray.toArray()

            // Replace with your actual class labels
            let classLabels = ["Asahi", "Heineken"]

            // Apply Softmax to get probabilities (if necessary)
            let expScores = scores.map { exp($0) }
            let sumExpScores = expScores.reduce(0, +)
            let probabilities = expScores.map { $0 / sumExpScores }

            // Find the index of the highest probability
            if let maxIndex = probabilities.indices.max(by: { probabilities[$0] < probabilities[$1] }) {
                let predictedLabel = classLabels[maxIndex]
                let confidence = probabilities[maxIndex]

                DispatchQueue.main.async {
                    self.classificationLabel = "\(predictedLabel) (\(confidence * 100)%)"
                    print("Prediction: \(predictedLabel), Confidence: \(confidence * 100)%")
                }
            } else {
                print("Failed to determine prediction results")
            }
        } catch {
            print("Prediction error: \(error.localizedDescription)")
        }
    }
    
    // Preprocess the image to match the model's input requirements
    func preprocessImage(_ image: UIImage) -> CVPixelBuffer? {
        let imageSize = CGSize(width: 224, height: 224) // Adjust to your model's expected input size

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()

        guard let pixelBuffer = resizedImage.pixelBuffer() else {
            return nil
        }

        return pixelBuffer
    }

    // Function to print model input and output descriptions
    func printModelInfo() {
        if let modelURL = Bundle.main.url(forResource: "beer_classifier", withExtension: "mlmodelc"),
           let mlmodel = try? MLModel(contentsOf: modelURL) {
            print("Model input descriptions: \(mlmodel.modelDescription.inputDescriptionsByName)")
            print("Model output descriptions: \(mlmodel.modelDescription.outputDescriptionsByName)")
        }
    }

    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
        model.$recentImage.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.recentImage = pic            
        }
        .store(in: &self.subscriptions)
        
        model.$isCameraBusy.sink { [weak self] (result) in
            self?.isCameraBusy = result
        }
        .store(in: &self.subscriptions)
        
        model.onPhotoCaptured = { [weak self] capturedImage in
            guard let self = self, let image = capturedImage else { return }
            self.classifyImageDirectly(image: image)
        }
    }
}


// Extension to map UIImage.Orientation to CGImagePropertyOrientation
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up:            self = .up
        case .down:          self = .down
        case .left:          self = .left
        case .right:         self = .right
        case .upMirrored:    self = .upMirrored
        case .downMirrored:  self = .downMirrored
        case .leftMirrored:  self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}

// Extension to convert UIImage to CVPixelBuffer
extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let attributes: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: NSNumber(value: true),
            kCVPixelBufferCGBitmapContextCompatibilityKey: NSNumber(value: true)
        ]

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.noneSkipFirst.rawValue

        guard let context = CGContext(data: pixelData, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: colorSpace, bitmapInfo: bitmapInfo) else {
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }

        guard let cgImage = self.cgImage else {
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }
}

// Extension to convert MLMultiArray to [Double]
extension MLMultiArray {
    func toArray() throws -> [Double] {
        let count = self.count
        var array = [Double](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = self[i].doubleValue
        }
        return array
    }
}
