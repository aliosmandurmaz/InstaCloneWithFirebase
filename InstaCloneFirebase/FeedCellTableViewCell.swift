//
//  FeedCellTableViewCell.swift
//  InstaCloneFirebase
//
//  Created by Ali Osman DURMAZ on 1.04.2022.
//

import UIKit
import Firebase

class FeedCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButton(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            // set data metodundaki merge ifadesi sadece istenilen kısımda(likes) değişiklik yapıp diğer kısımların değişmemesini sağlar
            
        }
    }
}
