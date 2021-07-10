//
//  SettingsView.swift
//  Packs
//
//  Created by Alex Layton on 10/07/2021.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                Section(header: packSizesHeader) {
                    ForEach(appState.packSizes) {
                        Text("\($0)")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
        }
    }
    
    var packSizesHeader: some View {
        HStack {
            Text("Pack Sizes")
            Spacer()
            Button(action: {}) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView()
            .environmentObject(AppState())
    }
}

