# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmi162.4gl
# Descriptions...: 集團銷售預測調整作業
# Date & Author..: 06/03/14 By Sarah
# Modify.........: No.FUN-620032 06/03/14 By Sarah 新增"集團銷售預測調整作業"
# Modify.........: No.FUN-640171 06/04/13 By Sarah 單身的預測數量應為預測總量(含下層數量)
# Modify.........: No.FUN-660104 06/06/21 By day   cl_err --> cl_err3
# Modify.........: No.FUN-680047 06/08/16 By Sarah 確認訊息加強(告知是何原因導致無法做確認、取消確認)
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0217 06/12/30 By Rayven 在”上層數量調整“或“上層金額調整”action中，點”退出“時，該程序會當出
#                                                   在”上層調整審核“出錯時，系統有時會提示多次同樣的錯誤
# Modify.........: No.TQC-740039 07/04/10 By Ray 1.查詢時狀態頁簽中的欄位不可下條件
#                                                2.‘上層調整審核’時，系統提示成功，其實并沒有成功
# Modify.........: No.TQC-750069 07/05/15 By kim 隱藏"單身"按鈕
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-930231 09/03/23 By Dido 當”上層數量調整“後,需重新顯示下層組織明細資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40055 10/05/06 by destiny 单身显示改为dialog
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
 
DEFINE   g_ode1         DYNAMIC ARRAY OF RECORD
                         tqd03_1  LIKE tqd_file.tqd03,
                         tqb02_1  LIKE tqb_file.tqb02,
                         ode05_s  LIKE ode_file.ode05,
                         ode09_s  LIKE ode_file.ode09,   #FUN-640171 modify ode06_s->ode09_s
                         ode07_s  LIKE ode_file.ode07
                        END RECORD
DEFINE   g_ode1_t       RECORD
                         tqd03_1  LIKE tqd_file.tqd03,
                         tqb02_1  LIKE tqb_file.tqb02,
                         ode05_s  LIKE ode_file.ode05,
                         ode09_s  LIKE ode_file.ode09,   #FUN-640171 modify ode06_s->ode09_s
                         ode07_s  LIKE ode_file.ode07
                        END RECORD
DEFINE   g_odd1         DYNAMIC ARRAY OF RECORD
                         odd04    LIKE odd_file.odd04,
                         odd07    LIKE odd_file.odd07,
                         odd09    LIKE odd_file.odd09,
                         ode04    LIKE ode_file.ode04,
                         ode05    LIKE ode_file.ode05,
                         ode09    LIKE ode_file.ode09,   #FUN-640171 modify ode06->ode09
                         ode07    LIKE ode_file.ode07
                        END RECORD
DEFINE   g_odd1_t       RECORD
                         odd04    LIKE odd_file.odd04,
                         odd07    LIKE odd_file.odd07,
                         odd09    LIKE odd_file.odd09,
                         ode04    LIKE ode_file.ode04,
                         ode05    LIKE ode_file.ode05,
                         ode09    LIKE ode_file.ode09,   #FUN-640171 modify ode06->ode09
                         ode07    LIKE ode_file.ode07
                        END RECORD
DEFINE   g_ode2         DYNAMIC ARRAY OF RECORD
                         tqd03_2  LIKE tqd_file.tqd03,
                         tqb02_2  LIKE tqb_file.tqb02,
                         ode05a_s LIKE ode_file.ode05,
                         ode14_s  LIKE ode_file.ode14,   #FUN-640171 modify ode11_s->ode14_s
                         ode12_s  LIKE ode_file.ode12
                        END RECORD
DEFINE   g_ode2_t       RECORD
                         tqd03_2  LIKE tqd_file.tqd03,
                         tqb02_2  LIKE tqb_file.tqb02,
                         ode05a_s LIKE ode_file.ode05,
                         ode14_s  LIKE ode_file.ode14,   #FUN-640171 modify ode11_s->ode14_s
                         ode12_s  LIKE ode_file.ode12
                        END RECORD
DEFINE   g_odd2         DYNAMIC ARRAY OF RECORD
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd09  LIKE odd_file.odd09,
                         ode04  LIKE ode_file.ode04,
                         ode05a LIKE ode_file.ode14,
                         ode14  LIKE ode_file.ode14,     #FUN-640171 modify ode11->ode14
                         ode12  LIKE ode_file.ode12
                        END RECORD
DEFINE   g_odd2_t       RECORD
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd09  LIKE odd_file.odd09,
                         ode04  LIKE ode_file.ode04,
                         ode05a LIKE ode_file.ode14,
                         ode14  LIKE ode_file.ode14,     #FUN-640171 modify ode11->ode14
                         ode12  LIKE ode_file.ode12
                        END RECORD
