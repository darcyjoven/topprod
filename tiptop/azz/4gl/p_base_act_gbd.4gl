# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: p_base_act_gbd.4gl
# Descriptions...: Action 資料內容變更 (p_base_act副程式,近 p_all_act功能)
# Date & Author..: 04/06/10 alex
# Modify.........: No.FUN-530022 05/03/17 By alex 修改 gbd_file index 加 gbd07
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770078 07/07/22 By Nicola 新增欄位異動日期(gbd11)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbd01          LIKE gbd_file.gbd01,   # Action ID
         g_gbd01_t        LIKE gbd_file.gbd01,
         g_gbd02          LIKE gbd_file.gbd02,   # Program ID (or STD)
         g_gbd02_t        LIKE gbd_file.gbd02,
         g_gaz03          LIKE gaz_file.gaz03,   # Program Name
         g_gbd    DYNAMIC ARRAY of RECORD        # 程式變數
            gbd03          LIKE gbd_file.gbd03,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
            gbd11          LIKE gbd_file.gbd11   #No.FUN-770078
                      END RECORD,
         g_gbd_t           RECORD                 # 變數舊值
            gbd03          LIKE gbd_file.gbd03,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
            gbd11          LIKE gbd_file.gbd11   #No.FUN-770078
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,    # 單身筆數        #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT        #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
FUNCTION p_base_act_gbd(l_gbd01,l_gbd02)
 
   DEFINE l_gbd01     LIKE gbd_file.gbd01
   DEFINE l_gbd02     LIKE gbd_file.gbd02
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_gbd01 = l_gbd01 CLIPPED
   LET g_gbd02 = l_gbd02 CLIPPED
   LET g_gbd01_t = NULL
   LET g_gbd02_t = NULL
   LET g_gaz03   = NULL
 
   # 2004/06/10 若為共用的話那要問一下
   IF g_gbd02 = "standard" THEN
      IF NOT cl_confirm("azz-041") THEN
         RETURN
      END IF
   END IF
 
   OPEN WINDOW p_base_act_gbd_w WITH FORM "azz/42f/p_base_act_gbd"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_base_act_gbd")
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gbd03")    
 
   # 2004/06/10 標準部分處理
   LET g_sql = "SELECT gbd03,gbd04,gbd05,gbd11 ",   #No.FUN-770078
                " FROM gbd_file ",
               " WHERE gbd01 = '",g_gbd01 CLIPPED,"' ",
                 " AND gbd02 = '",g_gbd02 CLIPPED,"' ",
                 " AND gbd07 = 'N' ",   #FUN-530022
               " ORDER BY gbd03"
 
   PREPARE p_base_act_gbd_prepare2 FROM g_sql 
   DECLARE act_gbd_curs CURSOR FOR p_base_act_gbd_prepare2
 
   # 2004/06/10 選取標準值
   SELECT gaz03 INTO g_gaz03 FROM gaz_file
     WHERE gaz01=g_gbd02 AND gaz02=g_lang  order by gaz05 #MOD-4A0206
 
   DISPLAY g_gbd01,g_gbd02,g_gaz03 TO gbd01,gbd02,gaz03
 
   CALL p_base_act_gbd_b_fill() 
   CALL p_base_act_gbd_menu() 
 
   CLOSE WINDOW p_base_act_gbd_w                       # 結束畫面
   RETURN
 
END FUNCTION
 
 
FUNCTION p_base_act_gbd_b_fill() 
 
    CALL g_gbd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH act_gbd_curs INTO g_gbd[g_cnt].*       #單身 ARRAY 填充
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
    CALL g_gbd.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
 
 
