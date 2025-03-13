# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi933.4gl
# Descriptions...: 資料群組維謢
# Date & Author..: NO.FUN-A40051 10/04/26 By Alan
# Modify.........: No.FUN-A50015 10/05/05 By Jay 加入六個基本欄位
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_azwc           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        azwc01       LIKE azwc_file.azwc01,        #資料群組別
        azwc02       LIKE azwc_file.azwc02,        #說明
        azwcacti     LIKE azwc_file.azwcacti       #有效否
                     END RECORD,
    g_azwc_t         RECORD                        #程式變數 (舊值)
        azwc01       LIKE azwc_file.azwc01,        #資料群組別
        azwc02       LIKE azwc_file.azwc02,        #說明
        azwcacti     LIKE azwc_file.azwcacti       #有效否
                     END RECORD,
    g_wc2,g_sql      STRING,  
    g_rec_b          LIKE type_file.num5,          #單身筆數 
    l_ac             LIKE type_file.num5           #目前處理的ARRAY CNT      
 
DEFINE g_forupd_sql          STRING                #SELECT ... FOR UPDATE SQL     
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5   #count/index for any purpose
DEFINE g_before_input_done   LIKE type_file.num5                
DEFINE g_str                 STRING                   
DEFINE g_rowac               LIKE type_file.num5   #FUN-A50015記錄新增'Global'資料位置

MAIN                                       
DEFINE p_row,p_col           LIKE type_file.num5
    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 4 LET p_col = 27
    OPEN WINDOW i933_w AT p_row,p_col WITH FORM "aoo/42f/aooi933"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    
    IF i933_chk_global_data() THEN       #FUN-A50015
       LET g_wc2 = '1=1' CALL i933_b_fill(g_wc2) 
    END IF                               #FUN-A50015
    
    CALL i933_menu()
    CLOSE WINDOW i933_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) 
       RETURNING g_time   
END MAIN
 
FUNCTION i933_menu()
 
   WHILE TRUE
      CALL i933_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL i933_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i933_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i933_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            IF i933_chk_global_data() THEN 
               EXIT WHILE
            END IF
         WHEN "controlg" 
            CALL cl_cmdask()
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_azwc[l_ac].azwc01 IS NOT NULL THEN
                  LET g_doc.column1 = "azwc01"
                  LET g_doc.value1 = g_azwc[l_ac].azwc01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azwc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i933_q()
    CLEAR FORM
    CALL g_azwc.clear()

    CONSTRUCT g_wc2 ON azwc01,azwc02,azwcacti
         FROM s_gem[1].azwc01,s_gem[1].azwc02,s_gem[1].azwcacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('geauser', 'geagrup')

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL i933_b_fill(g_wc2)

END FUNCTION
 
