# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: apmi252.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 91/09/05 By  Wu
# Note           : 本程式為教育訓練使用雙檔標準程式

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_pmw         RECORD LIKE pmw_file.*,       #簽核等級 (單頭)
       g_pmw_t       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw_o       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw01_t     LIKE pmw_file.pmw01,          #簽核等級 (舊值)
       g_pmw_rowid   LIKE type_file.chr18,         #ROWID
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_pmx         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #採購單位
           ima908    LIKE ima_file.ima908,         #計價單位
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_t       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #採購單位
           ima908    LIKE ima_file.ima908,         #計價單位
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_o       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名規格
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #採購單位
           ima908    LIKE ima_file.ima908,         #計價單位
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身總筆數
       l_ac          LIKE type_file.num5           #單身目前指標

DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_row_count         LIKE type_file.num10   #單頭總筆數
DEFINE g_curs_index        LIKE type_file.num10   #單頭目前指標
DEFINE g_jump              LIKE type_file.num10   #查詢指定的筆數
DEFINE mi_no_ask           LIKE type_file.num5    #是否開啟指定筆視窗
DEFINE g_argv1             LIKE pmw_file.pmw01    #單號
DEFINE g_argv2             STRING                 #指定執行的功能
DEFINE g_argv3             LIKE pmx_file.pmx11    #價格型態
DEFINE g_pmx11             LIKE pmx_file.pmx11    #價格型態
DEFINE l_table             STRING
DEFINE g_str               STRING

#主程式開始
MAIN
   OPTIONS                               #改變一些系統預設值
      FORM LINE       FIRST + 2,         #畫面開始的位置
      MESSAGE LINE    LAST,              #訊息顯示的位置
      PROMPT LINE     LAST,              #提示訊息的位置
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   LET g_argv1=ARG_VAL(1)                #程式一開始需先接收外部參數
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
   IF g_argv3 = "1" THEN                 #共用程式處理
      LET g_prog="apmi252"
      LET g_pmx11 = "1"
   ELSE
      LET g_prog="apmi262"
      LET g_pmx11 = "2"
   END IF 

   IF (NOT cl_user()) THEN               #抓取部分參數(g_prog,g_user...)
      EXIT PROGRAM                       #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log    #記錄log檔
 
   IF (NOT cl_setup("APM")) THEN         #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                       #判斷使用者執行程式權限
   END IF

   LET g_sql="pmw01.pmw_file.pmw01,",    #Crystal Report Temp Table開啟
             "pmx12.pmx_file.pmx12,",   
             "pmc03.pmc_file.pmc03,",   
             "pmw04.pmw_file.pmw04,",   
             "pmw06.pmw_file.pmw06,",   
             "pmwacti.pmw_file.pmwacti,",
             "pmx02.pmx_file.pmx02,",   
             "pmx08.pmx_file.pmx08,",   
             "pmx081.pmx_file.pmx081,", 
             "pmx082.pmx_file.pmx082,",
             "pmx10.pmx_file.pmx10,", 
             "pmx09.pmx_file.pmx09,",   
             "pmx06.pmx_file.pmx06,",   
             "pmx03.pmx_file.pmx03,",   
             "pmx07.pmx_file.pmx07,",   
             "pmx04.pmx_file.pmx04,",   
             "pmx05.pmx_file.pmx05,",   
             "pmw05.pmw_file.pmw05,",   
             "pmw051.pmw_file.pmw051,", 
             "pmx06t.pmx_file.pmx06t,", 
             "gec07.gec_file.gec07,",   
             "azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('apmi252',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #計算使用時間 (進入時間)
     

   LET g_forupd_sql = "SELECT * FROM pmw_file WHERE ROWID = ? FOR UPDATE NOWAIT"
   DECLARE i252_cl CURSOR FROM g_forupd_sql           #單頭Lock Cursor

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW i252_w AT p_row,p_col WITH FORM "apm/42f/apmi252"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_set_locale_frm_name("apmi252")             #共用程式時，設定介面資料的來源
   
   LET g_pdate = g_today

   CALL cl_ui_init()                    #轉換介面語言別、匯入ToolBar、Action...等資訊

   IF g_aza.aza71 MATCHES '[Yy]' THEN   #依照系統參數設定隱藏功能鍵
      CALL aws_gpmcli_toolbar()
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF

   IF (g_sma.sma116 MATCHES '[02]') THEN   #依照系統參數設定隱藏欄位
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF

   IF g_pmx11 = "1" THEN
      CALL cl_set_comp_visible("pmx10",FALSE)
   END IF

   LET g_ydate = NULL

   IF NOT cl_null(g_argv1) THEN                       #單據程式可透過外部參數
      CASE g_argv2                                    #決定是否直接進入查詢或新增功能
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i252_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i252_a()
            END IF
         OTHERWISE
            CALL i252_q()
      END CASE
   END IF

   CALL i252_menu()                                   #進入主視窗選單

   CLOSE WINDOW i252_w                                #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN

#QBE 查詢資料
FUNCTION i252_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM 
   CALL g_pmx.clear()
  
   IF NOT cl_null(g_argv1) THEN            #傳入key值直接進入查詢功能的話
      LET g_wc = " pmw01 = '",g_argv1,"'"  #則不提供使用者輸入條件，直接組合條件式
   ELSE
      CALL cl_set_head_visible("","YES")   #單頭區塊隱藏功能，配合畫面檔設定
                                           #這裡預設單頭區塊開啟
      CONSTRUCT BY NAME g_wc ON pmw01,pmw06,pmw04,pmw05,pmw051,
                                pmwuser,pmwgrup,pmwmodu,pmwdate,pmwacti

         BEFORE CONSTRUCT                  #預設查詢條件
            CALL cl_qbe_init()

         ON ACTION controlp                #單頭欄位開窗查詢
            CASE
               WHEN INFIELD(pmw01) #詢價單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pmw01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw01
                  NEXT FIELD pmw01

               WHEN INFIELD(pmw04) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw04
                  NEXT FIELD pmw04

               WHEN INFIELD(pmw05) #稅別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " gec011='1' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw05
                  NEXT FIELD pmw05
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds            #每個交談指令必備以下四個功能
            CALL cl_on_idle()              #idle、about、help、controlg
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select              #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn     #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn)   #顯示條件
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

   #資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND pmwuser = '",g_user,"'"
   END IF
 
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND pmwgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN              #相關部門權限
      LET g_wc = g_wc clipped," AND pmwgrup IN ",cl_chk_tgrup_list()
   END IF

   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,   #螢幕上取單身條件
                         pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082
                    FROM s_pmx[1].pmx02,s_pmx[1].pmx12,s_pmx[1].pmx08,s_pmx[1].pmx09,
                         s_pmx[1].ima44,s_pmx[1].ima908,
                         s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                         s_pmx[1].pmx06,s_pmx[1].pmx06t,s_pmx[1].pmx07,
                         s_pmx[1].pmx082

         BEFORE CONSTRUCT              #再次顯示查詢條件，因為進入單身後會將原顯示值清空
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmx10)     #作業編號
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx10
                  NEXT FIELD pmx10

               WHEN INFIELD(pmx12)     #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_pmc2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmx12
                 NEXT FIELD pmx12
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save                #條件儲存
            CALL cl_qbe_save()
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

   LET g_wc2 = g_wc2 CLIPPED," AND pmx11 ='",g_pmx11,"'"

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT ROWID, pmw01 FROM pmw_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 2"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE pmw_file.ROWID, pmw01 ",
                  "  FROM pmw_file, pmx_file ",
                  " WHERE pmw01 = pmx01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 2"
   END IF

   PREPARE i252_prepare FROM g_sql
   DECLARE i252_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i252_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmw_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT pmw01) FROM pmw_file,pmx_file WHERE ",
                "pmx01=pmw01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF

   PREPARE i252_precount FROM g_sql
   DECLARE i252_count CURSOR FOR i252_precount
