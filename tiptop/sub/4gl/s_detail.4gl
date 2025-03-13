# Prog. Version..: 
#
# Pattern name...: s_detail.4gl
# Descriptions...: 
# Date & Author..: #FUN-A50054 10/05/21 By chenmoyan 
# Modify.........: No:#FUN-A60035 10/06/29 By chenls 進入單身直接show出顏色 各顏色對應尺寸默認為0
#                                                    退出時判斷合計為0的刪除

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE
   g_ata03  DYNAMIC ARRAY WITH DIMENSION 2 OF INTEGER,
   g_ata1   DYNAMIC ARRAY OF RECORD
   ata03     LIKE ata_file.ata03,
   ata04     LIKE ata_file.ata04,
   ata06     LIKE ata_file.ata06,
   ata07     LIKE ata_file.ata07,
   ata08     LIKE ata_file.ata08
   END RECORD,
   g_ata1_t RECORD
   ata03     LIKE ata_file.ata03,
   ata04     LIKE ata_file.ata04,
   ata06     LIKE ata_file.ata06,
   ata07     LIKE ata_file.ata07,
   ata08     LIKE ata_file.ata08
   END RECORD,
   
   g_ata    DYNAMIC ARRAY OF RECORD
   ata06     LIKE ata_file.ata06,
   ata07     LIKE ata_file.ata07,
   ata08     LIKE ata_file.ata08,
   ata09     LIKE ata_file.ata09,
   ata10     LIKE ata_file.ata10,
   ata11     LIKE ata_file.ata11,
   ata12     LIKE ata_file.ata12,
   ata13     LIKE ata_file.ata13,
   ata14     LIKE ata_file.ata14,
   ata15     LIKE ata_file.ata15,
   ata16     LIKE ata_file.ata16,
   ata17     LIKE ata_file.ata17,
   ata18     LIKE ata_file.ata18,
   ata19     LIKE ata_file.ata19,
   ata20     LIKE ata_file.ata20,
   ata21     LIKE ata_file.ata21,
   ata22     LIKE ata_file.ata22,
   ata23     LIKE ata_file.ata23,
   ata24     LIKE ata_file.ata24,
   ata25     LIKE ata_file.ata25,
   ata26     LIKE ata_file.ata26,
   ata27     LIKE ata_file.ata27,
   ata28     LIKE ata_file.ata28
   END RECORD,
   g_ata_t  RECORD
   ata06     LIKE ata_file.ata06,
   ata07     LIKE ata_file.ata07,
   ata08     LIKE ata_file.ata08,
   ata09     LIKE ata_file.ata09,
   ata10     LIKE ata_file.ata10,
   ata11     LIKE ata_file.ata11,
   ata12     LIKE ata_file.ata12,
   ata13     LIKE ata_file.ata13,
   ata14     LIKE ata_file.ata14,
   ata15     LIKE ata_file.ata15,
   ata16     LIKE ata_file.ata16,
   ata17     LIKE ata_file.ata17,
   ata18     LIKE ata_file.ata18,
   ata19     LIKE ata_file.ata19,
   ata20     LIKE ata_file.ata20,
   ata21     LIKE ata_file.ata21,
   ata22     LIKE ata_file.ata22,
   ata23     LIKE ata_file.ata23,
   ata24     LIKE ata_file.ata24,
   ata25     LIKE ata_file.ata25,
   ata26     LIKE ata_file.ata26,
   ata27     LIKE ata_file.ata27,
   ata28     LIKE ata_file.ata28
   END RECORD,
   g_att    DYNAMIC ARRAY OF RECORD
   ata07     LIKE ata_file.ata07,
   color     LIKE ata_file.ata06,
   detail    ARRAY[20] OF RECORD
   ata03  LIKE ata_file.ata03,
   ata04  LIKE ata_file.ata04,
   size   LIKE agd_file.agd02,
   qty    LIKE ata_file.ata08
   END RECORD
   END RECORD,
   g_att_t  RECORD
   ata07     LIKE ata_file.ata07,
   color     LIKE ata_file.ata06,
   detail    ARRAY[20] OF RECORD
   ata03  LIKE ata_file.ata03,
   ata04  LIKE ata_file.ata04,
   size   LIKE agd_file.agd02,
   qty    LIKE ata_file.ata08
   END RECORD
   END RECORD,
   
   g_sql            STRING,
   g_wc             STRING,
   g_rec_b1          LIKE type_file.num5,  
   l_ac             LIKE type_file.num5   
   DEFINE field_array   DYNAMIC ARRAY OF LIKE type_file.chr100
   DEFINE g_oeb         RECORD LIKE oeb_file.*
   DEFINE g_curs_index  LIKE type_file.num10
   DEFINE g_row_count   LIKE type_file.num10
   DEFINE g_cnt         LIKE type_file.num10
   DEFINE g_msg         LIKE type_file.chr1000 
   DEFINE mi_no_ask     LIKE type_file.num5 
   DEFINE g_jump        LIKE type_file.num10
   DEFINE g_ataefore_input_done LIKE type_file.num5
   
   DEFINE  p_row,p_col  LIKE type_file.num5
   DEFINE  li_result    LIKE type_file.num5
   DEFINE  g_forupd_sql STRING
   DEFINE g_argv1       LIKE ata_file.ata00 
   DEFINE g_argv2       LIKE ata_file.ata01
   DEFINE g_argv3       LIKE ata_file.ata02
   DEFINE g_argv4       LIKE ata_file.ata05
   DEFINE g_argv5       LIKE type_file.chr1
   DEFINE g_ata04       LIKE ata_file.ata04
   DEFINE g_ata05       LIKE ata_file.ata05
   DEFINE g_conf        LIKE type_file.chr1
   DEFINE l_sum         LIKE type_file.num20_6
   DEFINE l_sum1        LIKE type_file.num20_6
#FUN-A60035 add begin
   DEFINE g_color       DYNAMIC ARRAY OF RECORD    #記錄顏色有幾種
          ata06         LIKE ata_file.ata06
          END RECORD 
#FUN-A60035 add end

FUNCTION s_detail(p_ata00,p_ata01,p_ata02,p_ata05,p_transaction) 
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE p_ata00         LIKE ata_file.ata00
   DEFINE p_ata01         LIKE ata_file.ata01
   DEFINE p_ata02         LIKE ata_file.ata02
   DEFINE p_ata05         LIKE ata_file.ata05
   DEFINE p_transaction   LIKE type_file.chr1
   DEFINE l_sql           LIKE type_file.chr1000
   
   LET g_argv1 = p_ata00
   LET g_argv2 = p_ata01
   LET g_argv3 = p_ata02
   LET g_argv4 = p_ata05
   LET g_argv5 = p_transaction
   LET g_ata05 = p_ata05
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET p_row = 2 LET p_col = 4
   
   OPEN WINDOW s_detail_w AT p_row,p_col WITH FORM "sub/42f/s_detail2"
          ATTRIBUTE( STYLE = g_win_style )   	 
   CALL cl_ui_locale("s_detail2")

   CALL cl_set_comp_required("ata07",FALSE)    #FUN-A60035 add
   CALL cl_set_comp_visible("ata07",FALSE)    #FUN-A60035 add

   CALL g_ata.clear() 
   CALL g_ata1.clear() 
   CALL g_att.clear() 

#  IF g_argv1 = "apmt420" THEN
#     SELECT pmk18,pml04 INTO g_conf,g_ata04 
#       FROM pmk_file,pml_file 
#      WHERE pmk01 = pml01 AND pmk01 = g_argv2 AND pml02 = g_argv3
#  END IF
#  IF g_argv1 = "apmt540" THEN
#     SELECT pmm18,pmn04 INTO g_conf,g_ata04
#       FROM pmm_file,pmn_file
#      WHERE pmm01 = pmn01 AND pmm01 = g_argv2 AND pmn02 = g_argv3
#  END IF
#  IF g_argv1 = "apmt110" THEN
#     SELECT rvaconf,rvb05 INTO g_conf,g_ata04
#       FROM rva_file,rvb_file
#      WHERE rva01 = rvb01 AND rva01 = g_argv2 AND rvb02 = g_argv3
#  END IF
#  IF g_argv1 = "axmt410" THEN
#     SELECT oeaconf,oeb04 INTO g_conf,g_ata04
#       FROM oea_file,oeb_file
#      WHERE oea01 = oeb01 AND oea01 = g_argv2 AND oeb03 = g_argv3
#  END IF
#  IF g_argv1 = "axmt610" THEN
#     SELECT ogaconf,ogb04 INTO g_conf,g_ata04
#       FROM oga_file,ogb_file
#      WHERE oga01 = ogb01 AND oga01 = g_argv2 AND ogb03 = g_argv3
#  END IF
#  IF g_argv1 = "axmt620" THEN
#     SELECT ogaconf,ogb04 INTO g_conf,g_ata04
#       FROM oga_file,ogb_file 
#      WHERE oga01 = ogb01 AND oga01 = g_argv2 AND ogb03 = g_argv3
#  END IF
#  IF g_argv1 = "axmt650" THEN
#     SELECT ogaconf,ogb04 INTO g_conf,g_ata04
#       FROM oga_file,ogb_file
#      WHERE oga01 = ogb01 AND oga01 = g_argv2 AND ogbud10 = g_argv3
#  END IF
#  IF cl_null(g_ata04) THEN RETURN END IF
      CALL cl_set_comp_visible("ata08,ata09,ata10,ata11,ata12,ata13,ata14,ata15,ata16,ata17,ata18,ata19,ata20,ata21,ata22,ata23,ata24,ata25,ata26,ata27",FALSE)
########		 ata15,ata16,ata17,ata18,ata19,ata20,ata21,
########		 ata22,ata23,ata24,ata25,ata26,ata27",FALSE)
      CALL s_detail_refresh()
      CALL s_detail_combobox()
      CALL s_detail_b_fill('F')     #FUN-A60035 add 'F'記錄第一次進入
      CALL s_detail_menu()
#  CALL s_detail_update()
	CLOSE WINDOW s_detail_w                     
        SELECT SUM(ata08) INTO l_sum FROM ata_file WHERE ata00=g_argv1 AND ata01=g_argv2 AND ata02=g_argv3
	RETURN l_sum
	END FUNCTION

