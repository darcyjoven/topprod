# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_itemname_update.4gl
# Descriptions...: 使用多語言記錄功能更新段副程式
# Input parameter: l_gbc01 檔案代碼  (Table ID)   Ex. zx_file
#                  l_gbc02 欄位代碼                   zx02
#                  l_gbc03 KEY 值序列,多組時以,隔開   hjwang
#                  l_gbc05 目前語言別下所需欄位值     Name of hjwang
# Return code....: l_gbc05 目前語言別下所需欄位值     Name of hjwang
# Date & Author..: 04/12/31 alex  
# Memo...........: 需同時搭配 cl_itemname_by_lang() 抓取修正完成的值用 gbc_file
# Modify.........: No.FUN-550011 05/05/07 By alex 依建議方式進行流程調整
# Modify.........: No.FUN-550077 05/05/23 By alex 接收到值後就先更新資料
# Modify.........: No.MOD-610148 06/01/25 By kevin 將lc_gbc05改成l_gbc05
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbc01          LIKE gbc_file.gbc01,   # 類別代號 (假單頭)
         g_gbc01_t        LIKE gbc_file.gbc01,   # 類別代號 (假單頭)
         g_gbc02          LIKE gbc_file.gbc02,   # 類別代號 (假單頭)
         g_gbc02_t        LIKE gbc_file.gbc02,   # 類別代號 (假單頭)
         g_gbc03          LIKE gbc_file.gbc03,   # 類別代號 (假單頭)
         g_gbc03_t        LIKE gbc_file.gbc03,   # 類別代號 (假單頭)
         g_gbc    DYNAMIC ARRAY of RECORD        # 程式變數
            gbc04          LIKE gbc_file.gbc04,
            gbc05          LIKE gbc_file.gbc05
                      END RECORD,
         g_gbc_t           RECORD                 # 變數舊值
            gbc04          LIKE gbc_file.gbc04,
            gbc05          LIKE gbc_file.gbc05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,    # 單身筆數    #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT    #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
#DEFINE   g_curr_gbc05          LIKE gbc_file.gbc05    #TQC-6C0060 mark
 
#FUNCTION p_itemname_update(l_gbc01,l_gbc02,l_gbc03,l_gbc05)  #TQC-6C0060 mark
FUNCTION p_itemname_update(l_gbc01,l_gbc02,l_gbc03)
 
   DEFINE l_gbc01     LIKE gbc_file.gbc01
   DEFINE l_gbc02     LIKE gbc_file.gbc02
   DEFINE l_gbc03     LIKE gbc_file.gbc03
  #DEFINE l_gbc05     LIKE gbc_file.gbc05  #TQC-6C0060 mark
   DEFINE l_zx14      LIKE zx_file.zx14
   DEFINE l_zx14_t    LIKE zx_file.zx14 
   DEFINE li_i        LIKE type_file.num10   #FUN-680135 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #IF g_aza.aza44<>"Y" THEN  #TQC-6C0060 mark
  #   RETURN l_gbc05 CLIPPED
  #END IF
 
   LET g_gbc01 = l_gbc01
   LET g_gbc02 = l_gbc02
   LET g_gbc03 = l_gbc03
   LET g_gbc01_t = NULL
   LET g_gbc02_t = NULL
   LET g_gbc03_t = NULL
  #LET g_curr_gbc05 = l_gbc05 CLIPPED  #TQC-6C0060 mark
 
  #IF NOT cl_null(g_curr_gbc05) THEN  #TQC-6C0060 mark
  #   SELECT * FROM gbc_file WHERE gbc01 = g_gbc01 AND gbc02 = g_gbc02
  #                            AND gbc03 = g_gbc03 AND gbc04 = g_lang
  #   IF SQLCA.sqlcode THEN
  #      INSERT INTO gbc_file (gbc01,gbc02,gbc03,gbc04,gbc05)
  #          VALUES( g_gbc01, g_gbc02, g_gbc03, g_lang, l_gbc05 ) #MOD-610148
  #   ELSE
  #      UPDATE gbc_file SET gbc05 = l_gbc05  #MOD-610148
  #       WHERE gbc01 = g_gbc01 AND gbc02 = g_gbc02 AND gbc03 = g_gbc03
  #         AND gbc04 = g_lang
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err("!",SQLCA.SQLCODE,0)
  #      END IF
  #   END IF
  #END IF
 
   LET l_zx14_t = g_zx14
   IF g_zx14="Y" THEN
      LET l_zx14="V"
   ELSE
      LET l_zx14=" "
   END IF
 
   OPEN WINDOW p_itemname_update_w WITH FORM "azz/42f/p_itemname_update"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_locale("p_itemname_update")
   CALL cl_set_combo_lang("gbc04")
   CALL cl_set_comp_lab_text("update_zx14",l_zx14)
   IF g_user <> "tiptop" THEN
      CALL cl_set_comp_visible("group01", FALSE)
   END IF
 
   DISPLAY g_gbc01,g_gbc02,g_gbc03 TO gbc01,gbc02,gbc03
 
   LET g_sql = "SELECT gbc04,gbc05 FROM gbc_file ",
               " WHERE gbc01 = '",g_gbc01 CLIPPED,"' ",
                 " AND gbc02 = '",g_gbc02 CLIPPED,"' ",
                 " AND gbc03 = '",g_gbc03 CLIPPED,"' ",
               " ORDER BY gbc04"
 
   PREPARE p_itemname_update_prepare2 FROM g_sql 
   DECLARE gbc_curs CURSOR FOR p_itemname_update_prepare2
 
   CALL p_itemname_update_b_fill() 
   CALL p_itemname_update_menu() 
 
   CALL cl_set_comp_visible("group01", TRUE)
   CLOSE WINDOW p_itemname_update_w                       # 結束畫面
 
   IF g_zx14 <> l_zx14_t THEN
      UPDATE zx_file SET zx14=g_zx14 WHERE zx01=g_user
   END IF
 
  #LET li_i = p_itemname_update_curr()  #TQC-6C0060 mark
  #IF li_i = 0 THEN  #TQC-6C0060 mark
  #   RETURN l_gbc05 CLIPPED
  #END IF
 
  #RETURN g_gbc[li_i].gbc05 CLIPPED  #TQC-6C0060 mark
 
