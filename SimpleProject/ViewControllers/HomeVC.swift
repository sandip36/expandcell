//
//  HomeVC.swift
//  SimpleProject
//
//  Created by applicationsupport on 15/10/17.
//  Copyright © 2017 SandipJadhav. All rights reserved.
//

import UIKit

class HomeVC: UIViewController{
   //ModelClass
    var isExpaneded : Bool = false

    var arrOfdata : [Sandip] = []
    var isMenuOneClicked = false
    var clickedCellIndexes : NSMutableArray = []
    var LastSelectedIndexPath = -1

    
    @IBOutlet weak var tblViewHome: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tblViewHome.register(nib, forCellReuseIdentifier: "Menu")
        let nibsecond = UINib(nibName: "MenuDataCell", bundle: nil)
        tblViewHome.register(nibsecond, forCellReuseIdentifier: "MenuData")
        self.tblViewHome.estimatedRowHeight = 20
        self.tblViewHome.rowHeight = UITableViewAutomaticDimension
        tblViewHome.tableFooterView = UIView()
     let aa = val()
       // let dddd = [11,12,13]
       //print(aa)
        let a = ["a", "b", "c"]
        let b = ["d", "e", "f"]
        
        let res = [a, b].reduce([],+)
        print(res)
        downloadDataFromService("http://trasquare.com/traveller_api/checktrawellersgatewayurl.php?action=getUserActivity&userId=85&publicId=1&page=1")
    }
    func val() -> [Int]
    {
         let data = Singlotone.sharerdinstance
        return data.callmethod()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark: =========================== Show Alert ===========================
    func showAlert(_ message:String){
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "No Internet", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }

    //MARK:===========================  Download Data from Service ===========================
    func downloadDataFromService(_ urlString : String){
        if Reachability.isConnectedToNetwork() == true {
            
            let url : URL = URL(string: urlString)!
            let request = URLRequest(url: url as URL)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    //print(json)
                    if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                        
                       let crimes = json?["data"] as! [[String:Any]]
                        print(crimes.count)
                       // print(crimes)

                        for obj in crimes{

                            let crime = Sandip()
                            crime.cdid = obj["id"] as? String
                            crime.date = obj["add_date"] as? String
                            crime.Discription = obj["activity_description"] as? String
                            crime.userImage = obj["userImage"] as? String
                             self.arrOfdata.append(crime)
                        }
                    //    print(self.arrOfdata)
                          DispatchQueue.main.async {
                self.tblViewHome.reloadData()
                        }
                    } else {
                      //  self.updateMapAndTableview()
                      self.showAlert("Data not fetched from server")
                    }
                }
            })
            
            task.resume()
        }else{
          //  self.updateMapAndTableview()
           self.showAlert("Device internet is not Working")
        }
        
    }
    
    
    //Mark: =========================== Show Alert ===========================
    func showAlert(message:String, AlertTital : String){
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: AlertTital, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            let window:UIWindow? = (UIApplication.shared.delegate?.window)!
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            // window.present(alertController, animated: true, completion:nil)
            
        }
}

}

extension HomeVC : UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        if (cell.tag % 2) != 0
        {
            return
        }
      
        
        if clickedCellIndexes.contains(indexPath.row)
        {
            clickedCellIndexes.remove(indexPath.row)
            isExpaneded = false
            
        }
        else
        {
            isExpaneded = true
            cell.isHidden = false
            clickedCellIndexes.add(indexPath.row)
            
            
        }
        cell.tag = indexPath.row
        
        
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations:
            { () -> Void in
                self.tblViewHome.reloadData()
        },
                          completion: nil);
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row % 2 == 0
        {
             let cellarr = self.arrOfdata[indexPath.row] as Sandip
           let  cella = tblViewHome.dequeueReusableCell(withIdentifier: "Menu") as! MenuCell
            cella.discription.text = cellarr.Discription
            cella.cid.text = cellarr.cdid
            cella.date.text = cellarr.date
           // print(cellarr.userImage)
            // async download
            cella.imgView.imageFromServerURL(urlString: cellarr.userImage!)
            
//            let label = cell.viewWithTag(21) as! UILabel
//
//            let lab = cell.viewWithTag(20) as?
//            UILabel
//            let bgviewd = cell.viewWithTag(999) as! UIView
          //  bgviewd.dropShadow()
     //       lab?.font=UIFont(name:MyConstant.AppFont.SFontelloName, size:25)
            
//lab?.font=UIFont(name:MyConstant.AppFont.SFontelloName, size:25)
      //
            if clickedCellIndexes.contains(indexPath.row)
            {
            //    lab?.text = MyConstant.AppIcon.SiconUPDetails
            }
            else
            {
        //        lab?.text = MyConstant.AppIcon.SiconDownDetails
            }
        //    label.text = arrforintimatedClaims.object(at: indexPath.row) as? String
            
            cella.isHidden = false
            
            cella.selectionStyle = .none
            
            cella.tag = indexPath.row
            return cella
        }else
        {
            
        }
        
        if indexPath.row % 2 != 0
        {
            
          let cell = tableView.dequeueReusableCell(withIdentifier: "MenuData") as! MenuDataCell
            cell.textLabel?.text = "ddd"
           // cell.di= "sssss"
//            let celldata = self.arrforintmatedData[indexPath.row] as IntimateClaimData
//            cell.Name.text = celldata.Name
//            cell.Name.font = MyConstant.fontApp.RegularSmall
//
//            cell.CliamIntimatedOn.text = celldata.ClaimIntimatedon
//            cell.CliamIntimatedOn.font = MyConstant.fontApp.RegularSmall
//
//            cell.cNo.text = celldata.ClaimIntimationNo
//            cell.cNo.font = MyConstant.fontApp.RegularSmall
//
//            cell.DOA.text = celldata.DOA
//            cell.DOA.font = MyConstant.fontApp.RegularSmall
//
//            cell.EstimatedAmmount.text = celldata.EstimatedCA
//            cell.EstimatedAmmount.font = MyConstant.fontApp.RegularSmall
//
//            cell.Diagnosis_Alis.text = celldata.Diagnosis_Ailment
//            cell.Diagnosis_Alis.font = MyConstant.fontApp.RegularSmall
//
//
            // cell.bgView.layer.cornerRadius = 5
            cell.isSelected = true
            
            cell.selectionStyle = .none
            if clickedCellIndexes.contains(indexPath.row - 1)
            {
                cell.isHidden = false
            }
            else
            {
                cell.isHidden = true
            }
            
           // cell.lblBgView.dropShadow()
            // border
            //            cell.lblBgView.layer.borderWidth = 0.1
            //            cell.lblBgView.layer.borderColor = UIColor.lightGray.cgColor
            //
            //            // shadow
            //            cell.lblBgView.layer.shadowColor = UIColor.black.cgColor
            //            cell.lblBgView.layer.shadowOffset = CGSize(width: 3, height: 3)
            //            cell.lblBgView.layer.shadowOpacity = 0.3
            //            cell.lblBgView.layer.shadowRadius = 4.0
            cell.tag = indexPath.row
            
            return cell
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfdata.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if clickedCellIndexes.contains(indexPath.row - 1)
        {
            
            return UITableViewAutomaticDimension
        }
        else if(!clickedCellIndexes.contains(indexPath.row - 1) && indexPath.row % 2 != 0)
        {
            return 0
        }
        
        
        return UITableViewAutomaticDimension
    }
    
    
    
    //MARK: ========================= Model Class For Sandip=======================
    class Sandip {
        var cdid: String?
        var date: String?
        var Discription: String?
        var userImage: String?
      
    }

}


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

