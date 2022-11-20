
import SwiftUI
import CropViewController
import PhotosUI

struct EditPhotoView: View {
    
    // PhotoPicker vars
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // CropImage vars
    @State private var tempInputImage: UIImage?
    
    @State private var showImageEnhancer = false
    @ObservedObject var imageEnt = ImageModel(blurIntensity: 0, contrastAdjust: 1, opacityAdjust: 1, brightnessAdjust: 0, saturationAdjust: 1, showCropper: false, showEnhancer: false, showPainter: false, imageUI: UIImage(named: "image1")!)

    // func to crop the img
//      func imageCropped(image: UIImage){
//        self.tempInputImage = nil
//          imageEnt.imageUI = image
//      }
    
    // func to update the image based on the one picked in the gallery
    func updateImg(){
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            imageEnt.imageUI = uiImage.fixOrientation()
            
            imageEnt.blurIntensity = 0
            imageEnt.contrastAdjust = 1
            imageEnt.opacityAdjust = 1
            imageEnt.brightnessAdjust = 0
            imageEnt.saturationAdjust = 1
        }
    }
    
    var body: some View {
            
            NavigationView {
                VStack{
                    
                    Spacer()
                    
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
                    }
                    
                    Spacer()
                    
                    HStack{
                        // Image cropper tool
                        Button {
                            imageEnt.showCropper.toggle()
                        } label: {
                            Image(systemName: "crop")
                                .padding(8)
                                .font(.system(size:26))
                        }
                        .fullScreenCover(isPresented: $imageEnt.showCropper) {
                                ImageCropperView(imageEnt: imageEnt)
                        }
                        
                        // Image enhancer tool
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
                        
                        Button {
                            imageEnt.showPainter.toggle()
                        } label: {
                            Image(systemName: "paintbrush.pointed")
                                .padding(8)
                                .font(.system(size:26))
                        }
                        .fullScreenCover(isPresented: $imageEnt.showPainter) {
                            ImagePainterView(imageEnt: imageEnt)
                        }
                        
                        Image(systemName: "wand.and.stars")
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
    }
}

// fix for camera-taken photos
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
    return self
    }
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRectMake(0, 0, self.size.width, self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return normalizedImage;
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
    }
}
