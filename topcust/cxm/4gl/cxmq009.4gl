DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE g_tc_ool  DYNAMIC ARRAY OF RECORD
        tc_ool01    LIKE tc_ool_file.tc_ool01,   
        tc_ool02    LIKE tc_ool_file.tc_ool02,   
        tc_ool03    LIKE tc_ool_file.tc_ool03,
        oga02       LIKE oga_file.oga02,
        oga03       LIKE oga_file.oga03,
        ogaud04     LIKE oga_file.ogaud04,
        ogaud05     LIKE oga_file.ogaud05
                 END RECORD

DEFINE g_wc            STRING
DEFINE g_tc_ool_t     RECORD 
        tc_ool01    LIKE tc_ool_file.tc_ool01,
        tc_ool02    LIKE tc_ool_file.tc_ool02,
        tc_ool03    LIKE tc_ool_file.tc_ool03,
        oga02       LIKE oga_file.oga02,
        oga03       LIKE oga_file.oga03,
        ogaud04     LIKE oga_file.ogaud04,
        ogaud05     LIKE oga_file.ogaud05
        END RECORD 
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_argv1         LIKE tc_ool_file.tc_ool01 
DEFINE g_argv2         LIKE type_file.chr30
DEFINE g_argv3         LIKE type_file.chr30
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_sql           STRING 
DEFINE g_gec07         LIKE gec_file.gec07 
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5 
DEFINE l_prog          LIKE type_file.chr30
DEFINE g_forupd_sql    STRING
DEFINE g_before_input_done   LIKE type_file.num5

MAIN

   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cxmq009_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmq009"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  LET g_argv1 = ARG_VAL(1)
  LET g_argv2 = ARG_VAL(2)
  LET g_argv3 = ARG_VAL(3)
 IF NOT cl_null(g_argv1) THEN 
   CALL q009_q()
 ELSE
  # EXIT PROGRAM
 END IF  
   CALL q009_menu()

    CLOSE WINDOW cxmq009_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q009_menu()
 
   WHILE TRUE
      CALL q009_bp("G")
      CASE g_action_choice
        WHEN "detail" 
            IF cl_chk_act_auth()  THEN
               CALL q009_b()
         ELSE
            LET g_action_choice = NULL
         END IF
         WHEN "query"
         IF cl_null(g_argv1) THEN 
               CALL q009_q()
         END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ool),'','')
            END IF
         
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q009_q()    
    CLEAR FORM
    CALL g_tc_ool.clear()
    IF NOT cl_null(g_argv1) THEN 
      LET g_wc = " tc_ool01 = '",g_argv1,"'"
    ELSE 
     CONSTRUCT g_wc ON                     # 螢幕上取條件  #huanglf161104
         tc_ool01,tc_ool02,tc_ool03   
        FROM s_tc_ool[1].tc_ool01,s_tc_ool[1].tc_ool02,s_tc_ool[1].tc_ool03
       
    
        BEFORE CONSTRUCT
          CALL cl_qbe_init()

       
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ool01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga_try"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ool01
                 NEXT FIELD tc_ool01
              
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
    END IF 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q009_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q009_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_i       LIKE type_file.num5
DEFINE l_rec_b   LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql STRING 
DEFINE p_wc2  STRING

 IF cl_null(p_wc2) THEN
    LET p_wc2 = "1=1" 
 END IF 
 LET l_i=1
 CALL cl_replace_str(p_wc2,"tc_ool03='N'","(tc_ool03='N' OR tc_ool03 is null)") RETURNING p_wc2
 LET l_sql = " SELECT tc_ool01,tc_ool02,tc_ool03,oga02,oga03,ogaud04,ogaud05 ",
             " FROM tc_ool_file,oga_file WHERE ",p_wc2 CLIPPED," AND oga01 = tc_ool01",
             " AND ogapost = 'Y' AND oga09='2' ",
             " ORDER BY tc_ool01" 
 PREPARE sel_omf1_pre FROM l_sql
 DECLARE sel_omf1_cur CURSOR FOR sel_omf1_pre
 FOREACH sel_omf1_cur INTO g_tc_ool[l_i].*
 #str----add by huanglf161207
   IF cl_null(g_tc_ool[l_i].tc_ool03) THEN
      LET g_tc_ool[l_i].tc_ool03 = 'N'
      DISPLAY BY NAME g_tc_ool[l_i].tc_ool03
   END IF 
 #str---end by huanglf161207
   LET  l_i=l_i+1
 END FOREACH
