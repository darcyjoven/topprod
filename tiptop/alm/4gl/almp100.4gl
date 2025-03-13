# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almp100.4gl
# Descriptions...: 招商狀態更新作業
# Date & Author..: No:FUN-BA0118 11/11/04 By baogc
# Modify.........: No:FUN-C20078 12/02/15 By nanbing 將 almp100與almp101 合併
# Modify.........: No:TQC-C30008 12/03/01 By shiwuying 预租结束(终止/到期)也要更新摊位状态
# Modify.........: No:MOD-C30411 12/03/14 By xumeimei rtz01抓当前营运中心资料
# Modify.........: No:FUN-C50036 12/05/22 By fanbj 終止變更時，update POS狀態
# Modify.........: No:FUN-C70094 12/07/23 By Lori "UPDATE ",cl_get_target_table改成"UPDATE ",cl_get_target_table    #FUN-C70094 UPDATE後面家空格
# Modify.........: No:FUN-C70115 12/07/26 By nanbing almp100邏輯調整，把攤位資料記錄放到最前面處理
# Modify.........: No.CHI-C80041 13/01/04 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
              wc    STRING,
              date  DATE,
              bgjob LIKE type_file.chr1
          END RECORD
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num5
DEFINE g_change_lang   LIKE type_file.chr1

