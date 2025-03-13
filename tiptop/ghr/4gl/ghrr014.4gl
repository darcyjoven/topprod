# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr014.4gl
# Descriptions...: 新进离职人员平衡表
# Date & Author..: 13/08/27 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,
            hrat03  LIKE hrat_file.hrat03,     #公司编号
            l_year  LIKE type_file.chr20,      
            l_month LIKE type_file.chr20,      #基准日期
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING
DEFINE l_company   LIKE type_file.chr20                 
 
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
   LET g_sql = " title_name.type_file.chr50, l_month.type_file.chr20, ",
               " l_year.type_file.chr20, l_company.type_file.chr20, ",
               " s_month.type_file.num5, hrat04_name.type_file.chr20, ",
               " qichu.type_file.num20, ruzhi.type_file.num20, ",
               " lizhi.type_file.num20, qimo.type_file.num20,  ",
               " sum1.type_file.num20,  sum2.type_file.num20,",
               " sum3.type_file.num20 "

                             
   LET l_table = cl_prt_temptable('ghrr014',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr014_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr014()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr014_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr014_w AT p_row,p_col WITH FORM "ghr/42f/ghrr014"
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
      CLOSE WINDOW ghrr014_w  
      EXIT WHILE        
   END IF
   CONSTRUCT BY NAME tm.wc ON hrat03,l_year,l_month

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET tm.hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(tm.hrat03) THEN
            NEXT FIELD hrat03
          END IF 
         SELECT hraa02 INTO l_company FROM hraa_file WHERE hraa01=tm.hrat03 
         DISPLAY l_company TO hrat03_name      
        AFTER FIELD l_year
          LET tm.l_year=GET_FLDBUF(l_year)
          IF cl_null(tm.l_year) THEN
            NEXT FIELD l_year
          END IF
        AFTER FIELD l_month
          LET tm.l_month=GET_FLDBUF(l_month)
          IF cl_null(tm.l_month) THEN
            NEXT FIELD l_month
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
          CALL cl_cmdask()    
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       AFTER INPUT
         LET tm.wc=" hrat03='",tm.hrat03,"'" CLIPPED," AND "," YEAR(hrat25)='",tm.l_year,"'" CLIPPED

 
    END INPUT
          
  
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr014_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr014'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr014','9031',1)
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
         CALL cl_cmdat('ghrr014',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr014_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr014()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr014_w
END FUNCTION
 
FUNCTION ghrr014()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000        
   
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE  sr        RECORD
           title_name  LIKE type_file.chr50,
           l_month     LIKE type_file.chr20,
           l_year      LIKE type_file.chr20,
           l_comany    LIKE type_file.chr20,
           hrao00      LIKE type_file.chr100,
           hrao01      LIKE hrao_file.hrao01,
           qichu       LIKE type_file.num20,
           ruzhi       LIKE type_file.num20,
           lizhi       LIKE type_file.num20,
           qimo        LIKE type_file.num20,
           hrat04_name LIKE type_file.chr20,
           s_month     LIKE type_file.num5,
           sum1        LIKE type_file.num20,
           sum2        LIKE type_file.num20,
           sum3        LIKE type_file.num20
                    END RECORD,
           sr1       RECORD
           hrao00      LIKE hrao_file.hrao00,
           hrao01      LIKE hrao_file.hrao01,
           hrao10      LIKE hrao_file.hrao10
                    END RECORD
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_hrao01  LIKE  hrao_file.hrao01

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
 
   LET sr.l_year=tm.l_year,"年"
   LET sr.l_month=tm.l_month,"月"
   LET sr.title_name=l_company,tm.l_year,"年月度"
   
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT DISTINCT hrao00,hrao01 ",
             " FROM hrao_file,hrat_file  ",
             " WHERE hrao01=hrat04 AND hrao10 is NULL AND hrao05 = 'N' AND hraoacti='Y' "
            
                                                      
             
   PREPARE ghrr014_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr014_curs1 CURSOR FOR ghrr014_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH ghrr014_curs1 INTO sr.hrao00,sr.hrao01
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      SELECT hrao01 INTO l_hrao01 
      FROM hrao_file
      WHERE hrao10=sr.hrao01

      SELECT hrao02 INTO sr.hrat04_name 
      FROM hrao_file 
      WHERE hrao01=sr.hrao01 
      
         #--部门年度入职离职总人数--#
         SELECT COUNT(hratid) INTO sr.sum3
         FROM hrat_file,hrad_file
         WHERE hrat19=hrad02 AND hrad01<>'003' AND YEAR(hrat25)=tm.l_year AND (hrat04=sr.hrao01 OR hrat04=l_hrao01) 
  
         SELECT count(hratid) INTO sr.sum1
         FROM hrat_file,hrad_file,hrao_file 
         WHERE hrao01=hrat04 AND hrat19=hrad02 AND hrad01<>'003' 
         AND YEAR(hrat25)=tm.l_year AND MONTH(hrat25)<=tm.l_month
         

         SELECT count(hratid) INTO sr.sum2
         FROM hrat_file,hrbh_file,hrao_file WHERE hrao01=hrat04 AND hrbh01=hratid  AND hrbhconf='2' 
         AND YEAR(hrbh04)=tm.l_year AND MONTH(hrbh04)<=tm.l_month 
         IF sr.sum2=0 THEN 
           LET sr.sum2=1
         END IF
     
 
      FOR l_i=1 TO tm.l_month
         LET sr.s_month=l_i
         
         #--期初人数--#
         IF l_i=1 THEN
         SELECT COUNT(hratid) INTO sr.qichu
         FROM hrat_file,hrad_file
         WHERE hrat19=hrad02 AND hrad01<>'003' AND YEAR(hrat25)<tm.l_year AND (hrat04=sr.hrao01 OR hrat04=l_hrao01)
         END IF
         IF l_i>1 THEN
         LET sr.qichu=sr.qimo
         END IF
         # --入职人数-- #
         SELECT count(hratid) INTO sr.ruzhi
         FROM hrat_file,hrad_file,hrao_file 
         WHERE hrao01=hrat04 AND hrat19=hrad02 AND hrad01<>'003' 
         AND (hrat04=sr.hrao01 OR hrat04=l_hrao01) AND YEAR(hrat25)=tm.l_year AND MONTH(hrat25)=l_i

         # --离职人数-- #
         SELECT count(hratid) INTO sr.lizhi
         FROM hrat_file,hrbh_file,hrao_file WHERE hrao01=hrat04 AND hrbh01=hratid  AND hrbhconf='2' 
         AND YEAR(hrbh04)=tm.l_year AND MONTH(hrbh04)=l_i AND (hrat04=sr.hrao01 OR hrat04=l_hrao01)

         #--期末人数--#
         LET sr.qimo=sr.qichu+sr.ruzhi-sr.lizhi

       
         EXECUTE insert_prep USING sr.title_name,sr.l_month,sr.l_year,l_company,
                                   sr.s_month,sr.hrat04_name,sr.qichu,sr.ruzhi,
                                   sr.lizhi,sr.qimo,sr.sum1,sr.sum2,sr.sum3
      END FOR
   END FOREACH  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr014','ghrr014',g_sql,g_str)     #第一个ghrr014是程序名字  第二是模板名字 p_zaw
END FUNCTION