END FUNCTION

FUNCTION i252_menu()
   DEFINE l_partnum    STRING                #GPM料號
   DEFINE l_supplierid STRING                #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值

   WHILE TRUE
      CALL i252_bp("G")                      #透過單身驅動各功能鍵
      CASE g_action_choice                   #g_action_choice存放使用者選擇的Action
         WHEN "insert"                       #各功能進入前必須檢查權限
            IF cl_chk_act_auth() THEN
               CALL i252_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i252_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i252_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i252_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i252_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i252_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i252_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i252_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"                #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmx),'','')
            END IF
         WHEN "related_document"             #相關文件
            IF cl_chk_act_auth() THEN
               IF g_pmw.pmw01 IS NOT NULL THEN
                  LET g_doc.column1 = "pmw01"
                  LET g_doc.value1 = g_pmw.pmw01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "gpm_show"
            LET l_partnum = ''
            LET l_supplierid = ''
            IF l_ac > 0 THEN 
               LET l_partnum = g_pmx[l_ac].pmx08 
               LET l_supplierid = g_pmx[l_ac].pmx12
            END IF
            CALL aws_gpmcli(l_partnum,l_supplierid) RETURNING l_status

         WHEN "gpm_query"
            LET l_partnum = ''
            LET l_supplierid = ''
            IF l_ac > 0 THEN 
               LET l_partnum = g_pmx[l_ac].pmx08 
               LET l_supplierid = g_pmx[l_ac].pmx12
            END IF
            CALL aws_gpmcli(l_partnum,l_supplierid) RETURNING l_status
      END CASE
   END WHILE
END FUNCTION

FUNCTION i252_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
                           #單身顯示資料時，將accept跟cancel兩功能隱藏
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmx TO s_pmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY       #預設第一筆、上筆、指定筆、下筆、末一筆五個功能關閉
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()             #將目前單身停留指標存放至共用變數l_ac內
         CALL cl_show_fld_cont()           #單身資料comment變更

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION first
         CALL i252_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)          #單頭切換資料後，單身指標指定在第一筆
         ACCEPT DISPLAY                    #配合最後的AFTER DISPLAY，重新refresh單身部份

      ON ACTION previous
         CALL i252_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i252_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i252_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL i252_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()           #畫面上欄位的工具提示轉換語言別
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
         END IF 

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel                     #利用單身驅動menu時，cancel代表右上角的"X"
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel              #匯出Excel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls        #單頭摺疊，可利用hot key "Ctrl-s"開啟/關閉單頭區塊
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i252_bp_refresh()
  DISPLAY ARRAY g_pmx TO s_pmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION i252_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10

   MESSAGE ""
   CLEAR FORM                                    #清空單頭畫面
   CALL g_pmx.clear()                            #清空單身畫面及資料
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_pmw.* LIKE pmw_file.*            #DEFAULT 設定
   LET g_pmw01_t = NULL

   IF g_ydate IS NULL THEN
      LET g_pmw.pmw01 = NULL
      LET g_pmw.pmw06 = g_today
   ELSE                                          #使用上筆資料值
      LET g_pmw.pmw01 = g_sheet                  #採購詢價單別
      LET g_pmw.pmw06 = g_ydate                  #收貨日期
   END IF

   #預設值及將數值類變數清成零
   LET g_pmw_t.* = g_pmw.*
   LET g_pmw_o.* = g_pmw.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_pmw.pmwuser=g_user
      LET g_pmw.pmwgrup=g_grup
      LET g_pmw.pmwdate=g_today
      LET g_pmw.pmwacti='Y'              #資料有效

      CALL i252_i("a")                   #輸入單頭

      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_pmw.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_pmw.pmw01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK

      #透過以下共用程式，可以判斷系統參數是否要自動編號，編號後自動檢查編號正確性並回傳
      CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","")
      RETURNING li_result,g_pmw.pmw01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_pmw.pmw01

      INSERT INTO pmw_file VALUES (g_pmw.*)

      LET g_ydate = g_pmw.pmw06                #備份上一筆交貨日期
                                               #截取單據編號中的單別代碼
      CALL s_get_doc_no(g_pmw.pmw01) RETURNING g_sheet

      IF SQLCA.sqlcode THEN                    #置入資料庫不成功
         ROLLBACK WORK                         #SQL處理錯誤時，用cl_err3顯示錯誤訊息
         CALL cl_err3("ins","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK                           #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_pmw.pmw01,'I')  #則增加訊息到udm7主畫面上或使用者信箱
      END IF                                   #此功能適用單據編號程式

      SELECT ROWID INTO g_pmw_rowid FROM pmw_file
       WHERE pmw01 = g_pmw.pmw01
      LET g_pmw01_t = g_pmw.pmw01              #保留舊值
      LET g_pmw_t.* = g_pmw.*
      LET g_pmw_o.* = g_pmw.*
      CALL g_pmx.clear()

      LET g_rec_b = 0
      CALL i252_b()                            #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i252_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_pmw.* FROM pmw_file
    WHERE pmw01=g_pmw.pmw01

   IF g_pmw.pmwacti ='N' THEN                      #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmw01_t = g_pmw.pmw01

   BEGIN WORK

   OPEN i252_cl USING g_pmw_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i252_cl INTO g_pmw.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i252_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i252_show()

   WHILE TRUE
      LET g_pmw01_t = g_pmw.pmw01
      LET g_pmw_o.* = g_pmw.*
      LET g_pmw.pmwmodu=g_user
      LET g_pmw.pmwdate=g_today

      CALL i252_i("u")                             #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmw.*=g_pmw_t.*
         CALL i252_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_pmw.pmw01 != g_pmw01_t THEN             #更改單號
         UPDATE pmx_file SET pmx01 = g_pmw.pmw01   #單身key值與單頭key值必須連動
          WHERE pmx01 = g_pmw01_t                  #SQLCA.sqlerrd[3]代表資料庫處理筆數
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmx_file",g_pmw01_t,"",SQLCA.sqlcode,"","pmx",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE pmw_file SET pmw_file.* = g_pmw.*
       WHERE ROWID = g_pmw_rowid

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pmw_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'U')        #更改成功後，流程訊息通知

   CALL i252_b_fill("1=1")                     #重新抓取單身
   CALL i252_bp_refresh()                      #refresh單身畫面資料
END FUNCTION

