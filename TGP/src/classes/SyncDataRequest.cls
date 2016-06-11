/*
    @name : SyncDataRequest
    @Description : class to enter data in fte and custom cost
    @Version : 1.0
*/
public without sharing class SyncDataRequest{
    public String Opportunityid, SSMVersion ,ScenarioNm, VersionNm,MRDBVersion,LstBDLGeneratedScNm,LstBDLGeneratedVrNm,LstBDLGeneratedUserNm;
    public String scenarioContractStartDate,scenarioContractEndDate,scenarioGoLiveDate,mrdBDate;
    public datetime bdlGeneratedUTCDateTime;
    public List<FTEDataEntity> fteData = new list<FTEDataEntity>();
    public List<CCDataEntity> ccData = new list<CCDataEntity>();
    //public List<PayrollCostData> PayrollCostData = new list<PayrollCostData>();
    public List<VolumeData> volumeData = new list<VolumeData>();
    public boolean appendData;
    public boolean isTransactionSuccessful;
    public boolean isFirstChunk;
    public boolean isLastChunk;
    public String versionID;
    public String bpoSETemplateVersion;
    public Boolean hasMasterDataBeenCustomizedForDeal;
    public string enterpriseid;
    public String serviceGroup;
    
    /*
    @name : FTEDataEntity
    @Description : class for fte data entry
    @Version : 1.0
    */
    public class FTEDataEntity{
    Public String deliveryLocationNm;
    Public String countryNm; 
    Public String careerTrackNm; 
    Public String careerLevelNm;  
    Public String billCodeCd; 
    Public String rateTypeCd;
    Public String loadTypeCd;
    Public String mobilizationStartDt; 
    Public String goLiveDt; 
    Public String description ;
    Public String subServiceOfferingNm ; 
    Public String createUserId ;
    Public DateTime createDttm ;
    Public String updateUserId ;
    Public DateTime updateDttm ;
    Public String recruitingCostPCT; 
    Public String costingTypeCd; 
    Public String economicProfileNm; 
    Public String languageNm;
    Public String description1 ;
    Public String description2 ;
    Public String description3 ;
    Public String description4 ;
    Public String description5 ;
    Public String description6 ;
    Public String description7 ;
    Public String generic1 ;
    Public String generic2 ;
    Public String generic3 ;
    Public String toolName;
    Public String toolType;
    Public String offering3 ;
    Public String dcnLocation;
    Public String dCNFTEType; 
    Public String fteType; 
    Public String baselineFTE ;
    Public string pyramidRichness; 
    Public String crossSolutioning; 
    Public String mobCategory;
    Public String mobSubCategory;
    Public String languagePremium;
    Public String serviceComponent ;
    Public String column6;
    Public String column7;
    Public String column8; 
    Public String column9; 
    Public String column10; 
    Public String column11;
    Public String column12;
    Public String column13;
    Public String column14;
    Public String column15;
    Public String column16;
    Public String column17; 
    Public String serviceOfferingNm;
    Public Decimal  month1;
    Public Decimal  month2;
    Public Decimal  month3;
    Public Decimal  month4;
    Public Decimal  month5;
    Public Decimal  month6; 
    Public Decimal  month7; 
    Public Decimal  month8 ;
    Public Decimal  month9;
    Public Decimal  month10; 
    Public Decimal  month11; 
    Public Decimal  month12;
    Public Decimal  month13; 
    Public Decimal  month14 ;
    Public Decimal  month15 ;
    Public Decimal  month16 ;
    Public Decimal  month17 ;
    Public Decimal  month18 ;
    Public Decimal  month19 ;
    Public Decimal  month20 ;
    Public Decimal  month21 ;
    Public Decimal  month22 ;
    Public Decimal  month23 ;
    Public Decimal  month24 ;
    Public Decimal  month25 ;
    Public Decimal  month26 ;
    Public Decimal  month27 ;
    Public Decimal  month28 ;
    Public Decimal  month29 ;
    Public Decimal  month30 ;
    Public Decimal  month31 ;
    Public Decimal  month32 ;
    Public Decimal  month33 ;
    Public Decimal  month34 ;
    Public Decimal  month35 ;
    Public Decimal  month36 ;
    Public Decimal  month37 ;
    Public Decimal  month38 ;
    Public Decimal  month39 ;
    Public Decimal  month40 ;
    Public Decimal  month41 ;
    Public Decimal  month42 ;
    Public Decimal  month43 ;
    Public Decimal  month44 ;
    Public Decimal  month45 ;
    Public Decimal  month46 ;
    Public Decimal  month47 ;
    Public Decimal  month48 ;
    Public Decimal  month49 ;
    Public Decimal  month50 ;
    Public Decimal  month51 ;
    Public Decimal  month52 ;
    Public Decimal  month53 ;
    Public Decimal  month54 ;
    Public Decimal  month55 ;
    Public Decimal  month56 ;
    Public Decimal  month57 ;
    Public Decimal  month58 ;
    Public Decimal  month59 ;
    Public Decimal  month60 ;
    Public Decimal  month61 ;
    Public Decimal  month62 ;
    Public Decimal  month63 ;
    Public Decimal  month64 ;
    Public Decimal  month65 ;
    Public Decimal  month66 ;
    Public Decimal  month67 ;
    Public Decimal  month68 ;
    Public Decimal  month69 ;
    Public Decimal  month70 ;
    Public Decimal  month71 ;
    Public Decimal  month72 ;
    Public Decimal  month73 ;
    Public Decimal  month74 ;
    Public Decimal  month75 ;
    Public Decimal  month76 ;
    Public Decimal  month77 ;
    Public Decimal  month78 ;
    Public Decimal  month79 ;
    Public Decimal  month80 ;
    Public Decimal  month81 ;
    Public Decimal  month82 ;
    Public Decimal  month83 ;
    Public Decimal  month84 ;
    Public Decimal  month85 ;
    Public Decimal  month86 ;
    Public Decimal  month87 ;
    Public Decimal  month88 ;
    Public Decimal  month89 ;
    Public Decimal  month90 ;
    Public Decimal  month91 ;
    Public Decimal  month92 ;
    Public Decimal  month93 ;
    Public Decimal  month94 ;
    Public Decimal  month95 ;
    Public Decimal  month96 ;
    Public Decimal  month97 ;
    Public Decimal  month98 ;
    Public Decimal  month99 ;
    Public Decimal  month100 ;
    Public Decimal  month101 ;
    Public Decimal  month102 ;
    Public Decimal  month103 ;
    Public Decimal  month104 ;
    Public Decimal  month105 ;
    Public Decimal  month106 ;
    Public Decimal  month107 ;
    Public Decimal  month108 ;
    Public Decimal  month109 ;
    Public Decimal  month110 ;
    Public Decimal  month111 ;
    Public Decimal  month112 ;
    Public Decimal  month113 ;
    Public Decimal  month114 ;
    Public Decimal  month115 ;
    Public Decimal  month116 ;
    Public Decimal  month117 ;
    Public Decimal  month118 ;
    Public Decimal  month119 ;
    Public Decimal  month120 ;
    Public Decimal  mobTotals ;
    Public Decimal  runYr1 ;
    Public Decimal  runYr2 ;
    Public Decimal  runYr3 ;
    Public Decimal  runYr4 ;
    Public Decimal  runYr5 ;
    Public Decimal  runYr6 ;
    Public Decimal  runYr7 ;
    Public Decimal  runYr8 ;
    Public Decimal  runYr9 ;
    Public Decimal  runYr10 ;
    Public Decimal  colaMobPercent;
    Public decimal fteTransformationTotals; 
    Public decimal transformationTotals;
    /* Public Decimal  ColaYr1 ;
    Public Decimal  ColaYr2; 
    Public Decimal  ColaYr3 
    Public Decimal  ColaYr4 ;
    Public Decimal  ColaYr5 ;;
    Public Decimal  ColaYr6 ;
    Public Decimal  ColaYr7 
    Public Decimal  ColaYr8 
    Public Decimal  ColaYr9 
    Public Decimal  ColaYr10 
    Public Decimal  FxMobPercent 
    Public Decimal  FxYr1 
    Public Decimal  FxYr2 
    Public Decimal  FxYr3 
    Public Decimal  FxYr4 
    Public Decimal  FxYr5 
    Public Decimal  FxYr6 
    Public Decimal  FxYr7 
    Public Decimal  FxYr8 
    Public Decimal  FxYr9 
    Public Decimal  FxYr10 
    Public Decimal  ContingencyMobPercent 
    Public Decimal  ContingencyYr1 
    Public Decimal  ContingencyYr2 
    Public Decimal  ContingencyYr3 
    Public Decimal  ContingencyYr4 
    Public Decimal  ContingencyYr5 
    Public Decimal  ContingencyYr6 
    Public Decimal  ContingencyYr7 
    Public Decimal  ContingencyYr8 
    Public Decimal  ContingencyYr9 
    Public Decimal  ContingencyYr10 
    Public Decimal  MarginMobPercent 
    Public Decimal  MarginYr1 
    Public Decimal  MarginYr2 
    Public Decimal  MarginYr3 
    Public Decimal  MarginYr4 
    Public Decimal  MarginYr5 
    Public Decimal  MarginYr6 
    Public Decimal  MarginYr7 
    Public Decimal  MarginYr8 
    Public Decimal  MarginYr9 
    Public Decimal  MarginYr10*/
    Public String groupName;
    Public String nonDCNLocation; 
    Public Decimal costRate;
    Public Decimal loadedCostRate;
    Public Decimal hoursAppliedToContract;
    Public Decimal  fteMobTotals;
    Public Decimal  fteYr1;
    Public Decimal  fteYr2 ;
    Public Decimal  fteYr3 ;
    Public Decimal  fteYr4 ;
    Public Decimal  fteYr5 ;
    Public Decimal  fteYr6 ;
    Public Decimal  fteYr7 ;
    Public Decimal  fteYr8 ;
    Public Decimal  fteYr9 ;
    Public Decimal  fteYr10;
    Public Decimal  finalMonthFTE;
    Public Decimal locationTypeCode;
    Public string locationTypeName;
    Public String serviceGroup;
    Public String role;
    Public String phase;
    }
    
    /*
    @name : CCDataEntity
    @Description : class for custom cost data entry
    @Version : 1.0
    */
    public class CCDataEntity{
    
    Public String description;
    Public String countryNm;
    Public String costTypeCd;
    Public String runTypeCd;
    Public String mobilizationStartDt;
    Public String goLiveDt;
    Public String subServiceOfferingNm ;
    Public String careerTrackNm;
    Public String rateTypeCd;
    Public String loadTypeCd;
    Public String costingTypeCd;
    Public String economicProfileNm;
    Public String createUserId;
    Public  DateTime createDttm; 
    Public String updateUserId; 
    Public  DateTime updateDttm; 
    Public String description1;
    Public String description2;
    Public String description3;
    Public String description4;
    Public String description5;
    Public String description6;
    Public String description7;
    Public String generic1;
    Public String generic2;
    Public String generic3;
    Public String toolName;
    Public String toolType;
    Public String offering3;
    Public String serviceOfferingNm;
    Public String mobCategory;
    Public String mobSubCategory;
    Public Decimal month1;
    Public Decimal month2;
    Public Decimal month3;
    Public Decimal month4;
    Public Decimal month5;
    Public Decimal month6;
    Public Decimal month7;
    Public Decimal month8;
    Public Decimal month9;
    Public Decimal month10;
    Public Decimal month11;
    Public Decimal month12;
    Public Decimal month13;
    Public Decimal month14;
    Public Decimal month15;
    Public Decimal month16;
    Public Decimal month17;
    Public Decimal month18;
    Public Decimal month19;
    Public Decimal month20;
    Public Decimal month21;
    Public Decimal month22;
    Public Decimal month23;
    Public Decimal month24;
    Public Decimal month25;
    Public Decimal month26;
    Public Decimal month27;
    Public Decimal month28;
    Public Decimal month29;
    Public Decimal month30;
    Public Decimal month31;
    Public Decimal month32;
    Public Decimal month33;
    Public Decimal month34;
    Public Decimal month35;
    Public Decimal month36;
    Public Decimal month37;
    Public Decimal month38;
    Public Decimal month39;
    Public Decimal month40;
    Public Decimal month41;
    Public Decimal month42;
    Public Decimal month43;
    Public Decimal month44;
    Public Decimal month45;
    Public Decimal month46;
    Public Decimal month47;
    Public Decimal month48;
    Public Decimal month49;
    Public Decimal month50;
    Public Decimal month51;
    Public Decimal month52;
    Public Decimal month53;
    Public Decimal month54;
    Public Decimal month55;
    Public Decimal month56;
    Public Decimal month57;
    Public Decimal month58;
    Public Decimal month59;
    Public Decimal month60;
    Public Decimal month61;
    Public Decimal month62;
    Public Decimal month63;
    Public Decimal month64;
    Public Decimal month65;
    Public Decimal month66;
    Public Decimal month67;
    Public Decimal month68;
    Public Decimal month69;
    Public Decimal month70;
    Public Decimal month71;
    Public Decimal month72;
    Public Decimal month73;
    Public Decimal month74;
    Public Decimal month75;
    Public Decimal month76;
    Public Decimal month77;
    Public Decimal month78;
    Public Decimal month79;
    Public Decimal month80;
    Public Decimal month81;
    Public Decimal month82;
    Public Decimal month83;
    Public Decimal month84;
    Public Decimal month85;
    Public Decimal month86;
    Public Decimal month87;
    Public Decimal month88;
    Public Decimal month89;
    Public Decimal month90;
    Public Decimal month91;
    Public Decimal month92;
    Public Decimal month93;
    Public Decimal month94;
    Public Decimal month95;
    Public Decimal month96;
    Public Decimal month97;
    Public Decimal month98;
    Public Decimal month99;
    Public Decimal month100;
    Public Decimal month101;
    Public Decimal month102;
    Public Decimal month103;
    Public Decimal month104;
    Public Decimal month105;
    Public Decimal month106;
    Public Decimal month107;
    Public Decimal month108;
    Public Decimal month109;
    Public Decimal month110;
    Public Decimal month111;
    Public Decimal month112;
    Public Decimal month113;
    Public Decimal month114;
    Public Decimal month115;
    Public Decimal month116;
    Public Decimal month117;
    Public Decimal month118;
    Public Decimal month119;
    Public Decimal month120;
    Public Decimal mobTotals;
    Public Decimal runYr1;
    Public Decimal runYr2;
    Public Decimal runYr3;
    Public Decimal runYr4;
    Public Decimal runYr5;
    Public Decimal runYr6;
    Public Decimal runYr7;
    Public Decimal runYr8;
    Public Decimal runYr9;
    Public Decimal runYr10;
    Public String languagePremium;
    Public String serviceComponent;
    Public String phase;
    
    /*
    Public Decimal ColaMobPercent
    Public Decimal ColaYr1
    Public Decimal ColaYr2
    Public Decimal ColaYr3
    Public Decimal ColaYr4
    Public Decimal ColaYr5
    Public Decimal ColaYr6
    Public Decimal ColaYr7
    Public Decimal ColaYr8
    Public Decimal ColaYr9
    Public Decimal ColaYr10
    Public Decimal FxMobPercent
    Public Decimal FxYr1
    Public Decimal FxYr2
    Public Decimal FxYr3
    Public Decimal FxYr4
    Public Decimal FxYr5
    Public Decimal FxYr6
    Public Decimal FxYr7
    Public Decimal FxYr8
    Public Decimal FxYr9
    Public Decimal FxYr10
    Public Decimal ContingencyMobPercent
    Public Decimal ContingencyYr1
    Public Decimal ContingencyYr2
    Public Decimal ContingencyYr3
    Public Decimal ContingencyYr4
    Public Decimal ContingencyYr5
    Public Decimal ContingencyYr6
    Public Decimal ContingencyYr7
    Public Decimal ContingencyYr8
    Public Decimal ContingencyYr9
    Public Decimal ContingencyYr10
    Public Decimal MarginMobPercent
    Public Decimal MarginYr1
    Public Decimal MarginYr2
    Public Decimal MarginYr3
    Public Decimal MarginYr4
    Public Decimal MarginYr5
    Public Decimal MarginYr6
    Public Decimal MarginYr7
    Public Decimal MarginYr8
    Public Decimal MarginYr9
    Public Decimal MarginYr10 */
    Public Decimal locationTypeCode; 
    Public string locationTypeName;
    //Public String ServiceComponent;
    Public String dcnType;
    Public String dcnLocation;
    Public String column6;
    Public String column7;
    Public String column8;
    Public String column9;
    Public String column10;
    Public String column11;
    Public String column12;
    Public String column13;
    Public String column14;
    Public String column15;
    Public String column16;
    Public String column17;
    Public String groupName;
    Public String serviceGroup;
    Public decimal transformationTotals;
    
    }
    /*
    @name : SyncDataResponse
    @Description : class for data response
    @Version : 1.0
    */
    public class SyncDataResponse{
            public Boolean status;
    }    
    /*
    @name : VolumeDataEntity
    @Description : class for payroll data entry. Added as part of IO Sync
    @Version : 1.0
    */
     public class VolumeData{
        Public String phase;
        Public String serviceGroup;
        Public String subServiceGroup;
        Public String service;
        Public String serviceComponent;
        Public String description;
        Public Decimal month1;
        Public Decimal month2;
        Public Decimal month3;
        Public Decimal month4;
        Public Decimal month5;
        Public Decimal month6;
        Public Decimal month7;
        Public Decimal month8;
        Public Decimal month9;
        Public Decimal month10;
        Public Decimal month11;
        Public Decimal month12;
        Public Decimal month13;
        Public Decimal month14;
        Public Decimal month15;
        Public Decimal month16;
        Public Decimal month17;
        Public Decimal month18;
        Public Decimal month19;
        Public Decimal month20;
        Public Decimal month21;
        Public Decimal month22;
        Public Decimal month23;
        Public Decimal month24;
        Public Decimal month25;
        Public Decimal month26;
        Public Decimal month27;
        Public Decimal month28;
        Public Decimal month29;
        Public Decimal month30;
        Public Decimal month31;
        Public Decimal month32;
        Public Decimal month33;
        Public Decimal month34;
        Public Decimal month35;
        Public Decimal month36;
        Public Decimal month37;
        Public Decimal month38;
        Public Decimal month39;
        Public Decimal month40;
        Public Decimal month41;
        Public Decimal month42;
        Public Decimal month43;
        Public Decimal month44;
        Public Decimal month45;
        Public Decimal month46;
        Public Decimal month47;
        Public Decimal month48;
        Public Decimal month49;
        Public Decimal month50;
        Public Decimal month51;
        Public Decimal month52;
        Public Decimal month53;
        Public Decimal month54;
        Public Decimal month55;
        Public Decimal month56;
        Public Decimal month57;
        Public Decimal month58;
        Public Decimal month59;
        Public Decimal month60;
        Public Decimal month61;
        Public Decimal month62;
        Public Decimal month63;
        Public Decimal month64;
        Public Decimal month65;
        Public Decimal month66;
        Public Decimal month67;
        Public Decimal month68;
        Public Decimal month69;
        Public Decimal month70;
        Public Decimal month71;
        Public Decimal month72;
        Public Decimal month73;
        Public Decimal month74;
        Public Decimal month75;
        Public Decimal month76;
        Public Decimal month77;
        Public Decimal month78;
        Public Decimal month79;
        Public Decimal month80;
        Public Decimal month81;
        Public Decimal month82;
        Public Decimal month83;
        Public Decimal month84;
        Public Decimal month85;
        Public Decimal month86;
        Public Decimal month87;
        Public Decimal month88;
        Public Decimal month89;
        Public Decimal month90;
        Public Decimal month91;
        Public Decimal month92;
        Public Decimal month93;
        Public Decimal month94;
        Public Decimal month95;
        Public Decimal month96;
        Public Decimal month97;
        Public Decimal month98;
        Public Decimal month99;
        Public Decimal month100;
        Public Decimal month101;
        Public Decimal month102;
        Public Decimal month103;
        Public Decimal month104;
        Public Decimal month105;
        Public Decimal month106;
        Public Decimal month107;
        Public Decimal month108;
        Public Decimal month109;
        Public Decimal month110;
        Public Decimal month111;
        Public Decimal month112;
        Public Decimal month113;
        Public Decimal month114;
        Public Decimal month115;
        Public Decimal month116;
        Public Decimal month117;
        Public Decimal month118;
        Public Decimal month119;
        Public Decimal month120;
        
     }
}