//
//  ViewController.swift
//  MVVM_app
//
//  Created by Gilles Sagot on 31/08/2022.
//

import UIKit

struct User {
    var name: Observable<String>
}


class Observable<ObservedType> {
    private var _value: ObservedType?
    
    public var value: ObservedType? {
        get {
            return _value
        }
        
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    var valueChanged: ((ObservedType?) -> ())?
    
    init(_ value: ObservedType) {
        _value = value
    }
    
    func bindingChanged(to newValue: ObservedType) {
        _value = newValue
        print("Value is now \(newValue)")
    }
}

class BoundTextField: UITextField {
    var changedClosure: (() -> ())?
    
    @objc func valueChanged() {
        changedClosure?()
    }
    
    
    func bind(to observable: Observable<String>) {
        addTarget(self, action: #selector(BoundTextField.valueChanged), for: .editingChanged)
        
        changedClosure = { [weak self] in
            observable.bindingChanged(to:self?.text ?? "")
        }
        
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet var username: BoundTextField!
    
    var user = User(name: Observable("Paul Hudson"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        username.bind(to: user.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.user.name.value = "Bilbo Baggins"
        }
    }
    
    
}

