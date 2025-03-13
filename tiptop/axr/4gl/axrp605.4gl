# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axrp605.4gl
# Descriptions...: 費用單整批生成應收還原作業
# Date & Author..: FUN-C30029 12/03/21 By zhangweib
# Modify.........: No.TQC-C40058 12/04/11 By zhangweib axrp605畫面新增年度期別欄位,
#                                                     還原費用單單身資料時,按照日期從大到小還原

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc          STRING                    #QBE_1的條件
DEFINE g_wc1         STRING                    #QBE_1的條件
DEFINE g_sql         STRING                    #組SQL
DEFINE g_oma         RECORD LIKE oma_file.*    #應收/待抵帳款單頭檔
DEFINE g_ooa         RECORD LIKE ooa_file.*
DEFINE g_oow         RECORD LIKE oow_file.*
DEFINE g_lub10       LIKE lub_file.lub10
DEFINE g_lub14       LIKE lub_file.lub14
DEFINE g_lua37       LIKE lua_file.lua37
DEFINE g_t1          LIKE ooy_file.ooyslip
DEFINE g_plant_new   LIKE type_file.chr21
DEFINE b_oob         RECORD LIKE oob_file.*
DEFINE g_forupd_sql  STRING
DEFINE tot1          LIKE type_file.num20_6
DEFINE tot2          LIKE type_file.num20_6
DEFINE tot3          LIKE type_file.num20_6
DEFINE un_pay1       LIKE type_file.num20_6
DEFINE un_pay2       LIKE type_file.num20_6
DEFINE g_msg         LIKE type_file.chr1000
DEFINE g_cnt         LIKE type_file.num5
DEFINE m_oma01       LIKE oma_file.oma01
DEFINE m_oma05       LIKE oma_file.oma05
DEFINE m_omb31       LIKE omb_file.omb31
DEFINE g_chr         LIKE type_file.chr1
DEFINE g_chr2        LIKE type_file.chr1
DEFINE i             LIKE type_file.num5
DEFINE g_str         STRING
#No.TQC-C40058   ---start---   Add
DEFINE tm            RECORD
         yy          LIKE type_file.num5,
         mm          LIKE type_file.num5
                     END RECORD
DEFINE g_lub10_o     LIKE lub_file.lub10
DEFINE g_lui03       LIKE lui_file.lui03
#No.TQC-C40058   ---end---     Add

