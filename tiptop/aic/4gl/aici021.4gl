# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: aici021.4gl
# Descriptions...: 客戶料件最低單價維護作業
# Date & Author..: 09/03/24 By jan(FUN-A30072)
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By vealxu AFTER FIELD idr01   沒控卡
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_idr_o         RECORD LIKE idr_file.*,  
       g_idra          RECORD LIKE idr_file.*,   
       g_idra_t        RECORD LIKE idr_file.*, 
       g_idr01         LIKE idr_file.idr01,
       g_idr01_t       LIKE idr_file.idr01, 
       g_idr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           idr02       LIKE idr_file.idr02,   
           occ02       LIKE occ_file.occ02,  
           idr03       LIKE idr_file.idr03,   
           idr04       LIKE idr_file.idr04    
                       END RECORD,
       g_idr_t         RECORD                 #程式變數 (舊值)
           idr02       LIKE idr_file.idr02,   
           occ02       LIKE occ_file.occ02,  
           idr03       LIKE idr_file.idr03,   
           idr04       LIKE idr_file.idr04 
                       END RECORD,
       g_wc,g_wc2,g_sql    STRING,  
       g_rec_b         LIKE type_file.num5,                #單身筆數
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    
       l_sl            LIKE type_file.num5,                #目前處理的SCREEN LINE
       g_y             LIKE type_file.num5,           
       g_m             LIKE type_file.num5,           
       g_argv1         LIKE idr_file.idr01            

#主程式開始
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp      STRING   
DEFINE l_sql          STRING   
DEFINE g_before_input_done LIKE type_file.num5  
DEFINE g_cnt          LIKE type_file.num10 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_row_count    LIKE type_file.num10 
DEFINE g_curs_index   LIKE type_file.num10 
DEFINE g_jump         LIKE type_file.num10 
DEFINE g_no_ask       LIKE type_file.num5  
DEFINE g_str          STRING    
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time  

    LET g_idr01= NULL
    LET g_idr01_t= NULL
    
    LET p_row = 3 LET p_col = 30
    OPEN WINDOW i021_w AT p_row,p_col
        WITH FORM "aic/42f/aici021"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()

    CALL i021_menu()
    CLOSE WINDOW i021_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間)
    RETURNING g_time    
END MAIN

FUNCTION i021_cs()

      CLEAR FORM                             #清除畫面
      CALL g_idr.clear()
      CALL cl_set_head_visible("","YES") 

      INITIALIZE g_idr01 TO NULL

      #螢幕上取條件
      CONSTRUCT g_wc ON idr01,idr02,idr03,idr04  
           FROM idr01,s_idr[1].idr02,s_idr[1].idr03,   
                s_idr[1].idr04

         #No:FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No:FUN-580031 --end--       HCN
       
         ON ACTION controlp
            CASE 
               WHEN INFIELD(idr01) 
#FUN-AB0025---------mod---------------str----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form     = "q_ima"
#                   LET g_qryparam.state = "c"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
                    DISPLAY g_qryparam.multiret TO idr01
                    NEXT FIELD idr01
               WHEN INFIELD(idr02)   
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_occ"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO idr02
                    NEXT FIELD idr02
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
     
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
     
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         #No:FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

   LET g_sql= "SELECT UNIQUE idr01 FROM idr_file",   
              " WHERE ", g_wc CLIPPED,
              " ORDER BY idr01"
   PREPARE i021_prepare FROM g_sql      #預備一下
   DECLARE i021_b_cs SCROLL CURSOR WITH HOLD FOR i021_prepare   #宣告成可捲動的

   LET g_sql_tmp= "SELECT UNIQUE idr01 FROM idr_file",  
                  " WHERE ", g_wc CLIPPED,
                  " INTO TEMP x "
   DROP TABLE x
   PREPARE i021_precount_x FROM g_sql_tmp  
   EXECUTE i021_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i021_precount FROM g_sql
   DECLARE i021_count CURSOR FOR i021_precount
END FUNCTION

