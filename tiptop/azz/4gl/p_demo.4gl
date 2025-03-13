# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: p_demo.4gl
# Descriptions...: 採購料件詢價維護作業 (Demo 自定義欄位功能)
# Date & Author..: 97/02/01 By saki FUN-710055 
# Modify.........: No.FUN-670045 07/04/26 By saki 重新整理範例
# Modify.........: No.FUN-660164 07/06/07 By saki 指定筆的確定/取消兩個button重現 範例
# Modify.........: No.FUN-770104 07/07/27 By saki 串查功能程式段簡化
# Modify.........: No.TQC-7B0139 07/11/27 By saki 移除行業別欄位,換自定義欄位
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10057 10/01/12 By tsai_yen 1.單頭改用pmw01為key; 2.單身加key:pmx13; 3.p_demo.4gl的INPUT ARRAY g_pmx有CALL cl_reference,必須設UNBUFFERED
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmw         RECORD LIKE pmw_file.*,       #簽核等級 (單頭)
       g_pmw_t       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw_o       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw01_t     LIKE pmw_file.pmw01,          #簽核等級 (舊值)
       g_t1          LIKE oay_file.oayslip,        #MOD-540182  #No.FUN-680136 VARCHAR(5)
       g_sheet       LIKE oay_file.oayslip,        #No.FUN-680136 VARCHAR(5) #單別 (沿用)
       g_ydate       LIKE type_file.dat,           #No.FUN-680136 DATE    #單據日期(沿用)
       g_pmx         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #FUN-A10057
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193 採購單位
           ima908    LIKE ima_file.ima908,         #FUN-560193 計價單位
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_t       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #FUN-A10057
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193
           ima908    LIKE ima_file.ima908,         #FUN-560193
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_o       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名規格
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #FUN-A10057
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193
           ima908    LIKE ima_file.ima908,         #FUN-560193
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 SMALLINT
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_gec07             LIKE gec_file.gec07    #FUN-550019
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #總筆數  #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10   #查詢指定的筆數  #No.FUN-680136 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #是否開啟指定筆視窗  #No.FUN-680136 SMALLINT      #No.FUN-6A0067
DEFINE g_argv1             LIKE pmw_file.pmw01    #No.FUN-680136 VARCHAR(16) #單號 #TQC-630074
DEFINE g_argv2             STRING               #指定執行的功能 #TQC-630074
DEFINE g_argv3             LIKE pmx_file.pmx11  #No.FUN-670099
DEFINE g_pmx11             LIKE pmx_file.pmx11  #No.FUN-670099
DEFINE g_query_flag        LIKE type_file.num5   #No.FUN-670045
#No.TQC-7B0139 --start--
DEFINE g_imaud01       LIKE ima_file.imaud01
DEFINE g_imaud02       LIKE ima_file.imaud02
DEFINE g_imaud07       LIKE ima_file.imaud07
DEFINE g_imaud13       LIKE ima_file.imaud13
#No.TQC-7B0139 ---end---
 
#主程式開始
MAIN
   DEFINE l_time   LIKE type_file.chr8             #計算被使用時間  #No.FUN-680136 VARCHAR(8)
 
   OPTIONS                               #改變一些系統預設值
      FIELD ORDER FORM,                  #依照tabIndex順序輸入
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理 FUN-710055
 
   #LET g_pmx11 = "2"  #FUN-A10057 mark
   LET g_pmx11 = "1"   #FUN-A10057
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)   
 
   CALL cl_used(g_prog,l_time,1) RETURNING l_time   #計算使用時間 (進入時間)
     
 
   #LET g_forupd_sql = "SELECT * FROM pmw_file WHERE ROWID = ? FOR UPDATE"   #FUN-A10057 mark
   LET g_forupd_sql = "SELECT * FROM pmw_file WHERE pmw01 = ? FOR UPDATE"   #FUN-A10057
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i252_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW demo_w AT p_row,p_col WITH FORM "azz/42f/p_demo"
     ATTRIBUTE (STYLE = "p_demo") #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN 
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
 
   IF (g_sma.sma116 MATCHES '[02]') THEN
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
 
   IF g_pmx11 = "1" THEN
      CALL cl_set_comp_visible("pmx10,pmx13",FALSE)   #FUN-A10057 add pmx13
   END IF
 
   LET g_ydate = NULL
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
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
 
   CALL i252_menu()
   CLOSE WINDOW i252_w                 #結束畫面
 
   CALL cl_used(g_prog,l_time,2) RETURNING l_time  #計算使用時間 (退出時間)
 
END MAIN
 
