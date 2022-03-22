//
//  RegisterVC.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 21/03/22.
//

import UIKit

class RegisterVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    
    // MARK: Actions
    @IBAction func addNewUser(_ sender: Any) {
        guard let email = emailField.text else {
            print("Preencha seu email!")
            return
        }
        guard let password = passwordField.text else {
            print("Preencha a senha!")
            return
        }
        guard let rePassword = rePasswordField.text else {
            print("Preencha a confirmação da sua senha!")
            return
        }
        
        if password != rePassword {
            print("A senha não confere!")
            return
        }
        Users().add(withEmail: email, password: password)
    }
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Layout Methods
    func setup() {
        createGradient()
    }
    
    func createGradient() {
        let background = GradientColor.createGradient(bounds: view.bounds)
        view.layer.insertSublayer(background, at: 0)
    }
}
