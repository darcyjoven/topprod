# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi6001.4gl
# Date & Author..: NO.MOD-B30171  11/03/14
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_geu        RECORD LIKE geu_file.*
DEFINE l_gev     DYNAMIC ARRAY OF RECORD
                    gev01     LIKE gev_file.gev01,
                    gev02     LIKE gev_file.gev02
                    END RECORD
   DEFINE l_gev_t   RECORD
                    gev01     LIKE gev_file.gev01,
                    gev02     LIKE gev_file.gev02
                    END RECORD
   DEFINE l_rec_b   LIKE type_file.num5,
          l_cnt     LIKE type_file.num5,
          i         LIKE type_file.num5,
          i_t       LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_lock_sw LIKE type_file.chr1,
          p_cmd     LIKE type_file.chr1
DEFINE 
    g_rec_b             LIKE type_file.num5,         
    l_ac                LIKE type_file.num5          
DEFINE   g_forupd_sql   STRING
DEFINE   g_sql          STRING
DEFINE   g_before_input_done  LIKE type_file.num5    
DEFINE   g_cnt          LIKE type_file.num10         
DEFINE   g_i            LIKE type_file.num5          
DEFINE   g_msg          LIKE type_file.chr1000       
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_geu01        LIKE geu_file.geu01         
DEFINE   g_inc02        LIKE inc_file.inc02          
FUNCTION i6001(p_argv1)
DEFINE   p_argv1        LIKE inc_file.inc01          
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW i600_1_w AT 6,26 WITH FORM "aoo/42f/aooi600_1"  #MOD-B30171
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aooi600_1")
   LET g_geu01 = p_argv1 
   LET g_inc02 = ' ' 
   SELECT * INTO g_geu.* FROM geu_file WHERE geu01 = p_argv1
 
   CALL i6001_b_fill()
   CALL i6001_menu()
   CLOSE WINDOW i600_1_w
END FUNCTION
FUNCTION i6001_menu()
   WHILE TRUE
     CALL i6001_bp("G")
     CASE g_action_choice
        WHEN "help"                                                                                                                
            CALL cl_show_help()                                                                                                     
        WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i6001_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF
        WHEN "exit"                                                                                                                
            EXIT WHILE                                                                                                              
        WHEN "controlg"                                                                                                            
            CALL cl_cmdask()
     END CASE
   END WHILE
END FUNCTION

