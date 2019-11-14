import UIKit

struct FilterPresenter {
    private var model = Filter()
    
    init() {
        model.country = []
        model.subjects = []
        model.minPoint = 100
        model.military = true
        model.campus = true
    }
    
    mutating func addCountry(newCountrys: String?) {
        
    }
    
    mutating func addSubject(newSubjects: String?) {
        
    }
    
    mutating func changeMinPoint(for value: Int) {
        model.minPoint? = value
    }
    
    mutating func changeMilitary(for value: Bool) {
        model.military? = value
    }
    
    mutating func changeCampus(for value: Bool) {
        model.campus? = value
    }
    
    func countOfCountrys() -> Int? {
        return self.model.country?.count
    }
    
    func countOfSubjects() -> Int? {
        return self.model.subjects?.count
    }
}
