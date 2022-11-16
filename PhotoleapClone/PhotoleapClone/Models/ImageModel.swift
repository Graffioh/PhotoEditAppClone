
import Foundation
import SwiftUI

class ImageModel: ObservableObject{
    @Published var blurIntensity: CGFloat
    @Published var contrastAdjust: Double
    @Published var opacityAdjust: Double
    @Published var brightnessAdjust: Double
    @Published var saturationAdjust: Double
    @Published var showCropper: Bool
    @Published var showEnhancer: Bool
    @Published var imageUI: UIImage?
    
    init(blurIntensity: CGFloat, contrastAdjust: Double, opacityAdjust: Double, brightnessAdjust: Double, saturationAdjust: Double, showCropper: Bool, showEnhancer: Bool, imageUI: UIImage) {
        self.blurIntensity = blurIntensity
        self.contrastAdjust = contrastAdjust
        self.opacityAdjust = opacityAdjust
        self.brightnessAdjust = brightnessAdjust
        self.saturationAdjust = saturationAdjust
        self.showCropper = showCropper
        self.showEnhancer = showEnhancer
        self.imageUI = imageUI
    }
}
