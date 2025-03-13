# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglq051.4gl
# Descriptions...: ABC
# Date & Author..: 11/03/22 By zhangweib
# Modify.........: NO.FUN-B40104 11/05/05 By jll    合并报表作业
# Modify.........: NO.FUN-B90082 11/09/13 By zhangweib 修改第二單身抓數據sql，修改單頭CONSTRUCT時欄位順序
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037

DEFINE
     tm  RECORD
       	wc  	STRING,
        wc2     STRING
        END RECORD,
    g_atd  RECORD
            atd01   LIKE atd_file.atd01,
            atd03   LIKE atd_file.atd03,
            atd02   LIKE atd_file.atd02,
            atd04   LIKE atd_file.atd04,
            atd12   LIKE atd_file.atd12
        END RECORD,
    g_list1 DYNAMIC ARRAY OF RECORD
            atd05   LIKE atd_file.atd05,  
            nml02   LIKE nml_file.nml02,
            atd06   LIKE atd_file.atd06
        END RECORD,
    g_list2 DYNAMIC ARRAY OF RECORD
            atd05   LIKE atd_file.atd05,  
            nml02   LIKE nml_file.nml02,
            atd06   LIKE atd_file.atd06
        END RECORD,
    g_atd02_1       LIKE atd_file.atd02,
    g_wc,g_sql      STRING,
    p_row,p_col     LIKE type_file.num5,
    g_rec_b         LIKE type_file.num5,
    g_rec_b2        LIKE type_file.num5

DEFINE   g_cnt           LIKE type_file.num10
DEFINE   l_ac,l_ac2      LIKE type_file.num5
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   l_table         STRING,
         g_str           STRING,
         l_atd02         STRING,
         l_atd03         STRING, 
         l_atd04         STRING

