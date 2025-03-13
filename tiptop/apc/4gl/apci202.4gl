# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apci202.4gl
# Descriptions...: POS功能基本資料維護
# Date & Author..: No:FUN-C40084 12/04/28 By fanbj
# Modify.........: No.FUN-C60024 12/06/08 By fanbj POS基礎資料調整
# Modify.........: No.MOD-CA0052 12/10/08 By jt_chen 於AFTER ROW中FUN-C60024的修改增加IF p_cmd='u' THEN的判斷
# Modify.........: No.FUN-CB0007 12/11/19 By shiwuying bug修改
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryq                  DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          ryq01                  LIKE ryq_file.ryq01,
          ryq01_desc             LIKE ryx_file.ryx05,
          ryq02                  LIKE ryq_file.ryq02,
          ryq02_desc             LIKE ryx_file.ryx05,
          ryq03                  LIKE ryq_file.ryq03,
          #FUN-C60024--start add---------------------
          ryq04                  LIKE ryq_file.ryq04,
          ryq05                  LIKE ryq_file.ryq05,
          ryq06                  LIKE ryq_file.ryq06,
          #FUN-C60024--end add-----------------------
          ryqacti                LIKE ryq_file.ryqacti,
          ryqpos                 LIKE ryq_file.ryqpos 
                              END RECORD,
       g_ryq_t                RECORD                 #程式變數 (舊值)
          ryq01                  LIKE ryq_file.ryq01,
          ryq01_desc             LIKE ryx_file.ryx05,
          ryq02                  LIKE ryq_file.ryq02,
          ryq02_desc             LIKE ryx_file.ryx05,
          ryq03                  LIKE ryq_file.ryq03,
          #FUN-C60024--start add---------------------
          ryq04                  LIKE ryq_file.ryq04,
          ryq05                  LIKE ryq_file.ryq05,
          ryq06                  LIKE ryq_file.ryq06,
          #FUN-C60024--end add-----------------------
          ryqacti                LIKE ryq_file.ryqacti,
          ryqpos                 LIKE ryq_file.ryqpos 
                              END RECORD
DEFINE g_wc2,g_sql            string    
DEFINE g_rec_b                LIKE type_file.num5                
DEFINE l_ac                   LIKE type_file.num5 
DEFINE g_forupd_sql           STRING                  #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt                  LIKE type_file.num10 
DEFINE g_i                    LIKE type_file.num5     #count/index for any purpose    
DEFINE g_before_input_done    LIKE type_file.num5
DEFINE g_flag                 LIKE type_file.chr1
DEFINE g_ryq01                LIKE ryq_file.ryq01
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("apc")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 
           
   OPEN WINDOW i202_w  WITH FORM "apc/42f/apci202"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('ryqpos',FALSE)
   END IF   
    
   LET g_wc2 = ' 1=1' 
   CALL i202_b_fill(g_wc2)
   CALL i202_menu()
   CLOSE WINDOW i202_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)  RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
FUNCTION i202_menu()
   WHILE TRUE
      CALL i202_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i202_q()
            END IF

         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i202_b() 
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "preserve_name" 
            IF cl_chk_act_auth() THEN
               LET g_flag = '1' 
               IF cl_null(g_ryq[l_ac].ryq01) THEN
                  CALL cl_err('','apc-183',0) 
               ELSE
                  CALL i201_get_key_name('2',g_ryq[l_ac].ryq01,g_flag)
                       RETURNING g_ryq[l_ac].ryq01_desc
               END IF 
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i202_q()
   CALL i202_b_askkey()
END FUNCTION

FUNCTION i202_upd(p_ryqpos)
   DEFINE p_ryqpos         LIKE ryq_file.ryqpos

   UPDATE ryq_file
      SET ryqpos = p_ryqpos
    WHERE ryq01 = g_ryq_t.ryq01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ryq_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
   END IF
   LET g_ryq[l_ac].ryqpos = p_ryqpos
   DISPLAY BY NAME g_ryq[l_ac].ryqpos
  
END FUNCTION
 
