//
//  TrendView.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/3/22.
//

import SwiftUI
import SwiftUICharts

struct NoLegendStyle: ChartStyle {
    var showLegends: Bool { false }
}

struct TrendView: View {
    
    private let cold = Legend(
        color: Color(.sRGBLinear, red: 167.0/255.0, green: 113.0/255.0, blue: 255.0/255.0, opacity: 1.0),
        label: "cold",
        order: 0
    )
    private let medium = Legend(
        color: Color(.sRGBLinear, red: 252.0/255.0, green: 92.0/255.0, blue: 255.0/255.0, opacity: 1.0),
        label: "cold",
        order: 0
    )
    private let hot = Legend(
        color: Color(.sRGBLinear, red: 255.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, opacity: 1.0),
        label: "cold",
        order: 0
    )
    
    @State var trendData = [TrendPoint]()
    var dataPoints: [DataPoint] {
        let formatter = RelativeDateTimeFormatter()
        return trendData.enumerated().map { (index, trendPoint) -> DataPoint in
            var legend = cold
            
            switch Double(index) / Double(trendData.count) {
            case 0.0..<0.33:
                legend = cold
            case 0.33..<0.66:
                legend = medium
            default:
                legend = hot
            }
            let label = LocalizedStringKey(
                formatter.string(for: Date(timeIntervalSince1970: Double(trendPoint.time))) ?? ""
            )
            return DataPoint(
                value: Double(trendPoint.value),
                label: label,
                legend: legend
            )
        }
    }
    
    var body: some View {
        LineChartView(dataPoints: dataPoints)
            .chartStyle(
                LineChartStyle(
                    lineMinHeight: 30.0,
                    showAxis: false,
                    showLabels: false,
                    showLegends: false,
                    drawing: .stroke(width: 4)
                )
            )
            .frame(width: 80, height: 30, alignment: .trailing)
    }
}

struct TrendView_Previews: PreviewProvider {
    static var previews: some View {
        TrendView()
    }
}
