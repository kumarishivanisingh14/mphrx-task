//
//  CustomViewController.swift
//  task2
//
//  Created by Mphrx on 27/10/21.
//

import UIKit

class CustomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    var baseURL : String = ""
    var result : [CellResultStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let customCellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(customCellNib, forCellReuseIdentifier: "CustomTableViewCell")
        fetchApi(urlString: baseURL)
    }
    
    func fetchApi(urlString: String){
        result.removeAll()
        if tableView.refreshControl?.isRefreshing == true{
            print("Refreshing data")
        }
        else {
            print("Fetching data")
        }
        
        let finalURL = urlString + "?access_token=hapmwass5t9uis8jenssbqz8ee03vy5zc88hj5iw"
        //print(finalURL)
        
        let url = URL(string: finalURL)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            do {
                self.result = try JSONDecoder().decode([CellResultStruct].self,from:data)
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = result[indexPath.row].name
        cell.descLabel.text = result[indexPath.row].text
        cell.descLabel.adjustsFontSizeToFitWidth = true
        cell.convertURLToImage(imageURL: result[indexPath.row].imageURL)
        return cell
    }
}
