# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct310.4gl
# Descriptions...: 每月人工製費維護作業
# Date & Author..: 01/11/09 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.MOD-640319 06/04/10 By Sarah 按更改後,說明會不見
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670037 06/07/13 By Sarah 修改完單身的金額後,沒有重算單位成本cae07
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6A0072 06/11/10 By Sarah 分類、分攤方式DEFINE的太小，導致顯示不出來
# Modify.........: No.FUN-710027 07/02/01 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740120 07/04/17 By Sarah 1.PROMPT訊息沒照規範寫
#                                                  2.單身分攤方式(cae08)改成COMBOBOX
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830135 08/03/31 By douzh 成本改善問題調整
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.FUN-910031 09/01/14 By kim 十號公報 for 重複性生產
# Modify.........: No.CHI-930044 09/03/24 By kim 十號公報 for 重複性生產
# Modify.........: No.CHI-940027 09/04/22 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/20 By jan 1.拿掉caa_cur2相關程式段 2.caa04-->ca4041
# Modify.........: No.CHI-980022 09/08/20 By jan insert into cae_file時補上cae041的處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980031 09/11/11 By jan 分攤方式新增選項，并可QBE
# Modify.........: No.TQC-9C0077 09/12/11 By Carrier oriu/orig等值赋值
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模组table重新分类
# Modify.........: No:FUN-D40030 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題											
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cae01         LIKE cae_file.cae01,
    g_cae01_t       LIKE cae_file.cae01,
    g_cae02         LIKE cae_file.cae02,
    g_cae02_t       LIKE cae_file.cae02,
    g_cae           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
               cae03 LIKE cae_file.cae03,  #成本中心
               cae04 LIKE cae_file.cae04,  #成本項目
               cab02 LIKE cab_file.cab02,  #說明
               cae041  LIKE cae_file.cae041,       #No.CHI-940027
               cae08   LIKE cae_file.cae08,
               cae05 LIKE cae_file.cae05,
               cae06 LIKE cae_file.cae06,
               cae07 LIKE cae_file.cae07,
               cae09 LIKE cae_file.cae09,   #FUN-910031
               cae10 LIKE cae_file.cae10,   #FUN-910031
               cae11 LIKE cae_file.cae11    #FUN-910031
                    END RECORD,
    g_cae_t         RECORD                 #程式變數 (舊值)
               cae03 LIKE cae_file.cae03,  #成本中心
               cae04 LIKE cae_file.cae04,  #成本項目
               cab02 LIKE cab_file.cab02,  #說明
               cae041  LIKE cae_file.cae041,       #No.CHI-940027
               cae08   LIKE cae_file.cae08,
               cae05 LIKE cae_file.cae05,
               cae06 LIKE cae_file.cae06,
               cae07 LIKE cae_file.cae07,
               cae09 LIKE cae_file.cae09,   #FUN-910031
               cae10 LIKE cae_file.cae10,   #FUN-910031
               cae11 LIKE cae_file.cae11    #FUN-910031
                    END RECORD,
     g_wc2,g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680122CHAR(80)
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW t310_w AT p_row,p_col WITH FORM "axc/42f/axct310"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("info",FALSE)
 
    CALL t310_menu()
 
    CLOSE WINDOW t310_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION t310_menu()
 
   WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t310_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t310_b()
            END IF
         WHEN "previous"
            CALL t310_fetch('P')
         WHEN "next"
            CALL t310_fetch('N')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "成本項目產生"
         WHEN "gen_cost_item"
            IF cl_chk_act_auth() THEN
               CALL t310_gen()
            END IF
       #@WHEN "修改"
         WHEN "update"
            IF cl_chk_act_auth() THEN
               CALL t310_b()
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
	    CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cae),'','')
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_cae01 IS NOT NULL THEN
                LET g_doc.column1 = "cae01"
                LET g_doc.column2 = "cae02"
                LET g_doc.value1 = g_cae01
                LET g_doc.value2 = g_cae02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t310_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_cae.clear()
    LET g_cae01_t = NULL
    LET g_cae02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cae01 = NULL
        LET g_cae02 = NULL
        CALL t310_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            RETURN
        END IF
        IF g_cae01 IS NULL OR g_cae02 IS NULL THEN   #KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL g_cae.clear()
        LET g_rec_b = 0
        CALL t310_b()                   #輸入單身
        IF INT_FLAG THEN                   #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           RETURN
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t310_i(p_cmd)
   DEFINE
        p_cmd               LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag              LIKE type_file.chr1,                    #判斷必要欄位是否輸入        #No.FUN-680122 VARCHAR(1)
        l_msg1,l_msg2       LIKE type_file.chr1000,       #No.FUN-680122CHAR(70)
        l_oba02    LIKE oba_file.oba02,
        l_n                 LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    CALL cl_set_head_visible("","YES")            #No.FUN-6A0092 
    INPUT g_cae01,g_cae02 WITHOUT DEFAULTS
        FROM cae01,cae02
 
        AFTER FIELD cae02
          IF NOT cl_null(g_cae02) THEN
              IF g_cae02  <1 OR g_cae02 > 12 THEN NEXT FIELD cae02 END IF
          END IF
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
               CLEAR FORM
               CALL g_cae.clear()
               EXIT INPUT
            END IF
            IF g_cae01 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_cae01
            END IF
            IF g_cae02 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_cae02
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
    END INPUT
