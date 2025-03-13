# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi304.4gl
# Descriptions...: 設備群組資料維護作業
# Date & Author..: FUN-850114 07/12/26 BY Yiting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vme01            LIKE vme_file.vme01,   #設備群組編號(假單頭)  #FUN-850114
    g_vme01_t          LIKE vme_file.vme01,   #設備群組編號(舊值)
    g_vme02            LIKE vme_file.vme02,    #設備編號
    g_vme02_t          LIKE vme_file.vme02,    #設備編號
    g_vme         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vme02          LIKE vme_file.vme02,   #設備編號
        eci06          LIKE eci_file.eci06   #標籤編號
                       END RECORD,
    g_vme_t       RECORD                 #程式變數 (舊值)
        vme02          LIKE vme_file.vme02,   #OJT代號
        eci06          LIKE eci_file.eci06   #OJT課程說明
                       END RECORD,
    g_cpf31   LIKE type_file.chr10,   #LIKE cpf_file.cpf31,   #TQC-B90211
    g_wc,g_sql,g_wc2   string,  #No.FUN-580092 HCN
    g_argv1         LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)      #資料性質
    g_argv2         LIKE type_file.chr20,    #No.FUN-690010 VARCHAR(10),    #單號
    g_argv3         LIKE type_file.num5,     #No.FUN-690010 SMALLINT,    #項次
    g_show          LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1),
    g_rec_b         LIKE type_file.num5,     #單身筆數                   #No.FUN-690010 SMALLINT
    g_flag          LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)
    g_ss            LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_jump               LIKE type_file.num10   #No.TQC-720019
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER


MAIN
DEFINE
    g_time        LIKE type_file.chr8,    #計算被使用時間  #No.FUN-690010 VARCHAR(8)
    p_row,p_col   LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW i304_w WITH FORM "aps/42f/apsi304"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL i304_menu()
 
    CLOSE WINDOW i304_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i304_cs()
    CLEAR FORM 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032                            #清除畫面
   INITIALIZE g_vme01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON vme01,vme02 FROM vme01,s_vme[1].vme02
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            IF INFIELD(vme02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_eci"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO vme02
               NEXT FIELD vme02
            END IF
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql= "SELECT UNIQUE vme01 FROM vme_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i304_prepare FROM g_sql      #預備一下
    DECLARE i304_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i304_prepare
 
#   LET g_sql = "SELECT UNIQUE vme01 FROM vme_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE vme01 FROM vme_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i304_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i304_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i304_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i304_precount FROM g_sql
    DECLARE i304_count CURSOR FOR i304_precount
 
END FUNCTION
 
FUNCTION i304_menu()
 
   WHILE TRUE
      CALL i304_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i304_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i304_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i304_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i304_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
        #No.FUN-6A0163-------add--------str----
         WHEN "related_document"                 #相關文件
          IF cl_chk_act_auth() THEN
             IF g_vme01 IS NOT NULL THEN
                LET g_doc.column1 = "vme01"
                LET g_doc.column2 = "vme02"
                LET g_doc.value1 = g_vme01
                LET g_doc.value2 = g_vme02
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0163-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i304_a()
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_vme01   LIKE  vme_file.vme01
    INITIALIZE g_vme02    LIKE  vme_file.vme02
    LET g_vme01_t  = NULL
    LET g_vme02_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i304_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_vme01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b=0                               #No.FUN-680064
        IF g_ss='N' THEN
           CALL g_vme.clear()
        ELSE
            CALL i304_b_fill('1=1')         #單身
        END IF
        CALL i304_b()                   #輸入單身
        LET g_vme01_t = g_vme01
        LET g_vme02_t = g_vme02
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i304_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-690010  SMALLINT
    l_str           LIKE type_file.chr50    #No.FUN-690010  VARCHAR(40)
 
    LET g_ss='Y'
 
    DISPLAY g_vme01 TO vme01
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
    INPUT g_vme01 WITHOUT DEFAULTS
         FROM vme01
 
        AFTER FIELD vme01                   #設備群組編號
            IF cl_null(g_vme01) THEN
                NEXT FIELD vme01
            END IF
 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i304_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vme01 TO NULL           #No.FUN-6A0163
    INITIALIZE g_vme02 TO NULL            #No.FUN-6A0163
    CALL cl_opmsg('q')
    MESSAGE ""    
    CALL g_vme.clear()                #No.FUN-6A0163
    CLEAR FORM    
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i304_cs()                        #取得查詢條件
    IF INT_FLAG THEN                      #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_vme01 TO NULL
        INITIALIZE g_vme02 TO NULL        #No.FUN-6A0163
        RETURN
    END IF
    OPEN i304_bcs                 #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vme01 TO NULL
        INITIALIZE g_vme02 TO NULL
    ELSE
        OPEN i304_count
        FETCH i304_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i304_fetch('F')                        #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i304_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690010 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i304_bcs INTO g_vme01
        WHEN 'P' FETCH PREVIOUS i304_bcs INTO g_vme01
        WHEN 'F' FETCH FIRST    i304_bcs INTO g_vme01
        WHEN 'L' FETCH LAST     i304_bcs INTO g_vme01
        WHEN '/'
         IF (NOT g_no_ask) THEN  #No.TQC-720019
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
#           PROMPT g_msg CLIPPED,': ' FOR l_abso  #No.TQC-720019
            PROMPT g_msg CLIPPED,': ' FOR g_jump  #No.TQC-720019
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
           END IF   #No.TQC-720019
#          FETCH ABSOLUTE l_abso i304_bcs INTO g_vme01  #No.TQC-720019
           FETCH ABSOLUTE g_jump i304_bcs INTO g_vme01
           LET g_no_ask = FALSE  #No.TQC-720019
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_vme01,SQLCA.sqlcode,0)
        INITIALIZE g_vme01 TO NULL  #TQC-6B0105
    ELSE
        CALL i304_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
