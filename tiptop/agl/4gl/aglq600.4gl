# Prog. Version..: '5.30.06-13.03.18(00004)'     #
# Pattern name...: aglq600.4gl
# Descriptions...: 年度預算實際查詢
# Date & Author..: No.FUN-AC0053 11/03/23 By baogc
# Modify.........: No.FUN-B40025 11/04/12 By baogc 修改BUG
# Modify.........: No.MOD-BA0180 11/10/25 By Polly 預算項目欄位開窗改開q_azf01a
# Modify.........: No.MOD-D30082 13/03/08 By apo 調整預算計算式中挪用金額部分
# Modify.........: No.MOD-D60170 13/06/20 By fengmy 算当月实际金额时，去掉axcq310抛转的凭证资料
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE tm             RECORD
                      yy      LIKE type_file.chr4,
                      mon1    LIKE type_file.chr2,
                      mon2    LIKE type_file.chr2,
                      confirm LIKE type_file.chr1,
                      post    LIKE type_file.chr1
                      END RECORD
                      
DEFINE tm1            RECORD
                      project  LIKE type_file.chr1,
                      subject  LIKE type_file.chr1,
                      depart   LIKE type_file.chr1
                      END RECORD
                      
DEFINE g_wc           STRING
DEFINE g_str          LIKE type_file.num5
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num10
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_omb          DYNAMIC ARRAY OF RECORD
              item          LIKE type_file.num5,
              prono         LIKE afa_file.afa01,
              proname       LIKE afa_file.afa02,
              subno         LIKE aag_file.aag01,
              subname       LIKE aag_file.aag02,
              depno         LIKE gem_file.gem01,
              depname       LIKE gem_file.gem02,
              month_b1      LIKE afc_file.afc06,
              month_p1      LIKE abb_file.abb07,
              month_o1      LIKE afc_file.afc06,
              month_b2      LIKE afc_file.afc06,
              month_p2      LIKE abb_file.abb07,
              month_o2      LIKE afc_file.afc06,
              month_b3      LIKE afc_file.afc06,
              month_p3      LIKE abb_file.abb07,
              month_o3      LIKE afc_file.afc06,
              month_b4      LIKE afc_file.afc06,
              month_p4      LIKE abb_file.abb07,
              month_o4      LIKE afc_file.afc06,
              month_b5      LIKE afc_file.afc06,
              month_p5      LIKE abb_file.abb07,
              month_o5      LIKE afc_file.afc06,
              month_b6      LIKE afc_file.afc06,
              month_p6      LIKE abb_file.abb07,
              month_o6      LIKE afc_file.afc06,
              month_b7      LIKE afc_file.afc06,
              month_p7      LIKE abb_file.abb07,
              month_o7      LIKE afc_file.afc06,
              month_b8      LIKE afc_file.afc06,
              month_p8      LIKE abb_file.abb07,
              month_o8      LIKE afc_file.afc06,
              month_b9      LIKE afc_file.afc06,
              month_p9      LIKE abb_file.abb07,
              month_o9      LIKE afc_file.afc06,
              month_b10     LIKE afc_file.afc06,
              month_p10     LIKE abb_file.abb07,
              month_o10     LIKE afc_file.afc06,
              month_b11     LIKE afc_file.afc06,
              month_p11     LIKE abb_file.abb07,
              month_o11     LIKE afc_file.afc06,
              month_b12     LIKE afc_file.afc06,
              month_p12     LIKE abb_file.abb07,
              month_o12     LIKE afc_file.afc06,
              sum_b         LIKE afc_file.afc06,
              sum_p         LIKE abb_file.abb07,
              sum_o         LIKE afc_file.afc06
                       END RECORD
