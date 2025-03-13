# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: aglr101.4gl
# Descriptions...: 營業成本明細表
# ------------------MODIFICATION-----------------------
# 98/08/03 By Gunter:報表列印族群編號可輸入部門層級編號
# -----------------------------------------------------
# Modify.........: 98/12/10 By Iris 增加金額分號及比率取至小數二位
# Modified By Thomas 99/01/11 增加處理maj06
#                                     maj07
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By judy 新增打印額外名稱欄位
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-6B0021 07/03/14 By jamie 族群欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By lora 會計科目加帳套
# Modify.........: No.TQC-810051 08/01/16 By Smapmin 族群的最後一個部門若金額皆為0,當金額為0不印出時,整個族群都印不出來.
#                                                    合計金額皆為0;報表抬頭沒對齊.
# Modify.........: No.FUN-830053 08/03/17 By johnray 結構報表改CR
# Modify.........: No.MOD-860310 08/06/26 By wujie   sql語句有錯
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-920312 09/02/24 By Dido 修改 maj02 宣告
# Modify.........: No.MOD-970236 09/07/27 By mike 將aglr101_file里的maj20e改為定義成LIKE maj_file.maj20e                            
# Modify.........: No.MOD-970245 09/07/27 By mike 將4gl里用到l_name1的部份都mark掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-D30245 13/03/27 By apo 報表金額應為正數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           a       LIKE type_file.chr6,     #報表結構編號 #No.FUN-680098   VARCHAR(6)   
           b       LIKE aaa_file.aaa01,   #帳別編號     #No.FUN-670039
           abe01   LIKE abe_file.abe01,   #列印族群/部門層級/部門#No.FUN-680098 VARCHAR(6)
           yy      LIKE type_file.num5,   #輸入年度     #No.FUN-680098  smallint
           bm      LIKE type_file.num5,   #Begin 期別   #No.FUN-680098  smallint   
           em      LIKE type_file.num5,   # End  期別   #No.FUN-680098  smallint   
           c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1)     
           d       LIKE type_file.chr1,   #金額單位        #No.FUN-680098  VARCHAR(1)   
           e       LIKE type_file.chr1,   #列印額外名稱 #FUN-6C0012
           f       LIKE type_file.num5,   #列印最小階數    #No.FUN-680098  smallint   
           more    LIKE type_file.chr1    #Input more condition(Y/N) #No.FUN-680098   VARCHAR(1)   
           END RECORD,
       i,j,k,g_mm  LIKE type_file.num5,         #No.FUN-680098    smallint 
       g_unit      LIKE type_file.num10,        #金額單位基數   #No.FUN-680098    integer 
       g_buf       LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(600)
       g_cn        LIKE type_file.num5,         #No.FUN-680098   smallint  
       g_flag      LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
       g_bookno    LIKE aah_file.aah00,   #帳別
       g_gem05     LIKE gem_file.gem05,
#       m_dept      LIKE type_file.chr1000,      #No.FUN-680098  VARCHAR(300)   #No.FUN-830053 mark
       m_dept     DYNAMIC ARRAY OF LIKE gem_file.gem02,   #No.FUN-830053 add
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_abd01     LIKE abd_file.abd01,
       g_abe01     LIKE abe_file.abe01,
       g_total DYNAMIC ARRAY OF RECORD
               maj02  LIKE maj_file.maj02,
               amt    LIKE type_file.num20_6             #No.FUN-680098  dec(20,6)
               END RECORD,
       g_tot1  ARRAY[100] OF  LIKE type_file.num20_6,    #No.FUN-680098  dec(20,6)   
               g_no   LIKE type_file.num5,                     #No.FUN-680098  smallint
       g_dept  DYNAMIC ARRAY OF RECORD
               gem01  LIKE gem_file.gem01, #部門編號
               gem05  LIKE gem_file.gem05  #是否為會計部門
               END RECORD
 
DEFINE g_aaa03 LIKE aaa_file.aaa03
DEFINE g_i     LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
#No.FUN-830053 -- begin --
DEFINE g_sql   STRING
DEFINE l_table STRING                  #MOD-9A0192 mod chr20->STRING
DEFINE g_str   STRING
#No.FUN-830053 -- end --
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047
 
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   #TQC-610056
   LET tm.abe01= ARG_VAL(10)
   LET tm.yy   = ARG_VAL(11)
   LET tm.bm   = ARG_VAL(12)
   LET tm.em   = ARG_VAL(13)
   LET tm.c    = ARG_VAL(14)
   LET tm.d    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
   LET tm.e    = ARG_VAL(20)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
 
   DROP TABLE aglr101_file
# Thomas 98/11/17
#No.FUN-830053 -- begin --
   LET g_sql = "maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,",
               "maj04.maj_file.maj04,",
               "maj05.maj_file.maj05,",
               "maj07.maj_file.maj07,",
               "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "page.type_file.num5,",
               "m_dept1.gem_file.gem02,",
               "m_dept2.gem_file.gem02,",
               "m_dept3.gem_file.gem02,",
               "m_dept4.gem_file.gem02,",
               "m_dept5.gem_file.gem02,",
               "m_dept6.gem_file.gem02,",
               "m_dept7.gem_file.gem02,",
               "m_dept8.gem_file.gem02,",
               "m_dept9.gem_file.gem02,",
               "m_dept10.gem_file.gem02,",
               "l_str1.type_file.chr20,",
               "l_str2.type_file.chr20,",
               "l_str3.type_file.chr20,",
               "l_str4.type_file.chr20,",
               "l_str5.type_file.chr20,",
               "l_str6.type_file.chr20,",
               "l_str7.type_file.chr20,",
               "l_str8.type_file.chr20,",
               "l_str9.type_file.chr20,",
               "l_str10.type_file.chr20,",
               "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglr101',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-830053 -- end --
