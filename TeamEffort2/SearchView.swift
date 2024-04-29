//
//  SearchView.swift
//  TeamEffort2
//
//  Created by GOETHALS, KENDALL A. on 4/24/24.
//

import SwiftUI

struct SearchView: View {
    @State private var movies: [Movie] = []
    @Binding var searchText: String
    
    var body: some View {
        
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
            Spacer()
        }
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
            Task {
                do {
                    movies = try await fetchSearchData(for: searchText)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}

func fetchSearchData(for query: String) async throws -> [Movie] {
    let urlString = "https://api.themoviedb.org/3/search/movie"
    guard var urlComponents = URLComponents(string: urlString) else {
        throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    let queryItems: [URLQueryItem] = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "include_adult", value: "false"),
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: "1"),
    ]
    urlComponents.queryItems = queryItems

    guard let url = urlComponents.url else {
        throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    let movieResponse = try decoder.decode(MovieResponse.self, from: data)

    return movieResponse.results
}





#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""))
    }
}
#endif


