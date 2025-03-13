# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_zx_tgrup.4gl
# Descriptions...: 群組管理人更新段副程式
# Input parameter: lc_zx01 群組代碼  
# Date & Author..: 06/02/21 alex  
# Modify.........: No.TQC-630208 06/03/21 By alex 單身新增權限群組編號時，應該控管權限群組是否存在        
#                                相關部門群組資料維護作業中
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zx01            LIKE zx_file.zx01,   # 類別代號 (假單頭)
         g_zx01_t          LIKE zx_file.zx01,   # 類別代號 (假單頭)
         g_zx02            LIKE zx_file.zx02,   # 類別代號 (假單頭)
         g_zyw    DYNAMIC ARRAY of RECORD       # 程式變數
            zyw01          LIKE zyw_file.zyw01,
            zyw02          LIKE zyw_file.zyw02,
            zyw03          STRING,
            gem02          STRING
                      END RECORD,
         g_zyw_t           RECORD                # 變數舊值
            zyw01          LIKE zyw_file.zyw01,
            zyw02          LIKE zyw_file.zyw02,
            zyw03          STRING,
            gem02          STRING
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,    # 單身筆數 #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
FUNCTION p_zx_tgrup(l_zx01)
 
   DEFINE l_zx01     LIKE zx_file.zx01
   DEFINE l_zx02     LIKE zx_file.zx02
   DEFINE li_i       LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_zx01 = l_zx01
   LET g_zx01_t = NULL
   SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_zx01
 
   OPEN WINDOW p_zx_tgrup_w WITH FORM "azz/42f/p_zx_tgrup"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_locale("p_zx_tgrup")
 
   DISPLAY g_zx01,g_zx02 TO zx01,zx02
 
   LET g_sql =" SELECT zyw01,zyw02 FROM zyw_file ",
               " WHERE zyw04 = '",g_zx01 CLIPPED,"' ",
                 " AND zyw05 = '1' ",
               " ORDER BY zyw01 "
 
   PREPARE p_zx_tgrup_pre FROM g_sql 
   DECLARE p_zx_tgrup_curs CURSOR FOR p_zx_tgrup_pre
 
   CALL p_zx_tgrup_b_fill() 
   CALL p_zx_tgrup_menu() 
 
   CLOSE WINDOW p_zx_tgrup_w                       # 結束畫面
 
   RETURN 
 
