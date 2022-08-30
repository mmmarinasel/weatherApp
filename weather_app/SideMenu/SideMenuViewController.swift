import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    private let cityImg = UIImage(systemName: "building.2.fill")
    private let settingsImg = UIImage(systemName: "gear")
    
    var delegate: SideMenuViewControllerDelegate?
    
    private var menu: [SideMenuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let cityImage = self.cityImg else { return }
        self.menu.append(SideMenuModel(icon: cityImage, title: "Выбрать город"))
        guard let settingsImage = self.settingsImg else { return }
        self.menu.append(SideMenuModel(icon: settingsImage, title: "Выбрать тему"))
        
//        self.sideMenuTableView.register(SideMenuTableViewCell.nib, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        
//        self.sideMenuTableView.reloadData()
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.sideMenuTableView.dequeueReusableCell(withIdentifier: "cell") as? SideMenuTableViewCell else { return SideMenuTableViewCell() }
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.selectedCell(indexPath.row)
    }
}