DEFINE sr          RECORD
              item          LIKE type_file.num5,
              prono         LIKE afa_file.afa01,
              proname       LIKE afa_file.afa02,
              subno         LIKE aag_file.aag01,
              subname       LIKE aag_file.aag02,
              depno         LIKE gem_file.gem01,
              depname       LIKE gem_file.gem02,
              month_b1      LIKE afc_file.afc06,
              month_p1      LIKE abb_file.abb07,
              month_o1      LIKE afc_file.afc06,
              month_b2      LIKE afc_file.afc06,
              month_p2      LIKE abb_file.abb07,
              month_o2      LIKE afc_file.afc06,
              month_b3      LIKE afc_file.afc06,
              month_p3      LIKE abb_file.abb07,
              month_o3      LIKE afc_file.afc06,
              month_b4      LIKE afc_file.afc06,
              month_p4      LIKE abb_file.abb07,
              month_o4      LIKE afc_file.afc06,
              month_b5      LIKE afc_file.afc06,
              month_p5      LIKE abb_file.abb07,
              month_o5      LIKE afc_file.afc06,
              month_b6      LIKE afc_file.afc06,
              month_p6      LIKE abb_file.abb07,
              month_o6      LIKE afc_file.afc06,
              month_b7      LIKE afc_file.afc06,
              month_p7      LIKE abb_file.abb07,
              month_o7      LIKE afc_file.afc06,
              month_b8      LIKE afc_file.afc06,
              month_p8      LIKE abb_file.abb07,
              month_o8      LIKE afc_file.afc06,
              month_b9      LIKE afc_file.afc06,
              month_p9      LIKE abb_file.abb07,
              month_o9      LIKE afc_file.afc06,
              month_b10     LIKE afc_file.afc06,
              month_p10     LIKE abb_file.abb07,
              month_o10     LIKE afc_file.afc06,
              month_b11     LIKE afc_file.afc06,
              month_p11     LIKE abb_file.abb07,
              month_o11     LIKE afc_file.afc06,
              month_b12     LIKE afc_file.afc06,
              month_p12     LIKE abb_file.abb07,
              month_o12     LIKE afc_file.afc06,
              sum_b         LIKE afc_file.afc06,
              sum_p         LIKE abb_file.abb07,
              sum_o         LIKE afc_file.afc06
                       END RECORD
                       
DEFINE sr1             RECORD
          mon               LIKE afc_file.afc05,
          budget            LIKE afc_file.afc06
                       END RECORD
                       
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_bookno       LIKE aaa_file.aaa01
DEFINE g_sel          LIKE type_file.chr1000
DEFINE g_grp          LIKE type_file.chr1000
DEFINE g_ord          LIKE type_file.chr1000
DEFINE g_sum          LIKE type_file.chr1000
DEFINE l_ac           LIKE type_file.num5

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
   
   DROP TABLE aglq600_tmp
   CREATE TEMP TABLE aglq600_tmp(
              item          LIKE type_file.num5,
              prono         LIKE afa_file.afa01,
              proname       LIKE afa_file.afa02,
              subno         LIKE aag_file.aag01,
              subname       LIKE aag_file.aag02,
              depno         LIKE gem_file.gem01,
              depname       LIKE gem_file.gem02,
              month_b1      LIKE afc_file.afc06,
              month_p1      LIKE abb_file.abb07,
              month_o1      LIKE afc_file.afc06,
              month_b2      LIKE afc_file.afc06,
              month_p2      LIKE abb_file.abb07,
              month_o2      LIKE afc_file.afc06,
              month_b3      LIKE afc_file.afc06,
              month_p3      LIKE abb_file.abb07,
              month_o3      LIKE afc_file.afc06,
              month_b4      LIKE afc_file.afc06,
              month_p4      LIKE abb_file.abb07,
              month_o4      LIKE afc_file.afc06,
              month_b5      LIKE afc_file.afc06,
              month_p5      LIKE abb_file.abb07,
              month_o5      LIKE afc_file.afc06,
              month_b6      LIKE afc_file.afc06,
              month_p6      LIKE abb_file.abb07,
              month_o6      LIKE afc_file.afc06,
              month_b7      LIKE afc_file.afc06,
              month_p7      LIKE abb_file.abb07,
              month_o7      LIKE afc_file.afc06,
              month_b8      LIKE afc_file.afc06,
              month_p8      LIKE abb_file.abb07,
              month_o8      LIKE afc_file.afc06,
              month_b9      LIKE afc_file.afc06,
              month_p9      LIKE abb_file.abb07,
              month_o9      LIKE afc_file.afc06,
              month_b10     LIKE afc_file.afc06,
              month_p10     LIKE abb_file.abb07,
              month_o10     LIKE afc_file.afc06,
              month_b11     LIKE afc_file.afc06,
              month_p11     LIKE abb_file.abb07,
              month_o11     LIKE afc_file.afc06,
              month_b12     LIKE afc_file.afc06,
              month_p12     LIKE abb_file.abb07,
              month_o12     LIKE afc_file.afc06,
              sum_b         LIKE afc_file.afc06,
              sum_p         LIKE abb_file.abb07,
              sum_o         LIKE afc_file.afc06)

   OPEN WINDOW q600_w
        WITH FORM "agl/42f/aglq600_d" ATTRIBUTE(STYLE = g_win_style)
        
        
   LET g_bookno = g_aza.aza81
   CALL cl_ui_init()
  
   CALL q600_q()

   CALL q600_menu()

   CLOSE WINDOW q600_w
   
   DROP TABLE aglq600_tmp

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q600_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_omb),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q600_q()

    CALL aglq600_tm()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       RETURN
    END IF 
    CALL aglq600()
    CALL aglq600_show()

