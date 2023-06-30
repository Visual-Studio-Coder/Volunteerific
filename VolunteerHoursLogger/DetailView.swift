//
//  DetailView.swift
//  VolunteerHoursLogger
//
//  Created by Vaibhav Satishkumar on 6/26/23.
//

import SwiftUI
import SwiftUIDigitalSignature
import CoreData


struct DetailView: View {
	
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	
	var activity: FetchedResults<Activity>.Element
	
	@State private var activityDate = Date()
	@State private var activityDuties = ""
	@State private var activityHours:Int = 1
	@State private var eventLocation = ""
	@State private var superVisorName = ""
	@State private var superVisorSignature:UIImage? = nil
	
	
	var disableForm: Bool {
		activityDuties.isEmpty || eventLocation.isEmpty || superVisorName.isEmpty || superVisorSignature == nil
		
	}
	
	
	
    var body: some View {
		
			Form {
				Section{
					DatePicker("Date and Time of Activity", selection: $activityDate, in: ...Date())
						.onAppear{
							activityDate = activity.activityDate!
							activityDuties = activity.activityDuties!
							activityHours = Int(activity.activityTotalHours)
							eventLocation = activity.eventLocation!
							superVisorName = activity.supervisorName ?? "amongus"
							superVisorSignature = activity.supervisorSignature!
							
						}
					Stepper("Amount of Hours Volunteering: ^[\(activityHours) Hour](inflect: true)", value: $activityHours, in: 1...24)
						.disabled(true)
				} header: {
					Text("date and time details")
				} footer: {
					Text("Start Time, End Time, Total Hours, and Date of Activity are already accounted for. We've removed redundant info for you.")
				}
				
				Section{
					TextField("Location of Activity", text: $eventLocation)
						.textContentType(.fullStreetAddress)
					Text("List the duties that you performed during your Volunteering:")
					TextArea("Start typing...", text: $activityDuties)
					TextField("Name of Supervisor", text: $superVisorName)
						.textContentType(.name)
					Text("Signature of Supervisor below:")
					SignatureView(availableTabs: [.draw],
								  onSave: { image in
						self.superVisorSignature = image
					}, onCancel: {
						
					})
					if superVisorSignature != nil {
						Image(uiImage: superVisorSignature!)
							.resizable()
							.aspectRatio(contentMode: .fit)
						
					} else {
						
					}
					
					
				} header: {
					Text("Activity Details and Signature")
				} footer: {
					Text("All supervisors should verify the information filled above and sign their name in the box. After completing this, the supervisor should immediately click save.")
				}
				Section{
		
					Button {
				
						DataController().editActivity(activity: activity, supervisorName: superVisorName, activityDate: activityDate, activityDuties: activityDuties, activityHours: Int16(activityHours), eventLocation: eventLocation, superVisorSignature: superVisorSignature!, context: moc)
						
						//hoursBrowser().hoursIsHidden.toggle()
						
						dismiss()
					} label: {
						HStack {
							Spacer()
							Text("Save")
							Spacer()
						}
					}.disabled(disableForm)
						.tint(.blue)
					
					
				}footer: {
					Text("You can still edit some parts of the form or just delete the logged activity itself.")
				}
			}
			.navigationTitle("Edit Activity")
			
			
		
		
		
		
	}
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
