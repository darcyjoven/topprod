# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almq300.4gl
# Descriptions...: 簽約商戶查詢作業
# Date & Author..: No:FUN-C60062 12/06/20 By fanbj
# Modify.........: No:FUN-C60062 12/06/30 By yangxf 新增rtz13栏位

DATABASE ds                  

GLOBALS "../../config/top.global"

DEFINE g_rtz01      LIKE rtz_file.rtz01
DEFINE g_lntplant   STRING  
DEFINE g_chk_auth   STRING
DEFINE g_lnt17      LIKE lnt_file.lnt17
DEFINE g_lnt18      LIKE lnt_file.lnt18
DEFINE g_lnt        DYNAMIC ARRAY OF RECORD
          lnt04        LIKE lnt_file.lnt04,
          lne05        LIKE lne_file.lne05,
          lne07        LIKE lne_file.lne07,
          lne62        LIKE lne_file.lne62,
          oca02        LIKE oca_file.oca02,
          lne14        LIKE lne_file.lne14,
          lne15        LIKE lne_file.lne15,
          lne28        LIKE lne_file.lne28,
          lntplant     LIKE lnt_file.lntplant,
          rtz13        LIKE rtz_file.rtz13,         #FUN-C60062 add
          lnt01        LIKE lnt_file.lnt01
                    END RECORD
DEFINE g_sql        STRING,
       g_wc         STRING,      
       g_rec_b      LIKE type_file.num5, 
       l_ac         LIKE type_file.num5
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10
#FUN-C60062-------add---str
DEFINE l_table      STRING
DEFINE g_wc2        STRING
###GENGRE###START
TYPE sr1_t        RECORD
        lnt04        LIKE lnt_file.lnt04,
        lne05        LIKE lne_file.lne05,
        lne07        LIKE lne_file.lne07,
        lne62        LIKE lne_file.lne62,
        lne14        LIKE lne_file.lne14,
        lne15        LIKE lne_file.lne15,
        lne28        LIKE lne_file.lne28,
        lntplant     LIKE lnt_file.lntplant,
        lnt01        LIKE lnt_file.lnt01,
        oca02        LIKE oca_file.oca02
                  END RECORD
###GENGRE###END
#FUN-C60062-------add---end

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
   #FUN-C60062----add----str
   LET g_sql ="lnt04.lnt_file.lnt04,",
              "lne05.lne_file.lne05,",
              "lne07.lne_file.lne07,",
              "lne62.lne_file.lne62,",
              "lne14.lne_file.lne14,",
              "lne15.lne_file.lne15,",
              "lne28.lne_file.lne28,",
              "lntplant.lnt_file.lntplant,",
              "lnt01.lnt_file.lnt01,",
              "oca02.oca_file.oca02"
   LET l_table = cl_prt_temptable('almq300',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_pdate = g_today
   #FUN-C60062----add----end 
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q300_w AT p_row,p_col WITH FORM "alm/42f/almq300"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()   
   CALL q300_q()                      #FUN-C60062 add
   CALL q300_menu()
   CLOSE WINDOW q300_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)
END MAIN
  
FUNCTION q300_menu()
   WHILE TRUE
      CALL q300_bp("G")
      
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q300_q()
            END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q300_out()
            END IF

         WHEN "merchant"
            IF cl_chk_act_auth() THEN
               CALL q300_merchant()
            END IF

         WHEN "contract1"
            IF cl_chk_act_auth() THEN
               CALL q300_contract()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnt),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
    
