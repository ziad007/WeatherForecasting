
import Foundation
import FirebaseDatabase

final class FireBaseStore {
    static let shared = FireBaseStore()
    var ref: DatabaseReference = Database.database().reference()

    func save(for data: NSDictionary, for key: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let deviceID = appDelegate.deviceID
        ref.child("users").child(deviceID).child(key).setValue(data)
    }
}
