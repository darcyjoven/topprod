# Prog. Version..: '5.30.07-13.05.16(00010)'     #
#
# Pattern name...: p_zy2.4gl
# Descriptions...: 程式列印方式權限維護作業
# Date & Author..: 03/07/12 yen
# Memo...........: 修改方式:1,$s/dsz.4gl/dsz_r.4gl/g    (Change Global file name)
#                          :1,$s/dsz/xxx/g              (Change system name)
#                          :1,$s/p_zy2/xxxx/g           (Change system name)
# Modify.........: No.FUN-510050 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-530267 05/03/25 By alex 抓取程式名稱改到 gaz_file
# Modify.........: No.MOD-560212 05/08/04 By alex 新增判斷此群組是否已失效,失效則不改
# Modify.........: No.FUN-580069 05/08/12 By alex 抓取傳入變數並改作 ATTRIBUTE
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-620091 06/03/06 By Echo 抓取程式名稱改為 CALL cl_get_progname()，另外修改顯示單身筆數(cn2)
# Modify.........: No.FUN-630099 06/03/31 By Echo 將原先填註 1234AOUT等代碼的方式改為參照 action 方式，讓使用者勾選
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0023 06/11/22 By jacklai p_zy2_prt新增vprint選項
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-660179 07/01/04 By Echo 報表輸出新增callviewer功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-770002 07/07/05 By jacklai 新增 Crystal Report 匯出的權限控管功能
# Modify.........: No.TQC-780047 07/08/15 By Smapmin 程式名稱改抓gaz_file
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A80035 11/05/23 By jacklai 新增匯出Excel(Data Only)權限
# Modify.........: No:FUN-C60029 12/06/09 By janet 程式代號屬於GR報表時，隱藏不屬於GR輸出格式的選項
# Modify.........: No:FUN-C20037 12/06/14 By jacklai CR新增N選項:無任何匯出權限
# Modify.........: No:FUN-C70120 12/08/21 By janet 增加GR選項
# Modify.........: No:FUN-D20057 12/03/01 By odyliao 增加XtraGrid的判斷 
# Modify.........: No:FUN-D40059 13/04/29 By odyliao XtraGrid報表選項增加 XLSX和CSV選項，並修正相關判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_zy01         LIKE zy_file.zy01,         #類別代號 (假單頭)
          g_zy01_t       LIKE zy_file.zy01,         #類別代號 (舊值)
          g_zy           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
              zy02       LIKE zy_file.zy02,         #程式代號
              gaz03      LIKE gaz_file.gaz03,       #程式名稱  #MOD-530267
              zy06       LIKE zy_file.zy06          #允許列印方式
                          END RECORD,
          g_zy_t         RECORD                     #程式變數 (舊值)
              zy02       LIKE zy_file.zy02,         #程式代號
              gaz03      LIKE gaz_file.gaz03,       #程式名稱  #MOD-530267
              zy06       LIKE zy_file.zy06          #允許列印方式
                          END RECORD,
           g_wc              STRING,                #MOD-530267
           g_sql             STRING,                #MOD-530267
          g_ss              LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680135 VARCHAR(1)
          g_rec_b           LIKE type_file.num5,    #單身筆數     #No.FUN-680135 SMALLINT
          l_ac              LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
   DEFINE g_forupd_sql      STRING                  #SELECT ... FOR UPDATE SQL
   DEFINE g_chr             LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   DEFINE g_cnt             LIKE type_file.num10    #No.FUN-680135 INTEGER
   DEFINE g_i               LIKE type_file.num5     #count/index for any purpose  #No.FUN-680135 SMALLINT
   DEFINE g_msg             LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
   DEFINE g_curs_index      LIKE type_file.num10    #No.FUN-680135 INTEGER
   DEFINE g_row_count       LIKE type_file.num10    #No.FUN-680135 INTEGER
   DEFINE g_jump            LIKE type_file.num10,   #No.FUN-680135 INTEGER
          g_no_ask         LIKE type_file.num5     #No.FUN-680135 SMALLINT #FUN-6A0080
   DEFINE g_argv1           LIKE zy_file.zy01       #FUN-580069
 
MAIN
   OPTIONS                                          #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)                           #若有傳入群組名則接收  FUN-580069
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_zy01 = NULL                     #清除鍵值
   LET g_zy01_t = NULL
 
   OPEN WINDOW p_zy2_w WITH FORM "azz/42f/p_zy2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_zy2_q()
   END IF

   CALL p_zy2_menu()
 
   CLOSE WINDOW p_zy2_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p_zy2_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_zy.clear()
 
   #FUN-580069
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "zy01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      CONSTRUCT g_wc ON zy01,zy02,zy06 FROM zy01,s_zy[1].zy02,s_zy[1].zy06
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
                CASE  # MOD-490292
                  WHEN INFIELD(zy01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zw"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_zy01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO zy01
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
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zyuser', 'zygrup') #FUN-980030
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE zy01 FROM zy_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   PREPARE p_zy2_prepare FROM g_sql      #預備一下
   DECLARE p_zy2_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_zy2_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT zy01) FROM zy_file WHERE ",g_wc CLIPPED
   PREPARE p_zy2_precount FROM g_sql
   DECLARE p_zy2_count CURSOR FOR p_zy2_precount
 
END FUNCTION
 
