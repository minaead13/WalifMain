//
//  AdoptionFilterViewController.swift
//  Wlif
//
//  Created by OSX on 18/07/2025.
//

import UIKit

class AdoptionFilterViewController: UIViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var adoptedPetsCollection: UICollectionView!
    @IBOutlet weak var myAnimalTableView: UITableView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var noDataView: NoDataView!
    
    let viewModel = AdoptionFilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        noDataView.isHidden = true
        setupCollectionView()
        setupTableView()
        setupHeaderActions()
        bind()
        viewModel.getMyAnimalList(isAnimal: true)
        
        self.navigationController?.navigationBar.isHidden = true
        adoptedPetsCollection.isHidden = true
        chatTableView.isHidden = true
        favTableView.isHidden = true
        
        let indexPath = IndexPath(item: 0, section: 0)
        let scrollPosition: UICollectionView.ScrollPosition = LanguageManager.shared.isRightToLeft ? .right : .left
        DispatchQueue.main.async {
            if self.filterCollectionView.numberOfItems(inSection: 0) > 0 {
                self.filterCollectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
            }
        }
    }
    
    func setupCollectionView() {
        filterCollectionView.registerCell(cell: FilterCollectionViewCell.self)
        adoptedPetsCollection.registerCell(cell: AdoptedPetsCollectionViewCell.self)
    }
    
    func setupTableView() {
        myAnimalTableView.registerCell(cell: MyAnimalTableViewCell.self)
        chatTableView.registerCell(cell: HistoryChatTableViewCell.self)
        favTableView.registerCell(cell: FavouriteTableViewCell.self)
    }
    
    func bind() {
        viewModel.onMyAnimalListFetched = { [weak self] services in
            self?.noDataView.isHidden = !(services?.isEmpty ?? true)
            self?.myAnimalTableView.reloadData()
            self?.adoptedPetsCollection.reloadData()
        }
        
        viewModel.onChatsListFetched = { [weak self] chats in
            self?.noDataView.isHidden = !(chats?.isEmpty ?? true)
            self?.chatTableView.reloadData()
        }
        
        viewModel.onFavAnimalListFetched = { [weak self] favs in
            self?.noDataView.isHidden = !(favs?.isEmpty ?? true)
            self?.favTableView.reloadData()
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
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func hideAllSections() {
        myAnimalTableView.isHidden = true
        adoptedPetsCollection.isHidden = true
        chatTableView.isHidden = true
        favTableView.isHidden = true
        noDataView.isHidden = true
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAdoptionViewController") as! AddAdoptionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AdoptionFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filterCollectionView:
            return viewModel.filterArr.count

        case adoptedPetsCollection:
            return viewModel.myAnimalList?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case filterCollectionView:
            
            guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let isSelected = indexPath.row == viewModel.selectedIndex
            cell.filterBackgroundView.backgroundColor = isSelected ? .label : UIColor(hex: "D9D9D9")
            cell.nameLabel.textColor = isSelected ? .white : .label
            let data = viewModel.filterArr[indexPath.row]
            cell.nameLabel.text = data.title
            cell.filterImageView.image = UIImage(named: (isSelected ? data.image : data.imageBlack) ?? "")
            
            return cell

        case adoptedPetsCollection:
            guard let cell = adoptedPetsCollection.dequeueReusableCell(withReuseIdentifier: "AdoptedPetsCollectionViewCell", for: indexPath) as? AdoptedPetsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if let data = viewModel.myAnimalList?[indexPath.row] {
                cell.configure(data: data)
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            viewModel.selectedIndex = indexPath.row
            filterCollectionView.reloadData()
            
            hideAllSections()
            
            switch indexPath.row {
            case 0:
                viewModel.getMyAnimalList(isAnimal: true)
                myAnimalTableView.isHidden = false
                
            case 1:
                viewModel.getMyAnimalList(isAnimal: false)
                adoptedPetsCollection.isHidden = false
               
                
            case 2:
                viewModel.getMessages()
                chatTableView.isHidden = false
                
            case 3:
                viewModel.getFavPets()
                favTableView.isHidden = false
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        switch collectionView {
            
        case filterCollectionView:
            return CGSize(width: 117, height: 34)
            
        case adoptedPetsCollection:
            let spacing: CGFloat = 16
            let width = (collectionView.frame.width - spacing) / 2
            return CGSize(width: width, height: 172)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

extension AdoptionFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case myAnimalTableView:
            return viewModel.myAnimalList?.count ?? 0
            
        case chatTableView:
            return viewModel.chats?.count ?? 0
            
        case favTableView:
            return viewModel.favPets?.count ?? 0
            
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case myAnimalTableView:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnimalTableViewCell", for: indexPath) as? MyAnimalTableViewCell else {return UITableViewCell() }
            if let data = viewModel.myAnimalList?[indexPath.row] {
                cell.configure(data: data)
            }
            
            cell.handleDeleteSelection = { [weak self] in
                self?.viewModel.deleteAdoptionPet(id: self?.viewModel.myAnimalList?[indexPath.row].id ?? 0)
            }
            
            cell.handleSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "AddAdoptionViewController") as! AddAdoptionViewController
                vc.viewModel.petID = self?.viewModel.myAnimalList?[indexPath.row].id ?? 0
                vc.viewModel.isFromEdit = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.selectionStyle = .none
            return cell
            
        case chatTableView:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryChatTableViewCell", for: indexPath) as? HistoryChatTableViewCell else {return UITableViewCell() }
            if let data = viewModel.chats?[indexPath.row] {
                cell.configure(data: data)
            }
            cell.selectionStyle = .none
            return cell
            
        case favTableView:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as? FavouriteTableViewCell else {return UITableViewCell() }
            if let data = viewModel.favPets?[indexPath.row] {
                cell.configure(data: data)
            }
            
            cell.handleSelection = { [weak self] in
                self?.viewModel.deleteFavPets(id: self?.viewModel.favPets?[indexPath.row].id ?? 0)
            }
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case myAnimalTableView, favTableView:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdoptionDetailsViewController") as! AdoptionDetailsViewController
            vc.viewModel.id = self.viewModel.myAnimalList?[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        case chatTableView:
            print("indexPath")
            
        default:
            break
        }
    }
}
