# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#                                                                                                                                   
# Pattern name...:aici022.4gl
# Descriptions...:ICD feature hold維護作業
# Date & Author..: 10/10/09 By jan No.FUN-AA0007
# Modify.........: No:FUN-AB0092 11/02/11 By jan Feature Hold Lot指定(aici022) 時，希望可以再指定到要鎖定的料件狀態
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE 
     g_ids           DYNAMIC ARRAY OF RECORD      #程式變量(Program Variables)
        ids01        LIKE ids_file.ids01,         #批號
        ids02        LIKE ids_file.ids02,         #hold type
        ids03        LIKE ids_file.ids03,         #目前狀態 #FUN-AB0092
        ids04        LIKE ids_file.ids04,         #目前狀態 #FUN-AB0092
        idsacti      LIKE ids_file.idsacti
                     END RECORD,
     g_ids_t         RECORD                       #程序變量（舊值）
        ids01        LIKE ids_file.ids01,         #批號
        ids02        LIKE ids_file.ids02,         #hold type
        ids03        LIKE ids_file.ids03,         #目前狀態 #FUN-AB0092
        ids04        LIKE ids_file.ids04,         #目前狀態 #FUN-AB0092
        idsacti      LIKE ids_file.idsacti
                     END RECORD,
      g_wc2,g_sql    STRING,
      g_rec_b        LIKE type_file.num5,         #單身筆數
      l_ac           LIKE type_file.num5          #目前處理的ARRAY CNT
  
DEFINE g_forupd_sql  STRING    #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt         LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5          #COUNT/index for any purpose
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE l_cmd         LIKE type_file.chr1000

MAIN
DEFINE l_time        LIKE type_file.chr8           #計算被使用時間
DEFINE p_row,p_col   LIKE type_file.num5      
    OPTIONS                                        #改變一些系統預設值                                                                 
       INPUT NO WRAP                               #輸入的方式: 不打轉                                                                      
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
    OPEN WINDOW i022_w AT p_row,p_col WITH FORM "aic/42f/aici022"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
                                                                                                                                    
    CALL cl_ui_init()                                                                                                               
                                                                                                                                    
    LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2)                                                                                       
    CALL i022_menu()                                                                                                                
    CLOSE WINDOW i022_w                  #結束畫面                                                                                   
    CALL  cl_used(g_prog,g_time,2)  RETURNING g_time   #計算使用時間 (退出使間)                                                                                                        
END MAIN                 
               
FUNCTION i022_menu()                                                                                                                
                                                                                                                                    
   WHILE TRUE                                                                                                                       
      CALL i022_bp("G")                                                                                                             
      CASE g_action_choice                                                                                                          
         WHEN "query"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i022_q()                                                                                                        
            END IF                                                                                                                  
         WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i022_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
            IF cl_null(g_wc2) THEN
               LET g_wc2=" 1=1"
            END IF
            LET l_cmd='p_query "aici022" "',g_wc2 CLIPPED,'"'
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
               IF g_ids[l_ac].ids01 IS NOT NULL THEN                                                                                
                  LET g_doc.column1 = "ids01"                                                                                       
                  LET g_doc.value1 = g_ids[l_ac].ids01                                                                                                                                                         
                  CALL cl_doc()                                                                                                     
               END IF                                                                                                               
            END IF                                                                                                                  
         WHEN "exporttoexcel"                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ids),'','')                                 
            END IF                                                                                                                  
                                                                                                                                    
      END CASE                                                                                                                      
   END WHILE                                                                                                                        
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i022_q()       
   CALL i022_b_askkey()                                                                                                             
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i022_b()                                                                                                                   
DEFINE                                                                                                                              
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   
    l_n             LIKE type_file.num5,                #檢查重復用                          
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                          
    p_cmd           LIKE type_file.chr1,                #處理狀態                              
    l_allow_insert  LIKE type_file.chr1,                #可新增否                                             
    l_allow_delete  LIKE type_file.chr1                 #可刪除否                                            
