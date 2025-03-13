# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axct900.4gl
# Descriptions...: 轉撥單價維護作業
# Date & Author..: NO.FUN-770023 07/07/07 By rainy
# Modify.........: NO.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940184 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/10/12 By baofei好和資料拋轉如果選擇的營運中心所對應的DB已經拋轉，則不重復拋轉
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90119 10/09/17 By Summer 當tm.s='4'時,g_sql增加ccc07='1'的條件
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.MOD-C60092 12/06/12 By ck2yuan create/insert時增加t900_tmp欄位azp01,對應後續select t900_tmp三個欄位
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_cxk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cxk01       LIKE cxk_file.cxk01,        #料號
        cxk02       LIKE cxk_file.cxk02,        #品名
        cxk03       LIKE cxk_file.cxk03,        #規格
        cxk04       LIKE cxk_file.cxk04,        #轉撥單價
        cxk05       LIKE cxk_file.cxk05         #建立日期
                    END RECORD,
    g_cxk_t         RECORD                 #程式變數 (舊值)
        cxk01       LIKE cxk_file.cxk01,        #料號
        cxk02       LIKE cxk_file.cxk02,        #品名
        cxk03       LIKE cxk_file.cxk03,        #規格
        cxk04       LIKE cxk_file.cxk04,        #轉撥單價
        cxk05       LIKE cxk_file.cxk05         #建立日期
                    END RECORD,
    g_azp           DYNAMIC ARRAY OF RECORD  #(資料拋轉)    
        select      LIKE type_file.chr1,     # 選擇
        azp01       LIKE azp_file.azp01,     # 營運中心代碼
        azp02       LIKE azp_file.azp02,     # 營運中心名稱
        azp03       LIKE azp_file.azp03      # 資料庫代碼
                    END RECORD,
    g_wc2,g_sql     STRING,   
    g_rec_b         LIKE type_file.num5,                #單身筆數        
    g_rec_b1        LIKE type_file.num5,                #單身筆數(資料拋轉)        
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       
    l_ac1           LIKE type_file.num5,                #目前處理的ARRAY CNT(資料拋轉)
    l_ac3           LIKE type_file.num5,                #目前處理的ARRAY CNT(資料拋轉)
    g_atot          LIKE type_file.num5,                #目前處理的ARRAY CNT(資料拋轉)
    g_msg           STRING,
    g_err           STRING
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt               LIKE type_file.num10            
DEFINE   g_cnt1              LIKE type_file.num10            
DEFINE   g_i                 LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        
 
#FUN-770023
MAIN
  DEFINE p_row,p_col   LIKE type_file.num5      
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time    
   LET p_row = 4 LET p_col = 27
   OPEN WINDOW t900_w AT p_row,p_col WITH FORM "axc/42f/axct900"  
               ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL t900_b_fill(g_wc2)
   CALL t900_menu()
   CLOSE WINDOW t900_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間)
         RETURNING g_time    
END MAIN
 
FUNCTION t900_menu()
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL t900_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t900_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_cxk[l_ac].cxk01 IS NOT NULL THEN
                  LET g_doc.column1 = "cxk01"
                  LET g_doc.value1 = g_cxk[l_ac].cxk01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cxk),'','')
            END IF
 
        #整批產生
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL t900_g()
               LET g_wc2 = '1=1' CALL t900_b_fill(g_wc2)
            END IF
 
        #資料拋轉
         WHEN "carry_data"
            IF cl_chk_act_auth() AND g_rec_b > 0 THEN
               CALL t900_dbs()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t900_q()
   CALL t900_b_askkey()
END FUNCTION
 
FUNCTION t900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,             #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,             #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,             #單身鎖住否       
    p_cmd           LIKE type_file.chr1,             #處理狀態     
    l_allow_insert  LIKE type_file.chr1,             #可新增否
    l_allow_delete  LIKE type_file.chr1              #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT cxk01,cxk02,cxk03,cxk04,cxk05 FROM cxk_file",
                       " WHERE cxk01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_cxk WITHOUT DEFAULTS FROM s_cxk.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
               CALL t900_set_entry(p_cmd)                                       
               CALL t900_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_cxk_t.* = g_cxk[l_ac].*  #BACKUP
               OPEN t900_bcl USING g_cxk_t.cxk01
               IF STATUS THEN
                  CALL cl_err("OPEN t900_bcl:", STATUS, 1)    
                   LET l_lock_sw = "Y"
               ELSE
                  FETCH t900_bcl INTO g_cxk[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_cxk_t.cxk01,SQLCA.sqlcode,1)   
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
                                                    
           LET g_before_input_done = FALSE                                      
           CALL t900_set_entry(p_cmd)                                           
           CALL t900_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
 
           INITIALIZE g_cxk[l_ac].* TO NULL    
           LET g_cxk[l_ac].cxk05 = g_today       #Body default
           LET g_cxk[l_ac].cxk04 = 0             #Body default
           LET g_cxk_t.* = g_cxk[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD cxk01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE t900_bcl
              CANCEL INSERT
           END IF
           INSERT INTO cxk_file(cxk01,cxk02,cxk03,cxk04,cxk05)
                  VALUES(g_cxk[l_ac].cxk01,g_cxk[l_ac].cxk02,
                         g_cxk[l_ac].cxk03,g_cxk[l_ac].cxk04,
                         g_cxk[l_ac].cxk05)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","cxk_file",g_cxk[l_ac].cxk01,"",SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD cxk01                        #check 編號是否重複
            IF NOT cl_null(g_cxk[l_ac].cxk01) THEN
              #FUN-AA0059 -----------------------add start----------------------
               IF NOT s_chk_item_no(g_cxk[l_ac].cxk01,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_cxk[l_ac].cxk01 = g_cxk_t.cxk01
                  NEXT FIELD cxk01
               END IF 
              #FUN-AA0059 --------------------------add end----------------------
               IF g_cxk[l_ac].cxk01 != g_cxk_t.cxk01 
                 OR g_cxk_t.cxk01 IS NULL THEN
 
                   SELECT count(*) INTO l_n FROM cxk_file
                    WHERE cxk01 = g_cxk[l_ac].cxk01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cxk[l_ac].cxk01 = g_cxk_t.cxk01
                       NEXT FIELD cxk01
                   END IF
                   CALL t900_cxk01()
               END IF
            ELSE
              NEXT FIELD cxk01
            END IF
 
       #品名
        AFTER FIELD cxk02
           IF cl_null(g_cxk[l_ac].cxk02) THEN
              NEXT FIELD cxk02
           END IF
       #轉撥單價
        AFTER FIELD cxk04
           IF cl_null(g_cxk[l_ac].cxk04) THEN
              NEXT FIELD cxk04
           ELSE
            IF g_cxk[l_ac].cxk04 < 0 THEN
              CALL cl_err('','axr-033',0)
              NEXT FIELD cxk04
            END IF
           END IF
       #建立日期
        AFTER FIELD cxk05
           IF cl_null(g_cxk[l_ac].cxk05) THEN
              NEXT FIELD cxk05
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_cxk_t.cxk01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "cxk01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_cxk[l_ac].cxk01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM cxk_file WHERE cxk01 = g_cxk_t.cxk01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","cxk_file",g_cxk_t.cxk01,"",SQLCA.sqlcode,"","",1)  
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
              LET g_cxk[l_ac].* = g_cxk_t.*
              CLOSE t900_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_cxk[l_ac].cxk01,-263,0)
               LET g_cxk[l_ac].* = g_cxk_t.*
           ELSE
               UPDATE cxk_file SET cxk02=g_cxk[l_ac].cxk02,
                                   cxk03=g_cxk[l_ac].cxk03,
                                   cxk04=g_cxk[l_ac].cxk04,
                                   cxk05=g_cxk[l_ac].cxk05
                WHERE cxk01 = g_cxk_t.cxk01
              
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","cxk_file",g_cxk_t.cxk01,"",SQLCA.sqlcode,"","",1) 
                  LET g_cxk[l_ac].* = g_cxk_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()            # 新增
