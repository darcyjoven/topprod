# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: artg610.4gl
# Descriptions...: 費用單明細打印
# Date & Author..: No:FUN-C60062 12/06/20 By yangxf
# Modify.........: No.FUN-C60062 12/10/10 By xumeimei 程序重新修改 

DATABASE ds
GLOBALS "../../config/top.global"


DEFINE g_sql      STRING
DEFINE g_sql1     STRING                                                                
DEFINE g_sql2     STRING                                                               
DEFINE g_sql3     STRING
DEFINE g_table    STRING
DEFINE g_azw01    LIKE azw_file.azw01
DEFINE g_chk_auth STRING
DEFINE g_luaplant STRING
DEFINE g_zz05     LIKE zz_file.zz05
DEFINE l_table    STRING
DEFINE g_wc       STRING
DEFINE g_gprog    STRING 
DEFINE tm         RECORD                            
                  wc  STRING,                    #Where Condiction
                  d1  LIKE type_file.chr1,       #條件選項
                  d2  LIKE type_file.chr1,       #條件選項
                  s   LIKE lua_file.luaplant,    #排列順序
                  t   LIKE lua_file.luaplant,    #跳頁
                  u   LIKE lua_file.luaplant,    #小計
                  m   LIKE type_file.chr1        #是否輸入其它特殊列印條件  
                  END RECORD
DEFINE g_orderA  ARRAY[3] OF LIKE lua_file.luaplant  #排序名稱  
DEFINE g_ord1_desc      STRING
DEFINE g_ord2_desc      STRING
DEFINE g_ord3_desc      STRING

TYPE sr1_t RECORD
       order1   LIKE type_file.chr100,
       order2   LIKE type_file.chr100,
       order3   LIKE type_file.chr100,
       luaplant LIKE lua_file.luaplant,
       rtz13    LIKE rtz_file.rtz13,
       lua06    LIKE lua_file.lua06,
       lua061   LIKE lua_file.lua061,
       lua07    LIKE lua_file.lua07,
       lmf13    LIKE lmf_file.lmf13,
       lua01    LIKE lua_file.lua01,
       lub02    LIKE lub_file.lub02,
       lub03    LIKE lub_file.lub03,
       oaj02    LIKE oaj_file.oaj02,
       lub04t   LIKE lub_file.lub04t,
       lub11    LIKE lub_file.lub11,
       amt_2    LIKE lub_file.lub11,
       lub12    LIKE lub_file.lub12,
       lmf03    LIKE lmf_file.lmf03,
       lmf04    LIKE lmf_file.lmf04,
       lie04    LIKE lie_file.lie04,
       lua34    LIKE lua_file.lua34,
       lub10    LIKE lub_file.lub10,
       lua39    LIKE lua_file.lua39,
       lua38    LIKE lua_file.lua38
END RECORD

MAIN

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   LET g_chk_auth = ARG_VAL(1)
   LET tm.wc = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_pdate = ARG_VAL(4) 
   LET g_bgjob = ARG_VAL(5)
   LET tm.d1 = ARG_VAL(6)
   LET tm.d2 = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET g_gprog = ARG_VAL(11)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_sql = "order1.type_file.chr100,",
               "order2.type_file.chr100,",
               "order3.type_file.chr100,",
               "luaplant.lua_file.luaplant,",
               "rtz13.rtz_file.rtz13,",
               "lua06.lua_file.lua06,",
               "lua061.lua_file.lua061,",
               "lua07.lua_file.lua07,",
               "lmf13.lmf_file.lmf13,",
               "lua01.lua_file.lua01,",
               "lub02.lub_file.lub02,",
               "lub03.lub_file.lub03,",
               "oaj02.oaj_file.oaj02,",
               "lub04t.lub_file.lub04t,",
               "lub11.lub_file.lub11,",
               "amt_2.lub_file.lub11,",
               "lub12.lub_file.lub12,",
               "lmf03.lmf_file.lmf03,",
               "lmf04.lmf_file.lmf04,",
               "lie04.lie_file.lie04,",
               "lua34.lua_file.lua34,",
               "lub10.lub_file.lub10,",
               "lua39.lua_file.lua39,",
               "lua38.lua_file.lua38"
   LET l_table = cl_prt_temptable("artg610",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                              
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF      
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL artg610_tm()
   ELSE
      CALL artg610()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)
