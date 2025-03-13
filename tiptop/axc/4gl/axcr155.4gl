# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcr155.4gl
# Descriptions...: LCM平均值取價單據明細表
# Date & Author..: No.FUN-950058 09/05/25 By kim
# Modify.........: NO.CHI-970034 09/08/12 By jan 報表打印增加cmg10/cmg11
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0170 10/01/07 By jan 新增ctype欄位及相關處理
# Modify.........: No.FUN-A10098 10/01/20 By lutingting GP5.2跨DB處理 
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表整批修改
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
#FUN-950058
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc1     STRING,                # Where condition    #FUN-A10098
              wc2     STRING,                # Where condition
              yy      LIKE type_file.num5,   # 年度
              mm      LIKE type_file.num5,   # 期別
              ctype   LIKE type_file.chr1,   #FUN-9C0170
              a       LIKE type_file.chr1,
              b       LIKE type_file.chr1,
              more    LIKE type_file.chr1  # Input more condition(Y/N)
              #FUN-A10098--add--str--
             ,plant_1,plant_2,plant_3,plant_4 LIKE cre_file.cre08,
              plant_5,plant_6,plant_7,plant_8 LIKE cre_file.cre08
             #FUN-A10098--add--end
              END RECORD
  DEFINE l_table     STRING
  DEFINE g_sql       STRING
  DEFINE g_str       STRING
  DEFINE l_plant     ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098
  DEFINE g_tmp       ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098
  DEFINE g_atot,g_k  LIKE type_file.num5    #FUN-A10098 
  DEFINE m_legal           ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
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

   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #FUN-A10098--mod--str--
  #LET tm.wc1   = ARG_VAL(7)
  #LET tm.wc2   = ARG_VAL(8)
  #LET tm.yy    = ARG_VAL(9)
  #LET tm.mm    = ARG_VAL(10)
  #LET tm.a     = ARG_VAL(11)
  #LET tm.a     = ARG_VAL(12)
  #LET g_rep_user = ARG_VAL(13)
  #LET g_rep_clas = ARG_VAL(14)
  #LET g_template = ARG_VAL(15)
  #LET tm.ctype    = ARG_VAL(16) #FUN-9C0170
   LET tm.wc2   = ARG_VAL(7)
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.ctype   = ARG_VAL(15) 
   LET tm.plant_1 = ARG_VAL(16)
   LET tm.plant_2 = ARG_VAL(17)
   LET tm.plant_3 = ARG_VAL(18)
   LET tm.plant_4 = ARG_VAL(19)
   LET tm.plant_5 = ARG_VAL(20)
   LET tm.plant_6 = ARG_VAL(21)
   LET tm.plant_7 = ARG_VAL(22)
   LET tm.plant_8 = ARG_VAL(23)
  #FUN-A10098--mod--end 
   LET g_sql = "cma021.cma_file.cma021,",
               "cma022.cma_file.cma022,",
               "cma31.cma_file.cma31,",
               "cme03.cme_file.cme03,",
               "cma24.cma_file.cma24,",
               "cma01.cma_file.cma01,",
               "cmg09.cmg_file.cmg09,",
               "cmg05.cmg_file.cmg05,",
               "cmg06.cmg_file.cmg06,",
               "cmg07.cmg_file.cmg07,",
               "cmg08.cmg_file.cmg08,",
               "imz02.imz_file.imz02,",
               "oba02.oba_file.oba02,",
               "cmg10.cmg_file.cmg10,",          #CHI-970034
               "cmg11.cmg_file.cmg11,",          #CHI-970034
               "cmg11_fac.cmg_file.cmg11_fac,",  #CHI-970034
               "cma08.cma_file.cma08,",          #FUN-9C0170
               "l_desc.imz_file.imz02"
 
   LET l_table = cl_prt_temptable('axcr155',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )" #CHI-970034 add ??? #FUN-9C0170 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
  #IF cl_null(tm.wc1)   #FUN-A10098
   IF cl_null(tm.wc2)   #FUN-A10098
      THEN CALL r155_tm(0,0)             # Input print condition
      ELSE CALL r155()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#====================================
