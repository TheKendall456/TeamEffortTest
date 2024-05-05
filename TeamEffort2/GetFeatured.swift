import Foundation



struct FavoriteMoviesResponse: Codable {
    let results: [Movie]
  
}

func fetchFavoriteMovies(completion: @escaping (Result<FavoriteMoviesResponse, Error>) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/account/20623212/favorite/movies")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "sort_by", value: "created_at.asc"),
    ]
    components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
    ]

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? URLError(.unknown)))
            return
        }

        do {
            let decoder = JSONDecoder()
            let favoriteMoviesResponse = try decoder.decode(FavoriteMoviesResponse.self, from: data)
            completion(.success(favoriteMoviesResponse))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


