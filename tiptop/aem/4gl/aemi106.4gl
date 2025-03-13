# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi106.4gl
# Descriptions...: 設備儀表維護作業
# Date & Author..: 04/07/08 By Carrier
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750213 07/05/28 By jamie show上下限的合理性控制的錯誤訊息
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query
# Modify.........: No.TQC-930027 09/03/06 By mike 查詢指定筆時的KEY值不正確
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990123 09/10/09 By lilingyu 度量單位"上限 下限",單身"數值"輸入負數沒有控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 11/12/28 By tanxc 增加數量欄位小數取位  

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fig            RECORD LIKE fig_file.*,
    g_fig_t          RECORD LIKE fig_file.*,
    g_fig01_t        LIKE fig_file.fig01,
    g_fig02_t        LIKE fig_file.fig02,
    g_fih            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variatpss)
        fih03        LIKE fih_file.fih03,
        fih04        LIKE fih_file.fih04,
        fih05        LIKE fih_file.fih05
                     END RECORD,
    g_fih_t          RECORD                 #程式變數 (舊值)
        fih03        LIKE fih_file.fih03,
        fih04        LIKE fih_file.fih04,
        fih05        LIKE fih_file.fih05
                     END RECORD,
    g_argv1          LIKE fig_file.fig01,
    g_argv2          LIKE fig_file.fig02,
    g_wc,g_wc2,g_sql STRING   , #TQC-630166   
    g_rec_b          LIKE type_file.num5,                #單身筆數        #No.FUN-680072 SMALLINT
    l_ac             LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680072CHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037
