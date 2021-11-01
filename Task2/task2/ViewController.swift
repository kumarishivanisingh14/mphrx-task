import UIKit
import WebKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate {
    
    var apiResult: ApiResultStruct?
    var isApiLoading: Bool = true
    var webviewContentHeight : CGFloat = 0.0
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let loader = self.loader()
        
        fetchApi(urlString: "https://api.json-generator.com/templates/AqlGwnzXxIHt/data?delay=2000&access_token=hapmwass5t9uis8jenssbqz8ee03vy5zc88hj5iw")
    
        tableView.dataSource = self
        tableView.delegate = self
        
        let fixedCellNib = UINib(nibName: "FixedTableCell", bundle: nil)
        let dynamicCellNib = UINib(nibName: "DynamicTableCell", bundle: nil)
        let webviewCellNib = UINib(nibName: "WebviewTableCell", bundle: nil)
        
        tableView.register(fixedCellNib, forCellReuseIdentifier: "FixedTableCell")
        tableView.register(dynamicCellNib, forCellReuseIdentifier: "DynamicTableCell")
        tableView.register(webviewCellNib, forCellReuseIdentifier: "WebviewTableCell")
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.stopLoader(loader: loader)
        }
        
    }
    
    @objc private func didPullToRefresh(){
        fetchApi(urlString: "https://api.json-generator.com/templates/AqlGwnzXxIHt/data?delay=2000&access_token=hapmwass5t9uis8jenssbqz8ee03vy5zc88hj5iw")
    }
    
    func fetchApi(urlString: String){
        if tableView.refreshControl?.isRefreshing == true{
            print("Refreshing data")
        }
        else {
            print("Fetching data")
            
        }
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            do {
                self.apiResult = try JSONDecoder().decode(ApiResultStruct.self,from:data)
                self.isApiLoading = false
                
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
        
        return (apiResult?.list.count) ?? 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(apiResult?.list[indexPath.row].type == "Text"){
            return 60
        }
        else if (apiResult?.list[indexPath.row].type == "WebView"){
            if(webviewContentHeight != 0 ){
                return webviewContentHeight
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
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(webviewContentHeight != 0)
        {
            return
        }
        webviewContentHeight = webView.scrollView.contentSize.height
        tableView.reloadData()
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(apiResult?.list[indexPath.row].type == "Text" || apiResult?.list[indexPath.row].type == "ResizableCard"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FixedTableCell",for: indexPath) as! FixedTableCell
            cell.textLabel?.text = apiResult?.list[indexPath.row].text
            cell.textLabel?.numberOfLines = 0
            cell.isUserInteractionEnabled = true
            
            if apiResult?.list[indexPath.row].type == "Text"{
                cell.textLabel?.adjustsFontSizeToFitWidth = true
            }
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebviewTableCell", for: indexPath) as! WebviewTableCell
            
            cell.webview.navigationDelegate = self
            cell.webview.load(URLRequest(url: URL(string: apiResult?.list[indexPath.row].url ?? "https://www.google.com")!))
            cell.webview.scrollView.isScrollEnabled = false
            return cell
            
        }
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
       
       let customVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomViewController") as? CustomViewController
       
       customVC?.baseURL = (apiResult?.list[indexPath.row].baseURL ?? "")!
       navigationController?.pushViewController(customVC!, animated: true)
       tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController {
    func loader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Please Wait!", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        alert.view.addSubview(indicator)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}



