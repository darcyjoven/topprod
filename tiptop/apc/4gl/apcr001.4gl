# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apcr001.4gl
# Descriptions...: 門店下傳資料勾稽表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B70013 11/07/07 by huangtao
# Modify.........: No:FUN-B80029 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90074 11/09/07 By huangtao 檢查門店所使用的價格策略中的產品編號, 不存在於產品策略中時, 顯示提示訊息.
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           cb1       LIKE type_file.chr1,
           cb2       LIKE type_file.chr1, 
           cb3       LIKE type_file.chr1,
           cb4       LIKE type_file.chr1,
           ryg01     STRING,
           rte03     LIKE rte_file.rte03,
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD
DEFINE g_wc          STRING 
DEFINE g_str         STRING                 
DEFINE g_sql         STRING             
DEFINE l_table       STRING
DEFINE l_table1      STRING
DEFINE l_table2      STRING
DEFINE l_table3      STRING
DEFINE l_table4      STRING
DEFINE l_table5      STRING
DEFINE l_table6      STRING
DEFINE l_table7      STRING
DEFINE l_table8      STRING           #FUN-B90074 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.cb1 = ARG_VAL(7)
   LET tm.cb2 = ARG_VAL(8)
   LET tm.cb3 = ARG_VAL(9)
   LET tm.cb4 = ARG_VAL(10)
   LET tm.ryg01  = ARG_VAL(11)
   LET tm.rte03  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark

    LET g_sql=  "main.type_file.chr1"
    LET l_table = cl_prt_temptable('apcr001',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql=  "main.type_file.chr1,",
               "rtz01.rtz_file.rtz01,",
               "azw08.azw_file.azw08,",
               "rtz28.rtz_file.rtz28,",
               "rtzpos.rtz_file.rtzpos,",
               "rtd01.rtd_file.rtd01,",
               "rtf01.rtf_file.rtf01,",
               "imd01.imd_file.imd01"
           
    LET l_table1 = cl_prt_temptable('apcr0011',g_sql) CLIPPED
    IF l_table1 = -1 THEN EXIT PROGRAM END IF
    LET g_sql=  "main.type_file.chr1,",
                "lpx01.lpx_file.lpx01,",
                "lpx02.lpx_file.lpx02,",
                "lpx15.lpx_file.lpx15,",
                "lrz03.lrz_file.lrz03,",
                "lnk01.lnk_file.lnk01"
    LET l_table2 = cl_prt_temptable('apcr0012',g_sql) CLIPPED
    IF l_table2 = -1 THEN EXIT PROGRAM END IF
    LET g_sql=  "main.type_file.chr1,",
                "lph01.lph_file.lph01,",
                "lph02.lph_file.lph02,",
                "lph24.lph_file.lph24,",
                "lnk01.lnk_file.lnk01"
    LET l_table3 = cl_prt_temptable('apcr0013',g_sql) CLIPPED
    IF l_table3 = -1 THEN EXIT PROGRAM END IF
    LET g_sql= "main.type_file.chr1,",
               "rtz01.rtz_file.rtz01,",
               "azw08.azw_file.azw08,",
               "rtz28.rtz_file.rtz28,",
               "rtzpos.rtz_file.rtzpos,",
               "rtd01.rtd_file.rtd01,",
               "rtf01.rtf_file.rtf01"
    LET l_table4 = cl_prt_temptable('apcr0014',g_sql) CLIPPED
    IF l_table4 = -1 THEN EXIT PROGRAM END IF 
    LET g_sql= "main.type_file.chr1,",
               "rtz01.rtz_file.rtz01,",
               "azw08.azw_file.azw08,",
               "rte01.rte_file.rte01,",
               "rte03.rte_file.rte03,",
               "rtg01.rtg_file.rtg01,",
               "rtg03.rtg_file.rtg03,",
               "rtg04.rtg_file.rtg04"
    LET l_table5 = cl_prt_temptable('apcr0015',g_sql) CLIPPED
    IF l_table5 = -1 THEN EXIT PROGRAM END IF 
     LET g_sql= "main.type_file.chr1,",
                "rtz01.rtz_file.rtz01,",
                "azw08.azw_file.azw08,", 
                "rte01.rte_file.rte01,",  
                "rte03.rte_file.rte03,",
                "rta01.rta_file.rta01,",
                "rta03.rta_file.rta03,",
                "rta05.rta_file.rta05"
    LET l_table6 = cl_prt_temptable('apcr0016',g_sql) CLIPPED
    IF l_table6 = -1 THEN EXIT PROGRAM END IF 
     LET g_sql= "main.type_file.chr1,",
               "rtz01.rtz_file.rtz01,",
               "azw08.azw_file.azw08,",
               "rte01.rte_file.rte01,",
               "rte03.rte_file.rte03,",
               "rtg01.rtg_file.rtg01,",
               "rtg03.rtg_file.rtg03,",
               "rtg04.rtg_file.rtg04,",
               "rta01.rta_file.rta01,",
               "rta03.rta_file.rta03,",
               "rta05.rta_file.rta05"
    LET l_table7 = cl_prt_temptable('apcr0017',g_sql) CLIPPED
    IF l_table7 = -1 THEN EXIT PROGRAM END IF 
#FUN-B90074 -----------------------STA
     LET g_sql= "main.type_file.chr1,",
                "rtz01.rtz_file.rtz01,",
                "azw08.azw_file.azw08,",
                "rtg01.rtg_file.rtg01,",
                "rtg03.rtg_file.rtg03,",
                "rtz04.rtz_file.rtz04"
    LET l_table8 = cl_prt_temptable('apcr0018',g_sql) CLIPPED
    IF l_table8 = -1 THEN EXIT PROGRAM END IF 
#FUN-B90074 -----------------------END    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL apcr001_tm()        # Input print condition
    ELSE 
       CALL apcr001() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION apcr001_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          STRING,   
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_n1           LIKE type_file.num5
DEFINE l_sql          STRING
DEFINE l_ryg01       LIKE ryg_file.ryg01

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW apcr001_w AT p_row,p_col WITH FORM "apc/42f/apcr001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.cb1 = 'N'
   LET tm.cb2 = 'N' 
   LET tm.cb3 = 'N' 
   LET tm.cb4 = 'N' 
   WHILE TRUE
      INPUT BY NAME  tm.cb1,tm.cb2,tm.cb3,tm.cb4,tm.ryg01,tm.rte03,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT 
           CALL cl_qbe_display_condition(lc_qbe_sn)
           IF tm.cb1 = 'Y'  THEN
               CALL cl_set_comp_entry("ryg01",TRUE)
           ELSE
               IF tm.cb4 = 'N'  THEN
                  CALL cl_set_comp_entry("ryg01",FALSE)
               ELSE
                  CALL cl_set_comp_entry("ryg01",TRUE)
               END IF
           END IF
            IF tm.cb4 = 'Y'  THEN
               CALL cl_set_comp_entry("ryg01,rte03",TRUE)
            ELSE
               CALL cl_set_comp_entry("rte03",FALSE)
               IF tm.cb1 = 'Y'  THEN
                  CALL cl_set_comp_entry("ryg01",TRUE)
               ELSE
                  CALL cl_set_comp_entry("ryg01",FALSE)
               END IF
            END IF
              
         ON CHANGE cb1
            IF tm.cb1 = 'Y'  THEN
               CALL cl_set_comp_entry("ryg01",TRUE)
            ELSE
               IF tm.cb4 = 'N'  THEN
                  CALL cl_set_comp_entry("ryg01",FALSE)
               ELSE
                  CALL cl_set_comp_entry("ryg01",TRUE)
               END IF
            END IF

         ON CHANGE cb4
            IF tm.cb4 = 'Y'  THEN
               CALL cl_set_comp_entry("ryg01,rte03",TRUE)
            ELSE
               CALL cl_set_comp_entry("rte03",FALSE)
               IF tm.cb1 = 'Y'  THEN
                  CALL cl_set_comp_entry("ryg01",TRUE)
               ELSE
                  CALL cl_set_comp_entry("ryg01",FALSE)
               END IF
            END IF
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ryg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ryg01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.ryg01 = g_qryparam.multiret
                  DISPLAY tm.ryg01 TO ryg01
                  NEXT FIELD ryg01
            END CASE
            
         ON ACTION CONTROLR
             CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

#FUN-B50163 -------------STA
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT INPUT
#FUN-B50163 -------------END         
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help()  
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()


         AFTER INPUT 
            IF INT_FLAG THEN
               LET INT_FLAG = 0 CLOSE WINDOW apcr001_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
            END IF
            IF tm.cb1 = 'N' AND tm.cb2 = 'N' AND tm.cb3 = 'N' AND tm.cb4 = 'N' THEN
               CONTINUE INPUT
            END IF
            IF cl_null(tm.ryg01) THEN
               DECLARE sel_ryg_curs CURSOR FOR SELECT ryg01 FROM ryg_file WHERE rygacti = 'Y'
               FOREACH sel_ryg_curs INTO l_ryg01
                  IF cl_null(tm.ryg01) THEN
                     LET tm.ryg01 =  l_ryg01
                  ELSE
                     LET tm.ryg01 = tm.ryg01,"|",l_ryg01
                  END IF
               END FOREACH
            END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW apcr001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 

#FUN-B50163 -------------STA
     IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-B50163 -------------END
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='apcr001'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('apcr001','9031',1)
         ELSE
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.cb1 CLIPPED,"'",
                       " '",tm.cb2 CLIPPED,"'",
                       " '",tm.cb3 CLIPPED,"'" ,
                       " '",tm.cb4 CLIPPED,"'" ,
                       " '",tm.ryg01 CLIPPED,"'" ,
                       " '",tm.rte03 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('apcr001',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW apcr001_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL apcr001()
      ERROR ""
   END WHILE
   CLOSE WINDOW apcr001_w
    
END FUNCTION


FUNCTION apcr001() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rtz28 LIKE rtz_file.rtz28,
                    rtzpos LIKE rtz_file.rtzpos,
                    rtd01 LIKE rtd_file.rtd01,
                    rtf01 LIKE rtf_file.rtf01,
                    imd01 LIKE imd_file.imd01
                    END RECORD,
          sr1       RECORD
                    lpx01 LIKE lpx_file.lpx01,
                    lpx02 LIKE lpx_file.lpx02,
                    lpx15 LIKE lpx_file.lpx15,
                    lrz03 LIKE lrz_file.lrz03,
                    lnk01 LIKE lnk_file.lnk01
                    END RECORD,
          sr2       RECORD
                    lph01 LIKE lph_file.lph01,
                    lph02 LIKE lph_file.lph02,
                    lph24 LIKE lph_file.lph24,
                    lnk01 LIKE lnk_file.lnk01
                    END RECORD,
          sr3       RECORD 
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rtz28 LIKE rtz_file.rtz28,
                    rtzpos LIKE rtz_file.rtzpos,
                    rtd01 LIKE rtd_file.rtd01,
                    rtf01 LIKE rtf_file.rtf01
                    END RECORD,
          sr4       RECORD 
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rte01 LIKE rte_file.rte01,
                    rte03 LIKE rte_file.rte03,
                    rtg01 LIKE rtg_file.rtg01,
                    rtg03 LIKE rtg_file.rtg03,
                    rtg04 LIKE rtg_file.rtg04
                    END RECORD,
          sr5       RECORD 
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rte01 LIKE rte_file.rte01,
                    rte03 LIKE rte_file.rte03,
                    rta01 LIKE rta_file.rta01,
                    rta03 LIKE rta_file.rta03,
                    rta05 LIKE rta_file.rta05
                    END RECORD,
          sr6       RECORD 
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rte01 LIKE rte_file.rte01,
                    rte03 LIKE rte_file.rte03,
                    rtg01 LIKE rtg_file.rtg01,
                    rtg03 LIKE rtg_file.rtg03,
                    rtg04 LIKE rtg_file.rtg04,
                    rta01 LIKE rta_file.rta01,
                    rta03 LIKE rta_file.rta03,
                    rta05 LIKE rta_file.rta05
                    END RECORD,
#FUN-B90074 -----------------------STA
          sr7       RECORD
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rtg01 LIKE rtg_file.rtg01,
                    rtg03 LIKE rtg_file.rtg03,
                    rtz04 LIKE rtz_file.rtz04
                    END RECORD
#FUN-B90074 -----------------------END                         
        
DEFINE tok            base.StringTokenizer      
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_n          LIKE type_file.num5

    DROP TABLE apcr001_tmp1
    CREATE TEMP TABLE apcr001_tmp1(
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rte01 LIKE rte_file.rte01,
                    rte03 LIKE rte_file.rte03,
                    rtg01 LIKE rtg_file.rtg01,
                    rtg03 LIKE rtg_file.rtg03,
                    rtg04 LIKE rtg_file.rtg04)
     DELETE FROM  apcr001_tmp1
     DROP TABLE apcr001_tmp2 
     CREATE TEMP TABLE apcr001_tmp2(
                    rtz01 LIKE rtz_file.rtz01,
                    azw08 LIKE azw_file.azw08,
                    rte01 LIKE rte_file.rte01,
                    rte03 LIKE rte_file.rte03,
                    rta01 LIKE rta_file.rta01,
                    rta03 LIKE rta_file.rta03,
                    rta05 LIKE rta_file.rta05)
     DELETE FROM  apcr001_tmp2               
                                  
    INITIALIZE sr.* TO NULL
    INITIALIZE sr1.* TO NULL
    INITIALIZE sr2.* TO NULL
    INITIALIZE sr3.* TO NULL
    INITIALIZE sr4.* TO NULL
    INITIALIZE sr5.* TO NULL
    INITIALIZE sr6.* TO NULL
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80029   ADD
       EXIT PROGRAM
    END IF  
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?)" 
              
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep1:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF         

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
              " VALUES(?,?,?,?,?,?)" 
              
    PREPARE insert_prep2 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep2:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF 

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
              " VALUES(?,?,?,?,?)" 
              
    PREPARE insert_prep3 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep3:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF 

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
              " VALUES(?,?,?,?,?,?,?)" 
              
    PREPARE insert_prep4 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep4:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF 

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?)" 
              
    PREPARE insert_prep5 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep5:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?)" 
              
    PREPARE insert_prep6 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep6:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table7 CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?)" 
              
    PREPARE insert_prep7 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep7:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80029   ADD
       EXIT PROGRAM
    END IF
