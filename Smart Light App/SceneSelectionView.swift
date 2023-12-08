import SwiftUI

struct SceneSelectionView: View {
    @State private var selections = Set<Int>()
    @Binding var scenes: [SingleScene]
    @EnvironmentObject var lights: Lights
    
    func isSceneSelected(_ index: Int) -> Bool {
        selections.contains(index)
    }
    
    func toggleScene(_ index: Int) {
        if scenes[index].isSelected {
            scenes[index].isSelected = false
            scenes[0].activateScene(lights: lights)
        }
        else {
            scenes[index].isSelected = true
            scenes[index].activateScene(lights: lights)
        }
    }
    
    func offsetForTab(at index: Int) -> CGFloat {
        if selections.contains(index) {
            return 0
        } else if index < selections.min() ?? 0 {
            return -10
        } else {
            return 10
        }
    }
    
    func getTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "Favoriten"
        case 1:
            return "Wohnzimmer"
        case 2:
            return "Küche"
        case 3:
            return "Bad"
        case 4:
            return "Sonstiges"
        default:
            return "Unbekannt"
        }
    }
    
    func getColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .customScene
        case 1:
            return .customScene
        case 2:
            return .customScene
        case 3:
            return .customScene
        case 4:
            return .customScene
        default:
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(scenes.indices, id: \.self) { index in
                        SceneBarButton(scene: $scenes[index], assignedTag: index, color: .customScene)
                            .offset(x: self.offsetForTab(at: index))
                            .onTapGesture {
                                withAnimation {
                                    toggleScene(index)
                                }
                            }
                    }
                }
                .frame(height: 100)
                .padding(.bottom)
                .padding(.bottom)
            }
            .animation(.easeInOut, value: selections)
        }
        .background(Color.customLightestGray)
        .overlay(Divider().background(.gray), alignment: .top)
    }
}

struct SceneBarButton: View {
    @Binding var scene: SingleScene
    let assignedTag: Int
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(scene.isSelected ? LinearGradient(gradient: Gradient(colors: [ .customYellow, .yellow]), startPoint: .top, endPoint: .bottom)
                  : LinearGradient(gradient: Gradient(colors: [color]), startPoint: .top, endPoint: .bottom))
            .frame(width: scene.isSelected ? 90 : 80, height: scene.isSelected ? 50 : 40)
            .cornerRadius(50)
            .shadow(color: Color.gray.opacity(0.5), radius: 0, x: 4, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 0)
            )
            .overlay(
                scene.image
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            )
            .zIndex(scene.isSelected ? 1 : 0)
    }
    
}


struct SceneView_Previews: PreviewProvider {
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
