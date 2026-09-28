# Prog. Version..:
#
# Pattern name...: cqcr001.4gl
# Descriptions...: 送货单打印
# Date & Author..: 16/03/03 By huanglf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1   
              END RECORD  

DEFINE tm1 RECORD  qcs04_start LIKE type_file.num5,
                   qcs04_end   LIKE type_file.num5 
            END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="qcs04.qcs_file.qcs04,",
             "qcs09.qcs_file.qcs09,",
             "qcs091.qcs_file.qcs091,",
             "qcs091_1.qcs_file.qcs091,",
             "qcs091_2.qcs_file.qcs091,",
             
             "qcs091_3.qcs_file.qcs091,",
             "qcs091_4.qcs_file.qcs091,",
             "qcs091_5.qcs_file.qcs091,",
             "qcs091_6.qcs_file.qcs091,",
             "qcs091_7.qcs_file.qcs091,",

             "qcs091_8.qcs_file.qcs091,",
             "qcs091_9.qcs_file.qcs091,",
             "qcs091_10.qcs_file.qcs091,",
             "qcs091_11.qcs_file.qcs091,",
             "qcs091_12.qcs_file.qcs091,",

             "qcs22.qcs_file.qcs22,",
             "qcs22_1.qcs_file.qcs22,",
             "qcs22_2.qcs_file.qcs22,",
             "qcs22_3.qcs_file.qcs22,",
             "qcs22_4.qcs_file.qcs22,",

             "qcs22_5.qcs_file.qcs22,",
             "qcs22_6.qcs_file.qcs22,",
             "qcs22_7.qcs_file.qcs22,",
             "qcs22_8.qcs_file.qcs22,",
             "qcs22_9.qcs_file.qcs22,",

             "qcs22_10.qcs_file.qcs22,",
             "qcs22_11.qcs_file.qcs22,",
             "qcs22_12.qcs_file.qcs22,",
             "qcs021.qcs_file.qcs021"    


   LET  l_table = cl_prt_temptable('cqcr001',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11) 
   
   IF cl_null(tm.wc)
      THEN CALL cqcr001_tm(0,0)          
      ELSE
           CALL cqcr001()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cqcr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000 
DEFINE l_n   LIKE type_file.num5
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cqcr001_w AT p_row,p_col WITH FORM "cqc/42f/cqcr001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON qcs021                              
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(qcs021)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qcs021
                 NEXT FIELD qcs021
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
         
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cqcr001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm1.qcs04_start,tm1.qcs04_end  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      --AFTER FIELD more
         --IF tm.more = 'Y'
            --THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                --g_bgjob,g_time,g_prtway,g_copies)
                      --RETURNING g_pdate,g_towhom,g_rlang,
                                --g_bgjob,g_time,g_prtway,g_copies
         --END IF
        AFTER FIELD qcs04_end
        IF tm1.qcs04_start > tm1.qcs04_end THEN 
        CALL cl_err('','hlf01',0)
        NEXT FIELD qcs04_end
        END IF 
        
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cqcr001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cqcr001'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cqcr001','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cqcr001',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cqcr001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cqcr001()
   ERROR ""
END WHILE
   CLOSE WINDOW cqcr001_w
END FUNCTION


