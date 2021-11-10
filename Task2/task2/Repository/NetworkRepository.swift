//
//  NetworkRepository.swift
//  task2
//
//  Created by Mphrx on 09/11/21.
//

import Foundation

struct NetworkResultRepository {
    func fetchDataFromApi(completion: @escaping (Int, [ApiResultStructItem]) -> Void){
        HttpUtility.shared.fetchApi(urlString: ApiUrl.firstApi.rawValue) { tc, templist in
            completion(tc, templist)
        }
    }
}
