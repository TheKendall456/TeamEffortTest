//
//  FeatureView.swift
//  TeamEffort2
//
//  Created by GOETHALS, KENDALL A. on 4/24/24.
//

import SwiftUI

struct FeatureView: View {
    
    @State private var movies: [Movie] = []
    
    var body: some View {
        // ScrollView to display movies
        ScrollView {
            LazyVStack {
                ForEach(movies, id: \.id) { movie in
                    VStack(alignment: .center) {
                        // Display movie title
                        Text(movie.title)
                            .foregroundColor(.black)
                            .italic()
                            .padding(.horizontal)
                        
                        // Load movie image asynchronously
                        AsyncImage(url: movie.posterURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 250.0)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                        } placeholder: {
                            // Placeholder image or activity indicator
                            ProgressView()
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            // Fetch data when the view appears
            fetchFavoriteMovies { result in
                switch result {
                case .success(let response):
                    movies = response.results
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}



#Preview {
    FeatureView()
}