# -------------------
DEFINE   g_odc          RECORD LIKE odc_file.*,
         g_odc_t        RECORD LIKE odc_file.*,
         g_odc01_t      LIKE odc_file.odc01,
         g_odc02_t      LIKE odc_file.odc02,
         g_tqd03        LIKE tqd_file.tqd03,
         g_wc,g_wc2     STRING,  #No.FUN-580092 HCN
         g_sql          STRING,  #No.FUN-580092 HCN
         g_rec_b        LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_b_flag       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i            LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   l_ac           LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   l_ac1          LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_cnt          LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
   LET g_forupd_sql= " SELECT * FROM odc_file WHERE odc01 = ? AND odc02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i162_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW i162_w AT p_row,p_col WITH FORM "atm/42f/atmi162"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i162_menu()
 
   CLOSE WINDOW i162_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i162_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   LET g_action_choice=" "
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_odc.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
             odc01,odc02,odc04,odc05,odc06,odc07,odc08,odc09,
             odc10,odc11,odc12,odc121,odc13,odc131,
             odcuser,odcgrup,odcmodu,odcdate      #No.TQC-740039
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE WHEN INFIELD(odc01)   #預測版本
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_odb"
                   LET g_qryparam.default1 = g_odc.odc01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc01
                   NEXT FIELD odc01
              WHEN INFIELD(odc02)   #組織代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_tqd03"
                   LET g_qryparam.default1 = g_odc.odc02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc02
                   NEXT FIELD odc02
              WHEN INFIELD(odc07)   #業務員
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_odc.odc07
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc07
                   NEXT FIELD odc07
              WHEN INFIELD(odc08)   #部門
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_odc.odc08
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc08
                   NEXT FIELD odc08
              WHEN INFIELD(odc09)   #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = g_odc.odc09
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odc09
                   NEXT FIELD odc09
              OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION adjust_forecast_qty_detail   #明細預測數量調整
         LET g_b_flag = '1'
 
      ON ACTION adjust_forecast_amt_detail   #明細預測金額調整
         LET g_b_flag = '2'
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION cancel
#        LET g_action_choice="exit"    #No.TQC-6C0217 mark
         LET g_action_choice=" "       #No.TQC-6C0217
         EXIT CONSTRUCT
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT CONSTRUCT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END CONSTRUCT
 
   IF INT_FLAG OR g_action_choice = "exit" THEN    #MOD-4B0238 add 'exit'
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND odcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND odcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND odcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT odc01,odc02 FROM odc_file",
               " WHERE odc12!='X' AND ", g_wc CLIPPED,
               " ORDER BY odc01,odc02"
   PREPARE i162_prepare FROM g_sql
   DECLARE i162_cs SCROLL CURSOR WITH HOLD FOR i162_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM odc_file",
               " WHERE odc12!='X' AND ", g_wc CLIPPED
   PREPARE i162_precount FROM g_sql
   DECLARE i162_count CURSOR FOR i162_precount
END FUNCTION
 
FUNCTION i162_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
         WHEN '1'
            CALL i162_bp1("G")
         WHEN '2'
            CALL i162_bp2("G")
         OTHERWISE
            CALL i162_bp1("G")
      END CASE
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i162_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-A40055--begin
#        #@WHEN "明細查詢"
#        WHEN "query_detail_qty"
#           CALL i162_bp1_1("G")
 
#        #@WHEN "明細查詢"
#        WHEN "query_detail_amt"
#           CALL i162_bp2_1("G")
         #No.FUN-A40055--end
         #@WHEN "明細預測數量調整"
         WHEN "adjust_forecast_qty_detail"
            CALL i162_b1_fill()
            LET g_b_flag = "1"
 
         #@WHEN "明細預測金額調整"
         WHEN "adjust_forecast_amt_detail"
            CALL i162_b2_fill()
            LET g_b_flag = "2"
 
         #@WHEN "上層數量調整"
         WHEN "adjust_upper_qty"
            CALL i162_adjust_qty()
 
         #@WHEN "上層金額調整"
         WHEN "adjust_upper_amt"
            CALL i162_adjust_amt()
 
         #@WHEN "上層調整確認"
         WHEN "confirm_upper_adjust"
            CALL i162_y()
 
         #@WHEN "上層調整取消確認"
         WHEN "undo_confirm_upper_adjust"
            CALL i162_z()
 
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_odc.odc01 IS NOT NULL THEN
                LET g_doc.column1 = "odc01"
                LET g_doc.column2 = "odc02"
                LET g_doc.value1 = g_odc.odc01
                LET g_doc.value2 = g_odc.odc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i162_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_odc.* TO NULL               #No.FUN-6B0043 
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   DISPLAY g_rec_b TO cn3
   DISPLAY g_rec_b TO cn5
   DISPLAY g_rec_b TO cn6
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   DISPLAY '   ' TO FORMONLY.cn4
   CALL i162_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_odc.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN i162_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_odc.* TO NULL
   ELSE
      OPEN i162_count
      FETCH i162_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      DISPLAY g_row_count TO FORMONLY.cn4
      CALL i162_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION i162_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i162_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'P' FETCH PREVIOUS i162_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'F' FETCH FIRST    i162_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'L' FETCH LAST     i162_cs INTO g_odc.odc01,g_odc.odc02
      WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
            
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
            
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump i162_cs INTO g_odc.odc01,g_odc.odc02
         LET mi_no_ask = FALSE   #No.FUN-6A0072
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_ode1.clear()
      CALL g_odd1.clear()
      CALL g_ode2.clear()
      CALL g_odd2.clear()
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_ode1.clear()
      CALL g_odd1.clear()
      CALL g_ode2.clear()
      CALL g_odd2.clear()
