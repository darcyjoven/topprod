# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft711.4gl
# Descriptions...: 報工時維護作業 
# Date & Author..: 10/09/15 By sabrina  
# Modify.........: No.FUN-A90056 10/09/23 By sabrina 新增asft711程式
# Modify.........: No.FUN-B10054 11/01/24 By jan 新增edf13/edf14/edf15 三個欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70102 12/07/17 By lixh1 作業打開后,在沒有任何資料的情況下給'-400'的提示
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-CB0184 12/11/23 By Elise 員工代碼並非必key不應該直接串進SQL內
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-C30163 12/12/27 By pauline CALL q_ecm(時增加參數
# Modify.........: No.MOD-D10015 13/01/04 By bart 在show段判斷g_wc2 判斷為null 則給1=1
# Modify.........: No.MOD-D20084 13/02/19 By bart 作業編號開窗改為 q_ecd， 員工開窗改為q_gen
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ede   RECORD LIKE ede_file.*,
    g_ede_t RECORD LIKE ede_file.*,
    g_ede_o RECORD LIKE ede_file.*,
    b_edf   RECORD LIKE edf_file.*,
    g_t1           LIKE oay_file.oayslip,                 
    g_wc,g_wc2,g_sql    string, 
    g_argv1        LIKE ede_file.ede01,
    g_argv2        STRING, 
    g_edf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        edf02		LIKE edf_file.edf02,  #項次
        edf03           LIKE edf_file.edf03,  #工單
        sfb81           LIKE sfb_file.sfb81 , #工單日期
        edf04		LIKE edf_file.edf04,  #料號
        ima02           LIKE ima_file.ima02,  #品名
        ima021          LIKE ima_file.ima021, #規格
        edf05		LIKE edf_file.edf05,  #完工入庫量
        edf012          LIKE edf_file.edf012, #製程段號
        edf06		LIKE edf_file.edf06,  #作業編號
        edf07		LIKE edf_file.edf07,  #製程序
        ecd02		LIKE ecd_file.ecd02,  #作業名稱
        edf08		LIKE edf_file.edf08,  #報工數量
        edf09		LIKE edf_file.edf09,  #員工
        gen02		LIKE gen_file.gen02,  #姓名
        edf10           LIKE edf_file.edf10,  #標準單件工時
        edf11           LIKE edf_file.edf11,  #實際單件工時
        edf12           LIKE edf_file.edf12,  #工時合計
        edf13           LIKE edf_file.edf13,  #標準單件機時 #FUN-B10054
        edf14           LIKE edf_file.edf14,  #實際單件機時 #FUN-B10054
        edf15           LIKE edf_file.edf15   #機時合計     #FUN-B10054
                    END RECORD,
    g_edf_t         RECORD                 #程式變數 (舊值)
        edf02		LIKE edf_file.edf02,  #項次
        edf03           LIKE edf_file.edf03,  #工單
        sfb81           LIKE sfb_file.sfb81 , #工單日期
        edf04		LIKE edf_file.edf04,  #料號
        ima02           LIKE ima_file.ima02,  #品名
        ima021          LIKE ima_file.ima021, #規格
        edf05		LIKE edf_file.edf05,  #完工入庫量
        edf012          LIKE edf_file.edf012, #製程段號
        edf06		LIKE edf_file.edf06,  #作業編號
        edf07		LIKE edf_file.edf07,  #製程序
        ecd02		LIKE ecd_file.ecd02,  #作業名稱
        edf08		LIKE edf_file.edf08,  #報工數量
        edf09		LIKE edf_file.edf09,  #員工
        gen02		LIKE gen_file.gen02,  #姓名
        edf10           LIKE edf_file.edf10,  #標準單件工時
        edf11           LIKE edf_file.edf11,  #實際單件工時
        edf12           LIKE edf_file.edf12,  #工時合計
        edf13           LIKE edf_file.edf13,  #標準單件機時 #FUN-B10054
        edf14           LIKE edf_file.edf14,  #實際單件機時 #FUN-B10054
        edf15           LIKE edf_file.edf15   #機時合計     #FUN-B10054
                    END RECORD,
    g_sw            LIKE type_file.chr1,         
    g_rec_b         LIKE type_file.num5,                #單身筆數      
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT    
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose       
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_confirm             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void                LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cmd                 LIKE type_file.chr1000 

MAIN
    DEFINE p_row,p_col     LIKE type_file.num5        
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序) 
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW t711_w AT p_row,p_col WITH FORM "asf/42f/asft711"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("edf012",g_sma.sma541='Y')
 
   CALL t711()
 
   CLOSE WINDOW t711_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION t711()
 
    INITIALIZE g_ede.* TO NULL
    INITIALIZE g_ede_t.* TO NULL
    INITIALIZE g_ede_o.* TO NULL
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t711_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t711_a()
             END IF
          OTHERWISE         
             CALL t711_q()  
       END CASE
    END IF
 
    IF NOT cl_null(g_argv1)  THEN   
       CALL  t711_q()
    END IF
 
    LET g_forupd_sql = "SELECT * FROM ede_file WHERE ede01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t711_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL t711_menu()
 
END FUNCTION
 
