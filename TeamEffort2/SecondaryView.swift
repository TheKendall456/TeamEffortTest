//
//  SecondaryView.swift
//  TeamEffort2
//
//  Created by Kendall Goethals on 4/10/24.
//

import SwiftUI


struct SecondaryView: View {
    @State private var apiData: String = ""
    var body: some View {
          VStack {
              Text("This is the Secondary Screen")
                  .font(.largeTitle)
              Text(apiData) // Display fetched data
                  .padding()
          }
          .onAppear {
              // Fetch data when the view appears
              Task {
                  do {
                      apiData = try await fetchData()
                  } catch {
                      print("Error: \(error)")
                  }
              }
          }
      }
    
    func fetchData() async throws -> String  {
        let url = URL(string: "https://api.themoviedb.org/3/find/external_id")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "external_source", value: ""),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjQ5ODg1YTBmYWI2NThkZDNlMTI0MmY3NWE4ODExOSIsInN1YiI6IjY1Mzk5NDZiMjgxMWExMDE0ZDYwYWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dT7HyNSXcyBaeud8FN0XzNCmNpAWXFCzJ7WmrGGJT9A"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return String(decoding: data, as: UTF8.self)
        
    }
}

#Preview {
    SecondaryView()
}
