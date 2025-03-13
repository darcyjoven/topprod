# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_lotcheck.4gl
# Descriptions...: 批/序號盤點作業
# Date & Author..: No.FUN-860001 08/06/02 By Sherry
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.FUN-8A0147 08/11/03 By douzh 批序號-盤點調整
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-BB0084 11/12/08 By lixh1 增加數量欄位小數取位
# Modify.........: No.MOD-C30065 12/03/09 By ck2yuan 多INSERT pias10,11,12 ,pias10改抓img09
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_pias01        LIKE pias_file.pias01,  
    g_pias02        LIKE pias_file.pias02,  
    g_pias03        LIKE pias_file.pias03,  
    g_pias04        LIKE pias_file.pias04,  
    g_pias05        LIKE pias_file.pias05,  
    g_pias10        LIKE pias_file.pias10,  
    g_qty           LIKE pias_file.pias09,          #No.FUN-8A0147
    g_ima02         LIKE ima_file.ima02,  
    g_ima021        LIKE ima_file.ima021,  
    g_pias          DYNAMIC ARRAY of RECORD
                       pias06     LIKE pias_file.pias06,
                       pias07     LIKE pias_file.pias07,
                       pias09     LIKE pias_file.pias09,
                       cqty       LIKE pias_file.pias09,        #No.FUN-8A0147
                       cdate      LIKE type_file.dat,           #No.FUN-8A0147
                       empno      LIKE pias_file.pias11,        #No.FUN-8A0147
                       gen02      LIKE gen_file.gen02           #No.FUN-8A0147
 
                    END RECORD,
    g_pias_t        RECORD
                       pias06     LIKE pias_file.pias06,
                       pias07     LIKE pias_file.pias07,
                       pias09     LIKE pias_file.pias09,
                       cqty       LIKE pias_file.pias09,        #No.FUN-8A0147
                       cdate      LIKE type_file.dat,           #No.FUN-8A0147
                       empno      LIKE pias_file.pias11,        #No.FUN-8A0147
                       gen02      LIKE gen_file.gen02           #No.FUN-8A0147
                    END RECORD,
    g_sql           STRING,
    g_wc            STRING,
    g_rec_b         LIKE type_file.num5,  
    l_ac            LIKE type_file.num5, 
    g_argv1         LIKE pias_file.pias01,  
    g_argv2         LIKE pias_file.pias02,  
    g_argv3         LIKE pias_file.pias03, 
    g_argv4         LIKE pias_file.pias04,
    g_argv5         LIKE pias_file.pias05,
    g_argv6         LIKE pias_file.pias09,         #No.FUN-8A0147
    g_argv7         LIKE type_file.chr3            #No.FUN-8A0147
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_chr           LIKE type_file.chr1 
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_msg           LIKE type_file.chr1000 
DEFINE mi_no_ask       LIKE type_file.num5 
DEFINE g_jump          LIKE type_file.num10
DEFINE g_before_input_done LIKE type_file.num5,
       p_row,p_col  LIKE type_file.num5,
       li_result    LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE l_i          LIKE type_file.chr1           #No.FUN-8A0147
DEFINE n_qty        LIKE pias_file.pias09         #No.FUN-8A0147
 
#FUNCTION s_lotcheck(p_no,p_item,p_stk,p_loc,p_lot)             #No.FUN-8A0147
FUNCTION s_lotcheck(p_no,p_item,p_stk,p_loc,p_lot,p_qty,p_act)  #No.FUN-8A0147
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE p_no            LIKE pias_file.pias01,
          p_item          LIKE pias_file.pias02,
          p_stk           LIKE pias_file.pias03,
          p_loc           LIKE pias_file.pias04,
          p_lot           LIKE pias_file.pias05,   
          p_qty           LIKE pias_file.pias09,    #No.FUN-8A0147
          p_act           LIKE type_file.chr3       #No.FUN-8A0147
   DEFINE ls_tmp STRING
 
   IF p_no IS NULL THEN RETURN END IF
 
   LET g_argv1 = p_no  
   LET g_argv2 = p_item
   LET g_argv3 = p_stk
   LET g_argv4 = p_loc 
   LET g_argv5 = p_lot 
   LET g_argv6 = p_qty               #No.FUN-8A0147
   LET g_argv7 = p_act               #No.FUN-8A0147
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_row = 2 LET p_col = 4
 
   OPEN WINDOW s_lotcheck_w AT p_row,p_col WITH FORM "sub/42f/s_lotcheck"
     ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_lotcheck")
 
   CALL g_pias.clear()
  
   LET l_i = "N"                     #No.FUN-8A0147
   LET n_qty = 0                     #No.FUN-8A0147
 
   CALL s_lotcheck_show()
 
