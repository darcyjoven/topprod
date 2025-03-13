# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr650.4gl
# Descriptions...: 料件儲位進耗存日報表列印作業
# Date & Author..: 95/07/16 By Roger
#                  SQL 中之 tlf10 改為 tlf10*tlf12 (單位換算)
# Modify.........: 01-04-06 BY ANN CHEN B310 多選項期間無異動的是否列印
# Modify ........: No.FUN-4A0045 04/10/07 By Echo 料件編號, 倉庫編號開窗
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630187 06/03/17 By Claire 邏輯錯誤
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-710079 07/01/26 By pengu 當條件只勾選-只列印料件品名時,報表之品名規格沒有印出
# Modify.........: No.MOD-720046 07/03/14 By TSD.doris 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-830060 08/03/31 By lumx 修改MOD-720046的問題
# Modify.........: No.FUN-890129 08/12/28 By lilingyu mark cl_outnam()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A90068 10/09/09 By Summer r650_prepare2 cursor加上ORDER BY
# Modify.........: No:FUN-AC0091 10/12/28 By suncx 改用錯誤訊息統整(s_showmsg)的方式來取替cl_err
# Modify.........: No.TQC-B40108 11/04/15 By destiny tm.wc长度不够
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
          #wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500) #TQC-B40108
           wc      STRING,                 #TQC-B40108                          
           s       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           t       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           u       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           choice  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           bdate,edate LIKE type_file.dat,     #No.FUN-690026 DATE
           detail_flag LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           o       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           zero    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD,
       i,g_yy,g_mm      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       last_y,last_m	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       m_bdate	        LIKE type_file.dat      #No.FUN-690026 DATE
 
