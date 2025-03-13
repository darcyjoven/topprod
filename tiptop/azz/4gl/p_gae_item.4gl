# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_gae_item.4gl
# Descriptions...: p_per 副程式: 串接並抓取單筆 gae_file 資料直接修正用
# Date & Author..: 03/12/04 saki  
# Modify.........: No.FUN-4C0107 04/12/31 By alex 改變 func name 原為p_per_gae_d
# Modify.........: No.FUN-590001 05/10/17 By alex 新增辨試是否為客製資料欄位
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710055 07/03/12 By saki 增加行業別多語言功能
# Modify.........: No.FUN-7B0081 08/01/10 By alex 將gae05移至gbs06
# Modify.........: No.MOD-810266 08/01/31 By alexstar 修正變數抓錯的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0006 13/01/18 By Zong-Yi 簡繁轉換功能
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gae01          LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_gae02          LIKE gae_file.gae02,   # 類別代號 (假單頭)
         g_gae11          LIKE gae_file.gae11,   #FUN-590001
         g_gae12          LIKE gae_file.gae12,   #No.FUN-710055
#        g_gae01_t        LIKE gae_file.gae01,   #FUN-590001
#        g_gae02_t        LIKE gae_file.gae02,   #FUN-590001
         g_gae    DYNAMIC ARRAY of RECORD        # 程式變數
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gbs06          LIKE gbs_file.gbs06   #FUN-7B0081 gae_file.gae05
                      END RECORD,
         g_gae_t           RECORD                 # 變數舊值
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gbs06          LIKE gbs_file.gbs06   #FUN-7B0081 gae_file.gae05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,   #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,                #FUN-580092 HCN
         g_rec_b               LIKE type_file.num5,   # 單身筆數  #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5    # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
FUNCTION p_gae_item(l_gae01,l_gae02,l_gae11,l_gae12)   #FUN-590001  #No.FUN-710055
 
   DEFINE l_gae01     LIKE gae_file.gae01
   DEFINE l_gae02     LIKE gae_file.gae02
   DEFINE l_gae11     LIKE gae_file.gae11      #FUN-590001
   DEFINE l_gae12     LIKE gae_file.gae12      #No.FUN-710055
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_gae01 = l_gae01
   LET g_gae02 = l_gae02
   LET g_gae11 = l_gae11         #FUN-590001
   LET g_gae12 = l_gae12         #No.FUN-710055
#  LET g_gae01_t = NULL          #FUN-590001
#  LET g_gae02_t = NULL          #FUN-590001
 
   OPEN WINDOW p_gae_item_w WITH FORM "azz/42f/p_gae_item"
   ATTRIBUTE(STYLE=g_win_style)
    
   CALL cl_ui_locale("p_gae_item")
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gae03")
 
   DISPLAY g_gae01,g_gae02,g_gae11,g_gae12 TO gae01,gae02,gae11,gae12     #FUN-590001   #No.FUN-710055
 
   LET g_sql = "SELECT gae03,gae04,'' ",                    #FUN-7B0081
                " FROM gae_file ",
               " WHERE gae01 = '",g_gae01 CLIPPED,"' ",
                 " AND gae02 = '",g_gae02 CLIPPED,"' ",
                 " AND gae11 = '",g_gae11 CLIPPED,"' ",     #FUN-590001
                 " AND gae12 = '",g_gae12 CLIPPED,"' ",     #No.FUN-710055
               " ORDER BY gae03"
 
   PREPARE p_gae_item_prepare2 FROM g_sql 
   DECLARE gae_curs CURSOR FOR p_gae_item_prepare2
 
   CALL p_gae_item_b_fill() 
   CALL p_gae_item_menu() 
 
   CLOSE WINDOW p_gae_item_w                       # 結束畫面
 
