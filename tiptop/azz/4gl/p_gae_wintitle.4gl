# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_gae_wintitle.4gl
# Descriptions...: 在 p_qry 中協助修改 wintitle 的副程式
# Modify.........: No.FUN-4C0107 04/12/31 alex 修改 function name
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-760049 07/07/18 By saki 增加Key - 行業別代碼
# Modify.........: No.FUN-810060 08/01/22 By alex 修改版號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0006 13/01/18 By Zong-Yi 簡繁轉換功能
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-810060
 
DEFINE   sg_gae01          LIKE gae_file.gae01,   # 類別代號 (假單頭)
         sg_gae01_t        LIKE gae_file.gae01,   # 類別代號 (假單頭)
         sg_gae12          LIKE gae_file.gae12,   # 行業別代碼  No.FUN-760049
         sg_gae12_t        LIKE gae_file.gae12,   # 行業別代碼  No.FUN-760049
         sg_gae    DYNAMIC ARRAY of RECORD        # 程式變數
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae11          LIKE gae_file.gae11
                      END RECORD,
         sg_gae_t           RECORD                 # 變數舊值
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae11          LIKE gae_file.gae11
                      END RECORD,
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,     # 單身筆數    #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5      # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
FUNCTION p_gae_wintitle(l_gae01,l_gae12)                #No.FUN-760049
 
   DEFINE l_gae01     LIKE gae_file.gae01
   DEFINE l_gae12     LIKE gae_file.gae12
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET sg_gae01 = l_gae01
   LET sg_gae01_t = NULL
   LET sg_gae12 = l_gae12    #No.FUN-760049
   LET sg_gae12_t = NULL     #No.FUN-760049
 
   OPEN WINDOW p_gae_wintitle_w WITH FORM "azz/42f/p_gae_wintitle"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_gae_wintitle")
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("sgae03")    
 
   DISPLAY sg_gae01 TO sgae01
 
   LET g_sql = "SELECT gae03,gae04,gae11 ",
                " FROM gae_file ",
               " WHERE gae01='",sg_gae01 CLIPPED,"' ",
                 " AND gae02='wintitle' ",
               "   AND gae12='",sg_gae12 CLIPPED,"' ",   #No.FUN-760049
               " ORDER BY gae11,gae03 "
 
   PREPARE p_gae_wintitle_prepare2 FROM g_sql 
   DECLARE gae_curs CURSOR FOR p_gae_wintitle_prepare2
 
   CALL p_gae_wintitle_b_fill() 
   CALL p_gae_wintitle_menu() 
 
   CLOSE WINDOW p_gae_wintitle_w                       # 結束畫面
 
   CALL cl_err(sg_gae01,"azz-084",1)
 
   RETURN
