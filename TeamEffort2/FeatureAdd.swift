import Foundation

class FeatureAdd {
    
    static func addToFavorites(movieID: Int) {
        let parameters = [
            "media_type": "movie",
            "media_id": movieID,
            "favorite": true
        ] as [String : Any?]

        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let url = URL(string: "https://api.themoviedb.org/3/account/20623212/favorite")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
            ]
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                }
                
                print(String(decoding: data, as: UTF8.self))
                
            }.resume()
            
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
}
