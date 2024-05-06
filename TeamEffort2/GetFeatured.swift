import Foundation


//sets strucutre from the movie object in global data
struct FavoriteMoviesResponse: Codable {
    let results: [Movie]
}

//func that calls data from api then sets it to favmovieresp
func fetchFavoriteMovies(completion: @escaping (Result<FavoriteMoviesResponse, Error>) -> Void) {
    //sets url for request
    let url = URL(string: "https://api.themoviedb.org/3/account/20623212/favorite/movies")!
    
    //sets components which is used to
    //pull specic data in api and sets up parameter for data to be pulled
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    //sets query items for what kind of information is pulled
    let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "sort_by", value: "created_at.asc"),
    ]
    
    components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

    //sets a var request that uses cpmponets set to make a call and set to request
    var request = URLRequest(url: components.url!)
    
    //sets request pethod
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    //sets info that the api will need to accept pull
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
    ]
    
    //func for pulling data from api to fav movie response
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        //catches any errors made here
        guard let data = data, error == nil else {
            completion(.failure(error ?? URLError(.unknown)))
            return
        }
        
        //if sucessful will go through this method which just sets the reponse and also checks again for error
        do {
            let decoder = JSONDecoder()
            let favoriteMoviesResponse = try decoder.decode(FavoriteMoviesResponse.self, from: data)
            completion(.success(favoriteMoviesResponse))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