FUNCTION s_detail_menu()

   WHILE TRUE
      CALL s_detail_bp1("G")	
      
      CASE g_action_choice
      
      WHEN "detail"
         CALL s_detail_b()
      WHEN "help"
         CALL cl_show_help()
      WHEN "exit"
         LET INT_FLAG = 0
      EXIT WHILE
         WHEN "controlg"
         CALL cl_cmdask()
      END CASE
   END WHILE

END FUNCTION

#FUN-A50054 --Begin
#FUNCTION s_detail_insert(l_argv1,l_argv2,l_argv3)
#   DEFINE l_argv1       LIKE ata_file.ata00
#   DEFINE l_argv2       LIKE ata_file.ata01
#   DEFINE l_argv3       LIKE ata_file.ata02
#   DEFINE l_ata         RECORD LIKE ata_file.*
#   LET g_sql = "SELECT * FROM ata_file WHERE ata00 = '",l_argv1,"' AND ata02 = ", 
#                l_argv3," AND ata01 = '",l_argv2,"'" 
#    PREPARE ata_pb_1 FROM g_sql
#    DECLARE ata_curs_1 CURSOR FOR ata_pb_1
#
#    MESSAGE "Searching!"
#    FOREACH ata_curs_1 INTO l_ata.*
#        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        LET l_ata.ata00 = g_argv1
#        LET l_ata.ata01 = g_argv2
#        LET l_ata.ata02 = g_argv3
#        INSERT INTO ata_file VALUES(l_ata.*)
#    END FOREACH
#END FUNCTION
#FUN-A50054 --End

#FUNCTION s_detail_b_fill()
FUNCTION s_detail_b_fill(p_f)      #FUN-A60035  add
	DEFINE l_count       LIKE type_file.num5
	DEFINE l_argv1       LIKE ata_file.ata00
	DEFINE l_argv2       LIKE ata_file.ata01
	DEFINE l_argv3       LIKE ata_file.ata02
	DEFINE l_i,l_j       LIKE type_file.num5
        DEFINE p_f           LIKE type_file.chr1    #FUN-A60035  add

	LET g_rec_b1 = 0
	SELECT COUNT(*) INTO l_count FROM ata_file WHERE ata00=g_argv1 AND ata02=g_argv3 AND ata01=g_argv2
	IF l_count = 0 AND p_f = 'F' THEN
           CALL s_detail_ins_ata()    #FUN-A60035  add
           CALL s_detail_b()          #FUN-A60035  add
        END IF                        #FUN-A60035  add
#FUN-A50054 --Begin
#      CASE g_argv1
#         WHEN "apmt420"  
#            LET l_argv1 = "axmt410"
#            SELECT pml24,pml25 INTO l_argv2,l_argv3 FROM pml_file
#             WHERE pml01=g_argv2 AND pml02 = g_argv3
#            CALL s_detail_insert(l_argv1,l_argv2,l_argv3)
#         WHEN "apmt540"
#            LET l_argv1 = "apmt420"
#            SELECT pmn24,pmn25 INTO l_argv2,l_argv3 FROM pmn_file WHERE pmn01=g_argv2 AND pmn02=g_argv3
#            CALL s_detail_insert(l_argv1,l_argv2,l_argv3)
#         WHEN "apmt110"
#            LET l_argv1 = "apmt540"
#            SELECT rvb04,rvb03 INTO l_argv2,l_argv3 FROM rvb_file WHERE rvb01=g_argv2 AND rvb02=g_argv3
#            CALL s_detail_insert(l_argv1,l_argv2,l_argv3)
#         WHEN "axmt610"
#            LET l_argv1 = "axmt410"
#            SELECT ogb31,ogb32 INTO l_argv2,l_argv3 FROM ogb_file WHERE ogb01=g_argv2 AND ogb03=g_argv3
#            CALL s_detail_insert(l_argv1,l_argv2,l_argv3)
#         WHEN "axmt620"
#            LET l_argv1 = "axmt410"
#            SELECT ogb31,ogb32 INTO l_argv2,l_argv3 FROM ogb_file WHERE ogb01=g_argv2 AND ogb03=g_argv3
#            CALL s_detail_insert(l_argv1,l_argv2,l_argv3)
#             
#         OTHERWISE
#            LET l_argv1 = g_argv1
#            LET l_argv2 = g_argv2
#            LET l_argv3 = g_argv3
#      END CASE
#   ELSE
#      LET l_argv1 = g_argv1
#      LET l_argv2 = g_argv2
#      LET l_argv3 = g_argv3
#   END IF
#FUN-A50054 --End
#      LET g_sql = "SELECT ata06,ata07,ata08,ata09,ata10,ata11,",
#                  "       ata12,ata13,ata14,ata15,ata16,ata17,",
#                  "       ata18,ata19,ata20,ata21,ata22,ata23,",
#                  "       ata24,ata25,ata26,ata27,ata28",
#                  " FROM ata_file WHERE ata00 = '",l_argv1,"' AND ata02 = ",
#                  l_argv3," AND ata01 = '",l_argv2,"'" 
#        ELSE       #FUN-A60035 mark
        LET g_sql = "SELECT ata03,ata04,ata06,ata07,ata08",
                    " FROM ata_file WHERE ata00 = '",g_argv1,"' AND ata02 = ",
                    g_argv3," AND ata01 = '",g_argv2,"'",
                    " ORDER BY ata06,ata07"
        PREPARE ata_pb FROM g_sql
        DECLARE ata_curs CURSOR FOR ata_pb

        CALL g_ata1.clear()
#       CALL g_att.clear()
        LET g_cnt = 1
        LET l_i = 1
        MESSAGE "Searching!"
        FOREACH ata_curs INTO g_ata1[g_cnt].*
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF   
           IF g_cnt > 1 THEN
#              IF g_ata1[g_cnt].ata06 <> g_ata1[g_cnt-1].ata06 OR g_ata1[g_cnt].ata07 <> g_ata1[g_cnt-1].ata07 THEN
              IF g_ata1[g_cnt].ata06 <> g_ata1[g_cnt-1].ata06 THEN   #FUN-A60035 add 
                 LET l_i = l_i + 1
              END IF
           END IF
           CALL s_detail_parse()
           LET g_att[l_i].ata07 = g_ata1[g_cnt].ata07
           LET g_att[l_i].color = field_array[2]
           FOR l_j = 1 TO 20 
              IF l_i > 1 THEN
                 LET g_att[l_i].detail[l_j].size=g_att[l_i-1].detail[l_j].size
              END IF
              IF g_att[l_i].detail[l_j].size = field_array[3] THEN
                 LET g_att[l_i].detail[l_j].qty = g_ata1[g_cnt].ata08
                 LET g_att[l_i].detail[l_j].ata03 = g_ata1[g_cnt].ata03
              END IF
           END FOR
           LET g_cnt = g_cnt + 1
        END FOREACH
        CALL s_detail_att_to_ata()
#      CALL g_ata.deleteElement(g_cnt)
#      MESSAGE ""
	LET g_rec_b1 = l_i
#      LET g_cnt = 0
#END IF        #FUN-A60035 mark
END FUNCTION

FUNCTION s_detail_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1        
   DEFINE l_i    LIKE type_file.num5
   
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
   RETURN
   END IF
   
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ata TO s_ata.* ATTRIBUTE(COUNT=g_rec_b1)  
   
   BEFORE ROW
   LET g_rec_b1 = ARR_COUNT()
   LET l_ac = ARR_CURR()
   CALL cl_show_fld_cont() 
   IF l_ac > 1 THEN
      FOR l_i = 1 TO 20  
         LET g_att[l_ac].detail[l_i].size=g_att[l_ac-1].detail[l_i].size
         LET g_att[l_ac].detail[l_i].qty=0
      END FOR
   END IF

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION s_detail_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_row,l_col     LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          l_i             LIKE type_file.num5,   
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_count         LIKE type_file.num5
   DEFINE l_sql           LIKE type_file.chr1000
   DEFINE l_ata03         LIKE ata_file.ata03
   DEFINE l_size          LIKE imx_file.imx02
   DEFINE l_color         LIKE imx_file.imx02
   DEFINE l_list          LIKE type_file.chr100
   DEFINE l_result        LIKE type_file.num5
   DEFINE l_ps            LIKE type_file.chr1
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_value         LIKE type_file.chr100

   LET g_action_choice = ""
   IF g_argv5='Y' THEN RETURN END IF
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN
       LET l_ps=' '
   END IF
   LET l_sql = " SELECT agd03 ",
               "   FROM ima_file,agd_file",
               "  WHERE agd02 = ?",
               "    AND agd01 = ima940",
               "    AND ima01 = '",g_argv4,"'"
   DECLARE att_curs CURSOR FROM l_sql
   LET l_sql = " SELECT agd03 ",
               "   FROM ima_file,agd_file",
               "  WHERE agd02 = ?",
               "    AND agd01 = ima941",
               "    AND ima01 = '",g_argv4,"'"
   DECLARE att_curs2 CURSOR FROM l_sql
   
   CALL cl_opmsg('b')
   LET l_sql = "UPDATE ata_file",
               "   SET ata04 = ?,",
               "       ata06 = ?,",
               "       ata07 = ?,",
               "       ata08 = ?",
               " WHERE ata00 = '",g_argv1,"'",
               "   AND ata01 = '",g_argv2,"'",
               "   AND ata02 = '",g_argv3,"'",
               "   AND ata03 = ?"
   PREPARE ata_upd FROM l_sql

   LET g_forupd_sql = " SELECT ata03,ata04,ata06,ata07,ata08",
                  #   "        ata11,ata12,ata13,ata14,ata15,",
                  #   "        ata16,ata17,ata18,ata19,ata20,",
                  #   "        ata21,ata22,ata23,ata24,ata25,",
                  #   "        ata26,ata27,ata28",
                      "   FROM ata_file ",
                      "  WHERE ata00 = ? ",
                      "    AND ata01 = ? ",
                      "    AND ata02 = ? ",
                      "    AND ata03 = ? ",
                      "    FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_bc2 CURSOR  FROM g_forupd_sql     

   LET l_ac_t = 0

   LET l_allow_insert = TRUE   #cl_detail_input_auth("insert")
   LET l_allow_delete = TRUE   #cl_detail_input_auth("delete")

   INPUT ARRAY g_ata WITHOUT DEFAULTS FROM s_ata.*
       ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET l_sum = 0

      AFTER FIELD ata06
            IF p_cmd = 'a' OR (p_cmd = "u" AND g_ata[l_ac].ata06 != g_ata_t.ata06)THEN
               IF cl_null(g_ata[l_ac].ata06) THEN
                  CALL cl_err('','agl-154',0)
                  NEXT FIELD ata06
               END IF
               SELECT COUNT(*) INTO l_cnt FROM ata_file 
                WHERE ata00=g_argv1
                  AND ata01=g_argv2
                  AND ata02=g_argv3
                  AND ata06=g_ata[l_ac].ata06
