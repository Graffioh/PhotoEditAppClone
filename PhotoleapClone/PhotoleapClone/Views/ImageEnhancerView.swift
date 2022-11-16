//
//  ImageEnhancerView.swift
//  PhotoleapClone
//
//  Created by Umberto Breglia on 16/11/22.
//

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
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                    }
                    
                    .padding()
                    
                     Spacer()
                    
                    Image(uiImage: imageEnt.imageUI!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .opacity(imageEnt.opacityAdjust)
                        .hueRotation(Angle(degrees:imageEnt.hueAdjust))
                        .brightness(imageEnt.brightnessAdjust)
                        .contrast(imageEnt.contrastAdjust)
                        .saturation(imageEnt.saturationAdjust)
                        .blur(radius: imageEnt.blurIntensity)
                    
                    Spacer()
                    
                    HStack(spacing: 20){
                        Text("Brightness")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.brightnessAdjust, in: 0...1)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Blur")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.blurIntensity, in: 0...10)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Saturation")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.saturationAdjust, in: 0...1)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Contrast")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.contrastAdjust, in: 0...1)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Hue rotation")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.hueAdjust, in: 0...90)
                    }.padding(.horizontal, 30)
                    
                    HStack(spacing: 20){
                        Text("Opacity")
                            .foregroundColor(Color(.systemBlue))
                        
                        Slider(value: $imageEnt.opacityAdjust, in: 0...1)
                    }.padding(.horizontal, 30)
                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            imageEnt.showEnhancer.toggle()
//                        } label: {
//                            Text("X")
//                        }
//                    }
//                }
                
            }
        }
    }
}

//struct ImageEnhancerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageEnhancerView(img: img)
//    }
//}