DEFINE l_img01      LIKE img_file.img01                 #FUN-AB0092
                                                                                                                                    
    IF s_shut(0) THEN RETURN END IF                                                                                                 
    CALL cl_opmsg('b')                                                                                                              
    LET g_action_choice = ""                                                                                                        
                                                                                                                                    
    LET l_allow_insert = cl_detail_input_auth('insert')                                                                             
    LET l_allow_delete = cl_detail_input_auth('delete')                                                                             
                                                                                                                                    
    LET g_forupd_sql = "SELECT ids01,ids02,ids03,ids04,idsacti FROM ids_file",     #FUN-AB0092                                                       
                       " WHERE ids01=?  FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                                                                    
    DECLARE i022_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR                                                                    
                                                                                                                                    
    INPUT ARRAY g_ids WITHOUT DEFAULTS FROM s_ids.*

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
               CALL i022_set_entry(p_cmd)                                                                                           
               CALL i022_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE           
               LET g_ids_t.* = g_ids[l_ac].*  #BACKUP                                                                               
               OPEN i022_bcl USING g_ids_t.ids01                                                              
               IF STATUS THEN                                                                                                       
                  CALL cl_err("OPEN i022_bcl:", STATUS, 1)                                                                          
                  LET l_lock_sw = "Y"                                                                                               
               ELSE                                                                                                                 
                  FETCH i022_bcl INTO g_ids[l_ac].*                                                                                 
                  IF SQLCA.sqlcode THEN                                                                                             
                     CALL cl_err(g_ids_t.ids01,SQLCA.sqlcode,1)                                                                     
                     LET l_lock_sw = "Y"                                                                                            
                  END IF                                                                                                            
               END IF                                                                                                               
               CALL cl_show_fld_cont()                                                        
            END IF                                                                                                                  
                                                                                                                                    
        BEFORE INSERT                                                                                                               
           LET l_n = ARR_COUNT()                                                                                                    
           LET p_cmd='a'                                                                                                            
           LET g_before_input_done = FALSE                                                                                          
           CALL i022_set_entry(p_cmd)                                                                                               
           CALL i022_set_no_entry(p_cmd)  
           INITIALIZE g_ids[l_ac].* TO NULL 
           LET g_ids[l_ac].ids02 = '1'
           LET g_ids[l_ac].idsacti = 'Y'
           LET g_ids_t.* = g_ids[l_ac].*         #新輸入資料                                                                        
           CALL cl_show_fld_cont()                                             
           NEXT FIELD ids01                                                                                                         
                                                                                                                                    
        AFTER INSERT                                                                                                                
           IF INT_FLAG THEN                                                                                                         
              CALL cl_err('',9001,0)                                                                                                
              LET INT_FLAG = 0
              CLOSE i022_bcl
              CANCEL INSERT
           END IF
          IF cl_null(g_ids[l_ac].ids03) THEN LET g_ids[l_ac].ids03='W' END IF  #FUN-AB0092
	  IF cl_null(g_ids[l_ac].ids04) THEN LET g_ids[l_ac].ids04=' ' END IF  #FUN-AB0092
           INSERT INTO ids_file(ids01,ids02,ids03,ids04,idsacti,idsuser,idsdate,idsgrup,idsoriu,idsorig)  #FUN-AB0092
           VALUES(g_ids[l_ac].ids01,g_ids[l_ac].ids02,g_ids[l_ac].ids03,                    #FUN-AB0092    
                  g_ids[l_ac].ids04,g_ids[l_ac].idsacti,g_user,g_today,g_grup,g_user,g_grup)#FUN-AB0092                                             
           IF SQLCA.sqlcode THEN                                                                                                    
              CALL cl_err3("ins","ids_file",g_ids[l_ac].ids01,"",SQLCA.sqlcode,"","",1)                            
              CANCEL INSERT                                                                                                         
           ELSE                                                                                                                     
              MESSAGE 'INSERT O.K'          
              LET g_rec_b=g_rec_b+1                                                                                                 
              DISPLAY g_rec_b TO FORMONLY.cn2                                                                                       
              COMMIT WORK                                                                                                           
           END IF                                                                                                                   
        
        AFTER FIELD ids01
           IF NOT cl_null(g_ids[l_ac].ids01) THEN               
              IF g_ids_t.ids01 <> g_ids[l_ac].ids01 OR
                 g_ids_t.ids01 IS NULL THEN
                 SELECT count(*) INTO l_n FROM ids_file
                  WHERE ids01=g_ids[l_ac].ids01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)                                                                                        
                    LET g_ids[l_ac].ids01 = g_ids_t.ids01                                                                         
                    NEXT FIELD ids01 
                 END IF
                 #FUN-AB0092--begin--add----------
                 DECLARE img_curs CURSOR FOR
                   SELECT img01 FROM img_file WHERE img04=g_ids[l_ac].ids01
                 FOREACH img_curs INTO l_img01
                   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF 
                   SELECT imaicd04 INTO g_ids[l_ac].ids03
                     FROM imaicd_file
                    WHERE imaicd00=l_img01
                 END FOREACH
                 IF cl_null(g_ids[l_ac].ids03) THEN LET g_ids[l_ac].ids03='W' END IF
                 #FUN-AB0092--end--add------------
               END IF
           END IF
                                                                                                                   
        #FUN-AB0092--begin--add----------
        AFTER FIELD ids04                                                                                                           
           IF NOT cl_null(g_ids[l_ac].ids04) THEN                                                                                   
              IF g_ids[l_ac].ids02 NOT MATCHES '[01234]' THEN                                            
                 CALL cl_err(g_ids[l_ac].ids04,'aoo-109',1)                                                                         
                 NEXT FIELD ids04                                                                                                   
              END IF                                                                                                                                                                                                                       
           END IF      

        BEFORE FIELD ids02
          CALL cl_set_comp_entry("ids04",TRUE)
        #FUN-AB0092--end--add-------------------                                                                                                          
                                                                                                                   
        AFTER FIELD ids02                                                                                                           
           IF NOT cl_null(g_ids[l_ac].ids02) THEN                                                                                   
              IF g_ids[l_ac].ids02 NOT MATCHES '[12]' THEN                                            
                 CALL cl_err(g_ids[l_ac].ids02,'aoo-109',1)                                                                         
                 NEXT FIELD ids02                                                                                                   
              END IF                                                                                                                                                                                                                       
              #FUN-AB0092--begin--add---------
              IF g_ids[l_ac].ids02='1' THEN
                 CALL cl_set_comp_entry("ids04",FALSE)
                 LET g_ids[l_ac].ids04=' '
              END IF                                                                                                                
              #FUN-AB0092--end--add----------
           END IF                                                                                                                
                                                                                                                                    
        BEFORE DELETE                            #是否取消單身                                                                      
            IF g_ids_t.ids01 IS NOT NULL THEN                                                                                       
               IF NOT cl_delete() THEN                                                                                              
                  CANCEL DELETE                                                                                                     
               END IF                                                                                                               
               INITIALIZE g_doc.* TO NULL  
               LET g_doc.column1 = "ids01" 
               LET g_doc.value1 = g_ids[l_ac].ids01
               CALL cl_del_doc()                                                                                                                                                            #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN                                                                                              
                  CALL cl_err("", -263, 1)                                                                                          
                  CANCEL DELETE                                                                                                     
               END IF                                                                                                               
               DELETE FROM ids_file WHERE ids01 = g_ids_t.ids01                                            
               IF SQLCA.sqlcode THEN                                                                                                
                  CALL cl_err3("del","ids_file",g_ids_t.ids01,"",SQLCA.sqlcode,"","",1)                          
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
              LET g_ids[l_ac].* = g_ids_t.*                                                                                         
              CLOSE i022_bcl                                                                                                        
              ROLLBACK WORK                                                                                                         
              EXIT INPUT                                                                                                            
           END IF                                                                                                                   
           IF l_lock_sw="Y" THEN                                                                                                    
               CALL cl_err(g_ids[l_ac].ids01,-263,0)                                                                                
               LET g_ids[l_ac].* = g_ids_t.*         
           ELSE                                                                                                                     
               UPDATE ids_file                                                                                                      
                  SET ids01=g_ids[l_ac].ids01,ids02=g_ids[l_ac].ids02,
                      ids03=g_ids[l_ac].ids03,ids04=g_ids[l_ac].ids04, #FUN-AB0092
                      idsacti=g_ids[l_ac].idsacti,
                      idsmodu=g_user,
                      idsdate=g_today                                                                        
                WHERE ids01=g_ids_t.ids01                                                                                                                                                                                      
               IF SQLCA.sqlcode THEN                                                                                                
                   CALL cl_err3("upd","ids_file",g_ids_t.ids01,g_ids_t.ids02,SQLCA.sqlcode,"","",1)              
                   LET g_ids[l_ac].* = g_ids_t.*                                                                                    
               ELSE                                                                                                                 
                   MESSAGE 'UPDATE O.K'                                                                                             
                   COMMIT WORK                                                                                                      
               END IF                                                                                                               
           END IF                                                                                                                   
                                                                                                                                    
        AFTER ROW                                                                                                                   
           LET l_ac = ARR_CURR()         # 新增  
          #LET l_ac_t = l_ac             # 新增 #FUN-D40030mark                                                                                     
                                                                                                                                    
           IF INT_FLAG THEN                                                                                                         
              CALL cl_err('',9001,0)                                                                                                
              LET INT_FLAG = 0                                                                                                      
              IF p_cmd='u' THEN                                                                                                     
                 LET g_ids[l_ac].* = g_ids_t.*                                                                                      
             #FUN-D40030--add--str
              ELSE
                 CALL g_ids.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #FUN-D40030--add--end
              END IF                                                                                                                
              CLOSE i022_bcl             # 新增                                                                                      
              ROLLBACK WORK              # 新增                                                                                          
              EXIT INPUT                                                                                                            
           END IF                                                                                                                   
           LET l_ac_t = l_ac             # 新增 #FUN-D40030 add
           CLOSE i022_bcl                # 新增                                                                                         
           COMMIT WORK   
                                                                                                                      
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(ids01)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_img3"
                 LET g_qryparam.default1 = g_ids[l_ac].ids01
                 CALL cl_create_qry() RETURNING g_ids[l_ac].ids01
                 DISPLAY BY NAME g_ids[l_ac].ids01
                 NEXT FIELD ids01 
           END CASE
                                                                                                                                     
        ON ACTION CONTROLO                        #沿用所有欄位           
            IF INFIELD(ids01) AND l_ac > 1 THEN                                                                                     
                LET g_ids[l_ac].* = g_ids[l_ac-1].*                                                                                 
                NEXT FIELD ids01                                                                                                    
            END IF                                                                                                                  
                                                                                                                                    
        ON ACTION CONTROLR                                                                                                          
           CALL cl_show_req_fields()                                                                                                
                                                                                                                                    
        ON ACTION CONTROLG                                                                                                          
            CALL cl_cmdask()                                                                                                        
                                                                                                                                    
        ON ACTION CONTROLF                                                                                                          
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name                     
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913                                                               
                                                                                                                                    
        ON IDLE g_idle_seconds                                                                                                   
           CALL cl_on_idle()                                                                                                     
           CONTINUE INPUT                                                                                                        
                                                                                                                                    
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121 
      ON ACTION help          #MOD-4C0121                                                                                           
         CALL cl_show_help()  #MOD-4C0121                                                                                           
                                                                                                                                    
                                                                                                                                    
        END INPUT                                                                                                                   
                                                                                                                                    
                                                                                                                                    
    CLOSE i022_bcl                                                                                                                  
    COMMIT WORK                                                                                                                     
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i022_b_askkey()                                                                                                            
    CLEAR FORM                                                                                                                      
    CALL g_ids.clear()                                                                                                               
    CONSTRUCT g_wc2 ON ids01,ids02,ids03,ids04,idsacti            #FUN-AB0092                                                                    
         FROM s_ids[1].ids01,s_ids[1].ids02,s_ids[1].ids03,s_ids[1].ids04,s_ids[1].idsacti #FUN-AB0092                                                      
              BEFORE CONSTRUCT                                                                                                      
                 CALL cl_qbe_init() 
                                                                                                                
      ON IDLE g_idle_seconds                                                                                                       
         CALL cl_on_idle()        
         CONTINUE CONSTRUCT   

      ON ACTION controlp
         CASE
           WHEN INFIELD(ids01) 
             CALL cl_init_qry_var() 
             LET g_qryparam.form = "q_img3" 
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             DISPLAY g_qryparam.multiret TO ids01 
             NEXT FIELD ids01
         END CASE
         
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('idsuser','idsrup')                                                                                                                 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF                                                                                 
    CALL i022_b_fill(g_wc2)                                                                                                         