MAIN
   DEFINE l_flag     LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_wc    = ARG_VAL(1)             #QBE參數一
   LET g_wc    = cl_replace_str(g_wc, "\\\"", "'")
   LET g_wc1   = ARG_VAL(2)             #QBE參數二
   LET g_wc1   = cl_replace_str(g_wc1, "\\\"", "'")
   LET tm.yy   = ARG_VAL(3)             #年度   #No.TQC-C40058   Add
   LET tm.mm   = ARG_VAL(4)             #期別   #No.TQC-C40058   Add
   LET g_bgjob = ARG_VAL(5)                     #No.TQC-C40058   Add
  #LET g_bgjob = ARG_VAL(3)                     #No.TQC-C40058   Mark

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT * INTO g_oow.* FROM oow_file

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p605()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p605_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL s_showmsg()
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p605
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p605_1()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL cl_err('','lib-284',1)
         ELSE
            CALL s_showmsg()
            ROLLBACK WORK
            CALL cl_err('','abm-020',1)
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p605()

   LET g_wc = NULL   #No.TQC-C40058   Add
   LET g_wc = NULL   #No.TQC-C40058   Add
   INITIALIZE tm.* TO NULL   #No.TQC-C40058   Add

   OPEN WINDOW p605 WITH FORM "axr/42f/axrp605"
      ATTRIBUTE (STYLE = g_win_style)

      CALL cl_ui_init()

      CLEAR FORM

      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON azp01

            BEFORE CONSTRUCT
               IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF
               IF cl_null(tm.yy) THEN LET tm.yy = YEAR(g_today) END IF   #No.TQC-C40058   Add
               IF cl_null(tm.mm) THEN LET tm.mm = MONTH(g_today) END IF  #No.TQC-C40058   Add
               DISPLAY BY NAME tm.*                                      #No.TQC-C40058   Add

         END CONSTRUCT

         CONSTRUCT BY NAME g_wc1 ON lua01

            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT

        #No.TQC-C40058   ---start---  Add
         INPUT BY NAME tm.yy,tm.mm
         END INPUT
        #No.TQC-C40058   ---end---    Add
         
         ON ACTION controlp
            CASE
               WHEN INFIELD(azp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azw"
                  LET g_qryparam.where ="azw02 = '",g_legal,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01
               WHEN INFIELD(lua01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_lua01"
                  LET g_qryparam.where = "lua15 = 'Y'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lua01
                  NEXT FIELD lua01
               OTHERWISE EXIT CASE
            END CASE

          ON ACTION controls
            CALL cl_set_head_visible("","AUTO")

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION accept
            EXIT DIALOG
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

      END DIALOG
      IF INT_FLAG THEN
         CLOSE WINDOW p605
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

END FUNCTION

FUNCTION p605_1()
   DEFINE l_lub14_1    LIKE lub_file.lub14
   DEFINE l_lub01      LIKE lub_file.lub01

   #抓取符合用戶QBE1條件的當前法人下的所有營運中心
   LET g_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azw02 = '",g_legal,"' AND ",g_wc CLIPPED
   PREPARE p605_sel_azw FROM g_sql
   DECLARE p605_azw_curs CURSOR FOR p605_sel_azw

   #鎖axrt400的資料
   LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_cl CURSOR FROM g_forupd_sql

   #鎖axrt300的資料
   LET g_forupd_sql = "SELECT * FROM oma_file WHERE oma01 = ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t300_cl CURSOR FROM g_forupd_sql

   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'

   LET g_lub14 = NULL
   CALL s_showmsg_init()
   BEGIN WORK

   FOREACH p605_azw_curs INTO g_plant_new

     #No.TQC-C40058   ---start---   Mark
     #LET g_sql = "SELECT DISTINCT lub14,lub10,lub01,lua37,ooa01 ",
     #            "  FROM ",cl_get_target_table(g_plant_new,'lua_file'),
     #                  ",",cl_get_target_table(g_plant_new,'lub_file'),
     #            "      ,ooa_file,oob_file",
     #            " WHERE lua01 = lub01 ",
     #            "   AND lub14 IS NOT NULL",
     #            "      AND lub14 = oob06",
     #            "      AND ooa01 = oob01",
     #            "   AND ",g_wc1 CLIPPED,
     #            " ORDER BY ooa01 DESC"       
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     #PREPARE p605_sel_lua FROM g_sql
     #DECLARE p605_lua_curs CURSOR FOR p605_sel_lua
     #No.TQC-C40058   ---end---     Mark
     #No.TQC-C40058   ---start---   Add
      LET g_sql = "SELECT DISTINCT lub14,lub10,lub01,lua37 ",
                  "  FROM ",cl_get_target_table(g_plant_new,'lua_file'),
                        ",",cl_get_target_table(g_plant_new,'lub_file'),
                  " WHERE lua01 = lub01 ",
                  "   AND lub14 IS NOT NULL",
                  "   AND ",g_wc1 CLIPPED,
                  "   AND YEAR(lub10) = '",tm.yy,"'",
                  "   AND MONTH(lub10) = '",tm.mm,"'",
                  " ORDER BY lub10 DESC"  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p605_sel_lua FROM g_sql
      DECLARE p605_lua_curs CURSOR FOR p605_sel_lua
      LET g_sql = "SELECT MAX(MONTH(lub10)) FROM ",cl_get_target_table(g_plant_new,'lub_file'),
                  " WHERE lub01 = ? AND lub14 IS NOT NULL"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p605_sel_lub10 FROM g_sql
      LET g_sql = "SELECT MONTH(lui03) FROM ",cl_get_target_table(g_plant_new,'lui_file'),
                  " WHERE lui04 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p605_sel_lui FROM g_sql
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'lui_file')," SET lui14=NULL",
                  " WHERE lui01 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p605_upd_lui FROM g_sql
     #No.TQC-C40058   ---end---     Add

     #檢查所有財務單的憑證,是否有已審核的
      FOREACH p605_lua_curs INTO g_lub14,g_lub10,l_lub01,g_lua37

         IF g_lub10 < g_ooz.ooz09 THEN
            CALL s_errmsg(g_lub14,g_lub10,'','axr-084',1)
            CONTINUE FOREACH
         END IF

        #No.TQC-C40058   ---start---   Add
         EXECUTE p605_sel_lub10 USING l_lub01 INTO g_lub10_o
         IF g_lub10_o > tm.mm THEN
            CALL s_errmsg('',g_lub10,'','axr-421',1)
            LET g_success = 'N'
            RETURN
         END IF
        #No.TQC-C40058   ---end---     Add

         CALL p605_agl_check(g_lub14)
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH

     #將所有已拋轉的憑證還原
      FOREACH p605_lua_curs INTO g_lub14,g_lub10,l_lub01,g_lua37
         CALL p605_agl_uncarry(g_lub14)
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH

      FOREACH p605_lua_curs INTO g_lub14,g_lub10,l_lub01,g_lua37

        #No.TQC-C40058   ---start---   Add
         EXECUTE p605_sel_lub10 USING l_lub01 INTO g_lub10_o
         EXECUTE p605_sel_lui   USING l_lub01 INTO g_lui03
        #No.TQC-C40058   ---end---     Add
         IF cl_null(l_lub14_1) OR (l_lub14_1 != g_lub14) THEN
            CALL p605_del_axrt400(g_lub14)
         END IF
         CALL p605_del_axrt300(g_lub14)
         LET l_lub14_1 = g_lub14
      END FOREACH
     #無合乎條件的資料
      IF cl_null(g_lub14) THEN
         CALL s_errmsg('','','','mfg2601',1)
         LET g_success = 'N'
          RETURN
      END IF
   END FOREACH
  #無合乎條件的資料
   IF cl_null(g_plant_new) THEN
      CALL s_errmsg('','','','mfg2601',1)
      LET g_success = 'N'
   END IF
   
END FUNCTION

FUNCTION p605_del_axrt400(p_lub14)
   DEFINE p_lub14      LIKE lub_file.lub14
   DEFINE l_oob        RECORD LIKE oob_file.*     
   DEFINE l_nmgconf    LIKE nmg_file.nmgconf      
   DEFINE l_oob06      LIKE oob_file.oob06
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5    #No.TQC-C40058   Add
   DEFINE l_n1         LIKE type_file.num5    #No.TQC-C40058   Add

   INITIALIZE g_ooa.* TO NULL

   SELECT * INTO g_ooa.* FROM ooa_file,oob_file
    WHERE ooa01 = oob01
      AND oob06 = p_lub14

   IF cl_null(g_ooa.ooa01) THEN RETURN END IF

  #No.TQC-C40058   ---start---   Add
   SELECT COUNT(*) INTO l_n FROM oob_file,ooa_file 
    WHERE oob01 = g_ooa.ooa01 
      AND ooa01 = oob01
      AND oob03 = '1' 
      AND oob04 != '3'
      AND ooaconf <> 'X'
   SELECT COUNT(*) INTO l_n1 FROM oob_file,ooa_file 
    WHERE oob01 = g_ooa.ooa01 
      AND ooa01 = oob01
      AND oob03 = '2' 
      AND oob04 = '1'
      AND ooaconf <> 'X'
   IF l_n > 0 AND l_n1 > 0 THEN
      CALL s_errmsg('',g_ooa.ooa01,'','axr-014',1)
      LET g_success='N'
      RETURN
   END IF
  #No.TQC-C40058   ---end---     Add

   CALL axrt400_unconfirm()

   IF g_success = 'Y' THEN
    #IF g_lua37 = 'Y' THEN   #No.TQC-C40058   Mark
     IF g_lua37 = 'Y' AND (g_lub10_o = g_lui03) THEN  #No.TQC-C40058   Add
       #UPDATE lui_file SET lui14=NULL WHERE lui01=g_ooa.ooa36   #No.TQC-C40058   Mark
        EXECUTE p605_upd_lui USING g_ooa.ooa36  #No.TQC-C40058   Add
        IF STATUS OR SQlCA.sqlerrd[3]=0 THEN
           CALL s_errmsg('upd lui_file',g_ooa.ooa36,'',"No lui update",1)
           LET g_success='N'
        END IF
     END IF
     LET l_sql = " SELECT * FROM oob_file WHERE oob01='",g_ooa.ooa01,"'",
                 " AND oob03='1'"
     PREPARE t400_del_pr FROM l_sql
     DECLARE t400_del_r CURSOR FOR t400_del_pr
     FOREACH t400_del_r INTO l_oob.*
       IF STATUS THEN EXIT FOREACH END IF
       IF l_oob.oob04='1' THEN
          DELETE FROM nmh_file WHERE nmh01=l_oob.oob06
       END IF
       IF l_oob.oob04='2' THEN
          SELECT nmgconf INTO l_nmgconf FROM nmg_file
           WHERE nmg00=l_oob.oob06
          IF l_nmgconf='Y' THEN
             DELETE FROM nme_file WHERE nme12=l_oob.oob06
          END IF
          DELETE FROM npk_file WHERE npk00=l_oob.oob06
          DELETE FROM nmg_file WHERE nmg00=l_oob.oob06
       END IF
     END FOREACH
     DELETE FROM ooa_file WHERE ooa01 = g_ooa.ooa01
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('del ooa_file',g_ooa.ooa01,'',"No ooa deleted",1)  
        LET g_success='N'
     END IF
     DELETE FROM oob_file WHERE oob01 = g_ooa.ooa01
     DELETE FROM npp_file WHERE npp01 = g_ooa.ooa01 AND nppsys = 'AR'
                            AND npp00 = 3  AND npp011 = 1
     DELETE FROM npq_file WHERE npq01 = g_ooa.ooa01 AND npqsys = 'AR'
                            AND npq00 = 3 AND npq011 = 1
     DELETE FROM tic_file WHERE tic04 = g_ooa.ooa01
     LET g_msg=TIME
     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    
          VALUES ('axrt400',g_user,g_today,g_msg,g_ooa.ooa01,'delete',g_plant,g_legal)
   END IF
   
END FUNCTION

FUNCTION p605_del_axrt300(p_lub14)
   DEFINE p_lub14      LIKE lub_file.lub14
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE l_omb        RECORD LIKE omb_file.*,
          tot          LIKE omb_file.omb18 
   DEFINE l_oob06      LIKE oob_file.oob06
   DEFINE l_nmh17      LIKE nmh_file.nmh17
   DEFINE l_nmh24      LIKE nmh_file.nmh24
   DEFINE l_nmh33      LIKE nmh_file.nmh33
   DEFINE l_omb38      LIKE omb_file.omb38 
   DEFINE l_azw05      LIKE azw_file.azw05
   DEFINE l_azw05_t    LIKE azw_file.azw05
   DEFINE l_azw        DYNAMIC ARRAY OF RECORD
             azw05        LIKE azw_file.azw05,      
             azw01        LIKE azw_file.azw01 
                       END RECORD
   DEFINE l_omb44      LIKE omb_file.omb44
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_count      LIKE type_file.num5

   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_lub14

   IF cl_null(g_oma.oma01) THEN RETURN END IF

   CALL axrt300_unconfirm()

   IF g_success = 'Y' THEN

      SELECT COUNT(*) INTO l_cnt FROM oot_file
       WHERE oot01 = g_oma.oma01
      IF l_cnt > 0 THEN
         CALL s_errmsg('','','','axr-009',1)
         LET g_success = 'N'
      END IF   
    
      DECLARE oob_cs1 CURSOR FOR
       SELECT oob06 FROM oob_file
        WHERE oob01=g_oma.oma01 AND oob03='1' AND oob04='1' AND oob02>0
      FOREACH oob_cs1 INTO l_oob06
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('foreach:','','',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         SELECT nmh17,nmh24,nmh33 INTO l_nmh17,l_nmh24,l_nmh33 FROM nmh_file
          WHERE nmh01=l_oob06
         IF l_nmh24<>'2' THEN
            CALL s_errmsg('','','','axr-045',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF l_nmh17 > 0 THEN
            CALL s_errmsg('','','','axr-077',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_nmh33) THEN
            CALL s_errmsg('','','','axr-047',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         DELETE FROM nmh_file WHERE nmh01=l_oob06
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('del nmh_file','','',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         DELETE FROM npp_file
          WHERE nppsys= 'NM' AND npp00=2 AND npp01 = l_oob06 AND npp011=1
         DELETE FROM npq_file
          WHERE npqsys= 'NM' AND npq00=2 AND npq01 = l_oob06 AND npq011=1
         DELETE FROM tic_file WHERE tic04 = l_oob06
      END FOREACH
      OPEN t300_cl USING g_oma.oma01
      IF STATUS THEN
         CALL s_errmsg('OPEN t300_cl','','',STATUS,1)
         CLOSE t300_cl
         LET g_success = 'N'
      END IF
      FETCH t300_cl INTO g_oma.*
      IF STATUS THEN 
         CALL s_errmsg('sel oma','','',STATUS,1)
         LET g_success = 'N'
      END IF
      DECLARE sel_oga_cs08 CURSOR FOR
       SELECT azw05,omb44 FROM omb_file,azw_file
        WHERE omb01 = g_oma.oma01
          AND omb44 = azw01
        ORDER BY azw05 
      LET g_cnt = 1
      LET l_azw05_t = ''
      FOREACH sel_oga_cs08 INTO l_azw05,l_omb44
         IF STATUS THEN EXIT FOREACH END IF  
         IF l_azw05_t = l_azw05 THEN
            CONTINUE FOREACH
         END IF
         LET l_azw[g_cnt].azw05 = l_azw05
         LET l_azw[g_cnt].azw01 = l_omb44 
         LET l_azw05_t = l_azw05
         LET g_cnt = g_cnt + 1
      END FOREACH
      LET l_count = g_cnt - 1                             
      IF g_oma.oma10 IS NOT NULL THEN
         SELECT COUNT(*) INTO g_cnt FROM oma_file
          WHERE oma10 = g_oma.oma10
            AND omavoid = 'N'     
         IF g_cnt = 1 THEN  #一張發票對一張應收時才詢問是否殺
            DELETE FROM ome_file  WHERE ome01  = g_oma.oma10 AND (ome03 = g_oma.oma75 OR ome03 =' ')  
            DELETE FROM omee_file WHERE omee01 = g_oma.oma10 AND (omee03 = g_oma.oma75 OR omee03 =' ')          
         END IF
      END IF

      MESSAGE "Delete oma,omb,oao,npp,npq!"
      DELETE FROM oma_file WHERE oma01 = g_oma.oma01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('del oma_file',g_oma.oma01,'',SQLCA.sqlcode,1) 
         LET g_success = 'N'
      ELSE
         LET g_sql = "SELECT UNIQUE omb44 FROM omb_file ",
                     " WHERE omb01 = '",g_oma.oma01,"'"
         PREPARE sel_omb44_pre FROM g_sql
         DECLARE sel_omb44_cur CURSOR FOR sel_omb44_pre
         FOREACH sel_omb44_cur INTO l_omb44
            IF STATUS THEN EXIT FOREACH END IF    
            LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oha_file'),
                        "   SET oha10 = NULL ",
                        " WHERE oha10 = '",g_oma.oma01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
            PREPARE upd_oha FROM g_sql
            EXECUTE upd_oha
            IF STATUS THEN
               CALL s_errmsg('upd oha_file',g_oma.oma01,'',STATUS,1)
               LET g_success = 'N'
            END IF     
         END FOREACH            
      END IF

      DELETE FROM omb_file WHERE omb01 = g_oma.oma01
      IF STATUS THEN
         CALL s_errmsg('del omb_file',g_oma.oma01,'',STATUS,1)
         LET g_success = 'N'
      END IF
      DELETE FROM omc_file WHERE omc01 = g_oma.oma01
      IF STATUS THEN
         CALL s_errmsg('del omc_file',g_oma.oma01,'',STATUS,1)
         LET g_success = 'N'
      END IF
      DELETE FROM oov_file WHERE oov01 = g_oma.oma01
      IF STATUS THEN
         CALL s_errmsg('del oov_file',g_oma.oma01,'',STATUS,1)
         LET g_success = 'N'
      END IF
      IF g_oma.oma00='14' THEN
         UPDATE fbe_file SET fbe11=NULL WHERE fbe11=g_oma.oma01
      END IF
      IF g_oma.oma00='15' OR g_oma.oma00='17' THEN
         UPDATE lub_file SET lub14=NULL WHERE lub01=g_oma.oma16
            AND lub14=g_oma.oma01 
         IF STATUS THEN
            CALL s_errmsg('upd lub_file',g_oma.oma01,'',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_oma.oma00 MATCHES '1*' THEN
         DELETE FROM oot_file WHERE oot03 = g_oma.oma01
      ELSE
         DELETE FROM oot_file WHERE oot01 = g_oma.oma01
      END IF
      DELETE FROM npp_file WHERE npp01 = g_oma.oma01 AND nppsys = 'AR'
                             AND npp00 = 2 AND npp011 = 1
      DELETE FROM npq_file WHERE npq01 = g_oma.oma01 AND npqsys = 'AR'
                             AND npq00 = 2 AND npq011 = 1
      DELETE FROM tic_file WHERE tic04 = g_oma.oma01
      DELETE FROM oob_file WHERE oob01 = g_oma.oma01
      DELETE FROM ooa_file WHERE ooa01 = g_oma.oma01
      DELETE FROM oml_file WHERE oml01 = g_oma.oma01 
      DELETE FROM omk_file WHERE omk01 = g_oma.oma01  
      IF g_oma.oma16 IS NOT NULL THEN
         IF g_oma.oma01 <> g_oma.oma16 THEN
            DELETE FROM oao_file WHERE oao01 = g_oma.oma01
         END IF
      ELSE
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM omb_file
          WHERE omb31 = g_oma.oma01
         IF g_cnt = 0 THEN
            DELETE FROM oao_file WHERE oao01 = g_oma.oma01
         END IF
      END IF
      LET g_cnt = 0 
      FOR l_i = 1 TO l_count
         LET g_plant_new = l_azw[l_i].azw01 
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oha_file'), 
                     " WHERE oha10 = '",g_oma.oma01,"' ",
                     "   AND ohaconf = 'Y'",
                     "   AND ohapost = 'Y'",
                     "   AND oha09 = '3' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         					
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                      
         PREPARE sel_oga_pre14 FROM g_sql
         EXECUTE sel_oga_pre14 INTO l_cnt
         LET g_cnt = g_cnt + l_cnt
      END FOR
      IF g_cnt > 0 THEN 
         FOR l_i = 1 TO l_count
            LET g_plant_new = l_azw[l_i].azw01 
            LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'),
                        "   SET oha10 = NULL ",
                        " WHERE oha10 = '",g_oma.oma01,"'",
                        "   AND ohaconf = 'Y'",
                        "   AND ohapost = 'Y'",
                        "   AND oha09 = '3' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql       						
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                                 
            PREPARE upd_oha_pre14 FROM g_sql
            EXECUTE upd_oha_pre14
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('dpd oha_file',g_oma.oma01,'',STATUS,1)
               LET g_success = 'N'
            END IF
         END FOR
      END IF
      LET g_msg=TIME
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  
          VALUES ('axrt300',g_user,g_today,g_msg,g_oma.oma01,'delete',g_plant,g_legal) 

      CLOSE t300_cl
   
   END IF
   
END FUNCTION

FUNCTION axrt400_unconfirm() # when g_ooa.ooaconf='Y' (Turn to 'N')
   DEFINE l_aba19    LIKE aba_file.aba19

   IF g_ooa.ooa34 = "S" THEN
      CALL s_errmsg('','','','mfg3557',1)
      LET g_success = 'N'
   END IF
 
   IF g_ooa.ooaconf='N' THEN RETURN END IF
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
      CALL s_errmsg('ooa02',g_ooa.ooa02,'','axr-164',1)
      LET g_success = 'N'
   END IF
   IF g_ooa.ooaconf = 'X' THEN
      CALL s_errmsg('ooaconf',g_ooa.ooaconf,'','9024',1)
      LET g_success = 'N'
   END IF
   IF NOT cl_null(g_ooa.ooa992) THEN
      CALL s_errmsg('ooa992',g_ooa.ooa992,'','axr-950',1)
      LET g_success = 'N'
   END IF

   OPEN t400_cl USING g_ooa.ooa01
   IF STATUS THEN
      CALL s_errmsg('OPEN t400_cl','','',STATUS,1)
      CLOSE t400_cl
      LET g_success = 'N'
   END IF
   FETCH t400_cl INTO g_ooa.*                       # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ooa',g_ooa.ooa01,'',SQLCA.sqlcode,1)    # 資料被他人LOCK
      CLOSE t400_cl
      LET g_success = 'N'
   END IF
   CALL t400_z1()
   
   CALL t400_del_oma()
 
   UPDATE ooa_file SET ooa34 = '0' WHERE ooa01 = g_ooa.ooa01
   IF STATUS THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",STATUS,"","upd ooa",1)  
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      LET g_ooa.ooaconf = 'N'
      LET g_ooa.ooa34 = "0"
   END IF

  IF g_ooa.ooaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  IF g_ooa.ooa34 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
END FUNCTION

FUNCTION t400_z1()
   DEFINE n      LIKE type_file.num5
   DEFINE l_cnt  LIKE type_file.num5
   DEFINE l_flag LIKE type_file.chr1
   
   UPDATE ooa_file SET ooaconf = 'N',ooa34 = '0' WHERE ooa01 = g_ooa.ooa01  
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('upd ooa_file',g_ooa.ooa01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
   #因為在s_g_np時, 會取apf_file已確認的資料, 故在此應先將之還原
   SELECT COUNT(*) INTO n FROM oob_file
    WHERE oob01 = g_ooa.ooa01 AND oob04='9'
   IF n>0 THEN
      UPDATE apf_file SET apf41 = 'N' WHERE apf01 = g_ooa.ooa01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd apf_file',g_ooa.ooa01,'',SQLCA.sqlcode,1)
         LET g_success = 'N' 
      END IF
   END IF
 
   DECLARE t400_z1_c CURSOR FOR
         SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH t400_z1_c INTO b_oob.*
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'z1 foreach',STATUS,1) 
         LET g_success = 'N'
      END IF
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
      IF l_flag = '0' THEN LET l_flag = b_oob.oob03 END IF
      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '1' THEN CALL t400_bu_11('-') END IF
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '2' THEN CALL t400_bu_12('-') END IF
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN CALL t400_bu_13('-') END IF
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN CALL t400_bu_21('-') END IF
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN CALL t400_bu_22('-',l_cnt) END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
   #---------------------------------- 970124 roger A/P對沖->需自動刪除apf,g,h
   #只要類別為9,就都INS AP:apf,g,h
   SELECT COUNT(*) INTO n FROM oob_file
    WHERE oob01 = g_ooa.ooa01 AND oob04='9'
   IF n>0 THEN CALL del_apf() END IF

END FUNCTION

FUNCTION t400_bu_11(p_sw)                     #更新應收票據檔 (nmh_file)
   DEFINE p_sw       LIKE type_file.chr1      # +:更新 -:還原
   DEFINE l_nmz59        LIKE nmz_file.nmz59
   DEFINE l_amt1,l_amt2 LIKE nmg_file.nmg25  
 
   SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
   IF l_nmz59 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
      CALL s_g_np('4','1',b_oob.oob06,b_oob.oob15) RETURNING tot3
   ELSE
      SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = b_oob.oob06
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
      CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1
      SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file 
       WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '1'
         AND oob06 = b_oob.oob06
      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      LET tot3 = l_amt1 - l_amt2
      IF cl_null(tot3) THEN LET tot3 = 0 END IF
   END IF
 
  #-:還原
   IF p_sw = '-' THEN
      UPDATE nmh_file SET nmh17=nmh17-b_oob.oob09 ,nmh40 = tot3
       WHERE nmh01= b_oob.oob06
      IF STATUS THEN
         CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17',STATUS,1) 
         LET g_success = 'N' 
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17','axr-198',1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t400_bu_12(p_sw)                          # 更新TT檔 (nmg_file)
   DEFINE p_sw           LIKE type_file.chr1       # +:更新 -:還原
   DEFINE l_nmg23        LIKE nmg_file.nmg23
   DEFINE l_nmg24        LIKE nmg_file.nmg24,
          l_nmg25        LIKE nmg_file.nmg25,
          l_cnt          LIKE type_file.num5 
   DEFINE tot1,tot3,tot2 LIKE type_file.num20_6 
   DEFINE l_nmz20        LIKE nmz_file.nmz20
   DEFINE l_str          STRING                 
 
   LET l_str = "bu_12:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
   CALL cl_msg(l_str) 
 
   SELECT nmg25 INTO l_nmg25 FROM nmg_file WHERE nmg00 = b_oob.oob06
   IF cl_null(l_nmg25) THEN LET l_nmg25 = 0 END IF
  ##--------------------------------------------------
  # 同參考單號若有一筆以上僅沖款一次即可 --------------
   SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='2'
            AND oob06=b_oob.oob06
   IF l_cnt > 0 THEN RETURN END IF
 
   LET tot1 = 0 LET tot2 = 0
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
          WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
            AND oob03='1'         AND oob04 = '2'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
   SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
   IF l_nmz20 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
      CALL s_g_np('3','',b_oob.oob06,b_oob.oob15) RETURNING tot3
   ELSE
      LET tot3 = 0
   END IF
 
   IF p_sw = '-' THEN
      UPDATE nmg_file SET nmg24 = tot1, nmg10 = tot3
       WHERE nmg00= b_oob.oob06
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',SQLCA.SQLCODE,0)
     END IF
   END IF
   LET l_nmg24 =0
   SELECT nmg23,nmg23-nmg24 INTO l_nmg23,l_nmg24
     FROM nmg_file WHERE nmg00= b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'sel nmg24',STATUS,1)
      LET g_success = 'N' 
   END IF
   IF l_nmg24 = 0  THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'nmg24=0','axr-185',1)
      LET g_success='N'
   END IF
  # check 是否沖過頭了 ------------
   IF tot1>l_nmg23  THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'','axr-258',1)
      LET g_success='N'
   END IF
   UPDATE nmg_file SET nmg24=tot1, nmg10 = tot3
    WHERE nmg00= b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',STATUS,1)
      LET g_success = 'N' 
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24','axr-198',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t400_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
   DEFINE p_sw           LIKE type_file.chr1      # +:更新 -:還原
   DEFINE l_omaconf      LIKE oma_file.omaconf,
          l_omavoid      LIKE oma_file.omavoid,
          l_cnt          LIKE type_file.num5   
   DEFINE l_oma00        LIKE oma_file.oma00,
          l_oma55        LIKE oma_file.oma55,  
          l_oma57        LIKE oma_file.oma57   
   DEFINE tot4,tot4t     LIKE type_file.num20_6 
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_13:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
   END IF
  # 同參考單號若有一筆以上僅沖款一次即可 --------------
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01=b_oob.oob01
      AND oob02<b_oob.oob02
      AND oob03='1'
      AND oob04='3'
      AND oob06=b_oob.oob06
   IF l_cnt>0 THEN RETURN END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07 
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1  
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2  

   LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t,oma55,oma57 ",
            "  FROM oma_file ",
            " WHERE oma01=?"
   PREPARE t400_bu_13_p1 FROM g_sql
   DECLARE t400_bu_13_c1 CURSOR FOR t400_bu_13_p1
   OPEN t400_bu_13_c1 USING b_oob.oob06
   FETCH t400_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57
   IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
   IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
  #取得衝帳單的待扺金額
   CALL t400_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t

   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file,ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf = 'Y'
      AND oob03='1'  AND oob04 = '3'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
   LET l_oma55 = 0 
   LET l_oma57 = 0 
    	
   IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
      CALL s_g_np('1',l_oma00,b_oob.oob06,0) RETURNING tot3
      LET tot3 = tot3 - tot4t
   ELSE
      LET tot3 = un_pay2 - tot2 - tot4t
   END IF
   LET g_sql="UPDATE oma_file ",
             "   SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "
   PREPARE t400_bu_13_p2 FROM g_sql
   LET tot1 = tot1 + tot4
   LET tot2 = tot2 + tot4t
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1 
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2 
   EXECUTE t400_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1) 
      LET g_success = 'N' 
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1)
      LET g_success = 'N'
   END IF
   IF SQLCA.sqlcode = 0 THEN
       CALL t400_omc(l_oma00,p_sw)
   END IF
END FUNCTION
 
FUNCTION t400_bu_21(p_sw)                        #更新應收帳款檔 (oma_file)
   DEFINE p_sw           LIKE type_file.chr1      # +:更新 -:還原
   DEFINE l_omaconf      LIKE oma_file.omaconf, 
          l_omavoid      LIKE oma_file.omavoid, 
          l_cnt          LIKE type_file.num5    
   DEFINE l_oma00        LIKE oma_file.oma00 
   DEFINE tot4,tot4t     LIKE type_file.num20_6
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_21:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
   END IF
 
  # 同參考單號若有一筆以上僅沖款一次即可 --------------
   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01=b_oob.oob01
         AND oob02<b_oob.oob02
         AND oob03='2'
         AND oob04='1'  
         AND oob06=b_oob.oob06
         AND oob15=b_oob.oob15
         AND oob19=b_oob.oob19
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01=b_oob.oob01
         AND oob02<b_oob.oob02
         AND oob03='2'
         AND oob04='1'        
         AND oob19=b_oob.oob19
         AND oob06=b_oob.oob06
   END IF
   IF l_cnt>0 THEN  
      LET g_showmsg=b_oob.oob06,"/",b_oob.oob01                       
      CALL s_errmsg('oob06,oob01',g_showmsg,b_oob.oob01,'axr-409',1)  
      LET g_success = 'N'
   END IF
 
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
      AND oob03='2'
      AND oob04='1' 
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
    	
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2
   LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
            "  FROM oma_file ",
            " WHERE oma01=?"
   PREPARE t400_bu_21_p1 FROM g_sql
   DECLARE t400_bu_21_c1 CURSOR FOR t400_bu_21_p1
   OPEN t400_bu_21_c1 USING b_oob.oob06
   FETCH t400_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
   IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
   IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
  #取得衝帳單的待扺金額
   CALL t400_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4   
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
   IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
      CALL s_g_np('1',l_oma00,b_oob.oob06,0) RETURNING tot3                                                 
      IF tot3 <0 THEN       
         CALL s_errmsg('','',tot3,'axr-185',1)                                            
         LET g_success ='N'                                                    
      END IF             
      LET tot3 = tot3 - tot4t
   ELSE
      LET tot3 = un_pay2 - tot2 - tot4t
   END IF
   LET g_sql="UPDATE oma_file ",
             "   SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "
   PREPARE t400_bu_21_p2 FROM g_sql
   LET tot1 = tot1 + tot4
   LET tot2 = tot2 + tot4t
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1  
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2  
   EXECUTE t400_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
   IF STATUS THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)   
      LET g_success = 'N'
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' 
   END IF
   IF SQLCA.sqlcode = 0 THEN
      CALL t400_omc(l_oma00,p_sw)
   END IF
  # 若有指定沖帳項次, 則對項次再次檢查及更新已沖金額
   IF NOT cl_null(b_oob.oob15) AND g_ooz.ooz62='Y' THEN
      LET tot1 = 0 LET tot2 = 0
      SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
         AND oob03='2' AND oob15 = b_oob.oob15
         AND oob04='1'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      LET g_sql="SELECT oma00,omaconf,omb14t,omb16t ",
               "  FROM omb_file,oma_file ",
               " WHERE oma01=omb01 AND omb01=? AND omb03 = ? "
      PREPARE t400_bu_21_p1b FROM g_sql
      DECLARE t400_bu_21_c1b CURSOR FOR t400_bu_21_p1b
      OPEN t400_bu_21_c1b USING b_oob.oob06,b_oob.oob15
      FETCH t400_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2
      IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
      IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
      IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
         IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                      
         CALL s_errmsg('omb01,omb03',g_showmsg,'un_pay<pay','axr-196',1)  LET g_success='N' 
         END IF
      END IF
      IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
        #取得未沖金額
         CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
      ELSE
         LET tot3 = un_pay2 - tot2
      END IF
      LET g_sql="UPDATE omb_file ",   
                "   SET omb34=?,omb35=?,omb37=? ",
                " WHERE omb01=? AND omb03=?"
      PREPARE t400_bu_21_p2b FROM g_sql
      EXECUTE t400_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
      IF STATUS THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                     
         CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35',STATUS,1)
         LET g_success = 'N' 
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15
         CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t400_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
   DEFINE p_sw            LIKE type_file.chr1     # +:產生 -:刪除
   DEFINE p_cnt           LIKE type_file.num5     
   DEFINE l_oma            RECORD LIKE oma_file.*  
   DEFINE l_cnt           LIKE type_file.num5    

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         MESSAGE "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
      ELSE
         DISPLAY "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
      END IF
   END IF
   INITIALIZE l_oma.* TO NULL
   IF p_sw = '-' THEN
  # 若溢收款在後已被沖帳,則不可取消確認
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
         SELECT COUNT(*) INTO g_cnt FROM oob_file,ooa_file
          WHERE oob06 = b_oob.oob06
            AND oob03 = '1' AND oob04 = '3'
            AND ooa01 = oob01 AND ooaconf!='X'            
         IF g_cnt > 0 THEN
           LET g_showmsg=b_oob.oob06,"/",'1',"/",'3'      
           CALL s_errmsg('oob06,oob03,oob04',g_showmsg,b_oob.oob06,'axr-206',1) 
           LET g_success = 'N' 
         END IF
      END IF
      SELECT * INTO l_oma.* FROM oma_file
       WHERE oma01=b_oob.oob06
         AND omavoid = 'N'
      IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN
         LET g_showmsg=b_oob.oob06,"/",'N'                                
         CALL s_errmsg('oma01,omavoid',g_showmsg,'oma55,57>0','axr-206',1)
          LET g_success = 'N' 
      END IF
      DELETE FROM oma_file WHERE oma01 = b_oob.oob06
      IF STATUS THEN
         CALL s_errmsg('oma01','b_oob.oob06','del oma',STATUS,1)  
         LET g_success = 'N' 
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('oma01','b_oob.oob06','del oma','axr-199',1)  
         LET g_success = 'N' 
      END IF
      DELETE FROM omc_file WHERE omc01=b_oob.oob06 AND omc02=b_oob.oob19
      IF STATUS THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob19                 
         CALL s_errmsg('omc01,omc02',g_showmsg,"del omc",STATUS,1) 
         LET g_success ='N'
      END IF 
      DELETE FROM oov_file WHERE oov01 = b_oob.oob06
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oov01','b_oob.oob06','del oov',STATUS,1)         
         LET g_success='N'
      END IF

     #更新退款單待抵單號
      IF g_ooa.ooa35 = '2' THEN
         UPDATE lud_file SET lud10=NULL 
          WHERE lud01 = g_ooa.ooa36 AND lud10 = b_oob.oob06
         IF STATUS OR SQlCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","lud_file",g_ooa.ooa36,"",STATUS,"","",1)
            LET g_success='N'
         END IF
         UPDATE luk_file SET luk16 = NULL WHERE luk04 = '2' AND luk05 = g_ooa.ooa36
         IF STATUS OR SQlCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","luk_file",g_ooa.ooa36,"",STATUS,"","",1)
            LET g_success='N'
         END IF
      END IF
      UPDATE oob_file SET oob06=NULL
       WHERE oob01=b_oob.oob01
         AND oob02=b_oob.oob02
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_showmsg=b_oob.oob01,"/",b_oob.oob02                            
         CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)   
         LET g_success = 'N' 
      ELSE        # 畫面清為空白
         LET b_oob.oob06 = NULL
      END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt
        FROM npq_file
       WHERE npq01 = b_oob.oob01 AND npq02 = b_oob.oob02
      IF l_cnt > 0 THEN
         UPDATE npq_file SET npq23=NULL
          WHERE npq01=b_oob.oob01
            AND npq02=b_oob.oob02
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_showmsg=b_oob.oob01,"/",b_oob.oob02     
            CALL s_errmsg('npq01,npq02',g_showmsg,'upd npq23',SQLCA.SQLCODE,1)   
            LET g_success = 'N' 
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t400_del_oma()
DEFINE  l_oof RECORD LIKE oof_file.*

   IF g_success ='N' THEN RETURN END IF 
   DECLARE t400_sel_oma1 CURSOR FOR 
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01
   
   FOREACH t400_sel_oma1 INTO l_oof.*
      IF STATUS THEN CALL cl_err('sel oma',STATUS,1) EXIT FOREACH END IF   
      DELETE FROM oma_file WHERE oma01 = l_oof.oof05
      IF SQLCA.sqlcode THEN                    
         CALL cl_err3("del","oma_file",l_oof.oof05,"",SQLCA.sqlcode,"","",1) 
         LET g_success = 'N'
         EXIT FOREACH 
      ELSE
         LET g_success ='Y'
      END IF
   END FOREACH 
