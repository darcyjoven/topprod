# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: gglt503.4gl
# Descriptions...: 合併直接法項目調整作業
# Date & Author..: 2011/03/24 By zhangweib
# Modify.........: NO.FUN-B40104 11/05/05 By jll   合并报表作业
# Modify.........: NO.TQC-B70103 11/07/18 By yinhy 查詢時，合并帳套和最上層公司位置錯了
# Modify.........: No.FUN-B80135 11/08/22 By lujh  相關日期欄位不可小於關帳日期
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C50111 12/05/14 By xuxz 總筆數顯示異常
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037

DEFINE g_ati      RECORD
       ati01      LIKE ati_file.ati01,
       ati02      LIKE ati_file.ati02,
       ati03      LIKE ati_file.ati03
                  END RECORD
DEFINE g_ati_t    RECORD
       ati01      LIKE ati_file.ati01,
       ati02      LIKE ati_file.ati02,
       ati03      LIKE ati_file.ati03
                  END RECORD
DEFINE g_ati_b    DYNAMIC ARRAY OF RECORD
       ati04      LIKE ati_file.ati04,
       ati05      LIKE ati_file.ati05,
       ati05_1    LIKE nml_file.nml02,
       ati06      LIKE ati_file.ati06,
       ati07      LIKE ati_file.ati07,
       ati08      LIKE ati_file.ati08,
       ati09      LIKE ati_file.ati09
                  END RECORD
DEFINE g_ati_b_t RECORD
       ati04      LIKE ati_file.ati04,
       ati05      LIKE ati_file.ati05,
       ati05_1    LIKE nml_file.nml02,
       ati06      LIKE ati_file.ati06,
       ati07      LIKE ati_file.ati07,
       ati08      LIKE ati_file.ati08,
       ati09      LIKE ati_file.ati09
                  END RECORD
DEFINE p_cmd      LIKE type_file.chr1 
DEFINE l_table    STRING 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE g_rec_b    LIKE type_file.num10
DEFINE g_wc       STRING 
DEFINE l_ac       LIKE type_file.num5
DEFINE g_sql_tmp  STRING