END FUNCTION 

FUNCTION i022_b_fill(p_wc2)                                                                                  
DEFINE                                                                                                                              
    #p_wc2           LIKE type_file.chr1000
    p_wc2           STRING         #NO.FUN-910082                                                             
                                                                                                                                    
    LET g_sql =                                                                                                                     
        "SELECT ids01,ids02,ids03,ids04,idsacti",     #FUN-AB0092                                                                                    
        " FROM ids_file",                                                                                                           
        " WHERE ", p_wc2 CLIPPED,                     #單身                                                                         
        " ORDER BY ids01"                                                                                                     
    PREPARE i022_pb FROM g_sql                                                                                                      
    DECLARE ids_curs CURSOR FOR i022_pb                                                                                             
                                                                                                                                    
    CALL g_ids.clear()                                                                                                              
                                                                                                                                    
    LET g_cnt = 1                                                                                                                                                                                                                              
    FOREACH ids_curs INTO g_ids[g_cnt].*              #單身 ARRAY 填充                                                                         
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF                                                         
        LET g_cnt = g_cnt + 1                                                                                                       
        IF g_cnt > g_max_rec THEN                                                                                                   
           CALL cl_err( '', 9035, 0 )                                                                                               
           EXIT FOREACH                                                                                                             
        END IF     
    END FOREACH                                                                                                                     
    CALL g_ids.deleteElement(g_cnt)                                                                                                 
    MESSAGE ""                                                                                                                      
    LET g_rec_b = g_cnt-1                                                                                                           
    DISPLAY g_rec_b TO FORMONLY.cn2                                                                                                 
    LET g_cnt = 0                                                                                                                   
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i022_bp(p_ud)                                                                                                              
   DEFINE   p_ud   LIKE type_file.chr1                                                                                                       
                                                                                                                                    
                                                                                                                                    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
   DISPLAY ARRAY g_ids TO s_ids.* ATTRIBUTE(COUNT=g_rec_b)                                                                          
                                                                                                                                    
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf                                                                  
                                                                                                                                    
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
                                                                                                                                    
                                                                                                                                    
      ON ACTION related_document  #No:MOD-470515                                                                                   
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

FUNCTION i022_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                  
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("ids01,ids02,ids04",TRUE)          #FUN-AB0092                                                                           
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i022_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                       
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ids01,ids02,ids04",FALSE)         #FUN-AB0092                                                                                  
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION          
#FUN-AA0007           
