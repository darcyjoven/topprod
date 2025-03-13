# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_item_set.4gl
# Descriptions...: s_item_set的副函式,控制ITEM設定
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_item01          LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_item01_t        LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_item03_h        LIKE gae_file.gae03,  
         g_item03_h_t      LIKE gae_file.gae03,
         g_item    DYNAMIC ARRAY of RECORD        # 程式變數
            gae03_co       LIKE gae_file.gae03,
            gae03_t        LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae05          LIKE gae_file.gae05,
            gae06          LIKE gae_file.gae06
                      END RECORD,
         g_item_t           RECORD                 # 變數舊值
            gae03_co       LIKE gae_file.gae03,
            gae03_t        LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae05          LIKE gae_file.gae05,
            gae06          LIKE gae_file.gae06
                      END RECORD,
         g_cnt2            LIKE type_file.num5,         #No.FUN-680147 SMALLINT
         g_mode            LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
         g_itm_b           LIKE type_file.num5,         #No.FUN-680147 SMALLINT   # 單身筆數
         l_ac              LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680147 SMALLINT
DEFINE   g_chr             LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
DEFINE   g_cnt             LIKE type_file.num10         #No.FUN-680147 INTEGER
DEFINE   g_msg             LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(72)
DEFINE   g_forupd_sql      STRING
DEFINE   g_curs_index      LIKE type_file.num10         #No.FUN-680147 INTEGER
 
FUNCTION s_item_set(p_gae01,p_gae03,p_mode)
   DEFINE   p_gae01        LIKE gae_file.gae01
   DEFINE   p_gae03        LIKE gae_file.gae03
   DEFINE   p_mode         LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
 
   LET g_item01_t = NULL
   LET g_item03_h_t = NULL
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW s_item_set_w AT 1,1 WITH FORM "sub/42f/s_item_set"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_item_set")
 
   LET g_item01 = p_gae01
   LET g_item03_h = p_gae03
   LET g_mode = p_mode
 
   CALL s_item_set_show()
   IF p_mode = 'b' THEN
      CALL s_item_set_b()
   ELSE
      CALL s_item_set_menu() 
   END IF
   CLOSE WINDOW s_item_set_w                       # 結束畫面
END FUNCTION
 
 
FUNCTION s_item_set_menu()
 
   WHILE TRUE
      CALL s_item_set_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL s_item_set_b()
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION s_item_set_show()                         # 將資料顯示在畫面上
   DISPLAY g_item01,g_item03_h TO gae01,gae03_h
   CALL s_item_set_b_fill()                    # 單身