FUNCTION i252_i(p_cmd)
   DEFINE   l_pmc05     LIKE pmc_file.pmc05,
            l_pmc30     LIKE pmc_file.pmc30,
            l_n         LIKE type_file.num5,
            p_cmd       LIKE type_file.chr1    #a:輸入 u:更改
   DEFINE   li_result   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_pmw.pmwuser,g_pmw.pmwmodu,
       g_pmw.pmwgrup,g_pmw.pmwdate,g_pmw.pmwacti

   CALL cl_set_head_visible("","YES")        #預設單頭區塊開啟
   INPUT BY NAME g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,
                 g_pmw.pmw05,g_pmw.pmw051 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE     #條件影響欄位開啟或關閉
         CALL i252_set_entry(p_cmd)
         CALL i252_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("pmw01")

      AFTER FIELD pmw01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_pmw.pmw01) THEN
            #以下共用程式可依照參數設定檔，檢查單別、流水號、整個單據編號是否正確
            CALL s_check_no("apm",g_pmw.pmw01,g_pmw01_t,"6","pmw_file","pmw01","")
            RETURNING li_result,g_pmw.pmw01
            DISPLAY BY NAME g_pmw.pmw01
            IF (NOT li_result) THEN
               LET g_pmw.pmw01=g_pmw_o.pmw01
               NEXT FIELD pmw01
            END IF
            DISPLAY g_smy.smydesc TO smydesc     #顯示單別名稱
         END IF

      AFTER FIELD pmw04                  #幣別
         IF NOT cl_null(g_pmw.pmw04) THEN
            IF g_pmw_o.pmw04 IS NULL OR
               (g_pmw_o.pmw04 != g_pmw.pmw04 ) THEN
               CALL i252_pmw04(p_cmd)            #檢查是否存在幣別基本檔內
               IF NOT cl_null(g_errno) THEN      #並顯示幣別名稱
                  CALL cl_err(g_pmw.pmw04,g_errno,0)
                  LET g_pmw.pmw04 = g_pmw_o.pmw04
                  DISPLAY BY NAME g_pmw.pmw04
                  NEXT FIELD pmw04
               END IF
            END IF
            LET g_pmw_o.pmw04 = g_pmw.pmw04
         END IF

      AFTER FIELD pmw05                  #稅別
         IF NOT cl_null(g_pmw.pmw05) THEN
            IF g_pmw_o.pmw05 IS NULL OR
               (g_pmw_o.pmw05 != g_pmw.pmw05 ) THEN
               CALL i252_pmw05(p_cmd)            #檢查是否存在稅別基本檔內
               IF NOT cl_null(g_errno) THEN      #並顯示稅率、是否單價含稅
                  CALL cl_err(g_pmw.pmw05,g_errno,0)
                  LET g_pmw.pmw05 = g_pmw_o.pmw05
                  DISPLAY BY NAME g_pmw.pmw05
                  NEXT FIELD pmw05
               END IF
               IF p_cmd = 'u' AND g_pmw_o.pmw051 != g_pmw.pmw051 THEN   
                  #當修改單頭稅別時,要重計單身的詢價未稅單價欄位(pmx06)
                  CALL i252_cal_price()
               END IF
            END IF
            LET g_pmw_o.pmw05 = g_pmw.pmw05
         END IF

      ON ACTION CONTROLZ                  #檢查必要欄位是否有值
         CALL cl_show_req_fields()

      ON ACTION CONTROLG                  #另開作業
         CALL cl_cmdask()

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(pmw01)           #單據編號
               #以下方式開窗非動態開窗，q_smy為實際存在$QRY下的程式及畫面
               LET g_t1=s_get_doc_no(g_pmw.pmw01)
               CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1
               LET g_pmw.pmw01 = g_t1
               DISPLAY BY NAME g_pmw.pmw01
               CALL i252_pmw01('d')
               NEXT FIELD pmw01

            WHEN INFIELD(pmw04)           #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_pmw.pmw04
               CALL cl_create_qry() RETURNING g_pmw.pmw04
               DISPLAY BY NAME g_pmw.pmw04
               CALL i252_pmw04('d')
               NEXT FIELD pmw04

            WHEN INFIELD(pmw05) #稅別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.default1 = g_pmw.pmw05
               LET g_qryparam.arg1     = '1'
               CALL cl_create_qry() RETURNING g_pmw.pmw05
               DISPLAY BY NAME g_pmw.pmw05
               CALL i252_pmw05('d')
               NEXT FIELD pmw05

            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION i252_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pmw01",TRUE)
   END IF

END FUNCTION

FUNCTION i252_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pmw01",FALSE)
   END IF

END FUNCTION

FUNCTION i252_pmw01(p_cmd)  #單據編號
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_pmw.pmw01)
   IF g_pmw.pmw01 IS NULL THEN
      LET g_errno = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
END FUNCTION
 
FUNCTION i252_pmx12(p_cmd)  #廠商編號
   DEFINE    l_pmc22     LIKE pmc_file.pmc22,
             l_pmc47     LIKE pmc_file.pmc47,
             l_pmcacti   LIKE pmc_file.pmcacti,
             p_cmd       LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT pmc03,pmc22,pmc47,pmcacti
     INTO g_pmx[l_ac].pmc03,l_pmc22,l_pmc47,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_pmx[l_ac].pmx12

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET g_pmx[l_ac].pmc03 = NULL
                                  LET l_pmc22 = NULL
        WHEN l_pmcacti='N'        LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_pmx[l_ac].pmc03 
   END IF
END FUNCTION
 
FUNCTION i252_pmw04(p_cmd)  #幣別
   DEFINE   l_azi02     LIKE azi_file.azi02,
            l_aziacti   LIKE azi_file.aziacti,
            p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   LET t_azi03 = 0
   SELECT azi02,aziacti,azi03 INTO l_azi02,l_aziacti,t_azi03
     FROM azi_file WHERE azi01 = g_pmw.pmw04

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_azi02 = NULL
        WHEN l_aziacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
END FUNCTION

FUNCTION i252_pmw05(p_cmd)  #稅別
   DEFINE  l_gec04     LIKE gec_file.gec04,
           l_gecacti   LIKE gec_file.gecacti,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07
     FROM gec_file
    WHERE gec01 = g_pmw.pmw05 AND gec011='1'  #進項
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                  LET l_gec04 = 0
        WHEN l_gecacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_gec07) THEN
      LET g_gec07 = 'N'
   END IF

   LET g_pmw.pmw051 = l_gec04
   DISPLAY BY NAME g_pmw.pmw051

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_gec07 TO FORMONLY.gec07
   END IF
END FUNCTION

FUNCTION i252_cal_price()
   DEFINE   l_pmx02    LIKE pmx_file.pmx02,
            l_pmx06t   LIKE pmx_file.pmx06t,
            l_pmx06    LIKE pmx_file.pmx06

   #抓取單身詢價含稅單價
   LET g_sql = "SELECT pmx02,pmx06t FROM pmx_file WHERE pmx01 ='",g_pmw.pmw01,"' "
   PREPARE i252_cal FROM g_sql
   DECLARE pmx_cs_cal CURSOR FOR i252_cal             #CURSOR

   FOREACH pmx_cs_cal INTO l_pmx02,l_pmx06t
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET l_pmx06 = l_pmx06t / (1 + g_pmw.pmw051/100)
      LET l_pmx06 = cl_digcut(l_pmx06,t_azi03)

      UPDATE pmx_file SET pmx06 = l_pmx06 
                    WHERE pmx01 = g_pmw.pmw01 
                      AND pmx02 = l_pmx02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pmx_file",g_pmw.pmw01,l_pmx02,SQLCA.sqlcode,"","",1)
      END IF
   END FOREACH
END FUNCTION

