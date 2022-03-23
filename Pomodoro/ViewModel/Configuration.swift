//
//  Configuration.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 22/03/22.
//

import FirebaseFirestore
import UIKit

class Configuration {
    static func save(withUserId id: String, duration: Int, short: Int, long: Int, rounds: Int) -> Bool {
        let firestore: Firestore = Firestore.firestore()
        var success = true
        firestore
            .collection("configurations")
            .document(id)
            .setData([
                "taskDuration": duration as Any,
                "shortPause": short as Any,
                "longPause": long as Any,
                "rounds": rounds as Any
            ], merge: true, completion: { error in
                if error != nil {
                    success = false
                }
            })
        return success
    }
    
    static func get(withUserId id: String, _ completion: @escaping (_ data: [String: Any]?) -> Void) {
        let firestore: Firestore = Firestore.firestore()
        
        firestore
            .collection("configurations")
            .document(id)
            .getDocument { document, error in
                guard let document = document, document.exists else {
                    print("Erro ao ler o banco de dados!")
                    completion(nil)
                    return
                }
                completion(document.data())
            }
    }
}
