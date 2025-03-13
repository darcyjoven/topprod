# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr203.4gl
# Descriptions...: 多欄式明細帳
# Modify.........: No.MOD-540120 05/04/18 By day 科目與數據未對齊
# Modify.........: No.TQC-640184 06/04/27 By wujie 報表轉xml便于excel分欄
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/21 By johnray 報表修改
# Modify.........: No.TQC-6B0073 06/11/24 By xufeng  報表修改
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 增加打印“額外名稱”
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/13 By sherry  會計科目加帳套
# Modify.........: No.MOD-820046 08/03/12 By Smapmin 轉為CR報表
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860252 09/02/03 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B60325 11/07/07 By elva 报表打印修正，增加期初期末
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              a       LIKE mai_file.mai01,    #NO FUN-690009   VARCHAR(6)    #報表結構編號 #TQC-840066
              b       LIKE aaa_file.aaa01,    #帳別編號        #No.FUN-670004
              yy      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #輸入年度
              bm      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #Begin 期別
              em      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # End  期別
              h       LIKE type_file.chr1,    #MOD-860252
              e       LIKE type_file.chr1,    #FUN-6C0012
              d       LIKE type_file.chr1,    #TQC-B60325
              f       LIKE type_file.chr1,    #TQC-B60325
              more    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)    #Input more condition(Y/N)
              END RECORD,
          i,j,k,g_mm  LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          g_unit      LIKE type_file.num10,   #NO FUN-690009   INTEGER    #金額單位基數
          g_buf       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(600)
          g_cn        LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          g_flag      LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
          g_bookno    LIKE aah_file.aah00,    #帳別
          g_gem05     LIKE gem_file.gem05,
          m_acc       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(300)
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_no        LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          g_acc       DYNAMIC ARRAY OF RECORD
		      maj21 LIKE maj_file.maj21,
		      maj20 LIKE maj_file.maj20,   #NO FUN-690009   VARCHAR(20)
	              maj20e LIKE maj_file.maj20e,   #FUN-6C0012
                      amt   LIKE abb_file.abb07  #TQC-B60325 期初
         	      END RECORD
 
DEFINE   g_aaa03      LIKE aaa_file.aaa03
DEFINE   g_i          LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
 
DEFINE l_table     STRING                       #MOD-820046
DEFINE l_table1    STRING                       #MOD-820046
DEFINE g_sql       STRING                       #MOD-820046
DEFINE g_str       STRING                       #MOD-820046
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #-----MOD-820046---------
   LET g_sql = "groupno.type_file.num5,",
               "aba02.aba_file.aba02,aba01.aba_file.aba01,",
               "abb04.abb_file.abb04,abb07.abb_file.abb07,",
               "abb06.abb_file.abb06,str01.abb_file.abb07,",
               "str02.abb_file.abb07,str03.abb_file.abb07,",
               "str04.abb_file.abb07,str05.abb_file.abb07,",
               "str06.abb_file.abb07,str07.abb_file.abb07,",
               "str08.abb_file.abb07,str09.abb_file.abb07,",
               "str10.abb_file.abb07"
   LET l_table = cl_prt_temptable('gglr203',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "groupno.type_file.num5,",
               "acc_01.maj_file.maj20,acc_02.maj_file.maj20,",
               "acc_03.maj_file.maj20,acc_04.maj_file.maj20,",
               "acc_05.maj_file.maj20,acc_06.maj_file.maj20,",
               "acc_07.maj_file.maj20,acc_08.maj_file.maj20,",
               "acc_09.maj_file.maj20,acc_10.maj_file.maj20"
   LET l_table1 = cl_prt_temptable('gglr2031',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #-----END MOD-820046-----
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   #TQC-610056
   LET tm.yy   = ARG_VAL(10)
   LET tm.bm   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE r203_file
# Thomas 98/11/17
   CREATE TEMP TABLE r203_file(
       no        LIKE type_file.num5,  
       aba02     LIKE aba_file.aba02,
       aba01     LIKE aba_file.aba01,
       abb04     LIKE abb_file.abb04,
       abb07     LIKE abb_file.abb07,
       abb06     LIKE abb_file.abb06)
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b= g_aza.aza81 END IF     #No.FUN-740055
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r203_tm()                        # Input print condition
   ELSE
      CALL r203()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r203_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5     #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 4 LET p_col = 38
 
   OPEN WINDOW r203_w AT p_row,p_col WITH FORM "ggl/42f/gglr203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN 
#        CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660124
         CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)     #No.FUN-660124
    END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
#  LET tm.b = g_bookno      #No.FUN-740055
   LET tm.e = 'N' #FUN-6C0012
   LET tm.h = 'Y' #No.MOD-860252
   LET tm.d = 'N' #TQC-B60325
   LET tm.f = 'N' #TQC-B60325
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.a,tm.b,tm.yy,tm.bm,tm.em,tm.h,tm.e,tm.d,tm.f,tm.more  #FUN-6C0012 #No.MOD-860252 add tm.h #TQC-B60325 add tm.d,tm.f
		  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
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
         IF STATUS THEN 
 #             CALL cl_err('sel mai:',STATUS,0)   #No.FUN-660124
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)    #No.FUN-660124
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
         IF NOT cl_null(tm.b) THEN
            #No.FUN-670004--begin
	          CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF
            #No.FUN-670004--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0)    #No.FUN-660124
               CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124   
               NEXT FIELD b 
            END IF
	 END IF
 
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
               LET g_qryparam.where = " mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               LET g_qryparam.default1 = tm.a
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
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r203_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr203'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr203','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('gglr203',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r203_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r203()
   ERROR ""
