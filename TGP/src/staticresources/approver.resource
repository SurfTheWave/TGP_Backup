{!REQUIRESCRIPT("/soap/ajax/29.0/connection.js")}
                  {!REQUIRESCRIPT("/soap/ajax/22.0/apex.js")}
onpageshow  = function(){
	
                  var url = window.location.href;
                  var urlArray1 = url.split('/');
                alert(urlArray1[1] );
                 var approvalrequest=sforce.connection.query("Select id,approver__r.user__r.id,requestor__r.user__r.id From approval_request__c where id="+urlArray1[1] );
                records =approvalrequest.getArray("records");
                if( (records.length > 0) &&( records[0].approver__r.user__r.id == sforce.connection.getUserInfo().userId) ){
                       alert(abc)
               }else{
          alert('No records found.');
          }
       }