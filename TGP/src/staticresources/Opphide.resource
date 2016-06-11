onload = function() {
	
	setFocusOnLoad();
    if (typeof(startSessionTimer) != 'undefined') {
        startSessionTimer();
    };
    if (typeof(ActivityReminder) != 'undefined') {
        ActivityReminder.initialize([], false, false);
    };
    if ((window.sfdcPage) && (sfdcPage.executeOnloadQueue)) {
        sfdcPage.executeOnloadQueue();
    };
    Sfdc.Cookie.deleteCookie('setupopen');
    if (document.getElementById('sidebarDiv')) {
        Sidebar.prototype.theSidebar = new Sidebar(document.getElementById('sidebarDiv'), true, false);
    };
	
    var e=document.getElementsByClassName('toolsContent');
   if(e.length!=0){
    console.log('sdfbgsdbdsfbsbsdfbsbgbdf');
     e[0].style.visibility = 'hidden';
    e[0].style.display = 'none';
  }
				
}