FUNCTION i021_menu()

   WHILE TRUE

      CALL i021_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i021_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i021_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i021_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i021_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i021_copy()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_idr),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_idr01 IS NOT NULL THEN
                  LET g_doc.column1 = "idr01"
                  LET g_doc.value1 = g_idr01
                  CALL cl_doc()
               END IF 
            END IF

      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i021_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_idr.clear()
   INITIALIZE g_idr01 LIKE idr_file.idr01
   INITIALIZE g_idra.* LIKE idr_file.*      #DEFAULT 設定
   LET g_idr01_t = NULL
   #預設值及將數值類變數清成零
   LET g_idr_o.* = g_idra.*
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i021_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_idra.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_idra.idr01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b=0
      CALL i021_b()                   #輸入單身
      LET g_idr01_t=g_idr01
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i021_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  
       l_cnt           LIKE type_file.num5,    
       p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       

   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INPUT BY NAME g_idra.idr01 WITHOUT DEFAULTS  

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i021_set_entry(p_cmd)
         CALL i021_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
       
      AFTER FIELD idr01                  #
         IF NOT cl_null(g_idra.idr01) THEN
            #FUN-AB0059 -----------add start--------------
            IF NOT s_chk_item_no(g_idra.idr01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD idr01
            END IF 
            #FUN-AB0059 -----------add end----------------
            SELECT COUNT(*) INTO l_cnt FROM ima_file
             WHERE ima01 = g_idra.idr01
               AND imaacti = 'Y'
            IF l_cnt = 0 THEN
               CALL cl_err('','mfg1201',1)
               NEXT FIELD idr01
            END IF
            LET g_idr_o.idr01=g_idra.idr01
            LET g_idr01=g_idra.idr01
         END IF

      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(idr01)
#FUN-AB0025---------mod---------------str----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima" 
#              LET g_qryparam.default1 = g_idra.idr01
#              CALL cl_create_qry() RETURNING g_idra.idr01
               CALL q_sel_ima(FALSE, "q_ima","",g_idra.idr01,"","","","","",'' ) 
                 RETURNING  g_idra.idr01 
#FUN-AB0025---------mod------------end-----------------
               DISPLAY  g_idra.idr01 TO idr01
               NEXT FIELD idr01
             OTHERWISE EXIT CASE 
         END CASE
               
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
   END INPUT
END FUNCTION

FUNCTION i021_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idr01",TRUE)
   END IF
END FUNCTION

FUNCTION i021_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idr01",FALSE)
   END IF
END FUNCTION

FUNCTION i021_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_idr01 TO NULL 

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i021_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i021_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_idr01 TO NULL
   ELSE
      OPEN i021_count
      FETCH i021_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i021_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i021_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1      #處理方式   #No.FUN-680122 CHAR(1)

   CASE p_flag
      WHEN 'N' FETCH NEXT     i021_b_cs INTO g_idr01
      WHEN 'P' FETCH PREVIOUS i021_b_cs INTO g_idr01
      WHEN 'F' FETCH FIRST    i021_b_cs INTO g_idr01
      WHEN 'L' FETCH LAST     i021_b_cs INTO g_idr01 
      WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
 
                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121
            
                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121
            
                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i021_b_cs INTO g_idr01
           LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idr01,SQLCA.sqlcode,0)
      INITIALIZE g_idr01 TO NULL 
   ELSE
      CALL i021_show()
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
FUNCTION i021_show()
   DISPLAY g_idr01 TO idr01
        
   CALL i021_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()               
END FUNCTION