#         WHEN '/' LET g_curs_index = l_abso  #No.TQC-720019
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i304_r()
  DEFINE l_n      LIKE type_file.num5       #No.FUN-690010 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_vme01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    CALL i304_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vme01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vme02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vme01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vme02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM vme_file WHERE vme01 = g_vme01
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i304_precount_x                  #No.TQC-720019
         PREPARE i304_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i304_precount_x2                 #No.TQC-720019
         CALL g_vme.clear()
         OPEN i304_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i304_bcs
            CLOSE i304_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i304_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i304_bcs
            CLOSE i304_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         #No.TQC-720019  --Begin
#        CALL i304_fetch('F')
         OPEN i304_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i304_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE        #No.FUN-6A0057 g_no_ask 
            CALL i304_fetch('/')
         END IF
         #No.TQC-720019  --End  
         #MOD-5A0004 end
 
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i304_show()
 
    DISPLAY g_vme01            #單頭
         TO vme01
    CALL i304_b_fill(g_wc)          #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i304_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否           #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否           #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF g_vme01 IS NULL OR g_vme01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vme02,'' FROM vme_file ",
                       " WHERE vme01 = ? AND vme02 = ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i304_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_vme WITHOUT DEFAULTS FROM s_vme.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
 
               BEGIN WORK
               LET g_vme_t.* = g_vme[l_ac].*  #BACKUP
 
               LET p_cmd='u'
 
               OPEN i304_bcl USING g_vme01,g_vme_t.vme02
               IF STATUS THEN
                  CALL cl_err("OPEN i304_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i304_bcl INTO g_vme[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_vme_t.vme02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vme_t.*=g_vme[l_ac].*
                  END IF
               END IF
               CALL i304_vme02('d',g_vme[l_ac].vme02)
                    RETURNING g_vme[l_ac].eci06
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
            NEXT FIELD vme02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vme[l_ac].* TO NULL            #900423
            LET g_vme_t.* = g_vme[l_ac].*               #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vme02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO vme_file(vme01,vme02)
                         VALUES(g_vme01,g_vme[l_ac].vme02)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_vme[l_ac].vme02,SQLCA.sqlcode,0) #No.FUN-660095
               CALL cl_err3("ins","vme_file",g_vme01,g_vme[l_ac].vme02,SQLCA.sqlcode,"","",1)  # Fun - 660095
               LET g_vme[l_ac].* = g_vme_t.*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
         AFTER FIELD vme02
            IF NOT cl_null(g_vme[l_ac].vme02) THEN
               IF g_vme_t.vme02 IS NULL OR
                  (g_vme_t.vme02 != g_vme[l_ac].vme02) THEN
                  CALL i304_vme02('a',g_vme[l_ac].vme02)
                       RETURNING g_vme[l_ac].eci06
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_vme[l_ac].vme02,g_errno,0)
                     LET g_vme[l_ac].vme02 = g_vme_t.vme02
                     NEXT FIELD vme02
                  END IF
               END IF
               IF g_vme[l_ac].vme02 != g_vme_t.vme02 OR
                  g_vme_t.vme02 IS NULL  THEN
                  SELECT COUNT(*) INTO l_n FROM vme_file
                   WHERE vme01 = g_vme01
                     AND vme02 = g_vme[l_ac].vme02
                  IF l_n > 0 THEN
                     CALL cl_err(g_vme[l_ac].vme02,-239,0)
                     LET g_vme[l_ac].vme02 = g_vme_t.vme02
                     NEXT FIELD vme02
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_vme_t.vme02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vme_file
                 WHERE vme01 = g_vme01
                   AND  vme02 = g_vme_t.vme02
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err(g_vme_t.vme02,SQLCA.sqlcode,0) #No.FUN-660095
                   CALL cl_err3("del","vme_file",g_vme01,g_vme_t.vme02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
display "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vme[l_ac].* = g_vme_t.*
               CLOSE i304_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vme[l_ac].vme02,-263,1)
               LET g_vme[l_ac].* = g_vme_t.*
            ELSE
               UPDATE vme_file SET vme02 =g_vme[l_ac].vme02
                WHERE vme01 = g_vme01
                  AND vme02 = g_vme_t.vme02
               IF SQLCA.sqlcode THEN
  #                CALL cl_err(g_vme[l_ac].vme02,SQLCA.sqlcode,0) #No.FUN-660095
                  CALL cl_err3("upd","vme_file",g_vme01,g_vme_t.vme02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                  LET g_vme[l_ac].* = g_vme_t.*
                  ROLLBACK WORK
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
                  LET g_vme[l_ac].* = g_vme_t.*
               END IF
               CLOSE i304_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i304_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i304_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vme02) AND l_ac > 1 THEN
                LET g_vme[l_ac].* = g_vme[l_ac-1].*
                DISPLAY g_vme[l_ac].* TO s_vme[l_ac].*
                NEXT FIELD vme02
            END IF
 
        ON ACTION controlp
            IF INFIELD(vme02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eci"
               LET g_qryparam.default1 = g_vme[l_ac].vme02
               CALL cl_create_qry() RETURNING g_vme[l_ac].vme02
#               CALL FGL_DIALOG_SETBUFFER( g_vme[l_ac].vme02 )
#               CALL fgl_dialog_setbuffer(g_vme[l_ac].vme02)
               NEXT FIELD vme02
            END IF
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
    CLOSE i304_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i304_vme02(p_cmd,l_vme02)  #設備編號
    DEFINE l_eci06   LIKE eci_file.eci06,
           l_vme02   LIKE vme_file.vme02,
           p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_errno = ''
    SELECT eci06 INTO l_eci06 FROM eci_file
     WHERE eci01 = l_vme02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-007'
                                   LET l_eci06 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_eci06
 
END FUNCTION
 
FUNCTION i304_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc ON vme02   #螢幕上取條件
       FROM s_vme[1].vme02
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
    IF INT_FLAG THEN RETURN END IF
    CALL i304_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i304_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
       "SELECT vme02,eci06,'' ",
       " FROM vme_file,eci_file ",
       " WHERE vme01 = '",g_vme01,"'",
       "   AND vme02= eci01 ",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1 "
    PREPARE i304_prepare2 FROM g_sql      #預備一下
    DECLARE tro_cs CURSOR FOR i304_prepare2
 
    CALL g_vme.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH tro_cs INTO g_vme[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL i304_vme02('d',g_vme[g_cnt].vme02)
             RETURNING g_vme[g_cnt].eci06
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_vme.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i304_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vme TO s_vme.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i304_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i304_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i304_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i304_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i304_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION related_document                #No.FUN-6A0163  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610036 <001,002> #