#FUN-B90074 ------------------STA
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table8 CLIPPED,
              " VALUES(?,?,?,?,?,?)" 
              
    PREPARE insert_prep8 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep8:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    
    END IF
#FUN-B90074 ------------------END        
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
    CALL cl_del_data(l_table2)
    CALL cl_del_data(l_table3)
    CALL cl_del_data(l_table4)
    CALL cl_del_data(l_table5)
    CALL cl_del_data(l_table6)
    CALL cl_del_data(l_table7)
    CALL cl_del_data(l_table8)                 #FUN-B90074  add    
    EXECUTE insert_prep USING  'Y' 
    LET tok = base.StringTokenizer.create(tm.ryg01,"|") 
    WHILE tok.hasMoreTokens() 
        LET l_plant  = tok.nextToken() 
        SELECT COUNT(*) INTO l_n FROM ryg_file
         WHERE ryg01 = l_plant
           AND rygacti = 'Y'
        IF l_n = 0 THEN
           CONTINUE WHILE
        END IF
        IF tm.cb1 = 'Y' THEN
           LET l_sql = "SELECT rtz01,azw08,rtz28,rtzpos,rtd01,rtf01,imd01 FROM ",cl_get_target_table(l_plant,'azw_file'),
                      " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON azw01 = rtz01 ",
                      " LEFT JOIN ",cl_get_target_table(l_plant,'rtd_file')," ON rtz04 = rtd01 ",
                      " LEFT JOIN ",cl_get_target_table(l_plant,'rtf_file')," ON rtz05 = rtf01 ",
                      " LEFT JOIN ( SELECT imd01 FROM ",cl_get_target_table(l_plant,'imd_file'),
                      "              WHERE imdacti = 'Y' AND imd20 = '",l_plant,"'",
                      "                AND imd01 NOT IN (SELECT jce02 FROM ",cl_get_target_table(l_plant,'jce_file'),"))",
                      " ON rtz07 = imd01 ",
                      " WHERE rtz01 = '",l_plant,"' AND azw01 IN ( SELECT DISTINCT ryg01 FROM ryg_file WHERE rygacti = 'Y') ",        
                      " AND rtzpos IN ('1', '2') AND (rtz28 <> 'Y' OR rtd01 IS NULL OR rtf01 IS NULL OR imd01 IS NULL) "                                        
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
           PREPARE sel_rtz_pre1 FROM l_sql
           EXECUTE sel_rtz_pre1 INTO sr.*
           IF NOT STATUS THEN
              EXECUTE insert_prep1 USING  'Y',sr.*
           END IF
        END IF

        IF tm.cb4 = 'Y' THEN
           LET l_sql = " SELECT rtz01,azw08,rtz28,rtzpos,rtd01,rtf01 FROM ",cl_get_target_table(l_plant,'azw_file'),
                       " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON azw01 = rtz01 ",
                       " LEFT JOIN ",cl_get_target_table(l_plant,'rtd_file')," ON rtz04 = rtd01 ",
                       " LEFT JOIN ",cl_get_target_table(l_plant,'rtf_file')," ON rtz05 = rtf01 ",
                       " WHERE rtz01 = '",l_plant,"' AND azw01 IN ( SELECT DISTINCT ryg01 FROM ryg_file WHERE rygacti = 'Y') "        
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
           PREPARE sel_rtz_pre2 FROM l_sql
           EXECUTE sel_rtz_pre2 INTO sr3.*
           IF NOT STATUS THEN
              EXECUTE insert_prep4 USING  'Y',sr3.*
           END IF 
           IF sr3.rtz28 = 'Y' AND NOT cl_null(sr3.rtd01) AND NOT cl_null(sr3.rtf01) THEN
              LET l_sql = " SELECT rtz01,azw08,rte01,rte03,rtg01,rtg03,rtg04 FROM ",cl_get_target_table(l_plant,'azw_file'),
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON azw01 = rtz01 ",
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rte_file')," ON rtz04 = rte01 ",
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rtg_file')," ON rtz05 = rtg01 AND rte03 = rtg03 ",
                          " WHERE rtz01 = '",l_plant,"' AND azw01 IN ( SELECT DISTINCT ryg01 FROM ryg_file WHERE rygacti = 'Y') "
              IF NOT cl_null(tm.rte03) THEN
                 LET l_sql = l_sql," AND rte03 = '",tm.rte03,"'"
              END IF
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
              PREPARE sel_rtg_pre FROM l_sql
              DECLARE apcr001_curs3 CURSOR FOR sel_rtg_pre
              FOREACH apcr001_curs3  INTO sr4.*
                   INSERT INTO  apcr001_tmp1 VALUES(sr4.*)
                   EXECUTE insert_prep5 USING  'Y',sr4.*
              END FOREACH
              LET l_sql = " SELECT rtz01,azw08,rte01,rte03,rta01,rta03,rta05 FROM ",cl_get_target_table(l_plant,'azw_file'),
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON azw01 = rtz01 ",
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rte_file')," ON rtz04 = rte01 ",
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rta_file')," ON rte03 = rta01 ",
                          " WHERE rtz01 = '",l_plant,"' AND azw01 IN ( SELECT DISTINCT ryg01 FROM ryg_file WHERE rygacti = 'Y') "
              IF NOT cl_null(tm.rte03) THEN
                 LET l_sql = l_sql," AND rte03 = '",tm.rte03,"'"
              END IF
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
              PREPARE sel_rta_pre FROM l_sql
              DECLARE apcr001_curs4 CURSOR FOR sel_rta_pre
              FOREACH apcr001_curs4  INTO sr5.*
                   INSERT INTO  apcr001_tmp2 VALUES(sr5.*)
                   EXECUTE insert_prep6 USING  'Y',sr5.*
              END FOREACH
              
           END IF 
