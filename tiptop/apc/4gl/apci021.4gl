# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apci021.4gl
# Descriptions...: POS分佈上傳設定作業
# Date & Author..: No.FUN-C80045 12/08/15 By xumeimei
# Modify.........: No.FUN-C90039 12/09/10 By baogc 報錯信息修改
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ryg03          LIKE ryg_file.ryg03,
         g_ryg03_t        LIKE ryg_file.ryg03,
         g_ryg    DYNAMIC ARRAY of RECORD
            ryg01          LIKE ryg_file.ryg01,
            azp02          LIKE azp_file.azp02
                      END RECORD,
         g_ryg_t           RECORD 
            ryg01          LIKE ryg_file.ryg01,
            azp02          LIKE azp_file.azp02
                      END RECORD, 
         g_wc                  STRING, 
         g_sql                 STRING, 
         g_rec_b               LIKE type_file.num5, 
         l_ac                  LIKE type_file.num5  
DEFINE   g_cnt                 LIKE type_file.num10  
DEFINE   g_msg                 LIKE type_file.chr1000 
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_curs_index          LIKE type_file.num10 
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5    
DEFINE   g_ryz10               LIKE ryz_file.ryz10

 
MAIN
 
   OPTIONS                 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF

   SELECT ryz10 INTO g_ryz10 FROM ryz_file
   IF g_ryz10 = 'N' THEN
      CALL cl_err('','apc1031',1)
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW i021_w WITH FORM "apc/42f/apci021"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL i021_menu() 

   CLOSE WINDOW i021_w 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION i021_curs()                         # QBE 查詢資料
   CLEAR FORM                                # 清除畫面
   CALL g_ryg.clear()
 
   CALL cl_set_head_visible("","YES") 
   INITIALIZE g_ryg03 TO NULL 
   
   CONSTRUCT g_wc ON ryg03,ryg01
                FROM ryg03,s_ryg[1].ryg01


      BEFORE CONSTRUCT                                                         
         CALL cl_qbe_init() 
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryg03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ryg03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ryg03
               NEXT FIELD ryg03
 
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
 
   IF INT_FLAG THEN 
      RETURN 
   END IF

   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF
    
   LET g_sql=" SELECT UNIQUE ryg03 FROM ryg_file ",
             "  WHERE ", g_wc CLIPPED,
             "    AND ryg03 IS NOT NULL ",
             "  ORDER BY ryg03" 

   PREPARE i021_prepare FROM g_sql  
   DECLARE i021_b_curs 
      SCROLL CURSOR WITH HOLD FOR i021_prepare

   LET g_sql = "SELECT COUNT(UNIQUE ryg03) FROM ryg_file WHERE ",g_wc CLIPPED," AND ryg03 IS NOT NULL"  
   PREPARE i021_precount FROM g_sql    
   DECLARE i021_count CURSOR FOR i021_precount
 
   CALL i021_show()
  
END FUNCTION
 
FUNCTION i021_menu()
 
   WHILE TRUE
      CALL i021_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i021_a()
            END IF
         WHEN "delete"                          # R.刪除
            IF cl_chk_act_auth() THEN
               CALL i021_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i021_q()
            END IF
         WHEN "modify"                          # M.更改
            IF cl_chk_act_auth() THEN
               CALL i021_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i021_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_ryg03 IS NOT NULL THEN
                  LET g_doc.column1 = "ryg03"
                  LET g_doc.value1 = g_ryg03
                  CALL cl_doc()
               END IF 
            END IF  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i021_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_ryg.clear()
 
   IF s_shut(0) THEN RETURN END IF 
   LET g_ryg03 = NULL                                                           
   LET g_ryg03_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i021_i("a")  
 
      IF INT_FLAG THEN 
         LET g_ryg03=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_ryg03) THEN                                                 
         CONTINUE WHILE                                                        
      END IF                
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err(g_ryg03,SQLCA.sqlcode,1)
         ROLLBACK WORK                   
      ELSE                                                                     
         COMMIT WORK                                                           
      END IF
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
      
      CALL i021_b() 
      LET g_ryg03_t=g_ryg03
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i021_chk_ryg03()
   DEFINE   l_n          LIKE type_file.num10
   DEFINE   l_rtz28      LIKE rtz_file.rtz28

   LET g_errno ='' 
   SELECT COUNT(*) INTO l_n
     FROM rtz_file
    WHERE rtz01 = g_ryg03
   IF l_n = 0 THEN LET g_errno = 'aap-025' END IF
   SELECT rtz28 INTO l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_ryg03 
   IF l_rtz28 = 'N' THEN LET g_errno = 'apc-197' END IF