FUNCTION p_zy2_menu()
 
   WHILE TRUE
      CALL p_zy2_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy2_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy2_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN 
               CALL p_zy2_out() 
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION  p_zy2_zy01(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
   l_zw02          LIKE zw_file.zw02,
   l_zwacti        LIKE zw_file.zwacti          #資料有效碼
 
   LET g_chr = ' '
   SELECT zw02,zwacti INTO l_zw02,l_zwacti FROM zw_file
    WHERE zw01 = g_zy01
 
   IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
      LET l_zw02 = NULL
   ELSE
      IF l_zwacti='N' THEN                     #無效的資料
         LET g_chr='E'
      END IF
   END IF
 
    DISPLAY l_zw02,l_zwacti TO zw02,zwacti  #MOD-560212 
 
END FUNCTION
 
FUNCTION p_zy2_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL p_zy2_curs()                      #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN p_zy2_b_curs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zy01 TO NULL
   ELSE
      CALL p_zy2_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN p_zy2_count
      FETCH p_zy2_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
 
END FUNCTION
 
FUNCTION p_zy2_fetch(p_flag)
DEFINE
   p_flag   LIKE type_file.chr1,    #處理方式   #No.FUN-680135 VARCHAR(1)
   l_abso   LIKE type_file.num10    #絕對的筆數 #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zy2_b_curs INTO g_zy01
      WHEN 'P' FETCH PREVIOUS p_zy2_b_curs INTO g_zy01
      WHEN 'F' FETCH FIRST    p_zy2_b_curs INTO g_zy01
      WHEN 'L' FETCH LAST     p_zy2_b_curs INTO g_zy01
      WHEN '/' 
            IF (NOT g_no_ask) THEN    #FUN-6A0080
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
            FETCH ABSOLUTE g_jump p_zy2_b_curs INTO g_zy01
            LET g_no_ask = FALSE       #FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zy01,SQLCA.sqlcode,0)
      INITIALIZE g_zy01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zy2_show()
   END IF
 
END FUNCTION
 
FUNCTION p_zy2_show()
 
   DISPLAY g_zy01 TO zy01                        #單頭
 
   CALL p_zy2_zy01('a')                          #單身
 
   CALL p_zy2_b_fill(g_wc)                       #單身
 
 
    CALL cl_show_fld_cont()                      #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zy2_b()
 
   DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
          l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680135 SMALLINT
          l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680135 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680135 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680135 SMALLINT
          l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680135 SMALLINT
   DEFINE lc_zwacti       LIKE zw_file.zwacti    #MOD-560212
   DEFINE l_prt           LIKE type_file.chr1    #FUN-660179
   DEFINE l_i             LIKE type_file.num10   #FUN-660179
   DEFINE l_cnt           LIKE type_file.num10   #No.FUN-770002
   DEFINE l_call_cr       LIKE type_file.chr1    #No.FUN-770002
 
   LET g_action_choice = ""
 
   IF g_zy01 IS NULL THEN
      RETURN
   ELSE                     #MOD-560212
      SELECT zwacti INTO lc_zwacti FROM zw_file
       WHERE zw01 = g_zy01
      IF lc_zwacti = "N" THEN
         CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
         RETURN
      END IF
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zy02,'',zy06 FROM zy_file",
                      " WHERE zy01=? AND zy02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zy2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
#  LET l_allow_insert = cl_detail_input_auth("insert")
#  LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_zy WITHOUT DEFAULTS FROM s_zy.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_zy_t.* = g_zy[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN p_zy2_bcl USING g_zy01,g_zy_t.zy02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN"||g_zy_t.zy02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            FETCH p_zy2_bcl INTO g_zy[l_ac].* 
            IF SQLCA.sqlcode THEN
               CALL cl_err("FETCH"||g_zy_t.zy02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               CALL p_zy2_zy02(' ')     #FUN-630099
               LET g_zy_t.*=g_zy[l_ac].*
               #CALL p_zy2_zy02(' ')     #FUN-630099
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         #No.FUN-770002 --start--
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM zaw_file WHERE zaw01 = g_zy[l_ac].zy02
         IF l_cnt > 0 THEN
            LET l_call_cr = 'Y'
         ELSE
           #FUN-C60029 ---------start---
            SELECT COUNT(*) INTO l_cnt FROM gdw_file WHERE gdw01 = g_zy[l_ac].zy02
            IF l_cnt > 0 THEN
               LET l_call_cr = 'G'
            ELSE
              #FUN-D20057 增加XtraGrid的判斷 --(S)
               SELECT COUNT(*) INTO l_cnt FROM gdr_file WHERE gdr01 = g_zy[l_ac].zy02
               IF l_cnt > 0 THEN
                  LET l_call_cr = 'X'
               ELSE
              #FUN-D20057 增加XtraGrid的判斷 --(E)
                  LET l_call_cr = 'N'
               END IF
            END IF #FUN-D20057
           #LET l_call_cr = 'N'
           #FUN-C60029 ---------end---
         END IF
         #No.FUN-770002 --end--
         NEXT FIELD zy06
 
      #FUN-660179
      AFTER FIELD zy06
         IF NOT cl_null(g_zy[l_ac].zy06) THEN
            IF g_zy[l_ac].zy06 != g_zy_t.zy06 OR g_zy_t.zy06 IS NULL THEN
               FOR l_i = 1 TO length(g_zy[l_ac].zy06)
                  LET l_prt = g_zy[l_ac].zy06[l_i,l_i]
                  #No.FUN-770002 --start--
                  #IF l_call_cr MATCHES '[Yy]' THEN #FUN-D20057 mark
                  IF l_call_cr MATCHES '[XYy]' THEN #FUN-D20057 add X
                     #FUN-C20037 --start--
                     #若選項中有N,則移除其他選項
                     IF l_prt = "N" THEN
                        LET g_zy[l_ac].zy06 = 'N'
                        EXIT FOR
                     ELSE
                     #FUN-C20037 --end--
                        #IF l_prt NOT MATCHES "[DEPRXA]" THEN   #No.FUN-A80035 add A
                        IF l_prt NOT MATCHES "[DEPRXAC]" THEN   #FUN-D40059 add C
                           CALL cl_err_msg(NULL, "azz-250",l_prt CLIPPED,0)
                           NEXT FIELD zy06
                        END IF
                     END IF   #FUN-C20037
                  ELSE
                  #No.FUN-770002 --end--
                     IF l_prt NOT MATCHES "[1LTDXIWMSPVNCJH]" THEN #No.FUN-6B0023 Matches add 'N'
                        CALL cl_err_msg(NULL, "azz-250",l_prt CLIPPED,0)
                        NEXT FIELD zy06
                     END IF
                  END IF #No.FUN-770002
               END FOR
            END IF
         END IF
      #END FUN-660179
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zy[l_ac].* = g_zy_t.*
            CLOSE p_zy2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zy[l_ac].zy06,-263,1)
            LET g_zy[l_ac].* = g_zy_t.*
         ELSE
            UPDATE zy_file SET zy06 = g_zy[l_ac].zy06
             WHERE zy01=g_zy01
               AND zy02=g_zy_t.zy02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zy[l_ac].zy02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zy_file",g_zy01,g_zy_t.zy02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zy[l_ac].* = g_zy_t.*
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
               LET g_zy[l_ac].* = g_zy_t.*
            END IF
            CLOSE p_zy2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_zy2_bcl
         COMMIT WORK
 
      #FUN-630099
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION CONTROLP 
         CASE
           WHEN INFIELD(zy06)
           #FUN-C60029 ---------start---
            ##No.FUN-770002 --start--
            #IF l_call_cr MATCHES '[Yy]' THEN
            #   CALL p_zy2_cr()
            #ELSE
            #   CALL p_zy2_prt()
            #END IF 
            ##No.FUN-770002 --end--
            CASE l_call_cr
              WHEN "Y" 
                 CALL p_zy2_cr()
              WHEN "G" 
                 CALL p_zy2_prt('G')
              WHEN "N"  
                 CALL p_zy2_prt('N')
            #FUN-D20057 add---(S)
              WHEN "X"  
                 CALL p_zy2_prt('X')
            #FUN-D20057 add---(E)
              OTHERWISE 
                 CALL p_zy2_prt('N')
            END CASE
           #FUN-C60029 ---------end---
             DISPLAY g_zy[l_ac].zy06 TO zy06
             NEXT FIELD zy06
         END CASE
      #END FUN-630099
       
#     ON KEY(control-n)
#        CALL p_zy2_b_askkey()
#        EXIT INPUT
 
#     ON KEY(control-o)                        #沿用所有欄位
#        IF INFIELD(zy02) AND l_ac > 1 THEN
#           LET g_zy[l_ac].* = g_zy[l_ac-1].*
#           NEXT FIELD zy02
#        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE p_zy2_bcl
   COMMIT WORK
 
END FUNCTION
   
FUNCTION  p_zy2_zy02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
#   l_zz04          VARCHAR(3000)
#   l_zz04          LIKE zz_filezz04
 
 #   #MOD-530267
#   CASE 
#      WHEN g_lang = '0'
#           SELECT zz02,zz04 INTO g_zy[l_ac].zz02,l_zz04 FROM zz_file
#            WHERE zz01 = g_zy[l_ac].zy02
#      WHEN g_lang = '2'
#           SELECT zz02c,zz04 INTO g_zy[l_ac].zz02,l_zz04 FROM zz_file
#            WHERE zz01 = g_zy[l_ac].zy02
#      OTHERWISE
#           SELECT zz02e,zz04 INTO g_zy[l_ac].zz02,l_zz04 FROM zz_file
#            WHERE zz01 = g_zy[l_ac].zy02
#   END CASE
 
#MOD-620091
   #SELECT gaz03 INTO g_zy[l_ac].gaz03 FROM gaz_file
   # WHERE gaz01=g_zy[l_ac].zy02 AND gaz02=g_lang
   CALL cl_get_progname(g_zy[l_ac].zy02,g_lang) RETURNING g_zy[l_ac].gaz03
#END MOD-620091
 
   IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
       LET g_zy[l_ac].gaz03 = NULL  #MOD-530267
#     LET g_zy[l_ac].zz02 = NULL
      RETURN
   END IF
 
   LET g_chr = ' '
 
END FUNCTION
 
#END FUN-630099
#FUN-C60029 ---------start---
FUNCTION p_zy2_prt(p_cmd)
#FUNCTION p_zy2_prt()
#FUN-C60029 ---------end---
DEFINE  p_cmd    LIKE type_file.chr1    #FUN-C60029
DEFINE  l_zy06   LIKE zy_file.zy06
DEFINE  l_prt    LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE  l_i      LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE  g_zy_prt    RECORD
         a      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         l      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         t      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         d      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         x      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         oh     LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         w      LIKE type_file.chr1,    #FUN-660179
         m      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         s      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         p      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         v      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         n      LIKE type_file.chr1,    #No.FUN-6B0023
         c      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         j      LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
         h      LIKE type_file.chr1,     #No.FUN-680135 SMALLINT #FUN-660179
         b     LIKE type_file.chr1,    #FUN-C70120 add
         e     LIKE type_file.chr1,    #FUN-C70120 add
         f     LIKE type_file.chr1     #FUN-C70120 add
        END RECORD 
 
   MESSAGE " "
 
   LET g_zy_prt.a  = 'N'
   LET g_zy_prt.l  = 'N'
   LET g_zy_prt.t  = 'N'
   LET g_zy_prt.d  = 'N'
   LET g_zy_prt.x  = 'N'
   LET g_zy_prt.oh = 'N'
   LET g_zy_prt.w  = 'N'                     #FUN-660179
   LET g_zy_prt.m  = 'N'
   LET g_zy_prt.s  = 'N'
   LET g_zy_prt.p  = 'N'
   LET g_zy_prt.v  = 'N'
   LET g_zy_prt.n  = 'N'    #No.FUN-6B0023
   LET g_zy_prt.c  = 'N'
   LET g_zy_prt.j  = 'N'
   LET g_zy_prt.h  = 'N'
   LET g_zy_prt.b  = 'N'   #FUN-C70120 add
   LET g_zy_prt.e  = 'N'   #FUN-C70120 add
   LET g_zy_prt.f  = 'N'   #FUN-C70120 add
   
   IF NOT cl_null(g_zy[l_ac].zy06) THEN
       FOR l_i = 1 TO length(g_zy[l_ac].zy06)
          LET l_prt = g_zy[l_ac].zy06[l_i,l_i]
          CASE l_prt
             WHEN '1'   LET g_zy_prt.a = 'Y'
             WHEN 'L'   LET g_zy_prt.l = 'Y'
             WHEN 'T'   LET g_zy_prt.t = 'Y'
             WHEN 'D'   LET g_zy_prt.d = 'Y'
             WHEN 'X'   LET g_zy_prt.x = 'Y'
             WHEN 'I'   LET g_zy_prt.oh = 'Y'
             WHEN 'W'   LET g_zy_prt.w = 'Y'               #FUN-660179
             WHEN 'M'   LET g_zy_prt.m = 'Y'
             WHEN 'S'   LET g_zy_prt.s = 'Y'
             WHEN 'P'   LET g_zy_prt.p = 'Y'
             WHEN 'V'   LET g_zy_prt.v = 'Y'
             WHEN 'N'   LET g_zy_prt.n = 'Y'    #No.FUN-6B0023
             WHEN 'C'   LET g_zy_prt.c = 'Y'
             WHEN 'J'   LET g_zy_prt.j = 'Y'
             WHEN 'H'   LET g_zy_prt.h = 'Y'
             WHEN 'B'   LET g_zy_prt.b = 'Y'    #FUN-C70120
             WHEN 'E'   LET g_zy_prt.e = 'Y'    #FUN-C70120
             WHEN 'F'   LET g_zy_prt.f = 'Y'    #FUN-C70120            
          END CASE 
       END FOR
   END IF
   OPEN WINDOW p_zy2_prt_w WITH FORM "azz/42f/p_zy2_prt"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zy2_prt")
#FUN-D20057 ------------------------(S)
  ##FUN-C60029 ---------start---
  #  IF p_cmd = 'G' THEN
  #     CALL cl_set_comp_visible("d,x,oh,p,j,b,e,f",TRUE) #FUN-C70120 add b,e,f
  #     CALL cl_set_comp_visible("a,l,t,w,m,s,v,n,c,h",FALSE)
  #  ELSE
  #     CALL cl_set_comp_visible("a,l,t,w,m,s,p,v,n,c,j,h,d,x,oh,p",TRUE)
  #     CALL cl_set_comp_visible("b,e,f",FALSE)  #FUN-C70120 add
  #  END IF
  ##FUN-C60029 ---------end---
  
   CALL cl_set_comp_att_text("n",cl_getmsg("azz1310",g_lang))  #FUN-D20057
   CASE p_cmd
     WHEN "G" #GR
       CALL cl_set_comp_visible("d,x,oh,p,j,b,e,f",TRUE) 
       CALL cl_set_comp_visible("a,l,t,w,m,s,v,n,c,h",FALSE)
     WHEN "X" #XtraGrid
     #FUN-D40059 ---start
       #CALL cl_set_comp_visible("d,x,p,n",TRUE)
       #CALL cl_set_comp_visible("a,l,t,w,m,s,v,c,h,b,e,f,oh,j",FALSE)
       CALL cl_set_comp_visible("d,x,p,n,e,c",TRUE)
       CALL cl_set_comp_visible("a,l,t,w,m,s,v,h,b,f,oh,j",FALSE)
     #FUN-D40059 ---end
       CALL cl_set_comp_att_text("n",cl_getmsg("azz1309",g_lang)) #FUN-D20057
       CALL cl_set_comp_att_text("c",cl_getmsg("azz1317",g_lang)) #FUN-D40059
     WHEN "X"
     OTHERWISE
       CALL cl_set_comp_visible("a,l,t,w,m,s,p,v,n,c,j,h,d,x,oh,p",TRUE)
       CALL cl_set_comp_visible("b,e,f",FALSE) 
   END CASE
#FUN-D20057 ------------------------(E)
 
   DISPLAY BY NAME  
       g_zy_prt.a,  g_zy_prt.l, g_zy_prt.t, g_zy_prt.d, g_zy_prt.x,
       g_zy_prt.b, g_zy_prt.e, g_zy_prt.f,                          #FUN-C70120 add
       g_zy_prt.oh, g_zy_prt.w, g_zy_prt.m, g_zy_prt.s, g_zy_prt.p, #FUN-660179
       g_zy_prt.v,  g_zy_prt.n, #No.FUN-6B0023
       g_zy_prt.c,  g_zy_prt.j, g_zy_prt.h 
 
   INPUT BY NAME  
       g_zy_prt.a,  g_zy_prt.l, g_zy_prt.t, g_zy_prt.d, g_zy_prt.x,
       g_zy_prt.b, g_zy_prt.e, g_zy_prt.f,                          #FUN-C70120 add
       g_zy_prt.oh, g_zy_prt.w, g_zy_prt.m, g_zy_prt.s, g_zy_prt.p, #FUN-660179
       g_zy_prt.v,  g_zy_prt.n, #No.FUN-6B0023
       g_zy_prt.c,  g_zy_prt.j, g_zy_prt.h 
       WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)
 
       ON ACTION select_all
     #FUN-D40059 ---start----
      #  #FUN-C60029 ---------start---
      #   IF p_cmd = 'G' THEN
      #      LET g_zy_prt.d  = 'Y'
      #      LET g_zy_prt.x  = 'Y'
      #      LET g_zy_prt.oh = 'Y'
      #      LET g_zy_prt.p  = 'Y'
      #      LET g_zy_prt.j  = 'Y'
      #      LET g_zy_prt.b = 'Y'   #FUN-C70120 add
      #      LET g_zy_prt.e  = 'Y'  #FUN-C70120 add
      #      LET g_zy_prt.f  = 'Y'  #FUN-C70120 add            
      #   ELSE
      #  #FUN-C60029 ---------end---
      #      LET g_zy_prt.a  = 'Y'
      #      LET g_zy_prt.l  = 'Y'
      #      LET g_zy_prt.t  = 'Y'
      #      LET g_zy_prt.d  = 'Y'
      #      LET g_zy_prt.x  = 'Y'
      #      LET g_zy_prt.oh = 'Y'
      #      LET g_zy_prt.w  = 'Y'                             #FUN-660179
      #      LET g_zy_prt.m  = 'Y'
      #      LET g_zy_prt.s  = 'Y'
      #      LET g_zy_prt.p  = 'Y'
      #      LET g_zy_prt.v  = 'Y'
      #    #FUN-D20057 add----(S)
      #      IF p_cmd = 'X' THEN
      #         LET g_zy_prt.n  = 'N' 
      #      ELSE
      #         LET g_zy_prt.n  = 'Y' 
      #      END IF
      #      #LET g_zy_prt.n  = 'Y'    #No.FUN-6B0023
      #    #FUN-D20057 add----(E)
      #      LET g_zy_prt.c  = 'Y'
      #      LET g_zy_prt.j  = 'Y'
      #      LET g_zy_prt.h  = 'Y'
      #   END IF
         CASE p_cmd
           WHEN "G"  #Genero Report
              LET g_zy_prt.d  = 'Y'
              LET g_zy_prt.x  = 'Y'
              LET g_zy_prt.oh = 'Y'
              LET g_zy_prt.p  = 'Y'
              LET g_zy_prt.j  = 'Y'
              LET g_zy_prt.b  = 'Y'  
              LET g_zy_prt.e  = 'Y' 
              LET g_zy_prt.f  = 'Y' 
              LET g_zy_prt.c  = 'Y'
              LET g_zy_prt.j  = 'Y'
              LET g_zy_prt.h  = 'Y'
              LET g_zy_prt.n  = 'Y'
           WHEN "X"  #XtraGrid
              LET g_zy_prt.d  = 'Y'
              LET g_zy_prt.e  = 'Y' 
              LET g_zy_prt.x  = 'Y'
              LET g_zy_prt.c  = 'Y'
              LET g_zy_prt.p  = 'Y'
              LET g_zy_prt.n  = 'N' 
              LET g_zy_prt.oh = 'N'
              LET g_zy_prt.j  = 'N'
              LET g_zy_prt.b  = 'N'  
              LET g_zy_prt.f  = 'N' 
              LET g_zy_prt.j  = 'N'
              LET g_zy_prt.h  = 'N'
           OTHERWISE
              LET g_zy_prt.a  = 'Y'
              LET g_zy_prt.l  = 'Y'
              LET g_zy_prt.t  = 'Y'
              LET g_zy_prt.d  = 'Y'
              LET g_zy_prt.x  = 'Y'
              LET g_zy_prt.oh = 'Y'
              LET g_zy_prt.w  = 'Y'
              LET g_zy_prt.m  = 'Y'
              LET g_zy_prt.s  = 'Y'
              LET g_zy_prt.p  = 'Y'
              LET g_zy_prt.v  = 'Y'
          END CASE
     #FUN-D40059 ---end----

      #FUN-D20057 add----(S)
       ON CHANGE n
          IF p_cmd = 'X' AND GET_FLDBUF(n) = 'Y' THEN
             LET g_zy_prt.x = 'N'
             LET g_zy_prt.d = 'N'
             LET g_zy_prt.p = 'N'
             LET g_zy_prt.e = 'N' #FUN-D40059
             LET g_zy_prt.c = 'N' #FUN-D40059
          END IF

       ON CHANGE x
           IF GET_FLDBUF(x) = 'Y' THEN
              LET g_zy_prt.n = 'N'
           END IF

       ON CHANGE d
           IF GET_FLDBUF(d) = 'Y' THEN
              LET g_zy_prt.n = 'N'
           END IF

       ON CHANGE p
           IF GET_FLDBUF(p) = 'Y' THEN
              LET g_zy_prt.n = 'N'
           END IF
      #FUN-D20057 add----(E)
      #FUN-D40059 add----(S)
       ON CHANGE e
           IF GET_FLDBUF(e) = 'Y' THEN
              LET g_zy_prt.n = 'N'
           END IF

       ON CHANGE c
           IF GET_FLDBUF(c) = 'Y' THEN
              LET g_zy_prt.n = 'N'
           END IF
      #FUN-D40059 add----(E)
 
       ON ACTION cancel_all
          LET g_zy_prt.a  = 'N'
          LET g_zy_prt.l  = 'N'
          LET g_zy_prt.t  = 'N'
          LET g_zy_prt.d  = 'N'
          LET g_zy_prt.x  = 'N'
          LET g_zy_prt.oh = 'N'
          LET g_zy_prt.w  = 'N'                             #FUN-660179
          LET g_zy_prt.m  = 'N'
          LET g_zy_prt.s  = 'N'
          LET g_zy_prt.p  = 'N'
          LET g_zy_prt.v  = 'N'
          LET g_zy_prt.n  = 'N'    #No.FUN-6B0023
          LET g_zy_prt.c  = 'N'
          LET g_zy_prt.j  = 'N'
          LET g_zy_prt.h  = 'N'
          LET g_zy_prt.b  = 'N'   #FUN-C70120 add
          LET g_zy_prt.e  = 'N'   #FUN-C70120 add
          LET g_zy_prt.f  = 'N'   #FUN-C70120 add           
 
       AFTER INPUT
          IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
          END IF
          LET l_zy06 = ''
          IF g_zy_prt.a  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'1'  END IF  
          IF g_zy_prt.l  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'L'  END IF  
          IF g_zy_prt.t  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'T'  END IF  
          IF g_zy_prt.d  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'D'  END IF  
          IF g_zy_prt.x  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'X'  END IF  
          IF g_zy_prt.oh = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'I'  END IF  
          IF g_zy_prt.w  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'W'  END IF #FUN-660179
          IF g_zy_prt.m  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'M'  END IF  
          IF g_zy_prt.s  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'S'  END IF  
          IF g_zy_prt.p  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'P'  END IF  
          IF g_zy_prt.v  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'V'  END IF  
          IF g_zy_prt.n  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'N'  END IF  #No.FUN-6B0023
          IF g_zy_prt.c  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'C'  END IF  
          IF g_zy_prt.j  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'J'  END IF  
          IF g_zy_prt.h  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'H'  END IF  
          IF g_zy_prt.b  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'B'  END IF  #FUN-C70120 add
          IF g_zy_prt.e  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'E'  END IF  #FUN-C70120 add
          IF g_zy_prt.f  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'F'  END IF  #FUN-C70120 add
          
          LET g_zy[l_ac].zy06 = l_zy06 CLIPPED
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT       
   LET INT_FLAG = 0 
   CLOSE WINDOW p_zy2_prt_w