FUNCTION cqcr001()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    LIKE type_file.chr1000,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    qcs04     LIKE qcs_file.qcs04,
                    qcs09     LIKE qcs_file.qcs09,
                    qcs091    LIKE qcs_file.qcs091,
                    qcs091_1  LIKE qcs_file.qcs091,
                    qcs091_2  LIKE qcs_file.qcs091,
                    
                    qcs091_3  LIKE qcs_file.qcs091,
                    qcs091_4  LIKE qcs_file.qcs091,
                    qcs091_5  LIKE qcs_file.qcs091,
                    qcs091_6  LIKE qcs_file.qcs091,
                    qcs091_7  LIKE qcs_file.qcs091,
                    
                    qcs091_8  LIKE qcs_file.qcs091,
                    qcs091_9  LIKE qcs_file.qcs091,
                    qcs091_10 LIKE qcs_file.qcs091,
                    qcs091_11 LIKE qcs_file.qcs091,
                    qcs091_12 LIKE qcs_file.qcs091,

                    qcs22     LIKE qcs_file.qcs22,
                    qcs22_1   LIKE qcs_file.qcs22,
                    qcs22_2   LIKE qcs_file.qcs22,
                    qcs22_3   LIKE qcs_file.qcs22,
                    qcs22_4   LIKE qcs_file.qcs22,

                    qcs22_5   LIKE qcs_file.qcs22,
                    qcs22_6   LIKE qcs_file.qcs22,
                    qcs22_7   LIKE qcs_file.qcs22,
                    qcs22_8   LIKE qcs_file.qcs22,
                    qcs22_9   LIKE qcs_file.qcs22,

                    qcs22_10  LIKE qcs_file.qcs22,
                    qcs22_11  LIKE qcs_file.qcs22,
                    qcs22_12  LIKE qcs_file.qcs22,
                    qcs021    LIKE qcs_file.qcs021

                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_start   LIKE type_file.chr20
   DEFINE l_end     LIKE type_file.chr20   

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_month        LIKE type_file.chr20
   DEFINE l_qcs091_1  LIKE qcs_file.qcs091,
          l_qcs091_2  LIKE qcs_file.qcs091,
          l_qcs091_3  LIKE qcs_file.qcs091,
          l_qcs091_4  LIKE qcs_file.qcs091,
          l_qcs091_5  LIKE qcs_file.qcs091,
          l_qcs091_6  LIKE qcs_file.qcs091,
          l_qcs091_7  LIKE qcs_file.qcs091,
          l_qcs091_8  LIKE qcs_file.qcs091,
          l_qcs091_9  LIKE qcs_file.qcs091,
          l_qcs091_10 LIKE qcs_file.qcs091,
          l_qcs091_11 LIKE qcs_file.qcs091,
          l_qcs091_12 LIKE qcs_file.qcs091,
          l_qcs22_1  LIKE qcs_file.qcs22,
          l_qcs22_2  LIKE qcs_file.qcs22,
          l_qcs22_3  LIKE qcs_file.qcs22,
          l_qcs22_4  LIKE qcs_file.qcs22,
          l_qcs22_5  LIKE qcs_file.qcs22,
          l_qcs22_6  LIKE qcs_file.qcs22,
          l_qcs22_7  LIKE qcs_file.qcs22,
          l_qcs22_8  LIKE qcs_file.qcs22,
          l_qcs22_9  LIKE qcs_file.qcs22,
          l_qcs22_10  LIKE qcs_file.qcs22,
          l_qcs22_11  LIKE qcs_file.qcs22,
          l_qcs22_12  LIKE qcs_file.qcs22
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cqcr001' 
 
     LET tm.wc = tm.wc CLIPPED 
     
   #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL

 LET l_qcs091_1 = 0 LET l_qcs091_2 = 0 LET l_qcs091_3 = 0 
 LET l_qcs091_4 = 0 LET l_qcs091_5 = 0 LET l_qcs091_6 = 0
 LET l_qcs091_7 = 0 LET l_qcs091_8 = 0 LET l_qcs091_9 = 0 
 LET l_qcs091_10 = 0 LET l_qcs091_11 = 0 LET l_qcs091_12 = 0
 LET l_qcs22_1 = 0 LET l_qcs22_2 = 0 LET l_qcs22_3 = 0 
 LET l_qcs22_4 = 0 LET l_qcs22_5 = 0 LET l_qcs22_6 = 0
 LET l_qcs22_7 = 0 LET l_qcs22_8 = 0 LET l_qcs22_9 = 0 
 LET l_qcs22_10 = 0 LET l_qcs22_11 = 0 LET l_qcs22_12 = 0


 
