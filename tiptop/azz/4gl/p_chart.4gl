# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_chart.4gl
# Descriptions...: 動態圖表自訂屬性設定作業
# Date & Author..: 11/04/27 By tommas
# Modify.........: No.FUN-B40086 by tommas 新建

IMPORT util

DATABASE ds

GLOBALS "../../config/top.global"

TYPE t_gfn_s         RECORD                  #程式自設屬性
                        s_gfn01    LIKE gfn_file.gfn01, #程式代碼
                        s_gfn02    LIKE gfn_file.gfn02, #圖表名稱
                        s_gfn03    LIKE gfn_file.gfn03, #屬性名稱
                        s_gfm04    LIKE gfm_file.gfm04, #屬性說明
                        s_gfm05    LIKE gfm_file.gfm05, #屬性類型 1.基本 2.陣列 3.特殊
                        s_gfn04    LIKE gfn_file.gfn04, #序號
                        s_gfn05    LIKE gfn_file.gfn05 #屬性值
                     END RECORD
DEFINE g_gfm_pics    DYNAMIC ARRAY OF RECORD  #PictureFlow
           gfm01_pic      STRING,
           gfm01          LIKE gfm_file.gfm01
                     END RECORD
DEFINE g_gdj_2       DYNAMIC ARRAY OF RECORD
              gdj03  LIKE gdj_file.gdj03,
              zx02   LIKE zx_file.zx02
                     END RECORD
DEFINE g_gdj_3       DYNAMIC ARRAY OF RECORD
              gdj03  LIKE gdj_file.gdj03,
              gem02  LIKE gem_file.gem02
                     END RECORD
DEFINE g_gfm         DYNAMIC ARRAY OF RECORD LIKE gfm_file.*  #預設屬性
DEFINE g_gfn         DYNAMIC ARRAY OF t_gfn_s                 #程式自設屬性                   
DEFINE g_gfn01       LIKE gfn_file.gfn01
DEFINE g_gfn02       LIKE gfn_file.gfn02
DEFINE g_gfn07       LIKE gfn_file.gfn07
DEFINE g_gfp04       LIKE gfp_file.gfp04
DEFINE g_wc          STRING
DEFINE g_wc2         STRING
DEFINE g_wc3         STRING
DEFINE g_gfm01_tmp   LIKE gfm_file.gfm01   #用來記錄上一筆的圖表類型，避免切換時重覆填充相同的ComboBox
DEFINE g_cnt         LIKE type_file.num10,
       g_rec_b       LIKE type_file.num5,
       g_curs_index  LIKE type_file.num10,
       g_row_count   LIKE type_file.num10,
       g_msg         LIKE type_file.chr1000,
       g_jump              LIKE type_file.num10
MAIN #No.FUN-B40086
   DEFINE l_wcpath   STRING

   OPTIONS                
      INPUT NO WRAP       
   DEFER INTERRUPT        
            
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
   #WHENEVER ERROR STOP
   
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET l_wcpath = FGL_GETENV("WEBSERVERIP"),"/components"

   CALL ui.interface.frontCall("standard", "setwebcomponentpath",[l_wcpath],[])

   OPEN WINDOW p_chart_w WITH FORM "azz/42f/p_chart"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_init()

   PREPARE p_chart_p1 FROM "SELECT * FROM gfm_file WHERE gfm01 = ?  ORDER BY gfm03, gfm05"
   PREPARE p_chart_p2 FROM "SELECT gfn01,gfn02,gfn03,'',gfm05,gfn04,gfn05 " ||
                           "FROM gfn_file INNER JOIN gfm_file ON gfn02 = gfm01 " ||
                           " WHERE gfn01 = ? AND gfn03=gfm03 ORDER BY gfn04"
   PREPARE p_chart_gfn03_p1 FROM "SELECT gfm03 FROM gfm_file WHERE gfm01 = ? "
   
   DECLARE p_chart_d1 CURSOR FOR p_chart_p1
   DECLARE p_chart_d2 CURSOR FOR p_chart_p2
   DECLARE p_chart_gfn03_d1 CURSOR FOR p_chart_gfn03_p1
   
   CALL cl_set_act_visible("auth_user,add_to_gdk,auth_dep,modify_chart_name", FALSE)
   CALL p_chart_menu()

   CLOSE WINDOW p_chart_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   
END MAIN
FUNCTION p_chart_menu()
   DEFINE l_cb       ui.ComboBox
   DEFINE l_i        INTEGER
   
   PREPARE p_chart_p3 FROM "SELECT gfm01 FROM gfm_file GROUP BY gfm01"   
   DECLARE p_chart_c3 CURSOR FOR p_chart_p3

   LET l_cb = ui.ComboBox.forName("gfn02_cb")

   CALL l_cb.clear()
   
   LET l_i = 1
   #填充PictureFlow及ComboBox
   FOREACH p_chart_c3 INTO g_gfm_pics[l_i].gfm01
      LET g_gfm_pics[l_i].gfm01_pic = g_gfm_pics[l_i].gfm01,".png"
      CALL l_cb.addItem(g_gfm_pics[l_i].gfm01,g_gfm_pics[l_i].gfm01)
      LET l_i = l_i + 1      
   END FOREACH
   CALL g_gfm_pics.deleteElement(l_i)
   CALL p_chart_show()
END FUNCTION

