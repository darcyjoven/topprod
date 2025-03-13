# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi204.4gl
# Descriptions...: 料件基本資料維護
# Date & Author..: 02/03/14 By Wiky
# Modify.........: No:FUN-4B0037 04/11/10 By ching add con_type..
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-660193 06/06/30 By Joe add con_bs del is_ato,is_phan,p_des,use_qty
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-6A0163 06/11/07 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-720043 07/03/02 By Mandy APS整合調整
# Modify.........: No:TQC-750013 07/05/04 By Mandy 當按下APS相關資料時(apsi204),最大批量數請帶'999999',而非'9999999'
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_ima           RECORD LIKE aps_ima.*, #FUN-720043
    g_aps_ima_t         RECORD LIKE aps_ima.*, #FUN-720043
    g_aps_imapid        LIKE aps_ima.pid,      #品項編號
    g_aps_ima_rowid     LIKE type_file.chr18, 		#ROWID  #No.FUN-690010 INT
    g_flag              LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_wc,g_sql          string  #No:FUN-580092 HCN

DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
MAIN
    DEFINE l_time          LIKE type_file.chr8   	#計算被使用時間  #No.FUN-690010 VARCHAR(8)
    DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT

    OPTIONS					#改變一些系統預設值
        FORM LINE     FIRST + 2,		#畫面開始的位置
        MESSAGE LINE  LAST,			#訊息顯示的位置
        PROMPT LINE   LAST,			#提示訊息的位置
        INPUT NO WRAP				#輸入的方式: 不打轉
						
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
    INITIALIZE g_aps_ima.* TO NULL
    INITIALIZE g_aps_ima_t.* TO NULL

    LET g_forupd_sql = "SELECT * FROM aps_ima WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE i204_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR

    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i204_w AT p_row,p_col
      WITH FORM "aps/42f/apsi204"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


    LET g_aps_ima.pid  = ARG_VAL(1)
    IF g_aps_ima.pid IS NOT NULL AND  g_aps_ima.pid != ' '
       THEN LET g_flag = 'Y'
            CALL i204_q()
       ELSE LET g_flag = 'N'
    END IF

    WHILE TRUE
      LET g_action_choice=""
      CALL i204_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i204_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i204_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " pid='",g_aps_ima.pid,"'"
    ELSE
   INITIALIZE g_aps_ima.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          pid,lot_rule,is_used,is_int,max_lot,is_ctl,is_cons,mo_tol,po_tol,
          is_feat,con_type,rel_refo,lst_cmb,lst_cblm,is_cnsn,sfx_lt,sply_rid,
          cons_bs,al_ratio,orip_id,pro_line_id,pro_line_nm,is_b_point,
          is_phan_del

          #No:FUN-580031 --start--     HCN
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #No:FUN-580031 --end--       HCN
          
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
          
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
          
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
          
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
          #No:FUN-580031 --start--     HCN
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
          #No:FUN-580031 --end--       HCN

       END CONSTRUCT
    END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                                 #只能使用自己的資料
        LET g_wc = g_wc clipped," AND pmeuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                                 #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND pmegrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND pmegrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql = "SELECT ROWID,pid FROM aps_ima ",   # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY pid"
    PREPARE i204_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i204_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i204_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM aps_ima WHERE ",g_wc CLIPPED
    PREPARE i204_precount FROM g_sql
    DECLARE i204_count CURSOR FOR i204_precount
END FUNCTION

FUNCTION i204_menu()
    MENU ""

        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i204_q()
           END IF
        ON ACTION next
           CALL i204_fetch('N')
        ON ACTION previous
           CALL i204_fetch('P')
        ON ACTION modify
           CALL i204_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121

        #No:FUN-6A0163-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_aps_ima.pid IS NOT NULL THEN
                  LET g_doc.column1 = "pid"
                  LET g_doc.value1 = g_aps_ima.pid
                  CALL cl_doc()
               END IF
           END IF
        #No:FUN-6A0163-------add--------end---- 
           LET g_action_choice = "exit"
           CONTINUE MENU

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i204_cs
END FUNCTION