# 開窗輸入條件
#====================================
FUNCTION r155_tm(p_row,p_col)
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
   OPEN WINDOW r155_w AT p_row,p_col WITH FORM "axc/42f/axcr155"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   CALL r155_set_visible() RETURNING l_cnt    #FUN-A70084

   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.yy   = YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.a    = 'Y'
   LET tm.b    = 'N'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
   LET l_exT = 'S'
   LET l_plant[1]=g_plant   #預設現行工廠 #No.FUN-A10098
 
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
 #    CLOSE WINDOW r410_w
 #    CALL cl_used(g_prog,g_time,2) RETURNING g_time
 #    EXIT WHILE
 # END IF
 # IF tm.wc1 = " 1=1" THEN
 #    CALL cl_err('','9046',0)
 #    CONTINUE WHILE
 # END IF
 #FUN-A10098--mod--end 

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
 
   INPUT BY NAME tm.yy,tm.mm,tm.ctype,tm.a,tm.b,tm.more 
                 #FUN-A10098--add--str--
                ,tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8
                #FUN-A10098--add--end
            WITHOUT DEFAULTS  #FUN-9C0170
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
            LET m_legal[1] = g_legal   #FUN-A70084
            DISPLAY tm.plant_1 TO FORMONLY.plant_1
            EXIT INPUT
         END IF

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
            IF NOT r155_chkplant(tm.plant_1) THEN
               CALL cl_err(tm.plant_1,g_errno,0)
               NEXT FIELD plant_1
            END IF
            LET l_plant[1] = tm.plant_1
            CALL s_chk_demo(g_user,tm.plant_1) RETURNING li_result
            IF not li_result THEN
               NEXT FIELD plant_1
            END IF
            SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
         END IF

      AFTER FIELD plant_2
             LET tm.plant_2 = duplicate(tm.plant_2,1)  # 不使工廠編號重覆
             IF tm.plant_2 = g_plant  THEN
                LET l_plant[2] = tm.plant_2
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                   IF NOT r155_chkplant(tm.plant_2) THEN
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
                IF NOT r155_chklegal(m_legal[2],1) THEN
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
                   IF NOT r155_chkplant(tm.plant_3) THEN
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
                IF NOT r155_chklegal(m_legal[3],2) THEN
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
                   IF NOT r155_chkplant(tm.plant_4) THEN
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
                IF NOT r155_chklegal(m_legal[4],3) THEN
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
                   IF NOT r155_chkplant(tm.plant_5) THEN
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
                IF NOT r155_chklegal(m_legal[5],4) THEN
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
                   IF NOT r155_chkplant(tm.plant_6) THEN
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
                IF NOT r155_chklegal(m_legal[6],5) THEN
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
                   IF NOT r155_chkplant(tm.plant_7) THEN
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
                IF NOT r155_chklegal(m_legal[7],6) THEN
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
                   IF NOT r155_chkplant(tm.plant_8) THEN
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
                IF NOT r155_chklegal(m_legal[8],7) THEN
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
         IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
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
      END IF  #FUN-A70084
 
      #FUN-A10098--add--str--
      ON ACTION CONTROLP
         CASE
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
         END CASE
      #FUN-A10098--add--end

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
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr155'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcr155','9031',1)
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
                        #" '",tm.wc1 CLIPPED,"'" ,    #FUN-A10098
                         " '",tm.wc2 CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'" ,
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.a  CLIPPED,"'" ,
                         " '",tm.b  CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",tm.ctype  CLIPPED,"'"    #FUN-9C0170
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
         CALL cl_cmdat('axcr155',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r155_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r155()
   ERROR ""
 END WHILE
 CLOSE WINDOW r155_w
 
END FUNCTION
 
 
#====================================
# 資料處理
#====================================
FUNCTION r155()
   DEFINE l_name      LIKE type_file.chr20,        # External(Disk) file name
          l_time      LIKE type_file.chr8,         # Used time for running the job
          l_sql       STRING,
         #l_azp01     LIKE azp_file.azp01,        #營運中心代碼    #FUN-A10098
         #l_azp03     LIKE azp_file.azp03,        #資料庫代碼      #FUN-A10098
          l_dbs_n     LIKE type_file.chr21,                #資料庫代碼(有含.)
          l_flag      LIKE type_file.num5,
          l_fac       LIKE ima_file.ima31_fac,
          l_tot       LIKE ccc_file.ccc92,        #By料號加總成本金額
          l_diff      LIKE ccc_file.ccc92,        #成本金額差異
          sr          RECORD
            cma021    LIKE cma_file.cma021,
            cma022    LIKE cma_file.cma022,
            cma31     LIKE cma_file.cma31,
            cme03     LIKE cme_file.cme03,
            cma24     LIKE cma_file.cma24,
            cma01     LIKE cma_file.cma01,
            cmg09     LIKE cmg_file.cmg09,
            cmg05     LIKE cmg_file.cmg05,
            cmg06     LIKE cmg_file.cmg06,
            cmg07     LIKE cmg_file.cmg07,
            cmg08     LIKE cmg_file.cmg08,
            imz02     LIKE imz_file.imz02,
            oba02     LIKE oba_file.oba02,
            cmg10     LIKE cmg_file.cmg10,     #CHI-970034
            cmg11     LIKE cmg_file.cmg11,     #CHI-970034
            cmg11_fac LIKE cmg_file.cmg11_fac, #CHI-970034
            cma08     LIKE cma_file.cma08      #FUN-9C0170
      
                      END RECORD,
          sr1         RECORD
            ima06     LIKE ima_file.ima06,        #主分群碼
            ima09     LIKE ima_file.ima09,        #分群碼一
            ima10     LIKE ima_file.ima10,        #分群碼二
            ima11     LIKE ima_file.ima11,        #分群碼三
            ima12     LIKE ima_file.ima12,        #成本分群
            ima131    LIKE ima_file.ima131,       #產品分類
            desc      LIKE imz_file.imz02         #主分群碼說明
                      END RECORD
     DEFINE l_cma24   LIKE cma_file.cma24
     DEFINE l_cma29_c  LIKE cma_file.cma25
     DEFINE l_cma29_n  LIKE cma_file.cma25
     DEFINE l_msg      LIKE ze_file.ze03
     DEFINE l_i       LIKE type_file.num5        #No.FUN-A10098 
 
     CALL cl_del_data(l_table)
 
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-B80056   MARK
     CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80056   ADD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
    #FUN-A10098--mod--str--
    #LET l_sql = "SELECT azp01,azp03 FROM azp_file ",
    #            " WHERE ", tm.wc1 CLIPPED
    #PREPARE r155_pre1 FROM l_sql
    #IF SQLCA.sqlcode != 0 THEN
    #   CALL cl_err('r155_pre1:',SQLCA.sqlcode,1)
    #   EXIT PROGRAM
    #END IF
    #DECLARE r155_cs1 CURSOR FOR r155_pre1
    #FOREACH r155_cs1 INTO l_azp01,l_azp03
    #   IF SQLCA.SQLCODE THEN
    #      CALL cl_err('FOREACH r155_cs1:',SQLCA.SQLCODE,0)
    #      EXIT FOREACH
    #   END IF
    #   LET l_dbs_n = l_azp03 CLIPPED, "."
     LET l_i = 1
     FOR l_i = 1 TO g_k     #g_k的值為實際的資料庫數目 
        IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
    #FUN-A10098--mod--end
        LET l_sql = "SELECT cma021,cma022,cma31,'',cma24,cma01,",
                    "       cmg09,cmg05,cmg06,cmg07,cmg08,",
                    "       imz02,oba02,",
                    "       cmg10,cmg11,cmg11_fac,cma08,",   #CHI-970034  #FUN-9C0170 add cma08
                    "       ima06,ima09,ima10,ima11,ima12,ima131,'' ",
                   #FUN-A10098--mod--str--
                   #"  FROM ", l_dbs_n CLIPPED, "cma_file,",
                   #           l_dbs_n CLIPPED, "cmg_file,",
                   #           l_dbs_n CLIPPED, "ima_file ",
                   #"  LEFT OUTER JOIN ",l_dbs_n CLIPPED, " imz_file ON (imz_file.imz01=ima_file.ima06 ) ",
                   #"  LEFT OUTER JOIN ",l_dbs_n CLIPPED, " oba_file ON (oba_file.oba01=ima_file.ima131) ",
                    "  FROM ",cl_get_target_table(l_plant[l_i],'cma_file'),",",
                    "       ",cl_get_target_table(l_plant[l_i],'cmg_file'),",",
                    "       ",cl_get_target_table(l_plant[l_i],'ima_file'),
                    "         LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'imz_file'),
                    "                           ON (imz_file.imz01=ima_file.ima06 ) ",
                    "         LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'oba_file'),
                    "                           ON (oba_file.oba01=ima_file.ima131) ",
                   #FUN-A10098--mod--end
                    " WHERE cma01=ima01 ",
                    "   AND cma021= ", tm.yy,
                    "   AND cma022= ", tm.mm,
                    "   AND cma07 = '",tm.ctype,"'",  #FUN-9C0170
                    "   AND cmg01=cma021",
                    "   AND cmg02=cma022",
                    "   AND cmg03=cma01",
                    "   AND cma07=cmg071",  #FUN-9C0170
                    "   AND cma08=cmg081",  #FUN-9C0170
                    "   AND ", tm.wc2 CLIPPED ,
                    " ORDER BY cma021,cma022,cma31,cma01,cmg04"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       #CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
        PREPARE r155_pre2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('r155_pre2:',SQLCA.sqlcode,1)
          #EXIT FOREACH   #FUN-A10098
          EXIT FOR        #FUN-A10098
        END IF
        DECLARE r155_cs2 CURSOR FOR r155_pre2
        FOREACH r155_cs2 INTO sr.*,sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('FOREACH r155_cs2:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          #CASE sr.cma24
          #   WHEN '1'
          #      CALL cl_getmsg('aco-047',g_lang) RETURNING l_msg
          #   WHEN '2'
          #      CALL cl_getmsg('axc-007',g_lang) RETURNING l_msg
          #   WHEN '3'
          #      CALL cl_getmsg('axc-008',g_lang) RETURNING l_msg
          #END CASE
           CASE sr.cma31
                WHEN '1'
                     LET sr.cme03=sr1.ima06
                     LET sr1.desc = sr.imz02
                WHEN '2'
                     LET sr.cme03=sr1.ima09
                    #CALL r155_get_azf03(l_dbs_n,sr1.ima09,'D') RETURNING sr1.desc   #FUN-A10098
                     CALL r155_get_azf03(l_plant[l_i],sr1.ima09,'D') RETURNING sr1.desc   #FUN-A10098
                WHEN '3'
                     LET sr.cme03=sr1.ima10
                    #CALL r155_get_azf03(l_dbs_n,sr1.ima10,'E') RETURNING sr1.desc   #FUN-A10098
                     CALL r155_get_azf03(l_plant[l_i],sr1.ima10,'E') RETURNING sr1.desc   #FUN-A10098
                WHEN '4'
                     LET sr.cme03=sr1.ima11
                    #CALL r155_get_azf03(l_dbs_n,sr1.ima11,'F') RETURNING sr1.desc   #FUN-A10098
                     CALL r155_get_azf03(l_plant[l_i],sr1.ima11,'F') RETURNING sr1.desc   #FUN-A10098
                WHEN '5'
                     LET sr.cme03=sr1.ima12
                    #CALL r155_get_azf03(l_dbs_n,sr1.ima12,'G') RETURNING sr1.desc   #FUN-A10098
                     CALL r155_get_azf03(l_plant[l_i],sr1.ima12,'G') RETURNING sr1.desc   #FUN-A10098
                WHEN '6'
                     LET sr.cme03=sr1.ima131
                     LET sr1.desc = sr.oba02
           END CASE
           EXECUTE insert_prep USING sr.*,sr1.desc
        END FOREACH
   #END FOREACH   #FUN-A10098
    END FOR       #FUN-A10098
 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table  CLIPPED
   #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
      #CALL cl_wcchp(tm.wc1,'azp01,ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
       CALL cl_wcchp(tm.wc2,'ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
         RETURNING g_str
    END IF
    LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.a,
                #";",g_azi03,";",g_azi04,";",g_azi05,";",tm.b #CHI-C30012
                ";",g_ccz.ccz26,";",g_ccz.ccz26,";",g_ccz.ccz26,";",tm.b  #CHI-C30012
    CALL cl_prt_cs3('axcr155','axcr155',l_sql,g_str)   
 
    #CALL cl_used(g_prog,l_time,2) RETURNING l_time        #FUN-B80056     MARK
    CALL cl_used(g_prog,g_time,1) RETURNING g_time         #FUN-B80056     ADD
 
END FUNCTION
 
#====================================
# 取得azf03
#====================================
#FUNCTION r155_get_azf03(p_dbs,p_azf01,p_azf02)   #FUN-A10098
FUNCTION r155_get_azf03(p_plant,p_azf01,p_azf02)   #FUN-A10098
  #DEFINE p_dbs       LIKE type_file.chr21    #FUN-A10098
   DEFINE p_plant     LIKE azp_file.azp01     #FUN-A10098
   DEFINE p_azf01     LIKE azf_file.azf01
   DEFINE p_azf02     LIKE azf_file.azf02
   DEFINE l_sql       STRING
   DEFINE l_azf03     LIKE azf_file.azf03
 
  #LET l_sql = "SELECT azf03 FROM ", p_dbs CLIPPED, "azf_file ",   #FUN-A10098
   LET l_sql = "SELECT azf03 FROM ",cl_get_target_table(p_plant,'azf_file'),  #FUN-A10098
               " WHERE azf01 = '", p_azf01, "' ",
               "   AND azf02 = '", p_azf02, "' "
  #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
   PREPARE r155_azf_p1 FROM l_sql
   DECLARE r155_azf_cs1 CURSOR FOR r155_azf_p1
   OPEN r155_azf_cs1
   FETCH r155_azf_cs1 INTO l_azf03
   RETURN l_azf03
END FUNCTION
#FUN-950058

#FUN-A10098--add--str--
FUNCTION r155_chkplant(l_plant)
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
FUNCTION r155_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("gb11",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r155_chklegal(l_legal,n)
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
