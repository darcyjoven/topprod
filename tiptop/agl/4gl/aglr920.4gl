# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aglr920.4gl
# Descriptions...: 二期損益比較表列印作業
# Date & Author..: 93/06/22  By  Felicity  Tseng
# Modify.........: No.FUN-580010 05/08/12 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A20019 10/02/25 By sabrina 取消9046錯誤訊息。QBE條件可以空白(1=1)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc  LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(300)
   DEFINE tm  RECORD
              s       LIKE type_file.chr2,     #No.FUN-680098 VARCHAR(2)
              t       LIKE type_file.chr2,     #No.FUN-680098 VARCHAR(2)
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              yy1     LIKE type_file.num5,    #No.FUN-680098   smallint
              m1      LIKE type_file.num5,    #No.FUN-680098   smallint
              m2      LIKE type_file.num5,    #No.FUN-680098   smallint
              yy2     LIKE type_file.num5,    #No.FUN-680098   smallint
              m3      LIKE type_file.num5,    #No.FUN-680098   smallint
              m4      LIKE type_file.num5,    #No.FUN-680098   smallint
              choice  LIKE type_file.chr1,    #異動額及餘額為零者是否列印 #No.FUN-680098 VARCHAR(1)
              dec     LIKE type_file.num5,    #小數位數     #No.FUN-680098  smallint
              cd      LIKE type_file.chr1,    #(1)借餘  (2)貸餘  #No.FUN-680098  VARCHAR(1)
              more    LIKE type_file.chr1     #No.FUN-680098 VARCHAR(1)
              END RECORD
   DEFINE g_orderA      ARRAY[2] OF  LIKE type_file.chr20     #No.FUN-680098   VARCHAR(10)
   DEFINE g_totdiff     LIKE type_file.num20_6      #No.FUN-680098  dec(20,6)
   DEFINE bookno  LIKE aah_file.aah00 #帳別     #No.FUN-740020
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE   g_head1         STRING                  #Print seqence
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET bookno = ARG_VAL(1)        #No.FUN-740020
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.yy1 = ARG_VAL(11)
   LET tm.yy2 = ARG_VAL(12)
   LET tm.m1  = ARG_VAL(13)
   LET tm.m2  = ARG_VAL(14)
   LET tm.m3  = ARG_VAL(15)
   LET tm.m4  = ARG_VAL(16)
   LET tm.choice  = ARG_VAL(17)
   LET tm.dec = ARG_VAL(18)
   LET tm.cd  = ARG_VAL(19)
   LET tm.azh01 = ARG_VAL(20)   #TQC-610056
   LET tm.azh02 = ARG_VAL(21)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   #No.FUN-570264 ---end---
   IF cl_null(bookno) THEN   #No.FUN-740020
      LET bookno = g_aza.aza81    #No.FUN-740020
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r920_tm(0,0)
      ELSE CALL r920()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r920_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 4 END IF
   CALL s_dsmark(bookno)     #No.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 4
   END IF
   OPEN WINDOW r920_w AT p_row,p_col
        WITH FORM "agl/42f/aglr920"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL  s_shwact(0,0,bookno)    #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno    #No.FUN-740020
   IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","aaa_file",bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123   #No.FUN-740020
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.dec FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
   LET tm.s    = '12'
   LET tm.choice = 'N'
   LET tm.cd = 'N'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME  g_wc ON aag223,aag224,aag225,aag226
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
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
  #IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF    #CHI-A20019 mark
 
   DISPLAY BY NAME tm.more
   INPUT BY NAME bookno,tm.azh01,tm.azh02,    #No.FUN-740020
                 tm.yy1,tm.m1,tm.m2,
                 tm.yy2,tm.m3,tm.m4,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.dec,
                 tm.choice,tm.cd,tm.more
                  WITHOUT DEFAULTS
         AFTER FIELD azh01
           IF NOT cl_null(tm.azh01) THEN
              SELECT azh02
                 INTO tm.azh02
                 FROM azh_file
                 WHERE azh01 = tm.azh01
                      IF SQLCA.SQLCODE = 100 THEN
