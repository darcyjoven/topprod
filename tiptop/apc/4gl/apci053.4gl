# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apci053.4gl
# Descriptions...: 觸摸分類維護作業
# Date & Author..: No.FUN-D20020 13/02/06 By dongsz
# Modify.........: No:FUN-D30093 13/03/27 By dongsz 如果分類名稱有異動，同時更新apci054中的分類名稱及已傳POS否欄位
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_rzh            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        rzh01       LIKE rzh_file.rzh01,  
        rzh02       LIKE rzh_file.rzh02, 
        rzh03       LIKE rzh_file.rzh03,  
        rzh04       LIKE rzh_file.rzh04,
        rzh04_desc  LIKE rzh_file.rzh02, 
        rzh05       LIKE rzh_file.rzh05, 
        rzh06       LIKE rzh_file.rzh06,
        rzhacti     LIKE rzh_file.rzhacti
                    END RECORD,
   g_rzh_t          RECORD                    #程式變數 (舊值)
        rzh01       LIKE rzh_file.rzh01,  
        rzh02       LIKE rzh_file.rzh02, 
        rzh03       LIKE rzh_file.rzh03, 
        rzh04       LIKE rzh_file.rzh04, 
        rzh04_desc  LIKE rzh_file.rzh02,
        rzh05       LIKE rzh_file.rzh05, 
        rzh06       LIKE rzh_file.rzh06,
        rzhacti     LIKE rzh_file.rzhacti
                    END RECORD,
   g_wc2,g_sql      STRING,    
   g_rec_b          LIKE type_file.num5,      #單身筆數       
   l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT       
DEFINE p_row,p_col  LIKE type_file.num5     
DEFINE g_forupd_sql STRING                    #SELECT ... FOR UPDATE SQL    
DEFINE g_cnt        LIKE type_file.num10         
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose        
DEFINE g_before_input_done LIKE type_file.num5    
 
MAIN
   OPTIONS                                    #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                    
 
   OPEN WINDOW i053_w WITH FORM "apc/42f/apci053"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   IF g_azw.azw04 <> '2' THEN
      CALL cl_set_comp_visible("rzh03,rzh04,rzh04_desc,rzh05,rzh06",FALSE)    
   ELSE
      CALL cl_set_comp_visible("rzh03,rzh04,rzh04_desc,rzh05,rzh06,rzhacti",TRUE)
   END IF
   
   LET g_wc2 = '1=1' CALL i053_b_fill(g_wc2)
   CALL i053_menu()
   CLOSE WINDOW i053_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i053_menu()
DEFINE l_cmd  LIKE type_file.chr1000           
   WHILE TRUE
      CALL i053_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i053_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i053_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
                CALL i053_out()                
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rzh),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i053_q()
   CALL i053_b_askkey()
END FUNCTION
 
FUNCTION i053_b()
DEFINE
    l_ac_t          LIKE type_file.num5,             #未取消的ARRAY CNT       
    l_n             LIKE type_file.num5,             #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,             #單身鎖住否        
    p_cmd           LIKE type_file.chr1,             #處理狀態       
    l_allow_insert  LIKE type_file.num5,             #可新增否        
    l_allow_delete  LIKE type_file.num5,             #可刪除否       
    l_cnt           LIKE type_file.num10,                  
    l_rzh06         LIKE rzh_file.rzh06,                  
    l_rzh03         LIKE rzh_file.rzh03,                
    l_rzh01         LIKE rzh_file.rzh01,                  
    l_rzh04         LIKE rzh_file.rzh04,                 
    l_rzh03_1       LIKE rzh_file.rzh03,                  
    l_rzh06_1       LIKE rzh_file.rzh06,                 
    l_n1            LIKE type_file.num5,               
    l_n2            LIKE type_file.num5               
