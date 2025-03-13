# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_icdcount.4gl
# Descriptions...: 刻號/BIN盤點作業
# Date & Author..: No.FUN-B70032 11/08/11 By Jason
# Modify.........: No.CHI-B90001 11/09/02 By Jason 盤點測試調整
# Modify.........: No:FUN-BB0083 11/12/14 By xujing 增加數量欄位小數取位
 
DATABASE ds
#No.FUN-B70032

GLOBALS "../../config/top.global"

DEFINE
    g_piad01        LIKE piad_file.piad01,  
    g_piad02        LIKE piad_file.piad02,  
    g_piad03        LIKE piad_file.piad03,  
    g_piad04        LIKE piad_file.piad04,  
    g_piad05        LIKE piad_file.piad05,  
    g_piad10        LIKE piad_file.piad10,  
    g_qty           LIKE piad_file.piad09,          
    g_ima02         LIKE ima_file.ima02,  
    g_ima021        LIKE ima_file.ima021,  
    g_piad          DYNAMIC ARRAY of RECORD
                       piad06     LIKE piad_file.piad06,
                       piad07     LIKE piad_file.piad07,
                       piad09     LIKE piad_file.piad09,
                       cqty       LIKE piad_file.piad09,        
                       cdate      LIKE type_file.dat,           
                       empno      LIKE piad_file.piad11,        
                       gen02      LIKE gen_file.gen02           
 
                    END RECORD,
    g_piad_t        RECORD
                       piad06     LIKE piad_file.piad06,
                       piad07     LIKE piad_file.piad07,
                       piad09     LIKE piad_file.piad09,
                       cqty       LIKE piad_file.piad09,        
                       cdate      LIKE type_file.dat,           
                       empno      LIKE piad_file.piad11,        
                       gen02      LIKE gen_file.gen02           
                    END RECORD,
    g_sql           STRING,
    g_wc            STRING,
    g_rec_b         LIKE type_file.num5,  
    l_ac            LIKE type_file.num5, 
    g_argv1         LIKE piad_file.piad01,  
    g_argv2         LIKE piad_file.piad02,  
    g_argv3         LIKE piad_file.piad03, 
    g_argv4         LIKE piad_file.piad04,
    g_argv5         LIKE piad_file.piad05,
    g_argv6         LIKE piad_file.piad09,         
    g_argv7         LIKE type_file.chr3            
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
DEFINE l_i          LIKE type_file.chr1           
DEFINE n_qty        LIKE piad_file.piad09         

FUNCTION s_icdcount(p_no,p_item,p_stk,p_loc,p_lot,p_qty,p_act)  
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE p_no            LIKE piad_file.piad01,
          p_item          LIKE piad_file.piad02,
          p_stk           LIKE piad_file.piad03,
          p_loc           LIKE piad_file.piad04,
          p_lot           LIKE piad_file.piad05,   
          p_qty           LIKE piad_file.piad09,    
          p_act           LIKE type_file.chr3       
   DEFINE ls_tmp STRING
 
   IF p_no IS NULL THEN RETURN END IF
 
   LET g_argv1 = p_no  
   LET g_argv2 = p_item
   LET g_argv3 = p_stk
   LET g_argv4 = p_loc 
   LET g_argv5 = p_lot 
   LET g_argv6 = p_qty               
   LET g_argv7 = p_act               
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_row = 2 LET p_col = 4
 
   OPEN WINDOW s_icdcount_w AT p_row,p_col WITH FORM "sub/42f/s_icdcount"
     ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_icdcount")
 
   CALL g_piad.clear()
  
   LET l_i = "N"                     
   LET n_qty = 0                     
 
   CALL s_icdcount_show()
 
 
   IF g_argv7 = 'SET' THEN
      CALL s_icdcount_b()
   END IF
 
 
   CALL s_icdcount_menu()
 
   CLOSE WINDOW s_icdcount_w
   
   RETURN l_i,n_qty                
 
END FUNCTION
 
