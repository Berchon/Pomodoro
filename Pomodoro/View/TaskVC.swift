//
//  TaskVC.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 15/03/22.
//

import UIKit

protocol TaskProtocol {
    func addTask(task: String)
}

class TaskVC: UIViewController {
    
    // MARK: Delegate
    var delegate: TaskProtocol?

    // MARK: Outlets
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    
    // MARK: Actions
    
    @IBAction func addButton(_ sender: Any) {
        guard let task = taskTextField.text else { return }
        if task != "" {
            delegate?.addTask(task: task)
            navigationController?.popViewController(animated: true)
            return
        }
        print("Você deve digitar um nome para sua tarefa!")
    }
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Layout Methods
    func setup() {
        createGradient()
        
        box.layer.borderWidth = 2
        box.layer.cornerRadius = 20
        box.layer.borderColor = UIColor.white.cgColor
    }
    
    func createGradient() {
        let background = GradientColor.createGradient(bounds: view.bounds)
        view.layer.insertSublayer(background, at: 0)
    }
}