FUNCTION i252_q()

   LET g_row_count = 0                     #預設上下筆功能關閉
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM                              #清空單頭畫面
   CALL g_pmx.clear()                      #清空單身畫面及資料
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i252_cs()                          #使用者輸入條件

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pmw.* TO NULL
      RETURN
   END IF

   OPEN i252_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmw.* TO NULL
   ELSE
      OPEN i252_count
      FETCH i252_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL i252_fetch('F')                 # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION i252_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1         #處理方式

   CASE p_flag
      WHEN 'N' FETCH NEXT     i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      WHEN 'P' FETCH PREVIOUS i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      WHEN 'F' FETCH FIRST    i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      WHEN 'L' FETCH LAST     i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      WHEN '/'
         IF (NOT mi_no_ask) THEN           #指定筆開窗選擇
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i252_cs INTO g_pmw_rowid,g_pmw.pmw01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)
      INITIALIZE g_pmw.* TO NULL
      RETURN
   ELSE
      CASE p_flag                        #指定目前筆數指標
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
                                         #重新設定上下筆五個功能鍵的開關
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT * INTO g_pmw.* FROM pmw_file WHERE ROWID = g_pmw_rowid
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmw_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_pmw.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_pmw.pmwuser      # 權限控管
   LET g_data_group = g_pmw.pmwgrup

   CALL i252_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i252_show()

   LET g_pmw_t.* = g_pmw.*                #保存單頭舊值
   LET g_pmw_o.* = g_pmw.*                #保存單頭舊值
   DISPLAY BY NAME g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,
                   g_pmw.pmwuser,g_pmw.pmwgrup,g_pmw.pmwmodu,
                   g_pmw.pmwdate,g_pmw.pmwacti,
                   g_pmw.pmw05,g_pmw.pmw051
 
   CALL i252_pmw01('d')
   CALL i252_pmw04('d')
   CALL i252_pmw05('d')

   CALL i252_b_fill(g_wc2)                #單身

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i252_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   BEGIN WORK

   OPEN i252_cl USING g_pmw_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i252_cl INTO g_pmw.*                     # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)    #資料被他人LOCK
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL i252_show()

   IF cl_exp(0,0,g_pmw.pmwacti) THEN              #確認一下
      LET g_chr=g_pmw.pmwacti
      IF g_pmw.pmwacti='Y' THEN
         LET g_pmw.pmwacti='N'
      ELSE
         LET g_pmw.pmwacti='Y'
      END IF

      UPDATE pmw_file SET pmwacti=g_pmw.pmwacti,
                          pmwmodu=g_user,
                          pmwdate=g_today
       WHERE pmw01=g_pmw.pmw01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1)
         LET g_pmw.pmwacti=g_chr
      END IF
   END IF

   CLOSE i252_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pmw.pmw01,'V')        #確認成功後，通知相關人員
   ELSE
      ROLLBACK WORK
   END IF

   SELECT pmwacti,pmwmodu,pmwdate
     INTO g_pmw.pmwacti,g_pmw.pmwmodu,g_pmw.pmwdate FROM pmw_file
    WHERE pmw01=g_pmw.pmw01
   DISPLAY BY NAME g_pmw.pmwacti,g_pmw.pmwmodu,g_pmw.pmwdate
END FUNCTION

FUNCTION i252_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_pmw.* FROM pmw_file
    WHERE pmw01=g_pmw.pmw01
   IF g_pmw.pmwacti ='N' THEN                   #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK

   OPEN i252_cl USING g_pmw_rowid
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i252_cl INTO g_pmw.*                   #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)  #資料被他人LOCK
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL i252_show()

   IF cl_delh(0,0) THEN                                #詢問是否刪除此筆資料
      DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01   #單頭單身資料一併刪除
      DELETE FROM pmx_file WHERE pmx01 = g_pmw.pmw01   #以免留下垃圾
      CLEAR FORM
      CALL g_pmx.clear()
      OPEN i252_count                                  #重新計算總筆數
      FETCH i252_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i252_cs                                     #refresh查詢出來的資料列
      IF g_curs_index = g_row_count + 1 THEN           #才能清空刪除後的空白位置
         LET g_jump = g_row_count                      #利用指定筆的功能，將指標停留在
         CALL i252_fetch('L')                          #刪除的後一筆
      ELSE                                                                                   
         LET g_jump = g_curs_index                                                           
         LET mi_no_ask = TRUE                          #利用指定筆時，控制不開窗直接搜尋資料
         CALL i252_fetch('/')
      END IF
   END IF

   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'D')                #流程訊息通知
END FUNCTION

