//
//  Hashes.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 15.02.2022.
//

import UIKit
import CommonCrypto

class Hashes: NSObject {

    static func md5(_ string: String) -> String{
        return md5_old(string)
    }
    
//    // Необходим CryptoKit который идет с iOS13 и выше
//    private func md5_new(_ string: String) -> String{
//        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
//        return digest.map { String(format: "%02hhx", $0) }.joined()
//    }
    
    private static func md5_old(_ string: String) -> String{
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
