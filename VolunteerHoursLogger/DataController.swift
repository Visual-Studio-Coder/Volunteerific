import CoreData
import Foundation
import UIKit

class DataController:ObservableObject {
	let container = NSPersistentContainer(name: "VolunteerHoursLogger")
	
	init(){
		
		ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTranformer"))
		
		container.loadPersistentStores { description, error in
			if let error = error{
				print("Core Data failed to load: \(error.localizedDescription)")
			}
			
			
		}
	}
	
	
	func save(context: NSManagedObjectContext) {
		do {
			try context.save()
			print("Data saved successfully. WUHU!!!")
		} catch {
				// Handle errors in our database
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
	
	
	func editActivity(
		activity: Activity,
		hasCompletedForm: Bool,
		supervisorName: String,
		activityDate: Date,
		activityDuties: String,
		activityHours: Double,
		eventLocation: String,
		superVisorSignature: UIImage,
		context: NSManagedObjectContext
	
	){
	
		
		//activity.id = UUID()
		activity.supervisorName = supervisorName
		activity.activityDate = activityDate
		activity.activityDuties = activityDuties
		activity.activityTotalHours = Double(activityHours)
		activity.eventLocation = eventLocation
		activity.supervisorSignature = superVisorSignature
		activity.completedForm = hasCompletedForm 
		
		save(context: context)
	}
	
}
