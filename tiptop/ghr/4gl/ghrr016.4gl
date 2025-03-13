# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr016.4gl
# Descriptions...: 用人单位退工（减员）登记表
# Date & Author..: 13/08/21 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,  
            hrat03  LIKE hrat_file.hrat03,      #公司编号
            hrat04  LIKE hrat_file.hrat04,      #基准日期
            hrat01  LIKE hrat_file.hrat01,
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*                    
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ghr")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = " hrat03_name.type_file.chr50, hrat02.hrat_file.hrat02  ,",
               " hrat22_name.type_file.chr50, hrat36.hrat_file.hrat36  ,",
               " hrat13.hrat_file.hrat13,     hrat49.hrat_file.hrat49  ,",
               " hrat45.hrat_file.hrat45,     hrbf08.hrbf_file.hrbf08  ,",
               " hrbf09.hrbf_file.hrbf09                                "

                             
   LET l_table = cl_prt_temptable('ghrr016',g_sql) CLIPPED   # 产生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table产生

   LET g_pdate  = ARG_VAL(1)                #報表列印參數設定.Print date # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)              #報表列印參數設定.Background job
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)                          
   LET g_rep_user = ARG_VAL(11)                       
   LET g_rep_clas = ARG_VAL(12)                       
   LET g_template = ARG_VAL(13)                      
   LET g_xml.subject = ARG_VAL(14)
   LET g_xml.body = ARG_VAL(15)
   LET g_xml.recipient = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  
 
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  
      CALL ghrr016_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr016()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr016_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr016_w AT p_row,p_col WITH FORM "ghr/42f/ghrr016"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL       
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
 
WHILE TRUE

       IF g_action_choice = "locale" THEN
          LET g_action_choice = " "
          CALL cl_dynamic_locale()        #动态转换画面语言
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW ghrr016_w  
      EXIT WHILE        
   END IF
   CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat01

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET tm.hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(tm.hrat03) THEN
            NEXT FIELD hrat03
          END IF     
        AFTER FIELD hrat04
          LET tm.hrat04=GET_FLDBUF(hrat04)
        AFTER FIELD hrat01
          LET tm.hrat01=GET_FLDBUF(hrat01)
          IF cl_null(tm.hrat01) THEN
             NEXT FIELD hrat01
          END IF
         
          
        ON ACTION controlp
          CASE
          	  WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING tm.hrat03
              DISPLAY BY NAME tm.hrat03
              NEXT FIELD hrat03
                 
              WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = tm.hrat03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat04
               NEXT FIELD hrat04
               
               WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
               
                         	
              OTHERWISE
                 EXIT CASE
           END CASE
        ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
    END CONSTRUCT
    
    INPUT BY NAME tm.qj WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD qj
          IF tm.qj = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
          
       ON ACTION qbe_save
          CALL cl_qbe_save()

    END INPUT
          
  
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr016_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr016'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr016','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
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
         CALL cl_cmdat('ghrr016',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr016_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr016()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr016_w
END FUNCTION
 
FUNCTION ghrr016()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000        
   
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
            hrat03_name   LIKE    type_file.chr50, 
            hrat02        LIKE    hrat_file.hrat02, 
            hrat22_name   LIKE    type_file.chr50, 
            hrat36        LIKE    hrat_file.hrat36,  
            hrat13        LIKE    hrat_file.hrat13,     
            hrat49        LIKE    hrat_file.hrat49,  
            hrat45        LIKE    hrat_file.hrat45,    
            hrbf08        LIKE    hrbf_file.hrbf08,  
            hrbf09        LIKE    hrbf_file.hrbf09     
                   END RECORD
  DEFINE  l_hrat22     LIKE   hrat_file.hrat22,
          l_flag       LIKE   type_file.num5
  LET  l_flag=0
 

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT '',hrat02,'',hrat36,hrat13,hrat49,hrat45,hrbf08,hrbf09 ",
             " FROM hrat_file,hrbf_file                                      ",
             " WHERE hratid=hrbf02 AND hrbf08 IS NOT NULL     AND            ",
             tm.wc CLIPPED,
             " ORDER BY hrbf08 DESC "                                             
             
   PREPARE ghrr016_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr016_curs1 CURSOR FOR ghrr016_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH ghrr016_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET l_flag=l_flag+1
      IF l_flag=2 THEN
         EXIT FOREACH
      END IF
       SELECT hraa02 INTO sr.hrat03_name FROM hraa_file WHERE hraa01=tm.hrat03
       SELECT hrat22 INTO l_hrat22 FROM hrat_file WHERE hrat01=tm.hrat01 
       IF NOT cl_null(l_hrat22) THEN
          CALL s_code('317',l_hrat22) RETURNING g_hrag.*
          LET sr.hrat22_name=g_hrag.hrag07 
       END IF
       EXECUTE insert_prep USING sr.*   
   END FOREACH  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr016','ghrr016',g_sql,g_str)     #第一个ghrr016是程序名字  第二是模板名字 p_zaw
END FUNCTION


