//
//  NoDataView.swift
//  Wlif
//
//  Created by Mina Eid on 23/09/2025.
//

import Lottie
import UIKit

class NoDataView: UIView {
    
    @IBOutlet weak var animationContainer: UIView!
    private var animationView: LottieAnimationView?
    
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
        let view = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        setupAnimation()
        
    }
    private func setupAnimation() {
        animationView = LottieAnimationView(name: "no_data")
        guard let animationView = animationView else { return }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        animationView.frame = bounds
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(animationView)
        
        animationView.play()
    }
}
