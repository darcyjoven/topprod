# Prog. Version..: '5.30.06-13.04.09(00004)'     #
#
# Pattern name...: almt360.4gl
# Descriptions...: 攤位意向協議維護作業
# Date & Author..: NO.FUN-B90121 11/09/23 By fanbj
# Modify.........: No:TQC-C30210 12/03/28 By fanbj BUG修改
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CA0081 12/10/22 By xumm 比例单身增加 上限和下限栏位
# Modify.........: No.CHI-D20015 13/03/27 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_lin         RECORD     LIKE lin_file.*,
       g_lin_t       RECORD     LIKE lin_file.*,
       g_lin_o       RECORD     LIKE lin_file.*,
       g_lio4        RECORD     LIKE lio_file.*,
       g_lin01_t                LIKE lin_file.lin01,
       g_lin01                  LIKE lin_file.lin01
       

DEFINE g_lio                 DYNAMIC ARRAY OF RECORD
          lio02                 LIKE lio_file.lio02,
          lio03_1               LIKE lio_file.lio03,
          lio04_1               LIKE lio_file.lio04,
          lio05_1               LIKE lio_file.lio05,
          lio06_1               LIKE lio_file.lio06,
          lio061_1              LIKE lio_file.lio061,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio06                 LIKE lio_file.lio06,
          lio061                LIKE lio_file.lio061 
                             END RECORD,

       g_lio_t               RECORD    
          lio02                 LIKE lio_file.lio02,
          lio03_1               LIKE lio_file.lio03,
          lio04_1               LIKE lio_file.lio04,
          lio05_1               LIKE lio_file.lio05,
          lio06_1               LIKE lio_file.lio06,
          lio061_1              LIKE lio_file.lio061,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio06                 LIKE lio_file.lio06,
          lio061                LIKE lio_file.lio061
                             END RECORD,

       g_lio2                DYNAMIC ARRAY OF RECORD
          lio02                 LIKE lio_file.lio02,
          lio03_2               LIKE lio_file.lio03,
          lio04_2               LIKE lio_file.lio04,
          lio05_2               LIKE lio_file.lio05,
          lio07_1               LIKE lio_file.lio07,
          lio081_2              LIKE lio_file.lio081,     #FUN-CA0081 add
          lio082_2              LIKE lio_file.lio082,     #FUN-CA0081 add
          lio071_1              LIKE lio_file.lio071,
          lio072_1              LIKE liO_file.lio072,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio07                 LIKE lio_file.lio07,
          lio081_3              LIKE lio_file.lio081,     #FUN-CA0081 add
          lio082_3              LIKE lio_file.lio082,     #FUN-CA0081 add
          lio071                LIKE lio_file.lio071,
          lio072                LIKE lio_file.lio072
                             END RECORD,
       g_lio2_t              RECORD
          lio02                 LIKE lio_file.lio02,
          lio03_2               LIKE lio_file.lio03,
          lio04_2               LIKE lio_file.lio04,
          lio05_2               LIKE lio_file.lio05,
          lio07_1               LIKE lio_file.lio07,
          lio081_2              LIKE lio_file.lio081,     #FUN-CA0081 add
          lio082_2              LIKE lio_file.lio082,     #FUN-CA0081 add
          lio071_1              LIKE lio_file.lio071,
          lio072_1              LIKE liO_file.lio072,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio07                 LIKE lio_file.lio07,
          lio081_3              LIKE lio_file.lio081,     #FUN-CA0081 add
          lio082_3              LIKE lio_file.lio082,     #FUN-CA0081 add
          lio071                LIKE lio_file.lio071,
          lio072                LIKE lio_file.lio072
                             END RECORD,
       g_lio3                DYNAMIC ARRAY OF RECORD
          lio02                 LIKE lio_file.lio02,
          lio03_3               LIKE lio_file.lio03,
          lio04_3               LIKE lio_file.lio04,
          lio05_3               LIKE lio_file.lio05,
          lio08_1               LIKE lio_file.lio08,
          lio081_1              LIKE lio_file.lio081,
          lio082_1              LIKE lio_file.lio082,
          lio083_1              LIKE lio_file.lio083,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio08                 LIKE lio_file.lio08,
          lio081                LIKE lio_file.lio081,
          lio082                LIKE lio_file.lio082,
          lio083                LIKE lio_file.lio083
                             END RECORD,
       g_lio3_t              RECORD
          lio02                 LIKE lio_file.lio02,
          lio03_3               LIKE lio_file.lio03,
          lio04_3               LIKE lio_file.lio04,
          lio05_3               LIKE lio_file.lio05,
          lio08_1               LIKE lio_file.lio08,
          lio081_1              LIKE lio_file.lio081,
          lio082_1              LIKE lio_file.lio082,
          lio083_1              LIKE lio_file.lio083,
          lio03                 LIKE lio_file.lio03,
          lio04                 LIKE lio_file.lio04,
          lio05                 LIKE lio_file.lio05,
          lio08                 LIKE lio_file.lio08,
          lio081                LIKE lio_file.lio081,
          lio082                LIKE lio_file.lio082,
          lio083                LIKE lio_file.lio083
                             END RECORD

