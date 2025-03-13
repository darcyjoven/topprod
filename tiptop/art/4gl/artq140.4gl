# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artq140.4gl
# Descriptions...: 營運中心銷售目標查詢作業
# Date & Author..: No.FUN-B50067 11/05/16 By baogc
# Modify.........: No.FUN-B80085 11/08/09 By fanbj 用g_time替换l_time

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_rwt1          DYNAMIC ARRAY OF RECORD
           rwt01       LIKE rwt_file.rwt01,
           azw08       LIKE azw_file.azw08,
           rwt02       LIKE rwt_file.rwt01,
           rwt_p       LIKE type_file.num5,
           rwt201      LIKE rwt_file.rwt201,
           rwt202      LIKE rwt_file.rwt202,
           rwt203      LIKE rwt_file.rwt203,
           rwt204      LIKE rwt_file.rwt204,
           rwt205      LIKE rwt_file.rwt205,
           rwt206      LIKE rwt_file.rwt206,
           rwt207      LIKE rwt_file.rwt207,
           rwt208      LIKE rwt_file.rwt208,
           rwt209      LIKE rwt_file.rwt209,
           rwt210      LIKE rwt_file.rwt210,
           rwt211      LIKE rwt_file.rwt211,
           rwt212      LIKE rwt_file.rwt212
                     END RECORD,
       g_rwt1_t        RECORD
           rwt01       LIKE rwt_file.rwt01,
           azw08       LIKE azw_file.azw08,
           rwt02       LIKE rwt_file.rwt01,
           rwt_p       LIKE type_file.num5,
           rwt201      LIKE rwt_file.rwt201,
           rwt202      LIKE rwt_file.rwt202,
           rwt203      LIKE rwt_file.rwt203,
           rwt204      LIKE rwt_file.rwt204,
           rwt205      LIKE rwt_file.rwt205,
           rwt206      LIKE rwt_file.rwt206,
           rwt207      LIKE rwt_file.rwt207,
           rwt208      LIKE rwt_file.rwt208,
           rwt209      LIKE rwt_file.rwt209,
           rwt210      LIKE rwt_file.rwt210,
           rwt211      LIKE rwt_file.rwt211,
           rwt212      LIKE rwt_file.rwt212
                     END RECORD
