# Prog. Version..: '5.10.03-08.09.13(00009)'     #
# Pattern name...: cpmi116.4gl
# Descriptions...: 基础价格类型档
# Date & Author..: 12/05/24 By zhangym
# Modify.........: No.121010     12/10/10 By qiull 增加库存单位，计价单位两个栏位
# Modify.........: No.121022     12/10/22 By qiull 增加单位转换率栏位

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE 
     g_tc_hrdn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_hrdn01       LIKE tc_hrdn_file.tc_hrdn01,
        hrat02           LIKE hrat_file.hrat02,
        hrao02          LIKE hrao_file.hrao02, 
        hrat25           LIKE hrat_file.hrat25,            #No.121010---qiull---add
        hrad03          LIKE hrad_file.hrad03,           #No.121010---qiull---add
    { #   desc            LIKE type_file.chr20,           #No.121022---qiull---add
     #   tc_hrdn002       LIKE tc_hrdn_file.tc_hrdn002, 
      #  pmc03           LIKE pmc_file.pmc03,       
      #  tc_hrdn003       LIKE tc_hrdn_file.tc_hrdn003,
      #  tc_cpa002_1     LIKE tc_cpa_file.tc_cpa002,        
      #  tc_hrdn004       LIKE tc_hrdn_file.tc_hrdn004,        
      #  tc_hrdn005       LIKE tc_hrdn_file.tc_hrdn005,
      #  tc_cpa002_2     LIKE tc_cpa_file.tc_cpa002,        
       # tc_hrdn006       LIKE tc_hrdn_file.tc_hrdn006,        
        tc_hrdn007       LIKE tc_hrdn_file.tc_hrdn007,
        tc_cpa002_3     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn008       LIKE tc_hrdn_file.tc_hrdn008,
        tc_hrdn009       LIKE tc_hrdn_file.tc_hrdn009,
        tc_cpa002_4     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn010       LIKE tc_hrdn_file.tc_hrdn010,
        tc_hrdn011       LIKE tc_hrdn_file.tc_hrdn011,
        tc_cpa002_5     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn012       LIKE tc_hrdn_file.tc_hrdn012,}
        tc_hrdn02       LIKE tc_hrdn_file.tc_hrdn02,
        tc_hrdn03       LIKE tc_hrdn_file.tc_hrdn03,
        tc_hrdn04       LIKE tc_hrdn_file.tc_hrdn04,
        tc_hrdn05       LIKE tc_hrdn_file.tc_hrdn05,
        tc_hrdn06       LIKE tc_hrdn_file.tc_hrdn06,
        tc_hrdn07       LIKE tc_hrdn_file.tc_hrdn07,
        tc_hrdn08       LIKE tc_hrdn_file.tc_hrdn08
                    END RECORD,
    g_tc_hrdn_t         RECORD                      #程式變數 (舊值)
        tc_hrdn01       LIKE tc_hrdn_file.tc_hrdn01,
        hrat02           LIKE hrat_file.hrat02,
        hrao02          LIKE hrao_file.hrao02,   
        hrat25           LIKE hrat_file.hrat25,            #No.121010---qiull---add
        hrad03          LIKE hrad_file.hrad03,           #No.121010---qiull---add    
       { desc            LIKE type_file.chr20,           #No.121022---qiull---add
        tc_hrdn002       LIKE tc_hrdn_file.tc_hrdn002, 
        pmc03           LIKE pmc_file.pmc03,       
        tc_hrdn003       LIKE tc_hrdn_file.tc_hrdn003,
        tc_cpa002_1     LIKE tc_cpa_file.tc_cpa002,        
        tc_hrdn004       LIKE tc_hrdn_file.tc_hrdn004,        
        tc_hrdn005       LIKE tc_hrdn_file.tc_hrdn005,
        tc_cpa002_2     LIKE tc_cpa_file.tc_cpa002,        
        tc_hrdn006       LIKE tc_hrdn_file.tc_hrdn006,        
        tc_hrdn007       LIKE tc_hrdn_file.tc_hrdn007,
        tc_cpa002_3     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn008       LIKE tc_hrdn_file.tc_hrdn008,
        tc_hrdn009       LIKE tc_hrdn_file.tc_hrdn009,
        tc_cpa002_4     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn010       LIKE tc_hrdn_file.tc_hrdn010,
        tc_hrdn011       LIKE tc_hrdn_file.tc_hrdn011,
        tc_cpa002_5     LIKE tc_cpa_file.tc_cpa002,
        tc_hrdn012       LIKE tc_hrdn_file.tc_hrdn012,}
        tc_hrdn02       LIKE tc_hrdn_file.tc_hrdn02,
        tc_hrdn03       LIKE tc_hrdn_file.tc_hrdn03,
        tc_hrdn04       LIKE tc_hrdn_file.tc_hrdn04,
        tc_hrdn05       LIKE tc_hrdn_file.tc_hrdn05,
        tc_hrdn06       LIKE tc_hrdn_file.tc_hrdn06,
        tc_hrdn07       LIKE tc_hrdn_file.tc_hrdn07,
        tc_hrdn08       LIKE tc_hrdn_file.tc_hrdn08
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,        #單身筆數
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT

DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5    
DEFINE g_row_count  LIKE type_file.num5   
DEFINE g_curs_index LIKE type_file.num5  
DEFINE g_str        STRING              
MAIN
    DEFINE p_row,p_col   LIKE type_file.num5

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i116_w AT p_row,p_col WITH FORM "ghr/42f/ghri116"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i116_b_fill(g_wc2)
    CALL i116_menu()
    CLOSE WINDOW i116_w                    #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION i116_menu()

   WHILE TRUE
      CALL i116_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i116_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i116_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_tc_hrdn[l_ac].tc_hrdn01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_hrdn01"
                  LET g_doc.value1 = g_tc_hrdn[l_ac].tc_hrdn01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_hrdn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i116_q()
   CALL i116_b_askkey()
END FUNCTION

FUNCTION i116_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                 #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
    p_cmd           LIKE type_file.chr1,                 #處理狀態 
    l_allow_insert  LIKE type_file.chr1,                 #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    v,l_str         string

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT tc_hrdn01 ",
                       "  FROM tc_hrdn_file WHERE tc_hrdn01 = ?  FOR UPDATE NOWAIT"
    DECLARE i116_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_tc_hrdn WITHOUT DEFAULTS FROM s_tc_hrdn.*
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
        LET g_on_change = TRUE 

        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE                                      
           CALL i116_set_entry(p_cmd)                                           
           CALL i116_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           LET g_tc_hrdn_t.* = g_tc_hrdn[l_ac].*  #BACKUP
           OPEN i116_bcl USING g_tc_hrdn_t.tc_hrdn01
           IF STATUS THEN
              CALL cl_err("OPEN i116_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i116_bcl INTO g_tc_hrdn[l_ac].tc_hrdn01
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_hrdn_t.tc_hrdn01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()
        END IF

     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL i116_set_entry(p_cmd)                                             
         CALL i116_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_tc_hrdn[l_ac].* TO NULL
         LET g_tc_hrdn_t.* = g_tc_hrdn[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD tc_hrdn01

     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i116_bcl
           CANCEL INSERT
        END IF

        BEGIN WORK 

        INSERT INTO tc_hrdn_file(tc_hrdn01,tc_hrdn02,tc_hrdn03,tc_hrdn04,tc_hrdn05,tc_hrdn06,tc_hrdn07,tc_hrdn08)
               VALUES(g_tc_hrdn[l_ac].tc_hrdn01,g_tc_hrdn[l_ac].tc_hrdn02,g_tc_hrdn[l_ac].tc_hrdn03,
                      g_tc_hrdn[l_ac].tc_hrdn04,g_tc_hrdn[l_ac].tc_hrdn05,g_tc_hrdn[l_ac].tc_hrdn06,g_tc_hrdn[l_ac].tc_hrdn07,
                      g_tc_hrdn[l_ac].tc_hrdn08
                      )
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tc_hrdn_file",g_tc_hrdn[l_ac].tc_hrdn01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK         
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1           	
           COMMIT WORK 
        END IF

     AFTER FIELD tc_hrdn01
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn01) THEN
          CALL i116_tc_hrdn01('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn01
          END IF
       END IF
       
   {  AFTER FIELD tc_hrdn002                        #check 編號是否重複
        IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn002) THEN     
           IF g_tc_hrdn[l_ac].tc_hrdn002 != g_tc_hrdn_t.tc_hrdn002 OR
              g_tc_hrdn_t.tc_hrdn002 IS NULL THEN
              SELECT count(*) INTO l_n FROM tc_hrdn_file
               WHERE tc_hrdn01 = g_tc_hrdn[l_ac].tc_hrdn01
                 AND tc_hrdn002 = g_tc_hrdn[l_ac].tc_hrdn002
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tc_hrdn[l_ac].tc_hrdn002 = g_tc_hrdn_t.tc_hrdn002
                  NEXT FIELD tc_hrdn002
              END IF
           END IF
           CALL i116_tc_hrdn002('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0) 
              NEXT FIELD tc_hrdn002
           END IF             
        END IF
        
     AFTER FIELD tc_hrdn003
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn003) THEN
          CALL i116_tc_hrdn003('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn003
          END IF
          IF g_tc_hrdn[l_ac].tc_hrdn004 != g_tc_hrdn_t.tc_hrdn004 OR
             g_tc_hrdn_t.tc_hrdn004 IS NULL THEN          
             LET g_tc_hrdn[l_ac].tc_hrdn004 = 1
          END IF 
       END IF  
       
     AFTER FIELD tc_hrdn005
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn005) THEN
          CALL i116_tc_hrdn005('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn005
          END IF
          IF g_tc_hrdn[l_ac].tc_hrdn006 != g_tc_hrdn_t.tc_hrdn006 OR
             g_tc_hrdn_t.tc_hrdn006 IS NULL THEN          
             LET g_tc_hrdn[l_ac].tc_hrdn006 = 1
          END IF 
       END IF  
       
     AFTER FIELD tc_hrdn007
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn007) THEN
          CALL i116_tc_hrdn007('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn007
          END IF
          IF g_tc_hrdn[l_ac].tc_hrdn008 != g_tc_hrdn_t.tc_hrdn008 OR
             g_tc_hrdn_t.tc_hrdn008 IS NULL THEN          
             LET g_tc_hrdn[l_ac].tc_hrdn008 = 1
          END IF 
       END IF  
       
     AFTER FIELD tc_hrdn009
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn009) THEN
          CALL i116_tc_hrdn009('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn009
          END IF
          IF g_tc_hrdn[l_ac].tc_hrdn010 != g_tc_hrdn_t.tc_hrdn010 OR
             g_tc_hrdn_t.tc_hrdn010 IS NULL THEN          
             LET g_tc_hrdn[l_ac].tc_hrdn010 = 1
          END IF 
       END IF  
       
     AFTER FIELD tc_hrdn011
       IF NOT cl_null(g_tc_hrdn[l_ac].tc_hrdn011) THEN
          CALL i116_tc_hrdn011('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) 
             NEXT FIELD tc_hrdn011
          END IF
          IF g_tc_hrdn[l_ac].tc_hrdn012 != g_tc_hrdn_t.tc_hrdn012 OR
             g_tc_hrdn_t.tc_hrdn012 IS NULL THEN          
             LET g_tc_hrdn[l_ac].tc_hrdn012 = 1
          END IF 
       END IF                           }         

     BEFORE DELETE                            #是否取消單身
         IF g_tc_hrdn_t.tc_hrdn01 IS NOT NULL  THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK
               CANCEL DELETE 
            END IF 
            IF (NOT cl_del_itemname("tc_hrdn_file","tc_hrdn01", g_tc_hrdn_t.tc_hrdn01)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
            DELETE FROM tc_hrdn_file WHERE tc_hrdn01 = g_tc_hrdn_t.tc_hrdn01 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_hrdn_file",g_tc_hrdn_t.tc_hrdn01,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1 
            COMMIT WORK              
         END IF

     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_tc_hrdn[l_ac].* = g_tc_hrdn_t.*
          CLOSE i116_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_tc_hrdn[l_ac].tc_hrdn01,-263,0)
           LET g_tc_hrdn[l_ac].* = g_tc_hrdn_t.*
        ELSE
           UPDATE tc_hrdn_file SET 
                                  tc_hrdn02=g_tc_hrdn[l_ac].tc_hrdn02,
                                  tc_hrdn03=g_tc_hrdn[l_ac].tc_hrdn03,
                                  tc_hrdn04=g_tc_hrdn[l_ac].tc_hrdn04,
                                  tc_hrdn05=g_tc_hrdn[l_ac].tc_hrdn05,
                                  tc_hrdn06=g_tc_hrdn[l_ac].tc_hrdn06,
                                  tc_hrdn07=g_tc_hrdn[l_ac].tc_hrdn07,
                                  tc_hrdn08=g_tc_hrdn[l_ac].tc_hrdn08                                    
           WHERE tc_hrdn01 = g_tc_hrdn_t.tc_hrdn01
             
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","tc_hrdn_file",g_tc_hrdn_t.tc_hrdn01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK 
              LET g_tc_hrdn[l_ac].* = g_tc_hrdn_t.*
           ELSE
              COMMIT WORK
           END IF
        END IF

     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        LET l_ac_t = l_ac                # 新增

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tc_hrdn[l_ac].* = g_tc_hrdn_t.*
           END IF
           CLOSE i116_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         CLOSE i116_bcl                  # 新增
         COMMIT WORK

     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_hrdn01) AND l_ac > 1 THEN
             LET g_tc_hrdn[l_ac].* = g_tc_hrdn[l_ac-1].*
             NEXT FIELD tc_hrdn01
         END IF

       ON ACTION controlp
           CASE WHEN INFIELD(tc_hrdn01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrat01"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn01
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn01
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn01 TO tc_hrdn01
              {  WHEN INFIELD(tc_hrdn002)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn002
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn002
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn002 TO tc_hrdn002
                WHEN INFIELD(tc_hrdn003)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_cpa"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn003
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn003
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn003 TO tc_hrdn003 
                WHEN INFIELD(tc_hrdn005)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_cpa"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn005
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn005
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn005 TO tc_hrdn005 
                WHEN INFIELD(tc_hrdn007)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_cpa"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn007
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn007
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn007 TO tc_hrdn007 
                WHEN INFIELD(tc_hrdn009)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_cpa"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn009
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn009
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn009 TO tc_hrdn009 
                WHEN INFIELD(tc_hrdn011)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_cpa"
                     LET g_qryparam.default1 = g_tc_hrdn[l_ac].tc_hrdn011
                     CALL cl_create_qry() RETURNING g_tc_hrdn[l_ac].tc_hrdn011
                     DISPLAY g_tc_hrdn[l_ac].tc_hrdn011 TO tc_hrdn011      }                                                                                                                         
                OTHERWISE
                     EXIT CASE
            END CASE
            

     ON ACTION CONTROLZ
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

    CLOSE i116_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i116_tc_hrdn01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    #SELECT hrat02,hrao02 INTO g_tc_hrdn[l_ac].hrat02,g_tc_hrdn[l_ac].hrao02                 #No.121010---qiull---mark
    SELECT hrat02,hrao02,hrat25,hrad03
    INTO g_tc_hrdn[l_ac].hrat02,g_tc_hrdn[l_ac].hrao02,    #No.121010---qiull---add
                                          g_tc_hrdn[l_ac].hrat25,g_tc_hrdn[l_ac].hrad03     #No.121010---qiull---add
      FROM hrat_file,hrao_file,hrad_file 
     WHERE hrat04=hrao01 AND hrat19=hrad02 and hrat01 = g_tc_hrdn[l_ac].tc_hrdn01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-202'
                                   LET g_tc_hrdn[l_ac].hrat02 = NULL
                                   LET g_tc_hrdn[l_ac].hrao02 = NULL
                                   LET g_tc_hrdn[l_ac].hrat25 = NULL               #No.121010---qiull---add
                                   LET g_tc_hrdn[l_ac].hrad03 = NULL              #No.121010---qiull---add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

{FUNCTION i116_tc_hrdn002(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT pmc03 INTO g_tc_hrdn[l_ac].pmc03
      FROM pmc_file
     WHERE pmc01 = g_tc_hrdn[l_ac].tc_hrdn002
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ctm-001'
                                   LET g_tc_hrdn[l_ac].pmc03 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i116_tc_hrdn003(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT tc_cpa002 INTO g_tc_hrdn[l_ac].tc_cpa002_1
      FROM tc_cpa_file
     WHERE tc_cpa001 = g_tc_hrdn[l_ac].tc_hrdn003
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cpm-905'
                                   LET g_tc_hrdn[l_ac].tc_cpa002_1 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i116_tc_hrdn005(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT tc_cpa002 INTO g_tc_hrdn[l_ac].tc_cpa002_2
      FROM tc_cpa_file
     WHERE tc_cpa001 = g_tc_hrdn[l_ac].tc_hrdn005
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cpm-905'
                                   LET g_tc_hrdn[l_ac].tc_cpa002_2 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i116_tc_hrdn007(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT tc_cpa002 INTO g_tc_hrdn[l_ac].tc_cpa002_3
      FROM tc_cpa_file
     WHERE tc_cpa001 = g_tc_hrdn[l_ac].tc_hrdn007
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cpm-905'
                                   LET g_tc_hrdn[l_ac].tc_cpa002_3 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i116_tc_hrdn009(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT tc_cpa002 INTO g_tc_hrdn[l_ac].tc_cpa002_4
      FROM tc_cpa_file
     WHERE tc_cpa001 = g_tc_hrdn[l_ac].tc_hrdn009
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cpm-905'
                                   LET g_tc_hrdn[l_ac].tc_cpa002_4 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i116_tc_hrdn011(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1

    LET g_errno = ' '
    SELECT tc_cpa002 INTO g_tc_hrdn[l_ac].tc_cpa002_5
      FROM tc_cpa_file
     WHERE tc_cpa001 = g_tc_hrdn[l_ac].tc_hrdn011
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cpm-905'
                                   LET g_tc_hrdn[l_ac].tc_cpa002_5 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION}

FUNCTION i116_b_askkey()
    CLEAR FORM
    CALL g_tc_hrdn.clear()

    CONSTRUCT g_wc2 ON tc_hrdn01 
         FROM s_tc_hrdn[1].tc_hrdn01 

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE WHEN INFIELD(tc_hrdn01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_tc_hrdn[1].tc_hrdn01
                                           
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

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i116_b_fill(g_wc2)

END FUNCTION

FUNCTION i116_b_fill(p_wc2)              #BODY FILL UP

    DEFINE p_wc2           STRING
    DEFINE l_flag          LIKE type_file.chr20     #No.121022---qiull---add

    #LET g_sql = "SELECT tc_hrdn01,'','',tc_hrdn002,'',tc_hrdn003,'',tc_hrdn004,tc_hrdn005,'',tc_hrdn006,",  #No.121010---qiull---mark
    LET g_sql = "SELECT tc_hrdn01,'','','','',tc_hrdn02,tc_hrdn03,tc_hrdn04,tc_hrdn05,tc_hrdn06,tc_hrdn07,tc_hrdn08 ",
                "  FROM tc_hrdn_file ",
                " WHERE ", p_wc2 CLIPPED,           #單身
                " ORDER BY 1" 

    PREPARE i116_pb FROM g_sql
    DECLARE tc_hrdn_curs CURSOR FOR i116_pb

    CALL g_tc_hrdn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tc_hrdn_curs INTO g_tc_hrdn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #SELECT hrat02,hrao02 INTO g_tc_hrdn[g_cnt].hrat02,g_tc_hrdn[g_cnt].hrao02 FROM hrat_file   #No.121010---qiull---mark
        #No.121010---qiull---add---begin
        SELECT hrat02,hrao02,hrat25,hrad03
          INTO g_tc_hrdn[g_cnt].hrat02,g_tc_hrdn[g_cnt].hrao02,g_tc_hrdn[g_cnt].hrat25,g_tc_hrdn[g_cnt].hrad03
          FROM hrat_file,hrao_file,hrad_file 
        #No.121010---qiull---add---end
         WHERE hrat04=hrao01 AND hrad02=hrat19 and hrat01 = g_tc_hrdn[g_cnt].tc_hrdn01
        {SELECT pmc03 INTO g_tc_hrdn[g_cnt].pmc03 FROM pmc_file
         WHERE pmc01 = g_tc_hrdn[g_cnt].tc_hrdn002
        SELECT tc_cpa002 INTO g_tc_hrdn[g_cnt].tc_cpa002_1 FROM tc_cpa_file
         WHERE tc_cpa001 = g_tc_hrdn[g_cnt].tc_hrdn003
        SELECT tc_cpa002 INTO g_tc_hrdn[g_cnt].tc_cpa002_2 FROM tc_cpa_file
         WHERE tc_cpa001 = g_tc_hrdn[g_cnt].tc_hrdn005
        SELECT tc_cpa002 INTO g_tc_hrdn[g_cnt].tc_cpa002_3 FROM tc_cpa_file
         WHERE tc_cpa001 = g_tc_hrdn[g_cnt].tc_hrdn007
        SELECT tc_cpa002 INTO g_tc_hrdn[g_cnt].tc_cpa002_4 FROM tc_cpa_file
         WHERE tc_cpa001 = g_tc_hrdn[g_cnt].tc_hrdn009
        SELECT tc_cpa002 INTO g_tc_hrdn[g_cnt].tc_cpa002_5 FROM tc_cpa_file
         WHERE tc_cpa001 = g_tc_hrdn[g_cnt].tc_hrdn011   }                       
      #  CALL s_umfchk(g_tc_hrdn[g_cnt].tc_hrdn01,g_tc_hrdn[g_cnt].hrat25,g_tc_hrdn[g_cnt].hrat19) RETURNING l_flag#,g_tc_hrdn[g_cnt].desc                       #No.121022---qiull---add
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_hrdn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION i116_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0
   LET g_curs_index = 0

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_hrdn TO s_tc_hrdn.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
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
 
      ON ACTION about
         CALL cl_about()
 
   
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i116_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("tc_hrdn01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i116_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("tc_hrdn01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