#                  AND ata07=g_ata[l_ac].ata07       #FUN-A60035
               IF l_cnt > 0 THEN
                  CALL cl_err('','sub-153',1)
                  NEXT FIELD ata06
               END IF
#              LET g_att[l_ac].color = g_ata[l_ac].ata06
            END IF

#FUN-A60035 ---mark begin
#     AFTER FIELD ata07
#           IF cl_null(g_ata[l_ac].ata07) THEN
#              CALL cl_err('','agl-154',0)
#              NEXT FIELD ata07
#           END IF
#           IF g_ata[l_ac].ata07 <= 0 THEN
#              CALL cl_err('','sub-154',1)
#              NEXT FIELD ata07
#           END IF
#           IF p_cmd = 'a' OR (p_cmd = "u" AND g_ata[l_ac].ata07 != g_ata_t.ata07) THEN
#              SELECT COUNT(*) INTO l_cnt FROM ata_file 
#               WHERE ata00=g_argv1
#                 AND ata01=g_argv2
#                 AND ata02=g_argv3
#                 AND ata06=g_ata[l_ac].ata06
#                 AND ata07=g_ata[l_ac].ata07
#              IF l_cnt > 0 THEN
#                 CALL cl_err('','apm-153',1)
#                 NEXT FIELD ata07
#              END IF
#           END IF
##           LET g_att[l_ac].ata07= g_ata[l_ac].ata07
#FUN-A60035 ---mark end

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
        #LET g_rec_b1 = ARR_COUNT()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF l_ac > 1 THEN
            FOR l_i = 1 TO 20  
               LET g_att[l_ac].detail[l_i].size=g_att[l_ac-1].detail[l_i].size
               LET g_att[l_ac].detail[l_i].qty=0
            END FOR
         END IF
         
         IF g_argv5= 'Y' THEN
            BEGIN WORK 
         END IF
         
         LET g_success='Y'
         IF g_rec_b1>=l_ac THEN
            LET p_cmd='u'
            LET g_ata_t.* = g_ata[l_ac].*
            LET g_att_t.* = g_att[l_ac].*
            DECLARE s_detail_ata SCROLL CURSOR FOR
             SELECT ata03 FROM ata_file
              WHERE ata00 = g_argv1
                AND ata01 = g_argv2
                AND ata02 = g_argv3
               #AND ata06 = g_att[l_ac].color
                AND ata06 = g_ata_t.ata06
            FOREACH s_detail_ata INTO l_ata03
               OPEN s_bc2 USING g_argv1,g_argv2,g_argv3,l_ata03
               IF STATUS THEN
                  CALL cl_err("OPEN s_bc2:", STATUS, 1)
                  CLOSE s_bc2
                  RETURN
               ELSE
                  FETCH s_bc2 INTO g_ata1_t.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock ata_file',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 #ELSE
                 #   LET g_att[l_ac].detail[1].ata03 = g_ata1[l_ac].ata03
                 #   LET g_ata[l_ac].ata08 = g_ata1[l_ac].ata08
                  END IF
               END IF
            END FOREACH
         END IF
        #  #OPEN s_bc2 USING g_argv1,g_argv2,g_argv3,g_ata03 
        #  #IF STATUS THEN
        #  #   CALL cl_err("OPEN s_bc2:", STATUS, 1)
        #  #   CLOSE s_bc2
        #  #   RETURN
        #  #ELSE
        #  #   FETCH s_bc2 INTO g_ata03,g_ata[l_ac].*
        #  #   IF g_cnt > 1 THEN
        #  #      IF g_ata1[g_cnt].ata06 <> g_ata1[g_cnt-1].ata06 THEN
        #  #         LET l_i = l_i + 1
        #  #      END IF
        #  #   END IF
        #  #   CALL s_detail_parse()
        #  #   LET g_att[l_i].color = field_array[2]
        #  #   FOR l_j = 1 TO 20 
        #  #      IF g_att[g_cnt].detail[l_j].size = field_array[3] THEN
        #  #         LET g_att[l_i].detail[l_j].qty = g_ata1[g_cnt].ata08
        #  #      END IF
        #  #   END FOR
        #  #   IF SQLCA.sqlcode THEN
        #  #      CALL cl_err('lock tc_cci',SQLCA.sqlcode,1)
        #  #      LET l_lock_sw = "Y"
        #  #   END IF
        #  #END IF
        #   LET g_ataefore_input_done = FALSE
        #   LET g_ataefore_input_done = TRUE            
        #   CALL cl_show_fld_cont()   
        #END IF
         
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_ata[l_ac].* TO NULL 
            DISPLAY g_ata[l_ac].* TO s_ata.*
            CALL g_ata.deleteElement(l_ac)
            EXIT INPUT
         END IF

         IF cl_null(g_ata[l_ac].ata08) THEN
            LET g_ata[l_ac].ata08 =0
         END IF 
         IF cl_null(g_ata[l_ac].ata09) THEN
            LET g_ata[l_ac].ata09 =0
         END IF
         IF cl_null(g_ata[l_ac].ata10) THEN
            LET g_ata[l_ac].ata10 =0
         END IF
         IF cl_null(g_ata[l_ac].ata11) THEN
            LET g_ata[l_ac].ata11 =0
         END IF
         IF cl_null(g_ata[l_ac].ata12) THEN
            LET g_ata[l_ac].ata12 =0
         END IF
         IF cl_null(g_ata[l_ac].ata13) THEN
            LET g_ata[l_ac].ata13 =0
         END IF
         IF cl_null(g_ata[l_ac].ata14) THEN
            LET g_ata[l_ac].ata14 =0
         END IF
         IF cl_null(g_ata[l_ac].ata15) THEN
            LET g_ata[l_ac].ata15 =0
         END IF
         IF cl_null(g_ata[l_ac].ata16) THEN
            LET g_ata[l_ac].ata16 =0
         END IF
         IF cl_null(g_ata[l_ac].ata17) THEN
            LET g_ata[l_ac].ata17 =0
         END IF
         IF cl_null(g_ata[l_ac].ata18) THEN
            LET g_ata[l_ac].ata18 =0
         END IF
         IF cl_null(g_ata[l_ac].ata19) THEN
            LET g_ata[l_ac].ata19 =0
         END IF
         IF cl_null(g_ata[l_ac].ata20) THEN
            LET g_ata[l_ac].ata20 =0
         END IF
         IF cl_null(g_ata[l_ac].ata21) THEN
            LET g_ata[l_ac].ata21 =0
         END IF
         IF cl_null(g_ata[l_ac].ata22) THEN
            LET g_ata[l_ac].ata22 =0
         END IF
         IF cl_null(g_ata[l_ac].ata23) THEN
            LET g_ata[l_ac].ata23 =0
         END IF
         IF cl_null(g_ata[l_ac].ata24) THEN
            LET g_ata[l_ac].ata24 =0
         END IF
         IF cl_null(g_ata[l_ac].ata25) THEN
            LET g_ata[l_ac].ata25 =0
         END IF
         IF cl_null(g_ata[l_ac].ata26) THEN
            LET g_ata[l_ac].ata26 =0
         END IF
         IF cl_null(g_ata[l_ac].ata27) THEN
            LET g_ata[l_ac].ata27 =0
         END IF
         CALL s_detail_ata_to_att()
#         CALL s_detail_ins()      #FUN-A60035 mark
         CALL s_detail_ins('N')    #FUN-A60035 add
