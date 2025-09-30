//
//  CommentTableViewCell.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var repliesCount: UILabel!
    @IBOutlet weak var tableView: ContentSizedTableView!
    @IBOutlet weak var repliesBtn: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var handleReplySelection: ((String) -> Void)?
    
    var comment: Comment? {
        didSet {
            nameLabel.text = comment?.name
            commentLabel.text = comment?.comment
            repliesCount.text = "\(comment?.repliesCount ?? 0)"
            dateLabel.text = comment?.date
            repliesBtn.isEnabled = !(comment?.replies?.isEmpty ?? true)
            tableView.isHidden = comment?.replies?.isEmpty ?? true
            tableView.reloadData()
            
            if let replies = comment?.replies, !replies.isEmpty {
                let height = CGFloat(60 * replies.count)
                tableViewHeightConstraint.constant = height
            } else {
                tableViewHeightConstraint.constant = 0
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

   
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: ReplyTableViewCell.self)
    }
    
    @IBAction func didTapOpenReplies(_ sender: Any) {
//        tableView.isHidden.toggle()
      //  tableView.reloadData()
        
//        DispatchQueue.main.async {
//            self.tableView.layoutIfNeeded()
//            print("height is \(self.tableView.contentSize.height) ")
//            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
//        }
    }
    
   
    @IBAction func didTapReplyBtn(_ sender: Any) {
        handleReplySelection?(comment?.name ?? "")
    }
    
}

extension CommentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment?.replies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as? ReplyTableViewCell else { return UITableViewCell() }
        
        if let reply = comment?.replies?[indexPath.row] {
            cell.configure(with: reply)
        }
       
        cell.selectionStyle = .none
        return cell
    }
}
