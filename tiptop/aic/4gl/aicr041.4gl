# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aicr041.4gl
# Desc/riptions..: Wafer采購單
# Date & Author..: 08/01/08 By xiaofeizhu
# Modify FUN-7B0027
# Modify FUN-830068
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.CHI-920072 09/02/24 By ve007 無法打印的BUG
# Modify.........: No.FUN-930113 09/03/18 By mike 將oah_file-->pnz_file
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40038 10/05/06 By liuxqa modify sql
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   
  DEFINE g_seq_item    LIKE type_file.num5
END GLOBALS
 
   DEFINE tm  RECORD				
       	  #  	wc      LIKE type_file.chr1000,	
       	      wc      STRING,          #NO.FUN-910082	
                a       LIKE type_file.chr1,
    	        b     LIKE type_file.chr1,
    	        c    	LIKE type_file.num5,
                more    LIKE type_file.chr1
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
   #DEFINE g_rpt_name  LIKE type_file.chr20 
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5   
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
DEFINE   g_rlang_2        LIKE type_file.chr1
DEFINE   l_table1        STRING                                                                                                     
DEFINE   l_table2        STRING                                                                                                     
DEFINE   l_table3        STRING                                                                                                     
DEFINE   g_str           STRING                                                                                                       
DEFINE   g_sql           STRING
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     
 
   LET g_pdate  = ARG_VAL(1)	             
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1) EXIT PROGRAM                                                                                      
   END IF
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " pmm01.pmm_file.pmm01,",                                                                                            
               " smydesc.smy_file.smydesc,",                                                                                        
               " pmm04.pmm_file.pmm04,",                                                                                            
               " l_pme031.pme_file.pme031,",                                                                                        
               " l_pme032.pme_file.pme032,",                                                                                        
               " pmm09.pmm_file.pmm09,",                                                                                            
               " pmc081.pmc_file.pmc081,",                                                                                          
               " pmc091.pmc_file.pmc091,",                                                                                          
               " l_pmd02.pmd_file.pmd02,",                                                                                          
               " pmc10.pmc_file.pmc10,",                                                                                            
               " pmc11.pmc_file.pmc11,",                                                                                            
               " pma02.pma_file.pma02,",                                                                                            
               " pmm22.pmm_file.pmm22,",                                                                                            
               " gec02.gec_file.gec02,",                                                                                            
               " pmn02.pmn_file.pmn02,",                                                                                            
               " pmn04.pmn_file.pmn04,",                                                                                            
               " pmn07.pmn_file.pmn07,",                                                                                            
               " pmn33.pmn_file.pmn33,",                                                                                            
               " pmn31.pmn_file.pmn31,",                                                                                            
               " pmn20.pmn_file.pmn20,",                                                                                            
               " pmn88.pmn_file.pmn88,",                                                                                            
               " pmn88t.pmn_file.pmn88t,",
               " pmn041.pmn_file.pmn041,",                                                                                          
               " l_ima021.ima_file.ima021,",                                                                                        
               " azi05.azi_file.azi05,",                                                                                            
               " l_username.gen_file.gen02,",                                                                                       
               " pmn24.pmn_file.pmn24,",                                                                                            
               " pmn25.pmn_file.pmn25,",
               " l_mask_layer.type_file.chr1000"                                                                                              
                                                                                                                                    
   LET l_table1 = cl_prt_temptable('aicr0411',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
                                                                                                                                    
   LET g_sql = " pmm01.pmm_file.pmm01,",                                                                                            
               " l_pmo06.pmo_file.pmo06"                                                                                            
                                                                                                                                    
   LET l_table2 = cl_prt_temptable('aicr0412',g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                                                                                        
                                                                                                                                    
   LET g_sql = " pmm01.pmm_file.pmm01,",                                                                                            
               " l_pmo06.pmo_file.pmo06"                                                                                            
                                                                                                                                    
   LET l_table3 = cl_prt_temptable('aicr0413',g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN EXIT PROGRAM END IF                                                                                        
#--------------------------CR(1)--------------------------------#
 
   IF cl_null(g_rlang) THEN
      LET g_rlang=g_lang
   END IF
   LET g_rlang_2 = g_rlang    
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)   
 
      THEN CALL r900_tm(0,0)		
      ELSE CALL aicr041()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r900_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd	 LIKE type_file.chr1000
DEFINE g_pmn01     LIKE pmn_file.pmn01
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r900_w AT p_row,p_col WITH FORM "aic/42f/aicr041"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			
   LET tm.a    = 'Y'
   LET tm.b    = 'N'
   LET tm.c    = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_rlang_2 = g_rlang            
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm12
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
 
ON ACTION CONTROLP
            CALL q_pmm(FALSE,TRUE,g_pmn01) RETURNING g_pmn01
            DISPLAY g_pmn01 TO pmm01
 
 
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
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','0416',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
                 LET g_rlang_2 = g_rlang        
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	
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
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='aicr041'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr041','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aicr041',g_time,l_cmd)      
      END IF
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr041()
   ERROR ""
END WHILE
   CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION aicr041()
   DEFINE l_name LIKE type_file.chr20,		
          l_time LIKE type_file.chr8,		
          l_sql  LIKE type_file.chr1000,		
          l_chr	 LIKE type_file.chr1,
          l_za05 LIKE type_file.chr50,
          l_zaa08       LIKE zaa_file.zaa08,   
          l_dash        LIKE type_file.chr1,                                                                                                 
          l_count       LIKE type_file.num5,                                                                                                   
          l_n           LIKE type_file.num5,                                                                                                   
          l_zaa09       LIKE zaa_file.zaa09,                                                                                        
          l_zaa14       LIKE zaa_file.zaa14,                                                                                        
          l_zaa16       LIKE zaa_file.zaa16,                                                                                        
          l_memo        LIKE zab_file.zab05,                                                                                        
          l_zaa08_trim  STRING,                                                                                                     
          sr   RECORD
                     pmm01     LIKE pmm_file.pmm01,    #采購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pmm04     LIKE pmm_file.pmm04,    #采購日期
                     pmc081    LIKE pmc_file.pmc081,   #供貨商全名
                     pmc091    LIKE pmc_file.pmc081,   #供貨商地址
                     pmc10     LIKE pmc_file.pmc10 ,   #供貨商電話
                     pmc11     LIKE pmc_file.pmc11 ,   #供貨商傳真
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pmm41     LIKE pmm_file.pmm41,    #價格條件
                     pnz02     LIKE pnz_file.pnz02,    #價格條件說明 #FUN-930113 oah-->pnz
                     gec02     LIKE gec_file.gec02,    #稅別
                     pmm09     LIKE pmm_file.pmm09,    #廠商編號
                     pmm10     LIKE pmm_file.pmm10,    #送貨地址
                     pmm11     LIKE pmm_file.pmm11,    #賬單地址
                     pmm22     LIKE pmm_file.pmm22,    #幣別
                     pmn02     LIKE pmn_file.pmn02,    #項次
                     pmn04     LIKE pmn_file.pmn04,    #料件編號
                     pmn041    LIKE pmn_file.pmn041,   #品名規格
                     pmn07     LIKE pmn_file.pmn07,    #單位
                     pmn20     LIKE pmn_file.pmn20,    #數量
                     pmn31     LIKE pmn_file.pmn31,    #未稅單價
                     pmn88     LIKE pmn_file.pmn88,    #未稅金額
                     pmn33     LIKE pmn_file.pmn33,    #交貨日
                     pmn15     LIKE pmn_file.pmn15,    #提前交貨
                     pmn14     LIKE pmn_file.pmn14,    #部份交貨
                     pmn24     LIKE pmn_file.pmn24,    #請購單號
                     pmn25     LIKE pmn_file.pmn25,    #請購項次
                     pmn06     LIKE pmn_file.pmn06,    #廠商料號
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05,
                     pmc911    LIKE pmc_file.pmc911,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     pmn08     LIKE pmn_file.pmn08,               
                     pmn09     LIKE pmn_file.pmn09,               
                     pmn80     LIKE pmn_file.pmn80,               
                     pmn82     LIKE pmn_file.pmn82,               
                     pmn83     LIKE pmn_file.pmn83,               
                     pmn85     LIKE pmn_file.pmn85,               
                     pmn86     LIKE pmn_file.pmn86,    #計價單位  
                     pmn87     LIKE pmn_file.pmn87     #計價數量  
        END RECORD,
        sr1          RECORD                                                                                                         
                     pmm04     LIKE pmm_file.pmm04,                                                                                 
                     pmm01     LIKE pmm_file.pmm01,                                                                                 
                     pmc03     LIKE pmc_file.pmc03,                                                                                 
                     pmn20     LIKE pmn_file.pmn20,                                                                                 
                     pmn07     LIKE pmn_file.pmn07,                                                                                 
                     pmm22     LIKE pmm_file.pmm22,                                                                                 
                     pmn31     LIKE pmn_file.pmn31,                                                                                 
                     pmn88     LIKE pmn_file.pmn88,                                                                                 
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價                                                                    
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額                                                                    
                     pmn08     LIKE pmn_file.pmn08,                                                                                 
                     pmn09     LIKE pmn_file.pmn09,                                                                                 
                     pmn80     LIKE pmn_file.pmn80,                                                                                 
                     pmn82     LIKE pmn_file.pmn82,                                                                                 
                     pmn83     LIKE pmn_file.pmn83,                                                                                 
                     pmn85     LIKE pmn_file.pmn85,                                                                                 
                     pmn86     LIKE pmn_file.pmn86,    #計價單位                                                                    
                     pmn87     LIKE pmn_file.pmn87     #計價數量                                                                    
                     END RECORD,
        l_pmo06      LIKE pmo_file.pmo06,                                                                                           
        l_pme031     LIKE pme_file.pme031,                                                                                          
        l_pme032     LIKE pme_file.pme032,                                                                                          
        l_ima021     LIKE ima_file.ima021,                                                                                          
        l_ima906     LIKE ima_file.ima906,                                                                                          
        l_flag       LIKE type_file.chr1,                                                                                                   
        l_tot        LIKE type_file.num5,                                                                                                      
        l_str        LIKE type_file.chr1000,                                                                                                  
        l_str2       LIKE type_file.chr1000,                                                                                                  
        l_totamt     LIKE pmm_file.pmm40,                                                                                           
        l_totamt1    LIKE pmn_file.pmn88t,                                                                                          
        l_tax        LIKE type_file.num5,                                                                                                      
        l_pmn85      STRING,                                                                                                        
        l_pmn82      STRING,                                                                                                        
        l_pmn20      STRING,                                                                                                        
        l_pmn24      STRING,                                                                                                        
        l_pmn06      STRING,                                                                                                        
        l_pmd02         LIKE pmd_file.pmd02
     DEFINE l_ima06     LIKE ima_file.ima06                                                                                         
     DEFINE l_ice05     LIKE ice_file.ice05                                                                                             
     DEFINE l_mask_layer LIKE type_file.chr1000                                                                                               
     DEFINE l_imaicd01  LIKE imaicd_file.imaicd01                                                                                       
     DEFINE l_username  LIKE gen_file.gen02                                                                                         
     DEFINE l_ice09     LIKE ice_file.ice09                                                                                             
     DEFINE l_ima03     LIKE ima_file.ima03                                                                                         
     DEFINE i           LIKE type_file.num5
     DEFINE l_i,l_cnt   LIKE type_file.num5
     DEFINE l_zaa02     LIKE zaa_file.zaa02
     DEFINE l_zab05     LIKE zab_file.zab05
     
     CALL g_zaa_dyn.clear()          
 
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time   #FUN-B90044
 
#--------------------------CR(2)--------------------------------#                                                                   
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)                                                                                                     
     CALL cl_del_data(l_table3)                                                                                                     
                                                                                                                                    
#    LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED, 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                        
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ? ) "                                                                                
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
#    LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,   
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                      
                 " VALUES(?,? )        "                                                                                            
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                                                                          
     END IF
 
