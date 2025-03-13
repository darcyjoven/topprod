# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr834.4gl
# Descriptions...: 在製工單盤點過帳記錄表
# Input parameter: 
# Return code....: 
# Date & Author..: 93/11/15 By Apple
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.FUN-7C0007 07/12/12 By baofei 報表輸出至Crystal Reports功能    
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/21 By lilingyu 平行工藝
# Modify.........: No.MOD-C70063 12/07/09 By Sakura 取替代時應考慮替代率
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           wc       STRING,                 # Where Condition  #TQC-630166
           data     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
           post     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s        LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t        LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5,     #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13  #No.TQC-6A0088
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                       
#No.FUN-7C0007---End  
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
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "pid01.pid_file.pid01,",                                         
               "pid02.pid_file.pid02,",
               "pid03.pid_file.pid03,",                                         
               "pie02.pie_file.pie02,",                                         
               "pie11.pie_file.pie11,",                                         
               "pie12.pie_file.pie12,",                                         
               "pie13.pie_file.pie13,",    
               "pie16.pie_file.pie16,", 
               "sfb82.sfb_file.sfb82,",                                      
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "gem02.gem_file.gem02,",
               "count.pie_file.pie30,",
               "l_uninv.pie_file.pie11,", 
               "l_diff.pie_file.pie13,",
               "l_sfa05.sfa_file.sfa05,",
               "l_sfa06.sfa_file.sfa06,", 
               "l_sfa062.sfa_file.sfa062,",
               "l_short.pie_file.pie11,",       
               "l_short2.pie_file.pie11,",       #FUN-A60092 add,
               "pid012.pid_file.pid012,",        #FUN-A60092 add
               "pid021.pid_file.pid021"          #FUN-A60092 add                           
                                                        
   LET l_table = cl_prt_temptable('aimr834',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?) "       #FUN-A60092 add ?,?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
#No.FUN-7C0007---End
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.data  = ARG_VAL(8)
   LET tm.post  = ARG_VAL(9)
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r834_tm(0,0)        # Input print condition
      ELSE CALL r834()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r834_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r834_w AT p_row,p_col
        WITH FORM "aim/42f/aimr834" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.post = 'Y'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pid02,pid01,pid03,pie02,sfb82 
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
      LET INT_FLAG = 0 CLOSE WINDOW r834_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.data,tm.post,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.more 
                    WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD post 
         IF tm.post IS NULL OR tm.post = ' ' OR  
            tm.post NOT MATCHES'[YN]'
         THEN NEXT FIELD post
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r834_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr834'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr834','9031',1)
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
                         " '",tm.post   CLIPPED,"'",
                         " '",tm.s      CLIPPED,"'",
                         " '",tm.t      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr834',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r834_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r834()
   ERROR ""
END WHILE
   CLOSE WINDOW r834_w
END FUNCTION

#No.FUN-7C0007---Begin  
FUNCTION r834_cur()                                                                                                                 
 DEFINE  l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)                                                                     
                                                                                                                                    
   LET l_cmd = "SELECT sfa05,sfa06,sfa064,sfa065 ",                                                                                 
               "  FROM sfa_file ",                                                                                                  
               " WHERE sfa01 = ? ",                                                                                                 
               "   AND sfa03 = ? ",                                                                                                 
               "   AND sfa08 = ? ",                                                                                                 
               "   AND sfa12 = ? ",                                                                                                  
               "   AND sfa27 = ? "   #No.FUN-870051                                                                                                                    
              ,"   AND sfa012= ?"    #FUN-A60092
              ,"   AND sfa013= ?"     #FUN-A60092
     PREPARE r834_psfa FROM l_cmd                                                                                                   
     IF SQLCA.sqlcode != 0 THEN                                                                                                     
        CALL cl_err('prepare:',SQLCA.sqlcode,1)                                                                                     
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo                                                      
        EXIT PROGRAM                                                                                                                
                                                                                                                                    
     END IF                                                                                                                         
     DECLARE r834_csfa  CURSOR FOR r834_psfa                                                                                        
END FUNCTION                      
#No.FUN-7C0007---End  

