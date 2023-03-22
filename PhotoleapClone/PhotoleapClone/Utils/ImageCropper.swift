import Foundation
import SwiftUI
import CoreGraphics

class ImageCropper: ObservableObject {
    
//    func rectReader() -> some View {
//        return GeometryReader { (geometry) -> Color in
//            let imageSize = geometry.size
//            DispatchQueue.main.async {
//                //print(">> \(imageSize)") // use image actual size in your calculations
//                self.imageSize = imageSize
//            }
//            return .clear
//        }
//    }
    
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
    
    func checkIfOutOfBounds(recPos: CGPoint, imageSize: CGSize, screenSize: CGSize, recSize: CGSize ) -> Bool {
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
    
    func recPosInsideTheImage(recPos: CGPoint, imageSize: CGSize, screenSize: CGSize, recSize: CGSize) -> CGPoint {
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
    
    
}