#    LET g_sql = "INSERT INTO ds_report.",l_table3 CLIPPED, 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                                        
                 " VALUES(?,? )        "                                                                                            
     PREPARE insert_prep2 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#------------------------CR(2)------------------------------------#
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的數據
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的數據
     #        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
#     LET l_sql = "SELECT pmm01,smydesc,pmm04,pmc081,pmc091,pmc10,pmc11,",
      LET l_sql = "SELECT  unique pmm01,smydesc,pmm04,pmc081,pmc091,pmc10,pmc11,",   #Mo.CHI-920072
                 "       pma02,pmm41,pnz02,", #FUN-930113 oah-->pnz 
                 "       gec02,pmm09,pmm10,pmm11,pmm22,pmn02,pmn04,pmn041,",
                 "       pmn07,pmn20,pmn31,pmn88,pmn33,pmn15,",
                 "       pmn14,pmn24,pmn25,pmn06,azi03,azi04,azi05,pmc911, ",
                 "       pmn31t,pmn88t,pmn08,pmn09,pmn80,pmn82,pmn83,pmn85,",
                 "       pmn86,pmn87",   
                 #"  FROM pmm_file,pmn_file, smy_file,OUTER pmc_file,",  #CHI-A40038 mark
                 #" OUTER azi_file,OUTER pma_file,OUTER gec_file,OUTER pnz_file", #FUN-930113 oah-->pnz #CHI-A40038 mark
                 "  FROM pmn_file, smy_file,pmm_file LEFT OUTER JOIN pmc_file ON pmc01 = pmm09 ",  #CHI-A40038 mod
                 " LEFT OUTER JOIN azi_file ON pmm22 = azi01 LEFT OUTER JOIN pma_file ON pmm20 = pma01 ",#CHI-A40038 mod
                 " LEFT OUTER JOIN gec_file ON gec01 = pmm21 LEFT OUTER JOIN pnz_file ON pmm41 = pnz01 ", #FUN-930113 oah-->pnz  #CHI-A40038 mod
                 " WHERE pmm01 = pmn01 ",
