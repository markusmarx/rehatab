var currentView

function fnSwitchToCalendar(open) {
    console.log("switch to calendar " + open)
    if (open) {
        fnCloseCurrentView()
        currentView.push(comp_calendar.createObject(main_content))
    }
}

function fnSwitchToGroupView(open) {
    console.log("switch to groups " + open)
    if (open) {
        fnCloseCurrentView()
        currentView.push(comp_groupoverview.createObject(main_content))
    }

}

function fnSwitchToClientView(open) {
        console.log("switch to clients " + open)
        if (open) {
            if (currentView[currentView.length-1])
                console.log(currentView[currentView.length-1].name)
            fnCloseCurrentView()
            currentView.push(comp_clientoverview.createObject(main_content))
        }

}

function fnSwitchToStatisticView(open) {
    console.log("switch to statistic " + open)
    if (open) {
        var statisticView = comp_statisticview.createObject(root_item)
        currentView.push(statisticView)
        statisticView.y = 40
        statisticView.x = 225
    } else {
        fnCloseCurrentView()
    }
}

function fnCloseCurrentView() {
    if (currentView.length > 0) {
        console.log("close currentView")
        currentView.pop().destroy();
    }
}


