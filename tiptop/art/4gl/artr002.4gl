# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artr002.4gl
# Descriptions...: 價簽列印作業
# Date & Author..: FUN-A30113 10/03/29 By chenmoyan
# Modify.........: No:TQC-AC0279 10/12/18 By suncx 單身資料抓取方式變更
# Modify.........: No.TQC-AC0307 10/12/22 By vealxu (1).查詢方案為售價變更查詢時，第一個查詢條件名稱現為變更單號，應為自定價調整單號
#                                                   (2).自定價變更單號字段選填值時應管控只可選填已審核的有效的自定價調整單，現未管控
#                                                   (3).只填了策略變更單號按查詢時，報查詢條件不可全為空，無法查詢產生單身資料 
# Modify.........: No.TQC-AC0325 10/12/22 By vealxu 1.自定價變更單號查詢結果不正確
#                                                   2.策略變更單號查詢結果不正確
# Modify.........: No.TQC-AC0327 10/12/23 By vealxu 特價促銷單開窗現查不到資料 
# Modify.........: No.TQC-AC0328 10/12/23 By vealxu 特價產品查詢結果不正確
# Modify.........: No:FUN-B30031 11/03/23 By shiwuying 增加生效范围判断

DATABASE ds 
GLOBALS "../../config/top.global"
 
DEFINE
   tm     RECORD
           ima01       LIKE ima_file.ima01,
           rta05       LIKE rta_file.rta05,
           rtm01       LIKE rtm_file.rtm01,
           rtmcond     LIKE rtm_file.rtmcond,
          #TQC-AC0328 -----------mod start----------------
          #rtm03       LIKE rtm_file.rtm03,
          #rwc04       LIKE rwc_file.rwc04,
          #rwbcond     LIKE rwb_file.rwbcond,
          #rwc19       LIKE rwc_file.rwc19,
          #rwc20       LIKE rwc_file.rwc20 
           rab02       LIKE rab_file.rab02,
           rabcond     LIKE rab_file.rabcond,
           rac12       LIKE rac_file.rac12,
           rac13       LIKE rac_file.rac13
          #TQC-AC0328 --------- mod end-------------------
        END RECORD,
   g_rta  DYNAMIC ARRAY OF RECORD
           sel         LIKE type_file.chr1,
           ima01_1     LIKE ima_file.ima01,
           ima02       LIKE ima_file.ima02,
           rta05_1     LIKE rta_file.rta05,
           ima021      LIKE ima_file.ima021,
           rta03       LIKE rta_file.rta03,
           rtg05       LIKE type_file.chr30,
           rtg06       LIKE type_file.chr30,
           rtmcond_1   LIKE rtm_file.rtmcond,
           rtm03_1     LIKE rtm_file.rtm03,
          #TQC-AC0328 ---------------mod start--------------
          #rwc13       LIKE type_file.chr30,
          #rwc15       LIKE type_file.chr30,
          #rwc19_1     LIKE rwc_file.rwc19,
          #rwc20_1     LIKE rwc_file.rwc20,
          #rwc21       LIKE rwc_file.rwc21,
          #rwc22       LIKE rwc_file.rwc22,
           rac05       LIKE rac_file.rac05,
           rac09       LIKE rac_file.rac09,
           rac12_1     LIKE rac_file.rac12,
           rac13_1     LIKE rac_file.rac13,
           rac14       LIKE rac_file.rac14,
           rac15       LIKE rac_file.rac15,
          #TQC-AC0328 ---------------mod end------------------
           qty         LIKE type_file.num10
       END RECORD,
   g_method            LIKE type_file.chr1,
   g_rza01             LIKE rza_file.rza01,
   g_pt1               LIKE type_file.chr1,
   g_pt2               LIKE type_file.chr1,
   g_sql               STRING