FUNCTION s_icdcount_menu()
 
   WHILE TRUE
      CALL s_icdcount_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL s_icdcount_b()
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
 
FUNCTION s_icdcount_show()
 
   LET g_piad01 = g_argv1
   LET g_piad02 = g_argv2
   LET g_piad03 = g_argv3
   LET g_piad04 = g_argv4
   LET g_piad05 = g_argv5
   LET g_qty    = g_argv6                
 
   DISPLAY g_piad01,g_piad02,g_piad03,g_piad04,g_piad05
        TO piad01,piad02,piad03,
           piad04,piad05          
   DISPLAY g_qty TO FORMONLY.qty
 
   SELECT piad10
     INTO g_piad10
     FROM piad_file
    WHERE piad01 = g_piad01
   DISPLAY g_piad10 TO piad10
 
   SELECT ima02,ima021
     INTO g_ima02,g_ima021
     FROM ima_file
    WHERE ima01 = g_piad02
   DISPLAY g_ima02,g_ima021 TO ima02,ima021
 
   CALL s_icdcount_b_fill()
 
END FUNCTION
 
FUNCTION s_icdcount_b_fill()
   DEFINE l_qty   LIKE piad_file.piad09
 
   DECLARE piad_curs CURSOR FOR
           SELECT piad06,piad07,piad09,'','','',''        
             FROM piad_file
            WHERE piad01 = g_piad01
              AND piad02 = g_piad02
              AND piad03 = g_piad03
              AND piad04 = g_piad04
              AND piad05 = g_piad05
            ORDER BY piad06,piad07
 
   CALL g_piad.clear()
 
   LET g_cnt = 1
 
   FOREACH piad_curs INTO g_piad[g_cnt].*             #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL s_icdcount_getqty(g_cnt)              
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_piad.deleteElement(g_cnt)
 
   LET g_rec_b= g_cnt-1
 
END FUNCTION
 