#No.FUN-8A0147--begin 
   IF g_argv7 = 'SET' THEN
      CALL s_lotcheck_b()
   END IF
#No.FUN-8A0147--end 
 
   CALL s_lotcheck_menu()
 
   CLOSE WINDOW s_lotcheck_w
   
   RETURN l_i,n_qty                #No.FUN-8A0147
 
END FUNCTION
 
FUNCTION s_lotcheck_menu()
 
   WHILE TRUE
      CALL s_lotcheck_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL s_lotcheck_b()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET INT_FLAG = 0
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION s_lotcheck_show()
 
   LET g_pias01 = g_argv1
   LET g_pias02 = g_argv2
   LET g_pias03 = g_argv3
   LET g_pias04 = g_argv4
   LET g_pias05 = g_argv5
   LET g_qty    = g_argv6                #No.FUN-8A0147
 
   DISPLAY g_pias01,g_pias02,g_pias03,g_pias04,g_pias05
        TO pias01,pias02,pias03,
           pias04,pias05          
   DISPLAY g_qty TO FORMONLY.qty
 
  #MOD-C30065 str------
  #SELECT pias10
  #  INTO g_pias10
  #  FROM pias_file
  # WHERE pias01 = g_pias01
   SELECT img09
     INTO g_pias10
     FROM img_file
    WHERE img01 = g_pias02 AND img02 = g_pias03
      AND img03 = g_pias04 AND img04 = g_pias05
  #MOD-C30065 end------
   DISPLAY g_pias10 TO pias10
 
   SELECT ima02,ima021
     INTO g_ima02,g_ima021
     FROM ima_file
    WHERE ima01 = g_pias02
   DISPLAY g_ima02,g_ima021 TO ima02,ima021
 
#No.FUN-8A0147--begin
#  IF g_prog='aimt820' THEN
#     SELECT pia30 INTO g_qty FROM pia_file
#      WHERE pia01=g_pias01 
#  END IF
#  IF g_prog='aimt821' THEN
#     SELECT pia40 INTO g_qty FROM pia_file
#      WHERE pia01=g_pias01 
#  END IF
#  IF g_prog='aimt850' THEN
#     SELECT pia50 INTO g_qty FROM pia_file
#      WHERE pia01=g_pias01 
#  END IF
#  IF g_prog='aimt851' THEN
#     SELECT pia60 INTO g_qty FROM pia_file
#      WHERE pia01=g_pias01
#  END IF
#  IF g_qty IS NULL THEN LET g_qty=0 END IF
#  DISPLAY g_qty TO qty
#No.FUN-8A0147--end
 
   CALL s_lotcheck_b_fill()
 
END FUNCTION
 
FUNCTION s_lotcheck_b_fill()
   DEFINE l_qty   LIKE pias_file.pias09
 
   DECLARE pias_curs CURSOR FOR
           SELECT pias06,pias07,pias09,'','','',''        #No.FUN-8A0147
             FROM pias_file
            WHERE pias01 = g_pias01
              AND pias02 = g_pias02
              AND pias03 = g_pias03
              AND pias04 = g_pias04
              AND pias05 = g_pias05
            ORDER BY pias06,pias07
 
   CALL g_pias.clear()
 
   LET g_cnt = 1
 
   FOREACH pias_curs INTO g_pias[g_cnt].*             #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL s_lotcheck_getqty(g_cnt)              
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pias.deleteElement(g_cnt)
 
   LET g_rec_b= g_cnt-1
 
