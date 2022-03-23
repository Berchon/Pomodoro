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
    static func add(withEmail email: String, password: String) {
        let auth: Auth = Auth.auth()
        let firestore: Firestore = Firestore.firestore()
        auth.createUser(withEmail: email, password: password) { dataResult, error in
            if error == nil {
                print("Usuário cadastrado com sucesso!")
            }
            else {
                print("Erro ao cadastrar usuário!")
            }
        }
    }
    
    static func login(withEmail email: String, password: String) {
        let auth: Auth = Auth.auth()
        let firestore: Firestore = Firestore.firestore()
        auth.signIn(withEmail: email, password: password) { user, error in
            if error == nil {
                print("Sucesso ao logar usuário")
            }
            else {
                print("Erro ao logar usuário")
            }
        }
    }
    
    static func logout() -> Bool {
        let auth: Auth = Auth.auth()
        let firestore: Firestore = Firestore.firestore()
        do {
            try auth.signOut()
            return true
        } catch {
            print("Erro ao deslogar usuário!")
            return false
        }
    }
}
