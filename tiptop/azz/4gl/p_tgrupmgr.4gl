# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_tgrupmgr.4gl
# Descriptions...: 群組管理人更新段副程式
# Date & Author..: 06/02/21 alex  
# Input parameter: lc_zyw01 群組代碼  
# Modify.........: No.TQC-640030 06/04/07 By pengu 單身新增時在zyw04(管理人員編號)欄位會去判斷是否重複，但應加一判斷
#                                若為新增時再做此判斷，否則會造成在修改時一直卡在此欄位無法往下走
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-7A0138 07/10/25 By Pengu 因為zyw03資料庫設為not null，所以會造成無法新增
# Modify.........: No.MOD-880238 08/08/28 By alexstar 開窗選擇後應回傳姓名與部門資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zyw01          LIKE zyw_file.zyw01,   # 類別代號 (假單頭)
         g_zyw02          LIKE zyw_file.zyw02,   # 類別代號 (假單頭)
         g_zyw    DYNAMIC ARRAY of RECORD        # 程式變數
            zyw04          LIKE zyw_file.zyw04,
            zx02           LIKE zx_file.zx02,
            zx03           LIKE zx_file.zx03,
            gem02          LIKE gem_file.gem02
                      END RECORD,
         g_zyw_t           RECORD                # 變數舊值
            zyw04          LIKE zyw_file.zyw04,
            zx02           LIKE zx_file.zx02,
            zx03           LIKE zx_file.zx03,
            gem02          LIKE gem_file.gem02
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,    # 單身筆數             #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
FUNCTION p_tgrupmgr(l_zyw01,l_zyw02)
 
   DEFINE l_zyw01     LIKE zyw_file.zyw01
   DEFINE l_zyw02     LIKE zyw_file.zyw02
   DEFINE li_i        LIKE type_file.num10             #No.FUN-680135 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_zyw01 = l_zyw01
   LET g_zyw02 = l_zyw02
 
   OPEN WINDOW p_tgrupmgr_w WITH FORM "azz/42f/p_tgrupmgr"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_locale("p_tgrupmgr")
 
   DISPLAY g_zyw01,g_zyw02 TO zyw01,zyw02
 
   LET g_sql = "SELECT zyw04,zx02,zx03,gem02 FROM zyw_file,OUTER zx_file, OUTER gem_file ",
               " WHERE zyw01 = '",g_zyw01 CLIPPED,"' ",
                 " AND zyw02 = '",g_zyw02 CLIPPED,"' ",
                 " AND zyw05 = '1' ",
                 " AND zx01 = zyw04 AND gem01 = zx03 ",
               " ORDER BY zyw04 "
 
   PREPARE p_tgrupmgr_prepare2 FROM g_sql 
   DECLARE zyw_curs CURSOR FOR p_tgrupmgr_prepare2
 
   CALL p_tgrupmgr_b_fill() 
   CALL p_tgrupmgr_menu() 
 
   CLOSE WINDOW p_tgrupmgr_w                       # 結束畫面
 
   RETURN 
 
