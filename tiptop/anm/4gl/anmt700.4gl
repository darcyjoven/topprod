# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: anmt700.4gl
# Descriptions...: 融資貸款備註說明維護作業
# Date & Author..: 00/07/10 by Brendan
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-940033 09/04/03 By Sarah 1.b()段判斷g_nnb01有沒有值前,應先將g_argv1與g_argv2的值給予g_nnb01與g_nnb02
#                                                  2.cs()段應抓nnb01與nnb02
# Modify.........: No.TQC-960048 09/06/12 By xiaofeizhu 修改查詢時的筆數問題
# Modify.........: No.TQC-970088 09/07/08 By wujie  單身無法修改
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_nnb01         LIKE nnb_file.nnb01,   #相關單號 (假單頭)
    g_nnb01_t       LIKE nnb_file.nnb01,   #相關單號   (舊值)
    g_nnb02         LIKE nnb_file.nnb02,   #資料性質
    g_nnb02_t       LIKE nnb_file.nnb02,   #資料性質
    l_cnt           LIKE type_file.num5,          #No.FUN-680107 SMALLINT
    l_cnt1          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(100)
    g_nnb           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        nnb03       LIKE nnb_file.nnb03,      #行序
        nnb04       LIKE nnb_file.nnb04       #說明
                    END RECORD,
    g_nnb_t         RECORD                    #程式變數 (舊值)
        nnb03       LIKE nnb_file.nnb03,      #行序
        nnb04       LIKE nnb_file.nnb04       #說明
                    END RECORD,
    g_nnb04_o       LIKE nnb_file.nnb04,
    g_wc,g_wc2,g_sql STRING   ,  #No.FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680107 SMALLINT
    g_ss            LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(1)
    g_argv1         LIKE nnb_file.nnb01,
    g_argv2         LIKE nnb_file.nnb02,
    l_za05          LIKE type_file.chr1000,     #        #No.FUN-680107 VARCHAR(40)
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT        #No.FUN-680107 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING        #SELECT ... FOR UPDATE SQL       
DEFINE   g_cnt      LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_msg      LIKE ze_file.ze03        #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680107 SMALLINT
MAIN
#DEFINE
#       l_time   LIKE type_file.chr8              #No.FUN-6A0082
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
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
   LET g_nnb01 = NULL                     #清除鍵值
   LET g_nnb01_t = NULL
   INITIALIZE g_nnb_t.* TO NULL
   #取得參數
   LET g_argv1=ARG_VAL(1)       #合約號碼
   LET g_argv2=ARG_VAL(2)       #合約號碼
   LET p_row = 3 LET p_col = 18
    OPEN WINDOW t700_w AT p_row,p_col
      WITH FORM "anm/42f/anmt700"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_nnb01 = g_argv1
    LET g_nnb02 = g_argv2
    IF NOT cl_null(g_argv1) THEN
       CALL t700_q()
    END IF
    CALL t700_menu()
    CLOSE WINDOW t700_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
#QBE 查詢資料
FUNCTION t700_cs()
 
   IF not cl_null(g_argv1) THEN
      LET g_wc=" nnb01='",g_argv1,"' AND nnb02='",g_argv2 CLIPPED,"' "
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_nnb.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nnb01 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON nnb01,nnb03,nnb04    #螢幕上取條件
           FROM nnb01,s_nnb[1].nnb03,s_nnb[1].nnb04
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   # 組合出 SQL 指令
   LET g_sql="SELECT UNIQUE nnb01,nnb02 FROM nnb_file ",   #MOD-940033 add nnb02
              " WHERE ", g_wc CLIPPED,
              " ORDER BY nnb01,nnb02"   #MOD-940033 add nnb02
   PREPARE t700_prepare FROM g_sql                            #預備一下
   DECLARE t700_bcs SCROLL CURSOR WITH HOLD FOR t700_prepare  #宣告成可捲動的
 
   #因主鍵值有兩個故所抓出資料筆數有誤
   #TQC-960048--Mark--Begin--#
#  DROP TABLE x
 