END FUNCTION
 
FUNCTION s_lotcheck_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pias TO s_pias.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION s_lotcheck_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_row,l_col     LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_desc       LIKE ima_file.ima02
   DEFINE l_qty        LIKE pias_file.pias09
   DEFINE l_n2         LIKE type_file.num5 
 
   LET g_action_choice = ""
 
   IF g_pias01 IS NULL THEN RETURN END IF
 
#No.FUN-8A0147--begin
   IF g_argv7 = "QRY" THEN
      RETURN
   END IF
#No.FUN-8A0147--end
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT pias06,pias07,pias09,'','','','' ",
                      "   FROM pias_file ",
                      "  WHERE pias01 = ? ",
                      "    AND pias06 = ? ",
                      "    AND pias07 = ? ",
                      "    FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_lotcheck_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pias WITHOUT DEFAULTS FROM s_pias.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success='Y'
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_pias_t.* = g_pias[l_ac].*
            OPEN s_lotcheck_bcl 
            USING g_pias01,
                  g_pias_t.pias06,
                  g_pias_t.pias07 
            IF STATUS THEN
               CALL cl_err("OPEN s_lotcheck_bcl:", STATUS, 1)
               CLOSE s_lotcheck_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH s_lotcheck_bcl INTO g_pias[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock pias',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL s_lotcheck_getqty(l_ac)  
               CALL s_lotcheck_set_noentry_b()
            END IF
            CALL cl_show_fld_cont()   
#No.FUN-8A0147--begin
         ELSE
            CALL s_lotcheck_set_entry_b()
#No.FUN-8A0147--end
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_pias[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_pias[l_ac].* TO s_pias.*
            CALL g_pias.deleteElement(l_ac)
            EXIT INPUT
         END IF
 
         IF cl_null(g_pias[l_ac].pias06) THEN
            LET g_pias[l_ac].pias06 = " "
         END IF
 
         IF cl_null(g_pias[l_ac].pias07) THEN
            LET g_pias[l_ac].pias07 = " "
         END IF
 
#No.FUN-8A0147--begin
#        INSERT INTO pias_file(pias01,pias02,pias03,pias04,pias05,
#                              pias06,pias07)
#                       VALUES(g_pias01,g_pias02,g_pias03,
#                              g_pias04,g_pias05,
#                              g_pias[l_ac].pias06,
#                              g_pias[l_ac].pias07
#                             )
         IF g_prog='aimt820' OR g_prog='aimt830'OR g_prog='aimt826'  THEN
            INSERT INTO pias_file(pias01,pias02,pias03,pias04,pias05,
                                  pias06,pias07,pias09,pias10,pias11,pias12,pias30,pias34,pias35,                 #MOD-C30065 add pias10,pias11,pias12
                                  piasplant,piaslegal)  #FUN-980012 add
                           VALUES(g_pias01,g_pias02,g_pias03,
                                  g_pias04,g_pias05,g_pias[l_ac].pias06,
                                  g_pias[l_ac].pias07,g_pias[l_ac].pias09,
                                  g_pias10,g_user,g_today,                            #MOD-C30065 add
                                  g_pias[l_ac].cqty,g_pias[l_ac].empno,
                                  g_pias[l_ac].cdate,
                                  g_plant,g_legal       #FUN-980012 add
                                 )
         END IF
         IF g_prog='aimt821' THEN
            INSERT INTO pias_file(pias01,pias02,pias03,pias04,pias05,
                                  pias06,pias07,pias09,pias10,pias11,pias12,pias40,pias44,pias45,                  #MOD-C30065 add pias10,pias11,pias12
                                  piasplant,piaslegal)  #FUN-980012 add
                           VALUES(g_pias01,g_pias02,g_pias03,
                                  g_pias04,g_pias05,g_pias[l_ac].pias06,
                                  g_pias[l_ac].pias07,g_pias[l_ac].pias09,
                                  g_pias10,g_user,g_today,                            #MOD-C30065 add
                                  g_pias[l_ac].cqty,g_pias[l_ac].empno,
                                  g_pias[l_ac].cdate,
                                  g_plant,g_legal       #FUN-980012 add
                                 )
         END IF
         IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN
            INSERT INTO pias_file(pias01,pias02,pias03,pias04,pias05,
                                  pias06,pias07,pias09,pias10,pias11,pias12,pias50,pias54,pias55,                  #MOD-C30065 add pias10,pias11,pias12
                                  piasplant,piaslegal)  #FUN-980012 add
                           VALUES(g_pias01,g_pias02,g_pias03,
                                  g_pias04,g_pias05,g_pias[l_ac].pias06,
                                  g_pias[l_ac].pias07,g_pias[l_ac].pias09,
                                  g_pias10,g_user,g_today,                            #MOD-C30065 add
                                  g_pias[l_ac].cqty,g_pias[l_ac].empno,
                                  g_pias[l_ac].cdate,
                                  g_plant,g_legal       #FUN-980012 add
                                 )
         END IF
         IF g_prog='aimt851' OR g_prog='aimt861' THEN                             
            INSERT INTO pias_file(pias01,pias02,pias03,pias04,pias05,
                                  pias06,pias07,pias09,pias10,pias11,pias12,pias60,pias64,pias65,                   #MOD-C30065 add pias10,pias11,pias12
                                  piasplant,piaslegal)  #FUN-980012 add
                           VALUES(g_pias01,g_pias02,g_pias03,
                                  g_pias04,g_pias05,g_pias[l_ac].pias06,
                                  g_pias[l_ac].pias07,g_pias[l_ac].pias09,
                                  g_pias10,g_user,g_today,                            #MOD-C30065 add
                                  g_pias[l_ac].cqty,g_pias[l_ac].empno,
                                  g_pias[l_ac].cdate,
                                  g_plant,g_legal       #FUN-980012 add
                                 )
         END IF
#No.FUN-8A0147--end
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pias_file",g_pias01,"",STATUS,"","",1)
            LET g_success = 'N'
            ROLLBACK WORK
            CANCEL INSERT
         END IF
         IF g_success='Y' THEN
            LET g_rec_b=g_rec_b+1
            MESSAGE 'Insert Ok'
            COMMIT WORK
         ELSE
            CANCEL INSERT
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_pias[l_ac].* TO NULL 
         LET g_pias_t.* = g_pias[l_ac].* 
#No.FUN-8A0147--begin
#        IF l_ac > 1 THEN
#           LET g_pias[l_ac].pias06 = g_pias[l_ac-1].pias06
#        END IF
         IF g_rec_b < l_ac THEN
            LET g_pias[l_ac].pias09 = 0
            DISPLAY g_pias[l_ac].pias09 TO pias09
         END IF
#No.FUN-8A0147--end
         CALL cl_show_fld_cont()
         NEXT FIELD pias06
 
      AFTER FIELD pias07          #check是否重複
         IF NOT cl_null(g_pias[l_ac].pias07) THEN
            IF g_pias[l_ac].pias07  != g_pias_t.pias07  OR
               g_pias_t.pias07  IS NULL THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM pias_file
                WHERE pias01 = g_pias01
                  AND pias06  = g_pias[l_ac].pias06 
                  AND pias07  = g_pias[l_ac].pias07
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0) 
                  NEXT FIELD pias06 
               END IF
            END IF
         END IF
 
#No.FUN-8A0147--begin
      AFTER FIELD cqty
           IF g_pias[l_ac].cqty < 0 THEN 
              NEXT FIELD cqty
           END IF 
           LET g_pias[l_ac].cqty = s_digqty(g_pias[l_ac].cqty,g_pias10)    #FUN-BB0084
           DISPLAY BY NAME g_pias[l_ac].cqty            #FUN-BB0084          
 
      AFTER FIELD empno    #盤點人員
           IF g_pias[l_ac].empno IS NOT NULL AND g_pias[l_ac].empno !=' ' THEN   
              CALL s_lotcheck_empno('d')
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_pias[l_ac].empno,g_errno,0)
                 LET g_pias[l_ac].empno = g_pias_t.empno
                 DISPLAY BY NAME g_pias[l_ac].empno 
                 NEXT FIELD empno  
               END IF
           END IF  
           IF g_pias[l_ac].empno IS NOT NULL THEN LET g_pias_t.empno = g_pias[l_ac].empno END IF
                  
      AFTER FIELD cdate #盤點日期 
         IF g_pias[l_ac].cdate IS NULL THEN
            LET g_pias[l_ac].cdate = g_today
            DISPLAY BY NAME g_pias[l_ac].cdate 
            NEXT FIELD cdate
         END IF
         IF g_pias[l_ac].cdate IS NOT NULL THEN LET g_pias_t.cdate = g_pias[l_ac].cdate END IF