FUNCTION t711_cs()
DEFINE lc_qbe_sn    LIKE    gbm_file.gbm01

    LET  g_wc2=' 1=1'
    CLEAR FORM
    INITIALIZE g_ede.* TO NULL
    CALL g_edf.clear()
    CALL cl_set_head_visible("","YES")             
    IF cl_null(g_argv1) THEN
       INITIALIZE g_ede.* TO NULL   
       CONSTRUCT BY NAME g_wc ON
                    ede01,ede02,edeconf
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           ON ACTION controlp
              CASE WHEN INFIELD(ede01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     ="q_ede01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ede01
                     NEXT FIELD ede01
                   OTHERWISE EXIT CASE
               END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
           
           ON ACTION qbe_select
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON edf03,edf04,edf012,edf06,edf07,edf09,edf10,edf11,edf12,
                          edf13,edf14,edf15   #FUN-B10054
            FROM s_edf[1].edf03,
                 s_edf[1].edf04,s_edf[1].edf012,s_edf[1].edf06,s_edf[1].edf07,
                 s_edf[1].edf09,s_edf[1].edf10,s_edf[1].edf11,s_edf[1].edf12,   
                 s_edf[1].edf13,s_edf[1].edf14,s_edf[1].edf15     #FUN-B10054
           BEFORE CONSTRUCT
              CALL cl_qbe_display_condition(lc_qbe_sn)
           ON ACTION controlp
              CASE WHEN INFIELD(edf03)           #工單
                        CALL cl_init_qry_var()    
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form     ="q_sfb2402"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO edf03
                        NEXT FIELD edf03          
                   WHEN INFIELD(edf06)           #作業編號
                        #CALL q_eca(TRUE,TRUE,g_edf[1].edf06) #MOD-D20084
                        CALL q_ecd(TRUE,TRUE,g_edf[1].edf06) #MOD-D20084
                        RETURNING g_qryparam.multiret      
                        DISPLAY g_qryparam.multiret TO edf06 
                        NEXT FIELD edf06
 
                   WHEN INFIELD(edf09)           #員工
                        #CALL q_ecd(TRUE,TRUE,g_edf[1].edf09)  #MOD-D20084
                        #RETURNING g_qryparam.multiret   #MOD-D20084    
                        CALL cl_init_qry_var()  #MOD-D20084
                        LET g_qryparam.state    = "c"  #MOD-D20084
                        LET g_qryparam.form     ="q_gen"   #MOD-D20084  
                        CALL cl_create_qry() RETURNING g_qryparam.multiret #MOD-D20084  
                        DISPLAY g_qryparam.multiret TO edf09  
                        NEXT FIELD edf09
              END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION qbe_save
              CALL cl_qbe_save()
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = NULL   
       IF not cl_null(g_argv1) THEN
          LET g_wc=" ede01='",g_argv1,"'"
       END IF
    END IF
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL
       THEN LET g_sql="SELECT ede01 FROM ede_file ",    
                      " WHERE ",g_wc CLIPPED, " ORDER BY ede01"
       ELSE LET g_sql="SELECT ede01",
                      "  FROM ede_file,edf_file ",     
                      " WHERE ede01=edf01 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY ede01"
    END IF
    PREPARE t711_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t711_cs SCROLL CURSOR WITH HOLD FOR t711_prepare
    LET g_sql= "SELECT COUNT(*) FROM ede_file WHERE ",g_wc CLIPPED    
    PREPARE t711_precount FROM g_sql
    DECLARE t711_count CURSOR FOR t711_precount
END FUNCTION
 
FUNCTION t711_menu()
 
   WHILE TRUE
      CALL t711_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t711_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t711_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t711_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t711_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t711_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t711_y()
               CALL t711_show()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t711_z()   
               CALL t711_show()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t711_x()    #CHI-D20010
               CALL t711_x(1)   #CHI-D20010   
               CALL t711_show()
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t711_x(2)
               CALL t711_show()
            END IF
         #CHI-D20010---end
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t711_copy()   
            END IF
         WHEN "volume_generated"
            IF cl_chk_act_auth() THEN
               CALL t711_g()   
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t711_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_edf),'','')
            END IF
      END CASE
   END WHILE
   CLOSE t711_cs
END FUNCTION
 
FUNCTION t711_a()
    DEFINE li_result  LIKE type_file.num5        
    DEFINE    l_cnt   LIKE type_file.num5        
    DEFINE    l_chr   LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_edf.clear()
    INITIALIZE g_ede.* TO NULL
    LET g_ede_o.* = g_ede.*
    LET g_ede_t.* = g_ede.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ede.ede02 = TODAY
        LET g_ede.edeconf='N'
        LET g_ede.edeacti='Y'
        LET g_ede.edeuser=g_user
        LET g_ede.edeoriu = g_user 
        LET g_ede.edeorig = g_grup 
        LET g_ede.edegrup=g_grup
        LET g_ede.edeplant = g_plant 
        LET g_ede.edelegal = g_legal 
        CALL t711_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_ede.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_ede.ede01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK 
        CALL s_auto_assign_no("asf",g_ede.ede01,TODAY,"W","ede_file","ede01","","","")
        RETURNING li_result,g_ede.ede01
        IF (NOT li_result) THEN
              ROLLBACK WORK  
              CONTINUE WHILE
           END IF
	   DISPLAY BY NAME g_ede.ede01
        INSERT INTO ede_file VALUES (g_ede.*)
        IF STATUS THEN
           CALL cl_err3("ins","ede_file",g_ede.ede01,"",STATUS,"","ins ede",1) 
           ROLLBACK WORK  
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_ede.ede01,'I')
 
        SELECT ede01 INTO g_ede.ede01 FROM ede_file WHERE ede01 = g_ede.ede01

        OPEN WINDOW t711_g_w WITH FORM "asf/42f/asft711_g"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
        CALL cl_ui_locale("asft711_g")

        LET l_chr='1'   
        INPUT l_chr WITHOUT DEFAULTS FROM FORMONLY.a

        AFTER FIELD a
          IF l_chr NOT MATCHES '[12]' THEN  
             NEXT FIELD a
          END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        AFTER INPUT
           IF INT_FLAG THEN                         # 若按了DEL鍵
              LET INT_FLAG = 0
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
           LET l_chr = '1'
        END IF

        CLOSE WINDOW t711_g_w               #結束畫面

        IF cl_null(l_chr) THEN
           LET l_chr = '1'
        END IF
        LET g_rec_b = 0
        CASE
          WHEN l_chr = '1'
               CALL g_edf.clear()
               CALL t711_b()
          WHEN l_chr = '2'
               COMMIT WORK
               CALL t711_g()
          OTHERWISE EXIT CASE
        END CASE
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t711_u()
    DEFINE  l_cnt   LIKE type_file.num5         
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ede.ede01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ede.edeconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_ede.edeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    SELECT * INTO g_ede.* FROM ede_file WHERE ede01 = g_ede.ede01
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ede_o.* = g_ede.*
 
    BEGIN WORK
 
    OPEN t711_cl USING g_ede.ede01
    IF STATUS THEN
       CALL cl_err("OPEN t711_cl:", STATUS, 1)
       CLOSE t711_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t711_cl INTO g_ede.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock ede:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t711_cl ROLLBACK WORK RETURN
    END IF
    CALL t711_show()
    WHILE TRUE
        LET g_ede.edemodu=g_user
        LET g_ede.ededate=g_today
        CALL t711_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ede.*=g_ede_t.*
            CALL t711_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ede_file SET * = g_ede.* WHERE ede01 = g_ede_t.ede01
        IF STATUS THEN
            CALL cl_err3("upd","ede_file",g_ede_t.ede01,"",STATUS,"","",1)  
        CONTINUE WHILE END IF
        IF g_ede.ede01 != g_ede_t.ede01 THEN CALL t711_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t711_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ede.ede01,'U')
END FUNCTION
 
