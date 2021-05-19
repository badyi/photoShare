//
//  CustomActivity.swift
//  Lec11
//
//  Created by badyi on 20.05.2021.
//

import UIKit

final class CustomActivity: UIActivity {
    var customActivityType: UIActivity.ActivityType
    var activityName: String
    var activityImageName: String
    var customActionWhenTapped: () -> Void
    
    init(title: String, imageName: String, performAction: @escaping () -> Void) {
        self.activityName = title
        self.activityImageName = imageName
        self.customActivityType = UIActivity.ActivityType(rawValue: "Action \(title)")
        self.customActionWhenTapped = performAction
        super.init()
    }
    
    override var activityType: UIActivity.ActivityType? {
        return customActivityType
    }

    override var activityTitle: String? {
        return activityName
    }

    override class var activityCategory: UIActivity.Category {
        return .action
    }

    override var activityImage: UIImage? {
        return UIImage(named: activityImageName)
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        // Nothing to prepare
    }

    override func perform() {
        customActionWhenTapped()
    }
}
