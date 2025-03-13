# Prog. Version..: '5.30.06-13.04.22(00006)'     #
# Pattern name...: amri401.4gl
# Descriptions...: MRP 訂單模擬資料維護作業
# Date & Author..: No.FUN-960110 09/11/13 By jan
# Modify.........: No.MOD-B30621 11/03/21 By zhangll 增加msjlegal,msjplant賦值
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C60080 12/06/12 By ck2yuan 編碼方式改為一般的輸入格式,與批次產生相同
# Modify.........: No.TQC-C60162 12/06/20 By fengrui 添加訂單單號範圍、客戶編號範圍開窗
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_msj01         LIKE msj_file.msj01,   #工單模擬編號
    g_msj01_t       LIKE msj_file.msj01,   #工單模擬編號(舊值)
    g_msj           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        msj02       LIKE msj_file.msj02,   #工單編號
        oea03       LIKE oea_file.oea03,   #客戶編號
        oea02       LIKE oea_file.oea02    #訂單日期
                    END RECORD,
    g_msj_t         RECORD                 #程式變數 (舊值)
        msj02       LIKE msj_file.msj02,   #工單編號
        oea03       LIKE oea_file.oea03,   #客戶編號
        oea02       LIKE oea_file.oea02    #訂單日期
                    END RECORD,
     g_wc,g_sql,g_wc2    STRING,           
    g_argv1         LIKE msj_file.msj01,   #員工代號
    g_argv2         LIKE msj_file.msj02,   
    g_argv3         LIKE type_file.num5,   
    g_show          LIKE type_file.chr1,   
    g_rec_b         LIKE type_file.num5,   #單身筆數     
    g_flag          LIKE type_file.chr1,   
    g_ss            LIKE type_file.chr1,   
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  

#主程式開始
DEFINE g_forupd_sql    STRING    #SELECT ... FOR UPDATE SQL   
DEFINE g_sql_tmp       STRING    
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_msg           LIKE type_file.chr1000   
DEFINE g_row_count    LIKE type_file.num10      
DEFINE g_curs_index   LIKE type_file.num10      
DEFINE g_jump         LIKE type_file.num10      
DEFINE mi_no_ask       LIKE type_file.num5      
 
MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
    OPEN WINDOW i401_w
        WITH FORM "amr/42f/amri401"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    IF NOT cl_null(g_argv1) THEN
       CALL i401_q()
    END IF
    CALL i401_menu()
    CLOSE WINDOW i401_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)  
         RETURNING g_time    
END MAIN

#QBE 查詢資料
FUNCTION i401_cs()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " msj01 = '",g_argv1,"'"
    ELSE
      CLEAR FORM                             #清除畫面
      CALL g_msj.clear()
      CALL cl_set_head_visible("","YES")   
   INITIALIZE g_msj01 TO NULL    
      CONSTRUCT g_wc ON msj01,msj02
          FROM msj01,s_msj[1].msj02

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      ON ACTION controlp
            CASE
                WHEN INFIELD(msj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_oea09"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO msj02
                  NEXT FIELD msj02
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
      IF INT_FLAG THEN RETURN END IF
    END IF
    LET g_sql= "SELECT UNIQUE msj01 FROM msj_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY msj01"
    PREPARE i401_prepare FROM g_sql      #預備一下
    DECLARE i401_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i401_prepare
 
    LET g_sql_tmp = "SELECT UNIQUE msj01 FROM msj_file ",  
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
    PREPARE i401_precount_x FROM g_sql_tmp  
    EXECUTE i401_precount_x

        LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i401_precount FROM g_sql
    DECLARE i401_count CURSOR FOR i401_precount
 
END FUNCTION

FUNCTION i401_menu()

   WHILE TRUE
      CALL i401_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i401_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i401_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i401_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i401_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i401_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msj),'','')
             END IF

         WHEN "generate"
            IF cl_chk_act_auth() THEN
               CALL i401_g()
            END IF

         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_msj01 IS NOT NULL THEN
                 LET g_doc.column1 = "msj01"
                 LET g_doc.value1 = g_msj01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i401_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_msj.clear()
    INITIALIZE g_msj01 LIKE msj_file.msj01
    LET g_msj01_t  = NULL
    LET g_rec_b =0        
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i401_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_msj01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_msj.clear()
        ELSE
            CALL i401_bf('1=1')            #單身
        END IF
        CALL i401_b()                      #輸入單身
        LET g_msj01_t = g_msj01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i401_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改  
    l_n             LIKE type_file.num5,     
    l_str           LIKE type_file.chr1000   

    LET g_ss='Y'

    DISPLAY g_msj01 TO msj01
    CALL cl_set_head_visible("","YES")   
    INPUT g_msj01 WITHOUT DEFAULTS
         FROM msj01
 
        BEFORE INPUT
         #CALL cl_set_docno_format("msj01")    #MOD-C60080 mark

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
    END INPUT
