# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: axri120.4gl
# Descriptions...: 電子發票簿主檔維護 
# Date & Author..: NO.FUN-C40076 12/04/26 By pauline 
# Modify.........: No.FUN-C50021 12/05/04 By pauline 批次新增發票/刪除發票後,重新產生清單
# Modify.........: No.FUN-C50022 12/05/09 By pauline 寫入oom_file時一併將oom11,oom12產生寫入
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds


GLOBALS "../../config/top.global"

DEFINE g_oon01         LIKE oon_file.oon01
DEFINE g_oon02         LIKE oon_file.oon02
DEFINE g_oon03         LIKE oon_file.oon03
DEFINE g_oon01_t       LIKE oon_file.oon01
DEFINE g_oon02_t       LIKE oon_file.oon02
DEFINE g_oon03_t       LIKE oon_file.oon03
DEFINE g_oon           DYNAMIC ARRAY OF RECORD
            oon04      LIKE oon_file.oon04,
            oon05      LIKE oon_file.oon05,
            qty        LIKE type_file.num5,
            oon06      LIKE oon_file.oon06,
            oon07      LIKE oon_file.oon07,
            oon08      LIKE oon_file.oon08
                       END RECORD 
DEFINE g_oon_t         RECORD
            oon04      LIKE oon_file.oon04,
            oon05      LIKE oon_file.oon05,
            qty        LIKE type_file.num5,
            oon06      LIKE oon_file.oon06,
            oon07      LIKE oon_file.oon07,
            oon08      LIKE oon_file.oon08
                       END RECORD
DEFINE g_tot           LIKE type_file.num20
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5 
DEFINE g_curs_index    LIKE type_file.num10         
DEFINE g_row_count     LIKE type_file.num10         
DEFINE g_jump          LIKE type_file.num10         
DEFINE mi_no_ask       LIKE type_file.num5          
DEFINE g_forupd_sql    STRING 
DEFINE g_wc            STRING
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num5
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_rec           LIKE type_file.num10
MAIN
DEFINE p_row,p_col      LIKE type_file.num5     
    OPTIONS                                          #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
      RETURNING g_time    #No.FUN-6A0095

   LET g_oon01 =NULL                      #清除鍵值
   LET g_oon02 =NULL                      #清除鍵值
   LET g_oon03 =NULL                      #清除鍵值
   LET g_oon01_t = NULL
   LET g_oon02_t = NULL
   LET g_oon03_t = NULL
   LET p_row = 3 LET p_col = 10

   OPEN WINDOW i120_w AT p_row,p_col              #顯示畫面
     WITH FORM "axr/42f/axri120"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("axri120")

   CALL cl_ui_init()

   CALL i120_menu()
   CLOSE WINDOW i120_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time    



END MAIN

FUNCTION i120_menu()

   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL i120_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL i120_q()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL i120_b()
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
                  CALL cl_export_to_excel
                  (ui.Interface.getRootNode(),base.TypeInfo.create(g_oon),'','')
               END IF

           WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_oon01 IS NOT NULL THEN
                  LET g_doc.column1 = "oon01"
                  LET g_doc.column2 = "oon02"
                  LET g_doc.column3 = "oon03"
                  LET g_doc.value1 = g_oon01
                  LET g_doc.value2 = g_oon02
                  LET g_doc.value3 = g_oon03
                  CALL cl_doc()
               END IF
            END IF

           WHEN "pro_invo"   #批次產生發票簿
              IF cl_chk_act_auth() THEN
                 CALL i120_pro_invo() 
                 CALL i120_bf(g_wc)
              END IF

           WHEN "del_invo"   #批次刪除發票簿
              IF cl_chk_act_auth() THEN
                 CALL i120_del_invo() 
                 CALL i120_bf(g_wc)
              END IF

      END CASE
   END WHILE

END FUNCTION

FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oon TO s_oom.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()               

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY                   

      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                  


      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                   


      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                 


      ON ACTION last
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                  

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

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
         LET INT_FLAG=FALSE             #MOD-570244     mars
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

      ON ACTION controls                         
         CALL cl_set_head_visible("","AUTO")         

      ON ACTION related_document                
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION pro_invo
         LET g_action_choice="pro_invo"
         EXIT DISPLAY

      ON ACTION del_invo
         LET g_action_choice="del_invo"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#Add  輸入
FUNCTION i120_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_oon.clear()
   INITIALIZE g_oon01 LIKE oon_file.oon01
   INITIALIZE g_oon02 LIKE oon_file.oon02
   INITIALIZE g_oon03 LIKE oon_file.oon03
   LET g_oon01_t = NULL
   LET g_oon02_t = NULL
   LET g_oon03_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
       CALL i120_i("a")                #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       CALL g_oon.clear()
       LET g_rec_b = 0

       CALL i120_b()                      #輸入單身
       LET g_oon01_t = g_oon01            #保留舊值
       LET g_oon02_t = g_oon02            #保留舊值
       LET g_oon03_t = g_oon03           #保留舊值
       EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i120_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改 
    l_n             LIKE type_file.num5,     
    l_oon01         LIKE oon_file.oon01,
    l_oon02         LIKE oon_file.oon02,
    l_oon03         LIKE oon_file.oon03,
    l_cnt           LIKE type_file.num5      
    CALL cl_set_head_visible("","YES")       

    INPUT g_oon01,g_oon02,g_oon03 WITHOUT DEFAULTS FROM oon01,oon02,oon03

        AFTER FIELD oon02
           IF NOT cl_null(g_oon02) THEN
              IF g_oon02 < 1 OR g_oon02 > 12 THEN NEXT FIELD oon02 END IF  
              LET g_oon03 = g_oon02 + 1
              DISPLAY g_oon03 TO oon03
              SELECT COUNT(*) INTO l_n FROM oon_file    #判斷發票年月是否重覆
                 WHERE oon01=g_oon01                    
                  AND  oon02=g_oon02                    #例 2001/1-1 與2001/1-2
              IF  l_n >0 THEN                           #同時存在是錯的
                  CALL cl_err(g_oon01,-239,0)
                  NEXT FIELD oon02
              END IF
              SELECT COUNT(*) INTO l_n FROM oon_file    #判斷發票年月是否重覆
               WHERE oon01=g_oon01                      
                 AND oon03=g_oon02                     #例 2001/1-2 與2001/2-3
              IF  l_n >0 THEN                           #同時存在是錯的
                  CALL cl_err(g_oon01,-239,0)
                  NEXT FIELD oon02
              END IF
           END IF

        AFTER FIELD oon03
           IF NOT cl_null(g_oon02) THEN
              IF g_oon03 < 1 OR g_oon03 > 12 THEN NEXT FIELD oon03 END IF 
              IF g_oon03 < g_oon02 THEN NEXT FIELD oon02 END IF
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM amb_file  #發票字軌與amdi010定義的不符!
               WHERE amb01=g_oon01
                AND  amb02=g_oon02
                AND  amb07=g_oon03
               IF l_cnt =0 THEN
                  CALL cl_err(g_oon03,'axr-019',0)
                  NEXT FIELD  oon03
               END IF
              SELECT UNIQUE oon01,oon02,oon021
                FROM oon_file WHERE oon01=g_oon01 AND oon02=g_oon02
                                AND oon021=g_oon03
              IF NOT STATUS THEN
                 CALL cl_err(g_oon01,-239,0)
                 LET g_oon01=g_oon01_t
                 LET g_oon02=g_oon02_t
                 LET g_oon01=g_oon03_t
                 NEXT FIELD oon01
              END IF
           END IF

        AFTER INPUT    
          IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 


       ON ACTION CONTROLR
           CALL cl_show_req_fields()

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