FUNCTION p_chart_b()
   DEFINE l_ac         INTEGER
   DEFINE l_gfm        RECORD LIKE gfm_file.*
   DEFINE l_gfn_t    RECORD                  #程式自設屬性
                   s_gfn01    LIKE gfn_file.gfn01, #程式代碼
                   s_gfn02    LIKE gfn_file.gfn02, #圖表名稱
                   s_gfn03    LIKE gfn_file.gfn03, #屬性名稱
                   s_gfm04    LIKE gfm_file.gfm04, #屬性說明
                   s_gfm05    LIKE gfm_file.gfm05, #屬性類型 1.基本 2.陣列 3.特殊
                   s_gfn04    LIKE gfn_file.gfn04, #序號
                   s_gfn05    LIKE gfn_file.gfn05 #屬性值
                   END RECORD
   DEFINE l_i          INTEGER
   DEFINE l_flag       BOOLEAN
   DEFINE l_gfn04      LIKE gfn_file.gfn04
   DEFINE l_sql        STRING
   DEFINE l_op         STRING
   DEFINE l_tmp        STRING
   DEFINE l_gfp02      LIKE gfp_file.gfp02
   DEFINE l_gfp02_t      LIKE gfp_file.gfp02
   DEFINE l_gay01      LIKE gay_file.gay01
   
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)

      INPUT ARRAY g_gfn FROM s_gfn.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE ROW 
		    LET l_op = "M"
            LET l_ac = ARR_CURR()
            LET l_flag = TRUE            
            LET l_gfn_t.* = g_gfn[l_ac].*
			
         AFTER FIELD s_gfn03, s_gfn04
            LET l_flag = TRUE 
            IF NOT cl_null(g_gfn[l_ac].s_gfn03) AND 
               NOT cl_null(g_gfn[l_ac].s_gfn04) THEN
                  FOR l_i = 1 TO g_gfn.getLength()
                     IF l_ac != l_i THEN
                        IF g_gfn[l_ac].s_gfn03 == g_gfn[l_i].s_gfn03 AND 
                           g_gfn[l_ac].s_gfn04 == g_gfn[l_i].s_gfn04 THEN
                           CALL cl_err("","azz1177",1)
                           LET l_flag = FALSE
                           #CALL dialog.nextField(DIALOG.getCurrentItem())
                           NEXT FIELD s_gfn04
                           EXIT FOR 
                        END IF
                     END IF
                  END FOR
            END IF
         
         ON CHANGE s_gfn03
            SELECT * INTO l_gfm.* FROM gfm_file 
                     WHERE gfm01 = g_gfn02
                       AND gfm03 = g_gfn[l_ac].s_gfn03

            IF NOT cl_null(l_gfm.gfm03) THEN
               CASE l_gfm.gfm05
                  WHEN 1       #gfm05 = 1則:gfn03不能重覆
                     LET l_gfn04 = 1
                     LET g_gfn[l_ac].s_gfn04 = 1
                     
                  WHEN 2       #gfm05 = 2則:自動幫gfn04遞增
                     LET l_gfn04 = 0
                     FOR l_i = 1 TO g_gfn.getLength()
                        IF l_ac != l_i THEN
                           IF g_gfn[l_ac].s_gfn03 == g_gfn[l_i].s_gfn03 THEN
                              IF g_gfn[l_i].s_gfn04 > l_gfn04 THEN
                                 LET l_gfn04 = g_gfn[l_i].s_gfn04
                              END IF
                           END IF
                        END IF
                     END FOR
                     LET l_gfn04 = l_gfn04 + 1
               END CASE
               #找出屬性預設值
               LET l_gfm.gfm04 = p_chart_get_lang(l_gfm.gfm01, l_gfm.gfm03, '')
               LET g_gfn[l_ac].s_gfn04 = l_gfn04
               LET g_gfn[l_ac].s_gfm04 = l_gfm.gfm04
               LET g_gfn[l_ac].s_gfm05 = l_gfm.gfm05
               LET g_gfn[l_ac].s_gfn05 = l_gfm.gfm06
            END IF
            
            #若為新增屬性，則自動將屬性預設值加到多語言gfp_file中
            LET l_tmp = "N"
            FOR l_i = 1 TO g_gfn.getLength()    #檢查屬性類型為1.基本，而且沒有重覆
               IF l_gfm.gfm05 == 1 AND l_i != l_ac THEN  #屬性類型為1.基本，且不是目前所選的列數
                  IF g_gfn[l_i].s_gfn03 == g_gfn[l_ac].s_gfn03 THEN
                     LET l_tmp = "Y"
                     EXIT FOR
                  END IF
               END IF
            END FOR
            IF l_tmp == "N" THEN  #如果屬性類型為1.基本，且沒有重覆，則自動將屬性預設值加到多語言
               DECLARE p_chart_lang_cs CURSOR FOR SELECT gay01 FROM gay_file
                                  WHERE gayacti = "Y"
                                  ORDER BY gay01
               LET l_tmp = g_gfn[l_ac].s_gfn04
               LET l_gfp02 = g_gfn[l_ac].s_gfn03, "|", l_tmp.trim() 
               FOREACH p_chart_lang_cs INTO l_gay01
                  INSERT INTO gfp_file VALUES (g_gfn01, l_gfp02, l_gay01, g_gfn[l_ac].s_gfn05)
               END FOREACH
            END IF
            
         ON CHANGE s_gfn04
            SELECT gfm_file.* INTO l_gfm.* FROM gfm_file 
                              WHERE gfm01 = g_gfn02
                                AND gfm03 = g_gfn[l_ac].s_gfn03
            CASE l_gfm.gfm05
               WHEN 1     #當gfm05 = 1則:序號必為1
                  IF g_gfn[l_ac].s_gfn04 != 1 THEN
                     LET g_gfn[l_ac].s_gfn04 = 1
                  END IF
            END CASE
            
         ON ROW CHANGE
		    IF l_op != "I" THEN LET l_op = "M" END IF
			
         BEFORE INSERT
		    LET l_op = "I" 
			
		 AFTER DELETE
		    LET l_op = "M"
			
         AFTER ROW
		    IF l_op == "I" AND NOT cl_null(g_gfn[l_ac].s_gfn03) THEN
            LET l_tmp = g_gfn[l_ac].s_gfn04
            LET l_gfp02 = g_gfn[l_ac].s_gfn03, "|", l_tmp.trim() 
				INSERT INTO gfn_file (gfn01,gfn02,gfn03,gfn04,gfn05,gfn07) 
                  VALUES (g_gfn01,
							     g_gfn02,
							     g_gfn[l_ac].s_gfn03,
							     g_gfn[l_ac].s_gfn04,
							     g_gfn[l_ac].s_gfn05,
                          g_gfn07)

            IF SQLCA.sqlcode THEN
				   CALL cl_err("",sqlca.sqlcode,1) 
				   EXIT DIALOG
				ELSE
				   MESSAGE "Update success!"
				END IF
				CALL cl_chart_load_demo_data() 
			END IF
		    IF l_op == "M" THEN
               IF cl_null(g_gfn[l_ac].s_gfn05) THEN LET g_gfn[l_ac].s_gfn05 = ' ' END IF
               UPDATE gfn_file SET gfn03 = g_gfn[l_ac].s_gfn03,
                                   gfn04 = g_gfn[l_ac].s_gfn04,
                                   gfn05 = g_gfn[l_ac].s_gfn05,
                                   gfn07 = g_gfn07
                             WHERE gfn01 = g_gfn01
                               AND gfn02 = g_gfn02
                               AND gfn03 = l_gfn_t.s_gfn03
                               AND gfn04 = l_gfn_t.s_gfn04
               LET l_tmp = g_gfn[l_ac].s_gfn04
               LET l_gfp02 = g_gfn[l_ac].s_gfn03, "|", l_tmp.trim() 
               LET l_tmp = l_gfn_t.s_gfn04
               LET l_gfp02_t = l_gfn_t.s_gfn03, "|", l_tmp.trim() 
               UPDATE gfp_file SET gfp02 = l_gfp02 #, gfp04 = g_gfn[l_ac].s_gfn05   #更新多語言
                             WHERE gfp01 = g_gfn01
                               AND gfp02 = l_gfp02_t
               IF SQLCA.sqlcode THEN
                  CALL cl_err("",sqlca.sqlcode,1) 
                  CONTINUE DIALOG
               ELSE
                  MESSAGE "update success!"
               END IF

            CALL cl_chart_load_demo_data()		 
            END IF
			
         BEFORE DELETE
			 IF l_op == "M" THEN
				IF g_gfn.getLength() > 1 THEN
				   DELETE FROM gfn_file WHERE gfn01 = g_gfn01
										  AND gfn02 = g_gfn02 
										  AND gfn03 = l_gfn_t.s_gfn03 
										  AND gfn04 = l_gfn_t.s_gfn04
               LET l_tmp = l_gfn_t.s_gfn04
               LET l_gfp02 = l_gfn_t.s_gfn03, "|", l_tmp.trim()
               DELETE FROM gfp_file WHERE gfp01 = g_gfn01
                                      AND gfp02 = l_gfp02
				ELSE 
				   CALL cl_err("","azz-905",1)
				   CANCEL DELETE
				   CONTINUE DIALOG 
				END IF
				IF SQLCA.sqlcode THEN
				   CALL cl_err("",sqlca.sqlcode,1) 
				   CANCEL DELETE
				END IF
				CALL cl_chart_load_demo_data()
			END IF
         
         ON ACTION lang
            CALL p_chart_gfn_lang(l_ac) RETURNING g_gfn[l_ac].s_gfn05
            DISPLAY g_gfn[l_ac].s_gfn05 TO s_gfn.s_gfn05
            
         ON ACTION CANCEL
            LET g_gfn[l_ac].* = l_gfn_t.*
            EXIT DIALOG
            
         ON ACTION ACCEPT
            IF l_op == "I" THEN
               LET l_tmp = g_gfn[l_ac].s_gfn04
               LET l_gfp02 = g_gfn[l_ac].s_gfn03, "|", l_tmp.trim() 
               INSERT INTO gfn_file VALUES (g_gfn01,
                                            g_gfn02,
                                            g_gfn[l_ac].s_gfn03,
                                            g_gfn[l_ac].s_gfn04,
                                            g_gfn[l_ac].s_gfn05,
                                            ' ',
                                            g_gfn07)
               DECLARE p_chart_lang_cs1 CURSOR FOR SELECT gay01 FROM gay_file
                                  WHERE gayacti = "Y"
                                  ORDER BY gay01
               #FOREACH p_chart_lang_cs1 INTO l_gay01
               #   INSERT INTO gfp_file VALUES (g_gfn01, l_gfp02, l_gay01, g_gfn[l_ac].s_gfn05)
               #END FOREACH
               IF SQLCA.sqlcode THEN
                  CALL cl_err("",sqlca.sqlcode,1) 
                  EXIT DIALOG
               END IF
               LET g_rec_b = l_ac
               CALL cl_chart_load_demo_data() 
            ELSE
               IF l_gfn_t.* != g_gfn[l_ac].* THEN
                  IF cl_null(g_gfn[l_ac].s_gfn05) THEN LET g_gfn[l_ac].s_gfn05 = ' ' END IF
                  UPDATE gfn_file SET gfn03 = g_gfn[l_ac].s_gfn03,
                                      gfn04 = g_gfn[l_ac].s_gfn04,
                                      gfn05 = g_gfn[l_ac].s_gfn05,
                                      gfn07 = g_gfn07
                                  WHERE gfn01 = g_gfn01
                                    AND gfn02 = g_gfn02
                                    AND gfn03 = l_gfn_t.s_gfn03
                                    AND gfn04 = l_gfn_t.s_gfn04
                  LET l_tmp = g_gfn[l_ac].s_gfn04
                  LET l_gfp02 = g_gfn[l_ac].s_gfn03, "|", l_tmp.trim() 
                  LET l_tmp = l_gfn_t.s_gfn04
                  LET l_gfp02_t = l_gfn_t.s_gfn03, "|", l_tmp.trim() 
                  UPDATE gfp_file SET gfp02 = l_gfp02 #, gfp04 = g_gfn[l_ac].s_gfn05   #更新多語言
                                WHERE gfp01 = g_gfn01
                                  AND gfp02 = l_gfp02_t
                  LET g_gfn[l_ac].s_gfn05 = p_chart_get_lang(g_gfn01, l_gfp02, '')
               END IF
            END IF

            EXIT DIALOG
      END INPUT
         
      DISPLAY ARRAY g_gfm TO s_gfm.*         
      END DISPLAY
         

   END DIALOG
