# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr307.4gl
# Descriptions...: 試算表列印
# Date & Author..: 02/09/10 By Maggie
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗
# Modify.........: No.FUN-510007 05/03/04 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-590097 05/09/13 By Nigel 報表格式維護
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改 
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/23 By johnray 報表修改
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查仲用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/13 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By sherry   會計科目加帳套Bug修改
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.TQC-740305 07/04/30 By Lynn "報表結構編號"開窗應該只選擇報表性質為試算表的編號
# Modify.........: No.TQC-770087 07/07/18 By chenl 報表title修改。
# Modify.........: No.FUN-780031 07/08/24 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-780084 07/10/17 By wujie   "打印外幣"沒有勾選時,PASS "打印外幣"字段后,在"幣種"字段跳不出去,
#                                                    不打印外幣,應該不用選擇幣種
# Modify.........: No.MOD-860252 09/02/09 By chenl   增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.MOD-950314 09/06/01 By xiaofeizhu 將科目的截位去掉
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-AC0008 10/12/07 By Summer 計算合計階段需增加maj09的控制
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib AFTER FIELD a 判斷報表性質,為1的才可以過欄位
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              a   LIKE mai_file.mai01,    #NO FUN-690009   VARCHAR(6)        #報表結構編號
              b   LIKE aaa_file.aaa01,    #帳別編號  #No.FUN-670004
              yy  LIKE type_file.num5,    #NO FUN-690009   SMALLINT  #輸入年度
              bm  LIKE type_file.num5,    #NO FUN-690009   SMALLINT  #Begin 期別
              em  LIKE type_file.num5,    #NO FUN-690009   SMALLINT  # End  期別
              dd  LIKE type_file.num5,    #NO FUN-690009   SMALLINT  #截止日
              c   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #餘額為0者是否列印
              s   LIKE type_file.chr1,    #MOD-860252
              d   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #金額單位
              e   LIKE type_file.num5,    #NO FUN-690009   SMALLINT  #小數位數
              f   LIKE type_file.num5,    #NO FUN-690009   SMALLINT  #列印最小階數
              h   LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)  #額外說明類別
              o   LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)  #是否列印外幣
              p   LIKE azi_file.azi01,    #幣別
              more    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)  #Input more condition(Y/N)
              END RECORD,
          bdate,edate   LIKE type_file.dat,        #NO FUN-690009   DATE
          i,k,g_mm      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          g_unit     LIKE type_file.num5,       #NO FUN-690009   INTEGER      #金額單位基數
          g_bookno   LIKE aah_file.aah00,       #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_tot1_1   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot1_2   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)  
          g_tot1_3   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot1_4   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6) 
          g_tot2_1   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot2_2   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot2_3   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot2_4   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot4_1   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot4_2   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot4_3   ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot4_4   ARRAY[100] OF LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING  #No.FUN-780031
DEFINE   g_str           STRING  #No.FUN-780031
DEFINE   g_sql           STRING  #No.FUN-780031
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-780031  --Begin
   LET g_sql = " bal1_1.type_file.num20_6,",
               " bal1_2.type_file.num20_6,",
               " bal1_3.type_file.num20_6,",
               " bal1_4.type_file.num20_6,",
               " bal2_1.type_file.num20_6,",
               " bal2_2.type_file.num20_6,",
               " bal2_3.type_file.num20_6,",
               " bal2_4.type_file.num20_6,",
               " bal4_1.type_file.num20_6,",
               " bal4_2.type_file.num20_6,",
               " bal4_3.type_file.num20_6,",
               " bal4_4.type_file.num20_6,",
               " maj02.maj_file.maj02,",
               " maj03.maj_file.maj03,",
               " maj20.maj_file.maj20 "
 
   LET l_table = cl_prt_temptable('gglr307',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?               ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)         # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)   #TQC-610056
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.em = ARG_VAL(12)
   LET tm.dd = ARG_VAL(13)
   LET tm.c  = ARG_VAL(14)
   LET tm.d  = ARG_VAL(15)
   LET tm.e  = ARG_VAL(16)
   LET tm.f  = ARG_VAL(17)
   LET tm.h  = ARG_VAL(18)
   LET tm.o  = ARG_VAL(19)
   LET tm.p  = ARG_VAL(20)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#  IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF       #NO.FUN-740055
   IF tm.b = ' ' OR tm.b IS NULL THEN                                #NO.FUN-740055                                            
      LET tm.b = g_aza.aza81  #帳別若為空白則使用預設帳別            #NO.FUN-740055                                            
   END IF                                                            #NO.FUN-740055

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r105_tm()                      # Input print condition
      ELSE CALL r105()                         # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r105_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5        #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5        #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r105_w AT p_row,p_col WITH FORM "ggl/42f/gglr307"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                     #Default condition
   #使用預設帳別之幣別
   IF tm.b = ' ' OR tm.b IS NULL THEN                                #NO.FUN-740055                                                 
      LET tm.b = g_aza.aza81  #帳別若為空白則使用預設帳別            #NO.FUN-740055                                                 
   END IF                                                            #NO.FUN-740055 
#  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno    #NO.FUN-740055
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b        #NO.FUN-740055 
   IF SQLCA.sqlcode THEN 
#         CALL cl_err('sel aaa:',SQLCA.sqlcode,0)    #No.FUN-660124
          CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660124
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#         CALL cl_err('sel azi:',SQLCA.sqlcode,0)    #No.FUN-660124
          CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660124
   END IF
   LET tm.b = g_bookno
   LET tm.c = 'Y'
   LET tm.s = 'Y'  #NO.MOD-860252
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
       LET l_sw = 1
       INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.dd,
                     tm.e,tm.f,tm.d,tm.s,tm.c,tm.h,tm.o,tm.p,  #No.MOD-860252 add tm.s
                     tm.more WITHOUT DEFAULTS
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
            IF tm.a IS NULL THEN NEXT FIELD a END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                   WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                     AND mai00 = tm.b  #NO.FUN-740055   
                     AND mai03 = '1'   #No.TQC-C50042   Add
            IF STATUS THEN 
