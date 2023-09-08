//
//  TodoVC.swift
//  Todo
//
//  Created by Dragon on 19/05/2023.
//

import UIKit
import CoreData

class TodoVC: UIViewController{
    
    var todoArray : [Todo] = []
    
    @IBOutlet weak var todoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoArray = getTodo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name("NewTodoAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editedTodo), name: NSNotification.Name("EditedTodo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletedTodo), name: NSNotification.Name("deletedTodo"), object: nil)
        
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    @objc func newTodoAdded(notification: Notification){
        var todo = notification.userInfo?["New Todo"] as? Todo
        if let todo = todo {
            todoArray.append(todo)
            storeTodo(todo: todo)
            todoTableView.reloadData()
         }
    }
    @objc func editedTodo(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedIndex"] as? Int{
                todoArray[index] = todo
                updateTodo(todo: todo, index: index)
                todoTableView.reloadData()
            }
        }
    }
    @objc func deletedTodo(notification: Notification){
        if let index = notification.userInfo?["index"] as? Int {
            todoArray.remove(at: index)
            deleteTodo(index: index)
            todoTableView.reloadData()

        }
    }
    
}

extension TodoVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitleLabel.text = todoArray[indexPath.row].title
        if todoArray[indexPath.row].image != nil {
            cell.todoImageView.image = todoArray[indexPath.row].image
        }else{
            cell.todoImageView.image = UIImage(named: "1")
        }
        cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = todoArray[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        
        if let  viewController = vc {
            viewController.todo = todo
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension TodoVC{
    
    func storeTodo(todo:Todo){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else { return}
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        
        if let image = todo.image{
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        do{
            try manageContext.save()
            print("done")
        }catch{
            
        }
    }
    
    func getTodo() -> [Todo]{
        var todos:[Todo] = []
        
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{return []}
        let manageContext = appDelegete.persistentContainer.viewContext
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
           let result = try manageContext.fetch(fetchRequst) as! [NSManagedObject]
            
            for manageContext in result{
                let title = manageContext.value(forKey: "title") as? String
                let details = manageContext.value(forKey: "details") as? String
                var todoImage : UIImage? = nil
                if let image = manageContext.value(forKey: "image") as? Data {
                     todoImage = UIImage(data: image)
                }
                let todo = Todo(title: title ?? "",image: todoImage, details: details ?? "")
                todos.append(todo)
            }
        }catch{
            
        }
        return todos
    }
    
    func updateTodo(todo: Todo, index:  Int){
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{return}
        let manageContext = appDelegete.persistentContainer.viewContext
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try manageContext.fetch(fetchRequst) as! [NSManagedObject]
            
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
           try manageContext.save()
            
        }catch{
            
        }
    }
    
    func deleteTodo(index:  Int){
        guard let appDelegete = UIApplication.shared.delegate as? AppDelegate else{return}
        let manageContext = appDelegete.persistentContainer.viewContext
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try manageContext.fetch(fetchRequst) as! [NSManagedObject]
            let deleteTodo = result[index]
            manageContext.delete(deleteTodo)
         
           try manageContext.save()
            
        }catch{
            
        }
    }
}