FUNCTION t711_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1        
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ede.ede01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ede.edeconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_ede.edeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    SELECT * INTO g_ede.* FROM ede_file WHERE ede01 = g_ede.ede01
 
    IF g_ede.edeconf = 'Y'   THEN CALL cl_err('','apm-067',0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t711_cl USING g_ede.ede01
    IF STATUS THEN
       CALL cl_err("OPEN t711_cl:", STATUS, 1)
       CLOSE t711_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t711_cl INTO g_ede.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ede.ede01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t711_show()
    IF cl_delb(20,16) THEN
       MESSAGE "Delete ede,edf!"
       DELETE FROM ede_file WHERE ede01 = g_ede.ede01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","ede_file",g_ede.ede01,"",SQLCA.SQLCODE,"","No ede deleted",1)  
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM edf_file WHERE edf01 = g_ede.ede01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","edf_file",g_ede.ede01,"",STATUS,"","del edf",1)  
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       CALL g_edf.clear()
       INITIALIZE g_ede.* TO NULL
       MESSAGE ""
       OPEN t711_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t711_cs
          CLOSE t711_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t711_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t711_cs
          CLOSE t711_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t711_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t711_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t711_fetch('/')
       END IF
    END IF
    CLOSE t711_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ede.ede01,'D')
 
END FUNCTION
 
