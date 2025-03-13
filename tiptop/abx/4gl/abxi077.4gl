# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: abxi077.4gl
# Descriptions...: 保稅群組代碼維護作業
# Date & Author..: 06/10/30 By kim
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/07/06 By ve 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bxe        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                       bxe01   LIKE bxe_file.bxe01,  #群組代碼 
                       bxe06   LIKE bxe_file.bxe06,  #工業局英文名稱
                       bxe07   LIKE bxe_file.bxe07,  #CCCCODE
                       bxe02   LIKE bxe_file.bxe02,  #群組品名
                       bxe03   LIKE bxe_file.bxe03,  #群組規格
                       bxe04   LIKE bxe_file.bxe04,  #群組單位
                       bxe05   LIKE bxe_file.bxe05,  #群組帳卡編號
                       bxeacti LIKE bxe_file.bxeacti   #資料有效碼
                    END RECORD,
    g_bxe_t      RECORD                 #程式變數 (舊值)
                       bxe01   LIKE bxe_file.bxe01,  #群組代碼 
                       bxe06   LIKE bxe_file.bxe06,  #工業局英文名稱
                       bxe07   LIKE bxe_file.bxe07,  #CCCCODE
                       bxe02   LIKE bxe_file.bxe02,  #群組品名
                       bxe03   LIKE bxe_file.bxe03,  #群組規格
                       bxe04   LIKE bxe_file.bxe04,  #群組單位
                       bxe05   LIKE bxe_file.bxe05,  #群組帳卡編號 
                       bxeacti LIKE bxe_file.bxeacti   #資料有效碼
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10   
DEFINE g_i          LIKE type_file.num5               #count/index for any purpose
DEFINE g_before_input_done  LIKE type_file.num5 
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間)
        RETURNING g_time
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i077_w AT p_row,p_col WITH FORM "abx/42f/abxi077"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i077_b_fill(g_wc2)
   CALL i077_menu()
   CLOSE WINDOW i077_w                     #結束畫面
   CALL cl_used(g_prog,g_time,2)           #計算使用時間 (退出使間)
        RETURNING g_time
END MAIN
 
FUNCTION i077_menu()
DEFINE l_cmd          STRING    #No.FUN-780037
   WHILE TRUE
      CALL i077_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i077_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i077_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #No.FUN-780037---Begin
               #CALL i077_out()                              
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET l_cmd = 'p_query "abxi077" "',g_wc2 CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd)                        
               #No.FUN-780037---End 
          END IF
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bxe),'','')
            END IF
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_bxe[l_ac].bxe01 IS NOT NULL THEN
                 LET g_doc.column1 = "bxe01"
                 LET g_doc.value1 = g_bxe[l_ac].bxe01
                 CALL cl_doc()
              END IF
           END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i077_q()
   CALL i077_b_askkey()
END FUNCTION
 
