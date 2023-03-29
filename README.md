# PhotoEditAppClone
iOS App clone made for educational purpose.

Implemented functionalities (without external packages):
+ Pick an image from the Gallery
  - PhotoPicker from PhotosUI to save or retrieve images from the Gallery
+ Save an image in the Gallery
  - ImageRenderer to save the composed image (Cropped/Painted/with Text)
  - Async rect reader with GeometryReader used to get image size based on specific device
+ Crop tool
  - Custom crop with a native SwiftUI Rectangle
+ Enhancer tool
  - Sliders that changes UIImage properties
  - Properties: Brightness, Opacity, Saturation and more...
+ Paint tool
  - Custom paint using Points, Lines and Paths
+ Add text tool
  - Simple TextField

## NEW VERSION!

Bug fixes, QoL improvements and a new functionality:
+ Browse images from the web and edit directly in the app
  - [Pexels](https://Pexels.com) API call
  - Search for images thanks to a custom query

Video:

https://user-images.githubusercontent.com/93008765/228460175-0eb7d886-2970-4cb1-954d-ff3e1c317da1.mp4







