//
//  SignupViewController.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/11/22.
//

import Foundation
import UIKit
import RxSwift

class SignupViewController: UIViewController {
    
    var viewModel: SignupViewModelTypes
    
    lazy var emailTextField: UITextField = UITextField()
    lazy var emailErrorLabel: UILabel = UILabel()
    lazy var passwordTextField: UITextField = UITextField()
    lazy var passwordErrorLabel: UILabel = UILabel()
    lazy var confirmPasswordTextField: UITextField = UITextField()
    lazy var confirmErrorLabel: UILabel = UILabel()
    lazy var signupButton: UIButton = UIButton()
    lazy var signinButton: UIButton = UIButton()
    lazy var disposeBag = DisposeBag()
    
    init(viewModel: SignupViewModelTypes) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