FUNCTION i933_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否     
    p_cmd           LIKE type_file.chr1,                #處理狀態    
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1                 #可刪除否
 
    IF s_shut(0) THEN
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT azwc01,azwc02,azwcacti FROM azwc_file",
                       " WHERE azwc01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i933_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_azwc WITHOUT DEFAULTS FROM s_gem.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
            CALL i933_set_entry(p_cmd)                     
            CALL i933_set_no_entry(p_cmd) 

        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
               CALL i933_set_entry(p_cmd)                                       
               CALL i933_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_azwc_t.* = g_azwc[l_ac].*  #BACKUP
               OPEN i933_bcl USING g_azwc_t.azwc01
               IF STATUS THEN
                  CALL cl_err("OPEN i933_bcl:", STATUS, 1)    
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i933_bcl INTO g_azwc[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_azwc_t.azwc01,SQLCA.sqlcode,1)   
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                      
           CALL i933_set_entry(p_cmd)                                           
           CALL i933_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           INITIALIZE g_azwc[l_ac].* TO NULL       #900423
           LET g_azwc[l_ac].azwcacti = 'Y'         #Body default
           LET g_azwc_t.* = g_azwc[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()    
           NEXT FIELD azwc01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i933_bcl
              CANCEL INSERT
           END IF
                    
           INSERT INTO azwc_file(azwc01, azwc02, azwcacti, azwcuser, azwcgrup, azwcdate, azwcorig, azwcoriu)
                  VALUES(g_azwc[l_ac].azwc01, g_azwc[l_ac].azwc02, g_azwc[l_ac].azwcacti, 
                         g_user, g_grup, g_today, g_grup, g_user)                                          #FUN-A50015
          
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azwc_file",g_azwc[l_ac].azwc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD azwc01                        #check 編號是否重複
            IF NOT cl_null(g_azwc[l_ac].azwc01) THEN
               IF g_azwc[l_ac].azwc01 != g_azwc_t.azwc01 OR
                  g_azwc_t.azwc01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM azwc_file
                       WHERE azwc01 = g_azwc[l_ac].azwc01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_azwc[l_ac].azwc01 = g_azwc_t.azwc01
                       NEXT FIELD azwc01
                   END IF
               END IF
            END IF
 
        AFTER FIELD azwcacti
           IF NOT cl_null(g_azwc[l_ac].azwcacti) THEN
              IF g_azwc[l_ac].azwcacti NOT MATCHES '[YN]' THEN 
                 LET g_azwc[l_ac].azwcacti = g_azwc_t.azwcacti
                 NEXT FIELD azwcacti
              END IF
              #----------FUN-A50015 modify start----------------------
              IF g_azwc[l_ac].azwcacti MATCHES '[N]' AND 
                 g_rec_b >= l_ac THEN 

                 IF g_azwc_t.azwc01="Global" THEN
                    CALL cl_err("","aoo-506",1)
                 ELSE
                    IF cl_confirm("aoo-508") THEN
                       UPDATE azwe_file set azwe02='Global'
                       WHERE azwe02 IN (SELECT azwe02 FROM azwe_file WHERE azwe02=g_azwc_t.azwc01)
                    ELSE
                       LET g_azwc[l_ac].azwcacti = 'Y'
                    END IF
                 END IF  
              END IF
              #----------FUN-A50015 modify end------------------------
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_azwc_t.azwc01 IS NOT NULL THEN
               IF g_azwc_t.azwc01="Global" THEN
                   CALL cl_err("","aoo-506",1)
                   CANCEL DELETE
                ELSE
                   CALL cl_err("","aoo-505",1)
                   IF NOT cl_delb(0,0) THEN
                      CANCEL DELETE
                   ELSE
                      UPDATE azwe_file set azwe02='Global'
                      WHERE azwe02 IN (SELECT azwe02 FROM azwe_file WHERE azwe02=g_azwc_t.azwc01)   #FUN-A50015
                      DELETE FROM azwc_file WHERE azwc01 = g_azwc_t.azwc01
                   END IF
                END IF                

                INITIALIZE g_doc.* TO NULL                
                LET g_doc.column1 = "azwc01"             
                LET g_doc.value1 = g_azwc[l_ac].azwc01  
                CALL cl_del_doc()                    
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","azwc_file",g_azwc_t.azwc01,"",SQLCA.sqlcode,"","",1)  
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
              LET g_azwc[l_ac].* = g_azwc_t.*
              CLOSE i933_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw="Y" THEN
              CALL cl_err(g_azwc[l_ac].azwc01,-263,0)
              LET g_azwc[l_ac].* = g_azwc_t.*
           ELSE
              UPDATE azwc_file SET azwc01=g_azwc[l_ac].azwc01,
                                   azwc02=g_azwc[l_ac].azwc02,
                                   azwcacti=g_azwc[l_ac].azwcacti,
                                   azwcdate=g_today,
                                   azwcmodu=g_user,
                                   azwcgrup=g_grup
                WHERE azwc01 = g_azwc_t.azwc01                        #FUN-A50015
              
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()            # 新增
           #LET l_ac_t = l_ac               # 新增  #FUN-D40030
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_azwc[l_ac].* = g_azwc_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_azwc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i933_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac               # 新增  #FUN-D40030
           CLOSE i933_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(azwc01) AND l_ac > 1 THEN
              LET g_azwc[l_ac].* = g_azwc[l_ac-1].*
              NEXT FIELD azwc01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()    
 
        ON ACTION help        
           CALL cl_show_help()  
 
    END INPUT
 
    CLOSE i933_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i933_b_fill(p_wc2)              
DEFINE
    p_wc2           LIKE type_file.chr1000     
 
    LET g_sql =
        "SELECT azwc01,azwc02,azwcacti",
        " FROM azwc_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i933_pb FROM g_sql
    DECLARE gea_curs CURSOR FOR i933_pb
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gea_curs INTO g_azwc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        END IF

        #----------FUN-A50015 modify start----------------------
         IF g_azwc[g_cnt].azwc01 = "Global" THEN
            LET g_rowac = g_cnt
         END IF
        #----------FUN-A50015 modify end------------------------
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_azwc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i933_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azwc TO s_gem.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i933_out()
    DEFINE
        l_gea           RECORD LIKE azwc_file.*,
        l_i             LIKE type_file.num5,          
        l_name          LIKE type_file.chr20,        
        l_za05          LIKE za_file.za05           
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    LET g_str=''                                               
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog       
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azwc_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i933_p1 FROM g_sql                     # RUNTIME 編譯
    DECLARE i933_co                                # SCROLL CURSOR
         CURSOR FOR i933_p1
 
    CALL cl_outnam('aooi933') RETURNING l_name                                
 
    FOREACH i933_co INTO l_gea.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
           EXIT FOREACH
        END IF    
    END FOREACH
 
 
    CLOSE i933_co
    ERROR ""
                     
    IF g_zz05='Y' THEN                                          
       CALL cl_wcchp(g_wc2,'azwc01,azwc02,azwcacti')           
       RETURNING g_wc2                                          
    END IF                                                      
    LET g_str=g_wc2                                             
    CALL cl_prt_cs1("aooi933","aooi933",g_sql,g_str)            
END FUNCTION                                                   
 
FUNCTION i933_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azwc01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i933_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1        
                                                                                        
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("azwc01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

#----------FUN-A50015 modify start----------------------
FUNCTION i933_chk_global_data()                                               
  DEFINE l_cnt   LIKE type_file.num5        
                                                                                        
   SELECT COUNT(*) INTO l_cnt FROM azwc_file
     WHERE azwc01 = 'Global'
   IF l_cnt = 0 THEN 
      BEGIN WORK
      INSERT INTO azwc_file(azwc01, azwc02, azwcacti, azwcuser, azwcgrup, azwcdate, azwcorig, azwcoriu)
             VALUES('Global', '', 'Y', 
                    g_user, g_grup, g_today, g_grup, g_user)                   
                          
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azwc_file",'Global',"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
      END IF
      COMMIT WORK
      LET g_wc2 = '1=1' CALL i933_b_fill(g_wc2)

      LET l_ac = g_rowac 
      CALL i933_b()
      RETURN FALSE       
   ELSE
      RETURN TRUE     
   END IF  
END FUNCTION 
#----------FUN-A50015 modify end------------------------
