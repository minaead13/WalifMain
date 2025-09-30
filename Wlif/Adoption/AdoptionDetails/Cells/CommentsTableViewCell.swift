//
//  CommentsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noOfCommentsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    var handleSendAction: ((_ text: String, _ isReply: Bool, _ parentId: Int) -> Void)?
    var isReply: Bool = false
    var parentId: Int?
    
    var comments: [Comment]? {
        didSet {
            noOfCommentsLabel.text = "(\(comments?.count ?? 0))"
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setupCommentView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: CommentTableViewCell.self)
    }
    
    func setupCommentView() {
        commentView.layer.shadowColor = UIColor.black.cgColor
        commentView.layer.shadowOpacity = 0.25
        commentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        commentView.layer.shadowRadius = 4
        commentView.layer.masksToBounds = false
    }
    
    
    @IBAction func didTapSendBtn(_ sender: Any) {
        let text = commentTextField.text ?? ""
        handleSendAction?(text, isReply, parentId ?? 0)
    }
}

extension CommentsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
        if let comment = comments?[indexPath.row] {
            cell.comment = comment
            self.parentId = comment.id
        }
        
        cell.handleReplySelection = { [weak self] name in
            self?.commentTextField.text = "\(name)  "
            self?.isReply = true
           
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