#單身
FUNCTION i120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,      #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        
    p_cmd           LIKE type_file.chr1,      #處理狀態          
    l_cnt           LIKE type_file.num5,      
    l_oom02         LIKE oom_file.oom02,
    l_allow_insert  LIKE type_file.num5,      #可新增否          
    l_allow_delete  LIKE type_file.num5       #可刪除否          
DEFINE l_i          LIKE type_file.num5          
DEFINE l_j          LIKE type_file.num5          
DEFINE l_amb03      LIKE amb_file.amb03       
DEFINE l_oompos     LIKE oom_file.oompos      
DEFINE l_yy         LIKE oom_file.oom02       

   LET g_action_choice = ""
   IF cl_null(g_oon01) THEN RETURN END IF
   IF cl_null(g_oon02) THEN RETURN END IF

   CALL cl_opmsg('b')

   DECLARE amb03_cs CURSOR FOR
      SELECT amb03 FROM amb_file
       WHERE amb01 = g_oon01
         AND amb02 <= g_oon02  
         AND amb07 >= g_oon03  

   LET g_forupd_sql = " SELECT oon04,oon05,'',oon06,oon07,oon08",    
                      "  FROM oon_file  ",
                      " WHERE oon01 =? ",
                      "   AND oon02 =? ",
                      "   AND oon03 =? ",
                      "   AND oon04 =? ",
                      "   AND oon05 =? "
   DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   IF g_rec_b=0 THEN CALL g_oon.clear() END IF

   INPUT ARRAY g_oon WITHOUT DEFAULTS FROM s_oom.*
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
             LET g_oon_t.* = g_oon[l_ac].*  #BACKUP
             LET p_cmd='u'
             BEGIN WORK
             OPEN i120_bcl USING g_oon01,g_oon02,g_oon03,g_oon_t.oon04,g_oon_t.oon05    #No.FUN-B90130
             IF STATUS THEN
                CALL cl_err("OPEN i120_bcl:", STATUS, 0)
                CLOSE i120_bcl
                ROLLBACK WORK
                RETURN
             END IF
             FETCH i120_bcl INTO g_oon[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err('',SQLCA.sqlcode,0)
                LET l_lock_sw = "Y"
             END IF 
             CALL i120_qty(g_oon[l_ac].oon04,g_oon[l_ac].oon05) RETURNING g_oon[l_ac].qty
             DISPLAY BY NAME g_oon[l_ac].qty
             CALL cl_show_fld_cont()     
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_oon[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_oon[l_ac].* TO s_oom.*
            CALL g_oon.deleteElement(l_ac)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO oon_file(oon01,oon02,oon03,oon04,
                              oon05,oon06,oon07,oon08,
                              oonuser,oongrup,oonmodu,oondate,oonoriu,oonorig)  
                 VALUES(g_oon01,g_oon02,g_oon03,
                        g_oon[l_ac].oon04,g_oon[l_ac].oon05,
                        g_oon[l_ac].oon06,g_oon[l_ac].oon07,'N',
                        g_user,g_grup,' ',g_today, g_user, g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oon_file",g_oon01,g_oon[l_ac].oon04,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            CALL i120_tot()
            COMMIT WORK
         END IF


      BEFORE INSERT
         LET l_n = ARR_COUNT()
         BEGIN WORK                
         LET p_cmd='a'
         INITIALIZE g_oon[l_ac].* TO NULL     
         LET g_oon[l_ac].oon08 = 'N'
         LET g_oon_t.* = g_oon[l_ac].*         #新輸入資料
         LET g_oon[l_ac].oon04=' '
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM ama_file
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt = 1 THEN
            SELECT ama02 INTO g_oon[l_ac].oon06
              FROM ama_file
         END IF
         CALL cl_show_fld_cont()    
         NEXT FIELD oon04

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_oon_t.oon04) AND NOT cl_null(g_oon_t.oon05) THEN
             IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             LET l_cnt = 0
             IF g_oon[l_ac].oon08 = 'Y' THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM oom_file
                   WHERE oom01 = g_oon01 AND oom02 = g_oon02
                     AND oom021 = g_oon03 
                     AND oom03 = '1' AND oom04 = '5'
                     AND RTRIM(oom09) IS NOT NULL
                     AND ( oom07 = g_oon_t.oon04  OR oom08 = g_oon_t.oon05 OR
                           (oom07 > g_oon_t.oon04  AND oom07 < g_oon_t.oon05) )
                IF l_n > 0 THEN
                   LET g_success = 'N'
                   CALL cl_err('','axr-813',0)
                   CANCEL DELETE
                   NEXT FIELD CURRENT 
                END IF
                LET l_n = 0  
                SELECT COUNT(*) INTO l_n FROM oom_file
                   WHERE oom01 = g_oon01 AND oom02 = g_oon02
                     AND oom021 = g_oon03 
                     AND oom03 = '1' AND oom04 = '5'
                     AND oompos <> '1' 
                     AND ( oom07 = g_oon_t.oon04  OR oom08 = g_oon_t.oon05 OR
                           (oom07 > g_oon_t.oon04  AND oom07 < g_oon_t.oon05) )
                IF l_n > 0 THEN
                   LET g_success = 'N'
                   CALL cl_err('','axr-817',0)
                   CANCEL DELETE 
                   NEXT FIELD CURRENT 
                END IF
             END IF
             CALL i120_del_oom(g_oon_t.oon04,g_oon_t.oon05)
             IF g_success = 'Y' THEN  
                DELETE FROM oon_file
                    WHERE oon01 = g_oon01
                      AND oon02 = g_oon02
                      AND oon03 = g_oon03
                      AND oon04 = g_oon_t.oon04
                      AND oon05 = g_oon_t.oon05
                IF SQLCA.sqlcode THEN
                    LET l_ac_t = l_ac
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                    COMMIT WORK
                    LET g_rec_b = g_rec_b-1
                    CALL i120_tot()
                END IF
            ELSE
                ROLLBACK WORK
                NEXT FIELD CURRENT
            END IF
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_oon[l_ac].* = g_oon_t.*
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_oon[l_ac].oon04,-263,1)
            LET g_oon[l_ac].* = g_oon_t.*
         ELSE
            UPDATE oon_file SET 
                                oon04=g_oon[l_ac].oon04,
                                oon05=g_oon[l_ac].oon05,
                                oon06=g_oon[l_ac].oon06,
                                oon07=g_oon[l_ac].oon07,
                                oon08=g_oon[l_ac].oon08,
                                oonmodu = g_user,
                                oondate = g_today
                          WHERE oon01=g_oon01
                            AND oon02=g_oon02
                            AND oon03=g_oon03
                            AND oon04=g_oon_t.oon04
                            AND oon05=g_oon_t.oon05
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oon_file",g_oon01,g_oon_t.oon04,SQLCA.sqlcode,"","",1) 
                LET g_oon[l_ac].* = g_oon_t.*
                ROLLBACK WORK
            ELSE
                CALL i120_tot()
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN               
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_oon[l_ac].* = g_oon_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_oon.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE i120_bcl
             ROLLBACK WORK
             EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i120_bcl
         COMMIT WORK

      AFTER FIELD oon04
         IF NOT cl_null(g_oon[l_ac].oon04) THEN
            IF g_oon[l_ac].oon08 = 'Y' AND 
               ( p_cmd = 'u' AND g_oon[l_ac].oon04 <> g_oon_t.oon04) THEN
               CALL cl_err('','axr-812',0) 
               LET g_oon[l_ac].oon04 = g_oon_t.oon04
               NEXT FIELD oon04
            END IF
            IF g_aza.aza26 = '0' THEN 
               IF length(g_oon[l_ac].oon04) <> '10' THEN
                  CALL cl_err('','axr-021',0)
                  NEXT FIELD oon04
               END IF
               FOR l_j = 1 TO 2
                  IF g_oon[l_ac].oon04[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                       CALL cl_err('','axr-017',0)
                       NEXT FIELD oon04
                  END IF
               END FOR
               FOR l_j = 3 TO 10
                   IF g_oon[l_ac].oon04[l_j,l_j] NOT MATCHES '[0-9]' THEN
                      CALL cl_err('','axr-018',0)
                      NEXT FIELD oon04
                   END IF
               END FOR
            END IF
            IF g_aza.aza26 = '0' THEN    
               LET l_amb03 = ' '
               FOREACH amb03_cs INTO l_amb03
                  IF g_oon[l_ac].oon04[1,2] <> l_amb03 THEN
                     CONTINUE FOREACH
                  ELSE
                     EXIT FOREACH
                  END IF
               END FOREACH
               IF g_oon[l_ac].oon04[1,2] <> l_amb03 THEN
                  CALL cl_err('','axr-019',0)
                  NEXT FIELD oon04
               END IF
            END IF   
            IF p_cmd = 'a' OR p_cmd = 'u' AND (g_oon[l_ac].oon04 <> g_oon_t.oon04
                           OR g_oon[l_ac].oon04 <> g_oon_t.oon04
                           OR g_oon[l_ac].oon05 <> g_oon_t.oon04  ) THEN  
               CALL i120_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD oon04
               END IF
            END IF
            IF g_oon02 = g_oon03 THEN
               LET l_yy = g_oon02 -1
               SELECT COUNT(*) INTO l_cnt
                 FROM oon_file
                WHERE oon01 = g_oon01
                  AND oon02 = l_yy
                  AND oon03= oon02
               IF l_cnt > 0 THEN
                  CALL cl_err(g_oon[l_ac].oon07,'alm-953',0)
                  NEXT FIELD oon04
               END IF
            END IF
            CALL i120_inv_repeat(g_oon[l_ac].oon04)   #判斷發票不可重複
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD oon04
            END IF
            DISPLAY BY NAME g_oon[l_ac].oon04
            CALL i120_qty(g_oon[l_ac].oon04,g_oon[l_ac].oon05) RETURNING g_oon[l_ac].qty
            DISPLAY BY NAME g_oon[l_ac].qty
         END IF

         IF cl_null(g_oon[l_ac].oon05) THEN
            LET g_oon[l_ac].oon05 = g_oon[l_ac].oon04
            DISPLAY BY NAME g_oon[l_ac].oon05
         END IF

      AFTER FIELD oon05
         IF NOT cl_null(g_oon[l_ac].oon05) THEN
            IF g_oon[l_ac].oon08 = 'Y' AND 
               ( p_cmd = 'u' AND g_oon[l_ac].oon05 <> g_oon_t.oon05) THEN
               CALL cl_err('','axr-812',0)
               LET g_oon[l_ac].oon05 = g_oon_t.oon05
               NEXT FIELD oon05
            END IF
            IF g_aza.aza26 = '0' THEN 
               IF length(g_oon[l_ac].oon05) <> '10' THEN
                  CALL cl_err('','axr-021',0)
                  NEXT FIELD oon05
               END IF
               FOR l_j = 1 TO 2
                  IF g_oon[l_ac].oon05[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                     CALL cl_err('','axr-017',0)
                     NEXT FIELD oon05
                  END IF
               END FOR
               FOR l_j = 3 TO 10
                   IF g_oon[l_ac].oon05[l_j,l_j] NOT MATCHES '[0-9]' THEN
                      CALL cl_err('','axr-018',0)
                      NEXT FIELD oon05
                   END IF
               END FOR
            END IF
            IF g_aza.aza26 = '0' THEN         
               LET l_amb03 = ' '
               FOREACH amb03_cs INTO l_amb03
                  IF g_oon[l_ac].oon05[1,2] <> l_amb03 THEN
                     CONTINUE FOREACH
                  ELSE
                     EXIT FOREACH
                  END IF
               END FOREACH
               IF g_oon[l_ac].oon05[1,2] <> l_amb03 THEN
                  CALL cl_err('','axr-019',0)
                  NEXT FIELD oon05
               END IF
            END IF   
            IF length(g_oon[l_ac].oon04) <> length(g_oon[l_ac].oon05) THEN
               CALL cl_err ('','axr-020',1)
               NEXT FIELD oon05
            END IF
            IF p_cmd = 'a' OR p_cmd = 'u' AND (
                           g_oon[l_ac].oon04 <> g_oon_t.oon04
                           OR g_oon[l_ac].oon05 <> g_oon_t.oon05  ) THEN   
               CALL i120_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD oon05
               END IF
            END IF
            CALL i120_inv_repeat(g_oon[l_ac].oon05)  #判斷發票不可重複
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD oon05
            END IF
            DISPLAY BY NAME g_oon[l_ac].oon05
            CALL i120_qty(g_oon[l_ac].oon04,g_oon[l_ac].oon05) RETURNING g_oon[l_ac].qty
            DISPLAY BY NAME g_oon[l_ac].qty
         END IF

      BEFORE FIELD oon06
         IF l_ac > 1 THEN
            IF cl_null(g_oon[l_ac].oon06) THEN
               LET g_oon[l_ac].oon06 = g_oon[l_ac-1].oon06
            END IF
         END IF
         DISPLAY BY NAME g_oon[l_ac].oon06

      AFTER FIELD oon06
         IF NOT cl_null(g_oon[l_ac].oon06) THEN
            IF g_oon[l_ac].oon08 = 'Y' AND
               ( p_cmd = 'u' AND g_oon[l_ac].oon06 <> g_oon_t.oon06) THEN
               CALL cl_err('','axr-812',0)
               LET g_oon[l_ac].oon06 = g_oon_t.oon06
               NEXT FIELD oon06
            END IF
            SELECT COUNT(*) INTO l_cnt FROM ama_file
               WHERE ama02 = g_oon[l_ac].oon06
            IF l_cnt = 0 THEN
               CALL cl_err("","mfg9329",0)
               NEXT FIELD oon06
            END IF
            IF g_aza.aza21 = 'Y' AND NOT s_chkban(g_oon[l_ac].oon06) AND g_aza.aza26 <> '2' THEN 
               CALL cl_err("","mfg7015",0)
               NEXT FIELD oon06
            END IF
         ELSE
            IF g_aza.aza94 = 'Y' AND g_aza.aza26 <> '2' THEN  
               CALL cl_err('oom13 is null: ','aap-099',0)
               NEXT FIELD oon06
            END IF
         END IF
   
      AFTER FIELD oon07
         IF NOT cl_null(g_oon[l_ac].oon07) THEN
            IF g_oon[l_ac].oon08 = 'Y' AND
               ( p_cmd = 'u' AND g_oon[l_ac].oon07 <> g_oon_t.oon07) THEN
               CALL cl_err('','axr-812',0)
               LET g_oon[l_ac].oon07 = g_oon_t.oon07
               NEXT FIELD oon07
            END IF
            IF g_oon[l_ac].oon07 <= 0 THEN
               CALL cl_err('','alm-808',0)
               NEXT FIELD oon07
            END IF
         END IF 
   END INPUT

   CALL i120_tot()
END FUNCTION

#檢查是否有發票號碼重複
FUNCTION i120_check()
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_sql     STRING

   LET g_errno = ''
   IF cl_null(g_oon[l_ac].oon04) THEN RETURN END IF
   IF cl_null(g_oon[l_ac].oon05) THEN RETURN END IF

   IF cl_null(g_oon01) OR cl_null(g_oon02) THEN  
      RETURN
   END IF

   IF g_oon[l_ac].oon04[3,10] > g_oon[l_ac].oon05[3,10] THEN
      LET g_errno = 'axr-934'
      RETURN
   END IF

   IF g_oon[l_ac].oon04[1,2] <> g_oon[l_ac].oon05[1,2] THEN
      LET g_errno = 'axr-809'
      RETURN
   END IF

   LET l_cnt = 0

   LET l_sql = " SELECT COUNT(*) FROM oon_file ",
               "  WHERE oon07 <= '",g_oon[l_ac].oon08,"'",
               "    AND oon08 >= '",g_oon[l_ac].oon07,"'",
               "    AND NOT (oon01 = ? ",
               "    AND oon02 = ? ",
               "    AND oon03 = ? ",
               "    AND oon04 = ? ",
               "    AND oon05 = ? )"


   PREPARE i120_check_p1 FROM l_sql
   EXECUTE i120_check_p1 USING g_oon01,g_oon02,g_oon03,g_oon[l_ac].oon04,g_oon[l_ac].oon05 INTO l_cnt
   IF l_cnt > 0 THEN
      LET g_errno = 'axr-307'
      RETURN
   END IF
END FUNCTION

#Query 查詢
FUNCTION i120_q()


    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_oon01 TO NULL     

    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i120_cs()                    #取得查詢條件
    IF INT_FLAG THEN   LET INT_FLAG = 0 RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oonuser', 'oongrup')

    LET g_sql= "SELECT DISTINCT oon01,oon02,oon03 FROM oon_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY oon01"
    PREPARE i120_prepare FROM g_sql      #預備一下
    DECLARE i120_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i120_prepare
    LET g_sql="SELECT COUNT(*) FROM ",
              " (SELECT COUNT(*) FROM oon_file WHERE ",g_wc CLIPPED,
              " GROUP BY oon01,oon02,oon03) t "
    PREPARE i120_precount FROM g_sql
    DECLARE i120_count CURSOR FOR i120_precount


    OPEN i120_count
    FETCH i120_count INTO g_row_count
   #DISPLAY g_row_count TO FORMONLY.cnt 

    OPEN i120_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err(g_oon01,SQLCA.sqlcode,0)
        INITIALIZE g_oon01 TO NULL
    ELSE
        CALL i120_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#QBE 查詢資料
FUNCTION i120_cs()
    CLEAR FORM                             #清除畫面
    CALL g_oon.clear()
    CALL cl_set_head_visible("","YES")    

   INITIALIZE g_oon01 TO NULL   
   INITIALIZE g_oon02 TO NULL   
   INITIALIZE g_oon03 TO NULL  
    CONSTRUCT g_wc ON oon01,oon02,oon03,oon04,oon05,oon06,oon07,oon08 
                 FROM oon01,oon02,oon03,oon04,oon05,oon06,oon07,oon08
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


      ON ACTION qbe_select
        CALL cl_qbe_select()
      ON ACTION qbe_save
        CALL cl_qbe_save()
    END CONSTRUCT

    IF INT_FLAG THEN RETURN END IF
#   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oonuser', 'oongrup')

#   LET g_sql= "SELECT DISTINCT oon01,oon02,oon03 FROM oon_file ",
#              " WHERE ", g_wc CLIPPED,
#              " ORDER BY oon01"
#   PREPARE i120_prepare FROM g_sql      #預備一下
#   DECLARE i120_bcs                  #宣告成可捲動的
#       SCROLL CURSOR WITH HOLD FOR i120_prepare
#   LET g_sql="SELECT COUNT(*) FROM ",
#             " (SELECT COUNT(*) FROM oon_file WHERE ",g_wc CLIPPED,
#             " GROUP BY oon01,oon02,oon03) t "              
#   PREPARE i120_precount FROM g_sql
#   DECLARE i120_count CURSOR FOR i120_precount
END FUNCTION

#處理資料的讀取
FUNCTION i120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式   
    l_abso          LIKE type_file.num10      #絕對的筆數 

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i120_bcs INTO g_oon01,g_oon02,g_oon03 
        WHEN 'P' FETCH PREVIOUS i120_bcs INTO g_oon01,g_oon02,g_oon03 
        WHEN 'F' FETCH FIRST    i120_bcs INTO g_oon01,g_oon02,g_oon03 
        WHEN 'L' FETCH LAST     i120_bcs INTO g_oon01,g_oon02,g_oon03 
        WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  
              PROMPT g_msg CLIPPED || ': ' FOR g_jump   

              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
              
              ON ACTION about        
                 CALL cl_about()     
              
              ON ACTION help         
                 CALL cl_show_help() 
              
              ON ACTION controlg     
                 CALL cl_cmdask()    


              END PROMPT
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i120_bcs INTO g_oon01,g_oon02,g_oon03 --改g_jump
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_oon01,SQLCA.sqlcode,0)
        INITIALIZE g_oon01  TO NULL  
        INITIALIZE g_oon02  TO NULL  
        INITIALIZE g_oon03  TO NULL  
    ELSE
        CALL i120_show()
        CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i120_show()
    DISPLAY g_oon01,g_oon02,g_oon03
         TO oon01,oon02,oon03 #單頭
    CALL i120_bf(g_wc)         #單身
#   DISPLAY g_tot  TO tot1
    CALL cl_show_fld_cont()               
END FUNCTION

FUNCTION i120_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000     

    LET g_sql =
       "SELECT oon04,oon05,0,oon06,oon07,oon08 ",  
       "  FROM oon_file",
       " WHERE oon01 = ",g_oon01," AND ",p_wc CLIPPED ,          
       "   AND oon02 = ",g_oon02,                                
       "   AND oon03 = ",g_oon03,                               
       " ORDER BY oon04,oon05"
    PREPARE i120_prepare2 FROM g_sql      #預備一下
    DECLARE oon_cs CURSOR FOR i120_prepare2
    CALL g_oon.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET g_rec = 0
    LET g_tot =0
    FOREACH oon_cs INTO g_oon[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,0)
            EXIT FOREACH
        END IF
        CALL i120_qty(g_oon[g_cnt].oon04,g_oon[g_cnt].oon05) RETURNING g_oon[g_cnt].qty
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oon.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    CALL i120_tot()

END FUNCTION

FUNCTION i120_qty(p_oon04,p_oon05)
DEFINE p_oon04    LIKE oon_file.oon04
DEFINE p_oon05    LIKE oon_file.oon05
DEFINE l_sta      LIKE type_file.num10
DEFINE l_end      LIKE type_file.num10
DEFINE l_num      LIKE type_file.num10
   IF cl_null(p_oon04) OR cl_null(p_oon05) THEN
      RETURN 0
   END IF  

   LET l_sta =  p_oon04[3,10] 

   LET l_end =  p_oon05[3,10]

   LET l_num = l_end - l_sta + 1 
   IF l_num < 0 THEN
      CALL cl_err('','axr-934',0)
      RETURN 0
   END IF 
   RETURN l_num 
   
END FUNCTION

FUNCTION i120_inv_repeat(p_oon04)   #判斷發票不可重複
DEFINE p_oon04   LIKE oon_file.oon04
DEFINE l_sql     STRING
DEFINE l_oon04   LIKE oon_file.oon04
DEFINE l_oon05   LIKE oon_file.oon05
DEFINE l_sta     LIKE type_file.num10
DEFINE l_end     LIKE type_file.num10
DEFINE l_num     LIKE type_file.num10
   LET g_errno = ''
   IF cl_null(p_oon04) THEN RETURN END IF 
   LET l_num = p_oon04[3,10]
   LET l_sql = " SELECT oon04, oon05 FROM oon_file",
               "    WHERE oon01 = '",g_oon01,"'",
               "      AND oon02 = '",g_oon02,"'",
               "      AND oon03 = '",g_oon03,"'" 
   IF NOT cl_null(g_oon_t.oon04) THEN
      LET l_sql = l_sql," AND oon04 NOT IN ('",g_oon_t.oon04,"')"
   END IF
   PREPARE i120_repeat FROM l_sql      #預備一下
   DECLARE i120_repeat_cs CURSOR FOR i120_repeat   
   FOREACH i120_repeat_cs INTO l_oon04, l_oon05
      IF p_oon04[1,2] <> l_oon04[1,2] OR p_oon04[1,2] <> l_oon05[1,2] THEN
         CONTINUE FOREACH
      END IF
      LET l_sta = l_oon04[3,10]
      LET l_end = l_oon05[3,10] 
      IF (l_num > l_sta AND l_num < l_end) OR l_num = l_sta OR l_num = l_end THEN
         LET g_errno = 'axr-810'
         RETURN
      END IF   
   END FOREACH

END FUNCTION

FUNCTION i120_tot()
DEFINE l_num     LIKE type_file.num20
DEFINE l_i       LIKE type_file.num5
   LET l_num = 0
   FOR l_i = 1 TO g_rec_b
      LET l_num = l_num + g_oon[l_i].qty    
   END FOR 
   LET g_tot = l_num
   DISPLAY g_tot TO FORMONLY.tot1
END FUNCTION

FUNCTION i120_pro_invo()
DEFINE l_n      LIKE type_file.num5
DEFINE l_oon    DYNAMIC ARRAY OF RECORD
          sel   LIKE type_file.chr1,
          oon04 LIKE oon_file.oon04,
          oon05 LIKE oon_file.oon05
                END RECORD
DEFINE l_sql    STRING
DEFINE l_i      LIKE type_file.num5
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_cnt1   LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_flag2  LIKE type_file.chr1
DEFINE l_oon08  LIKE oon_file.oon08

   LET l_n2 = 0
   LET g_success = 'Y'
   IF cl_null(g_oon01) OR cl_null(g_oon02) OR cl_null(g_oon03) THEN
       RETURN

   END IF
   SELECT COUNT(*) INTO l_n FROM oon_file 
      WHERE oon01 = g_oon01 AND oon02 = g_oon02 
        AND oon03 = g_oon03 AND oon08 = 'N' 
   IF l_n = 0 THEN
      RETURN
   END IF

   OPEN WINDOW i1201_w AT 3,10              #顯示畫面
     WITH FORM "axr/42f/axri1201"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("axri1201")
   
   LET l_sql = " SELECT 'N', oon04, oon05 FROM oon_file ",
               "    WHERE oon01 = '",g_oon01,"'",
               "      AND oon02 = '",g_oon02,"'" ,
               "      AND oon03 = '",g_oon03,"'",
               "      AND oon08 = 'N'"
   PREPARE i120_pro_invo FROM l_sql      #預備一下
   DECLARE i120_pro_invo_cs CURSOR FOR i120_pro_invo
   LET l_cnt = 1
   FOREACH i120_pro_invo_cs INTO l_oon[l_cnt].* 
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_oon[l_cnt].oon04) OR cl_null(l_oon[l_cnt].oon05) THEN
          CONTINUE FOREACH
       END IF 
       LET l_cnt = l_cnt + 1 
   END FOREACH 
   CALL l_oon.deleteElement(l_cnt)
   LET l_cnt = l_cnt - 1 

   WHILE TRUE
   INPUT ARRAY l_oon WITHOUT DEFAULTS FROM s_oon1.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED)
      BEFORE INPUT 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_cnt1 = ARR_CURR()
         CALL cl_show_fld_cont()                
      
      AFTER FIELD sel 
         IF NOT cl_null(l_oon[l_cnt1].sel) THEN
            IF l_oon[l_cnt1].sel <> 'Y' AND l_oon[l_cnt1].sel <> 'N' THEN
               NEXT FIELD sel
            END IF
         ELSE
            NEXT FIELD sel
         END IF

      ON CHANGE sel 
         IF l_oon[l_cnt1].sel = 'Y' THEN 
            LET l_n2 = l_n2 + 1 
         ELSE 
            LET l_n2 = l_n2 - 1
         END IF         

      AFTER INPUT
         IF INT_FLAG THEN
             LET INT_FLAG = 0
             EXIT INPUT
         END IF

      ON ACTION sel_all
         FOR l_i = 1 TO l_cnt 
             LET l_oon[l_i].sel = 'Y'
         END FOR
         LET l_n2 = l_cnt

      ON ACTION unsel_all
         FOR l_i = 1 TO l_cnt
             LET l_oon[l_i].sel = 'N'
         END FOR
         LET l_n2 = 0

      ON ACTION res_sel_all
         FOR l_i = 1 TO l_cnt
             IF l_oon[l_i].sel = 'Y' THEN
                LET l_oon[l_i].sel = 'N'
             ELSE
                LET l_oon[l_i].sel = 'Y'
             END IF
         END FOR
         LET l_n2 = l_cnt - l_n2

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         EXIT INPUT 

      ON ACTION controlg
         CALL cl_cmdask() 

      ON ACTION cancel
         EXIT INPUT 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 

      ON ACTION about      
         CALL cl_about()     
       
      ON ACTION accept
         EXIT INPUT

   END INPUT 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i1201_w
      EXIT WHILE
   ELSE
      IF l_n2 > 0 THEN
         IF cl_confirm('axr-811') THEN
            CALL s_showmsg_init()
            LET l_flag2 = 'Y'
            FOR l_i = 1 TO l_cnt 
               BEGIN WORK
               LET g_success = 'Y'
               IF l_oon[l_i].sel = 'N' THEN CONTINUE FOR END IF
               SELECT oon08 INTO l_oon08 FROM oon_file
                  WHERE oon01 = g_oon01 AND oon02 = g_oon02
                    AND oon03 = g_oon03 AND oon04 = l_oon[l_i].oon04
                    AND oon05 = l_oon[l_ac].oon05
               IF l_oon08 = 'Y' THEN
                  CALL s_errmsg('oon01',g_oon01,l_oon[l_i].oon04,'axr-815',1)
                  CONTINUE FOR
               END IF
               CALL i120_ins_oom(l_oon[l_i].oon04, l_oon[l_i].oon05)
               IF g_success = 'Y' THEN
                  UPDATE oon_file SET oon08 = 'Y' 
                     WHERE oon01 = g_oon01 AND oon02 = g_oon02
                       AND oon03 = g_oon03 AND oon04 = l_oon[l_i].oon04
                       AND oon05 = l_oon[l_i].oon05
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","oon_file",g_oon01,g_oon_t.oon04,SQLCA.sqlcode,"","",1)  
                      ROLLBACK WORK
                  ELSE
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
                  END IF 
               ELSE
                  ROLLBACK WORK
               END IF
            END FOR
            CALL s_showmsg()
         ELSE
            CLOSE WINDOW i1201_w
            EXIT WHILE         
         END IF
      END IF
   END IF 
 
   IF l_n2 > 0 AND l_flag2 = 'Y' THEN
      IF g_success = 'N' THEN
         CALL cl_end2(2) RETURNING l_flag
      ELSE
         CALL cl_end2(1) RETURNING l_flag
      END IF
 
      IF NOT l_flag THEN
         CLOSE WINDOW i1201_w
         EXIT WHILE
     #FUN-C50021 add START
      ELSE
         CALL l_oon.clear()
         LET l_cnt = 1
         LET l_n2 = 0 
         FOREACH i120_pro_invo_cs INTO l_oon[l_cnt].*
             IF SQLCA.sqlcode THEN
                 CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                 EXIT FOREACH
             END IF
             IF cl_null(l_oon[l_cnt].oon04) OR cl_null(l_oon[l_cnt].oon05) THEN
                CONTINUE FOREACH
             END IF
             LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_oon.deleteElement(l_cnt)
         LET l_cnt = l_cnt - 1
     #FUN-C50021 add END   
      END IF
   ELSE 
      CLOSE WINDOW i1201_w
      EXIT WHILE
   END IF
   END WHILE 


