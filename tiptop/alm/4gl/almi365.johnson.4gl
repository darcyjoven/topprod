# Prog. Version..: '5.20.01-12.01.17(00001)'
#
# Pattern name...: almi365.4gl
# Descriptions...: 摊位个别费用标准设置作业 
# Date & Author..: FUN-B90121 11/09/26 By  yangxf


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_lip           RECORD LIKE lip_file.*,
       g_lip_t         RECORD LIKE lip_file.*,
       g_lip_o         RECORD LIKE lip_file.*,
       g_lip01_t       LIKE lip_file.lip01,
       g_liq           DYNAMIC ARRAY OF RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq06       LIKE liq_file.liq06,
           liq061      LIKE liq_file.liq061,
           liq09       LIKE liq_file.liq09
                        END RECORD,

       g_liq_t       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq06       LIKE liq_file.liq06,
           liq061      LIKE liq_file.liq061,
           liq09       LIKE liq_file.liq09
                        END RECORD,

       g_liq_o       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq06       LIKE liq_file.liq06,
           liq061      LIKE liq_file.liq061,
           liq09       LIKE liq_file.liq09
                        END RECORD,
       g_liq1       DYNAMIC ARRAY OF RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq07       LIKE liq_file.liq07,
           liq071      LIKE liq_file.liq071,
           liq072      LIKE liq_file.liq072,
           liq073      LIKE liq_file.liq073,
           liq074      LIKE liq_file.liq074,
           liq09       LIKE liq_file.liq09           
                        END RECORD,
       g_liq1_t       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq07       LIKE liq_file.liq07,
           liq071      LIKE liq_file.liq071,
           liq072      LIKE liq_file.liq072,
           liq073      LIKE liq_file.liq073,
           liq074      LIKE liq_file.liq074,
           liq09       LIKE liq_file.liq09           
                      END RECORD,
       g_liq1_o       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq07       LIKE liq_file.liq07,
           liq071      LIKE liq_file.liq071,
           liq072      LIKE liq_file.liq072,
           liq073      LIKE liq_file.liq073,
           liq074      LIKE liq_file.liq074,
           liq09       LIKE liq_file.liq09           
                        END RECORD,                        
       g_liq2        DYNAMIC ARRAY OF RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq08       LIKE liq_file.liq08,
           liq081      LIKE liq_file.liq081,
           liq082      LIKE liq_file.liq082,
           liq083      LIKE liq_file.liq083,
           liq084      LIKE liq_file.liq084,
           liq09       LIKE liq_file.liq09
                      END RECORD,
       g_liq2_t       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq08       LIKE liq_file.liq08,
           liq081      LIKE liq_file.liq081,
           liq082      LIKE liq_file.liq082,
           liq083      LIKE liq_file.liq083,
           liq084      LIKE liq_file.liq084,
           liq09       LIKE liq_file.liq09
                      END RECORD,
       g_liq2_o       RECORD
           liq02       LIKE liq_file.liq02,
           liq03       LIKE liq_file.liq03,
           liq04       LIKE liq_file.liq04,
           liq05       LIKE liq_file.liq05,
           liq08       LIKE liq_file.liq08,
           liq081      LIKE liq_file.liq081,
           liq082      LIKE liq_file.liq082,
           liq083      LIKE liq_file.liq083,
           liq084      LIKE liq_file.liq084,
           liq09       LIKE liq_file.liq09
                      END RECORD,
       g_oaj02         LIKE oaj_file.oaj02,
       g_rtz13         LIKE rtz_file.rtz13,
       g_azt02         LIKE azt_file.azt02,
       g_lmb03         LIKE lmb_file.lmb03,
       g_lmc04         LIKE lmc_file.lmc04,
       g_lmy04         LIKE lmy_file.lmy04,
       g_oba02         LIKE oba_file.oba02,
       g_tqa02         LIKE tqa_file.tqa02,
       g_gen02         LIKE gen_file.gen02,
       g_gen02_1       LIKE gen_file.gen02,
       g_gen02_2       LIKE gen_file.gen02,
       g_desc          LIKE lip_file.lip09, 
       g_sql           STRING,
       g_wc            STRING,
       g_wc1           STRING,
       g_wc2           STRING,
       g_wc3           string,
       g_rec_b         LIKE type_file.num5,
       g_rec_b1        LIKE type_file.num5,
       g_rec_b2        LIKE type_file.num5,
       l_ac            LIKE type_file.num5
