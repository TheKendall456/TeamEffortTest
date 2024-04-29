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
    
#if DEBUG
    struct SecondaryView_Previews: PreviewProvider {
        static var previews: some View {
            SecondaryView()
        }
    }
#endif
}