#  LET g_sql="SELECT DISTINCT nnb01",
#            " FROM nnb_file WHERE ", g_wc CLIPPED," INTO TEMP x"
#  PREPARE t700_precount FROM g_sql
#  DECLARE t700_count CURSOR FOR  t700_precount
   #TQC-960048--Mark--End--#
   #TQC-960048--Add-Begin--#
   LET g_sql="SELECT UNIQUE nnb01,nnb02 FROM nnb_file ",   
              " WHERE ", g_wc CLIPPED,
              " ORDER BY nnb01,nnb02"   
   PREPARE t700_precount FROM g_sql                            
   DECLARE t700_bcs1 CURSOR FOR  t700_precount   
   #TQC-960048--Add-End--#   
 
END FUNCTION
 
FUNCTION t700_menu()
 
   WHILE TRUE
      CALL t700_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnb),'','')
            END IF
         #No.FUN-6A0011---------add---------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nnb01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnb01"
                 LET g_doc.value1 = g_nnb01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011---------add---------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t700_q()
DEFINE l_nnb01  LIKE nnb_file.nnb01,
       l_nnb02  LIKE nnb_file.nnb02,
       l_cnt    LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nnb01 TO NULL              #No.FUN-6A0011
    INITIALIZE g_nnb02 TO NULL              #No.FUN-6A0011
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t700_cs()                           #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_nnb01 TO NULL
      INITIALIZE g_nnb02 TO NULL
      RETURN
   END IF
   OPEN t700_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nnb01 TO NULL
      INITIALIZE g_nnb02 TO NULL
   ELSE      
