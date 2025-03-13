# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aapi002.4gl
# Descriptions...: 账龄及备抵呆账计提率维护作业
# Input parameter: 
# Date & Author..: 11/05/30 By wujie  TQC-B50125
# Modify.........: No.TQC-B90171 11/09/23 By Carrier fill时p_wc为空,导致程序当出
# Modify.........: No.TQC-BA0160 11/10/27 By yinhy 在欄位“賬齡起始天數”和“賬齡截止天數”輸入相同的天數時，報錯信息不準確
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
#TQC-B50125 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_aly01         LIKE aly_file.aly01,  
    g_aly01_t       LIKE aly_file.aly01,   
    g_aly02         LIKE aly_file.aly02,  
    g_aly02_t       LIKE aly_file.aly02,   
    g_aly           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aly02       LIKE aly_file.aly02,   
        aly03       LIKE aly_file.aly03,  
        aly04       LIKE aly_file.aly04,   
        aly05       LIKE aly_file.aly05  
                    END RECORD,
    g_aly_t         RECORD                 #程式變數 (舊值)
        aly02       LIKE aly_file.aly02,   
        aly03       LIKE aly_file.aly03,  
        aly04       LIKE aly_file.aly04,   
        aly05       LIKE aly_file.aly05  
                    END RECORD,
    g_wc,g_sql     STRING, 
    g_rec_b         LIKE type_file.num5,   #單身筆數           
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT 
DEFINE p_row,p_col  LIKE type_file.num5   
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done  LIKE type_file.num5           
DEFINE   g_cnt           LIKE type_file.num10           
DEFINE   g_i             LIKE type_file.num5         
DEFINE   g_msg           LIKE type_file.chr1000         
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   mi_no_ask      LIKE type_file.num5          
DEFINE   l_sql          STRING                       
DEFINE   g_str          STRING                       
DEFINE   l_table        STRING                       
DEFINE   l_table1       STRING                      
 
MAIN
   
     OPTIONS
         INPUT NO WRAP
     DEFER INTERRUPT
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CONTINUE 
   
    IF (NOT cl_setup("AAP")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW i002_w AT p_row,p_col
         WITH FORM "aap/42f/aapi002" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_entry('aly02',FALSE) 
 
    CALL i002_menu()
 
    CLOSE WINDOW i002_w                   #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time                
 
END MAIN     
 
#QBE 查詢資料
FUNCTION i002_curs()
    CLEAR FORM                            #清除畫面
    CALL g_aly.clear()
    CALL cl_set_head_visible("","YES")     
 
    INITIALIZE g_aly01 TO NULL   
    CONSTRUCT g_wc ON aly01,aly02,aly03,aly04,aly05    #螢幕上取條件
        FROM aly01,s_aly[1].aly02,s_aly[1].aly03,s_aly[1].aly04,s_aly[1].aly05
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
        ON ACTION about        
           CALL cl_about()     
        
        ON ACTION HELP          
           CALL cl_show_help()  
        
        ON ACTION controlg     
           CALL cl_cmdask()    
        
        ON ACTION qbe_select
           CALL cl_qbe_select() 
           
        ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF  
    LET g_sql= "SELECT UNIQUE aly01 FROM aly_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY aly01 "
    PREPARE i002_prepare FROM g_sql      #預備一下
    DECLARE i002_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i002_prepare

    DROP TABLE x
    LET g_sql = "SELECT COUNT(DISTINCT aly01) FROM aly_file",
                " WHERE ",g_wc CLIPPED
    PREPARE i002_precount FROM g_sql
    DECLARE i002_count CURSOR FOR i002_precount
    
END FUNCTION
 
FUNCTION i002_menu()
 
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i002_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i002_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i002_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i002_copy()
            END IF
         WHEN "re_sort"
            IF cl_chk_act_auth() THEN
               CALL i002_g()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aly),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_aly01 IS NOT NULL THEN
                 LET g_doc.column1 = "aly01"
                 LET g_doc.value1 = g_aly01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i002_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_aly.clear()
    INITIALIZE g_aly02 LIKE aly_file.aly02
    INITIALIZE g_aly01 LIKE aly_file.aly01
    CLOSE i002_b_curs
    LET g_aly01_t = NULL
    LET g_wc      = NULL
    WHILE TRUE
        CALL i002_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
    
        LET g_rec_b=0                              
        CALL i002_b()                        #輸入單身
        IF SQLCA.sqlcode THEN 
            CALL cl_err(g_aly01,SQLCA.sqlcode,0)
        END IF
        LET g_aly01_t = g_aly01                 #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION i002_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aly01)  THEN 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_aly01_t = g_aly01
    BEGIN WORK
    WHILE TRUE
        CALL i002_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_aly01=g_aly01_t
            DISPLAY g_aly01 TO aly01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_aly01 != g_aly01_t THEN  
           UPDATE aly_file 
              SET aly01 = g_aly01 #更新DB
            WHERE aly01 = g_aly01_t 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","aly_file",g_aly01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i002_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1         #a:輸入 u:更改  
