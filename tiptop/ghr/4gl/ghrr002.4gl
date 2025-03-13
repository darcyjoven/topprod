# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr002.4gl
# Descriptions...: 公司一级部门职务分布统计表
# Date & Author..: 13/08/08 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,  
            hrao00  LIKE hrao_file.hrao00,      #公司编号
            hrat25  LIKE hrat_file.hrat25,      #基准日期
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING                    
 
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
   LET g_sql = " hrat25.hrat_file.hrat25, l_hraa12.hraa_file.hraa12,   ",
               " hrao02.hrao_file.hrao02,  ",
               " hrag07.hrag_file.hrag07,  ",
               " l_sum.type_file.num20 "
                             
   LET l_table = cl_prt_temptable('ghrr002',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr002_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr002()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr002_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr002_w AT p_row,p_col WITH FORM "ghr/42f/ghrr002"
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
      CLOSE WINDOW ghrr002_w  
      EXIT WHILE        
   END IF
   
   INPUT BY NAME tm.hrao00,tm.hrat25,tm.qj WITHOUT DEFAULTS
    BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)  
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
    AFTER FIELD hrao00
       IF cl_null(tm.hrao00) THEN
         NEXT FIELD hrao00
       END IF
   AFTER FIELD hrat25
       IF cl_null(tm.hrat25) THEN
          NEXT FIELD hrat25
       END IF
          
   AFTER INPUT
     IF NOT cl_null(tm.hrao00) AND NOT cl_null(tm.hrat25)  THEN
        LET tm.wc=" hrao00='",tm.hrao00,"'" CLIPPED," AND "," hrat25<='",tm.hrat25,"'" CLIPPED
     END IF
    
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
          
      ON ACTION qbe_save
            CALL cl_qbe_save()
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrao00)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hrao00
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING tm.hrao00
              DISPLAY BY NAME tm.hrao00
              NEXT FIELD hrao00
           
         OTHERWISE
            EXIT CASE
         END CASE
     
   END INPUT
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr002'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr002','9031',1)
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
         CALL cl_cmdat('ghrr002',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr002()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr002_w
END FUNCTION
 
FUNCTION ghrr002()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000,
         l_sql1      LIKE  type_file.chr1000          
   
   DEFINE l_n      LIKE   type_file.num20 
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING   
   DEFINE l_i,l_j     LIKE type_file.num5   
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
          hrat25     LIKE hrat_file.hrat25,    
          l_hraa12   LIKE hraa_file.hraa12,    
          hrat01     LIKE hrat_file.hrat01,
          hrao01     LIKE hrao_file.hrao01,
          hrao02     LIKE hrao_file.hrao02,
          hrar02     LIKE hrar_file.hrar02,
          hrag07     LIKE hrag_file.hrag07,
          l_sum      LIKE type_file.num20             
                   END RECORD

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT hraa12 INTO sr.l_hraa12 FROM hraa_file WHERE hraa01=tm.hrao00
  
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT hrao01,hrao02,hrar02,hrag07,count(hrat01) ",
             " FROM   hrat_file,hrao_file,hras_file,hrar_file,hrag_file ",
             " WHERE hrat04=hrao01 AND hratconf='Y' AND hrao10 IS NULL AND  hrao05='Y' ",
             " AND hrat05=hras01 ",
             " AND hrar03=hras03 AND hrat19='2001' ",
             " AND hrag01='203' AND  hrag06=hrar02  AND ",
             tm.wc CLIPPED,
             " GROUP BY hrao01,hrao02,hrar02,hrag07 "
   PREPARE ghrr002_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr002_curs1 CURSOR FOR ghrr002_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH ghrr002_curs1 INTO sr.hrao01,sr.hrao02,sr.hrar02,sr.hrag07,sr.l_sum 
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      
       EXECUTE insert_prep USING tm.hrat25,sr.l_hraa12,sr.hrao02,sr.hrag07,sr.l_sum    
   END FOREACH 
  #--获取公司总人数--# 
   LET l_sql1=" SELECT count(hrat01) ",
             " FROM   hrat_file,hrao_file,hras_file,hrar_file,hrag_file ",
             " WHERE hrat04=hrao01 AND hratconf='Y' AND hrao09='1' AND  hrao05='Y' ",
             " AND hrat05=hras01 ",
             " AND hrar03=hras03 AND hrat19='2001' ",
             " AND hrag01='203' AND  hrag06=hrar02  AND ",
             tm.wc CLIPPED
   PREPARE ghrr002_prepare2 FROM l_sql1
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr002_curs2 CURSOR FOR ghrr002_prepare2
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
   
   FOREACH ghrr002_curs2 INTO l_n 
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

   END FOREACH 
   LET l_n=1
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc,';',l_n
   CALL cl_prt_cs3('ghrr002','ghrr002',g_sql,g_str)     #第一个ghrr002是程序名字  第二是模板名字 p_zaw
END FUNCTION


