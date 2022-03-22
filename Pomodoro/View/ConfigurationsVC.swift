//
//  ConfigurationsVC.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 14/03/22.
//

import UIKit

protocol ConfigurationsProtocol {
    func updateConfiguration(configurations: Configurations)
}

class ConfigurationsVC: UIViewController {
    
    // MARK: Delegate
    var delegate: ConfigurationsProtocol? = nil
    var configuration: Configurations? = nil

    // MARK: Outlets
    @IBOutlet weak var box: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var shortSlider: UISlider!
    @IBOutlet weak var longSlider: UISlider!
    @IBOutlet weak var roundSlider: UISlider!
    
    // MARK: Actions
    @IBAction func durationSliderAction(_ sender: Any) {
        durationLabel.text = String(Int(durationSlider.value))
    }
    
    @IBAction func shortSliderAction(_ sender: Any) {
        shortLabel.text = String(Int(shortSlider.value))
    }
    
    @IBAction func longSliderAction(_ sender: Any) {
        longLabel.text = String(Int(longSlider.value))
    }
    
    @IBAction func roundSliderAction(_ sender: Any) {
        roundLabel.text = String(Int(roundSlider.value))
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let convertMinToSeconds = 60
        let configurations = Configurations(
            taskDuration: Int(durationSlider.value) * convertMinToSeconds,
            shortPause: Int(shortSlider.value) * convertMinToSeconds,
            longPause: Int(longSlider.value) * convertMinToSeconds,
            rounds: Int(roundSlider.value) * convertMinToSeconds
        )
        if let delegate = self.delegate {
            delegate.updateConfiguration(configurations: configurations)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        guard let config = configuration else {
            navigationController?.popViewController(animated: false)
            return
        }
        print(config.taskDuration / 60)
        durationSlider.value = Float(config.taskDuration / 60)
        shortSlider.value = Float(config.shortPause / 60)
        longSlider.value = Float(config.longPause / 60)
        roundSlider.value = Float(config.rounds)
        
        durationLabel.text = String(Int(durationSlider.value))
        shortLabel.text = String(Int(shortSlider.value))
        longLabel.text = String(Int(longSlider.value))
        roundLabel.text = String(Int(roundSlider.value))
    }
    
    // MARK: Laytout Methods
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
