//
//  HeaderView.swift
//  Wlif
//
//  Created by OSX on 01/09/2025.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - Closures
    var onHomeTap: (() -> Void)?
    var onCartTap: (() -> Void)?
    var onSideMenuTap: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
    }
 
    required init?(coder : NSCoder) {
        super.init(coder: coder )
        commit()
    }
    
    private func commit(){
        let view = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: - Actions
    @IBAction func didTapHomeBtn(_ sender: Any) {
        onHomeTap?()
    }
    
    @IBAction func didTapCartBtn(_ sender: Any) {
        onCartTap?()
    }
    
    @IBAction func didTapSideMenuBtn(_ sender: Any) {
        onSideMenuTap?()
    }
}
