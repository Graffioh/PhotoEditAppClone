
import SwiftUI
import CoreGraphics

struct ImageCropperView: View {
    @ObservedObject var imageEnt: ImageModel
    @StateObject var imgCropper = ImageCropper()
    
    @State private var imageSize: CGSize = .zero
    
    @State private var originX: Double = 0
    @State private var originY: Double = 0
    
    @State private var isDragging: Bool = false
    @GestureState private var locationState: CGPoint = CGPoint(x: 100, y: 100)
    @State private var centerRecLocation: CGPoint = CGPoint(x: 210, y: 420)
    
    @State private var recSize: CGSize = CGSize(width: 100, height: 100)
    
    
    // Used to read the "bounds" of the image
    @MainActor private func rectReader() -> some View {
        return GeometryReader { (geometry) -> Color in
            // OLD
            //DispatchQueue.main.async {
            //    self.imageSize = geometry.size
            //}
            
            Task {
                self.imageSize = geometry.size
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
                                Text("Cancel")
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Text("Crop")
                                .foregroundColor(.white)
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                // Where the magic happens (broken magic actually)
                                originX = (centerRecLocation.x - (proxy.size.width - imageSize.width) / 2) - (recSize.width / 2)
                                originY = (centerRecLocation.y - (proxy.size.height - imageSize.height) / 2) - (recSize.height / 2)
                                
                                imageEnt.imageUI = imgCropper.cropImage(imageEnt.imageUI!, toRect: CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: recSize.width, height: recSize.height)), viewWidth: proxy.size.width, viewHeight: proxy.size.height)
                                
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
                                // DEBUG
                                //                                        .onTapGesture {
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
                                                
                                                if(imgCropper.checkIfOutOfBounds(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size, recSize: recSize)){
                                                    centerRecLocation = imgCropper.recPosInsideTheImage(recPos: centerRecLocation, imageSize: imageSize, screenSize: proxy.size, recSize: recSize)
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
                                
                                // Circle to resize the rectangle (to fix/change, not responsive)
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

