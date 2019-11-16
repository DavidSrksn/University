import UIKit

struct FilterPresenter {
    private var model = Filter()
    
    init() {
        model.country = ""
        model.subjects = []
        model.minPoint = 100
        model.military = true
        model.campus = true
    }
    
    mutating func loadFilterSettings() {
        self.model = Manager.shared.loadFilterSettings()
    }
    
    func updateFilterSettings() {
        Manager.shared.updateFilterSettings(with: self.model)
    }
    
    func fillFields(country: inout String, subjects: inout [String], minPoints: inout Int, military: inout Bool, campus: inout Bool) {
        country = self.model.country ?? ""
        subjects = self.model.subjects ?? []
        minPoints = self.model.minPoint ?? 100
        military = self.model.military ?? true
        military = self.model.campus ?? true
        
    }
    
    mutating func changeCountry(newCountry: String?) {
        
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
