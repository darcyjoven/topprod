# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli721.4gl
# Descriptions...: 常用傳票資料比率維護作業
# Date & Author..: 92/04/17 BY MAY
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490236 04/09/15 By Nicola 修改時，會計名稱無顯示
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By Lynn 會計科目加帳套-財務
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務-agli720串agli721有問題
# Modify.........: No.FUN-740201 07/04/26 By Carrier 科目做"部門"管理時,才可以key至部門字段
# Modify.........: No.MOD-7A0120 07/10/22 By Smapmin 輸入來源科目前都會出現錯誤訊息 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.MOD-B20073 11/02/17 By Dido 多筆時,需改用 distinct 語法
# Modify.........: No.MOD-B30296 11/03/14 By Dido 連續新增時,單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ahd01         LIKE ahd_file.ahd01,   #常用傳票表編號 (假單頭)
    g_ahd01_t       LIKE ahd_file.ahd01,   #常用傳票表編號 (舊值)
    g_bookno        LIKE ahd_file.ahd00,   #常用傳票帳別   (假單頭)
    g_argv1         LIKE ahd_file.ahd000,   #常用傳票表編號 (假單頭)
    g_argv2         LIKE ahd_file.ahd01,   #常用傳票表編號 (假單頭)
    g_ahd00         LIKE ahd_file.ahd00,   #常用傳票帳別   (假單頭)
    g_ahd000        LIKE ahd_file.ahd000,  #常用傳票性質   (假單頭)
    g_ahd00_t       LIKE ahd_file.ahd00,   #常用傳票帳別   (舊值)
    g_ahd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ahd02       LIKE ahd_file.ahd02,   #序號
        ahd03       LIKE ahd_file.ahd03,   #
        ahd04       LIKE ahd_file.ahd04,   #
        aag02       LIKE aag_file.aag02
                    END RECORD,
    g_ahd_t         RECORD                 #程式變數 (舊值)
        ahd02       LIKE ahd_file.ahd02,   #序號
        ahd03       LIKE ahd_file.ahd03,   #
        ahd04       LIKE ahd_file.ahd04,   #
        aag02       LIKE aag_file.aag02
                    END RECORD,
#   g_wc,g_wc2,g_sql    VARCHAR(300),
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166       
    g_sql_tmp           STRING,        #No.FUN-740033
    g_delete        LIKE type_file.chr1,                #若刪除資料,則要重新顯示筆數  #No.FUN-680098 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680098 SMALLINT
    g_ss            LIKE type_file.chr1,                                 #No.FUN-680098 VARCHAR(1) 
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72) 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
FUNCTION i721(p_bookno,p_argv1,p_argv2)
DEFINE
    p_row,p_col         LIKE type_file.num5,                #開窗的位置        #No.FUN-680098 SMALLINT
	p_bookno        LIKE ahd_file.ahd00,
	p_argv1         LIKE ahd_file.ahd000,
	p_argv2         LIKE ahd_file.ahd01,
    l_cnt               LIKE type_file.num5   #MOD-7A0120
 
    WHENEVER ERROR CALL cl_err_msg_log

    LET g_bookno= p_bookno                   #取得螢幕位置
    LET g_argv1 = p_argv1                  #性質
    LET g_argv2 = p_argv2                  #原始編號
    LET g_ahd01 = NULL                     #清除鍵值
    LET g_ahd01_t = NULL
    LET g_ahd00 = NULL    #No.FUN-740033
    LET g_ahd00_t = NULL  #No.FUN-740033
 
    OPEN WINDOW i721_w WITH FORM "agl/42f/agli721"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale('agli721')
 
    CALL s_shwact(0,0,g_bookno)
    LET g_delete='N'
    IF g_bookno IS NOT NULL AND g_bookno !=' ' AND g_argv1 IS NOT NULL AND g_argv1 !=' ' AND
       g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
       LET g_ahd00 = g_bookno
       LET g_ahd000= g_argv1
       LET g_ahd01 = g_argv2
       #-----MOD-7A0120---------
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM ahd_file
         WHERE ahd00=g_ahd00 AND ahd000=g_ahd000 AND ahd01=g_ahd01
       IF l_cnt > 0 THEN  
       #-----END MOD-7A0120-----
          CALL i721_q()
      #-MOD-B30296-add-
       ELSE
          LET g_rec_b = 0    
          CALL g_ahd.clear()
      #-MOD-B30296-end-
       END IF   #MOD-7A0120
       CALL i721_b()
    ELSE
       RETURN
    END  IF
    CLOSE WINDOW i721_w                 #結束畫面