END FUNCTION
 
FUNCTION i120_ins_oom(p_oon04, p_oon05)
DEFINE p_oon04    LIKE oon_file.oon04
DEFINE p_oon05    LIKE oon_file.oon05
DEFINE l_oom      RECORD LIKE oom_file.*
DEFINE l_sta      LIKE type_file.num10   #發票起始號碼
DEFINE l_end      LIKE type_file.num10   #發票截止號碼
DEFINE l_invoce   LIKE type_file.chr10   #發票批次結束號碼
DEFINE l_invoce2  LIKE type_file.chr10   #發票批次開始號碼
DEFINE l_qty      LIKE type_file.num10   #發票張數
DEFINE l_oon06    LIKE oon_file.oon06
DEFINE l_oon07    LIKE oon_file.oon07    #批量
DEFINE l_i        LIKE type_file.num5    #發票張數/批量
DEFINE l_i2       LIKE type_file.num5
DEFINE l_i3       LIKE type_file.num5    #FUN-C50022 add

   SELECT oon06,oon07 INTO l_oon06,l_oon07 FROM oon_file 
       WHERE oon01 = g_oon01 AND oon02 = g_oon02
         AND oon03 = g_oon03 AND oon04 = p_oon04
         AND oon05 = p_oon05

   LET l_sta = p_oon04[3,10]
   LET l_end = p_oon05[3,10]
   LET l_qty = l_end - l_sta   #發票張數
   IF l_qty MOD l_oon07 > 0 THEN
      LET l_i = (l_qty/l_oon07) + 1
   END IF 
   FOR l_i2 = 1 TO l_i 
       LET l_invoce = l_sta + l_oon07 - 1 
       IF l_invoce >= l_end THEN
          LET l_invoce = l_end
       END IF
       LET l_invoce = l_invoce USING "&&&&&&&&"
       LEt l_invoce2= l_sta USING "&&&&&&&&"
       LET l_oom.oom01 = g_oon01
       LET l_oom.oom02 = g_oon02
       LET l_oom.oom021 = g_oon03
       LET l_oom.oom03 = '1'
       LET l_oom.oom04 = '5'
       SELECT MAX(oom05) INTO l_oom.oom05 FROM oom_file
          WHERE oom01 = g_oon01 AND oom02 = g_oon02 AND oom021 = g_oon03
            AND oom03 = '1' AND oom04 = '5'
       IF l_oom.oom05 = 0 OR cl_null(l_oom.oom05) THEN
          LET l_oom.oom05 = 0 
       END IF
       LET l_oom.oom05 = l_oom.oom05 + 1
       LET l_oom.oom06 = '1'
       LET l_oom.oom07 = p_oon04[1,2],l_invoce2
       LET l_oom.oom08 = p_oon04[1,2],l_invoce
       LET l_oom.oom09 = ' '
       LET l_oom.oom10 = ' '
      #LET l_oom.oom11 = ' '   #FUN-C50022 mark
      #LET l_oom.oom12 = ' '   #FUN-C50022 mark
      #FUN-C50022 add START
       LET l_oom.oom12 = LENGTH(l_oom.oom07)
       FOR l_i3 = 1 TO l_oom.oom12 
          IF l_oom.oom07[l_i3,l_i3] MATCHES "[0123456789]" THEN
             LET l_oom.oom11 = l_i3
             EXIT FOR
          END IF
       END FOR
      #FUN-C50022 add END
       LET l_oom.oom13 = l_oon06 
       LET l_oom.oom14 = ' '
       LET l_oom.oom15 = ' '
       LET l_oom.oom16 = ' '
       LET l_oom.oom17 = 'Y'
       LET l_oom.oom18 = ' '
       LET l_oom.oomdate = g_today
       LET l_oom.oomgrup = g_grup 
       LET l_oom.oommodu = g_user
       LET l_oom.oomorig = g_grup
       LET l_oom.oomoriu = g_user
       LET l_oom.oompos = '1' 
       LET l_oom.oomuser = g_user
       INSERT INTO oom_file VALUES(l_oom.*)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('oom01',l_oom.oom01,'oom_ins',SQLCA.sqlcode,1)
          LET g_success="N"
          RETURN 
       END IF
       LET l_sta = l_invoce + 1 
   END FOR

