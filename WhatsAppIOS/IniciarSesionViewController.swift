//
//  ViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func nuevo(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentamos iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
             
                let alerta = UIAlertController(title: "Usuario inexistente", message: "Debe crear un nuevo usuario", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Crear", style: .default, handler: {
                    (UIAlertAction) in
                    self.performSegue(withIdentifier: "registroSegue", sender: nil)
                })
                let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel)
                
                alerta.addAction(btnOk)
                alerta.addAction(btnCancelar)
                self.present(alerta, animated: true, completion: nil)

            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
        }
    }
    
    @IBAction func btnRegistro(_ sender: Any) {
        print("Nueva Cuenta")
        self.performSegue(withIdentifier: "registroSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

