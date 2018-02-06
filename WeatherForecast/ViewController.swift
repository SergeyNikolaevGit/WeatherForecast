//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Sergey Nikolaev on 2/5/18.
//  Copyright © 2018 Sergey Nikolaev. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is furnished
//to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var appName: UILabel!
    @IBOutlet var wDayLabel: [UILabel]!
    @IBOutlet var wIcon: Array<UIImageView>!
    @IBOutlet var temperatureLabel: Array<UILabel>!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var citiesPicker: UIPickerView!
    
    let countryName = "Russia"
    var cityName = "Almetyevsk"
    
    var wDayArray = ["", "", "", ""]
    var weatherArray = ["", "", "", ""]
    var iconArray = ["", "", "", ""]
    var citiesArray = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citiesPicker.dataSource = self
        citiesPicker.delegate = self
        
        appName.text? = "Weather Forecast"
        
        countryLabel.text? = countryName
        cityLabel.text? = cityName
        
        let citiesPlistPath = Bundle.main.path(forResource: "Сities", ofType: "plist")
        citiesArray = NSMutableArray.init(contentsOfFile: citiesPlistPath!)!
        
        print(citiesArray)
        
        parseJson()
        
    }
    
    @IBAction func reloadJson(_ sender: Any) {
        
        
    }
    
    func parseJson() {
        
//        Please replase "YOUR_KEY" on registred key. Use http://api.wunderground.com
        
        let parseUrl = URL.init(string: "http://api.wunderground.com/api/YOUR_KEY/forecast/lang:EN/q/\(countryName)/\(cityName).json")
        
        let task = URLSession.shared.dataTask(with: parseUrl!) {data,responce,error in
            
            if error != nil {
                print("Error")
            } else {
                
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        for jsonCounter in 0...3 {
                            
                            if let jsondata = jsonResult as? [String: Any],
                                let forecast = jsondata["forecast"] as? [String: Any],
                                let simpleforecast = forecast["simpleforecast"] as? [String: Any],
                                let forecastday = simpleforecast["forecastday"] as? [Any],
                                
                                let object = forecastday[jsonCounter] as? [String: Any],
                                let objectDate = object["date"] as? [String: Any],
                                let weekDay = objectDate["weekday"],
                                let low = object["low"] as? [String: Any],
                                let celcius = low["celsius"],
                                let iconUrl = object["icon_url"] {
                                
                                print(celcius)
                                
                                self.wDayArray[jsonCounter] = weekDay as! String
                                self.weatherArray[jsonCounter] = celcius as! String
                                self.iconArray[jsonCounter] = iconUrl as! String
                                
                            }
                            
                        }
                    }
                    catch {
                        print("Error parse")
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return citiesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (citiesArray[row] as! String)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let city = citiesArray[row]
        print(city)
        
        cityName = city as! String
        cityLabel.text? = city as! String
        
        parseJson()
        
        print("\(weatherArray)")
        print("\(iconArray)")
        
        var counter = 0
        
        
        for weather in weatherArray {
            
            temperatureLabel[counter].text? = weather
            
            let imageUrl = URL.init(string: iconArray[counter])
            let data = try? Data(contentsOf: imageUrl!)
            wIcon[counter].image = UIImage(data: data!)
            
            wDayLabel[counter].text? = wDayArray[counter]
            
            counter+=1
        }
        
    }
    
    
}

