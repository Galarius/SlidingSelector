//
//  SlidingSelectorDelegate.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import Foundation

protocol SlidingSelectorDelegate: NSObjectProtocol {
    /**
     Called when item selected in slide selector
     */
    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int)
}
