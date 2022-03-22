//
//  AddNewUser.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 22/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Users {
    var auth: Auth = Auth.auth()
    var firestore: Firestore = Firestore.firestore()
    
    func add(withEmail email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { dataResult, error in
            if error == nil {
                print("Usuário cadastrado com sucesso!")
            }
            else {
                print("Erro ao cadastrar usuário!")
            }
        }
    }
    
    func login(withEmail email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { user, error in
            if error == nil {
                print("Sucesso ao logar usuário")
            }
            else {
                print("Erro ao logar usuário")
            }
        }
    }
    
    func logout() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            print("Erro ao deslogar usuário!")
            return false
        }
    }
}
