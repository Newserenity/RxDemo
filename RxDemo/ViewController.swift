//
//  ViewController.swift
//  RxDemo
//
//  Created by Jayden Jang on 2023/05/22.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ViewController: UIViewController {

    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstCount: UILabel!
    @IBOutlet weak var firstInput: UITextField!
    
    @IBOutlet weak var secoundLabel: UILabel!
    @IBOutlet weak var secoundCount: UILabel!
    @IBOutlet weak var secoundInput: UITextField!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstInput.rx.text
            .orEmpty
            .bind(to: firstLabel.rx.text)
            .disposed(by: disposeBag)
        
        firstInput.rx.text
            .orEmpty
            .map { $0.count.description }
            .bind(to: firstCount.rx.text)
            .disposed(by: disposeBag)

        secoundInput.rx.text
            .orEmpty
            .bind(to: secoundLabel.rx.text)
            .disposed(by: disposeBag)
        
        secoundInput.rx.text
            .orEmpty
            .map { $0.count.description }
            .bind(to: secoundCount.rx.text)
            .disposed(by: disposeBag)
    }
    
    // override touchesBegan (키보드 내리기)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstInput.resignFirstResponder()
        self.secoundInput.resignFirstResponder()
    }
}

// MARK: - Event Handling
extension ViewController {
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
    }
}
