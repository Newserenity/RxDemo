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
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var reset: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObservables()        
    }
    
    func createObservables() {
        let firstHasValue : Observable<Bool> = firstInput.rx.text.orEmpty
            .map{ $0.count > 0 }
            .share(replay: 1)
        
        let secondHasValue : Observable<Bool> = secoundInput.rx.text.orEmpty
            .map{ $0.count > 0 }
            .share(replay: 1)
        
        let firstInputText: Observable<String> = firstInput.rx.text
            .orEmpty
            .map { $0.isEmpty ? "입력하세요" : $0 }
        
        let secoundInputText: Observable<String> = secoundInput.rx.text
            .orEmpty
            .map { $0.isEmpty ? "입력하세요" : $0 }
        
        Observable
            .combineLatest(firstHasValue, secondHasValue)
            .map{ $0 == true && $1 == true } // 둘다 입력이 있는지 여부
            .map{ $0 ? "OK" : "첫번째, 두번째를 입력하세요" }
            .debug("⭐️ combineLatest")
            .bind(to: warningLabel.rx.text)
            .disposed(by: disposeBag)
        
        firstInputText
            .subscribe(onNext: { [weak self] text in
                self?.firstLabel.text = text
            })
            .disposed(by: disposeBag)
        
        secoundInputText
            .subscribe(onNext: { [weak self] text in
                self?.secoundLabel.text = text
            })
            .disposed(by: disposeBag)
        
        firstInput.rx.text.orEmpty
            .map { "\($0.count)" }
            .bind(to: firstCount.rx.text)
            .disposed(by: disposeBag)
        
        secoundInput.rx.text.orEmpty
            .map { "\($0.count)" }
            .bind(to: secoundCount.rx.text)
            .disposed(by: disposeBag)
        
        reset.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.firstInput.text = ""
                self?.secoundInput.text = ""
                self?.firstLabel.text = "입력하세요"
                self?.secoundLabel.text = "입력하세요"
                self?.firstCount.text = "0"
                self?.secoundCount.text = "0"
                self?.warningLabel.text = "첫번째, 두번째를 입력하세요"
            })
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