END FUNCTION
 
FUNCTION i021_i(p_cmd) 
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改

   DISPLAY g_ryg03 TO ryg03 
   CALL cl_set_head_visible("","YES") 
   INPUT g_ryg03 WITHOUT DEFAULTS FROM ryg03
 
      AFTER FIELD ryg03
         IF NOT cl_null(g_ryg03) THEN
            IF g_ryg03 != g_ryg03_t OR cl_null(g_ryg03_t) THEN
               CALL i021_chk_ryg03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryg03,g_errno,0)
                  LET g_ryg03 = g_ryg03_t
                  NEXT FIELD ryg03
               END IF
               SELECT COUNT(*) INTO g_cnt FROM ryg_file
                WHERE ryg03 = g_ryg03 
               IF p_cmd = 'a' AND g_cnt > 0 THEN
                  CALL i021_show()
                  EXIT INPUT
               END IF
               IF p_cmd = 'u' THEN
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_ryg03,'-239',0)
                     LET g_ryg03 = g_ryg03_t
                     NEXT FIELD ryg03
                  ELSE
                     LET g_success = 'Y'
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryg03,g_errno,0)
                  NEXT FIELD ryg03
               END IF
            END IF
         END IF

      AFTER INPUT          
          IF INT_FLAG THEN
             EXIT INPUT
          END IF                                                    
          IF g_ryg03 IS NULL THEN               
             NEXT FIELD ryg03                  
          END IF 
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryg03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ryg03i"
               LET g_qryparam.default1= g_ryg03
               CALL cl_create_qry() RETURNING g_ryg03
               DISPLAY g_ryg03 TO ryg03
               NEXT FIELD ryg03
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION controlf              
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION

FUNCTION i021_u()
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_ryg03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ryg03_t = g_ryg03

   BEGIN WORK
   OPEN i021_b_curs 
   IF STATUS THEN
      CALL cl_err("OPEN i021_b_curs:", STATUS, 1)
      CLOSE i021_b_curs 
      ROLLBACK WORK
      RETURN
   END IF
   CALL i021_show()
   WHILE TRUE
      LET g_ryg03_t=g_ryg03
      CALL i021_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ryg03=g_ryg03_t
         CALL i021_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_success = 'Y' THEN
         UPDATE ryg_file SET ryg03 = g_ryg03
          WHERE ryg03 = g_ryg03_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ryg_file",g_ryg03_t,'',SQLCA.sqlcode,"","ryg",1)
            CONTINUE WHILE
         ELSE
            COMMIT WORK
         END IF
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i021_b_curs 
   CALL i021_b_fill(" 1=1")
END FUNCTION
 
FUNCTION i021_q()
   LET g_ryg03 = ''                                                     
   INITIALIZE g_ryg03 TO NULL                            
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM 
   CALL g_ryg.clear()
   DISPLAY '' TO FORMONLY.cnt
   
   CALL i021_curs()   
   
   IF INT_FLAG THEN  
      LET INT_FLAG = 0
      INITIALIZE g_ryg03 TO NULL
      RETURN
   END IF

   OPEN i021_b_curs  
   IF SQLCA.SQLCODE THEN   
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ryg03 TO NULL
   ELSE
      OPEN i021_count
      FETCH i021_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i021_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i021_fetch(p_flag) 
   DEFINE   p_flag   LIKE type_file.chr1
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i021_b_curs INTO g_ryg03
      WHEN 'P' FETCH PREVIOUS i021_b_curs INTO g_ryg03
      WHEN 'F' FETCH FIRST    i021_b_curs INTO g_ryg03
      WHEN 'L' FETCH LAST     i021_b_curs INTO g_ryg03
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i021_b_curs INTO g_ryg03
         LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ryg03,SQLCA.sqlcode,0)
      INITIALIZE g_ryg03 TO NULL
   ELSE
      CALL i021_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
