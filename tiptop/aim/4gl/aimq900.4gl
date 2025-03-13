# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: "aimq900.4gl"
# Descriptions...: 料件批序號資料異動明細查詢
# Date & Author..: 11/04/13  BY suncx
# Modify.........: No.FUN-B30209 11/04/13  BY suncx
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_rvbs1   DYNAMIC ARRAY OF RECORD
                 rvbs021 LIKE rvbs_file.rvbs021,
                 ima02   LIKE ima_file.ima02,
                 ima021  LIKE ima_file.ima021,
                 rvbs04  LIKE rvbs_file.rvbs04,
                 rvbs03  LIKE rvbs_file.rvbs03
                 END RECORD,
       g_rvbs1_t RECORD
                 rvbs021 LIKE rvbs_file.rvbs021,
                 ima02   LIKE ima_file.ima02,
                 ima021  LIKE ima_file.ima021,
                 rvbs04  LIKE rvbs_file.rvbs04,
                 rvbs03  LIKE rvbs_file.rvbs03
                 END RECORD
DEFINE g_rvbs2   DYNAMIC ARRAY OF RECORD
                 rvbs00  LIKE rvbs_file.rvbs00,
                 docname LIKE smy_file.smydesc,
                 rvbs01  LIKE rvbs_file.rvbs01,
                 rvbs02  LIKE rvbs_file.rvbs02,
                 date    LIKE imm_file.imm02,
                 cust    LIKE imm_file.imm14,
                 name    LIKE gem_file.gem02,
                 rvbs06  LIKE rvbs_file.rvbs06,
                 conf    LIKE imm_file.immconf,
                 post    LIKE imm_file.imm03
                 END RECORD,
       g_rvbs2_t RECORD
                 rvbs00  LIKE rvbs_file.rvbs00,
                 docname LIKE smy_file.smydesc,
                 rvbs01  LIKE rvbs_file.rvbs01,
                 rvbs02  LIKE rvbs_file.rvbs02,
                 date    LIKE imm_file.imm02,
                 cust    LIKE imm_file.imm14,
                 name    LIKE gem_file.gem02,
                 rvbs06  LIKE rvbs_file.rvbs06,
                 conf    LIKE imm_file.immconf,
                 post    LIKE imm_file.imm03
                 END RECORD
DEFINE g_sql    STRING,
       g_wc     STRING,
       g_rec_b1 LIKE type_file.num5,
       g_rec_b2 LIKE type_file.num5,
       l_ac1    LIKE type_file.num5,
       l_ac2    LIKE type_file.num5
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_run_type  DYNAMIC ARRAY OF STRING
DEFINE g_colors DYNAMIC ARRAY OF RECORD
                 color1 STRING,
                 color2 STRING,
                 color3 STRING,
                 color4 STRING,
                 color5 STRING
                END RECORD

MAIN
   OPTIONS
   INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF


   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q900_w AT p_row,p_col WITH FORM "aim/42f/aimq900"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_wc = " 1=1"
   CALL q900_b_fill(g_wc)

   CALL q900_menu()
   CLOSE WINDOW q900_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_cmd  STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ''

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rvbs1 TO s_rvbs1.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL fgl_set_arr_curr(l_ac1)
            IF l_ac1 > 0 THEN
               CALL q900_b2_fill(g_rvbs1[l_ac1].rvbs021,g_rvbs1[l_ac1].rvbs03,g_rvbs1[l_ac1].rvbs04)
            END IF
            CALL DIALOG.setSelectionMode("s_rvbs1",1)
            CALL Dialog.setCurrentRow("s_rvbs1",l_ac1)
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG     
      END DISPLAY

      DISPLAY ARRAY g_rvbs2 TO s_rvbs2.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL fgl_set_arr_curr(l_ac2)
            CALL cl_show_fld_cont()
  
         ON ACTION qry_documents
            IF g_run_type[l_ac2] = '1' THEN
               LET l_cmd =  g_rvbs2[l_ac2].rvbs00," '' '' '",g_rvbs2[l_ac2].rvbs01,"'"
            ELSE
               LET l_cmd =  g_rvbs2[l_ac2].rvbs00," '",g_rvbs2[l_ac2].rvbs01,"'"
            END IF
            CALL cl_cmdrun(l_cmd)

         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY
     
      ON ACTION query
         LET g_action_choice="query"
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

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q900_menu()

   WHILE TRUE
      CALL q900_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q900_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac1 != 0 THEN
               IF g_rvbs1[l_ac1].rvbs021 IS NOT NULL THEN
                  LET g_doc.column1 = "rvbs021"
                  LET g_doc.value1 = g_rvbs1[l_ac1].rvbs021
                  CALL cl_doc()
               END IF
            END IF

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvbs1),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION q900_q()

   CALL q900_b_askkey()

