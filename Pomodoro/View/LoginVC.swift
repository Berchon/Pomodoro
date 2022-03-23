//
//  Login.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 21/03/22.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    // MARK: Propertiers
    var auth: Auth!
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Actions
    @IBAction func login(_ sender: Any) {
        if let email = emailField.text {
            if let password = passwordField.text {
                emailField.text = ""
                passwordField.text = ""
                Users.login(withEmail: email, password: password)
            }
            else {
                print("Preencha sua Senha!")
            }
        }
        else {
            print("Preencha seu email!")
        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        do {
            try auth.signOut()
        } catch {
            print("Erro ao deslogar usuário!")
        }
    }
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        auth = Auth.auth()
        
        auth.addStateDidChangeListener { autenticacao, usuario in
            if usuario != nil {
                self.performSegue(withIdentifier: "segueAutomaticLogin", sender: nil)
            }
            else {
                print("Usuário não está autenticado!")
            }
        }
    }
    
    // MARK: Layout Methods
    func setup() {
        createGradient()
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func createGradient() {
        let background = GradientColor.createGradient(bounds: view.bounds)
        view.layer.insertSublayer(background, at: 0)
    }
}