END WHILE
   CLOSE WINDOW r203_w
END FUNCTION
 
FUNCTION r203()
   #DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)     # External(Disk) file name   #MOD-820046
   #DEFINE l_name1   LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)     # External(Disk) file name   #MOD-820046
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0097
   DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)   # RDSQL STATEMENT
   DEFINE l_tmp     LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_maj21   LIKE maj_file.maj21
   DEFINE l_maj22   LIKE maj_file.maj22  #TQC-B60325
   DEFINE l_maj24   LIKE maj_file.maj24  #TQC-B60325
   DEFINE l_maj25   LIKE maj_file.maj25  #TQC-B60325
   DEFINE l_maj07   LIKE maj_file.maj07  #TQC-B60325
   DEFINE l_maj20   LIKE maj_file.maj20     #NO FUN-690009   VARCHAR(20)
   DEFINE l_maj20e  LIKE maj_file.maj20e    #FUN-6C0012
   DEFINE l_CE_sum1,l_CE_sum2 LIKE abb_file.abb07  #TQC-B60325
   DEFINE l_buf          LIKE ze_file.ze03       #TQC-B60325
   DEFINE l_leng,l_leng2    LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_bal     LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE sr  RECORD
              no     LIKE type_file.num5,    #NO FUN-690009   smallint
              aba02  LIKE type_file.dat,     #NO FUN-690009   date
              aba01  LIKE aba_file.aba01,    #NO FUN-690009   VARCHAR(12)
              abb04  LIKE abb_file.abb04,    #NO FUN-690009   VARCHAR(30)
              abb07  LIKE abb_file.abb07,    #NO FUN-690009   dec(20,6)
              abb06  LIKE abb_file.abb06     #NO FUN-690009   VARCHAR(1)
              END RECORD
#No.TQC-640184--begin
   DEFINE sr2 RECORD
#-----MOD-820046---------
#No.TQC-6A0094 -- begin --
              str1   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str2   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str3   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str4   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str5   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str6   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str7   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str8   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str9   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
              str10  LIKE abb_file.abb07     #NO FUN-690009   VARCHAR(18)
#             str1   LIKE maj_file.maj20,
#             str2   LIKE maj_file.maj20,
#             str3   LIKE maj_file.maj20,
#             str4   LIKE maj_file.maj20,
#             str5   LIKE maj_file.maj20,
#             str6   LIKE maj_file.maj20,
#             str7   LIKE maj_file.maj20,
#             str8   LIKE maj_file.maj20,
#             str9   LIKE maj_file.maj20,
#             str10  LIKE maj_file.maj20 
#No.TQC-6A0094 -- end --
#-----END MOD-820046-----
              END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5       LIKE abb_file.abb07  #TQC-B60325 remark
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10      LIKE abb_file.abb07  #TQC-B60325 remark
#No.TQC-640184--end   
   DEFINE l_str,l_totstr          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)  #No.TQC-640184
   DEFINE m_abd02                 LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5     #NO FUN-690009   SMALLINT
 #No.MOD-540120--begin
  #DEFINE l_cmd,l_cmd1  LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE l_cmd         LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE l_cmd1        LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)
 #No.MOD-540120--end
   DEFINE l_amt         LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_maj20_o     LIKE maj_file.maj20     #NO FUN-690009   VARCHAR(20)
   DEFINE l_group,i     LIKE type_file.num5     #MOD-820046
 
   #-----MOD-820046---------
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   #-----END MOD-820046-----
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
#No.TQC-640184--begin
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr203'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 250 END IF  #No.MOD-540120
#  FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
#No.TQC-640184--end   
 
 
   LET g_mm = tm.em
   LET l_i = 1
   LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_acc[g_no].* TO NULL END FOR
   #CALL cl_outnam('gglr203') RETURNING l_name   #MOD-820046
 
#將科目填入array------------------------------------
       LET g_no=0
       DECLARE r203_bom1 CURSOR FOR