END FUNCTION
 
#FUNCTION p_itemname_update_curr()  #TQC-6C0060 mark
 
#  DEFINE li_i       LIKE type_file.num10   #FUN-680135 INTEGER
 
#  FOR li_i = 1 TO g_gbc.getLength()
#     IF g_gbc[li_i].gbc04 CLIPPED = g_lang CLIPPED THEN
#        EXIT FOR
#     END IF
#  END FOR
 
#  IF li_i = g_gbc.getLength() AND g_gbc[li_i].gbc04 CLIPPED <> g_lang CLIPPED THEN
#     RETURN 0
#  END IF
 
#  RETURN li_i
 
#END FUNCTION
 
FUNCTION p_itemname_update_menu()
 
   WHILE TRUE
      CALL p_itemname_update_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_itemname_update_b()
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
 
 
FUNCTION p_itemname_update_b()                      # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,    # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,    # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   l_zx14          LIKE zx_file.zx14
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbc01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   #FUN-530027 在進入時已查核過權限, 此處不必重新再檢查
   LET l_allow_insert = TRUE
   LET l_allow_delete = TRUE
#  LET l_allow_insert = cl_detail_input_auth("insert")
#  LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbc04,gbc05 ",
                     "  FROM gbc_file",
                     "  WHERE gbc01=? AND gbc02=? AND gbc03=? AND gbc04=? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_itemname_update_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbc WITHOUT DEFAULTS FROM azz_gbc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         #CKP
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         #CKP
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            #CKP
            LET p_cmd='u'
            LET g_gbc_t.* = g_gbc[l_ac].*  #BACKUP
            BEGIN WORK
            LET p_cmd='u'
            OPEN p_itemname_update_bcl
                 USING g_gbc01,g_gbc02,g_gbc03,g_gbc_t.gbc04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_itemname_update_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_itemname_update_bcl INTO g_gbc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_itemname_update_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         #CKP
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gbc[l_ac].* TO NULL       #900423
         LET g_gbc_t.* = g_gbc[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gbc04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO gbc_file(gbc01,gbc02,gbc03,gbc04,gbc05)
                      VALUES (g_gbc01,g_gbc02,g_gbc03,
                              g_gbc[l_ac].gbc04,g_gbc[l_ac].gbc05)
         IF SQLCA.sqlcode THEN
             CALL cl_err(g_gbc[l_ac].gbc05,SQLCA.sqlcode,0)
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbc_t.gbc04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM gbc_file WHERE gbc01 = g_gbc01
                                   AND gbc02 = g_gbc02
                                   AND gbc03 = g_gbc03
                                   AND gbc04 = g_gbc[l_ac].gbc04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gbc_t.gbc05,SQLCA.sqlcode,0)
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
            LET g_gbc[l_ac].* = g_gbc_t.*
            CLOSE p_itemname_update_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbc[l_ac].gbc05,-263,1)
            LET g_gbc[l_ac].* = g_gbc_t.*
         ELSE
            UPDATE gbc_file
               SET gbc04 = g_gbc[l_ac].gbc04,
                   gbc05 = g_gbc[l_ac].gbc05
             WHERE gbc01 = g_gbc01
               AND gbc02 = g_gbc02
               AND gbc03 = g_gbc03
               AND gbc04 = g_gbc_t.gbc04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gbc[l_ac].gbc05,SQLCA.sqlcode,0)
               LET g_gbc[l_ac].* = g_gbc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac         #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
                LET g_gbc[l_ac].* = g_gbc_t.*   
            #FUN-D30034---add---str---
            ELSE
               CALL g_gbc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_itemname_update_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         #CKP
         #LET g_gbc_t.* = g_gbc[l_ac].*          # 900423
         LET l_ac_t = l_ac         #FUN-D30034 add
         CLOSE p_itemname_update_bcl
         COMMIT WORK
 
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
 
      ON ACTION update_zx14
         IF g_zx14="Y" THEN
            LET g_zx14="N" 
            LET l_zx14=" "
         ELSE
            LET g_zx14="Y" 
            LET l_zx14="V"
         END IF
         CALL cl_set_comp_lab_text("update_zx14",l_zx14)
 
   END INPUT
   CLOSE p_itemname_update_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_itemname_update_b_fill() 
 
    DEFINE li_gotsys  LIKE type_file.num5    #FUN-680135 SMALLINT
 
    CALL g_gbc.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    LET li_gotsys = 0
    FOREACH gbc_curs INTO g_gbc[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      #ELSE  #TQC-6C0060 mark
      #   IF g_gbc[g_cnt].gbc04 = g_lang THEN
      #      LET g_gbc[g_cnt].gbc05 = g_curr_gbc05
      #   END IF
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gbc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_itemname_update_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
   DEFINE   l_zx14 LIKE zx_file.zx14
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gbc TO azz_gbc.* ATTRIBUTE(UNBUFFERED)
 
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
 
      ON ACTION update_zx14
         IF g_zx14="Y" THEN
            LET g_zx14="N" 
            LET l_zx14=" "
         ELSE
            LET g_zx14="Y" 
            LET l_zx14="V"
         END IF
         CALL cl_set_comp_lab_text("update_zx14",l_zx14)
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
