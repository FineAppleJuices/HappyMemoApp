//
//  SettingDetailViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 10/4/24.
//

import UIKit

class SettingDetailViewController: UIViewController {
    
    enum SettingType {
        case notification
        case theme
        case appInfo
    }
    
    var settingType: SettingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        switch settingType {
        case .notification:
            let notificationSwitch = UISwitch()
            let notificationLabel = UILabel()
            notificationLabel.text = "알림 켜기"
            notificationLabel.textAlignment = .left
            
            // 스택 뷰 생성
            let stackView = UIStackView(arrangedSubviews: [notificationLabel, notificationSwitch])
            stackView.axis = .horizontal
            stackView.spacing = 20
            stackView.alignment = .center
            stackView.distribution = .fill
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 왼쪽 여백
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20) // 오른쪽 여백
            ])
            
        case .theme:
            let themeControl = UISegmentedControl(items: ["라이트", "다크", "시스템"])
            themeControl.selectedSegmentIndex = 2
            setupCenteredView(themeControl, leadingConstant: 20, trailingConstant: -20)
            
        case .appInfo:
            let appInfoLabel = UILabel()
            appInfoLabel.text = "메모 앱 버전 1.0\nⓒ 2023 Your Company"
            appInfoLabel.numberOfLines = 0
            appInfoLabel.lineBreakMode = .byWordWrapping
            appInfoLabel.textAlignment = .center
            
            setupCenteredView(appInfoLabel, leadingConstant: 20, trailingConstant: -20)
            
        case .none:
            break
        }
    }
    
    // 중앙에 배치하는 공통 헬퍼 메서드
    private func setupCenteredView(_ viewToCenter: UIView, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0) {
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewToCenter)
        
        NSLayoutConstraint.activate([
            viewToCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewToCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewToCenter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            viewToCenter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant)
        ])
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