END FUNCTION
 
 
FUNCTION p_zx_tgrup_menu()
 
   WHILE TRUE
      CALL p_zx_tgrup_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zx_tgrup_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"                                 # Esc.結束
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zx_tgrup_b()                              # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zx01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zyw01,zyw02 ",
                     "  FROM zyw_file",
                     "  WHERE zyw01=? AND zyw05='1' AND zyw04=? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zx_tgrup_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_zyw WITHOUT DEFAULTS FROM azz_zyw.*
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
            #CKP
            LET p_cmd='u'
            LET g_zyw_t.* = g_zyw[l_ac].*  #BACKUP
            BEGIN WORK
            LET p_cmd='u'
            OPEN p_zx_tgrup_bcl USING g_zyw_t.zyw01,g_zx01
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zx_tgrup_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zx_tgrup_bcl INTO g_zyw[l_ac].zyw01,g_zyw[l_ac].zyw02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_zx_tgrup_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL p_zx_tgrup_list(g_zyw[l_ac].zyw01)
                       RETURNING g_zyw[l_ac].zyw03,g_zyw[l_ac].gem02
                  DISPLAY g_zyw[l_ac].zyw03,g_zyw[l_ac].gem02 TO zyw03,gem02
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_zyw[l_ac].* TO NULL       #900423
         LET g_zyw_t.* = g_zyw[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zyw01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO zyw_file(zyw01,zyw02,zyw04,zyw05,zyworiu,zyworig)
                      VALUES (g_zyw[l_ac].zyw01,g_zyw[l_ac].zyw02,
                              g_zx01,'1', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_zyw[l_ac].zyw01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","zyw_file",g_zyw[l_ac].zyw01,g_zyw[l_ac].zyw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zyw_t.zyw01) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM zyw_file WHERE zyw01 = g_zyw[l_ac].zyw01
                                   AND (zyw02 = g_zyw[l_ac].zyw02 OR zyw02 IS NULL)   #No.TQC-630208 modify
                                   AND zyw04 = g_zx01
                                   AND zyw05 = '1'
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw_t.zyw01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zyw_file",g_zyw_t.zyw01,g_zx01,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      AFTER FIELD zyw01
         IF NOT cl_null(g_zyw[l_ac].zyw01) THEN
          #-----No.TQC-630208 add 判斷群組代碼是否存在
            SELECT COUNT(*) INTO l_n FROM zyw_file 
               WHERE zyw01 = g_zyw[l_ac].zyw01
               AND zyw05='0'
             IF l_n <= 0 THEN
                  CALL cl_err('','azz-240',0)
                  LET g_zyw[l_ac].zyw01 = g_zyw_t.zyw01
                  NEXT FIELD zyw01
             END IF
             LET l_n = 0 
          #-----No.TQC-630208 end
            SELECT count(*) INTO l_n FROM zyw_file 
             WHERE zyw01 = g_zyw[l_ac].zyw01
               AND zyw02 = g_zyw[l_ac].zyw02
               AND zyw04 = g_zx01
               AND zyw05 = '1'
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_zyw[l_ac].zyw01 = g_zyw_t.zyw01
               NEXT FIELD zyw01
            ELSE
               CALL p_zx_tgrup_list(g_zyw[l_ac].zyw01)
                    RETURNING  g_zyw[l_ac].zyw03,g_zyw[l_ac].gem02
               DISPLAY g_zyw[l_ac].zyw03,g_zyw[l_ac].gem02
                    TO zyw03,gem02
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zyw[l_ac].* = g_zyw_t.*
            CLOSE p_zx_tgrup_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zyw[l_ac].zyw01,-263,1)
            LET g_zyw[l_ac].* = g_zyw_t.*
         ELSE
            UPDATE zyw_file
               SET zyw01 = g_zyw[l_ac].zyw01,
                   zyw02 = g_zyw[l_ac].zyw02
             WHERE zyw01 = g_zyw_t.zyw01
               AND zyw02 = g_zyw_t.zyw02
               AND zyw04 = g_zx01
               AND zyw05 = '1'
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw[l_ac].zyw01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zyw_file",g_zyw_t.zyw01,g_zyw_t.zyw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zyw[l_ac].* = g_zyw_t.*
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
            #CKP
            IF p_cmd='u' THEN
                LET g_zyw[l_ac].* = g_zyw_t.*   
            END IF
            CLOSE p_zx_tgrup_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         #CKP
         #LET g_zyw_t.* = g_zyw[l_ac].*          # 900423
         CLOSE p_zx_tgrup_bcl
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
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zyw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zyw"
               LET g_qryparam.default1 = g_zyw[l_ac].zyw01
               CALL cl_create_qry() RETURNING g_zyw[l_ac].zyw01
               DISPLAY g_zyw[l_ac].zyw01 TO zyw01
         END CASE
 
   END INPUT
   CLOSE p_zx_tgrup_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zx_tgrup_b_fill() 
 
    DEFINE li_gotsys  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
    CALL g_zyw.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    LET li_gotsys = 0
    FOREACH p_zx_tgrup_curs INTO g_zyw[g_cnt].zyw01,g_zyw[g_cnt].zyw02  
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          CALL p_zx_tgrup_list(g_zyw[g_cnt].zyw01)
          RETURNING g_zyw[g_cnt].zyw03,g_zyw[g_cnt].gem02
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_zyw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_zx_tgrup_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_zyw TO azz_zyw.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()                #No.FUN-550037 hmf
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
         LET INT_FLAG=FALSE                      #MOD-570244 mars
         LET g_action_choice="exit"
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
 
      ON ACTION help  
         CALL cl_show_help()
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zx_tgrup_list(lc_zyw01)
 
   DEFINE lc_zyw01    LIKE zyw_file.zyw01
   DEFINE lc_zyw03    LIKE zyw_file.zyw03
   DEFINE lc_gem02    LIKE gem_file.gem02
   DEFINE ls_zyw03    STRING
   DEFINE ls_gem02    STRING
   DEFINE ls_sql      STRING
 
   LET ls_sql =" SELECT zyw03 FROM zyw_file ",
                " WHERE zyw01 = '",lc_zyw01 CLIPPED,"' ",
                  " AND zyw05 = '0' ",
                " ORDER BY zyw03 "
 
   PREPARE p_zx_tglist_pre FROM ls_sql 
   DECLARE p_zx_tglist_curs CURSOR FOR p_zx_tglist_pre
 
   LET ls_zyw03 = ''  LET ls_gem02 = ''
   FOREACH p_zx_tglist_curs INTO lc_zyw03
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         SELECT gem02 INTO lc_gem02 FROM gem_file WHERE gem01=lc_zyw03
         LET ls_zyw03 = ls_zyw03.trim(),lc_zyw03 CLIPPED,","
         LET ls_gem02 = ls_gem02.trim(),lc_gem02 CLIPPED,","
      END IF
   END FOREACH
 
   LET ls_zyw03=ls_zyw03.subString(1,ls_zyw03.getLength()-1)
   LET ls_gem02=ls_gem02.subString(1,ls_gem02.getLength()-1)
 
   RETURN ls_zyw03.trim(),ls_gem02.trim()
 
END FUNCTION
 
 
