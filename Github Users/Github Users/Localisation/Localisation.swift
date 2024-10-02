//
//  Localisation.swift
//  Github Users
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let languageDidChanged = Notification.Name(rawValue: "language.didChange")
}

class LanguageHandler: ObservableObject {
    static var shared = LanguageHandler()
    var bundle: Bundle?
    
    @AppStorage(UserDefaultKeys.selectedLanguage, store: UserDefaults.standard)
    var language: String = "en"
    
    init() {
        if let path = Bundle.main.path(forResource: LanguageHandler.shared.language, ofType: "lproj"), let bundle =  Bundle(path: path)  {
            self.bundle = bundle
        }
    }
}

extension String {
    func localised() -> String {
        guard let bundle = LanguageHandler.shared.bundle else { return self }
        return NSLocalizedString(self, bundle: bundle, comment: self)
    }

}