END FUNCTION

FUNCTION axrt300_unconfirm()              # when g_oma.omaconf='Y' (Turn to 'N')
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_yy,l_mm  LIKE type_file.num5    
   DEFINE l_cnt2     LIKE type_file.num5   
   DEFINE l_aba19    LIKE aba_file.aba19
 
   IF NOT cl_null(g_oma.oma992) THEN
      CALL s_errmsg('oma992',g_oma.oma992,'','axr-950',1)
      LET g_success='N'
   END IF

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt  FROM amd_file
    WHERE amd01 = g_oma.oma01
      AND amd021 = '3'
   IF l_cnt > 0  THEN
      CALL s_errmsg('oma01',g_oma.oma01,'','amd-030',1)
      LET g_success = 'N'
   END IF
   
   IF g_oma.oma64 = "S" THEN
      CALL s_errmsg('oma64',g_oma.oma64,'','mfg3557',1)
      LET g_success='N'
   END IF
   IF g_oma.oma00 = '24' THEN
     #由axrt400產生的溢收單應不可作確認取消
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ooa_file
       WHERE ooa01 = g_oma.oma16
      IF l_cnt > 0 THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-010',1)
         LET g_success='N'
      END IF
     #由anmt302產生的暫收單應不可作確認取消
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM nmg_file
       WHERE nmg00 = g_oma.oma01
      IF l_cnt > 0 THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-327',1)
         LET g_success='N'
      END IF
   END IF
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = g_oma.oma01
   IF g_oma.omaconf='N' THEN RETURN END IF
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_oma.oma02<=g_ooz.ooz09 THEN
      CALL s_errmsg('oma02',g_oma.oma02,'','axr-164',1)
      LET g_success='N'
   END IF
   IF g_ooz.ooz07 = 'Y' AND g_oma.oma23 != g_aza.aza17 THEN
      CALL s_yp(g_oma.oma02) RETURNING l_yy,l_mm
      SELECT COUNT(*) INTO l_cnt FROM oox_file 
       WHERE (oox01*12+oox02) >= (l_yy*12+l_mm)
         AND oox03 =g_oma.oma01
      IF l_cnt >0 THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-407',1)
         LET g_success='N'
      END IF
   END IF
   IF g_ooz.ooz20 = 'Y' THEN
      IF (g_aza.aza26='2' AND g_oma.oma00='21' AND NOT cl_null(g_oma.oma10)) OR
         ( (g_oma.oma00 MATCHES '1*' OR g_oma.oma00='31') AND
         (g_oma.oma10 IS NOT NULL AND g_oma.oma10 !=' ')) THEN #已開發票不可取消確認
         CALL s_errmsg('oma10',g_oma.oma10,'','axr-904',1)
         LET g_success='N'
      END IF
   END IF
   SELECT COUNT(*) INTO l_cnt FROM oot_file WHERE oot03 = g_oma.oma01
 
   #已有銷項發票底稿資料(不為作廢)時,則不可取消確認
   IF g_aza.aza26 = '2' AND g_aza.aza47 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM isa_file
       WHERE isa04 = g_oma.oma01
         AND isa07 != 'V'
      IF l_cnt > 0 THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-016',1)
         LET g_success='N'
      END IF
   END IF
 
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM npn_file
    WHERE npn01 = g_oma.oma16
   IF l_cnt > 0 THEN
      CALL s_errmsg('oma16',g_oma.oma16,'','aap-425',1)
      LET g_success='N'
   END IF 
 
   OPEN t300_cl USING g_oma.oma01
   IF STATUS THEN
      CALL s_errmsg('OPEN t300_cl','','',STATUS,1)
      LET g_success='N'
      CLOSE t300_cl
   END IF
   FETCH t300_cl INTO g_oma.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma01',g_oma.oma01,'',SQLCA.sqlcode,1)  # 資料被他人LOCK
      LET g_success='N'
      CLOSE t300_cl 
   END IF
   CALL s_ar_conf('z',g_oma.oma01,'') RETURNING i
   CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   CALL s_t300_w1('-',g_oma.oma01)
   CALL t300_omc_check()
   IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN
      CALL s_t300_del_oct(g_oma.oma00,g_oma.oma01,'0') RETURNING i
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_t300_del_oct(g_oma.oma00,g_oma.oma01,'1') RETURNING i
      END IF
   END IF
   IF i = 0 THEN
      LET g_oma.omaconf = 'N'
      LET g_oma.oma64 = "0"
      DISPLAY BY NAME g_oma.omaconf,g_oma.oma64
      UPDATE oma_file SET oma64 = g_oma.oma64 WHERE oma01 = g_oma.oma01
      IF STATUS THEN
         CALL s_errmsg('oma01',g_oma.oma01,'',STATUS,1)
         LET g_success = 'N'
      END IF
   END IF
   SELECT oma65 INTO g_oma.oma65 FROM oma_file WHERE oma01=g_oma.oma01
   IF g_oma.oma65='2' THEN
      CALL s_t300_unconfirm(g_oma.oma01)
   END IF

