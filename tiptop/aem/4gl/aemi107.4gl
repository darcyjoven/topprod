# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi107.4gl
# Descriptions...: 設備系列型號資料維護作業
# Date & Author..: 04/07/13 by day
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0116 06/11/08 By king 改正報表中有關錯誤
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-930027 09/03/06 By mike 查詢上下首末筆時KEY值不正確
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-C40242 12/04/26 By chenjing 查詢時"資料建立者、資料建立部門"可以下查詢條件
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fii           RECORD LIKE fii_file.*,
    g_fii_t         RECORD LIKE fii_file.*,
    g_fii_o         RECORD LIKE fii_file.*,
    g_fii01_t       LIKE fii_file.fii01,
    g_fii02_t       LIKE fii_file.fii02,
    g_fjd           DYNAMIC ARRAY OF RECORD
     fjd03       LIKE fjd_file.fjd03,
        fjd04       LIKE fjd_file.fjd04
                    END RECORD,
    g_fjd_t         RECORD
     fjd03       LIKE fjd_file.fjd03,
        fjd04       LIKE fjd_file.fjd04
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680072CHAR(72)
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0068
 
    OPEN WINDOW i107_w WITH FORM "aem/42f/aemi107"
        ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM fii_file WHERE fii01 = ? AND fii02 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i107_cl CURSOR FROM g_forupd_sql
 
    CALL i107_menu()
    CLOSE WINDOW i107_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i107_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fjd.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fii.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fii01,fii02,fii03,
     #  fiiuser,fiigrup,fiimodu,fiidate,fiiacti         #TQC-C40242
        fiiuser,fiigrup,fiimodu,fiidate,fiiacti,fiioriu,fiiorig         #TQC-C40242
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
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
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc CLIPPED," AND fiiuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc CLIPPED," AND fiigrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED," AND fiigrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiiuser', 'fiigrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON fjd03,fjd04              # 螢幕上取單身條件
            FROM s_fjd[1].fjd03,s_fjd[1].fjd04
 
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
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fii01, fii02 FROM fii_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY fii01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fii01, fii02 ",
                   "  FROM fii_file, fjd_file ",
                   " WHERE fii01 = fjd01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY fii01"
    END IF
 
    PREPARE i107_prepare FROM g_sql
    DECLARE i107_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i107_prepare
 
    #No.TQC-720019  --Begin
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE fii01,fii02 FROM fii_file WHERE ",g_wc CLIPPED,
                      " INTO TEMP x "
    ELSE
        LET g_sql_tmp="SELECT UNIQUE fii01,fii02 FROM fii_file,fjd_file ",
                      "WHERE fjd01=fii01 AND fjd02=fii02 ",
                      "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " INTO TEMP x "
    END IF
    DROP TABLE x
    PREPARE i107_precount_x FROM g_sql_tmp
    EXECUTE i107_precount_x
    LET g_sql = " SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End  
    PREPARE i107_precount FROM g_sql
    DECLARE i107_count CURSOR FOR i107_precount
END FUNCTION
 
