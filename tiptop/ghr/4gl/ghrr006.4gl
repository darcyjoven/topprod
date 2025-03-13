# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr006.4gl
# Descriptions...: 员工紧急联系人信息表
# Date & Author..: 13/08/15 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,             
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING 
DEFINE g_hrat    RECORD LIKE   hrat_file.*
DEFINE g_hrag    RECORD LIKE   hrag_file.*
DEFINE g_i         LIKE type_file.num5                    
 
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
 
   LET g_sql = " l_i.type_file.num5,         hrat01.hrat_file.hrat01,     ",
               " hrat02.hrat_file.hrat02,    hrat04_name.type_file.chr50,  ",
               " hrat05_name.type_file.chr50,hrat19_name.type_file.chr50, ",
               " hrat25.hrat_file.hrat25,    hrat46.hrat_file.hrat46,     ",
               " hrat47.hrat_file.hrat47,    hrat49.hrat_file.hrat49,      ",
               " hrath02.hrath_file.hrath02, hrath03_name.type_file.chr50, ",
               " hrath04.hrath_file.hrath04, hrath05.hrath_file.hrath05,   ",
               " hrath06.hrath_file.hrath06, hrath07.hrath_file.hrath07,   ",
               " hrath08.hrath_file.hrath08, hrath09.hrath_file.hrath09    "
                             
   LET l_table = cl_prt_temptable('ghrr006',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr006_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr006()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr006_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03
   DEFINE hrat19       LIKE hrat_file.hrat19
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr006_w AT p_row,p_col WITH FORM "ghr/42f/ghrr006"
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
      CLOSE WINDOW ghrr006_w  
      EXIT WHILE        
   END IF
   
  CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat19,hrat01

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN
                 NEXT FIELD hrat03
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
               LET g_qryparam.arg1 = l_hrat03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat04
               NEXT FIELD hrat04
               
          	 WHEN INFIELD(hrat19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = hrat19
              CALL cl_create_qry() RETURNING hrat19
              DISPLAY BY NAME hrat19
              NEXT FIELD hrat19 
              
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
         LET INT_FLAG = 0 CLOSE WINDOW ghrr006_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr006'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr006','9031',1)
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
         CALL cl_cmdat('ghrr006',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr006()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr006_w
END FUNCTION
 
FUNCTION ghrr006()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000,
         l_sql1      LIKE  type_file.chr1000          
   
   DEFINE l_n      LIKE   type_file.num20 
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING   
   DEFINE l_i,l_j     LIKE type_file.num5   
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
          l_i          LIKE   type_file.num5,         
          hrat01       LIKE   hrat_file.hrat01,     
          hrat02       LIKE   hrat_file.hrat02,  
          hrat04_name  LIKE   type_file.chr50, 
          hrat05_name  LIKE   type_file.chr50,
          hrat19_name  LIKE   type_file.chr50, 
          hrat25       LIKE   hrat_file.hrat25,    
          hrat46       LIKE   hrat_file.hrat46,    
          hrat47       LIKE   hrat_file.hrat47,    
          hrat49       LIKE   hrat_file.hrat49,      
          hrath02      LIKE   hrath_file.hrath02,
          hrath03_name LIKE   type_file.chr50, 
          hrath04      LIKE   hrath_file.hrath04,
          hrath05      LIKE   hrath_file.hrath05,   
          hrath06      LIKE   hrath_file.hrath06,
          hrath07      LIKE   hrath_file.hrath07,  
          hrath08      LIKE   hrath_file.hrath08, 
          hrath09      LIKE   hrath_file.hrath09              
                   END RECORD
                   
   DEFINE l_hrat04     LIKE   hrat_file.hrat04,
          l_hrat05     LIKE   hrat_file.hrat05,
          l_hrat19     LIKE   hrat_file.hrat19,
          l_hrath03    LIKE   hrath_file.hrath03
   DEFINE l_des       LIKE type_file.chr100

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT '',hrat01,hrat02,'','','',hrat25,hrat46,hrat47,hrat49 ,",
             " hrath02,'',hrath04,hrath05,hrath06,hrath07,hrath08,hrath09 ",       
             " FROM hrat_file,hrath_file                                  ",
             " WHERE hrath01=hrat01 AND                                    ",
             tm.wc CLIPPED
   LET g_i=0
   PREPARE ghrr006_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr006_curs1 CURSOR FOR ghrr006_prepare1
   IF STATUS THEN 
      CALL cl_err('declare:',STATUS,1) 
      RETURN 
   END IF
 
   FOREACH ghrr006_curs1 INTO sr.*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
     
      IF NOT cl_null(sr.hrat01) THEN
         LET g_i=g_i+1
         LET sr.l_i=g_i
         SELECT hrat04,hrat05,hrat19 INTO l_hrat04,l_hrat05,l_hrat19
         FROM hrat_file 
         WHERE hrat01=sr.hrat01
         
         SELECT hrath03 INTO l_hrath03 FROM hrath_file 
         WHERE hrath01=sr.hrat01 AND hrath02=sr.hrath02
         IF NOT cl_null(l_hrat04) THEN
           SELECT hrao02 INTO sr.hrat04_name FROM hrao_file WHERE hrao01=l_hrat04
         END IF
         IF NOT cl_null(l_hrat05) THEN
           SELECT hras04 INTO sr.hrat05_name FROM hras_file WHERE hras01=l_hrat05
         END IF
         IF NOT cl_null(l_hrat19) THEN
   #      LET g_hrat.hrat01=sr.hrat01
   #      LET g_hrat.hrat19=l_hrat19
   #      CALL i006_hrat19(g_hrat.*) RETURNING l_des
   #      LET sr.hrat19_name=l_des
          SELECT hrad03 INTO sr.hrat19_name FROM hrad_file WHERE hrad02=l_hrat19
         END IF
         IF NOT cl_null(l_hrath03) THEN
          CALL s_code('323',l_hrath03) RETURNING g_hrag.*
          LET sr.hrath03_name=g_hrag.hrag07 
       END IF 
         
      END IF
       EXECUTE insert_prep USING sr.*  
   END FOREACH 
  #--获取公司总人数--# 
  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr006','ghrr006',g_sql,g_str)     #第一个ghrr006是程序名字  第二是模板名字 p_zaw
END FUNCTION


