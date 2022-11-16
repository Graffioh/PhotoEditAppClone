
import SwiftUI
import CropViewController
import PhotosUI

struct EditPhotoView: View {
    // Placeholder image
    //@State var image1: UIImage? = UIImage(named: "image1")!
    
    // PhotoPicker vars
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // CropImage vars
    //@State private var showImageCropper = false
    @State private var tempInputImage: UIImage?
    
    @State private var showImageEnhancer = false
    @ObservedObject var imageEnt = ImageModel(blurIntensity: 0, hueAdjust: 0, contrastAdjust: 1, opacityAdjust: 1, brightnessAdjust: 0, saturationAdjust: 1, showCropper: false, showEnhancer: false, imageUI: UIImage(named: "image1")!)

    // func to crop the img
      func imageCropped(image: UIImage){
        self.tempInputImage = nil
          //self.image1 = image
          imageEnt.imageUI = image
      }
    
    // func to update the image based on the one picked in the gallery
    func updateImg(){
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            //image1 = uiImage
            imageEnt.imageUI = uiImage
        }
    }
    
    var body: some View {
            
            NavigationView {
//                ZStack {
//                    Color(.)
//                        .edgesIgnoringSafeArea(.all)
                VStack{
                    
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
                    
//                    HStack{
//                        Image(systemName: "arrow.turn.up.left")
//                            .padding(.bottom, 30)
//                            .font(.system(size:26))
//
//                        Image(systemName: "arrow.turn.up.right")
//                            .padding(.bottom, 30)
//                            .font(.system(size:26))
//                            .padding(.leading,20)
//
//                        Spacer()
//
//                    }
//                    .padding(.leading)
                    
                    HStack{
                        Button {
                            imageEnt.showCropper.toggle()
                        } label: {
                            Image(systemName: "crop")
                                .padding(8)
                                .font(.system(size:26))
                        }
                        .fullScreenCover(isPresented: $imageEnt.showCropper) {
                            ImageCropper(image: $imageEnt.imageUI, visible: $imageEnt.showCropper,done: self.imageCropped).zIndex(10)
                        }
                        
                        Button {
                            imageEnt.showEnhancer.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .padding(8)
                                .font(.system(size:26))
                        }
                        .fullScreenCover(isPresented: $imageEnt.showEnhancer) {
                            ImageEnhancerView(imageEnt: imageEnt)
                        }
                        
                        Image(systemName: "eraser.line.dashed")
                            .padding(8)
                            .font(.system(size:26))
                        
                        Image(systemName: "paintbrush.pointed")
                            .padding(8)
                            .font(.system(size:26))
                        
                        Image(systemName: "wand.and.stars")
                            .padding(8)
                            .font(.system(size:26))
                        
                        Image(systemName: "skew")
                            .padding(8)
                            .font(.system(size:26))
                        
                        Image(systemName: "character")
                            .padding(8)
                            .font(.system(size:26))
                    }
                }
                .navigationTitle("PhotoEditClone")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            Image(systemName: "photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                                
                                updateImg()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { // Save the image in the gallery
                            //                        UIImageWriteToSavedPhotosAlbum(image1!, nil, nil, nil)
                            
                            let imageSaver = ImageSaver()
                            
                            imageSaver.writeToPhotoAlbum(image: imageEnt.imageUI!)
                            
                        } label: {
                            Text("Save")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { } label: {
                        Image(systemName: "arrow.turn.up.left")
                            .font(.system(size:20))
                            .foregroundColor(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { } label: {
                        Image(systemName: "arrow.turn.up.right")
                            .font(.system(size:20))
                            .foregroundColor(.white)
                        }
                    }
                }
            }
            
            // Crop tool logic (split-screen)
            //        if showImageCropper {
            //            ImageCropper(image: self.$image1, visible: self.$showImageCropper,done: self.imageCropped).zIndex(10)
            //        }
//        }
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
    }
}
