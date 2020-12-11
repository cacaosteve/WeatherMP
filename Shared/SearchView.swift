import SwiftUI

struct SearchView : View {
    @State private var search: String = ""
    @State private var isValidating: Bool = false
    @AppStorage("zip") var zip = 94024
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Search Zip", text: $search, onCommit:  {
                        
                    })
                }
            }
                .disabled(isValidating)
                .navigationBarTitle(Text("Find by Zip Code"))
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
            zip = Int(search) ?? 0
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }
    }
}
