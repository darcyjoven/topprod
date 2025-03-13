# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: aglr100.4gl
# Descriptions...: 多部門財務報表
# Date & Author..: 97/12/17 By Danny
# Modify.........: No.MOD-550009 05/05/17 By ching  fix正負號問題
# Modify.........: No.MOD-590089 05/09/12 By Smapmin maj06應是處理營業
#                      成本相關報表的欄位,程式中針對 maj06的處理應取消
# Modify.........: No.TQC-630157 06/04/04 By Smapmin 新增是否列印下層部門的選項
# Modify.........: No.MOD-640089 06/04/10 By Smapmin 合計階計算錯誤
# Modify.........: No.MOD-640583 06/04/28 By Smapmin 修改變數定義
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6A0173 06/10/31 By Smapmin 修正金額顯示
# Modify.........: No.MOD-6C0142 06/12/20 By Smapmin 資產負債表也要能執行
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-6B0021 07/03/14 By jamie 族群欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/03/28 By lora   會計科目加帳套
# Modify.........: No.MOD-7B0162 07/11/22 By Smapmin 重新過單
# Modify.........: No.FUN-830053 08/03/17 By johnray 結構報表改CR
# Modify.........: No.MOD-840601 08/04/28 By douzh 處理欄位打印對齊問題,合計金額有打印
# Modify.........: No.MOD-850043 08/05/06 By Smapmin 將邏輯改的跟aglr110一致.
# Modify.........: No.MOD-870071 08/07/10 By Sarah 報表數字欄位(原l_str1~l_str10)改成直接寫入數字,取位的動作到rpt再做
# Modify.........: No.MOD-880204 08/09/17 By Sarah 取消舊zaa寫法
# Modify.........: No.MOD-8A0259 08/10/30 By Sarah 1.報表結構列印碼已設定為2.金額不為0才印出,出表卻仍印出
#                                                  2.報表結構最後一行設總計,出表卻沒印
# Modify.........: No.MOD-8A0286 08/11/03 By Sarah 寫入空行資料的FOR迴圈不可用i變數,會與外面另一個FOR迴圈用到同一個變數造成無窮迴圈
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.MOD-A80241 10/08/31 By Dido 合計階增加 maj09 處理 
# Modify.........: No.MOD-B40245 11/04/27 By Dido l_sql 宣告改用 STRING;科目餘額無資料取消檢核
# Modify.........: No.CHI-B50007 11/05/18 By JoHung 增加分頁選項;依選項抓不同的rpt 
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-BC0237 11/12/26 By Dido 傳取位變數至 RPT 取位;調整maj03為'5'的處理 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-C10184 12/01/30 By Polly 修正l_amt陣列清空導致會有無部門確有金額的問題產生
# Modify.........: No.MOD-C30009 12/03/03 By Polly cl_prt_cs3多傳CR參數g_azi04
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-C90020 12/09/20 By Elise 參考 aglr110 處理 maj07/maj09   
# Modify.........: No.MOD-C80087 12/10/10 By yinhy 去除CE類憑證
# Modify.........: No.TQC-CA0041 12/10/16 By yinhy 帳套應使用g_bookno
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           a       LIKE mai_file.mai01,     #報表結構編號  #No.FUN-680098   VARCHAR(6)   
           b       LIKE aaa_file.aaa01,     #帳別編號      #No.FUN-670039 
           abe01   LIKE abe_file.abe01,     #列印族群/部門層級/部門  #No.FUN-680098  VARCHAR(6)  
           yy      LIKE type_file.num5,     #輸入年度      #No.FUN-680098  smallint  
           bm      LIKE type_file.num5,     #Begin 期別    #No.FUN-680098  smallint
           em      LIKE type_file.num5,     # End  期別    #No.FUN-680098  smallint 
           c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1)  
           d       LIKE type_file.chr1,     #金額單位             #No.FUN-680098   VARCHAR(1)
           e       LIKE type_file.chr1,     #列印額外名稱 #FUN-6C0012
           f       LIKE type_file.num5,     #列印最小階數         #No.FUN-680098   smallint  
           s       LIKE type_file.chr1,     #列印下層部門         #TQC-630157  #No.FUN-680098  VARCHAR(1)   
           p       LIKE type_file.chr1,     #分頁選項            #CHI-B50007  char(1)
           more    LIKE type_file.chr1      #Input more condition(Y/N)         #No.FUN-680098  VARCHAR(1)   
           END RECORD,
       i,j,k,g_mm LIKE type_file.num5,      #No.FUN-680098   smallint
       g_unit     LIKE type_file.num10,     #金額單位基數  #No.FUN-680098  integer
      #g_buf      LIKE type_file.chr1000,   #No.FUN-680098     char(600)  #MOD-B40245 mark 
       g_buf      STRING,                   #MOD-B40245   
       g_cn       LIKE type_file.num5,      #No.FUN-680098     smallint
       g_flag     LIKE type_file.chr1,      #No.FUN-680098     VARCHAR(1)    
       g_bookno   LIKE aah_file.aah00,      #帳別      
       g_gem05    LIKE gem_file.gem05,
       m_dept     DYNAMIC ARRAY OF LIKE gem_file.gem02,   #No.FUN-680098      VARCHAR(300)   #No.FUN-830053 add
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_abd01    LIKE abd_file.abd01,
       g_abe01    LIKE abe_file.abe01,
       g_total    DYNAMIC ARRAY OF RECORD
                   maj02 LIKE maj_file.maj02,
                   amt    LIKE type_file.num20_6                   #No.FUN-680098  dec(20,6)
                  END RECORD,
       g_tot1     DYNAMIC ARRAY OF  LIKE type_file.num20_6,  #MOD-640583   #No.FUN-680098  dec(20,6)
       g_no       LIKE type_file.num5,                  #No.FUN-680098    smallint
       g_dept     DYNAMIC ARRAY OF RECORD
                  gem01 LIKE gem_file.gem01, #部門編號
                  gem05 LIKE gem_file.gem05  #是否為會計部門
                  END RECORD,
       maj02_max  LIKE type_file.num5     #MOD-640089   #MOD-640583  #No.FUN-680098  smallint 
 