END FUNCTION

PRIVATE FUNCTION p_chart_get_lang(p_gfp01, p_gfp02, p_idx)
   DEFINE p_gfp01 LIKE gfp_file.gfp01
   DEFINE p_gfp02 LIKE gfp_file.gfp02
   DEFINE p_idx   STRING
   DEFINE l_gfp04 LIKE gfp_file.gfp04
   
   LET p_idx = p_idx.trim()
   IF NOT cl_null(p_idx) THEN LET p_gfp02 = p_gfp02,"|",p_idx END IF
   SELECT gfp04 INTO l_gfp04 FROM gfp_file WHERE gfp01 = p_gfp01 
                                           AND gfp02 = p_gfp02
                                           AND gfp03 = g_lang
   RETURN l_gfp04
END FUNCTION

PRIVATE FUNCTION p_chart_gfn_lang(p_ac)
   DEFINE p_ac  INTEGER
   DEFINE l_gfp DYNAMIC ARRAY OF RECORD
                gfp01 LIKE gfp_file.gfp01,
                gfp02 LIKE gfp_file.gfp02,
                gfp03 LIKE gfp_file.gfp03,
                gfp04 LIKE gfp_file.gfp04
                END RECORD
   DEFINE l_gfp_t RECORD 
                gfp01 LIKE gfp_file.gfp01,
                gfp02 LIKE gfp_file.gfp02,
                gfp03 LIKE gfp_file.gfp03,
                gfp04 LIKE gfp_file.gfp04
                END RECORD
   DEFINE l_sql STRING
   DEFINE l_idx INTEGER
   DEFINE l_ac  INTEGER
   DEFINE l_op  STRING
   DEFINE l_len INTEGER
   DEFINE l_gfp02 LIKE gfp_file.gfp02
   DEFINE l_gfp04 LIKE gfp_file.gfp04   
   DEFINE l_tmp STRING
   DEFINE l_gfp03 LIKE gfp_file.gfp03
   
   LET l_tmp = g_gfn[p_ac].s_gfn04
   LET l_gfp02 = g_gfn[p_ac].s_gfn03, "|", l_tmp.trim()
   LET l_sql = "SELECT gfp01,gfp02,gfp03,gfp04 FROM gfp_file WHERE gfp01 = ? AND gfp02 = ?"
   PREPARE p_chart_gfn_lang_p1 FROM l_sql
   DECLARE p_chart_gfn_lang_d1 CURSOR FOR p_chart_gfn_lang_p1
   LET l_idx = 1
   FOREACH p_chart_gfn_lang_d1 USING g_gfn01, l_gfp02 INTO l_gfp[l_idx].*
      LET l_idx = l_idx + 1
   END FOREACH
   CALL l_gfp.deleteElement(l_idx)
   
   OPEN WINDOW p_chart_gfn_lang_w WITH FORM "azz/42f/p_chart_gfn_lang"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("p_chart_gfn_lang")
   CALL cl_set_combo_lang("gfp03")
   INPUT ARRAY l_gfp FROM s_gfp.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE,UNBUFFERED=TRUE)
      BEFORE ROW
         LET l_op = "M"
         LET l_ac = ARR_CURR()
         LET l_gfp_t.* = l_gfp[l_ac].*

      AFTER FIELD gfp03
         FOR l_len = 1 TO l_gfp.getLength()
             IF l_len != l_ac AND l_gfp[l_ac].gfp03 == l_gfp[l_len].gfp03 THEN
                ERROR "語言別重覆!"
                NEXT FIELD gfp03
             END IF
         END FOR
      BEFORE INSERT
         LET l_op = "I"

      BEFORE DELETE
         DELETE FROM gfp_file WHERE gfp01 = g_gfn01 AND gfp02 = l_gfp02 AND gfp03 = l_gfp[l_ac].gfp03
         LET l_op = "D"
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
         IF l_op = "M" THEN
            UPDATE gfp_file SET gfp03 = l_gfp[l_ac].gfp03, 
                                gfp04 = l_gfp[l_ac].gfp04
                          WHERE gfp01 = l_gfp[l_ac].gfp01
                            AND gfp03 = l_gfp_t.gfp03
                            AND gfp02 = l_gfp02
                            
            IF SQLCA.sqlcode THEN
               CALL cl_err("",SQLCA.sqlcode,1)
            ELSE
               MESSAGE "Update Success!"
               CONTINUE INPUT
            END IF
         END IF
         IF l_op = "I" THEN
            IF cl_null(l_gfp[l_ac].gfp03) THEN CONTINUE INPUT END IF
            INSERT INTO gfp_file (gfp01, gfp02, gfp03, gfp04) 
                          VALUES (g_gfn01, l_gfp02, l_gfp[l_ac].gfp03, l_gfp[l_ac].gfp04)
            IF SQLCA.sqlcode THEN
               CALL cl_err("",SQLCA.sqlcode,1)
            ELSE  
               MESSAGE "Insert Success!"
            END IF
         END IF
      ON ACTION CLOSE
         EXIT INPUT
   END INPUT
   LET INT_FLAG = FALSE
   CLOSE WINDOW p_chart_gfn_lang_w
   LET l_gfp04 = p_chart_get_lang(g_gfn01, l_gfp02, '')
   RETURN l_gfp04
END FUNCTION

#查詢
FUNCTION p_chart_q()
   LET g_wc = ""
   CONSTRUCT g_wc ON gfn01,gfn02,gfn07 FROM FORMONLY.gfn01_ed, FORMONLY.gfn02_cb, FORMONLY.gfn07_ck
      ON ACTION CLOSE
         EXIT CONSTRUCT
      ON ACTION EXIT
         EXIT CONSTRUCT
   END CONSTRUCT

   CALL p_chart_bp()
END FUNCTION