#QBE 查詢資料
FUNCTION i252_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM 
   CALL g_pmx.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " pmw01 = '",g_argv1,"'"  #FUN-580120
   ELSE
      CALL cl_set_head_visible("","YES")
      CONSTRUCT BY NAME g_wc ON pmw01,pmw06,pmw04,pmw05,pmw051,
                                pmwuser,pmwgrup,pmwmodu,pmwdate,pmwacti,
                                imaud01,imaud02,imaud07,imaud13         #No.TQC-7B0139
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(pmw01) #詢價單號   #MOD-4A0252
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw01
                  NEXT FIELD pmw01
 
               WHEN INFIELD(pmw04) #幣別
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw04
                  NEXT FIELD pmw04
      
               WHEN INFIELD(pmw05)   #稅別
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw05
                  NEXT FIELD pmw05
 
               #No.TQC-7B0139 --start--
               WHEN INFIELD(imaud02)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaud02
                  NEXT FIELD imaud02
               #No.TQC-7B0139 ---end---
 
               OTHERWISE EXIT CASE
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
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pmwuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pmwgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND pmwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmwuser', 'pmwgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      #螢幕上取單身條件
      CONSTRUCT g_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,   #FUN-560193 add ima44,ima908  #FUN-650191
                         pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082,pmx13   #No.FUN-550019 #FUN-A10057 add pmx13
              FROM s_pmx[1].pmx02,s_pmx[1].pmx12,s_pmx[1].pmx08,s_pmx[1].pmx09,  #FUN-650191
                   s_pmx[1].ima44,s_pmx[1].ima908,
                   s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                   s_pmx[1].pmx06,s_pmx[1].pmx06t,s_pmx[1].pmx07,      #No.FUN-550019
                   s_pmx[1].pmx082,s_pmx[1].pmx13                      #No.FUN-550019 #FUN-A10057 add pmx13
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmx10)     #作業編號
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx10
                  NEXT FIELD pmx10
 
               WHEN INFIELD(pmx12) #廠商編號
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx12
                  NEXT FIELD pmx12
               
               ###FUN-A10057 START ###   
               WHEN INFIELD(pmx13) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_sga"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmx13
                 NEXT FIELD pmx13
               ###FUN-A10057 END ###
              
               WHEN INFIELD(pmx08)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx08
                  NEXT FIELD pmx08
 
               WHEN INFIELD(pmx09)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx09
                  NEXT FIELD pmx09
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
   
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   LET g_wc2 = g_wc2 CLIPPED," AND pmx11 ='",g_pmx11,"'"  #No.FUN-670099
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      #LET g_sql = "SELECT ROWID, pmw01 FROM pmw_file ",   #FUN-A10057 mark
      LET g_sql = "SELECT pmw01 FROM pmw_file ",           #FUN-A10057
                  " WHERE ", g_wc CLIPPED
                  #" ORDER BY 2"                           #FUN-A10057 mark
   ELSE                                    # 若單身有輸入條件
      #LET g_sql = "SELECT UNIQUE pmw_file.ROWID, pmw01 ", #FUN-A10057 mark
      LET g_sql = "SELECT DISTINCT pmw01 ",                #FUN-A10057
                  "  FROM pmw_file, pmx_file ",
                  " WHERE pmw01 = pmx01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
                  #" ORDER BY 2"                           #FUN-A10057 mark
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
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i252_bp("G")
      CASE g_action_choice
         WHEN "insert"
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
 
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmx),'','')
            END IF
 
         WHEN "related_document"  #相關文件
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
 
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN 
                 LET l_partnum = g_pmx[l_ac].pmx08 
                 LET l_supplierid = g_pmx[l_ac].pmx12
              END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i252_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmx TO s_pmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i252_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i252_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i252_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL i252_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL i252_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      #No.FUN-670045 --start--
      ON ACTION refresh
         CALL i252_query_refresh()
      #No.FUN-670045 ---end---
 
      #No.FUN-770104 --modify--
      &include "qry_string.4gl"
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
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10   #No.FUN-680136 INTEGER
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pmx.clear()
   LET g_wc = NULL #MOD-530329
   LET g_wc2= NULL #MOD-530329
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pmw.* LIKE pmw_file.*             #DEFAULT 設定
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
      LET g_pmw.pmworiu = g_user #FUN-980030
      LET g_pmw.pmworig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_pmw.pmwgrup=g_grup
      LET g_pmw.pmwdate=g_today
      LET g_pmw.pmwacti='Y'              #資料有效
      LET g_pmw.pmwplant = g_plant #FUN-980011 add
      LET g_pmw.pmwlegal = g_legal #FUN-980011 add
 
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
      CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","") RETURNING li_result,g_pmw.pmw01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_pmw.pmw01
 
      INSERT INTO pmw_file VALUES (g_pmw.*)
 
      LET g_ydate = g_pmw.pmw06                #備份上一筆交貨日期
      CALL s_get_doc_no(g_pmw.pmw01) RETURNING g_sheet
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK      #No:7857
         CALL cl_err3("ins","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      ELSE
         COMMIT WORK        #No:7857
         CALL cl_flow_notify(g_pmw.pmw01,'I')
      END IF
 
      #SELECT ROWID INTO g_pmw_rowid FROM pmw_file #FUN-A10057 mark
      #   WHERE pmw01 = g_pmw.pmw01                #FUN-A10057 mark
      LET g_pmw01_t = g_pmw.pmw01        #保留舊值
      LET g_pmw_t.* = g_pmw.*
      LET g_pmw_o.* = g_pmw.*
      CALL g_pmx.clear()
 
      LET g_rec_b = 0  #No.MOD-490280
      CALL i252_b()                   #輸入單身
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
 
   IF g_pmw.pmwacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmw01_t = g_pmw.pmw01
   BEGIN WORK
 
   #OPEN i252_cl USING g_pmw_rowid      #FUN-A10057 mark
   OPEN i252_cl USING g_pmw.pmw01    #FUN-A10057   
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
 
      CALL i252_i("u")                   #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmw.* = g_pmw_t.*
         CALL i252_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pmw.pmw01 != g_pmw01_t THEN   # 更改單號
         UPDATE pmx_file SET pmx01 = g_pmw.pmw01
            WHERE pmx01 = g_pmw01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmx_file",g_pmw01_t,"",SQLCA.sqlcode,"","pmx",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE pmw_file SET pmw_file.* = g_pmw.*
          WHERE pmw01 = g_pmw.pmw01      #FUN-A10057
         #WHERE ROWID = g_pmw_rowid      #FUN-A10057 mark
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'U')
 
   CALL i252_b_fill("1=1")
   CALL i252_bp_refresh()
 
END FUNCTION
 
FUNCTION i252_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
   DEFINE    li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_pmw.pmwuser,g_pmw.pmwmodu,
       g_pmw.pmwgrup,g_pmw.pmwdate,g_pmw.pmwacti
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,g_pmw.pmw05,g_pmw.pmw051,
         g_imaud01,g_imaud02,g_imaud07,g_imaud13 WITHOUT DEFAULTS    #No.TQC-7B0139
    FROM pmw01,pmw06,pmw04,pmw05,pmw051,
         imaud01,imaud02,imaud07,imaud13   #No.TQC-7B0139
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
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
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         END IF
 
      BEFORE FIELD pmw04
         LET g_pmw.pmw04 = "test"
         DISPLAY BY NAME g_pmw.pmw04
         NEXT FIELD NEXT
         CALL cl_set_comp_entry("pmw04",FALSE)
 
