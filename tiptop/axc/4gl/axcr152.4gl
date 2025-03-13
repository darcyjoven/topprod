# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: axcr152.4gl
# Descriptions...: 在製品淨變現價值表
# Date & Author..: No.FUN-890030 08/09/17 By sherry
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-8C0049 08/12/09 By sherry 十號公報修改
# Modify.........: No.FUN-930100 09/03/31 By jan 打印資料增加 產品分類
# Modify.........: No.CHI-970011 09/07/15 By jan 修改程序BUG
# Modify.........: No.CHI-980015 09/08/07 By mike 預設執行年度期別，請統一為預設帶axcs010之年度期別(ccz01、ccz02)。                 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-980102 09/11/10 By jan 處理在制品凈變現計算，在抓取的到逆推成品，但逆推成品無成本的問題
# Modify.........: No.FUN-9C0170 10/01/07 By jan 新增ctype欄位及相關處理
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/20 By lutingting GP5.2跨DB處理 
# Modify.........: No.TQC-A50166 10/05/07 By Carrier 追单TQC-990129/CHI-990002
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表整批修改
# Modify.........: No.FUN-A80110 10/09/29 By vealxu 畫面多一個checkbox勾選是否多營運中心
# Modify.........: NO:CHI-AA0018 10/10/22 By sabrina 未上市新品列印不出資料
# Modify.........: NO:TQC-AC0126 10/12/10 By sabrina 修改CHI-AA0018錯誤
# Modify.........: NO:FUN-B30204 11/03/30 By shenyang 修改報表明細列印
# Modify.........: NO:CHI-B40026 11/03/30 By jan axcr152在算半成品淨變現時，沒有考慮與成品的QPA
# Modify.........: NO:CHI-B40042 11/04/28 By lixh1 投入如果為負的話,半成品淨變現=逆推成品淨變現
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: NO:MOD-C20098 12/02/09 By ck2yuan 若sr.ccc23-l_mrate不大於0,則用原本的淨變現價格
# Modify.........: NO:MOD-C30040 12/03/07 By Elise 已有做left outer join，檢查條件是否都有搬到對應left outer join的條件，且這些條件不應再存在where子句
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-C90175 12/09/21 By Elise 資料撈取時，應依input畫面的成本計算類別撈取資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc1     STRING,                # Where condition   #FUN-A10098
              wc2     STRING,                # Where condition
              s1      LIKE type_file.chr1,   # 排序
              t1      LIKE type_file.chr1,   # 跳頁
              u1      LIKE type_file.chr1,   # 小計
              ctype   LIKE type_file.chr1,   # FUN-9C0170
              yy      LIKE type_file.num5,   # 年度
              mm      LIKE type_file.num5,   # 期別
              a       LIKE type_file.chr1,   # 是否列印料號明細(Y/N)
              b       LIKE type_file.chr1,   # 是否列印庫存明細(Y/N)
              o       LIKE type_file.chr1,   # 轉換幣別否(Y/N)
              a_curr  LIKE azi_file.azi01,   # 總帳幣別
              t_curr  LIKE azi_file.azi01,   # 轉換幣別
              rate    LIKE apa_file.apa14,   # 乘匯率
              more    LIKE type_file.chr1    # Input more condition(Y/N)
             ,p       LIKE type_file.chr1    #FUN-A80110 
              #FUN-A10098--add--str--
             ,plant_1,plant_2,plant_3,plant_4 LIKE cre_file.cre08,
              plant_5,plant_6,plant_7,plant_8 LIKE cre_file.cre08
             #FUN-A10098--add--end
              END RECORD
 
  DEFINE l_table     STRING
  DEFINE g_sql       STRING
  DEFINE g_str       STRING
  DEFINE last_yy     LIKE type_file.num5     #FUN-980102
  DEFINE last_mm     LIKE type_file.num5     #FUN-980102
  DEFINE l_plant     ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098
  DEFINE g_tmp       ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098
  DEFINE g_atot,g_k  LIKE type_file.num5    #FUN-A10098
  DEFINE m_legal     ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084
#====================================
# 主程式開始
#====================================
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN 
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time            #FUN-B80056   ADD #FUN-BB0047 mark
 
   #FUN-A10098--add--str--
   FOR g_atot =1 to 8
     LET l_plant[g_atot]=''
   END FOR

   LET tm.plant_1 = l_plant[1]
   LET tm.plant_2 = l_plant[2]
   LET tm.plant_3 = l_plant[3]
   LET tm.plant_4 = l_plant[4]
   LET tm.plant_5 = l_plant[5]
   LET tm.plant_6 = l_plant[6]
   LET tm.plant_7 = l_plant[7]
   LET tm.plant_8 = l_plant[8]
   #FUN-A10098--add--end

   LET g_sql = "azp01.azp_file.azp01,",
               "chr20.type_file.chr20,",
               "chr50.type_file.chr50,",
               "ccg04.ccg_file.ccg04,",
               "ccg01.ccg_file.ccg01,",
               "ccg91.ccg_file.ccg91,",
               "ccc23.ccc_file.ccc23,",
               "price.cma_file.cma25,",   #TQC-A50166
               "cma27.cma_file.cma27,",   #TQC-A50166
               "cma28.cma_file.cma28,",   #TQC-A50166
               "cma29.cma_file.cma29,",   #TQC-A50166
               "cma25.cma_file.cma25,",   #TQC-A50166
               "ccc92.ccg_file.ccg92,",
               "amt_m.ccc_file.ccc92,",
               "amt_o.ccc_file.ccc92,",
               "amt_p.ccc_file.ccc92,",
               "amt_q.ccc_file.ccc92,",
               "sfb98.sfb_file.sfb98,",
               "cma32.cma_file.cma32,",  #TQC-A50166
               "cma24.cma_file.cma24,",   #FUN-930100 add
               "ccg07.ccg_file.ccg07 "    #FUN-9C0170 add
               
   LET l_table = cl_prt_temptable('axcr152',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? )"  #FUN-930100 add ? #FUN-9C0170 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #FUN-A10098--mod--str--
  #LET tm.wc1   = ARG_VAL(7)
  #LET tm.wc2   = ARG_VAL(8)
  #LET tm.s1    = ARG_VAL(9)
  #LET tm.t1    = ARG_VAL(10)
  #LET tm.u1    = ARG_VAL(11)
  #LET tm.yy    = ARG_VAL(12)
  #LET tm.mm    = ARG_VAL(13)
  #LET tm.a     = ARG_VAL(14)
  #LET tm.b     = ARG_VAL(15)
  #LET tm.o     = ARG_VAL(16)
  #LET tm.a_curr= ARG_VAL(17)
  #LET tm.t_curr= ARG_VAL(18)
  #LET tm.rate  = ARG_VAL(19)
  #LET g_rep_user = ARG_VAL(20)
  #LET g_rep_clas = ARG_VAL(21)
  #LET g_template = ARG_VAL(22)
  #LET tm.ctype   = ARG_VAL(23)   #FUN-9C0170
  #IF cl_null(tm.wc1)
  #   THEN CALL r152_tm(0,0)             # Input print condition
  #   ELSE CALL r152()                   # Read data and create out-file
  #END IF
   LET tm.wc2   = ARG_VAL(7)
   LET tm.s1    = ARG_VAL(8)
   LET tm.t1    = ARG_VAL(9)
   LET tm.u1    = ARG_VAL(10)
   LET tm.yy    = ARG_VAL(11)
   LET tm.mm    = ARG_VAL(12)
   LET tm.a     = ARG_VAL(13)
   LET tm.b     = ARG_VAL(14)
   LET tm.o     = ARG_VAL(15)
   LET tm.a_curr= ARG_VAL(16)
   LET tm.t_curr= ARG_VAL(17)
   LET tm.rate  = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET tm.ctype   = ARG_VAL(22)
   LET tm.plant_1 = ARG_VAL(23)
   LET tm.plant_2 = ARG_VAL(24)
   LET tm.plant_3 = ARG_VAL(25)
   LET tm.plant_4 = ARG_VAL(26)
   LET tm.plant_5 = ARG_VAL(27)
   LET tm.plant_6 = ARG_VAL(28)
   LET tm.plant_7 = ARG_VAL(29)
   LET tm.plant_8 = ARG_VAL(30)
   LET tm.p       = ARG_VAL(31)
   IF cl_null(tm.wc2)
      THEN CALL r152_tm(0,0)             # Input print condition
      ELSE CALL r152()                   # Read data and create out-file
   END IF
  #FUN-A10098--mod--end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
