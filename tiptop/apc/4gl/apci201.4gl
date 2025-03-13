# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: apci201.4gl
# Descriptions...: POS模塊基本資料維護
# Date & Author..: No:FUN-C40084 12/04/27 By fanbj
# Modify.........: No.FUN-C60024 12/06/08 By fanbj POS基礎資料調整
# Modify.........: No.FUN-CB0007 12/11/19 By shiwuying bug修改
# Modify.........: No.MOD-D10271 13/01/29 By Sakura 修正單身最後一筆新增，會出現更新ryp_file錯誤 
# Modify.........: No.FUN-D20038 13/02/19 By dongsz POS使用者權限相關邏輯調整
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryp                DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          ryp01                LIKE ryp_file.ryp01,
          ryp01_desc           LIKE ryx_file.ryx05,
          ryp02                LIKE ryp_file.ryp02,
          ryp03                LIKE ryp_file.ryp03,
          ryp03_desc           LIKE ryx_file.ryx05,
          #FUN-C60024--start add-------------------
          ryp04                LIKE ryp_file.ryp04,
          ryp05                LIKE ryp_file.ryp05,
          ryp06                LIKE ryp_file.ryp06,
          #FUN-C60024--end add---------------------
          rypacti              LIKE ryp_file.rypacti,
          ryppos               LIKE ryp_file.ryppos 
                            END RECORD,
       g_ryp_t              RECORD                    #程式變數 (舊值)
          ryp01                LIKE ryp_file.ryp01,
          ryp01_desc           LIKE ryx_file.ryx05,
          ryp02                LIKE ryp_file.ryp02,
          ryp03                LIKE ryp_file.ryp03,
          ryp03_desc           LIKE ryx_file.ryx05,
          #FUN-C60024--start add-------------------
          ryp04                LIKE ryp_file.ryp04,
          ryp05                LIKE ryp_file.ryp05,
          ryp06                LIKE ryp_file.ryp06,
          #FUN-C60024--end add---------------------
          rypacti              LIKE ryp_file.rypacti,
          ryppos               LIKE ryp_file.ryppos 
                            END RECORD
DEFINE g_wc2,g_sql          string    
DEFINE g_rec_b              LIKE type_file.num5                
DEFINE l_ac                 LIKE type_file.num5 
 
DEFINE g_forupd_sql         STRING                    #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt                LIKE type_file.num10 
DEFINE g_i                  LIKE type_file.num5       #count/index for any purpose    
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_flag               LIKE type_file.chr1
DEFINE g_ryp01              LIKE ryp_file.ryp01
 
MAIN
   OPTIONS                                            #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                    #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("apc")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #計算使用時間 
           
   OPEN WINDOW i201_w  WITH FORM "apc/42f/apci201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('ryppos',FALSE)
   END IF   
    
   LET g_wc2 = ' 1=1' 
   CALL i201_b_fill(g_wc2)
   CALL i201_menu()
   CLOSE WINDOW i201_w                                #結束畫面
   CALL  cl_used(g_prog,g_time,2)  RETURNING g_time   #計算使用時間 (退出使間)
END MAIN
 
FUNCTION i201_menu()
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF

         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i201_b() 
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "preserve_name" 
            IF cl_chk_act_auth() THEN
               IF cl_null(g_ryp[l_ac].ryp01) THEN
                  CALL cl_err('','apc-179',0)
               ELSE
                  LET g_flag = '1' 
                  CALL i201_get_key_name('1',g_ryp[l_ac].ryp01,g_flag)
                       RETURNING g_ryp[l_ac].ryp01_desc
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryp),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_q()
   CALL i201_b_askkey()
END FUNCTION

FUNCTION i201_upd(p_ryppos)
   DEFINE p_ryppos        LIKE ryp_file.ryppos

   UPDATE ryp_file
      SET ryppos = p_ryppos
    WHERE ryp01 = g_ryp_t.ryp01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ryp_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
   END IF
   LET g_ryp[l_ac].ryppos = p_ryppos
   DISPLAY BY NAME g_ryp[l_ac].ryppos 
   
