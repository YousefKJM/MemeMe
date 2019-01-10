//
//  MemeStorage.swift
//  MemeMe
//
//  Created by Yousef Majeed on 30/04/1440 AH.
//  Copyright © 1440 YousefKJM. All rights reserved.
//

import UIKit

class MemeStorage: NSObject {
    
    private static var memes = [MemeObject]()
    
    private override init() {
    }
    
    static func getMemes() -> [MemeObject] {
        return memes
    }
    
    static func addMeme(_ meme: MemeObject) {
        memes.append(meme)
    }
    
    static func get(_ position: Int) -> MemeObject {
        return memes[position]
    }
    
    static func getCount() -> Int {
        return memes.count
    }
}