#                 "   AND pmm01 like smyslip +'%' ", 
                #"   AND substr(pmm01,1,",g_doc_len,")= smy_file.smyslip",   #NO.CHI-920072
                 "   AND pmm01[1,",g_doc_len,"]= smy_file.smyslip",   #NO.CHI-920072   #FUN-B40029
                 #"   AND pmc_file.pmc01 = pmm_file.pmm09 ",  #CHI-A40038 mark
                 #"   AND pmm_file.pmm22 = azi_file.azi01 ",  #CHI-A40038 mark
                 #"   AND pma_file.pma01 = pmm_file.pmm20 ",  #CHI-A40038 mark
                 #"   AND gec_file.gec01 = pmm_file.pmm21 ",  #CHI-A40038 mark
                 #"   AND pmm41 = pnz_file.pnz01 ", #FUN-930113 oah-->pnz  #CHI-A40038 mark
                 "   AND pmm18 !='X' ",
                 "   AND gec011='1'",  #進項
                 "   AND pmmacti='Y' ",
                 "   AND pmm02 !='BKR' ",        
#                "   AND pmm02 in ('0','1') ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE r900_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     DECLARE r900_cs1 CURSOR FOR r900_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
     LET g_rlang = g_rlang_2    
 
#       CALL cl_outnam('aicr041') RETURNING l_name
 
