# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aski001_4.4gl
# Descriptions...: 洗水說明
# Date & Author..: No.FUN-810016 07/07/27 By hongmei 
# Modify.........: No.FUN-870117 08/09/10 By hongmei FUN-870117過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-AB0173 10/11/17 By lilingyu 點擊action按鈕,程序整個當掉
# Modify.........: No:FUN-D40030 13/04/07 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ske           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ske03       LIKE ske_file.ske03,   
        ske04       LIKE ske_file.ske04,  
        ske05       LIKE ske_file.ske05          
                    END RECORD,
    g_ske_t         RECORD                     #程式變數 (舊值)
        ske03       LIKE ske_file.ske03,   
        ske04       LIKE ske_file.ske04,  
        ske05       LIKE ske_file.ske05          
                    END RECORD,
    #g_wc2,g_sql     LIKE type_file.chr1000,
    g_wc2,g_sql           STRING ,     #NO.FUN-910082 S  
    g_rec_b         LIKE type_file.num5,       #單身筆數        
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT        
 
DEFINE g_skd01      LIKE skd_file.skd01
DEFINE g_skd04      LIKE skd_file.skd04 
DEFINE g_ske02      LIKE ske_file.ske02 
DEFINE g_forupd_sql LIKE type_file.chr1000     #SELECT ... FOR UPDATE  SQL         
DEFINE g_cnt             LIKE type_file.num10  
DEFINE g_i               LIKE type_file.num5   #count/index for any purpose        
DEFINE g_before_input_done    LIKE type_file.num5     
 
FUNCTION i001_4(p_skd01)
   DEFINE p_skd01    LIKE skd_file.skd01
  
    OPEN WINDOW i001_4_w WITH FORM "ask/42f/aski001_4"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
    CALL cl_ui_locale("aski001_4")
    LET g_skd01=p_skd01
        
#   LET g_wc2 = '1=1' CALL i001_4_b_fill(g_wc2)
    CALL i001_4_menu()
    CLOSE WINDOW i001_4_w                  #結束畫面
 
END FUNCTION
 
FUNCTION i001_4_menu()
 
   WHILE TRUE
      CALL i001_4_b_fill()
      CALL i001_4_bp("G")
      CASE g_action_choice
         WHEN "query" 
#           IF cl_chk_act_auth() THEN
               CALL i001_4_q()
#           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_4_b()
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
#           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ske),'','')
#           END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_4_q()
   CALL i001_4_b_askkey()
END FUNCTION
 
FUNCTION i001_4_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        
    l_n             LIKE type_file.num5,          #檢查重複用        
    l_lske_sw       LIKE type_file.chr1,          #單身鎖住否        
    p_cmd           LIKE type_file.chr1,          #處理狀態       
    l_allow_insert  LIKE type_file.num5,          #可新增否       
    l_allow_delete  LIKE type_file.num5           #可刪除否        
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    SELECT skd04 INTO g_skd04 FROM skd_file WHERE skd01 = g_skd01
    IF g_skd04 = 'Y' THEN 
       CALL cl_err("",'ask-002',0) RETURN 
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ske03,ske04,ske05 FROM ske_file ", 
                       " WHERE ske01= ? AND ske02=? AND ske03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_4_bcl CURSOR FROM g_forupd_sql      # Lske CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ske WITHOUT DEFAULTS FROM s_ske.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lske_sw = 'N'               #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_ske02 = '4'
#           LET g_ske[l_ac].ske05 = '0'

            BEGIN WORK      #MOD-AB0173
             
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ske_t.* = g_ske[l_ac].*  #BACKUP
               LET g_before_input_done = FALSE                                                                                      
               CALL i001_4_set_entry_b(p_cmd)                                                                                         
               CALL i001_4_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
 
