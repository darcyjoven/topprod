# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artt612.4gl
# Descriptions...: 待抵單維護作業
# Date & Author..: NO.FUN-BB0117 11/11/23 By xumm
# Modify.........: No:FUN-C20009 12/02/03 By shiwuying 增加栏位luk16
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.FUN-CB0076 12/11/12 By xumeimei 添加GR打印功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_luk            RECORD LIKE luk_file.*,    
       g_luk_t          RECORD LIKE luk_file.*,   
       g_luk01_t        LIKE luk_file.luk01,      
       g_lul            DYNAMIC ARRAY OF RECORD
           lul02        LIKE lul_file.lul02,
           lul03        LIKE lul_file.lul03,
           lul04        LIKE lul_file.lul04,
           lul05        LIKE lul_file.lul05,
           oaj02        LIKE oaj_file.oaj02,
           oaj05        LIKE oaj_file.oaj05,
           lul06        LIKE lul_file.lul06,
           lul07        LIKE lul_file.lul07,
           lul08        LIKE lul_file.lul08,
           amt_1        LIKE lul_file.lul08, 
           oaj04        LIKE oaj_file.oaj04,
           aag02        LIKE aag_file.aag02,
           oaj041       LIKE oaj_file.oaj041,
           aag02_1      LIKE aag_file.aag02
                        END RECORD,
       g_lul_t          RECORD                    
           lul02        LIKE lul_file.lul02,
           lul03        LIKE lul_file.lul03,
           lul04        LIKE lul_file.lul04,
           lul05        LIKE lul_file.lul05,
           oaj02        LIKE oaj_file.oaj02,
           oaj05        LIKE oaj_file.oaj05,
           lul06        LIKE lul_file.lul06,
           lul07        LIKE lul_file.lul07,
           lul08        LIKE lul_file.lul08,
           amt_1        LIKE lul_file.lul08, 
           oaj04        LIKE oaj_file.oaj04,
           aag02        LIKE aag_file.aag02,
           oaj041       LIKE oaj_file.oaj041,
           aag02_1      LIKE aag_file.aag02
                        END RECORD
                        
DEFINE g_sql               STRING                       
DEFINE g_wc                STRING                      
DEFINE g_wc2               STRING                     
DEFINE g_rec_b             LIKE type_file.num5       
DEFINE l_ac                LIKE type_file.num5      
DEFINE g_forupd_sql        STRING            
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03  
DEFINE g_curs_index        LIKE type_file.num10 
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5  
DEFINE g_argv1             LIKE luk_file.luk01
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lukplant  LIKE luk_file.lukplant,
    luk01     LIKE luk_file.luk01,
    luk08     LIKE luk_file.luk08,
    luk09     LIKE luk_file.luk09,
    luk06     LIKE luk_file.luk06,
    luk02     LIKE luk_file.luk02,
    luk07     LIKE luk_file.luk07,
    lukcond   LIKE luk_file.lukcond,
    lukcont   LIKE luk_file.lukcont,
    lukconu   LIKE luk_file.lukconu,
    lul02     LIKE lul_file.lul02,
    lul03     LIKE lul_file.lul03,
    lul04     LIKE lul_file.lul04,
    lul05     LIKE lul_file.lul05,
    lul06     LIKE lul_file.lul06,
    lul07     LIKE lul_file.lul07,
    lul08     LIKE lul_file.lul08,
    rtz13     LIKE rtz_file.rtz13,
    occ02     LIKE occ_file.occ02,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    oaj05     LIKE oaj_file.oaj05,
    amt       LIKE lul_file.lul06
END RECORD
#FUN-CB0076----add---end
 