END MAIN
 
#====================================
# 開窗輸入條件
#====================================
FUNCTION r152_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE l_a_curr_o     LIKE azi_file.azi01,
          l_t_curr_o     LIKE azi_file.azi01,
          l_exT          LIKE type_file.chr1
   DEFINE l_ac           LIKE type_file.num10 #FUN-A10098
   DEFINE i              LIKE type_file.num5  #FUN-A10098
   DEFINE li_result      LIKE type_file.num5  #FUN-A10098
   DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084
 
   LET p_row = 1 LET p_col = 20
   OPEN WINDOW r152_w AT p_row,p_col WITH FORM "axc/42f/axcr152"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r152_set_visible() RETURNING l_cnt    #FUN-A70084 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.yy   = g_ccz.ccz01                                                                                                        
   LET tm.mm   = g_ccz.ccz02                                                                                                        
   LET tm.s1   = '1'
   LET tm.t1   = 'N'
   LET tm.u1   = 'N'
   LET tm.a    = 'N'
#  LET tm.b    = 'N'
   LET tm.b    = 'Y'  #FUN-B20304
   LET tm.o    = 'N'
   LET tm.a_curr = g_aza.aza17
   LET tm.t_curr = g_aza.aza17
   LET tm.rate   = 1
   LET l_a_curr_o = tm.a_curr
   LET l_t_curr_o = tm.t_curr
   LET l_exT = 'S'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
   LET l_plant[1]=g_plant   #預設現行工廠 #No.FUN-A10098 
   LET tm.plant_1 = l_plant[1]   #FUN-A80110
   LET tm.p = 'N'                #FUN-A80110 add