#FUN-680098-BEGIN
   CREATE TEMP TABLE aglr101_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,  #MOD-920312 修改 cot_file.cot12
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e, #MOD-970236 abh11-->maj20e
       bal1      LIKE type_file.num20_6)
#FUN-680098-END
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81  END IF          #No.FUN-740020
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r101_tm()                        # Input print condition
   ELSE
      CALL r101()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r101_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098     SMALLINT
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098   VARCHAR(1)   
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5           #No.FUN-670005  #No.FUN-680098  smallint  
   DEFINE li_result      LIKE type_file.num5           #No.FUN-6C0068 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r101_w AT p_row,p_col WITH FORM "agl/42f/aglr101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81  END IF          #No.FUN-740020
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b   #No.FUN-740020
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)  # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   # NO.FUN-660123  #No.FUN-740020
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
#   LET tm.b = g_bookno   #No.FUN-740020
   LET tm.b = g_aza.aza81   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more    #FUN-6C0012  #No.FUN-740020
		  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b                #No.FUN-740032
         IF STATUS THEN 
#           CALL cl_err('sel mai:',STATUS,0)  # NO.FUN-660123
            CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   # NO.FUN-660123 
            NEXT FIELD a
        #No.TQC-C50042   ---start---   Add
         ELSE
            IF g_mai03 = '5' OR g_mai03 = '6' THEN
               CALL cl_err('','agl-268',0)
               NEXT FIELD a
            END IF
        #No.TQC-C50042   ---end---     Add
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN
            NEXT FIELD b END IF 
         #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
          #No.FUN-670005--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#           CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   # NO.FUN-660123
            NEXT FIELD b
         END IF
 
      AFTER FIELD abe01
         IF cl_null(tm.abe01) THEN NEXT FIELD abe01 END IF
 
         SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
         IF STATUS=100 THEN
           LET g_abe01 =' '
           SELECT UNIQUE abd01 INTO g_abd01 FROM abd_file WHERE abd01=tm.abe01
           IF STATUS=100 THEN
             LET g_abd01=' '
             SELECT gem05 INTO g_gem05 FROM gem_file WHERE gem01=tm.abe01
             IF STATUS THEN NEXT FIELD abe01 END IF
           END IF
         ELSE
           IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em
        END IF
        IF tm.d = '1' THEN LET g_unit = 1       END IF
        IF tm.d = '2' THEN LET g_unit = 1000    END IF
        IF tm.d = '3' THEN LET g_unit = 1000000 END IF
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
#              CALL q_mai(0,0,tm.a,tm.a) RETURNING tm.a
#              CALL FGL_DIALOG_SETBUFFER( tm.a )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6') "    #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
#               CALL FGL_DIALOG_SETBUFFER( tm.a )
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(b)
#              CALL q_aaa(0,0,tm.b) RETURNING tm.b
#              CALL FGL_DIALOG_SETBUFFER( tm.b )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
#               CALL FGL_DIALOG_SETBUFFER( tm.b )
               DISPLAY BY NAME tm.b
               NEXT FIELD b
 
           #FUN-6B0021---add---str---
            WHEN INFIELD(abe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_abe'
               LET g_qryparam.default1 = tm.abe01
               CALL cl_create_qry() RETURNING tm.abe01
               DISPLAY BY NAME tm.abe01
               NEXT FIELD abe01
           #FUN-6B0021---add---end---
 
      END CASE
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr101','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610056
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",                 #FUN-6C0012
                         " '",tm.f CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr101',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
END WHILE
   CLOSE WINDOW r101_w
END FUNCTION
 
FUNCTION r101()
   DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
  #DEFINE l_name1   LIKE type_file.chr20         # External(Disk) file name        #No.FUN-680098  VARCHAR(20) #MOD-970245
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT  #No.FUN-680098   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098     VARCHAR(1)
   DEFINE l_leng,l_leng2  LIKE type_file.num5    #No.FUN-680098     smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_abd02   LIKE abd_file.abd02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01
   DEFINE l_maj20   LIKE maj_file.maj20,             #No.FUN-680098     VARCHAR(30)
          l_bal     LIKE type_file.num20_6           #No.FUN-680098     dec(20,6)
   DEFINE sr  RECORD
              no        LIKE type_file.num5,         #No.FUN-680098     smallint
              maj02     LIKE maj_file.maj02,   
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              bal1      LIKE type_file.num20_6      #實際      #No.FUN-680098    dec(20,8) 
              END RECORD
   DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e
              END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5       LIKE type_file.chr20      #No.FUN-680098  VARCHAR(20)     
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10      LIKE type_file.chr20      #No.FUN-680098  VARCHAR(20)   
#   DEFINE l_str,l_totstr        LIKE type_file.chr1000         #No.FUN-680098    VARCHAR(300)  #No.FUN-830053 mark
   DEFINE m_abd02 LIKE abd_file.abd02 
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5          #No.FUN-680098   smallint
   DEFINE l_cmd,l_cmd1,l_cmd2     LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(400)
#   DEFINE l_amt         LIKE type_file.num20_6                 #No.FUN-680098    dec(20,6)  #No.FUN-830053 mark
   DEFINE l_amtstr DYNAMIC ARRAY OF LIKE type_file.chr20    #No.FUN-830053 add
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,                   #No.FUN-680098   VARCHAR(1)   
          l_zero2       LIKE type_file.chr1                    #No.FUN-680098   VARCHAR(1)   
 
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   #FUN-6C0012.....begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr101'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 223 END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr101'
#No.FUN-830053 -- begin --
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
#No.FUN-830053 -- end --
   IF tm.e = 'Y' THEN
      LET g_len = 250
   ELSE
      LET g_len = 290
   END IF
   #FUN-6C0012.....end 
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' AND maj23[1,1]='2' ",
               " ORDER BY maj02"
   PREPARE r101_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r101_c CURSOR FOR r101_p
 
   LET g_mm = tm.em
   LET l_i=1
   FOR l_i = 1 TO 300
       LET g_total[l_i].maj02 = NULL
       LET g_total[l_i].amt = 0
   END FOR
   LET g_i = 1 FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR
#   CALL cl_outnam('aglr101') RETURNING l_name  #No.FUN-830053
 
#將部門填入array------------------------------------
   LET g_buf = ''
   IF g_abe01 = ' ' THEN
      IF g_abd01 = ' ' THEN                   #--- 部門
         LET g_no = 1
         LET g_dept[g_no].gem01 = tm.abe01
         LET g_dept[g_no].gem05 = g_gem05
      ELSE                                    #--- 部門層級
         LET g_no=0
         DECLARE r192_bom1 CURSOR FOR SELECT abd02,gem05 FROM abd_file,gem_file
                                       WHERE abd01=tm.abe01 AND gem01=abd02
                                       ORDER BY 1
         FOREACH r192_bom1 INTO l_abd02,l_chr
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
            LET g_no = g_no + 1
            LET g_dept[g_no].gem01 = l_abd02
            LET g_dept[g_no].gem05 = l_chr
         END FOREACH
      END IF
 
   ELSE                                      #--- 族群
      LET g_no = 0
      DECLARE r192_bom2 CURSOR FOR SELECT abe03,gem05 FROM abe_file,gem_file
                                    WHERE abe01=tm.abe01 AND gem01=abe03
                                    ORDER BY 1
      FOREACH r192_bom2 INTO l_abe03,l_chr
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_dept[g_no].gem01 = l_abe03
         LET g_dept[g_no].gem05 = l_chr
      END FOREACH
   END IF
#---------------------------------------------------
#控制一次印十個部門---------------------------------
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   LET l_i = 0
   FOR l_i = 10 TO l_cnt STEP 10
      LET g_flag = 'n'
     #LET l_name1='r101_',l_i/10 USING '&&&','.out' #MOD-970245
#     START REPORT r101_rep TO l_name1   #No.FUN-830053 mark
      LET g_cn = 0
      LET g_pageno = 0
      DELETE FROM aglr101_file
#      LET m_dept = ''   #No.FUN-830053 mark
      CALL m_dept.clear()          #No.FUN-830053 add
      IF l_i <= g_no THEN
         LET l_no = l_i - 10
         FOR l_cn = 1 TO 10
            LET g_i = 1
            FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
            LET g_buf = ''
            LET l_dept = g_dept[l_no+l_cn].gem01
            LET l_chr  = g_dept[l_no+l_cn].gem05
            LET l_gem02 = ''
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
            #-----TQC-810051---------
            #LET l_leng2 = LENGTH(l_gem02_o)
            #LET l_leng2 = 16 - l_leng2
            LET l_leng2 = FGL_WIDTH(l_gem02_o)
            LET l_leng2 = 18 - l_leng2
            #-----END TQC-810051-----
#No.FUN-830053 -- begin --
#            IF l_cn = 1 THEN
#               LET m_dept = l_gem02
#            ELSE
#               #LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,l_gem02   #TQC-810051
#               LET m_dept = m_dept CLIPPED,l_leng2 SPACES,1 SPACES,l_gem02   #TQC-810051
#            END IF
            LET m_dept[l_cn] = l_gem02
#No.FUN-830053 -- end --
            CALL r101_bom(l_dept,l_chr)
            IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
            LET l_leng=LENGTH(g_buf)
            LET g_buf=g_buf[1,l_leng-1] CLIPPED
            CALL r101_process(l_cn)
            LET g_cn = l_cn
            LET l_gem02_o = l_gem02
         END FOR
      ELSE
         LET l_no = (l_i - 10)
         FOR l_cn = 1 TO (g_no - (l_i - 10))
            LET g_i = 1
            FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
            LET g_buf = ''
            LET l_dept = g_dept[l_no+l_cn].gem01
            LET l_chr  = g_dept[l_no+l_cn].gem05
            LET l_gem02 = ''
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
            #-----TQC-810051---------
            #LET l_leng2 = LENGTH(l_gem02_o)
            #LET l_leng2 = 16 - l_leng2
            LET l_leng2 = FGL_WIDTH(l_gem02_o)
            LET l_leng2 = 18 - l_leng2
            #-----END TQC-810051-----
#No.FUN-830053 -- end --
#            IF l_cn = 1 THEN
#               LET m_dept = l_gem02
#            ELSE
#               #LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,l_gem02   #TQC-810051
#               LET m_dept = m_dept CLIPPED,l_leng2 SPACES,1 SPACES,l_gem02   #TQC-810051
#            END IF
            LET m_dept[l_cn] = l_gem02
#No.FUN-830053 -- end --
            CALL r101_bom(l_dept,l_chr)
            IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
            LET l_leng=LENGTH(g_buf)
            LET g_buf=g_buf[1,l_leng-1] CLIPPED
            CALL r101_process(l_cn)
            LET g_cn = l_cn
            LET l_gem02_o = l_gem02
         END FOR
         LET l_leng2 = LENGTH(l_gem02)
         LET l_leng2 = 16 - l_leng2
         #-----TQC-810051---------
         #LET l_leng2 = LENGTH(l_gem02)
         #LET l_leng2 = 16 - l_leng2
         LET l_leng2 = FGL_WIDTH(l_gem02)
         LET l_leng2 = 18 - l_leng2
         #-----END TQC-810051-----
         #LET m_dept = m_dept CLIPPED,l_leng2 SPACES,3 SPACES,'合  計' #TQC-810051
#         LET m_dept = m_dept CLIPPED,l_leng2 SPACES,1 SPACES,'合計'   #TQC-810051  #No.FUN-830053 mark
         LET m_dept[g_cn+1] = '合  計'                                 #No.FUN-830053 add
         LET g_flag = 'y'
      END IF
      #add NO:4404--
      IF l_i > g_no AND (g_no MOD 10) = 0  THEN
         FOR i = 1 TO 300
            IF g_total[i].maj02 IS NOT NULL THEN
               SELECT maj02,maj03,maj04,maj05,maj07,maj20,maj20e INTO sr1.*
                 FROM maj_file
                WHERE maj01 = tm.a
                  AND maj02 = g_total[i].maj02
               IF sr1.maj03 = '%' THEN
#                  LET l_totstr = g_total[i].amt USING '--------&.&&',' %'    #No.FUN-830053 mark
                  LET l_amtstr[1] = g_total[i].amt USING '--------&.&&',' %'  #No.FUN-830053 add
               ELSE
#                  LET l_totstr = g_total[i].amt USING '--,---,---,---,--&'   #No.FUN-830053 mark
                  LET l_amtstr[1] = g_total[i].amt USING '--,---,---,---,--&' #No.FUN-830053 add
               END IF
#               LET l_str = l_totstr CLIPPED                                  #No.FUN-830053 mark
               #表頭不應該列印金額
               IF sr1.maj03 = 'H' THEN
#                  LET l_str = NULL                                           #No.FUN-830053 mark
                  CALL l_amtstr.clear()                                       #No.FUN-830053 add
               END IF
               #add by chien 02/01/14
               IF (tm.c='N' OR sr1.maj03='2') AND
                  sr1.maj03 MATCHES "[0125]"  AND g_total[i].amt = 0 THEN
                  CONTINUE FOR
               END IF
#No.FUN-830053 -- begin --
#              OUTPUT TO REPORT r101_rep(sr1.*,l_str)
               IF sr1.maj04 = 0 THEN
                  EXECUTE insert_prep USING sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                                            m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                            m_dept[8],m_dept[9],m_dept[10],
                                            l_amtstr[1],'','','','','','','','','','2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOR
                  END IF
               ELSE
                  EXECUTE insert_prep USING sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                                            m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                            m_dept[8],m_dept[9],m_dept[10],
                                            l_amtstr[1],'','','','','','','','','','2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOR
                  END IF
                  #空行的部份,以寫入同樣的maj20資料列進Temptable,
                  #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
                  #讓空行的這筆資料排在正常的資料前面印出
                  FOR i = 1 TO sr.maj04
                     EXECUTE insert_prep USING sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                                               m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                               m_dept[8],m_dept[9],m_dept[10],
                                               l_amtstr[1],'','','','','','','','','','1'
                     IF STATUS THEN
                        CALL cl_err("execute insert_prep:",STATUS,1)
                        EXIT FOR
                     END IF
                  END FOR
               END IF
#No.FUN-830053 -- end --
            END IF
         END FOR
      #end add--
      ELSE
         CALL r101_total()
         DECLARE tmp_curs CURSOR FOR
          SELECT * FROM aglr101_file ORDER BY maj02,no
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
         LET l_j = 1
         FOREACH tmp_curs INTO sr.*
            IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
            IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
            IF tm.d MATCHES '[23]' THEN             #換算金額單位
               IF g_unit!=0 THEN
                  LET sr.bal1 = sr.bal1 / g_unit    #實際
               ELSE
                  LET sr.bal1 = 0
               END IF
            END IF
            # Modify -- 98/12/10 By Iris
            IF sr.maj03 = '%' THEN   # 顯示百分比 Thomas 98/11/17
               CASE sr.no
#No.FUN-830053 -- begin --
#                  WHEN 1  LET l_str1  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 2  LET l_str2  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 3  LET l_str3  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 4  LET l_str4  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 5  LET l_str5  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 6  LET l_str6  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 7  LET l_str7  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 8  LET l_str8  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 9  LET l_str9  = sr.bal1 USING '--------&.&&',' %'
#                  WHEN 10 LET l_str10 = sr.bal1 USING '--------&.&&',' %'
                  WHEN 1  LET l_amtstr[1]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 2  LET l_amtstr[2]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 3  LET l_amtstr[3]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 4  LET l_amtstr[4]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 5  LET l_amtstr[5]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 6  LET l_amtstr[6]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 7  LET l_amtstr[7]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 8  LET l_amtstr[8]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 9  LET l_amtstr[9]  = sr.bal1 USING '--------&.&&',' %'
                  WHEN 10 LET l_amtstr[10] = sr.bal1 USING '--------&.&&',' %'
#No.FUN-830053 -- end --
               END CASE
            ELSE
               CASE sr.no
#No.FUN-830053 -- begin --
#                  WHEN 1  LET l_str1  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 2  LET l_str2  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 3  LET l_str3  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 4  LET l_str4  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 5  LET l_str5  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 6  LET l_str6  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 7  LET l_str7  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 8  LET l_str8  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 9  LET l_str9  = sr.bal1 USING '--,---,---,---,--&'
#                  WHEN 10 LET l_str10 = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 1  LET l_amtstr[1]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 2  LET l_amtstr[2]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 3  LET l_amtstr[3]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 4  LET l_amtstr[4]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 5  LET l_amtstr[5]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 6  LET l_amtstr[6]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 7  LET l_amtstr[7]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 8  LET l_amtstr[8]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 9  LET l_amtstr[9]  = sr.bal1 USING '--,---,---,---,--&'
                  WHEN 10 LET l_amtstr[10] = sr.bal1 USING '--,---,---,---,--&'
#No.FUN-830053 -- end --
               END CASE
            END IF
            IF sr.no = g_cn THEN
               #NO:4404
               LET l_zero1 = 'N'
               LET l_zero2 = 'N'
               IF (tm.c='N' OR sr.maj03='2') AND sr.maj03 MATCHES "[0125]" AND
#No.FUN-830053 -- begin --
#                  (l_str1[1,18]='                 0' OR cl_null(l_str1[1,18])) AND
#                  (l_str2[1,18]='                 0' OR cl_null(l_str2[1,18])) AND
#                  (l_str3[1,18]='                 0' OR cl_null(l_str3[1,18])) AND
#                  (l_str4[1,18]='                 0' OR cl_null(l_str4[1,18])) AND
#                  (l_str5[1,18]='                 0' OR cl_null(l_str5[1,18])) AND
#                  (l_str6[1,18]='                 0' OR cl_null(l_str6[1,18])) AND
#                  (l_str7[1,18]='                 0' OR cl_null(l_str7[1,18])) AND
#                  (l_str8[1,18]='                 0' OR cl_null(l_str8[1,18])) AND
#                  (l_str9[1,18]='                 0' OR cl_null(l_str9[1,18])) AND
#                  (l_str10[1,18]='                 0' OR cl_null(l_str10[1,18])) THEN
                  (l_amtstr[1][1,18] ='                 0' OR cl_null(l_amtstr[1][1,18])) AND
                  (l_amtstr[2][1,18] ='                 0' OR cl_null(l_amtstr[2][1,18])) AND
                  (l_amtstr[3][1,18] ='                 0' OR cl_null(l_amtstr[3][1,18])) AND
                  (l_amtstr[4][1,18] ='                 0' OR cl_null(l_amtstr[4][1,18])) AND
                  (l_amtstr[5][1,18] ='                 0' OR cl_null(l_amtstr[5][1,18])) AND
                  (l_amtstr[6][1,18] ='                 0' OR cl_null(l_amtstr[6][1,18])) AND
                  (l_amtstr[7][1,18] ='                 0' OR cl_null(l_amtstr[7][1,18])) AND
                  (l_amtstr[8][1,18] ='                 0' OR cl_null(l_amtstr[8][1,18])) AND
                  (l_amtstr[9][1,18] ='                 0' OR cl_null(l_amtstr[9][1,18])) AND
                  (l_amtstr[10][1,18]='                 0' OR cl_null(l_amtstr[10][1,18])) THEN
#No.FUN-830053 -- end --
                  LET l_zero1 = 'Y'             #餘額為 0 者不列印
               END IF
 
#No.FUN-830053 -- begin --
#               LET l_str = l_str1 CLIPPED,' ',l_str2 CLIPPED,' ',l_str3 CLIPPED,' ',
#                           l_str4 CLIPPED,' ',l_str5 CLIPPED,' ',l_str6 CLIPPED,' ',
#                           l_str7 CLIPPED,' ',l_str8 CLIPPED,' ',l_str9 CLIPPED,' ',
#                           l_str10 CLIPPED
#               LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
#               LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
#               LET l_str7 = '' LET l_str8 = '' LET l_str9 = ''
#               LET l_str10= ''
#No.FUN-830053 -- end --
               IF g_flag = 'y' THEN
                  IF sr.maj03 = '%' THEN
#                     LET l_totstr = g_total[l_j].amt USING '--------&.&&',' %'           #No.FUN-830053 mark
                     LET l_amtstr[sr.no+1] = g_total[l_j].amt USING '--------&.&&',' %'   #No.FUN-830053 add
                  ELSE
#                     LET l_totstr = g_total[l_j].amt USING '--,---,---,---,--&'          #No.FUN-830053 mark
                     LET l_amtstr[sr.no+1] = g_total[l_j].amt USING '--,---,---,---,--&'  #No.FUN-830053 add
                  END IF
                  IF (tm.c='N' OR sr.maj03='2') AND
                      sr.maj03 MATCHES "[0125]"  AND g_total[l_j].amt = 0 THEN
                      LET l_zero2 = 'Y'
                  END IF
#                  LET l_str = l_str CLIPPED,' ',l_totstr CLIPPED      #No.FUN-830053 mark
                  LET l_j = l_j + 1
                  IF l_j > 300 THEN
                     CALL cl_err('l_j > 300',STATUS,1) EXIT FOREACH
                  END IF
               END IF
               #NO:4404
               #表頭不應該列印金額
               IF sr.maj03 = 'H' THEN
#                  LET l_str =NULL                                     #No.FUN-830053
                  CALL l_amtstr.clear()                                #No.FUN-830053
               END IF
               IF l_zero1 = 'Y' AND (g_flag = 'n' OR
                  (g_flag = 'y' AND l_zero2 = 'Y')) THEN
                  CONTINUE FOREACH
               END IF
#No.FUN-830053 -- begin --
#              OUTPUT TO REPORT r101_rep(sr.maj02,sr.maj03,sr.maj04,sr.maj05,
#                                        sr.maj07,sr.maj20,sr.maj20e,l_str)
               IF sr.maj04 = 0 THEN
                  EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                                            sr.maj20,sr.maj20e,l_i,m_dept[1],m_dept[2],m_dept[3],
                                            m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                            m_dept[8],m_dept[9],m_dept[10],l_amtstr[1],l_amtstr[2],
                                            l_amtstr[3],l_amtstr[4],l_amtstr[5],l_amtstr[6],
                                            l_amtstr[7],l_amtstr[8],l_amtstr[9],l_amtstr[10],'2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
               ELSE
                  EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                                            sr.maj20,sr.maj20e,l_i,m_dept[1],m_dept[2],m_dept[3],
                                            m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                            m_dept[8],m_dept[9],m_dept[10],l_amtstr[1],l_amtstr[2],
                                            l_amtstr[3],l_amtstr[4],l_amtstr[5],l_amtstr[6],
                                            l_amtstr[7],l_amtstr[8],l_amtstr[9],l_amtstr[10],'2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
                  #空行的部份,以寫入同樣的maj20資料列進Temptable,
                  #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
                  #讓空行的這筆資料排在正常的資料前面印出
                  FOR i = 1 TO sr.maj04
                     EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                                               sr.maj20,sr.maj20e,l_i,m_dept[1],m_dept[2],m_dept[3],
                                               m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                                               m_dept[8],m_dept[9],m_dept[10],l_amtstr[1],l_amtstr[2],
                                               l_amtstr[3],l_amtstr[4],l_amtstr[5],l_amtstr[6],
                                               l_amtstr[7],l_amtstr[8],l_amtstr[9],l_amtstr[10],'1'
                     IF STATUS THEN
                        CALL cl_err("execute insert_prep:",STATUS,1)
                        EXIT FOREACH
                     END IF
                  END FOR
               END IF
#No.FUN-830053 -- end --
            END IF
            # Iris
         END FOREACH
         CLOSE tmp_curs
      END IF
 
#     FINISH REPORT r101_rep   #No.FUN-830053
#MOD-970245   ---start       
     #LET l_cmd2="chmod 777 ",l_name1 
     #RUN l_cmd2
 
###結合報表
     #IF l_i/10 = 1 THEN
     #   LET l_cmd1='cat ',l_name1 
     #ELSE
     #   LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1 
     #END IF
#MOD-970245   ---end        
   END FOR
  #LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name #MOD-970245       
  #RUN l_cmd1 #MOD-970245       
#No.FUN-830053 -- begin --
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.yy USING '<<<<',";",
               tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",tm.e
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aglr101','aglr101',g_sql,g_str)
#No.FUN-830053 -- end --
#---------------------------------------------------
END FUNCTION
 
FUNCTION r101_process(l_cn)
   DEFINE l_sql,l_sql1   LIKE type_file.chr1000           #No.FUN-680098  VARCHAR(1000)
   DEFINE l_cn           LIKE type_file.num5              #No.FUN-680098  smallint  
   DEFINE l_temp         LIKE type_file.num20_6           #No.FUN-680098  dec(20,6)
   DEFINE l_sun          LIKE type_file.num20_6           #No.FUN-680098  dec(20,6) 
   DEFINE l_mon          LIKE type_file.num20_6           #No.FUN-680098  dec(20,6) 
   DEFINE l_amt1,amt1,amt2,amt   LIKE type_file.num20_6   #No.FUN-680098  dec(20,6)
   DEFINE maj            RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2   LIKE type_file.num20_6   #No.FUN-680098     dec(20,6)
   DEFINE l_amt           LIKE type_file.num20_6   #No.FUN-680098     dec(20,6)
   DEFINE m_per1,m_per2   LIKE con_file.con06      #No.FUN-680098     dec(9,5)
   DEFINE l_mm            LIKE type_file.num5      #No.FUN-680098     smallint
 
    #----------- sql for sum(aao05-aao06)-----------------------------------
    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                " WHERE aao00= ? AND aao01 BETWEEN ? AND ? ",
                "   AND aao03 = ? ",
                "   AND aao04 BETWEEN ? AND ? ",
#No.MOD-860310 --begin
#               "   AND aao01 = aag01  AND aao00 = aag00 AND aag07 IN ('2','3')",#No.FUN-740020
                "   AND aao01 = aag01  AND aao00 = aag00 AND aag07 IN('2','3')",#No.FUN-740020
#No.MOD-860310 --end
                "   AND aao02 IN (",g_buf CLIPPED,")"             #---- g_buf 部門族群
    PREPARE r101_sum FROM l_sql
    DECLARE r101_sumc CURSOR FOR r101_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
 
    #----------- sql for sum(aao05-aao06)------Sum 期初---------------------
    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                " WHERE aao00= ? AND aao01 BETWEEN ? AND ? ",
                "   AND aao03 = ? ",
                "   AND aao00 = aag00 ",    #No.FUN-740020
                "   AND aao04 <= ? ",
#No.MOD-860310 --begin
#               "   AND aao01 = aag01  AND aao00 = aag00 AND aag07 IN ('2','3')",#No.FUN-740020
                "   AND aao01 = aag01  AND aao00 = aag00 AND aag07 IN('2','3')",#No.FUN-740020
#No.MOD-860310 --end
                "   AND aao02 IN (",g_buf CLIPPED,")"   #---- g_buf 部門族群
    PREPARE r101_sum1 FROM l_sql
    DECLARE r101_sumc1 CURSOR FOR r101_sum1
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
    FOREACH r101_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt  = 0
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj06 = '1' OR maj.maj06='3' THEN # Thomas99/01/11 取前期餘額
             IF maj.maj06='1' THEN LET l_mm=tm.bm-1 ELSE LET l_mm=tm.em END IF
             OPEN r101_sumc1 USING tm.b,maj.maj21,maj.maj22,tm.yy,l_mm
             FETCH r101_sumc1 INTO amt1
          ELSE
             OPEN r101_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm
             FETCH r101_sumc INTO amt1
          END IF
          IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt1) THEN LET amt1 = 0 END IF
       END IF
       # IF maj.maj07='2' THEN LET amt1=amt1*-1 END IF
       # Thomas 99/01/11 正負號應處理
       # 99/01/12
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          FOR i = 1 TO 100
          # FOR i = 1 TO maj.maj08
              LET l_amt1 = amt1
              # IF maj.maj06 matches '[3]' THEN LET l_amt1 = l_amt1 * -1 END IF
              # IF amt1 < 0 THEN
              #   LET l_amt1=amt1*-1 ELSE LET l_amt1=amt1 END IF
              IF maj.maj09 = '-' THEN  # Thomas 99/01/12
                 LET g_tot1[i]=g_tot1[i]-l_amt1     #科目餘額
              ELSE
                 LET g_tot1[i]=g_tot1[i]+l_amt1     #科目餘額
              END IF
          END FOR
          LET k=maj.maj08
          LET m_bal1=g_tot1[k]
          FOR i = 1 TO k LET g_tot1[i]=0 END FOR
       ELSE
