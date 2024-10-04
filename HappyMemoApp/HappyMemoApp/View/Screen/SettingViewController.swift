//
//  SettingViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 10/4/24.
//

import UIKit

class SettingViewController: UITableViewController {
    
    let settings = [
        ["알림 설정"],
        ["테마 설정"],
        ["앱 정보"]
    ]
    
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "설정"
        
        let topInset: CGFloat = 30 // 원하는 간격 설정
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    // 섹션의 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    // 각 섹션의 행 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    // 셀 생성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = SettingDetailViewController()
        
        switch indexPath.section {
        case 0:
            detailVC.settingType = .notification
        case 1:
            detailVC.settingType = .theme
        case 2:
            detailVC.settingType = .appInfo
        default:
            break
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