FUNCTION r834()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD 
                    order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    pid01  LIKE pid_file.pid01,   #標籤號碼
                    pid02  LIKE pid_file.pid02,   #工單編號
                    pid03  LIKE pid_file.pid03,   #生產料件
                    pid13  LIKE pid_file.pid13,   #入庫量  
                    pid17  LIKE pid_file.pid17,   #報廢量  
                    pie02  LIKE pie_file.pie02,   #盤點料號
                    pie03  LIKE pie_file.pie03,   #編號
                    pie04  LIKE pie_file.pie04,   #發料單位
                    pie11  LIKE pie_file.pie11,   #應發量
                    pie12  LIKE pie_file.pie12,   #已發量
                    pie13  LIKE pie_file.pie13,   #超領量
                    pie14  LIKE pie_file.pie14,   #QBA
                    pie15  LIKE pie_file.pie15,   #報廢數量
                    pie151 LIKE pie_file.pie151,  #代買量
                    pie16  LIKE pie_file.pie16,   #過帳否  
                    pie30  LIKE pie_file.pie30,   
                    pie50  LIKE pie_file.pie50, 
                    pie900 LIKE pie_file.pie900,  #No.FUN-870051  
                    count  LIKE pie_file.pie30,
                    ima02  LIKE ima_file.ima02,   #品名規格
                    ima021 LIKE ima_file.ima021,  #FUN-510017
                    sfb82  LIKE sfb_file.sfb82,   #製造部門
                    gem02  LIKE gem_file.gem02    #製造部門
                   ,pid012 LIKE pid_file.pid012   #FUN-A60092
                   ,pid021 LIKE pid_file.pid021   #FUN-A60092 
                    END RECORD,                   #No.FUN-7C0007
#No.FUN-7C0007---Begin
      l_sfa05      LIKE sfa_file.sfa05,
      l_sfa06      LIKE sfa_file.sfa06,
      l_sfa062     LIKE sfa_file.sfa062,
      l_sfa064     LIKE sfa_file.sfa064,
      l_diff       LIKE pid_file.pid13,
      l_uninv      LIKE pie_file.pie11,
      l_actuse     LIKE pie_file.pie11,
      l_short      LIKE pie_file.pie11,
      l_short2     LIKE pie_file.pie11,
      l_cnt        LIKE type_file.num5   
   DEFINE  l_sfa28 LIKE sfa_file.sfa28  #MOD-C70063 add

     CALL cl_del_data(l_table) 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
#No.FUN-7C0007---End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 " pid01, pid02, pid03, pid13, pid17, ",
                 " pie02, pie03, pie04, pie11, pie12, pie13, pie14, ",
                 " pie15, pie151,pie16, pie30, pie50, pie900,0,", #No.FUN-870051 add pie900
                 " ima02, ima021, sfb82, gem02,pid012,pid021 ", #FUN-510017
                                                                #FUN-A60092 add pid012,pid021
                 "  FROM pid_file,pie_file,sfb_file,",
                 "  OUTER ima_file, OUTER gem_file",
                 " WHERE pid01=pie01  AND pid02 =sfb01",
                 "   AND pie_file.pie02=ima_file.ima01  AND sfb_file.sfb82=gem_file.gem01",
                 "   AND pie02 IS NOT NULL AND sfb87!='X' ",
                 "   AND ",tm.wc
     IF tm.post = 'N'
     THEN LET l_sql = l_sql clipped," AND pie16 ='Y' "
     END IF
     PREPARE r834_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r834_curs1 CURSOR FOR r834_prepare1
 
#     LET l_name = 'aimr834.out'                 #No.FUN_7C0007
#     CALL cl_outnam('aimr834') RETURNING l_name #No.FUN_7C0007
#     START REPORT r834_rep TO l_name            #No.FUN_7C0007
     CALL r834_cur()
#     LET g_pageno = 0                           #No.FUN_7C0007
     FOREACH r834_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
      #IF sr.pie50 IS NULL THEN     #MOD-C70063 mark
       IF sr.pie50 IS NOT NULL THEN #MOD-C70063 add
          LET sr.count = sr.pie50
       ELSE 
          LET sr.count = sr.pie30
       END IF
