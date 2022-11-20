
import SwiftUI

struct InsertTextView: View {
    
    @ObservedObject var imageEnt: ImageModel
    
    @State var txt: String = ""
    @State var txtPos: CGPoint = CGPoint(x: 100, y: 100)
    
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
                            } label: {
                                Text("Done")
                            }
                            .alert("I don't think \"saving\" is possible with this implementation :O", isPresented: $showingAlert) {
                                        Button("OK", role: .cancel) { imageEnt.showInsertText.toggle() }
                                    }
                    }
                    .padding()
                    
                    Spacer()
                    
                    TextField("Insert text", text: $txt)
                        .padding()
                    
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
                                //.position(x: proxy.size.width / 2, y: (proxy.size.height / 2) - 40)
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
                }
            }
        }
        
    }
}

//struct InsertTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsertTextView()
//    }
//}