DEFINE g_chr            LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#CR11 add MOD-720046 by TSD.doris--------(S)--------
DEFINE l_table     STRING                        ### CR11 add ###
DEFINE g_sql       STRING                        ### CR11 add ###
DEFINE g_str       STRING                        ### CR11 add ###
#CR11 add MOD-720046 by TSD.doris--------(E)--------
 
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
 
   #CR11 add MOD-720046 by TSD.doris-----(S)-----
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "img01.img_file.img01,",
               "img04.img_file.img04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "img02.img_file.img02,",
               "img03.img_file.img03,",
               "img09.img_file.img09,",
               "ima25.ima_file.ima25,",
               "qty0.img_file.img10,",
               "qty1.img_file.img10,",
               "qty2.img_file.img10,",
               "qty3.img_file.img10,",
               "qty4.img_file.img10,",
               "img2ima_fac.ima_file.ima31_fac,",
               "qtyA.img_file.img10,",
               "qtyB.img_file.img10,",
               "qtyC.img_file.img10,",
               "qtyD.img_file.img10,",
               "qtyE.img_file.img10,",
               "qtyF.img_file.img10,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('aimr650',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #CR11 add MOD-720046 by TSD.doris-----(E)-----
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
   #TQC-610072-begin
   LET tm.detail_flag  = ARG_VAL(13)
   LET tm.o  = ARG_VAL(14)
   LET tm.zero  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r650_tm(0,0)
      ELSE CALL r650()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r650_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 10
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r650_w AT p_row,p_col
        WITH FORM "aim/42f/aimr650"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.detail_flag = 'Y'
   LET tm.o    = 'Y'
   LET tm.zero = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04,ima06,
                                 ima09,ima10,ima11,ima12,ima08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #### No.FUN-4A0045
         ON ACTION CONTROLP
             CASE
              WHEN INFIELD(img01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img01
                NEXT FIELD img01
 
              WHEN INFIELD(img02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img02
                NEXT FIELD img02
           END CASE
      ### END  No.FUN-4A0045
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r650_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.bdate,tm.edate,
                 tm.detail_flag,tm.o,tm.zero WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         LET g_yy=YEAR(tm.bdate)
         LET g_mm=MONTH(tm.bdate)
         IF tm.edate IS NULL THEN
            LET tm.edate = tm.bdate DISPLAY BY NAME tm.edate
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
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
      CLOSE WINDOW r650_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL s_azm(g_yy,g_mm) RETURNING g_chr,m_bdate,i
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr650'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr650','9031',1)
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
                        #TQC-610072-begin
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.detail_flag CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.zero CLIPPED,"'",
                        #TQC-610072-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr650',g_time,l_cmd)
      END IF
      CLOSE WINDOW r650_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r650()
   ERROR ""
END WHILE
   CLOSE WINDOW r650_w
END FUNCTION
 
FUNCTION r650()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
         #l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000) #TQC-B40108
          l_sql     STRING,                 #TQC-B40108 
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr        RECORD img01  LIKE img_file.img01,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           img02  LIKE img_file.img02,
                           img03  LIKE img_file.img03,
                           img04  LIKE img_file.img04,
                           img09  LIKE img_file.img09,
                           qty0   LIKE img_file.img10, #MOD-530179
                           qty1   LIKE img_file.img10, #MOD-530179
                           qty2   LIKE img_file.img10, #MOD-530179
                           qty3   LIKE img_file.img10, #MOD-530179
                           qty4   LIKE img_file.img10, #MOD-530179
                           ima25  LIKE ima_file.ima25,
                           img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
                    END RECORD,
          l_tlf     RECORD tlf021 LIKE tlf_file.tlf021,
                           tlf022 LIKE tlf_file.tlf022,
                           tlf023 LIKE tlf_file.tlf023,
                           tlf024 LIKE tlf_file.tlf024,
                           tlf031 LIKE tlf_file.tlf031,
                           tlf032 LIKE tlf_file.tlf032,
                           tlf033 LIKE tlf_file.tlf033,
                           tlf034 LIKE tlf_file.tlf034,
                           tlf06  LIKE tlf_file.tlf06  #No.FUN-690026 DATE
                    END RECORD
 
     #CR11 add MOD-720046 by TSD.doris-----(S)----
     DEFINE l_qtyA,l_qtyB,l_qtyC,l_qtyD ,l_qtyE,l_qtyF  LIKE img_file.img10
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ------------------------------#
 
     #CR11 add MOD-720046 by TSD.doris-----(E)----
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
 
#     CALL cl_outnam('aimr650') RETURNING l_name   #FUN-890129
    # START REPORT r650_rep TO l_name 070315 BY TSD.doris
     LET g_pageno = 0
     MESSAGE "1. foreach imk_file ..."
     CALL ui.Interface.refresh()
     CALL s_showmsg_init()           #FUN-AC0091 add
     LET l_sql = "SELECT",
                 " img01, ima02,ima021, img02, img03, img04, img09,",
                 " imk09, 0, 0, 0, 0,ima25,1",
                 " FROM imk_file,img_file, ima_file",
                 " WHERE img01 = imk01 AND img02 = imk02",
                 "   AND img03 = imk03 AND img04 = imk04",
                 "   AND img01 = ima01",
                 "   AND ", tm.wc CLIPPED,
                 "   AND imk05=",last_y," AND imk06=",last_m
     PREPARE r650_prepare1 FROM l_sql
     IF STATUS THEN  #CALL cl_err('prepare1:',STATUS,1)   #FUN-AC0091 mark
        CALL s_errmsg('','','prepare1:',STATUS,1)         #FUN-AC0091 add
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r650_curs1 CURSOR FOR r650_prepare1
     FOREACH r650_curs1 INTO sr.*
       #IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF    #FUN-AC0091 mark
       IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,1) EXIT FOREACH END IF   #FUN-AC0091 add  
## No:2668 modify 1998/10/28 ---------------
       IF sr.img09<>sr.ima25
          THEN
          CALL s_umfchk(sr.img01,sr.img09,sr.ima25)
               RETURNING g_i,sr.img2ima_fac
          IF g_i = 1 THEN
             #CALL cl_err(sr.img01,'mfg3075',1)           #FUN-AC0091 mark
             CALL s_errmsg('img01',sr.img01,'','mfg3075',1)    #FUN-AC0091 add
             #TQC-630187-begin
             #EXIT FOREACH
             CONTINUE FOREACH
             #TQC-630187-end
          END IF
       END IF
