//
//  EnviarImagenViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import FirebaseAuth

class EnviarImagenViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    var dat_user = Usuario()
    var imageURL = ""
    var descrip = ""
    var imagenID = NSUUID().uuidString
    
  
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mensajeText: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    
    @IBAction func galeriaTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        enviarButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
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
        
        
        let imagenesFolder = Storage.storage().reference().child("msjImagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo ", accion: "Aceptar")
                self.enviarButton.isEnabled = true
                print("Ocurrio un error al subir la imagen: \(error) ")
            }else{
                cargarImagen.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de la imagen", accion: "Cancelar")
                        self.enviarButton.isEnabled = true
                        print("Ocurrio un error al obtener informacion  de imagen \(error)")
                        return
                    }
                    let snap = ["from" : Auth.auth().currentUser?.email ,"mensaje" : self.mensajeText.text! ,"img" : url?.absoluteString, "hora" : horatotal, "fecha" : result, "imagenID": self.imagenID]
                    Database.database().reference().child("usuarios").child(self.dat_user.uid).child("snaps").childByAutoId().setValue(snap)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        
        
        
    }
    
    
/*
    @IBAction func btnEnviar(_ sender: Any) {
        self.enviarButton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo ", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir la imagen: \(error) ")
            }else{
                cargarImagen.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de la imagen", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion  de imagen \(error)")
                        return
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString )
                })
            }
    }
 */
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        enviarButton.isEnabled = false
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