#No.FUN-7C0007---Begin 
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid02
#                                        LET l_orderA[g_i] =g_x[61]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid01
#                                        LET l_orderA[g_i] =g_x[62]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pid03
#                                        LET l_orderA[g_i] =g_x[63]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pie02
#                                        LET l_orderA[g_i] =g_x[64]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sfb82
#                                        LET l_orderA[g_i] =g_x[65]    #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                                        LET l_orderA[g_i] =''    #TQC-6A0088
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
      IF sr.pie16 = 'Y' THEN 
           IF cl_null(sr.pie900) THEN LET sr.pie900=sr.pie02 END IF #FUN-870051 
           OPEN r834_csfa USING sr.pid02, 
                                sr.pie02,
                                sr.pie03, 
                                sr.pie04,
                                sr.pie900     #No.FUN-870051 
                               ,sr.pid012  #FUN-A60092 add
                               ,sr.pid021  #FUN-A60092 add 
           FETCH r834_csfa INTO l_sfa05,l_sfa06,l_sfa064,l_sfa062
           IF SQLCA.sqlcode THEN 
              LET l_sfa05 = ' '  LET l_sfa06 = ' '
              LET l_sfa064 = ' '  LET l_sfa062 = ' '
           END IF
           CLOSE r834_csfa
      END IF
      SELECT sfa28 INTO l_sfa28 FROM sfa_file WHERE sfa01 = sr.pid02 AND sfa03 = sr.pie02 #MOD-C70063 add
      IF sr.pie16 ='N' THEN 
        #LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15            #MOD-C70063 mark
         LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14 * l_sfa28) + sr.pie15  #MOD-C70063 add       
         LET l_uninv = (sr.pie12 + sr.pie13) - l_actuse
         LET l_diff  = sr.count - l_uninv
      ELSE 
        #LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15            #MOD-C70063 mark
         LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14 * l_sfa28) + sr.pie15  #MOD-C70063 add
         LET l_uninv  = (sr.pie12 + sr.pie13) - l_actuse
         LET l_diff = l_sfa064
      END IF
      LET l_short = sr.pie11 - sr.pie12
      LET l_short2 = l_sfa05 - l_sfa06        
       EXECUTE insert_prep USING sr.pid01,sr.pid02,sr.pid03,sr.pie02,sr.pie11,sr.pie12,
                                 sr.pie13,sr.pie16,sr.sfb82,sr.ima02,sr.ima021,
                                 sr.gem02,sr.count,l_uninv,l_diff,l_sfa05,l_sfa06,
                                 l_sfa062,l_short,l_short2
                                ,sr.pid012,sr.pid021   #FUN-A60092 add 
#       OUTPUT TO REPORT r834_rep(sr.*)
#No.FUN-7C0007---End
     END FOREACH
#No.FUN-7C0007---Begin
#     FINISH REPORT r834_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'pid02,pid01,pid03,pie02,sfb82')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.data,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                      tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   IF g_sma.sma541 = 'N' THEN    #FUN-A60092 add
       CALL cl_prt_cs3('aimr834','aimr834',l_sql,g_str) 
   ELSE                                                      #FUN-A60092 add
       CALL cl_prt_cs3('aimr834','aimr834_1',l_sql,g_str)    #FUN-A60092 add     
   END IF                                                    #FUN-A60092 add

#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---End
END FUNCTION

#No.FUN-7C0007---Begin     
#FUNCTION r834_cur()
#DEFINE  l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
 
#   LET l_cmd = "SELECT sfa05,sfa06,sfa064,sfa065 ",
#               "  FROM sfa_file ",
#               " WHERE sfa01 = ? ",
#               "   AND sfa03 = ? ",
#               "   AND sfa08 = ? ",
#               "   AND sfa12 = ? "
 
#     PREPARE r834_psfa FROM l_cmd
#     IF SQLCA.sqlcode != 0 THEN 
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM 
           