#    CALL cl_prt_pos_len()
 
#    START REPORT r900_rep TO l_name
     
      LET l_sql="SELECT zaa02,zaa08,zaa09,zaa14,zaa16 FROM zaa_file ",
                "WHERE zaa01 = '",g_prog ,"' AND zaa03 = ? ",
                "  AND zaa04 = '", g_zaa04_value,"' AND zaa10= '", g_zaa10_value , "'",
                "  AND zaa11 = '",g_zaa11_value CLIPPED,"' AND zaa17= '",g_zaa17_value CLIPPED ,"'" 
      PREPARE r900_zaa_pre FROM l_sql
      DECLARE r900_zaa_cur CURSOR FOR r900_zaa_pre
 
      LET l_sql = " SELECT zab05 from zab_file ",
           "WHERE zab01= ? AND zab04= ? AND zab03 = ?"
      PREPARE zab_prepare FROM l_sql
 
     LET g_pageno = 0
     FOREACH r900_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20=0 END IF
       IF cl_null(sr.pmn31) THEN LET sr.pmn31=0 END IF
       IF cl_null(sr.pmn31t) THEN LET sr.pmn31t=0 END IF
       IF cl_null(sr.pmn88)   THEN LET sr.pmn88=0   END IF
       IF cl_null(sr.pmn88t)   THEN LET sr.pmn88t=0   END IF
      IF g_pageno=0 AND (g_rlang <> sr.pmc911) THEN                                                                                 
         IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN                                                                              
             LET g_rlang = sr.pmc911                                                                                                
         END IF                                                                                                                     
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang                                                               
                                                                                                                                    
         OPEN r900_zaa_cur USING g_rlang                                                                                            
         FOREACH r900_zaa_cur INTO g_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16                                                              
           IF l_zaa09 = '1' THEN                                                                                                    
              IF l_zaa14 = "H" OR l_zaa14 = "I" THEN                                                                                
                 IF l_zaa16 = "Y" THEN                                                                                              
                    IF l_zaa14 = "H" THEN                                                                                           
                       LET g_memo_pagetrailer = 1                                                                                   
                    ELSE                                                                                                            
                       LET g_memo_pagetrailer = 0                                                                                   
                    END IF                                                                                                          
                    EXECUTE zab_prepare USING l_zaa08,g_rlang,'1' INTO l_zab05                                                      
                    EXECUTE zab_prepare USING l_zaa08,g_rlang,'2' INTO l_memo                                                       
                    IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN                                                               
                        LET l_zaa08 = l_zab05                                                                                       
                        LET g_memo = l_memo CLIPPED                                                                                 
                    END IF                                                                                                          
                 ELSE
                    LET g_memo_pagetrailer = 0                                                                                      
                    LET l_zaa08 = ""                                                                                                
                    LET g_memo =  ""                                                                                                
                 END IF                                                                                                             
              END IF                                                                                                                
              LET l_zaa08_trim = l_zaa08                                                                                            
              LET g_x[g_i] = l_zaa08_trim.trimRight()                                                                               
           ELSE                                                                                                                     
              LET g_zaa[g_i].zaa08 = l_zaa08                                                                                        
           END IF                                                                                                                   
        END FOREACH                                                                                                                 
      ELSE                                                                                                                          
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang                                                               
      END IF
 
         SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file                                                                  
                                                    WHERE pme01=sr.pmm10                                                            
         IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
 
      DECLARE pmo_cur2 CURSOR FOR                                                                                                   
         SELECT pmo06 FROM pmo_file                                                                                                 
          WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='0'                                                                     
                                                                                                               
 
