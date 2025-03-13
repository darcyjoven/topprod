# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr026.4gl
# Descriptions...: 员工年假结余表
# Date & Author..: 13/08/29 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      STRING, 
            hrat03  LIKE hrat_file.hrat03,
            hrat04  LIKE hrat_file.hrat04,
            l_year  LIKE type_file.chr20,           
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING,
       l_company      LIKE type_file.chr20
DEFINE l_hrat03       LIKE hrat_file.hrat03
 
                
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
 
   LET g_sql = " l_company.type_file.chr50, l_date.type_file.chr50 ,",
               " l_com.type_file.chr50, ",
               " hrat01.hrat_file.hrat01,   hrat02.hrat_file.hrat02, ",
               " hrao02.hrao_file.hrao02,   hras04.hras_file.hras04, ",
               " hrat25.hrat_file.hrat25,   jhua.type_file.num5, ",
               " hrch04.hrch_file.hrch04,   hrch15.hrch_file.hrch15,",
               " yixiu.type_file.num5,      hrch06.hrch_file.hrch06,",
               " kexiu.type_file.num5 "
                             
   LET l_table = cl_prt_temptable('ghrr026',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr026_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr026()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr026_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)

          
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr026_w AT p_row,p_col WITH FORM "ghr/42f/ghrr026"
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
      CLOSE WINDOW ghrr026_w  
      EXIT WHILE        
   END IF
   
  CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,l_year

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN
                 NEXT FIELD hrat03
          END IF
          SELECT hraa02 INTO l_company FROM hraa_file WHERE hraa01=l_hrat03 
          DISPLAY l_company TO hrat03_name  
        AFTER FIELD hrat04
          LET tm.hrat04=GET_FLDBUF(hrat04)
        AFTER FIELD l_year
           LET tm.l_year=GET_FLDBUF(l_year)
           IF cl_null(tm.l_year) THEN
              NEXT FIELD l_year
           END IF
       ON ACTION controlp
          CASE
              WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 =l_hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING l_hrat03
              DISPLAY l_hrat03 TO hrat03
              NEXT FIELD hrat03
               
             WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
                                                                   
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
      AFTER CONSTRUCT
      #   LET tm.wc=cl_replace_str(tm.wc,'l_year','hrch02')
 
    END CONSTRUCT
     LET tm.wc=cl_replace_str(tm.wc,'l_year','hrch02')
     IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.qj                  
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
         LET INT_FLAG = 0 CLOSE WINDOW ghrr026_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr026'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr026','9031',1)
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
         CALL cl_cmdat('ghrr026',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr026_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr026()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr026_w
END FUNCTION
 
FUNCTION ghrr026()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000
          
   DEFINE l_n      LIKE   type_file.num20 
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING   
   DEFINE l_i,l_j     LIKE type_file.num5   
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
                l_company  LIKE   type_file.chr50, 
                l_date  LIKE   type_file.chr50,
                l_com   LIKE   type_file.chr50, 
                hrat01  LIKE   hrat_file.hrat01,   
                hrat02  LIKE   hrat_file.hrat02, 
                hrao02  LIKE   hrao_file.hrao02,   
                hras04  LIKE   hras_file.hras04, 
                hrat25  LIKE   hrat_file.hrat25,   
                jhua   LIKE   type_file.num5, 
                hrch04  LIKE   hrch_file.hrch04,   
                hrch15  LIKE   hrch_file.hrch15,
                yixiu   LIKE   type_file.num5,      
                hrch06  LIKE   hrch_file.hrch06,
                kexiu   LIKE   type_file.num5             
                   END RECORD 
   DEFINE   l_hrch03  LIKE     hrch_file.hrch03,
            l_hrat04  LIKE     hrat_file.hrat04,
            l_hrat05  LIKE     hrat_file.hrat05,
            l_hrch10  LIKE     hrch_file.hrch10,
            l_hrch09  LIKE     hrch_file.hrch09,
            l_hrch11  LIKE     hrch_file.hrch11,
            l_hrch15  LIKE     hrch_file.hrch15,
            l_hrch17  LIKE     hrch_file.hrch17,
            l_hrch20  LIKE     hrch_file.hrch20,
            l_hrch21  LIKE     hrch_file.hrch21,
            l_hrch22  LIKE     hrch_file.hrch22

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  
   LET sr.l_company=l_company,tm.l_year,"年度"
   LET sr.l_date=tm.l_year,'年'
   LET sr.l_com=l_company
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT hrch03,hrat01,hrat02,hrat04,hrat05,hrat25,hrch04,hrch15,hrch06 ",
             " FROM hrch_file,hrat_file,hrad_file ",
             " WHERE hratid=hrch03 AND hrad02=hrat19 AND hrad01<>'003' AND hratacti='Y' AND ",
             tm.wc CLIPPED,
             " ORDER BY hrat04,hrat01 "
   PREPARE ghrr026_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr026_curs1 CURSOR FOR ghrr026_prepare1
   IF STATUS THEN 
      CALL cl_err('declare:',STATUS,1) 
      RETURN 
   END IF
 
   FOREACH ghrr026_curs1 INTO l_hrch03,sr.hrat01,sr.hrat02,l_hrat04,l_hrat05,sr.hrat25,
                              sr.hrch04,sr.hrch15,sr.hrch06
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
     
     SELECT hrao02 INTO sr.hrao02 
     FROM hrao_file 
     WHERE hrao01=l_hrat04
     
     SELECT hras04 INTO sr.hras04 
     FROM hras_file 
     WHERE hras01=l_hrat05
     
     #--本年计划天数--#
     SELECT hrch09,hrch10,hrch11 INTO l_hrch09,l_hrch10,l_hrch11
     FROM hrch_file
     WHERE hrch01=l_hrat03 AND hrch02=tm.l_year AND hrch03=l_hrch03
     IF cl_null(l_hrch09) THEN
        LET l_hrch09=0
     END IF
     IF cl_null(l_hrch10) THEN
        LET l_hrch10=0
     END IF
     IF cl_null(l_hrch11) THEN
        LET l_hrch11=0
     END IF
     LET sr.jhua=l_hrch09+l_hrch10+l_hrch11
     
     #--本年已休天数--#
     SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22
     FROM hrch_file
     WHERE hrch01=l_hrat03 AND hrch02=tm.l_year AND hrch03=l_hrch03
     IF cl_null(l_hrch22) THEN
        LET l_hrch22=0
     END IF
     IF cl_null(l_hrch20) THEN
        LET l_hrch20=0
     END IF
     IF cl_null(l_hrch21) THEN
        LET l_hrch21=0
     END IF
     LET sr.yixiu=sr.jhua-(l_hrch20+l_hrch21+l_hrch22)
      #--本年剩余可休天数--#
     SELECT hrch15,hrch17 INTO l_hrch15,l_hrch17
     FROM hrch_file
     WHERE hrch01=l_hrat03 AND hrch02=tm.l_year AND hrch03=l_hrch03
     IF cl_null(l_hrch15) THEN
        LET l_hrch15=0
     END IF
     IF cl_null(l_hrch17) THEN
        LET l_hrch17=0
     END IF
     LET sr.kexiu=l_hrch15-l_hrch17
     
       EXECUTE insert_prep USING sr.*  
   END FOREACH 
  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr026','ghrr026',g_sql,g_str)     #第一个ghrr026是程序名字  第二是模板名字 p_zaw
END FUNCTION