DEFINE g_rwt2         DYNAMIC ARRAY OF RECORD
           rwt01       LIKE rwt_file.rwt01,
           rwt01_desc  LIKE azw_file.azw08,
           rwt02       LIKE rwt_file.rwt01,
           rwt201_desc LIKE type_file.num5,
           rwt201      LIKE rwt_file.rwt201,
           rwt202_desc LIKE type_file.num5,
           rwt202      LIKE rwt_file.rwt202,
           rwt203_desc LIKE type_file.num5,
           rwt203      LIKE rwt_file.rwt203,
           rwt204_desc LIKE type_file.num5,
           rwt204      LIKE rwt_file.rwt204,
           rwt205_desc LIKE type_file.num5,
           rwt205      LIKE rwt_file.rwt205,
           rwt206_desc LIKE type_file.num5,
           rwt206      LIKE rwt_file.rwt206,
           rwt207_desc LIKE type_file.num5,
           rwt207      LIKE rwt_file.rwt207,
           rwt208_desc LIKE type_file.num5,
           rwt208      LIKE rwt_file.rwt208,
           rwt209_desc LIKE type_file.num5,
           rwt209      LIKE rwt_file.rwt209,
           rwt210_desc LIKE type_file.num5,
           rwt210      LIKE rwt_file.rwt210,
           rwt211_desc LIKE type_file.num5,
           rwt211      LIKE rwt_file.rwt211,
           rwt212_desc LIKE type_file.num5,
           rwt212      LIKE rwt_file.rwt212
                     END RECORD,
       g_rwt2_t     RECORD
           rwt01       LIKE rwt_file.rwt01,
           rwt01_desc  LIKE azw_file.azw08,
           rwt02       LIKE rwt_file.rwt01,
           rwt201_desc LIKE type_file.num5,
           rwt201      LIKE rwt_file.rwt201,
           rwt202_desc LIKE type_file.num5,
           rwt202      LIKE rwt_file.rwt202,
           rwt203_desc LIKE type_file.num5,
           rwt203      LIKE rwt_file.rwt203,
           rwt204_desc LIKE type_file.num5,
           rwt204      LIKE rwt_file.rwt204,
           rwt205_desc LIKE type_file.num5,
           rwt205      LIKE rwt_file.rwt205,
           rwt206_desc LIKE type_file.num5,
           rwt206      LIKE rwt_file.rwt206,
           rwt207_desc LIKE type_file.num5,
           rwt207      LIKE rwt_file.rwt207,
           rwt208_desc LIKE type_file.num5,
           rwt208      LIKE rwt_file.rwt208,
           rwt209_desc LIKE type_file.num5,
           rwt209      LIKE rwt_file.rwt209,
           rwt210_desc LIKE type_file.num5,
           rwt210      LIKE rwt_file.rwt210,
           rwt211_desc LIKE type_file.num5,
           rwt211      LIKE rwt_file.rwt211,
           rwt212_desc LIKE type_file.num5,
           rwt212      LIKE rwt_file.rwt212
                     END RECORD,
       g_rwu         DYNAMIC ARRAY OF RECORD
           rwu03     LIKE rwu_file.rwu03,
           gen02     LIKE gen_file.gen02,
           rwu02     LIKE rwu_file.rwu02,
           rwu201_desc LIKE type_file.num5,
           rwu201      LIKE rwu_file.rwu201,
           rwu202_desc LIKE type_file.num5,
           rwu202      LIKE rwu_file.rwu202,
           rwu203_desc LIKE type_file.num5,
           rwu203      LIKE rwu_file.rwu203,
           rwu204_desc LIKE type_file.num5,
           rwu204      LIKE rwu_file.rwu204,
           rwu205_desc LIKE type_file.num5,
           rwu205      LIKE rwu_file.rwu205,
           rwu206_desc LIKE type_file.num5,
           rwu206      LIKE rwu_file.rwu206,
           rwu207_desc LIKE type_file.num5,
           rwu207      LIKE rwu_file.rwu207,
           rwu208_desc LIKE type_file.num5,
           rwu208      LIKE rwu_file.rwu208,
           rwu209_desc LIKE type_file.num5,
           rwu209      LIKE rwu_file.rwu209,
           rwu210_desc LIKE type_file.num5,
           rwu210      LIKE rwu_file.rwu210,
           rwu211_desc LIKE type_file.num5,
           rwu211      LIKE rwu_file.rwu211,
           rwu212_desc LIKE type_file.num5,
           rwu212      LIKE rwu_file.rwu212
                     END RECORD,
       g_rwu_t       RECORD                
           rwu03     LIKE rwu_file.rwu03,
           gen02     LIKE gen_file.gen02,
           rwu02     LIKE rwu_file.rwu02,
           rwu201_desc LIKE type_file.num5,
           rwu201      LIKE rwu_file.rwu201,
           rwu202_desc LIKE type_file.num5,
           rwu202      LIKE rwu_file.rwu202,
           rwu203_desc LIKE type_file.num5,
           rwu203      LIKE rwu_file.rwu203,
           rwu204_desc LIKE type_file.num5,
           rwu204      LIKE rwu_file.rwu204,
           rwu205_desc LIKE type_file.num5,
           rwu205      LIKE rwu_file.rwu205,
           rwu206_desc LIKE type_file.num5,
           rwu206      LIKE rwu_file.rwu206,
           rwu207_desc LIKE type_file.num5,
           rwu207      LIKE rwu_file.rwu207,
           rwu208_desc LIKE type_file.num5,
           rwu208      LIKE rwu_file.rwu208,
           rwu209_desc LIKE type_file.num5,
           rwu209      LIKE rwu_file.rwu209,
           rwu210_desc LIKE type_file.num5,
           rwu210      LIKE rwu_file.rwu210,
           rwu211_desc LIKE type_file.num5,
           rwu211      LIKE rwu_file.rwu211,
           rwu212_desc LIKE type_file.num5,
           rwu212      LIKE rwu_file.rwu212
                     END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,
       g_wc1         STRING,
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,
       g_rec_b2      LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac2         LIKE type_file.num5  
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10    
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_azw07_n           LIKE type_file.num5
DEFINE g_chs               LIKE type_file.chr1
DEFINE g_replace           LIKE type_file.num20_6

