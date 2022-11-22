
import SwiftUI

struct InsertTextView: View {
    
    @ObservedObject var imageEnt: ImageModel
    
    @State var txt: String = ""
    @State var txtPos: CGPoint = CGPoint(x: 100, y: 200)
    
    @State private var showingAlert = false
    
        var body: some View {
            GeometryReader{proxy in
                ZStack{
                Color(red:18 / 255, green:18 / 255, blue:18 / 255)
    
                    VStack{
                        HStack{
                            Button {
                                imageEnt.showInsertText.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                            }
    
                            Spacer()
    
                            Button {
                                showingAlert.toggle()
//                                imageEnt.showInsertText.toggle()
    
//                                let renderer = ImageRenderer(content: imageTextView(imageEnt: imageEnt, txt: txt, txtPos: txtPos))
//
//                                imageEnt.imageUI = renderer.uiImage
                                } label: {
                                    Text("Done")
                                        .foregroundColor(.yellow)
                                }
                                .alert("I don't think \"saving\" is possible with this implementation :(", isPresented: $showingAlert) {
                                            Button("OK", role: .cancel) { imageEnt.showInsertText.toggle() }
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
                                    .position(x: proxy.size.width / 2, y: (proxy.size.height / 2.4))
                            }
    
                            Text("\(txt)")
                                .font(.system(size: 32))
                                .position(txtPos)
                                .gesture(DragGesture()
                                    .onChanged{ state in
                                        txtPos = state.location
                                    }
                                )
                            
                            
                        }
                        //Spacer()
                        
                        TextField("Insert text", text: $txt)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
    
        }
        
    }



private func imageWithTextView(imageEnt: ImageModel, txt: String, txtPos: CGPoint) -> some View {
    
        ZStack{
            Image(uiImage: imageEnt.imageUI!)
                .resizable()
                .scaledToFit()
                .padding()
                .opacity(imageEnt.opacityAdjust)
                .brightness(imageEnt.brightnessAdjust)
                .contrast(imageEnt.contrastAdjust)
                .saturation(imageEnt.saturationAdjust)
                .blur(radius: imageEnt.blurIntensity)
            
            Text("\(txt)")
                .font(.system(size: 32))
                .position(txtPos)
        }
    
}

//struct InsertTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsertTextView()
//    }
//}