FUNCTION p_chart_a()
   DEFINE l_gfn01  LIKE gfn_file.gfn01
   DEFINE l_gfn02  LIKE gfn_file.gfn02
   DEFINE l_gfn07  LIKE gfn_file.gfn07
   DEFINE l_cnt    INTEGER
   DEFINE l_gay01  LIKE gay_file.gay01
   LET l_gfn07 = 'N'
   CALL g_gfn.clear()
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)

      DISPLAY ARRAY g_gfm_pics TO g_gfm_pics.*
         BEFORE ROW 
            LET l_gfn02 = g_gfm_pics[ARR_CURR()].gfm01
            CALL p_chart_fill_gfm(l_gfn02)
      END DISPLAY 
      
      DISPLAY ARRAY g_gfm TO s_gfm.*
      END DISPLAY  
      
      DISPLAY ARRAY g_gfn TO s_gfn.*
      END DISPLAY
      
      INPUT l_gfn01,l_gfn02, l_gfn07 FROM gfn01_ed, gfn02_cb, gfn07_ck ATTRIBUTES(WITHOUT DEFAULTS)

         ON CHANGE gfn01_ed
            SELECT COUNT(*) INTO l_cnt FROM gfn_file WHERE gfn01 = l_gfn01
            IF l_cnt > 0 THEN
               CALL cl_err(l_gfn01,"afa-132",1)
               NEXT FIELD gfn01_ed
            END IF

         ON CHANGE gfn02_cb
            CALL p_chart_fill_gfm(l_gfn02)
            CALL p_chart_scroll_pic(DIALOG, l_gfn02)

         
         ON ACTION ACCEPT
            IF INT_FLAG THEN EXIT DIALOG END IF

            IF cl_null(l_gfn01) THEN
               CALL cl_err("","azz-139",1)
               NEXT FIELD gfn01_ed
               CONTINUE DIALOG
            END IF
            BEGIN WORK
               INSERT INTO gfn_file (gfn01,gfn02,gfn03,gfn04,gfn05,gfn07) VALUES (l_gfn01,l_gfn02,"caption", 1, l_gfn02,l_gfn07)
               IF SQLCA.sqlcode THEN
                  CALL cl_err("",sqlca.sqlcode,1) 
                  ROLLBACK WORK
                  NEXT FIELD l_gfn01
               END IF
               DECLARE p_chart_gay01 CURSOR FOR SELECT gay01 FROM gay_file
                                  WHERE gayacti = "Y"
                                  ORDER BY gay01
               FOREACH p_chart_gay01 INTO l_gay01
                  INSERT INTO gfp_file VALUES (l_gfn01, "caption|1", l_gay01, "Caption")
                  IF SQLCA.sqlcode THEN
                     CALL cl_err("",sqlca.sqlcode,1) 
                     ROLLBACK WORK
                     NEXT FIELD l_gfn01
                  END IF
               END FOREACH

            COMMIT WORK
            CLOSE p_chart_gay01
            LET g_gfn01 = l_gfn01
            LET g_gfn02 = l_gfn02
            CALL p_chart_fill_gfn(l_gfn01)
            CALL p_chart_b()
            EXIT DIALOG
            
      END INPUT
      ON ACTION CANCEL
         EXIT DIALOG
   END DIALOG

END FUNCTION

FUNCTION p_chart_fill_gfm(p_gfn02)
   DEFINE p_gfn02  LIKE gfn_file.gfn02
   DEFINE l_i      INTEGER
   CALL g_gfm.clear()
   LET l_i = 1
   FOREACH p_chart_d1 USING p_gfn02 INTO g_gfm[l_i].*
      LET g_gfm[l_i].gfm04 = p_chart_get_lang(g_gfm[l_i].gfm01, g_gfm[l_i].gfm03, '')
      LET l_i = l_i + 1
   END FOREACH 

   CALL g_gfm.deleteElement(l_i)
   CALL p_chart_combo_items(p_gfn02)
END FUNCTION

FUNCTION p_chart_combo_items(p_gfn02)
   DEFINE p_gfn02  LIKE gfn_file.gfn02
   DEFINE l_gfm03  LIKE gfm_file.gfm03
   DEFINE l_items  STRING

   IF NOT cl_null(p_gfn02) THEN
      LET g_gfm01_tmp = p_gfn02   
      FOREACH p_chart_gfn03_d1 USING g_gfm01_tmp INTO l_gfm03
         LET l_items = l_items, l_gfm03, ","
      END FOREACH

      LET l_items = l_items.subString(1, l_items.getLength()-1)
      CALL p_chart_set_table_combo_items("formonly.s_gfn03", l_items)
   END IF 
END FUNCTION

FUNCTION p_chart_fill_gfn(p_gfm01)
   DEFINE p_gfm01  LIKE gfm_file.gfm01
   DEFINE l_i      INTEGER
   DEFINE l_tmp    STRING
   DEFINE l_gfp02  LIKE gfp_file.gfp02
   
   LET l_i = 1
   FOREACH p_chart_d2 USING p_gfm01 INTO g_gfn[l_i].*
      LET g_gfn[l_i].s_gfn05 = p_chart_get_lang(g_gfn01, g_gfn[l_i].s_gfn03, g_gfn[l_i].s_gfn04)
      LET g_gfn[l_i].s_gfm04 = p_chart_get_lang(g_gfn[l_i].s_gfn02, g_gfn[l_i].s_gfn03, '')
      LET l_i = l_i + 1
   END FOREACH 
   CALL g_gfn.deleteElement(l_i)
   LET g_rec_b = l_i - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   CALL cl_navigator_setting( g_curs_index, g_row_count )
END FUNCTION
#宣告CURSOR
FUNCTION p_chart_bp()
   DEFINE l_sql      STRING
   
   CALL g_gfm.clear()
   CALL g_gfn.clear()

   IF NOT cl_null(g_wc) THEN
      LET l_sql = "SELECT gfn01,gfn02,gfn07 FROM gfn_file ",
                  "WHERE ", g_wc, " GROUP BY gfn01,gfn02,gfn07"
      PREPARE p_chart_q1 FROM l_sql
      DECLARE p_chart_d3 SCROLL CURSOR FOR p_chart_q1    
      OPEN p_chart_d3
      
      LET l_sql = "SELECT COUNT(DISTINCT gfn01) FROM gfn_file ",
                  "WHERE ", g_wc
      PREPARE p_chart_c1 FROM l_sql
      EXECUTE p_chart_c1 INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_chart_fetch("F")
   END IF
END FUNCTION

#換筆
FUNCTION p_chart_fetch(p_f)
   DEFINE p_f      STRING
   DEFINE l_cnt    INTEGER
   
   CASE p_f
      WHEN 'N' FETCH NEXT     p_chart_d3 INTO g_gfn01,g_gfn02,g_gfn07 
         LET g_curs_index = g_curs_index + 1 
      WHEN 'P' FETCH PREVIOUS p_chart_d3 INTO g_gfn01,g_gfn02,g_gfn07
         LET g_curs_index = g_curs_index - 1
      WHEN 'F' FETCH FIRST    p_chart_d3 INTO g_gfn01,g_gfn02,g_gfn07
         LET g_curs_index = 1
      WHEN 'L' FETCH LAST     p_chart_d3 INTO g_gfn01,g_gfn02,g_gfn07
         LET g_curs_index = g_row_count
      WHEN '/'

         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0
         PROMPT g_msg CLIPPED,': ' FOR g_jump
            ON IDLE g_idle_seconds
               CALL cl_on_idle() 
            ON ACTION about
               CALL cl_about()         
            ON ACTION help
               CALL cl_show_help()         
            ON ACTION controlg
               CALL cl_cmdask() 
         END PROMPT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            RETURN
         END IF

         FETCH ABSOLUTE g_jump p_chart_d3 INTO g_gfn01,g_gfn02,g_gfn07
         LET g_curs_index = g_jump
   END CASE 
   IF NOT cl_null(g_gfn01) THEN
      CALL cl_set_act_visible("auth_user,add_to_gdk,auth_dep,modify_chart_name", TRUE)
   ELSE
      CALL cl_set_act_visible("auth_user,add_to_gdk,auth_dep,modify_chart_name", FALSE)
   END IF   
   #檢查圖表是否已經在gdk_file中
   SELECT COUNT(gdk01) INTO l_cnt FROM gdk_file WHERE gdk01 = g_gfn01
   IF l_cnt > 0 THEN
      CALL cl_set_action_active("add_to_gdk", FALSE)
   ELSE
      CALL cl_set_action_active("add_to_gdk", TRUE)
   END IF
   
   CALL cl_navigator_setting(g_curs_index, g_row_count)
   INITIALIZE g_gfn TO NULL

   LET g_gfp04 = p_chart_get_lang(g_gfn01, 'name', '')

   DISPLAY g_gfp04 TO s_gfp04
   DISPLAY g_gfn01 TO gfn01_ed
   DISPLAY g_gfn02 TO gfn02_cb
   DISPLAY g_gfn07 TO gfn07_ck

   CALL p_chart_fill_gfm(g_gfn02)

   CALL p_chart_fill_gfn(g_gfn01)
   
   CALL ui.Interface.refresh()
   CALL cl_chart_load_demo_data()

