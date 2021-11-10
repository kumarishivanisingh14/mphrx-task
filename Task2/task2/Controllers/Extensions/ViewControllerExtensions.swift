//
//  ViewControllerExtensions.swift
//  task2
//
//  Created by Mphrx on 03/11/21.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listOfCells.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(listOfCells[indexPath.row].type == "Text"){
            return 60
        }
        else if (listOfCells[indexPath.row].type == "WebView"){
            if(webviewContentHeight != 0 ){
                //return webviewContentHeight
                return 200
            }
            else
            {
                return 150
            }
        }
        else {
            return UITableView.automaticDimension
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(listOfCells[indexPath.row].type == "Text" || listOfCells[indexPath.row].type == "ResizableCard"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FixedTableCell",for: indexPath) as! FixedTableCell
            cell.textLabel?.text = listOfCells[indexPath.row].text
            cell.textLabel?.numberOfLines = 0
            cell.isUserInteractionEnabled = true
            
            if listOfCells[indexPath.row].type == "Text"{
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebviewTableCell", for: indexPath) as! WebviewTableCell
            
            cell.webview.navigationDelegate = self
            cell.webview.load(URLRequest(url: URL(string: listOfCells[indexPath.row].url ?? "https://www.google.com")!))
            cell.webview.scrollView.isScrollEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("cell tapped")
        
        let customVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as? CustomViewController
        
        customVC?.baseURL = (listOfCells[indexPath.row].baseURL ?? "")!
        navigationController?.pushViewController(customVC!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let positions = scrollView.contentOffset.y
        if(positions == 0) {
            return
        }
        if (isApiLoading) {
            return
        }
        
        self.tableView.tableFooterView = createSpinnerFooter()
        
        let percent = ((tableView.contentOffset.y + scrollView.frame.size.height - 20) / tableView.contentSize.height)
        if (percent > 0.8) {
                print("Fetch more data")
                fetchApi(urlString: ApiUrl.firstApi.rawValue)
        }
    }
}
