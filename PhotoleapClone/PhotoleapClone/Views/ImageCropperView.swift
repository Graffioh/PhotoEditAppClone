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
    
    @State var imageSize: CGSize = .zero
    
    @State var originX: Double = 0
    @State var originY: Double = 0
    
    @State var isDragging: Bool = false
    @GestureState var locationState: CGPoint = CGPoint(x: 100, y: 100)
    @State var centerRecLocation: CGPoint = CGPoint(x: 210, y: 420)
    
    @State var recSize: CGSize = CGSize(width: 100, height: 100)
    
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
        let yTopBoundary = (screenSize.height - imageSize.height + 30) / 2 // + 30 because imageSize y is not 100 correct
        let yBotBoundary = ((screenSize.height) - imageSize.height) / 2 + imageSize.height - 15
        let xLeftBoundary = ((screenSize.width - imageSize.width) / 2) + 16
        let xRightBoundary = xLeftBoundary + imageSize.width - 32
        
//        if(recPos.y - recSize.height < yTopBoundary || (recPos.y + (recSize.height / 2)) > yBotBoundary || (recPos.x - (recSize.width / 2)) < xLeftBoundary || (recPos.x + (recSize.width / 2)) > xRightBoundary){
        if recPos.y - (recSize.height / 2) < yTopBoundary || recPos.y + (recSize.height / 2) > yBotBoundary || recPos.x - (recSize.width / 2) < xLeftBoundary || recPos.x + (recSize.width / 2) > xRightBoundary {
            return true
        }
           return false
    }
    
    private func outOfBounds(recPos: CGPoint, imageSize: CGSize, screenSize: CGSize) -> CGPoint {
        let yTopBoundary = (screenSize.height - imageSize.height + 30) / 2
        let yBotBoundary = ((screenSize.height) - imageSize.height) / 2 + imageSize.height - 16
        let xLeftBoundary = ((screenSize.width - imageSize.width) / 2) + 16
        let xRightBoundary = xLeftBoundary + imageSize.width - 32
        
        // From the image center I will use a sort of offset to see where the rectangle needs to stop
        let imageCenterY = (screenSize.height / 2)
        let imageCenterX = (screenSize.width / 2)
        
//        if((recPos.y + 81 - (recHeight / 2)) < yTopBoundary || (recPos.y + 81 + (recHeight / 2)) > yBotBoundary || (recPos.x - (recWidth / 2)) < xLeftBoundary || (recPos.x + (recWidth / 2)) > xRightBoundary){
//
//        }
        
        // Top Right
        if recPos.x + (recSize.width / 2) > xRightBoundary &&  recPos.y - (recSize.height / 2) < yTopBoundary{
            return CGPoint(x:(imageSize.width / 2 - (recSize.width / 2)) + imageCenterX - 16, y: imageCenterY - ((imageSize.height - 30) / 2) + (recSize.height / 2))
        }
        
        // Bot Right
        if recPos.y + (recSize.height / 2) > yBotBoundary &&  recPos.x + (recSize.width / 2) > xRightBoundary{
            return CGPoint(x:(imageSize.width / 2 - (recSize.width / 2)) + imageCenterX - 16, y: imageCenterY + ((imageSize.height - 30) / 2) - (recSize.height / 2))
        }
        
        // Top Left
        if recPos.y - (recSize.height / 2) < yTopBoundary &&  recPos.x - (recSize.width / 2) < xLeftBoundary && imageSize.width == screenSize.width{
            return CGPoint(x:(imageSize.width / 2 + (recSize.width / 2)) - imageCenterX + 16, y: imageCenterY - ((imageSize.height - 30) / 2) + (recSize.height / 2))
        }
        else if recPos.y - (recSize.height / 2) < yTopBoundary &&  recPos.x - (recSize.width / 2) < xLeftBoundary{
            return CGPoint(x:(imageCenterX - imageSize.width / 2 + 16) + recSize.width / 2, y: imageCenterY - ((imageSize.height - 30) / 2) + (recSize.height / 2))
        }
        
        // Bot Left
        if recPos.y + (recSize.height / 2) > yBotBoundary &&  recPos.x - (recSize.width / 2) < xLeftBoundary && imageSize.width == screenSize.width{
            return CGPoint(x:imageSize.width / 2 + (recSize.width / 2) - imageCenterX + 16, y: imageCenterY + ((imageSize.height - 30) / 2) - (recSize.height / 2))
        }
        else if recPos.y + (recSize.height / 2) > yBotBoundary &&  recPos.x - (recSize.width / 2) < xLeftBoundary{
            return CGPoint(x:(imageCenterX - imageSize.width / 2 + 16) + recSize.width / 2, y: imageCenterY + ((imageSize.height - 30) / 2) - (recSize.height / 2))
        }
        
        // Top
        if recPos.y - (recSize.height / 2) < yTopBoundary {
            return CGPoint(x: recPos.x, y: imageCenterY - ((imageSize.height - 30) / 2) + (recSize.height / 2))
        }
        
        // Bot
        if recPos.y + (recSize.height / 2) > yBotBoundary {
            return CGPoint(x: recPos.x, y: imageCenterY + ((imageSize.height - 30) / 2) - (recSize.height / 2))
        }
        
        // Left
        if recPos.x - (recSize.width / 2) < xLeftBoundary && imageSize.width == screenSize.width {
            return CGPoint(x:(imageSize.width / 2 + (recSize.width / 2)) - imageCenterX + 16, y: recPos.y)
        }
        else if recPos.x - (recSize.width / 2) < xLeftBoundary{ // for the "taller" image
            return CGPoint(x:(imageCenterX - imageSize.width / 2 + 16) + recSize.width / 2, y: recPos.y)
        }
        
        // Right
        if recPos.x + (recSize.width / 2) > xRightBoundary {
            return CGPoint(x:(imageSize.width / 2 - (recSize.width / 2)) + imageCenterX - 16, y: recPos.y)
        }
        
        return CGPoint(x: recPos.x, y: recPos.y)
    }
    
    var body: some View {
        GeometryReader { proxy in            
            NavigationStack{
                ZStack{
                    Color(red:18 / 255, green:18 / 255, blue:18 / 255)
                    
                    VStack{
                        
                        HStack{
                            Button {
                                imageEnt.showCropper.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Button {
                                originX = (centerRecLocation.x - (proxy.size.width - imageSize.width) / 2) - (recSize.width / 2)
                                originY = (centerRecLocation.y - (proxy.size.height - imageSize.height) / 2) - (recSize.height / 2)
                                
                                imageEnt.imageUI = cropImage(imageEnt.imageUI!, toRect: CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: recSize.width, height: recSize.height)), viewWidth: proxy.size.width, viewHeight: proxy.size.height)
                                
                                    imageEnt.showCropper.toggle()
                            } label: {
                                Text("Done")
                            }
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
                                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                                        .onTapGesture {
                                            print("x screen size: \(proxy.size.width) | y screen size: \(proxy.size.height) | x distance: \((proxy.size.width - imageSize.width) / 2)  | y distance: \((proxy.size.height - imageSize.height) / 2) | x image size: \(imageSize.width) | y image size: \(imageSize.height)")
                                }
                            }
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: recSize.width, height: recSize.height)
                                    .foregroundColor(.green)
                                    .opacity(0.01)
                                    .border(.white,width: 4)
                                    .position(centerRecLocation)
                                    .gesture(
                                        DragGesture()
                                            .onChanged{ state in
                                                centerRecLocation = state.location
                                                
                                            if(checkIfOut(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size)){
                                                centerRecLocation = outOfBounds(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size)
                                            }
                                                
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
                                
                        let circlePosition: CGPoint = CGPoint(x: centerRecLocation.x + (recSize.width / 2), y: centerRecLocation.y + (recSize.height / 2))


                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                    .opacity(0.5)
                                    .position(circlePosition)
                                .gesture(
                                    DragGesture()
                                        .onChanged{ value in
                                            recSize.height = min(max(100, (value.translation.height + recSize.height)), imageSize.height - 30)
                                            recSize.width = min(max(100, (value.translation.width + recSize.width)), imageSize.width - 30)
                                            }
                                    )
                            }
                            
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