#     CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
      RETURN
   END IF
 
   CALL i162_show()
END FUNCTION
 
FUNCTION i162_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_tqb02    LIKE tqb_file.tqb02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_ode14_1  LIKE ode_file.ode14
 
   DISPLAY BY NAME
      g_odc.odc01,g_odc.odc02, g_odc.odc04,g_odc.odc05, g_odc.odc06,
      g_odc.odc07,g_odc.odc08, g_odc.odc09,g_odc.odc10, g_odc.odc11,
      g_odc.odc12,g_odc.odc121,g_odc.odc13,g_odc.odc131,
      g_odc.odcuser,g_odc.odcgrup,g_odc.odcmodu,g_odc.odcdate
 
   #圖形顯示
   CALL cl_set_field_pic(g_odc.odc121,"","","","","")
 
   SELECT odb02 INTO l_odb02 FROM odb_file WHERE odb01=g_odc.odc01
   IF STATUS THEN LET l_odb02 = '' END IF
   DISPLAY l_odb02 TO FORMONLY.odb02
 
   SELECT tqb02 INTO l_tqb02 FROM tqb_file WHERE tqb01=g_odc.odc02
   IF STATUS THEN LET l_tqb02 = '' END IF
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_odc.odc07
   IF STATUS THEN LET l_gen02 = '' END IF
   DISPLAY l_gen02 TO FORMONLY.gen02
 
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_odc.odc08
   IF STATUS THEN LET l_gem02 = '' END IF
   DISPLAY l_gem02 TO FORMONLY.gem02
 
   SELECT SUM(ode14) INTO l_ode14_1 FROM ode_file
    WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
   IF STATUS THEN LET l_ode14_1 = 0 END IF
   DISPLAY l_ode14_1 TO FORMONLY.ode14_1
 
   CALL i162_b1_fill()
   CALL i162_b2_fill()
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i162_adjust_qty()
DEFINE
   l_ac1_t         LIKE type_file.num5,             #No.FUN-680120   SMALLINT           #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用    #No.FUN-680120 SMALLINT
   l_qty           LIKE type_file.num10,            #No.FUN-680120   INTEGER           #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否    #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態      #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否       #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5,                #MOD-5C0031     #No.FUN-680120 SMALLINT
   l_ode10         LIKE ode_file.ode10
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_tqd03
   IF g_odc.odc121='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT ode031,'','',ode04,ode05,ode09,ode07 ",   #FUN-640171 modify ode06->ode09
       "  FROM ode_file ",
       "  WHERE ode01 = ? AND ode02 = ? AND ode031 = ? AND ode04 = ? ",
       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i162_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_odd1 WITHOUT DEFAULTS FROM s_odd1.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
             #CALL fgl_set_arr_curr(l_ac1)
              LET l_ac1 = 1
           END IF
 
       BEFORE ROW
           #No.TQC-6C0217 --start--                                                                                                 
           IF g_odd1[1].odd04 IS NULL THEN                                                                                          
              CALL cl_err('','atm-561',0)                                                                                           
              RETURN                                                                                                                
           END IF                                                                                                                   
           #No.TQC-6C0217 --end--
           LET p_cmd=''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i162_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i162_cl:", STATUS, 1)
              CLOSE i162_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i162_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac1 THEN
              LET g_odd1_t.* = g_odd1[l_ac1].*  #BACKUP
              LET p_cmd='u'
 
              OPEN i162_bc2 USING g_odc.odc01,g_tqd03,g_odd1_t.odd04,g_odd1_t.ode04
              IF STATUS THEN
                 CALL cl_err("OPEN i162_bc2:", STATUS, 1)
                 CLOSE i162_bc2
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i162_bc2 INTO g_odd1[l_ac1].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_odd1_t.ode04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              SELECT DISTINCT odd07,odd09 
                         INTO g_odd1[l_ac1].odd07,g_odd1[l_ac1].odd09
                FROM odd_file
               WHERE odd04=g_odd1[l_ac1].odd04
              DISPLAY g_odd1[l_ac1].odd07 TO odd07
              DISPLAY g_odd1[l_ac1].odd09 TO odd09
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odd1[l_ac1].* = g_odd1_t.*
              CLOSE i162_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odd1[l_ac1].ode04,-263,1)
              LET g_odd1[l_ac1].* = g_odd1_t.*
           ELSE
              SELECT ode10 INTO l_ode10 FROM ode_file
               WHERE ode01=g_odc.odc01 AND ode02=g_tqd03
                 AND ode031=g_odd1_t.odd04 AND ode04=g_odd1_t.ode04
              IF STATUS THEN LET l_ode10 = 0 END IF 
              UPDATE ode_file SET ode07 = g_odd1[l_ac1].ode07,
                                  ode12 = g_odd1[l_ac1].ode07 * l_ode10
               WHERE ode01=g_odc.odc01 AND ode02=g_tqd03
                 AND ode031=g_odd1_t.odd04 AND ode04=g_odd1_t.ode04
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                CALL cl_err(g_odd1[l_ac1].ode04,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","ode_file",g_odc.odc01,g_tqd03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_odd1[l_ac1].* = g_odd1_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 #計算總預測量ode09
                 CALL i162_cal_tot(g_odc.odc01,g_tqd03)
              END IF
           END IF
 
       AFTER ROW
           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           CALL g_odd1.deleteElement(g_rec_b+1) #MOD-490200
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_odd1[l_ac1].* = g_odd1_t.*
              END IF
              CLOSE i162_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i162_bc2
           COMMIT WORK
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
 
   CLOSE i162_bc2
   COMMIT WORK
   CALL i162_show() #MOD-930231
END FUNCTION
 
FUNCTION i162_adjust_amt()
DEFINE
   l_ac1_t         LIKE type_file.num5,             #No.FUN-680120     SMALLINT        #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用     #No.FUN-680120 SMALLINT
   l_qty           LIKE type_file.num10,            #No.FUN-680120     INTEGER            #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否     #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5                 #MOD-5C0031      #No.FUN-680120 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_tqd03
   IF g_odc.odc121='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT ode031,'','',ode04,ode05*ode10,ode14,ode12 ",
       "  FROM ode_file ",
       "  WHERE ode01 = ? AND ode02 = ? AND ode031 = ? AND ode04 = ? ",
       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i162_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_odd2 WITHOUT DEFAULTS FROM s_odd2.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
             #CALL fgl_set_arr_curr(l_ac1)
              LET l_ac1 = 1
           END IF
 
       BEFORE ROW
           #No.TQC-6C0217 --start--                                                                                                 
           IF g_odd2[1].odd04 IS NULL THEN                                                                                          
              CALL cl_err('','atm-562',0)                                                                                           
              RETURN                                                                                                                
           END IF                                                                                                                   
           #No.TQC-6C0217 --end--
           LET p_cmd=''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i162_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i162_cl:", STATUS, 1)
              CLOSE i162_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i162_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b>=l_ac1 THEN
              LET g_odd2_t.* = g_odd2[l_ac1].*  #BACKUP
              LET p_cmd='u'
 
              OPEN i162_bc3 USING g_odc.odc01,g_tqd03,g_odd2_t.odd04,g_odd2_t.ode04
              IF STATUS THEN
                 CALL cl_err("OPEN i162_bc3:", STATUS, 1)
                 CLOSE i162_bc3
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i162_bc3 INTO g_odd2[l_ac1].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_odd2_t.ode04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              SELECT DISTINCT odd07,odd09 
                         INTO g_odd2[l_ac1].odd07,g_odd2[l_ac1].odd09
                FROM odd_file
               WHERE odd04=g_odd2[l_ac1].odd04
              DISPLAY g_odd2[l_ac1].odd07 TO odd07
              DISPLAY g_odd2[l_ac1].odd09 TO odd09
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odd2[l_ac1].* = g_odd2_t.*
              CLOSE i162_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odd2[l_ac1].ode04,-263,1)
              LET g_odd2[l_ac1].* = g_odd2_t.*
           ELSE
              UPDATE ode_file SET ode12 = g_odd2[l_ac1].ode12
               WHERE ode01=g_odc.odc01 AND ode02=g_tqd03
                 AND ode031=g_odd2_t.odd04 AND ode04=g_odd2_t.ode04
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                CALL cl_err(g_odd2[l_ac1].ode04,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("upd","ode_file",g_odc.odc01,g_tqd03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_odd2[l_ac1].* = g_odd2_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 #計算總預測金額ode14
                 CALL i162_cal_tot(g_odc.odc01,g_tqd03)
              END IF
           END IF
 
       AFTER ROW
           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           CALL g_odd2.deleteElement(g_rec_b+1) #MOD-490200
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_odd2[l_ac1].* = g_odd2_t.*
              END IF
              CLOSE i162_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i162_bc3
           COMMIT WORK
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
 
   CLOSE i162_bc3
   COMMIT WORK
   CALL i162_show() #MOD-930231
END FUNCTION
 
FUNCTION i162_b1_fill()
 
   DECLARE i162_1_c1 CURSOR FOR
      SELECT tqd03,tqb02,SUM(ode05),SUM(ode09),SUM(ode07)   #FUN-640171 modify ode06->ode09
        FROM ode_file,tqd_file,tqb_file
       WHERE ode01 = g_odc.odc01 AND tqd01 = g_odc.odc02
         AND ode02 = tqd03 AND tqd03 = tqb01
       GROUP BY tqd03,tqb02
       ORDER BY tqd03
 
   CALL g_ode1.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH i162_1_c1 INTO g_ode1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_ode1[g_cnt].ode05_s) THEN
         LET g_ode1[g_cnt].ode05_s = 0
      END IF
      IF cl_null(g_ode1[g_cnt].ode09_s) THEN   #FUN-640171 modify ode06_s->ode09_s
         LET g_ode1[g_cnt].ode09_s = 0         #FUN-640171 modify ode06_s->ode09_s
      END IF
      IF cl_null(g_ode1[g_cnt].ode07_s) THEN
         LET g_ode1[g_cnt].ode07_s = 0
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_ode1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
   LET g_cnt = 1
   CALL i162_b1_fill_1(g_ode1[g_cnt].tqd03_1)
 
END FUNCTION
 
FUNCTION i162_b1_fill_1(l_tqd03)
   DEFINE l_tqd03  LIKE tqd_file.tqd03
 
   DECLARE i162_1_c2 CURSOR FOR
      SELECT odd04,odd07,odd09,ode04,ode05,ode09,ode07    #FUN-640171 modify ode06->ode09
        FROM odd_file,ode_file
       WHERE odd01 = g_odc.odc01 AND odd02 = l_tqd03
         AND odd01 = ode01 AND odd02 = ode02 AND odd03 = ode03
       ORDER BY odd04,ode04
 
   CALL g_odd1.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH i162_1_c2 INTO g_odd1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_odd1[g_cnt].ode05) THEN
         LET g_odd1[g_cnt].ode05 = 0
      END IF
      IF cl_null(g_odd1[g_cnt].ode09) THEN   #FUN-640171 modify ode06->ode09
         LET g_odd1[g_cnt].ode09 = 0         #FUN-640171 modify ode06->ode09
      END IF
      IF cl_null(g_odd1[g_cnt].ode07) THEN
         LET g_odd1[g_cnt].ode07 = 0
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odd1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn3
 