END FUNCTION
 
 
FUNCTION p_tgrupmgr_menu()
 
   WHILE TRUE
      CALL p_tgrupmgr_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_tgrupmgr_b()
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
 
 
FUNCTION p_tgrupmgr_b()                              # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135      SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zyw01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zyw04,'','','' ",
                     "  FROM zyw_file",
                     "  WHERE zyw01=? AND zyw02=? AND zyw04=? ",
                       " AND zyw05= '1' ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_tgrupmgr_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
            LET p_cmd='u'
            LET g_zyw_t.* = g_zyw[l_ac].*  #BACKUP
            BEGIN WORK
            LET p_cmd='u'
            OPEN p_tgrupmgr_bcl
                 USING g_zyw01,g_zyw02,g_zyw_t.zyw04
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_tgrupmgr_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_tgrupmgr_bcl INTO g_zyw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_tgrupmgr_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT zx02,zx03,gem02
                    INTO g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                    FROM zx_file,OUTER gem_file
                   WHERE zx01=g_zyw[l_ac].zyw04 AND gem01=zx03
                  DISPLAY g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                       TO zx02,zx03,gem02
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
         NEXT FIELD zyw04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zyw_file(zyw01,zyw02,zyw03,zyw04,zyw05,zyworiu,zyworig)    #No.MOD-7A0138 add zyw03
                      VALUES (g_zyw01,g_zyw02,' ',              #No.MOD-7A0138 modify
                              g_zyw[l_ac].zyw04,'1', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_zyw[l_ac].zyw04,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","zyw_file",g_zyw01,g_zyw[l_ac].zyw04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_zyw_t.zyw04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM zyw_file WHERE zyw01 = g_zyw01
                                   AND zyw02 = g_zyw02
                                   AND zyw04 = g_zyw[l_ac].zyw04
                                   AND zyw05 = '1'
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw_t.zyw04,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zyw_file",g_zyw01,g_zyw_t.zyw04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      AFTER FIELD zyw04
         IF NOT cl_null(g_zyw[l_ac].zyw04) THEN
            SELECT count(*) INTO l_n FROM zyw_file 
             WHERE zyw01 = g_zyw01
                   AND zyw02 = g_zyw02
                   AND zyw04 = g_zyw[l_ac].zyw04
                   AND zyw05 = '1'
            IF l_n > 0 AND p_cmd='a' THEN      #No.TQC-640030 modify
               CALL cl_err('',-239,0)
               LET g_zyw[l_ac].zyw04 = g_zyw_t.zyw04
               NEXT FIELD zyw04
            ELSE
               SELECT zx02,zx03,gem02
                 INTO g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                 FROM zx_file,OUTER gem_file
                WHERE zx01=g_zyw[l_ac].zyw04 AND gem01=zx03
               DISPLAY g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                    TO zx02,zx03,gem02
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zyw[l_ac].* = g_zyw_t.*
            CLOSE p_tgrupmgr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zyw[l_ac].zyw04,-263,1)
            LET g_zyw[l_ac].* = g_zyw_t.*
         ELSE
            UPDATE zyw_file
               SET zyw04 = g_zyw[l_ac].zyw04
             WHERE zyw01 = g_zyw01
               AND zyw02 = g_zyw02
               AND zyw04 = g_zyw_t.zyw04
               AND zyw05 = '1'
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zyw[l_ac].zyw04,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zyw_file",g_zyw01,g_zyw_t.zyw04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zyw[l_ac].* = g_zyw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30034
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
                LET g_zyw[l_ac].* = g_zyw_t.*   
            #FUN-D30034--add--str--
            ELSE
               CALL g_zyw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_tgrupmgr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         #CKP
         #LET g_zyw_t.* = g_zyw[l_ac].*          # 900423
         CLOSE p_tgrupmgr_bcl
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
            WHEN INFIELD(zyw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               LET g_qryparam.default1 = g_zyw[l_ac].zyw04
               CALL cl_create_qry() RETURNING g_zyw[l_ac].zyw04
               DISPLAY g_zyw[l_ac].zyw04 TO zyw04
 
#MOD-880238---start---
               SELECT zx02,zx03,gem02
                 INTO g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                 FROM zx_file,OUTER gem_file
                WHERE zx01=g_zyw[l_ac].zyw04 AND gem01=zx03
 
               DISPLAY g_zyw[l_ac].zx02,g_zyw[l_ac].zx03,g_zyw[l_ac].gem02
                    TO zx02,zx03,gem02
#MOD-880238---end---
         END CASE
 
   END INPUT
   CLOSE p_tgrupmgr_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_tgrupmgr_b_fill() 
 
    DEFINE li_gotsys  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
    CALL g_zyw.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    LET li_gotsys = 0
    FOREACH zyw_curs INTO g_zyw[g_cnt].*       #單身 ARRAY 填充
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
    CALL g_zyw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_tgrupmgr_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
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
 
 
