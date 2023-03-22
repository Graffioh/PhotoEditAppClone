import SwiftUI

struct BrowseImagesView: View {
    @Binding var showBrowseImages: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    showBrowseImages.toggle()
                } label: {
                    Text("Done")
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
        }
    }
}

