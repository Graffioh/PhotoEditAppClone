import SwiftUI

struct BrowseImagesView: View {
    @ObservedObject var imageEnt: ImageModel
    @StateObject var imageConverter: ImageConverter = ImageConverter()
    
    @Binding var showBrowseImages: Bool
    
    @State private var fetchedImages: [BrowsedImageModel] = []
    @State private var fetchedImagesTry: [BrowsedImageModel] = []
    @State private var convertedImages: [UIImage] = []
    @State private var pageNumberCount: Int = 1
    @State private var searchText: String = ""
    @State private var isSearched: Bool = false
    
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
                
                Text("Browse")
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Button {
                    if pageNumberCount > 1 {
                        pageNumberCount-=1
                    }
                    
                    Task {
                        do {
                            if !isSearched {
                                self.fetchedImages = try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount)).photos
                                fetchedImages.append(contentsOf: try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount + 1)).photos)
                            } else {
                                self.fetchedImages = try await NetworkManager().fetchSearchedImages(pageNumber: String(pageNumberCount), searchString: searchText).photos
                                fetchedImages.append(contentsOf: try await NetworkManager().fetchSearchedImages(pageNumber: String(pageNumberCount + 1), searchString: searchText).photos)
                            }
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size:16))
                        .foregroundColor(pageNumberCount < 2 ? .gray : .yellow)
                }.disabled(pageNumberCount < 2 ? true : false)
                
                Button {
                    pageNumberCount+=1
                    
                    Task {
                        do {
                            if !isSearched {
                                self.fetchedImages = try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount)).photos
                                //fetchedImages.append(contentsOf: try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount + 1)).photos) // TRY FOR CACHING
                            } else {
                                self.fetchedImages = try await NetworkManager().fetchSearchedImages(pageNumber: String(pageNumberCount), searchString: searchText).photos
                                //fetchedImages.append(contentsOf: try await NetworkManager().fetchSearchedImages(pageNumber: String(pageNumberCount + 1), searchString: searchText).photos) // TRY FOR CACHING
                            }
                        } catch {
                            print(error)
                        }
                    }
//                    Task {
//                        do {
//                            if !isSearched {
//                                async let fetchedImagesC1 = try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount)).photos
//
//                                    async let fetchedImagesC2 = try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount + 1)).photos
//
//
//
//                                fetchedImages = await fetchedImagesC1
//                                fetchedImages.append(contentsOf: await fetchedImagesC2).photos)
//                            } else {
//                                print("Yo")
//
//                            }
//                        } catch {
//                            print(error)
//                        }
//                    }
                        
                    
                    
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size:16))
                        .foregroundColor(.yellow)
                }
                
            }.padding()
            
            Spacer()
            
            Text("Photos provided by Pexels")
            
            Spacer()
            
            HStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(16)
                
                Button {
                    isSearched = true
                    
                    pageNumberCount = 1
                    
                    Task {
                        do {
                            self.fetchedImages = try await NetworkManager().fetchSearchedImages(pageNumber: String(pageNumberCount), searchString: searchText).photos
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.trailing, 20)
                }
            }
            
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
            //URLCache.shared.memoryCapacity = 50_000_000
            //URLCache.shared.diskCapacity = 1_000_000_000
            
            Task {
                do {
                    self.fetchedImages = try await NetworkManager().fetchCuratedImages(pageNumber: "1").photos
                    // fetchedImages.append(contentsOf: try await NetworkManager().fetchCuratedImages(pageNumber: String(pageNumberCount + 1)).photos) // TRY FOR CACHING
                    
                    //self.convertedImages = try await imageConverter.convertUrlIntoImages(browsedImages: fetchedImages)
                } catch {
                    print(error)
                }
            }
        }
    }
}