END FUNCTION 

FUNCTION aglq600_tm()
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE l_str          STRING

   OPEN WINDOW aglq600_w WITH FORM "agl/42f/aglq600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aglq600")

   INITIALIZE tm.*    TO NULL
   INITIALIZE tm1.*    TO NULL
   INITIALIZE l_str   TO NULL

         CONSTRUCT BY NAME g_wc ON afb01,afb041,afb02
            BEFORE CONSTRUCT
               ON ACTION CONTROLP 
                    CASE
                        WHEN INFIELD(afb01)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_afa"
                           #LET g_qryparam.form = "q_afa"               #MOD-BA0180 mark
                            LET g_qryparam.form = "q_azf01a"            #MOD-BA0180 add
                            LET g_qryparam.state= 'c'
                            LET g_qryparam.arg1 = '7'                   #MOD-BA0180 add
                        #   LET g_qryparam.construct ='N'   #FUN-B40025 MARK
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO afb01
                            NEXT FIELD afb01
                        WHEN INFIELD(afb041)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_gem"
                            LET g_qryparam.state= 'c'
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO afb041
                            NEXT FIELD afb041
                        WHEN INFIELD(afb02)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_aag11"
                            LET g_qryparam.state= 'c'
                        #   LET g_qryparam.construct ='N'   #FUN-B40025 MARK
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO afb02
                            NEXT FIELD afb02
                    END CASE
                    
               ON ACTION CONTROLR
                  CALL cl_show_req_fields()

               ON ACTION CONTROLG
                  CALL cl_cmdask()
                    
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT

               ON ACTION about
                  CALL cl_about()

               ON ACTION help
                  CALL cl_show_help()

               ON ACTION exit
                  LET INT_FLAG = 1
                  EXIT CONSTRUCT        
         END CONSTRUCT
         IF INT_FLAG THEN
            CLOSE WINDOW aglq600_w
            RETURN
         END IF

         INPUT BY NAME tm.*
               ATTRIBUTES( WITHOUT DEFAULTS = TRUE)

               BEFORE INPUT
                  SELECT aaa04,aaa05 INTO tm.yy,tm.mon2
                    FROM aaa_file
                   WHERE aaa01 = g_bookno
                  LET tm.mon1 = 1
                  LET tm.confirm = 'Y'
                  LET tm.post = 'Y'
                  DISPLAY BY NAME tm.*
               AFTER FIELD yy
                  IF NOT cl_null(tm.yy) THEN
                     IF tm.yy < 1990 OR tm.yy > 3000 THEN
                       CALL cl_err('','aoo-020',1)
                       NEXT FIELD yy
                     END IF
                  END IF
               AFTER FIELD mon1
###-FUN-B40025- ADD - BEGIN -------------------------------------------
                  IF NOT cl_null(tm.mon1) THEN
                     IF tm.mon1 > 12 OR tm.mon1 < 1 THEN
                        CALL cl_err('','aom-580',1)
                        NEXT FIELD mon1
                     END IF
                  END IF
###-FUN-B40025- ADD -  END  -------------------------------------------
                  IF NOT cl_null(tm.mon1) AND NOT cl_null(tm.mon2) THEN
                     IF tm.mon1 > tm.mon2 THEN
                        CALL cl_err('','aps-725',1)
                        NEXT FIELD mon1
                     END IF
                  END IF
               AFTER FIELD mon2
###-FUN-B40025- ADD - BEGIN -------------------------------------------
                  IF NOT cl_null(tm.mon2) THEN
                     IF tm.mon2 > 12 OR tm.mon2 < 1 THEN
                        CALL cl_err('','aom-580',1)
                        NEXT FIELD mon2
                     END IF
                  END IF
###-FUN-B40025- ADD -  END  -------------------------------------------
                  IF NOT cl_null(tm.mon1) AND NOT cl_null(tm.mon2) THEN
                     IF tm.mon1 > tm.mon2 THEN
                        CALL cl_err('','aps-725',1)
                        NEXT FIELD mon2
                     END IF
                  END IF

               ON ACTION CONTROLR
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
         IF INT_FLAG THEN
            CLOSE WINDOW aglq600_w
            RETURN
         END IF

         INPUT BY NAME tm1.*
               ATTRIBUTES( WITHOUT DEFAULTS = TRUE)
               
               BEFORE INPUT
                  LET tm1.project = 'N'
                  LET tm1.subject = 'N'
                  LET tm1.depart  = 'N'
                  DISPLAY BY NAME tm1.*
               AFTER INPUT
