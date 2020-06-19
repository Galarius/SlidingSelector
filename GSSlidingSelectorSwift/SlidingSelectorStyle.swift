//
//  SlidingSelectorStyle.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import Foundation
import UIKit

final class SlidingSelectorStyle {
    private(set) var mainFont: UIFont?
    private(set) var mainColor: UIColor?
    private(set) var holdTouchColor: UIColor?
    private let mainFontSize: CGFloat = 32.0

    static let shared = SlidingSelectorStyle()

    private init() {
        mainColor = UIColor(red: 240/255.0, green: 235/255.0, blue: 180/255.0, alpha: 1.0)
        holdTouchColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)

        // Check if custom font is installed
        let customFont = "Titillium Web"
        let familyNames = UIFont.familyNames
        if familyNames.firstIndex(of: customFont) != nil {
            print("\(customFont) is installed!")
            mainFont = UIFont(name: "titilliumweb-regular", size: mainFontSize)
        } else {
            print("\(customFont) is not installed! Selecting 'Helvetica'...")
            mainFont = UIFont(name: "Helvetica", size: mainFontSize)
        }
    }

    func createTextField(withText text: String?) -> UITextField {
        let tField = UITextField()
        tField.backgroundColor = UIColor.clear
        tField.textAlignment = .center
        tField.textColor = UIColor.black
        tField.returnKeyType = .done
        tField.isUserInteractionEnabled = false
        tField.font = mainFont
        tField.isOpaque = true
        tField.text = text
        return tField
    }
}