END FUNCTION

#顯示資料
FUNCTION p_chart_show()
   DEFINE l_i    INTEGER
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
   
      DISPLAY ARRAY g_gfm_pics TO g_gfm_pics.*
      END DISPLAY 
      
      DISPLAY ARRAY g_gfm TO s_gfm.*         
      END DISPLAY
      
      DISPLAY ARRAY g_gfn TO s_gfn.*
      END DISPLAY

      BEFORE DIALOG
         CALL cl_navigator_setting(g_curs_index, g_row_count)
      ON ACTION first
         CALL p_chart_fetch("F")
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION previous 
         CALL p_chart_fetch('P')
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION next
         CALL p_chart_fetch('N')
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION last
         CALL p_chart_fetch('L') 
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION jump
         CALL p_chart_fetch('/')
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION detail
         CALL p_chart_b()
      ON ACTION EXIT
         EXIT DIALOG
      ON ACTION CLOSE
         EXIT DIALOG
      ON ACTION query
         CALL p_chart_q()
         CALL p_chart_scroll_pic(DIALOG, g_gfn02)
      ON ACTION reproduce
         CALL p_chart_copy()
      ON ACTION insert
         CALL p_chart_a()
      ON ACTION DELETE
         IF NOT cl_null(g_gfn01) THEN
            IF cl_confirm("lib-001") THEN            
               DELETE FROM gfn_file WHERE gfn01 = g_gfn01
               DELETE FROM gfp_file WHERE gfp01 = g_gfn01
               LET g_gfn01 = NULL          
               CLEAR FORM
            END IF
         END IF
         CONTINUE DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_chart_load_demo_data() 
      ON ACTION auth_user
         CALL p_chart_user()
      ON ACTION auth_dep
         CALL p_chart_dep()
      #ON ACTION cl_fc_dummy
      #   CALL cl_show_fc("cl_fc_dummy")
      #ON ACTION cl_fc_dummy_3c
      #   CALL cl_show_fc("cl_fc_dummy_3c")
      #ON ACTION cl_fc_dummy_4c
      #   CALL cl_show_fc("cl_fc_dummy_4c")
      
      #ON ACTION run_test
      #   CALL p_chart_ms('00','0709','100101',2010,'001-000','220002','Y001')
      #   MENU
      #      ON ACTION CLOSE
      #         EXIT MENU
      #   END MENU
      
      ON ACTION add_to_gdk
         SELECT COUNT(gdk01) INTO l_i FROM gdk_file WHERE gdk01 = g_gfn01
         IF l_i > 0 THEN
            ERROR "已加入自訂圖表清單中!"
         ELSE
            INSERT INTO gdk_file (gdk01,   gdk02, gdk03,gdkuser,gdkdate,gdkgrup,gdkmodu,gdkoriu,gdkorig)
                          VALUES (g_gfn01, ' ',   ' ',  g_user, g_today, g_grup, g_user, g_user, g_grup)
            IF SQLCA.sqlcode THEN
               CALL cl_err("",sqlca.sqlcode,1) 
            ELSE
               CALL cl_set_action_active("add_to_gdk", FALSE)
               MESSAGE "Insert Success!"
            END IF
         END IF
         
      ON ACTION modify_chart_name
         IF cl_null(g_gfn01) THEN
            ERROR "請先選擇欲處理的資料"
            CONTINUE DIALOG
         END IF
         CALL p_chart_modify_chart_name()  
   END DIALOG
END FUNCTION

PRIVATE FUNCTION p_chart_modify_chart_name()
   DEFINE l_gfp   DYNAMIC ARRAY OF RECORD 
            gfp01        LIKE gfp_file.gfp01, #圖表代號
            gfp03        LIKE gfp_file.gfp03, #語言別
            gfp04_name   LIKE gfp_file.gfp04, #圖表名稱
            gfp04_desc   LIKE gfp_file.gfp04  #圖表說明
                  END RECORD
   DEFINE l_sql   STRING
   DEFINE l_len   INTEGER
   DEFINE l_op    STRING,
          l_ac    INTEGER
   DEFINE l_gfp_t RECORD
            gfp01        LIKE gfp_file.gfp01, #圖表代號
            gfp03        LIKE gfp_file.gfp03, #語言別
            gfp04_name   LIKE gfp_file.gfp04, #圖表名稱
            gfp04_desc   LIKE gfp_file.gfp04  #圖表說明
                  END RECORD

   LET l_sql = "SELECT a.gfp01, a.gfp03, a.gfp04, b.gfp04 FROM gfp_file a JOIN gfp_file b ", 
               "ON a.gfp01 = b.gfp01 AND b.gfp02 = 'desc' AND a.gfp03 = b.gfp03 WHERE a.gfp01 = ? ",
               " AND a.gfp02='name' GROUP BY a.gfp01, a.gfp03, a.gfp04, b.gfp04 ORDER BY a.gfp03"
   PREPARE p_chart_gfp_p1 FROM l_sql
   DECLARE p_chart_gfp_d1 CURSOR FOR p_chart_gfp_p1
   LET l_len = 1
   FOREACH p_chart_gfp_d1 USING g_gfn01 INTO l_gfp[l_len].*
      LET l_len = l_len + 1
   END FOREACH
   CALL l_gfp.deleteElement(l_len)
   
   OPEN WINDOW p_chart_gfp_w WITH FORM "azz/42f/p_chart_gfp"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("p_chart_gfp")
   CALL cl_set_combo_lang("gfp03")
   INPUT ARRAY l_gfp FROM s_gfp.* ATTRIBUTES(UNBUFFERED=TRUE,WITHOUT DEFAULTS=TRUE)
      BEFORE ROW
         LET l_op = "M"
         LET l_ac = ARR_CURR()
         LET l_gfp_t.* = l_gfp[l_ac].*

      AFTER FIELD gfp03
         FOR l_len = 1 TO l_gfp.getLength()
             IF l_len != l_ac AND l_gfp[l_ac].gfp03 == l_gfp[l_len].gfp03 THEN
                ERROR "語言別重覆!"
                NEXT FIELD gfp03
             END IF
         END FOR
      BEFORE INSERT
         LET l_op = "I"
      BEFORE DELETE
         DELETE FROM gfp_file WHERE gfp01 = l_gfp[l_ac].gfp01 AND gfp02 = 'name' AND gfp03 = l_gfp[l_ac].gfp03
         DELETE FROM gfp_file WHERE gfp01 = l_gfp[l_ac].gfp01 AND gfp02 = 'desc' AND gfp03 = l_gfp[l_ac].gfp03
         LET l_op = "D"
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
         IF l_op = "M" THEN
            UPDATE gfp_file SET gfp03 = l_gfp[l_ac].gfp03, 
                                gfp04 = l_gfp[l_ac].gfp04_name
                          WHERE gfp01 = l_gfp[l_ac].gfp01
                            AND gfp03 = l_gfp_t.gfp03
                            AND gfp02 = 'name'
            UPDATE gfp_file SET gfp03 = l_gfp[l_ac].gfp03, 
                                gfp04 = l_gfp[l_ac].gfp04_desc
                          WHERE gfp01 = l_gfp[l_ac].gfp01
                            AND gfp03 = l_gfp_t.gfp03
                            AND gfp02 = 'desc'
                            
            IF SQLCA.sqlcode THEN
               CALL cl_err("",SQLCA.sqlcode,1)
            ELSE
               MESSAGE "Update Success!"
               CONTINUE INPUT
            END IF
         END IF
         IF l_op = "I" THEN
            INSERT INTO gfp_file (gfp01, gfp02, gfp03, gfp04) 
                          VALUES (g_gfn01, "name", l_gfp[l_ac].gfp03, l_gfp[l_ac].gfp04_name)
            INSERT INTO gfp_file (gfp01, gfp02, gfp03, gfp04) 
                          VALUES (g_gfn01, "desc", l_gfp[l_ac].gfp03, l_gfp[l_ac].gfp04_desc)
            IF SQLCA.sqlcode THEN
               CALL cl_err("",SQLCA.sqlcode,1)
            ELSE  
               MESSAGE "Insert Success!"
            END IF
         END IF
      ON ACTION CLOSE
         EXIT INPUT
   END INPUT
   LET INT_FLAG = FALSE
   CLOSE WINDOW p_chart_gfp_w
   
   LET g_gfp04 = p_chart_get_lang(g_gfn01, 'name', '')
   
   DISPLAY g_gfp04 TO FORMONLY.s_gfp04