END FUNCTION

FUNCTION del_apf()
   DELETE FROM apf_file WHERE apf01=g_ooa.ooa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('apf01','g_ooa.ooa01','del apf',SQLCA.SQLCODE,1) 
      LET g_success = 'N'
   END IF
   DELETE FROM apg_file WHERE apg01=g_ooa.ooa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('apg01','g_ooa.ooa01','del apg',SQLCA.SQLCODE,1) 
      LET g_success = 'N'
   END IF
   DELETE FROM aph_file WHERE aph01=g_ooa.ooa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('aph01','g_ooa.ooa01','del aph',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
END FUNCTION

#取得衝帳單的待扺金額
FUNCTION t400_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION

FUNCTION t400_omc(p_oma00,p_sw) 
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_oob09           LIKE oob_file.oob09  
DEFINE   l_oob10           LIKE oob_file.oob10 
DEFINE   l_oox10           LIKE oox_file.oox10   
DEFINE   p_oma00           LIKE oma_file.oma00   
DEFINE   tot4,tot4t        LIKE type_file.num20_6 
DEFINE   p_sw              LIKE type_file.chr1
 
   LET l_oox10 = 0 
   SELECT SUM(oox10) INTO l_oox10 FROM oox_file 
    WHERE oox00 = 'AR'
      AND oox03 = b_oob.oob06 
      AND oox041 = b_oob.oob19
   IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF 
   IF p_oma00 MATCHES '2*' THEN 
      LET l_oox10 = l_oox10 * -1
   END IF 

   SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19 
      AND oob01=ooa01  AND ooaconf = 'Y'
      AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))   
   IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
   IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
  #取得冲帐单的待抵金额                                                       
   CALL t400_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t                 
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4             
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t   
   LET l_oob09 = l_oob09 +tot4                                                 
   LET l_oob10 = l_oob10 +tot4t
   LET g_sql="UPDATE omc_file ", 
             "   SET omc10=?,omc11=? ",
             " WHERE omc01=? AND omc02=? "
   PREPARE t400_bu_13_p3 FROM g_sql
   EXECUTE t400_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
      LET g_success = 'N' 
   END IF
   LET g_sql="UPDATE omc_file ", 
             "   SET omc13=omc09-omc11+ ",l_oox10, 
             " WHERE omc01=? AND omc02=? "
   PREPARE t400_bu_13_p4 FROM g_sql
   EXECUTE t400_bu_13_p4 USING b_oob.oob06,b_oob.oob19
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
      LET g_success = 'N' 
   END IF