MAIN
DEFINE l_flag LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET tm.date  = ARG_VAL(2)
   LET tm.bgjob = ARG_VAL(3)
   IF cl_null(tm.bgjob) THEN
      LET tm.bgjob = "N"
   END IF
   
   IF NOT cl_user() THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF NOT cl_setup("ALM") THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   ERROR ""
   LET g_success = 'Y'
   WHILE TRUE
      IF tm.bgjob = "N" THEN
         CALL p100_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()
            CALL almp100()
            CALL s_showmsg()
            IF g_success = 'Y' THEN 
               IF g_cnt > 0 THEN
                  COMMIT WORK
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  ROLLBACK WORK
                  CALL cl_err('','aco-058',0) #無符合的資料
                  LET l_flag = TRUE
               END IF
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF 
            IF l_flag THEN
               CONTINUE WHILE 
            ELSE
               CLOSE WINDOW p100_w
               EXIT WHILE 
            END IF 
         ELSE
            CONTINUE WHILE 
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         IF cl_null(tm.date) THEN
            LET tm.date = g_today
         END IF
         CALL almp100()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK 
         ELSE
            ROLLBACK WORK 
         END IF 
         EXIT WHILE 
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p100_tm()
DEFINE lc_cmd  STRING
DEFINE l_zz08  LIKE zz_file.zz08

   IF s_shut(0) THEN RETURN END IF

   OPEN WINDOW p100_w WITH FORM "alm/42f/almp100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('z')

   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL
      LET tm.bgjob = 'N'
      LET tm.date  = TODAY
      DIALOG
         CONSTRUCT BY NAME tm.wc ON rtz01
            BEFORE CONSTRUCT 
               CALL cl_qbe_init()
               
            ON ACTION controlp
               CASE
                  WHEN INFIELD(rtz01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rtz1"
                     LET g_qryparam.where = " rtz28 = 'Y' AND rtz01 IN ",g_auth CLIPPED
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rtz01
                     NEXT FIELD rtz01

                  OTHERWISE 
                     EXIT CASE 
               END CASE 
         END CONSTRUCT

         INPUT tm.date,tm.bgjob FROM date,bgjob ATTRIBUTE(WITHOUT DEFAULTS)

            AFTER FIELD bgjob
               IF tm.bgjob NOT MATCHES "[YN]" OR cl_null(tm.bgjob) THEN 
                  NEXT FIELD bgjob            
               END IF
         END INPUT 
         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT DIALOG
      END DIALOG
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF 

      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF

      IF tm.bgjob = "Y" THEN
         SELECT zz08 INTO l_zz08 FROM zz_file
          WHERE zz01 = "almp100"
         IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
            CALL cl_err('almp100','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"' ",
                         " '",tm.date CLIPPED,"' ",
                         " '",tm.bgjob CLIPPED,"' "
            CALL cl_cmdat('almp100',g_time,lc_cmd CLIPPED)
         END IF 
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      EXIT WHILE 
   END WHILE 
END FUNCTION 

FUNCTION almp100()
 DEFINE l_sql      STRING
 DEFINE l_rtz01    LIKE rtz_file.rtz01

   LET g_cnt = 0
   #LET l_sql = "SELECT rtz01 FROM rtz_file WHERE ",tm.wc CLIPPED   #MOD-C30411 mark
   LET l_sql = "SELECT rtz01 FROM rtz_file WHERE ",tm.wc CLIPPED,   #MOD-C30411 add
               "   AND rtz01 IN ",g_auth CLIPPED                    #MOD-C30411 add
   PREPARE sel_rtz_pre FROM l_sql
   DECLARE sel_rtz_cs CURSOR FOR sel_rtz_pre
   FOREACH sel_rtz_cs INTO l_rtz01
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF 
      #CALL p100_p1(l_rtz01) #FUN-C70115 mark 
      CALL p100_p2(l_rtz01)
      CALL p100_p1(l_rtz01) #FUN-C70115 add
   END FOREACH
END FUNCTION 
#FUN-C20078 STA----
#
FUNCTION p100_p1(l_rtz01)
 DEFINE l_sql      STRING
 DEFINE l_n        LIKE type_file.num5
 DEFINE l_lih01    LIKE lih_file.lih01
 DEFINE l_lih07    LIKE lih_file.lih07
 DEFINE l_lih14    LIKE lih_file.lih14
 DEFINE l_lih15    LIKE lih_file.lih15
 DEFINE l_rtz01    LIKE rtz_file.rtz01
 DEFINE l_lji01    LIKE lji_file.lji01
    IF tm.date <> TODAY THEN
       RETURN
    END IF
    #遍歷合同變更單 - 合同終止處理
    #1.更新合同狀態為s.終止
    #LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lnt_file')," SET lnt26 = 'S'", #FUN-C50036 mark
    LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lnt_file')," SET lnt26 = 'S',", #FUN=C50036 add
                "       lntpos = (CASE lntpos WHEN '3' THEN '2' ELSE lntpos END ) ",    #FUN-C50036 add
                " WHERE lnt01 IN (SELECT lji04 ",                                      #合同編號
                "                   FROM ",cl_get_target_table(l_rtz01,'lji_file'),
                "                  WHERE lji02 = '5' ",                                #變更類型 5.終止
                "                    AND ljiconf <> 'X' ", #CHI-C80041
                "                    AND lji29 = '",tm.date - 1,"' ",                  #終止清算日期
                "                    AND ljiplant = '",l_rtz01,"') "
    PREPARE upd_lnt_pre1 FROM l_sql
    EXECUTE upd_lnt_pre1
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lnt',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
      #By shi Begin---
      #产生所有未产生的费用单
       LET l_sql = "SELECT lji01 FROM ",cl_get_target_table(l_rtz01,'lji_file'),
                   " WHERE lji02 = '5' ",
                   "   AND ljiconf <> 'X' ", #CHI-C80041
                   "   AND lji29 = '",tm.date-1,"'",
                   "   AND ljiplant = '",l_rtz01,"'"
       PREPARE p100_sel_lji_pre FROM l_sql
       DECLARE p100_sel_lji_cs CURSOR FOR p100_sel_lji_pre
       FOREACH p100_sel_lji_cs INTO l_lji01
          IF STATUS THEN
             CALL s_errmsg('','','p100_sel_lji_cs',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          
          CALL i400sub_upd_lnt('2',l_lji01,tm.date-1,l_rtz01)
       END FOREACH
      #By shi End-----
    END IF
    #2.更新攤位狀態為1.未出租
    #LET l_sql = "UPDATE lmf_file SET lmf05 = '1'",                                    #FUN-C50036 mark
    LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lmf_file')," SET lmf05 = '1' ", #FUN-C50036 add
                " WHERE lmf01 IN (SELECT lji08 ",                                      #攤位編號
                "                   FROM ",cl_get_target_table(l_rtz01,'lji_file'),
                "                  WHERE lji02 = '5' ",                                #變更類型 5.終止
                "                    AND ljiconf <> 'X' ", #CHI-C80041
                "                    AND lji29 = '",tm.date - 1,"' ",                  #終止清算日期
                "                    AND ljiplant = '",l_rtz01,"') "
    PREPARE upd_lmf_pre1 FROM l_sql
    EXECUTE upd_lmf_pre1
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lmf',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
    END IF

   #TQC-C30008 Begin---
    #预租协议到期，更新摊位状态为未出租，终止在almt320中已做了，这里不需要处理
    #LET l_sql = "UPDATE lmf_file SET lmf05 = '1'",                                    #FUN-C50036 mark
     LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lmf_file')," SET lmf05 = '1' ", #FUN-C50036 add
                " WHERE lmf01 IN (SELECT lih07 ",                                      #攤位編號
                "                   FROM ",cl_get_target_table(l_rtz01,'lih_file'),
                "                  WHERE lihconf = 'Y' ",
                "                    AND lih15 = '",tm.date - 1,"' ",
                "                    AND lihplant = '",l_rtz01,"') "
    PREPARE upd_lmf_pre1_1 FROM l_sql
    EXECUTE upd_lmf_pre1_1
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lmf',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
    END IF
   #TQC-C30008 End-----
      
    #遍歷合同 - 合同開始與合同到期處理
    #合同到期 -- 更新合同為E.到期
    #LET l_sql = "UPDATE lnt_file SET lnt26 = 'E' ",                                              #FUN-C50036 mark
    LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lnt_file')," SET lnt26 = 'E' ,",           #FUN-C50036 add
                "                    lntpos = (CASE lntpos WHEN '3' THEN '2' ELSE lntpos END ) ", #FUN-C50036 add
                " WHERE lnt01 IN (SELECT lnt01 ",
                "                   FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                "                  WHERE lnt18 = '",tm.date -1,"' ",
                "                    AND lntplant = '",l_rtz01,"') "
    PREPARE upd_lnt_pre2 FROM l_sql
    EXECUTE upd_lnt_pre2
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lnt',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
    END IF
    #合同到期 -- 更新攤位狀態為1.未出租
    #LET l_sql = "UPDATE lmf_file SET lmf05 = '1' ",                                      #FUN-C50036 mark
    LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lmf_file')," SET lmf05 = '1' ",    #FUN-C50036 add
                " WHERE lmf01 IN (SELECT lnt06 ",
                "                   FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                "                  WHERE lnt18 = '",tm.date -1,"' ",
                "                    AND lntplant = '",l_rtz01,"') "
    PREPARE upd_lmf_pre2 FROM l_sql
    EXECUTE upd_lmf_pre2
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lmf',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
    END IF
    #合同開始 -- 更新攤位狀態為2.已出租
    #LET l_sql = "UPDATE lmf_file SET lmf05 = '2' ",                                      #FUN-C50036 mark
    LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'lmf_file')," SET lmf05 = '2' ",    #FUN-C70094 add UPDATE後面家空格    #FUN-C50036 add
                " WHERE lmf01 IN (SELECT lnt06 ",
                "                   FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                "                  WHERE lnt17 = '",tm.date,"' ",
                "                    AND lntplant = '",l_rtz01,"') "
    PREPARE upd_lmf_pre3 FROM l_sql
    EXECUTE upd_lmf_pre3
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','upd lmf',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    ELSE
       LET g_cnt = g_cnt + SQLCA.sqlerrd[3]
    END IF

    #遍歷預租協議 - 預租開始處理
    LET l_sql = "SELECT lih01,lih07 ",        #攤位預租協議單號,攤位編號
                "  FROM ",cl_get_target_table(l_rtz01,'lih_file'),
                " WHERE lih14 = '",tm.date,"' ",
                "   AND lihconf = 'Y' ", #FUN-C20078 By shi Add
                "   AND lihplant = '",l_rtz01,"' "
    PREPARE sel_lih_pre FROM l_sql
    DECLARE sel_lih_cs CURSOR FOR sel_lih_pre
    FOREACH sel_lih_cs INTO l_lih01,l_lih07
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF 
       #SELECT lih14,lih15 INTO l_lih14,l_lih15 FROM lih_file WHERE lih01 = l_lih01       #FUN-C50036 mark
       #FUN-C50036--start add-----------------------------------------------------------
       LET l_sql = "SELECT lih14,lih15 FROM ",cl_get_target_table(l_rtz01,'lih_file') , 
                   " WHERE lih01 = '",l_lih01,"'"
       PREPARE sel_lih_add FROM l_sql
       EXECUTE sel_lih_add INTO l_lih14,l_lih15
               
       #檢查預租期內是否存在其他預租協議
       LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'lih_file'),       
                   " WHERE lih <> '",l_lih01,"'",
                   "   AND lih07 = '",l_lih07,"'",
                   "   AND ((lih14 <= '",l_lih15,"' AND lih14 >= '",l_lih14,"') ",
                   "     OR (lih15 <= '",l_lih15,"' AND lih15 >= '",l_lih14,"') ",    
                   "     OR (lih14 <= '",l_lih14,"' AND lih15 >= '",l_lih15,"')) "
       PREPARE sel_lih_add1 FROM l_sql 
       EXECUTE sel_lih_add1 INTO l_n
       #FUN-C50036--end add----------------------------------------------------------------

       #FUN-C50036--start mark----------------------------- 
       #SELECT COUNT(*) INTO l_n 
       #  FROM lih_file 
       # WHERE lih01 <> l_lih01 
       #   AND (   (lih14 <= l_lih15 AND lih14 >= l_lih14) 
       #        OR (lih15 <= l_lih15 AND lih15 >= l_lih14) 
       #        OR (lih14 <= l_lih14 AND lih15 >= l_lih15))
       #   AND lih07 = l_lih07
       #FUN-C50036--end mark--------------------------------

       IF l_n > 0 THEN
          CALL s_errmsg('','','sel_lih','alm1456',1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       #檢查預租期內是否存在合同
       #FUN-C50036--start mark-----------------------------
       #SELECT COUNT(*) INTO l_n 
       #  FROM lnt_file
       # WHERE (   (lnt17 <= l_lih15 AND lnt17 >= l_lih14)
       #        OR (lnt18 <= l_lih15 AND lnt18 >= l_lih14)
       #        OR (lnt17 <= l_lih14 AND lnt18 >= l_lih15))
       #   AND lnt06 = l_lih07
       #   AND lnt26 <> 'S' AND lnt26 <> 'E'
       #FUN-C50036--end mark--------------------------------  

       #FUN-C50036--start add-------------------------------------------------------
       LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                   " WHERE lnt06 = '",l_lih07,"'",
                   "   AND lnt26 <> 's' ",
                   "   AND lnt26 <> 'E' ",
                   "   AND ((lnt17 <= '",l_lih15,"' AND lnt17 >= '",l_lih14,"') ",
                   "     OR (lnt18 <= '",l_lih15,"' AND lnt16 >= '",l_lih14,"') ",
                   "     OR (lnt17 <= '",l_lih14,"' AND lnt18 >= '",l_lih15,"')) "

       PREPARE sel_lih_add2 FROM l_sql
       EXECUTE sel_lih_add2 INTO l_n  
       #FUN-C50036--end add---------------------------------------------------------
 
       IF l_n > 0 THEN
          CALL s_errmsg('','','sel_lnt','alm1457',1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       #預租開始 -- 更新攤位狀態為3.預租
       #UPDATE lmf_file SET lmf05 = '3' WHERE lmf01 = l_lih07                  #FUN-C50036 mark
       #FUN-C50036--start add------------------------------------------
       LET l_sql = " UPDATE ",cl_get_target_table(l_rtz01,'lmf_file') ,
                   "    SET lmf05 = '3' ",
                   "  WHERE lmf01 = '",l_lih07,"'"
       PREPARE upd_lmf_add FROM l_sql
       EXECUTE upd_lmf_add     
       #FUN-C50036--end add--------------------------------------------
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','upd lmf',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       ELSE
          LET g_cnt = g_cnt + 1
       END IF
    END FOREACH

END FUNCTION

FUNCTION p100_p2(l_rtz01)
 DEFINE l_sql      STRING
 DEFINE l_n        LIKE type_file.num5
 DEFINE g_lmf      LIKE type_file.chr1
 DEFINE l_lie04    LIKE lie_file.lie04
 DEFINE l_lml02    LIKE lml_file.lml02
 DEFINE l_rtz01    LIKE rtz_file.rtz01
 DEFINE l_ogb14t   LIKE ogb_file.ogb14t
 DEFINE l_ohb14t   LIKE ohb_file.ohb14t
 DEFINE l_oha23    LIKE oha_file.oha23
 DEFINE l_oga23    LIKE oga_file.oga23
 DEFINE l_amt      LIKE ogb_file.ogb14t
 DEFINE l_oaz52    LIKE oaz_file.oaz52
 DEFINE l_lix      RECORD LIKE lix_file.*
 DEFINE l_lmf      RECORD LIKE lmf_file.*
    LET l_sql = "DELETE FROM ",cl_get_target_table(l_rtz01,'lix_file'),
                " WHERE lixplant = '",l_rtz01,"' ",
                "   AND lix02 = '",tm.date - 1 ,"' "
    PREPARE del_lix FROM l_sql
    EXECUTE del_lix
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','','del_lix',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF            
    LET l_sql = "SELECT * FROM ",cl_get_target_table(l_rtz01,'lmf_file'),
                " WHERE lmf06 = 'Y' ",
                "   AND lmfstore = '",l_rtz01,"'"
    PREPARE sel_lmf01_pre FROM l_sql
    DECLARE sel_lmf01_cs CURSOR FOR sel_lmf01_pre
    FOREACH sel_lmf01_cs INTO l_lmf.*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       INITIALIZE l_lix.* TO NULL
       LET l_lix.lix01 = l_lmf.lmf01
       LET l_lix.lix02 = tm.date - 1
       LET l_lix.lix03 = ''
       LET l_lix.lix04 = l_lmf.lmf03
       LET l_lix.lix05 = l_lmf.lmf04
       LET l_sql = " SELECT COUNT(DISTINCT(lie04)) FROM ",cl_get_target_table(l_rtz01,'lie_file'),
                   "  WHERE lie01 = '",l_lmf.lmf01,"' ",
                   "    AND liestore = '",l_rtz01,"'"
       PREPARE sel_l_n FROM l_sql
       EXECUTE sel_l_n INTO l_n 
       IF l_n > 1 THEN      
          LET l_lix.lix06 = ''
       ELSE
          LET l_sql = " SELECT DISTINCT(lie04) FROM ",cl_get_target_table(l_rtz01,'lie_file'),
                      "  WHERE lie01 = '",l_lmf.lmf01,"' ",
                      "    AND liestore = '",l_rtz01,"'"
          PREPARE sel_lie04 FROM l_sql
          EXECUTE sel_lie04 INTO l_lix.lix06
       END IF
       LET l_sql = " SELECT lml02 FROM ",cl_get_target_table(l_rtz01,'lml_file'),
                   "  WHERE lml01 = '",l_lmf.lmf01,"' ",
                   "    AND lml06 = 'Y' ",
                   "    AND lmlstore = '",l_rtz01,"'"
       PREPARE sel_lml FROM l_sql
       EXECUTE sel_lml INTO l_lix.lix07
       LET l_lix.lix08 = l_lmf.lmf12
       LET l_lix.lix09 = l_lmf.lmf05
       LET l_lix.lix10 = l_lmf.lmf06   
       IF l_lmf.lmf05 = '2' THEN 
          LET l_lix.lix11 = '1'
          LET l_sql = " SELECT lnt01,lnt02,lnt04,lnt69 FROM ",
                      cl_get_target_table(l_rtz01,'lnt_file'),
                      "  WHERE lnt06 =  '",l_lmf.lmf01,"' ",
                      "    AND lnt17 <= '",tm.date-1,"' ",
                      "    AND lnt18 >= '",tm.date-1,"' ",
                      "    AND lnt26 =  'Y' ",
                      "    AND lntplant = '",l_rtz01,"'"
          PREPARE sel_lnt_pre FROM l_sql
          EXECUTE sel_lnt_pre INTO l_lix.lix12,l_lix.lix13,l_lix.lix14,l_lix.lix18 

          
          LET l_sql = "SELECT oaz52 FROM ",cl_get_target_table(l_rtz01,'oaz_file'),
                       " WHERE oaz00 = '0'"
          PREPARE p100_exp30 FROM l_sql
          EXECUTE p100_exp30 INTO l_oaz52
          LET l_ogb14t = 0
          LET l_sql = "SELECT oga23,SUM(ogb14t) FROM ",cl_get_target_table(l_rtz01,'ogb_file'),",",
                                                 cl_get_target_table(l_rtz01,'oga_file'),
                      " WHERE oga01 = ogb01 ",
                      "   AND ogaconf = 'Y' AND ogapost = 'Y' ",
                      "   AND ogb48 = '",l_lmf.lmf01,"'",
                      "   AND oga02 = '",tm.date-1,"'",
                      " GROUP BY oga23 "
          PREPARE p100_sel_oga FROM l_sql
          DECLARE p100_sel_oga_cs CURSOR FOR p100_sel_oga
          FOREACH p100_sel_oga_cs INTO l_oga23,l_amt
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','foreach oga :',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF 
             LET l_amt = l_amt * s_curr2(l_oga23,tm.date - 1,l_oaz52,l_rtz01)
             LET l_ogb14t = l_ogb14t + l_amt
          END FOREACH    
          IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
          LET l_ohb14t = 0
          LET l_sql = "SELECT oha23,SUM(ohb14t) FROM ",cl_get_target_table(l_rtz01,'ohb_file'),",",
                                                 cl_get_target_table(l_rtz01,'oha_file'),
                      " WHERE oha01 = ohb01 ",
                      "   AND ohaconf = 'Y' AND ohapost = 'Y' ",
                      "   AND ohb69 = '",l_lmf.lmf01,"'",
                      "   AND oha02 = '",tm.date -1,"'",
                      " GROUP BY oha23 "
          PREPARE p100_sel_oha FROM l_sql
          DECLARE p100_sel_oha_cs CURSOR FOR p100_sel_oha
          FOREACH p100_sel_oha_cs INTO l_oha23,l_amt
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','foreach oha:',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF 
             LET l_amt = l_amt * s_curr2(l_oha23,tm.date - 1,l_oaz52,l_rtz01)
             LET l_ohb14t = l_ohb14t + l_amt
          END FOREACH 
          IF cl_null(l_ohb14t) THEN LET l_ohb14t = 0 END IF
          LET l_lix.lix19 = l_ogb14t - l_ohb14t
       END IF 
       IF l_lmf.lmf05 = '3' THEN 
          LET l_lix.lix11 = '2'
          LET l_sql = " SELECT lih01,lih08,lih11 FROM ",cl_get_target_table(l_rtz01,'lih_file'),                                                                                    
                      "  WHERE lih07 = '",l_lmf.lmf01,"' ",
                      "    AND lih14 <= '",tm.date - 1,"' ",
                      "    AND lih15 >= '",tm.date - 1,"' ",
                      "    AND lihconf = 'Y' ",
                      "    AND lihplant = '",l_rtz01,"'"
          PREPARE p100_sel_lih FROM l_sql
          EXECUTE p100_sel_lih INTO l_lix.lix12,l_lix.lix14,l_lix.lix18
       END IF 
       LET l_lix.lix15 = l_lmf.lmf09
       LET l_lix.lix16 = l_lmf.lmf10 
       LET l_lix.lix17 = l_lmf.lmf11 
       IF cl_null(l_lix.lix11) THEN LET l_lix.lix11 = ' ' END IF
       IF cl_null(l_lix.lix15) THEN LET l_lix.lix15 = 0 END IF
       IF cl_null(l_lix.lix16) THEN LET l_lix.lix16 = 0 END IF
       IF cl_null(l_lix.lix17) THEN LET l_lix.lix17 = 0 END IF
       IF cl_null(l_lix.lix18) THEN LET l_lix.lix18 = 0 END IF         
       IF cl_null(l_lix.lix19) THEN LET l_lix.lix19 = 0 END IF  
       SELECT azw02 INTO l_lix.lixlegal
         FROM azw_file WHERE azw01 = l_rtz01
       LET g_sql = "INSERT INTO ",cl_get_target_table(l_rtz01,'lix_file'),"(",
                   "         lix01,lix02,lix03,lix04,lix05,lix06,lix07,lix08,",
                   "         lix09,lix10,lix11,lix12,lix13,lix14,lix15,lix16,",
                   "         lix17,lix18,lix19,lixlegal,lixplant )",
                   "  VALUES(?,?,?,?,?,?,?,?,",
                   "         ?,?,?,?,?,?,?,?,",
                   "         ?,?,?,?,? )"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
       CALL cl_parse_qry_sql(g_sql,l_rtz01) RETURNING g_sql 
       PREPARE lix_ins FROM g_sql
       EXECUTE lix_ins USING l_lix.lix01,l_lix.lix02,l_lix.lix03,
                             l_lix.lix04,l_lix.lix05,l_lix.lix06,l_lix.lix07,
                             l_lix.lix08,l_lix.lix09,l_lix.lix10,l_lix.lix11,
                             l_lix.lix12,l_lix.lix13,l_lix.lix14,l_lix.lix15,
                             l_lix.lix16,l_lix.lix17,l_lix.lix18,l_lix.lix19, 
                             l_lix.lixlegal,l_rtz01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL s_errmsg('','','ins lix',SQLCA.sqlcode,1)
          LET g_success = 'N'
       ELSE
          LET g_cnt = g_cnt + SQLCA.SQLERRD[3]   
       END IF       
    END FOREACH     
END FUNCTION 
#FUN-C20078 END---
#FUN-BA0118