LET l_sql="select year(qcs04),month(qcs04),qcs091,qcs09,qcs22,qcs021 ",
           " from qcs_file ",
           " WHERE ",tm.wc CLIPPED,"AND Month(qcs04) between ",tm1.qcs04_start,
           " and ",tm1.qcs04_end," and year(qcs04) = ",year(g_today)
     PREPARE cqcr001_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cqcr001_curs1 CURSOR FOR cqcr001_prepare1
      
     FOREACH cqcr001_curs1 INTO sr.*
 
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET l_month = Month(sr.qcs04)
        CASE l_month
     WHEN '1'
        IF sr.qcs09='1' THEN
        LET  l_qcs091_1 = l_qcs091_1 + sr.qcs091
        END IF 
        LET  l_qcs22_1= l_qcs22_1 + sr.qcs22
     WHEN '2'
        IF sr.qcs09='1' THEN
        LET  l_qcs091_2 = l_qcs091_2+ sr.qcs091
        END IF
        LET  l_qcs22_2 = l_qcs22_2 + sr.qcs22 
     WHEN '3'
        IF sr.qcs09='1' THEN
        LET  l_qcs091_3 = l_qcs091_3 + sr.qcs091
        END IF
        LET  l_qcs22_3 = sr.qcs22_3 + sr.qcs22 
     WHEN '4'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_4 = l_qcs091_4+ sr.qcs091
        END IF 
        LET  l_qcs22_4 = l_qcs22_4 + sr.qcs22 
     WHEN '5'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_5 = l_qcs091_5 + sr.qcs091
        END IF 
        LET l_qcs22_5 = l_qcs22_5 + sr.qcs22 
     WHEN '6'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_6 = l_qcs091_6 + sr.qcs091
        END IF 
        LET  l_qcs22_6 = l_qcs22_6 + sr.qcs22 
     WHEN '7'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_7 = l_qcs091_7 + sr.qcs091
        END IF 
        LET  l_qcs22_7 = l_qcs22_7 + sr.qcs22 
     WHEN '8'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_8 = l_qcs091_8 + sr.qcs091
        END IF 
        LET  l_qcs22_8 = l_qcs22_8 + sr.qcs22 
     WHEN '9'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_9 = l_qcs091_9 + sr.qcs091
        END IF 
        LET  l_qcs22_9 = l_qcs22_9 + sr.qcs22 
     WHEN '10'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_10 = l_qcs091_10 + sr.qcs091
        END IF 
        LET  l_qcs22_10 = l_qcs22_10 + sr.qcs22 
     WHEN '11'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_11 = l_qcs091_11 + sr.qcs091
        END IF 
        LET  l_qcs22_11 = l_qcs22_11 + sr.qcs22 
     WHEN '12'
        IF sr.qcs09='1' THEN 
        LET  l_qcs091_12 = l_qcs091_12 + sr.qcs091
        END IF 
        LET  l_qcs22_12 = l_qcs22_12 + sr.qcs22 
   END CASE
      
    
     END FOREACH
     LET sr.qcs091_1 = l_qcs091_1
     LET sr.qcs091_2 = l_qcs091_2
     LET sr.qcs091_3 = l_qcs091_3
     LET sr.qcs091_4 = l_qcs091_4 
     LET sr.qcs091_5 = l_qcs091_5
     LET sr.qcs091_6 = l_qcs091_6
     LET sr.qcs091_7 = l_qcs091_7
     LET sr.qcs091_8 = l_qcs091_8
     LET sr.qcs091_9 = l_qcs091_9
     LET sr.qcs091_10 = l_qcs091_10
     LET sr.qcs091_11 = l_qcs091_11
     LET sr.qcs091_12 = l_qcs091_12
     LET sr.qcs22_1 = l_qcs22_1
     LET sr.qcs22_2 = l_qcs22_2
     LET sr.qcs22_3 = l_qcs22_3
     LET sr.qcs22_4 = l_qcs22_4 
     LET sr.qcs22_5 = l_qcs22_5
     LET sr.qcs22_6 = l_qcs22_6
     LET sr.qcs22_7 = l_qcs22_7
     LET sr.qcs22_8 = l_qcs22_8
     LET sr.qcs22_9 = l_qcs22_9
     LET sr.qcs22_10 = l_qcs22_10
     LET sr.qcs22_11 = l_qcs22_11
     LET sr.qcs22_12 = l_qcs22_12
   EXECUTE insert_prep USING sr.*
   
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'qcs021')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cqcr001','cqcr001',g_sql,g_str)

END FUNCTION

--FUNCTION r002_table()
  --DROP TABLE cqcr002_tmp
  --CREATE TEMP TABLE cqcr002_tmp(
                    --qcs04    LIKE qcs_file.qcs04,   
                    --qcs01    LIKE qcs_file.qcs01,   
                    --qcs02    LIKE qcs_file.qcs02,   
                    --qcs05    LIKE qcs_file.qcs05,   
                    --qcs021   LIKE qcs_file.qcs021,  
                    --ima02    LIKE ima_file.ima02,  
                    --qcs091   LIKE qcs_file.qcs091,  
                    --qcs09    LIKE qcs_file.qcs09,   
                    --qcs22    LIKE qcs_file.qcs22,   
                    --qcu04    LIKE qcu_file.qcu04,  
                    --qce03    LIKE qce_file.qce03,   
                    --sum1     LIKE type_file.num5,   
                    --sum2     LIKE type_file.num5,  
                    --sum3     LIKE qcs_file.qcs22,  
                    --sum4     LIKE qcs_file.qcs22,
                    --pmc03    LIKE pmc_file.pmc03 )   
                   --
                                    --
		--
--END FUNCTION
--