# Thomas 98/11/15 GL014
	  IF maj.maj03 = '%' THEN
	     LET l_temp = maj.maj21
	     SELECT bal1 INTO l_sun FROM aglr101_file WHERE no=l_cn
	            AND maj02=l_temp
	     LET l_temp = maj.maj22
	     SELECT bal1 INTO l_mon FROM aglr101_file WHERE no=l_cn
	            AND maj02=l_temp
	     IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	     ELSE
                LET m_bal1 = l_sun / l_mon * 100
             END IF
# Thomas
          ELSE
             LET m_bal1=NULL
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
 
       #-----TQC-810051---------  
       #IF (tm.c='N' OR maj.maj03='2') AND
       #   maj.maj03 MATCHES "[012]" AND m_bal1=0 THEN
       #   CONTINUE FOREACH                              #餘額為 0 者不列印
       #END IF
       #-----END TQC-810051-----
#
       # IF maj.maj07='2' THEN LET m_bal1=m_bal1*-1 END IF
        #--MOD-D30245--mark--str
        #IF maj.maj07='2' THEN
        #   IF m_bal1 > 0 THEN LET m_bal1=m_bal1*-1  END IF
        #END IF
        #--MOD-D30245--mark--end
# Thomas 99/01/11
       IF maj.maj07='2' THEN LET m_bal1=m_bal1*-1 END IF   #MOD-D30245 add
 
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF
       INSERT INTO aglr101_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                    maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                    m_bal1)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('ins r101_file',STATUS,1)  #No.FUN-660123
          CALL cl_err3("ins","aglr101_file",l_cn,maj.maj02,STATUS,"","ins r101_file",1)   #No.FUN-660123
          EXIT FOREACH 
       END IF
    END FOREACH