DEFINE   g_name         STRING
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_msg          LIKE type_file.chr1000,
         l_ac           LIKE type_file.num5
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_xml_out      STRING
DEFINE   g_time1        LIKE type_file.chr8
DEFINE   g_wc,g_wc1,g_wc2     STRING
DEFINE   g_rtf03        LIKE rtf_file.rtf03    #TQC-AC0325 
DEFINE   g_wc01,g_wc02,g_wc03 STRING  #TQC-AC0325

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   LET g_time1 = g_time
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 3 LET p_col = 2

   OPEN WINDOW r002_w AT p_row,p_col WITH FORM "art/42f/artr002"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   SELECT rtf03 INTO g_rtf03 FROM rtf_file 
    WHERE rtf01 = (SELECT rtz05 FROM rtz_file
    WHERE rtz01 = g_plant )
   INITIALIZE tm.* TO NULL
   LET g_pt1   = 'Y'
   LET g_pt2   = 'N'
   LET g_method= '1'
  #CALL s_get_rza01()            #FUN-B30031
   CALL s_get_rza01('2',g_plant) #FUN-B30031
   CALL r002_set_no_visible(g_method)
   CALL r002_menu()
   CLOSE WINDOW r002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION r002_search()
DEFINE l_ac           LIKE type_file.num5
DEFINE l_rta04        LIKE rta_file.rta04
DEFINE l_img10        LIKE img_file.img10
DEFINE l_wc1          STRING
DEFINE i              LIKE type_file.num5
 
   IF g_pt1 = 'N' THEN
      CALL g_rta.clear()
      LET g_rec_b = 0
      LET l_ac = 1
   ELSE
      LET l_ac = g_rec_b+1
   END IF
   CALL cl_opmsg('q')
   CALL cl_set_head_visible("","YES")
 
   MESSAGE ' WAIT '

   IF g_method = '1' THEN
       IF cl_null(g_wc01) THEN            #TQC-AC0279 
          LET g_wc01 = " 1=1"             #TQC-AC0279 
       END IF                             #TQC-AC0279 
      #TQC-AC0279 mark ---begin---------------------------
      #IF cl_null(g_wc) THEN
      #   LET g_wc = " 1=1"
      #END IF
      #LET i=g_wc.getindexof('rta05',1)
      #IF i=0 THEN
      #   LET g_sql=" SELECT 'Y',ima01,ima02,'',ima021,rtg04,ROUND(rtg05,2),",
      #             "        ROUND(rtg06,2),'','','','','','','','',1",
      #             "   FROM ima_file,rtg_file,rtz_file",
      #             "  WHERE ima01 = rtg03 AND rtg01=rtz05 ",
      #             "    AND rtz01 = '",g_plant,"' ",
      #             "    AND ",g_wc,
      #             " UNION ",
      #             " SELECT 'Y',ima01,ima02,'',ima021,rth02,ROUND(rth04,2),",
      #             "        ROUND(rth05,2),'','','','','','','','',1",
      #             "   FROM ima_file,rth_file",
      #             "  WHERE ima01 = rth01 AND rthplant='",g_plant,"'",
      #             "    AND ",g_wc
      #ELSE
      #   LET g_sql=" SELECT 'Y',ima01,ima02,rta05,ima021,rtg04,ROUND(rtg05,2),",
      #             "        ROUND(rtg06,2),'','','','','','','','',1",
      #             "   FROM ima_file,rta_file,rtg_file,rtz_file",
      #             "  WHERE ima01 = rtg03 AND rtg01=rtz05 ",
      #             "    AND rtz01 = '",g_plant,"' AND rta01=ima01",
      #             "    AND rtg04 = rta03 AND ",g_wc,
      #             " UNION ",
      #             " SELECT 'Y',ima01,ima02,rta05,ima021,rta03,ROUND(rth04,2),",
      #             "        ROUND(rth05,2),'','','','','','','','',1",
      #             "   FROM ima_file,rta_file,rth_file",
      #             "  WHERE ima01 = rth01 AND rthplant='",g_plant,"'",
      #             "    AND rta01 = ima01 AND rth02 = rta03 AND ",g_wc
      #END IF
      #TQC-AC0279 mark ----end-----------------------------
      LET g_sql = " SELECT 'Y',ima01,ima02,rta05,ima021,rta03,'','','','','','','','','','',1 ",  #TQC-AC0279 add
                  "   FROM ima_file LEFT OUTER JOIN rta_file ON ima01 = rta01",                         #TQC-AC0279 add 
                  "  WHERE ",g_wc01                                            #TQC-AC0279 add
   END IF
   IF g_method = '2' THEN
     #TQC-AC0325 ---------------------------mod start---------------------------- 
      IF cl_null(g_wc02) THEN
         LET g_wc02 = " 1=1"
      END IF
     #IF cl_null(g_wc) THEN
     #   LET g_wc = " 1=1"
     #END IF
     #LET g_sql=" SELECT 'Y',ima01,ima02,'',ima021,rtn04,ROUND(rtn11,2),",
     #          "        ROUND(rtn12,2),rtmcond,rtm03,'','','','','','',1 ",
     #          "   FROM ima_file,rtm_file,rtn_file",
     #          "  WHERE rtn01 = rtm01 ",
     #          "    AND rtn03 = ima01 ",
     #          "    AND rtmconf = 'Y' AND rtnplant = '",g_plant,"'",
     #          "    AND ",g_wc,
     #          "    AND ",g_wc1,
     #          " UNION",
     #          " SELECT 'Y',ima01,ima02,'',ima021,rtj09,ROUND(rtj16,2),",
     #          "        ROUND(rtj17,2),rticond,rti03,'','','','','','',1 ",
     #          "   FROM ima_file,rtj_file,rti_file,rtk_file,rtz_file",
     #          "  WHERE rti01 = rtj01 AND rtiplant = '",g_plant,"'",
     #          "    AND rtj02='2' ",
     #          "    AND rtj04=ima01 AND rticonf='Y'",
     #          "    AND rti01 = rtk01 AND rtk02='2'",
     #          "    AND rtz05=rtk05 AND rtz01='",g_plant,"'",
     #          "    AND ",g_wc,
     #          "    AND ",g_wc2

     #SELECT rtf03 INTO l_rtf03 FROM rtf_file WHERE rtf01 = (SELECT rtz05 FROM rtz_file
     # WHERE rtz01 = g_plant )
      LET g_sql = " SELECT 'Y',rtn03,ima02,rta05,ima021,rtn04,ROUND(rtn11,2),ROUND(rtn12,2),",
                  "        rtmcond,rtm03,'','','','','','',1 ",
                  "   FROM rtn_file LEFT OUTER JOIN rta_file ",
                  "     ON rtn03 = rta01 AND rtn04 = rta03, ",
                  "        rtm_file,ima_file ",
                  "  WHERE rtn01 = rtm01 AND rtn03 = ima01 ",
                  "    AND rtnplant = '",g_plant,"'",
                  "    AND rtmconf = 'Y' ",
                  "    AND ",g_wc02,
                  "    AND ",g_wc1 
      CALL cl_replace_str(g_wc02,"rtm","rti") RETURNING g_wc02
      LET g_sql = g_sql CLIPPED, " UNION ",
                  " SELECT 'Y',rtj04,ima02,rta05,ima021,rtj09,ROUND(rtj16,2),ROUND(rtj17,2), ",
                  "        rticond,rti03,'','','','','','',1 ",
                  "   FROM ",cl_get_target_table(g_rtf03,'rtj_file')," LEFT OUTER JOIN ",
                             cl_get_target_table(g_rtf03,'rta_file')," ON rtj04 = rta01 AND rtj09 = rta03,",
                             cl_get_target_table(g_rtf03,'rti_file'),",",
                             cl_get_target_table(g_rtf03,'rtk_file'),",",
                             cl_get_target_table(g_rtf03,'ima_file'),
                  "  WHERE rtj01 = rti01 AND rtj01 = rtk01 AND rtj02 = rtk02 ",
                  "    AND rtj04 = ima01 ",
                  "    AND rtjplant  = '",g_rtf03, "'",
                  "    AND rtj02 = '2' ",
                  "    AND rticonf = 'Y' ",
                  "    AND rtk05 = ( SELECT rtz05 FROM rtz_file WHERE rtz01 = '",g_plant,"')",
                  "    AND ",g_wc02,
                  "    AND ",g_wc2     
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     #CALL cl_parse_qry_sql(g_sql,g_rtf03) RETURNING g_sql
     #TQC-AC0325 ----------------------mod end-------------------------------------
      
   END IF
   IF g_method = '3' THEN
     #TQC-AC0328 ----------------mod start--------------------------------------------
      IF cl_null(g_wc03) THEN
         LET g_wc03 = " 1=1"
      END IF
     #IF cl_null(g_wc) THEN
     #   LET g_wc = " 1=1"
     #END IF
     #LET g_sql="SELECT 'Y',ima01,ima02,'',ima021,rwc09,",
     #          "       ROUND((rwc13/rwc12*100),2),ROUND((rwc15/rwc14*100),2),",
     #          "       rwbcond,'',ROUND(rwc13,2),ROUND(rwc15),rwc19,rwc20,",
     #          "       rwc21,rwc22,1",
     #          "  FROM ima_file,rwc_file,rwb_file",
     #          " WHERE ima01=rwc06 AND rwc01=rwb01 AND rwc02=rwb02 AND rwc03=rwb03",
     #          "   AND rwc04=rwb04 AND rwbplant='",g_plant,"'",
     #          "   AND rwbconf='Y' AND rwcplant='",g_plant,"'",
     #          "   AND rwc04 IN (SELECT rwq04 FROM rwq_file ",
     #          "                  WHERE rwq03='1' AND rwqplant='",g_plant,"'",
     #          "                    AND rwq06='",g_plant,"')",
     #          "   AND ",g_wc

      LET g_sql="SELECT 'Y',ima01,ima02,rta05,ima021,rad06,",
                "       ROUND(rtg05,2),ROUND(rtg06,2),rabcond,rab901,ROUND(rac05,2),ROUND(rac09,2),rac12,rac13,rac14,rac15,1 ",
                "  FROM rad_file LEFT OUTER JOIN rta_file ON rad05 = rta01 AND rad06 = rta03, ",
                "       ima_file,rtg_file,rtz_file,rab_file,rac_file,raq_file ",
                " WHERE rtz01 = radplant AND rtz05 = rtg01 ",
                "   AND rad05 = rtg03    AND rad06 = rtg04 ",
                "   AND rad05 = ima01 ",
                "   AND rad01 = rab01    AND rad02 = rab02     AND radplant = rabplant ",
                "   AND rad01 = rac01    AND rad02 = rac02     AND rad03 = rac03     AND radplant = racplant ",
                "   AND rad01 = raq01    AND rad02 = raq02     AND rad03 = raq03     AND radplant = raq04    AND radplant = raqplant ",
                "   AND rac04 = '1'      AND rabconf = 'Y'     AND raq05 = 'Y'       AND raq03 = '1' ",
                "   AND radplant = '",g_plant,"'",
                "   AND ",g_wc03
     #TQC-AC0328 --------------mod end------------------------------------------------
   END IF
   
   PREPARE r002_prepare FROM g_sql
   DECLARE r002_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR r002_prepare
   FOREACH r002_cs INTO g_rta[l_ac].*,l_rta04
      SELECT SUM(img10) INTO l_img10 
        FROM img_file 
       WHERE img01=g_rta[l_ac].ima01_1
      IF g_pt2 = 'Y' AND (l_img10 <= 0 OR cl_null(l_img10)) THEN
         CALL g_rta.DeleteElement(l_ac)
         CONTINUE FOREACH
      END IF
      #TQC-AC0279 add --Begin------------------------------
      IF g_method='1' THEN
         SELECT ROUND(rth04,2),ROUND(rth05,2)
           INTO g_rta[l_ac].rtg05,g_rta[l_ac].rtg06
           FROM rth_file,rtg_file
          WHERE rth01 = rtg03 AND rth01 = g_rta[l_ac].ima01_1
            AND rtg08 = 'Y'   AND rthplant = g_plant
            AND rth02 = g_rta[l_ac].rta03 
      
         IF SQLCA.sqlcode = 100 THEN
            SELECT ROUND(rtg05,2),ROUND(rtg06,2)
              INTO g_rta[l_ac].rtg05,g_rta[l_ac].rtg06
              FROM rtz_file,rtg_file,rta_file
             WHERE rtg03 = g_rta[l_ac].ima01_1 
               AND rtg01 = rtz05 AND rtz01 = g_plant
               AND rtg04 = g_rta[l_ac].rta03
         END IF
      END IF
      #TQC-AC0279 add ---End------------------------------
     #TQC-AC0328 -----------mark start--------------- 
     #IF g_method <> '1' THEN   #TQC-AC0279 add   
     #   SELECT rta05 INTO g_rta[l_ac].rta05_1 FROM rta_file 
     #    WHERE rta01=g_rta[l_ac].ima01_1
     #      AND rta03=g_rta[l_ac].rta03
     #END IF
     #TQC-AC0328 ----------mark end------------------
      IF g_method='2' THEN
         IF cl_null(g_rta[l_ac].rtm03_1) THEN
            LET g_rta[l_ac].rtm03_1 = g_rta[l_ac].rtmcond_1
         END IF
      END IF
      CALL r002_set_format(g_rta[l_ac].rtg05) RETURNING g_rta[l_ac].rtg05
      CALL r002_set_format(g_rta[l_ac].rtg06) RETURNING g_rta[l_ac].rtg06
      CALL r002_set_format(g_rta[l_ac].rac05) RETURNING g_rta[l_ac].rac05    #TQC-AC0328 mod rwc13 ->rac05 
      CALL r002_set_format(g_rta[l_ac].rac09) RETURNING g_rta[l_ac].rac09    #TQC-AC0328 mod rwc15 ->rac09
     #LET g_rta[l_ac].rtg05 = g_rta[l_ac].rtg05 USING "##############&.&&"
     #LET g_rta[l_ac].rtg06 = g_rta[l_ac].rtg06 USING "##############&.&&"
     #LET g_rta[l_ac].rwc13 = g_rta[l_ac].rwc13 USING "##############&.&&"
     #LET g_rta[l_ac].rwc15 = g_rta[l_ac].rwc15 USING "##############&.&&"
      
      LET l_ac = l_ac+1

          
   END FOREACH
   CALL g_rta.deleteElement(l_ac)
   LET l_ac = l_ac - 1
   LET g_rec_b = l_ac
 # LET g_wc = ''      #TQC-AC0325 mark
   LET g_wc01 = ''    #TQC-AC0325
   LET g_wc02 = ''    #TQC-AC0325
   LET g_wc03 = ''    #TQC-AC0325
 