DEFINE g_aaa03    LIKE aaa_file.aaa03
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
DEFINE g_sql      STRING                  #No.FUN-830053
DEFINE l_table    STRING                  #No.FUN-830053  #MOD-9A0192 mod chr20->STRING
DEFINE l_table1   STRING                  #CHI-B50007
DEFINE g_str      STRING                  #No.FUN-830053
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   #TQC-630157
   LET tm.abe01= ARG_VAL(10)
   LET tm.yy   = ARG_VAL(11)
   LET tm.bm   = ARG_VAL(12)
   LET tm.em   = ARG_VAL(13)
   LET tm.c    = ARG_VAL(14)
   LET tm.d    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.s    = ARG_VAL(17)   #TQC-630157
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET tm.e    = ARG_VAL(21)   #FUN-6C0012
   LET tm.p    = ARG_VAL(22)   #CHI-B50007
 
   DROP TABLE r100_file
   LET g_sql="maj02.maj_file.maj02,maj03.maj_file.maj03,",
             "maj04.maj_file.maj04,maj05.maj_file.maj05,",
             "maj07.maj_file.maj07,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,page.type_file.num5,",
             "m_dept1.gem_file.gem02,m_dept2.gem_file.gem02,",
             "m_dept3.gem_file.gem02,m_dept4.gem_file.gem02,",
             "m_dept5.gem_file.gem02,m_dept6.gem_file.gem02,",
             "m_dept7.gem_file.gem02,m_dept8.gem_file.gem02,",
             "m_dept9.gem_file.gem02,m_dept10.gem_file.gem02,",
             "l_amt1.type_file.num20_6,l_amt2.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt3.type_file.num20_6,l_amt4.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt5.type_file.num20_6,l_amt6.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt7.type_file.num20_6,l_amt8.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt9.type_file.num20_6,l_amt10.type_file.num20_6,",  #MOD-870071 mod str->amt
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglr100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

#CHI-B50007 -- begin --
   LET g_sql="maj02.maj_file.maj02,maj03.maj_file.maj03,",
             "maj04.maj_file.maj04,maj05.maj_file.maj05,",
             "maj07.maj_file.maj07,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,page.type_file.num5,",
             "m_dept.gem_file.gem02,l_amt.type_file.num20_6,",
             "line.type_file.num5"
   LET l_table1 = cl_prt_temptable('aglr1001',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      EXIT PROGRAM 
   END IF
#CHI-B50007 -- end --
 
   CREATE TEMP TABLE r100_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       maj21     LIKE maj_file.maj21,
       maj22     LIKE maj_file.maj22,
       bal1      LIKE type_file.num20_6)  
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF         #No.FUN-740020
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r100_tm()                        # Input print condition
   ELSE
      CALL r100()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r100_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  VARCHAR(1)   
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098   VARCHAR(400)   
   DEFINE li_chk_bookno LIKE type_file.num5            #No.FUN-670005   #No.FUN-680098   smallint
   DEFINE li_result      LIKE type_file.num5           #No.FUN-6C0068   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r100_w AT p_row,p_col WITH FORM "agl/42f/aglr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF         #No.FUN-740020
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b     #No.FUN-740020
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   # NO.FUN-660123 #No.FUN-740020 
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
   LET tm.b = g_aza.aza81    #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.p = '1'  #CHI-B50007
   LET tm.f = 0
   LET tm.s = 'N'   #TQC-630157
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
 
    INPUT BY NAME tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.s,tm.e,tm.p,tm.more   #TQC-630157   #FUN-6C0012 #No.FUN-740020  #CHI-B50007
		  WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b  #No.FUN-740020
         IF STATUS THEN
            CALL cl_err3("sel","mai_file",tm.b,"",STATUS,"","sel mai:",0)   # NO.FUN-660123   #No.FUN-740020
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
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN
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
 
      AFTER FIELD s
         IF cl_null(tm.s) OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD bm
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
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
 
      AFTER FIELD em
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
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF

     AFTER FIELD p
         IF cl_null(tm.p) OR tm.p NOT MATCHES'[12]' THEN NEXT FIELD p END IF
 
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
        CASE
           WHEN tm.d = '1'  LET g_unit = 1
           WHEN tm.d = '2'  LET g_unit = 1000
           WHEN tm.d = '3'  LET g_unit = 1000000
        END CASE
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
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"   #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6') "     #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
 
            WHEN INFIELD(abe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_abe'
               LET g_qryparam.default1 = tm.abe01
               CALL cl_create_qry() RETURNING tm.abe01
               DISPLAY BY NAME tm.abe01
               NEXT FIELD abe01
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr100','9031',1)  
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-630157
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",    #FUN-6C0012
                         " '",tm.f CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,   #TQC-630157
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20)   
   DEFINE l_name1   LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098   VARCHAR(20)   
  #DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098   char(1000)  #MOD-B40245 mark 
   DEFINE l_sql     STRING                        # RDSQL STATEMENT        #MOD-B40245 
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1)   
   DEFINE l_leng,l_leng2  LIKE type_file.num5     #No.FUN-680098  smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_abd02   LIKE abd_file.abd02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01
   DEFINE l_maj20   LIKE maj_file.maj20        #No.FUN-680098    VARCHAR(30)   
   DEFINE l_bal     LIKE type_file.num20_6     #No.FUN-680098    DEC(20,6)  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6    #實際    #No.FUN-680098  DECIMAL(20,6)
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
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5     LIKE type_file.chr20     #No.FUN-680098   VARCHAR(20)   #MOD-870071 mark
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10    LIKE type_file.chr20     #No.FUN-680098   VARCHAR(20)   #MOD-870071 mark
   DEFINE m_abd02 LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5       #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)    
   DEFINE l_amtstr                DYNAMIC ARRAY OF LIKE type_file.chr20    #No.FUN-830053 add
   DEFINE l_amt                   DYNAMIC ARRAY OF LIKE type_file.num20_6  #MOD-870071 add
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)   
          l_zero2       LIKE type_file.chr1            #No.FUN-680098  VARCHAR(1)   
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01=tm.b AND aaf02=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr100'
 
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF

