//
//  String+Extension.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import Foundation
import CryptoKit

extension String {
    var MD5: String {
            let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
            return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