#        SELECT maj21,maj20[1,20] FROM maj_file WHERE maj01=tm.a
     #  SELECT maj21,maj20[1,30],maj20e[1,30] FROM maj_file WHERE maj01=tm.a #FUN-6C0012  #TQC-B60325
        SELECT maj21,maj22,maj24,maj25,maj20[1,30],maj20e[1,30],maj07 FROM maj_file WHERE maj01=tm.a #FUN-6C0012  #TQC-B60325
           ORDER BY maj21
       FOREACH r203_bom1 INTO l_maj21,l_maj22,l_maj24,l_maj25,l_maj20,l_maj20e,l_maj07       #FUN-6C0012  #TQC-B60325
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_acc[g_no].maj21 = l_maj21
         LET g_acc[g_no].maj20 = l_maj20
         LET g_acc[g_no].maj20e= l_maj20e  #FUN-6C0012
          #TQC-B60325 --begin 期初金额
             LET l_amt = 0
             LET l_sql = "SELECT SUM(aeh11-aeh12) FROM aeh_file,aag_file ",
                         " WHERE aeh00='",tm.b,"'",
                         "   AND aag00= aeh00 AND aag07 IN ('2','3')",
                         "   AND aeh01 BETWEEN '",l_maj21,"' AND '",l_maj22,"'",
                         "   AND aeh09=",tm.yy,
                         "   AND aeh10 < ",tm.bm
             IF NOT cl_null(l_maj24) THEN
                LET l_sql = l_sql," AND aeh02 BETWEEN '",l_maj24,"' AND '",l_maj25,"'"
             END IF
             PREPARE r203_qcsum FROM l_sql
             DECLARE r203_qcsumc CURSOR FOR r203_qcsum
             FETCH r203_qcsumc INTO l_amt
             IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             #加回CE凭证
             IF NOT cl_null(l_maj24) THEN
                SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file
                 WHERE aba01=abb01 AND aba00=tm.b
                   AND abb00=aba00 AND aba06='CE' AND abapost='Y'
                   AND abb06='1' AND aba03=tm.yy
                   AND aba04<tm.bm
                   AND abb03 BETWEEN l_maj21 AND l_maj22
                   AND abb05 BETWEEN l_maj24 AND l_maj25
                SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file
                 WHERE aba01=abb01 AND aba00=tm.b
                   AND abb00=aba00 AND aba06='CE' AND abapost='Y'
                   AND abb06='2' AND aba03=tm.yy
                   AND aba04<tm.bm
                   AND abb03 BETWEEN l_maj21 AND l_maj22
                   AND abb05 BETWEEN l_maj24 AND l_maj25
             ELSE
                SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file
                 WHERE aba01=abb01 AND aba00=tm.b
                   AND abb00=aba00 AND aba06='CE' AND abapost='Y'
                   AND abb06='1' AND aba03=tm.yy
                   AND aba04<tm.bm
                   AND abb03 BETWEEN l_maj21 AND l_maj22
                SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file
                 WHERE aba01=abb01 AND aba00=tm.b
                   AND abb00=aba00 AND aba06='CE' AND abapost='Y'
                   AND abb06='2' AND aba03=tm.yy
                   AND aba04<tm.bm
                   AND abb03 BETWEEN l_maj21 AND l_maj22
             END IF
             IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
             IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
             LET l_amt = l_amt+l_CE_sum2-l_CE_sum1
             IF l_maj07= 2 THEN
                LET l_amt = l_amt * -1
             END IF
             LET g_acc[g_no].amt= l_amt
          #TQC-B60325 --end
       END FOREACH
 
#---------------------------------------------------
#控制一次印十個部門---------------------------------
#-----MOD-820046---------
##No.TQC-640184--begin
#       LET g_zaa[38].zaa08 =NULL
#       LET g_zaa[39].zaa08 =NULL
#       LET g_zaa[40].zaa08 =NULL
#       LET g_zaa[41].zaa08 =NULL
#       LET g_zaa[42].zaa08 =NULL
#       LET g_zaa[43].zaa08 =NULL
#       LET g_zaa[44].zaa08 =NULL
#       LET g_zaa[45].zaa08 =NULL
#       LET g_zaa[46].zaa08 =NULL
#       LET g_zaa[47].zaa08 =NULL
#       LET g_zaa[38].zaa06 ='Y'
#       LET g_zaa[39].zaa06 ='Y'
#       LET g_zaa[40].zaa06 ='Y'
#       LET g_zaa[41].zaa06 ='Y'
#       LET g_zaa[42].zaa06 ='Y'
#       LET g_zaa[43].zaa06 ='Y'
#       LET g_zaa[44].zaa06 ='Y'
#       LET g_zaa[45].zaa06 ='Y'
#       LET g_zaa[46].zaa06 ='Y'
#       LET g_zaa[47].zaa06 ='Y'
##No.TQC-640184--end  
#-----END MOD-820046-----
   #-----MOD-820046---------
   LET i = 0
   FOR l_group = 1 TO ((10-(g_no MOD 10))+g_no)/10
       IF tm.e = 'Y' THEN
          EXECUTE insert_prep1 USING
            l_group,g_acc[i+1].maj20e,g_acc[i+2].maj20e,
            g_acc[i+3].maj20e,g_acc[i+4].maj20e,g_acc[i+5].maj20e,
            g_acc[i+6].maj20e,g_acc[i+7].maj20e,g_acc[i+8].maj20e,
            g_acc[i+9].maj20e,g_acc[i+10].maj20e
       ELSE
          EXECUTE insert_prep1 USING
            l_group,g_acc[i+1].maj20,g_acc[i+2].maj20,
            g_acc[i+3].maj20,g_acc[i+4].maj20,g_acc[i+5].maj20,
            g_acc[i+6].maj20,g_acc[i+7].maj20,g_acc[i+8].maj20,
            g_acc[i+9].maj20,g_acc[i+10].maj20
       END IF
       #TQC-B60325 begin 
       #期初
       CALL cl_getmsg('agl-192',g_lang) RETURNING l_buf
       EXECUTE insert_prep USING
          l_group,'','',l_buf,'','',
          g_acc[i+1].amt,g_acc[i+2].amt,g_acc[i+3].amt,g_acc[i+4].amt,g_acc[i+5].amt,
          g_acc[i+6].amt,g_acc[i+7].amt,g_acc[i+8].amt,g_acc[i+9].amt,g_acc[i+10].amt
       #TQC-B60325 end
       LET i = i + 10
   END FOR
   #-----END MOD-820046-----
 
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   #LET l_i = 0   #MOD-820046
   #START REPORT r203_rep TO l_name      #No.TQC-6B0073   #MOD-820046
   LET l_group = 1   #MOD-820046
   FOR l_i = 10 TO l_cnt STEP 10
       LET g_flag = 'n'
