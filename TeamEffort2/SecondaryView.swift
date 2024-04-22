import SwiftUI

struct SecondaryView: View {
    @State private var movies: [Movie] = []


    var body: some View {
        List(movies, id: \.id) { movie in
            VStack (alignment: .center) {
             
                Text(movie.title)
                //Text(movie.posterPath ?? "No poster available")
                    .foregroundColor(.secondary)
                // Load image asynchronously
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150.0)
                       
                       
                } placeholder: {
                    // Placeholder image or activity indicator
                    ProgressView()
                }
                .padding(.horizontal)
                
            }
            .padding(.vertical)
            .frame(width: 500.0)
          
        }
        .onAppear {
            // Fetch data when the view appears
            Task {
                do {
                    movies = try await fetchData()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchData() async throws -> [Movie]  {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the JSON response to extract movie data
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)

        return Array(movieResponse.results.prefix(10))
    }
}

// Define a struct to represent the movie
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }

    // Computed property to get the full URL of the poster image
    var posterURL: URL? {
        guard let posterPath = posterPath,
              !posterPath.isEmpty,
              posterPath != "null" else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
}
// Define a struct to represent the movie response
struct MovieResponse: Codable {
    let results: [Movie]
}

#if DEBUG
struct SecondaryView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryView()
    }
}
#endif