END FUNCTION
 
 
FUNCTION p_gae_wintitle_menu()
 
   WHILE TRUE
      CALL p_gae_wintitle_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_gae_wintitle_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_gae_wintitle_b()                       # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT SMALLINT
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5      #FUN-680135    SMALLINT 
   DEFINE   li_i            LIKE type_file.num5      #FUN-CB0006
   DEFINE   lc_target       LIKE gay_file.gay01      #FUN-CB0006
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(sg_gae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gae03,gae04,gae11 ",
                     "  FROM gae_file",
                     "  WHERE gae01=? AND gae02='wintitle' ",
                       " AND gae03=? AND gae11=? AND gae12=? ",   #No.FUN-760049
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gae_wintitle_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY sg_gae WITHOUT DEFAULTS FROM sub_gae.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET sg_gae_t.* = sg_gae[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN p_gae_wintitle_bcl USING sg_gae01,sg_gae_t.gae03,sg_gae_t.gae11,sg_gae12    #No.FUN-760049
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_gae_wintitle_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gae_wintitle_bcl INTO sg_gae[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_gae_wintitle_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE sg_gae[l_ac].* TO NULL 
         LET sg_gae[l_ac].gae11 = 'N'
         LET sg_gae_t.* = sg_gae[l_ac].* 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD sgae03
 
      AFTER FIELD sgae03
         IF sg_gae[l_ac].gae03 != sg_gae_t.gae03 OR sg_gae_t.gae03 IS NULL THEN
            LET l_count=0
            SELECT count(*) INTO l_count FROM gae_file
             WHERE gae01=sg_gae01 AND gae02='wintitle'
               AND gae03=sg_gae[l_ac].gae03
               AND gae11=sg_gae[l_ac].gae11
               AND gae12=sg_gae12               #No.FUN-760049
            IF l_count > 0 THEN
               CALL cl_err(sg_gae[l_ac].gae04,-239,1)
               LET sg_gae[l_ac].gae11 = sg_gae_t.gae03
               NEXT FIELD sgae03
            END IF
         END IF
 
      AFTER FIELD sgae11
         IF sg_gae[l_ac].gae11 != sg_gae_t.gae11 OR sg_gae_t.gae11 IS NULL THEN
            LET l_count=0
            SELECT count(*) INTO l_count FROM gae_file
             WHERE gae01=sg_gae01 AND gae02='wintitle'
               AND gae03=sg_gae[l_ac].gae03
               AND gae11=sg_gae[l_ac].gae11
               AND gae12=sg_gae12     #No.FUN-760049
            IF l_count > 0 THEN
               CALL cl_err(sg_gae[l_ac].gae04,-239,1)
               LET sg_gae[l_ac].gae11 = sg_gae_t.gae11
               NEXT FIELD sgae11
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gae_file(gae01,gae02,gae03,gae04,gae11,gae12)      #No.FUN-760049
            VALUES (sg_gae01,'wintitle', sg_gae[l_ac].gae03,
                    sg_gae[l_ac].gae04,  sg_gae[l_ac].gae11, sg_gae12)  #No.FUN-760049
         IF SQLCA.sqlcode THEN
             #CALL cl_err(sg_gae01,SQLCA.sqlcode,1)  #No.FUN-660081
             CALL cl_err3("ins","gae_file",sg_gae01,sg_gae[l_ac].gae03,SQLCA.sqlcode,"","",1)   #No.FUN-660081
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(sg_gae_t.gae03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM gae_file WHERE gae01 = sg_gae01
                                   AND gae02 = 'wintitle'
                                   AND gae03 = sg_gae[l_ac].gae03
                                   AND gae11 = sg_gae[l_ac].gae11
                                   AND gae12 = sg_gae12           #No.FUN-760049
            IF SQLCA.sqlcode THEN
               #CALL cl_err(sg_gae_t.gae03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gae_file",sg_gae01,sg_gae_t.gae03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
         END IF
         COMMIT WORK

      #FUN-CB0006 start
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN sg_gae[l_ac].gae03 = "0" LET lc_target = "2"
            WHEN sg_gae[l_ac].gae03 = "2" LET lc_target = "0"
         END CASE
         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO sg_gae.getLength()
            IF sg_gae[li_i].gae03 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(sgae04)
                     LET sg_gae[l_ac].gae04 = cl_trans_utf8_twzh(sg_gae[l_ac].gae03,sg_gae[li_i].gae04)
                     DISPLAY sg_gae[l_ac].gae04 TO sgae04
                     EXIT FOR
                END CASE
            END IF
         END FOR
      #FUN-CB0006 END
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET sg_gae[l_ac].* = sg_gae_t.*
            CLOSE p_gae_wintitle_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(sg_gae[l_ac].gae03,-263,1)
            LET sg_gae[l_ac].* = sg_gae_t.*
         ELSE
            UPDATE gae_file
               SET gae03 = sg_gae[l_ac].gae03,
                   gae04 = sg_gae[l_ac].gae04,
                   gae11 = sg_gae[l_ac].gae11
             WHERE gae01 = sg_gae01
               AND gae02 = 'wintitle'  
               AND gae03 = sg_gae_t.gae03
               AND gae11 = sg_gae_t.gae11
               AND gae12 = sg_gae12             #No.FUN-760049
            IF SQLCA.sqlcode THEN
               #CALL cl_err(sg_gae[l_ac].gae04,SQLCA.sqlcode,1)  #No.FUN-660081
               CALL cl_err3("upd","gae_file",sg_gae01,sg_gae_t.gae03,SQLCA.sqlcode,"","",1)   #No.FUN-660081
               LET sg_gae[l_ac].* = sg_gae_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac            #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET sg_gae[l_ac].* = sg_gae_t.*   
            #FUN-D30034---add---str---
            ELSE
               CALL sg_gae.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_gae_wintitle_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac            #FUN-D30034 add
         CLOSE p_gae_wintitle_bcl
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
 
   END INPUT
   CLOSE p_gae_wintitle_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gae_wintitle_b_fill() 
 
    CALL sg_gae.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH gae_curs INTO sg_gae[g_cnt].*       #單身 ARRAY 填充
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
 
    CALL sg_gae.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_gae_wintitle_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY sg_gae TO sub_gae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