#                        CALL cl_err(tm.azh01,'mfg9207',1)   #No.FUN-660123
                         CALL cl_err3("sel","azh_file",tm.azh01,"","mfg9207","","",1)   #No.FUN-660123
                         NEXT FIELD azh01
                      END IF
           END IF
         #No.FUN-740020 --begin                                                                                                     
         AFTER FIELD bookno                                                                                                         
            IF cl_null(bookno) THEN                                                                                              
               NEXT FIELD bookno                                                                                                    
            END IF                                                                                                                  
         #No.FUN-740020 --end
 
         AFTER FIELD yy1
           IF tm.yy1 <= 1911 OR cl_null(tm.yy1) THEN
              NEXT FIELD yy1
           END IF
         AFTER FIELD yy2
           IF tm.yy2 <= 1911 OR cl_null(tm.yy1) THEN
              NEXT FIELD yy2
           END IF
         AFTER FIELD m1
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.m1) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = tm.yy1
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
#No.TQC-720032 -- end --
           IF (tm.m1 < 0 OR tm.m1 >14) OR cl_null(tm.m1) THEN
              NEXT FIELD m1
           END IF
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.m2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = tm.yy1
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
#No.TQC-720032 -- end --
           IF (tm.m2 < 0 OR tm.m2 >14) OR cl_null(tm.m2) THEN
              NEXT FIELD m2
           END IF
 
         AFTER FIELD m3
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.m3) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = tm.yy2
               IF g_azm.azm02 = 1 THEN
                  IF tm.m3 > 12 OR tm.m3 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m3
                  END IF
               ELSE
                  IF tm.m3 > 13 OR tm.m3 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m3
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
           IF (tm.m3 < 0 OR tm.m3 >14) OR cl_null(tm.m3) THEN
              NEXT FIELD m3
           END IF
 
         AFTER FIELD m4
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m4) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.m4 > 12 OR tm.m4 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4
               END IF
            ELSE
               IF tm.m4 > 13 OR tm.m4 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
           IF (tm.m4 < 0 OR tm.m4 >14) OR cl_null(tm.m4) THEN
              NEXT FIELD m4
           END IF
 
         AFTER FIELD choice
           IF tm.choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF
         AFTER FIELD cd
           IF tm.cd NOT MATCHES '[YN]' THEN
              NEXT FIELD cd
           END IF
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
         ON ACTION CONTROLP
           CASE
         #No.FUN-740020  --Begin                                                                                                    
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 = bookno                                                                                      
              CALL cl_create_qry() RETURNING bookno                                                                                 
              DISPLAY BY NAME bookno                                                                                                
              NEXT FIELD bookno                                                                                                     
         #No.FUN-740020  --End
               WHEN INFIELD(azh01)
#                   CALL q_azh(10,3,tm.azh01,'') RETURNING tm.azh01,tm.azh02
#                   CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#                   CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azh'
    LET g_qryparam.default1 = tm.azh01
    LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#    CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#    CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
# END genero shell script ADD
################################################################################
                    DISPLAY tm.azh01, tm.azh02 TO azh01, azh02
              OTHERWISE EXIT CASE
           END CASE
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG CALL cl_cmdask()
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aglr920'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr920','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",bookno CLIPPED,"'",         #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'",
                         " '",tm.m3 CLIPPED,"'",
                         " '",tm.m4 CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.dec CLIPPED,"'",
                         " '",tm.cd CLIPPED,"'" ,
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr920',g_time,l_cmd)
      END IF
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r920()
   ERROR ""
END WHILE
   CLOSE WINDOW r920_w
END FUNCTION
 
