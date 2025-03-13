# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr830.4gl
# Descriptions...: 複盤差異分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/27 By Apple
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.MOD-720046 07/03/15 By TSD.Jin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                       # Print condition RECORD
           wc   STRING,                 # Where Condition  #TQC-630166
           diff LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,    # Order by sequence  #No.FUN-690026 VARCHAR(3)
           t    LIKE type_file.chr3,    # Eject sw  #No.FUN-690026 VARCHAR(3)
           more LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_q_point  LIKE zaa_file.zaa08,     #No.FUN-690026 VARCHAR(80)
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
DEFINE g_star     LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(80)
#MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#MOD-720046 By TSD.Jin--end
 
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
 
   #MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " pia01.pia_file.pia01,  ",
               " pia02.pia_file.pia02,  ",
               " pia03.pia_file.pia03,  ",
               " pia04.pia_file.pia04,  ",
               " pia05.pia_file.pia05,  ",
               " pia08.pia_file.pia08,  ",
               " pia50.pia_file.pia50,  ",
               " pia51.pia_file.pia51,  ",
               " pia54.pia_file.pia54,  ",
               " pia55.pia_file.pia55,  ",
               " pia60.pia_file.pia60,  ",
               " pia61.pia_file.pia61,  ",
               " pia64.pia_file.pia64,  ",
               " pia65.pia_file.pia65,  ",
               " ima02.ima_file.ima02,  ",
               " ima021.ima_file.ima021,",
               " gen02_1.gen_file.gen02,",
               " gen02_2.gen_file.gen02,",
               " gen02_pia51.gen_file.gen02,",
               " gen02_pia61.gen_file.gen02,",
               " azi03.azi_file.azi03,  ", 
               " azi04.azi_file.azi04,  ", 
               " azi05.azi_file.azi05   "  
 
   LET l_table = cl_prt_temptable('aimr830',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?) " 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #MOD-720046 By TSD.Jin--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.diff  = ARG_VAL(8)      #TQC-610072 順序順推
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r830_tm(0,0)        # Input print condition
      ELSE CALL r830()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r830_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col =17
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r830_w AT p_row,p_col
        WITH FORM "aim/42f/aimr830" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
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
   CONSTRUCT BY NAME tm.wc ON pia01,pia03,pia04,pia05,pia02,pia51,pia61,pia931     #FUN-930122 Add pia931
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
            IF INFIELD(pia02) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO pia02                                                                                 
               NEXT FIELD pia02                                                                                                     
            END IF                                                            
#No.FUN-570240 --end  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.diff,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD diff 
         IF tm.diff IS NULL OR tm.diff NOT MATCHES'[YNyn]'
         THEN NEXT FIELD diff
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
      LET INT_FLAG = 0 CLOSE WINDOW r830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr830'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr830','9031',1)
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
                         " '",tm.diff CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr830',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r830_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r830()
   ERROR ""
END WHILE
   CLOSE WINDOW r830_w
END FUNCTION
 