#No.CHI-920072  --begin--
     FOREACH pmo_cur2 INTO l_pmo06                                                                                                 
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF                                                                              
#          IF NOT cl_null(l_pmo06) THEN PRINT COLUMN 4,l_pmo06 END IF                                                                
      END FOREACH               
#No.CHI-920072 --end--     
                                                                                                                                    
      #modify CHI-940010 by hellen --begin 090408
#     SELECT ima021,ima906,ima06,imaicd01 INTO l_ima021,l_ima906,l_ima06,l_imaicd01 FROM ima_file WHERE ima01=sr.pmn04              
      SELECT ima021,ima906,ima06,imaicd01 
        INTO l_ima021,l_ima906,l_ima06,l_imaicd01 
        FROM ima_file,imaicd_file      #CHI-940010 add imaicd_file by hellen
       WHERE ima01 = sr.pmn04              
         AND ima01 = imaicd00          #CHI-940010 add by hellen
      #modify CHI-940010 by hellen --end 090408
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                     
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                                                                             
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN                                                                           
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                                 
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED                                                                          
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN                                                                   
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED                                                     
                   END IF                                                                                                           
                END IF                                                                                                              
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN                                                                      
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                 
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                                                                         
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                                                                                                                        
      IF g_sma.sma116 MATCHES '[13]' THEN                                                                                           
            IF sr.pmn80 <> sr.pmn86 THEN                                                                                            
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF
 
      DECLARE pmo_cur3 CURSOR FOR                                                                                                   
       SELECT pmo06 FROM pmo_file                                                                                                   
        WHERE pmo01=sr.pmm01                                                                                                        
          AND pmo03='0' AND pmo04='1'                                                                                               
#No.CHI-920072  --begin--
      FOREACH pmo_cur3 INTO l_pmo06                                                                                                 
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF                                                                              
#          IF NOT cl_null(l_pmo06) THEN                                                                                              
#             PRINT COLUMN 1,l_pmo06[1,120] CLIPPED                                                                                  
#             if length(l_pmo06)>120 then                                                                                            
#                PRINT COLUMN 1,l_pmo06[121,length(l_pmo06)] CLIPPED                                                                 
#             end if                                                                                                                 
#          END IF                                                                                                                    
      END FOREACH      	
#No.CHI-920072 --end--     
 
          LET l_mask_layer=NULL                                                                                                     
          DECLARE ima_cur2 CURSOR FOR                                                                                               
          SELECT (ice05||ice06) ice,ice09 FROM ice_file WHERE ICE02=sr.pmn04                                                        
          ORDER BY ICE04                                                                                                            
          FOREACH ima_cur2 INTO l_ice05,l_ice09                                                                                     
            if NOT cl_null(l_ice09) then                                                                                            
               LET l_ima03 = NULL                                                                                                   
               FOR i = 1 TO l_ice09                                                                                                 
                   LET l_ima03=l_ima03,'X'                                                                                          
               END FOR                                                                                                              
               LET l_ice05=l_ice05,'-',l_ima03                                                                                      
            end if                                                                                                                  
            IF NOT cl_null(l_mask_layer) then                                                                                       
               LET l_mask_layer=l_mask_layer,',',l_ice05                                                                            
            ELSE                                                                                                                    
               LET l_mask_layer=l_mask_layer,l_ice05                                                                                
            END IF                                                                                                                  
          END FOREACH
 
#      OUTPUT TO REPORT r900_rep(sr.*)
    EXECUTE insert_prep USING                                                                                                       
                sr.pmm01,sr.smydesc,sr.pmm04,l_pme031,l_pme032,sr.pmm09,sr.pmc081,sr.pmc091,                                        
                l_pmd02,sr.pmc10,sr.pmc11,sr.pma02,sr.pmm22,sr.gec02,sr.pmn02,sr.pmn04,sr.pmn07,                                    
                sr.pmn33,sr.pmn31,sr.pmn20,sr.pmn88,sr.pmn88t,sr.pmn041,l_ima021,sr.azi05,                                          
                l_username,sr.pmn24,sr.pmn25,l_mask_layer
 
     END FOREACH
 
#    FINISH REPORT r900_rep
 
     LET g_rlang = g_rlang_2      
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#----------------------CR(3)------------------------------#                                                                         
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                         
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",                                                         
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED                                                              
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm12')                                                                                    
             RETURNING tm.wc                                                                                                        
     END IF                                                                                                                         
     LET g_str = tm.wc,";",g_zo.zo041,";",g_zo.zo042,";",                                                                           
                 g_zo.zo05,";",g_zo.zo09,";",                                                                                       
                 g_zo.zo06,";",g_memo                                                                                               
     CALL cl_prt_cs3('aicr041','aicr041',g_sql,g_str)                                                                               