#CHI-B50007 -- begin -- 
   CALL cl_del_data(l_table1)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
#CHI-B50007 -- end --
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",   #MOD-6C0142
               " ORDER BY maj02"
   PREPARE r100_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r100_c CURSOR FOR r100_p
  
   SELECT COUNT(*) INTO maj02_max FROM maj_file    #MOD-640583
     WHERE maj01 = tm.a   #MOD-6C0142
   IF cl_null(maj02_max) THEN LET maj02_max = 0 END IF
   LET g_mm = tm.em
   LET l_i = 1
   FOR l_i = 1 TO maj02_max
       LET g_total[l_i].maj02 = NULL
       LET g_total[l_i].amt = 0
   END FOR
   LET g_i = 1 FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
   LET g_no = 1 FOR g_no = 1 TO maj02_max INITIALIZE g_dept[g_no].* TO NULL END FOR
 
#將部門填入array------------------------------------
   LET g_buf = ''
   IF g_abe01 = ' ' THEN
     IF g_abd01 = ' ' THEN                   #--- 部門
       LET g_no = 1
       LET g_dept[g_no].gem01 = tm.abe01
       LET g_dept[g_no].gem05 = g_gem05
     ELSE                                    #--- 部門層級
       LET g_no=0
       DECLARE r192_bom1 CURSOR FOR
         SELECT abd02,gem05 FROM abd_file,gem_file
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
      DECLARE r192_bom2 CURSOR FOR
        SELECT abe03,gem05 FROM abe_file,gem_file
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
#CHI-B50007 原程式段搬到r100_page()
#CHI-B50007 -- begein --
   IF tm.p = '1' THEN
      CALL r100_page()
   ELSE
      CALL r100_not_page()
   END IF
#CHI-B50007 -- end --
#---------------------------------------------------
END FUNCTION

#CHI-B50007
FUNCTION r100_page()
   DEFINE l_name1   LIKE type_file.chr20
   DEFINE l_chr     LIKE type_file.chr1  
   DEFINE l_leng,l_leng2  LIKE type_file.num5
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6
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
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5
   DEFINE l_amt                   DYNAMIC ARRAY OF LIKE type_file.num20_6
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,
          l_zero2       LIKE type_file.chr1
