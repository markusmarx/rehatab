var currentView

function fnSwitchToCalendar(open) {
    console.log("switch to calendar " + open)
    if (open) {
        fnCloseCurrentView()
        currentView = comp_calendar.createObject(main_content)
    }
}

function fnSwitchToGroupView(open) {
    console.log("switch to groups " + open)
    if (open) {
        fnCloseCurrentView()
        currentView = comp_groupoverview.createObject(main_content)
    }

}

function fnSwitchToClientView(open) {

        console.log("switch to clients " + open)
        if (open) {
            fnCloseCurrentView()
            currentView = comp_clientoverview.createObject(main_content)
        }

}

function fnCloseCurrentView() {
    if (currentView) {
        console.log("close currentView")
        currentView.destroy();
    }
}
