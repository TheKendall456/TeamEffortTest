import SwiftUI

class MovieFetcher: ObservableObject {
    @Published var setMovies: [Movie] = []
    
    func getMovies() {
        Task {
            do {
                // Fetch movie data asynchronously
                let movies = try await fetchData()
                
                // Assign fetched movies to setMovies
                DispatchQueue.main.async {
                    self.setMovies = movies
                }
                
                // Print the number of fetched movies
                print("Fetched \(movies.count) movies")
            } catch {
                print("Error fetching movies: \(error)")
                // Handle error as needed
            }
        }
    }
}

struct RandomView: View {

        @StateObject private var movieFetcher = MovieFetcher()
        
        var body: some View {
            VStack(alignment: .center) {
                if let randomMovie = movieFetcher.setMovies.randomElement() {
                    // Display details of the randomly selected movie
                    Text(randomMovie.title)
                        .foregroundColor(.secondary)
                    
                    AsyncImage(url: randomMovie.posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 150.0)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.horizontal)
                } else {
                    Text("No movies available")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical)
            .frame(width: 500.0)
            .onAppear {
                // Fetch movies data when the view appears
                movieFetcher.getMovies()
            }
        }
    }

#Preview {
    RandomView()
}
