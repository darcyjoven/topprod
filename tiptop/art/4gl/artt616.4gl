# Prog. Version..: '5.30.06-13.04.09(00008)'     #
#
# Pattern name...: artt616.4gl
# Descriptions...: 終止結算維護作業
# Date & Author..: No:FUN-BB0117 11/11/23 By nanbing
# Modify.........: No:FUN-BB0117 11/12/22 By shi 重要逻辑重新整理
# Modify.........: No:FUN-C20079 12/02/14 By xumeimei 客戶簡稱從occ_file表中抓取
# Modify.........: No:TQC-C30106 12/03/06 By yangxf 如果结算类型是1商户摊位，抓费用单时，加一个合同租赁期的条件
# Modify.........: No:TQC-C30340 12/04/01 By fanbj 修改帶出部門編號
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0076 12/12/11 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-C80041 13/01/21 By bart 排除作廢
# Modify.........: No:CHI-D20015 13/03/36 By minpp 修改审核人员，审核日期为审核异动人员，审核异动日期,取消审核给值

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE   g_luq     RECORD LIKE luq_file.*      
DEFINE   g_luq_t   RECORD LIKE luq_file.*   
DEFINE   g_luq_o   RECORD LIKE luq_file.*     #TQC-C30340 add
DEFINE   g_lur     DYNAMIC ARRAY OF RECORD
                   lur02      LIKE lur_file.lur02, 
                   lur03      LIKE lur_file.lur03,
                   lur04      LIKE lur_file.lur04,
                   lur05      LIKE lur_file.lur05,
                   oaj02      LIKE oaj_file.oaj02,
                   lur06      LIKE lur_file.lur06,
                   lur07      LIKE lur_file.lur07,
                   lur08      LIKE lur_file.lur08,
                   amt        LIKE lur_file.lur08,
                   oaj04      LIKE oaj_file.oaj04,
                   aag02      LIKE aag_file.aag02,
                   oaj041     LIKE oaj_file.oaj041, 
                   aag02_1    LIKE aag_file.aag02
                   END RECORD
DEFINE   g_lur_t  RECORD
                   lur02      LIKE lur_file.lur02, 
                   lur03      LIKE lur_file.lur03,
                   lur04      LIKE lur_file.lur04,
                   lur05      LIKE lur_file.lur05,
                   oaj02      LIKE oaj_file.oaj02,
                   lur06      LIKE lur_file.lur06,
                   lur07      LIKE lur_file.lur07,
                   lur08      LIKE lur_file.lur08,
                   amt        LIKE lur_file.lur08,
                   oaj04      LIKE oaj_file.oaj04,
                   aag02      LIKE aag_file.aag02,
                   oaj041     LIKE oaj_file.oaj041, 
                   aag02_1    LIKE aag_file.aag02
                   END RECORD
DEFINE   g_lus    DYNAMIC ARRAY OF RECORD
                   lus02      LIKE lus_file.lus02,    
                   lus03      LIKE lus_file.lus03, 
                   oaj02_1    LIKE oaj_file.oaj02,
                   lus04      LIKE lus_file.lus04,
                   lus05      LIKE lus_file.lus05,
                   lus06      LIKE lus_file.lus06,
                   amt_1      LIKE lus_file.lus06,
                   oaj04_1    LIKE oaj_file.oaj04,
                   aag02_2    LIKE aag_file.aag02,
                   oaj041_1   LIKE oaj_file.oaj041, 
                   aag02_3    LIKE aag_file.aag02
                   END RECORD
DEFINE   g_lus_t   RECORD
                   lus02      LIKE lus_file.lus02,    
                   lus03      LIKE lus_file.lus03, 
                   oaj02_1    LIKE oaj_file.oaj02,
                   lus04      LIKE lus_file.lus04,
                   lus05      LIKE lus_file.lus05,
                   lus06      LIKE lus_file.lus06,
                   amt_1      LIKE lus_file.lus06,
                   oaj04_1    LIKE oaj_file.oaj04,
                   aag02_2    LIKE aag_file.aag02,
                   oaj041_1   LIKE oaj_file.oaj041, 
                   aag02_3    LIKE aag_file.aag02
                   END RECORD                   
           
DEFINE   g_rec_b1  LIKE type_file.num5
DEFINE   g_rec_b2  LIKE type_file.num5
DEFINE   g_wc,g_wc2,g_wc3       STRING
DEFINE   g_sql                STRING
DEFINE   g_forupd_sql        STRING
DEFINE   g_chr                LIKE type_file.chr1     
DEFINE   g_cnt                LIKE type_file.num10    
DEFINE   g_i                  LIKE type_file.num5     
DEFINE   g_msg                LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_row_count          LIKE type_file.num10
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_jump               LIKE type_file.num10
DEFINE   g_no_ask             LIKE type_file.num5  
DEFINE   g_confirm            LIKE type_file.chr1
DEFINE   g_void               LIKE type_file.chr1    
DEFINE   g_t1                 LIKE oay_file.oayslip
DEFINE   li_result            LIKE type_file.num5
DEFINE   g_luq01_t            LIKE luq_file.luq01
DEFINE   g_flag_b             LIKE type_file.chr1
DEFINE   l_ac1,l_ac2,l_ac     LIKE type_file.num5
DEFINE   g_time               LIKE luq_file.luqcont
#DEFINE   g_lla04              LIKE lla_file.lla04
DEFINE   g_luc01              LIKE luc_file.luc01
DEFINE   g_dd                 LIKE luc_file.luc07
#FUN-CB0076----add---str
DEFINE l_table           STRING
DEFINE l_table1          STRING
TYPE sr1_t RECORD
     luqplant  LIKE luq_file.luqplant,
     luq01     LIKE luq_file.luq01,
     luq04     LIKE luq_file.luq04,
     luq05     LIKE luq_file.luq05,
     luq02     LIKE luq_file.luq02,
     luq06     LIKE luq_file.luq06,
     luqcond   LIKE luq_file.luqcond,
     luqcont   LIKE luq_file.luqcont,
     luqconu   LIKE luq_file.luqconu,
     luq07     LIKE luq_file.luq07,
     luq09     LIKE luq_file.luq09,
     lur02     LIKE lur_file.lur02,
     lur03     LIKE lur_file.lur03,
     lur04     LIKE lur_file.lur04,
     lur05     LIKE lur_file.lur05,
     lur06     LIKE lur_file.lur06,
     lur07     LIKE lur_file.lur07,
     lur08     LIKE lur_file.lur08,
     sign_type LIKE type_file.chr1,
     sign_img  LIKE type_file.blob,
     sign_show LIKE type_file.chr1,
     sign_str  LIKE type_file.chr1000,
     rtz13     LIKE rtz_file.rtz13,
     occ02     LIKE occ_file.occ02,
     gen02     LIKE gen_file.gen02,
     amt1      LIKE type_file.num20
END RECORD
TYPE sr2_t RECORD
     lus01     LIKE lus_file.lus01,
     lus02     LIKE lus_file.lus02,
     lus03     LIKE lus_file.lus03,
     lus04     LIKE lus_file.lus04,
     lus05     LIKE lus_file.lus05,
     lus06     LIKE lus_file.lus06,
     amt2      LIKE type_file.num20