MAIN
   DEFINE l_time   LIKE type_file.chr8


   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF


   #CALL cl_used(g_prog,l_time,1) RETURNING l_time       #FUN-B80085--mark--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #FUN-B80085--add--

   OPEN WINDOW q140_w WITH FORM "art/42f/artq140"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_azw07_n = 0
   SELECT COUNT(*) INTO g_azw07_n FROM azw_file WHERE azw07 = g_plant
   IF g_azw07_n > 0 THEN
      CALL cl_set_comp_visible("Page2",TRUE)
      CALL cl_set_comp_visible("Page3",FALSE)
   ELSE
      CALL cl_set_comp_visible("Page2",FALSE)
      CALL cl_set_comp_visible("Page3",TRUE)
   END IF

   LET g_action_choice = ""
   CALL q140_menu()
   CLOSE WINDOW q140_w

   #CALL cl_used(g_prog,l_time,2) RETURNING l_time        #FUN-B80085--mark--
    CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80085--add--

END MAIN

FUNCTION q140_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE  l_wc        STRING

   CLEAR FORM 
   CALL g_rwt1.clear()
   CALL g_rwt2.clear()
   CALL g_rwu.clear()

   INITIALIZE g_wc,g_wc1,l_wc TO NULL
  
   CONSTRUCT g_wc ON rwt01,rwt02,rwt_p,rwt201,rwt202,rwt203,rwt204,rwt205,
                     rwt206,rwt207,rwt208,rwt209,rwt210,rwt211,rwt212
        FROM s_rwt1[1].rwt01,s_rwt1[1].rwt02,s_rwt1[1].rwt_p,
             s_rwt1[1].rwt201,s_rwt1[1].rwt202,s_rwt1[1].rwt203,
             s_rwt1[1].rwt204,s_rwt1[1].rwt205,s_rwt1[1].rwt206,
             s_rwt1[1].rwt207,s_rwt1[1].rwt208,s_rwt1[1].rwt209,
             s_rwt1[1].rwt210,s_rwt1[1].rwt211,s_rwt1[1].rwt212

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER CONSTRUCT
         LET l_wc = GET_FLDBUF(rwt_p)

      ON ACTION controlp
         CASE
            WHEN INFIELD(rwt01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where = "azw01 IN",g_auth
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rwt01
               NEXT FIELD rwt01
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

   END CONSTRUCT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_wc = g_wc CLIPPED
   CALL cl_replace_str(g_wc,"AND","and") RETURNING g_wc
   IF NOT cl_null(l_wc) THEN
      LET l_wc = g_wc.subString(1,g_wc.getIndexOf('rwt_p',1)-1)
      LET g_wc1 = g_wc.subString(g_wc.getIndexOf('rwt_p',1),g_wc.getLength())
      IF g_wc1.getIndexOf('and',1) THEN
         LET g_wc = l_wc,g_wc1.subString(g_wc1.getIndexOf('and',1)+3,g_wc1.getLength())
      ELSE
         LET g_wc = l_wc," 1=1"
      END IF
      IF g_wc1.getIndexOf('and',1) THEN
         LET g_wc1 = g_wc1.subString(1,g_wc1.getIndexOf('and',1)-1)
      ELSE
         LET g_wc1 = g_wc1
      END IF
   END IF

   LET g_wc1 = g_wc1 CLIPPED

   IF cl_null(g_wc) THEN
      LET g_wc = "1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1 = "1=1"
   END IF
   LET l_ac  = 1
   LET l_ac1 = 1
   LET l_ac2 = 1

   CALL q140_ins_temp()
   CALL q140_b1_fill()
   CALL q140_b2_fill()
   CALL q140_b3_fill()

END FUNCTION

FUNCTION q140_menu()
DEFINE l_azw07  LIKE azw_file.azw07
DEFINE l_n      LIKE type_file.num5

   WHILE TRUE
      CALL q140_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q140_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rwt1),base.TypeInfo.create(g_rwt2),base.TypeInfo.create(g_rwu))
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q140_q()

   CALL q140_b_askkey()

