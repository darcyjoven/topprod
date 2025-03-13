# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: amri603.4gl
# Descriptions...: 多營運中心MRP 版本條件維護
# Date & Author..: 07/06/04 By chenl
# Modify.........: No.FUN-740234 07/06/06 chenl 過單用
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_msw000                LIKE msw_file.msw000       #No.FUN-740234
DEFINE  g_msw000_t              LIKE msw_file.msw000
DEFINE  g_msw02                 LIKE msw_file.msw02
DEFINE  g_msw02_t               LIKE msw_file.msw02
DEFINE  g_msw03                 LIKE msw_file.msw03
DEFINE  g_msw04                 LIKE msw_file.msw04
DEFINE  g_msw05                 LIKE msw_file.msw05
DEFINE  g_msw07                 LIKE msw_file.msw07
DEFINE  g_msw                   DYNAMIC ARRAY OF RECORD 
                                msw08   LIKE msw_file.msw08,
                                azp02   LIKE azp_file.azp02,
                                msw10   LIKE msw_file.msw10
                                END RECORD
DEFINE  g_msw_t                 RECORD
                                msw08   LIKE msw_file.msw08,
                                azp02   LIKE azp_file.azp02,
                                msw10   LIKE msw_file.msw10
                                END RECORD 
DEFINE  g_forupd_sql            STRING 
DEFINE  g_before_input_done     STRING
DEFINE  g_cnt                   LIKE type_file.num10
DEFINE  g_row_count             LIKE type_file.num10
DEFINE  g_curs_index            LIKE type_file.num10  
DEFINE  g_jump                  LIKE type_file.num10 
DEFINE  mi_no_ask               LIKE type_file.num5
DEFINE  g_sql                   STRING
DEFINE  g_wc                    STRING 
DEFINE  g_rec_b                 LIKE type_file.num5
DEFINE  l_ac                    LIKE type_file.num5
DEFINE  g_msg                   LIKE type_file.chr1000
 
MAIN
DEFINE  p_row,p_col             LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AMR")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   
    INITIALIZE g_msw TO NULL 
    INITIALIZE g_msw_t.* TO NULL 
    LET p_row = 3 LET p_col = 4
    OPEN WINDOW i603_w AT p_row,p_col              #顯示畫面
        WITH FORM "amr/42f/amri603"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM nmw_file WHERE msw000 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i603_cl CURSOR FROM g_forupd_sql
 
    CALL i603_menu()
      
    CLOSE WINDOW i603_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
         RETURNING g_time  
END MAIN
 
 
FUNCTION i603_cs()
DEFINE   lc_qbe_sn       LIKE    gbm_file.gbm01
  
   CLEAR FORM                           
   CALL g_msw.clear()
   CALL cl_set_head_visible("","YES")
 
   
   CONSTRUCT  g_wc ON msw000,msw02,msw08,msw10             # 螢幕上取單頭條件
        FROM  msw000,msw02,s_msw[1].msw08,s_msw[1].msw10
      
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(msw08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO msw08
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
		      CALL cl_qbe_list() RETURNING lc_qbe_sn
		      CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   
   LET g_sql = "SELECT DISTINCT msw000 FROM msw_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY msw000"
   PREPARE i603_prepare FROM g_sql
   DECLARE i603_bcs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i603_prepare
 
   LET g_sql="SELECT COUNT(UNIQUE msw000) FROM msw_file WHERE ",g_wc CLIPPED
   PREPARE i603_precount FROM g_sql
   DECLARE i603_count CURSOR FOR i603_precount
 
   OPEN i603_count
   FETCH i603_count INTO g_row_count
   CLOSE i603_count
 
END FUNCTION
 
FUNCTION i603_menu()
 
   WHILE TRUE
      CALL i603_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i603_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i603_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i603_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i603_u()
            END IF
        #WHEN "reproduce" 
        #   IF cl_chk_act_auth() THEN
        #      CALL i603_copy()
        #   END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i603_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        # WHEN "output" 
        #    IF cl_chk_act_auth()
        #       THEN CALL i603_out()
        #    END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
           IF cl_chk_act_auth() THEN
              IF g_msw000 IS NOT NULL THEN
                 LET g_doc.column1 = "msw000"
                 LET g_doc.value1 = g_msw000
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_msw),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i603_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_msw.clear()
    INITIALIZE g_msw000 LIKE msw_file.msw000              #DEFAULT 設定
    INITIALIZE g_msw02  LIKE msw_file.msw02
    LET g_msw000_t = g_msw000
    LET g_msw02_t  = g_msw02
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i603_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            CALL g_msw.clear()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_msw000 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_rec_b = 0 
        CALL i603_b()                   #輸入單身
        LET g_msw000_t = g_msw000
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i603_u()
    IF g_msw000 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_msw000_t = g_msw000
    LET g_msw02_t = g_msw02
    WHILE TRUE
        CALL i603_i('u')
        IF INT_FLAG THEN
            LET g_msw000=g_msw000_t
            LET g_msw02 =g_msw02_t
            DISPLAY g_msw000 TO msw000          #ATTRIBUTE(YELLOW) 
            DISPLAY g_msw02  TO msw02           
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_msw000 != g_msw000_t OR g_msw02 != g_msw02_t THEN #欄位更改         
            UPDATE msw_file SET msw000  = g_msw000,
                                msw02   = g_msw02
                WHERE msw000 = g_msw000_t       
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","msw_file",g_msw000,"",SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION 
 
