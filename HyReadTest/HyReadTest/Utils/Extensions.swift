//
//  Extensions.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/30.
//

import Foundation


extension Book {
    
    init?(dictionary: NSDictionary) {
        guard
            let title = dictionary["title"] as? String,
            let author = dictionary["author"] as? String,
            let coverUrl = dictionary["Cover URL"] as? String,
            let publishDate = dictionary["Publish Date"] as? String,
            let publisher = dictionary["Publisher"] as? String,
            let uuid = dictionary["UUID"] as? Int64,
            let favorite = dictionary["favorite"] as? Bool
        else {
            return nil // 如果缺少必要的屬性，返回 nil
        }
        self.title = title
        self.author = author
        self.coverUrl = coverUrl
        self.publishDate = publishDate
        self.publisher = publisher
        self.uuid = uuid
        self.favorite = favorite
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        return ["title": self.title,
                "author": self.author,
                "Cover URL": self.coverUrl,
                "Publish Date": self.publishDate,
                "Publisher": self.publisher,
                "UUID": self.uuid,
                "favorite": self.favorite]
    }
}


