# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr898.4gl
# Descriptions...: 盤盈虧彙總表
# Date & Author..: 95/06/07 by Roger
# Modify...........dbo.No:7597 03/07/14 By mandy pia03 /pia04 宣告時是用char(4).., 應用 like pia_file.pia03
# Modify.........:No.B012 04/01/12 Kammy 1.盤點量要跟 pia08比較，而非img10/imk09
#                                        2.畫面上"庫存結存年月"拿掉
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/04/03 MOD-720046 By TSD.Jin 改為Crystal Report
# Modify.........: No.FUN-930121 09/04/13 By zhaijie新增查詢字段pia931-底稿類型
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C40001 12/04/01 By SunLM chr1000--->STRING

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           #wc      LIKE type_file.chr1000,  #No.FUN-690026 VARCHAR(500)
           wc      STRING,                  #TQC-C40001
           yy,mm   LIKE type_file.num5,     #No.FUN-690026 SMALLINT
           z,a,b,c,d,e,f,g,h,w LIKE type_file.chr1,         #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
           END RECORD 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
 
#070403 MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#070403 MOD-720046 By TSD.Jin--end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#070403 MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " pia01.pia_file.pia01, ",
               " pia02.pia_file.pia02, ",
               " pia03.pia_file.pia03, ",
               " pia04.pia_file.pia04, ",
               " pia05.pia_file.pia05, ",
               " pia09.pia_file.pia09, ",
               " pia30.pia_file.pia30, ",
               " ima02.ima_file.ima02, ",
               " ima021.ima_file.ima021,",
               " ima06.ima_file.ima06, ",
               " ima09.ima_file.ima09, ",
               " ima10.ima_file.ima10, ",
               " ima11.ima_file.ima11, ",
               " ima12.ima_file.ima12, ",
               " ima131.ima_file.ima131,",
               " img10.img_file.img10, ",
               " diff1.pia_file.pia30, ",
               " diff2.pia_file.pia30, ",
               " l_pia02.type_file.chr1000,",
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05  " 
 
   LET l_table = cl_prt_temptable('aimr898',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?) "
  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#070403 MOD-720046 By TSD.Jin--end
 
  #TQC-610072-begin 
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
  #LET g_bgjob = 'N'
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
  #LET g_copies = 1
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.d  = ARG_VAL(13)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)
   LET tm.g  = ARG_VAL(14)
   LET tm.h  = ARG_VAL(15)
   LET tm.w  = ARG_VAL(16)
   LET tm.z  = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(14)
   #LET g_rep_clas = ARG_VAL(15)
   #LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r898_tm(0,0)        
      ELSE CALL r898()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r898_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 11 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 2 LET p_col = 11
   END IF
 
   OPEN WINDOW r898_w AT p_row,p_col
        WITH FORM "aim/42f/aimr898" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.z    = 'N'
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'N'
   LET tm.e    = '0'
   LET tm.f    = 'N'
   LET tm.g    = 'Y'
   LET tm.h    = '5'
   LET tm.w    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima131,pia05,pia04,pia931,pia02,pia03,pia01  #FUN-930121 add pia931
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r898_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME #tm.yy,tm.mm, #No:B012 mark
                 tm.e,tm.h,tm.z,tm.b,
                 tm.d,tm.g,tm.a,tm.c,tm.f,tm.w,tm.more  
		WITHOUT DEFAULTS   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()  
#     ON ACTION CONTROLP CALL r898_wc()  
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
      LET INT_FLAG = 0 
      CLOSE WINDOW r898_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aimr898'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr898','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         #TQC-610072-begin
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",tm.z CLIPPED,"'",
                         #TQC-610072-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr898',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r898_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r898()
   ERROR ""
END WHILE
   CLOSE WINDOW r898_w
END FUNCTION
 
