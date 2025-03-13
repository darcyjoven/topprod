# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almp420.4gl
# Descriptions...: 合同終止/到期作業
# Date & Author..: 06/08/15 By Carrier
# Modify.........: FUN-980082 09/08/19 By Carrier 移植功能調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A90049 10/09/25 By shaoyong 更新合約時一併更改合約檔的已傳POS否
# Modify.........: No.FUN-AA0006 10/10/13 By vealxu 重新規劃 lnt_file、lnu_file 資料檔, 檔案類別由原 B類(基本資料檔) 改成 T類(交易檔). 並在 lnt_file、lnu_file 加 PlantCode 欄位
# Modify.........: No.FUN-AB0031 10/11/10 By suncx POS中間庫資料下載相關程式Bug修正.
# Modify.........: No.MOD-B30300 11/03/12 By huangtao 隱藏結算商戶欄位 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B40071 11/05/06 by jason 已傳POS否狀態調整

DATABASE ds  #No.FUN-980082
 
GLOBALS "../../config/top.global"
 
DEFINE g_rec_b         LIKE type_file.num5
DEFINE g_exit          LIKE type_file.chr1
DEFINE g_wc            LIKE type_file.chr1000
DEFINE g_lnt           DYNAMIC ARRAY OF RECORD
                       sel        LIKE type_file.chr1,
                       lnt01_1    LIKE lnt_file.lnt01,
                       lnt03_1    LIKE lnt_file.lnt03,
                       lnt04_1    LIKE lnt_file.lnt04,
                       lne05_1    LIKE lne_file.lne05,
                       lnt06_1    LIKE lnt_file.lnt06,
                       lnt08_1    LIKE lnt_file.lnt08,
                       lnt09_1    LIKE lnt_file.lnt09,
                       lnt12_1    LIKE lnt_file.lnt12,
                       lne05_2    LIKE lne_file.lne05,
                       lnt15_1    LIKE lnt_file.lnt15,
                       lnt17_1    LIKE lnt_file.lnt17,
                       lnt18_1    LIKE lnt_file.lnt18,
                       lnt51_1    LIKE lnt_file.lnt51,
                       lnt21_1    LIKE lnt_file.lnt21,
                       lnt22_1    LIKE lnt_file.lnt22
                       END RECORD
