# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsi318.4gl
# Descriptions...: 存貨預配記錄資料
# Date & Author..: NO.FUN-850114 08/01/21 BY yiting
# Modify.........: NO.FUN-840209 08/05/13 BY Duke
# Modify.........: NO.FUN-880010 08/08/07 BY DUKE add 配給對象vna02開窗查詢指定發料料號之工單單號,倉庫儲位check img_file
# Modify.........: NO.TQC-940088 09/04/16 BY destiny 1.fetch()段缺少一個KEY
#                                                    2.g_doc.column 的值應該對應一個KEY而不是把4個都賦給它
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0076 09/10/26 By lilingyu 改寫Sql標準寫法
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-B50004 11/05/23 by Abby APS GP5.25追版
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vna           RECORD LIKE vna_file.*,
    g_vna_t         RECORD LIKE vna_file.*,
    g_vna_o         RECORD LIKE vna_file.*,
    g_vna01_t       LIKE vna_file.vna01,
    g_vna02_t       LIKE vna_file.vna02,
    g_vna03_t       LIKE vna_file.vna03,
    g_vna04_t       LIKE vna_file.vna04,   #TQC-750013 add
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    l_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
    g_argv1         LIKE vna_file.vna01,
    g_argv2         LIKE vna_file.vna02,
    g_argv3         LIKE vna_file.vna03,
    g_argv4         LIKE vna_file.vna04
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-690010 INTEGER


MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

    INITIALIZE g_vna.* TO NULL
    INITIALIZE g_vna_t.* TO NULL
    INITIALIZE g_vna_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vna_file WHERE vna01 = ? AND vna02=? AND vna03=? AND vna04=? FOR UPDATE"  #FUN-9A0076
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i318_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i318_w WITH FORM "aps/42f/apsi318"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_argv1 =  ARG_VAL(1)       
    LET g_argv2 =  ARG_VAL(2)      
    LET g_argv3 =  ARG_VAL(3)
    LET g_argv4 =  ARG_VAL(4)
 
    IF NOT cl_null(g_argv1) AND cl_null(g_argv2)
       THEN CALL i318_q()
	    CALL i318_u()
    END IF
 
      LET g_action_choice=""
    CALL i318_menu()
 
    CLOSE WINDOW i318_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i318_cs()
    CLEAR FORM
    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3) AND 
           cl_null(g_argv4)) THEN
        LET g_wc = "vna01 = '",g_argv1,
                   "' and vna02 = '",g_argv2, "'",
                   "' and vna03 = '",g_argv3, "'",
                   "' and vna04 = '",g_argv4, "'"
    ELSE
   INITIALIZE g_vna.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         vna01,
         vna02,
         vna03,
         vna04,
         vna06,
         vna05,
         vna09
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(vna01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vna.vna01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO vna01
             NEXT FIELD vna01
 
             WHEN INFIELD(vna02)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_vna01"
             LET g_qryparam.state='c'
             LET g_qryparam.default1 = g_vna.vna02
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret to vna02
             NEXT FIELD vna02
 
 
             WHEN INFIELD(vna03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_img10"  #FUN-870010
             LET g_qryparam.state = "c"
             LET g_qryparam.arg1 = g_vna.vna01
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO vna03
             NEXT FIELD vna03
 
             OTHERWISE
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    END IF
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT vna01,vna02,vna03,vna04 ",# 組合出 SQL 指令
             "  FROM vna_file,ima_file,imd_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND ima01 = vna01 AND imd01 = vna03 ",
             " ORDER BY vna01,vna02,vna03,vna04 "
 
   PREPARE i318_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i318_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i318_prepare
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2)  
      AND cl_null(g_argv3) AND cl_null(g_argv4) THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vna_file ",
                 " WHERE vna01 ='",g_argv1,
                 "'  AND vna02 ='",g_argv2, "'",
                 "'  AND vna03 ='",g_argv3, "'",
                 "'  AND vna04 ='",g_argv4, "'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vna_file,ima_file,imd_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND ima01 = vna01 AND imd01 = vna03"
   END IF
   PREPARE i318_precount FROM g_sql
   DECLARE i318_count CURSOR FOR i318_precount
END FUNCTION
 
FUNCTION i318_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i318_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i318_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i318_fetch('N')
        ON ACTION previous
            CALL i318_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                CALL i318_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i318_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION first
            CALL i318_fetch('F')

        ON ACTION last
            CALL i318_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
  
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_vna.vna01 IS NOT NULL AND
                  g_vna.vna02 IS NOT NULL AND
                  g_vna.vna03 IS NOT NULL AND 
                  g_vna.vna04 IS NOT NULL THEN
                  LET g_doc.column1 = "vna01"
                  LET g_doc.value1 = g_vna.vna01
                  LET g_doc.column2 = "vna02"            #No.TQC-940088
                  LET g_doc.value2 = g_vna.vna02         #No.TQC-940088
                  LET g_doc.column2 = "vna03"            #No.TQC-940088
                  LET g_doc.value2 = g_vna.vna03         #No.TQC-940088
                  LET g_doc.column2 = "vna04"            #No.TQC-940088
                  LET g_doc.value2 = g_vna.vna04         #No.TQC-940088
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i318_cs
END FUNCTION
 
FUNCTION i318_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_vna.* LIKE vna_file.*
    LET g_vna01_t = NULL
    LET g_vna02_t = NULL
    LET g_vna03_t = NULL
    LET g_vna04_t = NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vna.vna05=0
        LET g_vna.vna06=0
        LET g_vna.vna09=0
        CALL i318_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_vna.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF (g_vna.vna01 AND g_vna.vna02 AND g_vna.vna03 AND g_vna.vna04) IS NULL THEN
           CONTINUE WHILE
        END IF
 
        IF g_vna.vna04 IS NULL THEN  LET  g_vna.vna04=' ' END IF
        LET g_vna.vnaplant = g_plant  #FUN-B50004 add
        LET g_vna.vnalegal = g_legal  #FUN-B50004 add
        INSERT INTO vna_file VALUES(g_vna.*)
        IF SQLCA.SQLCODE THEN
          CALL cl_err3("ins","vna_file",g_vna.vna02,g_vna.vna01,SQLCA.sqlcode,"","",1) # Fun-660095  
           CONTINUE WHILE
        ELSE
           SELECT vna01,vna02,vna03,vna04 INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04 FROM vna_file
                  WHERE vna01 = g_vna.vna01
                  AND vna02 = g_vna.vna02
                  AND vna03 = g_vna.vna03
                  AND vna04 = g_vna.vna04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i318_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_vna.vna01) AND cl_null(g_vna.vna03) AND cl_null(g_vna.vna02) 
       AND cl_null(g_vna.vna04) 
       THEN CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vna01_t = g_vna.vna01
    LET g_vna02_t = g_vna.vna02
    LET g_vna03_t = g_vna.vna03
    LET g_vna04_t = g_vna.vna04 #TQC-750013 add
    LET g_vna_o.*= g_vna.*
    BEGIN WORK
 
    OPEN i318_cl USING g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04
    IF STATUS THEN
       CALL cl_err("OPEN i318_cl:", STATUS, 1)
       CLOSE i318_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i318_cl INTO g_vna.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vna.vna01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i318_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i318_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vna.*=g_vna_t.*
            CALL i318_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_vna.vna04 IS NULL THEN  LET  g_vna.vna04=' ' END IF
 
        UPDATE vna_file SET vna_file.* = g_vna.*    # 更新DB
            WHERE vna01 = g_vna01_t AND vna02 = g_vna02_t 
                        AND vna03 = g_vna03_t AND vna04 = g_vna04_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vna_file",g_vna.vna02,g_vna.vna01,SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i318_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i318_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME
         g_vna.vna01,
         g_vna.vna02,
         g_vna.vna03,
         g_vna.vna04,
         g_vna.vna06,
         g_vna.vna05,
         g_vna.vna09
 
    INPUT BY NAME
         g_vna.vna01,
         g_vna.vna02,
         g_vna.vna03,
         g_vna.vna04,
         g_vna.vna06,
         g_vna.vna05,
         g_vna.vna09
         WITHOUT DEFAULTS
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i318_set_entry(p_cmd)
        CALL i318_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
    BEFORE FIELD vna01
        IF p_cmd = 'u' AND g_chkey = 'N' THEN
           NEXT FIELD vna06
        END IF
 
    AFTER FIELD vna01
      IF g_vna.vna01 IS NOT NULL THEN
        IF p_cmd = "a" OR    
           (p_cmd = "u" AND g_vna.vna01 != g_vna01_t) THEN
           SELECT ima01 FROM ima_file
           WHERE ima01 = g_vna.vna01 AND imaacti = 'Y'
           IF SQLCA.SQLCODE THEN
           CALL cl_err3("sel","ima_file",g_vna.vna01,"",SQLCA.sqlcode,"","",1) # Fun-660095
              LET g_vna.vna01 = g_vna01_t
              DISPLAY BY NAME g_vna.vna01
              NEXT FIELD vna01
           END IF
        END IF
      END IF
      IF g_vna.vna01 IS NULL THEN  
         NEXT  FIELD vna01 
      END IF
 
    AFTER FIELD vna05
      IF g_vna.vna05 IS NULL OR g_vna.vna05<0 THEN   #FUN-880010 add  IS NULL
         CALL cl_err('','aps-406',0)
         NEXT FIELD vna05
      END IF
      IF g_vna.vna06<g_vna.vna05 THEN   #FUN-880010
         CALL cl_err('','aps-714',0)
         NEXT FIELD vna05
      END IF
 
    AFTER FIELD vna06
      IF g_vna.vna06 IS NULL OR g_vna.vna06<0 THEN  #FUN-880010 add IS NULL
         CALL cl_err('','aps-406',0)
         NEXT FIELD vna06
      END IF
      IF  g_vna.vna06<g_vna.vna05 THEN   #FUN-880010
          CALL cl_err('','aps-714',0)
          NEXT FIELD vna06
      END IF
 
    AFTER FIELD vna03
      IF g_vna.vna03 IS NOT NULL THEN
        IF p_cmd = "a" OR
           (p_cmd = "u" AND g_vna.vna03 != g_vna03_t) THEN
           SELECT imd01 FROM imd_file
           WHERE imd01 = g_vna.vna03
              AND imdacti = 'Y' #MOD-4B0169
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("sel","imd_file",g_vna.vna03,"",SQLCA.sqlcode,"","",1) # Fun-660095
              LET g_vna.vna03 = g_vna03_t
              DISPLAY BY NAME g_vna.vna03
              NEXT FIELD vna03
           END IF
        END IF
      END IF
 
    AFTER FIELD vna02
        IF g_vna.vna02 IS NOT NULL THEN
           SELECT sfa01 from sfa_file 
                  where sfa03 = g_vna.vna01
                    AND sfa01 = g_vna.vna02
          IF SQLCA.SQLCODE THEN
             CALL cl_err3("sel","sfa_file",g_vna.vna02,"",SQLCA.sqlcode,"","",1)
             LET g_vna.vna02 = g_vna02_t
             DISPLAY BY NAME g_vna.vna02
             NEXT FIELD vna02
          END IF
       ELSE
          NEXT FIELD vna02
       END IF
 
    AFTER FIELD vna04
        IF g_vna.vna04 IS NULL THEN LET g_vna.vna04 =' ' END IF 
        SELECT COUNT(*) INTO l_n
           FROM img_file
          WHERE img02=g_vna.vna03
            AND img03=g_vna.vna04
            AND img01=g_vna.vna01
        IF l_n <= 0 THEN 
           CALL cl_err(g_vna.vna04,-1281,0)
           LET g_vna.vna04 = g_vna04_t
           DISPLAY BY NAME g_vna.vna04
           NEXT FIELD vna04
        ELSE 
          IF p_cmd = "a" OR
             (p_cmd = "u" AND g_vna.vna04 != g_vna04_t) THEN
             SELECT COUNT(*) INTO l_n 
               FROM vna_file
              WHERE vna01 = g_vna.vna01 
                AND vna02 = g_vna.vna02
                AND vna03 = g_vna.vna03
                AND vna04 = g_vna.vna04
             IF l_n > 0 THEN
                CALL cl_err(g_vna.vna03,-239,0)
                LET g_vna.vna04 = g_vna04_t
                DISPLAY BY NAME g_vna.vna04
                NEXT FIELD vna04
             END IF
         END IF
        END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(vna01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.default1 = g_vna.vna01
             CALL cl_create_qry() RETURNING g_vna.vna01
             DISPLAY BY NAME g_vna.vna01
             NEXT FIELD vna01
 
             WHEN INFIELD(vna02)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_sfa12"
             LET g_qryparam.arg1 = g_vna.vna01
             LET g_qryparam.default1 = g_vna.vna02
             CALL cl_create_qry() RETURNING g_vna.vna02
             DISPLAY BY NAME g_vna.vna02
             NEXT FIELD vna02
 
 
 
             WHEN INFIELD(vna03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_img10" #FUN-870010
             LET g_qryparam.arg1 = g_vna.vna01
             CALL cl_create_qry() RETURNING g_vna.vna03,g_vna.vna04
             DISPLAY BY NAME g_vna.vna03,g_vna.vna04
             NEXT FIELD vna03
 
             OTHERWISE
               EXIT CASE
           END CASE
 
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i318_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vna.* TO NULL          #No.FUN-6A0163
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i318_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i318_count
    FETCH i318_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i318_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vna.vna01,SQLCA.sqlcode,0)
        INITIALIZE g_vna.* TO NULL
    ELSE
        CALL i318_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i318_fetch(p_flvna_file)
    DEFINE
        p_flvna_file    LIKE type_file.chr1,     #No.FUN-690010  VARCHAR(1),
        l_abso         LIKE type_file.num10     #No.FUN-690010 INTEGER
 
    CASE p_flvna_file
         WHEN 'N' FETCH NEXT     i318_cs INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04                  #No.TQC-940088
         WHEN 'P' FETCH PREVIOUS i318_cs INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04                  #No.TQC-940088
         WHEN 'F' FETCH FIRST    i318_cs INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04                  #No.TQC-940088
         WHEN 'L' FETCH LAST     i318_cs INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04                  #No.TQC-940088
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
            FETCH ABSOLUTE l_abso i318_cs INTO g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04                  #No.TQC-940088   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vna.vna01,SQLCA.sqlcode,0)
        INITIALIZE g_vna.* TO NULL   #No.TQC-6B0105
        
        RETURN
    ELSE
       CASE p_flvna_file
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vna.* FROM vna_file            
WHERE vna01 = g_vna.vna01 AND vna02 = g_vna.vna02  AND vna03 = g_vna.vna03 AND vna04 = g_vna.vna04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vna_file",g_vna.vna02,g_vna.vna01,SQLCA.sqlcode,"","",1) # Fun-660095
    ELSE
 
        CALL i318_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i318_show()
    LET g_vna_t.* = g_vna.*
    DISPLAY BY NAME
         g_vna.vna01,
         g_vna.vna02,
         g_vna.vna03,
         g_vna.vna04,
         g_vna.vna06,
         g_vna.vna05,
         g_vna.vna09
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i318_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_vna.vna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i318_cl USING g_vna.vna01,g_vna.vna02,g_vna.vna03,g_vna.vna04
    IF STATUS THEN
       CALL cl_err("OPEN i318_cl:", STATUS, 1)
       CLOSE i318_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i318_cl INTO g_vna.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vna.vna01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i318_show()
    IF cl_delete() THEN
        DELETE FROM vna_file WHERE vna01 = g_vna.vna01 AND vna02 = g_vna.vna02  AND vna03 = g_vna.vna03 AND vna04 = g_vna.vna04
        CLEAR FORM
    END IF
    CLOSE i318_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i318_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vna02,vna01,vna03,vna04",TRUE)
   END IF
END FUNCTION
 
FUNCTION i318_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("vna02,vna01,vna03,vna04",FALSE) #TQC-750013 add vna04
   END IF
END FUNCTION
 
 
#No.FUN-9C0072 精簡程式碼
