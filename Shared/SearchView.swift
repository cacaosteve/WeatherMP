import SwiftUI

struct SearchView : View {
    @State private var search: String = ""
    @State private var isValidating: Bool = false
    @AppStorage("cityName") var cityName = "Cupertino"
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Search City", text: $search, onCommit:  {
                        
                    })
                }
            }
                .disabled(isValidating)
                .navigationBarTitle(Text("Add City"))
                .navigationBarItems(trailing: doneButton)
                .listStyle(GroupedListStyle())
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            cityName = search
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }
    }
}