{
FUNCTION r920_wc()
   DEFINE l_wc LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(300)
 
   OPEN WINDOW r920_w2 AT 2,2
        WITH FORM "agl/42f/aglt110"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aglt110")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                      # 螢幕上取條件
              apa01, apa02, apa05,
              apa06, apa08, apa09, apa11, apa12,
              apa13, apa14, apa15, apa16,
              apa19, apa20, apa17, apa21, apa22,
              apa24, apa25, apa43, apa44, apamksg, apa36,
              apa31, apa51, apa32, apa52, apa33, apa53, apa34, apa54,
              apa35,
              apainpd, apauser, apagrup, apamodu, apadate, apaacti
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
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   CLOSE WINDOW r920_w2
   LET g_wc = g_wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION r920()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT #No.FUN-680098  VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_za05    LIKE za_file.za05,        #No.FUN-680098   VARCHAR(40)   
          l_order   ARRAY[2] OF LIKE  aag_file.aag223, #No.FUN-680098  VARCHAR(5) 
          sr               RECORD
                                  order1 LIKE aag_file.aag223, #No.FUN-680098  VARCHAR(5)
                                  order2 LIKE aag_file.aag223, #No.FUN-680098  VARCHAR(5)
                                  aag01  LIKE aag_file.aag01,
                                  aag06  LIKE aag_file.aag06,
                                  aag223 LIKE aag_file.aag223,
                                  aag224 LIKE aag_file.aag224,
                                  aag225 LIKE aag_file.aag225,
                                  aag226 LIKE aag_file.aag226,
                                  amt1   LIKE aah_file.aah04,
                                  amt2   LIKE aah_file.aah05
                        END RECORD
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno     #No.FUN-740020
			AND aaf02 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET g_wc = g_wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT aag223,aag224,aag225,aag226,aag01,aag06",
                 " FROM aag_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND aag00 = '",bookno,"'"      #No.FUN-740020
     PREPARE r920_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r920_curs1 CURSOR FOR r920_prepare1
#    LET l_name = 'aglr920.out'
     CALL cl_outnam('aglr920') RETURNING l_name
     START REPORT r920_rep TO l_name
     LET g_pageno = 0
     LET g_totdiff = 0
     FOREACH r920_curs1 INTO sr.aag223,sr.aag224,sr.aag225,sr.aag226,
                             sr.aag01,sr.aag06
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          SELECT SUM(aah04-aah05) INTO sr.amt1 FROM aah_file
            WHERE aah00=bookno AND aah01=sr.aag01 AND aah02 = tm.yy1      #No.FUN-740020
              AND aah03 BETWEEN tm.m1 AND tm.m2
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Select aah error !',SQLCA.SQLCODE,1)   #No.FUN-660123
               CALL cl_err3("sel","aah_file",tm.yy1,sr.aag01,SQLCA.sqlcode,"","Select aah error !",1)   #No.FUN-660123
               EXIT FOREACH
            END IF	
{??}      IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
          SELECT SUM(aah04-aah05) INTO sr.amt2 FROM aah_file
            WHERE aah00=bookno AND aah01=sr.aag01 AND aah02 = tm.yy2    #No.FUN-740020
              AND aah03 BETWEEN tm.m3 AND tm.m4
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Select aah error !',SQLCA.SQLCODE,1)   #No.FUN-660123
               CALL cl_err3("sel","aah_file",tm.yy2,sr.aag01,SQLCA.sqlcode,"","Select aah error !",1)   #No.FUN-660123
               EXIT FOREACH
            END IF	
{??}      IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
          IF sr.aag06 = '2' THEN                #貸餘
             LET sr.amt1 = -1 * sr.amt1
             LET sr.amt2 = -1 * sr.amt2
          END IF
          IF sr.amt1 = 0 AND sr.amt2 = 0 AND tm.choice = 'N' THEN
             CONTINUE FOREACH
          END IF
          FOR g_i = 1 TO 2
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.aag223
                                            LET g_orderA[g_i]= g_x[20]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.aag224
                                            LET g_orderA[g_i]= g_x[21]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.aag225
                                            LET g_orderA[g_i]= g_x[22]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aag226
                                            LET g_orderA[g_i]= g_x[23]
                   OTHERWISE LET l_order[g_i]  = '-'
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          OUTPUT TO REPORT r920_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r920_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r920_rep(sr)
DEFINE l_last_sw     LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)
DEFINE sr               RECORD
                        order1 LIKE aag_file.aag223,  #No.FUN-680098  VARCHAR(5)
                        order2 LIKE aag_file.aag223,  #No.FUN-680098  VARCHAR(5) 
                        aag01  LIKE aag_file.aag01,
                        aag06  LIKE aag_file.aag06,
                        aag223 LIKE aag_file.aag223,
                        aag224 LIKE aag_file.aag224,
                        aag225 LIKE aag_file.aag225,
                        aag226 LIKE aag_file.aag226,
                        amt1   LIKE aah_file.aah04,
                        amt2   LIKE aah_file.aah05
                        END RECORD
DEFINE l_buf DYNAMIC ARRAY OF RECORD
                        aae01  LIKE aae_file.aae01,
                        aae02  LIKE aae_file.aae02,
                        amt1   LIKE aah_file.aah04,
                        amt2   LIKE aah_file.aah05,
                        diff   LIKE aah_file.aah04,
                        pr3    LIKE aah_file.aah04
                        END RECORD
DEFINE l_aae02_1        LIKE aae_file.aae02
DEFINE l_aae02_2        LIKE aae_file.aae02
DEFINE l_max            LIKE type_file.num5    #No.FUN-680098  smallint
DEFINE l_idx            LIKE type_file.num5    #No.FUN-680098  smallint
DEFINE l_posistion      LIKE type_file.num5    #No.FUN-680098  smallint 
DEFINE l_gsum_1 ,l_gsum_3 LIKE aah_file.aah04
DEFINE l_gsum_2 ,l_gsum_4 LIKE aah_file.aah04
DEFINE l_totdiff         LIKE type_file.num20_6 #No.FUN-680098 dec(20,6)
DEFINE l_diff            LIKE type_file.num20_6 #No.FUN-680098 dec(20,6)
 
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1, sr.order2
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[11] CLIPPED, g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED
      PRINT g_head1
