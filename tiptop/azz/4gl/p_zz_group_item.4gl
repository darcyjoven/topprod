# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: p_zz_group_item.4gl (副程式)
# Descriptions...: 編修群組設定副程式
# Date & Author..: 05/01/02 alex
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60010 10/07/16 By Pengu 更新群組項目視窗的單身程式代碼無法開窗
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gaw01          LIKE gaw_file.gaw01,         # 類別代號 (假單頭)
         g_gaw01_t        LIKE gaw_file.gaw01,         # 類別代號 (假單頭)
         g_gaz    DYNAMIC ARRAY of RECORD              # 程式變數
            gaz01          LIKE gaz_file.gaz01,
            gaz03          LIKE gaz_file.gaz03
                      END RECORD,
         g_gaz_t           RECORD                      # 變數舊值
            gaz01          LIKE gaz_file.gaz01,
            gaz03          LIKE gaz_file.gaz03
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,    # 單身筆數  #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
FUNCTION p_zz_group_item(l_gaw01)
 
   DEFINE l_gaw01     LIKE gaw_file.gaw01
   DEFINE l_gaw02     LIKE gaw_file.gaw02
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_gaw01 = l_gaw01
   LET g_gaw01_t = NULL
 
   OPEN WINDOW p_zz_group_item_w WITH FORM "azz/42f/p_zz_group_item"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zz_group_item")
 
   SELECT gaw02 INTO l_gaw02 FROM gaw_file WHERE gaw01=g_gaw01
   DISPLAY g_gaw01,l_gaw02 TO gaw01,gaw02
 
   LET g_sql = "SELECT gaz01,gaz03 FROM zz_file,gaz_file ",
               " WHERE zz10 = '",g_gaw01 CLIPPED,"' ",
                 " AND gaz02= '",g_lang CLIPPED,"' ",
                 " AND gaz01=zz01 ",
               " ORDER BY gaz01 "
 
   PREPARE p_zz_group_item_prepare2 FROM g_sql 
   DECLARE gaz_curs CURSOR FOR p_zz_group_item_prepare2
 
   CALL p_zz_group_item_b_fill() 
   CALL p_zz_group_item_menu() 
 
   CLOSE WINDOW p_zz_group_item_w                       # 結束畫面
   RETURN
 
END FUNCTION
 
 
FUNCTION p_zz_group_item_menu()
 
   WHILE TRUE
      CALL p_zz_group_item_bp("G")
 
      CASE g_action_choice
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zz_group_item_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_zz_group_item_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,        # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,        # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,        # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,        # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,        #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5         #No.FUN-680135      SMALLINT
   DEFINE   lc_zz10         LIKE zz_file.zz10
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gaw01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= " SELECT zz01,gaz03 FROM zz_file,gaz_file ",
                      "  WHERE zz10 = ? AND zz01 = ? AND zz01=gaz01 AND gaz02= ? ",
                        " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zz_group_item_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gaz WITHOUT DEFAULTS FROM s_gaz.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gaz_t.* = g_gaz[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN p_zz_group_item_bcl USING g_gaw01,g_gaz_t.gaz01,g_lang
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zz_group_item_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zz_group_item_bcl INTO g_gaz[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_zz_group_item_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gaz[l_ac].* TO NULL       #900423
         LET g_gaz_t.* = g_gaz[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gaz01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         UPDATE zz_file SET zz10=g_gaw01 WHERE zz01=g_gaz[l_ac].gaz01
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("upd","zz_file",g_gaz[l_ac].gaz01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gaz01
         IF NOT cl_null(g_gaz[l_ac].gaz01) THEN
            SELECT zz01 FROM zz_file 
             WHERE zz01=g_gaz[l_ac].gaz01 AND zz011 <> 'MENU'
               AND zz08 IS NOT NULL
            IF SQLCA.SQLCODE THEN
               #CALL cl_err(g_gaz[l_ac].gaz01 CLIPPED,SQLCA.SQLCODE,1)  #No.FUN-660081
               CALL cl_err3("sel","zz_file",g_gaz[l_ac].gaz01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
               LET g_gaz[l_ac].gaz01=g_gaz_t.gaz01 CLIPPED
               DISPLAY g_gaz[l_ac].gaz01 TO gaz01
            ELSE
               SELECT zz10 INTO lc_zz10 FROM zz_file 
                WHERE zz01=g_gaz[l_ac].gaz01
               IF NOT cl_null(lc_zz10) AND (lc_zz10 CLIPPED)<>(g_gaw01 CLIPPED) THEN
                  CALL cl_err_msg(NULL,"azz-112",g_gaz[l_ac].gaz01 CLIPPED || "|" || g_gaw01 CLIPPED, 10)
                  LET g_gaz[l_ac].gaz01=g_gaz_t.gaz01 CLIPPED
                  DISPLAY g_gaz[l_ac].gaz01 TO gaz01
               ELSE
                  SELECT gaz03 INTO g_gaz[l_ac].gaz03 FROM gaz_file
                   WHERE gaz01=g_gaz[l_ac].gaz01
                     AND gaz02=g_lang
                  DISPLAY g_gaz[l_ac].gaz03 TO gaz03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gaz_t.gaz03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            UPDATE zz_file SET zz10="" WHERE zz01=g_gaz[l_ac].gaz01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gaz_t.gaz03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zz_file",g_gaz[l_ac].gaz01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gaz[l_ac].* = g_gaz_t.*
            CLOSE p_zz_group_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL cl_err(g_gaz[l_ac].gaz01,"azz-111",1)
         LET g_gaz[l_ac].* = g_gaz_t.*
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gaz[l_ac].* = g_gaz_t.*   
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gaz.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_zz_group_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE p_zz_group_item_bcl
         COMMIT WORK
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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

     #---------------No:MOD-A60010 add
      ON ACTION controlp
          CASE 
            WHEN INFIELD(gaz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz" 
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET g_qryparam.default1 = g_gaz[l_ac].gaz01
               CALL cl_create_qry() RETURNING g_gaz[l_ac].gaz01
               DISPLAY g_gaz[l_ac].gaz01 TO gaz01
         END CASE
     #---------------No:MOD-A60010 end
 
   END INPUT
   CLOSE p_zz_group_item_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_zz_group_item_b_fill() 
 
    CALL g_gaz.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH gaz_curs INTO g_gaz[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gaz.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_zz_group_item_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gaz TO s_gaz.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