FUNCTION i603_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1         
DEFINE   l_n             LIKE type_file.num5          
 
    CALL cl_set_head_visible("","YES")       
 
    INPUT g_msw000,g_msw02 WITHOUT DEFAULTS FROM msw000,msw02
 
        BEFORE INPUT
 
        AFTER FIELD msw000
            IF NOT cl_null(g_msw000) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_msw000!=g_msw000_t) THEN
                  #判斷資料重復否
                  SELECT COUNT(DISTINCT msw000) INTO l_n FROM msw_file
                   WHERE msw000=g_msw000
                  IF l_n >=1 THEN
                     CALL cl_err(g_msw000,"atm-310",1)
                     LET g_msw000 = g_msw000_t
                     NEXT FIELD msw000
                  END IF
               END IF 
            END IF 
            
   
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
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i603_q()
  DEFINE l_msw000  LIKE msw_file.msw000,
         l_cnt    LIKE type_file.num10        
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msw000 TO NULL    
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_msw.clear()
 
    CALL i603_cs()                 #取得查詢條件 
    IF INT_FLAG THEN               #使用者不玩了  
       LET INT_FLAG = 0
       CLEAR FORM                  #No.TQC-6C0018
       RETURN
    END IF
    OPEN i603_bcs                  #從DB產生合乎條件的TEMP(0-30秒)  
    IF SQLCA.sqlcode THEN           
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msw000 TO NULL
    ELSE
        OPEN i603_count                                                     
        FETCH i603_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i603_fetch('F')        #讀取TEMP的第一筆并顯示  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i603_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1         #處理方式       
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i603_bcs INTO g_msw000 
        WHEN 'P' FETCH PREVIOUS i603_bcs INTO g_msw000 
        WHEN 'F' FETCH FIRST    i603_bcs INTO g_msw000 
        WHEN 'L' FETCH LAST     i603_bcs INTO g_msw000 
        WHEN '/' 
         IF (NOT mi_no_ask) THEN 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump i603_bcs INTO g_msw000  
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_msw000,SQLCA.sqlcode,0)
        INITIALIZE g_msw000 TO NULL 
        RETURN
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
    OPEN i603_count
    FETCH i603_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i603_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i603_show()
 
    SELECT DISTINCT(msw02),msw03,msw04,msw05,msw07 
      INTO g_msw02,g_msw03,g_msw04,g_msw05,g_msw07
      FROM msw_file
     WHERE msw000= g_msw000
    DISPLAY g_msw000 TO msw000  
    DISPLAY g_msw02 TO msw02 
    DISPLAY g_msw03 TO msw03
    DISPLAY g_msw04 TO msw04
    DISPLAY g_msw05 TO msw05
    DISPLAY g_msw07 TO msw07
    CALL i603_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#刪除整筆資料(所有合乎單頭的資料)
