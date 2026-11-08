//
//  learndDay.swift
//  LearningJourney
//
//  Created by may.mohammed on 30/05/1448 AH.
//
import SwiftUI
import Playgrounds


enum DayStatus {
    case freeze
    case learn
}

struct LoggedDay {
    var state: DayStatus
    var date: Date = Date.now
}

@Observable
class ActivityViewModel {
    
    var loggedDays: [LoggedDay] = []
    var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
    }
    
    var learnedCount: Int {
        loggedDays.filter { $0.state == .learn }.count
    }
    
    var usedFreezes: Int {
        loggedDays.filter { $0.state == .freeze }.count
    }
    
    var canFreeze: Bool {
        usedFreezes < goal.cycle.maxFreezes
    }
    var todayStatus : DayStatus?{
        loggedDays.first{ Calendar.current.isDateInToday($0.date)}?.state
        
    }
    
    func addLearn() {
        guard todayStatus==nil else{return}
        loggedDays.append(LoggedDay(state: .learn))
        
    }
    
    func addFreeze() {
        guard todayStatus == nil, canFreeze else { return }
            loggedDays.append(LoggedDay(state: .freeze))
    }
}


struct ActivityView: View {
    var body: some View {
        Text("Activity")
    }
}

#Preview {
    ActivityView()
}

#Playground {
    _ = 1 + 2
}