END FUNCTION

#Query 查詢
FUNCTION i401_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msj01 TO NULL          
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_msj.clear()
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i401_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_msj01 TO NULL
        RETURN
    END IF
    OPEN i401_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msj01 TO NULL
    ELSE
        OPEN i401_count
        FETCH i401_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i401_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i401_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    
    l_abso          LIKE type_file.num10     #絕對的筆數  

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i401_bcs INTO g_msj01
        WHEN 'P' FETCH PREVIOUS i401_bcs INTO g_msj01
        WHEN 'F' FETCH FIRST    i401_bcs INTO g_msj01
        WHEN 'L' FETCH LAST     i401_bcs INTO g_msj01
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
           FETCH ABSOLUTE g_jump i401_bcs INTO g_msj01
           LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_msj01,SQLCA.sqlcode,0)
        INITIALIZE g_msj01 TO NULL  
    ELSE
        CALL i401_show()
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
FUNCTION i401_show()
 
    DISPLAY g_msj01 TO msj01                #單頭
    CALL i401_bf(g_wc)                      #單身
    CALL cl_show_fld_cont()                   
END FUNCTION

#單身
FUNCTION i401_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        
    p_cmd           LIKE type_file.chr1,    #處理狀態          
    l_imd02         LIKE imd_file.imd02,
    l_smydesc       LIKE smy_file.smydesc,
    l_i             LIKE type_file.num5,    
    l_sw            LIKE type_file.chr1,    
    l_allow_insert  LIKE type_file.num5,    #可新增否    
    l_allow_delete  LIKE type_file.num5     #可刪除否    

    LET g_action_choice = ""
    IF g_msj01 IS NULL OR g_msj01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF

    CALL cl_opmsg('b')


    LET g_forupd_sql = " SELECT msj02,'','','','' ",
                       " FROM msj_file ",
                       " WHERE msj01 =? ",
                       " AND msj02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i401_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_msj WITHOUT DEFAULTS FROM s_msj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_docno_format("msj02")   
 
        BEFORE ROW
            LET p_cmd = ''
            BEGIN WORK
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
 
                LET p_cmd='u'
                LET g_msj_t.* = g_msj[l_ac].*  #BACKUP
                OPEN i401_bcl USING g_msj01,g_msj_t.msj02
                IF STATUS THEN
                   CALL cl_err("OPEN i401_bcl:", STATUS, 1)
                   CLOSE i401_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i401_bcl INTO g_msj[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_msj_t.msj02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       SELECT oea03,oea02 INTO
                              g_msj[l_ac].oea03,g_msj[l_ac].oea02
                        FROM oea_file WHERE oea01=g_msj[l_ac].msj02
                        LET g_msj_t.* = g_msj[l_ac].*          
                   END IF                                      
                END IF
                CALL cl_show_fld_cont()     
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #Mod No.MOD-B30621
           #INSERT INTO msj_file(msj01,msj02)
           #VALUES(g_msj01,g_msj[l_ac].msj02)
            INSERT INTO msj_file(msj01,msj02,msjlegal,msjplant)
            VALUES(g_msj01,g_msj[l_ac].msj02,g_legal,g_plant)
           #End Mod No.MOD-B30621
            IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","msj_file",g_msj01,g_msj[l_ac].msj02,SQLCA.SQLCODE,"","",1)       
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_msj[l_ac].* TO NULL            
            LET g_msj_t.* = g_msj[l_ac].*               #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD msj02

        AFTER FIELD msj02
            IF NOT cl_null(g_msj[l_ac].msj02) THEN
                 SELECT COUNT(*) INTO l_n FROM oea_file
                     WHERE oea01 = g_msj[l_ac].msj02
                       AND oeaconf <> 'X'
                     IF l_n > 0 THEN
                        SELECT oea03,oea02 INTO
                               g_msj[l_ac].oea03,g_msj[l_ac].oea02
                          FROM oea_file WHERE oea01=g_msj[l_ac].msj02
                     ELSE
                        CALL cl_err(g_msj[l_ac].msj02,'asf-959',0)
                        NEXT FIELD msj02
                     END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_msj_t.msj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM msj_file
                    WHERE msj01 = g_msj01
                     AND  msj02 = g_msj_t.msj02
                IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","msj_file",g_msj01,g_msj_t.msj02,SQLCA.SQLCODE,"","",1)       
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_msj[l_ac].* = g_msj_t.*
               CLOSE i401_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msj[l_ac].msj02,-263,1)
               LET g_msj[l_ac].* = g_msj_t.*
            ELSE
               UPDATE msj_file SET msj02=g_msj[l_ac].msj02
                WHERE msj01 = g_msj01
                  AND msj02 = g_msj_t.msj02
               IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","msj_file",g_msj01,g_msj_t.msj02,SQLCA.SQLCODE,"","",1)       
                   LET g_msj[l_ac].* = g_msj_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msj[l_ac].* = g_msj_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_msj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i401_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add 
            CLOSE i401_bcl
            COMMIT WORK

        ON ACTION controlp
            CASE
                WHEN INFIELD(msj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oea09"
                  LET g_qryparam.default1 = g_msj[l_ac].msj02
                  CALL cl_create_qry() RETURNING g_msj[l_ac].msj02
                  DISPLAY BY NAME g_msj[l_ac].msj02
                  NEXT FIELD msj02
            END CASE

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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
        END INPUT

    CLOSE i401_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i401_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000   

    CONSTRUCT l_wc ON msj02 #螢幕上取條件
       FROM s_msj[1].msj02

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
    CALL i401_bf(l_wc)
END FUNCTION

FUNCTION i401_bf(p_wc)                     #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000     

    LET g_sql =
       "SELECT msj02,oea03,oea02",
       " FROM msj_file ",
       " LEFT OUTER JOIN oea_file ON oea01 = msj02 ",
       " WHERE msj01 = '",g_msj01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY msj02"
    PREPARE i401_prepare2 FROM g_sql       #預備一下
    DECLARE msj_cs CURSOR FOR i401_prepare2
    FOR g_cnt = 1 TO g_msj.getLength()           #單身 ARRAY
       INITIALIZE g_msj[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH msj_cs INTO g_msj[g_cnt].*     #單身 ARRAY 填充
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
    CALL g_msj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i401_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msj TO s_msj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
      ON ACTION first
         CALL i401_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 

      ON ACTION previous
         CALL i401_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION jump
         CALL i401_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION next
         CALL i401_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION last
         CALL i401_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION reproduce
         LET g_action_choice="reproduce"
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

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生
      ON ACTION generate
         LET g_action_choice="generate"
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

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i401_copy()
DEFINE
    l_n             LIKE type_file.num5,    
    l_buf           LIKE type_file.chr1000, 
    l_newno1,l_oldno1  LIKE msj_file.msj01

    IF s_shut(0) THEN RETURN END IF
    IF g_msj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY " " TO msj01
    CALL cl_set_head_visible("","YES")   
    INPUT l_newno1 FROM msj01

       AFTER FIELD msj01                   #員工編號
          IF NOT cl_null(l_newno1) THEN
             SELECT COUNT(*) INTO l_n FROM msj_file
              WHERE msj01 = l_newno1
             IF l_n > 0 THEN
                CALL cl_err(g_msj01,-239,0)
                NEXT FIELD msj01
             END IF
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
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
        DISPLAY  g_msj01 TO msj01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM msj_file             #單身複製
        WHERE msj01 = g_msj01
        INTO TEMP x
     IF SQLCA.sqlcode THEN
        LET g_msg=g_msj01 CLIPPED
          CALL cl_err3("ins","x",g_msj01,"",SQLCA.SQLCODE,"","",1)       
        RETURN
    END IF
    IF cl_null(l_newno1) THEN LET l_newno1 = ' ' END IF 
    UPDATE x
        SET msj01=l_newno1             #資料鍵值
  
    INSERT INTO msj_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_msj01 CLIPPED
          CALL cl_err3("ins","msj_file",l_newno1,"",SQLCA.SQLCODE,"","",1)       
        RETURN
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K'
        LET l_oldno1= g_msj01
        LET g_msj01 = l_newno1
        CALL i401_b()
        #LET g_msj01 = l_oldno1  #FUN-C80046
        #CALL i401_show()        #FUN-C80046
    END IF
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i401_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_msj01 IS NULL THEN
       CALL cl_err("",-400,0)                 
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msj01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msj01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM msj_file WHERE msj01 = g_msj01
        IF SQLCA.sqlcode THEN
              CALL cl_err3("del","msj_file",g_msj01,"",SQLCA.SQLCODE,"","BODY DELETE:",1)       
        ELSE
            CLEAR FORM
            DROP TABLE x
         IF NOT cl_null(g_sql_tmp) THEN              
            PREPARE i401_precount_x2 FROM g_sql_tmp  
            EXECUTE i401_precount_x2                 
         END IF                                      
            CALL g_msj.clear()
            OPEN i401_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i401_bcs
               CLOSE i401_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
                 FETCH i401_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i401_bcs
               CLOSE i401_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i401_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i401_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i401_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION

FUNCTION i401_g()
DEFINE l_wc          LIKE type_file.chr1000,   
       l_sql         LIKE type_file.chr1000,   
       l_success     LIKE type_file.chr1,      
       l_msj01       LIKE msj_file.msj01,   
       l_oea01       LIKE oea_file.oea01    #訂單編號


   OPEN WINDOW i401_g_w AT 12,24 WITH FORM "amr/42f/amri401g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_locale("amri401g")

   IF STATUS THEN
      CALL cl_err('open window i401_g_w:',STATUS,0)
      RETURN
   END IF

   INPUT l_msj01 FROM FORMONLY.m HELP 1

        AFTER FIELD m                    #版別編號
            IF cl_null(l_msj01) THEN
                NEXT FIELD m
            END IF

   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW i401_g_w LET INT_FLAG=0 RETURN END IF

 
   CONSTRUCT l_wc ON oea01,oea03,oea02
        FROM oea01,oea03,oea02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      #TQC-C60162--add--str--
      ON ACTION controlp
         CASE
            WHEN INFIELD(oea01)
              CALL cl_init_qry_var()
              LET g_qryparam.form  = "q_oea09"
              LET g_qryparam.state = "c" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01 
            WHEN INFIELD(oea03)
              CALL cl_init_qry_var()
              LET g_qryparam.form  = "q_oea18"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
         END CASE
      #TQC-C60162--add--end--

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

   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i401_g_w RETURN END IF

   CLOSE WINDOW i401_g_w
   LET l_sql="SELECT oea01 FROM oea_file ",
             " WHERE oeaconf <> 'X' AND ",l_wc CLIPPED
 
   PREPARE i401_g FROM l_sql
   DECLARE i401_gcur CURSOR FOR i401_g
   IF STATUS THEN
      RETURN
   END IF

   BEGIN WORK
   LET l_success='Y'

   FOREACH i401_gcur INTO l_oea01
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         LET l_success='N'
         EXIT FOREACH
      END IF
      IF cl_null(l_msj01) THEN LET l_msj01 = ' ' END IF 
     #Mod No.MOD-B30621
     #INSERT INTO msj_file(msj01,msj02) VALUES (l_msj01,l_oea01) 
      INSERT INTO msj_file(msj01,msj02,msjlegal,msjplant)
            VALUES(l_msj01,l_oea01,g_legal,g_plant)
     #End Mod No.MOD-B30621
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
           CALL cl_err3("ins","msj_file",l_msj01,l_oea01,SQLCA.SQLCODE,"","",1)       
         LET l_success='N'
         EXIT FOREACH
      END IF

   END FOREACH


   IF l_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   LET g_msj01 = l_msj01
   LET g_wc = "1 = 1"     
   CALL i401_show()       

   DISPLAY g_msj01 TO msj01                     #單頭

   DISPLAY ARRAY g_msj TO s_msj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY

END FUNCTION
#No.FUN-960110
