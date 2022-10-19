//
//  ShoppingListCollectionViewCell.swift
//  ShoppingList
//
//  Created by 이현호 on 2022/10/20.
//

import UIKit
import SnapKit

class ShoppingListCollectionViewCell: UICollectionViewListCell {
    
    let checkButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [checkButton, contentLabel].forEach { contentView.addSubview($0) }
    }
    
    func setConstraints() {
        checkButton.snp.makeConstraints { make in
            make.top.leading.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(checkButton.snp.height)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.bottom.trailing.equalTo(-8)
            make.leading.equalTo(checkButton.snp.trailing).offset(16)
        }
    }
    
}
