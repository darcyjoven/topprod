# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_qry.4gl
# Descriptions...: 動態查詢函式維護作業 
# Date & Author..: 03/07/23 alex
# Modify.........: No.MOD-490027 04/09/01 By Wiky 單身新增或修改都會產生
#                                FETCH p_qry_bcl無此筆資料
# Modify.........: No.MOD-440465 04/10/13 By saki 新增客製欄位gab11,gac12
# Modify.........: No.FUN-4B0028 04/11/11 By alex 新增Construct Input單身開窗單身
#                                資料檢查及自動帶出部份欄位預設值
# Modify.........: No.MOD-4C0011 04/12/30 By alex 放大回傳值可以到 5 個
# Modify.........: No.FUN-4C0107 04/12/31 By alex 增加維護 wintitle 功能
# Modify.........: No.MOD-440464 05/02/14 By saki 增加log功能
# Modify.........: No.MOD-520083 05/02/17 By alex 檢查欄位功能由ztb移至gaq
# Modify.........: No.MOD-470106 05/02/23 By alex 增加欄位輸入遮罩,增gac13,gac14
# Modify.........: No.MOD-530267 05/03/25 By alex 新增時有 out of dimension 問題修
# Modify.........: No.MOD-570313 05/07/25 By saki 欄位代碼在維護模式時開窗沒有資料顯示
# Modify.........: No.FUN-580021 05/08/09 By Dido 欄位輸入時增加呼叫欄位寬度函數 cl_get_field_width
# Modify.........: No.MOD-540157 05/09/27 By alex 修正 construct 及複製的問題
# Modify.........: No.TQC-5B0076 05/11/09 By Claire 檢視異動紀錄功能失效 showlog
# Modify.........: No.TQC-5B0211 05/11/30 By alex 修正當單身給予查詢條件值時筆數錯誤問題
# Modify.........: No.TQC-620032 06/02/13 By alex 修正欄寬已有值時就不可再變動其值
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-650106 06/06/28 By saki 修正查詢SQL及筆數
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.CHI-690041 06/11/16 By pengu 將單頭的"是否忽略單身營運中心設定值"與
#                                單身的"資料資料庫代碼"欄位disable掉
# Modify.........: No.MOD-6A0136 06/11/17 By claire 不正常訊息的出現要取消
# Modify.........: No.TQC-6B0170 06/12/08 By pengu 還原BUG單CHI-690041的修改
# Modify.........: No.TQC-710077 07/01/22 By Smapmin 開啟程式後馬上開窗查詢就會出錯
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0081 07/04/09 By pengu 隱藏"無效"action按鈕
# Modify.........: No.FUN-760072 07/06/29 By saki 增加串查設定
# Modify.........: No.FUN-760049 07/07/18 By saki 視窗Title加入行業別代碼key
# Modify.........: No.TQC-780022 07/08/06 By hjwang 修正複製時要全開欄位功能
# Modify.........: No.MOD-7A0052 07/10/09 By claire 是否忽略單身營運中心設定 gab10 default 'Y' 
# Modify.........: No.MOD-820118 08/02/22 By alexstar 單身checkbox選項預設值 'N'
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-980030 09/08/03 By Hiko 移除gab10,gac04
# Modify.........: No.MOD-9A0031 09/10/06 By Dido 先查詢再新增時無法確實新增資料 
# Modify.........: No:TQC-9B0178 09/11/23 By Dido 欄位控管調整 
# Modify.........: No:FUN-A10083 10/01/14 By tommas 未p_qry_cs時，就進入p_qry_r，會跳出程式。
# Modify.........: No:CHI-A90035 10/10/06 By Summer 增加單頭折疊功能 
# Modify.........: No.FUN-A90024 10/11/25 By Jay 將cl_get_field_width()改為cl_get_column_info()
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-BB0132 11/11/12 By johung 調整按修改後點放棄無作用的問題
# Modify.........: No.MOD-B90072 12/06/18 By Elise 無論zlw_file有無資料都應要顯示gac15 
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE 
    g_gab           RECORD                        # (單頭)
        gab01       LIKE gab_file.gab01,                
        gae04       LIKE gae_file.gae04,                
        gab07       LIKE gab_file.gab07,                
        #gab10       LIKE gab_file.gab10, #FUN-980030:移除gab10
        gab08       LIKE gab_file.gab08,
        gab11       LIKE gab_file.gab11,
        gab06       LIKE gab_file.gab06,                
        gab02       LIKE gab_file.gab02,                
        gab05       LIKE gab_file.gab05,                
        gab03       LIKE gab_file.gab03, 
        gab04       LIKE gab_file.gab04
                    END RECORD
END GLOBALS
DEFINE
    g_gab_t         RECORD                        # (舊值)
        gab01       LIKE gab_file.gab01,                
        gae04       LIKE gae_file.gae04,                
        gab07       LIKE gab_file.gab07,                
        #gab10       LIKE gab_file.gab10, #FUN-980030:移除gab10
        gab08       LIKE gab_file.gab08,
        gab11       LIKE gab_file.gab11,
        gab06       LIKE gab_file.gab06,                
        gab02       LIKE gab_file.gab02,                
        gab05       LIKE gab_file.gab05,                
        gab03       LIKE gab_file.gab03,
        gab04       LIKE gab_file.gab04
                    END RECORD,
    g_gab_o         RECORD                        # (舊值)
        gab01       LIKE gab_file.gab01,                
        gae04       LIKE gae_file.gae04,                
        gab07       LIKE gab_file.gab07,                
        #gab10       LIKE gab_file.gab10, #FUN-980030:移除gab10
        gab08       LIKE gab_file.gab08,
        gab11       LIKE gab_file.gab11,
        gab06       LIKE gab_file.gab06,                
        gab02       LIKE gab_file.gab02,                
        gab05       LIKE gab_file.gab05,                
        gab03       LIKE gab_file.gab03,
        gab04       LIKE gab_file.gab04
                    END RECORD,
    g_gab01_t       LIKE gab_file.gab01,          # (舊值)
    g_gab11_t       LIKE gab_file.gab11,          # (舊值)
    g_gac           DYNAMIC ARRAY OF RECORD       # 程式變數(Program Variables)
        gac02       LIKE gac_file.gac02,
        #gac04       LIKE gac_file.gac04,          #TQC-6B0170  #FUN-980030:移除gac04
        gac05       LIKE gac_file.gac05,
        gac06       LIKE gac_file.gac06,
        gaq03       LIKE gaq_file.gaq03,
        gac09       LIKE gac_file.gac09,
        gac10       LIKE gac_file.gac10,
        gac07       LIKE gac_file.gac07,
        gac11       LIKE gac_file.gac11,
         gac13       LIKE gac_file.gac13,          # MOD-470106
        gac15       LIKE gac_file.gac15            #No.FUN-760072
                    END RECORD,
    g_gac_t         RECORD                         # (舊值)
        gac02       LIKE gac_file.gac02,
        #gac04       LIKE gac_file.gac04,          #TQC-6B0170  #FUN-980030:移除gac04
        gac05       LIKE gac_file.gac05,
        gac06       LIKE gac_file.gac06,
        gaq03       LIKE gaq_file.gaq03,
        gac09       LIKE gac_file.gac09,
        gac10       LIKE gac_file.gac10,
        gac07       LIKE gac_file.gac07,
        gac11       LIKE gac_file.gac11,
        gac13       LIKE gac_file.gac13,
        gac15       LIKE gac_file.gac15           #No.FUN-760072
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,                  #FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,     #單身筆數            #No.FUN-680135 SMALLINT
    l_ac                LIKE type_file.num5      #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5      #No.FUN-680135 SMALLINT 
DEFINE g_forupd_sql     STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp        STRING                   #No.TQC-720019
DEFINE g_cnt            LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE g_cnt2           LIKE type_file.num5      #FUN-680135    SMALLINT
DEFINE g_msg            LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE g_curs_index     LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE g_row_count      LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE g_jump           LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE g_no_ask        LIKE type_file.num5      #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE g_gae_wintitle   LIKE type_file.num5      #NO.FUN-680135 SMALLINT  #已設定wintitle於gae旗標
 