END FUNCTION
 
FUNCTION i162_b2_fill()
 
   DECLARE i162_2_c1 CURSOR FOR
      SELECT tqd03,tqb02,SUM(ode05*ode10),SUM(ode14),SUM(ode12)   #FUN-640171 modify ode11->ode14
        FROM ode_file,tqd_file,tqb_file
       WHERE ode01 = g_odc.odc01 AND tqd01 = g_odc.odc02
         AND ode02 = tqd03 AND tqd03 = tqb01
       GROUP BY tqd03,tqb02
       ORDER BY tqd03
 
   CALL g_ode2.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH i162_2_c1 INTO g_ode2[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_ode2[g_cnt].ode05a_s) THEN
         LET g_ode2[g_cnt].ode05a_s = 0
      END IF
      IF cl_null(g_ode2[g_cnt].ode14_s) THEN   #FUN-640171 modify ode11->ode14
         LET g_ode2[g_cnt].ode14_s = 0         #FUN-640171 modify ode11->ode14
      END IF
      IF cl_null(g_ode2[g_cnt].ode12_s) THEN
         LET g_ode2[g_cnt].ode12_s = 0
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_ode2.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn5
 
   LET g_cnt = 1
   CALL i162_b2_fill_1(g_ode2[g_cnt].tqd03_2)
 