#                CALL cl_err('sel mai:',STATUS,0)   #No.FUN-660124
                 CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660124
            NEXT FIELD a 
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
#                 CALL cl_err('sel aaa:',STATUS,0)    #No.FUN-660124
                  CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124   
                  NEXT FIELD b 
               END IF
	    END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
 
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
            IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#            IF tm.bm <1 OR tm.bm > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm
#            END IF
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
            IF tm.em IS NULL THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#            IF tm.em <1 OR tm.em > 13 THEN
#               CALL cl_err('','agl-013',0) NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
         AFTER FIELD dd
            IF tm.dd IS NOT NULL THEN
               IF tm.dd <0 OR tm.dd > 31 THEN NEXT FIELD dd END IF
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
 
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
#No.TQC-780084 --begin                                                                                                              
         BEFORE FIELD o                                                                                                             
               CALL cl_set_comp_entry("p",TRUE)                                                                                     
#No.TQC-780084 --end  
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN
#No.TQC-780084 --begin  
               CALL cl_set_comp_entry("p",FALSE)        
#No.TQC-780084 --end 
               LET tm.p = NULL
               DISPLAY BY NAME tm.p
            END IF
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'agl-109',0)   #No.FUN-660124
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660124
               NEXT FIELD p 
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
            IF tm.yy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy
               CALL cl_err('',9033,0)
           END IF
            IF tm.bm IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.bm
           END IF
            IF tm.em IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.em
           END IF
           IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
           END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
#                 CALL q_mai(0,0,tm.a,'13') RETURNING tm.a
#                 CALL FGL_DIALOG_SETBUFFER( tm.a )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 = '1'"  #No.TQC-740093   # No.TQC-740305  
                  CALL cl_create_qry() RETURNING tm.a
#                  CALL FGL_DIALOG_SETBUFFER( tm.a )
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
 
             #No.MOD-4C0156 add
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
              #No.MOD-4C0156 end
               WHEN INFIELD(p)
#                 CALL q_azi(6,10,tm.p) RETURNING tm.p
#                 CALL FGL_DIALOG_SETBUFFER( tm.p )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
#                  CALL FGL_DIALOG_SETBUFFER( tm.p )
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p
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
          CLOSE WINDOW r105_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
          EXIT PROGRAM
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='gglr307'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
              CALL cl_err('gglr307','9031',1)   
          ELSE
             LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
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
                             " '",tm.dd CLIPPED,"'",
                             " '",tm.c CLIPPED,"'",
                             " '",tm.d CLIPPED,"'",
                             " '",tm.e CLIPPED,"'",
                             " '",tm.f CLIPPED,"'",
                             " '",tm.h CLIPPED,"'",
                             " '",tm.o CLIPPED,"'",
                             " '",tm.p CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr307',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD  
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r105()
      ERROR ""
   END WHILE
   CLOSE WINDOW r105_w
END FUNCTION
 
FUNCTION r105()
   DEFINE l_name    LIKE type_file.chr20       #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0097
   DEFINE l_sql     LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
   DEFINE l_chr     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(40)
   DEFINE amt1_1    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt1_2    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt1_3    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt1_4    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt2_1    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt2_2    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt2_3    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt2_4    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt4_1    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt4_2    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt4_3    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE amt4_4    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE l_tmp1    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE l_tmp2    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
   DEFINE l_tmp3    LIKE type_file.num10       #NO FUN-690009   INTEGER
   DEFINE l_tmp4    LIKE type_file.num10       #NO FUN-690009   INTEGER
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr  RECORD
              bal1_1	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初原幣
              bal1_2	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初原幣
              bal1_3	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初本幣
              bal1_4	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初本幣
              bal2_1	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期原幣借
              bal2_2	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期原幣貸
              bal2_3	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期本幣借
              bal2_4	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期本幣貸
              bal4_1    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末原幣
              bal4_2    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末原幣
              bal4_3    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末本幣
              bal4_4    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)    #--- 期末本幣
              END RECORD
 
     #No.FUN-780031  --Begin
     CALL cl_del_data(l_table)
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin--- 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
            AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr307'
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN
    #   IF tm.o = "N" THEN LET g_len = 126
    #   ELSE LET g_len = 186
    #   END IF
    #END IF
    #TQC-650055...............end
     LET l_sql = "SELECT * FROM maj_file",
                 " WHERE maj01 = '",tm.a,"' ORDER BY maj02"
     PREPARE r105_p FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE r105_c CURSOR FOR r105_p
 
     IF tm.dd IS NULL THEN
        LET g_mm = tm.em
     ELSE
        LET g_mm = tm.em - 1
        LET bdate = MDY(tm.em, 01,    tm.yy)
        LET edate = MDY(tm.em, tm.dd, tm.yy)
     END IF
     FOR g_i = 1 TO 100
         LET g_tot1_1[g_i] = 0 LET g_tot1_2[g_i] = 0
         LET g_tot1_3[g_i] = 0 LET g_tot1_4[g_i] = 0
         LET g_tot2_1[g_i] = 0 LET g_tot2_2[g_i] = 0
         LET g_tot2_3[g_i] = 0 LET g_tot2_4[g_i] = 0
         LET g_tot4_1[g_i] = 0 LET g_tot4_2[g_i] = 0
         LET g_tot4_3[g_i] = 0 LET g_tot4_4[g_i] = 0
     END FOR
     #CALL cl_outnam('gglr307') RETURNING l_name  #No.FUN-780031
