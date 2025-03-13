# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern Name...: p_chartm.4gl
# Descriptions...: 自訂圖表清單維護作業
# Date & Author..: 11/10/21 By tommas
# Modify.........: No.FUN-BA0079 by tommas 新建

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_gdk       DYNAMIC ARRAY OF RECORD    #圖表清單檔
            gdk01    LIKE gdk_file.gdk01,       #圖表代號
            gfp04_1  LIKE gfp_file.gfp04,       #圖表名稱
            gfn02    LIKE gfn_file.gfn02,       #圖表類型
            gfp04_2  LIKE gfp_file.gfp04,       #圖表說明
            gdk02    LIKE gdk_file.gdk02,       #篩選條件一
            gdk03    LIKE gdk_file.gdk03        #篩選條件二
                     END RECORD,
         g_gdl       DYNAMIC ARRAY OF RECORD    #使用者自訂圖表設定檔
            gdl02    LIKE gdl_file.gdl02,       #優先序
            gdl03    LIKE gdl_file.gdl03,       #圖表代號
            gfp04    LIKE gfp_file.gfp04,       #圖表名稱
            gdldate  LIKE gdl_file.gdldate,     #最近修改日期
            gdlgrup  LIKE gdl_file.gdlgrup,     #資料所有群
            gdlmodu  LIKE gdl_file.gdlmodu,     #資料更改者 
            gdloriu  LIKE gdl_file.gdloriu,     #資料建立者
            gdlorig  LIKE gdl_file.gdlorig,     #資料建立部門
            gdluser  LIKE gdl_file.gdluser      #資料所有者
                  END RECORD,
         g_gdl_t     RECORD    #使用者自訂圖表設定檔
            gdl02    LIKE gdl_file.gdl02,       #優先序
            gdl03    LIKE gdl_file.gdl03,       #圖表代號
            gfp04    LIKE gfp_file.gfp04,       #圖表名稱
            gdldate  LIKE gdl_file.gdldate,     #最近修改日期
            gdlgrup  LIKE gdl_file.gdlgrup,     #資料所有群
            gdlmodu  LIKE gdl_file.gdlmodu,     #資料更改者 
            gdloriu  LIKE gdl_file.gdloriu,     #資料建立者
            gdlorig  LIKE gdl_file.gdlorig,     #資料建立部門
            gdluser  LIKE gdl_file.gdluser      #資料所有者
                  END RECORD,
         g_gfm_pics  DYNAMIC ARRAY OF RECORD
            gfm01_pic  STRING,
            gfm01      LIKE gfm_file.gfm01
                     END RECORD
DEFINE   g_wc2       STRING,
         g_sql       STRING
DEFINE   g_zx     RECORD 
            zx01  LIKE zx_file.zx01,  #過濾的使用者名稱
            zx02  LIKE zx_file.zx02,
            zx03  LIKE zx_file.zx03   #部門
                  END RECORD
DEFINE   g_row_count    INTEGER,
         g_curs_index   INTEGER,
         g_jump         INTEGER,
         g_no_ask       INTEGER,
         g_msg          STRING