END FUNCTION
 
 
FUNCTION t310_q()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE l_cae01 LIKE cae_file.cae01
  DEFINE l_cae02 LIKE cae_file.cae02
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE  ""
    CLEAR FORM
    CALL g_cae.clear()
    CALL cl_set_head_visible("","YES")            #No.FUN-6A0092 
    CONSTRUCT BY NAME g_wc ON cae01,cae02
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('caeuser', 'caegrup') #FUN-980030
    IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF
 
    CONSTRUCT g_wc2 ON cae03,cae04,cae041,cae08,cae05,cae06,cae07,     #No.CHI-940027 add cae041#FUN-980031 add cae08
                       cae09,cae10,cae11   #FUN-910031
            FROM s_cae[1].cae03,s_cae[1].cae04,s_cae[1].cae041,  #No.CHI-940027 add cae041
                 s_cae[1].cae08,  #FUN-980031
                 s_cae[1].cae05,s_cae[1].cae06,s_cae[1].cae07,
                 s_cae[1].cae09,s_cae[1].cae10,s_cae[1].cae11  #FUN-910031
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION CONTROLP
           CASE
             WHEN INFIELD(cae04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_cab"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cae04
                   NEXT FIELD cae04
             EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cae01,cae02 FROM cae_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cae01,cae02 ",
                   "  FROM cae_file ",
                   "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t310_prepare FROM g_sql
    DECLARE t310_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t310_prepare
 
    DROP TABLE x   #TQC-740120 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT UNIQUE cae01,cae02 FROM cae_file WHERE ",g_wc CLIPPED,
                  " INTO TEMP x"
    ELSE
        LET g_sql="SELECT UNIQUE cae01,cae02 FROM cae_file WHERE ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " INTO TEMP x"
    END IF
    PREPARE t310_precount_x FROM g_sql
    EXECUTE t310_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t310_precount FROM g_sql
    DECLARE t310_count CURSOR FOR t310_precount
 
 
    MESSAGE "Searching !"
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_cae01 = NULL
        LET g_cae02 = NULL
    ELSE
        OPEN t310_count
        FETCH t310_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
        MESSAGE " "
    END IF
END FUNCTION
 
 
FUNCTION t310_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t310_cs INTO g_cae01,g_cae02
        WHEN 'P' FETCH PREVIOUS t310_cs INTO g_cae01,g_cae02
        WHEN 'F' FETCH FIRST    t310_cs INTO g_cae01,g_cae02
        WHEN 'L' FETCH LAST     t310_cs INTO g_cae01,g_cae02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t310_cs INTO g_cae01,g_cae02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cae01 TO NULL  #TQC-6B0105
        INITIALIZE g_cae02 TO NULL  #TQC-6B0105
    ELSE
        CALL t310_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t310_show()
    DISPLAY g_cae01 TO cae01
    DISPLAY g_cae02 TO cae02
    CALL t310_b_fill(g_cae01,g_cae02)                 #單身
    CALL t310_tot()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t310_tot()
  DEFINE l_cae  RECORD LIKE cae_file.*,
         p_ltot  LIKE cae_file.cae05,
         p_otot1 LIKE cae_file.cae05,
         p_otot2 LIKE cae_file.cae05,   #No.CHI-940027
         p_otot3 LIKE cae_file.cae05,   #No.CHI-940027
         p_otot4 LIKE cae_file.cae05,   #No.CHI-940027
         p_otot5 LIKE cae_file.cae05,   #No.CHI-940027
         l_sql   LIKE type_file.chr1000       #No.FUN-680122CHAR(300)
 
 
  DECLARE cae_cur CURSOR FOR
   SELECT * FROM cae_file
    WHERE cae01=g_cae01 AND cae02=g_cae02
  IF STATUS THEN 
   CALL cl_err('cae_cur',STATUS,1)       
  END IF
  LET p_ltot=0 
  LET p_otot1=0
  LET p_otot2=0
  LET p_otot3=0
  LET p_otot4=0
  LET p_otot5=0
  FOREACH cae_cur INTO l_cae.*
   IF STATUS THEN CALL cl_err('cae_for',STATUS,1) EXIT FOREACH END IF
   CASE l_cae.cae041   #CHI-970021 l_caa04-->l_cae.cae041
     WHEN '1' LET p_ltot=p_ltot+l_cae.cae05 #人工
     WHEN '2' LET p_otot1=p_otot1+l_cae.cae05 #製費1
     WHEN '3' LET p_otot2=p_otot2+l_cae.cae05 #製費2
     WHEN '4' LET p_otot3=p_otot3+l_cae.cae05 #製費3
     WHEN '5' LET p_otot4=p_otot4+l_cae.cae05 #製費4
     WHEN '6' LET p_otot5=p_otot5+l_cae.cae05 #製費5
   END CASE
  END FOREACH
  IF p_ltot IS NULL THEN LET p_ltot=0 END IF
  IF p_otot1 IS NULL THEN LET p_otot1=0 END IF
  IF p_otot2 IS NULL THEN LET p_otot2=0 END IF
  IF p_otot3 IS NULL THEN LET p_otot3=0 END IF
  IF p_otot4 IS NULL THEN LET p_otot4=0 END IF
  IF p_otot5 IS NULL THEN LET p_otot5=0 END IF
  DISPLAY p_ltot TO FORMONLY.ltot
  DISPLAY p_otot1 TO FORMONLY.otot1
  DISPLAY p_otot2 TO FORMONLY.otot2
  DISPLAY p_otot3 TO FORMONLY.otot3
  DISPLAY p_otot4 TO FORMONLY.otot4
  DISPLAY p_otot5 TO FORMONLY.otot5
END FUNCTION
 
FUNCTION t310_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680122 VARCHAR(1)
    l_possible      LIKE type_file.num5,          #No.FUN-680122SMALLINT #用來設定判斷重複的可能性
    l_ltot          LIKE cae_file.cae05,
    l_otot          LIKE cae_file.cae05,
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_cae01) OR g_cae01 = 0 THEN   #FUN-980031
       CALL cl_err('',-400,0)      #FUN-980031
       RETURN                      #FUN-980031
    END IF                         #FUN-980031
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT cae03,cae04,'',cae041,cae08,cae05,cae06,cae07, ",     #TQC-740120  #No.CHI-940027 add cae041
        "       cae09,cae10,cae11 ",                              #FUN-910031 
        "  FROM cae_file ",
        "  WHERE cae01= ? ",
        "   AND cae02= ? ",
        "   AND cae03= ? ",
        "   AND cae04= ? ",
        "   AND cae08= ? ",
        "   AND cae041 =? ",              #NO.CHI-940027
        " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cae WITHOUT DEFAULTS FROM s_cae.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_cae_t.* = g_cae[l_ac].*  #BACKUP
               BEGIN WORK
 
               OPEN t310_bcl USING g_cae01,g_cae02,g_cae_t.cae03,g_cae_t.cae04,g_cae_t.cae08,g_cae_t.cae041   #No.CHI-940027
               IF STATUS THEN
                   CALL cl_err("OPEN t310_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH t310_bcl INTO g_cae[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cae_t.cae03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT cab02 INTO g_cae[l_ac].cab02 FROM cab_file
                    WHERE cab01=g_cae[l_ac].cae04
                   IF STATUS THEN
                      LET g_cae[l_ac].cab02 = ''
                   END IF
                   CALL t310_cae04(g_cae[l_ac].cae03,g_cae[l_ac].cae04)
                         RETURNING g_cae[l_ac].cab02   #NO.CHI-940027
                   LET g_before_input_done = FALSE
                   CALL t310_set_entry_b(p_cmd)
                   CALL t310_set_no_entry_b(p_cmd)
                   LET g_before_input_done = TRUE
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_cae[l_ac].cae05) THEN
               LET g_cae[l_ac].cae05=0
            END IF
            IF cl_null(g_cae[l_ac].cae06) THEN
               LET g_cae[l_ac].cae06=0
            END IF
            IF cl_null(g_cae[l_ac].cae07) THEN
               LET g_cae[l_ac].cae07=0
            END IF
            INSERT INTO cae_file(cae01,cae02,cae03,cae04,cae041,cae05,      #No.CHI-940027  add cae041
                                 cae06,cae07,cae08,
                                 cae09,cae10,cae11,caeuser,caegrup,caedate,caeoriu,caeorig,caelegal)   #FUN-910031    #No.FUN=9C0077   #FUN-A50075 add legal
                   VALUES(g_cae01,g_cae02,g_cae[l_ac].cae03,
                   g_cae[l_ac].cae04,g_cae[l_ac].cae041,g_cae[l_ac].cae05,  #No.CHI-940027  add cae041
                   g_cae[l_ac].cae06,g_cae[l_ac].cae07,g_cae[l_ac].cae08,
                   g_cae[l_ac].cae09,g_cae[l_ac].cae10,g_cae[l_ac].cae11,
                   g_user,g_grup,g_today,g_user,g_grup,g_legal) #FUN-910031  #No.FUN=9C0077   #FUN-A50075 add legal
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cae_file",g_cae01,g_cae02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cae[l_ac].* TO NULL
            LET g_cae_t.* = g_cae[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cae03
        BEFORE FIELD cae03
            CALL t310_set_entry_b(p_cmd)
        AFTER FIELD cae03
            CALL t310_set_no_entry_b(p_cmd)
 
        #check 須存在成本項目分攤設定檔(caa_file)
        AFTER FIELD cae04
            IF NOT cl_null(g_cae[l_ac].cae04) THEN
                SELECT COUNT(*) INTO g_cnt FROM cab_file
                 WHERE cab01=g_cae[l_ac].cae04
               IF g_cnt=0 THEN
                  LET INT_FLAG = 0  ######add for prompt bug
                  CALL cl_getmsg('mfg1313',g_lang) RETURNING g_msg
                  PROMPT g_msg CLIPPED FOR g_chr
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
 
                     ON ACTION about         #MOD-4C0121
                        CALL cl_about()      #MOD-4C0121
 
                     ON ACTION help          #MOD-4C0121
                        CALL cl_show_help()  #MOD-4C0121
 
                     ON ACTION controlg      #MOD-4C0121
                        CALL cl_cmdask()     #MOD-4C0121
 
                  END PROMPT
                  NEXT FIELD cae04
               END IF
               CALL t310_cae04(g_cae[l_ac].cae03,g_cae[l_ac].cae04)
                    RETURNING g_cae[l_ac].cab02  #NO.CHI-940027
           END IF
 
        AFTER FIELD cae05
           IF g_cae[l_ac].cae05 != g_cae_t.cae05 THEN
              LET g_cae[l_ac].cae07 = g_cae[l_ac].cae05 / g_cae[l_ac].cae06
              DISPLAY BY NAME g_cae[l_ac].cae05,g_cae[l_ac].cae07
           END IF
        
        AFTER FIELD cae041
            IF g_cae[l_ac].cae041 NOT MATCHES '[123456]' THEN  
               NEXT FIELD cae041
            END IF 
            IF (g_cae[l_ac].cae04 !=g_cae_t.cae04 OR
                   g_cae[l_ac].cae03 !=g_cae_t.cae03) OR
                 (g_cae[l_ac].cae03 IS NOT NULL AND g_cae_t.cae03 IS NULL)
                  OR (g_cae[l_ac].cae04 IS NOT NULL AND g_cae_t.cae04 IS NULL) 
                  OR (g_cae[l_ac].cae041 IS NOT NULL AND g_cae_t.cae041 IS NULL)THEN 
                   SELECT count(*) INTO l_n FROM cae_file
                    WHERE cae01 = g_cae01
                      AND cae02 = g_cae02
                      AND cae03 = g_cae[l_ac].cae03
                      AND cae04 = g_cae[l_ac].cae04
                      AND cae041 = g_cae[l_ac].cae041   
                   IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_cae[l_ac].cae03 = g_cae_t.cae03
                     LET g_cae[l_ac].cae04 = g_cae_t.cae04
                     LET g_cae[l_ac].cae041 = g_cae_t.cae041
                     NEXT FIELD cae03
                   END IF
               END IF   
        
        AFTER FIELD cae08
           IF NOT cl_null(g_cae[l_ac].cae08) THEN
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_cae_t.cae03 IS NOT NULL AND g_cae_t.cae04 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM cae_file WHERE cae01=g_cae01
                  AND cae02 = g_cae02
                  AND cae03 = g_cae_t.cae03
                  AND cae04 = g_cae_t.cae04
                  AND cae041 = g_cae_t.cae041       #NO.CHI-940027
                IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","cae_file",g_cae01,g_cae02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                     
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cae[l_ac].* = g_cae_t.*
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_cae[l_ac].cae03,-263,1)
                LET g_cae[l_ac].* = g_cae_t.*
            ELSE
                UPDATE cae_file SET cae03 = g_cae[l_ac].cae03,
                                    cae04 = g_cae[l_ac].cae04,
                                    cae041 = g_cae[l_ac].cae041,   #No.CHI-940027
                                    cae05 = g_cae[l_ac].cae05,
                                    cae06 = g_cae[l_ac].cae06,
                                    cae07 = g_cae[l_ac].cae07,
                                    cae08 = g_cae[l_ac].cae08,
                                    cae09 = g_cae[l_ac].cae09, #FUN-910031
                                    cae10 = g_cae[l_ac].cae10, #FUN-910031
                                    cae11 = g_cae[l_ac].cae11, #FUN-910031
                                    caemodu = g_user,          #No.TQC-9C0077
                                    caedate = g_today          #No.TQC-9C0077
                 WHERE cae01=g_cae01
                   AND cae02=g_cae02
                   AND cae03=g_cae_t.cae03
                   AND cae04=g_cae_t.cae04
                   AND cae041=g_cae_t.cae041                #No.CHI-940027
                   AND cae08=g_cae_t.cae08
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","cae_file",g_cae01,g_cae02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                    LET g_cae[l_ac].* = g_cae_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
        
        
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cae[l_ac].* = g_cae_t.*
               #FUN-D40030--add--begin--						
               ELSE						
                  CALL g_cae.deleteElement(l_ac)						
                  IF g_rec_b != 0 THEN						
                     LET g_action_choice = "detail"						
                     LET l_ac = l_ac_t						
                  END IF						
               #FUN-D40030--add--end----						
               END IF
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D40030 add
            CLOSE t310_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(cae04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cab"
                LET g_qryparam.default1 = g_cae[l_ac].cae04
                CALL cl_create_qry() RETURNING g_cae[l_ac].cae04
                 DISPLAY BY NAME g_cae[l_ac].cae04  #No.MOD-490371
                NEXT FIELD cae04
                call t310_cae04(g_cae[l_ac].cae03,g_cae[l_ac].cae04)
                 returning g_cae[l_ac].cab02    #No.CHI-940027
              EXIT CASE
            END CASE
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cae03) AND l_ac > 1 THEN
                LET g_cae[l_ac].* = g_cae[l_ac-1].*
                NEXT FIELD cae01
            END IF
 
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
 
        ON ACTION controls                                #No.FUN-6A0092                                                              
           CALL cl_set_head_visible("","AUTO")            #No.FUN-6A0092
 
    END INPUT
 
    #統計總人工成本/製造費用到ltot,otot
    CALL t310_tot()
    CLOSE t310_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t310_b_fill(p_cae01,p_cae02)              #BODY FILL UP
