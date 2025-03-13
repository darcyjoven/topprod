# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr921.4gl
# Descriptions...: 二期分類預算損益比較表列印作業
# Date & Author..: 93/06/22  By  Felicity  Tseng
# Modify.........: No.FUN-580010 05/08/12 By yoyo 憑証類報表原則修改
# Modify.........: No.TQC-5B0045 05/11/08 By Smapmin 調整報表格式
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: NO.FUN-810069 08/03/03 By destiny 預算編號改為預算項目
# Modify.........: No.FUN-830139 08/04/02 By douzh項目預算去掉預算編號
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No:CHI-A20019 10/02/25 By sabrina 取消9046錯誤訊息。QBE條件可以空白(1=1)
# Modify.........: No:FUN-AB0020 10/11/05 By chenying 畫面上新增預算項目afc01
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#  DEFINE g_wc LIKE VARCHAR(300)     
   DEFINE g_wc STRING         #TQC-630166     
   DEFINE tm  RECORD
              s      LIKE  type_file.chr2,   #No.FUN-680098  VARCHAR(2)
              t      LIKE  type_file.chr2,   #No.FUN-680098  VARCHAR(2)
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              yy1     LIKE aah_file.aah02,   #No.FUN-680098  smallint
              m1      LIKE aah_file.aah03,   #No.FUN-680098  smallint
              m2      LIKE aah_file.aah03,   #No.FUN-680098  smallint
              yy2     LIKE aah_file.aah02,   #No.FUN-680098  smallint 
              m3      LIKE aah_file.aah03,   #No.FUN-680098  smallint 
              m4      LIKE aah_file.aah03,   #No.FUN-680098  smallint
              afc01   LIKE afc_file.afc01,   #FUN-AB0020 add 
#             h       LIKE afa_file.afa01,   #No.FUN-680098  VARCHAR(4)         #No.FUN-830139
              choice  LIKE type_file.chr1,   #異動額及餘額為零者是否列印     #No.FUN-680098 VARCHAR(1)
              dec     LIKE azi_file.azi05,   #小數位數                       #No.FUN-680098 smallint
              cd      LIKE type_file.chr1,   #(1)借餘  (2)貸餘               #No.FUN-680098 VARCHAR(1)
              g       LIKE type_file.chr1,   #(1)本年  (2)上期 (3)本季       #No.FUN-680098 VARCHAR(1) 
              more    LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
              END RECORD
   DEFINE g_orderA      ARRAY[2] OF LIKE type_file.chr20   #No.FUN-680098  VARCHAR(10)
   DEFINE g_totdiff     LIKE type_file.num20_6             #No.FUN-680098  dec(20,6)
#  DEFINE g_bookno      LIKE aaa_file.aaa01                #No.FUN-670039
 
   DEFINE bookno      LIKE aaa_file.aaa01               #No.FUN-740020 
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098  smallint
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
 
 
   LET bookno= ARG_VAL(1)     #No.FUN-740020
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
   LET tm.afc01 = ARG_VAL(17)  #FUN-AB0020 add
