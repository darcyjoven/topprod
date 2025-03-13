# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr730.4gl
# Descriptions...: 出貨資料列印
# Date & Author..: 97/09/24 by Connie
# Modify.........: 99/09/14 By Carol:add 單位換算
#                : 01-04-06 BY ANN CHEN No.B314 應不含出貨通知單, 但包含一般出貨
#                                               ,無訂單出貨,三角貿易出貨
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 產品編號,帳款客戶開窗
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表結構修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0096 06/11/20 By Ray 報表寬度不符
# Modify.........: NO.MOD-6C0179 07/01/26 By claire 選擇明細列印時,表頭要改明細表
# Modify.........: NO.MOD-710028 07/01/26 By claire l_k定義不可為整數,否則造成出貨數量為整數,應呈現小數
# Modify.........: NO.MOD-7B0098 07/11/09 By claire 長度定義問題
# Modify.........: No.FUN-850018 08/05/06 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.TQC-B50075 11/05/16 By lixia 開窗全選報錯修改
# Modify.........: No:MOD-BA0055 12/02/17 By bart 銷退資料都沒有呈現
 
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
              #wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)       # Where condition
              wc      STRING,                     #TQC-B50075
              bdate   LIKE type_file.dat,         # No.FUN-680137 DATE
              edate   LIKE type_file.dat,         # No.FUN-680137 DATE
              # Prog. Version..: '5.30.06-13.03.12(01)         # 報表性質   #MOD-BA0055
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)         # Input more condition(Y/N)
              END RECORD,
          l_outbill   LIKE oga_file.oga01		 # 出貨單號,傳參數用
DEFINE    g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    g_head1     STRING
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-850018 --Begin
DEFINE g_str            LIKE type_file.chr1000
DEFINE #g_sql            LIKE type_file.chr1000
       g_sql            STRING       #NO.FUN-910082
DEFINE l_table          STRING       #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#No.FUN-850018 --End
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
#No.FUN-850018 --Begin
   LET g_sql="ogb04.ogb_file.ogb04,",
             "ogb06.ogb_file.ogb06,",
             "oga02.oga_file.oga02,",
             "ogb12.ogb_file.ogb12,",
             "oha02.oha_file.oha02,",
             "ohb12.ohb_file.ohb12,",
             "ogb05.ogb_file.ogb05,",
             "ima25.ima_file.ima25,",
             "ima021.ima_file.ima021,",
             "ogb910.ogb_file.ogb910,",
             "ogb912.ogb_file.ogb912,",
             "ogb913.ogb_file.ogb913,",
             "ogb915.ogb_file.ogb915,",
             "ima906.ima_file.ima906,",
             "l_ogb15_fac.ogb_file.ogb15_fac,",
             "l_ohb15_fac.ohb_file.ohb15_fac"
   LET l_table = cl_prt_temptable('axmr730',g_sql) CLIPPED
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-850018 --End
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.a ='1'
  #LET l_outbill = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #LET tm.a    = ARG_VAL(8)   #MOD-BA0055
   LET tm.bdate= ARG_VAL(9)
   LET tm.edate= ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
 #--------------No.TQC-610089 modify
  #IF cl_null(l_outbill)
   IF cl_null(tm.wc)
      THEN CALL axmr730_tm(0,0)             # Input print condition
   ELSE 
     #LET tm.wc="oga01='",tm.wc CLIPPED,"'"
      CALL axmr730()                   # Read data and create out-file
   END IF
 #--------------No.TQC-610089 end
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr730_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW axmr730_w AT p_row,p_col WITH FORM "axm/42f/axmr730"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #LET tm.a ='1'   #MOD-BA0055
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   LET tm.bdate = TODAY
   LET tm.edate = TODAY
   CONSTRUCT BY NAME tm.wc ON ogb04,oga03,oga01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    ON ACTION CONTROLP
               IF INFIELD(ogb04) THEN #產品編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogb04
                  NEXT FIELD ogb04
               END IF
               IF INFIELD(oga03) THEN #客戶編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga03
                  NEXT FIELD oga03
               END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
#UI
   #INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more WITHOUT DEFAULTS   #MOD-BA0055
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS   #MOD-BA0055
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      #-----MOD-BA0055---------
      #AFTER FIELD a
      #   IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
      #      NEXT FIELD a
      #   END IF
      #-----END MOD-BA0055-----
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr730'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr730','9031',1)
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
                         #" '",tm.a CLIPPED,"'" ,   #MOD-BA0055
                         " '",tm.bdate CLIPPED,"'" ,         #No.TQC-610089 add
                         " '",tm.edate CLIPPED,"'" ,         #No.TQC-610089 add
                        #" '",tm.more CLIPPED,"'"  ,         #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr730',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr730_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr730()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr730_w