MAIN
   OPTIONS
      INPUT NO WRAP         
   DEFER INTERRUPT        

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW gglq051 WITH FORM "ggl/42f/gglq051"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL q100_menu()
   CLOSE WINDOW gglq051
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q100_cs()
   DEFINE   l_cnt  LIKE type_file.num5

   CLEAR FORM
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES") 
   INITIALIZE g_atd.* TO NULL 
   CALL g_list1.clear()
   CALL g_list2.clear()
   CONSTRUCT BY NAME tm.wc ON 
            #atd01,atd03,atd02,atd04   #FUN-B90082   Mark
             atd01,atd03,atd04,atd02   #FUN-B90082   Add
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(atd01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_atd01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO atd01
                WHEN INFIELD(atd02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_asg"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO atd02
            END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about  
         CALL cl_about()  
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF

   LET g_sql=" SELECT unique atd01,atd02,atd03,atd04,atd12 FROM atd_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND atd12 <>'XX' and atd12 <>' '",			
             "   AND atd12 in(SELECT asg08 FROM asg_file ", 					
             "                 WHERE asg01 in (SELECT unique asa02 FROM asa_file",
             "                                  WHERE asa01 = atd01 ",
             "                                  UNION SELECT asb04 FROM asb_file ",
             "                                  WHERE asb01 = atd01))",
             " ORDER BY atd01,atd02,atd03,atd04,atd12"

   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs
           SCROLL CURSOR FOR q100_prepare

   LET g_sql=" SELECT unique atd01,atd02,atd03,atd04,atd12 FROM atd_file ",
             "     WHERE ",tm.wc CLIPPED,
             "   AND atd12 <>'XX' and atd12 <>' '",			
             "   AND atd12 in(SELECT asg08 FROM asg_file ", 					
             "                 WHERE asg01 in (SELECT unique asa02 FROM asa_file",
             "                                  WHERE asa01 = atd01 ",
             "                                  UNION SELECT asb04 FROM asb_file ",
             "                                  WHERE asb01 = atd01))",
             "     INTO TEMP x "
   DROP TABLE x
   PREPARE q100_prepare_x FROM g_sql
   EXECUTE q100_prepare_x

       LET g_sql = "SELECT COUNT(*) FROM x "

   PREPARE q100_prepare_cnt FROM g_sql
   DECLARE q100_count CURSOR FOR q100_prepare_cnt
END FUNCTION

FUNCTION q100_menu()

   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q100_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q100_count
       FETCH q100_count INTO g_cnt
       DISPLAY g_cnt TO FORMONLY.cnt
       LET g_row_count = g_cnt      
       CALL q100_fetch('F') 
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1,
    l_abso         LIKE type_file.num10

    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs 
           INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd.atd12
        WHEN 'P' FETCH PREVIOUS q100_cs 
           INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd.atd12
        WHEN 'F' FETCH FIRST    q100_cs 
           INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd.atd12
        WHEN 'L' FETCH LAST     q100_cs 
           INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd.atd12
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q100_cs 
               INTO g_atd.atd01,g_atd.atd03,g_atd.atd02,g_atd.atd04,g_atd.atd12
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_atd.atd01,SQLCA.sqlcode,0)
        INITIALIZE g_atd.* TO NULL  
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    CALL q100_show()
END FUNCTION

FUNCTION q100_show()
   DEFINE l_asa02   LIKE asa_file.asa02 
   DEFINE l_asg01   LIKE asg_file.asg01 
   DEFINE l_asz01  LIKE asz_file.asz01
   DEFINE l_sql    STRING
   SELECT asz01 INTO l_asz01 FROM asz_file
   DISPLAY l_asz01 TO aaz641
   SELECT asa02 INTO l_asa02 FROM asa_file WHERE asa01 = g_atd.atd01
      AND asa04 = 'Y'    #FUN-B90082   Add
   DISPLAY BY NAME g_atd.atd01,g_atd.atd03,g_atd.atd02,g_atd.atd04 

#  select asg01 INTO g_atd02_1 FROM asg_file WHERE asg08 = g_atd12
#     AND asg01 in (SELECT unique asa02 FROM asa_file,atd_file
#                    WHERE asa01 = atd01 
#                    UNION 
#                   SELECT UNIQUE asb04 FROM asb_file,atd_file 
#                           WHERE asb01 = atd01)
   LET l_sql = " SELECT asg01 FROM asg_file WHERE asg08 = ? ",
               "    AND asg01 in (SELECT unique asa02 FROM asa_file,atd_file ",
               "        WHERE asa01 = atd01  ",
               "          AND asa01 = '",g_atd.atd01,"' ",      #FUN-B90082   Add
               "        UNION SELECT asb04 FROM asb_file,atd_file ",
               "               WHERE asb01 = atd01 ",
               "                 AND atd01 = '",g_atd.atd01,"')" #FUN-B90082   Add
   PREPARE atd02_1 FROM l_sql
   EXECUTE atd02_1 USING g_atd.atd12 INTO g_atd02_1
  #DISPLAY g_atd02_1,l_asa02 TO atd02_1,asa02     #FUN-B90082   Mark
   DISPLAY g_atd.atd12,l_asa02 TO atd02_1,asa02   #FUN-B90082   Add
   CALL q100_b_fill()
   CALL q100_b2_fill()
   CALL cl_show_fld_cont()   
END FUNCTION

FUNCTION q100_b_fill()
   DEFINE l_sql     STRING, 
          l_n       LIKE type_file.num5

   LET l_atd02 = g_atd.atd02
   LET l_atd03 = g_atd.atd03
   LET l_atd04 = g_atd.atd04
   LET l_sql =
        " SELECT atd05,nml02,atd06        ",
        "   FROM atd_file,nml_file ",
        "  WHERE atd01 = '",g_atd.atd01,"'",
        "    AND atd02 = '",l_atd02,"'",
        "    AND atd03 = '",l_atd03,"'",
        "    AND atd04 = '",l_atd04,"'",
        "    AND atd12 = '",g_atd.atd12,"'",
        "    AND atd05 = nml01"
   PREPARE q100_pb FROM l_sql
   DECLARE q100_bcs CURSOR FOR q100_pb
   CALL g_list1.clear() 

   LET g_rec_b=0
   OPEN q100_bcs
   IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
   END IF
   LET l_ac = 1
   FOREACH q100_bcs INTO g_list1[l_ac].*
      IF SQLCA.sqlcode = 100 THEN
##########
      END IF
#          IF g_i = 0 THEN
#               CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
#               LET g_atd[g_cnt].seq = g_msg clipped
#          ELSE 
#               LET g_atd[g_cnt].seq = g_i
#          END IF
       LET l_ac = l_ac + 1
    END FOREACH
    CALL g_list1.deleteElement(l_ac)     #FUN-B90082   Add

    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn1
END FUNCTION

FUNCTION q100_b2_fill()
   DEFINE l_sql     STRING, 
          l_n       LIKE type_file.num5
   DEFINE l_asg01   LIKE asg_file.asg01                              #FUN-B90082   Add
   SELECT asg01 INTO l_asg01 FROM asg_file WHERE asg08 = g_atd.atd02 #FUN-B90082   Add
   LET l_atd02 = g_atd02_1
   LET l_atd03 = g_atd.atd03
   LET l_atd04 = g_atd.atd04
   LET l_sql =
        " SELECT atd05,nml02,atd06        ",
        "   FROM atd_file,nml_file  ",
        "  WHERE atd01 = '",g_atd.atd01,"'",
        "    AND atd02 = '",l_atd02,"'",
        "    AND atd03 = '",l_atd03,"'",
        "    AND atd04 = '",l_atd04,"'",
        "    AND atd12 = '",g_atd.atd02,"'", 
        "    AND atd05 = nml01   "
   PREPARE q100_pb2 FROM l_sql
   DECLARE q100_bcs2 CURSOR FOR q100_pb2
   CALL g_list2.clear() 

   LET g_rec_b2 = 0
   OPEN q100_bcs2
   IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
   END IF
   LET l_ac2 = 1
   FOREACH q100_bcs2 INTO g_list2[l_ac2].*
      LET l_ac2 = l_ac2 + 1
   END FOREACH
   CALL g_list2.deleteElement(l_ac2)   #FUN-B90082   Add
    LET g_rec_b2 = l_ac2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION

FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_list1 TO s_atd1.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  

   END DISPLAY
   
   DISPLAY ARRAY g_list2 TO s_atd2.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
   END DISPLAY 
   
   BEFORE DIALOG   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION first
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL q100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION controlg
         CALL cl_cmdask()
               
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
#NO.FUN-B40104
