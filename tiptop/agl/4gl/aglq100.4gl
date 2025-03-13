# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglq100.4gl
# Descriptions...: ABC
# Date & Author..: 11/03/22 By zhangweib
# Modify.........: NO.FUN-B40104 11/05/05 By jll    合并报表作业
# Modify.........: NO.FUN-B90082 11/09/14 By zhangweib 修改第二單身抓數據sql，修改單頭CONSTRUCT時欄位順序

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     tm  RECORD
       	wc  	STRING,
        wc2     STRING
        END RECORD,
    g_aep  RECORD
            aep01   LIKE aep_file.aep01,
            aep03   LIKE aep_file.aep03,
            aep02   LIKE aep_file.aep02,
            aep04   LIKE aep_file.aep04,
            aep12   LIKE aep_file.aep12
        END RECORD,
    g_list1 DYNAMIC ARRAY OF RECORD
            aep05   LIKE aep_file.aep05,  
            nml02   LIKE nml_file.nml02,
            aep06   LIKE aep_file.aep06
        END RECORD,
    g_list2 DYNAMIC ARRAY OF RECORD
            aep05   LIKE aep_file.aep05,  
            nml02   LIKE nml_file.nml02,
            aep06   LIKE aep_file.aep06
        END RECORD,
    g_aep02_1       LIKE aep_file.aep02,
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
         l_aep02         STRING,
         l_aep03         STRING, 
         l_aep04         STRING

MAIN
   OPTIONS
      INPUT NO WRAP         
   DEFER INTERRUPT        

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW aglq100 WITH FORM "agl/42f/aglq100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL q100_menu()
   CLOSE WINDOW aglq100
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q100_cs()
   DEFINE   l_cnt  LIKE type_file.num5

   CLEAR FORM
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES") 
   INITIALIZE g_aep.* TO NULL 
   CALL g_list1.clear()
   CALL g_list2.clear()
   CONSTRUCT BY NAME tm.wc ON 
            #aep01,aep03,aep02,aep04  #FUN-B90082   Mark
             aep01,aep03,aep04,aep02  #FUN-B90082   Add
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aep01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aep01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aep01
                WHEN INFIELD(aep02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_axz"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aep02
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

   LET g_sql=" SELECT unique aep01,aep02,aep03,aep04,aep12 FROM aep_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND aep12 <>'XX' and aep12 <>' '",			
             "   AND aep12 in(SELECT axz08 FROM axz_file ", 					
             "                 WHERE axz01 in (SELECT unique axa02 FROM axa_file",
             "                                  WHERE axa01 = aep01 ",
             "                                  UNION SELECT axb04 FROM axb_file ",
             "                                  WHERE axb01 = aep01))",
             " ORDER BY aep01,aep02,aep03,aep04,aep12"

   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs
           SCROLL CURSOR FOR q100_prepare

   LET g_sql=" SELECT unique aep01,aep02,aep03,aep04,aep12 FROM aep_file ",
             "     WHERE ",tm.wc CLIPPED,
             "   AND aep12 <>'XX' and aep12 <>' '",			
             "   AND aep12 in(SELECT axz08 FROM axz_file ", 					
             "                 WHERE axz01 in (SELECT unique axa02 FROM axa_file",
             "                                  WHERE axa01 = aep01 ",
             "                                  UNION SELECT axb04 FROM axb_file ",
             "                                  WHERE axb01 = aep01))",
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aep),'','')
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
           INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep.aep12
        WHEN 'P' FETCH PREVIOUS q100_cs 
           INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep.aep12
        WHEN 'F' FETCH FIRST    q100_cs 
           INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep.aep12
        WHEN 'L' FETCH LAST     q100_cs 
           INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep.aep12
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
               INTO g_aep.aep01,g_aep.aep03,g_aep.aep02,g_aep.aep04,g_aep.aep12
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aep.aep01,SQLCA.sqlcode,0)
        INITIALIZE g_aep.* TO NULL  
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
   DEFINE l_axa02   LIKE axa_file.axa02 
   DEFINE l_axz01   LIKE axz_file.axz01 
   DEFINE l_aaw01  LIKE aaw_file.aaw01
   DEFINE l_sql    STRING
   SELECT aaw01 INTO l_aaw01 FROM aaw_file
   DISPLAY l_aaw01 TO aaz641
   SELECT axa02 INTO l_axa02 FROM axa_file WHERE axa01 = g_aep.aep01
      AND axa04 = 'Y'    #FUN-B90082   Add
   DISPLAY BY NAME g_aep.aep01,g_aep.aep03,g_aep.aep02,g_aep.aep04 

