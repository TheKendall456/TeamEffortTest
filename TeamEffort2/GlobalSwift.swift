//
//  GlobalSwift.swift
//  TeamEffort2
//
//  Created by GRANT, EBBETT C. on 4/24/24.
//

import Foundation

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


var setMovies: [Movie] = []

func getMovies() {
    Task {
        do {
            // Fetch movie data asynchronously
            let movies = try await fetchData()
            
            // Assign the fetched movies to setMovies
            setMovies = movies
            
            // Print the number of fetched movies
            print("Fetched \(movies.count) movies")
        } catch {
            print("Error fetching movies: \(error)")
            // Handle error as needed
        }
    }
}








