//
//  MemoTableViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/19/24.
//

import UIKit
import CoreData

class MemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memolist: [MemoModel] = []
    
    private var categorizedMemos: [(category: Category, memos: [MemoModel])] = []
    
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    let coreDataManager = CoreDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        setupTitleLabel()
        setupTableView()
        setupConstraints()
        
        fetchSavedMemos()
    }
    private func fetchSavedMemos() {
        memolist = coreDataManager.fetchAllMemos() // Core Data에서 메모 리스트 불러오기
        categorizeMemos()
        tableView.reloadData()
    }
    
    private func categorizeMemos() {
        // 카테고리별로 메모를 정렬하고, memolist 순서에 맞춰 카테고리를 유지
        var tempCategorizedMemos: [Category: [MemoModel]] = [:]
        
        for memo in memolist {
            tempCategorizedMemos[memo.category, default: []].append(memo)
        }
        
        // Category 순서대로 딕셔너리를 배열로 변환
        categorizedMemos = Category.orderedCategories.compactMap { category in
            guard let memos = tempCategorizedMemos[category] else { return nil }
            return (category, memos)
        }
    }
    
    private func setupTitleLabel() {
        // 타이틀 설정
        titleLabel.text = "Happy 메모장"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    private func setupTableView() {
        // 테이블 뷰 설정
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    
    @objc private func addMemo() {
        let memoCreateVC = MemoCreateViewController()
        memoCreateVC.memoList = memolist
        memoCreateVC.onSave = { savedMemo in
            self.coreDataManager.createMemo(memo: savedMemo)
            self.fetchSavedMemos()
//            if let index = self.memolist.firstIndex(where: { $0.id == savedMemo.id }) {
//                self.memolist[index] = savedMemo // 수정된 메모 반영
//            } else {
//                self.memolist.append(savedMemo) // 새로운 메모 추가
//            }
//            self.categorizeMemos()
//            self.tableView.reloadData()
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
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // 테이블 뷰 오토레이아웃
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorizedMemos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorizedMemos[section].memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        let memo = categorizedMemos[indexPath.section].memos[indexPath.row]
        
        cell.titleLabel.text = memo.title
        cell.contentLabel.text = memo.content
          
        let separatorView = UIView()
           separatorView.backgroundColor = .gray
           separatorView.translatesAutoresizingMaskIntoConstraints = false
           cell.contentView.addSubview(separatorView)

           NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 0.2),
               separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
               separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
               separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
           ])

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .secondarySystemBackground // 헤더 배경색 설정
        
        let label = UILabel()
        label.text = categorizedMemos[section].category.rawValue // 카테고리 텍스트 설정
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        // 구분선 추가
            let separator = UIView()
            separator.backgroundColor = .lightGray // 구분선 색상 설정
            separator.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(separator)

            // 구분선 오토레이아웃 설정
            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: 0.2), // 구분선 높이 설정
                separator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor), // 왼쪽 정렬
                separator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor), // 오른쪽 정렬
                separator.bottomAnchor.constraint(equalTo: headerView.bottomAnchor) // 헤더 하단에 위치
            ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = categorizedMemos[indexPath.section].memos[indexPath.row]  // 섹션에서 메모를 가져옴
        
        let detailVC = MemoDetailViewController()
        detailVC.memo = selectedMemo // 선택한 메모 전달
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // "편집" 액션 생성
        let editAction = UIContextualAction(style: .normal, title: "편집") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let selectedCategory = self.categorizedMemos[indexPath.section].category
            let memoToEdit = self.categorizedMemos[indexPath.section].memos[indexPath.row]

            // AddView 재활용: 편집 화면을 모달로 표시
            let memoCreateVC = MemoCreateViewController()
            memoCreateVC.memoList = self.memolist
            memoCreateVC.memo = memoToEdit
            memoCreateVC.onSave = { [weak self] updatedMemo in
                guard let self = self else { return }
                self.coreDataManager.updateMemo(memo: updatedMemo)
                self.fetchSavedMemos()
//                if let index = self.memolist.firstIndex(where: { $0.id == updatedMemo.id }) {
//                    self.memolist[index] = updatedMemo
//                    self.categorizeMemos() // 카테고리 다시 구분
//                    self.tableView.reloadData()
//                }
            }
            
            let navigationController = UINavigationController(rootViewController: memoCreateVC)
            self.present(navigationController, animated: true, completion: {
                completionHandler(true) // 액션 완료 후 호출
            })
        }
        
        editAction.backgroundColor = .systemBlue
        
        // "삭제" 액션 생성
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let memosInCategory = self.categorizedMemos[indexPath.section].memos
            guard indexPath.row < memosInCategory.count else {
                completionHandler(false)
                return
            }
            
            // 삭제 확인 알림창
            let alert = UIAlertController(title: "삭제 확인", message: "이 메모를 삭제하시겠습니까?", preferredStyle: .actionSheet)
            let confirmDelete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                
                let memoToDelete = memosInCategory[indexPath.row]
                self.coreDataManager.deleteMemo(memo: memoToDelete)
                self.categorizedMemos[indexPath.section].memos.remove(at: indexPath.row)
                
                if let index = self.memolist.firstIndex(where: { $0.id == memoToDelete.id }) {
                    self.memolist.remove(at: index)
                }
                
                // 섹션이 비어있으면 섹션을 삭제
                if self.categorizedMemos[indexPath.section].memos.isEmpty == true {
                    self.categorizedMemos.remove(at: indexPath.section)
                    self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                } else {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
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
