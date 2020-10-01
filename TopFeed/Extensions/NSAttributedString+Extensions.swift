//
//  NSAttributedString+Extensions.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 01.10.2020.
//

import Foundation
import CoreGraphics

extension NSAttributedString {
    func height(for width: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }
}