END FUNCTION
 
FUNCTION i201_b()
   DEFINE l_ac_t          LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5    #檢查重複用 
   DEFINE l_lock_sw       LIKE type_file.chr1    #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1    #處理狀態        
   DEFINE l_allow_insert  LIKE type_file.num5    #可新增否        
   DEFINE l_allow_delete  LIKE type_file.num5    #可刪除否 
   DEFINE l_n1            LIKE type_file.num5  
   DEFINE l_ryppos        LIKE ryp_file.ryppos
   DEFINE l_flag          LIKE type_file.chr1    #FUN-C60024 add
   DEFINE l_zz011         LIKE zz_file.zz011     #FUN-D20038 add
 
   LET g_action_choice = ""
   LET g_flag = '2'
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT ryp01,'',ryp02,ryp03,'',rypacti,ryppos",                   #FUN-C50036 mark
   LET g_forupd_sql = "SELECT ryp01,'',ryp02,ryp03,'',ryp04,ryp05,ryp06,rypacti,ryppos",  #FUN-C50036 add
                      "  FROM ryp_file  ",                
                      " WHERE ryp01= ?  FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ryp WITHOUT DEFAULTS FROM s_ryp.*              
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert) 
         
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
             
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryp03)                                                                                   
               CALL cl_init_qry_var()                                                                                
               LET g_qryparam.form ="q_ryp_1"                                                                        
               LET g_qryparam.arg1 = g_lang 
               LET g_qryparam.where = "ryp01 <> '",g_ryp[l_ac].ryp01,"'" 
               LET g_qryparam.default1 = g_ryp[l_ac].ryp03                                                        
               CALL cl_create_qry() RETURNING g_ryp[l_ac].ryp03                                                
               DISPLAY g_ryp[l_ac].ryp03 TO ryp03                                                               
               NEXT FIELD ryp03   
                               
            OTHERWISE EXIT CASE
         END CASE 
                      
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
        #LET l_flag = 'N'                  #FUN-C60024 add #MOD-D10271 mark
         LET g_ryp01 = NULL
         LET l_n  = ARR_COUNT()
         IF g_ryp[l_ac].ryp02 = '1' THEN
            CALL cl_set_comp_entry("ryp03",FALSE)
         ELSE
            CALL cl_set_comp_entry("ryp03",TRUE)
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ryp_t.* = g_ryp[l_ac].*  #BACKUP
                                                                                                    
            LET g_before_input_done = FALSE                                                                                      
            CALL i201_set_entry_b(p_cmd)                                                                                         
            CALL i201_set_no_entry_b(p_cmd)                                                                                      

            LET g_before_input_done = TRUE                                                                                       


            IF g_aza.aza88 = 'Y' THEN
               BEGIN WORK
               OPEN i201_bcl USING g_ryp_t.ryp01
               IF STATUS THEN
                  CALL cl_err(g_ryp[l_ac].ryp01,status,1)
                  CLOSE i201_bcl
                  ROLLBACK WORK
                  RETURN 
               ELSE
                  FETCH i201_bcl INTO g_ryp[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ryp[l_ac].ryp01,SQLCA.sqlcode,1)
                     CLOSE i201_bcl
                     ROLLBACK WORK
                     RETURN 
                  ELSE
                     #FUN-C60024--start add------------------
                     SELECT ryppos INTO l_ryppos
                       FROM ryp_file
                      WHERE ryp01 = g_ryp[l_ac].ryp01
                     #FUN-C60024--end add---------------------
 
                     UPDATE ryp_file
                        SET ryppos = '4'
                      WHERE ryp01 = g_ryp[l_ac].ryp01
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","ryp_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
                        LET l_lock_sw = "Y"
                     END IF
                     #LET l_ryppos = g_ryp[l_ac].ryppos          #FUN-C60024 mark        
                     LET g_ryp[l_ac].ryppos = '4'              
                     DISPLAY BY NAME g_ryp[l_ac].ryppos
                  END IF
               END IF
               CLOSE i201_bcl
               COMMIT WORK
            END IF

            BEGIN WORK
 
            OPEN i201_bcl USING g_ryp_t.ryp01
            IF STATUS THEN
               CALL cl_err("OPEN i201_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i201_bcl INTO g_ryp[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ryp_t.ryp01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i201_ryp01('d')
               CALL i201_ryp03('d')                
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         #FUN-C60024--start add------------------------------------------------
         #INSERT INTO ryp_file(ryp01,ryp02,ryp03,ryppos,rypacti,rypcrat,rypdate,
         #                     rypgrup,rypuser,ryporiu,ryporig)                 
         #FUN-C60024--end add--------------------------------------------------
      
         #FUN-C60024--start add------------------------------------------------
         INSERT INTO ryp_file(ryp01,ryp02,ryp03,ryp04,ryp05,ryp06,
                              ryppos,rypacti,rypcrat,rypdate,
                              rypgrup,rypuser,ryporiu,ryporig)
         #FUN-C60024--end add--------------------------------------------------
 
         VALUES(g_ryp[l_ac].ryp01,g_ryp[l_ac].ryp02,g_ryp[l_ac].ryp03,
                g_ryp[l_ac].ryp04,g_ryp[l_ac].ryp05,g_ryp[l_ac].ryp06,       #FUN-C60024 add  
                g_ryp[l_ac].ryppos,g_ryp[l_ac].rypacti,g_today,g_today,
                g_grup,g_user,g_user,g_grup)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ryp_file",g_ryp[l_ac].ryp01,"",SQLCA.sqlcode,"","",1) 
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
         CALL i201_set_entry_b(p_cmd)                                                                                         
         CALL i201_set_no_entry_b(p_cmd)                                                                                      
         LET g_before_input_done = TRUE                                                                                       


         INITIALIZE g_ryp[l_ac].* TO NULL      
         LET g_ryp_t.* = g_ryp[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         LET g_ryp[l_ac].rypacti = 'Y' 
         LET g_ryp[l_ac].ryp02 = '1'
         LET g_ryp[l_ac].ryp04 = '0'           #FUN-C60024 add  
         LET g_ryp01 = NULL                    #FUN-C60024 add
         IF g_ryp[l_ac].ryp02 = '1' THEN
            CALL cl_set_comp_entry("ryp03",FALSE)
         END IF 
         IF g_aza.aza88 = 'Y' THEN                                            
            LET g_ryp[l_ac].ryppos = '1'                                      
            LET l_ryppos = '1' 
         END IF     
         DISPLAY BY NAME g_ryp[l_ac].ryppos
         CALL cl_set_comp_entry("ryppos",FALSE)
         NEXT FIELD ryp01

 
      AFTER FIELD ryp01                        #check 編號是否重複
         IF NOT cl_null(g_ryp[l_ac].ryp01) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ryp_t.ryp01 <> g_ryp[l_ac].ryp01) THEN 
               IF p_cmd = 'u' AND g_ryp_t.ryp01 <> g_ryp[l_ac].ryp01 THEN
                  CALL i201_ryp_chk('5')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_ryp[l_ac].ryp01 = g_ryp_t.ryp01
                     NEXT FIELD ryp01
                  END IF 
               END IF 
               CALL i201_ryp01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryp[l_ac].ryp01 = g_ryp_t.ryp01
                  DISPLAY BY NAME g_ryp[l_ac].ryp01                  
                  NEXT FIELD ryp01
               END IF 
            END IF   
         END IF

      ON CHANGE ryp02
         IF g_ryp[l_ac].ryp02 = '1' THEN
            CALL cl_set_comp_entry("ryp03",FALSE)
         ELSE
            CALL cl_set_comp_entry("ryp03",TRUE)
         END IF 
 
      AFTER FIELD ryp02
         IF NOT cl_null(g_ryp[l_ac].ryp02) THEN 
            IF NOT cl_null(g_ryp_t.ryp02) AND g_ryp[l_ac].ryp02 <> g_ryp_t.ryp02 THEN
               CALL i201_ryp_chk('3')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryp[l_ac].ryp02 = g_ryp_t.ryp02
                  NEXT FIELD ryp02
               END IF 
            END IF  
            CALL i201_ryp03_chk()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)   
               IF g_ryp[l_ac].ryp02 = '2' THEN
                  LET g_ryp[l_ac].ryp02 = g_ryp_t.ryp02
                  DISPLAY BY NAME g_ryp[l_ac].ryp02
                  NEXT FIELD ryp02
               END IF   
            END IF 
         END IF 

      AFTER FIELD ryp03
         IF NOT cl_null(g_ryp[l_ac].ryp03) THEN
            IF NOT cl_null(g_ryp_t.ryp03) AND g_ryp[l_ac].ryp03 <> g_ryp_t.ryp03 THEN
               CALL i201_ryp_chk('4') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryp[l_ac].ryp03 = g_ryp_t.ryp03
                  DISPLAY BY NAME g_ryp[l_ac].ryp03
                  NEXT FIELD ryp03
               END IF 
            END IF   
            
            CALL i201_ryp03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ryp[l_ac].ryp03 = g_ryp_t.ryp03
               DISPLAY BY NAME g_ryp[l_ac].ryp03                  
               NEXT FIELD ryp03
            END IF  
            
            IF NOT cl_null(g_ryp[l_ac].ryp02) THEN
               CALL i201_ryp03_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  IF g_ryp[l_ac].ryp02 = '2' THEN 
                     LET g_ryp[l_ac].ryp03 = g_ryp_t.ryp03
                     DISPLAY BY NAME g_ryp[l_ac].ryp03
                     NEXT FIELD ryp03
                  END IF 
               END IF 
            END IF 
         END IF  

     #FUN-D20038--add--str---
      AFTER FIELD ryp04
         CALL cl_set_comp_required("ryp06",FALSE)
         IF g_ryp[l_ac].ryp04 = '2' THEN
            CALL cl_set_comp_required("ryp06",TRUE)
            IF NOT cl_null(g_ryp[l_ac].ryp06) THEN
               SELECT COUNT(*) INTO l_n FROM zz_file WHERE zz01 = g_ryp[l_ac].ryp06
               IF l_n < 1 THEN
                  CALL cl_err('','apc-668',0)
                  LET g_ryp[l_ac].ryp06 = g_ryp_t.ryp06
                  DISPLAY BY NAME g_ryp[l_ac].ryp06
                  NEXT FIELD ryp06
               ELSE
                  SELECT zz011 INTO l_zz011 FROM zz_file WHERE zz01 = g_ryp[l_ac].ryp06
                  IF l_zz011 != 'WPC' THEN
                     CALL cl_err('','apc-668',0)
                     LET g_ryp[l_ac].ryp06 = g_ryp_t.ryp06
                     DISPLAY BY NAME g_ryp[l_ac].ryp06
                     NEXT FIELD ryp06 
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD ryp06
         IF g_ryp[l_ac].ryp04 = '2' THEN
            IF cl_null(g_ryp[l_ac].ryp06) THEN
               CALL cl_err('','apc-668',0) 
               NEXT FIELD ryp06
            ELSE
               SELECT COUNT(*) INTO l_n FROM zz_file WHERE zz01 = g_ryp[l_ac].ryp06
               IF l_n < 1 THEN
                  CALL cl_err('','apc-668',0)
                  LET g_ryp[l_ac].ryp06 = g_ryp_t.ryp06
                  DISPLAY BY NAME g_ryp[l_ac].ryp06
                  NEXT FIELD ryp06
               ELSE
                  SELECT zz011 INTO l_zz011 FROM zz_file WHERE zz01 = g_ryp[l_ac].ryp06
                  IF l_zz011 != 'WPC' THEN
                     CALL cl_err('','apc-668',0)
                     LET g_ryp[l_ac].ryp06 = g_ryp_t.ryp06
                     DISPLAY BY NAME g_ryp[l_ac].ryp06
                     NEXT FIELD ryp06
                  END IF
               END IF
            END IF
         END IF
     #FUN-D20038--add--end---

      ON CHANGE rypacti 
         IF g_ryp_t.rypacti = 'Y'  AND g_ryp[l_ac].rypacti = 'N' THEN
            CALL i201_ryp_chk('2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ryp[l_ac].rypacti = g_ryp_t.rypacti
               NEXT FIELD rypacti
            END IF 
         END IF 

      AFTER FIELD ryppos
         IF NOT cl_null(g_ryp[l_ac].ryppos) THEN
            IF g_ryp[l_ac].ryppos NOT MATCHES '[123]' THEN
               NEXT FIELD ryppos
            END IF
         END IF     
        
      BEFORE DELETE                            #是否取消單身
         IF g_ryp_t.ryp01 IS NOT NULL THEN
            
            CALL i201_ryp_chk('1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               CANCEL DELETE
            END IF

            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "ryp01" 
            LET g_doc.value1 = g_ryp[l_ac].ryp01
            CALL cl_del_doc()
      
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
         
            IF g_aza.aza88 = 'Y' THEN
               IF NOT ((l_ryppos='3' AND g_ryp_t.rypacti='N')
                         OR (l_ryppos ='1'))  THEN
                  CALL cl_err('','apc-139',0)
                  CANCEL DELETE 
               END IF 
            END IF 
         
            DELETE FROM ryx_file
             WHERE ryx01 = 'ryp_file'
               AND ryx02 = 'ryp01'
               AND ryx03 = g_ryp_t.ryp01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ryx_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF   
           
            DELETE FROM ryp_file WHERE ryp01 = g_ryp_t.ryp01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ryp_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET l_flag = 'Y'   #FUN-CB0007
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK"
            CLOSE i201_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryp[l_ac].* = g_ryp_t.*
            CLOSE i201_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF                      

         LET l_flag = 'Y'                           #FUN-C60024 add
           
         IF p_cmd = 'u' AND (g_ryp_t.ryp01 <> g_ryp[l_ac].ryp01 
                          OR g_ryp_t.ryp02 <> g_ryp[l_ac].ryp02
                          OR g_ryp_t.ryp03 <> g_ryp[l_ac].ryp03
                          OR g_ryp_t.rypacti <> g_ryp[l_ac].rypacti) THEN
            CALL i201_ryp_chk('5')
            IF NOT cl_null(g_errno) THEN
               CALL i201_upd(l_ryppos)
               CALL cl_err('',g_errno,0) 
               LET g_ryp[l_ac].* = g_ryp_t.*
               NEXT FIELD ryp01
            END IF 
         END IF  
         IF g_aza.aza88 = 'Y' THEN
            IF l_ryppos <> '1' THEN
               LET g_ryp[l_ac].ryppos = '2'
            ELSE
               LET g_ryp[l_ac].ryppos = '1'
            END IF
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryp[l_ac].ryp01,-263,1)
            LET g_ryp[l_ac].* = g_ryp_t.*
         ELSE
            IF p_cmd = 'u' AND g_ryp_t.ryp01 <> g_ryp[l_ac].ryp01 THEN
               SELECT COUNT(*) INTO l_n
                 FROM ryx_file
                WHERE ryx01 = 'ryp_file'
                  AND ryx02 = 'ryp01'
                  AND ryx03 = g_ryp_t.ryp01

               IF l_n > 0 THEN
                  UPDATE ryx_file
                     SET ryx03 = g_ryp[l_ac].ryp01
                   WHERE ryx01 = 'ryp_file'
                     AND ryx02 = 'ryp01'
                     AND ryx03 = g_ryp_t.ryp01

                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","ryx_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
            END IF

            UPDATE ryp_file
               SET ryp01=g_ryp[l_ac].ryp01,
                   ryp02=g_ryp[l_ac].ryp02,
                   ryp03=g_ryp[l_ac].ryp03,
                   #FUN-C60024--start add------------------
                   ryp04=g_ryp[l_ac].ryp04,
                   ryp05=g_ryp[l_ac].ryp05,
                   ryp06=g_ryp[l_ac].ryp06,
                   #FUN-C60024--end add--------------------              
                   rypacti=g_ryp[l_ac].rypacti,
                   ryppos=g_ryp[l_ac].ryppos,
                   rypmodu = g_user,
                   rypdate = g_today
             WHERE ryp01 = g_ryp_t.ryp01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ryp_file",g_ryp_t.ryp01,"",SQLCA.sqlcode,"","",1)
                LET g_ryp[l_ac].* = g_ryp_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i201_bcl
                COMMIT WORK
            END IF
         END IF   
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i201_bcl
            ROLLBACK WORK
            IF p_cmd='u' THEN
               IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN
                  CALL i201_upd(l_ryppos)
               END IF
               LET g_ryp[l_ac].* = g_ryp_t.*
            ELSE
               CALL g_ryp.deleteElement(l_ac)
              #FUN-D30033--add--begin--
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
              #FUN-D30033--add--end----
            END IF
            EXIT INPUT
         END IF
         #FUN-C60024--start add---------
         IF l_flag <> 'Y' AND NOT INT_FLAG THEN
            IF l_ryppos <> '1' THEN
               LET g_ryp[l_ac].ryppos = '2'
            ELSE
               LET g_ryp[l_ac].ryppos = '1'
            END IF   
            CALL i201_upd(g_ryp[l_ac].ryppos)
         END IF  
         #FUN-C60024--end add-----------

         LET l_ac_t = l_ac #FUN-D30033  add 
         CLOSE i201_bcl
         COMMIT WORK
 
      ON ACTION preserve_name1
         IF cl_null(g_ryp[l_ac].ryp01) THEN
            CALL cl_err('','apc-179',0)
         ELSE
            IF i201_ryx_chk() THEN 
               CALL i201_get_key_name('1',g_ryp[l_ac].ryp01,g_flag)
                    RETURNING g_ryp[l_ac].ryp01_desc
            END IF 
         END IF 

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ryp01) AND l_ac > 1 THEN
            LET g_ryp[l_ac].* = g_ryp[l_ac-1].*
            NEXT FIELD ryp01
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
   CLOSE i201_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i201_b_askkey()
   CLEAR FORM
   CALL g_ryp.clear()

   #CONSTRUCT g_wc2 ON ryp01,ryp02,ryp03,rypacti,ryppos                   #FUN-C60024 mark
   CONSTRUCT g_wc2 ON ryp01,ryp02,ryp03,ryp04,ryp05,ryp06,rypacti,ryppos  #FUN-C60024 add
          FROM s_ryp[1].ryp01,s_ryp[1].ryp02,s_ryp[1].ryp03,
               s_ryp[1].ryp04,s_ryp[1].ryp05,s_ryp[1].ryp06,              #FUN-C60024 add
               s_ryp[1].rypacti,s_ryp[1].ryppos

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryp01)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_ryp01"                                                                       
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state='c'                                                                             
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO ryp01                                                               
               NEXT FIELD ryp01  
                      
            WHEN INFIELD(ryp03)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_ryp03"   
               LET g_qryparam.arg1 = g_lang                                                                     
               LET g_qryparam.state='c'                                                                             
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO ryp03                                                               
               NEXT FIELD ryp03
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
   CALL i201_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)             
   DEFINE p_wc2           LIKE type_file.chr1000 

   #LET g_sql = "SELECT ryp01,'',ryp02,ryp03,'',rypacti,ryppos ",                   #FUN-C60024 mark
   LET g_sql = "SELECT ryp01,'',ryp02,ryp03,'',ryp04,ryp05,ryp06,rypacti,ryppos ",  #FUN-C60024 add                 
              " FROM ryp_file ",
              " WHERE ", p_wc2 CLIPPED,                     #單身
              " ORDER BY ryp01"
 
   PREPARE i201_pb FROM g_sql
   DECLARE ryp_curs CURSOR FOR i201_pb
 
   CALL g_ryp.clear()
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
   FOREACH ryp_curs INTO g_ryp[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       
      SELECT ryx05 INTO g_ryp[g_cnt].ryp01_desc
        FROM ryx_file
       WHERE ryx03 = g_ryp[g_cnt].ryp01
         AND ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx04 = g_lang  

      SELECT ryx05 INTO g_ryp[g_cnt].ryp03_desc
        FROM ryx_file
       WHERE ryx03 = g_ryp[g_cnt].ryp03
         AND ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx04 = g_lang

      LET g_cnt = g_cnt + 1
     
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF     
   END FOREACH
   CALL g_ryp.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryp TO s_ryp.* ATTRIBUTE(COUNT=g_rec_b)
 
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
            CALL i201_b_fill( g_wc2) 
 
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

FUNCTION i201_ryp01(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_n         LIKE type_file.num10

   LET g_errno = ''

   SELECT COUNT(*) INTO l_n 
     FROM ryp_file
    WHERE ryp01 = g_ryp[l_ac].ryp01

   IF l_n > 0 THEN
      LET g_errno = 'apc-162' 
   END IF  
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT ryx05 INTO g_ryp[l_ac].ryp01_desc
        FROM ryx_file
       WHERE ryx03 = g_ryp[l_ac].ryp01
         AND ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx04 = g_lang 
      DISPLAY g_ryp[l_ac].ryp01_desc TO s_ryp[l_ac].ryp01_desc
   END IF 
END FUNCTION 

FUNCTION i201_ryp03(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_rypacti    LIKE ryp_file.rypacti

   LET g_errno = ''

   SELECT rypacti INTO l_rypacti
     FROM ryp_file
    WHERE ryp01 = g_ryp[l_ac].ryp03

   CASE 
      WHEN SQLCA.SQLCODE = 100
          LET g_errno = 'apc-169'
       WHEN l_rypacti <> 'Y'
          LET g_errno = 'apc-164'
       OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT ryx05 INTO g_ryp[l_ac].ryp03_desc
        FROM ryx_file
       WHERE ryx03 = g_ryp[l_ac].ryp03
         AND ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx04 = g_lang
      DISPLAY g_ryp[l_ac].ryp03_desc TO s_ryp[l_ac].ryp03_desc 
   END IF 
END FUNCTION 

FUNCTION i201_ryp03_chk()
   DEFINE l_ryp02         LIKE ryp_file.ryp02

   LET g_errno = ''
   
   IF g_ryp[l_ac].ryp02 = '1' THEN
      LET g_ryp[l_ac].ryp03 = NULL
      LET g_ryp[l_ac].ryp03_desc = NULL
      DISPLAY BY NAME  g_ryp[l_ac].ryp03
      DISPLAY BY NAME g_ryp[l_ac].ryp03_desc  
      CALL cl_set_comp_entry("ryp03",FALSE)
   ELSE
      IF g_ryp[l_ac].ryp02 = '2' THEN
         IF g_ryp[l_ac].ryp03 = g_ryp_t.ryp01 THEN
            LET g_errno = 'apc-169'
            RETURN
         END IF            

         SELECT ryp02 INTO l_ryp02
           FROM ryp_file
          WHERE ryp01 = g_ryp[l_ac].ryp03

         IF l_ryp02 = '2' THEN 
            LET g_errno = 'apc-169' 
            RETURN 
         END IF 
      END IF    
   END IF       
END FUNCTION

FUNCTION i201_ryp_chk(p_flag)
   DEFINE p_flag     LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.chr1

   LET g_errno = ''
   IF p_flag <> '4' THEN 
      IF g_flag = '1' THEN
         SELECT count(*) INTO l_n
           FROM ryp_file
          WHERE ryp03 = g_ryp[l_ac].ryp01
      ELSE 
         SELECT count(*) INTO l_n
           FROM ryp_file   
          WHERE ryp03 = g_ryp_t.ryp01
      END IF 
      CASE
         WHEN l_n > 0 AND p_flag = '1'
            LET g_errno = 'apc-172'
            RETURN
         WHEN l_n > 0 AND p_flag = '2'
            LET g_errno = 'apc-182'
            RETURN
         WHEN l_n > 0 AND p_flag = '3'
            LET g_errno = 'apc-173'
            RETURN
         WHEN l_n > 0 AND P_flag = '5'
            LET g_errno = 'apc-171' 
            RETURN
      END CASE
   END IF  

   IF g_flag = '1' THEN
      SELECT COUNT(*) INTO l_n
        FROM ryq_file
       WHERE ryq02 = g_ryp[l_ac].ryp01
   ELSE
      SELECT count(*) INTO l_n
        FROM ryq_file
        WHERE ryq02 = g_ryp_t.ryp01
   END IF 

   IF l_n > 0 THEN
      CASE p_flag 
         WHEN '1'
            LET g_errno = 'apc-165'
         WHEN '3'
            LET g_errno = 'apc-167'
         WHEN '4' 
            LET g_errno = 'apc-168' 
         WHEN '5'
            LET g_errno = 'apc-176'
      END CASE
   END IF 
END FUNCTION

FUNCTION i201_ryx_chk()
   DEFINE l_n             LIKE type_file.num10
   DEFINE l_ryp01         LIKE ryp_file.ryp01

   IF NOT cl_null(g_ryp01) THEN 
      LET l_ryp01 = g_ryp01
   ELSE
      IF NOT cl_null(g_ryp_t.ryp01) THEN
         LET l_ryp01 = g_ryp_t.ryp01
      END IF
   END IF

   IF NOT cl_null(l_ryp01) THEN
      SELECT COUNT(*) INTO l_n
        FROM ryx_file
       WHERE ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx03 = l_ryp01
      IF l_n > 0 AND l_ryp01 <> g_ryp[l_ac].ryp01 THEN
         UPDATE ryx_file
            SET ryx03 = g_ryp[l_ac].ryp01
          WHERE ryx01 = 'ryp_file'
            AND ryx02 = 'ryp01'
            AND ryx03 = l_ryp01

         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ryp_file",g_ryp01,"",SQLCA.sqlcode,"","",1)
            RETURN FALSE
         ELSE
            LET g_ryp01 = g_ryp[l_ac].ryp01
            RETURN TRUE
         END IF
      ELSE
         LET g_ryp01 = g_ryp[l_ac].ryp01
         RETURN TRUE
      END IF
   ELSE
      LET g_ryp01 = g_ryp[l_ac].ryp01
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i201_set_entry_b(p_cmd)                                                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1  

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("ryp01",TRUE)                                                                                           
   END IF                                                                                                                            
END FUNCTION   
                                                                                                                  
FUNCTION i201_set_no_entry_b(p_cmd)                                                                                                                                                                                                                           
   DEFINE p_cmd   LIKE type_file.chr1        
                                                                                                                                     
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ryp01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#FUN-C40084 --end-- 