DEFINE g_wc                     STRING
DEFINE g_wc1                    STRING   
DEFINE g_wc2                    STRING  
DEFINE g_wc3                    STRING 
DEFINE g_sql                    STRING
DEFINE g_forupd_sql             STRING       #SELECT ... FOR UPDATE SQL
DEFINE g_input_done             LIKE type_file.num5
DEFINE g_chr                    LIKE type_file.chr1
DEFINE g_cnt                    LIKE type_file.num10
DEFINE g_i                      LIKE type_file.num5      
DEFINE g_msg                    LIKE type_file.chr1000
DEFINE g_curs_index             LIKE type_file.num10
DEFINE g_row_count              LIKE type_file.num10
DEFINE g_jump                   LIKE type_file.num10
DEFINE g_no_ask                 LIKE type_file.num5
DEFINE g_void                   LIKE type_file.chr1
DEFINE g_confirm                LIKE type_file.chr1
DEFINE g_date                   LIKE lne_file.lnedate
DEFINE g_modu                   LIKE lne_file.lnemodu
DEFINE g_flag2                  LIKE type_file.chr1    
DEFINE l_ac1                    LIKE type_file.num5
DEFINE l_ac2                    LIKE type_file.num5
DEFINE l_ac3                    LIKE type_file.num5
DEFINE g_rec_b1                 LIKE type_file.num5
DEFINE g_rec_b2                 LIKE type_file.num5
DEFINE g_kindslip               LIKE oay_file.oayslip
DEFINE g_rec_b3                 LIKE type_file.num5
DEFINE g_b_flag                 LIKE type_file.chr1
DEFINE g_argv1                  LIKE lin_file.lin00

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lin_file WHERE lin01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW t360_w WITH FORM "alm/42f/almt360"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   
   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_comp_visible("lir06",FALSE)
      LET g_lin.lin00 = g_argv1
      DISPLAY BY NAME g_lin.lin00
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
   
   CALL t360_menu()
   CLOSE WINDOW t360_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t360_curs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   DEFINE  l_table         LIKE    type_file.chr1000
   DEFINE  l_where         LIKE    type_file.chr1000     
   
   CLEAR FORM
   CALL g_lio.clear() 
   CALL g_lio2.clear()
   CALL g_lio3.clear()

   IF cl_null(g_argv1) THEN
      DIALOG ATTRIBUTE(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON
                           lin00,lin01,lin02,lin03,lin04,lin05,lin06,linplant,
                           linlegal, lin07,lin08,lin09,lin10,lin11,lin12,lin13,
                           lin14,lin141,lin15,lin151,lin16,lin161,linmksg,lin17,
                           linconf,linconu,lincond,lincont,lin18,linuser,lingrup,
                           linoriu,linmodu,lindate,linorig,linacti,lincrat
                           
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
               

               ON ACTION controlp
                  CASE
                     WHEN INFIELD(lin01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin01"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin01
                        NEXT FIELD lin01

                     WHEN INFIELD(lin03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin03"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin03
                        NEXT FIELD lin03

                     WHEN INFIELD(lin04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin04"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin04
                        NEXT FIELD lin04

                     WHEN INFIELD(lin06)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin06"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin06
                        NEXT FIELD lin06

                     WHEN INFIELD(linplant)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_linplant"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO linplant
                        NEXT FIELD linplant

                     WHEN INFIELD(linlegal)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_linlegal"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO linlegal
                        NEXT FIELD linlegal
                         
                     WHEN INFIELD(lin07)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin07"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin07
                        NEXT FIELD lin07

                     WHEN INFIELD(lin08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin08"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin08
                        NEXT FIELD lin08

                     WHEN INFIELD(lin09)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin09"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin09
                        NEXT FIELD lin09
                     
                     WHEN INFIELD(lin10)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin10"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin10
                        NEXT FIELD lin10

                     WHEN INFIELD(lin11)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_lin11"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lin11
                        NEXT FIELD lin11

           
                     WHEN INFIELD(linconu)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_linconu"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO linconu
                        NEXT FIELD linconu

                     OTHERWISE
                        EXIT CASE
                  END CASE
         END CONSTRUCT

         
         CONSTRUCT g_wc1 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio06,b.lio061
                       FROM s_lio[1].lio02,s_lio[1].lio03,s_lio[1].lio04,
                            s_lio[1].lio05, s_lio[1].lio06,s_lio[1].lio061

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT

         CONSTRUCT g_wc2 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio07,
                            b.lio081_3,b.lio082_3,b.lio071,b.lio072                                 #FUN-CA0081 add b.lio081_3,b.lio082_3,
                       FROM s_lio2[1].lio02,s_lio2[1].lio03,s_lio2[1].lio04,
                            s_lio2[1].lio05,s_lio2[1].lio07,s_lio2[1].lio081_3,s_lio2[1].lio082_3,  #FUN-CA0081 add s_lio2[1].lio081_3,s_lio2[1].lio082_3,
                            s_lio2[1].lio071,s_lio2[1].lio072

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
 
         CONSTRUCT g_wc3 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio08,b.lio081,
                            b.lio082,b.lio083
                       FROM s_lio3[1].lio02,s_lio3[1].lio03,s_lio3[1].lio04,
                            s_lio3[1].lio05,s_lio3[1].lio08,s_lio3[1].lio081,
                            s_lio3[1].lio082,s_lio3[1].lio083

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
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

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG

      END DIALOG       
   ELSE
   
      LET g_lin.lin00 = g_argv1
      DISPLAY BY NAME g_lin.lin00
      
      IF g_lin.lin00 = '1' THEN
         CALL cl_set_comp_visible("page4,page5",FALSE)
      END IF    

      IF g_lin.lin00 = '2' THEN
         CALL cl_set_comp_visible("page3,page5",FALSE)
      END IF 
  
      IF g_lin.lin00 = '3' THEN
         CALL cl_set_comp_visible("page3,page4",FALSE)
      END IF 

      DIALOG ATTRIBUTE(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON
                           lin01,lin02,lin03,lin04,lin05,lin06,linplant,linlegal,
                           lin07,lin08,lin09,lin10,lin11,lin12,lin13,lin14,lin141,lin15,
                           lin151,lin16,lin161,linmksg,lin17,linconf,linconu,lincond,lincont,
                           lin18,linuser,lingrup,linoriu,linmodu,lindate,linorig,linacti,lincrat
            BEFORE CONSTRUCT
               CALL cl_qbe_init()


            ON ACTION controlp
               CASE
                  WHEN INFIELD(lin01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin01
                     NEXT FIELD lin01

                  WHEN INFIELD(lin03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin03"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin03
                     NEXT FIELD lin03

                  WHEN INFIELD(lin04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin04"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin04
                     NEXT FIELD lin04

                  WHEN INFIELD(lin06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin06"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin06
                     NEXT FIELD lin06

                  WHEN INFIELD(linplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_linplant"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO linplant
                     NEXT FIELD linplant

                  WHEN INFIELD(linlegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_linlegal"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO linlegal
                     NEXT FIELD linlegal

                  WHEN INFIELD(lin07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin07"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin07
                     NEXT FIELD lin07

                  WHEN INFIELD(lin08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin08"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin08
                     NEXT FIELD lin08

                  WHEN INFIELD(lin09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin09"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin09
                     NEXT FIELD lin09

                  WHEN INFIELD(lin10)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin10"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin10
                     NEXT FIELD lin10

                  WHEN INFIELD(lin11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lin11"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lin11
                     NEXT FIELD lin11


                  WHEN INFIELD(linconu)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_linconu"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO linconu
                     NEXT FIELD linconu

                  OTHERWISE
                     EXIT CASE
               END CASE
         END CONSTRUCT
      
         CONSTRUCT g_wc1 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio06,b.lio061
                       FROM s_lio[1].lio02,s_lio[1].lio03,s_lio[1].lio04,
                            s_lio[1].lio05, s_lio[1].lio06,s_lio[1].lio061

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

         END CONSTRUCT
 
         CONSTRUCT g_wc2 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio07,b.lio071,b.lio072
                       FROM s_lio2[1].lio02,s_lio2[1].lio03,s_lio2[1].lio04,
                            s_lio2[1].lio05,s_lio2[1].lio07,s_lio2[1].lio071,
                            s_lio2[1].lio072

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

         END CONSTRUCT

         CONSTRUCT g_wc3 ON b.lio02,b.lio03,b.lio04,b.lio05,b.lio08,b.lio081,b.lio082,b.lio083
                       FROM s_lio3[1].lio02,s_lio3[1].lio03,s_lio3[1].lio04,
                            s_lio3[1].lio05,s_lio3[1].lio08,s_lio3[1].lio081,
                            s_lio3[1].lio082,s_lio3[1].lio083

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

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

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG
      END DIALOG   
   END IF

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT lin01 " 
   LET l_table = " FROM lin_file "

   IF cl_null(g_argv1) THEN
      LET l_where = " WHERE ",g_wc 
   ELSE
       LET l_where = " WHERE ",g_wc,
                     "  AND lin00 = '",g_argv1,"'"
   END IF

   IF g_wc1 <> " 1=1" OR g_wc2 <> " 1=1" OR g_wc3 <> " 1=1" THEN
      LET l_table = l_table,",lio_file b"
      LET l_where = l_where," AND lin01 = b.lio01 AND ",g_wc1," AND ",g_wc2," AND ",g_wc3
   END IF
   LET g_sql = g_sql,l_table,l_where," ORDER BY lin01"
 
   PREPARE t360_prepare FROM g_sql
   DECLARE t360_cs SCROLL CURSOR WITH HOLD FOR t360_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT lin01) ",l_table,l_where
   PREPARE t360_precount FROM g_sql
   DECLARE t360_count CURSOR FOR t360_precount
END FUNCTION
          
FUNCTION t360_menu() 
   DEFINE l_msg        LIKE type_file.chr1000   
   DEFINE l_count      LIKE type_file.num5
   DEFINE g_body       LIKE type_file.chr1
                         
   WHILE TRUE      
      IF g_action_choice = "exit"  THEN
        EXIT WHILE
      END IF 

      CALL t360_bp("G")
      
   
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t360_a() 
            END IF        
                         
         WHEN "query"     
            IF cl_chk_act_auth() THEN
               CALL t360_q()  
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t360_u()
            END IF

         WHEN "invalid"
             IF cl_chk_act_auth() THEN
                CALL t360_x()
             END IF   

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t360_r()
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t360_confirm()
            END IF

         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lin.lin01) THEN
                  CALL t360_cer_confirm()
               ELSE
                  CALL cl_err('','-400',1)
               END IF
            END IF

        # WHEN "exporttoexcel"
        #     IF cl_chk_act_auth() THEN
        #        CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lio),
        #           base.TypeInfo.create(g_lio2),base.TypeInfo.create(g_lio3))
        #     END IF   

         WHEN "change_post"
            IF cl_chk_act_auth() THEN
               CALL t360_post()
            END IF
           
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exit"
            EXIT WHILE

         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lin.lin01) THEN
                  LET g_doc.column1 = "lin01"
                  LET g_doc.value1 = g_lin.lin01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag = 1 THEN
                  CALL t360_b1()
               END IF

               IF g_b_flag = 2 THEN
                  CALL t360_b2()
               END IF 
               
               IF g_b_flag = 3 THEN
                  CALL t360_b3()
               END IF 
            END IF
      END CASE
   END WHILE
   CLOSE t360_cs
END FUNCTION

FUNCTION t360_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lio TO s_lio.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_b_flag = '1'
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_b_flag = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_lio2 TO s_lio2.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_b_flag = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_b_flag = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY


      DISPLAY ARRAY g_lio3 TO s_lio3.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_b_flag = '3'
            LET l_ac3 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_b_flag = '3'
            LET l_ac3 = ARR_CURR()
            EXIT DIALOG
      END DISPLAY

     # ON ACTION exporttoexcel
     #    LET g_action_choice = 'exporttoexcel'
     #    EXIT DIALOG

      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice = "query"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice = "modify"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DIALOG

      ON ACTION invalid
        LET g_action_choice="invalid"
        EXIT DIALOG 

      ON ACTION first
         CALL t360_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
         
      ON ACTION previous
         CALL t360_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t360_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t360_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t360_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG

      ON ACTION unconfirm 
         LET g_action_choice = "unconfirm"
         EXIT DIALOG

      ON ACTION change_post
         LET g_action_choice="change_post"
       EXIT DIALOG

      ON ACTION help
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t360_q()
   LET  g_row_count = 0
   LET  g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   INITIALIZE g_lin.* TO NULL
   INITIALIZE g_lin_t.* TO NULL
   INITIALIZE g_lin_o.* TO NULL
   
   LET g_lin01_t = NULL
   LET g_wc = NULL
   
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
   
   CALL t360_curs()  
         
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_lin.* TO NULL
      CALL g_lio.clear()
      CALL g_lio2.clear()
      CALL g_lio3.clear()
      LET g_wc1 = NULL
      LET g_wc2 = NULL
      LET g_wc3 = NULL
      LET g_lin01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
   
   MESSAGE " SEARCHING ! "
   OPEN t360_cs   
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      INITIALIZE g_lin.* TO NULL
      LET g_lin01_t = NULL
      LET g_wc = NULL
   ELSE
      OPEN t360_count
      FETCH t360_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t360_fetch('F')  
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t360_fetch(p_icb)
   DEFINE p_icb LIKE type_file.chr1 
 
   CASE p_icb
      WHEN 'N' FETCH NEXT     t360_cs INTO g_lin.lin01
      WHEN 'P' FETCH PREVIOUS t360_cs INTO g_lin.lin01
      WHEN 'F' FETCH FIRST    t360_cs INTO g_lin.lin01
      WHEN 'L' FETCH LAST     t360_cs INTO g_lin.lin01
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
         FETCH ABSOLUTE g_jump t360_cs INTO g_lin.lin01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      INITIALIZE g_lin.* TO NULL
      CALL g_lio.clear()
      CALL g_lio2.clear()
      CALL g_lio3.clear()
      LET g_lin01_t = NULL
      RETURN
   ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
   END IF
 
   SELECT * INTO g_lin.* FROM lin_file  
    WHERE lin01 = g_lin.lin01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_lin.linuser 
      LET g_data_group = g_lin.lingrup
      CALL t360_show() 
   END IF
END FUNCTION
 
FUNCTION t360_show()
   LET g_lin_t.* = g_lin.*
   LET g_lin_o.* = g_lin.*
   DISPLAY BY NAME g_lin.lin00, g_lin.lin01,g_lin.lin02,g_lin.lin03,g_lin.lin04,
                   g_lin.lin05, g_lin.lin06,g_lin.linplant,g_lin.linlegal,g_lin.lin07,
                   g_lin.lin08,g_lin.lin09,g_lin.lin10,g_lin.lin11,g_lin.lin12,
                   g_lin.lin13,g_lin.lin14,g_lin.lin141,g_lin.lin15,
                   g_lin.lin151,g_lin.lin16,g_lin.lin161,g_lin.linmksg,
                   g_lin.lin17,g_lin.linconf,g_lin.linconu,g_lin.lincond,
                   g_lin.lincont,g_lin.lin18,g_lin.linuser,g_lin.lingrup,
                   g_lin.linoriu,g_lin.linmodu,g_lin.lindate,g_lin.linorig,
                   g_lin.linacti,g_lin.lincrat
                            
   CALL cl_set_field_pic(g_lin.linconf,"","","","","")   

   CALL t360_desc()
   IF g_lin.lin00 = '1' THEN
      CALL cl_set_comp_visible('Page4,Page5',FALSE)
      CALL cl_set_comp_visible('Page3',TRUE)
      CALL t360_b1_fill(g_wc1)
   END IF

   IF g_lin.lin00 = '2' THEN
      CALL cl_set_comp_visible('Page3,Page5',FALSE)
      CALL cl_set_comp_visible('Page4',TRUE)
      CALL t360_b2_fill(g_wc2)
   END IF

   IF g_lin.lin00 = '3' THEN
      CALL cl_set_comp_visible('Page3,Page4',FALSE)
      CALL cl_set_comp_visible('Page5',TRUE)
      CALL t360_b3_fill(g_wc3)
   END IF
   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION t360_desc()
   DEFINE l_gen02    LIKE gen_file.gen02,
          l_oaj02    LIKE oaj_file.oaj02,
          l_rtz13    LIKE rtz_file.rtz13,
          l_azt02    LIKE azt_file.azt02,
          l_lmb03    LIKE lmb_file.lmb03,
          l_lmc04    LIKE lmc_file.lmc04,
          l_lmy04    LIKE lmy_file.lmy04,
          l_oba02    LIKE oba_file.oba02,
          l_tqa02    LIKE tqa_file.tqa02, 
          l_gen02_1  LIKE gen_file.gen02

   SELECT gen02 INTO l_gen02 
     FROM gen_file 
    WHERE gen01 = g_lin.lin03
   DISPLAY l_gen02 TO FORMONLY.gen02   
   
   SELECT oaj02 INTO l_oaj02 
     FROM oaj_file 
    WHERE oaj01 = g_lin.lin06
   DISPLAY l_oaj02 TO FORMONLY.oaj02

   SELECT rtz13 INTO l_rtz13 
     FROM rtz_file 
    WHERE rtz01 = g_lin.linplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13

   SELECT azt02 INTO l_azt02 
     FROM azt_file 
    WHERE azt01 = g_lin.linlegal
   DISPLAY l_azt02 TO FORMONLY.azt02
   
   SELECT lmb03 INTO l_lmb03 
     FROM lmb_file 
    WHERE lmbstore = g_lin.linplant 
      AND lmb02 = g_lin.lin07
   DISPLAY l_lmb03  TO FORMONLY.lmb03
   
   IF NOT cl_null(g_lin.lin07) THEN
      SELECT lmc04 INTO l_lmc04 
        FROM lmc_file 
       WHERE lmcstore = g_lin.linplant 
         AND lmc02 = g_lin.lin07 
         AND lmc03 = g_lin.lin08
      DISPLAY l_lmc04  TO FORMONLY.lmc04
   ELSE
      SELECT lmc04 INTO l_lmc04
        FROM lmc_file
       WHERE lmcstore = g_lin.linplant
         AND lmc03 = g_lin.lin08
      IF SQLCA.sqlcode = -284 THEN
         DISPLAY '' TO FORMONLY.lmc04
      ELSE 
         DISPLAY l_lmc04  TO FORMONLY.lmc04
      END IF 
   END IF 
   
   IF NOT cl_null(g_lin.lin07) THEN
      IF NOT cl_null( g_lin.lin08) THEN
         SELECT lmy04 INTO l_lmy04 
           FROM lmy_file 
          WHERE lmystore = g_lin.linplant 
            AND lmy01 = g_lin.lin07
            AND lmy02 = g_lin.lin08 
            AND lmy03 = g_lin.lin09
         DISPLAY l_lmy04  TO FORMONLY.lmy04
      ELSE
         SELECT lmy04 INTO l_lmy04
           FROM lmy_file
          WHERE lmystore = g_lin.linplant
            AND lmy01 = g_lin.lin07
            AND lmy03 = g_lin.lin09
         IF SQLCA.sqlcode = -284 THEN
            DISPLAY '' TO FORMONLY.lmy04
         ELSE
            DISPLAY l_lmy04  TO FORMONLY.lmy04
         END IF
      END IF 
   ELSE
      IF NOT cl_null( g_lin.lin08) THEN
         SELECT lmy04 INTO l_lmy04
           FROM lmy_file
          WHERE lmystore = g_lin.linplant
            AND lmy02 = g_lin.lin08
            AND lmy03 = g_lin.lin09

         IF SQLCA.sqlcode = -284 THEN
            DISPLAY '' TO FORMONLY.lmy04
         ELSE
            DISPLAY l_lmy04  TO FORMONLY.lmy04
         END IF
      ELSE
         SELECT lmy04 INTO l_lmy04
           FROM lmy_file
          WHERE lmystore = g_lin.linplant
            AND lmy03 = g_lin.lin09

         IF SQLCA.sqlcode = -284 THEN
            DISPLAY '' TO FORMONLY.lmy04
         ELSE
            DISPLAY l_lmy04  TO FORMONLY.lmy04
         END IF
      END IF   
      
   END IF 
   
   SELECT oba02 INTO l_oba02 
     FROM oba_file 
    WHERE oba01 = g_lin.lin10
   DISPLAY l_oba02  TO FORMONLY.oba02

   SELECT tqa02 INTO l_tqa02 
     FROM tqa_file 
    WHERE tqa01= g_lin.lin11 
      AND tqa03 = '30'
   DISPLAY l_tqa02 TO FORMONLY.tqa02
   
   SELECT gen02 INTO l_gen02_1 
     FROM gen_file 
    WHERE gen01 = g_lin.linconu
   DISPLAY l_gen02_1 TO FORMONLY.gen02_1
   
END FUNCTION

FUNCTION t360_b1()
   DEFINE l_ac1_t         LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_lio03         LIKE lio_file.lio03,
          l_lio04         LIKE lio_file.lio04,
          l_lio05         LIKE lio_file.lio05,
          l_qty           LIKE type_file.num10,
          l_lock_sw       LIKE type_file.chr1,
          p_cmd           LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_cnt           LIKE type_file.num5,
          l_success       LIKE type_file.chr1

   DEFINE l_lio        RECORD 
             lio02        LIKE lio_file.lio02,
             lio03        LIKE lio_file.lio03,
             lio04        LIKE lio_file.lio04,
             lio05        LIKE lio_file.lio05,
             lio06        LIKE lio_file.lio06,
             lio061       LIKE lio_file.lio061
                       END RECORD

   DEFINE  l_sql          STRING 

   LET g_action_choice = ""
   MESSAGE ""   

   IF s_shut(0) THEN RETURN END IF
   IF g_lin.lin01 IS NULL OR g_lin.linplant IS NULL THEN 
      RETURN 
   END IF
      
   SELECT * INTO g_lin.* 
     FROM lin_file
    WHERE lin01=g_lin.lin01 

   IF g_lin.linacti = 'N' THEN 
      CALL cl_err('','mfg1000',0) 
      RETURN 
   END IF     

   IF g_lin.linconf='Y' THEN 
      CALL cl_err('','art-046',0) 
      RETURN 
   END IF
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       " SELECT lio02,lio03,lio04,lio05,lio06,lio061",
       "  FROM lio_file ",
       " WHERE lio02=?  AND lio01='",g_lin.lin01,"'",
       "   AND lio03 = ?",
       " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc11 CURSOR FROM g_forupd_sql

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc12 CURSOR FROM g_forupd_sql

   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lio WITHOUT DEFAULTS FROM s_lio.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
            LET l_ac1 = 1
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
 
         OPEN t360_cl USING g_lin.lin01
         IF STATUS THEN
            CALL cl_err("OPEN t360_cl:", STATUS, 1)
            CLOSE t360_cl
            ROLLBACK WORK
            RETURN
         END IF

         FETCH t360_cl INTO g_lin.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lin.lin01,SQLCA.SQLCODE,0)
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b1>=l_ac1 THEN
            LET g_lio_t.* = g_lio[l_ac1].*  #BACKUP
            LET p_cmd='u'

            SELECT count(*) INTO l_n FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_liO[l_ac1].lio02
               AND lio03 = '0'
            IF l_n > 0 THEN
               OPEN t360_bc11 USING g_lio_t.lio02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc11:", STATUS, 1)
                  CLOSE t360_bc11
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t360_bc11 INTO g_lio[l_ac1].lio02,g_lio[l_ac1].lio03_1,g_lio[l_ac1].lio04_1,
                                    g_lio[l_ac1].lio05_1,g_lio[l_ac1].lio06_1,g_lio[l_ac1].lio061_1
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF

            SELECT lio03 INTO g_lio[l_ac1].lio03 FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_liO[l_ac1].lio02
               AND (lio03 = '1' OR lio03='2')

            IF NOT cl_null(g_lio[l_ac1].lio03) THEN
               OPEN t360_bc12 USING g_lio_t.lio02,g_lio[l_ac1].lio03
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc12:", STATUS, 1)
                  CLOSE t360_bc12
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t360_bc12 INTO g_lio[l_ac1].lio02,g_lio[l_ac1].lio03,g_lio[l_ac1].lio04,
                                                   g_lio[l_ac1].lio05,g_lio[l_ac1].lio06,g_lio[l_ac1].lio061
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            #NEXT FIELD lio02
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_lio[l_ac1].* TO NULL
         LET g_lio_t.* = g_lio[l_ac1].*
         CALL cl_show_fld_cont()
         LET g_lio[l_ac1].lio03 = '2' 
         LET g_lio[l_ac1].lio061 = '1'        
         NEXT FIELD lio02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio06,lio061,
                              lioplant,liolegal)
            VALUES(g_lin.lin01,g_lio[l_ac1].lio02,g_lio[l_ac1].lio03,
                   g_lio[l_ac1].lio04,g_lio[l_ac1].lio05,g_lio[l_ac1].lio06,
                  g_lio[l_ac1].lio061,g_lin.linplant,g_lin.linlegal)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b1=g_rec_b1+1   
            DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF

      BEFORE DELETE  
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF

         LET l_lio03 = g_lio[l_ac1].lio03

         CALL t360_lio_b_delete(g_lio_t.lio02)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0) 
            CANCEL DELETE
         END IF 
        
         SELECT count(*) INTO l_n
           FROM lio_file
          WHERE lio01 = g_lin.lin01 
            AND lio02 = g_lio[l_ac1].lio02
        
         IF (l_n = '1' AND g_lio[l_ac1].lio03_1 = '0') THEN
            CANCEL DELETE
         END IF 

         DELETE FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = g_lio_t.lio02
            AND lio03 = g_lio[l_ac1].lio03

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lio_file",g_lin.lin01,g_lio_t.lio02,
                             SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
            IF l_lio03 = '1' THEN 
               LET g_lio[l_ac1].lio03 = ''
               LET g_lio[l_ac1].lio04 = ''
               LET g_lio[l_ac1].lio05 = ''
               LET g_lio[l_ac1].lio06 = ''
               LET g_lio[l_ac1].lio061 = ''
               CANCEL DELETE
               COMMIT WORK
            END IF
        END IF

         IF l_lio03 = '2' THEN
            LET g_rec_b1=g_rec_b1-1
         END IF
         DISPLAY g_rec_b1 TO FORMONLY.cn2
         COMMIT WORK
          
      BEFORE FIELD lio02
         IF g_lio[l_ac1].lio02 IS NULL OR g_lio[l_ac1].lio02 = 0 THEN
            SELECT max(lio02)
              INTO g_lio[l_ac1].lio02
              FROM lio_file
             WHERE lio01 = g_lin.lin01
            IF g_lio[l_ac1].lio02 IS NULL THEN
               LET g_lio[l_ac1].lio02 = 1
            ELSE
               LET g_lio[l_ac1].lio02 =g_lio[l_ac1].lio02+1
            END IF
         END IF    
          
      AFTER FIELD lio02
         IF NOT cl_null(g_lio[l_ac1].lio02) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND 
                  g_lio[l_ac1].lio02!=g_lio_t.lio02) THEN
                SELECT count(*) INTO l_n
                  FROM lio_file
                  WHERE lio01 = g_lin.lin01
                    AND lio02 = g_lio[l_ac1].lio02
                IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lio[l_ac1].lio02 = g_lio_t.lio02
                  NEXT FIELD lio02
               END IF 
            END IF
         END IF

      AFTER FIELD lio04
         IF NOT cl_null(g_lio[l_ac1].lio04) THEN
            CALL t360_chk_lio_date(g_lio[l_ac1].lio02,p_cmd) 
                  RETURNING l_success
            IF l_success <> 'S'  THEN

               IF NOT cl_null(g_lio[l_ac1].lio05) THEN
                  IF g_lio[l_ac1].lio04 > g_lio[l_ac1].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio[l_ac1].lio04 = g_lio_t.lio04
                     NEXT FIELD lio04
                  END IF
               END IF
               CALL t360_chk_lio04(g_lio[l_ac1].lio04,g_lio[l_ac1].lio05,
                                     g_lio[l_ac1].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio[l_ac1].lio04 = g_lio_t.lio04
                  NEXT FIELD lio04
               END IF  
            END IF  
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio[l_ac1].lio02,g_lio[l_ac1].lio03) 
                                RETURNING g_lio[l_ac1].lio03
            END IF
         END IF 

      AFTER FIELD lio05
         IF NOT cl_null(g_lio[l_ac1].lio05) THEN
            CALL t360_chk_lio_date(g_lio[l_ac1].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S'  THEN

               IF NOT cl_null(g_lio[l_ac1].lio04) THEN
                  IF g_lio[l_ac1].lio04 > g_lio[l_ac1].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio[l_ac1].lio05 = g_lio_t.lio05
                     NEXT FIELD lio05
                  END IF
               END IF
               
               CALL t360_chk_lio04(g_lio[l_ac1].lio04,g_lio[l_ac1].lio05,
                                   g_lio[l_ac1].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio[l_ac1].lio05 = g_lio_t.lio05
                  NEXT FIELD lio05
               END IF
            END IF    
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio[l_ac1].lio02,g_lio[l_ac1].lio03)
                             RETURNING g_lio[l_ac1].lio03
            END IF
         END IF 

      AFTER FIELD lio06
         IF NOT cl_null(g_lio[l_ac1].lio06 ) THEN
            CALL t360_chk_lio_date(g_lio[l_ac1].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S'  THEN
               IF g_lio[l_ac1].lio06 < 0 THEN
                  CALL cl_err( '','alm1080',0)
                  LET g_lio[l_ac1].lio06 = g_lio_t.lio06
                  NEXT FIELD lio06
               END IF
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio[l_ac1].lio02,g_lio[l_ac1].lio03)
                        RETURNING g_lio[l_ac1].lio03
            END IF
         END IF 

      AFTER FIELD lio061
         IF NOT cl_null( g_lio[l_ac1].lio061) THEN
            CALL t360_chk_lio_date(g_lio[l_ac1].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S'  THEN
               IF g_lio[l_ac1].lio061 <= 0 THEN
                  CALL cl_err( '','alm1079',0)
                  LET g_lio[l_ac1].lio06 = g_lio_t.lio06
                  NEXT FIELD lio06
               END IF 
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio[l_ac1].lio02,g_lio[l_ac1].lio03)
                        RETURNING g_lio[l_ac1].lio03
            END IF
         END IF 
        
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lio[l_ac1].* = g_lio_t.*
            CLOSE t360_bc11
            CLOSE t360_bc12
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lio[l_ac1].lio02,-263,1) 
            LET g_lio[l_ac1].* = g_lio_t.*
         ELSE
            SELECT count(*) INTO l_n
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_lio[l_ac1].lio02
               AND lio03 = g_lio[l_ac1].lio03

            IF l_n > 0 THEN
               UPDATE lio_file
                  SET lio04 = g_lio[l_ac1].lio04,
                      lio05 = g_lio[l_ac1].lio05,
                      lio06 = g_lio[l_ac1].lio06,
                      lio061 = g_lio[l_ac1].lio061
                WHERE lio01 = g_lin.lin01
                  AND lio02 = g_lio[l_ac1].lio02
                  AND lio03 = g_lio[l_ac1].lio03

               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  LET g_lio[l_ac1].* = g_lio_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            ELSE
               INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio06,lio061,lioplant,liolegal)
                    VALUES (g_lin.lin01,g_lio[l_ac1].lio02,g_lio[l_ac1].lio03,
                            g_lio[l_ac1].lio04,g_lio[l_ac1].lio05,g_lio[l_ac1].lio06,
                            g_lio[l_ac1].lio061,g_lin.linplant,g_lin.linlegal)
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  ROLLBACK WORK
               END IF
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac1= ARR_CURR()
         LET l_ac1_t = l_ac1
         
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            
            IF p_cmd = 'a' THEN
               CALL g_lio.deleteElement(l_ac1)
            END IF

            IF p_cmd = 'u' THEN
               LET g_lio[l_ac1].* = g_lio_t.*
            END IF
            CLOSE t360_bc11
            CLOSE t360_bc12
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t360_bc11
         CLOSE t360_bc12
         COMMIT WORK
 
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
 
      ON ACTION HELP
         CALL cl_show_help()
                                                                                                            
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END INPUT
   IF p_cmd = 'u' THEN
      LET g_lin.linmodu = g_user
      LET g_lin.lindate = g_today
      UPDATE lin_file SET linmodu = g_lin.linmodu,
                          lindate = g_lin.lindate
         WHERE lin01 = g_lin.lin01 

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lin_file",g_lin.lin01,"",SQLCA.SQLCODE,"","upd lin",1)  
      END IF

      DISPLAY BY NAME g_lin.linmodu,g_lin.lindate
   END IF
   CLOSE t360_bc11
   CLOSE t360_bc12
   COMMIT WORK
END FUNCTION

FUNCTION t360_chk_lio_date(p_lio02,p_cmd)
   DEFINE l_n         LIKE type_file.num5,
          p_cmd       LIKE type_file.chr1,
          l_lio04     LIKE lio_file.lio04,
          l_lio05     LIKE lio_file.lio05,
          p_lio02     LIKE lio_file.lio02
 
   IF p_cmd = 'u' THEN  
      SELECT count(*) INTO l_n
        FROM lio_file
       WHERE lio01 = g_lin.lin01
         AND lio02 = p_lio02
         AND lio03 = '0'
      IF l_n > 0 THEN
         SELECT lio04,lio05 INTO l_lio04,l_lio05
           FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = p_lio02
            AND lio03 = '0'
         
         IF l_lio04 <= g_today OR l_lio05 < g_today THEN
            CASE g_b_flag
               WHEN '1'
                  LET g_lio[l_ac1].lio04 = g_lio[l_ac1].lio04_1
                  LET g_lio[l_ac1].lio06 = g_lio[l_ac1].lio06_1
                  LET g_lio[l_ac1].lio061 = g_lio[l_ac1].lio061_1
               WHEN '2'
                  LET g_lio2[l_ac2].lio04 = g_lio2[l_ac2].lio04_2
                  LET g_lio2[l_ac2].lio07 = g_lio2[l_ac2].lio07_1
                  LET g_lio2[l_ac2].lio081_3 = g_lio2[l_ac2].lio081_3   #FUN-CA0081 add
                  LET g_lio2[l_ac2].lio082_3 = g_lio2[l_ac2].lio082_3   #FUN-CA0081 add
                  LET g_lio2[l_ac2].lio071 = g_lio2[l_ac2].lio071_1
                  LET g_lio2[l_ac2].lio072 = g_lio2[l_ac2].lio072_1
               WHEN '3'
                  LET g_lio3[l_ac3].lio04 = g_lio3[l_ac3].lio04_3
                  LET g_lio3[l_ac3].lio08 = g_lio3[l_ac3].lio08_1
                  LET g_lio3[l_ac3].lio081 = g_lio3[l_ac3].lio081_1          
                  LET g_lio3[l_ac3].lio082 = g_lio3[l_ac3].lio082_1
                  LET g_lio3[l_ac3].lio083 = g_lio3[l_ac3].lio083_1  
            END CASE
            
            IF l_lio05 < g_today THEN
               CASE g_b_flag
                  WHEN '1'
                     LET g_lio[l_ac1].lio05 = g_lio[l_ac1].lio05_1
                  WHEN '2'
                     LET g_lio2[l_ac2].lio05 = g_lio2[l_ac2].lio05_2
                  WHEN '3'
                     LET g_lio3[l_ac3].lio05 = g_lio3[l_ac3].lio05_3
               END CASE
               RETURN 'S'
            #TQC-C30210--start add-----------------------------------
            ELSE
               CASE g_b_flag
                  WHEN '1'
                     IF g_lio[l_ac1].lio05 <= g_today THEN
                        LET g_lio[l_ac1].lio05 = g_today
                     END IF
                  WHEN '2'
                     IF g_lio2[l_ac2].lio05 <= g_today THEN
                        LET g_lio2[l_ac2].lio05 = g_today
                     END IF 
                  WHEN '3'
                     IF g_lio3[l_ac3].lio05 <= g_today THEN
                        LET g_lio3[l_ac3].lio05 = g_today
                     END IF 
               END CASE 
               RETURN 'Y'
            #TQC-C30210--end add------------------------------------- 
            END IF
            RETURN 'Y'
         ELSE
            RETURN 'N' 
         END IF 
      ELSE
         RETURN 'N' 
      END IF
   ELSE 
      RETURN 'N'
   END IF
END FUNCTION

FUNCTION t360_chk_ins(l_lio02,p_lio03)
   DEFINE p_lio03       LIKE lio_file.lio03, 
          l_n           LIKE type_file.num5,
          l_lio02       LIKE lio_file.lio02
        
   SELECT count(*) INTO l_n 
     FROM lio_file
    WHERE lio01 = g_lin.lin01
      AND lio02 = l_lio02 
      AND lio03 = '0'     

   IF l_n > 0 THEN
      LET  p_lio03 = '1'
   END IF
   
   RETURN p_lio03 
   
END FUNCTION

FUNCTION t360_chk_b3_field(p_cmd)
   DEFINE l_lio04         LIKE lio_file.lio04,
          l_lio05         LIKE lio_file.lio05,
          l_lio081        LIKE lio_file.lio081,
          l_lio082        LIKE lio_file.lio082,
          l_n             LIKE type_file.num5,
          startdate       LIKE lin_file.lin14,
          enddate         LIKE lin_file.lin15,
          p_cmd           LIKE type_file.chr1
   
   LET g_errno = ''
   
   IF NOT cl_null(g_lin.lin141) THEN
      LET startdate = g_lin.lin141
   ELSE 
      LET startdate = g_lin.lin14
   END IF 
 
   IF NOT cl_null(g_lin.lin151) THEN
      LET enddate = g_lin.lin151
   ELSE 
      LET enddate = g_lin.lin15
   END IF 

   IF g_lio3[l_ac3].lio04 < startdate OR
      g_lio3[l_ac3].lio05 > enddate OR 
      g_lio3[l_ac3].lio04 > enddate OR
      g_lio3[l_ac3].lio05 < startdate THEN
      LET g_errno = 'alm1085'
      RETURN
   END IF
 
 
   IF p_cmd = 'u' THEN    
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND lio02 <> g_lio3_t.lio02
         AND (a.lio03 = '1' OR a.lio03 = '2'
              OR (a.lio03='0' AND (SELECT count(*) FROM lio_file b WHERE  
                   b.lio01 = g_lin.lin01 AND b.lio02 = a.lio02 )=1))
         AND ((g_lio3[l_ac3].lio04 BETWEEN a.lio04 AND  a.lio05)
              OR (g_lio3[l_ac3].lio05 BETWEEN a.lio04 AND a.lio05)
              OR ( g_lio3[l_ac3].lio04 <= a.lio04 AND g_lio3[l_ac3].lio05>= a.lio05))
         AND ((g_lio3[l_ac3].lio081 BETWEEN a.lio081 AND a.lio082)
              OR ( g_lio3[l_ac3].lio082 BETWEEN a.lio081 AND a.lio082)
              OR ( g_lio3[l_ac3].lio081 <= a.lio081 AND g_lio3[l_ac3].lio082 >= a.lio082))
   ELSE 
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2'
              OR (a.lio03='0' AND (SELECT count(*) FROM lio_file b WHERE
                   b.lio01 = g_lin.lin01 AND b.lio02 = a.lio02 )=1))
         AND ((g_lio3[l_ac3].lio04 BETWEEN a.lio04 AND  a.lio05)
              OR (g_lio3[l_ac3].lio05 BETWEEN a.lio04 AND a.lio05)
              OR ( g_lio3[l_ac3].lio04 <= a.lio04 AND g_lio3[l_ac3].lio05>= a.lio05))
         AND ((g_lio3[l_ac3].lio081 BETWEEN a.lio081 AND a.lio082)
              OR ( g_lio3[l_ac3].lio082 BETWEEN a.lio081 AND a.lio082)
              OR ( g_lio3[l_ac3].lio081 <= a.lio081 AND g_lio3[l_ac3].lio082 >= a.lio082))
   END IF   

   IF l_n > 0 THEN 
      LET g_errno = 'alm-872'
   END IF
END FUNCTION

FUNCTION t360_chk_lio04(startdate,enddate,p_lio02,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02,
          l_n              LIKE type_file.num5,
          startdate        LIKE type_file.dat,
          startdate1       LIKE type_file.dat,
          enddate1         LIKE type_file.dat,
          enddate          LIKE type_file.dat,
          p_cmd            LIKE type_file.chr1

   LET g_errno = ''
   
   IF NOT cl_null(g_lin.lin141) THEN
      LET startdate1 = g_lin.lin141
   ELSE
      LET startdate1 = g_lin.lin14
   END IF 

   IF NOT cl_null(g_lin.lin151) THEN
      LET enddate1 = g_lin.lin151
   ELSE
      LET enddate1 = g_lin.lin15
   END IF 
   
   IF startdate < startdate1 OR enddate > enddate1 
       OR startdate > enddate1 OR enddate < startdate1 THEN   
      LET g_errno = 'alm1085'
      RETURN
   END IF 

   IF p_cmd = 'u' THEN
      SELECT count(*) INTO l_n 
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01 
         AND a.lio02 <> p_lio02
         AND (a.lio03 = '1' OR a.lio03 = '2' OR 
              (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b 
                WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND ((startdate BETWEEN a.lio04 AND a.lio05 )
               OR (enddate BETWEEN a.lio04 AND a.lio05 )
               OR (startdate <= a.lio04 AND enddate >=  a.lio05))
   ELSE
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
              (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND ((startdate BETWEEN a.lio04 AND a.lio05 )
               OR (enddate BETWEEN a.lio04 AND a.lio05 )
               OR (startdate <= a.lio04 AND enddate >=  a.lio05))
   END IF 
 
   IF l_n >0 THEN
      LET g_errno ='alm1086'
      RETURN
   END IF
END FUNCTION
#FUN-CA0081------------add---------str
#比例单身的开始日期、结束日期间检查
FUNCTION t360_chk_lio05(startdate,enddate,p_lio02,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02,
          l_n              LIKE type_file.num5,
          l_n1             LIKE type_file.num5, 
          startdate        LIKE type_file.dat,
          startdate1       LIKE type_file.dat,
          enddate1         LIKE type_file.dat,
          enddate          LIKE type_file.dat,
          p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   IF NOT cl_null(g_lin.lin141) THEN
      LET startdate1 = g_lin.lin141
   ELSE
      LET startdate1 = g_lin.lin14
   END IF

   IF NOT cl_null(g_lin.lin151) THEN
      LET enddate1 = g_lin.lin151
   ELSE
      LET enddate1 = g_lin.lin15
   END IF

   IF startdate < startdate1 OR enddate > enddate1
       OR startdate > enddate1 OR enddate < startdate1 THEN
      LET g_errno = 'alm1085'
      RETURN
   END IF

   IF p_cmd = 'u' THEN
      SELECT count(*) INTO l_n1
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND a.lio02 <> p_lio02
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND (startdate = a.lio04  AND enddate = a.lio05)
      IF l_n1 = 0 THEN
         SELECT count(*) INTO l_n
           FROM lio_file a
          WHERE a.lio01 = g_lin.lin01
            AND a.lio02 <> p_lio02
            AND (a.lio03 = '1' OR a.lio03 = '2' OR
                 (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                   WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
            AND ((startdate BETWEEN a.lio04 AND a.lio05 )
                  OR (enddate BETWEEN a.lio04 AND a.lio05 )
                  OR (startdate <= a.lio04 AND enddate >=  a.lio05))
      END IF
   ELSE
      SELECT count(*) INTO l_n1
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND (startdate = a.lio04  AND enddate = a.lio05)
      IF l_n1 = 0 THEN
         SELECT count(*) INTO l_n
           FROM lio_file a
          WHERE a.lio01 = g_lin.lin01
            AND (a.lio03 = '1' OR a.lio03 = '2' OR
                 (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                   WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
            AND ((startdate BETWEEN a.lio04 AND a.lio05 )
                  OR (enddate BETWEEN a.lio04 AND a.lio05 )
                  OR (startdate <= a.lio04 AND enddate >=  a.lio05))
      END IF 
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1086'
      RETURN
   END IF
END FUNCTION
#检查同一时间段内上下限不重复
FUNCTION t360_chk_lio081(startdate,enddate,p_lio02,p_lio081,p_lio082,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02
   DEFINE p_lio081         LIKE lio_file.lio081
   DEFINE p_lio082         LIKE lio_file.lio082
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat
   DEFINE p_cmd            LIKE type_file.chr1

   LET g_errno = ''

   IF p_cmd = 'u' THEN
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND a.lio02 <> p_lio02
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND ((p_lio081 BETWEEN lio081 AND lio082
              OR p_lio082 BETWEEN lio081 AND lio082)
          OR  (lio081 BETWEEN p_lio081 AND p_lio082
               OR lio082 BETWEEN p_lio081 AND p_lio082 )) 
   ELSE
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND ((p_lio081 BETWEEN lio081 AND lio082
              OR p_lio082 BETWEEN lio081 AND lio082)
          OR  (lio081 BETWEEN p_lio081 AND p_lio082
               OR lio082 BETWEEN p_lio081 AND p_lio082 ))
   END IF   
   IF l_n >0 THEN
      LET g_errno ='alm-872'
      RETURN
   END IF
END FUNCTION
FUNCTION t360_chk_lio04_lio05(startdate,enddate,p_lio02,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   LET g_errno = ''

   IF p_cmd= 'u' THEN
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND a.lio02 <> p_lio02
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND lio081 IS NULL
         AND lio082 IS NULL
   ELSE
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND lio081 IS NULL
         AND lio082 IS NULL
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
FUNCTION t360_chk_lio082(startdate,enddate,p_lio02,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   LET g_errno = ''

   IF p_cmd= 'u' THEN
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND a.lio02 <> p_lio02
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND lio081 IS NOT NULL
         AND lio082 IS NOT NULL
   ELSE
      SELECT count(*) INTO l_n
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '1' OR a.lio03 = '2' OR
             (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                  WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
         AND lio04 = startdate
         AND lio05 = enddate
         AND lio081 IS NOT NULL
         AND lio082 IS NOT NULL
   END IF

   IF l_n >0 THEN
      LET g_errno ='alm1389'
      RETURN
   END IF
END FUNCTION
FUNCTION t360_set_required(startdate,enddate,p_lio02,p_lio081,p_lio082,p_cmd)
   DEFINE p_lio02          LIKE lio_file.lio02
   DEFINE p_lio081         LIKE lio_file.lio081
   DEFINE p_lio082         LIKE lio_file.lio082
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE startdate        LIKE type_file.dat
   DEFINE enddate          LIKE type_file.dat

   IF NOT cl_null(startdate) AND NOT cl_null(enddate) THEN
      IF p_cmd= 'u' THEN
         SELECT count(*) INTO l_n
           FROM lio_file a
          WHERE a.lio01 = g_lin.lin01
            AND a.lio02 <> p_lio02
            AND (a.lio03 = '1' OR a.lio03 = '2' OR
                (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                     WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
            AND lio04 = startdate
            AND lio05 = enddate
            AND lio081 IS NOT NULL
            AND lio082 IS NOT NULL
      ELSE
         SELECT count(*) INTO l_n
           FROM lio_file a
          WHERE a.lio01 = g_lin.lin01
            AND (a.lio03 = '1' OR a.lio03 = '2' OR
                (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
                                     WHERE b.lio01 = g_lin.lin01 and b.lio02 = a.lio02)=1))
            AND lio04 = startdate
            AND lio05 = enddate
            AND lio081 IS NOT NULL
            AND lio082 IS NOT NULL
      END IF
   END IF
   IF NOT cl_null(p_lio081) OR NOT cl_null(p_lio082) OR l_n >0 THEN
      CALL cl_set_comp_required("lio081_3",TRUE)
      CALL cl_set_comp_required("lio082_3",TRUE)
   ELSE
      CALL cl_set_comp_required("lio081_3",FALSE)
      CALL cl_set_comp_required("lio082_3",FALSE)
   END IF
END FUNCTION
#FUN-CA0081------------add---------end

FUNCTION t360_b2()
   DEFINE l_ac2_t          LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_qty           LIKE type_file.num10,
          l_lock_sw       LIKE type_file.chr1,
          p_cmd           LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_cnt           LIKE type_file.num5,
          l_lio03         LIKE lio_file.lio03,
          l_lio04         LIKE lio_file.lio04,
          l_lio05         LIKE lio_file.lio05,
          l_success       LIKE type_file.chr1

   DEFINE l_sql           STRING 
   DEFINE l_lio2       RECORD
             lio02        LIKE lio_file.lio02,
             lio03        LIKE lio_file.lio03,
             lio04        LIKE lio_file.lio04,
             lio05        LIKE lio_file.lio05,
             lio07        LIKE lio_file.lio07,
             lio081       LIKE lio_file.lio081,     #FUN-CA0081 add
             lio082       LIKE lio_file.lio082,     #FUN-CA0081 add
             lio071       LIKE lio_file.lio071,
             lio072       LIKE lio_file.lio072
                       END RECORD
      
   LET g_action_choice = ""
   MESSAGE ""

   IF s_shut(0) THEN 
      RETURN 
   END IF

   IF g_lin.lin01 IS NULL OR g_lin.linplant IS NULL THEN 
      RETURN 
   END IF

   SELECT * INTO g_lin.* 
     FROM lin_file 
    WHERE lin01=g_lin.lin01 

   IF g_lin.linconf='Y' THEN 
      CALL cl_err('','art-046',0) 
      RETURN 
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lio02,lio03,lio04,lio05,lio07,lio081,lio082,lio071,lio072",  #FUN-CA0081 add lio081,lio082
                      "  FROM lio_file ", 
                      " WHERE lio02=? AND lio01='",g_lin.lin01,"'",
                      "   AND lio03 = ?  ",
                      "   FOR UPDATE  "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc21 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc22 CURSOR FROM g_forupd_sql      # LOCK CURSOR   

   LET l_ac2_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lio2 WITHOUT DEFAULTS FROM s_lio2.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN t360_cl USING g_lin.lin01
         IF STATUS THEN
            CALL cl_err("OPEN t360_cl:", STATUS, 1)
            CLOSE t360_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t360_cl INTO g_lin.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lin.lin01,SQLCA.SQLCODE,0)
            CLOSE t360_cl
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b2>=l_ac2 THEN
            LET g_lio2_t.* = g_lio2[l_ac2].*  #BACKUP
            LET p_cmd='u'
                  
            SELECT count(*) INTO l_n
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_lio2[l_ac2].lio02
               AND lio03 = '0'
          
           IF l_n > 0 THEN
               OPEN t360_bc21 USING g_lio2_t.lio02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc21:", STATUS, 1)
                  CLOSE t360_bc21
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t360_bc21 INTO g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03_2,
                                    g_lio2[l_ac2].lio04_2,g_lio2[l_ac2].lio05_2,
                                    g_lio2[l_ac2].lio07_1,g_lio2[l_ac2].lio081_2,g_lio2[l_ac2].lio082_2,  #FUN-CA0081 add lio081_2,lio082_2
                                    g_lio2[l_ac2].lio071_1,g_lio2[l_ac2].lio072_1

               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio2_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF

            SELECT lio03 INTO g_lio2[l_ac2].lio03 FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_liO2[l_ac2].lio02
               AND (lio03 = '1' OR lio03='2')

            IF NOT cl_null(g_lio2[l_ac2].lio03) THEN
               OPEN t360_bc22 USING g_lio2_t.lio02,g_lio2[l_ac2].lio03
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc22:", STATUS, 1)
                  CLOSE t360_bc22
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t360_bc22 INTO g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03,
                                    g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,
                                    g_lio2[l_ac2].lio07,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,  #FUN-CA0081 add lio081_3,lio082_3
                                    g_lio2[l_ac2].lio071,g_lio2[l_ac2].lio072
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio2_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            NEXT FIELD lio02
            CALL t360_set_required(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2_t.lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)  #FUN-CA0081 add
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_lio2[l_ac2].* TO NULL
         LET g_lio2_t.* = g_lio2[l_ac2].*
         CALL t360_set_required(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2_t.lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)  #FUN-CA0081 add
         CALL cl_show_fld_cont()
         LET g_lio2[l_ac2].lio03 = '2'
         NEXT FIELD lio02

      BEFORE DELETE 
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
    
         LET l_lio03 = g_lio2[l_ac2].lio03
         
         CALL t360_lio_b_delete(g_lio2_t.lio02)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)  
            CANCEL DELETE
         END IF

         SELECT count(*) INTO l_n
           FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = g_lio2[l_ac2].lio02

         IF ( l_n= '1' AND g_lio2[l_ac2].lio03_2= '0') THEN
            CANCEL DELETE
         END IF  
 
         DELETE FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = g_lio2_t.lio02
            AND lio03 = g_lio2[l_ac2].lio03

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lio_file",g_lin.lin01,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE 
            IF l_lio03 = '1' THEN
               LET g_lio2[l_ac2].lio03 = ''
               LET g_lio2[l_ac2].lio04 = ''
               LET g_lio2[l_ac2].lio05 = ''
               LET g_lio2[l_ac2].lio07 = ''
               LET g_lio2[l_ac2].lio081_3 = ''   #FUN-CA0081 add
               LET g_lio2[l_ac2].lio082_3 = ''   #FUN-CA0081 add
               LET g_lio2[l_ac2].lio071 = ''
               LET g_lio2[l_ac2].lio072 = ''
               CANCEL DELETE
               COMMIT WORK
            END IF
         END IF

         IF l_lio03 = '2' THEN
            LET g_rec_b2=g_rec_b2-1
         END IF
         DISPLAY g_rec_b2 TO FORMONLY.cn2
         COMMIT WORK

      BEFORE FIELD lio02
         IF g_lio2[l_ac2].lio02 IS NULL OR g_lio2[l_ac2].lio02 = 0 THEN
            SELECT max(lio02)
              INTO g_lio2[l_ac2].lio02
              FROM lio_file
             WHERE lio01 = g_lin.lin01
            IF g_lio2[l_ac2].lio02 IS NULL THEN
               LET g_lio2[l_ac2].lio02 = 1
            ELSE 
               LET g_lio2[l_ac2].lio02 = g_lio2[l_ac2].lio02+1
            END IF
         END IF    
          
      AFTER FIELD lio02
         IF NOT cl_null(g_lio2[l_ac2].lio02) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND 
                  g_lio2[l_ac2].lio02!=g_lio2_t.lio02) THEN
                SELECT count(*) INTO l_n
                  FROM lio_file
                  WHERE lio01 = g_lin.lin01
                    AND lio02 = g_lio2[l_ac2].lio02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lio2[l_ac2].lio02 = g_lio2_t.lio02
                  NEXT FIELD lio02
               END IF 
            END IF
         END IF

      AFTER FIELD lio04
         IF NOT cl_null(g_lio2[l_ac2].lio04) THEN
            CALL t360_chk_lio_date(g_lio2[l_ac2].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF NOT cl_null(g_lio2[l_ac2].lio05) THEN
                  IF g_lio2[l_ac2].lio04 > g_lio2[l_ac2].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio2[l_ac2].lio04 = g_lio2_t.lio04
                     NEXT FIELD lio04
                  END IF
               END IF
              #CALL t360_chk_lio04(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,  #FUN-CA0081 mark
              #                    g_lio2[l_ac2].lio02,p_cmd)                #FUN-CA0081 mark
               IF NOT cl_null(g_lio2[l_ac2].lio05) THEN                      #FUN-CA0081 add
                  CALL t360_chk_lio05(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)  #FUN-CA0081 add
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lio2[l_ac2].lio04 = g_lio2_t.lio04
                     NEXT FIELD lio04
                  END IF   
               END IF   #FUN-CA0081 add
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03)
                       RETURNING g_lio2[l_ac2].lio03
            END IF
         END IF 
         #FUN-CA0081--------add------str
         IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
            IF cl_null(g_lio2[l_ac2].lio081_3) AND cl_null(g_lio2[l_ac2].lio082_3) THEN
               CALL t360_chk_lio04_lio05(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio2[l_ac2].lio04 = g_lio2_t.lio04
                  NEXT FIELD lio04
               END IF
            END IF
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio081_3) AND NOT cl_null(g_lio2[l_ac2].lio082_3) THEN
            IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
               CALL t360_chk_lio081(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio2[l_ac2].lio04 = g_lio2_t.lio04
                  NEXT FIELD lio04
               END IF
            END IF           
         END IF
         #FUN-CA0081--------add------end

      AFTER FIELD lio05
         IF NOT cl_null(g_lio2[l_ac2].lio05) THEN
            CALL t360_chk_lio_date(g_lio2[l_ac2].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF NOT cl_null(g_lio2[l_ac2].lio04) THEN
                  IF g_lio2[l_ac2].lio04 > g_lio2[l_ac2].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio2[l_ac2].lio05 = g_lio2_t.lio05
                     NEXT FIELD lio05
                  END IF
               END IF
              #CALL t360_chk_lio04(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,   #FUN-CA0081 mark
              #                    g_lio2[l_ac2].lio02,p_cmd)                 #FUN-CA0081 mark
               IF NOT cl_null(g_lio2[l_ac2].lio04) THEN                       #FUN-CA0081 add
                  CALL t360_chk_lio05(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)  #FUN-CA0081 add
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lio2[l_ac2].lio05 = g_lio2_t.lio05
                     NEXT FIELD lio05
                  END IF   
               END IF  #FUN-CA0081 add
            END IF 

            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03)
                         RETURNING g_lio2[l_ac2].lio03
            END IF
         END IF 
         #FUN-CA0081--------add------str
         IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
            IF cl_null(g_lio2[l_ac2].lio081_3) AND cl_null(g_lio2[l_ac2].lio082_3) THEN
               CALL t360_chk_lio04_lio05(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio2[l_ac2].lio05 = g_lio2_t.lio05
                  NEXT FIELD lio05
               END IF
            END IF
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio081_3) AND NOT cl_null(g_lio2[l_ac2].lio082_3) THEN
            IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
               CALL t360_chk_lio081(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lio2[l_ac2].lio05 = g_lio2_t.lio05
                  NEXT FIELD lio05
               END IF
            END IF
         END IF
         #FUN-CA0081--------add------end

      AFTER FIELD lio07
         IF NOT cl_null(g_lio2[l_ac2].lio07) THEN
            CALL t360_chk_lio_date(g_lio2[l_ac2].lio02,p_cmd)
                  RETURNING l_success

            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03)
                     RETURNING g_lio2[l_ac2].lio03
            END IF
         END IF   

      AFTER FIELD lio071
         IF NOT cl_null(g_lio2[l_ac2].lio071) THEN
            CALL t360_chk_lio_date(g_lio2[l_ac2].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF g_lio2[l_ac2].lio071 < 0 THEN
                  CALL cl_err('','axm_109',0)
                  LET g_lio2[l_ac2].lio071 = g_lio2_t.lio071
                  NEXT FIELD lio071
               END IF

               IF g_lio2[l_ac2].lio071 >100 THEN
                  CALL cl_err('','alm1087',0)
                  LET g_lio2[l_ac2].lio071 = g_lio2_t.lio071
                  NEXT FIELD lio071 
               END IF 
            END IF 
           IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03)
                     RETURNING g_lio2[l_ac2].lio03    
            END IF
        END IF 

      AFTER FIELD lio072
         IF NOT cl_null(g_lio2[l_ac2].lio072) THEN
            CALL t360_chk_lio_date(g_lio2[l_ac2].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF g_lio2[l_ac2].lio072 < 0 THEN
                  CALL cl_err('','alm1088',0)
                  LET g_lio2[l_ac2].lio072 = g_lio2_t.lio071
                  NEXT FIELD lio071
               END IF
            END IF   
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03)
                     RETURNING g_lio2[l_ac2].lio03
            END IF
         END IF     
  
      #FUN-CA0081--------add------str
      AFTER FIELD lio081_3
         IF NOT cl_null(g_lio2[l_ac2].lio081_3) THEN
            IF g_lio2[l_ac2].lio081_3 < 0 THEN
               CALL cl_err('','alm1089',0)
               LET g_lio2[l_ac2].lio081_3 = g_lio2_t.lio081_3
               NEXT FIELD lio081_3
            END IF
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio081_3) AND NOT cl_null(g_lio2[l_ac2].lio082_3) THEN
            IF g_lio2[l_ac2].lio081_3 > g_lio2[l_ac2].lio082_3  THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lio081_3
            END IF
            IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
               CALL t360_chk_lio081(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lio081_3
               END IF
            END IF
         END IF
         IF (NOT cl_null(g_lio2[l_ac2].lio082_3) AND cl_null(g_lio2[l_ac2].lio081_3))
            OR (cl_null(g_lio2[l_ac2].lio082_3) AND NOT cl_null(g_lio2[l_ac2].lio081_3)) THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
            IF cl_null(g_lio2[l_ac2].lio081_3) AND cl_null(g_lio2[l_ac2].lio082_3) THEN
               CALL t360_chk_lio082(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lio081_3 
               END IF
            END IF
         END IF

      AFTER FIELD lio082_3
         IF NOT cl_null(g_lio2[l_ac2].lio082_3) THEN
            IF g_lio2[l_ac2].lio082_3 < 0 THEN
               CALL cl_err('','alm1090',0)
               LET g_lio2[l_ac2].lio082_3 = g_lio2_t.lio082_3
               NEXT FIELD lio082_3
            END IF
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio081_3) AND NOT cl_null(g_lio2[l_ac2].lio082_3) THEN
            IF g_lio2[l_ac2].lio081_3 > g_lio2[l_ac2].lio082_3  THEN
               CALL cl_err('','alm-161',0)
               NEXT FIELD lio082_3
            END IF
            IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
               CALL t360_chk_lio081(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lio082_3
               END IF
            END IF
         END IF
         IF (NOT cl_null(g_lio2[l_ac2].lio082_3) AND cl_null(g_lio2[l_ac2].lio081_3))
            OR (cl_null(g_lio2[l_ac2].lio082_3) AND NOT cl_null(g_lio2[l_ac2].lio081_3)) THEN
            CALL cl_err('','alm1383',0)
         END IF
         IF NOT cl_null(g_lio2[l_ac2].lio04) AND NOT cl_null(g_lio2[l_ac2].lio05) THEN
            IF cl_null(g_lio2[l_ac2].lio081_3) AND cl_null(g_lio2[l_ac2].lio082_3) THEN
               CALL t360_chk_lio082(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio02,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lio082_3
               END IF
            END IF
         END IF
   
      ON CHANGE lio04,lio05,lio081_3,lio082_3
         CALL t360_set_required(g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2_t.lio02,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,p_cmd)  #FUN-CA0081 a
      #FUN-CA0081--------add------end 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio07,lio081,lio082,lio071,lio072,lioplant,liolegal)    #FUN-CA0081 add lio081,lio082
                      VALUES(g_lin.lin01,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03,
                              g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,
                              g_lio2[l_ac2].lio07,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,g_lio2[l_ac2].lio071,   #FUN-CA0081 add lio081_3,lio082_3
                              g_lio2[l_ac2].lio072,g_lin.linplant,g_lin.linlegal)
                             
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b2=g_rec_b2+1   
            DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lio2[l_ac2].* = g_lio2_t.*
            CLOSE t360_bc21
            CLOSE t360_bc22
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lio2[l_ac2].lio02,-263,1)
            LET g_lio2[l_ac2].* = g_lio2_t.*
         ELSE
            SELECT count(*) INTO l_n
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_lio2[l_ac2].lio02
               AND lio03 = g_lio2[l_ac2].lio03
            IF l_n > 0 THEN
               UPDATE lio_file
                  SET lio04 = g_lio2[l_ac2].lio04,
                      lio05 = g_lio2[l_ac2].lio05,
                      lio07 = g_lio2[l_ac2].lio07,
                      lio081 = g_lio2[l_ac2].lio081_3,    #FUN-CA0081 add
                      lio082 = g_lio2[l_ac2].lio082_3,    #FUN-CA0081 add
                      lio071 = g_lio2[l_ac2].lio071,
                      lio072 = g_lio2[l_ac2].lio072
                WHERE lio01 = g_lin.lin01
                  AND lio02 = g_lio2[l_ac2].lio02
                  AND lio03 = g_lio2[l_ac2].lio03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  LET g_lio2[l_ac2].* = g_lio2_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            ELSE
               INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio07,lio081,lio082,lio071,lio072,lioplant,liolegal)  #FUN-CA0081 add lio081,lio082
                    VALUES (g_lin.lin01,g_lio2[l_ac2].lio02,g_lio2[l_ac2].lio03,
                            g_lio2[l_ac2].lio04,g_lio2[l_ac2].lio05,g_lio2[l_ac2].lio07,g_lio2[l_ac2].lio081_3,g_lio2[l_ac2].lio082_3,   #FUN-CA0081 add lio081,lio082
                            g_lio2[l_ac2].lio071,g_lio2[l_ac2].lio072,g_lin.linplant,g_lin.linlegal)
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  ROLLBACK WORK
               END IF
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac2 = ARR_CURR()
         LET l_ac2_t = l_ac2

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0

            IF p_cmd = 'a' THEN
               CALL g_lio2.deleteElement(l_ac2)
            END IF

            IF p_cmd = 'u' THEN
               LET g_lio2[l_ac2].* = g_lio2_t.*
            END IF
            CLOSE t360_bc21
            CLOSE t360_bc22
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t360_bc21
         CLOSE t360_bc22
         COMMIT WORK
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
                                                                                                            
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")     
                                                                                
   END INPUT
   
   IF p_cmd = 'u' THEN
      LET g_lin.linmodu = g_user
      LET g_lin.lindate = g_today
      UPDATE lin_file SET linmodu = g_lin.linmodu,
                          lindate = g_lin.lindate
         WHERE lin01 = g_lin.lin01 

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lin_file",g_lin.lin01,"",SQLCA.SQLCODE,"","upd lin",1)  
      END IF
      DISPLAY BY NAME g_lin.linmodu,g_lin.lindate
   END IF
   CLOSE t360_bc21
   CLOSE t360_bc22
   COMMIT WORK
END FUNCTION

FUNCTION t360_lio_b_delete(l_lio02)
   DEFINE l_lio02      LIKE lio_file.lio02,
          l_n          LIKE type_file.num5,
          l_lio04      LIKE lio_file.lio04,
          l_lio05      LIKE lio_file.lio05,
          l_lio081     LIKE lio_file.lio081,
          l_lio082     LIKE lio_file.lio082

   LET g_errno = ''

   SELECT lio04,lio05,lio081,lio082 
     INTO l_lio04,l_lio05,l_lio081,l_lio082
     FROM lio_file
    WHERE lio01 = g_lin.lin01
      AND lio02 = l_lio02
      AND lio03 = '0'

   IF g_b_flag = '3' THEN
      SELECT count(*) INTO l_n
        FROM lio_file
       WHERE lio01 = g_lin.lin01
         AND lio02 <> l_lio02
         AND ((lio04 BETWEEN l_lio04 AND l_lio05)
              OR ( lio05 BETWEEN l_lio04 AND l_lio05)
              OR ( lio04<= l_lio04 AND lio05 >= l_lio05))
         AND ((lio081 BETWEEN l_lio081 AND l_lio082)
              OR (lio082 BETWEEN l_lio081 AND l_lio082)
              OR (lio081 <= l_lio081 AND lio082 >= l_lio082))
   ELSE        
      SELECT count(*) INTO l_n
        FROM lio_file
       WHERE lio01 = g_lin.lin01
         AND lio02 <> l_lio02
         AND ((lio04 BETWEEN l_lio04 AND l_lio05)
              OR ( lio05 BETWEEN l_lio04 AND l_lio05)
              OR ( lio04>= l_lio04 AND lio05 <= l_lio05))
   END IF 

   IF l_n > 0 THEN
      LET g_errno = 'alm1116'
   END IF 
   
END FUNCTION

FUNCTION t360_b3()
   DEFINE l_ac3_t          LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_qty           LIKE type_file.num10,
          l_lio03         LIKE lio_file.lio03,
          l_lio04         LIKE lio_file.lio04,
          l_lio05         LIKE lio_file.lio05,
          l_lock_sw       LIKE type_file.chr1,
          p_cmd           LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          l_cnt           LIKE type_file.num5,
          l_success       LIKE type_file.chr1
   DEFINE l_sql           STRING 
   DEFINE l_lio3       RECORD 
             lio02        LIKE lio_file.lio02,
             lio03        LIKE lio_file.lio03,
             lio04        LIKE lio_file.lio04,
             lio05        LIKE lio_file.lio05,
             lio08        LIKE lio_file.lio08,
             lio081       LIKE lio_file.lio081,
             lio082       LIKE lio_file.lio082,
             lio083       LIKE lio_file.lio083
                       END RECORD 

   LET g_action_choice = ""
   MESSAGE ""

   IF s_shut(0) THEN 
      RETURN 
   END IF

   IF g_lin.lin01 IS NULL OR g_lin.linplant IS NULL THEN 
      RETURN 
   END IF

   SELECT * INTO g_lin.* 
     FROM lin_file 
    WHERE lin01=g_lin.lin01 

   IF g_lin.linconf='Y' THEN 
      CALL cl_err('','art-046',0) 
      RETURN 
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT lio02,lio03,lio04,lio05,lio08,lio081,lio082,lio083 ",
                      "   FROM lio_file ",   
                      "  WHERE lio01 = '",g_lin.lin01,"' AND lio02 =? ",
                      "    AND lio03 = ? ",
                      "   FOR UPDATE  "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc31 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360_bc32 CURSOR FROM g_forupd_sql      # LOCK CURSOR 
 
   LET l_ac3_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lio3 WITHOUT DEFAULTS FROM s_lio3.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN t360_cl USING g_lin.lin01
         IF STATUS THEN
            CALL cl_err("OPEN t360_cl:", STATUS, 1)
            CLOSE t360_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t360_cl INTO g_lin.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err(g_lin.lin01,SQLCA.SQLCODE,0)
            CLOSE t360_cl
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b3>=l_ac3 THEN
            LET g_lio3_t.* = g_lio3[l_ac3].*  #BACKUP
            LET p_cmd='u'

            SELECT count(*) INTO l_n
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_lio3[l_ac3].lio02
               AND lio03 = '0'

            IF l_n > 0 THEN
               OPEN t360_bc31 USING g_lio3_t.lio02,'0'
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc31:", STATUS, 1)
                  CLOSE t360_bc31
                  ROLLBACK WORK
                  RETURN
               END IF

               FETCH t360_bc31 INTO g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03_3,
                                    g_lio3[l_ac3].lio04_3,g_lio3[l_ac3].lio05_3,
                                    g_lio3[l_ac3].lio08_1,g_lio3[l_ac3].lio081_1,
                                    g_lio3[l_ac3].lio082_1,g_lio3[l_ac3].lio083_1
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio3_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF

            SELECT lio03 INTO g_lio3[l_ac3].lio03 FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_liO3[l_ac3].lio02
               AND (lio03 = '1' OR lio03='2')

            IF NOT cl_null(g_lio3[l_ac3].lio03) THEN
               OPEN t360_bc32 USING g_lio3_t.lio02,g_lio3[l_ac3].lio03
               IF STATUS THEN
                  CALL cl_err("OPEN t360_bc32:", STATUS, 1)
                  CLOSE t360_bc32
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t360_bc32 INTO g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03,
                                    g_lio3[l_ac3].lio04,g_lio3[l_ac3].lio05,
                                    g_lio3[l_ac3].lio08,g_lio3[l_ac3].lio081,
                                    g_lio3[l_ac3].lio082,g_lio3[l_ac3].lio083
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_lio3_t.lio02,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            NEXT FIELD lio02
         END IF         

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_lio3[l_ac3].* TO NULL
         LET g_lio3_t.* = g_lio3[l_ac3].*
         CALL cl_show_fld_cont()
         LET g_lio3[l_ac3].lio03 = '2'
         NEXT FIELD lio02 

      BEFORE DELETE 
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
 
         LET l_lio03 = g_lio3[l_ac3].lio03
        
         CALL t360_lio_b_delete(g_lio3_t.lio02)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)  
            CANCEL DELETE
         END IF

         SELECT count(*) INTO l_n
           FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = g_lio3[l_ac3].lio02

         IF (l_n = '1' AND g_lio3[l_ac3].lio03_3 ='0') THEN
            CANCEL DELETE
         END IF 

         DELETE FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = g_lio3_t.lio02
            AND lio03 = g_lio3[l_ac3].lio03

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lio_file",g_lin.lin01,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
            IF l_lio03 = '1' THEN
               LET g_lio3[l_ac3].lio03 = ''
               LET g_lio3[l_ac3].lio04 = ''
               LET g_lio3[l_ac3].lio05 = ''
               LET g_lio3[l_ac3].lio08 = ''
               LET g_lio3[l_ac3].lio081 = ''
               LET g_lio3[l_ac3].lio082 = ''
               LET g_lio3[l_ac3].lio083 = ''
               CANCEL DELETE
               COMMIT WORK
            END IF
         END IF
       
         IF l_lio03 = '2' THEN
            LET g_rec_b3=g_rec_b3-1
         END IF
         DISPLAY g_rec_b3 TO FORMONLY.cn2
         COMMIT WORK

      BEFORE FIELD lio02
         IF g_lio3[l_ac3].lio02 IS NULL OR g_lio3[l_ac3].lio02 = 0 THEN
            SELECT max(lio02)
              INTO g_lio3[l_ac3].lio02
              FROM lio_file
             WHERE lio01 = g_lin.lin01
            IF g_lio3[l_ac3].lio02 IS NULL THEN
               LET g_lio3[l_ac3].lio02 = 1
            ELSE
               LET g_lio3[l_ac3].lio02 = g_lio3[l_ac3].lio02+1
            END IF
         END IF    
          
      AFTER FIELD lio02
         IF NOT cl_null(g_lio3[l_ac3].lio02) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND 
                  g_lio3[l_ac3].lio02!=g_lio3_t.lio02) THEN
                SELECT count(*) INTO l_n
                  FROM lio_file
                  WHERE lio01 = g_lin.lin01
                    AND lio02 = g_lio3[l_ac3].lio02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lio3[l_ac3].lio02 = g_lio3_t.lio02
                  NEXT FIELD lio02
               END IF 
            END IF
         END IF

      AFTER FIELD lio04
         IF NOT cl_null(g_lio3[l_ac3].lio04) THEN
            CALL t360_chk_lio_date(g_lio3[l_ac3].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF NOT cl_null(g_lio3[l_ac3].lio05) THEN
                  IF g_lio3[l_ac3].lio04 > g_lio3[l_ac3].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio3[l_ac3].lio04 = g_lio3_t.lio04
                     NEXT FIELD lio04
                  END IF
                  IF NOT cl_null(g_lio3[l_ac3].lio081) AND NOT cl_null(g_lio3[l_ac3].lio082) THEN
                     CALL t360_chk_b3_field(p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_lio3[l_ac3].lio04 = g_lio3_t.lio04
                        NEXT FIELD lio04
                     END IF   
                  END IF
               END IF
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                       RETURNING g_lio3[l_ac3].lio03
            END IF
         END IF 

      AFTER FIELD lio05
         IF NOT cl_null(g_lio3[l_ac3].lio05) THEN
            CALL t360_chk_lio_date(g_lio3[l_ac3].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF NOT cl_null(g_lio3[l_ac3].lio04) THEN
                  IF g_lio3[l_ac3].lio04 > g_lio3[l_ac3].lio05 THEN
                     CALL cl_err('','alm-402',0)
                     LET g_lio3[l_ac3].lio05 = g_lio3_t.lio05
                     NEXT FIELD lio05
                  END IF
                  IF NOT cl_null(g_lio3[l_ac3].lio081) AND NOT cl_null(g_lio3[l_ac3].lio082) THEN
                     CALL t360_chk_b3_field(p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_lio2[l_ac3].lio05 = g_lio3_t.lio05
                        NEXT FIELD lio05
                     END IF   
                  END IF 
               END IF
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                         RETURNING g_lio3[l_ac3].lio03
            END IF
         END IF    

      AFTER FIELD lio08
         IF NOT cl_null( g_lio3[l_ac3].lio08) THEN
            CALL t360_chk_lio_date(g_lio3[l_ac3].lio02,p_cmd)
                  RETURNING l_success
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                                RETURNING g_lio3[l_ac3].lio03
               IF p_cmd = 'u' THEN
                  CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                        RETURNING g_lio3[l_ac3].lio03
               END IF
            END IF
         END IF

      AFTER FIELD lio081,lio082
         IF NOT cl_null(g_lio3[l_ac3].lio081) THEN
            IF g_lio3[l_ac3].lio081 < 0 THEN
                 CALL cl_err('','alm1089',0)
                 LET g_lio3[l_ac3].lio081 = g_lio3_t.lio081
                 NEXT FIELD lio081
              END IF
         END IF  
  
         IF NOT cl_null(g_lio3[l_ac3].lio082) THEN
            IF g_lio3[l_ac3].lio082 < 0 THEN
               CALL cl_err('','alm1090',0)
               LET g_lio3[l_ac3].lio082 = g_lio3_t.lio082
               NEXT FIELD lio082
            END IF   
         END IF 

         CALL t360_chk_lio_date(g_lio3[l_ac3].lio02,p_cmd)
                  RETURNING l_success
         IF l_success <> 'S' THEN
            IF NOT cl_null(g_lio3[l_ac3].lio081) AND NOT cl_null(g_lio3[l_ac3].lio082) THEN
               IF g_lio3[l_ac3].lio081 > g_lio3[l_ac3].lio082 THEN
                      CALL cl_err('','alm161',0)
                     LET g_lio3[l_ac3].lio081 = g_lio3_t.lio081
                     NEXT FIELD lio081
                 END IF  
               
               IF NOT cl_null(g_lio3[l_ac3].lio04) AND NOT cl_null( g_lio3[l_ac3].lio05) THEN
                  CALL t360_chk_b3_field(p_cmd)
                  IF NOT cl_null( g_errno ) THEN
                     CALL cl_err('',g_errno,0) 
                     IF INFIELD (lio081) THEN
                        LET g_lio3[l_ac3].lio081 = g_lio3_t.lio081
                     ELSE
                        LET g_lio3[l_ac3].lio082 = g_lio3_t.lio082
                     END IF
                     NEXT FIELD CURRENT
                  END IF 
               END IF
            END IF 
         END IF  
         IF p_cmd = 'u' THEN
            CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                        RETURNING g_lio3[l_ac3].lio03
         END IF

      AFTER FIELD lio083 
         IF NOT cl_null(g_lio3[l_ac3].lio083) THEN
            CALL t360_chk_lio_date(g_lio3[l_ac3].lio02,p_cmd)
                  RETURNING l_success
            IF l_success <> 'S' THEN
               IF g_lio3[l_ac3].lio083 < 0 THEN
                  CALL cl_err('','alm1080',0)
                  LET g_lio3[l_ac3].lio083 = g_lio3_t.lio083
                  NEXT FIELD lio083
               END IF
            END IF 
            IF p_cmd = 'u' THEN
               CALL t360_chk_ins(g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03)
                          RETURNING g_lio3[l_ac3].lio03
            END IF
         END IF    
           
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio08,lio081,lio082,
                                 lio083,lioplant,liolegal)
                      VALUES(g_lin.lin01,g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03,
                              g_lio3[l_ac3].lio04,g_lio3[l_ac3].lio05,
                              g_lio3[l_ac3].lio08,g_lio3[l_ac3].lio081,
                              g_lio3[l_ac3].lio082,g_lio3[l_ac3].lio083,
                              g_lin.linplant,g_lin.linlegal)
                             
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b3=g_rec_b3+1   
            DISPLAY g_rec_b3 TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lio3[l_ac3].* = g_lio3_t.*
            CLOSE t360_bc31
            CLOSE t360_bc32
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lio3[l_ac3].lio02,-263,1)
            LET g_lio3[l_ac3].* = g_lio3_t.*
         ELSE
            SELECT count(*) INTO l_n
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = g_lio3[l_ac3].lio02
               AND lio03 = g_lio3[l_ac3].lio03
            IF l_n > 0 THEN
               UPDATE lio_file
                  SET lio04 = g_lio3[l_ac3].lio04,
                      lio05 = g_lio3[l_ac3].lio05,
                      lio08 = g_lio3[l_ac3].lio08,
                      lio081 = g_lio3[l_ac3].lio081,
                      lio082 = g_lio3[l_ac3].lio082,
                      lio083 = g_lio3[l_ac3].lio083
                WHERE lio01 = g_lin.lin01
                  AND lio02 = g_lio3[l_ac3].lio02
                  AND lio03 = g_lio3[l_ac3].lio03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  LET g_lio3[l_ac3].* = g_lio3_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            ELSE
               INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio08,lio081,
                                    lio082,lio083,lioplant,liolegal)
                    VALUES (g_lin.lin01,g_lio3[l_ac3].lio02,g_lio3[l_ac3].lio03,
                            g_lio3[l_ac3].lio04,g_lio3[l_ac3].lio05,g_lio3[l_ac3].lio08,
                            g_lio3[l_ac3].lio081,g_lio3[l_ac3].lio082,g_lio3[l_ac3].lio083 ,
                            g_lin.linplant,g_lin.linlegal)
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
                  ROLLBACK WORK
               END IF
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac3 = ARR_CURR()
         LET l_ac3_t = l_ac3

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0

            IF p_cmd = 'a' THEN
               CALL g_lio3.deleteElement(l_ac3)
            END IF

            IF p_cmd = 'u' THEN
               LET g_lio3[l_ac3].* = g_lio3_t.*
            END IF
            CLOSE t360_bc31
            CLOSE t360_bc32
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t360_bc31
         CLOSE t360_bc31
         COMMIT WORK
        
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
                                                                                                            
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")     
                                                                                
   END INPUT
   
   IF p_cmd = 'u' THEN
      LET g_lin.linmodu = g_user
      LET g_lin.lindate = g_today

      UPDATE lin_file SET linmodu = g_lin.linmodu,
                          lindate = g_lin.lindate
         WHERE lin01 = g_lin.lin01 

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lin_file",g_lin.lin01,"",SQLCA.SQLCODE,"","upd lin",1)  
      END IF

      DISPLAY BY NAME g_lin.linmodu,g_lin.lindate
   END IF
   CLOSE t360_bc31
   CLOSE t360_bc32
   COMMIT WORK
END FUNCTION

FUNCTION t360_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lin.lin01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lin.linconf = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   BEGIN WORK

   OPEN t360_cl USING g_lin.lin01
   IF STATUS THEN
      CALL cl_err("OPEN t360_cl:", STATUS, 1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t360_cl INTO g_lin.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t360_show()

   IF cl_exp(0,0,g_lin.linacti) THEN
      IF g_lin.linacti='Y' THEN
         LET g_lin.linacti='N'
      ELSE
         LET g_lin.linacti='Y'
      END IF

      UPDATE lin_file SET linacti=g_lin.linacti,
                          linmodu=g_user,
                          lindate=g_today
       WHERE lin01=g_lin.lin01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lin_file",g_lin.lin01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE t360_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lin.lin01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   LET g_lin.linmodu = g_user
   LET g_lin.lindate=g_today
   DISPLAY BY NAME g_lin.linacti,g_lin.linmodu,g_lin.lindate
    CALL cl_set_field_pic("","","","","",g_lin.linacti)

END FUNCTION
 
FUNCTION t360_b1_fill(p_wc)
   DEFINE l_sql      STRING
   DEFINE p_wc       STRING

   
   LET l_sql = " SELECT b.lio02,b.lio03,b.lio04,b.lio05,b.lio06,b.lio061,",
               "        a.lio03,a.lio04,a.lio05,a.lio06,a.lio061",
               "   FROM lio_file b LEFT OUTER JOIN lio_file a ",
               "         ON (b.lio01=a.lio01 AND b.lio02=a.lio02 AND b.lio03 <> a.lio03) ",
               "  WHERE b.lio01 = '",g_lin.lin01,"'  AND b.lioplant= '",g_lin.linplant,"'", 
               "    AND b.lio03 = '0'"
 
   IF NOT cl_null( p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc
   END IF 
         
   DECLARE t360_cr1 CURSOR FROM l_sql 

   CALL g_lio.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1

   FOREACH t360_cr1 INTO g_lio[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   LET l_sql = " SELECT b.lio02,'','','','','',b.lio03,b.lio04,b.lio05,b.lio06,b.lio061",
               "   FROM lio_file b",
               "  WHERE b.lio01 = '",g_lin.lin01,"' AND b.lioplant= '",g_lin.linplant,"'",
               "    AND b.lio03 ='2' "

   IF NOT cl_null( p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc
   END IF

   DECLARE t360_cr12 CURSOR FROM l_sql

   FOREACH t360_cr12 INTO g_lio[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   

   CALL g_lio.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   LET g_cnt = 1

   DISPLAY g_rec_b1 TO FORMONLY.cn2
   CLOSE t360_cr1
   CALL t360_bp1_refresh()
END FUNCTION
 
FUNCTION t360_bp1_refresh()
   DISPLAY ARRAY g_lio TO s_lio.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t360_b2_fill(p_wc)
   DEFINE l_sql,p_wc        STRING
 
   LET l_sql = " SELECT b.lio02,b.lio03,b.lio04,b.lio05,b.lio07,b.lio081,b.lio082,b.lio071,b.lio072,",   #FUN-CA0081 add b.lio081,b.lio082
               "        a.lio03,a.lio04,a.lio05,a.lio07,a.lio081,a.lio082,a.lio071,a.lio072",            #FUN-CA0081 add a.lio081,a.lio082
               "   FROM lio_file b LEFT OUTER JOIN lio_file a ",
               "     ON (b.lio01=a.lio01 AND b.lio02=a.lio02 AND b.lio03 <> a.lio03) ",
               "  WHERE b.lio01 = '",g_lin.lin01,"'  AND b.lioplant= '",g_lin.linplant,"'",
               "    AND b.lio03 = '0'"

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ", p_wc
   END IF 

   DECLARE t360_cr2 CURSOR FROM l_sql
 
   CALL g_lio2.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   FOREACH t360_cr2 INTO g_lio2[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   LET l_sql = " SELECT b.lio02,'','','','','','','','',",                                    #FUN-CA0081 add 2''
               "        b.lio03,b.lio04,b.lio05,b.lio07,b.lio081,b.lio082,b.lio071,b.lio072", #FUN-CA0081 add b.lio081,b.lio082
               "   FROM lio_file b ",
               "  WHERE b.lio01 = '",g_lin.lin01,"'  AND b.lioplant= '",g_lin.linplant,"'",
               "    AND b.lio03 ='2' "

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ", p_wc
   END IF

   DECLARE t360_cr22 CURSOR FROM l_sql

   FOREACH t360_cr22 INTO g_lio2[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lio2.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   LET g_cnt = 1
   CLOSE t360_cr2
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   CALL t360_bp2_refresh()
END FUNCTION
 
FUNCTION t360_bp2_refresh()
   DISPLAY ARRAY g_lio2 TO s_lio2.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t360_b3_fill(p_wc)
   DEFINE l_sql        STRING
   DEFINE p_wc         STRING 
 
   LET l_sql = " SELECT b.lio02,b.lio03,b.lio04,b.lio05,b.lio08,b.lio081,b.lio082,b.lio083,",
               "        a.lio03,a.lio04,a.lio05,a.lio08,a.lio081,a.lio082,a.lio083",
               "   FROM lio_file b LEFT OUTER JOIN lio_file a ",
               "     ON (b.lio01=a.lio01 AND b.lio02=a.lio02 AND b.lio03 <> a.lio03) ",
               "  WHERE b.lio01 = '",g_lin.lin01,"'  AND b.lioplant= '",g_lin.linplant,"'",
               "    AND b.lio03 = '0'"

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND",p_wc
   END IF               

   PREPARE t360_b3_prepare FROM l_sql
   DECLARE t360_cr3 CURSOR FOR t360_b3_prepare
 
   CALL g_lio3.clear()
   LET g_rec_b3 = 0
   LET g_cnt = 1

   FOREACH t360_cr3 INTO g_lio3[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

  LET l_sql = " SELECT b.lio02,'','','','','','','',",
               "       b.lio03,b.lio04,b.lio05,b.lio08,b.lio081,b.lio082,b.lio083 ",
              "   FROM lio_file b ",
               "  WHERE b.lio01 = '",g_lin.lin01,"'  AND b.lioplant= '",g_lin.linplant,"'",
               "    AND b.lio03 ='2' "

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc
   END IF 

   DECLARE t360_cr32 CURSOR FROM l_sql

   FOREACH t360_cr32 INTO g_lio3[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lio3.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt - 1
   LET g_cnt = 1
   CLOSE t360_cr3
   DISPLAY g_rec_b3 TO FORMONLY.cn2
   CALL t360_bp3_refresh()
END FUNCTION

FUNCTION t360_bp3_refresh()
   DISPLAY ARRAY g_lio3 TO s_lio3.* ATTRIBUTE(COUNT = g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t360_lin03(p_cmd)
   DEFINE  p_cmd          LIKE type_file.chr1,
           l_gen02        LIKE gen_file.gen02,
           l_genacti      LIKE gen_file.genacti

   LET g_errno = ''

   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lin.lin03

   CASE 
      WHEN SQLCA.sqlcode=100
         LET g_errno='aap-038'
         LET l_gen02 = ''
      WHEN l_genacti <> 'Y'
         LET g_errno = 'art-733'   
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION

FUNCTION t360_linplant(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_rtz13    LIKE rtz_file.rtz13,
          l_rtz28    LIKE rtz_file.rtz28

   LET g_errno = ''

   SELECT rtz13 ,rtz28 INTO l_rtz13,l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_lin.linplant

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-077'
         LET l_rtz13 = ''
      WHEN l_rtz28 <> 'Y'
         LET g_errno = 'alm-606'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION

FUNCTION t321_liglegal(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_azt02    LIKE azt_file.azt02

   LET g_errno = ''

   SELECT azt02 INTO l_azt02
     FROM azt_file
    WHERE azt01 = g_lin.linlegal

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='aoo-416'
         LET l_azt02 = ''
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION
    
FUNCTION t360_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM    
   INITIALIZE g_lin.*    LIKE lin_file.*       
   INITIALIZE g_lin_t.*  LIKE lin_file.*
   INITIALIZE g_lin_o.*  LIKE lin_file.*     

   CALL g_lio.clear()
   CALL g_lio2.clear()
   CALL g_lio3.clear()
   LET g_wc1 = NULL
   LET g_wc2 = NULL
   LET g_wc3 = NULL
   
   LET g_lin01_t = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')     

    WHILE TRUE
       IF cl_null(g_argv1) THEN
         CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)
      ELSE
         LET g_lin.lin00 = g_argv1
         CASE g_lin.lin00
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

       LET g_lin.lin02 = g_today
       LET g_lin.lin03 = g_user 
       LET g_lin.linplant = g_plant 
       LET g_lin.linlegal = g_legal  
       LET g_lin.linmksg   = 'N'
       LET g_lin.lin17   = '0'
       LET g_lin.linconf = 'N'
       LET g_lin.linuser = g_user
       LET g_lin.lingrup = g_grup
       LET g_lin.lindate = g_today
       LET g_lin.linacti = 'Y'
       LET g_lin.lincrat = g_today        
       LET g_lin.linoriu = g_today
       LET g_lin.linorig = g_grup
       LET g_lin.lin161  = ' '
       CALL t360_i('a') 
      
       IF INT_FLAG THEN  
          LET INT_FLAG = 0
          INITIALIZE g_lin.* TO NULL
          CALL g_lio.clear()
          CALL g_lio2.clear()
          CALL g_lio3.clear()
          LET g_lin01_t = NULL  
          CALL cl_set_comp_visible('Page3,Page4,Page5',TRUE)         
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       
       IF cl_null(g_lin.lin01) OR cl_null(g_lin.linplant) THEN    
          CONTINUE WHILE
       END IF     

       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lin.lin01,g_today,"P1",
                                   "lin_file","lin01","","","")
          RETURNING li_result,g_lin.lin01
       IF (NOT li_result) THEN
           CONTINUE WHILE
       END IF
       DISPLAY BY NAME g_lin.lin01
        
       INSERT INTO lin_file VALUES(g_lin.*)                   
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_lin.lin01,SQLCA.SQLCODE,0)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          CALL t360_insert_lio()
          COMMIT WORK
       END IF
       LET g_rec_b1 = 0
       LET g_rec_b2 = 0
       LET g_rec_b3 = 0

       IF g_lin.lin00 = '1' THEN
          CALL t360_b1_fill(" 1=1")
          CALL cl_set_comp_visible('Page4,Page5',FALSE)
          CALL cl_set_comp_visible('Page3',TRUE)
          LET g_b_flag = '1'      #TQC-C30210 add
          CALL t360_b1() 
       END IF

       IF g_lin.lin00 = '2' THEN
          CALL t360_b2_fill(" 1=1")
          CALL cl_set_comp_visible('Page3,Page5',FALSE)
          CALL cl_set_comp_visible('Page4',TRUE)
          LET g_b_flag = '2'      #TQC-C30210 add
          CALL t360_b2()
       END IF

       IF g_lin.lin00 = '3' THEN
          CALL t360_b3_fill(" 1=1")
          CALL cl_set_comp_visible('Page3,Page4',FALSE)
          CALL cl_set_comp_visible('Page5',TRUE)
          LET g_b_flag = '3'      #TQC-C30210 add
          CALL t360_b3()
       END IF

       CALL t360_delall()
       EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION

FUNCTION t360_insert_lio()
   DEFINE l_lio    DYNAMIC ARRAY OF RECORD
             lio02      LIKE lio_file.lio02,
             lio04      LIKE lio_file.lio04,
             lio05      LIKE lio_file.lio05,
             lio06      LIKE lio_file.lio06,
             lio061     LIKE lio_file.lio061,
             lio07      LIKE lio_file.lio07,
             lio071     LIKE lio_file.lio071,
             lio072     LIKE lio_file.lio072,
             lio08      LIKE lio_file.lio08,
             lio081     LIKE lio_file.lio081,
             lio082     LIKE lio_file.lio082,
             lio083     LIKE lio_file.lio083
                END RECORD
   DEFINE count1        LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_n     LIKE type_file.num5

   LET l_sql = "SELECT lim02,lim03,lim04,lim05,lim051,lim06,",
               "       lim061,lim062,lim07,lim071,lim072,lim073   ",
               "  FROM lim_file                                    ",
               " WHERE lim01 = '",g_lin.lin04,"'"
   PREPARE t360_ins_pre FROM l_sql
   DECLARE t360_ins_cs CURSOR FOR t360_ins_pre

   LET l_n = 1

   FOREACH t360_ins_cs INTO l_lio[l_n].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_n = l_n + 1

   END FOREACH
   CALL l_lio.deleteElement(l_n)
   FOR count1 =1 TO l_n-1
      INSERT INTO lio_file(lio01,lio02,lio03,lio04,lio05,lio06,lio061,lio07,
                           lio071,lio072,lio08,lio081,lio082,lio083,lioplant,liolegal)
           VALUES(g_lin.lin01,l_lio[count1].lio02,'0',l_lio[count1].lio04,l_lio[count1].lio05,
                  l_lio[count1].lio06,l_lio[count1].lio061,l_lio[count1].lio07,l_lio[count1].lio071,
                  l_lio[count1].lio072,l_lio[count1].lio08,l_lio[count1].lio081,l_lio[count1].lio082,
                  l_lio[count1].lio083,g_lin.linplant,g_lin.linlegal)
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","lio_file",g_lin.lin01,"",SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
      ELSE
         MESSAGE 'INSERT O.K'
      END IF
   END FOR
   
END FUNCTION

FUNCTION t360_delall()
   DEFINE l_cnt1      LIKE type_file.num5
 
   LET l_cnt1 = 0

   SELECT COUNT(*) INTO l_cnt1 FROM lio_file                                                                                   
       WHERE lio01=g_lin.lin01 
        
   IF l_cnt1=0  THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED

      DELETE FROM lin_file WHERE lin01 = g_lin.lin01

      INITIALIZE g_lin.* TO NULL
      CALL g_lio.clear()
      CALL g_lio2.clear()
      CALL g_lio3.clear()
      CLEAR FORM
   END IF
END FUNCTION

FUNCTION t360_i(p_cmd)
   DEFINE  l_cnt      LIKE type_file.num5 
   DEFINE  l_count    LIKE type_file.num5 
   DEFINE  p_cmd      LIKE type_file.chr1,
           l_n        LIKE type_file.num5,
           li_result  LIKE type_file.num5

   DISPLAY BY NAME  g_lin.lin00,g_lin.lin01,g_lin.lin02,g_lin.lin03,g_lin.lin04,
                    g_lin.lin05,g_lin.lin06,g_lin.linplant,g_lin.linlegal,
                    g_lin.lin07,g_lin.lin08,g_lin.lin09,g_lin.lin10,g_lin.lin11,
                    g_lin.lin12,g_lin.lin13,g_lin.lin14,g_lin.lin141,g_lin.lin15,
                    g_lin.lin151,g_lin.lin16,g_lin.lin161,g_lin.linmksg,
                    g_lin.lin17,g_lin.linconf,g_lin.linconu,g_lin.lincond,
                    g_lin.lin18,g_lin.linuser,g_lin.lingrup,g_lin.linoriu,
                    g_lin.linmodu,g_lin.lindate,g_lin.linorig,g_lin.linacti,
                    g_lin.lincrat

   CALL t360_desc()
              
   INPUT BY NAME g_lin.lin00,g_lin.lin01,g_lin.lin02,g_lin.lin03,g_lin.lin04,
                  g_lin.lin05,g_lin.lin06,g_lin.linplant,g_lin.linlegal,
                  g_lin.lin07,g_lin.lin08,g_lin.lin09,g_lin.lin10,g_lin.lin11,
                  g_lin.lin12,g_lin.lin13,g_lin.lin14,g_lin.lin141,g_lin.lin15,
                  g_lin.lin151,g_lin.lin16,g_lin.lin161,g_lin.linmksg,
                  g_lin.lin17,g_lin.linconf,g_lin.linconu,g_lin.lincond,
                  g_lin.lin18,g_lin.linuser,g_lin.lingrup,g_lin.linoriu,
                  g_lin.linmodu,g_lin.lindate,g_lin.linorig,g_lin.linacti,
                  g_lin.lincrat  
        WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_input_done = FALSE  
         CALL t360_set_entry(p_cmd)        
         CALL t360_set_no_entry(p_cmd)      
         LET g_input_done = TRUE
         CALL cl_set_docno_format("lin01")
                   
      AFTER FIELD lin01 
         IF NOT cl_null(g_lin.lin01) THEN
            IF (p_cmd = 'a' ) OR 
               (p_cmd = 'u' AND g_lin.lin01 != g_lin_t.lin01) THEN
               CALL s_check_no("alm",g_lin.lin01,g_lin01_t,"P1","lin_file",
                         "lin01","") RETURNING li_result,g_lin.lin01
               IF ( NOT li_result) THEN                  
                  LET g_lin.lin01 = g_lin_t.lin01                                                        
                  NEXT FIELD lin01                                        
               END IF
               SELECT oayapr INTO g_lin.linmksg 
                 FROM oay_file 
                WHERE oayslip = g_lin.lin01
            END IF                
         END IF           

      ON CHANGE lin00
         CASE g_lin.lin00
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
           
      AFTER FIELD lin03
         IF NOT cl_null( g_lin.lin03) THEN
            CALL t360_lin03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lin.lin03 = g_lin_t.lin03
               DISPLAY BY NAME g_lin.lin03
               NEXT FIELD lin03
            END IF
         END IF

      AFTER FIELD lin04
         IF NOT cl_null( g_lin.lin04) THEN
            IF p_cmd = 'u' THEN
               IF g_lin.lin04 <> g_lin_t.lin04 THEN
                  CALL cl_err('','alm1098',0)
                  LET g_lin.lin04 = g_lin_t.lin04
                  DISPLAY BY NAME g_lin.lin04
               END IF
            ELSE 
               CALL t360_lin04_1()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err ('',g_errno,0)
                  LET g_lin.lin04 = g_lin_t.lin04
                  DISPLAY BY NAME g_lin.lin04
                  NEXT FIELD lin04
               END IF  
            END IF 
            CALL t360_lin04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err ('',g_errno,0)
               LET g_lin.lin04 = g_lin_t.lin04
               DISPLAY BY NAME g_lin.lin04
               NEXT FIELD lin04
            END IF

            CALL t360_desc()      

            IF g_lin.lin14 > g_today THEN
               CALL cl_set_comp_entry("lin141",TRUE)
            ELSE
               CALL cl_set_comp_entry("lin141",FALSE)
            END IF

         END IF

      AFTER FIELD lin05
         IF NOT cl_null(g_lin.lin05) THEN
            CALL t360_lin05_2()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lin.lin05 = g_lin_t.lin05
               DISPLAY BY NAME g_lin.lin04
               NEXT FIELD lin05
            END IF
         END IF    

      BEFORE FIELD lin141
         IF g_lin.lin14 > g_today THEN
            CALL cl_set_comp_entry("lin141",TRUE)
         ELSE
            CALL cl_set_comp_entry("lin141",FALSE)
         END IF   

      AFTER FIELD lin141
         IF NOT cl_null(g_lin.lin141) THEN
            IF NOT cl_null(g_lin.lin151) THEN
               IF g_lin.lin141 < g_lin.lin151 THEN
                  CALL t360_lin141(g_lin.lin141,g_lin.lin151,p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lin.lin141 = g_lin_t.lin141
                     DISPLAY BY NAME g_lin.lin141
                     NEXT FIELD lin141
                  END IF
               ELSE
                  CALL cl_err('','alm1038',0)
                  LET g_lin.lin141 = g_lin_t.lin141
                  DISPLAY BY NAME g_lin.lin141
                  NEXT FIELD lin141
               END IF
            ELSE
               IF g_lin.lin141 >= g_lin.lin15 THEN
                  CALL cl_err('','alm1038',0)
                  LET g_lin.lin141 = g_lin_t.lin141
                  DISPLAY BY NAME g_lin.lin141
                  NEXT FIELD lin141
               ELSE
                  CALL t360_lin141(g_lin.lin141,g_lin.lin15,p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lin.lin141 = g_lin_t.lin141
                     DISPLAY BY NAME g_lin.lin141
                     NEXT FIELD lin141
                  END IF
               END IF 
            END IF

         END IF

      AFTER FIELD lin151
         IF NOT cl_null(g_lin.lin151) THEN
            IF g_lin.lin151 <= g_today THEN
               CALL cl_err('','alm1099',0)
               LET g_lin.lin151 = g_lin_t.lin151
               DISPLAY BY NAME g_lin.lin151
               NEXT FIELD lin151
            END IF 
            IF NOT cl_null(g_lin.lin141) THEN
               IF g_lin.lin141 < g_lin.lin151 THEN
                  CALL t360_lin141(g_lin.lin141,g_lin.lin151,p_cmd) 
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lin.lin151 = g_lin_t.lin151
                     DISPLAY BY NAME g_lin.lin151
                     NEXT FIELD lin151
                  END IF
               ELSE
                  CALL cl_err('','alm1038',0)
                  LET g_lin.lin151 = g_lin_t.lin151
                  DISPLAY BY NAME g_lin.lin151
                  NEXT FIELD lin151
               END IF
            ELSE 
               IF g_lin.lin14 >= g_lin.lin151 THEN
                  CALL cl_err('','alm1038',0)
                  LET g_lin.lin151 = g_lin_t.lin151
                  DISPLAY BY NAME g_lin.lin151
                  NEXT FIELD lin151
               ELSE 
                  CALL t360_lin141(g_lin.lin14,g_lin.lin151,p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lin.lin151 = g_lin_t.lin151
                     DISPLAY BY NAME g_lin.lin151
                     NEXT FIELD lin151
                  END IF 
               END IF
            END IF
         END IF
     
      ON ACTION controlp
         CASE       
            WHEN INFIELD(lin01)
               LET g_kindslip = s_get_doc_no(g_lin.lin01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'P1','ALM') RETURNING g_kindslip
               LET g_lin.lin01 = g_kindslip
               DISPLAY BY NAME g_lin.lin01
               NEXT FIELD lin01
            
            WHEN INFIELD(lin03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen02"
               LET g_qryparam.default1 = g_lin.lin03
               CALL cl_create_qry() RETURNING g_lin.lin03
               DISPLAY BY NAME g_lin.lin03
               CALL t360_lin03('d')
               NEXT FIELD lin03
   
            WHEN INFIELD(lin04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lil01"  
               LET g_qryparam.default1 = g_lin.lin04
               CALL cl_create_qry() RETURNING g_lin.lin04
               DISPLAY BY NAME g_lin.lin04
               CALL t360_lin04('d')
               NEXT FIELD lin04
            OTHERWISE
              EXIT CASE
         END CASE
 
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

FUNCTION t360_lin141(startdate,enddate,p_cmd)
   DEFINE l_n          LIKE type_file.chr1,
          l_lio04      LIKE lio_file.lio04,
          l_lio05      LIKE lio_file.lio05,
          startdate    LIKE lin_file.lin14,
          enddate      LIKE lin_file.lin15
   DEFINE p_date1      LIKE lin_file.lin14,
          p_date2      LIKE lin_file.lin15,
          p_cmd        LIKE type_file.chr1

   LET g_errno = ''
  
   IF p_cmd = 'u' THEN
      SELECT MIN(lio04),MAX(lio05) INTO l_lio04,l_lio05
        FROM lio_file a
       WHERE a.lio01 = g_lin.lin01
         AND (a.lio03 = '2' OR a.lio03 = '1' OR 
              (a.lio03 = '0' AND (SELECT count(*) FROM lio_file b
               WHERE b.lio01 = g_lin.lin01 AND b.lio02 = a.lio02)=1))
   END IF

   IF p_cmd = 'a' THEN
      
      SELECT MIN(lim03),MAX(lim04) INTO l_lio04,l_lio05
        FROM lim_file                       
       WHERE lim01 = g_lin.lin04
   END IF  

   IF (startdate>l_lio04) OR (enddate <l_lio05) THEN
      LET g_errno = 'alm1100'
      RETURN
   END IF

   CALL t360_check_date(startdate,enddate)

END FUNCTION

FUNCTION t360_r()
 
    IF cl_null(g_lin.lin01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_lin.linconf = 'Y' THEN 
       CALL cl_err(g_lin.lin01,'alm-028',1)
       RETURN
     END IF
    
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t360_cl USING g_lin.lin01
    IF STATUS THEN
       CALL cl_err("OPEN t360_cl:",STATUS,0)
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t360_cl INTO g_lin.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
       CLOSE t360_cl
       ROLLBACK WORK
       RETURN
    END IF

    CALL t360_show()
    
    IF cl_delh(0,0) THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "lin01"         
        LET g_doc.value1 = g_lin.lin01 
        CALL cl_del_doc()                                  
       
       DELETE FROM lin_file  WHERE lin01  = g_lin.lin01
       IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lin_file",g_lin.lin01,"",SQLCA.SQLCODE,
                       "","(t360_r:delete lin)",1)
         LET g_success='N'
      END IF

      DELETE FROM lio_file 
         WHERE lio01 = g_lin.lin01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lio_file",g_lin.lin01,"",
                      SQLCA.SQLCODE,"","(t360_r:delete lio)",1)
         LET g_success='N'
      END IF

       INITIALIZE g_lin.* TO NULL

      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM
      
         CALL g_lio.clear()
         CALL g_lio2.clear()
         CALL g_lio3.clear()
         
         OPEN t360_count
         IF STATUS THEN
            CLOSE t360_cs
            CLOSE t360_count
            COMMIT WORK
            RETURN
         END IF
         
         FETCH t360_count INTO g_row_count
         
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t360_cs
            CLOSE t360_count
            COMMIT WORK
            RETURN
         END IF
         
         DISPLAY g_row_count TO FORMONLY.cnt

         OPEN t360_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t360_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t360_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_lin.* = g_lin_t.*
       END IF
    END IF 

    CLOSE t360_cl
    COMMIT WORK
    CALL t360_show()
END FUNCTION

FUNCTION t360_u()
   DEFINE   l_n         LIKE type_file.num5
     
   IF cl_null(g_lin.lin01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF       
        
   SELECT * INTO g_lin.* FROM lin_file 
     WHERE lin01 = g_lin.lin01
 
   IF g_lin.linconf = 'Y' THEN
      CALL cl_err(g_lin.lin01,'alm-027',1)
      RETURN
   END IF    
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lin01_t = g_lin.lin01
   BEGIN WORK
 
   OPEN t360_cl USING g_lin.lin01
   IF STATUS THEN
      CALL cl_err("OPEN t360_cl:",STATUS,1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t360_cl INTO g_lin.*  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF 

   ###############
   LET g_date = g_lin.lindate
   LET g_modu = g_lin.linmodu
   ############### 
   
   LET g_lin.linmodu = g_user  
   LET g_lin.lindate = g_today 

   CALL t360_show() 
   
   WHILE TRUE
      CALL t360_i('u')        

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lin_t.lindate = g_date
         LET g_lin_t.linmodu = g_modu
         LET g_lin.*=g_lin_t.*
         CALL t360_show()     
         CALL cl_err('',9001,0)        
         EXIT WHILE           
      END IF

      IF g_lin.lin01 != g_lin01_t THEN
         UPDATE lio_file 
            SET lio01 = g_lin.lin01 
          WHERE lio01 = g_lin01_t
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("upd","lio_file",g_lin01_t,
                 "",SQLCA.sqlcode,"","lio",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE lin_file SET lin_file.* = g_lin.*
       WHERE lin01 = g_lin01_t
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE 
   END WHILE
   CLOSE t360_cl
   COMMIT WORK

   SELECT * INTO g_lin.*
     FROM lin_file
    WHERE lin01 = g_lin.lin01

   CALL t360_show()
   CALL cl_flow_notify(g_lin.lin01,'U')
   CALL t360_b1_fill(" 1=1")
   CALL t360_b2_fill(" 1=1")
   CALL t360_b3_fill(" 1=1")
END FUNCTION

FUNCTION t360_set_entry(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_input_done) THEN
      CALL cl_set_comp_entry("lin01",TRUE)
   END IF
END FUNCTION

FUNCTION t360_set_no_entry(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1 
    IF p_cmd = 'u' AND (NOT g_input_done) THEN
      CALL cl_set_comp_entry("lin01",FALSE)
   END IF
END FUNCTION

#FUNCTION t360_set_entry_lio(p_cmd)
#   DEFINE   p_cmd    LIKE type_file.chr1
#
#   IF p_cmd = 'a' AND (NOT g_input_done) THEN
#      CALL cl_set_comp_entry("lio04,lio05",TRUE)
#   END IF
#END FUNCTION

FUNCTION t360_confirm()
   DEFINE l_linconu       LIKE lin_file.linconu,
          l_lincond       LIKE lin_file.lincond,
          l_count         LIKE type_file.num5,
          l_lin17         LIKE lin_file.lin17,
          l_gen02         LIKE gen_file.gen02,
          l_lincont       LIKE lin_file.lincont
  
   IF cl_null(g_lin.lin01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------- add -------- begin
   IF g_lin.linconf = 'Y' THEN
      CALL cl_err(g_lin.lin01,'alm-005',1)
      RETURN
   END IF  
   IF NOT cl_confirm("alm-006") THEN RETURN END IF
   SELECT * INTO g_lin.* FROM lin_file
    WHERE lin01 = g_lin.lin01
#CHI-C30107 ------- add -------- end
   IF g_lin.linconf = 'Y' THEN
      CALL cl_err(g_lin.lin01,'alm-005',1)
      RETURN
   END IF
   
#  SELECT * INTO g_lin.* FROM lin_file  #CHI-C30107 mark
#   WHERE lin01 = g_lin.lin01           #CHI-C30107 mark
   
   LET l_linconu = g_lin.linconu
   LET l_lincond = g_lin.lincond 
   LET l_lin17   = g_lin.lin17
   LET l_lincont = g_lin.lincont
   
   SELECT * INTO g_lin.* FROM lin_file
    WHERE lin01 = g_lin.lin01

   LET g_success = 'Y'
    
   BEGIN WORK 
   OPEN t360_cl USING g_lin.lin01
   IF STATUS THEN 
      CALL cl_err("open t360_cl:",STATUS,1)
      CLOSE t360_cl
      ROLLBACK WORK 
      RETURN 
   END IF 
    
   FETCH t360_cl INTO g_lin.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN 
   END IF    
  
#CHI-C30107 -------- mark -------- begin
#  IF NOT cl_confirm("alm-006") THEN
#     RETURN
#  ELSE
#CHI-C30107 -------- mark -------- end
      LET g_lin.linconf = 'Y'
      LET g_lin.linconu = g_user
      LET g_lin.lincond = g_today 
      LET g_lin.lin17   = '1' 
      LET g_lin.lincont = TIME
        
      UPDATE lin_file
         SET linconf = g_lin.linconf,
             linconu = g_lin.linconu,
             lincond = g_lin.lincond,
             lin17   = g_lin.lin17,
             lincont = g_lin.lincont 
       WHERE lin01 = g_lin.lin01
       
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lin:',SQLCA.SQLCODE,0)
         LET g_lin.linconf = 'N'
         LET g_lin.linconu = l_linconu
         LET g_lin.lincond = l_lincond
         LET g_lin.lin17   = l_lin17
         LET g_lin.lincont = ''
         DISPLAY BY NAME g_lin.lin17,g_lin.linconf,g_lin.linconu,
                         g_lin.lincond,g_lin.lincont
         RETURN
      ELSE
         DISPLAY BY NAME g_lin.lin17,g_lin.linconf,g_lin.linconu,
                         g_lin.lincond,g_lin.lincont       
         CALL cl_set_field_pic(g_lin.linconf,"","","","","")

         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lin.linconu
         DISPLAY l_gen02 TO FORMONLY.gen02_1
      END IF
#  END IF  #CHI-C30107 mark
   CLOSE t360_cl
   COMMIT WORK
END FUNCTION

FUNCTION t360_cer_confirm()
   DEFINE l_n         LIKE type_file.num5,
          l_linconu   LIKE lin_file.linconu,
          l_lincond   LIKE lin_file.lincond,
          l_lin17     LIKE lin_file.lin17,
          l_lincont   LIKE lin_file.lincont
   DEFINE l_gen02     LIKE gen_file.gen02         #CHI-D20015---ADD---
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   IF g_lin.lin01 IS NULL  OR g_lin.linplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_lin.* FROM lin_file 
    WHERE lin01 = g_lin.lin01

   LET l_linconu = g_lin.linconu
   LET l_lincond = g_lin.lincond
   LET l_lin17   = g_lin.lin17   
   LET l_lincont = g_lin.lincont

   IF g_lin.linconf <> 'Y' THEN
      CALL cl_err('','alm-007',0)
      RETURN
   END IF

   IF g_lin.linacti = 'N' THEN
      CALL cl_err(g_lin.lin01,'mfg0301',0)
      RETURN
   END IF 

   IF g_lin.lin17 = '2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF


   LET g_success = 'Y'

   BEGIN WORK

   OPEN t360_cl USING g_lin.lin01
   IF STATUS THEN
      CALL cl_err("open t360_cl:",STATUS,1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t360_cl INTO g_lin.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      LET g_lin.lin17   = '0'
      LET g_lin.linconf = 'N'
      #CHI-D20015---modify---str---
      #LET g_lin.linconu = NULL
      #LET g_lin.lincond =NULL
      LET g_lin.linconu = g_user
      LET g_lin.lincond = g_today
      #CHI-D20015---modify---end---
      LET g_lin.linmodu = g_user
      LET g_lin.lindate = g_today
      #LET g_lin.lincont = NULL       #CHI-D20015---mark---
      LET g_lin.lincont = TIME        #CHI-D20015---add---
      
      UPDATE lin_file 
         SET linconf = g_lin.linconf,
             linconu = g_lin.linconu,
             lincond = g_lin.lincond,
             linmodu = g_lin.linmodu,
             lindate = g_lin.lindate,
             lin17   = g_lin.lin17,
             lincont = g_lin.lincont
       WHERE lin01 = g_lin.lin01
     
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd lin:',SQLCA.sqlcode,0)
         LET g_lin.lin17   = '0'
         LET g_lin.linconf = 'Y'
         LET g_lin.linconu = l_linconu
         LET g_lin.lincond = l_lincond
         LET g_lin.lincont = l_lincont 
         DISPLAY BY NAME g_lin.linconf,g_lin.linconu,g_lin.lincond,
                         g_lin.linmodu,g_lin.lindate,g_lin.lin17,g_lin.lincont
         RETURN
      ELSE
         #DISPLAY '' TO FORMONLY.gen02_1    #CHI-D20015---mark---
         DISPLAY BY NAME g_lin.linconf,g_lin.linconu,g_lin.lincond,
                         g_lin.linmodu,g_lin.lindate,g_lin.lin17,g_lin.lincont      
         CALL cl_set_field_pic(g_lin.linconf,"","","","","")
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lin.linconu  #CHI-D20015---ADD---
         DISPLAY l_gen02 TO FORMONLY.gen02_1                                  #CHI-D20015---ADD---
      END IF
   END IF
   CLOSE t360_cl
   COMMIT WORK
END FUNCTION

FUNCTION t360_post()
   DEFINE   l_t        LIKE type_file.chr1,
            l_sql      STRING ,
            l_cnt      LIKE type_file.num5,
            l_lin14    LIKE lin_file.lin14,
            l_lin141   LIKE lin_file.lin141,
            l_lin15    LIKE lin_file.lin15,
            l_lin151   LIKE lin_file.lin151,
            startdate  LIKE type_file.dat,
            enddate    LIKE type_file.dat
   
   IF g_lin.lin01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_lin.* 
     FROM lin_file 
    WHERE lin01 = g_lin.lin01
    
   IF g_lin.linplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
   
   IF g_lin.lin17 = '0' THEN 
      CALL cl_err('','art-124',0) 
      RETURN 
   END IF

   IF g_lin.lin17 = '2' THEN 
      CALL cl_err('','art-125',0) 
      RETURN 
   END IF

   IF NOT cl_confirm('alm-207') THEN 
      RETURN 
   END IF

   SELECT lin14,lin141,lin15,lin151 INTO l_lin14,l_lin141,l_lin15,l_lin151
     FROM lin_file
    WHERE lin01 = g_lin.lin01

   IF NOT cl_null(g_lin.lin141) THEN
      LET startdate = g_lin.lin141
   ELSE 
      LET startdate = g_lin.lin14
   END IF
   
   IF NOT cl_null(g_lin.lin151) THEN
      LET enddate = g_lin.lin151
   ELSE 
      LET enddate = g_lin.lin15
   END IF 

   CALL t360_check_date(startdate,enddate)

   IF NOT cl_null(g_errno) THEN
      CALL cl_err ('',g_errno,0) 
      RETURN
   END IF 
  
   LET g_success = 'Y' 

   BEGIN WORK
   CALL s_showmsg_init()
   OPEN t360_cl USING g_lin.lin01
   IF STATUS THEN
      CALL cl_err("OPEN t360_cl:", STATUS, 1)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t360_cl INTO g_lin.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      CLOSE t360_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_null(g_lin.lin141) THEN
      UPDATE lil_file 
         SET lil12 = g_lin.lin141
       WHERE lil01 = g_lin.lin04
     
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
           ROLLBACK WORK
           RETURN
      END IF
   END IF 

   IF NOT cl_null(g_lin.lin151) THEN
      UPDATE lil_file
         SET lil13 = g_lin.lin151
       WHERE lil01 = g_lin.lin04

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
           ROLLBACK WORK
           RETURN
      END IF
   END IF

   IF NOT cl_null(g_lin.lin161) THEN
      UPDATE lil_file
         SET lil14 = g_lin.lin161
       WHERE lil01 = g_lin.lin04

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
           ROLLBACK WORK
           RETURN
      END IF
   END IF
   
   UPDATE lil_file 
      SET lil02 = g_lin.lin05
    WHERE lil01 = g_lin.lin04
  
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
    
   CALL t360_chk_lio() 

   UPDATE lin_file
      SET  lin17 = '2'
    WHERE lin01 = g_lin.lin01

   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err(g_lin.lin01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
   END IF

   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE 
      ROLLBACK WORK 
   END IF

   SELECT * INTO g_lin.* FROM lin_file WHERE lin01 = g_lin.lin01
   DISPLAY BY NAME g_lin.lin17
   CLOSE t360_cl
END FUNCTION

FUNCTION t360_chk_lio()
   DEFINE l_sql    STRING
   DEFINE l_lio02  LIKE lio_file.lio02,
          l_lio03  LIKE lio_file.lio03,
          l_n      LIKE type_file.num5
   DEFINE l_lio    RECORD LIKE lio_file.*

   LET l_sql = "SELECT DISTINCT lio02 FROM lio_file ",
               " WHERE lio01 ='",g_lin.lin01,"'"

   DECLARE lio_chk CURSOR FROM l_sql

   FOREACH lio_chk INTO l_lio02
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      SELECT count(*) INTO l_n
        FROM lio_file
       WHERE lio01 = g_lin.lin01
         AND lio02 = l_lio02

      IF l_n = '2' THEN
         SELECT * INTO l_lio.*
           FROM lio_file
         WHERE lio01 = g_lin.lin01
            AND lio02 = l_lio02
            AND lio03 = '1'
         
         UPDATE lim_file
            SET lim03 = l_lio.lio04,
                lim04 = l_lio.lio05,
                lim05 = l_lio.lio06,
                lim051 = l_lio.lio061,
                lim06 = l_lio.lio07,
                lim061 = l_lio.lio071,
                lim062 = l_lio.lio072,
                lim07  = l_lio.lio08,
                lim071 = l_lio.lio081,
                lim072 = l_lio.lio082,
                lim073 = l_lio.lio083
          WHERE lim01 = g_lin.lin04
            AND lim02 = l_lio02

         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("upd","lim_file",g_lin.lin04,"",SQLCA.sqlcode,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      
      IF l_n = '1' THEN
         SELECT lio03 INTO l_lio03
           FROM lio_file
          WHERE lio01 = g_lin.lin01
            AND lio02 = l_lio02
 
         IF l_lio03 = '2' THEN    
            SELECT * INTO l_lio.*
              FROM lio_file
             WHERE lio01 = g_lin.lin01
               AND lio02 = l_lio02
               AND lio03 = '2'
            INSERT INTO lim_file(lim01,lim02,lim03,lim04,lim05,lim051,lim06,
                                 lim061,lim062,lim07,lim071,lim072,lim073,
                                 limplant,limlegal)
                        VALUES(g_lin.lin04,l_lio02,l_lio.lio04,l_lio.lio05,l_lio.lio06,
                               l_lio.lio061,l_lio.lio07,l_lio.lio071,l_lio.lio072,
                               l_lio.lio08,l_lio.lio081,l_lio.lio082,l_lio.lio083,
                               l_lio.lioplant,l_lio.liolegal)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("ins","lim_file",g_lin.lin04,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF 
      END IF     
   END FOREACH
   
END FUNCTION

FUNCTION t360_check_date(p_start,p_end)
   DEFINE p_plant     LIKE lin_file.linplant,    # 门店编号
          p_6         LIKE lin_file.lin06,       # 费用编号 
          p_7         LIKE lin_file.lin07,       # 楼栋
          p_8         LIKE lin_file.lin08,       # 楼层
          p_9         LIKE lin_file.lin09,       # 区域
          p_10        LIKE lin_file.lin10,       # 小类 
          p_11        LIKE lin_file.lin11,       # 摊位用途
          p_start     LIKE type_file.dat,        # 预租开始日期
          p_end       LIKE type_file.dat,        # 预租结束日期
          l_n         LIKE type_file.num5

   SELECT COUNT(*) INTO l_n
     FROM lil_file
    WHERE lilplant = g_lin.linplant
      AND lil04 = g_lin.lin06 
      AND lil05 = g_lin.lin07
      AND lil06 = g_lin.lin08
      AND lil07 = g_lin.lin09
      AND lil08 = g_lin.lin10
      AND lil09 = g_lin.lin11
      AND lil01 <> g_lin.lin04
      AND lilconf <> 'S'           #TQC-C30210 add
      AND (
            lil12 BETWEEN p_start AND p_end
          OR  lil13 BETWEEN p_start AND p_end
              OR  (lil12<=p_start AND lil13>= p_end)
               )
   IF l_n>0 THEN
      LET g_errno = 'alm1078'
   END IF
END FUNCTION  

FUNCTION t360_upd_lim()
   IF g_lin.lin00 = '1' THEn
      UPDATE lio_file 
         SET lim03 = g_lio4.lio04,
             lim04 = g_lio4.lio05,
             lim05 = g_lio4.lio06,
             lim051 = g_lio4.lio061
       WHERE lio01 = g_lio4.lio01
         AND lio02 = g_lio4.lio02   
   
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
    
   IF g_lin.lin00 = '2' THEn
      UPDATE lio_file 
         SET lim03 = g_lio4.lio04,
             lim04 = g_lio4.lio05,
             lim06 = g_lio4.lio07,
             lim061 = g_lio4.lio071,
             lim062 = g_lio4.lio072
       WHERE lio01 = g_lio4.lio01
         AND lio02 = g_lio4.lio02      

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   IF g_lin.lin00 = '3' THEn
      UPDATE lio_file 
         SET lim03 = g_lio4.lio04,
             lim04 = g_lio4.lio05,
             lim07 = g_lio4.lio08,
             lim071 = g_lio4.lio081,
             lim072 = g_lio4.lio082,
             lim073 = g_lio4.lio083
       WHERE lio01 = g_lio4.lio01
         AND lio02 = g_lio4.lio02     
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF 
END FUNCTION

FUNCTION t360_ins_lim() 
   DEFINE   l_lim  RECORD LIKE lim_file.*
  
   LET l_lim.lim01 = g_lio4.lio01
   LET l_lim.lim02 = g_lio4.lio02 
   LET l_lim.lim03 = g_lio4.lio04
   LET l_lim.lim04 = g_lio4.lio05
   LET l_lim.limplant = g_lio4.lioplant
   LET l_lim.limlegal = g_lio4.liolegal

   IF g_lin.lin00 = '1' THEN
      LET l_lim.lim05 = g_lio4.lio06
      LET l_lim.lim051 = g_lio4.lio061
      INSERT INTO lim_file (lim01,lim02,lim03,lim04,lim05,lim051,limplant,limlegal)
            VALUES(l_lim.lim01,l_lim.lim02,l_lim.lim03,l_lim.lim04,l_lim.lim05,
            l_lim.lim051,l_lim.limplant,l_lim.limlegal)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF   
   END IF

   IF g_lin.lin00 = '2' THEN
      LET l_lim.lim06 = g_lio4.lio07
      LET l_lim.lim061 = g_lio4.lio071
      LET l_lim.lim062 = g_lio4.lio072
      INSERT INTO lim_file (lim01,lim02,lim03,lim04,lim06,lim061,lim062,
                            limplant,limlegal)
            VALUES(l_lim.lim01,l_lim.lim02,l_lim.lim03,l_lim.lim04,l_lim.lim06,
                   l_lim.lim061,l_lim.lim062,l_lim.limplant,l_lim.limlegal)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF    
   END IF 

   IF g_lin.lin00 = '3' THEN
      LET l_lim.lim07 = g_lio4.lio08
      LET l_lim.lim071 = g_lio4.lio081
      LET l_lim.lim072 = g_lio4.lio082
      LET l_lim.lim073 = g_lio4.lio083
      INSERT INTO lim_file (lim01,lim02,lim03,lim04,lim07,lim071,lim072,lim073,
                            limplant,limlegal)
            VALUES(l_lim.lim01,l_lim.lim02,l_lim.lim03,l_lim.lim04,l_lim.lim07,
                   l_lim.lim071,l_lim.lim072,l_lim.lim073,l_lim.limplant,
                   l_lim.limplant)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ins lim_file',g_lio4.lio01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
      END IF 
   END IF 
END FUNCTION

FUNCTION t360_lin04_1()
   DEFINE l_n      LIKE type_file.num5,
          l_lin17  LIKE lin_file.lin17

   LET g_errno = ''

   SELECT count(*) INTO l_n
     FROM lin_file
    WHERE lin04 = g_lin.lin04
      AND lin17 <> '2' 

   IF l_n >0 THEN
      LET g_errno = 'alm1117'
   END IF 
END FUNCTION

FUNCTION t360_lin04(p_cmd)
   DEFINE l_lil     RECORD LIKE lil_file.*
   DEFINE l_lin     RECORD LIKE lin_file.*
   DEFINE p_cmd            LIKE type_file.chr1

   SELECT * INTO l_lil.* FROM lil_file
    WHERE lil01 = g_lin.lin04

   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1083'
      WHEN l_lil.lilacti = 'N'  LET g_errno = 'alm1082'
      WHEN l_lil.lilconf = 'N'  LET g_errno = 'alm1094'
      WHEN l_lil.lilconf = 'S'  LET g_errno = 'alm-228'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   CALL t360_lin05(g_lin.lin04) RETURNING g_lin.lin05

   IF cl_null(g_errno) THEN
      CALL t360_checkexpense(l_lil.lil00,l_lil.lil04,l_lil.lilplant,l_lil.lil05,l_lil.lil06,
                             l_lil.lil07,l_lil.lil08,l_lil.lil09,l_lil.lil10,
                             l_lil.lil11)
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lin.lin00 = l_lil.lil00
      LET g_lin.lin04 = l_lil.lil01
      LET g_lin.lin06 = l_lil.lil04
      LET g_lin.linplant = l_lil.lilplant
      LET g_lin.linlegal = l_lil.lillegal
      LET g_lin.lin07 = l_lil.lil05
      LET g_lin.lin08 = l_lil.lil06
      LET g_lin.lin09 = l_lil.lil07
      LET g_lin.lin10 = l_lil.lil08
      LET g_lin.lin11 = l_lil.lil09
      LET g_lin.lin12 = l_lil.lil10
      LET g_lin.lin13 = l_lil.lil11
      LET g_lin.lin14 = l_lil.lil12
      LET g_lin.lin15 = l_lil.lil13
      LET g_lin.lin16 = l_lil.lil14
      DISPLAY BY NAME g_lin.lin00,g_lin.lin04,g_lin.lin05,g_lin.lin06,g_lin.linplant,
                      g_lin.linlegal,g_lin.lin07,g_lin.lin08,g_lin.lin09,
                      g_lin.lin10,g_lin.lin11,g_lin.lin12,g_lin.lin13,
                      g_lin.lin14,g_lin.lin15,g_lin.lin16
   END IF
END FUNCTION

FUNCTION t360_lin05(l_lil01)
   DEFINE l_n        LIKE type_file.num5,
          l_lil01    LIKE lil_file.lil01,
          l_lin05    LIKE lin_file.lin05

      SELECT lil02 INTO l_lin05
        FROM lil_file
       WHERE lil01 = l_lil01
     
      IF cl_null(l_lin05) THEN
         LET l_lin05 = 1
      ELSE 
         LET l_lin05 = l_lin05+1
      END IF
   RETURN l_lin05
END FUNCTION

FUNCTION t360_lin05_2()
   DEFINE l_n          LIKE type_file.num5
   
   LET g_errno = ''

   SELECT count(*) INTO l_n
     FROM lin_file
    WHERE lin04 = g_lin.lin04
      AND lin05 = g_lin.lin05

   IF l_n >0 THEN
      LET g_errno = 'alm1095'
   END IF
          
END FUNCTION

FUNCTION t360_checkexpense(l_lil00,l_lil04,l_lilplant,l_lil05,l_lil06,l_lil07,
                           l_lil08,l_lil09,l_lil10,l_lil11)
   DEFINE l_lil00         LIKE lil_file.lil00,#方案类型
          l_lil04         LIKE lil_file.lil04,#费用编号
          l_lilplant      LIKE lil_file.lilplant,#门店
          l_lil05         LIKE lil_file.lil05,#楼栋编号
          l_lil06         LIKE lil_file.lil06,#楼层编号
          l_lil07         LIKE lil_file.lil07,#区域编号
          l_lil08         LIKE lil_file.lil08,#小类编号
          l_lil09         LIKE lil_file.lil09,#摊位用途
          l_lil10         LIKE lil_file.lil10,#日期类型
          l_lil11         LIKE lil_file.lil11,#定义方式
          l_lnl03         LIKE lnl_file.lnl03,#楼栋
          l_lnl04         LIKE lnl_file.lnl04,#楼层
          l_lnl05         LIKE lnl_file.lnl05,#区域
          l_lnl09         LIKE lnl_file.lnl09,#小类
          l_n             LIKE type_file.chr1
   DEFINE l_sql           STRING

   LET g_errno = ''

   SELECT lnl03,lnl04,lnl05,lnl09
     INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = l_lil04 AND lnlstore = l_lilplant

   CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = 100
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
         SELECT count(*) INTO l_n FROM lik_file
          WHERE lik01 = l_lil04
            AND lik07 = l_lil09
            AND lik08 = l_lil10
            AND lik09 = l_lil11
            AND lik10 = l_lil00
         IF l_n = 0 THEN
            LET g_errno= 'alm1084'
         END IF
      END IF
   END IF
END FUNCTION
#--FUN-B90121----------------------------------------------------------------------