END FUNCTION
#FUN-630099
 
FUNCTION p_zy2_b_askkey()
 
   DEFINE l_wc     LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(200)
 
   CONSTRUCT l_wc ON zy02,zy06 FROM s_zy[1].zy02,s_zy[1].zy06
              #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
#No.FUN-580031 --end--       HCN
#No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
#No.FUN-580031 --end--       HCN
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE CONSTRUCT 
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CALL p_zy2_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION p_zy2_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(200)
 
#   #MOD-530267
#   CASE 
#      WHEN g_lang = '0'
#         LET g_sql = "SELECT zy02,zy06,zz02,''",
#                     " FROM zy_file, OUTER zz_file ",
#                     " WHERE zy01 = '",g_zy01,"' AND ",
#                     "  zy02 = zz01 AND ",p_wc CLIPPED ,
#                     " ORDER BY 1"
#      WHEN g_lang = '2'
#         LET g_sql = "SELECT zy02,zy06,zz02c,''",
#                     " FROM zy_file, OUTER zz_file ",
#                     " WHERE zy01 = '",g_zy01,"' AND ",
#                     "  zy02 = zz01 AND ",p_wc CLIPPED ,
#                     " ORDER BY 1"
#      OTHERWISE
#         LET g_sql = "SELECT zy02,zy06,zz02e,''",
#                     " FROM zy_file, OUTER zz_file ",
#                     " WHERE zy01 = '",g_zy01,"' AND ",
#                     "  zy02 = zz01 AND ",p_wc CLIPPED ,
#                     " ORDER BY 1"
#   END CASE
 
