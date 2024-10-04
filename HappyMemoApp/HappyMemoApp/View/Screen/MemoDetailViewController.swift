//
//  MemoDetailViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/30/24.
//

import UIKit

class MemoDetailViewController: UIViewController {
    
    var memo: Memo?
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        navigationItem.title = titleLabel.text
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentLabel)
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16), // 상단 여백
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // 왼쪽 여백
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // 오른쪽 여백
            
            // 콘텐츠 레이블의 상단 간격을 최소화
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),// 타이틀 아래에 바로 붙임
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // 왼쪽 여백
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // 오른쪽 여백
        ])
        
        // 메모 데이터가 있는 경우 레이블 업데이트
        if let memo = memo {
            titleLabel.text = memo.title
            contentLabel.text = memo.content
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
