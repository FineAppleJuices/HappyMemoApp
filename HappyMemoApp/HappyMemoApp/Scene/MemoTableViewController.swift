//
//  MemoTableViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/19/24.
//

import UIKit

class MemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let memolist: [Memo] = [
    Memo(title: "해피의 쇼핑 목록", content: "우유, 빵, 달걀"),
    Memo(title: "해피의 할 일", content: "운동가기, 책 반납하기"),
    Memo(title: "해피의 회의 안건", content: "프로젝트 진행상황 공유"),
    Memo(title: "해피의 여행 계획", content: "숙소 예약, 관광지 조사")
    ]
    
    let titleLabel = UILabel()
    let tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 타이틀 설정
        titleLabel.text = "해피 메모장"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // 타이틀 오토레이아웃 설정
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 테이블 뷰 설정, 테이블 뷰에 기본 셀 등록
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // 테이블 뷰 오토레이아웃 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 자동 높이 설정
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        setupConstraints()
    }
    
    func setupConstraints() {
        // 타이틀 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60) // 타이틀 높이 설정
        ])
        
        // 테이블 뷰 오토레이아웃
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor), // 타이틀 아래에 위치
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor) // 하단 고정
        ])
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memolist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        let memo = memolist[indexPath.row]
        
        cell.titleLabel.text = memo.title
        cell.contentLabel.text = memo.content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memolist[indexPath.row]
        
        let detailVC = MemoDetailViewController()
        detailVC.memo = selectedMemo // 선택한 메모 전달
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
