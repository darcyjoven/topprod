# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi104.4gl
# Descriptions...: 作業資料維護作業
# Date & Author..: 04/07/08 by day
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990122 09/10/09 By liuxqa 非負控管。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fid           RECORD LIKE fid_file.*,
    g_fid_t         RECORD LIKE fid_file.*,
    g_fid_o         RECORD LIKE fid_file.*,
    g_fid01_t       LIKE fid_file.fid01,
    g_fie           DYNAMIC ARRAY OF RECORD
     fie02       LIKE fie_file.fie02,
        fie03       LIKE fie_file.fie03
                    END RECORD,
    g_fie_t         RECORD
     fie02       LIKE fie_file.fie02,
        fie03       LIKE fie_file.fie03
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5                                    #No.FUN-680072 SMALLINT
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680072CHAR(72)
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037     
#主程式開始
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8             #No.FUN-6A0068
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680072 SMALLINT
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
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i104_w AT p_row,p_col WITH FORM "aem/42f/aemi104"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM fid_file WHERE fid01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_cl CURSOR FROM g_forupd_sql
 
    CALL i104_menu()
    CLOSE WINDOW i104_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i104_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fie.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029  
   INITIALIZE g_fid.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        fid01,fid02,fid03,fid04,
        fiduser,fidgrup,fidmodu,fiddate,fidacti
 
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
    #        LET g_wc = g_wc CLIPPED," AND fiduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc CLIPPED," AND fidgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED," AND fidgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiduser', 'fidgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON fie02,fie03              # 螢幕上取單身條件
            FROM s_fie[1].fie02,s_fie[1].fie03
 
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
       LET g_sql = "SELECT fid01 FROM fid_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY fid01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fid01 ",
                   "  FROM fid_file, fie_file ",
                   " WHERE fid01 = fie01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY fid01"
    END IF
 
    PREPARE i104_prepare FROM g_sql
    DECLARE i104_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i104_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fid_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fid01) FROM fid_file,fie_file WHERE ",
                  "fie01=fid01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i104_precount FROM g_sql
    DECLARE i104_count CURSOR FOR i104_precount
END FUNCTION
 
