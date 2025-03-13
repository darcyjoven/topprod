# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr612.4gl
# Descriptions...: 料件儲位庫存期報表列印作業
# Date & Author..: 93/06/16  By  Felicity  Tseng
# Modify.........: No.FUN-510017 05/01/14 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui  移除列印順序三
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-7B0077 07/11/08 By Pengu mark g_orderA[3]的PRINT
# Modify.........: No.TQC-810093 08/02/19 By lumxa aimr612 
                                                   #在報表畫面上‘分群碼排列資料選擇’ 選其他分群碼二（另外幾個分群碼也一樣）
                                                   #，列印出來的結果并沒有顯示出我的分群碼是什麼或者是錯誤的，
                                                   #只能看到一堆數據，卻不知道這些數據是屬于哪個分群碼。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0021 09/10/05 By Smapmin 列印條件若在最後一行,則報表無法印出來
# Modify.........: No.TQC-C40107 12/04/13 By xianghui 增加倉庫編號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc          STRING,                 # Where Condition  #TQC-630166
           s           LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           t           LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           u           LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           choice      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           yy          LIKE type_file.num10,   #No.FUN-690026 INTEGER
           m1          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           m2          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           detail_flag LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           more        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD,
       last_y,last_m   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   #   g_orderA        ARRAY[3] OF LIKE ima_file.ima01  #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)
       g_orderA        ARRAY[2] OF LIKE ima_file.ima01  #FUN-5B0105 10->40  #No.FUN-690026 VARCHAR(40)   #TQC-6A0088
 
