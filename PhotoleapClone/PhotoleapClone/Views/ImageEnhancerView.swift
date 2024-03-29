
import SwiftUI

struct ImageEnhancerView: View {
    @ObservedObject var imageEnt: ImageModel
    
    @State private var isImageModified: Bool = false
    
    @State private var imageViewGetter: ImageViewGetter = ImageViewGetter()
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color(red:18 / 255, green:18 / 255, blue:18 / 255)
                //.edgesIgnoringSafeArea(.all)
                VStack{
                    
                    HStack{
                        // Reset enhancement when cancel is tapped
                        Button {
                            imageEnt.showEnhancer.toggle()
                            
                            imageEnt.blurIntensity = 0
                            imageEnt.contrastAdjust = 1
                            imageEnt.opacityAdjust = 1
                            imageEnt.brightnessAdjust = 0
                            imageEnt.saturationAdjust = 1
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Enhance")
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            imageEnt.showEnhancer.toggle()
                            
                            let renderer = ImageRenderer(content: imageViewGetter.imageWithEnhancementsView(imageEnt: imageEnt))
                            imageEnt.imageUI = renderer.uiImage
                        } label: {
                            Text("Done")
                                .foregroundColor(isImageModified ? .yellow : .gray)
                        }.disabled(isImageModified ? false : true)
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
                    
                    // Enhance modifiers
                    HStack(spacing: 20){
                        Text("Brightness")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.brightnessAdjust, in: 0...1){_ in
                            isImageModified = true
                        }.accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Blur")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.blurIntensity, in: 0...10){_ in
                            isImageModified = true
                        }.accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Saturation")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.saturationAdjust, in: 0...1){_ in
                            isImageModified = true
                        }.accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Contrast")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.contrastAdjust, in: 0...1){_ in
                            isImageModified = true
                        }.accentColor(.white)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Opacity")
                            .foregroundColor(.white)
                        
                        Slider(value: $imageEnt.opacityAdjust, in: 0...1){_ in
                            isImageModified = true
                        }.accentColor(.white)
                    }.padding(.horizontal, 30)
                }
                .padding(.bottom,30)
            }
        }
    }
}


