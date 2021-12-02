import Foundation

public struct LWWElementGraphChronologyDataStateModel<Element: Hashable> {
    
    public let trackingItem: LWWEElementGraphChronologyTrackingItem<Element>
    public let timeStamp: Date = Date()
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(timeStamp.timeIntervalSince1970))
    }
    
}

extension LWWElementGraphChronologyDataStateModel: Hashable {
    
    public static func == (lhs: LWWElementGraphChronologyDataStateModel<Element>, rhs: LWWElementGraphChronologyDataStateModel<Element>) -> Bool {
        return (lhs.timeStamp == rhs.timeStamp) && lhs.trackingItem == rhs.trackingItem
    }
}
