
import SwiftUI

struct InsertTextView: View {
    
    @ObservedObject var imageEnt: ImageModel
    
    @Binding var textImage: UIImage
    
    @State private var imageSize: CGSize = .zero
    @State private var txt: String = ""
    @State private var txtPos: CGPoint = CGPoint(x: 100, y: 200)
    @State private var showingAlert = false
    @State private var imageViewGetter: ImageViewGetter = ImageViewGetter()
    
    // Used to read the "bounds" of the image
   @MainActor private func rectReader3() -> some View {
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
        GeometryReader{ proxy in
            ZStack{
                Color(red:18 / 255, green:18 / 255, blue:18 / 255)
                
                VStack{
                    HStack{
                        Button {
                            imageEnt.showInsertText.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        TextField("Insert text", text: $txt)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(16)
                        
                        
                        Spacer()
                        
                        Button {
                            imageEnt.showInsertText.toggle()
                            
                            let renderer = ImageRenderer(content: imageViewGetter.imageWithTextView(imageEnt: imageEnt, txt: txt, txtPos: txtPos, imageSize: imageSize))
                            
                            textImage = renderer.uiImage!
                            
                            print("txtPos: \(txtPos)")
                            print("ImageSize: \(imageSize)")
                            //MARK: print("ImagePos: \()") This is needed to fix the wrong text position
                        } label: {
                            Text("Done")
                                .foregroundColor(txt != "" ? .yellow : .gray)
                        }.disabled(txt != "" ? false : true)
                        
                    }.padding()
                    
                    
                    ZStack{
                        if let image = imageEnt.imageUI {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .background(rectReader3())
                                .opacity(imageEnt.opacityAdjust)
                                .brightness(imageEnt.brightnessAdjust)
                                .contrast(imageEnt.contrastAdjust)
                                .saturation(imageEnt.saturationAdjust)
                                .blur(radius: imageEnt.blurIntensity)
                                .position(x: proxy.size.width / 2, y: (proxy.size.height / 2.4))
                        }
                        
                        Text("\(txt)")
                            .font(.system(size: 40))
                            .position(txtPos)
                            .foregroundColor(.green)
                            .bold()
                            .gesture(DragGesture()
                                .onChanged{ state in
                                    txtPos = state.location
                                }
                            )
                    }
                }
            }
        }
        
    }
    
}
