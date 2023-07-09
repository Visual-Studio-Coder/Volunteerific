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
	@State private var activityHours:Double = 1
	@State private var eventLocation = ""
	@State private var superVisorName = ""
	@State private var superVisorSignature:UIImage? = nil
	@State private var hasCompletedForm:Bool = false
	@State private var hasCompletedForm1:Bool = false
	
	@State private var activityMinutesStepper:Int = 0
	@State private var activityHoursStepper:Int = 1
	
	
	var disableForm: Bool {
		activityDuties.isEmpty || eventLocation.isEmpty || superVisorName.isEmpty || superVisorSignature == nil
		
	}
	
	
	
    var body: some View {
		
		if hasCompletedForm{
			Divider()
			Text("You can not edit this form because it has already been signed by the supervisor.")
				.foregroundColor(.red)
				.padding(.horizontal)
		}
			Form {
				Section{
					
					DatePicker("Date and Time of Activity", selection: $activityDate, in: ...Date())
					HStack{
						Text("Time Volunteered:")
						VStack(alignment: .trailing){
							HStack{
								Spacer()
								Text("Hours: \(activityHoursStepper)")
								Stepper("", value: $activityHoursStepper, in: 0...23)
								Spacer()
							}
							
							HStack{
								Spacer()
								Text("Minutes: \(activityMinutesStepper)")
								Stepper("", value: $activityMinutesStepper, in: 0...59)
								Spacer()
							}
							
						}
					}
						.onAppear{
							activityDate = activity.activityDate!
							activityDuties = activity.activityDuties!
							activityHours = Double(activity.activityTotalHours)
							activityHoursStepper = Int((activityHours*60)/60)
							activityMinutesStepper = Int(((activityHours*60).truncatingRemainder(dividingBy: 60)))
							eventLocation = activity.eventLocation!
							superVisorName = activity.supervisorName ?? "amongus"
							superVisorSignature = activity.supervisorSignature ?? UIImage(named: "Image")
							hasCompletedForm = activity.completedForm
							
						}
					//Stepper("Amount of Hours Volunteering: ^[\(activityHours) Hour](inflect: true)", value: $activityHours, in: 1...24)
						
				} header: {
					Text("date and time details")
				} footer: {
					Text("Start Time, End Time, Total Hours, and Date of Activity are already accounted for. We've removed redundant info for you.")
				}.disabled(hasCompletedForm)
				
				Section{
					Text("Location of Activity:")
					TextField("Location of Activity", text: $eventLocation)
						.textContentType(.fullStreetAddress)
					Text("Duties:")
					TextEditor(text: $activityDuties)
					Text("Name of Supervisor:")
					TextField("Name of Supervisor", text: $superVisorName)
						.textContentType(.name)
					Text("Signature of Supervisor below:")
					if !hasCompletedForm{
						SignatureView(availableTabs: [.draw, .image],
									  onSave: { image in
							self.superVisorSignature = image
							hasCompletedForm1.toggle()
						}, onCancel: {
							
						})
					}
					if superVisorSignature != nil {
						if hasCompletedForm1{
							Image(uiImage: superVisorSignature!)
								.resizable()
								.aspectRatio(contentMode: .fit)
						}
						if hasCompletedForm{
							Image(uiImage: superVisorSignature!)
								.resizable()
								.aspectRatio(contentMode: .fit)
						}
					} else {
						
					}
					
					
				} header: {
					Text("Activity Details and Signature")
				} footer: {
					Text("All supervisors should verify the information filled above and sign their name in the box. After completing this, the supervisor should immediately click save.")
				}
				.disabled(hasCompletedForm)
				if !hasCompletedForm{
					Section{
						
						Button {
							hasCompletedForm = hasCompletedForm1
							DataController().editActivity(activity: activity, hasCompletedForm: hasCompletedForm, supervisorName: superVisorName, activityDate: activityDate, activityDuties: activityDuties, activityHours: Double(activityHours), eventLocation: eventLocation, superVisorSignature: superVisorSignature!, context: moc)
							
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
			}
			.navigationTitle("Edit Activity")
			
			
		
		
		
		
	}
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
