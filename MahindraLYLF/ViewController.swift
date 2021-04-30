import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var lylfTabV: UITableView!
    var responseArr = [NSDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.lylfApiCall()
    }
    
    func lylfApiCall()
    {
        let url = URL(string: "http://mahindralylf.com/apiv1/getholidays")
        let urlReq = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlReq) { (data, resp, err) in
            print("Response Here")
            if let errObj = err
            {
                print(errObj.localizedDescription)
            }else if let dataObj = data {
                do{
                    let response = try JSONSerialization.jsonObject(with: dataObj, options: .mutableContainers) as? NSDictionary
                    print("Response \(String(describing: response))")
                    guard let dict = response else{
                        return
                    }
                    self.responseArr = dict.value(forKey: "holidays") as! [NSDictionary]
                    DispatchQueue.main.async {
                        self.lylfTabV.reloadData()
                    }
                }catch{
                    print("Exception Here")
                }
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return responseArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let dict = responseArr[section]
        return dict.value(forKey: "month") as? String ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let arr = responseArr[section]["details"] as! [NSDictionary]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let arr = responseArr[indexPath.section]["details"] as! [NSDictionary]
        let dict = arr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "holidayTVC") as! holidayTVC
        cell.titleLbl.text = dict.value(forKey: "title") as? String ?? ""
        cell.dateLbl.text = dict.value(forKey: "date") as? String ?? ""
        cell.dayLbl.text = dict.value(forKey: "day") as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
}

class holidayTVC: UITableViewCell
{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
}