#----------------------CR(3)------------------------------#
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time     #FUN-B90044
END FUNCTION
 
#REPORT r900_rep(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,
#         l_dash        LIKE type_file.chr1,
#         l_count       LIKE type_file.num5,
#         l_n           LIKE type_file.num5,
#         l_zaa08       LIKE zaa_file.zaa08,    
#         l_zaa09       LIKE zaa_file.zaa09,    
#         l_zaa14       LIKE zaa_file.zaa14,    
#         l_zaa16       LIKE zaa_file.zaa16,    
#         l_memo        LIKE zab_file.zab05,   
#         l_zaa08_trim  STRING,                 
#         l_sql  LIKE type_file.chr1000,		
#         sr   RECORD
#                    pmm01     LIKE pmm_file.pmm01,    #采購單號
#                    smydesc   LIKE smy_file.smydesc,  #單別說明
#                    pmm04     LIKE pmm_file.pmm04,    #采購日期
#                    pmc081    LIKE pmc_file.pmc081,   #供貨商全名
#                    pmc091    LIKE pmc_file.pmc081,   #供貨商地址
#                    pmc10     LIKE pmc_file.pmc10 ,   #供貨商電話
#                    pmc11     LIKE pmc_file.pmc11 ,   #供貨商傳真
#                    pma02     LIKE pma_file.pma02,    #付款條件
#                    pmm41     LIKE pmm_file.pmm41,    #價格條件
#                    oah02     LIKE oah_file.oah02,    #價格條件說明
#                    gec02     LIKE gec_file.gec02,    #稅別
#                    pmm09     LIKE pmm_file.pmm09,    #廠商代碼
#                    pmm10     LIKE pmm_file.pmm10,    #送貨地址
#                    pmm11     LIKE pmm_file.pmm11,    #賬單地址
#                    pmm22     LIKE pmm_file.pmm22,    #幣別
#                    pmn02     LIKE pmn_file.pmn02,    #項次
#                    pmn04     LIKE pmn_file.pmn04,    #料件編號
#                    pmn041    LIKE pmn_file.pmn041,   #品名規格
#                    pmn07     LIKE pmn_file.pmn07,    #單位
#                    pmn20     LIKE pmn_file.pmn20,    #數量
#                    pmn31     LIKE pmn_file.pmn31,    #未稅單價
#                    pmn88     LIKE pmn_file.pmn88,    #未稅金額
#                    pmn33     LIKE pmn_file.pmn33,    #交貨日
#                    pmn15     LIKE pmn_file.pmn15,    #提前交貨
#                    pmn14     LIKE pmn_file.pmn14,    #部份交貨
#                    pmn24     LIKE pmn_file.pmn24,    #請購單號
#                    pmn25     LIKE pmn_file.pmn25,    #請購項次
#                    pmn06     LIKE pmn_file.pmn06,    #廠商料號
#                    azi03     LIKE azi_file.azi03,
#                    azi04     LIKE azi_file.azi04,
#                    azi05     LIKE azi_file.azi05,
#                    pmc911    LIKE pmc_file.pmc911,
#                    pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
#                    pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
#                    pmn08     LIKE pmn_file.pmn08,               
#                    pmn09     LIKE pmn_file.pmn09,               
#                    pmn80     LIKE pmn_file.pmn80,               
#                    pmn82     LIKE pmn_file.pmn82,               
#                    pmn83     LIKE pmn_file.pmn83,               
#                    pmn85     LIKE pmn_file.pmn85,               
#                    pmn86     LIKE pmn_file.pmn86,    #計價單位 
#                    pmn87     LIKE pmn_file.pmn87     #計價數量  
#       END RECORD,
#       sr1          RECORD
#                    pmm04     LIKE pmm_file.pmm04,
#                    pmm01     LIKE pmm_file.pmm01,
#                    pmc03     LIKE pmc_file.pmc03,
#                    pmn20     LIKE pmn_file.pmn20,
#                    pmn07     LIKE pmn_file.pmn07,
#                    pmm22     LIKE pmm_file.pmm22,
#                    pmn31     LIKE pmn_file.pmn31,
#                    pmn88     LIKE pmn_file.pmn88,
#                    pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
#                    pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
#                    pmn08     LIKE pmn_file.pmn08,               
#                    pmn09     LIKE pmn_file.pmn09,               
#                    pmn80     LIKE pmn_file.pmn80,               
#                    pmn82     LIKE pmn_file.pmn82,               
#                    pmn83     LIKE pmn_file.pmn83,               
#                    pmn85     LIKE pmn_file.pmn85,               
#                    pmn86     LIKE pmn_file.pmn86,    #計價單位  
#                    pmn87     LIKE pmn_file.pmn87     #計價數量  
#                    END RECORD,
#       l_pmo06      LIKE pmo_file.pmo06,
#       l_pme031     LIKE pme_file.pme031,
#       l_pme032     LIKE pme_file.pme032,
#       l_ima021     LIKE ima_file.ima021,              
#       l_ima906     LIKE ima_file.ima906,              
#       l_flag       LIKE type_file.chr1,
#       l_tot        LIKE type_file.num5,
#       l_str        LIKE type_file.chr1000,			
#       l_str2       LIKE type_file.chr1000,
#       l_totamt     LIKE pmm_file.pmm40, 
#       l_totamt1    LIKE pmn_file.pmn88t, 
#       l_tax	     LIKE type_file.num5,
#       l_pmn85      STRING,
#       l_pmn82      STRING,
#       l_pmn20      STRING,
#       l_pmn24      STRING,
#       l_pmn06      STRING,
#       l_pmd02		LIKE pmd_file.pmd02
#    DEFINE l_zab05     LIKE zab_file.zab05   
#    DEFINE l_ima06	LIKE ima_file.ima06
#    DEFINE l_ice05 LIKE ice_file.ice05
#    DEFINE l_mask_layer LIKE type_file.chr1000
#    DEFINE l_imaicd01 LIKE ima_file.imaicd01
#    DEFINE l_username  LIKE gen_file.gen02
#    DEFINE l_ice09 LIKE ice_file.ice09
#    DEFINE l_ima03	LIKE ima_file.ima03
#    DEFINE i		LIKE type_file.num5
 
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN 2
#        BOTTOM MARGIN 5
#        PAGE LENGTH g_page_line
# ORDER BY sr.pmm01,sr.pmn02
# FORMAT
#  PAGE HEADER
#     IF g_pageno=0 AND (g_rlang <> sr.pmc911) THEN
#        IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
#            LET g_rlang = sr.pmc911
#        END IF
#        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#        OPEN r900_zaa_cur USING g_rlang
#        FOREACH r900_zaa_cur INTO g_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16
#          IF l_zaa09 = '1' THEN
#             IF l_zaa14 = "H" OR l_zaa14 = "I" THEN             
#                IF l_zaa16 = "Y" THEN
#                   IF l_zaa14 = "H" THEN
#                      LET g_memo_pagetrailer = 1
#                   ELSE
#                      LET g_memo_pagetrailer = 0
#                   END IF
#                   EXECUTE zab_prepare USING l_zaa08,g_rlang,'1' INTO l_zab05
#                   EXECUTE zab_prepare USING l_zaa08,g_rlang,'2' INTO l_memo  
#                   IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN
#                       LET l_zaa08 = l_zab05
#                       LET g_memo = l_memo CLIPPED
#                   END IF
#                ELSE
#                   LET g_memo_pagetrailer = 0
#                   LET l_zaa08 = ""
#                   LET g_memo =  ""
#                END IF
#             END IF
#             LET l_zaa08_trim = l_zaa08
#             LET g_x[g_i] = l_zaa08_trim.trimRight()
#          ELSE
#             LET g_zaa[g_i].zaa08 = l_zaa08
#          END IF
#       END FOREACH
#     ELSE
#        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED     ))/2)+1,g_company CLIPPED      
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo041))/2)+1,g_zo.zo041 CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo042))/2)+1,g_zo.zo042 CLIPPED
#     LET l_str=g_x[28] CLIPPED,g_zo.zo05,'  ',g_x[29] CLIPPED,g_zo.zo09,'   ',g_x[60],g_zo.zo06	
#     PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str CLIPPED
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#        SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
#                                                   WHERE pme01=sr.pmm10
#        IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
#        PRINT g_x[11] CLIPPED,sr.pmm01,COLUMN 30,sr.smydesc CLIPPED,COLUMN 75,
#              g_x[12] CLIPPED,sr.pmm04 CLIPPED						
#        PRINT g_x[16] CLIPPED,l_pme031 CLIPPED ,l_pme032 CLIPPED #MOD-640173
#        SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
#                                                   WHERE pme01=sr.pmm11
#        IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF	 	 							
#     PRINT COLUMN 1,g_x[13] CLIPPED,sr.pmm09 CLIPPED				
#     PRINT COLUMN 10,sr.pmc081 CLIPPED,COLUMN 45,sr.pmc091 CLIPPED
#     SELECT pmd02 INTO l_pmd02 FROM pmd_file WHERE pmd05='Y' and pmd01=sr.pmm09
#     PRINT COLUMN 1,'TO:',l_pmd02 CLIPPED,COLUMN 22,g_x[28] CLIPPED,sr.pmc10,COLUMN 45,g_x[29] CLIPPED,sr.pmc11			     
#     PRINT COLUMN 1,g_x[14] CLIPPED,sr.pma02,COLUMN 22,g_x[19] CLIPPED,sr.pmm22,
#          COLUMN 45,g_x[18] CLIPPED,sr.gec02 #MOD-504194 48->52			 
#     PRINT g_dash[1,g_len]
 