#MOD-620091
   #LET g_sql = "SELECT zy02,gaz03,zy06 FROM zy_file, OUTER gaz_file ",
   #            " WHERE zy01 = '",g_zy01,"' ",
   #              " AND zy02 = gaz01 AND gaz02='",g_lang CLIPPED,"' ",
   #              " AND ",p_wc CLIPPED ,
   #            " ORDER BY 1"
    LET g_sql = "SELECT zy02,' ',zy06 FROM zy_file",
                " WHERE zy01 = '",g_zy01,"' ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
#END MOD-620091
 
   PREPARE p_zy2_prepare2 FROM g_sql      #預備一下
   DECLARE zy_curs CURSOR FOR p_zy2_prepare2
 
   CALL g_zy.clear()
   LET g_rec_b = 0    #MOD620091
   LET g_cnt = 1
 
   FOREACH zy_curs INTO g_zy[g_cnt].*   #單身 ARRAY 填充
      IF g_cnt=1 THEN
         LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #MOD-620091
      CALL cl_get_progname( g_zy[g_cnt].zy02,g_lang) RETURNING g_zy[g_cnt].gaz03
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #END MOD-620091
 
   END FOREACH
   CALL g_zy.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1           #MOD-620091
   IF g_rec_b=0 AND g_cnt > 0 THEN
      LET g_rec_b=9999
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zy2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zy TO s_zy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL p_zy2_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p_zy2_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL p_zy2_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION next
         CALL p_zy2_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
              
      ON ACTION last 
         CALL p_zy2_fetch('L')
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zy2_out()
DEFINE
    l_i            LIKE type_file.num5,    #No.FUN-680135 SMALLINT
    sr             RECORD
        zy01       LIKE zy_file.zy01,      #類別代號
        zw02       LIKE zw_file.zw02,      #類別名稱
        zy02       LIKE zy_file.zy02,      #程式代號
        zy06       LIKE zy_file.zy06,   
        gaz03      LIKE gaz_file.gaz03   #TQC-780047
        #zz02       LIKE zz_file.zz02       #程式名稱   #TQC-780047
                   END RECORD,
    l_name         LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-680135 VARCHAR(20)
    l_za05         LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(40)
 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('p_zy2') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    #-----TQC-780047---------
    