#              BEGIN WORK      #MOD-AB0173
 
               OPEN i001_4_bcl USING g_skd01,g_ske02,g_ske_t.ske03
               IF STATUS THEN
                  CALL cl_err("OPEN i001_4_bcl:", STATUS, 1)
                  LET l_lske_sw = "Y"
               ELSE  
                  FETCH i001_4_bcl INTO g_ske[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ske_t.ske03,SQLCA.sqlcode,1)
                     LET l_lske_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
            NEXT FIELD ske03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ske_file(ske01,ske02,ske03,ske04,ske05,skeplant,skelegal) #FUN-980008 add
                          VALUES(g_skd01,g_ske02,g_ske[l_ac].ske03,
                                 g_ske[l_ac].ske04,g_ske[l_ac].ske05,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#              CALL cl_err3("ins","ske_file",g_ske[l_ac].ske03,"",SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
        
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                                                                      
            CALL i001_4_set_entry_b(p_cmd)                                                                                         
            CALL i001_4_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
            INITIALIZE g_ske[l_ac].* TO NULL      
            LET g_ske_t.* = g_ske[l_ac].*         #新輸入資料
            LET g_ske02 = '4'
            LET g_ske[l_ac].ske05 = '0'
            CALL cl_show_fld_cont()     
            NEXT FIELD ske03
#           SELECT COUNT(*) INTO l_n FROM ske_file 
#           IF cl_null(l_n) THEN 
#              let l_n = 0
#           END IF 
#           LET g_ske[l_ac].ske03 = l_n +1
            
         BEFORE FIELD ske03
             IF g_ske[l_ac].ske03 IS NULL OR g_ske[l_ac].ske03 = 0  THEN
                SELECT MAX(ske03)+1
                INTO g_ske[l_ac].ske03 FROM ske_file WHERE ske01 = g_skd01
                                                       AND ske02 = '4'
                IF g_ske[l_ac].ske03 IS NULL THEN
                   LET g_ske[l_ac].ske03 =1
                END IF
             END IF         
 
        AFTER FIELD ske03                        #check 編號是否重複
            IF NOT cl_null(g_ske[l_ac].ske03) THEN
               IF g_ske[l_ac].ske03 != g_ske_t.ske03 OR
                  (g_ske[l_ac].ske03 IS NOT NULL AND g_ske_t.ske03 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM ske_file
                       WHERE ske01 =g_skd01 
                         AND ske02 = '4'
                         AND ske03 = g_ske[l_ac].ske03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ske[l_ac].ske03 = g_ske_t.ske03
                       NEXT FIELD ske03
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ske_t.ske03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lske_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
               #DELETE FROM ske_file WHERE ske03 = g_ske_t.ske03   #No.FUN-870117 mark
                DELETE FROM ske_file WHERE ske01 = g_skd01         #No.FUN-870117 add
                                       AND ske02 = '4'             #No.FUN-870117 add
                                       AND ske03 = g_ske_t.ske03   #No.FUN-870117 add
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ske_file",g_ske_t.ske03,"",SQLCA.sqlcode,"","",1)  
#                  ROLLBACK WORK    #MOD-AB0713
                   CANCEL DELETE 
                END IF
                MESSAGE "Delete OK"
                LET g_rec_b = g_rec_b - 1    #No.FUN-870117 add
#                CLOSE i001_4_bcl          #MOD-AB0173
#                COMMIT WORK               #MOD-AB0173
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ske[l_ac].* = g_ske_t.*
               CLOSE i001_4_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lske_sw = 'Y' THEN
               CALL cl_err(g_ske[l_ac].ske03,-263,1)
               LET g_ske[l_ac].* = g_ske_t.*
            ELSE
               UPDATE ske_file SET
                      ske03  = g_ske[l_ac].ske03,
                      ske04  = g_ske[l_ac].ske04,
                      ske05  = g_ske[l_ac].ske05
                WHERE ske01  = g_skd01
                  AND ske02  = '4'  
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ske_file",g_ske_t.ske03,"",SQLCA.sqlcode,"","",1)  
                   LET g_ske[l_ac].* = g_ske_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
#                  CLOSE i001_4_bcl     #MOD-AB0173
#                  COMMIT WORK          #MOD-AB0173
               END IF
            #--Move original UPDATE blske from AFTER ROW to here
            END IF
 
            #--New AFTER ROW blske
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac    #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ske[l_ac].* = g_ske_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_ske.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i001_4_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 add
            CLOSE i001_4_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i001_4_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ske03) AND l_ac > 1 THEN
                LET g_ske[l_ac].* = g_ske[l_ac-1].*
                NEXT FIELD ske03
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
 
#    CLOSE i001_4_bcl       #MOD-AB0173
#    COMMIT WORK            #MOD-AB0173
END FUNCTION
 
FUNCTION i001_4_b_askkey()
    CLEAR FORM
    CALL g_ske.clear()
    CONSTRUCT g_wc2 ON ske03,ske04,ske05
            FROM s_ske[1].ske03,s_ske[1].ske04,s_ske[1].ske05 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i001_4_b_fill()
END FUNCTION
 
FUNCTION i001_4_b_fill()              #BODY FILL UP
DEFINE
    p_wc2            STRING   
 
    LET g_sql =
        "SELECT ske03,ske04,ske05",
        " FROM ske_file",
        " WHERE ",                     #單身
        "    ske01='",g_skd01,"'",
        "   AND ske02='4'",
        " ORDER BY 1"
    PREPARE i001_4_pb FROM g_sql
    DECLARE ske_curs CURSOR FOR i001_4_pb
 
    CALL g_ske.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ske_curs INTO g_ske[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_ske.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i001_4_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ske TO s_ske.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
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
 
FUNCTION i001_4_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ske03",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i001_4_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                   
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ske03",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-810016   
