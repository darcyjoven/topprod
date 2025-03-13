# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr012.4gl
# Descriptions...: 员工状态分布图
# Date & Author..: 13/08/19 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,  
            hrat03  LIKE hrat_file.hrat03,      #公司编号
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
   LET g_sql = " comp_name.type_file.chr50, hrat25.hrat_file.hrat25,    ",
               " hrat04.hrat_file.hrat04  , hrat04_name.type_file.chr50,",
               " age.type_file.chr50      , l_sum.type_file.num20       "

                             
   LET l_table = cl_prt_temptable('ghrr012',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr012_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr012()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr012_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr012_w AT p_row,p_col WITH FORM "ghr/42f/ghrr012"
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
      CLOSE WINDOW ghrr012_w  
      EXIT WHILE        
   END IF
   CONSTRUCT BY NAME tm.wc ON hrat03,hrat25

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET tm.hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(tm.hrat03) THEN
            NEXT FIELD hrat03
          END IF     
        AFTER FIELD hrat25
          LET tm.hrat25=GET_FLDBUF(hrat25)
         
          
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
       AFTER INPUT
          LET tm.wc=" hrat03='",tm.hrat03,"'" CLIPPED," AND "," hrat25<='",tm.hrat25,"'" CLIPPED

 
    END INPUT
          
  
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr012_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr012'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr012','9031',1)
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
         CALL cl_cmdat('ghrr012',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr012_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr012()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr012_w
END FUNCTION
 
FUNCTION ghrr012()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000        
   
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
          comp_name      LIKE     type_file.chr50, 
          hrat25         LIKE     hrat_file.hrat25,    
          hrat04         LIKE     hrat_file.hrat04, 
          hrat04_name    LIKE     type_file.chr50,
          age            LIKE     type_file.chr50, 
          l_sum          LIKE     type_file.num20          
                   END RECORD
  DEFINE  l_hraa12     LIKE   hraa_file.hraa12
  DEFINE  l_n          LIKE type_file.num5,
          l_m          LIKE type_file.num5


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT hraa12 INTO sr.comp_name FROM hraa_file WHERE hraa01=tm.hrat03
   
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT hrao01,age,count(hart01) from ( ",
             "   SELECT hrao01 hrao01,                   ",
             "          CASE                             ",
             " WHEN ((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365<0) THEN 0 ",             
             " WHEN ((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365=0) THEN 1 ", 
             " WHEN (((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365) BETWEEN 1 AND 2) THEN 2 ", 
             " WHEN (((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365) BETWEEN 3 AND 4) THEN 3 ", 
             " WHEN (((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365) BETWEEN 5 AND 9) THEN 4 ", 
             " WHEN (((to_date('",tm.hrat25,"','yyyy/mm/dd')-hrat25)/365)>=10) THEN 5              ",
             " END age,hrat01 hart01                                         ",
             " FROM hrat_file,hrao_file                                      ",
             " WHERE hrat04=hrao01 AND hrao10 is NULL AND hrao05='N' AND     ",  
             tm.wc CLIPPED," ) ",
             " GROUP BY hrao01,age                                           ",
             " ORDER BY age                                               "
             
   PREPARE ghrr012_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr012_curs1 CURSOR FOR ghrr012_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH ghrr012_curs1 INTO sr.hrat04,l_n,sr.l_sum
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF NOT cl_null(sr.hrat04) THEN
         SELECT hrao02 INTO sr.hrat04_name FROM hrao_file WHERE hrao01=sr.hrat04
      END IF
      LET sr.hrat25=tm.hrat25
      IF sr.age=0 THEN
         CONTINUE FOREACH
      END IF
      CASE l_n
           WHEN 1   LET sr.age="入司一年内"
           WHEN 2   LET sr.age="入司1-3年"
           WHEN 3   LET sr.age="入司3-5年"
           WHEN 4   LET sr.age="入司5-10年"
           WHEN 5   LET sr.age="入司10年以上"           
      END CASE
       EXECUTE insert_prep USING sr.*   
   END FOREACH  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   SELECT COUNT(hrat01) INTO l_m FROM hrat_file,hrao_file 
   WHERE hrat04=hrao01 AND hrao10 is NULL AND hrat03=tm.hrat03 AND hrat25<=tm.hrat25    
   LET g_str = tm.wc,';',l_m
   CALL cl_prt_cs3('ghrr012','ghrr012',g_sql,g_str)     #第一个ghrr012是程序名字  第二是模板名字 p_zaw
END FUNCTION


