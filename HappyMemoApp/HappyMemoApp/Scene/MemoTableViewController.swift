//
//  MemoTableViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/19/24.
//

import UIKit

class MemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memolist: [Memo] = [
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
        
    }
    
    @objc private func addMemo() {
        let memoCreateVC = MemoCreateViewController()
        memoCreateVC.onSave = { [weak self] memo in
            self?.memolist.append(memo)
            self?.tableView.reloadData()
        }
        // 별도의 뷰 계층구조를 따로 설정
        let navigationController = UINavigationController(rootViewController:  memoCreateVC)
        present(navigationController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // "편집" 액션 생성
        let editAction = UIContextualAction(style: .normal, title: "편집") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let memoToEdit = self.memolist[indexPath.row]
            
            // AddView 재활용: 편집 화면을 모달로 표시
            let memoCreateVC = MemoCreateViewController()
            memoCreateVC.memo = memoToEdit
            memoCreateVC.onSave = { [weak self] updatedMemo in
                self?.memolist[indexPath.row] = updatedMemo
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            let navigationController = UINavigationController(rootViewController: memoCreateVC)
            self.present(navigationController, animated: true, completion: {
                completionHandler(true) // 액션 완료 후 호출
            })
        }
        editAction.backgroundColor = .systemBlue
        
        // "삭제" 액션 생성
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            
            // 삭제 확인 알림창
            let alert = UIAlertController(title: "삭제 확인", message: "이 메모를 삭제하시겠습니까?", preferredStyle: .actionSheet)
            let confirmDelete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.memolist.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completionHandler(false) // 취소 후 완료 호출
            }
            
            alert.addAction(confirmDelete)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // "편집, 삭제" 텍스트 커스텀 액션을 구성
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    // delete 수정 불가한 기본 editingStyle 방식
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let alert = UIAlertController(title: "삭제 확인", message: "이 메모를 삭제하시겠습니까?", preferredStyle: .actionSheet)
    //            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
    //                self.memolist.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .automatic)
    //            }
    //            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    //
    //            alert.addAction(deleteAction)
    //            alert.addAction(cancelAction)
    //
    //            present(alert, animated: true, completion: nil)
    //        }
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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