FUNCTION r830()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           pia01  LIKE pia_file.pia01,
                           pia02  LIKE pia_file.pia02,
                           pia03  LIKE pia_file.pia03,
                           pia04  LIKE pia_file.pia04,
                           pia05  LIKE pia_file.pia05,
                           pia08  LIKE pia_file.pia08,
                           pia50  LIKE pia_file.pia50,
                           pia51  LIKE pia_file.pia51,
                           pia54  LIKE pia_file.pia54,
                           pia55  LIKE pia_file.pia55,
                           pia60  LIKE pia_file.pia60,
                           pia61  LIKE pia_file.pia61,
                           pia64  LIKE pia_file.pia64,
                           pia65  LIKE pia_file.pia65,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           gen02_1     LIKE gen_file.gen02,
                           gen02_2     LIKE gen_file.gen02,
                           gen02_pia51 LIKE gen_file.gen02,
                           gen02_pia61 LIKE gen_file.gen02
                        END RECORD
 
   #MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #MOD-720046 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 "pia01, pia02, pia03, pia04,",
                 "pia05, pia08, pia50, pia51, pia54, pia55,",
                 "pia60, pia61, pia64, pia65, ima02,ima021, gen02",
                 "  FROM pia_file ,OUTER gen_file ,OUTER ima_file",
                 " WHERE pia_file.pia54=gen_file.gen01 AND pia_file.pia02=ima_file.ima01",
                 " AND (pia02 IS NOT NULL OR  pia02 != ' ') ",
             #   " AND ( (pia50 IS NOT NULL OR  pia50 != ' ') ",
             #   "  OR (pia60 IS NOT NULL OR  pia60 != ' ')) ",
                 " AND ( (pia50 IS NOT NULL OR  pia50 != 0) ", # modi NO:2565
                 "  OR (pia60 IS NOT NULL OR  pia60 != 0 )) ",
                 " AND ",tm.wc
 
     #複盤資料輸入員(一)與資料輸入員(二)
     IF tm.diff ='N' THEN 
  {
        LET l_sql = l_sql clipped," AND (pia50 != pia60 OR ",
                              " pia50 IS NULL OR pia50 = ' ' OR",
                              " pia60 IS NULL OR pia60 = ' ' )"
   }
        LET l_sql = l_sql clipped," AND (pia50 != pia60 )"
     END IF
 
     PREPARE r830_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r830_curs1 CURSOR FOR r830_prepare1
 
    #MOD-720046 By TSD.Jin--start mark
    #LET l_name = 'aimr830.out'
    #CALL cl_outnam('aimr830') RETURNING l_name
    #START REPORT r830_rep TO l_name
    #MOD-720046 By TSD.Jin--end mark
     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR
     FOR g_i = 1 TO 80 LET g_star[g_i,g_i] = '*' END FOR
 
     LET g_pageno = 0
     FOREACH r830_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
      #MOD-720046 By TSD.Jin--start mark
      #FOR g_i = 1 TO 3
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pia01
      #                                 LET l_orderA[g_i] =g_x[51]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pia03
      #                                 LET l_orderA[g_i] =g_x[52]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pia04
      #                                 LET l_orderA[g_i] =g_x[53]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pia05
      #                                 LET l_orderA[g_i] =g_x[54]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pia02
      #                                 LET l_orderA[g_i] =g_x[55]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pia51
      #                                 LET l_orderA[g_i] =g_x[56]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pia61
      #                                 LET l_orderA[g_i] =g_x[57]    #TQC-6A0088
      #        OTHERWISE LET l_order[g_i] = '-'
      #                                 LET l_orderA[g_i] =''    #TQC-6A0088
 
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
      #MOD-720046 By TSD.Jin--end mark
       IF sr.pia03 IS NULL THEN LET sr.pia03 = ' ' END IF
       IF sr.pia04 IS NULL THEN LET sr.pia04 = ' ' END IF
       IF sr.pia05 IS NULL THEN LET sr.pia05 = ' ' END IF
       SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.pia64
       SELECT gen02 INTO sr.gen02_pia51 FROM gen_file WHERE gen01 = sr.pia51
       SELECT gen02 INTO sr.gen02_pia61 FROM gen_file WHERE gen01 = sr.pia61
 
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r830_rep(sr.*)  #MOD-720046 By TSD.Jin mark
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.pia01, sr.pia02, sr.pia03, sr.pia04, sr.pia05,
          sr.pia08, sr.pia50, sr.pia51, sr.pia54, sr.pia55,
          sr.pia60, sr.pia61, sr.pia64, sr.pia65, sr.ima02,
          sr.ima021,sr.gen02_1,sr.gen02_2,sr.gen02_pia51,sr.gen02_pia61,
          g_azi03,g_azi04,g_azi05
      #MOD-720046 By TSD.Jin--end
     END FOREACH
 
    #MOD-720046 By TSD.Jin--start
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pia01,pia03,pia04,pia05,pia02,pia51,pia61,pia931')         #FUN-930122 Add pia931
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s,";",tm.t
 
     CALL cl_prt_cs3('aimr830','aimr830',l_sql,g_str)   #FUN-710080 modify
 
    #FINISH REPORT r830_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #MOD-720046 By TSD.Jin--end
