
import SwiftUI

struct EditPhotoView: View {
    var body: some View {
        NavigationView {
            VStack{
                
                Spacer()
                
                
                Image("image1")
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
                    Image(systemName: "crop")
                        .padding(8)
                        .font(.system(size:26))
                    
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
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
    }
}