#單身
FUNCTION i252_b()
   DEFINE   l_ac_t           LIKE type_file.num5,    #未取消的ARRAY CNT
            l_n              LIKE type_file.num5,    #檢查重複用
            l_cnt            LIKE type_file.num5,    #檢查重複用
            l_lock_sw        LIKE type_file.chr1,    #單身鎖住否
            p_cmd            LIKE type_file.chr1,    #處理狀態
            l_misc           LIKE gef_file.gef01,
            l_allow_insert   LIKE type_file.num5,    #可新增否
            l_allow_delete   LIKE type_file.num5,    #可刪除否
            l_pmc05          LIKE pmc_file.pmc05,
            l_pmc30          LIKE pmc_file.pmc30

   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_pmw.pmw01 IS NULL THEN
      RETURN
   END IF

   SELECT * INTO g_pmw.* FROM pmw_file
    WHERE pmw01=g_pmw.pmw01

   IF g_pmw.pmwacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,pmx09,'','',pmx04,",
                      "       pmx05,pmx03,pmx06,pmx06t,pmx07 ",
                      "  FROM pmx_file",
                      " WHERE pmx01=? AND pmx02=? ",
                      "   AND pmx11='",g_pmx11,"' FOR UPDATE NOWAIT"
   DECLARE i252_bcl CURSOR FROM g_forupd_sql      # 單身LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")  #單身insert權限
   LET l_allow_delete = cl_detail_input_auth("delete")  #單身delete權限

   INPUT ARRAY g_pmx WITHOUT DEFAULTS FROM s_pmx.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)           #設定新增、刪除的權限

      BEFORE INPUT
         IF g_rec_b != 0 THEN                     #指定進入單身後跳至第幾筆
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'             #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK

         OPEN i252_cl USING g_pmw_rowid
         IF STATUS THEN
            CALL cl_err("OPEN i252_cl:", STATUS, 1)
            CLOSE i252_cl
            ROLLBACK WORK
            RETURN
         END IF

         FETCH i252_cl INTO g_pmw.*      # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i252_cl
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b >= l_ac THEN         # 當總筆數大於目前指標時，代表對已有資料做更改
            LET p_cmd='u'
            LET g_pmx_t.* = g_pmx[l_ac].*  #BACKUP
            LET g_pmx_o.* = g_pmx[l_ac].*  #BACKUP
            OPEN i252_bcl USING g_pmw.pmw01,g_pmx_t.pmx02
            IF STATUS THEN
               CALL cl_err("OPEN i252_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i252_bcl INTO g_pmx[l_ac].*    #鎖定單筆單身資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pmx_t.pmx02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i252_pmx12('d')

               SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                 FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
            END IF
            CALL cl_show_fld_cont()
            CALL i252_set_entry_b(p_cmd)
            CALL i252_set_no_entry_b(p_cmd)
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pmx[l_ac].* TO NULL
         LET g_pmx[l_ac].pmx03 =  0            #Body default
         LET g_pmx[l_ac].pmx06 =  0            #Body default
         LET g_pmx[l_ac].pmx06t=  0            #Body default
         LET g_pmx[l_ac].pmx07 =  0            #Body default
         LET g_pmx[l_ac].pmx10 = " "
         LET g_pmx_t.* = g_pmx[l_ac].*         #新輸入資料
         LET g_pmx_o.* = g_pmx[l_ac].*         #新輸入資料
         IF l_ac > 1 THEN
            LET g_pmx[l_ac].pmx04 = g_pmx[l_ac-1].pmx04
         ELSE
            LET g_pmx[l_ac].pmx04 = g_pmw.pmw06
         END IF
         CALL cl_show_fld_cont()
         CALL i252_set_entry_b(p_cmd)
         CALL i252_set_no_entry_b(p_cmd)
         NEXT FIELD pmx02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT                #按下中斷鍵時，離開新增階段
         END IF
         IF cl_null(g_pmx[l_ac].pmx10) THEN
            LET g_pmx[l_ac].pmx10 = " "
         END IF
         INSERT INTO pmx_file(pmx01,pmx02,pmx03,pmx04,pmx05,pmx06,
                              pmx06t,pmx07,pmx08,pmx09,pmx10,pmx11,pmx081,pmx082,pmx12)
         VALUES(g_pmw.pmw01,g_pmx[l_ac].pmx02,
                g_pmx[l_ac].pmx03,g_pmx[l_ac].pmx04,
                g_pmx[l_ac].pmx05,g_pmx[l_ac].pmx06,
                g_pmx[l_ac].pmx06t,
                g_pmx[l_ac].pmx07,g_pmx[l_ac].pmx08,
                g_pmx[l_ac].pmx09,g_pmx[l_ac].pmx10,g_pmx11,
                g_pmx[l_ac].pmx081,g_pmx[l_ac].pmx082,g_pmx[l_ac].pmx12)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmx_file",g_pmw.pmw01,g_pmx[l_ac].pmx02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE FIELD pmx02                      #default 序號
         IF g_pmx[l_ac].pmx02 IS NULL OR g_pmx[l_ac].pmx02 = 0 THEN
            SELECT max(pmx02)+1 INTO g_pmx[l_ac].pmx02 FROM pmx_file
             WHERE pmx01 = g_pmw.pmw01
            IF g_pmx[l_ac].pmx02 IS NULL THEN
               LET g_pmx[l_ac].pmx02 = 1
            END IF
         END IF

      AFTER FIELD pmx02                       #check 序號是否重複
         IF NOT cl_null(g_pmx[l_ac].pmx02) THEN
            IF g_pmx[l_ac].pmx02 != g_pmx_t.pmx02
               OR g_pmx_t.pmx02 IS NULL THEN
               SELECT count(*) INTO l_n FROM pmx_file
                WHERE pmx01 = g_pmw.pmw01 AND pmx02 = g_pmx[l_ac].pmx02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pmx[l_ac].pmx02 = g_pmx_t.pmx02
                  NEXT FIELD pmx02
               END IF
            END IF
         END IF

      AFTER FIELD pmx12                       #廠商編號資料檢查
         IF NOT cl_null(g_pmx[l_ac].pmx12) THEN
            IF g_pmx_o.pmx12 IS NULL OR
               (g_pmx[l_ac].pmx12 != g_pmx_o.pmx12 ) THEN
               CALL i252_pmx12(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmx[l_ac].pmx12,g_errno,0)
                  LET g_pmx[l_ac].pmx12 = g_pmx_o.pmx12
                  DISPLAY BY NAME g_pmx[l_ac].pmx12
                  NEXT FIELD pmx12
               END IF
            END IF
            SELECT pmc05,pmc30 INTO l_pmc05,l_pmc30 FROM pmc_file
             WHERE pmc01 = g_pmx[l_ac].pmx12
            IF l_pmc05 = "0" THEN
               CALL cl_err('','mfg3288',1)
            END IF
            IF l_pmc05 = "3" THEN
               CALL cl_err('','mfg3289',0)
               NEXT FIELD pmx12
            END IF
            LET g_pmx_o.pmx12 = g_pmx[l_ac].pmx12
         END IF

      BEFORE FIELD pmx08                 #料件編號影響品名與規格的輸入
         CALL i252_set_entry_b(p_cmd)
 
      AFTER FIELD pmx08                  #料件編號
         LET l_misc=g_pmx[l_ac].pmx08[1,4]
         IF g_pmx[l_ac].pmx08[1,4]='MISC' THEN
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01=l_misc AND ima01='MISC'
            IF l_n=0 THEN
               CALL cl_err('','aim-806',0)
               NEXT FIELD pmx08
            END IF
         END IF
         IF NOT cl_null(g_pmx[l_ac].pmx08) THEN
            IF g_pmx_o.pmx08 IS NULL OR g_pmx_o.pmx081 IS NULL OR
              (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) THEN
               CALL i252_pmx08('a')
               SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
               FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
               IF NOT cl_null(g_errno)
                  AND g_pmx[l_ac].pmx08[1,4] !='MISC' THEN
                  CALL cl_err(g_pmx[l_ac].pmx08,g_errno,0)
                  LET g_pmx[l_ac].pmx08 = g_pmx_o.pmx08
                  DISPLAY BY NAME g_pmx[l_ac].pmx08
                  NEXT FIELD pmx08
               END IF
            END IF
         END IF
         LET g_pmx_o.pmx08 = g_pmx[l_ac].pmx08
         CALL i252_set_no_entry_b(p_cmd)

      AFTER FIELD pmx10                  #作業編號資料檢查
         IF NOT cl_null(g_pmx[l_ac].pmx10) THEN
            SELECT COUNT(*) INTO g_cnt FROM ecd_file
             WHERE ecd01=g_pmx[l_ac].pmx10
            IF g_cnt=0 THEN
               CALL cl_err('sel ecd_file',100,0)
               NEXT FIELD pmx10
            END IF
         END IF
         IF cl_null(g_pmx[l_ac].pmx10) THEN
            LET g_pmx[l_ac].pmx10 =" " 
         END IF
         IF g_pmx_o.pmx081 IS NULL OR g_pmx_o.pmx08 IS NULL OR
           (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) OR
           (g_pmx[l_ac].pmx081 != g_pmx_o.pmx081 ) THEN
            SELECT COUNT(*) INTO l_cnt FROM pmx_file
             WHERE pmx01=g_pmw.pmw01
               AND pmx08=g_pmx[l_ac].pmx08
               AND pmx081=g_pmx[l_ac].pmx081
               AND pmx10=g_pmx[l_ac].pmx10
               AND pmx11=g_pmx11
               AND pmx12=g_pmx[l_ac].pmx12
            IF l_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD pmx10
            END IF
         END IF
 
      AFTER FIELD pmx09                  #詢價單位
         IF NOT cl_null(g_pmx[l_ac].pmx09) THEN
            IF g_pmx[l_ac].pmx09 IS NULL OR g_pmx_t.pmx09 IS NULL OR
               (g_pmx[l_ac].pmx09 != g_pmx_o.pmx09) THEN
               CALL i252_pmx09()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmx[l_ac].pmx09,g_errno,0)
                  LET g_pmx[l_ac].pmx09 = g_pmx_o.pmx09
                  DISPLAY BY NAME g_pmx[l_ac].pmx09
                  NEXT FIELD pmx09
               END IF
            END IF
         END IF
         LET g_pmx_o.pmx09 = g_pmx[l_ac].pmx09

      AFTER FIELD pmx05
         IF NOT cl_null(g_pmx[l_ac].pmx05) THEN
            IF (g_pmx[l_ac].pmx05 < g_pmx[l_ac].pmx04) THEN
               CALL cl_err(g_pmx[l_ac].pmx05,'mfg3009',0)
               NEXT FIELD pmx05
            END IF
         END IF

      AFTER FIELD pmx03                  #下限數量
         IF NOT cl_null(g_pmx[l_ac].pmx03) THEN
            IF g_pmx[l_ac].pmx03 < 0 THEN
               CALL cl_err(g_pmx[l_ac].pmx03,'mfg5034',0)
               LET g_pmx[l_ac].pmx03 = g_pmx_o.pmx03
               DISPLAY BY NAME g_pmx[l_ac].pmx03
               NEXT FIELD pmx03
            END IF
            IF p_cmd = 'a' THEN
               IF NOT cl_null(g_pmx[l_ac].pmx05) THEN
                  SELECT COUNT(*) INTO l_cnt FROM pmx_file
                   WHERE( (g_pmx[l_ac].pmx04 <= pmx04
                     AND g_pmx[l_ac].pmx05 >= pmx04)
                      OR (g_pmx[l_ac].pmx04 <= pmx05
                     AND g_pmx[l_ac].pmx05 >= pmx05)
                      OR (g_pmx[l_ac].pmx04 >= pmx04
                     AND g_pmx[l_ac].pmx05 <= pmx05)
                      OR (g_pmx[l_ac].pmx04 <= pmx04
                     AND g_pmx[l_ac].pmx05 >= pmx05)
                      OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
                     AND pmx08 = g_pmx[l_ac].pmx08
                     AND pmx09 = g_pmx[l_ac].pmx09
                     AND pmx03 = g_pmx[l_ac].pmx03
                     AND pmx01 = g_pmw.pmw01
                     AND pmx03[1,4] <> 'MISC'
                     AND pmx11 =  g_pmx11
                     AND pmx12 = g_pmx[l_ac].pmx12
               END IF
               IF g_pmx[l_ac].pmx05 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM pmx_file
                   WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
                      OR (pmx05 IS NULL))
                     AND pmx08 = g_pmx[l_ac].pmx08
                     AND pmx09 = g_pmx[l_ac].pmx09
                     AND pmx03 = g_pmx[l_ac].pmx03
                     AND pmx01 = g_pmw.pmw01
                     AND pmx03[1,4] <> 'MISC'
                     AND pmx11 =  g_pmx11
                     AND pmx10 =  g_pmx[l_ac].pmx10
                     AND pmx12 = g_pmx[l_ac].pmx12
               END IF
               IF l_cnt > 0 THEN
                  CALL cl_err('','mfg3287',0)
                  NEXT FIELD pmx04
               END IF
            END IF
            IF p_cmd = 'u' THEN
               IF g_pmx[l_ac].pmx05 IS NOT NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM pmx_file
                   WHERE( (g_pmx[l_ac].pmx04 <= pmx04
                     AND g_pmx[l_ac].pmx05 >= pmx04)
                      OR (g_pmx[l_ac].pmx04 <= pmx05
                     AND g_pmx[l_ac].pmx05 >= pmx05)
                      OR (g_pmx[l_ac].pmx04 >= pmx04
                     AND g_pmx[l_ac].pmx05 <= pmx05)
                      OR (g_pmx[l_ac].pmx04 <= pmx04
                     AND g_pmx[l_ac].pmx05 >= pmx05)
                      OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
                     AND pmx08 = g_pmx[l_ac].pmx08
                     AND pmx09 = g_pmx[l_ac].pmx09
                     AND pmx03 = g_pmx[l_ac].pmx03
                     AND pmx02 != g_pmx[l_ac].pmx02
                     AND pmx01 = g_pmw.pmw01
                     AND pmx11 =  g_pmx11
                     AND pmx12 = g_pmx[l_ac].pmx12
               END IF
               IF g_pmx[l_ac].pmx05 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM pmx_file
                   WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
                      OR (pmx05 IS NULL))
                     AND pmx08 = g_pmx[l_ac].pmx08
                     AND pmx09 = g_pmx[l_ac].pmx09
                     AND pmx03 = g_pmx[l_ac].pmx03
                     AND pmx02 != g_pmx[l_ac].pmx02
                     AND pmx01 = g_pmw.pmw01
                     AND pmx11 =  g_pmx11
                     AND pmx10 =  g_pmx[l_ac].pmx10
                     AND pmx12 =  g_pmx[l_ac].pmx12
               END IF
               IF l_cnt > 0 THEN
                  CALL cl_err('','mfg3287',0)
                  NEXT FIELD pmx04
               END IF
            END IF
            LET g_pmx_o.pmx03 = g_pmx[l_ac].pmx03
         END IF

      AFTER FIELD pmx06                  #詢價單價
         IF NOT cl_null(g_pmx[l_ac].pmx06) THEN
            IF g_pmx[l_ac].pmx06 <= 0 THEN
               CALL cl_err(g_pmx[l_ac].pmx06,'mfg3291',0)
               LET g_pmx[l_ac].pmx06 = g_pmx_o.pmx06
               NEXT FIELD pmx06
            END IF
            LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)  #幣別取位
            DISPLAY BY NAME g_pmx[l_ac].pmx06
            LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
            LET g_pmx[l_ac].pmx06t = g_pmx[l_ac].pmx06 * (1 + g_pmw.pmw051/100)
            LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)
            LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t
         END IF

      AFTER FIELD pmx06t                 #詢價單價
         IF NOT cl_null(g_pmx[l_ac].pmx06t) THEN
            IF g_pmx[l_ac].pmx06t <= 0 THEN
               CALL cl_err(g_pmx[l_ac].pmx06t,'mfg3291',0)
               LET g_pmx[l_ac].pmx06t = g_pmx_o.pmx06t
               NEXT FIELD pmx06t
            END IF
            LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)
            LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t

            LET g_pmx[l_ac].pmx06 = g_pmx[l_ac].pmx06t / (1 + g_pmw.pmw051/100)
            LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)
            LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
         END IF

      AFTER FIELD pmx07                  #折扣比率
         IF NOT cl_null(g_pmx[l_ac].pmx07) THEN
            IF g_pmx[l_ac].pmx07 < 0 OR g_pmx[l_ac].pmx07 >= 100 THEN
               CALL cl_err(g_pmx[l_ac].pmx07,'mfg0013',0)
               LET g_pmx[l_ac].pmx07 = g_pmx_o.pmx07
               DISPLAY BY NAME g_pmx[l_ac].pmx07
               NEXT FIELD pmx07
            END IF
            LET g_pmx_o.pmx07 = g_pmx[l_ac].pmx07
         END IF

      BEFORE DELETE                      #是否取消單身
         IF g_pmx_t.pmx02 > 0 AND g_pmx_t.pmx02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN     #詢問使用者
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN      #資料被lock的話，不可刪除
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pmx_file
             WHERE pmx01 = g_pmw.pmw01
               AND pmx02 = g_pmx_t.pmx02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pmx[l_ac].* = g_pmx_t.*
            CLOSE i252_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN         #資料被lock的話，不可更改
            CALL cl_err(g_pmx[l_ac].pmx02,-263,1)
            LET g_pmx[l_ac].* = g_pmx_t.*
         ELSE
            IF cl_null(g_pmx[l_ac].pmx10) THEN
               LET g_pmx[l_ac].pmx10 = " "
            END IF
            UPDATE pmx_file SET pmx02=g_pmx[l_ac].pmx02,
                                pmx03=g_pmx[l_ac].pmx03,
                                pmx04=g_pmx[l_ac].pmx04,
                                pmx05=g_pmx[l_ac].pmx05,
                                pmx06=g_pmx[l_ac].pmx06,
                                pmx06t=g_pmx[l_ac].pmx06t,
                                pmx07=g_pmx[l_ac].pmx07,
                                pmx08=g_pmx[l_ac].pmx08,
                                pmx09=g_pmx[l_ac].pmx09,
                                pmx10=g_pmx[l_ac].pmx10,
                                pmx11=g_pmx11,
                                pmx081=g_pmx[l_ac].pmx081,
                                pmx082=g_pmx[l_ac].pmx082,
                                pmx12=g_pmx[l_ac].pmx12
             WHERE pmx01=g_pmw.pmw01
               AND pmx02=g_pmx_t.pmx02
               AND pmx11=g_pmx11
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)
               LET g_pmx[l_ac].* = g_pmx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmx[l_ac].* = g_pmx_t.*
            END IF
            CLOSE i252_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i252_bcl
         COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pmx02) AND l_ac > 1 THEN
            LET g_pmx[l_ac].* = g_pmx[l_ac-1].*
            LET g_pmx[l_ac].pmx02 = g_rec_b + 1
            NEXT FIELD pmx02
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION itemno
         IF g_sma.sma38 matches'[Yy]' THEN
            CALL cl_cmdrun("aimi109 ")
         ELSE
            CALL cl_err(g_sma.sma38,'mfg0035',1)
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(pmx12) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_pmx[l_ac].pmx12
               CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx12
               DISPLAY BY NAME g_pmx[l_ac].pmx12
               CALL i252_pmx12('d')
               NEXT FIELD pmx12

            WHEN INFIELD(pmx08) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ima"
               LET g_qryparam.default1 = g_pmx[l_ac].pmx08
               CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx08
               DISPLAY BY NAME g_pmx[l_ac].pmx08
               IF NOT cl_null(g_pmx[l_ac].pmx08) AND
                  g_pmx[l_ac].pmx08[1,4] !='MISC' THEN
                  CALL i252_pmx08('d')
               END IF
               NEXT FIELD pmx08

            WHEN INFIELD(pmx09) #詢價單位
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_pmx[l_ac].pmx09
               CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx09
               DISPLAY BY NAME g_pmx[l_ac].pmx09
               NEXT FIELD pmx09

            WHEN INFIELD(pmx10) #作業編號
               CALL q_ecd(FALSE,TRUE,'') RETURNING g_pmx[l_ac].pmx10
               DISPLAY BY NAME g_pmx[l_ac].pmx10
               NEXT FIELD pmx10
             OTHERWISE EXIT CASE
          END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls                 #單頭區塊開啟或隱藏
         CALL cl_set_head_visible("","AUTO")
   END INPUT

   LET g_pmw.pmwmodu = g_user
   LET g_pmw.pmwdate = g_today
   UPDATE pmw_file SET pmwmodu = g_pmw.pmwmodu,pmwdate = g_pmw.pmwdate
   WHERE pmw01 = g_pmw.pmw01
   DISPLAY BY NAME g_pmw.pmwmodu,g_pmw.pmwdate

   CLOSE i252_bcl
   COMMIT WORK
   CALL i252_delall()                    #若單身無任何資料，則刪除單頭資料

