# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: aws_name_update.4gl
# Descriptions...: 整合多語言記錄資料更新作業
# Usage..........: call aws_name_update(l_wan01,l_wan02,l_wan03,l_wan04,l_wan06) RETURNING l_wan06
# Input parameter: l_wan01 檔案代碼             Ex: "wae_file"
#                : l_wan02 欄位代碼                 "wae04"
#                : l_wan03 KEY 值序列               "axmr430"
#                : l_wan04 KEY 值序列 2             "g_pdate"
#                : l_wan06 目前語言別下所需欄位值   "列印日期"
# Return code....: l_wan06 目前語言別下所需欄位值   "列印日期"
# Date & Author..: 09/06/29 by Vicky
# Modify.........: No.FUN-930132 09/06/29 by Vicky 新建立
 
DATABASE ds
 
#FUN-930132
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wan01       LIKE wan_file.wan01,     # 類別代號 (假單頭)
         g_wan02       LIKE wan_file.wan02,     # 類別代號 (假單頭)
         g_wan03       LIKE wan_file.wan03,     # 類別代號 (假單頭)
         g_wan04       LIKE wan_file.wan04,     # 類別代號 (假單頭)
         g_wan         DYNAMIC ARRAY of RECORD  # 程式變數
            wan05      LIKE wan_file.wan05,
            wan06      LIKE wan_file.wan06
                       END RECORD,
         g_wan_t       RECORD                   # 變數舊值
            wan05      LIKE wan_file.wan05,
            wan06      LIKE wan_file.wan06
                       END RECORD,
         g_sql         STRING,
         g_forupd_sql  STRING,
         g_rec_b       LIKE type_file.num5,     # 單身筆數
         l_ac          LIKE type_file.num5,     # 目前處理的ARRAY CNT
         g_cnt         LIKE type_file.num10,
         g_curr_wan06  LIKE wan_file.wan06,
         g_first       LIKE type_file.chr1      #是否第一次進入單身
 
FUNCTION aws_name_update(l_wan01,l_wan02,l_wan03,l_wan04,l_wan06)
   DEFINE  l_wan01       LIKE wan_file.wan01,
           l_wan02       LIKE wan_file.wan02,
           l_wan03       LIKE wan_file.wan03,
           l_wan04       LIKE wan_file.wan04,
           l_wan06       LIKE wan_file.wan06,
           l_wan06_new   LIKE wan_file.wan06,
           l_gay01       LIKE gay_file.gay01,
           l_i           LIKE type_file.num10,
           l_cnt         LIKe type_file.num10,
           l_sql         STRING,
           l_str         STRING
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_wan01 = l_wan01
   LET g_wan02 = l_wan02
   LET g_wan03 = l_wan03
   LET g_wan04 = l_wan04
   LET g_curr_wan06 = l_wan06 CLIPPED
 
   #--------------------------------------------------------------------------#
   #檢查傳入的KEY值序列是否所有語言別的資料都已經存在
   #若不存在資料則自動給予預設值並 INSERT
   #--------------------------------------------------------------------------#
   LET l_sql = "SELECT wan06 FROM wan_file",
               " WHERE wan04 = '",g_wan04,"'",
                 " AND wan05 = ? "
   PREPARE wan06_pre FROM l_sql
   DECLARE wan06_curs SCROLL CURSOR FOR wan06_pre
 
   BEGIN WORK
   DECLARE gay_curs CURSOR FOR SELECT gay01 FROM gay_file WHERE gayacti = 'Y'
   FOREACH gay_curs INTO l_gay01
      LET l_wan06_new = ""
      SELECT COUNT(*)INTO l_cnt FROM wan_file
       WHERE wan01 = g_wan01 AND wan02 = g_wan02
         AND wan03 = g_wan03 AND wan04 = g_wan04
         AND wan05 = l_gay01
      IF l_cnt = 0 THEN
         IF g_wan04 = "*" OR
            (g_wan04<>"*" AND l_gay01=g_lang AND NOT cl_null(l_wan06)) THEN
            LET l_wan06_new = l_wan06
         ELSE
            OPEN wan06_curs USING l_gay01
            FETCH FIRST wan06_curs INTO l_wan06_new
            IF SQLCA.SQLCODE THEN
               SELECT gaq03 INTO l_wan06_new FROM gaq_file
                WHERE gaq01 = g_wan04 AND gaq02 = l_gay01
                IF SQLCA.SQLCODE THEN
                   LET l_wan06_new = ""
                END IF
            END IF
            CLOSE wan06_curs
         END IF
         INSERT INTO wan_file(wan01,wan02,wan03,wan04,wan05,wan06)
                VALUES (g_wan01,g_wan02,g_wan03,g_wan04,l_gay01,l_wan06_new)
         IF SQLCA.sqlcode THEN
            LET l_str = "Insert ",l_gay01,":",l_wan06_new, " into wan_file failed"
            CALL cl_err(l_str,"!" ,0)
         END IF
      END IF
   END FOREACH
   COMMIT WORK
 
   OPEN WINDOW aws_name_update_w WITH FORM "aws/42f/aws_name_update"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("aws_name_update")
   CALL cl_set_combo_lang("wan05")
 
   LET g_sql = "SELECT wan05,wan06 FROM wan_file",
               " WHERE wan01 = '", g_wan01 CLIPPED, "'",
                 " AND wan02 = '", g_wan02 CLIPPED, "'",
                 " AND wan03 = '", g_wan03 CLIPPED, "'",
                 " AND wan04 = '", g_wan04 CLIPPED, "'",
               " ORDER BY wan05"
 
   PREPARE aws_name_update_pre FROM g_sql
   DECLARE wan_curs CURSOR FOR aws_name_update_pre
 
   CALL aws_name_update_b_fill()
 
   LET g_first = "Y"
   CALL aws_name_update_b()
 
   CALL aws_name_update_menu()
 
   CLOSE WINDOW aws_name_update_w
 
   LET l_i = aws_name_update_curr()
   IF l_i = 0 THEN
      RETURN l_wan06 CLIPPED
   END IF
 
   RETURN g_wan[l_i].wan06 CLIPPED
 