FUNCTION i6001_b()
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_geu01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT gev01,gev02 ",
                      "  FROM gev_file WHERE gev01=? AND gev02 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i600_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY l_gev WITHOUT DEFAULTS FROM s_gev.*
         ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
       BEFORE INPUT
          IF l_rec_b != 0 THEN
             CALL fgl_set_arr_curr(i)
          END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
           LET l_lock_sw = 'N'            # DEFAULT
           LET l_n  = ARR_COUNT()         # 陣列總數有幾筆
           IF l_rec_b >= i THEN
               BEGIN WORK
               LET p_cmd='u'
               LET l_gev_t.* = l_gev[i].*  #BACKUP
               OPEN i600_1_bcl USING l_gev_t.gev01,l_gev_t.gev02
               IF STATUS THEN
                  CALL cl_err("OPEN i600_1_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i600_1_bcl INTO l_gev[i].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(l_gev_t.gev01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_gev[i].* TO NULL
            LET l_gev_t.* = l_gev[i].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD gev01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i600_1_bcl
              CANCEL INSERT
           END IF
           INSERT INTO gev_file(gev01,gev02,gev03,gev04)
           VALUES(l_gev[i].gev01,l_gev[i].gev02,'Y',g_geu01)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gev_file",l_gev[i].gev01,l_gev[i].gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET l_rec_b = l_rec_b + 1
           END IF
 
       #AFTER FIELD gev01
       #    IF NOT cl_null(l_gev[i].gev01) THEN
       #       IF l_gev[i].gev01 != l_gev_t.gev01 OR l_gev_t.gev01 IS NULL THEN
       #          SELECT COUNT(*) INTO g_cnt FROM gev_file
       #           WHERE gev01 = l_gev[i].gev01
       #             AND gev03 = 'Y'
       #          IF g_cnt > 0 THEN
       #             CALL cl_err('',-239,0)
       #             LET l_gev[i].gev01 = l_gev_t.gev01
       #             NEXT FIELD gev01
       #          END IF
       #       END IF
       #    END IF
 
        BEFORE FIELD gev02
            IF cl_null(l_gev[i].gev01) THEN NEXT FIELD gev01 END IF
 
        AFTER FIELD gev02
            IF NOT cl_null(l_gev[i].gev02) THEN
               SELECT azp02 FROM azp_file WHERE azp01=l_gev[i].gev02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_gev[i].gev02,SQLCA.sqlcode,0)
                  NEXT FIELD gev02
               END IF
               IF l_gev[i].gev02 != l_gev_t.gev02 OR l_gev_t.gev02 IS NULL OR
                  l_gev[i].gev01 != l_gev_t.gev01 OR l_gev_t.gev01 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM gev_file
                   WHERE gev01 = l_gev[i].gev01
                     AND gev02 = l_gev[i].gev02
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_gev[i].gev02 = l_gev_t.gev02
                     NEXT FIELD gev02
                  END IF
                  DISPLAY 'SELECT COUNT OK'
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF l_rec_b>=i THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "geu01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_geu01                #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gev_file WHERE gev01 = l_gev_t.gev01
                                      AND gev02 = l_gev_t.gev02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gev_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK
                  EXIT INPUT

               ELSE
                  DELETE FROM gey_file
                   WHERE gey01 = l_gev_t.gev01
                     AND gey02 = l_gev_t.gev02

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gey_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)   
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF

                  DELETE FROM gew_file
                   WHERE gew02 = l_gev_t.gev01
                     AND gew04 = l_gev_t.gev02
                     AND gew01 = g_geu01

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gew_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF

                  DELETE FROM gez_file
                   WHERE gez02 = l_gev_t.gev01
                     AND gez03 = l_gev_t.gev02
                     AND gez01 = g_geu01

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gez_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF
                  LET l_rec_b = l_rec_b - 1
                  COMMIT WORK
               END IF
             END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_gev[i].* = l_gev_t.*
              CLOSE i600_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(l_gev[i].gev01,-263,0)
              LET l_gev[i].* = l_gev_t.*
           ELSE
              UPDATE gev_file SET gev01=l_gev[i].gev01,gev02=l_gev[i].gev02
               WHERE gev01 = l_gev_t.gev01
                 AND gev02 = l_gev_t.gev02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gev_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET l_gev[i].* = l_gev_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
           LET i = ARR_CURR()
           #LET i_t = i  #FUN-D40030
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET l_gev[i].* = l_gev_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL l_gev.deleteElement(i)
                 IF l_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET i = i_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i600_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET i_t = i  #FUN-D40030
           CLOSE i600_1_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gev02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.default1 = l_gev[i].gev02
                #LET g_qryparam.arg1     = l_gev[i].gev01
                 CALL cl_create_qry() RETURNING l_gev[i].gev02
                 NEXT FIELD gev02
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gev01) AND i > 1 THEN
              LET l_gev[i].* = l_gev[i-1].*
              NEXT FIELD gev01
           END IF
 
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
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
 
    CLOSE i600_1_bcl
    
    COMMIT WORK
END FUNCTION
FUNCTION i6001_b_fill()              #BODY FILL UP
 
  LET g_sql = "SELECT gev01,gev02 ",
               "  FROM gev_file ",
               " WHERE gev04 = '",g_geu01,"'",
               "   AND gev03 = 'Y'",
               " ORDER BY gev01,gev02 "
 
   PREPARE s_aooi600_1_pre1 FROM g_sql
 
   DECLARE s_aooi600_1_c1 CURSOR FOR s_aooi600_1_pre1
 
   CALL l_gev.clear()
   LET l_cnt = 1
 
   FOREACH s_aooi600_1_c1 INTO l_gev[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach gev',STATUS,0)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
 
   CALL l_gev.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET i = 1
 
END FUNCTION
 
FUNCTION i6001_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY l_gev TO s_gev.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()
 
        ON ACTION detail
           LET g_action_choice="detail"    
           LET l_ac = 1
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"      
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
           EXIT DISPLAY
 
        #ON ACTION output
        #   LET g_action_choice="output"
        #   EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit" 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

#FUN-B80035
