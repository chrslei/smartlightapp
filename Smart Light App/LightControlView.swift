import SwiftUI

struct LightControlView: View {
    @State private var showOverlay = false
    @Binding var selectedRoom: Int
    @EnvironmentObject var lights: Lights
    
    var filteredLights: [Light] {
        if selectedRoom == 0 {
            return lights.lights
        } else {
            return lights.lights.filter { $0.room == selectedRoom }
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
    
    var body: some View {
        ZStack{
            Text(LightControlView.getTitle(for: selectedRoom))
                .font(.largeTitle)
                .foregroundStyle(Color.customLightestGray)
                .bold()
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .offset(x: 40, y: -265)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            OverviewPanel()
                .offset(x: -7, y: -170)
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 116))], spacing: 30) {
                    ForEach(filteredLights, id: \.id) { light in
                        LightButton(light: light, showOverlay: $showOverlay)
                    }
                }
                .padding(.top)
                .padding(.top)
                .padding(.trailing)
                .padding(.trailing)
                Spacer()
            }
            .frame(width: 350)
            .padding(.leading)
            .offset(y: 110)
        }
        .offset(x: -10)
    }
}

struct OverviewPanel: View {
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [ .clear, .white]), startPoint: .top, endPoint: .bottom))
                .frame(width: 300, height: 100)
                .cornerRadius(30)
                .opacity(0.2)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 2)
                        .opacity(0.6)
                )
            VStack{
                Text("Guten Morgen, Marlene!")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading) // Optional, für zusätzlichen Abstand vom Rand
                Text("0 aktive Leuchten")
                    .bold()
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading) // Optional, für zusätzlichen Abstand vom Rand
                Text("Aktueller Verbrauch: 2,4 kWh")
                    .bold()
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading) // Optional, für zusätzlichen Abstand vom Rand
            }
            .offset(x: 50)
        }
    }
}


struct LightButton: View {
    @ObservedObject var light: Light
    @Binding var showOverlay : Bool
    @GestureState private var isLongPressing = false
    @State private var isShowingDetails = false
    @State private var angleValue: CGFloat = 0.0
    let config = Config(minimumValue: 0.0, maximumValue: 100.0, totalValue: 200.0, knobRadius: 10.0, radius: 70.0)
    
    private func change(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: location.y)
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi/2.0
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        let value = fixedAngle / (2.0 * .pi) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            light.brightness = value
            angleValue = fixedAngle * 180 / .pi
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.customLightestGray)
                .frame(width: 140, height: 100)
                .cornerRadius(20)
                .onTapGesture {
                    if light.brightness > 0 {
                        light.setBrightness(to: 0)
                    }
                    else {
                        light.setBrightness(to: 100)
                    }
                }
                .offset(x:0)
                .shadow(color: Color.gray.opacity(0.5), radius: 0, x: 4, y: 5)
                .opacity(showOverlay && !isShowingDetails || !showOverlay && !isShowingDetails ? 1 : 0)
            
            Rectangle()
                .fill(light.brightness > 0 ? Color.customYellow : Color.blue)
                .frame(width: 20, height: 26)
                .cornerRadius(5)
                .shadow(color: Color.gray.opacity(0.5), radius: 0, x: 3, y: 3)
                .onTapGesture {
                    if light.brightness > 0 {
                        light.setBrightness(to: 0)
                        light.objectWillChange.send()
                    }
                    else {
                        light.setBrightness(to: 100)
                    }
                }
                .offset(x: (showOverlay && !isShowingDetails) || (!showOverlay && !isShowingDetails) ? -50 : -35)
            
            if !isShowingDetails {
                VStack(alignment: .leading){
                    Text(light.name)
                    
                        .font(.system(size: 13))
                        .bold()
                    
                    Text("\(String(format: "%.0f", light.brightness)) %")
                    
                        .font(.system(size: 13))
                        .bold()
                    Text(RoomSelectionView.getTitle(for: light.room))
                    
                        .font(.system(size: 13))
                }
                .foregroundColor(.customBlack)
                .frame(width: 300, height: 100)
                .offset(x:12)
            }
            
        }
        .onChange(of: isShowingDetails) { newValue in
            showOverlay = newValue
        }
        .gesture(
            LongPressGesture(minimumDuration: 0.5)
                .updating($isLongPressing) { current, state, _ in
                    state = current
                }
                .onEnded { _ in
                    isShowingDetails = true
                }
                .sequenced(before: DragGesture(minimumDistance: 0.0))
                .onChanged { value in
                    if case .second(true, let drag?) = value {
                        change(location: drag.location)
                    }
                }
                .onEnded { _ in
                    isShowingDetails = false
                }
        )
        .overlay(
            Group {
                if isShowingDetails {
                    BrightnessControlView(light: light, angleValue: $angleValue)
                        .frame(width: 80, height: 160)
                        .offset(x: -40)
                        .frame(width: 100)
                        .clipped()
                        .offset(x: 40)
                }
            }
        )
        .animation(.easeInOut, value: isShowingDetails)
        .opacity(showOverlay && isShowingDetails || !showOverlay && !isShowingDetails ? 1.0 : 0.2)
    }
}

// Quelle: https://medium.com/@anik1.bd_38552/swiftui-circular-slider-f713a2b28779
struct BrightnessControlView: View {
    @ObservedObject var light: Light
    @Binding var angleValue: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0))
                .frame(width: 140, height: 140)
                .scaleEffect(1.2)
            
            Circle()
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, dash: [3, 23.18]))
                .frame(width: 140, height: 140)
            
            Circle()
                .trim(from: 0.0, to: light.brightness / 200.0)
                .stroke(light.brightness < 100.0 ? Color.customYellow : Color.red, lineWidth: 4)
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill(light.brightness < 100.0 ? Color.customYellow : Color.red)
                .frame(width: 20, height: 20)
                .padding(10)
                .offset(y: -70)
                .rotationEffect(Angle.degrees(Double(angleValue)))
            
            Text("\(String(format: "%.0f", light.brightness)) %")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .offset(x: 25)
        }
    }
}


struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct DashboardView_Previews: PreviewProvider {
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