DEFINE l_n             LIKE type_file.num5
    
    
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_aly01 WITHOUT DEFAULTS  
        FROM aly01
 
 
       AFTER FIELD aly01
         IF g_aly01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_aly01 != g_aly01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM aly_file WHERE aly01 = g_aly01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_aly01,-239,1)
                  LET g_aly01 = g_aly01_t
                  DISPLAY BY NAME g_aly01
                  NEXT FIELD aly01
               END IF
            END IF
         END IF
         
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
 
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
 
#Query 查詢
FUNCTION i002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aly01 TO NULL           
 
    MESSAGE ""                               
    CLEAR FORM                               
    CALL g_aly.clear()
 
    CALL i002_curs()                         #取得查詢條件
 
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN i002_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_aly01 TO NULL        
    ELSE
       CALL i002_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i002_count
       FETCH i002_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_b_curs INTO g_aly01
        WHEN 'P' FETCH PREVIOUS i002_b_curs INTO g_aly01
        WHEN 'F' FETCH FIRST    i002_b_curs INTO g_aly01
        WHEN 'L' FETCH LAST     i002_b_curs INTO g_aly01
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about        
                     CALL cl_about()     
                  
                  ON ACTION help        
                     CALL cl_show_help() 
                  
                  ON ACTION controlg    
                    CALL cl_cmdask()                    
               END PROMPT
               
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF 
            FETCH ABSOLUTE g_jump i002_b_curs INTO g_aly01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_aly01,SQLCA.sqlcode,0)
       INITIALIZE g_aly01 TO NULL  #TQC-6B0105
    ELSE
 
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump        
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i002_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i002_show()
 
    DISPLAY g_aly01 TO aly01               #單頭
 
    CALL i002_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                 
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i002_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aly01 IS NULL THEN
       CALL cl_err("",-400,0)               
       RETURN
    END IF
 
    BEGIN WORK
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL             
        DELETE FROM aly_file WHERE aly01 = g_aly01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","aly_file",g_aly01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660167
        ELSE
            CLEAR FORM
            CALL g_aly.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i002_count
            FETCH i002_count INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i002_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i002_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i002_fetch('/')
            END IF
        END IF
    END IF
 
    COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                #處理狀態         
    l_allow_insert  LIKE type_file.num5,                #可新增否         
    l_allow_delete  LIKE type_file.num5                 #可刪除否         
 
    LET g_action_choice = ""
 
    IF cl_null(g_aly01) THEN 
       RETURN
    END IF
 
    LET g_forupd_sql = 
        "SELECT aly02,aly03,aly04,aly05 FROM aly_file ",
        " WHERE aly01 = ? AND aly02 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aly WITHOUT DEFAULTS FROM s_aly.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEn
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK    #MOD-8B0180
            
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_aly_t.* = g_aly[l_ac].*  #BACKUP
 
               OPEN i002_bcl USING g_aly01, g_aly_t.aly02
               IF STATUS THEN
                  CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i002_bcl INTO g_aly_t.* 
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_aly_t.aly03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_aly_t.*=g_aly[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aly[l_ac].* TO NULL      #900423
            IF l_ac > 1 THEN 
               IF NOT cl_null(g_aly[l_ac-1].aly04) THEN
                  LET g_aly[l_ac].aly03 = g_aly[l_ac-1].aly04+1
               END IF
            END IF 
            LET g_aly_t.* = g_aly[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aly02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO aly_file(aly01,aly02,aly03,aly04,aly05)   
                          VALUES(g_aly01,
                                 g_aly[l_ac].aly02,g_aly[l_ac].aly03,
                                 g_aly[l_ac].aly04,g_aly[l_ac].aly05)  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","aly_file",g_aly01,g_aly[l_ac].aly02,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               #DISPLAY g_rec_b TO FORMONLY.cn2    #MOD-8B0180
            END IF
 
        BEFORE FIELD aly02                        #default 序號
           IF g_aly[l_ac].aly02 IS NULL OR g_aly[l_ac].aly02 = 0 THEN
              SELECT max(aly02)+1
                INTO g_aly[l_ac].aly02
                FROM aly_file
               WHERE aly01 = g_aly01
              IF g_aly[l_ac].aly02 IS NULL THEN
                 LET g_aly[l_ac].aly02 = 1
              END IF
           END IF

        BEFORE FIELD aly03 
           IF cl_null(g_aly[l_ac].aly03) AND g_aly[l_ac].aly02 > 1 THEN
              IF NOT cl_null(g_aly[l_ac-1].aly04) THEN
                 LET g_aly[l_ac].aly03 = g_aly[l_ac-1].aly04+1
              END IF
           END IF 

#        AFTER FIELD aly03
#           IF NOT cl_null(g_aly[l_ac].aly03) AND g_aly[l_ac].aly02 > 1 THEN
#              IF g_aly[l_ac].aly03 != g_aly_t.aly03 OR g_aly_t.aly03 IS NULL THEN 
#                 IF NOT cl_null(g_aly[l_ac-1].aly04) THEN
#                    IF g_aly[l_ac].aly03 < g_aly[l_ac-1].aly04+1 THEN 
#                       CALL cl_err('','axr-959',1)
#                       LET g_aly[l_ac].aly03 = g_aly_t.aly03
#                       NEXT FIELD aly03
#                    END IF 
#                 END IF
#              END IF 
#           END IF         

        AFTER FIELD aly04 
           IF NOT cl_null(g_aly[l_ac].aly03) AND NOT cl_null(g_aly[l_ac].aly04) THEN 
              IF g_aly[l_ac].aly04 <= g_aly[l_ac].aly03 THEN 
                 #CALL cl_err('','aap-100',1) #TQC-BA0160
                 CALL cl_err('','aap-367',1)  #TQC-BA0160
                 LET g_aly[l_ac].aly04 = g_aly_t.aly04
                 NEXT FIELD aly04
              END IF 
           END IF 
           
        AFTER FIELD aly05 
           IF NOT cl_null(g_aly[l_ac].aly05) THEN
              IF g_aly[l_ac].aly05<0 THEN 
                 CALL cl_err('','aec-020',1)
                 LET g_aly[l_ac].aly05 = g_aly_t.aly05
                 NEXT FIELD aly05
              END IF 
           END IF 
                   
        BEFORE DELETE                            #是否取消單身
            IF g_aly_t.aly02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               
                DELETE FROM aly_file
                 WHERE aly01 = g_aly01 AND aly02 = g_aly_t.aly02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","aly_file",g_aly_t.aly02,g_aly01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b = g_rec_b -1   #MOD-780239 add
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aly[l_ac].* = g_aly_t.*
               CLOSE i002_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aly[l_ac].aly02,-263,1)
               LET g_aly[l_ac].* = g_aly_t.*
            ELSE
               UPDATE aly_file SET aly01=g_aly01,
                                   aly02=g_aly[l_ac].aly02,
                                   aly03=g_aly[l_ac].aly03,
                                   aly04=g_aly[l_ac].aly04,
                                   aly05=g_aly[l_ac].aly05
                WHERE aly01 = g_aly01 
                  AND aly02 = g_aly_t.aly02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","aly_file",g_aly01,g_aly_t.aly02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 LET g_aly[l_ac].* = g_aly_t.*
                 ROLLBACK WORK
              ELSE
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
                  LET g_aly[l_ac].* = g_aly_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aly.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i002_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032
            CLOSE i002_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(aly02) AND l_ac > 1 THEN
               LET g_aly[l_ac].* = g_aly[l_ac-1].*
               NEXT FIELD aly02
            END IF
 
        ON ACTION controls                               #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
END FUNCTION
   
FUNCTION i002_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT g_wc ON aly02,aly03,aly04,aly05    #螢幕上取條件
        FROM s_aly[1].aly02,s_aly[1].aly03,s_aly[1].aly04,s_aly[1].aly05
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
    IF INT_FLAG THEN RETURN END IF
 
    CALL i002_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i002_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680137   VARCHAR(200)

    #No.TQC-B90171  --Begin
    IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF
    #No.TQC-B90171  --End
 
    LET g_sql =
               "SELECT aly02,aly03,aly04,aly05 ",
               " FROM aly_file ",
               " WHERE aly01 = '",g_aly01,
               "' AND ",p_wc CLIPPED ,
               " ORDER BY aly02,aly03,aly04 "
    PREPARE i002_p2 FROM g_sql      #預備一下
    DECLARE aly_curs CURSOR FOR i002_p2
 
    CALL g_aly.clear()
    LET g_cnt = 1
 
    FOREACH aly_curs INTO g_aly[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_aly.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aly TO s_aly.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION re_sort
         LET g_action_choice="re_sort"
         EXIT DISPLAY
          
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i002_copy()

    DEFINE l_newno         LIKE aly_file.aly01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
    DEFINE l_wc            STRING
 
    IF g_aly01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    LET g_before_input_done = TRUE

    INPUT l_newno FROM aly01
 
        AFTER FIELD aly01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM aly_file WHERE aly01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 LET l_newno =NULL 
                 NEXT FIELD aly01
              END IF
           END IF
 

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

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_aly01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM aly_file
        WHERE aly01=g_aly01
        INTO TEMP x
    UPDATE x
        SET aly01=l_newno    #資料鍵值


    INSERT INTO aly_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","aly_file",g_aly01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET g_aly01 = l_newno
        LET l_wc ="aly01 ='",g_aly01,"'"
        CALL i002_bp(l_wc)
        CALL i002_u()
    END IF
    CALL i002_show()
END FUNCTION 

FUNCTION i002_g()
DEFINE  l_sql    LIKE type_file.chr1000,      
        l_cnt    LIKE type_file.num5,          
        l_aly02  LIKE aly_file.aly02
 
   IF s_aglshut(0) THEN RETURN END IF
   LET l_sql = " UPDATE aly_file SET aly02 = aly02 + 10000 ",
               " WHERE aly01 = '",g_aly01,"'"
   PREPARE i002_pre3  FROM l_sql
   EXECUTE i002_pre3
   DECLARE i002_aly CURSOR FOR
           SELECT aly02 FROM aly_file
            WHERE aly01 = g_aly01
            ORDER BY aly03
   LET l_cnt = 1
   FOREACH i002_aly INTO l_aly02
      UPDATE aly_file SET aly02 = l_cnt
       WHERE aly01 = g_aly01 AND aly02 = l_aly02
      LET l_cnt  = l_cnt + 1
   END FOREACH
   CALL i002_show()
   ERROR 'O.K.'
END FUNCTION