#No.FUN-580010 --end--
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      ELSE
         LET g_x[1] = g_x[1]
      END IF
 
      PRINT g_dash[1,g_len]
#No.FUN-580010 --start--
#     PRINT COLUMN 01, g_x[12] CLIPPED,
#           COLUMN 32, g_x[13] CLIPPED,
#           COLUMN 44, g_x[14] CLIPPED,
#           COLUMN 50, g_x[15] CLIPPED,
#           COLUMN 65, g_x[14] CLIPPED,
#           COLUMN 75, g_x[16] CLIPPED,
#           COLUMN 86, g_x[14] CLIPPED
#     PRINT COLUMN 29,tm.yy1 USING '####','/',tm.m1 USING '##',
#                     '-',tm.m2 USING '<#',
#           COLUMN 44,'%',
#           COLUMN 50,tm.yy2 USING '####','/',tm.m3 USING '##',
#                     '-',tm.m4 USING '<#',
#           COLUMN 65,'%',
#           COLUMN 86,'%'
#     PRINT '------------------------- ',
#           '---------------- --- ',
#           '---------------- --- ',
#           '---------------- ----'
      LET g_zaa[39].zaa08 = tm.yy1 USING '####','/',tm.m1 USING '##','-',tm.m2 USING '<#'
      LET g_zaa[41].zaa08 = tm.yy2 USING '####','/',tm.m3 USING '##','-',tm.m4 USING '<#'
      PRINTX name = H1  g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINTX name = H2  g_x[38],g_x[39],g_x[40],g_x[41]
      PRINT  g_dash1
#No.FUN-580010 --end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      SELECT aae02
        INTO l_aae02_1
        FROM aae_file
        WHERE aae01 = sr.order1
        IF SQLCA.SQLCODE THEN
           LET l_aae02_1 = NULL
        END IF
#No.FUN-580010 --start--
#     PRINT COLUMN 01, sr.order1,
#           COLUMN 06, l_aae02_1
      PRINT COLUMN g_c[31], sr.order1, l_aae02_1
#No.FUN-580010 --end--
      SKIP 1 LINE
      FOR l_idx = 1 TO 200
          INITIALIZE l_buf[l_idx].* TO NULL
      END FOR
      LET l_totdiff = 0
      LET l_max = 0               #Array 用到的個數
      LET l_idx = 0
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
 
   AFTER GROUP OF sr.order1
      LET l_gsum_3 = GROUP SUM (sr.amt1)
      LET l_gsum_4 = GROUP SUM (sr.amt2)
      IF l_gsum_3 = 0 THEN LET l_gsum_3 = NULL END IF
      IF l_gsum_4 = 0 THEN LET l_gsum_4 = NULL END IF
      IF l_idx > 200 THEN LET l_max = 200 END IF
      FOR l_idx = 1 to l_max
#No.FUN-580010 --start--
#         PRINT COLUMN 01, l_buf[l_idx].aae01,
#               COLUMN 06, l_buf[l_idx].aae02,
#               COLUMN 27, cl_numfor(l_buf[l_idx].amt1,15,tm.dec) CLIPPED,
#               COLUMN 44, l_buf[l_idx].amt1/l_gsum_3 * 100 USING '##&',
#               COLUMN 48, cl_numfor(l_buf[l_idx].amt2,15,tm.dec) CLIPPED,
#               COLUMN 65, l_buf[l_idx].amt2/l_gsum_4 * 100 USING '##&',
#               COLUMN 69, cl_numfor(l_buf[l_idx].diff,15,tm.dec) CLIPPED,
#               COLUMN 86, l_buf[l_idx].pr3 USING '---&'
         PRINT  COLUMN g_c[31], l_buf[l_idx].aae01,l_buf[l_idx].aae02,
                COLUMN g_c[32], cl_numfor(l_buf[l_idx].amt1,15,tm.dec) CLIPPED,
                COLUMN g_c[33], l_buf[l_idx].amt1/l_gsum_3 * 100 USING '##&',
                COLUMN g_c[34], cl_numfor(l_buf[l_idx].amt2,15,tm.dec) CLIPPED,
                COLUMN g_c[35], l_buf[l_idx].amt2/l_gsum_4 * 100 USING '##&',
                COLUMN g_c[36], cl_numfor(l_buf[l_idx].diff,15,tm.dec) CLIPPED,
                COLUMN g_c[37], l_buf[l_idx].pr3 USING '---&'