END FUNCTION

FUNCTION i252_set_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF INFIELD(pmx08) THEN
      CALL cl_set_comp_entry("pmx081,pmx082,pmx06,pmx06t",TRUE)
   END IF
   CALL cl_set_comp_entry("pmx06,pmx06t",TRUE)

END FUNCTION

FUNCTION i252_set_no_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1

   IF INFIELD(pmx08) THEN
      IF g_pmx[l_ac].pmx08[1,4] <> 'MISC' THEN
         CALL cl_set_comp_entry("pmx081,pmx082",FALSE)
      END IF
   END IF

   IF g_gec07 = 'N' THEN
      CALL cl_set_comp_entry("pmx06t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmx06",FALSE)
   END IF

END FUNCTION
 
FUNCTION i252_delall()

   SELECT COUNT(*) INTO g_cnt FROM pmx_file
    WHERE pmx01 = g_pmw.pmw01

   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01
   END IF

END FUNCTION
 
FUNCTION i252_pmx08(p_cmd)  #料件編號
   DEFINE   l_ima02     LIKE ima_file.ima02,
            l_ima44     LIKE ima_file.ima44,
            l_ima021    LIKE ima_file.ima021,
            l_imaacti   LIKE ima_file.imaacti,
            p_cmd       LIKE type_file.chr1

   LET g_errno = ' '
   SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
     FROM ima_file WHERE ima01 = g_pmx[l_ac].pmx08

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                  LET l_ima02 = NULL
                                  LET l_ima44 = NULL
        WHEN l_imaacti='N'        LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF p_cmd = 'a' THEN
      LET g_pmx[l_ac].pmx09 = l_ima44
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmx[l_ac].pmx08[1,4]='MISC' THEN
      LET g_pmx[l_ac].pmx081 = l_ima02
      LET g_pmx[l_ac].pmx082 = l_ima021
      DISPLAY BY NAME g_pmx[l_ac].pmx081
      DISPLAY BY NAME g_pmx[l_ac].pmx082
   END IF

