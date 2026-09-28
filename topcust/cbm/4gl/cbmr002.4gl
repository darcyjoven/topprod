# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cbmr002.4gl
# Descriptions...: 实盘差异分析表
# Date & Author..: 2016/08/11 guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

#GLOBALS
#  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
#  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
#  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
#  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
#  DEFINE g_seq_item     LIKE type_file.num5 
#END GLOBALS
#No.FUN-580004--end
DEFINE tm  RECORD 
           wc        STRING
        END RECORD 
DEFINE g_tc_bwc07     VARCHAR(1000)
DEFINE  g_i             LIKE type_file.num5     
DEFINE  g_msg           LIKE type_file.chr1000    
DEFINE l_oaz23          LIKE oaz_file.oaz23 
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT

#FUN-710081--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_str      STRING
#FUN-710081--end
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
  
   DISPLAY "g_rpt_name:",g_rpt_name
  
    LET g_sql ="bma01.bma_file.bma01,",
               "ima02.ima_file.ima02,",
               "l_chr.type_file.chr1000,",
               "imaud07.ima_file.imaud07,", #str---add by huanglf160815
               "imaud10.ima_file.imaud10,",#str---add by huanglf160815
               "ima94.ima_file.ima94,",
               "ecu02.ecu_file.ecu02,",
               "bmb03.bmb_file.bmb03,",
               "bmb09.bmb_file.bmb09,",     #add by wangxt170209
               "bmbud02.bmb_file.bmbud02,",
               "bmbud03.bmb_file.bmbud03,",
               "bmbud04.bmb_file.bmbud04,",
               "ima02_1.ima_file.ima02,",

               "ima021.ima_file.ima021,",
               "imaud05.ima_file.imaud05,",
               "bmb06.bmb_file.bmb06,",
               "bmb10.bmb_file.bmb10,",
               "bmbud01.bmb_file.bmbud01,",
               
               "bmbud05.bmb_file.bmbud05,",#str---add byhuanglf160815
               "bmb02.bmb_file.bmb02,",
               "bmd04.bmd_file.bmd04,",    #add by guanyao160902
               "url.type_file.chr1000,",
               "url2.type_file.chr1000,",

               "ima08.ima_file.ima08,",   #str---add by huanglf160914
               "ima08_1.type_file.chr30,",
               "l_flag.type_file.chr1,",     #add by huanglf160920
               "bmbud06.bmb_file.bmbud06,",  #add by huanglf160920
               "ima021_1.type_file.chr1000,",  #add by huanglf160922

               "title.type_file.chr1000,",  #add by guanyao160928
               "imaud06.ima_file.imaud06,",   #add by huanglf161017
               "imaud06_1.ima_file.imaud06"   #add by huanglf161017
   LET l_table = cl_prt_temptable('cbmr002',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   IF cl_null(tm.wc) THEN
      CALL cbmr002_tm(0,0)             
   ELSE      
      CALL cbmr002()
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION cbmr002_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         
          l_cmd          LIKE type_file.chr1000   
   DEFINE l_str          LIKE type_file.chr1000
   DEFINE l_sql          LIKE type_file.chr1000
    
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cbmr002_w AT p_row,p_col WITH FORM "cbm/42f/cbmr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify  
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end 
   WHILE TRUE
   DIALOG ATTRIBUTE (UNBUFFERED)

       
      CONSTRUCT BY NAME tm.wc ON bma01        
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT DIALOG 
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bma01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_ima"
                 LET g_qryparam.state ="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bma01
                 NEXT FIELD bma01
            END CASE        
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG
 
         ON ACTION qbe_select
            CALL cl_qbe_select()


         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      
      ON ACTION ACCEPT  
          ACCEPT DIALOG   

      ON ACTION CANCEL  
          LET INT_FLAG=1   
          EXIT DIALOG      
          
    END DIALOG  
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW cbmr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'cbmr002'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cbmr002','9031',1)
         ELSE
#            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,       
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",                       
                         " '",g_rlang CLIPPED,"'", 
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,                       
                        " '",g_rep_user CLIPPED,"'",          
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"           
            CALL cl_cmdat('cbmr002',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW cbmr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait() 
      CALL cbmr002() 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW cbmr002_w
 
END FUNCTION
 
FUNCTION cbmr002()
   DEFINE sr        RECORD
               bma01    LIKE bma_file.bma01,
               ima02    LIKE ima_file.ima02,
               l_chr    LIKE type_file.chr1000,
               imaud07  LIKE ima_file.imaud07,
               imaud10  LIKE ima_file.imaud10,
               ima94    LIKE ima_file.ima94,
               ecu02    LIKE ecu_file.ecu02,
 
               bmb03    LIKE bmb_file.bmb03,
               bmb09    LIKE bmb_file.bmb09,#add by wangxt170209
               bmbud02  LIKE bmb_file.bmbud02,
               bmbud03  LIKE bmb_file.bmbud03,
               bmbud04  LIKE bmb_file.bmbud04,
               ima02_1  LIKE ima_file.ima02,

               ima021   LIKE ima_file.ima021,
               imaud05  LIKE ima_file.imaud05,
               bmb06    LIKE bmb_file.bmb06,
               bmb10    LIKE bmb_file.bmb10,
               bmbud01  LIKE bmb_file.bmbud01,

               bmbud05  LIKE bmb_file.bmbud05, #str----add byhuanglf160815
               bmb02    LIKE bmb_file.bmb02,
               bmd04    LIKE bmd_file.bmd04,   #add by guanyao160902
               url      LIKE type_file.chr1000,
               url2     LIKE type_file.chr1000,
               
               ima08    LIKE ima_file.ima08,   #add by huanglf160914
               ima08_1  LIKE type_file.chr30,
               l_flag   LIKE type_file.chr1,   #add by huanglf160920
               bmbud06  LIKE bmb_file.bmbud06, #add by huanglf160920
               ima021_1 LIKE type_file.chr1000, #add by huanglf160922
               
               title    LIKE type_file.chr1000, #add by guanyao160928
               imaud06  LIKE ima_file.imaud06,  #add by huanglf161017
               imaud06_1 LIKE ima_file.imaud06
                 END RECORD
   DEFINE l_zo041     LIKE zo_file.zo041 
   DEFINE l_zo05      LIKE zo_file.zo05  
   DEFINE l_zo09      LIKE zo_file.zo09
   DEFINE l_occ01     LIKE occ_file.occ01
   DEFINE l_sql,l_sqla,l_sqlb,l_sqll       STRING
   DEFINE l_cmd,g_wc2a,g_wc2b       STRING 
   DEFINE l_imaud10   LIKE type_file.chr30
   DEFINE l_n,l_n1         LIKE type_file.num5  #add by huanglf160920
   DEFINE l_ima02    LIKE ima_file.ima02  #add by huanglf160922
   DEFINE l_ima021   LIKE ima_file.ima021 #add by huanglf160922
   DEFINE l_bmd04    LIKE bmd_file.bmd04  #add by huanglf160922
   DEFINE l_n2       LIKE type_file.num5  #add by huanglf160922
   DEFINE l_x        LIKE type_file.num5  #add by guanyao160928
   
   CALL cl_del_data(l_table)  
  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang
  #end FUN-810029 mod 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'cbmr002'  

   LET l_n2 = 1 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                    #add by huanglf161017 
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?,?)"   #str----add byhuanglf160815  #add ? by guanyao160902 #add ? by wangxt170209
   PREPARE insert_prep FROM g_sql                                        #add by huanglf160914
   IF STATUS THEN                                                        #add by huanglf160920      
      CALL cl_err("insert_prep:",STATUS,1)                               #add by huanglf160922#add ? by guanyao160928
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecuuser', 'ecugrup')  

   LET l_sql = "SELECT bma01,a.ima02,'',a.imaud07,a.imaud10,a.ima94,'',bmb03,bmb09,bmbud02,bmbud03,bmbud04,b.ima02,b.ima021,b.imaud05,bmb06,",#add bmb09 by wangxt170209
               "       bmb10,bmbud01,bmbud05,bmb02,'','','',b.ima08,'','',bmbud06,'','',a.imaud06,b.imaud06",  #add by huanglf160914 
               "  FROM bmb_inplan LEFT JOIN ima_file b ON b.ima01=bmb03 ,",    #add by huanglf160920
               "       bma_inplan LEFT JOIN ima_file a ON a.ima01=bma01 ",
               " WHERE bmb01 = bma01",
               "   AND bmb04<=to_date('",g_today,"','yy/mm/dd')",
               "   AND (bmb05 is null or bmb05 >to_date('",g_today,"','yy/mm/dd') ) ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY bma01,bmb03"
   PREPARE prep_aaa FROM l_sql
   DECLARE decl_aaa CURSOR FOR prep_aaa
   FOREACH decl_aaa INTO sr.*

#str---add by huanglf161017
   #IF sr.imaud06 = 'Y' THEN 
   #  LET  sr.imaud06 = '汽车板'
   #END IF 
   #IF sr.imaud06_1 = 'Y' THEN 
   #  LET sr.bmbud01 = '汽车板'
   #END IF
   #chg by donghy 客户改为自行录入，必须要转换了
#str---end by huanglf161017 
   #str---add by huanglf160815
    SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = sr.bma01 AND imaud07 LIKE '%mm%'
    SELECT to_char(sr.imaud10) INTO l_imaud10 FROM ima_file WHERE ima01 = sr.bma01
    SELECT COUNT(*)  INTO l_n1 FROM ima_file WHERE ima02 = sr.ima02 AND ima02 LIKE '%-%'
    IF l_n1 = 0 THEN 
      LET sr.l_flag = 'N'
    ELSE 
      LET sr.l_flag = 'Y'  
    END IF 
     IF l_n = 0 THEN 
      LET sr.l_chr = sr.imaud07 CLIPPED,'mm/' CLIPPED,l_imaud10 CLIPPED,'pcs' CLIPPED
     ELSE  
      LET sr.l_chr = sr.imaud07 CLIPPED,'/' CLIPPED,l_imaud10 CLIPPED,'pcs' CLIPPED
     END IF 
     LET sr.url="C:\Users\tiptop\Desktop\1.png"
     LET sr.url2="C:\Users\tiptop\Desktop\2.png"

        IF sr.ima08 ='C' THEN LET sr.ima08_1 = '规格组件'  END IF 
        IF sr.ima08 ='T' THEN LET sr.ima08_1 = '最后规格料件'  END IF 
        IF sr.ima08 ='D' THEN LET sr.ima08_1 = '特性料件' END IF 
        IF sr.ima08 ='A' THEN LET sr.ima08_1 = '族群料件' END IF 
        IF sr.ima08 ='M' THEN LET sr.ima08_1 = '自制料件' END IF 
        IF sr.ima08 ='P' THEN LET sr.ima08_1 = '采购料件' END IF 
        IF sr.ima08 ='X' THEN LET sr.ima08_1 = '虚拟料件' END IF 
        IF sr.ima08 ='K' THEN LET sr.ima08_1 = '配件虚拟料件' END IF 
        IF sr.ima08 ='U' THEN LET sr.ima08_1 = '自制大宗料件' END IF  
        IF sr.ima08 ='V' THEN LET sr.ima08_1 = '采购大宗料件' END IF 
        IF sr.ima08 ='R' THEN LET sr.ima08_1 = '在制途料件' END IF 
        IF sr.ima08 ='Z' THEN LET sr.ima08_1 = '杂项料件' END IF 
        IF sr.ima08 ='S' THEN LET sr.ima08_1 = '委外加工料件' END IF
        #str----add by guanyao160928
        LET l_x = ''
        SELECT instr(sr.bma01,'-') INTO l_x  FROM dual
        IF l_x> 0 THEN 
           LET sr.title = '料件名称'
        ELSE 
           LET sr.title = '客户料号'
        END IF 
        #end----add by guanyao160928
   #str---end by huanglf160815
    #str-----add by guanyao160902
      LET l_bmd04 = ''
      LET l_ima02 = ''
      LET l_ima021 = ''
      LET sr.ima021_1 = ''
      #LET l_sql = " SELECT to_char(wmsys.wm_concat(bmd04)) FROM bmd_file ", #modify by huanglf160922
      LET l_sql = " SELECT bmd04 FROM bmd_file ",  #add by huanglf160922
                  " WHERE bmd08 = '",sr.bma01,"'",
                  "   AND bmd01 = '",sr.bmb03,"'",
                  "   AND bmd05<=to_date('",g_today,"','yy/mm/dd')",
                  "   AND (bmd06 is null or bmd06 >to_date('",g_today,"','yy/mm/dd') ) "  #modify by huanglf160922
      PREPARE prep_ccc FROM l_sql
#str----add by huanglf160922
      DECLARE decl_ccc CURSOR FOR prep_ccc
      FOREACH decl_ccc INTO sr.bmd04  
        --IF cl_null(l_ima02) THEN LET l_ima02 = '' END IF 
        --IF cl_null(l_ima021) THEN LET l_ima021 = '' END IF 
        --IF cl_null(sr.ima021_1) THEN LET l_ima02 = '' END IF 
        --IF cl_null(l_bmd04) THEN LET l_bmd04 = '' END IF
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.bmd04 
       
        IF cl_null(sr.ima021_1) THEN 
          IF cl_null(l_bmd04) THEN 
            LET l_bmd04 = sr.bmd04
          ELSE 
            LET l_bmd04 = l_bmd04,",",sr.bmd04
          END IF 
           IF cl_null(l_ima02) AND NOT cl_null(l_ima021) THEN  LET sr.ima021_1 = l_ima021 END IF 
           IF cl_null(l_ima021) AND NOT cl_null(l_ima02) THEN  LET sr.ima021_1 = l_ima02  END IF 
           IF cl_null(l_ima02) AND  cl_null(l_ima021) THEN  LET sr.ima021_1 = '' END IF 
           IF NOT cl_null(l_ima02) AND NOT cl_null(l_ima021) THEN
               LET sr.ima021_1 = l_ima02,"/",l_ima021
           END IF 
        ELSE 
          IF cl_null(l_bmd04) THEN 
           LET l_bmd04 = sr.bmd04
          ELSE 
           LET l_bmd04 = l_bmd04,",",sr.bmd04
          END IF 
           IF cl_null(l_ima02) AND NOT cl_null(l_ima021) THEN   LET sr.ima021_1 = sr.ima021_1,",",l_ima021 END IF 
           IF cl_null(l_ima021) AND NOT cl_null(l_ima02)THEN  LET sr.ima021_1 =  sr.ima021_1,",",l_ima02  END IF 
           IF cl_null(l_ima02) AND  cl_null(l_ima021) THEN  LET sr.ima021_1 = sr.ima021_1 END IF 
           IF NOT cl_null(l_ima02) AND NOT cl_null(l_ima021) THEN
               LET sr.ima021_1 = sr.ima021_1,",",l_ima02,"/",l_ima021
           END IF 
           
        END IF 
      END FOREACH 
      LET sr.bmd04 = l_bmd04
      select max(ecu02) into sr.ima94
      from ecu_file 
      where ecu01=sr.bma01  
         
      LET l_n2 = 1
    #  EXECUTE prep_ccc INTO sr.bmd04  #modify by huanglf160922
    #end-----add by guanyao160802
      EXECUTE insert_prep USING sr.*
   END FOREACH                     
 
   LET l_str = l_str CLIPPED,";",tm.wc

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('cbmr002','cbmr002',l_sql,l_str)
 
END FUNCTION

