# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anms110.4gl
# Descriptions...: 應付票據設定維護作業
# Date & Author..: 00/12/04 By Payton
# Modify.........: No.FUN-590128 05/09/29 By Smapmin 增加報表列印功能
# Modify.........: No.FUN-5A0108 05/10/20 By Smapmin 增加匯出Excel功能
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-640075 06/04/09 By Mandy 單身本列結束否insert時請先預設N
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/12 By Judy 單身"空幾列","空幾格"無控管,可為負
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840019 08/04/28 By lutingting 報表轉為使用CR輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(2) 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C40170 12/04/19 By wujie oriu，orig不显示
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_npx           RECORD LIKE npx_file.*,       #格式代號 (假單頭)
    g_npx_t         RECORD LIKE npx_file.*,       #格式代號 (舊值)
    g_npx_o         RECORD LIKE npx_file.*,       #格式代號 (舊值)
    g_npx01_t       LIKE npx_file.npx01,          #格式代號 (舊值)
    g_npy           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        npy02       LIKE npy_file.npy02,          #項次
        npy03       LIKE npy_file.npy03,          #項目
        dses        LIKE type_file.chr1000,       #FUN-680107
        npy04       LIKE npy_file.npy04,          #空幾列
        npy05       LIKE npy_file.npy05,          #印幾行
        npy06       LIKE npy_file.npy06           #本行結束否
                    END RECORD,
    g_npy_t         RECORD                        #程式變數 (舊值)
        npy02       LIKE npy_file.npy02,          #項次
        npy03       LIKE npy_file.npy03,          #項目
        dses        LIKE type_file.chr1000,       #FUN-680107
        npy04       LIKE npy_file.npy04,          #空幾列
        npy05       LIKE npy_file.npy05,          #印幾行
        npy06       LIKE npy_file.npy06           #本行結束否
                    END RECORD,
#   g_x ARRAY[50] OF    VARCHAR(40),   #FUN-590128
    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,   #No.FUN-580092 HCN      #No.FUN-680107
#   l_za05          LIKE za_file.za05,            #FUN-590128
    g_rec_b         LIKE type_file.num5,          #單身筆數               #No.FUN-680107
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT    #No.FUN-680107
    p_row,p_col     LIKE type_file.num5           #No.FUN-680107
DEFINE g_forupd_sql LIKE type_file.chr1000        #SELECT ... FOR UPDATE SQL    #No.FUN-680107
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680107
 
#主程式開始
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680107
 
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680107
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107
DEFINE   l_sql          STRING                       #No.FUN-840019
DEFINE   g_str          STRING                       #No.FUN-840019
DEFINE   l_table        STRING                       #No.FUN-840019
 
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0082
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   #No.FUN-840019-----start--
   LET l_sql = "npx01.npx_file.npx01,",
               "npx02.npx_file.npx02,",
               "npx04.npx_file.npx04,",
               "nma02.nma_file.nma02,",
               "npx05.npx_file.npx05,",
               "npx03.npx_file.npx03,",
               "npx06.npx_file.npx06,",
               "npy02.npy_file.npy02,",
               "npy03.npy_file.npy03,",
               "dses.type_file.chr1000,", 
               "npy04.npy_file.npy04,",
               "npy05.npy_file.npy05,",
               "npy06.npy_file.npy06"
   LET l_table = cl_prt_temptable('anms110',l_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF     
   #No.FUN-840019-----end
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW s110_w AT p_row,p_col
     WITH FORM "anm/42f/anms110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    CALL g_x.clear()   #FUN-590128
    LET g_forupd_sql = "SELECT * FROM npx_file WHERE npx01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s110_cl CURSOR FROM g_forupd_sql
 
    CALL s110_menu()
    CLOSE WINDOW s110_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211 
END MAIN
 
#QBE 查詢資料
FUNCTION s110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_npy.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_npx.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        npx01,npx02,npx03,npx04,npx05,npx06,npxuser,npxgrup,npxoriu,npxorig,npxdate    #No.TQC-C40170  add oriu,orig
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
                WHEN INFIELD (npx02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO npx02
                     NEXT FIELD npx02
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND npxuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND npxgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND npxgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('npxuser', 'npxgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON npy02,npy03,npy04,npy05,npy06        # 螢幕上取單身條件
            FROM s_npy[1].npy02,s_npy[1].npy03,s_npy[1].npy04,s_npy[1].npy05 ,s_npy[1].npy06
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
                WHEN INFIELD (npy03)
                     CALL q_anm(FALSE,TRUE,g_npy[1].npy03)
                #         RETURNING g_qryparam.multiret
                          RETURNING g_npy[1].npy03,g_npy[1].dses
        #      DISPLAY g_qryparam.multiret TO npy03
                      DISPLAY g_npy[1].npy03 TO npy03
                      DISPLAY g_npy[1].dses  TO dses
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT npx01 FROM npx_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY npx01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE npx01 ",
                   "  FROM npx_file, npy_file ",
                   " WHERE npx01 = npy01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY npx01"
    END IF
 
    PREPARE s110_prepare FROM g_sql
    DECLARE s110_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s110_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM npx_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT npx01) FROM npx_file,npy_file WHERE ",
                  "npy01=npx01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE s110_precount FROM g_sql
    DECLARE s110_count CURSOR FOR s110_precount
 
END FUNCTION
 
FUNCTION s110_menu()
 
   WHILE TRUE
      CALL s110_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL s110_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s110_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL s110_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL s110_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL s110_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-590128 將mark拿掉
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL s110_out()
            END IF
#END FUN-590128
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-5A0108
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_npy),'','')
             END IF