END FUNCTION

FUNCTION q140_ins_temp()
DEFINE l_rwt  RECORD
      rwt01   LIKE rwt_file.rwt01,
      rwt02   LIKE rwt_file.rwt02,
      rwt_p   LIKE type_file.num5,
      rwt201  LIKE rwt_file.rwt201,
      rwt202  LIKE rwt_file.rwt202,
      rwt203  LIKE rwt_file.rwt203,
      rwt204  LIKE rwt_file.rwt204,
      rwt205  LIKE rwt_file.rwt205,
      rwt206  LIKE rwt_file.rwt206,
      rwt207  LIKE rwt_file.rwt207,
      rwt208  LIKE rwt_file.rwt208,
      rwt209  LIKE rwt_file.rwt209,
      rwt210  LIKE rwt_file.rwt210,
      rwt211  LIKE rwt_file.rwt211,
      rwt212  LIKE rwt_file.rwt212
              END RECORD
DEFINE l_rwt_sum1   LIKE rwt_file.rwt201
DEFINE l_rwt_sum2   LIKE rwt_file.rwt201
              
   DROP TABLE q140_rwt_temp
   CREATE TEMP TABLE q140_rwt_temp(
      rwt01   LIKE rwt_file.rwt01,
      rwt02   LIKE rwt_file.rwt02,
      rwt_p   LIKE type_file.num5,
      rwt201  LIKE rwt_file.rwt201,
      rwt202  LIKE rwt_file.rwt202,
      rwt203  LIKE rwt_file.rwt203,
      rwt204  LIKE rwt_file.rwt204,
      rwt205  LIKE rwt_file.rwt205,
      rwt206  LIKE rwt_file.rwt206,
      rwt207  LIKE rwt_file.rwt207,
      rwt208  LIKE rwt_file.rwt208,
      rwt209  LIKE rwt_file.rwt209,
      rwt210  LIKE rwt_file.rwt210,
      rwt211  LIKE rwt_file.rwt211,
      rwt212  LIKE rwt_file.rwt212)

   LET g_sql = "SELECT rwt01,rwt02,'',rwt201,rwt202,  ",
               "       rwt203,rwt204,rwt205,rwt206,",
               "       rwt207,rwt208,rwt209,rwt210,",
               "       rwt211,rwt212",
               "  FROM rwt_file",
               " WHERE ",g_wc CLIPPED,
               "   AND rwt01 IN ",g_auth,
               " ORDER BY rwt01"
   PREPARE sel_rwt_pre FROM g_sql
   DECLARE sel_rwt_cs CURSOR FOR sel_rwt_pre
   INITIALIZE l_rwt.* TO NULL

   FOREACH sel_rwt_cs INTO l_rwt.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rwt_sum1 = l_rwt.rwt201 + l_rwt.rwt202 + l_rwt.rwt203 + l_rwt.rwt204 + 
                       l_rwt.rwt205 + l_rwt.rwt206 + l_rwt.rwt207 + l_rwt.rwt208 + 
                       l_rwt.rwt209 + l_rwt.rwt210 + l_rwt.rwt211 + l_rwt.rwt212
      IF cl_null(l_rwt_sum1) THEN LET l_rwt_sum1 = 0 END IF
      SELECT COUNT(*) INTO g_azw07_n FROM azw_file WHERE azw07 = l_rwt.rwt01 AND azwacti = 'Y'
      IF g_azw07_n > 0 THEN
         SELECT SUM(rwt201) + SUM(rwt202) + SUM(rwt203) + SUM(rwt204) + 
                SUM(rwt205) + SUM(rwt206) + SUM(rwt207) + SUM(rwt208) + 
                SUM(rwt209) + SUM(rwt210) + SUM(rwt211) + SUM(rwt212)
           INTO l_rwt_sum2
           FROM rwt_file 
          WHERE rwt04 = l_rwt.rwt01
            AND rwt02 = l_rwt.rwt02
      ELSE
         SELECT SUM(rwu201) + SUM(rwu202) + SUM(rwu203) + SUM(rwu204) + 
                SUM(rwu205) + SUM(rwu206) + SUM(rwu207) + SUM(rwu208) + 
                SUM(rwu209) + SUM(rwu210) + SUM(rwu211) + SUM(rwu212)
           INTO l_rwt_sum2
           FROM rwu_file 
          WHERE rwu01 = l_rwt.rwt01
            AND rwu02 = l_rwt.rwt02
      END IF
      IF cl_null(l_rwt_sum2) THEN LET l_rwt_sum2 = 0 END IF
      LET l_rwt.rwt_p = cl_digcut(l_rwt_sum2/l_rwt_sum1*100,0)
      INSERT INTO q140_rwt_temp VALUES(l_rwt.*)
      INITIALIZE l_rwt.* TO NULL
   END FOREACH