#No.TQC-6A0094 -- begin --
#    #TQC-650055...............begin
#     IF g_len = 0 OR g_len IS NULL THEN
#        IF tm.o = "N" THEN LET g_len = 126
#        ELSE LET g_len = 186
#        END IF
#     END IF
#    #TQC-650055...............end
#No.TQC-6A0094 -- end --
     #START REPORT r105_rep TO l_name  #No.FUN-780031
     FOREACH r105_c INTO maj.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET amt1_1=0 LET amt1_2=0 LET amt1_3=0 LET amt1_4=0
       LET amt2_1=0 LET amt2_2=0 LET amt2_3=0 LET amt2_4=0
       LET amt4_1=0 LET amt4_2=0 LET amt4_3=0 LET amt4_4=0
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj24 IS NULL THEN
             #--- 不列印外幣
             IF tm.o = 'N' THEN
               #No.MOD-860252--begin-- modify
                IF tm.s = 'Y' THEN
                   #--- 
                   SELECT SUM(aah04-aah05) INTO amt1_1 FROM aah_file,aag_file
                       WHERE aah00 = tm.b
                         AND aag00 = aah00   #NO.FUN-740055
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy AND aah03 < tm.bm
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                         AND aag09 = 'Y'
                   #--- 
                   SELECT SUM(aah04),SUM(aah05)
                       INTO amt2_1,amt2_2 FROM aah_file,aag_file
                       WHERE aah00 = tm.b
                         AND aag00 = aah00   #NO.FUN-740055
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy AND aah03 >=tm.bm AND aah03 <=g_mm
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                         AND aag09 = 'Y'
                ELSE
                   #--- 
                   SELECT SUM(aah04-aah05) INTO amt1_1 FROM aah_file,aag_file
                       WHERE aah00 = tm.b
                         AND aag00 = aah00   #NO.FUN-740055
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy AND aah03 < tm.bm
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                   #--- 
                   SELECT SUM(aah04),SUM(aah05)
                       INTO amt2_1,amt2_2 FROM aah_file,aag_file
                       WHERE aah00 = tm.b
                         AND aag00 = aah00   #NO.FUN-740055
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy AND aah03 >=tm.bm AND aah03 <=g_mm
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                END IF 
               #No.MOD-860252---end---
             ELSE 
               #NO.MOD-860252--begin-- modify
                IF tm.s = 'Y' THEN  
                #--- 期初
                SELECT SUM(aah04-aah05) INTO amt1_1 FROM aah_file,aag_file
                    WHERE aah00 = tm.b
                      AND aag00 = aah00   #NO.FUN-740055
                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
                      AND aah02 = tm.yy AND aah03 < tm.bm
                      AND aah01 = aag01 AND aag07 IN ('2','3')
                #--- 本期
                SELECT SUM(aah04),SUM(aah05)
                    INTO amt2_1,amt2_2 FROM aah_file,aag_file
                    WHERE aah00 = tm.b
                      AND aag00 = aah00   #NO.FUN-740055
                      AND aah01 BETWEEN maj.maj21 AND maj.maj22
                      AND aah02 = tm.yy AND aah03 >=tm.bm AND aah03 <=g_mm
                      AND aah01 = aag01 AND aag07 IN ('2','3')
             ELSE                                               #列印外幣
                #--- 期初
                   SELECT SUM(tah04-tah05),SUM(tah09-tah10)
                     INTO amt1_1,amt1_3
                     FROM tah_file,aag_file
                    WHERE tah00 = tm.b
                      AND aag00 = tah00   #NO.FUN-740055
                      AND tah08 = tm.p                           #幣別符合
                      AND tah01 BETWEEN maj.maj21 AND maj.maj22
                      AND tah02 = tm.yy AND tah03 < tm.bm
                      AND tah01 = aag01 AND aag07 IN ('2','3')
                #--- 本期
                   SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
                     INTO amt2_1,amt2_2,amt2_3,amt2_4
                     FROM tah_file,aag_file
                    WHERE tah00 = tm.b
                      AND aag00 = tah00   #NO.FUN-740055
                      AND tah08 = tm.p                           #幣別符合
                      AND tah01 BETWEEN maj.maj21 AND maj.maj22
                      AND tah02 = tm.yy AND tah03 >=tm.bm AND tah03 <=g_mm
                      AND tah01 = aag01 AND aag07 IN ('2','3')
                END IF
               #No.MOD-860252---end--- modify
             END IF
          ELSE                                                   #起始部門編號不為空
             #--- 不列印外幣
             IF tm.o = 'N' THEN
               #No.MOD-860252--begin-- modify
                IF tm.s = 'Y' THEN  
                   #--- 
                   SELECT SUM(aao05-aao06) INTO amt1_1 FROM aao_file,aag_file
                       WHERE aao00 = tm.b
                         AND aag00 = aao00   #NO.FUN-740055
                         AND aao01 BETWEEN maj.maj21 AND maj.maj22
                         AND aao02 BETWEEN maj.maj24 AND maj.maj25
                         AND aao03 = tm.yy AND aao04 < tm.bm
                         AND aao01 = aag01 AND aag07 IN ('2','3')
                         AND aag09 = 'Y'
                   #--- 
                   SELECT SUM(aao05),SUM(aao06) INTO amt2_1,amt2_2
                       FROM aao_file,aag_file
                       WHERE aao00 = tm.b
                         AND aag00 = aao00   #NO.FUN-740055
                         AND aao01 BETWEEN maj.maj21 AND maj.maj22
                         AND aao02 BETWEEN maj.maj24 AND maj.maj25
                         AND aao03 = tm.yy AND aao04 >=tm.bm AND aao04 <=g_mm
                         AND aao01 = aag01 AND aag07 IN ('2','3')
                         AND aag09 = 'Y'
                ELSE
                   #--- 
                   SELECT SUM(aao05-aao06) INTO amt1_1 FROM aao_file,aag_file
                       WHERE aao00 = tm.b
                         AND aag00 = aao00   #NO.FUN-740055
                         AND aao01 BETWEEN maj.maj21 AND maj.maj22
                         AND aao02 BETWEEN maj.maj24 AND maj.maj25
                         AND aao03 = tm.yy AND aao04 < tm.bm
                         AND aao01 = aag01 AND aag07 IN ('2','3')
                   #--- 
                   SELECT SUM(aao05),SUM(aao06) INTO amt2_1,amt2_2
                       FROM aao_file,aag_file
                       WHERE aao00 = tm.b
                         AND aag00 = aao00   #NO.FUN-740055
                         AND aao01 BETWEEN maj.maj21 AND maj.maj22
                         AND aao02 BETWEEN maj.maj24 AND maj.maj25
                         AND aao03 = tm.yy AND aao04 >=tm.bm AND aao04 <=g_mm
                         AND aao01 = aag01 AND aag07 IN ('2','3')
                END IF
               #NO.MOD-860252---end--- modify
             ELSE                                        
               #No.MOD-860252--begin-- modify
                IF tm.s = 'Y' THEN
                #--- 期初
                SELECT SUM(aao05-aao06) INTO amt1_1 FROM aao_file,aag_file
                    WHERE aao00 = tm.b
                      AND aag00 = aao00   #NO.FUN-740055
                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
                      AND aao03 = tm.yy AND aao04 < tm.bm
                      AND aao01 = aag01 AND aag07 IN ('2','3')
                #--- 本期
                SELECT SUM(aao05),SUM(aao06) INTO amt2_1,amt2_2
                    FROM aao_file,aag_file
                    WHERE aao00 = tm.b
                      AND aag00 = aao00   #NO.FUN-740055
                      AND aao01 BETWEEN maj.maj21 AND maj.maj22
                      AND aao02 BETWEEN maj.maj24 AND maj.maj25
                      AND aao03 = tm.yy AND aao04 >=tm.bm AND aao04 <=g_mm
                      AND aao01 = aag01 AND aag07 IN ('2','3')
             ELSE                                               #列印外幣
                #--- 期初
                   SELECT SUM(tao05-tao06),SUM(tao10-tao11)
                     INTO amt1_1,amt1_3
                     FROM tao_file,aag_file
                    WHERE tao00 = tm.b
                      AND aag00 = tao00   #NO.FUN-740055
                      AND tao08 = tm.p                           #幣別符合
                      AND tao01 BETWEEN maj.maj21 AND maj.maj22
                      AND tao02 BETWEEN maj.maj24 AND maj.maj25
                      AND tao03 = tm.yy AND tao04 < tm.bm
                      AND tao01 = aag01 AND aag07 IN ('2','3')
                #--- 本期
                   SELECT SUM(tao05),SUM(tao06),SUM(tao09),SUM(tao10)
                     INTO amt2_1,amt2_2,amt2_3,amt2_4
                     FROM tao_file,aag_file
                    WHERE tao00 = tm.b
                      AND aag00 = tao00   #NO.FUN-740055
                      AND tao08 = tm.p                           #幣別符合
                      AND tao01 BETWEEN maj.maj21 AND maj.maj22
                      AND tao02 BETWEEN maj.maj24 AND maj.maj25
                      AND tao03 = tm.yy AND tao04 >=tm.bm AND tao04 <=g_mm
                      AND tao01 = aag01 AND aag07 IN ('2','3')
                END IF
               #No.MOD-860252---end--- modify
             END IF
          END IF
          IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
          IF amt1_1 IS NULL THEN LET amt1_1=0 END IF
          IF amt1_3 IS NULL THEN LET amt1_3=0 END IF
          IF amt2_1 IS NULL THEN LET amt2_1=0 END IF
          IF amt2_2 IS NULL THEN LET amt2_2=0 END IF
          IF amt2_3 IS NULL THEN LET amt2_3=0 END IF
          IF amt2_4 IS NULL THEN LET amt2_4=0 END IF
          #--- 日餘額
          IF tm.dd IS NOT NULL THEN
             IF maj.maj24 IS NULL THEN
             #--- 不列印外幣
               IF tm.o = 'N' THEN
                 #No.MOD-860252--begin-- modify
                  IF tm.s = 'Y' THEN 
                     SELECT SUM(aas04),SUM(aas05)
                       INTO l_tmp1,l_tmp2
                       FROM aas_file,aag_file WHERE aas00 = tm.b
                        AND aag00 = aas00   #NO.FUN-740055
                        AND aas01 BETWEEN maj.maj21 AND maj.maj22
                        AND aas02 BETWEEN bdate AND edate
                        AND aas01 = aag01 AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
                  ELSE
                     SELECT SUM(aas04),SUM(aas05)
                       INTO l_tmp1,l_tmp2
                       FROM aas_file,aag_file WHERE aas00 = tm.b
                        AND aag00 = aas00   #NO.FUN-740055
                        AND aas01 BETWEEN maj.maj21 AND maj.maj22
                        AND aas02 BETWEEN bdate AND edate
                        AND aas01 = aag01 AND aag07 IN ('2','3')
                  END IF 
                 #No.MOD-860252---end---
               ELSE
                 #No.MOD-860252---begin--
                 IF tm.s = 'Y' THEN
                  SELECT SUM(aas04),SUM(aas05)
                    INTO l_tmp1,l_tmp2
                    FROM aas_file,aag_file WHERE aas00 = tm.b
                     AND aag00 = aas00   #NO.FUN-740055
                     AND aas01 BETWEEN maj.maj21 AND maj.maj22
                     AND aas02 BETWEEN bdate AND edate
                     AND aas01 = aag01 AND aag07 IN ('2','3')
               ELSE
               #--- 本幣
                  SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)
                     INTO l_tmp1,l_tmp2,l_tmp3,l_tmp4
                     FROM tas_file,aag_file
                    WHERE tas00 = tm.b
                      AND aag00 = tas00   #NO.FUN-740055
                      AND tas08 = tm.p                        #幣別符合
                      AND tas01 BETWEEN maj.maj21 AND maj.maj22
                      AND tas02 BETWEEN bdate AND edate
                      AND tas01 = aag01 AND aag07 IN ('2','3')
                 END IF
                 #NO.MOD-860252---end---
                END IF
             ELSE
             #--- 不列印外幣
               IF tm.o = 'N' THEN
                 #No.MOD-860252--begin-- modify
                  IF tm.s = 'Y' THEN 
                     SELECT SUM(abb07) INTO l_tmp1 FROM aba_file,abb_file,aag_file
                      WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                        AND aag00 = aba00   #NO.FUN-740055
                        AND abb03 = aag01 AND aag07 IN ('2','3')
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND abb05 BETWEEN maj.maj24 AND maj.maj25
                        AND aba02 BETWEEN bdate AND edate AND abb06='1'
                        AND abaacti = 'Y'  #no.4868
                        AND aag09 = 'Y'
                        AND aba19 <> 'X'  #CHI-C80041
                     SELECT SUM(abb07) INTO l_tmp2 FROM aba_file,abb_file,aag_file
                      WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                        AND aag00 = aba00   #NO.FUN-740055
                        AND abb03 = aag01 AND aag07 IN ('2','3')
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND abb05 BETWEEN maj.maj24 AND maj.maj25
                        AND aba02 BETWEEN bdate AND edate AND abb06='2'
                        AND abaacti = 'Y'
                        AND aag09 = 'Y'
                        AND aba19 <> 'X'  #CHI-C80041
                  ELSE
                     SELECT SUM(abb07) INTO l_tmp1 FROM aba_file,abb_file,aag_file
                      WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                        AND aag00 = aba00   #NO.FUN-740055
                        AND abb03 = aag01 AND aag07 IN ('2','3')
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND abb05 BETWEEN maj.maj24 AND maj.maj25
                        AND aba02 BETWEEN bdate AND edate AND abb06='1'
                        AND abaacti = 'Y'  #no.4868
                        AND aba19 <> 'X'  #CHI-C80041
                     SELECT SUM(abb07) INTO l_tmp2 FROM aba_file,abb_file,aag_file
                      WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                        AND aag00 = aba00   #NO.FUN-740055
                        AND abb03 = aag01 AND aag07 IN ('2','3')
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND abb05 BETWEEN maj.maj24 AND maj.maj25
                        AND aba02 BETWEEN bdate AND edate AND abb06='2'
                        AND abaacti = 'Y'
                        AND aba19 <> 'X'  #CHI-C80041
                  END IF 
                 #No.MOD-860252---end---
               ELSE
                 #No.MOD-860252--begin-- modify
                  IF tm.s = 'Y' THEN
                  SELECT SUM(abb07) INTO l_tmp1 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND aag00 = aba00   #NO.FUN-740055
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25
                     AND aba02 BETWEEN bdate AND edate AND abb06='1'
                     AND abaacti = 'Y'  #no.4868
                     AND aba19 <> 'X'  #CHI-C80041
                  SELECT SUM(abb07) INTO l_tmp2 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND aag00 = aba00   #NO.FUN-740055
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25
                     AND aba02 BETWEEN bdate AND edate AND abb06='2'
                     AND abaacti = 'Y'
                     AND aba19 <> 'X'  #CHI-C80041
               ELSE
                  SELECT SUM(abb07),SUM(abb07f)
                    INTO l_tmp1,l_tmp3
                    FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01
                     AND aag00 = aba00   #NO.FUN-740055
                     AND abb00 = tm.b  AND abb24 = tm.p
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25
                     AND aba02 BETWEEN bdate AND edate AND abb06='1'
                     AND abaacti = 'Y'
                     AND aba19 <> 'X'  #CHI-C80041
                  SELECT SUM(abb07),SUM(abb07f)
                    INTO l_tmp2,l_tmp4
                    FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01
                     AND aag00 = aba00   #NO.FUN-740055
                     AND abb00 = tm.b  AND abb24 = tm.p
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25
                     AND aba02 BETWEEN bdate AND edate AND abb06='2'
                     AND abaacti = 'Y'
                     AND aba19 <> 'X'  #CHI-C80041
                  END IF
                 #No.MOD-860252---end---
                END IF
             END IF
             IF STATUS THEN CALL cl_err('aas',STATUS,1) EXIT FOREACH END IF
             IF l_tmp1 IS NULL THEN LET l_tmp1 = 0 END IF
             IF l_tmp2 IS NULL THEN LET l_tmp2 = 0 END IF
             IF l_tmp3 IS NULL THEN LET l_tmp3 = 0 END IF
             IF l_tmp4 IS NULL THEN LET l_tmp4 = 0 END IF
             LET amt2_1 = amt2_1 + l_tmp1
             LET amt2_2 = amt2_2 + l_tmp2
             LET amt2_3 = amt2_3 + l_tmp3
             LET amt2_4 = amt2_4 + l_tmp4
          END IF
          IF tm.o = "N" THEN
             IF amt1_1<0 THEN LET amt1_2=amt1_1*-1 LET amt1_1=0 END IF
             #--- 期末
             LET amt4_1=amt1_1+amt2_1-amt1_2-amt2_2
             IF amt4_1<0 THEN LET amt4_2=amt4_1*-1 LET amt4_1=0 END IF
          ELSE
             #--- 期末
             LET amt4_1=amt1_1+amt2_1-amt2_2
             LET amt4_3=amt1_3+amt2_3-amt2_4
             IF amt1_3<0 THEN LET amt1_3=amt1_3*-1 END IF
             IF amt4_3<0 THEN LET amt4_3=amt4_3*-1 END IF
          END IF
       END IF
 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN #合計階數處理
          FOR i = 1 TO 100
             #CHI-AC0008 mod --start--
             #LET g_tot1_1[i]=g_tot1_1[i]+amt1_1
             #LET g_tot1_2[i]=g_tot1_2[i]+amt1_2
             #LET g_tot1_3[i]=g_tot1_3[i]+amt1_3
             #LET g_tot1_4[i]=g_tot1_4[i]+amt1_4
             #LET g_tot2_1[i]=g_tot2_1[i]+amt2_1
             #LET g_tot2_2[i]=g_tot2_2[i]+amt2_2
             #LET g_tot2_3[i]=g_tot2_3[i]+amt2_3
             #LET g_tot2_4[i]=g_tot2_4[i]+amt2_4
             #LET g_tot4_1[i]=g_tot4_1[i]+amt4_1
             #LET g_tot4_2[i]=g_tot4_2[i]+amt4_2
             #LET g_tot4_3[i]=g_tot4_3[i]+amt4_3
             #LET g_tot4_4[i]=g_tot4_4[i]+amt4_4
              IF maj.maj09 = '-' THEN
                 LET g_tot1_1[i] = g_tot1_1[i] - amt1_1
                 LET g_tot1_2[i] = g_tot1_2[i] - amt1_2
                 LET g_tot1_3[i] = g_tot1_3[i] - amt1_3
                 LET g_tot1_4[i] = g_tot1_4[i] - amt1_4
                 LET g_tot2_1[i] = g_tot2_1[i] - amt2_1
                 LET g_tot2_2[i] = g_tot2_2[i] - amt2_2
                 LET g_tot2_3[i] = g_tot2_3[i] - amt2_3
                 LET g_tot2_4[i] = g_tot2_4[i] - amt2_4
                 LET g_tot4_1[i] = g_tot4_1[i] - amt4_1
                 LET g_tot4_2[i] = g_tot4_2[i] - amt4_2
                 LET g_tot4_3[i] = g_tot4_3[i] - amt4_3
                 LET g_tot4_4[i] = g_tot4_4[i] - amt4_4
              ELSE
                 LET g_tot1_1[i] = g_tot1_1[i] + amt1_1
                 LET g_tot1_2[i] = g_tot1_2[i] + amt1_2
                 LET g_tot1_3[i] = g_tot1_3[i] + amt1_3
                 LET g_tot1_4[i] = g_tot1_4[i] + amt1_4
                 LET g_tot2_1[i] = g_tot2_1[i] + amt2_1
                 LET g_tot2_2[i] = g_tot2_2[i] + amt2_2
                 LET g_tot2_3[i] = g_tot2_3[i] + amt2_3
                 LET g_tot2_4[i] = g_tot2_4[i] + amt2_4
                 LET g_tot4_1[i] = g_tot4_1[i] + amt4_1
                 LET g_tot4_2[i] = g_tot4_2[i] + amt4_2
                 LET g_tot4_3[i] = g_tot4_3[i] + amt4_3
                 LET g_tot4_4[i] = g_tot4_4[i] + amt4_4
              END IF
             #CHI-AC0008 mod --start--
          END FOR
          LET k=maj.maj08
          LET sr.bal1_1=g_tot1_1[k] LET sr.bal1_2=g_tot1_2[k]
          LET sr.bal1_3=g_tot1_3[k] LET sr.bal1_4=g_tot1_4[k]
          LET sr.bal2_1=g_tot2_1[k] LET sr.bal2_2=g_tot2_2[k]
          LET sr.bal2_3=g_tot2_3[k] LET sr.bal2_4=g_tot2_4[k]
          LET sr.bal4_1=g_tot4_1[k] LET sr.bal4_2=g_tot4_2[k]
          LET sr.bal4_3=g_tot4_3[k] LET sr.bal4_4=g_tot4_4[k]
          #CHI-AC0008 add --start--
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET sr.bal1_1 = sr.bal1_1 *-1
             LET sr.bal1_2 = sr.bal1_2 *-1
             LET sr.bal1_3 = sr.bal1_3 *-1
             LET sr.bal1_4 = sr.bal1_4 *-1
             LET sr.bal2_1 = sr.bal2_1 *-1
             LET sr.bal2_2 = sr.bal2_2 *-1
             LET sr.bal2_3 = sr.bal2_3 *-1
             LET sr.bal2_4 = sr.bal2_4 *-1
             LET sr.bal4_1 = sr.bal4_1 *-1
             LET sr.bal4_2 = sr.bal4_2 *-1
             LET sr.bal4_3 = sr.bal4_3 *-1
             LET sr.bal4_4 = sr.bal4_4 *-1
          END IF
          #CHI-AC0008 add --end--
          FOR i = 1 TO maj.maj08
              LET g_tot1_1[i]=0 LET g_tot1_2[i]=0 LET g_tot1_3[i]=0
              LET g_tot1_4[i]=0 LET g_tot2_1[i]=0 LET g_tot2_2[i]=0
              LET g_tot2_3[i]=0 LET g_tot2_4[i]=0 LET g_tot4_1[i]=0
              LET g_tot4_2[i]=0 LET g_tot4_3[i]=0 LET g_tot4_4[i]=0
          END FOR
       ELSE
          LET sr.bal1_1=NULL LET sr.bal1_2=NULL LET sr.bal1_3=NULL
          LET sr.bal1_4=NULL LET sr.bal2_1=NULL LET sr.bal2_2=NULL
          LET sr.bal2_3=NULL LET sr.bal2_4=NULL LET sr.bal4_1=NULL
          LET sr.bal4_2=NULL LET sr.bal4_3=NULL LET sr.bal4_4=NULL
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF    #本行不印出
       IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"
          AND sr.bal1_1=0 AND sr.bal1_2=0 AND sr.bal1_3=0 AND sr.bal1_4=0
          AND sr.bal2_1=0 AND sr.bal2_2=0 AND sr.bal2_3=0 AND sr.bal2_4=0
          AND sr.bal4_1=0 AND sr.bal4_2=0 AND sr.bal4_3=0 AND sr.bal4_4=0
       THEN CONTINUE FOREACH				#餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH				#最小階數起列印
       END IF
       #No.FUN-780031  --Begin
       #OUTPUT TO REPORT r105_rep(maj.*, sr.*)
       IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
