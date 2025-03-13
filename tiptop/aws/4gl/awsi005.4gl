# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: awsi005.4gl
# Descriptions...: 
# Date & Author..: 06/08/03 By yoyo
# Modify.........: 新建立 FUN-8A0122 binbin
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    m_waf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        waf01       LIKE waf_file.waf01,    
        waf02       LIKE waf_file.waf02,   
        waf03       LIKE waf_file.waf03                     
                    END RECORD,
    g_buf           LIKE type_file.chr50,
    m_waf_t         RECORD                 #程式變數 (舊值)
        waf01       LIKE waf_file.waf01,    
        waf02       LIKE waf_file.waf02,   
        waf03       LIKE waf_file.waf03                      
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num5   
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE g_argv1      LIKE waf_file.waf01
 
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
 
   OPEN WINDOW i005_w WITH FORM "aws/42f/awsi005"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #
   CALL cl_ui_init()
 
   LET g_argv1 = ARG_VAL(1)
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2="waf01 =","'",g_argv1,"'"
   ELSE
      LET g_wc2 = ' 1=1'
   END IF
 
   CALL i005_b_fill(g_wc2)
   CALL i005_menu()
 
   CLOSE WINDOW i005_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i005_menu()
 
   WHILE TRUE
      CALL i005_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i005_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i005_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_waf),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i005_q()
 
   CALL i005_b_askkey()
 
END FUNCTION
 
FUNCTION i005_b()
   DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,              #檢查重復用
          l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
          p_cmd           LIKE type_file.chr1,               #處理狀態
          l_allow_insert  LIKE type_file.num5,              #可新增否
          l_allow_delete  LIKE type_file.num5               #可刪除否
   DEFINE l_i             LIKE type_file.num5   
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT waf01,waf02,waf03",   
                      "  FROM waf_file WHERE waf01=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i005_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY m_waf WITHOUT DEFAULTS FROM s_waf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
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
            LET m_waf_t.* = m_waf[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i005_bcl USING m_waf_t.waf01
            IF STATUS THEN
               CALL cl_err("OPEN i005_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i005_bcl INTO m_waf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(m_waf_t.waf01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i005_set_entry(p_cmd)                                        
            CALL i005_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE m_waf[l_ac].* TO NULL      #900423
         LET m_waf_t.* = m_waf[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i005_set_entry(p_cmd)                                        
         CALL i005_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE
         CALL cl_show_fld_cont()    
         NEXT FIELD waf01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO waf_file(waf01,waf02,waf03)
              VALUES(m_waf[l_ac].waf01,m_waf[l_ac].waf02,  
                     m_waf[l_ac].waf03)
         IF SQLCA.sqlcode THEN
            CALL cl_err(m_waf[l_ac].waf01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD waf01              
         IF m_waf[l_ac].waf01 IS NOT NULL THEN
            IF m_waf[l_ac].waf01 != m_waf_t.waf01 OR
               (NOT cl_null(m_waf[l_ac].waf01) AND cl_null(m_waf_t.waf01)) THEN
               SELECT count(*) INTO l_n FROM waf_file
                WHERE waf01 = m_waf[l_ac].waf01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET m_waf[l_ac].waf01 = m_waf_t.waf01
                  NEXT FIELD waf01
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身                    
         IF m_waf_t.waf01 IS NOT NULL THEN                                    
            IF NOT cl_delete() THEN                                             
               CANCEL DELETE                                                    
            END IF                                                              
            IF l_lock_sw = "Y" THEN                                             
               CALL cl_err("", -263, 1)                                         
               CANCEL DELETE                                                    
            END IF                                                              
            DELETE FROM waf_file WHERE waf01 = m_waf_t.waf01                  
            IF SQLCA.sqlcode THEN                                               
               CALL cl_err(m_waf_t.waf01,SQLCA.sqlcode,0)                     
               ROLLBACK WORK                                                    
               CANCEL DELETE                                                    
            END IF                                                              
            LET g_rec_b=g_rec_b-1                                               
            DISPLAY g_rec_b TO FORMONLY.cn2                                     
            MESSAGE "Delete OK"                                                 
            CLOSE i005_bcl                                                      
            COMMIT WORK                                                         
         END IF      
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_waf[l_ac].* = m_waf_t.*
            CLOSE i005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(m_waf[l_ac].waf01,-263,1)
            LET m_waf[l_ac].* = m_waf_t.*
         ELSE
            UPDATE waf_file SET
                   waf01=m_waf[l_ac].waf01,waf02=m_waf[l_ac].waf02,
                   waf03=m_waf[l_ac].waf03
             WHERE waf01 = m_waf_t.waf01
            IF SQLCA.sqlcode THEN
               CALL cl_err(m_waf[l_ac].waf01,SQLCA.sqlcode,0)
               LET m_waf[l_ac].* = m_waf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i005_bcl
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
               LET m_waf[l_ac].* = m_waf_t.*
            END IF
            CLOSE i005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i005_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(waf01) AND l_ac > 1 THEN
            LET m_waf[l_ac].* = m_waf[l_ac-1].*
            NEXT FIELD waf01
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
 
   CLOSE i005_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i005_b_askkey()
 
   CLEAR FORM
   CALL m_waf.clear()
 
   CONSTRUCT g_wc2 ON waf01,waf02,waf03   
           FROM s_waf[1].waf01,s_waf[1].waf02,s_waf[1].waf03
 
      ON ACTION controlp
         IF INFIELD(waf01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_waf"
            LET g_qryparam.default1 = m_waf[1].waf01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            IF NOT cl_null(g_qryparam.multiret) THEN
            DISPLAY g_qryparam.multiret TO waf01
            END IF
            NEXT FIELD waf01
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
 
   CALL i005_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i005_b_fill(p_wc2)              #BODY FILL UP
   DEFINE 
      #p_wc2   LIKE type_file.chr200
      p_wc2        STRING       #NO.FUN-910082
 
   LET g_sql = "SELECT waf01,waf02,waf03",   
               "  FROM waf_file",
               " WHERE ", p_wc2 CLIPPED,         
               " ORDER BY waf01"
   PREPARE i005_pb FROM g_sql
   DECLARE waf_curs CURSOR FOR i005_pb
 
   CALL m_waf.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH waf_curs INTO m_waf[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL m_waf.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i005_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_waf TO s_waf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i005_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd='a' AND  ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("waf01",TRUE)
    END IF  
 
END FUNCTION  
               
FUNCTION i005_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1           
                                                                                
 
    IF p_cmd='u' AND  ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("waf01",FALSE)
    END IF  
END FUNCTION           
#No.FUN-8A0122 
#FUN-B80064
