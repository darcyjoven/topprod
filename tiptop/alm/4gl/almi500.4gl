# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi500.4gl
# Descriptions...: 會員管理基礎代碼檔
# Date & Author..: No.FUN-BC0058 11/12/19 By yangxf 
# Modify.........: No.FUN-BC0079 11/12/28 By yuhuabao 當要把代碼資料刪除或無效時，應判斷當會員基本資料中的會員紀念
# Modify.........: No.FUN-C30196 12/05/17 By pauline 將almi506作業中的"等級規則設定"action移除,而原action串出去的開窗請移到主程式的單身
# Modify.........: No.FUN-C60032 12/06/18 By lori 新增lpc05,且g_argv1=8時才顯示
# Modify.........: No.FUN-CB0007 12/11/12 By xumm 將almi506,almi507作業中添加已传POS否逻辑
# Modify.........: No.FUN-D10059 13/01/15 By dongsz 在almi506作業中增加lqq06(序號)欄位
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE 
     g_lpc00        LIKE lpc_file.lpc00,
     g_lpc00_t      LIKE lpc_file.lpc00,
     g_lpc          DYNAMIC ARRAY OF RECORD    
        lpc01       LIKE lpc_file.lpc01,   
        lpc02       LIKE lpc_file.lpc02,   
        lpc03       LIKE lpc_file.lpc03,
        lpc04       LIKE lpc_file.lpc04,
        lpc05       LIKE lpc_file.lpc05,      #FUN-C60032 add
        lpcacti     LIKE lpc_file.lpcacti,    #FUN-CB0007 add ,
        lpcpos      LIKE lpc_file.lpcpos      #FUN-CB0007 add 
                    END RECORD,
     g_lpc_t         RECORD                
        lpc01       LIKE lpc_file.lpc01,   
        lpc02       LIKE lpc_file.lpc02,   
        lpc03       LIKE lpc_file.lpc03,
        lpc04       LIKE lpc_file.lpc04,
        lpc05       LIKE lpc_file.lpc05,      #FUN-C60032 add
        lpcacti     LIKE lpc_file.lpcacti,    #FUN-CB0007 add ,
        lpcpos      LIKE lpc_file.lpcpos      #FUN-CB0007 add
                    END RECORD,
     g_wc,g_sql     LIKE type_file.chr1000,         
     g_rec_b        LIKE type_file.num5,    
     l_ac           LIKE type_file.num5                        
DEFINE g_rec_b2 LIKE type_file.num5      
DEFINE g_lqq_t     RECORD
                   lqq01    LIKE lqq_file.lqq01,
                   lqq06    LIKE lqq_file.lqq06,        #FUN-D10059 add
                   lqq02    LIKE lqq_file.lqq02,
                   lqq03    LIKE lqq_file.lqq03,
                   lqq04    LIKE lqq_file.lqq04,
                   lqq05    LIKE lqq_file.lqq05
                   END RECORD
DEFINE g_lqq       DYNAMIC ARRAY OF RECORD
                      lqq01    LIKE lqq_file.lqq01,
                      lqq06    LIKE lqq_file.lqq06,     #FUN-D10059 add
                      lqq02    LIKE lqq_file.lqq02,
                      lqq03    LIKE lqq_file.lqq03,
                      lqq04    LIKE lqq_file.lqq04,
                      lqq05    LIKE lqq_file.lqq05
                   END RECORD
