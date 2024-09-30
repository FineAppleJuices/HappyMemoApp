//
//  MemoCreateViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/30/24.
//

import UIKit

class MemoCreateViewController: UIViewController {
    
    let titleTextField = UITextField()
    let contentTextField = UITextField()
    let saveButton = UIButton(type: .system)
    var onSave: ((Memo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        navigationItem.title = "새 메모"
        
        // 취소 버튼 설정
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        // 저장 버튼 설정
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMemo))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupUI() {
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "제목"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        contentTextField.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        contentTextField.placeholder = ""
        contentTextField.layer.borderWidth = 1.0 // 테두리 두께
        contentTextField.layer.cornerRadius = 5.0 // 모서리 둥글게
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentTextField)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            contentTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            contentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextField.heightAnchor.constraint(equalToConstant: 600) 
        ])
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil) // 모달 닫기
    }
    
    @objc private func saveMemo() {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextField.text, !content.isEmpty else { return }
        
        let newMemo = Memo(title: title, content: content)
        onSave?(newMemo)
        dismiss(animated: true, completion: nil)
    }
}
