//
//  ViewController.swift
//  VkStoryboardUI
//
//  Created by Анатолий Волостных on 16.12.2021.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Жест нажатия
                let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                // Присваиваем его UIScrollVIew
                scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    @IBOutlet var usernameLogin: UITextField!
    @IBOutlet var passwordLogin: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
       
    }
    
    
    
    //скрытие клавиатуры
    @objc func hideKeyboard() {
            self.scrollView?.endEditing(true)
        }

    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
            
            // Получаем размер клавиатуры
            let info = notification.userInfo! as NSDictionary
            let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            
            // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
            self.scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
        }
        
        //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
            // Устанавливаем отступ внизу UIScrollView, равный 0
            let contentInsets = UIEdgeInsets.zero
            scrollView?.contentInset = contentInsets
        }
    
    
    //Что-то с уведомлениеями
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
            // Второе — когда она пропадает
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    //Проверка валидности логина и пароля для перехода на следующий экран
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "goToMain":
            if !checkUser() {
            presentAlert()
            return false
            } else {
            clearDate()
            return true
        }
        default:
            return false
        }
    }
    
    //MARK: private methods
    private func checkUser() -> Bool {
        usernameLogin.text == "admin" && passwordLogin.text == "admin"
    }
    
    //Ошибка при не валидных логине/пароле
    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Incorect Username or password",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Close",
            style: .cancel,
            handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    //Очистка данных
    private func clearDate() {
        usernameLogin.text = ""
        passwordLogin.text = ""
    }
}