#控制一次印十個部門---------------------------------
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   LET l_i = 0
   FOR l_i = 10 TO l_cnt STEP 10
      LET g_flag = 'n'
      LET l_name1='r100_',l_i/10 USING '&&&','.out'
 
      LET g_pageno = 0
 
      LET g_cn = 0
      DELETE FROM r100_file
      CALL m_dept.clear()          #No.FUN-830053 add
      IF l_i <= g_no THEN
         LET l_no = l_i - 10
         FOR l_cn = 1 TO 10
            LET g_i = 1
            FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
            LET g_buf = ''
            LET l_dept = g_dept[l_no+l_cn].gem01
            LET l_chr  = g_dept[l_no+l_cn].gem05
            LET l_gem02 = ''
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
            LET l_leng2 = LENGTH(l_gem02_o)
            LET l_leng2 = 16 - l_leng2
            LET m_dept[l_cn] = l_gem02
            IF tm.s = 'Y' THEN
               CALL r100_bom(l_dept,l_chr)
            END IF
            IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
           #LET l_leng=LENGTH(g_buf)                        #MOD-B40245 mark
            LET l_leng = g_buf.getlength()                  #MOD-B40245
           #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B40245 mark
            LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B40245
            CALL r100_process(l_cn)
            LET g_cn = l_cn
	    LET l_gem02_o = l_gem02
         END FOR
      ELSE
         LET l_no = (l_i - 10)
         FOR l_cn = 1 TO (g_no - (l_i - 10))
            LET g_i = 1
            FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
            LET g_buf = ''
            LET l_dept = g_dept[l_no+l_cn].gem01
            LET l_chr  = g_dept[l_no+l_cn].gem05
            LET l_gem02 = ''
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
            LET l_leng2 = LENGTH(l_gem02_o)
            LET l_leng2 = 16 - l_leng2
            LET m_dept[l_cn] = l_gem02
            IF tm.s = 'Y' THEN
               CALL r100_bom(l_dept,l_chr)
            END IF
            IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
           #LET l_leng=LENGTH(g_buf)                        #MOD-B40245 mark
            LET l_leng = g_buf.getlength()                  #MOD-B40245
           #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B40245 mark
            LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B40245
            CALL r100_process(l_cn)
            LET g_cn = l_cn
            LET l_gem02_o = l_gem02
         END FOR
         LET l_leng2 = LENGTH(l_gem02)
         LET l_leng2 = 16 - l_leng2
         LET m_dept[g_cn+1] = '合  計'                                 #No.FUN-830053 mark
         LET g_flag = 'y'
      END IF
      IF l_i > g_no AND (g_no MOD 10) = 0  THEN
         FOR i = 1 TO maj02_max
            IF g_total[i].maj02 IS NOT NULL THEN
               SELECT maj02,maj03,maj04,maj05,maj07,maj20,maj20e INTO sr1.*
                 FROM maj_file
                WHERE maj01 = tm.a
                  AND maj02 = g_total[i].maj02
               LET sr1.maj20 = sr1.maj05 SPACES,sr1.maj20   #MOD-870071 add
               LET sr1.maj20e= sr1.maj05 SPACES,sr1.maj20e  #MOD-870071 add
               CALL l_amt.clear()                           #MOD-C10184 add
               IF sr1.maj03 = '%' THEN
                  LET l_amt[1] = g_total[i].amt   #MOD-870071 add
               ELSE
                  LET l_amt[1] = g_total[i].amt   #MOD-870071 add
               END IF
               #表頭不應該列印金額
               IF sr1.maj03 = 'H' THEN
                  CALL l_amt.clear()        #MOD-870071 add
               END IF
               IF (tm.c='N' OR sr1.maj03='2') AND
                  sr1.maj03 MATCHES "[0125]"  AND g_total[i].amt = 0 THEN
                  CONTINUE FOR
               END IF
               IF sr1.maj04 = 0 THEN
                  EXECUTE insert_prep USING
                     sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                     m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                     m_dept[8],m_dept[9],m_dept[10],
                     l_amt[1],'','','','','','','','','','2'     #MOD-870071
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOR
                  END IF
               ELSE
                  EXECUTE insert_prep USING
                     sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                     m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                     m_dept[8],m_dept[9],m_dept[10],
                     l_amt[1],'','','','','','','','','','2'     #MOD-870071
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOR
                  END IF
                  #空行的部份,以寫入同樣的maj20資料列進Temptable,
                  #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
                  #讓空行的這筆資料排在正常的資料前面印出
                  FOR j = 1 TO sr.maj04   #MOD-8A0286 mod i->j
                     EXECUTE insert_prep USING
                        sr1.*,l_i,m_dept[1],m_dept[2],m_dept[3],
                        m_dept[4],m_dept[5],m_dept[6],m_dept[7],
                        m_dept[8],m_dept[9],m_dept[10],
                        l_amt[1],'','','','','','','','','','1'     #MOD-870071
                     IF STATUS THEN
                        CALL cl_err("execute insert_prep:",STATUS,1)
                        EXIT FOR
                     END IF
                  END FOR
               END IF
            END IF
         END FOR
      ELSE
         CALL r100_total()
         DECLARE tmp_curs CURSOR FOR
            SELECT * FROM r100_file ORDER BY maj02,no
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
         LET l_j = 1
         FOREACH tmp_curs INTO sr.*
            IF sr.no = 1 THEN                              #MOD-C10184 add
               CALL l_amt.clear()                          #MOD-C10184 add
            END IF                                         #MOD-C10184 add
            IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
            IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
            IF tm.d MATCHES '[23]' THEN             #換算金額單位
               IF g_unit!=0 THEN
                  LET sr.bal1 = sr.bal1 / g_unit    #實際
               ELSE
                  LET sr.bal1 = 0
               END IF
            END IF
            IF sr.maj03 = '%' THEN   # 顯示百分比 Thomas 98/11/17
               CASE sr.no
                  WHEN 1  LET l_amt[1] = sr.bal1
                  WHEN 2  LET l_amt[2] = sr.bal1
                  WHEN 3  LET l_amt[3] = sr.bal1
                  WHEN 4  LET l_amt[4] = sr.bal1
                  WHEN 5  LET l_amt[5] = sr.bal1
                  WHEN 6  LET l_amt[6] = sr.bal1
                  WHEN 7  LET l_amt[7] = sr.bal1
                  WHEN 8  LET l_amt[8] = sr.bal1
                  WHEN 9  LET l_amt[9] = sr.bal1
                  WHEN 10 LET l_amt[10]= sr.bal1
               END CASE
            ELSE
               CASE sr.no
                  WHEN 1  LET l_amt[1] = sr.bal1
                  WHEN 2  LET l_amt[2] = sr.bal1
                  WHEN 3  LET l_amt[3] = sr.bal1
                  WHEN 4  LET l_amt[4] = sr.bal1
                  WHEN 5  LET l_amt[5] = sr.bal1
                  WHEN 6  LET l_amt[6] = sr.bal1
                  WHEN 7  LET l_amt[7] = sr.bal1
                  WHEN 8  LET l_amt[8] = sr.bal1
                  WHEN 9  LET l_amt[9] = sr.bal1
                  WHEN 10 LET l_amt[10]= sr.bal1
               END CASE
            END IF
            IF sr.no = g_cn THEN
               LET l_zero1 = 'N'
               LET l_zero2 = 'N'
               IF (tm.c='N' OR sr.maj03='2') AND
                  sr.maj03 MATCHES "[0125]" AND
                  (l_amt[1]=0  OR cl_null(l_amt[1])) AND
                  (l_amt[2]=0  OR cl_null(l_amt[2])) AND
                  (l_amt[3]=0  OR cl_null(l_amt[3])) AND
                  (l_amt[4]=0  OR cl_null(l_amt[4])) AND
                  (l_amt[5]=0  OR cl_null(l_amt[5])) AND
                  (l_amt[6]=0  OR cl_null(l_amt[6])) AND
                  (l_amt[7]=0  OR cl_null(l_amt[7])) AND
                  (l_amt[8]=0  OR cl_null(l_amt[8])) AND
                  (l_amt[9]=0  OR cl_null(l_amt[9])) AND
                  (l_amt[10]=0 OR cl_null(l_amt[10])) THEN
                  LET l_zero1 = 'Y'             #餘額為 0 者不列印
               END IF
 
               IF g_flag = 'y' THEN
                  IF sr.maj03 = '%' THEN
                     LET l_amt[sr.no+1] = g_total[l_j].amt   #MOD-870071 add
                  ELSE
                     LET l_amt[sr.no+1] = g_total[l_j].amt   #MOD-870071 add
                  END IF
                  IF (tm.c='N' OR sr.maj03='2') AND
                     sr.maj03 MATCHES "[0125]"  AND g_total[l_j].amt = 0 THEN
                     LET l_zero2 = 'Y'
                  END IF
                  LET l_j = l_j + 1
               END IF
 
               IF (tm.c='N' OR sr.maj03='2') AND
                  sr.maj03 MATCHES "[0125]" AND
                  (l_amt[1]=0  OR cl_null(l_amt[1])) AND
                  (l_amt[2]=0  OR cl_null(l_amt[2])) AND
                  (l_amt[3]=0  OR cl_null(l_amt[3])) AND
                  (l_amt[4]=0  OR cl_null(l_amt[4])) AND
                  (l_amt[5]=0  OR cl_null(l_amt[5])) AND
                  (l_amt[6]=0  OR cl_null(l_amt[6])) AND
                  (l_amt[7]=0  OR cl_null(l_amt[7])) AND
                  (l_amt[8]=0  OR cl_null(l_amt[8])) AND
                  (l_amt[9]=0  OR cl_null(l_amt[9])) AND
                  (l_amt[10]=0 OR cl_null(l_amt[10])) THEN
                  LET l_zero1 = 'Y'             #餘額為 0 者不列印
               END IF
 
               #表頭不應該列印金額
               IF sr.maj03 = 'H' THEN
                  CALL l_amt.clear()          #MOD-870071 add
               END IF
               IF l_zero1 = 'Y' AND (g_flag = 'n' OR
                  (g_flag = 'y' AND l_zero2 = 'Y')) THEN
                  CONTINUE FOREACH
               END IF
               LET sr.maj20 = sr.maj05 SPACES,sr.maj20   #MOD-870071 add
               LET sr.maj20e= sr.maj05 SPACES,sr.maj20e  #MOD-870071 add
               IF sr.maj04 = 0 THEN
                  EXECUTE insert_prep USING
                     sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                     sr.maj20,sr.maj20e,l_i,
                     m_dept[1],m_dept[2],m_dept[3],m_dept[4],m_dept[5],
                     m_dept[6],m_dept[7],m_dept[8],m_dept[9],m_dept[10],
                     l_amt[1],l_amt[2],l_amt[3],l_amt[4],l_amt[5],
                     l_amt[6],l_amt[7],l_amt[8],l_amt[9],l_amt[10],
                     '2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
               ELSE
                  EXECUTE insert_prep USING
                     sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                     sr.maj20,sr.maj20e,l_i,
                     m_dept[1],m_dept[2],m_dept[3],m_dept[4],m_dept[5],
                     m_dept[6],m_dept[7],m_dept[8],m_dept[9],m_dept[10],
                     l_amt[1],l_amt[2],l_amt[3],l_amt[4],l_amt[5],
                     l_amt[6],l_amt[7],l_amt[8],l_amt[9],l_amt[10],
                     '2'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
                  #空行的部份,以寫入同樣的maj20資料列進Temptable,
                  #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
                  #讓空行的這筆資料排在正常的資料前面印出
                  FOR j = 1 TO sr.maj04   #MOD-8A0286 mod i->j
                     EXECUTE insert_prep USING
                        sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                        sr.maj20,sr.maj20e,l_i,
                        m_dept[1],m_dept[2],m_dept[3],m_dept[4],m_dept[5],
                        m_dept[6],m_dept[7],m_dept[8],m_dept[9],m_dept[10],
                        l_amt[1],l_amt[2],l_amt[3],l_amt[4],l_amt[5],
                        l_amt[6],l_amt[7],l_amt[8],l_amt[9],l_amt[10],
                        '1'
                     IF STATUS THEN
                        CALL cl_err("execute insert_prep:",STATUS,1)
                        EXIT FOREACH
                     END IF
                  END FOR
               END IF
            END IF
         END FOREACH
         CLOSE tmp_curs
      END IF
   END FOR
   LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.yy USING '<<<<',";",
               tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",tm.e,";",
               g_azi04            #MOD-BC0237
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aglr100','aglr100',g_sql,g_str)
END FUNCTION


