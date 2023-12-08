//
//  ContentView.swift
//  Smart Light App
//
//  Created by Christopher Leibiger on 04.12.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedRoom: Int = 0
    @State private var scenes: [SingleScene] = [SingleScene(name: "Night", number: 0, brightnesses: [0.0, 0, 0, 0, 0, 0], image: Image(systemName: "moon.fill")), SingleScene(name: "Morning", number: 0, brightnesses: [40, 40, 40, 40, 40, 40], image: Image(systemName: "sun.horizon.fill")), SingleScene(name: "Work", number: 0, brightnesses: [0, 0, 30, 30, 30, 30], image: Image(systemName: "suitcase")), SingleScene(name: "Maximum", number: 0, brightnesses: [40, 40, 40, 40, 40, 40], image: Image(systemName: "light.max")), SingleScene(name: "Gear", number: 0, brightnesses: [40, 40, 40, 40, 40, 40], image: Image(systemName: "gear")) ]
    @EnvironmentObject var lights: Lights
    
    private func updateSceneSelection() {
        for index in scenes.indices {
            if scenes[index].isSelected {
                if !scenes[index].matchesCurrentLightSettings(lights: lights.lights) {
                    withAnimation {
                        scenes[index].isSelected = false
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image("backgroundtest4")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                Text("Smart Light")
                    .font(.largeTitle)
                    .foregroundStyle(Color.customLightestGray)
                    .bold()
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding(.leading)
                RoomSelectionView(selection: $selectedRoom)
                    .padding(.top)
                LightControl(selectedRoom: $selectedRoom)
                    .frame(height: 450)
                Spacer()
                SceneSelectionView(scenes: $scenes)
                
            }
            .onReceive(lights.objectWillChange) {
                updateSceneSelection()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Lights(lights: [Light(name: "Decke", room: 1, brightness: 0),
                                               Light(name: "Decke 2", room: 1, brightness: 0),
                                               Light(name: "Stehlampe", room: 2, brightness: 0),
                                               Light(name: "Tischlampe", room: 2, brightness: 0),
                                               Light(name: "Wandleuchte", room: 3, brightness: 0),
                                               Light(name: "Sideboard", room: 3, brightness: 0) ]))
    }
}

