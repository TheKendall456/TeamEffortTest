import SwiftUI

struct SecondaryView: View {
    
    @State private var movies: [Movie] = []


    var body: some View {
        //stores everything in a list to then be recalled for each movie stored
        List(movies, id: \.id) { movie in
            //Vstack that is aligned to the center
            VStack (alignment: .center) {
             
                Text(movie.title)//movie title
                //Text(movie.posterPath ?? "No poster available")
                    .foregroundColor(.secondary)
                
                // Load image asynchronously
                //uses the image url to pull image
                //from api and stores it in this image
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
            //sets padding and frame width for vstack
            .padding(.vertical)
            .frame(width: 500.0)
          
        }
        //calls when page is called
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
    
    //function for fetching data then stores to movie object
    func fetchData() async throws -> [Movie]  {
        
        //sets url that is used to pull
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        
        //sets components which is used to
        //pull specic data in api and sets up parameter for data to be pulled
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        //sets query items specification which pulls from the api
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        //sets compent of query item to the specified object called from $0
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        //setting request parameters
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
        ]

        //request which stores everything under data
        //and _ is the reposne given back which isn't used
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the JSON response to extract movie data
        let decoder = JSONDecoder()
        
        //pulls data to movie reposne which uses the model of movie reponse
        //which then uses the movdel of movie that then stores data
        let movieResponse = try decoder.decode(MovieResponse.self, from: data)

        //returns response which sets retriction of 10 items
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