#TQC-960048--Mark--Begin--#   	
#     CALL t700_fetch('F')            #讀出TEMP第一筆並顯示        
#     FOREACH t700_count INTO l_nnb01
#         LET g_row_count = g_row_count + 1
#     END FOREACH
#     FETCH t700_count INTO g_row_count
#TQC-960048--Mark--End--#      
      #TQC-960048--Begin--#
      LET l_cnt = 0 
      FOREACH t700_bcs1 INTO l_nnb01,l_nnb02
          LET l_cnt = l_cnt + 1   
      END FOREACH
      LET g_row_count = l_cnt
      #TQC-960048--End--#
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t700_fetch('F')            #讀出TEMP第一筆並顯示        #TQC-960048      
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t700_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t700_bcs INTO g_nnb01,g_nnb02   #MOD-940033 add g_nnb02
      WHEN 'P' FETCH PREVIOUS t700_bcs INTO g_nnb01,g_nnb02   #MOD-940033 add g_nnb02
      WHEN 'F' FETCH FIRST    t700_bcs INTO g_nnb01,g_nnb02   #MOD-940033 add g_nnb02
      WHEN 'L' FETCH LAST     t700_bcs INTO g_nnb01,g_nnb02   #MOD-940033 add g_nnb02
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
            FETCH ABSOLUTE g_jump t700_bcs INTO g_nnb01,g_nnb02   #MOD-940033 add g_nnb02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nnb01,SQLCA.sqlcode,0)
      INITIALIZE g_nnb01 TO NULL  #TQC-6B0105
      INITIALIZE g_nnb02 TO NULL  #MOD-940033 add
     #str MOD-940033 add
      IF NOT cl_null(g_argv1) THEN
         DISPLAY g_argv1 TO nnb01
      END IF
     #end MOD-940033 add
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
      CALL t700_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t700_show()
   IF NOT cl_null(g_argv1) THEN
      DISPLAY g_argv1 TO nnb01      #單頭
   ELSE
      DISPLAY g_nnb01 TO nnb01      #單頭
   END IF
   CALL t700_b_fill(g_wc)           #單身
   CALL cl_show_fld_cont()          #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t700_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680107 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF                #檢查權限 
   IF cl_null(g_nnb01) THEN     #No.TQC-970088
      LET g_nnb01 = g_argv1   #MOD-940033 mod
      LET g_nnb02 = g_argv2   #MOD-940033 mod
   END IF    #No.TQC-970088
   IF g_nnb01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nnb03,nnb04 FROM nnb_file",
                      " WHERE nnb01=? AND nnb02=? AND nnb03=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nnb WITHOUT DEFAULTS FROM s_nnb.*
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
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nnb_t.* = g_nnb[l_ac].*      #BACKUP
            BEGIN WORK
            OPEN t700_bcl USING g_nnb01,g_nnb02,g_nnb_t.nnb03
            IF STATUS THEN
               CALL cl_err("OPEN t700_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t700_bcl INTO g_nnb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nnb_t.nnb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_nnb[l_ac].* TO NULL      #900423
          LET g_nnb_t.* = g_nnb[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD nnb03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO nnb_file (nnb01,nnb02,nnb03,nnb04,nnblegal)  #No.MOD-470041  #FUN-980005 add legal 
              VALUES(g_nnb01,g_nnb02,g_nnb[l_ac].nnb03,g_nnb[l_ac].nnb04,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nnb[l_ac].nnb03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nnb_file",g_nnb01,g_nnb02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD nnb03                        #default 序號
         IF cl_null(g_nnb[l_ac].nnb03) OR g_nnb[l_ac].nnb03 = 0 THEN
            SELECT max(nnb03)+1 INTO g_nnb[l_ac].nnb03
              FROM nnb_file
            WHERE nnb01 = g_nnb01 AND nnb02 = g_nnb02
            IF cl_null(g_nnb[l_ac].nnb03) THEN
               LET g_nnb[l_ac].nnb03 = 1
            END IF
         END IF
 
      AFTER FIELD nnb03                        #check 序號是否重複
         IF NOT cl_null(g_nnb[l_ac].nnb03) THEN
            IF g_nnb[l_ac].nnb03 != g_nnb_t.nnb03 OR cl_null(g_nnb_t.nnb03) THEN
               SELECT count(*) INTO l_n FROM nnb_file
                WHERE nnb01 = g_nnb01
                  AND nnb02 = g_nnb02
                  AND nnb03 = g_nnb[l_ac].nnb03
               IF l_n > 0 THEN
                  CALL cl_err(g_nnb[l_ac].nnb03,-239,0)
                  LET g_nnb[l_ac].nnb03 = g_nnb_t.nnb03
                  NEXT FIELD nnb03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_nnb_t.nnb03 > 0 AND g_nnb_t.nnb03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nnb_file
             WHERE nnb01 = g_nnb01
               AND nnb02 = g_nnb02
               AND nnb03 = g_nnb_t.nnb03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnb_t.nnb03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nnb_file",g_nnb01,g_nnb_t.nnb03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nnb[l_ac].* = g_nnb_t.*
            CLOSE t700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nnb[l_ac].nnb03,-263,1)
            LET g_nnb[l_ac].* = g_nnb_t.*
         ELSE
            UPDATE nnb_file SET nnb03 = g_nnb[l_ac].nnb03,
                                nnb04 = g_nnb[l_ac].nnb04
             WHERE nnb01=g_nnb01
               AND nnb02=g_nnb02
               AND nnb03=g_nnb_t.nnb03
            IF SQLCA.sqlcode THEN
#              CALL cl_err('update',SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nnb_file",g_nnb01,g_nnb_t.nnb03,SQLCA.sqlcode,"","update",1)  #No.FUN-660148
               LET g_nnb[l_ac].* = g_nnb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
      #   LET l_ac_t = l_ac     #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nnb[l_ac].* = g_nnb_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_nnb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE t700_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D30032 add 
          CLOSE t700_bcl
          COMMIT WORK
 
#     ON ACTION CONTROLN
#         CALL t700_b_askkey()
#         EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nnb03) AND l_ac > 1 THEN
            LET g_nnb[l_ac].* = g_nnb[l_ac-1].*
            LET g_nnb[l_ac].nnb03 = NULL   #TQC-620018
            DISPLAY g_nnb[l_ac].* TO s_nnb[l_ac].*
            NEXT FIELD nnb03
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END INPUT
 
   CLOSE t700_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t700_b_askkey()
DEFINE
   l_wc            LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT l_wc ON nnb03,nnb04             #螢幕上取條件
        FROM s_nnb[1].nnb03,s_nnb[1].nnb04
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
   IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
   CALL t700_b_fill(l_wc)
END FUNCTION
 
FUNCTION t700_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(200) #TQC-840066
 
   LET g_sql = "SELECT nnb03,nnb04 FROM nnb_file ",
               " WHERE nnb01 = '",g_nnb01,"' AND nnb02 = '",g_nnb02,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE t700_prepare2 FROM g_sql      #預備一下
   DECLARE nnb_cs CURSOR FOR t700_prepare2
 
   CALL g_nnb.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH nnb_cs INTO g_nnb[g_cnt].*   #單身 ARRAY 填充
      LET g_cnt = g_cnt + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #-----TQC-630104---------      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #-----END TQC-630104-----
   END FOREACH
 
   CALL g_nnb.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnb TO s_nnb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t700_fetch('L')
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
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
 
 
#Patch....NO.TQC-610036 <001> #
