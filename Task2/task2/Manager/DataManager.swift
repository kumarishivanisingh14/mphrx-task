//
//  DataManager.swift
//  task2
//
//  Created by Mphrx on 08/11/21.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    let cdRepository = CDResultRepository()
    let networkRepository = NetworkResultRepository()
    
    private init(){}
    
    var listOfCells : [ApiResultStructItem] = []
    //var totalCount = 0
    var isApiLoading: Bool = true
    
    func fetchData(urlString: String, currentCount: Int, completion: @escaping (Int, [ApiResultStructItem]) -> Void) {
        
        listOfCells = cdRepository.readSomeRecord(count: currentCount)!
        
        if(listOfCells.isEmpty) {
            networkRepository.fetchDataFromApi{ tc, templist in
                self.listOfCells.append(contentsOf: templist)
                self.listOfCells.forEach { temporarylist in
                    self.cdRepository.createRecord(result: temporarylist)
                }
                completion(self.listOfCells.count, self.listOfCells)
            }
            //self.totalCount = tc
        } else {
            isApiLoading = false
            completion(listOfCells.count, listOfCells)
        }
    }
}
