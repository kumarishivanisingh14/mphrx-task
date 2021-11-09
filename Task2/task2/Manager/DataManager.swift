//
//  DataManager.swift
//  task2
//
//  Created by Mphrx on 08/11/21.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    let apiResultRepository = ApiResultRepository()
    
    private init(){}
    
    var listOfCells : [ApiResultStructItem] = []
    //var totalCount = 0
    var isApiLoading: Bool = true

    
    func fetchData(urlString: String, currentCount: Int, completion: @escaping (Int, [ApiResultStructItem]) -> Void) {
        
        listOfCells = apiResultRepository.readSomeRecord(count: currentCount)!
        
        if(listOfCells.isEmpty) {
            HttpUtility.shared.fetchApi(urlString: ApiUrl.firstApi.rawValue) { tc, templist in
                //self.totalCount = tc
                self.listOfCells.append(contentsOf: templist)
                
                self.listOfCells.forEach { temporarylist in
                    self.apiResultRepository.createRecord(result: temporarylist)

                }
                completion(self.listOfCells.count, self.listOfCells)
                            
            }
        } else {
            isApiLoading = false
            completion(listOfCells.count, listOfCells)
        }
        
    }
}
