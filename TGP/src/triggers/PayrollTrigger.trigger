trigger PayrollTrigger on Payroll__c (before insert) {
    if(trigger.isbefore && trigger.isinsert){
        map<id,decimal> payrollMap = new map<id,decimal>();
        for(aggregateResult ar :[select opportunity__c,sum(Y1__c)y1,sum(Y2__c)y2 from payroll__c 
                                where ID IN: trigger.new Group BY opportunity__c limit 5000]){
            string oppid = (string) ar.get('opportunity__c');
            decimal total = (Decimal) ar.get('y1')+(Decimal) ar.get('y2');
            decimal average = 0.00;
            if(total != 0 && total != null){ 
                 average = total/24; 
            }
            payrollMap.put(oppid,average.setscale(2));
        }
        for(payroll__c pay : trigger.new){
            if(payrollMap.get(pay.opportunity__c) != null){
                pay.PayRoll_Cost_IO__c = payrollMap.get(pay.opportunity__c);
            }
        }
    }  
}