#CHI-B50007
FUNCTION r100_not_page()
   DEFINE l_name1   LIKE type_file.chr20
   DEFINE l_chr     LIKE type_file.chr1  
   DEFINE l_leng,l_leng2  LIKE type_file.num5
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6
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
   DEFINE l_cn,l_cnt,l_i,l_j,l_deptcnt LIKE type_file.num5
   DEFINE l_amt         LIKE type_file.num20_6
   DEFINE m_dept        LIKE gem_file.gem02
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,
          l_zero2       LIKE type_file.chr1
   LET l_cnt = g_no
   LET l_i = 0
   FOR l_i = 1 TO l_cnt
      LET g_flag = 'n'
      LET l_name1='r100_1.out'
      LET g_pageno = 0
      LET g_cn = 0
      DELETE FROM r100_file
      LET m_dept = ''
      LET g_i = 1
      FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
      LET g_buf = ''
      LET l_dept = g_dept[l_i].gem01
      LET l_chr  = g_dept[l_i].gem05
      LET l_gem02 = ''
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
      LET l_leng2 = LENGTH(l_gem02_o)
      LET l_leng2 = 16 - l_leng2
      LET m_dept = l_gem02
      IF tm.s = 'Y' THEN
         CALL r100_bom(l_dept,l_chr)
      END IF
      IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
      LET l_leng = g_buf.getlength()
      LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED
      CALL r100_process(l_i)
      LET g_cn = l_i
      LET l_gem02_o = l_gem02
      
      CALL r100_total()
      DECLARE tmp_curs1 CURSOR FOR
         SELECT * FROM r100_file ORDER BY maj02,no
      IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
      LET l_j = 1
      FOREACH tmp_curs1 INTO sr.*
         IF sr.no = 1 THEN                              #MOD-C10184 add
            LET l_amt= 0                                #MOD-C10184 add
         END IF                                         #MOD-C10184 add
         IF STATUS THEN CALL cl_err('tmp_curs1',STATUS,1) EXIT FOREACH END IF
         IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
         IF tm.d MATCHES '[23]' THEN             #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
            ELSE
               LET sr.bal1 = 0
            END IF
         END IF
         IF sr.maj03 = '%' THEN
            LET l_amt = sr.bal1
         ELSE
            LET l_amt = sr.bal1
         END IF
         IF sr.no = g_cn THEN
            LET l_zero1 = 'N'
            LET l_zero2 = 'N'
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[0125]" AND
               (l_amt=0  OR cl_null(l_amt)) THEN
               LET l_zero1 = 'Y'
            END IF
            IF g_flag = 'y' THEN
               IF sr.maj03 = '%' THEN
                  LET l_amt = g_total[l_j].amt
               ELSE
                  LET l_amt = g_total[l_j].amt
               END IF
               IF (tm.c='N' OR sr.maj03='2') AND
                  sr.maj03 MATCHES "[0125]"  AND g_total[l_j].amt = 0 THEN
                  LET l_zero2 = 'Y'
               END IF
               LET l_j = l_j + 1
            END IF
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[0125]" AND
               (l_amt=0  OR cl_null(l_amt)) THEN
               LET l_zero1 = 'Y'
            END IF
            IF sr.maj03 = 'H' OR sr.maj03= '4' THEN
               LET l_amt = ''
            END IF
            IF l_zero1 = 'Y' AND (g_flag = 'n' OR
               (g_flag = 'y' AND l_zero2 = 'Y')) THEN
               DISPLAY "CONTINUE FOREACH==============="
               CONTINUE FOREACH
            END IF
            LET sr.maj20 = sr.maj05 SPACES,sr.maj20
            LET sr.maj20e= sr.maj05 SPACES,sr.maj20e
            IF sr.maj04 = 0 THEN
               EXECUTE insert_prep1 USING
                  sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                     sr.maj20,sr.maj20e,l_i,
                     m_dept,l_amt,'2'
               IF STATUS THEN
                  CALL cl_err("execute insert_prep1:",STATUS,1)
                  EXIT FOREACH
               END IF
            ELSE
               EXECUTE insert_prep1 USING
                  sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                     sr.maj20,sr.maj20e,l_i,
                     m_dept,'','2'
               IF STATUS THEN
                  CALL cl_err("execute insert_prep1:",STATUS,1)
                  EXIT FOREACH
               END IF
               #空行的部份,以寫入同樣的maj20資料列進Temptable,
               #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
               #讓空行的這筆資料排在正常的資料前面印出
               FOR j = 1 TO sr.maj04
                  EXECUTE insert_prep1 USING
                     sr.maj02,sr.maj03,sr.maj04,sr.maj05,sr.maj07,
                     sr.maj20,sr.maj20e,l_i,
                     m_dept,'','1'
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep1:",STATUS,1)
                     EXIT FOREACH
                  END IF
               END FOR
            END IF
         END IF
      END FOREACH
      CLOSE tmp_curs1
   END FOR
  #LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.yy USING '<<<<',";",               #MOD-C30009 mark
  #            tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",tm.e,";",g_no    #MOD-C30009 mark
   LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.yy USING '<<<<',";",               #MOD-C30009 add
               tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",                 #MOD-C30009 add
               tm.e,";",g_azi04,";",g_no                                         #MOD-C30009 add
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   CALL cl_prt_cs3('aglr100','aglr100_1',g_sql,g_str)
END FUNCTION

