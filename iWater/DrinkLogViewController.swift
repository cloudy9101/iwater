//
//  DrinkLogViewController.swift
//  iWater
//
//  Created by cloudy on 2018/5/19.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class DrinkLogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: UICollectionView!
    let dateCellIdentifier = "calendarDateCell"
    var currentDate = Date()
    var dates: [Date] = []
    
    @IBOutlet weak var drinkLogTotal: UILabel!
    @IBOutlet weak var drinkLogTable: UITableView!
    let drinkLogCellIdentifier = "drinkLogCell"
    var drinkLogs: [DrinkLog] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerObservers()
        initCalendar()
        initDrinkLogTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDrinkLog), name: NSNotification.Name(rawValue: "GetDrinkLog"), object: nil)
    }
    
    @IBAction func prevMonth(_ sender: Any) {
        let currentMonth = Calendar.current.component(Calendar.Component.month, from: currentDate)
        let prevMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: currentDate)
        setCalendar(date: prevMonthDate!)
        self.currentDate = prevMonthDate!
        
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        let currentMonth = Calendar.current.component(Calendar.Component.month, from: currentDate)
        let nextMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: currentDate)
        setCalendar(date: nextMonthDate!)
        self.currentDate = nextMonthDate!
    }
    
    @objc func showDrinkLog(n: Notification) {
        let result = n.object as! DrinkLogData
        drinkLogTotal.text = String(result.total!) + " ML"
        drinkLogs = result.logs
        drinkLogTable.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DrinkLogViewController {
    func initCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(UINib(nibName: "CalendarDateCell", bundle: nil), forCellWithReuseIdentifier: dateCellIdentifier)
        calendar.register(CalendarDateCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dateCellIdentifier)
        calendar.register(UINib(nibName: "CalendrDateCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dateCellIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 0)
        layout.itemSize = CGSize.init(width: 40, height: 20)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        calendar.collectionViewLayout = layout
        setCalendar(date: currentDate)
    }
    
    func setCalendar(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM"
        let stringTime = dateFormatter.string(from: date)
        dateLabel.text = stringTime
        dates = CalendarData.init(date: date).dateArray()
        calendar.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dates.count / 7 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath) as! CalendarDateCell
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor.init(red: 0, green: 255.0, blue: 0, alpha: 1)
            cell.dateLabel.text = CalendarData.weekHeaders[indexPath.row]
        } else {
            cell.backgroundColor = UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 1)
            cell.dateLabel.text = String(Calendar.current.component(Calendar.Component.day, from: dates[indexPath.row + (indexPath.section - 1) * 7]))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        Utils.shared.getDrinkLog(on: dates[indexPath.row + (indexPath.section - 1) * 7])
    }
}

extension DrinkLogViewController {
    func initDrinkLogTable() {
        drinkLogTable.dataSource = self
        drinkLogTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = drinkLogTable.dequeueReusableCell(withIdentifier: drinkLogCellIdentifier, for: indexPath) as? DrinkLogCell
        let time = ISO8601DateFormatter().date(from: drinkLogs[indexPath.row].time)!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        cell!.timeLabel.text = dateFormatter.string(from: time)
        cell!.volumeLabel.text = String(drinkLogs[indexPath.row].volume) + " ML"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkLogs.count
    }
}
