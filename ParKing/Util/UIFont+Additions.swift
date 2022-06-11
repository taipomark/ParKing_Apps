//
//  UIFont_Additions.swift
//  ParKing
//
//  Created by Mark Lai on 20/5/2022.
//

import Foundation
import UIKit

//Define UI Font style
extension UIFont {
    
    //Set up standard form for the whole apps
    static let fontBody = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .body)
    static let fontHeadline = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .headline)
    static let fontTitle1 = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .title1)
    static let fontTitle2 = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .title2)
    static let fontCaption1 = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .caption1)
    static let fontCaption2 = UIFontDescriptor
        .preferredFontDescriptor(withTextStyle: .caption2)
    
    
    static let BlackHeader = UIFont(name: "Noto Sans TC Black", size: fontTitle1.pointSize)
    static let BlackHeader2 = UIFont(name: "Noto Sans TC Black", size: fontTitle2.pointSize)
    static let BlackHeadLine = UIFont(name: "Noto Sans TC Black", size: fontHeadline.pointSize)
    static let BlackBody = UIFont(name: "Noto Sans TC Black", size: fontBody.pointSize)
    static let BlackCaption1 = UIFont(name: "Noto Sans TC Black", size: fontCaption1.pointSize)
    static let NormalHeadLine = UIFont(name: "Noto Sans TC Medium", size: fontHeadline.pointSize)
    static let NormalBody = UIFont(name: "Noto Sans TC Medium", size: fontBody.pointSize)
    static let NormalCaption1 = UIFont(name: "Noto Sans TC Medium", size: fontCaption1.pointSize)
    static let NormalCaption2 = UIFont(name: "Noto Sans TC Medium", size: fontCaption2.pointSize)
}
