//
//  Utilities.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/8/20.
//

import UIKit

let dateFormatter = ISO8601DateFormatter()

func showLoadingView(presenter: UIViewController) {
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();

    alert.view.addSubview(loadingIndicator)
    presenter.present(alert, animated: true, completion: nil)
}

func removeLoadingView(remover: UIViewController) {
    remover.dismiss(animated: false, completion: nil)
}

extension Date {
    func getDate() -> String {
        let dateString = dateFormatter.string(from: self).components(separatedBy: "T")[0]
        let yearMonthDay = dateString.components(separatedBy: "-")
        // i.e. 2018-11-08
        let year = yearMonthDay[0]
        let month = yearMonthDay[1].convertDigitToMonth()
        let day = String(Int(yearMonthDay[2])!) // would rather crash then have wrong day being outputted
        // output: November 8, 2018
        return "\(month) \(day), \(year)"
    }
    func getTime() -> String {
        let dateString = dateFormatter.string(from: self).components(separatedBy: "T")
        let times = dateString[1].components(separatedBy: ":")
        let time = "\(times[0]):\(times[1])"
        return time == "" ? "00:00" : time
    }
    
}

extension String {
    func convertDate() -> Date {
        // i.e. "November 10, 2018 6:00 PM"
        let dateComponents = self.components(separatedBy: " ")
        // MM
        let month = dateComponents[0].convertMonthToDigit()
        // dd
        let day = dateComponents[1].filter { $0.isNumber }.convertDay()
        // yyyy
        let year = dateComponents[2]
        let hour_minute = dateComponents[3].components(separatedBy: ":")
        let am_pm = dateComponents[4] == "AM" ? true : false
        // hh
        let hour = hour_minute[0].convertHour(am_pm)
        // mm
        let minute = hour_minute[1]
        // "yyyy-MM-ddTHH:mm:ss+0000"
        let isoDate = "\(year)-\(month)-\(day)T\(hour):\(minute):00+0000"
        return dateFormatter.date(from:isoDate)!
    }
    
    func convertHour(_ am_pm: Bool) -> String {
        let am_pm = self == "12" ? !am_pm : am_pm
        if am_pm {
            return self.count == 1 ? "0\(self)" : self
        } else {
            guard self != "12" else { return "00" }
            let integer = Int(self)!
            let pm = integer + 12
            return String(pm)
        }
    }
    
    func convertDay() -> String {
        return self.count == 1 ? "0\(self)" : self
    }
    
    func convertMonthToDigit() -> String {
        switch self {
        case "January":
            return "01"
        case "February":
            return "02"
        case "March":
            return "03"
        case "April":
            return "04"
        case "May":
            return "05"
        case "June":
            return "06"
        case "July":
            return "07"
        case "August":
            return "08"
        case "September":
            return "09"
        case "October":
            return "10"
        case "November":
            return "11"
        case "December":
            return "12"
        default:
            return "UNKNOWN MONTH"
        }
    }
    
    func convertDigitToMonth() -> String {
        switch self {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "UNKNOWN DIGIT"
        }
    }
}
