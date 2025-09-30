//
//  HotelBookingSelectionDateVC.swift
//  Wlif
//
//  Created by OSX on 30/07/2025.
//

import UIKit
import FSCalendar

class HotelBookingSelectionDateVC: UIViewController {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var completionHandler: ((String, String) -> Void)?
    private var fromDate: Date?
    private var toDate: Date?
    private var isSelectingStartDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    
    @IBAction func didTapConfirmBtn(_ sender: Any) {
        guard let from = fromDate, let to = toDate else { return }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        completionHandler?(formatter.string(from: from), formatter.string(from: to))
        self.dismiss(animated: true)
    }
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension HotelBookingSelectionDateVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.selectedDates.forEach { calendar.deselect($0) }
        
        if isSelectingStartDate {
            fromDate = date
            toDate = nil
            fromLabel.text = formatDateToArabic(date)
            toLabel.text = "--"
            calendar.select(date)
            isSelectingStartDate = false
        } else {
            if let start = fromDate, date >= start {
                toDate = date
                toLabel.text = formatDateToArabic(date)
                
                var currentDate = start
                while currentDate <= date {
                    calendar.select(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                isSelectingStartDate = true
            } else {
                toDate = nil
                toLabel.text = "--"
                isSelectingStartDate = true
            }
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
       
    func maximumDate(for calendar: FSCalendar) -> Date {
        Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    }
    
    func formatDateToArabic(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}
