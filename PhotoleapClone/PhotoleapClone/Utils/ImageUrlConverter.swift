import Foundation
import SwiftUI

class ImageUrlConverter: ObservableObject {
    func convertUrlIntoImages(browsedImages: [BrowsedImageModel]) async throws -> [UIImage] {
        var images: [UIImage] = []
        
        for browsedImage in browsedImages {
            let imageUrlString = browsedImage.src.medium

            let imageUrl = URL(string: imageUrlString)!
            
            let (data, _) = try await URLSession.shared.data(from: imageUrl)

            if let image = UIImage(data: data) {
                images.append(image)
                print("hello")
            }

        }
        
        return images
    }

    func convertUrlIntoSingleImage(imgUrl: String) async throws -> UIImage {
        var image: UIImage = UIImage()
        
        //let data = try! Data(contentsOf: URL(string: imgUrl)!)
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: imgUrl)!)

        if let uiimage = UIImage(data: data) {
            image = uiimage
        }

        return image
    }
}