END FUNCTION

FUNCTION i120_del_invo()
DEFINE l_n      LIKE type_file.num5
DEFINE l_oon    DYNAMIC ARRAY OF RECORD
          sel   LIKE type_file.chr1,
          oon04 LIKE oon_file.oon04,
          oon05 LIKE oon_file.oon05
                END RECORD
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_cnt1   LIKE type_file.num5
DEFINE l_i      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_flag2  LIKE type_file.chr1
DEFINE l_oon08  LIKE oon_file.oon08

   LET l_n2 = 0
   LET g_success = 'Y'
   IF cl_null(g_oon01) OR cl_null(g_oon02) OR cl_null(g_oon03) THEN
       RETURN
   END IF

   SELECT COUNT(*) INTO l_n FROM oon_file 
      WHERE oon01 = g_oon01 AND oon02 = g_oon02 
        AND oon03 = g_oon03 AND oon08 = 'Y'
   IF l_n = 0 THEN
      RETURN
   END IF

   OPEN WINDOW i1201_w AT 3,10              #顯示畫面
     WITH FORM "axr/42f/axri1201"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("axri1201")

   LET l_sql = " SELECT 'N', oon04, oon05 FROM oon_file ",
               "    WHERE oon01 = '",g_oon01,"'",
               "      AND oon02 = '",g_oon02,"'" ,
               "      AND oon03 = '",g_oon03,"'",
               "      AND oon08 = 'Y'"
   PREPARE i120_del_invo FROM l_sql      #預備一下
   DECLARE i120_del_invo_cs CURSOR FOR i120_del_invo
   LET l_cnt = 1
   FOREACH i120_del_invo_cs INTO l_oon[l_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_oon[l_cnt].oon04) OR cl_null(l_oon[l_cnt].oon05) THEN
          CONTINUE FOREACH
       END IF
       LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_oon.deleteElement(l_cnt)
   LET l_cnt = l_cnt - 1

   WHILE TRUE
   INPUT ARRAY l_oon WITHOUT DEFAULTS FROM s_oon1.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED)
      BEFORE INPUT
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_cnt1 = ARR_CURR()
         CALL cl_show_fld_cont()

      AFTER FIELD sel
         IF NOT cl_null(l_oon[l_cnt1].sel) THEN
            IF l_oon[l_cnt1].sel <> 'Y' AND l_oon[l_cnt1].sel <> 'N' THEN
               NEXT FIELD sel
            END IF
         ELSE
            NEXT FIELD sel
         END IF

      ON CHANGE sel
         IF l_oon[l_cnt1].sel = 'Y' THEN
            LET l_n2 = l_n2 + 1
         ELSE
            LET l_n2 = l_n2 - 1
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
             LET INT_FLAG = 0
             EXIT INPUT
         END IF

      ON ACTION sel_all
         FOR l_i = 1 TO l_cnt
             LET l_oon[l_i].sel = 'Y'
         END FOR
         LET l_n2 = l_cnt

      ON ACTION unsel_all
         FOR l_i = 1 TO l_cnt
             LET l_oon[l_i].sel = 'N'
         END FOR
         LET l_n2 = 0

      ON ACTION res_sel_all
         FOR l_i = 1 TO l_cnt
             IF l_oon[l_i].sel = 'Y' THEN
                LET l_oon[l_i].sel = 'N'
             ELSE
                LET l_oon[l_i].sel = 'Y'
             END IF
         END FOR
         LET l_n2 = l_cnt - l_n2

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         EXIT INPUT

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION cancel
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION accept
         EXIT INPUT

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i1201_w
      EXIT WHILE
   ELSE
      IF l_n2 > 0 THEN
         IF cl_confirm('axr-814') THEN
            LET l_flag2 = 'Y'
            CALL s_showmsg_init()
            LET g_success = 'Y'
            FOR l_i = 1 TO l_cnt
               BEGIN WORK
               IF l_oon[l_i].sel = 'N' THEN CONTINUE FOR END IF
               SELECT oon08 INTO l_oon08 FROM oon_file
                  WHERE oon01 = g_oon01 AND oon02 = g_oon02
                    AND oon03 = g_oon03 AND oon04 = l_oon[l_i].oon04
                    AND oon05 = l_oon[l_ac].oon05
               IF l_oon08 = 'N' THEN
                  CALL s_errmsg('oon01',g_oon01,l_oon[l_i].oon04,'axr-816',1)
                  CONTINUE FOR
               END IF
               LET g_success = 'Y'
               CALL i120_del_oom(l_oon[l_i].oon04, l_oon[l_i].oon05)
               IF g_success = 'Y' THEN
                  UPDATE oon_file SET oon08 = 'N'
                     WHERE oon01 = g_oon01 AND oon02 = g_oon02
                       AND oon03 = g_oon03 AND oon04 = l_oon[l_i].oon04
                       AND oon05 = l_oon[l_i].oon05
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","oon_file",g_oon01,g_oon_t.oon04,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                  ELSE
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
                  END IF
               ELSE
                  ROLLBACK WORK
               END IF
            END FOR
            CALL s_showmsg()
         ELSE
            CLOSE WINDOW i1201_w
            EXIT WHILE        
         END IF
      END IF
   END IF

   IF l_n2 > 0 AND l_flag2 = 'Y' THEN
      IF g_success = 'N' THEN
         CALL cl_end2(2) RETURNING l_flag
      ELSE
         CALL cl_end2(1) RETURNING l_flag
      END IF

      IF NOT l_flag THEN
         CLOSE WINDOW i1201_w
         EXIT WHILE
     #FUN-C50021 add START
      ELSE
         CALL l_oon.clear()
         LET l_cnt = 1
         LET l_n2 = 0
         FOREACH i120_del_invo_cs INTO l_oon[l_cnt].*
             IF SQLCA.sqlcode THEN
                 CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                 EXIT FOREACH
             END IF
             IF cl_null(l_oon[l_cnt].oon04) OR cl_null(l_oon[l_cnt].oon05) THEN
                CONTINUE FOREACH
             END IF
             LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_oon.deleteElement(l_cnt)
         LET l_cnt = l_cnt - 1
     #FUN-C50021 add END
      END IF
   ELSE
      CLOSE WINDOW i1201_w
      EXIT WHILE
   END IF
   END WHILE