#     END IF
#     DECLARE r834_csfa  CURSOR FOR r834_psfa
#END FUNCTION
#REPORT r834_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         sr           RECORD 
#                      order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                      order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                      order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                      pid01  LIKE pid_file.pid01,   #標籤號碼
#                      pid02  LIKE pid_file.pid02,   #工單編號
#                      pid03  LIKE pid_file.pid03,   #生產料件
#                      pid13  LIKE pid_file.pid13,   #入庫量  
#                      pid17  LIKE pid_file.pid17,   #報廢量  
#                      pie02  LIKE pie_file.pie02,   #盤點料號
#                      pie03  LIKE pie_file.pie03,   #作業編號
#                      pie04  LIKE pie_file.pie04,   #發料單位
#                      pie11  LIKE pie_file.pie11,   #應發量
#                      pie12  LIKE pie_file.pie12,   #已發量
#                      pie13  LIKE pie_file.pie13,   #超領量
#                      pie14  LIKE pie_file.pie14,   #QBA
#                      pie15  LIKE pie_file.pie15,   #報廢數量
#                      pie151 LIKE pie_file.pie151,  #代買量
#                      pie16  LIKE pie_file.pie16,   #過帳否  
#                      pie30  LIKE pie_file.pie30,   
#                      pie50  LIKE pie_file.pie50,   
#                      count  LIKE pie_file.pie30,
#                      ima02  LIKE ima_file.ima02,   #品名規格
#                      ima021 LIKE ima_file.ima021,  #FUN-510017
#                      sfb82  LIKE sfb_file.sfb82,   #製造部門
#                      gem02  LIKE gem_file.gem02    #製造部門
#                      END RECORD,
#     l_sfa05      LIKE sfa_file.sfa05,
#     l_sfa06      LIKE sfa_file.sfa06,
#     l_sfa062     LIKE sfa_file.sfa062,
#     l_sfa064     LIKE sfa_file.sfa064,
#     l_diff       LIKE pid_file.pid13,
#     l_uninv      LIKE pie_file.pie11,
#     l_actuse     LIKE pie_file.pie11,
#     l_short      LIKE pie_file.pie11,
#     l_short2     LIKE pie_file.pie11,
#     l_cnt        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#     l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.pid02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno" 
#     PRINT g_head CLIPPED,pageno_total     
#     PRINT tm.data
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                      '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#     PRINT g_dash
#     PRINT COLUMN g_c[39],g_x[16] CLIPPED,
#           COLUMN g_c[42],g_x[17] CLIPPED
#     PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+1+g_w[39]+1+g_w[40]],
#           COLUMN g_c[41],g_dash2[1,g_w[41]+1+g_w[42]+1+g_w[43]]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#     PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
#     PRINTX name=H3 g_x[51],g_x[52]
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 12)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 12)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 12)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.pid02 
#     PRINTX name=D1 COLUMN g_c[31],sr.pid02,
#                    COLUMN g_c[32],sr.pid01,
#                    COLUMN g_c[33],sr.sfb82 USING '######',
#                    COLUMN g_c[34],sr.gem02;
#  ON EVERY ROW
#     #--->列印過帳後備料資料
#     IF sr.pie16 = 'Y' 
#     THEN 
#          OPEN r834_csfa USING sr.pid02,   #工單編號
#                               sr.pie02,   #下階料件 
#                               sr.pie03,   #作業序號
#                               sr.pie04    #發料單位
#          FETCH r834_csfa INTO l_sfa05,l_sfa06,l_sfa064,l_sfa062
#          IF SQLCA.sqlcode THEN 
#             LET l_sfa05 = ' '  LET l_sfa06 = ' '
#             LET l_sfa064 = ' '  LET l_sfa062 = ' '
#          END IF
#          CLOSE r834_csfa
#     END IF
#     #--->計算未入庫數量
#     #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
#     #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
#     IF sr.pie16 ='N' THEN 
#        LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15 
#        LET l_uninv = (sr.pie12 + sr.pie13) - l_actuse
#        LET l_diff  = sr.count - l_uninv
#     ELSE 
#        LET l_actuse = ((sr.pid13 + sr.pid17) * sr.pie14) + sr.pie15 
#        LET l_uninv  = (sr.pie12 + sr.pie13) - l_actuse
#        LET l_diff = l_sfa064
#     END IF
#     LET l_short = sr.pie11 - sr.pie12
#     LET l_short2 = l_sfa05 - l_sfa06
#     PRINTX name=D1 COLUMN g_c[35],sr.pie02,
#                    COLUMN g_c[36],cl_numfor(l_uninv,36,3),   #應盤點量 
#                    COLUMN g_c[37],cl_numfor(l_diff,37,3),    #盈虧數量
 
#                    COLUMN g_c[38],cl_numfor(sr.pie11,38,3),  #應發量              
#                    COLUMN g_c[39],cl_numfor(sr.pie12,39,3),  #已發量              
#                    COLUMN g_c[40],cl_numfor(l_short,40,3);   #缺料量              
#     IF sr.pie16 ='Y' THEN 
#         PRINTX name=D1 COLUMN g_c[41],cl_numfor(l_sfa05,41,3),#應發量
#                        COLUMN g_c[42],cl_numfor(l_sfa06,42,3),#已發量
#                        COLUMN g_c[43],cl_numfor(l_short2,43,3)#缺料量
#     ELSE               
#         PRINTX name=D1 COLUMN g_c[41],'*',
#                        COLUMN g_c[42],'',
#                        COLUMN g_c[43],''
#     END IF
 
#     PRINTX name=D2 COLUMN g_c[44],' ',
#                    COLUMN g_c[45],sr.ima02,
#                    COLUMN g_c[46],cl_numfor(sr.count,46,3), #盤點量    
#                    COLUMN g_c[47],' ',
#                    COLUMN g_c[48],cl_numfor(sr.pie13,48,3), #超領量              
#                    COLUMN g_c[49],' ';
#     IF sr.pie16 = 'Y' THEN 
#        PRINTX name=D2 COLUMN g_c[50],cl_numfor(l_sfa062,50,3) #超領量
#     ELSE
#        PRINTX name=D2 COLUMN g_c[50],''
#     END IF
#     PRINTX name=D3 COLUMN g_c[51],' ',
#                    COLUMN g_c[52],sr.ima021
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'pid02,pid01,pid03,pie02,sfb82')
#             RETURNING tm.wc
#        PRINT g_dash
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132 
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_x[18] clipped
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[18] clipped
#             PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 3 LINE
#      END IF
#END REPORT
#No.FUN-7C0007---End 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r834_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