## --
       #MOD-720046 by TSD.doris-----------(S)------------
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
            LET l_qtyA = sr.qty0+sr.qty1-sr.qty2
            LET l_qtyB = sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4
            LET l_qtyC = (sr.qty0+sr.qty1-sr.qty2)*sr.img2ima_fac
            LET l_qtyD = sr.qty3*sr.img2ima_fac
            LET l_qtyE = sr.qty4*sr.img2ima_fac
            LET l_qtyF = (sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4)*sr.img2ima_fac
            EXECUTE insert_prep USING
               sr.img01,sr.img04,sr.ima02,sr.ima021,sr.img02,
               sr.img03,sr.img09,sr.ima25,sr.qty0,sr.qty1,
               sr.qty2,sr.qty3,sr.qty4,sr.img2ima_fac,l_qtyA,
               l_qtyB,l_qtyC,l_qtyD,l_qtyE,l_qtyF,g_azi03,g_azi04,
               g_azi05
       #MOD-720046 by TSD.doris-----------(E)------------
 
       #OUTPUT TO REPORT r650_rep(sr.*) #070315 by TSD.doris
     END FOREACH
#--------------------------------------------------------------------
     MESSAGE "2. foreach tlf_file ..."
     CALL ui.Interface.refresh()
     LET l_sql = "SELECT",
                 " img01, ima02,ima021, img02, img03, img04, img09,",
##               " tlf10*tlf12, 0, 0, 0, 0,",
                 " tlf10*tlf12, 0, 0, 0, 0, ima25, 1,",
                 " tlf021,tlf022,tlf023,tlf024,",
                 " tlf031,tlf032,tlf033,tlf034,",
                 " tlf06",
                 " FROM img_file, tlf_file, ima_file",
                 " WHERE img01=tlf01 AND img01=ima01",
                 "   AND ((img02=tlf021 AND img03=tlf022 AND img04=tlf023 ",
                 "   AND  tlf907=-1 ) ",  #入出庫碼 (1:入庫 -1:出庫 0:其它
                 "     OR (img02=tlf031 AND img03=tlf032 AND img04=tlf033 ",
                 "   AND  tlf907=1)) ",    #入出庫碼 (1:入庫 -1:出庫 0:其它
                 "   AND ", tm.wc CLIPPED,
                 "   AND tlf06 BETWEEN '",m_bdate,"' AND '",tm.edate,"'", #MOD-A90068 add ,
                 " ORDER BY img01,img02,img03,img04 " #MOD-A90068 add
## No:2799 modify 1998/11/18 ---------------
## -----------------------------------------
     PREPARE r650_prepare2 FROM l_sql
     IF STATUS THEN #CALL cl_err('prepare2:',STATUS,1)    #FUN-AC0091 mark 
        CALL s_errmsg('','','prepare2:',STATUS,1)         #FUN-AC0091 add
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r650_curs2 CURSOR FOR r650_prepare2
     FOREACH r650_curs2 INTO sr.*, l_tlf.*
       #IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF   #FUN-AC0091 mark
       IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,1) EXIT FOREACH END IF   #FUN-AC0091 add  
## No:2668 modify 1998/10/28 ---------------
       IF sr.img09<>sr.ima25
          THEN
          CALL s_umfchk(sr.img01,sr.img09,sr.ima25)
               RETURNING g_i,sr.img2ima_fac
          IF g_i = 1 THEN
             #CALL cl_err(sr.img01,'mfg3075',1)    #FUN-AC0091 mark
             CALL s_errmsg('img01',sr.img01,'','mfg3075',1)    #FUN-AC0091 add
             #TQC-630187-begin
             #EXIT FOREACH
             CONTINUE FOREACH
             #TQC-630187-end
          END IF
       END IF
## --
       IF l_tlf.tlf021 = sr.img02 AND l_tlf.tlf022 = sr.img03 AND
          l_tlf.tlf023 = sr.img04 THEN
          IF l_tlf.tlf06 < tm.bdate
             THEN LET sr.qty2=sr.qty0
             ELSE LET sr.qty4=sr.qty0
          END IF
          LET sr.qty0=0
