# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_gaz_item.4gl (副程式)
# Descriptions...: p_zz可變更程式名稱的副程式
# Date & Author..: 03/12/04 alex
# Modify.........: 04/12/15 alex 增加讓 p_zmd 串入的功能
#                  04/12/31 alex 程式原名 p_zz_gaz, 更新為 p_gaz_item
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-760179 07/07/12 By rainy 1.加一個傳入參數 p_type: P:progra nname R:report title
#                                                  2.新增報表title處理 gaz06
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0006 13/01/18 By Zong-Yi 簡繁轉換功能
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gaz01          LIKE gaz_file.gaz01,   # 類別代號 (假單頭)
         g_gaz01_t        LIKE gaz_file.gaz01,   # 類別代號 (假單頭)
         g_gaz    DYNAMIC ARRAY of RECORD        # 程式變數
            gaz02          LIKE gaz_file.gaz02,
            gaz03          LIKE gaz_file.gaz03,
            gaz06          LIKE gaz_file.gaz06,   #TQC-760179
            gaz05          LIKE gaz_file.gaz05
                      END RECORD,
         g_gaz_t           RECORD                 # 變數舊值
            gaz02          LIKE gaz_file.gaz02,
            gaz03          LIKE gaz_file.gaz03,
            gaz06          LIKE gaz_file.gaz06,   #TQC-760179
            gaz05          LIKE gaz_file.gaz05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,     #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 string,  #No.FUN-580092 HCN
         g_rec_b               LIKE type_file.num5,     # 單身筆數              #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5      # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
#FUNCTION p_gaz_item(l_gaz01)        #TQC-760179
FUNCTION p_gaz_item(l_gaz01,l_type)  #TQC-760179
 
   DEFINE l_gaz01     LIKE gaz_file.gaz01
   DEFINE l_type      LIKE type_file.chr1 #TQC-760179
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_gaz01 = l_gaz01
   LET g_gaz01_t = NULL
 
   OPEN WINDOW p_gaz_item_w WITH FORM "azz/42f/p_gaz_item"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   IF g_prog="p_zmd" THEN
      CALL cl_ui_locale("p_zmd_gaz")
      CALL cl_set_comp_visible("gaz06",FALSE)  #TQC-760179
   ELSE
      CALL cl_ui_locale("p_gaz_item")
    #TQC-760179 begin
      IF l_type = 'R' THEN #report title
         CALL cl_set_comp_visible("gaz03",FALSE)
         CALL cl_set_comp_visible("gaz06",TRUE)
      ELSE #'P' program name
         CALL cl_set_comp_visible("gaz03",TRUE)
         CALL cl_set_comp_visible("gaz06",FALSE)
      END IF
    #TQC-760179 end
   END IF
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gaz02")    
 
   DISPLAY g_gaz01 TO gaz01
 
   LET g_sql = "SELECT gaz02,gaz03,gaz06,gaz05 ",   ##TQC-760179 add gaz06
                " FROM gaz_file ",
               " WHERE gaz01 = '",g_gaz01 CLIPPED,"' ",
               " ORDER BY gaz02"
 
   PREPARE p_gaz_item_prepare2 FROM g_sql 
   DECLARE gaz_curs CURSOR FOR p_gaz_item_prepare2
 
   CALL p_gaz_item_b_fill() 
   CALL p_gaz_item_menu() 
 
   CLOSE WINDOW p_gaz_item_w                       # 結束畫面
 