WHILE TRUE

 #FUN-A10098--mark--str--
 ##QBE查詢條件1
 # CONSTRUCT BY NAME tm.wc1 ON azp01
 #    BEFORE CONSTRUCT
 #       CALL cl_qbe_init()
 
 #    ON ACTION locale
 #       CALL cl_show_fld_cont()
 #       LET g_action_choice = "locale"
 #       EXIT CONSTRUCT
 
 #    ON IDLE g_idle_seconds
 #       CALL cl_on_idle()
 #       CONTINUE CONSTRUCT
 
 #    ON ACTION controlp
 #       CASE
 #         WHEN INFIELD(azp01)   #料件
 #              CALL cl_init_qry_var()
 #              LET g_qryparam.form = "q_azp"
 #              LET g_qryparam.state = "c"
 #              CALL cl_create_qry() RETURNING g_qryparam.multiret
 #              DISPLAY g_qryparam.multiret TO azp01
 #              NEXT FIELD azp01
 #       END CASE
 
 #    ON ACTION about
 #       CALL cl_about()
 
 #    ON ACTION help
 #       CALL cl_show_help()
 
 #    ON ACTION controlg
 #       CALL cl_cmdask()
 
 #    ON ACTION exit
 #       LET INT_FLAG = 1
 #       EXIT CONSTRUCT
 
 #    ON ACTION qbe_select
 #       CALL cl_qbe_select()
 # END CONSTRUCT
 # LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 # IF g_action_choice = "locale" THEN
 #    LET g_action_choice = ""
 #    CALL cl_dynamic_locale()
 #    CONTINUE WHILE
 # END IF
 # IF INT_FLAG THEN
 #    LET INT_FLAG = 0
 #    EXIT WHILE
 # END IF
 # IF tm.wc1 = " 1=1" THEN
 #    CALL cl_err('','9046',0)
 #    CONTINUE WHILE
 # END IF
 #FUN-A10098--mark--end
 
   WHILE TRUE
     #QBE查詢條件2
      CONSTRUCT BY NAME tm.wc2 ON ima01,ima06,ima09,ima10,ima11,ima12,ima131
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE
              WHEN INFIELD(ima01)   #料件
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
              WHEN INFIELD(ima06)   #主分群碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_imz"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima06
                   NEXT FIELD ima06
              WHEN INFIELD(ima09)   #分群碼一
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "D"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima09
                   NEXT FIELD ima09
              WHEN INFIELD(ima10)   #分群碼二
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "E"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima10
                   NEXT FIELD ima10
              WHEN INFIELD(ima11)   #分群碼三
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "F"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima11
                   NEXT FIELD ima11
              WHEN INFIELD(ima12)   #分群碼四
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "G"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima12
                   NEXT FIELD ima12
              WHEN INFIELD(ima131)  #產品分類
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oba"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
            END CASE
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
      IF tm.wc2 = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   INPUT BY NAME tm.s1,tm.t1,tm.u1,tm.ctype,tm.yy,tm.mm,tm.a,tm.b, #FUN-9C0170
                 tm.o,tm.a_curr,tm.t_curr,tm.rate,
                 tm.more,tm.p                          #FUN-A80110 add tm.p
                 #FUN-A10098--add--str--
                ,tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8
                #FUN-A10098--add--end
            WITHOUT DEFAULTS
              
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         CALL r152_set_entry()
 
      AFTER FIELD s1
         IF cl_null(tm.s1) OR tm.s1 NOT MATCHES '[123456]' THEN
            NEXT FIELD s1
         END IF
 
      AFTER FIELD t1
         IF cl_null(tm.t1) OR tm.t1 NOT MATCHES '[YN]' THEN
            NEXT FIELD t1
         END IF
 
      AFTER FIELD u1
         IF cl_null(tm.u1) OR tm.u1 NOT MATCHES '[YN]' THEN
            NEXT FIELD u1
         END IF
 
      AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN
            IF tm.yy < 0 THEN
               CALL cl_err('','mfg5034',0)
               NEXT FIELD yy
            END IF
         END IF
 
      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            IF tm.mm < 1 OR tm.mm > 12 THEN
               CALL cl_err('','aom-580',0)
               NEXT FIELD mm
            END IF
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
#FUN-B30204--mark 
#      ON CHANGE a
#         IF tm.a = 'N' THEN LET tm.b = 'N' END IF
#         DISPLAY tm.b TO FORMONLY.b
#         CALL r152_set_entry()
# 
#      BEFORE FIELD b
#         IF tm.a = 'N' THEN LET tm.b = 'N' END IF
#         DISPLAY tm.b TO FORMONLY.b
#         CALL r152_set_entry()
#FUN-B20304--mark 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[YN]' THEN
            NEXT FIELD o
         END IF
         CALL r152_set_entry()
 
      ON CHANGE o
         CALL r152_set_entry()
         IF tm.o = 'N' THEN
            LET tm.t_curr = tm.a_curr
            LET tm.rate = 1
            DISPLAY tm.t_curr TO FORMONLY.t_curr
            DISPLAY tm.rate TO FORMONLY.rate
            LET l_t_curr_o = tm.t_curr
         END IF
 
      BEFORE FIELD a_curr
         CALL r152_set_entry()
 
      AFTER FIELD a_curr
         IF NOT cl_null(tm.a_curr) THEN
            CALL r152_chk_azi(tm.a_curr) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD a_curr
            END IF
            IF tm.a_curr <> l_a_curr_o THEN
               LET tm.rate = s_exrate(tm.a_curr,tm.t_curr,l_exT)
               DISPLAY tm.rate TO FORMONLY.rate
            END IF
         END IF
         LET l_a_curr_o = tm.a_curr
 
      AFTER FIELD t_curr
         IF NOT cl_null(tm.t_curr) THEN
            CALL r152_chk_azi(tm.t_curr) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD t_curr
            END IF
            IF tm.t_curr <> l_t_curr_o THEN
               LET tm.rate = s_exrate(tm.a_curr,tm.t_curr,l_exT)
               DISPLAY tm.rate TO FORMONLY.rate
            END IF
         END IF
         LET l_t_curr_o = tm.t_curr
 
#FUN-A80110 --------------add start-----------------------
      AFTER FIELD p
         IF cl_null(tm.p) OR tm.p NOT MATCHES '[YN]' THEN
            NEXT FIELD p
         END IF
         CALL r152_set_entry()

      ON CHANGE p
         CALL r152_set_entry()