FUNCTION i107_menu()
   WHILE TRUE
      CALL i107_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i107_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i107_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i107_r()
           END IF
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i107_copy()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i107_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN
                  CALL g_fjd.deleteElement(1)
               END IF
              CALL i107_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i107_x()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
           #No.FUN-780037---Begin   
           #  CALL i107_out()
              IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
              LET l_cmd = 'p_query "aemi107" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'               
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
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_fii.fii01 IS NOT NULL THEN
                LET g_doc.column1 = "fii01"
                LET g_doc.value1 = g_fii.fii01
                CALL cl_doc()
              END IF
        END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i107_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_fjd.clear()
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fii.* LIKE fii_file.*             #DEFAULT 設定
    LET g_fii01_t = NULL
    LET g_fii02_t = NULL
 #預設值及將數值類變數清成零
    LET g_fii_t.* = g_fii.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fii.fiiuser=g_user
        LET g_fii.fiioriu = g_user #FUN-980030
        LET g_fii.fiiorig = g_grup #FUN-980030
        LET g_fii.fiigrup=g_grup
        LET g_fii.fiidate=g_today
        LET g_fii.fiiacti='Y'              #資料有效
        CALL i107_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fii.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fii.fii01 IS NULL OR g_fii.fii02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        INSERT INTO fii_file VALUES (g_fii.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","fii_file",g_fii.fii01,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---上移2行---
            ROLLBACK WORK
#           CALL cl_err(g_fii.fii01,SQLCA.sqlcode,1)   #No.FUN-660092
            CONTINUE WHILE
        ELSE
            COMMIT WORK
        END IF
 
        SELECT fii01,fii02 INTO g_fii.fii01,g_fii.fii02 FROM fii_file
            WHERE fii01 = g_fii.fii01
              AND fii02 = g_fii.fii02
        LET g_fii01_t = g_fii.fii01        #保留舊值
        LET g_fii02_t = g_fii.fii02        #保留舊值
        LET g_fii_t.* = g_fii.*
        CALL g_fjd.clear()
        LET g_rec_b=0
        CALL i107_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i107_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fii.fii01 IS NULL OR g_fii.fii02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fii.* FROM fii_file
     WHERE fii01=g_fii.fii01
       AND fii02=g_fii.fii02
 
    IF g_fii.fiiacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_fii.fii01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fii01_t = g_fii.fii01
    LET g_fii02_t = g_fii.fii02
    LET g_fii_t.* = g_fii.*
    BEGIN WORK
    OPEN i107_cl USING g_fii.fii01,g_fii.fii02
    IF STATUS THEN
       CALL cl_err("OPEN i107_cl:", STATUS, 1)
       CLOSE i107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i107_cl INTO g_fii.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i107_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL i107_show()
    WHILE TRUE
        LET g_fii01_t = g_fii.fii01
        LET g_fii.fiimodu=g_user
        LET g_fii.fiidate=g_today
        CALL i107_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fii.*=g_fii_t.*
            CALL i107_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
     IF (g_fii.fii01 != g_fii01_t
           OR g_fii.fii02 != g_fii02_t) THEN
            UPDATE fjd_file SET fjd01 = g_fii.fii01,
                                fid02 = g_fii.fii02
                WHERE fjd01 = g_fii01_t
                  AND fjd02 = g_fii02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fjd',SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fjd_file",g_fii01_t,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fii_file
           SET fii_file.* = g_fii.*
            WHERE fii01=g_fii01_t AND fii02=g_fii02_t 
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fii_file",g_fii01_t,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i107_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i107_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    l_cnt           LIKE type_file.num5          #No.FUN-680072 SMALLINT
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
    INPUT BY NAME g_fii.fiioriu,g_fii.fiiorig,
     g_fii.fii01,g_fii.fii02,g_fii.fii03,
        g_fii.fiiuser,g_fii.fiigrup,g_fii.fiimodu,g_fii.fiidate,g_fii.fiiacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i107_set_entry(p_cmd)
            CALL i107_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD fii02
            IF NOT cl_null(g_fii.fii02) THEN
               IF g_fii.fii01 != g_fii_t.fii01 OR g_fii_t.fii01 IS NULL
                  OR g_fii.fii02 != g_fii_t.fii02 OR g_fii_t.fii02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM fii_file
                   WHERE fii01 = g_fii.fii01
                     AND fii02 = g_fii.fii02
                  IF g_cnt > 0 THEN   #資料重復
                     CALL cl_err(g_fii.fii01,-239,0)
                     LET g_fii.fii01 = g_fii_t.fii01
                     LET g_fii.fii02 = g_fii_t.fii02
                     DISPLAY BY NAME g_fii.fii01
                     DISPLAY BY NAME g_fii.fii02
                     NEXT FIELD fii01
                  END IF
                END IF
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                 #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
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
 
#Query 查詢
FUNCTION i107_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fii.* TO NULL               #No.FUN-6B0050
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fjd.clear()
    DISPLAY '   ' TO FORMONLY.cnt             #ATTRIBUTE(YELLOW)
    CALL i107_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fii.* TO NULL
        RETURN
    END IF
 
    OPEN i107_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fii.* TO NULL
    ELSE
        OPEN i107_count
        FETCH i107_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i107_fetch('F')
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i107_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i107_cs INTO g_fii.fii01,g_fii.fii02 #TQC-930027 add fii02
        WHEN 'P' FETCH PREVIOUS i107_cs INTO g_fii.fii01,g_fii.fii02 #TQC-930027 add fii02
        WHEN 'F' FETCH FIRST    i107_cs INTO g_fii.fii01,g_fii.fii02 #TQC-930027 add fii02
        WHEN 'L' FETCH LAST     i107_cs INTO g_fii.fii01,g_fii.fii02 #TQC-930027 add fii02
        WHEN '/'
          IF (NOT g_no_ask) THEN
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
          FETCH ABSOLUTE g_jump i107_cs INTO g_fii.fii01,g_fii.fii02
          LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)
        RETURN
    END IF
    SELECT * INTO g_fii.* FROM fii_file
     WHERE fii01 = g_fii.fii01 AND fii02=g_fii.fii02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("sel","fii_file",g_fii.fii01,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fii.* TO NULL
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
    LET g_data_owner = g_fii.fiiuser   #FUN-4C0069
    LET g_data_group = g_fii.fiigrup   #FUN-4C0069
    CALL i107_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i107_show()
    LET g_fii_t.* = g_fii.*                      #保存單頭舊值
    DISPLAY BY NAME g_fii.fiioriu,g_fii.fiiorig,                              # 顯示單頭值
     g_fii.fii01,g_fii.fii02,g_fii.fii03,
        g_fii.fiiuser,g_fii.fiigrup,g_fii.fiimodu,
        g_fii.fiidate,g_fii.fiiacti
    CALL i107_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i107_r()
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_fii.fii01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
 
   SELECT * INTO g_fii.* FROM fii_file
    WHERE fii01=g_fii.fii01
      AND fii02=g_fii.fii02
   IF g_fii.fiiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fii.fii01,'mfg1000',0)
      RETURN
   END IF
 
    BEGIN WORK
    OPEN i107_cl USING g_fii.fii01,g_fii.fii02
    IF STATUS THEN
       CALL cl_err("OPEN i107_cl:", STATUS, 1)
       CLOSE i107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i107_cl INTO g_fii.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i107_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fii01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fii.fii01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM fii_file
          WHERE fii01 = g_fii.fii01
            AND fii02 = g_fii.fii02
         DELETE FROM fjd_file
          WHERE fjd01 = g_fii.fii01
            AND fid02 = g_fii.fii02
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i107_precount_x                  #No.TQC-720019
         PREPARE i107_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i107_precount_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_fjd.clear()
         OPEN i107_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i107_cs
             CLOSE i107_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i107_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i107_cs
             CLOSE i107_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i107_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i107_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i107_fetch('/')
         END IF
    END IF
    CLOSE i107_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i107_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fii.fii01 IS NULL OR g_fii.fii02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i107_cl USING g_fii.fii01,g_fii.fii02
    IF STATUS THEN
       CALL cl_err("OPEN i107_cl:", STATUS, 1)
       CLOSE i107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i107_cl INTO g_fii.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i107_show()
    IF cl_exp(0,0,g_fii.fiiacti) THEN                   #確認一下
        LET g_chr=g_fii.fiiacti
        IF g_fii.fiiacti='Y' THEN
            LET g_fii.fiiacti='N'
        ELSE
            LET g_fii.fiiacti='Y'
        END IF
        UPDATE fii_file                    #更改有效碼
            SET fiiacti=g_fii.fiiacti
            WHERE fii01=g_fii.fii01
        IF STATUS = 100 THEN