#No.FUN-580010 --end--
         LET l_totdiff = l_totdiff + l_buf[l_idx].diff
      END FOR
      LET g_totdiff = g_totdiff + l_totdiff
      CALL r920_cha(l_aae02_1)
           RETURNING l_posistion
#No.FUN-580010 --start--
#     PRINT COLUMN 27,'---------------------------------------------------------------'
#     PRINT COLUMN l_posistion, l_aae02_1 CLIPPED,            #印"合計"
#           COLUMN 21, g_x[18] CLIPPED,
#           COLUMN 27, cl_numfor(l_gsum_3,15,tm.dec) CLIPPED,
#           COLUMN 44, '100',
#           COLUMN 48, cl_numfor(l_gsum_4,15,tm.dec) CLIPPED,
#           COLUMN 65, '100',
#           COLUMN 69, cl_numfor(l_totdiff,15,tm.dec) CLIPPED,
#           COLUMN 86, l_totdiff/l_gsum_4*100 USING '---&'
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
            COLUMN g_c[33],g_dash2[1,g_w[33]],
            COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]]
 
      PRINT COLUMN g_c[31],l_aae02_1 CLIPPED,g_x[18] CLIPPED,
            COLUMN g_c[32],cl_numfor(l_gsum_3,15,tm.dec) CLIPPED,
            COLUMN g_c[33],'100',
            COLUMN g_c[34],cl_numfor(l_gsum_4,15,tm.dec) CLIPPED,
            COLUMN g_c[35],'100',
            COLUMN g_c[36],cl_numfor(l_totdiff,15,tm.dec) CLIPPED,
            COLUMN g_c[37],l_totdiff/l_gsum_4*100 USING '---&'
#No.FUN-580010 --end--
      SKIP 1 LINE
 
   AFTER GROUP OF sr.order2
      SELECT aae02
        INTO l_aae02_2
        FROM aae_file
        WHERE aae01 = sr.order2
        IF SQLCA.SQLCODE THEN
           LET l_aae02_2 = NULL
        END IF
      LET l_idx = l_idx + 1
      LET l_gsum_1 = GROUP SUM(sr.amt1)
      LET l_gsum_2 = GROUP SUM(sr.amt2)
#     IF l_gsum_1 = 0 THEN LET l_gsum_1 = NULL END IF
#     IF l_gsum_2 = 0 THEN LET l_gsum_2 = NULL END IF
      LET l_diff = l_gsum_1 - l_gsum_2
      LET l_buf[l_idx].aae01=sr.order2
      LET l_buf[l_idx].aae02=l_aae02_2
      LET l_buf[l_idx].amt1=l_gsum_1
      LET l_buf[l_idx].amt2=l_gsum_2
      LET l_buf[l_idx].diff=l_diff
      IF l_gsum_2 = 0 THEN
         LET l_buf[l_idx].pr3= NULL
      ELSE
         LET l_buf[l_idx].pr3=l_buf[l_idx].diff/l_gsum_2 * 100
      END IF
      LET l_max = l_idx
 
   ON LAST ROW
      IF tm.cd = 'Y' THEN
#No.FUN-580010 --start--
#     PRINT COLUMN 19, g_x[19] CLIPPED,             #印"總合計"
#           COLUMN 27, cl_numfor(SUM(sr.amt1),15,tm.dec) CLIPPED,
#           COLUMN 48, cl_numfor(SUM(sr.amt2),15,tm.dec) CLIPPED,
#           COLUMN 69, cl_numfor(g_totdiff,15,tm.dec) CLIPPED,
#           COLUMN 86, (g_totdiff/SUM(sr.amt2)*100) USING '---&'
      PRINT COLUMN g_c[31],g_x[19] CLIPPED,             #印"總合計"
            COLUMN g_c[32],cl_numfor(SUM(sr.amt1),15,tm.dec) CLIPPED,
            COLUMN g_c[34],cl_numfor(SUM(sr.amt2),15,tm.dec) CLIPPED,
            COLUMN g_c[36],cl_numfor(g_totdiff,15,tm.dec) CLIPPED,
            COLUMN g_c[37],(g_totdiff/SUM(sr.amt2)*100) USING '---&'
#No.FUN-580010 --end--
      END IF
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
 
FUNCTION r920_cha(l_cha)
DEFINE l_cha       LIKE type_file.chr20     #No.FUN-680098 VARCHAR(20)
DEFINE l_leng      LIKE type_file.num5      #No.FUN-680098 smallint 
DEFINE l_result    LIKE type_file.num5      #No.FUN-680098 smallint
 
   LET l_leng = LENGTH (l_cha)
   LET l_result = 21 - l_leng
   RETURN l_result
END FUNCTION
#Patch....NO.TQC-610035 <> #