FUNCTION r898()
DEFINE l_name    LIKE type_file.chr20  # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0074
#DEFINE l_sql     LIKE type_file.chr1000# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
DEFINE l_sql     STRING                #TQC-C40001
DEFINE l_za05    LIKE za_file.za05     #No.FUN-690026 VARCHAR(40)
DEFINE l_pia40   LIKE pia_file.pia40   #No.B481 add
DEFINE l_pia50   LIKE pia_file.pia50   #No.B481 add
DEFINE l_pia60   LIKE pia_file.pia60   #No.B481 add
DEFINE sr        RECORD ima131  LIKE ima_file.ima131,#No:7597
                        pia02   LIKE pia_file.pia02, #No:7597
                        ima02   LIKE ima_file.ima02, #No:7597
                        ima021  LIKE ima_file.ima021,#FUN-510017
                        pia09   LIKE pia_file.pia09, #No:7597
                        pia05   LIKE pia_file.pia05, #No:7597
                        pia03   LIKE pia_file.pia03, #No:7597
                        pia04   LIKE pia_file.pia04, #No:7597
                        pia01   LIKE pia_file.pia01, #No:7597
                        img10   LIKE img_file.img10, #No:7597  
                        pia30   LIKE pia_file.pia30, #No:7597
                        diff1   LIKE pia_file.pia30, #MOD-530179
                        diff2   LIKE pia_file.pia30, #MOD-530179
                        ima06   LIKE ima_file.ima06, #No:7597
                        ima09   LIKE ima_file.ima09, #No:7597
                        ima10   LIKE ima_file.ima10, #No:7597
                        ima11   LIKE ima_file.ima11, #No:7597
                        ima12   LIKE ima_file.ima12  #No:7597
                 END RECORD
 
#070403 MOD-720046 By TSD.Jin--start
   DEFINE l_pia02       LIKE type_file.chr1000  #CHAR(100)
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr898'
#070403 MOD-720046 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima131, pia02, ima02,ima021, pia09, pia05, pia03,", #FUN-510017 add ima021
                #"       pia04, pia01, img10, pia30, 0,0,", #No:B012
                 "       pia04, pia01, pia08, pia30, 0,0,", #No.B012
               # "       ima06,ima09,ima10,ima11,ima12",   #No.B481
                 "       ima06,ima09,ima10,ima11,ima12,pia40,pia50,pia60 ",
                 "  FROM pia_file, ima_file, OUTER img_file",
                 " WHERE pia02=ima01",
                 "   AND pia_file.pia02=img_file.img01 AND pia_file.pia03=img_file.img02",
                 "   AND pia_file.pia04=img_file.img03 AND pia_file.pia05=img_file.img04",
                 "   AND ", tm.wc CLIPPED
     PREPARE r898_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r898_curs1 CURSOR FOR r898_prepare1
 
    #070403 MOD-720046 By TSD.Jin--start mark
    #CALL cl_outnam('aimr898') RETURNING l_name
 
    #START REPORT r898_rep TO l_name
    #070403 MOD-720046 By TSD.Jin--end mark
 
     LET g_pageno = 0
     FOREACH r898_curs1 INTO sr.*,l_pia40,l_pia50,l_pia60
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No:B012
#      IF tm.yy IS NOT NULL AND tm.mm IS NOT NULL THEN
#         SELECT imk09 INTO sr.img10 FROM imk_file
#                WHERE imk01=sr.pia02
#                  AND imk02=sr.pia03
#                  AND imk03=sr.pia04
#                  AND imk04=sr.pia05
#                  AND imk05=tm.yy
#                  AND imk06=tm.mm
#      END IF
#No:B012(end)
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
       #No.B481 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
       IF not cl_null(l_pia60)  THEN 
          LET sr.pia30 = l_pia60 
       ELSE
          IF NOT cl_null(l_pia50) THEN
             LET sr.pia30=l_pia50
          ELSE
             IF NOT cl_null(l_pia40) THEN
                LET sr.pia30 = l_pia40
             END IF
          END IF
       END IF
       #No.B480 end---
       CASE WHEN tm.h='0' LET sr.ima131=sr.ima06
            WHEN tm.h='1' LET sr.ima131=sr.ima09
            WHEN tm.h='2' LET sr.ima131=sr.ima10
            WHEN tm.h='3' LET sr.ima131=sr.ima11
            WHEN tm.h='4' LET sr.ima131=sr.ima12
            OTHERWISE     LET sr.ima131=sr.ima131
       END CASE
       IF tm.z='N' THEN LET sr.pia02=' ' END IF
       IF tm.a='N' THEN LET sr.pia05=' ' END IF
       IF tm.b='N' THEN LET sr.pia03=' ' END IF
       IF tm.c='N' THEN LET sr.pia04=' ' END IF
       IF tm.a='N' OR tm.b='N' OR tm.c='N' THEN LET sr.pia01=' ' END IF
       IF tm.d='N' AND sr.img10=sr.pia30 THEN CONTINUE FOREACH END IF
       IF sr.img10 > sr.pia30
          THEN LET sr.diff2=sr.img10-sr.pia30 LET sr.diff1=0
          ELSE LET sr.diff1=sr.pia30-sr.img10 LET sr.diff2=0
       END IF
 
      #070403 MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r898_rep(sr.*)
       LET l_pia02 = NULL
       IF NOT cl_null(sr.pia02) THEN
          LET l_pia02 = sr.pia02 CLIPPED
       END IF
       IF NOT cl_null(sr.pia05) THEN 
          IF cl_null(l_pia02) THEN
             LET l_pia02 = sr.pia05 CLIPPED
          ELSE
             LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia05 CLIPPED
          END IF
       END IF
       IF NOT cl_null(sr.pia03) THEN
          IF cl_null(l_pia02) THEN
             LET l_pia02 = sr.pia03 CLIPPED
          ELSE
             LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia03 CLIPPED
          END IF
       END IF
       IF NOT cl_null(sr.pia04) THEN
          IF cl_null(l_pia02) THEN
             LET l_pia02 = sr.pia04 CLIPPED
          ELSE
             LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia04 CLIPPED
          END IF
       END IF
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.pia01,sr.pia02,sr.pia03,sr.pia04, sr.pia05,
          sr.pia09,sr.pia30,sr.ima02,sr.ima021,sr.ima06,
          sr.ima09,sr.ima10,sr.ima11,sr.ima12, sr.ima131,
          sr.img10,sr.diff1,sr.diff2,l_pia02,  g_azi03,
          g_azi04, g_azi05
      #070403 MOD-720046 By TSD.Jin--end  
     END FOREACH
 
    #070403 MOD-720046 By TSD.Jin--start
    #FINISH REPORT r898_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima131,pia05,pia04,pia931,pia02,pia03,pia01')  #FUN-930121 add pia931
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.d,";",tm.e,";",tm.f,";",tm.g,";",tm.w
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     CALL cl_prt_cs3('aimr898','aimr898',l_sql,g_str)
    #070403 MOD-720046 By TSD.Jin--end  