END FUNCTION

FUNCTION p_chart_dep() 
   OPEN WINDOW p_chart_dep_w WITH FORM "azz/42f/p_chart_dep"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("p_chart_dep")
   LET g_wc3 = "1=1"
   WHILE TRUE
      CALL p_chart_dep_show()
      CASE g_action_choice
         WHEN "query"
            CALL p_chart_dep_q()
         WHEN "detail"
            CALL p_chart_dep_b()
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
   CLOSE WINDOW p_chart_dep_w
END FUNCTION

FUNCTION p_chart_dep_q()
   CALL cl_set_act_visible("accept,cancel",TRUE)
   CALL g_gdj_3.clear()
   CONSTRUCT g_wc3 ON gdj03,gem02 FROM s_gdj.gdj03, s_gdj.gem02
   IF cl_null(g_wc3) THEN LET g_wc3= "1=1" END IF
END FUNCTION

FUNCTION p_chart_dep_show()
   DEFINE l_sql   STRING
   DEFINE l_len   INTEGER
   
   LET l_sql = "SELECT gdj03, gem02 FROM gdj_file INNER JOIN gem_file ON gdj03 = gem01 ",
               " WHERE ",g_wc3," AND gdj02 = '1' AND gdj01 = ? "
   DECLARE p_chart_gdj_gem_sel1 CURSOR FROM l_sql
   CALL g_gdj_3.clear()
   LET l_len = 1
   FOREACH p_chart_gdj_gem_sel1 USING g_gfn01 INTO g_gdj_3[l_len].*
      LET l_len = l_len + 1
   END FOREACH
   CALL g_gdj_3.deleteElement(l_len)
   CALL cl_set_act_visible("accept,cancel",FALSE)
   
   DISPLAY ARRAY g_gdj_3 TO s_gdj.*
      ON ACTION detail
         LET g_action_choice = "detail"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice = "query"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice = "exit"
         EXIT DISPLAY
   END DISPLAY
   
END FUNCTION

FUNCTION p_chart_user()
 
   OPEN WINDOW p_chart_user_w WITH FORM "azz/42f/p_chart_user"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("p_chart_user")
   LET g_wc2 = "1=1"
   WHILE TRUE
      CALL p_chart_user_show()
      CASE g_action_choice
         WHEN "query"
            CALL p_chart_user_q()
         WHEN "detail"
            CALL p_chart_user_b()
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
   

   CLOSE WINDOW p_chart_user_w
END FUNCTION

FUNCTION p_chart_user_q()
   CALL cl_set_act_visible("accept,cancel",TRUE)
   CALL g_gdj_2.clear()
   CONSTRUCT g_wc2 ON gdj03,zx02 FROM s_gdj.gdj03, s_gdj.zx02
   IF cl_null(g_wc2) THEN LET g_wc2 = "1=1" END IF
END FUNCTION

FUNCTION p_chart_dep_b()
    DEFINE l_gdj_t RECORD
              gdj03  LIKE gdj_file.gdj03,
              gem02  LIKE gem_file.gem02
                  END RECORD
   DEFINE l_op    STRING,
          l_ac    INTEGER,
          l_sql   STRING,
          l_len   INTEGER
   DEFINE l_gem01  LIKE gem_file.gem01
   
   LET INT_FLAG = 0
   LET l_sql = "UPDATE gdj_file SET gdj03=?, ",
            "                       gdjdate = to_date(?,'yyyy-mm-dd hh24:mi:ss'), ",
            "                       gdjmodu = ? ",
            "                       WHERE gdj01 = ? AND gdj02 = '1' AND gdj03 = ?"                    
   PREPARE p_chart_gdj_gem_upd FROM l_sql
   LET l_sql = "INSERT INTO gdj_file (gdj01,gdj02,gdj03,gdjdate,gdjgrup,gdjmodu,gdjorig,gdjoriu,gdjuser) VALUES ",
               "                     (?    ,'1'    ,?    ,?      ,?      ,?      ,?      ,?      ,?)"
   PREPARE p_chart_gdj_gem_ins FROM l_sql   
   CALL cl_set_act_visible("accept,cancel",TRUE)
   INPUT ARRAY g_gdj_3 FROM s_gdj.* ATTRIBUTES(WITHOUT DEFAULTS, UNBUFFERED)
      BEFORE INSERT 
         LET l_op = "I"
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_op = "M"
         LET l_gdj_t.* = g_gdj_3[l_ac].*
         
      ON ACTION controlp
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gem"
         LET g_qryparam.state = "i"
         CALL cl_create_qry() RETURNING l_gem01
         LET g_gdj_3[l_ac].gdj03 = l_gem01
         SELECT gem02 INTO g_gdj_3[l_ac].gem02 FROM gem_file WHERE gem01 = g_gdj_3[l_ac].gdj03

      ON ROW CHANGE
         IF l_op != "I" THEN LET l_op = "M" END IF
         
      BEFORE DELETE
         IF cl_confirm("p_tgr14") THEN
               DELETE FROM gdj_file WHERE gdj01 = g_gfn01 AND gdj02 = '1' AND gdj03 = g_gdj_3[l_ac].gdj03
               IF SQLCA.sqlcode THEN
                  CALL cl_err("",sqlca.sqlcode,1)
                  CANCEL DELETE
               ELSE
                  MESSAGE "Delete success!"
               END IF
         END IF

      AFTER DELETE
         LET l_op = ""

      ON CHANGE gdj03
         IF NOT cl_null(g_gdj_3[l_ac].gdj03) THEN
         FOR l_len = 1 TO g_gdj_3.getLength()
            IF l_len != l_ac AND g_gdj_3[l_len].gdj03 == g_gdj_3[l_ac].gdj03 THEN
               CALL cl_err("","atm-310",1)
               NEXT FIELD gdj03
            END IF
         END FOR
         SELECT COUNT(gem01) INTO l_len FROM gem_file WHERE gem01 = g_gdj_3[l_ac].gdj03
         END IF
         
      AFTER FIELD gdj03
         FOR l_len = 1 TO g_gdj_3.getLength()
            IF l_len != l_ac AND g_gdj_3[l_len].gdj03 == g_gdj_3[l_ac].gdj03 THEN
               CALL cl_err("","atm-310",1)
               NEXT FIELD gdj03
            END IF
         END FOR
         SELECT COUNT(gem01) INTO l_len FROM gem_file WHERE gem01 = g_gdj_3[l_ac].gdj03
         IF l_len == 0 AND NOT cl_null(g_gdj_3[l_ac].gdj03) THEN
            CALL cl_err("","aoo-001",1)
            NEXT FIELD gdj03
         ELSE
            SELECT gem02 INTO g_gdj_3[l_ac].gem02 FROM gem_file WHERE gem01 = g_gdj_3[l_ac].gdj03   
            LET l_gem01 = g_gdj_3[l_ac].gdj03   
         END IF

      
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(l_gem01) THEN LET l_op = "" END IF
         IF l_op == "M" THEN
            EXECUTE p_chart_gdj_gem_upd USING l_gem01 , g_today, g_user, g_gfn01, l_gdj_t.gdj03
            IF SQLCA.sqlcode THEN
               CALL cl_err("",sqlca.sqlcode,1)
               EXIT INPUT
            ELSE
               MESSAGE "Update success!"
            END IF
            LET l_op = ""
         END IF
         IF l_op = "I" THEN
            EXECUTE p_chart_gdj_gem_ins USING g_gfn01, l_gem01 , g_today, g_grup, g_user, g_grup, g_user, g_user
            IF SQLCA.sqlcode THEN
               CALL cl_err("",sqlca.sqlcode,1)
            ELSE
               MESSAGE "Insert success!"
            END IF
         END IF          
   END INPUT
   LET INT_FLAG = 0