MAIN
#DEFINE
#       l_time           LIKE type_file.chr8      #計算被使用時間 #No.FUN-680135 VARCHAR(8) #No.FUN-6A0096
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-6A0096 -- begin --
#     CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
#       RETURNING l_time
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
#No.FUN-6A0096 -- end --
   LET p_row = 3 LET p_col = 14
 
   OPEN WINDOW p_qry_w AT p_row,p_col WITH FORM "azz/42f/p_qry"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT gab01,'',gab07,gab08,gab11,gab06,gab02, ",
                            " gab05,gab03,gab04 ", #FUN-980030:移除gab10
                       " FROM gab_file  WHERE gab01 = ? AND gab11 = ?",
                        " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_qry_cl CURSOR FROM g_forupd_sql
  #MOD-B90072---mark---start---  
  ##No.FUN-760072 --start--
  #SELECT COUNT(*) INTO g_cnt FROM zlw_file
  #IF SQLCA.sqlcode OR g_cnt < 3 THEN
  #   CALL cl_set_comp_entry("gac15",FALSE)
  #END IF
  ##No.FUN-760072 ---end---
  #MOD-B90072---mark---end---  
   CALL p_qry_menu()
   CLOSE WINDOW p_qry_w                 #結束畫面
#No.FUN-6A0096 -- begin --
#     CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
#        RETURNING l_time
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#No.FUN-6A0096 -- end --
END MAIN
 
 
 
