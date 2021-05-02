//
//  MainVC.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import UIKit
import Combine

final class MainVC: UIViewController {
    
    private var disposables: Set<AnyCancellable> = []
    private lazy var demoButton: UIButton = getButton(with: "DEMO")
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.addArrangedSubview(demoButton)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.mLayChainCenterXY()
        demoButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else { return }
            let nextVC: DemoVC = DemoVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }.store(in: &disposables)
    }
    
    // MARK: - Functions
    private func getButton(with title: String) -> UIButton {
        let button: UIButton = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .red
        button.mLayChain(size: CGSize(width: 200, height: 80))
        return button
    }

}
