# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr612.4gl
# Descriptions...: 出貨通知清單
# Date & Author..: 01-04-06 BY ANN CHEN
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 帳款客戶,送貨客戶,人員編號,部門編號開窗
# Modify.........: FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-570048 05/07/14 By Nicola 移除tm.a欄位
# Modify.........: No.FUN-580004 05/08/08 By wujie 雙單位報表結構修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0128 05/11/14 By echo 將列印「單身編號+項次」拆開為二個欄位
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-830153 08/07/01 By baofei 報表打印改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40132 10/04/22 By Smapmin 改由訂單單號+項次來判斷出通是否已產生至出貨
# Modify.........: No:TQC-B30064 11/03/09 By zhangll l_sql -> STRIG
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90055 11/09/07 By lilingyu通知單號欄位修改為可開窗查詢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     STRING,                # Where condition
              a      LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)              # 列印單價
              b      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
              more   LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
         l_outbill   LIKE oga_file.oga01		 # 出貨單號,傳參數用
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-830153---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       l_table1       STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
#No.FUN-830153---End 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-830153---Begin                                                                                                              
   LET g_sql = "oga01.oga_file.oga01,",                                                                                             
               "oga02.oga_file.oga02,",                                                                                             
               "oga03.oga_file.oga03,",                                                                                             
               "oga04.oga_file.oga04,",                                                                                             
               "oga011.oga_file.oga011,",                                                                                           
               "oga032.oga_file.oga032,",                                                                                           
               "oga14.oga_file.oga14,",                                                                                             
               "oga15.oga_file.oga15,",                                                                                             
               "ogb03.ogb_file.ogb03,",                                                                                             
               "ogb04.ogb_file.ogb04,",                                                                                             
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ogb12.ogb_file.ogb12,",                                                                                             
               "ogb31.ogb_file.ogb31,",                                                                                             
               "ogb32.ogb_file.ogb32,",                                                                                             
               "l_occ02.occ_file.occ02,",                                                                                           
               "l_gen02.gen_file.gen02,",                                                                                           
               "l_gem02.gem_file.gem02,",                                                                                           
               "l_ima021.ima_file.ima021,",                                                                                         
               "l_str.type_file.chr1000,",                                                                                          
               "l_str2.type_file.chr1000"      
   LET l_table = cl_prt_temptable('axmr612',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "ogc01.ogc_file.ogc01,",                                                                                             
               "ogc03.ogc_file.ogc03,",                                                                                             
               "ogc09.ogc_file.ogc09,",                                                                                             
               "ogc091.ogc_file.ogc091,",                                                                                           
               "ogc092.ogc_file.ogc092,",                                                                                           
               "ogc16.ogc_file.ogc16"                                                                                               
   LET l_table1 = cl_prt_temptable('axmr6121',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.FUN-830153---End    
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.b ='Y'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
 #--------------No.TQC-610089 modify
  #IF cl_null(l_outbill)
   IF cl_null(tm.wc)
      THEN CALL axmr612_tm(0,0)             # Input print condition
   ELSE  
     #LET tm.wc="oga01='",tm.wc CLIPPED,"'"
      CALL axmr612()                   # Read data and create out-file
   END IF
 #--------------No.TQC-610089 end
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr612_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 15
 
   OPEN WINDOW axmr612_w AT p_row,p_col WITH FORM "axm/42f/axmr612"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET tm.b    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
             CASE
#TQC-B90055 --begin--
             WHEN INFIELD(oga01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_oga01_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga01
                  NEXT FIELD oga01
#TQC-B90055 --end--    
             WHEN INFIELD(oga03) #帳款客戶    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga03
                  NEXT FIELD oga03
             WHEN INFIELD(oga04) #送貨客戶    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga04
                  NEXT FIELD oga04
             WHEN INFIELD(oga14) #人員    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga14
                  NEXT FIELD oga14
             WHEN INFIELD(oga15) #部門    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga15
                  NEXT FIELD oga15
             END CASE
     ON ACTION locale
        #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_action_choice = "locale"
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr612_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
    INPUT BY NAME tm.b,tm.more WITHOUT DEFAULTS  #No.MOD-570048
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr612_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr612'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr612','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr612',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr612_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr612()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr612_w
END FUNCTION
 
FUNCTION axmr612()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,  #Mod No:TQC-B30064
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_ogc   RECORD                          #No.FUN-830153                                                                    
                 ogc09     LIKE ogc_file.ogc09,   #No.FUN-830153                                                                    
                 ogc091    LIKE ogc_file.ogc091,  #No.FUN-830153                                                                    
                 ogc16     LIKE ogc_file.ogc16,   #No.FUN-830153                                                                    
                 ogc092    LIKE ogc_file.ogc092   #No.FUN-830153                                                                    
                 END RECORD,                      #No.FUN-830153                                                                    
         l_ima021  LIKE ima_file.ima021,          #No.FUN-830153                                                                    
         l_occ02   LIKE occ_file.occ02,           #No.FUN-830153                                                                    
         l_gen02   LIKE gen_file.gen02,           #No.FUN-830153                                                                    
         l_gem02   LIKE gem_file.gem02,           #No.FUN-830153                                                                    
         l_str     LIKE type_file.chr1000,        #No.FUN-830153                                                                    
         l_str2    LIKE type_file.chr1000,        #No.FUN-830153   
          sr        RECORD
                    oga01     LIKE oga_file.oga01,
                    oga02     LIKE oga_file.oga02,
                    oga011    LIKE oga_file.oga011,
                    oga03     LIKE oga_file.oga03,
                    oga032    LIKE oga_file.oga032,
                    oga04     LIKE oga_file.oga04,
                    oga044    LIKE oga_file.oga044,
                    oga14     LIKE oga_file.oga14,
                    oga15     LIKE oga_file.oga15,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb04     LIKE ogb_file.ogb04,
                    ogb05     LIKE ogb_file.ogb05,
					ogb06	  LIKE ogb_file.ogb06,
                    ogb09     LIKE ogb_file.ogb09,
                    ogb091    LIKE ogb_file.ogb091,
                    ogb092    LIKE ogb_file.ogb092,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb16     LIKE ogb_file.ogb16,
                    ogb17     LIKE ogb_file.ogb17,
                    ogb31     LIKE ogb_file.ogb31,
                    ogb32     LIKE ogb_file.ogb32,
                    ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915      #No.FUN-580004
                    END RECORD
  DEFINE  l_ogb915    STRING                            #No.FUN-830153                                                              
  DEFINE  l_ogb912    STRING                            #No.FUN-830153                                                              
  DEFINE  l_ima906    LIKE ima_file.ima906              #No.FUN-830153                                                              
  DEFINE  l_cnt       LIKE type_file.num5   #MOD-A40132
#No.FUN-830153---Begin  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?,?) "                                                                                              
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                                                                                                     
#No.FUN-830153---End      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-830153   
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT oga01,oga02,oga011,oga03,oga032,oga04,oga044,oga14,",
               "       oga15,",
               "       ogb03,ogb04,ogb05,ogb06,ogb09,ogb091,ogb092,",
               "       ogb12,ogb16,ogb17,ogb31,ogb32,ogb910,ogb912,ogb913,ogb915",        #No.FUN-580004
               "  FROM oga_file,ogb_file ",
               " WHERE oga01=ogb01 ",
               "   AND (oga09='1' OR oga09='5')  ",
               "   AND ogaconf != 'X' ",
      	       "   AND ",tm.wc
	 LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
     PREPARE axmr612_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr612_curs1 CURSOR FOR axmr612_prepare1
 
#     CALL cl_outnam('axmr612') RETURNING l_name   #No.FUN-830153   
 
#FUN-580004--begin
     SELECT sma115 INTO g_sma115 FROM sma_file
     IF g_sma115 = "Y"  THEN
#            LET g_zaa[53].zaa06 = "N"   #No.FUN-830153                                                                             
             LET l_name = 'axmr612_1'    #No.FUN-830153                                                                             
     ELSE                                                                                                                           
#            LET g_zaa[53].zaa06 = "Y"   #No.FUN-830153                                                                             
             LET l_name = 'axmr612'      #No.FUN-830153   
     END IF
      CALL cl_prt_pos_len()
#No.FUN-580004--end
#     START REPORT axmr612_rep TO l_name   #No.FUN-830153   
 
     LET g_pageno = 0
     FOREACH axmr612_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #-----MOD-A40132---------
       #IF tm.b='Y' AND NOT cl_null(sr.oga011) THEN CONTINUE FOREACH END IF
       IF tm.b = 'Y' THEN
          LET l_cnt = 0 
          SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
            WHERE ogb31 = sr.ogb31
              AND ogb32 = sr.ogb32
              AND ogb04 = sr.ogb04
              AND oga01 = ogb01 
              AND ogaconf != 'X'
              AND oga09 IN ('2','4','6')
              AND oga011 = sr.oga01 
          IF l_cnt > 0 THEN
             CONTINUE FOREACH
          END IF
       END IF
       #-----END MOD-A40132-----
#No.FUN-830153---Begin                                                                                                              
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04                                                                  
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14                                                                  
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15                                                                  
      IF SQLCA.SQLCODE THEN                                                                                                         
         LET l_gen02='' LET l_gem02=''                                                                                              
      END IF                                                                                                                        
          IF sr.ogb17 = 'Y' THEN     #No.MOD-570048                                                                                 
             LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",                                                         
                       " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"                                                    
         ELSE                                                                                                                       
             LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file ",                                                          
                       " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"                                                    
         END IF                                                                                                                     
         PREPARE r600_p2 FROM l_sql                                                                                                 
         DECLARE r600_c2 CURSOR FOR r600_p2                                                                                         
         LET i = 1                                                                                                                  
         FOREACH r600_c2 INTO l_ogc.*                                                                                               
            IF STATUS THEN EXIT FOREACH END IF                                                                                      
         EXECUTE insert_prep1 USING sr.oga01,sr.ogb03,l_ogc.ogc09,l_ogc.ogc091,                                                     
                                    l_ogc.ogc092,l_ogc.ogc16                                                                        
         END FOREACH                                       
         IF sr.ogb04[1,4] !='MISC' THEN                                                                                             
            SELECT ima021 INTO l_ima021 FROM ima_file                                                                               
             WHERE ima01 = sr.ogb04                                                                                                 
         ELSE                                                                                                                       
            LET l_ima021 = ''                                                                                                       
         END IF                                                                                                                     
         LET l_str = sr.ogb31 CLIPPED,'-',sr.ogb32 USING '&&&&'                                                                     
                                                                                                                                    
 #FUN-580004--begin                                                                                                                 
                                                                                                                                    
      SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
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
 #FUN-580004--end                                                                                                                   
     EXECUTE insert_prep USING sr.oga01,sr.oga02,sr.oga03,sr.oga04,sr.oga011,sr.oga032,                                             
                               sr.oga14,sr.oga15,sr.ogb03,sr.ogb04,sr.ogb05,sr.ogb06,                                               
                               sr.ogb12,sr.ogb31,sr.ogb32,l_occ02,l_gen02,l_gem02,l_ima021,                                         
                               l_str,l_str2                                                                                         
                                                                                                                                    
#       OUTPUT TO REPORT axmr612_rep(sr.*)                                                                                          
#No.FUN-830153---End                      
     END FOREACH
#No.FUN-830153---Begin                                                                                                              
#     FINISH REPORT axmr612_rep                                                                                                     
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15')                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.a                                                                                                     
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED                                                              
   CALL cl_prt_cs3('axmr612',l_name,l_sql,g_str)                                                                                    
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                   
#No.FUN-830153---End   
END FUNCTION
#No.FUN-830153---Begin
#REPORT axmr612_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#         sr        RECORD
#                   oga01     LIKE oga_file.oga01,
#                   oga02     LIKE oga_file.oga02,
#                   oga011    LIKE oga_file.oga011,
#                   oga03     LIKE oga_file.oga03,
#                   oga032    LIKE oga_file.oga032,
#                   oga04     LIKE oga_file.oga04,
#                   oga044    LIKE oga_file.oga044,
#                   oga14     LIKE oga_file.oga14,
#                   oga15     LIKE oga_file.oga15,
#                   ogb03     LIKE ogb_file.ogb03,
#                   ogb04     LIKE ogb_file.ogb04,
#                   ogb05     LIKE ogb_file.ogb05,
#                   ogb06     LIKE ogb_file.ogb06,
#                   ogb09     LIKE ogb_file.ogb09,
#                   ogb091    LIKE ogb_file.ogb091,
#                   ogb092    LIKE ogb_file.ogb092,
#                   ogb12     LIKE ogb_file.ogb12,
#                   ogb16     LIKE ogb_file.ogb16,
#                   ogb17     LIKE ogb_file.ogb17,
#                   ogb31     LIKE ogb_file.ogb31,
#                   ogb32     LIKE ogb_file.ogb32,
#                   ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
#                   ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
#                   ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
#                   ogb915    LIKE ogb_file.ogb915      #No.FUN-580004
#                END RECORD,
#        l_buf   DYNAMIC ARRAY OF RECORD
#                ogc09     LIKE ogc_file.ogc09,
#                ogc091    LIKE ogc_file.ogc091,
#                ogc092    LIKE ogc_file.ogc092
#                END RECORD,
#        l_buf2  DYNAMIC ARRAY OF LIKE ogc_file.ogc16,
#        l_ogc   RECORD
#                ogc09     LIKE ogc_file.ogc09,
#                ogc091    LIKE ogc_file.ogc091,
#                ogc16     LIKE ogc_file.ogc16,
#                ogc092    LIKE ogc_file.ogc092
#                END RECORD,
#        l_flag    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#        l_ima021  LIKE ima_file.ima021,
#        l_occ02   LIKE occ_file.occ02,
#        l_gen02   LIKE gen_file.gen02,
#        l_gem02   LIKE gem_file.gem02,
#        l_ogb12   LIKE ogb_file.ogb12,
#        l_sql 	   LIKE type_file.chr1000,     #No.FUN-680137 VARCHAR(1000)
#        l_str 	   LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(60)
#        i,j       LIKE type_file.num5,        #No.FUN-680137 SMALLINT
#        l_rowno   LIKE type_file.num5        # No.FUN-680137 SMALLINT
##No.FUN-580004--begin
#  DEFINE  l_ogb915    STRING
#  DEFINE  l_ogb912    STRING
#  DEFINE  l_str2      STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
##No.FUN-580004--end
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.oga01,sr.ogb03
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT ''
 
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           #g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[54],g_x[44],g_x[45],g_x[46],  #TQC-5B0128
#            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]          #No.FUN-580004   #No.MOD-570048
 
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.oga01
#     LET l_rowno =1
#     SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04
#     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#     IF SQLCA.SQLCODE THEN
#        LET l_gen02='' LET l_gem02=''
#     END IF
#     PRINT COLUMN g_c[31],sr.oga01,
#           COLUMN g_c[32],sr.oga02,
#           COLUMN g_c[33],sr.oga011,
#           COLUMN g_c[34],sr.oga03,
#           COLUMN g_c[35],sr.oga032,
#           COLUMN g_c[36],sr.oga04,
#           COLUMN g_c[37],l_occ02,
#           COLUMN g_c[38],sr.oga14,
#           COLUMN g_c[39],l_gen02,
#           COLUMN g_c[40],sr.oga15,
#           COLUMN g_c[41],l_gem02 CLIPPED;
 
#  ON EVERY ROW
#        CALL l_buf.clear()
#        CALL l_buf2.clear()
#         IF sr.ogb17 = 'Y' THEN     #No.MOD-570048
#            LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
#                      " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
#        ELSE
#            LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file ",
#                      " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
#        END IF
#        PREPARE r600_p2 FROM l_sql
#        DECLARE r600_c2 CURSOR FOR r600_p2
#        LET i = 1
#        FOREACH r600_c2 INTO l_ogc.*
#           IF STATUS THEN EXIT FOREACH END IF
#           LET l_buf[i].ogc09 =l_ogc.ogc09  CLIPPED
#           LET l_buf[i].ogc091=l_ogc.ogc091  CLIPPED
#           LET l_buf[i].ogc092=l_ogc.ogc092 CLIPPED
#           LET l_buf2[i]=l_ogc.ogc16
#           LET i=i+1
#        END FOREACH
#        IF sr.ogb04[1,4] !='MISC' THEN
#           SELECT ima021 INTO l_ima021 FROM ima_file
#            WHERE ima01 = sr.ogb04
#        ELSE
#           LET l_ima021 = ''
#        END IF
#        LET l_str = sr.ogb31 CLIPPED,'-',sr.ogb32 USING '&&&&'
 
##FUN-580004--begin
 
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr.ogb04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#               LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                   CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                   LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                     CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                     LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                   CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                   LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
##FUN-580004--end
#        PRINT COLUMN g_c[42],sr.ogb03 USING '####',
#             #TQC-5B0128
#             #COLUMN g_c[43],l_str CLIPPED,
#              COLUMN g_c[43],sr.ogb31 CLIPPED,
#              COLUMN g_c[54],sr.ogb32 USING '####',
#             #END TQC-5B0128
#              COLUMN g_c[53],l_str2 CLIPPED,           #No.FUN-580004
#              #COLUMN g_c[44],sr.ogb04[1,20],           #No.FUN-580004
#              COLUMN g_c[44],sr.ogb04 CLIPPED,           #No.FUN-580004
#              COLUMN g_c[45],sr.ogb06,
#              COLUMN g_c[46],l_ima021,
#              COLUMN g_c[47],sr.ogb05 CLIPPED,
#              COLUMN g_c[48],sr.ogb12 USING '############.##';
#        IF tm.a = 'N' THEN
#           PRINT ''
#        ELSE
#           FOR j = 1 TO i
#               PRINT COLUMN g_c[49],l_buf[j].ogc09 CLIPPED,
#                     COLUMN g_c[50],l_buf[j].ogc091 CLIPPED,
#                     COLUMN g_c[51],l_buf[j].ogc092 CLIPPED,
#                     COLUMN g_c[52],l_buf2[j] USING '############.##'
#           END FOR
#        END IF
#
#  AFTER GROUP OF sr.oga01
#     LET l_ogb12= GROUP SUM(sr.ogb12)
#     PRINT COLUMN g_c[46],g_x[11] CLIPPED,
#           COLUMN g_c[48],l_ogb12 USING '############.##'
#     PRINT
 
#  ON LAST ROW
#     #是否列印選擇條件
#     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#             RETURNING tm.wc
#        PRINT g_dash
#        #TQC-630166
#        #     IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #     IF tm.wc[071,140] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #     IF tm.wc[141,210] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #     IF tm.wc[211,280] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
 
#     END IF
#     PRINT g_dash
### FUN-550127
#     #PRINT COLUMN g_c[31],g_x[04] CLIPPED,
#     #      COLUMN g_c[34],g_x[05] CLIPPED,
#     #      COLUMN g_c[37],g_x[09] CLIPPED,
#     #      COLUMN g_c[40],g_x[10] CLIPPED,
#     PRINT COLUMN (g_len-9),g_x[7] CLIPPED   #No.FUN-580004
#     LET l_last_sw = 'y'
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash
#       #PRINT COLUMN g_c[31],g_x[04] CLIPPED,
#       #      COLUMN g_c[34],g_x[05] CLIPPED,
#       #      COLUMN g_c[37],g_x[09] CLIPPED,
#       #      COLUMN g_c[40],g_x[10] CLIPPED,
#        PRINT COLUMN (g_len-9),g_x[6] CLIPPED   #No.FUN-580004
#     ELSE
#        SKIP 2 LINE
#     END IF
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
## END FUN-550127
 
#END REPORT
#No.FUN-830153---End
