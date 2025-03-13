# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: aimx610.4gl
# Descriptions...: 料件儲位庫存期報表列印作業
# Date & Author..: 93/06/16  By  Felicity  Tseng
# Modify ........: No.FUN-4A0046 04/10/07 By Echo 料件編號, 倉庫編號開窗
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510017 05/01/14 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-570315 05/07/22 By kim EXIT FOREACH 改為CONTINUE FOREACH
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 05/06/11 By kevin 結束位置調整
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/03/13 By TSD.Jin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-C70012 12/07/11 By suncx 新增倉庫選項
# Modify.........: No.FUN-CB0003 12/11/02 By chenjing CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By wangrr XtraGrid報表畫面檔上小計條件去除，4gl中并去除grup_sum_field
# Modify.........: No:FUN-D40129 13/05/07 By yangtt 1、WHERE條件錯誤 2、ima09,ima10,ima11,ima12新增開窗 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc           STRING,                 # Where Condition  #TQC-630166
           s            LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t            LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
          #u            LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03) #FUN-D30070 mark
           choice       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           yy           LIKE type_file.num10,   #No.FUN-690026 INTEGER
           m1           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           m2           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           detail_flag  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           a            LIKE type_file.chr1,    #CHI-C70012 add
           more         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD,
       last_y,last_m    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_orderA         ARRAY[3] OF LIKE ima_file.ima01 #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
 
DEFINE g_chr            LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
 
#MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#MOD-720046 By TSD.Jin--end
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
 
   #MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " img01.img_file.img01,  ",
               " img02.img_file.img02,  ",
               " img03.img_file.img03,  ",
               " img04.img_file.img04,  ",
               " imk081.imk_file.imk081,",
               " imk082.imk_file.imk082,",
               " imk084.imk_file.imk085,",
               " imk085.imk_file.imk085,",
               " imk09.imk_file.imk09,  ",
               " fresh.imk_file.imk09,  ",
               " ima02.ima_file.ima02,  ",
               " ima021.ima_file.ima021,",
               " ima06.ima_file.ima06,  ",
               " ima08.ima_file.ima08,  ",
               " ima09.ima_file.ima09,  ",
               " ima10.ima_file.ima10,  ",
               " ima11.ima_file.ima11,  ",
               " ima12.ima_file.ima12,  ",
               " ima25.ima_file.ima25,  ",
               " img09.img_file.img09,  ",
               " img2ima_fac.ima_file.ima31_fac,",
               " fresh_fac.imk_file.imk09,  ",
               " imk081_fac.imk_file.imk081,",
               " imk082_fac.imk_file.imk082,",
               " imk084_fac.imk_file.imk085,",
               " imk085_fac.imk_file.imk085,",
               " imk09_fac.imk_file.imk09,  ",
               " azi03.azi_file.azi03,  ",
               " azi04.azi_file.azi04,  ",
               " azi05.azi_file.azi05,  ",
        #FUN-CB0003--add--str--
               " imd02.imd_file.imd02,", 
               " ime03.ime_file.ime03 "
        #FUN-CB0003--add--end--     
 
   LET l_table = cl_prt_temptable('aimx610',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?) "   #FUN-CB0003 add 2?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #MOD-720046 By TSD.Jin--end
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.choice  = ARG_VAL(10)
   LET tm.yy  = ARG_VAL(11)
   LET tm.m1  = ARG_VAL(12)
   LET tm.m2  = ARG_VAL(13)
  #TQC-610072-begin
  #LET tm.u  = ARG_VAL(14) #FUN-D30070 mark
   LET tm.detail_flag  = ARG_VAL(14) #FUN-D30070 mod 15->14
   LET tm.a = ARG_VAL(15)   #CHI-C70012 #FUN-D30070 mod 16->15
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16) #FUN-D30070 mod 17->16
   LET g_rep_clas = ARG_VAL(17) #FUN-D30070 mod 18->17
   LET g_template = ARG_VAL(18) #FUN-D30070 mod 19->18
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078 #FUN-D30070 mod 20->19
   #No.FUN-570264 ---end---
  #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL x610_tm(0,0)
      ELSE CALL x610()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION x610_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 9
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW x610_w AT p_row,p_col
        WITH FORM "aim/42f/aimx610"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '142'
  #LET tm.u    = 'Y  ' #FUN-D30070 mark
   LET tm.choice = 0
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.detail_flag = 'Y'
   LET tm.a = '2'   #CHI-C70012
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
  #LET tm2.u1   = tm.u[1,1] #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2] #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3] #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF #FUN-D30070 mark
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
 
         #### No.FUN-4A0046
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
              
         #FUN-CB0003--add--str---
              WHEN INFIELD(img03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_img32"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img03
                NEXT FIELD img03 
  
              WHEN INFIELD(img04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_img041"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img04
                NEXT FIELD img04

              WHEN INFIELD(ima06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima06"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima06
                NEXT FIELD ima06

              WHEN INFIELD(ima08)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima7"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima08
                NEXT FIELD ima08
       #FUN-CB0003--add--end--
             #FUN-D40129-add-str--
              WHEN INFIELD(ima09)  #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_ima09_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima09
                  NEXT FIELD ima09
              WHEN INFIELD(ima10)   #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_ima10_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima10
                  NEXT FIELD ima10
              WHEN INFIELD(ima11)   #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_ima11_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima11
                  NEXT FIELD ima11
              WHEN INFIELD(ima12)  #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_ima12_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima12
                  NEXT FIELD ima12
             #FUN-D40129-add-end--
              END CASE
       ### END  No.FUN-4A0046
 
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
         CLOSE WINDOW x610_w
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
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3, #FUN-D30070 mark
                 tm.choice,tm.yy,tm.m1,tm.m2,
                 tm.detail_flag,tm.a,tm.more WITHOUT DEFAULTS    #CHI-C70012 add tm.a
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice NOT MATCHES "[0-4]" THEN
            NEXT FIELD choice
         END IF
 
      AFTER FIELD yy
         IF tm.yy <1900 THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#         IF tm.m1 <1 OR g_aza.aza02 = 1 AND tm.m1 >12 OR
#            (g_aza.aza02 = 2 AND tm.m1 >13 ) THEN
#            NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end --
         LET last_m=tm.m1-1
         IF last_m=0
            THEN LET last_y=tm.yy-1 LET last_m=12
            ELSE LET last_y=tm.yy
         END IF
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#         IF tm.m2 <1 OR g_aza.aza02 = 1 AND tm.m2 >12 OR
#            (g_aza.aza02 = 2 AND tm.m2 >13 ) THEN
#            NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
 
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070 mark
 
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
      CLOSE WINDOW x610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimx610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimx610','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'" ,
                        #" '",tm.u CLIPPED,"'" ,  #TQC-610072 #FUN-D30070 mark
                         " '",tm.detail_flag CLIPPED,"'" ,      #TQC-610072 
                         " '",tm.a CLIPPED,"'" ,                #CHI-C70012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimx610',g_time,l_cmd)
      END IF
      CLOSE WINDOW x610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x610()
   ERROR ""
END WHILE
   CLOSE WINDOW x610_w
END FUNCTION
 
FUNCTION x610()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                            # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           img01  LIKE img_file.img01,
                           img02  LIKE img_file.img02,
                           img03  LIKE img_file.img03,
                           img04  LIKE img_file.img04,
                           imk081 LIKE imk_file.imk081,
                           imk082 LIKE imk_file.imk082,
                           imk084 LIKE imk_file.imk085,
                           imk085 LIKE imk_file.imk085,
                           imk09  LIKE imk_file.imk09,
                           fresh  LIKE imk_file.imk09, #期初數量
                           ima02  LIKE ima_file.ima02, #FUN-510017
                           ima021 LIKE ima_file.ima021,#FUN-510017
                           ima06  LIKE ima_file.ima06,
                           ima08  LIKE ima_file.ima08,
                           ima09  LIKE ima_file.ima09,
                           ima10  LIKE ima_file.ima10,
                           ima11  LIKE ima_file.ima11,
                           ima12  LIKE ima_file.ima12,
                           ima25  LIKE ima_file.ima25,
                           img09  LIKE img_file.img09,
                           img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
                        END RECORD
 
#MOD-720046 By TSD.Jin--start
   DEFINE l_frech_fac    LIKE imk_file.imk09,
          l_imk081_fac   LIKE imk_file.imk081,
          l_imk082_fac   LIKE imk_file.imk082,
          l_imk084_fac   LIKE imk_file.imk084,
          l_imk085_fac   LIKE imk_file.imk085,
          l_imk09_fac    LIKE imk_file.imk09 
   DEFINE l_n LIKE type_file.num5
   DEFINE l_str  STRING
#FUN-CB0003--add--str--
   DEFINE l_ime03    LIKE ime_file.ime03,
          l_imd02    LIKE imd_file.imd02
#FUN-CB0003--add--end--
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#MOD-720046 By TSD.Jin--end
 
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
 
     LET l_sql = "SELECT '','','',",
                 " img01,img02,img03,img04,0,0,0,0,0,0,",
                 " ima02,ima021,ima06,ima08,ima09,ima10,ima11,ima12,ima25,", #FUN-510017 add ima021
                 " img09,1 ",
                 " FROM img_file,ima_file WHERE ima01=img01 AND ",
                 tm.wc CLIPPED
     PREPARE x610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE x610_curs1 CURSOR FOR x610_prepare1
    #MOD-720046 By TSD.Jin--start mark
    #CALL cl_outnam('aimx610') RETURNING l_name
    #START REPORT x610_rep TO l_name
    #MOD-720046 By TSD.Jin--end mark
     LET g_pageno = 0
     FOREACH x610_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #CHI-C70012 add begin-------------
          SELECT COUNT(*) INTO l_n FROM jce_file 
           WHERE jce02 = sr.img02
          CASE tm.a
             WHEN '0'
                IF l_n>0 THEN CONTINUE FOREACH END IF  
             WHEN '1'
                IF l_n<=0 THEN CONTINUE FOREACH END IF 
          END CASE 
          #CHI-C70012 add end---------------
## No:2669 modify 1998/10/28 ---------------
       IF sr.img09<>sr.ima25
       THEN CALL s_umfchk(sr.img01,sr.img09,sr.ima25)
                 RETURNING g_i,sr.img2ima_fac
            IF g_i = 1 THEN
               CALL cl_err(sr.img01,'mfg3075',1)
                #EXIT FOREACH    #MOD-570315 mark
                CONTINUE FOREACH #MOD-570315
            END IF
       END IF
## --
          SELECT imk09 INTO sr.imk09 FROM imk_file
           WHERE imk01=sr.img01 AND imk02=sr.img02
             AND imk03=sr.img03 AND imk04=sr.img04
             AND imk05=tm.yy    AND imk06=tm.m2
          SELECT sum(imk081),sum(imk082+imk083),sum(imk084),sum(imk085)
            INTO sr.imk081,sr.imk082,sr.imk084,sr.imk085
            FROM imk_file
           WHERE imk01=sr.img01 AND imk02=sr.img02
             AND imk03=sr.img03 AND imk04=sr.img04
             AND imk05=tm.yy    AND imk06 BETWEEN tm.m1 AND tm.m2
          IF cl_null(sr.imk081) THEN LET sr.imk081 = 0 END IF
          IF cl_null(sr.imk082) THEN LET sr.imk082 = 0 END IF
          IF cl_null(sr.imk084) THEN LET sr.imk084 = 0 END IF
          IF cl_null(sr.imk085) THEN LET sr.imk085 = 0 END IF
          IF cl_null(sr.imk09) THEN LET sr.imk09 = 0 END IF
          IF sr.imk081=0 AND sr.imk082=0 AND sr.imk084=0 AND sr.imk085=0 AND
             sr.imk09=0  THEN CONTINUE FOREACH END IF
          LET sr.fresh = sr.imk09-sr.imk081-sr.imk082-sr.imk084-sr.imk085
         #070315 By TSD.Jin--start mark
         #FOR g_i = 1 TO 3
         #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.img01
         #                                  LET g_orderA[g_i]= g_x[25]
         #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.img02
         #                                  LET g_orderA[g_i]= g_x[26]
         #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img03
         #                                  LET g_orderA[g_i]= g_x[27]
         #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img04
         #                                  LET g_orderA[g_i]= g_x[28]
         #         WHEN tm.s[g_i,g_i] = '5'
         #              CASE
         #     		 WHEN tm.choice ='0' LET l_order[g_i] = sr.ima06
         #                                   LET g_orderA[g_i]= g_x[29]
	 #       	 WHEN tm.choice ='1' LET l_order[g_i] = sr.ima09
         #                                   LET g_orderA[g_i]= g_x[30]
    	 #      	 WHEN tm.choice ='2' LET l_order[g_i] = sr.ima10
         #                                   LET g_orderA[g_i]= g_x[31]
	 #    	      	 WHEN tm.choice ='3' LET l_order[g_i] = sr.ima11
         #                                   LET g_orderA[g_i]= g_x[32]
	 #    		 WHEN tm.choice ='4' LET l_order[g_i] = sr.ima12
         #                                   LET g_orderA[g_i]= g_x[33]
         #              END CASE
         #         WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima08
         #                                  LET g_orderA[g_i]= g_x[34]
         #         OTHERWISE LET l_order[g_i]  = '-'
         #                   LET g_orderA[g_i] = ' '          #清為空白
         #    END CASE
         #END FOR
         #LET sr.order1 = l_order[1]
         #LET sr.order2 = l_order[2]
         #LET sr.order3 = l_order[3]
         #070315 By TSD.Jin--end mark
 
         #MOD-720046 By TSD.Jin--start
         #OUTPUT TO REPORT x610_rep(sr.*)     #MOD-720046 By TSD.Jin mark
 
         LET l_frech_fac = sr.fresh*sr.img2ima_fac
         LET l_imk081_fac= sr.imk081*sr.img2ima_fac
         LET l_imk082_fac= sr.imk082*sr.img2ima_fac
         LET l_imk084_fac= sr.imk084*sr.img2ima_fac
         LET l_imk085_fac= sr.imk085*sr.img2ima_fac
         LET l_imk09_fac = sr.imk09 *sr.img2ima_fac
     #FUN-CB0003--add--str--
         SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = sr.img02
        #SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime01 = sr.img03  #FUN-D40129 mark
         SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime02 = sr.img03  #FUN-D40129 add 
     #FUN-CB0003--add--end--
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
         EXECUTE insert_prep USING
            sr.img01, sr.img02, sr.img03, sr.img04, sr.imk081,
            sr.imk082,sr.imk084,sr.imk085,sr.imk09, sr.fresh,
            sr.ima02, sr.ima021,sr.ima06, sr.ima08, sr.ima09,
            sr.ima10, sr.ima11, sr.ima12, sr.ima25, sr.img09,
            sr.img2ima_fac,l_frech_fac,l_imk081_fac,l_imk082_fac,l_imk084_fac,
            l_imk085_fac,l_imk09_fac,g_azi03,g_azi04,g_azi05,l_imd02,l_ime03      #FUN-CB0003 add l_imd02,l_ime03 
         #MOD-720046 By TSD.Jin--end
     END FOREACH
 
    #MOD-720046 By TSD.Jin--start
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
###XtraGrid###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    #是否列印選擇條件
    LET g_str = NULL
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'img01,ima09,img02,ima10,img03,ima11,img04,ima12,ima06,ima08')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
###XtraGrid###    LET g_str = g_str,";",tm.yy USING '####',";",tm.m1 USING '##',";",
#               tm.m2 USING '##',";",tm.choice,";",tm.s,";",tm.t,";",tm.u,";",
#               tm.detail_flag
 
###XtraGrid###    CALL cl_prt_cs3('aimx610','aimx610',l_sql,g_str)   #FUN-710080 modify
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003--add--str---
   CASE tm.choice
      WHEN '0'
         LET g_xgrid.order_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima06,ima08")
         LET g_xgrid.grup_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima06,ima08")
        #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"img01,img02,img03,img04,ima06,ima08") #FUN-D30070 mark
         LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"img01,img02,img03,img04,ima06,ima08")
        #LET l_str = cl_wcchp(g_xgrid.order_field,"img01,img02,img03,img04,ima06,ima08") #FUN-D30070 mark
      WHEN '1'
         LET g_xgrid.order_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima09,ima08")
         LET g_xgrid.grup_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima09,ima08")
        #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"img01,img02,img03,img04,ima09,ima08")#FUN-D30070 mark
         LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"img01,img02,img03,img04,ima09,ima08")
        #LET l_str = cl_wcchp(g_xgrid.order_field,"img01,img02,img03,img04,ima09,ima08")  #FUN-D30070 mark
      WHEN '2'
         LET g_xgrid.order_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima10,ima08")
         LET g_xgrid.grup_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima10,ima08")
        #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"img01,img02,img03,img04,ima10,ima08")#FUN-D30070 mark
         LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"img01,img02,img03,img04,ima10,ima08")
        #LET l_str = cl_wcchp(g_xgrid.order_field,"img01,img02,img03,img04,ima10,ima08") #FUN-D30070 mark
      WHEN '3'
         LET g_xgrid.order_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima11,ima08")
         LET g_xgrid.grup_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima11,ima08")
        #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"img01,img02,img03,img04,ima11,ima08")#FUN-D30070 mark
         LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"img01,img02,img03,img04,ima11,ima08")
        #LET l_str = cl_wcchp(g_xgrid.order_field,"img01,img02,img03,img04,ima11,ima08") #FUN-D30070 mark
      WHEN '4'
         LET g_xgrid.order_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima12,ima08")
         LET g_xgrid.grup_field = cl_get_order_field(tm.s,"img01,img02,img03,img04,ima12,ima08")
        #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"img01,img02,img03,img04,ima12,ima08")#FUN-D30070 mark
         LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"img01,img02,img03,img04,ima12,ima08")
        #LET l_str = cl_wcchp(g_xgrid.order_field,"img01,img02,img03,img04,ima12,ima08") #FUN-D30070 mark
   END CASE
   LET g_xgrid.footerinfo1 = cl_getmsg("lib-068",g_lang),tm.yy USING '####'
   LET g_xgrid.footerinfo2 = cl_getmsg("lib-069",g_lang),tm.m1 USING '##','-',tm.m2 USING '##'
  #LET l_str = cl_replace_str(l_str,',','-') #FUN-D30070 mark
  #LET g_xgrid.footerinfo3 = cl_getmsg("lib-626",g_lang),l_str #FUN-D30070 mark
   LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   
