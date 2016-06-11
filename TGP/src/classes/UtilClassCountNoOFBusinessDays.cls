/**
   @Author :Apoorva Sharma
   @name   : UtilClassCountNoOFBusinessDays 
   @CreateDate : 1 March 2016 
   @Description : This class is used for calculating the number of business/working days between two dates.
   @Version : 1.0 
  */
public without sharing class UtilClassCountNoOFBusinessDays {
	/**
     * @description       This method is used for calculating the number of business/working days between two dates.
     * @param             Date startdt, Date enddt
     * @return            Integer
     * @throws            None 
     */ 
    public static integer getDiffBusinessDays(Date startdt, Date enddt){
    	Date tempdate = null;
	 	if (startdt > enddt) {
		 	tempdate = enddt;
		 	enddt = startdt;
		 	startdt = tempdate;
	 	}
	 	
	 	integer i = Math.mod((date.newinstance(1985, 6, 24)).daysBetween(startdt),7);
	 	Map<integer, Map<integer, integer>> m = new Map<integer, Map<integer, integer>> {
			0 => new Map<integer, integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 5 , 5 => 5 , 6 => 5 },
			1 => new Map<integer, integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 4 , 5 => 4 , 6 => 5 },
			2 => new Map<integer, integer> { 1 => 2 , 2 => 3 , 3 => 3 , 4 => 3 , 5 => 4 , 6 => 5 },
			3 => new Map<integer, integer> { 1 => 2 , 2 => 2 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
			4 => new Map<integer, integer> { 1 => 1 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
			5 => new Map<integer, integer> { 1 => 0 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
			6 => new Map<integer, integer> { 1 => 1 , 2 => 2 , 3 => 3 , 4 => 4 , 5 => 5 , 6 => 5 }
		};
		
		Integer i2 = Math.mod((startdt.daysBetween(enddt)),7);
		Integer i3 = (m.get(i)).get(i2);
		if (i2 == null || i2 < 1 || i2 > 6){
			if (i >= 0 && i <= 4)
			{ 
				i3 = 1; 
			}
			else{ 
				i3 = 0;
			}
		}
		i3 = i3 + 5 * (Math.floor( ((Decimal) startdt.daysBetween(enddt)).divide(7,4))).intValue(); 
		if (tempdate != null){
			i3 *= -1;
		} 
		return i3;
    }
}