#     CALL cl_prt_pos_dyn()                        
#     PRINTX name=H1 g_x[38],g_x[39],g_x[48],g_x[51],g_x[49],g_x[54],g_x[50]
#     PRINTX name=H2 g_x[41],g_x[42],g_x[45],g_x[52]
#     PRINT g_dash1
 
#BEFORE GROUP OF sr.pmm01
#     SKIP TO TOP OF PAGE
#     LET l_flag = 'N'
 
#ON EVERY ROW
#     #-->單身備注(前)
#
#AFTER GROUP OF sr.pmm01
#     LET l_totamt=GROUP SUM(sr.pmn88)  
#     LET l_totamt1=GROUP SUM(sr.pmn88t)  
#     LET l_tax=l_totamt1-l_totamt						
#     PRINT g_dash[1,g_len]
#     PRINT 'Amount:',cl_numfor(l_totamt,56,sr.azi05),COLUMN 30,'Tax: ',l_tax,COLUMN 50,'Total Amount:',sr.pmm22,COLUMN 55,cl_numfor(l_totamt1,56,sr.azi05)	#2006/11/09-Steven_Yeh-Add
#     SKIP 5 LINE
#     PRINT '備注  :'
#     #-->單頭備注(后)
#     DECLARE pmo_cur3 CURSOR FOR
#      SELECT pmo06 FROM pmo_file
#       WHERE pmo01=sr.pmm01 
#         AND pmo03='0' AND pmo04='1'
#     FOREACH pmo_cur3 INTO l_pmo06
#         IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
#         IF NOT cl_null(l_pmo06) THEN	     
#            PRINT COLUMN 1,l_pmo06[1,120] CLIPPED 
#            if length(l_pmo06)>120 then
#               PRINT COLUMN 1,l_pmo06[121,length(l_pmo06)] CLIPPED
#            end if
#         END IF 
#     END FOREACH
#     PRINT g_dash2
 