END FUNCTION
 
FUNCTION aws_name_update_curr()
 
   DEFINE l_i   LIKE type_file.num10
 
   FOR l_i = 1 TO g_wan.getLength()
      IF g_wan[l_i].wan05 CLIPPED = g_lang CLIPPED THEN
         EXIT FOR
      END IF
   END FOR
 
   IF l_i = g_wan.getLength() AND g_wan[l_i].wan05 CLIPPED <> g_lang CLIPPED THEN
      RETURN 0
   END IF
 
   RETURN l_i
 
END FUNCTION
 
FUNCTION aws_name_update_menu()
   WHILE TRUE
      CALL aws_name_update_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_first = "N"
               CALL aws_name_update_b()
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
 
FUNCTION aws_name_update_b()                    # 單身
   DEFINE l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_ac_t          LIKE type_file.num5,  # 未取消的ARRAY CNT
          l_lock_sw       LIKe type_file.chr1,  # 單身鎖住否
          l_n             LIKe type_file.num5,  # 檢查重複用
          p_cmd           LIKE type_file.chr1   # 處理狀態
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_wan01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_opmsg('b')
   LET l_allow_insert = TRUE
   LET l_allow_delete = TRUE
 
   LET g_forupd_sql= "SELECT wan05,wan06",
                      " FROM wan_file",
                     " WHERE wan01=? AND wan02=? AND wan03=? AND wan04=? AND wan05=?",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aws_name_update_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_wan WITHOUT DEFAULTS FROM aws_wan.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            LET l_ac = aws_name_update_curr()
            CALL FGL_SET_ARR_CURR(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_wan_t.* = g_wan[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN aws_name_update_bcl
                 USING g_wan01,g_wan02,g_wan03,g_wan04,g_wan_t.wan05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN aws_name_update_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH aws_name_update_bcl INTO g_wan[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH aws_name_update_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF g_first = "Y" AND g_wan[l_ac].wan05 = g_lang
                     AND NOT cl_null(g_curr_wan06) THEN
                     LET g_wan[l_ac].wan06 = g_curr_wan06
                  END IF
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_wan[l_ac].* TO NULL
         LET g_wan_t.* = g_wan[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD wan05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO wan_file(wan01,wan02,wan03,wan04,wan05,wan06)
                      VALUES (g_wan01,g_wan02,g_wan03,g_wan04,
                              g_wan[l_ac].wan05,g_wan[l_ac].wan06)
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_wan[l_ac].wan06,SQLCA.sqlcode,0)
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_wan_t.wan05) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM wan_file WHERE wan01 = g_wan01
                                   AND wan02 = g_wan02
                                   AND wan03 = g_wan03
                                   AND wan04 = g_wan04
                                   AND wan05 = g_wan[l_ac].wan05
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wan_t.wan06,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wan[l_ac].* = g_wan_t.*
            CLOSE aws_name_update_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wan[l_ac].wan06,-263,1)
            LET g_wan[l_ac].* = g_wan_t.*
         ELSE
            UPDATE wan_file
               SET wan05 = g_wan[l_ac].wan05,
                   wan06 = g_wan[l_ac].wan06
             WHERE wan01 = g_wan01
               AND wan02 = g_wan02
               AND wan03 = g_wan03
               AND wan04 = g_wan04
               AND wan05 = g_wan_t.wan05
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wan[l_ac].wan06,SQLCA.sqlcode,0)
               LET g_wan[l_ac].* = g_wan_t.*
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
                LET g_wan[l_ac].* = g_wan_t.*
            END IF
            CLOSE aws_name_update_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_first = "Y" THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_wan[l_ac].wan06,-263,1)
               LET g_wan[l_ac].* = g_wan_t.*
            ELSE
               UPDATE wan_file
                  SET wan05 = g_wan[l_ac].wan05,
                      wan06 = g_wan[l_ac].wan06
                WHERE wan01 = g_wan01
                  AND wan02 = g_wan02
                  AND wan03 = g_wan03
                  AND wan04 = g_wan04
                  AND wan05 = g_wan_t.wan05
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wan[l_ac].wan06,SQLCA.sqlcode,0)
                  LET g_wan[l_ac].* = g_wan_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
         CLOSE  aws_name_update_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      AFTER INPUT
         LET g_first = "N"
 
   END INPUT
   CLOSE aws_name_update_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION aws_name_update_b_fill()
 
   CALL g_wan.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH wan_curs INTO g_wan[g_cnt].*       #單身 ARRAY 填充
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
   CALL g_wan.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
END FUNCTION
 
FUNCTION aws_name_update_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1,
          l_i    LIKe type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_wan TO aws_wan.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         LET l_i = aws_name_update_curr()
         CALL FGL_SET_ARR_CURR(l_i)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()
         LET l_ac = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice = 'detail'
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = FALSE
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice = 'help'
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice = 'exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