END FUNCTION
 
REPORT r101_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)
   DEFINE l_unit      LIKE zaa_file.zaa08    #No.FUN-680098 VARCHAR(4) 
   DEFINE per1         LIKE fid_file.fid03   #No.FUN-680098 dec(8,3)
   DEFINE l_gem02      LIKE gem_file.gem02  
   DEFINE sr  RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              str       LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(300) 
              END RECORD, 
	  l_j LIKE type_file.num5,          #No.FUN-680098   smallint
	  l_total  LIKE type_file.num20_6,  #No.FUN-680098   dec(17,3)  
	  l_x      LIKE type_file.chr50     #No.FUN-680098   VARCHAR(40) 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.maj02
  FORMAT
   PAGE HEADER
      #FUN-6C0012.....begin
      IF tm.e = 'Y' THEN
         LET g_len = 250
      ELSE
         LET g_len = 290
      END IF
      #FUN-6C0012.....end
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      #金額單位之列印
      CASE tm.d
           WHEN '1'  LET l_unit = g_x[16]
           WHEN '2'  LET l_unit = g_x[17]
           WHEN '3'  LET l_unit = g_x[18]
           OTHERWISE LET l_unit = ' '
      END CASE
      PRINT ''
      IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
      PRINT g_x[14] CLIPPED,tm.a,COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,
            g_x[1] CLIPPED
      PRINT ''
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[13])-10)/2,g_x[13] CLIPPED,
            tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&',
	    30 SPACES,g_x[15] CLIPPED ,l_unit CLIPPED ,
            COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash2[1,g_len]
  #FUN-6C0012.....begin
