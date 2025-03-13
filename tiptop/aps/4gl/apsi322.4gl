# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi322.4gl
# Descriptions...: 設備群組資料維護作業(工作站)
# Date & Author..: FUN-850114 07/12/26 BY Yiting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_vmp01            LIKE vmp_file.vmp01,   #設備群組編號(假單頭)   #FUN-850114
    g_vmp01_t          LIKE vmp_file.vmp01,   #設備群組編號(舊值)
    g_vmp02            LIKE vmp_file.vmp02,   #設備編號
    g_vmp02_t          LIKE vmp_file.vmp02,   #設備編號
    g_vmp         DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        vmp02          LIKE vmp_file.vmp02,   #設備編號
        eca02          LIKE eca_file.eca02    #標籤編號
                       END RECORD,
    g_vmp_t       RECORD                 #程式變數 (舊值)
        vmp02          LIKE vmp_file.vmp02,   #OJT代號
        eca02          LIKE eca_file.eca02   #OJT課程說明
                       END RECORD,
    g_wc,g_sql,g_wc2   string,  #No.FUN-580092 HCN
    g_argv1         LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)      #資料性質
    g_argv2         LIKE type_file.chr20,    #No.FUN-690010 VARCHAR(10),    #單號
    g_argv3         LIKE type_file.num5,     #No.FUN-690010 SMALLINT,    #項次
    g_show          LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1),
    g_rec_b         LIKE type_file.num5,     #單身筆數                   #No.FUN-690010 SMALLINT
    g_flag          LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)
    g_ss            LIKE type_file.chr1,     #No.FUN-690010 VARCHAR(1)
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-690010 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_jump               LIKE type_file.num10   #No.TQC-720019
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
 
 
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
MAIN
DEFINE
    l_time        LIKE type_file.chr8,    #計算被使用時間  #No.FUN-690010 VARCHAR(8)
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
 
 
      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
    LET p_row = 5 LET p_col = 25
 
    OPEN WINDOW i322_w AT p_row,p_col WITH FORM "aps/42f/apsi322"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL i322_menu()
 
    CLOSE WINDOW i322_w                 #結束畫面
      CALL cl_used(g_prog,l_time,2)  #No.MOD-580088  HCN 20050818
         RETURNING l_time
END MAIN
 