END FUNCTION
 
 
FUNCTION p_gae_item_menu()
 
   WHILE TRUE
      CALL p_gae_item_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_gae_item_b()
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
 
 
FUNCTION p_gae_item_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,          # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT SMALLINT
            l_n             LIKE type_file.num5,          # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,            #FUN-680135    SMALLINT # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,          # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,          # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5           #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5           #FUN-7B0081
   DEFINE   li_j            LIKE type_file.num5           #FUN-CB0006
   DEFINE   lc_target       LIKE gay_file.gay01           #FUN-CB0006
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gae03,gae04,'' ",          #FUN-7B0081
                     "  FROM gae_file",
                     "  WHERE gae01 = ? AND gae02 = ? AND gae11 = ? AND gae12 = ? ",    #FUN-590001  #No.FUN-710055
                       " AND gae03 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gae_item_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gae WITHOUT DEFAULTS FROM sub_gae.*
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
            LET g_gae_t.* = g_gae[l_ac].*  #BACKUP
            BEGIN WORK
            LET p_cmd='u'
            OPEN p_gae_item_bcl USING g_gae01,g_gae02,g_gae11,g_gae12,g_gae_t.gae03 #FUN-590001  #No.FUN-710055
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_gae_item_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gae_item_bcl INTO g_gae[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_gae_item_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE                     #FUN-7B0081
                 #SELECT gbs06 INTO g_gae[g_cnt].gbs06 FROM gbs_file   #MOD-810266 mark
                 # WHERE gbs01 = g_gae01 AND gbs02 = g_gae02
                 #   AND gbs03 = g_gae[g_cnt].gae03
                 #   AND gbs04 = g_gae11 AND gbs05 = g_gae12 
                  SELECT gbs06 INTO g_gae[l_ac].gbs06 FROM gbs_file   #MOD-810266 
                   WHERE gbs01 = g_gae01 AND gbs02 = g_gae02
                     AND gbs03 = g_gae[l_ac].gae03
                     AND gbs04 = g_gae11 AND gbs05 = g_gae12 
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_gae[l_ac].* TO NULL       #900423
         LET g_gae_t.* = g_gae[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gae03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gae_file(gae01,gae02,gae11,gae12,gae03,gae04)  #FUN-590001 #No.FUN-710055
                      VALUES (g_gae01,g_gae02,g_gae11,g_gae12,      #FUN-710055
                              g_gae[l_ac].gae03,
                              g_gae[l_ac].gae04)                    #FUN-7B0081
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gae01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gae_file",g_gae02,g_gae[l_ac].gae03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             IF NOT cl_null(g_gae[l_ac].gbs06) THEN
                INSERT INTO gbs_file(gbs01,gbs02,gbs04,gbs05,gbs03,gbs06)
                      VALUES (g_gae01,g_gae02,g_gae11,g_gae12,
                              g_gae[l_ac].gae03,g_gae[l_ac].gbs06)
             END IF
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gae03
         IF NOT cl_null(g_gae[l_ac].gae03) THEN
            # 檢視目前欲變更的是否為 Key Realtion 中的主鍵值 Primary Key
            # gau01, 若有則出現註記入 l_gau01
            SELECT COUNT(*) INTO l_gau01 FROM gau_file
             WHERE gau01 = g_gae02
            IF STATUS THEN
               LET l_gau01 = 0
            END IF
         END IF
 
      AFTER FIELD gae04
         IF NOT cl_null(g_gae[l_ac].gae04) THEN
            IF g_gae[l_ac].gae04 != g_gae_t.gae04 AND l_gau01 > 0 THEN
 
   # 2004/03/05 暫時 mark
   #           IF NOT p_gae_item_chk_gau("0") THEN
   #              CALL cl_err("gau04 CHANGING,RUN p_keyrelat!","!",1)
   #           END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gae_t.gae03) THEN
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
            DELETE FROM gae_file WHERE gae01 = g_gae01
                                   AND gae02 = g_gae02
                                   AND gae11 = g_gae11     #FUN-590001
                                   AND gae12 = g_gae12     #No.FUN-710055
                                   AND gae03 = g_gae[l_ac].gae03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gae_t.gae03,SQLCA.sqlcode,0)
               CALL cl_err3("del","gae_file",g_gae02,g_gae_t.gae03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE   #FUN-7B0081
               DELETE FROM gbs_file WHERE gbs01 = g_gae01
                       AND gbs02 = g_gae02 AND gbs04 = g_gae11
                       AND gbs05 = g_gae12 AND gbs03 = g_gae[l_ac].gae03
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      #FUN-CB0006 START
      ON ACTION translate_zhtw  
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_gae[l_ac].gae03 = "0" LET lc_target = "2"
            WHEN g_gae[l_ac].gae03 = "2" LET lc_target = "0"
         END CASE
         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gae.getLength()
            IF g_gae[li_i].gae03 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gae04)
                     LET g_gae[l_ac].gae04 = cl_trans_utf8_twzh(g_gae[l_ac].gae03,g_gae[li_i].gae04)
                     DISPLAY g_gae[l_ac].gae04 TO gae04
                     EXIT FOR
                END CASE
            END IF
         END FOR
      #FUN-CB0006 END
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gae[l_ac].* = g_gae_t.*
            CLOSE p_gae_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gae[l_ac].gae03,-263,1)
            LET g_gae[l_ac].* = g_gae_t.*
         ELSE
            UPDATE gae_file
               SET gae03 = g_gae[l_ac].gae03,
                   gae04 = g_gae[l_ac].gae04    #FUN-7B0081
             WHERE gae01 = g_gae01
               AND gae02 = g_gae02
               AND gae11 = g_gae11     #FUN-590001
               AND gae12 = g_gae12     #No.FUN-710055
               AND gae03 = g_gae_t.gae03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gae[l_ac].gae03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gae_file",g_gae02,g_gae_t.gae03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gae[l_ac].* = g_gae_t.*
            ELSE    #FUN-7B0081
               IF NOT cl_null(g_gae[l_ac].gbs06) THEN
                  SELECT COUNT(*) FROM gbs_file
                   WHERE gbs01 = g_gae01
                     AND gbs02 = g_gae02 AND gbs04 = g_gae11
                     AND gbs05 = g_gae12 AND gbs03 = g_gae_t.gae03
                  IF li_i > 0 THEN
                     UPDATE gbs_file
                        SET gae03 = g_gae[l_ac].gae03, gbs06 = g_gae[l_ac].gbs06
                      WHERE gbs01 = g_gae01
                        AND gbs02 = g_gae02 AND gbs04 = g_gae11
                        AND gbs05 = g_gae12 AND gbs03 = g_gae_t.gae03
                  ELSE
                     INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs06)
                            VALUES(g_gae01,g_gae02,g_gae[l_ac].gae03,
                                   g_gae11,g_gae12,g_gae[l_ac].gbs06)
                  END IF
               ELSE
                  DELETE FROM gbs_file WHERE gbs01 = g_gae01
                          AND gbs02 = g_gae02 AND gbs04 = g_gae11
                          AND gbs05 = g_gae12 AND gbs03 = g_gae[l_ac].gae03
               END IF
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
                LET g_gae[l_ac].* = g_gae_t.*   
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gae.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_gae_item_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         #LET g_gae_t.* = g_gae[l_ac].*          # 900423
         CLOSE p_gae_item_bcl
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gae04)
               CALL s_keyrelat(g_gae[l_ac].gae04,g_gae[l_ac].gae03,g_gae02)
                    RETURNING g_gae[l_ac].gae04
               DISPLAY g_gae[l_ac].gae04 TO gae04
               NEXT FIELD gae04
 
            OTHERWISE
               EXIT CASE
         END CASE
   
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
   CLOSE p_gae_item_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gae_item_b_fill() 
 
    CALL g_gae.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH gae_curs INTO g_gae[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE                                    #FUN-7B0081
          SELECT gbs06 INTO g_gae[g_cnt].gbs06 FROM gbs_file
           WHERE gbs01 = g_gae01 AND gbs02 = g_gae02
             AND gbs03 = g_gae[g_cnt].gae03
             AND gbs04 = g_gae11 AND gbs05 = g_gae12
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gae.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_gae_item_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gae TO sub_gae.* ATTRIBUTE(UNBUFFERED)
 
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