END FUNCTION
 
FUNCTION r002_menu()
   WHILE TRUE
      CALL r002_bp("G")
      CASE g_action_choice
         WHEN "search"
            IF cl_chk_act_auth() THEN
               CALL r002_search()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "clear"
            IF cl_chk_act_auth() THEN
               CALL g_rta.clear()
               LET g_rec_b = 0
            END IF
         WHEN "sel_none" 
            IF cl_chk_act_auth() THEN
               CALL r002_sel('N')
            END IF
         WHEN "sel_all" 
            IF cl_chk_act_auth() THEN
               CALL r002_sel('Y')
            END IF
         WHEN "print"
            IF cl_chk_act_auth() THEN
               CALL r002_print()
            END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION r002_sel(p_type)
DEFINE p_type     LIKE type_file.chr1
DEFINE i          LIKE type_file.num5
   FOR i=1 TO g_rec_b
      LET g_rta[i].sel = p_type
   END FOR
END FUNCTION
 
FUNCTION r002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   LET g_action_choice = " "
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME g_method,g_rza01,g_pt1,g_pt2
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         ON CHANGE g_method
            CALL r002_set_visible()
            CALL r002_set_no_visible(g_method)
      END INPUT
      CONSTRUCT BY NAME g_wc1 ON rtm01
         ON ACTION CONTROLP 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
               WHEN INFIELD(rtm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_rtm01'   
                  LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.where = " rtmacti = 'Y' AND rtmconf = 'Y' "    #TQC-AC0307 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtm01
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rtm01
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc2 ON rti01
         ON ACTION CONTROLP 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
               WHEN INFIELD(rti01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_rti'
                  LET g_qryparam.arg1 = g_plant   
                  LET g_qryparam.plant = g_rtf03   #TQC-AC0325  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rti01
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rti01
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
     #TQC-AC0325 --------------------add start-------------------------------------
      CONSTRUCT BY NAME g_wc01 ON ima01,rta05     #普通查询 
          ON ACTION CONTROLP
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_ima'
                  LET g_qryparam.default1 = g_qryparam.multiret
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD ima01
               WHEN INFIELD(rta05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_rta1'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rta05
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rta05
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT 

     CONSTRUCT BY NAME g_wc02 ON rtmcond,rtm03
         ON ACTION CONTROLP
            CALL cl_set_act_visible("accept,cancel", TRUE)   
     END CONSTRUCT
    #TQC-AC0325 -----------------------------add end----------------------------------
    #CONSTRUCT BY NAME g_wc ON ima01,rta05,rtmcond,rtm03,
    #                           rwc04,rwbcond,rwc19,rwc20     #TQC-AC0328 mark
     CONSTRUCT BY NAME g_wc03 ON  rab02,rabcond,rac12,rac13     #TQC-AC0328
 
         ON ACTION CONTROLP 
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CASE
              #TQC-AC0325 ----------mark start-------------
              #WHEN INFIELD(ima01)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form = 'q_ima'
              #   LET g_qryparam.default1 = g_qryparam.multiret
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO ima01
              #   CALL cl_set_act_visible("accept,cancel", FALSE)
              #   NEXT FIELD ima01
              #WHEN INFIELD(rta05)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form = 'q_rta1'
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   DISPLAY g_qryparam.multiret TO rta05
              #   CALL cl_set_act_visible("accept,cancel", FALSE)
              #   NEXT FIELD rta05
              #TQC-AC0325 ----------------mark end----------------------
             # WHEN INFIELD(rwc04)     #TQC-AC0328 mark
               WHEN INFIELD(rab02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                # LET g_qryparam.form = 'q_rwc04'    #TQC-AC0327 mark
                  LET g_qryparam.form = 'q_rab02_1'  #TQC-AC0328
                  LET g_qryparam.arg1 = g_plant  
                # LET g_qryparam.arg2 = g_today       #TQC-AC0327 mark
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rab02       #TQC-AC0328 mod rwc04 -> rab02
                  CALL cl_set_act_visible("accept,cancel", FALSE)
                  NEXT FIELD rab02             #TQC-AC0328 mod rwc04 -> rab02
                  OTHERWISE EXIT CASE 
            END CASE
 
      END CONSTRUCT
      INPUT ARRAY g_rta FROM s_rta.*
           ATTRIBUTES(WITHOUT DEFAULTS=TRUE,COUNT=g_rta.getLength(),MAXCOUNT=g_rta.getLength(),
                     INSERT ROW=FALSE,DELETE ROW=FALSE,
                     APPEND ROW=FALSE)
 
         BEFORE INPUT
            DISPLAY "BEFORE INPUT ARRAY!"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            DISPLAY "BEFORE ROW!"
            LET l_ac = ARR_CURR()
            LET g_rec_b = ARR_COUNT()
         AFTER FIELD qty
            IF l_ac>0 THEN
               IF g_rta[l_ac].qty<=0 THEN
                  CALL cl_err('','art-096',0)
                  NEXT FIELD qty
               END IF
            END IF
         AFTER INPUT
            IF l_ac>0 THEN
               IF g_rta[l_ac].qty<=0 THEN
                  CALL cl_err('','art-096',0)
                  NEXT FIELD qty
               END IF
            END IF
      END INPUT
      
      ON ACTION search
         IF cl_null(GET_FLDBUF(ima01)) AND cl_null(GET_FLDBUF(rta05)) AND cl_null(GET_FLDBUF(rtm01))
            AND cl_null(GET_FLDBUF(rti01))                                         #TQC-AC0307
            AND cl_null(GET_FLDBUF(rtmcond)) AND cl_null(GET_FLDBUF(rtm03))
           #TQC-AC0328 ---------------mod start--------------------
           #AND cl_null(GET_FLDBUF(rwc04)) AND cl_null(GET_FLDBUF(rwbcond))
           #AND cl_null(GET_FLDBUF(rwc19)) AND cl_null(GET_FLDBUF(rwb20)) THEN
            AND cl_null(GET_FLDBUF(rab02)) AND cl_null(GET_FLDBUF(rabcond))
            AND cl_null(GET_FLDBUF(rac12)) AND cl_null(GET_FLDBUF(rac13)) THEN
           #TQC-AC0328 --------------mod end----------------------- 
            CALL cl_err('','art-121',0)
            NEXT FIELD ima01
         ELSE 
            LET g_action_choice="search"
            EXIT DIALOG
         END IF

      ON ACTION clear
         LET g_action_choice="clear"
         EXIT DIALOG
 
      ON ACTION sel_all
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="sel_all"
         EXIT DIALOG

      ON ACTION sel_none
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="sel_none"
         EXIT DIALOG

      ON ACTION print
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="print"
         EXIT DIALOG

      ON ACTION help
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         IF l_ac>0 THEN
            IF g_rta[l_ac].qty<=0 THEN
               CALL cl_err('','art-096',0)
               NEXT FIELD qty
            END IF
         END IF
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
   END DIALOG
      
END FUNCTION

FUNCTION r002_xml()
DEFINE l_channel       base.Channel
DEFINE l_time     LIKE type_file.chr20                                                                                           
DEFINE l_date1    LIKE type_file.chr20                                                                                           
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_cmd      LIKE type_file.chr1000
    LET l_date1 = g_today                                                                                                            
    LET l_time = g_time1                                                                                                              
    LET l_dt   = l_date1[1,2],l_date1[4,5],l_date1[7,8],                                                                             
                 l_time[1,2],l_time[4,5],l_time[7,8]
    LET g_name = FGL_GETENV("TEMPDIR") CLIPPED,'/',"artr002",l_dt,".xml"
    LET l_cmd  = "rm -f ",g_name
    RUN l_cmd
    LET l_channel = base.Channel.create()
    CALL l_channel.openFile(g_name,"a" )
    CALL l_channel.setDelimiter("")

    CALL l_channel.write(g_xml_out)
    CALL l_channel.close()
END FUNCTION
FUNCTION r002_xml_out()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_i,l_j            LIKE type_file.num10                  
 
   IF g_rta.getLength() = 0 THEN
      RETURN
   END IF
 
   LET l_str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>", ASCII 10,
               "<Data>", ASCII 10,
               "       <DataSet Field=\"ima01|ima02|rta05|ima021|rta03|rtg05|",
             # "rtg06|rwc13|rwc15|rwc19|rwc20|rwc21|rwc22\">", ASCII 10    #TQC-AC0328 mark
               "rtg06|rac05|rac09|rac12|rac13|rac14|rac15\">", ASCII 10    #TQC-AC0328
  
   FOR l_i = 1 TO g_rta.getLength()
       IF g_rta[l_i].sel = 'Y' THEN
          FOR l_j = 1 TO g_rta[l_i].qty
             LET l_str2 = "          <Row Data=\"",g_rta[l_i].ima01_1,"|",g_rta[l_i].ima02,"|",
                          g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",
                          g_rta[l_i].rta03,"|",g_rta[l_i].rtg05,"|",
                         #TQC-AC0328 ------------mod start---------------------
                         #g_rta[l_i].rtg06,"|",g_rta[l_i].rwc13,"|",
                         #g_rta[l_i].rwc15,"|",g_rta[l_i].rwc19_1,"|",
                         #g_rta[l_i].rwc20_1,"|",g_rta[l_i].rwc21,"|",
                         #g_rta[l_i].rwc22,"\"/>", ASCII 10
                          g_rta[l_i].rtg06,"|",g_rta[l_i].rac05,"|",
                          g_rta[l_i].rac09,"|",g_rta[l_i].rac12_1,"|",
                          g_rta[l_i].rac13_1,"|",g_rta[l_i].rac14,"|",
                          g_rta[l_i].rac15,"\"/>", ASCII 10
                         #TQC-AC0328 ------------mod end--------------------------
             LET l_str = l_str, l_str2
          END FOR
       END IF
   END FOR
   LET l_str = l_str,
               "       </DataSet>", ASCII 10,
               "</Data>", ASCII 10
 
   LET g_xml_out = l_str
   DISPLAY g_xml_out TO FORMONLY.out
END FUNCTION
FUNCTION r002_print()
DEFINE l_cmd LIKE type_file.chr100
   CALL r002_xml_out()
   CALL r002_xml()
   IF NOT p_pricetag_print(g_rza01,g_name) THEN END IF
   LET l_cmd  = "rm -f ",g_name
   RUN l_cmd
END FUNCTION

FUNCTION r002_set_visible()
   CALL cl_set_comp_visible("gb1,gb7,gb9",TRUE)
END FUNCTION

FUNCTION r002_set_no_visible(p_type)
DEFINE p_type LIKE type_file.chr1
   CASE p_type
      WHEN "1"
         CALL cl_set_comp_visible("gb7,gb9",FALSE)
      WHEN "2"
         CALL cl_set_comp_visible("gb1,gb9",FALSE)
      WHEN "3"
         CALL cl_set_comp_visible("gb1,gb7",FALSE)
      OTHERWISE EXIT CASE
   END CASE
END FUNCTION

FUNCTION r002_set_format(p_value)
DEFINE p_value  LIKE type_file.chr30
DEFINE l_str    STRING
DEFINE l_i,l_j  LIKE type_file.num5
   LET l_str=p_value
   LET l_i=l_str.getIndexOf('.',1)-1
   IF l_i=0 THEN LET l_i=1 END IF
   CASE l_i
      WHEN 1 
          LET p_value = p_value USING '&.&&'
      WHEN 2 
          LET p_value = p_value USING '#&.&&'
      WHEN 3 
          LET p_value = p_value USING '##&.&&'
      WHEN 4 
          LET p_value = p_value USING '###&.&&'
      WHEN 5 
          LET p_value = p_value USING '####&.&&'
      WHEN 6 
          LET p_value = p_value USING '#####&.&&'
      WHEN 7 
          LET p_value = p_value USING '######&.&&'
      WHEN 8 
          LET p_value = p_value USING '#######&.&&'
      WHEN 9 
          LET p_value = p_value USING '########&.&&'
      WHEN 10 
          LET p_value = p_value USING '#########&.&&'
      WHEN 11 
          LET p_value = p_value USING '##########&.&&'
      WHEN 12 
          LET p_value = p_value USING '###########&.&&'
      WHEN 13 
          LET p_value = p_value USING '############&.&&'
      WHEN 14 
          LET p_value = p_value USING '#############&.&&'
      WHEN 15 
          LET p_value = p_value USING '##############&.&&'
      WHEN 16 
          LET p_value = p_value USING '###############&.&&'
      WHEN 17 
          LET p_value = p_value USING '################&.&&'
      WHEN 18 
          LET p_value = p_value USING '#################&.&&'
      WHEN 19 
          LET p_value = p_value USING '##################&.&&'
      WHEN 20 
          LET p_value = p_value USING '###################&.&&'
   END CASE
   RETURN p_value
END FUNCTION

#FUN-A30113