FUNCTION s_icdcount_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_piad TO s_piad.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION s_icdcount_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_row,l_col     LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_desc       LIKE ima_file.ima02
   DEFINE l_qty        LIKE piad_file.piad09
   DEFINE l_n2         LIKE type_file.num5 
 
   LET g_action_choice = ""
 
   IF g_piad01 IS NULL THEN RETURN END IF
 

   IF g_argv7 = "QRY" THEN
      RETURN
   END IF

 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT piad06,piad07,piad09,'','','','' ",
                      "   FROM piad_file ",
                      "  WHERE piad01 = ? ",
                      "    AND piad06 = ? ",
                      "    AND piad07 = ? ",
                      "    FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_icdcount_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_piad WITHOUT DEFAULTS FROM s_piad.*
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
            LET g_piad_t.* = g_piad[l_ac].*
            OPEN s_icdcount_bcl 
            USING g_piad01,
                  g_piad_t.piad06,
                  g_piad_t.piad07 
            IF STATUS THEN
               CALL cl_err("OPEN s_icdcount_bcl:", STATUS, 1)
               CLOSE s_icdcount_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH s_icdcount_bcl INTO g_piad[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock piad',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL s_icdcount_getqty(l_ac)  
               CALL s_icdcount_set_noentry_b()
            END IF
            CALL cl_show_fld_cont()   

         ELSE
            CALL s_icdcount_set_entry_b()

         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_piad[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_piad[l_ac].* TO s_piad.*
            CALL g_piad.deleteElement(l_ac)
            EXIT INPUT
         END IF
 
         IF cl_null(g_piad[l_ac].piad06) THEN
            LET g_piad[l_ac].piad06 = " "
         END IF
 
         IF cl_null(g_piad[l_ac].piad07) THEN
            LET g_piad[l_ac].piad07 = " "
         END IF
 

#        INSERT INTO piad_file(piad01,piad02,piad03,piad04,piad05,
#                              piad06,piad07)
#                       VALUES(g_piad01,g_piad02,g_piad03,
#                              g_piad04,g_piad05,
#                              g_piad[l_ac].piad06,
#                              g_piad[l_ac].piad07
#                             )
         IF g_prog='aimt820' OR g_prog='aimt830'OR g_prog='aimt826'  THEN
            INSERT INTO piad_file(piad01,piad02,piad03,piad04,piad05,
                                  piad06,piad07,piad09,
                                  piad10,piad11,piad12,piad19,   #CHI-B90001
                                  piad30,piad34,piad35,   
                                  piadplant,piadlegal)  
                           VALUES(g_piad01,g_piad02,g_piad03,
                                  g_piad04,g_piad05,g_piad[l_ac].piad06,
                                  g_piad[l_ac].piad07,g_piad[l_ac].piad09,
                                  g_piad10,g_user,g_today,'N',  #CHI-B90001   
                                  g_piad[l_ac].cqty,g_piad[l_ac].empno,
                                  g_piad[l_ac].cdate,
                                  g_plant,g_legal       
                                 )
         END IF
         IF g_prog='aimt821' THEN
            INSERT INTO piad_file(piad01,piad02,piad03,piad04,piad05,
                                  piad06,piad07,piad09,
                                  piad10,piad11,piad12,piad19,   #CHI-B90001
                                  piad40,piad44,piad45,
                                  piadplant,piadlegal)  
                           VALUES(g_piad01,g_piad02,g_piad03,
                                  g_piad04,g_piad05,g_piad[l_ac].piad06,
                                  g_piad[l_ac].piad07,g_piad[l_ac].piad09,
                                  g_piad10,g_user,g_today,'N',  #CHI-B90001
                                  g_piad[l_ac].cqty,g_piad[l_ac].empno,
                                  g_piad[l_ac].cdate,
                                  g_plant,g_legal       
                                 )
         END IF
         IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN
            INSERT INTO piad_file(piad01,piad02,piad03,piad04,piad05,
                                  piad06,piad07,piad09,
                                  piad10,piad11,piad12,piad19,   #CHI-B90001
                                  piad50,piad54,piad55,
                                  piadplant,piadlegal)  
                           VALUES(g_piad01,g_piad02,g_piad03,
                                  g_piad04,g_piad05,g_piad[l_ac].piad06,
                                  g_piad[l_ac].piad07,g_piad[l_ac].piad09,
                                  g_piad10,g_user,g_today,'N',  #CHI-B90001
                                  g_piad[l_ac].cqty,g_piad[l_ac].empno,
                                  g_piad[l_ac].cdate,
                                  g_plant,g_legal       
                                 )
         END IF
         IF g_prog='aimt851' OR g_prog='aimt861' THEN                             
            INSERT INTO piad_file(piad01,piad02,piad03,piad04,piad05,
                                  piad06,piad07,piad09,
                                  piad10,piad11,piad12,piad19,   #CHI-B90001
                                  piad60,piad64,piad65,
                                  piadplant,piadlegal)  
                           VALUES(g_piad01,g_piad02,g_piad03,
                                  g_piad04,g_piad05,g_piad[l_ac].piad06,
                                  g_piad[l_ac].piad07,g_piad[l_ac].piad09,
                                  g_piad10,g_user,g_today,'N',  #CHI-B90001
                                  g_piad[l_ac].cqty,g_piad[l_ac].empno,
                                  g_piad[l_ac].cdate,
                                  g_plant,g_legal       
                                 )
         END IF

 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","piad_file",g_piad01,"",STATUS,"","",1)
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
         INITIALIZE g_piad[l_ac].* TO NULL 
         LET g_piad_t.* = g_piad[l_ac].* 

#        IF l_ac > 1 THEN
#           LET g_piad[l_ac].piad06 = g_piad[l_ac-1].piad06
#        END IF
         #IF g_rec_b < l_ac THEN   #CHI-B90001 mark
            LET g_piad[l_ac].piad09 = 0
            DISPLAY g_piad[l_ac].piad09 TO piad09
         #END IF   #CHI-B90001 mark

         CALL cl_show_fld_cont()
         CALL s_icdcount_set_entry_b()
         NEXT FIELD piad06
 
      AFTER FIELD piad07          #check是否重複
         IF NOT cl_null(g_piad[l_ac].piad07) THEN
            IF g_piad[l_ac].piad07  != g_piad_t.piad07  OR
               g_piad_t.piad07  IS NULL THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM piad_file
                WHERE piad01 = g_piad01
                  AND piad06  = g_piad[l_ac].piad06 
                  AND piad07  = g_piad[l_ac].piad07
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0) 
                  NEXT FIELD piad06 
               END IF
            END IF
         END IF
 

      AFTER FIELD cqty
           IF g_piad[l_ac].cqty < 0 THEN 
              NEXT FIELD cqty
           END IF
           #FUN-BB0083---add---str
           LET g_piad[l_ac].cqty = s_digqty(g_piad[l_ac].cqty,g_piad10)
               DISPLAY BY NAME g_piad[l_ac].cqty
           #FUN-BB0083---add---end 
 
      AFTER FIELD empno    #盤點人員
           IF g_piad[l_ac].empno IS NOT NULL AND g_piad[l_ac].empno !=' ' THEN   
              CALL s_icdcount_empno('d')
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_piad[l_ac].empno,g_errno,0)
                 LET g_piad[l_ac].empno = g_piad_t.empno
                 DISPLAY BY NAME g_piad[l_ac].empno 
                 NEXT FIELD empno  
               END IF
           END IF  
           IF g_piad[l_ac].empno IS NOT NULL THEN LET g_piad_t.empno = g_piad[l_ac].empno END IF
                  
      AFTER FIELD cdate #盤點日期 
         IF g_piad[l_ac].cdate IS NULL THEN
            LET g_piad[l_ac].cdate = g_today
            DISPLAY BY NAME g_piad[l_ac].cdate 
            NEXT FIELD cdate
         END IF
         IF g_piad[l_ac].cdate IS NOT NULL THEN LET g_piad_t.cdate = g_piad[l_ac].cdate END IF

          
      BEFORE DELETE            #是否取消單身

         IF g_rec_b < l_ac THEN   #CHI-B90001
            CALL cl_err("",'aim-', 1)
            CANCEL DELETE
         END IF

         #IF g_piad_t.piad07  > 0 AND g_piad_t.piad07 IS NOT NULL THEN
         IF g_piad_t.piad06 IS NOT NULL AND g_piad_t.piad07 IS NOT NULL THEN       
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
 
            DELETE FROM piad_file
             WHERE piad01 = g_piad01
               AND piad06  = g_piad_t.piad06 
               AND piad07  = g_piad_t.piad07 
            IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL cl_err(g_piad_t.piad07,SQLCA.sqlcode,1)
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
            LET g_piad[l_ac].* = g_piad_t.*
            CLOSE s_icdcount_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_piad[l_ac].piad06,-263,1)
            LET g_piad[l_ac].* = g_piad_t.*
         ELSE
 
            IF cl_null(g_piad[l_ac].piad06) THEN
               LET g_piad[l_ac].piad06 = " "
            END IF
 
            IF cl_null(g_piad[l_ac].piad07) THEN
               LET g_piad[l_ac].piad07 = " "
            END IF
 
          IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN  
            UPDATE piad_file
               SET piad30 = g_piad[l_ac].cqty,         
                   piad34 = g_piad[l_ac].empno,        
                   piad35 = g_piad[l_ac].cdate         
             WHERE piad01 = g_piad01
               AND piad06 = g_piad_t.piad06 
               AND piad07 = g_piad_t.piad07 
          END IF
          IF g_prog='aimt821' THEN 
            UPDATE piad_file
               SET piad40 = g_piad[l_ac].cqty,         
                   piad44 = g_piad[l_ac].empno,        
                   piad45 = g_piad[l_ac].cdate         
             WHERE piad01 = g_piad01
               AND piad06 = g_piad_t.piad06 
               AND piad07 = g_piad_t.piad07 
          END IF
          IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN 
            UPDATE piad_file
               SET piad50 = g_piad[l_ac].cqty,         
                   piad54 = g_piad[l_ac].empno,        
                   piad55 = g_piad[l_ac].cdate         
             WHERE piad01 = g_piad01
               AND piad06 = g_piad_t.piad06 
               AND piad07 = g_piad_t.piad07 
          END IF
          IF g_prog='aimt851' OR g_prog='aimt861' THEN 
            UPDATE piad_file
               SET piad60 = g_piad[l_ac].cqty,         
                   piad64 = g_piad[l_ac].empno,        
                   piad65 = g_piad[l_ac].cdate         
             WHERE piad01 = g_piad01
               AND piad06 = g_piad_t.piad06 
               AND piad07 = g_piad_t.piad07 
          END IF
            IF SQLCA.sqlcode THEN
               CALL cl_err('upd piad',SQLCA.sqlcode,1)
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
               LET g_piad[l_ac].* = g_piad_t.*
            END IF
            CLOSE s_icdcount_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE s_icdcount_bcl
         CALL g_piad.deleteElement(g_rec_b+1)
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
      ON ACTION controlo
         IF INFIELD(piad06) AND l_ac > 1 THEN
            LET g_piad[l_ac].* = g_piad[l_ac-1].*
            LET g_piad[l_ac].piad06 = NULL
            LET g_piad[l_ac].piad07 = NULL
            NEXT FIELD piad06
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(empno) #盤點人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_piad[l_ac].empno
               CALL cl_create_qry() RETURNING g_piad[l_ac].empno
               DISPLAY BY NAME g_piad[l_ac].empno  
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
 
   CLOSE s_icdcount_bcl
 
   CALL s_icdcount_chkqty()
 