#FUN-A50054 --Begin
#        INSERT INTO ata_file(ata00,ata01,ata02,ata03,ata04,ata05,
#                                ata06,ata07,ata08,ata09,ata10,ata11,
#                                ata12,ata13,ata14,ata15,ata16,ata17,ata18,
#                                ata19,ata20,ata21,ata22,ata23,ata24,ata25,
#                                ata26,ata27,ata28)
#                       VALUES(g_argv1,g_argv2,g_argv3,l_ata03,g_ata04,g_ata05,
#                       g_ata[l_ac].ata06,g_ata[l_ac].ata07,g_ata[l_ac].ata08,g_ata[l_ac].ata09,
#                       g_ata[l_ac].ata10,g_ata[l_ac].ata11,g_ata[l_ac].ata12,g_ata[l_ac].ata13,
#                       g_ata[l_ac].ata14,g_ata[l_ac].ata15,g_ata[l_ac].ata16,g_ata[l_ac].ata17,
#                       g_ata[l_ac].ata18,g_ata[l_ac].ata19,g_ata[l_ac].ata20,g_ata[l_ac].ata21,
#                       g_ata[l_ac].ata22,g_ata[l_ac].ata23,g_ata[l_ac].ata24,g_ata[l_ac].ata25,
#                       g_ata[l_ac].ata26,g_ata[l_ac].ata27,g_ata[l_ac].ata28)
#FUN-A50054 --End
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ata_file","ata00","ata01",STATUS,"","",1)
            LET g_success = 'N'
            CANCEL INSERT
         END IF
         IF g_success='Y' THEN
            LET g_rec_b1=g_rec_b1+1
            MESSAGE 'Insert Ok'
            IF g_argv5 = 'Y' THEN
               COMMIT WORK 
            END IF
         ELSE
            CANCEL INSERT
         END IF

      BEFORE INSERT
         LET p_cmd = 'a'
         LET g_ataefore_input_done = FALSE
         LET g_ataefore_input_done = TRUE
         LET l_n = ARR_COUNT()
         INITIALIZE g_ata[l_ac].* TO NULL
         LET g_ata[l_ac].ata07 = '1'     #FUN-A60035 add 
         LET g_ata[l_ac].ata08 = 0
         LET g_ata[l_ac].ata09 = 0
         LET g_ata[l_ac].ata10 = 0
         LET g_ata[l_ac].ata11 = 0
         LET g_ata[l_ac].ata12 = 0
         LET g_ata[l_ac].ata13 = 0
         LET g_ata[l_ac].ata14 = 0
         LET g_ata[l_ac].ata15 = 0
         LET g_ata[l_ac].ata16 = 0
         LET g_ata[l_ac].ata17 = 0
         LET g_ata[l_ac].ata18 = 0
         LET g_ata[l_ac].ata19 = 0
         LET g_ata[l_ac].ata20 = 0
         LET g_ata[l_ac].ata21 = 0
         LET g_ata[l_ac].ata22 = 0
         LET g_ata[l_ac].ata23 = 0
         LET g_ata[l_ac].ata24 = 0
         LET g_ata[l_ac].ata25 = 0
         LET g_ata[l_ac].ata26 = 0
         LET g_ata[l_ac].ata27 = 0
         LET g_ata[l_ac].ata28 = 0
         DISPLAY BY NAME g_ata[l_ac].*
         LET g_ata_t.* = g_ata[l_ac].* 
         CALL cl_show_fld_cont()
         NEXT FIELD ata06

      AFTER FIELD ata08
        IF NOT cl_null(g_ata[l_ac].ata08) THEN 
           IF g_ata[l_ac].ata08 < 0 THEN 
              LET g_ata[l_ac].ata08 = 0 
              DISPLAY BY NAME g_ata[l_ac].ata08
           END IF 
          #LET g_att[l_ac].detail[1].qty = g_ata[l_ac].ata08
        END IF
        CALL s_detail_ata28()
      AFTER FIELD ata09
        IF NOT cl_null(g_ata[l_ac].ata09) THEN
           IF g_ata[l_ac].ata09 < 0 THEN
              LET g_ata[l_ac].ata09 = 0
              DISPLAY BY NAME g_ata[l_ac].ata09
           END IF
        END IF
       #LET g_att[l_ac].detail[2].qty = g_ata[l_ac].ata09
        CALL s_detail_ata28()
      AFTER FIELD ata10
        IF NOT cl_null(g_ata[l_ac].ata10) THEN
           IF g_ata[l_ac].ata10 < 0 THEN
              LET g_ata[l_ac].ata10 = 0
              DISPLAY BY NAME g_ata[l_ac].ata10
           END IF
        END IF
    #   LET g_att[l_ac].detail[3].qty = g_ata[l_ac].ata10
        CALL s_detail_ata28()
      AFTER FIELD ata11
        IF NOT cl_null(g_ata[l_ac].ata11) THEN
           IF g_ata[l_ac].ata11 < 0 THEN
              LET g_ata[l_ac].ata11 = 0
              DISPLAY BY NAME g_ata[l_ac].ata11
           END IF
        END IF
   #    LET g_att[l_ac].detail[4].qty = g_ata[l_ac].ata11
        CALL s_detail_ata28()
      AFTER FIELD ata12
        IF NOT cl_null(g_ata[l_ac].ata12) THEN
           IF g_ata[l_ac].ata12 < 0 THEN
              LET g_ata[l_ac].ata12 = 0
              DISPLAY BY NAME g_ata[l_ac].ata12
           END IF
        END IF
  #     LET g_att[l_ac].detail[5].qty = g_ata[l_ac].ata12
        CALL s_detail_ata28()
      AFTER FIELD ata13
        IF NOT cl_null(g_ata[l_ac].ata13) THEN
           IF g_ata[l_ac].ata13 < 0 THEN
              LET g_ata[l_ac].ata13 = 0
              DISPLAY BY NAME g_ata[l_ac].ata13
           END IF
        END IF      
   #    LET g_att[l_ac].detail[6].qty = g_ata[l_ac].ata13
        CALL s_detail_ata28()
      AFTER FIELD ata14
        IF NOT cl_null(g_ata[l_ac].ata14) THEN
           IF g_ata[l_ac].ata14 < 0 THEN
              LET g_ata[l_ac].ata14 = 0
              DISPLAY BY NAME g_ata[l_ac].ata14
           END IF
        END IF
  #     LET g_att[l_ac].detail[7].qty = g_ata[l_ac].ata14
        CALL s_detail_ata28()
      AFTER FIELD ata15
        IF NOT cl_null(g_ata[l_ac].ata15) THEN
           IF g_ata[l_ac].ata15 < 0 THEN
              LET g_ata[l_ac].ata15 = 0
              DISPLAY BY NAME g_ata[l_ac].ata15
           END IF
        END IF
  #     LET g_att[l_ac].detail[8].qty = g_ata[l_ac].ata15
        CALL s_detail_ata28()
      AFTER FIELD ata16
        IF NOT cl_null(g_ata[l_ac].ata16) THEN
           IF g_ata[l_ac].ata16 < 0 THEN
              LET g_ata[l_ac].ata16 = 0
              DISPLAY BY NAME g_ata[l_ac].ata16
           END IF
        END IF
  #     LET g_att[l_ac].detail[9].qty = g_ata[l_ac].ata16
        CALL s_detail_ata28()
      AFTER FIELD ata17
        IF NOT cl_null(g_ata[l_ac].ata17) THEN
           IF g_ata[l_ac].ata17 < 0 THEN
              LET g_ata[l_ac].ata17 = 0
              DISPLAY BY NAME g_ata[l_ac].ata17
           END IF
        END IF
#       LET g_att[l_ac].detail[10].qty = g_ata[l_ac].ata17
        CALL s_detail_ata28()
      AFTER FIELD ata18
        IF NOT cl_null(g_ata[l_ac].ata18) THEN
           IF g_ata[l_ac].ata18 < 0 THEN
              LET g_ata[l_ac].ata18 = 0
              DISPLAY BY NAME g_ata[l_ac].ata18
           END IF
        END IF
   #    LET g_att[l_ac].detail[11].qty = g_ata[l_ac].ata18
        CALL s_detail_ata28()
      AFTER FIELD ata19
        IF NOT cl_null(g_ata[l_ac].ata19) THEN
           IF g_ata[l_ac].ata19 < 0 THEN
              LET g_ata[l_ac].ata19 = 0
              DISPLAY BY NAME g_ata[l_ac].ata19
           END IF
        END IF
   #    LET g_att[l_ac].detail[12].qty = g_ata[l_ac].ata19
        CALL s_detail_ata28()
      AFTER FIELD ata20
        IF NOT cl_null(g_ata[l_ac].ata20) THEN
           IF g_ata[l_ac].ata20 < 0 THEN
              LET g_ata[l_ac].ata20 = 0
              DISPLAY BY NAME g_ata[l_ac].ata20
           END IF
        END IF
 #      LET g_att[l_ac].detail[13].qty = g_ata[l_ac].ata20
        CALL s_detail_ata28()
      AFTER FIELD ata21
        IF NOT cl_null(g_ata[l_ac].ata21) THEN
           IF g_ata[l_ac].ata21 < 0 THEN
              LET g_ata[l_ac].ata21 = 0
              DISPLAY BY NAME g_ata[l_ac].ata21
           END IF
        END IF
 #      LET g_att[l_ac].detail[14].qty = g_ata[l_ac].ata21
        CALL s_detail_ata28()
      AFTER FIELD ata22
        IF NOT cl_null(g_ata[l_ac].ata22) THEN
           IF g_ata[l_ac].ata22 < 0 THEN
              LET g_ata[l_ac].ata22 = 0
              DISPLAY BY NAME g_ata[l_ac].ata22
           END IF
        END IF
   #    LET g_att[l_ac].detail[15].qty = g_ata[l_ac].ata22
        CALL s_detail_ata28()
      AFTER FIELD ata23
        IF NOT cl_null(g_ata[l_ac].ata23) THEN
           IF g_ata[l_ac].ata23 < 0 THEN
              LET g_ata[l_ac].ata23 = 0
              DISPLAY BY NAME g_ata[l_ac].ata23
           END IF
        END IF
   #    LET g_att[l_ac].detail[16].qty = g_ata[l_ac].ata23
        CALL s_detail_ata28()
      AFTER FIELD ata24
        IF NOT cl_null(g_ata[l_ac].ata24) THEN
           IF g_ata[l_ac].ata24 < 0 THEN
              LET g_ata[l_ac].ata24 = 0
              DISPLAY BY NAME g_ata[l_ac].ata24
           END IF
        END IF
   #    LET g_att[l_ac].detail[17].qty = g_ata[l_ac].ata24
        CALL s_detail_ata28()
      AFTER FIELD ata25
        IF NOT cl_null(g_ata[l_ac].ata25) THEN
           IF g_ata[l_ac].ata25 < 0 THEN
              LET g_ata[l_ac].ata25 = 0
              DISPLAY BY NAME g_ata[l_ac].ata25
           END IF
        END IF
  #     LET g_att[l_ac].detail[18].qty = g_ata[l_ac].ata25
        CALL s_detail_ata28()
      AFTER FIELD ata26
        IF NOT cl_null(g_ata[l_ac].ata26) THEN
           IF g_ata[l_ac].ata26 < 0 THEN
              LET g_ata[l_ac].ata26 = 0
              DISPLAY BY NAME g_ata[l_ac].ata26
           END IF
        END IF
   #    LET g_att[l_ac].detail[19].qty = g_ata[l_ac].ata26
        CALL s_detail_ata28()
      AFTER FIELD ata27
        IF NOT cl_null(g_ata[l_ac].ata27) THEN
           IF g_ata[l_ac].ata27 < 0 THEN
              LET g_ata[l_ac].ata27 = 0
              DISPLAY BY NAME g_ata[l_ac].ata27
           END IF
        END IF
   #    LET g_att[l_ac].detail[20].qty = g_ata[l_ac].ata27
        CALL s_detail_ata28()
              
      BEFORE DELETE           
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        IF l_lock_sw = "Y" THEN
           CANCEL DELETE
        END IF
       #s_detail_ata_to_att()
                    
        DELETE FROM ata_file
         WHERE ata00 = g_argv1
           AND ata01 = g_argv2
           AND ata02 = g_argv3
           AND ata06 = g_ata[l_ac].ata06
