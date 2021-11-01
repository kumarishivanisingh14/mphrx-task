//
//  ResponseStruct.swift
//  task2
//
//  Created by Mphrx on 21/10/21.
//

import Foundation


struct ApiResultStruct: Codable {
    
    let list: [ApiResultStructItem]
}

struct ApiResultStructItem: Codable {

    let _id: String
    let url: String?
    let text: String?
    let type: String
    let baseURL: String?

}

struct CellResultStruct : Codable {
    let _id: String?
    let name: String?
    let text: String?
    let imageURL: String?
}