END FUNCTION

FUNCTION q140_b1_fill()

   LET g_sql = "SELECT rwt01,'',rwt02,rwt_p,rwt201,rwt202,",
               "       rwt203,rwt204,rwt205,rwt206,",
               "       rwt207,rwt208,rwt209,rwt210,",
               "       rwt211,rwt212",
               "  FROM q140_rwt_temp",
               " WHERE ",g_wc1 CLIPPED
               
   LET g_sql=g_sql CLIPPED," ORDER BY rwt01 "
   DISPLAY g_sql

   PREPARE sel_rwt_pre1 FROM g_sql
   DECLARE sel_rwt_cs1 CURSOR FOR sel_rwt_pre1

   CALL g_rwt1.clear()
   LET g_cnt = 1

   FOREACH sel_rwt_cs1 INTO g_rwt1[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azw08 INTO g_rwt1[g_cnt].azw08 FROM azw_file 
        WHERE azw01 = g_rwt1[g_cnt].rwt01 AND azwacti = 'Y'
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rwt1.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0

END FUNCTION

FUNCTION q140_b2_fill()

   LET g_sql = "SELECT rwt01,'',rwt02,'',rwt201,'',rwt202,'',rwt203,'',",
               "       rwt204,'',rwt205,'',rwt206,'',rwt207,'',",
               "       rwt208,'',rwt209,'',rwt210,'',rwt211,'',rwt212",
               "  FROM rwt_file",
               " WHERE rwt04 = '",g_rwt1[l_ac].rwt01,"' ",
               "   AND rwt02 = '",g_rwt1[l_ac].rwt02,"' ",
               " ORDER BY rwt01"
   DISPLAY g_sql

   PREPARE sel_rwt_pre2 FROM g_sql
   DECLARE sel_rwt_cs2 CURSOR FOR sel_rwt_pre2

   CALL g_rwt2.clear()
   LET g_cnt = 1

   FOREACH sel_rwt_cs2 INTO g_rwt2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azw08 INTO g_rwt2[g_cnt].rwt01_desc FROM azw_file
        WHERE azw01 = g_rwt2[g_cnt].rwt01 AND azwacti = 'Y'
       CALL q140_fill_b2(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rwt2.deleteElement(g_cnt)
 
   LET g_rec_b1 = g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION q140_b3_fill()

   LET g_sql = "SELECT rwu03,'',rwu02,'',rwu201,'',rwu202,'',  ",
               "       rwu203,'',rwu204,'',rwu205,'',rwu206,'',",
               "       rwu207,'',rwu208,'',rwu209,'',rwu210,'',",
               "       rwu211,'',rwu212",                      
               "  FROM rwu_file",
               " WHERE rwu01 = '",g_rwt1[l_ac].rwt01,"' ",
               "   AND rwu02 = '",g_rwt1[l_ac].rwt02,"' "
                
   LET g_sql=g_sql CLIPPED," ORDER BY rwu03 "
   DISPLAY g_sql

   PREPARE sel_rwu_pre FROM g_sql
   DECLARE sel_rwu_cs CURSOR FOR sel_rwu_pre

   CALL g_rwu.clear()
   LET g_cnt = 1

   FOREACH sel_rwu_cs INTO g_rwu[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gen02 INTO g_rwu[g_cnt].gen02 FROM gen_file 
        WHERE gen01 = g_rwu[g_cnt].rwu03
          AND genacti = 'Y'
       CALL q140_fill_b3(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rwu.deleteElement(g_cnt)
 
   LET g_rec_b2 = g_cnt-1
   IF g_azw07_n = 0 THEN
      DISPLAY g_rec_b2 TO FORMONLY.cn2
   END IF
   LET g_cnt = 0

END FUNCTION

FUNCTION q140_bp(p_ud)
   DEFINE p_ud LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rwt1 TO s_rwt1.* ATTRIBUTE(COUNT=g_rec_b)


         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL q140_azw07()
            CALL q140_b2_fill()
            CALL q140_b3_fill()
            CALL cl_show_fld_cont()

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE     
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"            
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

         AFTER DISPLAY
            CONTINUE DIALOG


         ON ACTION controls                                    
            CALL cl_set_head_visible("","AUTO")   

      END DISPLAY

      DISPLAY ARRAY g_rwt2 TO s_rwt2.* ATTRIBUTE(COUNT=g_rec_b1)


         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE     
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"            
            LET INT_FLAG=FALSE            
            LET g_action_choice="exit"            
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about    
            CALL cl_about()  

         AFTER DISPLAY
            CONTINUE DIALOG


         ON ACTION controls                                    
            CALL cl_set_head_visible("","AUTO")   

      END DISPLAY
      
      DISPLAY ARRAY g_rwu TO s_rwu.* ATTRIBUTE(COUNT=g_rec_b2)


         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE     
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"            
            LET INT_FLAG=FALSE            
            LET g_action_choice="exit"            
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about    
            CALL cl_about()  

         AFTER DISPLAY
            CONTINUE DIALOG


         ON ACTION controls                                    
            CALL cl_set_head_visible("","AUTO")   

      END DISPLAY

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q140_azw07()

   LET g_azw07_n = 0
   SELECT COUNT(*) INTO g_azw07_n 
     FROM azw_file 
    WHERE azw07 = g_rwt1[l_ac].rwt01
      AND azwacti = 'Y'
   IF g_azw07_n > 0 THEN
      CALL cl_set_comp_visible("Page2",TRUE)
      CALL cl_set_comp_visible("Page3",FALSE)
   ELSE
      CALL cl_set_comp_visible("Page3",TRUE)
      CALL cl_set_comp_visible("Page2",FALSE)
   END IF 
END FUNCTION

FUNCTION q140_fill_b2(p_num)
DEFINE l_i     LIKE type_file.num5
DEFINE p_num   LIKE type_file.num5

   FOR l_i = 1 TO 12
      CASE l_i
         WHEN 1
            LET g_replace = g_rwt2[p_num].rwt201/g_rwt1[l_ac].rwt201*100
            LET g_rwt2[p_num].rwt201_desc = cl_digcut(g_replace,0)
         WHEN 2
            LET g_replace = g_rwt2[p_num].rwt202/g_rwt1[l_ac].rwt202*100
            LET g_rwt2[p_num].rwt202_desc = cl_digcut(g_replace,0)
         WHEN 3
            LET g_replace = g_rwt2[p_num].rwt203/g_rwt1[l_ac].rwt203*100
            LET g_rwt2[p_num].rwt203_desc = cl_digcut(g_replace,0)
         WHEN 4
            LET g_replace = g_rwt2[p_num].rwt204/g_rwt1[l_ac].rwt204*100
            LET g_rwt2[p_num].rwt204_desc = cl_digcut(g_replace,0)
         WHEN 5
            LET g_replace = g_rwt2[p_num].rwt205/g_rwt1[l_ac].rwt205*100
            LET g_rwt2[p_num].rwt205_desc = cl_digcut(g_replace,0)
         WHEN 6
            LET g_replace = g_rwt2[p_num].rwt206/g_rwt1[l_ac].rwt206*100
            LET g_rwt2[p_num].rwt206_desc = cl_digcut(g_replace,0)
         WHEN 7
            LET g_replace = g_rwt2[p_num].rwt207/g_rwt1[l_ac].rwt207*100
            LET g_rwt2[p_num].rwt207_desc = cl_digcut(g_replace,0)
         WHEN 8
            LET g_replace = g_rwt2[p_num].rwt208/g_rwt1[l_ac].rwt208*100
            LET g_rwt2[p_num].rwt208_desc = cl_digcut(g_replace,0)
         WHEN 9
            LET g_replace = g_rwt2[p_num].rwt209/g_rwt1[l_ac].rwt209*100
            LET g_rwt2[p_num].rwt209_desc = cl_digcut(g_replace,0)
         WHEN 10
            LET g_replace = g_rwt2[p_num].rwt210/g_rwt1[l_ac].rwt210*100
            LET g_rwt2[p_num].rwt210_desc = cl_digcut(g_replace,0)
         WHEN 11
            LET g_replace = g_rwt2[p_num].rwt211/g_rwt1[l_ac].rwt211*100
            LET g_rwt2[p_num].rwt211_desc = cl_digcut(g_replace,0)
         WHEN 12
            LET g_replace = g_rwt2[p_num].rwt212/g_rwt1[l_ac].rwt212*100
            LET g_rwt2[p_num].rwt212_desc = cl_digcut(g_replace,0)
      END CASE
   END FOR
END FUNCTION

FUNCTION q140_fill_b3(p_num)
DEFINE l_i     LIKE type_file.num5
DEFINE p_num   LIKE type_file.num5

   FOR l_i = 1 TO 12
      CASE l_i
         WHEN 1
            LET g_replace = g_rwu[p_num].rwu201/g_rwt1[l_ac].rwt201*100
            LET g_rwu[p_num].rwu201_desc = cl_digcut(g_replace,0)
         WHEN 2
            LET g_replace = g_rwu[p_num].rwu202/g_rwt1[l_ac].rwt202*100
            LET g_rwu[p_num].rwu202_desc = cl_digcut(g_replace,0)
         WHEN 3
            LET g_replace = g_rwu[p_num].rwu203/g_rwt1[l_ac].rwt203*100
            LET g_rwu[p_num].rwu203_desc = cl_digcut(g_replace,0)
         WHEN 4
            LET g_replace = g_rwu[p_num].rwu204/g_rwt1[l_ac].rwt204*100
            LET g_rwu[p_num].rwu204_desc = cl_digcut(g_replace,0)
         WHEN 5
            LET g_replace = g_rwu[p_num].rwu205/g_rwt1[l_ac].rwt205*100
            LET g_rwu[p_num].rwu205_desc = cl_digcut(g_replace,0)
         WHEN 6
            LET g_replace = g_rwu[p_num].rwu206/g_rwt1[l_ac].rwt206*100
            LET g_rwu[p_num].rwu206_desc = cl_digcut(g_replace,0)
         WHEN 7
            LET g_replace = g_rwu[p_num].rwu207/g_rwt1[l_ac].rwt207*100
            LET g_rwu[p_num].rwu207_desc = cl_digcut(g_replace,0)
         WHEN 8
            LET g_replace = g_rwu[p_num].rwu208/g_rwt1[l_ac].rwt208*100
            LET g_rwu[p_num].rwu208_desc = cl_digcut(g_replace,0)
         WHEN 9
            LET g_replace = g_rwu[p_num].rwu209/g_rwt1[l_ac].rwt209*100
            LET g_rwu[p_num].rwu209_desc = cl_digcut(g_replace,0)
         WHEN 10
            LET g_replace = g_rwu[p_num].rwu210/g_rwt1[l_ac].rwt210*100
            LET g_rwu[p_num].rwu210_desc = cl_digcut(g_replace,0)
         WHEN 11
            LET g_replace = g_rwu[p_num].rwu211/g_rwt1[l_ac].rwt211*100
            LET g_rwu[p_num].rwu211_desc = cl_digcut(g_replace,0)
         WHEN 12
            LET g_replace = g_rwu[p_num].rwu212/g_rwt1[l_ac].rwt212*100
            LET g_rwu[p_num].rwu212_desc = cl_digcut(g_replace,0)
      END CASE
   END FOR
END FUNCTION


#FUN-B50067 ADD