END FUNCTION
 
FUNCTION axmr730()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     STRING,  #MOD-7B0098 LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-850018
          l_sql2    LIKE type_file.chr1000,       #No.FUN-850018
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
#No.FUN-850018 --Begin
          l_cnt      LIKE type_file.chr1,                                                             
          l_ima25    LIKE gsb_file.gsb05,           
          l_ima906   LIKE ima_file.ima906,                                             
          l_ohb05    LIKE gsb_file.gsb05,                                                 
          l_ogb15_fac  LIKE ogb_file.ogb15_fac,                                                                                      
          l_ohb15_fac  LIKE ohb_file.ohb15_fac,
          l_ogb04    LIKE ogb_file.ogb04,
          l_oga02    LIKE oga_file.oga02,
          l_ogb04_t  LIKE ogb_file.ogb04,                                                                                           
          l_oga02_t  LIKE oga_file.oga02,
          l_sum        LIKE type_file.num5,
          l_flag     LIKE type_file.chr1,   #MOD-BA0055
#No.FUN-850018 --End
          sr        RECORD
                    ogb04     LIKE ogb_file.ogb04,
                    ogb06     LIKE ogb_file.ogb06,
                    oga02     LIKE oga_file.oga02,
                    ogb12     LIKE ogb_file.ogb12,
                    oha02     LIKE oha_file.oha02,
                    ohb12     LIKE ohb_file.ohb12,
                    ogb05     LIKE ogb_file.ogb05,
                    ima25     LIKE ima_file.ima25,
                    ima021    LIKE ima_file.ima021,
                    ogb910    LIKE ogb_file.ogb910,    #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,    #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,    #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915     #No.FUN-580004
          END RECORD
     CALL cl_del_data(l_table)                         #No.FUN-850018
     LET l_oga02_t = " "
     LET l_ogb04_t = " "
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr730'#No.FUN-850018
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR  
 
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
 
     LET l_sql="SELECT ogb04,ogb06,oga02,SUM(ogb12),'',0,ogb05,ima25,ima021,ogb910,ogb912,ogb913,ogb915",     #No.FUN-580004
               "  FROM oga_file,ogb_file,OUTER ima_file ",
               " WHERE oga01 = ogb01 ",
               "   AND oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
##No.B314 010406
               #"   AND oga09 = '2' ",
               "   AND oga09 !='1' AND oga09 !='5' ",
               "   AND oga09 !='7' AND oga09 !='9' ",  #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
               "   AND ogaconf !='X' ", #No.314
##No.B314 END
               "   AND ogb_file.ogb04 = ima_file.ima01 ",
               "   AND ",tm.wc ,
               " GROUP BY ogb04,ogb06,oga02,ogb05,ima25,ima021,ogb910,ogb912,ogb913,ogb915 ",
             # " GROUP BY ogb04,ogb06,oga02,ogb05,ima25,ima021",        #No.FUN-580004
               " ORDER BY ogb04,oga02 "
     PREPARE axmr730_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr730_curs1 CURSOR FOR axmr730_prepare1
#No.FUN-850018 --Begin 
#    CALL cl_outnam('axmr730') RETURNING l_name
#FUN-580004--begin
     SELECT sma115 INTO g_sma115 FROM sma_file
#    IF g_sma115 = "Y"  THEN
#           LET g_zaa[40].zaa06 = "N"
#    ELSE
#           LET g_zaa[40].zaa06 = "Y"
#    END IF
#     CALL cl_prt_pos_len()
#No.FUN-580004--end
 