DEFINE g_sql           LIKE type_file.chr1000
DEFINE l_ac            LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_argv1         LIKE type_file.chr1     #1.終止  2.到期
DEFINE g_argv2         LIKE lnt_file.lnt01     #合同
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   CASE g_argv1
        WHEN '1' LET g_prog = "almp420"
        WHEN '2' LET g_prog = "almp421"
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   IF NOT cl_null(g_argv2) THEN
      LET g_rec_b = 1
      CALL g_lnt.clear()
      LET g_lnt[1].sel = 'Y'
      LET g_lnt[1].lnt01_1 = g_argv2
      SELECT lnt06 INTO g_lnt[1].lnt06_1
        FROM lnt_file
       WHERE lnt01 = g_lnt[1].lnt01_1
      CALL s_showmsg_init()
      CALL p420_process()
      CALL s_showmsg()
   ELSE
      OPEN WINDOW p420_w WITH FORM "alm/42f/almp420"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_set_locale_frm_name("almp420")
 
      CALL cl_ui_init()
      CALL cl_set_comp_visible("lnt12",FALSE)                      #MOD-B30300  add
      CALL p420()
      CLOSE WINDOW p420_w
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p420()
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_flag1   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   CALL g_lnt.clear()
   WHILE TRUE
      LET g_exit = 'N'
      LET INT_FLAG=0
      CONSTRUCT BY NAME g_wc ON lnt01,lnt03,lnt04,lnt12,lnt06,lnt08,lnt09,
                                lnt17,lnt18,lnt51,lnt21,lnt22
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lnt01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lnt01_1"
                  IF g_argv1 = '2' THEN  #到期  小于今天
                     LET g_qryparam.where = " lnt18 < '",g_today,"' AND lntplant IN ",g_auth," " #No.FUN-A10060   #FUN-AA0006 mod lntstore -> lntplant
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt01
                  NEXT FIELD lnt01
               WHEN INFIELD(lnt04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lnt04"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060        #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt04
                  NEXT FIELD lnt04
               WHEN INFIELD(lnt06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lnt06"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060        #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt06
                  NEXT FIELD lnt06
               WHEN INFIELD(lnt08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lnt08"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060         #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt08
                  NEXT FIELD lnt08
               WHEN INFIELD(lnt09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lnt09"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060         #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt09
                  NEXT FIELD lnt09
               WHEN INFIELD(lnt12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lnt12"
                  LET g_qryparam.where = " lntplant IN ",g_auth," " #No.FUN-A10060         #FUN-AA0006 mod lntstore -> lntplant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnt12
                  NEXT FIELD lnt12
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION help
            CALL cl_show_help()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lntuser', 'lntgrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p420_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      CALL p420_b_fill()
 
      IF g_exit='Y' THEN
         CONTINUE WHILE
      END IF
 
      CALL p420_b()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p420_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      LET l_flag1 = 'N'
      FOR l_i = 1 TO g_rec_b
          IF g_lnt[l_i].sel = 'Y' THEN
             LET l_flag1 = 'Y'
          END IF
      END FOR
      IF l_flag1 = 'N' THEN CONTINUE WHILE END IF
      IF cl_sure(0,0) THEN
         LET g_success='Y'
         BEGIN WORK
         CALL s_showmsg_init()
         CALL p420_process()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         CLEAR FORM
         CALL g_lnt.clear()
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p420_b_fill()
 
   LET g_sql = " SELECT 'N',lnt01,lnt03,lnt04,'',lnt06,lnt08,lnt09,",
               "        lnt12,'',",
               "        lnt15,lnt17,lnt18,lnt51,lnt21,lnt22 ",
               "   FROM lnt_file ",
               "  WHERE lnt26 = 'Y' ",             #已審核
               "    AND lntplant = '",g_plant,"'",    #只能中止自己門店的資料    #FUN-AA0006 mod lntstore -> lntplant
               "    AND ",g_wc CLIPPED
   IF g_argv1 = '2' THEN  #到期
      LET g_sql = g_sql CLIPPED,"    AND lnt18 < '",g_today,"'"
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lnt01 "
 
   PREPARE p420_prepare FROM g_sql
   DECLARE p420_cur CURSOR FOR p420_prepare
 
   CALL g_lnt.clear()
   LET g_cnt = 1
   FOREACH p420_cur INTO g_lnt[g_cnt].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT lne05 INTO g_lnt[g_cnt].lne05_1
        FROM lne_file
       WHERE lne01 = g_lnt[g_cnt].lnt04_1
      SELECT lne05 INTO g_lnt[g_cnt].lne05_2
        FROM lne_file
       WHERE lne01 = g_lnt[g_cnt].lnt12_1
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lnt.deleteElement(g_cnt)
   IF g_cnt= 1 THEN CALL cl_err('','mfg3442',0) LET g_exit = 'Y' END IF
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION p420_b()
 
   LET l_ac = 1
   INPUT ARRAY g_lnt WITHOUT DEFAULTS FROM s_lnt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE, DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION select_all
         CALL p420_sel_all("Y")
 
      ON ACTION select_non
         CALL p420_sel_all("N")
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         CONTINUE INPUT
 
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
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
END FUNCTION
 
FUNCTION p420_sel_all(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_lnt.getLength()
       LET g_lnt[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p420_process()
   DEFINE l_i     LIKE type_file.num10
   DEFINE l_stat  LIKE type_file.chr1
   DEFINE l_lntpos  LIKE lnt_file.lntpos #NO.FUN-B40071
   FOR l_i = 1 TO g_rec_b
       IF g_lnt[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
 
       #1.合同狀態-終止/到期
       IF g_argv1 = '1' THEN
          UPDATE lnt_file SET lnt26 = 'S',   #終止
                              lnt23 = g_today,
                              lnt34 = g_user,
                              lntmodu = g_user,   #FUN-AB0031 add 
                              lntdate = g_today   #FUN-AB0031 add 
           WHERE lnt01 = g_lnt[l_i].lnt01_1
       ELSE
          UPDATE lnt_file SET lnt26 = 'E'    #到期
           WHERE lnt01 = g_lnt[l_i].lnt01_1
       END IF
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('lnt01',g_lnt[l_i].lnt01_1,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF

       #No.FUN-A90049 add start------------------     
       IF g_aza.aza88 = 'Y' THEN        

          #FUN-B40071 --START--
           #UPDATE lnt_file SET lntpos = '2'
           #   WHERE lnt01 = g_lnt[l_i].lnt01_1          
          SELECT lntpos INTO l_lntpos FROM lnt_file
             WHERE lnt01 = g_lnt[l_i].lnt01_1
          IF l_lntpos <> '1' THEN
             UPDATE lnt_file SET lntpos = '2'
               WHERE lnt01 = g_lnt[l_i].lnt01_1
          ELSE
             UPDATE lnt_file SET lntpos = '1'
               WHERE lnt01 = g_lnt[l_i].lnt01_1
          END IF
          #FUN-B40071 --START--
          
           
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL s_errmsg('lnt01',g_lnt[l_i].lnt01_1,'',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       END IF     
       #No.FUN-A90049 add end  ------------------
 
       #2.攤位狀態-未使用
       UPDATE lmf_file SET lmf05 = '0'
        WHERE lmf01 = g_lnt[l_i].lnt06_1
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('lmf01',g_lnt[l_i].lnt06_1,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
 
       #3.場地狀態 - N.未使用
       UPDATE lmd_file SET lmd07 = 'N'
        WHERE lmd01 IN (SELECT lmh03 FROM lmh_file,lmg_file
                         WHERE lmg01 = lmh01
                           AND lmg08 = 'Y'
                           AND lmg02 = g_lnt[l_i].lnt06_1
                           AND lmh02 = lmg02
                           AND lmh06 = 'Y')
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('lmh02',g_lnt[l_i].lnt06_1,'upd lmd07',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       
       #4.場攤關系單身 - 場攤關系 無效
       UPDATE lmh_file SET lmh06 = 'N' 
        WHERE lmh02 = g_lnt[l_i].lnt06_1
          AND lmh01 IN (SELECT lmg01 FROM lmg_file 
                         WHERE lmg02 = g_lnt[l_i].lnt06_1
                           AND lmg08 = 'Y')
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('lmh02',g_lnt[l_i].lnt06_1,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
 
       #5.場攤關系單頭狀態-終止/到期
       IF g_argv1 = '1' THEN
          UPDATE lmg_file SET lmg08 = 'S', #終止
                              lmg12 = g_user,
                              lmg13 = g_today
           WHERE lmg02 = g_lnt[l_i].lnt06_1
             AND lmg08 = 'Y'
       ELSE
          UPDATE lmg_file SET lmg08 = 'E'  #到期
           WHERE lmg02 = g_lnt[l_i].lnt06_1
             AND lmg08 = 'Y'
       END IF
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('lmf01',g_lnt[l_i].lnt06_1,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
   END FOR
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