#          LET l_ac_t = l_ac                # 新增    #FUN-D40030 mark


           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_cxk[l_ac].* = g_cxk_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_cxk.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE t900_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                # 新增    #FUN-D40030 add
           CLOSE t900_bcl
           COMMIT WORK       
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(cxk01) 
#FUN-AA0059---------mod------------str----------------- 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form  = "q_ima"
#                 LET g_qryparam.default1 = g_cxk[l_ac].cxk01
#                 CALL cl_create_qry() RETURNING g_cxk[l_ac].cxk01
                  CALL q_sel_ima(FALSE, "q_ima","",g_cxk[l_ac].cxk01,"","","","","",'')  
                    RETURNING  g_cxk[l_ac].cxk01
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_cxk[l_ac].cxk01
                  CALL t900_cxk01()
                  NEXT FIELD cxk01
               OTHERWISE EXIT CASE
            END CASE
           
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(cxk01) AND l_ac > 1 THEN
              LET g_cxk[l_ac].* = g_cxk[l_ac-1].*
              NEXT FIELD cxk01
           END IF
 
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
 
        END INPUT
 
    CLOSE t900_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t900_cxk01()
  DEFINE l_ima02  LIKE ima_file.ima02,
         l_ima021 LIKE ima_file.ima021
 
  SELECT ima02,ima021 INTO l_ima02,l_ima021
    FROM ima_file
   WHERE ima01 = g_cxk[l_ac].cxk01
  IF SQLCA.sqlcode THEN
    LET l_ima02 = ''
    LET l_ima021 = ''
  END IF 
  LET g_cxk[l_ac].cxk02 = l_ima02
  LET g_cxk[l_ac].cxk03 = l_ima021
  DISPLAY BY NAME g_cxk[l_ac].cxk02,g_cxk[l_ac].cxk03
END FUNCTION
 
 
 
FUNCTION t900_b_askkey()
 
   CLEAR FORM
   CALL g_cxk.clear()
 
   CONSTRUCT g_wc2 ON cxk01,cxk02,cxk03,cxk04,cxk05
       FROM s_cxk[1].cxk01,s_cxk[1].cxk02,s_cxk[1].cxk03,
            s_cxk[1].cxk04,s_cxk[1].cxk05
       BEFORE CONSTRUCT
              CALL cl_qbe_init()
       ON ACTION controlp
          CASE
            WHEN INFIELD(cxk01) 
