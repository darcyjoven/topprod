# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Program name...: axci004.4gl
# Descriptions...: 成本性质科目对应表
# Date & Author..: 12/08/07 by jiangxt
# Modify.........: No.FUN-C80092 12/10/10 By fengrui 測試問題修改
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ckb         DYNAMIC ARRAY OF RECORD
            ckb01         LIKE ckb_file.ckb01,
            ckb02         LIKE ckb_file.ckb02,
            ckb03         LIKE ckb_file.ckb03,
            aag02         LIKE aag_file.aag02,  #FUN-C80092 add
            ckb04         LIKE ckb_file.ckb04
                        END RECORD,
         g_ckb_t       RECORD
            ckb01         LIKE ckb_file.ckb01,
            ckb02         LIKE ckb_file.ckb02,
            ckb03         LIKE ckb_file.ckb03,
            aag02         LIKE aag_file.aag02,  #FUN-C80092 add
            ckb04         LIKE ckb_file.ckb04
                        END RECORD
DEFINE   g_sql          string,                       #No.FUN-580092 HCN
         g_cnt          LIKE type_file.num10,         #No.FUN-680135 INTEGER
         l_ac           LIKE type_file.num5,          #No.FUN-680135 SMALLINT
         g_rec_b        LIKE type_file.num5           #No.FUN-680135 SMALLINT
DEFINE   g_wc2          STRING,                       #No.FUN-580092 HCN
         g_i            LIKE type_file.num5           #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   l_str1         LIKE aag_file.aag01,
         g_depno        LIKE type_file.chr20,
         g_ckb01_t  LIKE ckb_file.ckb01,
         g_ckb02_t  LIKE ckb_file.ckb02,
         g_ckb03_t  LIKE ckb_file.ckb03  
DEFINE   g_before_input_done   LIKE type_file.num5    #NO.MOD-580056 #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)  RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW axci004_w WITH FORM "axc/42f/axci004"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   LET l_str1 = g_depno CLIPPED,'%' CLIPPED
   CALL cl_ui_init()
   CALL axci004_b_fill(' 1=1')  #FUN-C80092 add
   CALL axci004_menu()
 
   CLOSE WINDOW axci004_w
 
   CALL cl_used(g_prog,g_time,2)  RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION axci004_menu()
   LET g_action_choice = " "
   WHILE TRUE
      CALL axci004_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL axci004_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL axci004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ckb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION axci004_q()
   CALL axci004_b_askkey()
END FUNCTION
 