#No.FUN-8A0147--end
          
      BEFORE DELETE            #是否取消單身
#No.FUN-8A0147--begin
         IF g_rec_b >= l_ac THEN
            CALL cl_err("",'aim-', 1)
            CANCEL DELETE
         END IF
#No.FUN-8A0147--end
         IF g_pias_t.pias07  > 0 AND g_pias_t.pias07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','',"", -263, 1) 
               ELSE
                  CALL cl_err("", -263, 1)
               END IF
               CANCEL DELETE
            END IF
 
            DELETE FROM pias_file
             WHERE pias01 = g_pias01
               AND pias06  = g_pias_t.pias06 
               AND pias07  = g_pias_t.pias07 
            IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL cl_err(g_pias_t.pias07,SQLCA.sqlcode,1)
                ROLLBACK WORK
                CANCEL DELETE
            END IF
 
            IF g_success='Y'   THEN
               LET g_rec_b=g_rec_b-1
               COMMIT WORK
               MESSAGE 'Delete Ok'
            END IF
 
            CONTINUE INPUT
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','',9001,0)
            ELSE
               CALL cl_err('',9001,0)
            END IF
 
            LET INT_FLAG = 0
            LET g_pias[l_ac].* = g_pias_t.*
            CLOSE s_lotcheck_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pias[l_ac].pias06,-263,1)
            LET g_pias[l_ac].* = g_pias_t.*
         ELSE
 
            IF cl_null(g_pias[l_ac].pias06) THEN
               LET g_pias[l_ac].pias06 = " "
            END IF
 
            IF cl_null(g_pias[l_ac].pias07) THEN
               LET g_pias[l_ac].pias07 = " "
            END IF
 
          IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN #No.FUN-8A0147 
            UPDATE pias_file
               SET pias30 = g_pias[l_ac].cqty,         #No.FUN-8A0147
                   pias34 = g_pias[l_ac].empno,        #No.FUN-8A0147
                   pias35 = g_pias[l_ac].cdate         #No.FUN-8A0147
             WHERE pias01 = g_pias01
               AND pias06 = g_pias_t.pias06 
               AND pias07 = g_pias_t.pias07 
          END IF
          IF g_prog='aimt821' THEN #No.FUN-8A0147
            UPDATE pias_file
               SET pias40 = g_pias[l_ac].cqty,         #No.FUN-8A0147
                   pias44 = g_pias[l_ac].empno,        #No.FUN-8A0147
                   pias45 = g_pias[l_ac].cdate         #No.FUN-8A0147
             WHERE pias01 = g_pias01
               AND pias06 = g_pias_t.pias06 
               AND pias07 = g_pias_t.pias07 
          END IF
          IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN #No.FUN-8A0147
            UPDATE pias_file
               SET pias50 = g_pias[l_ac].cqty,         #No.FUN-8A0147
                   pias54 = g_pias[l_ac].empno,        #No.FUN-8A0147
                   pias55 = g_pias[l_ac].cdate         #No.FUN-8A0147
             WHERE pias01 = g_pias01
               AND pias06 = g_pias_t.pias06 
               AND pias07 = g_pias_t.pias07 
          END IF
          IF g_prog='aimt851' OR g_prog='aimt861' THEN #No.FUN-8A0147
            UPDATE pias_file
               SET pias60 = g_pias[l_ac].cqty,         #No.FUN-8A0147
                   pias64 = g_pias[l_ac].empno,        #No.FUN-8A0147
                   pias65 = g_pias[l_ac].cdate         #No.FUN-8A0147
             WHERE pias01 = g_pias01
               AND pias06 = g_pias_t.pias06 
               AND pias07 = g_pias_t.pias07 
          END IF
            IF SQLCA.sqlcode THEN
               CALL cl_err('upd pias',SQLCA.sqlcode,1)
               LET g_success = 'N'
               ROLLBACK WORK
            END IF
 
            IF g_success='Y' THEN
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
 
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','',9001,0)
            ELSE
               CALL cl_err('',9001,0)
            END IF
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_pias[l_ac].* = g_pias_t.*
            END IF
            CLOSE s_lotcheck_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE s_lotcheck_bcl
         CALL g_pias.deleteElement(g_rec_b+1)
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
      ON ACTION controlo
         IF INFIELD(pias06) AND l_ac > 1 THEN
            LET g_pias[l_ac].* = g_pias[l_ac-1].*
            LET g_pias[l_ac].pias06 = NULL
            LET g_pias[l_ac].pias07 = NULL
            NEXT FIELD pias06
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(empno) #盤點人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_pias[l_ac].empno
               CALL cl_create_qry() RETURNING g_pias[l_ac].empno
               DISPLAY BY NAME g_pias[l_ac].empno  
               NEXT FIELD empno  
            OTHERWISE EXIT CASE
         END CASE
               
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO") 
 
   END INPUT
 
   CLOSE s_lotcheck_bcl
 
   CALL s_lotcheck_chkqty()
 
