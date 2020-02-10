//
//  ViewController.swift
//  Flashcards
//
//  Created by Charlie on 2/9/20.
//  Copyright © 2020 Charlie Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var wrongAndCorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wrongAndCorrectLabel.isHidden = true
    }

    @IBAction func didTapOnFlashCard(_ sender: Any) {
        showCorrectAnswer()
    }
    
    @IBAction func wrongAnswerSelected(_ sender: UIButton) {
        let tempColor = sender.backgroundColor
        sender.backgroundColor = UIColor.red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.backgroundColor = tempColor
        }
        checkIfHidden()
    }
    
    @IBAction func correctAnswerSelected(_ sender: UIButton) {
        sender.backgroundColor = UIColor.green
        showCorrectAnswer()
        wrongAndCorrectLabel.isHidden = false
        wrongAndCorrectLabel.text = "Correct!"
        wrongAndCorrectLabel.textColor = UIColor.green
    }
}

//MARK: - Answer Methods
extension ViewController {
    func showCorrectAnswer() {
        frontLabel.isHidden = !frontLabel.isHidden
    }
}

//MARK: - Wrong And Correct Label Methods
extension ViewController {
    func checkIfHidden() {
        if wrongAndCorrectLabel.isHidden {
            wrongAndCorrectLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.wrongAndCorrectLabel.isHidden = true
            }
        }
    }
}


