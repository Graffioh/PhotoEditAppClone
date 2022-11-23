
import SwiftUI
import CoreGraphics

struct ImageCropperView: View {
    
    let cropper = ImageCropper()
    
    @ObservedObject var imageEnt: ImageModel
    
    @State var imageSize: CGSize = .zero
    
    @State var originX: Double = 0
    @State var originY: Double = 0
    
    @State var isDragging: Bool = false
    @GestureState var locationState: CGPoint = CGPoint(x: 100, y: 100)
    @State var centerRecLocation: CGPoint = CGPoint(x: 210, y: 420)
    
    @State var recSize: CGSize = CGSize(width: 100, height: 100)
    
    private func rectReader() -> some View {
        return GeometryReader { (geometry) -> Color in
            let imageSize = geometry.size
            DispatchQueue.main.async {
                self.imageSize = imageSize
            }
            return .clear
        }
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
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Text("Crop")
                                .foregroundColor(.white)
                                .bold()
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            Button {
                                // Where the magic happens (broken magic actually)
                                originX = (centerRecLocation.x - (proxy.size.width - imageSize.width) / 2) - (recSize.width / 2)
                                originY = (centerRecLocation.y - (proxy.size.height - imageSize.height) / 2) - (recSize.height / 2)
                                
                                imageEnt.imageUI = cropper.cropImage(imageEnt.imageUI!, toRect: CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: recSize.width, height: recSize.height)), viewWidth: proxy.size.width, viewHeight: proxy.size.height)
                                
                                    imageEnt.showCropper.toggle()
                            } label: {
                                Text("Done")
                                    .foregroundColor(.yellow)
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
//                                        .onTapGesture { // DEBUG
//                                            print("x screen size: \(proxy.size.width) | y screen size: \(proxy.size.height) | x distance: \((proxy.size.width - imageSize.width) / 2)  | y distance: \((proxy.size.height - imageSize.height) / 2) | x image size: \(imageSize.width) | y image size: \(imageSize.height)")
//                                }
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
                                                
                                                if(cropper.checkIfOutOfBounds(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size, recSize: recSize)){
                                                    centerRecLocation = cropper.recPosInsideTheImage(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size, recSize: recSize)
                                                }
                                                
                                                // DEBUG
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

// For image bounds
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

