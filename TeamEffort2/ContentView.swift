//
//  ContentView.swift
//  TeamEffort2
//
//  Created by Kendall Goethals on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SecondaryView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Secondary")
                }


             }
        
        
    }
}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