#     AFTER FIELD pmw04                  #幣別
#        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER FIELD pmw05                  #稅別
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         IF NOT cl_null(g_pmw.pmw05) THEN
            IF p_cmd = 'u' AND g_pmw_o.pmw051 != g_pmw.pmw051 THEN   
               #當修改單頭稅別時,要重計單身的詢價未稅單價欄位(pmx06)
               CALL i252_cal_price()
            END IF
            LET g_pmw_o.pmw05 = g_pmw.pmw05
         END IF
 
      #No.TQC-7B0139 --start--
      AFTER FIELD imaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.TQC-7B0139 ---end---
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmw01) #單據編號
                 LET g_t1=s_get_doc_no(g_pmw.pmw01)     #No.MOD-540182
                 CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1 #TQC-670008
                 LET g_pmw.pmw01 = g_t1                 #No.MOD-540182
                 DISPLAY BY NAME g_pmw.pmw01
                 CALL cl_reference("pmw01",g_pmw.pmw01) RETURNING li_result
                 NEXT FIELD pmw01
 
            WHEN INFIELD(pmw04) #幣別
               CALL cl_dynamic_qry() RETURNING g_pmw.pmw04
               DISPLAY BY NAME g_pmw.pmw04
               CALL cl_reference("pmw04",g_pmw.pmw04) RETURNING li_result
               NEXT FIELD pmw04
 
            WHEN INFIELD(pmw05) #稅別
               CALL cl_dynamic_qry() RETURNING g_pmw.pmw05
               DISPLAY BY NAME g_pmw.pmw05
               CALL cl_reference("pmw05",g_pmw.pmw05) RETURNING li_result
               NEXT FIELD pmw05
 
            #No.TQC-7B0139 --start--
            WHEN INFIELD(imaud02)
               CALL cl_dynamic_qry() RETURNING g_imaud02
               DISPLAY BY NAME g_imaud02
               NEXT FIELD imaud02
            #No.TQC-7B0139 ---end---
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i252_cal_price()
    DEFINE l_pmx02   LIKE pmx_file.pmx02,
           l_pmx06t  LIKE pmx_file.pmx06t,
           l_pmx06   LIKE pmx_file.pmx06
 
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
       LET l_pmx06 = cl_digcut(l_pmx06,t_azi03)  #No.CHI-6A0004
 
       UPDATE pmx_file SET pmx06 = l_pmx06 
                     WHERE pmx01 = g_pmw.pmw01 
                       AND pmx02 = l_pmx02
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","pmx_file",g_pmw.pmw01,l_pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
       END IF
    END FOREACH
 
END FUNCTION
 
FUNCTION i252_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmx.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i252_cs()
 
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
 
      CALL i252_fetch('F')                  # 讀出TEMP第一筆並顯示
      LET g_query_flag = TRUE               #No.FUN-670045
   END IF
 
END FUNCTION
 
FUNCTION i252_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
DEFINE   li_accept    LIKE type_file.num5               #No.FUN-660164
DEFINE   li_cancel    LIKE type_file.num5               #No.FUN-660164
 
   CASE p_flag
      ###FUN-A10057 mark START ###
      #WHEN 'N' FETCH NEXT     i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      #WHEN 'P' FETCH PREVIOUS i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      #WHEN 'F' FETCH FIRST    i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      #WHEN 'L' FETCH LAST     i252_cs INTO g_pmw_rowid,g_pmw.pmw01
      ###FUN-A10057 END ###
      ###FUN-A10057 mark START ###
      WHEN 'N' FETCH NEXT     i252_cs INTO g_pmw.pmw01
      WHEN 'P' FETCH PREVIOUS i252_cs INTO g_pmw.pmw01
      WHEN 'F' FETCH FIRST    i252_cs INTO g_pmw.pmw01
      WHEN 'L' FETCH LAST     i252_cs INTO g_pmw.pmw01
      ###FUN-A10057 END ###
      WHEN '/'
            IF (NOT mi_no_ask) THEN      #No.FUN-6A0067
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                #No.FUN-660164 --start--
                #不直接啟用/關閉，是因為可能有非標準做法，原本的確定/取消是開啟的
                LET li_accept = cl_detect_act_visible("accept")
                LET li_cancel = cl_detect_act_visible("cancel")
                IF NOT li_accept THEN
                   CALL cl_set_act_visible("accept",TRUE)
                END IF
                IF NOT li_cancel THEN
                   CALL cl_set_act_visible("cancel",TRUE)
                END IF
                #No.FUN-660164 ---end---
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
                #No.FUN-660164 --start--
                IF NOT li_accept THEN
                   CALL cl_set_act_visible("accept",FALSE)
                END IF
                IF NOT li_cancel THEN
                   CALL cl_set_act_visible("cancel",FALSE)
                END IF
                #No.FUN-660164 ---end---
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   LET g_jump = g_curs_index   #No.FUN-660164
                   EXIT CASE
                END IF
            END IF
            #FETCH ABSOLUTE g_jump i252_cs INTO g_pmw_rowid,g_pmw.pmw01   #FUN-A10057 mark
            FETCH ABSOLUTE g_jump i252_cs INTO g_pmw.pmw01   #FUN-A10057
            LET mi_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)
      INITIALIZE g_pmw.* TO NULL               #No.FUN-6A0162
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   #SELECT * INTO g_pmw.* FROM pmw_file WHERE ROWID = g_pmw_rowid  #FUN-A10057 mark
   SELECT * INTO g_pmw.* FROM pmw_file WHERE pmw01 = g_pmw.pmw01   #FUN-A10057
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pmw.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_pmw.pmwuser      #FUN-4C0056 add
   LET g_data_group = g_pmw.pmwgrup      #FUN-4C0056 add
   LET g_data_plant = g_pmw.pmwplant     #FUN-980030
 
   CALL i252_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i252_show()
   DEFINE   li_result   LIKE type_file.num5    #No.FUN-710055
 
   LET g_pmw_t.* = g_pmw.*                #保存單頭舊值
   LET g_pmw_o.* = g_pmw.*                #保存單頭舊值
   DISPLAY BY NAME g_pmw.pmworiu,g_pmw.pmworig, g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,                #FUN-650191
                   g_pmw.pmwuser,g_pmw.pmwgrup,g_pmw.pmwmodu,
                   g_pmw.pmwdate,g_pmw.pmwacti,
                   g_pmw.pmw05,g_pmw.pmw051           #No.FUN-550019
 
   CALL cl_reference("pmw01",g_pmw.pmw01) RETURNING li_result
   CALL cl_reference("pmw04",g_pmw.pmw04) RETURNING li_result
   CALL cl_reference("pmw05",g_pmw.pmw05) RETURNING li_result
 
   CALL i252_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
   #OPEN i252_cl USING g_pmw_rowid   #FUN-A10057 mark
   OPEN i252_cl USING g_pmw.pmw01    #FUN-A10057
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i252_cl INTO g_pmw.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i252_show()
 
   IF cl_exp(0,0,g_pmw.pmwacti) THEN                   #確認一下
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
         CALL cl_err3("upd","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_pmw.pmwacti=g_chr
      END IF
   END IF
 
   CLOSE i252_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pmw.pmw01,'V')
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
       WHERE pmw01 = g_pmw.pmw01
   IF g_pmw.pmwacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   #OPEN i252_cl USING g_pmw_rowid   #FUN-A10057 mark
   OPEN i252_cl USING g_pmw.pmw01    #FUN-A10057
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i252_cl INTO g_pmw.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i252_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pmw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pmw.pmw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01
      DELETE FROM pmx_file WHERE pmx01 = g_pmw.pmw01
      CLEAR FORM
      CALL g_pmx.clear()
      OPEN i252_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i252_cl
          CLOSE i252_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
      FETCH i252_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i252_cl
          CLOSE i252_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i252_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i252_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      #No.FUN-6A0067
         CALL i252_fetch('/')
      END IF
   END IF
 
   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'D')