END FUNCTION
 
FUNCTION i162_b2_fill_1(l_tqd03)
   DEFINE l_tqd03  LIKE tqd_file.tqd03
 
   DECLARE i162_2_c2 CURSOR FOR
      SELECT odd04,odd07,odd09,ode04,ode05*ode10,ode14,ode12   #FUN-640171 modify ode11->ode14
        FROM odd_file,ode_file
       WHERE odd01 = g_odc.odc01 AND odd02 = l_tqd03
         AND odd01 = ode01 AND odd02 = ode02 AND odd03 = ode03
       ORDER BY odd04,ode04
 
   CALL g_odd2.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH i162_2_c2 INTO g_odd2[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_odd2[g_cnt].ode05a) THEN
         LET g_odd2[g_cnt].ode05a = 0
      END IF
      IF cl_null(g_odd2[g_cnt].ode14) THEN   #FUN-640171 modify ode11->ode14
         LET g_odd2[g_cnt].ode14 = 0         #FUN-640171 modify ode11->ode14
      END IF
      IF cl_null(g_odd2[g_cnt].ode12) THEN
         LET g_odd2[g_cnt].ode12 = 0
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odd2.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn6
 
END FUNCTION
 
FUNCTION i162_bp1_refresh()
  DISPLAY ARRAY g_odd1 TO s_odd1.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i162_bp2_refresh()
  DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i162_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)                                    #NO.FUN-A40055
   DISPLAY ARRAY g_ode1 TO s_ode1.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            CALL i162_b1_fill_1(g_ode1[l_ac].tqd03_1)
