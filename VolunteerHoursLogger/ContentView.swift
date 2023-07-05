import SwiftUI

struct ContentView: View {
	
	var body: some View {
		
		TabView{
			hoursBrowser()
				.tabItem {
					Image(systemName: "list.dash")
					Text("Logged Activities")
				}
			
			
				
			
			SpreadsheetView()
				.tabItem {
					Image(systemName: "tablecells")
					Text("Spreadsheet")
				}
		}
	}
	
	
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

