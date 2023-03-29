import Foundation
import SwiftUI

class ImageViewGetter {
    // This view is basically the image and it's used to save it through ImageRenderer
    func imageComposedView(imageEnt: ImageModel, paintImage: UIImage, textImage: UIImage) -> some View {
        
        ZStack{
            if let image = imageEnt.imageUI {
                Image(uiImage: image)
                    .opacity(imageEnt.opacityAdjust)
                    .brightness(imageEnt.brightnessAdjust)
                    .contrast(imageEnt.contrastAdjust)
                    .saturation(imageEnt.saturationAdjust)
                    .blur(radius: imageEnt.blurIntensity)
            }
            
            Image(uiImage: textImage)
                .resizable()
                .frame(width: imageEnt.imageUI!.size.width, height: imageEnt.imageUI!.size.height)
            
            //MARK: If the image is low quality, the painting becomes low quality too
            Image(uiImage: paintImage)
                .resizable()
                .frame(width: imageEnt.imageUI!.size.width, height: imageEnt.imageUI!.size.height)
        }
        
    }

    func imageWithPaintingView(imageEnt: ImageModel, lines: [Line], pickedColor: Color, imageSize: CGSize) -> some View {
        
        Canvas { context, size in
            for line in lines{
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(pickedColor), lineWidth: line.lineWidth)
            }
        }
        .frame(width: imageSize.width, height: imageSize.height)
        
    }

    func imageWithTextView(imageEnt: ImageModel, txt: String, txtPos: CGPoint, imageSize: CGSize) -> some View {
        
        Text("\(txt)")
            .font(.system(size: 32))
            //.position(x: txtPos.x, y: 100) // Problem with y pos
            .foregroundColor(.green)
            .bold()
            .frame(width: imageSize.width, height: imageSize.height - 30)
        
    }
    
    // To save enhanced image in ImageRenderer (problem with different resolutions)
    func imageWithEnhancementsView(imageEnt: ImageModel) -> some View {
        Image(uiImage: imageEnt.imageUI!)
            .opacity(imageEnt.opacityAdjust)
            .brightness(imageEnt.brightnessAdjust)
            .contrast(imageEnt.contrastAdjust)
            .saturation(imageEnt.saturationAdjust)
            .blur(radius: imageEnt.blurIntensity)
    }

}