FUNCTION t711_chkkey()
    UPDATE edf_file SET edf01=g_ede.ede01 WHERE edf01=g_ede_t.ede01
    IF STATUS THEN
       CALL cl_err3("upd","edf_file",g_ede_t.ede01,"",STATUS,"","upd edf01",1)  
       CALL t711_show()
       ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION t711_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ede.* TO NULL              
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t711_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_edf.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN t711_count
    FETCH t711_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN t711_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ede.ede01,SQLCA.sqlcode,0)
        INITIALIZE g_ede.* TO NULL
    ELSE
        CALL t711_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t711_fetch(p_flede)
    DEFINE
        p_flede         LIKE type_file.chr1,          
        l_abso          LIKE type_file.num10          
 
    CASE p_flede
        WHEN 'N' FETCH NEXT     t711_cs INTO g_ede.ede01
        WHEN 'P' FETCH PREVIOUS t711_cs INTO g_ede.ede01
        WHEN 'F' FETCH FIRST    t711_cs INTO g_ede.ede01
        WHEN 'L' FETCH LAST     t711_cs INTO g_ede.ede01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t711_cs INTO g_ede.ede01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ede.ede01,SQLCA.sqlcode,0)
        INITIALIZE g_ede.* TO NULL  
        RETURN
    ELSE
       CASE p_flede
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ede.* FROM ede_file       # 重讀DB,因TEMP有不被更新特性
       WHERE ede01 = g_ede.ede01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ede_file",g_ede.ede01,"",SQLCA.sqlcode,"","",1)  
    ELSE
       LET g_data_owner = g_ede.edeuser      
       LET g_data_group = g_ede.edegrup      
       LET g_data_plant = g_ede.edeplant 
       CALL t711_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t711_show()
 
    LET g_ede_t.* = g_ede.*
    IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF  #MOD-D10015
    DISPLAY BY NAME 
        g_ede.ede01, g_ede.ede02, g_ede.edeconf 
 
        CALL t711_b_fill(g_wc2)
        CASE g_ede.edeconf
             WHEN 'Y'   LET g_confirm = 'Y'
                        LET g_void = ''
             WHEN 'N'   LET g_confirm = 'N'
                        LET g_void = ''
             WHEN 'X'   LET g_confirm = ''
                        LET g_void = 'Y'
          OTHERWISE     LET g_confirm = ''
                        LET g_void = ''
        END CASE
        #圖形顯示
        CALL cl_set_field_pic(g_confirm,"","","",g_void,g_ede.edeacti)
    CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION t711_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5         
  DEFINE p_cmd          LIKE type_file.chr1                 #a:輸入 u:更改    
  DEFINE l_n,l_cnt      LIKE type_file.num5       
 
    DISPLAY BY NAME
       g_ede.ede01,g_ede.ede02,g_ede.edeconf
      
    CALL cl_set_head_visible("","YES")              #FUN-6B0031 
    INPUT BY NAME 
       g_ede.ede01,g_ede.ede02,g_ede.edeconf
       WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t711_set_entry(p_cmd)
            CALL t711_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD ede01
         #IF p_cmd = "a" AND NOT cl_null(g_ede.ede01) THEN                  
          IF NOT cl_null(g_ede.ede01) AND (g_ede.ede01 != g_ede_t.ede01 OR g_ede_t.ede01 IS NULL) THEN     #FUN-B50026 mod
            CALL s_check_no("asf",g_ede.ede01,g_ede_t.ede01,"W","ede_file","ede01","")
            RETURNING li_result,g_ede.ede01
            DISPLAY BY NAME g_ede.ede01
            IF (NOT li_result) THEN
               NEXT FIELD ede01
            END IF
          END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(ede01)
                     LET g_t1 = s_get_doc_no(g_ede.ede01)    
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','W') RETURNING g_t1 
                     LET g_ede.ede01=g_t1   
                     DISPLAY BY NAME g_ede.ede01
                     NEXT FIELD ede01
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION t711_b()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態        
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
    l_allow_insert  LIKE type_file.num5,                #可新增否        
    l_allow_delete  LIKE type_file.num5                 #可刪除否       
 
    LET g_action_choice = ""
 
    IF g_ede.ede01 IS NULL THEN RETURN END IF
    IF g_ede.edeconf = 'Y' THEN 
       CALL cl_err('','axm-101',1) 
       RETURN
    END IF
    IF g_ede.edeconf = 'X' THEN 
       CALL cl_err('','9024',1) 
       RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT * FROM edf_file ", 
        " WHERE edf01  = ?  AND edf02 = ? FOR UPDATE" 
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t711_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
   #IF g_rec_b=0 THEN CALL g_edf.clear() END IF
 
    INPUT ARRAY g_edf WITHOUT DEFAULTS FROM s_edf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL t711_set_entry_b()
            CALL t711_set_no_entry_b()
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t711_cl USING g_ede.ede01
            IF STATUS THEN
               CALL cl_err("OPEN t711_cl:", STATUS, 1)
               CLOSE t711_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t711_cl INTO g_ede.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err('lock ede:',SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t711_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_edf_t.* = g_edf[l_ac].*  #BACKUP
                OPEN t711_bcl USING g_ede.ede01,g_edf_t.edf02   
                IF STATUS THEN
                   CALL cl_err("OPEN t711_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t711_bcl INTO b_edf.*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_edf_t.edf02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_edf[l_ac].* TO NULL     
            LET g_edf[l_ac].edf05 = 0
            LET g_edf[l_ac].edf08 = 0
            LET g_edf[l_ac].edf10 = 0
            LET g_edf[l_ac].edf11 = 0
            LET g_edf[l_ac].edf12 = 0
            LET g_edf[l_ac].edf13 = 0   #FUN-B10054
            LET g_edf[l_ac].edf14 = 0   #FUN-B10054
            LET g_edf[l_ac].edf15 = 0   #FUN-B10054
            LET g_edf_t.* = g_edf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD edf02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_edf[l_ac].edf05) THEN LET g_edf[l_ac].edf05 = 0 END IF
            IF cl_null(g_edf[l_ac].edf08) THEN LET g_edf[l_ac].edf08 = 0 END IF
            INSERT INTO edf_file(edf01,edf02,edf03,edf04,edf05,edf012,edf06,edf07,    
                                 edf08,edf09,edf10,edf11,edf12,edf13,edf14,edf15,  #FUN-B10054
                                 edfplant,edflegal)
                          VALUES(g_ede.ede01,g_edf[l_ac].edf02,
                                 g_edf[l_ac].edf03,g_edf[l_ac].edf04,g_edf[l_ac].edf05,
                                 g_edf[l_ac].edf012,g_edf[l_ac].edf06,                
                                 g_edf[l_ac].edf07,g_edf[l_ac].edf08,
                                 g_edf[l_ac].edf09,g_edf[l_ac].edf10,
                                 g_edf[l_ac].edf11,g_edf[l_ac].edf12,
                                 g_edf[l_ac].edf13,g_edf[l_ac].edf14,g_edf[l_ac].edf15,  #FUN-B10054
                                 g_plant,g_legal)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","edf_file",g_ede.ede01,g_edf[l_ac].edf03,SQLCA.sqlcode,"","ins edf",1)  
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
    
        BEFORE FIELD edf02 
           IF g_edf[l_ac].edf02 IS NULL OR g_edf[l_ac].edf02 = 0 THEN
              SELECT max(edf02)+1 INTO g_edf[l_ac].edf02
                FROM edf_file WHERE edf01 = g_ede.ede01
              IF g_edf[l_ac].edf02 IS NULL THEN
                  LET g_edf[l_ac].edf02 = 1
              END IF
           END IF

        AFTER FIELD edf02
          IF g_edf[l_ac].edf02 IS NULL THEN
             LET g_edf[l_ac].edf02 = g_edf_t.edf02
          END IF
          IF NOT cl_null(g_edf[l_ac].edf02) THEN
              IF g_edf[l_ac].edf02 != g_edf_t.edf02 OR
                 g_edf_t.edf02 IS NULL THEN
                  SELECT count(*)
                      INTO l_n
                      FROM edf_file
                      WHERE edf01 = g_ede.ede01 AND
                            edf02 = g_edf[l_ac].edf02
                  IF l_n > 0 THEN
                      CALL cl_err('',-239,1) 
                      LET g_edf[l_ac].edf02 = g_edf_t.edf02
                      NEXT FIELD edf02
                  END IF
              END IF
          END IF

        AFTER FIELD edf03
          IF NOT cl_null(g_edf[l_ac].edf03) THEN
             SELECT count(*) INTO l_n FROM sfb_file
              WHERE sfb01 = g_edf[l_ac].edf03
                AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR          
                    (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))     
                AND (sfb28 < '2' OR sfb28 IS NULL)
                AND sfb87!='X'
             IF l_n = 0 THEN
                CALL cl_err(g_edf[l_ac].edf03,'asf-018',0) 
                LET g_edf[l_ac].edf03 = g_edf_t.edf03
                DISPLAY BY NAME g_edf[l_ac].edf03
                NEXT FIELD edf03
             ELSE
                IF p_cmd = 'a' THEN
                   SELECT sfb81,sfb05,sfb09,sfb09 
                     INTO g_edf[l_ac].sfb81,g_edf[l_ac].edf04,g_edf[l_ac].edf05,g_edf[l_ac].edf08
                     FROM sfb_file
                    WHERE sfb01 = g_edf[l_ac].edf03
                   SELECT ima02,ima021 INTO g_edf[l_ac].ima02,g_edf[l_ac].ima021 FROM ima_file
                    WHERE ima01 = g_edf[l_ac].edf04
                END IF
             END IF
          END IF
        
        AFTER FIELD edf04
          IF NOT cl_null(g_edf[l_ac].edf04) THEN
             SELECT ima02,ima021 INTO g_edf[l_ac].ima02,g_edf[l_ac].ima021 
               FROM ima_file
              WHERE ima01 = g_edf[l_ac].edf04
             IF SQLCA.SQLCODE THEN
                CALL cl_err(g_edf[l_ac].edf04,'axc-204',0)
                NEXT FIELD edf04
             END IF
          END IF 

        AFTER FIELD edf05 
          IF g_edf[l_ac].edf05 <= 0 THEN 
             CALL cl_err('','afa-037',0)
             NEXT FIELD edf05
          END IF
 
        AFTER FIELD edf012
          IF NOT cl_null(g_edf[l_ac].edf012) THEN
             LET l_cnt = 0
             SELECT 	COUNT(*) INTO l_cnt FROM ecm_file
              WHERE ecm01=g_edf[l_ac].edf03
                AND ecm012=g_edf[l_ac].edf012
             IF l_cnt = 0 THEN  
                CALL cl_err('','abm-214',1)
                NEXT FIELD edf012
             END IF
             #平行工藝時,可以輸入製程序,但不能輸作業編號,故這裡要做一次在作業編號處理的事情
             IF p_cmd = 'a' THEN
                CALL t711_edf06_relation() RETURNING g_i 
             END IF
          END IF

        AFTER FIELD edf06
          IF NOT cl_null(g_edf[l_ac].edf06) THEN
             IF t711_edf06_relation() THEN 
                NEXT FIELD edf06 
             END IF
          END IF
        AFTER FIELD edf07
          IF NOT cl_null(g_edf[l_ac].edf07) THEN
             IF cl_null(g_edf[l_ac].edf012) THEN LET g_edf[l_ac].edf012=' ' END IF
             LET l_cnt = 0
             SELECT 	COUNT(*) INTO l_cnt FROM ecm_file
              WHERE ecm01=g_edf[l_ac].edf03
                AND ecm012=g_edf[l_ac].edf012
                AND ecm03=g_edf[l_ac].edf07
             IF l_cnt = 0 THEN  
                CALL cl_err('','abm-215',1)
                NEXT FIELD edf07
             END IF

             #平行工藝時,可以輸入製程序,但不能輸作業編號,故這裡要做一次在作業編號處理的事情
             IF p_cmd = 'a' THEN
                CALL t711_edf06_relation() RETURNING g_i 
             END IF
          END IF

        AFTER FIELD edf08 
          IF g_edf[l_ac].edf08 <= 0 THEN 
             CALL cl_err('','afa-037',0)
             NEXT FIELD edf08
          END IF

        AFTER FIELD edf09
          IF NOT cl_null(g_edf[l_ac].edf09) THEN
             CALL t711_edf09('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD edf09 
             END IF
          END IF

        AFTER FIELD edf11 
          IF g_edf[l_ac].edf11 <= 0 THEN 
             CALL cl_err('','afa-037',0)
             NEXT FIELD edf11
          ELSE
             LET g_edf[l_ac].edf12 = g_edf[l_ac].edf11 * g_edf[l_ac].edf08
             DISPLAY BY NAME g_edf[l_ac].edf12
          END IF

       #FUN-B10054--begin--add---
        AFTER FIELD edf14 
          IF g_edf[l_ac].edf14 <= 0 THEN 
             CALL cl_err('','afa-037',0)
             NEXT FIELD edf14
          ELSE
             LET g_edf[l_ac].edf15 = g_edf[l_ac].edf14 * g_edf[l_ac].edf08
             DISPLAY BY NAME g_edf[l_ac].edf15
          END IF
       #FUN-B10054--end--add-------

        BEFORE DELETE                            #是否取消單身
            IF g_edf_t.edf02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM edf_file
                WHERE edf01 = g_ede.ede01
                  AND edf02 = g_edf_t.edf02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","edf_file",g_ede.ede01,g_edf_t.edf03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
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
               LET g_edf[l_ac].* = g_edf_t.*
               CLOSE t711_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_edf[l_ac].edf03,-263,1)
               LET g_edf[l_ac].* = g_edf_t.*
            ELSE
               UPDATE edf_file SET edf02=g_edf[l_ac].edf02,
                                   edf03=g_edf[l_ac].edf03,
                                   edf04=g_edf[l_ac].edf04,
                                   edf05=g_edf[l_ac].edf05,
                                   edf06=g_edf[l_ac].edf06,
                                   edf07=g_edf[l_ac].edf07,
                                   edf08=g_edf[l_ac].edf08,
                                   edf09=g_edf[l_ac].edf09,
                                   edf10=g_edf[l_ac].edf10,
                                   edf11=g_edf[l_ac].edf11,
                                   edf12=g_edf[l_ac].edf12, 
                                   edf13=g_edf[l_ac].edf13,  #FUN-B10054
                                   edf14=g_edf[l_ac].edf14,  #FUN-B10054
                                   edf15=g_edf[l_ac].edf15   #FUN-B10054
                 WHERE edf01=g_ede.ede01
                   AND edf02=g_edf_t.edf02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","edf_file",g_ede.ede01,g_edf_t.edf03,SQLCA.sqlcode,"","",1)  
                    LET g_edf[l_ac].* = g_edf_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac    #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edf[l_ac].* = g_edf_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_edf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t711_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D40030 Add
            CLOSE t711_bcl
            COMMIT WORK
        ON ACTION CONTROLS           
         CALL cl_set_head_visible("","AUTO")           
 
        ON ACTION controlp
           CASE WHEN INFIELD(edf03)                 #工單
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfb2402"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_edf[l_ac].edf03
                     LET g_qryparam.arg1     = 234567
                     CALL cl_create_qry() RETURNING g_edf[l_ac].edf03
                     DISPLAY BY NAME g_edf[l_ac].edf03
                     NEXT FIELD edf03
                WHEN INFIELD(edf012)                #製程段號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shb012"
                     LET g_qryparam.default1 = g_edf[l_ac].edf012
                     LET g_qryparam.default2 = g_edf[l_ac].edf07
                     LET g_qryparam.default3 = g_edf[l_ac].edf06
                     LET g_qryparam.arg1     = g_edf[l_ac].edf03
                     CALL cl_create_qry() RETURNING g_edf[l_ac].edf012,g_edf[l_ac].edf07,g_edf[l_ac].edf06
                     DISPLAY BY NAME g_edf[l_ac].edf012,g_edf[l_ac].edf07,g_edf[l_ac].edf06
                     NEXT FIELD CURRENT
                WHEN INFIELD(edf06)                 #作業編號
                     IF cl_null(g_edf[l_ac].edf012) THEN LET g_edf[l_ac].edf012=' ' END IF 
                     CALL q_ecm02(FALSE,FALSE,g_edf[l_ac].edf03,'') RETURNING g_edf[l_ac].edf06,g_edf[l_ac].edf07 
                     SELECT ecm03
                       INTO g_edf[l_ac].edf07
                       FROM ecm_file
                      WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
                        AND ecm03=g_edf[l_ac].edf07
                        AND ecm012=g_edf[l_ac].edf012
                     IF STATUS THEN  #資料資料不存在
                        CALL cl_err(g_edf[l_ac].edf06,g_errno,0)
                        LET g_edf[l_ac].edf06 = g_edf_t.edf06
                        LET g_edf[l_ac].edf07 = g_edf_t.edf07
                        DISPLAY BY NAME g_edf[l_ac].edf06,g_edf[l_ac].edf07
                        NEXT FIELD edf06 
                     END IF
                WHEN INFIELD(edf09)                 #員工
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_gen"
                     LET g_qryparam.default1 = g_edf[l_ac].edf09
                     CALL cl_create_qry() RETURNING g_edf[l_ac].edf09
                     DISPLAY BY NAME g_edf[l_ac].edf09
                     NEXT FIELD edf09 
           END CASE
 
        ON ACTION CONTROLO   #沿用所有欄位
            IF INFIELD(edf02) AND l_ac > 1 THEN
                LET g_edf[l_ac].* = g_edf[l_ac-1].*
                NEXT FIELD edf02
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
 
    END INPUT
 
    UPDATE ede_file SET edemodu= g_user,
                        ededate= TODAY
     WHERE ede01=g_ede.ede01
 
    CLOSE t711_bcl
    CALL t711_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t711_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ede.ede01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ede_file ",
                  "  WHERE ede01 LIKE '",l_slip,"%' ",
                  "    AND ede01 > '",g_ede.ede01,"'"
      PREPARE t711_pb1 FROM l_sql 
      EXECUTE t711_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t711_x()   #CHI-D20010
         CALL t711_x(1)  #CHI-D20010   
         CALL t711_show()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  ede_file WHERE ede01=g_ede.ede01
         INITIALIZE g_ede.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t711_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ede01",TRUE)  
   END IF