FUNCTION axci004_b()
   DEFINE   l_ac_t           LIKE type_file.num5,          #No.FUN-680135 SMALLINT 
            l_n              LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_lock_sw        LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
            l_allow_insert   LIKE type_file.num5,          #No.FUN-680135 VARCHAR(1)
            l_allow_delete   LIKE type_file.num5,          #No.FUN-680135 VARCHAR(1)
            l_aaaacti        LIKE aaa_file.aaaacti,
            l_aag20          LIKE aag_file.aag20,
            l_cnt            LIKE type_file.num5,
            l_ckb01_t        LIKE ckb_file.ckb01,          #No.FUN-C80092
            l_msg            STRING                        #No.FUN-C80092 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * FROM ckb_file WHERE ckb01 = ? AND ckb02=? AND ckb03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE axci004_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_ckb WITHOUT DEFAULTS FROM s_ckb.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED=TRUE,   #FUN-940014
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_ckb_t.* =g_ckb[l_ac].*
            LET l_ckb01_t =g_ckb[l_ac].ckb01  #FUN-C80092 
            LET g_before_input_done = FALSE
            CALL p_auth_as_set_entry_b(p_cmd)
            CALL p_auth_as_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
            OPEN axci004_bcl USING g_ckb_t.ckb01,g_ckb_t.ckb02,g_ckb_t.ckb03
            IF STATUS THEN
               CALL cl_err("OPEN axci004_bcl:",STATUS,1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH axci004_bcl INTO g_ckb[l_ac].ckb01,g_ckb[l_ac].ckb02,g_ckb[l_ac].ckb03,g_ckb[l_ac].ckb04  #FUN-C80092 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ckb_t.ckb01,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_ckb[l_ac].* TO NULL
         LET g_ckb[l_ac].ckb04 = 'Y' #FUN-C80092 add
         LET g_ckb_t.* = g_ckb[l_ac].*
         LET l_ckb01_t = g_ckb[l_ac].ckb01  #FUN-C80092 
         LET g_before_input_done = FALSE
         CALL p_auth_as_set_entry_b(p_cmd)
         CALL p_auth_as_set_no_entry_b(p_cmd)
         LET  g_before_input_done = TRUE
         CALL cl_show_fld_cont()  
 
      AFTER FIELD ckb01
         IF NOT cl_null(g_ckb[l_ac].ckb01) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_ckb[l_ac].ckb01                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","ckb_file",g_ckb[l_ac].ckb01,"",100,"","",1)            
               NEXT FIELD ckb01                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_ckb[l_ac].ckb01,"9028",1)                                    
               NEXT FIELD ckb01                                                 
            END IF                                                               
            #FUN-C80092--add--str--
            IF l_ckb01_t IS NOT NULL AND l_ckb01_t!=g_ckb[l_ac].ckb01 THEN  
               LET g_ckb[l_ac].ckb03 = ''      
            END IF  
            IF NOT cl_null(g_ckb[l_ac].ckb03) THEN
               LET l_cnt = 0 
               SELECT COUNT(*) INTO l_cnt FROM aag_file
                WHERE aag00=g_ckb[l_ac].ckb01
                  AND aag01=g_ckb[l_ac].ckb03
               IF l_cnt = 0 THEN
                  LET l_msg = g_ckb[l_ac].ckb01 , "+" ,g_ckb[l_ac].ckb03
                  CALL cl_err(l_msg,"mfg9329",1)
                  NEXT FIELD ckb01
               ELSE  
                  SELECT COUNT(*) INTO l_cnt FROM aag_file
                   WHERE aag00=g_ckb[l_ac].ckb01
                     AND aag01=g_ckb[l_ac].ckb03
                     AND aagacti = 'N'
                  LET l_msg = g_ckb[l_ac].ckb01 , "+" ,g_ckb[l_ac].ckb03
                  IF l_cnt >= 1 THEN CALL cl_err(l_msg,"9028",1) END IF
               END IF
            END IF        
            LET l_ckb01_t = g_ckb[l_ac].ckb01  
            IF NOT cl_null(g_ckb[l_ac].ckb01) AND NOT cl_null(g_ckb[l_ac].ckb02)
               AND NOT cl_null(g_ckb[l_ac].ckb03) THEN 
               IF g_ckb_t.ckb03 IS NULL OR  #新增/修改 判斷不可重複
                 (g_ckb_t.ckb03 IS NOT NULL AND g_ckb_t.ckb03!=g_ckb[l_ac].ckb03) THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM ckb_file
                   WHERE ckb01 = g_ckb[l_ac].ckb01
                     AND ckb02 = g_ckb[l_ac].ckb02
                     AND ckb03 = g_ckb[l_ac].ckb03
                  IF l_cnt > 0 THEN
                     CALL cl_err('','axc-132',1)
                     NEXT FIELD ckb01
                  END IF 
               END IF      
            END IF    
            #FUN-C80092--add--end--
            DISPLAY BY NAME g_ckb[l_ac].ckb01,g_ckb[l_ac].ckb03 
         END IF
         
      #FUN-C80092--add--str--
      AFTER FIELD ckb02
         IF NOT cl_null(g_ckb[l_ac].ckb01) AND NOT cl_null(g_ckb[l_ac].ckb02) 
            AND NOT cl_null(g_ckb[l_ac].ckb03) THEN 
            IF g_ckb_t.ckb03 IS NULL OR  #新增/修改 判斷不可重複 
              (g_ckb_t.ckb03 IS NOT NULL AND g_ckb_t.ckb03!=g_ckb[l_ac].ckb03) THEN  
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ckb_file
                WHERE ckb01 = g_ckb[l_ac].ckb01
                  AND ckb02 = g_ckb[l_ac].ckb02
                  AND ckb03 = g_ckb[l_ac].ckb03
               IF l_cnt > 0 THEN
                  CALL cl_err('','axc-132',1)
                  NEXT FIELD ckb02
               END IF
            END IF 
         END IF
      #FUN-C80092--add--end--

      AFTER FIELD ckb03
           IF NOT cl_null(g_ckb[l_ac].ckb03) THEN
               #FUN-C80092--add--str--
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM aag_file
                WHERE aag01=g_ckb[l_ac].ckb03
               IF l_cnt = 0 THEN
                  CALL cl_err(g_ckb[l_ac].ckb03,"mfg9329",1)
                  NEXT FIELD ckb03
               END IF
               IF NOT cl_null(g_ckb[l_ac].ckb01) THEN 
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM aag_file
                   WHERE aag00=g_ckb[l_ac].ckb01
                     AND aag01=g_ckb[l_ac].ckb03
                  IF l_cnt = 0 THEN
                     LET l_msg = g_ckb[l_ac].ckb01 , "+" ,g_ckb[l_ac].ckb03
                     CALL cl_err(l_msg,"mfg9329",1)
                     NEXT FIELD ckb03
                  ELSE 
                     SELECT COUNT(*) INTO l_cnt FROM aag_file
                      WHERE aag00=g_ckb[l_ac].ckb01
                        AND aag01=g_ckb[l_ac].ckb03
                       AND aagacti = 'N'
                     IF l_cnt >= 1 THEN
                        LET l_msg = g_ckb[l_ac].ckb01 , "+" ,g_ckb[l_ac].ckb03
                        CALL cl_err(l_msg,"9028",1)
                     END IF 
                  END IF
               END IF 
               IF NOT cl_null(g_ckb[l_ac].ckb01) AND NOT cl_null(g_ckb[l_ac].ckb02) THEN 
                  IF g_ckb_t.ckb03 IS NULL OR  #新增/修改 判斷不可重複 
                    (g_ckb_t.ckb03 IS NOT NULL AND g_ckb_t.ckb03!=g_ckb[l_ac].ckb03) THEN  
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM ckb_file
                      WHERE ckb01 = g_ckb[l_ac].ckb01
                        AND ckb02 = g_ckb[l_ac].ckb02
                        AND ckb03 = g_ckb[l_ac].ckb03
                     IF l_cnt > 0 THEN
                        CALL cl_err('','axc-132',1)
                        NEXT FIELD ckb03
                     END IF
                  END IF 
               END IF
               #FUN-C80092--add--end--
               IF g_ckb_t.ckb03 IS NOT NULL AND g_ckb_t.ckb03!=g_ckb[l_ac].ckb03 THEN
                  SELECT aag20 INTO l_aag20 FROM aag_file
                   WHERE aag01=g_ckb_t.ckb03
                     AND aag00=g_ckb[l_ac].ckb01   
                  IF STATUS=0 AND l_aag20='Y' THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM abh_file
                      WHERE abh00=g_ckb[l_ac].ckb01 
                        AND abh03=g_ckb_t.ckb03
                     IF l_cnt > 0 THEN
                        CALL cl_err(g_ckb_t.ckb03,'agl-894',0)
                        LET g_ckb[l_ac].ckb03 = g_ckb_t.ckb03
                        DISPLAY BY NAME g_ckb[l_ac].ckb03
                        NEXT FIELD ckb03
                     END IF
                  END IF
               END IF
               #FUN-C80092--add--str--
               IF NOT cl_null(g_ckb[l_ac].ckb01) THEN
                  SELECT aag02 INTO g_ckb[l_ac].aag02 FROM aag_file 
                  WHERE aag00 = g_ckb[l_ac].ckb01
                     AND aag01 = g_ckb[l_ac].ckb03
                  DISPLAY BY NAME g_ckb[l_ac].aag02
               END IF 
               #FUN-C80092--add--end--
           END IF
           
      BEFORE DELETE
         IF g_ckb_t.ckb01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err("",-263,1)
               CANCEL DELETE
            END IF
            DELETE FROM ckb_file WHERE ckb01 = g_ckb_t.ckb01
                                      AND ckb02 = g_ckb_t.ckb02
                                      AND ckb03 = g_ckb_t.ckb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ckb_file",g_ckb_t.ckb01,'',SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ckb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.default1 = g_ckb[l_ac].ckb01
                  CALL cl_create_qry() RETURNING g_ckb[l_ac].ckb01
                  DISPLAY BY NAME g_ckb[l_ac].ckb01
                  NEXT FIELD ckb01  
               WHEN INFIELD(ckb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.arg1 = g_ckb[l_ac].ckb01
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 ,"'"
                  CALL cl_create_qry() RETURNING g_ckb[l_ac].ckb03
                  DISPLAY BY NAME g_ckb[l_ac].ckb03      
                  NEXT FIELD ckb03
               OTHERWISE
                  EXIT CASE
            END CASE
            
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ckb[l_ac].* = g_ckb_t.*
            CLOSE axci004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
       
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ckb[l_ac].ckb01,-263,1)
            LET g_ckb[l_ac].* = g_ckb_t.*
         ELSE
            UPDATE ckb_file SET ckb04 = g_ckb[l_ac].ckb04
             WHERE ckb01 = g_ckb_t.ckb01
              AND  ckb02 = g_ckb_t.ckb02
              AND  ckb03 = g_ckb_t.ckb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ckb_file",'','',SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_ckb[l_ac].* = g_ckb_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE OK'
               COMMIT WORK
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE axci004_bcl
            CANCEL INSERT
         END IF
 
         INSERT INTO ckb_file(ckb01,ckb02,ckb03,ckb04)
         VALUES (g_ckb[l_ac].ckb01,g_ckb[l_ac].ckb02,
                 g_ckb[l_ac].ckb03,g_ckb[l_ac].ckb04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ckb_file",'','',SQLCA.sqlcode,"","",0)   
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #FUN-C80092--add--str--
            IF p_cmd='a' THEN
               CALL g_ckb.deleteElement(l_ac) 
              #FUN-D40030---add---str---
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
              #FUN-D40030---add---end---
            END IF
            #FUN-C80092--add--end--
            IF p_cmd='u' THEN
               LET g_ckb[l_ac].* = g_ckb_t.*
            END IF
            CLOSE axci004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE axci004_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO
         IF INFIELD(ckb01) AND l_ac > 1 THEN
            LET g_ckb[l_ac].* = g_ckb[l_ac-1].*
            NEXT FIELD ckb01
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
  
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
 
   CLOSE axci004_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION axci004_b_askkey()
   CLEAR FORM
   CALL g_ckb.clear()
   
   CONSTRUCT g_wc2 ON ckb01,ckb02,ckb03,ckb04
        FROM s_ckb[1].ckb01,s_ckb[1].ckb02,s_ckb[1].ckb03,
             s_ckb[1].ckb04

     ON ACTION CONTROLP
       CASE
        WHEN INFIELD(ckb01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aaa"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ckb01
        WHEN INFIELD(ckb03)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_aag"
            LET g_qryparam.state = "c"
            LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 ,"'"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ckb03
        OTHERWISE
            EXIT CASE
        END CASE
        
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL axci004_b_fill(g_wc2)
END FUNCTION
 
FUNCTION axci004_b_fill(lc_wc2)
   DEFINE   lc_wc2   LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(1000)
 
   LET g_sql = "SELECT ckb01,ckb02,ckb03,aag02,ckb04",       #FUN-C80092 add aag02
               "  FROM ckb_file LEFT OUTER JOIN aag_file ",  #FUN-C80092 add aag_file
               "    ON aag00 = ckb01 AND aag01 = ckb03 ",    #FUN-C80092 add
               " WHERE ",lc_wc2 CLIPPED,
               " ORDER BY ckb01"
   PREPARE axci004_pb FROM g_sql
   DECLARE ckb_curs CURSOR FOR axci004_pb
 
   CALL g_ckb.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   MESSAGE "Searching!"
   FOREACH ckb_curs INTO g_ckb[g_cnt].*
      LET g_rec_b = g_rec_b + 1
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ckb.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION axci004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_ckb TO s_ckb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query                  # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help                   # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice = "output"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_auth_as_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ckb01,ckb02,ckb03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_auth_as_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ckb01,ckb02,ckb03",FALSE)
   END IF
END FUNCTION 
#No.MOD-580056 --end
 
 