FUNCTION p_base_act_gbd_menu()
 
   WHILE TRUE
      CALL p_base_act_gbd_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_base_act_gbd_b()
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
 
 
FUNCTION p_base_act_gbd_b()                       # 單身
   
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,               #FUN-680135    SMALLINT # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5                # 暫存用數值    # No:FUN-BA0116
   DEFINE   lc_target       LIKE gay_file.gay01                # No:FUN-BA0116
 
   LET g_action_choice = ""
 
   IF cl_null(g_gbd01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbd03,gbd04,gbd05,gbd11 ",   #No.FUN-770078
                      " FROM gbd_file ",
                     "  WHERE gbd01 = ? AND gbd02 = ? AND gbd03 = ? ",
                       " AND gbd07 = 'N' ",
                       " FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_base_act_gbd_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbd WITHOUT DEFAULTS FROM sub_gbd.*
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
            LET g_gbd_t.* = g_gbd[l_ac].*  #BACKUP
            BEGIN WORK
 
            OPEN p_base_act_gbd_bcl USING g_gbd01,g_gbd02,g_gbd_t.gbd03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_base_act_gbd_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_base_act_gbd_bcl INTO g_gbd[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_base_act_gbd_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_gbd[l_ac].gbd11 = TODAY   #No.FUN-770078
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gbd[l_ac].* TO NULL       #900423
         LET g_gbd[l_ac].gbd11 = TODAY   #No.FUN-770078
         LET g_gbd_t.* = g_gbd[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gbd03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gbd_file(gbd01,gbd02,gbd03,gbd04,gbd05,gbd06,gbd07,gbd11)   #No.FUN-770078
                      VALUES (g_gbd01,g_gbd02,
                              g_gbd[l_ac].gbd03, g_gbd[l_ac].gbd04,
                              g_gbd[l_ac].gbd05,"N","N",g_gbd[l_ac].gbd11)  #FUN-530022   #No.FUN-770078
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gbd01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gbd_file",g_gbd01,g_gbd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbd_t.gbd04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gbd_file WHERE gbd01 = g_gbd01
                                   AND gbd02 = g_gbd02
                                   AND gbd03 = g_gbd[l_ac].gbd03
                                   AND gbd07 = 'N'   #FUN-530022
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbd_t.gbd04,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbd_file",g_gbd01,g_gbd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
         END IF
         COMMIT WORK

      ###FUN-B90139 START ###
      AFTER FIELD gbd04
         IF NOT cl_unicode_check02(g_gbd[l_ac].gbd03, g_gbd[l_ac].gbd04,"1") THEN
            NEXT FIELD gbd04
         END IF
         
      AFTER FIELD gbd05
         IF NOT cl_unicode_check02(g_gbd[l_ac].gbd03, g_gbd[l_ac].gbd05,"1") THEN
            NEXT FIELD gbd05
         END IF
      ###FUN-B90139 END ###
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbd[l_ac].* = g_gbd_t.*
            CLOSE p_base_act_gbd_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbd[l_ac].gbd04,-263,1)
            LET g_gbd[l_ac].* = g_gbd_t.*
         ELSE
            UPDATE gbd_file
               SET gbd03 = g_gbd[l_ac].gbd03,
                   gbd04 = g_gbd[l_ac].gbd04,
                   gbd05 = g_gbd[l_ac].gbd05,
                   gbd11 = g_gbd[l_ac].gbd11   #No.FUN-770078
             WHERE gbd01 = g_gbd01
               AND gbd02 = g_gbd02
               AND gbd03 = g_gbd_t.gbd03
               AND gbd07 = 'N'   #FUN-530022
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbd[l_ac].gbd03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbd_file",g_gbd01,g_gbd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbd[l_ac].* = g_gbd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
               LET g_gbd[l_ac].* = g_gbd_t.*   
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_base_act_gbd_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add 
         CLOSE p_base_act_gbd_bcl
         COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
          LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_gbd[l_ac].gbd03 = "0" LET lc_target = "2"
            WHEN g_gbd[l_ac].gbd03 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gbd.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            # 因為gbd01、gbd02歸在單頭，不屬於單身ARRAY中的資料
            IF g_gbd[li_i].gbd03 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gbd04)
                     LET g_gbd[l_ac].gbd04 = cl_trans_utf8_twzh(g_gbd[l_ac].gbd03,g_gbd[li_i].gbd04)
                     DISPLAY g_gbd[l_ac].gbd04 TO gbd04
                     EXIT FOR
                  WHEN INFIELD(gbd05)
                     LET g_gbd[l_ac].gbd05 = cl_trans_utf8_twzh(g_gbd[l_ac].gbd03,g_gbd[li_i].gbd05)
                     DISPLAY g_gbd[l_ac].gbd05 TO gbd05
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

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
 
 
   END INPUT
   CLOSE p_base_act_gbd_bcl
   COMMIT WORK
END FUNCTION
 
 
 
FUNCTION p_base_act_gbd_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gbd TO sub_gbd.* ATTRIBUTE(UNBUFFERED)
 
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