DEFINE p_cae01  LIKE cae_file.cae01
DEFINE p_cae02  LIKE cae_file.cae02
 
    LET g_sql =
        "SELECT cae03,cae04,cab02,cae041,cae08,cae05,cae06,cae07,cae09,cae10,cae11 ",      #FUN-910031  #No.CHI-940027 add cae041
        "  FROM cae_file,cab_file ",
        " WHERE cae04=cab01 ",
        "   AND cae01='",p_cae01,"' ",
        "   AND cae02='",p_cae02,"' ",
        "   AND ",g_wc2 CLIPPED,
        " ORDER BY cae03"
    PREPARE t310_pb FROM g_sql
    DECLARE cae_curs CURSOR FOR t310_pb
 
    CALL g_cae.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cae_curs INTO g_cae[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL t310_cae04(g_cae[g_cnt].cae03,g_cae[g_cnt].cae04)
            RETURNING g_cae[g_cnt].cab02   #No.CHI-940027 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cae.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t310_cae04(p_cae03,p_cae04)
  DEFINE p_cae04 LIKE cae_file.cae04
  DEFINE p_cae03 LIKE cae_file.cae03
  DEFINE l_cab02 LIKE cab_file.cab02
  DEFINE l_cae041 LIKE cae_file.cae041     #CHI-970021
  DEFINE l_caa04_d  LIKE type_file.chr10     #No.FUN-680122CHAR(8)  #TQC-6A0072
 
  LET l_cab02=''   LET l_cae041='' #CHI-970021
  DECLARE caa_cur CURSOR FOR
    SELECT cab02,cae041  #CHI-970021 a04->e041
      FROM cab_file,cae_file          #CHI-970021
     WHERE cae03=p_cae03  #成本中心   #CHI-970021
       AND cae04=p_cae04  #成本項目   #CHI-970021
       AND cab01=cae04
 
  OPEN caa_cur
  FETCH caa_cur INTO l_cab02,l_cae041
  CLOSE caa_cur
 
  CASE l_cae041  #CHI-970021
    WHEN '1' LET l_caa04_d=cl_getmsg('axc-281',g_lang)
    WHEN '2' LET l_caa04_d=cl_getmsg('axc-287',g_lang)#製費1
    WHEN '3' LET l_caa04_d=cl_getmsg('axc-288',g_lang)#製費2
    WHEN '4' LET l_caa04_d=cl_getmsg('axc-289',g_lang)#製費3
    WHEN '5' LET l_caa04_d=cl_getmsg('axc-290',g_lang)#製費4
    WHEN '6' LET l_caa04_d=cl_getmsg('axc-299',g_lang)#製費5
   EXIT CASE
 END CASE
  RETURN l_cab02   #No.CHI-940027
END FUNCTION
 
FUNCTION t310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cae TO s_cae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION first
         CALL t310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
  	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL t310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 成本項目產生
      ON ACTION gen_cost_item
         LET g_action_choice="gen_cost_item"
         EXIT DISPLAY
    #@ON ACTION 更改
      ON ACTION update
         LET g_action_choice="update"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                                #No.FUN-6A0092                                                              
         CALL cl_set_head_visible("","AUTO")            #No.FUN-6A0092
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B076
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t310_gen()
  DEFINE l_caa RECORD LIKE caa_file.*
   CLEAR FORM
   CALL g_cae.clear()
   CALL cl_set_head_visible("","YES")        #No.FUN-6A0092
 
  INPUT g_cae01,g_cae02 WITHOUT DEFAULTS FROM cae01,cae02
   AFTER FIELD cae01
    IF cl_null(g_cae01) OR g_cae01=0 THEN NEXT FIELD cae01 END IF
   AFTER FIELD cae02
    IF cl_null(g_cae02) OR g_cae02 >12 OR g_cae02 < 1 THEN
        NEXT FIELD cae02 END IF
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION controls                            #No.FUN-6A0092     
         CALL cl_set_head_visible("","AUTO")        #No.FUN-6A0092 
 
  END INPUT
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
 BEGIN WORK
   LET g_success='Y'
   SELECT COUNT(*) INTO g_cnt FROM cae_file WHERE cae01=g_cae01
      AND cae02=g_cae02
   IF g_cnt > 0 THEN
      LET INT_FLAG = 0  ######add for prompt bug
      CALL cl_getmsg('axc-096',g_lang) RETURNING g_msg
      PROMPT g_msg CLIPPED FOR g_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      END PROMPT
      IF INT_FLAG OR g_chr MATCHES '[Nn]' THEN   #TQC-740120
         LET INT_FLAG = 0                        #TQC-740120
         RETURN
      END IF
   END IF
   DELETE FROM cae_file WHERE cae01=g_cae01 AND cae02=g_cae02
     IF STATUS THEN 
     CALL cl_err3("del","cae_file",g_cae01,g_cae02,STATUS,"","DEL cae error!",1)  #No.FUN-660127
     LET g_success='N'
   END IF
   LET g_cnt=0
  DECLARE cae_gen_cur CURSOR FOR
   SELECT * FROM caa_file
  CALL s_showmsg_init()    #NO.FUN-710027
  FOREACH cae_gen_cur INTO l_caa.*
     IF STATUS THEN 
        LET g_showmsg=l_caa.caa01,"/",l_caa.caa02,"/",l_caa.caa04,"/",l_caa.caa05     #NO.FUN-710027
        CALL s_errmsg('caa01,caa02,caa04,caa05',g_showmsg,'cae_gen_cur',STATUS,1)     #NO.FUN-710027
        LET g_success='N'   
        EXIT FOREACH
    END IF
    IF g_success='N' THEN                                                                                                          
       LET g_totsuccess='N'                                                                                                       
       LET g_success="Y"                                                                                                          
    END IF                    
 
    INSERT INTO cae_file(cae01,cae02,cae03,cae04,cae041,cae05,cae06,cae07,cae08,cae09,cae10,cae11,  #FUN-910031#CHI-980022 add cae041
                         caeuser,caegrup,caedate,caeoriu,caeorig,caelegal)            #No.TQC-9C0077   #FUN-A50075 add legal
     VALUES(g_cae01,g_cae02,l_caa.caa01,l_caa.caa02,l_caa.caa04,'0','0','0', #CHI-980022 add l_caa04
            l_caa.caa06,l_caa.caa07,l_caa.caa08,NULL,g_user,g_grup,g_today,g_user,g_grup,g_legal)  #FUN-910031  #No.TQC-9C0077 #FUN-A50075
     IF STATUS THEN 
       CONTINUE FOREACH                                                             #NO.FUN-710027
     END IF
    LET g_cnt=g_cnt+1
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
  END IF
  CALL s_showmsg()           
 
  IF g_success='N' THEN CALL cl_rbmsg(1) ROLLBACK WORK
  ELSE CALL cl_cmmsg(1) COMMIT WORK
  END IF
  IF g_cnt >0 THEN
    LET g_wc2=' 1=1 '
    CALL t310_b_fill(g_cae01,g_cae02)
  END IF
END FUNCTION
 
 
#單身
FUNCTION t310_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("cae04",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF INFIELD(cae03) OR (NOT g_before_input_done) THEN
       IF cl_null(g_cae[l_ac].cae03) THEN
           CALL cl_set_comp_entry("cae04",FALSE)
       END IF
   END IF
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13
