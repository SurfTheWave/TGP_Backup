/**
    @Author : Devanna.Goudar
    @name:  ImportOpexSratChecklist
    @CreateDate :  2/21/2015
    @Description: This class contains all methods Import data from excel sheet into SRAT and OPEX tracker
    @Version: 1.0
    @reference: None
*/
public with sharing class ImportOpexSratChecklist {
    public string nameFile {
        get;
        set;
    }
    public Blob contentFile {
        get;
        set;
    }
    public String[] filelines = new String[] {};

    public List < Deal_OPEX_Additional_Tracking_Level_1__c > lstUpdatedOpexL1;
    public List < Deal_OPEX_Additional_Tracking_Level_1__c > lstopexLevel1 = new List < Deal_OPEX_Additional_Tracking_Level_1__c > ();
    public List < String > opexL1Ids = new List < String > ();

    public List < SRAT_Additional_Tracking_Level_1__c > lstUpdatedSratL1;
    public List < SRAT_Additional_Tracking_Level_1__c > lstsratLevel1 = new List < SRAT_Additional_Tracking_Level_1__c > ();
    public List < String > sratL1Ids = new List < String > ();

    public List < SRAT_Additional_Tracking_Level_2__c > lstUpdatedSratL2;
    public List < SRAT_Additional_Tracking_Level_2__c > lstsratLevel2 = new List < SRAT_Additional_Tracking_Level_2__c > ();
    public List < String > sratL2Ids = new List < String > ();

    public List < Deal_OPEX_Additional_Tracking_Level_2__c > lstUpdatedOpexL2;
    public List < Deal_OPEX_Additional_Tracking_Level_2__c > lstopexLevel2 = new List < Deal_OPEX_Additional_Tracking_Level_2__c > ();
    public List < String > opexL2Ids = new List < String > ();

    public Integer rowCount {
        get;
        set;
    }
    public Integer colCount {
        get;
        set;
    }

    /**
    @Author : Devanna.Goudar
    @name:  OpexL1Import
    @CreateDate :  2/21/2015
    @Description: This method is used to Import data from excel sheet into SRAT and OPEX tracker
    @Version: 1.0
    @reference: None
    */
    public Pagereference OpexL1Import() {

        rowCount = 0;
        colCount = 0;
        List < List < String >> parsedCSV = new List < List < String >> ();

        if (contentFile != null) {

            String fileString = contentFile.toString();
            parsedCSV = parseCSV(fileString, false);
            rowCount = parsedCSV.size();

            for (List < String > row: parsedCSV) {
                if (row.size() > colCount) {
                    colCount = row.size();
                }
            }
        }

        lstUpdatedOpexL1 = new List < Deal_OPEX_Additional_Tracking_Level_1__c > ();
        for (Integer i = 1; i < parsedCSV.size(); i++) {
            string str = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
            str = str.trim();

            opexL1Ids.add(str);
        }
        lstopexLevel1 = [Select Id, Name, OPEX_Level_1_Tracking_Type__c from Deal_OPEX_Additional_Tracking_Level_1__c where Id IN: opexL1Ids Limit 5000];
        for (Deal_OPEX_Additional_Tracking_Level_1__c opexL1: lstopexLevel1) {
            for (Integer i = 1; i < parsedCSV.size(); i++) {

                string rec = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                rec = rec.trim();

                if (rec == opexL1.Id) {
                    opexL1.OPEX_Level_1_Tracking_Type__c = parsedCSV[i][2].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    lstUpdatedOpexL1.add(opexL1);
                }
            }

        }



        try {
            update lstUpdatedOpexL1;
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO, UtilConstants.PAGE_MSG_3);
            ApexPages.addMessage(errormsg);
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, UtilConstants.PAGE_MSG_4);
            ApexPages.addMessage(errormsg);
        }
        return null;
    }
      /*
  @Author: 
  @Name: OpexL2Import
  @Created Date: 01 January 2015
  @Description:This is a Pagerefrence type method OpexL2Import
  @version: 1.0
*/
    public Pagereference OpexL2Import() {
        rowCount = 0;
        colCount = 0;
        List < List < String >> parsedCSV = new List < List < String >> ();

        if (contentFile != null) {

            String fileString = contentFile.toString();
            parsedCSV = parseCSV(fileString, false);
            rowCount = parsedCSV.size();

            for (List < String > row: parsedCSV) {
                if (row.size() > colCount) {
                    colCount = row.size();
                }
            }
        }

        lstUpdatedOpexL2 = new List < Deal_OPEX_Additional_Tracking_Level_2__c > ();
        for (Integer i = 1; i < parsedCSV.size(); i++) {
            string str = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
            str = str.trim();
            opexL2Ids.add(str);

        }
        lstopexLevel2 = [Select Id, OPEX_Level_1_Tracking_Type__c, Name, Answer__c from Deal_OPEX_Additional_Tracking_Level_2__c where Id IN: opexL2Ids Limit 5000];
        for (Deal_OPEX_Additional_Tracking_Level_2__c opexL2: lstopexLevel2) {
            for (Integer i = 1; i < parsedCSV.size(); i++) {

                string rec = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                rec = rec.trim();

                if (rec == opexL2.Id) {
                    opexL2.Name = parsedCSV[i][2].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    opexL2.Answer__c = parsedCSV[i][3].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);

                    lstUpdatedOpexL2.add(opexL2);
                }
            }
        }


        try {
            update lstUpdatedOpexL2;
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO, UtilConstants.PAGE_MSG_3);
            ApexPages.addMessage(errormsg);
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, UtilConstants.PAGE_MSG_4);
            ApexPages.addMessage(errormsg);
        }
        return null;
    }
    /*
    @Author: 
    @Name: SratL1Import
    @Created Date: 01 January 2015
    @Description: This is a pagereferance type method SratL1Import.
    @version: 1.0
    */
    public Pagereference SratL1Import() {
        rowCount = 0;
        colCount = 0;
        List < List < String >> parsedCSV = new List < List < String >> ();

        if (contentFile != null) {

            String fileString = contentFile.toString();
            parsedCSV = parseCSV(fileString, false);

            //system.debug('parsedCSV:'+parsedCSV);
            rowCount = parsedCSV.size();

            for (List < String > row: parsedCSV) {
                if (row.size() > colCount) {
                    colCount = row.size();
                }
            }
        }

        lstUpdatedSratL1 = new List < SRAT_Additional_Tracking_Level_1__c > ();
        for (Integer i = 1; i < parsedCSV.size(); i++) {
            string str = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
            str = str.trim();

            sratL1Ids.add(str);

        }
        lstsratLevel1 = [Select Id, Name, SRAT_Tracker__c, SRAT_Level_1_Tracking_Type__c, Question__c, Overall_RAG_Status__c, Comments__c from SRAT_Additional_Tracking_Level_1__c where Id IN: sratL1Ids Limit 5000];
        for (SRAT_Additional_Tracking_Level_1__c sratL1: lstsratLevel1) {
            for (Integer i = 1; i < parsedCSV.size(); i++) {

                string rec = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                rec = rec.trim();

                // system.debug('rec:'+rec);   
                // system.debug('sratL1.Id'+sratL1.Id);
                if (rec.equals(sratL1.Id)) {
                    //   system.debug('question value:'+parsedCSV[i][3].replaceAll('\"',''));                    
                    //       sratL1.Question__c = parsedCSV[i][3].replaceAll('\"','');
                    sratL1.Overall_RAG_Status__c = parsedCSV[i][3].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    sratL1.Comments__c = parsedCSV[i][4].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);

                    lstUpdatedSratL1.add(sratL1);
                }
            }

        }



        try {
            update lstUpdatedSratL1;
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO, UtilConstants.PAGE_MSG_3);
            ApexPages.addMessage(errormsg);
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, UtilConstants.PAGE_MSG_4);
            ApexPages.addMessage(errormsg);
        }
        return null;
    }
    /*
  @Author: 
  @Name: SratL2Import
  @Created Date: 01 January 2015
  @Description: This is a Pagereferance type method SratL2Import.
  @version: 1.0
*/
    public Pagereference SratL2Import() {
        rowCount = 0;
        colCount = 0;
        List < List < String >> parsedCSV = new List < List < String >> ();

        if (contentFile != null) {

            String fileString = contentFile.toString();
            parsedCSV = parseCSV(fileString, false);
            rowCount = parsedCSV.size();

            //system.debug('parsedCSV:'+parsedCSV);

            for (List < String > row: parsedCSV) {
                if (row.size() > colCount) {
                    colCount = row.size();
                }
            }
        }

        lstUpdatedSratL2 = new List < SRAT_Additional_Tracking_Level_2__c > ();
        for (Integer i = 1; i < parsedCSV.size(); i++) {

            string str = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
            str = str.trim();

            sratL2Ids.add(str);

        }
        lstsratLevel2 = [Select Id, Name, SRAT_Level_1_Tracking_Type__c, Section__c, Category__c, RAG_Status__c, Comments__c from SRAT_Additional_Tracking_Level_2__c where Id IN: sratL2Ids Limit 5000];
        for (SRAT_Additional_Tracking_Level_2__c sratL2: lstsratLevel2) {
            for (Integer i = 1; i < parsedCSV.size(); i++) {

                string rec = parsedCSV[i][0].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                rec = rec.trim();

                if (rec == sratL2.Id) {

                    sratL2.Section__c = parsedCSV[i][3].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    sratL2.Category__c = parsedCSV[i][4].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    sratL2.RAG_Status__c = parsedCSV[i][5].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);
                    sratL2.Comments__c = parsedCSV[i][6].replaceAll(UtilConstants.SLASH_QUOTE, UtilConstants.EMPTY_STRING);

                    lstUpdatedSratL2.add(sratL2);
                }
            }

        }
        try {
            update lstUpdatedSratL2;
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO, UtilConstants.PAGE_MSG_3);
            ApexPages.addMessage(errormsg);
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, UtilConstants.PAGE_MSG_4);
            ApexPages.addMessage(errormsg);
        }
        return null;
    }
    /*
    @Author: 
    @Name: parseCSV
    @Created Date: 01 January 2015
    @Description: This is a List<List> type method parseCSV
    @version: 1.0
    */
    public static List < List < String >> parseCSV(String contents, Boolean skipHeaders) {

        List < List < String >> allFields = new List < List < String >> ();

        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');

        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll(UtilConstants.DUB_QUOTE, UtilConstants.DBLQT);

        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows

        List < String > lines = new List < String > ();

        try {
            lines = contents.split(UtilConstants.NEW_LINE);
        } catch (System.ListException e) {
            String str = e.getMessage();
        }

        Integer num = 0;
        for (String line: lines) {

            // check for blank CSV lines (only commas)
            if (line.replaceAll(UtilConstants.COMMA_STRING, UtilConstants.EMPTY_STRING).trim().length() == 0) break;
            List < String > fields = line.split(UtilConstants.COMMA);
            List < String > cleanFields = new List < String > ();
            String compositeField;
            Boolean makeCompositeField = false;

            for (String field: fields) {
                if (field.startsWith(UtilConstants.DOUBLE_QUOTE) && field.endsWith(UtilConstants.DOUBLE_QUOTE)) {
                    cleanFields.add(field.replaceAll(UtilConstants.DOUBLE_QUOTE_STR, UtilConstants.DOUBLE_QUOTE));
                } else if (field.startsWith(UtilConstants.DOUBLE_QUOTE)) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith(UtilConstants.DOUBLE_QUOTE)) {
                    compositeField += UtilConstants.COMMA_STRING + field;
                    cleanFields.add(compositeField.replaceAll(UtilConstants.DOUBLE_QUOTE_STR, UtilConstants.DOUBLE_QUOTE));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField += UtilConstants.COMMA_STRING + field;
                } else {
                    cleanFields.add(field.replaceAll(UtilConstants.DOUBLE_QUOTE_STR, UtilConstants.DOUBLE_QUOTE));
                }

            }
            allFields.add(cleanFields);
        }

        if (skipHeaders) allFields.remove(0);
        return allFields;
    }
}