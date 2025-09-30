//
//  OrderHistoryViewController.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var bookTableView: UITableView!
    
    let viewModel = OrderHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        setCollectionView()
        bind()
        viewModel.getOrders()
        bookTableView.isHidden = true
        setupHeaderActions()
    }
    
    func setTableView() {
        ordersTableView.registerCell(cell: OrderHistoryTableViewCell.self)
        bookTableView.registerCell(cell: ClinicAndHotelOrderTableViewCell.self)
    }
    
    func setCollectionView() {
        collectionView.registerCell(cell: FilterCollectionViewCell.self)
    }
    
    func bind() {
        viewModel.onOrderHistoryFetched = { [weak self] services in
            self?.collectionView.reloadData()
            self?.ordersTableView.reloadData()
        }
        
        viewModel.onBookOrderHistoryFetched = { [weak self] services in
            self?.collectionView.reloadData()
            self?.bookTableView.reloadData()
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
    
    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func hideAllSections() {
        ordersTableView.isHidden = true
        bookTableView.isHidden = true
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ordersTableView:
            return viewModel.orderHistory?.data?.count ?? 0
        case bookTableView:
            return viewModel.bookHistory?.data?.count ?? 0
        default:
            return 0
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case ordersTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell", for: indexPath) as? OrderHistoryTableViewCell else { return UITableViewCell() }
            if let data = viewModel.orderHistory?.data?[indexPath.row] {
                cell.configure(order: data)
            }
            cell.selectionStyle = .none
            return cell
        case bookTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicAndHotelOrderTableViewCell", for: indexPath) as? ClinicAndHotelOrderTableViewCell else { return UITableViewCell() }
            if let data = viewModel.bookHistory?.data?[indexPath.row] {
                cell.configure(order: data, index: viewModel.selectedIndex)
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case ordersTableView:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreOrderDetailsViewController") as! StoreOrderDetailsViewController
            vc.viewModel.id = viewModel.orderHistory?.data?[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
            
        case bookTableView:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClinicAndHotelOrderDetailsVC") as! ClinicAndHotelOrderDetailsVC
            vc.viewModel.id = viewModel.bookHistory?.data?[indexPath.row].id
            vc.viewModel.slogan = viewModel.selectedIndex == 1 ? .veterinaryServices : .petHotel
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension OrderHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let isSelected = indexPath.row == viewModel.selectedIndex
        cell.filterBackgroundView.backgroundColor = isSelected ? .label : UIColor(hex: "D9D9D9")
        cell.nameLabel.textColor = isSelected ? .white : .label
        let data = viewModel.filterArr[indexPath.row]
        cell.nameLabel.text = data.title
        cell.filterImageView.image = UIImage(named: (isSelected ? data.image : data.imageBlack) ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.selectedIndex = indexPath.row
        collectionView.reloadData()
        
        hideAllSections()
        
        switch indexPath.row {
        case 0:
            viewModel.getOrders()
            ordersTableView.isHidden = false
            
        case 1:
            viewModel.getBookOrders(slogan: .veterinaryServices)
            bookTableView.isHidden = false
        case 2:
            viewModel.getBookOrders(slogan: .petHotel)
            bookTableView.isHidden = false
            
        case 3:
            bookTableView.isHidden = false
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "IBMPlexSansArabic-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let title = viewModel.filterArr[indexPath.row].title ?? ""
        let textWidth = ceil(title.widthOfString(usingFont: font))
        let horizontalPadding = 30
        let cellWidth = textWidth + CGFloat(horizontalPadding)
        return CGSize(width: cellWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