END MAIN

FUNCTION artg610_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
DEFINE l_combo        ui.ComboBox
   OPEN WINDOW artg610_w AT p_row,p_col
        WITH FORM "art/42f/artg610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL 
   LET tm.d1 = '3'
   LET tm.d2 = '3'
   LET tm.s = '123'
   LET tm.u = 'Y'
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_gprog = g_prog
   LET tm2.s1 = tm.s[1,1]
   LET tm2.s2 = tm.s[2,2]
   LET tm2.s3 = tm.s[3,3]
   LET tm2.t1 = tm.t[1,1]
   LET tm2.t2 = tm.t[2,2]
   LET tm2.t3 = tm.t[2,2]
   LET tm2.u1 = tm.u[1,1]
   LET tm2.u2 = tm.u[2,2]
   LET tm2.u3 = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
    DIALOG ATTRIBUTE(unbuffered)
    CONSTRUCT BY NAME g_luaplant ON luaplant

    END CONSTRUCT
 
    CONSTRUCT BY NAME tm.wc ON lmf03,lmf04,lie04,lua07,lmf13,lua06,
                               lub03,lua34,lub10,lua38,lua39

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

    END CONSTRUCT
         INPUT BY NAME tm.d1,tm.d2,tm2.s1,tm2.s2,tm2.s3,
                       tm2.t1,tm2.t2,tm2.t3,
                       tm2.u1,tm2.u2,tm2.u3,tm.m
                        ATTRIBUTE(WITHOUT DEFAULTS) 
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn) 
      
          AFTER FIELD d1
             IF tm.d1 NOT MATCHES "[123]" THEN NEXT FIELD d1 END IF
          AFTER FIELD d2
             IF tm.d2 NOT MATCHES "[123]" THEN NEXT FIELD d2 END IF
          AFTER FIELD m
             IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
          AFTER INPUT
             LET tm.s = tm2.s1[1,2],tm2.s2[1,2],tm2.s3[1,2]
             LET tm.t = tm2.t1,tm2.t2,tm2.t3
             LET tm.u = tm2.u1,tm2.u2,tm2.u3
             LET l_combo = ui.ComboBox.forName("formonly.s1")
             LET g_ord1_desc = l_combo.getTextOf(tm2.s1[1,2])
             LET l_combo = ui.ComboBox.forName("formonly.s2")
             LET g_ord2_desc = l_combo.getTextOf(tm2.s2[1,2])
             LET l_combo = ui.ComboBox.forName("formonly.s3")
             LET g_ord3_desc = l_combo.getTextOf(tm2.s3[1,2])
          END INPUT

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(luaplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw01"
                 LET g_qryparam.where = " azw01 IN ",g_auth," "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO luaplant
                 NEXT FIELD luaplant
              WHEN INFIELD(lmf03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmb02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmf03
                 NEXT FIELD lmf03
              WHEN INFIELD(lmf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmc03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmf04
                 NEXT FIELD lmf04
              WHEN INFIELD(lie04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmy03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lie04
                 NEXT FIELD lie04
              WHEN INFIELD(lua06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua06
                 NEXT FIELD lua06
              WHEN INFIELD(lua07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmf01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua07
                 NEXT FIELD lua07
              WHEN INFIELD(lub03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oaj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lub03
                 NEXT FIELD lub03
              WHEN INFIELD(lua39)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua39
                 NEXT FIELD lua39
              WHEN INFIELD(lua38)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lua38
                 NEXT FIELD lua38
               OTHERWISE EXIT CASE
            END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle() 
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1 
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
         LET tm.s = tm2.s1[1,2],tm2.s2[1,2],tm2.s3[1,2]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
         LET l_combo = ui.ComboBox.forName("formonly.s1")
         LET g_ord1_desc = l_combo.getTextOf(tm2.s1[1,2])
         LET l_combo = ui.ComboBox.forName("formonly.s2")
         LET g_ord2_desc = l_combo.getTextOf(tm2.s2[1,2])
         LET l_combo = ui.ComboBox.forName("formonly.s3")
         LET g_ord3_desc = l_combo.getTextOf(tm2.s3[1,2])
         EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG

       ON ACTION qbe_select
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
   END DIALOG
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW artg610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file 
             WHERE zz01='artg610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artg610','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_chk_auth CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",tm.d1 CLIPPED,"'",
                         " '",tm.d2 CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'"
         CALL cl_cmdat('artg610',g_time,l_cmd) 
      END IF
      CLOSE WINDOW artg610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artg610()
   ERROR ""
END WHILE
   CLOSE WINDOW artg610_w
END FUNCTION
FUNCTION artg610_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE l_rtz13    LIKE rtz_file.rtz13
    DEFINE l_oaj02    LIKE oaj_file.oaj02

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LET g_sql1 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=?"
    DECLARE artg610_repcur01 CURSOR FROM g_sql1
    LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=?"
    DECLARE artg610_repcur02 CURSOR FROM g_sql2
    LET g_sql3 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=? AND order3=?"
    DECLARE artg610_repcur03 CURSOR FROM g_sql3

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg610")
        IF handler IS NOT NULL THEN
            START REPORT artg610_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3,luaplant" 
          
            DECLARE artg610_datacur1 CURSOR FROM l_sql
            FOREACH artg610_datacur1 INTO sr1.*
               LET l_sql = " SELECT rtz13 ",
                           "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),
                           "  WHERE rtz01 = '",sr1.luaplant,"'"
               PREPARE rtz_cs1 FROM l_sql
               EXECUTE rtz_cs1 INTO l_rtz13
               LET l_sql = " SELECT oaj02 ",
                           "   FROM ",cl_get_target_table(g_azw01,'oaj_file'),
                           "  WHERE oaj01 = '",sr1.lub03,"'"
               PREPARE oaj_cs1 FROM l_sql
               EXECUTE oaj_cs1 INTO l_oaj02
               IF cl_null(sr1.lub11) THEN
                  LET sr1.lub11 = 0
               END IF
               IF cl_null(sr1.lub12) THEN
                  LET sr1.lub12 = 0
               END IF
               LET sr1.amt_2 = sr1.lub04t - sr1.lub11 - sr1.lub12
               LET sr1.rtz13 = l_rtz13
               LET sr1.oaj02 = l_oaj02
               OUTPUT TO REPORT artg610_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg610_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

PRIVATE FUNCTION artg610_replace_ord_desc(p_desc)
    DEFINE p_desc   STRING
    DEFINE l_pos    LIKE type_file.num10
    DEFINE l_str    STRING

    IF p_desc IS NOT NULL THEN
        LET l_pos = p_desc.getIndexOf(":",1)
        IF l_pos > 1 THEN
            LET l_str = p_desc.subString(l_pos + 1,p_desc.getLength())
        ELSE
            LET l_str = p_desc
        END IF
    END IF

    RETURN l_str
END FUNCTION

REPORT artg610_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_t             LIKE type_file.num5
    DEFINE l_title         STRING
    DEFINE l_orderA        STRING
    DEFINE l_lineno        LIKE type_file.num5
    DEFINE l_cnt1          LIKE type_file.num10
    DEFINE l_cnt2          LIKE type_file.num10
    DEFINE l_cnt3          LIKE type_file.num10
    DEFINE l_ord1_cnt      LIKE type_file.num10
    DEFINE l_ord2_cnt      LIKE type_file.num10
    DEFINE l_ord3_cnt      LIKE type_file.num10
    DEFINE l_skip_ord1     LIKE type_file.chr1 
    DEFINE l_skip_ord2     LIKE type_file.chr1  
    DEFINE l_skip_ord3     LIKE type_file.chr1  
    DEFINE l_ord1_skip     STRING
    DEFINE l_ord2_skip     STRING
    DEFINE l_ord3_skip     STRING
    DEFINE l_ord1_show     STRING
    DEFINE l_ord2_show     STRING
    DEFINE l_ord3_show     STRING
    DEFINE l_ord1_desc     STRING
    DEFINE l_ord2_desc     STRING
    DEFINE l_ord3_desc     STRING
    DEFINE l_tot1          LIKE lub_file.lub04t
    DEFINE l_tot2          LIKE lub_file.lub11
    DEFINE l_tot3          LIKE lub_file.lub11
    DEFINE l_tot4          LIKE lub_file.lub12
    DEFINE l_tot5          LIKE lub_file.lub04t
    DEFINE l_tot6          LIKE lub_file.lub11
    DEFINE l_tot7          LIKE lub_file.lub11
    DEFINE l_tot8          LIKE lub_file.lub12
    DEFINE l_tot9          LIKE lub_file.lub04t
    DEFINE l_tot10         LIKE lub_file.lub11
    DEFINE l_tot11         LIKE lub_file.lub11
    DEFINE l_tot12         LIKE lub_file.lub12
    DEFINE l_lub04t_fmt    STRING
    DEFINE l_lub11_fmt     STRING
    DEFINE l_lub12_fmt     STRING
    DEFINE l_tot1_fmt      STRING
    DEFINE l_tot2_fmt      STRING
    DEFINE l_tot3_fmt      STRING


    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3 
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime
            PRINTX tm.*,g_wc

            LET l_ord1_skip = tm.t[1]
            LET l_ord2_skip = tm.t[2]
            LET l_ord3_skip = tm.t[3]
            IF l_ord1_skip = 'N' THEN
               IF l_ord2_skip = 'Y' OR l_ord3_skip = 'Y' THEN
                  LET l_ord1_skip = 'Y'
               END IF
            END IF
            PRINTX l_ord1_skip,l_ord2_skip,l_ord3_skip

            LET l_ord1_show = tm.u[1]
            LET l_ord2_show = tm.u[2]
            LET l_ord3_show = tm.u[3]
            PRINTX l_ord1_show,l_ord2_show,l_ord3_show
            LET l_orderA = artg610_replace_ord_desc(g_ord1_desc),'-',artg610_replace_ord_desc(g_ord2_desc),'-',artg610_replace_ord_desc(g_ord3_desc)
            PRINTX l_orderA
            LET l_ord1_desc = artg610_replace_ord_desc(g_ord1_desc),cl_gr_getmsg("gre-245",g_lang,1),':'
            LET l_ord2_desc = artg610_replace_ord_desc(g_ord2_desc),cl_gr_getmsg("gre-245",g_lang,1),':'
            LET l_ord3_desc = artg610_replace_ord_desc(g_ord3_desc),cl_gr_getmsg("gre-245",g_lang,1),':'
            PRINTX l_ord1_desc,l_ord2_desc,l_ord3_desc 
            IF g_gprog = "artg610" THEN LET l_t = 1 END IF
            IF g_gprog = "artq610" THEN LET l_t = 2 END IF
            LET l_title = cl_gr_getmsg("gre-310",g_lang,l_t)
            PRINTX l_title
        
        BEFORE GROUP OF sr1.order1
            FOREACH artg610_repcur01 USING sr1.order1 INTO l_cnt1 END FOREACH
            LET l_ord1_cnt = 0

        BEFORE GROUP OF sr1.order2
            FOREACH artg610_repcur02 USING sr1.order1,sr1.order2 INTO l_cnt2 END FOREACH
            LET l_ord2_cnt = 0

        BEFORE GROUP OF sr1.order3
            FOREACH artg610_repcur03 USING sr1.order1,sr1.order2,sr1.order3 INTO l_cnt3 END FOREACH
            LET l_ord3_cnt = 0
 
        ON EVERY ROW
            LET l_ord3_cnt = l_ord3_cnt + 1
            LET l_ord2_cnt = l_ord2_cnt + 1
            LET l_ord1_cnt = l_ord1_cnt + 1
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lub04t_fmt = cl_gr_numfmt('lub_file','lub04t',g_azi04)
            LET l_lub11_fmt = cl_gr_numfmt('lub_file','lub11',g_azi04)
            LET l_lub12_fmt = cl_gr_numfmt('lub_file','lub12',g_azi04)
            PRINTX l_lub04t_fmt
            PRINTX l_lub11_fmt
            PRINTX l_lub12_fmt
            PRINTX sr1.*

        AFTER GROUP OF sr1.order3
            LET l_tot9 = GROUP SUM(sr1.lub04t)
            LET l_tot10 = GROUP SUM(sr1.lub11)
            LET l_tot11 = GROUP SUM(sr1.amt_2)
            LET l_tot12 = GROUP SUM(sr1.lub12)
            PRINTX l_tot9
            PRINTX l_tot10
            PRINTX l_tot11
            PRINTX l_tot12
            IF l_ord2_cnt = l_cnt2 OR l_ord1_cnt = l_cnt1 THEN
               LET l_skip_ord3 = 'Y'
            ELSE
               LET l_skip_ord3 = 'N'
            END IF
            PRINTX l_skip_ord3
             
          
        AFTER GROUP OF sr1.order2
            LET l_tot5 = GROUP SUM(sr1.lub04t)
            LET l_tot6 = GROUP SUM(sr1.lub11)
            LET l_tot7 = GROUP SUM(sr1.amt_2)
            LET l_tot8 = GROUP SUM(sr1.lub12)
            PRINTX l_tot5
            PRINTX l_tot6
            PRINTX l_tot7
            PRINTX l_tot8 
            IF l_ord1_cnt = l_cnt1 THEN 
               LET l_skip_ord2 = 'Y'
            ELSE
               LET l_skip_ord2 = 'N'
            END IF
            PRINTX l_skip_ord2
 
        AFTER GROUP OF sr1.order1
            LET l_tot1 = GROUP SUM(sr1.lub04t)
            LET l_tot2 = GROUP SUM(sr1.lub11)
            LET l_tot3 = GROUP SUM(sr1.amt_2)
            LET l_tot4 = GROUP SUM(sr1.lub12)
            PRINTX l_tot1
            PRINTX l_tot2
            PRINTX l_tot3
            PRINTX l_tot4
            LET l_tot1_fmt = cl_gr_numfmt('lub_file','lub04t',g_azi05)
            LET l_tot2_fmt = cl_gr_numfmt('lub_file','lub11',g_azi05)
            LET l_tot3_fmt = cl_gr_numfmt('lub_file','lub12',g_azi05)
            PRINTX l_tot1_fmt
            PRINTX l_tot2_fmt
            PRINTX l_tot3_fmt
            LET l_skip_ord1 = 'N'
            PRINTX l_skip_ord1

        ON LAST ROW

END REPORT

FUNCTION artg610()
   DEFINE l_name      LIKE type_file.chr20,
          l_sql       STRING,
          l_where     STRING,
          l_where1    STRING,
          l_order     ARRAY[5] OF LIKE type_file.chr100,   #排列順序
          l_i         LIKE type_file.num5,
          sr          RECORD
                      luaplant LIKE lua_file.luaplant,
                      rtz13    LIKE rtz_file.rtz13,
                      lua06    LIKE lua_file.lua06,
                      lua061   LIKE lua_file.lua061,
                      lua07    LIKE lua_file.lua07,
                      lmf13    LIKE lmf_file.lmf13,
                      lua01    LIKE lua_file.lua01,
                      lub02    LIKE lub_file.lub02,
                      lub03    LIKE lub_file.lub03,
                      oaj02    LIKE oaj_file.oaj02,
                      lub04t   LIKE lub_file.lub04t,
                      lub11    LIKE lub_file.lub11,
                      amt_2    LIKE lub_file.lub11,
                      lub12    LIKE lub_file.lub12,
                      lmf03    LIKE lmf_file.lmf03,
                      lmf04    LIKE lmf_file.lmf04,
                      lie04    LIKE lie_file.lie04,
                      lua34    LIKE lua_file.lua34,
                      lub10    LIKE lub_file.lub10,
                      lua39    LIKE lua_file.lua39,
                      lua38    LIKE lua_file.lua38
                      END RECORD
   CALL cl_del_data(l_table)
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('luauser', 'luagrup')
   IF g_bgjob = 'Y' THEN
       LET g_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,lua_file ",
                   "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                   "    AND luaplant = azw01",
                   "    AND azwacti = 'Y'",
                   "  ORDER BY azw01 "
   ELSE
       LET g_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,lua_file ",
                   "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                   "    AND luaplant = azw01",
                   "    AND ", g_luaplant,
                   "    AND azwacti = 'Y'",
                   "  ORDER BY azw01 "
   END IF
   PREPARE g610_pb_1 FROM g_sql
   DECLARE g610_bc1 CURSOR FOR g610_pb_1
   FOREACH g610_bc1 INTO g_azw01
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_sql = "SELECT DISTINCT luaplant,'',lua06,lua061,lua07,lmf13,lua01,",
                  "       lub02,lub03,'',lub04t,lub11,'',lub12,'','','',lua34,lub10,lua39,lua38 ",
                  "  FROM ",cl_get_target_table(g_azw01,'lua_file'),
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'lmf_file'),
                  "          ON lua07 = lmf01",
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'lie_file'),
                  "          ON lua07 = lie01",
                  ",",cl_get_target_table(g_azw01,'lub_file'),
                  " WHERE luaplant = '",g_azw01,"' AND lua01 = lub01"
      CASE tm.d1
           WHEN '1' LET l_where = "  AND (lub04t-lub11-lub12 > 0)"
           WHEN '2' LET l_where = "  AND (lub04t-lub11-lub12 = 0)"
           WHEN '3' LET l_where = " "
      END CASE
      CASE tm.d2
           WHEN '1' LET l_where1 = " AND lua15 = 'Y'"
           WHEN '2' LET l_where1 = " AND lua15 = 'N'"   
           WHEN '3' LET l_where1 = " "
      END CASE
      LET l_sql = l_sql,l_where,l_where1," AND ",tm.wc CLIPPED
      PREPARE artg610_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE artg610_curs1 CURSOR FOR artg610_prepare1
      FOREACH artg610_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF

        FOR l_i = 1 TO 3
            CASE WHEN tm.s[l_i,l_i]='1' LET l_order[l_i] =sr.luaplant
                 WHEN tm.s[l_i,l_i]='2' LET l_order[l_i] =sr.lmf03 
                 WHEN tm.s[l_i,l_i]='3' LET l_order[l_i] =sr.lmf04
                 WHEN tm.s[l_i,l_i]='4' LET l_order[l_i] =sr.lie04
                 WHEN tm.s[l_i,l_i]='5' LET l_order[l_i] =sr.lua06
                 WHEN tm.s[l_i,l_i]='6' LET l_order[l_i] =sr.lua07
                 WHEN tm.s[l_i,l_i]='7' LET l_order[l_i] =sr.lmf13
                 WHEN tm.s[l_i,l_i]='8' LET l_order[l_i] =sr.lub03
                 WHEN tm.s[l_i,l_i]='9' LET l_order[l_i] =sr.lua34  USING 'yyyymmdd'
                 WHEN tm.s[l_i,l_i]='10' LET l_order[l_i] =sr.lub10 USING 'yyyymmdd'
                 WHEN tm.s[l_i,l_i]='11' LET l_order[l_i] =sr.lua39
                 WHEN tm.s[l_i,l_i]='12' LET l_order[l_i] =sr.lua38
                 OTHERWISE LET l_order[l_i] = '-'
            END CASE
        END FOR

        IF l_order[1] IS NULL THEN LET l_order[1] = ' ' END IF
        IF l_order[2] IS NULL THEN LET l_order[2] = ' ' END IF
        IF l_order[3] IS NULL THEN LET l_order[3] = ' ' END IF
        EXECUTE insert_prep USING l_order[1],l_order[2],l_order[3],sr.*
      END FOREACH
   END FOREACH
   IF tm.wc =" 1=1" THEN
      LET g_wc = g_luaplant
   ELSE
      LET g_wc = g_luaplant,tm.wc
   END IF
   CALL cl_wcchp(g_wc,'luaplant,lmf03,lmf04,lie04,lua06,lua07,lmf13,lub03,lua34,lua39,lua38,lub10') RETURNING g_wc
   IF g_wc.getLength() > 500 THEN
      LET g_wc = tm.wc.subString(1,500)
      CALL cl_wcchp(g_wc,'luaplant,lmf03,lmf04,lie04,lua06,lua07,lmf13,lub03,lua34,lua39,lua38,lub10') RETURNING g_wc
      LET g_wc = g_wc,"..."
   END IF
   LET g_template = 'artg610'
   CALL artg610_grdata()
END FUNCTION
#FUN-C60062
