//
//  HoursForm.swift
//  VolunteerHoursLogger
//
//  Created by Vaibhav Satishkumar on 6/24/23.
//
import SwiftUIDigitalSignature
import SwiftUI

struct HoursForm: View {
	
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	
	
	@State private var activityDate = Date()
	@State private var activityDuties = ""
	@State private var activityHours:Int = 1
	@State private var eventLocation = ""
	@State private var superVisorName = ""
	@State private var superVisorSignature:UIImage? = nil
	@State private var hasCompletedForm:Bool = false
	

	
	var disableForm: Bool {
		activityDuties.isEmpty || eventLocation.isEmpty || superVisorName.isEmpty //|| superVisorSignature == nil
		
	}
	
    var body: some View {
		NavigationView {
			Form {
				Section{
					DatePicker("Date and Time of Activity", selection: $activityDate, in: ...Date())
					Stepper("Amount of Hours Volunteering: ^[\(activityHours) Hour](inflect: true)", value: $activityHours, in: 1...24)
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
						
					} else {
						
					}
					
					
				} header: {
					Text("Activity Details and Signature")
				} footer: {
					Text("All supervisors should verify the information filled above and sign their name in the box. After completing this, the supervisor should immediately click save.")
				}
				Section{
					
					
					
					Button {
						
						let newActivity = Activity(context: moc)
						
						newActivity.id = UUID()
						newActivity.activityDate = activityDate
						newActivity.activityDuties = activityDuties
						newActivity.activityTotalHours = Int16(activityHours)
						newActivity.eventLocation = eventLocation
						newActivity.supervisorSignature = superVisorSignature
						newActivity.supervisorName = superVisorName
						
						newActivity.hasCompletedForm = hasCompletedForm
						
					
						
						
						try? moc.save()
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
			.navigationTitle("Log Activity")
			
			
		}
		
		
		
    }
}

struct TextArea: View {
	private let placeholder: String
	@Binding var text: String
	
	init(_ placeholder: String, text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}
	
	var body: some View {
		TextEditor(text: $text)
			.background(
				HStack(alignment: .top) {
					text.isBlank ? Text(placeholder) : Text("")
					Spacer()
				}
					.foregroundColor(Color.primary.opacity(0.25))
					.padding(EdgeInsets(top: 0, leading: 4, bottom: 7, trailing: 0))
			)
	}
}

extension String {
	var isBlank: Bool {
		return allSatisfy({ $0.isWhitespace })
	}
}



struct HoursForm_Previews: PreviewProvider {
    static var previews: some View {
        HoursForm()
    }
}
