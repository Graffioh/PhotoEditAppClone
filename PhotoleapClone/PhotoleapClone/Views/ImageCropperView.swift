//
//  ImageCropperView.swift
//  PhotoleapClone
//
//  Created by Umberto Breglia on 16/11/22.
//

import SwiftUI
import CoreGraphics

struct ImageCropperView: View {
    
    @ObservedObject var imageEnt: ImageModel
    
    @State var imageSize: CGSize = .zero // << or initial from NSImage
    
    @State var isDragging: Bool = false
    @GestureState var locationState: CGPoint = CGPoint(x: 100, y: 100)
    
    @State var centerRecLocation: CGPoint = CGPoint(x: 200, y: 400)
    
    @State var topRecLocation: CGPoint = CGPoint(x:200, y:400)
    
    let recWidth: Double = 50
    let recHeight: Double = 50
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    private func rectReader() -> some View {
        return GeometryReader { (geometry) -> Color in
            let imageSize = geometry.size
            DispatchQueue.main.async {
                //print(">> \(imageSize)") // use image actual size in your calculations
                self.imageSize = imageSize
            }
            return .clear
        }
    }
    
    private func checkIfOut(recPos: CGPoint, imageSize: CGSize, screenSize: CGSize ) -> Bool {
        let yTopBoundary = ((screenSize.height + 81) - imageSize.height) / 2
        let yBotBoundary = ((screenSize.height + 81) - imageSize.height) / 2 + imageSize.height - 32
        let xLeftBoundary = ((screenSize.width - imageSize.width) / 2) + 14
        let xRightBoundary = xLeftBoundary + imageSize.width - 28
        
        if((recPos.y + 81 - (recHeight / 2)) < yTopBoundary || (recPos.y + 81 + (recHeight / 2)) > yBotBoundary || (recPos.x - (recWidth / 2)) < xLeftBoundary || (recPos.x + (recWidth / 2)) > xRightBoundary){
            return true
        }
           return false
    }
    
    var body: some View {
        GeometryReader { proxy in
            let yScreenSize = proxy.size.height + 81 // I don't know why + 81 but it give the right result *skull-emoji*
            let xScreenSize = proxy.size.width
            
            NavigationStack{
                ZStack{
                    Color(red:18 / 255, green:18 / 255, blue:18 / 255)
                    //.edgesIgnoringSafeArea(.all)
                    VStack{
                        
                        HStack{
                            Button {
                                imageEnt.showCropper.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                        
                        .padding()
                        
                        Spacer()
                        ZStack{
                            if let image = imageEnt.imageUI{
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .opacity(imageEnt.opacityAdjust)
                                        .brightness(imageEnt.brightnessAdjust)
                                        .contrast(imageEnt.contrastAdjust)
                                        .saturation(imageEnt.saturationAdjust)
                                        .blur(radius: imageEnt.blurIntensity)
                                        .background(rectReader())
                                        .onTapGesture {
                                            print("x screen size: \(xScreenSize) | y screen size: \(yScreenSize) | x distance: \((xScreenSize - imageSize.width) / 2)  | y distance: \((yScreenSize - imageSize.height) / 2) | x image size: \(imageSize.width) | y image size: \(imageSize.height)")
                                }
                            }
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                    .position(centerRecLocation)
                                    .gesture(
                                        DragGesture()
                                            .onChanged{ state in
                                                centerRecLocation = state.location
                                                
                                                if(checkIfOut(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size)){
                                                    centerRecLocation = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                                                }
                                                
//                                                if(checkIfOut(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size)){
//
//                                                }
                                                
//                                                print("x CENTER rec: \(centerRecLocation.x) & y  CENTER rec: \(centerRecLocation.y + 81)")

//                                                print("BOT image: \(((proxy.size.height + 81) - imageSize.height) / 2 + imageSize.height)")
//
//                                                print("TOP image: \(((proxy.size.height + 81) - imageSize.height) / 2)")
//
//                                                print("y CENTER rec: \(centerRecLocation.y + 81)")
                                            }
                                            .updating( $locationState
                                            ){ currentState, pastLocation, transaction in
                                                pastLocation = currentState.location
                                                
                                                
                                            }
                                    )
                                
                                Circle()
                                    .frame(width:4, height: 4)
                                    .foregroundColor(.red)
                                    .position(centerRecLocation)
                            }
                            
                        }
                        
                       
                        Button {
                            imageEnt.imageUI = cropImage(imageEnt.imageUI!, toRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 10, height: 10)), viewWidth: 15, viewHeight: 15)
                        } label: {
                            Text("Crop")
                                .font(.system(size: 30))
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

extension UIImageView {
    var contentRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}


//struct ImageCropperView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCropperView()
//    }
//}

