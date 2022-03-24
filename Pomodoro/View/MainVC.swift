//
//  ViewController.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 10/03/22.
//

import UIKit
import FirebaseAuth

extension MainVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Picker Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        toggleEnableEditButton()
    }
}

// MARK: Protocols implements
extension MainVC: ConfigurationsProtocol, TaskProtocol, EditTaskProtocol {
    func editTask(task: String, index: Int) {
        pickerData[index] = task
        pickerView.reloadAllComponents()
    }
    
    func updateConfiguration(configurations: Configurations) {
        self.configurations.rounds = configurations.rounds
        self.configurations.longPause = configurations.longPause
        self.configurations.shortPause = configurations.shortPause
        self.configurations.taskDuration = configurations.taskDuration
        self.timeRemaining = configurations.taskDuration

        timerLabel.text = String(configurations.taskDuration / 60)
    }
    
    func addTask(task: String) {
        if pickerData.count == 0 {
            editButton.isEnabled = true
        }
        var numberOfTask = pickerData.count / 2
        
        pickerData.append(task)
        numberOfTask += 1
        
        if numberOfTask % configurations.rounds == 0 {
            pickerData.append("Pausa longa")
        }
        else {
            pickerData.append("Pause curta")
        }
        pickerView.reloadAllComponents()
    }
}