END FUNCTION
 
 
FUNCTION s_icdcount_chkqty()
 
   DEFINE l_qty   LIKE piad_file.piad09 
 
   LET l_qty = 0
 
   IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN         
     SELECT SUM(piad30) INTO l_qty FROM piad_file WHERE piad01 = g_piad01
   END IF
   IF g_prog='aimt821' THEN             
     SELECT SUM(piad40) INTO l_qty FROM piad_file WHERE piad01 = g_piad01
   END IF
   IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN         
     SELECT SUM(piad50) INTO l_qty FROM piad_file WHERE piad01 = g_piad01
   END IF
   IF g_prog='aimt851' OR g_prog='aimt861' THEN         
     SELECT SUM(piad60) INTO l_qty FROM piad_file WHERE piad01 = g_piad01
   END IF
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
   
   LET n_qty = l_qty
 
   LET g_msg=cl_getmsg('aim-032',g_lang)
   IF g_qty <> l_qty OR g_qty IS NULL THEN
      IF cl_prompt(10,10,g_msg) THEN
         CASE g_prog
            WHEN 'aimt820'
               UPDATE pia_file SET pia30=l_qty WHERE pia01=g_piad01

            WHEN 'aimt850'
               UPDATE pia_file SET pia50=l_qty WHERE pia01=g_piad01   
         END CASE
         DISPLAY l_qty TO qty
         LET l_i = 'Y'

         #IF g_prog != 'aimt826' THEN                                          
            #IF g_prog != 'aimt836' THEN                                       
               #IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN     
                  #UPDATE pia_file SET pia30=l_qty WHERE pia01=g_piad01
               #END IF
               #IF g_prog='aimt821' THEN            
                  #UPDATE pia_file SET pia40=l_qty WHERE pia01=g_piad01
               #END IF
               #IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN     
                  #UPDATE pia_file SET pia50=l_qty WHERE pia01=g_piad01
               #END IF
               #IF g_prog='aimt851' OR g_prog='aimt861' THEN     
                  #UPDATE pia_file SET pia60=l_qty WHERE pia01=g_piad01
               #END IF
               #IF STATUS OR sqlca.sqlerrd[3]=0 THEN
                   #CALL cl_err3("upd","pia_file",g_piad01,"",STATUS,"","",1)
               #END IF                  
               #DISPLAY l_qty TO qty
               #LET l_i = 'Y'                      
               #LET n_qty = l_qty                  
            #ELSE
               #DISPLAY l_qty TO qty
               #LET l_i = 'Y'                      
               #LET n_qty = l_qty                  
            #END IF                                                            
         #ELSE
            #DISPLAY l_qty TO qty                  
            #LET l_i = 'Y'                         
            #LET n_qty = l_qty                     
         #END IF                                                                
      END IF
   END IF
 
 