#END FUN-5A0108
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION s110_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_npy.clear()
    INITIALIZE g_npx.* LIKE npx_file.*             #DEFAULT 設定
    LET g_npx01_t = NULL
    #預設值及將數值類變數清成零
    LET g_npx.npx04=0
    LET g_npx.npx05=0
    LET g_npx.npx06=0
    LET g_npx_o.* = g_npx.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_npx.npxuser=g_user
        LET g_npx.npxgrup=g_grup
        LET g_npx.npxdate=g_today
        LET g_npx.npxoriu=g_user     #No.TQC-C40170
        LET g_npx.npxorig=g_grup     #No.TQC-C40170
        CALL s110_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_npx.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_npx.npx01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_npx.npxoriu = g_user      #No.FUN-980030 10/01/04
        LET g_npx.npxorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO npx_file VALUES (g_npx.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_npx.npx01,SQLCA.sqlcode,1)   #No.FUN-660148
            CALL cl_err3("ins","npx_file",g_npx.npx01,"",SQLCA.sqlcode,"","",1) #No.FUN-660148
            CONTINUE WHILE
        END IF
display 'npx insert ok'
        SELECT npx01 INTO g_npx.npx01 FROM npx_file
            WHERE npx01 = g_npx.npx01
        LET g_npx01_t = g_npx.npx01        #保留舊值
        LET g_npx_t.* = g_npx.*
 
        CALL g_npy.clear()
        LET g_rec_b = 0
 
        CALL s110_b()                   #輸入單身
        CALL s110_show()      #No.TQC-C40170
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s110_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_npx.npx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_npx.* FROM npx_file WHERE npx01=g_npx.npx01
 
    CALL cl_opmsg('u')
    LET g_npx01_t = g_npx.npx01
    LET g_npx_o.* = g_npx.*
    BEGIN WORK
    OPEN s110_cl USING g_npx.npx01
    FETCH s110_cl INTO g_npx.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)      # 資料被他人LOCK   
        CLOSE s110_cl ROLLBACK WORK RETURN
    END IF
    CALL s110_show()
    WHILE TRUE
        LET g_npx01_t = g_npx.npx01
        LET g_npx.npxdate=g_today
        CALL s110_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_npx.*=g_npx_t.*
            CALL s110_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_npx.npx01 != g_npx01_t THEN            # 更改單號
            UPDATE npy_file SET npy01 = g_npx.npx01
                WHERE npy01 = g_npx01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('npy',SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","npy_file",g_npx01_t,"",SQLCA.sqlcode,"","npy",0) #No.FUN-660148
                CONTINUE WHILE
            END IF
        END IF
        UPDATE npx_file SET npx_file.* = g_npx.*
            WHERE npx01 = g_npx.npx01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","npx_file",g_npx01_t,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s110_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION s110_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入  #No.FUN-680107
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改           #No.FUN-680107
    l_desc          LIKE type_file.chr1000,  #FUN-680107
    l_nna02         LIKE nna_file.nna02,
    l_nma02         LIKE nma_file.nma02,
    l_cnt           LIKE type_file.num5      #No.FUN-680107
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME
        g_npx.npx01,g_npx.npx02,g_npx.npx03,g_npx.npx04,
        g_npx.npx05,g_npx.npx06,
        g_npx.npxuser,g_npx.npxgrup,g_npx.npxdate
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL s110_set_entry(p_cmd)
            CALL s110_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD npx01                  #簽核等級
            IF NOT cl_null(g_npx.npx01) THEN
               IF g_npx.npx01 != g_npx01_t OR g_npx01_t IS NULL THEN
                  SELECT count(*) INTO g_cnt FROM npx_file
                   WHERE npx01 = g_npx.npx01
                  IF g_cnt > 0 THEN   #資料重複
                      CALL cl_err(g_npx.npx01,-239,0)
                      LET g_npx.npx01 = g_npx01_t
                      DISPLAY BY NAME g_npx.npx01
                      NEXT FIELD npx01
                  END IF
               END IF
            END IF
 
        AFTER FIELD npx02 #銀行代號
            IF NOT cl_null(g_npx.npx02) THEN
               SELECT nma02 INTO l_nma02 FROM nma_file
                WHERE nma01=g_npx.npx02
               IF STATUS OR cl_null(l_nma02) THEN
#                 CALL cl_err('','anm-013',0)   #No.FUN-660148
                  CALL cl_err3("sel","nma_file",g_npx.npx02,"","anm-013","","",0) #No.FUN-660148
                  NEXT FIELD npx02
               END IF
               DISPLAY l_nma02 TO FORMONLY.nma02
            END IF
 
        AFTER FIELD npx03 #簿號
            IF NOT cl_null(g_npx.npx03) THEN
               SELECT nna02 INTO l_nna02 FROM nna_file
                WHERE nna01=g_npx.npx02
                AND nna02=g_npx.npx03
                AND nna021= (SELECT MAX(nna021) FROM nna_file
                     WHERE nna01 = g_npx.npx02 AND nna02 = g_npx.npx03)
               IF STATUS OR cl_null(l_nna02) THEN
#                 CALL cl_err('','anm-134',0)   #No.FUN-660148
                  CALL cl_err3("sel","nna_file",g_npx.npx02, g_npx.npx03,"anm-134","","",0) #No.FUN-660148
                  NEXT FIELD npx03
               END IF
            END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN EXIT INPUT  END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       
        #MOD-650015 --start  
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(npx01) THEN
        #        LET g_npx.* = g_npx_t.*
        #        DISPLAY BY NAME g_npx.*
        #        NEXT FIELD npx01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION controlp
           CASE
                WHEN INFIELD (npx02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma"
                     LET g_qryparam.default1 = g_npx.npx02
                     CALL cl_create_qry() RETURNING g_npx.npx02
#                     CALL FGL_DIALOG_SETBUFFER( g_npx.npx02 )
                     DISPLAY BY NAME g_npx.npx02
                     NEXT FIELD npx02
                OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION s110_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("npx01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION s110_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("npx01",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION s110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
   CALL g_npy.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s110_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN s110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_npx.* TO NULL
    ELSE
       OPEN s110_count
       FETCH s110_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL s110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION s110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680107
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680107
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     s110_cs INTO g_npx.npx01
        WHEN 'P' FETCH PREVIOUS s110_cs INTO g_npx.npx01
        WHEN 'F' FETCH FIRST    s110_cs INTO g_npx.npx01
        WHEN 'L' FETCH LAST     s110_cs INTO g_npx.npx01
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
            FETCH ABSOLUTE g_jump s110_cs INTO g_npx.npx01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)
        INITIALIZE g_npx.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_npx.* FROM npx_file WHERE npx01 = g_npx.npx01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","npx_file",g_npx.npx01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
        INITIALIZE g_npx.* TO NULL
        RETURN
    END IF
 
    CALL s110_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION s110_show()
    DEFINE l_cnt      LIKE type_file.num5        #No.FUN-680107
    DEFINE l_desc     LIKE cre_file.cre08        #FUN-680107
    DEFINE l_nma02    LIKE nma_file.nma02
    LET g_npx_t.* = g_npx.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_npx.npx01,g_npx.npx02,g_npx.npx03,
        g_npx.npx04,g_npx.npx05,
        g_npx.npx06,
        g_npx.npxuser,g_npx.npxgrup,
        g_npx.npxdate,g_npx.npxoriu,g_npx.npxorig    #No.TQC-C40170
    SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=g_npx.npx02
    DISPLAY l_nma02 TO FORMONLY.nma02
    CALL s110_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION s110_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_npx.npx01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN s110_cl USING g_npx.npx01
    FETCH s110_cl INTO g_npx.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE s110_cl ROLLBACK WORK RETURN
    END IF
    CALL s110_show()
    IF cl_delh(0,0) THEN                   #確認一下
       DELETE FROM npx_file WHERE npx01 = g_npx.npx01
       DELETE FROM npy_file WHERE npy01 = g_npx.npx01
       INITIALIZE g_npx.* TO NULL
       CLEAR FORM
       CALL g_npy.clear()
       OPEN s110_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE s110_cs
          CLOSE s110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH s110_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE s110_cs
          CLOSE s110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN s110_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL s110_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL s110_fetch('/')
       END IF
    END IF
    CLOSE s110_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION s110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680107
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680107
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680107
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680107
    l_allow_insert  LIKE type_file.num5,                #FUN-680107        #可新增否
    l_allow_delete  LIKE type_file.num5                 #FUN-680107        #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_npx.npx01 IS NULL THEN RETURN END IF
    SELECT * INTO g_npx.* FROM npx_file WHERE npx01=g_npx.npx01
 
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT npy02,npy03,'',npy04,npy05,npy06 FROM npy_file ",
                       "WHERE npy01= ? AND npy02= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s110_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    INPUT ARRAY g_npy WITHOUT DEFAULTS FROM s_npy.*
          ATTRIBUTE(COUNT=g_rec_b,
                    MAXCOUNT=g_max_rec,
                    UNBUFFERED,
                    INSERT ROW=l_allow_insert,
                    DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN s110_cl USING g_npx.npx01
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE s110_cl ROLLBACK WORK RETURN
            END IF
            FETCH s110_cl INTO g_npx.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE s110_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_npy_t.* = g_npy[l_ac].*  #BACKUP
                OPEN s110_bcl USING g_npx.npx01,g_npy_t.npy02
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_npy_t.npy02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH s110_bcl INTO g_npy[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_npy_t.npy02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                     CALL s110_desc(g_npy[l_ac].npy03) RETURNING g_npy[l_ac].dses
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_npy[l_ac].* TO NULL      #900423
            LET g_npy[l_ac].npy06 = 'N' #MOD-640075 add
            LET g_npy_t.* = g_npy[l_ac].*         #新輸入資料
            CALL s110_desc(g_npy[l_ac].npy03) RETURNING g_npy[l_ac].dses
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD npy02
 
        AFTER INSERT
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
             # CALL g_npy.deleteElement(l_ac)
             # IF g_rec_b != 0 THEN
             #    LET g_action_choice="detail"
             #    LET l_ac = l_ac_t
             # END IF
             # EXIT INPUT
            END IF
            INSERT INTO npy_file(npy01,npy02,npy03,npy04,npy05,npy06)
                          VALUES(g_npx.npx01,g_npy[l_ac].npy02,g_npy[l_ac].npy03,
                                 g_npy[l_ac].npy04,g_npy[l_ac].npy05,g_npy[l_ac].npy06)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_npy[l_ac].npy02,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("ins","npy_file",g_npx.npx01,g_npy[l_ac].npy02,SQLCA.sqlcode,"","",0) #No.FUN-660148
               #LET g_npy[l_ac].* = g_npy_t.*
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD npy02                        #default 序號
            IF g_npy[l_ac].npy02 IS NULL OR
               g_npy[l_ac].npy02 = 0 THEN
                SELECT max(npy02)+1
                   INTO g_npy[l_ac].npy02
                   FROM npy_file
                   WHERE npy01 = g_npx.npx01
                IF g_npy[l_ac].npy02 IS NULL THEN
                    LET g_npy[l_ac].npy02 = 1
                END IF
            END IF
 
        AFTER FIELD npy02                        #check 序號是否重複
            IF NOT cl_null(g_npy[l_ac].npy02) THEN
               IF g_npy[l_ac].npy02 != g_npy_t.npy02 OR
                  g_npy_t.npy02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM npy_file
                    WHERE npy01 = g_npx.npx01 AND
                          npy02 = g_npy[l_ac].npy02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_npy[l_ac].npy02 = g_npy_t.npy02
                       NEXT FIELD npy02
                   END IF
               END IF
            END IF
 
        AFTER FIELD npy03
            IF NOT cl_null(g_npy[l_ac].npy03) THEN
               IF g_npy[l_ac].npy03 NOT MATCHES '[ABCDEFGHIJKLMS]' THEN
                  CALL cl_err('','anm-700',0)
                  NEXT FIELD npy03
               END IF
               CALL s110_desc(g_npy[l_ac].npy03) RETURNING g_npy[l_ac].dses
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_npy[l_ac].dses
               #------MOD-5A0095 END------------
            END IF
#TQC-740058.....begin                                                           
        AFTER FIELD npy04                                                       
            IF NOT cl_null(g_npy[l_ac].npy04) THEN                              
               IF g_npy[l_ac].npy04 < 0 THEN                                    
                  CALL cl_err(g_npy[l_ac].npy04,'aim1007',0)                    
                  NEXT FIELD npy04                                              
               END IF                                                           
            END IF                                                              
#TQC-740058.....end
 
        AFTER FIELD npy05
#TQC-740058.....begin                                                           
            IF NOT cl_null(g_npy[l_ac].npy05) THEN                              
               IF g_npy[l_ac].npy05 < 0 THEN                                    
                  CALL cl_err(g_npy[l_ac].npy05,'aim1007',0)                    
                  NEXT FIELD npy05                                              
               END IF                                                           
#TQC-740058.....end
               IF g_npy[l_ac].npy05 > 80 THEN
                  NEXT FIELD npy05
               END IF
            END IF    #TQC-740058   
 
        AFTER FIELD npy06
            IF NOT cl_null(g_npy[l_ac].npy06) THEN
               IF g_npy[l_ac].npy06 NOT MATCHES '[YN]' THEN
                  NEXT FIELD npy06
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_npy_t.npy02 > 0 AND
               g_npy_t.npy02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM npy_file
                    WHERE npy01 = g_npx.npx01 AND
                          npy02 = g_npy_t.npy02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_npy_t.npy02,SQLCA.sqlcode,0)   #No.FUN-660148
                    CALL cl_err3("del","npy_file",g_npx.npx01, g_npy_t.npy02,SQLCA.sqlcode,"","",0) #No.FUN-660148
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_npy[l_ac].* = g_npy_t.*
              CLOSE s110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_npy[l_ac].npy02,-263,0)
              LET g_npy[l_ac].* = g_npy_t.*
           ELSE
               UPDATE npy_file SET
                               npy02=g_npy[l_ac].npy02,
                               npy03=g_npy[l_ac].npy03,
                               npy04=g_npy[l_ac].npy04,
                               npy05=g_npy[l_ac].npy05,
                               npy06=g_npy[l_ac].npy06
                         WHERE npy01 = g_npx.npx01
                           AND npy02 = g_npy_t.npy02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_npy[l_ac].npy02,SQLCA.sqlcode,0)   #No.FUN-660148
                   CALL cl_err3("upd","npy_file",g_npx.npx01, g_npy_t.npy02,SQLCA.sqlcode,"","",0) #No.FUN-660148
                   LET g_npy[l_ac].* = g_npy_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_npy[l_ac].* = g_npy_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_npy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE s110_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
          #LET g_npy_t.* = g_npy[l_ac].*
           LET l_ac_t = l_ac
           CLOSE s110_bcl
           COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL s110_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(npy02) AND l_ac > 1 THEN
                LET g_npy[l_ac].* = g_npy[l_ac-1].*
                LET g_npy[l_ac].npy02 = NULL   #TQC-620018
                NEXT FIELD npy02
            END IF
 
        ON ACTION controlp
           CASE
                WHEN INFIELD (npy03)
                     CALL q_anm(FALSE,FALSE,g_npy[l_ac].npy03)
                          RETURNING g_npy[l_ac].npy03,g_npy[l_ac].dses
                    #CALL FGL_DIALOG_SETBUFFER( g_npy[l_ac].npy03 )
                    #CALL FGL_DIALOG_SETBUFFER( g_npy[l_ac].dses )
                     DISPLAY g_npy[l_ac].npy03 TO npy03
                     DISPLAY g_npy[l_ac].dses TO dses
                OTHERWISE EXIT CASE
           END CASE
 
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
    END INPUT
 
    CLOSE s110_bcl
    COMMIT WORK
 
    CALL s110_delall()
 
END FUNCTION
 
FUNCTION s110_delall()
display 'delete all'
    SELECT COUNT(*) INTO g_cnt FROM npy_file
     WHERE npy01 = g_npx.npx01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM npx_file WHERE npx01 = g_npx.npx01
    END IF
 
END FUNCTION
 
FUNCTION s110_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680107
 
    CONSTRUCT l_wc2 ON npy02,npy03,npy04,npy05
         FROM s_npy[1].npy02,s_npy[1].npy03,s_npy[1].npy04,s_npy[1].npy05,s_npy[1].npy06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
                WHEN INFIELD (npy03)
                #    CALL q_anm(TRUE,TRUE,g_npy[1].npy03)
                #         RETURNING g_npy[1].npy03,g_npy[1].dses
                     DISPLAY g_npy[1].npy03 TO s_npy[1].npy03
                     DISPLAY g_npy[1].dses  TO s_npy[1].dses
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL s110_b_fill(l_wc2)
END FUNCTION
 
FUNCTION s110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680107
 
    LET g_sql =
        "SELECT npy02,npy03,'',npy04,npy05,npy06 ",
        " FROM npy_file ",
        " WHERE npy01 ='",g_npx.npx01,"' AND ",  #單頭
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE s110_pb FROM g_sql
    DECLARE npy_curs                       #SCROLL CURSOR
        CURSOR FOR s110_pb
 
    CALL g_npy.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH npy_curs INTO g_npy[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s110_desc(g_npy[g_cnt].npy03) RETURNING g_npy[g_cnt].dses
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_npy.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION s110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_npy TO s_npy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL s110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL s110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL s110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL s110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL s110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#FUN-590128 將mark拿掉
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#END FUN-590128
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#FUN-5A0108
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#END FUN-5A0108
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION s110_copy()
DEFINE
    l_npx		RECORD LIKE npx_file.*,
    l_oldno,l_newno	LIKE npx_file.npx01
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_npx.npx01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL s110_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM npx01
        AFTER FIELD npx01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM npx_file
                   WHERE npx01 = l_newno
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD npx01
               END IF
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
        DISPLAY BY NAME g_npx.npx01
        RETURN
    END IF
    LET l_npx.* = g_npx.*
    LET l_npx.npx01  =l_newno   #新的鍵值
    LET l_npx.npxuser=g_user    #資料所有者
    LET l_npx.npxgrup=g_grup    #資料所有者所屬群
    LET l_npx.npxdate=g_today   #資料建立日期
    BEGIN WORK
    LET l_npx.npxoriu = g_user      #No.FUN-980030 10/01/04
    LET l_npx.npxorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO npx_file VALUES (l_npx.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('npx:',SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("ins","npx_file",l_npx.npx01,"",SQLCA.sqlcode,"","npx:",0) #No.FUN-660148
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM npy_file         #單身複製
        WHERE npy01=g_npx.npx01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_npx.npx01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("ins","x",g_npx.npx01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
        RETURN
    END IF
    UPDATE x
        SET   npy01=l_newno
    INSERT INTO npy_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('npy:',SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("ins","npy_file",l_newno,"",SQLCA.sqlcode,"","npy:",0) #No.FUN-660148
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_npx.npx01
     SELECT npx_file.* INTO g_npx.* FROM npx_file WHERE npx01 = l_newno
     CALL s110_u()
     CALL s110_b()
     #SELECT npx_file.* INTO g_npx.* FROM npx_file WHERE npx01 = l_oldno  #FUN-C80046
     #CALL s110_show()  #FUN-C80046
END FUNCTION
 
#FUN-590128
FUNCTION s110_out()
    DEFINE
        sr         RECORD
          npx01    LIKE npx_file.npx01,
          npx02    LIKE npx_file.npx02,
          nma02    LIKE nma_file.nma02,
          npx03    LIKE npx_file.npx03,
          npx04    LIKE npx_file.npx04,
          npx05    LIKE npx_file.npx05,
          npx06    LIKE npx_file.npx06,
          npy02    LIKE npy_file.npy02,
          npy03    LIKE npy_file.npy03,
          dses     LIKE type_file.chr1000,  #FUN-680107
          npy04    LIKE npy_file.npy04,
          npy05    LIKE npy_file.npy05,
          npy06    LIKE npy_file.npy06
         END RECORD,
         l_name    LIKE type_file.chr20     # External(Disk) file name        #No.FUN-680107
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_del_data(l_table)    #No.FUN-840019
    CALL cl_wait()
    #CALL cl_outnam('anms110') RETURNING l_name     #No.FUN-840019
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anms110'  #No.FUN-840019    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT npx01,npx02,'',npx03,npx04,npx05,npx06,npy02,npy03,",
              "       '',npy04,npy05,npy06 ",
              "  FROM npx_file,npy_file ",
              " WHERE ",g_wc CLIPPED ,
              "   AND npx01 = npy01 ",
              " ORDER BY npx01 "
    PREPARE s110_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s110_co CURSOR FOR s110_p1
 
    #START REPORT s110_rep TO l_name     #No.FUN-840019
 
    FOREACH s110_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
            END IF
        #No.FUN-840019-----start--
        SELECT nma02 INTO sr.nma02 FROM nma_file
           WHERE nma01=sr.npx02        
        CALL s110_desc(sr.npy03) RETURNING sr.dses
        EXECUTE insert_prep USING
            sr.npx01,sr.npx02,sr.npx04,sr.nma02,sr.npx05,sr.npx03,
            sr.npx06,sr.npy02,sr.npy03,sr.dses,sr.npy04,sr.npy05,sr.npy06
        #No.FUN-840019-----end  
        #OUTPUT TO REPORT s110_rep(sr.*)    #No.FUN-840019
    END FOREACH
 
    #FINISH REPORT s110_rep    #No.FUN-840019
    #No.FUN-840019-----start--
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'npx01,npx02,npx03,npx04,npx05,npx06,npxuser,npxgrup,
                           npxdate,npy02,npy03,npy04,npy05,npy06') 
            RETURNING g_wc
            LET g_str = g_wc
    END IF
    
    LET g_str = g_str
                           
    CALL cl_prt_cs3('anms110','anms110',l_sql,g_str)
    #No.FUN-840019-----end   
 
    CLOSE s110_co
 
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)    #No.FUN-840019
END FUNCTION
 
#No.FUN-840019-----------start--
#REPORT s110_rep(sr)
#    DEFINE
#        sr         RECORD
#          npx01    LIKE npx_file.npx01,
#          npx02    LIKE npx_file.npx02,
#          nma02    LIKE nma_file.nma02,
#          npx03    LIKE npx_file.npx03,
#          npx04    LIKE npx_file.npx04,
#          npx05    LIKE npx_file.npx05,
#          npx06    LIKE npx_file.npx06,
#          npy02    LIKE npy_file.npy02,
#          npy03    LIKE npy_file.npy03,
#          dses     LIKE type_file.chr1000,       #FUN-680107
#          npy04    LIKE npy_file.npy04,
#          npy05    LIKE npy_file.npy05,
#          npy06    LIKE npy_file.npy06
#         END RECORD,
#         l_trailer_sw    LIKE type_file.chr1     #FUN-680107
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.npx01,sr.npy02
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            SELECT nma02 INTO sr.nma02 FROM nma_file
#              WHERE nma01=sr.npx02
#            PRINT COLUMN 1,g_x[9],COLUMN 11,sr.npx01,
#                  COLUMN 16,g_x[10],COLUMN 26,sr.npx02,
#                  COLUMN 43,g_x[13],COLUMN 53,sr.npx04
#            PRINT COLUMN 16,g_x[11],COLUMN 26,sr.nma02,
#                  COLUMN 43,g_x[14],COLUMN 53,sr.npx05
#            PRINT COLUMN 16,g_x[12],COLUMN 26,sr.npx03,
#                  COLUMN 43,g_x[15],COLUMN 53,sr.npx06
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.npx01
#            SKIP TO TOP OF PAGE
#
#        ON EVERY ROW
#            CALL s110_desc(sr.npy03) RETURNING sr.dses
#            PRINT COLUMN g_c[31],sr.npy02 USING '###&', #FUN-590118
#                  COLUMN g_c[32],sr.npy03,
#                  COLUMN g_c[33],sr.dses,
#                  COLUMN g_c[34],sr.npy04,
#                  COLUMN g_c[35],sr.npy05,
#                  COLUMN g_c[36],sr.npy06
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840019----end 
#END FUN-590128
 
 
FUNCTION s110_desc(p_npy03)
DEFINE p_npy03  LIKE npy_file.npy03
DEFINE l_desc   LIKE type_file.chr1000  #FUN-680107
 
     CASE p_npy03
#FUN-590128
           WHEN 'A' LET l_desc=cl_getmsg('anm-300',g_lang)
           WHEN 'B' LET l_desc=cl_getmsg('anm-301',g_lang)
           WHEN 'C' LET l_desc=cl_getmsg('anm-302',g_lang)
           WHEN 'D' LET l_desc=cl_getmsg('anm-303',g_lang)
           WHEN 'E' LET l_desc=cl_getmsg('anm-304',g_lang)
           WHEN 'F' LET l_desc=cl_getmsg('anm-305',g_lang)
           WHEN 'G' LET l_desc=cl_getmsg('anm-306',g_lang)
           WHEN 'H' LET l_desc=cl_getmsg('anm-307',g_lang)
           WHEN 'I' LET l_desc=cl_getmsg('anm-308',g_lang)
           WHEN 'J' LET l_desc=cl_getmsg('anm-309',g_lang)
           WHEN 'K' LET l_desc=cl_getmsg('anm-310',g_lang)
           WHEN 'L' LET l_desc=cl_getmsg('anm-311',g_lang)
           WHEN 'M' LET l_desc=cl_getmsg('anm-312',g_lang)
           WHEN 'S' LET l_desc=cl_getmsg('anm-313',g_lang)
#          WHEN 'A' LET l_desc='開票日'
#          WHEN 'B' LET l_desc='到期日'
#          WHEN 'C' LET l_desc='受款人'
#          WHEN 'D' LET l_desc='帳號日'
#          WHEN 'E' LET l_desc='大寫國字金額'
#          WHEN 'F' LET l_desc='小寫國字金額'
#          WHEN 'G' LET l_desc='禁止背書轉讓'
#          WHEN 'H' LET l_desc='存根  受款人'
#          WHEN 'I' LET l_desc='存根  開票日'
#          WHEN 'J' LET l_desc='存根  到期日'
#          WHEN 'K' LET l_desc='存根  金  額'
#          WHEN 'L' LET l_desc='廠商編號'
#          WHEN 'M' LET l_desc='付款單號'
#          WHEN 'S' LET l_desc='空白'
#END FUN-590128
     END CASE
     RETURN l_desc
END FUNCTION
#Patch....NO.MOD-5A0095 <003> #