FUNCTION i077_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bxe01,bxe06,bxe07,bxe02,",
                       "       bxe03,bxe04,",
                       "       bxe05,bxeacti FROM bxe_file",
                       " WHERE bxe01 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i077_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bxe WITHOUT DEFAULTS FROM s_bxe.*
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
               LET p_cmd='u'
               LET g_bxe_t.* = g_bxe[l_ac].*  #BACKUP
               LET g_before_input_done = FALSE                                                                                      
               CALL i077_set_entry_b(p_cmd)                                                                                         
               CALL i077_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
               BEGIN WORK
 
               OPEN i077_bcl USING g_bxe_t.bxe01
               IF STATUS THEN
                  CALL cl_err("OPEN i077_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i077_bcl INTO g_bxe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bxe_t.bxe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
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
 
            INSERT INTO bxe_file(bxe01,bxe06,bxe07,
                                    bxe02,bxe03,
                                    bxe04,bxe05,bxeacti)
               VALUES(g_bxe[l_ac].bxe01,g_bxe[l_ac].bxe06,
                      g_bxe[l_ac].bxe07,g_bxe[l_ac].bxe02,
                      g_bxe[l_ac].bxe03,g_bxe[l_ac].bxe04,
                      g_bxe[l_ac].bxe05,g_bxe[l_ac].bxeacti)
 
            #INSERT INTO bxe_file VALUES(g_bxe[l_ac].*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err(g_bxe[l_ac].bxe01,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                                                                      
            CALL i077_set_entry_b(p_cmd)                                                                                         
            CALL i077_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
            INITIALIZE g_bxe[l_ac].* TO NULL
            LET g_bxe[l_ac].bxeacti = 'Y'
            LET g_bxe_t.* = g_bxe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD bxe01
 
        AFTER FIELD bxe01 #保稅群組代碼
            IF NOT cl_null(g_bxe[l_ac].bxe01) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND       #check 編號是否重複
                  g_bxe[l_ac].bxe01 != g_bxe_t.bxe01) THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM bxe_file
                   WHERE bxe01 = g_bxe[l_ac].bxe01
                  IF l_n > 0 THEN
                     CALL cl_err(g_bxe[l_ac].bxe01,-239,0)
                     LET g_bxe[l_ac].bxe01 = g_bxe_t.bxe01
                     DISPLAY BY NAME g_bxe[l_ac].bxe01
                     NEXT FIELD bxe01
                  END IF
               END IF
            END IF
 
        AFTER FIELD bxe04 #群組單位
            IF NOT cl_null(g_bxe[l_ac].bxe04) THEN
               CALL i077_bxe04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bxe[l_ac].bxe04,g_errno,0)
                  LET g_bxe[l_ac].bxe04 = g_bxe_t.bxe04
                  DISPLAY BY NAME g_bxe[l_ac].bxe04
                  NEXT FIELD bxe04
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bxe_t.bxe01) THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "bxe01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_bxe[l_ac].bxe01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               
               DELETE FROM bxe_file WHERE bxe01 = g_bxe_t.bxe01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err(g_bxe_t.bxe01,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i077_bcl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bxe[l_ac].* = g_bxe_t.*
               CLOSE i077_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bxe[l_ac].bxe01,-263,1)
               LET g_bxe[l_ac].* = g_bxe_t.*
            ELSE
               UPDATE bxe_file SET bxe01 = g_bxe[l_ac].bxe01,
                                      bxe06 = g_bxe[l_ac].bxe06,
                                      bxe07 = g_bxe[l_ac].bxe07,
                                      bxe02 = g_bxe[l_ac].bxe02,
                                      bxe03 = g_bxe[l_ac].bxe03,
                                      bxe04 = g_bxe[l_ac].bxe04,
                                      bxe05 = g_bxe[l_ac].bxe05,
                                      bxeacti= g_bxe[l_ac].bxeacti
                WHERE bxe01 = g_bxe_t.bxe01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err(g_bxe[l_ac].bxe01,SQLCA.sqlcode,0)
                  LET g_bxe[l_ac].* = g_bxe_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bxe[l_ac].* = g_bxe_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_bxe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i077_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i077_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i077_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO #沿用所有欄位
            IF INFIELD(bxe01) AND l_ac > 1 THEN
               LET g_bxe[l_ac].* = g_bxe[l_ac-1].*
               NEXT FIELD bxe01
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bxe04) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_bxe[l_ac].bxe04
                  CALL cl_create_qry() RETURNING g_bxe[l_ac].bxe04
                  DISPLAY BY NAME g_bxe[l_ac].bxe04
                  NEXT FIELD bxe04
            
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
        
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
 
    CLOSE i077_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i077_bxe04()  #單位
    DEFINE l_gfeacti  LIKE gfe_file.gfeacti
    
    LET g_errno = " "
    SELECT gfeacti INTO l_gfeacti FROM gfe_file
     WHERE gfe01 = g_bxe[l_ac].bxe04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i077_b_askkey()
    CLEAR FORM
    CALL g_bxe.clear()
    CONSTRUCT g_wc2 ON bxe01,bxe06,bxe07,bxe02,bxe03,
                       bxe04,bxe05,bxeacti
                  FROM s_bxe[1].bxe01,s_bxe[1].bxe06,
                       s_bxe[1].bxe07,s_bxe[1].bxe02,
                       s_bxe[1].bxe03,s_bxe[1].bxe04,
                       s_bxe[1].bxe05,s_bxe[1].bxeacti
                       
             #No.FUN-580031 --start--     HCN
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
             #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bxe04) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bxe04
                  NEXT FIELD bxe04
            
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
 
               #No.FUN-580031 --start--     HCN
                ON ACTION qbe_select
                  CALL cl_qbe_select()
                ON ACTION qbe_save
                  CALL cl_qbe_save()
               #No.FUN-580031 --end--       HCN
    
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i077_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i077_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING
 
    LET g_sql = "SELECT bxe01,bxe06,bxe07,bxe02,",
                "       bxe03,bxe04,bxe05, ",
                "       bxeacti FROM bxe_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY bxe01"
    PREPARE i077_pb FROM g_sql
    DECLARE bxe_curs CURSOR FOR i077_pb
 
    CALL g_bxe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bxe_curs INTO g_bxe[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
     
    END FOREACH
    CALL g_bxe.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i077_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bxe TO s_bxe.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i077_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd  LIKE type_file.chr1
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("bxe01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i077_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                        
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("bxe01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
 
FUNCTION i077_out()
   DEFINE l_name     LIKE type_file.chr20,     # External(Disk) file name
          l_i        LIKE type_file.num10,
          sr         RECORD 
                       bxe01   LIKE bxe_file.bxe01,  #群組代碼 
                       bxe06   LIKE bxe_file.bxe06,  #工業局英文名稱
                       bxe07   LIKE bxe_file.bxe07,  #CCCCODE
                       bxe02   LIKE bxe_file.bxe02,  #群組品名
                       bxe03   LIKE bxe_file.bxe03,  #群組規格
                       bxe04   LIKE bxe_file.bxe04,  #群組單位
                       bxe05   LIKE bxe_file.bxe05,  #群組帳卡編號
                       bxeacti LIKE bxe_file.bxeacti   #資料有效碼
                     END RECORD
 
#No.TQC-710076 -- begin --
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
     IF g_bxe.getlength()=0 THEN
        CALL cl_err('','-400',1)
        RETURN
     END IF
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL cl_outnam('abxi077') RETURNING l_name
     START REPORT i077_rep TO l_name
 
     LET g_pageno = 0
     FOR l_i=1 TO g_bxe.getlength()
       IF g_bxe[l_i].bxe01 IS NULL THEN
          CONTINUE FOR
       END IF
       INITIALIZE sr.* TO NULL
       LET sr.bxe01   = g_bxe[l_i].bxe01  
       LET sr.bxe06   = g_bxe[l_i].bxe06  
       LET sr.bxe07   = g_bxe[l_i].bxe07  
       LET sr.bxe02   = g_bxe[l_i].bxe02  
       LET sr.bxe03   = g_bxe[l_i].bxe03  
       LET sr.bxe04   = g_bxe[l_i].bxe04  
       LET sr.bxe05   = g_bxe[l_i].bxe05  
       LET sr.bxeacti = g_bxe[l_i].bxeacti 
       OUTPUT TO REPORT i077_rep(sr.*)
     END FOR
 
     FINISH REPORT i077_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT i077_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,
          sr         RECORD 
                       bxe01   LIKE bxe_file.bxe01,  #群組代碼 
                       bxe06   LIKE bxe_file.bxe06,  #工業局英文名稱
                       bxe07   LIKE bxe_file.bxe07,  #CCCCODE
                       bxe02   LIKE bxe_file.bxe02,  #群組品名
                       bxe03   LIKE bxe_file.bxe03,  #群組規格
                       bxe04   LIKE bxe_file.bxe04,  #群組單位
                       bxe05   LIKE bxe_file.bxe05,  #群組帳卡編號
                       bxeacti LIKE bxe_file.bxeacti   #資料有效碼
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bxe01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.bxe01, 
            COLUMN g_c[32],sr.bxe06, 
            COLUMN g_c[33],sr.bxe07, 
            COLUMN g_c[34],sr.bxe02, 
            COLUMN g_c[35],sr.bxe03, 
            COLUMN g_c[36],sr.bxe04, 
            COLUMN g_c[37],sr.bxe05, 
            COLUMN g_c[38],sr.bxeacti
            
   ON LAST ROW
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
