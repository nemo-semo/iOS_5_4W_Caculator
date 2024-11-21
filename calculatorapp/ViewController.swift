//
//  ViewController.swift
//  calculatorapp
//
//  Created by 네모 on 11/18/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전체 배경을 검은색으로 설정
        self.view.backgroundColor = .black
        
        // 1단계: 수식 표시할 UILabel 설정
        setupLabel()
        
        // 2단계: 계산기 버튼들 생성
        let buttons = createButtons()
        
        // 3단계: 버튼들을 담을 verticalStackView 생성
        let verticalStackView = makeVerticalStackView(buttons)
        
        // verticalStackView를 view에 추가
        self.view.addSubview(verticalStackView)
        
        // AutoLayout 설정
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),  // 수식 라벨 아래 60 떨어지도록
            verticalStackView.widthAnchor.constraint(equalToConstant: 350),  // 버튼 너비
        ])
    }

    // 수식 표시용 UILabel 설정
    func setupLabel() {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.text = "12345"  // 초기 텍스트
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 60)
        self.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    // 버튼을 만드는 함수 (title, action, 배경색을 인자로 받음)
    func makeButton(titleValue: String, action: Selector, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(titleValue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)  // 폰트 설정
        button.backgroundColor = backgroundColor  // 배경색 설정
        button.layer.cornerRadius = 40  // 둥근 버튼 (정사각형이므로, cornerRadius는 한 변의 절반 크기)
        button.clipsToBounds = true  // 내용이 잘리도록 설정
        button.translatesAutoresizingMaskIntoConstraints = false  // AutoLayout 사용
        button.addTarget(self, action: action, for: .touchUpInside)  // 버튼 클릭 시 action 메서드 실행
        
        // AutoLayout으로 버튼 크기 설정 (정사각형으로 설정)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 80),  // 너비 80
            button.heightAnchor.constraint(equalToConstant: 80)  // 높이 80
        ])
        
        return button
    }

    // 버튼을 만드는 함수
    func createButtons() -> [[UIButton]] {
        let buttonRows: [[String]] = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "*"],
            ["AC", "0", "=", "/"]
        ]
        
        var allButtons: [[UIButton]] = []
        
        // 각 버튼을 만들고 배열에 추가
        for row in buttonRows {
            var buttonRow: [UIButton] = []
            for title in row {
                // 연산 버튼인지 확인
                let backgroundColor: UIColor
                let action: Selector
                
                // 연산 버튼은 orange로 설정, 연산에 맞는 action 지정
                if ["+", "-", "*", "/", "AC", "="].contains(title) {
                    backgroundColor = .orange
                    action = #selector(handleOperatorButton(_:))  // 연산자 버튼의 공통 동작
                } else {
                    backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)  // 숫자 버튼의 기본 색상
                    action = #selector(handleNumberButton(_:))  // 숫자 버튼의 공통 동작
                }
                
                // 버튼 생성
                let button = makeButton(titleValue: title, action: action, backgroundColor: backgroundColor)
                buttonRow.append(button)
            }
            allButtons.append(buttonRow)
        }
        
        return allButtons
    }

    // 연산자 버튼 클릭 시 호출될 메서드 (예: +, -, *, /, AC, =)
    @objc func handleOperatorButton(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "") 버튼 클릭됨")
        // 실제 연산 기능을 구현할 위치입니다
    }

    // 숫자 버튼 클릭 시 호출될 메서드 (0~9)
    @objc func handleNumberButton(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "") 버튼 클릭됨")
        // 숫자 버튼의 값을 수식 입력에 반영하는 동작을 구현할 위치입니다
    }

    // verticalStackView 메서드: UIButton 배열을 받아 UIStackView를 생성
    func makeVerticalStackView(_ buttonRows: [[UIButton]]) -> UIStackView {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical  // 세로 방향
        verticalStackView.spacing = 10  // 버튼 사이 간격
        verticalStackView.distribution = .fillEqually  // 버튼 크기 동일하게 분배
        verticalStackView.backgroundColor = .black
        
        // 각 row에 대해 horizontalStackView를 만들고 verticalStackView에 추가
        for buttonRow in buttonRows {
            let horizontalStackView = makeHorizontalStackView(buttonRow)
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        return verticalStackView
    }

    // makeHorizontalStackView 메서드: UIView 배열을 받아 UIStackView를 생성
    func makeHorizontalStackView(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal  // 가로 방향
        stackView.spacing = 10  // 버튼 사이 간격
        stackView.distribution = .fillEqually  // 버튼들 크기 동일하게 분배
        stackView.backgroundColor = .black  // 배경색 설정 (필요 시)
        return stackView
    }
}
