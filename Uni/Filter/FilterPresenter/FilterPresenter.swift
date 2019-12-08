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
    
    mutating func loadFilterSettings() -> Bool {
        self.model = Manager.shared.loadFilterSettings()
        
        return self.model.country != nil
    }
    
    func updateFilterSettings() {
        Manager.shared.updateFilterSettings(with: self.model)
    }
    
    func fillFields(country: inout String?, subjects: inout [subjectData], minPoints: inout Float, military: inout Bool, campus: inout Bool) {
        country = self.model.country
        
        if let data = self.model.subjects {
            for i in 0...data.count {
                subjects[i].title = data[i]
            }
        }
        
        minPoints = Float(self.model.minPoint ?? 100)
        military = self.model.military ?? true
        campus = self.model.campus ?? true
    }
    
    mutating func changeCountry(newCountry: String?) {
        model.country = newCountry
    }
    
    mutating func updateSubject(newSubjects: [String]?) {
        model.subjects = newSubjects ?? []
    }
    
    mutating func changeMinPoint(for value: Int) {
        model.minPoint = value
    }
    
    mutating func changeMilitary(for value: Bool) {
        model.military = value
    }
    
    mutating func changeCampus(for value: Bool) {
        model.campus = value
    }
    
//    func countOfCountrys() -> Int? {
//        return self.model.country?.count
//    }
    
    func countOfSubjects() -> Int? {
        return self.model.subjects?.count
    }
}
