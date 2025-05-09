import Foundation
import FirebaseFirestoreSwift

enum RestaurantCategory: String, CaseIterable, Identifiable, Codable {
    case casual = "Casual"
    case fancy = "Fancy"
    case fastFood = "FastFood"

    var id: String { rawValue }
}

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let category: RestaurantCategory
    var isFavorite: Bool
    let isAd: Bool
    let adWeight: Int
    let offerURL: String?
}
