//
//  SplashScreen.swift
//  VolunteerHoursLogger
//
//  Created by Vaibhav Satishkumar on 6/28/23.
//

import SwiftUI

struct SplashScreen: View {
	
	@State private var isActive = false
	@State private var size = 0.8
	@State private var opacity = 0.5
	
	@StateObject private var dataController = DataController()
	
	
	
    var body: some View {
		if isActive {
			hoursBrowser()
				.environment(\.managedObjectContext, dataController.container.viewContext)
		} else {
			
			VStack{
				VStack{
					Image("Image")
						.resizable()
						.aspectRatio(contentMode: .fit)
				}
				
				.scaleEffect(size)
				.opacity(opacity)
				.onAppear{
					withAnimation(.easeInOut(duration: 1.2)){
						self.size = 0.9
						self.opacity = 1
					}
				}
			}.onAppear{
				DispatchQueue.main.asyncAfter(deadline: .now()+2) {
					self.isActive = true
				}
				
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(.purple)
			
		}
    }
		
		
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
