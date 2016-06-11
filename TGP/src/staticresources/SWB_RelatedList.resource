window.onload = function() {
	if(this.bodyOnLoad)bodyOnLoad();
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


 /* search start*/
  if ((window.sfdcPage) && (sfdcPage.executeOnloadQueue)){sfdcPage.executeOnloadQueue();};
	new GhostTextInputWrapperElement('phSearchInput', 'Search All... \u25be', '', 'headerSearchBoxGhostText', "phSearchForm", null, false);
	new UnifiedSearchAutoCompleteElement("phSearchInput","/_ui/common/search/client/ui/UnifiedSearchAutoCompleteServlet",1,{},true,null,"phSearchForm",["div","searchOwner","asPhrase","sen"],{},"searchScopeDialog","Search Options","/unifiedsearch/unifiedSearchScoping.apexp?scopeDest=UNIFIED",378,"false");
	new UnifiedSearchButton("searchButtonContainer", "phSearchButton", "headerSearchRightRoundedCornerMouseOver", "phSearchForm");
	
 /* search start*/

    Sfdc.Cookie.deleteCookie('setupopen');
    if (document.getElementById('sidebarDiv')) { 
        Sidebar.prototype.theSidebar = new Sidebar(document.getElementById('sidebarDiv'), true, false);
    };
	
	var mainTitle=document.getElementsByTagName('h2');
	var e=document.getElementsByTagName('*');
    if(mainTitle.length!=null){
		for(var m=0;m<mainTitle.length;m++){
			
			//start of opportunity page
			if(mainTitle[m].innerHTML.match('Opportunity Detail')){
				    //Hiding opportunity documents related list
					
						if(e[i]!=null){
							if(e[i].id!=null){
								if (e[i].id.match('_00NE0000005hTDp_link')){
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								}
							}	
						}
						for(var i = 0; i < e.length; i++){
							if (e[i].id.match('_00NE0000005hTDp')){
								e[i].style.visibility = 'hidden';
								e[i].style.display = 'none';
							}
						}
					

					//hiding analytics related list  
					
					var analyticsckboxid=document.getElementById('00NE0000005hTXx_chkbox');
					
					if (analyticsckboxid.title != 'Checked') {
						for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									// this id will differ for every organization. It is used for hiding analytic related list.It refers to the analytic //related list on opportunity page layout.
									if (e[i].id.match('_00NE0000005hTCp_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
			     // this id will differ for every organization. It is used for hiding analytic related list.It refers to the analytic hover links
							if (e[i].id.match('_00NE0000005hTCp')) {
								e[i].style.visibility = 'hidden';
								e[i].style.display = 'none';
							};
						};
					}
					
					//hiding capacity related list
					
					var capasitychkboxid=document.getElementById('00NE0000005hTYI_chkbox');
					
					if (capasitychkboxid.title != 'Checked') {
						
							for (var i = 0; i < e.length; i++) {
								if(e[i]!=null){
									if(e[i].id!=null){
										if (e[i].id.match('_00NE0000005hTD2_link ')) {
											e[i].style.visibility = 'hidden';
											e[i].style.display = 'none';
										};
									}	
								}
			 
								if (e[i].id.match('_00NE0000005hTD2')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
							};
                };
				
				//hiding governance related list
				
				var governancechkboxid=document.getElementById('00NE0000005hTaU_chkbox');
			    if(governancechkboxid.title != 'Checked'){
					   for (var i = 0; i < e.length; i++) {
								if(e[i]!=null){
									if(e[i].id!=null){
										if (e[i].id.match('_00NE0000005hTDX_link ')) {
											e[i].style.visibility = 'hidden';
											e[i].style.display = 'none';
										};
									}	
								}
						 
									if (e[i].id.match('_00NE0000005hTDX')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
						};
			   }
			   
			   //hiding commercial related list
			   
			   	var commercialckboxid=document.getElementById('00NE0000005hTYM_chkbox');
				if(commercialckboxid.title != 'Checked'){
					for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									if (e[i].id.match('_00NE0000005hTD5_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
					 
								if (e[i].id.match('_00NE0000005hTD5')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
					};
	   
				}
				
				//hiding capability related list
				var capabilityckboxid=document.getElementById('00NE00000064AbS_chkbox');			
				if(capabilityckboxid.title != 'Checked'){
					for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									if (e[i].id.match('_00NE00000064IFK_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
					 
								if (e[i].id.match('_00NE00000064IFK')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
					};
	   
				}

			}
			//End Of Opportunity Page
			
			// Start Of Service Detail Page
			
			if(mainTitle[m].innerHTML.match('Service Detail')){
				
				
				
			}
			
			//End Of Service Detail Page
			
			// Start Of Mail Summary Page
			if(mainTitle[m].innerHTML.match('Service Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			//End Of Mail Summary Page
			
			// Start Of Mail Summary Page
			
			if(mainTitle[m].innerHTML.match('Mail Summary Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			
			//End Of Mail Summary Page
			// Start Of Commercial Data Edit
			if(mainTitle[m].innerHTML.match('Commercial Data Edit')){
			var savenew= document.getElementsByName('save_new');
			if(savenew.length!=0){
			savenew[0].style.visibility='hidden';
			savenew[0].style.display='none';
			savenew[1].style.visibility='hidden';
			savenew[1].style.display='none';
			}
			}
			//Commercial Data Edit Ends 
			//Opp team Starts
			if(mainTitle[m].innerHTML.match('Opportunity Team Edit')){
			var savenew= document.getElementsByName('save_new');
			if(savenew.length!=0){
			savenew[0].style.visibility='hidden';
			savenew[0].style.display='none';
			savenew[1].style.visibility='hidden';
			savenew[1].style.display='none';
			}
			}
			//Opp team Starts ends
			
			
			// Start Of Risk And Action Log Edit Page
			
			if(mainTitle[m].innerHTML.match('Risk And Action Log Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			
			//End Of Risk And Action Log Edit Page
			
			
			
			 //Start Of Client Visit  Edit Page

			if(mainTitle[m].innerHTML.match('Client Visit Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			
			//End Of Client Visit  Edit Page

             
			
			
			//Start Of Capability Involvement Edit  Page

			if(mainTitle[m].innerHTML.match('Capability Involvement Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			
			//End Of Capability Involvement Edit  Page

			//Start Of Client Visit Feedback Edit  Page

			if(mainTitle[m].innerHTML.match('Client Visit Feedback Edit')){
				
				var savenew= document.getElementsByName('save_new');
				if(savenew.length!=0){
					savenew[0].style.visibility='hidden';
					savenew[0].style.display='none';
					savenew[1].style.visibility='hidden';
					savenew[1].style.display='none';
				}
				
			}
			
			//End Of Client Visit Feedback Edit  Page
			

			// Start Of Commercial Data Detail Page
			
			if(mainTitle[m].innerHTML.match('Commercial Data Detail')){
				
				var newnote=document.getElementsByName('newNote');
				if(newnote.length!=0){
					newnote[0].style.visibility='hidden';
					newnote[0].style.display='none';
				}
				
			}
			
			//End Of Commercial Data Detail Page
			
			// Start Of  Deal Review Note Detail Page
			
			if(mainTitle[m].innerHTML.match('Deal Review Note Detail')){
				
				var newnote=document.getElementsByName('newNote');
				if(newnote.length!=0){
					newnote[0].style.visibility='hidden';
					newnote[0].style.display='none';
				}
				
			}
			
			//End Of Deal Review Note Detail Page
			
			// Start Of  Deal Detail Page
			
			if(mainTitle[m].innerHTML.match('Deal New Detail')){
				
				var newnote=document.getElementsByName('newNote');
				if(newnote.length!=0){
					newnote[0].style.visibility='hidden';
					newnote[0].style.display='none';
				}
				
			}
			
			//End Of Deal Detail Page
			
			// Start Of  Mobilization Plan Detail Page
			
			if(mainTitle[m].innerHTML.match('Mobilization Plan Detail')){
				
				var checkContract=document.getElementById('00NE0000005hTVp_chkbox');
				var checkService=document.getElementById('00NE0000005hTWQ_chkbox');
				var checkJourney=document.getElementById('00NE0000005hTVz_chkbox');
				
				//Hiding contract Related list
				if(checkContract.title != 'Checked'){
					for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									if (e[i].id.match('_00NE0000005hTD6_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
					 
								if (e[i].id.match('_00NE0000005hTD6')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
					};
	   
				}
				
				//Hiding Service related list
				
				if(checkService.title != 'Checked'){
					for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									if (e[i].id.match('_00NE0000005hTDc_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
					 
								if (e[i].id.match('_00NE0000005hTDc')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
					};
	   
				}
				
				// Hiding journey related list
				
				if(checkJourney.title != 'Checked'){
					for (var i = 0; i < e.length; i++) {
							if(e[i]!=null){
								if(e[i].id!=null){
									if (e[i].id.match('_00NE0000005hTDE_link ')) {
										e[i].style.visibility = 'hidden';
										e[i].style.display = 'none';
									};
								}	
							}
					 
								if (e[i].id.match('_00NE0000005hTDE')) {
									e[i].style.visibility = 'hidden';
									e[i].style.display = 'none';
								};
					};
	   
				}
				
				
				/*
				var newnote=document.getElementsByName('newNote');
				if(newnote.length!=0){
					newnote[0].style.visibility='hidden';
					newnote[0].style.display='none';
				}
				*/
				
				var budgetMain=document.getElementsByClassName('listRelatedObject Custom5Block')[0];
				var dwnldBdgtButton = document.getElementsByName('download_budget_cost_summary');
                
				if(budgetMain!=null){
					var noRows=budgetMain.getElementsByClassName('noRowsHeader')[0];
					if(noRows!=null){
						if(noRows.innerHTML=='No records to display'){
							dwnldBdgtButton[0].style.visibility = 'hidden';
							dwnldBdgtButton[0].style.display = 'none';
						}
					}
				}
				
			}
			
			//End Of Mobilization Plan Detail Page
			
			// Start Of MEC Detail Page
			
			if(mainTitle[m].innerHTML.match('MEC Detail')){
				var newnote=document.getElementsByName('newNote');
				if(newnote.length!=0){
					newnote[0].style.visibility='hidden';
					newnote[0].style.display='none';
				}
				
				
			}
			//End Of MEC Detail Page
					
		   
		   var ophide=document.getElementsByClassName('linksModule sidebarModule');
		   if(ophide.length!=0){
			 ophide[1].style.visibility = 'hidden';
			ophide[1].style.display = 'none';
			}
			
			
		}
		
					
		
			
			//hiding tool contents  of opportunity page  toolsContent
					
						
					for(var i = 0; i < e.length; i++){
						if(e[i]!=null){
							if(e[i].id!=null){
								if (e[i].id=='toolsContent'){
												e[i].style.visibility = 'hidden';
												e[i].style.display = 'none';
											};
							}
						}
					}
	}
}	