FUNCTION r100_process(l_cn)
  #DEFINE l_sql,l_sql1   LIKE type_file.chr1000   #No.FUN-680098 char(1000) #MOD-B40245 mark
   DEFINE l_sql,l_sql1   STRING                   #MOD-B40245
   DEFINE l_cn           LIKE type_file.num5      #No.FUN-680098 smallint
   DEFINE l_temp         LIKE maj_file.maj21       #No.FUN-680098 dec(20,6) 
   DEFINE l_sun          LIKE type_file.num20_6    #No.FUN-680098 dec(20,6)
   DEFINE l_mon          LIKE type_file.num20_6    #No.FUN-680098 DEC(20,6) 
   DEFINE l_amt1,amt1,amt2,amt   LIKE type_file.num20_6  #No.FUN-680098 
   DEFINE maj             RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2   LIKE type_file.num20_6      #No.FUN-680098 DEC(20,6)
   DEFINE l_amt           LIKE type_file.num20_6      #No.FUN-680098 DEC(20,6)
   DEFINE m_per1,m_per2   LIKE con_file.con06         #No.FUN-680098 dec(9,5)
   DEFINE l_mm            LIKE type_file.num5         #No.FUN-680098 smallint
   #No.MOD-C80087  --Begin
   DEFINE l_aaa09   LIKE aaa_file.aaa09
   DEFINE l_aeh11   LIKE aeh_file.aeh11
   DEFINE l_aeh12   LIKE aeh_file.aeh12
   DEFINE l_aeh15   LIKE aeh_file.aeh15
   DEFINE l_aeh16   LIKE aeh_file.aeh16
   #No.MOD-C80087  --End 
    #----------- sql for sum(aao05-aao06)-----------------------------------
    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                " WHERE aao00= ? AND aao01 BETWEEN ? AND ? ",
                "   AND aao03 = ? ",
                "   AND aao04 BETWEEN ? AND ? ",
                "   AND aao01 = aag01 AND aag07 IN ('2','3')",
                "   AND aao00 = aag00  ",                  #No.FUN-740020                  
                "   AND aao02 IN (",g_buf CLIPPED,")"       #---- g_buf 部門族群
    PREPARE r100_sum FROM l_sql
    DECLARE r100_sumc CURSOR FOR r100_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
    #SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01 = g_bookno  #MOD-C80087  #TQC-CA0041
    FOREACH r100_c INTO maj.* 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt  = 0
       IF NOT cl_null(maj.maj21) THEN
          OPEN r100_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm
          FETCH r100_sumc INTO amt1
         #IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF #MOD-B40245
          IF cl_null(amt1) THEN LET amt1 = 0 END IF
          #No.MOD-C80087  --Begin           
          #IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF                                  #TQC-CA0041
          #CALL s_minus_ce(g_bookno, maj.maj21, maj.maj22, NULL,     NULL,     NULL,       #TQC-CA0041
          #                NULL,      NULL,      NULL,      NULL,     NULL,     tm.yy,
          #                tm.bm,     g_mm,      NULL,      NULL,     NULL,     NULL,
          #                NULL,      NULL,      NULL,      NULL,     g_plant,  l_aaa09,'0')
          #     RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
          #减借加贷
          #LET sr.amt = sr.amt - l_aeh11 + l_aeh12      #TQC-CA0041 mark
          #LET amt1 = amt1 - l_aeh11 + l_aeh12           #TQC-CA0041
          #No.MOD-C80087  --End  
       END IF
 
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          FOR i = 1 TO maj02_max
              LET l_amt1 = amt1
             #LET g_tot1[i]=g_tot1[i]+l_amt1     #MOD-A80241 mark
             #-MOD-A80241-remark-
              IF maj.maj09 = '-' THEN  # Thomas 99/01/12
                 LET g_tot1[i]=g_tot1[i]-l_amt1     #科目餘額
              ELSE
                 LET g_tot1[i]=g_tot1[i]+l_amt1     #科目餘額
              END IF
             #-MOD-A80241-end-
          END FOR
          LET k=maj.maj08
          LET m_bal1=g_tot1[k]

         #MOD-C90020---S---
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET m_bal1 = m_bal1 * -1
          END IF
         #MOD-C90020---E---
         #MOD-C90020---mark---S
         #IF maj.maj07='2' THEN
         #   LET m_bal1 = m_bal1*-1
         #END IF
         #MOD-C90020---mark---E
          FOR i = 1 TO k LET g_tot1[i]=0 END FOR
       ELSE
	  IF maj.maj03 = '%' THEN
	     LET l_temp = maj.maj21
	     SELECT bal1 INTO l_sun FROM r100_file WHERE no=l_cn
	            AND maj02=l_temp
	     LET l_temp = maj.maj22
	     SELECT bal1 INTO l_mon FROM r100_file WHERE no=l_cn
	            AND maj02=l_temp
	     IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	     ELSE
                LET m_bal1 = l_sun / l_mon * 100
             END IF
          ELSE
            #LET m_bal1=NULL         #MOD-BC0237 mark
            #-MOD-BC0237-add-
             IF maj.maj03 = '5' THEN
                LET m_bal1 = amt1
             ELSE
                LET m_bal1 = NULL
             END IF
            #-MOD-BC0237-end-
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
 
       IF maj.maj03 !='%' THEN
         IF maj.maj07='2' THEN
            IF NOT cl_null(maj.maj21) THEN
               IF m_bal1 > 0 AND amt1 < 0 THEN
                  LET m_bal1=m_bal1
               END IF
            END IF
         END IF
       END IF
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF

      #MOD-C90020---S---
       IF maj.maj07='2' THEN
          LET m_bal1 = m_bal1*-1
       END IF
      #MOD-C90020---E---

       INSERT INTO r100_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                    maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                    maj.maj21,maj.maj22,m_bal1)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","r100_file",l_cn,maj.maj02,SQLCA.sqlcode,"","ins r100_file",1)   #No.FUN-660123
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION r100_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01        #No.FUN-680098   VARCHAR(6)   
    DEFINE l_sw     LIKE type_file.chr1        #No.FUN-680098    VARCHAR(1)   
    DEFINE l_abd02  LIKE abd_file.abd02        #No.FUN-680098    VARCHAR(6)   
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5          #No.FUN-680098 smallint
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
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
           CALL r100_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
 