END FUNCTION

FUNCTION q900_b_askkey()

   CLEAR FORM

   CONSTRUCT g_wc ON rvbs021,rvbs04,rvbs03
                FROM s_rvbs1[1].rvbs021,s_rvbs1[1].rvbs04,s_rvbs1[1].rvbs03

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

      ON ACTION controlp
         CASE
            WHEN INFIELD(rvbs021)
               CALL cl_init_qry_var()
               LET g_qryparam.state="c"
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.default1 =g_rvbs1[1].rvbs021
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvbs021
               NEXT FIELD rvbs021
            OTHERWISE EXIT CASE
         END CASE


   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL g_rvbs1.clear()
   CALL g_rvbs2.clear()
   CALL g_run_type.clear()
   CALL q900_b_fill(g_wc)

END FUNCTION

FUNCTION q900_b_fill(p_wc)
DEFINE   p_wc       STRING

   LET g_sql = " SELECT DISTINCT rvbs021,ima02,ima021,rvbs04,rvbs03 ",
               "   FROM rvbs_file LEFT JOIN ima_file ON ima01 = rvbs021 ",
               "  WHERE ",p_wc CLIPPED,
               "  ORDER BY 1" 


   PREPARE q900_pb FROM g_sql
   DECLARE rvbs1_cs CURSOR FOR q900_pb

   CALL g_rvbs1.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH rvbs1_cs INTO g_rvbs1[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_rvbs1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cnt
   LET g_cnt = 0
END FUNCTION

FUNCTION q900_b2_fill(p_rvbs021,p_rvbs03,p_rvbs04)
DEFINE p_rvbs021 LIKE rvbs_file.rvbs021,
       p_rvbs03  LIKE rvbs_file.rvbs03,
       p_rvbs04  LIKE rvbs_file.rvbs04
DEFINE l_smyslip LIKE smy_file.smyslip    #單據別
DEFINE l_rvbs00  STRING

   LET g_sql = "SELECT DISTINCT rvbs00,'',rvbs01,rvbs02,'','','',rvbs06,'',''",
               "  FROM rvbs_file ",
               " WHERE rvbs021 = '",p_rvbs021,"'",
               "   AND rvbs03 = '",p_rvbs03,"'",
               "   AND rvbs04 = '",p_rvbs04,"'",
               " ORDER BY 1"

   PREPARE q900_pb1 FROM g_sql
   DECLARE rvbs2_cs CURSOR FOR q900_pb1

   CALL g_rvbs2.clear()
   CALL g_run_type.clear()
   LET g_cnt = 1

   FOREACH rvbs2_cs INTO g_rvbs2[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL s_get_doc_no(g_rvbs2[g_cnt].rvbs01) RETURNING l_smyslip

      LET l_rvbs00 = g_rvbs2[g_cnt].rvbs00
      IF l_rvbs00.getIndexOf("axm",1) > 0 THEN
         SELECT oaydesc INTO g_rvbs2[g_cnt].docname FROM oay_file WHERE oayslip=l_smyslip
      ELSE
         SELECT smydesc INTO g_rvbs2[g_cnt].docname FROM smy_file WHERE smyslip=l_smyslip
      END IF

      #取單據日期，廠商/客戶/部門，簡稱，確認，過賬資料
      LET g_run_type[g_cnt] = ''
      CASE 
         WHEN l_rvbs00="aimt324"
            SELECT imm02,imm14,gem02,immconf,imm03
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM imm_file LEFT JOIN gem_file ON gem01 = imm14
             WHERE imm01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="aimt325" OR l_rvbs00="aimt326")
            SELECT imm02,imm14,gem02,imm04,imm03
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM imm_file LEFT JOIN gem_file ON gem01 = imm14 
             WHERE imm01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="aimt301" OR l_rvbs00="aimt302" OR l_rvbs00="aimt303" OR
               l_rvbs00="aimt311" OR l_rvbs00="aimt312" OR l_rvbs00="aimt313" OR 
               l_rvbs00="aimt370")
            SELECT ina03,ina04,gem02,inaconf,inapost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM ina_file LEFT JOIN gem_file ON gem01 = ina04
             WHERE ina01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="apmt110" OR l_rvbs00="apmt200")
            SELECT rva06,rva05,pmc03,rvaconf,""
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM rva_file LEFT JOIN pmc_file ON pmc01 = rva05
             WHERE rva01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="apmt720" OR l_rvbs00="apmt721" OR l_rvbs00="apmt722" OR
               l_rvbs00="apmt730" OR l_rvbs00="apmt731" OR l_rvbs00="apmt732" OR
               l_rvbs00="apmt740" OR l_rvbs00="apmt741" OR l_rvbs00="apmt742")
            LET g_run_type[g_cnt] = '1'
            SELECT rvu03,rvu04,pmc03,rvuconf,""
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM rvu_file LEFT JOIN pmc_file ON pmc01 = rvu04
             WHERE rvu01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="aqct110" OR l_rvbs00="aqct700" OR l_rvbs00="aqct800")
            SELECT qcs04,qcs03,pmc03,qcs14,""
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM qcs_file LEFT JOIN pmc_file ON pmc01 = qcs03  
             WHERE qcs01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="asfi510" OR l_rvbs00="asfi511" OR l_rvbs00="asfi512" OR 
               l_rvbs00="asfi513" OR l_rvbs00="asfi514" OR l_rvbs00="asfi520" OR 
               l_rvbs00="asfi526" OR l_rvbs00="asfi527" OR l_rvbs00="asfi528" OR 
               l_rvbs00="asfi529" OR l_rvbs00="asri210" OR l_rvbs00="asri220" OR 
               l_rvbs00="asfi519")                                                  #FUN-C70014
            SELECT sfp02,sfp07,gem02,sfpconf,sfp04
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM sfp_file LEFT JOIN gem_file ON gem01 = sfp07
             WHERE sfp01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="asft620" OR l_rvbs00="asft623")
            SELECT sfu14,sfu04,gem02,sfuconf,sfupost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM sfu_file LEFT JOIN gem_file ON gem01 = sfu04
             WHERE sfu01 = g_rvbs2[g_cnt].rvbs01
         WHEN l_rvbs00="asft622"
            SELECT ksc14,ksc04,gem02,kscconf,kscpost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM ksc_file LEFT JOIN gem_file ON gem01 = ksc04
             WHERE ksc01 = g_rvbs2[g_cnt].rvbs01
         WHEN l_rvbs00="asft670"
            SELECT sfk02,"","",sfkconf,sfkpost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM sfk_file
             WHERE sfk01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="axmt610" OR l_rvbs00="axmt620" OR l_rvbs00="axmt640" OR 
               l_rvbs00="axmt820" OR l_rvbs00="axmt821" OR l_rvbs00="axmt628" OR 
               l_rvbs00="axmt629" OR l_rvbs00="axmt650")
            SELECT oga02,oga03,occ02,ogaconf,ogapost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM oga_file LEFT JOIN occ_file ON occ01 = oga03
             WHERE oga01 = g_rvbs2[g_cnt].rvbs01
         WHEN (l_rvbs00="axmt700" OR l_rvbs00="axmt840")
            SELECT oha02,oha03,occ02,ohaconf,ohapost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM oha_file LEFT JOIN occ_file ON occ01 = oha03
             WHERE oha01 = g_rvbs2[g_cnt].rvbs01
         WHEN l_rvbs00="atmt260"
            SELECT tsc02,tsc15,gem02,tscconf,tscpost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM tsc_file LEFT JOIN gem_file ON gem01 = tsc15
             WHERE tsc01 = g_rvbs2[g_cnt].rvbs01
         WHEN l_rvbs00="atmt261"
            SELECT tse02,tse15,gem02,tseconf,tsepost
              INTO g_rvbs2[g_cnt].date,g_rvbs2[g_cnt].cust,g_rvbs2[g_cnt].name,
                   g_rvbs2[g_cnt].conf,g_rvbs2[g_cnt].post
              FROM tse_file LEFT JOIN gem_file ON gem01 = tse15 
             WHERE tse01 = g_rvbs2[g_cnt].rvbs01
      END CASE

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_rvbs2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
#FUN-B30209 