END FUNCTION
 
 
FUNCTION s_item_set_b()                                  # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,         # 未取消的ARRAY CNT  #No.FUN-680147 SMALLINT
            l_n             LIKE type_file.num5,         # 檢查重複用         #No.FUN-680147 SMALLINT
            l_lock_sw       LIKE type_file.chr1,         # 單身鎖住否         #No.FUN-680147 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,         # 處理狀態           #No.FUN-680147 VARCHAR(1)
            l_allow_append  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
            l_allow_insert  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
            l_allow_delete  LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE   l_gae02         LIKE gae_file.gae02
 
   LET g_action_choice = ""
 
   LET g_forupd_sql= "SELECT gae03,'',gae04,gae05,gae06 ",
                     " FROM gae_file",
                     " WHERE gae01 = ? AND gae03 = ? ",
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_item_set_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   IF g_mode="a" THEN
      LET l_allow_insert=FALSE LET l_allow_delete=FALSE LET l_allow_append=FALSE
   ELSE
      LET l_allow_insert=TRUE  LET l_allow_delete=TRUE  LET l_allow_append=TRUE
   END IF
 
   INPUT ARRAY g_item WITHOUT DEFAULTS FROM s_item.*
              ATTRIBUTE(COUNT=g_itm_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_append)
      BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
         IF g_mode = "a" THEN
            CALL cl_set_comp_entry("gae03_t",FALSE)
         ELSE
            CALL cl_set_comp_entry("gae03_t",TRUE)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET g_item_t.* = g_item[l_ac].*    #BACKUP
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_itm_b >= l_ac THEN
            BEGIN WORK        #如果是從 menu 段串進來者,則需進入 transaction
            LET p_cmd='u'
            OPEN s_item_set_bcl USING g_item01,g_item_t.gae03_co
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN s_item_set_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH s_item_set_bcl INTO g_item[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_item_t.gae03_co,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL s_item_set_tail(g_item[l_ac].gae03_co,g_item03_h)
                    RETURNING g_item[l_ac].gae03_t
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         NEXT FIELD gae03_co
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_item[l_ac].* TO NULL       #900423
         LET g_item_t.* = g_item[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gae03_co
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CALL g_item.deleteElement(l_ac)   #取消 Array Element
            IF g_itm_b != 0 THEN   #單身有資料時取消新增而不離開輸入
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            EXIT INPUT
         END IF
 
         INSERT INTO gae_file(gae01,gae02,gae03,gae04,gae05,gae06,gae07,
                              gae08,gae09,gae10,gae11,gae12)
                      VALUES (g_item01,'Y',g_item[l_ac].gae03_co,
                              g_item[l_ac].gae04,g_item[l_ac].gae05,
                              g_item[l_ac].gae06,' ',' ',' ','N','N',' ')
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_item01,SQLCA.sqlcode,0)  #FUN-670091
              CALL cl_err3("ins","gae_file","","",STATUS,"","",0)  #FUN-670091
             LET g_item[l_ac].* = g_item_t.*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_itm_b = g_itm_b + 1
         END IF
 
      AFTER FIELD gae03_t
         IF NOT cl_null(g_item[l_ac].gae03_t) THEN
            LET g_item[l_ac].gae03_co=g_item03_h CLIPPED,'_',g_item[l_ac].gae03_t CLIPPED
            DISPLAY g_item[l_ac].gae03_co TO gae03
            IF g_item[l_ac].gae03_co != g_item_t.gae03_co OR g_item_t.gae03_co IS NULL THEN
               # 檢視 gae_file 中同一 Program Name (gae01) 下是否有相同的
               # Filed Name (gae03)
               SELECT COUNT(*) INTO l_n FROM gae_file
                WHERE gae01 = g_item01 AND gae03 = g_item[l_ac].gae03_co
               IF l_n > 0 THEN
                  CALL cl_err(g_item[l_ac].gae03_co,-239,0)
                  LET g_item[l_ac].gae03_co = g_item_t.gae03_co
                  NEXT FIELD gae03_t
               END IF
             END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_item_t.gae03_co) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM gae_file WHERE gae01 = g_item01
                                   AND gae03 = g_item[l_ac].gae03_co
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_item_t.gae03_co,SQLCA.sqlcode,0)  #FUN-670091
               CALL cl_err3("del","gae_file",g_item01,g_item[l_ac].gae03_co,STATUS,"","",0)  #FUN-670091
               ROLLBACK WORK 
               CANCEL DELETE
            END IF 
            LET g_itm_b = g_itm_b - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_item[l_ac].* = g_item_t.*
            CLOSE s_item_set_bcl
            ROLLBACK WORK 
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_item[l_ac].gae03_co,-263,1)
            LET g_item[l_ac].* = g_item_t.*
         ELSE
            UPDATE gae_file
               SET gae03 = g_item[l_ac].gae03_co,
                   gae04 = g_item[l_ac].gae04,
                   gae05 = g_item[l_ac].gae05,
                   gae06 = g_item[l_ac].gae06
             WHERE gae01 = g_item01
               AND gae03 = g_item_t.gae03_co
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_item[l_ac].gae03_co,SQLCA.sqlcode,0) #FUN-670091
                CALL cl_err3("upd","gae_file",g_item01,g_item[l_ac].gae03_co,STATUS,"","",0) #FUN-670091
               LET g_item[l_ac].* = g_item_t.*
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
            LET g_item[l_ac].* = g_item_t.*
            CLOSE s_item_set_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET g_item_t.* = g_item[l_ac].*
         CLOSE s_item_set_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON ACTION THROW_BACK
         SELECT gae02 INTO l_gae02 FROM gae_file
          WHERE gae01 = g_item01 AND gae03 = g_item_t.gae03_co
 
         display 'OLD gae03 = ',g_item[l_ac].gae03_co,' AND gae02 = ',l_gae02
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   CLOSE s_item_set_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION s_item_set_b_fill()              #BODY FILL UP
   DEFINE p_ac         LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
    LET g_forupd_sql = "SELECT gae03,'',gae04,gae05,gae06 ",
                        " FROM gae_file ",
                       " WHERE gae01 = '",g_item01 CLIPPED,"' ",
                         " AND gae02 = 'Y' ",
                         " AND gae03 MATCHES '",g_item03_h CLIPPED,"*' ",
                       " ORDER BY gae03"
 
    PREPARE s_item_set_prepare2 FROM g_forupd_sql
    DECLARE gae_item_curs CURSOR FOR s_item_set_prepare2
 
    CALL g_item.clear()
 
    LET g_cnt = 1
    LET g_itm_b = 0
 
    FOREACH gae_item_curs INTO g_item[g_cnt].*       #單身 ARRAY 填充
       LET g_itm_b = g_itm_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL s_item_set_tail(g_item[g_cnt].gae03_co,g_item03_h)
            RETURNING g_item[g_cnt].gae03_t
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION s_item_set_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_item TO s_item.* ATTRIBUTE(COUNT=g_itm_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION s_item_set_tail(pc_gae03,pc_gae03_h)
 
   DEFINE pc_gae03     LIKE gae_file.gae03
   DEFINE pc_gae03_h   LIKE gae_file.gae03
   DEFINE pc_gae03_t   LIKE gae_file.gae03
   DEFINE ps_gae03     STRING
   DEFINE ps_gae03_h   STRING
   DEFINE pi_start     LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE pi_end       LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
   LET ps_gae03 = pc_gae03 CLIPPED
   LET ps_gae03_h = pc_gae03_h CLIPPED
   LET pi_start = ps_gae03_h.getLength() + 2
   LET pi_end   = ps_gae03.getLength() 
   LET pc_gae03_t = ps_gae03.subString(pi_start,pi_end)
   RETURN pc_gae03_t
 
END FUNCTION
