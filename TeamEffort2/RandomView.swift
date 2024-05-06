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
        @State private var refreshToggle = false
        var body: some View {
            
            VStack(alignment: .center) {
                
                if let randomMovie = movieFetcher.setMovies.randomElement() {
                    // Display details of the randomly selected movie
                    
                    Text(randomMovie.title)
                        .foregroundColor(.white)
                        .bold()
                        .underline()
                        .italic()
                    
                    
                    AsyncImage(url: randomMovie.posterURL) { image in
                        image
                            .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 450.0)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.7), radius: 6, x: 0, y: 2)
                                .padding(10)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.horizontal)
                    
                    // Add button to add movie to favorites
                    Button(action: {
                        FeatureAdd.addToFavorites(movieID: randomMovie.id)
                    }) {
                        Text("Add to Favorites")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                    
                    
                    
                } else {
                    Text("No movies available")
                        .foregroundColor(.secondary)
                }
                
                Button("Refresh") {
                                self.refreshToggle.toggle()
                }
                Text("Page Status: \(refreshToggle ? "Refreshed!" : "Initial Content")").foregroundColor(Color.clear)
            }
            .padding(.vertical)
            .frame(width: 500.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill parent view
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all) // Ignore safe area for gradient
                    )
            .onAppear {
                // Fetch movies data when the view appears
                movieFetcher.getMovies()
            }
        }
    }

#Preview {
    RandomView()
}
