//
//  LanguageTagView.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//


import UIKit
import UIComponent

class LanguageTagView: UIView {
    var label = UILabel()
    var imageView = UIImageView()
    lazy var stackView = UIStackView(arrangedSubviews: [imageView, label])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.preferredSymbolConfiguration = .init(textStyle: .footnote, scale: .small)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .fill
        
        fill(with: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor?, language: String?) {
        imageView.tintColor = color
        label.text = language
    }
}
