import SwiftUI

struct BrowseImagesView: View {
    @ObservedObject var imageEnt: ImageModel
    
    @Binding var showBrowseImages: Bool
    
    @State var fetchedImages: [BrowsedImageModel] = []
    @State var convertedImages: [UIImage] = []
    
    @StateObject var imageConverter: ImageConverter = ImageConverter()
    
    @State var pageNumberCount: Int = 1
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showBrowseImages.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                
                Text("Browse images")
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Button {
                    if pageNumberCount > 1 {
                        pageNumberCount-=1
                    }
                    
                    Task {
                        do {
                            self.fetchedImages = try await NetworkManager().fetchPexelsImages(pageNumber: String(pageNumberCount)).photos
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size:20))
                        .foregroundColor(pageNumberCount < 2 ? .gray : .yellow)
                }.disabled(pageNumberCount < 2 ? true : false)
                
                Button {
                    pageNumberCount+=1
                    
                    Task {
                        do {
                            self.fetchedImages = try await NetworkManager().fetchPexelsImages(pageNumber: String(pageNumberCount)).photos
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size:20))
                        .foregroundColor(.yellow)
                }
            
        }.padding()
        
        Spacer()
        
            Text("Photos provided by Pexels")
            
        List(self.fetchedImages, id: \.self) { img in
            Button {
                showBrowseImages.toggle()
                
                Task {
                    imageEnt.imageUI = try await imageConverter.convertUrlIntoSingleImage(imgUrl: img.src.large)
                }
            } label: {
                AsyncImage(url: URL(string: img.src.large)) { asyncimg in
                    asyncimg
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
        
    }.onAppear {
//        URLCache.shared.memoryCapacity = 50_000_000
//        URLCache.shared.diskCapacity = 1_000_000_000
        
        Task {
            do {
                self.fetchedImages = try await NetworkManager().fetchPexelsImages(pageNumber: "1").photos
                
                //self.convertedImages = try await imageConverter.convertUrlIntoImages(browsedImages: fetchedImages)
            } catch {
                print(error)
            }
        }
    }
}
}