#      LET l_name1='r203_',l_i/10 USING '&&&','.out'
#      START REPORT r203_rep TO l_name1
       LET g_cn = 0
       LET g_pageno = 0
       DELETE FROM r203_file
       LET m_acc = ''
       IF l_i <= g_no THEN
          LET l_no = l_i - 10
          FOR l_cn = 1 TO 10
              LET g_i = 1
              LET g_buf = ''
              LET l_maj21= g_acc[l_no+l_cn].maj21
              #FUN-6C0012.....begin
              IF tm.e = 'Y' THEN
                 LET l_maj20= g_acc[l_no+l_cn].maj20e
              ELSE
                 LET l_maj20= g_acc[l_no+l_cn].maj20
              END IF
              #FUN-6C0012.....end
              LET l_leng2 = LENGTH(l_maj20_o)
              LET l_leng2 = 16 - l_leng2
#-----MOD-820046---------
##No.TQC-640184--begin
#              CASE l_cn
#               WHEN 1  LET g_zaa[38].zaa08 =l_maj20 
#               WHEN 2  LET g_zaa[39].zaa08 =l_maj20
#               WHEN 3  LET g_zaa[40].zaa08 =l_maj20
#               WHEN 4  LET g_zaa[41].zaa08 =l_maj20
#               WHEN 5  LET g_zaa[42].zaa08 =l_maj20
#               WHEN 6  LET g_zaa[43].zaa08 =l_maj20
#               WHEN 7  LET g_zaa[44].zaa08 =l_maj20
#               WHEN 8  LET g_zaa[45].zaa08 =l_maj20
#               WHEN 9  LET g_zaa[46].zaa08 =l_maj20
#               WHEN 10 LET g_zaa[47].zaa08 =l_maj20
#              END CASE
#              IF g_zaa[38].zaa08 IS NOT NULL THEN
#                 LET g_zaa[38].zaa06 ='N'
#              END IF 
#              IF g_zaa[39].zaa08 IS NOT NULL THEN
#                 LET g_zaa[39].zaa06 ='N'
#              END IF 
#              IF g_zaa[40].zaa08 IS NOT NULL THEN
#                 LET g_zaa[40].zaa06 ='N'
#              END IF 
#              IF g_zaa[41].zaa08 IS NOT NULL THEN
#                 LET g_zaa[41].zaa06 ='N'
#              END IF 
#              IF g_zaa[42].zaa08 IS NOT NULL THEN
#                 LET g_zaa[42].zaa06 ='N'
#              END IF 
#              IF g_zaa[43].zaa08 IS NOT NULL THEN
#                 LET g_zaa[43].zaa06 ='N'
#              END IF 
#              IF g_zaa[44].zaa08 IS NOT NULL THEN
#                 LET g_zaa[44].zaa06 ='N'
#              END IF 
#              IF g_zaa[45].zaa08 IS NOT NULL THEN
#                 LET g_zaa[45].zaa06 ='N'
#              END IF 
#              IF g_zaa[46].zaa08 IS NOT NULL THEN
#                 LET g_zaa[46].zaa06 ='N'
#              END IF 
#              IF g_zaa[47].zaa08 IS NOT NULL THEN
#                 LET g_zaa[47].zaa06 ='N'
#              END IF 
#-----END MOD-820046-----
#             IF l_cn = 1 THEN
#                LET m_acc = l_maj20
#             ELSE
#                LET m_acc = m_acc  CLIPPED,l_leng2 SPACES,1 SPACES,l_maj20
#             END IF
#No.TQC-640184--end    
              IF g_buf IS NULL THEN LET g_buf="'",l_maj21 CLIPPED,"'," END IF
              LET l_leng=LENGTH(g_buf)
              LET g_buf=g_buf[1,l_leng-1] CLIPPED
               CALL r203_process(l_cn,l_maj21)   #No.MOD-540120
              LET g_cn = l_cn
	      LET l_maj20_o = l_maj20
          END FOR
       ELSE
          LET l_no = (l_i - 10)
          FOR l_cn = 1 TO (g_no - (l_i - 10))
              LET g_i = 1
              LET g_buf = ''
              LET l_maj21 = g_acc[l_no+l_cn].maj21
              LET l_maj20  = g_acc[l_no+l_cn].maj20
              LET l_maj20e = g_acc[l_no+l_cn].maj20e  #FUN-6C0012
              LET l_leng2 = LENGTH(l_maj20_o)
              LET l_leng2 = 16 - l_leng2