###-FUN-B40025- ADD - BEGIN ----------------------------------------------
                  IF INT_FLAG THEN
                     EXIT INPUT
                  END IF
###-FUN-B40025- ADD -  END  ----------------------------------------------
                  IF tm1.project = 'N' AND tm1.subject = 'N' AND tm1.depart = 'N' THEN
               #     CALL cl_err('YEAR:','agl-260',1)  #FUN-B40025 MARK
                     CALL cl_err('','agl-260',1)       #FUN-B40025 ADD
                     NEXT FIELD project
                  END IF
               ON ACTION CONTROLR
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
         IF INT_FLAG THEN
            CLOSE WINDOW aglq600_w
            RETURN
         END IF
   CLOSE WINDOW aglq600_w

   CLEAR FORM
END FUNCTION

FUNCTION aglq600()
   DEFINE l_sql              LIKE type_file.chr1000,
          l_sql1             LIKE type_file.chr1000,
          l_sql2             LIKE type_file.chr1000,
          l_sql4             LIKE type_file.chr1000
   DEFINE l_sel              STRING

   CALL g_omb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   LET g_max_rec = 3000
   CALL q600_set_visible()
   CALL q600_set_str()

   DELETE FROM aglq600_tmp
   
#  LET l_sql = "SELECT DISTINCT '111',afb01,afa02,afb02,aag02,afb041,gem02,",     #FUN-B40025 MARK
   LET l_sql = "SELECT DISTINCT '111',afb01,azf03,afb02,aag02,afb041,gem02,  ",   #FUN-B40025 ADD
               "'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',",
               "'0','0','0','0','0','0','0','0','0','0','0','0','0',",
               "'0','0','0','0','0','0','0','0','0','0','0'",
#              " FROM afa_file,afb_file,aag_file,gem_file",                       #FUN-B40025 MARK
               "  FROM ((afb_file LEFT OUTER JOIN azf_file                   ",   #FUN-B40025 ADD
               "    ON azf01 = afb01 AND azf02 = '2' AND azfacti = 'Y')      ",   #FUN-B40025 ADD
               "  LEFT OUTER JOIN gem_file ON afb041 = gem01)                ",   #FUN-B40025 ADD
               "  LEFT OUTER JOIN aag_file ON aag00 = afb00 AND aag01 = afb02",   #FUN-B40025 ADD
#              " WHERE afb01 = afa01 AND aag01 = afb02 AND afb041 = gem01",       #FUN-B40025 MARK
               " WHERE ",g_wc CLIPPED," AND afb00 = '",g_bookno,"'",              #FUN-B40025 ADD