#FUN-B90074 -------------------------STA
           LET l_sql = " SELECT rtz01,azw08,rtg01,rtg03,rtz04 FROM ",cl_get_target_table(l_plant,'azw_file'),
                                                                 ",",cl_get_target_table(l_plant,'rtz_file'),
                       " LEFT JOIN ",cl_get_target_table(l_plant,'rtg_file')," ON rtz05 = rtg01 ",
                       " LEFT JOIN ",cl_get_target_table(l_plant,'rte_file')," ON rtz04 = rte01 AND rtg03 = rte03 ",
                       " WHERE azw01 = rtz01 ",
                       "   AND rtz01 = '",l_plant,"' AND azw01 IN ( SELECT DISTINCT ryg01 FROM ryg_file WHERE rygacti = 'Y') ",
                       "   AND rte03 IS NULL "
           IF NOT cl_null(tm.rte03) THEN
              LET l_sql = l_sql," AND rtg03 = '",tm.rte03,"'"
           END IF
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE sel_rte_pre FROM l_sql
           DECLARE apcr001_curs6 CURSOR FOR sel_rte_pre
           FOREACH apcr001_curs6 INTO sr7.*
               EXECUTE insert_prep8 USING  'Y',sr7.*
           END FOREACH
#FUN-B90074 -------------------------END              
        END IF      
    END WHILE

    IF  tm.cb2 = 'Y' THEN
         LET l_sql = " SELECT lpx01,lpx02,lpx15,lrz03,lnk01 FROM lpx_file ",
                     " LEFT JOIN lrz_file ON lpx28 = lrz01 ",
                     " LEFT JOIN (  SELECT DISTINCT lnk01 FROM lnk_file  WHERE lnk02 = '2' AND lnk05 = 'Y' )",
                     " ON lpx01 = lnk01 ",
                     #" WHERE lpx26 IN ('1', '3')",   #FUN-D10040 mark
                     " WHERE lpx38 = 'Y'",            #FUN-D10040 add
                     " AND lpxpos IN ('1', '2')",
                     " AND (lpx15 <> 'Y' OR lrz03 <> 'Y' OR lrz03 IS NULL OR lnk01 IS NULL)"

         PREPARE sel_lpx_pre FROM l_sql
         DECLARE apcr001_curs1 CURSOR FOR sel_lpx_pre
         FOREACH apcr001_curs1  INTO sr1.*
            EXECUTE insert_prep2 USING  'Y',sr1.*
         END FOREACH
    END IF
    IF tm.cb3 = 'Y' THEN
       LET l_sql = " SELECT lph01 ,lph02,lph24,lnk01 FROM lph_file ",
                   " LEFT JOIN ( SELECT DISTINCT lnk01 FROM lnk_file  WHERE lnk02 = '1' AND  lnk05 = 'Y')",
                   " ON lph01 = lnk01 ",
                   " WHERE lphpos IN ('1', '2') AND  (lph24 <> 'Y' OR lnk01 IS NULL)"
       PREPARE sel_lph_pre FROM l_sql
       DECLARE apcr001_curs2 CURSOR FOR sel_lph_pre 
       FOREACH apcr001_curs2  INTO sr2.*
          EXECUTE insert_prep3 USING 'Y',sr2.*
       END FOREACH
    END IF
    DECLARE apcr001_curs5 CURSOR FOR SELECT a.rtz01,a.azw08,a.rte01,a.rte03,rtg01,rtg03,rtg04,rta01,rta03,rta05
                                       FROM apcr001_tmp1 a,apcr001_tmp2 b
                                      WHERE a.rtz01 = b.rtz01 AND a.azw08 = b.azw08
                                        AND a.rte01 = b.rte01 AND a.rte03 = b.rte03
    FOREACH  apcr001_curs5  INTO sr6.*  
       EXECUTE insert_prep7 USING 'Y',sr6.*
    END FOREACH   

    LET g_str = ''
    LET g_wc = ''
    
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table7 CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table8 CLIPPED     #FUN-B90074 add 
                
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'ryg01,rte03')
             RETURNING g_wc
        LET g_str = g_wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   LET g_str = g_str,";",tm.cb1,";",tm.cb2,';',tm.cb3,";",tm.cb4

   CALL cl_prt_cs3('apcr001','apcr001',l_sql,g_str)  

END FUNCTION
#FUN-B70013 