#    CASE 
#    WHEN g_lang = '0'
#    LET g_sql="SELECT zy01,zw02,zy02,zy06,zz02",
#              " FROM zy_file,OUTER zw_file, OUTER zz_file ",  # 組合出 SQL 指令
#              " WHERE zy01=zw01 AND zy02=zz01 AND ",g_wc CLIPPED
#    WHEN g_lang = '2'
#    LET g_sql="SELECT zy01,zw02,zy02,zy06,zz02c",
#              " FROM zy_file,OUTER zw_file, OUTER zz_file ",  # 組合出 SQL 指令
#              " WHERE zy01=zw01 AND zy02=zz01 AND ",g_wc CLIPPED
#    OTHERWISE 
#    LET g_sql="SELECT zy01,zw02,zy02,zy06,zz02e",
#              " FROM zy_file,OUTER zw_file, OUTER zz_file ",  # 組合出 SQL 指令
#              " WHERE zy01=zw01 AND zy02=zz01 AND ",g_wc CLIPPED
#    END CASE
   
    LET g_sql="SELECT zy01,zw02,zy02,zy06,''",
              " FROM zy_file,OUTER zw_file ",  # 組合出 SQL 指令
              " WHERE zy01=zw01 AND ",g_wc CLIPPED
    #-----END TQC-780047-----
    PREPARE p_zy2_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zy2_curo                         # SCROLL CURSOR
        CURSOR FOR p_zy2_p1
 
    START REPORT p_zy2_rep TO l_name
 
    FOREACH p_zy2_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL cl_get_progname(sr.zy02,g_lang) RETURNING sr.gaz03   #TQC-780047
        OUTPUT TO REPORT p_zy2_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_zy2_rep
 
    CLOSE p_zy2_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
 