#      PRINT 25 SPACES,m_dept CLIPPED
      IF tm.e = 'Y' THEN
         #PRINT 61 SPACES,m_dept CLIPPED   #TQC-810051
#         PRINT 60 SPACES,m_dept CLIPPED   #TQC-810051   #No.FUN-830053 mark
         PRINT '------------------------------------------------------------ ',
#      PRINT '------------------------ ',
               '------------------ ------------------ ------------------ ------------------ ',
               '------------------ ------------------ ------------------ ------------------ ',
               '------------------ ------------------'
       ELSE
          #PRINT 101 SPACES,m_dept CLIPPED   #TQC-810051
#          PRINT 100 SPACES,m_dept CLIPPED   #TQC-810051  #No.FUN-830053 mark
          PRINT '--------------------------------------------------------------------------------------------------- ',
                '------------------ ------------------ ------------------ ------------------ ',     
                '------------------ ------------------ ------------------ ------------------ ',
                '------------------ ------------------'
       END IF
  #FUN-6C0012.....end     
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      CASE WHEN sr.maj03 = '9'
             SKIP TO TOP OF PAGE
           WHEN sr.maj03 = '3'
             #FUN-6C0012.....begin
#             PRINT COLUMN 26,
             IF tm.e = 'Y' THEN
                PRINT COLUMN 62,
                '------------------ ------------------ ------------------ ------------------ ',
                '------------------ ------------------ ',
                '------------------ ------------------ ------------------ ------------------'
             ELSE
                PRINT COLUMN 102,
                '------------------ ------------------ ------------------ ------------------ ',
                '------------------ ------------------ ',
                '------------------ ------------------ ------------------ ------------------'
             END IF
             #FUN-6C0012.....end
           WHEN sr.maj03 = '4'
             PRINT g_dash2
           OTHERWISE
             FOR i = 1 TO sr.maj04 PRINT END FOR
             #FUN-6C0012.....begin
