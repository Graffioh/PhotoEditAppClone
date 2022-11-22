
import SwiftUI
import PhotosUI

struct EditPhotoView: View {
    
    // PhotoPicker vars
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // CropImage vars
    @State private var tempInputImage: UIImage?
    
    @State private var showImageEnhancer = false
    @ObservedObject var imageEnt = ImageModel(blurIntensity: 0, contrastAdjust: 1, opacityAdjust: 1, brightnessAdjust: 0, saturationAdjust: 1, showCropper: false, showEnhancer: false, showPainter: false, showInsertText: false, imageUI: UIImage(named: "image1")!)
    
    @State private var showingAlert = false
    
    @State private var paintImage: UIImage = UIImage()
    
    @State private var composedImage: UIImage = UIImage()

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
                }
                
                Image(uiImage: paintImage)
                    .resizable()
                    .scaledToFit()
            }
            
            
            Spacer()
            
            HStack{
                // Image cropper tool
                Button {
                    imageEnt.showCropper.toggle()
                } label: {
                    Image(systemName: "crop")
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
                        .padding(8)
                        .font(.system(size:26))
                }
                .fullScreenCover(isPresented: $imageEnt.showPainter) {
                    ImagePainterView(imageEnt: imageEnt, paintImage: $paintImage)
                }
                
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.gray)
                    .padding(8)
                    .font(.system(size:26))
                
                Button {
                    imageEnt.showInsertText.toggle()
                } label: {
                    Image(systemName: "character")
                        .foregroundColor(.white)
                        .padding(8)
                        .font(.system(size:26))
                }
                .fullScreenCover(isPresented: $imageEnt.showInsertText) {
                    InsertTextView(imageEnt: imageEnt)
                }
                
            }.padding(.bottom, 10)
        }
        .navigationTitle("PhotoEditClone")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo")
                        .foregroundColor(.white)
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
                Button {
                    
                    showingAlert.toggle()
                    
                    let renderer = ImageRenderer(content: imageComposedView(imageEnt: imageEnt, paintImage: paintImage))

                    composedImage = renderer.uiImage!
                    
                    let imageSaver = ImageSaver()
                    
                    imageSaver.writeToPhotoAlbum(image: composedImage) // This mf save the image with a white border I don't know why
                    
                    // Clear painting
                    paintImage = UIImage() // Keep or remove?
                    
                } label: {
                    Text("Save")
                        .foregroundColor(.yellow)
                }
                .alert("Image saved.", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { showingAlert.toggle() }
                        }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button { } label: {
                Image(systemName: "arrow.turn.up.left")
                    .font(.system(size:20))
                    .foregroundColor(.gray)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button { } label: {
                Image(systemName: "arrow.turn.up.right")
                    .font(.system(size:20))
                    .foregroundColor(.gray)
                }
                }
            }
        }
    }
}


private func imageComposedView(imageEnt: ImageModel, paintImage: UIImage) -> some View {
    
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
        }
        
        Image(uiImage: paintImage)
            .resizable()
            .scaledToFit()
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
