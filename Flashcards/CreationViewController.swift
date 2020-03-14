//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Charlie on 2/29/20.
//  Copyright © 2020 Charlie Nguyen. All rights reserved.
//

import Foundation
import UIKit

class CreationViewController: UIViewController {
    
    //Cache References
    var flashcardsController: ViewController!
    
    //MARK: - Variables
    var initialQuestion: String?
    var initialAnswer: String?
    
    //MARK: - IBOutlets
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var fakeAnswer1: UITextField!
    @IBOutlet weak var fakeAnswer2: UITextField!
    @IBOutlet weak var fakeAnswer3: UITextField!
    
    //MARK: - IBActions
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        var isExisting = false
        if initialQuestion == questionTextField.text {
            isExisting = true
        }
        
        if (questionTextField.text != "") {
            if (answerTextField.text != "") {
                if (fakeAnswer1.text != "" && fakeAnswer2.text != "" && fakeAnswer3.text != "") {
                    flashcardsController.updateFlashCard(question: questionTextField.text!, answer: answerTextField.text!, fakeAnswer1: fakeAnswer1.text!, fakeAnswer2: fakeAnswer2.text!, fakeAnswer3: fakeAnswer3.text!, isExisting: isExisting);
                    dismiss(animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Missing Answer", message: "You need to an answer for your question", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Missing Text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
}