FUNCTION i204_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_aps_ima.* LIKE aps_ima.*
    LET g_aps_ima.pid          = NULL
    LET g_aps_ima.lot_rule     = 0
    LET g_aps_ima.is_used      = 0  
    LET g_aps_ima.is_int       = 0
   #LET g_aps_ima.max_lot      = 9999999 #TQC-750013 mark
    LET g_aps_ima.max_lot      = 999999  #TQC-750013 mod
    LET g_aps_ima.is_ctl       = 0
    LET g_aps_ima.is_cons      = 0
    LET g_aps_ima.mo_tol       = 0
    LET g_aps_ima.po_tol       = 0
    LET g_aps_ima.is_feat      = 0
    LET g_aps_ima.con_type     = 0
    LET g_aps_ima.rel_refo     = 0  
    LET g_aps_ima.lst_cmb      = 0  
    LET g_aps_ima.lst_cblm     = 1  
    LET g_aps_ima.is_cnsn      = 0  
    LET g_aps_ima.sfx_lt       = 0  
    LET g_aps_ima.sply_rid     = NULL  
    LET g_aps_ima.cons_bs      = 7  
    LET g_aps_ima.al_ratio     = 0  
    LET g_aps_ima.orip_id      = NULL  
    LET g_aps_ima.pro_line_id  = NULL 
    LET g_aps_ima.pro_line_nm  = NULL  
    LET g_aps_ima.is_b_point   = 0  
    LET g_aps_ima.is_phan_del  = 0

    LET g_aps_ima_t.*=g_aps_ima.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i204_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_aps_ima.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_aps_ima.pid IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO aps_ima VALUES(g_aps_ima.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","aps_ima",g_aps_ima.pid,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_aps_ima_t.* = g_aps_ima.*                # 保存上筆資料
            SELECT ROWID INTO g_aps_ima_rowid FROM aps_ima
                WHERE pid = g_aps_ima.pid
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i204_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT

    DISPLAY BY NAME 
        g_aps_ima.pid          ,
        g_aps_ima.lot_rule     ,
        g_aps_ima.is_used      ,
        g_aps_ima.is_int       ,
        g_aps_ima.max_lot      ,
        g_aps_ima.is_ctl       ,
        g_aps_ima.is_cons      ,
        g_aps_ima.mo_tol       ,
        g_aps_ima.po_tol       ,
        g_aps_ima.is_feat      ,
        g_aps_ima.con_type     ,
        g_aps_ima.rel_refo     ,
        g_aps_ima.lst_cmb      ,
        g_aps_ima.lst_cblm     ,
        g_aps_ima.is_cnsn      ,
        g_aps_ima.sfx_lt       ,
        g_aps_ima.sply_rid     ,
        g_aps_ima.cons_bs      ,
        g_aps_ima.al_ratio     ,
        g_aps_ima.orip_id      ,
        g_aps_ima.pro_line_id  ,
        g_aps_ima.pro_line_nm  ,
        g_aps_ima.is_b_point   ,
        g_aps_ima.is_phan_del   

    INPUT BY NAME   
        g_aps_ima.pid          ,
        g_aps_ima.lot_rule     ,
        g_aps_ima.is_used      ,
        g_aps_ima.is_int       ,
        g_aps_ima.max_lot      ,
        g_aps_ima.is_ctl       ,
        g_aps_ima.is_cons      ,
        g_aps_ima.mo_tol       ,
        g_aps_ima.po_tol       ,
        g_aps_ima.is_feat      ,
        g_aps_ima.con_type     ,
        g_aps_ima.rel_refo     ,
        g_aps_ima.lst_cmb      ,
        g_aps_ima.lst_cblm     ,
        g_aps_ima.is_cnsn      ,
        g_aps_ima.sfx_lt       ,
        g_aps_ima.sply_rid     ,
        g_aps_ima.cons_bs      ,
        g_aps_ima.al_ratio     ,
        g_aps_ima.orip_id      ,
        g_aps_ima.pro_line_id  ,
        g_aps_ima.pro_line_nm  ,
        g_aps_ima.is_b_point   ,
        g_aps_ima.is_phan_del   
        WITHOUT DEFAULTS

        AFTER FIELD lot_rule
            IF NOT cl_null(g_aps_ima.lot_rule) THEN
               IF g_aps_ima.lot_rule NOT MATCHES '[012]' THEN
                  NEXT FIELD lot_rule
               END IF
            END IF
            LET g_aps_ima_t.lot_rule = g_aps_ima.lot_rule

        AFTER FIELD is_used
            IF NOT cl_null(g_aps_ima.is_used) THEN
               IF g_aps_ima.is_used NOT MATCHES '[01]' THEN
                  NEXT FIELD is_used
               END IF
            END IF
            LET g_aps_ima_t.is_used = g_aps_ima.is_used

        AFTER FIELD is_ctl
            IF NOT cl_null(g_aps_ima.is_ctl) THEN
               IF g_aps_ima.is_ctl NOT MATCHES '[01]' THEN
                  NEXT FIELD is_ctl
               END IF
            END IF
            LET g_aps_ima_t.is_ctl = g_aps_ima.is_ctl

        AFTER FIELD is_cons
            IF NOT cl_null(g_aps_ima.is_cons) THEN
               IF g_aps_ima.is_cons NOT MATCHES '[01]' THEN
                  NEXT FIELD is_cons
               END IF
            END IF
            LET g_aps_ima_t.is_cons = g_aps_ima.is_cons

        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD pid
           END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION
 
FUNCTION i204_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i204_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_aps_ima.* TO NULL
        RETURN
    END IF
    OPEN i204_count
    FETCH i204_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i204_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ima.pid,SQLCA.sqlcode,0)
        INITIALIZE g_aps_ima.* TO NULL
    ELSE
        CALL i204_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i204_fetch(p_flpme)
    DEFINE
        p_flpme         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER

    CASE p_flpme
        WHEN 'N' FETCH NEXT     i204_cs INTO g_aps_ima_rowid,g_aps_ima.pid
        WHEN 'P' FETCH PREVIOUS i204_cs INTO g_aps_ima_rowid,g_aps_ima.pid
        WHEN 'F' FETCH FIRST    i204_cs INTO g_aps_ima_rowid,g_aps_ima.pid
        WHEN 'L' FETCH LAST     i204_cs INTO g_aps_ima_rowid,g_aps_ima.pid
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i204_cs INTO g_aps_ima_rowid,g_aps_ima.pid
    END CASE

    IF SQLCA.sqlcode THEN
        LET g_msg = g_aps_ima.pid CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_aps_ima.* TO NULL          #No.FUN-6A0163
        RETURN
    ELSE
       CASE p_flpme
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_aps_ima.* FROM aps_ima            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_aps_ima_rowid
    IF SQLCA.sqlcode THEN
        LET g_msg = g_aps_ima.pid CLIPPED
