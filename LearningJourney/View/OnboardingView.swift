//
//  onboarding.swift
//  LearningJourney
//
//  Created by may.mohammed on 28/05/1448 AH.
//

import SwiftUI


enum Timeframe : String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var maxFreezes: Int{
        switch self {
        case .week : return 2
        case .month : return 8
        case .year : return 96
        }}
    
}



struct OnboardingView: View {
    @State private var desire = ""
    @State private var cycle : Timeframe = .week
    var body: some View {
        VStack(alignment: .leading , spacing:35 ){
            
            VStack(alignment: .leading , spacing: 80){
                Image("streak")
                    .padding(.top , 60)
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading){
                    Text("Hello **Learner**")
                        .font(.largeTitle)
                    Text("This app will help you learn everyday!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }}
            
            VStack(alignment: .leading){
                Text("I want to learn")
                TextField("Swift", text: $desire)
                Divider()
            }
            VStack(alignment: .leading){
                Text("I want to learn it in a")
                    .font(.subheadline)
                HStack(spacing:12){
                    ForEach(Timeframe.allCases , id: \.self ) {  timeframe in
                        
                        Button {
                            cycle = timeframe
                            
                        }label:{
                            Text(timeframe.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal , 20)
                                .padding(.vertical , 14)
                                .fixedSize()
                                .foregroundStyle(cycle==timeframe ? .white : .gray)
                                .glassEffect(.regular.tint(cycle==timeframe ? .orange : .clear), in: .capsule)
                            
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            Spacer()
            VStack(alignment: .leading){
                Button{
                    
                }label: {
                    Text("Start Learning")
                    
                        .fontWeight(.medium)
                    
                        .padding(.horizontal , 20)
                    
                    
                }
                
                .buttonStyle(.glassProminent)
                .tint(.orange)
                
                .frame(maxWidth:.infinity)
                .controlSize(.large)
                
                
                
                
                Text("You can edit your desire later")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .frame(maxWidth:.infinity)
            }}
        .padding(.horizontal)
    }
}


struct Goal{
    var desire : String
    var cycle : Timeframe
    var start : Date = .now
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}