FUNCTION q300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN          
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_lnt TO s_lnt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
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

      ON ACTION merchant
         LET INT_FLAG=FALSE
         LET g_action_choice="merchant"
         EXIT DISPLAY

      ON ACTION contract1
         LET INT_FLAG=FALSE
         LET g_action_choice="contract1"
         EXIT DISPLAY
   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q300_cs()
   DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_lnt.clear()
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT g_wc ON lntplant,lnt08,lnt09,lnt60,lnt04,lne62,lne67,lne08
                   FROM lntplant,lnt08,lnt09,lnt60,lnt04,lne62,lne67,lne08       
                
         BEFORE CONSTRUCT
            CALL cl_qbe_init() 
              
         ON ACTION controlp
            CASE
               WHEN INFIELD(lntplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01"
                  LET g_qryparam.where = " azw01 IN ",g_auth," "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lntplant
                  NEXT FIELD lntplant
                  
               WHEN INFIELD(lnt08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lnt08"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt08
                  NEXT FIELD lnt08
                  
               WHEN INFIELD(lnt09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lnt09"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt09
                  NEXT FIELD lnt09
                  
               WHEN INFIELD(lnt60)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lnt60"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt60
                  NEXT FIELD lnt60
                  
               WHEN INFIELD(lnt04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lnt04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt04
                  NEXT FIELD lnt04
                  
               WHEN INFIELD(lne62)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lne62"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne62
                  NEXT FIELD lne62
                  
               WHEN INFIELD(lne67)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lne67"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne67
                  NEXT FIELD lne67
                  
               WHEN INFIELD(lne08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lne08"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne08
                  NEXT FIELD lne08
                    
               OTHERWISE
                  EXIT CASE
            END CASE
 
         ON ACTION qbe_select                         	  
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)          

         AFTER CONSTRUCT
            IF cl_null(GET_FLDBUF(lntplant)) OR GET_FLDBUF(lntplant) = "*" THEN
                 LET g_chk_auth = g_auth
              END IF
            LET g_lntplant = GET_FLDBUF(lntplant)
           	
      END CONSTRUCT
   
      INPUT g_lnt17,g_lnt18 FROM lnt17,lnt18 

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION qbe_save
            CALL cl_qbe_save()
        
          
      END INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG

   END DIALOG
    
   IF INT_FLAG THEN
      RETURN
   END IF	      
   IF cl_null(g_wc) THEN
     LET g_wc=" 1=1"
   END IF
END FUNCTION
 
FUNCTION q300_q()
   LET g_chk_auth = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lnt.clear()
   MESSAGE ""
   
   CALL q300_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_lnt.clear()
      RETURN
   END IF
   CALL q300_show()
END FUNCTION
 
FUNCTION q300_show()
   CALL q300_b_fill(g_wc)   
   CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION q300_b_fill(p_wc)              
   DEFINE p_wc       STRING  
   DEFINE l_n        LIKE type_file.num10
   DEFINE l_lntplant STRING
   DEFINE l_rtz13    LIKE rtz_file.rtz13     #FUN-C60026 add
   DEFINE tok        base.StringTokenizer
   
   CALL g_lnt.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"

   IF NOT cl_null(g_lntplant) AND g_lntplant <> "*" THEN
      LET tok = base.StringTokenizer.create(g_lntplant,"|")
      LET l_lntplant = ""
      WHILE tok.hasMoreTokens()
         LET l_lntplant = tok.nextToken()
         LET g_sql = " SELECT COUNT(*) FROM azw_file,rtz_file ",
                     "  WHERE rtz01 = '",l_lntplant,"' ",
                     "    AND rtz01 = azw01 ",
                     "    AND azwacti = 'Y'",
                     "    AND azw01 IN ",g_auth
         PREPARE sel_num_pre FROM g_sql
         EXECUTE sel_num_pre INTO l_n
         IF l_n > 0 THEN
             IF g_chk_auth IS NULL THEN
                LET g_chk_auth = "'",g_lntplant,"'"
             ELSE
                LET g_chk_auth = g_chk_auth,",'",l_lntplant,"'"
             END IF
         ELSE
            CONTINUE WHILE
         END IF
      END WHILE
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
   END IF
    
   LET g_sql = " SELECT DISTINCT rtz01 FROM rtz_file,azw_file ",
               "  WHERE azw01 = rtz01 ",
               "    AND rtz01 IN " ,g_chk_auth ,
               "  ORDER BY rtz01 "
   
   PREPARE q300_pb_1 FROM g_sql
   DECLARE q300_bcl CURSOR FOR q300_pb_1
   FOREACH q300_bcl INTO g_rtz01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_sql = "SELECT DISTINCT lnt04,lne05,lne07,lne62,'',lne14,lne15,",
                  "       lne28,lntplant,'',lnt01 ",                                  #FUN-C60026 add ''
                  "  FROM ",cl_get_target_table(g_rtz01,'lnt_file'),",",
                            cl_get_target_table(g_rtz01,'lne_file'),
                  " WHERE lntplant ='",g_rtz01,"'",
                  "   AND lnt04 = lne01 ",
                  "   AND lnt26 = 'Y' ",
                  "   AND lne36 = 'Y'"

      IF p_wc <> ' 1=1' THEN
         LET g_sql = g_sql, " AND ",p_wc CLIPPED 
      END IF        

      IF NOT cl_null(g_lnt17) THEN
         LET g_sql = g_sql," AND lnt17 >= '",g_lnt17,"' " 
      END IF 
     
      IF NOT cl_null(g_lnt18) THEN
         LET g_sql = g_sql," AND lnt18 <= '",g_lnt18,"' " 
      END IF 
 
      PREPARE q300_pb FROM g_sql
      DECLARE lnt_cs CURSOR FOR q300_pb
      FOREACH lnt_cs INTO g_lnt[g_cnt].*  
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) 
            EXIT FOREACH
         END IF
      
         LET g_sql = " SELECT oca02 ",
                     "   FROM ",cl_get_target_table(g_rtz01,'oca_file'),
                     "  WHERE oca01 = '",g_lnt[g_cnt].lne62,"'"
         PREPARE oca_cs FROM g_sql
         EXECUTE oca_cs INTO g_lnt[g_cnt].oca02
         DISPLAY BY NAME g_lnt[g_cnt].oca02
#FUN-C60026 add being --
         LET g_sql = " SELECT rtz13 ",
                     "   FROM ",cl_get_target_table(g_rtz01,'rtz_file'),
                     "  WHERE rtz01 = '",g_lnt[g_cnt].lntplant,"'"
         PREPARE rtz_cs FROM g_sql
         EXECUTE rtz_cs INTO l_rtz13
         LET g_lnt[g_cnt].rtz13 = l_rtz13 
         DISPLAY BY NAME g_lnt[g_cnt].rtz13
#FUN-C60026 add end ----
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            EXIT FOREACH
         END IF 
      END FOREACH
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_lnt.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
END FUNCTION

#FUN-C60062----mark----str    
#FUNCTION q300_out()
##  DEFINE l_cmd LIKE type_file.chr1000    #FUN-C60062 mark
#   DEFINE l_cmd STRING                    #FUN-C60062 add 
#   CALL cl_wait()
#
#   CASE
#      WHEN (NOT cl_null(g_lnt17)) AND (NOT cl_null(g_lnt18))
#         LET l_cmd='almg301 "',g_chk_auth CLIPPED,'" "',g_wc CLIPPED,'" "',g_lang CLIPPED,'" ',
#                   '"',g_today,'" "',g_lnt17,'" "',g_lnt18,'" '
#      WHEN (NOT cl_null(g_lnt17)) AND cl_null(g_lnt18)
#         LET l_cmd='almg301 "',g_chk_auth CLIPPED,'" "',g_wc CLIPPED,'" "',g_lang CLIPPED,'" ',
#                   '"',g_today,'" "',g_lnt17,'" "" '
#      WHEN cl_null(g_lnt17) AND (NOT cl_null(g_lnt18))
#         LET l_cmd='almg301 "',g_chk_auth CLIPPED,'" "',g_wc CLIPPED,'" "',g_lang CLIPPED,'" ',
#                   '"',g_today,'" "" "',g_lnt18,'" '
#      WHEN cl_null(g_lnt17) AND cl_null(g_lnt18)
#         LET l_cmd='almg301 "',g_chk_auth CLIPPED,'" "',g_wc CLIPPED,'" "',g_lang CLIPPED,'" ',
#                   '"',g_today,'" "" "" '
#   END CASE
#
#   #LET l_cmd='almg301 "',g_chk_auth CLIPPED,'" "',g_wc CLIPPED,'" "',g_lang CLIPPED,'" "',g_today,'" '
#   CALL cl_cmdrun(l_cmd)
#
#   ERROR ''
#END FUNCTION
#FUN-C60062----mark----end

FUNCTION q300_merchant()
   DEFINE l_cmd LIKE type_file.chr1000

   IF cl_null(g_lnt[l_ac].lnt04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_cmd="almi300 '",g_lnt[l_ac].lnt04 CLIPPED,"'"
   CALL cl_cmdrun(l_cmd)
END FUNCTION

FUNCTION q300_contract()
   DEFINE l_cmd LIKE type_file.chr1000

   IF cl_null(g_lnt[l_ac].lnt01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lnt[l_ac].lntplant <> g_plant THEN
      CALL cl_err('','alm1627',0)
      RETURN
   END IF 

   LET l_cmd="almi400 '",g_lnt[l_ac].lnt01 CLIPPED,"'"
   CALL cl_cmdrun(l_cmd)
END FUNCTION
#FUN-C60062-------add---str
FUNCTION q300_out()
   DEFINE l_sql     LIKE type_file.chr1000,
          l_oca02   LIKE oca_file.oca02,
          l_where   STRING,
          l_table1  STRING,
       sr       RECORD
                lnt04        LIKE lnt_file.lnt04,
                lne05        LIKE lne_file.lne05,
                lne07        LIKE lne_file.lne07,
                lne62        LIKE lne_file.lne62,
                lne14        LIKE lne_file.lne14,
                lne15        LIKE lne_file.lne15,
                lne28        LIKE lne_file.lne28,
                lntplant     LIKE lnt_file.lntplant,
                lnt01        LIKE lnt_file.lnt01
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'lntplant,lnt08,lnt09,lnt60,lnt04,lne62,lne67,lne08,lnt17,lnt18')
                      RETURNING g_wc2
        IF g_wc2.getLength() > 1000 THEN
            LET g_wc2 = g_wc2.subString(1,600)
            LET g_wc2 = g_wc2,"..."
        END IF
     END IF

     IF NOT cl_null(g_lnt17) THEN
        LET g_sql = g_sql ," AND lnt17 >= '",g_lnt17,"' "
        LET g_wc = g_wc,";lnt17>= ",g_lnt17
     END IF

     IF NOT cl_null(g_lnt18) THEN
        LET g_sql = g_sql ," AND lnt18 <= '",g_lnt18,"' "
        LET g_wc = g_wc,";lnt18 <= ",g_lnt18
     END IF
     LET g_sql = "SELECT lnt04,lne05,lne07,lne62,lne14,",
                 "       lne15,lne28,lntplant,lnt01 "
     LET l_table1 = "  FROM ",cl_get_target_table(g_rtz01,'lnt_file'),",",
                             cl_get_target_table(g_rtz01,'lne_file')
     LET l_where = " WHERE lnt04 = lne01 ",
                   "   AND lnt26 = 'Y' ",
                   "   AND lne36 = 'Y' ",
                   "   AND lntplant = '",g_rtz01,"'"

     LET g_sql = g_sql,l_table1,l_where," AND ",g_wc CLIPPED
     PREPARE q300_prepare1 FROM g_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table1)   
        EXIT PROGRAM
     END IF
     DECLARE q300_cs1 CURSOR FOR q300_prepare1

     DISPLAY l_table
     FOREACH q300_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_oca02 = ' '
       LET g_sql = " SELECT oca02 ",
                   "   FROM ",cl_get_target_table(g_rtz01,'oca_file'),
                   "  WHERE oca01 = '",sr.lne62,"'"
       PREPARE oca_cs1 FROM g_sql
       EXECUTE oca_cs1 INTO l_oca02
       EXECUTE insert_prep USING sr.*,l_oca02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL q300_grdata()  
END FUNCTION

FUNCTION q300_grdata()
   DEFINE l_sql      STRING
   DEFINE handler    om.SaxDocumentHandler
   DEFINE sr1        sr1_t
   DEFINE l_cnt      LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      CALL cl_msgany(0, 0, "No Data!!")
      RETURN 
   END IF

   WHILE TRUE                 
      CALL cl_gre_init_pageheader()   
      LET handler = cl_gre_outnam("almq300")
      IF handler IS NOT NULL THEN
         START REPORT q300_rep TO XML HANDLER handler
         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lnt04"
           DECLARE q300_datacur1 CURSOR FROM l_sql
           FOREACH q300_datacur1 INTO sr1.*
               OUTPUT TO REPORT q300_rep(sr1.*)
           END FOREACH
           FINISH REPORT q300_rep
      END IF
      IF INT_FLAG = TRUE THEN
          LET INT_FLAG = FALSE 
          EXIT WHILE
      END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT q300_rep(sr1)
   DEFINE sr1 sr1_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_lne07  STRING
   DEFINE l_lne28  STRING

   FORMAT
      FIRST PAGE HEADER
          PRINTX g_grPageHeader.*
          PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime
          PRINTX g_wc
          PRINTX g_wc2


      ON EVERY ROW
          LET l_lineno = l_lineno + 1
          PRINTX l_lineno
          LET l_lne07 = cl_gr_getmsg('gre-289',g_lang,sr1.lne07)
          LET l_lne07 = sr1.lne07,":",l_lne07
          PRINTX l_lne07
          LET l_lne28 = cl_gr_getmsg('gre-290',g_lang,sr1.lne28)
          LET l_lne28 = sr1.lne28,":",l_lne28
          PRINTX l_lne28
          PRINTX sr1.*

      ON LAST ROW
END REPORT
###GENGRE###END
#FUN-C60062-------add---end   
    
