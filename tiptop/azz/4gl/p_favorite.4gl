# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_favorite.4gl
# Descriptions...: 我的最愛維護作業
# Date & Author..: 04/04/23 saki  
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-4C0012 04/12/07 By saki 
# Modify.........: No.TQC-590020 05/09/22 By saki 增加Exit按鍵
# Modify.........: No.FUN-5A0042 06/02/15 By saki 增加查詢功能
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.TQC-680026 06/08/09 By pengu 查詢功能，程式代碼欄位無法開窗查詢
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-7C0039 07/12/06 By alexstar 讓資料q出來後可以加到我的最愛
# Modify.........: No.MOD-930300 09/04/01 By Dido 調整若抓取不到客制資料時,則抓取標準版資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40010 11/04/07 By tommas 改成使用拖拉的方式，左側拉到右側=>新增， 右側拉到左側=>刪除

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zz             DYNAMIC ARRAY OF RECORD
           zz01           LIKE zz_file.zz01,
           gaz03          LIKE gaz_file.gaz03
                          END RECORD
DEFINE   g_gbi            DYNAMIC ARRAY OF RECORD
           gbi02          LIKE gbi_file.gbi02,
           gaz03_2        LIKE gaz_file.gaz03
                          END RECORD
DEFINE   g_cnt            LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   l_ac             LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   l_ac2            LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   g_rec_b          LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   g_rec_b2         LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   g_array_change   LIKE type_file.num5    #FUN-680135 SMALLINT
DEFINE   l_cnt            LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   l_gaz05          LIKE gaz_file.gaz05    #FUN-680135 VARCHAR(1)
DEFINE   lc_zz011         LIKE zz_file.zz011
DEFINE   ls_zz011         STRING
MAIN
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW p_favorite_w AT 3,3 WITH FORM "azz/42f/p_favorite"
      ATTRIBUTE(STYLE="err01")
 
   CALL cl_ui_init()
 
   CALL g_zz.clear()
 
   #No.FUN-5A0042 --start--mark
#  DECLARE p_favorite_cur3 CURSOR FOR
#     SELECT zz01,'' FROM zz_file
#      WHERE zz03 != 'M'
#      ORDER BY zz01
 
#  LET g_cnt = 1
#   FOREACH p_favorite_cur3 INTO g_zz[g_cnt].*                   # MOD-4C0012
#     IF SQLCA.sqlcode THEN
#        EXIT FOREACH
#     END IF
#     SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = g_zz[g_cnt].zz01
#     LET ls_zz011 = lc_zz011
#     IF ls_zz011.subString(1,1) = "C" AND ls_zz011.subString(1,3) != "CL_" THEN
#        SELECT gaz03 INTO g_zz[g_cnt].gaz03 FROM gaz_file 
#           WHERE gaz01=g_zz[g_cnt].zz01 AND gaz02 = g_lang AND gaz05 = 'Y'
#     ELSE
#        SELECT gaz03 INTO g_zz[g_cnt].gaz03 FROM gaz_file 
#           WHERE gaz01=g_zz[g_cnt].zz01 AND gaz02 = g_lang AND gaz05 = 'N'
#     END IF
#     LET g_cnt = g_cnt + 1
#  END FOREACH
#  CALL g_zz.deleteElement(g_cnt)
#  LET g_rec_b = g_cnt - 1
   #No.FUN-5A0042 ---end---mark
 
   #CALL p_favorite_array1()  #No.FUN-B40010 mark
   CALL p_favorite_array()    #No.FUN-B40010 add
 
   CLOSE WINDOW p_favorite_w
END MAIN

#No.FUN-B40010 add 用DIALOG合併p_favorite_array1()及p_favorite_array2()
FUNCTION p_favorite_array()
   DEFINE   ls_cnt    LIKE type_file.num10   
   DEFINE   l_dnd     ui.DragDrop
   DEFINE   l_source  STRING

   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      DISPLAY ARRAY g_zz TO s_zz.* ATTRIBUTE(COUNT=g_rec_b) 
         ON DRAG_START(l_dnd)
            LET l_source="LEFT"
            LET l_ac = ARR_CURR()
         ON DRAG_OVER(l_dnd)
            IF l_source == "LEFT" THEN
               CALL l_dnd.setOperation(NULL)
            ELSE
               CALL l_dnd.setOperation("move")
               CALL l_dnd.setFeedback("insert")
            END IF
         ON DROP(l_dnd)
            IF l_source == "RIGHT" AND l_ac > 0 THEN
               DELETE FROM gbi_file WHERE gbi01 = g_user AND gbi02 = g_gbi[l_ac].gbi02
               CALL p_favorite_array2_b_fill()
               LET l_ac = 0
            END IF
      END DISPLAY
 
      DISPLAY ARRAY g_gbi TO s_gbi.* ATTRIBUTE(COUNT=g_rec_b2)
         ON DRAG_START(l_dnd)
            LET l_source = "RIGHT"
            LET l_ac = ARR_CURR()
         ON DRAG_OVER(l_dnd)
            IF l_source == "RIGHT" THEN
               CALL l_dnd.setOperation(NULL)
            ELSE
               CALL l_dnd.setOperation("move")
               CALL l_dnd.setFeedback("insert")
            END IF
         ON DROP(l_dnd)
            IF l_source == "LEFT" AND l_ac > 0 THEN
               IF l_ac > 0 THEN              
                  SELECT COUNT(*) INTO ls_cnt FROM gbi_file
                   WHERE gbi01 = g_user AND gbi02 = g_zz[l_ac].zz01
                  IF ls_cnt > 0 THEN
                     MESSAGE "Repeat Data"
                  ELSE
                      INSERT INTO gbi_file(gbi01,gbi02,gbi03,gbi04,gbi05)  
                                   VALUES(g_user,g_zz[l_ac].zz01,"","","")
                     CALL p_favorite_array2_b_fill()
                  END IF
               END IF                          
               LET l_ac = 0
            END IF
      END DISPLAY

      BEFORE DIALOG
         CALL p_favorite_array2_b_fill()
         CALL cl_set_comp_visible("accept,cancel",FALSE)
      ON ACTION query
         CALL cl_set_comp_visible("accept,cancel",TRUE)
         CALL p_favorite_cs()
         CALL cl_set_comp_visible("accept,cancel",FALSE)
      ON ACTION exit
         EXIT DIALOG
      ON ACTION close
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
   END DIALOG
