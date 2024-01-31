//
//  modelStruct.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/25.
//

import Foundation


struct Book: Codable {
    let author: String
    let coverUrl: String
    let publishDate: String
    let publisher: String
    let title: String
    let uuid: Int64
    var favorite: Bool
}

struct Constants {
    static let KEY_BOOK_FAVORITE = "KEY_BOOK_FAVORITE"
    
    
    
}

