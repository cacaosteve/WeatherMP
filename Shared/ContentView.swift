// rgb(5, 223, 215)

import SwiftUI

extension UserDefaults {
    @objc var cityName: Float {
        get {
            return float(forKey: "cityName")
        }
        set {
            set(newValue, forKey: "cityName")
        }
    }
}

struct ContentView: View {
    @ObservedObject var fetcher = WeatherFetcher()
    @ObservedObject var cityFetcher = CityIDFetcher()
    @State var isPresentingModal: Bool = false
    @AppStorage("cityName") var cityName = "San Diego"
    
    var body: some View {
        NavigationView{
            List(fetcher.consolidatedWeathers) { consolidatedWeathers in
                HStack(alignment: .center) {
                    VStack(alignment: .leading)  {
                        Text(consolidatedWeathers.applicableDate)
                        Text(consolidatedWeathers.weatherStateName)
                        Text("Min: \(consolidatedWeathers.minTemp) ºC")
                        Text("Max: \(consolidatedWeathers.maxTemp) ºC")
                    }
                    Spacer()
                    VStack(alignment: .trailing)  {
                        Image(consolidatedWeathers.weatherStateAbbr)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle(Text(fetcher.title))
            .alert(isPresented: $fetcher.showingAlert) {
                Alert(title: Text("Error"), message: Text("There was an issue parsing data from the server"), dismissButton: .default(Text("Got it!")))
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            self.isPresentingModal = true
        }) {
            Image(systemName: "plus.circle.fill") // magnifyingglass.circle.fill
            .font(.title)
        }.sheet(isPresented: $isPresentingModal) {
            SearchView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#if os(macOS)
extension View {
    func navigationBarTitle(_ title: Text) -> some View {
        return self
    }
}
#endif
