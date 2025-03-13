# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#                                                                                                                                   
# Pattern name...:aici003.4gl
# Descriptions...:ICD理由碼維護                                                                                                                  
# Date & Author..: 07/11/15 By destiny No.FUN-7B0074  
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-7B0074--begin--
DEFINE 
     g_icd            DYNAMIC ARRAY OF RECORD     #程式變量(Program Variables)
        icd01        LIKE icd_file.icd01,         #碼別代號
        icd02        LIKE icd_file.icd02,         #碼類別
        icd03        LIKE icd_file.icd03,         #說明內容
        icdacti      LIKE icd_file.icdacti
                     END RECORD,
     g_icd_t         RECORD                       #程序變量（舊值）
        icd01        LIKE icd_file.icd01,         #碼別代號
        icd02        LIKE icd_file.icd02,         #碼類別
        icd03        LIKE icd_file.icd03,         #說明內容
        icdacti      LIKE icd_file.icdacti
                     END RECORD,
      g_wc2,g_sql    STRING,
      g_rec_b        LIKE type_file.num5,         #單身筆數
      l_ac           LIKE type_file.num5          #目前處理的ARRAY CNT
  
DEFINE g_forupd_sql  STRING    #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt         LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5          #COUNT/index for any purpose
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE l_cmd         LIKE type_file.chr1000
MAIN
DEFINE l_time        LIKE type_file.chr8           #計算被使用時間
DEFINE p_row,p_col   LIKE type_file.num5      
    OPTIONS                                        #改變一些系統預設值
       INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理                                                                  
                                                                                                                                    
    IF (NOT cl_user()) THEN                                                                                                          
       EXIT PROGRAM                                                                                                                  
    END IF                                                                                                                           
 
    WHENEVER ERROR CALL cl_err_msg_log                                                                                               
                                                                                                                                    
    IF (NOT cl_setup("AIC")) THEN                                                                                                    
       EXIT PROGRAM                                                                                                                  
    END IF
                 
    IF NOT s_industry('icd') THEN                                                                                                   
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
    END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)                
       RETURNING g_time                                                                                      
                                                                                                                                    
    LET p_row = 4 LET p_col = 25                                                                                                    
    OPEN WINDOW i003_w AT p_row,p_col WITH FORM "aic/42f/aici003"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
                                                                                                                                    
    CALL cl_ui_init()                                                                                                               
                                                                                                                                    
    LET g_wc2 = '1=1' CALL i003_b_fill(g_wc2)                                                                                       
    CALL i003_menu()                                                                                                                
    CLOSE WINDOW i003_w                  #結束畫面                                                                                   
       CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間)            
         RETURNING g_time                                                                                     
END MAIN                 
               
