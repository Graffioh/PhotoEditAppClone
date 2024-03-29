import Foundation

enum NetworkError: Error {
    case serverError(String)
}

class NetworkManager : ObservableObject{
    let token: String = "nhYhY8Lqmyt0GSsFODrwQKI4ZI3e8OBUcq50x8myJUd6d4NKRRyKghdW"
    
    // GET All curated photos
    func fetchCuratedImages(pageNumber: String) async throws -> BrowsedImageResponse {
        guard let url = URL(string: "https://api.pexels.com/v1/curated?page=\(pageNumber)&per_page=10") else {
             print("Invalid url...")
             return BrowsedImageResponse(page: 0, per_page: 0, photos: [])
         }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
          throw NetworkError.serverError("The server responded with an error.")
        }
        
        let browsedImagesResponse = try JSONDecoder().decode(BrowsedImageResponse.self, from: data)
        
        return browsedImagesResponse
    }
    
    // GET searched images
    func fetchSearchedImages(pageNumber: String, searchString: String) async throws -> BrowsedImageResponse {
        guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(searchString)&page=\(pageNumber)&per_page=10") else {
             print("Invalid url...")
             return BrowsedImageResponse(page: 0, per_page: 0, photos: [])
         }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
            
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.serverError("The server responded with an error.")
        }
        
        let browsedImagesResponse = try JSONDecoder().decode(BrowsedImageResponse.self, from: data)
        
        return browsedImagesResponse
    }
}