#             PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,COLUMN 26,sr.str CLIPPED
             IF tm.e = 'Y' THEN
                #PRINT sr.maj05 SPACES,sr.maj20e CLIPPED,COLUMN 62,sr.str CLIPPED   #TQC-810051
                PRINT sr.maj05 SPACES,sr.maj20e CLIPPED,COLUMN 61,sr.str CLIPPED   #TQC-810051
             ELSE
                #PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,COLUMN 102,sr.str CLIPPED   #TQC-810051
                PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,COLUMN 101,sr.str CLIPPED   #TQC-810051
             END IF
             #FUN-6C0012.....end
      END CASE
 
   ON LAST ROW
      IF g_flag = 'y' THEN
      {
         LET l_j = 1
	 LET l_total = 0
         FOR l_j = 1 TO 300
      	     LET l_total = l_total + g_total[l_j]
         END FOR
         IF cl_null(l_total) THEN LET l_total = 0 END IF
         PRINT g_dash2[1,g_len]
         PRINT '公司各部門費用總計:',l_total USING '-------------&'
	 SKIP 1 LINE
         PRINT COLUMN 25,'負責人:',30 SPACES,'財務部主管:',30 SPACES,'承辦會計:'
	 }
         PRINT g_dash2[1,g_len]
         # PRINT '負責人:',30 SPACES,'財務部主管:',30 SPACES,'承辦會計:'
      END IF
 
