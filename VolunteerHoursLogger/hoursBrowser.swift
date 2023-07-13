import SwiftUI
import CoreData
import UIKit

	// swiftlint:disable type_body_length
struct HoursBrowser: View {
	@Environment(\.managedObjectContext) var moc
	@FetchRequest(sortDescriptors: [NSSortDescriptor(
		keyPath: \Activity.activityDate,
		ascending: false)]) var activities: FetchedResults<Activity>
	@State private var showingAddScreen = false
	@State public var hoursIsHidden = false
	@State public var listIsHidden = true
	@State public var unverifiedCount = 0
	var sum: Int {
		Int(activities.reduce(0) { $0 + $1.activityTotalHours })
	}
	var body: some View {
		ZStack {
			VStack {
				NavigationView {
					if activities.count == 0 {
						Text("You haven't logged any volunteer activity yet. Tap the \"+\" button or the \"Log Hours\" button to get started")
							.multilineTextAlignment(.center)
							.foregroundColor(.secondary)
							.padding()
							.navigationTitle("Logged Activities")
							.toolbar {
								ToolbarItem(placement: .navigationBarLeading) {
									EditButton()
								}
								ToolbarItem(placement: .navigationBarTrailing) {
									Button {
										showingAddScreen.toggle()
									} label: {
										Label("Log Hours", systemImage: "plus")
									}
								}
							}
							.sheet(isPresented: $showingAddScreen) {
								HoursForm()
							}
					} else {
						VStack {
							if activities.count > 1 {
								Divider()
									.padding(.horizontal)
								HStack {
									Text("\(activities.count) entries")
										.foregroundColor(.gray)
										.padding([.horizontal])
									Spacer()
								}
							}
							List {
								Section {
									ForEach(activities) { activities in
										if !activities.completedForm {
											NavigationLink {
												DetailView(activity: activities)
											} label: {
												HStack {
													let location = activities.eventLocation
													VStack(alignment: .leading, spacing: 3) {
														Text("\(formatDate(activities.activityDate!))")
															.font(.title3)
														HStack {
															Image(systemName: "mappin.and.ellipse")
																.foregroundColor(.secondary)
															Text("\(location ?? "untitled")")
																.font(.subheadline)
																.multilineTextAlignment(.leading)
																.foregroundColor(.secondary)
															Spacer()
														}
														if Int(((activities.activityTotalHours*60).truncatingRemainder(dividingBy: 60))) == 0 {
															HStack {
																Image(systemName: "clock")
																	.foregroundColor(.secondary)
																Text("^[\(Int((activities.activityTotalHours*60)/60)) hour](inflect: true)")
																	.font(.subheadline)
																	.multilineTextAlignment(.leading)
																	.foregroundColor(.secondary)
																Spacer()
															}
														} else {
															HStack {
																Image(systemName: "clock")
																	.foregroundColor(.secondary)
																Text("^[\(Int((activities.activityTotalHours*60)/60)) hour](inflect: true) ^[\(Int(((activities.activityTotalHours*60).truncatingRemainder(dividingBy: 60)))) min](inflect: true)")
																	.font(.subheadline)
																	.multilineTextAlignment(.leading)
																	.foregroundColor(.secondary)
																Spacer()
															}
														}
													}
													if activities.completedForm {
														Spacer()
														Image(systemName: "checkmark.seal.fill")
															.foregroundColor(.green)
															.frame(alignment: .trailing)
															.scaleEffect(1.3)
													}
												}
											}
											.swipeActions(edge: .leading) {
												Button {
													let newActivity = Activity(context: moc)
													newActivity.id = UUID()
													newActivity.activityDate = Date.now
													newActivity.activityDuties = activities.activityDuties
													newActivity.activityTotalHours = activities.activityTotalHours
													newActivity.eventLocation = activities.eventLocation
													newActivity.supervisorName = activities.supervisorName
													newActivity.completedForm = false
												} label: {
													Text("Duplicate")
												}
												.tint(Color(UIColor.systemBlue))
											}
										}
									}
									.onDelete(perform: deleteActivities)
								} header: {
									Text("Unverified/Drafts")
								} footer: {
									Text("The entries under \"unverified\" are activities that have not received a signature yet. You can still edit these activities until you receive a signature.")
								}
								Section {
									ForEach(activities) {activities in
										if activities.completedForm {
											NavigationLink {
												DetailView(activity: activities)
											} label: {
												HStack {
													let location = activities.eventLocation
													VStack(alignment: .leading, spacing: 3) {
														Text("\(formatDate(activities.activityDate!))")
															.font(.title3)
														HStack {
															Image(systemName: "mappin.and.ellipse")
																.foregroundColor(.secondary)
															Text("\(location ?? "untitled")")
																.font(.subheadline)
																.multilineTextAlignment(.leading)
																.foregroundColor(.secondary)
															Spacer()
														}
														if Int(((activities.activityTotalHours*60).truncatingRemainder(dividingBy: 60))) == 0 {
															HStack {
																Image(systemName: "clock")
																	.foregroundColor(.secondary)
																Text("^[\(Int((activities.activityTotalHours*60)/60)) hour](inflect: true)")
																	.font(.subheadline)
																	.multilineTextAlignment(.leading)
																	.foregroundColor(.secondary)
																Spacer()
															}
														} else {
															HStack {
																Image(systemName: "clock")
																	.foregroundColor(.secondary)
																Text("^[\(Int((activities.activityTotalHours*60)/60)) hour](inflect: true) ^[\(Int(((activities.activityTotalHours*60).truncatingRemainder(dividingBy: 60)))) min](inflect: true)")
																	.font(.subheadline)
																	.multilineTextAlignment(.leading)
																	.foregroundColor(.secondary)
																Spacer()
															}
														}
													}
													.onAppear {
														unverifiedCount = activities.completedForm.description.count
													}
													if activities.completedForm {
														Spacer()
														Image(systemName: "checkmark.seal.fill")
															.foregroundColor(.green)
															.frame(alignment: .trailing)
															.scaleEffect(1.3)
													}
												}
												.swipeActions(edge: .leading) {
													Button {
														let newActivity = Activity(context: moc)
														newActivity.id = UUID()
														newActivity.activityDate = Date.now
														newActivity.activityDuties = activities.activityDuties
														newActivity.activityTotalHours = activities.activityTotalHours
														newActivity.eventLocation = activities.eventLocation
														newActivity.completedForm = false
													} label: {
														Text("Duplicate")
													}
													.tint(Color(UIColor.systemBlue))
												}
											}
										}
									}
									.onDelete(perform: deleteActivities)
								} header: {
									Text("Verified")
								} footer: {
									Text("The entries under \"verified\" are activities that have received a signature and can not be edited.")
								}
							}
							.navigationTitle("Logged Activities")
							.toolbar {
								ToolbarItem(placement: .navigationBarLeading) {
									EditButton()
								}
								ToolbarItem(placement: .navigationBarTrailing) {
									Button {
										showingAddScreen.toggle()
									} label: {
										Label("Log Hours", systemImage: "plus")
									}
								}
							}
							.sheet(isPresented: $showingAddScreen) {
								HoursForm()
							}
						}
					}
				}
				.navigationBarTitleDisplayMode(.automatic)
				VStack {
					if sum != 0 {
						Text("You have completed approximately **^[\(sum) hour](inflect: true)** of volunteering")
							.multilineTextAlignment(.center)
						Divider()
							.padding(.horizontal)
					}
					HStack {
						Button {
							showingAddScreen.toggle()
						} label: {
							Label("Log Hours", systemImage: "timer")
								.padding(.horizontal, 35.0)
						}
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.controlSize(.large)
						Menu {
							Button("Filter", action: {showingAddScreen.toggle()})
							Button("Export Logs", action: {showingAddScreen.toggle()})
						} label: {
							Image(systemName: "ellipsis.circle.fill")
						}.tint(Color(.lightGray))
					}
					Divider()
						.padding(.horizontal)
				}
			}
			.ignoresSafeArea(.keyboard)
		}
	}
	func deleteActivities(at offsets: IndexSet) {
		for offset in offsets {
			let activity = activities[offset]
			moc.delete(activity)
		}
		try? moc.save()
	}
	func formatDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM d, yyyy"
		return dateFormatter.string(from: date)
	}
}
struct HoursBrowser_Previews: PreviewProvider {
	static var previews: some View {
		HoursBrowser()
	}
}
extension View {
	@ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
		if hidden {
			if !remove {
				self.hidden()
			}
		} else {
			self
		}
	}
}
