//
//  ContentView.swift
//  Shared
//
//  Created by Alex Layton on 10/07/2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var showSettings = false
    
    @State var countText = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Calculate")) {
                    TextField("Count", text: $countText)
                    Button(action: { appState.calculate() }) {
                        Text("Calculate")
                    }
                }
                Section(header: Text("Packs")) {
                    packsView
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Packs")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { settingsButton }
            }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .onChange(of: countText) { appState.count = Int($0) ?? 0 }
    }
    
    var settingsButton: some View {
        Button(action: { showSettings = true }) {
            Image(systemName: "gearshape")
        }
    }
    
    var packsView: some View {
        ForEach(appState.calculatedPacks) { pack in
            Text("\(pack.size) x \(pack.size)")
        }
    }

}

extension Pack: Identifiable {
    public var id: Int {
        size
    }
}

class ContentViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    let client = PacksClient()
    
    @Published var packSizes = [250, 500, 1000, 2000, 5000]
    
    @Published var count = 1
    

    
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
