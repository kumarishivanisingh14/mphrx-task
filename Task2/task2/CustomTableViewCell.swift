//
//  CustomTableViewCell.swift
//  task2
//
//  Created by Mphrx on 27/10/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func convertURLToImage(imageURL: String?){
        guard let imgURL = imageURL else{
            return
        }
        
        let url = URL(string: imgURL)
        
        URLSession.shared.dataTask(with: url!) { data, response , error in
            guard let resData = data, error == nil else {
                print("Something went wrong!")
                return
            }
            
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: resData)
            }
        }.resume()

    }
    
    
}