END FUNCTION
 
FUNCTION s_icdcount_getqty(p_ac)
   DEFINE l_qty   LIKE piad_file.piad09
   DEFINE p_ac    LIKE type_file.num5
   DEFINE l_gen01 LIKE gen_file.gen01   
   DEFINE l_date  LIKE type_file.dat    
   DEFINE l_gen02 LIKE gen_file.gen02   
 
   LET l_qty=0
   IF g_prog='aimt820' OR g_prog='aimt830' OR g_prog='aimt826' THEN          
#     SELECT piad30 INTO l_qty FROM piad_file                                
      SELECT piad30,piad34,piad35 INTO l_qty,l_gen01,l_date FROM piad_file    
       WHERE piad01=g_piad01
         AND piad06=g_piad[p_ac].piad06
         AND piad07=g_piad[p_ac].piad07
   END IF
   IF g_prog='aimt821' THEN
#     SELECT piad40 INTO l_qty FROM piad_file                                 
      SELECT piad40,piad44,piad45 INTO l_qty,l_gen01,l_date FROM piad_file    
       WHERE piad01=g_piad01
         AND piad06=g_piad[p_ac].piad06
         AND piad07=g_piad[p_ac].piad07
   END IF
   IF g_prog='aimt850' OR g_prog='aimt860' OR g_prog='aimt836' THEN          
