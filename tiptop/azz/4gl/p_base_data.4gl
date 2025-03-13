# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_base_data.4gl
# Descriptions...: 標準基本資料檔案清單檔
# Date & Author..: NO.FUN-930114 09/04/17 jamie 新增程式
# Modify.........: NO.FUN-930160 09/06/05 By Mandy 修改提示訊息
# Modify.........: No.TQC-960347 09/07/02 By Mandy UNLOAD 指令後面要加column-name的順序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0012 09/11/16 By Hiko 配合p_create_schema的做法,取得欄位方式和p_zta相同.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70028 10/05/28 by Hiko 增加SQL Server的判斷.
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_azs          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        azs01          LIKE azs_file.azs01,            
        gat03          LIKE gat_file.gat03,            
        azs02          LIKE azs_file.azs02,            
        azs03          LIKE azs_file.azs03,            
        azs04          LIKE azs_file.azs04        
                    END RECORD,
    g_azs_t         RECORD                 #程式變數 (舊值)
        azs01          LIKE azs_file.azs01,            
        gat03          LIKE gat_file.gat03,            
        azs02          LIKE azs_file.azs02,            
        azs03          LIKE azs_file.azs03,            
        azs04          LIKE azs_file.azs04        
                    END RECORD,
    g_wc2              STRING,
    g_sql              STRING,
    g_rec_b            LIKE type_file.num5,                                                  
    l_ac               LIKE type_file.num5                                                              
DEFINE g_forupd_sql          STRING                                               
DEFINE g_cnt                 LIKE type_file.num10                             
DEFINE g_before_input_done   LIKE type_file.num5                                            
DEFINE g_i                   LIKE type_file.num5                                                          
DEFINE g_on_change           LIKE type_file.num5                                           
DEFINE g_row_count           LIKE type_file.num5                         
DEFINE g_curs_index          LIKE type_file.num5                         
DEFINE g_str                 STRING                                       
DEFINE g_tempdir             STRING                                       
DEFINE g_show_msg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           type_1            LIKE type_file.chr20,              
           type_2            LIKE type_file.chr100,             
           type_3            LIKE type_file.chr100             
                            END RECORD
DEFINE g_msg                 LIKE ze_file.ze03                             
DEFINE g_msg2                LIKE type_file.chr1000                                         
DEFINE g_db_type STRING  #FUN-A70028
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW p_base_data_w WITH FORM "azz/42f/p_base_data"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    LET g_db_type = cl_db_get_database_type() #FUN-A70028

    LET g_wc2 = '1=1'
    CALL data_b_fill(g_wc2)
    CALL data_menu()
    CLOSE WINDOW data_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION data_menu()
   DEFINE l_cmd     STRING         
 
   WHILE TRUE
      CALL data_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL data_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL data_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
              #CALL data_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET l_cmd='p_query "p_base_data" "',g_wc2 CLIPPED,'" "',g_lang CLIPPED,'" '
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
               IF g_azs[l_ac].azs01 IS NOT NULL THEN
                  LET g_doc.column1 = "azs01"
                  LET g_doc.value1 = g_azs[l_ac].azs01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azs),'','')
            END IF
         WHEN "field_list"
            IF cl_chk_act_auth() THEN
               CALL field_list()
            END IF
         WHEN "file_download"
            IF cl_chk_act_auth() THEN
               CALL data_file()
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION data_q()
   CALL data_b_askkey()
END FUNCTION
 