#-----MOD-820046---------
##No.TQC-640184--begin
#              CASE l_cn
#               WHEN 1  LET g_zaa[38].zaa08 =l_maj20 
#               WHEN 2  LET g_zaa[39].zaa08 =l_maj20
#               WHEN 3  LET g_zaa[40].zaa08 =l_maj20
#               WHEN 4  LET g_zaa[41].zaa08 =l_maj20
#               WHEN 5  LET g_zaa[42].zaa08 =l_maj20
#               WHEN 6  LET g_zaa[43].zaa08 =l_maj20
#               WHEN 7  LET g_zaa[44].zaa08 =l_maj20
#               WHEN 8  LET g_zaa[45].zaa08 =l_maj20
#               WHEN 9  LET g_zaa[46].zaa08 =l_maj20
#               WHEN 10 LET g_zaa[47].zaa08 =l_maj20
#              END CASE
#              IF g_zaa[38].zaa08 IS NOT NULL THEN
#                 LET g_zaa[38].zaa06 ='N'
#              END IF 
#              IF g_zaa[39].zaa08 IS NOT NULL THEN
#                 LET g_zaa[39].zaa06 ='N'
#              END IF 
#              IF g_zaa[40].zaa08 IS NOT NULL THEN
#                 LET g_zaa[40].zaa06 ='N'
#              END IF 
#              IF g_zaa[41].zaa08 IS NOT NULL THEN
#                 LET g_zaa[41].zaa06 ='N'
#              END IF 
#              IF g_zaa[42].zaa08 IS NOT NULL THEN
#                 LET g_zaa[42].zaa06 ='N'
#              END IF 
#              IF g_zaa[43].zaa08 IS NOT NULL THEN
#                 LET g_zaa[43].zaa06 ='N'
#              END IF 
#              IF g_zaa[44].zaa08 IS NOT NULL THEN
#                 LET g_zaa[44].zaa06 ='N'
#              END IF 
#              IF g_zaa[45].zaa08 IS NOT NULL THEN
#                 LET g_zaa[45].zaa06 ='N'
#              END IF 
#              IF g_zaa[46].zaa08 IS NOT NULL THEN
#                 LET g_zaa[46].zaa06 ='N'
#              END IF 
#              IF g_zaa[47].zaa08 IS NOT NULL THEN
#                 LET g_zaa[47].zaa06 ='N'
#              END IF 
#-----END MOD-820046-----
#             IF l_cn = 1 THEN
#                LET m_acc = l_maj20
#             ELSE
#                LET m_acc = m_acc CLIPPED ,l_leng2 SPACES,1 SPACES,l_maj20
#             END IF
#No.TQC-640184--end
              IF g_buf IS NULL THEN LET g_buf="'",l_maj21 CLIPPED,"'," END IF
              LET l_leng=LENGTH(g_buf)
              LET g_buf=g_buf[1,l_leng-1] CLIPPED
               CALL r203_process(l_cn,l_maj21)   #No.MOD-540120
              LET g_cn = l_cn
	      LET l_maj20_o = l_maj20
          END FOR
          LET l_leng2 = LENGTH(l_gem02)
          LET l_leng2 = 16 - l_leng2
          LET m_acc = m_acc CLIPPED
	  LET g_flag = 'y'
       END IF
       CALL  cl_prt_pos_len()     #No.TQC-640184
#      START REPORT r203_rep TO l_name   #No.TQC-640184   #No.TQC-6B0073
       #TQC-B60325 --begin
       LET l_str1 = 0
       LET l_str2 = 0
       LET l_str3 = 0
       LET l_str4 = 0
       LET l_str5 = 0
       LET l_str6 = 0
       LET l_str7 = 0
       LET l_str8 = 0
       LET l_str9 = 0
       LET l_str10 = 0
       #TQC-B60325 --end
       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM r203_file ORDER BY aba02,aba01
       IF STATUS THEN 
            CALL cl_err('tmp_curs',STATUS,1)    
       EXIT FOR END IF
       LET l_j = 1
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
	 IF cl_null(sr.abb07) THEN LET sr.abb07 = 0 END IF
             CASE sr.no
#No.TQC-6A0094 -- begin --
#                 WHEN 1  LET sr2.str1  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 2  LET sr2.str2  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 3  LET sr2.str3  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 4  LET sr2.str4  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 5  LET sr2.str5  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 6  LET sr2.str6  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 7  LET sr2.str7  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 8  LET sr2.str8  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 9  LET sr2.str9  = sr.abb07 USING '---,---,---,--&.&&'
#                 WHEN 10 LET sr2.str10 = sr.abb07 USING '---,---,---,--&.&&'
                 WHEN 1  LET sr2.str1  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 2  LET sr2.str2  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 3  LET sr2.str3  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 4  LET sr2.str4  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 5  LET sr2.str5  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 6  LET sr2.str6  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 7  LET sr2.str7  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 8  LET sr2.str8  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 9  LET sr2.str9  = sr.abb07 USING '---,---,---,---,---,---,--&.&&'   
                 WHEN 10 LET sr2.str10 = sr.abb07 USING '---,---,---,---,---,---,--&.&&'
#No.TQC-6A0094 -- end --
             END CASE
           #-----MOD-820046---------
           #將原本印空白,改為0
           IF sr2.str1 IS NULL THEN LET sr2.str1= 0 END IF                                                              
           IF sr2.str2 IS NULL THEN LET sr2.str2= 0 END IF                                                              
           IF sr2.str3 IS NULL THEN LET sr2.str3= 0 END IF                                                              
           IF sr2.str4 IS NULL THEN LET sr2.str4= 0 END IF                                                              
           IF sr2.str5 IS NULL THEN LET sr2.str5= 0 END IF                                                              
           IF sr2.str6 IS NULL THEN LET sr2.str6= 0 END IF                                                              
           IF sr2.str7 IS NULL THEN LET sr2.str7= 0 END IF                                                              
           IF sr2.str8 IS NULL THEN LET sr2.str8= 0 END IF                                                              
           IF sr2.str9 IS NULL THEN LET sr2.str9= 0 END IF                                                              
           IF sr2.str10 IS NULL THEN LET sr2.str10= 0  END IF  
           #-----END MOD-820045-----