DEFINE g_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
 
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
   LET tm.u  = ARG_VAL(14)
   LET tm.detail_flag  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
  #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r612_tm(0,0)
      ELSE CALL r612()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r612_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 10
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r612_w AT p_row,p_col
        WITH FORM "aim/42f/aimr612"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '12'
   LET tm.u    = '  '
   LET tm.choice = 0
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.detail_flag = 'Y'
   LET tm.more = 'N'
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
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
            #TQC-C40107-add-str--
            IF INFIELD(img02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img02
               NEXT FIELD img02
            END IF
            #TQc-C40107-add-end--
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r612_w
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
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.choice,tm.yy,tm.m1,tm.m2,
                 tm.detail_flag,tm.more WITHOUT DEFAULTS
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
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      CLOSE WINDOW r612_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr612'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr612','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
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
                         " '",tm.u CLIPPED,"'" ,                #TQC-610072  
                         " '",tm.detail_flag CLIPPED,"'" ,       #TQC-610072 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr612',g_time,l_cmd)
      END IF
      CLOSE WINDOW r612_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r612()
   ERROR ""
END WHILE
   CLOSE WINDOW r612_w
END FUNCTION
 
FUNCTION r612()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                            # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           img01  LIKE img_file.img01,
                           img02  LIKE img_file.img02,
                           img03  LIKE img_file.img03,
                           img04  LIKE img_file.img04,
                           imk081 LIKE imk_file.imk081,
                           imk082 LIKE imk_file.imk082,
                           imk083 LIKE imk_file.imk084,
                           imk084 LIKE imk_file.imk084,
                           imk085 LIKE imk_file.imk084,
                           imk09  LIKE imk_file.imk09,
                           fresh  LIKE imk_file.imk09, #期初數量
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           ima06  LIKE ima_file.ima06,
                           ima08  LIKE ima_file.ima08,
                           ima09  LIKE ima_file.ima09,
                           ima10  LIKE ima_file.ima10,
                           ima11  LIKE ima_file.ima11,
                           ima12  LIKE ima_file.ima12,
                           img09  LIKE img_file.img09,
                           ima25  LIKE ima_file.ima25,
                           img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
                        END RECORD
 
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
 
     LET l_sql = "SELECT '','',",
                 " img01, img02, img03, img04, ",
                 " 0, 0, 0, 0, 0, 0, 0,",
                 " ima02,ima021, ima06, ima08, ima09, ima10, ima11, ima12, img09,",
                 " ima25, 1 ",
                 " FROM ima_file,img_file",
                 " WHERE img01 = ima01 ",
                 "   AND ", tm.wc CLIPPED
     PREPARE r612_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r612_curs1 CURSOR FOR r612_prepare1
     CALL cl_outnam('aimr612') RETURNING l_name
     START REPORT r612_rep TO l_name
     LET g_pageno = 0
     FOREACH r612_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
## No:2673 modify 1998/10/28 ---------------
       IF sr.img09<>sr.ima25
          THEN
          CALL s_umfchk(sr.img01,sr.img09,sr.ima25)
               RETURNING g_i,sr.img2ima_fac
          IF g_i = 1 THEN
             CALL cl_err(sr.img01,'mfg3075',1)
             EXIT FOREACH
          END IF
       END IF
## --
          SELECT imk09 INTO sr.imk09 FROM imk_file
           WHERE imk01=sr.img01 AND imk02=sr.img02
             AND imk03=sr.img03 AND imk04=sr.img04
             AND imk05=tm.yy    AND imk06=tm.m2
          SELECT sum(imk081),sum(imk082),sum(imk083),sum(imk084),sum(imk085)
            INTO sr.imk081,sr.imk082,sr.imk083,sr.imk084,sr.imk085
            FROM imk_file
           WHERE imk01=sr.img01 AND imk02=sr.img02
             AND imk03=sr.img03 AND imk04=sr.img04
             AND imk05=tm.yy    AND imk06 BETWEEN tm.m1 AND tm.m2
          IF cl_null(sr.imk081) THEN LET sr.imk081 = 0 END IF
          IF cl_null(sr.imk082) THEN LET sr.imk082 = 0 END IF
          IF cl_null(sr.imk083) THEN LET sr.imk083 = 0 END IF
          IF cl_null(sr.imk084) THEN LET sr.imk084 = 0 END IF
          IF cl_null(sr.imk085) THEN LET sr.imk085 = 0 END IF
          IF cl_null(sr.imk09) THEN LET sr.imk09 = 0 END IF
          IF sr.imk081=0 AND sr.imk082=0 AND sr.imk083=0 AND sr.imk084=0 AND
             sr.imk085=0 AND sr.imk09=0  THEN CONTINUE FOREACH END IF
          LET sr.fresh = sr.imk09 - sr.imk081 - sr.imk082 - sr.imk083 -
                         sr.imk084 - sr.imk085
          FOR g_i = 1 TO 2
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.img01
                                            LET g_orderA[g_i]= g_x[25]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.img02
                                            LET g_orderA[g_i]= g_x[26]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img03
                                            LET g_orderA[g_i]= g_x[27]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img04
                                            LET g_orderA[g_i]= g_x[28]
                   WHEN tm.s[g_i,g_i] = '5'
                        CASE
      			    		 WHEN tm.choice ='0' LET l_order[g_i] = sr.ima06
                                                 LET g_orderA[g_i]= g_x[29]
	      			    	 WHEN tm.choice ='1' LET l_order[g_i] = sr.ima09
                                                 LET g_orderA[g_i]= g_x[30]
    		      			 WHEN tm.choice ='2' LET l_order[g_i] = sr.ima10
                                                 LET g_orderA[g_i]= g_x[31]
	    		   	      	 WHEN tm.choice ='3' LET l_order[g_i] = sr.ima11
                                                 LET g_orderA[g_i]= g_x[32]
		    	      		 WHEN tm.choice ='4' LET l_order[g_i] = sr.ima12
                                                 LET g_orderA[g_i]= g_x[33]
                        END CASE
                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima08
                                            LET g_orderA[g_i]= g_x[34]
                   OTHERWISE LET l_order[g_i]  = '-'
                             LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          OUTPUT TO REPORT r612_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r612_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
##94/11/04 Modify By Jackson
##修改期初與期末
##將Group SUM(sr.fresh)與Group SUM(sr.ima09) 由 l_b1,l_b2,l_e1,l_e2 之 計算代替
REPORT r612_rep(sr)
   DEFINE l_str     STRING #FUN-510017
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          g_chr2    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          i         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          x1        LIKE img_file.img01,
          x2        LIKE ima_file.ima02,
          x3        LIKE img_file.img02,
          x4        LIKE img_file.img03,
          x5        LIKE img_file.img04,
          x6        LIKE ima_file.ima06,
          l_beg,l_end,l_b1,l_b2,l_e1,l_e2 LIKE imb_file.imb118, #MOD-530179
          g_msg     LIKE type_file.chr1000,            #No.FUN-690026 VARCHAR(86)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           img01  LIKE img_file.img01,
                           img02  LIKE img_file.img02,
                           img03  LIKE img_file.img03,
                           img04  LIKE img_file.img04,
                           imk081 LIKE imk_file.imk081,
                           imk082 LIKE imk_file.imk082,
                           imk083 LIKE imk_file.imk084,
                           imk084 LIKE imk_file.imk084,
                           imk085 LIKE imk_file.imk084,
                           imk09  LIKE imk_file.imk09,
                           fresh  LIKE imk_file.imk09,  #期初數量
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           ima06  LIKE ima_file.ima06,
                           ima08  LIKE ima_file.ima08,
                           ima09  LIKE ima_file.ima09,
                           ima10  LIKE ima_file.ima10,
                           ima11  LIKE ima_file.ima11,
                           ima12  LIKE ima_file.ima12,
                           img09  LIKE img_file.img09,
                           ima25  LIKE ima_file.ima25,
                           img2ima_fac LIKE ima_file.ima31_fac #MOD-530179
                    END RECORD,
      l_img0203     LIKE type_file.chr1000,                    #No.FUN-690026 VARCHAR(50)
      l_i,l_j       LIKE type_file.num10   #MOD-9A0021
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.img01,sr.img02,sr.img03
  FORMAT
   PAGE HEADER
      LET l_str = NULL
      LET l_str = g_x[11] CLIPPED,tm.yy USING '####',' ',
                  g_x[12] CLIPPED, tm.m1 USING'##','-',tm.m2 USING '##',' ',
                  g_x[37] CLIPPED,g_orderA[1] CLIPPED,'-',
                                 #-----------No.MOD-7B0077 modify
                                 #g_orderA[2] CLIPPED,'-',
                                 #g_orderA[3] CLIPPED
                                  g_orderA[2] CLIPPED
                                 #-----------No.MOD-7B0077 end
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT l_str
      PRINT g_dash
#TQC-810093 --start---
      LET g_zaa[54].zaa08 = g_orderA[1] #TQC-810093
      IF tm.s[1] <>'5' THEN               
         LET g_zaa[54].zaa06='Y'
      END IF
      PRINT g_x[54],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50], #TQC-810093
            g_x[51],g_x[52],g_x[53]
