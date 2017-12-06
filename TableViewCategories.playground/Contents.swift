//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


//modelo for TableView
class  Category {
    
    var name: String? //Atributo
    
    init(name: String){ //Constructor where name is parameter
        
        self.name = name
    }
    
    
    
}

class FormViewController: UIViewController {
    
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Nome da Seção:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Nome da Categoria:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sectionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //Set Up UIStackView
        let sectionStackView = UIStackView(frame: self.view.bounds)
        sectionStackView.axis = .horizontal
        sectionStackView.alignment = .fill
        sectionStackView.distribution = .fillEqually
        sectionStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Inserting elements into my section stack view
        
        sectionStackView.addArrangedSubview(sectionLabel)
        sectionStackView.addArrangedSubview(sectionTextField)
        
        //Set Up UIStackView
        let categoryStackView = UIStackView(frame: self.view.bounds)
        categoryStackView.axis = .horizontal
        categoryStackView.alignment = .fill
        categoryStackView.distribution = .fillEqually
        categoryStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Inserting elements into my section stack view
        
        categoryStackView.addArrangedSubview(categoryLabel)
        categoryStackView.addArrangedSubview(categoryTextField)
        
        let formStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 600))
        formStackView.axis = .vertical
        formStackView.alignment = .fill
        formStackView.distribution = .fillProportionally
        formStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let addBtn = UIButton(type: .roundedRect)
        addBtn.setTitle("Salvar", for: .normal)
        addBtn.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        
        formStackView.addArrangedSubview(sectionStackView)
        formStackView.addArrangedSubview(categoryStackView)
        formStackView.addArrangedSubview(addBtn)
        
        self.view.addSubview(formStackView)
        
        
    }
    
    @objc private func saveCategory(){
        let myTableViewController = self.tabBarController?.viewControllers?.first as! MyTableViewController
        
        let section = Int(sectionTextField.text!)
        let categoryName = categoryTextField.text!
        
        myTableViewController.createCategory(section: section!, categoryName: categoryName)
        
        
        print("Foo")
    }
    
}

class MyTableViewController: UITableViewController {

    // DataSource for tableView
    
    var categoryList = [[Category]] () //Declaration for bidimentional array
    
    
    public func createCategory(section: Int, categoryName: String) {
        let newCategory = Category(name: categoryName)
        //best case: section already existis
        while (categoryList.count <= section) {
            categoryList.append([Category]())
        }
        categoryList[section].append(newCategory)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category List"
        
        //Section 0 --> Creation
        categoryList.append ([Category]())
        //Section 1 --> Creation
        categoryList.append([Category]())
        //insert element into section 0
        let category1 = Category(name: "Senac")
        categoryList[0].append(category1)
        //insert elemento into section 1
        let category2 = Category(name: "Hello")
        categoryList[1].append(category2)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Seção: \(section)"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if categoryList[section].count == 0 {
            return 0
        } else  {
            return 50
        }
    }
    
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewLocal = UIView()
        viewLocal.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 30))
        label.text = "Seção \(section)"
        viewLocal.addSubview(label)
        return viewLocal
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        
        let section = indexPath.section
        let row = indexPath.row
        let category = categoryList[section][row]
        
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
}



class MyTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tableViewController = MyTableViewController()
        let tabBarItem1 = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        tableViewController.tabBarItem = tabBarItem1
        
        let formViewController = FormViewController()
        let tabBarItem2 = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        formViewController.tabBarItem = tabBarItem2
        
        self.viewControllers = [tableViewController, formViewController]
    }
}

PlaygroundPage.current.liveView = MyTabBarController()
