
import Foundation
import SwiftUI
import PhotosUI


class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
    
    func updateImg(imageEnt: ImageModel, uiImage: UIImage){
        imageEnt.imageUI = uiImage.fixOrientation()
        
        imageEnt.blurIntensity = 0
        imageEnt.contrastAdjust = 1
        imageEnt.opacityAdjust = 1
        imageEnt.brightnessAdjust = 0
        imageEnt.saturationAdjust = 1
    }
}