DEFINE l_sql        STRING                               
DEFINE i            LIKE type_file.num5            
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT rzh01,rzh02,rzh03,rzh04,'',rzh05,rzh06,rzhacti ",   
                      "  FROM rzh_file WHERE rzh01=? FOR UPDATE"  
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i053_bcl CURSOR FROM g_forupd_sql     
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_rzh WITHOUT DEFAULTS FROM s_rzh.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               IF cl_null(g_rzh[l_ac].rzh05) THEN 
                  LET g_rzh[l_ac].rzh05='0'  
                  UPDATE rzh_file SET rzh05=0 WHERE rzh01 = g_rzh[l_ac].rzh01     
               END IF

               LET g_rzh_t.* = g_rzh[l_ac].*   #BACKUP
                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i053_set_entry_b(p_cmd)                                                                                         
               CALL i053_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
 
               BEGIN WORK
 
               OPEN i053_bcl USING g_rzh_t.rzh01
               IF STATUS THEN
                  CALL cl_err("OPEN i053_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i053_bcl INTO g_rzh[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rzh_t.rzh01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  IF g_azw.azw04='2' THEN                             
                     CALL i053_get_rzh04_desc(g_rzh[l_ac].rzh04)     
                        RETURNING g_rzh[l_ac].rzh04_desc            
                  END IF                                                
               END IF
               CALL cl_show_fld_cont()    
            END IF

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO rzh_file(rzh01,rzh02,rzh03,rzh04,rzh05,rzh06,rzhacti) 
              VALUES(g_rzh[l_ac].rzh01,g_rzh[l_ac].rzh02,
                     g_rzh[l_ac].rzh03,g_rzh[l_ac].rzh04,   
                     g_rzh[l_ac].rzh05,g_rzh[l_ac].rzh06,   
                     g_rzh[l_ac].rzhacti)                 
 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","rzh_file",g_rzh[l_ac].rzh01,"",SQLCA.sqlcode,"","",1)  
                 CANCEL INSERT
              ELSE
                 IF g_azw.azw04='2' THEN
                    IF g_rzh[l_ac].rzh04 IS NOT NULL THEN
                       UPDATE rzh_file SET rzh05=COALESCE(rzh05,0)+1 WHERE rzh01=g_rzh[l_ac].rzh04
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","rzh_file",g_rzh[l_ac].rzh01,"",SQLCA.sqlcode,"","",1)
                       END IF
                    END IF
                 END IF
                 MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2  
                 IF g_azw.azw04='2' THEN                           
                     FOR i=1 TO g_rec_b                                                                                             
                        IF g_rzh[l_ac].rzh04=g_rzh[i].rzh01 THEN                                                                    
                           LET g_rzh[i].rzh05=g_rzh[i].rzh05+1                                                               
                        END IF                                                                                                      
                     END FOR 
                     IF cl_null(g_rzh[l_ac].rzh05) THEN 
                        LET g_rzh[l_ac].rzh05 = 0
                     END IF 
                     DISPLAY BY NAME g_rzh[l_ac].rzh05 
                  END IF      
               END IF
 
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'

            LET g_before_input_done = FALSE
            CALL i053_set_entry_b(p_cmd)
            CALL i053_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE

            INITIALIZE g_rzh[l_ac].* TO NULL     
            IF g_azw.azw04='2' THEN                   
               LET g_rzh[l_ac].rzh05=0               
               LET g_rzh[l_ac].rzhacti='Y'           
               LET g_rzh[l_ac].rzh03 = 1            
            END IF                                    
            LET g_rzh[l_ac].rzhacti='Y'             
            LET g_rzh_t.* = g_rzh[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD rzh01
 
         AFTER FIELD rzh01                         #check 編號是否重複
            IF g_rzh[l_ac].rzh01 IS NOT NULL THEN
               IF p_cmd = "a" THEN
                  LET g_rzh[l_ac].rzh06 = g_rzh[l_ac].rzh01 
               END IF
               IF g_rzh[l_ac].rzh01 != g_rzh_t.rzh01 OR
                  (g_rzh[l_ac].rzh01 IS NOT NULL AND g_rzh_t.rzh01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM rzh_file
                   WHERE rzh01 = g_rzh[l_ac].rzh01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_rzh[l_ac].rzh01 = g_rzh_t.rzh01
                     NEXT FIELD rzh01
                  END IF
               END IF
            END IF

         AFTER FIELD rzh04
            IF g_azw.azw04='2' THEN   
               IF NOT cl_null(g_rzh[l_ac].rzh04) THEN
                  LET l_n= 0 
                  SELECT COUNT(*) INTO l_n FROM rzh_file
                   WHERE rzh01 = g_rzh[l_ac].rzh04
                  IF l_n = 0 AND g_rzh[l_ac].rzh04 != g_rzh[l_ac].rzh01 THEN 
                     CALL cl_err('','alm-845',1)
                     LET g_rzh[l_ac].rzh04=g_rzh_t.rzh04
                     LET g_rzh[l_ac].rzh04_desc=g_rzh_t.rzh04_desc
                     DISPLAY BY NAME g_rzh[l_ac].rzh04,g_rzh[l_ac].rzh04_desc
                     NEXT FIELD rzh04
                  END IF
                  IF g_rzh[l_ac].rzh04 != g_rzh[l_ac].rzh01 THEN   
                     IF g_rzh[l_ac].rzh04 != g_rzh_t.rzh04 OR g_rzh_t.rzh04 IS NULL THEN
                        SELECT rzh03 INTO l_rzh03_1 FROM rzh_file WHERE rzh01 = g_rzh[l_ac].rzh04
                        LET g_rzh[l_ac].rzh03 = l_rzh03_1 + 1
                        DISPLAY BY NAME g_rzh[l_ac].rzh03
                        LET l_rzh03_1 = g_rzh[l_ac].rzh03 + 1
                        CALL i053_rzh04_rzh03(g_rzh[l_ac].rzh01,l_rzh03_1)
                        SELECT COUNT(*) INTO l_n1 FROM rzh_file WHERE rzh04 = g_rzh[l_ac].rzh01
                        LET g_rzh[l_ac].rzh05 = l_n1
                        DISPLAY BY NAME g_rzh[l_ac].rzh05
                        SELECT rzh06 INTO l_rzh06_1 FROM rzh_file WHERE rzh01=g_rzh[l_ac].rzh04
                        LET g_rzh[l_ac].rzh06=l_rzh06_1
                        DISPLAY BY NAME g_rzh[l_ac].rzh06
                        CALL i053_rzh04_rzh06(g_rzh[l_ac].rzh01,l_rzh06_1)
                     END IF

                     IF NOT cl_null(g_rzh[l_ac].rzh03) THEN                     
                        LET l_cnt=0
                        SELECT COUNT(*) INTO l_cnt FROM rzh_file
                         WHERE rzh01=g_rzh[l_ac].rzh04
                           AND rzhacti='Y' AND rzh03<g_rzh[l_ac].rzh03
                     ELSE
                        LET l_cnt=0
                        SELECT COUNT(*) INTO l_cnt FROM rzh_file
                         WHERE rzh01=g_rzh[l_ac].rzh04
                           AND rzhacti='Y'
                     END IF
                     IF l_cnt=0 THEN 
                        CALL cl_err('','art-027',1)
                        LET g_rzh[l_ac].rzh04=g_rzh_t.rzh04
                        LET g_rzh[l_ac].rzh04_desc=g_rzh_t.rzh04_desc
                        DISPLAY BY NAME g_rzh[l_ac].rzh04,g_rzh[l_ac].rzh04_desc
                        NEXT FIELD rzh04
                     END IF
                  END IF   
                  CALL i053_get_rzh04_desc(g_rzh[l_ac].rzh04)
                     RETURNING g_rzh[l_ac].rzh04_desc
               ELSE
                  LET g_rzh[l_ac].rzh03 = 1                  
                  DISPLAY BY NAME g_rzh[l_ac].rzh03         
                  LET l_rzh03_1 = g_rzh[l_ac].rzh03 + 1
                  CALL i053_rzh04_rzh03(g_rzh[l_ac].rzh01,l_rzh03_1)
                  SELECT COUNT(*) INTO l_n1 FROM rzh_file WHERE rzh04 = g_rzh[l_ac].rzh01
                  LET g_rzh[l_ac].rzh05 = l_n1
                  DISPLAY BY NAME g_rzh[l_ac].rzh05
                  LET g_rzh[l_ac].rzh04_desc=NULL
                  DISPLAY BY NAME g_rzh[l_ac].rzh04_desc
                  LET g_rzh[l_ac].rzh06=g_rzh[l_ac].rzh01
                  DISPLAY BY NAME g_rzh[l_ac].rzh06
                  CALL i053_rzh04_rzh06(g_rzh[l_ac].rzh01,g_rzh[l_ac].rzh06)
               END IF
            END IF

         AFTER FIELD rzhacti
            IF g_rzh[l_ac].rzhacti = 'N' THEN
               LET l_n2 = 0
               SELECT COUNT(*) INTO l_n2 FROM rzh_file 
                WHERE rzh04 = g_rzh[l_ac].rzh01 AND rzhacti = 'Y'
               IF l_n2 > 0 THEN
                  CALL cl_err('','axm1178',0)
                  LET g_rzh[l_ac].rzhacti = g_rzh_t.rzhacti
                  DISPLAY BY NAME g_rzh[l_ac].rzhacti
                  NEXT FIELD rzhacti
               END IF
            END IF
                     
         BEFORE DELETE                              #是否取消單身
            IF g_rzh_t.rzh01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
     
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
      
               IF g_azw.azw04='2' THEN
                  IF g_rzh[l_ac].rzh05<>0 THEN 
                     CALL cl_err("",'abx-048',1)
                     CANCEL DELETE
                  END IF
               END IF
 
               DELETE FROM rzh_file WHERE rzh01 = g_rzh_t.rzh01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rzh_file",g_rzh_t.rzh01,"",SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF

               IF g_azw.azw04='2' THEN 
                  IF g_rzh_t.rzh04 IS NOT NULL THEN
                     UPDATE rzh_file SET rzh05=rzh05-1 WHERE rzh01=g_rzh_t.rzh04
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","rzh_file",g_rzh_t.rzh04,"",SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
                  FOR i=1 TO g_rec_b                                                                                               
                     IF g_rzh[l_ac].rzh04=g_rzh[i].rzh01 THEN                                                                    
                        LET g_rzh[i].rzh05=g_rzh[i].rzh05-1                                                                      
                     END IF                                                                                                      
                  END FOR    
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i053_bcl
               COMMIT WORK
            END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rzh[l_ac].* = g_rzh_t.*
               CLOSE i053_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF

            IF g_rzh[l_ac].rzh02<>g_rzh_t.rzh02 OR g_rzh[l_ac].rzh03<>g_rzh_t.rzh03 
               OR g_rzh[l_ac].rzh04<>g_rzh_t.rzh04 OR g_rzh[l_ac].rzh05<>g_rzh_t.rzh05
               OR g_rzh[l_ac].rzh06<>g_rzh_t.rzh06 OR g_rzh[l_ac].rzhacti<>g_rzh_t.rzhacti THEN  
               SELECT rzh04 INTO l_rzh04 FROM rzh_file WHERE rzh01=g_rzh[l_ac].rzh01
               IF g_rzh[l_ac].rzh02<>g_rzh_t.rzh02 THEN
                  SELECT COUNT(*) INTO l_n FROM rzh_file WHERE rzh04=g_rzh[l_ac].rzh01
               END IF
            END IF

           #FUN-D30093--add--str---
            IF g_rzh[l_ac].rzh02<>g_rzh_t.rzh02 THEN
               UPDATE rzj_file SET rzj04 = g_rzh[l_ac].rzh02
                WHERE rzj01 IN (SELECT DISTINCT rzi01 FROM rzi_file WHERE rzi09 = '2')
                  AND rzj03 = g_rzh[l_ac].rzh01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzj_file",g_rzh_t.rzh02,"",SQLCA.sqlcode,"","",1)
                  LET g_rzh[l_ac].* = g_rzh_t.*
               END IF
               UPDATE rzi_file SET rzipos = '2'
                WHERE rzi01 IN (SELECT DISTINCT rzj01 FROM rzj_file WHERE rzj03 = g_rzh[l_ac].rzh01)
                  AND rzipos IN ('3','4')
                  AND rzi09 = '2'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzi_file",g_rzh[l_ac].rzh01,"",SQLCA.sqlcode,"","",1)
                  LET g_rzh[l_ac].* = g_rzh_t.*
               END IF
            END IF
           #FUN-D30093--add--end---

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rzh[l_ac].rzh01,-263,1)
               LET g_rzh[l_ac].* = g_rzh_t.*
            ELSE
               UPDATE rzh_file SET
                   rzh01=g_rzh[l_ac].rzh01,rzh02=g_rzh[l_ac].rzh02,
                   rzh03=g_rzh[l_ac].rzh03,rzh04=g_rzh[l_ac].rzh04,   
                   rzh05=g_rzh[l_ac].rzh05,rzh06=g_rzh[l_ac].rzh06,   
                   rzhacti=g_rzh[l_ac].rzhacti                     
                WHERE rzh01 = g_rzh_t.rzh01
 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzh_file",g_rzh_t.rzh01,"",SQLCA.sqlcode,"","",1) 
                  LET g_rzh[l_ac].* = g_rzh_t.*
               ELSE
                  IF g_azw.azw04='2' THEN
                     IF g_rzh_t.rzh04 IS NOT NULL THEN 
                        UPDATE rzh_file SET rzh05=COALESCE(rzh05,0)-1 WHERE rzh01=g_rzh_t.rzh04
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rzh_file",g_rzh_t.rzh01,"",SQLCA.sqlcode,"","",1)
                        END IF
                     END IF
                     IF g_rzh[l_ac].rzh04 IS NOT NULL THEN
                        UPDATE rzh_file SET rzh05=COALESCE(rzh05,0)+1 WHERE rzh01=g_rzh[l_ac].rzh04
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rzh_file",g_rzh[l_ac].rzh01,"",SQLCA.sqlcode,"","",1)
                        END IF
                     END IF
                     FOR i=1 TO g_rec_b                                                                                      
                        IF g_rzh[l_ac].rzh04=g_rzh[i].rzh01 THEN                                                                    
                           LET g_rzh[i].rzh05=g_rzh[i].rzh05+1                                                                      
                        END IF                                
                        IF g_rzh_t.rzh04=g_rzh[i].rzh01 THEN
                           LET g_rzh[i].rzh05=g_rzh[i].rzh05-1
                        END IF                                                                       
                     END FOR        
                  END IF
                  MESSAGE 'UPDATE O.K'
                  CLOSE i053_bcl
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rzh[l_ac].* = g_rzh_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_rzh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i053_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac #FUN-D30033 add
            CLOSE i053_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rzh04)
                 IF g_azw.azw04='2' THEN  
                    CALL cl_init_qry_var()                                                                                 
                    IF NOT cl_null(g_rzh[l_ac].rzh03) THEN          
                       LET g_qryparam.form ="q_rzh04_1"
                       LET g_qryparam.arg1 = g_rzh[l_ac].rzh03
                    ELSE                                            
                       LET g_qryparam.form ="q_rzh04_2"             
                    END IF                                          
                    LET g_qryparam.where = " rzhacti = 'Y' "
                    CALL cl_create_qry() RETURNING g_rzh[l_ac].rzh04                                                        
                    DISPLAY BY NAME g_rzh[l_ac].rzh04                                                                     
                    NEXT FIELD rzh04
                 END IF
           END CASE 
              
        ON ACTION CONTROLN
           CALL i053_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                         #沿用所有欄位
           IF INFIELD(rzh01) AND l_ac > 1 THEN
              LET g_rzh[l_ac].* = g_rzh[l_ac-1].*
              NEXT FIELD rzh01
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
 
        ON ACTION HELP          
           CALL cl_show_help()  
 
   END INPUT
 
   CLOSE i053_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i053_b_askkey()
   CLEAR FORM
   CALL g_rzh.clear()
   CONSTRUCT g_wc2 ON rzh01,rzh02,rzh03,rzh04,rzh05,rzh06,rzhacti 
      FROM s_rzh[1].rzh01,s_rzh[1].rzh02,s_rzh[1].rzh03,s_rzh[1].rzh04,s_rzh[1].rzh05,
           s_rzh[1].rzh06,s_rzh[1].rzhacti          

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rzh01)                                                                                                  
               CALL cl_init_qry_var()                                                                                            
               LET g_qryparam.form  = "q_rzh_1"                                                                                  
               LET g_qryparam.state = "c"                                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
               DISPLAY g_qryparam.multiret TO rzh01                                                                              
               NEXT FIELD rzh01                                                                                                  
            WHEN INFIELD(rzh04)
               IF g_azw.azw04='2' THEN      
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_rzh04"
                  LET g_qryparam.state = "c"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rzh04 
                  NEXT FIELD rzh04
               END IF
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
      RETURN
   END IF

   CALL i053_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i053_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2        LIKE type_file.chr1000      
 
   LET g_sql =
        "SELECT rzh01,rzh02,rzh03,rzh04,'',rzh05,rzh06,rzhacti", 
        "  FROM rzh_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"

   PREPARE i053_pb FROM g_sql
   DECLARE rzh_curs CURSOR FOR i053_pb
 
   CALL g_rzh.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH rzh_curs INTO g_rzh[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF g_azw.azw04='2' THEN                               
         CALL i053_get_rzh04_desc(g_rzh[g_cnt].rzh04)       
            RETURNING g_rzh[g_cnt].rzh04_desc            
      END IF                                                
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rzh.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i053_bp(p_ud)
DEFINE p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rzh TO s_rzh.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION CANCEL
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

FUNCTION i053_out()
DEFINE l_cmd  LIKE type_file.chr1000  
          
   IF g_wc2 IS NULL THEN 
      CALL cl_err('','9057',0) RETURN END IF
   LET l_cmd = 'p_query "apci053" "',g_wc2 CLIPPED,'"'
   CALL cl_cmdrun(l_cmd)                                                                                                          
   RETURN
   
END FUNCTION
                                                                                                        
FUNCTION i053_set_entry_b(p_cmd)                                                                                                    
DEFINE p_cmd   LIKE type_file.chr1                       
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("rzh01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                              
FUNCTION i053_set_no_entry_b(p_cmd)                                                                                                 
DEFINE p_cmd   LIKE type_file.chr1                       
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
      CALL cl_set_comp_entry("rzh01",FALSE)                                                                                          
   END IF
                                                                                                                          
   IF (p_cmd = 'a' AND ( NOT g_before_input_done )) OR 
      (p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N') THEN
      CALL cl_set_comp_entry("rzh03",FALSE)
   END IF
                                                                                                                                    
END FUNCTION                                                                                                                        

FUNCTION i053_rzh04_rzh03(p_rzh01,p_rzh03)
DEFINE p_rzh01       LIKE rzh_file.rzh01
DEFINE p_rzh03       LIKE rzh_file.rzh03
DEFINE l_rzh01       LIKE rzh_file.rzh01
DEFINE l_rzh03       LIKE rzh_file.rzh03
DEFINE l_i           SMALLINT
DEFINE l_rzh_rzh03   DYNAMIC ARRAY OF RECORD
                     rzh01 LIKE rzh_file.rzh01
                     END RECORD
DEFINE l_sql         STRING

   LET l_sql = " SELECT rzh01 FROM rzh_file WHERE rzh04 = '",p_rzh01,"' "
   PREPARE sel_rzh01_pre FROM l_sql
   DECLARE sel_rzh01_cs  CURSOR FOR sel_rzh01_pre
   LET l_i = 1
   FOREACH sel_rzh01_cs  INTO l_rzh_rzh03[l_i].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         RETURN
      END IF
      LET l_i = l_i + 1
   END FOREACH

   CALL l_rzh_rzh03.deleteElement(l_i)

   FOR l_i = 1 TO l_rzh_rzh03.getLength()
      LET l_rzh01 = l_rzh_rzh03[l_i].rzh01
      UPDATE rzh_file SET rzh03 = p_rzh03 WHERE rzh01 = l_rzh01
      IF STATUS OR SQLCA.sqlcode THEN
         CALL cl_err('upd',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      LET l_rzh03 = p_rzh03 + 1
      CALL i053_rzh04_rzh03(l_rzh01,l_rzh03)
   END FOR

END FUNCTION

FUNCTION i053_rzh04_rzh06(p_rzh01,p_rzh06)
DEFINE p_rzh01       LIKE rzh_file.rzh01
DEFINE p_rzh06       LIKE rzh_file.rzh06
DEFINE l_rzh01       LIKE rzh_file.rzh01
DEFINE l_rzh06       LIKE rzh_file.rzh06
DEFINE l_i           SMALLINT
DEFINE l_rzh_rzh06   DYNAMIC ARRAY OF RECORD
                     rzh01 LIKE rzh_file.rzh01
                     END RECORD
DEFINE l_sql         STRING

   LET l_sql = " SELECT rzh01 FROM rzh_file WHERE rzh04 = '",p_rzh01,"' "
   PREPARE sel_rzh01_pre1 FROM l_sql
   DECLARE sel_rzh01_cs1  CURSOR FOR sel_rzh01_pre1
   LET l_i = 1
   FOREACH sel_rzh01_cs1  INTO l_rzh_rzh06[l_i].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         RETURN
      END IF
      LET l_i = l_i + 1
   END FOREACH

   CALL l_rzh_rzh06.deleteElement(l_i)

   FOR l_i = 1 TO l_rzh_rzh06.getLength()
      LET l_rzh01 = l_rzh_rzh06[l_i].rzh01
      UPDATE rzh_file SET rzh06 = p_rzh06 WHERE rzh01 = l_rzh01
      IF STATUS OR SQLCA.sqlcode THEN
         CALL cl_err('upd',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      LET l_rzh06 = p_rzh06
      CALL i053_rzh04_rzh06(l_rzh01,l_rzh06)
   END FOR

END FUNCTION
 
FUNCTION i053_get_rzh04_desc(p_rzh04)
DEFINE p_rzh04      LIKE rzh_file.rzh04,
       l_rzh04_desc LIKE rzh_file.rzh02
 
   SELECT rzh02 INTO l_rzh04_desc FROM rzh_file
    WHERE rzh01=p_rzh04
      AND rzhacti='Y'   
   IF SQLCA.sqlcode THEN
      LET l_rzh04_desc = NULL
   END IF
   RETURN l_rzh04_desc
END FUNCTION
#FUN-D20020
