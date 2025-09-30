//
//  HistoryChatTableViewCell.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import UIKit

class HistoryChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: ChatModel) {
        userImageView.setImage(from: data.receiver?.image)
        nameLabel.text = data.receiver?.name
        messageLabel.text = data.lastMessage
        dateLabel.text = data.lastMessageAt
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