#     SELECT piad50 INTO l_qty FROM piad_file                                 
      SELECT piad50,piad54,piad55 INTO l_qty,l_gen01,l_date FROM piad_file    
       WHERE piad01=g_piad01
         AND piad06=g_piad[p_ac].piad06
         AND piad07=g_piad[p_ac].piad07
   END IF
   IF g_prog='aimt851' OR g_prog='aimt861' THEN          
#     SELECT piad60 INTO l_qty FROM piad_file                                 
      SELECT piad60,piad64,piad65 INTO l_qty,l_gen01,l_date FROM piad_file    
       WHERE piad01=g_piad01
         AND piad06=g_piad[p_ac].piad06
         AND piad07=g_piad[p_ac].piad07
   END IF
   IF l_qty IS NULL THEN LET l_qty=0 END IF
   SELECT gen02 INTO l_gen02 FROM gen_file         
    WHERE gen01= l_gen01                           
   DISPLAY l_gen02 TO FORMONLY.gen02               
   LET g_piad[p_ac].cqty  = l_qty
   LET g_piad[p_ac].cdate = l_date                 
   LET g_piad[p_ac].empno = l_gen01                
   LET g_piad[p_ac].gen02 = l_gen02                
 
END FUNCTION
 

FUNCTION s_icdcount_empno(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_piad[l_ac].empno 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_piad[l_ac].gen02 = l_gen02
       DISPLAY BY NAME g_piad[l_ac].gen02
    END IF
END FUNCTION
 
FUNCTION s_icdcount_set_entry_b()  
 
   CALL cl_set_comp_entry("piad06,piad07",TRUE)   
 
END FUNCTION
 
FUNCTION s_icdcount_set_noentry_b()  
 
   CALL cl_set_comp_entry("piad06,piad07",FALSE)   
 
END FUNCTION

#No.FUN-860001 
