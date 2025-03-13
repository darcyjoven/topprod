# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr035.4gl
# Descriptions...: 出貨單
# Date & Author..: No.FUN-7B0073 08/01/15 by sherry
# Modify ........: No.MOD-890032 chenyu 選擇多張出貨單打印的時候，會彈出多個IE瀏覽器
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5
END GLOBALS
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,             # Where condition
              a       LIKE type_file.chr1,              # print price
              b       LIKE type_file.chr1,              # print memo
              c       LIKE type_file.chr1,              # print Sub Item#   
              more    LIKE type_file.chr1               # Input more condition(Y/N)
              END RECORD,
          g_m  ARRAY[40] OF LIKE oao_file.oao06,  
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000
 
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10
DEFINE l_i,l_cnt        LIKE type_file.num5
DEFINE g_sql            STRING                                                  
DEFINE g_str            STRING                                                  
DEFINE l_table          STRING 
DEFINE l_table1         STRING 
DEFINE l_table2         STRING 
DEFINE l_table3         STRING 
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF    
 
   LET g_sql = "occ02.occ_file.occ02,",
               "oga01.oga_file.oga01,",
               "oga09.oga_file.oga09,",
               "oaydesc.oay_file.oaydesc,",
               "oag02.oag_file.oag02,",
               "oga02.oga_file.oga02,",
               "oga11.oga_file.oga11,",
               "oga23.oga_file.oga23,",
               "oga24.oga_file.oga24,",
               "gen02.gen_file.gen02,",
               "oga908.oga_file.oga908,",
               "occ261.occ_file.occ261,",
               "oma10.oma_file.oma10,",
               "oga011.oga_file.oga011,",
               "l_addr1.type_file.chr1000,",
               "ogb04.ogb_file.ogb04,",
               "ogb05.ogb_file.ogb05,",
               "ogb03.ogb_file.ogb03,",
               "ogc09.ogc_file.ogc09,",
               "ogc091.ogc_file.ogc091,",
               "ogc092.ogc_file.ogc092,",
               "ogc16.ogc_file.ogc16,",
               "oea10.oea_file.oea10,",
               "ogb12.ogb_file.ogb12,",
               "l_spare.ogb_file.ogb12,",
               "l_spare2.ogb_file.ogb12 "
              
   LET l_table = cl_prt_temptable('aicr035',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06 " 
 
   LET l_table1 = cl_prt_temptable('aicr0351',g_sql)CLIPPED                       
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oao01.oao_file.oao01,",                                         
               "oao03.oao_file.oao03,",                                         
               "oao05.oao_file.oao05,",                                         
               "oao06.oao_file.oao06 "                                          
                                                                                
   LET l_table2 = cl_prt_temptable('aicr0352',g_sql)CLIPPED                     
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oao01.oao_file.oao01,",                                         
               "oao03.oao_file.oao03,",                                         
               "oao05.oao_file.oao05,",                                         
               "oao06.oao_file.oao06 "                                          
                                                                                
   LET l_table3 = cl_prt_temptable('aicr0353',g_sql)CLIPPED                     
   IF l_table3 = -1 THEN EXIT PROGRAM END IF                                                                                                     
               
   INITIALIZE tm.* TO NULL                # Default condition
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044
   IF cl_null(tm.wc) THEN
      CALL aicr035_tm(0,0)             # Input print condition
   ELSE
      LET tm.a = "1"    
      CALL aicr035()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION aicr035_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col LIKE type_file.num5
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_oaz23     LIKE oaz_file.oaz23  
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW aicr035_w AT p_row,p_col WITH FORM "aic/42f/aicr035"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                  
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  
                 LET g_qryparam.arg1 = "2','3','4','6','7','8" 
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
            END CASE
 
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
         CLOSE WINDOW aicr035_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a = '1'
      LET tm.b = 'Y'
      LET tm.c = 'N'     
      INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS  
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
        AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
             NEXT FIELD c
          END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
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
 
         ON ACTION about        
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help() 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aicr035_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'aicr035'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr035','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",          
                        " '",g_rep_clas CLIPPED,"'",         
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('aicr035',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aicr035_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044       
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL aicr035()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aicr035_w
 
END FUNCTION
 
FUNCTION aicr035()
   DEFINE l_name    LIKE type_file.chr20 ,        # External(Disk) file name
          l_time    LIKE type_file.chr8,          # Used time for running the job
          #l_sql     LIKE type_file.chr1000,
          l_sql      STRING,     #NO.FUN-910082
          l_za05    LIKE type_file.chr1000,
          sr        RECORD
                       oga01     LIKE oga_file.oga01,
                       oaydesc   LIKE oay_file.oaydesc,
                       oga02     LIKE oga_file.oga02,
                       oga021    LIKE oga_file.oga021,
                       oga011    LIKE oga_file.oga011,
                       oga14     LIKE oga_file.oga14,
                       oga15     LIKE oga_file.oga15,
                       oga16     LIKE oga_file.oga16,
                       oga032    LIKE oga_file.oga032,
                       oga03     LIKE oga_file.oga03,
                       oga033    LIKE oga_file.oga033,   #稅號
                       oga45     LIKE oga_file.oga45,    #聯絡人
                       occ02     LIKE occ_file.occ02,
                       oga04     LIKE oga_file.oga04,
                       oga044    LIKE oga_file.oga044,		       
                       ogb03     LIKE ogb_file.ogb03,
                       ogb31     LIKE ogb_file.ogb31,
                       ogb32     LIKE ogb_file.ogb32,
                       ogb04     LIKE ogb_file.ogb04,
                       ogb092    LIKE ogb_file.ogb092,
                       ogb05     LIKE ogb_file.ogb05,
                       ogb12     LIKE ogb_file.ogb12,
                       ogb06     LIKE ogb_file.ogb06,
                       ogb11     LIKE ogb_file.ogb11,
                       ogb17     LIKE ogb_file.ogb17,
                       ogb19     LIKE ogb_file.ogb19,     
                       ogb910    LIKE ogb_file.ogb910,     
                       ogb912    LIKE ogb_file.ogb912,    
                       ogb913    LIKE ogb_file.ogb913,     
                       ogb915    LIKE ogb_file.ogb915,    
                       ogb916    LIKE ogb_file.ogb916,   
                       ima18     LIKE ima_file.ima18,
		       oga32     LIKE oga_file.oga32,  
		       oga11     LIKE oga_file.oga11,
		       oga23     LIKE oga_file.oga23,
		       oga24     LIKE oga_file.oga24,
		       oga908    LIKE oga_file.oga908,
		       oga10	 LIKE oga_file.oga10,
		       occ261    LIKE occ_file.occ261,
		       ogb09     LIKE ogb_file.ogb09,
		       ogb091    LIKE ogb_file.ogb091		
                    END RECORD
   DEFINE l_spare   LIKE ogb_file.ogb12
   DEFINE l_spare2  LIKE ogb_file.ogb12
   DEFINE ofa       RECORD
                      ofa23     LIKE ofa_file.ofa23
                    END RECORD
   DEFINE l_ogc     RECORD
                      ogc09     LIKE ogc_file.ogc09,
                      ogc091    LIKE ogc_file.ogc091,
                      ogc16     LIKE ogc_file.ogc16,
                      ogc092    LIKE ogc_file.ogc092
                    END RECORD,
            l_buf      ARRAY[10] OF LIKE ogc_file.ogc16,
            l_buf3     ARRAY[10] OF LIKE ogc_file.ogc16,
            l_buf4     ARRAY[10] OF LIKE ogc_file.ogc16,
            l_buf2     ARRAY[10] OF LIKE ogc_file.ogc16,
            l_flag     LIKE type_file.chr1,
            l_addr1    LIKE type_file.chr1000,
            l_addr2    LIKE type_file.chr1000,
            l_addr3    LIKE type_file.chr1000,
            l_addr4    LIKE type_file.chr1000,
            l_addr5    LIKE type_file.chr1000,
            l_gen02    LIKE gen_file.gen02,
            l_oag02    LIKE oag_file.oag02,
            l_gem02    LIKE gem_file.gem02,
            l_ogb12    LIKE ogb_file.ogb12,
            i,j,l_n    LIKE type_file.num5
   DEFINE  l_ogb915    LIKE ogb_file.ogb915
   DEFINE  l_ogb912    LIKE ogb_file.ogb912
   DEFINE  l_str2      LIKE type_file.chr1000
   DEFINE  l_ima906    LIKE ima_file.ima906
   DEFINE  l_ima021    LIKE ima_file.ima021
   DEFINE  l_oga09     LIKE oga_file.oga09
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
   DEFINE  l_i         LIKE type_file.num10
   DEFINE  g_ogc       RECORD
                 ogc12 LIKE ogc_file.ogc12,
                 ogc17 LIKE ogc_file.ogc17
           END RECORD
   DEFINE  l_oaz23     LIKE oaz_file.oaz23
   DEFINE  l_ima02     LIKE ima_file.ima02
   DEFINE  #g_sql       LIKE type_file.chr1000 
           g_sql      STRING     #NO.FUN-910082
   DEFINE  l_oma10     LIKE oma_file.oma10					
   DEFINE  l_oea10     LIKE oea_file.oea10
   DEFINE  l_total     LIKE ogb_file.ogb12 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,             
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                     
               "        ?,?,?,?,?, ?,?,?,?,?, ? ) "                             
   PREPARE insert_prep FROM g_sql                                               
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM                         
   END IF       
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table1 CLIPPED,             
               " values(?,?,?,?) "                     
   PREPARE insert_prep1 FROM g_sql                                               
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM                         
   END IF    
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table2 CLIPPED,            
               " values(?,?,?,?) "                                              
   PREPARE insert_prep2 FROM g_sql                                              
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM                        
   END IF       
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table3 CLIPPED,            
               " values(?,?,?,?) "                                              
   PREPARE insert_prep3 FROM g_sql                                              
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep3:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM                        
   END IF   
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   #CALL cl_used(g_prog,l_time,1) RETURNING l_time    #FUN-B90044   MARK
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的數據
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的數據
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
 
   LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,   ",
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,",
             "       ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18,",        
	     "       oga32,oga11,oga23,oga24,oga908,oga10,occ261,ogbiicd02,",
             "       ogb09,ogb091 ",							
             "  FROM oga_file,ogb_file,ogbi_file, OUTER occ_file,",
             "   oay_file,",
             "  OUTER ima_file ",
             " WHERE oga01 like rtrim(ltrim(oayslip)) || '-%' AND oga_file.oga04=occ_file.occ01",
             "   AND oga01=ogb01 ",
             "   AND ogb01 = ogbi01",
             "   AND oga09 != '1' AND  oga09 != '5' AND oga09 !='9'", 
	     "   AND ogbiicd03 <>2 ",
             "   AND ogb_file.ogb04=ima_file.ima01 AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " 
 
   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
 
   PREPARE aicr035_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
 
   DECLARE aicr035_curs1 CURSOR FOR aicr035_prepare1
 
   SELECT sma115 INTO g_sma115 FROM sma_file
 
   FOREACH aicr035_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ogb092 IS NULL THEN
         LET sr.ogb092 = ' '
      END IF
       SELECT COALESCE(ogb12,0) INTO l_spare FROM ogb_file,ogbi_file 
        WHERE ogb01=sr.oga01 AND ogb31=sr.ogb31 AND ogb32 = sr.ogb32 
         AND ogb01 = ogbi01 AND ogbiicd03=2
         AND ogb04=sr.ogb04 AND ogb09=sr.ogb09 AND ogb091=sr.ogb091 AND ogb092=sr.ogb092
	 IF SQLCA.SQLCODE THEN LET l_spare=0 END IF
	 
	 SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
         IF STATUS THEN
            LET l_gen02 = ''
         END IF
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
         IF STATUS THEN
            LET l_gem02 = ''
         END IF
 
         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
              RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5
         IF SQLCA.SQLCODE THEN
            LET l_addr1 = ''
            LET l_addr2 = ''
            LET l_addr3 = ''
         END IF
 
	SELECT oma10 INTO l_oma10 FROM oma_file WHERE oma01=sr.oga10
	SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=ofa.ofa23			#幣種檔案小數位數讀取
	SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oga32
	IF SQLCA.SQLCODE THEN LET l_oag02 =NULL END IF
 
        IF tm.b = 'Y'  THEN     #打印備注于表頭
           CALL r600_oao(sr.oga01,0,'1')
           FOR l_n = 1 TO 40
               IF NOT cl_null(g_m[l_n]) THEN
                  EXECUTE insert_prep1 USING sr.oga01,sr.ogb03,'1',g_m[l_n] 
               ELSE
                  LET l_n = 40
               END IF
           END FOR
       END IF
 
       LET l_i = 0
 
       FOR i = 1 TO 10
           INITIALIZE l_buf[i]  TO NULL
           INITIALIZE l_buf3[i] TO NULL 
           INITIALIZE l_buf[i]  TO NULL 
           INITIALIZE l_buf2[i] TO NULL
       END FOR
 
       IF tm.a ='1' THEN
          CASE sr.ogb17 #多倉位批出貨否 (Y/N)
            WHEN 'Y'
              LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
                        " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
            WHEN 'N'
              LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
                        " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
         END CASE
       ELSE
         LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
                   " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
                   "   AND img10 > 0 "
       END IF
 
  PREPARE r600_p2 FROM l_sql
  DECLARE r600_c2 CURSOR FOR r600_p2
 
  IF tm.b = 'Y'  THEN     #打印備注于單身前
     CALL r600_oao(sr.oga01,sr.ogb03,'1')
     FOR l_n = 1 TO 40
      IF NOT cl_null(g_m[l_n]) THEN
         EXECUTE insert_prep2 USING sr.oga01,sr.ogb03,'1',g_m[l_n]
      ELSE
         LET l_n = 40
      END IF
     END FOR
  END IF
 
  SELECT ima02,ima021,ima906 
    INTO l_ima02,l_ima021,l_ima906 
    FROM ima_file
   WHERE ima01=sr.ogb04
   LET l_str2 = ""
    IF g_sma115 = "Y" THEN
       CASE l_ima906
            WHEN "2"
              CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
              LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
              IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                 CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                 LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
              ELSE
                 IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                 END IF
              END IF
           WHEN "3"
                 IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                 END IF
       END CASE
     ELSE
     END IF
     IF g_sma.sma116 MATCHES '[23]' THEN   
            IF sr.ogb910 <> sr.ogb916 THEN
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
 
	 SELECT oea10 INTO l_oea10 FROM oea_file WHERE oea01=sr.ogb31
	 IF SQLCA.SQLCODE THEN LET l_oea10=NULL END IF
	 SELECT COALESCE(ogb12,0) INTO l_spare2 FROM ogb_file,ogbi_file 
	  WHERE ogb01=sr.oga01 AND ogb31=sr.ogb31 AND ogb32 = sr.ogb32 
          AND ogb01 = ogbi01 AND ogbiicd03=2
          AND ogb04=sr.ogb04 AND ogb09=sr.ogb09 AND ogb091= sr.ogb091 
          AND ogb092=sr.ogb092
	 IF SQLCA.SQLCODE THEN LET l_spare2=0 END IF 
 
   LET i=0
   FOREACH r600_c2 INTO l_ogc.*
     IF STATUS THEN EXIT FOREACH END IF
     LET i=i+1
     IF i > 10 THEN LET i=10 EXIT FOREACH END IF
   END FOREACH         
   IF l_oga09 = '8' THEN
      SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
       WHERE oga01 = ogb01 AND oga011 = sr.oga011
         AND ogb03 = sr.ogb03 AND oga09 = '9'
      IF SQLCA.sqlcode = 0 THEN
         IF g_sma115 = "Y" THEN
            CASE l_ima906
              WHEN "2"
                CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
                IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
                   CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                   LET l_str2 = l_ogb912, l_ogb.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
                      CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
                   END IF
                END IF
              WHEN "3"
                  IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
                     CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                     LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
                  END IF
            END CASE
          END IF
          IF g_sma.sma116 MATCHES '[23]' THEN  
             IF l_ogb.ogb910 <> l_ogb.ogb916 THEN
                CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
                LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
             END IF
          END IF
          LET l_str2=l_str2 CLIPPED,(21-LENGTH(l_str2 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
        END IF
      END IF
 
      IF tm.b = 'Y'  THEN     #打印備注于單身后
         CALL r600_oao(sr.oga01,sr.ogb03,'2')
         FOR l_n = 1 TO 40
             IF NOT cl_null(g_m[l_n]) THEN
                EXECUTE insert_prep3 USING sr.oga01,sr.ogb03,'2',g_m[l_n]
             ELSE
                LET l_n = 40
             END IF
         END FOR
      END IF
     
	  IF cl_null(l_spare) then
	     LET l_spare=0
	  END IF
	  LET l_total= l_ogb12+l_spare
    EXECUTE insert_prep USING sr.occ02,sr.oga01,l_oga09,sr.oaydesc,l_oag02,
                              sr.oga02,sr.oga11,sr.oga23,sr.oga24,l_gen02,
                              sr.oga908,sr.occ261,l_oma10,sr.oga011,l_addr1,
                              sr.ogb04,sr.ogb05,sr.ogb03,l_ogc.ogc09,l_ogc.ogc091,
                              l_ogc.ogc092,l_ogc.ogc16,l_oea10,sr.ogb12,l_spare,
                              l_spare2  
   END FOREACH     #No.MOD-890032 add
	                          
    IF g_zz05 = 'Y' THEN                                                       
       CALL cl_wcchp(tm.wc,'oga01,oga02')                          
         RETURNING tm.wc                                                       
    END IF                                                                     
    LET g_str = tm.wc,";",tm.b                               
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,"|",                                                           
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                           
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",                                                           
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED             
    CALL cl_prt_cs3('aicr035','aicr035',l_sql,g_str)   
 # END FOREACH     #No.MOD-890032 mark
 
   #CALL cl_used(g_prog,l_time,2) RETURNING l_time    #FUN-B90044   MARK
 
END FUNCTION
 
FUNCTION r600_oao(l_p1,l_p3,l_p5)
   DEFINE l_p1   LIKE oao_file.oao01,
          l_p3   LIKE oao_file.oao03,
          l_p5   LIKE oao_file.oao05,
          l_n    LIKE type_file.num5
 
   FOR l_n = 1 TO 40
      LET g_m[l_n] = ''
   END FOR
 
   DECLARE r600_c5 CURSOR FOR SELECT oao06 FROM oao_file
                               WHERE oao01 = l_p1
                                 AND oao03 = l_p3
                                 AND oao05 = l_p5
 
   LET l_n = 1
 
   FOREACH r600_c5 INTO g_m[l_n]
      LET l_n = l_n + 1
   END FOREACH
 
END FUNCTION
#Patch....NO.TQC-610037 <> #
