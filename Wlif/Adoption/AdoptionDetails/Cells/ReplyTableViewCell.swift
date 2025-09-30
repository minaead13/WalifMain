//
//  ReplyTableViewCell.swift
//  Wlif
//
//  Created by OSX on 14/07/2025.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with reply: Reply) {
        replyImageView.setImage(from: reply.image)
        nameLabel.text = reply.name
        dateLabel.text = reply.date
        replyLabel.text = reply.comment
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
