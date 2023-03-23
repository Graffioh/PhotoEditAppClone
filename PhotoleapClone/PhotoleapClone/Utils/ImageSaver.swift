
import Foundation
import SwiftUI
import PhotosUI


class ImageSaver: NSObject, ObservableObject {
    func writeToPhotoAlbum(image: UIImage) {
        //ImageConverter().convertImgToJpg(image: image)
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