END FUNCTION

 
FUNCTION i021_show() 
   DISPLAY g_ryg03 TO ryg03
   CALL i021_b_fill(g_wc) 
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i021_chk_ryg01()
   DEFINE l_ryg03      LIKE ryg_file.ryg03
   DEFINE l_rygacti    LIKE ryg_file.rygacti
   
   LET g_errno =''                                                      
   SELECT ryg03,rygacti INTO l_ryg03,l_rygacti FROM ryg_file
    WHERE ryg01=g_ryg[l_ac].ryg01 
                                                         
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apc-206' #FUN-C90039 MOD
        WHEN l_rygacti = 'N'      LET g_errno = 'apc-206' #FUN-C90039 MOD
        WHEN NOT cl_null(l_ryg03) LET g_errno = 'apc1032'
        OTHERWISE                 LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE              
END FUNCTION

FUNCTION i021_r()   
   DEFINE   l_cnt   LIKE type_file.num5,  
            l_ryg   RECORD LIKE ryg_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ryg03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   LET l_cnt = 0
   
   BEGIN WORK
   IF cl_delh(0,0) THEN 
      UPDATE ryg_file SET ryg03 = ''
       WHERE ryg03 = g_ryg03  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ryg_file",g_ryg03,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
         CLEAR FORM
         CALL g_ryg.clear()
         LET g_sql = "SELECT COUNT(UNIQUE ryg03) FROM ryg_file ",
                     " WHERE ryg03 IS NOT NULL"
         PREPARE i021_precount1 FROM g_sql
         DECLARE i021_count1 CURSOR FOR i021_precount1
         OPEN i021_count1
         FETCH i021_count1 INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i021_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i021_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i021_fetch('/')
         END IF
      END IF
   END IF
   
END FUNCTION
 