END FUNCTION
 
#070403 MOD-720046 By TSD.Jin--start mark
#REPORT r898_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#DEFINE l_pia02      LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(100)
#DEFINE tot1,tot2,tot3,tot4  LIKE img_file.img10     #MOD-530179
#DEFINE sr        RECORD ima131  LIKE ima_file.ima131,#No:7597
#                        pia02   LIKE pia_file.pia02, #No:7597
#                        ima02   LIKE ima_file.ima02, #No:7597
#                        ima021  LIKE ima_file.ima021,#FUN-510017
#                        pia09   LIKE pia_file.pia09, #No:7597
#                        pia05   LIKE pia_file.pia05, #No:7597
#                        pia03   LIKE pia_file.pia03, #No:7597
#                        pia04   LIKE pia_file.pia04, #No:7597
#                        pia01   LIKE pia_file.pia01, #No:7597
#                        img10   LIKE img_file.img10, #No:7597  
#                        pia30   LIKE pia_file.pia30, #No:7597
#                        diff1   LIKE pia_file.pia30, #MOD-530179
#                        diff2   LIKE pia_file.pia30, #MOD-530179
#                        ima06   LIKE ima_file.ima06, #No:7597
#                        ima09   LIKE ima_file.ima09, #No:7597
#                        ima10   LIKE ima_file.ima10, #No:7597
#                        ima11   LIKE ima_file.ima11, #No:7597
#                        ima12   LIKE ima_file.ima12  #No:7597
#                        END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ima131,sr.pia02,sr.pia05,sr.pia03,sr.pia04,sr.pia01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
#      PRINT ' '
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINTX name=H2 g_x[38],g_x[39]
#      PRINTX name=H3 g_x[40],g_x[41]
#      PRINT g_dash1 
#      LET l_last_sw = 'n'
# 
#   AFTER GROUP OF sr.pia01
#{
#   分類            品號         單位     現有存量          盤點數量           盤盈量            盤虧量
#---------- -------------------- ---- ----------------- ----------------- ----------------- -----------------
#ima131     pia02                ia09 img10             pia30             diff1             diff2
#}
#      LET tot1 = GROUP SUM(sr.img10) USING '------------&.&&&'
#      LET tot2 = GROUP SUM(sr.pia30) USING '------------&.&&&'
#      LET tot3 = GROUP SUM(sr.diff1) USING '------------&.&&&'
#      LET tot4 = GROUP SUM(sr.diff2) USING '------------&.&&&'
#      IF tot3 > tot4
#         THEN LET tot3 = tot3 - tot4 LET tot4=0
#         ELSE LET tot4 = tot4 - tot3 LET tot3=0
#      END IF
#      IF tm.d='N' AND tot3=tot4 THEN 
#          LET tot3=0 
#      ELSE
#          #LET l_pia02 = sr.pia02 CLIPPED,' ',sr.pia05 CLIPPED,' ',
#          #              sr.pia03 CLIPPED,' ',sr.pia04 CLIPPED
#          #No:7597
#          LET l_pia02 = NULL
#          IF NOT cl_null(sr.pia02) THEN
#              LET l_pia02 = sr.pia02 CLIPPED
#          END IF
#          IF NOT cl_null(sr.pia05) THEN 
#              IF cl_null(l_pia02) THEN
#                  LET l_pia02 = sr.pia05 CLIPPED
#              ELSE
#                  LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia05 CLIPPED
#              END IF
#          END IF
#          IF NOT cl_null(sr.pia03) THEN
#              IF cl_null(l_pia02) THEN
#                  LET l_pia02 = sr.pia03 CLIPPED
#              ELSE
#                  LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia03 CLIPPED
#              END IF
#          END IF
#          IF NOT cl_null(sr.pia04) THEN
#              IF cl_null(l_pia02) THEN
#                  LET l_pia02 = sr.pia04 CLIPPED
#              ELSE
#                  LET l_pia02 = l_pia02 CLIPPED,' ',sr.pia04 CLIPPED
#              END IF
#          END IF
#          ##
# 
#          PRINTX name=D1 COLUMN g_c[31],sr.ima131,
#                         COLUMN g_c[32],l_pia02 CLIPPED, #FUN-5B0014[1,30],
#                         COLUMN g_c[33],sr.pia09,
#                         COLUMN g_c[34],cl_numfor(tot1,34,tm.e),
#                         COLUMN g_c[35],cl_numfor(tot2,35,tm.e),
#                         COLUMN g_c[36],cl_numfor(tot3,36,tm.e),
#                         COLUMN g_c[37],cl_numfor(tot4,37,tm.e)
#          IF tm.w='Y' THEN 
#              PRINTX name=D2 COLUMN g_c[38],' ',
#                             COLUMN g_c[39],sr.ima02 
#              PRINTX name=D3 COLUMN g_c[40],' ',
#                             COLUMN g_c[41],sr.ima021
#          END IF
#      END IF
#   AFTER GROUP OF sr.pia02
#      IF tm.f='Y' THEN
#          LET tot1 = GROUP SUM(sr.img10) USING '------------&.&&&'
#          LET tot2 = GROUP SUM(sr.pia30) USING '------------&.&&&'
#          LET tot3 = GROUP SUM(sr.diff1) USING '------------&.&&&'
#          LET tot4 = GROUP SUM(sr.diff2) USING '------------&.&&&'
#          IF tot3 > tot4 THEN
#              LET tot3 = tot3 - tot4 LET tot4=0
#          ELSE 
#              LET tot4 = tot4 - tot3 LET tot3=0
#          END IF
#          IF tm.d='N' AND tot3=tot4 THEN 
#              LET tot3=0 
#          ELSE
#              PRINT
#              PRINTX name=S1 COLUMN g_c[32],g_x[14] CLIPPED,
#                             COLUMN g_c[34],cl_numfor(tot1,34,tm.e),
#                             COLUMN g_c[35],cl_numfor(tot2,35,tm.e),
#                             COLUMN g_c[36],cl_numfor(tot3,36,tm.e),
#                             COLUMN g_c[37],cl_numfor(tot4,37,tm.e)
#              PRINT g_dash2
#          END IF
#      END IF
#   AFTER GROUP OF sr.ima131
#      IF tm.g='Y' THEN
#          LET tot1 = GROUP SUM(sr.img10) USING '------------&.&&&'
#          LET tot2 = GROUP SUM(sr.pia30) USING '------------&.&&&'
#          LET tot3 = GROUP SUM(sr.diff1) USING '------------&.&&&'
#          LET tot4 = GROUP SUM(sr.diff2) USING '------------&.&&&'
#          IF tot3 > tot4 THEN
#              LET tot3 = tot3 - tot4 LET tot4=0
#          ELSE 
#              LET tot4 = tot4 - tot3 LET tot3=0
#          END IF
#          IF tm.d='N' AND tot3=tot4 THEN 
#              LET tot3=0 
#          ELSE
#              IF tm.f='N' THEN 
#                  PRINT 
#              END IF
#              PRINTX name=S1 COLUMN g_c[32],g_x[15] CLIPPED,
#                             COLUMN g_c[34],cl_numfor(tot1,34,tm.e),
#                             COLUMN g_c[35],cl_numfor(tot2,35,tm.e),
#                             COLUMN g_c[36],cl_numfor(tot3,36,tm.e),
#                             COLUMN g_c[37],cl_numfor(tot4,37,tm.e)
#              PRINT g_dash2
#          END IF
#      END IF
# 
#   ON LAST ROW
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      PRINT g_dash
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#END REPORT
#070403 MOD-720046 By TSD.Jin--end mark