#FUN-A80110 -------------add end------------------------

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #FUN-A10098--add--str--
      BEFORE FIELD plant_1
         LET tm.plant_1 = g_plant
         DISPLAY tm.plant_1 TO FORMONLY.plant_1
         IF g_multpl= 'N' THEN             # 不為多工廠環境
            LET tm.plant_1 = g_plant
            LET l_plant[1] = g_plant
            DISPLAY tm.plant_1 TO FORMONLY.plant_1
            EXIT INPUT
         END IF

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
            IF NOT r152_chkplant(tm.plant_1) THEN
               CALL cl_err(tm.plant_1,g_errno,0)
               NEXT FIELD plant_1
            END IF
            LET l_plant[1] = tm.plant_1
            SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
            CALL s_chk_demo(g_user,tm.plant_1) RETURNING li_result
            IF not li_result THEN
               NEXT FIELD plant_1
            END IF
         END IF

      AFTER FIELD plant_2
             LET tm.plant_2 = duplicate(tm.plant_2,1)  # 不使工廠編號重覆
             IF tm.plant_2 = g_plant  THEN
                LET l_plant[2] = tm.plant_2
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                   IF NOT r152_chkplant(tm.plant_2) THEN
                      CALL cl_err(tm.plant_2,g_errno,0)
                      NEXT FIELD plant_2
                   END IF
                   LET l_plant[2] = tm.plant_2
                   SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_2) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_2
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[2] = tm.plant_2
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r152_chklegal(m_legal[2],1) THEN
                   CALL cl_err(tm.plant_2,g_errno,0)
                   NEXT FIELD plant_2
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_3
             LET tm.plant_3 = duplicate(tm.plant_3,2)  # 不使工廠編號重覆
             IF tm.plant_3 = g_plant  THEN
                LET l_plant[3] = tm.plant_3
                LET m_legal[3] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_3) THEN
                   IF NOT r152_chkplant(tm.plant_3) THEN
                      CALL cl_err(tm.plant_3,g_errno,0)
                      NEXT FIELD plant_3
                   END IF
                   LET l_plant[3] = tm.plant_3
                   SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_3) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_3
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[3] = tm.plant_3
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r152_chklegal(m_legal[3],2) THEN
                   CALL cl_err(tm.plant_3,g_errno,0)
                   NEXT FIELD plant_3
                END IF
             END IF
             #FUN-A70084--add--end

      AFTER FIELD plant_4
             LET tm.plant_4 = duplicate(tm.plant_4,3)  # 不使工廠編號重覆
             IF tm.plant_4 = g_plant  THEN
                LET l_plant[4] = tm.plant_4
                LET m_legal[4] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_4) THEN
                   IF NOT r152_chkplant(tm.plant_4) THEN
                      CALL cl_err(tm.plant_4,g_errno,0)
                      NEXT FIELD plant_4
                   END IF
                   LET l_plant[4] = tm.plant_4
                   SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_4) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_4
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[4] = tm.plant_4
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r152_chklegal(m_legal[4],3) THEN
                   CALL cl_err(tm.plant_4,g_errno,0)
                   NEXT FIELD plant_4
                END IF
             END IF
             #FUN-A70084--add--end


         AFTER FIELD plant_5
             LET tm.plant_5 = duplicate(tm.plant_5,4)  # 不使工廠編號重覆
             IF tm.plant_5 = g_plant  THEN
                LET l_plant[5] = tm.plant_5
                LET m_legal[5] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_5) THEN
                   IF NOT r152_chkplant(tm.plant_5) THEN
                      CALL cl_err(tm.plant_5,g_errno,0)
                      NEXT FIELD plant_5
                   END IF
                   LET l_plant[5] = tm.plant_5
                   SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_5) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_5
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[5] = tm.plant_5
                END IF
             END IF
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r152_chklegal(m_legal[5],4) THEN
                   CALL cl_err(tm.plant_5,g_errno,0)
                   NEXT FIELD plant_5
                END IF
             END IF
             #FUN-A70084--add--end

      AFTER FIELD plant_6
             LET tm.plant_6 = duplicate(tm.plant_6,5)  # 不使工廠編號重覆
             IF tm.plant_6 = g_plant  THEN
                LET l_plant[6] = tm.plant_6
                LET m_legal[6] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_6) THEN
                   IF NOT r152_chkplant(tm.plant_6) THEN
                      CALL cl_err(tm.plant_6,g_errno,0)
                      NEXT FIELD plant_6
                   END IF
                   LET l_plant[6] = tm.plant_6
                   SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_6) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_6
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[6] = tm.plant_6
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r152_chklegal(m_legal[6],5) THEN
                   CALL cl_err(tm.plant_6,g_errno,0)
                   NEXT FIELD plant_6
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_7
             LET tm.plant_7 = duplicate(tm.plant_7,6)  # 不使工廠編號重覆
             IF tm.plant_7 = g_plant  THEN
                LET l_plant[7] = tm.plant_7
                LET m_legal[7] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_7) THEN
                   IF NOT r152_chkplant(tm.plant_7) THEN
                      CALL cl_err(tm.plant_7,g_errno,0)
                      NEXT FIELD plant_7
                   END IF
                   LET l_plant[7] = tm.plant_7
                   SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_7) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_7
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[7] = tm.plant_7
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r152_chklegal(m_legal[7],6) THEN
                   CALL cl_err(tm.plant_7,g_errno,0)
                   NEXT FIELD plant_7
                END IF
             END IF
             #FUN-A70084--add--end


      AFTER FIELD plant_8
             LET tm.plant_8 = duplicate(tm.plant_8,7)  # 不使工廠編號重覆
             IF tm.plant_8 = g_plant  THEN
                LET l_plant[8] = tm.plant_8
                LET m_legal[8] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_8) THEN
                   IF NOT r152_chkplant(tm.plant_8) THEN
                      CALL cl_err(tm.plant_8,g_errno,0)
                      NEXT FIELD plant_8
                   END IF
                   LET l_plant[8] = tm.plant_8
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_8) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_8
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[8] = tm.plant_8
                END IF
             END IF
      #FUN-A10098--add--end
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r152_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #FUN-A10098--add--str--
         IF tm.p = 'Y' AND cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND       #FUN-A80110 add tm.p = 'Y'
            cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
            cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
            cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN   #FUN-A70084 add l_cnt<=1
            CALL cl_err(0,'aap-137',0)
            NEXT FIELD plant_1
         END IF
      #FUN-A70084--add--str--
      IF l_cnt >1 THEN
         LET g_k = 1
         LET l_plant[1] = g_plant
      ELSE
      #FUN-A70084--add--end
         LET g_k=0
         FOR g_atot = 1  TO  8
             IF cl_null(l_plant[g_atot]) THEN
                CONTINUE FOR
             END IF
             LET g_k=g_k+1
             LET g_tmp[g_k]=l_plant[g_atot]
         END FOR

         FOR g_atot = 1  TO 8
             IF  g_atot > g_k THEN
                 LET l_plant[g_atot]=NULL
             ELSE
                 LET l_plant[g_atot]=g_tmp[g_atot]
             END IF
         END FOR
         #FUN-A10098--add--end 
      END IF   #FUN-A70084

      ON ACTION CONTROLP
         CASE WHEN INFIELD(a_curr)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = tm.a_curr
                   CALL cl_create_qry() RETURNING tm.a_curr
                   DISPLAY tm.a_curr TO FORMONLY.a_curr
              WHEN INFIELD(t_curr)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = tm.t_curr
                   CALL cl_create_qry() RETURNING tm.t_curr
                   DISPLAY tm.a_curr TO FORMONLY.t_curr
              #FUN-A10098--add--str--
              WHEN INFIELD(plant_1)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_1
                     CALL cl_create_qry() RETURNING tm.plant_1
                     DISPLAY BY NAME tm.plant_1
                     NEXT FIELD plant_1

                WHEN INFIELD(plant_2)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_2
                     CALL cl_create_qry() RETURNING tm.plant_2
                     DISPLAY BY NAME tm.plant_2
                     NEXT FIELD plant_2

                WHEN INFIELD(plant_3)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_3
                     CALL cl_create_qry() RETURNING tm.plant_3
                     DISPLAY BY NAME tm.plant_3
                     NEXT FIELD plant_3

                WHEN INFIELD(plant_4)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_4
                     CALL cl_create_qry() RETURNING tm.plant_4
                     DISPLAY BY NAME tm.plant_4
                     NEXT FIELD plant_4

                WHEN INFIELD(plant_5)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_5
                     CALL cl_create_qry() RETURNING tm.plant_5
                     DISPLAY BY NAME tm.plant_5
                     NEXT FIELD plant_5

                WHEN INFIELD(plant_6)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_6
                     CALL cl_create_qry() RETURNING tm.plant_6
                     DISPLAY BY NAME tm.plant_6
                     NEXT FIELD plant_6

                WHEN INFIELD(plant_7)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_7
                     CALL cl_create_qry() RETURNING tm.plant_7
                     DISPLAY BY NAME tm.plant_7
                     NEXT FIELD plant_7

                WHEN INFIELD(plant_8)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_8
                     CALL cl_create_qry() RETURNING tm.plant_8
                     DISPLAY BY NAME tm.plant_8
                     NEXT FIELD plant_8
              #FUN-A10098--add--end--
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   #年度期別要抓上一期的參考
   LET last_yy = tm.yy
   LET last_mm = tm.mm-1
   IF last_mm=0 THEN LET last_yy=tm.yy-1 LET last_mm=12 END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr152'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcr152','9031',1)
      ELSE
        #LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")   #FUN-A10098
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                        #" '",tm.wc1 CLIPPED,"'" ,   #FUN-A10098 
                         " '",tm.wc2 CLIPPED,"'" ,
                         " '",tm.s1 CLIPPED,"'" ,
                         " '",tm.t1 CLIPPED,"'" ,
                         " '",tm.u1 CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'" ,
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.o CLIPPED,"'" ,
                         " '",tm.a_curr CLIPPED,"'" ,
                         " '",tm.t_curr CLIPPED,"'" ,
                         " '",tm.rate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",tm.ctype CLIPPED,"'" #FUN-9C0170
                        ," '",tm.p CLIPPED,"'"     #FUN-A80110  
                         #FUN-A10098--add--str--
                        ," '",l_plant[1] CLIPPED,"'",
                         " '",l_plant[2] CLIPPED,"'",
                         " '",l_plant[3] CLIPPED,"'",
                         " '",l_plant[4] CLIPPED,"'",
                         " '",l_plant[5] CLIPPED,"'",
                         " '",l_plant[6] CLIPPED,"'",
                         " '",l_plant[7] CLIPPED,"'",
                         " '",l_plant[8] CLIPPED,"'"
                         #FUN-A10098--add--end
         CALL cl_cmdat('axcr152',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r152_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r152()
   ERROR ""
 END WHILE
 CLOSE WINDOW r152_w
 
END FUNCTION
 
#====================================
# 欄位是否可輸入
#====================================
FUNCTION r152_set_entry()
 
#  CALL cl_set_comp_entry("a_curr,t_curr,rate,b",TRUE)
   CALL cl_set_comp_entry("a_curr,t_curr,rate",TRUE)     #FUN-B30204
   CALL cl_set_comp_entry("plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8",TRUE)   #FUN-A80110
   IF cl_null(tm.o) OR tm.o = 'N' THEN
      CALL cl_set_comp_entry("a_curr,t_curr,rate",FALSE)
   END IF
#FUN-B30204--mark
#   IF cl_null(tm.a) OR tm.a = 'N' THEN
#      CALL cl_set_comp_entry("b",FALSE)
#   END IF
#FUN-B30204--mark
#FUN-A80110  ------------add start----------------------------
   IF cl_null(tm.p) OR tm.p = 'N' THEN
      CALL cl_set_comp_entry("plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8",FALSE)
   END IF
#FUN-A80110 ------------add end---------------------------------
END FUNCTION
 
#====================================
# 檢查幣別
#====================================
FUNCTION r152_chk_azi(p_azi01)
   DEFINE p_azi01         LIKE azi_file.azi01,
          l_aziacti       LIKE azi_file.aziacti
 
   LET g_errno = ''
 
   SELECT aziacti INTO l_aziacti FROM azi_file
    WHERE azi01 = p_azi01
   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'axs-001'
        WHEN l_aziacti <> 'Y'       LET g_errno = '9028'
        OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
END FUNCTION
 
#====================================
# 資料處理
#====================================
FUNCTION r152()
   DEFINE l_name      LIKE type_file.chr20,        # External(Disk) file name
          l_time      LIKE type_file.chr8,         # Used time for running the job
          l_sql       STRING,
         #l_azp01     LIKE azp_file.azp01,        #營運中心代碼    #FUN-A10098
         #l_azp03     LIKE azp_file.azp03,        #資料庫代碼      #FUN-A10098
          l_dbs_n     LIKE type_file.chr21,       #資料庫代碼(有含.)
          sr          RECORD
            order1    LIKE azp_file.azp01,        #營運中心
            order2    LIKE type_file.chr20,       #產品種類
            desc      LIKE type_file.chr1000,    #產品種類_中文說明
            ccg04     LIKE ccg_file.ccg04,        #料號
            ccg01     LIKE ccg_file.ccg01,        #工單單號
            ccg91     LIKE ccg_file.ccg91,        #在製數量
            ccc23     LIKE ccc_file.ccc23,        #成本單價
            #No.TQC-A50166  --Begin
            price     LIKE cma_file.cma25,        #淨變現單價
            cma27     LIKE cma_file.cma27,        #參考單號
            cma28     LIKE cma_file.cma28,        #參考項次
            cma29     LIKE cma_file.cma29,        #逆推-成品料號
            cma25     LIKE cma_file.cma25,        #逆推-成品料號_淨變現單價
            #No.TQC-A50166  --End   
            ccg92     LIKE ccg_file.ccg92,        #成本金額
            amt_m     LIKE ccc_file.ccc92,        #淨變現價值
            amt_o     LIKE ccc_file.ccc92,        #個別項目
            amt_p     LIKE ccc_file.ccc92,        #備抵跌價損失
            amt_q     LIKE ccc_file.ccc92,        #備抵跌價利益
            sfb98     LIKE sfb_file.sfb98,        #分類項目
            cma32     LIKE cma_file.cma32,        #銷售費用率  #No.TQC-A50166
            cma24     LIKE cma_file.cma24,        #凈變現計算類別 :1.成品 2.半成品 3.原料 #FUN-930100 add
            ccg07     LIKE ccg_file.ccg07         #FUN-9C0170
                      END RECORD,
          sr1         RECORD
            ima06     LIKE ima_file.ima06,        #主分群碼
            ima09     LIKE ima_file.ima09,        #分群碼一
            ima10     LIKE ima_file.ima10,        #分群碼二
            ima11     LIKE ima_file.ima11,        #分群碼三
            ima12     LIKE ima_file.ima12,        #成本分群
            ima131    LIKE ima_file.ima131,       #產品分類
            imz02     LIKE imz_file.imz02,        #主分群碼說明
            oba02     LIKE oba_file.oba02         #產品分類說明
                      END RECORD
     DEFINE l_mrate   LIKE ccg_file.ccg91        #FUN-930100
     DEFINE l_i       LIKE type_file.num5        #No.FUN-A10098 
     DEFINE l_cma293  LIKE cma_file.cma293       #CHI-B40026

     CALL cl_del_data(l_table)
     
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time            #FUN-B80056        MARK
     #No.FUN-BB0047--mark--Begin---
     #CALL cl_used(g_prog,g_time,1) RETURNING g_time             #FUN-B80056        ADD
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     
     IF tm.p = 'Y' THEN                         #FUN-A80110 add
        IF tm.a = 'N' THEN
           LET l_name = 'axcr152_1'
        ELSE
#FUN-B30204--mark
#           IF tm.b= 'Y' THEN 
#              LET l_name = 'axcr152'
#           ELSE 
#              LET l_name = 'axcr152_2'
#           END IF
            LET l_name = 'axcr152'
#FUN-B30204--mark
        END IF
             
     #FUN-A80110 -----add start-----------------
     ELSE
        IF tm.a = 'N' THEN
           LET l_name = 'axcr152_4'
        ELSE
#FUN-B30204--mark
#          IF tm.b= 'Y' THEN
#             LET l_name = 'axcr152_3'
#          ELSE
#             LET l_name = 'axcr152_5'
#          END IF
           LET l_name = 'axcr152_3'
#FUN-B30204--mark
        END IF
     END IF
     #FUN-A80110 ----add end-------------------
     
     SELECT azi03,azi04,azi05,azi07
       INTO g_azi03,g_azi04,g_azi05,g_azi07
       FROM azi_file
      WHERE azi01 = tm.t_curr
 
    #FUN-A10098--mod--str--
    #LET l_sql = "SELECT azp01,azp03 FROM azp_file ",
    #            " WHERE ", tm.wc1 CLIPPED
    #PREPARE r152_pre1 FROM l_sql
    #IF SQLCA.sqlcode != 0 THEN
    #   CALL cl_err('r152_pre1:',SQLCA.sqlcode,1)
    #   EXIT PROGRAM
    #END IF
    #DECLARE r152_cs1 CURSOR FOR r152_pre1
    #FOREACH r152_cs1 INTO l_azp01,l_azp03
    #   IF SQLCA.SQLCODE THEN
    #      CALL cl_err('FOREACH r152_cs1:',SQLCA.SQLCODE,0)
    #      EXIT FOREACH
    #   END IF
    #   LET l_dbs_n = s_dbstring(l_azp03 CLIPPED)
     LET l_i = 1
     FOR l_i = 1 TO g_k     #g_k的值為實際的資料庫數目
        IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
    #FUN-A10098--mod--end
        LET l_sql = "SELECT '','','',",
                    "       ccg04,ccg01,ccg91,ccc23,0,",
                    "       cma27,cma28,cma29,cma25,", #FUN-8B0047 #FUN-930100 add cma25
                    "       ccg92,0,0,0,0,sfb98,cma32,cma24,ccg07,", #FUN-8B0047 #FUN-930100 add cma24 #FUN-9C0170
                    "       ima06,ima09,ima10,ima11,ima12,ima131,",
                    "       imz02,oba02",
#FUN-A10098--mod--str--
#"  FROM ", l_dbs_n CLIPPED, "ccg_file LEFT OUTER JOIN ",l_dbs_n CLIPPED,"ccc_file ON ccg04 = ccc01 AND ccg02 = ccc02 AND ccg06=ccc07 AND ccg07=ccc08 AND ccg03 = ccc03 ", #FUN-9C0170
#"                                     LEFT OUTER JOIN ",l_dbs_n CLIPPED,"sfb_file ON ccg01 = sfb01 ",
#"                                     LEFT OUTER JOIN ",l_dbs_n CLIPPED,"cma_file ON ccg04 = cma01 AND ccg02 = cma021 AND ccg06=cma07 AND ccg07=cma08  AND ccg03 = cma022,", #FUN-9C0170
#"       ", l_dbs_n CLIPPED, "ima_file LEFT OUTER JOIN ",l_dbs_n CLIPPED,"imz_file ON ima06 = imz01 ",
#"                                     LEFT OUTER JOIN ",l_dbs_n CLIPPED,"oba_file ON ima131= oba01 ",
                    "  FROM ",cl_get_target_table(l_plant[l_i],'ccg_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'ccc_file'),
                    "       ON ccg04 = ccc01 AND ccg02 = ccc02 AND ccg06=ccc07",
                    "       AND ccg07=ccc08 AND ccg03 = ccc03",
                   #"       AND ccg06='1' AND ccc08=' ') ",         #CHI-AA0018 add #TQC-AC0126 mark
                   #"       AND ccg06='1' AND ccc08=' ' ",          #TQC-AC0126 add #MOD-C90175 mark
                    "       AND ccg06='",tm.ctype,"' AND ccc08=' ' ",               #MOD-C90175
                    "       AND ccg07 = ccc08",                     #MOD-C30040 add
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'sfb_file'),
                    "       ON ccg01 = sfb01 ",
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'cma_file'),
                    "       ON ccg04 = cma01 AND ccg02 = cma021 AND ccg06=cma07 ",
                    "       AND ccg07=cma08  AND ccg03 = cma022,",
                    "       ",cl_get_target_table(l_plant[l_i],'ima_file'),
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'imz_file'),
                    "       ON ima06 = imz01 ",
                    "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'oba_file'),
                    "       ON ima131= oba01 ",