END FUNCTION
 
 
FUNCTION p_gaz_item_menu()
 
   WHILE TRUE
      CALL p_gaz_item_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_gaz_item_b()
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
 
 
FUNCTION p_gaz_item_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5                #FUN-CB0006
   DEFINE   lc_target       LIKE gay_file.gay01                #FUN-CB0006
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gaz01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gaz02,gaz03,gaz06,gaz05 ",   ##TQC-760179 add gaz06
                     "  FROM gaz_file",
                     "  WHERE gaz01 = ? AND gaz02 = ? AND gaz05 = ?",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gaz_item_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gaz WITHOUT DEFAULTS FROM sub_gaz.*
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
            LET g_gaz_t.* = g_gaz[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN p_gaz_item_bcl USING g_gaz01,g_gaz_t.gaz02, g_gaz_t.gaz05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_gaz_item_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gaz_item_bcl INTO g_gaz[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_gaz_item_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #CKP
        #NEXT FIELD gaz02
 
      BEFORE INSERT
         #CKP
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gaz[l_ac].* TO NULL       #900423
         LET g_gaz[l_ac].gaz05 = 'N'
         LET g_gaz_t.* = g_gaz[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gaz02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gaz06,gazoriu,gazorig)   ##TQC-760179 add gaz06
            VALUES (g_gaz01,g_gaz[l_ac].gaz02, g_gaz[l_ac].gaz03,g_gaz[l_ac].gaz05,g_gaz[l_ac].gaz06, g_user, g_grup)   ##TQC-760179 add gaz06      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gaz01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gaz_file",g_gaz01,g_gaz[l_ac].gaz02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
             #CKP
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
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
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gaz_file WHERE gaz01 = g_gaz01
                                   AND gaz02 = g_gaz[l_ac].gaz02
                                   AND gaz05 = g_gaz[l_ac].gaz05
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gaz_t.gaz03,SQLCA.sqlcode,0)
               CALL cl_err3("del","gaz_file",g_gaz01,g_gaz_t.gaz02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      #FUN-CB0006 start
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_gaz[l_ac].gaz02 = "0" LET lc_target = "2"
            WHEN g_gaz[l_ac].gaz02 = "2" LET lc_target = "0"
         END CASE
         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gaz.getLength()
            IF g_gaz[li_i].gaz02 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gaz03)
                     LET g_gaz[l_ac].gaz03 = cl_trans_utf8_twzh(g_gaz[l_ac].gaz02,g_gaz[li_i].gaz03)
                     DISPLAY g_gaz[l_ac].gaz03 TO gaz03
                     EXIT FOR

                  WHEN INFIELD(gaz06)
                     LET g_gaz[l_ac].gaz06 = cl_trans_utf8_twzh(g_gaz[l_ac].gaz02,g_gaz[li_i].gaz06)
                     DISPLAY g_gaz[l_ac].gaz06 TO gaz06
                     EXIT FOR
                END CASE
            END IF
         END FOR
         #FUN-CB0006 END
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gaz[l_ac].* = g_gaz_t.*
            CLOSE p_gaz_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gaz[l_ac].gaz03,-263,1)
            LET g_gaz[l_ac].* = g_gaz_t.*
         ELSE
            UPDATE gaz_file
               SET gaz02 = g_gaz[l_ac].gaz02,
                   gaz03 = g_gaz[l_ac].gaz03,
                   gaz06 = g_gaz[l_ac].gaz06,   ##TQC-760179
                   gaz05 = g_gaz[l_ac].gaz05
             WHERE gaz01 = g_gaz01
               AND gaz02 = g_gaz_t.gaz02
               AND gaz05 = g_gaz_t.gaz05
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gaz[l_ac].gaz02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gaz_file",g_gaz01,g_gaz_t.gaz02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gaz[l_ac].* = g_gaz_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac          #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
               LET g_gaz[l_ac].* = g_gaz_t.*   
            #FUN-D30034---add---str---
            ELSE
               CALL g_gaz.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_gaz_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
        #CKP
        #LET g_gaz_t.* = g_gaz[l_ac].*          # 900423
         LET l_ac_t = l_ac          #FUN-D30034 add
         CLOSE p_gaz_item_bcl
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
   CLOSE p_gaz_item_bcl
   COMMIT WORK
END FUNCTION
 
 
 
FUNCTION p_gaz_item_b_fill() 
 
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
    #CKP
    CALL g_gaz.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_gaz_item_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gaz TO sub_gaz.* ATTRIBUTE(UNBUFFERED)
 
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

