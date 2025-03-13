# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: awsi003.4gl
# Descriptions...: 
# Date & Author..: 06/08/03 By yoyo
# Modify.........: 新建立 FUN-8A0122 by binbin
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    m_wac           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        wac01       LIKE wac_file.wac01,    
        wac02       LIKE wac_file.wac02,   
        gat03       LIKE gat_file.gat03,   
        wac03       LIKE wac_file.wac03,                      
        gaq03       LIKE gaq_file.gaq03,                      
        wac04       LIKE wac_file.wac04,                      
        wac05       LIKE wac_file.wac05,  
        wac06       LIKE wac_file.wac06,  
        wac07       LIKE wac_file.wac07,  
        wac08       LIKE wac_file.wac08,                  
        wac09       LIKE wac_file.wac09,    
        wac10       LIKE wac_file.wac10,     
        wac11       LIKE wac_file.wac11,    
        wac12       LIKE wac_file.wac12,    
        wac13       LIKE wac_file.wac13,                  
#        wac14       LIKE wac_file.wac14,                  
        wac15       LIKE wac_file.wac15                  
                    END RECORD,
    g_buf           LIKE type_file.chr50,
    m_wac_t         RECORD                 #程式變數 (舊值)
        wac01       LIKE wac_file.wac01,    
        wac02       LIKE wac_file.wac02,   
        gat03       LIKE gat_file.gat03,   
        wac03       LIKE wac_file.wac03,                      
        gaq03       LIKE gaq_file.gaq03,                      
        wac04       LIKE wac_file.wac04,                      
        wac05       LIKE wac_file.wac05,  
        wac06       LIKE wac_file.wac06,  
        wac07       LIKE wac_file.wac07,  
        wac08       LIKE wac_file.wac08,                  
        wac09       LIKE wac_file.wac09,    
        wac10       LIKE wac_file.wac10,     
        wac11       LIKE wac_file.wac11,    
        wac12       LIKE wac_file.wac12,    
        wac13       LIKE wac_file.wac13,                  
#        wac14       LIKE wac_file.wac14,                  
        wac15       LIKE wac_file.wac15                  
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num5  
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE g_argv1      LIKE wac_file.wac01
DEFINE g_cmd        STRING
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i003_w WITH FORM "aws/42f/awsi003"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #
   CALL cl_ui_init()
 
   LET g_argv1 = ARG_VAL(1)
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2="wac01 =","'",g_argv1,"'"
   ELSE
      LET g_wc2 = ' 1=1'
   END IF
 
   CALL i003_b_fill(g_wc2)
 
   CALL i003_menu()
 
   CLOSE WINDOW i003_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
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
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_wac),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i003_q()
 
   CALL i003_b_askkey()
 
END FUNCTION
 
