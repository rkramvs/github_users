//
//  UserDetailDisplayModel.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation
import UIKit

struct UserDetailDisplayModel: Hashable, Equatable, UIContentConfiguration {
    
    let symbolName: String?
    let attributeString: NSMutableAttributedString?
    
    func makeContentView() -> any UIView & UIContentView {
        UserDetailCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> UserDetailDisplayModel {
        self
    }
    
    static func `default`() -> Self {
        return UserDetailDisplayModel(symbolName: nil, attributeString: nil)
    }
}