#  LET tm.h   = ARG_VAL(17)    #No.FUN-830139
   LET tm.choice  = ARG_VAL(18)
   LET tm.dec = ARG_VAL(19)
   LET tm.cd  = ARG_VAL(20)
   LET tm.g = ARG_VAL(21)   #TQC-610056
   LET tm.azh01 = ARG_VAL(22)   #TQC-610056
   LET tm.azh02 = ARG_VAL(23)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   #No.FUN-570264 ---end---
   IF cl_null(bookno) THEN    #No.FUN-740020
      LET bookno = g_aza.aza81 #No.FUN-740020
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r921_tm(0,0)
      ELSE CALL r921()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r921_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
   DEFINE l_azfacti      LIKE azf_file.azfacti        #FUN-AB0020 add  
     
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 4 END IF
   CALL s_dsmark(bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 4
   END IF
   OPEN WINDOW r921_w AT p_row,p_col
        WITH FORM "agl/42f/aglr921"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL  s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","aaa_file",bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.dec FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#    CALL cl_err('',SQLCA.sqlcode,0)  # NO.FUN-660123
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
   LET tm.s    = '12'
   LET tm.choice = 'N'
   LET tm.cd = 'N'
   LET tm.g='1'
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
      CLOSE WINDOW r921_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
  #IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF    #CHI-A20019 mark
 
   DISPLAY BY NAME tm.more
   INPUT BY NAME bookno,tm.azh01,tm.azh02,    #No.FUN-740020
                 tm.yy1,tm.m1,tm.m2,
                 tm.yy2,tm.m3,tm.m4,
#                tm.h,tm.dec,tm.g,            #No.FUN-830139 
                 tm.afc01,tm.dec,tm.g,        #No.FUN-830139   #FUN-AB0020 add tm.afc01 
                 tm.choice,tm.cd,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.more
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
#No.FUN-830139-begin
#        AFTER FIELD h
#           IF tm.h IS NULL THEN NEXT FIELD h END IF
#           SELECT afa01 FROM afa_file
#            WHERE afa01 = tm.h
#           IF SQLCA.sqlcode THEN
##             CALL cl_err(tm.h,'agl-005',0)   #No.FUN-660123
#              CALL cl_err3("sel","afa_file",tm.h,"","agl-005","","",0)   #No.FUN-660123
#              NEXT FIELD h
#           END IF
#No.FUN-830139-end

#FUN-AB0020--------------add--------------str--------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file  
             WHERE azf01 = tm.afc01 AND azf02 = '2'
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
              NEXT FIELD afc01
           ELSE
              SELECT azfacti INTO l_azfacti FROM azf_file
               WHERE azf01 = tm.afc01 AND azf02 = '2'
              IF l_azfacti = 'N' THEN
                 CALL cl_err(tm.afc01,'agl1002',0)
              END IF
           END IF                 
        END IF
#FUN-AB0020--------------add-------------end-----------
 
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
#No.FUN-830139--begin
#                   WHEN INFIELD(h)
#	            CALL q_afa(10,16,tm.h,g_bookno) RETURNING tm.h
#	            CALL FGL_DIALOG_SETBUFFER( tm.h )
################################################################################
# START genero shell script ADD
#   CALL cl_init_qry_var()
#   LET g_qryparam.form = 'q_afa'                  #No.FUN-810069
#   LET g_qryparam.form = 'q_azf'                  #No.FUN-810069
#   LET g_qryparam.default1 = tm.h
#   LET g_qryparam.arg1 ='2'                       #No.FUN-810069 
#   CALL cl_create_qry() RETURNING tm.h
#    CALL FGL_DIALOG_SETBUFFER( tm.h )
# END genero shell script ADD
################################################################################
#          DISPLAY BY NAME tm.h
#           NEXT FIELD h
#No.FUN-830139--end
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
      CLOSE WINDOW r921_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aglr921'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr921','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",bookno CLIPPED,"'",     #No.FUN-740020
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
                         " '",tm.afc01 CLIPPED,"'",   #FUN-AB0020 add
#                        " '",tm.h CLIPPED,"'",                #No.FUN-830139
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.dec CLIPPED,"'",
                         " '",tm.cd CLIPPED,"'" ,
                         " '",tm.g CLIPPED,"'" ,   #TQC-610056
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr921',g_time,l_cmd)
      END IF
      CLOSE WINDOW r921_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r921()
   ERROR ""
END WHILE
   CLOSE WINDOW r921_w
END FUNCTION
 
{
FUNCTION r921_wc()
#  DEFINE l_wc VARCHAR(300)   
   DEFINE l_wc STRING         #TQC-630166     
 
   OPEN WINDOW r921_w2 AT 2,2
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
   CLOSE WINDOW r921_w2
   LET g_wc = g_wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r921_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION r921()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
#         l_sql     VARCHAR(1000),                   # RDSQL STATEMENT      
          l_sql     STRING,           #TQC-630166 # RDSQL STATEMENT    
          l_chr     LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680098  VARCHAR(40)
          l_order   ARRAY[2] OF LIKE aag_file.aag223,          #No.FUN-680098 VARCHAR(4)
          sr               RECORD
                                  order1 LIKE aag_file.aag223, #No.FUN-680098  VARCHAR(4)
                                  order2 LIKE aag_file.aag223, #No.FUN-680098  VARCHAR(4)
                                  aag01  LIKE aag_file.aag01,
                                  aag06  LIKE aag_file.aag06,
                                  aag223 LIKE aag_file.aag223,
                                  aag224 LIKE aag_file.aag224,
                                  aag225 LIKE aag_file.aag225,
                                  aag226 LIKE aag_file.aag226,
                                  amt1   LIKE aah_file.aah04,
                                  amt1f  LIKE aah_file.aah04,
                                  diff1  LIKE aah_file.aah04,
                                  amt2   LIKE aah_file.aah05,
                                  amt2f  LIKE aah_file.aah05,
                                  diff2  LIKE aah_file.aah05
                        END RECORD
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno     #No.FUN-740020
			AND aaf02 = g_rlang
     #資料權限的檢查
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
                 "   AND aag00 = '",bookno,"'"     #No.FUN-740020
     PREPARE r921_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r921_curs1 CURSOR FOR r921_prepare1
#    LET l_name = 'aglr921.out'
     CALL cl_outnam('aglr921') RETURNING l_name
     START REPORT r921_rep TO l_name
     LET g_pageno = 0
     LET g_totdiff = 0
     FOREACH r921_curs1 INTO sr.aag223,sr.aag224,sr.aag225,sr.aag226,
                             sr.aag01,sr.aag06
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#------------------------------------------------------------------------
          SELECT SUM(aah04-aah05) INTO sr.amt1 FROM aah_file
            WHERE aah01=sr.aag01
              AND aah02 = tm.yy1 AND aah03 BETWEEN tm.m1 AND tm.m2
              AND aah00 = bookno  #no.7277    #No.FUN-740020
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Select aah error !',SQLCA.SQLCODE,1)   #No.FUN-660123
               CALL cl_err3("sel","aah_file",tm.yy1,bookno,SQLCA.sqlcode,"","Select aah error !",1)   #No.FUN-660123
               EXIT FOREACH
            END IF	
{??}      IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
#------------------------------------------------------------------------
          IF cl_null(tm.afc01) THEN                       #FUN-AB0020 add
            #SELECT SUM(afc06) INTO sr.amt1f                                                 #CHI-B60055 mark
             SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO sr.amt1f #CHI-B60055
               FROM afc_file
              WHERE afc00 = bookno                    #AND afc01 = tm.h   #No.FUN-740020 #No.FUN-830139
                AND afc02 = sr.aag01 AND afc04 = ' '    #MOD-9C0100 afc04 ='@' modify afc04 = ' '
                AND afc041='' AND afc042=''       #No.FUN-810069
                AND afc03 = tm.yy1 AND afc05 BETWEEN tm.m1 AND tm.m2
#FUN-AB0020-------------------add-----------------------str-------
          ELSE
            #SELECT SUM(afc06) INTO sr.amt1f                                                 #CHI-B60055 mark
             SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO sr.amt1f #CHI-B60055
               FROM afc_file
              WHERE afc00 = bookno  AND afc01 = tm.afc01   
                AND afc02 = sr.aag01 AND afc04 = ' '    #MOD-9C0100 afc04 ='@' modify afc04 = ' '
                AND afc041='' AND afc042=''       #No.FUN-810069
                AND afc03 = tm.yy1 AND afc05 BETWEEN tm.m1 AND tm.m2
         END IF
#FUN-AB0020-------------------add-----------------------end-----------
          IF sr.amt1f IS NULL THEN LET sr.amt1f=0 END IF
#------------------------------------------------------------------------
          SELECT SUM(aah04-aah05) INTO sr.amt2 FROM aah_file
            WHERE aah01=sr.aag01
            AND aah02 = tm.yy2 AND aah03 BETWEEN tm.m3 AND tm.m4
            AND aah00 = bookno #no.7277    #No.FUN-740020
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Select aah error !',SQLCA.SQLCODE,1)   #No.FUN-660123
               CALL cl_err3("sel","aah_file",sr.aag01,tm.yy2,SQLCA.sqlcode,"","Select aah error !",1)   #No.FUN-660123
               EXIT FOREACH
            END IF	
{??}      IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
#------------------------------------------------------------------------
          IF cl_null(tm.afc01) THEN                        #FUN-AB0020 add
            #SELECT SUM(afc06) INTO sr.amt2f                                                 #CHI-B60055 mark
             SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO sr.amt2f #CHI-B60055
               FROM afc_file
              WHERE afc00 = bookno                    #AND afc01 = tm.h    #No.FUN-740020 #No.FUN-830139
                AND afc02 = sr.aag01 AND afc04 = ' '    #MOD-9C0100 afc04 = '@' modify afc04 = ' '
                AND afc041='' AND afc042=''       #No.FUN-810069
                AND afc03 = tm.yy2 AND afc05 BETWEEN tm.m3 AND tm.m4
#FUN-AB0020-------------------add-----------------------str----------          
          ELSE
            #SELECT SUM(afc06) INTO sr.amt2f                                                 #CHI-B60055 mark
             SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO sr.amt2f #CHI-B60055
               FROM afc_file
              WHERE afc00 = bookno  AND afc01 = tm.afc01  
                AND afc02 = sr.aag01 AND afc04 = ' '    #MOD-9C0100 afc04 = '@' modify afc04 = ' '
                AND afc041='' AND afc042=''       #No.FUN-810069
                AND afc03 = tm.yy2 AND afc05 BETWEEN tm.m3 AND tm.m4
          END IF
#FUN-AB0020-------------------add-----------------------end-----------
          IF sr.amt2f IS NULL THEN LET sr.amt2f=0 END IF
#------------------------------------------------------------------------
          IF sr.aag06 = '2' THEN                #貸餘
             LET sr.amt1 = -1 * sr.amt1 LET sr.amt1f = -1 * sr.amt1f
             LET sr.amt2 = -1 * sr.amt2 LET sr.amt2f = -1 * sr.amt2f
          END IF
          IF tm.choice = 'N' AND
             sr.amt1 = 0 AND sr.amt2 = 0 AND sr.amt1f = 0 AND sr.amt2f = 0 THEN
             CONTINUE FOREACH
          END IF
          LET sr.diff1 = sr.amt1 - sr.amt1f
          LET sr.diff2 = sr.amt2 - sr.amt2f
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
          OUTPUT TO REPORT r921_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r921_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r921_rep(sr)
DEFINE l_last_sw        LIKE type_file.chr1                  #No.FUN-680098  VARCHAR(1)
DEFINE sr               RECORD
                        order1 LIKE aag_file.aag223,         #No.FUN-680098  VARCHAR(4)
                        order2 LIKE aag_file.aag223,         #No.FUN-680098  VARCHAR(4)
                        aag01  LIKE aag_file.aag01,
                        aag06  LIKE aag_file.aag06,
                        aag223 LIKE aag_file.aag223,
                        aag224 LIKE aag_file.aag224,
                        aag225 LIKE aag_file.aag225,
                        aag226 LIKE aag_file.aag226,
                        amt1   LIKE aah_file.aah04,
                        amt1f  LIKE aah_file.aah04,
                        diff1  LIKE aah_file.aah04,
                        amt2   LIKE aah_file.aah05,
                        amt2f  LIKE aah_file.aah05,
                        diff2  LIKE aah_file.aah05
                        END RECORD
DEFINE l_aae02          LIKE aae_file.aae02
DEFINE l_posistion      LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE l_amt1,l_amt2,l_amt1f,l_amt2f,l_diff1,l_diff2 LIKE aah_file.aah04
DEFINE amt1f,amt2f LIKE aah_file.aah04
DEFINE g_zaa44          STRING
DEFINE g_zaa43          STRING
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1, sr.order2
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT g_x[26] CLIPPED,tm.h
      PRINT COLUMN 69,g_x[11] CLIPPED,
            g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED
      PRINT g_dash[1,g_len]
     #PRINT COLUMN 27,'|<----------------- ',
     #         tm.yy1 USING '####','/',tm.m1 USING '##','-',tm.m2 USING '<#',
     #                ' ----------------->| |<----------------- ',
     #         tm.yy2 USING '####','/',tm.m3 USING '##','-',tm.m4 USING '<#',
     #                ' ----------------->|'
#      LET g_zaa43='****************************',tm.yy1 USING '####','/',tm.m1 USING '##','-',tm.m2 USING '<#','*********************************'   #TQC-5B0045
      LET g_zaa43='****************************',tm.yy1 USING '####','/',tm.m1 USING '##','-',tm.m2 USING '<#','********************************'     #TQC-5B0045
#      LET g_zaa44='****************************',tm.yy2 USING '####','/',tm.m3 USING '##','-',tm.m4 USING '<#','*********************************'   #TQC-5B0045
      LET g_zaa44='****************************',tm.yy2 USING '####','/',tm.m3 USING '##','-',tm.m4 USING '<#','********************************'     #TQC-5B0045
#     PRINT COLUMN 27,'********************',tm.yy1 USING '####','/',tm.m1 USING '##','-',tm.m2 USING '<#','**************************',
#           COLUMN 85,'********************',tm.yy2 USING '####','/',tm.m3 USING '##','-',tm.m4 USING '<#','**************************'
#     PRINT COLUMN 01, g_x[12] CLIPPED,
#          #COLUMN 31, g_x[13] CLIPPED,'   %       ';
#          #本期實際       本期預算       本期差異
#           COLUMN 27,g_x[31] CLIPPED,
#           COLUMN 44,g_x[32] CLIPPED,
#           COLUMN 61,g_x[33] CLIPPED,
#           COLUMN 78,'%';
      IF tm.g = '1' THEN
        #本年實際       本年預算本年差異
        #PRINT COLUMN 81,g_x[24] CLIPPED,'   % '
#        PRINT COLUMN  85,g_x[37] CLIPPED,
#              COLUMN 102,g_x[38] CLIPPED,
#              COLUMN 119,g_x[39] CLIPPED,
#              COLUMN 136,'%'
        LET g_zaa[51].zaa08=g_x[37] CLIPPED
        LET g_zaa[52].zaa08=g_x[38] CLIPPED
        LET g_zaa[53].zaa08=g_x[39]
      ELSE
         IF tm.g = '2' THEN
           #上期實際       上期預算       上期差異
           #PRINT COLUMN 81,g_x[14] CLIPPED,'   % '
#           PRINT COLUMN  85,g_x[34] CLIPPED,
#                 COLUMN 102,g_x[35] CLIPPED,
#                 COLUMN 119,g_x[36] CLIPPED,
#                 COLUMN 136,'%'
 
        LET g_zaa[51].zaa08=g_x[34] CLIPPED
        LET g_zaa[52].zaa08=g_x[35] CLIPPED
        LET g_zaa[53].zaa08=g_x[36]
         ELSE
           #本季實際       本季預算       本季差異
           #PRINT COLUMN 81,g_x[25] CLIPPED,'   % '
#           PRINT COLUMN  85,g_x[40] CLIPPED,
#                 COLUMN 102,g_x[41] CLIPPED,
#                 COLUMN 119,g_x[42] CLIPPED,
#                 COLUMN 136,'%'
        LET g_zaa[51].zaa08=g_x[40] CLIPPED
        LET g_zaa[52].zaa08=g_x[41] CLIPPED
        LET g_zaa[53].zaa08=g_x[42]
 
         END IF
      END IF
      PRINT COLUMN 27,g_zaa43 ,COLUMN 98,g_zaa44
      PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54]
#     PRINT COLUMN 01,'-------------------------',
#           COLUMN 27,'---------------- ---------------- ---------------- -----',
#           COLUMN 85,'---------------- ---------------- ---------------- -----'
      PRINT g_dash1
#No.FUN-580010--end
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      SELECT aae02 INTO l_aae02 FROM aae_file
        WHERE aae01 = sr.order1
      IF SQLCA.SQLCODE THEN LET l_aae02 = NULL END IF
#No.FUN-580010--start
#     PRINT COLUMN 01, sr.order1,
#           COLUMN 06, l_aae02
      PRINT COLUMN g_c[45], sr.order1,
            COLUMN g_c[46], l_aae02
#No.FUN-580010--end
      SKIP 1 LINE
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
 
   AFTER GROUP OF sr.order2
      SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order2
      IF SQLCA.SQLCODE THEN LET l_aae02 = NULL END IF
      LET l_amt1 = GROUP SUM(sr.amt1)
      LET l_amt1f= GROUP SUM(sr.amt1f)
      LET l_diff1= GROUP SUM(sr.diff1)
      LET l_amt2 = GROUP SUM(sr.amt2)
      LET l_amt2f= GROUP SUM(sr.amt2f)
      LET l_diff2= GROUP SUM(sr.diff2)
      LET amt1f = l_amt1f  IF l_amt1f= 0 THEN LET amt1f= NULL END IF
      LET amt2f = l_amt2f  IF l_amt2f= 0 THEN LET amt2f= NULL END IF
#No.FUN-580010--start
#         PRINT sr.order2,' ',l_aae02,
#               COLUMN  27,cl_numfor(l_amt1 ,15,tm.dec) CLIPPED,
#               COLUMN  44,cl_numfor(l_amt1f,15,tm.dec) CLIPPED,
#               COLUMN  61,cl_numfor(l_diff1,15,tm.dec) CLIPPED,
#               COLUMN  78,l_diff1/amt1f*100 USING '----&','%',
#               COLUMN  85,cl_numfor(l_amt2 ,15,tm.dec) CLIPPED,
#               COLUMN 102,cl_numfor(l_amt2f,15,tm.dec) CLIPPED,
#               COLUMN 119,cl_numfor(l_diff2,15,tm.dec) CLIPPED,
#               COLUMN 136,l_diff2/amt2f*100 USING '----&','%'
          PRINT COLUMN g_c[45],sr.order2,
                COLUMN g_c[46],l_aae02,
                COLUMN g_c[47],cl_numfor(l_amt1 ,47,tm.dec) CLIPPED,
                COLUMN g_c[48],cl_numfor(l_amt1f,48,tm.dec) CLIPPED,
                COLUMN g_c[49],cl_numfor(l_diff1,49,tm.dec) CLIPPED,
                COLUMN g_c[50],l_diff1/amt1f*100 USING '----&','%',
                COLUMN g_c[51],cl_numfor(l_amt2 ,51,tm.dec) CLIPPED,
                COLUMN g_c[52],cl_numfor(l_amt2f,52,tm.dec) CLIPPED,
                COLUMN g_c[53],cl_numfor(l_diff2,53,tm.dec) CLIPPED,
                COLUMN g_c[54],l_diff2/amt2f*100 USING '----&','%'
   AFTER GROUP OF sr.order1
      SELECT aae02 INTO l_aae02 FROM aae_file WHERE aae01 = sr.order1
      IF SQLCA.SQLCODE THEN LET l_aae02 = NULL END IF
      LET l_amt1 = GROUP SUM(sr.amt1)
      LET l_amt1f= GROUP SUM(sr.amt1f)
      LET l_diff1= GROUP SUM(sr.diff1)
      LET l_amt2 = GROUP SUM(sr.amt2)
      LET l_amt2f= GROUP SUM(sr.amt2f)
      LET l_diff2= GROUP SUM(sr.diff2)
      LET amt1f = l_amt1f  IF l_amt1f= 0 THEN LET amt1f= NULL END IF
      LET amt2f = l_amt2f  IF l_amt2f= 0 THEN LET amt2f= NULL END IF
      CALL r921_cha(l_aae02) RETURNING l_posistion
#No.FUN-580010--start
#     PRINT COLUMN 27,'---------------- ---------------- ---------------- -----',
#           COLUMN 85,'---------------- ---------------- ---------------- -----'
      PRINT COLUMN g_c[47],g_dash2[1,g_w[47]],
            COLUMN g_c[48],g_dash2[1,g_w[48]],
            COLUMN g_c[49],g_dash2[1,g_w[49]],
            COLUMN g_c[50],g_dash2[1,g_w[50]],
            COLUMN g_c[51],g_dash2[1,g_w[51]],
            COLUMN g_c[52],g_dash2[1,g_w[52]],
            COLUMN g_c[53],g_dash2[1,g_w[53]],
            COLUMN g_c[54],g_dash2[1,g_w[54]]
#No.FUN-580010--end
      LET l_last_sw = 'n'
#No.FUN-580010--start
#     PRINT COLUMN l_posistion, l_aae02 CLIPPED,            #印"合計"
#           COLUMN  21, g_x[18] CLIPPED,
#           COLUMN  27,cl_numfor(l_amt1,15,tm.dec) CLIPPED,
#           COLUMN  44,cl_numfor(l_amt1f,15,tm.dec) CLIPPED,
#           COLUMN  61,cl_numfor(l_diff1,15,tm.dec) CLIPPED,
#           COLUMN  78,l_diff1/amt1f*100 USING '----&','%',
#           COLUMN  85,cl_numfor(l_amt2,15,tm.dec) CLIPPED,
#           COLUMN 102,cl_numfor(l_amt2f,15,tm.dec) CLIPPED,
#           COLUMN 119,cl_numfor(l_diff2,15,tm.dec) CLIPPED,
#           COLUMN 136,l_diff2/amt2f*100 USING '----&','%'
      PRINTX name=S1
            COLUMN g_c[46], l_aae02 CLIPPED,g_x[18] CLIPPED,            #印"合計"
            COLUMN g_c[47],cl_numfor(l_amt1,47,tm.dec) CLIPPED,
            COLUMN g_c[48],cl_numfor(l_amt1f,48,tm.dec) CLIPPED,
            COLUMN g_c[49],cl_numfor(l_diff1,49,tm.dec) CLIPPED,
            COLUMN g_c[50],l_diff1/amt1f*100 USING '----&','%',
            COLUMN g_c[51],cl_numfor(l_amt2,51,tm.dec) CLIPPED,
            COLUMN g_c[52],cl_numfor(l_amt2f,52,tm.dec) CLIPPED,
            COLUMN g_c[53],cl_numfor(l_diff2,53,tm.dec) CLIPPED,
            COLUMN g_c[54],l_diff2/amt2f*100 USING '----&','%'
#No.FUN-580010--end
      SKIP 1 LINE
   ON LAST ROW
      IF tm.cd = 'Y' THEN
      LET l_amt1 = SUM(sr.amt1)
      LET l_amt1f= SUM(sr.amt1f)
      LET l_diff1= SUM(sr.diff1)
      LET l_amt2 = SUM(sr.amt2)
      LET l_amt2f= SUM(sr.amt2f)
      LET l_diff2= SUM(sr.diff2)
      LET amt1f = l_amt1f  IF l_amt1f= 0 THEN LET amt1f= NULL END IF
      LET amt2f = l_amt2f  IF l_amt2f= 0 THEN LET amt2f= NULL END IF
#No.FUN-580010--start
#     PRINT g_x[19] CLIPPED,             #印"總合計"
#           COLUMN  27,cl_numfor(l_amt1,15,tm.dec) CLIPPED,
#           COLUMN  44,cl_numfor(l_amt1f,15,tm.dec) CLIPPED,
#           COLUMN  61,cl_numfor(l_diff1,15,tm.dec) CLIPPED,
#           COLUMN  78,l_diff1/amt1f*100 USING '----&','%',
#           COLUMN  85,cl_numfor(l_amt2,15,tm.dec) CLIPPED,
#           COLUMN 102,cl_numfor(l_amt2f,15,tm.dec) CLIPPED,
#           COLUMN 119,cl_numfor(l_diff2,15,tm.dec) CLIPPED,
#           COLUMN 136,l_diff2/amt2f*100 USING '----&','%'
      PRINTX name=S1
            COLUMN g_c[46],g_x[19] CLIPPED,             #印"總合計"
            COLUMN g_c[47],cl_numfor(l_amt1,47,tm.dec) CLIPPED,
            COLUMN g_c[48],cl_numfor(l_amt1f,48,tm.dec) CLIPPED,
            COLUMN g_c[49],cl_numfor(l_diff1,49,tm.dec) CLIPPED,
            COLUMN g_c[50],l_diff1/amt1f*100 USING '----&','%',
            COLUMN g_c[51],cl_numfor(l_amt2,51,tm.dec) CLIPPED,
            COLUMN g_c[52],cl_numfor(l_amt2f,52,tm.dec) CLIPPED,
            COLUMN g_c[53],cl_numfor(l_diff2,53,tm.dec) CLIPPED,
            COLUMN g_c[54],l_diff2/amt2f*100 USING '----&','%'
#No.FUN-580010--end
      END IF
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(g_wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING g_wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF g_wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
         #     IF g_wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
         #     IF g_wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
         #     IF g_wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     g_wc[211,280] CLIPPED END IF
#             IF g_wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,g_wc[001,120] CLIPPED END IF
#             IF g_wc[921,240] > ' ' THEN
#         PRINT COLUMN 10,     g_wc[921,240] CLIPPED END IF
#             IF g_wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     g_wc[241,300] CLIPPED END IF
          CALL cl_prt_pos_wc(g_wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION r921_cha(l_cha)
DEFINE l_cha     LIKE type_file.chr20            #No.FUN-680098 VARCHAR(20)
DEFINE l_leng    LIKE type_file.num5             #No.FUN-680098 smallint 
DEFINE l_result  LIKE type_file.num5             #No.FUN-680098 smallint 
 
   LET l_leng = LENGTH (l_cha)
   LET l_result = 21 - l_leng
   RETURN l_result
END FUNCTION
#Patch....NO.TQC-610035 <> #