DEFINE g_action_choice2 STRING                
DEFINE g_lqq01     LIKE lqq_file.lqq01         
DEFINE g_forupd_sql STRING         
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5          
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1      LIKE lpc_file.lpc00
DEFINE l_ac2        LIKE type_file.num5   #FUN-C30196 add
DEFINE g_b_flag     LIKE type_file.chr1   #FUN-C30196 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP    
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1) 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   CASE
      WHEN g_argv1='1'
           LET g_prog='almi501'
      WHEN g_argv1='2'
           LET g_prog='almi502'
      WHEN g_argv1='3'
           LET g_prog='almi503'
      WHEN g_argv1='4'
           LET g_prog='almi504'
      WHEN g_argv1='5'
           LET g_prog='almi505'
      WHEN g_argv1='6'
           LET g_prog='almi506'
      WHEN g_argv1='7'
           LET g_prog='almi507'
      WHEN g_argv1='8'
           LET g_prog='almi508'
      OTHERWISE
           CALL cl_err('','alm1453',1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
   END CASE 

   OPEN WINDOW i500_w WITH FORM "alm/42f/almi500" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    IF g_argv1 <> '3' THEN
       CALL cl_set_comp_visible("lpc03,lpc04",FALSE)
       CALL cl_set_comp_visible("lpc02",TRUE)
    ELSE
       IF g_argv1 = '3' THEN
          CALL cl_set_comp_visible("lpc03,lpc04",TRUE)
          CALL cl_set_comp_visible("lpc02",FALSE)
       END IF 
    END IF 
   #FUN-C30196 add START
    IF g_argv1 <> '6' THEN 
       CALL cl_set_comp_visible("s_lqq",FALSE)
    END IF
   #FUN-C30196 add END

   #FUN-C60032 add begin---
    IF g_argv1 = '8' THEN
       CALL cl_set_comp_visible("lpc05",TRUE)
    ELSE
       CALL cl_set_comp_visible("lpc05",FALSE)
    END IF
   #FUN-C60032 add end-----

    #FUN-CB0007---add--str
    IF g_aza.aza88='Y'AND (g_argv1 = '6' OR g_argv1 = '7') THEN
       CALL cl_set_comp_visible("lpcpos",TRUE)
    ELSE
       CALL cl_set_comp_visible("lpcpos",FALSE)
    END IF
    #FUN-CB0007---add--end
    CALL cl_ui_init()
    IF g_argv1 = '6' THEN
       CALL cl_set_act_visible("upgrade_rule",TRUE)
    ELSE
       CALL cl_set_act_visible("upgrade_rule",FALSE)
    END IF
    LET g_lpc00 = g_argv1
    LET g_wc = " lpc00 = '",g_argv1,"'" 
    CALL i500_b_fill(g_wc)
    DISPLAY g_lpc00 TO lpc00
    CALL i500_menu()
    CLOSE WINDOW i500_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i500_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag = '1' THEN  #FUN-C30196 add
                  CALL i500_b()
               END IF                  #FUN-C30196 add 
               IF g_b_flag = '2' THEN          #FUN-C30196 add
                  CALL i500_degrade_b()        #FUN-C30196 add
               END IF                          #FUN-C30196 add               
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lpc[l_ac].lpc01 IS NOT NULL THEN
                  LET g_doc.column1 = "lpc01"
                  LET g_doc.value1 = g_lpc[l_ac].lpc01
                  CALL cl_doc()
               END IF
            END IF
        #FUN-C30196 mark START
        #WHEN "upgrade_rule"
        #   IF cl_chk_act_auth() AND l_ac != 0 THEN
        #       CALL i500_deg_menu()
        #   END IF
        #FUN-C30196 mark END
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i500_q()
   CALL i500_b_askkey()
END FUNCTION
 
FUNCTION i500_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_lpcpos        LIKE lpc_file.lpcpos,               #FUN-CB0007 add
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1                 #可刪除否

   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lpc01,lpc02,lpc03,lpc04,lpc05,lpcacti,lpcpos",     #FUN-C60032 add lpc05  #FUN-CB0007 add lpcpos         
                      "  FROM lpc_file WHERE lpc00 = ? AND lpc01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i500_bcl CURSOR FROM g_forupd_sql      
 
   INPUT ARRAY g_lpc WITHOUT DEFAULTS FROM s_lpc.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             #FUN-CB0007------add----str
             #已傳POS否處理段
             LET p_cmd='u'
             LET g_before_input_done = FALSE
             CALL i500_set_entry(p_cmd)
             CALL i500_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
             LET g_lpc_t.* = g_lpc[l_ac].*
             IF g_aza.aza88 = 'Y' AND (g_argv1 = '6' OR g_argv1 = '7') THEN
                BEGIN WORK
                OPEN i500_bcl USING g_lpc00,g_lpc_t.lpc01
                IF SQLCA.sqlcode THEN
                   CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                   EXIT INPUT
                   LET l_lock_sw = 'Y'
                ELSE
                   FETCH i500_bcl INTO g_lpc[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('FETCH i500_bcl:',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT lpcpos INTO l_lpcpos
                        FROM lpc_file
                       WHERE lpc00 = g_lpc00
                         AND lpc01 = g_lpc[l_ac].lpc01
                      UPDATE lpc_file SET lpcpos = '4'
                        WHERE lpc00 = g_lpc00
                         AND lpc01 = g_lpc[l_ac].lpc01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","lpc_file",g_lpc_t.lpc01,"",SQLCA.sqlcode,"","",1)
                         RETURN
                      END IF
                      LET g_lpc[l_ac].lpcpos = '4'
                      DISPLAY BY NAME g_lpc[l_ac].lpcpos
                   END IF
                END IF
                COMMIT WORK
             END IF
             #FUN-CB0007------add----str
             BEGIN WORK
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
             CALL i500_set_entry(p_cmd)                                         
             CALL i500_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_lpc_t.* = g_lpc[l_ac].*  
             OPEN i500_bcl USING g_lpc00,g_lpc_t.lpc01
             IF STATUS THEN
                CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i500_bcl INTO g_lpc[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lpc_t.lpc01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i500_set_entry(p_cmd)                                            
          CALL i500_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lpc[l_ac].* TO NULL   
          LET g_lpc[l_ac].lpcacti = 'Y' 
          #FUN-CB0007------add----str      
          LET g_lpc[l_ac].lpcpos = '1'
          LET l_lpcpos = '1'
          #FUN-CB0007------add----end
          IF g_argv1 <> '3' THEN 
             LET g_lpc[l_ac].lpc03 = 0
             LET g_lpc[l_ac].lpc04 = 0  
          ELSE
             IF g_argv1 = '3' THEN 
                LET g_lpc[l_ac].lpc02 = ''
             END IF 
          END IF 
          LET g_lpc[l_ac].lpc05 = 'Y'           #FUN-C60032 add
          LET g_lpc_t.* = g_lpc[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lpc01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i500_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lpc_file(lpc00,lpc01,lpc02,lpc03,lpc04,lpc05,lpcacti,lpcpos)            #FUN-C60032 add lpc05  #FUN-CB0007 add lpcpos
          VALUES(g_lpc00,g_lpc[l_ac].lpc01,g_lpc[l_ac].lpc02,g_lpc[l_ac].lpc03,
                 g_lpc[l_ac].lpc04,g_lpc[l_ac].lpc05,g_lpc[l_ac].lpcacti,g_lpc[l_ac].lpcpos)  #FUN-C60032 add lpc05 #FUN-CB0007 add lpcpos
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","lpc_file",g_lpc[l_ac].lpc01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD lpc01                        #check 編號是否重複
          IF NOT cl_null(g_lpc[l_ac].lpc01) THEN 
             IF g_lpc[l_ac].lpc01 != g_lpc_t.lpc01 OR
                g_lpc_t.lpc01 IS NULL THEN
                SELECT count(*) INTO l_n FROM lpc_file
                 WHERE lpc01 = g_lpc[l_ac].lpc01
                   AND lpc00 = g_lpc00
                IF l_n> 0 THEN
                   CALL cl_err('','-239',0)
                   LET g_lpc[l_ac].lpc01 = g_lpc_t.lpc01
                   NEXT FIELD lpc01
                END IF
              END IF
           END IF
          
       AFTER FIELD lpc03
           IF (NOT cl_null(g_lpc[l_ac].lpc03) AND cl_null(g_lpc_t.lpc03))
              OR (NOT cl_null(g_lpc_t.lpc03) AND g_lpc[l_ac].lpc03 != g_lpc_t.lpc03) THEN
              IF g_lpc[l_ac].lpc03 <0 THEN
                 CALL cl_err('','alm-061',0)
                 LET g_lpc[l_ac].lpc03 = g_lpc_t.lpc03
                 NEXT FIELD lpc03
              ELSE
                 IF NOT cl_null(g_lpc[l_ac].lpc04) THEN
                    IF g_lpc[l_ac].lpc03 >= g_lpc[l_ac].lpc04 THEN
                       CALL cl_err('','alm1454',0)
                       LET g_lpc[l_ac].lpc03=g_lpc_t.lpc03
                       NEXT FIELD lpc03
                    END IF
                 END IF
              END IF
              SELECT COUNT(*) INTO l_n FROM lpc_file
                WHERE lpc01 !=g_lpc[l_ac].lpc01
                  AND lpc00 = g_lpc00
                  AND (lpc03 <= g_lpc[l_ac].lpc03 AND lpc04 >= g_lpc[l_ac].lpc03
                   OR (lpc03 >= g_lpc[l_ac].lpc03 AND lpc03 <= g_lpc[l_ac].lpc04)
                   OR (lpc04 >= g_lpc[l_ac].lpc03 AND lpc04 <= g_lpc[l_ac].lpc04))
              IF l_n>0 THEN
                 CALL cl_err('','alm-185',0)
                 LET g_lpc[l_ac].lpc02=g_lpc_t.lpc03
                 NEXT FIELD lpc03
              END IF
           END IF

       AFTER FIELD lpc04
           IF (NOT cl_null(g_lpc[l_ac].lpc04) AND cl_null(g_lpc_t.lpc04)) 
              OR (NOT cl_null(g_lpc_t.lpc04) AND g_lpc[l_ac].lpc04 != g_lpc_t.lpc04) THEN
              IF g_lpc[l_ac].lpc04 <0 THEN
                 CALL cl_err('','alm-061',0)
                 LET g_lpc[l_ac].lpc04 = g_lpc_t.lpc04
                 NEXT FIELD lpc04
              ELSE
                IF g_lpc[l_ac].lpc04 <= g_lpc[l_ac].lpc03 THEN
                   CALL cl_err('','alm1454',0)
                   LET g_lpc[l_ac].lpc04 = g_lpc_t.lpc04
                   NEXT FIELD lpc04
                END IF
              END IF
              SELECT COUNT(*) INTO l_n FROM lpc_file
              WHERE lpc01 !=g_lpc[l_ac].lpc01
                AND lpc00 = g_lpc00
                AND ((lpc03 <= g_lpc[l_ac].lpc04 AND lpc04 >= g_lpc[l_ac].lpc04)
                 OR (lpc03 >= g_lpc[l_ac].lpc03 AND lpc03 <= g_lpc[l_ac].lpc04)
                 OR (lpc04 >= g_lpc[l_ac].lpc03 AND lpc04 <= g_lpc[l_ac].lpc04))
   
              IF l_n>0 THEN
                 CALL cl_err('','alm-185',0)
                 LET g_lpc[l_ac].lpc04=g_lpc_t.lpc04
                 NEXT FIELD lpc04
              END IF
           END IF

       AFTER FIELD lpcacti
          IF NOT cl_null(g_lpc[l_ac].lpcacti) THEN
             IF g_lpc[l_ac].lpcacti NOT MATCHES '[YN]' THEN 
                LET g_lpc[l_ac].lpcacti = g_lpc_t.lpcacti
                NEXT FIELD lpcacti
             END IF
          END IF
          IF NOT cl_null(g_lpc[l_ac].lpcacti) THEN                                                                                    
             IF g_lpc[l_ac].lpcacti != g_lpc_t.lpcacti THEN                                                                             
                CALL i500_chk_acti()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lpc[l_ac].lpcacti = g_lpc_t.lpcacti                                                                            
                   NEXT FIELD lpcacti                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
          END IF 
       		
       BEFORE DELETE                            #是否取消單身
          IF g_lpc_t.lpc01 IS NOT NULL THEN
             INITIALIZE g_doc.* TO NULL               
             LET g_doc.column1 = "lpc01"               
             LET g_doc.value1 = g_lpc[l_ac].lpc01      
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             #FUN-CB0007------add----str
             IF g_aza.aza88='Y' AND (g_argv1 = '6' OR g_argv1 = '7') THEN
                IF NOT ((l_lpcpos='3' AND g_lpc_t.lpcacti='N') OR (l_lpcpos='1'))  THEN
                   CALL cl_err('','apc-139',0)
                   CANCEL DELETE
                END IF
             END IF
             #FUN-CB0007------add----end
             SELECT count(*) INTO l_n1 FROM lpk_file                                                                             
              WHERE lpk08= g_lpc[l_ac].lpc01                                                                     
             IF l_n1 > 0 THEN                                                                                                    
                CALL cl_err('','alm-268',1) 
                cancel DELETE
             END IF               

#FUN-BC0079 -----add----- begin
            SELECT COUNT(*) INTO l_n1 FROM lpa_file
             WHERE lpa02 = g_lpc[l_ac].lpc01
            IF l_n1 > 0 AND g_lpc00 = '8' THEN
               CALL cl_err('','alm1501',1)
               CANCEL DELETE
            END IF
#FUN-BC0079 -----add----- end

             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
 
             DELETE FROM lpc_file WHERE lpc01 = g_lpc_t.lpc01 
                                    AND lpc00 = g_lpc00
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lpc_file",g_lpc_t.lpc01,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lpc[l_ac].* = g_lpc_t.*
             CLOSE i500_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lpc[l_ac].lpc01,-263,0)
             LET g_lpc[l_ac].* = g_lpc_t.*
          ELSE
             #FUN-CB0007------add----str
             IF g_aza.aza88='Y' AND (g_argv1 = '6' OR g_argv1 = '7') THEN
                IF l_lpcpos <> '1' THEN
                   LET g_lpc[l_ac].lpcpos='2'
                ELSE
                   LET g_lpc[l_ac].lpcpos='1'
                END IF
             END IF
             #FUN-CB0007------add----end
             UPDATE lpc_file SET lpc02=g_lpc[l_ac].lpc02,
                                 lpc03=g_lpc[l_ac].lpc03,
                                 lpc04=g_lpc[l_ac].lpc04,
                                 lpc05=g_lpc[l_ac].lpc05,                 #FUN-C60032 add
                                 lpcacti=g_lpc[l_ac].lpcacti,             #FUN-CB0007 add ,
                                 lpcpos=g_lpc[l_ac].lpcpos                #FUN-CB0007 add
              WHERE lpc01 = g_lpc_t.lpc01
                AND lpc00 = g_lpc00
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lpc_file",g_lpc_t.lpc01,"",SQLCA.sqlcode,"","",1) 
                LET g_lpc[l_ac].* = g_lpc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()     
         #LET l_ac_t = l_ac      #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lpc[l_ac].* = g_lpc_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lpc.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--  
             END IF
             CLOSE i500_bcl   
             ROLLBACK WORK   
             #FUN-CB0007------add----str
             IF p_cmd='u' THEN
                IF g_aza.aza88 = 'Y' AND (g_argv1 = '6' OR g_argv1 = '7') THEN
                   UPDATE lpc_file SET lpcpos = l_lpcpos
                    WHERE lpc00 = g_lpc00
                      AND lpc01 = g_lpc_t.lpc01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","lpc_file",g_lpc_t.lpc01,"",SQLCA.sqlcode,"","",1)
                   END IF
                   LET g_lpc[l_ac].lpcpos = l_lpcpos
                   DISPLAY BY NAME g_lpc[l_ac].lpcpos
                END IF
             END IF 
             #FUN-CB0007------add----end
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D30033 Add 
          CLOSE i500_bcl       
          COMMIT WORK
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lpc01) AND l_ac > 1 THEN
             LET g_lpc[l_ac].* = g_lpc[l_ac-1].*
             NEXT FIELD lpc01
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
 
   CLOSE i500_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i500_chk_acti()
   DEFINE l_n LIKE type_file.num5
   LET g_errno = '' 
   IF g_lpc00 = '1' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk08= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-268'
         RETURN
      END IF
   END IF 
   IF g_lpc00 = '2' THEN  
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk14= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-274'
         RETURN
      END IF
   END IF 
   IF g_lpc00 = '3' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk11= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-271'
         RETURN
      END IF
   END IF
   IF g_lpc00 = '4' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk12= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-272'
         RETURN
      END IF
   END IF
   IF g_lpc00 = '5' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk09= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-269'
         RETURN
      END IF
   END IF
   IF g_lpc00 = '6' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk10= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-270'
         RETURN
      END IF
   END IF
   IF g_lpc00 = '7' THEN
      SELECT count(*) INTO l_n FROM lpk_file
        WHERE lpk13= g_lpc[l_ac].lpc01
      IF l_n > 0 THEN
         LET g_errno = 'alm-273'
         RETURN
      END IF
   END IF
#   IF g_lpc00 = '8' THEN
#      SELECT count(*) INTO l_n FROM lpk_file
#        WHERE lpk= g_lpc[l_ac].lpc01
#      IF l_n > 0 THEN
#         LET g_errno = ''
#         RETURN
#      END IF
#   END IF
#FUN-BC0079 -----add----- begin
    IF g_lpc00 = '8' THEN
       SELECT COUNT(*) INTO l_n FROM lpa_file
        WHERE lpa02 = g_lpc[l_ac].lpc01
       IF l_n > 0 THEN
          LET g_errno = 'alm1501'
          RETURN
       END IF
    END IF
#FUN-BC0079 -----add----- end

END FUNCTION 

FUNCTION i500_b_askkey()
 
   CLEAR FORM
   CALL g_lpc.clear()
   LET l_ac =1
   DISPLAY g_lpc00 TO lpc00
   CONSTRUCT g_wc ON lpc01,lpc02,lpc03,lpc04,lpc05,lpcacti,lpcpos    #FUN-C60032 add lpc05   #FUN-CB0007 add lpcpos
        FROM s_lpc[1].lpc01,s_lpc[1].lpc02,s_lpc[1].lpc03,
             s_lpc[1].lpc04,s_lpc[1].lpc05,s_lpc[1].lpcacti   #FUN-C60032 add lpc05     
             ,s_lpc[1].lpcpos                                 #FUN-CB0007 add             
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 
         
      ON ACTION CONTROLP
          CASE
            WHEN INFIELD(lpc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpc01_1"
                 LET g_qryparam.arg1 = g_lpc00
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lpc01
                 NEXT FIELD lpc01 
          END CASE
   
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
   LET g_wc = " lpc00 = '",g_argv1,"' AND ",g_wc 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i500_b_fill(g_wc)
   DISPLAY g_lpc00 TO lpc00 
END FUNCTION
 
FUNCTION i500_b_fill(p_wc)              
DEFINE
    p_wc           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lpc01,lpc02,lpc03,lpc04,lpc05,lpcacti,lpcpos",              #FUN-C60032 add lpc05     #FUN-CB0007 add lpcpos          
        " FROM lpc_file ",
        " WHERE ", g_wc CLIPPED,        #單身
        " ORDER BY lpc01"
    PREPARE i500_pb FROM g_sql
    DECLARE lpc_curs CURSOR FOR i500_pb
 
    CALL g_lpc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lpc_curs INTO g_lpc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lpc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-C30196 add
   DISPLAY ARRAY g_lpc TO s_lpc.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
        #FUN-C30196 add START
         IF g_argv1 = '6' THEN
            IF NOT cl_null(g_lpc[l_ac].lpc01) THEN
               CALL i500_degrade("G")
            END IF
         END IF
        #FUN-C30196 add END
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET g_b_flag = '1'  #FUN-C30196 add
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add

      ON ACTION help
         LET g_action_choice="help"
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET g_b_flag = '1'  #FUN-C30196 add
         LET l_ac = ARR_CURR()
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add 
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
        #EXIT DISPLAY  #FUN-C30196 mark
         EXIT DIALOG   #FUN-C30196 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        #CONTINUE DISPLAY   #FUN-C30196 mark 
         CONTINUE DIALOG    #FUN-C30196 add
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION related_document  
         LET g_action_choice="related_document"
        #EXIT DISPLAY   #FUN-C30196 mark
         EXIT DIALOG    #FUN-C30196 add

     #FUN-C30196 mark START 
     #ON ACTION upgrade_rule
     #   LET g_action_choice="upgrade_rule"
     #   EXIT DISPLAY 
     #FUN-C30196 mark END

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
        #EXIT DISPLAY   #FUN-C30196 mark
         EXIT DIALOG    #FUN-C30196 add
 
 
      AFTER DISPLAY
        #CONTINUE DISPLAY   #FUN-C30196 mark
         CONTINUE DIALOG    #FUN-C30196 add
 
   END DISPLAY

  #FUN-C30196 add START
   DISPLAY ARRAY g_lqq TO s_lqq.*

      BEFORE ROW
        LET l_ac2 = ARR_CURR()
        CALL cl_show_fld_cont()

      ON ACTION detail
         LET g_action_choice ="detail"
         LET g_b_flag = '2'  #FUN-C30196 add
         LET l_ac2 = 1
         EXIT DIALOG 

      ON ACTION help
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET INT_FLAG=FALSE
         LET g_action_choice2="exit"
         EXIT DIALOG 


      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice2="exit"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION accept
         LET l_ac2 = ARR_CURR()
         LET g_action_choice ="detail"
         LET g_b_flag = '2'  #FUN-C30196 add 
         EXIT DIALOG 

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG    #FUN-C30196 add

      AFTER DISPLAY
        CONTINUE DIALOG 

   END DISPLAY
   END DIALOG
  #FUN-C30196 add END
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i500_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lpc01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i500_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lpc01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                       

FUNCTION i500_deg_menu()
   OPEN WINDOW almi500_a_w  WITH FORM "alm/42f/almi500_a"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   WHILE TRUE
     CALL i500_degrade("G")
     CASE g_action_choice2
        WHEN "detail"
          CALL i500_degrade_b()
        WHEN "exit"
          EXIT WHILE
      END CASE
  END WHILE
  CLOSE WINDOW almi500_a_w
END FUNCTION


FUNCTION i500_degrade(p_ud)
DEFINE l_sql          STRING
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_curs_index   LIKE type_file.num10
DEFINE l_row_count    LIKE type_file.num10
DEFINE l_ac2          LIKE type_file.num10
DEFINE   p_ud   LIKE type_file.chr1
   LET g_action_choice2 = ""
   LET g_lqq01 = g_lpc[l_ac].lpc01

  #CALL cl_ui_locale('almi500_a')  #FUN-C30196 mark

   LET l_sql = "SELECT lqq01, lqq06, lqq02, lqq03, lqq04, lqq05 FROM lqq_file ",     #FUN-D10059 add lqq06
               " WHERE lqq01 = '",g_lqq01,"'"
   PREPARE i500_a_pre FROM l_sql

   DECLARE i500_a_cl CURSOR FOR i500_a_pre

   CALL g_lqq.clear()
   LET l_cnt = 1

   FOREACH i500_a_cl INTO g_lqq[l_cnt].*
      IF STATUS THEN
        CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH
      END IF
      LET l_cnt = l_cnt+1
   END FOREACH
   CALL g_lqq.deleteElement(l_cnt)
   LET g_rec_b2 = l_cnt-1

  #FUN-C30196 mark START 
  #CALL cl_set_act_visible("accept,cancel",FALSE)

  #IF p_ud <> "G" OR g_action_choice2 = "detail" THEN
  #   RETURN
  #END IF

  #DISPLAY ARRAY g_lqq TO s_lqq.*
  #   BEFORE DISPLAY
  #       CALL cl_navigator_setting(l_curs_index, l_row_count)
  #   BEFORE ROW
  #     LET l_ac2 = ARR_CURR()
  #     CALL cl_show_fld_cont()

  #   ON ACTION detail
  #      LET g_action_choice2="detail"
  #      LET l_ac2 = 1
  #      EXIT DISPLAY

  #   ON ACTION help
  #      CALL cl_show_help()

  #   ON ACTION locale
  #      CALL cl_dynamic_locale()
  #      CALL cl_show_fld_cont()

  #   ON ACTION exit
  #      LET INT_FLAG=FALSE
  #      LET g_action_choice2="exit"
  #      EXIT DISPLAY


  #   ON ACTION cancel
  #      LET INT_FLAG=FALSE
  #      LET g_action_choice2="exit"
  #      EXIT DISPLAY

  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE DISPLAY

  #   ON ACTION about
  #      CALL cl_about()

  #   ON ACTION controlg
  #      CALL cl_cmdask()

  #   ON ACTION accept
  #      LET l_ac2 = ARR_CURR()
  #      LET g_action_choice2="detail"
  #      EXIT DISPLAY

  #   AFTER DISPLAY
  #     CONTINUE DISPLAY

  #END DISPLAY
  #CALL cl_set_act_visible("accept,cancel", TRUE)
  #FUN-C30196 mark END  
   CALL i500_b2_refresh()   #FUN-C30196 add

END FUNCTION

FUNCTION i500_degrade_b()
DEFINE l_forupd_sql STRING
DEFINE i           LIKE type_file.num5
DEFINE l_n2        LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_lock_sw   LIKE type_file.chr1
DEFINE l_cnt2      LIKE type_file.num5
DEFINE l_lqq01     LIKE lqq_file.lqq01
DEFINE l_allow_insert  LIKE type_file.chr1                #可新增否
DEFINE l_allow_delete  LIKE type_file.chr1                #可刪除否
DEFINE str        STRING
DEFINE l_n         LIKE type_file.num5        #FUN-D10059 add

   IF s_shut(0) THEN RETURN END IF

   LET g_action_choice = ' '  #FUN-C30196 add
   IF g_argv1 <> '6' THEN RETURN END IF   #FUN-C30196 add 
 
   CALL cl_opmsg('b')
   LET l_forupd_sql="SELECT lqq01, lqq06, lqq02, lqq03, lqq04, lqq05 FROM lqq_file",   #FUN-D10059 add lqq06
                    " WHERE lqq01=? AND lqq02=? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE i500_deg_bcl CURSOR FROM l_forupd_sql
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   INPUT ARRAY g_lqq WITHOUT DEFAULTS FROM s_lqq.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

     BEFORE INPUT
       IF g_rec_b2 !=0 THEN
         CALL fgl_set_arr_curr(i)
       END IF
       CALL cl_set_comp_entry("lqq01",FALSE)    #FUN-C30196 add

     BEFORE ROW
       LET i=ARR_CURR()
       LET l_lock_sw = 'N'
       LET l_lqq01 = g_lqq01
       IF g_rec_b2 >= i THEN
          BEGIN WORK
          LET g_lqq_t.* = g_lqq[i].*
          OPEN i500_deg_bcl USING g_lqq_t.lqq01,g_lqq_t.lqq02
          IF STATUS THEN
             CALL cl_err("OPEN i500_deg_bcl:",STATUS,1)
             LET l_lock_sw = 'Y'
          ELSE
             FETCH i500_deg_bcl INTO g_lqq[i].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_lqq_t.lqq01,SQLCA.sqlcode,1)
                LET l_lock_sw = 'Y'
             END IF
          END IF
          CALL cl_show_fld_cont()
        END IF

     BEFORE INSERT
        LET l_n2 = ARR_COUNT()
        INITIALIZE g_lqq[i].* TO NULL
        LET g_lqq_t.* = g_lqq[i].*
        CALL cl_show_fld_cont()
        LET g_lqq[i].lqq01 = l_lqq01
        NEXT FIELD lqq01

     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i500_deg_bcl
           CANCEL INSERT
        END IF
        INSERT INTO lqq_file(lqq01, lqq02, lqq03, lqq04, lqq05, lqq06)       #FUN-D10059 add lqq06
        VALUES (g_lqq[i].lqq01, g_lqq[i].lqq02, g_lqq[i].lqq03, g_lqq[i].lqq04,g_lqq[i].lqq05,g_lqq[i].lqq06)   #FUN-D10059 add g_lqq[i].lqq06
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lqq_file",g_lqq[i].lqq01, g_lqq[i].lqq02,SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b2+1
        END IF


     AFTER FIELD lqq01
        IF g_lqq[i].lqq01 != l_lqq01 THEN
          CALL cl_err('','alm1021',0)
        NEXT FIELD lqq01
        END IF

    #FUN-D10059--add--str---
     BEFORE FIELD lqq06
        IF g_lqq[i].lqq06 IS NULL THEN
           SELECT MAX(lqq06) + 1 INTO g_lqq[i].lqq06 FROM lqq_file 
            WHERE lqq01 = g_lqq[i].lqq01
            IF g_lqq[i].lqq06 IS NULL THEN
            LET g_lqq[i].lqq06 = 1
            END IF
        END IF

     AFTER FIELD lqq06
        IF NOT  cl_null(g_lqq[i].lqq06) THEN
           LET l_n = 0
           IF g_lqq[i].lqq06 <= 0 THEN
              CALL cl_err('','alm-468',0)
              LET g_lqq[i].lqq06 = g_lqq_t.lqq06
              NEXT FIELD lqq06
           END IF
           IF cl_null(g_lqq[i].lqq01) THEN
              CALL cl_err('', 'alm-055', 0)
              NEXT FIELD lqq01
           ELSE
              IF g_lqq[i].lqq06 != g_lqq_t.lqq06 OR g_lqq_t.lqq06 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM lqq_file WHERE lqq01 = g_lqq[i].lqq01
                                                          AND lqq06 = g_lqq[i].lqq06
                 IF l_n > 0 THEN
                 CALL cl_err('','alm2007',0)
                 LET g_lqq[i].lqq06 = g_lqq_t.lqq06
                 NEXT FIELD lqq06
                 END IF
              END IF
           END IF
        END IF
    #FUN-D10059--add--end--- 

     AFTER FIELD lqq02
         IF NOT  cl_null(g_lqq[i].lqq02) THEN
            IF cl_null(g_lqq[i].lqq01) THEN
              CALL cl_err('', 'alm-055', 0)
              NEXT FIELD lqq01
            ELSE
              IF g_lqq[i].lqq02 != g_lqq_t.lqq02 OR g_lqq_t.lqq02 IS NULL OR
                 g_lqq[i].lqq01 != g_lqq_t.lqq01 OR g_lqq_t.lqq01 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM lqq_file WHERE lqq01 = g_lqq[i].lqq01 AND lqq02 = g_lqq[i].lqq02
                 IF l_cnt > 0 THEN
                 CALL cl_err('','alm1019',0)
                 LET g_lqq[i].lqq02 = g_lqq_t.lqq02
                 NEXT FIELD lqq02
                 END IF
              END IF
              IF NOT cl_null(g_lqq[i].lqq05) AND NOT cl_null(g_lqq[i].lqq04) THEN
                 SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (g_lqq[i].lqq04 BETWEEN lqq04 AND lqq05)
                            OR (g_lqq[i].lqq05 BETWEEN lqq04 AND lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
                 IF l_cnt2 >0  THEN
                      CALL cl_err('','alm1018',0)
                      NEXT FIELD lqq04
                 END IF
              END IF
            END IF
         END IF

      AFTER FIELD lqq04
         LET l_cnt2 = 0
         IF NOT cl_null(g_lqq[i].lqq04) THEN
            IF g_lqq[i].lqq04 < 0 THEN
               CALL cl_err('','alm-061',0)
               NEXT FIELD lqq04
            END IF
            LET l_cnt2 = 0

            SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                   WHERE lqq02 = g_lqq[i].lqq02
                   AND ( g_lqq[i].lqq04 BETWEEN lqq04 AND lqq05)
                   AND lqq01 NOT IN(g_lqq[i].lqq01)
            IF l_cnt2 >0  THEN
                CALL cl_err('','alm1018',0)
                NEXT FIELD lqq04
            END IF
            IF NOT cl_null(g_lqq[i].lqq05) THEN
               IF g_lqq[i].lqq04 > g_lqq[i].lqq05 THEN
                  CALL cl_err('','alm-161',0)
                  NEXT FIELD lqq04
               END IF
               SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (g_lqq[i].lqq04 BETWEEN lqq04 AND lqq05)
                            OR (g_lqq[i].lqq05 BETWEEN lqq04 AND lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
               IF l_cnt2 >0  THEN
                   CALL cl_err('','alm1018',0)
                   NEXT FIELD lqq04
               END IF
               LET l_cnt2 = 0
               SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (lqq04 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                            OR (lqq05 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
              IF l_cnt2 >0  THEN
                 CALL cl_err('','alm1018',0)
                 NEXT FIELD lqq04
              END IF
            END IF
         END IF

       AFTER FIELD lqq05
         LET l_cnt2 = 0
         IF NOT cl_null(g_lqq[i].lqq05) THEN
            IF g_lqq[i].lqq05 < 0 THEN
               CALL cl_err('','alm-061',0)
               NEXT FIELD lqq05
            END IF
            LET l_cnt2 = 0
            SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                   WHERE lqq02 = g_lqq[i].lqq02
                   AND ( g_lqq[i].lqq05 BETWEEN lqq04 AND lqq05)
                   AND lqq01 NOT IN(g_lqq[i].lqq01)
            IF l_cnt2 >0  THEN
                CALL cl_err('','alm1018',0)
                NEXT FIELD lqq05
            END IF
            IF NOT cl_null(g_lqq[i].lqq04) THEN
              IF g_lqq[i].lqq05 < g_lqq[i].lqq04 THEN
                 CALL cl_err('','alm1020',0)
                 NEXT FIELD lqq05
              END IF
              LET l_cnt2 = 0
              SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (g_lqq[i].lqq04 BETWEEN lqq04 AND lqq05)
                            OR (g_lqq[i].lqq05 BETWEEN lqq04 AND lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
              IF l_cnt2 >0  THEN
                 CALL cl_err('','alm1018',0)
                 NEXT FIELD lqq05
              END IF
              LET l_cnt2 = 0
              SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (lqq04 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                            OR (lqq05 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
              IF l_cnt2 >0  THEN
                 CALL cl_err('','alm1018',0)
                 NEXT FIELD lqq04
              END IF
            END IF
         END IF

       BEFORE DELETE
         IF g_rec_b2 >= i THEN
            IF NOT cl_delete() THEN
                 CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
            END IF
            DELETE FROM lqq_file WHERE lqq01 =  g_lqq[i].lqq01 AND lqq02 = g_lqq[i].lqq02
            IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lqq_file",g_lqq_t.lqq01,g_lqq_t.lqq02,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
            END IF
            LET g_rec_b2=g_rec_b2-1
            COMMIT WORK
         END IF

       AFTER ROW
         LET i = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i500_deg_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i500_deg_bcl
         COMMIT WORK

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lqq[i].* = g_lqq_t.*
             CLOSE i500_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF NOT cl_null(g_lqq[i].lqq04) THEN
               IF g_lqq[i].lqq05 < g_lqq[i].lqq04 THEN
                  CALL cl_err('','alm1020',0)
                  NEXT FIELD lqq05
               END IF
               LET l_cnt2 = 0
               SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                      WHERE lqq02 = g_lqq[i].lqq02
                      AND ( (g_lqq[i].lqq04 BETWEEN lqq04 AND lqq05)
                            OR (g_lqq[i].lqq05 BETWEEN lqq04 AND lqq05)
                          )
                      AND lqq01 NOT IN(g_lqq[i].lqq01)
               IF l_cnt2 >0  THEN
                  CALL cl_err('','alm1018',0)
                  NEXT FIELD lqq05
               END IF
               LET l_cnt2 = 0
               SELECT COUNT(*) INTO l_cnt2 FROM lqq_file
                       WHERE lqq02 = g_lqq[i].lqq02
                       AND ( (lqq04 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                             OR (lqq05 BETWEEN g_lqq[i].lqq04 AND g_lqq[i].lqq05)
                           )
                       AND lqq01 NOT IN(g_lqq[i].lqq01)
               IF l_cnt2 >0  THEN
                  CALL cl_err('','alm1018',0)
                  NEXT FIELD lqq04
               END IF
          END IF
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lpc[l_ac].lpc01,-263,0)
             LET g_lqq[i].* = g_lqq_t.*
          ELSE
              UPDATE lqq_file SET lqq02=g_lqq[i].lqq02,
                                  lqq03=g_lqq[i].lqq03,
                                  lqq04=g_lqq[i].lqq04,
                                  lqq05=g_lqq[i].lqq05,
                                  lqq06=g_lqq[i].lqq06                 #FUN-D10059 add
              WHERE lqq01 = g_lqq_t.lqq01
                    AND lqq02=  g_lqq_t.lqq02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lqq_file",g_lqq_t.lqq01,"",SQLCA.sqlcode,"","",1)
                LET g_lqq[i].* = g_lqq_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

       ON ACTION CONTROLG
           CALL cl_cmdask()

       ON IDLE g_idle_seconds
           CALL cl_on_idle()

       ON ACTION about
           CALL cl_about()

       ON ACTION help
           CALL cl_show_help()

       ON ACTION cancel
           LET INT_FLAG=FALSE
           EXIT INPUT

   END INPUT
   CLOSE i500_deg_bcl

   COMMIT WORK
END FUNCTION

#FUN-BC0058
#FUN-C30196 add START
FUNCTION i500_b2_refresh()

  DISPLAY ARRAY g_lqq TO s_lqq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
#FUN-C30196 add END
