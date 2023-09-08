//
//  NewTodoVC.swift
//  Todo
//
//  Created by Dragon on 24/05/2023.
//

import UIKit

class NewTodoVC: UIViewController {
    
    var isCreate = true
    var todo : Todo?
    var editedIndex:Int?
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreate{
            navigationItem.title = "Edit Todo"
            addButtonOutlet.setTitle("Edit",for: .normal)
            nameTextField.text = todo?.title
            detailsTextView.text = todo?.details
            todoImageView.image = todo?.image
            
        }

    }
    
    @IBAction func addButton(_ sender: Any) {
        if isCreate{
            var todo = Todo(title: nameTextField.text ?? "Unknown Name",image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name("NewTodoAdded"), object: nil,userInfo: ["New Todo" : todo])
            
            let alert = UIAlertController(title: "Done", message: "Todo Added", preferredStyle: UIAlertController.Style.actionSheet)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                self.tabBarController?.selectedIndex = 0
                self.nameTextField.text = nil
                self.detailsTextView.text = nil
            }
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            var todo = Todo(title: nameTextField.text ?? "Unknown Name",image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name("EditedTodo"), object: nil,userInfo: ["editedTodo": todo,"editedIndex": editedIndex])
            let alert = UIAlertController(title: "Done", message: "Todo Edited", preferredStyle: UIAlertController.Style.actionSheet)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
                self.nameTextField.text = nil
                self.detailsTextView.text = nil
            }
            alert.addAction(action)
            present(alert, animated: true)
            
        }
    }
   
    @IBAction func choseImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
}
extension NewTodoVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            todoImageView.image = image
        }
        dismiss(animated: true)
    }
}
