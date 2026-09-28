# Prog. Version..:
#
# Pattern name...: csfr006.4gl
# Descriptions...: Run Card单打印
# Date & Author..: 16/07/13 By huanglf
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
 
   IF (NOT cl_setup("csf")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="shm05.shm_file.shm05,",
             "oea10.oea_file.oea10,",
             "shm01.shm_file.shm01,",
             "shm012.shm_file.shm012,",
             "shm08.shm_file.shm08,",
             
             "sgm03.sgm_file.sgm03,",
             "sgm04.sgm_file.sgm04,",
             "sgm45.sgm_file.sgm45,",
             "ta_sgm01.sgm_file.ta_sgm01,",
             "ta_sgm02.sgm_file.ta_sgm02,",

             "ta_sgm03.sgm_file.ta_sgm03,",
             "ima02.ima_file.ima02,",
             "imaud07.ima_file.imaud07,",
             "imaud10.ima_file.imaud10,",
             "ta_shm03.shm_file.ta_shm03,",

             "sfbud02.sfb_file.sfbud02,",
             "sfb86.sfb_file.sfb86"   #add by huanglf170119
             

   LET  l_table = cl_prt_temptable('csfr006',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"                     
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
      THEN CALL csfr006_tm(0,0)          
      ELSE
           CALL csfr006()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr006_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr006_w AT p_row,p_col WITH FORM "csf/42f/csfr006"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shm01,shm13,shm012,shm05
                              
     
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
              WHEN INFIELD(shm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm1"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shm01
                 NEXT FIELD shm01
              WHEN INFIELD(shm012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_shm012"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shm012
                 NEXT FIELD shm012
               WHEN INFIELD(shm05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_shm05"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shm05
                 NEXT FIELD shm05
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr006_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr006_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr006'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr006','9031',1)
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
         CALL cl_cmdat('csfr006',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr006()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr006_w
END FUNCTION


FUNCTION csfr006()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    shm05    LIKE shm_file.shm05,    #厂内料号
                    oea10    LIKE oea_file.oea10,    #客户料号
                    shm01    LIKE shm_file.shm01,    #Run Card单号
                    shm012   LIKE shm_file.shm012,   #工单单号
                    shm08    LIKE shm_file.shm08,    #下料数量 

                    sgm03    LIKE sgm_file.sgm03,    #工艺序号
                    sgm04    LIKE sgm_file.sgm04,    #作业编号
                    sgm45    LIKE sgm_file.sgm45,    #作业名称
                    ta_sgm01 LIKE sgm_file.ta_sgm01, #生产说明
                    ta_sqm02 LIKE sgm_file.ta_sgm02, #使用工具

                    ta_sgm03 LIKE sgm_file.ta_sgm03, #使用程序
                    ima02    LIKE ima_file.ima02,
                    imaud07  LIKE ima_file.imaud07,
                    imaud10  LIKE ima_file.imaud10,
                    ta_shm03 LIKE shm_file.ta_shm03,

                    sfbud02  LIKE sfb_file.sfbud02,
                    sfb86    LIKE sfb_file.sfb86    #add by huanglf170119
            
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr006' 
 
     LET tm.wc = tm.wc CLIPPED 
     
LET l_sql="select shm05,oea10,shm01,shm012,shm08,sgm03,sgm04,sgm45,ta_sgm01,ta_sgm02,ta_sgm03,'','','',ta_shm03,sfbud02,sfb86",
           " from shm_file,sfb_file",
           "      left join oea_file on sfb22=oea01,sgm_file ",
           " where ",tm.wc ,
           "   AND shm01=sgm01 ",
           "   AND shm012 = sfb01",
           "   order by shm01,sgm03 " 
 
     PREPARE csfr006_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr006_curs1 CURSOR FOR csfr006_prepare1
 
     FOREACH csfr006_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,imaud07,imaud10 INTO sr.ima02,sr.imaud07,sr.imaud10 FROM ima_file WHERE ima01 = sr.shm05
     #  SELECT sfbud02  INTO sr.sfbud02 FROM  sfb_file WHERE sfb01 = sr.shm012
       EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shm01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr006','csfr006',g_sql,g_str)

END FUNCTION



