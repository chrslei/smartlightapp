//
//  Lights.swift
//  Smart Light App
//
//  Created by Christopher Leibiger on 06.12.23.
//

import Foundation
import Combine
class Lights: ObservableObject {
    @Published var lights = [Light]()
    private var cancellables = Set<AnyCancellable>()
    
    init(lights: [Light] = []) {
        for light in lights {
            self.lights.append(light)
            light.objectWillChange
                .sink(receiveValue: { self.objectWillChange.send() })
                .store(in: &cancellables)
        }
    }
    
    
}
