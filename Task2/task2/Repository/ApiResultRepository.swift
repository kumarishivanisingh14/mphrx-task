//
//  ApiResultRepository.swift
//  task2
//
//  Created by Mphrx on 02/11/21.
//

import Foundation
import CoreData

protocol ApiRepository {
    func createRecord(result : ApiResultStructItem)
    func readRecord() -> [ApiResultStructItem]?
    //func updateRecord()
    //func deleteRecord()
}

struct ApiResultRepository: ApiRepository {
    
    func createRecord(result : ApiResultStructItem) {
        let item = CDApiResultStructItem(context: PersistentStorage.shared.context)
        
        item.id = result._id
        item.text = result.text
        item.type = result.type
        item.url = result.url
        item.baseURL = result.baseURL
        
        PersistentStorage.shared.saveContext()
    }
    
    func readRecord() -> [ApiResultStructItem]? {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDApiResultStructItem.self)
        
        var cellList : [ApiResultStructItem] = []
        
        result?.forEach({ resultItem in
            cellList.append(resultItem.convert())
        })
        
        return cellList
    }
    
    func readSomeRecord(limit : Int = 10, count currentCount: Int) -> [ApiResultStructItem]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDApiResultStructItem")
        
        var list : [ApiResultStructItem] = []
        
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = currentCount

        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest)
            
            for i in result{
                guard let objectData = i as? CDApiResultStructItem else {continue}
                list.append(objectData.convert())
            }
            
            
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return list
    }
}