## No:B310 Modify BY ANN CHEN 010406
      #   IF tm.zero='N' AND sr.qty4=0 THEN   #No.+337 mark
      #      CONTINUE FOREACH
      #   END IF
## No:B310 END
          #MOD-720046 by TSD.doris-----------(S)------------
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               LET l_qtyA = sr.qty0+sr.qty1-sr.qty2
               LET l_qtyB = sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4
               LET l_qtyC = (sr.qty0+sr.qty1-sr.qty2)*sr.img2ima_fac
               LET l_qtyD = sr.qty3*sr.img2ima_fac
               LET l_qtyE = sr.qty4*sr.img2ima_fac
               LET l_qtyF = (sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4)*sr.img2ima_fac
               EXECUTE insert_prep USING
                  sr.img01,sr.img04,sr.ima02,sr.ima021,sr.img02,
                  sr.img03,sr.img09,sr.ima25,sr.qty0,sr.qty1,
                  sr.qty2,sr.qty3,sr.qty4,sr.img2ima_fac,l_qtyA,
                  l_qtyB,l_qtyC,l_qtyD,l_qtyE,l_qtyF,g_azi03,g_azi04,
                  g_azi05
 
          #MOD-720046 by TSD.doris-----------(E)------------
 
         # OUTPUT TO REPORT r650_rep(sr.*) #MOD-720046 by TSD.doris
       END IF
       IF l_tlf.tlf031 = sr.img02 AND l_tlf.tlf032 = sr.img03 AND
          l_tlf.tlf033 = sr.img04 THEN
          IF l_tlf.tlf06 < tm.bdate
             THEN LET sr.qty1=sr.qty0
             ELSE LET sr.qty3=sr.qty0
          END IF
          LET sr.qty0=0
## No:B310 Modify BY ANN CHEN 010406
       #  IF tm.zero='N' AND sr.qty3=0 THEN   #No.+337 mark
       #     CONTINUE FOREACH
       #  END IF
## No:B310 END
          #MOD-720046 by TSD.doris-----------(S)------------
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               LET l_qtyA = sr.qty0+sr.qty1-sr.qty2
               LET l_qtyB = sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4
               LET l_qtyC = (sr.qty0+sr.qty1-sr.qty2)*sr.img2ima_fac
               LET l_qtyD = sr.qty3*sr.img2ima_fac
               LET l_qtyE = sr.qty4*sr.img2ima_fac
               LET l_qtyF = (sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4)*sr.img2ima_fac
               EXECUTE insert_prep USING
                  sr.img01,sr.img04,sr.ima02,sr.ima021,sr.img02,
                  sr.img03,sr.img09,sr.ima25,sr.qty0,sr.qty1,
                  sr.qty2,sr.qty3,sr.qty4,sr.img2ima_fac,l_qtyA,
                  l_qtyB,l_qtyC,l_qtyD,l_qtyE,l_qtyF,g_azi03,g_azi04,
                  g_azi05
 
          #MOD-720046 by TSD.doris-----------(E)------------
 
         # OUTPUT TO REPORT r650_rep(sr.*) 070315 by TSD.doris
       END IF
     END FOREACH
