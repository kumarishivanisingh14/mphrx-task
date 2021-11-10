import UIKit
import WebKit

class ViewController: UIViewController {
    
    var listOfCells : [ApiResultStructItem] = []
    var totalCount = 0
    var currentCount = 0
    var isApiLoading: Bool = false
    var webviewContentHeight : CGFloat = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    let cdRepository = CDResultRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path[0])
        let loader = self.loader()
        
        fetchApi(urlString: ApiUrl.firstApi.rawValue)
        
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
        fetchApi(urlString: ApiUrl.firstApi.rawValue)
    }
    
    func fetchApi(urlString: String){
        if(isApiLoading){
            return
        }
        if tableView.refreshControl?.isRefreshing == true{
            print("Refreshing data")
        }
        else {
            print("Fetching data")
        }
        
        self.isApiLoading = true
        DataManager.shared.fetchData(urlString: ApiUrl.firstApi.rawValue, currentCount: currentCount) { tc, templist in
            //self.totalCount = tc
            self.currentCount += templist.count
            self.listOfCells.append(contentsOf: templist)
            self.isApiLoading = false
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.tableFooterView = nil
                self.tableView.reloadData()
            }
        }
    }
}





