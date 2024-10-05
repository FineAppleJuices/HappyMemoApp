//
//  MemoCreateViewController.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/30/24.
//

import UIKit

class MemoCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue // 각 행에 카테고리 이름 반환
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = Category.allCases[row] // 선택된 카테고리 저장
    }
    
    var memo: Memo?
    var onSave: ((Memo) -> Void)?
    
    let titleTextField = UITextField()
    let contentTextView = UITextView()
    let saveButton = UIButton(type: .system)
    let categoryPicker = UIPickerView()
    var selectedCategory: Category = .work // 기본 선택 카테고리
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        navigationItem.title = memo == nil ? "새 메모" : "메모 편집"
        
        // 취소 버튼 설정
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        // 저장 버튼 설정
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMemo))
        navigationItem.rightBarButtonItem = saveButton
        
        // 기존 메모 내용이 있으면 텍스트 필드와 텍스트 뷰에 설정
        if let memo = memo {
            titleTextField.text = memo.title
            contentTextView.text = memo.content
            selectedCategory = memo.category
        }
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // 기존 메모가 있을 경우, 해당 카테고리로 PickerView를 설정
        if let index = Category.allCases.firstIndex(of: selectedCategory) {
            categoryPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    private func setupUI() {
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "제목"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        contentTextView.layer.borderWidth = 1.0 // 테두리 두께
        contentTextView.layer.cornerRadius = 5.0 // 모서리 둥글게
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentTextView)
        
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryPicker)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 200),
            
            categoryPicker.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 16),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                        
        ])
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil) // 모달 닫기
    }
    
    @objc private func saveMemo() {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty else { return }
        
        let newMemo = Memo(title: title, content: content, category: selectedCategory)
        onSave?(newMemo)
        dismiss(animated: true, completion: nil)
    }
}
