//
//  editTaskVC.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 19/03/22.
//

import UIKit

protocol EditTaskProtocol {
    func editTask(task: String, index: Int)
}

class EditTaskVC: UIViewController {
    
    // MARK: Delegate
    var delegate: EditTaskProtocol?
    var currentTaskIndex: Int?
    var task: String?

    // MARK: Outlets
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    
    // MARK: Actions
    @IBAction func updateButton(_ sender: Any) {
        guard let task = taskTextField.text else { return }
        if task != "" {
            print()
            delegate?.editTask(task: task, index: index)
            navigationController?.popViewController(animated: true)
            return
        }
        print("Você deve digitar um nome para sua tarefa!")
    }
    
    // MARK: Properties
    var index = 0
    
    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        guard let currencIndex = currentTaskIndex else {
            navigationController?.popViewController(animated: true)
            return
        }
        guard let task = task else {
            navigationController?.popViewController(animated: true)
            return
        }
        taskTextField.text = task
        index = currencIndex
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
