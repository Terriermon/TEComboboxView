//
//  TEComboBoxView.swift
//  TEComboboxView_Example
//
//  Created by drore on 2019/1/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol TEComboBoxViewDelegate: class {
    func comboBoxView(_ comboBoxView: TEComboBoxView, didSelectRowAt row: Int, title: String)
}

extension TEComboBoxViewDelegate {
    func comboBoxView(_ comboBoxView: TEComboBoxView, didSelectRowAt row: Int, title: String) {
        
    }
}

class TEComboBoxView: UIView {
    
    open var icon: UIImage? {
        didSet {
            contentTextField.rightViewMode = .always
            let imageView = UIImageView(image: icon)
            let length = 24
            imageView.frame = CGRect(x: 0, y: 0, width: length, height: length)
            imageView.contentMode = .scaleAspectFit
           
            contentTextField.rightView = imageView
        }
    }
    
    open var placeholder: String? {
        didSet {
            contentTextField.placeholder = placeholder
        }
    }
    
    open var textAlignment: NSTextAlignment {
        didSet {
            contentTextField.textAlignment = textAlignment
        }
    }
    
    open var options:[String]? {
        didSet {
            listView.reloadData()
        }
    }
    
    public var optionSelected:((_ row: Int, _ value: String) -> Void)?
    
    public var delegate: TEComboBoxViewDelegate?
    
    private lazy var contentTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.delegate = self
        return textField
    }()
    
    private lazy var listView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.setBorder()
        return tableView
    }()
    
    private var show = false
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayListView)))
        return view
    }()
    
    override init(frame: CGRect) {
        textAlignment = .center
        super.init(frame: frame)
        
        self.addSubview(contentTextField)
        self.setNeedsUpdateConstraints()
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.setBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        let views = ["textField": contentTextField]
        let textFieldHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField]|", options: .alignAllCenterY, metrics: nil, views: views)
        let textFieldVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: .alignAllCenterX, metrics: nil, views: views)
        self.addConstraints(textFieldHConstraints + textFieldVConstraints)
        super.updateConstraints()
    }
}

extension TEComboBoxView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        displayListView()
        return false
    }
}

extension TEComboBoxView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayListView()
        let text = self.options?[indexPath.row]
        contentTextField.text = text
        if let delegate = self.delegate, let title = text {
            delegate.comboBoxView(self, didSelectRowAt: indexPath.row, title: title)
        }
        
        if let optionSelected = self.optionSelected, let title = text {
            optionSelected(indexPath.row, title)
        }
    }
    
}

extension TEComboBoxView {
    @objc private func displayListView() {
        if !show {
            let keyWindow = UIApplication.shared.keyWindow!
            keyWindow.addSubview(backgroundView)
            keyWindow.addSubview(listView)
            backgroundView.frame = keyWindow.bounds
            
            let convertRect = convert(self.bounds, to: keyWindow)
            var height: CGFloat = 0
            if convertRect.maxY + convertRect.height + CGFloat(self.options?.count ?? 0) * convertRect.height > UIScreen.main.bounds.height {
                height = UIScreen.main.bounds.height - convertRect.maxY
            } else {
                height = CGFloat(self.options?.count ?? 0) * convertRect.height
            }
             self.listView.frame = CGRect(x: convertRect.minX, y: convertRect.maxY, width: convertRect.width, height: height)
            
            self.show = true
        } else {
            self.show = false
            self.listView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
}

internal extension UIView {
    fileprivate func setBorder() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.masksToBounds = true
        layer.cornerRadius = 5
    }
}
