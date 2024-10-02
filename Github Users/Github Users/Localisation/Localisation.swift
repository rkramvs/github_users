//
//  Localisation.swift
//  Github Users
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation
import SwiftUI

extension String {
    func localised() -> String {
        return NSLocalizedString(self, comment: self)
    }

}


