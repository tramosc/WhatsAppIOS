//
//  VerMensajesViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 31/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class VerMensajesViewController: UIViewController {

    @IBOutlet weak var fromtext: UILabel!
    @IBOutlet weak var horaText: UILabel!
    @IBOutlet weak var fechaText: UILabel!
    
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func regresar(_ sender: Any) {
        let alerta = UIAlertController(title: "Eliminando mensaje", message: "Quiere eliminar el mensaje leido", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Si, eliminar", style: .default, handler: {
            (UIAlertAction) in
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap.id).removeValue()
            
            Storage.storage().reference().child("msjImagenes").child("\(self.snap.imagenID).jpg").delete{
                (error) in
                print("Se elimino la imagen correctamente")
                self.navigationController?.popViewController(animated: true)
            }
        })
        let btnCon = UIAlertAction(title: "No, conservar", style: .default, handler: {
            (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        alerta.addAction(btnOk)
        alerta.addAction(btnCon)
        self.present(alerta, animated: true, completion: nil)
        ///////////
    }
    var snap = Snap()
    
    override func viewDidDisappear(_ animated: Bool) {
        let alerta = UIAlertController(title: "Eliminando mensaje", message: "Quiere eliminar el mensaje leido", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Si, eliminar", style: .default, handler: {
            (UIAlertAction) in
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(self.snap.id).removeValue()
            
            Storage.storage().reference().child("msjImagenes").child("\(self.snap.imagenID).jpg").delete{
                (error) in
                print("Se elimino la imagen correctamente")
            }
        })
        let btnCon = UIAlertAction(title: "No, conservar", style: .default, handler: {
            (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        alerta.addAction(btnOk)
        alerta.addAction(btnCon)
        self.present(alerta, animated: true, completion: nil)
        ///////////
        
        
        ////////////////
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblMensaje.text = "Mensaje: " + snap.mensaje
        fromtext.text = "De: " + snap.from
        horaText.text = "Hora: " + snap.hora
        fechaText.text = "Fecha: " + snap.fecha
        
        imageView.sd_setImage(with: URL(string: snap.img), completed: nil)
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