END FUNCTION
 
#單身
FUNCTION i252_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_n1            LIKE type_file.num5,    #FUN-A10057
    l_cnt           LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE gef_file.gef01,    #No.FUN-680136 VARCHAR(04)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    l_pmc05         LIKE pmc_file.pmc05,    #FUN-650191
    l_pmc30         LIKE pmc_file.pmc30     #FUN-650191
DEFINE   li_result  LIKE type_file.num5     #No.FUN-710055
 
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
 
    LET g_forupd_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,pmx13,pmx09,'','',pmx04,", #FUN-560193  #No.FUN-670099  #FUN-650191 add pmx12,pmc03 #FUN-A10057 add pmx13
                       "       pmx05,pmx03,pmx06,pmx06t,pmx07 ",  #No.FUN-550019
                       "  FROM pmx_file",
                       "  WHERE pmx01=? AND pmx02=? ",
                       "   AND pmx11='",g_pmx11,"' FOR UPDATE"  #No.FUN-670099
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i252_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmx WITHOUT DEFAULTS FROM s_pmx.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.FUN-710055
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           #OPEN i252_cl USING g_pmw_rowid   #FUN-A10057 mark
           OPEN i252_cl USING g_pmw.pmw01    #FUN-A10057
           IF STATUS THEN
              CALL cl_err("OPEN i252_cl:", STATUS, 1)
              CLOSE i252_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i252_cl INTO g_pmw.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i252_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pmx_t.* = g_pmx[l_ac].*  #BACKUP
              LET g_pmx_o.* = g_pmx[l_ac].*  #BACKUP
              OPEN i252_bcl USING g_pmw.pmw01,g_pmx_t.pmx02
              IF STATUS THEN
                 CALL cl_err("OPEN i252_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i252_bcl INTO g_pmx[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pmx_t.pmx02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL cl_reference("pmx12",g_pmx[l_ac].pmx12) RETURNING li_result
                 SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                   FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              CALL i252_set_entry_b(p_cmd)    #No.FUN-610018
              CALL i252_set_no_entry_b(p_cmd) #No.FUN-610018
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pmx[l_ac].* TO NULL      #900423
           LET g_pmx[l_ac].pmx03 =  0            #Body default
           LET g_pmx[l_ac].pmx06 =  0            #Body default
           LET g_pmx[l_ac].pmx06t=  0            #No.FUN-550019
           LET g_pmx[l_ac].pmx07 =  0            #Body default
           LET g_pmx[l_ac].pmx10 = " "           #FUN-A10057
           LET g_pmx[l_ac].pmx13 = " "           #FUN-A10057
           LET g_pmx_t.* = g_pmx[l_ac].*         #新輸入資料
           LET g_pmx_o.* = g_pmx[l_ac].*         #新輸入資料
           IF l_ac > 1 THEN
              LET g_pmx[l_ac].pmx04 = g_pmx[l_ac-1].pmx04
           ELSE
              LET g_pmx[l_ac].pmx04 = g_pmw.pmw06
           END IF
           CALL cl_show_fld_cont()         #FUN-550037(smin)
           CALL i252_set_entry_b(p_cmd)    #No.FUN-610018
           CALL i252_set_no_entry_b(p_cmd) #No.FUN-610018
           NEXT FIELD pmx02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_pmx[l_ac].pmx10) THEN
              LET g_pmx[l_ac].pmx10 = " "
           END IF
           INSERT INTO pmx_file(pmx01,pmx02,pmx03,pmx04,pmx05,pmx06,
                                pmx06t,pmx07,pmx08,pmx09,pmx10,pmx13,pmx11,pmx081,pmx082,pmx12,  #No.FUN-550019  #No.FUN-670099  #FUN-650191 add pmx12 #FUN-A10057 add pmx13
                                pmxplant,pmxlegal)   #FUN-980011 add
           VALUES(g_pmw.pmw01,g_pmx[l_ac].pmx02,
                  g_pmx[l_ac].pmx03,g_pmx[l_ac].pmx04,
                  g_pmx[l_ac].pmx05,g_pmx[l_ac].pmx06,
                  g_pmx[l_ac].pmx06t,                     #No.FUN-550019
                  g_pmx[l_ac].pmx07,g_pmx[l_ac].pmx08,
                  g_pmx[l_ac].pmx09,g_pmx[l_ac].pmx10,g_pmx[l_ac].pmx13,g_pmx11,  #No.FUN-670099 #FUN-A10057 add pmx13
                  g_pmx[l_ac].pmx081,g_pmx[l_ac].pmx082,g_pmx[l_ac].pmx12,  #FUN-650191 add pmx12
                  g_plant,g_legal)    #FUN-980011 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pmx_file",g_pmw.pmw01,g_pmx[l_ac].pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD pmx02                        #default 序號
           IF g_pmx[l_ac].pmx02 IS NULL OR g_pmx[l_ac].pmx02 = 0 THEN
              SELECT max(pmx02)+1
                INTO g_pmx[l_ac].pmx02
                FROM pmx_file
               WHERE pmx01 = g_pmw.pmw01
              IF g_pmx[l_ac].pmx02 IS NULL THEN
                 LET g_pmx[l_ac].pmx02 = 1
              END IF
           END IF
 
        AFTER FIELD pmx02                        #check 序號是否重複
           IF NOT cl_null(g_pmx[l_ac].pmx02) THEN
              IF g_pmx[l_ac].pmx02 != g_pmx_t.pmx02
                 OR g_pmx_t.pmx02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pmx_file
                  WHERE pmx01 = g_pmw.pmw01
                    AND pmx02 = g_pmx[l_ac].pmx02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pmx[l_ac].pmx02 = g_pmx_t.pmx02
                    NEXT FIELD pmx02
                 END IF
              END IF
           END IF
 
      AFTER FIELD pmx12                       #廠商編號
         IF NOT cl_null(g_pmx[l_ac].pmx12) THEN
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
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
 
        BEFORE FIELD pmx08
           CALL i252_set_entry_b(p_cmd)
 
        AFTER FIELD pmx08                  #料件編號
           LET l_misc=g_pmx[l_ac].pmx08[1,4]
           IF g_pmx[l_ac].pmx08[1,4]='MISC' THEN
              SELECT COUNT(*) INTO l_n FROM ima_file
               WHERE ima01=l_misc
                 AND ima01='MISC'
              IF l_n=0 THEN
                 CALL cl_err('','aim-806',0)
                 NEXT FIELD pmx08
              END IF
           END IF
           IF NOT cl_null(g_pmx[l_ac].pmx08) THEN
              IF g_pmx_o.pmx08 IS NULL OR g_pmx_o.pmx081 IS NULL OR
                (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) THEN
                 CALL cl_reference("pmx08",g_pmx[l_ac].pmx08) RETURNING li_result
                 SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                 FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
                 IF NOT cl_null(g_errno)
                    AND g_pmx[l_ac].pmx08[1,4] !='MISC' THEN  #NO:6808
                    CALL cl_err(g_pmx[l_ac].pmx08,g_errno,0)
                    LET g_pmx[l_ac].pmx08 = g_pmx_o.pmx08
                    DISPLAY BY NAME g_pmx[l_ac].pmx08
                    NEXT FIELD pmx08
                 END IF
              END IF
           END IF
           LET g_pmx_o.pmx08 = g_pmx[l_ac].pmx08
           CALL i252_set_no_entry_b(p_cmd)
 
        AFTER FIELD pmx10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           ###FUN-A10057 START ###
           IF cl_null(g_pmx[l_ac].pmx10) THEN
              LET g_pmx[l_ac].pmx10 =" " 
           END IF
           ###FUN-A10057 END ###
           IF g_pmx_o.pmx081 IS NULL OR g_pmx_o.pmx08 IS NULL OR
             (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) OR
             (g_pmx[l_ac].pmx081 != g_pmx_o.pmx081 ) THEN
              SELECT COUNT(*) INTO l_cnt FROM pmx_file
               WHERE pmx01=g_pmw.pmw01
                 AND pmx08=g_pmx[l_ac].pmx08
                 AND pmx081=g_pmx[l_ac].pmx081
                 AND pmx10=g_pmx[l_ac].pmx10
                 AND pmx11=g_pmx11
                 AND pmx12=g_pmx[l_ac].pmx12   #No.TQC-740192
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD pmx10
              END IF
           END IF
           ###FUN-A10057 START ###
           IF NOT cl_null(g_pmx[l_ac].pmx13) AND g_pmx[l_ac].pmx13 != " " THEN
               IF g_pmx[l_ac].pmx10 IS NULL OR g_pmx[l_ac].pmx10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD pmx10
              END IF
           END IF
           ###FUN-A10057 END ###
 
        AFTER FIELD pmx09                  #詢價單位
           IF NOT cl_null(g_pmx[l_ac].pmx09) THEN
              IF g_pmx[l_ac].pmx09 IS NULL OR g_pmx_t.pmx09 IS NULL OR
                 (g_pmx[l_ac].pmx09 != g_pmx_o.pmx09) THEN
                 IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
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
 
        AFTER FIELD pmx03                 #下限數量
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
                       AND pmx11 =  g_pmx11  #No.FUN-670099
                 END IF
                 IF g_pmx[l_ac].pmx05 IS NULL THEN
                    SELECT COUNT(*) INTO l_cnt FROM pmx_file
                     WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
                        OR (pmx05 IS NULL))
                       AND pmx08 = g_pmx[l_ac].pmx08
                       AND pmx09 = g_pmx[l_ac].pmx09
                       AND pmx03 = g_pmx[l_ac].pmx03
                       AND pmx01 = g_pmw.pmw01
                       AND pmx03[1,4] <> 'MISC' #NO:7276
                       AND pmx11 =  g_pmx11  #No.FUN-670099
                       AND pmx10 =  g_pmx[l_ac].pmx10  #No.FUN-670099
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
                       AND pmx11 =  g_pmx11  #No.FUN-670099
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
                       AND pmx11 =  g_pmx11  #No.FUN-670099
                       AND pmx10 =  g_pmx[l_ac].pmx10  #No.FUN-670099
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
              LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)  #幣別取位  #No.CHI-6A0004
              DISPLAY BY NAME g_pmx[l_ac].pmx06
              LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
              LET g_pmx[l_ac].pmx06t = g_pmx[l_ac].pmx06 * (1 + g_pmw.pmw051/100)
              LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t
           END IF
 
        AFTER FIELD pmx06t                  #詢價單價
           IF NOT cl_null(g_pmx[l_ac].pmx06t) THEN
              IF g_pmx[l_ac].pmx06t <= 0 THEN
                 CALL cl_err(g_pmx[l_ac].pmx06t,'mfg3291',0)
                 LET g_pmx[l_ac].pmx06t = g_pmx_o.pmx06t
                 NEXT FIELD pmx06t
              END IF
              LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t
 
              LET g_pmx[l_ac].pmx06 = g_pmx[l_ac].pmx06t / (1 + g_pmw.pmw051/100)
              LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
           END IF
 
        AFTER FIELD pmx07                 #折扣比率
           IF NOT cl_null(g_pmx[l_ac].pmx07) THEN
              IF g_pmx[l_ac].pmx07 < 0 OR g_pmx[l_ac].pmx07 >= 100 THEN
                 CALL cl_err(g_pmx[l_ac].pmx07,'mfg0013',0)
                 LET g_pmx[l_ac].pmx07 = g_pmx_o.pmx07
                 DISPLAY BY NAME g_pmx[l_ac].pmx07
                 NEXT FIELD pmx07
              END IF
              LET g_pmx_o.pmx07 = g_pmx[l_ac].pmx07
           END IF
        
        ###FUN-A10057 START ###
        AFTER FIELD pmx13
           IF cl_null(g_pmx[l_ac].pmx13) THEN
              LET g_pmx[l_ac].pmx13 = " "
           END IF
           IF NOT cl_null(g_pmx[l_ac].pmx13) AND g_pmx[l_ac].pmx13 != " " THEN
              SELECT count(*) INTO l_n1 FROM sga_file
               WHERE sga01 = g_pmx[l_ac].pmx13
                 AND sgaacti = 'Y'
              IF l_n1 = 0 THEN
                 CALL cl_err('','apm-105',0)
                 NEXT FIELD pmx13
              END IF
               IF g_pmx[l_ac].pmx10 IS NULL OR g_pmx[l_ac].pmx10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD pmx10
              END IF
           END IF
        ###FUN-A10057 END ###
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_pmx_t.pmx02 > 0 AND g_pmx_t.pmx02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pmx_file
               WHERE pmx01 = g_pmw.pmw01
                 AND pmx02 = g_pmx_t.pmx02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
           IF l_lock_sw = 'Y' THEN
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
                                  pmx06t=g_pmx[l_ac].pmx06t,    #No.FUN-550019
                                  pmx07=g_pmx[l_ac].pmx07,
                                  pmx08=g_pmx[l_ac].pmx08,
                                  pmx09=g_pmx[l_ac].pmx09,
                                  pmx10=g_pmx[l_ac].pmx10,  #No.FUN-670099
                                  pmx13=g_pmx[l_ac].pmx13,  #FUN-A10057
                                  pmx11=g_pmx11,            #No.FUN-670099
                                  pmx081=g_pmx[l_ac].pmx081,
                                  pmx082=g_pmx[l_ac].pmx082,
                                  pmx12=g_pmx[l_ac].pmx12  #FUN-650191 add
               WHERE pmx01=g_pmw.pmw01
                 AND pmx02=g_pmx_t.pmx02
                 AND pmx11=g_pmx11
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmx[l_ac].* = g_pmx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pmx[l_ac].* = g_pmx_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_pmx.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE i252_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE i252_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmx02) AND l_ac > 1 THEN
              LET g_pmx[l_ac].* = g_pmx[l_ac-1].*
              LET g_pmx[l_ac].pmx02 = g_rec_b + 1
              NEXT FIELD pmx02
           END IF
 
        ON ACTION CONTROLR
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
               CALL cl_dynamic_qry() RETURNING g_pmx[l_ac].pmx12
               DISPLAY BY NAME g_pmx[l_ac].pmx12
               CALL cl_reference("pmx12",g_pmx[l_ac].pmx12) RETURNING li_result
               NEXT FIELD pmx12
 
              WHEN INFIELD(pmx08) #料件編號
                 CALL cl_dynamic_qry() RETURNING g_pmx[l_ac].pmx08
                 DISPLAY BY NAME g_pmx[l_ac].pmx08              #No.MOD-490371
                 IF NOT cl_null(g_pmx[l_ac].pmx08) AND
                    g_pmx[l_ac].pmx08[1,4] !='MISC' THEN
                    CALL cl_reference("pmx08",g_pmx[l_ac].pmx08) RETURNING li_result
                 END IF
                 NEXT FIELD pmx08
 
              WHEN INFIELD(pmx09) #詢價單位
                 CALL cl_dynamic_qry() RETURNING g_pmx[l_ac].pmx09
                 DISPLAY BY NAME g_pmx[l_ac].pmx09
                 NEXT FIELD pmx09
                 
              ###FUN-A10057 START ###
              WHEN INFIELD(pmx13) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_sga"
                 LET g_qryparam.default1 = g_pmx[l_ac].pmx13
                 CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx13
                 DISPLAY BY NAME g_pmx[l_ac].pmx13
              ###FUN-A10057 END ###
                 
              WHEN INFIELD(pmx10)     #作業編號
                 CALL q_ecd(FALSE,TRUE,'') RETURNING g_pmx[l_ac].pmx10
                 DISPLAY BY NAME g_pmx[l_ac].pmx10
                 NEXT FIELD pmx10
               OTHERWISE EXIT CASE
            END CASE
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_pmw.pmwmodu = g_user
    LET g_pmw.pmwdate = g_today
    UPDATE pmw_file SET pmwmodu = g_pmw.pmwmodu,pmwdate = g_pmw.pmwdate
     WHERE pmw01 = g_pmw.pmw01
    DISPLAY BY NAME g_pmw.pmwmodu,g_pmw.pmwdate
 
    CLOSE i252_bcl
    COMMIT WORK
    CALL i252_delall()
 
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
 