END FUNCTION

FUNCTION t300_omc_check()
   DEFINE l_sql     STRING    
   DEFINE l_amt     LIKE omc_file.omc08
   DEFINE l_amtf    LIKE omc_file.omc09    
   DEFINE l_sum,l_sumf  LIKE  omc_file.omc08     
   DEFINE l_omc     DYNAMIC ARRAY OF RECORD   
          omc02 LIKE omc_file.omc02,
          omc08 LIKE omc_file.omc08,
          omc09 LIKE omc_file.omc09,
          omc10 LIKE omc_file.omc10,
          omc11 LIKE omc_file.omc11,
          omc13 LIKE omc_file.omc13
          END RECORD
   DEFINE l_cnt     LIKE type_file.num10
 
   CALL l_omc.clear()
   LET l_cnt =1
 
   LET l_sql ="SELECT omc02,omc08,omc09,omc10,omc11,omc13",
      "  FROM omc_file",
      " WHERE omc01 = ?",
      " ORDER BY omc02"
   PREPARE t300_omc_p FROM l_sql                                                                                                       
   DECLARE omc_curs_c CURSOR FOR t300_omc_p
 
   LET l_sumf =0
   LET l_sum =0
   SELECT oma55,oma57 INTO l_amtf,l_amt FROM oma_file
     WHERE oma01=g_oma.oma01
   UPDATE omc_file SET omc10=0,omc11=0,omc13=0 WHERE omc01=g_oma.oma01
   FOREACH omc_curs_c USING g_oma.oma01 INTO l_omc[l_cnt].* 
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                    
         LET g_success='N'
         EXIT FOREACH                                                                                                               
      END IF      
      IF cl_null(l_omc[l_cnt].omc08) THEN
         LET l_omc[l_cnt].omc08 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc09) THEN
         LET l_omc[l_cnt].omc09 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc10) THEN
         LET l_omc[l_cnt].omc10 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc11) THEN
         LET l_omc[l_cnt].omc11 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc13) THEN
         LET l_omc[l_cnt].omc13 =0
      END IF
      LET l_sumf=l_sumf+ l_omc[l_cnt].omc08
      LET l_sum =l_sum + l_omc[l_cnt].omc09
      IF l_amtf <= l_omc[l_cnt].omc08 THEN   
         UPDATE omc_file SET omc10=l_amtf,
                             omc11=l_amt,
                             omc13=l_omc[l_cnt].omc09-l_amt
          WHERE omc01 = g_oma.oma01
            AND omc02 = l_omc[l_cnt].omc02
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('upd omc_file',g_oma.oma01,'',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         LET l_amtf = 0 #既表示此筆沖漲以全數歸在此項次之中,因此後續無須計算 
         LET l_amt  = 0 
      ELSE
         IF l_amt >=l_omc[l_cnt].omc09 THEN
            UPDATE omc_file SET omc10=l_omc[l_cnt].omc08,
                                omc11=l_omc[l_cnt].omc09,
                                omc13= 0
             WHERE omc01=g_oma.oma01
               AND omc02 = l_omc[l_cnt].omc02
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('upd omc_file',g_oma.oma01,'',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
            LET l_amtf = l_amtf - l_omc[l_cnt].omc08  
            LET l_amt  = l_amt  - l_omc[l_cnt].omc09    
         ELSE
            UPDATE omc_file SET omc10=l_omc[l_cnt].omc08,
                                omc11=l_amt,
                                omc13=l_omc[l_cnt].omc09-l_amt
             WHERE omc01=g_oma.oma01
               AND omc02 = l_omc[l_cnt].omc02
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('upd omc_file',g_oma.oma01,'',SQLCA.sqlcode,1)  
               LET g_success='N'
            END IF
            LET l_amtf = l_amtf - l_omc[l_cnt].omc08  
            LET l_amt =0
         END IF
      END IF
      LET l_cnt = l_cnt + 1                                                                                                         
   END FOREACH
   CALL l_omc.deleteElement(l_cnt)                                                                                                  
END FUNCTION

FUNCTION p605_agl_check(p_lub14)
   DEFINE p_lub14   LIKE lub_file.lub14
   DEFINE l_aba19   LIKE aba_file.aba19

   SELECT * INTO g_ooa.* FROM ooa_file,oob_file
    WHERE ooa01 = oob01
      AND oob06 = p_lub14

   CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ooa.ooa33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-370',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p
      LET g_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ooa.ooa33,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE aba_pre FROM g_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-071',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_lub14

   CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_oma.oma33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-370',1)
         LET g_success='N'
         RETURN
      END IF
   END If
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p
      LET g_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_oma.oma33,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE aba_pre1 FROM g_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1 
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('oma01',g_oma.oma01,'','axr-071',1)
         LET g_success='N'
         RETURN
      END IF
   END IF

END FUNCTION

FUNCTION p605_agl_uncarry(p_lub14)
   DEFINE p_lub14   LIKE lub_file.lub14
   DEFINE l_aba19   LIKE aba_file.aba19

   SELECT * INTO g_ooa.* FROM ooa_file,oob_file
    WHERE ooa01 = oob01
      AND oob06 = p_lub14

   IF NOT cl_null(g_ooa.ooa33) THEN
      CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1

      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa.ooa33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)

   END IF

   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_lub14
   IF NOT cl_null(g_oma.oma33) THEN
      CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1

      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_oma.oma33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)

   END IF

END FUNCTION

#No.FUN-C30029

