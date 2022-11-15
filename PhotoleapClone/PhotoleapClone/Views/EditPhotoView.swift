
import SwiftUI
import CropViewController
import PhotosUI

struct EditPhotoView: View {
    // Placeholder image
    @State var image1: UIImage? = UIImage(named: "image1")!
    
    // PhotoPicker vars
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // CropImage vars
    @State private var showImageCropper = false
    @State private var tempInputImage: UIImage?

    // func to crop the img
      func imageCropped(image: UIImage){
        self.tempInputImage = nil
          self.image1 = image
      }
    
    // func to update the image based on the one picked in the gallery
    func updateImg(){
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            image1 = uiImage
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                
                Spacer()
                
                Image(uiImage: image1!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
                
                HStack{
                    Image(systemName: "arrow.turn.up.left")
                        .padding(.bottom, 30)
                        .font(.system(size:26))
                    
                    Image(systemName: "arrow.turn.up.right")
                        .padding(.bottom, 30)
                        .font(.system(size:26))
                        .padding(.leading,20)
                    
                    Spacer()
                    
                }
                .padding(.leading)
                
                HStack{
                    Button {
                        self.showImageCropper.toggle()
                    } label: {
                        Image(systemName: "crop")
                            .padding(8)
                            .font(.system(size:26))
                    }
                    .fullScreenCover(isPresented: $showImageCropper) {
                        ImageCropper(image: self.$image1, visible: self.$showImageCropper,done: self.imageCropped).zIndex(10)
                    }
                    
                    Image(systemName: "slider.horizontal.3")
                        .padding(8)
                        .font(.system(size:26))
                    
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
            .navigationTitle("Photoleap")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                        
                        imageSaver.writeToPhotoAlbum(image: image1!)
                        
                    } label: {
                        Text("Save")
                            .foregroundColor(.blue)
                    }

                }
                
                
            }
        }
        
        // Crop tool logic
//        if showImageCropper {
//            ImageCropper(image: self.$image1, visible: self.$showImageCropper,done: self.imageCropped).zIndex(10)
//        }
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
    }
}