REPORT p_zy2_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    sr              RECORD
        zy01       LIKE zy_file.zy01,       #類別代號
        zw02       LIKE zw_file.zw02,       #類別名稱
        zy02       LIKE zy_file.zy02,       #程式代號
        zy06       LIKE zy_file.zy06,       #
        gaz03      LIKE gaz_file.gaz03   #TQC-780047
        #zz02       LIKE zz_file.zz02        #程式名稱   #TQC-780047
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.zy01,sr.zy02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                   g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.zy01  #類別代號
            PRINT COLUMN g_c[31],sr.zy01,
                  COLUMN g_c[33],sr.zw02;
        ON EVERY ROW
            PRINT COLUMN g_c[34],sr.zy02,
                  #COLUMN g_c[36],sr.zz02,   #TQC-780047
                  COLUMN g_c[36],sr.gaz03,   #TQC-780047
                  COLUMN g_c[37],sr.zy06
 
        AFTER GROUP OF sr.zy01  #類別代號
            SKIP 1 LINE
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
               IF g_wc.subString(001,080) > ' ' THEN
		       PRINT g_x[8] CLIPPED,g_wc.subString(001,070) CLIPPED END IF
               IF g_wc.subString(071,140) > ' ' THEN
		       PRINT COLUMN 10,     g_wc.subString(071,140) CLIPPED END IF
               IF g_wc.subString(141,210) > ' ' THEN
		       PRINT COLUMN 10,     g_wc.subString(141,210) CLIPPED END IF
               PRINT g_dash[1,g_len]
            END IF
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
 