END FUNCTION

#No.FUN-B40010 --- mark start ---
#
#FUNCTION p_favorite_array1()
#   DEFINE   ls_cnt    LIKE type_file.num10   #FUN-680135 INTEGER
# 
#   LET g_array_change = FALSE
# 
#   DISPLAY ARRAY g_zz TO s_zz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#      #No.FUN-5A0042 --start--
#      BEFORE DISPLAY
#         CALL cl_set_comp_visible("accept,cancel",FALSE)
#      #No.FUN-5A0042 ---end---
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL p_favorite_array2_b_fill()
#         CALL p_favorite_array2_refresh()
#      #No.FUN-5A0042 --start--
#      ON ACTION query
#         CALL cl_set_comp_visible("accept,cancel",TRUE)
#         CALL p_favorite_cs()
#         CALL p_favorite_array1()   #MOD-7C0039
#         EXIT DISPLAY               #MOD-7C0039
#         CALL cl_set_comp_visible("accept,cancel",FALSE)
#      #No.FUN-5A0042 ---end---
#      ON ACTION change
#         LET g_array_change = TRUE
#         EXIT DISPLAY
#      ON ACTION add
#         IF l_ac > 0 THEN               #No.FUN-5A0042
#            SELECT COUNT(*) INTO ls_cnt FROM gbi_file
#             WHERE gbi01 = g_user AND gbi02 = g_zz[l_ac].zz01
#            IF ls_cnt > 0 THEN
#               MESSAGE "Repeat Data"
#            ELSE
#                INSERT INTO gbi_file(gbi01,gbi02,gbi03,gbi04,gbi05)  #No.MOD-470041
#                             VALUES(g_user,g_zz[l_ac].zz01,"","","")
#               CALL p_favorite_array2_b_fill()
#               CALL p_favorite_array2_refresh()
#            END IF
#         END IF                          #No.FUN-5A0042
#      ON ACTION accept
#         IF l_ac > 0 THEN               #No.FUN-5A0042
#            SELECT COUNT(*) INTO ls_cnt FROM gbi_file
#             WHERE gbi01 = g_user AND gbi02 = g_zz[l_ac].zz01
#            IF ls_cnt > 0 THEN
#               MESSAGE "Repeat Data"
#            ELSE
#                INSERT INTO gbi_file(gbi01,gbi02,gbi03,gbi04,gbi05)  #No.MOD-470041 
#                             VALUES(g_user,g_zz[l_ac].zz01,"","","")
#               CALL p_favorite_array2_b_fill()
#               CALL p_favorite_array2_refresh()
#            END IF
#         END IF                          #No.FUN-5A0042
#      ON ACTION close
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      #No.TQC-590020 --start--
#      ON ACTION exit
#         EXIT DISPLAY
#      #No.TQC-590020 ---end---
# 
#   END DISPLAY
#
#   
#   CALL cl_set_act_visible("accept,cancel",TRUE)
#   IF g_array_change THEN
#      CALL p_favorite_array2()
#   END IF
#END FUNCTION
#
#No.FUN-B40010 --- mark end ---