FUNCTION i021_b()                           
   DEFINE   l_ac_t          LIKE type_file.num5,
            l_n             LIKE type_file.num5,
            l_cnt           LIKE type_file.num5,   
            l_lock_sw       LIKE type_file.chr1, 
            p_cmd           LIKE type_file.chr1, 
            l_allow_insert  LIKE type_file.num5, 
            l_allow_delete  LIKE type_file.num5  
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ryg03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql= "SELECT ryg01,'' ",
                     "  FROM ryg_file ",
                     "  WHERE ryg03 = ? AND ryg01 = ?",  
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i021_bcl CURSOR FROM g_forupd_sql 
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_ryg WITHOUT DEFAULTS FROM s_ryg.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'  
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ryg03_t = g_ryg03
            LET g_ryg_t.* = g_ryg[l_ac].*  
            OPEN i021_bcl USING g_ryg03,g_ryg[l_ac].ryg01
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i021_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i021_bcl INTO g_ryg[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i021_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i021_azp02()
            END IF
            CALL cl_show_fld_cont()   
         END IF
         
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE
         INITIALIZE g_ryg[l_ac].* TO NULL 
         LET g_before_input_done = TRUE
         LET g_ryg_t.* = g_ryg[l_ac].*   
         CALL cl_show_fld_cont()
         NEXT FIELD ryg01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         UPDATE ryg_file SET ryg03 = g_ryg03
          WHERE ryg01 = g_ryg[l_ac].ryg01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryg_file",g_ryg03,g_ryg[l_ac].ryg01,SQLCA.sqlcode,"","",0) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD ryg01  
          IF NOT cl_null(g_ryg[l_ac].ryg01) THEN 
             IF g_ryg[l_ac].ryg01 != g_ryg_t.ryg01 OR
                g_ryg_t.ryg01 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM ryg_file 
                 WHERE ryg01=g_ryg[l_ac].ryg01 AND ryg03 = g_ryg03 
                IF l_n> 0 THEN
                   CALL cl_err(g_ryg[l_ac].ryg01,'-239',1)
                   LET g_ryg[l_ac].ryg01=g_ryg_t.ryg01
                   NEXT FIELD ryg01
                END IF
                CALL i021_chk_ryg01() 
                IF NOT cl_null(g_errno) THEN                 
                   CALL cl_err(g_ryg[l_ac].ryg01,g_errno,1)  
                   LET g_ryg[l_ac].ryg01=g_ryg_t.ryg01
                   NEXT FIELD ryg01
                END IF  
                CALL i021_azp02()
              END IF
           END IF  
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ryg_t.ryg01) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", '-263', 1) 
               CANCEL DELETE 
            END IF
            UPDATE ryg_file SET ryg03 = ''
             WHERE ryg01 = g_ryg_t.ryg01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ryg_file",g_ryg03,SQLCA.sqlcode,"","","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ryg[l_ac].* = g_ryg_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_ryg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30033 add
         CLOSE i021_bcl
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryg[l_ac].* = g_ryg_t.*
            CLOSE i021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryg[l_ac].ryg01,-263,1)
            LET g_ryg[l_ac].* = g_ryg_t.*
         ELSE
            UPDATE ryg_file SET ryg03 = NULL
             WHERE ryg01 = g_ryg_t.ryg01
            UPDATE ryg_file SET ryg03 = g_ryg03
             WHERE ryg01 = g_ryg[l_ac].ryg01
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","ryg_file",g_ryg03,SQLCA.sqlcode,"","","",1)
              ROLLBACK WORK  
              LET g_ryg[l_ac].* = g_ryg_t.*
            ELSE  
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
            END IF
         END IF


      ON ACTION CONTROLO                      
         IF INFIELD(ryg01) AND l_ac > 1 THEN
            LET g_ryg[l_ac].* = g_ryg[l_ac-1].*
            LET g_ryg[l_ac].ryg01=null
            NEXT FIELD ryg01
         END IF
         
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ryg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryg01i"
               LET g_qryparam.default1 = g_ryg[l_ac].ryg01
               CALL cl_create_qry() RETURNING g_ryg[l_ac].ryg01
               DISPLAY BY NAME g_ryg[l_ac].ryg01
               CALL i021_azp02()
               NEXT FIELD ryg01
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   
   END INPUT
 
   CLOSE i021_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i021_azp02()
   SELECT azp02 INTO g_ryg[l_ac].azp02
     FROM azp_file
    WHERE azp01=g_ryg[l_ac].ryg01

END FUNCTION
 
FUNCTION i021_b_fill(p_wc)   
 
    DEFINE p_wc         STRING 

    IF cl_null(p_wc) THEN
       LET p_wc = " 1=1"
    END IF 
    LET g_sql = "SELECT ryg01,'' ",
                "  FROM ryg_file ",
                " WHERE ryg03 = '",g_ryg03 CLIPPED,"' ",
                "   AND ",p_wc CLIPPED,
                " ORDER BY ryg03"
 
    PREPARE i021_prepare2 FROM g_sql  
    DECLARE ryg_curs CURSOR FOR i021_prepare2
 
    CALL g_ryg.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ryg_curs INTO g_ryg[g_cnt].*  
       SELECT azp02 INTO g_ryg[g_cnt].azp02 
        FROM azp_file
       WHERE azp01=g_ryg[g_cnt].ryg01
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ryg.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    LET g_ryg_t.ryg01 = g_ryg[1].ryg01
END FUNCTION
 
FUNCTION i021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_ryg TO s_ryg.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # M.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION delete                           # D.删除
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first            
         CALL i021_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY              
 
      ON ACTION previous                 
         CALL i021_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION jump            
         CALL i021_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next                          
         CALL i021_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION last                            
         CALL i021_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
       ON ACTION help                           
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
         EXIT DISPLAY
 
      ON ACTION exit      
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      AFTER DISPLAY
         CONTINUE DISPLAY

                                                                                           
      ON ACTION controls                                                                                                              
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-C80045