FUNCTION i603_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_msw000 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0079   
       RETURN 
    END IF
    IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msw000"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msw000       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM msw_file WHERE msw000 = g_msw000 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","msw_file",g_msw000,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_msw.clear()
            LET g_msw000 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i603_count                                                     
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i603_bcs
               CLOSE i603_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i603_count INTO g_row_count                 
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i603_bcs
               CLOSE i603_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i603_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i603_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET mi_no_ask = TRUE                           
               CALL i603_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i603_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重復用        
    l_ac_o          LIKE type_file.num5,          
    l_rows          LIKE type_file.num5,          
    l_success       LIKE type_file.chr1,            
    l_str           LIKE type_file.chr20,         
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                 #處理狀態        
    l_allow_insert  LIKE type_file.num5,                #可新增否        
    l_allow_delete  LIKE type_file.num5                 #可刪除否        
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_msw000) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT msw08,'',msw10 ",
                       "   FROM msw_file  ",
                       "   WHERE msw000=?   ",
                       "    AND msw08=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i603_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_msw WITHOUT DEFAULTS FROM s_msw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            IF g_rec_b >=l_ac THEN  
                LET p_cmd='u'
                LET g_msw_t.* = g_msw[l_ac].*      #BACKUP
                OPEN i603_bcl USING g_msw000,g_msw_t.msw08
                IF STATUS THEN
                   CALL cl_err("OPEN i603_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i603_bcl INTO g_msw[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_msw_t.msw08,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT azp02 INTO g_msw[l_ac].azp02 FROM azp_file
                       WHERE azp01 = g_msw[l_ac].msw08
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_msw[l_ac].* TO NULL      #900423
            LET g_msw_t.* = g_msw[l_ac].*         #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD msw08
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO msw_file(msw000,msw02,msw08,msw10)
                          VALUES(g_msw000,g_msw02,g_msw[l_ac].msw08,
                                 g_msw[l_ac].msw10)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","msw_file",g_msw000,g_msw[l_ac].msw08,
                             SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b = g_rec_b+1
            END IF
       
        AFTER FIELD msw08
            IF NOT cl_null(g_msw[l_ac].msw08) THEN 
               SELECT COUNT(*) INTO l_n FROM azp_file 
                WHERE azp01=g_msw[l_ac].msw08
               IF l_n=0 THEN
                  CALL cl_err(g_msw[l_ac].msw08,'aap-025',1)
                  LET g_msw[l_ac].msw08 = g_msw_t.msw08
                  NEXT FIELD msw08
               END IF 
               IF p_cmd='a' OR (p_cmd='u' AND g_msw[l_ac].msw08 != g_msw_t.msw08) THEN
                  SELECT COUNT(*) INTO l_n FROM msw_file
                   WHERE msw000=g_msw000 AND msw08=g_msw[l_ac].msw08
                  IF l_n >0 THEN 
                     CALL cl_err3("sel","msw_file",g_msw000,g_msw[l_ac].msw08,"atm-310","","",1)
                     LET g_msw[l_ac].msw08 = g_msw_t.msw08
                     NEXT FIELD msw08
                  END IF 
                  IF SQLCA.sqlcode THEN 
                     CALL cl_err3("sel","msw_file",g_msw000,g_msw[l_ac].msw08,SQLCA.sqlcode,"","",1)
                     NEXT FIELD msw08
                  ELSE
                     SELECT azp02 INTO g_msw[l_ac].azp02 FROM azp_file WHERE azp01=g_msw[l_ac].msw08
                     IF SQLCA.sqlcode THEN 
                        LET g_msw[l_ac].azp02 = NULL 
                     END IF 
                     DISPLAY g_msw[l_ac].azp02 TO azp02
                  END IF 
               END IF 
            END IF 
 
        BEFORE DELETE                            #刪除單身
            IF  NOT cl_null(g_msw_t.msw08) THEN  
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM msw_file
                 WHERE msw000 = g_msw000 
                   AND msw08 = g_msw_t.msw08 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","msw_file",g_msw_t.msw08,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1   
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_msw[l_ac].* = g_msw_t.*
               CLOSE i603_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msw[l_ac].msw08,-263,1)
               LET g_msw[l_ac].* = g_msw_t.*
            ELSE
               UPDATE msw_file SET msw08=g_msw[l_ac].msw08,
                                   msw10=g_msw[l_ac].msw10
                WHERE msw000 = g_msw000 
                  AND msw08 = g_msw_t.msw08
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","msw_file",g_msw[l_ac].msw08,"",
                               SQLCA.sqlcode,"","",1)  
                 LET g_msw[l_ac].* = g_msw_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msw[l_ac].* = g_msw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_msw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i603_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add  
            CLOSE i603_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(msw08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azp"
                   LET g_qryparam.default1 = g_msw[l_ac].msw08
                   CALL cl_create_qry() RETURNING g_msw[l_ac].msw08
                   NEXT FIELD msw08
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION controls                             
           CALL cl_set_head_visible("","AUTO")         
 
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
    CLOSE i603_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i603_b_fill(p_wc)              #BODY FILL UP
#DEFINE p_wc            LIKE type_file.chr1000
 DEFINE p_wc  STRING     #NO.FUN-910082       
DEFINE l_azp02         LIKE azp_file.azp02
 
    LET g_sql = "SELECT msw08,'',msw10 ",
                "  FROM msw_file ",  
                " WHERE msw000 = '",g_msw000,"'",  
                " ORDER BY msw08"
    PREPARE i603_prepare2 FROM g_sql      
    DECLARE msw_cs CURSOR FOR i603_prepare2
    CALL g_msw.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH msw_cs INTO g_msw[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF NOT cl_null(g_msw[g_cnt].msw08) THEN 
           SELECT azp02 INTO g_msw[g_cnt].azp02 FROM azp_file 
            WHERE azp01=g_msw[g_cnt].msw08
           IF SQLCA.sqlcode THEN 
              LET g_msw[g_cnt].azp02 = NULL
           END IF 
           DISPLAY g_msw[g_cnt].azp02 TO azp02
        END IF 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_msw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1     
END FUNCTION
 
FUNCTION i603_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msw TO s_msw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()   
 
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
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i603_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i603_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	         ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i603_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	         ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i603_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	         ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i603_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	         ACCEPT DISPLAY               
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DISPLAY
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
      ON ACTION controls                                         #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                    #No.FUN-6A0092
  
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
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
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
