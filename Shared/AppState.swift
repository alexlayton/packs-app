//
//  AppState.swift
//  Packs
//
//  Created by Alex Layton on 10/07/2021.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    
    @Published var packSizes = [250, 500, 1000, 2000, 5000]
    
    @Published var count = 0
    
    @Published var calculatedPacks = Packs()
    
    let client = PacksClient()
    
    var calculateCancellable: AnyCancellable?
    
    func calculate() {
        calculatedPacks = []
        calculateCancellable?.cancel()
        calculateCancellable = client
            .calculate(count: count, packSizes: packSizes)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error calculating - \(error.localizedDescription)")
                }
            } receiveValue: { packs in
                self.calculatedPacks = packs
            }
    }
    
}