END FUNCTION
 
FUNCTION i120_del_oom(p_oon04, p_oon05)
DEFINE p_oon04    LIKE oon_file.oon04
DEFINE p_oon05    LIKE oon_file.oon05
DEFINE l_oom05    LIKE oom_file.oom05
DEFINE l_oom07    LIKE oom_file.oom07
DEFINE l_oom08    LIKE oom_file.oom08
DEFINE l_sql      STRING
DEFINE l_n        LIKE type_file.num10
DEFINE l_str      STRING

   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM oom_file
      WHERE oom01 = g_oon01 AND oom02 = g_oon02
        AND oom021 = g_oon03 
        AND oom03 = '1' AND oom04 = '5'
        AND RTRIM(oom09) IS NOT NULL
        AND ( oom07 = p_oon04 OR oom08 = p_oon05 OR
              (oom07 > p_oon04 AND oom07 < p_oon05))
   IF l_n > 0 THEN
      LET g_success = 'N'
      LET l_str = p_oon04,",",p_oon05 
      CALL s_errmsg('oom07',l_str ,'','axr-813',1)
      RETURN 
   END IF

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM oom_file
      WHERE oom01 = g_oon01 AND oom02 = g_oon02
        AND oom021 = g_oon03 AND oompos <> '1'
        AND oom03 = '1' AND oom04 = '5'
        AND ( oom07 = p_oon04 OR oom08 = p_oon05 OR
              (oom07 > p_oon04 AND oom07 < p_oon05))
   IF l_n > 0 THEN
      LET g_success = 'N'
      LET l_str = p_oon04,",",p_oon05
      CALL s_errmsg('oom07',l_str ,'','axr-817',1)
      RETURN
   END IF

   LET l_sql = " SELECT oom05, oom07, oom08 FROM oom_file ",
               "   WHERE oom01 = '",g_oon01,"'",
               "     AND oom02 = '",g_oon02,"'",
               "     AND oom021 = '",g_oon03,"'",
               "     AND oom03= '1' AND oom04 = '5'",
               "     AND oom17 = 'Y'",
               "     AND ( oom07 = '",p_oon04,"' OR oom07 = '",p_oon05,"' 
                          OR (oom07 > '",p_oon04,"' AND oom07 < '",p_oon05,"'))"   
   PREPARE i120_del_invo1 FROM l_sql      #預備一下
   DECLARE i120_del_invo_cs1 CURSOR FOR i120_del_invo1
   FOREACH i120_del_invo_cs1 INTO l_oom05, l_oom07, l_oom08
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF cl_null(l_oom05) OR cl_null(l_oom07) OR cl_null(l_oom08) THEN
         CONTINUE FOREACH
      END IF        
      IF l_oom07[1,2] <> p_oon04[1,2] THEN CONTINUE FOREACH END IF
      IF l_oom08[1,2] <> p_oon05[1,2] THEN CONTINUE FOREACH END IF
      DELETE FROM oom_file 
         WHERE oom01 = g_oon01 AND oom02 = g_oon02
           AND oom021 = g_oon03 AND oom03 = '1' AND oom04 = '5'
           AND oom05 = l_oom05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oom01',g_oon01,'oom_del',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      END IF       
   END FOREACH
END FUNCTION
#FUN-C40076 