#    START REPORT axmr730_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-850018 --End
 
     FOREACH axmr730_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-850018 --Begin 
       CALL s_umfchk(sr.ogb04,sr.ogb05,sr.ima25)                                                                                      
             RETURNING l_cnt,l_ogb15_fac                                                                                            
       IF l_ogb15_fac IS NULL  THEN LET l_ogb15_fac = 0 END IF   
       #-----MOD-BA0055---------
       DECLARE a_curs CURSOR FOR
        SELECT oha02,ohb05,SUM(ohb12)
          FROM oga_file,oha_file,ohb_file
         WHERE ohb04 = sr.ogb04
           AND ohb31 = oga01
           AND oha01 = ohb01
           AND oha02 BETWEEN tm.bdate AND tm.edate 
           AND oga09 !='1' AND oga09 !='5'  
           AND oga09 !='7' AND oga09 !='9'  
           AND oga65='N'    
           AND ohaconf !='X'
       GROUP BY oha02,ohb05
       ORDER BY oha02,ohb05
       LET l_flag = 0 
       IF cl_null(l_ogb04_t) OR cl_null(l_oga02_t) OR 
          NOT (l_ogb04_t = sr.ogb04 AND l_oga02_t <> sr.oga02) THEN
          FOREACH a_curs INTO sr.oha02,l_ohb05,sr.ohb12
             IF l_flag = 1 THEN
                LET sr.ogb12 = 0 
             END IF
             SELECT ima25 INTO l_ima25 FROM ima_file
              WHERE ima01 = sr.ogb04
          #-----END MOD-BA0055-----       
             CALL s_umfchk(sr.ogb04,l_ohb05,l_ima25)                                                                                        
                RETURNING l_cnt,l_ohb15_fac                                                                                            
             IF l_ohb15_fac IS NULL  THEN LET l_ohb15_fac = 0 END IF
             SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                           WHERE ima01=sr.ogb04   
             EXECUTE insert_prep USING sr.*,l_ima906,l_ogb15_fac,l_ohb15_fac
             LET l_flag = 1   #MOD-BA0055
             LET l_ogb04_t = sr.ogb04   #MOD-BA0055
             LET l_oga02_t = sr.oga02   #MOD-BA0055
#      OUTPUT TO REPORT axmr730_rep(sr.*)
       #-----MOD-BA0055---------
          END FOREACH   
       END IF
       IF l_flag = 0 THEN
          EXECUTE insert_prep USING sr.*,l_ima906,l_ogb15_fac,l_ohb15_fac  
       END IF
       #-----END MOD-BA0055-----
       
     END FOREACH
#    FINISH REPORT axmr730_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ogb04,oga03,oga01')
                RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     #LET g_str = tm.wc,';',g_sma115,';',tm.a,';',tm.bdate,';',tm.edate   #MOD-BA0055
     LET g_str = tm.wc,';',g_sma115,';','',';',tm.bdate,';',tm.edate   #MOD-BA0055
     IF g_sma115="Y" THEN
        CALL cl_prt_cs3('axmr730','axmr730',g_sql,g_str)
     ELSE
        CALL cl_prt_cs3('axmr730','axmr730_1',g_sql,g_str)
     END IF
#No.FUN-850018 --End
END FUNCTION
 
#No.FUN-850018 --Begin
#REPORT axmr730_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#         sr        RECORD
#                   ogb04     LIKE ogb_file.ogb04,
#                   ogb06     LIKE ogb_file.ogb06,
#                   oga02     LIKE oga_file.oga02,
#                   ogb12     LIKE ogb_file.ogb12,
#                   oha02     LIKE oha_file.oha02,
#                   ohb12     LIKE ohb_file.ohb12,
#                   ogb05     LIKE ogb_file.ogb05,
#                   ima25     LIKE ima_file.ima25,
#                   ima021    LIKE ima_file.ima021,
#                   ogb910    LIKE ogb_file.ogb910,    #No.FUN-580004
#                   ogb912    LIKE ogb_file.ogb912,    #No.FUN-580004
#                   ogb913    LIKE ogb_file.ogb913,    #No.FUN-580004
#                   ogb915    LIKE ogb_file.ogb915     #No.FUN-580004
#          END RECORD ,
#        l_buf      ARRAY[10] OF LIKE aaf_file.aaf03,      # No.FUN-680137  VARCHAR(40)
#        l_cnt      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
#        l_ima25    LIKE gsb_file.gsb05,        # No.FUN-680137 VARCHAR(04)
#        l_ohb05    LIKE gsb_file.gsb05,        # No.FUN-680137 VARCHAR(04)
#        l_ogb15_fac  LIKE ogb_file.ogb15_fac,
#        l_ohb15_fac  LIKE ohb_file.ohb15_fac,
#        l_flag     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#        l_sql      STRING,  #MOD-7B0098 LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
#       #MOD-710028 modify
#        l_i,j      LIKE type_file.num10,    # No.FUN-680137 INTEGER
#        l_k,i,k    LIKE ogb_file.ogb12,     #MOD-710028 add
#        l_rowno    LIKE type_file.num5           # No.FUN-680137 SMALLINT
#No.FUN-580004--begin
#  DEFINE  l_ogb915    STRING
#  DEFINE  l_ogb912    STRING
#  DEFINE  l_str2      STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.ogb04,sr.oga02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
 
