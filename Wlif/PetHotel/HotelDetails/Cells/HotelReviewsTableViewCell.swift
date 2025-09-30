//
//  HotelReviewsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 25/08/2025.
//

import UIKit

class HotelReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heigtTableViewConstant: NSLayoutConstraint!
    @IBOutlet weak var reviewsTitle: UILabel!
    
    
    var reviews: [HotelReview] = [] {
        didSet {
            reviewsTitle.text = "Review :".localized
            heigtTableViewConstant.constant = CGFloat(reviews.count * 100)
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setuptableView()
    }

    func setuptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: ReviewsTableViewCell.self)
    }
   
    
}

extension HotelReviewsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as? ReviewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(data: reviews[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}