FUNCTION p_qry_cs()
   CLEAR FORM                             #清除畫面
   CALL g_gac.clear()
   CALL cl_set_head_visible("","YES")   #CHI-A90035 add
 
   # 螢幕上取單頭條件
  #-------------TQC-6B0170 modify
   CONSTRUCT g_wc ON gab01,gab07,gab08,gab11,gab06,gab02,gab05,gab03,gab04
        FROM gab01,gab07,gab08,gab11,gab06,gab02,gab05,gab03,gab04 #FUN-980030:移除gab10
  #-------------TQC-6B0170 end
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(gab01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gac"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state= "c"
                LET g_qryparam.default1 = g_gab.gab01
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO gab01
                NEXT FIELD gab01
          END CASE
 
          ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
# 資料權限的檢查
#   IF g_priv2='4' THEN                           #只能使用自己的資料
#       LET g_wc = g_wc clipped," AND gabuser = '",g_user,"'"
#   END IF
#   IF g_priv3='4' THEN                           #只能使用相同群的資料
#       LET g_wc = g_wc clipped," AND gabgrup MATCHES '",g_grup CLIPPED,"*'"
#   END IF
#   IF g_priv3 MATCHES '[5678]' THEN                           #只能使用相同群的資料
#       LET g_wc = g_wc clipped," AND gabgrup IN ",cl_chk_tgrup_list()
#   END IF
 
    CALL g_gac.clear()
 
    # 螢幕上取單身條件
   #---------------TQC-6B0170 modify
    CONSTRUCT g_wc2 ON gac02,gac05,gac06,gac09,gac10,gac07,gac11,gac13,gac15  #No.FUN-760072
         FROM s_gac[1].gac02,
              s_gac[1].gac05,s_gac[1].gac06,
   #---------------TQC-6B0170 end
              s_gac[1].gac09,s_gac[1].gac10,s_gac[1].gac07,
              s_gac[1].gac11,s_gac[1].gac13,s_gac[1].gac15          #No.FUN-760072 #FUN-980030:移除gac04
 
        ON ACTION CONTROLP
           CASE
             #BEGIN:FUN-980030:移除gac04
             #-----------TQC-6B0170 modify
             #WHEN INFIELD(gac04)
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_azp4zta"
             #   LET g_qryparam.construct = "N"
             #   LET g_qryparam.state= "c"
             #    LET g_qryparam.default1 = g_gac[1].gac04  #MOD-540157
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
             #   DISPLAY g_qryparam.multiret TO gac04
             #   NEXT FIELD gac04
             #-----------TQC-6B0170 end
             #END:FUN-980030:移除gac04
              WHEN INFIELD(gac05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gat"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.state= "c"
                 #LET g_qryparam.default1 = g_gac[l_ac].gac05   #TQC-710077
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gac05
                 NEXT FIELD gac05
 
              WHEN INFIELD(gac06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaq"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.state= "c"
                 #LET g_qryparam.default1 = g_gac[l_ac].gac06   #TQC-710077
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gac06
                 NEXT FIELD gac06
 
              #No.FUN-760072 --start--
              WHEN INFIELD(gac15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.state= "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gac15
                 NEXT FIELD gac15
              #No.FUN-760072 ---end---
 
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

    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  gab01, gab11 FROM gab_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY gab01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  gab01, gab11 ",  #No.TQC-650106
                   "  FROM gab_file, gac_file ",
                   " WHERE gab01 = gac01",
                   "   AND gab11 = gac12",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY gab01"
    END IF
 
    PREPARE p_qry_prepare FROM g_sql
    DECLARE p_qry_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_qry_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
#       LET g_sql="SELECT COUNT(*) FROM gab_file WHERE ",g_wc CLIPPED      #No.TQC-720019
        LET g_sql_tmp="SELECT UNIQUE gab01,gab11 FROM gab_file WHERE ",g_wc CLIPPED, #No.TQC-720019
                      " INTO TEMP x "   #No.TQC-720019
    ELSE    #TQC-5B0211
        #No.TQC-650106 --start--
#       LET g_sql="SELECT COUNT(DISTINCT gab01 || gab11 ) FROM gab_file,gac_file ",
#                 " WHERE gac01=gab01 AND gac12=gab11 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#       LET g_sql="SELECT UNIQUE gab01,gab11 FROM gab_file,gac_file ",      #No.TQC-720019
        LET g_sql_tmp="SELECT UNIQUE gab01,gab11 FROM gab_file,gac_file ",  #No.TQC-720019
                  " WHERE gac01=gab01 AND gac12=gab11 ",
                  "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " INTO TEMP x "
        #No.TQC-650106 ---end---
    END IF
    #No.TQC-720019  --Begin
    DROP TABLE x
#   PREPARE qry_count_temp FROM g_sql      #No.TQC-720019
    PREPARE qry_count_temp FROM g_sql_tmp  #No.TQC-720019
    EXECUTE qry_count_temp
 
    LET g_sql = "SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End  
    PREPARE p_qry_precount FROM g_sql
    DECLARE p_qry_count CURSOR FOR p_qry_precount
END FUNCTION
 
FUNCTION p_qry_menu()
 
   WHILE TRUE
      CALL p_qry_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL p_qry_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_qry_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL p_qry_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL p_qry_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL p_qry_x()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL p_qry_copy()
            END IF
         WHEN "detail" 
            # 2004/04/02 新增判斷若為 hard-code (gab07="Y") 則不給輸入單身
            # 2004/05/06 新增判斷若為 Locked    (gab08="N") 則不給輸入單身
            IF cl_chk_act_auth() THEN
               IF g_gab.gab07 = "N" AND g_gab.gab08 = "Y" THEN
                  CALL p_qry_b()
               ELSE
                  IF g_gab.gab07 = "Y" THEN
                     CALL cl_err(g_gab.gab01,"azz-020",1)
                     LET g_action_choice = ""
                  ELSE
                     CALL cl_err(g_gab.gab01,"azz-037",1)
                     LET g_action_choice = ""
                  END IF
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "test_func"    
            # 2004/04/02 新增判斷若為 hard-code (gab07='Y') 則不給輸入單身
            IF g_gab.gab07 <> 'Y' THEN
               CALL p_qry_test()
            ELSE
               CALL cl_err(g_gab.gab01,"azz-020",1)
            END IF
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("p_qry")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION p_qry_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gac.clear()
    # 預設值及將數值類變數清成零
    INITIALIZE g_gab.* LIKE gab_file.*             #DEFAULT 設定
    LET g_gab01_t = NULL
    LET g_gab.gab08 = "Y"
   #MOD-7A0052-modify-begin
   ##----------TQC-6B0170 modify
    #LET g_gab.gab10 = "N"
   ##LET g_gab.gab10 = "Y"
   ##----------TQC-6B0170 end
    #LET g_gab.gab10 = "Y" #FUN-980030:移除gab10    
    LET g_gab.gab04 = "N"                       
    LET g_gab.gab07 = "N"                       
   #MOD-7A0052-modify-end
    LET g_gab.gab11 = "N"
    LET g_gab_o.* = g_gab.*
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CALL p_qry_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gab.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_gab.gab01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        #新增單頭部份
        INSERT INTO gab_file(gab01,gab02,gab03,gab04,gab05,gab06,
                             gab07,gab08,gab11) #FUN-980030:移除gab10
        VALUES (g_gab.gab01,g_gab.gab02,g_gab.gab03,g_gab.gab04,
                g_gab.gab05,g_gab.gab06,g_gab.gab07,g_gab.gab08,
                g_gab.gab11) #FUN-980030:移除gab10
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            #CALL cl_err(g_gab.gab01,SQLCA.sqlcode,1)  #No.FUN-660081
            CALL cl_err3("ins","gab_file",g_gab.gab01,g_gab.gab11,SQLCA.sqlcode,"","",1)    #No.FUN-660081
            CONTINUE WHILE
        END IF
 
        SELECT gab01 INTO g_gab.gab01 FROM gab_file
         WHERE gab01 = g_gab.gab01
 
        LET g_gab01_t = g_gab.gab01        #保留舊值
        LET g_gab_t.* = g_gab.*
        CALL g_gac.clear()
        LET g_rec_b=0
 
        # 2004/04/02 新增判斷若為 hard-code (gab07='Y') 則不給輸入單身
        IF g_gab.gab07 <> 'Y' THEN
           CALL p_qry_b() #輸入單身
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p_qry_u()
   DEFINE   l_gab09   LIKE gab_file.gab09
   DEFINE   ls_msg_n  STRING,
            ls_msg_o  STRING
    IF s_shut(0) THEN RETURN END IF
    IF g_gab.gab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('u')
    LET g_gab01_t = g_gab.gab01
    LET g_gab11_t = g_gab.gab11
    LET g_gab_o.* = g_gab.*
 
    BEGIN WORK
 
    OPEN p_qry_cl USING g_gab.gab01,g_gab.gab11
    IF STATUS THEN
       CALL cl_err("OPEN p_qry_cl:", STATUS, 1)
       CLOSE p_qry_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_qry_cl INTO g_gab.*            # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err("FETCH p_qry_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_qry_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL p_qry_show()
    WHILE TRUE
        LET g_gab01_t = g_gab.gab01
        LET g_gab11_t = g_gab.gab11
        CALL p_qry_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gab.*=g_gab_t.*
            CALL p_qry_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF (g_gab.gab01 != g_gab01_t) OR (g_gab.gab11 != g_gab11_t) THEN      #更改gab01
            UPDATE gac_file SET gac01 = g_gab.gab01 , gac12 = g_gab.gab11
                WHERE gac01 = g_gab01_t AND gac12 = g_gab11_t
            IF SQLCA.sqlcode THEN
               #No.FUN-660081  --Begin
               #CALL cl_err('gac',SQLCA.sqlcode,0)
               CALL cl_err3("upd","gac_file",g_gab01_t,g_gab11_t,SQLCA.sqlcode,"","gac",0)    #No.FUN-660081
               CONTINUE WHILE 
               #No.FUN-660081  --End  
            END IF
        END IF
        UPDATE gab_file
           SET gab01 = g_gab.gab01,
               gab02 = g_gab.gab02,
               gab03 = g_gab.gab03,
               gab04 = g_gab.gab04,
               gab05 = g_gab.gab05,
               gab06 = g_gab.gab06,
               gab07 = g_gab.gab07,
               gab08 = g_gab.gab08,
               #gab10 = g_gab.gab10, #FUN-980030:移除gab10
               gab11 = g_gab.gab11
            WHERE gab01 = g_gab01_t AND gab11=g_gab11_t
        IF SQLCA.sqlcode THEN
            #CALL cl_err('Update gab',SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","gab_file",g_gab01_t,g_gab11_t,SQLCA.sqlcode,"","Update gab",0)    #No.FUN-660081
            CONTINUE WHILE
        END IF
 
        SELECT gab09 INTO l_gab09 FROM gab_file
         WHERE gab01 = g_gab.gab01 AND gab11 = g_gab.gab11
 
        LET ls_msg_n = g_gab.gab01 CLIPPED,"",g_gab.gab02 CLIPPED,"",
                       g_gab.gab03 CLIPPED,"",g_gab.gab04 CLIPPED,"",
                       g_gab.gab05 CLIPPED,"",g_gab.gab06 CLIPPED,"",
                       g_gab.gab07 CLIPPED,"",g_gab.gab08 CLIPPED,"",
                       g_user CLIPPED,"",    #g_gab.gab10 CLIPPED,"", #FUN-980030:移除gab10
                       g_gab.gab11 CLIPPED,"^A"
        LET ls_msg_o = g_gab_t.gab01 CLIPPED,"",g_gab_t.gab02 CLIPPED,"",
                       g_gab_t.gab03 CLIPPED,"",g_gab_t.gab04 CLIPPED,"",
                       g_gab_t.gab05 CLIPPED,"",g_gab_t.gab06 CLIPPED,"",
                       g_gab_t.gab07 CLIPPED,"",g_gab_t.gab08 CLIPPED,"",
                       l_gab09  CLIPPED,"",    #g_gab_t.gab10 CLIPPED,"", #FUN-980030:移除gab10
                       g_gab_t.gab11 CLIPPED,"^A"
         CALL cl_log("p_qry","H",ls_msg_n,ls_msg_o)            # MOD-440464
 
        # 2004/05/06 若有誰把不可維護單身開成可維護單身, 把他的 g_user 記下來
        IF g_gab_o.gab08 = "N" AND g_gab.gab08 = "Y" THEN
           UPDATE gab_file SET gab09=g_user WHERE gab01 = g_gab.gab01 AND gab11=g_gab.gab11
        END IF
 
        # 2004/03/08 title 部份移入 gae_file 維護
        # UPDATE gac_file
 
        EXIT WHILE
    END WHILE
    CLOSE p_qry_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION p_qry_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入 #No.FUN-680135 VARCHAR(1) 
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改          #No.FUN-680135 VARCHAR(1)
    l_ze03          LIKE ze_file.ze03
 
    CALL cl_set_head_visible("","YES")   #CHI-A90035 add
    # 2004/03/08 title 部份移入 gae_file 維護
   #-------------TQC-6B0170 modify
    INPUT g_gab.gab01,g_gab.gab07,g_gab.gab08,g_gab.gab11,
          g_gab.gab06,g_gab.gab02,g_gab.gab05,g_gab.gab03,g_gab.gab04
          WITHOUT DEFAULTS #FUN-980030:移除gab10
     FROM gab01,gab07,gab08,gab11,gab06,gab02,gab05,gab03,gab04
   #-------------TQC-6B0170 end
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p_qry_set_entry(p_cmd)
            CALL p_qry_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD gab01                  # 查詢代號
            IF NOT cl_null(g_gab.gab01) THEN
               IF g_gab.gab01 != g_gab01_t THEN
                  SELECT count(*) INTO g_cnt FROM gab_file
                   WHERE gab01 = g_gab.gab01
                   IF g_cnt > 0 THEN   #資料重複
                      CALL cl_err(g_gab.gab01,-239,0)
                      LET g_gab.gab01 = g_gab01_t
                      DISPLAY BY NAME g_gab.gab01 
                      NEXT FIELD gab01
                   END IF
                END IF
            END IF
 
            # 2004/11/11 查詢代號是否有在 gae_file 中建置 wintitle 
            SELECT gae04 INTO g_gab.gae04 FROM gae_file 
             WHERE gae01=g_gab.gab01 AND gae02="wintitle" AND gae03=g_lang
             ORDER BY gae11 DESC
 
            #若沒有則抓取第一回傳值的 gat_file 資料 (cl_create_qry 也是這樣作)
            IF cl_null(g_gab.gae04) THEN
               IF g_gac.getLength() > 0 THEN
                  SELECT gat03 INTO g_gab.gae04
                    FROM gat_file,gac_file
                   WHERE gac01=g_gab.gab01 AND gac10="Y"
                     AND gat01=gac05 AND gat02=g_lang
                   ORDER BY gac02 ASC
 
#                 SELECT ze03 INTO l_ze03 FROM ze_file
#                  WHERE ze01="lib-213" AND ze02=g_lang
#                 LET g_gab.gae04 = l_ze03 CLIPPED, " ",g_gab.gae04 CLIPPED
                  LET l_ze03 = cl_getmsg("lib-213",g_lang)   #2005/02/14改
 
               END IF
               LET g_gae_wintitle=FALSE  #抓不到wintitle則旗標為FALSE
            ELSE
               LET g_gae_wintitle=TRUE   #抓到wintitle則旗標為TRUE
            END IF
            DISPLAY g_gab.gae04 TO gae04
 
        BEFORE FIELD gab07
            CALL p_qry_set_entry(p_cmd)
 
        AFTER FIELD gab07 # 是否為 Hard-code
            CALL p_qry_set_no_entry(p_cmd)
            #MOD-6A0136-begin-mark
            #IF g_gab.gab07 = 'Y' AND
            #  (g_gab_o.gab07 IS NULL OR g_gab_o.gab07 = 'N') THEN
            #   CALL cl_err("TEST TEST","!",1)
            #END IF
            #MOD-6A0136-end-mark
              
        BEFORE FIELD gab02
            IF g_gab.gab07 = 'Y' THEN
               NEXT FIELD gab06
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD gab01
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gab01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gac"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1 = g_gab.gab01
                   CALL cl_create_qry() RETURNING g_gab.gab01
#                   CALL FGL_DIALOG_SETBUFFER( g_gab.gab01 )
                   DISPLAY BY NAME g_gab.gab01
                   NEXT FIELD gab01
              OTHERWISE
                   EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION about
           CALL cl_about()

        ON IDLE g_idle_seconds  #FUN-860033
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION modify_program_name
           CALL p_gae_wintitle(g_gab.gab01,"std")    #No.FUN-760049
        

        ON ACTION cancel        #No.FUN-A10083 add
          #IF p_cmd = "a" THEN  #No.FUN-A10083 add   #MOD-BB0132 mark
              CLEAR FORM        #No.FUN-A10083 add
              EXIT INPUT        #No.FUN-A10083 add
          #END IF               #No.FUN-A10083 add   #MOD-BB0132 mark
          
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION p_qry_q()
 
    MESSAGE ""
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
 
    CLEAR FORM
    CALL g_gac.clear()
 
    DISPLAY ' ' TO FORMONLY.cnt  
 
    CALL p_qry_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN p_qry_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gab.* TO NULL
    ELSE
        OPEN p_qry_count
        FETCH p_qry_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL p_qry_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION p_qry_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式    #No.FUN-680135 VARCHAR(1) 
    l_abso          LIKE type_file.num10       #絕對的筆數  #No.FUN-680135 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_qry_cs INTO g_gab.gab01,g_gab.gab11 
        WHEN 'P' FETCH PREVIOUS p_qry_cs INTO g_gab.gab01,g_gab.gab11
        WHEN 'F' FETCH FIRST    p_qry_cs INTO g_gab.gab01,g_gab.gab11
        WHEN 'L' FETCH LAST     p_qry_cs INTO g_gab.gab01,g_gab.gab11
        WHEN '/'
         IF (NOT g_no_ask) THEN  #No.FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_qry_cs INTO g_gab.gab01,g_gab.gab11
         LET g_no_ask = FALSE     #No.FUN-6A0080
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gab.gab01,SQLCA.sqlcode,0)
        INITIALIZE g_gab.* TO NULL  #TQC-6B0105
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
 
    SELECT gab01,'',gab07,gab08,gab11,gab06,gab02,gab05,gab03,gab04
      INTO g_gab.* FROM gab_file #FUN-980030:移除gab10
     WHERE gab_file.gab01 = g_gab.gab01 AND gab11=g_gab.gab11
       AND gab01 = g_gab.gab01 AND gab11 = g_gab.gab11
 
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_gab.gab01,SQLCA.sqlcode,1)  #No.FUN-660081
        CALL cl_err3("sel","gab_file",g_gab.gab01,g_gab.gab11,SQLCA.sqlcode,"","",1)    #No.FUN-660081
        INITIALIZE g_gab.* TO NULL
        RETURN
    ELSE
       SELECT gae04 INTO g_gab.gae04 FROM gae_file
        WHERE gae01=g_gab.gab01 AND gae02='wintitle' 
          AND gae03=g_lang 
        ORDER BY gae11
    END IF
    CALL p_qry_show()
 
END FUNCTION
 
 
 
FUNCTION p_qry_show()
 
    LET g_gab_t.* = g_gab.*                      #保存單頭舊值
 
    # 2004/03/08 title 部份移入 gae_file 維護
   #------------------TQC-6B0170 modify
    DISPLAY g_gab.* TO gab01,gae04,gab07,gab08,gab11,gab06,gab02,
                       gab05,gab03,gab04 #FUN-980030:移除gab10
   #------------------TQC-6B0170 end
 
    CALL p_qry_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_qry_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_gab.gab01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_qry_cl USING g_gab.gab01,g_gab.gab11
    IF STATUS THEN
       CALL cl_err("OPEN p_qry_cl:", STATUS, 1)
       CLOSE p_qry_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_qry_cl INTO g_gab.*            # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err("FETCH p_qry_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_qry_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL p_qry_show()
    CLOSE p_qry_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_qry_r()
    DEFINE l_chr LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gab.gab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_qry_cl USING g_gab.gab01,g_gab.gab11
    IF STATUS THEN
       CALL cl_err("OPEN p_qry_cl:", STATUS, 1)
       CLOSE p_qry_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_qry_cl INTO g_gab.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gab.gab01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE p_qry_cl ROLLBACK WORK RETURN
    END IF
 
    CALL p_qry_show()
    IF cl_delh(0,0) THEN
        DELETE FROM gab_file WHERE gab01=g_gab.gab01 AND gab11=g_gab.gab11
        DELETE FROM gac_file WHERE gac01=g_gab.gab01 AND gac12=g_gab.gab11
        IF SQLCA.sqlcode THEN
           #CALL cl_err(g_gab.gab01,SQLCA.sqlcode,0)  #No.FUN-660081
           CALL cl_err3("del","gac_file",g_gab.gab01,g_gab.gab11,SQLCA.sqlcode,"","",0)    #No.FUN-660081
        ELSE 
           CLEAR FORM
           CALL g_gac.clear()
           DROP TABLE x  #No.TQC-720019
           IF NOT cl_null(g_sql_tmp) THEN                #No.FUN-A10083
              PREPARE qry_count_temp2 FROM g_sql_tmp  #No.TQC-720019
              EXECUTE qry_count_temp2                 #No.TQC-720019
              OPEN p_qry_count
#FUN-B50065------begin---
              IF STATUS THEN
                 CLOSE p_qry_count
                 CLOSE p_qry_cl
                 COMMIT WORK
                 RETURN
              END IF
#FUN-B50065------end------
              FETCH p_qry_count INTO g_row_count
#FUN-B50065------begin---
              IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                 CLOSE p_qry_count
                 CLOSE p_qry_cl
                 COMMIT WORK
                 RETURN
              END IF
#FUN-B50065------end------
              DISPLAY g_row_count TO FORMONLY.cnt
              OPEN p_qry_cs
              IF g_curs_index = g_row_count + 1 THEN
                 LET g_jump = g_row_count
                 CALL p_qry_fetch('L')
              ELSE
                 LET g_jump = g_curs_index
                 LET g_no_ask = TRUE     #No.FUN-6A0080
                 CALL p_qry_fetch('/')
              END IF
           END IF                                  #No.FUN-A10083
        END IF
    END IF
    CLOSE p_qry_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION p_qry_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_length        LIKE type_file.num5,    #長度              #No.FUN-680135 SMALLINT
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680135 SMALLINT
DEFINE   l_gac08    LIKE gac_file.gac08
DEFINE   ls_msg_n   STRING
DEFINE   ls_msg_o   STRING
DEFINE   li_count   LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   li_inx     LIKE type_file.num5    #No.FUN-680135 SMALLINT #No.MOD-570313
DEFINE   ls_str     STRING                 #No.MOD-570313
DEFINE   ls_sql     STRING                 #No.MOD-570313
DEFINE   li_cnt     LIKE type_file.num5    #No.FUN-680135 SMALLINT #No.MOD-570313
 
    LET g_action_choice = ""
    IF g_gab.gab01 IS NULL THEN RETURN END IF
#   SELECT * INTO g_gab.* FROM gab_file WHERE gab01=g_gab.gab01 AND gab11=g_gab.gab11
    SELECT gab01,'',gab07,gab08,gab11,gab06,gab02,gab05,gab03,gab04  #FUN-980030:移除gab10
      INTO g_gab.* FROM gab_file WHERE gab01=g_gab.gab01 AND gab11=g_gab.gab11
 
    CALL cl_opmsg('b')
 
   #------------TQC-6B0170 mark
    LET g_forupd_sql = " SELECT gac02,gac05,gac06,'',gac09,gac10,gac07,gac11,gac13,gac15 ",  #No.FUN-760072 #FUN-980030:移除gac04
   #------------TQC-6B0170 end
                         " FROM gac_file ",
                        "  WHERE gac01= ? AND gac02 = ? AND gac12 = ?",
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_qry_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    CALL cl_query_prt_temptable()     #No.FUN-A90024
 
    INPUT ARRAY g_gac WITHOUT DEFAULTS FROM s_gac.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_before_input_done = FALSE
           CALL p_qry_set_no_entry_b()
          #CALL p_qry_set_b_entry("i")			#MOD-9A0031 mark
          #CALL p_qry_set_b_no_entry("i")		#MOD-9A0031 mark
           LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN p_qry_cl USING g_gab.gab01,g_gab.gab11
            IF STATUS THEN
               CALL cl_err("OPEN p_qry_cl:", STATUS, 1)
               CLOSE p_qry_cl
               ROLLBACK WORK
               RETURN
            ELSE 
               FETCH p_qry_cl INTO g_gab.*            # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gab.gab01,SQLCA.sqlcode,1)      # 資料被他人LOCK
                  CLOSE p_qry_cl 
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
 
             IF g_rec_b >= l_ac THEN #MOD-490027
               LET p_cmd='u'
               LET g_gac_t.* = g_gac[l_ac].*  #BACKUP
 
               OPEN p_qry_bcl USING g_gab.gab01,g_gac_t.gac02,g_gab.gab11
               IF STATUS THEN
                  CALL cl_err("OPEN p_qry_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH p_qry_bcl INTO g_gac[l_ac].*
                  IF STATUS THEN
                     CALL cl_err("FETCH p_qry_bcl",SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT gae04 INTO g_gac[l_ac].gaq03 FROM gae_file
                      WHERE gae01=g_gab.gab01 AND gae02=g_gac[l_ac].gac06
                        AND gae03=g_lang AND gae11=g_gab.gab11
                     IF cl_null(g_gac[l_ac].gaq03) THEN
                        SELECT gaq03 INTO g_gac[l_ac].gaq03 FROM gaq_file
                         WHERE gaq01=g_gac[l_ac].gac06 AND gaq02=g_lang
                     END IF
                     CALL p_qry_set_b_entry("i")	#MOD-9A0031
                     CALL p_qry_set_b_no_entry("i")	#MOD-9A0031
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 #           MOD-470106
            LET g_before_input_done = FALSE
           #CALL p_qry_set_b_entry("i")			#MOD-9A0031 mark
           #CALL p_qry_set_b_no_entry("i")		#MOD-9A0031 mark
            LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gac[l_ac].* TO NULL      #900423
           #--------TQC-6B0170 modify
            #LET g_gac[l_ac].gac04="ds" #FUN-980030:移除gac04
           #--------TQC-6B0170 end
            LET g_gac[l_ac].gac10 = 'N'   #MOD-820118
            LET g_gac[l_ac].gac11 = 'N'   #MOD-820118
            LET g_gac_t.* = g_gac[l_ac].*         #新輸入資料
            CALL p_qry_set_b_entry("i")		#MOD-9A0031
            CALL p_qry_set_b_no_entry("i")	#MOD-9A0031
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gac02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO gac_file(gac01,gac02,gac03,gac05,gac06, #FUN-980030:移除gac04
                                 gac07,gac08,gac09,gac10,gac11,gac12,gac13,gac15)   #No.FUN-760072
            VALUES(g_gab.gab01,      g_gac[l_ac].gac02,"0",
                  #------------TQC-6B0170 modify
                   g_gac[l_ac].gac05,g_gac[l_ac].gac06, #FUN-980030:移除gac04的設定值.
                  #------------TQC-6B0170 end
                   g_gac[l_ac].gac07,g_user,
                   g_gac[l_ac].gac09,g_gac[l_ac].gac10,g_gac[l_ac].gac11,
                   g_gab.gab11,      g_gac[l_ac].gac13,g_gac[l_ac].gac15)           #No.FUN-760072
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gac[l_ac].gac02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("ins","gac_file",g_gab.gab01,g_gac[l_ac].gac02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD gac02                        #default 序號
            IF cl_null(g_gac[l_ac].gac02) OR cl_null(g_gac_t.gac02) THEN
                SELECT max(gac02)+1
                  INTO g_gac[l_ac].gac02
                  FROM gac_file
                 WHERE gac01 = g_gab.gab01
                IF cl_null(g_gac[l_ac].gac02) OR g_gac[l_ac].gac02 <= 0 THEN
                    LET g_gac[l_ac].gac02 = 1
                END IF
            END IF
 
        AFTER FIELD gac02
            #目前cl_create_qry只限顯示 20 筆資料, 
            IF g_gac[l_ac].gac02 > 20 OR g_gac[l_ac].gac02 <= 0 THEN
                LET g_errno = 'azz-012'
                CALL cl_err('',g_errno,0)
                NEXT FIELD gac02
            END IF
            #check 序號是否重複
            IF g_gac[l_ac].gac02 != g_gac_t.gac02 OR
               g_gac_t.gac02 IS NULL THEN
                SELECT count(*) INTO l_n FROM gac_file
                 WHERE gac01 = g_gab.gab01
                   AND gac02 = g_gac[l_ac].gac02
                IF l_n > 0 THEN
                    CALL cl_err('Serial Repeat',-239,0)
                    LET g_gac[l_ac].gac02 = g_gac_t.gac02
                    NEXT FIELD gac02
                END IF
            END IF
            #若檢查通過, 則給予初始資料庫預設值
            #BEGIN:#FUN-980030:移除gac04
            ##----------TQC-6B0170 modify
            # IF cl_null(g_gac[l_ac].gac04) THEN
            #    LET g_gac[l_ac].gac04="ds"
            # END IF
            ##----------TQC-6B0170 end
            #END:#FUN-980030:移除gac04
 
       #BEGIN:#FUN-980030:移除gac04
       #AFTER FIELD gac04
       #    #檢查資料庫名稱是否存在於系統中, 就算單頭核選 "忽略單身中資料
       #    #庫設定也要查, 因為若忽略,則應於 ds 標準資料庫中也要存在資料
       #    IF NOT cl_null(g_gac[l_ac].gac04) THEN
       #       IF g_gac[l_ac].gac04[1,3] != "arg" THEN
       #          SELECT azp03 FROM azp_file
       #           WHERE azp03=g_gac[l_ac].gac04
       #          IF SQLCA.SQLCODE THEN
       #             CALL cl_err3("sel","azp_file",g_gac[l_ac].gac04,"",SQLCA.sqlcode,"","Select Plant ID",1)    #No.FUN-660081
       #             NEXT FIELD gac04
       #          END IF
       #       END IF
       #    END IF
       #END:#FUN-980030:移除gac04
        AFTER FIELD gac05
            #檢查資料庫中是否含有此資料表
            IF NOT cl_null(g_gac[l_ac].gac05) THEN
                #No.MOD-570313 --start-- zta01跟gac05的長度不符合，所以改成另一種
               LET ls_sql = "SELECT COUNT(*) FROM zta_file ",
                            " WHERE zta01 = '",g_gac[l_ac].gac05 CLIPPED,"'"
                           #-------------TQC-6B0170 modify
                           # "   AND zta02 = '",g_gac[l_ac].gac04 CLIPPED,"'" #FUN-980030:移除gac04
                           #-------------TQC-6B0170 end
               PREPARE cnt_curs FROM ls_sql
               EXECUTE cnt_curs INTO li_cnt
                #No.MOD-570313 ---end---
                IF SQLCA.SQLCODE OR (li_cnt <= 0) THEN  #No.MOD-570313
                  CALL cl_err("Select Table ID:",SQLCA.SQLCODE,1)
                  NEXT FIELD gac05
               END IF
               CALL p_qry_check_gae04()
            END IF
 
        AFTER FIELD gac06
            #檢查資料表中是否含有此欄位
            IF NOT cl_null(g_gac[l_ac].gac06) THEN
 
                # MOD-520083 由 ztb 移到 gaq 執行欄位是否存在的檢查, 所以
               #            從此開完欄位務必要註冊 gaq 欄位說明資料
               LET li_count=0
               SELECT count(*) INTO li_count FROM gaq_file
                WHERE gaq01=g_gac[l_ac].gac06 
#              SELECT ztb08 INTO g_gac[l_ac].gac09 FROM ztb_file 
#               WHERE ztb01=g_gac[l_ac].gac05 # AND ztb02=g_gac[l_ac].gac04 #FUN-980030:移除gac04
#                 AND ztb03=g_gac[l_ac].gac06
#              IF SQLCA.SQLCODE THEN
#                 CALL cl_err("Select Field ID:",SQLCA.SQLCODE,1)
#                 NEXT FIELD gac06
#              END IF
                IF li_count=0 THEN    #MOD-540157
                  CALL cl_err(g_gac[l_ac].gac06,"azz-116",1) #MOD-540157
#                 CALL cl_err("Select Field ID Don't Exist in p_feldname","!",1)
                  NEXT FIELD gac06
               ELSE
                  SELECT gaq03 INTO g_gac[l_ac].gaq03 FROM gaq_file
                   WHERE gaq01=g_gac[l_ac].gac06 AND gaq02=g_lang
                  DISPLAY g_gac[l_ac].gaq03 TO gaq03
#                 IF cl_null(g_gac[l_ac].gac09) THEN   #TQC-620032
#                    DISPLAY g_gac[l_ac].gac09 TO gac09
#                 END IF
               END IF
 
#              #TQC-620032  #FUN-580021
               IF cl_null(g_gac[l_ac].gac09) THEN
                 
                 #---FUN-A90024---start-----
                 ##--------TQC-6B0170 modify
                 # CALL cl_get_field_width(g_dbs,g_gac[l_ac].gac05,g_gac[l_ac].gac06) RETURNING g_gac[l_ac].gac09 #FUN-980030:移除gac04  #FUN-A90024 mark
                 ##--------TQC-6B0170 end
                 CALL cl_query_prt_getlength(g_gac[l_ac].gac06, 'N', 's', 0)
                 SELECT xabc04 INTO l_length
                   FROM xabc WHERE xabc02 = g_gac[l_ac].gac06
                   
                 LET g_gac[l_ac].gac09 = l_length
                 #---FUN-A90024---end-------
                 
                 DISPLAY g_gac[l_ac].gac09 TO gac09
               END IF
#              #FUN-580021 End
            END IF
 
 #       MOD-470106
        BEFORE FIELD gac07
            CALL p_qry_set_b_entry('i')
 
        AFTER FIELD gac07
            IF NOT cl_null(g_gac[l_ac].gac07) THEN
               CALL p_qry_set_b_no_entry('i')
            END IF
 
#       #TQC-620032
        BEFORE FIELD gac09
           IF cl_null(g_gac[l_ac].gac09) THEN
             #-----------TQC-6B0170 modify
              #IF NOT cl_null(g_gac[l_ac].gac04) AND #FUN-980030:移除gac04
              IF NOT cl_null(g_gac[l_ac].gac05) AND
                 NOT cl_null(g_gac[l_ac].gac06) THEN
                 #---FUN-A90024---start-----
                 #CALL cl_get_field_width(g_dbs,g_gac[l_ac].gac05,g_gac[l_ac].gac06) RETURNING g_gac[l_ac].gac09 #FUN-980030:移除gac04  #FUN-A90024 mark
                 CALL cl_query_prt_getlength(g_gac[l_ac].gac06, 'N', 's', 0)
                 SELECT xabc04 INTO l_length
                   FROM xabc WHERE xabc02 = g_gac[l_ac].gac06
                   
                 LET g_gac[l_ac].gac09 = l_length
                 #---FUN-A90024---end-------
             #-----------TQC-6B0170 end
                 DISPLAY g_gac[l_ac].gac09 TO gac09
              END IF
           END IF
 
        AFTER FIELD gac10
            IF cl_null(g_gac[l_ac].gac10) THEN
               CALL p_qry_gac10()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD gac10
               END IF
               CALL p_qry_check_gae04()
            END IF
 
        #No.FUN-760072 --start--
        AFTER FIELD gac15
           IF NOT cl_null(g_gac[l_ac].gac15) THEN
              SELECT COUNT(*) INTO l_n FROM gaz_file WHERE gaz01=g_gac[l_ac].gac15
              IF l_n <= 0 THEN
                 CALL cl_err(g_gac[l_ac].gac15,'lib-021',0)
                 NEXT FIELD gac15
              END IF
           END IF                                #No.FUN-760072
        #No.FUN-760072 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_gac_t.gac02 > 0 AND g_gac_t.gac02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM gac_file
                    WHERE gac01 = g_gab.gab01 AND
                          gac02 = g_gac_t.gac02 AND
                          gac12 = g_gab.gab11
                IF SQLCA.sqlcode THEN
                    #CALL cl_err(g_gac_t.gac02,SQLCA.sqlcode,0)  #No.FUN-660081
                    CALL cl_err3("del","gac_file",g_gab.gab01,g_gac_t.gac02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
               LET g_gac[l_ac].* = g_gac_t.*
               CLOSE p_qry_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gac[l_ac].gac02,-263,1)
               LET g_gac[l_ac].* = g_gac_t.*
            ELSE
               UPDATE gac_file SET
                  gac02 = g_gac[l_ac].gac02,
                 #-----------TQC-6B0170 modify
                  #gac04 = g_gac[l_ac].gac04, #FUN-980030:移除gac04
                 #-----------TQC-6B0170 end
                  gac05 = g_gac[l_ac].gac05,
                  gac06 = g_gac[l_ac].gac06,
                  gac09 = g_gac[l_ac].gac09,
                  gac10 = g_gac[l_ac].gac10,
                  gac07 = g_gac[l_ac].gac07,
                  gac11 = g_gac[l_ac].gac11,
                  gac13 = g_gac[l_ac].gac13,
                  gac15 = g_gac[l_ac].gac15      #No.FUN-760072
                WHERE gac01=g_gab.gab01 
                  AND gac02=g_gac_t.gac02 
                  AND gac12=g_gab.gab11
               IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gac[l_ac].gac02,SQLCA.sqlcode,0)  #No.FUN-660081
                   CALL cl_err3("upd","gac_file",g_gab.gab01,g_gac_t.gac02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                   LET g_gac[l_ac].* = g_gac_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   SELECT gac08 INTO l_gac08 FROM gac_file
                    WHERE gac01 = g_gab.gab01 AND gac02 = g_gac_t.gac02
                      AND gac12 = g_gab.gab11
                   LET ls_msg_n = g_gab.gab01 CLIPPED,"",g_gac[l_ac].gac02 CLIPPED,"",
                                #---------TQC-6B0170 modify              
                                #  "0","",                g_gac[l_ac].gac04 CLIPPED,"", #FUN-980030:移除gac04
                                #---------TQC-6B0170 end          
                                  g_gac[l_ac].gac05 CLIPPED,"",g_gac[l_ac].gac06 CLIPPED,"",
                                  g_gac[l_ac].gac07 CLIPPED,"",g_user CLIPPED,"",
                                  g_gac[l_ac].gac09 CLIPPED,"",g_gac[l_ac].gac10 CLIPPED,"",
                                  g_gac[l_ac].gac11 CLIPPED,"",g_gab.gab11 CLIPPED
                   LET ls_msg_o = g_gab.gab01 CLIPPED,"",g_gac_t.gac02 CLIPPED,"",
                                 #-------------TQC-6B0170 modify
                                 # "0","",                  g_gac_t.gac04 CLIPPED,"", #FUN-980030:移除gac04
                                 #-------------TQC-6B0170 end
                                  g_gac_t.gac05 CLIPPED,"",g_gac_t.gac06 CLIPPED,"",
                                  g_gac_t.gac07 CLIPPED,"",l_gac08 CLIPPED,"",
                                  g_gac_t.gac09 CLIPPED,"",g_gac_t.gac10 CLIPPED,"",
                                  g_gac_t.gac11 CLIPPED,"",g_gab.gab11 CLIPPED
                    CALL cl_log("p_qry","B",ls_msg_n,ls_msg_o)            # MOD-440464
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gac[l_ac].* = g_gac_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_gac.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE p_qry_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034
            CLOSE p_qry_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gac02) AND 1 > 1 THEN
              LET g_gac[l_ac].* = g_gac[l_ac-1].*
              LET g_gac[l_ac].gaq03 = ''
              NEXT FIELD gac02
            END IF

        ON ACTION CONTROLP
            CASE
               #BEGIN:#FUN-980030:移除gac04
               #WHEN INFIELD(gac04)
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_azp4zta"
               #   LET g_qryparam.construct = "N"
               #   LET g_qryparam.default1 = g_gac[l_ac].gac04
               #   CALL cl_create_qry() RETURNING g_gac[l_ac].gac04
               #   DISPLAY g_gac[l_ac].gac04 TO gac04
               #   NEXT FIELD gac04
               #END:#FUN-980030:移除gac04
               WHEN INFIELD(gac05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gat"
                  LET g_qryparam.arg1 = g_lang
                  LET g_qryparam.default1 = g_gac[l_ac].gac05
                  CALL cl_create_qry() RETURNING g_gac[l_ac].gac05
                  DISPLAY g_gac[l_ac].gac05 TO gac05
                  NEXT FIELD gac05
 
               WHEN INFIELD(gac06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaq"
                  LET g_qryparam.arg1 = g_lang
                   #No.MOD-570313 --start--
                  LET ls_str = g_gac[l_ac].gac05
                  LET li_inx = ls_str.getIndexOf("_file",1)
                  IF li_inx >= 1 THEN
                     LET ls_str = ls_str.subString(1,li_inx - 1)
                  ELSE
                     LET ls_str = ""
                  END IF
                   #No.MOD-570313 ---end---
                   LET g_qryparam.arg2 = ls_str               #No.MOD-570313
                  LET g_qryparam.default1 = g_gac[l_ac].gac06
                  CALL cl_create_qry() RETURNING g_gac[l_ac].gac06
                  DISPLAY g_gac[l_ac].gac06 TO gac06
                  NEXT FIELD gac06
 
               #No.FUN-760072 --start--
               WHEN INFIELD(gac15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  LET g_qryparam.default1 = g_gac[l_ac].gac15
                  CALL cl_create_qry() RETURNING g_gac[l_ac].gac15
                  DISPLAY g_gac[l_ac].gac15 TO gac15
                  NEXT FIELD gac15
               #No.FUN-760072 ---end---
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

      #CHI-A90035 add --start--
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #CHI-A90035 add --end--

    END INPUT
 
    CLOSE p_qry_bcl
    COMMIT WORK
    CALL p_qry_delall()
END FUNCTION
 
# 2004/11/11 若 gae06欄位名稱  和 gac10是否回傳有變動 則檢查 gae04是否隨著變
FUNCTION p_qry_check_gae04()
 
    DEFINE l_ze03    LIKE ze_file.ze03
    DEFINE l_gac05   LIKE gac_file.gac05
    DEFINE l_i       LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
    #檢查若本筆資料存在 gae_file 的 wintitle 設定, 則不動
    IF g_gae_wintitle THEN
       RETURN
    END IF
 
    #2004/11/11 抓取第一回傳值的 gat_file 資料
    IF g_gac.getLength() > 0 THEN
 
       FOR l_i=1 TO g_gac.getLength()
          IF g_gac[l_i].gac10="Y" THEN
             LET l_gac05=g_gac[l_i].gac05
             EXIT FOR
          ELSE
             LET l_gac05=" "
          END IF
       END FOR
       SELECT gat03 INTO g_gab.gae04
         FROM gat_file
        WHERE gat01=l_gac05 AND gat02=g_lang
       IF SQLCA.SQLCODE THEN
          LET g_gab.gae04 = ""
          DISPLAY g_gab.gae04 TO gae04
          RETURN
       END IF
 
       SELECT ze03 INTO l_ze03 FROM ze_file
        WHERE ze01="lib-213" AND ze02=g_lang
       LET g_gab.gae04 = l_ze03 CLIPPED, " ",g_gab.gae04 CLIPPED
       DISPLAY g_gab.gae04 TO gae04
    END IF
 
    RETURN
END FUNCTION
 
 
FUNCTION p_qry_gac10()
 
 DEFINE   l_count   LIKE type_file.num10   #FUN-680135 INTEGER
 
   LET g_errno = ''
   LET l_count = 0
 
   SELECT COUNT(gac10) INTO l_count FROM gac_file
    WHERE gac01=g_gab.gab01 AND gac10="Y" AND gac12=g_gab.gab11
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg1312'
       WHEN l_count > 5             # 原本為 3  MOD-4C0011
         LET g_errno = 'azz-010'
         CALL cl_err('',g_errno,0)
         LET g_errno = ' '
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
 
 
FUNCTION p_qry_delall()
 
    # 2004/03/09: 未輸入單身資料,且非為hard-code(gab07='N'),則取消單頭資料
    SELECT COUNT(*) INTO g_cnt FROM gac_file
        WHERE gac01 = g_gab.gab01 AND gac12=g_gab.gab11
    IF g_cnt = 0 AND g_gab.gab07='N' THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM gab_file WHERE gab01 = g_gab.gab01 AND gab11=g_gab.gab11
    END IF
END FUNCTION
   
 
FUNCTION p_qry_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING,        #TQC-5B0211
           l_ze03          LIKE ze_file.ze03
 
   #------------------TQC-6B0170 modify
    LET g_sql = "SELECT gac02,gac05,gac06,'',gac09,gac10,gac07,gac11,gac13,gac15 ",   #No.FUN-760072 #FUN-980030:移除gac04
   #------------------TQC-6B0170 end
                 " FROM gac_file",
                " WHERE gac01 ='",g_gab.gab01,"'",
                "   AND gac12 ='",g_gab.gab11,"'",
                "   AND ", p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    PREPARE p_qry_pb FROM g_sql
    DECLARE gac_curs                       #CURSOR
        CURSOR FOR p_qry_pb
 
    CALL g_gac.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH gac_curs INTO g_gac[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        #2004/03/09 hjwang 先找 gae 再找 gaq
        SELECT gae04 INTO g_gac[g_cnt].gaq03 FROM gae_file
         WHERE gae01=g_gab.gab01 AND gae02=g_gac[g_cnt].gac06
           AND gae03=g_lang AND gae11=g_gab.gab11
        IF cl_null(g_gac[g_cnt].gaq03) THEN
           SELECT gaq03 INTO g_gac[g_cnt].gaq03 FROM gaq_file
            WHERE gaq01=g_gac[g_cnt].gac06 AND gaq02=g_lang
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gac.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
 
    #2004/11/11 若 g_gab.gae04 為空值, 則抓取第一回傳值的 gat_file 資料
    IF cl_null(g_gab.gae04) THEN
       IF g_gac.getLength() > 0 THEN
          SELECT gat03 INTO g_gab.gae04
            FROM gat_file,gac_file
           WHERE gac01=g_gab.gab01 AND gac10="Y"
             AND gat01=gac05 AND gat02=g_lang
           ORDER BY gac02 ASC
          SELECT ze03 INTO l_ze03 FROM ze_file
           WHERE ze01="lib-213" AND ze02=g_lang
          LET g_gab.gae04 = l_ze03 CLIPPED, " ",g_gab.gae04 CLIPPED
       END IF
       DISPLAY g_gab.gae04 TO gae04
       LET g_gae_wintitle=FALSE  #抓不到wintitle則旗標為FALSE
    ELSE
       LET g_gae_wintitle=TRUE   #抓到wintitle則旗標為TRUE
    END IF
 
END FUNCTION
 
FUNCTION p_qry_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gac TO s_gac.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL p_qry_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p_qry_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL p_qry_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL p_qry_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL p_qry_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
     #---------------No.TQC-6B0081 mark
     #ON ACTION invalid
     #   LET g_action_choice="invalid"
     #   EXIT DISPLAY
     #---------------No.TQC-6B0081 end
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION test_func
         LET g_action_choice="test_func"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       ON ACTION showlog             #MOD-440464
         LET g_action_choice = "showlog"
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

      #CHI-A90035 add --start--
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #CHI-A90035 add --end--
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_qry_copy()
DEFINE
    l_gab		RECORD 
        gab01       LIKE gab_file.gab01,                
        gae04       LIKE gae_file.gae04,                
        gab07       LIKE gab_file.gab07,                
        #gab10       LIKE gab_file.gab10, #FUN-980030:移除gab10
        gab08       LIKE gab_file.gab08,
        gab11       LIKE gab_file.gab11,
        gab06       LIKE gab_file.gab06,                
        gab02       LIKE gab_file.gab02,                
        gab05       LIKE gab_file.gab05,                
        gab03       LIKE gab_file.gab03,
        gab04       LIKE gab_file.gab04 
                    END RECORD,
    l_old_gab01,l_new_gab01 LIKE gab_file.gab01,
    l_old_gab11,l_new_gab11 LIKE gab_file.gab11
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gab.gab01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    #TQC-780022
    LET g_before_input_done = FALSE
    CALL p_qry_set_entry('a')
    LET g_before_input_done = TRUE
    #TQC-780022 end
 
    CALL cl_set_head_visible("","YES")   #CHI-A90035 add
    LET l_new_gab11 = 'N'
    INPUT l_new_gab01,l_new_gab11 WITHOUT DEFAULTS FROM gab01,gab11
        AFTER FIELD gab01
            IF l_new_gab01 IS NULL THEN
                NEXT FIELD gab01
            END IF
 
        AFTER FIELD gab11
            SELECT count(*) INTO g_cnt FROM gab_file
                WHERE gab01 = l_new_gab01 AND gab11 = l_new_gab11
            IF g_cnt > 0 THEN
                CALL cl_err(l_new_gab11,-239,0)
                NEXT FIELD gab11
            END IF
 
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
        DISPLAY BY NAME g_gab.gab01 ,g_gab.gab11
        RETURN
    END IF
    LET l_gab.* = g_gab.*
    LET l_gab.gab01 = l_new_gab01   #新的鍵值
    LET l_gab.gab11 = l_new_gab11   #新的鍵值
    INSERT INTO gab_file(gab01,gab02,gab03,gab04,gab05,gab06,gab07,gab08,gab11)
    VALUES (l_gab.gab01,l_gab.gab02,l_gab.gab03,l_gab.gab04,l_gab.gab05,
            l_gab.gab06,l_gab.gab07,l_gab.gab08,l_gab.gab11) #FUN-980030:移除gab10
    IF SQLCA.sqlcode THEN
        #CALL cl_err('gab:',SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","gab_file",l_gab.gab01,l_gab.gab02,SQLCA.sqlcode,"","gab",0)    #No.FUN-660081
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM gac_file         #單身複製
        WHERE gac01=g_gab.gab01
          AND gac12=g_gab.gab11
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_gab.gab01,SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","x",g_gab.gab01,g_gab.gab11,SQLCA.sqlcode,"","",0)    #No.FUN-660081
        RETURN
    END IF
    UPDATE x
        SET gac01=l_new_gab01, gac12=l_new_gab11
    INSERT INTO gac_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        #CALL cl_err('gac:',SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","gac_file",l_new_gab01,l_new_gab11,SQLCA.sqlcode,"","gac",0)    #No.FUN-660081
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new_gab01,') O.K'
    LET g_gab.gab01 = l_new_gab01  #FUN-C30027
    LET g_gab.gab11 = l_new_gab11  #FUN-C30027
    CALL p_qry_show()              #FUN-C30027
END FUNCTION
 
FUNCTION p_qry_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("gab01",TRUE)
   END IF
 
   IF INFIELD(gab07) OR (NOT g_before_input_done) THEN
     #--------------TQC-6B0170 modify
      CALL cl_set_comp_entry("gab02,gab05,gab03,gab04,gab08",TRUE) #FUN-980030:移除gab10
     #--------------TQC-6B0170 end
   END IF
 
END FUNCTION
 
FUNCTION p_qry_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("gab01",FALSE)
       END IF
   END IF
 
   IF INFIELD(gab07) OR (NOT g_before_input_done) THEN
      IF g_gab.gab07 = "Y" THEN
        #------------------TQC-6B0170 modify
         CALL cl_set_comp_entry("gab02,gab05,gab03,gab04,gab08",FALSE) #FUN-980030:移除gab10
        #------------------TQC-6B0170 end
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_qry_set_no_entry_b()
 
   IF (NOT g_before_input_done) THEN
      #IF g_gab.gab10 = "Y" THEN #FUN-980030:移除gab10
         CALL cl_set_comp_entry("gab04",FALSE)
      #END IF
   END IF
 
END FUNCTION
 
 # MOD-470106
FUNCTION p_qry_set_b_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
  #IF (NOT g_before_input_done) THEN          #TQC-9B0178 mark
      CALL cl_set_comp_entry("gac13",TRUE)
  #END IF                                     #TQC-9B0178 mark
 
END FUNCTION
 
 
 # MOD-470106
FUNCTION p_qry_set_b_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
  #IF INFIELD(gac07) OR (NOT g_before_input_done) THEN     #TQC-9B0178 mark
       #MOD-530267
      IF l_ac <> 0 THEN
         IF g_gac[l_ac].gac07 <> "3" THEN
            CALL cl_set_comp_entry("gac13",FALSE)
         END IF
      END IF
  #END IF                                                  #TQC-9B0178 mark
 
END FUNCTION
 
 