#No.TQC-640184--begin
#           LET l_str = l_str1 ,l_str2 ,l_str3 ,
#                       l_str4 ,l_str5 ,l_str6 ,
#                       l_str7 ,l_str8 ,l_str9 ,
#                       l_str10
#           LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
#           LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
#           LET l_str7 = '' LET l_str8 = '' LET l_str9 = ''
#           LET l_str10= ''
#No.TQC-640184--end   
            #-----MOD-820046---------
            #OUTPUT TO REPORT r203_rep(sr.aba02,sr.aba01,sr.abb04,sr.abb07,
            #                          sr.abb06,sr2.*)     #No.TQC-640184
            EXECUTE insert_prep USING
               l_group,sr.aba02,sr.aba01,sr.abb04,sr.abb07,sr.abb06,
               sr2.str1,sr2.str2,sr2.str3,sr2.str4,sr2.str5,sr2.str6,
               sr2.str7,sr2.str8,sr2.str9,sr2.str10
            #-----END MOD-820046-----
           #TQC-B60325 begin 
           #期末
           LET l_str1 = l_str1+sr2.str1          
           LET l_str2 = l_str2+sr2.str2          
           LET l_str3 = l_str3+sr2.str3          
           LET l_str4 = l_str4+sr2.str4          
           LET l_str5 = l_str5+sr2.str5          
           LET l_str6 = l_str6+sr2.str6          
           LET l_str7 = l_str7+sr2.str7          
           LET l_str8 = l_str8+sr2.str8          
           LET l_str9 = l_str9+sr2.str9          
           LET l_str10 = l_str10+sr2.str10          
           #TQC-B60325 end
            INITIALIZE sr2.* TO NULL   #MOD-820046
    END FOREACH
    #TQC-B60325 begin
    LET l_j = (l_group-1)*10
    LET l_str1 = g_acc[l_j+1].amt+l_str1          
    LET l_str2 = g_acc[l_j+2].amt+l_str2          
    LET l_str3 = g_acc[l_j+3].amt+l_str3          
    LET l_str4 = g_acc[l_j+4].amt+l_str4          
    LET l_str5 = g_acc[l_j+5].amt+l_str5          
    LET l_str6 = g_acc[l_j+6].amt+l_str6          
    LET l_str7 = g_acc[l_j+7].amt+l_str7          
    LET l_str8 = g_acc[l_j+8].amt+l_str8          
    LET l_str9 = g_acc[l_j+9].amt+l_str9          
    LET l_str10 = g_acc[l_j+10].amt+l_str10          
    CALL cl_getmsg('agl-193',g_lang) RETURNING l_buf
    EXECUTE insert_prep USING
        l_group,'','',l_buf,'','',
        l_str1,l_str2,l_str3,l_str4,l_str5,l_str6,l_str7,l_str8,l_str9,l_str10
    #TQC-B60325 end
 
#   FINISH REPORT r203_rep     #No.TQC-6B0073
    CLOSE tmp_curs
 
###結合報表
#      IF l_i/10 = 1 THEN
#         LET l_cmd1='cat ',l_name1
#      ELSE
#         LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1
#      END IF
       LET l_group = l_group + 1   #MOD-820046
   END FOR
   #FINISH REPORT r203_rep     #No.TQC-6B0073   #MOD-820046
#  LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name
#  RUN l_cmd1
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #MOD-820046
  #-----MOD-820046---------
  LET g_sql = "SELECT A.*,B.acc_01,B.acc_02,B.acc_03,B.acc_04,B.acc_05,",
              "           B.acc_06,B.acc_07,B.acc_08,B.acc_09,B.acc_10 ",
              "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A",
              "      ,",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
              " WHERE A.groupno=B.groupno"
  LET g_str=tm.a,";",tm.yy,";",tm.bm,";",tm.em
  CALL cl_prt_cs3('gglr203','gglr203',g_sql,g_str)
  #-----END MOD-820046-----
    
    #No.FUN-B80096--mark--Begin---
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
    #No.FUN-B80096--mark--End-----
#---------------------------------------------------
END FUNCTION
 
 FUNCTION r203_process(l_cn,l_maj21)    #No.MOD-540120
   DEFINE l_sql,l_sql1   LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)
   DEFINE l_cn           LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_temp         LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_sun          LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_mon          LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_amt1,amt1,amt2,amt  LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE maj            RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2  LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE l_maj21        LIKE maj_file.maj21
   DEFINE l_amt          LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   DEFINE m_per1,m_per2  LIKE bmw_file.bmw05     #NO FUN-690009   DEC(9,5)
   DEFINE l_mm           LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE sr1 RECORD
              aba02  LIKE aba_file.aba02,   #NO FUN-690009   date
              aba01  LIKE aba_file.aba01,   #NO FUN-690009   VARCHAR(12)
              abb04  LIKE abb_file.abb04,   #NO FUN-690009   VARCHAR(30)
              abb07  LIKE abb_file.abb07,   #NO FUN-690009   dec(20,6)
              abb06  LIKE abb_file.abb06    #NO FUN-690009   VARCHAR(1)
              END RECORD
 
 
   LET l_sql = "SELECT * FROM maj_file",
 #No.MOD-540120--begin