#           AND ata07 = g_ata[l_ac].ata07        #FUN-A60035 mark
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err(' ',SQLCA.sqlcode,1)
            CANCEL DELETE
        END IF

        IF g_success='Y'   THEN
           LET g_rec_b1=g_rec_b1-1
           MESSAGE 'Delete Ok'
           IF g_argv5 = 'Y' THEN
              COMMIT WORK 
           END IF
           CALL s_detail_b_fill('N')     #FUN-A60035 add 'N'
        END IF
      # CONTINUE INPUT

      ON ROW CHANGE
         IF INT_FLAG THEN            
            LET INT_FLAG = 0
            LET g_ata[l_ac].* = g_ata_t.*
            CLOSE s_bc2
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(' ',-263,1)
            LET g_ata[l_ac].* = g_ata_t.*
         ELSE

#FUN-A50054 --Begin
            CALL s_detail_ata28()
#           IF cl_null(g_ata[l_ac].ata06) THEN
#              LET g_ata[l_ac].ata06 = "1"
#           END IF            
#            IF cl_null(g_ata[l_ac].ata07) THEN
#               LET g_ata[l_ac].ata07 = 0
#            END IF     
#           IF cl_null(g_ata[l_ac].ata08) THEN
#              LET g_ata[l_ac].ata08 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata09) THEN
#              LET g_ata[l_ac].ata09 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata10) THEN
#              LET g_ata[l_ac].ata10 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata11) THEN
#              LET g_ata[l_ac].ata11 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata12) THEN
#              LET g_ata[l_ac].ata12 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata13) THEN
#              LET g_ata[l_ac].ata13 = 0
#           END IF 
#           IF cl_null(g_ata[l_ac].ata14) THEN
#              LET g_ata[l_ac].ata14 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata15) THEN
#              LET g_ata[l_ac].ata15 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata16) THEN
#              LET g_ata[l_ac].ata16 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata17) THEN
#              LET g_ata[l_ac].ata17 = 0
#           END IF
#           IF cl_null(g_ata[l_ac].ata18) THEN
#              LET g_ata[l_ac].ata18 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata19) THEN
#              LET g_ata[l_ac].ata19 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata20) THEN
#              LET g_ata[l_ac].ata20 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata21) THEN
#              LET g_ata[l_ac].ata21 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata22) THEN
#              LET g_ata[l_ac].ata22 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata23) THEN
#              LET g_ata[l_ac].ata23 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata24) THEN
#              LET g_ata[l_ac].ata24 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata25) THEN
#              LET g_ata[l_ac].ata25 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata26) THEN
#              LET g_ata[l_ac].ata26 =0
#           END IF
#           IF cl_null(g_ata[l_ac].ata27) THEN
#              LET g_ata[l_ac].ata27 =0
#           END IF
#                                                                    
#           LET g_ata[l_ac].ata28 = g_ata[l_ac].ata08 +g_ata[l_ac].ata09+
#                                 g_ata[l_ac].ata10 + g_ata[l_ac].ata11+
#                                 g_ata[l_ac].ata12 + g_ata[l_ac].ata13+
#                                 g_ata[l_ac].ata14 + g_ata[l_ac].ata15+
#                                 g_ata[l_ac].ata16 + g_ata[l_ac].ata17+
#                                 g_ata[l_ac].ata18 + g_ata[l_ac].ata19+
#                                 g_ata[l_ac].ata20 + g_ata[l_ac].ata21+
#                                 g_ata[l_ac].ata22 + g_ata[l_ac].ata23+
#                                 g_ata[l_ac].ata24 + g_ata[l_ac].ata25+
#                                 g_ata[l_ac].ata26 + g_ata[l_ac].ata27
#FUN-A50054 --End
#           UPDATE ata_file
#              SET ata06 = g_ata[l_ac].ata06,
#                  ata07 = g_ata[l_ac].ata07,
#                  ata08 = g_ata[l_ac].ata08
#            WHERE ata00 = g_argv1
#              AND ata01 = g_argv2
#              AND ata02 = g_argv3
#              AND ata03 = l_ata03
            CALL s_detail_ata_to_att()
            FOR l_i = 1 TO 20
               IF NOT cl_null(g_att[l_ac].detail[l_i].size) THEN
                  LET g_att[l_ac].detail[l_i].ata04 = g_argv4,l_ps,g_att[l_ac].color,
                                                      l_ps,g_att[l_ac].detail[l_i].size
                  EXECUTE ata_upd USING g_att[l_ac].detail[l_i].ata04,
                                        g_ata[l_ac].ata06,
                                        g_att[l_ac].ata07,
                                        g_att[l_ac].detail[l_i].qty,
                                        g_att[l_ac].detail[l_i].ata03
                  IF SQLCA.sqlcode<>0 THEN
                     CALL cl_err('upd ata_file',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  ELSE
                     IF SQLCA.sqlerrd[3] = 0 THEN
                        IF g_att[l_ac].detail[l_i].qty <> 0 THEN
                           SELECT MAX(ata03)+1 INTO g_att[l_ac].detail[l_i].ata03 FROM ata_file 
                            WHERE ata00 = g_argv1
                              AND ata01 = g_argv2
                              AND ata02 = g_argv3
                           INSERT INTO ata_file(ata00,ata01,ata02,ata03,ata04,ata05,
                                                ata06,ata07,ata08,ata09,ata10,ata11,
                                                ata12,ata13,ata14,ata15,ata16,ata17,ata18,
                                                ata19,ata20,ata21,ata22,ata23,ata24,ata25,
                                                ata26,ata27,ata28)
                                          VALUES(g_argv1,g_argv2,g_argv3, g_att[l_ac].detail[l_i].ata03,
                                                 g_att[l_ac].detail[l_i].ata04,g_argv4,
                                                 g_ata[l_ac].ata06,g_ata[l_ac].ata07,g_att[l_ac].detail[l_i].qty,0,
                                                 0,0,0,0,0, 0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
                           IF SQLCA.sqlcode <> 0 THEN
                              CALL cl_err('ins ata_file',SQLCA.sqlcode,1)
                              LET g_success = 'N'
                           ELSE
                              LET g_ata04 = g_att[l_ac].detail[l_i].ata04    #FUN-A60035 add
                              OPEN att_curs USING g_ata[l_ac].ata06
                              FETCH att_curs INTO l_color
                              CLOSE att_curs
                              OPEN att_curs2 USING g_att[l_ac].detail[l_i].size
                              FETCH att_curs2 INTO l_size
                              CLOSE att_curs2
                              SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_ata05
                              LET l_list = g_ata[l_ac].ata06,'|',l_color,'|',g_att[l_ac].detail[l_i].size,'|',l_size
                              LET l_value= l_ima02,l_ps,l_color,l_ps,l_size
                              CALL cl_copy_ima(g_argv4,g_ata04,l_value,l_list) RETURNING l_result
                              IF l_result = 0 THEN
                                 SELECT COUNT(*) INTO l_count
                                   FROM ima_file
                                  WHERE ima01 = g_ata04
                                 IF l_count = 0 THEN
                                    CALL cl_err('','sub-152',0)
                                    LET g_success = 'N'
                                 END IF
                              ELSE
                                 INSERT INTO imx_file(imx000,imx00,imx01,imx02)
                                 VALUES(g_ata04,g_argv4,g_att[l_ac].color,g_att[l_ac].detail[l_i].size)
                                 IF SQLCA.sqlcode THEN
                                    CALL cl_err3("ins","imx_file","ata00","ata01",STATUS,"","",1)
                                    LET g_success = 'N'
                                 END IF
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END FOR

            IF g_success='Y' THEN
               MESSAGE 'UPDATE O.K'
               IF g_argv5 = 'Y' THEN
                  COMMIT WORK                
               END IF
               DELETE FROM ata_file WHERE ata08=0
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN          
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ata[l_ac].* = g_ata_t.*
            END IF
          LET l_sum1 = 0
          FOR l_ac = 1 TO g_ata.getLength()
            LET l_sum1 = l_sum1 + g_ata[l_ac].ata27
            LET l_sum = l_sum1 
          END FOR              
            CLOSE s_bc2
            EXIT INPUT
      #  ELSE
      #     LET g_ata[l_ac].ata28 = g_ata[l_ac].ata08 +g_ata[l_ac].ata09+
      #                           g_ata[l_ac].ata10 + g_ata[l_ac].ata11+
      #                           g_ata[l_ac].ata12 + g_ata[l_ac].ata13+
      #                           g_ata[l_ac].ata14 + g_ata[l_ac].ata15+
      #                           g_ata[l_ac].ata16 + g_ata[l_ac].ata17
      #    DISPLAY BY NAME g_ata[l_ac].ata28     

         END IF     
         CLOSE s_bc2
         IF g_argv5 = 'Y' THEN
            COMMIT WORK 
         END IF
        #CALL g_ata.deleteElement(g_rec_b1+1)

      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF

         IF cl_null(g_ata[l_ac].ata06) THEN 
             NEXT FIELD ata06
         END IF
#FUN-A60035 ---mark begin
#         IF cl_null(g_ata[l_ac].ata07) THEN
#             NEXT FIELD ata07
#         END IF
#FUN-A60035 ---mark end
         IF cl_null(g_ata[l_ac].ata08) THEN
             NEXT FIELD ata08
         END IF
         IF cl_null(g_ata[l_ac].ata09) THEN
             NEXT FIELD ata09
         END IF
         IF cl_null(g_ata[l_ac].ata10) THEN
             NEXT FIELD ata10
         END IF
         IF cl_null(g_ata[l_ac].ata11) THEN
             NEXT FIELD ata11
         END IF
         IF cl_null(g_ata[l_ac].ata12) THEN
             NEXT FIELD ata12
         END IF
         IF cl_null(g_ata[l_ac].ata13) THEN
             NEXT FIELD ata13
         END IF
         IF cl_null(g_ata[l_ac].ata14) THEN
             NEXT FIELD ata14
         END IF
         IF cl_null(g_ata[l_ac].ata15) THEN
             NEXT FIELD ata15
         END IF
         IF cl_null(g_ata[l_ac].ata16) THEN
             NEXT FIELD ata16
         END IF
         IF cl_null(g_ata[l_ac].ata17) THEN
             NEXT FIELD ata17
         END IF
         IF cl_null(g_ata[l_ac].ata18) THEN
             NEXT FIELD ata18
         END IF 
         IF cl_null(g_ata[l_ac].ata19) THEN
            NEXT FIELD ata19
         END IF
         IF cl_null(g_ata[l_ac].ata20) THEN
            NEXT FIELD ata20
         END IF
         IF cl_null(g_ata[l_ac].ata21) THEN
            NEXT FIELD ata21
         END IF
         IF cl_null(g_ata[l_ac].ata22) THEN
            NEXT FIELD ata22
         END IF
         IF cl_null(g_ata[l_ac].ata23) THEN
            NEXT FIELD ata23
         END IF
         IF cl_null(g_ata[l_ac].ata24) THEN
            NEXT FIELD ata24
         END IF
         IF cl_null(g_ata[l_ac].ata25) THEN
            NEXT FIELD ata25
         END IF
         IF cl_null(g_ata[l_ac].ata26) THEN
            NEXT FIELD ata26
         END IF
         IF cl_null(g_ata[l_ac].ata27) THEN
            NEXT FIELD ata27
         END IF
  
         LET l_sum = 0
         FOR l_ac = 1 TO g_ata.getLength()
            LET l_sum = l_sum + g_ata[l_ac].ata28
         END FOR        
          
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      #  CONTINUE INPUT

      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO") 

   END INPUT
 
   CLOSE s_bc2
   CALL s_detail_del_ata()   #FUN-A60035 add
   CALL g_ata.clear()        #FUN-A60035 add
   CALL s_detail_b_fill('N')    #FUN-A60035 add
   
   IF g_argv5 = 'Y' THEN
      COMMIT WORK        
   END IF

END FUNCTION

#FUNCTION s_detail_update()
#
#   SELECT SUM(ata28) INTO l_sum FROM ata_file 
#    WHERE ata00=g_argv1 AND ata01=g_argv2 AND ata02=g_argv3
#   IF cl_null(l_sum) THEN
#      LET l_sum  = 0 
#   END IF
#   BEGIN WORK
#
#   IF g_argv1 = 'apmt420' THEN
#      UPDATE pml_file SET pml20 = l_sum
#       WHERE pml01 = g_argv2 AND pml02 = g_argv3
#   END IF
#   IF g_argv1 = 'apmt540' THEN       #or apmt590
#      UPDATE pmn_file SET pmn20 = l_sum
#       WHERE pmn01 = g_argv2 AND pmn02 = g_argv3
#   END IF
#   IF g_argv1 = 'apmt110' THEN
#      UPDATE rvb_file SET rvb07 = l_sum
#       WHERE rvb01 = g_argv2 AND rvb02 = g_argv3
#   END IF
#   IF g_argv1 = 'axmt410' THEN
#      UPDATE oeb_file SET oeb12 = l_sum,oebud09 = l_sum
#       WHERE oeb01 = g_argv2 AND oeb03 = g_argv3
#   END IF
#   IF g_argv1 = 'axmt610' OR g_argv1 = 'axmt620' OR g_argv1 = 'axmt650' THEN
#      UPDATE ogb_file SET ogb12 = l_sum,ogbud09 = l_sum
#       WHERE ogb01 = g_argv2 AND ogb03 = g_argv3
#   END IF
#  COMMIT WORK
#END FUNCTION

FUNCTION s_detail_ata28()
   IF cl_null(g_ata[l_ac].ata08) THEN
      LET g_ata[l_ac].ata08 = 0
      DISPLAY BY NAME g_ata[l_ac].ata08
   END IF
   IF cl_null(g_ata[l_ac].ata09) THEN
      LET g_ata[l_ac].ata09 = 0
      DISPLAY BY NAME g_ata[l_ac].ata09
   END IF
   IF cl_null(g_ata[l_ac].ata10) THEN
      LET g_ata[l_ac].ata10 = 0
      DISPLAY BY NAME g_ata[l_ac].ata10
   END IF
   IF cl_null(g_ata[l_ac].ata11) THEN
      LET g_ata[l_ac].ata11 = 0
      DISPLAY BY NAME g_ata[l_ac].ata11
   END IF
   IF cl_null(g_ata[l_ac].ata12) THEN
      LET g_ata[l_ac].ata12 = 0
      DISPLAY BY NAME g_ata[l_ac].ata12
   END IF
   IF cl_null(g_ata[l_ac].ata13) THEN
      LET g_ata[l_ac].ata13 = 0
      DISPLAY BY NAME g_ata[l_ac].ata13
   END IF
   IF cl_null(g_ata[l_ac].ata14) THEN
      LET g_ata[l_ac].ata14 = 0
      DISPLAY BY NAME g_ata[l_ac].ata14
   END IF
   IF cl_null(g_ata[l_ac].ata15) THEN
      LET g_ata[l_ac].ata15 = 0
      DISPLAY BY NAME g_ata[l_ac].ata15
   END IF
   IF cl_null(g_ata[l_ac].ata16) THEN
      LET g_ata[l_ac].ata16 = 0
      DISPLAY BY NAME g_ata[l_ac].ata16
   END IF
   IF cl_null(g_ata[l_ac].ata17) THEN
      LET g_ata[l_ac].ata17 = 0
      DISPLAY BY NAME g_ata[l_ac].ata17
   END IF
   IF cl_null(g_ata[l_ac].ata18) THEN
      LET g_ata[l_ac].ata17 = 0
      DISPLAY BY NAME g_ata[l_ac].ata18
   END IF
   IF cl_null(g_ata[l_ac].ata19) THEN
      LET g_ata[l_ac].ata19 = 0
      DISPLAY BY NAME g_ata[l_ac].ata19
   END IF
   IF cl_null(g_ata[l_ac].ata20) THEN
      LET g_ata[l_ac].ata20 = 0
      DISPLAY BY NAME g_ata[l_ac].ata20
   END IF
   IF cl_null(g_ata[l_ac].ata21) THEN
      LET g_ata[l_ac].ata21 = 0
      DISPLAY BY NAME g_ata[l_ac].ata21
   END IF
   IF cl_null(g_ata[l_ac].ata22) THEN
      LET g_ata[l_ac].ata22 = 0
      DISPLAY BY NAME g_ata[l_ac].ata22
   END IF
   IF cl_null(g_ata[l_ac].ata23) THEN
      LET g_ata[l_ac].ata23 = 0
      DISPLAY BY NAME g_ata[l_ac].ata23
   END IF
   IF cl_null(g_ata[l_ac].ata24) THEN
      LET g_ata[l_ac].ata24 = 0
      DISPLAY BY NAME g_ata[l_ac].ata24
   END IF
   IF cl_null(g_ata[l_ac].ata25) THEN
      LET g_ata[l_ac].ata25 = 0
      DISPLAY BY NAME g_ata[l_ac].ata25
   END IF
   IF cl_null(g_ata[l_ac].ata26) THEN
      LET g_ata[l_ac].ata26 = 0
      DISPLAY BY NAME g_ata[l_ac].ata26
   END IF
   IF cl_null(g_ata[l_ac].ata27) THEN
      LET g_ata[l_ac].ata27 = 0
      DISPLAY BY NAME g_ata[l_ac].ata27
   END IF
   LET g_ata[l_ac].ata28 = g_ata[l_ac].ata08 +g_ata[l_ac].ata09+
                            g_ata[l_ac].ata10 + g_ata[l_ac].ata11+
                            g_ata[l_ac].ata12 + g_ata[l_ac].ata13+
                            g_ata[l_ac].ata14 + g_ata[l_ac].ata15+
                            g_ata[l_ac].ata16 + g_ata[l_ac].ata17
   DISPLAY BY NAME g_ata[l_ac].ata28   
END FUNCTION

FUNCTION s_detail_combobox()
   DEFINE   ls_sql       STRING
   DEFINE   lc_agd02     LIKE agd_file.agd02
   DEFINE   lc_agd03     LIKE agd_file.agd03
   DEFINE   ls_value     STRING
   DEFINE   ls_desc      STRING
   DEFINE   l_color_index   LIKE type_file.num5   #FUN-A60035 add

   LET ls_sql = "SELECT agd02,agd03 FROM agd_file,ima_file ",
                " WHERE agd01 = ima940 ",
                "   AND ima01 = '",g_ata05,"'",
                " ORDER BY agd01 "
   PREPARE agd_pre FROM ls_sql
   DECLARE agd_curs CURSOR FOR agd_pre

   LET l_color_index = 1     #FUN-A60035 add
   FOREACH agd_curs INTO lc_agd02,lc_agd03
      LET ls_value = ls_value,lc_agd02 CLIPPED,","
      LET ls_desc = ls_desc,lc_agd02 CLIPPED," : ",lc_agd03 CLIPPED,","
      LET g_color[l_color_index].ata06 = lc_agd02    #FUN-A60035 add
      LET l_color_index = l_color_index + 1          #FUN-A60035 add
   END FOREACH
   CALL cl_set_combo_items("ata06",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
FUNCTION s_detail_refresh()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    
  DEFINE li_i, li_j,l_i     LIKE type_file.num5   
  DEFINE l_n                LIKE type_file.num5   
  DEFINE lc_agd03           LIKE agd_file.agd03
  DEFINE lr_agc             RECORD LIKE agc_file.*
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
  DEFINE l_bz               LIKE type_file.chr1
  LET lc_index = 7
  LET l_i = 1
# LET l_bz = '0'
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值

  IF NOT cl_null(g_ata05) THEN
     SELECT COUNT(*) INTO li_col_count 
       FROM ima_file,agc_file,agd_file 
      WHERE ima01 = g_ata05
        AND ima941= agc01
        AND agc01 = agd01
 
     #走到這個分支說明是采用新機制，那么使用ata00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
 
     #顯現該有的欄位,置換欄位格式
     INITIALIZE lr_agc.* TO NULL
 
         SELECT agc_file.* INTO lr_agc.* FROM ima_file,agc_file
           WHERE agc01 = ima941
             AND ima01 = g_ata05
 
         CASE lr_agc.agc04
           WHEN '1'
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
             CALL cl_chg_comp_att("ata" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_sql = "SELECT * FROM agd_file ",
                          " WHERE agd01 = '",lr_agc.agc01,"'",
                          " ORDER BY agd01 "
             DECLARE agd_curs1 CURSOR FROM ls_sql
             FOREACH agd_curs1 INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET lc_index = lc_index + 1 USING '&&'
                IF cl_null(ls_show) THEN
                   LET ls_show = "ata" || lc_index
                ELSE
                   LET ls_show = ls_show || ",ata" || lc_index
                END IF
                CALL cl_set_comp_att_text("ata" || lc_index,lr_agd.agd03)
                LET g_att[1].detail[l_i].size = lr_agd.agd02
                LET g_att[1].detail[l_i].qty  = 0
                LET l_i = l_i + 1
             END FOREACH
          WHEN '3'
             LET ls_show = ls_show || ",ata" || lc_index
             CALL cl_set_comp_att_text("ata" || lc_index,lr_agc.agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("ata" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
  END IF
  
  CALL cl_set_comp_visible(ls_show, TRUE)
 
# RETURN ls_show
END FUNCTION
#FUNCTION s_detail_ins_oeb()
#   CALL s_detail_default()
#END FUNCTION
#FUNCTION s_detail_default()
#   INITIALIZE g_oeb.* TO NULL
#   LET g_oeb.oeb01=g_argv1
#   LET g_oeb.oeb12=0
#   IF g_azw.azw04='2' THEN
#      LET g_oeb.oeb47=0
#      LET g_oeb.oeb48=2
#   ELSE
#      LET g_oeb.oeb44='1'
#   END IF
#   LET g_oeb.oeb13=0
#   LET g_oeb.oeb14=0
#   LET g_oeb.oeb14t=0
#   LET g_oeb.oeb24=0
#   LET g_oeb.oeb28=0
#   LET g_oeb.oeb19='N'
#   LET g_oeb.oeb906 = 'N'
#   LET g_oeb.oeb1003 = '1'
#   LET g_oeb.oeb1012 = 'N'
#   LET g_oeb.oeb1006 = 100
#   LET g_oeb.oeb05_fac=1
#   LET g_oeb.oeb23=0
#   LET g_oeb.oeb24=0
#   LET g_oeb.oeb25=0
#   LET g_oeb.oeb29=0
#   LET g_oeb.oeb26=0
#   LET g_oeb.oeb901=0
#   LET g_oeb.oeb920=0
#   LET g_oeb.oeb70='N'
#END FUNCTION


#FUNCTION s_detail_ins()    #FUN-A60035 mark
FUNCTION s_detail_ins(p_once)    #FUN-A60035 add p_index 記錄第一次錄入
DEFINE l_i,l_j             LIKE type_file.num5
DEFINE l_ps                LIKE type_file.chr1
DEFINE l_color,l_size      LIKE agd_file.agd03
DEFINE l_list              LIKE type_file.chr100
DEFINE l_result,l_count    LIKE type_file.num5
DEFINE l_ima02             LIKE ima_file.ima02
DEFINE l_value             LIKE type_file.chr100
DEFINE l_sql               LIKE type_file.chr1000
DEFINE p_once              LIKE type_file.chr1     #FUN-A60035

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps=' ' END IF
#  FOR l_i = 1 TO g_ata.getLength()
      FOR l_j = 1 TO 20
#         IF g_att[l_ac].detail[l_j].qty <> 0 THEN      #FUN-A60035 mark
         IF g_att[l_ac].detail[l_j].qty <> 0 OR p_once = 'F' THEN   #FUN-A60035  #第一次錄入時新增的都是0 
            LET g_ata04 = g_argv4,l_ps,g_att[l_ac].color,l_ps,g_att[l_ac].detail[l_j].size
            SELECT MAX(ata03)+1 INTO g_att[l_ac].detail[l_j].ata03 FROM ata_file 
               WHERE ata00=g_argv1 AND ata01=g_argv2
            IF cl_null( g_att[l_ac].detail[l_j].ata03) THEN
               LET  g_att[l_ac].detail[l_j].ata03 = 1
            END IF
            INSERT INTO ata_file(ata00,ata01,ata02,ata03,ata04,ata05,
                                    ata06,ata07,ata08,ata09,ata10,ata11,
                                    ata12,ata13,ata14,ata15,ata16,ata17,ata18,
                                    ata19,ata20,ata21,ata22,ata23,ata24,ata25,
                                    ata26,ata27,ata28)
                           VALUES(g_argv1,g_argv2,g_argv3, g_att[l_ac].detail[l_j].ata03,g_ata04,g_argv4,
                           g_ata[l_ac].ata06,g_ata[l_ac].ata07,g_att[l_ac].detail[l_j].qty,0,
                           0,0,0,0,0, 0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
            IF SQLCA.sqlcode <> 0 THEN
              #UPDATE ata_file SET ata07 = g_ata[l_ac].ata07,
              #                    ata08 = g_att[l_ac].detail[l_j].qty
              #              WHERE ata00 = g_argv1
              #                AND ata01 = g_argv2
              #                AND ata02 = g_argv3
              #                AND ata03 = l_ata03
              #IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ata_file","ata00","ata01",STATUS,"","",1)
                  LET g_success = 'N'
              #END IF
            ELSE
               OPEN att_curs USING g_ata[l_ac].ata06
               FETCH att_curs INTO l_color
               CLOSE att_curs
               OPEN att_curs2 USING g_att[l_ac].detail[l_j].size
               FETCH att_curs2 INTO l_size
               CLOSE att_curs2
               LET l_list = g_ata[l_ac].ata06,'|',l_color,'|',g_att[l_ac].detail[l_j].size,'|',l_size
               SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_ata05
               LET l_value= l_ima02,l_ps,l_color,l_ps,l_size
               CALL cl_copy_ima(g_argv4,g_ata04,l_value,l_list) RETURNING l_result
               IF l_result = 0 THEN
                  SELECT COUNT(*) INTO l_count
                    FROM ima_file
                   WHERE ima01 = g_ata04
                  IF l_count = 0 THEN
                     CALL cl_err('','sub-152',0)
                     LET g_success = 'N'
                  END IF
               ELSE
                  INSERT INTO imx_file(imx000,imx00,imx01,imx02)
                  VALUES(g_ata04,g_argv4,g_att[l_ac].color,g_att[l_ac].detail[l_j].size)
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("ins","imx_file","ata00","ata01",STATUS,"","",1)
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END IF
      END FOR
#  END FOR
END FUNCTION
FUNCTION s_detail_parse()
DEFINE l_str  STRING
DEFINE l_str1 STRING
DEFINE l_ps   LIKE type_file.chr1
DEFINE l_tok  base.stringTokenizer
DEFINE l_i    LIKE type_file.num5
   LET l_str1 = g_argv4
   LET l_str  = g_ata1[g_cnt].ata04
   LET l_str  = l_str.subString(l_str1.getLength()+1,l_str.getLength())
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN
       LET l_ps=' '
   END IF
   LET l_tok = base.StringTokenizer.createExt(l_str,l_ps,'',TRUE)
   IF l_tok.countTokens() > 0 THEN
      LET l_i=0
      WHILE l_tok.hasMoreTokens()
            LET l_i=l_i+1
            LET field_array[l_i] = l_tok.nextToken()
      END WHILE
   END IF
END FUNCTION
FUNCTION s_detail_ata_to_att()
DEFINE l_i          LIKE type_file.num5
   FOR l_i = 1 TO g_ata.getLength()
      LET g_att[l_i].ata07 = g_ata[l_i].ata07
      LET g_att[l_i].color = g_ata[l_i].ata06
      LET g_att[l_i].detail[1].qty  = g_ata[l_i].ata08
      LET g_att[l_i].detail[2].qty  = g_ata[l_i].ata09
      LET g_att[l_i].detail[3].qty  = g_ata[l_i].ata10
      LET g_att[l_i].detail[4].qty  = g_ata[l_i].ata11
      LET g_att[l_i].detail[5].qty  = g_ata[l_i].ata12
      LET g_att[l_i].detail[6].qty  = g_ata[l_i].ata13
      LET g_att[l_i].detail[7].qty  = g_ata[l_i].ata14
      LET g_att[l_i].detail[8].qty  = g_ata[l_i].ata15
      LET g_att[l_i].detail[9].qty  = g_ata[l_i].ata16
      LET g_att[l_i].detail[10].qty  = g_ata[l_i].ata17
      LET g_att[l_i].detail[11].qty  = g_ata[l_i].ata18
      LET g_att[l_i].detail[12].qty  = g_ata[l_i].ata19
      LET g_att[l_i].detail[13].qty  = g_ata[l_i].ata20
      LET g_att[l_i].detail[14].qty  = g_ata[l_i].ata21
      LET g_att[l_i].detail[15].qty  = g_ata[l_i].ata22
      LET g_att[l_i].detail[16].qty  = g_ata[l_i].ata23
      LET g_att[l_i].detail[17].qty  = g_ata[l_i].ata24
      LET g_att[l_i].detail[18].qty  = g_ata[l_i].ata25
      LET g_att[l_i].detail[19].qty  = g_ata[l_i].ata26
      LET g_att[l_i].detail[20].qty  = g_ata[l_i].ata27
   END FOR
END FUNCTION
FUNCTION s_detail_att_to_ata()
DEFINE l_i,l_j    LIKE type_file.num5
DEFINE l_count    LIKE type_file.num5
   CALL g_ata1.clear()
   SELECT COUNT(*) INTO l_count FROM ata_file WHERE ata00=g_argv1 AND ata02=g_argv3 AND ata01=g_argv2
   IF l_count > 0 THEN
      FOR l_i = 1 TO g_att.getLength()
         LET g_ata[l_i].ata06 = g_att[l_i].color
         LET g_ata[l_i].ata07 = g_att[l_i].ata07
         FOR l_j = 1 TO 20
            LET g_ata03[l_i,l_j]= g_att[l_i].detail[1].ata03
         END FOR
         LET g_ata[l_i].ata08 = g_att[l_i].detail[1].qty
         LET g_ata[l_i].ata09 = g_att[l_i].detail[2].qty
         LET g_ata[l_i].ata10 = g_att[l_i].detail[3].qty
         LET g_ata[l_i].ata11 = g_att[l_i].detail[4].qty
         LET g_ata[l_i].ata12 = g_att[l_i].detail[5].qty
         LET g_ata[l_i].ata13 = g_att[l_i].detail[6].qty
         LET g_ata[l_i].ata14 = g_att[l_i].detail[7].qty
         LET g_ata[l_i].ata15 = g_att[l_i].detail[8].qty
         LET g_ata[l_i].ata16 = g_att[l_i].detail[9].qty
         LET g_ata[l_i].ata17 = g_att[l_i].detail[10].qty
         LET g_ata[l_i].ata18 = g_att[l_i].detail[11].qty
         LET g_ata[l_i].ata19 = g_att[l_i].detail[12].qty
         LET g_ata[l_i].ata20 = g_att[l_i].detail[13].qty
         LET g_ata[l_i].ata21 = g_att[l_i].detail[14].qty
         LET g_ata[l_i].ata22 = g_att[l_i].detail[15].qty
         LET g_ata[l_i].ata23 = g_att[l_i].detail[16].qty
         LET g_ata[l_i].ata24 = g_att[l_i].detail[17].qty
         LET g_ata[l_i].ata25 = g_att[l_i].detail[18].qty
         LET g_ata[l_i].ata26 = g_att[l_i].detail[19].qty
         LET g_ata[l_i].ata27 = g_att[l_i].detail[20].qty
         IF cl_null(g_ata[l_i].ata08) THEN
            LET g_ata[l_i].ata08 = 0
         END IF
         IF cl_null(g_ata[l_i].ata09) THEN
            LET g_ata[l_i].ata09 = 0
         END IF
         IF cl_null(g_ata[l_i].ata10) THEN
            LET g_ata[l_i].ata10 = 0
         END IF
         IF cl_null(g_ata[l_i].ata11) THEN
            LET g_ata[l_i].ata11 = 0
         END IF
         IF cl_null(g_ata[l_i].ata12) THEN
            LET g_ata[l_i].ata12 = 0
         END IF
         IF cl_null(g_ata[l_i].ata13) THEN
            LET g_ata[l_i].ata13 = 0
         END IF
         IF cl_null(g_ata[l_i].ata14) THEN
            LET g_ata[l_i].ata14 = 0
         END IF
         IF cl_null(g_ata[l_i].ata15) THEN
            LET g_ata[l_i].ata15 = 0
         END IF
         IF cl_null(g_ata[l_i].ata16) THEN
            LET g_ata[l_i].ata16 = 0
         END IF
         IF cl_null(g_ata[l_i].ata17) THEN
            LET g_ata[l_i].ata17 = 0
         END IF
         IF cl_null(g_ata[l_i].ata18) THEN
            LET g_ata[l_i].ata18 = 0
         END IF
         IF cl_null(g_ata[l_i].ata19) THEN
            LET g_ata[l_i].ata19 = 0
         END IF
         IF cl_null(g_ata[l_i].ata20) THEN
            LET g_ata[l_i].ata20 = 0
         END IF
         IF cl_null(g_ata[l_i].ata21) THEN
            LET g_ata[l_i].ata21 = 0
         END IF
         IF cl_null(g_ata[l_i].ata22) THEN
            LET g_ata[l_i].ata22 = 0
         END IF
         IF cl_null(g_ata[l_i].ata23) THEN
            LET g_ata[l_i].ata23 = 0
         END IF
         IF cl_null(g_ata[l_i].ata24) THEN
            LET g_ata[l_i].ata24 = 0
         END IF
         IF cl_null(g_ata[l_i].ata25) THEN
            LET g_ata[l_i].ata25 = 0
         END IF
         IF cl_null(g_ata[l_i].ata26) THEN
            LET g_ata[l_i].ata26 = 0
         END IF
         IF cl_null(g_ata[l_i].ata27) THEN
            LET g_ata[l_i].ata27 = 0
         END IF
         LET g_ata[l_i].ata28 = g_ata[l_i].ata08 + g_ata[l_i].ata09 + g_ata[l_i].ata10
                              + g_ata[l_i].ata11 + g_ata[l_i].ata12 + g_ata[l_i].ata13
                              + g_ata[l_i].ata14 + g_ata[l_i].ata15 + g_ata[l_i].ata16
                              + g_ata[l_i].ata17 + g_ata[l_i].ata18 + g_ata[l_i].ata19
                              + g_ata[l_i].ata20 + g_ata[l_i].ata21 + g_ata[l_i].ata22
                              + g_ata[l_i].ata23 + g_ata[l_i].ata24 + g_ata[l_i].ata25
                              + g_ata[l_i].ata26 + g_ata[l_i].ata27
      END FOR
   END IF
      
END FUNCTION
#FUN-A50054

#FUN-A60035 add begin
FUNCTION s_detail_ins_ata()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_j     LIKE type_file.num5

   IF g_color.getLength() = 0 THEN
      RETURN
   END IF
   FOR l_i = 1 TO g_color.getLength()
      INITIALIZE g_ata[l_i].* TO NULL
      LET g_ata[l_i].ata08 = 0
      LET g_ata[l_i].ata09 = 0
      LET g_ata[l_i].ata10 = 0
      LET g_ata[l_i].ata11 = 0
      LET g_ata[l_i].ata12 = 0
      LET g_ata[l_i].ata13 = 0
      LET g_ata[l_i].ata14 = 0
      LET g_ata[l_i].ata15 = 0
      LET g_ata[l_i].ata16 = 0
      LET g_ata[l_i].ata17 = 0
      LET g_ata[l_i].ata18 = 0
      LET g_ata[l_i].ata19 = 0
      LET g_ata[l_i].ata20 = 0
      LET g_ata[l_i].ata21 = 0
      LET g_ata[l_i].ata22 = 0
      LET g_ata[l_i].ata23 = 0
      LET g_ata[l_i].ata24 = 0
      LET g_ata[l_i].ata25 = 0
      LET g_ata[l_i].ata26 = 0
      LET g_ata[l_i].ata27 = 0
      LET g_ata[l_i].ata28 = 0
     
      LET g_ata[l_i].ata06 = g_color[l_i].ata06
      LET g_ata[l_i].ata07 = '1'
   END FOR
   CALL s_detail_ata_to_att()
   FOR l_i = 1 TO g_color.getLength()
      IF l_i > 1 THEN
         FOR l_j = 1 TO 20
            LET g_att[l_i].detail[l_j].size=g_att[l_i-1].detail[l_j].size
         END FOR
      END IF
      LET l_ac = l_i
      CALL s_detail_ins('F')
   END FOR
END FUNCTION

FUNCTION s_detail_ins_ata_2()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_j     LIKE type_file.num5
  
    
END FUNCTION

FUNCTION s_detail_del_ata()
   DEFINE l_ata03    LIKE ata_file.ata03
   DEFINE l_ata08    LIKE ata_file.ata08
   DEFINE l_sql      STRING

   LET l_sql = "SELECT ata03,ata08",
               " FROM ata_file WHERE ata00 = '",g_argv1,"' AND ata02 = ",
                 g_argv3," AND ata01 = '",g_argv2,"'",
               " ORDER BY ata06,ata07"
   PREPARE s_detail_del_pre FROM l_sql
   DECLARE s_detail_del_cus CURSOR FOR s_detail_del_pre
   FOREACH s_detail_del_cus INTO l_ata03,l_ata08
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,0)
      END IF
      IF l_ata08 <= 0 THEN
         DELETE FROM ata_file 
          WHERE ata00 = g_argv1 AND ata02 = g_argv3
            AND ata01 = g_argv2 AND ata03 = l_ata03
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("del","ata_file","ata00","ata01",STATUS,"","",1) 
         END IF
      END IF
   END FOREACH
END FUNCTION

FUNCTION s_detail_ins_2()
DEFINE l_i,l_j             LIKE type_file.num5
DEFINE l_ps                LIKE type_file.chr1
DEFINE l_color,l_size      LIKE agd_file.agd03
DEFINE l_list              LIKE type_file.chr100
DEFINE l_result,l_count    LIKE type_file.num5
DEFINE l_ima02             LIKE ima_file.ima02
DEFINE l_value             LIKE type_file.chr100
DEFINE l_sql               LIKE type_file.chr1000
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps=' ' END IF
   FOR l_j = 1 TO 20
         IF g_att[l_ac].detail[l_j].qty <> 0 THEN
            LET g_ata04 = g_argv4,l_ps,g_att[l_ac].color,l_ps,g_att[l_ac].detail[l_j].size
            SELECT MAX(ata03)+1 INTO g_att[l_ac].detail[l_j].ata03 FROM ata_file
               WHERE ata00=g_argv1 AND ata01=g_argv2
            IF cl_null( g_att[l_ac].detail[l_j].ata03) THEN
               LET  g_att[l_ac].detail[l_j].ata03 = 1
            END IF
            INSERT INTO ata_file(ata00,ata01,ata02,ata03,ata04,ata05,
                                    ata06,ata07,ata08,ata09,ata10,ata11,
                                    ata12,ata13,ata14,ata15,ata16,ata17,ata18,
                                    ata19,ata20,ata21,ata22,ata23,ata24,ata25,
                                    ata26,ata27,ata28)
                           VALUES(g_argv1,g_argv2,g_argv3, g_att[l_ac].detail[l_j].ata03,g_ata04,g_argv4,
                           g_ata[l_ac].ata06,g_ata[l_ac].ata07,g_att[l_ac].detail[l_j].qty,0,
                           0,0,0,0,0, 0,0,0,0, 0,0,0,0,0, 0,0,0,0,0)
            IF SQLCA.sqlcode <> 0 THEN
                  CALL cl_err3("ins","ata_file","ata00","ata01",STATUS,"","",1)
                  LET g_success = 'N'
            ELSE
               OPEN att_curs USING g_ata[l_ac].ata06
               FETCH att_curs INTO l_color
               CLOSE att_curs
               OPEN att_curs2 USING g_att[l_ac].detail[l_j].size
               FETCH att_curs2 INTO l_size
               CLOSE att_curs2
               LET l_list = g_ata[l_ac].ata06,'|',l_color,'|',g_att[l_ac].detail[l_j].size,'|',l_size
               SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_ata05
               LET l_value= l_ima02,l_ps,l_color,l_ps,l_size
               CALL cl_copy_ima(g_argv4,g_ata04,l_value,l_list) RETURNING l_result
               IF l_result = 0 THEN
                  SELECT COUNT(*) INTO l_count
                    FROM ima_file
                   WHERE ima01 = g_ata04
                  IF l_count = 0 THEN
                     CALL cl_err('','sub-152',0)
                     LET g_success = 'N'
                  END IF
               ELSE
                  INSERT INTO imx_file(imx000,imx00,imx01,imx02)
                  VALUES(g_ata04,g_argv4,g_att[l_ac].color,g_att[l_ac].detail[l_j].size)
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("ins","imx_file","ata00","ata01",STATUS,"","",1)
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END IF
   END FOR
END FUNCTION
#FUN-A60035 add end
