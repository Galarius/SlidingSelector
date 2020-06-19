//
//  SlidingSelectorDataSource.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import Foundation

protocol SlidingSelectorDataSource: NSObjectProtocol {
    /**
     Number of items that will be displayed in slide selector.

     This control is convinient for only a small number of elements.
     The maximum number of elements is defined in `GSMaximumNumberOfElements` which is equal to 25 by default.
     */
    func numberOfItemsInSlideSelector(_ selector: SlidingSelectorViewController!) -> Int
    /**
     Title for each item
     */
    func slideSelector(_ selector: SlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String
}
