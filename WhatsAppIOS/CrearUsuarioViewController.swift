//
//  CrearUsuarioViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CrearUsuarioViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var regUsuario: UIButton!
    
    @IBAction func btnCrearUsuario(_ sender: Any) {
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        
        cargarImagen.putData(imagenData!, metadata: nil) {
            (metadata, error) in
            if error != nil {
                
                print("ocurrio un error al subir la imagen \(error)")
            }else{
                cargarImagen.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        return
                    }
                    //self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    print("correcto")
                    
                    Auth.auth().createUser(withEmail: self.txtUsuario.text!, password: self.txtClave.text!, completion: { (user,error) in
                        print("intentemos crear  un nuevo usaurio")
                        if error != nil {
                            print("se presento el siguiente error al crear el usuario: \(error)")
                        }else{
                            print("El usuario fue creado exitosamente")
                            
    Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
    Database.database().reference().child("usuarios").child(user!.user.uid).child("photoURL").setValue(url?.absoluteString)
                            
                            let alerta = UIAlertController(title: "Usuario creado", message: "El usuario se ha creado con exito", preferredStyle: .alert)
                            let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: {
                                (UIAlertAction) in
                                self.performSegue(withIdentifier: "nuevoinicioSegue", sender: nil)
                            })
                            
                            
                            alerta.addAction(btnOk)
                            self.present(alerta, animated: true, completion: nil)
                        }
                    })
                    
                })
            }
        }
        
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        let alerta = UIAlertController(title: "Cancelando  proceso...", message: "Desea cancelar el registro?", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: {
            (UIAlertAction) in
            self.performSegue(withIdentifier: "regresoSegue", sender: nil)
        })
        let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addAction(btnOk)
        alerta.addAction(btnCancelar)
        self.present(alerta, animated: true, completion: nil)
    }
    
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnGaleria(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        regUsuario.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
