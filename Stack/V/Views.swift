import SwiftUI

struct ContentView: View {
    let tabColor = ViewModelSettings.showUIColors ? Color.orange : Color.clear
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .background(tabColor)
            InterestBearingAccountView()
                .tabItem {
                    Label("Line of Credit", systemImage: "square.grid.2x2")
                }
                .background(tabColor)
        }
    }
}

enum ViewModelSettings {
    static let showUIColors = false
    
    /// dashboard - to show summary of net worth, assets & liabilities, prices of markets that portfolio is allocated to, etc.
    static let dashCols = 6, dashRows = 10
    static let rowGridItems_dashboard: [GridItem] = Array(repeating: .init(.flexible()), count: dashRows)
    
    /// interest bearing accounts
    static let cols_lineOfCredit = 4, rows_lineOfCredit = 24
    static let rowGridItems_lineOfCredit: [GridItem] = Array(repeating: .init(.flexible()), count: rows_lineOfCredit)
}

struct DashboardView: View {
    @StateObject var dashboardViewModel = DashboardViewModel(cols: ViewModelSettings.dashCols, rows: ViewModelSettings.dashRows)
    var body: some View {
        GridView(rowGridItems: ViewModelSettings.rowGridItems_dashboard, viewModel: dashboardViewModel)
    }
}

struct InterestBearingAccountView: View {
    @StateObject var creditLineViewModel = InterestBearingAccountViewModel(cols: ViewModelSettings.cols_lineOfCredit, rows: ViewModelSettings.rows_lineOfCredit)
    var body: some View {
        GridView(rowGridItems: ViewModelSettings.rowGridItems_lineOfCredit, viewModel: creditLineViewModel)
    }
}

struct InterestBearingAccountView_Previews: PreviewProvider {
    static let cols = ViewModelSettings.cols_lineOfCredit, rows = ViewModelSettings.rows_lineOfCredit
    static var previews: some View {
        GridView(rowGridItems: ViewModelSettings.rowGridItems_lineOfCredit, viewModel: InterestBearingAccountViewModel(cols: cols, rows: rows))
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static let cols = Constants.dashCols, rows = Constants.dashRows
//    static var previews: some View {
//        GridView(rowGridItems: Constants.rowGridItems_dashboard, viewModel: DashboardViewModel(cols: cols, rows: rows))
//    }
//}