#單身
FUNCTION i021_b()
DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
       l_cnt           LIKE type_file.num5,    #檢查重複用 
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
       p_cmd           LIKE type_file.chr1,    #處理狀態 
       l_length        LIKE type_file.num5,    #長度
       l_allow_insert  LIKE type_file.num5,    #可新增否 
       l_allow_delete  LIKE type_file.num5     #可刪除否

   LET g_action_choice = ""
   LET g_idra.idr01=g_idr01
   IF g_idra.idr01 IS NULL THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT idr02,'',idr03,idr04 ",  
                      "  FROM idr_file ", 
                      " WHERE idr01 =? ",
                      "   AND idr02 =? ",
                      "   AND idr03=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
                  
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_idr WITHOUT DEFAULTS FROM s_idr.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET g_idr_t.* = g_idr[l_ac].*  #BACKUP
            LET p_cmd='u'

            OPEN i021_bcl USING g_idra.idr01,g_idr_t.idr02,g_idr_t.idr03
            IF STATUS THEN
               CALL cl_err("OPEN i021_bcl:", STATUS, 1)
               CLOSE i021_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i021_bcl INTO g_idr[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_idr_t.idr03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               CALL i021_idr02(g_idr[l_ac].idr02) RETURNING g_idr[l_ac].occ02 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO idr_file(idr01,idr02,idr03,idr04)
         VALUES(g_idra.idr01,g_idr[l_ac].idr02,
                g_idr[l_ac].idr03,g_idr[l_ac].idr04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","idr_file",g_idra.idr01,g_idr[l_ac].idr02,SQLCA.sqlcode,"","",1)  
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
         INITIALIZE g_idr[l_ac].* TO NULL      #900423
         LET g_idr[l_ac].idr03=g_today
         LET g_idr[l_ac].idr04 =1
         LET g_idr_t.* = g_idr[l_ac].*             #新輸入資料
         CALL cl_show_fld_cont()     

      AFTER FIELD idr02     
         IF NOT cl_null(g_idr[l_ac].idr02) AND g_idr[l_ac].idr02 <> 'ALL' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM occ_file
             WHERE occ01 = g_idr[l_ac].idr02
               AND occacti = 'Y'
             IF l_cnt = 0 THEN 
                CALL cl_err('','anm-045',1)
                LET g_idr[l_ac].idr02 = g_idr_t.idr02
                NEXT FIELD idr02
             END IF
             CALL i021_idr02(g_idr[l_ac].idr02) RETURNING g_idr[l_ac].occ02
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('idr02:',g_errno,1)
                LET g_idr[l_ac].idr02 = g_idr_t.idr02
                NEXT FIELD idr02                                                                                                  
             END IF
         END IF
         IF p_cmd = 'a' OR (p_cmd='u' AND g_idr[l_ac].idr02<>g_idr_t.idr02) THEN
            IF NOT cl_null(g_idr[l_ac].idr02) AND NOT cl_null(g_idr[l_ac].idr03) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idr_file
               WHERE idr01 = g_idra.idr01
                 AND idr02 = g_idr[l_ac].idr02
                 AND idr03 = g_idr[l_ac].idr03
               IF l_cnt > 0 THEN
                  CALL cl_err('','-239',1)
                  NEXT FIELD idr02
               END IF
            END IF
         END IF
      
      AFTER FIELD idr03 
         IF p_cmd = 'a' OR (p_cmd='u' AND g_idr[l_ac].idr03<>g_idr_t.idr03) THEN
            IF NOT cl_null(g_idr[l_ac].idr02) AND NOT cl_null(g_idr[l_ac].idr03) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idr_file
               WHERE idr01 = g_idra.idr01
                 AND idr02 = g_idr[l_ac].idr02
                 AND idr03 = g_idr[l_ac].idr03
               IF l_cnt > 0 THEN
                  CALL cl_err('','-239',1)
                  NEXT FIELD idr03
               END IF
            END IF
         END IF

      AFTER FIELD idr04
         IF NOT cl_null(g_idr[l_ac].idr04) THEN
            IF g_idr[l_ac].idr04 <= 0 THEN
               CALL cl_err('','aec-042',1)
               NEXT FIELD idr04
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_idra.idr01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
               DELETE FROM idr_file WHERE idr01 = g_idra.idr01
                                      AND idr02 = g_idr_t.idr02
                                      AND idr03 = g_idr_t.idr03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","idr_file",g_idra.idr01,g_idr_t.idr02,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_idr[l_ac].* = g_idr_t.*
            CLOSE i021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_idr[l_ac].idr02,-263,1)
            LET g_idr[l_ac].* = g_idr_t.*
         ELSE
            UPDATE idr_file SET idr02=g_idr[l_ac].idr02,
                                idr03=g_idr[l_ac].idr03,
                                idr04=g_idr[l_ac].idr04
                          WHERE idr01 = g_idra.idr01 
                            AND idr02 = g_idr_t.idr02
                            AND idr03 = g_idr_t.idr03
            IF SQLCA.sqlcode THEN #No.FUN-660127
               LET g_idr[l_ac].* = g_idr_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_idr[l_ac].* = g_idr_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_idr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030
         CLOSE i021_bcl
         COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(idr02) AND l_ac > 1 THEN
            LET g_idr[l_ac].* = g_idr[l_ac-1].*
            NEXT FIELD idr02
         END IF

      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO") 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON ACTION controlp
         CASE 
            WHEN INFIELD(idr02) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_occ"
                 LET g_qryparam.default1 = g_idr[l_ac].idr02
                 CALL cl_create_qry() RETURNING g_idr[l_ac].idr02
                 DISPLAY BY NAME g_idr[l_ac].idr02
                 NEXT FIELD idr02
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
      
   CLOSE i021_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i021_idr02(p_idr02)
DEFINE p_idr02   LIKE idr_file.idr02
DEFINE l_occ02   LIKE occ_file.occ02
DEFINE l_occacti LIKE occ_file.occacti

     LET g_errno=''
     SELECT occ02,occacti INTO l_occ02,l_occacti
       FROM occ_file
      WHERE occ01 = p_idr02
      CASE 
         WHEN SQLCA.sqlcode=100   LET g_errno='anm-045'
                                  LET l_occ02 = NULL
         WHEN l_occacti='N'       LET g_errno='9028'
         OTHERWISE                                                                                                                    
               LET g_errno=SQLCA.sqlcode USING '------'                                                                                
     END CASE
     RETURN l_occ02
END FUNCTION

   
FUNCTION i021_b_askkey()
DEFINE l_wc            LIKE type_file.chr1000     

   CALL cl_opmsg('q')
   CLEAR idr02,idr03,idr04
   #螢幕上取條件
   CONSTRUCT l_wc ON idr02,idr03,idr04 
        FROM s_idr[1].idr02,s_idr[1].idr03,s_idr[1].idr04

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON ACTION controlp
         CASE 
            WHEN INFIELD(idr02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO idr02
                 NEXT FIELD idr02
            OTHERWISE EXIT CASE
            END CASE
            
      ON IDLE g_idle_seconds   
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   CALL i021_b_fill(l_wc)
   CALL cl_opmsg('b')
END FUNCTION

FUNCTION i021_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000        

   LET g_sql = "SELECT idr02,'',idr03,idr04",   #FUN-7B0116 add idr031
               "  FROM idr_file",
               " WHERE idr01 = '",g_idr01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE i021_prepare2 FROM g_sql      #預備一下
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE i021_curs1 CURSOR FOR i021_prepare2
   CALL g_idr.clear()
   LET g_cnt = 1
   FOREACH i021_curs1 INTO g_idr[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('B_FILL:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      CALL i021_idr02(g_idr[g_cnt].idr02) RETURNING g_idr[g_cnt].occ02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_idr.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION

FUNCTION i021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idr TO s_idr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         CALL i021_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL i021_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 

      ON ACTION jump 
         CALL i021_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 	 ACCEPT DISPLAY                   

      ON ACTION next
         CALL i021_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   

      ON ACTION last 
         CALL i021_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 
                              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY


      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document     
         LET g_action_choice="related_document"          
         EXIT DISPLAY  

      ON ACTION controls        
         CALL cl_set_head_visible("","AUTO")           

      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i021_r()
   IF g_idr01 IS NULL THEN
      CALL cl_err("",-400,0)   
      RETURN 
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL 
       LET g_doc.column1 = "idr01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_idr01     
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM idr_file
       WHERE idr01=g_idr01  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","idr_file",g_idr01,'',SQLCA.sqlcode,"","BODY DELETE",1)  
      ELSE
         CLEAR FORM
         CALL g_idr.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i021_precount_x2 FROM g_sql_tmp 
         EXECUTE i021_precount_x2  
         OPEN i021_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i021_b_cs
            CLOSE i021_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i021_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i021_b_cs
            CLOSE i021_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i021_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i021_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i021_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION

#================================
# 複製
#================================
FUNCTION i021_copy()
DEFINE
   l_idr01,l_oldno1    LIKE idr_file.idr01,
   l_idr02,l_oldno2    LIKE idr_file.idr02,
   l_cnt               INTEGER,
   l_buf               VARCHAR(100)

   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   IF s_shut(0) THEN RETURN END IF
   IF g_idr01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL i021_set_entry('a')
   LET g_before_input_done = TRUE

   INPUT l_idr01 FROM idr01
      AFTER FIELD idr01
         IF NOT cl_null(l_idr01) THEN
            #FUN-AB0059 -------------add start-----------
            IF NOT s_chk_item_no(l_idr01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD idr01
            END IF
            #FUN-AB0059 -----------add end----------------
            SELECT COUNT(*) INTO l_cnt FROM ima_file
             WHERE ima01 = l_idr01
               AND imaacti = 'Y'
            IF l_cnt = 0 THEN
               CALL cl_err('','mfg1201',1)
               NEXT FIELD idr01
            END IF
         END IF

   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(idr01)
#FUN-AB0025---------mod---------------str----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima" 
#              LET g_qryparam.default1 = l_idr01
#              CALL cl_create_qry() RETURNING l_idr01
               CALL q_sel_ima(FALSE, "q_ima","",l_idr01,"","","","","",'' )
                 RETURNING l_idr01 
#FUN-AB0025--------mod---------------end----------------
               DISPLAY  l_idr01 TO idr01
               NEXT FIELD idr01
             OTHERWISE EXIT CASE 
         END CASE
         
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
      DISPLAY g_idr01 TO idr01
      LET INT_FLAG = 0
      RETURN
   END IF

   BEGIN WORK
   DROP TABLE x
   SELECT * FROM idr_file
    WHERE idr01 = g_idr01
     INTO TEMP x
   UPDATE x SET idr01    = l_idr01
   INSERT INTO idr_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","idr_file",l_idr01,'',SQLCA.sqlcode,"","idr:",1)
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_buf,') O.K'

   LET l_oldno1 = g_idr01
   LET g_idr01  = l_idr01
   CALL i021_b()
   #LET g_idr01  = l_oldno1  #FUN-C30027
   #CALL i021_show()         #FUN-C30027
END FUNCTION
#FUN-A30072