END FUNCTION
 
#MOD-720046 By TSD.Jin--start mark
#REPORT r830_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
#          sr           RECORD order1  LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              order2  LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              order3  LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                              pia01   LIKE pia_file.pia01,
#                              pia02   LIKE pia_file.pia02,
#                              pia03   LIKE pia_file.pia03,
#                              pia04   LIKE pia_file.pia04,
#                              pia05   LIKE pia_file.pia05,
#                              pia08   LIKE pia_file.pia08,
#                              pia50   LIKE pia_file.pia50,
#                              pia51   LIKE pia_file.pia51,
#                              pia54   LIKE pia_file.pia54,
#                              pia55   LIKE pia_file.pia55,
#                              pia60   LIKE pia_file.pia60,
#                              pia61   LIKE pia_file.pia61,
#                              pia64   LIKE pia_file.pia64,
#                              pia65   LIKE pia_file.pia65, 
#                              ima02   LIKE ima_file.ima02,
#                              ima021  LIKE ima_file.ima021,
#                              gen02_1 LIKE gen_file.gen02,
#                              gen02_2 LIKE gen_file.gen02,
#                              gen02_pia51 LIKE gen_file.gen02,
#                              gen02_pia61 LIKE gen_file.gen02
#                       END RECORD,
#      l_diff       LIKE pia_file.pia50,
#      l_str        LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(13)
#      l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.pia01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
##     PRINT            #TQC-6A0088
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
#      PRINTX name=H3 g_x[49],g_x[50]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   ON EVERY ROW
#      IF sr.pia50 IS NULL OR sr.pia50 = ' ' THEN 
#         LET l_str    ='***************'
#      END IF
#      IF sr.pia60 IS NULL OR sr.pia60 = ' ' THEN 
#         LET l_str    ='***************'
#      END IF
#      LET l_diff = sr.pia50 - sr.pia60
#      PRINTX name=D1 COLUMN g_c[31],sr.pia01,
#                     COLUMN g_c[32],sr.pia02,
#                     COLUMN g_c[33],sr.pia03,
#                     COLUMN g_c[34],sr.pia04,
#                     COLUMN g_c[35],cl_numfor(sr.pia08,35,3),
#                     COLUMN g_c[36],sr.pia51,
#                     COLUMN g_c[37],sr.gen02_pia51;
#            IF sr.pia50 IS NOT NULL AND sr.pia50 != ' ' THEN
#                PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr.pia50,38,3);
#            ELSE 
#                PRINTX name=D1 COLUMN g_c[38],g_q_point[1,g_w[38]];
#            END IF
#            IF l_diff IS NULL OR l_diff = ' ' THEN 
#               PRINTX name=D1 COLUMN g_c[39],g_star[1,g_w[39]], #l_str
#                              COLUMN g_c[40],sr.gen02_1
#            ELSE 
#               PRINTX name=D1 COLUMN g_c[39],cl_numfor(l_diff,39,3),
#                              COLUMN g_c[40],sr.gen02_1
#            END IF
# 
#      PRINTX name=D2 COLUMN g_c[41],' ',
#                     COLUMN g_c[42],sr.ima02,
#                     COLUMN g_c[43],sr.pia05,
#                     COLUMN g_c[44],sr.pia61,
#                     COLUMN g_c[45],sr.gen02_pia61;
#            IF sr.pia60 IS NOT NULL AND sr.pia60 != ' ' THEN
#                PRINTX name=D2 COLUMN g_c[46],cl_numfor(sr.pia60,46,3);
#            ELSE 
#                PRINTX name=D2 COLUMN g_c[46],g_q_point[1,g_w[46]];
#            END IF
#      PRINTX name=D2 COLUMN g_c[47],sr.pia55,
#                     COLUMN g_c[48],sr.pia54
#      PRINTX name=D3 COLUMN g_c[49],' ',
#                     COLUMN g_c[50],sr.ima021
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pia01,pia03,pia04,pia05,pia02,pia51,pia61')
#              RETURNING tm.wc
#         PRINT g_dash
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#MOD-720046 By TSD.Jin--end mark
