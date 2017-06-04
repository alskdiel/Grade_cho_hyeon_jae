//
//  main.swift
//  Grade_cho_hyeon_jae
//
//  Created by CHJ on 2017. 6. 2..
//  Copyright © 2017년 CHJ. All rights reserved.
//

import Foundation

private func getDataFromFile() -> Dictionary<String, Any> {
    var result = [String:Any]()
    do {
        let homeURL = URL(fileURLWithPath: "/Users/yagom/")
        let file = homeURL.appendingPathComponent("students.json")
        let data_file = try Data(contentsOf: file)

        let object = try JSONSerialization.jsonObject(with: data_file, options: []) as? NSArray
        result = getResult(data: object!)

    } catch {
        print(error.localizedDescription)
    }
    
    return result
}

private func getResult(data: NSArray) -> Dictionary<String, Any> {
    var ret = [String:Any]()
    var grade_container = [String:String]()
    var certificated_container = [String]()
    
    var total_score = 0.0
    for student in data {
        let dic_student = student as? NSDictionary
        
        let name = dic_student!["name"] as! String
        let avr = getGradeInfo(student: dic_student!)
        total_score += avr

        if(avr <= 100 && avr >= 90) {
            grade_container[name] = "A"
            certificated_container.append(name)
        } else if(avr < 90 && avr >= 80) {
            grade_container[name] = "B"
            certificated_container.append(name)
        } else if(avr < 80 && avr >= 70) {
            grade_container[name] = "C"
            certificated_container.append(name)
        } else if(avr < 70 && avr >= 60) {
            grade_container[name] = "D"
        } else {
            grade_container[name] = "F"
        }
    }

    ret["average"] = ceil(total_score / Double(data.count) * 100) / 100
    ret["grade"] = grade_container
    ret["certificated"] = certificated_container
    
    return ret
}

private func getGradeInfo(student: NSDictionary) -> Double {
    let grade = student["grade"] as? NSDictionary
    
    var total_score = 0.0
    for (_, value) in grade! {
        total_score += Double(value as! Double)
    }
    
    let avr = ceil(total_score / Double(grade!.count) * 100) / 100

    return avr
}

private func saveFile(average: Double, grade: Array<(key : String, value : String)>, certificated: Array<String>) {
    let text = setTextAsString(average: average, grade: grade, certificated: certificated)
    writeToFile(text: text)
}

private func setTextAsString(average: Double, grade: Array<(key : String, value : String)>, certificated: Array<String>) -> String {
    var text = ""
    text += "성적결과표\n"
    text += "\n"
    
    text += "전체 평균 : " + String(average) + "\n"
    text += "\n"
    
    text += "개인별 학점\n"
    for (key, value) in grade {
        let len = key.characters.count
        let blank_needed = 11 - len
        
        text += key
        
        for _ in 1 ... blank_needed {
            text += " "
        }
        
        text += ": " + value + "\n"
    }
    
    text += "\n"
    
    text += "수료생\n"
    text += certificated.joined(separator: ", ")
    
    return text
}

private func writeToFile(text: String) {
    let homeURL = URL(fileURLWithPath: "/Users/yagom/")
    let file = homeURL.appendingPathComponent("result.txt")
    
    do {
        try text.write(to: file, atomically: false, encoding: .utf8)
        
    } catch {
        print("error writing to url:", file, error)
    }
}

private func main() {
    let data = getDataFromFile()    // average: Double, grade: Dictionary<String, Any>, certificated: Array<String>
  
    let average = data["average"]! as! Double
    let grade = (data["grade"]! as! Dictionary<String, String>).sorted { $0.0 < $1.0 }
    let certificated = (data["certificated"]! as! [String]).sorted()

    
    saveFile(average: average, grade: grade, certificated: certificated)
}

main()