END FUNCTION
 
 
FUNCTION s_lotcheck_chkqty()
 
   DEFINE l_qty   LIKE pias_file.pias06
 
   LET l_qty = 0
 
   IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN         #No.FUN-8A0147
     SELECT SUM(pias30) INTO l_qty FROM pias_file WHERE pias01 = g_pias01
   END IF
   IF g_prog='aimt821' THEN             
     SELECT SUM(pias40) INTO l_qty FROM pias_file WHERE pias01 = g_pias01
   END IF
   IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN         #No.FUN-8A0147
     SELECT SUM(pias50) INTO l_qty FROM pias_file WHERE pias01 = g_pias01
   END IF
   IF g_prog='aimt851' OR g_prog='aimt861' THEN         #No.FUN-8A0147
     SELECT SUM(pias60) INTO l_qty FROM pias_file WHERE pias01 = g_pias01
   END IF
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
 
 
   LET g_msg=cl_getmsg('aim-012',g_lang)
   IF g_qty <> l_qty OR g_qty IS NULL THEN
      IF cl_prompt(10,10,g_msg) THEN
         IF g_prog != 'aimt826' THEN                                          #No.FUN-8A0147
            IF g_prog != 'aimt836' THEN                                       #No.FUN-8A0147
               IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN     #No.FUN-8A0147
                  UPDATE pia_file SET pia30=l_qty WHERE pia01=g_pias01
               END IF
               IF g_prog='aimt821' THEN            
                  UPDATE pia_file SET pia40=l_qty WHERE pia01=g_pias01
               END IF
               IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN     #No.FUN-8A0147
                  UPDATE pia_file SET pia50=l_qty WHERE pia01=g_pias01
               END IF
               IF g_prog='aimt851' OR g_prog='aimt861' THEN     #No.FUN-8A0147
                  UPDATE pia_file SET pia60=l_qty WHERE pia01=g_pias01
               END IF
               IF STATUS OR sqlca.sqlerrd[3]=0 THEN
                   CALL cl_err3("upd","pia_file",g_pias01,"",STATUS,"","",1)
               END IF                  
               DISPLAY l_qty TO qty
               LET l_i = 'Y'                      #No.FUN-8A0147
               LET n_qty = l_qty                  #No.FUN-8A0147
            ELSE
               DISPLAY l_qty TO qty
               LET l_i = 'Y'                      #No.FUN-8A0147
               LET n_qty = l_qty                  #No.FUN-8A0147
            END IF                                                            #No.FUN-8A0147
         ELSE
            DISPLAY l_qty TO qty                  #No.FUN-8A0147
            LET l_i = 'Y'                         #No.FUN-8A0147
            LET n_qty = l_qty                     #No.FUN-8A0147
         END IF                                                               #No.FUN-8A0147 
      END IF
   END IF
 
 
