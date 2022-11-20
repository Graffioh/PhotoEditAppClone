
import SwiftUI

struct Line {
    var points: [CGPoint] = []
    var color: Color = .red
    var lineWidth: Double = 4.0
}

struct ImagePainterView: View {
    
    @ObservedObject var imageEnt: ImageModel
    
    @State var currentLine = Line()
    @State var lines: [Line] = []
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                Color(red:18 / 255, green:18 / 255, blue:18 / 255)
            VStack{
                    HStack{
                        Button {
                            imageEnt.showPainter.toggle()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                        
                        Button {
                            imageEnt.showPainter.toggle()
                        } label: {
                            Text("Done")
                        }
                    }
                    .padding()
                
                Spacer()
                
                ZStack{
                    
                    if let image = imageEnt.imageUI {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .opacity(imageEnt.opacityAdjust)
                            .brightness(imageEnt.brightnessAdjust)
                            .contrast(imageEnt.contrastAdjust)
                            .saturation(imageEnt.saturationAdjust)
                            .blur(radius: imageEnt.blurIntensity)
                            .gesture( DragGesture()
                                .onChanged(){ value in
                                    // Getting our gesture location (idk why but the offset is needed)
                                    let newPoint = CGPoint(x: value.location.x, y: value.location.y + (proxy.size.height / 3.4))
                                    // Creating the current line by appending the new points
                                    currentLine.points.append(newPoint)
                                    // Appending the line created in the lines array
                                    self.lines.append(currentLine)
                                }
                                .onEnded(){ value in
                                    // To make separate lines by clearing the points that the previous line was made of
                                    self.currentLine = Line(points: [])
                                }
                            )
                        }
                    
                    DrawShape(lines: lines)
                        .stroke(lineWidth: currentLine.lineWidth)
                        .foregroundColor(currentLine.color)
                    }
                }
            }
        }
    }
}

struct DrawShape: Shape {
    
    var lines: [Line]

    // Drawing is happening here
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for line in lines {
            path.addLines(line.points)
        }
        
        return path
    }
}

//extension UIView {
//    func asImage() -> UIImage {
//        if #available(iOS 10.0, *) {
//            let renderer = UIGraphicsImageRenderer(bounds: bounds)
//            return renderer.image { rendererContext in
//                layer.render(in: rendererContext.cgContext)
//            }
//        } else {
//            UIGraphicsBeginImageContext(self.frame.size)
//            self.layer.render(in:UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return UIImage(cgImage: image!.cgImage!)
//        }
//    }
//    func asImages() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
//}


//struct ImagePainterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePainterView()
//    }
//}