#FUN-CB0003--add--end---
    CALL cl_xg_view()    ###XtraGrid###
 
    #FINISH REPORT x610_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #MOD-720046 By TSD.Jin--end
END FUNCTION
 
#MOD-720046 By TSD.Jin--start mark
###94/11/04 Modify By Jackson
###修改期初與期末
###將Group SUM(sr.fresh)與Group SUM(sr.ima09) 由 l_b1,l_b2,l_e1,l_e2 之 計算代替:
#REPORT x610_rep(sr)
#   DEFINE l_str         STRING #FUN-510017
#   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          g_chr2        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          i	        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#          x1            LIKE img_file.img01,
#          x2            LIKE ima_file.ima02,
#          x7            LIKE ima_file.ima021,
#          x3            LIKE img_file.img02,
#          x4            LIKE img_file.img03,
#          x5            LIKE img_file.img04,
#          x6            LIKE ima_file.ima06,
#          l_beg,l_end,l_b1,l_b2,l_e1,l_e2 LIKE imb_file.imb118, #MOD-530179
#          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                               img01  LIKE img_file.img01,
#                               img02  LIKE img_file.img02,
#                               img03  LIKE img_file.img03,
#                               img04  LIKE img_file.img04,
#                               imk081 LIKE imk_file.imk081,
#                               imk082 LIKE imk_file.imk082,
#                               imk084 LIKE imk_file.imk085,
#                               imk085 LIKE imk_file.imk085,
#                               imk09  LIKE imk_file.imk09,
#                               fresh  LIKE imk_file.imk09,  #期初數量
#                               ima02  LIKE ima_file.ima02,
#                               ima021 LIKE ima_file.ima021, #FUN-510017
#                               ima06  LIKE ima_file.ima06,
#                               ima08  LIKE ima_file.ima08,
#                               ima09  LIKE ima_file.ima09,
#                               ima10  LIKE ima_file.ima10,
#                               ima11  LIKE ima_file.ima11,
#                               ima12  LIKE ima_file.ima12,
#                               ima25  LIKE ima_file.ima25,
#                               img09  LIKE img_file.img09,
#                               img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
#                        END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.img01,sr.img02,sr.img03
#  FORMAT
#   PAGE HEADER
#      LET l_str = NULL
#      LET l_str = g_x[11] CLIPPED,tm.yy USING '####',' ',
#                  g_x[12] CLIPPED, tm.m1 USING'##','-',tm.m2 USING '##',' ',
#                  g_x[37] CLIPPED,g_orderA[1] CLIPPED,'-',
#                                  g_orderA[2] CLIPPED,'-',
#                                  g_orderA[3] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT l_str
#      PRINT g_dash
#      PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#            g_x[51],g_x[52],g_x[53],g_x[54]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#      LET l_b1=0 LET l_e1=0
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#      LET l_b2=0 LET l_e2=0
#   ON EVERY ROW
#      IF tm.detail_flag = 'Y' THEN
#      PRINT COLUMN g_c[41],sr.ima06,
#            COLUMN g_c[42],sr.img01,
#            COLUMN g_c[43],sr.img04,
#            COLUMN g_c[44],sr.ima02,
#            COLUMN g_c[45],sr.ima021,
#            COLUMN g_c[46],sr.img02,
#            COLUMN g_c[47],sr.img03,
#            COLUMN g_c[48],sr.img09,
#            COLUMN g_c[49],cl_numfor(sr.fresh,49,3),
#            COLUMN g_c[50],cl_numfor(sr.imk081,50,3),
#            COLUMN g_c[51],cl_numfor(sr.imk082,51,3),
#            COLUMN g_c[52],cl_numfor(sr.imk084,52,3),
#            COLUMN g_c[53],cl_numfor(sr.imk085,53,3),
#            COLUMN g_c[54],cl_numfor(sr.imk09,53,3)
#      END IF
# 
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET x1=' ' LET x2=' ' LET x3=' ' LET x4=' ' LET x5=' ' LET x6=' ' LET x7=' '
#            LET g_chr = tm.s[1,1]
#            CASE WHEN g_chr = '1' LET x1=sr.img01
#                                  LET x2=sr.ima02
#                                  LET x7=sr.ima021
#                 WHEN g_chr = '2' LET x3=sr.img02
#                 WHEN g_chr = '3' LET x4=sr.img03
#                 WHEN g_chr = '4' LET x5=sr.img04
#                 WHEN g_chr = '5' LET x6=sr.ima06
#            END CASE
#         PRINT
#         PRINT COLUMN g_c[41],x6,
#               COLUMN g_c[42],x1,
#               COLUMN g_c[43],x5,
#              #COLUMN g_c[44],x2,
#              #COLUMN g_c[45],x7,
#               COLUMN g_c[46],x3,
#               COLUMN g_c[47],x4,
#               COLUMN g_c[48],g_x[36] CLIPPED,
#               COLUMN g_c[49],cl_numfor(GROUP SUM(sr.fresh *sr.img2ima_fac),49,3),
#               COLUMN g_c[50],cl_numfor(GROUP SUM(sr.imk081*sr.img2ima_fac),50,3),
#               COLUMN g_c[51],cl_numfor(GROUP SUM(sr.imk082*sr.img2ima_fac),51,3),
#               COLUMN g_c[52],cl_numfor(GROUP SUM(sr.imk084*sr.img2ima_fac),52,3),
#               COLUMN g_c[53],cl_numfor(GROUP SUM(sr.imk085*sr.img2ima_fac),53,3),
#               COLUMN g_c[54],cl_numfor(GROUP SUM(sr.imk09 *sr.img2ima_fac),54,3)
#      END IF
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET x1=' ' LET x2=' ' LET x3=' ' LET x4=' ' LET x5=' ' LET x6=' ' LET x7=' '
#            LET g_chr = tm.s[2,2]
#            CASE WHEN g_chr = '1' LET x1=sr.img01
#                                  LET x2=sr.ima02
#                                  LET x7=sr.ima021
#                 WHEN g_chr = '2' LET x3=sr.img02
#                 WHEN g_chr = '3' LET x4=sr.img03
#                 WHEN g_chr = '4' LET x5=sr.img04
#                 WHEN g_chr = '5' LET x6=sr.ima06
#            END CASE
#         PRINT
#         PRINT COLUMN g_c[41],x6,
#               COLUMN g_c[42],x1,
#               COLUMN g_c[43],x5,
#              #COLUMN g_c[44],x2,
#              #COLUMN g_c[45],x7,
#               COLUMN g_c[46],x3,
#               COLUMN g_c[47],x4,
#               COLUMN g_c[48],g_x[36] CLIPPED,
#               COLUMN g_c[49],cl_numfor(GROUP SUM(sr.fresh *sr.img2ima_fac),49,3),
#               COLUMN g_c[50],cl_numfor(GROUP SUM(sr.imk081*sr.img2ima_fac),50,3),
#               COLUMN g_c[51],cl_numfor(GROUP SUM(sr.imk082*sr.img2ima_fac),51,3),
#               COLUMN g_c[52],cl_numfor(GROUP SUM(sr.imk084*sr.img2ima_fac),52,3),
#               COLUMN g_c[53],cl_numfor(GROUP SUM(sr.imk085*sr.img2ima_fac),53,3),
#               COLUMN g_c[54],cl_numfor(GROUP SUM(sr.imk09 *sr.img2ima_fac),54,3)
#      END IF
##  AFTER GROUP OF sr.order2
##     IF tm.u[2,2] = 'Y' THEN
##        LET x1=' ' LET x2=' ' LET x3=' ' LET x4=' ' LET x5=' ' LET x6=' '
##        LET g_chr = tm.s[1,1] LET g_chr2 = tm.s[2,2]
##        IF g_chr='1' OR g_chr2='1' THEN LET x1=sr.img01 LET x2=sr.ima02 END IF
##        IF g_chr='2' OR g_chr2='2' THEN LET x3=sr.img02                 END IF
##        IF g_chr='3' OR g_chr2='3' THEN LET x4=sr.img03                 END IF
##        IF g_chr='4' OR g_chr2='4' THEN LET x5=sr.img04                 END IF
##        IF g_chr='5' OR g_chr2='5' THEN LET x6=sr.ima06                 END IF
##        PRINT
##        PRINT COLUMN 01,x6 CLIPPED,
##              COLUMN 06,x1[1,20],' ',x5[1,10],
##              COLUMN 37,x2[1,24] CLIPPED,
##              COLUMN 63,x3 CLIPPED,
##              COLUMN 78,x4 CLIPPED,
##              COLUMN 81,g_x[35] CLIPPED,
### No:2669 modify 1998/10/28 ---------------
##           COLUMN 87,
##           GROUP SUM(sr.fresh *sr.img2ima_fac) USING '------------&.&&&',
##           COLUMN 105,
##           GROUP SUM(sr.imk081*sr.img2ima_fac) USING '------------&.&&&',
##           COLUMN 123,
##           GROUP SUM(sr.imk082*sr.img2ima_fac) USING '------------&.&&&',
##           COLUMN 141,
##           GROUP SUM(sr.imk084*sr.img2ima_fac) USING '------------&.&&&',
##           COLUMN 159,
##           GROUP SUM(sr.imk085*sr.img2ima_fac) USING '------------&.&&&',
##           COLUMN 177,
##           GROUP SUM(sr.imk09 *sr.img2ima_fac) USING '------------&.&&&'
##     END IF
# 
#   ON LAST ROW
#         PRINT
#         PRINT
#           COLUMN g_c[48],g_x[38] CLIPPED,
#           COLUMN g_c[49],cl_numfor(SUM(sr.fresh *sr.img2ima_fac),49,3),
#           COLUMN g_c[50],cl_numfor(SUM(sr.imk081*sr.img2ima_fac),50,3),
#           COLUMN g_c[51],cl_numfor(SUM(sr.imk082*sr.img2ima_fac),51,3),
#           COLUMN g_c[52],cl_numfor(SUM(sr.imk084*sr.img2ima_fac),52,3),
#           COLUMN g_c[53],cl_numfor(SUM(sr.imk085*sr.img2ima_fac),53,3),
#           COLUMN g_c[54],cl_numfor(SUM(sr.imk09 *sr.img2ima_fac),54,3)
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'imk01,imk02,imk03,imk04,imk05') RETURNING tm.wc
#         PRINT g_dash
##TQC-630166
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#MOD-720046 By TSD.Jin--end mark


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