FUNCTION i202_b()
   DEFINE l_ac_t          LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5                #檢查重複用 
   DEFINE l_lock_sw       LIKE type_file.chr1                #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1                #處理狀態        
   DEFINE l_allow_insert  LIKE type_file.num5                #可新增否        
   DEFINE l_allow_delete  LIKE type_file.num5                #可刪除否 
   DEFINE l_n1            LIKE type_file.num5  
   DEFINE l_ryqpos        LIKE ryq_file.ryqpos
   DEFINE l_flag          LIKE type_file.chr1                #FUN-C60024 add
 
   LET g_action_choice = ""
   LET g_flag = '2'
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT ryq01,'',ryq02,'',ryq03,ryqacti,ryqpos",                  #FUN-C60024 mark
   LET g_forupd_sql = "SELECT ryq01,'',ryq02,'',ryq03,ryq04,ryq05,ryq06,ryqacti,ryqpos", #FUN-C60024 add
                      "  FROM ryq_file  ",                
                      " WHERE ryq01= ?  FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ryq WITHOUT DEFAULTS FROM s_ryq.*              
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert) 
         
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
             
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryq02)                                                                                   
               CALL cl_init_qry_var()                                                                                
               LET g_qryparam.form ="q_ryp_2"                                                                        
               LET g_qryparam.arg1 = g_lang 
               LET g_qryparam.default1 = g_ryq[l_ac].ryq02                                                        
               CALL cl_create_qry() RETURNING g_ryq[l_ac].ryq02                                                
               DISPLAY g_ryq[l_ac].ryq02 TO ryq02                                                               
               NEXT FIELD ryq02   
                               
            OTHERWISE EXIT CASE
         END CASE 
                      
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_flag = 'N'                  #FUN-C60024 add
         LET g_ryq01 = NULL 
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ryq_t.* = g_ryq[l_ac].*  #BACKUP
                                                                                                    
            LET g_before_input_done = FALSE                                                                                      
            CALL i202_set_entry_b(p_cmd)                                                                                         
            CALL i202_set_no_entry_b(p_cmd)  
            LET g_before_input_done = TRUE                                                                                       

            IF g_aza.aza88 = 'Y' THEN
               BEGIN WORK

               OPEN i202_bcl USING g_ryq_t.ryq01
               IF STATUS THEN
                  CALL cl_err(g_ryq[l_ac].ryq01,status,1)
                  CLOSE i202_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH i202_bcl INTO g_ryq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ryq[l_ac].ryq01,SQLCA.sqlcode,1)
                     CLOSE i202_bcl
                     ROLLBACK WORK
                     RETURN
                  ELSE
                     #FUN-C60024--start add-------------------------
                     SELECT ryqpos INTO l_ryqpos
                       FROM ryq_file
                      WHERE ryq01 = g_ryq[l_ac].ryq01
                     #FUN-C60024--end add---------------------------

                     UPDATE ryq_file
                        SET ryqpos = '4'
                      WHERE ryq01 = g_ryq[l_ac].ryq01
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","ryq_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
                        LET l_lock_sw = "Y"
                     END IF
                     #LET l_ryqpos = g_ryq[l_ac].ryqpos                 #FUN-C60024 mark
                     LET g_ryq[l_ac].ryqpos = '4'
                     DISPLAY BY NAME g_ryq[l_ac].ryqpos
                  END IF
               END IF
               CLOSE i202_bcl
               COMMIT WORK
            END IF
  
            BEGIN WORK
 
            OPEN i202_bcl USING g_ryq_t.ryq01
            IF STATUS THEN
               CALL cl_err("OPEN i202_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i202_bcl INTO g_ryq[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ryq_t.ryq01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i202_ryq01('d')
               CALL i202_ryq02('d')                
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO ryq_file(ryq01,ryq02,ryq03,ryqpos,ryqacti,ryqcrat,ryqdate,
                              ryq04,ryq05,ryq06,                                #FUN-C60024 add
                              ryqgrup,ryquser,ryqoriu,ryqorig)
         VALUES(g_ryq[l_ac].ryq01,g_ryq[l_ac].ryq02,g_ryq[l_ac].ryq03,
                g_ryq[l_ac].ryqpos,g_ryq[l_ac].ryqacti,g_today,g_today,
                g_ryq[l_ac].ryq04,g_ryq[l_ac].ryq05,g_ryq[l_ac].ryq06,          #FUN-C60024 add 
                g_grup,g_user,g_user,g_grup)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ryq_file",g_ryq[l_ac].ryq01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         BEGIN WORK                                                                                                        

         LET g_before_input_done = FALSE                                                                                      
         CALL i202_set_entry_b(p_cmd)                                                                                         
         CALL i202_set_no_entry_b(p_cmd)                                                                                      
         LET g_before_input_done = TRUE                                                                                       


         INITIALIZE g_ryq[l_ac].* TO NULL      
         LET g_ryq_t.* = g_ryq[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         LET g_ryq[l_ac].ryqacti = 'Y' 
         LET g_ryq[l_ac].ryq03 = 'N'
         LET g_ryq[l_ac].ryq04 = '0'           #FUN-C60024 add
         LET g_ryq01 = NULL                    #FUN-C60024 add
         IF g_aza.aza88 = 'Y' THEN                                            
            LET g_ryq[l_ac].ryqpos = '1'                                      
            LET l_ryqpos = '1' 
         END IF     
         DISPLAY BY NAME g_ryq[l_ac].ryqpos
         CALL cl_set_comp_entry("ryqpos",FALSE)
         NEXT FIELD ryq01

      AFTER FIELD ryq01                        #check 編號是否重複
         IF NOT cl_null(g_ryq[l_ac].ryq01) THEN 
            IF p_cmd = 'a' OR 
              (p_cmd = 'u' AND g_ryq_t.ryq01 <> g_ryq[l_ac].ryq01) THEN 
               IF p_cmd = 'u' AND g_ryq_t.ryq01 <> g_ryq[l_ac].ryq01 THEN 
                  CALL i202_ryq_chk('3')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_ryq[l_ac].ryq01 = g_ryq_t.ryq01
                     DISPLAY BY NAME g_ryq[l_ac].ryq01 
                     NEXT FIELD ryq01
                  END IF 
               END IF 
               
               CALL i202_ryq01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryq[l_ac].ryq01 = g_ryq_t.ryq01
                  DISPLAY BY NAME g_ryq[l_ac].ryq01                  
                  NEXT FIELD ryq01
               END IF 
            END IF   
         END IF

      AFTER FIELD ryq02
         IF NOT cl_null(g_ryq[l_ac].ryq02) THEN 
            IF p_cmd = 'u' AND g_ryq[l_ac].ryq02 <> g_ryq_t.ryq02 THEN
               CALL i202_ryq_chk('4')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryq[l_ac].ryq02 = g_ryq_t.ryq02
                  DISPLAY BY NAME g_ryq[l_ac].ryq02
                  NEXT FIELD ryq02
               END IF   
            END IF 
            CALL i202_ryq02(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ryq[l_ac].ryq02 = g_ryq_t.ryq02
               NEXT FIELD ryq02
            END IF 
         END IF 

      AFTER FIELD ryqpos
         IF NOT cl_null(g_ryq[l_ac].ryqpos) THEN
            IF g_ryq[l_ac].ryqpos NOT MATCHES '[123]' THEN
               NEXT FIELD ryqpos
            END IF
         END IF     
        
      BEFORE DELETE                            #是否取消單身
         IF g_ryq_t.ryq01 IS NOT NULL THEN
            CALL i202_ryq_chk('1')           
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               CANCEL DELETE
            END IF  

            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "ryq01" 
            LET g_doc.value1 = g_ryq[l_ac].ryq01
            CALL cl_del_doc()
      
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
         
            IF g_aza.aza88 = 'Y' THEN
               IF NOT ((l_ryqpos='3' AND g_ryq_t.ryqacti='N')
                         OR (l_ryqpos ='1'))  THEN
                  CALL cl_err('','apc-139',0)
                  CANCEL DELETE 
               END IF 
            END IF 
         
            DELETE FROM ryx_file
             WHERE ryx01 = 'ryq_file'
               AND ryx02 = 'ryq01'
               AND ryx03 = g_ryq_t.ryq01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ryx_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF   
           
            DELETE FROM ryq_file WHERE ryq01 = g_ryq_t.ryq01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ryq_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET l_flag = 'Y'   #FUN-CB0007
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK"
            CLOSE i202_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryq[l_ac].* = g_ryq_t.*
            CLOSE i202_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF                      

         LET l_flag = 'Y'              #FUN-C60024 add

         IF p_cmd = 'u' AND (g_ryq_t.ryq01 <> g_ryq[l_ac].ryq01
                          OR g_ryq_t.ryq02 <> g_ryq[l_ac].ryq02
                          OR g_ryq_t.ryqacti <> g_ryq[l_ac].ryqacti ) THEN
            CALL i202_ryq_chk('3')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ryq[l_ac].* = g_ryq_t.*
               CALL i202_upd(l_ryqpos)   
               NEXT FIELD ryq01
            END IF    
         END IF 
         
         IF g_aza.aza88 = 'Y' THEN
            IF l_ryqpos <> '1' THEN
               LET g_ryq[l_ac].ryqpos = '2'
            ELSE
               LET g_ryq[l_ac].ryqpos = '1'
            END IF
         END IF          
  
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryq[l_ac].ryq01,-263,1)
            LET g_ryq[l_ac].* = g_ryq_t.*
         ELSE
            IF p_cmd = 'u' AND g_ryq_t.ryq01 <> g_ryq[l_ac].ryq01 THEN
               SELECT COUNT(*) INTO l_n
                 FROM ryx_file
                WHERE ryx01 = 'ryq_file'
                  AND ryx02 = 'ryq01'
                  AND ryx03 = g_ryq_t.ryq01
               IF l_n > 0 THEN
                  UPDATE ryx_file
                     SET ryx03 = g_ryq[l_ac].ryq01
                   WHERE ryx01 = 'ryq_file'
                     AND ryx02 = 'ryq01'
                     AND ryx03 = g_ryq_t.ryq01

                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","ryx_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
            END IF

            UPDATE ryq_file 
               SET ryq01=g_ryq[l_ac].ryq01,
                   ryq02=g_ryq[l_ac].ryq02,
                   ryq03=g_ryq[l_ac].ryq03,    
                   ryqacti=g_ryq[l_ac].ryqacti,  
                   ryqpos=g_ryq[l_ac].ryqpos,
                   #FUN-C60024--start add-----------------
                   ryq04=g_ryq[l_ac].ryq04,
                   ryq05=g_ryq[l_ac].ryq05,
                   ryq06=g_ryq[l_ac].ryq06, 
                   #FUN-C60024--end add-------------------
                   ryqmodu = g_user,
                   ryqdate = g_today                                       
             WHERE ryq01 = g_ryq_t.ryq01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ryq_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
                LET g_ryq[l_ac].* = g_ryq_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i202_bcl
                COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i202_bcl
            ROLLBACK WORK
            IF p_cmd='u' THEN
               IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN
                  CALL i202_upd(l_ryqpos)  
               END IF
               LET g_ryq[l_ac].* = g_ryq_t.*
            ELSE
               CALL g_ryq.deleteElement(l_ac)
               #FUN-D30033--add--begin--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               #FUN-D30033--add--end----
            END IF
            EXIT INPUT
         END IF
          
         IF p_cmd = 'u' THEN   #MOD-CA0052 add
            #FUN-C60024--start add-------------------------------
            IF l_flag <> 'Y' AND NOT INT_FLAG THEN
               IF l_ryqpos <> '1' THEN
                  LET g_ryq[l_ac].ryqpos = '2' 
               ELSE
                  LET g_ryq[l_ac].ryqpos = '1'
               END IF 
               CALL i202_upd(g_ryq[l_ac].ryqpos)
            END IF 
            #FUN-C60024--end add---------------------------------
         END IF   #MOD-CA0052 add

         LET l_ac_t = l_ac   #FUN-D30033 add 
         CLOSE i202_bcl
         COMMIT WORK 

      AFTER INPUT
         IF INT_FLAG THEN
            IF g_aza.aza88 = 'Y' THEN
                  UPDATE ryq_file
                     SET ryqpos = l_ryqpos
                   WHERE ryq01 = g_ryq[l_ac].ryq01
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","ryq_file",g_ryq_t.ryq01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_ryq[l_ac].ryqpos = l_ryqpos
                  DISPLAY BY NAME g_ryq[l_ac].ryqpos
               END IF 
            EXIT INPUT
         END IF 
 
      ON ACTION preserve_name1
         IF cl_null(g_ryq[l_ac].ryq01) THEN
            CALL cl_err('','apc-183',0)
         ELSE
            IF i202_ryx_chk() THEN
               CALL i201_get_key_name('2',g_ryq[l_ac].ryq01,g_flag)
                    RETURNING g_ryq[l_ac].ryq01_desc
            END IF 
         END IF 

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ryq01) AND l_ac > 1 THEN
            LET g_ryq[l_ac].* = g_ryq[l_ac-1].*
            NEXT FIELD ryq01
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

   CLOSE i202_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i202_b_askkey()
   CLEAR FORM
   CALL g_ryq.clear()

   #CONSTRUCT g_wc2 ON ryq01,ryq02,ryq03,ryqacti,ryqpos                   #FUN-C60024 mark
   CONSTRUCT g_wc2 ON ryq01,ryq02,ryq03,ryq04,ryq05,ryq06,ryqacti,ryqpos  #FUN-C60024 add  
          FROM s_ryq[1].ryq01,s_ryq[1].ryq02,s_ryq[1].ryq03,
               s_ryq[1].ryq04,s_ryq[1].ryq05,s_ryq[1].ryq06,              #FUN-C60024 add
               s_ryq[1].ryqacti,s_ryq[1].ryqpos

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryq01)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_ryq01"                                                                       
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state='c'                                                                             
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO ryq01                                                               
               NEXT FIELD ryq01  
                      
            WHEN INFIELD(ryq02)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_ryq02"   
               LET g_qryparam.arg1 = g_lang                                                                     
               LET g_qryparam.state='c'                                                                             
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO ryq02                                                               
               NEXT FIELD ryq02
            OTHERWISE EXIT CASE
         END CASE 
                   
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

   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
   END IF
   CALL i202_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i202_b_fill(p_wc2)             
   DEFINE p_wc2           LIKE type_file.chr1000 

   #LET g_sql = "SELECT ryq01,'',ryq02,'',ryq03,ryqacti,ryqpos ",                  #FUN-C60024 mark              
   LET g_sql = "SELECT ryq01,'',ryq02,'',ryq03,ryq04,ryq05,ryq06,ryqacti,ryqpos ", #FUN-C60024 add              
              " FROM ryq_file ",
              " WHERE ", p_wc2 CLIPPED,                     #單身
              " ORDER BY ryq01"
 
   PREPARE i202_pb FROM g_sql
   DECLARE ryq_curs CURSOR FOR i202_pb
 
   CALL g_ryq.clear()
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
   FOREACH ryq_curs INTO g_ryq[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       
      SELECT ryx05 INTO g_ryq[g_cnt].ryq01_desc
        FROM ryx_file
       WHERE ryx03 = g_ryq[g_cnt].ryq01
         AND ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx04 = g_lang  

      SELECT ryx05 INTO g_ryq[g_cnt].ryq02_desc
        FROM ryx_file
       WHERE ryx03 = g_ryq[g_cnt].ryq02
         AND ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx04 = g_lang

      LET g_cnt = g_cnt + 1
     
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF     
   END FOREACH
   CALL g_ryq.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryq TO s_ryq.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION preserve_name
         LET g_action_choice="preserve_name"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CALL i202_b_fill( g_wc2) 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION about     
         CALL cl_about()     
   
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
      CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION i202_ryq01(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_n         LIKE type_file.num10

   LET g_errno = ''

   SELECT COUNT(*) INTO l_n 
     FROM ryq_file
    WHERE ryq01 = g_ryq[l_ac].ryq01

   IF l_n > 0 THEN
      LET g_errno = 'apc-159' 
   END IF  
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT ryx05 INTO g_ryq[l_ac].ryq01_desc
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = g_ryq[l_ac].ryq01
         AND ryx04 = g_lang 
      DISPLAY g_ryq[l_ac].ryq01_desc TO s_ryq[l_ac].ryq01_desc
   END IF 
END FUNCTION 

FUNCTION i202_ryq02(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_rypacti    LIKE ryq_file.ryqacti
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_ryp02      LIKE ryp_file.ryp02
   LET g_errno = ''

   SELECT rypacti,ryp02 INTO l_rypacti,l_ryp02
     FROM ryp_file
    WHERE ryp01 = g_ryq[l_ac].ryq02

   CASE 
      WHEN SQLCA.SQLCODE = 100
          LET g_errno = 'apc-163'
       WHEN l_rypacti <> 'Y'
          LET g_errno = 'apc-164'
       WHEN l_ryp02 <> '2' 
          LET g_errno = 'apc-181'   
       OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT ryx05 INTO g_ryq[l_ac].ryq02_desc
        FROM ryx_file
       WHERE ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx03 = g_ryq[l_ac].ryq02
         AND ryx04 = g_lang
      DISPLAY g_ryq[l_ac].ryq02_desc TO s_ryq[l_ac].ryq02_desc 
   END IF 
END FUNCTION 

FUNCTION i202_ryq_chk(p_flag)
   DEFINE p_flag     LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.chr1

   LET g_errno = ''

   IF g_flag = '1' THEN
      SELECT count(*) INTO l_n
        FROM ryt_file
       WHERE ryt03 = g_ryq[l_ac].ryq01
   ELSE
      SELECT count(*) INTO l_n
        FROM ryt_file
       WHERE ryt03 = g_ryq_t.ryq01
   END IF  

   IF l_n > 0 THEN
      CASE p_flag
         WHEN '1'
            LET g_errno = 'apc-174'
         WHEN '3'
            LET g_errno = 'apc-160' 
         WHEN '4'   
            LET g_errno = 'apc-177'
         WHEN '5'
            LET g_errno = 'apc-178'
      END CASE
   END IF 
END FUNCTION

FUNCTION i202_ryx_chk()
   DEFINE l_n             LIKE type_file.num10
   DEFINE l_ryq01         LIKE ryq_file.ryq01

   IF NOT cl_null(g_ryq01) THEN
      LET l_ryq01 = g_ryq01
   ELSE
      IF NOT cl_null(g_ryq_t.ryq01) THEN
         LET l_ryq01 = g_ryq_t.ryq01
      END IF 
   END IF 

   IF NOT cl_null(l_ryq01) THEN
      SELECT COUNT(*) INTO l_n
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = l_ryq01
      IF l_n > 0 AND l_ryq01 <> g_ryq[l_ac].ryq01 THEN
         UPDATE ryx_file
            SET ryx03 = g_ryq[l_ac].ryq01
          WHERE ryx01 = 'ryq_file'
            AND ryx02 = 'ryq01'
            AND ryx03 = l_ryq01

         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ryq_file",g_ryq01,"",SQLCA.sqlcode,"","",1)
            RETURN FALSE
         ELSE
            LET g_ryq01 = g_ryq[l_ac].ryq01
            RETURN TRUE
         END IF
      ELSE
         LET g_ryq01 = g_ryq[l_ac].ryq01
         RETURN TRUE
      END IF
   ELSE
      LET g_ryq01 = g_ryq[l_ac].ryq01
      RETURN TRUE
   END IF 
END FUNCTION

FUNCTION i202_set_entry_b(p_cmd)                                                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1  

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("ryq01",TRUE)                                                                                           
   END IF                                                                                                                            
END FUNCTION   
                                                                                                                  
FUNCTION i202_set_no_entry_b(p_cmd)                                                                                                                                                                                                                           
   DEFINE p_cmd   LIKE type_file.chr1        
                                                                                                                                     
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ryq01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-C40084 --end-- 