END FUNCTION

FUNCTION p_chart_user_show()
   DEFINE l_sql   STRING
   DEFINE l_len   INTEGER
   
   LET l_sql = "SELECT gdj03, zx02 FROM gdj_file INNER JOIN zx_file ON gdj03 = zx01 ",
               " WHERE ",g_wc2," AND gdj02 = '2' AND gdj01 = ? "
   DECLARE p_chart_gdj_zx02_sel1 CURSOR FROM l_sql
   CALL g_gdj_2.clear()
   LET l_len = 1
   FOREACH p_chart_gdj_zx02_sel1 USING g_gfn01 INTO g_gdj_2[l_len].*
      LET l_len = l_len + 1
   END FOREACH
   CALL g_gdj_2.deleteElement(l_len)
   CALL cl_set_act_visible("accept,cancel",FALSE)
   
   DISPLAY ARRAY g_gdj_2 TO s_gdj.*
      ON ACTION detail
         LET g_action_choice = "detail"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice = "query"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice = "exit"
         EXIT DISPLAY
   END DISPLAY
   
END FUNCTION

FUNCTION p_chart_user_b()
   DEFINE l_gdj_t RECORD
              gdj03 LIKE gdj_file.gdj03,
              zx02  LIKE zx_file.zx02
                  END RECORD
   DEFINE l_op    STRING,
          l_ac    INTEGER,
          l_sql   STRING,
          l_len   INTEGER
   DEFINE l_zx01  LIKE zx_file.zx01
   
   LET INT_FLAG = 0
   LET l_sql = "UPDATE gdj_file SET gdj03=?, ",
            "                       gdjdate = to_date(?,'yyyy-mm-dd hh24:mi:ss'), ",
            "                       gdjmodu = ? ",
            "                       WHERE gdj01 = ? AND gdj02 = '2' AND gdj03 = ?"                    
   PREPARE p_chart_gdj_zx02_upd FROM l_sql
   LET l_sql = "INSERT INTO gdj_file (gdj01,gdj02,gdj03,gdjdate,gdjgrup,gdjmodu,gdjorig,gdjoriu,gdjuser) VALUES ",
               "                     (?    ,'2'    ,?    ,?      ,?      ,?      ,?      ,?      ,?)"
   PREPARE p_chart_gdj_zx02_ins FROM l_sql   
   CALL cl_set_act_visible("accept,cancel",TRUE)
   INPUT ARRAY g_gdj_2 FROM s_gdj.* ATTRIBUTES(WITHOUT DEFAULTS, UNBUFFERED)
      BEFORE INSERT 
         LET l_op = "I"
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_op = "M"
         LET l_gdj_t.* = g_gdj_2[l_ac].*
         
      ON ACTION controlp
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_zx01"
         LET g_qryparam.state = "i"
         CALL cl_create_qry() RETURNING l_zx01
         LET g_gdj_2[l_ac].gdj03 = l_zx01
         SELECT zx02 INTO g_gdj_2[l_ac].zx02 FROM zx_file WHERE zx01 = g_gdj_2[l_ac].gdj03

      ON ROW CHANGE
         IF l_op != "I" THEN LET l_op = "M" END IF
         
      BEFORE DELETE
         IF cl_confirm("p_tgr14") THEN
               DELETE FROM gdj_file WHERE gdj01 = g_gfn01 AND gdj02 = '2' AND gdj03 = g_gdj_2[l_ac].gdj03
               IF SQLCA.sqlcode THEN
                  CALL cl_err("",sqlca.sqlcode,1)
                  CANCEL DELETE
               ELSE
                  MESSAGE "Delete success!"
               END IF
         END IF

      AFTER DELETE
         LET l_op = ""

      ON CHANGE gdj03
         IF NOT cl_null(g_gdj_2[l_ac].gdj03) THEN
         FOR l_len = 1 TO g_gdj_2.getLength()
            IF l_len != l_ac AND g_gdj_2[l_len].gdj03 == g_gdj_2[l_ac].gdj03 THEN
               CALL cl_err("","atm-310",1)
               NEXT FIELD gdj03
            END IF
         END FOR
         SELECT COUNT(zx01) INTO l_len FROM zx_file WHERE zx01 = g_gdj_2[l_ac].gdj03
         END IF
         
      AFTER FIELD gdj03
         FOR l_len = 1 TO g_gdj_2.getLength()
            IF l_len != l_ac AND g_gdj_2[l_len].gdj03 == g_gdj_2[l_ac].gdj03 THEN
               CALL cl_err("","atm-310",1)
               NEXT FIELD gdj03
            END IF
         END FOR
         SELECT COUNT(zx01) INTO l_len FROM zx_file WHERE zx01 = g_gdj_2[l_ac].gdj03
         IF l_len == 0 AND NOT cl_null(g_gdj_2[l_ac].gdj03) THEN
            CALL cl_err("","aoo-001",1)
            NEXT FIELD gdj03
         ELSE
            SELECT zx02 INTO g_gdj_2[l_ac].zx02 FROM zx_file WHERE zx01 = g_gdj_2[l_ac].gdj03   
            LET l_zx01 = g_gdj_2[l_ac].gdj03   
         END IF

      
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(l_zx01) THEN LET l_op = "" END IF
         IF l_op == "M" THEN
            EXECUTE p_chart_gdj_zx02_upd USING l_zx01 , g_today, g_user, g_gfn01, l_gdj_t.gdj03
            IF SQLCA.sqlcode THEN
               CALL cl_err("",sqlca.sqlcode,1)
               EXIT INPUT
            ELSE
               MESSAGE "Update success!"
            END IF
            LET l_op = ""
         END IF
         IF l_op = "I" THEN
            EXECUTE p_chart_gdj_zx02_ins USING g_gfn01, l_zx01 , g_today, g_grup, g_user, g_grup, g_user, g_user
            IF SQLCA.sqlcode THEN
               CALL cl_err("",sqlca.sqlcode,1)
               EXIT INPUT
            ELSE
               MESSAGE "Insert success!"
            END IF
         END IF          
   END INPUT
   LET INT_FLAG = 0
END FUNCTION


#run_test要刪除
FUNCTION p_chart_ss(p_img01)
   DEFINE p_img01    LIKE img_file.img01   #料件編號
   DEFINE l_img    DYNAMIC ARRAY OF RECORD 
            img02    LIKE img_file.img02,  #倉庫編號
            img03    LIKE img_file.img03,  #儲位
            img09    LIKE img_file.img09,  #庫存單位
            img10    LIKE img_file.img10   #庫存量
                   END RECORD
   DEFINE l_sql    STRING
   DEFINE l_li     INTEGER
   DEFINE l_lb  STRING          #各數值x軸標籤
   
   LET l_sql = "SELECT img02,img03,img09,SUM(img10) FROM img_file ",
                  " WHERE img01 = ? ",
                  "   AND img10 > 0 ",
                  " GROUP BY img02,img03,img09" 
                  
   PREPARE img_chart_pre1 FROM l_sql
   DECLARE img_chart_d1 CURSOR FOR img_chart_pre1

   LET l_li = 0
   CALL cl_chart_init_comp("demo_wc1") #初始WebComponent的資料
   FOREACH img_chart_d1 USING p_img01 INTO l_img[l_li+1].* 
      LET l_lb = l_img[l_li+1].img02, "-", l_img[l_li+1].img03
      CALL cl_chart_array_data_comp("demo_wc1", "dataset", l_lb, l_img[l_li+1].img10)
      LET l_li = l_li + 1
   END FOREACH
   CALL cl_chart_attr_comp("demo_wc1", "subcaption", l_img[1].img09)
   CALL cl_chart_create_comp("demo_wc1","c_img01")