MAIN
   OPTIONS                              
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1=ARG_VAL(1)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="lukplant.luk_file.lukplant,",
    "luk01.luk_file.luk01,",
    "luk08.luk_file.luk08,",
    "luk09.luk_file.luk09,",
    "luk06.luk_file.luk06,",
    "luk02.luk_file.luk02,",
    "luk07.luk_file.luk07,",
    "lukcond.luk_file.lukcond,",
    "lukcont.luk_file.lukcont,",
    "lukconu.luk_file.lukconu,",
    "lul02.lul_file.lul02,",
    "lul03.lul_file.lul03,",
    "lul04.lul_file.lul04,",
    "lul05.lul_file.lul05,",
    "lul06.lul_file.lul06,",
    "lul07.lul_file.lul07,",
    "lul08.lul_file.lul08,",
    "rtz13.rtz_file.rtz13,",
    "occ02.occ_file.occ02,",
    "gen02.gen_file.gen02,",
    "oaj02.oaj_file.oaj02,",
    "oaj05.oaj_file.oaj05,",
    "amt.lul_file.lul06"
   LET l_table = cl_prt_temptable('artt612',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end 

   LET g_forupd_sql = "SELECT * FROM luk_file WHERE luk01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t612_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t612_w WITH FORM "art/42f/artt612"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_set_locale_frm_name("artt612")   
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
       CALL t612_q()
   END IF
   LET g_pdate = g_today   
 
   IF g_aza.aza63 <> 'Y' THEN 
      CALL cl_set_comp_visible("oaj041,aag02_1",FALSE) 
   END IF 
   CALL t612_menu()
   CLOSE WINDOW t612_w               
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN
 
FUNCTION t612_cs()
   CLEAR FORM 
   CALL g_lul.clear()
 
   IF g_wc =' ' THEN
      LET g_wc=' 1=1'
   END IF

   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_luk.* TO NULL     
   IF cl_null(g_argv1) THEN
      DIALOG ATTRIBUTE (UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON luk01,luk02,luk03,luk04,luk05,lukplant,luklegal,luk06,luk07,luk08,
                                luk09,luk10,luk11,luk12,luk13,luk14,luk16,lukconf,lukconu,lukcond,lukcont, #FUN-C20009
                                luk15,lukuser,lukgrup,lukoriu,lukmodu,lukdate,lukorig,lukacti,lukcrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(luk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk01
                  NEXT FIELD luk01

               WHEN INFIELD(luk05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk05"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk05
                  NEXT FIELD luk05
                  
               WHEN INFIELD(lukplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lukplant"
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.default1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lukplant
                  NEXT FIELD lukplant
      
               WHEN INFIELD(luklegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_luklegal"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_legal
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luklegal
                  NEXT FIELD luklegal

                WHEN INFIELD(luk06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk06"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk06
                  NEXT FIELD luk06 

                WHEN INFIELD(luk07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk07"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk07
                  NEXT FIELD luk07

                WHEN INFIELD(luk08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk08"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk08
                  NEXT FIELD luk08

                WHEN INFIELD(luk13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk13"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk13
                  NEXT FIELD luk13

                WHEN INFIELD(luk14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_luk14"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luk14
                  NEXT FIELD luk14
                  
                WHEN INFIELD(lukconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lukconu"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lukconu
                  NEXT FIELD lukconu 
                  
               OTHERWISE EXIT CASE
            END CASE
      
       END CONSTRUCT
 
       CONSTRUCT g_wc2 ON lul02,lul03,lul04,lul05,lul06,lul07,lul08
                     FROM s_lul[1].lul02,s_lul[1].lul03,s_lul[1].lul04,s_lul[1].lul05,
                          s_lul[1].lul06,s_lul[1].lul07,s_lul[1].lul08                
    
            BEFORE CONSTRUCT
      
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(lul03) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_lul03" 
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lul03
                       NEXT FIELD lul03
                       
                  WHEN INFIELD(lul05) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_lul05"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lul05
                       NEXT FIELD lul05
               END CASE
            END CONSTRUCT
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG 

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
    
            ON ACTION close
               LET INT_FLAG=1
               EXIT DIALOG
            
            ON ACTION accept
               EXIT DIALOG
            
            ON ACTION cancel
               LET INT_FLAG=1
               EXIT DIALOG
    
      END DIALOG
   
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF

 
   IF NOT cl_null(g_argv1) THEN
      LET g_sql = "SELECT luk01 FROM luk_file ",
                  " WHERE luk05 = '",g_argv1,"'",
                  " ORDER BY luk01"
   ELSE
      IF g_wc2 = " 1=1" THEN    
         LET g_sql = "SELECT luk01 FROM luk_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY luk01"
      ELSE                     
         LET g_sql = "SELECT UNIQUE luk_file.luk01 ",
                     "  FROM luk_file, lul_file ",
                     " WHERE luk01 = lul01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY luk01"
      END IF
   END IF 

   PREPARE t612_prepare FROM g_sql
   DECLARE t612_cs  SCROLL CURSOR WITH HOLD FOR t612_prepare

   IF NOT cl_null(g_argv1) THEN
      LET g_sql="SELECT COUNT(*) FROM luk_file WHERE luk05 = '",g_argv1,"'" 
   ELSE
      IF g_wc2 = " 1=1" THEN 
         LET g_sql="SELECT COUNT(*) FROM luk_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT luk01) FROM luk_file,lul_file WHERE ",
                   "lul01=luk01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
   END IF 

   PREPARE t612_precount FROM g_sql
   DECLARE t612_count CURSOR FOR t612_precount
 
END FUNCTION
 
FUNCTION t612_menu()
 
   WHILE TRUE
      CALL t612_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t612_q()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lul),'','')
            END IF 
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t612_out()
            END IF
         #FUN-CB0076------add----end

         WHEN "q_source"
            IF cl_chk_act_auth() THEN
               CALL t612_source()
            END IF
                    
         WHEN "q_expend"
            IF cl_chk_act_auth() THEN
               CALL t612_expend()
            END IF
            
         WHEN "related_document" 
              IF cl_chk_act_auth() THEN
                 IF g_luk.luk01 IS NOT NULL THEN
                    LET g_doc.column1 = "luk01"
                    LET g_doc.value1 = g_luk.luk01
                    CALL cl_doc()
                 END IF
             END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t612_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
  
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lul TO s_lul.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      #FUN-CB0076------add-----str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-CB0076------add-----end

      ON ACTION q_source
         LET g_action_choice="q_source"
         EXIT DISPLAY
      
      ON ACTION q_expend
         LET g_action_choice="q_expend"
         EXIT DISPLAY

      ON ACTION first
         CALL t612_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t612_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t612_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t612_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t612_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
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
 
      ON ACTION about        
         CALL cl_about()    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t612_bp_refresh()
   DISPLAY ARRAY g_lul TO s_lul.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
   END DISPLAY
END FUNCTION

FUNCTION t612_desc()
  DEFINE l_rtz13          LIKE rtz_file.rtz13
  DEFINE l_azt02          LIKE azt_file.azt02
  DEFINE l_luk06_desc     LIKE occ_file.occ02
  DEFINE l_gen02          LIKE gen_file.gen02
  DEFINE l_gem02          LIKE gem_file.gem02
  DEFINE l_gen02_1        LIKE gen_file.gen02
  DEFINE l_amt            LIKE luk_file.luk12
   
  SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_luk.lukplant
  SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_luk.luklegal
  SELECT occ02 INTO l_luk06_desc FROM occ_file WHERE occ01 = g_luk.luk06
  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_luk.luk13
  SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_luk.luk14
  SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_luk.lukconu
  LET l_amt = g_luk.luk10 - g_luk.luk11 - g_luk.luk12
  
  DISPLAY l_azt02 TO FORMONLY.azt02
  DISPLAY l_rtz13 TO FORMONLY.rtz13
  DISPLAY l_luk06_desc TO FORMONLY.luk06_desc
  DISPLAY l_gen02 TO FORMONLY.gen02
  DISPLAY l_gem02 TO FORMONLY.gem02
  DISPLAY l_gen02_1 TO FORMONLY.gen02_1
  DISPLAY l_amt TO FORMONLY.amt
  
END FUNCTION

FUNCTION t612_lnt30()
  DEFINE l_lnt30          LIKE lnt_file.lnt30
  DEFINE l_tqa02          LIKE tqa_file.tqa02
  

  SELECT lnt30 INTO l_lnt30 FROM lnt_file WHERE lnt01 = g_luk.luk08
  SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lnt30 AND tqa03 = '2'

  DISPLAY l_lnt30 TO FORMONLY.lnt30
  DISPLAY l_tqa02 TO FORMONLY.tqa02
  
END FUNCTION

FUNCTION t612_lne08()
  DEFINE l_lne08          LIKE lne_file.lne08
  DEFINE l_tqa02          LIKE tqa_file.tqa02

  SELECT lne08 INTO l_lne08 FROM lne_file WHERE lne01 = g_luk.luk06
  SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lne08 AND tqa03 = '2'

  DISPLAY l_lne08 TO FORMONLY.lnt30
  DISPLAY l_tqa02 TO FORMONLY.tqa02
  
END FUNCTION

FUNCTION t612_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lul.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t612_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_luk.* TO NULL
      LET g_luk01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   OPEN t612_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_luk.* TO NULL
      LET g_luk01_t = NULL
      LET g_wc = NULL
   ELSE
      OPEN t612_count
      FETCH t612_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t612_fetch('F')                  
   END IF
 
END FUNCTION
 
FUNCTION t612_fetch(p_flag)
   DEFINE  p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t612_cs INTO g_luk.luk01
      WHEN 'P' FETCH PREVIOUS t612_cs INTO g_luk.luk01
      WHEN 'F' FETCH FIRST    t612_cs INTO g_luk.luk01
      WHEN 'L' FETCH LAST     t612_cs INTO g_luk.luk01
      WHEN '/'
            IF (NOT g_no_ask) THEN      
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()      
  
                   ON ACTION HELP          
                      CALL cl_show_help()  
 
                   ON ACTION controlg      
                      CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t612_cs INTO g_luk.luk01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luk.luk01,SQLCA.sqlcode,0)
      INITIALIZE g_luk.* TO NULL        
      LET g_luk01_t = NULL       
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_luk.* FROM luk_file WHERE luk01 = g_luk.luk01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","luk_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_luk.* TO NULL
      LET g_luk01_t = NULL
      RETURN
   END IF
   
   LET g_data_owner = g_luk.lukuser      
   LET g_data_group = g_luk.lukgrup      
   LET g_data_plant = g_luk.lukplant
 
   CALL t612_show()
END FUNCTION
 

FUNCTION t612_show()

   LET g_luk_t.* = g_luk.*                                
   DISPLAY BY NAME g_luk.luk01,g_luk.luk02,g_luk.luk03,g_luk.luk04,g_luk.luk05,g_luk.lukplant,g_luk.luklegal,
                   g_luk.luk06,g_luk.luk07,g_luk.luk08,g_luk.luk09,g_luk.luk10,g_luk.luk11,g_luk.luk12,
                   g_luk.luk13,g_luk.luk14,g_luk.lukconf,g_luk.lukconu,g_luk.lukcond,g_luk.lukcont,g_luk.luk15,
                   g_luk.lukuser,g_luk.lukgrup,g_luk.lukoriu,g_luk.lukmodu,g_luk.lukdate,g_luk.lukorig,
                   g_luk.lukacti,g_luk.lukcrat,g_luk.luk16 #FUN-C20009
                             
   CALL t612_desc()
   CALL t612_pic()
   IF NOT cl_null(g_luk.luk08) THEN
      CALL t612_lnt30()
   ELSE
      CALL t612_lne08()
   END IF
   CALL t612_b_fill(g_wc2)      
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t612_b_fill(p_wc2)
DEFINE p_wc2           STRING
DEFINE l_sql           STRING
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--

 
   LET l_sql = "SELECT lul02,lul03,lul04,lul05,'','',lul06,lul07,lul08,'','','','',''",
               "  FROM lul_file",   
               " WHERE lul01 ='",g_luk.luk01,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET l_sql=l_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET l_sql=l_sql CLIPPED," ORDER BY lul02 "
   DISPLAY l_sql
 
   PREPARE t612_pb FROM l_sql
   DECLARE lul_cs CURSOR FOR t612_pb
 
   CALL g_lul.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH lul_cs INTO g_lul[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_get_bookno(YEAR(g_luk.luk02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add 
      SELECT oaj02,oaj04 INTO g_lul[g_cnt].oaj02,g_lul[g_cnt].oaj04
        FROM oaj_file WHERE oaj01 = g_lul[g_cnt].lul05 AND oajacti = 'Y'
      IF g_aza.aza63='Y' THEN
         SELECT oaj041 INTO g_lul[g_cnt].oaj041 
           FROM oaj_file WHERE oaj01 = g_lul[g_cnt].lul05 AND oajacti = 'Y'
         SELECT aag02 INTO g_lul[g_cnt].aag02_1
           FROM aag_file WHERE aag01 = g_lul[g_cnt].oaj041 AND aag00 =l_bookno2  #FUN-C10024 add
      END IF
      SELECT oaj05 INTO g_lul[g_cnt].oaj05
        FROM oaj_file WHERE oaj01 = g_lul[g_cnt].lul05

      SELECT aag02 INTO g_lul[g_cnt].aag02
        FROM aag_file WHERE aag01 = g_lul[g_cnt].oaj04 AND aag00 =l_bookno1   #FUN-C10024 add

      LET g_lul[g_cnt].amt_1 = g_lul[g_cnt].lul06 - g_lul[g_cnt].lul07 - g_lul[g_cnt].lul08
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lul.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t612_bp_refresh()
 
END FUNCTION
 
FUNCTION t612_source()
   DEFINE l_cmd    LIKE type_file.chr1000
   DEFINE l_luo01  LIKE luo_file.luo01   
 
   IF cl_null(g_luk.luk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_luk.luk04 = '1' THEN
      IF NOT cl_null(g_luk.luk05) THEN
         LET l_cmd ="artt611 '' '",g_luk.luk05 CLIPPED,"'"
      ELSE
         LET l_cmd ="artt611 '' '",g_lul[l_ac].lul03 CLIPPED,"'"
      END IF
   END IF
   IF g_luk.luk04 = '2' THEN
      IF NOT cl_null(g_luk.luk05) THEN
         SELECT luo01 INTO l_luo01 FROM luo_file WHERE luo03 = '1' AND luo04 = g_luk.luk05
         LET l_cmd ="artt615 '1' '" ,l_luo01 CLIPPED,"' "
      END IF
   END IF
   IF g_luk.luk04 = '3' THEN
      IF NOT cl_null(g_luk.luk01) THEN
         LET l_cmd ="artt613 '" ,g_luk.luk01 CLIPPED,"' "
      END IF
   END IF
   CALL cl_cmdrun(l_cmd)
   RETURN
END FUNCTION

FUNCTION t612_expend()
   DEFINE l_cmd LIKE type_file.chr1000
  
   IF cl_null(g_luk.luk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET l_cmd =  "artt614 '1' '",g_luk.luk01 CLIPPED,"' "
   CALL cl_cmdrun(l_cmd)
   RETURN
   
END FUNCTION

FUNCTION t612_pic()
   CASE g_luk.lukconf
      WHEN 'Y'  LET g_confirm = 'Y'
      WHEN 'N'  LET g_confirm = 'N'
      OTHERWISE LET g_confirm = ''
   END CASE

   CALL cl_set_field_pic(g_confirm,"","","","",g_luk.lukacti)
END FUNCTION

FUNCTION t612_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("luk01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t612_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("luk01",FALSE)
    END IF

END FUNCTION
#FUN-BB0117

#FUN-CB0076-------add------str
FUNCTION t612_out()
DEFINE l_sql     STRING, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_oaj05   LIKE oaj_file.oaj05,
       l_amt     LIKE lul_file.lul06,
       sr        RECORD
          lukplant  LIKE luk_file.lukplant,
          luk01     LIKE luk_file.luk01,
          luk08     LIKE luk_file.luk08,
          luk09     LIKE luk_file.luk09,
          luk06     LIKE luk_file.luk06,
          luk02     LIKE luk_file.luk02,
          luk07     LIKE luk_file.luk07,
          lukcond   LIKE luk_file.lukcond,
          lukcont   LIKE luk_file.lukcont,
          lukconu   LIKE luk_file.lukconu,
          lul02     LIKE lul_file.lul02,
          lul03     LIKE lul_file.lul03,
          lul04     LIKE lul_file.lul04,
          lul05     LIKE lul_file.lul05,
          lul06     LIKE lul_file.lul06,
          lul07     LIKE lul_file.lul07,
          lul08     LIKE lul_file.lul08
                 END RECORD
                 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lukser', 'lukgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " luk01 = '",g_luk.luk01,"'" END IF
     LET l_sql = "SELECT lukplant,luk01,luk08,luk09,luk06,luk02,luk07,lukcond,lukcont,lukconu,",
                 "       lul02,lul03,lul04,lul05,lul06,lul07,lul08",
                 "  FROM luk_file,lul_file",
                 " WHERE luk01 = lul01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t612_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t612_cs1 CURSOR FOR t612_prepare1

     DISPLAY l_table
     FOREACH t612_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lukplant
       LET l_occ02 = ' '
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.luk06
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lukconu
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.lul05
       LET l_oaj05 = ' '
       SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = sr.lul05
       LET l_amt = 0
       LET l_amt = sr.lul06-sr.lul07-sr.lul08
       EXECUTE insert_prep USING sr.*,l_rtz13,l_occ02,l_gen02,l_oaj02,l_oaj05,l_amt
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'luk01,luk02,luk03,luk04,luk05,lukplant,luklegal,luk06,luk07,luk08,luk09,luk10,luk11,luk12,luk13,luk14,luk16,lukconf,lukconu,lukcond,lukcont,luk15,lukuser,lukgrup,lukoriu,lukmodu,lukdate,lukorig,lukacti,lukcrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lul02,lul03,lul04,lul05,lul06,lul07,lul08')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF
     END IF
     CALL t612_grdata()
END FUNCTION

FUNCTION t612_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("artt612")
       IF handler IS NOT NULL THEN
           START REPORT t612_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY luk01,lul02"
           DECLARE t612_datacur1 CURSOR FROM l_sql
           FOREACH t612_datacur1 INTO sr1.*
               OUTPUT TO REPORT t612_rep(sr1.*)
           END FOREACH
           FINISH REPORT t612_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t612_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lul06_sum   LIKE lul_file.lul06
    DEFINE l_lul07_sum   LIKE lul_file.lul07
    DEFINE l_lul08_sum   LIKE lul_file.lul08
    DEFINE l_amt_sum     LIKE lul_file.lul06
    DEFINE l_oaj05       STRING
    DEFINE l_plant       STRING
    
    ORDER EXTERNAL BY sr1.luk01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
            PRINTX g_wc3
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.luk01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr1.oaj05)
            PRINTX l_lineno
            PRINTX l_oaj05
            PRINTX sr1.*
            LET l_plant = sr1.lukplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.luk01
            LET l_lul06_sum = GROUP SUM(sr1.lul06)
            LET l_lul07_sum = GROUP SUM(sr1.lul07)
            LET l_lul08_sum = GROUP SUM(sr1.lul08)
            LET l_amt_sum = GROUP SUM(sr1.amt)
            PRINTX l_lul06_sum
            PRINTX l_lul07_sum
            PRINTX l_lul08_sum
            PRINTX l_amt_sum
            
        ON LAST ROW

END REPORT
#FUN-CB0076-------add------end

