import SwiftUI

struct RoomSelectionView: View {
    @Binding var selection: Int
    
    func offsetForTab(at index: Int) -> CGFloat {
        if index == selection {
            return 0
        } else if index < selection {
            return 0
        } else {
            return 10
        }
    }
    
    static func getTitle(for index: Int) -> String {
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
            return ""
        default:
            return "Unbekannt"
        }
    }
    
    func getColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .yellow
        case 1:
            return .cyan
        case 2:
            return .purple
        case 3:
            return .orange
        case 4:
            return .gray
        default:
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: -20) {
                ForEach(0..<5) { index in
                    TabBarButton(selected: $selection, assignedTag: index, color: getColor(for: index))
                        .offset(x: self.offsetForTab(at: index))
                        .opacity(selection == index ? 1 : 1)
                }
            }
            .frame(height: 60)
            
            HStack(spacing: -20) {
                ForEach(0..<5) { index in
                    Text(RoomSelectionView.getTitle(for: index).uppercased())
                        .padding(.top)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundColor(selection == index ? .white : .clear)
                        .frame(width: selection == index ? 150 : 80, height: 20)
                        .offset(x: self.offsetForTab(at: index))
                }
            }
        }
        .animation(.easeInOut, value: selection)
    }
}

struct TabBarButton: View {
    @Binding var selected: Int
    let assignedTag: Int
    let color: Color
    
    func getIcon(for index: Int) -> Image {
        switch index {
        case 0:
            return Image(systemName: "star.fill")
        case 1:
            return Image(systemName: "sofa.fill")
        case 2:
            return Image(systemName: "fork.knife")
        case 3:
            return Image(systemName: "shower.fill")
        default:
            return Image(systemName: "plus.circle")
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: selected == assignedTag ? 90 : 80, height: selected == assignedTag ? 50 : 40)
            .cornerRadius(10)
            .shadow(color: .customLighGray.opacity(1), radius: 0, x: 4, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customLightestGray, lineWidth: 0)
            )
            .overlay(
                getIcon(for: assignedTag)
                    .foregroundColor(.customLightestGray)
                    .font(.system(size: 28))
            )
            .zIndex(selected == assignedTag ? 1 : 0)
            .onTapGesture {
                withAnimation {
                    selected = assignedTag
                }
            }
    }
}


struct RoomTabs_Previews: PreviewProvider {
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