FUNCTION r100_total()
    DEFINE  l_i,l_y  LIKE type_file.num5,        #No.FUN-680098  SMALLINT
	    l_maj02  LIKE maj_file.maj02,
	    l_maj03  LIKE maj_file.maj03,
	    l_maj21  LIKE maj_file.maj21,
	    l_maj22  LIKE maj_file.maj22,
	    l_t1,l_t2  LIKE type_file.num5,      #No.FUN-680098  SMALLINT
	    l_bal      LIKE type_file.num20_6    #No.FUN-680098  DECIMAL(20,6)   
 
    DECLARE tot_curs CURSOR FOR
      SELECT maj02,maj03,maj21,maj22,SUM(bal1)
        FROM r100_file
       GROUP BY maj02,maj03,maj21,maj22 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj02 = ' '
    LET l_bal = 0
    FOREACH tot_curs INTO l_maj02,l_maj03,l_maj21,l_maj22,l_bal
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
       IF cl_null(l_bal) THEN LET l_bal = 0 END IF
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
          ELSE
             LET l_bal = 0
          END IF
       END IF
       IF l_maj03 = '%' THEN
          LET l_t1 = l_maj21
          LET l_t2 = l_maj22
          FOR l_y = 1 TO maj02_max
              IF g_total[l_y].maj02 = l_t1 THEN LET l_t1 = l_y END IF
              IF g_total[l_y].maj02 = l_t2 THEN LET l_t2 = l_y END IF
          END FOR
          IF g_total[l_t2].amt != 0 THEN
             LET g_total[l_i].amt = g_total[l_t1].amt / g_total[l_t2].amt * 100
          ELSE
             LET g_total[l_i].amt = 0
          END IF
       ELSE
          LET g_total[l_i].amt = g_total[l_i].amt + l_bal
       END IF
       LET g_total[l_i].maj02 = l_maj02
       LET l_i = l_i + 1
       IF l_i > maj02_max THEN   
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#No.FUN-9C0072  精簡程式碼