END FUNCTION

FUNCTION t711_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ede01",FALSE)  
   END IF

END FUNCTION

FUNCTION t711_set_entry_b()

    CALL cl_set_comp_entry("edf012,edf06,edf07",FALSE) 
 
END FUNCTION
 
FUNCTION t711_set_no_entry_b()
 
  CALL cl_set_comp_entry("sfb81,ima02,ima021,ecd02,gen02,edf10,edf12,edf13,edf15",FALSE) #FUN-B10054 add edf13,edf15
 
  IF g_sma.sma541='Y' THEN
     CALL cl_set_comp_entry("edf012,edf07",TRUE)
  ELSE
     CALL cl_set_comp_entry("edf06",TRUE)
  END IF
END FUNCTION
 
FUNCTION t711_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
    CONSTRUCT g_wc2 ON edf02,edf03,edf04,edf05,edf012,edf06,edf07,edf08,edf09,edf10,edf11,edf12,
                       edf13,edf14,edf15   #FUN-B10054
            FROM s_edf[1].edf02,s_edf[1].edf03,s_edf[1].edf04,s_edf[1].edf05,
                 s_edf[1].edf012,s_edf[1].edf06,
                 s_edf[1].edf07,s_edf[1].edf08,s_edf[1].edf09,s_edf[1].edf10,s_edf[1].edf11,
                 s_edf[1].edf12,s_edf[1].edf13,s_edf[1].edf14,s_edf[1].edf15  #FUN-B10054
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t711_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t711_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
 
    LET g_sql =
        "SELECT edf02,edf03,'',edf04,'','',edf05,edf012,edf06,edf07,'',edf08,edf09,'',edf10,edf11,edf12,edf13,edf14,edf15 ",  #FUN-B10054 
        " FROM edf_file ",
        " WHERE edf01 ='",g_ede.ede01,"' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY edf02"   
    PREPARE t711_pb FROM g_sql
    DECLARE edf_curs CURSOR FOR t711_pb
 
    CALL g_edf.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH edf_curs INTO g_edf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        SELECT sfb81 INTO g_edf[g_cnt].sfb81 FROM sfb_file
         WHERE sfb01 = g_edf[g_cnt].edf03
        SELECT ima02,ima021 INTO g_edf[g_cnt].ima02,g_edf[g_cnt].ima021 FROM ima_file
         WHERE ima01 = g_edf[g_cnt].edf04
        SELECT ecd02 INTO g_edf[g_cnt].ecd02 FROM ecd_file
         WHERE ecd01 = g_edf[g_cnt].edf06
        SELECT gen02 INTO g_edf[g_cnt].gen02 FROM gen_file
         WHERE gen01 = g_edf[g_cnt].edf09
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_edf.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    LET l_ac=0
 