END RECORD
#FUN-CB0076----add---end
MAIN 
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="luqplant.luq_file.luqplant,",
              "luq01.luq_file.luq01,",
              "luq04.luq_file.luq04,",
              "luq05.luq_file.luq05,",
              "luq02.luq_file.luq02,",
              "luq06.luq_file.luq06,",
              "luqcond.luq_file.luqcond,",
              "luqcont.luq_file.luqcont,",
              "luqconu.luq_file.luqconu,",
              "luq07.luq_file.luq07,",
              "luq09.luq_file.luq09,",
              "lur02.lur_file.lur02,",
              "lur03.lur_file.lur03,",
              "lur04.lur_file.lur04,",
              "lur05.lur_file.lur05,",
              "lur06.lur_file.lur06,",
              "lur07.lur_file.lur07,",
              "lur08.lur_file.lur08,",
              "sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000,",
              "rtz13.rtz_file.rtz13,",
              "occ02.occ_file.occ02,",
              "gen02.gen_file.gen02,",
              "amt1.type_file.num20"
   LET l_table = cl_prt_temptable('artt616',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   LET g_sql ="lus01.lus_file.lus01,",
              "lus02.lus_file.lus02,",
              "lus03.lus_file.lus03,",
              "lus04.lus_file.lus04,",
              "lus05.lus_file.lus05,",
              "lus06.lus_file.lus06,",
              "amt2.type_file.num20"
   LET l_table1 = cl_prt_temptable('artt6161',g_sql) CLIPPED
   IF l_table1 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end 
 
   LET g_forupd_sql= " SELECT * FROM luq_file WHERE luq01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t616_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t616_w  WITH FORM "art/42f/artt616"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_ui_init()
#   SELECT lla04 INTO g_lla04 FROM lla_file
#    WHERE llastore = g_plant
   IF g_aza.aza63 <> 'Y' THEN 
      CALL cl_set_comp_visible("oaj041,aag02_1",FALSE) 
      CALL cl_set_comp_visible("oaj041_1,aag02_3",FALSE) 
   END IF 
   CALL t616_menu()
 
   CLOSE WINDOW t616_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-CB0076 add
END MAIN
FUNCTION t616_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   
   CLEAR FORM
   CALL g_lur.clear()
   CALL g_lus.clear()
   LET g_action_choice=" " 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_luq.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED) 
      CONSTRUCT BY NAME g_wc ON
                luq01,luq02,luq03,luqplant,luqlegal,luq04,luq05,luq06,luq07,luq08,
                luq09,luq10,luq11,luq12,luqmksg,luq14,luqconf,luqconu,luqcond,
                luqcont,luq13,luquser,luqgrup,luqoriu,luqmodu,luqdate,luqorig,luqacti,luqcrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE
            
               WHEN INFIELD(luq01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq01
                  NEXT FIELD luq01

               WHEN INFIELD(luqplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luqplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luqplant
                  NEXT FIELD luqplant
               WHEN INFIELD(luqlegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luqlegal"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luqlegal
                  NEXT FIELD luqlegal                  
               WHEN INFIELD(luq04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq04
                  NEXT FIELD luq04
               WHEN INFIELD(luq05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq05
                  NEXT FIELD luq05
               WHEN INFIELD(luq06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq06
                  NEXT FIELD luq06                 
 
               WHEN INFIELD(luq11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq11
                  NEXT FIELD luq14 
               WHEN INFIELD(luq12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luq12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luq12
                  NEXT FIELD luq15     
                    
               WHEN INFIELD(luqconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_luqconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO luqconu
                  NEXT FIELD luqconu   
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
      CONSTRUCT g_wc2 ON lur02,lur03,lur04,lur05,lur06,lur07,lur08
         FROM s_lur[1].lur02,s_lur[1].lur03,s_lur[1].lur04,s_lur[1].lur05,
              s_lur[1].lur06,s_lur[1].lur07,s_lur[1].lur08
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE 
               WHEN INFIELD(lur03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lur03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lur03
                  NEXT FIELD lur03
               WHEN INFIELD(lur05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lur05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lur05
                  NEXT FIELD lur05   
               OTHERWISE EXIT CASE
            END CASE
      
       END CONSTRUCT

       CONSTRUCT g_wc3 ON lus02,lus03,lus04,lus05,lus06
          FROM s_lus[1].lus02,s_lus[1].lus03,s_lus[1].lus04,
               s_lus[1].lus05,s_lus[1].lus06
             
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          ON ACTION controlp
             CASE 
                WHEN INFIELD(lus03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lus03"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lus03
                   NEXT FIELD lus03
                   OTHERWISE EXIT CASE
             END CASE
      
       END CONSTRUCT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
       ON ACTION about
          CALL cl_about()
     
       ON ACTION HELP
          CALL cl_show_help()
     
       ON ACTION controlg
          CALL cl_cmdask()
       ON ACTION EXIT
          LET g_action_choice="exit"
          EXIT DIALOG
       ON ACTION accept
          ACCEPT DIALOG
       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DIALOG     
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END DIALOG
      IF INT_FLAG THEN
         RETURN
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('luquser', 'luqgrup') 
      LET g_wc = g_wc CLIPPED," AND luqplant IN ",g_auth 
      IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
         LET g_sql = "SELECT luq01 FROM luq_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY luq01"
      END IF 
      IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN  
         LET g_sql = "SELECT UNIQUE luq01 ",
                     " FROM luq_file, lur_file ",
                     " WHERE luq01 = lur01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY luq01"
      END IF                
      IF g_wc3 <> " 1=1" AND g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT UNIQUE luq01 ",
                     " FROM luq_file, lus_file ",
                     " WHERE luq01 = lus01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY luq01"                         
      END IF 
      IF g_wc3 <> " 1=1" AND g_wc2 <> " 1=1" THEN
         LET g_sql = "SELECT UNIQUE luq01 ",
                     " FROM luq_file, lur_file, lus_file ",
                     " WHERE luq01 = lur01 AND luq01 = lus01 AND lur01 = lus01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY luq01"     
      END IF

   PREPARE t616_prepare FROM g_sql
   DECLARE t616_cs
      SCROLL CURSOR WITH HOLD FOR t616_prepare
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM luq_file WHERE ",g_wc CLIPPED
   ELSE
      IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT luq01)",
                   " FROM luq_file ,lur_file WHERE ",
                   " lur01=luq01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      IF g_wc3 <> " 1=1" AND g_wc2 = " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT luq01)",
                   " FROM luq_file,lus_file WHERE ",
                   " lus01=luq01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
      END IF
      IF g_wc3 <> " 1=1" AND g_wc2 <> " 1=1" THEN
         LET g_sql = "SELECT COUNT(DISTINCT luq01)",
                     " FROM luq_file, lur_file, lus_file ",
                     " WHERE luq01 = lur01 AND luq01 = lus01 AND lur01 = lus01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY luq01"     
      END IF      
   END IF
   PREPARE t616_precount FROM g_sql
   DECLARE t616_count CURSOR FOR t616_precount

END FUNCTION
 
FUNCTION t616_menu()

   WHILE TRUE
      CALL t616_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t616_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t616_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t616_r()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t616_x()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t616_u()
            END IF
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t616_out()
            END IF
         #FUN-CB0076------add----end
         WHEN "re_settlement"
            IF cl_chk_act_auth() THEN
               CALL t616_re_settlement('d')
            END IF   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t616_confirm()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t616_undoconfirm()
            END IF
         WHEN "refund"
            IF cl_chk_act_auth() THEN
               CALL t616_refund()
            END IF 
         WHEN "sel_refund"
            IF cl_chk_act_auth() THEN
               CALL t616_sel_refund()
            END IF 
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE
        
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lur),base.TypeInfo.create(g_lus),'')
            END IF   
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_luq.luq01 IS NOT NULL THEN
                 LET g_doc.column1 = "luq01"
                 LET g_doc.value1 = g_luq.luq01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t616_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lur TO s_lur.* ATTRIBUTE(COUNT=g_rec_b1)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac1 = ARR_CURR()
           DISPLAY g_rec_b1 TO FORMONLY.cn1
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_lus TO s_lus.* ATTRIBUTE(COUNT=g_rec_b2)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac2 = ARR_CURR()
           DISPLAY g_rec_b2 TO FORMONLY.cn1
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
      #FUN-CB0076------add-----str
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DIALOG
      #FUN-CB0076------add-----end
      ON ACTION FIRST
         CALL t616_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION PREVIOUS
         CALL t616_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t616_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION NEXT
         CALL t616_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION LAST
         CALL t616_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
      ON ACTION re_settlement
         LET g_action_choice="re_settlement"
         EXIT DIALOG 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG 

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 
     
      ON ACTION refund
         LET g_action_choice="refund"
         EXIT DIALOG 
      ON ACTION sel_refund
         LET g_action_choice="sel_refund"
         EXIT DIALOG 
      
   
    #  ON ACTION change_export
    #     LET g_action_choice="change_export"
    #     EXIT DIALOG 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
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


      ON ACTION CANCEL
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

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t616_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_lur.clear()
   CALL g_lus.clear()
   INITIALIZE g_luq.* LIKE luq_file.*
   LET g_luq01_t = NULL
   LET g_luq_t.* = g_luq.*
   LET g_luq_o.* = g_luq.*      #TQC-C30340 add
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_luq.luq02 = g_today
       LET g_luq.luqplant = g_plant
       LET g_luq.luqlegal = g_legal
       LET g_luq.luqconf = 'N'
       LET g_luq.luq14 = '0'
       LET g_luq.luquser = g_user
       LET g_luq.luqoriu = g_user 
       LET g_luq.luqorig = g_grup 
       LET g_luq.luqgrup = g_grup
       LET g_luq.luqmodu = ''
       #LET g_luq.luqmksg = 'N'
       LET g_luq.luqdate = g_today 
       LET g_luq.luqacti = 'Y'
       LET g_luq.luqcrat = g_today
       LET g_luq.luq11 = g_user
       LET g_luq.luq12 = g_grup     
       CALL t616_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           INITIALIZE g_luq.* TO NULL 
           CALL g_lur.clear()
           CALL g_lus.clear()
           EXIT WHILE
       END IF
       IF g_luq.luq01 IS NULL OR g_luq.luqplant IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
       CALL s_auto_assign_no("art",g_luq.luq01,g_today,"B5","luq_file","luq01","","","")
          RETURNING li_result,g_luq.luq01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_luq.luq01
       
       INSERT INTO luq_file VALUES(g_luq.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","luq_file",g_luq.luq01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
       END IF
       LET g_luq_t.* = g_luq.*     #TQC-C30340 add
       LET g_luq_o.* = g_luq.*     #TQC-C30340 add
       LET g_rec_b1=0
       LET g_rec_b2=0
       #自動產生單身
       LET g_luq01_t = g_luq.luq01
       CALL t616_re_settlement('a')
       CALL t616_b1_fill(" 1=1")
       CALL t616_b2_fill(" 1=1")
       LET g_luq01_t = NULL
      #CALL t616_delall()
       EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t616_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_luq.luq01 IS NULL OR g_luq.luqplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_luq.* FROM luq_file WHERE luq01 = g_luq.luq01
 
   IF g_luq.luqconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF   
   IF g_luq.luqacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF  
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_luq01_t = g_luq.luq01
   LET g_luq_t.* = g_luq.*
   LET g_luq_o.* = g_luq.*       #TQC-C30340 add
   BEGIN WORK
   OPEN t616_cl USING g_luq.luq01
   FETCH t616_cl INTO g_luq.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_luq.luq01,SQLCA.SQLCODE,0)
      CLOSE t616_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t616_show()
   WHILE TRUE
      LET g_luq01_t = g_luq.luq01
      LET g_luq.luqmodu=g_user
      LET g_luq.luqdate=g_today
      CALL t616_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_luq.*=g_luq_t.*
          CALL t616_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE luq_file SET luq_file.* = g_luq.* WHERE luq01 = g_luq01_t 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","luq_file",g_luq.luq01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t616_cl
   COMMIT WORK
   #重新產生單身
   CALL t616_re_settlement('u')
   CALL t616_b1_fill(" 1=1")
   CALL t616_b2_fill(" 1=1")
  #CALL t616_delall()
END FUNCTION
 
FUNCTION t616_i(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       li_result    LIKE type_file.num5,
       l_gen03      LIKE gen_file.gen03
   DISPLAY BY NAME
                g_luq.luq01,g_luq.luq02,g_luq.luq03,g_luq.luqplant,g_luq.luqlegal,
                g_luq.luq04,g_luq.luq05,g_luq.luq06,g_luq.luq07,g_luq.luq08,g_luq.luq09,
                g_luq.luq10,g_luq.luq11,g_luq.luq12,g_luq.luq13,g_luq.luq14,g_luq.luqmksg,
                g_luq.luqconf,g_luq.luqconu,g_luq.luqcond,g_luq.luqcont,g_luq.luquser,
                g_luq.luqgrup,g_luq.luqoriu,g_luq.luqmodu,g_luq.luqdate,g_luq.luqorig,
                g_luq.luqacti,g_luq.luqcrat        
      
   
   CALL t616_desc()
   INPUT BY NAME g_luq.luq01,g_luq.luq02,g_luq.luq03,g_luq.luq04,
                 g_luq.luq11,g_luq.luq12,g_luq.luq13  WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t616_set_entry(p_cmd)
           CALL t616_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("luq01")
           
       AFTER FIELD luq01
           IF NOT cl_null(g_luq.luq01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_luq.luq01!=g_luq_t.luq01) THEN
                 CALL s_check_no("art",g_luq.luq01,g_luq01_t,"B5","luq_file","luq01","")  
                    RETURNING li_result,g_luq.luq01
                 IF (NOT li_result) THEN                                                            
                    LET g_luq.luq01=g_luq_t.luq01                                                                 
                    NEXT FIELD luq01                                                                                      
                 END IF
                 LET g_t1=s_get_doc_no(g_luq.luq01)
                 SELECT oayapr INTO g_luq.luqmksg FROM oay_file WHERE oayslip = g_t1 
                 DISPLAY BY NAME g_luq.luqmksg
              END IF
           END IF
       AFTER FIELD luq02
          IF NOT cl_null(g_luq.luq02) THEN 
             CALL t616_luq02()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD luq02
             END IF                 
          END IF 
       AFTER FIELD luq04
          IF NOT cl_null(g_luq.luq04) THEN 
             CALL t616_luq04(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD luq04
             END IF                 
          END IF 
     
       AFTER FIELD luq11
          IF NOT cl_null(g_luq.luq11) THEN 
             CALL t616_luq11(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_luq.luq11 = g_luq_o.luq11    #TQC-C30340 add
                NEXT FIELD luq11
             END IF
          END IF
       AFTER FIELD luq12
          IF NOT cl_null(g_luq.luq12) THEN 
             CALL t616_luq12(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_luq.luq12 = g_luq_t.luq12     #TQC-C30340 add
                NEXT FIELD luq12
             END IF
          END IF           
       ON ACTION controlp
          CASE 
             WHEN INFIELD(luq01)
                LET g_t1=s_get_doc_no(g_luq.luq01)
                CALL q_oay(FALSE,FALSE,g_t1,'B5','ART') RETURNING g_t1  
                LET g_luq.luq01=g_t1               
                DISPLAY BY NAME g_luq.luq01       
                NEXT FIELD luq01  
             WHEN INFIELD(luq04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lnt01"
                LET g_qryparam.default1 = g_luq.luq04
                LET g_qryparam.where = " (lnt26 = 'E' OR lnt26 = 'S') ",
                                       " AND lntplant = '",g_plant ,"' "  
                CALL cl_create_qry() RETURNING g_luq.luq04
                DISPLAY BY NAME g_luq.luq04
                CALL t616_luq04(p_cmd)
             WHEN INFIELD(luq11) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_luq.luq11                
                CALL cl_create_qry() RETURNING g_luq.luq11
                DISPLAY BY NAME g_luq.luq11
                CALL t616_luq11(p_cmd)
             WHEN INFIELD(luq12) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.default1 = g_luq.luq12   
                CALL cl_create_qry() RETURNING g_luq.luq12
                DISPLAY BY NAME g_luq.luq12
                CALL t616_luq12(p_cmd)                    
                
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
 
       ON ACTION HELP
          CALL cl_show_help()
 
       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
   END INPUT
END FUNCTION
FUNCTION t616_luq02()
DEFINE l_sma53  LIKE sma_file.sma53 
   LET g_errno = ''
   SELECT sma53 INTO l_sma53 FROM sma_file
   IF l_sma53 > g_luq.luq02 THEN 
      LET g_errno = 'alm1203'
   END IF    
END FUNCTION
FUNCTION  t616_luq04(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,
       l_lnt26    LIKE lnt_file.lnt26,#確認碼
       l_lntacti  LIKE lnt_file.lntacti,#有效碼
       l_lnt06    LIKE lnt_file.lnt06,#攤位編號
       l_lnt04    LIKE lnt_file.lnt04, #商戶編號
       l_lntplant LIKE lnt_file.lntplant,
       l_n        LIKE type_file.num5
              
   LET g_errno = ''                                  
   SELECT lnt26,lntacti,lntplant INTO l_lnt26,l_lntacti,l_lntplant
     FROM lnt_file
    WHERE lnt01 = g_luq.luq04
      #AND lntplant = g_plant
   CASE 
      WHEN SQLCA.sqlcode = 100            LET g_errno = 'alm-132'
      WHEN l_lntacti = 'N'                LET g_errno = 'aec-090'
      WHEN l_lntplant <> g_plant          LET g_errno = 'alm1246' 
   END CASE
   IF (l_lnt26 NOT MATCHES '[ES]') THEN 
      LET g_errno = 'alm1245'
   END IF
   IF l_lnt26 = 'E' THEN 
      SELECT COUNT(*) INTO l_n FROM liw_file 
       WHERE liw01 = g_luq.luq04
         AND liw17 = 'N'
         AND liw16 IS NULL
      IF l_n > 0 THEN 
         LET g_errno = 'alm1254'
      END IF    
   END IF    
   IF cl_null(g_errno) AND p_cmd <> 'd' THEN
      SELECT lnt06,lnt04 INTO l_lnt06,l_lnt04
        FROM lnt_file WHERE lnt01 = g_luq.luq04
      LET g_luq.luq05 = l_lnt04 
      LET g_luq.luq06 = l_lnt06
      DISPLAY BY NAME g_luq.luq05,g_luq.luq06
      CALL t616_desc() 
   END IF     
END FUNCTION

FUNCTION t616_luq11(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gen02   LIKE gen_file.gen02,#員工姓名
       l_gen03   LIKE gen_file.gen03,#所屬部門
       l_gem02     LIKE gem_file.gem02,
       l_gemacti   LIKE gem_file.gemacti,
       l_genacti LIKE gen_file.genacti
   LET g_errno = ''  
   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_luq.luq11
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'art-241'
      WHEN l_genacti = 'N'       LET g_errno = '9028'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      #TQC-C30340--start add--------------------------------------
      IF cl_null(g_luq.luq12) OR (NOT cl_null(g_luq_o.luq11) AND g_luq.luq11 <> g_luq_o.luq11) 
         OR cl_null(g_luq_o.luq11) THEN     
         LET g_luq_o.luq11 = g_luq.luq11                                
         IF p_cmd <> 'd' THEN                                     
      #TQC-C30340--end add---------------------------------------- 
            SELECT gem02,gemacti INTO l_gem02,l_gemacti
              FROM gem_file
             WHERE gem01 = l_gen03
            LET g_luq.luq12 = l_gen03
            DISPLAY l_gem02 TO FORMONLY.gem02  
         END IF                                #TQC-C30340 add
      END IF                                   #TQC-C30340 add 
   END IF 
END FUNCTION 
FUNCTION t616_luq12(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,
       l_gem02     LIKE gem_file.gem02,
       l_gemacti   LIKE gem_file.gemacti,
       l_n         LIKE type_file.num5
   LET g_errno = ''  
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_luq.luq12
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'asf-624'
      WHEN l_gemacti = 'N'       LET g_errno = 'asf-624'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE    
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gem02 TO FORMONLY.gem02   
   END IF    
END FUNCTION 
FUNCTION t616_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_luq.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt    
   CALL t616_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      CLEAR FORM 
      INITIALIZE g_luq.* TO NULL
      CALL g_lur.clear()
      CALL g_lus.clear()
      LET g_wc2 = NULL
      LET g_wc3 = NULL
      LET g_luq01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t616_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_luq.* TO NULL
   ELSE
      OPEN t616_count
      FETCH t616_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t616_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
FUNCTION t616_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_luq.luq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_luq.luqconf = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 

   SELECT * INTO g_luq.* FROM luq_file
    WHERE luq01=g_luq.luq01
   BEGIN WORK

   OPEN t616_cl USING g_luq.luq01
   IF STATUS THEN
      CALL cl_err("OPEN t616_cl:", STATUS, 1)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t616_cl INTO g_luq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luq.luq01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t616_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "luq01"
       LET g_doc.value1 = g_luq.luq01
       CALL cl_del_doc()
      DELETE FROM luq_file WHERE luq01 = g_luq.luq01
      DELETE FROM lur_file WHERE lur01 = g_luq.luq01
      DELETE FROM lus_file WHERE lus01 = g_luq.luq01
      CLEAR FORM
      CALL g_lur.clear()
      CALL g_lus.clear()
      OPEN t616_count
      FETCH t616_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t616_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t616_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t616_fetch('/')
      END IF
   END IF

   CLOSE t616_cl
   COMMIT WORK
   CALL cl_flow_notify(g_luq.luq01,'D')
END FUNCTION 
FUNCTION t616_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_luq.luq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   IF g_luq.luqconf = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF 
   BEGIN WORK

   OPEN t616_cl USING g_luq.luq01
   IF STATUS THEN
      CALL cl_err("OPEN t616_cl:", STATUS, 1)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t616_cl INTO g_luq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luq.luq01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t616_show()

   IF cl_exp(0,0,g_luq.luqacti) THEN
      IF g_luq.luqacti='Y' THEN
         LET g_luq.luqacti='N'
      ELSE
         LET g_luq.luqacti='Y'
      END IF

      UPDATE luq_file SET luqacti=g_luq.luqacti,
                          luqmodu=g_user,
                          luqdate=g_today
       WHERE luq01=g_luq.luq01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","luq_file",g_luq.luq01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE t616_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_luq.luq01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   LET g_luq.luqmodu = g_user
   LET g_luq.luqdate=g_today
   DISPLAY BY NAME g_luq.luqacti,g_luq.luqmodu,
                   g_luq.luqdate
   CALL cl_set_field_pic(g_luq.luqconf,g_luq.luq14,"","","",g_luq.luqacti)
END FUNCTION

FUNCTION t616_fetch(p_flag)
DEFINE   p_flag   LIKE type_file.chr1
   CASE p_flag
      WHEN 'N' FETCH NEXT     t616_cs INTO g_luq.luq01
      WHEN 'P' FETCH PREVIOUS t616_cs INTO g_luq.luq01
      WHEN 'F' FETCH FIRST    t616_cs INTO g_luq.luq01
      WHEN 'L' FETCH LAST     t616_cs INTO g_luq.luq01
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
         FETCH ABSOLUTE g_jump t616_cs INTO g_luq.luq01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_luq.luq01,SQLCA.SQLCODE,0) 
      INITIALIZE g_luq.* TO NULL
      CALL g_lur.clear()
      CALL g_lus.clear()
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
   SELECT * INTO g_luq.* FROM luq_file WHERE  luq01 = g_luq.luq01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_luq.* TO NULL
      CALL g_lur.clear()
      CALL g_lus.clear()
      CALL cl_err3("sel","luq_file",g_luq.luq01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL t616_show()
END FUNCTION
 
FUNCTION t616_show()
DEFINE l_amt1  LIKE luq_file.luq07
DEFINE l_amt2  LIKE luq_file.luq09  
   LET g_luq_t.* = g_luq.*      #TQC-C30340 add
   LET g_luq_o.* = g_luq.*      #TQC-C30340 add

   DISPLAY BY NAME
                g_luq.luq01,g_luq.luq02,g_luq.luq03,g_luq.luqplant,g_luq.luqlegal,
                g_luq.luq04,g_luq.luq05,g_luq.luq06,g_luq.luq07,g_luq.luq08,g_luq.luq09,
                g_luq.luq10,g_luq.luq11,g_luq.luq12,g_luq.luq13,g_luq.luq14,
                g_luq.luqmksg,g_luq.luqconf,g_luq.luqconu,g_luq.luqcond,
                g_luq.luquser,g_luq.luqgrup,g_luq.luqoriu,g_luq.luqmodu,
                g_luq.luqdate,g_luq.luqorig,g_luq.luqacti,g_luq.luqcrat        
   LET l_amt1 = g_luq.luq07 - g_luq.luq08
   LET l_amt2 = g_luq.luq09 - g_luq.luq10
   DISPLAY l_amt1,l_amt2 TO FORMONLY.amt1,FORMONLY.amt2   
   CALL t616_desc()
   CALL cl_set_field_pic(g_luq.luqconf,g_luq.luq14,"","","",g_luq.luqacti)      
   CALL cl_show_fld_cont()
   CALL t616_b1_fill(g_wc2)
   CALL t616_b2_fill(g_wc3)
END FUNCTION

FUNCTION t616_b1_fill(p_wc2)
DEFINE p_wc2  STRING        
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--

    LET g_sql = "SELECT lur02,lur03,lur04,lur05,'',lur06,lur07,lur08,'','','','','' ",   
                " FROM lur_file",
                " WHERE lur01 = '", g_luq.luq01,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t616_pb FROM g_sql
    DECLARE t616_curs CURSOR FOR t616_pb
 
    CALL g_lur.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH t616_curs INTO g_lur[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       LET g_lur[g_cnt].amt = g_lur[g_cnt].lur07 - g_lur[g_cnt].lur08
       CALL s_get_bookno(YEAR(g_luq.luq02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add       
       SELECT oaj02,oaj04 INTO g_lur[g_cnt].oaj02,g_lur[g_cnt].oaj04
         FROM oaj_file
        WHERE oaj01 = g_lur[g_cnt].lur05
       SELECT aag02 INTO g_lur[g_cnt].aag02
         FROM aag_file WHERE aag01 = g_lur[g_cnt].oaj04 AND aag00=l_bookno1   #FUN-C10024 add "AND aag00=l_bookno1"       
       IF g_aza.aza63='Y' THEN
          SELECT oaj041 INTO g_lur[g_cnt].oaj041 
            FROM oaj_file WHERE oaj01 = g_lur[g_cnt].lur05 AND oajacti = 'Y'
          SELECT aag02 INTO g_lur[g_cnt].aag02_1
            FROM aag_file WHERE aag01 = g_lur[g_cnt].oaj041
             # AND aag00 = g_aza.aza81  #FUN-C10024 mark
             AND aag00 = l_bookno2   #FUN-C10024 add
       END IF

       ### 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lur.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1  
    DISPLAY g_rec_b1 TO FORMONLY.cn1
    LET g_cnt = 0
END FUNCTION                      
FUNCTION t616_b2_fill(p_wc2)         
DEFINE p_wc2            STRING
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--

    LET g_sql = "SELECT lus02,lus03,'',lus04,lus05,lus06,'','','','','' ",   
                " FROM lus_file",
                " WHERE lus01 = '", g_luq.luq01,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t616_pb1 FROM g_sql
    DECLARE t616_curs1 CURSOR FOR t616_pb1
 
    CALL g_lus.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH t616_curs1 INTO g_lus[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       LET g_lus[g_cnt].amt_1 = g_lus[g_cnt].lus05 - g_lus[g_cnt].lus06
       CALL s_get_bookno(YEAR(g_luq.luq02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
       SELECT oaj02,oaj04 INTO g_lus[g_cnt].oaj02_1,g_lus[g_cnt].oaj04_1
         FROM oaj_file
        WHERE oaj01 = g_lus[g_cnt].lus03 
       SELECT aag02 INTO g_lus[g_cnt].aag02_2
         FROM aag_file WHERE aag01 = g_lus[g_cnt].oaj04_1 AND aag00=l_bookno1 ##FUN-C10024 add "AND aag00=l_bookno1"        
       IF g_aza.aza63='Y' THEN
          SELECT oaj041 INTO g_lus[g_cnt].oaj041_1 
            FROM oaj_file WHERE oaj01 = g_lus[g_cnt].lus03
          SELECT aag02 INTO g_lus[g_cnt].aag02_3
            FROM aag_file WHERE aag01 = g_lus[g_cnt].oaj041_1 
             #AND aag00 = g_aza.aza81  FUN-C10024  mark
             AND aag00 = l_bookno2  #FUN-C10024 add
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lus.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1  
  #  DISPLAY g_rec_b2 TO FORMONLY.cn1
    LET g_cnt = 0
END FUNCTION 
                      
FUNCTION t616_desc()
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_azt02    LIKE azt_file.azt02
DEFINE l_lne05    LIKE lne_file.lne05
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_gem02    LIKE gem_file.gem02
DEFINE l_gen02_1  LIKE gen_file.gen02
DEFINE l_lmf13    LIKE lmf_file.lmf13
DEFINE l_oba02    LIKE oba_file.oba02
DEFINE l_tqa02    LIKE tqa_file.tqa02 
DEFINE l_lnt33    LIKE lnt_file.lnt33 #經營小類
DEFINE l_lnt30    LIKE lnt_file.lnt30 #主品牌
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_luq.luq11
   DISPLAY l_gen02 TO FORMONLY.gen02  
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_luq.luqplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_luq.luqlegal
   DISPLAY l_azt02 TO FORMONLY.azt02
   #SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = g_luq.luq05   #FUN-C20079 mark
   SELECT occ02 INTO l_lne05 FROM occ_file WHERE occ01 = g_luq.luq05    #FUN-C20079 add
   DISPLAY l_lne05 TO FORMONLY.luq05_desc
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_luq.luqconu
   DISPLAY l_gen02_1 TO FORMONLY.gen02_1
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_luq.luq12
   DISPLAY l_gem02 TO FORMONLY.gem02
   SELECT lmf13 INTO l_lmf13 FROM lmf_file
    WHERE lmf01 = g_luq.luq06
   DISPLAY l_lmf13 TO FORMONLY.lmf13
   SELECT lnt33,lnt30 INTO l_lnt33,l_lnt30 FROM lnt_file
    WHERE lnt01 = g_luq.luq04
   DISPLAY l_lnt33 TO FORMONLY.lnt33
   DISPLAY l_lnt30 TO FORMONLY.lnt30    
   SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lnt30 AND tqa03 = '2'
   DISPLAY l_tqa02  TO FORMONLY.tqa02
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = l_lnt33
   DISPLAY l_oba02  TO FORMONLY.oba02   
END FUNCTION 

FUNCTION t616_confirm()                       #審核
DEFINE l_gen02_1  LIKE gen_file.gen02

   IF cl_null(g_luq.luq01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
#CHI-C30107 --------- add ------------ begin
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF

   IF g_luq.luqacti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF

   IF g_luq.luqconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
      RETURN
   END IF
#CHI-C30107 --------- add ------------ end
   SELECT * INTO g_luq.* FROM luq_file WHERE luq01=g_luq.luq01
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
    
   IF g_luq.luqacti='N' THEN
      CALL cl_err('','alm-048',0)
      RETURN
   END IF
 
   IF g_luq.luqconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF

   #检查单身一的费用单
   CALL s_showmsg_init()
   LET g_success = 'Y'
   CALL t616_check()
   CALL s_showmsg()
   IF g_success = 'N' THEN RETURN END IF

   IF g_luq.luq09 < 0 THEN 
      CALL cl_err('','alm1240',0)
      RETURN
   END IF 
#CHI-C30107 -------- mark -------- begin
#  IF NOT cl_confirm('alm-006') THEN
#     RETURN
#  END IF
#CHI-C30107 -------- mark -------- end

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()

   OPEN t616_cl USING g_luq.luq01
   IF STATUS THEN
      CALL cl_err("OPEN t616_cl:", STATUS, 1)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t616_cl INTO g_luq.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_luq.luq01,SQLCA.sqlcode,0)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_time = TIME 
   UPDATE luq_file
      SET luqconf = 'Y',
          luqconu = g_user,
          luqcond = g_today,
          luqcont = g_time,
          luqmodu = g_user,
          luqdate = g_today,
          luq14   = '1'
    WHERE luq01 = g_luq.luq01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('luq01',g_luq.luq01,'upd luq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
      CALL t616_confirm_upd('1')
      IF g_success = 'Y' THEN 
         LET g_luq.luqconf = 'Y'
         LET g_luq.luqconu = g_user
         LET g_luq.luqcond = g_today
         LET g_luq.luqcont = TIME
         LET g_luq.luqmodu = g_user
         LET g_luq.luqdate = g_today
         LET g_luq.luq14   = '1'
         DISPLAY BY NAME g_luq.luqconf,g_luq.luqconu,g_luq.luqcond,g_luq.luqcont,
                      g_luq.luqmodu,g_luq.luqdate,g_luq.luq14
         SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_luq.luqconu
         DISPLAY l_gen02_1 TO gen02_1                   
         CALL cl_set_field_pic(g_luq.luqconf,g_luq.luq14,"","","",g_luq.luqacti)
      END IF          
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t616_undoconfirm()                     #取消審核
 DEFINE l_n  LIKE type_file.num5
 DEFINE l_gen02 LIKE gen_file.gen02     #CHI-D20015
   IF cl_null(g_luq.luq01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_luq.* FROM luq_file
    WHERE luq01=g_luq.luq01
   IF g_luq.luqplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF   
   IF g_luq.luqacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_luq.luqconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_luq.luq14='2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM luc_file
    WHERE luc11 = g_luq.luq01
   IF l_n > 0 THEN 
      CALL cl_err('','alm1247',0)
      RETURN 
   END IF     
   
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t616_cl USING g_luq.luq01
   IF STATUS THEN
      CALL cl_err("OPEN t616_cl:", STATUS, 1)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t616_cl INTO g_luq.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_luq.luq01,SQLCA.sqlcode,0)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   END IF

   LET g_time = TIME     #CHI-D20015 
   UPDATE luq_file SET luqconf = 'N',
                     #CHI-D20015----mod--str
                      #luqconu = '',
                      #luqcond = '',
                      #luqcont = '',
                       luqconu = g_user,
                       luqcond = g_today,
                       luqcont = g_time,
                      #CHI-D20015--mod--end
                       luq14 = '0',
                     luqmodu = g_user,luqdate = g_today
    WHERE luq01 = g_luq.luq01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('luq01',g_luq.luq01,'upd luq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
      CALL t616_confirm_upd('2')
      IF g_success = 'Y' THEN 
         LET g_luq.luqconf = 'N'
         #CHI-D20015----mod--str
       # LET g_luq.luqconu = ''
       # LET g_luq.luqcond = ''
       # LET g_luq.luqcont = ''
         LET g_luq.luqconu = g_user
         LET g_luq.luqcond = g_today
         LET g_luq.luqcont = g_time
         #CHI-D20015----mod--end
         LET g_luq.luq14 = '0'
         LET g_luq.luqmodu = g_user
         LET g_luq.luqdate = g_today
         DISPLAY BY NAME g_luq.luqconf,g_luq.luqconu,g_luq.luqcond,g_luq.luqcont,
                         g_luq.luq14,g_luq.luqmodu,g_luq.luqdate
        #DISPLAY '' TO gen02_1                                                 #CHI-D20015
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_luq.luqconu   #CHI-D20015
         DISPLAY l_gen02 TO gen02_1                                            #CHI-D20015
         CALL cl_set_field_pic(g_luq.luqconf,g_luq.luq14,"","","",g_luq.luqacti)
      END IF          
   END IF

   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE 
      COMMIT WORK    
   END IF 
END FUNCTION 

FUNCTION t616_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("luq01",TRUE)
    END IF

END FUNCTION

FUNCTION t616_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("luq01",FALSE)
    END IF

END FUNCTION 

FUNCTION t616_delall()
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5 
   LET l_cnt1 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM lur_file                                                                                   
       WHERE lur01=g_luq.luq01 AND lurplant = g_plant
   SELECT COUNT(*) INTO l_cnt2 FROM lus_file                                                                                   
       WHERE lus01=g_luq.luq01 AND lusplant = g_plant    
   IF l_cnt1=0 AND l_cnt2 = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM luq_file WHERE luq01 = g_luq.luq01 AND luqplant = g_plant
      INITIALIZE g_luq.* TO NULL
      CALL g_lur.clear()
      CALL g_lus.clear()
      CLEAR FORM
   END IF
END FUNCTION

#20111222 以下所有By shi重新整理
FUNCTION t616_ins_lur()
DEFINE l_lur     RECORD LIKE lur_file.*
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_lnt17   LIKE lnt_file.lnt17   #TQC-C30106 add
DEFINE l_lnt18   LIKE lnt_file.lnt18   #TQC-C30106 add

#TQC-C30106 add begin ---
   SELECT lnt17,lnt18 INTO l_lnt17,l_lnt18
     FROM lnt_file
    WHERE lnt01 = g_luq.luq04
#TQC-C30106 add end  ----
   #先抓取费用单新增到单身一
   #抓所有的费用单，不区分是否结案
   LET g_sql = "SELECT lua01,lub02,lub03,lub09,lub04t,lub11 ",
               "  FROM lua_file,lub_file",
               " WHERE lub01 = lua01"
   #           "   AND lub13 = 'N' "
   IF g_luq.luq03 = '1' THEN								
      LET g_sql = g_sql CLIPPED,"   AND lua06 = '",g_luq.luq05,"'", #商户								
                                "   AND lua07 = '",g_luq.luq06,"'"  #摊位								
                               ,"   AND (lua09 BETWEEN '",l_lnt17,"' AND '",l_lnt18,"')"                 #TQC-C30106 add                   
 
   END IF								
   IF g_luq.luq03 = '2' THEN								
      LET g_sql = g_sql CLIPPED,"   AND lua06 = '",g_luq.luq05,"'", #商户								
                                "   AND lua04 = '",g_luq.luq04,"'" #合同	
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lua01,lub02"
   PREPARE t616_1_prepare FROM g_sql                     #預備一下
   DECLARE lur_ins_cs CURSOR FOR t616_1_prepare
   LET l_cnt = 1
   FOREACH lur_ins_cs INTO l_lur.lur03,l_lur.lur04,l_lur.lur05,
                           l_lur.lur06,l_lur.lur07,l_lur.lur08
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','lur_ins_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
       
      LET l_lur.lur01 = g_luq.luq01
      LET l_lur.lur02 = l_cnt
      LET l_lur.lurlegal = g_luq.luqlegal
      LET l_lur.lurplant = g_luq.luqplant
      INSERT INTO lur_file VALUES l_lur.*
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('lur01',g_luq.luq01,'ins lur_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET l_cnt = l_cnt+1
   END FOREACH 
   #检查是否有未审核的费用单，交款单，支出单，退款单
   CALL t616_check()
   IF g_success = 'Y' THEN
      CALL t616_ins_lus()
   END IF
END FUNCTION 

FUNCTION t616_ins_lus()
DEFINE l_lus     RECORD LIKE lus_file.*
DEFINE l_cnt     LIKE type_file.num5

   LET g_sql = "SELECT lur05,lur06,SUM(lur07),SUM(lur08) ",
               "  FROM lur_file ",
               " WHERE lur01 = '",g_luq.luq01,"'",
               "   AND lur07 <> lur08",
               " GROUP BY lur05,lur06",
               " ORDER BY lur05,lur06"
   PREPARE t616_6_prepare FROM g_sql
   DECLARE lus_sel_cs CURSOR FOR t616_6_prepare
   LET l_cnt = 1
   FOREACH lus_sel_cs INTO l_lus.lus03,l_lus.lus04,l_lus.lus05,l_lus.lus06
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','lus_ins_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET l_lus.lus01 = g_luq.luq01
      LET l_lus.lus02 = l_cnt
      LET l_lus.lus05 = (l_lus.lus05 - l_lus.lus06) * (-1)
      LET l_lus.lus06 = 0
      LET l_lus.luslegal = g_luq.luqlegal
      LET l_lus.lusplant = g_luq.luqplant
      INSERT INTO lus_file VALUES l_lus.*
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('lus01',g_luq.luq01,'ins lus_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF 
      LET l_cnt = l_cnt + 1
   END FOREACH 
END FUNCTION  

FUNCTION t616_check()
DEFINE l_lur03  LIKE lur_file.lur03  
DEFINE l_lui01  LIKE lui_file.lui01
DEFINE l_luo01  LIKE luo_file.luo01
DEFINE l_luc01  LIKE luc_file.luc01  
DEFINE l_lua15  LIKE lua_file.lua15

   LET g_sql = "SELECT DISTINCT lur03 FROM lur_file ",
               " WHERE lur01 = '",g_luq.luq01,"'"
   PREPARE t616_2_prepare FROM g_sql                     #預備一下
   DECLARE lur_sel_cs CURSOR FOR t616_2_prepare
   FOREACH lur_sel_cs INTO l_lur03
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','lur_ins_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
       #1.判读费用单有没有审核	
      SELECT lua15 INTO l_lua15 FROM lua_file
       WHERE lua01 = l_lur03
      IF l_lua15 <> 'Y' THEN
         CALL s_errmsg('lur03',l_lur03,'','alm1244',2) 
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF   
      #2.看费用单对应的交款单有没有审核，提示先处理！
      LET g_sql =" SELECT DISTINCT lui01 FROM lui_file,luj_file ",								
                 "  WHERE lui01 = luj01	",							
                 "    AND luj03 = '", l_lur03,"'",								
                 "    AND luiconf <> 'Y' ",
                 "    AND luiconf <> 'X' "  #CHI-C80041
      PREPARE t616_3_prepare FROM g_sql                     #預備一下
      DECLARE lui_sel_cs CURSOR FOR t616_3_prepare
      FOREACH lui_sel_cs INTO l_lui01
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_showmsg = l_lur03,'/',l_lui01 
         CALL s_errmsg('lur03,lui01',g_showmsg,'','alm1243',2)
         LET g_success = 'N'
         CONTINUE FOREACH
      END FOREACH 
       #3.判读是否有支出单未审核	
      LET g_sql =" SELECT DISTINCT luo01 FROM luo_file,lup_file ",								
                 "  WHERE luo01 = lup01	",							
                 "    AND lup03 = '", l_lur03,"'",
                 "    AND luo03 = '2' ",	        
                 "    AND luoconf <> 'Y' ",
                 "    AND luoconf <> 'X' " #CHI-C80041
      PREPARE t616_4_prepare FROM g_sql                     #預備一下
      DECLARE luo_sel_cs CURSOR FOR t616_4_prepare
      FOREACH luo_sel_cs INTO l_luo01
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_showmsg = l_lur03,'/',l_luo01 
         CALL s_errmsg('lur03,luo01',g_showmsg,'','alm1242',2) 
         LET g_success = 'N'		
         CONTINUE FOREACH
      END FOREACH 
       #3.判读是否有退款单未审核	 
      LET g_sql =" SELECT DISTINCT luc01 FROM luc_file,lud_file,luo_file,lup_file ",								
                 "  WHERE luc01 = lud01	",							
                 "    AND luo01 = lup01	",							
                 "    AND lud03 = luo01	",							
                 "    AND lup03 = '", l_lur03,"'",
                 "    AND luo03 = '2' ",
                 "    AND luc10 = '1' ",         
                 "    AND luc14 <> 'Y' ",
                 "    AND luc14 <> 'X' "  #CHI-C80041
      PREPARE t616_5_prepare FROM g_sql                     #預備一下
      DECLARE luc_sel_cs CURSOR FOR t616_5_prepare
      FOREACH luc_sel_cs INTO l_luc01
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         LET g_showmsg = l_lur03,'/',l_luc01 
         CALL s_errmsg('lur03,luc01',g_showmsg,'','alm1241',2)
         LET g_success = 'N'	
         CONTINUE FOREACH
      END FOREACH
   END FOREACH 
END FUNCTION 

FUNCTION t616_confirm_upd(p_type)
 DEFINE p_type    LIKE type_file.chr1    #1.审核，2.取消审核
 DEFINE l_lur     RECORD LIKE lur_file.*
 DEFINE l_lua     RECORD LIKE lua_file.*
 DEFINE l_lub     RECORD LIKE lub_file.*
 DEFINE l_lup     RECORD LIKE lup_file.*
 DEFINE l_lla     RECORD LIKE lla_file.*
 DEFINE l_liw03   LIKE liw_file.liw03
 DEFINE l_liw13   LIKE liw_file.liw13
 DEFINE l_liw14   LIKE liw_file.liw14
 DEFINE l_liw15   LIKE liw_file.liw15
 DEFINE l_liw17   LIKE liw_file.liw17
 DEFINE l_lub12   LIKE lub_file.lub12
 DEFINE l_luo11   LIKE luo_file.luo11
 DEFINE l_luo15   LIKE luo_file.luo15
 DEFINE l_lij05   LIKE lij_file.lij05

   SELECT * INTO l_lla.* FROM lla_file WHERE llastore = g_luq.luqplant
   LET g_sql = " SELECT lur_file.* ",
               "   FROM lur_file",
               "  WHERE lur01 = '",g_luq.luq01,"'",
               "    AND lur07-lur08 <> 0",
               "  ORDER BY lur03,lur04 "
   PREPARE t616_confirm_upd_p FROM g_sql
   DECLARE t616_confirm_upd_cs CURSOR FOR t616_confirm_upd_p
   FOREACH t616_confirm_upd_cs INTO l_lur.*
      IF STATUS THEN
         CALL s_errmsg('','','t616_confirm_upd_cs',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      
      SELECT lua_file.*,lub_file.* INTO l_lua.*,l_lub.*
        FROM lua_file,lub_file
       WHERE lua01 = lub01
         AND lua01 = l_lur.lur03
         AND lub02 = l_lur.lur04
      
      #更新费用单单身清算金额和结案码
      IF p_type = '1' THEN
         LET l_lub.lub12 = l_lub.lub12 + (l_lur.lur07-l_lur.lur08)
      END IF
      IF p_type = '2' THEN
         LET l_lub.lub12 = l_lub.lub12 - (l_lur.lur07-l_lur.lur08)
      END IF
      IF p_type = '1' AND l_lub.lub04t = l_lub.lub11+l_lub.lub12 THEN
         LET l_lub.lub13 = 'Y'
      END IF
      IF p_type = '2' THEN
         LET l_lub.lub13 = 'N'
      END IF
      UPDATE lub_file SET lub12 = l_lub.lub12,
                          lub13 = l_lub.lub13
       WHERE lub01 = l_lur.lur03
         AND lub02 = l_lur.lur04
         AND lub03 = l_lur.lur05
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg = l_lur.lur03,'/',l_lur.lur04
         CALL s_errmsg('lub01,lub02',g_showmsg,'upd lub_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         #更新合同账单
         IF NOT cl_null(l_lua.lua33) AND NOT cl_null(l_lua.lua34) THEN
            SELECT lij05 INTO l_lij05 FROM lij_file,lua_file
             WHERE lij01 = lnt71
               AND lnt01 = lua04
               AND lij02 = l_lub.lub03
               AND lua01 = l_lub.lub01
            IF l_lla.lla05 = 'N' OR l_lij05 = '1' THEN
               SELECT liw03,liw13,liw14,liw15,liw17 INTO l_liw03,l_liw13,l_liw14,l_liw15,l_liw17
                 FROM liw_file,lua_file,lub_file
                WHERE lua01 = lub01
                  AND lub01 = l_lub.lub01
                  AND lub02 = l_lub.lub02
                  AND liw05 = lua33       #帐期
                  AND liw06 = lua34       #出账日
                  AND liw02 = lub16       #合同版本号
                  AND liw16 = l_lub.lub01 #费用单号
                  AND liw04 = l_lub.lub03 #费用编号
            ELSE
               SELECT liw03,liw13,liw14,liw15,liw17 INTO l_liw03,l_liw13,l_liw14,l_liw15,l_liw17
                 FROM liw_file,lub_file,lua_file
                WHERE lua01 = lub01
                  AND lub01 = l_lub.lub01
                  AND lub02 = l_lub.lub02
                  AND liw05 = lua33       #帐期
                  AND liw06 = lua34       #出账日
                  AND liw02 = lub16       #合同版本号
                  AND liw16 = l_lub.lub01 #费用单号
                  AND liw04 = l_lub.lub03 #费用编号
                  AND liw07 = lub07       #开始日期
                  AND liw08 = lub08       #结束日期
            END IF
            IF p_type = '1' THEN
               LET l_liw15 = l_liw15 + (l_lur.lur07-l_lur.lur08)
            END IF
            IF p_type = '2' THEN
               LET l_liw15 = l_liw15 - (l_lur.lur07-l_lur.lur08)
            END IF
            IF l_liw13 = l_liw14 + l_liw15 THEN
               LET l_liw17 = 'Y'
            ELSE
            	 LET l_liw17 = 'N'
            END IF
            UPDATE liw_file SET liw15 = l_liw15,
                                liw17 = l_liw17
             WHERE liw01 = l_lua.lua04
               AND liw03 = l_liw03
            IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
               LET g_showmsg = l_lua.lua04,'/',l_lub.lub01
               CALL s_errmsg('liw01,liw16',g_showmsg,'upd liw_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         END IF
      
         #更新费用单单头结案
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM lub_file
          WHERE lub01 = l_lur.lur03
            AND lub13 = 'N'
         IF g_cnt = 0 THEN
            LET l_lua.lua14 = '2'
         END IF
         IF p_type = '2' THEN
            LET l_lua.lua14 = '1'
         END IF
         #更新费用单单头清算金额
         SELECT SUM(lub12) INTO l_lub12 FROM lub_file
          WHERE lub01 = l_lur.lur03
         UPDATE lua_file SET lua36 = l_lub12,
                             lua14 = l_lua.lua14
          WHERE lua01 = l_lur.lur03
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
            LET g_showmsg = l_lur.lur03
            CALL s_errmsg('lub01',g_showmsg,'upd lua_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
      
      #根据费用单+项次回写支出单的清算金额
      DECLARE t616_confirm_upd_cs1 CURSOR FOR
       SELECT * FROM lup_file
        WHERE lup03 = l_lur.lur03
          AND lup04 = l_lur.lur04
      FOREACH t616_confirm_upd_cs1 INTO l_lup.*
         IF STATUS THEN
            CALL s_errmsg('','','t616_confirm_upd_cs1',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         #更新单身清算金额
         IF p_type = '1' THEN
            UPDATE lup_file SET lup08 = lup06-lup07,
                                lup09 = g_luq.luq01
             WHERE lup03 = l_lur.lur03
               AND lup04 = l_lur.lur04
         ELSE
            UPDATE lup_file SET lup08 = 0,
                                lup09 = ''
             WHERE lup03 = l_lur.lur03
               AND lup04 = l_lur.lur04
         END IF
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
            LET g_showmsg = l_lur.lur03,'/',l_lur.lur04
            CALL s_errmsg('lup03,lup04',g_showmsg,'upd lup08',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF

         #更新单头结案和清算金额
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM lup_file
          WHERE lup01 = l_lup.lup01
            AND lup06 <> lup07+lup08
         IF g_cnt = 0 THEN
            LET l_luo15 = '2'
         ELSE
            LET l_luo15 = '1'
         END IF 
         SELECT SUM(lup08) INTO l_luo11 FROM lup_file
          WHERE lup01 = l_lup.lup01
         UPDATE luo_file SET luo11 = l_luo11,
                             luo15 = l_luo15
          WHERE luo01 = l_lup.lup01
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
            LET g_showmsg = l_lup.lup01
            CALL s_errmsg('luo01',g_showmsg,'upd luo_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END FOREACH
   END FOREACH    
END FUNCTION

FUNCTION t616_re_settlement(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
 
   IF g_luq.luq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF  
   SELECT * INTO g_luq.* FROM luq_file
     WHERE luq01 = g_luq.luq01
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF   
   IF g_luq.luqacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_luq.luqconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF p_cmd <> 'a' THEN
      IF NOT cl_confirm('alm1377') THEN
         RETURN
      END IF
   END IF

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   OPEN t616_cl USING g_luq.luq01
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_luq.luq01,SQLCA.SQLCODE,0)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t616_cl INTO g_luq.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_luq.luq01,SQLCA.SQLCODE,0)
      CLOSE t616_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   DELETE FROM lur_file WHERE lur01 = g_luq.luq01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lur01',g_luq.luq01,'del lur_file','',1)
      LET g_success = 'N'
   END IF
   DELETE FROM lus_file WHERE lus01 = g_luq.luq01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lus01',g_luq.luq01,'del lus_file','',1)
      LET g_success = 'N'
   END IF

   CALL t616_ins_lur()
   CALL t616_upd_luq()
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      CALL cl_err('','abm-019',0)
      COMMIT WORK
   ELSE
      CALL cl_err('','aic-060',0)
      ROLLBACK WORK
   END IF
   CALL t616_b1_fill(" 1=1")
   CALL t616_b2_fill(" 1=1")
END FUNCTION

FUNCTION t616_upd_luq()

   SELECT SUM(lur07),SUM(lur08) INTO g_luq.luq07,g_luq.luq08 FROM lur_file
    WHERE lur01 = g_luq.luq01
   IF g_luq.luq07-g_luq.luq08 > 0 THEN
      CALL s_errmsg('lur01',g_luq.luq01,'','alm1382',1)
      LET g_success = 'N'
   END IF
   SELECT SUM(lus05),SUM(lus06) INTO g_luq.luq09,g_luq.luq10 FROM lus_file
    WHERE lus01 = g_luq.luq01
   UPDATE luq_file SET luq07 = g_luq.luq07,
                       luq08 = g_luq.luq08,
                       luq09 = g_luq.luq09,
                       luq10 = g_luq.luq10
    WHERE luq01 = g_luq.luq01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('luq01',g_luq.luq01,'upd luq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
      DISPLAY BY NAME g_luq.luq07,g_luq.luq08,g_luq.luq09,g_luq.luq10
      DISPLAY g_luq.luq07-g_luq.luq08,g_luq.luq09-g_luq.luq10 TO amt1,amt2
   END IF
END FUNCTION

FUNCTION t616_refund()
 DEFINE l_lus     RECORD LIKE lus_file.*
 DEFINE l_luc     RECORD LIKE luc_file.*
 DEFINE l_lud     RECORD LIKE lud_file.*
 DEFINE l_cnt     LIKE type_file.num5  
 DEFINE l_luc01   LIKE luc_file.luc01
 DEFINE l_amt     LIKE lus_file.lus05
 DEFINE l_ooz09   LIKE ooz_file.ooz09

   IF g_luq.luq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF  
   SELECT * INTO g_luq.* FROM luq_file
     WHERE luq01 = g_luq.luq01
   IF g_luq.luqplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF   
   IF g_luq.luqacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_luq.luqconf='N' THEN
      CALL cl_err('','aap-717',0)
      RETURN
   END IF
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM luc_file
    WHERE luc11 = g_luq.luq01
      AND luc10 = '2'
      AND luc14 <> 'X' #CHI-C80041
   IF g_cnt > 0 THEN 
      CALL cl_err('','alm1248',0)
      RETURN 
   END IF

   BEGIN WORK
   LET g_success = 'Y' 
   CALL s_showmsg_init()
 
   #FUN-C90050 mark begin---  
   #SELECT rye03 INTO g_luc01 FROM rye_file
   # WHERE rye01 = 'art' AND rye02 = 'C1'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','C1',g_plant,'N') RETURNING g_luc01   #FUN-C90050 add

   IF cl_null(g_luc01) THEN
      CALL s_errmsg('','','sel rye03','art-330',1)
      LET g_success = 'N'
   END IF
   LET g_dd = g_today
  #OPEN WINDOW t616_1_w WITH FORM "art/42f/artt616_1"
  # ATTRIBUTE(STYLE=g_win_style CLIPPED)
  #CALL cl_ui_locale("artt616_1")
  #DISPLAY g_luc01 TO FORMONLY.g_luc01
  #DISPLAY g_dd TO FORMONLY.g_dd
  #INPUT  BY NAME g_luc01,g_dd   WITHOUT DEFAULTS
  #   BEFORE INPUT
  #   AFTER FIELD g_luc01
  #      LET l_cnt = 0
  #      SELECT COUNT(*) INTO  l_cnt FROM oay_file
  #       WHERE oaysys ='art' AND oaytype ='C1' AND oayslip = g_luc01
  #      IF l_cnt = 0 THEN
  #         CALL cl_err(g_luc01,'art-800',0)
  #         NEXT FIELD g_luc01
  #      END IF

  #   ON ACTION CONTROLR
  #      CALL cl_show_req_fields()

  #   ON ACTION CONTROLG
  #      CALL cl_cmdask()
  #   ON ACTION CONTROLF
  #      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
  #      CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

  #   ON ACTION controlp
  #      CASE
  #         WHEN INFIELD(g_luc01)
  #            LET g_t1=s_get_doc_no(g_luc01)
  #            CALL q_oay(FALSE,FALSE,g_t1,'C1','ART') RETURNING g_t1  
  #            LET g_luc01=g_t1               
  #           
  #           # CALL cl_init_qry_var()
  #            #LET g_qryparam.form ="q_slip"
  #            #LET g_qryparam.default1 = g_luc01
  #            #CALL cl_create_qry() RETURNING g_luc01
  #            DISPLAY BY NAME g_luc01
  #            NEXT FIELD g_luc01
  #         OTHERWISE EXIT CASE
  #      END CASE
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE INPUT

  #   ON ACTION about
  #      CALL cl_about()

  #   ON ACTION HELP
  #      CALL cl_show_help()
  #END INPUT
  #IF INT_FLAG THEN
  #   LET INT_FLAG=0
  #   CALL cl_err('',9001,0)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  #CLOSE WINDOW t616_1_w
  #      ####自動編號
   CALL s_check_no("art",g_luc01,"",'C1',"luc_file","luc01","")
      RETURNING li_result,l_luc01
   CALL s_auto_assign_no("art",g_luc01,g_dd,'C1',"luc_file","luc01","","","")
      RETURNING li_result,l_luc01
   IF NOT li_result THEN
      CALL s_errmsg('','','auto luc01','abm-621',1)
      LET g_success = 'N'
   END IF
   
   LET l_luc.luc01 = l_luc01           #退款單號
   LET l_luc.luc02 = ' '               #商戶來源
   LET l_luc.luc03 = g_luq.luq05       #商戶號
   #SELECT lne05 INTO l_luc.luc031 FROM lne_file    #FUN-C20079 mark
   # WHERE lne01 = l_luc.luc03                      #FUN-C20079 mark
   SELECT occ02 INTO l_luc.luc031 FROM occ_file     #FUN-C20079 add
    WHERE occ01 = l_luc.luc03                       #FUN-C20079 add
  #LET l_luc.luc031=                   #商戶簡稱
   LET l_luc.luc04 = g_luq.luq04       #合約編號
   LET l_luc.luc05 = g_luq.luq05       #攤位編號
   LET l_luc.luc06 = 0                 #未稅支出總金額
   LET l_luc.luc06t= 0                 #含稅支出總金額
   LET l_luc.luc07 = g_dd              #單據日期
   LET l_luc.luc08 = NULL              #備注    
   LET l_luc.luc09 = 'Y'               #系統自動生成
   LET l_luc.luc10 = '2'               #來源作業
   LET l_luc.luc11 = g_luq.luq01       #單據號  
  #LET l_luc.luc12 =                   #是否簽核
   LET g_t1=s_get_doc_no(l_luc.luc01)
   SELECT oayapr INTO l_luc.luc12 FROM oay_file WHERE oayslip = g_t1 
   LET l_luc.luc13 = '0'               #簽核狀態
   LET l_luc.luc14 = 'N'               #審核碼
   LET l_luc.luc15 = NULL              #審核人
   LET l_luc.luc16 = NULL              #審核日期
   LET l_luc.luc17 = 0                 #未稅應付金額
   LET l_luc.luc17t= 0                 #含稅應付金額
   SELECT lnt02,lnt35,lnt36,lnt37 INTO l_luc.luc22,l_luc.luc18,l_luc.luc181,l_luc.luc182
     FROM lnt_file
    WHERE lnt01 = l_luc.luc04
  #LET l_luc.luc18 =                   #稅種
  #LET l_luc.luc181=                   #稅率
  #LET l_luc.luc182=                   #含稅
   LET l_luc.luc19 = NULL              #no use 原門店編號
   LET l_luc.lucacti = 'Y'             #資料有效碼
   LET l_luc.luccrat = g_today         #資料創建日
   LET l_luc.lucdate = g_today         #最近更改日
   LET l_luc.lucgrup = g_grup          #資料所有群
   LET l_luc.luclegal= g_luq.luqlegal  #所屬法人
   LET l_luc.lucmodu = NULL            #資料修改者
   LET l_luc.lucplant= g_luq.luqplant  #所屬營運中心
   LET l_luc.lucuser = g_user          #資料所有者
   LET l_luc.lucoriu = g_user          #資料建立者
   LET l_luc.lucorig = g_grup          #資料建立部門
   LET l_luc.luc20 = '2'               #客戶來源
   LET l_luc.luc21 = g_dd              #立帳日期
   SELECT ooz09 INTO l_ooz09 FROM ooz_file
   IF g_dd <= l_ooz09 THEN
      LET l_luc.luc21 = l_ooz09 + 1
   ELSE
      LET l_luc.luc21 = g_dd
   END IF
   LET l_luc.luc23 = l_amt             #退款金額
   LET l_luc.luc24 = 0                 #已退金額
   LET l_luc.luc25 = 'N'               #是否產生新的待抵
   LET l_luc.luc26 = g_user            #業務人員
   LET l_luc.luc27 = g_grup            #部門編號
   LET l_luc.luccont = NULL            #確認時間
   LET l_luc.luc22 = l_luc.luc22       #合約版本號

   SELECT SUM(lus05)-SUM(lus06) INTO l_amt FROM lus_file 
    WHERE lus01 = g_luq.luq01
   LET g_sql = "SELECT * FROM lus_file",
               " WHERE lus01 = '",g_luq.luq01,"'",
               "   AND lus05 > 0 ",
               " ORDER BY lus02 DESC"
   PREPARE t616_10_prepare FROM g_sql
   DECLARE t616_rf_cs CURSOR FOR t616_10_prepare  
   LET l_cnt = 1 
   FOREACH t616_rf_cs INTO l_lus.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','t616_rf_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF l_lus.lus05-l_lus.lus06 < l_amt THEN 
         LET l_amt = l_amt - (l_lus.lus05-l_lus.lus06)
         LET l_lus.lus05 = l_lus.lus05-l_lus.lus06
      ELSE 
         LET l_lus.lus05 =  l_amt
         LET l_amt = 0         
      END IF
      LET l_lud.lud01 = l_luc.luc01        #費用退款單號
      LET l_lud.lud02 = l_cnt              #項次
      LET l_lud.lud03 = l_lus.lus01        #費用單編號
      LET l_lud.lud04 = l_lus.lus02        #費用單項次
      LET l_lud.lud05 = l_lus.lus03        #費用明細編碼
      LET l_lud.lud06 = NULL               #賬款編號
      LET l_lud.lud07t= l_lus.lus05        #含稅費用金額
      LET l_lud.lud07 = l_lud.lud07t/(1+l_luc.luc181) #未稅費用金額
      LET l_lud.lud07 = cl_digcut(l_lud.lud07,g_azi04)
      LET l_lud.lud08 = NULL               #備注
      LET l_lud.lud09 = NULL               #no use 原門店編號
      LET l_lud.ludlegal = l_lus.luslegal  #所屬法人
      LET l_lud.ludplant = l_lus.lusplant  #所屬營運中心
      LET l_lud.lud10 = NULL               #待抵單號
      INSERT INTO lud_file VALUES l_lud.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','ins lud',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      ELSE 
         LET l_cnt = l_cnt + 1
      END IF           
      IF l_amt = 0 THEN 
         EXIT FOREACH
      END IF    
   END FOREACH

   INSERT INTO luc_file VALUES l_luc.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','ins luc',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF

   CALL s_showmsg()
   IF g_success = 'Y' THEN 
      CALL cl_err('','abm-019',0)
      COMMIT WORK 
   ELSE
      CALL cl_err('','abm-020',0)
      ROLLBACK WORK 
   END IF    
END FUNCTION 

FUNCTION t616_sel_refund()
DEFINE l_msg  STRING 
DEFINE l_luc01 LIKE luc_file.luc01
   IF g_luq.luq01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   SELECT luc01 INTO l_luc01 FROM luc_file
    WHERE luc11 = g_luq.luq01
   IF cl_null(l_luc01) THEN 
      CALL cl_err('','alm1330',0)
      RETURN
   ELSE 
      LET l_msg = "artt615 '2' '",g_luq.luq01,"'"
      CALL cl_cmdrun_wait(l_msg) 
   END IF    
END FUNCTION 
#FUN-BB0117
#FUN-CB0076-------add------str
FUNCTION t616_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_amt     LIKE lur_file.lur07,
       l_amt1    LIKE lus_file.lus05
DEFINE l_img_blob     LIKE type_file.blob
DEFINE sr        RECORD
       luqplant  LIKE luq_file.luqplant,
       luq01     LIKE luq_file.luq01,
       luq04     LIKE luq_file.luq04,
       luq05     LIKE luq_file.luq05,
       luq02     LIKE luq_file.luq02,
       luq06     LIKE luq_file.luq06,
       luqcond   LIKE luq_file.luqcond,
       luqcont   LIKE luq_file.luqcont,
       luqconu   LIKE luq_file.luqconu,
       luq07     LIKE luq_file.luq07,
       luq09     LIKE luq_file.luq09,
       lur02     LIKE lur_file.lur02,
       lur03     LIKE lur_file.lur03,
       lur04     LIKE lur_file.lur04,
       lur05     LIKE lur_file.lur05,
       lur06     LIKE lur_file.lur06,
       lur07     LIKE lur_file.lur07,
       lur08     LIKE lur_file.lur08
                 END RECORD
DEFINE sr3       RECORD
       lus01     LIKE lus_file.lus01,
       lus02     LIKE lus_file.lus02,
       lus03     LIKE lus_file.lus03,
       lus04     LIKE lus_file.lus04,
       lus05     LIKE lus_file.lus05,
       lus06     LIKE lus_file.lus06
                 END RECORD

   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                      ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
             " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1) 
   LOCATE l_img_blob IN MEMORY
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET l_sql = "SELECT luqplant,luq01,luq04,luq05,luq02,luq06,luqcond,",
               "       luqcont,luqconu,luq07,luq09,lur02,lur03,lur04,lur05,",
               "       lur06,lur07,lur08",
               "  FROM luq_file,lur_file",
               " WHERE luq01 = '",g_luq.luq01,"'",
               "   AND luq01 = lur01"
   PREPARE t616_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   
      EXIT PROGRAM
   END IF
   DECLARE t616_cs1 CURSOR FOR t616_prepare1

   DISPLAY l_table
   FOREACH t616_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_rtz13 = ' '
      SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.luqplant
      LET l_occ02 = ' '
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.luq05
      LET l_gen02 = ' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.luqconu
      LET l_amt = 0
      LET l_amt = sr.lur07-sr.lur08
      EXECUTE insert_prep USING sr.*,"",l_img_blob,"N","",l_rtz13,l_occ02,l_gen02,l_amt
   END FOREACH
   LET l_sql = "SELECT lus01,lus02,lus03,lus04,lus05,lus06",
               "  FROM lus_file",
               " WHERE lus01 = '",g_luq.luq01,"'"
   PREPARE t616_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   DECLARE t616_cs2 CURSOR FOR t616_prepare2
   DISPLAY l_table1
   FOREACH t616_cs2 INTO sr3.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_amt1 = 0
      LET l_amt1 = sr3.lus05-sr3.lus06
      EXECUTE insert_prep1 USING sr3.*,l_amt1
   END FOREACH
   LET g_cr_table = l_table
   LET g_cr_apr_key_f = "luq01"
   CALL t616_grdata()
END FUNCTION

FUNCTION t616_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   LOCATE sr1.sign_img IN MEMORY
   CALL cl_gre_init_apr()
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("artt616")
       IF handler IS NOT NULL THEN
           START REPORT t616_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY luq01,lur02"
           DECLARE t616_datacur1 CURSOR FROM l_sql
           FOREACH t616_datacur1 INTO sr1.*
               OUTPUT TO REPORT t616_rep(sr1.*)
           END FOREACH
           FINISH REPORT t616_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t616_rep(sr1)
    DEFINE sr1           sr1_t
    DEFINE sr2           sr2_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lur07_sum   LIKE lur_file.lur07
    DEFINE l_lur08_sum   LIKE lur_file.lur08
    DEFINE l_amt_sum     LIKE lur_file.lur08
    DEFINE l_lur06       STRING
    DEFINE l_plant       STRING
    
    ORDER EXTERNAL BY sr1.luq01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
              
        BEFORE GROUP OF sr1.luq01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            LET l_lur06 = cl_gr_getmsg('gre-316',g_lang,sr1.lur06)
            PRINTX l_lur06
            LET l_plant = sr1.luqplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.luq01
            LET l_lur07_sum = GROUP SUM(sr1.lur07)
            LET l_lur08_sum = GROUP SUM(sr1.lur08)
            LET l_amt_sum = GROUP SUM(sr1.amt1)
            PRINTX l_lur07_sum
            PRINTX l_lur08_sum
            PRINTX l_amt_sum
            LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " ORDER BY lus02"
            START REPORT artt616_subrep01
            DECLARE artt616_repcur2 CURSOR FROM g_sql
            FOREACH artt616_repcur2 INTO sr2.*
                OUTPUT TO REPORT artt616_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT artt616_subrep01
            
        ON LAST ROW
END REPORT
REPORT artt616_subrep01(sr2)
    DEFINE sr2           sr2_t
    DEFINE l_lus04       STRING
    DEFINE l_lus05_sum   LIKE lus_file.lus05
    DEFINE l_lus06_sum   LIKE lus_file.lus06
    DEFINE l_amt1_sum    LIKE lus_file.lus06
   
    ORDER EXTERNAL BY sr2.lus01
 
    FORMAT
        ON EVERY ROW
           PRINTX sr2.*
           LET l_lus04 = cl_gr_getmsg('gre-316',g_lang,sr2.lus04)
           PRINTX l_lus04

        AFTER GROUP OF sr2.lus01
           LET l_lus05_sum = GROUP SUM(sr2.lus05)
           LET l_lus06_sum = GROUP SUM(sr2.lus06)
           LET l_amt1_sum = GROUP SUM(sr2.amt2)
           PRINTX l_lus05_sum
           PRINTX l_lus06_sum
           PRINTX l_amt1_sum

END REPORT
#FUN-CB0076-------add------end