#        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("sel","aps_ima",g_aps_ima.pid,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_aps_ima.* TO NULL       #No.FUN-6A0163
    ELSE

        CALL i204_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i204_show()
    LET g_aps_ima_t.* = g_aps_ima.*
    DISPLAY BY NAME 
        g_aps_ima.pid          ,
        g_aps_ima.lot_rule     ,
        g_aps_ima.is_used      ,
        g_aps_ima.is_int       ,
        g_aps_ima.max_lot      ,
        g_aps_ima.is_ctl       ,
        g_aps_ima.is_cons      ,
        g_aps_ima.mo_tol       ,
        g_aps_ima.po_tol       ,
        g_aps_ima.is_feat      ,
        g_aps_ima.con_type     ,
        g_aps_ima.rel_refo     ,
        g_aps_ima.lst_cmb      ,
        g_aps_ima.lst_cblm     ,
        g_aps_ima.is_cnsn      ,
        g_aps_ima.sfx_lt       ,
        g_aps_ima.sply_rid     ,
        g_aps_ima.cons_bs      ,
        g_aps_ima.al_ratio     ,
        g_aps_ima.orip_id      ,
        g_aps_ima.pro_line_id  ,
        g_aps_ima.pro_line_nm  ,
        g_aps_ima.is_b_point   ,
        g_aps_ima.is_phan_del   
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i204_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_aps_ima.pid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aps_imapid = g_aps_ima.pid
    BEGIN WORK

    OPEN i204_cl USING g_aps_ima_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i204_cl:", STATUS, 1)
       CLOSE i204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i204_cl INTO g_aps_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ima.pid,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i204_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i204_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps_ima.* = g_aps_ima_t.*
            CALL i204_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_ima SET aps_ima.* = g_aps_ima.*    # 更新DB
            WHERE ROWID = g_aps_ima_rowid               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           LET g_msg = g_aps_ima.pid CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660095
            CALL cl_err3("upd","aps_ima",g_aps_imapid,"",SQLCA.sqlcode,"","",1) # FUN-660095
           CONTINUE WHILE
        ELSE
           LET g_aps_ima_t.* = g_aps_ima.*# 保存上筆資料
           SELECT ROWID INTO g_aps_ima_rowid FROM aps_ima
            WHERE pid = g_aps_ima.pid
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i204_cl
    COMMIT WORK
END FUNCTION

FUNCTION i204_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_aps_ima.pid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i204_cl USING g_aps_ima_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i204_cl:", STATUS, 1)
       CLOSE i204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i204_cl INTO g_aps_ima.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_ima.pid,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i204_show()
    IF cl_delete() THEN
            DELETE FROM aps_ima WHERE ROWID = g_aps_ima_rowid
            CLEAR FORM
    END IF
    CLOSE i204_cl
    INITIALIZE g_aps_ima.* TO NULL
    COMMIT WORK
END FUNCTION

#Patch....NO:TQC-610036 <> #