DEFINE g_kindslip      LIKE oay_file.oayslip
DEFINE li_result       LIKE type_file.num5
DEFINE g_forupd_sql    STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1             LIKE lip_file.lip04
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_argv1 = ARG_VAL(1)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("alm")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lip_file WHERE lip01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i365_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i365_w WITH FORM "alm/42f/almi365"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) THEN 
      CALL cl_set_comp_entry("lip04",FALSE)
      LET g_lip.lip04 = g_argv1
      DISPLAY BY NAME g_lip.lip04 
      IF g_argv1 = '1' THEN 
         CALL cl_set_comp_visible("page4,page5",FALSE)
      END IF 
      IF g_argv1 = '2' THEN 
         CALL cl_set_comp_visible("page3,page5",FALSE)
      END IF 
      IF g_argv1 = '3' THEN 
         CALL cl_set_comp_visible("page3,page4",FALSE)
      END IF
   END IF
   CALL i365_menu()
   CLOSE WINDOW i365_w
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i365_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000

      CLEAR FORM
      CALL g_liq.clear()
      CALL g_liq1.clear()
      CALL g_liq2.clear()
      INITIALIZE g_lip.* TO NULL
      IF cl_null(g_argv1) THEN
         CONSTRUCT BY NAME g_wc ON lip01,lip02,lip03,lip04,lip05,
                                   lip051,lip06,lipplant,liplegal,lip07,
                                   lip08,lip09,lip10,lip11,lip12,lip13,
                                   lip14,lip15,lip16,lip17,lip18,
                                   lipmksg,lip19,lipconf,lipconu,lipcond,
                                   lip20,lip21,lip22,lipuser,lipgrup,liporiu,
                                   lipmodu,lipdate,liporig,lipacti,lipcrat
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

            ON ACTION controlp
               CASE
                  WHEN INFIELD(lip01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip01
                     NEXT FIELD lip01
                  WHEN INFIELD(lip05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip05
                     NEXT FIELD lip05
                  WHEN INFIELD(lip06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip06"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip06 
                     NEXT FIELD lip06
                  WHEN INFIELD(lip07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip07"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip07
                     NEXT FIELD lip07
                  WHEN INFIELD(lip08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip08"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip08
                     NEXT FIELD lip08
                  WHEN INFIELD(lip09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip09"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip09
                     NEXT FIELD lip09
                  WHEN INFIELD(lip10)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip10"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip10
                     NEXT FIELD lip10
                  WHEN INFIELD(lip11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip11"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip11
                     NEXT FIELD lip11
                  WHEN INFIELD(lipplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lipplant"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lipplant
                     NEXT FIELD lipplant
                  WHEN INFIELD(liplegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_liplegal"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO liplegal
                     NEXT FIELD liplegal
                  WHEN INFIELD(lipconu)
                     CALL cl_init_qry_var() 
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lipconu"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lipconu
                     NEXT FIELD lipconu
                  WHEN INFIELD(lip20)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip20"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip20
                     NEXT FIELD lip20
                  OTHERWISE EXIT CASE
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
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
         END CONSTRUCT
      ELSE
         LET g_lip.lip04 = g_argv1
         DISPLAY BY NAME g_lip.lip04
         CONSTRUCT BY NAME g_wc ON lip01,lip02,lip03,lip05,
                                   lip051,lip06,lipplant,liplegal,lip07,
                                   lip08,lip09,lip10,lip11,lip12,lip13,
                                   lip14,lip15,lip16,lip17,lip18,
                                   lipmksg,lip19,lipconf,lipconu,lipcond,
                                   lip20,lip21,lip22,lipuser,lipgrup,liporiu,
                                   lipmodu,lipdate,liporig,lipacti,lipcrat
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

            ON ACTION controlp
               CASE
                  WHEN INFIELD(lip01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip01
                     NEXT FIELD lip01
                  WHEN INFIELD(lip05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip05
                     NEXT FIELD lip05
                  WHEN INFIELD(lip06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip06"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip06
                     NEXT FIELD lip06
                  WHEN INFIELD(lip07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip07"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip07
                     NEXT FIELD lip07
                  WHEN INFIELD(lip08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip08"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip08
                     NEXT FIELD lip08
                  WHEN INFIELD(lip09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip09"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip09
                     NEXT FIELD lip09
                  WHEN INFIELD(lip10)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip10"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip10
                     NEXT FIELD lip10
                  WHEN INFIELD(lip11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip11"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip11
                     NEXT FIELD lip11
                  WHEN INFIELD(lipplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lipplant"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lipplant
                     NEXT FIELD lipplant
                  WHEN INFIELD(liplegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_liplegal"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO liplegal
                     NEXT FIELD liplegal
                  WHEN INFIELD(lipconu)
                     CALL cl_init_qry_var() 
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lipconu"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lipconu
                     NEXT FIELD lipconu
                  WHEN INFIELD(lip20)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lip20"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lip20
                     NEXT FIELD lip20

                  OTHERWISE EXIT CASE
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
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)

         END CONSTRUCT
      END IF 
      IF INT_FLAG THEN
         RETURN
      END IF
      LET g_wc1 = " 1=1"
      LET g_wc2 = " 1=1"
      LET g_wc3 = " 1=1"
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT g_wc1 ON liq02,liq03,liq04,
                            liq05,liq06,liq061,liq09
              FROM s_liq[1].liq02,s_liq[1].liq03,
                   s_liq[1].liq04,s_liq[1].liq05,
                   s_liq[1].liq06,s_liq[1].liq061,
                   s_liq[1].liq09
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(liq03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_liq03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO liq03
              NEXT FIELD liq03
            END CASE

       END CONSTRUCT 
       CONSTRUCT g_wc2 ON liq02_1,liq03_1,liq04_1,
                          liq05_1,liq07,liq071,liq072,liq073,liq074,liq09_1
            FROM s_liq1[1].liq02_1,s_liq1[1].liq03_1,
                 s_liq1[1].liq04_1,s_liq1[1].liq05_1,
                 s_liq1[1].liq07,s_liq1[1].liq071,
                 s_liq1[1].liq072,s_liq1[1].liq073,
                 s_liq1[1].liq074,s_liq1[1].liq09_1
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)    

         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(liq03_1)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_liq03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO liq03_1
              NEXT FIELD liq03_1
            END CASE
       END CONSTRUCT
       CONSTRUCT g_wc3 ON liq02_2,liq03_2,liq04_2,
                          liq05_2,liq08,liq081,liq082,liq083,liq084,liq09_2
            FROM s_liq2[1].liq02_2,s_liq2[1].liq03_2,
                 s_liq2[1].liq04_2,s_liq2[1].liq05_2,
                 s_liq2[1].liq08,s_liq2[1].liq081,
                 s_liq2[1].liq082,s_liq2[1].liq083,
                 s_liq2[1].liq084,s_liq2[1].liq09_2
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)    

         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(liq03_2)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_liq03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO liq03_2
              NEXT FIELD liq03_2
            END CASE
       END CONSTRUCT       
       ON ACTION ACCEPT
          ACCEPT DIALOG

       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DIALOG

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION qbe_save
          CALL cl_qbe_save()
    END DIALOG
    IF INT_FLAG THEN
       RETURN
    END IF
    LET g_wc2 = cl_replace_str(g_wc2,"liq02_1","liq02")
    LET g_wc2 = cl_replace_str(g_wc2,"liq03_1","liq03")
    LET g_wc2 = cl_replace_str(g_wc2,"liq04_1","liq04")
    LET g_wc2 = cl_replace_str(g_wc2,"liq05_1","liq05")
    LET g_wc2 = cl_replace_str(g_wc2,"liq09_1","liq09")
    LET g_wc3 = cl_replace_str(g_wc3,"liq02_2","liq02")
    LET g_wc3 = cl_replace_str(g_wc3,"liq03_2","liq03")
    LET g_wc3 = cl_replace_str(g_wc3,"liq04_2","liq04")
    LET g_wc3 = cl_replace_str(g_wc3,"liq05_2","liq05")
    LET g_wc3 = cl_replace_str(g_wc3,"liq09_2","liq09")
    IF cl_null(g_argv1) THEN
       LET g_sql = "SELECT UNIQUE lip01 "
       LET l_table = " FROM lip_file "
       LET l_where = " WHERE ",g_wc
       IF g_wc1 <> " 1=1" OR g_wc2 <> " 1=1" OR g_wc3 <> " 1=1" THEN
          LET l_table = l_table,",liq_file"
          LET l_where = l_where," AND lip01 = liq01 AND ",g_wc1," AND ",g_wc2," AND ",g_wc3
       END IF
       LET g_sql = g_sql,l_table,l_where," ORDER BY lip01"
    ELSE 
       LET g_sql = "SELECT UNIQUE lip01 "
       LET l_table = " FROM lip_file "
       LET l_where = " WHERE ",g_wc,
                     "  AND lip04 = '",g_argv1,"'"
       IF g_wc1 <> " 1=1" OR g_wc2 <> " 1=1" OR g_wc3 <> " 1=1" THEN
          LET l_table = l_table,",liq_file"
          LET l_where = l_where," AND lip01 = liq01 AND ",g_wc1," AND ",g_wc2," AND ",g_wc3
       END IF
       LET g_sql = g_sql,l_table,l_where," ORDER BY lip01"
    END IF 
    PREPARE i365_prepare FROM g_sql
    DECLARE i365_cs
       SCROLL CURSOR WITH HOLD FOR i365_prepare
    LET g_sql = "SELECT COUNT(DISTINCT lip01) ",l_table,l_where
    PREPARE i365_precount FROM g_sql
    DECLARE i365_count CURSOR FOR i365_precount

END FUNCTION


FUNCTION i365_menu()

   WHILE TRUE
      CALL i365_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i365_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i365_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i365_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i365_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i365_x()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_lip.lip04
                  WHEN '1'  CALL i365_b()
                  WHEN '2'  CALL i365_b1()
                  WHEN '3'  CALL i365_b2()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i365_confirm()
            END IF

         WHEN "over"
            IF cl_chk_act_auth() THEN
               CALL i365_s()
            END IF


         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CASE g_lip.lip04
                  WHEN '1'
                    CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_liq),'','')
                  WHEN '2'
                    CALL cl_export_to_excel(ui.Interface.getRootNode(),'',base.TypeInfo.create(g_liq1),'')
                  WHEN '3'
                    CALL cl_export_to_excel(ui.Interface.getRootNode(),'','',base.TypeInfo.create(g_liq2))
               END CASE              
            END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lip.lip01 IS NOT NULL THEN
                 LET g_doc.column1 = "lip01"
                 LET g_doc.value1 = g_lip.lip01
                 CALL cl_doc()
               END IF
          
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i365_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_liq TO s_liq.* ATTRIBUTE(COUNT=g_rec_b)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_liq1 TO s_liq1.* ATTRIBUTE(COUNT=g_rec_b1)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_liq2 TO s_liq2.* ATTRIBUTE(COUNT=g_rec_b2)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
      END DISPLAY      

      ON ACTION INSERT
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION DELETE
         LET g_action_choice="delete"
         EXIT DIALOG 

      ON ACTION MODIFY
         LET g_action_choice="modify"
         EXIT DIALOG
         
      ON ACTION FIRST
         CALL i365_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION PREVIOUS
         CALL i365_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL i365_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION NEXT
         CALL i365_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION LAST
         CALL i365_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      ON ACTION over
         LET g_action_choice="over"
         EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG 

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG 

      ON ACTION CANCEL
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i365_bp_refresh()
  DISPLAY ARRAY g_liq TO s_liq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  DISPLAY ARRAY g_liq1 TO s_liq1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  DISPLAY ARRAY g_liq2 TO s_liq2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY  
  

END FUNCTION

FUNCTION i365_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_liq.clear()
   CALL g_liq1.clear()
   CALL g_liq2.clear()
   LET g_wc = NULL
   LET g_wc1 = NULL 
   LET g_wc2 = NULL
   LET g_wc3 = NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_lip.* LIKE lip_file.*
   LET g_lip01_t = NULL
   LET g_lip_t.* = g_lip.*
   LET g_lip_o.* = g_lip.*
   WHILE TRUE
      IF cl_null(g_argv1) THEN
         CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
      ELSE
         LET g_lip.lip04 = g_argv1
         CASE g_lip.lip04
            WHEN '1'
              CALL cl_set_comp_visible('Page4,Page5',FALSE)
              CALL cl_set_comp_visible('Page3',TRUE)
            WHEN '2'
              CALL cl_set_comp_visible('Page3,Page5',FALSE)
              CALL cl_set_comp_visible('Page4',TRUE)
            WHEN '3'
              CALL cl_set_comp_visible('Page3,Page4',FALSE)
              CALL cl_set_comp_visible('Page5',TRUE)
         END CASE         
      END IF 
      LET g_lip.lipuser=g_user
      LET g_lip.liporiu = g_user
      LET g_lip.liporig = g_grup
      LET g_lip.lipgrup=g_grup
      LET g_lip.lipcrat=g_today
      LET g_lip.lipacti='Y'
      LET g_lip.lip02 = 0
      LET g_lip.lip03 = g_today
      LET g_lip.lipconf = 'N'
      LET g_lip.lip16 = 'N'
      LET g_lip.lipmksg = 'N'
      LET g_lip.lip19 = '0'
      LET g_lip.lipconf = 'N'
      LET g_lip.lipplant = g_plant
      LET g_lip.liplegal = g_legal
      LET g_lip.lip17 = g_user
      LET g_lip.lip18 = g_today
      SELECT rtz13 INTO g_rtz13 
        FROM rtz_file
       WHERE rtz01 = g_plant
      SELECT azt02 INTO g_azt02
        FROM azt_file
       WHERE azt01 = g_legal      
      CALL i365_i("a")
      IF INT_FLAG THEN
         INITIALIZE g_lip.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_lip.lip01) THEN
         CONTINUE WHILE
      END IF
      CALL s_auto_assign_no("ALM",g_lip.lip01,g_today,"P2","lip_file","lip01","","","")
         RETURNING li_result,g_lip.lip01
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF
      DISPLAY BY NAME g_lip.lip01
      BEGIN WORK
      INSERT INTO lip_file VALUES (g_lip.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lip_file",
                      g_lip.lip01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lip.lip01,'I')
      END IF
      SELECT lip01 INTO g_lip.lip01 FROM lip_file
       WHERE lip01 = g_lip.lip01
      LET g_lip01_t = g_lip.lip01
      LET g_lip_t.* = g_lip.*
      LET g_lip_o.* = g_lip.*
      CALL g_liq.clear()
      CALL g_liq1.clear()
      CALL g_liq2.clear()
      LET g_rec_b = 0
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      CASE g_lip.lip04
         WHEN '1'  CALL i365_b()
         WHEN '2'  CALL i365_b1()
         WHEN '3'  CALL i365_b2()
      END CASE
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i365_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lip.lip01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lip.lipconf = 'Y' THEN
      CALL cl_err('','aap-005',0)
      RETURN
   END IF

   IF g_lip.lipconf = 'S' THEN
      CALL cl_err('','alm-929',0)
      RETURN
   END IF 

   SELECT * INTO g_lip.* FROM lip_file
    WHERE lip01=g_lip.lip01

   IF g_lip.lipacti ='N' THEN
      CALL cl_err(g_lip.lip01,'aic-200',0)
      RETURN
   END IF

   MESSAGE ""
   LET g_lip01_t = g_lip.lip01
   BEGIN WORK

   OPEN i365_cl USING g_lip.lip01
   IF STATUS THEN
      CALL cl_err("OPEN i365_cl:", STATUS, 1)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i365_cl INTO g_lip.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
       CLOSE i365_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i365_show()

   WHILE TRUE
      LET g_lip01_t = g_lip.lip01
      LET g_lip_o.* = g_lip.*
      LET g_lip.lipmodu=g_user
      LET g_lip.lipdate=g_today
      
      CALL i365_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lip.*=g_lip_t.*
         CALL i365_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_lip.lip01 != g_lip01_t THEN
         UPDATE liq_file SET liq01 = g_lip.lip01
          WHERE liq01 = g_lip01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","liq_file",g_lip01_t,
                         "",SQLCA.sqlcode,"","liq",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE lip_file SET lip_file.* = g_lip.*
       WHERE lip01 = g_lip.lip01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lip_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i365_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lip.lip01,'U')
   CALL i365_b_fill("1=1")
   CALL i365_bp_refresh()

END FUNCTION

FUNCTION i365_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lip.lip01,g_lip.lip02,g_lip.lip03,g_lip.lip04,g_lip.lip05,
                   g_lip.lip051,g_lip.lip06,g_lip.lipplant,g_lip.liplegal,g_lip.lip07,
                   g_lip.lip08,g_lip.lip09,g_lip.lip10,g_lip.lip11,g_lip.lip12,g_lip.lip13,
                   g_lip.lip14,g_lip.lip15,g_lip.lip16,g_lip.lip17,g_lip.lip18,
                   g_lip.lipmksg,g_lip.lip19,g_lip.lipconf,g_lip.lipconu,g_lip.lipcond,g_lip.lipcont,
                   g_lip.lip20,g_lip.lip21,g_lip.lip22,g_lip.lipuser,g_lip.lipgrup,g_lip.liporiu,
                   g_lip.lipmodu,g_lip.lipdate,g_lip.liporig,g_lip.lipacti,g_lip.lipcrat
   CALL i365_desc()
   INPUT BY NAME   g_lip.lip01,g_lip.lip02,g_lip.lip03,
                   g_lip.lip04,g_lip.lip05,
                   g_lip.lip06,g_lip.lipplant,g_lip.liplegal,
                   g_lip.lip07,g_lip.lip08,g_lip.lip09,
                   g_lip.lip10,g_lip.lip11,g_lip.lip12,
                   g_lip.lip13,g_lip.lip14,g_lip.lip15,
                   g_lip.lip16,g_lip.lip17,
                   g_lip.lip18,g_lip.lipmksg,g_lip.lip19,
                   g_lip.lipconf,g_lip.lipconu,g_lip.lipcond,g_lip.lipcont,
                   g_lip.lip20,g_lip.lip21,g_lip.lip22
       WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i365_set_entry(p_cmd)
         CALL cl_set_comp_entry("lip07,lip08,lip09,lip10",FALSE)
         CALL cl_set_comp_entry("lip06,lip11",TRUE)
         CALL i365_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lip01")
         LET g_before_input_done = TRUE

       AFTER FIELD lip01
         IF NOT cl_null(g_lip.lip01) THEN
            IF  p_cmd = 'a'
               OR (p_cmd = 'u' AND g_lip.lip01 != g_lip_t.lip01) THEN
               CALL s_check_no("ALM",g_lip.lip01,g_lip_t.lip01,"P2","lip_file","lip01,lipplant","")
                           RETURNING li_result,g_lip.lip01
               IF (NOT li_result) THEN
                  LET g_lip.lip01 = g_lip_t.lip01
                  NEXT FIELD lip01
               END IF
               SELECT oayapr INTO g_lip.lipmksg FROM oay_file WHERE oayslip = g_lip.lip01
            END IF 
         END IF

       BEFORE FIELD lip04 
          LET g_lip_t.lip04 = g_lip.lip04
      
       AFTER FIELD lip04
          IF NOT cl_null(g_lip.lip04) THEN
             IF NOT cl_null(g_lip.lip05) THEN
                CALL i365_lip05(p_cmd)
                CALL i365_desc()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lip.lip04 = g_lip_t.lip04
                   DISPLAY BY NAME g_lip.lip04
                   NEXT FIELD lip04
                END IF 
             ELSE 
               CALL i365_lip04()
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lip.lip04 = g_lip_t.lip04
                   DISPLAY BY NAME g_lip.lip04
                   NEXT FIELD lip04
               END IF 
             END IF 
             CASE g_lip.lip04
               WHEN '1'
                 CALL cl_set_comp_visible('Page4,Page5',FALSE)
                 CALL cl_set_comp_visible('Page3',TRUE)
               WHEN '2'
                 CALL cl_set_comp_visible('Page3,Page5',FALSE)
                 CALL cl_set_comp_visible('Page4',TRUE)
               WHEN '3'
                 CALL cl_set_comp_visible('Page3,Page4',FALSE)
                 CALL cl_set_comp_visible('Page5',TRUE)
            END CASE
        END IF 

      AFTER FIELD lip05 
         IF NOT cl_null(g_lip.lip05) THEN
            CALL i365_lip05(p_cmd)
            CALL i365_desc()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip05 = g_lip_t.lip05
               LET g_lip.lip051 = g_lip_t.lip051
               LET g_lip.lip06 = g_lip_t.lip06
               LET g_lip.lip07 = g_lip_t.lip07
               LET g_lip.lip08 = g_lip_t.lip08
               LET g_lip.lip09 = g_lip_t.lip09
               LET g_lip.lip10 = g_lip_t.lip10
               LET g_lip.lip11 = g_lip_t.lip11
               LET g_lip.lip12 = g_lip_t.lip12
               LET g_lip.lip13 = g_lip_t.lip13
               DISPLAY BY NAME g_lip.lip04,g_lip.lip05,g_lip.lip051,g_lip.lip06,g_lip.lip07,
                               g_lip.lip08,g_lip.lip09,g_lip.lip10,g_lip.lip11,g_lip.lip12,
                               g_lip.lip13
               CALL i365_desc()
               IF cl_null(g_lip.lip05) THEN
                   CALL cl_set_comp_entry("lip06,lip11",TRUE)
                   CALL cl_set_comp_required("lip06,lip11",TRUE)
               END IF 
               NEXT FIELD lip05
            END IF
            CALL cl_set_comp_entry("lip06,lip07,lip08,lip09,lip10,lip11",FALSE)
         ELSE
            IF cl_null(g_lip.lip06) AND cl_null(g_lip.lip07) AND cl_null(g_lip.lip08)
               AND cl_null(g_lip.lip09) AND cl_null(g_lip.lip10) AND cl_null(g_lip.lip11) THEN
               IF p_cmd = 'a' THEN
                  LET g_lip.lip051 = ''
                  LET g_lip.lip06 = ''
                  LET g_lip.lip07 =''
                  LET g_lip.lip08 =''
                  LET g_lip.lip09 =''
                  LET g_lip.lip10 =''
                  LET g_lip.lip11 =''
                  LET g_lip.lip12 =''
                  LET g_lip.lip13 =''
               END IF 
            END IF 
            DISPLAY BY NAME g_lip.lip04,g_lip.lip05,g_lip.lip051,g_lip.lip06,g_lip.lip07,
                            g_lip.lip08,g_lip.lip09,g_lip.lip10,g_lip.lip11,g_lip.lip12,
                            g_lip.lip13
            CALL i365_desc()
            CALL cl_set_comp_entry("lip06,lip11",TRUE)
            CALL cl_set_comp_required("lip06,lip11",TRUE)
         END IF 

      AFTER FIELD lip06
         IF NOT cl_null(g_lip.lip06) THEN
            CALL i365_chk_lip06()
            IF NOT cl_null(g_errno) THEN
                LET g_lip.lip06 = g_lip_t.lip06
                CALL cl_err('',g_errno,0)
                NEXT FIELD lip06
            ELSE
               IF cl_null(g_lip.lip04) THEN
                   CALL i365_chk_to()
               ELSE
                   CALL i365_chk_to_1()
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lip.lip06 = g_lip_t.lip06
                  CALL i365_desc()
                  NEXT FIELD lip06
               END IF
               CALL i365_chk_lip14_lip15()
               IF NOT cl_null(g_errno) THEN
                   LET g_lip.lip06 = g_lip_t.lip06
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
               ELSE 
                  CALL i365_lip06()
                  CALL i365_desc()
               END IF 
            END IF
         ELSE
            IF p_cmd ='a' THEN
               LET g_lip.lip07 = ''
               LET g_lip.lip08 = ''
               LET g_lip.lip09 = ''
               LET g_lip.lip10 = ''
               LET g_lip.lip11 = ''
               LET g_lip.lip12 = ''
               LET g_lip.lip13 = ''
               DISPLAY BY NAME  g_lip.lip07,g_lip.lip08,g_lip.lip09,
                                g_lip.lip10,g_lip.lip11,g_lip.lip12,g_lip.lip13 
               DISPLAY ' ' TO oaj02 
            ELSE 
               LET g_lip.lip12 = ''
               LET g_lip.lip13 = ''
               DISPLAY BY NAME g_lip.lip12,g_lip.lip13   
            END IF 
         END IF
         
      AFTER FIELD lip07
         IF NOT cl_null(g_lip.lip07) THEN
            CALL i365_chk_lip07()
            IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lip.lip07 = g_lip_t.lip07
                NEXT FIELD lip07
            END IF
            CALL i365_desc()
            IF cl_null(g_lip.lip04) THEN 
                CALL i365_chk_to()             
            ELSE 
                CALL i365_chk_to_1()
            END IF 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip07 = g_lip_t.lip07
               CALL i365_desc()
               NEXT FIELD lip07
            END IF
            CALL i365_chk_lip14_lip15()
            IF NOT cl_null(g_errno) THEN
                LET g_lip.lip07 = g_lip_t.lip07
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
            END IF
            IF p_cmd = 'u' THEN
               CALL i365_lip07_liq03()
               IF NOT cl_null(g_errno) THEN
                   LET g_lip.lip07 = g_lip_t.lip07
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
               END IF 
            END IF
         ELSE
            DISPLAY ' ' TO lmb03
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         END IF

      AFTER FIELD lip08
         IF NOT cl_null(g_lip.lip08) THEN
            CALL i365_chk_lip08()
            IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lip.lip08 = g_lip_t.lip08
                NEXT FIELD lip08
            END IF
            CALL i365_desc()
            IF cl_null(g_lip.lip04) THEN
                CALL i365_chk_to()
            ELSE
                CALL i365_chk_to_1()
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip08 = g_lip_t.lip08
               CALL i365_desc()       
               NEXT FIELD lip08
            END IF
            CALL i365_chk_lip14_lip15()
            IF NOT cl_null(g_errno) THEN
                LET g_lip.lip08 = g_lip_t.lip08
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
            END IF
            IF p_cmd = 'u' THEN
               CALL i365_lip07_liq03()
               IF NOT cl_null(g_errno) THEN
                   LET g_lip.lip08 = g_lip_t.lip08
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO lmc04 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         END IF

      AFTER FIELD lip09
         IF NOT cl_null(g_lip.lip09) THEN
            CALL i365_chk_lip09()
            IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lip.lip09 = g_lip_t.lip09
                NEXT FIELD lip09
            END IF
            CALL i365_desc()
            IF cl_null(g_lip.lip04) THEN
                CALL i365_chk_to()
            ELSE
                CALL i365_chk_to_1()
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip09 = g_lip_t.lip09
               CALL i365_desc()
               NEXT FIELD lip09
            END IF
            CALL i365_chk_lip14_lip15()
            IF NOT cl_null(g_errno) THEN
                LET g_lip.lip09 = g_lip_t.lip09
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
            END IF
         ELSE
            DISPLAY ' ' TO lmy04
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         END IF        

      AFTER FIELD lip10
         IF NOT cl_null(g_lip.lip10) THEN
           CALL i365_chk_lip10()
           IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip10 = g_lip_t.lip10
               NEXT FIELD lip10
           END IF
           CALL i365_desc()
           IF cl_null(g_lip.lip04) THEN
               CALL i365_chk_to()
           ELSE
               CALL i365_chk_to_1()
           END IF
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lip.lip10 = g_lip_t.lip10
              CALL i365_desc()
              NEXT FIELD lip10
           END IF
           CALL i365_chk_lip14_lip15()
           IF NOT cl_null(g_errno) THEN
               LET g_lip.lip10 = g_lip_t.lip10
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
           END IF
         ELSE
             DISPLAY ' ' TO oba02
             LET g_lip.lip12 = ''
             LET g_lip.lip13 = ''
             DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         END IF        

      AFTER FIELD lip11
         IF NOT cl_null(g_lip.lip11) THEN
            SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa01 = g_lip.lip11 AND tqa03 = '30'
            IF l_n = 0 THEN
               CALL cl_err('','alm-780',0)
               LET g_lip.lip11 = g_lip_t.lip11
               NEXT FIELD lip11
            ELSE 
               SELECT tqa02 INTO g_tqa02 FROM tqa_file WHERE tqa01 = g_lip.lip11 AND tqa03 = '30'
               DISPLAY g_tqa02 TO tqa02 
            END IF
            IF cl_null(g_lip.lip04) THEN
                CALL i365_chk_to()
            ELSE
                CALL i365_chk_to_1()
            END IF            
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lip.lip11 = g_lip_t.lip11
               CALL i365_desc()
               NEXT FIELD lip11
            END IF
            CALL i365_chk_lip14_lip15()
            IF NOT cl_null(g_errno) THEN
                LET g_lip.lip11 = g_lip_t.lip11
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
            END IF
         ELSE
            LET g_tqa02 = ' '
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            DISPLAY g_tqa02 TO tqa02 
         END IF  

      AFTER FIELD lip14,lip15
         IF NOT cl_null(g_lip.lip14) AND NOT cl_null(g_lip.lip15)  THEN
             IF g_lip.lip14 > g_lip.lip15 THEN
                CALL cl_err('','alm1038',0)
                NEXT FIELD CURRENT
             END IF
             CALL i365_chk_lip14_lip15()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 CASE 
                    WHEN INFIELD(lip14)
                           LET g_lip.lip14 = g_lip_t.lip14
                    WHEN INFIELD(lip15)
                           LET g_lip.lip15 = g_lip_t.lip15
                 END CASE 
                 NEXT FIELD CURRENT
             END IF
             CALL i365_lip14_lip15(g_lip.lip14,g_lip.lip15,p_cmd)
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 CASE
                    WHEN INFIELD(lip14)
                           LET g_lip.lip14 = g_lip_t.lip14
                    WHEN INFIELD(lip15)
                           LET g_lip.lip15 = g_lip_t.lip15
                 END CASE
                 NEXT FIELD CURRENT
             END IF
         END IF         

      ON ACTION controlp 
         CASE 
            WHEN INFIELD(lip01)
               LET g_kindslip=s_get_doc_no(g_lip.lip01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'P2','ALM') RETURNING g_kindslip
               LET g_lip.lip01 = g_kindslip
               DISPLAY BY NAME g_lip.lip01
               NEXT FIELD lip01
            WHEN INFIELD(lip05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lil"
               LET g_qryparam.default1 = g_lip.lip05
               IF NOT cl_null(g_lip.lip04) THEN
                 LET g_lip_t.lip04 = g_lip.lip04
                 LET g_qryparam.where = " lil00 = '",g_lip.lip04,"'"
               END IF 
               CALL cl_create_qry() RETURNING g_lip.lip05,g_lip.lip04,g_lip.lip051
               IF NOT cl_null(g_lip.lip05) THEN
                  CALL i365_lip05('d')
               ELSE 
                  IF NOT cl_null(g_argv1) THEN
                     LET g_lip.lip04 = g_argv1
                  ELSE
                     LET g_lip.lip04 = g_lip_t.lip04
                  END IF 
               END IF 
               DISPLAY BY NAME g_lip.lip05,g_lip.lip04,g_lip.lip051
               NEXT FIELD lip05               
            WHEN INFIELD(lip06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj"
               LET g_qryparam.default1 = g_lip.lip06
               LET g_qryparam.where = " oajacti = 'Y' "
               CALL cl_create_qry() RETURNING g_lip.lip06
               DISPLAY BY NAME g_lip.lip06
               CALL i365_lip06()
               NEXT FIELD lip06                 
            WHEN INFIELD(lip07) #樓棟開窗
               CALL cl_init_qry_var()
               IF NOT cl_null(g_lip.lip08) THEN
                  IF NOT cl_null(g_lip.lip09) THEN
                     LET g_qryparam.form = "q_lmy01"
                     LET g_qryparam.where = " lmy02 = '",g_lip.lip08,"' AND lmy03 = '",g_lip.lip09,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form = "q_lmc02"
                     LET g_qryparam.where = " lmc03 = '",g_lip.lip08,"' AND lmcstore = '",g_lip.lipplant,"' "
                  END IF
               ELSE
                  IF NOT cl_null(g_lip.lip09) THEN
                     LET g_qryparam.form = "q_lmy01"
                     LET g_qryparam.where = " lmy03 = '",g_lip.lip09,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form = "q_lmb02"
                     LET g_qryparam.where = " lmbstore = '",g_lip.lipplant,"' "
                  END IF
               END IF
               CALL cl_create_qry() RETURNING g_lip.lip07
               DISPLAY g_lip.lip07 TO lip07
               CALL i365_desc()
               NEXT FIELD lip07
            WHEN INFIELD(lip08) #樓層開窗
               CALL cl_init_qry_var()
               IF NOT cl_null(g_liP.liP07) THEN
                  IF NOT cl_null(g_lip.lip09) THEN
                     LET g_qryparam.form ="q_lmy02"
                     LET g_qryparam.where = " lmy01 = '",g_lip.lip07,"' AND lmy03 = '",g_lip.lip09,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form ="q_lmc03"
                     LET g_qryparam.where = " lmc02 = '",g_lip.lip07,"' AND lmcstore = '",g_lip.lipplant,"' "
                  END IF
               ELSE
                  IF NOT cl_null(g_lip.lip09) THEN
                     LET g_qryparam.form ="q_lmy02"
                     LET g_qryparam.where = " lmy03 = '",g_lip.lip07,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form ="q_lmc03"
                     LET g_qryparam.where = " lmcstore = '",g_lip.lipplant,"' "
                  END IF
               END IF
               CALL cl_create_qry() RETURNING g_lip.lip08
               DISPLAY g_lip.lip08 TO lip08
               CALL i365_desc()
               NEXT FIELD lip08
            WHEN INFIELD(lip09) #區域開窗
               CALL cl_init_qry_var()
               IF NOT cl_null(g_lip.lip07) THEN
                  IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.form ="q_lmy03"
                     LET g_qryparam.where = " lmy01 = '",g_lip.lip07,"' AND lmy02 = '",g_lip.lip08,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form ="q_lmy03"
                     LET g_qryparam.where = " lmy01 = '",g_lip.lip07,"' AND lmystore = '",g_lip.lipplant,"' "
                  END IF
               ELSE
                  IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.form ="q_lmy03"
                     LET g_qryparam.where = " lmy02 = '",g_lip.lip08,"' AND lmystore = '",g_lip.lipplant,"' "
                  ELSE
                     LET g_qryparam.form ="q_lmy03"
                     LET g_qryparam.where = " lmystore = '",g_lip.lipplant,"' "
                  END IF
               END IF
               CALL cl_create_qry() RETURNING g_lip.lip09
               DISPLAY g_lip.lip09 TO lip09
               CALL i365_desc()
               NEXT FIELD lip09
            WHEN INFIELD(lip10) #小類開窗
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oba01"
               CALL cl_create_qry() RETURNING g_lip.lip10
               DISPLAY g_lip.lip10 TO lip10
               CALL i365_desc()
               NEXT FIELD lip10
            WHEN INFIELD(lip11) #攤位用途開窗
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = '30'
               LET g_qryparam.form ="q_tqa"
               CALL cl_create_qry() RETURNING g_lip.lip11
               DISPLAY g_lip.lip11 TO lip11
               CALL i365_desc()
               NEXT FIELD lip11
         END CASE    

      AFTER INPUT 
         LET g_lip.lipuser = s_get_data_owner("lip_file") #FUN-C10039
         LET g_lip.lipgrup = s_get_data_group("lip_file") #FUN-C10039
         IF cl_null(g_lip.lip05) THEN
            CALL cl_set_comp_entry("lip06,lip011",TRUE)
            CALL cl_set_comp_required("lip06,lip011",TRUE) 
         END IF 
    
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

END FUNCTION

FUNCTION i365_lip07_liq03()
DEFINE l_n    LIKE type_file.num5
DEFINE l_sql  STRING
   LET g_errno = ''
   LET l_sql = " SELECT count(*) FROM lmf_file WHERE lmf01 IN (SELECT liq03 FROM liq_file where liq01 = '",g_lip_t.lip01,"')",
               "  AND lmfstore  = '",g_lip.lipplant,"'"
   IF NOT cl_null(g_lip.lip07) THEN
      LET l_sql = l_sql," AND lmf03 = '",g_lip.lip07,"'"
   END IF 
   IF NOT cl_null(g_lip.lip08) THEN
      LET l_sql = l_sql," AND lmf04 = '",g_lip.lip08,"'"
   END IF 
   PREPARE i365_pre_lmf FROM l_sql
   EXECUTE i365_pre_lmf INTO l_n
   IF l_n = 0 THEN 
     IF NOT cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
        LET g_errno = 'alm-855'                         #樓棟+樓層下沒有對應單身的攤位
     ELSE 
       IF NOT cl_null(g_lip.lip07) AND cl_null(g_lip.lip08) THEN 
           LET g_errno = 'alm-856'                     #樓棟下沒有對應單身的攤位
       END IF 
       IF cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
           LET g_errno =  'alm-857'                     #樓層下沒有對應單身的攤位
       END IF 
     END IF 
   END IF 
END FUNCTION 

FUNCTION i365_lip14_lip15(p_stardate,p_enddate,p_cmd)
DEFINE p_stardate   LIKE lip_file.lip14,
       p_enddate    LIKE lip_file.lip15,
       l_liq04      LIKE liq_file.liq04,
       l_liq05      LIKE liq_file.liq05,
       p_cmd        LIKE type_file.chr1
   LET g_errno =''
   IF p_cmd = 'u' THEN
      SELECT MIN(liq04),MAX(liq05) INTO l_liq04,l_liq05 FROM liq_file
       WHERE liq01 = g_lip_t.lip01
      IF p_stardate > l_liq04 OR p_enddate < l_liq05 THEN
         LET g_errno = 'alm-854'
      END IF
   END IF
END FUNCTION

FUNCTION i365_chk_lip14_lip15()
DEFINE l_sql     STRING
DEFINE l_n       LIKE type_file.num5
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09

    LET g_errno = ' '
    LET l_sql = " SELECT COUNT(*) FROM lip_file WHERE lipplant = '",g_plant,"'",
                " AND lip01 <> '",g_lip.lip01,"'",
                " AND (('",g_lip.lip14,"' BETWEEN lip14 AND lip15 ",
                "        OR '",g_lip.lip15,"' BETWEEN lip14 AND lip15 ) ",
                "  OR (lip14 BETWEEN '",g_lip.lip14,"'  AND '",g_lip.lip15,"'",
                "        OR lip15 BETWEEN '",g_lip.lip14,"'  AND '",g_lip.lip15,"'))",
                " AND lipconf <> 'S' "

    IF NOT cl_null(g_lip.lip06) THEN
      SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
        FROM lnl_file WHERE lnl01 = g_lip.lip06
                        AND lnlstore = g_lip.lipplant
                        AND lnlacti = 'Y'
    ELSE 
         RETURN
    END IF 
    IF NOT cl_null( g_lip.lip06) THEN
       LET l_sql = l_sql," AND lip06 = '",g_lip.lip06,"'"
    END IF
    IF l_lnl03 = 'Y' THEN
       IF NOT cl_null( g_lip.lip07) THEN
          LET l_sql = l_sql," AND lip07 = '",g_lip.lip07,"'"
       ELSE 
          RETURN
       END IF 
    END IF 
    IF l_lnl04 = 'Y' THEN
       IF NOT cl_null( g_lip.lip08) THEN
          LET l_sql = l_sql," AND lip08 = '",g_lip.lip08,"'"
       ELSE 
          RETURN
       END IF
    END IF 
    IF l_lnl05 = 'Y' THEN
       IF NOT cl_null( g_lip.lip09) THEN
          LET l_sql = l_sql," AND lip09 = '",g_lip.lip09,"'"
       ELSE 
          RETURN
       END IF
    END IF 
    IF l_lnl09 = 'Y' THEN
       IF NOT cl_null( g_lip.lip10) THEN
          LET l_sql = l_sql," AND lip10 = '",g_lip.lip10,"'"
       ELSE 
          RETURN 
       END IF
    END IF 
    IF NOT cl_null( g_lip.lip11) THEN
       LET l_sql = l_sql," AND lip11 = '",g_lip.lip11,"'"
    ELSE 
       RETURN    
    END IF
    PREPARE sel_num_pre FROM l_sql
    EXECUTE  sel_num_pre INTO l_n
    IF l_n > 0 THEN
       LET g_errno = 'alm-882'
    END IF
END FUNCTION


FUNCTION i365_chk_lip07()
DEFINE l_n        LIKE type_file.num5
DEFINE l_n1       LIKE type_file.num5
DEFINE l_n2       LIKE type_file.num5
DEFINE l_lmb06    LIKE lmb_file.lmb06

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lmb_file WHERE lmb02 = g_lip.lip07
                                            AND lmbstore = g_plant
   IF l_n = 0 THEN
      LET g_errno = 'alm-003'
      RETURN
   ELSE
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lip.lip06
                                                AND lik03 = '*' AND likstore = g_lip.lipplant
      IF l_n1 = 0 THEN
         SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lip.lip06
                                                   AND lik03 = g_lip.lip07 AND likstore = g_lip.lipplant
         IF l_n2 = 0 THEN
            LET g_errno = 'alm-865'
            RETURN
         END IF
      END IF
      SELECT lmb06 INTO l_lmb06 FROM lmb_file WHERE lmb02 = g_lip.lip07 AND lmbstore = g_plant
      IF l_lmb06 = 'N' THEN
         LET g_errno = 'alm-905'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION i365_chk_lip08()
DEFINE l_n      LIKE type_file.num5
DEFINE l_n1     LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_lmc07  LIKE lmc_file.lmc07

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lmc_file WHERE lmc03 = g_lip.lip08 AND lmcstore = g_plant
   IF l_n = 0 THEN
      LET g_errno = 'alm-554'
      RETURN
   ELSE
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lip.lip06
                                                AND lik04 = '*'
      IF l_n1 = 0 THEN
         SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lip.lip06
                                                   AND lik04 = g_lip.lip08
            IF l_n2 = 0 THEN
               LET g_errno = 'alm-866'
               RETURN
            END IF
      END IF
      IF NOT cl_null(g_lip.lip07) THEN
         SELECT lmc07 INTO l_lmc07 FROM  lmc_file  WHERE lmc03 = g_lip.lip08 AND lmcstore = g_plant
                                                     AND lmc02 = g_lip.lip07
         IF SQLCA.SQLCODE = 100 THEN
            LET g_errno = 'alm-847'
            RETURN
         END IF
         IF l_lmc07 = 'N' THEN
            LET g_errno = 'alm-908'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i365_chk_lip09()
DEFINE l_n       LIKE type_file.num5
DEFINE l_n1      LIKE type_file.num5
DEFINE l_n2      LIKE type_file.num5
DEFINE l_lmyacti LIKE lmy_file.lmyacti

   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lmy_file WHERE lmy03 = g_lip.lip09 AND lmystore = g_plant
   IF l_n = 0 THEN
      LET g_errno = 'alm-767'
      RETURN
   ELSE
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lip.lip06
                                                AND lik05 = '*'
      IF l_n1 = 0 THEN
         SELECT COUNT(*) INTO l_n2 FROM lik_file WHERE lik01 = g_lip.lip06
                                                   AND lik05 = g_lip.lip09
            IF l_n2 = 0 THEN
               LET g_errno = 'alm-867'
               RETURN
            END IF
      END IF
      IF NOT cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
         SELECT lmyacti INTO l_lmyacti FROM  lmy_file  WHERE lmy03 = g_lip.lip09 AND lmystore = g_plant
                                                     AND lmy02 = g_lip.lip08 AND lmy01 = g_lip.lip07
         IF l_lmyacti = 'N' THEN
            LET g_errno = 'alm-747'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION


FUNCTION i365_chk_lip10()
DEFINE l_n         LIKE type_file.num5
DEFINE l_n1        LIKE type_file.num5
DEFINE l_obaacti   LIKE oba_file.obaacti

   LET g_errno = ' '
   SELECT obaacti INTO l_obaacti FROM oba_file WHERE oba01 = g_lip.lip10
   IF STATUS = 100 THEN
      LET g_errno = 'alm-104'
      RETURN
   ELSE
      IF SQLCA.SQLCODE = 0 AND l_obaacti = 'N' THEN
        LET g_errno = 'alm-781'
        RETURN
      END IF
   END IF
   SELECT COUNT(*) INTO l_n FROM lik_file WHERE lik01 = g_lip.lip06
                                            AND lik06 = '*'
   IF l_n = 0 THEN
      SELECT COUNT(*) INTO l_n1 FROM lik_file WHERE lik01 = g_lip.lip06
                                                AND lik06 = g_lip.lip10 
      IF l_n1 = 0 THEN
        LET g_errno = 'alm-868'
        RETURN
      END IF
    END IF
END FUNCTION

FUNCTION i365_desc()
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_azt02    LIKE azt_file.azt02
DEFINE l_tqa02    LIKE tqa_file.tqa02
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_gen02_1  LIKE gen_file.gen02
DEFINE l_gen02_2  LIKE gen_file.gen02
DEFINE l_lmb03    LIKE lmb_file.lmb03
DEFINE l_lmc04    LIKE lmc_file.lmc04
DEFINE l_lmy04    LIKE lmy_file.lmy04
DEFINE l_oba02    LIKE oba_file.oba02

   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lip.lip06
   DISPLAY l_oaj02 TO oaj02 
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_plant
   DISPLAY l_rtz13 TO rtz13 
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lip.liplegal
   DISPLAY l_azt02 TO azt02 
   SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmbstore = g_lip.lipplant AND lmb02 = g_lip.lip07
   DISPLAY l_lmb03  TO lmb03 
   IF NOT cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
      SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lip.lipplant AND lmc02 = g_lip.lip07 AND lmc03 = g_lip.lip08
   ELSE 
     IF NOT cl_null(g_lip.lip08) THEN
        SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lip.lipplant AND lmc03 = g_lip.lip08
        IF SQLCA.sqlcode = -284 THEN
          LET l_lmc04 = ''
        END IF 
     END IF 
   END IF 
   DISPLAY l_lmc04  TO lmc04
   IF NOT cl_null(g_lip.lip09) AND NOT cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
      SELECT lmy04 INTO l_lmy04 FROM lmy_file WHERE lmystore = g_lip.lipplant AND lmy01 = g_lip.lip07
                                                AND lmy02 = g_lip.lip08 AND lmy03 = g_lip.lip09             
   ELSE 
      IF NOT cl_null(g_lip.lip07) AND cl_null(g_lip.lip08) THEN
         SELECT lmy04 INTO l_lmy04 FROM lmy_file WHERE lmystore = g_lip.lipplant AND lmy03 = g_lip.lip09
                                                   AND lmy01 = g_lip.lip07
         IF SQLCA.sqlcode = -284 THEN
            LET l_lmy04 = ''
         END IF
      ELSE 
         IF cl_null(g_lip.lip07) AND NOT cl_null(g_lip.lip08) THEN
            SELECT lmy04 INTO l_lmy04 FROM lmy_file WHERE lmystore = g_lip.lipplant AND lmy03 = g_lip.lip09
                                                           AND lmy02 = g_lip.lip08
            IF SQLCA.sqlcode = -284 THEN
               LET l_lmy04 = ''
            END IF
         ELSE 
            SELECT lmy04 INTO l_lmy04 FROM lmy_file WHERE lmystore = g_lip.lipplant AND lmy03 = g_lip.lip09
            IF SQLCA.sqlcode = -284 THEN
               LET l_lmy04 = ''
            END IF
         END IF 
      END IF 
      IF SQLCA.sqlcode = -284 THEN
         LET l_lmy04 = ''
      END IF
   END IF 
   DISPLAY l_lmy04  TO lmy04
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lip.lip10
   DISPLAY l_oba02  TO oba02
   SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = g_lip.lip11 AND tqa03 = '30'
   DISPLAY l_tqa02  TO tqa02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lip.lip17
   DISPLAY l_gen02 TO gen02
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lip.lipconu
   DISPLAY l_gen02_1 TO gen02_1
   SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = g_lip.lip20
   DISPLAY l_gen02_2 TO gen02_2

END FUNCTION

FUNCTION i365_chk_to()          #如先有門店+樓棟+樓層+區域+小類+攤位用途帶出方案類型
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09
DEFINE l_lik10    LIKE lik_file.lik10
DEFINE l_sql      STRING
   LET g_errno = ' '
   IF NOT cl_null(g_lip.lip06) THEN 
      SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
        FROM lnl_file WHERE lnl01 = g_lip.lip06
                        AND lnlstore = g_lip.lipplant
                        AND lnlacti = 'Y'
      LET l_sql = " SELECT lik08,lik09,lik10 FROM lik_file WHERE lik01 = '",g_lip.lip06,"'",
                                                            " AND likstore = '",g_lip.lipplant,"'"
      IF NOT cl_null( g_lip.lip11) THEN
         LET l_sql = l_sql,"  AND lik07 = '",g_lip.lip11,"'" 
      ELSE 
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
         DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         RETURN
      END IF 
      IF l_lnl03 = 'Y' THEN
         IF NOT cl_null(g_lip.lip07) THEN
            LET l_sql = l_sql," AND (lik03 = '",g_lip.lip07,"' OR lik03 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl04 = 'Y' THEN
         IF NOT cl_null(g_lip.lip08) THEN
            LET l_sql = l_sql," AND (lik04 = '",g_lip.lip08,"' OR lik04 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl05 = 'Y' THEN
         IF NOT cl_null(g_lip.lip09) THEN
            LET l_sql = l_sql," AND (lik05 = '",g_lip.lip09,"' OR lik05 = '*') "
         ELSE
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl09 = 'Y' THEN
         IF NOT cl_null(g_lip.lip10) THEN
            LET l_sql = l_sql," AND (lik06 = '",g_lip.lip10,"' OR lik06 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      PREPARE sel_lik_pre FROM l_sql
      EXECUTE sel_lik_pre INTO g_lip.lip12,g_lip.lip13,l_lik10
      IF sqlca.sqlcode = 100 THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
         LET l_lik10 = ''
         DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         LET g_errno = 'alm-869'
      END IF
      IF cl_null(g_errno) AND NOT cl_null(g_argv1) THEN
         IF l_lik10 <> g_argv1 THEN
              LET g_errno = 'alm-883'
              LET g_lip.lip12 = ''
              LET g_lip.lip13 = ''
              LET g_lip.lip04 = g_argv1
          END IF    
      END IF 
      IF cl_null(g_errno) THEN
         LET g_lip.lip04 = l_lik10
      END IF 
      CASE g_lip.lip04
         WHEN '1'
           CALL cl_set_comp_visible('Page4,Page5',FALSE)
           CALL cl_set_comp_visible('Page3',TRUE)
         WHEN '2'
           CALL cl_set_comp_visible('Page3,Page5',FALSE)
           CALL cl_set_comp_visible('Page4',TRUE)
         WHEN '3'
           CALL cl_set_comp_visible('Page3,Page4',FALSE)
           CALL cl_set_comp_visible('Page5',TRUE)
      END CASE
      DISPLAY BY NAME g_lip.lip04,g_lip.lip06,g_lip.lip07,
                      g_lip.lip08,g_lip.lip09,g_lip.lip10,
                      g_lip.lip11,g_lip.lip12,g_lip.lip13
   END IF

END FUNCTION

FUNCTION i365_chk_to_1()              #如先有方案類型，後輸入門店+樓棟+樓層+區域+小類+攤位用途
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09
DEFINE l_lip12    LIKE lip_file.lip12
DEFINE l_lip13    LIKE lip_file.lip13
DEFINE l_lik10    LIKE lik_file.lik10
DEFINE l_sql      STRING
   LET g_errno = ' '
   IF NOT cl_null(g_lip.lip06) THEN
      SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
        FROM lnl_file WHERE lnl01 = g_lip.lip06 
                        AND lnlstore = g_lip.lipplant
                        AND lnlacti = 'Y'
      LET l_sql = " SELECT lik08,lik09,lik10 FROM lik_file WHERE lik01 = '",g_lip.lip06,"'",
                                                           " AND likstore = '",g_lip.lipplant,"'"
      IF NOT cl_null( g_lip.lip11) THEN
        LET l_sql = l_sql,"  AND lik07 = '",g_lip.lip11,"'"
      ELSE
        LET g_lip.lip12 = ''
        LET g_lip.lip13 = ''
        DISPLAY BY NAME g_lip.lip12,g_lip.lip13 
        RETURN
      END IF
      IF l_lnl03 = 'Y' THEN
         IF NOT cl_null(g_lip.lip07) THEN
            LET l_sql = l_sql," AND (lik03 = '",g_lip.lip07,"' OR lik03 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl04 = 'Y' THEN
         IF NOT cl_null(g_lip.lip08) THEN
            LET l_sql = l_sql," AND (lik04 = '",g_lip.lip08,"' OR lik04 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl05 = 'Y' THEN
         IF NOT cl_null(g_lip.lip09) THEN
            LET l_sql = l_sql," AND (lik05 = '",g_lip.lip09,"' OR lik05 = '*') "
         ELSE 
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      IF l_lnl09 = 'Y' THEN
         IF NOT cl_null(g_lip.lip10) THEN
            LET l_sql = l_sql," AND (lik06 = '",g_lip.lip10,"' OR lik06 = '*') "
         ELSE
            LET g_lip.lip12 = ''
            LET g_lip.lip13 = ''
            DISPLAY BY NAME g_lip.lip12,g_lip.lip13
            RETURN
         END IF
      END IF
      PREPARE sel_lik_pre_2 FROM l_sql
      EXECUTE sel_lik_pre_2 INTO l_lip12,l_lip13,l_lik10
      IF sqlca.sqlcode = 100 THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
         LET l_lik10 = ''
         DISPLAY BY NAME g_lip.lip12,g_lip.lip13
         LET g_errno = 'alm-869'
      END IF
      IF cl_null(g_errno) AND l_lik10 <>  g_lip.lip04 AND cl_null(g_argv1) THEN
          LET g_errno = 'alm-887'
      END IF
      IF cl_null(g_errno) AND l_lik10 <> g_argv1 AND NOT cl_null(g_argv1) THEN
           LET g_errno = 'alm-883'
           LET g_lip.lip12 = ''
           LET g_lip.lip13 = ''
           LET g_lip.lip04 = g_argv1
      END IF 
      IF cl_null(g_errno) AND (l_lik10 = g_lip.lip04 OR l_lik10 = g_argv1) THEN
          LET g_lip.lip04 = l_lik10
          LET g_lip.lip12 = l_lip12 
          LET g_lip.lip13 = l_lip13  
          DISPLAY BY NAME g_lip.lip04,g_lip.lip12,g_lip.lip13
      END IF
      IF cl_null(g_errno) THEN
         CASE g_lip.lip04
            WHEN '1'
              CALL cl_set_comp_visible('Page4,Page5',FALSE)
              CALL cl_set_comp_visible('Page3',TRUE)
            WHEN '2'
              CALL cl_set_comp_visible('Page3,Page5',FALSE)
              CALL cl_set_comp_visible('Page4',TRUE)
            WHEN '3'
              CALL cl_set_comp_visible('Page3,Page4',FALSE)
              CALL cl_set_comp_visible('Page5',TRUE)
         END CASE
         DISPLAY BY NAME g_lip.lip04,g_lip.lip06,g_lip.lip07,
                         g_lip.lip08,g_lip.lip09,g_lip.lip10,
                         g_lip.lip11,g_lip.lip12,g_lip.lip13
       END IF 
   END IF

END FUNCTION

FUNCTION i365_lip04()
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09
DEFINE l_sql      STRING
DEFINE l_lik      DYNAMIC ARRAY OF RECORD
                  lik08  LIKE lik_file.lik08,
                  lik09  LIKE lik_file.lik09,
                  lik10  LIKE lik_file.lik10
                  END RECORD
DEFINE l_cnt      LIKE type_file.num5
   LET g_errno = ' '
   IF NOT cl_null(g_lip.lip06) THEN
      SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
        FROM lnl_file WHERE lnl01 = g_lip.lip06
      LET l_sql = " SELECT lik08,lik09,lik10 FROM lik_file WHERE lik01 = '",g_lip.lip06,"'",
                                                           " AND likstore = '",g_lip.lipplant,"'"
      IF NOT cl_null( g_lip.lip11) THEN
      LET l_sql = l_sql,"  AND lik07 = '",g_lip.lip11,"'" 
      END if 
      IF l_lnl03 = 'Y' THEN
         IF NOT cl_null(g_lip.lip07) THEN
            LET l_sql = l_sql," AND (lik03 = '",g_lip.lip07,"' OR lik03 = '*') "
         END IF
      END IF
      IF l_lnl04 = 'Y' THEN
         IF NOT cl_null(g_lip.lip08) THEN
            LET l_sql = l_sql," AND (lik04 = '",g_lip.lip08,"' OR lik04 = '*') "
         END IF
      END IF
      IF l_lnl05 = 'Y' THEN
         IF NOT cl_null(g_lip.lip09) THEN
            LET l_sql = l_sql," AND (lik05 = '",g_lip.lip09,"' OR lik05 = '*') "
         END IF
      END IF
      IF l_lnl09 = 'Y' THEN
         IF NOT cl_null(g_lip.lip10) THEN
            LET l_sql = l_sql," AND (lik06 = '",g_lip.lip10,"' OR lik06 = '*') "
         END IF
      END IF
      DECLARE sel_like_pre_cs CURSOR FROM l_sql
      LET l_cnt =1
      FOREACH sel_like_pre_cs INTO l_lik[l_cnt].*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            EXIT FOREACH
         END IF
         IF l_lik[l_cnt].lik10 <>  g_lip.lip04 THEN
             LET g_errno = 'alm-887'  
         END IF 
         IF l_lik[l_cnt].lik10 = g_lip.lip04 THEN
             LET g_lip.lip04 = l_lik[l_cnt].lik10
             LET g_lip.lip12 = l_lik[l_cnt].lik08
             LET g_lip.lip13 = l_lik[l_cnt].lik09
             DISPLAY BY NAME g_lip.lip04,g_lip.lip12,g_lip.lip13
             LET g_errno = ''
             RETURN
         END IF 
         LET l_cnt = l_cnt + 1      
      END FOREACH
   END IF 
   IF cl_null(g_errno) THEN
      CASE g_lip.lip04
          WHEN '1'
            CALL cl_set_comp_visible('Page4,Page5',FALSE)
            CALL cl_set_comp_visible('Page3',TRUE)
          WHEN '2'
            CALL cl_set_comp_visible('Page3,Page5',FALSE)
            CALL cl_set_comp_visible('Page4',TRUE)
          WHEN '3'
            CALL cl_set_comp_visible('Page3,Page4',FALSE)
            CALL cl_set_comp_visible('Page5',TRUE)
      END CASE
   END IF 
END FUNCTION

FUNCTION i365_lip05(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_lip   RECORD LIKE lip_file.*
DEFINE l_lil   RECORD LIKE lil_file.*
   LET g_errno =''
   SELECT * INTO l_lil.* FROM lil_file
    WHERE lil01 = g_lip.lip05
   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1093'
      WHEN l_lil.lilacti = 'N'  LET g_errno = 'alm1082'
      WHEN l_lil.lilconf = 'N'  LET g_errno = 'alm1094'
      WHEN l_lil.lilconf = 'S'  LET g_errno = 'alm-884'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      IF NOT cl_null(g_lip.lip04) THEN
         IF l_lil.lil00 <> g_lip.lip04 THEN
            LET g_errno = 'alm-886'      #方案類型與來源方案對應的方案類型不一致！ 
         END IF 
      END IF 
   END IF 
   IF cl_null(g_errno) THEN
      CALL i365_checkexpense(l_lil.lil04,l_lil.lilplant,l_lil.lil05,l_lil.lil06,l_lil.lil07,
                             l_lil.lil08,l_lil.lil09,l_lil.lil10,l_lil.lil11)
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF cl_null(g_lip.lip04)  AND cl_null(g_errno) THEN
           LET g_lip.lip04 = l_lil.lil00
      END IF 
      LET g_lip.lip051 = l_lil.lil02
      LET g_lip.lip06 = l_lil.lil04
      IF NOT cl_null(l_lil.lilplant) THEN
         LET g_lip.lipplant = l_lil.lilplant
         LET g_lip.liplegal = l_lil.lillegal
      END IF 
      LET g_lip.lip07 = l_lil.lil05
      LET g_lip.lip08 = l_lil.lil06
      LET g_lip.lip09 = l_lil.lil07
      LET g_lip.lip10 = l_lil.lil08
      LET g_lip.lip11 = l_lil.lil09
      LET g_lip.lip12 = l_lil.lil10
      LET g_lip.lip13 = l_lil.lil11
      DISPLAY BY NAME g_lip.lip04,g_lip.lip051,g_lip.lip06,g_lip.lipplant,g_lip.liplegal,
                      g_lip.lip07,g_lip.lip08,g_lip.lip09,
                      g_lip.lip10,g_lip.lip11,g_lip.lip12,g_lip.lip13
   END IF
   IF cl_null(g_errno) THEN
      CASE g_lip.lip04
          WHEN '1'
            CALL cl_set_comp_visible('Page4,Page5',FALSE)
            CALL cl_set_comp_visible('Page3',TRUE)
          WHEN '2'
            CALL cl_set_comp_visible('Page3,Page5',FALSE)
            CALL cl_set_comp_visible('Page4',TRUE)
          WHEN '3'
            CALL cl_set_comp_visible('Page3,Page4',FALSE)
            CALL cl_set_comp_visible('Page5',TRUE)
      END CASE
   END IF 
END FUNCTION

FUNCTION i365_checkexpense(l_lil04,l_lilplant,l_lil05,l_lil06,l_lil07,
                           l_lil08,l_lil09,l_lil10,l_lil11)
DEFINE
   l_lil04    LIKE lil_file.lil04,#费用编号
   l_lilplant LIKE lil_file.lilplant,#门店
   l_lil05    LIKE lil_file.lil05,#楼栋编号
   l_lil06    LIKE lil_file.lil06,#楼层编号
   l_lil07    LIKE lil_file.lil07,#区域编号
   l_lil08    LIKE lil_file.lil08,#小类编号
   l_lil09    LIKE lil_file.lil09,#摊位用途
   l_lil10    LIKE lil_file.lil10,#日期类型
   l_lil11    LIKE lil_file.lil11,#定义方式
   l_lnl03    LIKE lnl_file.lnl03,#楼栋
   l_lnl04    LIKE lnl_file.lnl04,#楼层
   l_lnl05    LIKE lnl_file.lnl05,#区域
   l_lnl09    LIKE lnl_file.lnl09,#小类
   l_n        LIKE type_file.chr1,
   l_sql      STRING
   SELECT lnl03,lnl04,lnl05,lnl09
     INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = l_lil04 AND lnlstore = l_lilplant
   CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm1031'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      #判断方案中NOT NULL的栏位在almi350参数中是否有勾选
      IF NOT cl_null(l_lil05) AND l_lnl03 = 'N' THEN
         LET g_errno= 'alm1084'
      ELSE
         IF NOT cl_null(l_lil06) AND l_lnl04 = 'N' THEN
            LET g_errno= 'alm1084'
         ELSE
            IF NOT cl_null(l_lil07) AND l_lnl05 = 'N' THEN
               LET g_errno= 'alm1084'
            ELSE
               IF NOT cl_null(l_lil08) AND l_lnl09 = 'N' THEN
                  LET g_errno= 'alm1084'
               END IF
            END IF
         END IF
      END IF
      IF cl_null(g_errno) THEN
       #参数中的日期类型，定义方法，定义方式，摊位用途与方案中的是否一致
         LET l_sql = " SELECT count(*) FROM lik_file",
                     "  WHERE lik01 ='",l_lil04,"'",
                     "    AND lik07 ='",l_lil09,"'",
                     "    AND lik08 ='",l_lil10,"'",
                     "    AND lik09 ='",l_lil11,"'"
         IF NOT cl_null(l_lil05) THEN
            LET l_sql = l_sql," AND lik03 = '",l_lil05,"' OR lik03 = '*' "
         END IF 
         IF NOT cl_null(l_lil06) THEN
            LET l_sql = l_sql," AND lik04 = '",l_lil06,"' OR lik04 = '*' "
         END IF
         IF NOT cl_null(l_lil07) THEN
            LET l_sql = l_sql," AND lik05 = '",l_lil07,"' OR lik05 = '*' "
         END IF
         IF NOT cl_null(l_lil08) THEN
            LET l_sql = l_sql," AND lik06 = '",l_lil08,"' OR lik06 = '*' "
         END IF  
         PREPARE i365_pre_l FROM l_sql       
         EXECUTE i365_pre_l INTO l_n
         IF l_n = 0 THEN
            LET g_errno= 'alm1084'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i365_chk_lip06()
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_n        LIKE type_file.num5
DEFINE l_lnlacti  LIKE lnl_file.lnlacti
DEFINE l_lnl03    LIKE lnl_file.lnl03
DEFINE l_lnl04    LIKE lnl_file.lnl04
DEFINE l_lnl05    LIKE lnl_file.lnl05
DEFINE l_lnl09    LIKE lnl_file.lnl09
DEFINE l_sql      STRING 
  LET g_errno = ' '
  SELECT COUNT(*) INTO l_n FROM lnl_file WHERE lnl01 = g_lip.lip06
                                           AND lnlstore = g_lip.lipplant
  IF l_n = 0 THEN
     LET g_errno = 'alm-864'
     RETURN
  ELSE
    SELECT lnlacti INTO  l_lnlacti FROM lnl_file WHERE lnl01 = g_lip.lip06
                                                   AND lnlstore = g_lip.lipplant
    IF l_lnlacti = 'N' THEN
       LET g_errno = 'alm1032'
       RETURN
    END IF
  END IF
  
  SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
    FROM lnl_file WHERE lnl01 = g_lip.lip06
                    AND lnlstore = g_lip.lipplant
                    AND lnlacti = 'Y'
  LET l_sql = " SELECT COUNT(lik01) FROM lik_file WHERE likstore = '",g_lip.lipplant,"'",
              " AND lik01 = '",g_lip.lip06,"'"
  IF l_lnl03 = 'Y' THEN
     IF NOT cl_null( g_lip.lip07) THEN
        LET l_sql = l_sql," AND (lik03 = '",g_lip.lip07,"' OR lik03 = '*') "
     ELSE
        RETURN
     END IF
  END IF
  IF l_lnl04 = 'Y' THEN
     IF NOT cl_null( g_lip.lip08) THEN
        LET l_sql = l_sql," AND (lik04 = '",g_lip.lip08,"' OR lik04 = '*') "
     ELSE
        RETURN
     END IF
  END IF
  IF l_lnl05 = 'Y' THEN
     IF NOT cl_null( g_lip.lip09) THEN
        LET l_sql = l_sql," AND (lik05 = '",g_lip.lip09,"' OR lik05 = '*') "
     ELSE
        RETURN
     END IF
  END IF
  IF l_lnl09 = 'Y' THEN
     IF NOT cl_null( g_lip.lip10) THEN
        LET l_sql = l_sql," AND lik06 = '",g_lip.lip10,"'"
     ELSE
        RETURN
     END IF
  END IF
  IF NOT cl_null( g_lip.lip11) THEN
     LET l_sql = l_sql," AND lik07 = '",g_lip.lip11,"'"
  ELSE
     RETURN
  END IF
  PREPARE sel_lik01_pre FROM l_sql
  EXECUTE  sel_lik01_pre INTO l_n
  IF l_n = 0 THEN
     LET g_errno = 'alm-858'
  END IF 
END FUNCTION

FUNCTION  i365_lip06()
DEFINE  l_lnl03   LIKE lnl_file.lnl03
DEFINE  l_lnl04   LIKE lnl_file.lnl04
DEFINE  l_lnl05   LIKE lnl_file.lnl05
DEFINE  l_lnl09   LIKE lnl_file.lnl09
DEFINE  l_oaj02   LIKE oaj_file.oaj02

   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file WHERE lnl01 = g_lip.lip06 AND lnlstore = g_lip.lipplant
   IF l_lnl03 = 'Y' THEN
      IF cl_null(g_lip.lip07) OR cl_null(g_lip.lip11) THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
      END IF 
      CALL cl_set_comp_entry("lip07",TRUE)
      CALL cl_set_comp_required("lip07",TRUE)
   ELSE
      LET g_lip.lip07 = ''
      CALL cl_set_comp_required("lip07",FALSE)
      CALL cl_set_comp_entry("lip07",FALSE)
   END IF
   IF l_lnl04 = 'Y' THEN
      IF cl_null(g_lip.lip08) OR cl_null(g_lip.lip11) THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
      END IF
      CALL cl_set_comp_entry("lip08",TRUE)
      CALL cl_set_comp_required("lip08",TRUE)
   ELSE
      LET g_lip.lip08 = ''
      CALL cl_set_comp_required("lip08",FALSE)
      CALL cl_set_comp_entry("lip08",FALSE)
   END IF
   IF l_lnl05 = 'Y' THEN
      IF cl_null(g_lip.lip09) OR cl_null(g_lip.lip11) THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
      END IF
      CALL cl_set_comp_entry("lip09",TRUE)
      CALL cl_set_comp_required("lip09",TRUE)
   ELSE
      LET g_lip.lip09 = ''
      CALL cl_set_comp_required("lip09",FALSE)
      CALL cl_set_comp_entry("lip09",FALSE)
   END IF
   IF l_lnl09 = 'Y' THEN
      IF cl_null(g_lip.lip10) OR cl_null(g_lip.lip11) THEN
         LET g_lip.lip12 = ''
         LET g_lip.lip13 = ''
      END IF
      CALL cl_set_comp_entry("lip10",TRUE)
      CALL cl_set_comp_required("lip10",TRUE)
   ELSE
      LET g_lip.lip10 = ''
      CALL cl_set_comp_required("lip10",FALSE)
      CALL cl_set_comp_entry("lip10",FALSE)
   END IF
   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lip.lip06 
   DISPLAY l_oaj02 TO oaj02 
   DISPLAY BY NAME  g_lip.lip07,g_lip.lip08,g_lip.lip09,
                    g_lip.lip10,g_lip.lip12,g_lip.lip13
END FUNCTION



FUNCTION i365_q()
   CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CLEAR FORM
   CALL g_liq.clear()
   DISPLAY ' ' TO FORMONLY.cn1

   CALL i365_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lip.* TO NULL
      RETURN
   END IF

   OPEN i365_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lip.* TO NULL
   ELSE
      OPEN i365_count
      FETCH i365_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn1

      CALL i365_fetch('F')
   END IF

END FUNCTION

FUNCTION i365_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i365_cs INTO g_lip.lip01
      WHEN 'P' FETCH PREVIOUS i365_cs INTO g_lip.lip01
      WHEN 'F' FETCH FIRST    i365_cs INTO g_lip.lip01
      WHEN 'L' FETCH LAST     i365_cs INTO g_lip.lip01
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
            FETCH ABSOLUTE g_jump i365_cs INTO g_lip.lip01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
      INITIALIZE g_lip.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx1
   END IF

   SELECT * INTO g_lip.* FROM lip_file WHERE lip01 = g_lip.lip01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lip_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lip.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lip.lipuser
   LET g_data_group = g_lip.lipgrup
   CALL i365_show()
END FUNCTION

FUNCTION i365_show()

   LET g_lip_t.* = g_lip.*
   LET g_lip_o.* = g_lip.*
   DISPLAY BY NAME g_lip.lip01,g_lip.lip02,
                   g_lip.lip03,g_lip.lip04,g_lip.lip05,
                   g_lip.lip051,g_lip.lip06,g_lip.lipplant,g_lip.liplegal,
                   g_lip.lip07,g_lip.lip08,g_lip.lip09,g_lip.lip10,g_lip.lip11,
                   g_lip.lip12,g_lip.lip13,g_lip.lip14,g_lip.lip15,g_lip.lip16,
                   g_lip.lip17,g_lip.lip18,g_lip.lipmksg,g_lip.lip19,g_lip.lip20,
                   g_lip.lip21,g_lip.lip22,
                   g_lip.lipconf,g_lip.lipconu,
                   g_lip.lipcond,g_lip.lipcont,g_lip.lip05,
                   g_lip.lipuser,g_lip.lipgrup,
                   g_lip.liporiu,g_lip.lipmodu,
                   g_lip.lipdate,g_lip.liporig,
                   g_lip.lipacti,g_lip.lipcrat
   CALL i365_desc()
   CASE g_lip.lip04
      WHEN '1'
        CALL cl_set_comp_visible('Page4,Page5',FALSE)
        CALL cl_set_comp_visible('Page3',TRUE)
      WHEN '2'
        CALL cl_set_comp_visible('Page3,Page5',FALSE)
        CALL cl_set_comp_visible('Page4',TRUE)
      WHEN '3'
        CALL cl_set_comp_visible('Page3,Page4',FALSE)
        CALL cl_set_comp_visible('Page5',TRUE)
   END CASE   
   CALL cl_set_field_pic(g_lip.lipconf,"","","","","")
   CALL i365_b_fill(g_wc1)
   CALL i365_b1_fill(g_wc2)
   CALL i365_b2_fill(g_wc3)
   CALL i365_liq09('d')
   CALL i365_liq09_1('d')
   CALL i365_liq09_2('d')
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i365_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lip.lip01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lip.lipconf = 'Y' THEN 
      CALL cl_err('','alm1061',0)
      RETURN
   END IF 
   BEGIN WORK
   IF g_lip.lipconf='S' THEN
      CALL cl_err('','alm-931',0)
      RETURN
   END IF

   OPEN i365_cl USING g_lip.lip01
   IF STATUS THEN
      CALL cl_err("OPEN i365_cl:", STATUS, 1)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i365_cl INTO g_lip.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL i365_show()

   IF cl_exp(0,0,g_lip.lipacti) THEN
      IF g_lip.lipacti='Y' THEN
         LET g_lip.lipacti='N'
      ELSE
         LET g_lip.lipacti='Y'
      END IF

      UPDATE lip_file SET lipacti=g_lip.lipacti,
                          lipmodu=g_user,
                          lipdate=g_today
       WHERE lip01=g_lip.lip01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lip_file",g_lip.lip01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE i365_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lip.lip01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lipacti,lipmodu,lipdate
   INTO g_lip.lipacti,g_lip.lipmodu,
        g_lip.lipdate FROM lip_file
   WHERE lip01=g_lip.lip01
   DISPLAY BY NAME g_lip.lipacti,g_lip.lipmodu,
                   g_lip.lipdate

END FUNCTION

FUNCTION i365_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lip.lip01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lip.lipconf = 'Y' THEN
      CALL cl_err('','abm-881',0)
      RETURN
   END IF
   IF g_lip.lipconf = 'S' THEN
      CALL cl_err('','alm-932',0)
      RETURN
   END IF
   IF g_lip.lipacti = 'N' THEN
      CALL cl_err('','abm-033',0)
      RETURN
   END IF 
   SELECT * INTO g_lip.* FROM lip_file
    WHERE lip01=g_lip.lip01
   BEGIN WORK

   OPEN i365_cl USING g_lip.lip01
   IF STATUS THEN
      CALL cl_err("OPEN i365_cl:", STATUS, 1)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i365_cl INTO g_lip.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL i365_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "lip01"
       LET g_doc.value1 = g_lip.lip01
       CALL cl_del_doc()
      DELETE FROM lip_file WHERE lip01 = g_lip.lip01
      DELETE FROM liq_file WHERE liq01 = g_lip.lip01
      CLEAR FORM
      CALL g_liq.clear()
      OPEN i365_count
      FETCH i365_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn1
      OPEN i365_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i365_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i365_fetch('/')
      END IF
   END IF

   CLOSE i365_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lip.lip01,'D')
END FUNCTION

FUNCTION i365_b()
DEFINE
    l_n             LIKE type_file.num5,
    l_i1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE 
       l_imaacti    LIKE ima_file.imaacti,
       l_gfeacti    LIKE gfe_file.gfeacti

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lip.lip01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_lip.* FROM lip_file
     WHERE lip01=g_lip.lip01

    IF g_lip.lipacti ='N' THEN
       CALL cl_err(g_lip.lip01,'mfg1000',0)
       RETURN
    END IF

    IF g_lip.lipconf = 'Y' THEN
       CALL cl_err('','9022',0)
       RETURN
    END IF      

    IF g_lip.lipconf='S' THEN
       CALL cl_err('','alm1048',0)
       RETURN
    END IF
    LET g_forupd_sql = "SELECT liq02,liq03,liq04,liq05,liq06,liq061,liq09",
                       "  FROM liq_file",
                       "  WHERE liq01=? AND liq02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i365_bcl CURSOR FROM g_forupd_sql
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_liq WITHOUT DEFAULTS FROM s_liq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           LET g_success = 'N'
           OPEN i365_cl USING g_lip.lip01
           IF STATUS THEN
              CALL cl_err("OPEN i365_cl:", STATUS, 1)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i365_cl INTO g_lip.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_liq_t.* = g_liq[l_ac].*
              OPEN i365_bcl USING g_lip.lip01,g_liq_t.liq02
              IF STATUS THEN
                 CALL cl_err("OPEN i365_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i365_bcl INTO g_liq[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_liq_t.liq02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_liq[l_ac].* TO NULL
           LET g_liq_t.* = g_liq[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD liq02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_liq[l_ac].liq09) THEN
              CALL i365_liq09(p_cmd)
           END IF 
           INSERT INTO liq_file(liq01,liq02,liq03,liq04,liq05,liq06,
                                liq061,liq09,liqlegal,liqplant)

           VALUES(g_lip.lip01,g_liq[l_ac].liq02,
                  g_liq[l_ac].liq03,g_liq[l_ac].liq04,
                  g_liq[l_ac].liq05,g_liq[l_ac].liq06,
                  g_liq[l_ac].liq061,g_liq[l_ac].liq09,g_lip.liplegal,g_lip.lipplant
                 )
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","liq_file",g_lip.lip01,
                         g_liq[l_ac].liq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_success = 'Y'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

        BEFORE FIELD liq02
           IF g_liq[l_ac].liq02 IS NULL OR g_liq[l_ac].liq02 = 0 THEN
              SELECT max(liq02)+1
                INTO g_liq[l_ac].liq02
                FROM liq_file
               WHERE liq01 = g_lip.lip01
              IF g_liq[l_ac].liq02 IS NULL THEN
                 LET g_liq[l_ac].liq02 = 1
              END IF
           END IF

        AFTER FIELD liq02
           IF NOT cl_null(g_liq[l_ac].liq02) THEN
              IF (g_liq[l_ac].liq02 != g_liq_t.liq02
                  AND NOT cl_null(g_liq_t.liq02))
                 OR g_liq_t.liq02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM liq_file
                  WHERE liq01 = g_lip.lip01
                    AND liq02 = g_liq[l_ac].liq02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_liq[l_ac].liq02 = g_liq_t.liq02
                    NEXT FIELD liq02
                 END IF
              END IF
           END IF


       AFTER FIELD liq03
         IF NOT cl_null(g_liq[l_ac].liq03) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND g_liq[l_ac].liq03!=g_liq_t.liq03) THEN
               CALL i365_liq03(p_cmd) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_liq[l_ac].liq03 = g_liq_t.liq03
                  NEXT FIELD liq03
               END IF 
            END IF 
            IF g_liq[l_ac].liq04 != g_liq_t.liq04 OR cl_null(g_liq_t.liq04) THEN
               IF NOT cl_null(g_liq[l_ac].liq02) AND NOT cl_null(g_liq[l_ac].liq05) AND NOT cl_null(g_liq[l_ac].liq03) THEN
                  CALL i365_liq04(g_liq[l_ac].liq02,g_liq[l_ac].liq03,g_liq[l_ac].liq04,g_liq[l_ac].liq05,p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_liq[l_ac].liq03 = g_liq_t.liq03
                     NEXT FIELD liq03
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD liq04 
         IF NOT cl_null(g_liq[l_ac].liq04) THEN
            IF g_liq[l_ac].liq04 < g_lip.lip14 OR g_liq[l_ac].liq04 > g_lip.lip15 THEN
               CALL cl_err('','alm1085',0)
               LET g_liq[l_ac].liq04 = g_liq_t.liq04
               NEXT FIELD liq04
            ELSE
              IF NOT cl_null(g_liq[l_ac].liq05) THEN
                 IF g_liq[l_ac].liq04 > g_liq[l_ac].liq05 THEN
                    CALL cl_err('','alm1038',0)
                    LET g_liq[l_ac].liq04 = g_liq_t.liq04
                    NEXT FIELD liq04
                 END IF
              END IF
              IF g_liq[l_ac].liq04 != g_liq_t.liq04 OR cl_null(g_liq_t.liq04) THEN
                 IF NOT cl_null(g_liq[l_ac].liq05) AND NOT cl_null(g_liq[l_ac].liq03) THEN
                    CALL i365_liq04(g_liq[l_ac].liq02,g_liq[l_ac].liq03,g_liq[l_ac].liq04,g_liq[l_ac].liq05,p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_liq[l_ac].liq04 = g_liq_t.liq04
                       NEXT FIELD liq04
                    END IF
                 END IF
               END IF 
           END IF   
           IF NOT cl_null(g_liq[l_ac].liq05) THEN
                SELECT lim05 INTO g_liq[l_ac].liq06 
                  FROM lim_file
                 WHERE lim01 = g_lip.lip05
                   AND lim03 BETWEEN  g_liq[l_ac].liq04 AND g_liq[l_ac].liq05
                   AND lim04 BETWEEN  g_liq[l_ac].liq04 AND g_liq[l_ac].liq05
                IF SQLCA.sqlcode = 100 THEN
                   LET g_liq[l_ac].liq06 = ''
                END IF 
                IF NOT cl_null(g_liq[l_ac].liq061) THEN
                   LET g_liq[l_ac].liq09 = (g_liq[l_ac].liq061 - g_liq[l_ac].liq06)/g_liq[l_ac].liq06
                   IF NOT cl_null(g_liq[l_ac].liq09) THEN
                      CALL i365_liq09(p_cmd)
                   END IF
                END IF
                DISPLAY BY NAME g_liq[l_ac].liq06,g_liq[l_ac].liq09
            END IF  
          END IF  

      AFTER FIELD liq05
        IF NOT cl_null(g_liq[l_ac].liq05) THEN
            IF g_liq[l_ac].liq05 > g_lip.lip15 OR g_liq[l_ac].liq05 < g_lip.lip14 THEN
               CALL cl_err('','alm1085',0)
               LET g_liq[l_ac].liq05 = g_liq_t.liq05
               NEXT FIELD liq05
            ELSE
              IF NOT cl_null(g_liq[l_ac].liq04) THEN
                 IF g_liq[l_ac].liq04 > g_liq[l_ac].liq05 THEN
                    CALL cl_err('','alm1038',0)
                    LET g_liq[l_ac].liq05 = g_liq_t.liq05
                    NEXT FIELD liq05
                 END IF    
              END IF 
              IF g_liq[l_ac].liq05 != g_liq_t.liq05 OR cl_null(g_liq_t.liq05) THEN
                  IF NOT cl_null(g_liq[l_ac].liq04) AND NOT cl_null(g_liq[l_ac].liq03)  THEN
                     CALL i365_liq04(g_liq[l_ac].liq02,g_liq[l_ac].liq03,g_liq[l_ac].liq04,g_liq[l_ac].liq05,p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_liq[l_ac].liq05 = g_liq_t.liq05
                        NEXT FIELD liq05
                     END IF
                  END IF
               END IF 
            END IF
            IF NOT cl_null(g_liq[l_ac].liq04) THEN
                SELECT lim05 INTO g_liq[l_ac].liq06
                  FROM lim_file
                 WHERE lim01 = g_lip.lip05
                   AND g_liq[l_ac].liq04 BETWEEN lim03 AND lim04
                   AND g_liq[l_ac].liq05 BETWEEN lim03 AND lim04
                IF SQLCA.sqlcode = 100 THEN
                   LET g_liq[l_ac].liq06 = ''
                END IF
                IF NOT cl_null(g_liq[l_ac].liq061) THEN
                   LET g_liq[l_ac].liq09 = (g_liq[l_ac].liq061 - g_liq[l_ac].liq06)/g_liq[l_ac].liq06
                   IF NOT cl_null(g_liq[l_ac].liq09) THEN
                      CALL i365_liq09(p_cmd)
                   END IF 
                END IF 
                DISPLAY BY NAME g_liq[l_ac].liq06,g_liq[l_ac].liq09
            END IF
         END IF 

      AFTER FIELD liq061
         IF NOT cl_null(g_liq[l_ac].liq061) THEN
            IF g_liq[l_ac].liq061 < 0 THEN
                CALL cl_err('','alm1080',0)
                LET g_liq[l_ac].liq061 = g_liq_t.liq061
                NEXT FIELD liq061
            ELSE 
                LET g_liq[l_ac].liq09 = (g_liq[l_ac].liq061 - g_liq[l_ac].liq06)/g_liq[l_ac].liq06
                IF NOT cl_null(g_liq[l_ac].liq09) THEN
                   CALL i365_liq09(p_cmd)
                END IF
            END IF 
         END IF 
       
      BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_liq_t.liq02 > 0 AND g_liq_t.liq02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM liq_file
               WHERE liq01 = g_lip.lip01
                 AND liq02 = g_liq_t.liq02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","liq_file",g_lip.lip01,
                               g_liq_t.liq02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
           LET g_success = 'Y'

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_liq[l_ac].* = g_liq_t.*
              CLOSE i365_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_liq[l_ac].liq02,-263,1)
              LET g_liq[l_ac].* = g_liq_t.*
           ELSE
              UPDATE liq_file SET liq02=g_liq[l_ac].liq02,
                                  liq03=g_liq[l_ac].liq03,
                                  liq04=g_liq[l_ac].liq04,
                                  liq05=g_liq[l_ac].liq05,
                                  liq06=g_liq[l_ac].liq06,
                                  liq061=g_liq[l_ac].liq061,
                                  liq09=g_liq[l_ac].liq09
               WHERE liq01=g_lip.lip01
                 AND liq02=g_liq_t.liq02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","liq_file",g_lip.lip01,
                               g_liq_t.liq02,SQLCA.sqlcode,"","",1)
                 LET g_liq[l_ac].* = g_liq_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET g_success = 'Y'
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'a' THEN 
                 CALL g_liq.deleteElement(l_ac)
              END IF 
              IF p_cmd = 'u' THEN
                 LET g_liq[l_ac].* = g_liq_t.*
              END IF
              CLOSE i365_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_success =  'N' THEN 
              CLOSE i365_bcl
              ROLLBACK WORK   
           ELSE 
              CLOSE i365_bcl
           END IF 

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()


        ON ACTION controlp
           CASE
             WHEN INFIELD(liq03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmf02"
               LET g_qryparam.default1 = g_liq[l_ac].liq03
               LET g_qryparam.arg1 = g_lip.lipplant
               IF NOT cl_null(g_lip.lip07) THEN
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = " lmf03 = '",g_lip.lip07,"' AND lmf04 = '",g_lip.lip08,"'"
                   ELSE
                     LET g_qryparam.where = " lmf03 = '",g_lip.lip07,"'"  
                   END IF 
               ELSE 
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = " lmf04 = '",g_lip.lip08,"'"
                   END IF 
               END IF
               CALL cl_create_qry() RETURNING g_liq[l_ac].liq03
               DISPLAY BY NAME g_liq[l_ac].liq03
               OTHERWISE EXIT CASE
            END CASE

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
    IF p_cmd = 'u' THEN
    LET g_lip.lipmodu = g_user
    LET g_lip.lipdate = g_today
    UPDATE lip_file
    SET lipmodu = g_lip.lipmodu,
        lipdate = g_lip.lipdate
     WHERE lip01 = g_lip.lip01
    DISPLAY BY NAME g_lip.lipmodu,g_lip.lipdate
    END IF
    CLOSE i365_bcl
    CALL i365_delall()
END FUNCTION

FUNCTION i365_liq09(p_cmd)
   DEFINE l_count    LIKE liq_file.liq09 
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.num5
   IF p_cmd = 'a' THEN 
      SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n 
        FROM liq_file 
       WHERE liq01 = g_lip.lip01 
         AND liq09 IS NOT NULL 
       IF cl_null(l_count) THEN
          LET l_count = 0
       END IF 
       IF cl_null(l_n) THEN
          LET l_n = 0
       END IF
       LET l_count = l_count + g_liq[l_ac].liq09
       LET l_n = l_n + 1
   ELSE 
      IF p_cmd = 'u' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n 
           FROM liq_file
          WHERE liq01 = g_lip.lip01
            AND liq02 <> g_liq[l_ac].liq02 
            AND liq09 IS NOT NULL
         IF cl_null(l_count) THEN
            LET l_count = 0
         END IF
         IF cl_null(l_n) THEN
            LET l_n = 0
         END IF
         LET l_count = l_count + g_liq[l_ac].liq09
         LET l_n = l_n + 1
      END IF 
      IF p_cmd = 'd' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
           FROM liq_file
          WHERE liq01 = g_lip.lip01
            AND liq09 IS NOT NULL
          IF cl_null(l_count) THEN
             LET l_count = 0
          END IF
          IF cl_null(l_n) THEN
             LET l_n = 0
          END IF         
      END IF 
   END IF 
   LET g_desc = l_count/l_n
   DISPLAY g_desc TO desc
END FUNCTION 

FUNCTION i365_liq09_1(p_cmd)
   DEFINE l_count    LIKE liq_file.liq09
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.num5
   IF p_cmd = 'a' THEN
      SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
        FROM liq_file
       WHERE liq01 = g_lip.lip01
         AND liq09 IS NOT NULL
       IF cl_null(l_count) THEN
          LET l_count = 0
       END IF
       IF cl_null(l_n) THEN
          LET l_n = 0
       END IF
       LET l_count = l_count + g_liq1[l_ac].liq09
       LET l_n = l_n + 1
   ELSE
      IF p_cmd = 'u' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
           FROM liq_file
          WHERE liq01 = g_lip.lip01
            AND liq02 <> g_liq1[l_ac].liq02
            AND liq09 IS NOT NULL
         IF cl_null(l_count) THEN
            LET l_count = 0
         END IF
         IF cl_null(l_n) THEN
            LET l_n = 0
         END IF
         LET l_count = l_count + g_liq1[l_ac].liq09
         LET l_n = l_n + 1
      END IF
      IF p_cmd = 'd' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
           FROM liq_file
          WHERE liq01 = g_lip.lip01
            AND liq09 IS NOT NULL
          IF cl_null(l_count) THEN
             LET l_count = 0
          END IF
          IF cl_null(l_n) THEN
             LET l_n = 0
          END IF     
      END IF
   END IF
   LET g_desc = l_count/l_n
   DISPLAY g_desc TO desc
END FUNCTION

FUNCTION i365_liq09_2(p_cmd)
   DEFINE l_count    LIKE liq_file.liq09
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.num5
   IF p_cmd = 'a' THEN
      SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
        FROM liq_file
       WHERE liq01 = g_lip.lip01
       IF cl_null(l_count) THEN
          LET l_count = 0
       END IF
       IF cl_null(l_n) THEN
          LET l_n = 0
       END IF
       LET l_count = l_count + g_liq2[l_ac].liq09
       LET l_n = l_n + 1
   ELSE
      IF p_cmd = 'u' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
           FROM liq_file
          WHERE liq01 = g_lip.lip01
            AND liq02 <> g_liq2[l_ac].liq02
         IF cl_null(l_count) THEN
            LET l_count = 0
         END IF
         IF cl_null(l_n) THEN
            LET l_n = 0
         END IF
         LET l_count = l_count + g_liq2[l_ac].liq09
         LET l_n = l_n + 1
      END IF
      IF p_cmd = 'd' THEN
         SELECT SUM(liq09),COUNT(liq09) INTO l_count,l_n
           FROM liq_file
          WHERE liq01 = g_lip.lip01
          IF cl_null(l_count) THEN
             LET l_count = 0
          END IF
          IF cl_null(l_n) THEN
             LET l_n = 0
          END IF     
      END IF
   END IF
   LET g_desc = l_count/l_n
   DISPLAY g_desc TO desc
END FUNCTION

FUNCTION i365_liq03(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_t       LIKE type_file.chr1,
        l_lmf06   LIKE lmf_file.lmf06,  #確認碼
        l_sql     STRING 

     LET l_sql = " SELECT lmf06 ",
                 "   FROM lmf_file",
                 "  WHERE lmf01 = '",g_liq[l_ac].liq03,"'",
                 "    AND lmfstore ='",g_lip.lipplant,"'"
     IF NOT cl_null(g_lip.lip07) THEN
         LET l_sql = l_sql," AND lmf03 = '",g_lip.lip07,"'"
     END IF 
     IF NOT cl_null(g_lip.lip08) THEN
         LET l_sql = l_sql," AND lmf04 = '",g_lip.lip08,"'"
     END IF 
     LET l_sql = l_sql,"  AND lmf06 ='Y' "
     PREPARE i365_pre_liq FROM l_sql
     EXECUTE i365_pre_liq INTO l_lmf06
     CASE
        WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip07) AND cl_null(g_lip.lip08)  LET g_errno = 'alm-888'
        WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND cl_null(g_lip.lip07)  LET g_errno = 'alm-889'
        WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND NOT cl_null(g_lip.lip07) LET g_errno = 'alm-885'
        WHEN l_lmf06 <> 'Y'        LET g_errno = 'alm-059'
        OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
END FUNCTION

FUNCTION i365_liq03_1(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_t       LIKE type_file.chr1,
        l_lmf06   LIKE lmf_file.lmf06,  #確認碼
        l_sql     STRING

        LET l_sql = " SELECT lmf06 ",
                    "   FROM lmf_file",
                    "  WHERE lmf01 = '",g_liq1[l_ac].liq03,"'",
                    "    AND lmfstore ='",g_lip.lipplant,"'"
        IF NOT cl_null(g_lip.lip07) THEN
            LET l_sql = l_sql," AND lmf03 = '",g_lip.lip07,"'"
        END IF
        IF NOT cl_null(g_lip.lip08) THEN
            LET l_sql = l_sql," AND lmf04 = '",g_lip.lip08,"'"
        END IF
        LET l_sql = l_sql,"  AND lmf06 ='Y' "
        PREPARE i365_pre_liq_1 FROM l_sql
        EXECUTE i365_pre_liq_1 INTO l_lmf06
        CASE
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip07) AND cl_null(g_lip.lip08)  LET g_errno = 'alm-888'
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND cl_null(g_lip.lip07)  LET g_errno = 'alm-889'
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND NOT cl_null(g_lip.lip07) LET g_errno = 'alm-885'
           WHEN l_lmf06 <> 'Y'        LET g_errno = 'alm-059'
           OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
END FUNCTION

FUNCTION i365_liq03_2(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_t       LIKE type_file.chr1,
        l_lmf06   LIKE lmf_file.lmf06,  #確認碼
        l_sql     STRING

        LET l_sql = " SELECT lmf06 ",
                    "   FROM lmf_file",
                    "  WHERE lmf01 = '",g_liq2[l_ac].liq03,"'",
                    "    AND lmfstore ='",g_lip.lipplant,"'"
        IF NOT cl_null(g_lip.lip07) THEN
            LET l_sql = l_sql," AND lmf03 = '",g_lip.lip07,"'"
        END IF
        IF NOT cl_null(g_lip.lip08) THEN
            LET l_sql = l_sql," AND lmf04 = '",g_lip.lip08,"'"
        END IF
        LET l_sql = l_sql,"  AND lmf06 ='Y' "
        PREPARE i365_pre_liq_2 FROM l_sql
        EXECUTE i365_pre_liq_2 INTO l_lmf06

        CASE
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip07) AND cl_null(g_lip.lip08)  LET g_errno = 'alm-888'
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND cl_null(g_lip.lip07)  LET g_errno = 'alm-889'
           WHEN SQLCA.sqlcode = 100 AND NOT cl_null(g_lip.lip08) AND NOT cl_null(g_lip.lip07) LET g_errno = 'alm-885'
           WHEN l_lmf06 <> 'Y'        LET g_errno = 'alm-059'
           OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
END FUNCTION

FUNCTION i365_liq04(l_liq02,l_liq03,p_stardate,p_enddate,p_cmd)
DEFINE l_n          LIKE type_file.num5,
       l_liq02      LIKE liq_file.liq02,
       l_liq03      LIKE liq_file.liq03,
       p_stardate   LIKE liq_file.liq04,
       p_enddate    LIKE liq_file.liq05,
       p_cmd        LIKE type_file.chr1
   LET g_errno =''
   IF p_cmd = 'u' THEN
      SELECT COUNT(liq03) INTO l_n FROM liq_file
       WHERE liq03 = l_liq03
         AND liq01 = g_lip.lip01
         AND liq02 <> l_liq02
         AND (
              liq04 BETWEEN p_stardate AND p_enddate
              OR  liq05 BETWEEN p_stardate AND p_enddate
              OR  (liq04 <=p_stardate AND liq05 >= p_enddate)
             )
   ELSE 
      SELECT COUNT(liq03) INTO l_n FROM liq_file
       WHERE liq03 = l_liq03
         AND liq01 = g_lip.lip01
         AND (
              liq04 BETWEEN p_stardate AND p_enddate
              OR  liq05 BETWEEN p_stardate AND p_enddate
              OR  (liq04 <=p_stardate AND liq05 >= p_enddate)
             )
   END IF 
   IF l_n > 0 THEN
      LET g_errno = 'alm1096'
   END IF
END FUNCTION

FUNCTION i365_b1()
DEFINE
    l_n             LIKE type_file.num5,
    l_i1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5

    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_lip.lip01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_lip.* FROM lip_file
     WHERE lip01=g_lip.lip01

    IF g_lip.lipacti ='N' THEN
       CALL cl_err(g_lip.lip01,'mfg1000',0)
       RETURN
    END IF

    IF g_lip.lipconf = 'Y' THEN
       CALL cl_err('','9022',0)
       RETURN
    END IF
    IF g_lip.lipconf='S' THEN
       CALL cl_err('','alm1048',0)
       RETURN
    END IF
    LET g_forupd_sql = "SELECT liq02,liq03,liq04,liq05,liq07,liq071,liq072,liq073,liq074,liq09",
                       "  FROM liq_file",
                       "  WHERE liq01=? AND liq02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i365_bcl1 CURSOR FROM g_forupd_sql
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_liq1 WITHOUT DEFAULTS FROM s_liq1.*
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           LET g_success = 'N'
           OPEN i365_cl USING g_lip.lip01
           IF STATUS THEN
              CALL cl_err("OPEN i365_cl:", STATUS, 1)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i365_cl INTO g_lip.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b1 >= l_ac THEN
              LET p_cmd='u'
              LET g_liq1_t.* = g_liq1[l_ac].*
              OPEN i365_bcl1 USING g_lip.lip01,g_liq1_t.liq02
              IF STATUS THEN
                 CALL cl_err("OPEN i365_bcl1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i365_bcl1 INTO g_liq1[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_liq1_t.liq02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_liq1[l_ac].* TO NULL
           LET g_liq1_t.* = g_liq1[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD liq02_1

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_liq1[l_ac].liq09) THEN
              CALL i365_liq09_1(p_cmd)
           END IF 
           INSERT INTO liq_file(liq01,liq02,liq03,liq04,liq05,liq07,
                                liq071,liq072,liq073,liq074,liq09,liqlegal,liqplant)

           VALUES(g_lip.lip01,g_liq1[l_ac].liq02,
                  g_liq1[l_ac].liq03,g_liq1[l_ac].liq04,
                  g_liq1[l_ac].liq05,g_liq1[l_ac].liq07,
                  g_liq1[l_ac].liq071,g_liq1[l_ac].liq072,
                  g_liq1[l_ac].liq073,g_liq1[l_ac].liq074,
                  g_liq1[l_ac].liq09,g_lip.liplegal,g_lip.lipplant
                 )
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","liq_file",g_lip.lip01,
                         g_liq[l_ac].liq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_success = 'Y'
             LET g_rec_b1 = g_rec_b1 + 1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
          END IF

        BEFORE FIELD liq02_1
           IF g_liq1[l_ac].liq02 IS NULL OR g_liq1[l_ac].liq02 = 0 THEN
              SELECT max(liq02)+1
                INTO g_liq1[l_ac].liq02
                FROM liq_file
               WHERE liq01 = g_lip.lip01
              IF g_liq1[l_ac].liq02 IS NULL THEN
                 LET g_liq1[l_ac].liq02 = 1
              END IF
           END IF

        AFTER FIELD liq02_1
           IF NOT cl_null(g_liq1[l_ac].liq02) THEN
              IF (g_liq1[l_ac].liq02 != g_liq1_t.liq02
                  AND NOT cl_null(g_liq1_t.liq02))
                 OR g_liq1_t.liq02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM liq_file
                  WHERE liq01 = g_lip.lip01
                    AND liq02 = g_liq1[l_ac].liq02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_liq1[l_ac].liq02 = g_liq1_t.liq02
                    NEXT FIELD liq02
                 END IF
              END IF
           END IF


       AFTER FIELD liq03_1
           IF NOT cl_null(g_liq1[l_ac].liq03) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_liq1[l_ac].liq03!=g_liq1_t.liq03) THEN
                 CALL i365_liq03_1(p_cmd) 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_liq1[l_ac].liq03 = g_liq1_t.liq03
                    NEXT FIELD liq03_1
                 END IF 
                 IF NOT cl_null(g_liq1[l_ac].liq05) AND NOT cl_null(g_liq1[l_ac].liq05) AND NOT cl_null(g_liq1[l_ac].liq02) THEN
                     CALL i365_liq04(g_liq1[l_ac].liq02,g_liq1[l_ac].liq03,g_liq1[l_ac].liq04,g_liq1[l_ac].liq05,p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_liq1[l_ac].liq03 = g_liq1_t.liq03
                        NEXT FIELD liq03_1
                     END IF  
                 END IF 
              END IF
           END IF

      AFTER FIELD liq04_1 
           IF NOT cl_null(g_liq1[l_ac].liq04) THEN
              IF g_liq1[l_ac].liq04 < g_lip.lip14 OR g_liq1[l_ac].liq04 > g_lip.lip15 THEN
                 CALL cl_err('','alm1085',0)
                 LET g_liq1[l_ac].liq04 = g_liq1_t.liq04
                 NEXT FIELD liq04_1
              ELSE
                 IF NOT cl_null(g_liq1[l_ac].liq05) THEN
                    IF g_liq1[l_ac].liq04 > g_liq1[l_ac].liq05 THEN
                       CALL cl_err('','alm1038',0)
                       LET g_liq1[l_ac].liq04 = g_liq1_t.liq04
                       NEXT FIELD liq04_1
                    END IF
                 END IF
                 IF g_liq1[l_ac].liq04 != g_liq1_t.liq04 OR cl_null(g_liq1_t.liq04) THEN
                    IF NOT cl_null(g_liq1[l_ac].liq05) AND NOT cl_null(g_liq1[l_ac].liq03) AND NOT cl_null(g_liq1[l_ac].liq02) THEN
                       CALL i365_liq04(g_liq1[l_ac].liq02,g_liq1[l_ac].liq03,g_liq1[l_ac].liq04,g_liq1[l_ac].liq05,p_cmd)
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_liq1[l_ac].liq04 = g_liq1_t.liq04
                          NEXT FIELD liq04_1
                       END IF
                    END IF
                 END IF 
              END IF
              IF NOT cl_null(g_liq1[l_ac].liq05) THEN
                  SELECT lim061,lim062 INTO g_liq1[l_ac].liq071,g_liq1[l_ac].liq072
                    FROM lim_file
                   WHERE lim01 = g_lip.lip05
                     AND g_liq1[l_ac].liq04 BETWEEN lim03 AND lim04
                     AND g_liq1[l_ac].liq05 BETWEEN lim03 AND lim04
                  IF SQLCA.sqlcode = 100 THEN
                     LET g_liq1[l_ac].liq071 = ''
                     LET g_liq1[l_ac].liq072 = '' 
                  END IF
                  IF NOT cl_null(g_liq1[l_ac].liq074) THEN
                     LET g_liq1[l_ac].liq09 = (g_liq1[l_ac].liq074 - g_liq1[l_ac].liq072)/g_liq1[l_ac].liq072
                     IF NOT cl_null(g_liq1[l_ac].liq09) THEN
                        CALL i365_liq09_1(p_cmd)
                     END IF 
                  END IF 
                  DISPLAY BY NAME g_liq1[l_ac].liq071,g_liq1[l_ac].liq072,g_liq1[l_ac].liq09
              END IF
           END IF    


      AFTER FIELD liq05_1
        IF NOT cl_null(g_liq1[l_ac].liq05) THEN
            IF g_liq1[l_ac].liq05 > g_lip.lip15 OR g_liq1[l_ac].liq05 < g_lip.lip14 THEN
               CALL cl_err('','alm1085',0)
               LET g_liq1[l_ac].liq05 = g_liq1_t.liq05
               NEXT FIELD liq05_1
            ELSE
               IF NOT cl_null(g_liq1[l_ac].liq04) THEN
                  IF g_liq1[l_ac].liq04 > g_liq1[l_ac].liq05 THEN
                     CALL cl_err('','alm1038',0)
                     LET g_liq1[l_ac].liq05 = g_liq1_t.liq05
                     NEXT FIELD liq05_1
                  END IF
               END IF
               IF g_liq1[l_ac].liq05 != g_liq1_t.liq05 OR cl_null(g_liq1_t.liq05) THEN
                  IF NOT cl_null(g_liq1[l_ac].liq04) AND NOT cl_null(g_liq1[l_ac].liq03) AND NOT cl_null(g_liq1[l_ac].liq02)  THEN
                     CALL i365_liq04(g_liq1[l_ac].liq02,g_liq1[l_ac].liq03,g_liq1[l_ac].liq04,g_liq1[l_ac].liq05,p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_liq1[l_ac].liq05 = g_liq1_t.liq05
                        NEXT FIELD liq05_1
                     END IF
                  END IF
                END IF 
            END IF
            IF NOT cl_null(g_liq1[l_ac].liq04) THEN
                SELECT lim061,lim062 INTO g_liq1[l_ac].liq071,g_liq1[l_ac].liq072
                  FROM lim_file
                 WHERE lim01 = g_lip.lip05
                   AND g_liq1[l_ac].liq04 BETWEEN lim03 AND lim04
                   AND g_liq1[l_ac].liq05 BETWEEN lim03 AND lim04
                  IF SQLCA.sqlcode = 100 THEN
                     LET g_liq1[l_ac].liq071 = ''
                     LET g_liq1[l_ac].liq072 = ''
                  END IF
                  IF NOT cl_null(g_liq1[l_ac].liq074) THEN
                     LET g_liq1[l_ac].liq09 = (g_liq1[l_ac].liq074 - g_liq1[l_ac].liq072)/g_liq1[l_ac].liq072
                     IF NOT cl_null(g_liq1[l_ac].liq09) THEN
                        CALL i365_liq09_1(p_cmd)
                     END IF 
                  END IF 
                DISPLAY BY NAME g_liq1[l_ac].liq071,g_liq1[l_ac].liq072,g_liq1[l_ac].liq09
            END IF
         END IF 

      AFTER FIELD liq073    #比例 
         IF NOT cl_null(g_liq1[l_ac].liq073) THEN
            IF g_liq1[l_ac].liq073 < 0 OR g_liq1[l_ac].liq073 > 100 THEN
               CALL cl_err('','apc-133',0)
               LET g_liq1[l_ac].liq073 = g_liq1_t.liq073
               NEXT FIELD liq073
            END IF
         END IF               

      AFTER FIELD liq074
         IF NOT cl_null(g_liq1[l_ac].liq074) THEN
            IF g_liq1[l_ac].liq074 < 0 THEN
               CALL cl_err('','alm1088',0)
               LET g_liq1[l_ac].liq074 = g_liq1_t.liq074
               NEXT FIELD liq074
            LET g_liq1[l_ac].liq09 = (g_liq1[l_ac].liq074 - g_liq1[l_ac].liq072)/g_liq1[l_ac].liq072
            IF NOT cl_null(g_liq1[l_ac].liq09) THEN
               CALL i365_liq09_1(p_cmd)
            END IF
            END IF
         END IF  

      BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_liq1_t.liq02 > 0 AND g_liq1_t.liq02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM liq_file
               WHERE liq01 = g_lip.lip01
                 AND liq02 = g_liq1_t.liq02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","liq_file",g_lip.lip01,
                               g_liq1_t.liq02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1 = g_rec_b1 - 1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK
           LET g_success = 'Y'

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_liq1[l_ac].* = g_liq1_t.*
              CLOSE i365_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_liq1[l_ac].liq02,-263,1)
              LET g_liq1[l_ac].* = g_liq1_t.*
           ELSE
              UPDATE liq_file SET liq02=g_liq1[l_ac].liq02,
                                  liq03=g_liq1[l_ac].liq03,
                                  liq04=g_liq1[l_ac].liq04,
                                  liq05=g_liq1[l_ac].liq05,
                                  liq07=g_liq1[l_ac].liq07,
                                  liq071=g_liq1[l_ac].liq071,
                                  liq072=g_liq1[l_ac].liq072,
                                  liq073=g_liq1[l_ac].liq073,
                                  liq074=g_liq1[l_ac].liq074,
                                  liq09=g_liq1[l_ac].liq09
               WHERE liq01 = g_lip.lip01
                 AND liq02 = g_liq1_t.liq02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","liq_file",g_lip.lip01,
                               g_liq1_t.liq02,SQLCA.sqlcode,"","",1)
                 LET g_liq1[l_ac].* = g_liq1_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET g_success = 'Y'
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'a' THEN 
                 CALL g_liq1.deleteElement(l_ac)
              END IF 
              IF p_cmd = 'u' THEN
                 LET g_liq1[l_ac].* = g_liq1_t.*
              END IF
              CLOSE i365_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_success =  'N' THEN 
              CLOSE i365_bcl1
              ROLLBACK WORK   
           ELSE 
              CLOSE i365_bcl1
           END IF 

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()


        ON ACTION controlp
           CASE
             WHEN INFIELD(liq03_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmf02"
               LET g_qryparam.default1 = g_liq1[l_ac].liq03
               LET g_qryparam.arg1 = g_lip.lipplant
               IF NOT cl_null(g_lip.lip07) THEN
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = " lmf03 = '",g_lip.lip07,"' AND lmf04 = '",g_lip.lip08,"'"
                   ELSE
                     LET g_qryparam.where = " lmf03 = '",g_lip.lip07,"'"
                   END IF 
               ELSE
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = " lmf04 = '",g_lip.lip08,"'"
                   END IF 
               END IF
               CALL cl_create_qry() RETURNING g_liq1[l_ac].liq03
               DISPLAY BY NAME g_liq1[l_ac].liq03
               NEXT FIELD liq03_1
               OTHERWISE EXIT CASE
            END CASE

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
    IF p_cmd = 'u' THEN
       LET g_lip.lipmodu = g_user
       LET g_lip.lipdate = g_today
       UPDATE lip_file
       SET lipmodu = g_lip.lipmodu,
           lipdate = g_lip.lipdate
       WHERE lip01 = g_lip.lip01
       DISPLAY BY NAME g_lip.lipmodu,g_lip.lipdate
    END IF
    CLOSE i365_bcl1
    CALL i365_delall()
END FUNCTION

FUNCTION i365_b2()
DEFINE
    l_n             LIKE type_file.num5,
    l_i1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_lip.lip01 IS NULL THEN
       RETURN
    END IF

    IF g_lip.lipconf = 'Y' THEN
       CALL cl_err('','9022',0)
       RETURN
    END IF

    SELECT * INTO g_lip.* FROM lip_file
     WHERE lip01=g_lip.lip01

    IF g_lip.lipacti ='N' THEN
       CALL cl_err(g_lip.lip01,'mfg1000',0)
       RETURN
    END IF

    IF g_lip.lipconf='S' THEN
       CALL cl_err('','alm1048',0)
       RETURN
    END IF
    LET g_forupd_sql = "SELECT liq02,liq03,liq04,liq05,liq08,liq081,liq082,liq083,liq084,liq09",
                       "  FROM liq_file",
                       "  WHERE liq01=? AND liq02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i365_bcl2 CURSOR FROM g_forupd_sql
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_liq2 WITHOUT DEFAULTS FROM s_liq2.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           LET g_success = 'N'
           OPEN i365_cl USING g_lip.lip01
           IF STATUS THEN
              CALL cl_err("OPEN i365_cl:", STATUS, 1)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i365_cl INTO g_lip.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
              CLOSE i365_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_liq2_t.* = g_liq2[l_ac].*
              OPEN i365_bcl2 USING g_lip.lip01,g_liq2_t.liq02
              IF STATUS THEN
                 CALL cl_err("OPEN i365_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i365_bcl2 INTO g_liq2[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_liq2_t.liq02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_liq[l_ac].* TO NULL
           LET g_liq2_t.* = g_liq2[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD liq02_2

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_liq2[l_ac].liq09) THEN
              CALL i365_liq09_2(p_cmd)
           END IF 
           INSERT INTO liq_file(liq01,liq02,liq03,liq04,liq05,liq08,
                                liq081,liq082,liq083,liq084,liq09,liqlegal,liqplant)

           VALUES(g_lip.lip01,g_liq2[l_ac].liq02,
                  g_liq2[l_ac].liq03,g_liq2[l_ac].liq04,
                  g_liq2[l_ac].liq05,g_liq2[l_ac].liq08,
                  g_liq2[l_ac].liq081,g_liq2[l_ac].liq082,
                  g_liq2[l_ac].liq083,g_liq2[l_ac].liq084,
                  g_liq2[l_ac].liq09,g_lip.liplegal,g_lip.lipplant
                 )
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","liq_file",g_lip.lip01,
                         g_liq2[l_ac].liq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_success = 'Y'
             LET g_rec_b2 = g_rec_b2 + 1
             DISPLAY g_rec_b2 TO FORMONLY.cn2
          END IF

        BEFORE FIELD liq02_2
           IF g_liq2[l_ac].liq02 IS NULL OR g_liq2[l_ac].liq02 = 0 THEN
              SELECT max(liq02)+1
                INTO g_liq2[l_ac].liq02
                FROM liq_file
               WHERE liq01 = g_lip.lip01
              IF g_liq2[l_ac].liq02 IS NULL THEN
                 LET g_liq2[l_ac].liq02 = 1
              END IF
           END IF

        AFTER FIELD liq02_2
           IF NOT cl_null(g_liq2[l_ac].liq02) THEN
              IF (g_liq2[l_ac].liq02 != g_liq2_t.liq02
                  AND NOT cl_null(g_liq2_t.liq02))
                 OR g_liq2_t.liq02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM liq_file
                  WHERE liq01 = g_lip.lip01
                    AND liq02 = g_liq2[l_ac].liq02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_liq2[l_ac].liq02 = g_liq2_t.liq02
                    NEXT FIELD liq02_2
                 END IF
              END IF
           END IF


       AFTER FIELD liq03_2
           IF NOT cl_null(g_liq2[l_ac].liq03) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_liq2[l_ac].liq03!=g_liq2_t.liq03) THEN
                 CALL i365_liq03_2(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_liq2[l_ac].liq03 = g_liq2_t.liq03
                    NEXT FIELD liq03_2
                 END IF 
              END IF
              IF NOT cl_null(g_liq2[l_ac].liq081) AND NOT cl_null(g_liq2[l_ac].liq04)
                 AND NOT cl_null(g_liq2[l_ac].liq082) AND NOT cl_null(g_liq2[l_ac].liq05) THEN
                 IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_n FROM liq_file
                     WHERE liq01 = g_lip.lip01 
                       AND liq03 = g_liq2[l_ac].liq03
                       AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                            OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                            OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                             OR liq05 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05  ))
                         AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                            OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                            OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                            OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                    IF l_n > 0 THEN
                       CALL cl_err('','alm-872',0)
                       NEXT FIELD CURRENT
                    END IF
                 ELSE
                    IF g_liq2[l_ac].liq03!=g_liq2_t.liq03 THEN
                      SELECT COUNT(*) INTO l_n FROM liq_file
                       WHERE liq01 = g_lip.lip01
                         AND liq03 = g_liq2[l_ac].liq03
                         AND liq02 <> g_liq2_t.liq02
                         AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                            OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                            OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                             OR liq05 BETWEEN g_liq2[l_ac].liq05 AND g_liq2[l_ac].liq05 ))
                          AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                            OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                            OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                            OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                      IF l_n > 0 THEN
                         CALL cl_err('','alm-872',0)
                         LET g_liq2[l_ac].liq03 = g_liq2_t.liq03
                         NEXT FIELD CURRENT
                      END IF
                    END IF
                 END IF 
              END IF
           END IF
             
      AFTER FIELD liq04_2  
           IF NOT cl_null(g_liq2[l_ac].liq04) THEN
              IF g_liq2[l_ac].liq04 < g_lip.lip14 OR g_liq2[l_ac].liq04 > g_lip.lip15 THEN
                 CALL cl_err('','alm1085',0)
                 LET g_liq2[l_ac].liq04 = g_liq2_t.liq04
                 NEXT FIELD liq04_2
              END IF
              IF NOT cl_null(g_liq2[l_ac].liq05) THEN
                 IF g_liq2[l_ac].liq04 > g_liq2[l_ac].liq05 THEN
                    CALL cl_err('','alm1038',0)
                    LET g_liq2[l_ac].liq04 = g_liq2_t.liq04
                    NEXT FIELD liq04_2
                 END IF
              END IF
              IF NOT cl_null(g_liq2[l_ac].liq081) AND NOT cl_null(g_liq2[l_ac].liq03)
                 AND NOT cl_null(g_liq2[l_ac].liq082) AND NOT cl_null(g_liq2[l_ac].liq05) THEN
                 IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_n FROM liq_file
                     WHERE liq01 = g_lip.lip01
                       AND liq03 = g_liq2[l_ac].liq03
                       AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                            OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                            OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                             OR liq05 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05  ))
                         AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                            OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                            OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                            OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                    IF l_n > 0 THEN
                       CALL cl_err('','alm-872',0)
                       NEXT FIELD CURRENT
                    END IF
                 ELSE
                    IF g_liq2[l_ac].liq04 <> g_liq2_t.liq04 THEN
                      SELECT COUNT(*) INTO l_n FROM liq_file
                       WHERE liq01 = g_lip.lip01
                         AND liq03 = g_liq2[l_ac].liq03
                         AND liq02 <> g_liq2_t.liq02
                         AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                            OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                            OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                             OR liq05 BETWEEN g_liq2[l_ac].liq05 AND g_liq2[l_ac].liq05 ))
                          AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                            OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                            OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                            OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                      IF l_n > 0 THEN
                         CALL cl_err('','alm-872',0)
                         LET g_liq2[l_ac].liq04 = g_liq2_t.liq04
                         NEXT FIELD CURRENT
                      END IF
                   END IF
                END IF
              END IF                
              IF NOT cl_null(g_liq2[l_ac].liq05) AND cl_null(g_errno) THEN
                  SELECT lim073 INTO g_liq2[l_ac].liq083
                    FROM lim_file
                   WHERE lim01 = g_lip.lip05
                     AND g_liq2[l_ac].liq04 BETWEEN lim03 AND lim04
                     AND g_liq2[l_ac].liq05 BETWEEN lim03 AND lim04
                  IF SQLCA.sqlcode = 100 THEN
                     LET g_liq2[l_ac].liq083 = ''
                  END IF
                  IF NOT cl_null(g_liq2[l_ac].liq084) THEN
                    LET g_liq2[l_ac].liq09 = (g_liq2[l_ac].liq084 - g_liq2[l_ac].liq083)/g_liq2[l_ac].liq083
                    IF NOT cl_null(g_liq2[l_ac].liq09) THEN
                       CALL i365_liq09_2(p_cmd)
                    END IF 
                  END IF
                  DISPLAY BY NAME g_liq2[l_ac].liq083,g_liq2[l_ac].liq09
              END IF
           END IF    
              
                  
      AFTER FIELD liq05_2
        IF NOT cl_null(g_liq2[l_ac].liq05) THEN
            IF g_liq2[l_ac].liq05 > g_lip.lip15 OR g_liq2[l_ac].liq05 < g_lip.lip14 THEN
               CALL cl_err('','alm1085',0)
               LET g_liq2[l_ac].liq05 = g_liq2_t.liq05
               NEXT FIELD liq05_2
            END IF 
            IF NOT cl_null(g_liq2[l_ac].liq04) THEN
               IF g_liq2[l_ac].liq04 > g_liq2[l_ac].liq05 THEN
                  CALL cl_err('','alm1038',0)
                  LET g_liq2[l_ac].liq05 = g_liq2_t.liq05
                  NEXT FIELD liq05_2
               END IF
            END IF
            IF NOT cl_null(g_liq2[l_ac].liq081) AND NOT cl_null(g_liq2[l_ac].liq03)
               AND NOT cl_null(g_liq2[l_ac].liq082) AND NOT cl_null(g_liq2[l_ac].liq04) THEN
               IF p_cmd = 'a' THEN
                  SELECT COUNT(*) INTO l_n FROM liq_file
                   WHERE liq01 = g_lip.lip01
                     AND liq03 = g_liq2[l_ac].liq03
                     AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                          OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                          OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                           OR liq05 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05  ))
                       AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                          OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                          OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                          OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                  IF l_n > 0 THEN
                     CALL cl_err('','alm-872',0)
                     NEXT FIELD CURRENT
                  END IF
               ELSE
                 IF g_liq2[l_ac].liq05 <> g_liq2_t.liq05 THEN
                    SELECT COUNT(*) INTO l_n FROM liq_file
                     WHERE liq01 = g_lip.lip01
                       AND liq03 = g_liq2[l_ac].liq03
                       AND liq02 <> g_liq2_t.liq02
                       AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                          OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                          OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                           OR liq05 BETWEEN g_liq2[l_ac].liq05 AND g_liq2[l_ac].liq05 ))
                        AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                          OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                          OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                          OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                    IF l_n > 0 THEN
                       CALL cl_err('','alm-872',0)
                       LET g_liq2[l_ac].liq05 = g_liq2_t.liq05
                       NEXT FIELD CURRENT
                    END IF
                 END IF
              END IF
            END IF
            IF NOT cl_null(g_liq2[l_ac].liq05) THEN
                SELECT lim073 INTO g_liq2[l_ac].liq083
                  FROM lim_file
                 WHERE lim01 = g_lip.lip05
                   AND g_liq2[l_ac].liq04 BETWEEN lim03 AND lim04
                   AND g_liq2[l_ac].liq05 BETWEEN lim03 AND lim04
                  IF SQLCA.sqlcode = 100 THEN
                     LET g_liq2[l_ac].liq083 = ''
                  END IF
                  IF NOT cl_null(g_liq2[l_ac].liq084) THEN
                     LET g_liq2[l_ac].liq09 = (g_liq2[l_ac].liq084 - g_liq2[l_ac].liq083)/g_liq2[l_ac].liq083
                     IF NOT cl_null(g_liq2[l_ac].liq09) THEN
                        CALL i365_liq09_2(p_cmd)
                     END IF 
                  END IF 
                DISPLAY BY NAME g_liq2[l_ac].liq083,g_liq2[l_ac].liq09
            END IF
         END IF

      AFTER FIELD liq081
         IF NOT cl_null(g_liq2[l_ac].liq081) THEN
            IF g_liq2[l_ac].liq081 < 0 THEN
               CALL cl_err('','alm1089',0)
               LET g_liq2[l_ac].liq081 = g_liq2_t.liq081
               NEXT FIELD liq081
            END IF
            IF NOT cl_null(g_liq2[l_ac].liq082) THEN
               IF g_liq2[l_ac].liq081 > g_liq2[l_ac].liq082  THEN
                  CALL cl_err('','alm1020',0)
                  LET g_liq2[l_ac].liq081 = g_liq2_t.liq081
                  NEXT FIELD liq081
               END IF 
            END IF 
            IF NOT cl_null(g_liq2[l_ac].liq082) THEN
               IF NOT cl_null(g_liq2[l_ac].liq03) AND NOT cl_null(g_liq2[l_ac].liq04) AND NOT cl_null(g_liq2[l_ac].liq05) THEN
                  IF p_cmd = 'a' THEN
                     SELECT COUNT(*) INTO l_n FROM liq_file
                      WHERE liq01 = g_lip.lip01
                        AND liq03 = g_liq2[l_ac].liq03
                        AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                             OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                             OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                              OR liq05 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05  ))
                          AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                             OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                             OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                             OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                     IF l_n > 0 THEN
                        CALL cl_err('','alm-872',0)
                        NEXT FIELD CURRENT
                     END IF
                  ELSE
                     IF g_liq2[l_ac].liq081 <> g_liq2_t.liq081 THEN
                         SELECT COUNT(*) INTO l_n FROM liq_file
                          WHERE liq01 = g_lip.lip01
                            AND liq03 = g_liq2[l_ac].liq03
                            AND liq02 <> g_liq2_t.liq02
                            AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                               OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                               OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                                OR liq05 BETWEEN g_liq2[l_ac].liq05 AND g_liq2[l_ac].liq05 ))
                             AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                               OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                               OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                               OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                         IF l_n > 0 THEN
                            CALL cl_err('','alm-872',0)
                            LET g_liq2[l_ac].liq081 = g_liq2_t.liq081
                            NEXT FIELD CURRENT
                         END IF
                      END IF
                    END IF
                END IF 
              END IF 
           END IF

      AFTER FIELD liq082
         IF NOT cl_null(g_liq2[l_ac].liq082) THEN
            IF g_liq2[l_ac].liq082 < 0 THEN
               CALL cl_err('','alm1090',0)
               LET g_liq2[l_ac].liq082 = g_liq2_t.liq082
               NEXT FIELD liq082
            END IF
            IF NOT cl_null(g_liq2[l_ac].liq081) THEN
               IF g_liq2[l_ac].liq081 > g_liq2[l_ac].liq082  THEN
                  CALL cl_err('','alm1020',0)
                  LET g_liq2[l_ac].liq082 = g_liq2_t.liq082
                  NEXT FIELD liq082
               END IF
            END IF
            IF NOT cl_null(g_liq2[l_ac].liq081) THEN
               IF NOT cl_null(g_liq2[l_ac].liq03) AND NOT cl_null(g_liq2[l_ac].liq04) AND NOT cl_null(g_liq2[l_ac].liq05) THEN
                  IF p_cmd = 'a' THEN
                     SELECT COUNT(*) INTO l_n FROM liq_file
                      WHERE liq01 = g_lip.lip01
                        AND liq03 = g_liq2[l_ac].liq03
                        AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                             OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                             OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                              OR liq05 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05  ))
                          AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                             OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                             OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                             OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                     IF l_n > 0 THEN
                        CALL cl_err('','alm-872',0)
                        NEXT FIELD CURRENT
                     END IF
                  ELSE
                     IF g_liq2[l_ac].liq082 <> g_liq2_t.liq082 THEN
                        SELECT COUNT(*) INTO l_n FROM liq_file
                         WHERE liq01 = g_lip.lip01
                           AND liq03 = g_liq2[l_ac].liq03
                           AND liq02 <> g_liq2_t.liq02
                           AND ((g_liq2[l_ac].liq04 BETWEEN liq04 AND liq05
                              OR g_liq2[l_ac].liq05 BETWEEN liq04 AND liq05)
                              OR (liq04 BETWEEN g_liq2[l_ac].liq04 AND g_liq2[l_ac].liq05
                              OR liq05 BETWEEN g_liq2[l_ac].liq05 AND g_liq2[l_ac].liq05 ))
                            AND ((g_liq2[l_ac].liq081 BETWEEN liq081 AND liq082
                              OR g_liq2[l_ac].liq082 BETWEEN liq081 AND liq082)
                              OR  (liq081 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082
                              OR liq082 BETWEEN g_liq2[l_ac].liq081 AND g_liq2[l_ac].liq082 ))
                        IF l_n > 0 THEN
                           CALL cl_err('','alm-872',0)
                           LET g_liq2[l_ac].liq082 = g_liq2_t.liq082
                           NEXT FIELD CURRENT
                        END IF
                     END IF
                  END IF
               END IF 
            END IF 
         END IF

      AFTER FIELD liq084
         IF NOT cl_null(g_liq2[l_ac].liq084) THEN
            IF g_liq2[l_ac].liq084 < 0 THEN
               CALL cl_err('','alm1080',0)
               LET g_liq2[l_ac].liq084 = g_liq2_t.liq084
               NEXT FIELD liq084
            ELSE 
               LET g_liq2[l_ac].liq09 = (g_liq2[l_ac].liq084 - g_liq2[l_ac].liq083)/g_liq2[l_ac].liq083
               IF NOT cl_null(g_liq2[l_ac].liq09) THEN
                  CALL i365_liq09_2(p_cmd)
               END IF 
            END IF
         END IF
   
      BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_liq2_t.liq02 > 0 AND g_liq2_t.liq02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM liq_file
               WHERE liq01 = g_lip.lip01
                 AND liq02 = g_liq2_t.liq02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","liq_file",g_lip.lip01,
                               g_liq2_t.liq02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2 = g_rec_b2 - 1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK
           LET g_success = 'Y'

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_liq2[l_ac].* = g_liq2_t.*
              CLOSE i365_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_liq2[l_ac].liq02,-263,1)
              LET g_liq2[l_ac].* = g_liq2_t.*
           ELSE
              UPDATE liq_file SET liq02  = g_liq2[l_ac].liq02,
                                  liq03  = g_liq2[l_ac].liq03,
                                  liq04  = g_liq2[l_ac].liq04,
                                  liq05  = g_liq2[l_ac].liq05,
                                  liq08  = g_liq2[l_ac].liq08,
                                  liq081 = g_liq2[l_ac].liq081,
                                  liq082 = g_liq2[l_ac].liq082,
                                  liq083 = g_liq2[l_ac].liq083,
                                  liq084 = g_liq2[l_ac].liq084,
                                  liq09  = g_liq2[l_ac].liq09
               WHERE liq01=g_lip.lip01
                 AND liq02=g_liq2_t.liq02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","liq_file",g_lip.lip01,
                               g_liq2_t.liq02,SQLCA.sqlcode,"","",1)
                 LET g_liq2[l_ac].* = g_liq2_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET g_success = 'Y'
              END IF
           END IF

        AFTER ROW
          DISPLAY  "AFTER ROW!!"
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'a' THEN 
                CALL g_liq2.deleteElement(l_ac)
             END IF 
             IF p_cmd = 'u' THEN
                LET g_liq2[l_ac].* = g_liq2_t.*
             END IF
             CLOSE i365_bcl2
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF g_success =  'N' THEN 
             CLOSE i365_bcl2
             ROLLBACK WORK   
          ELSE 
             CLOSE i365_bcl2
          END IF 

        ON ACTION controlp
           CASE
             WHEN INFIELD(liq03_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmf02"
               LET g_qryparam.default1 = g_liq2[l_ac].liq03
               LET g_qryparam.arg1 = g_lip.lipplant
               IF NOT cl_null(g_lip.lip07) THEN
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = "  lmf03 = '",g_lip.lip07,"' AND lmf04 = '",g_lip.lip08,"'"
                   ELSE
                     LET g_qryparam.where = "  lmf03 = '",g_lip.lip07,"'"
                   END IF 
               ELSE
                   IF NOT cl_null(g_lip.lip08) THEN
                     LET g_qryparam.where = "  lmf04 = '",g_lip.lip08,"'"
                   END IF 
               END IF
               CALL cl_create_qry() RETURNING g_liq2[l_ac].liq03
               DISPLAY BY NAME g_liq2[l_ac].liq03
               OTHERWISE EXIT CASE
            END CASE

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
           CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION controls
          CALL cl_set_head_visible("","AUTO")
    END INPUT
    IF p_cmd = 'u' THEN
    LET g_lip.lipmodu = g_user
    LET g_lip.lipdate = g_today
    UPDATE lip_file
    SET lipmodu = g_lip.lipmodu,
        lipdate = g_lip.lipdate
     WHERE lip01 = g_lip.lip01
    DISPLAY BY NAME g_lip.lipmodu,g_lip.lipdate
    END IF
    CLOSE i365_bcl2
    CALL i365_delall()
END FUNCTION

FUNCTION i365_hmd03(p_cmd)
DEFINE l_imaacti    LIKE ima_file.imaacti
DEFINE l_ima02      LIKE ima_file.ima02
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_ima1010    LIKE ima_file.ima1010
   LET g_errno = ''
   SELECT imaacti,ima02,ima1010
     INTO l_imaacti,l_ima02,l_ima1010
     FROM ima_file
    WHERE ima01 = g_liq[l_ac].liq03 
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-032'
                               LET l_ima02 = ''
      WHEN l_imaacti <> 'Y'    LET g_errno = 'alm-015'
      WHEN l_ima1010 <> '1'    LET g_errno = 'alm-039'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION


FUNCTION i365_hmd04(p_cmd)
DEFINE l_gfeacti    LIKE gfe_file.gfeacti
DEFINE l_gfe02      LIKE gfe_file.gfe02
DEFINE p_cmd        LIKE type_file.chr1
    LET g_errno = ''
    SELECT gfe02,gfeacti
      INTO l_gfe02,l_gfeacti
      FROM gfe_file
     WHERE gfe01 = g_liq[l_ac].liq04
   CASE 
       WHEN SQLCA.SQLCODE = 100   LET g_errno = 'alm-011'
                                  LET l_gfe02 = ''
       WHEN l_gfeacti <> 'Y'      LET g_errno = 'alm-012'
       OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i365_delall()
DEFINE l_n   LIKE type_file.num5
    LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM liq_file
    WHERE liq01 = g_lip.lip01
      AND liqplant = g_lip.lipplant
      AND liqlegal = g_lip.liplegal
   IF l_n = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lip_file WHERE lip01 = g_lip.lip01
                             AND lipplant = g_lip.lipplant
                             AND liplegal = g_lip.liplegal
   END IF

END FUNCTION


FUNCTION i365_b_fill(p_wc2)
DEFINE p_wc2      STRING

   LET g_sql = "SELECT liq02,liq03,liq04,liq05,liq06,liq061,liq09",
               "  FROM liq_file",
               " WHERE liq01 ='",g_lip.lip01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY liq02 "

   PREPARE i365_pb FROM g_sql
   DECLARE liq_cs CURSOR FOR i365_pb

   CALL g_liq.clear()
   LET g_cnt = 1

   FOREACH liq_cs INTO g_liq[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_errno = ' '
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_liq.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i365_b1_fill(p_wc2)
DEFINE p_wc2      STRING

   LET g_sql = "SELECT liq02,liq03,liq04,liq05,liq07,liq071,liq072,liq073,liq074,liq09",
               "  FROM liq_file",
               " WHERE liq01 ='",g_lip.lip01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY liq02 "

   PREPARE i365_pb1 FROM g_sql
   DECLARE liq1_cs CURSOR FOR i365_pb1

   CALL g_liq1.clear()
   LET g_cnt = 1

   FOREACH liq1_cs INTO g_liq1[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_errno = ' '
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_liq1.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i365_b2_fill(p_wc2)
DEFINE p_wc2      STRING

   LET g_sql = "SELECT liq02,liq03,liq04,liq05,liq08,liq081,liq082,liq083,liq084,liq09",
               "  FROM liq_file",
               " WHERE liq01 ='",g_lip.lip01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY liq02 "

   PREPARE i365_pb2 FROM g_sql
   DECLARE liq2_cs CURSOR FOR i365_pb2

   CALL g_liq2.clear()
   LET g_cnt = 1

   FOREACH liq2_cs INTO g_liq2[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_errno = ' '
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_liq2.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i365_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lip01,lip04,lip05,lip06,lip11",TRUE)
    END IF

END FUNCTION

FUNCTION i365_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lip01",FALSE)
    END IF
    IF p_cmd = 'u'  AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lip05",FALSE)
       IF NOT cl_null(g_lip.lip05) THEN
           CALL cl_set_comp_entry("lip04,lip06,lip11",FALSE)
       ELSE 
           CALL cl_set_comp_entry("lip04,lip11",TRUE)
       END IF 
    END IF 
END FUNCTION


FUNCTION i365_confirm()                       #審核
   IF cl_null(g_lip.lip01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
   SELECT * INTO g_lip.* FROM lip_file WHERE lip01=g_lip.lip01
   IF g_lip.lipacti='N' THEN
        CALL cl_err('','art-142',0)
        RETURN
   END IF

   IF g_lip.lipconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF g_lip.lipconf='S' THEN
        CALL cl_err('','alm1048',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
   CALL i365_chk_lip14_lip15() 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'

   OPEN i365_cl USING g_lip.lip01
   IF STATUS THEN
      CALL cl_err("OPEN i365_cl:", STATUS, 1)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i365_cl INTO g_lip.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_lip.lipcont = Time
   UPDATE lip_file
   SET lipconf = 'Y',
       lipconu = g_user,
       lipcond = g_today,
       lipcont = g_lip.lipcont,
       lipmodu = g_user,
       lipdate = g_today,
       lip19 = '1'
    WHERE lip01 = g_lip.lip01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lip_file",g_lip.lip01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      SELECT * INTO g_lip.* FROM lip_file
       WHERE lip01 = g_lip.lip01
      DISPLAY BY NAME g_lip.lip19,g_lip.lipconf,g_lip.lipconu,g_lip.lipcond,
                      g_lip.lipmodu,g_lip.lipdate,g_lip.lipcont
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_set_field_pic(g_lip.lipconf,g_lip.lip19,"","","","")
   ELSE
      ROLLBACK WORK
   END IF
   SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_lip.lipconu
   DISPLAY g_gen02 TO gen02_1 
END FUNCTION

FUNCTION i365_s()
DEFINE l_gen02  LIKE gen_file.gen02
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lip.lip01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
   SELECT * INTO g_lip.* FROM lip_file WHERE lip01=g_lip.lip01
   IF g_lip.lipacti='N' THEN
        CALL cl_err('','alm-226',0)
        RETURN
   END IF
   IF g_lip.lipconf='N' THEN
      CALL cl_err('','alm-226',0)
      RETURN
   END IF   
   IF g_lip.lipconf='S' THEN
      CALL cl_err('','alm-935',0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i365_cl USING g_lip.lip01
   IF STATUS THEN
      CALL cl_err("OPEN i365_cl:", STATUS, 1)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i365_cl INTO g_lip.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lip.lip01,SQLCA.sqlcode,0)
      CLOSE i365_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF NOT cl_confirm('alm-227') THEN
      RETURN
   END IF 
   UPDATE lip_file SET lipconf = 'S',lip20 = g_user,lip21 = g_today 
    WHERE lip01 = g_lip.lip01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","lip_file",g_lip.lip01,"",STATUS,"","",1)
        LET g_success = 'N'
     ELSE
        LET g_lip.lipconf ='S'
        LET g_lip.lip20 = g_user
        LET g_lip.lip21 = g_today
        DISPLAY BY NAME g_lip.lipconf,g_lip.lip20,g_lip.lip21
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lip.lip20
        DISPLAY l_gen02 TO gen02_2
     END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF   
END FUNCTION
#FUN-B90121

