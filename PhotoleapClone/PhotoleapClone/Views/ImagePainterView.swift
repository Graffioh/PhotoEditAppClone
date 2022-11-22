
import SwiftUI

struct Line {
    var points: [CGPoint] = []
    var lineWidth: Double = 4.0
}

struct ImagePainterView: View {
    
    @ObservedObject var imageEnt: ImageModel
    @State var imageSize: CGSize = .zero
    
    @State var currentLine = Line()
    @State var lines: [Line] = []
    
    @State var pickedColor: Color = .red
    
    @State private var showingAlert = false
    
    @Binding var paintImage: UIImage
    
    private func rectReader2() -> some View {
        return GeometryReader { (geometry) -> Color in
            let imageSize = geometry.size
            DispatchQueue.main.async {
                self.imageSize = imageSize
            }
            return .clear
        }
    }
    
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
                        
                        Menu {
                            Button {
                                pickedColor = .red
                            } label: {
                                Text("Red")
                            }
                            
                            Button {
                                pickedColor = .green
                            } label: {
                                Text("Green")
                            }

                            Button {
                                pickedColor = .blue
                            } label: {
                                Text("Blue")
                            }
                            
                            Button {
                                pickedColor = .black
                            } label: {
                                Text("Black")
                            }
                            
                            Button {
                                pickedColor = .white
                            } label: {
                                Text("White")
                            }
                        } label: {
                            Image(systemName:"paintpalette")
                                .font(.system(size: 24))
                        }
                        .padding(.trailing, 10)
                        
                        Button {
                            imageEnt.showPainter.toggle()
                            
                            let renderer = ImageRenderer(content: imageWithPaintingView(imageEnt: imageEnt, lines: lines, pickedColor: pickedColor, imageSize: imageSize))

                            paintImage = renderer.uiImage!
                            
                            // Clear previous painting
                            lines.removeAll()
                        } label: {
                            Text("Done")
                                .foregroundColor(.yellow)
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
                            .background(rectReader2())
                            .opacity(imageEnt.opacityAdjust)
                            .brightness(imageEnt.brightnessAdjust)
                            .contrast(imageEnt.contrastAdjust)
                            .saturation(imageEnt.saturationAdjust)
                            .blur(radius: imageEnt.blurIntensity)
                            .position(x: proxy.size.width / 2, y: proxy.size.height / 2.2)
                    
                    Canvas { context, size in
                        for line in lines{
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path, with: .color(pickedColor), lineWidth: line.lineWidth)
                        }
                    }
                    .frame(width: imageSize.width, height: imageSize.height - 30)
                    .gesture( DragGesture()
                        .onChanged(){ value in
                            // Getting our gesture location (idk why but the offset is needed)
                            let newPoint = CGPoint(x: value.location.x, y: value.location.y)
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
                    
//                    DrawShape(lines: lines)
//                        .stroke(lineWidth: currentLine.lineWidth)
//                        .foregroundColor(currentLine.color)
                    }
                }
            }
        }
    }

}

// old drawing thing
//struct DrawShape: Shape {
//
//    var lines: [Line]
//
//    // Drawing is happening here
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        for line in lines {
//            path.addLines(line.points)
//        }
//
//        return path
//    }
//}

private func imageWithPaintingView(imageEnt: ImageModel, lines: [Line], pickedColor: Color, imageSize: CGSize) -> some View {
    
    ZStack{
//        if let image = imageEnt.imageUI {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .padding()
//                //.frame(width: imageSize.width, height: imageSize.height + 20) // with this the image is like Minecraft but the paint is right, without this the image size is too big
//                //.position(x: proxy.size.width / 2, y: proxy.size.height / 2.2)
//                .opacity(imageEnt.opacityAdjust)
//                .brightness(imageEnt.brightnessAdjust)
//                .contrast(imageEnt.contrastAdjust)
//                .saturation(imageEnt.saturationAdjust)
//                .blur(radius: imageEnt.blurIntensity)
            
            Canvas { context, size in
                for line in lines{
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(pickedColor), lineWidth: line.lineWidth)
                }
            }
            .frame(width: imageSize.width, height: imageSize.height - 30)
            
        }
    //}
}


extension UIImageView {
    var contentRect2: CGRect {
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

//struct ImagePainterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePainterView()
//    }
//}
