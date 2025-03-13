# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr040.4gl
# Descriptions...: 预算达成分析管理表
# Date & Author..: 13/09/03 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,
            hreb00  LIKE hreb_file.hreb00,      
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING,
       l_table1    STRING                
DEFINE g_sql       STRING                   
DEFINE g_str       STRING
DEFINE l_name                 STRING
DEFINE g_hreb     DYNAMIC ARRAY OF RECORD
       m     LIKE     type_file.num20,
       n     LIKE     type_file.num20,
       rate  LIKE     type_file.num20
                  END RECORD
                
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
   LET g_sql = " hreb01.hreb_file.hreb01, l_year.type_file.chr20, ",
               " m1.type_file.num20,    n1.type_file.num20, ",
               " rate1.type_file.num20, m2.type_file.num20, ",
               " n2.type_file.num20,    rate2.type_file.num20, ",
               " m3.type_file.num20,    n3.type_file.num20, ",
               " rate3.type_file.num20, m01.type_file.num20, ",
               " n01.type_file.num20,   rate01.type_file.num20, ",
               " m4.type_file.num20,    n4.type_file.num20, ",
               " rate4.type_file.num20, m5.type_file.num20, ",
               " n5.type_file.num20,    rate5.type_file.num20, ",
               " m6.type_file.num20,    n6.type_file.num20, ",
               " rate6.type_file.num20, m02.type_file.num20, ",
               " n02.type_file.num20,   rate02.type_file.num20, ",
               " m7.type_file.num20,    n7.type_file.num20, ",
               " rate7.type_file.num20, m8.type_file.num20, ",
               " n8.type_file.num20,    rate8.type_file.num20, ",
               " m9.type_file.num20,    n9.type_file.num20, ",
               " rate9.type_file.num20, m03.type_file.num20, ",
               " n03.type_file.num20,   rate03.type_file.num20, ",
               " m10.type_file.num20,   n10.type_file.num20, ",
               " rate10.type_file.num20,m11.type_file.num20, ",
               " n11.type_file.num20,   rate11.type_file.num20, ",
               " m12.type_file.num20,   n12.type_file.num20, ",
               " rate12.type_file.num20, m04.type_file.num20, ",
               " n04.type_file.num20,    rate04.type_file.num20, ",
               " m_s.type_file.num20,    n_s.type_file.num20, ",
               " rate_s.type_file.num20, m_p.type_file.num20, ",
               " n_p.type_file.num20,    rate_p.type_file.num20, ",
               " sum_m1.type_file.num20,    sum_n1.type_file.num20, ",
               " sum_rate1.type_file.num20, sum_m2.type_file.num20, ",
               " sum_n2.type_file.num20,    sum_rate2.type_file.num20, ",
               " sum_m3.type_file.num20,    sum_n3.type_file.num20, ",
               " sum_rate3.type_file.num20, sum_m01.type_file.num20, ",
               " sum_n01.type_file.num20,   sum_rate01.type_file.num20, ",
               " sum_m4.type_file.num20,    sum_n4.type_file.num20, ",
               " sum_rate4.type_file.num20, sum_m5.type_file.num20, ",
               " sum_n5.type_file.num20,    sum_rate5.type_file.num20, ",
               " sum_m6.type_file.num20,    sum_n6.type_file.num20, ",
               " sum_rate6.type_file.num20, sum_m02.type_file.num20, ",
               " sum_n02.type_file.num20,   sum_rate02.type_file.num20, ",
               " sum_m7.type_file.num20,    sum_n7.type_file.num20, ",
               " sum_rate7.type_file.num20, sum_m8.type_file.num20, ",
               " sum_n8.type_file.num20,    sum_rate8.type_file.num20, ",
               " sum_m9.type_file.num20,    sum_n9.type_file.num20, ",
               " sum_rate9.type_file.num20, sum_m03.type_file.num20, ",
               " sum_n03.type_file.num20,   sum_rate03.type_file.num20, ",
               " sum_m10.type_file.num20,   sum_n10.type_file.num20, ",
               " sum_rate10.type_file.num20, sum_m11.type_file.num20, ",
               " sum_n11.type_file.num20,    sum_rate11.type_file.num20, ",
               " sum_m12.type_file.num20,    sum_n12.type_file.num20, ",
               " sum_rate12.type_file.num20, sum_m04.type_file.num20, ",
               " sum_n04.type_file.num20,    sum_rate04.type_file.num20, ",
               " sum_m_s.type_file.num20,    sum_n_s.type_file.num20, ",
               " sum_rate_s.type_file.num20, sum_m_p.type_file.num20, ",
               " sum_n_p.type_file.num20,    sum_rate_p.type_file.num20 "
                                        
   LET l_table = cl_prt_temptable('ghrr040',g_sql) CLIPPED   # 产生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table产生
   
   LET g_sql=" l_year.type_file.chr20, l_month.type_file.chr20, ",
             " sum1.type_file.num20,   sum2.type_file.num20 "
   LET l_table1=cl_prt_temptable('ghrr040_a',g_sql)
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
      CALL ghrr040_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr040()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr040_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr040_w AT p_row,p_col WITH FORM "ghr/42f/ghrr040"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   CALL cl_set_combo_items("hreb00",NULL,NULL)
   CALL r040_get_items() RETURNING l_name
   CALL cl_set_combo_items("hreb00",l_name,l_name)
 
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
      CLOSE WINDOW ghrr040_w  
      EXIT WHILE        
   END IF
   CONSTRUCT BY NAME tm.wc ON hreb00

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hreb00
          LET tm.hreb00 = GET_FLDBUF(hreb00)
          IF cl_null(tm.hreb00) THEN
            NEXT FIELD hreb00
          END IF        
                   
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
         LET tm.wc="hreb00='",tm.hreb00,"'" CLIPPED

 
    END INPUT
          
  
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr040_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr040'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr040','9031',1)
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
         CALL cl_cmdat('ghrr040',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr040_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr040()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr040_w
END FUNCTION
 
FUNCTION ghrr040()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000        
   
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE  sr        RECORD
  hreb01  LIKE    hreb_file.hreb01, 
  l_year  LIKE    type_file.chr20,  
  m1  LIKE    type_file.num20,    
  n1  LIKE    type_file.num20,  
  rate1  LIKE    type_file.num20, 
  m2  LIKE    type_file.num20,  
  n2  LIKE    type_file.num20,    
  rate2  LIKE    type_file.num20,  
  m3  LIKE    type_file.num20,    
  n3  LIKE    type_file.num20,  
  rate3  LIKE    type_file.num20, 
  m01  LIKE    type_file.num20,  
  n01  LIKE    type_file.num20,   
  rate01  LIKE    type_file.num20,  
  m4  LIKE    type_file.num20,    
  n4  LIKE    type_file.num20,  
  rate4  LIKE    type_file.num20, 
  m5  LIKE    type_file.num20,  
  n5  LIKE    type_file.num20,    
  rate5  LIKE    type_file.num20,  
  m6  LIKE    type_file.num20,    
  n6  LIKE    type_file.num20,  
  rate6  LIKE    type_file.num20, 
  m02  LIKE    type_file.num20,  
  n02  LIKE    type_file.num20,   
  rate02  LIKE    type_file.num20,  
  m7  LIKE    type_file.num20,    
  n7  LIKE    type_file.num20,  
  rate7  LIKE    type_file.num20, 
  m8  LIKE    type_file.num20,  
  n8  LIKE    type_file.num20,    
  rate8  LIKE    type_file.num20,  
  m9  LIKE    type_file.num20,    
  n9  LIKE    type_file.num20,  
  rate9  LIKE    type_file.num20, 
  m03  LIKE    type_file.num20,  
  n03  LIKE    type_file.num20,   
  rate03  LIKE    type_file.num20,  
  m10  LIKE    type_file.num20,   
  n10  LIKE    type_file.num20,  
  rate10  LIKE    type_file.num20,
  m11  LIKE    type_file.num20,  
  n11  LIKE    type_file.num20,   
  rate11  LIKE    type_file.num20,  
  m12  LIKE    type_file.num20,   
  n12  LIKE    type_file.num20,  
  rate12  LIKE    type_file.num20, 
  m04  LIKE    type_file.num20,  
  n04  LIKE    type_file.num20,    
  rate04  LIKE    type_file.num20,  
  m_s  LIKE    type_file.num20,    
  n_s  LIKE    type_file.num20,  
  rate_s  LIKE    type_file.num20, 
  m_p  LIKE    type_file.num20,  
  n_p  LIKE    type_file.num20,    
  rate_p  LIKE    type_file.num20,
  sum_m1  LIKE    type_file.num20,    
  sum_n1  LIKE    type_file.num20,  
  sum_rate1  LIKE    type_file.num20, 
  sum_m2  LIKE    type_file.num20,  
  sum_n2  LIKE    type_file.num20,    
  sum_rate2  LIKE    type_file.num20,  
  sum_m3  LIKE    type_file.num20,    
  sum_n3  LIKE    type_file.num20,  
  sum_rate3  LIKE    type_file.num20, 
  sum_m01  LIKE    type_file.num20,  
  sum_n01  LIKE    type_file.num20,   
  sum_rate01  LIKE    type_file.num20,  
  sum_m4  LIKE    type_file.num20,    
  sum_n4  LIKE    type_file.num20,  
  sum_rate4  LIKE    type_file.num20, 
  sum_m5  LIKE    type_file.num20,  
  sum_n5  LIKE    type_file.num20,    
  sum_rate5  LIKE    type_file.num20,  
  sum_m6  LIKE    type_file.num20,    
  sum_n6  LIKE    type_file.num20,  
  sum_rate6  LIKE    type_file.num20, 
  sum_m02  LIKE    type_file.num20,  
  sum_n02  LIKE    type_file.num20,   
  sum_rate02  LIKE    type_file.num20,  
  sum_m7  LIKE    type_file.num20,    
  sum_n7  LIKE    type_file.num20,  
  sum_rate7  LIKE    type_file.num20, 
  sum_m8  LIKE    type_file.num20,  
  sum_n8  LIKE    type_file.num20,    
  sum_rate8  LIKE    type_file.num20,  
  sum_m9  LIKE    type_file.num20,    
  sum_n9  LIKE    type_file.num20,  
  sum_rate9  LIKE    type_file.num20, 
  sum_m03  LIKE    type_file.num20,  
  sum_n03  LIKE    type_file.num20,   
  sum_rate03  LIKE    type_file.num20,  
  sum_m10  LIKE    type_file.num20,   
  sum_n10  LIKE    type_file.num20,  
  sum_rate10  LIKE    type_file.num20,
  sum_m11  LIKE    type_file.num20,  
  sum_n11  LIKE    type_file.num20,   
  sum_rate11  LIKE    type_file.num20,  
  sum_m12  LIKE    type_file.num20,   
  sum_n12  LIKE    type_file.num20,  
  sum_rate12  LIKE    type_file.num20, 
  sum_m04  LIKE    type_file.num20,  
  sum_n04  LIKE    type_file.num20,    
  sum_rate04  LIKE    type_file.num20,  
  sum_m_s  LIKE    type_file.num20,    
  sum_n_s  LIKE    type_file.num20,  
  sum_rate_s  LIKE    type_file.num20, 
  sum_m_p  LIKE    type_file.num20,  
  sum_n_p  LIKE    type_file.num20,    
  sum_rate_p  LIKE    type_file.num20 

                    END RECORD
                    
  DEFINE     sr2        RECORD
             l_year   LIKE  type_file.chr20,
             l_month  LIKE  type_file.chr20,
             sum1     LIKE  type_file.num20,
             sum2     LIKE  type_file.num20
                     END RECORD
  DEFINE l_i       LIKE type_file.num5,
         l_hreb01  LIKE hreb_file.hreb01,
         l_count   LIKE type_file.num5,
         l_count1  LIKE type_file.num5


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,? ) "
                       
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
   END IF
   

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  LET  sr.sum_m1=0     
  LET  sr.sum_n1=0   
  LET  sr.sum_rate1=0  
  LET  sr.sum_m2=0   
  LET  sr.sum_n2=0     
  LET  sr.sum_rate2=0   
  LET  sr.sum_m3=0     
  LET  sr.sum_n3=0   
  LET  sr.sum_rate3=0  
  LET  sr.sum_m01=0   
  LET  sr.sum_n01=0    
  LET  sr.sum_rate01=0   
  LET  sr.sum_m4=0     
  LET  sr.sum_n4=0   
  LET  sr.sum_rate4=0  
  LET  sr.sum_m5=0   
  LET  sr.sum_n5=0     
  LET  sr.sum_rate5=0   
  LET  sr.sum_m6=0     
  LET  sr.sum_n6=0   
  LET  sr.sum_rate6=0  
  LET  sr.sum_m02=0   
  LET  sr.sum_n02=0    
  LET  sr.sum_rate02=0   
  LET  sr.sum_m7=0     
  LET  sr.sum_n7=0   
  LET  sr.sum_rate7=0  
  LET  sr.sum_m8=0   
  LET  sr.sum_n8=0     
  LET  sr.sum_rate8=0   
  LET  sr.sum_m9=0     
  LET  sr.sum_n9=0   
  LET  sr.sum_rate9=0  
  LET  sr.sum_m03=0   
  LET  sr.sum_n03=0    
  LET  sr.sum_rate03=0   
  LET  sr.sum_m10=0  
  LET  sr.sum_n10=0   
  LET  sr.sum_rate10=0  
  LET  sr.sum_m11=0   
  LET  sr.sum_n11=0    
  LET  sr.sum_rate11=0  
  LET  sr.sum_m12=0    
  LET  sr.sum_n12=0  
  LET  sr.sum_rate12=0 
  LET  sr.sum_m04=0   
  LET  sr.sum_n04=0     
  LET  sr.sum_rate04=0   
  LET  sr.sum_m_s=0     
  LET  sr.sum_n_s=0   
  LET  sr.sum_rate_s=0  
  LET  sr.sum_m_p=0   
  LET  sr.sum_n_p=0     
  LET  sr.sum_rate_p=0 
  LET  l_count1=0
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   
    SELECT  count(DISTINCT hreb01) INTO l_count
    FROM hreba_file,hreb_file 
    WHERE hreba00=hreb00  AND  hreb00=tm.hreb00
   LET l_sql=" SELECT DISTINCT hreb01 ",
             "  FROM hreba_file,hreb_file ",
             "  WHERE hreba00=hreb00  AND ",
             tm.wc
            
                                                      
             
   PREPARE ghrr040_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr040_curs1 CURSOR FOR ghrr040_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
   
    LET l_sql=" SELECT hreba02,sum(hreba03),sum(hreba06) ",
              " FROM hreba_file WHERE ",
              " hreba00='",tm.hreb00,"'",
              " GROUP BY hreba02 ",
              " order by hreba02 "
                                                                             
   PREPARE ghrr040_prepare2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr040_curs2 CURSOR FOR ghrr040_prepare2
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH ghrr040_curs1 INTO l_hreb01
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET l_count1=l_count1+1
      LET sr.m_s=0
      LET sr.n_s=0
      LET sr.rate01=0
      LET sr.rate02=0
      LET sr.rate03=0
      LET sr.rate04=0
      LET sr.rate_s=0
      LET sr.rate_p=0
      
      SELECT hrag07 INTO sr.hreb01
      FROM  hrag_file
      WHERE hrag01='654' AND hrag06=l_hreb01
      FOR l_i=1 TO 12
          SELECT hreba03,hreba06 INTO g_hreb[l_i].m,g_hreb[l_i].n
          FROM hreba_file
          WHERE hreba00=tm.hreb00 AND hreba01=l_hreb01 AND hreba02=l_i
          
          IF g_hreb[l_i].m=0 THEN
             LET g_hreb[l_i].rate=0
          END IF
          IF g_hreb[l_i].m<>0 THEN
             LET g_hreb[l_i].rate=g_hreb[l_i].n/g_hreb[l_i].m
          END IF
          LET sr.m_s=sr.m_s+g_hreb[l_i].m
          LET sr.n_s=sr.n_s+g_hreb[l_i].n
      END FOR
      LET sr.m1=g_hreb[1].m
      LET sr.n1=g_hreb[1].n
      LET sr.rate1=g_hreb[1].rate
      LET sr.m2=g_hreb[2].m
      LET sr.n2=g_hreb[2].n
      LET sr.rate2=g_hreb[2].rate
      LET sr.m3=g_hreb[3].m
      LET sr.n3=g_hreb[3].n
      LET sr.rate3=g_hreb[3].rate
      LET sr.m4=g_hreb[4].m
      LET sr.n4=g_hreb[4].n
      LET sr.rate4=g_hreb[4].rate
      LET sr.m5=g_hreb[5].m
      LET sr.n5=g_hreb[5].n
      LET sr.rate5=g_hreb[5].rate
      LET sr.m6=g_hreb[6].m
      LET sr.n6=g_hreb[6].n
      LET sr.rate6=g_hreb[6].rate
      LET sr.m7=g_hreb[7].m
      LET sr.n7=g_hreb[7].n
      LET sr.rate7=g_hreb[7].rate
      LET sr.m8=g_hreb[8].m
      LET sr.n8=g_hreb[8].n
      LET sr.rate8=g_hreb[8].rate
      LET sr.m9=g_hreb[9].m
      LET sr.n9=g_hreb[9].n
      LET sr.rate9=g_hreb[9].rate
      LET sr.m10=g_hreb[10].m
      LET sr.n10=g_hreb[10].n
      LET sr.rate10=g_hreb[10].rate
      LET sr.m11=g_hreb[11].m
      LET sr.n11=g_hreb[11].n
      LET sr.rate11=g_hreb[11].rate
      LET sr.m12=g_hreb[12].m
      LET sr.n12=g_hreb[12].n
      LET sr.rate12=g_hreb[12].rate
      
      LET sr.m01=g_hreb[1].m+g_hreb[2].m+g_hreb[3].m
      LET sr.m02=g_hreb[4].m+g_hreb[5].m+g_hreb[6].m
      LET sr.m03=g_hreb[7].m+g_hreb[8].m+g_hreb[9].m
      LET sr.m04=g_hreb[10].m+g_hreb[11].m+g_hreb[12].m
      LET sr.n01=g_hreb[1].n+g_hreb[2].n+g_hreb[3].n
      LET sr.n02=g_hreb[4].n+g_hreb[5].n+g_hreb[6].n
      LET sr.n03=g_hreb[7].n+g_hreb[8].n+g_hreb[9].n
      LET sr.n04=g_hreb[10].n+g_hreb[11].n+g_hreb[12].n
      
      LET sr.m_p=(sr.m01+sr.m02+sr.m03+sr.m04)/12
      LET sr.n_p=(sr.n01+sr.n02+sr.n03+sr.n04)/12
      IF sr.m_p<>0 THEN
         LET sr.rate_p=sr.n_p/sr.m_p
      END IF
      
      IF sr.m_s<>0 THEN
         LET sr.rate_s=sr.n_s/sr.m_s
      END IF
      
      IF sr.m01<>0 THEN
         LET sr.rate01=sr.n01/sr.m01
      END IF
      IF sr.m02<>0 THEN
         LET sr.rate02=sr.n02/sr.m02
      END IF
      IF sr.m03<>0 THEN
         LET sr.rate03=sr.n01/sr.m03
      END IF
      IF sr.m04<>0 THEN
         LET sr.rate04=sr.n04/sr.m04
      END IF
     
  LET  sr.sum_m1=sr.sum_m1+sr.m1     
  LET  sr.sum_n1=sr.sum_n1+sr.n1   
  LET  sr.sum_rate1=sr.sum_rate1+sr.rate1  
  LET  sr.sum_m2=sr.sum_m2+sr.m2   
  LET  sr.sum_n2=sr.sum_n2+sr.n2     
  LET  sr.sum_rate2=sr.sum_rate2+sr.rate2   
  LET  sr.sum_m3=sr.sum_m3+sr.m3     
  LET  sr.sum_n3=sr.sum_n3+sr.n3   
  LET  sr.sum_rate3=sr.sum_rate3+sr.rate3  
  LET  sr.sum_m01=sr.sum_m01+sr.m01   
  LET  sr.sum_n01=sr.sum_n01+sr.n01    
  LET  sr.sum_rate01=sr.sum_rate01+sr.rate01   
  LET  sr.sum_m4=sr.sum_m4+sr.m4     
  LET  sr.sum_n4=sr.sum_n4+sr.n4   
  LET  sr.sum_rate4=sr.sum_rate4+sr.rate4  
  LET  sr.sum_m5=sr.sum_m5+sr.m5   
  LET  sr.sum_n5=sr.sum_n5+sr.n5     
  LET  sr.sum_rate5=sr.sum_rate5+sr.rate5   
  LET  sr.sum_m6=sr.sum_m6+sr.m6     
  LET  sr.sum_n6=sr.sum_n6+sr.n6   
  LET  sr.sum_rate6=sr.sum_rate6+sr.rate6  
  LET  sr.sum_m02=sr.sum_m02+sr.m02   
  LET  sr.sum_n02=sr.sum_n02+sr.n02    
  LET  sr.sum_rate02=sr.sum_rate02+sr.rate02   
  LET  sr.sum_m7=sr.sum_m7+sr.m7     
  LET  sr.sum_n7=sr.sum_n7+sr.n7   
  LET  sr.sum_rate7=sr.sum_rate7+sr.rate7  
  LET  sr.sum_m8=sr.sum_m8+sr.m8   
  LET  sr.sum_n8=sr.sum_n8+sr.n8     
  LET  sr.sum_rate8=sr.sum_rate8+sr.rate8   
  LET  sr.sum_m9=sr.sum_m9+sr.m9     
  LET  sr.sum_n9=sr.sum_n9+sr.n9   
  LET  sr.sum_rate9=sr.sum_rate9+sr.rate9  
  LET  sr.sum_m03=sr.sum_m03+sr.m03   
  LET  sr.sum_n03=sr.sum_n03+sr.n03    
  LET  sr.sum_rate03=sr.sum_rate03+sr.rate03   
  LET  sr.sum_m10=sr.sum_m10+sr.m10  
  LET  sr.sum_n10=sr.sum_n10+sr.n10   
  LET  sr.sum_rate10=sr.sum_rate10+sr.rate10  
  LET  sr.sum_m11=sr.sum_m11+sr.m11   
  LET  sr.sum_n11=sr.sum_n11+sr.n11    
  LET  sr.sum_rate11=sr.sum_rate11+sr.rate11  
  LET  sr.sum_m12=sr.sum_m12+sr.m12    
  LET  sr.sum_n12=sr.sum_n12+sr.n12  
  LET  sr.sum_rate12=sr.sum_rate12+sr.rate12 
  LET  sr.sum_m04=sr.sum_m04+sr.m04   
  LET  sr.sum_n04=sr.sum_n04+sr.n04     
  LET  sr.sum_rate04=sr.sum_rate04+sr.rate04   
  LET  sr.sum_m_s=sr.sum_m_s+sr.m_s     
  LET  sr.sum_n_s=sr.sum_n_s+sr.n_s   
  LET  sr.sum_rate_s=sr.sum_rate_s+sr.rate_s  
  LET  sr.sum_m_p=sr.sum_m_p+sr.m_p   
  LET  sr.sum_n_p=sr.sum_n_p+sr.n_p     
  LET  sr.sum_rate_p=sr.sum_rate_p+sr.rate_p  
  
  IF l_count1=l_count THEN 
     LET  sr.sum_rate1=sr.sum_rate1/l_count1
     LET  sr.sum_rate2=sr.sum_rate2/l_count1
     LET  sr.sum_rate3=sr.sum_rate3/l_count1
     LET  sr.sum_rate4=sr.sum_rate4/l_count1
     LET  sr.sum_rate5=sr.sum_rate5/l_count1
     LET  sr.sum_rate6=sr.sum_rate6/l_count1
     LET  sr.sum_rate7=sr.sum_rate7/l_count1
     LET  sr.sum_rate8=sr.sum_rate8/l_count1
     LET  sr.sum_rate9=sr.sum_rate9/l_count1
     LET  sr.sum_rate10=sr.sum_rate10/l_count1
     LET  sr.sum_rate11=sr.sum_rate11/l_count1
     LET  sr.sum_rate12=sr.sum_rate12/l_count1
     LET  sr.sum_rate01=sr.sum_rate01/l_count1
     LET  sr.sum_rate02=sr.sum_rate02/l_count1
     LET  sr.sum_rate03=sr.sum_rate03/l_count1
     LET  sr.sum_rate04=sr.sum_rate04/l_count1
     LET  sr.sum_rate_s=sr.sum_rate_s/l_count1
     LET  sr.sum_rate_p=sr.sum_rate_p/l_count1
     
  END IF
         
       
         EXECUTE insert_prep USING sr.*
   END FOREACH  
   FOREACH ghrr040_curs2 INTO sr2.l_month,sr2.sum1,sr2.sum2
     IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
     END IF
         EXECUTE insert_prep1 USING sr2.*
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr040','ghrr040',g_sql,g_str)     #第一个ghrr040是程序名字  第二是模板名字 p_zaw
END FUNCTION

FUNCTION r040_get_items()
DEFINE p_name   STRING
DEFINE p_hrac01 LIKE hrac_file.hrac01
DEFINE l_sql    STRING

       LET p_name=''

       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  WHERE hrac01 NOT IN( SELECT hrct04 FROM hrct_file WHERE hrct06='Y')",
                 "  ORDER BY hrac01 "
       PREPARE i099_get_items_pre FROM l_sql
       DECLARE i099_get_items CURSOR FOR i099_get_items_pre
       FOREACH i099_get_items INTO p_hrac01
          IF cl_null(p_name) THEN
            LET p_name=p_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrac01 CLIPPED
          END IF
       END FOREACH

       RETURN p_name
END FUNCTION