FUNCTION data_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    v               string,
    l_gat01         LIKE gat_file.gat01
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT azs01,'',azs02,azs03,azs04",
                       "  FROM azs_file WHERE azs01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE data_bcl CURSOR FROM g_forupd_sql                      # LOCK CURSOR
 
    INPUT ARRAY g_azs WITHOUT DEFAULTS FROM s_azs.*
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
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE                                      
           CALL data_set_entry(p_cmd)                                           
           CALL data_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           LET g_azs_t.* = g_azs[l_ac].*  #BACKUP
           OPEN data_bcl USING g_azs_t.azs01
           IF STATUS THEN
              CALL cl_err("OPEN data_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH data_bcl INTO g_azs[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_azs_t.azs01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT gat03 INTO g_azs[l_ac].gat03 FROM gat_file
            WHERE gat01 = g_azs[l_ac].azs01 
              AND gat02 = g_lang
           CALL cl_show_fld_cont()     
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL data_set_entry(p_cmd)                                             
         CALL data_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_azs[l_ac].* TO NULL    
         LET g_azs_t.* = g_azs[l_ac].*       #新輸入資料
         LET g_azs[l_ac].azs02 = 'Y'
         LET g_azs[l_ac].azs03 = 'Y'
         LET g_azs[l_ac].azs04 = 'Y'
         CALL cl_show_fld_cont()            
         NEXT FIELD azs01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE data_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                   
 
        INSERT INTO azs_file(azs01,azs02,azs03,azs04)
               VALUES(g_azs[l_ac].azs01,g_azs[l_ac].azs02,
                      g_azs[l_ac].azs03,g_azs[l_ac].azs04)
                      
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","azs_file",g_azs[l_ac].azs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              
           CANCEL INSERT
        END IF
 
     AFTER FIELD azs01                    
        IF NOT cl_null(g_azs[l_ac].azs01) THEN
           IF g_azs[l_ac].azs01 != g_azs_t.azs01 OR
              g_azs_t.azs01 IS NULL THEN
              SELECT count(*) INTO l_n FROM azs_file
               WHERE azs01 = g_azs[l_ac].azs01
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_azs[l_ac].azs01 = g_azs_t.azs01
                  NEXT FIELD azs01
              END IF
              
              #FUN-A70082-----start---- 
              #SELECT gat01 INTO l_gat01 FROM gat_file
              # WHERE gat01 = g_azs[l_ac].azs01
              #   AND gat02 = g_lang
              SELECT DISTINCT(zta01) INTO l_gat01 FROM zta_file
                WHERE zta01 = g_azs[l_ac].azs01 AND zta02 = 'ds'
              #FUN-A70082-----end-----
 
              IF cl_null(l_gat01) THEN
                  CALL cl_err('','mfg9180',0)
                  LET g_azs[l_ac].azs01 = g_azs_t.azs01
                  NEXT FIELD azs01
              END IF
           END IF
           CALL data_azs01('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0) 
              NEXT FIELD azs01
           END IF
        END IF
 
     AFTER FIELD azs02
       IF g_azs[l_ac].azs02 NOT MATCHES "[YN]" THEN
          CALL cl_err('',9061,0) 
          NEXT FIELD azs02
       END IF 
 
     AFTER FIELD azs03
       IF g_azs[l_ac].azs03 NOT MATCHES "[YN]" THEN
          CALL cl_err('',9061,0) 
          NEXT FIELD azs03
       END IF 
 
     AFTER FIELD azs04
       IF g_azs[l_ac].azs04 NOT MATCHES "[YN]" THEN
          CALL cl_err('',9061,0) 
          NEXT FIELD azs04
       END IF 
 
     BEFORE DELETE                            #是否取消單身
         IF g_azs_t.azs01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "azs01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_azs[l_ac].azs01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
           ##TQC-6B0103---start---
           #IF (NOT cl_del_itemname("azs_file","azs02", g_azs_t.azs01)) THEN 
           #   ROLLBACK WORK
           #   RETURN
           #END IF
           ##TQC-6B0103---end---
            DELETE FROM azs_file WHERE azs01 = g_azs_t.azs01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","azs_file",g_azs_t.azs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
                EXIT INPUT
            END IF
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_azs[l_ac].* = g_azs_t.*
          CLOSE data_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_azs[l_ac].azs01,-263,0)
           LET g_azs[l_ac].* = g_azs_t.*
        ELSE
           UPDATE azs_file SET azs01=g_azs[l_ac].azs01,
                               azs02=g_azs[l_ac].azs02,
                               azs03=g_azs[l_ac].azs03,
                               azs04=g_azs[l_ac].azs04
           WHERE azs01 = g_azs_t.azs01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","azs_file",g_azs_t.azs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK   
              LET g_azs[l_ac].* = g_azs_t.*
           ELSE
             #IF g_azs[l_ac].azs03 <> g_azs_t.azs03 THEN
             #   SELECT COUNT(*) INTO l_n FROM cpf_file
             #    WHERE cpf01=g_azs[l_ac].azs01
             #   IF l_n > 0 THEN
             #      IF cl_confirm('aoo-106') THEN
             #         UPDATE cpf_file SET cpf29=g_azs[l_ac].azs03
             #          WHERE cpf01=g_azs[l_ac].azs01
             #         IF SQLCA.sqlcode THEN
             #            CALL cl_err3("upd","cpf_file",g_azs[l_ac].azs01,"",SQLCA.sqlcode,"","up cpf29:",1)  #No.FUN-660131
             #         END IF
             #      END IF
             #   END IF
             #END IF
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()                  
       #LET l_ac_t = l_ac           #FUN-D30034 mark           
 
        IF INT_FLAG THEN                        
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_azs[l_ac].* = g_azs_t.*
           #FUN-D30034--add--begin--
           ELSE
              CALL g_azs.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034--add--end----
           END IF
           CLOSE data_bcl                      
           ROLLBACK WORK                       
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE data_bcl                      
         COMMIT WORK
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(azs01) AND l_ac > 1 THEN
             LET g_azs[l_ac].* = g_azs[l_ac-1].*
             NEXT FIELD azs01
         END IF
 
     ON ACTION controlp
         CASE WHEN INFIELD(azs01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gat"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1 = g_azs[l_ac].azs01
                   CALL cl_create_qry() RETURNING g_azs[l_ac].azs01
                   DISPLAY g_azs[l_ac].azs01 TO azs01
                   CALL data_azs01('a')
              OTHERWISE
                   EXIT CASE
          END CASE
 
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
 
    #ON ACTION update_item
    #   IF g_aza.aza44 = "Y" THEN
    #      CALL GET_FLDBUF(azs02) RETURNING g_azs[l_ac].azs02
    #     #CALL p_itemname_update("azs_file","azs02",g_azs[l_ac].azs01)  #FUN-930114 mark #TQC-6C0060
    #      LET g_on_change=FALSE
    #      CALL cl_show_fld_cont()   #TQC-6C0060 
    #   ELSE
    #      CALL cl_err(g_azs[l_ac].azs01,"lib-151",1)
    #      LET g_cuelang = TRUE
    #   END IF
 
    END INPUT
 
    CLOSE data_bcl
    COMMIT WORK
END FUNCTION
 
 
 
FUNCTION data_azs01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1
 
    LET g_errno = ' '
    SELECT gat03 INTO g_azs[l_ac].gat03
      FROM gat_file
     WHERE gat01 = g_azs[l_ac].azs01
       AND gat02 = g_lang
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'aoo-005'
                            LET g_azs[l_ac].gat03 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION data_b_askkey()
    CLEAR FORM
    CALL g_azs.clear()
 
    CONSTRUCT g_wc2 ON azs01,azs02,azs03,azs04
         FROM s_azs[1].azs01,s_azs[1].azs02,s_azs[1].azs03,
              s_azs[1].azs04
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
     ON ACTION CONTROLP
         CASE WHEN INFIELD(azs01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gat"
                   LET g_qryparam.arg1  = g_lang
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_azs[l_ac].azs01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_azs[1].azs01
                   CALL data_azs01('a')
              OTHERWISE
                   EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL data_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION data_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
    LET g_sql = " SELECT azs01,gat03,azs02,azs03,azs04 ",
                  " FROM azs_file, OUTER gat_file ",
                 " WHERE azs_file.azs01 = gat_file.gat01  AND ", p_wc2 CLIPPED,           #單身
                   " AND gat_file.gat02 = '",g_lang,"' ",
                 " ORDER BY azs01 " 
 
    PREPARE data_pb FROM g_sql
    DECLARE azs_curs CURSOR FOR data_pb
 
    CALL g_azs.clear()
    LET g_cnt = 1
 
    FOREACH azs_curs INTO g_azs[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_azs.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION data_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0                                 
   LET g_curs_index = 0                                
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azs TO s_azs.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document               
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#@    ON ACTION field list 下載
      ON ACTION field_list
         LET g_action_choice="field_list"
         EXIT DISPLAY
 
#@    ON ACTION 檔案下載 
      ON ACTION file_download
         LET g_action_choice="file_download"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION data_out()
    DEFINE
        l_azs           RECORD LIKE azs_file.*,
        l_i             LIKE type_file.num5,    
        l_name          LIKE type_file.chr20,    #External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azs_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
 
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc2,'azs01,azs02,azs03,azs04')
        RETURNING g_wc2
    END IF
 
    LET g_str=g_wc2
    CALL cl_prt_cs1("p_base_data","p_base_data",g_sql,g_str)
 
END FUNCTION
 
FUNCTION data_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azs01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION data_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("azs01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end          
 
FUNCTION data_file()
 
DEFINE l_industry      LIKE type_file.chr1,
       l_logistics     LIKE azp_file.azp03,
       l_sql           STRING, 
       l_azs01         LIKE type_file.chr20, 
       l_file          LIKE type_file.chr100, 
       l_file1         LIKE type_file.chr100, 
       l_log           LIKE type_file.chr100, 
       l_dbs_azp03     LIKE type_file.chr21,
       l_n             LIKE type_file.num5,       #檢查重複用
       l_status        LIKE type_file.chr100,
       l_msg           LIKE type_file.chr100
DEFINE ls_get_flst     base.Channel #TQC-960347 add
DEFINE l_str_flst      STRING       #TQC-960347 add
DEFINE ls_spath_flst   STRING       #TQC-960347 add
 
    OPEN WINDOW p_base_data_1 WITH FORM "azz/42f/p_base_data_1" 
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("p_base_data_1")
 
   INPUT l_industry,l_logistics  WITHOUT DEFAULTS FROM industry,logistics
 
      BEFORE INPUT 
         LET l_industry ='1'
 
      AFTER FIELD industry
         IF l_industry NOT  MATCHES "[123]" THEN
            CALL cl_err('', 'mfg-012', 1)
            NEXT FIELD industry
         END IF
 
      AFTER FIELD logistics
         IF NOT cl_null(l_logistics) THEN
            SELECT COUNT(*) INTO l_n FROM azp_file 
             WHERE azp01=l_logistics
            IF l_n <> 1 THEN
                CALL cl_err('','aps-008',0)
                LET l_logistics=''
                DISPLAY l_logistics TO logistics
                NEXT FIELD logistics
            END IF
         ELSE
            CALL cl_err('','mfg5103',0)
            NEXT FIELD logistics
         END IF
 
     ON ACTION controlp
         CASE
             WHEN INFIELD(logistics)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azp"
                LET g_qryparam.default1= l_logistics
                CALL cl_create_qry() RETURNING l_logistics
                DISPLAY l_logistics TO logistics
                NEXT FIELD logistics
              OTHERWISE
                   EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
  #IF NOT INT_FLAG THEN                            # 使用者不玩了
  #   LET INT_FLAG = 0
 
   IF cl_confirm('abx-080') THEN #是否確定執行 (Y/N) ? #FUN-930160
 
      {%1}          
      LET l_sql= "SELECT azs01 FROM azs_file "
      
       CASE l_industry
            WHEN '1'
               LET l_sql = l_sql CLIPPED," WHERE azs02='Y' "
            WHEN '2'
               LET l_sql = l_sql CLIPPED," WHERE azs03='Y' "
            WHEN '3'
               LET l_sql = l_sql CLIPPED," WHERE azs04='Y' "
       END CASE
      
      PREPARE data_pre FROM l_sql   
      DECLARE data_cs CURSOR FOR data_pre
      
      {%3}          
      LET g_plant_new = l_logistics  #營運中心
      CALL s_getdbs()
      LET l_dbs_azp03 = g_dbs_new    #所屬DB
      
      LET g_tempdir = FGL_GETENV("TOP")
 
      CASE l_industry
           WHEN '1'
                LET l_file =g_tempdir,'/doc/def_data/std/'                        
           WHEN '2'
                LET l_file =g_tempdir,'/doc/def_data/icd/'                        
           WHEN '3'
                LET l_file =g_tempdir,'/doc/def_data/slk/'                        
      END CASE
 
      RUN "rm -f " || l_file CLIPPED || "*"
 
      {start}
      LET g_i = 1            
      CALL g_show_msg.clear()
      FOREACH data_cs INTO l_azs01
          IF STATUS THEN
             CALL cl_err("OPEN data_cs:", STATUS, 1)
             EXIT FOREACH
          END IF
      
          LET l_file1=''
          CASE l_industry
               WHEN '1'
                    LET l_file1 =l_file,l_azs01 CLIPPED ,'.std'
               WHEN '2'
                    LET l_file1 =l_file,l_azs01 CLIPPED ,'.icd'
               WHEN '3'
                    LET l_file1 =l_file,l_azs01 CLIPPED ,'.slk'
          END CASE
 
          LET l_log=l_dbs_azp03 CLIPPED,l_azs01
 
          #TQC-960347---add---str---
          LET ls_spath_flst =g_tempdir,'/doc/def_data/flst/',l_azs01 CLIPPED,'.flst'
          
          #將文字檔內容導致字串l_str_flst
          LET ls_get_flst = base.Channel.create()
          CALL ls_get_flst.openFile(ls_spath_flst, "r")
          WHILE ls_get_flst.read(l_str_flst)
               #DISPLAY "l_str_flst:",l_str_flst
          END WHILE
          #TQC-960347---add---end---
 
         #LET l_sql= "SELECT * FROM ",l_log CLIPPED               #TQC-960347 mark
          LET l_sql= "SELECT ",l_str_flst," FROM ",l_log CLIPPED  #TQC-960347 mod
 
          UNLOAD TO l_file1 l_sql
          IF SQLCA.sqlcode THEN
            #CALL cl_err('unload',SQLCA.sqlcode,1)
             LET l_status='fail'
             LET l_msg=SQLCA.sqlcode
          ELSE 
            #CALL cl_err(l_file1,'anm1007',1)
             LET l_status='success'
             LET l_msg = cl_getmsg('anm1007',g_lang)
          END IF
 
          LET g_show_msg[g_i].type_1=l_status
          LET g_show_msg[g_i].type_2=l_azs01
          LET g_show_msg[g_i].type_3=l_msg
          LET g_i = g_i + 1
 
      END FOREACH
     #jamie
     #以陣列方式show出所產生的資料
      LET g_msg = NULL
      LET g_msg2= NULL
      CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
      CALL cl_getmsg('azz-169',g_lang) RETURNING g_msg2
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg, g_msg2)
 
   END IF
   CLOSE WINDOW p_base_data_1
 
END FUNCTION
 
FUNCTION field_list()
 
DEFINE l_sql           STRING, 
       l_col           STRING,
       l_name          LIKE type_file.chr10, 
       l_azs01         LIKE type_file.chr20, 
       l_file_flst     LIKE type_file.chr100,
       l_file_flst1    LIKE type_file.chr100,
       l_status        LIKE type_file.chr100,
       l_msg           LIKE type_file.chr100
DEFINE lc_channel      base.Channel
 
  IF cl_confirm('azz-168') THEN
 
      {%1}          
      LET l_sql= "SELECT azs01 FROM azs_file "
      DISPLAY "Hiko:azs sql=",l_sql
      PREPARE field_pre FROM l_sql   
      DECLARE field_cs CURSOR FOR field_pre
     
      {%2}          
      #Begin:FUN-9B0012
      #LET l_sql=
      #  "SELECT COLUMN_NAME FROM all_tab_cols ",
      #  " WHERE TABLE_NAME= UPPER(?) AND OWNER ='DS' ORDER BY 1"
      DISPLAY "Hiko:g_db_type=",g_db_type,"<<"
      CASE g_db_type #FUN-A70028
         WHEN "ORA"
            LET l_sql = "SELECT column_name",
                        "  FROM all_tab_cols",
                        " WHERE table_name=UPPER(?) AND owner='DS'",
                        " ORDER BY column_id"
         WHEN "MSV"
            LET l_sql = "SELECT a.name",
                        "  FROM sys.columns a",
                        " INNER JOIN sys.tables b ON b.object_id=a.object_id",
                        " WHERE b.name=LOWER(?)",
                        " ORDER BY a.column_id"
      END CASE
      #End:FUN-9B0012
      PREPARE field_pre_1 FROM l_sql   
      DECLARE field_cs_1 CURSOR FOR field_pre_1
      LET g_tempdir = FGL_GETENV("TOP")
      
      LET l_file_flst =g_tempdir,'/doc/def_data/flst/'                        
 
      RUN "rm -f " || l_file_flst CLIPPED || "*"
 
      {start}
      LET g_i = 1            
      CALL g_show_msg.clear()
      FOREACH field_cs INTO l_azs01
 
          IF STATUS THEN
             CALL cl_err("OPEN field_cs:", STATUS, 1)
             EXIT FOREACH
          END IF
      
          LET lc_channel = base.Channel.create()
          LET l_file_flst1 = l_file_flst,l_azs01 CLIPPED ,'.flst'
          CALL lc_channel.openFile(l_file_flst1,"w")
         
          LET l_col=''
          FOREACH field_cs_1 USING l_azs01 INTO l_name
            IF cl_null(l_col) THEN 
               LET l_col = l_name CLIPPED
            ELSE 
               LET l_col = l_col CLIPPED,',',l_name CLIPPED
            END IF
          END FOREACH
      
          CALL lc_channel.setDelimiter("")
          CALL lc_channel.write(l_col)
          CALL lc_channel.close()
 
          IF SQLCA.sqlcode THEN
            #CALL cl_err('unload',SQLCA.sqlcode,1)
             LET l_status='fail'
             LET l_msg=SQLCA.sqlcode
          ELSE 
            #CALL cl_err(l_file,'anm1007',1)
             LET l_status='success'
             LET l_msg = cl_getmsg('anm1007',g_lang)
          END IF
 
          LET g_show_msg[g_i].type_1=l_status
          LET g_show_msg[g_i].type_2=l_azs01
          LET g_show_msg[g_i].type_3=l_msg
          LET g_i = g_i + 1
 
      END FOREACH
 
     #以陣列方式show出所產生的資料
      LET g_msg = NULL
      LET g_msg2= NULL
      CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
      CALL cl_getmsg('azz-169',g_lang) RETURNING g_msg2
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg, g_msg2)
   END IF
 
END FUNCTION