#            CALL i162_bp1_refresh()                                 #NO.FUN-A40055
         END IF
    END DISPLAY 
    DISPLAY ARRAY g_odd1 TO s_odd1.* ATTRIBUTE(COUNT = g_rec_b)      #NO.FUN-A40055
    END DISPLAY                                                      #NO.FUN-A40055
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
     #TQC-750069..............begin
     #ON ACTION detail
     #   LET g_action_choice="detail"
     #   LET l_ac = 1
     #   EXIT DIALOG
     #TQC-750069..............end
 
      ON ACTION first
         CALL i162_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL i162_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL i162_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL i162_fetch('N')
         EXIT DIALOG
 
      ON ACTION last
         CALL i162_fetch('L')
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc121,"","","","","")
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
      #No.FUN-A40055--begin 
      #@WHEN "明細查詢"
#      ON ACTION query_detail_qty
#         LET g_action_choice="query_detail_qty"
#         EXIT DIALOG
     
      #@WHEN "明細預測數量調整"
      ON ACTION adjust_forecast_qty_detail
         LET g_action_choice="adjust_forecast_qty_detail"
         EXIT DIALOG
 
      #@WHEN "明細預測金額調整"
      ON ACTION adjust_forecast_amt_detail
         LET g_action_choice="adjust_forecast_amt_detail"
         EXIT DIALOG
 
      #@WHEN "上層數量調整"
      ON ACTION adjust_upper_qty
         LET g_action_choice="adjust_upper_qty"
         LET g_tqd03 = g_ode1[l_ac].tqd03_1     #No.TQC-6C0217 mark
#        LET g_tqd03 = g_ode1[1].tqd03_1        #No.TQC-6C0217
         EXIT DIALOG
 
      #@WHEN "上層調整確認"
      ON ACTION confirm_upper_adjust
         LET g_action_choice="confirm_upper_adjust"
         EXIT DIALOG
 
      #@WHEN "上層調整取消確認"
      ON ACTION undo_confirm_upper_adjust
         LET g_action_choice="undo_confirm_upper_adjust"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
#   END DISPLAY                                           #NO.FUN-A40055
   END DIALOG                                             #NO.FUN-A40055
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i162_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)                              #NO.FUN-A40055
   DISPLAY ARRAY g_ode2 TO s_ode2.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            CALL i162_b2_fill_1(g_ode2[l_ac].tqd03_2)
#            CALL i162_bp2_refresh()                           #NO.FUN-A40055
         END IF
   END DISPLAY                                                 #NO.FUN-A40055
   DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT = g_rec_b) #NO.FUN-A40055
   END DISPLAY                                                 #NO.FUN-A40055
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      #TQC-750069.............begin
     #ON ACTION detail
     #   LET g_action_choice="detail"
     #   LET l_ac = 1
     #   EXIT DIALOG
      #TQC-750069.............end
 
      ON ACTION first
         CALL i162_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL i162_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL i162_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL i162_fetch('N')
         EXIT DIALOG
 
      ON ACTION last
         CALL i162_fetch('L')
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc121,"","","","","")
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
      #No.FUN-A40055--begin
      #@WHEN "明細查詢"
#     ON ACTION query_detail_amt
#        LET g_action_choice="query_detail_amt"
#        EXIT DIALOG
      #No.FUN-A40055--end 
      #@WHEN "明細預測數量調整"
      ON ACTION adjust_forecast_qty_detail
         LET g_action_choice="adjust_forecast_qty_detail"
         EXIT DIALOG
 
      #@WHEN "明細預測金額調整"
      ON ACTION adjust_forecast_amt_detail
         LET g_action_choice="adjust_forecast_amt_detail"
         EXIT DIALOG
 
      #@WHEN "上層金額調整"
      ON ACTION adjust_upper_amt
         LET g_action_choice="adjust_upper_amt"
         LET g_tqd03 = g_ode2[l_ac].tqd03_2      #No.TQC-6C0217 mark