DEFINE g_forupd_sql    STRING 
DEFINE g_cnt           LIKE type_file.num10    
DEFINE g_i             LIKE type_file.num5    
DEFINE g_msg           LIKE ze_file.ze03     
DEFINE g_row_count     LIKE type_file.num10 
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10 
DEFINE mi_no_ask       LIKE type_file.num5 
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_dbs_asg03     LIKE asg_file.asg03   #TQC-B70103
DEFINE g_aaa07         LIKE aaa_file.aaa07   #No.FUN-B80135
DEFINE g_year          LIKE type_file.chr4   #No.FUN-B80135
DEFINE g_month         LIKE type_file.chr2   #No.FUN-B80135

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

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end
   
   OPEN WINDOW gglt503 WITH FORM "ggl/42f/gglt503" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t020_menu()                                                            
   CLOSE WINDOW gglt503 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t020_cs()
   CLEAR FORM  
   CALL g_ati_b.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON ati01,ati02,ati03,ati04,ati05,ati06,ati07,ati08,ati09
                FROM ati01,ati02,ati03,s_ati1[1].ati04,s_ati1[1].ati05,
                     s_ati1[1].ati06,s_ati1[1].ati07,s_ati1[1].ati08,
                     s_ati1[1].ati09

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp 
         CASE
          WHEN INFIELD(ati01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_atd01"                                                                               
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ati01                                                                             
             NEXT FIELD ati01
          WHEN INFIELD(ati04)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_asg"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ati04           
             NEXT FIELD ati04
          WHEN INFIELD(ati05)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_nml"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ati05
             NEXT FIELD ati05
          WHEN INFIELD(ati08)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_asg"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ati08           
             NEXT FIELD ati08
          OTHERWISE
             EXIT CASE
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
   LET g_sql="SELECT UNIQUE ati01,ati02,ati03 FROM ati_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY ati01,ati02,ati03 "
   PREPARE t020_prepare FROM g_sql 
   DECLARE t020_b_cs
       SCROLL CURSOR WITH HOLD FOR t020_prepare

   LET g_sql_tmp= "SELECT UNIQUE ati01,ati02,ati03 FROM ati_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE t020_pre_x FROM g_sql_tmp
   EXECUTE t020_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE t020_precount FROM g_sql
   DECLARE t020_count CURSOR FOR t020_precount
END FUNCTION

FUNCTION t020_menu()
   WHILE TRUE
      CALL t020_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t020_a()
            END IF
     #   WHEN "modify"
     #      IF cl_chk_act_auth() THEN
     #         CALL t020_u()
     #      END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t020_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t020_q() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL t020_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION t020_a()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000, 
          l_n            LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF   
   MESSAGE ""
   INITIALIZE g_ati.* TO NULL 
   CLEAR FORM
   CALL g_ati_b.clear()
   CALL cl_opmsg('a')
   
   WHILE TRUE
      CALL t020_i("a")  
      IF INT_FLAG THEN    
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_ati_b.clear()
      SELECT COUNT(*) INTO l_n FROM ati_file WHERE ati01 = g_ati.ati01
                                               AND ati02 = g_ati.ati02 
                                               AND ati03 = g_ati.ati03
      LET g_rec_b = 0
      IF l_n > 0 THEN
         CALL t020_b_fill('1=1')
      END IF
      CALL t020_b()
     
 
      LET g_ati_t.ati01 = g_ati.ati01
      LET g_ati_t.ati02 = g_ati.ati02
      LET g_ati_t.ati03 = g_ati.ati03

      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t020_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,  
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,      
   l_asa02         LIKE asa_file.asa02,
   l_asa03         LIKE asa_file.asa03

   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ati.ati01,g_ati.ati02,g_ati.ati03 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t020_set_entry(p_cmd)
         CALL t020_set_no_entry(p_cmd)
         CALL cl_qbe_init()

 
      AFTER FIELD ati01
         IF NOT cl_null(g_ati.ati01) THEN
            SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = g_ati.ati01 AND asa04 = 'Y'
            IF l_n = 0 THEN
               CALL cl_err(g_ati.ati01,100,0)
               NEXT FIELD ati01
            END IF
            SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_ati.ati01 AND asa04 = 'Y'
         ELSE
            LET l_asa02 = NULL
            LET l_asa03 = NULL
         END IF
         DISPLAY l_asa02 TO FORMONLY.ati01_2
         DISPLAY l_asa03 TO FORMONLY.ati01_1

      AFTER FIELD ati02
         IF NOT cl_null(g_ati.ati02) THEN
            IF g_ati.ati02 < 0 THEN
               CALL cl_err(g_ati.ati02,'afa-370',0)
               NEXT FIELD ati02
            END IF
            #No.FUN-B80135--add--str--
            IF g_ati.ati02<g_year THEN
               CALL cl_err(g_ati.ati02,'atp-164',0)
               NEXT FIELD ati02
            ELSE
               IF g_ati.ati02=g_year AND g_ati.ati03<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD ati03
               END IF
            END IF 
            #No.FUN-B80135--add--end
         END IF

      AFTER FIELD ati03
         IF NOT cl_null(g_ati.ati03) THEN
            IF g_ati.ati03 < 0 OR g_ati.ati03 > 12 THEN
               CALL cl_err(g_ati.ati03,'agl-020',0)
               NEXT FIELD ati03
            END IF 
            #FUN-B80135--add--str--
            IF NOT cl_null(g_ati.ati02) AND g_ati.ati02=g_year 
               AND g_ati.ati03<=g_month THEN
               CALL cl_err('','atp-164',0)
               NEXT FIELD ati03
            END IF 
            #FUN-B80135--add--end
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(ati01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_ati.ati01 
               CALL cl_create_qry() RETURNING g_ati.ati01 
               DISPLAY BY NAME g_ati.ati01
               NEXT FIELD ati01
            END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()    
 
      ON ACTION help    
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
END FUNCTION

FUNCTION t020_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ati.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t020_cs()
   IF INT_FLAG THEN  
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t020_b_cs    
   IF SQLCA.sqlcode THEN  
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ati.* TO NULL
   ELSE
      CALL t020_fetch('F') 
      OPEN t020_count
      FETCH t020_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION t020_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t020_b_cs INTO g_ati.ati01,g_ati.ati02,g_ati.ati03
       WHEN 'P' FETCH PREVIOUS t020_b_cs INTO g_ati.ati01,g_ati.ati02,g_ati.ati03
       WHEN 'F' FETCH FIRST    t020_b_cs INTO g_ati.ati01,g_ati.ati02,g_ati.ati03
       WHEN 'L' FETCH LAST     t020_b_cs INTO g_ati.ati01,g_ati.ati02,g_ati.ati03
       WHEN '/'
            IF (NOT mi_no_ask) THEN
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

            FETCH ABSOLUTE g_jump t020_b_cs INTO g_ati.ati01,g_ati.ati02,g_ati.ati03
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ati.ati01,SQLCA.sqlcode,0)   
      INITIALIZE g_ati.* TO NULL 
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

   CALL t020_show()
END FUNCTION

FUNCTION t020_show()
DEFINE l_asa02    LIKE asa_file.asa02
DEFINE l_asa03    LIKE asa_file.asa03
DEFINE g_asz01    LIKE asz_file.asz01  #TQC-B70103
   SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_ati.ati01 AND asa04 = 'Y'
   #No.TQC-B70103 --Beatk
   #DISPLAY l_asa02 TO FORMONLY.ati01_1
   #DISPLAY l_asa03 TO FORMONLY.ati01_2
   CALL s_aaz641_asg(g_ati.ati01,l_asa02) RETURNING g_dbs_asg03
   CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
   DISPLAY l_asa02 TO FORMONLY.ati01_2 
   DISPLAY g_asz01 TO FORMONLY.ati01_1  
   #No.TQC-B70103 --Beatk
   DISPLAY BY NAME g_ati.*              

   CALL t020_b_fill(g_wc)  
   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION t020_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    
   l_n             LIKE type_file.num5,   
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1, 
   p_cmd           LIKE type_file.chr1,    
   l_ati_delyn     LIKE type_file.chr1,  
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,       
   l_allow_delete  LIKE type_file.num5   

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF 
   IF cl_null(g_ati.ati01) OR cl_null(g_ati.ati02) OR cl_null(g_ati.ati03) THEN
       RETURN
   END IF

   CALL cl_opmsg('b') 

   LET g_forupd_sql = "SELECT ati04,ati05,'',ati06,ati07,ati08,ati09 FROM ati_file",
                      " WHERE ati01 = ? AND ati02 = ? AND ati03 = ? ",
                      "   AND ati04 = ? AND ati05 = ? AND ati06 = ? ",
                      "   AND ati08 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE t020_bcl CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ati_b WITHOUT DEFAULTS FROM s_ati1.*
      ATTRIBUTE (COUNT = g_rec_b,MAXCOUNT = g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N' 
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL t020_set_entry(p_cmd)
            CALL t020_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_ati_b_t.* = g_ati_b[l_ac].*
            OPEN t020_bcl USING g_ati.ati01,g_ati.ati02,g_ati.ati03,
                                g_ati_b[l_ac].ati04,g_ati_b[l_ac].ati05,
                                g_ati_b[l_ac].ati06,g_ati_b[l_ac].ati08
            IF STATUS THEN
               CALL cl_err("OPEN t020_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t020_bcl INTO g_ati_b[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ati_b_t.ati04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02 INTO g_ati_b[l_ac].ati05_1 FROM nml_file 
                WHERE nml01 = g_ati_b[l_ac].ati05
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ati_b[l_ac].* TO NULL
         LET g_ati_b_t.* = g_ati_b[l_ac].* 
         LET  g_before_input_done = FALSE
         CALL t020_set_entry(p_cmd)
         LET  g_before_input_done = TRUE
         CALL cl_show_fld_cont() 
         NEXT FIELD ati04

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t020_bcl
         END IF
         INSERT INTO ati_file 
            VALUES(g_ati.ati01,g_ati.ati02,g_ati.ati03,g_ati_b[l_ac].ati04,
                   g_ati_b[l_ac].ati05,g_ati_b[l_ac].ati06,
                   g_ati_b[l_ac].ati07,g_ati_b[l_ac].ati08,g_ati_b[l_ac].ati09,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ati_file",g_ati_b[l_ac].ati04,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD ati04
         IF (cl_null(g_ati_b_t.ati04) OR g_ati_b[l_ac].ati04 != g_ati_b_t.ati04) 
                         AND NOT cl_null(g_ati_b[l_ac].ati04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asg_file WHERE asg01 = g_ati_b[l_ac].ati04
            IF l_n = 0 THEN
               CALL cl_err(g_ati_b[l_ac].ati04,100,0)
               NEXT FIELD ati04
            END IF
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_ati_b[l_ac].ati04 = g_ati_b_t.ati04
               CALL cl_err('','-239',0)
               NEXT FIELD ati04
            END IF
         END IF          

      AFTER FIELD ati05
         IF NOT cl_null(g_ati_b[l_ac].ati05) THEN
            LET l_n = 0
            SELECT COUNT(nml01) INTO l_n FROM nml_file WHERE nml01 = g_ati_b[l_ac].ati05
            IF l_n < 1 THEN
              CALL cl_err(g_ati_b[l_ac].ati05,'',1)
              NEXT FIELD ati05
            ELSE 
               LET l_n = 0
               CALL t020_check(l_ac) RETURNING l_n
               IF l_n <> 0 THEN
                  LET g_ati_b[l_ac].ati05 = g_ati_b_t.ati05
                  CALL cl_err('','-239',0)
                  NEXT FIELD ati05
               END IF
               SELECT nml02 INTO g_ati_b[l_ac].ati05_1 FROM nml_file
                WHERE nml01 = g_ati_b[l_ac].ati05
            END IF 
         ELSE
            LET g_ati_b[l_ac].ati05_1 = NULL
         END IF
         DISPLAY g_ati_b[l_ac].ati05_1 TO ati05_1

      AFTER FIELD ati06
         IF NOT cl_null(g_ati_b[l_ac].ati06) THEN
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_ati_b[l_ac].ati06 = g_ati_b_t.ati06
               CALL cl_err('','-239',0)
               NEXT FIELD ati06
            END IF
         END IF


      AFTER FIELD ati07
         IF NOT cl_null(g_ati_b[l_ac].ati07) THEN
            IF g_ati_b[l_ac].ati07 < 0 THEN
               CALL cl_err(g_ati_b[l_ac].ati07,'',1)
               NEXT FIELD ati07
            END IF
         END IF 

      AFTER FIELD ati08
         IF (cl_null(g_ati_b_t.ati08) OR g_ati_b[l_ac].ati08 != g_ati_b_t.ati08)
                         AND NOT cl_null(g_ati_b[l_ac].ati08) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asg_file WHERE asg01 = g_ati_b[l_ac].ati08
            IF l_n = 0 THEN
               CALL cl_err(g_ati_b[l_ac].ati08,100,0)
               NEXT FIELD ati08
            END IF
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_ati_b[l_ac].ati08 = g_ati_b_t.ati08
               CALL cl_err('','-239',0)
               NEXT FIELD ati08
            END IF
         END IF
         
      BEFORE DELETE
         IF NOT cl_null(g_ati_b_t.ati04) AND NOT cl_null(g_ati_b_t.ati05) 
            AND NOT cl_null(g_ati_b_t.ati06)AND NOT cl_null(g_ati_b_t.ati08) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ati_file
             WHERE ati01 = g_ati.ati01   
               AND ati02 = g_ati.ati02
               AND ati03 = g_ati.ati03
               AND ati04 = g_ati_b_t.ati04
               AND ati05 = g_ati_b_t.ati05
               AND ati06 = g_ati_b_t.ati06
               AND ati08 = g_ati_b_t.ati08

            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ati_file",g_ati_b_t.ati04,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF NOT cl_null(g_ati_b_t.ati04) AND NOT cl_null(g_ati_b_t.ati05) 
            AND NOT cl_null(g_ati_b_t.ati06) AND NOT cl_null(g_ati_b_t.ati08) THEN 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ati_b[l_ac].ati04,-263,1)
               LET g_ati_b[l_ac].* = g_ati_b_t.*
            ELSE
               UPDATE ati_file SET ati07 = g_ati_b[l_ac].ati07,
                                   ati09 = g_ati_b[l_ac].ati09
                WHERE ati01 = g_ati.ati01 AND ati02 = g_ati.ati02
                  AND ati03 = g_ati.ati03 AND ati04 = g_ati_b_t.ati04
                  AND ati05 = g_ati_b_t.ati05 AND ati06 = g_ati_b_t.ati06
                  AND ati08 = g_ati_b_t.ati08
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ati_file",g_ati.ati01,g_ati.ati02,SQLCA.sqlcode,"","",1)
                  LET g_ati_b[l_ac].* = g_ati_b_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #FUN-D30032--mark&add--str--
        #LET l_ac_t = l_ac
        #IF p_cmd = 'u' THEN
        #   CLOSE t020_bcl
        #END IF
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ati_b[l_ac].* = g_ati_b_t.*
            ELSE
               CALL g_ati_b.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t020_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE t020_bcl 
         COMMIT WORK 
        #FUN-D30032--mark&add--end--

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ati04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_asg"
              LET g_qryparam.default1 = g_ati_b[l_ac].ati04
              CALL cl_create_qry() RETURNING g_ati_b[l_ac].ati04
              NEXT FIELD ati04
            WHEN INFIELD(ati05)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_ati_b[l_ac].ati05
              CALL cl_create_qry() RETURNING g_ati_b[l_ac].ati05
              NEXT FIELD ati05
            WHEN INFIELD(ati08)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_asg"
              LET g_qryparam.default1 = g_ati_b[l_ac].ati08
              CALL cl_create_qry() RETURNING g_ati_b[l_ac].ati08
              NEXT FIELD ati08
            OTHERWISE
              EXIT CASE
         END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about    
         CALL cl_about()  

      ON ACTION help       
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END INPUT

   CLOSE t020_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t020_b_fill(p_wc)  
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,   
   l_sql           STRING       

   LET l_sql = "SELECT ati04,ati05,'',ati06,ati07,ati08,ati09 FROM ati_file ",
               " WHERE ati01 = '",g_ati.ati01,"'",     
               "   AND ati02 = '",g_ati.ati02,"'",
               "   AND ati03 = '",g_ati.ati03,"'",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY ati01,ati02,ati03 "

   PREPARE ati_pre FROM l_sql
   DECLARE ati_cs CURSOR FOR ati_pre

   CALL g_ati_b.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH ati_cs INTO g_ati_b[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT nml02 INTO g_ati_b[g_cnt].ati05_1 FROM nml_file 
       WHERE nml01 = g_ati_b[g_cnt].ati05
      LET l_flag = 'Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ati_b.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b = 0 END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t020_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  

   IF p_cmd='a' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("ati04,ati05,ati06,ati08",TRUE)                               
   END IF
 
END FUNCTION
 
FUNCTION t020_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 

   IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("ati04,ati05,ati06,ati08",FALSE)             
   END IF 
 
END FUNCTION

FUNCTION t020_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ati_b TO s_ati1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION delete 
         LET g_action_choice="delete"
         EXIT DISPLAY  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL t020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL t020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL t020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t020_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ati.ati01) AND cl_null(g_ati.ati02) AND cl_null(g_ati.ati03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM ati_file WHERE ati01 = g_ati.ati01 AND ati02 = g_ati.ati02  
                             AND ati03 = g_ati.ati03                                  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ati_file",g_ati.ati01,'',SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_ati_b.clear()
         OPEN t020_count
         FETCH t020_count INTO g_row_count
         LET g_row_count = g_row_count - 1 
         #TQC-C50111--add--str
         IF g_row_count < 0 THEN 
            LET g_row_count = 0
            COMMIT WORK
            RETURN
         END IF
         #TQC-C50111--add--end
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t020_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t020_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE 
            CALL t020_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

FUNCTION t020_check(l_ac)
DEFINE l_n,l_ac    LIKE type_file.num5

    SELECT COUNT(*) INTO l_n FROM ati_file
             WHERE ati01 = g_ati.ati01 AND ati02 = g_ati.ati02
               AND ati03 = g_ati.ati03 AND ati04 = g_ati_b[l_ac].ati04
               AND ati05 = g_ati_b[l_ac].ati05
               AND ati06 = g_ati_b[l_ac].ati06
               AND ati08 = g_ati_b[l_ac].ati08

   RETURN l_n
END FUNCTION
#NO.FUN-B40104
