//
//  EnviarTextoViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EnviarTextoViewController: UIViewController {

     var dat_user = Usuario()
    
    @IBOutlet weak var mensajeTextField: UITextField!
    @IBOutlet weak var enviarBoton: UIButton!
    
    
    @IBAction func btnEnviar(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let horatotal:String = "\(hour):\(minutes):\(seconds)"
        
        
        let snap = ["from" : Auth.auth().currentUser?.email, "mensaje" : mensajeTextField.text!,"img": "nil", "hora" : horatotal, "fecha" : result]
        Database.database().reference().child("usuarios").child(dat_user.uid).child("snaps").childByAutoId().setValue(snap)
        self.performSegue(withIdentifier: "regresarSegue", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