END FUNCTION
 
#QBE 查詢資料
FUNCTION i721_cs()
    CLEAR FORM                             #清除畫面
   CALL g_ahd.clear()
	IF (g_bookno IS NOT NULL AND g_bookno != ' ') AND
       (g_argv1 IS NOT NULL AND g_argv1 != ' ') AND
       (g_argv2 IS NOT  NULL AND  g_argv2 != ' ') THEN
	   LET g_wc = " ahd00 = '",g_bookno,"'",
				  " AND ahd000= '",g_argv1,"'",
				  " AND ahd01 = '",g_argv2,"'"
#      DISPLAY g_ahd01 TO ahd01 ATTRIBUTE(YELLOW)  #No.FUN-740033
    ELSE  RETURN
    END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_sql="SELECT ahd000,ahd01,ahd00 FROM ahd_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ahd00,ahd01"  #No.FUN-740033
    PREPARE i721_prepare FROM g_sql      #預備一下
    DECLARE i721_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i721_prepare
    #No.FUN-740033 --Begin
    DROP TABLE x
    LET g_sql_tmp="SELECT UNIQUE ahd00,ahd01 ",
                  " FROM ahd_file WHERE ",g_wc CLIPPED,
                  " INTO TEMP x"
    PREPARE i721_pre_x FROM g_sql_tmp
    EXECUTE i721_pre_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    #No.FUN-740033 --End  
    PREPARE i721_precount FROM g_sql
    DECLARE i721_count CURSOR FOR i721_precount
END FUNCTION
 
FUNCTION i721_menu()
 
   WHILE TRUE
 
      CALL i721_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i721_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i721_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                CALL i721_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i721_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i721_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ahd),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ahd01 IS NOT NULL THEN
                LET g_doc.column1 = "ahd01"
                LET g_doc.column2 = "ahd00"
                LET g_doc.value1 = g_ahd01
                LET g_doc.value2 = g_ahd00
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
 
   END WHILE
 
END FUNCTION
 
FUNCTION i721_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ahd01 TO NULL INITIALIZE g_ahd000 TO NULL        #NO.FUN-6B0040 
    INITIALIZE g_ahd00 TO NULL        #NO.FUN-6B0040 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i721_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i721_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN             #有問題
       CALL cl_err('open i721_b_cs:',SQLCA.sqlcode,0)
       INITIALIZE g_ahd01 TO NULL INITIALIZE g_ahd000 TO NULL
       INITIALIZE g_ahd00 TO NULL        #NO.FUN-6B0040 
    ELSE
       CALL i721_fetch('F')            #讀出TEMP第一筆並顯示
       #No.FUN-740033  --Begin