#              " WHERE maj01 = '",tm.a,"' AND maj23[1,1]='2' ",
#              "   AND maj02 = '",l_cn,"'"
               " WHERE maj01 = '",tm.a,"' AND maj21='",l_maj21,"' ",
               "   ORDER BY maj21 "
 #No.MOD-540120--end
   PREPARE r203_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE r203_c CURSOR FOR r203_p
    FOREACH r203_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt  = 0
       IF NOT cl_null(maj.maj21) THEN
          LET l_sql1 = "SELECT aba02,aba01,abb04,abb07,abb06 ",
                      " FROM aba_file,abb_file,aag_file",
                      " WHERE aba00= '",tm.b,"'",
                      "   AND aag00='",tm.b,"'",      #No.FUN-740055      
                     #"   AND abb03='",maj.maj21,"'",  #TQC-B60325
                      "   AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",  #TQC-B60325
                      "   AND aba03 = '",tm.yy,"'",
                      "   AND aba04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                      "   AND abb03 = aag01 AND aag07 IN ('2','3')",
                      "   AND aba19 = 'Y' ",  #TQC-B60325
                      "   AND aba01=abb01 "
         #No.MOD-860252--begin--
         IF tm.h = 'Y' THEN
            LET l_sql1 = l_sql1, " AND aag09 = 'Y' "
         END IF
         #No.MOD-860252---end---
         #TQC-B60325--begin
         IF NOT cl_null(maj.maj24) THEN
            LET l_sql1 = l_sql1, " AND abb05 BETWEEN '",maj.maj24,"' AND '",maj.maj25,"'" 
         END IF
         IF tm.d <> 'Y' THEN
            LET l_sql1 = l_sql1," AND abapost = 'Y' "
         END IF
         IF tm.f <> 'Y' THEN
            LET l_sql1 = l_sql1," AND aba06 <> 'CE' "
         END IF
         #TQC-B60325--end
         PREPARE r203_sum FROM l_sql1
         DECLARE r203_sumc CURSOR FOR r203_sum
         FOREACH r203_sumc INTO sr1.*
          IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
          IF cl_null(sr1.abb07) THEN LET sr1.abb07 = 0 END IF
       # Thomas 99/01/11 正負號應處理
       # 99/01/12
       # 99/01/18 modify
          IF maj.maj07 = '1' AND sr1.abb06="2" THEN
             LET sr1.abb07 = sr1.abb07 * -1
          END IF
 
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       IF maj.maj03 !='%' THEN
         IF maj.maj07='2' THEN
            IF NOT cl_null(maj.maj21) THEN
               IF m_bal1 > 0 AND sr1.abb07 < 0 THEN
                  LET m_bal1=m_bal1
               END IF
            END IF
         END IF
         IF maj.maj07='1' THEN
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj09 <> '-' AND m_bal1 < 0 THEN
                  LET m_bal1=m_bal1*-1  END IF
            ELSE
               IF m_bal1 < 0 AND maj.maj09 = '-' AND maj.maj07 = '2' THEN
                  LET m_bal1=m_bal1*-1
               END IF
            END IF
         END IF
# Thomas 99/01/11
       END IF
       INSERT INTO r203_file VALUES(l_cn,sr1.aba02,sr1.aba01,
                                    sr1.abb04,sr1.abb07,sr1.abb06)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('ins r203_file',STATUS,1)   #No.FUN-660124
          CALL cl_err3("ins","r203_file","","",STATUS,"","ins r203_file",1)   #No.FUN-660124
          exit FOREACH
       END IF
       END FOREACH
      END IF
    END FOREACH
END FUNCTION
 
