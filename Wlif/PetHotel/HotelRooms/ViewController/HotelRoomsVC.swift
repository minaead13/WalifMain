//
//  HotelRoomsVC.swift
//  Wlif
//
//  Created by OSX on 30/07/2025.
//

import UIKit

class HotelRoomsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = RoomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        bind()
        viewModel.getHotelRooms()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: HotelRoomTableViewCell.self)
    }
    
    func bind() {
        viewModel.onRoomsListFetched = { [weak self] rooms in
            self?.tableView.reloadData()
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
}


extension HotelRoomsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomTableViewCell", for: indexPath) as? HotelRoomTableViewCell else { return UITableViewCell() }
        
        let isSelected = indexPath.row == viewModel.selectedIndex
        cell.containerView?.borderColor = UIColor(hex: isSelected ? "0F0F0F" : "E9E9E9")
        if let data = viewModel.rooms?[indexPath.row] {
            cell.configure(data: data)
            cell.services = data.services ?? []
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row
        tableView.reloadData()
        if let room = viewModel.rooms?[indexPath.row] {
            viewModel.completionHandler?(room)
        }
    }
    
}
