//
//  DetailsVC.swift
//  Todo
//
//  Created by Dragon on 20/05/2023.
//

import UIKit

class DetailsVC: UIViewController {
    var todo:Todo!
    var index:Int!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var todoNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Todo Details"
        todoNameLabel.text = todo.title
        if todo.image != nil {
            detailsImageView.image = todo.image
        }else{
            detailsImageView.image = UIImage(named: "1")
        }
        detailsLabel.text = todo.details
    }
    
    @IBAction func editButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC
        
        if let viewController = vc {
            viewController.isCreate = false
            viewController.todo = todo
            viewController.editedIndex = index
            
            hidesBottomBarWhenPushed
            navigationController?.pushViewController(viewController, animated: true)
        }
       
    }
    
    @IBAction func deleteButton(_ sender: Any) {
       
        let alert = UIAlertController(title: "Delete Todo", message: "Are you sure you want to delete this Todo!", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
        let confirmAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("deletedTodo"), object: nil,userInfo: ["index":self.index])
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
}