#  select axz01 INTO g_aep02_1 FROM axz_file WHERE axz08 = g_aep12
#     AND axz01 in (SELECT unique axa02 FROM axa_file,aep_file
#                    WHERE axa01 = aep01 
#                    UNION 
#                   SELECT UNIQUE axb04 FROM axb_file,aep_file 
#                           WHERE axb01 = aep01)
   LET l_sql = " SELECT axz01 FROM axz_file WHERE axz08 = ? ",
               "    AND axz01 in (SELECT unique axa02 FROM axa_file,aep_file ",
               "        WHERE axa01 = aep01  ",
               "          AND axa01 = '",g_aep.aep01,"' ",      #FUN-B90082   Add
               "        UNION SELECT axb04 FROM axb_file,aep_file ",
               "               WHERE axb01 = aep01 ",
               "                 AND aep01 = '",g_aep.aep01,"')" #FUN-B90082   Add
   PREPARE aep02_1 FROM l_sql
   EXECUTE aep02_1 USING g_aep.aep12 INTO g_aep02_1
  #DISPLAY g_aep02_1,l_axa02 TO aep02_1,axa02     #FUN-B90082   Mark
   DISPLAY g_aep.aep12,l_axa02 TO aep02_1,axa02   #FUN-B90082   Add
   CALL q100_b_fill()
   CALL q100_b2_fill()
   CALL cl_show_fld_cont()   
END FUNCTION

FUNCTION q100_b_fill()
   DEFINE l_sql     STRING, 
          l_n       LIKE type_file.num5

   LET l_aep02 = g_aep.aep02
   LET l_aep03 = g_aep.aep03
   LET l_aep04 = g_aep.aep04
   LET l_sql =
        " SELECT aep05,nml02,aep06        ",
        "   FROM aep_file,nml_file ",
        "  WHERE aep01 = '",g_aep.aep01,"'",
        "    AND aep02 = '",l_aep02,"'",
        "    AND aep03 = '",l_aep03,"'",
        "    AND aep04 = '",l_aep04,"'",
        "    AND aep12 = '",g_aep.aep12,"'",
        "    AND aep05 = nml01"
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
#               LET g_aep[g_cnt].seq = g_msg clipped
#          ELSE 
#               LET g_aep[g_cnt].seq = g_i
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
   DEFINE l_axz01   LIKE axz_file.axz01                              #FUN-B90082   Add
   SELECT axz01 INTO l_axz01 FROM axz_file WHERE axz08 = g_aep.aep02 #FUN-B90082   Add
   LET l_aep02 = g_aep02_1
   LET l_aep03 = g_aep.aep03
   LET l_aep04 = g_aep.aep04
   LET l_sql =
        " SELECT aep05,nml02,aep06        ",
        "   FROM aep_file,nml_file  ",
        "  WHERE aep01 = '",g_aep.aep01,"'",
        "    AND aep02 = '",l_aep02,"'",
        "    AND aep03 = '",l_aep03,"'",
        "    AND aep04 = '",l_aep04,"'",
        "    AND aep12 = '",g_aep.aep02,"'",
        "    AND aep05 = nml01   "
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
   DISPLAY ARRAY g_list1 TO s_aep1.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  

   END DISPLAY
   
   DISPLAY ARRAY g_list2 TO s_aep2.* ATTRIBUTE(COUNT=g_rec_b2)
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