END FUNCTION
FUNCTION p_chart_ms(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,p_afc042)
   DEFINE p_afc00   LIKE afc_file.afc00,
          p_afc01   LIKE afc_file.afc01,
          p_afc02   LIKE afc_file.afc02,
          p_afc03   LIKE afc_file.afc03,
          p_afc04   LIKE afc_file.afc04,
          p_afc041  LIKE afc_file.afc041,
          p_afc042  LIKE afc_file.afc042
   DEFINE l_afc     DYNAMIC ARRAY OF RECORD
             afc05  LIKE afc_file.afc05,
             afc06  LIKE afc_file.afc06,
             afc07  LIKE afc_file.afc07
                    END RECORD
   DEFINE l_sql     STRING
   DEFINE l_li      INTEGER
   
   LET l_sql = "SELECT afc05,afc06,afc07 FROM afc_file ",
                   " WHERE afc00=? AND afc01=? AND afc02=? AND afc03=?",
                   "   AND afc04=? AND afc041=? AND afc042=?"
   PREPARE p_chart_afcp1 FROM l_sql
   DECLARE p_chart_afcd1 CURSOR FOR p_chart_afcp1 
   
   LET l_li = 0
   CALL cl_chart_init_comp("demo_wc1") 
   FOREACH p_chart_afcd1 USING p_afc00,p_afc01,p_afc02,
                               p_afc03,p_afc04,p_afc041,p_afc042
                          INTO l_afc[l_li+1].*
      CALL cl_chart_array_data_comp("demo_wc1","categories","",l_afc[l_li+1].afc05)
      CALL cl_chart_array_data_comp("demo_wc1","dataset","afc06",l_afc[l_li+1].afc06)
      CALL cl_chart_array_data_comp("demo_wc1","dataset","afc07",l_afc[l_li+1].afc07)
      LET l_li = l_li + 1
   END FOREACH
   CALL cl_chart_create_comp("demo_wc1","c_afc01")
   CALL cl_chart_clear_comp("demo_wc1")
END FUNCTION
#run_test要刪除

#複製成新圖表代碼
FUNCTION p_chart_copy()
   DEFINE l_gfn01   LIKE gfn_file.gfn01
   DEFINE l_gfn02   LIKE gfn_file.gfn02
   DEFINE l_gfn07   LIKE gfn_file.gfn07
   DEFINE l_cnt     INTEGER
   DEFINE l_i       INTEGER
   LET l_gfn02 = g_gfn02
   LET l_gfn07 = g_gfn07
   INPUT l_gfn01 FROM gfn01_ed ATTRIBUTES(WITHOUT DEFAULTS=TRUE,UNBUFFERED=TRUE)
      ON ACTION accept
         IF NOT cl_null(l_gfn01) THEN
            SELECT COUNT(gfn01) INTO l_cnt FROM gfn_file WHERE gfn01 = l_gfn01
            IF l_cnt > 0 THEN
               CALL cl_err(l_gfn01,"afa-132",1)
               CONTINUE INPUT
            ELSE
               PREPARE p_chart_gfn_a1 FROM "INSERT INTO gfn_file (gfn01,gfn02,gfn03,gfn04,gfn05,gfn07)  VALUES (?,?,?,?,?,?)"
               FOR l_i = 1 TO g_gfn.getlength()
                  EXECUTE p_chart_gfn_a1 USING l_gfn01,l_gfn02,g_gfn[l_i].s_gfn03,
                                               g_gfn[l_i].s_gfn04,g_gfn[l_i].s_gfn05,
                                               l_gfn07
               END FOR
               MESSAGE "insert successed!"
               EXIT INPUT
            END IF
         END IF         
         
      ON ACTION CANCEL
         EXIT INPUT
   END INPUT
END FUNCTION

#將PictureFlow捲到正確的圖表類型
FUNCTION p_chart_scroll_pic(p_dialog, p_gfn02)
   DEFINE p_dialog  ui.Dialog,
          p_gfn02   LIKE gfn_file.gfn02
   DEFINE l_i       INTEGER
   FOR l_i = 1 TO g_gfm_pics.getLength()
      IF p_gfn02 == g_gfm_pics[l_i].gfm01 THEN
         CALL p_dialog.setCurrentRow("g_gfm_pics",l_i)
         EXIT FOR
      END IF
   END FOR 
END FUNCTION

#載入demo data
FUNCTION cl_chart_load_demo_data()
   DEFINE l_labels  DYNAMIC ARRAY OF STRING
   DEFINE l_idx     INTEGER
   DEFINE l_gfm02   LIKE gfm_file.gfm02  #圖表類型 1.單一數列 2.多數列
   
   CALL cl_chart_clear_comp("demo_wc1")

   LET l_labels[1] = "January"
   LET l_labels[2] = "February"
   LET l_labels[3] = "March"
   LET l_labels[4] = "April"
   LET l_labels[5] = "May"   
   LET l_labels[6] = "June"
   LET l_labels[7] = "July"
   LET l_labels[8] = "August"
   LET l_labels[9] = "September"
   LET l_labels[10] = "October"
   LET l_labels[11] = "November"
   LET l_labels[12] = "December"

   CALL cl_chart_init_comp("demo_wc1")

   SELECT MAX(gfm02) INTO l_gfm02 FROM gfm_file,gfn_file WHERE gfm01 = g_gfn02 AND gfn01 = g_gfn01
   CASE g_gfn02
      WHEN "AngularGauge"
         CALL cl_chart_ag_comp("demo_wc1", "", util.Math.rand(100), 0, 100)
         CALL cl_chart_create_comp("demo_wc1",g_gfn01)
         RETURN
      WHEN "BulbGauge"
         CALL cl_chart_bulb_comp("demo_wc1", "", util.Math.rand(100), 33,66,100)
         CALL cl_chart_create_comp("demo_wc1",g_gfn01)
         RETURN
   END CASE
  
   CASE l_gfm02
      WHEN 1
         CALL util.Math.srand()   
         FOR l_idx = 1 TO 12
            CALL cl_chart_array_data_comp("demo_wc1","dataset", l_labels[l_idx], (util.Math.rand(300) + 100))
         END FOR 
      WHEN 2
         FOR l_idx = 1 TO 12
            CALL cl_chart_array_data_comp("demo_wc1","categories", "", l_labels[l_idx])
            CALL cl_chart_array_data_comp("demo_wc1","dataset", "Serial 1", (util.Math.rand(300) + 100))
            CALL cl_chart_array_data_comp("demo_wc1","dataset", "Serial 2", (util.Math.rand(300) + 100))
            CALL cl_chart_array_data_comp("demo_wc1","dataset", "Serial 3", (util.Math.rand(300) + 100))
         END FOR 
         CALL cl_chart_array_attr_comp("demo_wc1","Serial 1","seriesName","serial_1")
         CALL cl_chart_array_attr_comp("demo_wc1","Serial 2","seriesName","serial_2")
         CALL cl_chart_array_attr_comp("demo_wc1","Serial 3","seriesName","serial_3")
   END CASE

   CALL cl_chart_create_comp("demo_wc1",g_gfn01)
   
   
END FUNCTION

FUNCTION p_chart_set_table_combo_items(p_fieldname, ps_values)
   DEFINE p_fieldname   STRING, 
          ps_values     STRING
   DEFINE l_win     ui.Window
   DEFINE l_node    om.DomNode,
          l_item    om.DomNode
   DEFINE st        base.StringTokenizer
   DEFINE l_value   STRING
   
   LET l_win = ui.Window.getCurrent()
   LET l_node = l_win.findNode("TableColumn",p_fieldname)
   IF l_node IS NOT NULL THEN
      LET l_node = l_node.getFirstChild()
      IF l_node.getTagName() == "ComboBox" THEN
         WHILE l_node.getChildCount() > 0
            LET l_item = l_node.getFirstChild()
            CALL l_node.removeChild(l_item)
         END WHILE
         LET st = base.StringTokenizer.create(ps_values, ",")
         WHILE st.hasMoreTokens()
            LET l_value = st.nextToken()
            LET l_item = l_node.createChild("Item")
            CALL l_item.setAttribute("name", l_value)
            CALL l_item.setAttribute("text", l_value)
         END WHILE 
      END IF
   END IF
   CALL ui.Interface.refresh()
END FUNCTION
