//
//  CDApiResultStructItem+CoreDataProperties.swift
//  task2
//
//  Created by Mphrx on 02/11/21.
//
//

import Foundation
import CoreData


extension CDApiResultStructItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDApiResultStructItem> {
        return NSFetchRequest<CDApiResultStructItem>(entityName: "CDApiResultStructItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var text: String?
    @NSManaged public var type: String?
    @NSManaged public var baseURL: String?
    
    func convert() -> ApiResultStructItem {

        return ApiResultStructItem(_id: self.id!, url: self.url, text: self.text, type: self.type!, baseURL: self.baseURL)
    }

}

extension CDApiResultStructItem : Identifiable {
    
}
