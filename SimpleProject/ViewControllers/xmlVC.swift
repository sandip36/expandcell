//
//  xmlVC.swift
//  SimpleProject
//
//  Created by applicationsupport on 16/10/17.
//  Copyright © 2017 SandipJadhav. All rights reserved.
//

import UIKit

class xmlVC: UIViewController,XMLParserDelegate {
    let recordKey = "Escalations"
    let dictionaryKeys = ["ESCALATION", "PERSON_NAME", "ADDRESS", "LANDLINE_NO","MOBILE_NO","FAX_NO","EMAIL_ID","CONTACT_TYPE"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //  downloadDataFromService("https://api.androidhive.info/pizza/?format=xml")
let urlstr = URL(string: "http://www.mybenefits360.com/appservice/escalationsservice.svc/getescalations1/881/285")
        let task = URLSession.shared.dataTask(with: urlstr!) { data, response, error in
            if error != nil {
                print(error )
                return
            }
            let parser = XMLParser(data: data!)
            parser.delegate = self
            if parser.parse() {
                print(self.results)
            }
        }
        task.resume()
    }
    
   
   
    // a few variables to hold the results as we parse the XML
    
    var results: [[String: String]] = [[:]]        // the whole array of dictionaries
    var currentDictionary: [String: String]! // the current dictionary
    var currentValue: String?
    
    // start element
    //
    // - If we're starting a "record" create the dictionary that will hold the results
    // - If we're starting one of our dictionary keys, initialize `currentValue` (otherwise leave `nil`)
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == recordKey {
            
            self.currentDictionary = [String : String]()
            
        } else if dictionaryKeys.contains(elementName) {
            
            self.currentValue = String()
            
        }
        
    }
    
    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        self.currentValue? += string
        
    }
    
    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
     //   print(elementName)
        if elementName == self.recordKey {
//self.results.append(["sandip":"jadhav"])
          //  print(self.currentDictionary)
         self.results.append(self.currentDictionary)
            
            self.currentDictionary = nil
            
        } else if dictionaryKeys.contains(elementName) {
            
            self.currentDictionary[elementName] = currentValue
            
            self.currentValue = nil
            
        }

    }
    
    // Just in case, if there's an error, report it. (We don't want to fly blind here.)
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
       
        
        self.currentValue = nil
        self.currentDictionary = nil
        self.results.removeAll()
        
    }
    
  
    
}