#           CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fii_file",g_fii.fii01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
            LET g_fii.fiiacti=g_chr
        END IF
        DISPLAY BY NAME g_fii.fiiacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE i107_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i107_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_n,l_n1        LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    l_fjd03         LIKE fjd_file.fjd03,          #No.FUN-680072 SMALLINT
    l_allow_insert  LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fii.fii01 IS NULL OR g_fii.fii02 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_fii.*
      FROM fii_file
     WHERE fii01=g_fii.fii01
       AND fii02=g_fii.fii02
 
    IF g_fii.fiiacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fii.fii01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fjd03,fjd04 ",
                       "   FROM fjd_file ",
                       " WHERE fjd01 = ? AND fjd02 = ? AND fjd03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i107_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_fjd WITHOUT DEFAULTS FROM s_fjd.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
    BEFORE ROW
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
 
            BEGIN WORK
            OPEN i107_cl USING g_fii.fii01,g_fii.fii02
            IF STATUS THEN
               CALL cl_err("OPEN i107_cl:", STATUS, 1)
               CLOSE i107_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i107_cl INTO g_fii.*
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)
                CLOSE i107_cl
                ROLLBACK WORK
                RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fjd_t.* = g_fjd[l_ac].*  #BACKUP
                OPEN i107_bcl USING g_fii.fii01,g_fii.fii02,
                                    g_fjd_t.fjd03
                IF STATUS THEN
                   CALL cl_err("OPEN i107_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH i107_bcl INTO g_fjd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fjd_t.fjd03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_fjd[l_ac].* TO NULL      #900423
            LET g_fjd_t.* = g_fjd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fjd03
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fjd_file(fjd01,fjd02,fjd03,fjd04)
                       VALUES(g_fii.fii01,g_fii.fii02,
                              g_fjd[l_ac].fjd03,
                              g_fjd[l_ac].fjd04)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fjd[l_ac].fjd03,SQLCA.sqlcode,0)   #No.FUN-660092
               CALL cl_err3("ins","fjd_file",g_fii.fii01,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK
            END IF
 
        BEFORE FIELD fjd03
            IF g_fjd[l_ac].fjd03 IS NULL OR g_fjd[l_ac].fjd03 = 0 THEN
               SELECT max(fjd03)+1 INTO g_fjd[l_ac].fjd03 FROM fjd_file
                WHERE fjd01 = g_fii.fii01
                  AND fjd02 = g_fii.fii02
              IF g_fjd[l_ac].fjd03 IS NULL THEN
                 LET g_fjd[l_ac].fjd03 = 1
              END IF
            END IF
 
        AFTER FIELD fjd03
            IF NOT cl_null(g_fjd[l_ac].fjd03) THEN
               IF g_fjd[l_ac].fjd03 != g_fjd_t.fjd03 THEN
                  SELECT count(*)
                    INTO l_n
                    FROM fjd_file
                   WHERE fjd01 = g_fii.fii01
                     AND fid02 = g_fii.fii02
                     AND fjd03 = g_fjd[l_ac].fjd03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fjd[l_ac].fjd03 = g_fjd_t.fjd03
                     NEXT FIELD fjd03
                  END IF
               END IF
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fjd_t.fjd03 > 0 AND
               g_fjd_t.fjd03 IS NOT NULL THEN
                   IF NOT cl_delb(0,0) THEN
                      CANCEL DELETE
                   END IF
                   IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
                   DELETE FROM fjd_file
                    WHERE fjd01 = g_fii.fii01
                      AND fjd02 = g_fii.fii02
                      AND fjd03 = g_fjd_t.fjd03
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err(g_fjd_t.fjd03,SQLCA.sqlcode,0)   #No.FUN-660092
                        CALL cl_err3("del","fjd_file",g_fii.fii01,g_fii.fii02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fjd[l_ac].* = g_fjd_t.*
               CLOSE i107_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fjd[l_ac].fjd03,-263,1)
               LET g_fjd[l_ac].* = g_fjd_t.*
            ELSE
               UPDATE fjd_file
                  SET fjd03=g_fjd[l_ac].fjd03,
                      fjd04=g_fjd[l_ac].fjd04
                WHERE CURRENT OF i107_bcl
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_fjd[l_ac].fjd03,SQLCA.sqlcode,0)   #No.FUN-660092
                      CALL cl_err3("upd","fjd_file",g_fjd[l_ac].fjd03,g_fjd[l_ac].fjd04,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                      LET g_fjd[l_ac].* = g_fjd_t.*
                      CLOSE i107_bcl
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
                  LET g_fjd[l_ac].* = g_fjd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fjd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i107_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i107_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i107_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
      ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
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
    LET g_fii.fiimodu = g_user
    LET g_fii.fiidate = g_today
    UPDATE fii_file SET fiimodu = g_fii.fiimodu,fiidate = g_fii.fiidate
     WHERE fii01 = g_fii.fii01
    DISPLAY BY NAME g_fii.fiimodu,g_fii.fiidate
   #end FUN-5A0029
 
    CLOSE i107_bcl
    COMMIT WORK
    CALL i107_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i107_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fii_file WHERE fii01 = g_fii.fii01
                                AND fii02 = g_fii.fii02
         INITIALIZE g_fii.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i107_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680072CHAR(200)
 
 CONSTRUCT l_wc2 ON fjd03,fjd04
            FROM s_fjd[1].fjd03,s_fjd[1].fjd04
 
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
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i107_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i107_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fjd03,fjd04 ",
        "  FROM fjd_file ",
        " WHERE fjd01 ='",g_fii.fii01,"'",
        "   AND fjd02 ='",g_fii.fii02,"'" 
    #No.FUN-8B0123---Begin
    #   "   AND ",p_wc2 CLIPPED,                     #單身
    #   " ORDER BY fjd03"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY fjd03 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i107_pb FROM g_sql
    DECLARE fjd_curs                       #SCROLL CURSOR
        CURSOR FOR i107_pb
 
    CALL g_fjd.clear()
    LET g_cnt = 1
    FOREACH fjd_curs INTO g_fjd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_fjd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i107_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fjd TO s_fjd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i107_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i107_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i107_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i107_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i107_fetch('L')
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
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
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
 
 
FUNCTION i107_copy()
DEFINE
    l_fii		RECORD LIKE fii_file.*,
    l_newno1            LIKE fii_file.fii01,
    l_newno2            LIKE fii_file.fii02,
    l_oldno1            LIKE fii_file.fii01,
    l_oldno2            LIKE fii_file.fii02
 
 
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_fii.fii01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_fii.fii02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i107_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT l_newno1,l_newno2 FROM fii01,fii02
    AFTER FIELD fii01
          IF l_newno1 IS NULL THEN
             NEXT FIELD fii01
          END IF
    AFTER FIELD fii02
          IF l_newno2 IS NULL THEN
             NEXT FIELD fii02
          END IF
 
            SELECT COUNT(*) INTO g_cnt
              FROM fii_file
             WHERE fii01 = l_newno1
               AND fii02 = l_newno2
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno1,-239,0)
                NEXT FIELD fii01
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
    IF INT_FLAG OR l_newno1 IS NULL OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    LET l_fii.* = g_fii.*
    LET l_fii.fii01  =l_newno1   #新的鍵值
    LET l_fii.fii02  =l_newno2   #新的鍵值
    LET l_fii.fiiuser=g_user    #資料所有者
    LET l_fii.fiigrup=g_grup    #資料所有者所屬群
    LET l_fii.fiimodu=NULL      #資料修改日期
    LET l_fii.fiidate=g_today   #資料建立日期
    LET l_fii.fiiacti='Y'       #有效資料
    BEGIN WORK
    LET l_fii.fiioriu = g_user      #No.FUN-980030 10/01/04
    LET l_fii.fiiorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fii_file VALUES (l_fii.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('fii:',SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fii_file",l_fii.fii01,l_fii.fii02,SQLCA.sqlcode,"","fii:",1)  #No.FUN-660092
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM fjd_file         #單身復制
        WHERE fjd01=g_fii.fii01
          AND fjd02=g_fii.fii02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fii.fii01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
    UPDATE x
        SET   fjd01=l_newno1,
              fjd02=l_newno2
    INSERT INTO fjd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('fjd:',SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fjd_file",l_newno1,l_newno2,SQLCA.sqlcode,"","fjd:",1)  #No.FUN-660092
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
     LET l_oldno1 = g_fii.fii01
     LET l_oldno2 = g_fii.fii02
     SELECT fii_file.* INTO g_fii.*
       FROM fii_file
      WHERE fii01 = l_newno1
        AND fii02 = l_newno2
     CALL i107_u()
     CALL i107_b()
     #FUN-C30027---begin
     #SELECT fii_file.* INTO g_fii.*
     #  FROM fii_file
     # WHERE fii01 = l_oldno1
     #   AND fii02 = l_oldno2
     #CALL i107_show()
     #FUN-C30027---end
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i107_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fii01       LIKE fii_file.fii01,
        fii02       LIKE fii_file.fii02,
        fii03       LIKE fii_file.fii03,
        fjd03       LIKE fjd_file.fjd03,
        fjd04       LIKE fjd_file.fjd04
                    END RECORD,
        l_name      LIKE type_file.chr20   #No.FUN-680072 VARCHAR(20)
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT fii01,fii02,fii03,fjd03,fjd04 ",
          " FROM fii_file LEFT OUTER JOIN fjd_file ON fii_file.fii01=fjd_file.fjd01 AND fii_file.fii02=fjd_file.fjd02 ",
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i107_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i107_co                         # SCROLL CURSOR
         CURSOR FOR i107_p1
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #No.TQC-6A0116
    CALL cl_outnam('aemi107') RETURNING l_name
    START REPORT i107_rep TO l_name
 
    FOREACH i107_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        END IF
 
        OUTPUT TO REPORT i107_rep(sr.*)
 
    END FOREACH
 
    FINISH REPORT i107_rep
 
    CLOSE i107_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i107_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680072CHAR(1)
    l_sw            LIKE type_file.chr1,          #No.FUN-680072CHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fii01       LIKE fii_file.fii01,
        fii02       LIKE fii_file.fii02,
        fii03       LIKE fii_file.fii03,
        fjd03       LIKE fjd_file.fjd03,
        fjd04       LIKE fjd_file.fjd04
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fii01,sr.fii02,sr.fjd03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1, g_x[1] CLIPPED  #No.TQC-6A0093
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33], g_x[34], g_x[35]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
 #      BEFORE GROUP OF sr.fii01  #等級
 #          PRINT COLUMN g_c[31],sr.fii01 CLIPPED,
 #                COLUMN g_c[32],sr.fii02 CLIPPED,
 #                COLUMN g_c[33],sr.fii03 CLIPPED;
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.fii01 CLIPPED,
                  COLUMN g_c[32],sr.fii02 CLIPPED,
                  COLUMN g_c[33],sr.fii03 CLIPPED,
                  COLUMN g_c[34],sr.fjd03 USING '###&', #FUN-590118
                  COLUMN g_c[35],sr.fjd04 CLIPPED
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0093
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0093
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780037---End
FUNCTION i107_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("fii01,fii02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i107_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("fii01,fii02",FALSE)
       END IF
   END IF
 
END FUNCTION