FUNCTION p_favorite_array2_b_fill()
   CALL g_gbi.clear()
 
   DECLARE p_favorite_cur2 CURSOR FOR
      SELECT gbi02,'' FROM gbi_file
       WHERE gbi01 = g_user 
 
   LET g_cnt = 1
    FOREACH p_favorite_cur2 INTO g_gbi[g_cnt].*                 # MOD-4C0012
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = g_gbi[g_cnt].gbi02
      LET ls_zz011 = lc_zz011
      IF ls_zz011.subString(1,1) = "C" AND ls_zz011.subString(1,3) != "CL_" THEN
         SELECT gaz03 INTO g_gbi[g_cnt].gaz03_2 FROM gaz_file
          WHERE gaz01=g_gbi[g_cnt].gbi02 AND gaz02 = g_lang AND gaz05 = 'Y'
      ELSE
         SELECT gaz03 INTO g_gbi[g_cnt].gaz03_2 FROM gaz_file
          WHERE gaz01=g_gbi[g_cnt].gbi02 AND gaz02 = g_lang AND gaz05 = 'N'
      END IF
      #-MOD-930300
      IF cl_null(g_gbi[g_cnt].gaz03_2) THEN
         SELECT gaz03 INTO g_gbi[g_cnt].gaz03_2 FROM gaz_file
          WHERE gaz01=g_gbi[g_cnt].gbi02 AND gaz02=g_lang AND gaz05="N"
      END IF
      #-MOD-930300 End
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_gbi.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
END FUNCTION

#No.FUN-B40010 --- mark start ---
#
#FUNCTION p_favorite_array2()
# 
#   LET g_array_change = FALSE
# 
#   DISPLAY ARRAY g_gbi TO s_gbi.* ATTRIBUTE(COUNT=g_rec_b2)
#      #No.FUN-5A0042 --start--
#      BEFORE DISPLAY
#         CALL cl_set_comp_visible("accept,cancel",FALSE)
#      #No.FUN-5A0042 ---end---
#      BEFORE ROW
#         LET l_ac2 = ARR_CURR()
#      ON ACTION change
#         LET g_array_change = TRUE
#         EXIT DISPLAY
#      ON ACTION remove
#         DELETE FROM gbi_file WHERE gbi01 = g_user AND gbi02 = g_gbi[l_ac2].gbi02
#         CALL p_favorite_array2_b_fill()
#         CALL p_favorite_array2_refresh()
#      ON ACTION accept
#         DELETE FROM gbi_file WHERE gbi01 = g_user AND gbi02 = g_gbi[l_ac2].gbi02
#         CALL p_favorite_array2_b_fill()
#         CALL p_favorite_array2_refresh()
#      ON ACTION close
#         EXIT DISPLAY
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      #No.FUN-5A0042 --start--
#      ON ACTION exit
#         EXIT DISPLAY
#      #No.FUN-5A0042 ---end---
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel",TRUE)
#   IF g_array_change THEN
#      CALL p_favorite_array1()
#   END IF
#END FUNCTION
#
#No.FUN-B40010 --- mark end ---

FUNCTION p_favorite_array2_refresh()
 
   DISPLAY ARRAY g_gbi TO s_gbi.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
#No.FUN-5A0042 --start--
FUNCTION p_favorite_cs()
   DEFINE   ls_wc   STRING
   DEFINE   ls_sql  STRING
 
   CONSTRUCT ls_wc ON zz01 FROM formonly.zz01_1
      ON ACTION controlp
         CASE
           #----No.TQC-680026 modify
           #WHEN INFIELD(zz01)
            WHEN INFIELD(zz01_1)
           #----No.TQC-680026 end
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zz01_1    #No.TQC-680026 modify
               NEXT FIELD zz01_1      #No.TQC-680026
         END CASE
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   END CONSTRUCT
   LET ls_wc = ls_wc CLIPPED,cl_get_extra_cond('zzuser', 'zzgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
 
   CALL g_zz.clear()
   LET ls_sql = "SELECT zz01,'' FROM zz_file ",
                " WHERE zz03 != 'M' AND ",ls_wc CLIPPED, " ORDER BY zz01"
   PREPARE p_favorite_pre FROM ls_sql
   DECLARE p_favorite_cur CURSOR FOR p_favorite_pre
 
   LET g_cnt = 1
   FOREACH p_favorite_cur INTO g_zz[g_cnt].*                   # MOD-4C0012
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = g_zz[g_cnt].zz01
      LET ls_zz011 = lc_zz011
      IF ls_zz011.subString(1,1) = "C" AND ls_zz011.subString(1,3) != "CL_" THEN
         SELECT gaz03 INTO g_zz[g_cnt].gaz03 FROM gaz_file 
            WHERE gaz01=g_zz[g_cnt].zz01 AND gaz02 = g_lang AND gaz05 = 'Y'
      ELSE
         SELECT gaz03 INTO g_zz[g_cnt].gaz03 FROM gaz_file 
            WHERE gaz01=g_zz[g_cnt].zz01 AND gaz02 = g_lang AND gaz05 = 'N'
      END IF
      #-MOD-930300
      IF cl_null(g_zz[g_cnt].gaz03) THEN
         SELECT gaz03 INTO g_zz[g_cnt].gaz03 FROM gaz_file
          WHERE gaz01=g_zz[g_cnt].zz01 AND gaz02 = g_lang AND gaz05="N"
      END IF
      #-MOD-930300 End
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_zz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
END FUNCTION
#No.FUN-5A0042 ---end---