#FUN-A10098--mod--end
                    " WHERE ccg04 = ima_file.ima01 ",
                    "   AND ccg02 = ", tm.yy,
                    "   AND ccg03 = ", tm.mm,
                   #"   AND ccc07 = '",tm.ctype,"'",   #FUN-9C0170  #MOD-C30040 mark
                    "   AND ccg06 = '",tm.ctype,"'",   #MOD-C30040
#                   "   AND ccc07 = ccg06 ", #FUN-8C0049  #CHI-970021  #No.TQC-A50166
                   #"   AND ccg07 = ccc08 ",    #FUN-9C0170     #MOD-C30040 mark
                   #"   AND ccg06 = '1' ",      #CHI-AA0018 add #MOD-C90175 mark
                    "   AND ", tm.wc2 CLIPPED
#FUN-B30204--mark
                 IF tm.b='Y' THEN
                    LET l_sql = l_sql," AND ccg92 > '0' "
                 END IF
#FUN-B30204--mark 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       #CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
        PREPARE r152_pre2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('r152_pre2:',SQLCA.sqlcode,1)
          #EXIT FOREACH     #FUN-A10098
           EXIT FOR         #FUN-A10098
        END IF
        DECLARE r152_cs2 CURSOR FOR r152_pre2
        FOREACH r152_cs2 INTO sr.*,sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('FOREACH r152_cs2:',SQLCA.sqlcode,1)
              EXIT FOREACH  
           END IF
          #在製數量
           IF sr.ccg91 IS NULL THEN LET sr.ccg91 = 0 END IF
          #成本金額
           IF sr.ccg92 IS NULL THEN LET sr.ccg92 = 0 END IF
           IF sr.ccc23 IS NULL THEN LET sr.ccc23 = 0 END IF
           IF sr.price IS NULL THEN LET sr.price= 0 END IF
           IF sr.amt_m IS NULL THEN LET sr.amt_m = 0 END IF
           IF sr.amt_o IS NULL THEN LET sr.amt_o = 0 END IF
           IF sr.amt_p IS NULL THEN LET sr.amt_p = 0 END IF
           IF sr.amt_q IS NULL THEN LET sr.amt_q = 0 END IF
           IF sr.cma32 IS NULL THEN LET sr.cma32 = 0 END IF #TQC-A50166
           LET sr.ccg92 = sr.ccg92 * tm.rate
          #LET sr.ccg92 = cl_digcut(sr.ccg92,g_azi04)  #TQC-A50166
          #成本單價
           IF sr.ccc23 IS NULL THEN LET sr.ccc23 = 0 END IF
           LET sr.ccc23 = sr.ccc23 * tm.rate
          #LET sr.ccc23 = cl_digcut(sr.ccc23,g_azi03)  #TQC-A50166
          #逆推-成品料號_淨變現單價
           IF cl_null(sr.cma29) THEN LET sr.cma29=sr.ccg04 END IF #TQC-A50166

           IF sr.cma25 IS NULL THEN LET sr.cma25 = 0 END IF #TQC-A50166
           LET sr.cma25 = sr.cma25 * tm.rate                #TQC-A50166
          #LET sr.cmd05 = cl_digcut(sr.cmd05,g_azi03)       #TQC-A50166
 
           IF sr.ccg91 > 0 THEN
              LET l_mrate = sr.ccg92 / sr.ccg91
           ELSE
              LET l_mrate=0
           END IF
           IF sr.cma24= '1' OR sr.cma24 IS NULL THEN #成品
             #case 1: 工單開成品 A,WIP淨變現 = A淨變現值 - ( A成本ccc23 - ( WIP本月結存金額ccg92/WIP本月結存數量ccg91) )
             #                     WIP淨變現值 =WIP淨變現單價  x WIP本月結存數量ccg91
             LET sr.price = sr.cma25  #TQC-A50166
            #LET sr.price = cl_digcut(sr.price,g_azi03)  #TQC-A50166
             IF sr.ccc23-l_mrate > 0 THEN      #MOD-C20098 add
                LET sr.price = sr.price - ( sr.ccc23 - l_mrate )  #FUN-930100
             END IF                            #MOD-C20098 add
             IF sr.price < 0 THEN LET sr.price = 0  END IF  #CHI-970011
             LET sr.ccc23=sr.ccc23 - (sr.ccc23-l_mrate)     #CHI-970011 add
             IF sr.ccc23 < 0 THEN LET sr.ccc23 = 0 END IF   #CHI-970011 add
             LET sr.amt_m = sr.price * sr.ccg91 
            #LET sr.amt_m = cl_digcut(sr.amt_m,g_azi04)  #TQC-A50166
           ELSE #半成品
             #case 2: 工單開半成品 B,WIP淨變現單價 =A淨變現單價 - ( A成本ccc23 - ( WIP本月結存金額ccg92/WIP本月結存數量ccg91) )
             #                       WIP淨變現值 =WIP淨變現單價  x WIP本月結存數量ccg91
             IF sr.cma29 = 'AVG' THEN  # cma29 ='AVG' ==> 逆推成本取平均值  #No.TQC-A50166
                SELECT cma291,cma292,cma293 INTO sr.ccc23,sr.cma25,l_cma293  #TQC-A50166  #CHI-B40026
                                     FROM cma_file
                                    WHERE cma01  = sr.ccg04
                                      AND cma021 = tm.yy
                                      AND cma022 = tm.mm
             ELSE
                SELECT ccc23,cma25,cmh031 INTO sr.ccc23,sr.cma25,l_cma293  #TQC-A50166  #CHI-B40026
                             FROM cma_file
                             LEFT OUTER JOIN ccc_file ON (ccc_file.ccc01=cma_file.cma01 AND ccc02 = cma021 AND ccc03 = cma022 and ccc07='1' and ccc08=' ')  #CHI-970011
                             LEFT OUTER JOIN cmh_file ON (cmh03=sr.ccg04 AND cmh04=sr.cma29 AND cmh01 = cma021 AND cmh02 = cma022 AND cmh071='1' AND cmh081=' ')  #CHI-B40026 
                            WHERE cma01  = sr.cma29  #TQC-A50166
                              AND cma021 = tm.yy
                              AND cma022 = tm.mm                
                IF cl_null(sr.ccc23) THEN
                   SELECT cca23 INTO sr.ccc23 
                     FROM cca_file
                    WHERE cca01=sr.cma29  #TQC-A50166
                      AND cca02= last_yy #注:年度期別要抓上一期的
                      AND cca03= last_mm #注:年度期別要抓上一期的
                END IF
             END IF
             IF sr.ccc23 IS NULL THEN LET sr.ccc23 = 0 END IF
             IF l_cma293 IS NULL OR l_cma293=0 THEN LET l_cma293 = 1 END IF  #CHI-B40026
             LET sr.ccc23 = sr.ccc23 * tm.rate
            #LET sr.ccc23 = cl_digcut(sr.ccc23,g_azi03)  #TQC-A50166
             IF sr.cma25 IS NULL THEN LET sr.cma25 = 0 END IF #TQC-A50166
             LET sr.cma25 = sr.cma25 * tm.rate  #TQC-A50166
            #LET sr.cmd05 = cl_digcut(sr.cmd05,g_azi03)  #TQC-A50166

             LET sr.price = sr.cma25   #TQC-A50166
            #LET sr.price = cl_digcut(sr.price,g_azi03)  #TQC-A50166
             IF ( sr.ccc23 - l_mrate * l_cma293) > 0 THEN  #CHI-B40042
                 LET sr.price = sr.price - ( sr.ccc23 - l_mrate * l_cma293)  #FUN-930100  #CHI-B40026  #CHI-B40042
             END IF    #FUN-AC0074                                 
             LET sr.price = sr.price / l_cma293   #CHI-B40026
             IF sr.price < 0 THEN LET sr.price = 0  END IF  #CHI-970011
             LET sr.ccc23=sr.ccc23 - (sr.ccc23-l_mrate)     #CHI-970011 add
             IF sr.ccc23 < 0 THEN LET sr.ccc23 = 0 END IF   #CHI-970011 add
             LET sr.amt_m = sr.price * sr.ccg91
            #LET sr.amt_m = cl_digcut(sr.amt_m,g_azi04)  #TQC-A50166
           END IF           
           
          #營運中心
          #LET sr.order1 = l_azp01        #FUN-A10098
           LET sr.order1 = l_plant[l_i]   #FUN-A10098
           CASE tm.s1
               WHEN '1'
                    LET sr.order2 = sr1.ima06
                    LET sr.desc = sr1.imz02
               WHEN '2'
                    LET sr.order2 = sr1.ima09
                   #CALL r152_get_azf03(l_dbs_n,sr1.ima09,'D') RETURNING sr.desc   #FUN-A10098
                    CALL r152_get_azf03(l_plant[l_i],sr1.ima09,'D') RETURNING sr.desc   #FUN-A10098
               WHEN '3'
                    LET sr.order2 = sr1.ima10
                   #CALL r152_get_azf03(l_dbs_n,sr1.ima10,'E') RETURNING sr.desc        #FUN-A10098
                    CALL r152_get_azf03(l_plant[l_i],sr1.ima10,'E') RETURNING sr.desc   #FUN-A10098
               WHEN '4'
                    LET sr.order2 = sr1.ima11
                   #CALL r152_get_azf03(l_dbs_n,sr1.ima11,'F') RETURNING sr.desc        #FUN-A10098
                    CALL r152_get_azf03(l_plant[l_i],sr1.ima11,'F') RETURNING sr.desc   #FUN-A10098
               WHEN '5'
                    LET sr.order2 = sr1.ima12
                   #CALL r152_get_azf03(l_dbs_n,sr1.ima12,'G') RETURNING sr.desc        #FUN-A10098
                    CALL r152_get_azf03(l_plant[l_i],sr1.ima12,'G') RETURNING sr.desc   #FUN-A10098
               WHEN '6'
                    LET sr.order2 = sr1.ima131
                    LET sr.desc = sr1.oba02
           END CASE
           MESSAGE sr.order1 CLIPPED, ' / ', sr.order2 CLIPPED 
           CALL ui.Interface.refresh()
          #個別項目,備抵跌價損失,備抵跌價利益
           IF sr.ccg92 > sr.amt_m THEN
              LET sr.amt_o = sr.amt_m
              LET sr.amt_p = sr.amt_m - sr.ccg92
           ELSE
              LET sr.amt_o = sr.ccg92
              LET sr.amt_q = sr.amt_m - sr.ccg92
           END IF
           EXECUTE insert_prep USING sr.*
        END FOREACH
    #END FOREACH    #FUN-A10098
     END FOR        #FUN-A10098
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
       #CALL cl_wcchp(tm.wc1,'azp01,ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
        CALL cl_wcchp(tm.wc2,'ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
             RETURNING g_str
     END IF
     #LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.t_curr,";",tm.rate,";",g_azi03     #CHI-C30012
     LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.t_curr,";",tm.rate,";",g_ccz.ccz26  #CHI-C30012
                 #,";",g_azi04,";",tm.a,";",tm.b,";",tm.t1,";",tm.u1,";",g_azi07,";",tm.ctype,";",tm.p    #FUN-9C0170   #FUN-A80110 add tm.p #CHI-C30012
                 ,";",g_ccz.ccz26,";",tm.a,";",tm.b,";",tm.t1,";",tm.u1,";",g_azi07,";",tm.ctype,";",tm.p,";",g_ccz.ccz27 #CHI-C30012
     CALL cl_prt_cs3('axcr152',l_name,l_sql,g_str)   
    # CALL cl_used(g_prog,l_time,2) RETURNING l_time       #FUN-B80056    MARK
     #No.FUN-BB0047--mark--Begin---
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80056    ADD 
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#====================================
# 取得azf03
#====================================
#FUNCTION r152_get_azf03(p_dbs,p_azf01,p_azf02)   #FUN-A10098
FUNCTION r152_get_azf03(p_plant,p_azf01,p_azf02)   #FUN-A10098
  #DEFINE p_dbs       LIKE type_file.chr21   #FUN-A10098
   DEFINE p_plant     LIKE azp_file.azp01    #FUN-A10098
   DEFINE p_azf01     LIKE azf_file.azf01
   DEFINE p_azf02     LIKE azf_file.azf02
   DEFINE l_sql       STRING
   DEFINE l_azf03     LIKE azf_file.azf03
 
  #LET l_sql = "SELECT azf03 FROM ", p_dbs CLIPPED, "azf_file ", #FUN-A10098
   LET l_sql = "SELECT azf03 FROM ",cl_get_target_table(p_plant,'azf_file'),  #FUN-A10098
               " WHERE azf01 = '", p_azf01, "' ",
               "   AND azf02 = '", p_azf02, "' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
   PREPARE r152_azf_p1 FROM l_sql
   DECLARE r152_azf_cs1 CURSOR FOR r152_azf_p1
   OPEN r152_azf_cs1
   FETCH r152_azf_cs1 INTO l_azf03
   RETURN l_azf03
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

#FUN-A10098--add--str--
FUNCTION r152_chkplant(l_plant)
   DEFINE l_plant     LIKE azp_file.azp01

   SELECT azp01 FROM azp_file
    WHERE azp01 = l_plant
   IF SQLCA.SQLCODE THEN
      LET g_errno='aom-300'
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION

FUNCTION duplicate(li_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE li_plant     LIKE azp_file.azp01
   DEFINE l_idx,n      LIKE type_file.num10

   FOR l_idx = 1 TO n
       IF l_plant[l_idx] = li_plant THEN
          LET li_plant = ''
       END IF
   END FOR
   RETURN li_plant
END FUNCTION
#FUN-A10098--add--end 
#FUN-A70084--add--str--
FUNCTION r152_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("gb13",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r152_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
#FUN-A70084--add--end
