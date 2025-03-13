# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aimr833.4gl
# Descriptions...: 盤點清單－在製工單
# Input parameter: 
# Return code....: 
# Date & Author..: 93/11/11 By Apple
# Modify.........: No.FUN-510017 05/02/22 By Mandy 報表轉XML
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-7B0138 07/12/05 By Lutingting 轉為用Crystal Report 輸出
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-AC0094 10/12/13 By sabrina 報表表頭增加"作業編號"欄位
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數,報表類程式傳入空
# Modify.........: No:MOD-D10132 13/01/30 By bart計算未入庫量時，如為替代料則判斷，原bom料號扣完了，餘量才扣

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                           # Print condition RECORD
                 wc       STRING,                 # Where Condition  #TQC-630166
                 data     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
                 choice   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 user     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 type     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                 END RECORD
#       g_str     LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(40)  #No.FUN-7B0138
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table   STRING                  #No.FUN-7B0138
DEFINE g_str     STRING                  #No.FUN-7B0138 
DEFINE g_sql     STRING                  #No.FUN-7B0138 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#No.FUN-7B0138--START--
   LET g_sql = "pid02.pid_file.pid02,",
               "pid022.pid_file.pid022,",      #MOD-AC0094 add
               "pid03.pid_file.pid03,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "pid05.pid_file.pid05,",
               "sfb82.sfb_file.sfb82,",
               "gem02.gem_file.gem02,",
               "pid01.pid_file.pid01,",
               "pid04.pid_file.pid04,",
               "l_pair.pid_file.pid04,",
               "pid13.pid_file.pid13,", 
               "l_diff.pid_file.pid13,",
               "pie07.pie_file.pie07,",
               "pie02.pie_file.pie02,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pie04.pie_file.pie04,",
               "pie14.pie_file.pie14,",
               "pie11.pie_file.pie11,",
               "mkqty.pie_file.pie12,",
               "l_uninv.pie_file.pie11,",
               "pie30.pie_file.pie30,", 
               "pie40.pie_file.pie40,", 
               "pie50.pie_file.pie50,", 
               "pie60.pie_file.pie60,",      #FUN-A60027
               "pie012.pie_file.pie012,",    #FUN-A60027
               "pie013.pie_file.pie013"      #FUN-A60027
   LET l_table =cl_prt_temptable('aimr833',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES (?,?,?,?,?,?,?,?,?,?,  ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?)"     #FUN-A60027 add 2?  #MOD-AC0094 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('inset_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7B0138--end
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.data  = ARG_VAL(8)
   LET tm.choice= ARG_VAL(9)
   LET tm.user  = ARG_VAL(10)
   LET tm.type  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r833_tm(0,0)        # Input print condition
      ELSE CALL r833()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r833_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 17
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r833_w AT p_row,p_col
        WITH FORM "aim/42f/aimr833" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice= '1'
   LET tm.user  = '1'
   LET tm.type  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pid02,pid01,pid03,sfb82 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.data,tm.choice,tm.user,tm.type,tm.more 
                    WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[12]'
         THEN NEXT FIELD choice
         END IF
 
      AFTER FIELD user  
         IF tm.user   IS NULL OR tm.user   NOT MATCHES'[12]'
         THEN NEXT FIELD user  
         END IF
 
      AFTER FIELD type  
         IF tm.type   IS NULL OR tm.type   NOT MATCHES'[YN]'
         THEN NEXT FIELD type  
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW r833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr833'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr833','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.data   CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.user   CLIPPED,"'",
                         " '",tm.type   CLIPPED,"'",            #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr833',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r833_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r833()
   ERROR ""
END WHILE
   CLOSE WINDOW r833_w
END FUNCTION
 
FUNCTION r833()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr        RECORD 
                    pid01  LIKE pid_file.pid01,   #標籤號碼
                    pid02  LIKE pid_file.pid02,   #料件編號
                    pid022 LIKE pid_file.pid022,  #作業編號
                    pid03  LIKE pid_file.pid03,   #生產料號
                    pid04  LIKE pid_file.pid04,   #生產數量
                    pid05  LIKE pid_file.pid05,   #生產單位
                    pid13  LIKE pid_file.pid13,   #入庫量  
                    pid17  LIKE pid_file.pid17,   #報廢量  
                    pie02  LIKE pie_file.pie02,   #盤點料號
                    pie04  LIKE pie_file.pie04,   #發料單位
                    pie07  LIKE pie_file.pie07,   #項次
                    pie11  LIKE pie_file.pie11,   #應發數量
                    mkqty  LIKE pie_file.pie12,   #實發數量
                    pie14  LIKE pie_file.pie14,   #QBA
                    pie15  LIKE pie_file.pie15,   #報廢數量
                    pie151 LIKE pie_file.pie151,  #代買量
                    pie30  LIKE pie_file.pie30,   
                    pie40  LIKE pie_file.pie40,   
                    pie50  LIKE pie_file.pie50,   
                    pie60  LIKE pie_file.pie60,   
                    pie012 LIKE pie_file.pie012,  #FUN-A60027
                    pie013 LIKE pie_file.pie013,  #FUN-A60027
                    count  LIKE pie_file.pie30,
                    sfb82  LIKE sfb_file.sfb82,   #製造部門
                    ima02  LIKE ima_file.ima02,   #品名規格
                    ima021 LIKE ima_file.ima021,  #FUN-510017
                    gem02  LIKE gem_file.gem02,    #製造部門
                    pie900 LIKE pie_file.pie900   #MOD-D10132
                    END RECORD
#No.FUN-7B0138--START--自rep()提上來
   DEFINE  l_sw         LIKE type_file.num5,                                                                 
           l_diff       LIKE pid_file.pid13,                                                                                        
           l_pair       LIKE pid_file.pid04,                                                                                        
           l_uninv      LIKE pie_file.pie11,                                                                                        
           l_actuse     LIKE pie_file.pie11,                                                                                        
           l_ima02      LIKE ima_file.ima02,                                                                                        
           l_ima153     LIKE ima_file.ima153,  #FUN-910053
           l_ima021     LIKE ima_file.ima021
#No.FUN-7B0138--END   
   DEFINE  l_mkqty      LIKE pie_file.pie12    #MOD-D10132
   DEFINE  l_uninv1     LIKE pie_file.pie11    #MOD-D10132
   
     CALL cl_del_data(l_table)                                   #No.FUN-7B0138
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aimr833'   #No.FUN-7B0138
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT pid01, pid02, pid022,pid03, pid04, pid05, pid13, pid17,",   #MOD-AC0094 add pid022
                 "       pie02, pie04, pie07, pie11, (pie12+pie13),",
                 "       pie14, pie15, pie151,pie30, pie40, pie50, ",
                 "       pie60, pie012,pie013,0,sfb82,ima02,ima021, gem02,pie900 ", #FUN-510017 add ima021    #FUN-A60027 add pie012,pie013 #MOD-D10132
                 "  FROM pid_file,pie_file,sfb_file,",
                 "  OUTER ima_file, OUTER gem_file",
               # " WHERE pid01=pid01  AND pid02 =sfb01",
                 " WHERE pid01=pie01  AND pid02 =sfb01",  #No.B201 010322 mod
                 "   AND pie_file.pie02= ima_file.ima01 AND sfb_file.sfb82=gem_file.gem01",
                 "   AND pid02 IS NOT NULL AND sfb87!='X' ",
                 "   AND ",tm.wc
     IF tm.type ='N'
     THEN  CASE tm.choice    
           WHEN  '1'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,"AND pie30 >=0 "
                      ELSE LET l_sql =l_sql clipped,"AND pie50 >=0 "
                      END IF
           WHEN  '2'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,"AND pie40 >=0 "
                      ELSE LET l_sql =l_sql clipped,"AND pie60 >=0 "
                      END IF
           END CASE
     END IF
     PREPARE r833_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r833_curs1 CURSOR FOR r833_prepare1
 
#No.FUN-7B0138--START--     
#     CALL cl_outnam('aimr833') RETURNING l_name 
#     LET l_name = 'aimr833.out'
#     START REPORT r833_rep TO l_name
#     IF tm.choice = '1' 
#     THEN LET g_str = g_x[15] clipped
#     ELSE LET g_str = g_x[16] clipped
#     END IF
#     LET g_pageno = 0
#No.FUN-7B0138--END
     FOREACH r833_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
#No.FUN-7B0138--START--
#       IF tm.user = '1' 
#       THEN IF tm.choice = '1' 
#            THEN LET sr.count = sr.pie30
#            ELSE LET sr.count = sr.pie50
#            END IF
#       ELSE IF tm.choice = '1'
#            THEN LET sr.count = sr.pie40
#            ELSE LET sr.count = sr.pie60
#            END IF
#       END IF
#       OUTPUT TO REPORT r833_rep(sr.*)
       #--->擷取發料套數                                                                                                             
        CALL s_get_ima153(sr.pid03) RETURNING l_ima153  #FUN-910053
       #CALL s_minp(sr.pid02,g_sma.sma73,g_sma.sma74,'')#FUN-910053                                                                             
       #CALL s_minp(sr.pid02,g_sma.sma73,l_ima153,'',sr.pie012,sr.pie013)   #FUN-910053 #FUN-A60027 add pie012,pie013  #FUN-C70037 mark                                                                        
        CALL s_minp(sr.pid02,g_sma.sma73,l_ima153,'',sr.pie012,sr.pie013,'') #FUN-C70037 
        RETURNING l_sw,l_pair                                                                                                        
       #--->未完套數                                                                                                                 
        LET l_diff = l_pair - sr.pid13                                                                                               
        IF l_diff < 0 THEN LET l_diff = ' ' END IF                                                                                   
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.pid03   
       #--->計算未入庫數量                                                                                                           
       #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢                                                                   
       #    應盤數量  = 已發數量 + 超領數量 - 實際已用量                                                                             
       LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15 
       #MOD-D10132---begin
       IF sr.pie02 <> sr.pie900 THEN
          LET l_mkqty = 0
          SELECT pie12+pie13
            INTO l_mkqty
            FROM pie_file
           WHERE pie01 = sr.pid01
             AND pie02 = sr.pie900
          LET l_uninv1 = l_mkqty - l_actuse 
          IF l_uninv1 < 0 THEN 
             LET l_uninv = sr.mkqty + l_uninv1
          ELSE 
             LET l_uninv = sr.mkqty
          END IF 
       ELSE 
       #MOD-D10132---end       
          LET l_uninv = sr.mkqty - l_actuse 
          IF l_uninv < 0 THEN LET l_uninv = 0 END IF #MOD-D10132
       END IF   #MOD-D10132
       EXECUTE insert_prep USING
           sr.pid02,sr.pid022,sr.pid03,l_ima02,l_ima021,sr.pid05,sr.sfb82,sr.gem02,sr.pid01,    #MOD-AC0094 add pid022
           sr.pid04,l_pair,sr.pid13,l_diff,sr.pie07,sr.pie02,sr.ima02,sr.ima021,
           sr.pie04,sr.pie14,sr.pie11,sr.mkqty,l_uninv,sr.pie30,sr.pie40,sr.pie50,
           sr.pie60,sr.pie012,sr.pie013                                              #FUN-A60027 add pie012,pie013             
#No.FUN-7B0138--END
     END FOREACH
#No.FUN-7B0138--START--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'pid02,pid01,pid03,sfb82')
        RETURNING tm.wc
        LET g_str=tm.wc
     END IF
     LET g_str= g_str,";",tm.user,";",tm.choice,";",tm.data
#    CALL cl_prt_cs3('aimr833','aimr833',g_sql,g_str)           #FUN-A60027 mark
     #FUN-A60027 -------------------start--------------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('aimr833','aimr833_1',g_sql,g_str)
     ELSE
        CALL cl_prt_cs3('aimr833','aimr833',g_sql,g_str) 
     END IF 
     #FUN-A60027-------------------end----------------------- 
#     FINISH REPORT r833_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0138--END
END FUNCTION
 
#No.FUN-7B0138--START--
#REPORT r833_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr           RECORD 
#                       pid01  LIKE pid_file.pid01,   #標籤號碼
#                       pid02  LIKE pid_file.pid02,   #料件編號
#                       pid03  LIKE pid_file.pid03,   #生產料號
#                       pid04  LIKE pid_file.pid04,   #生產數量
#                       pid05  LIKE pid_file.pid05,   #生產單位
#                       pid13  LIKE pid_file.pid13,   #入庫量  
#                       pid17  LIKE pid_file.pid17,   #報廢量  
#                       pie02  LIKE pie_file.pie02,   #盤點料號
#                       pie04  LIKE pie_file.pie04,   #發料單位
#                       pie07  LIKE pie_file.pie07,   #項次
#                       pie11  LIKE pie_file.pie11,   #應發數量
#                       mkqty  LIKE pie_file.pie12,   #實發數量
#                       pie14  LIKE pie_file.pie14,   #QBA
#                       pie15  LIKE pie_file.pie15,   #報廢數量
#                       pie151 LIKE pie_file.pie151,  #代買量
#                       pie30  LIKE pie_file.pie30,   
#                       pie40  LIKE pie_file.pie40,   
#                       pie50  LIKE pie_file.pie50,   
#                       pie60  LIKE pie_file.pie60,   
#                       count  LIKE pie_file.pie30,
#                       sfb82  LIKE sfb_file.sfb82,   #製造部門
#                       ima02  LIKE ima_file.ima02,   #品名規格
#                       ima021 LIKE ima_file.ima021,  #FUN-510017
#                       gem02  LIKE gem_file.gem02    #製造部門
#                       END RECORD,
#          l_sw         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#          l_diff       LIKE pid_file.pid13,
#          l_pair       LIKE pid_file.pid04,
#          l_uninv      LIKE pie_file.pie11,
#          l_actuse     LIKE pie_file.pie11,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,  #FUN-510017
#          l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pid02,sr.pie07,sr.pie02
#  FORMAT
#   PAGE HEADER
#      #--->擷取發料套數
#       CALL s_minp(sr.pid02,g_sma.sma73,g_sma.sma74,'')
#       RETURNING l_sw,l_pair
#      #--->未完套數
#       LET l_diff = l_pair - sr.pid13
#       IF l_diff < 0 THEN LET l_diff = ' ' END IF
#       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.pid03
 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED,g_str
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
#      PRINT tm.data
#      PRINT g_dash
#      #----
#      PRINT column  3,g_x[17] clipped,sr.pid02, column 52,g_x[21] clipped,sr.pid01
#      PRINT column  3,g_x[18] clipped,sr.pid03, column 52,g_x[22] clipped,sr.pid04 using '------------&.&&&'
#      PRINT column 12,l_ima02, column 52,g_x[23] clipped,l_pair   using '------------&.&&&'
#      PRINT column 12,l_ima021,column 52,g_x[24] clipped,sr.pid13 using '------------&.&&&'
#      PRINT column  3,g_x[19] clipped,sr.pid05, column 52,g_x[25] clipped,l_diff   using '------------&.&&&'
#      PRINT column  3,g_x[20] clipped,sr.sfb82,'  ',sr.gem02
#      PRINT ' '
      #----
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
#      PRINTX name=H3 g_x[43],g_x[44]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.pid02 
#      IF (PAGENO > 1 OR LINENO > 17)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   ON EVERY ROW
      #--->計算未入庫數量
      #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
      #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
#      LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15 
#      LET l_uninv = sr.mkqty - l_actuse
#      PRINTX name=D1 COLUMN g_c[31],sr.pie07 using '###&',
#                     COLUMN g_c[32],sr.pie02,
#                     COLUMN g_c[33],sr.pie04,
#                     COLUMN g_c[34],cl_numfor(sr.pie14,34,5),
#                     COLUMN g_c[35],cl_numfor(sr.pie11,35,3),
#                     COLUMN g_c[36],cl_numfor(l_uninv,36,3),
#                     COLUMN g_c[37],cl_numfor(sr.count,37,3)
#      PRINTX name=D2 COLUMN g_c[38],' ',
#                     COLUMN g_c[39],sr.ima02,
#                     COLUMN g_c[40],' ',
#                     COLUMN g_c[41],' ',
#                     COLUMN g_c[42],cl_numfor(sr.mkqty,42,3)
#      PRINTX name=D3 COLUMN g_c[43],' ',
#                     COLUMN g_c[44],sr.ima021
 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pid03,pid04,pid05,pid02,pid01')
#              RETURNING tm.wc
#         PRINT g_dash
#TQC-630166
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##            IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7B0138--END
 