#QBE 查詢資料
FUNCTION i322_cs()
    CLEAR FORM 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032                            #清除畫面
   INITIALIZE g_vmp01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON vmp01,vmp02 FROM vmp01,s_vmp[1].vmp02
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            IF INFIELD(vmp02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_eca1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO vmp02
               NEXT FIELD vmp02
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
 
    LET g_sql= "SELECT UNIQUE vmp01 FROM vmp_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i322_prepare FROM g_sql      #預備一下
    DECLARE i322_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i322_prepare
 
#   LET g_sql = "SELECT UNIQUE vmp01 FROM vmp_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE vmp01 FROM vmp_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i322_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i322_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i322_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i322_precount FROM g_sql
    DECLARE i322_count CURSOR FOR i322_precount
 
END FUNCTION
 
FUNCTION i322_menu()
 
   WHILE TRUE
      CALL i322_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i322_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i322_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i322_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i322_b()
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
             IF g_vmp01 IS NOT NULL THEN
                LET g_doc.column1 = "vmp01"
                LET g_doc.column2 = "vmp02"
                LET g_doc.value1 = g_vmp01
                LET g_doc.value2 = g_vmp02
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0163-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i322_a()
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_vmp01   LIKE  vmp_file.vmp01
    INITIALIZE g_vmp02    LIKE  vmp_file.vmp02
    LET g_vmp01_t  = NULL
    LET g_vmp02_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i322_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_vmp01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b=0                               #No.FUN-680064
        IF g_ss='N' THEN
           CALL g_vmp.clear()
        ELSE
            CALL i322_b_fill('1=1')         #單身
        END IF
        CALL i322_b()                   #輸入單身
        LET g_vmp01_t = g_vmp01
        LET g_vmp02_t = g_vmp02
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i322_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-690010  SMALLINT
    l_str           LIKE type_file.chr50    #No.FUN-690010  VARCHAR(40)
 
    LET g_ss='Y'
 
    DISPLAY g_vmp01 TO vmp01
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
    INPUT g_vmp01 WITHOUT DEFAULTS
         FROM vmp01
 
        AFTER FIELD vmp01                   #設備群組編號
            IF cl_null(g_vmp01) THEN
                NEXT FIELD vmp01
            END IF
 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i322_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vmp01 TO NULL           #No.FUN-6A0163
    INITIALIZE g_vmp02 TO NULL            #No.FUN-6A0163
    CALL cl_opmsg('q')
    MESSAGE ""    
    CALL g_vmp.clear()                #No.FUN-6A0163
    CLEAR FORM    
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i322_cs()                        #取得查詢條件
    IF INT_FLAG THEN                      #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_vmp01 TO NULL
        INITIALIZE g_vmp02 TO NULL        #No.FUN-6A0163
        RETURN
    END IF
    OPEN i322_bcs                 #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vmp01 TO NULL
        INITIALIZE g_vmp02 TO NULL
    ELSE
        OPEN i322_count
        FETCH i322_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i322_fetch('F')                        #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i322_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690010 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i322_bcs INTO g_vmp01
        WHEN 'P' FETCH PREVIOUS i322_bcs INTO g_vmp01
        WHEN 'F' FETCH FIRST    i322_bcs INTO g_vmp01
        WHEN 'L' FETCH LAST     i322_bcs INTO g_vmp01
        WHEN '/'
         IF (NOT mi_no_ask) THEN  #No.TQC-720019
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
#          FETCH ABSOLUTE l_abso i322_bcs INTO g_vmp01  #No.TQC-720019
           FETCH ABSOLUTE g_jump i322_bcs INTO g_vmp01
           LET mi_no_ask = FALSE  #No.TQC-720019
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_vmp01,SQLCA.sqlcode,0)
        INITIALIZE g_vmp01 TO NULL  #TQC-6B0105
    ELSE
        CALL i322_show()
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
FUNCTION i322_r()
  DEFINE l_n      LIKE type_file.num5       #No.FUN-690010 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_vmp01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    CALL i322_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmp01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vmp02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmp01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vmp02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM vmp_file WHERE vmp01 = g_vmp01
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i322_precount_x                  #No.TQC-720019
         PREPARE i322_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i322_precount_x2                 #No.TQC-720019
         CALL g_vmp.clear()
         OPEN i322_count
         FETCH i322_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         #No.TQC-720019  --Begin