#FUN-AA0059---------mod------------str----------------- 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  = "q_ima"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret 
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO cxk01
               NEXT FIELD cxk01
            OTHERWISE EXIT CASE
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
 
   CALL t900_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   # p_wc2         LIKE type_file.chr1000
     p_wc2         STRING       #NO.FUN-910082    
 
    LET g_sql =
        "SELECT cxk01,cxk02,cxk03,cxk04,cxk05",
        " FROM cxk_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE t900_pb FROM g_sql
    DECLARE cxk_curs CURSOR FOR t900_pb
 
    CALL g_cxk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cxk_curs INTO g_cxk[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_cxk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t900_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1    
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
  DISPLAY ARRAY g_cxk TO s_cxk.* ATTRIBUTE(COUNT=g_rec_b)
 
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
   
#@  ON ACTION 相關文件  
    ON ACTION related_document 
       LET g_action_choice="related_document"
       EXIT DISPLAY
 
    ON ACTION exporttoexcel   
       LET g_action_choice = 'exporttoexcel'
       EXIT DISPLAY
 
    ON ACTION batch_generate
       LET g_action_choice = 'batch_generate'
       EXIT DISPLAY
    ON ACTION carry_data
       LET g_action_choice = 'carry_data'
       EXIT DISPLAY
 
    AFTER DISPLAY
         CONTINUE DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t900_out()
  DEFINE   l_za05          LIKE za_file.za05            
  DEFINE   g_str           STRING                   
  DEFINE   l_i             LIKE type_file.num5
  
  LET g_pdate = g_today
  LET g_rlang = g_lang
  IF cl_null(g_wc2) THEN 
     IF l_ac > 0 THEN
       LET g_wc2 = " cxk01 IN("
       FOR l_i = 1 TO l_ac
         IF l_i > 1 THEN
           LET g_wc2 = g_wc2 CLIPPED ,","
         END IF
         LET g_wc2 = g_wc2 ,"'", g_cxk[l_i].cxk01,"'"
       END FOR
       LET g_wc2 = g_wc2,")"
     ELSE
       CALL cl_err('','9057',0)
     END IF
  RETURN END IF
  CALL cl_wait()
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  LET g_sql="SELECT * FROM cxk_file ",      # 組合出 SQL 指令
            " WHERE ",g_wc2 CLIPPED
  #是否列印選擇條件
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(g_wc2,'cxk01,cxk02,cxk03,cxk04,cxk05')
          RETURNING g_str
  ELSE
     LET g_str = " "
  END IF
  CALL cl_prt_cs1('axct900','axct900',g_sql,g_str)
END FUNCTION
 
 
FUNCTION t900_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("cxk01,cxk02,cxk03",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION t900_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
  
  #更改狀態下只能改轉撥單價及建立日期                                                                              
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("cxk01,cxk02,cxk03",FALSE)                                      
  END IF                                                                       
END FUNCTION                                                                    
 
 
#資料拋轉  insert/update
FUNCTION t900_dbs() 
   DEFINE p_row,p_col   LIKE type_file.num5      
   DEFINE l_ans         LIKE type_file.chr1,  
          l_exit_sw     LIKE type_file.chr1,  
          i             LIKE type_file.num5,  
          l_cnt         LIKE type_file.num5,  
          l_allow_insert  LIKE type_file.chr1,             #可新增否
          l_allow_delete  LIKE type_file.chr1              #可刪除否
   DEFINE l_sql         STRING
 
   IF s_shut(0) THEN RETURN END IF
   LET l_ans = '2'
   #WHILE l_ans IS NULL OR l_ans NOT MATCHES "[120]"
   #   CALL cl_getmsg('axm-029',g_lang) RETURNING g_msg
   #   LET INT_FLAG = 0  
   #   PROMPT g_msg CLIPPED || ': ' FOR CHAR l_ans
   #      ON IDLE g_idle_seconds
   #         CALL cl_on_idle()
   #      ON ACTION about         
   #         CALL cl_about()      
 
   #      ON ACTION help          
   #         CALL cl_show_help()  
 
   #      ON ACTION controlg      
   #         CALL cl_cmdask()     
   #   END PROMPT
   #   IF INT_FLAG THEN EXIT WHILE END IF
   #END WHILE
   #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #IF l_ans = '0' THEN RETURN END IF
 
   LET p_row = 10 LET p_col = 25
   OPEN WINDOW t900_c_w AT p_row,p_col WITH FORM "axc/42f/axct900_c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("axct900_c")
    LET l_sql = "SELECT 'Y',zxy03,azp02,azp03 FROM zxy_file,azp_file",
                " WHERE zxy03=azp01",
                "   AND zxy01='",g_user,"'",
                "   AND azp053='Y'",
                "   AND azp01 <>'", g_plant CLIPPED,"'",
                " ORDER BY zxy03"
    DECLARE t900_c_cs CURSOR FROM l_sql
 
    CALL g_azp.clear()
    LET g_rec_b1=0
    LET g_cnt1 = 1
    FOREACH t900_c_cs INTO g_azp[g_cnt1].*   #單身 ARRAY 填充
       IF sqlca.sqlcode THEN
          LET g_err="foreach azp data error"
          CALL cl_err(g_err CLIPPED,sqlca.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt1 = g_cnt1 + 1
       IF g_cnt1 > g_max_rec THEN
          CALL cl_err("",9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_azp.deleteElement(g_cnt1)
    LET g_cnt1 = g_cnt1 - 1
 
    #改成INPUT 
    LET g_rec_b1 = g_cnt1
    LET l_ac1 = 0
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_azp WITHOUT DEFAULTS FROM s_azp.*
      ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE INPUT
          IF g_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(l_ac1)
          END IF
 
       BEFORE ROW
          LET l_ac1 = ARR_CURR()
 
       AFTER FIELD select
          IF NOT cl_null(g_azp[l_ac1].select) THEN
             IF g_azp[l_ac1].select NOT MATCHES "[YN]" THEN
                NEXT FIELD select
             END IF
          END IF
       AFTER INPUT
          FOR g_i =1 TO g_rec_b1
             IF g_azp[g_i].select = 'Y' AND
                NOT cl_null(g_azp[g_i].azp01)  THEN
             END IF
          END FOR
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION select_all
          FOR g_i = 1 TO g_rec_b1
              LET g_azp[g_i].select="Y"
          END FOR
       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b1
              LET g_azp[g_i].select="N"
          END FOR
       AFTER ROW
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
    END INPUT
 
    IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t900_c_w
         RETURN
    END IF
    CLOSE WINDOW t900_c_w
 
    BEGIN WORK
    LET g_success='Y'
    IF l_ans = '1' THEN CALL t900_dbs_ins() END IF
    IF l_ans = '2' THEN CALL t900_dbs_upd() END IF
    IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
    ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
    END IF
END FUNCTION
 
 
 
 
FUNCTION t900_dbs_ins()
   DEFINE l_exit_sw     LIKE type_file.chr1,    
          l_chk_cxk     LIKE type_file.chr1,    
          i             LIKE type_file.num5,    
          j             LIKE type_file.num5,
          l_cnt         LIKE type_file.num5     
   DEFINE l_i           LIKE type_file.num5   #FUN-990069
   DEFINE l_sql         STRING 
   DEFINE l_flag        LIKE type_file.chr1   #FUN-990069
 
   MESSAGE ' COPY FOR INSERT .... '
   
   IF g_rec_b < 1 THEN 
      CALL cl_err('','9057',0)
      LET g_success = 'N'
      RETURN 
   END IF
 
  #讀取相關資料..........................................
   LET l_chk_cxk = 'Y'
   DROP TABLE w1
   
   #FOR l_i = 1 TO g_rec_b
   #  SELECT * FROM cxk_file WHERE cxk01 = g_cxk[l_i].cxk01 INTO TEMP w1
   #END FOR
  
   LET l_sql = "SELECT * FROM cxk_file WHERE ",g_wc2 CLIPPED," INTO TEMP w1"
   PREPARE t900_tmp_pre FROM l_sql
   EXECUTE t900_tmp_pre
   IF STATUS THEN LET l_chk_cxk='N' END IF
 
 
   FOR i = 1 TO g_rec_b1
       IF cl_null(g_azp[i].azp03) THEN  CONTINUE FOR END IF
#FUN-990069---begin
       LET l_flag = 'N'
       IF i>1 THEN
        FOR j = 1 TO i-1
            IF g_azp[i].azp03 = g_azp[j].azp03 THEN 
               LET l_flag = 'Y' 
               EXIT FOR
            END IF
        END FOR 
       END IF
       IF l_flag = 'Y' THEN CONTINUE FOR END IF 
#FUN-990069---end
       IF g_azp[i].select = 'Y' THEN
         #LET g_azp[i].azp03 = s_dbstring(g_azp[i].azp03)  
         #LET g_sql='INSERT INTO ',g_azp[i].azp03 CLIPPED,'cxk_file ',
         #          'SELECT * FROM ',g_dbs CLIPPED,'.w1'
         LET g_sql='INSERT INTO ',cl_get_target_table(g_azp[i].azp01,'cxk_file'), #FUN-A50102
                   ' SELECT * FROM w1 '
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	      CALL cl_parse_qry_sql(g_sql,g_azp[i].azp01) RETURNING g_sql #FUN-A50102	  
         PREPARE i_cxk FROM g_sql
 
         IF l_chk_cxk = 'Y' THEN
            EXECUTE i_cxk
            IF STATUS THEN
               LET g_msg = 'ins ',g_azp[i].azp03 CLIPPED,':cxk'
               CALL cl_err(g_msg,SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOR
            END IF
         END IF
       END IF
   END FOR
END FUNCTION
 
FUNCTION t900_dbs_upd()
   DEFINE l_cxk         RECORD LIKE cxk_file.*,
          l_c,l_s,i     LIKE type_file.num5,    
          j             LIKE type_file.num5,  #FUN-990069
          l_sql         STRING, 
          l_cnt         LIKE type_file.num5    
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1   #FUN-990069
 
  # MESSAGE ' COPY FOR UPDATE .... '       #FUN-B80056     MARK
   MESSAGE ' COPY FOR THE  UPDATE .... '   #FUN-B80056     ADD
   
   IF g_rec_b < 1 THEN 
      CALL cl_err('','9057',0)
      LET g_success = 'N'
      RETURN 
   END IF
   IF cl_null(g_wc2) THEN
     IF l_ac > 0 THEN
       LET g_wc2 = " cxk01 IN("
       FOR l_i = 1 TO l_ac
         IF l_i > 1 THEN
           LET g_wc2 = g_wc2 CLIPPED ,","
         END IF
         LET g_wc2 = g_wc2 CLIPPED ,"'", g_cxk[l_i].cxk01,"'"
       END FOR
       LET g_wc2 = g_wc2,")"
     ELSE
       CALL cl_err('','9057',0)
       LET g_success = 'N'
       RETURN
     END IF
   END IF
  #讀取相關資料..........................................
 
   LET g_sql='SELECT * FROM cxk_file WHERE ',g_wc2 CLIPPED
   PREPARE s_cxk_p FROM g_sql
   DECLARE s_cxk CURSOR FOR s_cxk_p
 
   FOR i = 1 TO g_rec_b1
     IF cl_null(g_azp[i].azp03) THEN  CONTINUE FOR END IF
#FUN-990069---begin                                                                                                                 
       LET l_flag = 'N'                                                                                                             
       IF i>1 THEN                                                                                                                  
        FOR j = 1 TO i-1                                                                                                              
            IF g_azp[i].azp03 = g_azp[j].azp03 THEN                                                                                 
               LET l_flag = 'Y'                                                                                                     
               EXIT FOR                                                                                                             
            END IF                                                                                                                  
        END FOR                                                                                                                     
       END IF                                                                                                                       
       IF l_flag = 'Y' THEN CONTINUE FOR END IF                                                                                     
#FUN-990069---end         
     IF g_azp[i].select = 'Y' THEN
       #LET g_azp[i].azp03 = s_dbstring(g_azp[i].azp03) LET g_sql='SELECT COUNT(*) FROM ',g_azp[i].azp03 CLIPPED,'cxk_file ',
       #LET g_azp[i].azp03 = s_dbstring(g_azp[i].azp03) 
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(g_azp[i].azp01,'cxk_file'),  #FUN-A50102 
                   ' WHERE cxk01= ? ' CLIPPED
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102									
	   CALL cl_parse_qry_sql(g_sql,g_azp[i].azp01) RETURNING g_sql #FUN-A50102            
       PREPARE c_cxk_p FROM g_sql
       DECLARE c_cxk CURSOR FOR c_cxk_p
 
#-------------------- UPDATE FILE.cxk_file ------------------------------
      # MESSAGE ' COPY FOR THE  UPDATE.cxk_file .... '         #FUN-B80056    MARK
       MESSAGE ' COPY FOR THE  UPDATE.cxk_file .... '          #FUN-B80056    ADD
       FOREACH s_cxk INTO l_cxk.*
           IF STATUS THEN
             CALL cl_err('foreach cxk',STATUS,0)
             EXIT FOREACH
           END IF
 
           OPEN c_cxk USING l_cxk.cxk01
           FETCH c_cxk INTO l_cnt
           IF l_cnt > 0 THEN
             #LET g_sql='UPDATE ',g_azp[i].azp03 CLIPPED,'.cxk_file ',
             LET g_sql='UPDATE ',cl_get_target_table(g_azp[i].azp01,'cxk_file'),  #FUN-A50102
                       ' SET cxk02= ? ',
                       '    ,cxk03= ? ',
                       '    ,cxk04= ? ',
                       '    ,cxk05= ? ',
                       ' WHERE cxk01= ? ' CLIPPED
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102									
	         CALL cl_parse_qry_sql(g_sql,g_azp[i].azp01) RETURNING g_sql #FUN-A50102          
             PREPARE u_cxk FROM g_sql
             EXECUTE u_cxk USING l_cxk.cxk02,l_cxk.cxk03,l_cxk.cxk04,
                                 l_cxk.cxk05,l_cxk.cxk01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                LET g_msg = 'upd ',g_azp[i].azp03 CLIPPED,':cxk'
                CALL cl_err(g_msg,SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE     
            #LET g_sql="INSERT INTO ",g_azp[i].azp03 CLIPPED,"cxk_file",  #TQC-940184  
             #LET g_sql="INSERT INTO ",s_dbstring(g_azp[i].azp03 CLIPPED),"cxk_file",#TQC-940184 
             LET g_sql="INSERT INTO ",cl_get_target_table(g_azp[i].azp01,'cxk_file'),  #FUN-A50102 
                       "(cxk01, cxk02, cxk03, cxk04, cxk05)",
                       " VALUES( ?, ?, ?, ?, ?)"
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102									
	         CALL cl_parse_qry_sql(g_sql,g_azp[i].azp01) RETURNING g_sql #FUN-A50102	          
             PREPARE i_cxk_cpy FROM g_sql
             EXECUTE i_cxk_cpy USING l_cxk.cxk01,l_cxk.cxk02,l_cxk.cxk03,
                                     l_cxk.cxk04,l_cxk.cxk05
             IF STATUS THEN
                 LET g_msg = 'ins ',g_azp[i].azp03 CLIPPED,':cxk'
                 CALL cl_err(g_msg,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOR
             END IF
          END IF
       END FOREACH
     END IF
   END FOR
END FUNCTION
 
 
#產生資料
FUNCTION t900_g()
  DEFINE  l_cmd           LIKE type_file.chr1000,       
          l_cnt           LIKE type_file.num5          
  
  DEFINE  tm RECORD
               bdate      LIKE imm_file.imm02,  #起始日期
               edate      LIKE imm_file.imm02,  #結束日期
               s          LIKE type_file.chr1,  #資料來源(1.標準成本 2.實際成本 3.市價 4.月加權平均單價 5.最近銷售單價 6.平均採購單價)
               yy         LIKE type_file.num5,  #年
               mm         LIKE type_file.num5,  #月
               a          LIKE type_file.chr1   #加成計價(1.不加成 2.依產品分類加成 3.依料件加成)
           END RECORD
  DEFINE  tm2 DYNAMIC ARRAY OF RECORD
               azp01      LIKE azp_file.azp01,  #營運中心
               azp02      LIKE azp_file.azp02   #營運中心名稱
           END RECORD
  DEFINE  l_azp03         LIKE azp_file.azp03   #資料庫
  DEFINE  l_plant         LIKE azp_file.azp03   #資料庫
  
  DEFINE sr RECORD
               imn03    LIKE imn_file.imn03,
               azp01    LIKE azp_file.azp01,    #FUN-A50102
               azp03    LIKE azp_file.azp03
           END RECORD 
  DEFINE l_bdate        LIKE  type_file.dat,
         l_edate        LIKE  type_file.dat,
         l_flag         LIKE  type_file.chr1,
         i              LIKE  type_file.num5
  DEFINE l_imn03        LIKE  imn_file.imn03,
         l_cxk04        LIKE  cxk_file.cxk04,
         l_ima129       LIKE  ima_file.ima129,
         l_ima131       LIKE  ima_file.ima131,
         l_ima25        LIKE  ima_file.ima25,  #庫存單位
         l_ima31        LIKE  ima_file.ima31,  #銷售單位
         l_ima44        LIKE  ima_file.ima44,  #採購單位
         l_ima531       LIKE  ima_file.ima531, #市價       (*ima44與ima25換算)
         l_ima33        LIKE  ima_file.ima33,  #最近銷售單價(*ima31與ima25換算)
         l_ima91        LIKE  ima_file.ima91,   #最近採購單價(*ima44與ima25換算) 
         l_ima31_fac    LIKE  ima_file.ima31_fac,
         l_ima44_fac    LIKE  ima_file.ima44_fac
  DEFINE l_cxk    RECORD LIKE  cxk_file.*
  DEFINE l_imb    RECORD LIKE  imb_file.*
 
#CREATE TEMP TABLE   (先依所輸入的plant抓料號和所在的plant)
 DROP TABLE t900_tmp
 CREATE TEMP TABLE t900_tmp
  (imn03 LIKE imn_file.imn03,
   azp01 LIKE azp_file.azp01,    #MOD-C60092 add
   azp03 LIKE azp_file.azp03);
 
  OPEN WINDOW t900_g_w AT 5,24 WITH FORM "axc/42f/axct900_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_locale("axct900_g")
  
  LET tm.bdate = g_today
  LET tm.edate = g_today
  LET tm.a = '1'
  #LET tm.s = '1'
  LET tm.yy = YEAR(g_today)
  LET tm.mm = MONTH(g_today)
  INPUT BY NAME tm.bdate,tm.edate,tm.s,tm.yy,tm.mm,tm.a  WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t900_set_entry_b()
         CALL t900_set_no_entry_b()
         LET g_before_input_done = TRUE
 
      AFTER FIELD edate
         IF tm.edate IS NULL OR tm.edate < tm.bdate THEN 
            NEXT FIELD edate 
         END IF
 
      BEFORE FIELD s 
         LET g_before_input_done = FALSE
         CALL t900_set_entry_b()
         LET g_before_input_done = TRUE
 
      ON CHANGE s
         IF tm.s <> '4' THEN
            LET g_before_input_done = FALSE
            CALL t900_set_no_entry_b()
            LET g_before_input_done = TRUE
            LET tm.yy = NULL LET tm.mm = null
            DISPLAY BY NAME tm.yy,tm.mm
         ELSE
           LET g_before_input_done = FALSE
           CALL t900_set_entry_b()
           LET g_before_input_done = TRUE
           LET tm.yy = YEAR(g_today)
           LET tm.mm = MONTH(g_today)
           DISPLAY BY NAME tm.yy,tm.mm
         END IF                                       
 
      AFTER FIELD s 
         IF cl_null(tm.s) THEN NEXT FIELD s END IF 
 
      AFTER FIELD yy
         IF tm.a = '4' THEN  #月加權平均單價要輸入年月
             IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         END IF
 
      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            IF tm.mm > 12 OR tm.mm < 1 THEN
               CALL cl_err('','agl-020',0)
               NEXT FIELD mm
            END IF
         END IF
         IF tm.a = '4' THEN  #月加權平均單價要輸入年月
            IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         END IF
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      AFTER INPUT
         IF int_flag THEN EXIT INPUT END IF
         CALL s_azm(tm.yy,tm.mm)
              RETURNING l_flag, l_bdate, l_edate #得出起始日與截止日
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t900_g_w
      RETURN
   END IF
 
   CALL tm2.CLEAR()
   INPUT ARRAY tm2 WITHOUT DEFAULTS FROM s_plant.*
       BEFORE ROW               
         LET l_ac3 = ARR_CURR()
 
       AFTER FIELD azp01
          IF NOT cl_null(tm2[l_ac3].azp01) THEN
             SELECT azp02 INTO tm2[l_ac3].azp02
               FROM azp_file 
              WHERE azp01 = tm2[l_ac3].azp01
             IF STATUS THEN
                CALL cl_err3("sel","azp_file",tm2[l_ac3].azp01,"",STATUS,"","sel azp",1)   
                NEXT FIELD azp01 
             END IF
             DISPLAY BY NAME tm2[l_ac3].azp02
             FOR i = 1 TO l_ac3-1      # 檢查工廠是否重覆
                 IF tm2[i].azp01 = tm2[l_ac3].azp01 THEN
                    CALL cl_err('','aom-492',1) NEXT FIELD azp01
                 END IF
             END FOR
             IF NOT s_chkdbs(g_user,tm2[l_ac3].azp01,g_rlang) THEN
                NEXT FIELD azp01
             END IF
          END IF
       AFTER INPUT                    # 檢查至少輸入一個工廠
          IF INT_FLAG THEN 
             EXIT INPUT 
          END IF
          LET g_atot = ARR_COUNT()
          FOR i = 1 TO g_atot
              IF NOT cl_null(tm2[i].azp01) THEN EXIT INPUT END IF
          END FOR
          IF i = g_atot+1 THEN
             CALL cl_err('','aom-423',1) NEXT FIELD azp01
          END IF
 
       ON ACTION CONTROLP
          CALL cl_init_qry_var()
          LET g_qryparam.form = 'q_azp'
          LET g_qryparam.default1 = tm2[l_ac3].azp01
          CALL cl_create_qry() RETURNING tm2[l_ac3].azp01
          CALL FGL_DIALOG_SETBUFFER(tm2[l_ac3].azp01)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about         
          CALL cl_about()      
       ON ACTION help          
          CALL cl_show_help()  
       ON ACTION controlg      
          CALL cl_cmdask()     
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN LET 
      INT_FLAG = 0 
      CLOSE WINDOW t900_g_w 
      RETURN 
   END IF
   CLOSE WINDOW t900_g_w 
 
 
  #依有輸入的plant 抓調撥單身的料件
   FOR i = 1 TO g_atot
     IF NOT cl_null(tm2[i].azp01) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file
        WHERE azp01 = tm2[i].azp01
 
      #LET l_plant = s_dbstring(l_azp03)   #TQC-940184    
       #LET l_plant = s_dbstring(l_azp03 CLIPPED) #TQC-940184  #FUN-A50102 
       LET g_sql = " SELECT DISTINCT imn03 ",
                   #"   FROM ",l_plant CLIPPED,"imn_file,",
                   #"        ",l_plant CLIPPED,"imm_file ",
                   "   FROM ",cl_get_target_table(tm2[i].azp01,'imn_file'),",",  #FUN-A50102
                              cl_get_target_table(tm2[i].azp01,'imm_file'),      #FUN-A50102
                   "  WHERE imn01 = imm01 ",
                   "    AND imm02 BETWEEN '", tm.bdate CLIPPED,"'",
                   "                  AND '", tm.edate CLIPPED,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
	   CALL cl_parse_qry_sql(g_sql,tm2[i].azp01) RETURNING g_sql #FUN-A50102	            
       PREPARE imn03_pre FROM g_sql
       DECLARE imn03_curs CURSOR FOR imn03_pre
       FOREACH imn03_curs INTO l_imn03
         LET l_cnt = 0
         #如果在之前的DB有抓到的就不再寫入
         SELECT COUNT(*) INTO l_cnt FROM t900_tmp
          WHERE imn03 = l_imn03
         IF l_cnt < 1 THEN
           INSERT INTO t900_tmp VALUES( l_imn03, tm2[i].azp01  , l_azp03 )     #MOD-C60092 add tm2[i].azp01
           IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","t900_tmp",l_imn03,l_azp03,SQLCA.sqlcode,"","",0) 
             CONTINUE FOREACH 
           END IF
         END IF
       END FOREACH
     END IF
   END FOR
  #####
 
 
  #將TEMP TABLE 中的資料找出來處理
   #LET g_sql = "SELECT imn03,azp03 FROM t900_tmp ORDER BY azp03,imn03"
   LET g_sql = "SELECT imn03,azp01,azp03 FROM t900_tmp ORDER BY azp03,imn03"  #FUN-A50102
   PREPARE imn_pre2 FROM g_sql
   DECLARE imn_curs2 CURSOR FOR imn_pre2
   FOREACH imn_curs2 INTO sr.*
     LET l_ima129 = 0
     LET l_ima131 = ''
     LET l_ima25  = ''     #庫存單位
     LET l_ima31  = ''     #銷售單位
     LET l_ima44  = ''     #採購單位
     LET l_ima531 = 0      #市價       (*ima44與ima25換算)
     LET l_ima33  = 0      #最近銷售單價(*ima31與ima25換算)
     LET l_ima91  = 0      #最近採購單價(*ima44與ima25換算) 
 
    #LET l_plant = sr.azp03 CLIPPED,"." #TQC-940184   
     LET l_plant = s_dbstring(sr.azp03 CLIPPED) #TQC-940184    
     LET l_cxk.cxk01 = sr.imn03
     LET l_cxk.cxk05 = g_today 
     LET g_sql =" SELECT ima02,ima021,ima129,ima131,ima25, ",
                "        ima31,ima44,ima531,ima33,ima91 ",
                #"   FROM ",l_plant,"ima_file",
                "   FROM ",cl_get_target_table(sr.azp01,'ima_file'),  #FUN-A50102
                "  WHERE ima01 ='", sr.imn03 CLIPPED,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
     CALL cl_parse_qry_sql(g_sql,sr.azp01) RETURNING g_sql #FUN-A50102	
     PREPARE ima02_pre FROM g_sql
     EXECUTE ima02_pre INTO l_cxk.cxk02,l_cxk.cxk03,
                            l_ima129,l_ima131,l_ima25,l_ima31,
                            l_ima44,l_ima531,l_ima33,l_ima91
     IF sqlca.sqlcode THEN
       LET l_cxk.cxk02 = ''
       LET l_cxk.cxk03 = ''
       CONTINUE FOREACH
     END IF
 
     IF tm.s = '1' OR tm.s = '2' THEN
       #LET g_sql= "SELECT * FROM ",l_plant,"imb_file",
       LET g_sql= "SELECT * FROM ",cl_get_target_table(sr.azp01,'imb_file'),  #FUN-A50102
                  " WHERE imb01 = '",sr.imn03 CLIPPED,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
       CALL cl_parse_qry_sql(g_sql,sr.azp01) RETURNING g_sql      #FUN-A50102	
       PREPARE imb_pre FROM g_sql
       EXECUTE imb_pre INTO l_imb.*
       IF STATUS = 100 OR SQLCA.sqlcode THEN
          CALL cl_err3("sel","imb_file",l_plant,sr.imn03,STATUS,"","sel imb",0)   
          LET l_imb.imb111 =0  LET l_imb.imb112 =0  LET l_imb.imb1131=0  LET l_imb.imb1132=0
          LET l_imb.imb114 =0  LET l_imb.imb115 =0  LET l_imb.imb1151=0  LET l_imb.imb116 =0
          LET l_imb.imb1171=0  LET l_imb.imb1172=0  LET l_imb.imb119 =0  LET l_imb.imb120 =0
          LET l_imb.imb121 =0  LET l_imb.imb122 =0  LET l_imb.imb1231=0  LET l_imb.imb1232=0
          LET l_imb.imb124 =0  LET l_imb.imb125 =0  LET l_imb.imb126 =0  LET l_imb.imb1251=0
          LET l_imb.imb1271=0  LET l_imb.imb1272=0  LET l_imb.imb129 =0  LET l_imb.imb130 =0
          LET l_imb.imb211 =0  LET l_imb.imb212 =0  LET l_imb.imb2131=0  LET l_imb.imb2132=0
          LET l_imb.imb214 =0  LET l_imb.imb215 =0  LET l_imb.imb2151=0  LET l_imb.imb216 =0
          LET l_imb.imb2171=0  LET l_imb.imb2172=0  LET l_imb.imb219 =0  LET l_imb.imb220 =0
          LET l_imb.imb221 =0  LET l_imb.imb222 =0  LET l_imb.imb2231=0  LET l_imb.imb2232=0
          LET l_imb.imb224 =0  LET l_imb.imb225 =0  LET l_imb.imb226 =0  LET l_imb.imb2251=0
          LET l_imb.imb2271=0  LET l_imb.imb2272=0  LET l_imb.imb229 =0  LET l_imb.imb230 =0
       END IF
 
       IF cl_null(l_imb.imb111 ) THEN LET l_imb.imb111 =0 END IF  IF cl_null(l_imb.imb112 ) THEN LET l_imb.imb112 =0 END IF  
       IF cl_null(l_imb.imb1131) THEN LET l_imb.imb1131=0 END IF  IF cl_null(l_imb.imb1132) THEN LET l_imb.imb1132=0 END IF
       IF cl_null(l_imb.imb114 ) THEN LET l_imb.imb114 =0 END IF  IF cl_null(l_imb.imb115 ) THEN LET l_imb.imb115 =0 END IF  
       IF cl_null(l_imb.imb1151) THEN LET l_imb.imb1151=0 END IF  IF cl_null(l_imb.imb116 ) THEN LET l_imb.imb116 =0 END IF 
       IF cl_null(l_imb.imb1171) THEN LET l_imb.imb1171=0 END IF  IF cl_null(l_imb.imb1172) THEN LET l_imb.imb1172=0 END IF  
       IF cl_null(l_imb.imb119 ) THEN LET l_imb.imb119 =0 END IF  IF cl_null(l_imb.imb120 ) THEN LET l_imb.imb120 =0 END IF 
       IF cl_null(l_imb.imb121 ) THEN LET l_imb.imb121 =0 END IF  IF cl_null(l_imb.imb122 ) THEN LET l_imb.imb122 =0 END IF  
       IF cl_null(l_imb.imb1231) THEN LET l_imb.imb1231=0 END IF  IF cl_null(l_imb.imb1232) THEN LET l_imb.imb1232=0 END IF 
       IF cl_null(l_imb.imb124 ) THEN LET l_imb.imb124 =0 END IF  IF cl_null(l_imb.imb125 ) THEN LET l_imb.imb125 =0 END IF 
       IF cl_null(l_imb.imb126 ) THEN LET l_imb.imb126 =0 END IF  IF cl_null(l_imb.imb1251) THEN LET l_imb.imb1251=0 END IF 
       IF cl_null(l_imb.imb1271) THEN LET l_imb.imb1271=0 END IF  IF cl_null(l_imb.imb1272) THEN LET l_imb.imb1272=0 END IF
       IF cl_null(l_imb.imb129 ) THEN LET l_imb.imb129 =0 END IF  IF cl_null(l_imb.imb130 ) THEN LET l_imb.imb130 =0 END IF 
       IF cl_null(l_imb.imb211 ) THEN LET l_imb.imb211 =0 END IF  IF cl_null(l_imb.imb212 ) THEN LET l_imb.imb212 =0 END IF 
       IF cl_null(l_imb.imb2131) THEN LET l_imb.imb2131=0 END IF  IF cl_null(l_imb.imb2132) THEN LET l_imb.imb2132=0 END IF 
       IF cl_null(l_imb.imb214 ) THEN LET l_imb.imb214 =0 END IF  IF cl_null(l_imb.imb215 ) THEN LET l_imb.imb215 =0 END IF
       IF cl_null(l_imb.imb2151) THEN LET l_imb.imb2151=0 END IF  IF cl_null(l_imb.imb216 ) THEN LET l_imb.imb216 =0 END IF 
       IF cl_null(l_imb.imb2171) THEN LET l_imb.imb2171=0 END IF  IF cl_null(l_imb.imb2172) THEN LET l_imb.imb2172=0 END IF
       IF cl_null(l_imb.imb219 ) THEN LET l_imb.imb219 =0 END IF  IF cl_null(l_imb.imb220 ) THEN LET l_imb.imb220 =0 END IF 
       IF cl_null(l_imb.imb221 ) THEN LET l_imb.imb221 =0 END IF  IF cl_null(l_imb.imb222 ) THEN LET l_imb.imb222 =0 END IF
       IF cl_null(l_imb.imb2231) THEN LET l_imb.imb2231=0 END IF  IF cl_null(l_imb.imb2232) THEN LET l_imb.imb2232=0 END IF 
       IF cl_null(l_imb.imb224 ) THEN LET l_imb.imb224 =0 END IF  IF cl_null(l_imb.imb225 ) THEN LET l_imb.imb225 =0 END IF
       IF cl_null(l_imb.imb226 ) THEN LET l_imb.imb226 =0 END IF  IF cl_null(l_imb.imb2251) THEN LET l_imb.imb2251=0 END IF 
       IF cl_null(l_imb.imb2271) THEN LET l_imb.imb2271=0 END IF  IF cl_null(l_imb.imb2272) THEN LET l_imb.imb2272=0 END IF
       IF cl_null(l_imb.imb229 ) THEN LET l_imb.imb229 =0 END IF  IF cl_null(l_imb.imb230 ) THEN LET l_imb.imb230 =0 END IF 
     END IF
 
     LET l_ima31_fac = 0
     LET l_ima44_fac = 0
     CALL s_umfchk(sr.imn03,l_ima31,l_ima25)
         RETURNING g_cnt,l_ima31_fac
     IF g_cnt = 1 THEN
       LET l_ima31_fac = 1
     END IF
     CALL s_umfchk(sr.imn03,l_ima44,l_ima25)
         RETURNING g_cnt,l_ima44_fac
     IF g_cnt = 1 THEN
       LET l_ima44_fac = 1
     END IF
 
     LET l_cxk04 = 0
    #資料來源
     CASE tm.s
       WHEN "1"  #標準成本
         LET l_cxk04 =l_imb.imb111 +l_imb.imb112 +l_imb.imb1131+l_imb.imb1132+
                      l_imb.imb114 +l_imb.imb115 +l_imb.imb1151+l_imb.imb116+
                      l_imb.imb1171+l_imb.imb1172+l_imb.imb119 +l_imb.imb120 +
                      l_imb.imb121 +l_imb.imb122 +l_imb.imb1231+l_imb.imb1232+
                      l_imb.imb124 +l_imb.imb125 +l_imb.imb126 +l_imb.imb1251+
                      l_imb.imb1271+l_imb.imb1272+l_imb.imb129 +l_imb.imb130 
       WHEN "2"  #實際成本
         LET l_cxk04 =l_imb.imb211 +l_imb.imb212 +l_imb.imb2131+l_imb.imb2132+
                      l_imb.imb214 +l_imb.imb215 +l_imb.imb2151+l_imb.imb216+
                      l_imb.imb2171+l_imb.imb2172+l_imb.imb219 +l_imb.imb220 +
                      l_imb.imb221 +l_imb.imb222 +l_imb.imb2231+l_imb.imb2232+
                      l_imb.imb224 +l_imb.imb225 +l_imb.imb226 +l_imb.imb2251+
                      l_imb.imb2271+l_imb.imb2272+l_imb.imb229 +l_imb.imb230
 
       WHEN "3"  #市價 ima531 * (採購 ima44/庫存ima25換算率)
          LET l_cxk04 = l_ima531 * l_ima44_fac
 
       WHEN "4"  #月加權平均單價ccc23
          #LET g_sql = "SELECT ccc23 FROM ", l_plant,"ccc_file",
          LET g_sql = "SELECT ccc23 FROM ", cl_get_target_table(sr.azp01,'ccc_file'),  #FUN-A50102
                      " WHERE ccc01 = '",sr.imn03 CLIPPED,"'",
                      "   AND ccc02 = ",tm.yy,
                      "   AND ccc03 = ",tm.mm, #MOD-A90119 add ,
                      "   AND ccc07='1'" #MOD-A90119 add
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
          CALL cl_parse_qry_sql(g_sql,sr.azp01) RETURNING g_sql      #FUN-A50102	
          PREPARE ccc23_pre FROM g_sql
          EXECUTE ccc23_pre INTO l_cxk04
          IF STATUS = 100 OR SQLCA.sqlcode THEN
            LET l_cxk04 = 0
          END IF
          
       WHEN "5"  #最近銷售單價 -> ima33 (銷售ima31與庫存ima25做轉換)
          LET l_cxk04 = l_ima33 * l_ima31_fac 
 
       WHEN "6"  #平均採購單價 -> ima91 (採購ima44 與庫存ima25 轉換)
          LET l_cxk04 = l_ima91 * l_ima44_fac
     END CASE
 
 
    ##加成##
     CASE tm.a
       WHEN "1"
         LET l_cxk.cxk04 = l_cxk04
       WHEN "2"
         #LET g_sql = " SELECT oba07 FROM ",l_plant,"oba_file ",
         LET g_sql = " SELECT oba07 FROM ",cl_get_target_table(sr.azp01,'oba_file'),  #FUN-A50102
                     "  WHERE oba01 ='",l_ima131 CLIPPED,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
         CALL cl_parse_qry_sql(g_sql,sr.azp01) RETURNING g_sql      #FUN-A50102	
         PREPARE oba07_pre FROM g_sql
         EXECUTE oba07_pre INTO l_ima129
         LET l_cxk.cxk04 = l_cxk04 * (1+(l_ima129/100)) 
       WHEN "3"
         LET l_cxk.cxk04 = l_cxk04 * (1+(l_ima129/100)) 
     END CASE     
    ######
 
     INSERT INTO cxk_file VALUES(l_cxk.*)
     ##NO.TQC-790100 START--------------------------
     ##IF STATUS=-239 THEN
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
     ##NO.TQC-790100 END----------------------------
       UPDATE cxk_file SET cxk02 = l_cxk.cxk02,
                           cxk03 = l_cxk.cxk03,
                           cxk04 = l_cxk.cxk04,
                           cxk05 = l_cxk.cxk05
                     WHERE cxk01 = l_cxk.cxk01
       IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","cxk_file",l_cxk.cxk01,"",SQLCA.sqlcode,"","",1) 
       END IF
     END IF
   END FOREACH
 
   CALL cl_err('','axc-001',0)
END FUNCTION
 
FUNCTION t900_set_entry_b()
   IF  NOT g_before_input_done  THEN                          
     CALL cl_set_comp_entry("mm,yy",TRUE)                                       
   END IF                                                                       
END FUNCTION
 
FUNCTION t900_set_no_entry_b()
   IF  NOT g_before_input_done  THEN                          
     CALL cl_set_comp_entry("mm,yy",FALSE)
   END IF
END FUNCTION
