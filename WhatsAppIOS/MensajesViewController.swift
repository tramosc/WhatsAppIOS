//
//  MensajesViewController.swift
//  WhatsAppIOS
//
//  Created by MAC06 on 29/05/19.
//  Copyright © 2019 Toni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class MensajesViewController: UIViewController,
    UITableViewDelegate,
UITableViewDataSource  {
    
    
    @IBOutlet weak var tablaSnaps: UITableView!
    
    var snaps:[Snap] = []
    var usuarios:[Usuario] = []
    var usuario = Usuario()
    
    @IBAction func CerrarSesion(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return snaps.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if  snaps.count == 0{
            cell.textLabel?.text = "No tienes snaps"
        }else {
            let snap = snaps[indexPath.row]
            if(snap.img == "nil"){
                cell.textLabel?.text = snap.from
                cell.backgroundColor = UIColor.yellow
            }else{
                cell.textLabel?.text = snap.from
                cell.backgroundColor = UIColor.green
            }
            cell.textLabel?.text = snap.from
            cell.textLabel?.text = snap.mensaje
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "verSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verSnapSegue"{
            let siguienteVC = segue.destination as! VerMensajesViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {
            (snapshot) in
            let snap = Snap()
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.mensaje = (snapshot.value as! NSDictionary)["mensaje"] as! String
            snap.img = (snapshot.value as! NSDictionary)["img"] as! String
            snap.hora = (snapshot.value as! NSDictionary)["hora"] as! String
            snap.fecha = (snapshot.value as! NSDictionary)["fecha"] as! String
            snap.id = snapshot.key
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterator = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })
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
