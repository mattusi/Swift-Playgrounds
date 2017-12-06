
//: Only works on iPad i dont know why

/*
 Timer and Stopwathc developed by Matheus Tusi.
 For Nano-Challange #06 - Apple Developer Academy Senac-SP - Swift Playgrounds Program
 */

import UIKit
import PlaygroundSupport

import AVFoundation

var str = "Hello, playground"






class TimerViewController: UIViewController {
    //global variables
    var Button = UIButton(type: .system)
    var ResetBtn = UIButton(type: .system)
    let timePiker = UIDatePicker()
    var totalTime: Int = 0
    var countdownTimer: Timer!
    var timerLabel = UILabel()
    var player: AVAudioPlayer?
    let MusikName = "hatsunemiku-levaspolka"
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        //UIView
        super.viewDidLoad()
        self.title = "Timer"
        
        view = UIView()
        view.backgroundColor = .white
        //Start Button
        Button.setTitle("Start", for: .normal)
        Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        Button.clipsToBounds = true
        Button.addTarget(self, action: #selector(ButtonPressed), for: .touchUpInside)
        view.addSubview(Button)
        //Reset Button
        ResetBtn.setTitle("Reset", for: .normal)
        ResetBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        ResetBtn.clipsToBounds = true
        ResetBtn.addTarget(self, action: #selector(ResetPress), for: .touchUpInside)
        view.addSubview(ResetBtn)
        //timePiker
        timePiker.datePickerMode = .countDownTimer
        timePiker.tag = 2
        view.addSubview(timePiker)
        //Label
        timerLabel.textColor = #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0)
        timerLabel.font = timerLabel.font.withSize(80)
        timerLabel.tag = 3
        timerLabel.text = "00:00:00"
        
        //layout
        
        timePiker.translatesAutoresizingMaskIntoConstraints = false
        Button.translatesAutoresizingMaskIntoConstraints = false
        ResetBtn.translatesAutoresizingMaskIntoConstraints = false
        let NSLayoutArray = [timePiker.topAnchor.constraint(equalTo:view.topAnchor, constant: 20),timePiker.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 20),timePiker.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -20)
            ,Button.topAnchor.constraint(equalTo:timePiker.bottomAnchor, constant: 20),
             Button.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20), ResetBtn.topAnchor.constraint(equalTo:timePiker.bottomAnchor, constant: 20), ResetBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)]
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutArray)
        self.view = view
    }
    //para realocar a interface
    func Layout(timerIsOn : Bool ) {
        if timerIsOn {
            view.addSubview(timerLabel)
            let NSLayoutArray = [timerLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 50),timerLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor, constant: 0)
                ,Button.topAnchor.constraint(equalTo:timerLabel.bottomAnchor, constant: 20),
                 Button.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20), ResetBtn.topAnchor.constraint(equalTo:timerLabel.bottomAnchor, constant: 20), ResetBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)]
            NSLayoutConstraint.activate(NSLayoutArray)
            self.view = view
            
        } else {
            view.addSubview(timePiker)
            
            let NSLayoutArray = [timePiker.topAnchor.constraint(equalTo:view.topAnchor, constant: 20),timePiker.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 20),timePiker.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -20)
                ,Button.topAnchor.constraint(equalTo:timePiker.bottomAnchor, constant: 20),
                 Button.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20), ResetBtn.topAnchor.constraint(equalTo:timePiker.bottomAnchor, constant: 20), ResetBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)]
            NSLayoutConstraint.activate(NSLayoutArray)
            
            self.view = view
        }
    }
    
    //function to play the alarm.
    func playSound() {
        //name of the file you want to play
        guard let url = Bundle.main.url(forResource: MusikName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    @objc func ButtonPressed(sender:UIButton) {
        totalTime = Int(timePiker.countDownDuration)
        timerLabel.text = timeFormatted(Int(timePiker.countDownDuration))
        if let viewWithTag = self.view.viewWithTag(2) {
            //removes time picker from view and updates the layout accordingly.
            viewWithTag.removeFromSuperview()
            Layout(timerIsOn: true)
            
        }
        //starts the timer
       startTimer()
    }
    @objc func ResetPress(sender: UIButton) {
        countdownTimer.invalidate()
        if let viewWithTag = self.view.viewWithTag(3) {
            //adds the time picker back and removes the label
            viewWithTag.removeFromSuperview()
            Layout(timerIsOn: false)
        }
        
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    func endTimer() {
       // countdownTimer.invalidate()
        if let viewWithTag = self.view.viewWithTag(3) {
            //adds the time picker back and removes the label
            viewWithTag.removeFromSuperview()
            Layout(timerIsOn: false)
        }
        //Starts playing the alarm
        playSound()
        //shows an alert
  
        let alertController = UIAlertController(title: "Timer Completo", message:"", preferredStyle: .alert)
        
        // chama a func StopMusic.
        alertController.addAction(UIAlertAction(title: "Okay", style: .default ,handler: StopMusic))
        //mostra o alerta para o usuario
        self.present(alertController, animated: true, completion: nil)
    }
    
    func StopMusic(action: UIAlertAction) {
        player?.stop()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

}

class StopWatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var startBtn = UIButton(type: .system)
    var lapBtn = UIButton(type: .system)
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var timer: Timer!
    var timerLabel = UILabel()
    var status: Bool = false
    var lapTableView: UITableView!
    var lapTimes = [String]()
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        //UIView
        super.viewDidLoad()
        self.title = "StopWatch"
        let resetBtn = UIBarButtonItem(barButtonSystemItem: .refresh , target: self, action: #selector(self.resetPressFunc))

        view = UIView()
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = resetBtn
        //Start Button
        startBtn.setTitle("Start", for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        startBtn.clipsToBounds = true
        startBtn.addTarget(self, action: #selector(ButtonPressed), for: .touchUpInside)
        view.addSubview(startBtn)
        //lap Button
        lapBtn.setTitle("Lap", for: .normal)
        lapBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        lapBtn.clipsToBounds = true
        lapBtn.isEnabled = false
        lapBtn.addTarget(self, action: #selector(lapTimeFunc), for: .touchUpInside)
        view.addSubview(lapBtn)
        
        //Label
        timerLabel.textColor = #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0)
        timerLabel.font = timerLabel.font.withSize(80)
        timerLabel.tag = 3
        timerLabel.text = "00:00:00"
        view.addSubview(timerLabel)
        //Laps TableView
        lapTableView = UITableView()
        lapTableView.delegate = self
        lapTableView.dataSource = self
        view.addSubview(lapTableView)
        //layout
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        lapBtn.translatesAutoresizingMaskIntoConstraints = false
        lapTableView.translatesAutoresizingMaskIntoConstraints = false
        let NSLayoutArray = [timerLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 50),timerLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor, constant: 0)
            ,startBtn.topAnchor.constraint(equalTo:timerLabel.bottomAnchor, constant: 20),
             startBtn.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 20), lapBtn.topAnchor.constraint(equalTo:timerLabel.bottomAnchor, constant: 20), lapBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20), lapTableView.rightAnchor.constraint(equalTo: view.rightAnchor), lapTableView.leftAnchor.constraint(equalTo: view.leftAnchor), lapTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor), lapTableView.topAnchor.constraint(equalTo: startBtn.bottomAnchor, constant: 20)]
        NSLayoutConstraint.activate(NSLayoutArray)
        self.view = view

    }
    
    @objc func ButtonPressed(sender:UIButton) {
        if (status) {
            stopTimer()
            startBtn.setTitle("Start", for: .normal)
            lapBtn.isEnabled = false
        } else {
            //starts the timer
        startTimer()
        startBtn.setTitle("Stop", for: .normal)
        lapBtn.isEnabled = true
        
        }
        if (timerLabel.text != "00:00:00") {
            startBtn.setTitle("Resume", for: .normal)
        
        }
    }
    @objc func resetPressFunc() {
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        status = false
        timerLabel.text = "00:00:00"
        startBtn.setTitle("Start", for: .normal)
        lapTimes.removeAll()
        DispatchQueue.main.async {
            self.lapTableView.reloadData()
        }

    }
    
    @objc func lapTimeFunc(sender: UIButton) {
        lapTimes.append(timerLabel.text!)
        
        DispatchQueue.main.async {
            self.lapTableView.reloadData()
        }
    }
    
    func startTimer() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        status = true
    }
    func stopTimer() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer.invalidate()
        status = false
    }
    
   @objc func updateCounter() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        let milliseconds = UInt8(time * 100)
        
        // Format time vars with leading zero
        timerLabel.text = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
        
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "mycell")
        cell.textLabel?.text="\(lapTimes[indexPath.row])"
        cell.detailTextLabel?.text="Lap \(indexPath.row)"
        
        return cell
    }
}
    
    


class TabBarViewController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //iten 1
        let timerViewController = UINavigationController(rootViewController: TimerViewController())
        
        let tabBarItemTimer = UITabBarItem(title: "Timer", image: nil, tag: 1)
        timerViewController.tabBarItem = tabBarItemTimer
        //iten 2
        let stopWatchViewController = UINavigationController(rootViewController: StopWatchViewController())
        
        let tabBarItemStopWatch = UITabBarItem(title: "Stop Watch", image: nil, tag: 2)
        stopWatchViewController.tabBarItem = tabBarItemStopWatch
        self.viewControllers = [timerViewController, stopWatchViewController]
    }
}

PlaygroundPage.current.liveView = TabBarViewController()