END FUNCTION
 
FUNCTION i252_pmx09()  #單位
   DEFINE   l_gfeacti  LIKE gfe_file.gfeacti

   LET g_errno = " "
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_pmx[l_ac].pmx09
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                           LET l_gfeacti = NULL
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION
 
FUNCTION i252_b_askkey()
   DEFINE   l_wc2   STRING

   CONSTRUCT l_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,
                      pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082
                 FROM s_pmx[1].pmx02,s_pmx[1].pmx08,s_pmx[1].pmx09,
                      s_pmx[1].ima44,s_pmx[1].ima908,
                      s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                      s_pmx[1].pmx06,s_pmx[1].pmx06t,
                      s_pmx[1].pmx07,s_pmx[1].pmx082
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
           WHEN INFIELD(pmx12) #廠商編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form ="q_pmc2"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmx12
             NEXT FIELD pmx12
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
        CALL cl_qbe_select()

      ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   LET l_wc2 = l_wc2 CLIPPED," AND pmx11 ='",g_pmx11,"'"

   CALL i252_b_fill(l_wc2)

END FUNCTION

FUNCTION i252_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,pmx09,'    ','    ',pmx04,pmx05,pmx03,",
               " pmx06,pmx06t,pmx07  FROM pmx_file",
               " WHERE pmx01 ='",g_pmw.pmw01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pmx08,pmx02,pmx04 "
   DISPLAY g_sql

   PREPARE i252_pb FROM g_sql
   DECLARE pmx_cs CURSOR FOR i252_pb

   CALL g_pmx.clear()                    #清空單身資料
   LET g_cnt = 1

   FOREACH pmx_cs INTO g_pmx[g_cnt].*    #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   
      SELECT pmc03 INTO g_pmx[g_cnt].pmc03 FROM pmc_file
       WHERE pmc01 = g_pmx[g_cnt].pmx12
      IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pmc_file",g_pmx[g_cnt].pmc03,"",SQLCA.sqlcode,"","",0)
        LET g_pmx[g_cnt].pmc03 = NULL
      END IF

      SELECT ima44,ima908 INTO g_pmx[g_cnt].ima44,g_pmx[g_cnt].ima908
        FROM ima_file
       WHERE ima01 = g_pmx[g_cnt].pmx08
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN          #最大單身筆數限制
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmx.deleteElement(g_cnt)       #刪除最後新增的空白列
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i252_copy()
   DEFINE   l_newno     LIKE pmw_file.pmw01,
            l_newdate   LIKE pmw_file.pmw06,
            l_oldno     LIKE pmw_file.pmw01
   DEFINE   li_result   LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL i252_set_entry('a')

   CALL cl_set_head_visible("","YES")    #預設單頭區塊開啟
   INPUT l_newno,l_newdate FROM pmw01,pmw06
      BEFORE INPUT                       #設定單別format(幾碼)
         CALL cl_set_docno_format("pmw01")

      AFTER FIELD pmw01                  #單據編號檢查
         CALL s_check_no("apm",l_newno,"","6","pmw_file","pmw01","")
         RETURNING li_result,l_newno
         DISPLAY l_newno TO pmw01
         IF (NOT li_result) THEN
            LET g_pmw.pmw01 = g_pmw_o.pmw01
            NEXT FIELD pmw01
         END IF
         DISPLAY g_smy.smydesc TO smydesc      #單據名稱

      AFTER FIELD pmw06
         IF cl_null(l_newdate) THEN NEXT FIELD pmw06 END IF
         BEGIN WORK
         #自動賦予單據編號，及檢查編號是否正確
         CALL s_auto_assign_no("apm",l_newno,l_newdate,"","pmw_file","pmw01","","","")
         RETURNING li_result,l_newno
         IF (NOT li_result) THEN
            NEXT FIELD pmw01
         END IF
         DISPLAY l_newno TO pmw01

      ON ACTION controlp
         CASE
            WHEN INFIELD(pmw01) #單據編號
               LET g_t1=s_get_doc_no(l_newno)
               CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1
               LET l_newno=g_t1
               DISPLAY BY NAME l_newno
               NEXT FIELD pmw01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pmw.pmw01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y

   SELECT * FROM pmw_file    #單頭複製
    WHERE pmw01=g_pmw.pmw01
     INTO TEMP y

   UPDATE y
       SET pmw01=l_newno,    #新的鍵值
           pmw06=l_newdate,  #新的鍵值
           pmwuser=g_user,   #資料所有者
           pmwgrup=g_grup,   #資料所有者所屬群
           pmwmodu=NULL,     #資料修改日期
           pmwdate=g_today,  #資料建立日期
           pmwacti='Y'       #有效資料

   INSERT INTO pmw_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmw_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x

   SELECT * FROM pmx_file         #單身複製
       WHERE pmx01=g_pmw.pmw01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET pmx01=l_newno

   INSERT INTO pmx_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      ROLLBACK WORK
      CALL cl_err3("ins","pmx_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pmw.pmw01
   SELECT ROWID,pmw_file.* INTO g_pmw_rowid,g_pmw.* FROM pmw_file WHERE pmw01 = l_newno
   CALL i252_u()                         #複製完後，修改新的單頭資料
   CALL i252_b()                         #接著維護新的單身資料
   SELECT ROWID,pmw_file.* INTO g_pmw_rowid,g_pmw.* FROM pmw_file WHERE pmw01 = l_oldno
   CALL i252_show()                      #最後顯示複製的舊資料於畫面上

END FUNCTION

FUNCTION i252_out()
   DEFINE   l_i           LIKE type_file.num5,
            sr            RECORD
                pmw01     LIKE pmw_file.pmw01,   #單據編號
                pmx12     LIKE pmx_file.pmx12,   #廠商編號
                pmc03     LIKE pmc_file.pmc03,   #廠商簡稱
                pmw04     LIKE pmw_file.pmw04,   #交易幣別
                pmw06     LIKE pmw_file.pmw06,   #詢價日期
                pmwacti   LIKE pmw_file.pmwacti, #資料有效碼
                pmx02     LIKE pmx_file.pmx02,   #項次
                pmx08     LIKE pmx_file.pmx08,   #料件編號
                pmx081    LIKE pmx_file.pmx081,  #品名
                pmx082    LIKE pmx_file.pmx082,  #規格
                pmx10     LIKE pmx_file.pmx10,
                pmx09     LIKE pmx_file.pmx09,   #詢價單位
                pmx06     LIKE pmx_file.pmx06,   #採購價格
                pmx03     LIKE pmx_file.pmx03,   #上限數量
                pmx07     LIKE pmx_file.pmx07,   #折扣比率
                pmx04     LIKE pmx_file.pmx04,   #生效日期
                pmx05     LIKE pmx_file.pmx05,   #失效日期
                pmw05     LIKE pmw_file.pmw05,   #稅別
                pmw051    LIKE pmw_file.pmw051,  #稅率
                pmx06t    LIKE pmx_file.pmx06t,  #含稅單價
                gec07     LIKE gec_file.gec07    #含稅否
                          END RECORD,
            l_name        LIKE type_file.chr20,  #External(Disk) file name
            l_za05        LIKE za_file.za05,
            l_azi03       LIKE azi_file.azi03

   IF cl_null(g_pmw.pmw01) THEN
       CALL cl_err('','9057',0)
       RETURN
   END IF
   IF cl_null(g_wc) THEN
       LET g_wc ="  pmw01='",g_pmw.pmw01,"'"
       LET g_wc2=" 1=1 AND pmx11=' ",g_pmx11,"'"
   END IF
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   CALL cl_del_data(l_table)             #清空Crystal Report temp table內的資料
   #以下要將列印的資料傳送到temp table內
   LET  g_sql="INSERT INTO ds_report.",l_table CLIPPED," VALUES(?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   LET g_sql="SELECT pmw01,pmx12,pmc03,pmw04,pmw06,pmwacti,",
         " pmx02,pmx08,pmx081,pmx082,pmx10,pmx09,pmx06,pmx03,pmx07,pmx04,pmx05,",
         " pmw05,pmw051,pmx06t,gec07",
         " FROM pmw_file,pmx_file,OUTER pmc_file,OUTER gec_file",
         " WHERE pmx01 = pmw01 AND pmx12=pmc_file.pmc01 AND ",g_wc CLIPPED,
         "   AND pmw05 = gec_file.gec01 AND ",g_wc2 CLIPPED
   LET g_sql = g_sql CLIPPED," ORDER BY pmw01,pmx02"
   PREPARE i252_p1 FROM g_sql                # RUNTIME 編譯
   IF STATUS THEN CALL cl_err('i252_p1',STATUS,0) END IF

   DECLARE i252_co                         # CURSOR
       CURSOR FOR i252_p1


   FOREACH i252_co INTO sr.*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
          END IF
      SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01=sr.pmw04
      EXECUTE insert_prep USING sr.*,l_azi03
   END FOREACH
   CALL cl_wcchp(g_wc,'pmw01,pmw06,pmw04,pmw05,pmw051,pmwuser,pmwgrup,pmwmodu,pmwdate,pmwacti')                 
        RETURNING  g_wc
   LET g_str = g_wc
   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('apmi252','apmi252',g_sql,g_str)   #利用Crystal Report列印

   CLOSE i252_co
   ERROR ""
END FUNCTION