#     PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#           g_x[51],g_x[52],g_x[53]
#TQC-810093 --end---
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_b1=0 LET l_e1=0
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_b2=0 LET l_e2=0
   AFTER GROUP OF sr.img03
      IF tm.detail_flag = 'Y' THEN
      LET l_img0203 = sr.img02 CLIPPED,' ',sr.img03 CLIPPED
#TQC-810093 --start---
      PRINT COLUMN g_c[54],sr.order1,
#TQC-810093 --start---
            COLUMN g_c[41],sr.img01,
            COLUMN g_c[42],sr.ima02,
            COLUMN g_c[43],sr.ima021,
            COLUMN g_c[44],sr.img02,
            COLUMN g_c[45],sr.img03,
            COLUMN g_c[46],sr.img09,
            COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fresh ),47,3),
            COLUMN g_c[48],cl_numfor(GROUP SUM(sr.imk081),48,3),
            COLUMN g_c[49],cl_numfor(GROUP SUM(sr.imk082),49,3),
            COLUMN g_c[50],cl_numfor(GROUP SUM(sr.imk083),50,3),
            COLUMN g_c[51],cl_numfor(GROUP SUM(sr.imk084),51,3),
            COLUMN g_c[52],cl_numfor(GROUP SUM(sr.imk085),52,3),
            COLUMN g_c[53],cl_numfor(GROUP SUM(sr.imk09 ),53,3)
      END IF
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET g_msg = ' '
         LET x1=' ' LET x2=' ' LET x3=' ' LET x4=' ' LET x5=' ' LET x6=' '
            LET g_chr = tm.s[1,1]
            CASE WHEN g_chr = '1' LET x1=sr.img01
                                  LET x2=sr.ima02
                 WHEN g_chr = '2' LET x3=sr.img02
                 WHEN g_chr = '3' LET x4=sr.img03
                 WHEN g_chr = '4' LET x5=sr.img04
                 WHEN g_chr = '5' LET x6=sr.ima06
            END CASE
         PRINT
#TQC-810093 --start---
         PRINT COLUMN g_c[54],sr.order1,