#--------------------------------------------------------------------
     #FINISH REPORT r650_rep #070315 BY TSD.doris
 
     #CR11 add MOD-720046 by TSD.doris-----(S)------
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify 
     #是否列印選擇條件
 
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,ima06,ima09,ima10,ima11,ima12,ima08')
             RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",
                 tm.bdate,";",tm.edate,";",tm.detail_flag,";",tm.o,";",tm.zero
     CALL cl_prt_cs3('aimr650','aimr650',l_sql,g_str)   #FUN-710080 modify
     CALL s_showmsg()   #FUN-AC0091 add
     #------------------------------ CR (4) ------------------------------#
     #CR11 add MOD-720046 by TSD.doris-----(E)------
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len) 070315 by TSD.doris
END FUNCTION
##TQC-830060---begin---
#REPORT r650_rep(sr)
#   DEFINE l_str	       LIKE zaa_file.zaa08    #No.FUN-690026 VARCHAR(20)
#   DEFINE l_qty3       LIKE img_file.img10,   #No.+337 add #MOD-530179
#          l_qty4       LIKE img_file.img10    #No.+337 add #MOD-530179
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr           RECORD img01  LIKE img_file.img01,
#                              ima02  LIKE ima_file.ima02,
#                              ima021 LIKE ima_file.ima021,
#                              img02  LIKE img_file.img02,
#                              img03  LIKE img_file.img03,
#                              img04  LIKE img_file.img04,
#                              img09  LIKE img_file.img09,
#                              qty0   LIKE img_file.img10, #MOD-530179
#                              qty1   LIKE img_file.img10, #MOD-530179
#                              qty2   LIKE img_file.img10, #MOD-530179
#                              qty3   LIKE img_file.img10, #MOD-530179
#                              qty4   LIKE img_file.img10, #MOD-530179
#                              ima25  LIKE ima_file.ima25,
#                              img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
#                        END RECORD
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.img01,sr.img04,sr.img02,sr.img03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[12] CLIPPED,tm.bdate,'-',tm.edate
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
#           ,g_x[40],g_x[41]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   AFTER GROUP OF sr.img03
#      IF tm.o <> 'Y' THEN
#          LET sr.ima02 = NULL
#          LET sr.ima021 = NULL
#      END IF
#      IF tm.detail_flag = 'Y' THEN
#          LET l_qty3 = GROUP SUM(sr.qty3)
#          LET l_qty4 = GROUP SUM(sr.qty4)
#          IF tm.zero='Y' OR (tm.zero='N' AND (l_qty3<>0 OR l_qty4 <>0 )) THEN
#              PRINTX name=D1 COLUMN g_c[31],sr.img01,
#                             COLUMN g_c[32],sr.img04,
#                             COLUMN g_c[33],sr.ima02,
#                            #COLUMN g_c[34],'規格56789012345678901234567END',
#                             COLUMN g_c[34],sr.ima021,
#                             COLUMN g_c[35],sr.img02,
#                             COLUMN g_c[36],sr.img03,
#                             COLUMN g_c[37],sr.img09,
#                             COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty0+sr.qty1-sr.qty2),38,3),
#                             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.qty3),39,3),
#                             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.qty4),40,3),
#                             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4),41,3)
#          END IF    #No.+337 add
#      END IF
#   AFTER GROUP OF sr.img01
#   LET l_str=''
#   #No.+337 010702 add by linda
#   LET l_qty3 = GROUP SUM(sr.qty3)
#   LET l_qty4 = GROUP SUM(sr.qty4)
#   IF tm.zero='Y' OR (tm.zero='N' AND (l_qty3<>0 OR l_qty4 <>0 )) THEN
#      #No.+337 end--
#      IF tm.detail_flag = 'Y' THEN LET l_str=g_x[16] CLIPPED END IF
#      IF tm.detail_flag = 'Y' THEN PRINT END IF
#      PRINT COLUMN g_c[31],sr.img01 CLIPPED,
#            COLUMN g_c[32],l_str CLIPPED,
#           #--------------No.MOD-710079 modify
#           #COLUMN g_c[33],' ',
#           #COLUMN g_c[34],' ',
#            COLUMN g_c[33],sr.ima02 CLIPPED,
#            COLUMN g_c[34],sr.ima021 CLIPPED,
#           #--------------No.MOD-710079 end
#            COLUMN g_c[37],sr.ima25,
#            COLUMN g_c[38],cl_numfor(GROUP SUM((sr.qty0+sr.qty1-sr.qty2)*sr.img2ima_fac),38,3),
#            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.qty3*sr.img2ima_fac),39,3),
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.qty4*sr.img2ima_fac),40,3),
#            COLUMN g_c[41],cl_numfor(GROUP SUM((sr.qty0+sr.qty1-sr.qty2+sr.qty3-sr.qty4)*sr.img2ima_fac),41,3)
#      PRINT g_dash2
#   END IF   #No.+337
# 
#   ON LAST ROW
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
#TQC-830060--end--