END FUNCTION
 
FUNCTION s_lotcheck_getqty(p_ac)
   DEFINE l_qty   LIKE pias_file.pias09
   DEFINE p_ac    LIKE type_file.num5
   DEFINE l_gen01 LIKE gen_file.gen01   #No.FUN-8A0147
   DEFINE l_date  LIKE type_file.dat    #No.FUN-8A0147
   DEFINE l_gen02 LIKE gen_file.gen02   #No.FUN-8A0147
 
   LET l_qty=0
   IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN          #No.FUN-8A0147
#     SELECT pias30 INTO l_qty FROM pias_file                                #No.FUN-8A0147
      SELECT pias30,pias34,pias35 INTO l_qty,l_gen01,l_date FROM pias_file   #No.FUN-8A0147 
       WHERE pias01=g_pias01
         AND pias06=g_pias[p_ac].pias06
         AND pias07=g_pias[p_ac].pias07
   END IF
   IF g_prog='aimt821' THEN
#     SELECT pias40 INTO l_qty FROM pias_file                                #No.FUN-8A0147 
      SELECT pias40,pias44,pias45 INTO l_qty,l_gen01,l_date FROM pias_file   #No.FUN-8A0147 
       WHERE pias01=g_pias01
         AND pias06=g_pias[p_ac].pias06
         AND pias07=g_pias[p_ac].pias07
   END IF
   IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN          #No.FUN-8A0147