END REPORT
 
FUNCTION r101_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01    #No.FUN-680098  VARCHAR(6) 
    DEFINE l_sw     LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
    DEFINE l_abd02  LIKE aab_file.aab02    #No.FUN-680098  VARCHAR(6) 
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5          #No.FUN-680098 smallint
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN
           CALL r101_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
 
FUNCTION r101_total()
    DEFINE  l_i      LIKE type_file.num5,    #No.FUN-680098 SMALLINT
	    l_maj20  LIKE maj_file.maj20,
	    l_maj02  LIKE maj_file.maj02,
	    l_bal    LIKE type_file.num20_6  #No.FUN-680098 DEC(20,6)
 
    DECLARE tot_curs CURSOR FOR
      SELECT maj02,SUM(bal1) FROM aglr101_file #WHERE maj20 IS NOT NULL
       GROUP BY maj02 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj20 = ' '
    LET l_bal = 0
    FOREACH tot_curs INTO l_maj02,l_bal
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
       IF cl_null(l_bal) THEN LET l_bal = 0 END IF
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
          ELSE
             LET l_bal = 0
          END IF
       END IF
       LET g_total[l_i].maj02 =l_maj02
       LET g_total[l_i].amt = l_bal   #TQC-810051
       LET l_i = l_i + 1
       IF l_i > 300 THEN
          CALL cl_err('l_i > 300',STATUS,1) EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #
#FUN-870144
