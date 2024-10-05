//
//  MemoCell.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/23/24.
//

import UIKit

class MemoCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 타이틀 레이블 설정
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        // 내용 레이블 설정
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .gray
        contentLabel.numberOfLines = 0
        
        // 서브뷰 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        // 제약 조건 설정
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 구분선 색상 및 위치 설정
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        self.backgroundColor = .white // 배경색
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
