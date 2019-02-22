/*!
 * \file GSSlideSelectorStyle.swift
 * \author Galarius
 * \date 22.02.2019
 * \copyright (c) 2019 galarius. All rights reserved.
 */

import Foundation
import UIKit

private let GSMainFontSize: CGFloat = 32.0

@objc public class GSSlidingSelectorStyle : NSObject
{
    @objc var mainFont: UIFont?
    @objc var mainColor: UIColor?
    @objc var holdTouchColor: UIColor?
    
    @objc static let shared = GSSlidingSelectorStyle()
    
    private override init() {
        super.init()
        
        // Check if specific custom fonts are available
        let customFont = "Titillium Web"
        
        // Check if custom font is installed
        let familyNames = UIFont.familyNames
        if familyNames.firstIndex(of: customFont) != nil {
            print("\(customFont) is installed!")
            mainFont = UIFont(name: "titilliumweb-regular", size:GSMainFontSize)
        } else {
            print("\(customFont) is not installed! Selecting 'Helvetica'...")
            mainFont = UIFont(name: "Helvetica", size:GSMainFontSize)
        }
        
        // Setup other style consts
        mainColor = UIColor(red: 240/255.0, green: 235/255.0, blue: 180/255.0, alpha: 1.0)
        holdTouchColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
    }
    
    @objc func createTextField(withText text: String?) -> UITextField {
        let tField = UITextField()
        tField.backgroundColor = UIColor.clear
        tField.textAlignment = .center
        tField.textColor = UIColor.black
        tField.returnKeyType = .done;
        tField.isUserInteractionEnabled = false;
        tField.font = mainFont;
        tField.isOpaque = true;
        tField.text = text;
        return tField;
    }
}
