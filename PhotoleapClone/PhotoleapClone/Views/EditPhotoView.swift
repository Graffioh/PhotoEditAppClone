
import SwiftUI
import CropViewController

struct EditPhotoView: View {
    @State var image1: UIImage? = UIImage(named: "image1")!
    
    @State private var showImageCropper = false
    
    @State private var tempInputImage: UIImage?

      func imageCropped(image: UIImage){
        self.tempInputImage = nil
          self.image1 = image
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
                    Image(systemName: "house")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
        }
        
        // Crop tool logic
        if showImageCropper {
            ImageCropper(image: self.$image1, visible: self.$showImageCropper,done: self.imageCropped).zIndex(10)
        }
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
    }
}