FUNCTION i003_b()
   DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,              #檢查重復用
          l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
          p_cmd           LIKE type_file.chr1,               #處理狀態
          l_allow_insert  LIKE type_file.num5,              #可新增否
          l_allow_delete  LIKE type_file.num5               #可刪除否
   DEFINE l_i             LIKE type_file.num5   
   DEFINE l_wac02         STRING
   DEFINE l_wac03         STRING
   DEFINE l_wac07         LIKE wac_file.wac07               #FUN-A90024為了目前長度有小數點型式(如:20,6),所以改變資料型態 (原本:LIKE type_file.num5)
   DEFINE m_wac02         LIKE wac_file.wac02
   DEFINE m_wac03         LIKE wac_file.wac03
   DEFINE l_datatype      LIKE type_file.chr20              #FUN-A90024
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT wac01,wac02,gat03,wac03,gaq03,wac04,wac05,wac06,",   
                      "       wac07,wac08,wac09,wac10,wac11,wac12,",
                      "       wac13,wac14,wac15 ",
                      "  FROM wac_file,gat_file,gaq_file WHERE ",
                      " gat01=wac02 AND gaq01=wac03 AND gat02='",g_lang,"' AND gaq02='",g_lang,"' AND",
                      " wac01=? AND wac02=? AND wac03=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL cl_query_prt_temptable()     #No.FUN-A90024
 
   INPUT ARRAY m_wac WITHOUT DEFAULTS FROM s_wac.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("wac07",FALSE )
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET m_wac_t.* = m_wac[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i003_bcl USING m_wac_t.wac01,m_wac_t.wac02,m_wac_t.wac03
            IF STATUS THEN
               CALL cl_err("OPEN i003_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i003_bcl INTO m_wac[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(m_wac_t.wac01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i003_set_entry(p_cmd)                                        
            CALL i003_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE m_wac[l_ac].* TO NULL      #900423
         LET m_wac_t.* = m_wac[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i003_set_entry(p_cmd)                                        
         CALL i003_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE
         LET m_wac[l_ac].wac08= 'N'
         LET m_wac[l_ac].wac09= 'N'
         LET m_wac[l_ac].wac10= 'N'
         CALL cl_show_fld_cont()    
         NEXT FIELD wac01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO wac_file(wac01,wac02,wac03,wac04,
                              wac05,wac06,wac07,wac08,
                              wac09,wac10,wac11,wac12,
                              wac13,wac14,wac15)
              VALUES(m_wac[l_ac].wac01,m_wac[l_ac].wac02,  
                     m_wac[l_ac].wac03,m_wac[l_ac].wac04,
                     m_wac[l_ac].wac05,m_wac[l_ac].wac06,
                     m_wac[l_ac].wac07,m_wac[l_ac].wac08,
                     m_wac[l_ac].wac09,m_wac[l_ac].wac10,
                     m_wac[l_ac].wac11,m_wac[l_ac].wac12,
                     m_wac[l_ac].wac13,'',
                     m_wac[l_ac].wac15)
         IF SQLCA.sqlcode THEN
            CALL cl_err(m_wac[l_ac].wac01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD wac01              
         IF m_wac[l_ac].wac01 IS NOT NULL THEN
            IF m_wac[l_ac].wac01 != m_wac_t.wac01 OR
               (NOT cl_null(m_wac[l_ac].wac01) AND cl_null(m_wac_t.wac01)) THEN
               SELECT count(*) INTO l_n FROM waa_file
                WHERE waa01 = m_wac[l_ac].wac01
               IF l_n = 0 THEN
                  CALL cl_err('','mfg9329',0)
                  LET m_wac[l_ac].wac01 = m_wac_t.wac01
                  NEXT FIELD wac01
               END IF
            END IF
         END IF
 
      AFTER FIELD wac02              
         IF m_wac[l_ac].wac02 IS NOT NULL THEN
            IF m_wac[l_ac].wac02 != m_wac_t.wac02 OR
               (NOT cl_null(m_wac[l_ac].wac02) AND cl_null(m_wac_t.wac02)) THEN
                  SELECT count(*)
                    INTO l_n
                    FROM wab_file
                   WHERE wab01 = m_wac[l_ac].wac01
                     AND wab02 = m_wac[l_ac].wac02
                  IF l_n = 0 THEN
                     CALL cl_err('','mfg9329',0)
                     LET m_wac[l_ac].wac02 = m_wac_t.wac02
                     NEXT FIELD wac02
                  ELSE
                     SELECT gat03 INTO m_wac[l_ac].gat03
                       FROM gat_file
                      WHERE gat01 = m_wac[l_ac].wac02 AND gat02=g_lang
                     DISPLAY BY NAME m_wac[l_ac].gat03
                  END IF                  
            END IF
         END IF
 
      AFTER FIELD wac03
        IF m_wac[l_ac].wac03 IS NOT NULL THEN
          IF m_wac[l_ac].wac03 != m_wac_t.wac03 OR
               (NOT cl_null(m_wac[l_ac].wac03) AND cl_null(m_wac_t.wac03)) THEN
             SELECT count(*) INTO l_n from wac_file
              WHERE wac01 = m_wac[l_ac].wac01
                AND wac02 = m_wac[l_ac].wac02
                AND wac03 = m_wac[l_ac].wac03
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                NEXT FIELD wac03
             ELSE
                LET l_wac02 = m_wac[l_ac].wac02
                #LET l_wac02 = l_wac02.toUpperCase()    #FUN-A90024 mark
                LET m_wac02 =l_wac02
                LET l_wac03 = m_wac[l_ac].wac03
                #LET l_wac03 = l_wac03.toUpperCase()    #FUN-A90024 mark
                LET m_wac03 =l_wac03
                #---FUN-A90024---start-----
                #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
                #目前統一用sch_file紀錄TIPTOP資料結構
                #SELECT COUNT(*) INTO l_n FROM user_tab_columns WHERE
                #    table_name =m_wac02
                #    AND column_name=m_wac03
                SELECT COUNT(*) INTO l_n FROM sch_file 
                  WHERE sch01 = m_wac02
                    AND sch02 = m_wac03
                #---FUN-A90024---end------- 
                IF l_n > 0 THEN
                   LET m_wac[l_ac].wac04=m_wac[l_ac].wac03
                   SELECT gaq03 INTO  m_wac[l_ac].gaq03 FROM gaq_file WHERE gaq01=m_wac[l_ac].wac03 AND gaq02=g_lang
                   IF m_wac[l_ac].wac05 IS NULL AND m_wac[l_ac].gaq03 IS NOT NULL THEN
                      LET m_wac[l_ac].wac05=m_wac[l_ac].gaq03
                   END IF
                   LET m_wac[l_ac].wac11=m_wac[l_ac].wac05
                   LET m_wac[l_ac].wac06='C'
                   DISPLAY BY NAME m_wac[l_ac].wac03
                   DISPLAY BY NAME m_wac[l_ac].gaq03
                   DISPLAY BY NAME m_wac[l_ac].wac04
                   DISPLAY BY NAME m_wac[l_ac].wac05
                   DISPLAY BY NAME m_wac[l_ac].wac06
                   #---FUN-A90024---start-----
                   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
                   #目前統一用sch_file紀錄TIPTOP資料結構
                   #SELECT data_length INTO l_wac07 FROM user_tab_columns WHERE
                   #    table_name =m_wac02
                   #    AND column_name=m_wac03 

                   CALL cl_query_prt_getlength(m_wac03, 'N', 's', 0)
                   SELECT xabc06, xabc04 INTO l_datatype, l_wac07 FROM xabc 
                     WHERE xabc02 = m_wac03
                   #---FUN-A90024---end------- 
                   LET m_wac[l_ac].wac07 = l_wac07
                   DISPLAY BY NAME m_wac[l_ac].wac07
                   DISPLAY BY NAME m_wac[l_ac].wac11
                ELSE
                   CALL cl_err('','mfg9329',0)
                   LET m_wac[l_ac].wac03 = m_wac_t.wac03
                   NEXT FIELD wac03
                END IF
             END IF
          END IF
        END IF 
 
      AFTER FIELD wac05
        IF m_wac[l_ac].wac05 IS NOT NULL THEN
           LET m_wac[l_ac].wac11=m_wac[l_ac].wac05
           DISPLAY BY NAME m_wac[l_ac].wac05
           DISPLAY BY NAME m_wac[l_ac].wac11
        END IF 
 
      AFTER FIELD wac06 
         IF m_wac[l_ac].wac06 IS NOT NULL AND m_wac[l_ac].wac06='D' THEN
            LET m_wac[l_ac].wac07 = '8'
            DISPLAY BY NAME m_wac[l_ac].wac07
         END IF
 
      AFTER FIELD wac12 
         IF m_wac[l_ac].wac12 IS NOT NULL AND m_wac[l_ac].wac13 IS NOT NULL THEN
            IF m_wac[l_ac].wac12 > m_wac[l_ac].wac13 THEN
               CALL cl_err('','aws-354',0)
               NEXT FIELD wac12
            END IF
         END IF
 
      AFTER FIELD wac13                                                         
         IF m_wac[l_ac].wac12 IS NOT NULL AND m_wac[l_ac].wac13 IS NOT NULL THEN
            IF m_wac[l_ac].wac12 > m_wac[l_ac].wac13 THEN                       
               CALL cl_err('','aws-354',0)                                      
               NEXT FIELD wac13                                                 
            END IF                                                              
         END IF            
 
      BEFORE DELETE                            #是否取消單身                    
         IF m_wac_t.wac01 IS NOT NULL AND m_wac_t.wac02 IS NOT NULL
            AND m_wac_t.wac03 IS NOT NULL THEN                        
            IF NOT cl_delete() THEN                                             
               CANCEL DELETE                                                    
            END IF                                                              
            IF l_lock_sw = "Y" THEN                                             
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
            END IF                                                              
            DELETE FROM wac_file WHERE wac01 = m_wac_t.wac01 
                                   AND wac02 = m_wac_t.wac02
                                   AND wac03 = m_wac_t.wac03                    
            IF SQLCA.sqlcode THEN                                               
               CALL cl_err(m_wac_t.wac01,SQLCA.sqlcode,0)                       
               ROLLBACK WORK                                                    
               CANCEL DELETE                                                    
            END IF                                                              
            LET g_rec_b=g_rec_b-1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            MESSAGE "Delete OK"                                                 
            CLOSE i003_bcl                                                      
            COMMIT WORK                                                         
         END IF          
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_wac[l_ac].* = m_wac_t.*
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(m_wac[l_ac].wac01,-263,1)
            LET m_wac[l_ac].* = m_wac_t.*
         ELSE
            UPDATE wac_file SET
                   wac01=m_wac[l_ac].wac01,wac02=m_wac[l_ac].wac02,
                   wac03=m_wac[l_ac].wac03,wac04=m_wac[l_ac].wac04,
                   wac05=m_wac[l_ac].wac05,wac06=m_wac[l_ac].wac06,
                   wac08=m_wac[l_ac].wac08,wac09=m_wac[l_ac].wac09,
                   wac10=m_wac[l_ac].wac10,wac11=m_wac[l_ac].wac11,
                   wac12=m_wac[l_ac].wac12,wac13=m_wac[l_ac].wac13,
#                   wac14=m_wac[l_ac].wac14,
                   wac15=m_wac[l_ac].wac15
             WHERE wac01 = m_wac_t.wac01
               AND wac02 = m_wac_t.wac02
               AND wac03 = m_wac_t.wac03
            IF SQLCA.sqlcode THEN
               CALL cl_err(m_wac[l_ac].wac01,SQLCA.sqlcode,0)
               LET m_wac[l_ac].* = m_wac_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i003_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET m_wac[l_ac].* = m_wac_t.*
            END IF
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i003_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(wac01) AND l_ac > 1 THEN
            LET m_wac[l_ac].* = m_wac[l_ac-1].*
            NEXT FIELD wac01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         IF INFIELD(wac01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_waa"
            LET g_qryparam.default1 = m_wac[l_ac].wac01  
            CALL cl_create_qry() RETURNING m_wac[l_ac].wac01  
            IF NOT cl_null(m_wac[l_ac].wac01) THEN
            DISPLAY BY NAME m_wac[l_ac].wac01
            END IF           
            NEXT FIELD wac01
         END IF 
         IF INFIELD(wac02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_gat1"
            LET g_qryparam.default1 = m_wac[l_ac].wac02
            CALL cl_create_qry() RETURNING m_wac[l_ac].wac02
            IF NOT cl_null(m_wac[l_ac].wac02) THEN
            DISPLAY BY NAME m_wac[l_ac].wac02
            END IF           
            NEXT FIELD wac02  
         END IF 
          
 
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
 
   CLOSE i003_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i003_b_askkey()
 
   CLEAR FORM
   CALL m_wac.clear()
 
   CONSTRUCT g_wc2 ON wac01,wac02,wac03,wac04,wac05,wac06,wac07,    
                      wac08,wac09,wac10,wac11,wac12,wac13,wac15
           FROM s_wac[1].wac01,s_wac[1].wac02,s_wac[1].wac03,
                s_wac[1].wac04,s_wac[1].wac05,s_wac[1].wac06,
                s_wac[1].wac07,s_wac[1].wac08,s_wac[1].wac09,     
                s_wac[1].wac10,s_wac[1].wac11,s_wac[1].wac12,      
                s_wac[1].wac13,s_wac[1].wac15        
 
      ON ACTION controlp
         IF INFIELD(wac01) THEN                                                 
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_waa"                                       
            LET g_qryparam.default1 = m_wac[1].wac01                            
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            IF NOT cl_null(g_qryparam.multiret) THEN
            DISPLAY g_qryparam.multiret TO wac01                                
            END IF           
            NEXT FIELD wac01                                                    
         END IF       
 
         IF INFIELD(wac02) THEN                                                 
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_gat1"                                      
            LET g_qryparam.default1 = m_wac[1].wac02                            
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            IF NOT cl_null(g_qryparam.multiret) THEN
            DISPLAY g_qryparam.multiret TO wac02                                
            END IF           
            NEXT FIELD wac02                                                    
         END IF      
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()  
      
      ON ACTION help      
         CALL cl_show_help()  
      
      ON ACTION controlg    
         CALL cl_cmdask()    
    
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN 
   END IF
 
   CALL i003_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i003_b_fill(p_wc2)              #BODY FILL UP
   DEFINE 
      #p_wc2   LIKE type_file.chr200
      p_wc2         STRING       #NO.FUN-910082
 
   LET g_sql = "SELECT wac01,wac02,gat03,wac03,gaq03,wac04,wac05,wac06,",   
               "       wac07,wac08,wac09,wac10,wac11,wac12,", 
               "       wac13,wac15", 
               "  FROM wac_file,gat_file,gaq_file",
               " WHERE gat01=wac02 AND gaq01=wac03 AND gat02='",g_lang,
               "' AND gaq02='",g_lang,"' AND ", p_wc2 CLIPPED,         
               " ORDER BY wac01"
   PREPARE i003_pb FROM g_sql
   DECLARE wac_curs CURSOR FOR i003_pb
 
   CALL m_wac.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH wac_curs INTO m_wac[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL m_wac.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i003_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_wac TO s_wac.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               
 
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
   
      ON ACTION feldvalues
         IF l_ac>0 THEN 
            LET g_cmd = "awsi009  '",m_wac[l_ac].wac01,"' '",m_wac[l_ac].wac02,"' '",m_wac[l_ac].wac03,"'"
            CALL cl_cmdrun(g_cmd)
            LET g_action_choice = ''
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i003_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd='a' AND  ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("wac01,wac02,wac03",TRUE)
    END IF  
 
END FUNCTION  
               
FUNCTION i003_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1           
                                                                                
 
    IF p_cmd='u' AND  ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("wac01,wac02,wac03",FALSE)
    END IF  
END FUNCTION            
#No.FUN-8A0122 