END FUNCTION

FUNCTION q009_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_tc_ool07         LIKE tc_ool_file.tc_ool07,                 #MOD-B20155 ADD
    v               string,
    l_cnt           LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT tc_ool01,tc_ool02,tc_ool03 ",
                       "  FROM tc_ool_file WHERE tc_ool01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i130_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_ool WITHOUT DEFAULTS FROM s_tc_ool.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
       IF g_argv3='axmt610' THEN
          CALL  cl_set_comp_entry("tc_ool01,tc_ool03",FALSE)
       ELSE
          CALL cl_set_comp_entry("tc_ool01,tc_ool02",FALSE)
       END IF
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()

        SELECT oga02,oga03,ogaud04,ogaud05 
        INTO g_tc_ool[l_ac].oga02,g_tc_ool[l_ac].oga03,g_tc_ool[l_ac].ogaud04,g_tc_ool[l_ac].ogaud05
        FROM  oga_file WHERE oga01 = g_tc_ool[l_ac].tc_ool01
        DISPLAY BY NAME g_tc_ool[l_ac].oga02,g_tc_ool[l_ac].oga03,g_tc_ool[l_ac].ogaud04,g_tc_ool[l_ac].ogaud05
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           IF g_argv3='axmt610' THEN
              CALL  cl_set_comp_entry("tc_ool01,tc_ool03",FALSE)
           ELSE 
              CALL cl_set_comp_entry("tc_ool01,tc_ool02",FALSE)
           END IF
           LET g_before_input_done = FALSE                                      
           LET g_before_input_done = TRUE                                       
           LET g_tc_ool_t.* = g_tc_ool[l_ac].*  #BACKUP
           OPEN i130_bcl USING g_tc_ool_t.tc_ool01
           IF STATUS THEN
              CALL cl_err("OPEN i130_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i130_bcl INTO g_tc_ool[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_ool_t.tc_ool01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         #CALL i130_set_entry(p_cmd)                                             
        # CALL i130_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_tc_ool[l_ac].* TO NULL      #900423
         IF NOT cl_null(g_argv1) THEN
            LET g_tc_ool[l_ac].tc_ool01 = g_argv1
            CALL cl_set_comp_entry("tc_ool01",FALSE)
         END IF
         LET g_tc_ool_t.* = g_tc_ool[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
     #    NEXT FIELD tc_ool01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i130_bcl
           CANCEL INSERT
        END IF
 
      {  BEGIN WORK                    #FUN-680010
 
        INSERT INTO tc_ool_file(tc_ool01,tc_ool011,tc_ool02,tc_ool021,tc_ool03,tc_ool031,tc_ool04,tc_ool041,tc_ool05,
                     tc_ool06,tc_ool07,tc_ool081,tc_ool082,tc_ool083,tc_ool091,tc_ool092,tc_ool093)
               VALUES(g_tc_ool[l_ac].tc_ool01,g_tc_ool[l_ac].tc_ool011,g_tc_ool[l_ac].tc_ool02,g_tc_ool[l_ac].tc_ool021,
               g_tc_ool[l_ac].tc_ool03,g_tc_ool[l_ac].tc_ool031,g_tc_ool[l_ac].tc_ool04,g_tc_ool[l_ac].tc_ool041,
               g_tc_ool[l_ac].tc_ool05,g_tc_ool[l_ac].tc_ool06,g_tc_ool[l_ac].tc_ool07,
               g_tc_ool[l_ac].tc_ool081,g_tc_ool[l_ac].tc_ool082,g_tc_ool[l_ac].tc_ool083,g_tc_ool[l_ac].tc_ool091,
               g_tc_ool[l_ac].tc_ool092,g_tc_ool[l_ac].tc_ool093)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tc_ool_file",g_tc_ool[l_ac].tc_ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
           CALL cl_msg('INSERT O.K, INSERT MDM O.K')
           COMMIT WORK 
        END IF }
 
   {  AFTER FIELD tc_ool01                        #check 編號是否重複
        IF NOT cl_null(g_tc_ool[l_ac].tc_ool01) THEN
           IF g_tc_ool[l_ac].tc_ool01 != g_tc_ool_t.tc_ool01 OR
              g_tc_ool_t.tc_ool01 IS NULL THEN
              SELECT count(*) INTO l_n FROM ima_file
               WHERE ima01 = g_tc_ool[l_ac].tc_ool01
              IF l_n = 0 THEN
                 CALL cl_err('','abm-202',1)
                 LET g_tc_ool[l_ac].tc_ool01 = g_tc_ool_t.tc_ool01
                 NEXT FIELD tc_ool01
              END IF
           END IF
           SELECT ima02,ima021,ima31,ima31,ima31 INTO g_tc_ool[l_ac].ima02,g_tc_ool[l_ac].ima021,g_tc_ool[l_ac].tc_ool021,
           g_tc_ool[l_ac].tc_ool031,g_tc_ool[l_ac].tc_ool041 FROM ima_file WHERE ima01=g_tc_ool[l_ac].tc_ool01
           DISPLAY BY NAME g_tc_ool[l_ac].ima02,g_tc_ool[l_ac].ima021,g_tc_ool[l_ac].tc_ool021,
           g_tc_ool[l_ac].tc_ool031,g_tc_ool[l_ac].tc_ool041
           SELECT COUNT(*) INTO l_cnt FROM tc_ool_file WHERE tc_ool01=g_tc_ool[l_ac].tc_ool01
           IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
           LET g_tc_ool[l_ac].tc_ool011=l_cnt+1 
           DISPLAY BY NAME g_tc_ool[l_ac].tc_ool011   #变更版次序号
        END IF
 }
      AFTER FIELD tc_ool02 
        IF g_argv3='axmt610' AND cl_null(g_tc_ool[l_ac].tc_ool02) THEN
           NEXT FIELD tc_ool02
        END IF
    
      AFTER FIELD tc_ool03
       IF g_argv3='axmt620' AND cl_null(g_tc_ool[l_ac].tc_ool03) THEN
          NEXT FIELD tc_ool021
       END IF



{     BEFORE DELETE                            #是否取消單身
         IF g_tc_ool_t.tc_ool01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "tc_ool01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_tc_ool[l_ac].tc_ool01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_ool_file WHERE tc_ool01 = g_tc_ool_t.tc_ool01 AND tc_ool011=g_tc_ool_t.tc_ool011 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_ool_file",g_tc_ool_t.tc_ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      
                CANCEL DELETE
                EXIT INPUT
            END IF
 
 
         END IF
   }
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_tc_ool[l_ac].* = g_tc_ool_t.*
          CLOSE i130_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_tc_ool[l_ac].tc_ool01,-263,0)
           LET g_tc_ool[l_ac].* = g_tc_ool_t.*
        ELSE
           UPDATE tc_ool_file SET 
                               tc_ool02=g_tc_ool[l_ac].tc_ool02,
                               tc_ool03=g_tc_ool[l_ac].tc_ool03
           WHERE tc_ool01 = g_tc_ool[l_ac].tc_ool01  #g_argv1
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_tc_ool[l_ac].tc_ool01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("upd","tc_ool_file",g_tc_ool_t.tc_ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_tc_ool[l_ac].* = g_tc_ool_t.*
           ELSE
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
       #LET l_ac_t = l_ac                # 新增   #FUN-D40030 Mark
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tc_ool[l_ac].* = g_tc_ool_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_tc_ool.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i130_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac                       #FUN-D40030 Add
         CLOSE i130_bcl                # 新增
         COMMIT WORK
 
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_ool01) AND l_ac > 1 THEN
             LET g_tc_ool[l_ac].* = g_tc_ool[l_ac-1].*
             NEXT FIELD tc_ool01
         END IF
 
       ON ACTION controlp
 
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
 
    CLOSE i130_bcl
    COMMIT WORK
END FUNCTION




 FUNCTION q009_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ool TO s_tc_ool.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
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

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