END FUNCTION
 
FUNCTION t711_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_edf TO s_edf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()             
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO")             
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY  
      ON ACTION first
         CALL t711_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

      ON ACTION void 
         LET g_action_choice="void"
         EXIT DISPLAY
  
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end

      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION Volume_generated
         LET g_action_choice="volume_generated"
         EXIT DISPLAY

      ON ACTION previous
         CALL t711_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
 
      ON ACTION jump
         CALL t711_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL t711_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL t711_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
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
            CASE g_ede.edeconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,g_ede.edeacti)
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t711_edf09(p_cmd)
    DEFINE l_gen02    LIKE gen_file.gen02,
           l_genacti  LIKE gen_file.genacti,
           p_cmd      LIKE type_file.chr1   
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO g_edf[l_ac].gen02,l_genacti
      FROM gen_file WHERE gen01 = g_edf[l_ac].edf09
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                                   LET g_edf[l_ac].gen02 = NULL
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION t711_out()
                                           
                                           
    IF cl_null(g_ede.ede01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    LET g_wc =" ede01='",g_ede.ede01,"'"       
    
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
   
   #MOD-CB0184---mark---S
   #LET g_sql = "SELECT ede02,edf_file.*,sfb81,ima02,ima021,ecd02,gen02 ",
   #            "  FROM ede_file,edf_file,sfb_file,ima_file,ecd_file,gen_file ",
   #            " WHERE edf03=sfb01 ",
   #            "   AND edf04=ima01 ", 
   #            "   AND edf06=ecd01 ", 
   #            "   AND edf09=gen01 ", 
   #            "   AND ede01=edf01 ", 
   #            "   AND ",g_wc CLIPPED,
   #            "   AND ",g_wc2 CLIPPED
   #MOD-CB0184---mark---E
   #MOD-CB0184------S
    LET g_sql = "SELECT ede02,edf_file.*,sfb81,ima02,ima021,ecd02,gen02 ",
                "  FROM ede_file, ",
                "       edf_file LEFT OUTER JOIN gen_file ON (edf09=gen01), ",
                "       sfb_file,ima_file,ecd_file ",
                " WHERE edf03=sfb01 ",
                "   AND edf04=ima01 ",
                "   AND edf06=ecd01 ",
                "   AND ede01=edf01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   #MOD-CB0184------E 

    IF g_sma.sma541 = 'N' THEN 
       CALL cl_prt_cs1('asft711','asft711',g_sql,'')
    ELSE
       CALL cl_prt_cs1('asft711','asft711_1',g_sql,'')
    END IF
END FUNCTION

FUNCTION t711_edf06_relation()
   DEFINE l_cnt    LIKE type_file.num5

   IF cl_null(g_edf[l_ac].edf012) THEN LET g_edf[l_ac].edf012=' ' END IF 

   IF NOT cl_null(g_edf[l_ac].edf07) THEN
      SELECT COUNT(*) INTO l_cnt FROM ecm_file
       WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
         AND ecm03=g_edf[l_ac].edf07
         AND ecm012=g_edf[l_ac].edf012  
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM ecm_file
       WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
         AND ecm012=g_edf[l_ac].edf012  
   END IF

   CASE
     WHEN l_cnt=0
          CALL cl_err(g_edf[l_ac].edf06,'aec-015',1)
          LET g_edf[l_ac].edf06 = g_edf_t.edf06
          LET g_edf[l_ac].edf07 = g_edf_t.edf07
     WHEN l_cnt=1
          IF NOT cl_null(g_edf[l_ac].edf07) THEN
              SELECT ecm03,ecm13,ecm13,ecm15,ecm15   #FUN-B10054
                INTO g_edf[l_ac].edf07,g_edf[l_ac].edf10,g_edf[l_ac].edf11,
                     g_edf[l_ac].edf13,g_edf[l_ac].edf14   #FUN-B10054
                FROM ecm_file
               WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
                 AND ecm03=g_edf[l_ac].edf07
                 AND ecm012=g_edf[l_ac].edf012  
          ELSE
              SELECT ecm03,ecm13,ecm13,ecm15,ecm15  #FUN-B10054
                INTO g_edf[l_ac].edf07,g_edf[l_ac].edf10,g_edf[l_ac].edf11,
                     g_edf[l_ac].edf13,g_edf[l_ac].edf14   #FUN-B10054
                FROM ecm_file
               WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
                 AND ecm012=g_edf[l_ac].edf012  
          END IF
          IF STATUS THEN  #資料資料不存在
             CALL cl_err(g_edf[l_ac].edf06,STATUS,0)
             LET g_edf[l_ac].edf06 = g_edf_t.edf06
             LET g_edf[l_ac].edf07 = g_edf_t.edf07
          END IF
     WHEN l_cnt>1
         #如果手動輸入作業編號存在兩個製程序,則需讓使用者開窗挑選製程序
         #CALL q_ecm(FALSE,FALSE,g_edf[l_ac].edf03,g_edf[l_ac].edf06)   #FUN-C30163 mark
          CALL q_ecm(FALSE,FALSE,g_edf[l_ac].edf03,g_edf[l_ac].edf06,'','','','')  #FUN-C30163 add
          RETURNING g_edf[l_ac].edf06,g_edf[l_ac].edf07
          SELECT ecm03,ecm13,ecm13,ecm15,ecm15  #FUN-B10054
            INTO g_edf[l_ac].edf07,g_edf[l_ac].edf10,g_edf[l_ac].edf11,
                 g_edf[l_ac].edf13,g_edf[l_ac].edf14   #FUN-B10054
            FROM ecm_file
           WHERE ecm01=g_edf[l_ac].edf03 AND ecm04=g_edf[l_ac].edf06
             AND ecm03=g_edf[l_ac].edf07
             AND ecm012=g_edf[l_ac].edf012 
          IF STATUS THEN  #資料資料不存在
             CALL cl_err(g_edf[l_ac].edf06,STATUS,0)
             LET g_edf[l_ac].edf06 = g_edf_t.edf06
             LET g_edf[l_ac].edf07 = g_edf_t.edf07
          END IF
   END CASE
   LET g_edf[l_ac].edf12 = g_edf[l_ac].edf11 * g_edf[l_ac].edf08
   RETURN 0
END FUNCTION

FUNCTION t711_y()
DEFINE    l_cnt   LIKE type_file.num5        

   IF g_ede.ede01 IS NULL THEN
      CALL cl_err('','-400',1)   #TQC-C70102   
      RETURN
   END IF
#CHI-C30107 --------------- add ------------- begin
   IF g_ede.edeconf = 'Y' THEN
      CALL cl_err('','9023',1)
      RETURN
   END IF
   IF g_ede.edeconf = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF   
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
   SELECT * INTO g_ede.* FROM ede_file WHERE ede01 = g_ede.ede01
#CHI-C30107 --------------- add ------------- end
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM edf_file
    WHERE edf01 = g_ede.ede01
   IF l_cnt = 0 THEN
      CALL cl_err('','atm-228',1)
      RETURN
   END IF      
   IF g_ede.edeconf = 'Y' THEN
      CALL cl_err('','9023',1)
      RETURN
   END IF
   IF g_ede.edeconf = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
#CHI-C30107 ------------- mark ----------- begin
#  IF NOT cl_confirm('axm-108') THEN
#     RETURN
#  END IF
#CHI-C30107 ------------- mark ----------- end
   UPDATE ede_file set edeconf='Y' WHERE ede01 = g_ede.ede01
   LET g_ede.edeconf = 'Y'
   DISPLAY BY NAME g_ede.edeconf
END FUNCTION

FUNCTION t711_z()

#TQC-C70102 ---------Begin----------
   IF g_ede.ede01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
#TQC-C70102 ---------End------------

   IF g_ede.edeconf = 'N' THEN
      CALL cl_err('','9025',1)
      RETURN
   END IF
   IF g_ede.edeconf = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN 
      RETURN 
   END IF
   UPDATE ede_file set edeconf='N' WHERE ede01 = g_ede.ede01
   LET g_ede.edeconf = 'N'
   DISPLAY BY NAME g_ede.edeconf
END FUNCTION

#FUNCTION t711_x()       #CHI-D20010
FUNCTION t711_x(p_type)  #CHI-D20010
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010

#TQC-C70102 ---------Begin----------
   IF g_ede.ede01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
#TQC-C70102 ---------End------------

   IF g_ede.edeconf = 'Y' THEN
      CALL cl_err('','9023',1)
      RETURN
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ede.edeconf ='X' THEN RETURN END IF
   ELSE
      IF g_ede.edeconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

  #IF cl_void(0,0,g_ede.edeconf) THEN    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN           #CHI-D20010
     #IF g_ede.edeconf = 'N' THEN   #CHI-D20010
      IF p_type = 1 THEN     #CHI-D20010
         LET g_ede.edeconf = 'X'
      ELSE
         LET g_ede.edeconf = 'N'
      END IF      
      UPDATE ede_file set edeconf=g_ede.edeconf WHERE ede01 = g_ede.ede01
      DISPLAY BY NAME g_ede.edeconf
   END IF
END FUNCTION

FUNCTION t711_copy()
DEFINE l_ede01_t    LIKE ede_file.ede01
DEFINE l_ede02_t    LIKE ede_file.ede02
DEFINE l_ede01      LIKE ede_file.ede01
DEFINE l_ede02      LIKE ede_file.ede02
DEFINE li_result    LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF g_ede.ede01 IS NULL THEN
        CALL cl_err('',-420,0)
        RETURN
    END IF
    LET l_ede01_t = g_ede.ede01
    LET l_ede02_t = g_ede.ede02
    LET g_before_input_done = FALSE 
    CALL t711_set_entry('a')        
    LET g_before_input_done = TRUE  
 
    CALL cl_set_head_visible("","YES")        
    INPUT l_ede01,l_ede02 FROM ede01,ede02
          BEFORE INPUT
             CALL cl_set_docno_format("ede01")

          AFTER FIELD ede01
            IF NOT cl_null(l_ede01) THEN                  
               CALL s_check_no("asf",l_ede01,"","W","ede_file","ede01","")
               RETURNING li_result,l_ede01
               DISPLAY l_ede01 TO ede01 
               IF (NOT li_result) THEN
                  NEXT FIELD ede01
               END IF
            END IF
          AFTER FIELD ede02
             IF NOT cl_null(l_ede02) THEN
                SELECT azn02,azn04 FROM azn_file
                 WHERE azn01 = l_ede02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","azn_file",l_ede02,"","mfg0027","","",1) 
                   LET l_ede02 = l_ede02_t
                   DISPLAY l_ede02 TO ede02 
                   NEXT FIELD ede02 
                END IF
             END IF

            BEGIN WORK
            CALL s_auto_assign_no("asf",l_ede01,l_ede02,"W","ede_file","ede01","","","") RETURNING li_result,l_ede01
            IF (NOT li_result) THEN
               NEXT FIELD ede01 
            END IF
            DISPLAY l_ede01 TO ede01
 
             ON ACTION controlp
                 CASE WHEN INFIELD(ede01)
                           LET g_t1 = s_get_doc_no(l_ede01)    
                           CALL q_smy(FALSE,TRUE,g_t1,'ASF','W') RETURNING g_t1 
                           LET l_ede01=g_t1   
                           DISPLAY l_ede01 TO ede01 
                           NEXT FIELD ede01
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
        LET INT_FLAG = 0
        ROLLBACK WORK
        DISPLAY BY NAME g_ede.ede01
        RETURN
    END IF
    DROP TABLE y

    SELECT * FROM ede_file         #單頭複製
     WHERE ede01=l_ede01_t
     INTO TEMP y

    UPDATE y
        SET ede01=l_ede01,  
            ede02=l_ede02,    
            edeuser=g_user,   
            edegrup=g_grup,   
            edeoriu=g_user,  
            edeorig=g_grup,  
            edemodu=NULL,     
            ededate=NULL,     
            edeplant=g_plant, 
            edelegal=g_legal,
            edeconf='N',
            edeacti='Y'        
    INSERT INTO ede_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ede_file",l_ede01,"",SQLCA.sqlcode,"","",1)  
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
    SELECT * FROM edf_file         #單身複製
        WHERE edf01=l_ede01_t
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","edf_file",l_ede01_t,"",SQLCA.sqlcode,"","",1)  
        RETURN
    END IF
    UPDATE x
      SET edf01 = l_ede01,
          edflegal = g_legal,
          edfplant = g_plant
    INSERT INTO edf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","edf_file",g_ede.ede01,"",SQLCA.sqlcode,"","",1) 
        RETURN
    END IF
    CALL t711_b()
    #SELECT ede_file.* INTO g_ede.* FROM ede_file #FUN-C80046
    #               WHERE ede01 = l_ede01_t       #FUN-C80046
    #CALL t711_show()                             #FUN-C80046
    DISPLAY BY NAME g_ede.ede01
END FUNCTION

FUNCTION t711_g()
DEFINE p_row,p_col     LIKE type_file.num5        
  
   IF g_ede.ede01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ede.edeconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_ede.edeconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW t711_q_w AT p_row,p_col WITH FORM "asf/42f/asft711_q"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
  
   CALL cl_ui_locale("asft711_q")
       
   CALL t711_g1()
  
   CLOSE WINDOW t711_q_w 
   
   CALL t711_b_fill(' 1=1')
   CALL t711_b()
END FUNCTION

FUNCTION t711_g1()
DEFINE l_sfb       RECORD LIKE sfb_file.*
DEFINE l_edf       RECORD LIKE edf_file.*
DEFINE l_n         LIKE type_file.num5
DEFINE l_ecm03     LIKE ecm_file.ecm03
DEFINE l_ecm04     LIKE ecm_file.ecm04
DEFINE l_ecm13     LIKE ecm_file.ecm13
DEFINE l_ecm012    LIKE ecm_file.ecm012
DEFINE l_edf02     LIKE edf_file.edf02
DEFINE l_sql       STRING
DEFINE i           LIKE type_file.num5
DEFINE lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_ecm15     LIKE ecm_file.ecm15   #FUN-B10054

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM edf_file
    WHERE edf01 = g_ede.ede01
   IF l_n > 0 THEN
      IF cl_delb(20,16) THEN
         MESSAGE "Delete edf!"
         DELETE FROM edf_file WHERE edf01 = g_ede.ede01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","edf_file",g_ede.ede01,"",STATUS,"","del edf",1)  
            ROLLBACK WORK RETURN
         END IF
      END IF
   END IF
   
   INITIALIZE l_sfb.* TO NULL   
   CONSTRUCT BY NAME g_wc ON
                sfb01,sfb81,sfb98 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION controlp
         CASE WHEN INFIELD(sfb01)
                   CALL cl_init_qry_var()    
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     ="q_sfb2402"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfb01 
                   NEXT FIELD sfb01 
              WHEN INFIELD(sfb98)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   IF g_aaz.aaz90='Y' THEN  
                     LET g_qryparam.form = "q_gem4"  
                   ELSE
                     LET g_qryparam.form = "q_gem"
                   END IF
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfb98   
                   NEXT FIELD sfb98
              OTHERWISE EXIT CASE
         END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT

   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  

   LET l_sql = NULL
   LET l_sql="SELECT * FROM sfb_file ",    
             " WHERE ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR ",         
             "       (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2')) ",    
             "   AND (sfb28 < '2' OR sfb28 IS NULL) ",
             "   AND sfb87!='X' ",
             "   AND ",g_wc CLIPPED
   PREPARE t711g_p FROM l_sql
   DECLARE t711_g CURSOR FOR t711g_p
   LET i   = 1
   CALL cl_msg("Waiting...")
   FOREACH t711_g INTO l_sfb.*
     LET l_sql = NULL
     LET l_sql = "SELECT ecm03,ecm04,ecm012,ecm13,ecm15 ",  #FUN-B10054 
                 "  FROM ecm_file ",
                 " WHERE ecm01 = '",l_sfb.sfb01,"'"
     PREPARE t711g_ecm FROM l_sql
     DECLARE t711_g_e CURSOR FOR t711g_ecm
     FOREACH t711_g_e INTO l_ecm03,l_ecm04,l_ecm012,l_ecm13,l_ecm15   #FUN-B10054
        LET l_edf.edf01 = g_ede.ede01
        LET l_edf.edf03 = l_sfb.sfb01
        LET l_edf.edf04 = l_sfb.sfb05
        LET l_edf.edf05 = l_sfb.sfb09
        LET l_edf.edf08 = l_sfb.sfb09
        LET l_edf.edf09 = NULL 
        IF cl_null(l_ecm03) THEN LET l_ecm03 = ' ' END IF
        IF cl_null(l_ecm04) THEN LET l_ecm04 = ' ' END IF
        IF cl_null(l_ecm012) THEN LET l_ecm012 = ' ' END IF
        IF cl_null(l_ecm13) THEN LET l_ecm13 = 0 END IF
        LET l_edf.edf06 = l_ecm04
        LET l_edf.edf07 = l_ecm03
        LET l_edf.edf012 = l_ecm012
        LET l_edf.edf10 = l_ecm13
        LET l_edf.edf11 = l_ecm13
        LET l_edf.edf12 = l_edf.edf11 * l_edf.edf08
        LET l_edf.edf13 = l_ecm15  #FUN-B10054
        LET l_edf.edf14 = l_ecm15  #FUN-B10054
        LET l_edf.edf15 = l_edf.edf14 * l_edf.edf08  #FUN-B10054
        
        SELECT MAX(edf02) INTO l_edf02 FROM edf_file
         WHERE edf01 = g_ede.ede01
        IF cl_null(l_edf02) THEN LET l_edf02 = 0 END IF
        LET l_edf.edf02 = l_edf02 + 1
        INSERT INTO edf_file VALUES (l_edf.*)
     END FOREACH
   END FOREACH
END FUNCTION
#FUN-A90056
