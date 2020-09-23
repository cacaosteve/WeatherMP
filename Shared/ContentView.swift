// rgb(5, 223, 215)

import SwiftUI

struct ContentView: View {
    @ObservedObject var fetcher = WeatherFetcher()
    
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
            .navigationBarTitle(Text(fetcher.title))
            .alert(isPresented: $fetcher.showingAlert) {
                Alert(title: Text("Error"), message: Text("There was an issue parsing data from the server"), dismissButton: .default(Text("Got it!")))
            }
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