FUNCTION i104_menu()
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i104_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i104_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i104_r()
           END IF
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i104_copy()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i104_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN
                  CALL g_fie.deleteElement(1)
               END IF
              CALL i104_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i104_x()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
         #No.FUN-780037---Begin      
         #    CALL i104_out()
              IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF     
              LET g_msg = g_wc CLIPPED ," AND ", g_wc2 CLIPPED                 
              LET l_cmd = 'p_query "aemi104" "',g_msg,'"'               
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
                IF g_fid.fid01 IS NOT NULL THEN
                LET g_doc.column1 = "fid01"
                LET g_doc.value1 = g_fid.fid01
                CALL cl_doc()
              END IF
        END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i104_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fie.clear()
    INITIALIZE g_fid.* LIKE fid_file.*             #DEFAULT 設定
    LET g_fid01_t = NULL
 #預設值及將數值類變數清成零
    LET g_fid_o.* = g_fid.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fid.fiduser=g_user
        LET g_fid.fidoriu = g_user #FUN-980030
        LET g_fid.fidorig = g_grup #FUN-980030
        LET g_fid.fidgrup=g_grup
        LET g_fid.fiddate=g_today
        LET g_fid.fidacti='Y'              #資料有效
        CALL i104_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fid.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fid.fid01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        BEGIN WORK
 
        INSERT INTO fid_file VALUES (g_fid.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","fid_file",g_fid.fid01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---調整至回滾事務前---
            ROLLBACK WORK
#           CALL cl_err(g_fid.fid01,SQLCA.sqlcode,1)   #No.FUN-660092
            CONTINUE WHILE
        ELSE
            COMMIT WORK
        END IF
 
        SELECT fid01 INTO g_fid.fid01 FROM fid_file
            WHERE fid01 = g_fid.fid01
        LET g_fid01_t = g_fid.fid01        #保留舊值
        LET g_fid_t.* = g_fid.*
        LET g_rec_b=0
        CALL g_fie.clear()
        CALL i104_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i104_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fid.fid01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fid.* FROM fid_file WHERE fid01=g_fid.fid01
    IF g_fid.fidacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_fid.fid01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fid01_t = g_fid.fid01
    LET g_fid_o.* = g_fid.*
    BEGIN WORK
    OPEN i104_cl USING g_fid.fid01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_fid.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i104_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL i104_show()
    WHILE TRUE
        LET g_fid01_t = g_fid.fid01
        LET g_fid.fidmodu=g_user
        LET g_fid.fiddate=g_today
        CALL i104_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fid.*=g_fid_t.*
            CALL i104_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
     IF g_fid.fid01 != g_fid01_t THEN
            UPDATE fie_file SET fie01 = g_fid.fid01
                WHERE fie01 = g_fid01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fie',SQLCA.sqlcode,0)  #No.FUN-660092
                CALL cl_err3("upd","fie_file",g_fid01_t,"",SQLCA.sqlcode,"","fie",1)  #No.FUN-660092
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fid_file SET fid_file.* = g_fid.*
            WHERE fid01 = g_fid01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fid_file",g_fid01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i104_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i104_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改                 #No.FUN-680072 VARCHAR(1)
    l_cnt           LIKE type_file.num5                                                 #No.FUN-680072 SMALLINT
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    INPUT BY NAME g_fid.fidoriu,g_fid.fidorig,
     g_fid.fid01,g_fid.fid02,g_fid.fid03,g_fid.fid04,
        g_fid.fiduser,g_fid.fidgrup,g_fid.fidmodu,g_fid.fiddate,g_fid.fidacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i104_set_entry(p_cmd)
            CALL i104_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD fid01                  #簽核等級
            IF NOT cl_null(g_fid.fid01) THEN
               IF g_fid.fid01 != g_fid01_t OR g_fid01_t IS NULL THEN
                   SELECT COUNT(*) INTO g_cnt FROM fid_file
                    WHERE fid01 = g_fid.fid01
                   IF g_cnt > 0 THEN   #資料重復
                       CALL cl_err(g_fid.fid01,-239,0)
                       LET g_fid.fid01 = g_fid01_t
                       DISPLAY BY NAME g_fid.fid01
                       NEXT FIELD fid01
                   END IF
               END IF
            END IF
 
#No.TQC-990122 add --begin
         AFTER FIELD fid03
             IF NOT cl_null(g_fid.fid03) THEN
                IF g_fid.fid03 < 0 THEN
                   CALL cl_err('','aec-020',0)
                   NEXT FIELD fid03
                END IF
              END IF
 
         AFTER FIELD fid04
             IF NOT cl_null(g_fid.fid04) THEN
                IF g_fid.fid04 < 0 THEN
                   CALL cl_err('','aec-020',0)
                   NEXT FIELD fid04
                END IF
              END IF
#No.TQC-990122 add --end
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLF                 #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
FUNCTION i104_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fid.* TO NULL               #NO.FUN-6B0050 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fie.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL i104_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN i104_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fid.* TO NULL
    ELSE
        OPEN i104_count
        FETCH i104_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i104_fetch('F')
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i104_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i104_cs INTO g_fid.fid01
        WHEN 'P' FETCH PREVIOUS i104_cs INTO g_fid.fid01
        WHEN 'F' FETCH FIRST    i104_cs INTO g_fid.fid01
        WHEN 'L' FETCH LAST     i104_cs INTO g_fid.fid01
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
          FETCH ABSOLUTE g_jump i104_cs INTO g_fid.fid01
          LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)
        RETURN
    END IF
    SELECT * INTO g_fid.* FROM fid_file WHERE fid01 = g_fid.fid01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("sel","fid_file",g_fid.fid01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fid.* TO NULL
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
    LET g_data_owner = g_fid.fiduser   #FUN-4C0069
    LET g_data_group = g_fid.fidgrup   #FUN-4C0069
    CALL i104_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i104_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    LET g_fid_t.* = g_fid.*                      #保存單頭舊值
    DISPLAY BY NAME g_fid.fidoriu,g_fid.fidorig,                              # 顯示單頭值
     g_fid.fid01,g_fid.fid02,g_fid.fid03,
        g_fid.fid04,
        g_fid.fiduser,g_fid.fidgrup,g_fid.fidmodu,
        g_fid.fiddate,g_fid.fidacti
    CALL i104_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i104_r()
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_fid.fid01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
 
   SELECT * INTO g_fid.* FROM fid_file
    WHERE fid01=g_fid.fid01
   IF g_fid.fidacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fid.fid01,'mfg1000',0)
      RETURN
   END IF
 
    BEGIN WORK
    OPEN i104_cl USING g_fid.fid01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_fid.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i104_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fid01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fid.fid01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM fid_file WHERE fid01 = g_fid.fid01
         DELETE FROM fie_file WHERE fie01 = g_fid.fid01