#No.FUN-770002 --start--
FUNCTION p_zy2_cr()
    DEFINE  l_zy06   LIKE zy_file.zy06
    DEFINE  l_prt    LIKE type_file.chr1
    DEFINE  l_i      LIKE type_file.num10
    
    DEFINE  g_zy_cr    RECORD
         d      LIKE type_file.chr1,
         e      LIKE type_file.chr1,
         p      LIKE type_file.chr1,
         r      LIKE type_file.chr1,
         x      LIKE type_file.chr1,
         a      LIKE type_file.chr1,     #No.FUN-A80035
         n      LIKE type_file.chr1      #No.FUN-C20037
    END RECORD 
 
    MESSAGE " "
 
    LET g_zy_cr.d = 'N'
    LET g_zy_cr.e = 'N'
    LET g_zy_cr.p = 'N'
    LET g_zy_cr.r = 'N'
    LET g_zy_cr.x = 'N'
    LET g_zy_cr.a = 'N' #No.FUN-A80035
    LET g_zy_cr.n = 'N' #No.FUN-C20037
 
    IF NOT cl_null(g_zy[l_ac].zy06) THEN
        FOR l_i = 1 TO length(g_zy[l_ac].zy06)
            LET l_prt = g_zy[l_ac].zy06[l_i,l_i]
            CASE l_prt                
                WHEN 'D'   LET g_zy_cr.d = 'Y'
                WHEN 'E'   LET g_zy_cr.e = 'Y'
                WHEN 'P'   LET g_zy_cr.p = 'Y'
                WHEN 'R'   LET g_zy_cr.r = 'Y'
                WHEN 'X'   LET g_zy_cr.x = 'Y'
                WHEN 'A'   LET g_zy_cr.a = 'Y'  #No.FUN-A80035
                WHEN 'N'   LET g_zy_cr.n = 'Y'  #No.FUN-C20037 #勾選無權限時取消其他選項
                           LET g_zy_cr.d = 'N'  #No.FUN-C20037
                           LET g_zy_cr.e = 'N'  #No.FUN-C20037
                           LET g_zy_cr.p = 'N'  #No.FUN-C20037
                           LET g_zy_cr.r = 'N'  #No.FUN-C20037
                           LET g_zy_cr.x = 'N'  #No.FUN-C20037
                           LET g_zy_cr.a = 'N'  #No.FUN-C20037
            END CASE
        END FOR
    END IF
    OPEN WINDOW p_zy2_cr_w WITH FORM "azz/42f/p_zy2_cr"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_ui_locale("p_zy2_cr")
 
    DISPLAY BY NAME
        g_zy_cr.p, g_zy_cr.r, g_zy_cr.d, g_zy_cr.e, g_zy_cr.x, g_zy_cr.a      #No.FUN-A80035
        , g_zy_cr.n  #No.FUN-C20037
        
    INPUT BY NAME
        g_zy_cr.p, g_zy_cr.r, g_zy_cr.d, g_zy_cr.e, g_zy_cr.x, g_zy_cr.a      #No.FUN-A80035
        , g_zy_cr.n  #No.FUN-C20037
        WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)

        #FUN-C20037 --start--
        ON CHANGE d
            IF GET_FLDBUF(d) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF

        ON CHANGE e
            IF GET_FLDBUF(e) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF

        ON CHANGE p
            IF GET_FLDBUF(p) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF

        ON CHANGE r
            IF GET_FLDBUF(r) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF

        ON CHANGE x
            IF GET_FLDBUF(x) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF

        ON CHANGE a
            IF GET_FLDBUF(a) = 'Y' THEN
               LET g_zy_cr.n = 'N'
            END IF
            
        ON CHANGE n
            IF GET_FLDBUF(n) = 'Y' THEN
               LET g_zy_cr.d = 'N'
               LET g_zy_cr.e = 'N'
               LET g_zy_cr.p = 'N'
               LET g_zy_cr.r = 'N'
               LET g_zy_cr.x = 'N'
               LET g_zy_cr.a = 'N'
            END IF
        #FUN-C20037 --end--
    
        ON ACTION select_all
            LET g_zy_cr.d = 'Y'
            LET g_zy_cr.e = 'Y'
            LET g_zy_cr.p = 'Y'
            LET g_zy_cr.r = 'Y'
            LET g_zy_cr.x = 'Y'
            LET g_zy_cr.a = 'Y'     #No.FUN-A80035
            LET g_zy_cr.n = 'N'     #No.FUN-C20037 #無權限選項需取消
        
        ON ACTION cancel_all
            LET g_zy_cr.d = 'N'
            LET g_zy_cr.e = 'N'
            LET g_zy_cr.p = 'N'
            LET g_zy_cr.r = 'N'
            LET g_zy_cr.x = 'N'
            LET g_zy_cr.a = 'N'     #No.FUN-A80035
            LET g_zy_cr.n = 'N'     #No.FUN-C20037 #無權限選項不設定
 
        AFTER INPUT
            IF INT_FLAG THEN                            # 使用者不玩了
                EXIT INPUT
            END IF
            LET l_zy06 = ''
            IF g_zy_cr.d  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'D'  END IF
            IF g_zy_cr.e  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'E'  END IF
            IF g_zy_cr.p  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'P'  END IF
            IF g_zy_cr.r  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'R'  END IF
            IF g_zy_cr.x  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'X'  END IF
            IF g_zy_cr.a  = 'Y' THEN  LET l_zy06 = l_zy06 CLIPPED,'A'  END IF   #No.FUN-A80035
            IF g_zy_cr.n  = 'Y' THEN  LET l_zy06 = 'N'  END IF #No.FUN-C20037
            LET g_zy[l_ac].zy06 = l_zy06 CLIPPED
 
       ON ACTION about         #FUN-860033
          CALL cl_about()      #FUN-860033
 
       ON ACTION controlg      #FUN-860033
          CALL cl_cmdask()     #FUN-860033
 
       ON ACTION help          #FUN-860033
          CALL cl_show_help()  #FUN-860033
 
       ON IDLE g_idle_seconds  #FUN-860033
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT  
    LET INT_FLAG = 0 
    CLOSE WINDOW p_zy2_cr_w
END FUNCTION
#No.FUN-770002 --end--