#   #MOD-6C0179-begin-modify
#    IF tm.a='1'  THEN
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#    ELSE 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[11]))/2)+1,g_x[11]
#    END IF
#   #MOD-6C0179-end-modify
#     LET g_head1 = g_x[10] CLIPPED,
#                   tm.bdate,"-",tm.edate
#     PRINT g_head1
#
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40]   
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#     BEFORE GROUP OF sr.ogb04
 
#FUN-580004--begin
 
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
#FUN-580004--end
#        #PRINT COLUMN g_c[31],sr.ogb04[1,20],   #No.FUN-580004
#        PRINT COLUMN g_c[31],sr.ogb04 CLIPPED,   #No.FUN-580004  #NO.FUN-5B0015
#No.TQC-6B0096 --begin
#              COLUMN g_c[32],sr.ogb06,
#              COLUMN g_c[33],sr.ima021,
#              COLUMN g_c[32],sr.ogb06[1,30],
#              COLUMN g_c[33],sr.ima021[1,30],
#No.TQC-6B0096 --end
#              COLUMN g_c[40],l_str2 CLIPPED,
#              COLUMN g_c[34],sr.ima25;
#        LET k = 0
 
#     BEFORE GROUP OF sr.oga02   # 同日出多次同產品
#        LET i = 0
#        LET j = 0
 
#     AFTER GROUP OF sr.oga02
#        CALL s_umfchk(sr.ogb04,sr.ogb05,sr.ima25)
#             RETURNING l_cnt,l_ogb15_fac
#        IF l_ogb15_fac IS NULL  THEN LET l_ogb15_fac = 0 END IF
#        LET l_k = GROUP SUM(sr.ogb12) * l_ogb15_fac
#        IF tm.a = '2' THEN #明細
#             #PRINT COLUMN g_c[35],sr.oga02  USING 'YY/MM/DD', #FUN-570250 mark
#             PRINT COLUMN g_c[35],sr.oga02, #FUN-570250 add
#                   COLUMN g_c[36],l_k USING '############.##'
#        END IF
#        LET k = k + l_k
 
#     AFTER GROUP OF sr.ogb04
#        DECLARE a_curs CURSOR FOR
#         SELECT oha02,ohb05,SUM(ohb12) #ohb05 銷售單位
#           FROM oga_file,oha_file,ohb_file
#          WHERE ohb04 = sr.ogb04
#            AND ohb31 = oga01
#            AND oha01 = ohb01
#            AND oha02 BETWEEN tm.bdate AND tm.edate #BugNo:4984
#           #AND oga09 = '2'
#            AND oga09 !='1' AND oga09 !='5'  #No.8347
#            AND oga09 !='7' AND oga09 !='9'  #No.FUN-610020
#            AND oga65='N'     #No.FUN-610020
#            AND ohaconf !='X'
#        GROUP BY oha02,ohb05
#        ORDER BY oha02,ohb05
 
#        FOREACH a_curs INTO sr.oha02,l_ohb05,sr.ohb12
#            SELECT ima25 INTO l_ima25 FROM ima_file
#             WHERE ima01 = sr.ogb04
#         CALL s_umfchk(sr.ogb04,l_ohb05,l_ima25)
#                   RETURNING l_cnt,l_ohb15_fac
#         IF l_ohb15_fac IS NULL  THEN LET l_ohb15_fac = 0 END IF
#           LET l_i =0
#           LET l_i =l_i + sr.ohb12 * l_ohb15_fac
#           IF tm.a = '2' THEN #明細
#              IF j THEN
#                 PRINT
#              END IF
#              #PRINT COLUMN g_c[37],sr.oha02 USING 'YY/MM/DD' ,#FUN-570250 mark
#              PRINT COLUMN g_c[37],sr.oha02, #FUN-570250 add
#                    COLUMN g_c[38],l_i USING '############.##'  #BugNo:4997
#           END IF
#           LET i = i+l_i
#           LET j = 1
#        END FOREACH
#        IF tm.a = '1' THEN    #彙總
#             PRINT COLUMN g_c[36],k USING '############.##',
#                   COLUMN g_c[38],i USING '############.##';
#        END IF
#        IF tm.a = '2' THEN
#            PRINT g_dash2
#        END IF
#        PRINT COLUMN g_c[39],(k-i) USING '------------.--'
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.FUN-580004
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.FUN-580004
#     ELSE
#        SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850018 --End
#No.FUN-870144