#         INITIALIZE g_fid.* TO NULL
         CLEAR FORM
         CALL g_fie.clear()
         OPEN i104_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i104_cs
            CLOSE i104_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i104_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i104_cs
            CLOSE i104_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i104_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i104_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i104_fetch('/')
         END IF
    END IF
    CLOSE i104_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i104_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fid.fid01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i104_cl USING g_fid.fid01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_fid.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i104_show()
    IF cl_exp(0,0,g_fid.fidacti) THEN                   #確認一下
        LET g_chr=g_fid.fidacti
        IF g_fid.fidacti='Y' THEN
            LET g_fid.fidacti='N'
        ELSE
            LET g_fid.fidacti='Y'
        END IF
        UPDATE fid_file                    #更改有效碼
            SET fidacti=g_fid.fidacti
            WHERE fid01=g_fid.fid01
        IF STATUS=100 THEN
#           CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fid_file",g_fid.fid01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
            LET g_fid.fidacti=g_chr
        END IF
        DISPLAY BY NAME g_fid.fidacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE i104_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_n,l_n1        LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    l_fie02         LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_allow_insert  LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fid.fid01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_fid.* FROM fid_file WHERE fid01=g_fid.fid01
    IF g_fid.fidacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fid.fid01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fie02,fie03 ",
                       "   FROM fie_file WHERE fie01= ? AND fie02= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_fie WITHOUT DEFAULTS FROM s_fie.*
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
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN i104_cl USING g_fid.fid01
            IF STATUS THEN
               CALL cl_err("OPEN i104_cl:", STATUS, 1)
               CLOSE i104_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i104_cl INTO g_fid.*
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)
                CLOSE i104_cl
                ROLLBACK WORK
                RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fie_t.* = g_fie[l_ac].*  #BACKUP
                OPEN i104_bcl USING g_fid.fid01,g_fie_t.fie02
                IF STATUS THEN
                   CALL cl_err("OPEN i104_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH i104_bcl INTO g_fie[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fie_t.fie02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fie[l_ac].* TO NULL      #900423
            LET g_fie_t.* = g_fie[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fie02
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fie_file(fie01,fie02,fie03)
                       VALUES(g_fid.fid01,g_fie[l_ac].fie02,
                              g_fie[l_ac].fie03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fie[l_ac].fie02,SQLCA.sqlcode,0)   #No.FUN-660092
               CALL cl_err3("ins","fie_file",g_fid.fid01,g_fie[l_ac].fie02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK
            END IF
{
        BEFORE FIELD fie02
            IF g_fie[l_ac].fie02 IS NULL OR g_fie[l_ac].fie02 = 0 THEN
               SELECT max(fie02)+1 INTO l_fie02 FROM fie_file
                WHERE fie01 = g_fid.fid01
              IF g_fie[l_ac].fie02 IS NULL THEN
                 LET g_fie[l_ac].fie02 = 1
              END IF
               IF l_fie02 IS NULL THEN LET l_fie02 = 1 END IF
            END IF
}
        BEFORE FIELD fie02                        #default 序號
           IF g_fie[l_ac].fie02 IS NULL OR g_fie[l_ac].fie02 = 0 THEN
              SELECT max(fie02)+1
                INTO g_fie[l_ac].fie02
                FROM fie_file
               WHERE fie01 = g_fid.fid01
              IF g_fie[l_ac].fie02 IS NULL THEN
                 LET g_fie[l_ac].fie02 = 1
              END IF
           END IF
 
 
        AFTER FIELD fie02
           IF NOT cl_null(g_fie[l_ac].fie02) THEN
              IF g_fie[l_ac].fie02 != g_fie_t.fie02
                 OR g_fie_t.fie02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM fie_file
                  WHERE fie01 = g_fid.fid01
                    AND fie02 = g_fie[l_ac].fie02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fie[l_ac].fie02 = g_fie_t.fie02
                    NEXT FIELD fie02
                 END IF
              END IF
           END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fie_t.fie02 > 0 AND
               g_fie_t.fie02 IS NOT NULL THEN
                   IF NOT cl_delb(0,0) THEN
                      CANCEL DELETE
                   END IF
                   IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
                   DELETE FROM fie_file
                    WHERE fie01 = g_fid.fid01 AND
                          fie02 = g_fie_t.fie02
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err(g_fie_t.fie02,SQLCA.sqlcode,0)   #No.FUN-660092
                        CALL cl_err3("del","fie_file",g_fid.fid01,g_fie_t.fie02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fie[l_ac].* = g_fie_t.*
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fie[l_ac].fie02,-263,1)
               LET g_fie[l_ac].* = g_fie_t.*
            ELSE
               UPDATE fie_file
                  SET fie02=g_fie[l_ac].fie02,
                      fie03=g_fie[l_ac].fie03
               WHERE fie01=g_fid.fid01
                 AND fie02=g_fie_t.fie02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fie[l_ac].fie02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fie_file",g_fid.fid01,g_fie_t.fie02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fie[l_ac].* = g_fie_t.*
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
                  LET g_fie[l_ac].* = g_fie_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fie.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i104_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i104_b_askkey()
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
    LET g_fid.fidmodu = g_user
    LET g_fid.fiddate = g_today
    UPDATE fid_file SET fidmodu = g_fid.fidmodu,fiddate = g_fid.fiddate
     WHERE fid01 = g_fid.fid01
    DISPLAY BY NAME g_fid.fidmodu,g_fid.fiddate
   #end FUN-5A0029
 
    CLOSE i104_bcl
    CLOSE i104_cl
    COMMIT WORK
    CALL i104_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i104_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fid_file WHERE fid01 = g_fid.fid01
         INITIALIZE g_fid.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i104_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
 CONSTRUCT l_wc2 ON fie02,fie03
            FROM s_fie[1].fie02,s_fie[1].fie03
 
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
    CALL i104_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fie02,fie03 ",
        "  FROM fie_file ",
        " WHERE fie01 ='",g_fid.fid01,"'"
    #No.FUN-8B0123---Begin
    #   "   AND ",p_wc2 CLIPPED,                     #單身
    #   " ORDER BY fie02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY fie02 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i104_pb FROM g_sql
    DECLARE fie_curs                       #SCROLL CURSOR
        CURSOR FOR i104_pb
 
    CALL g_fie.clear()
    LET g_cnt = 1
    FOREACH fie_curs INTO g_fie[g_cnt].*   #單身 ARRAY 填充
#        LET g_rec_b = g_rec_b + 1
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
    CALL g_fie.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i104_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fie TO s_fie.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i104_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i104_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i104_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i104_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i104_fetch('L')
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
 
 
FUNCTION i104_copy()
DEFINE
    l_fid		RECORD LIKE fid_file.*,
    l_oldno,l_newno	LIKE fid_file.fid01
 
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_fid.fid01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i104_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    INPUT l_newno FROM fid01
    AFTER FIELD fid01
          IF l_newno IS NULL THEN
             NEXT FIELD fid01
          END IF
            SELECT COUNT(*) INTO g_cnt FROM fid_file WHERE fid01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD fid01
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
        DISPLAY BY NAME g_fid.fid01
        RETURN
    END IF
    LET l_fid.* = g_fid.*
    LET l_fid.fid01  =l_newno   #新的鍵值
    LET l_fid.fiduser=g_user    #資料所有者
    LET l_fid.fidgrup=g_grup    #資料所有者所屬群
    LET l_fid.fidmodu=NULL      #資料修改日期
    LET l_fid.fiddate=g_today   #資料建立日期
    LET l_fid.fidacti='Y'       #有效資料
    BEGIN WORK
    LET l_fid.fidoriu = g_user      #No.FUN-980030 10/01/04
    LET l_fid.fidorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fid_file VALUES (l_fid.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('fid:',SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fid_file",l_fid.fid01,"",SQLCA.sqlcode,"","fid:",1)  #No.FUN-660092
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM fie_file         #單身復制
        WHERE fie01=g_fid.fid01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fid.fid01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
    UPDATE x
        SET   fie01=l_newno
    INSERT INTO fie_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('fie:',SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fie_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_fid.fid01
     SELECT fid_file.* INTO g_fid.* FROM fid_file WHERE fid01 = l_newno
     CALL i104_u()
     CALL i104_b()
     #SELECT fid_file.* INTO g_fid.* FROM fid_file WHERE fid01 = l_oldno #FUN-C30027
     #CALL i104_show()  #FUN-C30027
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i104_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fid01       LIKE fid_file.fid01,
        fid02       LIKE fid_file.fid02,
        fid03       LIKE fid_file.fid03,
        fid04       LIKE fid_file.fid04,
        fie02       LIKE fie_file.fie02,
        fie03       LIKE fie_file.fie03
                    END RECORD,
        l_name      LIKE type_file.chr20   #No.FUN-680072 VARCHAR(20)
    LET g_sql="SELECT fid01,fid02,fid03,fid04,fie02,fie03 ",
          " FROM fid_file LEFT OUTER JOIN fie_file ON fid_file.fid01 = fie_file.fie01  ",
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i104_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i104_co                         # SCROLL CURSOR
         CURSOR FOR i104_p1
 
    CALL cl_wait()
    CALL cl_outnam('aemi104') RETURNING l_name
    START REPORT i104_rep TO l_name
 
    FOREACH i104_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        END IF
 
        OUTPUT TO REPORT i104_rep(sr.*)
 
    END FOREACH
 
    FINISH REPORT i104_rep
 
    CLOSE i104_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i104_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    l_sw            LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fid01       LIKE fid_file.fid01,
        fid02       LIKE fid_file.fid02,
        fid03       LIKE fid_file.fid03,
        fid04       LIKE fid_file.fid04,
        fie02       LIKE fie_file.fie02,
        fie03       LIKE fie_file.fie03
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fid01,sr.fie02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.fid01,
                  COLUMN g_c[32],sr.fid02,
                  COLUMN g_c[33],sr.fid03 USING '---------&.&&&',
                  COLUMN g_c[34],sr.fid04 USING '---------&.&&&',
                  COLUMN g_c[35],sr.fie02 USING '<<<<<',
                  COLUMN g_c[36],sr.fie03
 
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
 
END REPORT
}
#No.FUN-780037---End
FUNCTION i104_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("fid01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i104_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("fid01",FALSE)
       END IF
   END IF
 
END FUNCTION