class MainVC: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Outlets
    @IBOutlet weak var heightLawnImageView: NSLayoutConstraint!
    @IBOutlet weak var cloud1Height: NSLayoutConstraint!
    @IBOutlet weak var cloud1Width: NSLayoutConstraint!
    @IBOutlet weak var cloud2Height: NSLayoutConstraint!
    @IBOutlet weak var cloud3Height: NSLayoutConstraint!
    @IBOutlet weak var cloud4Height: NSLayoutConstraint!
    @IBOutlet weak var cloud5Height: NSLayoutConstraint!
    
    @IBOutlet weak var girlBottom: NSLayoutConstraint!
    @IBOutlet weak var girlHeight: NSLayoutConstraint!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timerViewTop: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var restartButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var restartButtonPositionY: NSLayoutConstraint!
    @IBOutlet weak var restartButtonPositionX: NSLayoutConstraint!
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goBackButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var goForwardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var backgroundPicker: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var timerLable: UILabel!
    
    // MARK: Properties
    var pickerData: [String] = []
    let convertSecToMin = 60
    var isPausedButtonShowing = false
    var isBreak = false
    var timer = Timer()
    var configurations = Configurations(taskDuration: 1500, shortPause: 300, longPause: 900, rounds: 4)
    var timeRemaining = 1500 // in seconds
    var future = Date()
    var circleLayerFront = CAShapeLayer()
    
    var auth: Auth!
    
    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        if Users.logout() {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        if isPausedButtonShowing {
            togglePlayOrPauseButton()
            isPausedButtonShowing = false
            self.deleteButton.isEnabled = true
            timer.invalidate()
            return
        }
        
        if pickerData.count != 0 {
            togglePlayOrPauseButton()
            isPausedButtonShowing = true
            self.deleteButton.isEnabled = false
            
            future = Date().addingTimeInterval(TimeInterval(timeRemaining))
            
            let timerIntervalInSeconds: TimeInterval = 1
            timer = Timer.scheduledTimer(timeInterval: timerIntervalInSeconds, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func goForwardAction(_ sender: Any) {
        if pickerData.count != 0 {
            let currentTaskIndex = pickerView.selectedRow(inComponent: 0)

            if currentTaskIndex != pickerData.count - 1 {
                pickerView.selectRow(currentTaskIndex + 1, inComponent: 0, animated: true)
                toggleEnableEditButton()
                resetTimer()
            }
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        if pickerData.count != 0 {
            let currentTaskIndex = pickerView.selectedRow(inComponent: 0)
            
            if currentTaskIndex != 0 {
                pickerView.selectRow(currentTaskIndex - 1, inComponent: 0, animated: true)
                toggleEnableEditButton()
                resetTimer()
            }
        }
    }
    
    @IBAction func restartAction(_ sender: Any) {
        if pickerData.count != 0 {
            resetTimer()
        }
    }
    
    @IBAction func deleteTasks(_ sender: UIBarButtonItem) {
        pickerData.removeAll()
        pickerView.reloadAllComponents()
        editButton.isEnabled = false
    }
    
    // MARK: Methods
    func resetTimer() {
        var time = configurations.taskDuration
        if pickerData[pickerView.selectedRow(inComponent: 0)] == "Pausa longa" {
            time = configurations.longPause
        }
        
        if pickerData[pickerView.selectedRow(inComponent: 0)] == "Pausa curta" {
            time = configurations.shortPause
        }
        timeRemaining = time
        future = Date().addingTimeInterval(TimeInterval(time))
    }
    
    @objc func step() {
        if timeRemaining <= 0 {
            let currentTaskIndex = pickerView.selectedRow(inComponent: 0)
            if currentTaskIndex == pickerData.count - 1 {
                togglePlayOrPauseButton()
                isPausedButtonShowing = false
                timer.invalidate()
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView.selectRow(currentTaskIndex + 1, inComponent: 0, animated: true)
            }
            resetTimer()
        }
        
        timeRemaining = Int(future.timeIntervalSinceNow.rounded())
        changeSecondsTimer(timeInterval: timeRemaining)
        let getMinutePart = (timeRemaining / 60) % 60
        timerLabel.text = String(getMinutePart)
    }
    
    func changeSecondsTimer(timeInterval: Int) {
        let seconds = timeInterval % 60
        var color = CGColor(red: 242/255, green: 203/255, blue: 5/255, alpha: 1)
        if seconds <= 10 && seconds > 0 {
            color = CGColor(red: 243/255, green: 45/255, blue: 86/255, alpha: 1)
        }
        let timerViewHeight = timerView.bounds.height
        let angularCoef = Double(1 / 30.0)
        let linearCoef = -Double.pi / 2

        let finalAngle = angularCoef * Double(seconds) * Double.pi + linearCoef
        circleLayerFront.strokeColor = color
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (timerViewHeight / 2.0), startAngle: -Double.pi / 2, endAngle: CGFloat(finalAngle), clockwise: true)
        circleLayerFront.path = circularPath.cgPath
    }
    
    func secondsAnimation() {
        let circleLayerBack = createBorderTimer(strokeColor: CGColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1))
        timerView.layer.insertSublayer(circleLayerBack, at: 0)

        circleLayerFront = createBorderTimer(strokeColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        timerView.layer.insertSublayer(circleLayerFront, at: 1)
    }
    
    func createBorderTimer(strokeColor: CGColor) -> CAShapeLayer {
        let viewHeight = view.bounds.height
        let timerViewHeight = timerView.bounds.height
        
        let finalAngle = Double.pi + 1/2 * Double.pi
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (timerViewHeight / 2.0), startAngle: -Double.pi / 2, endAngle: finalAngle, clockwise: true)
        
        let circleLayerBack = CAShapeLayer()
        circleLayerBack.path = circularPath.cgPath
        circleLayerBack.lineWidth = viewHeight / 100
        circleLayerBack.fillColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        circleLayerBack.strokeColor = strokeColor
        circleLayerBack.lineCap = .round
        circleLayerBack.position = CGPoint(x: timerViewHeight / 2.0, y: timerViewHeight / 2.0)
        
        return circleLayerBack
    }
    
    func toggleEnableEditButton() {
        if pickerView.selectedRow(inComponent: 0) % 2 == 0 {
            editButton.isEnabled = true
        }
        else {
            editButton.isEnabled = false
        }
    }
    
    func togglePlayOrPauseButton() {
        let viewHeight = view.bounds.height
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewHeight/25)
        var play = UIImage(systemName: "pause", withConfiguration: largeConfig)
        if isPausedButtonShowing {
            play = UIImage(systemName: "play", withConfiguration: largeConfig)
        }
        playButton.setImage(play, for: .normal)
    }

    // MARK: LifeCycle Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask" {
            if let taskVC = segue.destination as? TaskVC {
                taskVC.delegate = self
            }
        }
        if segue.identifier == "configuration" {
            if let configurationVC = segue.destination as? ConfigurationsVC {
                configurationVC.delegate = self
                configurationVC.configuration = configurations
            }
        }
        if segue.identifier == "editTask" {
            if pickerData.count == 0 {
                print("Não há dados para ser editado!")
                return
            }
            if let editTaskVC = segue.destination as? EditTaskVC {
                editTaskVC.delegate = self
                let index = pickerView.selectedRow(inComponent: 0)
                editTaskVC.currentTaskIndex = index
                editTaskVC.task = pickerData[index]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        secondsAnimation()
        
        pickerView.dataSource = self
        pickerView.delegate = self

        auth = Auth.auth()
        if let loggedUserId = auth.currentUser?.uid {
            Configuration.get(withUserId: loggedUserId) { data in
                if let data = data {
                    let initialConfig = Configurations(
                        taskDuration: data["taskDuration"] as! Int,
                        shortPause: data["shortPause"] as! Int,
                        longPause: data["longPause"] as! Int,
                        rounds: data["rounds"] as! Int
                    )
                    self.updateConfiguration(configurations: initialConfig)
                    self.timeRemaining = initialConfig.taskDuration
                    let getMinutePart = (self.timeRemaining / 60) % 60
                    self.timerLabel.text = String(getMinutePart)
                }
                else {
                    print("Erro ao acessar os dados do usuário!")
                    print("Você será logado com a configuração padrão!")
                }
            }
        }
        else {
            print("Erro ao acessar o Id do usuário!")
            print("Você será logado com a configuração padrão!")
        }
        
        
        let getMinutePart = (timeRemaining / 60) % 60
        timerLabel.text = String(getMinutePart)
    }
    
    
    // MARK: Layout Methods
    func setup() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        createGradient()
        configureLawn()
        configureCloud()
        configureGirl()
        timerViewConfigure()
        configureControlsButtons()
        borderButtonConfigure(button: restartButton)
        configurePicker()
    }
    
    func configurePicker() {
        backgroundPicker.layer.borderWidth = 2
        backgroundPicker.layer.cornerRadius = 20
        backgroundPicker.layer.borderColor = UIColor.white.cgColor
    }
    
    func borderButtonConfigure(button: UIButton) {
        let buttonHeight = button.bounds.height
        button.layer.cornerRadius = buttonHeight / 2
        button.layer.borderWidth = buttonHeight / 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layoutIfNeeded()
    }
    
    func configureControlsButtons() {
        let viewHeight = view.bounds.height
        
        restartButtonHeight.constant = viewHeight / 22
        let position = timerViewHeight.constant / 2 - restartButtonHeight.constant / 2
        restartButtonPositionX.constant = -position
        restartButtonPositionY.constant = -position

        restartButton.layoutIfNeeded()
        
        goBackButtonHeight.constant = viewHeight / 22
        goBackButton.layoutIfNeeded()
        borderButtonConfigure(button: goBackButton)
        
        playButtonHeight.constant = viewHeight / 12
        playButton.layoutIfNeeded()
        borderButtonConfigure(button: playButton)
        
        goForwardHeight.constant = viewHeight / 22
        goForwardButton.layoutIfNeeded()
        borderButtonConfigure(button: goForwardButton)

        let smallConfig = UIImage.SymbolConfiguration(pointSize: viewHeight/50)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewHeight/25)
        
        let restart = UIImage(systemName: "arrow.counterclockwise", withConfiguration: smallConfig)
        let goBack = UIImage(systemName: "backward.end", withConfiguration: smallConfig)
        let play = UIImage(systemName: "play", withConfiguration: largeConfig)
        let goForward = UIImage(systemName: "forward.end", withConfiguration: smallConfig)
        
        restartButton.setImage(restart, for: .normal)
        goBackButton.setImage(goBack, for: .normal)
        playButton.setImage(play, for: .normal)
        goForwardButton.setImage(goForward, for: .normal)
    }
    
    func timerViewConfigure() {
        let viewHeight = view.bounds.height
        
        timerViewTop.constant = viewHeight / 13
        timerViewHeight.constant = viewHeight / 6
        timerLabel.font = timerLabel.font.withSize(viewHeight / 12)
        
        timerView.layer.cornerRadius = timerViewHeight.constant / 2
        
        timerView.layer.shadowColor = UIColor.black.cgColor
        timerView.layer.shadowOpacity = 0.3
        timerView.layer.shadowOffset = CGSize(width: 8, height: 8)
        timerView.layer.shadowRadius = 8
        
        timerView.layer.masksToBounds = false
        timerView.layoutIfNeeded()
    }
    
    func configureCloud() {
        let viewHeight = view.bounds.height
        
        let image1Height = CGFloat(313)
        let image1Width = CGFloat(1005)
        
        let newCloud1Height = viewHeight / CGFloat(30)
        let newCloud1Width = newCloud1Height * (image1Width / image1Height)
        cloud1Height.constant = newCloud1Height
        cloud1Width.constant = newCloud1Width
        
        cloud2Height.constant = viewHeight / CGFloat(35)
        cloud3Height.constant = viewHeight / CGFloat(25)
        cloud4Height.constant = viewHeight / CGFloat(50)
        cloud5Height.constant = viewHeight / CGFloat(75)
        
        view.layoutIfNeeded()
    }
    
    func configureGirl() {
        let viewHeight = view.bounds.height
        let lawnHeight = heightLawnImageView.constant
        
        girlHeight.constant = viewHeight / 3
        girlBottom.constant = lawnHeight / 6
        view.layoutIfNeeded()
    }
    
    func configureLawn() {
        let currentImageWidth = view.bounds.width
        let originalImageWidth = CGFloat(3067)
        let originalImageHeight = CGFloat(1074)
        let newHeightImage = currentImageWidth * (originalImageHeight / originalImageWidth)
        
        heightLawnImageView.constant = newHeightImage
        
        view.layoutIfNeeded()
    }

    func createGradient() {
        let background = GradientColor.createGradient(bounds: view.bounds)
        view.layer.insertSublayer(background, at: 0)
    }

}
