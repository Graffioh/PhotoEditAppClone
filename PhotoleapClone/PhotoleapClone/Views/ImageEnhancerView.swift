
import SwiftUI

struct ImageEnhancerView: View {
    @ObservedObject var imageEnt: ImageModel
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color(red:18 / 255, green:18 / 255, blue:18 / 255)
                    //.edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack{
                        Button {
                            imageEnt.showEnhancer.toggle()
                            
                            imageEnt.blurIntensity = 0
                            imageEnt.contrastAdjust = 1
                            imageEnt.opacityAdjust = 1
                            imageEnt.brightnessAdjust = 0
                            imageEnt.saturationAdjust = 1
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                        
                        Text("Enhance")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Button {
                            imageEnt.showEnhancer.toggle()
                            
                            let renderer = ImageRenderer(content: imageWithEnhancements(imageEnt: imageEnt))
                            imageEnt.imageUI = renderer.uiImage
                        } label: {
                            Text("Done")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    .padding()
                    
                     Spacer()
                    
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
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20){
                        Text("Brightness")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.brightnessAdjust, in: 0...1).accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Blur")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.blurIntensity, in: 0...10).accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Saturation")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.saturationAdjust, in: 0...1).accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Contrast")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.contrastAdjust, in: 0...1).accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Opacity")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.opacityAdjust, in: 0...1).accentColor(.white)
                    }.padding(.horizontal, 30)
                }
                .padding(.bottom,30)
            }
        }
    }
}

// To save enhanced image in ImageRenderer
private func imageWithEnhancements(imageEnt: ImageModel) -> some View {
    Image(uiImage: imageEnt.imageUI!)
        .resizable()
        .scaledToFit()
        .padding()
        .opacity(imageEnt.opacityAdjust)
        .brightness(imageEnt.brightnessAdjust)
        .contrast(imageEnt.contrastAdjust)
        .saturation(imageEnt.saturationAdjust)
        .blur(radius: imageEnt.blurIntensity)
}

//struct ImageEnhancerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageEnhancerView(img: img)
//    }
//}
