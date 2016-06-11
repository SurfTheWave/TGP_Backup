
onload=function(){
	alert('hi');
{!REQUIRESCRIPT("/soap/ajax/29.0/connection.js")} 
{!REQUIRESCRIPT("/soap/ajax/22.0/apex.js")} 
var url = window.location.href; 
var urlArray1 = url.split('/'); 
var oppid = urlArray1[1];  
var ids=[]; 
var oppteamid=sforce.connection.query("SELECT Id, Name, Opportunity__c, Role__r.name FROM Opportunity_Team__c where Opportunity__c= ='" + oppid + "'" ); 
records = oppteamid.getArray("records"); 
alert(records[0]);
console.log(records[0]+'sadrfasdfasfasdfasfa');
}