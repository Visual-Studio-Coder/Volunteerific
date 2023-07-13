import Foundation
import CoreData
import UIKit

@objc(Activity)
class Activity: NSManagedObject {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
		return NSFetchRequest<Activity>(entityName: "Activity")
	}
	@NSManaged public var activityDate: Date?
	@NSManaged public var activityDuties: String?
	@NSManaged public var activityTotalHours: Double
	@NSManaged public var eventLocation: String?
	@NSManaged public var id: UUID?
	@NSManaged public var supervisorName: String?
	@NSManaged public var supervisorSignature: UIImage?
	@NSManaged public var completedForm: Bool
}

extension Activity: Identifiable {
}