#        LET g_tqd03 = g_ode2[1].tqd03_2         #No.TQC-6C0217
         EXIT DIALOG
 
      #@WHEN "上層調整確認"
      ON ACTION confirm_upper_adjust
         LET g_action_choice="confirm_upper_adjust"
         EXIT DIALOG
 
      #@WHEN "上層調整取消確認"
      ON ACTION undo_confirm_upper_adjust
         LET g_action_choice="undo_confirm_upper_adjust"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
#  END DISPLAY                                  #NO.FUN-A40055   
   END DIALOG                                   #NO.FUN-A40055
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i162_bp1_1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept", FALSE)
   DISPLAY ARRAY g_odd1 TO s_odd1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc121,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   END DISPLAY
 
   LET g_action_choice = " "
   IF INT_FLAG THEN LET INT_FLAG = FALSE END IF
   CALL cl_set_act_visible("accept", TRUE)
 
END FUNCTION
 
FUNCTION i162_bp2_1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept", FALSE)
   DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc121,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   END DISPLAY
 
   LET g_action_choice = " "
   IF INT_FLAG THEN LET INT_FLAG = FALSE END IF
   CALL cl_set_act_visible("accept", TRUE)
 
END FUNCTION
 
FUNCTION i162_y()
   DEFINE l_odc02      LIKE odc_file.odc02,
          l_odc12      LIKE odc_file.odc12,
          l_odc121     LIKE odc_file.odc121,
          l_tqd03      LIKE tqd_file.tqd03
   DEFINE l_n          LIKE type_file.num5     #No.TQC-740039
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   #當下層的預測確認碼皆為Y、調整確認碼皆為N時,才可做調整確認
   DECLARE i162_y_c1 CURSOR FOR
      SELECT odc02,odc12,odc121 FROM odc_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN 
           (SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
 
   LET g_success = 'Y'
   LET l_n = 0      #No.TQC-740039
   FOREACH i162_y_c1 INTO l_odc02,l_odc12,l_odc121
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_n = l_n + 1      #No.TQC-740039
      #檢查有無單身資料odd_file
      SELECT COUNT(*) INTO g_cnt FROM odd_file
       WHERE odd01 = g_odc.odc01 AND odd02 = l_odc02
      IF g_cnt = 0 THEN
         CALL cl_err('','arm-034',1) 
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
      #檢查預測確認碼odc12
      IF l_odc12  = 'N' THEN
         #尚有未執行預測確認之下層組織,請先執行下層組織之預測確認!
         CALL cl_err('','atm-552',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
      #檢查調整確認碼odc121
      IF l_odc121 = 'Y' THEN
         #此筆資料已確認
         CALL cl_err('','9023',1)   #FUN-680047 add
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
   END FOREACH   
   IF l_n = 0 THEN CALL cl_err(g_odc.odc02,'atm-320',1) RETURN END IF      #No.TQC-740039
   IF g_success = 'N' THEN RETURN END IF
 
   IF cl_confirm('axm-108') THEN
      MESSAGE "WORKING !"
      BEGIN WORK
 
      OPEN i162_cl USING g_odc.odc01,g_odc.odc02
      FETCH i162_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i162_cl ROLLBACK WORK RETURN
      END IF
 
      IF g_success = 'Y' THEN
         DECLARE i162_y_c2 CURSOR FOR
            SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01
         FOREACH i162_y_c2 INTO l_tqd03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE odc_file SET odc121='Y'
             WHERE odc01=g_odc.odc01 AND odc02=l_tqd03
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,l_tqd03,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
               EXIT FOREACH      #No.TQC-6C0217
            END IF
         END FOREACH
      END IF
 
   #- MOD-930231 Add
      #檢查若為最上層(不存在tqd03)則更新 odc121 
      SELECT COUNT(*) INTO g_cnt FROM tqd_file
       WHERE tqd03 = g_odc.odc02
      IF g_cnt = 0 THEN
         UPDATE odc_file SET odc121='Y'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
   #- MOD-930231 End
 
      CLOSE i162_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
   END IF
   CALL i162_upd_lower()   #計算下層量
 
   #- MOD-930231 Add
   SELECT * INTO g_odc.* 
     FROM odc_file 
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02  
 
   CALL i162_show() 
   #- MOD-930231 End
 
END FUNCTION
 
FUNCTION i162_z()
   DEFINE l_odc121     LIKE odc_file.odc121,
          l_tqd03      LIKE tqd_file.tqd03
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   #當下層的調整確認碼皆為Y時,才可做取消調整確認
   DECLARE i162_z_c1 CURSOR FOR
      SELECT odc121 FROM odc_file
       WHERE odc01 = g_odc.odc01
         AND odc02 IN 
           (SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
 
   LET g_success = 'Y'
   FOREACH i162_z_c1 INTO l_odc121
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #檢查調整確認碼odc121
      IF l_odc121 = 'N' THEN
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
   END FOREACH   
   IF g_success = 'N' THEN 
      #尚未執行過上層調整確認,不可取消確認!
      CALL cl_err('','atm-553',1)   #FUN-680047 add
      RETURN 
   END IF
 
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      BEGIN WORK
 
      OPEN i162_cl USING g_odc.odc01,g_odc.odc02
      FETCH i162_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i162_cl ROLLBACK WORK RETURN
      END IF
 
      IF g_success = 'Y' THEN
         DECLARE i162_z_c2 CURSOR FOR
            SELECT tqd03 FROM odc_file,tqd_file
             WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01
         FOREACH i162_z_c2 INTO l_tqd03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE odc_file SET odc121='N'
             WHERE odc01=g_odc.odc01 AND odc02=l_tqd03
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
               CALL cl_err3("upd","odc_file",g_odc.odc01,l_tqd03,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
               LET g_success='N'
            END IF
         END FOREACH
      END IF
 
   #- MOD-930231 Add
      #檢查若為最上層(不存在tqd03)則更新 odc121 
      SELECT COUNT(*) INTO g_cnt FROM tqd_file
       WHERE tqd03 = g_odc.odc02
      IF g_cnt = 0 THEN
         UPDATE odc_file SET odc121='N'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
   #- MOD-930231 End
 
      CLOSE i162_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      #將下層量清為0
      UPDATE ode_file SET ode071=0,ode121=0
       WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ode_file',SQLCA.SQLCODE,0)  #No.FUN-660104
         CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd ode_file",1)  #No.FUN-660104
         RETURN
      END IF
      CALL i162_cal_tot(g_odc.odc01,g_odc.odc02)
   END IF
 
   #- MOD-930231 Add
   SELECT * INTO g_odc.* 
     FROM odc_file 
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02  
 
   CALL i162_show() 
   #- MOD-930231 End
 
END FUNCTION
 
#計算下層量
FUNCTION i162_upd_lower()
   DEFINE l_ode03      LIKE ode_file.ode03,
          l_ode04      LIKE ode_file.ode04,
          l_ode071     LIKE ode_file.ode071,
          l_ode121     LIKE ode_file.ode121
 
   DECLARE i162_y_c3 CURSOR FOR
      SELECT ode03,ode04,SUM(ode09),SUM(ode14) FROM ode_file
       WHERE ode01=g_odc.odc01
         AND ode02 IN (SELECT tqd03 FROM odc_file,tqd_file
                        WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
       GROUP BY ode03,ode04
   FOREACH i162_y_c3 INTO l_ode03,l_ode04,l_ode071,l_ode121
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_ode071) THEN LET l_ode071 = 0 END IF
      IF cl_null(l_ode121) THEN LET l_ode121 = 0 END IF
      UPDATE ode_file SET ode071=l_ode071,ode121=l_ode121
       WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02 
         AND ode03=l_ode03 AND ode04=l_ode04
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ode_file',SQLCA.SQLCODE,0)  #No.FUN-660104
         CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd ode_file",1)  #No.FUN-660104
         RETURN
      END IF
      CALL i162_cal_tot(g_odc.odc01,g_odc.odc02)
   END FOREACH
 
END FUNCTION
 
#計算總預測量ode09,總預測金額ode14
FUNCTION i162_cal_tot(l_ode01,l_ode02)
   DEFINE l_ode01   LIKE ode_file.ode01,
          l_ode02   LIKE ode_file.ode02,
          l_ode03   LIKE ode_file.ode03,
          l_ode04   LIKE ode_file.ode04,
          l_ode09   LIKE ode_file.ode09,
          l_ode14   LIKE ode_file.ode14
 
   DECLARE i162_cal_c1 CURSOR FOR
      SELECT ode03,ode04,SUM(ode06+ode07+ode071+ode08),SUM(ode11+ode12+ode121+ode13)
        FROM ode_file
       WHERE ode01=l_ode01 AND ode02=l_ode02
       GROUP BY ode03,ode04
   FOREACH i162_cal_c1 INTO l_ode03,l_ode04,l_ode09,l_ode14
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_ode09) THEN LET l_ode09 = 0 END IF
      IF cl_null(l_ode14) THEN LET l_ode14 = 0 END IF
      UPDATE ode_file SET ode09 = l_ode09 , ode14 = l_ode14
       WHERE ode01=l_ode01 AND ode02=l_ode02 
         AND ode03=l_ode03 AND ode04=l_ode04
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(l_ode04,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","ode_file",l_ode01,l_ode02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         RETURN
      END IF
   END FOREACH
END FUNCTION
