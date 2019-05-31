//
//  ElegirUsuarioTextoViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class ElegirUsuarioTextoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var usuario = Usuario()
    var imageURL = ""
    var descrip = ""
    var imagenID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate=self
        listaUsuarios.dataSource=self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)

            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email" ] as! String
            usuario.img = (snapshot.value as! NSDictionary)["photoURL" ] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        cell.imageView?.sd_setImage(with: URL(string: usuario.img), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usuario = usuarios[indexPath.row]
        performSegue(withIdentifier: "enviarMensajeSegue", sender: usuario)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! EnviarTextoViewController
        siguienteVC.dat_user = usuario
        
    }

}