#      EXECUTE insert_prep USING sr.*,maj.maj02,maj.maj03,maj.maj20[1,25]       #MOD-950314
       EXECUTE insert_prep USING sr.*,maj.maj02,maj.maj03,maj.maj20             #MOD-950314
       #No.FUN-780031  --End  
     END FOREACH
 
     #No.FUN-780031  --Begin
     #FINISH REPORT r105_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF tm.o = 'N' THEN 
         LET l_name = 'gglr307'
     ELSE
         LET l_name = 'gglr307_1'
     END IF
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF cl_null(tm.dd) THEN LET tm.dd='0' END IF
     LET g_str = g_str,";",g_aaz.aaz77,";",g_mai02,";",tm.d,";",tm.a,";",
                 tm.yy,";",tm.bm,";",tm.em,";",tm.dd,";",tm.p,";",
                 g_unit,";",tm.e    
     CALL cl_prt_cs3('gglr307',l_name,g_sql,g_str)
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT r105_rep(maj, sr)
#   DEFINE l_last_sw    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
#   DEFINE l_unit       LIKE zaa_file.zaa08        #NO FUN-690009   VARCHAR(4)
#   DEFINE cc1          LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
#   DEFINE cc2          LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
#   DEFINE maj RECORD LIKE maj_file.*
#   DEFINE sr  RECORD
#              bal1_1	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初原幣
#              bal1_2	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初原幣
#              bal1_3	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初本幣
#              bal1_4	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期初本幣
#              bal2_1	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期原幣借
#              bal2_2	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期原幣貸
#              bal2_3	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期本幣借
#              bal2_4	LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 本期本幣貸
#              bal4_1    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末原幣
#              bal4_2    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末原幣
#              bal4_3    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)    #--- 期末本幣
#              bal4_4    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)    #--- 期末本幣
#              END RECORD
#   DEFINE  l_title      LIKE type_file.chr1000    #No.TQC-770087
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY maj.maj02
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom CLIPPED;
#      END IF
##No.TQC-6A0094 -- begin --
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      CASE tm.d
##           WHEN '1'  LET l_unit = g_x[14]
##           WHEN '2'  LET l_unit = g_x[15]
##           WHEN '3'  LET l_unit = g_x[16]
##           OTHERWISE LET l_unit = ' '
##      END CASE
##      IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
##      PRINT g_x[12] CLIPPED,tm.a, COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,g_x[1],
##            COLUMN (g_len-FGL_WIDTH(g_user)-5),g_x[13] CLIPPED,l_unit
##      PRINT
##      LET g_pageno = g_pageno + 1
##      PRINT g_x[2] CLIPPED,g_pdate ,
##            COLUMN (g_len-FGL_WIDTH(g_x[11])-16)/2,g_x[11] CLIPPED,
##            tm.yy USING '<<<<','/',tm.bm USING'&&';
##            IF tm.dd IS NOT NULL THEN PRINT '/01'               ; END IF
##            PRINT '-',tm.yy USING '<<<<','/',tm.em USING'&&';
##            IF tm.dd IS NOT NULL THEN PRINT '/',tm.dd USING '&&'; END IF
##            IF tm.o = "N" THEN                     #Modify by maggie
##               PRINT COLUMN g_len-11,g_x[3] CLIPPED,PAGENO USING '<<<'
##            ELSE
##               PRINT COLUMN g_len-17,g_x[3] CLIPPED,'(Page)',PAGENO USING '<<<'
##            END IF
#         LET g_pageno = g_pageno + 1
## No.TQC-740305 --begin
##     PRINT g_x[2] CLIPPED,g_pdate,
##           COLUMN (g_len-FGL_WIDTH(g_user CLIPPED)-15),'FROM:',g_user CLIPPED,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      LET l_title = NULL          #No.TQC-770087
#      IF g_aaz.aaz77 = 'Y' THEN
#      #No.TQC-770087--begin--
#        #LET g_x[1] = g_x[1] CLIPPED,' (',g_mai02 CLIPPED,')'
#         LET l_title = g_x[1] CLIPPED,' (',g_mai02 CLIPPED,')'
#      ELSE
#         LET l_title = g_x[1] CLIPPED
#      #No.TQC-770087---end---
#      END IF
#     #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED      #No.TQC-770087  mark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,l_title CLIPPED      #No.TQC-770087 
#      PRINT g_x[2] CLIPPED,g_pdate,
#            COLUMN (g_len-FGL_WIDTH(g_user CLIPPED)-15),'FROM:',g_user CLIPPED,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
## No.TQC-740305 --end
#      CASE tm.d                                                                
#           WHEN '1'  LET l_unit = g_x[14] CLIPPED
#           WHEN '2'  LET l_unit = g_x[15] CLIPPED
#           WHEN '3'  LET l_unit = g_x[16] CLIPPED
#           OTHERWISE LET l_unit = ' '
#      END CASE
#      PRINT g_x[12] CLIPPED,tm.a;   #,COLUMN (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2,g_x[1] CLIPPED;
#      PRINT COLUMN (g_len-FGL_WIDTH(g_x[11] CLIPPED)-16)/2,g_x[11] CLIPPED,
#            tm.yy USING '<<<<','/',tm.bm USING'&&';
#      IF tm.dd IS NOT NULL THEN PRINT '/01'; END IF
#      PRINT '-',tm.yy USING '<<<<','/',tm.em USING'&&';
#      IF tm.dd IS NOT NULL THEN
#         PRINT '/',tm.dd USING '&&';
#      ELSE
#         PRINT '';
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user CLIPPED)-5),g_x[13] CLIPPED,l_unit CLIPPED
##No.TQC-6A0094 -- end --
#      IF tm.o = "N" THEN                           #Modify by maggie
#     #MOD-590097--start--
#         PRINT COLUMN 01, g_x[35],g_x[36],g_x[37],g_x[38]
#         PRINT COLUMN 01, g_x[17] CLIPPED,g_x[18] CLIPPED,g_x[19] CLIPPED,
#                          g_x[20] CLIPPED
#         PRINT COLUMN 01, g_x[39],g_x[40],g_x[41],g_x[42]
#         PRINT COLUMN 01, g_x[21] CLIPPED,g_x[22] CLIPPED,g_x[23] CLIPPED,
#                          g_x[22] CLIPPED,g_x[23] CLIPPED,g_x[22] CLIPPED,
#                          g_x[23] CLIPPED
#      ELSE
#         PRINT COLUMN 01, g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#         PRINT COLUMN 01, g_x[17] CLIPPED,
#               COLUMN 33, g_x[24] CLIPPED,g_x[25] CLIPPED,g_x[26] CLIPPED,
#               COLUMN 147,g_x[27] CLIPPED
#
#         PRINT COLUMN 01, g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
#     #MOD-590097--end--
#         PRINT COLUMN 01, g_x[28] CLIPPED,g_x[29] CLIPPED,g_x[30] CLIPPED,
#                          g_x[31] CLIPPED,g_x[30] CLIPPED,g_x[31] CLIPPED,
#                          g_x[30] CLIPPED,g_x[31] CLIPPED,g_x[29] CLIPPED,
#                          g_x[30] CLIPPED,g_x[31] CLIPPED
#      END IF
#
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      LET cc1=0
#      LET cc2=0
#      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
#      IF maj.maj03 = '9' THEN SKIP TO TOP OF PAGE
#      ELSE
#        IF tm.o ="N" THEN
#     #MOD-590097--start--
#           PRINT COLUMN 01, g_x[53],g_x[54],g_x[55],g_x[56]
#           PRINT COLUMN 01, g_x[71],maj.maj20[1,25] CLIPPED,
#                 COLUMN 29, g_x[71],cl_numfor(sr.bal1_1/g_unit,18,tm.e),
#                 COLUMN 51, g_x[71],cl_numfor(sr.bal1_2/g_unit,18,tm.e),
#                 COLUMN 73, g_x[71],cl_numfor(sr.bal2_1/g_unit,18,tm.e),
#                 COLUMN 95, g_x[71],cl_numfor(sr.bal2_2/g_unit,18,tm.e),
#                 COLUMN 117, g_x[71],cl_numfor(sr.bal4_1/g_unit,18,tm.e),
#                 COLUMN 139,g_x[71],cl_numfor(sr.bal4_2/g_unit,18,tm.e),
#                 COLUMN 161,g_x[71]
#      #MOD-590097--end--
#        ELSE
#          IF sr.bal1_1 > 0 THEN
#             LET cc1 = 1
#          ELSE
#             IF sr.bal1_1 < 0 THEN
#                LET sr.bal1_1 = sr.bal1_1 * -1
#                LET cc1 = 2
#             END IF
#          END IF
#          IF sr.bal4_1 > 0 THEN
#             LET cc2 = 1
#          ELSE
#             IF sr.bal4_1 < 0 THEN
#                LET sr.bal4_1 = sr.bal4_1 * -1
#                LET cc2 = 2
#             END IF
#          END IF
#   #MOD-590097--start--
#          PRINT COLUMN 01, g_x[57],g_x[58],g_x[59],g_x[60],g_x[61]
#          PRINT COLUMN 01, g_x[71],maj.maj20[1,25] CLIPPED;
#          IF cc1 = 1 THEN
#             PRINT COLUMN 29, g_x[71],g_x[32] CLIPPED;
#          ELSE
#             IF cc1 =2 THEN
#             PRINT COLUMN 29, g_x[71],g_x[33] CLIPPED;
#             ELSE PRINT COLUMN 29, g_x[71],g_x[34] CLIPPED;
#             END IF
#          END IF
#          PRINT COLUMN 35, g_x[71],tm.p CLIPPED,cl_numfor(sr.bal1_3/g_unit,18,tm.e),
#                COLUMN 61, g_x[71],cl_numfor(sr.bal1_1/g_unit,18,tm.e),
#                COLUMN 83, g_x[71],tm.p CLIPPED,cl_numfor(sr.bal2_3/g_unit,18,tm.e),
#                COLUMN 109, g_x[71],cl_numfor(sr.bal2_1/g_unit,18,tm.e),
#                COLUMN 131,g_x[71],tm.p CLIPPED,cl_numfor(sr.bal2_4/g_unit,18,tm.e),
#                COLUMN 157,g_x[71],cl_numfor(sr.bal2_2/g_unit,18,tm.e);
#          IF cc2 = 1 THEN
#             PRINT COLUMN 179,g_x[71],g_x[32] CLIPPED;
#          ELSE
#             IF cc2 =2 THEN
#             PRINT COLUMN 179,g_x[71],g_x[33] CLIPPED;
#             ELSE PRINT COLUMN 179,g_x[71],g_x[34] CLIPPED;
#             END IF
#          END IF
#          PRINT COLUMN 185,g_x[71],tm.p CLIPPED,cl_numfor(sr.bal4_3/g_unit,18,tm.e),
#                COLUMN 211,g_x[71],cl_numfor(sr.bal4_1/g_unit,18,tm.e),
#                COLUMN 233,g_x[71]
#    #MOD-590097--end--
#        END IF
#      END IF
# 
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      IF tm.o = "N" THEN
#    #MOD-590097--start--
#         PRINT COLUMN 01, g_x[62],g_x[63],g_x[64],g_x[65]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      ELSE
#         PRINT COLUMN 01, g_x[66],g_x[67],g_x[68],g_x[69],g_x[70]
#    #MOD-590097--end--
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         IF tm.o = "N" THEN
#    #MOD-590097--start--
#            PRINT COLUMN 01, g_x[62],g_x[63],g_x[64],g_x[65]
#         ELSE
#             PRINT COLUMN 01, g_x[66],g_x[67],g_x[68],g_x[69],g_x[70]
#    #MOD-590097--end--
#         END IF
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780031  --End  
#Patch....NO.TQC-610037 <001> #
