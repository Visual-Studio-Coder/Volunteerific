import SwiftUIDigitalSignature
import SwiftUI

struct HoursForm: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.dismiss) var dismiss
	@State private var activityDate = Date()
	@State private var activityDuties = ""
	@State private var activityHours: Double = 1
	@State private var eventLocation = ""
	@State private var superVisorName = ""
	@State private var superVisorSignature: UIImage?
	@State private var hasCompletedForm: Bool = false
	@State private var activityMinutesStepper: Double = 0
	@State private var activityHoursStepper: Int16 = 1
	var disableForm: Bool {
		eventLocation.isEmpty || superVisorName.isEmpty
	}
    var body: some View {
		NavigationView {
			Form {
				Section {
					DatePicker("Date and Time of Activity", selection: $activityDate, in: ...Date())
					HStack {
						Text("Time Volunteered:")
						VStack(alignment: .trailing) {
							HStack {
								Spacer()
								Text("Hours: \(activityHoursStepper)")
								Stepper("", value: $activityHoursStepper, in: 0...23)
								Spacer()
							}
							HStack {
								Spacer()
								Text("Minutes: \(Int(activityMinutesStepper))")
								Stepper("", value: $activityMinutesStepper, in: 0...59)
								Spacer()
							}
						}
					}
				} header: {
					Text("date and time details")
				}
				Section {
					TextField("Location of Activity", text: $eventLocation)
						.textContentType(.fullStreetAddress)
					Text("List the duties that you performed during your Volunteering:")
					TextArea("Start typing...", text: $activityDuties)
					TextField("Name of Supervisor", text: $superVisorName)
						.textContentType(.name)
					Text("Signature of Supervisor below:")
					SignatureView(availableTabs: [.draw, .image],
								  onSave: { image in
						self.superVisorSignature = image
						hasCompletedForm.toggle()
					}, onCancel: {
					})
					if superVisorSignature != nil {
						Image(uiImage: superVisorSignature!)
					}
				} header: {
					Text("Activity Details and Signature")
				} footer: {
					Text("Supervisors should verify the information, sign their name in the box, and immediately click save.")
				}
				Section {
					Button {
						activityHours = Double(Double(activityHoursStepper) + activityMinutesStepper/60)
						let newActivity = Activity(context: moc)
						newActivity.id = UUID()
						newActivity.activityDate = activityDate
						newActivity.activityDuties = activityDuties
						newActivity.activityTotalHours = Double(activityHours)
						newActivity.eventLocation = eventLocation
						newActivity.supervisorSignature = superVisorSignature
						newActivity.supervisorName = superVisorName
						newActivity.completedForm = hasCompletedForm
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
