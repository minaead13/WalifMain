//
//  DateSelectionVC.swift
//  Wlif
//
//  Created by OSX on 22/07/2025.
//

import UIKit
import FSCalendar

class DateSelectionVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var completionHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    
    @IBAction func didTapConfirmBtn(_ sender: Any) {
        if let date = dateLabel.text {
            completionHandler?(date)
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension DateSelectionVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateLabel.text = formatDateToArabic(date)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
       
    func maximumDate(for calendar: FSCalendar) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    }
    
    func formatDateToArabic(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}
