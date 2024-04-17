   
    import Foundation
     
    var globalData: Data?
     
    func fetchData() async throws {
        let url = URL(string: "https://api.themoviedb.org/3/authentication")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
        ]
     
        let (data, _) = try await URLSession.shared.data(for: request)
        globalData = data // Store the fetched data in the global variable
        print(String(decoding: data, as: UTF8.self))
    }
     
    @main // Entry point of the program
    struct Main {
        static func main() async {
            do {
                try await fetchData()
            } catch {
                print("Error: \(error)")
            }
        }
    }