DEFINE   g_fig03_t       LIKE fig_file.fig03          #No.FUN-BB0086 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_wc2= " 1=1"
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0068
 
    LET g_forupd_sql = "SELECT * FROM fig_file WHERE fig01 = ? AND fig02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i106_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i106_w WITH FORM "aem/42f/aemi106"
         ATTRIBUTE(STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i106_q()
       CALL i106_b_fill(g_wc2)
    END IF
 
    CALL g_x.clear()
 
    CALL i106_menu()
 
    CLOSE WINDOW i106_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i106_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_fih.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " 1=1"
       LET g_wc  = "  fig01 = '",g_argv1 CLIPPED,"'"
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = "   AND fig02 = '",g_argv2 CLIPPED,"'"
       END IF
       LET g_sql = "SELECT fig01,fig02 FROM fig_file ",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY 1,2"
    ELSE
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029    
   INITIALIZE g_fig.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           fig01,fig02,fig03,fig04,fig05,
           figuser,figgrup,figmodu,figdate,figacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
          ON ACTION CONTROLP
             CASE
                 WHEN INFIELD(fig01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_fia"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO fig01
                     NEXT FIELD fig01
                 WHEN INFIELD(fig02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_fif"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO fig02
                     NEXT FIELD fig02
                WHEN INFIELD(fig03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO fig03
                     NEXT FIELD fig03
             END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND figuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND figgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND figgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('figuser', 'figgrup')
       #End:FUN-980030
 
 
       CONSTRUCT g_wc2 ON fih03,fih04,fih05  #螢幕上取單身條件
                  FROM s_fih[1].fih03,s_fih[1].fih04,s_fih[1].fih05
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
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
       IF INT_FLAG THEN RETURN END IF
       IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT fig01,fig02 FROM fig_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY 1,2"
       ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE fig01,fig02 ",
                      "  FROM fig_file, fih_file ",
                      " WHERE fig01 = fih01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY 1,2"
       END IF
    END IF
 
    PREPARE i106_prepare FROM g_sql
    DECLARE i106_cs                         #SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR i106_prepare
 
    #No.TQC-720019  --Begin
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE fig01,fig02 FROM fig_file WHERE ",g_wc CLIPPED,
                      " INTO TEMP x "
    ELSE
        LET g_sql_tmp="SELECT UNIQUE fig01,fig02 FROM fig_file,fih_file ",
                      " WHERE fig01=fih01 AND fig02=fih02 ",
                      " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " INTO TEMP x "
    END IF
    DROP TABLE x
    PREPARE i106_precount_x FROM g_sql_tmp
    EXECUTE i106_precount_x
    LET g_sql = " SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End  
    PREPARE i106_precount FROM g_sql
    DECLARE i106_count CURSOR FOR i106_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION i106_menu()
 
   WHILE TRUE
      CALL i106_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i106_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i106_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i106_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i106_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i106_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i106_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i106_x()
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
           #No.FUN-780037---Begin     
           #  CALL i106_out()
              IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
              LET l_cmd = 'p_query "aemi106" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'               
              CALL cl_cmdrun(l_cmd)   
           #No.FUN-780037---End 
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No.FUN-6B0050-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_fig.fig01 IS NOT NULL THEN
               LET g_doc.column1 = "fig01"
               LET g_doc.column2 = "fig02"
               LET g_doc.value1 = g_fig.fig01
               LET g_doc.value2 = g_fig.fig02
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i106_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_fih.clear()
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fig.* LIKE fig_file.*             #DEFAULT 設定
    LET g_fig01_t = NULL
    LET g_fig02_t = NULL
    LET g_fig_t.* = g_fig.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fig.fig04 = 0
        LET g_fig.fig05 = 0
        LET g_fig.figuser=g_user
        LET g_fig.figoriu = g_user #FUN-980030
        LET g_fig.figorig = g_grup #FUN-980030
        LET g_fig.figgrup=g_grup
        LET g_fig.figdate=g_today
        LET g_fig.figacti='Y'              #資料有效
        CALL i106_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fig.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fig.fig01 IS NULL OR g_fig.fig02 IS NULL THEN  # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO fig_file VALUES (g_fig.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fig.fig01,SQLCA.sqlcode,1)   #No.FUN-660092
           CALL cl_err3("ins","fig_file",g_fig.fig01,g_fig.fig02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
           CONTINUE WHILE
        END IF
        SELECT fig01,fig02 INTO g_fig.fig01,g_fig.fig02 FROM fig_file
         WHERE fig01 = g_fig.fig01 AND fig02 = g_fig.fig02
        LET g_fig01_t = g_fig.fig01        #保留舊值
        LET g_fig02_t = g_fig.fig02        #保留舊值
        LET g_fig_t.* = g_fig.*
 
        CALL g_fih.clear()
        LET g_rec_b=0
        CALL i106_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i106_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fig.fig01 IS NULL OR g_fig.fig02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    SELECT * INTO g_fig.* FROM fig_file
     WHERE fig01=g_fig.fig01
       AND fig02=g_fig.fig02
 
    IF g_fig.figacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_fig.fig01,'mfg1000',0) RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fig01_t = g_fig.fig01
    LET g_fig02_t = g_fig.fig02
    LET g_fig_t.* = g_fig.*
    BEGIN WORK
    OPEN i106_cl USING g_fig.fig01,g_fig.fig02
    IF STATUS THEN
       CALL cl_err("OPEN i106_cl:", STATUS, 1)
       CLOSE i106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i106_cl INTO g_fig.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i106_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_fig.figmodu=g_user
    LET g_fig.figdate=g_today
    CALL i106_show()
    WHILE TRUE
        CALL i106_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fig.*=g_fig_t.*
            CALL i106_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fig.fig01 != g_fig01_t OR g_fig.fig02 != g_fig02_t THEN
            UPDATE fih_file SET fih01 = g_fig.fig01,fih02 = g_fig.fig02
             WHERE fih01 = g_fig01_t AND fih02 = g_fig02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fih',SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fih_file",g_fig01_t,g_fig02_t,SQLCA.sqlcode,"","fih",1)  #No.FUN-660092
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fig_file
           SET fig_file.* = g_fig.*
         WHERE fig01=g_fig01_t AND fig02=g_fig02_t 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fig_file",g_fig01_t,g_fig02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660092
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i106_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i106_i(p_cmd)
DEFINE
    l_n	      LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_sw      LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    p_cmd     LIKE type_file.chr1,           #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    l_tf      LIKE type_file.chr1,           #No.FUN-BB0086
    l_case    STRING            #No.FUN-BB0086
    
   IF s_shut(0) THEN RETURN END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0029 
   INPUT BY NAME g_fig.figoriu,g_fig.figorig,
        g_fig.fig01,g_fig.fig02,g_fig.fig03,g_fig.fig04,g_fig.fig05,
        g_fig.figuser,g_fig.figgrup,g_fig.figmodu,g_fig.figdate,g_fig.figacti
        WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i106_set_entry(p_cmd)
            CALL i106_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-BB0086--add--begin--
            IF p_cmd = 'u' THEN 
               LET g_fig03_t = g_fig.fig03
            END IF 
            IF p_cmd = 'a' THEN 
               LET g_fig03_t = NULL 
            END IF 
            #No.FUN-BB0086--add--end--
 
        AFTER FIELD fig01
            IF NOT cl_null(g_fig.fig01) THEN
               CALL i106_fig01('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_fig.fig01,g_errno,0)
                  LET g_fig.fig01 = g_fig_t.fig01
                  DISPLAY BY NAME g_fig.fig01
                  NEXT FIELD fig01
               END IF
            END IF
 
        AFTER FIELD fig02
            IF NOT cl_null(g_fig.fig02) THEN
               CALL i106_fig02('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_fig.fig02,g_errno,0)
                  LET g_fig.fig02 = g_fig_t.fig02
                  DISPLAY BY NAME g_fig.fig02
                  NEXT FIELD fig02
               END IF
               IF g_fig.fig01 != g_fig_t.fig01 OR g_fig_t.fig01 IS NULL
               OR g_fig.fig02 != g_fig_t.fig02 OR g_fig_t.fig02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM fig_file
                   WHERE fig01 = g_fig.fig01
                     AND fig02 = g_fig.fig02
                  IF g_cnt > 0 THEN   #資料重復
                     CALL cl_err(g_fig.fig01,-239,0)
                     LET g_fig.fig01 = g_fig_t.fig01
                     LET g_fig.fig02 = g_fig_t.fig02
                     DISPLAY BY NAME g_fig.fig01
                     DISPLAY BY NAME g_fig.fig02
                     NEXT FIELD fig01
                  END IF
               END IF
            END IF
 
        AFTER FIELD fig03
            IF NOT cl_null(g_fig.fig03) THEN
               SELECT gfe01 FROM gfe_file WHERE  gfe01= g_fig.fig03
               IF STATUS THEN
#                 CALL cl_err(g_fig.fig03,STATUS ,0)   #No.FUN-660092
                  CALL cl_err3("sel","gfe_file",g_fig.fig03,"",STATUS,"","",1)  #No.FUN-660092
                  LET g_fig.fig03 = g_fig_t.fig03
                  NEXT FIELD fig03
               END IF
               #No.FUN-BB0086--add--begin--
               CALL i106_fig05_check() RETURNING l_tf,l_case  
               IF NOT i106_fig04_check() THEN 
                  LET g_fig03_t = g_fig.fig03
                  NEXT FIELD fig04
               END IF 
               LET g_fig03_t = g_fig.fig03
               IF NOT l_tf THEN 
                  CASE l_case
                     WHEN "fig04"
                        NEXT FIELD fig04
                     WHEN "fig05"
                        NEXT FIELD fig05
                     OTHERWISE EXIT CASE 
                  END CASE 
               END IF 
               #No.FUN-BB0086--add--end--
            END IF
 
#TQC-990123 --begin--
        AFTER FIELD fig04
           #No.FUN-BB0086--add--begin--
           IF NOT i106_fig04_check() THEN
              NEXT FIELD fig04
           END IF 
           #No.FUN-BB0086--add--end--  
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_fig.fig04) THEN 
            #   IF g_fig.fig04 < 0 THEN 
            #      CALL cl_err('','aec-020',0)
            #      NEXT FIELD fig04
            #   END IF 
            #END IF 
            ##TQC-990123 --end--
            #No.FUN-BB0086--mark--end--
 
        AFTER FIELD fig05
            #No.FUN-BB0086--add--begin--
            LET l_tf = ""   
            LET l_case = ""  
            CALL i106_fig05_check() RETURNING l_tf,l_case   
            LET g_fig03_t = g_fig.fig03
            IF NOT l_tf THEN 
               CASE l_case 
                  WHEN "fig04"
                     NEXT FIELD fig04
                  WHEN "fig05"
                     NEXT FIELD fig05
                  OTHERWISE EXIT CASE 
               END CASE 
            END IF 
            #No.FUN-BB0086--add--end--
            #No.FUN-BB0086--mark--begin--
            ##TQC-990123 --begin--
            #IF NOT cl_null(g_fig.fig05) THEN 
            #   IF g_fig.fig05 < 0 THEN 
            #      CALL cl_err('','aec-020',0)
            #      NEXT FIELD fig05
            #   END IF 
            #   
            #END IF 
            ##TQC-990123 --end--           
            #IF g_fig.fig05 > g_fig.fig04 THEN
            #   CALL cl_err('','aem-050',0)       #TQC-750213 add
            #   NEXT FIELD fig04
            #END IF
            #No.FUN-BB0086--mark--end--

 
        AFTER INPUT
           LET g_fig.figuser = s_get_data_owner("fig_file") #FUN-C10039
           LET g_fig.figgrup = s_get_data_group("fig_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
{            SELECT COUNT(*) INTO l_n FROM fih_file
             WHERE fih05 NOT BETWEEN g_fig.fig05 AND g_fig.fig04
               AND fih01=g_fig.fig01 AND fih02=g_fig.fig02
            IF l_n > 0 THEN
               CALL cl_err('','aem-017',1)
            END IF
}
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                 #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fig01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fia"
                   LET g_qryparam.default1 = g_fig.fig01
                   CALL cl_create_qry() RETURNING g_fig.fig01
                   CALL FGL_DIALOG_SETBUFFER( g_fig.fig01 )
                   DISPLAY BY NAME g_fig.fig01
                   NEXT FIELD fig01
               WHEN INFIELD(fig02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fif"
                   LET g_qryparam.default1 = g_fig.fig02
                   CALL cl_create_qry() RETURNING g_fig.fig02
                   CALL FGL_DIALOG_SETBUFFER( g_fig.fig02 )
                   DISPLAY BY NAME g_fig.fig02
                   NEXT FIELD fig02
              WHEN INFIELD(fig03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_fig.fig03
                   CALL cl_create_qry() RETURNING g_fig.fig03
                   CALL FGL_DIALOG_SETBUFFER( g_fig.fig03 )
                   DISPLAY BY NAME g_fig.fig03
                   NEXT FIELD fig03
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
 
FUNCTION i106_fig01(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_fia02     LIKE fia_file.fia02,
        l_fiaacti   LIKE fia_file.fiaacti
 
  LET g_errno = ' '
  SELECT fia02,fiaacti INTO l_fia02,l_fiaacti
    FROM fia_file
   WHERE fia01 = g_fig.fig01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_fiaacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_fia02 TO FORMONLY.fia02
  END IF
END FUNCTION
 
FUNCTION i106_fig02(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_fif02     LIKE fif_file.fif02,
        l_fif04     LIKE fif_file.fif04
 
  LET g_errno = ' '
  SELECT fif02,fif04 INTO l_fif02,l_fif04
    FROM fif_file
   WHERE fif01 = g_fig.fig02
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                 LET l_fif04 = NULL
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_fif02 TO FORMONLY.fif02
     IF cl_null(g_fig.fig03) THEN
        LET g_fig.fig03= l_fif04
        DISPLAY BY NAME g_fig.fig03
     END IF
  END IF
END FUNCTION
 
#Query 查詢
FUNCTION i106_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fig.* TO NULL               #No.FUN-6B0050
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fih.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL i106_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fig.* TO NULL
        RETURN
    END IF
 
    OPEN i106_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fig.* TO NULL
    ELSE
        OPEN i106_count
        FETCH i106_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i106_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i106_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i106_cs INTO g_fig.fig01,g_fig.fig02
        WHEN 'P' FETCH PREVIOUS i106_cs INTO g_fig.fig01,g_fig.fig02
        WHEN 'F' FETCH FIRST    i106_cs INTO g_fig.fig01,g_fig.fig02
        WHEN 'L' FETCH LAST     i106_cs INTO g_fig.fig01,g_fig.fig02
        WHEN '/'
                 IF NOT g_no_ask THEN
                    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                    LET INT_FLAG = 0
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
                    IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
                 END IF
                 FETCH ABSOLUTE g_jump i106_cs INTO g_fig.fig01,g_fig.fig02 #TQC-930027 add fig02
                 LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)
       INITIALIZE g_fig.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_fig.* FROM fig_file WHERE fig01=g_fig.fig01 AND fig02=g_fig.fig02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("sel","fig_file",g_fig01_t,g_fig02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fig.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fig.figuser   #FUN-4C0069
    LET g_data_group = g_fig.figgrup   #FUN-4C0069
    CALL i106_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i106_show()
    LET g_fig_t.* = g_fig.*                #保存單頭舊值
    DISPLAY BY NAME g_fig.figoriu,g_fig.figorig,                              # 顯示單頭值
        g_fig.fig01,g_fig.fig02,g_fig.fig03,g_fig.fig04,
        g_fig.fig05,g_fig.figuser,g_fig.figgrup,g_fig.figmodu,
        g_fig.figdate,g_fig.figacti
    CALL i106_fig01('d')
    CALL i106_fig02('d')
    CALL i106_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i106_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fig.fig01 IS NULL OR g_fig.fig02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i106_cl USING g_fig.fig01,g_fig.fig02
    IF STATUS THEN
       CALL cl_err("OPEN i106_cl:", STATUS, 1)
       CLOSE i106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i106_cl INTO g_fig.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i106_show()
    IF cl_exp(0,0,g_fig.figacti) THEN                   #確認一下
        LET g_chr=g_fig.figacti
        IF g_fig.figacti='Y' THEN
            LET g_fig.figacti='N'
        ELSE
            LET g_fig.figacti='Y'
        END IF
        UPDATE fig_file
           SET figacti=g_fig.figacti, #更改有效碼
               figmodu=g_user,
               figdate=g_today
         WHERE fig01=g_fig.fig01
        IF SQLCA.sqlcode OR STATUS = 100 THEN
#           CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fig_file",g_fig.fig01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
            LET g_fig.figacti=g_chr
        END IF
        SELECT figacti,figmodu,figdate
          INTO g_fig.figacti,g_fig.figmodu,g_fig.figdate
          FROM fig_file
         WHERE fig01=g_fig.fig01
        DISPLAY BY NAME g_fig.figacti,g_fig.figmodu,g_fig.figdate
    END IF
    CLOSE i106_cl
    COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i106_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_fig.fig01 IS NULL OR g_fig.fig02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT * INTO g_fig.* FROM fig_file
     WHERE fig01=g_fig.fig01 AND fig02=g_fig.fig02
    IF g_fig.figacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fig.fig01,'mfg1000',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i106_cl USING g_fig.fig01,g_fig.fig02
    IF STATUS THEN
       CALL cl_err("OPEN i106_cl:", STATUS, 1)
       CLOSE i106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i106_cl INTO g_fig.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i106_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fig01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fig02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fig.fig01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fig.fig02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM fig_file WHERE fig01=g_fig.fig01 AND fig02=g_fig.fig02
       DELETE FROM fih_file WHERE fih01=g_fig.fig01 AND fih02=g_fig.fig02
       CLEAR FORM
       #MOD-5A0004 add
       DROP TABLE x
#      EXECUTE i106_precount_x                  #No.TQC-720019
       PREPARE i106_precount_x2 FROM g_sql_tmp  #No.TQC-720019
       EXECUTE i106_precount_x2                 #No.TQC-720019
       #MOD-5A0004 end
       CALL g_fih.clear()
       OPEN i106_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i106_cs
          CLOSE i106_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i106_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i106_cs
          CLOSE i106_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i106_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i106_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i106_fetch('/')
       END IF
    END IF
    CLOSE i106_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i106_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fig.fig01 IS NULL OR g_fig.fig02 IS NULL THEN RETURN END IF
    SELECT * INTO g_fig.* FROM fig_file
     WHERE fig01=g_fig.fig01 AND fig02=g_fig.fig02
    IF g_fig.figacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fig.fig01,'mfg1000',0) RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fih03,fih04,fih05 ",
                       "  FROM fih_file  ",
                       " WHERE fih01=? AND fih02=? AND fih03=? AND fih04=?",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i106_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fih WITHOUT DEFAULTS FROM s_fih.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
 
            BEGIN WORK
            OPEN i106_cl USING g_fig.fig01,g_fig.fig02
            IF STATUS THEN
               CALL cl_err('OPEN i106_cl:',STATUS,1)
               CLOSE i106_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i106_cl INTO g_fig.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i106_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fih_t.* = g_fih[l_ac].*  #BACKUP
               OPEN i106_b_cl USING g_fig.fig01,g_fig.fig02,
                                    g_fih_t.fih03,g_fih_t.fih04
               IF STATUS THEN
                  CALL cl_err('OPEN i106_b_cl:', STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i106_b_cl INTO g_fih[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fih_t.fih03,SQLCA.sqlcode,1)
                      LET l_lock_sw = 'Y'
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_fih[l_ac].* TO NULL      #900423
            LET g_fih_t.* = g_fih[l_ac].*         #新輸入資料
            LET g_fih[l_ac].fih03 = g_today
            LET g_fih[l_ac].fih04 = '000000'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fih03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fih_file(fih01,fih02,fih03,fih04,fih05)
            VALUES(g_fig.fig01,g_fig.fig02,
                   g_fih[l_ac].fih03,g_fih[l_ac].fih04,
                   g_fih[l_ac].fih05)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fih[l_ac].fih03,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("ins","fih_file",g_fig.fig01,g_fig.fig02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
{        AFTER FIELD fih03
            IF NOT cl_null(g_fih[l_ac].fih04) AND NOT cl_null(g_fih[l_ac].fih03) THEN
               IF g_fih[l_ac].fih04 != g_fih_t.fih04 OR g_fih_t.fih04 IS NULL
               OR g_fih[l_ac].fih03 != g_fih_t.fih03 OR g_fih_t.fih03 IS NULL
               THEN
                  SELECT COUNT(*) INTO l_n FROM fih_file
                   WHERE fih01 = g_fig.fig01
                     AND fih02 = g_fig.fig02
                     AND fih03 = g_fih[l_ac].fih03
                     AND fih04 = g_fih[l_ac].fih04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fih[l_ac].fih03 = g_fih_t.fih03
                     NEXT FIELD fih03
                  END IF
               END IF
            END IF
}
        AFTER FIELD fih04
            IF NOT cl_null(g_fih[l_ac].fih04) THEN
               LET g_i=LENGTH(g_fih[l_ac].fih04)
               IF g_i <> 6 THEN
                  CALL cl_err(g_fih[l_ac].fih04,'aem-006',0)
                  NEXT FIELD fih04
               END IF
               IF g_fih[l_ac].fih04 NOT MATCHES '[0-9][0-9][0-9][0-9][0-9][0-9]'
               OR g_fih[l_ac].fih04[1,2] <'00' OR g_fih[l_ac].fih04[1,2]>'23'
               OR g_fih[l_ac].fih04[3,4] NOT MATCHES '[0-5][0-9]'
               OR g_fih[l_ac].fih04[5,6] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fih[l_ac].fih04,'aem-006',0)
                  NEXT FIELD fih04
               END IF
               IF NOT cl_null(g_fih[l_ac].fih03) THEN
                  IF g_fih[l_ac].fih04 != g_fih_t.fih04 OR g_fih_t.fih04 IS NULL
                  OR g_fih[l_ac].fih03 != g_fih_t.fih03 OR g_fih_t.fih03 IS NULL
                  THEN
                     SELECT COUNT(*) INTO l_n FROM fih_file
                      WHERE fih01 = g_fig.fig01
                        AND fih02 = g_fig.fig02
                        AND fih03 = g_fih[l_ac].fih03
                        AND fih04 = g_fih[l_ac].fih04
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_fih[l_ac].fih04 = g_fih_t.fih04
                        NEXT FIELD fih04
                     END IF
                  END IF
               END IF
            END IF
{
        AFTER FIELD fih05
            IF NOT cl_null(g_fih[l_ac].fih05) THEN
               IF g_fih[l_ac].fih05 > g_fig.fig04
               OR g_fih[l_ac].fih05 < g_fig.fig05 THEN
                  CALL cl_err(g_fih[l_ac].fih05,'aem-005',0)
                  NEXT FIELD fih05
               END IF
            END IF
}
 
#TQC-990123 --begin--
        AFTER FIELD fih05
            IF NOT cl_null(g_fih[l_ac].fih05) THEN 
               IF g_fih[l_ac].fih05 < 0 THEN 
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD fih05
               END IF 
            END IF 
#TQC-990123 --end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_fih_t.fih03 IS NOT NULL OR g_fih_t.fih04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fih_file
                    WHERE fih01 = g_fig.fig01
                      AND fih02 = g_fig.fig02
                      AND fih03 = g_fih_t.fih03
                      AND fih04 = g_fih_t.fih04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fih_t.fih03,SQLCA.sqlcode,0)   #No.FUN-660092
                    CALL cl_err3("del","fih_file",g_fig.fig01,g_fig.fig02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fih[l_ac].* = g_fih_t.*
               CLOSE i106_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fih[l_ac].fih03,-263,1)
               LET g_fih[l_ac].* = g_fih_t.*
            ELSE
               UPDATE fih_file
                  SET fih03 = g_fih[l_ac].fih03,
                      fih04 = g_fih[l_ac].fih04,
                      fih05 = g_fih[l_ac].fih05
                WHERE CURRENT OF i106_b_cl
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_fih[l_ac].fih03,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("upd","fih_file",g_fih_t.fih03,g_fih_t.fih04,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   LET g_fih[l_ac].* = g_fih_t.*
                   CLOSE i106_b_cl
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fih[l_ac].* = g_fih_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fih.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i106_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i106_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i106_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(fih03) AND l_ac > 1 THEN
                LET g_fih[l_ac].* = g_fih[l_ac-1].*
                NEXT FIELD fih03
            END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end           
           
    END INPUT
 
   #start FUN-5A0029
    LET g_fig.figmodu = g_user
    LET g_fig.figdate = g_today
    UPDATE fig_file SET figmodu = g_fig.figmodu,figdate = g_fig.figdate
     WHERE fig01 = g_fig.fig01
    DISPLAY BY NAME g_fig.figmodu,g_fig.figdate
   #end FUN-5A0029
 
    CLOSE i106_b_cl
    COMMIT WORK
    CALL i106_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i106_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fig_file WHERE fig01 = g_fig.fig01
                                AND fig02 = g_fig.fig02
         INITIALIZE g_fig.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i106_b_askkey()
DEFINE
   #l_wc2            VARCHAR(200)    #TQC-630166  
    l_wc2           STRING    #TQC-630166      
 
    CONSTRUCT l_wc2 ON fih03,fih04,fih05
            FROM s_fih[1].fih03,s_fih[1].fih04,s_fih[1].fih05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i106_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i106_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200)    #TQC-630166 
    p_wc2           STRING    #TQC-630166    
 
    LET g_sql = "SELECT fih03,fih04,fih05",
                "  FROM fih_file",
                " WHERE fih01 ='",g_fig.fig01,"'",
                "   AND fih02 ='",g_fig.fig02,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY fih03,fih04 DESC "
    PREPARE i106_pb FROM g_sql
    DECLARE fih_cs CURSOR FOR i106_pb
 
    #單身 ARRAY 乾洗
    CALL g_fih.clear()
    LET g_cnt = 1
    FOREACH fih_cs INTO g_fih[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fih.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i106_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fih TO s_fih.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i106_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i106_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i106_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i106_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i106_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                    
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i106_copy()
DEFINE
    l_newno1        LIKE fig_file.fig01,
    l_newno2        LIKE fig_file.fig02,
    l_oldno1        LIKE fig_file.fig01,
    l_oldno2        LIKE fig_file.fig02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fig.fig01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fig.fig02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i106_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT l_newno1,l_newno2 FROM fig01,fig02
        AFTER FIELD fig01
            IF l_newno1 IS NULL THEN
                NEXT FIELD fig01
            END IF
 
        AFTER FIELD fig02
            IF l_newno2 IS NULL THEN
                NEXT FIELD fig02
            END IF
            SELECT COUNT(*) INTO g_cnt FROM fig_file
             WHERE fig01 = l_newno1
               AND fig02 = l_newno2
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno1,-239,0)
               NEXT FIELD fig01
            END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fig01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fia"
                   LET g_qryparam.default1 = l_newno1
                   CALL cl_create_qry() RETURNING l_newno1
                   CALL FGL_DIALOG_SETBUFFER( l_newno1 )
                   DISPLAY l_newno1 TO fig01
                   NEXT FIELD fig01
               WHEN INFIELD(fig02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fif"
                   LET g_qryparam.default1 = l_newno2
                   CALL cl_create_qry() RETURNING l_newno2
                   CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                   DISPLAY l_newno2 TO fig02
                   NEXT FIELD fig02
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
    IF INT_FLAG OR l_newno1 IS NULL OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM fig_file         #單頭復制
     WHERE fig01=g_fig.fig01
       AND fig02=g_fig.fig02
      INTO TEMP y
    UPDATE y
        SET fig01=l_newno1,    #新的鍵值
            fig02=l_newno2,    #新的鍵值
            figuser=g_user,    #資料所有者
            figgrup=g_grup,    #資料所有者所屬群
            figdate = g_today,
            figacti = 'Y'
    INSERT INTO fig_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#       CALL  cl_err(l_newno1,SQLCA.sqlcode,0) #No.FUN-660092
        CALL cl_err3("ins","fig_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660092
    END IF
 
    DROP TABLE x
    SELECT * FROM fih_file         #單身復制
     WHERE fih01=g_fig.fig01
       AND fih02=g_fig.fig02
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
    UPDATE x SET fih01=l_newno1,fih02=l_newno2
    INSERT INTO fih_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fig.fig01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fih_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno1 = g_fig.fig01
     LET l_oldno2 = g_fig.fig02
     SELECT fig_file.* INTO g_fig.* FROM fig_file  
      WHERE fig01 = l_newno1 AND fig02 = l_newno2
     CALL i106_u()
     CALL i106_b()
     #FUN-C30027---begin
     #SELECT fig_file.* INTO g_fig.* FROM fig_file
     # WHERE fig01 = l_oldno1 AND fig02 = l_oldno2
     #CALL i106_show()
     #FUN-C30027---end
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i106_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fig01       LIKE fig_file.fig01,
        fia02       LIKE fia_file.fia02,
        fig02       LIKE fig_file.fig02,
        fif02       LIKE fif_file.fif02,
        fig03       LIKE fig_file.fig03,
        fig04       LIKE fig_file.fig04,
        fig05       LIKE fig_file.fig05,
        fih03       LIKE fih_file.fih03,
        fih04       LIKE fih_file.fih04,
        fih05       LIKE fih_file.fih05
       END RECORD,
    l_name          LIKE type_file.chr20,  #No.FUN-680072 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680072 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('aemi106') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT fig01,fia02,fig02,fif02,fig03,fig04,",
              "       fig05,fih03,fih04,fih05 ",
              "  FROM fih_file,fig_file LEFT OUTER fia_file ON fig_file.fig01=fia_file.fia01 LEFT OUTER JOIN fif_file ON fig_file.fig02=fif_file.fif01 ",
              " WHERE fig01=fih01 AND fig02=fih02 ",
              "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    PREPARE i106_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i106_co CURSOR FOR i106_p1
 
    START REPORT i106_rep TO l_name
 
    FOREACH i106_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i106_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i106_rep
 
    CLOSE i106_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i106_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680072CHAR(01)
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fig01       LIKE fig_file.fig01,
        fia02       LIKE fia_file.fia02,
        fig02       LIKE fig_file.fig02,
        fif02       LIKE fif_file.fif02,
        fig03       LIKE fig_file.fig03,
        fig04       LIKE fig_file.fig04,
        fig05       LIKE fig_file.fig05,
        fih03       LIKE fih_file.fih03,
        fih04       LIKE fih_file.fih04,
        fih05       LIKE fih_file.fih05
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fig01,sr.fig02,sr.fih03,sr.fih04
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33], g_x[34],
                  g_x[35], g_x[36], g_x[37], g_x[38],
                  g_x[39], g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.fig01,
                  COLUMN g_c[32],sr.fia02,
                  COLUMN g_c[33],sr.fig02,
                  COLUMN g_c[34],sr.fif02,
                  COLUMN g_c[35],sr.fig03,
                  COLUMN g_c[36],sr.fig04 USING '-----------&.&&',
                  COLUMN g_c[37],sr.fig05 USING '-----------&.&&',
                  COLUMN g_c[38],sr.fih03,
                  COLUMN g_c[39],sr.fih04,
                  COLUMN g_c[40],sr.fih05 USING '-----------&.&&'
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
                  #IF g_wc[001,080] > ' ' THEN
                  #PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                  # IF g_wc[071,140] > ' ' THEN
                  #PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                  # IF g_wc[141,210] > ' ' THEN
                  #PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash[1,g_len]
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780037---End
 
FUNCTION i106_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("fig01,fig02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i106_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("fig01,fig02",FALSE)
       END IF
   END IF
 
END FUNCTION
#No.FUN-BB0086--add--begin--
FUNCTION i106_fig04_check()
   IF NOT cl_null(g_fig.fig04) AND NOT cl_null(g_fig.fig03) THEN
      IF cl_null(g_fig_t.fig04) OR cl_null(g_fig03_t) OR g_fig_t.fig04 != g_fig.fig04 OR g_fig03_t != g_fig.fig03 THEN
         LET g_fig.fig04=s_digqty(g_fig.fig04,g_fig.fig03)
         DISPLAY BY NAME g_fig.fig04
      END IF
   END IF
   
   IF NOT cl_null(g_fig.fig04) THEN 
      IF g_fig.fig04 < 0 THEN 
         CALL cl_err('','aec-020',0)
         RETURN FALSE
      END IF 
   END IF 
   RETURN TRUE
END FUNCTION 

FUNCTION i106_fig05_check()
   IF NOT cl_null(g_fig.fig05) AND NOT cl_null(g_fig.fig03) THEN
      IF cl_null(g_fig_t.fig05) OR cl_null(g_fig03_t) OR g_fig_t.fig05 != g_fig.fig05 OR g_fig03_t != g_fig.fig03 THEN
         LET g_fig.fig05=s_digqty(g_fig.fig05,g_fig.fig03)
         DISPLAY BY NAME g_fig.fig05
      END IF
   END IF
   
   IF NOT cl_null(g_fig.fig05) THEN 
      IF g_fig.fig05 < 0 THEN 
         CALL cl_err('','aec-020',0)
         RETURN FALSE,'fig05'
      END IF 
   END IF        
   IF g_fig.fig05 > g_fig.fig04 THEN
      CALL cl_err('','aem-050',0)       
      RETURN FALSE,'fig04'
   END IF
   RETURN TRUE,''
END FUNCTION 
#No.FUN-BB0086--add--end--

