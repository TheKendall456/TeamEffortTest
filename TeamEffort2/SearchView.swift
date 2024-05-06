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
        VStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
            
            List(movies, id: \.id) { movie in
                VStack(alignment: .center) {
                    Text(movie.title)
                        .foregroundColor(.secondary)
                    
                    AsyncImage(url: movie.posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 150.0)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding(10)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.horizontal)
                    
                    // Add button to add movie to favorites
                    Button(action: {
                        FeatureAdd.addToFavorites(movieID: movie.id)
                    }) {
                        Text("Add to Favorites")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    
                }
                .padding(.vertical)
                .frame(width: 500.0)
            }
        }
        .onAppear {
            // Fetch data when the view appears
            fetchData()
        }
        .onChange(of: searchText) { _ in
            // Fetch data whenever searchText changes
            fetchData()
        }
    }
    
    func fetchData() {
        Task {
            do {
                movies = try await fetchSearchData(for: searchText)
            } catch {
                print("Error: \(error)")
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






#Preview {
    SearchView(searchText: .constant(""))
}