FUNCTION i003_menu()                                                                                                                
                                                                                                                                    
   WHILE TRUE                                                                                                                       
      CALL i003_bp("G")                                                                                                             
      CASE g_action_choice                                                                                                          
         WHEN "query"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i003_q()                                                                                                        
            END IF                                                                                                                  
         WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i003_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
            IF cl_null(g_wc2) THEN
               LET g_wc2=" 1=1"
            END IF
            LET l_cmd='p_query "aici003" "',g_wc2 CLIPPED,'"'
            CALL cl_cmdrun(l_cmd)
            END IF                                                                                                                  
         WHEN "help"                                                                                                                
            CALL cl_show_help()                                                                                                     
         WHEN "exit" 
            EXIT WHILE                                                                                                              
         WHEN "controlg"                                                                                                            
            CALL cl_cmdask()                                                                                                        
          WHEN "related_document"                                                                                    
            IF cl_chk_act_auth() AND l_ac != 0 THEN                                                             
               IF g_icd[l_ac].icd01 IS NOT NULL THEN                                                                                
                  LET g_doc.column1 = "icd01"                                                                                       
                  LET g_doc.value1 = g_icd[l_ac].icd01                                                                              
                  LET g_doc.column2 = "icd02"                                                                                       
                  LET g_doc.value2 = g_icd[l_ac].icd02                                                                              
                  CALL cl_doc()                                                                                                     
               END IF                                                                                                               
            END IF                                                                                                                  
         WHEN "exporttoexcel"                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icd),'','')                                 
            END IF                                                                                                                  
                                                                                                                                    
      END CASE                                                                                                                      
   END WHILE                                                                                                                        
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_q()       
   CALL i003_b_askkey()                                                                                                             
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_b()                                                                                                                   
DEFINE                                                                                                                              
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   
    l_n             LIKE type_file.num5,                #檢查重復用                          
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                          
    p_cmd           LIKE type_file.chr1,                #處理狀態                              
    l_allow_insert  LIKE type_file.chr1,                #可新增否                                             
    l_allow_delete  LIKE type_file.chr1                 #可刪除否                                            
                                                                                                                                    
    IF s_shut(0) THEN RETURN END IF                                                                                                 
    CALL cl_opmsg('b')                                                                                                              
    LET g_action_choice = ""                                                                                                        
                                                                                                                                    
    LET l_allow_insert = cl_detail_input_auth('insert')                                                                             
    LET l_allow_delete = cl_detail_input_auth('delete')                                                                             
                                                                                                                                    
    LET g_forupd_sql = "SELECT icd01,icd02,icd03,icdacti FROM icd_file",                                                            
                       " WHERE icd01=? AND icd02=? FOR UPDATE"                                                                      
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR                                                                    
                                                                                                                                    
    INPUT ARRAY g_icd WITHOUT DEFAULTS FROM s_icd.*
 
    ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                                                                       
               INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)                                   
                                                                                                                                    
        BEFORE INPUT                                                                                                                
           IF g_rec_b != 0 THEN                                                                                                     
              CALL fgl_set_arr_curr(l_ac)                                                                                           
           END IF                                                                                                                   
                                                                                                                                    
        BEFORE ROW                                                                                                                  
            LET p_cmd=''                                                                                                            
            LET l_ac = ARR_CURR()                                                                                                   
            LET l_lock_sw = 'N'            #DEFAULT                                                                                 
            LET l_n  = ARR_COUNT()                                                                                                  
            IF g_rec_b>=l_ac THEN                                                                                                   
               BEGIN WORK                                                                                                           
               LET p_cmd='u'                                                                                                        
               LET g_before_input_done = FALSE                                                                                      
               CALL i003_set_entry(p_cmd)                                                                                           
               CALL i003_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE           
               LET g_icd_t.* = g_icd[l_ac].*  #BACKUP                                                                               
               OPEN i003_bcl USING g_icd_t.icd01,g_icd_t.icd02                                                                      
               IF STATUS THEN                                                                                                       
                  CALL cl_err("OPEN i003_bcl:", STATUS, 1)                                                                          
                  LET l_lock_sw = "Y"                                                                                               
               ELSE                                                                                                                 
                  FETCH i003_bcl INTO g_icd[l_ac].*                                                                                 
                  IF SQLCA.sqlcode THEN                                                                                             
                     CALL cl_err(g_icd_t.icd01,SQLCA.sqlcode,1)                                                                     
                     LET l_lock_sw = "Y"                                                                                            
                  END IF                                                                                                            
               END IF                                                                                                               
               CALL cl_show_fld_cont()                                                        
            END IF                                                                                                                  
                                                                                                                                    
        BEFORE INSERT                                                                                                               
           LET l_n = ARR_COUNT()                                                                                                    
           LET p_cmd='a'                                                                                                            
           LET g_before_input_done = FALSE                                                                                          
           CALL i003_set_entry(p_cmd)                                                                                               
           CALL i003_set_no_entry(p_cmd)  
           INITIALIZE g_icd[l_ac].* TO NULL      #900423                                                                            
           LET g_icd[l_ac].icdacti = 'Y'         #Body default                                                                      
           LET g_icd_t.* = g_icd[l_ac].*         #新輸入資料                                                                        
           CALL cl_show_fld_cont()                                             
           NEXT FIELD icd01                                                                                                         
                                                                                                                                    
        AFTER INSERT                                                                                                                
           IF INT_FLAG THEN                                                                                                         
              CALL cl_err('',9001,0)                                                                                                
              LET INT_FLAG = 0                                                                                                      
              CLOSE i003_bcl                                                                                                        
              CANCEL INSERT                                                                                                         
           END IF                                                                                                                   
           INSERT INTO icd_file(icd01,icd02,icd03,icdacti,icduser,icddate,icdoriu,icdorig)                                                          
                         VALUES(g_icd[l_ac].icd01,g_icd[l_ac].icd02,                                                                
                                g_icd[l_ac].icd03,g_icd[l_ac].icdacti,g_user,g_today, g_user, g_grup)                                                     #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN                                                                                                    
              CALL cl_err3("ins","icd_file",g_icd[l_ac].icd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131                             
              CANCEL INSERT                                                                                                         
           ELSE                                                                                                                     
              MESSAGE 'INSERT O.K'          
              LET g_rec_b=g_rec_b+1                                                                                                 
              DISPLAY g_rec_b TO FORMONLY.cn2                                                                                       
              COMMIT WORK                                                                                                           
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD icd02                                                                                                           
           IF NOT cl_null(g_icd[l_ac].icd02) THEN                                                                                   
              IF g_icd[l_ac].icd02 NOT MATCHES '[JKLMNOPQRSTU]' THEN                                            
                 CALL cl_err(g_icd[l_ac].icd02,'aoo-109',1)                                                                         
                 NEXT FIELD icd02                                                                                                   
              END IF                                                                                                                
              IF (g_icd[l_ac].icd01 != g_icd_t.icd01 OR g_icd_t.icd01 IS NULL)                                                      
                 OR (g_icd[l_ac].icd02 != g_icd_t.icd02 OR g_icd_t.icd02 IS NULL) THEN                                              
                  SELECT count(*) INTO l_n FROM icd_file                                                                            
                   WHERE icd01 = g_icd[l_ac].icd01                                                                                  
                     AND icd02 = g_icd[l_ac].icd02                                                                                  
                  IF l_n > 0 THEN                                                                                                   
                      CALL cl_err('',-239,0)                                                                                        
                      LET g_icd[l_ac].icd02 = g_icd_t.icd02                                                                         
                      NEXT FIELD icd02                                                                                              
                  END IF   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD icdacti                                                                                                         
           IF NOT cl_null(g_icd[l_ac].icdacti) THEN                                                                                 
              IF g_icd[l_ac].icdacti NOT MATCHES '[YN]' OR                                                                          
                 cl_null(g_icd[l_ac].icdacti) THEN                                                                                  
                 LET g_icd[l_ac].icdacti = g_icd_t.icdacti                                                                          
                 NEXT FIELD icdacti                                                                                                 
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        BEFORE DELETE                            #是否取消單身                                                                      
            IF g_icd_t.icd01 IS NOT NULL THEN                                                                                       
               IF NOT cl_delete() THEN                                                                                              
                  CANCEL DELETE                                                                                                     
               END IF                                                                                                               
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "icd01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_icd[l_ac].icd01      #No.FUN-9B0098 10/02/24
               LET g_doc.column2 = "icd02"               #No.FUN-9B0098 10/02/24
               LET g_doc.value2 = g_icd[l_ac].icd02      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                                                                                                                                            #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN                                                                                              
                  CALL cl_err("", -263, 1)                                                                                          
                  CANCEL DELETE                                                                                                     
               END IF                                                                                                               
               DELETE FROM icd_file WHERE icd01 = g_icd_t.icd01
                                      AND icd02 = g_icd_t.icd02                                              
               IF SQLCA.sqlcode THEN                                                                                                
                  CALL cl_err3("del","icd_file",g_icd_t.icd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131                             
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
              LET g_icd[l_ac].* = g_icd_t.*                                                                                         
              CLOSE i003_bcl                                                                                                        
              ROLLBACK WORK                                                                                                         
              EXIT INPUT                                                                                                            
           END IF                                                                                                                   
           IF l_lock_sw="Y" THEN                                                                                                    
               CALL cl_err(g_icd[l_ac].icd01,-263,0)                                                                                
               LET g_icd[l_ac].* = g_icd_t.*         
           ELSE                                                                                                                     
               UPDATE icd_file                                                                                                      
                  SET icd01=g_icd[l_ac].icd01,icd02=g_icd[l_ac].icd02,                                                              
                      icd03=g_icd[l_ac].icd03,icdacti=g_icd[l_ac].icdacti,                                                          
                      icdmodu=g_user,icddate=g_today                                                                                
                WHERE icd01=g_icd_t.icd01                                                                                           
                  AND icd02=g_icd_t.icd02                                                                                           
               IF SQLCA.sqlcode THEN                                                                                                
                   CALL cl_err3("upd","icd_file",g_icd_t.icd01,g_icd_t.icd02,SQLCA.sqlcode,"","",1)  #No.FUN-660131                 
                   LET g_icd[l_ac].* = g_icd_t.*                                                                                    
               ELSE                                                                                                                 
                   MESSAGE 'UPDATE O.K'                                                                                             
                   COMMIT WORK                                                                                                      
               END IF                                                                                                               
           END IF                                                                                                                   
                                                                                                                                    
        AFTER ROW                                                                                                                   
           LET l_ac = ARR_CURR()         # 新增  
          #LET l_ac_t = l_ac             # 新增 #FUN-D40030 mark
                                                                                                                                    
           IF INT_FLAG THEN                                                                                                         
              CALL cl_err('',9001,0)                                                                                                
              LET INT_FLAG = 0                                                                                                      
              IF p_cmd='u' THEN                                                                                                     
                 LET g_icd[l_ac].* = g_icd_t.*                                                                                      
             #FUN-D40030--add--str
              ELSE
                 CALL g_icd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF 
             #FUN-D40030--add--end
              END IF                                                                                                                
              CLOSE i003_bcl             # 新增                                                                                      
              ROLLBACK WORK              # 新增                                                                                          
              EXIT INPUT                                                                                                            
           END IF                                                                                                                   
           LET l_ac_t = l_ac #FUN-D40030 add
           CLOSE i003_bcl                # 新增                                                                                         
           COMMIT WORK                                                                                                              
                                                                                                                                    
        ON ACTION CONTROLO                        #沿用所有欄位           
            IF INFIELD(icd01) AND l_ac > 1 THEN                                                                                     
                LET g_icd[l_ac].* = g_icd[l_ac-1].*                                                                                 
                NEXT FIELD icd01                                                                                                    
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
                                                                                                                                    
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121 
      ON ACTION help          #MOD-4C0121                                                                                           
         CALL cl_show_help()  #MOD-4C0121                                                                                           
                                                                                                                                    
                                                                                                                                    
        END INPUT                                                                                                                   
                                                                                                                                    
                                                                                                                                    
    CLOSE i003_bcl                                                                                                                  
    COMMIT WORK                                                                                                                     
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_b_askkey()                                                                                                            
    CLEAR FORM                                                                                                                      
    CALL g_icd.clear()                                                                                                               
    CONSTRUCT g_wc2 ON icd01,icd02,icd03,icdacti                                                                                    
         FROM s_icd[1].icd01,s_icd[1].icd02,s_icd[1].icd03,s_icd[1].icdacti                                                         
              BEFORE CONSTRUCT                                                                                                      
                 CALL cl_qbe_init()                                                                                                 
       ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()        
          CONTINUE CONSTRUCT   
 
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION help          #MOD-4C0121                                                                                           
         CALL cl_show_help()  #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION controlg      #MOD-4C0121                                                                                           
         CALL cl_cmdask()     #MOD-4C0121                                                                                           
 
      ON ACTION qbe_select                                                                                               
         CALL cl_qbe_select()                                                                                             
      ON ACTION qbe_save                                                                                                 
         CALL cl_qbe_save()                                                                                               
    END CONSTRUCT                                                                                                                   
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('icduser', 'icdgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF                                                                                 
    CALL i003_b_fill(g_wc2)                                                                                                         
END FUNCTION 
 
FUNCTION i003_b_fill(p_wc2)                                                                                  
DEFINE                                                                                                                              
    #p_wc2           LIKE type_file.chr1000
    p_wc2           STRING         #NO.FUN-910082                                                             
                                                                                                                                    
    LET g_sql =                                                                                                                     
        "SELECT icd01,icd02,icd03,icdacti",                                                                                         
        " FROM icd_file",                                                                                                           
        " WHERE ", p_wc2 CLIPPED,                     #單身                                                                         
        " ORDER BY icd02,icd01"                                                                                                     
    PREPARE i003_pb FROM g_sql                                                                                                      
    DECLARE icd_curs CURSOR FOR i003_pb                                                                                             
                                                                                                                                    
    CALL g_icd.clear()                                                                                                              
                                                                                                                                    
    LET g_cnt = 1                                                                                                                   
    MESSAGE "Searching!"                                                                                                            
    FOREACH icd_curs INTO g_icd[g_cnt].*              #單身 ARRAY 填充                                                                         
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF                                                         
        LET g_cnt = g_cnt + 1                                                                                                       
        IF g_cnt > g_max_rec THEN                                                                                                   
           CALL cl_err( '', 9035, 0 )                                                                                               
           EXIT FOREACH                                                                                                             
        END IF     
    END FOREACH                                                                                                                     
    CALL g_icd.deleteElement(g_cnt)                                                                                                 
    MESSAGE ""                                                                                                                      
    LET g_rec_b = g_cnt-1                                                                                                           
    DISPLAY g_rec_b TO FORMONLY.cn2                                                                                                 
    LET g_cnt = 0                                                                                                                   
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_bp(p_ud)                                                                                                              
   DEFINE   p_ud   LIKE type_file.chr1                                                                                                       
                                                                                                                                    
                                                                                                                                    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
   DISPLAY ARRAY g_icd TO s_icd.* ATTRIBUTE(COUNT=g_rec_b)                                                                          
                                                                                                                                    
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf                                                                  
                                                                                                                                    
      ##########################################################################                                                    
      # Standard 4ad ACTION                                                                                                         
      ##########################################################################                                                    
      ON ACTION query                                                                                                               
         LET g_action_choice="query"                                                                                                
         EXIT DISPLAY                                                                                                               
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
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
             LET INT_FLAG=FALSE                 #MOD-570244     mars                                                                
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121                                                                                           
                                                                                                                                    
                                                                                                                                    
      ON ACTION related_document  #No.MOD-470515                                                                                   
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
 
FUNCTION i003_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                  
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("icd01,icd02",TRUE)                                                                                     
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i003_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                       
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("icd01,icd02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION          
#No.FUN-7B0074--end--           