#     SELECT pias50 INTO l_qty FROM pias_file                                #No.FUN-8A0147 
      SELECT pias50,pias54,pias55 INTO l_qty,l_gen01,l_date FROM pias_file   #No.FUN-8A0147 
       WHERE pias01=g_pias01
         AND pias06=g_pias[p_ac].pias06
         AND pias07=g_pias[p_ac].pias07
   END IF
   IF g_prog='aimt851' OR g_prog='aimt861' THEN          #No.FUN-8A0147
#     SELECT pias60 INTO l_qty FROM pias_file                                #No.FUN-8A0147 
      SELECT pias60,pias64,pias65 INTO l_qty,l_gen01,l_date FROM pias_file   #No.FUN-8A0147 
       WHERE pias01=g_pias01
         AND pias06=g_pias[p_ac].pias06
         AND pias07=g_pias[p_ac].pias07
   END IF
   IF l_qty IS NULL THEN LET l_qty=0 END IF
   SELECT gen02 INTO l_gen02 FROM gen_file         #No.FUN-8A0147
    WHERE gen01= l_gen01                           #No.FUN-8A0147
   DISPLAY l_gen02 TO FORMONLY.gen02               #No.FUN-8A0147
   LET g_pias[p_ac].cqty  = l_qty
   LET g_pias[p_ac].cdate = l_date                 #No.FUN-8A0147
   LET g_pias[p_ac].empno = l_gen01                #No.FUN-8A0147
   LET g_pias[p_ac].gen02 = l_gen02                #No.FUN-8A0147
 
END FUNCTION
 
#No.FUN-8A0147--begin
FUNCTION s_lotcheck_empno(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_pias[l_ac].empno 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_pias[l_ac].gen02 = l_gen02
       DISPLAY BY NAME g_pias[l_ac].gen02
    END IF
END FUNCTION
 
FUNCTION s_lotcheck_set_entry_b()  
 
   CALL cl_set_comp_entry("pias06,pias07",TRUE)   
 
END FUNCTION
 
FUNCTION s_lotcheck_set_noentry_b()  
 
   CALL cl_set_comp_entry("pias06,pias07",FALSE)   
 
END FUNCTION
#No.FUN-8A0147--end
#No.FUN-860001 