MAIN  #FUN-BA0079 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW chartm_w WITH FORM "azz/42f/p_chartm"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()

   PREPARE chartm_gfp FROM "SELECT a.gfp04, b.gfp04 FROM gfp_file a JOIN gfp_file b ON a.gfp01 = b.gfp01 AND b.gfp02 = 'desc' WHERE a.gfp01 = ? AND a.gfp02 = 'name' AND a.gfp03 = ? "
   LET g_zx.zx01 = 'default'
   CALL chartm_menu()  
   
   CLOSE WINDOW chartm_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION chartm_menu()
   DEFINE l_i    INTEGER
   
   PREPARE p_chartm_gfm_p1 FROM "SELECT gfm01 FROM gfm_file GROUP BY gfm01"   
   DECLARE p_chartm_gfm_d1 CURSOR FOR p_chartm_gfm_p1
   LET l_i = 1
   
   FOREACH p_chartm_gfm_d1 INTO g_gfm_pics[l_i].gfm01
      LET g_gfm_pics[l_i].gfm01_pic = g_gfm_pics[l_i].gfm01,".png"
      LET l_i = l_i + 1      
   END FOREACH   
   
   CALL g_gfm_pics.deleteElement(l_i)
   WHILE TRUE
   CALL p_chartm_b_fill()
   CALL p_chartm_show()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p_chartm_q()
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "next"
            CALL p_chartm_fetch('N')
         WHEN "previous"
            CALL p_chartm_fetch('P')
         WHEN "last"
            CALL p_chartm_fetch('L')
         WHEN "first"
            CALL p_chartm_fetch('F')
         WHEN "jump"
            CALL p_chartm_fetch('/')
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_chartm_show()
   DEFINE l_dnd   ui.DragDrop
   DEFINE l_ld    INTEGER 
   DEFINE l_s     STRING  #拖拉的來源(
   DEFINE l_ac    INTEGER #拖拉放開後在哪一筆
   DEFINE l_len   INTEGER
   DISPLAY g_zx.zx01 TO s_zx01
   DISPLAY g_zx.zx02 TO s_zx02

   DIALOG ATTRIBUTE(UNBUFFERED=TRUE)     
      
      DISPLAY ARRAY g_gfm_pics TO s_gfm.*
         BEFORE DISPLAY 
            IF g_gdk.getLength() > 0 THEN
               CALL p_chartm_scroll_pic(DIALOG, g_gdk[1].gfn02)  #轉到正確的圖表類型
            END IF
      END DISPLAY
      
      DISPLAY ARRAY g_gdk TO s_gdk.*

            
         ON DRAG_START(l_dnd)
            IF g_gdl.getLength() >= 6 AND g_zx.zx01 != 'default' THEN
               ERROR "自訂清單最多只可選擇6筆"
               CALL l_dnd.setOperation(null)
               CONTINUE DIALOG
            END IF
            LET l_s = "GDK"
            CALL l_dnd.setOperation("move")
            LET l_ld = ARR_CURR()
            
         ON DROP(l_dnd)
            IF l_s == "GDL" THEN
               CALL g_gdl.deleteElement(l_ld)
               CALL p_chartm_upd_gdl()
            END IF
            
         BEFORE ROW
            IF ARR_CURR() > 0 THEN
               CALL p_chartm_scroll_pic(DIALOG, g_gdk[ARR_CURR()].gfn02)  #轉到正確的圖表類型
            END IF
      END DISPLAY
      
      DISPLAY ARRAY g_gdl TO s_gdl.*
      
         BEFORE ROW
            IF ARR_CURR() > 0 THEN
               CALL p_chartm_scroll_pic(DIALOG, g_gdl[ARR_CURR()].gdl03)  #轉到正確的圖表類型
            END IF
            
         ON DRAG_START(l_dnd) #自訂圖表清單不給
            LET l_s = "GDL"
            LET l_ld = ARR_CURR()

         ON DROP(l_dnd)
            LET l_ac = l_dnd.getLocationRow()
            IF l_s == "GDK" THEN #從可選清單中移入 
               CALL g_gdl.insertElement(l_ac)
               LET g_gdl[l_ac].gdl02 = 1
               LET g_gdl[l_ac].gdl03 = g_gdk[l_ld].gdk01
               LET g_gdl[l_ac].gdldate = TODAY
               LET g_gdl[l_ac].gdlgrup = g_grup
               LET g_gdl[l_ac].gdlmodu = g_user
               LET g_gdl[l_ac].gdlorig = g_grup
               LET g_gdl[l_ac].gdloriu = g_user
               LET g_gdl[l_ac].gdluser = g_user
            END IF 
            IF l_s == "GDL" THEN #移動位置
               LET g_gdl_t.* = g_gdl[l_ld].*  #將移動的拿出來
               LET g_gdl[l_ld].gdl02 = 0      #清空移動位置的值
               CALL g_gdl.insertElement(l_ac) #插入新位置
               LET g_gdl[l_ac].* = g_gdl_t.*  #將拿出來的值給新位置
               FOR l_len = 1 TO g_gdl.getLength()  #清除空值
                  IF g_gdl[l_len].gdl02 == 0 THEN 
                     CALL g_gdl.deleteElement(l_len)
                     EXIT FOR
                  END IF
               END FOR            
            END IF
            CALL p_chartm_upd_gdl()
      END DISPLAY
      
      ON ACTION query
         LET g_action_choice = "query"
         EXIT DIALOG
      ON ACTION first
         LET g_action_choice = "first"
         EXIT DIALOG
      ON ACTION last
         LET g_action_choice = "last"
         EXIT DIALOG
      ON ACTION next
         LET g_action_choice = "next"
         EXIT DIALOG
      ON ACTION previous
         LET g_action_choice = "previous"
         EXIT DIALOG
      ON ACTION jump
         LET g_action_choice = "jump"
         EXIT DIALOG
      ON ACTION EXIT
         LET INT_FLAG = FALSE
         LET g_action_choice = "exit"
         EXIT DIALOG      
      ON ACTION CLOSE
         LET INT_FLAG = FALSE
         LET g_action_choice = "exit"
         EXIT DIALOG 
   END DIALOG
