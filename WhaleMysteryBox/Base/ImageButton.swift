//
//  ImageButton.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/13.
//

import UIKit

class ImageButton: UIImageView {
    var actionHandler : Block?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFit
        self.addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(){
        let tap = UITapGestureRecognizer {[weak self] _ in
            self?.actionHandler?()
        }
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

}