FUNCTION i252_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,
                       pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082,pmx13  #No.FUN-550019 #FUN-A10057 add pmx13
            FROM s_pmx[1].pmx02,s_pmx[1].pmx08,s_pmx[1].pmx09,
                 s_pmx[1].ima44,s_pmx[1].ima908,
                 s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                 s_pmx[1].pmx06,s_pmx[1].pmx06t,                 #No.FUN-550019
                 s_pmx[1].pmx07,s_pmx[1].pmx082,s_pmx[1].pmx13   #No.FUN-550019 #FUN-A10057 add pmx13
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(pmx12) #廠商編號
              CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmx12
              NEXT FIELD pmx12
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
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    LET l_wc2 = l_wc2 CLIPPED," AND pmx11 ='",g_pmx11,"'"  #No.FUN-670099
 
    CALL i252_b_fill(l_wc2) 
END FUNCTION
 

FUNCTION i252_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,pmx13,pmx09,'    ','    ',pmx04,pmx05,pmx03,", #FUN-560193  #No.FUN-670099  #FUN-650191 add pmx12,pmc03 #FUN-A10057 add pmx13
               " pmx06,pmx06t,pmx07  FROM pmx_file",    #No.FUN-550019
               " WHERE pmx01 ='",g_pmw.pmw01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pmx08,pmx02,pmx04 "
   DISPLAY g_sql
 
   PREPARE i252_pb FROM g_sql
   DECLARE pmx_cs CURSOR FOR i252_pb
 
   CALL g_pmx.clear()
   LET g_cnt = 1
 
   FOREACH pmx_cs INTO g_pmx[g_cnt].*   #單身 ARRAY 填充
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
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pmx.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i252_copy()
   DEFINE l_newno     LIKE pmw_file.pmw01,
          l_newdate   LIKE pmw_file.pmw06,
          l_oldno     LIKE pmw_file.pmw01
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i252_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno,l_newdate FROM pmw01,pmw06
       BEFORE INPUT
          CALL cl_set_docno_format("pmw01")
 
       AFTER FIELD pmw01
           CALL s_check_no("apm",l_newno,"","6","pmw_file","pmw01","") RETURNING li_result,l_newno
           DISPLAY l_newno TO pmw01
           IF (NOT li_result) THEN
              LET g_pmw.pmw01 = g_pmw_o.pmw01
              NEXT FIELD pmw01
           END IF
           DISPLAY g_smy.smydesc TO smydesc           #單據名稱
       AFTER FIELD pmw06
           IF cl_null(l_newdate) THEN NEXT FIELD pmw06 END IF
           BEGIN WORK #No:7857
           CALL s_auto_assign_no("apm",l_newno,l_newdate,"","pmw_file","pmw01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD pmw01
           END IF
           DISPLAY l_newno TO pmw01
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmw01) #單據編號
                LET g_t1=s_get_doc_no(l_newno)         #No.MOD-540182
                CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1 #TQC-670008
                LET l_newno=g_t1                       #No.MOD-540182
                DISPLAY BY NAME l_newno
                NEXT FIELD pmw01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pmw.pmw01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pmw_file         #單頭複製
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
      CALL cl_err3("ins","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET pmx01=l_newno
 
   INSERT INTO pmx_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      ROLLBACK WORK #No:7857
      CALL cl_err3("ins","pmx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   ELSE
       COMMIT WORK #No:7857
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pmw.pmw01
   #SELECT ROWID,* INTO g_pmw_rowid,g_pmw.* FROM pmw_file WHERE pmw01 = l_newno   #在i252_u()就會做了  #FUN-A10057 mark
   LET g_pmw.pmw01 = l_newno   #FUN-A10057
   CALL i252_u()
   CALL i252_b()
   #SELECT ROWID,* INTO g_pmw_rowid,g_pmw.* FROM pmw_file WHERE pmw01 = l_oldno   #FUN-A10057 mark
   #SELECT * INTO g_pmw.* FROM pmw_file WHERE pmw01 = l_oldno   #FUN-A10057 #FUN-C30027
   #CALL i252_show()  #FUN-C30027
 
END FUNCTION
 
FUNCTION i252_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    sr              RECORD
        pmw01       LIKE pmw_file.pmw01,   #單據編號
        pmx12       LIKE pmx_file.pmx12,   #廠商編號 #FUN-650191
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
        pmw04       LIKE pmw_file.pmw04,   #交易幣別
        pmw06       LIKE pmw_file.pmw06,   #詢價日期
        pmwacti     LIKE pmw_file.pmwacti, #資料有效碼
        pmx02       LIKE pmx_file.pmx02,   #項次
        pmx08       LIKE pmx_file.pmx08,   #料件編號
        pmx081      LIKE pmx_file.pmx081,  #品名
        pmx082      LIKE pmx_file.pmx082,  #規格      #MOD-640052
        pmx10       LIKE pmx_file.pmx10,   #No.FUN-670099
        pmx09       LIKE pmx_file.pmx09,   #詢價單位
        pmx06       LIKE pmx_file.pmx06,   #採購價格
        pmx03       LIKE pmx_file.pmx03,   #上限數量
        pmx07       LIKE pmx_file.pmx07,   #折扣比率
        pmx04       LIKE pmx_file.pmx04,   #生效日期
        pmx05       LIKE pmx_file.pmx05,   #失效日期
        pmw05       LIKE pmw_file.pmw05,   #稅別
        pmw051      LIKE pmw_file.pmw051,  #稅率
        pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
        gec07       LIKE gec_file.gec07    #含稅否
       END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-680136 VARCHAR(20)
    l_za05          LIKE za_file.za05                   #  #No.FUN-680136 VARCHAR(40)
    IF cl_null(g_pmw.pmw01) THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    IF cl_null(g_wc) THEN
        LET g_wc ="  pmw01='",g_pmw.pmw01,"'"
        LET g_wc2=" 1=1 AND pmx11=' ",g_pmx11,"'"
    END IF
    CALL cl_wait()
    CALL cl_outnam('apmi252') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT pmw01,pmx12,pmc03,pmw04,pmw06,pmwacti,",   #FUN-650191 pmw03->pmx12
          " pmx02,pmx08,pmx081,pmx082,pmx10,pmx09,pmx06,pmx03,pmx07,pmx04,pmx05,", #MOD-640052  #No.FUN-670099
          " pmw05,pmw051,pmx06t,gec07",
          " FROM pmw_file,pmx_file,OUTER pmc_file,OUTER gec_file",
          " WHERE pmx01 = pmw01 AND pmx12=pmc01 AND ",g_wc CLIPPED, #FUN-650191
          "   AND pmw05 = gec_file.gec01 AND ",g_wc2 CLIPPED
    PREPARE i252_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i252_p1',STATUS,0) END IF
 
    DECLARE i252_co                         # CURSOR
        CURSOR FOR i252_p1
 
    START REPORT i252_rep TO l_name
 
    FOREACH i252_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i252_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i252_rep
 
    CLOSE i252_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i252_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
    l_str1          LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(50) #No.FUN-680136 VARCHAR(50) #No.FUN-5A0139 add
    l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    sr              RECORD
        pmw01       LIKE pmw_file.pmw01,   #單據編號
        pmx12       LIKE pmx_file.pmx12,   #廠商編號  #FUN-650191
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
        pmw04       LIKE pmw_file.pmw04,   #交易幣別
        pmw06       LIKE pmw_file.pmw06,   #詢價日期
        pmwacti     LIKE pmw_file.pmwacti, #資料有效碼
        pmx02       LIKE pmx_file.pmx02,   #項次
        pmx08       LIKE pmx_file.pmx08,   #料件編號
        pmx081      LIKE pmx_file.pmx081,  #品名
        pmx082      LIKE pmx_file.pmx082,  #規格        #MOD-640052
        pmx10       LIKE pmx_file.pmx10,   #No.FUN-670099
        pmx09       LIKE pmx_file.pmx09,   #詢價單位
        pmx06       LIKE pmx_file.pmx06,   #採購價格
        pmx03       LIKE pmx_file.pmx03,   #上限數量
        pmx07       LIKE pmx_file.pmx07,   #折扣比率
        pmx04       LIKE pmx_file.pmx04,   #生效日期
        pmx05       LIKE pmx_file.pmx05,   #失效日期
        pmw05       LIKE pmw_file.pmw05,   #稅別
        pmw051      LIKE pmw_file.pmw051,  #稅率
        pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
        gec07       LIKE gec_file.gec07    #含稅否
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.pmw01,sr.pmx02
    FORMAT
        PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.pmw01  #單據編號
         IF (PAGENO > 1 OR LINENO > 9)
            THEN SKIP TO TOP OF PAGE
         END IF
         PRINTX name=H1
               g_x[31],g_x[52],g_x[32],g_x[33],g_x[34], #TQC-5B0037 52->40   #TQC-6C0031 40->52
               g_x[35],g_x[36],g_x[37],g_x[38]
         PRINTX name=H2
               g_x[41],g_x[40],g_x[42],g_x[43],g_x[44], #TQC-5B0037 40->52   #TQC-6C0031 52->40
               g_x[45],g_x[46]
         PRINTX name=H3
               g_x[47],g_x[51],g_x[48],g_x[53],g_x[49],g_x[50]  #No.FUN-610018
         PRINTX name=H4 
               g_x[54],g_x[55],g_x[56],g_x[57]     #MOD-640052  #No.FUN-670099
         PRINT g_dash1
         IF sr.pmwacti MATCHES'[Nn]'  THEN
            PRINTX name=D1
               COLUMN g_c[31],'*';
         END IF
         SELECT azi03,azi04,azi05
           INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取   #No.CHI-6A0004
           FROM azi_file
          WHERE azi01=sr.pmw04
         LET l_str1=sr.pmw051 USING '#############&','%'  #No.FUN-610018
         PRINTX name=D1
               COLUMN g_c[32],sr.pmw01,
               COLUMN g_c[33],sr.pmw06,  #單據編號,日期
               #COLUMN g_c[34],sr.pmw03,  #FUN-650191
               COLUMN g_c[34],sr.pmx12,   #FUN-650191
               COLUMN g_c[35],sr.pmc03,  #廠商
               COLUMN g_c[36],sr.pmw04;  #幣別
         PRINTX name=D1
               COLUMN g_c[37],sr.pmw05,
               COLUMN g_c[38],l_str1 CLIPPED
 
        ON EVERY ROW
         PRINTX name=D2
               COLUMN g_c[40],sr.pmx02 USING '####', #TQC-5B0037 mark   #TQC-6C0031 mark回復
               COLUMN g_c[42],sr.pmx08,
               COLUMN g_c[43],sr.pmx09,
               COLUMN g_c[44],cl_numfor(sr.pmx06,44,t_azi03),  #No.CHI-6A0004
               COLUMN g_c[45],sr.pmx07 USING '######.###',
               COLUMN g_c[46],cl_numfor(sr.pmx03,46,t_azi03)   #No.CHI-6A0004
         PRINTX name=D3
               COLUMN g_c[48],sr.pmx081 CLIPPED,  #MOD-640052
               COLUMN g_c[53],cl_numfor(sr.pmx06t,44,t_azi03),  #No.FUN-610018  #No.CHI-6A0004
               COLUMN g_c[49],sr.pmx04,
               COLUMN g_c[50],sr.pmx05
         PRINTX name=D4 COLUMN g_c[56],sr.pmx082 CLIPPED,   #MOD-640052
                        COLUMN g_c[57],sr.pmx10 CLIPPED
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
               IF g_wc.subString(001,080) > ' ' THEN
                  PRINT g_x[8] CLIPPED,g_wc.subString(001,070) CLIPPED
               END IF
               IF g_wc.subString(071,140) > ' ' THEN
                  PRINT COLUMN 10,     g_wc.subString(071,140) CLIPPED
               END IF
               IF g_wc.subString(141,210) > ' ' THEN
                  PRINT COLUMN 10,     g_wc.subString(141,210) CLIPPED
               END IF
               PRINT g_dash[1,g_len]
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        AFTER  GROUP OF sr.pmw01  #單據編號
            PRINT ' '
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i252_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pmw01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i252_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pmw01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i252_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmx08) THEN
       CALL cl_set_comp_entry("pmx081,pmx082,pmx06,pmx06t",TRUE)    #No.FUN-550019
    END IF
    CALL cl_set_comp_entry("pmx06,pmx06t",TRUE)    #No.FUN-610018
 
END FUNCTION
 
FUNCTION i252_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmx08) THEN
       IF g_pmx[l_ac].pmx08[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("pmx081,pmx082",FALSE)
       END IF
    END IF
 
    #No.FUN-550019
    IF g_gec07 = 'N' THEN           #No.FUN-560102
       CALL cl_set_comp_entry("pmx06t",FALSE)
    ELSE
       CALL cl_set_comp_entry("pmx06",FALSE)
    END IF
    #end No.FUN-550019
 
END FUNCTION
 
#No.FUN-670045 --start--
FUNCTION i252_query_refresh()
   IF g_query_flag THEN
      OPEN i252_count
      FETCH i252_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i252_cs
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,0)
         INITIALIZE g_pmw.* TO NULL
      ELSE
         CALL i252_fetch('F')
      END IF
   END IF
END FUNCTION
#No.FUN-670045 ---end---
#Patch....NO.MOD-5A0095 <003,001,002,004,005,006> #
#Patch....NO.TQC-610036 <001> # 