#-----MOD-820046---------
#REPORT r203_rep(sr,sr2)    #No.TQC-640184
#   DEFINE l_last_sw    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
#   DEFINE l_amt1       LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
#   DEFINE l_gem02      LIKE gem_file.gem02
#   DEFINE sr  RECORD
#              aba02  LIKE aba_file.aba02,   #NO FUN-690009   date                                                                   
#              aba01  LIKE aba_file.aba01,   #NO FUN-690009   VARCHAR(12)                                                               
#              abb04  LIKE abb_file.abb04,   #NO FUN-690009   VARCHAR(30)                                                               
#              abb07  LIKE abb_file.abb07,   #NO FUN-690009   dec(20,6)                                                              
#              abb06  LIKE abb_file.abb06    #NO FUN-690009   VARCHAR(1) 
##             str    VARCHAR(300)   #No.TQC-640184
#              END RECORD,
#          l_j      LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#          l_total  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#          l_x      LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(40)
##No.TQC-640184--begin
#   DEFINE sr2 RECORD
##No.TQC-6A0094 -- begin --
##              str1   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str2   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)   
##              str3   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str4   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str5   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str6   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str7   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str8   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str9   LIKE abb_file.abb07,    #NO FUN-690009   VARCHAR(18)
##              str10  LIKE abb_file.abb07     #NO FUN-690009   VARCHAR(18)
#              str1   LIKE maj_file.maj20,
#              str2   LIKE maj_file.maj20,
#              str3   LIKE maj_file.maj20,
#              str4   LIKE maj_file.maj20,
#              str5   LIKE maj_file.maj20,
#              str6   LIKE maj_file.maj20,
#              str7   LIKE maj_file.maj20,
#              str8   LIKE maj_file.maj20,
#              str9   LIKE maj_file.maj20,
#              str10  LIKE maj_file.maj20
##No.TQC-6A0094 -- end --
#              END RECORD
#   OUTPUT                                                                                                                           
#      TOP MARGIN g_top_margin                                                                                                                  
#      LEFT MARGIN g_left_margin                                                                                                                 
#      BOTTOM MARGIN g_bottom_margin                                                                                                               
#      PAGE LENGTH g_page_line   
#
## OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
##No.TQC-640184--end   
#
#  ORDER BY sr.aba02,sr.aba01
#  FORMAT
#   PAGE HEADER
##No.TQC-640184--begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##No.TQC-640184--end
#      #金額單位之列印
#      LET l_unit = g_x[17]
#      PRINT ''
#      IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
#      PRINT g_x[15] CLIPPED,tm.a,COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,
#            g_x[1] CLIPPED
##     PRINT ''
##     LET g_pageno = g_pageno + 1    #No.TQC-6B0073   
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#      PRINT g_x[14] CLIPPED,           #No.TQC-640184
#            tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&',
#            COLUMN (g_len -10),g_x[16] CLIPPED ,l_unit
##           COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT g_dash[1,g_len]      #No.TQC-640184
##     DISPLAY "m_acc=",m_acc     #No.TQC-640184
# #No.MOD-540120--begin
##     PRINT g_x[12] ,g_x[13] CLIPPED,COLUMN 72,m_acc
##No.TQC-640184--begin
##     PRINT COLUMN 01,g_x[12] ,
##           COLUMN 39,g_x[13] CLIPPED,
##           COLUMN 61,g_x[23] CLIPPED,
##           COLUMN 92,m_acc
# #No.MOD-540120--end
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],
#            g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#      PRINT g_dash1
##No.TQC-640184--end   
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#             IF l_amt1 IS NULL THEN LET l_amt1=0 END IF
#             LET l_amt1=l_amt1+sr.abb07
##No.TQC-640184--begin
#             PRINT COLUMN g_c[31],MONTH(sr.aba02) USING "&&",
#                   COLUMN g_c[32],DAY(sr.aba02) USING "&&",
#                   COLUMN g_c[33],sr.aba01 CLIPPED,
#                   COLUMN g_c[34],sr.abb04[1,20] CLIPPED,
#                   COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04) CLIPPED;
#             IF sr.abb07>0 THEN
#              PRINT COLUMN g_c[36],"1" USING '#####';
#             ELSE
#              PRINT COLUMN g_c[36],"2" USING '#####';
#             END IF
#             PRINT COLUMN g_c[37],cl_numfor(l_amt1,37,g_azi04) CLIPPED,
##                   COLUMN g_c[38],sr2.str1, #No.TQC-6B0073        
##                   COLUMN g_c[39],sr2.str2,#No.TQC-6B0073 
##                   COLUMN g_c[40],sr2.str3,#No.TQC-6B0073
##                   COLUMN g_c[41],sr2.str4,#No.TQC-6B0073
##                   COLUMN g_c[42],sr2.str5,#No.TQC-6B0073
##                   COLUMN g_c[43],sr2.str6,#No.TQC-6B0073
##                   COLUMN g_c[44],sr2.str7,#No.TQC-6B0073
##                   COLUMN g_c[45],sr2.str8,#No.TQC-6B0073
##                   COLUMN g_c[46],sr2.str9,#No.TQC-6B0073
##                   COLUMN g_c[47],sr2.str10 #No.TQC-6B0073
#                  COLUMN g_c[38],cl_numfor(sr2.str1,37,g_azi04) CLIPPED,#No.TQC-6B0073     
#                  COLUMN g_c[39],cl_numfor(sr2.str2,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[40],cl_numfor(sr2.str3,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[41],cl_numfor(sr2.str4,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[42],cl_numfor(sr2.str5,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[43],cl_numfor(sr2.str6,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[44],cl_numfor(sr2.str7,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[45],cl_numfor(sr2.str8,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[46],cl_numfor(sr2.str9,37,g_azi04) CLIPPED,#No.TQC-6B0073
#                  COLUMN g_c[47],cl_numfor(sr2.str10,37,g_azi04) CLIPPED  #No.TQC-6B0073
##            PRINT COLUMN 01,MONTH(sr.aba02) USING "&&",
##                  COLUMN 04,DAY(sr.aba02) USING "&&",
# #No.MOD-540120--begin
##                  COLUMN 07,sr.aba02,
##                  COLUMN 07,sr.aba01,
##                  COLUMN 20,sr.abb04[1,20],
##                  COLUMN 42,cl_numfor(sr.abb07,18,g_azi04) CLIPPED;
##                  IF sr.abb07>0 THEN
##                   PRINT COLUMN 65,"1";
##                  ELSE
##                   PRINT COLUMN 65,"2";
##                  END IF
##            PRINT COLUMN 67, cl_numfor(l_amt1,18,g_azi04) CLIPPED;
##            PRINT COLUMN 92,sr.str CLIPPED
###No.MOD-540120--end
##No.TQC-640184--begin
#
#   ON LAST ROW
#      IF g_flag = 'y' THEN
#         PRINT g_dash2[1,g_len]   
#      END IF
#      PRINT g_dash[1,g_len]     #No.TQC-640184
##No.TQC-6A0094 -- begin --
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER                                                              
#      IF l_last_sw = 'n' THEN                                                
#         PRINT g_dash[1,g_len]                                               
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED  #No.MOD-5
#      ELSE                                                                   
#         SKIP 2 LINE                                                         
#      END IF
##No.TQC-6A0094 -- end --
#END REPORT
#-----END MOD-820046-----
 
FUNCTION r203_bom(l_maj21)
    DEFINE l_maj21       LIKE maj_file.maj21
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5     #NO FUN-690009   SMALLINT
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             aag01       LIKE aag_file.aag01
           END RECORD
    DEFINE l_sql         STRING  #No.MOD-860252
 
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
   ##No.MOD-860252--begin-- modify
   #DECLARE a_curs CURSOR FOR
   # SELECT aag01 FROM aag_file
   #  WHERE aag01 = l_maj21
   #    AND aag00 = tm.b    #No.FUN-740055  
    LET l_sql = " SELECT aag01 FROM aag_file  ",
                "  WHERE aag01 = '", l_maj21 CLIPPED,"'",
                "    AND aag00 = '", tm.b CLIPPED ,"'"
    IF tm.h = 'Y' THEN 
       LET l_sql = l_sql , " AND aag09 = 'Y' "
    END IF
    PREPARE a_curs_p FROM l_sql
    DECLARE a_curs CURSOR FOR a_curs_p
   ##No.MOD-860252---end--- modify
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].aag01 IS NOT NULL THEN
           CALL r203_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
       LET g_buf=g_buf CLIPPED,"'",l_maj21 CLIPPED,"',"
END FUNCTION
#Patch....NO.TQC-610037 <001,002> #