#      OPEN i721_count
#      FETCH i721_count INTO g_row_count
#      DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
       #No.FUN-740033  --End  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i721_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i721_b_cs INTO g_ahd000,g_ahd01,g_ahd00
        WHEN 'P' FETCH PREVIOUS i721_b_cs INTO g_ahd000,g_ahd01,g_ahd00
        WHEN 'F' FETCH FIRST    i721_b_cs INTO g_ahd000,g_ahd01,g_ahd00
        WHEN 'L' FETCH LAST     i721_b_cs INTO g_ahd000,g_ahd01,g_ahd00
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i721_b_cs INTO g_ahd000,g_ahd01,g_ahd00
            LET mi_no_ask = FALSE
    END CASE
   #SELECT ahd01,ahd00,ahd000 INTO g_ahd01,g_ahd00,g_ahd000           #MOD-B20073 amrk
    SELECT DISTINCT ahd01,ahd00,ahd000 INTO g_ahd01,g_ahd00,g_ahd000  #MOD-B20073
      FROM ahd_file WHERE ahd00 = g_ahd00 AND ahd01 = g_ahd01 AND ahd000 = g_ahd000
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ahd01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","ahd_file",g_ahd01,g_ahd00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_ahd00 TO NULL  #TQC-6B0105
       INITIALIZE g_ahd01 TO NULL INITIALIZE g_ahd000 TO NULL  #TQC-6B0105
       #No.FUN-740033 --Begin
       LET g_ahd00 = g_bookno
       LET g_ahd01 = g_argv2 
       LET g_ahd000= g_argv1 
       #No.FUN-740033 --End  
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
    #No.FUN-740033  --Begin
    #OPEN i721_count
    #FETCH i721_count INTO g_row_count
    #DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
    CALL i721_show()
    #No.FUN-740033  --End  
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i721_show()
    #No.FUN-740033  --Begin
    #DISPLAY g_ahd01 TO ahd01               #單頭
    #DISPLAY g_ahd000 TO ahd000             #單頭
    #    ATTRIBUTE(YELLOW)
    #No.FUN-740033  --End  
    CALL i721_b_fill(0)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i721_r()
    IF s_aglshut(0) THEN RETURN END IF                #檢查權限
    IF g_ahd01 IS NULL THEN
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ahd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ahd00"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ahd01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ahd00       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM ahd_file WHERE ahd01 = g_ahd01 AND ahd00 = g_ahd00 AND
                                   ahd000 = g_ahd000
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("del","ahd_file",g_ahd01,g_ahd00,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
            ROLLBACK WORK RETURN
        ELSE
            CLEAR FORM
            CALL g_ahd.clear()
            CALL g_ahd.clear()
            LET g_delete='Y'
            LET g_ahd01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i721_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i721_b_cs
               CLOSE i721_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i721_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i721_b_cs
               CLOSE i721_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i721_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i721_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i721_fetch('/')
            END IF
 
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i721_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680098 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680098 VARCHAR(1) 
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680098 VARCHAR(1) 
    l_allow_insert  LIKE type_file.chr1,                #可新增否         #No.FUN-680098 VARCHAR(1) 
    l_allow_delete  LIKE type_file.chr1                #可刪除否          #No.FUN-680098 VARCHAR(1) 
 
    LET g_action_choice = ""
    IF s_aglshut(0) THEN RETURN END IF                #檢查權限
 
    LET l_ac_t=0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    IF g_ahd01 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ahd02,ahd03,ahd04 FROM ahd_file ",
                       "  WHERE ahd00= ? AND ahd000= ? AND ahd01=? AND ahd02= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i721_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ahd WITHOUT DEFAULTS FROM s_ahd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_ahd_t.* = g_ahd[l_ac].*  #BACKUP
              OPEN i721_bcl USING g_ahd00,g_ahd000,g_ahd01,g_ahd_t.ahd02
              IF STATUS THEN
                 CALL cl_err("OPEN i721_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i721_bcl INTO g_ahd[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ahd_t.ahd03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                  #-----No.MOD-490236-----
                 ELSE
                    SELECT aag02 INTO g_ahd[l_ac].aag02
                      FROM aag_file
                     WHERE aag01 = g_ahd[l_ac].ahd03
                       AND aag00 = g_ahd00          #No.FUN-740020  #No.FUN-740033
                  #-----No.MOD-490236 END-----
                 END IF
              END IF
              #No.FUN-740201  --Begin
              CALL i721_set_entry_b(p_cmd)
              CALL i721_set_no_entry_b(p_cmd)
              #No.FUN-740201  --End  
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ahd[l_ac].* TO NULL      #900423
           LET g_ahd_t.* = g_ahd[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           #No.FUN-740201  --Begin
           CALL i721_set_entry_b(p_cmd)
           CALL i721_set_no_entry_b(p_cmd)
           #No.FUN-740201  --End  
           NEXT FIELD ahd02
 
        AFTER INSERT
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
              CLOSE i721_bcl
           END IF
            INSERT INTO ahd_file (ahd00,ahd000,ahd01,ahd02,ahd03,ahd04)  #No.MOD-470041
                VALUES(g_ahd00,g_ahd000,g_ahd01,g_ahd[l_ac].ahd02,
                       g_ahd[l_ac].ahd03,g_ahd[l_ac].ahd04)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_ahd[l_ac].ahd02,SQLCA.sqlcode,0)   #No.FUN-660123
              CALL cl_err3("ins","ahd_file",g_ahd00,g_ahd000,SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD ahd02                        #default 序號
           IF cl_null(g_ahd[l_ac].ahd02) OR g_ahd[l_ac].ahd02 = 0 THEN
              SELECT max(ahd02)+1
                INTO g_ahd[l_ac].ahd02
                FROM ahd_file
               WHERE ahd01 = g_ahd01 AND
                     ahd00 = g_ahd00 AND
                     ahd000 = g_ahd000
              IF g_ahd[l_ac].ahd02 IS NULL THEN
                 LET g_ahd[l_ac].ahd02 = 1
              END IF
           END IF
 
        AFTER FIELD ahd02                        #check 序號是否重複
           IF NOT cl_null(g_ahd[l_ac].ahd02) THEN
              IF g_ahd[l_ac].ahd02 != g_ahd_t.ahd02 OR
                 g_ahd_t.ahd02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM ahd_file
                  WHERE ahd01 = g_ahd01 AND
                        ahd02 = g_ahd[l_ac].ahd02 AND
                        ahd00 = g_ahd00 AND
                        ahd000 = g_ahd000
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ahd[l_ac].ahd02 = g_ahd_t.ahd02
                    NEXT FIELD ahd02
                 END IF
              END IF
           END IF
 
        #No.FUN-740201  --Begin
        BEFORE FIELD ahd03
           CALL i721_set_entry_b(p_cmd)
        #No.FUN-740201  --End  
 
        AFTER FIELD ahd03
           IF NOT cl_null(g_ahd[l_ac].ahd03) THEN
              CALL i721_ahd03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                #Mod No.FUN-B10048
                #LET g_ahd[l_ac].ahd03=g_ahd_t.ahd03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ahd[l_ac].ahd03
                 LET g_qryparam.arg1 = g_ahd00 
                 LET g_qryparam.where = " aag01 LIKE '",g_ahd[l_ac].ahd03 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ahd[l_ac].ahd03
                 DISPLAY BY NAME g_ahd[l_ac].ahd03
                #End Mod No.FUN-B10048
                 NEXT FIELD ahd03
             END IF
           END IF
           CALL i721_set_no_entry_b(p_cmd)  #No.FUN-740201
 
        AFTER FIELD ahd04
           IF NOT cl_null(g_ahd[l_ac].ahd04) THEN
              SELECT COUNT(*) INTO l_n FROM gem_file
               WHERE gem01 = g_ahd[l_ac].ahd04 AND gem05='Y'
              IF l_n=0 THEN
                 CALL cl_err('','agl-004',0)
                 NEXT FIELD ahd04
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_ahd_t.ahd02 > 0 AND g_ahd_t.ahd02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
              DELETE FROM ahd_file
               WHERE ahd00 = g_ahd00 AND
                     ahd000 = g_ahd000 AND
                     ahd01 = g_ahd01 AND
                     ahd02 = g_ahd_t.ahd02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ahd_t.ahd02,SQLCA.sqlcode,0)   #No.FUN-660123
                 CALL cl_err3("del","ahd_file",g_ahd00,g_ahd000,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 ROLLBACK WORK
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
              LET g_ahd[l_ac].* = g_ahd_t.*
              CLOSE i721_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN     # 新增此段
              CALL cl_err(g_ahd[l_ac].ahd02,SQLCA.sqlcode,0)
              LET g_ahd[l_ac].* = g_ahd_t.*
           ELSE
              UPDATE ahd_file SET ahd02 = g_ahd[l_ac].ahd02,
                                  ahd03 = g_ahd[l_ac].ahd03,
                                  ahd04 = g_ahd[l_ac].ahd04
               WHERE ahd00 = g_ahd00
                 AND ahd000= g_ahd000
                 AND ahd01 = g_ahd01
                 AND ahd02 = g_ahd_t.ahd02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ahd[l_ac].ahd02,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","ahd_file",g_ahd00,g_ahd000,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_ahd[l_ac].* = g_ahd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           #LET l_ac_t = l_ac  #FUN-D30032
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_ahd[l_ac].* = g_ahd_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_ahd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE i721_bcl            # 新增
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ahd02) AND l_ac > 1 THEN
              LET g_ahd[l_ac].* = g_ahd[l_ac-1].*
              LET g_ahd[l_ac].ahd02 = NULL   #TQC-620018
              NEXT FIELD ahd02
            END IF
 
        ON ACTION mntn_acc_code
           CALL cl_cmdrun('agli102' CLIPPED)
 
        ON ACTION mntn_acc_dept
           CALL cl_cmdrun('agli104' CLIPPED)
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ahd03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_ahd[l_ac].ahd03
                   LET g_qryparam.arg1 = g_ahd00   #No.FUN-740033
                   CALL cl_create_qry() RETURNING g_ahd[l_ac].ahd03
#                   CALL FGL_DIALOG_SETBUFFER( g_ahd[l_ac].ahd03 )
                    DISPLAY BY NAME g_ahd[l_ac].ahd03              #No.MOD-490344
                   CALL i721_ahd03('d')
                   NEXT FIELD ahd03
              WHEN INFIELD(ahd04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_ahd[l_ac].ahd04
                   CALL cl_create_qry() RETURNING g_ahd[l_ac].ahd04
#                   CALL FGL_DIALOG_SETBUFFER( g_ahd[l_ac].ahd04 )
                    DISPLAY BY NAME g_ahd[l_ac].ahd04              #No.MOD-490344
                   NEXT FIELD ahd04
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
 
 
    END INPUT
 
    CLOSE i721_bcl
 
END FUNCTION
 
FUNCTION i721_ahd03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
    l_aha09         LIKE aha_file.aha09,
    l_aha08         LIKE aha_file.aha08,
    l_n             LIKE type_file.num5,          #No.FUN-680098 smallint
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
        INTO g_ahd[l_ac].aag02,l_aagacti
        FROM aag_file
        WHERE aag01 = g_ahd[l_ac].ahd03
          AND aag00 = g_ahd00      #No.FUN-740020
    CASE WHEN STATUS = 100  LET g_errno = 'agl-001'
                            LET g_ahd[l_ac].aag02 = NULL
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    SELECT aha08,aha09 INTO l_aha08,l_aha09 FROM aha_file
                       WHERE aha00 = g_ahd00 AND
                             aha01 = g_ahd01 AND
                             aha000 = g_ahd000
    IF l_aha09 != ' ' AND l_aha09 IS NOT NULL THEN
    SELECT COUNT(*) INTO l_n FROM afb_file WHERE afb00 = g_ahd00 AND
                                                 afb01 = l_aha09 AND
                                                 afb02 = g_ahd[l_ac].ahd03 AND 
                                                 afbacti = 'Y'   #TQC-630238
    IF (g_ahd_t.ahd03 != g_ahd[l_ac].ahd03 AND g_ahd_t.ahd03 IS NOT NULL) OR
       (g_ahd_t.ahd03 IS NULL AND g_ahd[l_ac].ahd03 ) THEN
       IF l_n = 0 THEN CALL cl_err('','agl-148',0) END IF
    END IF
    END IF
END FUNCTION
 
FUNCTION i721_b_askkey()
DEFINE
    l_begin_key     LIKE ahd_file.ahd03
 
    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
    PROMPT g_msg CLIPPED,': ' FOR l_begin_key
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END PROMPT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    IF l_begin_key IS NULL THEN
        LET l_begin_key = 0
    END IF
    CALL i721_b_fill(l_begin_key)
END FUNCTION
 
FUNCTION i721_b_fill(p_key)              #BODY FILL UP
DEFINE
    p_key           LIKE ahd_file.ahd03,
#   l_sql           CAHR(400)
    l_sql           STRING         #TQC-630166       
 
    LET l_sql = "SELECT ahd02,ahd03,ahd04,aag02 FROM ahd_file LEFT OUTER JOIN aag_file ON aag_file.aag00  = ahd00 AND ahd03 = aag_file.aag01 ",
                " WHERE ahd00 = '",g_ahd00 CLIPPED,
                "' AND ahd000 = '",g_ahd000 CLIPPED,
                "' AND ahd01  = '",g_ahd01 CLIPPED,
                "' ",       #No.FUN-740020  #No.FUN-740033
                "    ORDER BY ahd02 "  #No.FUN-740033
    PREPARE i721_pb FROM l_sql
    DECLARE ahd_cs CURSOR FOR i721_pb
 
    CALL g_ahd.clear()
 
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH ahd_cs INTO g_ahd[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b +1
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ahd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1  #No.FUN-740033
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
    #No.FUN-740033  --Begin
    DISPLAY ARRAY g_ahd TO s_ahd.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    #No.FUN-740033  --End  
 
END FUNCTION
 
FUNCTION i721_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahd TO s_ahd.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i721_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i721_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i721_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i721_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i721_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i721_copy()
DEFINE
    l_oldno         LIKE ahd_file.ahd01,
    l_newno         LIKE ahd_file.ahd01
 
    IF s_aglshut(0) THEN RETURN END IF                #檢查權限
    IF g_ahd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    INPUT l_newno  FROM ahd01
        AFTER FIELD ahd01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM ahd_file
                WHERE aha01 = l_newno AND aha00 = g_ahd00 AND aha000 = g_aha000
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD ahd01
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
    IF INT_FLAG OR cl_null(l_newno) THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    DROP TABLE x
    SELECT * FROM ahd_file
        WHERE ahd01 = g_ahd01 AND
			  ahd00 = g_ahd00
        INTO TEMP x
    UPDATE x
        SET ahd01=l_newno     #資料鍵值
    INSERT INTO ahd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ahd01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","ahd_file",l_newno,g_ahd00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ahd01
        LET g_ahd01 = l_newno
        CALL i721_b()
        #LET g_ahd01 = l_oldno  #FUN-C30027
        #CALL i721_show()       #FUN-C30027
    END IF
END FUNCTION
 
FUNCTION i721_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098  smallint
    sr              RECORD
        ahd01       LIKE ahd_file.ahd01,   #常用傳票表編號
        ahd02       LIKE ahd_file.ahd02,   #序號
        ahd03       LIKE ahd_file.ahd03,   #
        ahd04       LIKE ahd_file.ahd04    #
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680098 VARCHAR(20) 
    l_za05          LIKE za_file.za05      #        #No.FUN-680098 VARCHAR(40) 
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'agli721'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT ahd01,ahd02,ahd03,ahd04",
              " FROM ahd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i721_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i721_co CURSOR FOR i721_p1
 
    CALL cl_outnam('agli721') RETURNING l_name
    START REPORT i721_rep TO l_name
 
    FOREACH i721_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i721_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i721_rep
 
    CLOSE i721_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i721_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1) 
    sr              RECORD
        ahd01       LIKE ahd_file.ahd01,   #常用傳票表編號
        ahd02       LIKE ahd_file.ahd02,   #序號
        ahd03       LIKE ahd_file.ahd03,   #從幾點幾分
        ahd04       LIKE ahd_file.ahd04    #
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ahd01,sr.ahd02
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
             COLUMN (g_len-FGL_WIDTH(g_user)-5),g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11],g_x[12]
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.ahd01  #常用傳票表編號
            PRINT COLUMN 7,sr.ahd01;
 
        ON EVERY ROW
            PRINT COLUMN 23,sr.ahd02 USING '###&',
                  COLUMN 48,sr.ahd03,' ',sr.ahd04
 
        AFTER  GROUP OF sr.ahd01  #常用傳票表編號
              SKIP 1 LINE
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                    #TQC-630166
                    #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
 		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#Patch....NO.TQC-610035 <001> #
 
#No.FUN-740201  --Begin
FUNCTION i721_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
 
    CALL cl_set_comp_entry("ahd04",TRUE)
END FUNCTION
 
FUNCTION i721_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
DEFINE   l_aag05   LIKE aag_file.aag05
 
    SELECT aag05 INTO l_aag05 FROM aag_file
     WHERE aag01 = g_ahd[l_ac].ahd03
       AND aag00 = g_ahd00
    IF l_aag05 = 'N' THEN
       CALL cl_set_comp_entry("ahd04",FALSE)
    END IF
END FUNCTION
#No.FUN-740201  --End  