#TQC-810093 --start---
               COLUMN g_c[41],x1,
               COLUMN g_c[42],g_x[36] CLIPPED,
               COLUMN g_c[44],x3,
               COLUMN g_c[45],x4,
               COLUMN g_c[46],sr.ima25,
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fresh*sr.img2ima_fac ),47,3),
               COLUMN g_c[48],cl_numfor(GROUP SUM(sr.imk081*sr.img2ima_fac),48,3),
               COLUMN g_c[49],cl_numfor(GROUP SUM(sr.imk082*sr.img2ima_fac),49,3),
               COLUMN g_c[50],cl_numfor(GROUP SUM(sr.imk083*sr.img2ima_fac),50,3),
               COLUMN g_c[51],cl_numfor(GROUP SUM(sr.imk084*sr.img2ima_fac),51,3),
               COLUMN g_c[52],cl_numfor(GROUP SUM(sr.imk085*sr.img2ima_fac),52,3),
               COLUMN g_c[53],cl_numfor(GROUP SUM(sr.imk09*sr.img2ima_fac ),53,3)
         PRINT g_dash2
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET g_msg = ' '
         LET x1=' ' LET x2=' ' LET x3=' ' LET x4=' ' LET x5=' ' LET x6=' '
            LET g_chr = tm.s[2,2]
            CASE WHEN g_chr = '1' LET x1=sr.img01
                                  LET x2=sr.ima02
                 WHEN g_chr = '2' LET x3=sr.img02
                 WHEN g_chr = '3' LET x4=sr.img03
                 WHEN g_chr = '4' LET x5=sr.img04
                 WHEN g_chr = '5' LET x6=sr.ima06
            END CASE
         PRINT
         PRINT COLUMN g_c[41],x1,
               COLUMN g_c[42],g_x[36] CLIPPED,
               COLUMN g_c[44],x3,
               COLUMN g_c[45],x4,
               COLUMN g_c[46],sr.ima25,
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fresh*sr.img2ima_fac ),47,3),
               COLUMN g_c[48],cl_numfor(GROUP SUM(sr.imk081*sr.img2ima_fac),48,3),
               COLUMN g_c[49],cl_numfor(GROUP SUM(sr.imk082*sr.img2ima_fac),49,3),
               COLUMN g_c[50],cl_numfor(GROUP SUM(sr.imk083*sr.img2ima_fac),50,3),
               COLUMN g_c[51],cl_numfor(GROUP SUM(sr.imk084*sr.img2ima_fac),51,3),
               COLUMN g_c[52],cl_numfor(GROUP SUM(sr.imk085*sr.img2ima_fac),52,3),
               COLUMN g_c[53],cl_numfor(GROUP SUM(sr.imk09*sr.img2ima_fac ),53,3)
         PRINT g_dash2
      END IF
 
   ON LAST ROW
         PRINT ' '
         PRINT
            COLUMN g_c[42],g_x[38] CLIPPED,
            COLUMN g_c[47],cl_numfor(SUM(sr.fresh*sr.img2ima_fac ),47,3),
            COLUMN g_c[48],cl_numfor(SUM(sr.imk081*sr.img2ima_fac),48,3),
            COLUMN g_c[49],cl_numfor(SUM(sr.imk082*sr.img2ima_fac),49,3),
            COLUMN g_c[50],cl_numfor(SUM(sr.imk083*sr.img2ima_fac),50,3),
            COLUMN g_c[51],cl_numfor(SUM(sr.imk084*sr.img2ima_fac),51,3),
            COLUMN g_c[52],cl_numfor(SUM(sr.imk085*sr.img2ima_fac),52,3),
            COLUMN g_c[53],cl_numfor(SUM(sr.imk09*sr.img2ima_fac ),53,3)
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'imk01,imk02,imk03,imk04,imk05') RETURNING tm.wc
         PRINT g_dash
#TQC-630166
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         #-----MOD-9A0021---------
         #CALL cl_prt_pos_wc(tm.wc)
         LET l_j = g_len - 10
         FOR l_i = 1 TO tm.wc.getlength()
              IF l_j > tm.wc.getLength() THEN 
                  LET l_j = tm.wc.getLength()
              END IF
              IF l_i = 1 THEN
                 IF tm.s[1] <>'5' THEN               
                    PRINT COLUMN g_c[41],g_x[8] CLIPPED, tm.wc.subString(l_i,l_j)
                 ELSE
                    PRINT g_x[8] CLIPPED, tm.wc.subString(l_i,l_j)
                 END IF
              ELSE
                 PRINT COLUMN g_c[41], tm.wc.subString(l_i,l_j)
              END IF
              LET l_i = l_j
              LET l_j = l_i + g_len - 10
         END FOR
         #-----MOD-9A0021---------
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
         ELSE SKIP 2 LINE
      END IF
END REPORT
