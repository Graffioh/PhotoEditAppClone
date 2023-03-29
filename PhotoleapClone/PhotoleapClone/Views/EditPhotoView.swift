
import SwiftUI
import PhotosUI

struct EditPhotoView: View {
    // Image entity
    @ObservedObject var imageEnt = ImageModel(blurIntensity: 0, contrastAdjust: 1, opacityAdjust: 1, brightnessAdjust: 0, saturationAdjust: 1, showCropper: false, showEnhancer: false, showPainter: false, showInsertText: false, imageUI: UIImage(named: "startingImage")!)
    
    // PhotoPicker vars
    @State private var selectedPhotoFromGallery: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // Show the painting on top of the current image
    @State private var paintedImage: UIImage = UIImage()
    
    // Show the text on top of the current image
    @State private var textImage: UIImage = UIImage()
    
    // Final image that is going to be saved
    @State private var composedImage: UIImage = UIImage()
    
    // Used to save the image
    @State private var imgSaver: ImageSaver = ImageSaver()
    @State private var imgViewGetter: ImageViewGetter = ImageViewGetter()
    
    // Various toggles
    @State private var showingAlert = false
    @State private var showBrowseImages = false
    @State private var showOptionsForPickingImages = false
    @State private var showPhotoPicker = false
    
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
                    
                    Image(uiImage: textImage)
                        .resizable()
                        .scaledToFit()
                    
                    Image(uiImage: paintedImage)
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
                    
                    // Paint tool
                    Button {
                        imageEnt.showPainter.toggle()
                    } label: {
                        Image(systemName: "paintbrush.pointed")
                            .foregroundColor(.white)
                            .padding(8)
                            .font(.system(size:26))
                    }
                    .fullScreenCover(isPresented: $imageEnt.showPainter) {
                        ImagePainterView(imageEnt: imageEnt, paintedImage: $paintedImage)
                    }
                    
                    // Add text tool
                    Button {
                        imageEnt.showInsertText.toggle()
                    } label: {
                        Image(systemName: "character")
                            .foregroundColor(.white)
                            .padding(8)
                            .font(.system(size:26))
                    }
                    .fullScreenCover(isPresented: $imageEnt.showInsertText) {
                        InsertTextView(imageEnt: imageEnt, textImage: $textImage)
                    }
                }.padding(.bottom, 10)
            }
            .navigationTitle("PhotoEditAppClone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Gallery
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showOptionsForPickingImages.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                    }.confirmationDialog("Select an option", isPresented: $showOptionsForPickingImages, titleVisibility: .visible) {
                        // Open gallery selection
                        Button("Gallery"){
                            showPhotoPicker = true
                        }
                        
                        // Open browse images online
                        Button("Web"){
                            showBrowseImages = true
                        }
                    }
                    .sheet(isPresented: $showBrowseImages) {
                        BrowseImagesView(imageEnt: imageEnt, showBrowseImages: $showBrowseImages)
                    }
                    .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoFromGallery)
                    .onChange(of: selectedPhotoFromGallery) { newPhoto in
                        // Async operation used to select a new image from gallery
                        Task {
                            if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                            
                            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                imgSaver.updateImg(imageEnt: imageEnt, uiImage: uiImage)
                            }
                        }
                    }
                }
                
                // Save photo
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert.toggle()
                        
                        let renderer = ImageRenderer(content: imgViewGetter.imageComposedView(imageEnt: imageEnt, paintImage: paintedImage, textImage: textImage))
                        
                        composedImage = renderer.uiImage!
                        
                        imgSaver.writeToPhotoAlbum(image: composedImage) // This mf save the image with a white border I don't know why (Fixed)
                        
                        // Clear text
                        textImage = UIImage() // Keep or remove?
                        // Clear painting
                        paintedImage = UIImage() // Keep or remove?
                        
                        //DEBUG
                        //print("width: \(imageEnt.imageUI!.size.width) - height: \(imageEnt.imageUI!.size.height)")
                        
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
                            .font(.system(size:18))
                            .foregroundColor(.gray)
                            .disabled(true)
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: {
                        Image(systemName: "arrow.turn.up.right")
                            .font(.system(size:18))
                            .foregroundColor(.gray)
                            .disabled(true)
                    }
                }
            }
        }
    }
}

