# Prog. Version..:
#
# Pattern name...: capr330.4gl
# Descriptions...: 付款申请单打印
# Date & Author..: 16/08/01 By huanglf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
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
 
   IF (NOT cl_setup("cap")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="apf01.apf_file.apf01,",
             "apf05.apf_file.apf05,",
             "gem02.gem_file.gem02,",
             "apf02.apf_file.apf02,",
             "apf03.apf_file.apf03,",
             
             "pmc081.pmc_file.pmc081,",
             "pmf02.pmf_file.pmf02,",
             "nmt02.nmt_file.nmt02,",
             "pmf03.pmf_file.pmf03,",
             "apf06.apf_file.apf06,",
        
             "azi02.azi_file.azi02,",
             "apf08f.apf_file.apf08f,",
             "apg04.apg_file.apg04,",
             "apc12.type_file.chr1000,",
             "pmc17.pmc_file.pmc17,",

             "pma02.pma_file.pma02,",
             "apc04.apc_file.apc04"
             
             
             

   LET  l_table = cl_prt_temptable('capr330',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"                     
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
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
   
   IF cl_null(tm.wc)
      THEN CALL capr330_tm(0,0)          
      ELSE
           CALL capr330()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION capr330_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW capr330_w AT p_row,p_col WITH FORM "cap/42f/capr330"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apf01,apf02
     
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
              WHEN INFIELD(apf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_apf01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apf01
                 NEXT FIELD apf01
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
      LET INT_FLAG = 0 CLOSE WINDOW capr330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 CLOSE WINDOW capr330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='capr330'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('capr330','9031',1)
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
                      #   " '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('capr330',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW capr330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL capr330()
   ERROR ""
END WHILE
   CLOSE WINDOW capr330_w
END FUNCTION


FUNCTION capr330()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    apf01    LIKE apf_file.apf01,    #单据编号
                    apf05    LIKE apf_file.apf05,    #部门编码
                    gem02    LIKE gem_file.gem02,    #部门名称
                    apf02    LIKE apf_file.apf02,    #付款日期
                    apf03    LIKE apf_file.apf03,    #供应商编号 

                    pmc081   LIKE pmc_file.pmc081,   #供应商名称
                    pmf02    LIKE pmf_file.pmf02,    #银行编号
                    nmt02    LIKE nmt_file.nmt02,    #银行名称
                    pmf03    LIKE pmf_file.pmf03,    #银行账号
                    apf06    LIKE apf_file.apf06,    #币别
                    
                    azi02    LIKE azi_file.azi02,    #币别名称
                    apf08f   LIKE apf_file.apf08f,   #实际付款金额
                    apg04    LIKE apg_file.apg04,    
                    apc12    LIKE type_file.chr1000,
                    pmc17    LIKE pmc_file.pmc17,    #付款条件编号

                    pma02    LIKE pma_file.pma02,    #付款条件
                    apc04    LIKE apc_file.apc04
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='capr330' 
 
     LET tm.wc = tm.wc CLIPPED 
     
LET l_sql="select apf01,apf05,'',apf02,apf03,'','','','',apf06,'',apf08f,'','','','',''",
           " from apf_file",
           " where ",tm.wc ,
           "   order by apf01 " 
 
     PREPARE capr330_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE capr330_curs1 CURSOR FOR capr330_prepare1
 
     FOREACH capr330_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT pmf02,pmf03 INTO sr.pmf02,sr.pmf03 FROM pmf_file WHERE pmf01 = sr.apf03
       SELECT nmt02 INTO sr.nmt02 FROM nmt_file WHERE nmt01 = sr.pmf02
       SELECT azi02 INTO sr.azi02 FROM azi_file WHERE azi01 = sr.apf06
       SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.apf05
       SELECT pmc081 INTO sr.pmc081 FROM  pmc_file WHERE pmc01 = sr.apf03
       
       SELECT  to_char(wmsys.wm_concat(apc12)),apc04 INTO sr.apc12,sr.apc04  FROM  apg_file,apc_file 
       WHERE  apg01 = sr.apf01 AND  apc01 = apg04
       SELECT pma02 INTO sr.pma02 FROM pmc_file,pma_file WHERE pmc01 = sr.apf03 AND pmc17 = pma01 
    
       EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'apf01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('capr330','capr330',g_sql,g_str)

END FUNCTION