#        CALL i322_fetch('F')
         OPEN i322_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i322_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE        #No.FUN-6A0057 g_no_ask 
            CALL i322_fetch('/')
         END IF
         #No.TQC-720019  --End  
         #MOD-5A0004 end
 
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i322_show()
 
    DISPLAY g_vmp01            #單頭
         TO vmp01
    CALL i322_b_fill(g_wc)          #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i322_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否           #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否           #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF g_vmp01 IS NULL OR g_vmp01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vmp02,'' FROM vmp_file ",
                       " WHERE vmp01 = ? AND vmp02 = ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i322_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_vmp WITHOUT DEFAULTS FROM s_vmp.*
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
               LET g_vmp_t.* = g_vmp[l_ac].*  #BACKUP
 
               LET p_cmd='u'
 
               OPEN i322_bcl USING g_vmp01,g_vmp_t.vmp02
               IF STATUS THEN
                  CALL cl_err("OPEN i322_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i322_bcl INTO g_vmp[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_vmp_t.vmp02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vmp_t.*=g_vmp[l_ac].*
                  END IF
               END IF
               CALL i322_vmp02('d',g_vmp[l_ac].vmp02)
                    RETURNING g_vmp[l_ac].eca02
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
            NEXT FIELD vmp02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vmp[l_ac].* TO NULL            #900423
            LET g_vmp_t.* = g_vmp[l_ac].*               #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vmp02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO vmp_file(vmp01,vmp02)
                         VALUES(g_vmp01,g_vmp[l_ac].vmp02)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_vmp[l_ac].vmp02,SQLCA.sqlcode,0) #No.FUN-660095
               CALL cl_err3("ins","vmp_file",g_vmp01,g_vmp[l_ac].vmp02,SQLCA.sqlcode,"","",1)  # Fun - 660095
               LET g_vmp[l_ac].* = g_vmp_t.*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
         AFTER FIELD vmp02
            IF NOT cl_null(g_vmp[l_ac].vmp02) THEN
               IF g_vmp_t.vmp02 IS NULL OR
                  (g_vmp_t.vmp02 != g_vmp[l_ac].vmp02) THEN
                  CALL i322_vmp02('a',g_vmp[l_ac].vmp02)
                       RETURNING g_vmp[l_ac].eca02
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_vmp[l_ac].vmp02,g_errno,0)
                     LET g_vmp[l_ac].vmp02 = g_vmp_t.vmp02
                     NEXT FIELD vmp02
                  END IF
               END IF
               IF g_vmp[l_ac].vmp02 != g_vmp_t.vmp02 OR
                  g_vmp_t.vmp02 IS NULL  THEN
                  SELECT COUNT(*) INTO l_n FROM vmp_file
                   WHERE vmp01 = g_vmp01
                     AND vmp02 = g_vmp[l_ac].vmp02
                  IF l_n > 0 THEN
                     CALL cl_err(g_vmp[l_ac].vmp02,-239,0)
                     LET g_vmp[l_ac].vmp02 = g_vmp_t.vmp02
                     NEXT FIELD vmp02
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_vmp_t.vmp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vmp_file
                 WHERE vmp01 = g_vmp01
                   AND  vmp02 = g_vmp_t.vmp02
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err(g_vmp_t.vmp02,SQLCA.sqlcode,0) #No.FUN-660095
                   CALL cl_err3("del","vmp_file",g_vmp01,g_vmp_t.vmp02,SQLCA.sqlcode,"","",1)  # Fun - 660095
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
               LET g_vmp[l_ac].* = g_vmp_t.*
               CLOSE i322_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vmp[l_ac].vmp02,-263,1)
               LET g_vmp[l_ac].* = g_vmp_t.*
            ELSE
               UPDATE vmp_file SET vmp02 =g_vmp[l_ac].vmp02
                WHERE vmp01 = g_vmp01
                  AND vmp02 = g_vmp_t.vmp02
               IF SQLCA.sqlcode THEN
  #                CALL cl_err(g_vmp[l_ac].vmp02,SQLCA.sqlcode,0) #No.FUN-660095
                  CALL cl_err3("upd","vmp_file",g_vmp01,g_vmp_t.vmp02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                  LET g_vmp[l_ac].* = g_vmp_t.*
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
                  LET g_vmp[l_ac].* = g_vmp_t.*
               END IF
               CLOSE i322_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i322_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i322_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vmp02) AND l_ac > 1 THEN
                LET g_vmp[l_ac].* = g_vmp[l_ac-1].*
                DISPLAY g_vmp[l_ac].* TO s_vmp[l_ac].*
                NEXT FIELD vmp02
            END IF
 
        ON ACTION controlp
            IF INFIELD(vmp02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eca1"
               LET g_qryparam.default1 = g_vmp[l_ac].vmp02
               CALL cl_create_qry() RETURNING g_vmp[l_ac].vmp02
               NEXT FIELD vmp02
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
 
    CLOSE i322_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i322_vmp02(p_cmd,l_vmp02)  #設備編號
    DEFINE l_eca02   LIKE eca_file.eca02,
           l_vmp02   LIKE vmp_file.vmp02,
           p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_errno = ''
    SELECT eca02 INTO l_eca02 FROM eca_file
     WHERE eca01 = l_vmp02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-007'
                                   LET l_eca02 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_eca02
 
END FUNCTION
 
FUNCTION i322_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc ON vmp02   #螢幕上取條件
       FROM s_vmp[1].vmp02
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
    CALL i322_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i322_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
       "SELECT vmp02,eca02,'' ",
       " FROM vmp_file,eca_file ",
       " WHERE vmp01 = '",g_vmp01,"'",
       "   AND vmp02= eca01 ",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1 "
    PREPARE i322_prepare2 FROM g_sql      #預備一下
    DECLARE tro_cs CURSOR FOR i322_prepare2
 
    CALL g_vmp.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH tro_cs INTO g_vmp[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL i322_vmp02('d',g_vmp[g_cnt].vmp02)
             RETURNING g_vmp[g_cnt].eca02
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_vmp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i322_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vmp TO s_vmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i322_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i322_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i322_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i322_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i322_fetch('L')
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
      # Specaal 4ad ACTION
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