#              " AND ",g_wc CLIPPED," AND afb00 = '",g_bookno,"'",                #FUN-B40025 MARK
               " AND afb03 = '",tm.yy,"'"
              ," AND afbacti = 'Y' "                        #FUN-D70090 add 

   PREPARE aglq600_c FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('aglq600_c',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE aglq600_cs CURSOR FOR aglq600_c
   FOREACH aglq600_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('aglq600_cs foreach:',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      LET l_sql1 = "SELECT afc05,",
                  #"sum(COALESCE(afc06,0)-COALESCE(afc08,0)+COALESCE(afc09,0))",   #MOD-D30082 mark
                   "sum(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",   #MOD-D30082
                   " FROM afc_file",
                   " WHERE afc00 = '",g_bookno,"' AND afc01 = '",sr.prono,"'",
                   " AND afc02 = '",sr.subno,"'",
                   " AND afc041 = '",sr.depno,"'",
                   " AND afc03 = '",tm.yy,"'",
                   " AND afc05 BETWEEN '",tm.mon1,"' AND '",tm.mon2,"'",
                   " GROUP BY afc05"
      PREPARE aglq600_c1 FROM l_sql1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('aglq600_c1',SQLCA.sqlcode,1)
         RETURN
      END IF
      DECLARE aglq600_cs1 CURSOR FOR aglq600_c1
      FOREACH aglq600_cs1 INTO sr1.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('aglq600_cs1 foreach:',SQLCA.sqlcode,0) 
            EXIT FOREACH
         END IF
         CASE sr1.mon
            WHEN 1
               LET sr.month_b1 = sr1.budget
               LET sr.month_p1 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o1 = sr.month_p1 - sr.month_b1
            WHEN 2
               LET sr.month_b2 = sr1.budget
               LET sr.month_p2 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o2 = sr.month_p2 - sr.month_b2
            WHEN 3
               LET sr.month_b3 = sr1.budget
               LET sr.month_p3 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o3 = sr.month_p3 - sr.month_b3
            WHEN 4
               LET sr.month_b4 = sr1.budget
               LET sr.month_p4 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o4 = sr.month_p4 - sr.month_b4
            WHEN 5
               LET sr.month_b5 = sr1.budget
               LET sr.month_p5 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o5 = sr.month_p5 - sr.month_b5
            WHEN 6
               LET sr.month_b6 = sr1.budget
               LET sr.month_p6 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o6 = sr.month_p6 - sr.month_b6
            WHEN 7
               LET sr.month_b7 = sr1.budget
               LET sr.month_p7 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o7 = sr.month_p7 - sr.month_b7
            WHEN 8
               LET sr.month_b8 = sr1.budget
               LET sr.month_p8 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o8 = sr.month_p8 - sr.month_b8
            WHEN 9
               LET sr.month_b9 = sr1.budget
               LET sr.month_p9 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o9 = sr.month_p9 - sr.month_b9
            WHEN 10
               LET sr.month_b10 = sr1.budget
               LET sr.month_p10 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o10 = sr.month_p10 - sr.month_b10
            WHEN 11
               LET sr.month_b11 = sr1.budget
               LET sr.month_p11 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o11 = sr.month_p11 - sr.month_b11
            WHEN 12
               LET sr.month_b12 = sr1.budget
               LET sr.month_p12 = p_calc(sr.prono,sr.subno,sr.depno,tm.yy,sr1.mon)
               LET sr.month_o12 = sr.month_p12 - sr.month_b12
         END CASE
         INITIALIZE sr1.* TO NULL
      END FOREACH
      LET sr.sum_b = sr.month_b1 + sr.month_b2 + sr.month_b3 + sr.month_b4 +
                     sr.month_b5 + sr.month_b6 + sr.month_b7 + sr.month_b8 +
                     sr.month_b9 + sr.month_b10 + sr.month_b11 + sr.month_b12
      LET sr.sum_p = sr.month_p1 + sr.month_p2 + sr.month_p3 + sr.month_p4 +
                     sr.month_p5 + sr.month_p6 + sr.month_p7 + sr.month_p8 +
                     sr.month_p9 + sr.month_p10 + sr.month_p11 + sr.month_p12
      LET sr.sum_o = sr.month_o1 + sr.month_o2 + sr.month_o3 + sr.month_o4 +
                     sr.month_o5 + sr.month_o6 + sr.month_o7 + sr.month_o8 +
                     sr.month_o9 + sr.month_o10 + sr.month_o11 + sr.month_o12
      INSERT INTO aglq600_tmp VALUES (sr.*)
      INITIALIZE sr.* TO NULL
   END FOREACH
   LET l_sql2 = "SELECT '998'",g_sel CLIPPED,",sum(month_b1),sum(month_p1),",
                   "sum(month_o1),sum(month_b2),sum(month_p2),sum(month_o2),",
                   "sum(month_b3),sum(month_p3),sum(month_o3),sum(month_b4),",
                   "sum(month_p4),sum(month_o4),sum(month_b5),sum(month_p5),",
                   "sum(month_o5),sum(month_b6),sum(month_p6),sum(month_o6),",
                   "sum(month_b7),sum(month_p7),sum(month_o7),sum(month_b8),",
                   "sum(month_p8),sum(month_o8),sum(month_b9),sum(month_p9),",
                   "sum(month_o9),sum(month_b10),sum(month_p10),",
                   "sum(month_o10),sum(month_b11),sum(month_p11),",
                   "sum(month_o11),sum(month_b12),sum(month_p12),",
                   "sum(month_o12),sum(sum_b),sum(sum_p),sum(sum_o)",
                   " FROM aglq600_tmp",g_grp CLIPPED
   PREPARE aglq600_c2 FROM l_sql2
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('aglq600_c',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE aglq600_cs2 CURSOR FOR aglq600_c2
   FOREACH aglq600_cs2 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('aglq600_cs2 foreach:',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      INSERT INTO aglq600_tmp VALUES (sr.*) 
      INITIALIZE sr.* TO NULL
   END FOREACH
   SELECT COUNT(*) INTO g_str FROM aglq600_tmp
   IF g_str > 0 THEN
      LET l_sql4 = "SELECT '999'",g_sum CLIPPED,",sum(month_b1),sum(month_p1),",
                   "sum(month_o1),sum(month_b2),sum(month_p2),sum(month_o2),",
                   "sum(month_b3),sum(month_p3),sum(month_o3),sum(month_b4),",
                   "sum(month_p4),sum(month_o4),sum(month_b5),sum(month_p5),",
                   "sum(month_o5),sum(month_b6),sum(month_p6),sum(month_o6),",
                   "sum(month_b7),sum(month_p7),sum(month_o7),sum(month_b8),",
                   "sum(month_p8),sum(month_o8),sum(month_b9),sum(month_p9),",
                   "sum(month_o9),sum(month_b10),sum(month_p10),",
                   "sum(month_o10),sum(month_b11),sum(month_p11),",
                   "sum(month_o11),sum(month_b12),sum(month_p12),",
                   "sum(month_o12),sum(sum_b),sum(sum_p),sum(sum_o)",
                   " FROM aglq600_tmp",
                   " WHERE item = '111'"
      PREPARE aglq600_c4 FROM l_sql4
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('aglq600_c4',SQLCA.sqlcode,1)
         RETURN
      END IF
      DECLARE aglq600_cs4 CURSOR FOR aglq600_c4
      FOREACH aglq600_cs4 INTO sr.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('aglq600_cs2 foreach:',SQLCA.sqlcode,0) 
            EXIT FOREACH
         END IF
         INSERT INTO aglq600_tmp VALUES (sr.*)
         INITIALIZE sr.* TO NULL
      END FOREACH
   END IF                
   LET g_sql = "SELECT * FROM aglq600_tmp WHERE item = '998' OR item = '999'",
                g_ord CLIPPED
   PREPARE aglq600_c3 FROM g_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('aglq600_c',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE aglq600_cs3 CURSOR FOR aglq600_c3
   FOREACH aglq600_cs3 INTO g_omb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('aglq600_cs3 foreach:',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF  g_cnt > g_max_rec  THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF 
   END FOREACH
   CALL g_omb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   
   
   CLOSE aglq600_cs
   CLOSE aglq600_cs1
   CLOSE aglq600_cs2
   CLOSE aglq600_cs3
   CLOSE aglq600_cs4
END FUNCTION

FUNCTION p_calc(p_prono,p_subno,p_depno,p_yy,p_mon)

   DEFINE p_prono      LIKE afb_file.afb01
   DEFINE p_subno      LIKE afb_file.afb02
   DEFINE p_depno      LIKE afb_file.afb041
   DEFINE p_yy         LIKE type_file.chr4
   DEFINE p_mon        LIKE type_file.chr2
   DEFINE l_pre        LIKE abb_file.abb07
   DEFINE l_pre1       LIKE abb_file.abb07
   DEFINE l_pre2       LIKE abb_file.abb07
   DEFINE l_com        LIKE type_file.chr1
   DEFINE l_sql_pre    LIKE type_file.chr1000
   DEFINE l_sql_pre1   LIKE type_file.chr1000
   DEFINE l_sql_pre2   LIKE type_file.chr1000
   LET l_pre  = 0
   LET l_pre1 = 0
   LET l_pre2 = 0
   LET l_sql_pre = "SELECT sum(abb07) FROM abb_file,aba_file",
                    " WHERE aba00 = abb00 AND aba01 = abb01",
                    " AND abb07 IS NOT NULL",
                    " AND aba06 <> 'CE' ",  #20110209 ADD
                    " AND aba01 NOT IN (SELECT nppglno FROM npp_file WHERE nppsys ='CA' AND npp00 =8 AND npp011 =1 and nppglno is not null) ",  #MOD-D60170
                    " AND aba03 = '",p_yy,"' AND abb03 = '",p_subno,"'",
                    " AND abb05 = '",p_depno,"' AND aba04 = '",p_mon,"'"
   IF  tm.confirm = 'Y' THEN
      LET l_sql_pre = l_sql_pre CLIPPED," AND aba19 = 'Y'"
   END IF      
   IF  tm.post = 'Y' THEN
      LET l_sql_pre = l_sql_pre CLIPPED," AND abapost = 'Y'"
   END IF
   LET  l_sql_pre1 = l_sql_pre CLIPPED," AND abb06 = '1'"
   LET  l_sql_pre2 = l_sql_pre CLIPPED," AND abb06 = '2'"
   PREPARE pre1 FROM l_sql_pre1
   EXECUTE pre1 INTO l_pre1 
   PREPARE pre2 FROM l_sql_pre2
   EXECUTE pre2 INTO l_pre2
   IF cl_null(l_pre1) THEN LET l_pre1 = 0 END IF
   IF cl_null(l_pre2) THEN LET l_pre2 = 0 END IF
   SELECT DISTINCT aag06 INTO l_com FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = p_subno
   CASE l_com
      WHEN 1
         LET l_pre = l_pre1 - l_pre2
      WHEN 2
         LET l_pre = l_pre2 - l_pre1
   END CASE
   RETURN l_pre

END FUNCTION

FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         DISPLAY g_rec_b TO FORMONLY.cnt
         CALL q600_bp_refresh()

      ON ACTION query
         LET g_action_choice="query"
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

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION aglq600_show()

   CALL cl_show_fld_cont()
   
END FUNCTION

FUNCTION q600_set_visible()

   DEFINE  l_number   LIKE type_file.num5
   DEFINE  l_number1  LIKE type_file.num5
   DEFINE  l_number2  LIKE type_file.num5
   CALL cl_set_comp_visible("item",FALSE)
   CALL cl_set_comp_visible("prono",FALSE)
   CALL cl_set_comp_visible("subno",FALSE)
   CALL cl_set_comp_visible("depno",FALSE)
###-FUN-B40025- ADD - BEGIN -----------------------------------------------------------------
   CALL cl_set_comp_visible("month_b1,month_b2,month_b3,month_b4,month_b5,month_b6,",TRUE)
   CALL cl_set_comp_visible("month_b7,month_b8,month_b9,month_b10,month_b11,month_b12,",TRUE)
   CALL cl_set_comp_visible("month_o1,month_o2,month_o3,month_o4,month_o5,month_o6,",TRUE)
   CALL cl_set_comp_visible("month_o7,month_o8,month_o9,month_o10,month_o11,month_o12,",TRUE)
   CALL cl_set_comp_visible("month_p1,month_p2,month_p3,month_p4,month_p5,month_p6,",TRUE)
   CALL cl_set_comp_visible("month_p7,month_p8,month_p9,month_p10,month_p11,month_p12,",TRUE)
###-FUN-B40025- ADD -  END  -----------------------------------------------------------------
   LET l_number1 = tm.mon1 - 1
   LET l_number2 = tm.mon2 + 1
   IF tm.mon1 ! = 1 THEN
      FOR l_number = 1 TO l_number1 STEP 1
         CALL q600_set_comp_visible(l_number)
      END FOR
   END IF
   IF tm.mon2 ! = 12 THEN
      FOR l_number = 12 TO l_number2 STEP -1
         CALL q600_set_comp_visible(l_number)
      END FOR
   END IF
END FUNCTION

FUNCTION q600_set_comp_visible(p_number)
   DEFINE p_number   LIKE type_file.num5
      IF p_number = 1 THEN
         CALL cl_set_comp_visible("month_b1",FALSE)
         CALL cl_set_comp_visible("month_p1",FALSE)
         CALL cl_set_comp_visible("month_o1",FALSE)
      END IF
      IF p_number = 2 THEN
         CALL cl_set_comp_visible("month_b2",FALSE)
         CALL cl_set_comp_visible("month_p2",FALSE)
         CALL cl_set_comp_visible("month_o2",FALSE)
      END IF
      IF p_number = 3 THEN
         CALL cl_set_comp_visible("month_b3",FALSE)
         CALL cl_set_comp_visible("month_p3",FALSE)
         CALL cl_set_comp_visible("month_o3",FALSE)
      END IF
      IF p_number = 4 THEN
         CALL cl_set_comp_visible("month_b4",FALSE)
         CALL cl_set_comp_visible("month_p4",FALSE)
         CALL cl_set_comp_visible("month_o4",FALSE)
      END IF
      IF p_number = 5 THEN
         CALL cl_set_comp_visible("month_b5",FALSE)
         CALL cl_set_comp_visible("month_p5",FALSE)
         CALL cl_set_comp_visible("month_o5",FALSE)
      END IF
      IF p_number = 6 THEN
         CALL cl_set_comp_visible("month_b6",FALSE)
         CALL cl_set_comp_visible("month_p6",FALSE)
         CALL cl_set_comp_visible("month_o6",FALSE)
      END IF
      IF p_number = 7 THEN
         CALL cl_set_comp_visible("month_b7",FALSE)
         CALL cl_set_comp_visible("month_p7",FALSE)
         CALL cl_set_comp_visible("month_o7",FALSE)
      END IF
      IF p_number = 8 THEN
         CALL cl_set_comp_visible("month_b8",FALSE)
         CALL cl_set_comp_visible("month_p8",FALSE)
         CALL cl_set_comp_visible("month_o8",FALSE)
      END IF
      IF p_number = 9 THEN
         CALL cl_set_comp_visible("month_b9",FALSE)
         CALL cl_set_comp_visible("month_p9",FALSE)
         CALL cl_set_comp_visible("month_o9",FALSE)
      END IF
      IF p_number = 10 THEN
         CALL cl_set_comp_visible("month_b10",FALSE)
         CALL cl_set_comp_visible("month_p10",FALSE)
         CALL cl_set_comp_visible("month_o10",FALSE)
      END IF
      IF p_number = 11 THEN
         CALL cl_set_comp_visible("month_b11",FALSE)
         CALL cl_set_comp_visible("month_p11",FALSE)
         CALL cl_set_comp_visible("month_o11",FALSE)
      END IF
      IF p_number = 12 THEN
         CALL cl_set_comp_visible("month_b12",FALSE)
         CALL cl_set_comp_visible("month_p12",FALSE)
         CALL cl_set_comp_visible("month_o12",FALSE)
      END IF
END FUNCTION

FUNCTION q600_set_str()
DEFINE  l_msg  STRING
   LET l_msg = cl_getmsg('agl-261',g_lang)

   IF tm1.project = 'Y' AND tm1.subject = 'Y' AND tm1.depart = 'Y' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      LET g_sel = ",prono,proname,subno,subname,depno,depname"
      LET g_grp = " GROUP BY '998',prono,proname,subno,subname,depno,depname"
      LET g_ord = " ORDER BY prono,subno,depno,item"
      LET g_sum = ",'','",l_msg CLIPPED,"','','','',''"
   END IF
   IF tm1.project = 'Y' AND tm1.subject = 'Y' AND tm1.depart = 'N' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("depno,depname",FALSE)
      LET g_sel = ",prono,proname,subno,subname,'',''"
      LET g_grp = " GROUP BY '998',prono,proname,subno,subname"
      LET g_ord = " ORDER BY prono,subno,item"
      LET g_sum = ",'','",l_msg CLIPPED,"','','','',''"
   END IF
   IF tm1.project = 'Y' AND tm1.subject = 'N' AND tm1.depart = 'Y' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("subno,subname",FALSE)
      LET g_sel = ",prono,proname,'','',depno,depname"
      LET g_grp = " GROUP BY '998',prono,proname,depno,depname"
      LET g_ord = " ORDER BY prono,depno,item"
      LET g_sum = ",'','",l_msg CLIPPED,"','','','',''"
   END IF
   IF tm1.project = 'N' AND tm1.subject = 'Y' AND tm1.depart = 'Y' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("prono,proname",FALSE)
      LET g_sel = ",'','',subno,subname,depno,depname"
      LET g_grp = " GROUP BY '998',subno,subname,depno,depname"
      LET g_ord = " ORDER BY subno,depno,item"
      LET g_sum = ",'','','','",l_msg CLIPPED,"','',''"
   END IF
   IF tm1.project = 'Y' AND tm1.subject = 'N' AND tm1.depart = 'N' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("subno,subname",FALSE)
      CALL cl_set_comp_visible("depno,depname",FALSE)
      LET g_sel = ",prono,proname,'','','',''"
      LET g_grp = " GROUP BY '998',prono,proname"
      LET g_ord = " ORDER BY prono,item"
      LET g_sum = ",'','",l_msg CLIPPED,"','','','',''"
   END IF
   IF tm1.project = 'N' AND tm1.subject = 'Y' AND tm1.depart = 'N' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("depno,depname",FALSE)
      CALL cl_set_comp_visible("prono,proname",FALSE)
      LET g_sel = ",'','',subno,subname,'',''"
      LET g_grp = " GROUP BY '998',subno,subname"
      LET g_ord = " ORDER BY subno,item"
      LET g_sum = ",'','','','",l_msg CLIPPED,"','',''"
   END IF
   IF tm1.project = 'N' AND tm1.subject = 'N' AND tm1.depart = 'Y' THEN
      CALL cl_set_comp_visible("proname,depname,subname",TRUE)  #FUN-B40025 ADD
      CALL cl_set_comp_visible("prono,proname",FALSE)
      CALL cl_set_comp_visible("subno,subname",FALSE)
      LET g_sel = ",'','','','',depno,depname"
      LET g_grp = " GROUP BY '998',depno,depname"
      LET g_ord = " ORDER BY depno,item"
      LET g_sum = ",'','','','','','",l_msg CLIPPED,"'"
   END IF

END FUNCTION

FUNCTION q600_bp_refresh()

    DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

       BEFORE DISPLAY
          EXIT DISPLAY
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
          
    END DISPLAY

END FUNCTION
#FUN-AC0053
