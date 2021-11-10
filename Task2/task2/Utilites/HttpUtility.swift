//
//  HttpUtility.swift
//  task2
//
//  Created by Mphrx on 03/11/21.
//

import Foundation

class HttpUtility {
    static let shared = HttpUtility()
    
    private init(){}
    
    var apiResult: ApiResultStruct?
    var isApiLoading: Bool = true
    
    func fetchApi(urlString: String, completion: @escaping (Int, [ApiResultStructItem]) -> Void) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let responseData = data, error == nil else {
                print("Something went wrong")
                return
            }
            do {
                self.apiResult = try JSONDecoder().decode(ApiResultStruct.self,from: responseData)
                completion(self.apiResult!.totalCount, self.apiResult!.list)
                self.isApiLoading = false
            }catch{
                print(error)
            }
        }.resume()
    }
}