#IF l_tot = 58 AND LINENO = 57 THEN LET l_flag = 'Y' END IF 
 
#         LET l_mask_layer=NULL
# 	  DECLARE ima_cur2 CURSOR FOR	
#         SELECT (ice05||ice06) ice,ice09 FROM ice_file WHERE ICE02=sr.pmn04 
#         ORDER BY ICE04	  
#         FOREACH ima_cur2 INTO l_ice05,l_ice09
#           if NOT cl_null(l_ice09) then
#              LET l_ima03 = NULL
#              FOR i = 1 TO l_ice09
#       	   LET l_ima03=l_ima03,'X'
#              END FOR		
#              LET l_ice05=l_ice05,'-',l_ima03
#           end if
#           IF NOT cl_null(l_mask_layer) then	        
#              LET l_mask_layer=l_mask_layer,',',l_ice05
#           ELSE
#              LET l_mask_layer=l_mask_layer,l_ice05
#           END IF
#         END FOREACH
#         PRINT COLUMN 1,g_x[67] CLIPPED	
#         PRINT COLUMN 1,l_mask_layer[1,120] CLIPPED    
#            if length(l_mask_layer)>120 then		
#               PRINT COLUMN 1,l_mask_layer[121,length(l_mask_layer)] CLIPPED
#            end if
#     LET l_flag='Y'
#     LET g_pageno=0
#       										
 
#PAGE TRAILER
#   
#        PRINT COLUMN 1,g_x[61]	CLIPPED						
#        PRINT COLUMN 1,g_x[62] CLIPPED
#        PRINT COLUMN 1,g_x[63] CLIPPED
#        PRINT COLUMN 1,g_x[64] CLIPPED
#        PRINT COLUMN 1,g_x[65] CLIPPED
#        PRINT COLUMN 1,g_x[66] CLIPPED
#    PRINT g_dash2
#    SELECT gen02 INTO l_username FROM GEN_FILE WHERE GEN01=g_user
#    IF l_flag = 'N' THEN
#       IF g_memo_pagetrailer THEN
#           PRINT COLUMN 5,'部門主管:	陳 富 美  	   經 辦 人:  ',l_username,'	    廠 商 簽 回:__________'
#           PRINT g_memo
#       ELSE
#           PRINT          
#           PRINT
#       END IF
#    ELSE
#           PRINT COLUMN 5,'部門主管:	陳 富 美	   經 辦 人:   ',l_username,'	    廠 商 簽 回:__________'
#           PRINT g_memo
#    END IF
#END REPORT
 
# Modify FUN-7B0027
# Modify FUN-830068