END FUNCTION

FUNCTION p_chartm_upd_gdl()
   DEFINE l_len   INTEGER
   DEFINE l_err   INTEGER
   ######  更新gdl_file  start   ######
   LET l_err = 0
   BEGIN WORK
   DELETE FROM gdl_file WHERE gdl01 = g_zx.zx01
   IF SQLCA.sqlcode THEN
      LET l_err = SQLCA.sqlcode
      CALL cl_err3("del","gdl_file",g_zx.zx01,"",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK 
      RETURN
   END IF
   FOR l_len = 1 TO g_gdl.getLength()
      INSERT INTO gdl_file (gdl01,gdl02,
                            gdl03,gdldate,
                            gdlgrup,gdlmodu,
                            gdloriu,gdlorig,
                            gdluser)
                     VALUES (g_zx.zx01,l_len,
                             g_gdl[l_len].gdl03,today,
                             g_gdl[l_len].gdlgrup,g_user,
                             g_gdl[l_len].gdloriu,g_gdl[l_len].gdlorig,
                             g_user)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("del","gdl_file",g_zx.zx01,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
         EXIT FOR
      END IF
   END FOR
   IF l_err == 0 THEN
      COMMIT WORK
      CALL p_chartm_b_fill()  #重新取得正確資料並填入table
   END IF   
   ######  更新gdl_file  end     ######
END FUNCTION
FUNCTION p_chartm_q()
   DEFINE l_sql STRING
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   DISPLAY '   ' TO FORMONLY.cnt

   CONSTRUCT g_wc2 ON zx01 FROM s_zx01

      ON ACTION controlp
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_zx"
         LET g_qryparam.state ="c"
         LET g_qryparam.default1 = g_zx.zx01
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO s_zx01

   END CONSTRUCT     
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      CLEAR FORM 
   END IF

   LET l_sql = "SELECT DISTINCT zx01, zx02, zx03 ",
               "  FROM zx_file ",  
               "  WHERE ", g_wc2 CLIPPED, " ORDER BY zx01"

   PREPARE p_chartm_zx FROM l_sql
   DECLARE p_chartm_zxd1 SCROLL CURSOR WITH HOLD FOR p_chartm_zx

   LET l_sql = "SELECT COUNT(zx01) FROM zx_file WHERE ", g_wc2 CLIPPED
   PREPARE p_chartm_pre_zxcnt FROM l_sql
   DECLARE p_chartm_zxcnt CURSOR FOR p_chartm_pre_zxcnt
   
   OPEN p_chartm_zxd1
   OPEN p_chartm_zxcnt
   
   FETCH p_chartm_zxcnt INTO g_row_count 
   DISPLAY g_row_count TO FORMONLY.cnt
   
   CALL p_chartm_fetch("F")
END FUNCTION

FUNCTION p_chartm_b_fill()
   DEFINE   l_cnt       INTEGER
   DEFINE   l_zx01      LIKE zx_file.zx01,
            l_zx02      LIKE zx_file.zx02,
            l_zx03      LIKE zx_file.zx03
   DEFINE   l_tmp       LIKE gfp_file.gfp04

   LET l_zx01 = g_zx.zx01
   LET l_zx02 = g_zx.zx02
   LET l_zx03 = g_zx.zx03
   
   LET g_sql = "SELECT DISTINCT gdk01, gdk02, gdk03, gfn02 FROM gdk_file ", 
               "    JOIN gfn_file ON gdk01 = gfn01 ", 
               "  WHERE gdk01 NOT IN (SELECT gdl03 FROM gdl_file WHERE gdl01 = ?)"

   CALL g_gdk.clear()
   PREPARE chartm_gdk_p1 FROM g_sql
   DECLARE chartm_gdk_d1 CURSOR FOR chartm_gdk_p1
   LET l_cnt = 1 
   
   FOREACH chartm_gdk_d1 USING l_zx01 INTO g_gdk[l_cnt].gdk01, g_gdk[l_cnt].gdk02, 
                             g_gdk[l_cnt].gdk03, g_gdk[l_cnt].gfn02  
      CALL p_chartm_chart_info(g_gdk[l_cnt].gdk01) 
               RETURNING g_gdk[l_cnt].gfp04_1, g_gdk[l_cnt].gfp04_2
      LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL g_gdk.deleteElement(l_cnt)
   
   FOR l_cnt = g_gdk.getLength() TO 1 STEP -1
      IF NOT s_chart_auth(g_gdk[l_cnt].gdk01, l_zx01) THEN
         CALL g_gdk.deleteElement(l_cnt)
      END IF
   END FOR
   LET g_sql = "SELECT DISTINCT gdl02, gdl03, '', gdldate, gdlgrup, gdlmodu, gdloriu, gdlorig, gdluser",
               "   FROM gdl_file WHERE gdl01 = ? ORDER BY gdl02"
   CALL g_gdl.clear()
   PREPARE p_chartm_gdl_p1 FROM g_sql
   DECLARE p_chartm_gdl_d1 CURSOR FOR p_chartm_gdl_p1
   LET l_cnt = 1
   FOREACH p_chartm_gdl_d1 USING l_zx01 INTO g_gdl[l_cnt].*
      CALL p_chartm_chart_info(g_gdl[l_cnt].gdl03) RETURNING g_gdl[l_cnt].gfp04, l_tmp
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_gdl.deleteElement(l_cnt)
   
END FUNCTION 

FUNCTION p_chartm_fetch(p_flzx)
   DEFINE p_flzx          LIKE type_file.chr1
      CASE p_flzx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      IF g_curs_index <= 0 THEN LET g_curs_index = 1 END IF
      IF g_curs_index > g_row_count THEN LET g_curs_index = g_row_count END IF
      
   CASE p_flzx
      WHEN 'N' FETCH ABSOLUTE g_curs_index p_chartm_zxd1 INTO g_zx.*
      WHEN 'P' FETCH ABSOLUTE g_curs_index p_chartm_zxd1 INTO g_zx.*
      WHEN 'F' FETCH FIRST    p_chartm_zxd1 INTO g_zx.*
      WHEN 'L' FETCH LAST     p_chartm_zxd1 INTO g_zx.*
      WHEN '/' 
         IF (NOT g_no_ask) THEN   #FUN-6A0080
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
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_chartm_zxd1 INTO g_zx.*
         LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      INITIALIZE g_zx.* TO NULL
      RETURN
   END IF
   CALL cl_navigator_setting(g_curs_index, g_row_count)
END FUNCTION

FUNCTION p_chartm_chart_info(p_gdk01)
   DEFINE p_gdk01    LIKE gdk_file.gdk01
   DEFINE l_gfp02    LIKE gfp_file.gfp02
   DEFINE l_gfp03    LIKE gfp_file.gfp03
   DEFINE l_name     LIKE gfp_file.gfp04,  #圖表名稱
          l_desc     LIKE gfp_file.gfp04   #圖表說明
          
   EXECUTE chartm_gfp USING p_gdk01, g_lang INTO l_name, l_desc
   RETURN l_name, l_desc
END FUNCTION

#將PictureFlow捲到正確的圖表類型
FUNCTION p_chartm_scroll_pic(p_dialog, p_gdk01)
   DEFINE p_dialog  ui.Dialog,
          p_gdk01   LIKE gdk_file.gdk01 
   DEFINE l_i       INTEGER
   FOR l_i = 1 TO g_gfm_pics.getLength()
      IF p_gdk01 == g_gfm_pics[l_i].gfm01 THEN
         CALL p_dialog.setCurrentRow("s_gfm",l_i)
         EXIT FOR
      END IF
   END FOR 
END FUNCTION
