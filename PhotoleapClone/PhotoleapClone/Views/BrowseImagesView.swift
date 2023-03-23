import SwiftUI

struct BrowseImagesView: View {
    @ObservedObject var imageEnt: ImageModel
    
    @Binding var showBrowseImages: Bool
    
    @State var fetchedImages: [BrowsedImageModel] = []
    @State var convertedImages: [UIImage] = []
    
    @StateObject var imageConverter: ImageConverter = ImageConverter()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showBrowseImages.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
                Text("Photos provided by Pexels")
                
                Spacer()

            }.padding()
            
            Spacer()
            
            List(self.fetchedImages, id: \.self) { img in
                Button {
                    showBrowseImages.toggle()
                    
                    Task {
                        imageEnt.imageUI = try await imageConverter.convertUrlIntoSingleImage(imgUrl: img.src.medium)
                    }
                } label: {
                    AsyncImage(url: URL(string: img.src.medium)) { asyncimg in
                        asyncimg
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
            }
            
        }.onAppear {
            Task {
                do {
                    self.fetchedImages = try await NetworkManager().fetchPexelsImages().photos
                    
                    self.convertedImages = try await imageConverter.convertUrlIntoImages(browsedImages: fetchedImages)
                } catch {
                    print(error)
                }
            }
        }
    }
}


