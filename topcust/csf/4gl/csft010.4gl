# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csft010.4gl
# Descriptions...: 簽核等級
# Date & Author..: 16/05/11 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_sfa           RECORD LIKE tc_sfa_file.*,       
    g_tc_sfa_t         RECORD LIKE tc_sfa_file.*,       
    g_tc_sfa_o         RECORD LIKE tc_sfa_file.*,       
    g_tc_sfa01_t       LIKE tc_sfa_file.tc_sfa01, 
    #str---add by guanyao160615
    g_sfb           DYNAMIC ARRAY OF RECORD    
        sel            LIKE type_file.chr1,
        sfb05          LIKE sfb_file.sfb05,   
        ecm04          LIKE ecm_file.ecm04,   
        ecm45          LIKE ecm_file.ecm45,   
        wipqty         LIKE type_file.num15_3,
        llbg           LIKE type_file.num15_3,
        pcl            LIKE type_file.num15_3 
                    END RECORD, 
    g_sfb_t            RECORD    
        sel            LIKE type_file.chr1,
        sfb05          LIKE sfb_file.sfb05,   
        ecm04          LIKE ecm_file.ecm04,   
        ecm45          LIKE ecm_file.ecm45,   
        wipqty         LIKE type_file.num15_3,
        llbg           LIKE type_file.num15_3,
        pcl            LIKE type_file.num15_3 
                   END RECORD, 
    #end----add by guanhyao160615
    # g_sfb           DYNAMIC ARRAY OF RECORD    
    #    sel            LIKE type_file.chr1,   
    #    sfb01          LIKE sfb_file.sfb01, 
    #    ecm03          LIKE ecm_file.ecm03,  
    #    sfb06          LIKE sfb_file.sfb06,  
    #    ecu03          LIKE ecu_file.ecu03,  
    #    ecm06          LIKE ecm_file.ecm06,  
    #    wipqty         LIKE type_file.num15_3
    #                END RECORD, 
    #g_sfb_t            RECORD
    #    sel            LIKE type_file.chr1,   
    #    sfb01          LIKE sfb_file.sfb01, 
    #    ecm03          LIKE ecm_file.ecm03,  
    #    sfb06          LIKE sfb_file.sfb06,  
    #    ecu03          LIKE ecu_file.ecu03,  
    #    ecm06          LIKE ecm_file.ecm06,  
    #    wipqty         LIKE type_file.num15_3
    #                END RECORD, 
    g_tc_sfb           DYNAMIC ARRAY OF RECORD    
        tc_sfb02       LIKE tc_sfb_file.tc_sfb02,  
        tc_sfbud04     LIKE tc_sfb_file.tc_sfbud04,   #add  by guanyao160615
        tc_sfb03       LIKE tc_sfb_file.tc_sfb03,  
        tc_sfbud02     LIKE tc_sfb_file.tc_sfbud02,   #add  by guanyao160615
        tc_sfb04       LIKE tc_sfb_file.tc_sfb04,
        tc_sfb05       LIKE tc_sfb_file.tc_sfb05,
        tc_sfb06       LIKE tc_sfb_file.tc_sfb06,
        tc_sfbud05     LIKE tc_sfb_file.tc_sfbud05,    #add  by guanyao160615
        tc_sfbud06     LIKE tc_sfb_file.tc_sfbud06,    #add  by guanyao160615
        tc_sfbud07     LIKE tc_sfb_file.tc_sfbud07,    #add  by guanyao160615
        tc_sfbud08     LIKE tc_sfb_file.tc_sfbud08,    #add  by guanyao160615
        tc_sfb07       LIKE tc_sfb_file.tc_sfb07,
        tc_sfb08       LIKE tc_sfb_file.tc_sfb08,
        tc_sfbud03     LIKE tc_sfb_file.tc_sfbud03,    #add  by guanyao160615
        tc_sfbud01     LIKE tc_sfb_file.tc_sfbud01,
        #tc_sfbud02     LIKE tc_sfb_file.tc_sfbud02,  #mark  by guanyao160615
        #tc_sfbud03     LIKE tc_sfb_file.tc_sfbud03,  #mark  by guanyao160615
        #tc_sfbud04     LIKE tc_sfb_file.tc_sfbud04,  #mark  by guanyao160615
        #tc_sfbud05     LIKE tc_sfb_file.tc_sfbud05,  #mark  by guanyao160615
        #tc_sfbud06     LIKE tc_sfb_file.tc_sfbud06,  #mark  by guanyao160615
        #tc_sfbud07     LIKE tc_sfb_file.tc_sfbud07,  #mark  by guanyao160615
        #tc_sfbud08     LIKE tc_sfb_file.tc_sfbud08,  #mark  by guanyao160615
        tc_sfbud09     LIKE tc_sfb_file.tc_sfbud09,
        tc_sfbud10     LIKE tc_sfb_file.tc_sfbud10,
        tc_sfbud11     LIKE tc_sfb_file.tc_sfbud11,
        tc_sfbud12     LIKE tc_sfb_file.tc_sfbud12,
        tc_sfbud13     LIKE tc_sfb_file.tc_sfbud13,
        tc_sfbud14     LIKE tc_sfb_file.tc_sfbud14,
        tc_sfbud15     LIKE tc_sfb_file.tc_sfbud15
                    END RECORD,
    g_tc_sfb_t         RECORD                 
        tc_sfb02       LIKE tc_sfb_file.tc_sfb02,  
        tc_sfbud04     LIKE tc_sfb_file.tc_sfbud04,   #add  by guanyao160615
        tc_sfb03       LIKE tc_sfb_file.tc_sfb03,  
        tc_sfbud02     LIKE tc_sfb_file.tc_sfbud02,   #add  by guanyao160615
        tc_sfb04       LIKE tc_sfb_file.tc_sfb04,
        tc_sfb05       LIKE tc_sfb_file.tc_sfb05,
        tc_sfb06       LIKE tc_sfb_file.tc_sfb06,
        tc_sfbud05     LIKE tc_sfb_file.tc_sfbud05,    #add  by guanyao160615
        tc_sfbud06     LIKE tc_sfb_file.tc_sfbud06,    #add  by guanyao160615
        tc_sfbud07     LIKE tc_sfb_file.tc_sfbud07,    #add  by guanyao160615
        tc_sfbud08     LIKE tc_sfb_file.tc_sfbud08,    #add  by guanyao160615
        tc_sfb07       LIKE tc_sfb_file.tc_sfb07,
        tc_sfb08       LIKE tc_sfb_file.tc_sfb08,
        tc_sfbud03     LIKE tc_sfb_file.tc_sfbud03,    #add  by guanyao160615
        tc_sfbud01     LIKE tc_sfb_file.tc_sfbud01,
        #tc_sfbud02     LIKE tc_sfb_file.tc_sfbud02,  #mark  by guanyao160615
        #tc_sfbud03     LIKE tc_sfb_file.tc_sfbud03,  #mark  by guanyao160615
        #tc_sfbud04     LIKE tc_sfb_file.tc_sfbud04,  #mark  by guanyao160615
        #tc_sfbud05     LIKE tc_sfb_file.tc_sfbud05,  #mark  by guanyao160615
        #tc_sfbud06     LIKE tc_sfb_file.tc_sfbud06,  #mark  by guanyao160615
        #tc_sfbud07     LIKE tc_sfb_file.tc_sfbud07,  #mark  by guanyao160615
        #tc_sfbud08     LIKE tc_sfb_file.tc_sfbud08,  #mark  by guanyao160615
        tc_sfbud09     LIKE tc_sfb_file.tc_sfbud09,
        tc_sfbud10     LIKE tc_sfb_file.tc_sfbud10,
        tc_sfbud11     LIKE tc_sfb_file.tc_sfbud11,
        tc_sfbud12     LIKE tc_sfb_file.tc_sfbud12,
        tc_sfbud13     LIKE tc_sfb_file.tc_sfbud13,
        tc_sfbud14     LIKE tc_sfb_file.tc_sfbud14,
        tc_sfbud15     LIKE tc_sfb_file.tc_sfbud15
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #No.TQC-740021
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    g_rec_b1        LIKE type_file.num5,
    l_ac,l_ac1            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_str          STRING                              #No.FUN-760083 
DEFINE l_table        STRING                              #No.FUN-760083 
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL     
DEFINE g_chr          LIKE tc_sfa_file.tc_sfa04        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_cnt1         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_argv1        LIKE type_file.chr1
DEFINE g_argv2        LIKE pmn_file.pmn01
DEFINE g_argv3        LIKE pmn_file.pmn02
DEFINE g_err          LIKE type_file.chr1
DEFINE g_sfb_1        RECORD LIKE sfb_file.*
DEFINE g_sfa          RECORD LIKE sfa_file.*
DEFINE g_sfa2         RECORD LIKE sfa_file.*
DEFINE g_ima108       LIKE ima_file.ima108
DEFINE issue_type     LIKE type_file.chr1
DEFINE g_sfp01        LIKE sfp_file.sfp01
DEFINE b_sfs          RECORD LIKE sfs_file.*
DEFINE b_sfq          RECORD LIKE sfq_file.*
DEFINE issue_qty,issue_qty1,issue_qty2  LIKE sfb_file.sfb08
DEFINE g_img          RECORD LIKE img_file.*
DEFINE img_qty             LIKE sfb_file.sfb08
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
    OPEN WINDOW t010_w WITH FORM "csf/42f/csft010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
        
    CALL g_tc_sfb.clear()
 
    LET g_forupd_sql = "SELECT * FROM tc_sfa_file WHERE tc_sfa01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t010_cl CURSOR FROM g_forupd_sql
    CALL t010_table ()
    DELETE FROM t010_tmp
    CALL t010_menu()
    DROP TABLE t010_tmp
    CLOSE WINDOW t010_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION t010_cs()
 
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_sfb.clear()
   CALL g_sfb.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_tc_sfa.* TO NULL    #No.FUN-750051
 
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      tc_sfa01,tc_sfa02,tc_sfa03,tc_sfa04,tc_sfa05,tc_sfa06,
      tc_sfauser,tc_sfagrup,tc_sfamodu,tc_sfadate,
      tc_sfaud01,tc_sfaud02,tc_sfaud03,tc_sfaud04,tc_sfaud05,
      tc_sfaud06,tc_sfaud07,tc_sfaud08,tc_sfaud09,tc_sfaud10,
      tc_sfaud11,tc_sfaud12,tc_sfaud13,tc_sfaud14,tc_sfaud15
               
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_sfa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_tc_sfa.tc_sfa03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfa03
            OTHERWISE
               EXIT CASE
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_sfauser', 'tc_sfagrup')
 
   CONSTRUCT g_wc2 ON tc_sfb02,tc_sfb03,tc_sfb04,tc_sfb05,tc_sfb06,tc_sfb07,tc_sfb08,
                      tc_sfbud01,tc_sfbud02,tc_sfbud03,tc_sfbud04,tc_sfbud05,
                      tc_sfbud06,tc_sfbud07,tc_sfbud08,tc_sfbud09,tc_sfbud10,
                      tc_sfbud11,tc_sfbud12,tc_sfbud13,tc_sfbud14,tc_sfbud15
        FROM s_tc_sfb[1].tc_sfb02,s_tc_sfb[1].tc_sfb03,s_tc_sfb[1].tc_sfb04,
             s_tc_sfb[1].tc_sfb05,s_tc_sfb[1].tc_sfb06,s_tc_sfb[1].tc_sfb07,s_tc_sfb[1].tc_sfb08,
             s_tc_sfb[1].tc_sfbud01,s_tc_sfb[1].tc_sfbud02,s_tc_sfb[1].tc_sfbud03,
             s_tc_sfb[1].tc_sfbud04,s_tc_sfb[1].tc_sfbud05,s_tc_sfb[1].tc_sfbud06,
             s_tc_sfb[1].tc_sfbud07,s_tc_sfb[1].tc_sfbud08,s_tc_sfb[1].tc_sfbud09,
             s_tc_sfb[1].tc_sfbud10,s_tc_sfb[1].tc_sfbud11,s_tc_sfb[1].tc_sfbud12,
             s_tc_sfb[1].tc_sfbud13,s_tc_sfb[1].tc_sfbud14,s_tc_sfb[1].tc_sfbud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
        # CASE
        #    WHEN INFIELD(tc_sfb03)
        #       CALL cl_init_qry_var()
        #       LET g_qryparam.form = "q_gen"
        #       LET g_qryparam.state = "c"
        #       CALL cl_create_qry() RETURNING g_qryparam.multiret
        #       DISPLAY g_qryparam.multiret TO tc_sfb03
        # END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN		
      LET g_sql = "SELECT  tc_sfa01 FROM tc_sfa_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_sfa01"
   ELSE					
      LET g_sql = "SELECT UNIQUE  tc_sfa01 ",
                  "  FROM tc_sfa_file LEFT OUTER JOIN tc_sfb_file ON tc_sfa01=tc_sfb01",
                  "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_sfa01"
   END IF
 
   PREPARE t010_prepare FROM g_sql
   DECLARE t010_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t010_prepare
 
   IF g_wc2 = " 1=1" THEN		
       LET g_sql="SELECT COUNT(*) FROM tc_sfa_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT tc_sfa01) FROM tc_sfa_file,tc_sfb_file WHERE ",
                 "tc_sfb01=tc_sfa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t010_precount FROM g_sql
   DECLARE t010_count CURSOR FOR t010_precount
   OPEN t010_count
   FETCH t010_count INTO g_row_count
   CLOSE t010_count
 
END FUNCTION
 
 
 
FUNCTION t010_menu()
 
   WHILE TRUE
      CALL t010_bp("G")
      CASE g_ACTION_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t010_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t010_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t010_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t010_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL t010_x()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t010_confirm()
            END IF
          WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t010_undo_confirm()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t010_b()
            ELSE
               LET g_ACTION_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_tc_sfa.tc_sfa01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_sfa01"
                  LET g_doc.value1 = g_tc_sfa.tc_sfa01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sfb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t010_a()
DEFINE l_y       LIKE type_file.chr20 
DEFINE l_m       LIKE type_file.chr20
DEFINE l_str       LIKE type_file.chr20
DEFINE l_tmp       LIKE type_file.chr20 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_sfb.clear()
    INITIALIZE g_tc_sfa.* LIKE tc_sfa_file.*             #DEFAULT 設定
    LET g_tc_sfa01_t = NULL
    LET g_tc_sfa_o.* = g_tc_sfa.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tc_sfa.tc_sfa02=g_today
        LET g_tc_sfa.tc_sfauser=g_user
        LET g_tc_sfa.tc_sfagrup=g_grup
        LET g_tc_sfa.tc_sfadate=g_today
        LET g_tc_sfa.tc_sfa04 = 'N'
        
        LET l_y =YEAR(g_today)
        LET l_y = l_y[3,4] USING '&&' 
        LET l_m =MONTH(g_today)
        LET l_m = l_m USING '&&' 
        LET l_str='FLY-',l_y clipped,l_m CLIPPED
        SELECT max(substr(tc_sfa01,9,12)) INTO l_tmp FROM tc_sfa_file
         WHERE substr(tc_sfa01,1,8)=l_str
        IF cl_null(l_tmp) THEN 
           LET l_tmp = '0001' 
        ELSE 
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&'     
        END IF 
        LET g_tc_sfa.tc_sfa01 = l_str clipped,l_tmp
        
        CALL t010_i("a")                
        IF INT_FLAG THEN                   
            INITIALIZE g_tc_sfa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tc_sfa.tc_sfa01 IS NULL THEN          
            CONTINUE WHILE
        END IF
        LET g_tc_sfa.tc_sfaplant = g_plant
        LET g_tc_sfa.tc_sfalegal = g_legal
        INSERT INTO tc_sfa_file VALUES (g_tc_sfa.*)
        IF SQLCA.sqlcode THEN   
            CALL cl_err3("ins","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT tc_sfa01 INTO g_tc_sfa.tc_sfa01 FROM tc_sfa_file
            WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
        LET g_tc_sfa01_t = g_tc_sfa.tc_sfa01        #保留舊值
        LET g_tc_sfa_t.* = g_tc_sfa.*
 
        CALL g_tc_sfb.clear()
        LET g_rec_b = 0
        CALL t010_b1_fill()
        IF g_rec_b1> 0 THEN 
           CALL t010_d() 
           CALL t010_b_fill(' 1=1')
           CALL t010_b()
        END IF            
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t010_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01=g_tc_sfa.tc_sfa01
    IF g_tc_sfa.tc_sfa04 ='Y' THEN    
       CALL cl_err(g_tc_sfa.tc_sfa01,9027,0)
       RETURN
    END IF
    IF g_tc_sfa.tc_sfa04 ='X' THEN    
       CALL cl_err(g_tc_sfa.tc_sfa01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_sfa01_t = g_tc_sfa.tc_sfa01
    LET g_tc_sfa_o.* = g_tc_sfa.*
    BEGIN WORK
 
    OPEN t010_cl USING g_tc_sfa.tc_sfa01
    IF STATUS THEN
       CALL cl_err("OPEN t010_cl:", STATUS, 1)
       CLOSE t010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t010_cl INTO g_tc_sfa.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE t010_cl ROLLBACK WORK RETURN
    END IF
    CALL t010_show()
    WHILE TRUE
        LET g_tc_sfa01_t = g_tc_sfa.tc_sfa01
        LET g_tc_sfa.tc_sfamodu=g_user
        LET g_tc_sfa.tc_sfadate=g_today
        CALL t010_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_sfa.*=g_tc_sfa_t.*
            CALL t010_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tc_sfa.tc_sfa01 != g_tc_sfa01_t THEN            # 更改單號
            UPDATE tc_sfb_file SET tc_sfb01 = g_tc_sfa.tc_sfa01
                WHERE tc_sfb01 = g_tc_sfa01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('tc_sfb',SQLCA.sqlcode,0)    #No.FUN-660131
                CALL cl_err3("upd","tc_sfb_file",g_tc_sfa01_t,"",SQLCA.sqlcode,"","tc_sfb",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        UPDATE tc_sfa_file SET tc_sfa_file.* = g_tc_sfa.*
            WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t010_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5                         #No.FUN-680102 SMALLINT
   DEFINE l_x        LIKE type_file.num5
   DEFINE l_pmc03    LIKE pmc_file.pmc03
   DEFINE l_gen02    LIKE gen_file.gen02
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030

   DISPLAY BY NAME 
      g_tc_sfa.tc_sfa01,g_tc_sfa.tc_sfauser,g_tc_sfa.tc_sfagrup,g_tc_sfa.tc_sfamodu,g_tc_sfa.tc_sfadate,
      g_tc_sfa.tc_sfa04
       
   INPUT BY NAME 
      g_tc_sfa.tc_sfa02,g_tc_sfa.tc_sfa03,g_tc_sfa.tc_sfa05,g_tc_sfa.tc_sfa06,
      g_tc_sfa.tc_sfauser,g_tc_sfa.tc_sfagrup,g_tc_sfa.tc_sfamodu,g_tc_sfa.tc_sfadate,
      g_tc_sfa.tc_sfaud01,g_tc_sfa.tc_sfaud02,g_tc_sfa.tc_sfaud03,g_tc_sfa.tc_sfaud04,
      g_tc_sfa.tc_sfaud05,g_tc_sfa.tc_sfaud06,g_tc_sfa.tc_sfaud07,g_tc_sfa.tc_sfaud08,
      g_tc_sfa.tc_sfaud09,g_tc_sfa.tc_sfaud10,g_tc_sfa.tc_sfaud11,g_tc_sfa.tc_sfaud12,
      g_tc_sfa.tc_sfaud13,g_tc_sfa.tc_sfaud14,g_tc_sfa.tc_sfaud15
      WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t010_set_entry(p_cmd)
         CALL t010_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD tc_sfa03
         IF NOT cl_null(g_tc_sfa.tc_sfa03) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM gen_file 
             WHERE gen01 = g_tc_sfa.tc_sfa03 
               AND genacti = 'Y' 
            IF cl_null(l_x) OR l_x = 0 THEN 
                CALL cl_err('',g_errno,0)
                NEXT FIELD tc_sfa03
            END IF
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_sfa.tc_sfa03
            DISPLAY l_gen02 TO gen02
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_tc_sfa.tc_sfauser = s_get_data_owner("tc_sfa_file") #FUN-C10039
         LET g_tc_sfa.tc_sfagrup = s_get_data_group("tc_sfa_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_sfa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_tc_sfa.tc_sfa03
               CALL cl_create_qry() RETURNING g_tc_sfa.tc_sfa03
               DISPLAY BY NAME g_tc_sfa.tc_sfa03
               NEXT FIELD tc_sfa03
            OTHERWISE
                    EXIT CASE
            END CASE  
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
 
FUNCTION t010_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tc_sfa03,tc_sfa04",TRUE)
      END IF
END FUNCTION
 
FUNCTION t010_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tc_sfa03,tc_sfa04",FALSE)
      END IF
 
END FUNCTION

FUNCTION t010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    INITIALIZE g_tc_sfa.* TO NULL                #FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tc_sfb.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t010_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN t010_count
    FETCH t010_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
 
    OPEN t010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfa.* TO NULL
    ELSE
        CALL t010_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t010_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t010_cs INTO g_tc_sfa.tc_sfa01
        WHEN 'P' FETCH PREVIOUS t010_cs INTO g_tc_sfa.tc_sfa01
        WHEN 'F' FETCH FIRST    t010_cs INTO g_tc_sfa.tc_sfa01
        WHEN 'L' FETCH LAST     t010_cs INTO g_tc_sfa.tc_sfa01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            FETCH ABSOLUTE g_jump t010_cs INTO g_tc_sfa.tc_sfa01 --改g_jump
            LET g_no_ask = FALSE
 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfa.* TO NULL  #TQC-6B0105
        LET g_tc_sfa.tc_sfa01 = NULL      #TQC-6B0105
        RETURN
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF

    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_tc_sfa.* TO NULL
        RETURN
    ELSE                                   
       LET g_data_owner=g_tc_sfa.tc_sfauser       
       LET g_data_group=g_tc_sfa.tc_sfagrup
    END IF
 
    CALL t010_show()
END FUNCTION
 
FUNCTION t010_show()
    DEFINE l_pmc03    LIKE pmc_file.pmc03
    DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680102 SMALLINT
    DEFINE l_gen02    LIKE gen_file.gen02          
    DEFINE l_gen02_1  LIKE gen_file.gen02 
    LET g_tc_sfa_t.* = g_tc_sfa.*                      #保存單頭舊值
    DISPLAY BY NAME                               
        g_tc_sfa.tc_sfa01,g_tc_sfa.tc_sfa02,g_tc_sfa.tc_sfa03,
        g_tc_sfa.tc_sfa04,g_tc_sfa.tc_sfa05,g_tc_sfa.tc_sfa06,
        g_tc_sfa.tc_sfauser,g_tc_sfa.tc_sfagrup,g_tc_sfa.tc_sfamodu,
        g_tc_sfa.tc_sfadate,
        g_tc_sfa.tc_sfaud01,g_tc_sfa.tc_sfaud02,g_tc_sfa.tc_sfaud03,g_tc_sfa.tc_sfaud04,
        g_tc_sfa.tc_sfaud05,g_tc_sfa.tc_sfaud06,g_tc_sfa.tc_sfaud07,g_tc_sfa.tc_sfaud08,
        g_tc_sfa.tc_sfaud09,g_tc_sfa.tc_sfaud10,g_tc_sfa.tc_sfaud11,g_tc_sfa.tc_sfaud12,
        g_tc_sfa.tc_sfaud13,g_tc_sfa.tc_sfaud14,g_tc_sfa.tc_sfaud15 
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_sfa.tc_sfa03
    DISPLAY l_gen02 TO gen02
    SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=g_tc_sfa.tc_sfa05
    DISPLAY l_gen02_1 TO gen02_1
    CALL t010_b_fill(g_wc2)                
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t010_r()
DEFINE l_x   LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
    IF g_tc_sfa.tc_sfa04 = 'Y' THEN 
       CALL cl_err('','9023',0)
       RETURN 
    END IF
    IF g_tc_sfa.tc_sfa04 = 'X' THEN 
       CALL cl_err('','aom-000',0)
       RETURN 
    END IF  
    BEGIN WORK
 
    OPEN t010_cl USING g_tc_sfa.tc_sfa01
    IF STATUS THEN
       CALL cl_err("OPEN t010_cl:", STATUS, 1)
       CLOSE t010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t010_cl INTO g_tc_sfa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t010_cl ROLLBACK WORK RETURN
    END IF
    CALL t010_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tc_sfa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tc_sfa.tc_sfa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM tc_sfa_file WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
         DELETE FROM tc_sfb_file WHERE tc_sfb01 = g_tc_sfa.tc_sfa01
         INITIALIZE g_tc_sfa.* TO NULL
         CLEAR FORM
         CALL g_tc_sfb.clear()
 
         OPEN t010_count
         IF STATUS THEN
            CLOSE t010_cs
            CLOSE t010_count
            COMMIT WORK
            RETURN
         END IF
         FETCH t010_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t010_cs
            CLOSE t010_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t010_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t010_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t010_fetch('/')
         END IF
 
    END IF
    CLOSE t010_cl
    COMMIT WORK
END FUNCTION

FUNCTION t010_x()
DEFINE l_tc_sfa04    LIKE tc_sfa_file.tc_sfa04
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_tc_sfa.tc_sfa04 ='Y' THEN    
       CALL cl_err(g_tc_sfa.tc_sfa01,9027,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t010_cl USING g_tc_sfa.tc_sfa01
    IF STATUS THEN
       CALL cl_err("OPEN t010_cl:", STATUS, 1)
       CLOSE t010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t010_cl INTO g_tc_sfa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t010_cl ROLLBACK WORK RETURN
    END IF
    CALL t010_show()
    IF g_tc_sfa.tc_sfa04 = 'X' THEN 
       LET l_tc_sfa04 = 'N' 
    ELSE 
       LET l_tc_sfa04 = 'Y'
    END IF 
    IF cl_exp(0,0,l_tc_sfa04) THEN                   #確認一下
        LET g_chr=g_tc_sfa.tc_sfa04
        IF g_tc_sfa.tc_sfa04='N' THEN
            LET g_tc_sfa.tc_sfa04='X'
        ELSE
            LET g_tc_sfa.tc_sfa04='N'
        END IF
        UPDATE tc_sfa_file                   
            SET tc_sfa04=g_tc_sfa.tc_sfa04
            WHERE tc_sfa01=g_tc_sfa.tc_sfa01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_tc_sfa.tc_sfa04=g_chr
        END IF
        DISPLAY BY NAME g_tc_sfa.tc_sfa04 
    END IF
    CLOSE t010_cl
    COMMIT WORK
END FUNCTION

FUNCTION t010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)              #可刪除否

    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    LET g_ACTION_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = FALSE 
    LET l_allow_delete = FALSE 
 
    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01=g_tc_sfa.tc_sfa01
    IF g_tc_sfa.tc_sfa04 ='X' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_sfa.tc_sfa01,'aom-000',0)
       RETURN
    END IF
    IF g_tc_sfa.tc_sfa04 = 'Y' THEN 
       CALL cl_err(g_tc_sfa.tc_sfa01,'9023',0)
       RETURN
    END IF 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_sfb02,tc_sfbud04,tc_sfb03,tc_sfbud02,tc_sfb04,tc_sfb05,",
                       "       tc_sfb06,tc_sfbud05,tc_sfbud06,tc_sfbud07,tc_sfbud08,",
                       "       tc_sfb07,tc_sfb08,tc_sfbud01,tc_sfbud03,",
                       "       tc_sfbud09,tc_sfbud10,tc_sfbud11,tc_sfbud12,tc_sfbud13,",
                       "       tc_sfbud14,tc_sfbud15",
                       "  FROM tc_sfb_file ",
                       " WHERE tc_sfb01=? AND tc_sfb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_sfb WITHOUT DEFAULTS FROM s_tc_sfb.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'          
 
            BEGIN WORK
            OPEN t010_cl USING g_tc_sfa.tc_sfa01
            IF STATUS THEN
               CALL cl_err("OPEN t010_cl:", STATUS, 1)
               CLOSE t010_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t010_cl INTO g_tc_sfa.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t010_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_tc_sfb_t.* = g_tc_sfb[l_ac].*  #BACKUP
                OPEN t010_bcl USING g_tc_sfa.tc_sfa01,g_tc_sfb_t.tc_sfb02
                IF STATUS THEN
                   CALL cl_err("OPEN t010_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t010_bcl INTO g_tc_sfb[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_tc_sfb_t.tc_sfb02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_tc_sfb[l_ac].* TO NULL      #900423
            LET g_tc_sfb_t.* = g_tc_sfb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_sfb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO tc_sfb_file
                         VALUES(g_tc_sfa.tc_sfa01,g_tc_sfb[l_ac].tc_sfb02,g_tc_sfb[l_ac].tc_sfb03,
                                g_tc_sfb[l_ac].tc_sfb04,g_tc_sfb[l_ac].tc_sfb05,g_tc_sfb[l_ac].tc_sfb06,
                                g_tc_sfb[l_ac].tc_sfb07,g_tc_sfb[l_ac].tc_sfb08,g_tc_sfb[l_ac].tc_sfbud01,
                                g_tc_sfb[l_ac].tc_sfbud02,g_tc_sfb[l_ac].tc_sfbud03,g_tc_sfb[l_ac].tc_sfbud04,
                                g_tc_sfb[l_ac].tc_sfbud05,g_tc_sfb[l_ac].tc_sfbud06,g_tc_sfb[l_ac].tc_sfbud07,
                                g_tc_sfb[l_ac].tc_sfbud08,g_tc_sfb[l_ac].tc_sfbud09,g_tc_sfb[l_ac].tc_sfbud10,
                                g_tc_sfb[l_ac].tc_sfbud11,g_tc_sfb[l_ac].tc_sfbud12,g_tc_sfb[l_ac].tc_sfbud13,
                                g_tc_sfb[l_ac].tc_sfbud14,g_tc_sfb[l_ac].tc_sfbud15)
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_sfb_file",g_tc_sfb[l_ac].tc_sfb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD tc_sfb02                        #default 序號
            IF g_tc_sfb[l_ac].tc_sfb02 IS NULL OR
               g_tc_sfb[l_ac].tc_sfb02 = 0 THEN
                 SELECT max(tc_sfb02)+1               #MOD-540144
                   INTO g_tc_sfb[l_ac].tc_sfb02
                   FROM tc_sfb_file
                   WHERE tc_sfb01 = g_tc_sfa.tc_sfa01
                IF g_tc_sfb[l_ac].tc_sfb02 IS NULL THEN
                    LET g_tc_sfb[l_ac].tc_sfb02 = 1
                END IF
            END IF
 
        AFTER FIELD tc_sfb02                        #check 序號是否重複
            IF NOT cl_null(g_tc_sfb[l_ac].tc_sfb02) THEN
               IF g_tc_sfb[l_ac].tc_sfb02 != g_tc_sfb_t.tc_sfb02 OR
                  g_tc_sfb_t.tc_sfb02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tc_sfb_file
                    WHERE tc_sfb01 = g_tc_sfa.tc_sfa01 AND
                          tc_sfb02 = g_tc_sfb[l_ac].tc_sfb02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_tc_sfb[l_ac].tc_sfb02 = g_tc_sfb_t.tc_sfb02
                      NEXT FIELD tc_sfb02
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_sfb_t.tc_sfb02 > 0 AND
               g_tc_sfb_t.tc_sfb02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM tc_sfb_file
                WHERE tc_sfb01 = g_tc_sfa.tc_sfa01 AND
                      tc_sfb02 = g_tc_sfb_t.tc_sfb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tc_sfb_file",g_tc_sfb_t.tc_sfb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete Ok"
               CLOSE t010_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_sfb[l_ac].* = g_tc_sfb_t.*
               CLOSE t010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_sfb[l_ac].tc_sfb02,-263,1)
               LET g_tc_sfb[l_ac].* = g_tc_sfb_t.*
            ELSE
               UPDATE tc_sfb_file SET tc_sfb08=g_tc_sfb[l_ac].tc_sfb08 
                WHERE tc_sfb01=g_tc_sfa.tc_sfa01 
                  AND tc_sfb02=g_tc_sfb_t.tc_sfb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_sfb_file",g_tc_sfb[l_ac].tc_sfb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_tc_sfb[l_ac].* = g_tc_sfb_t.*
                  CLOSE t010_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t010_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_sfb[l_ac].* = g_tc_sfb_t.*
               ELSE
                  CALL g_tc_sfb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_ACTION_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF

               END IF
               CLOSE t010_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac                #FUN-D40030 Add
           CLOSE t010_bcl
           COMMIT WORK
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(tc_sfb03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_tc_sfb[l_ac].tc_sfb03
                     CALL cl_create_qry() RETURNING g_tc_sfb[l_ac].tc_sfb03
                     DISPLAY BY NAME g_tc_sfb[l_ac].tc_sfb03
                     NEXT FIELD tc_sfb03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_sfb02) AND l_ac > 1 THEN
               LET g_tc_sfb[l_ac].* = g_tc_sfb[l_ac-1].*
               SELECT max(tc_sfb02)+1 INTO g_tc_sfb[l_ac].tc_sfb02 FROM tc_sfb_file
                WHERE tc_sfb01 = g_tc_sfa.tc_sfa01
               DISPLAY BY NAME g_tc_sfb[l_ac].tc_sfb02, g_tc_sfb[l_ac].tc_sfb03
               NEXT FIELD tc_sfb02
            END IF
 
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END INPUT
 
    LET g_tc_sfa.tc_sfamodu = g_user
    LET g_tc_sfa.tc_sfadate = g_today
    UPDATE tc_sfa_file SET tc_sfamodu = g_tc_sfa.tc_sfamodu,tc_sfadate = g_tc_sfa.tc_sfadate
     WHERE tc_sfa01 = g_tc_sfa.tc_sfa01
    DISPLAY BY NAME g_tc_sfa.tc_sfamodu,g_tc_sfa.tc_sfadate
 
    CLOSE t010_bcl
    CLOSE t010_cl
    COMMIT WORK
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
END FUNCTION
 
FUNCTION t010_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2          STRING       #No.FUN-680102CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 =" 1=1"  END IF #MOD-8A0032
    LET g_sql =
        "SELECT tc_sfb02,tc_sfbud04,tc_sfb03,tc_sfbud02,tc_sfb04,tc_sfb05,tc_sfb06,tc_sfbud05,",
        "       tc_sfbud06,tc_sfbud07,tc_sfbud08,tc_sfb07,tc_sfb08,tc_sfbud03,tc_sfbud01,",
        "       tc_sfbud09,tc_sfbud10,tc_sfbud11,tc_sfbud12,tc_sfbud13,tc_sfbud14,tc_sfbud15",
        " FROM tc_sfb_file",
        " WHERE tc_sfb01 ='",g_tc_sfa.tc_sfa01,"' AND ",p_wc2 CLIPPED,                     
        " ORDER BY tc_sfb02"
    PREPARE t010_pb FROM g_sql
    DECLARE tc_sfb_curs                       #SCROLL CURSOR
        CURSOR FOR t010_pb
 
    CALL g_tc_sfb.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH tc_sfb_curs INTO g_tc_sfb[g_cnt].*   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_tc_sfb.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION

FUNCTION t010_confirm()
DEFINE l_gen02    LIKE gen_file.gen02
IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01= g_tc_sfa.tc_sfa01
    IF g_tc_sfa.tc_sfa04 = 'Y' THEN 
       CALL cl_err('','9023',0)
       RETURN 
    END IF 
    IF g_tc_sfa.tc_sfa04 = 'X' THEN 
       CALL cl_err('','9024',0)
       RETURN 
    END IF
    BEGIN WORK
 
    OPEN t010_cl USING g_tc_sfa.tc_sfa01
    IF STATUS THEN
       CALL cl_err("OPEN t010_cl:", STATUS, 1)
       CLOSE t010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t010_cl INTO g_tc_sfa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t010_cl ROLLBACK WORK RETURN
    END IF
    CALL t010_show()
    IF cl_confirm('axm-108') THEN                  #確認一下
       LET g_chr=g_tc_sfa.tc_sfa04
       LET g_tc_sfa.tc_sfa04 = 'Y'
       UPDATE tc_sfa_file                   
          SET tc_sfa04=g_tc_sfa.tc_sfa04,
              tc_sfa05=g_user,
              tc_sfa06= g_today 
        WHERE tc_sfa01=g_tc_sfa.tc_sfa01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
          LET g_tc_sfa.tc_sfa04=g_chr
       END IF
       CALL t010_ins_sfp()  #add by guanyao160622
       DISPLAY BY NAME g_tc_sfa.tc_sfa04
       DISPLAY BY NAME g_tc_sfa.tc_sfa05
       DISPLAY BY NAME g_tc_sfa.tc_sfa06
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_sfa.tc_sfa05
       DISPLAY l_gen02 TO gen02_1
    END IF
    CLOSE t010_cl
    COMMIT WORK

END FUNCTION 

FUNCTION t010_undo_confirm()
DEFINE l_gen02     LIKE gen_file.gen02
IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfa.tc_sfa01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfa.* FROM tc_sfa_file WHERE tc_sfa01= g_tc_sfa.tc_sfa01
    IF g_tc_sfa.tc_sfa04 = 'N' THEN 
       RETURN 
    END IF 
    IF g_tc_sfa.tc_sfa04 = 'X' THEN 
       CALL cl_err('','9024',0)
       RETURN 
    END IF
    BEGIN WORK
 
    OPEN t010_cl USING g_tc_sfa.tc_sfa01
    IF STATUS THEN
       CALL cl_err("OPEN t010_cl:", STATUS, 1)
       CLOSE t010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t010_cl INTO g_tc_sfa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t010_cl ROLLBACK WORK RETURN
    END IF
    CALL t010_show()
    IF cl_confirm('axm-109') THEN                  #確認一下
        LET g_chr=g_tc_sfa.tc_sfa04
        LET g_tc_sfa.tc_sfa04 = 'N'
        UPDATE tc_sfa_file                   
            SET tc_sfa04=g_tc_sfa.tc_sfa04,
                tc_sfa05= g_user,
                tc_sfa06= g_today
            WHERE tc_sfa01=g_tc_sfa.tc_sfa01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sfa_file",g_tc_sfa.tc_sfa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_tc_sfa.tc_sfa04=g_chr
        END IF
        DISPLAY BY NAME g_tc_sfa.tc_sfa04 
        DISPLAY BY NAME g_tc_sfa.tc_sfa05
        DISPLAY BY NAME g_tc_sfa.tc_sfa06
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_sfa.tc_sfa05
        DISPLAY l_gen02 TO gen02_1
    END IF
    CLOSE t010_cl
    COMMIT WORK

END FUNCTION 
 
FUNCTION t010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_ACTION_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_ACTION_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_tc_sfb TO s_tc_sfb.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)

     END DISPLAY 
     DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        AFTER DISPLAY
         CONTINUE DIALOG
 
     END DISPLAY
     BEFORE DIALOG 
        CALL cl_show_fld_cont()
         ON ACTION INSERT
            LET g_ACTION_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_ACTION_choice="query"
            EXIT DIALOG
         ON ACTION DELETE
            LET g_ACTION_choice="delete"
            EXIT DIALOG
         ON ACTION MODIFY
            LET g_ACTION_choice="modify"
            EXIT DIALOG
 
         ON ACTION FIRST 
            CALL t010_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
                              
         ON ACTION PREVIOUS
            CALL t010_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
	        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
                              
         ON ACTION jump 
            CALL t010_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
 	        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
                              
         ON ACTION NEXT
            CALL t010_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
	        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
                              
         ON ACTION LAST 
            CALL t010_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
	        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST 
         
         ON ACTION invalid
            LET g_ACTION_choice="invalid"
            EXIT DIALOG
         ON ACTION confirm
            LET g_ACTION_choice="confirm"
            EXIT DIALOG
         ON ACTION undo_confirm
            LET g_ACTION_choice="undo_confirm"
            EXIT DIALOG
         ON ACTION reproduce
            LET g_ACTION_choice="reproduce"
            EXIT DIALOG
 
         ON ACTION detail
            LET g_ACTION_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION OUTPUT
            LET g_ACTION_choice="output"
            EXIT DIALOG
         ON ACTION HELP
            LET g_ACTION_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT DIALOG
 
         ON ACTION EXIT
            LET g_ACTION_choice="exit"
            EXIT DIALOG
 
         ON ACTION ACCEPT
            LET g_ACTION_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_ACTION_choice="exit"
            EXIT DIALOG
 
         ON ACTION controlg 
            LET g_ACTION_choice="controlg"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
  
         ON ACTION related_document  #No.MOD-470515
            LET g_ACTION_choice="related_document"
            EXIT DIALOG
 
         ON ACTION exporttoexcel   #No.FUN-4B0020
            LET g_ACTION_choice = 'exporttoexcel'
            EXIT DIALOG
 
         ON ACTION controls                                                                                                             
            CALL cl_set_head_visible("","AUTO")                 

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION t010_b1_fill()
DEFINE l_sql   STRING  

   #LET l_sql = "select 'N',sfb01,sfb05,ecm03,sfb06,ecu03,ecm06,",   #add sfb05 by guanyao160615
   LET l_sql = "SELECT 'N',sfb05,ecm04,ecm45,",
               "       CASE ecm54 WHEN 'Y' THEN SUM(ecm291-ecm311-ecm312-ecm313-ecm314-ecm316) ",
               "                  ELSE SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316) END CASE,",
               "       0,0",
               "  FROM sfb_file,ecm_file ",
               " WHERE sfb08>sfb09 ",
               "   AND sfb01= ecm01",
               "   AND sfb87 = 'Y'",
               " GROUP BY sfb05,ecm04,ecm45,ecm54"
   LET l_sql = " INSERT INTO t010_tmp ", l_sql CLIPPED
   PREPARE t010_ins FROM l_sql
   EXECUTE t010_ins
   
   LET l_sql = " MERGE INTO t010_tmp o ",
               "      USING (SELECT sum(sgm65-shb111-shb115-shb112-shb113) sgm65,sfb05,sgm04 ",
               "               FROM sfb_file,sgm_file,shm_file,shb_file",
               "              WHERE sfb08>sfb09 ",
               "                AND sfb87 = 'Y'",
               "                AND sfb01 = shm012",
               "                AND shm01 = sgm01",
               "                AND sgm01 = shb16",
               "                AND sgm03 = shb06",
               "                AND shb081 = sgm04",
               "              GROUP BY sfb05,sgm04) n ",
               "         ON (o.sfb05 = n.sfb05 AND o.ecm04 =n.sgm04) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.llbg = n.sgm65 "
   PREPARE t010_pre1 FROM l_sql
   EXECUTE t010_pre1

   LET l_sql = "SELECT * FROM t010_tmp ORDER BY sfb05,ecm04"
   
   PREPARE t010_pb1 FROM l_sql
   DECLARE sfb_curs1 CURSOR FOR t010_pb1
 
   CALL g_tc_sfb.clear()
 
   LET g_rec_b1 = 0
   LET g_cnt1 = 1
   FOREACH sfb_curs1 INTO g_sfb[g_cnt1].*   #單身 ARRAY 填充
      LET g_rec_b1 = g_rec_b1 + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
   END FOREACH
   CALL g_sfb.deleteElement(g_cnt1)
   DISPLAY g_rec_b1 TO FORMONLY.cnt1
   LET g_cnt1 = 0
END FUNCTION 

FUNCTION t010_d()
DEFINE l_i         LIKE type_file.num5
DEFINE l_a         LIKE type_file.num5
DEFINE l_tc_sfb02  LIKE tc_sfb_file.tc_sfb02
DEFINE l_ecm58     LIKE ecm_file.ecm58
DEFINE l_x         LIKE type_file.num5
      SELECT max(tc_sfb02) INTO l_tc_sfb02 FROM tc_sfb_file WHERE tc_sfb01 = g_tc_sfa.tc_sfa01
      IF cl_null(l_tc_sfb02) THEN 
         LET l_tc_sfb02 = 0
      END IF 
      LET g_ACTION_choice = ""
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
      INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
             LET l_ac1 = ARR_CURR()
             IF l_ac1 = 0 THEN
                LET l_ac1 = 1
             END IF
             CALL fgl_set_arr_curr(l_ac1)
             CALL cl_show_fld_cont()
             LET g_sfb_t.* = g_sfb[l_ac1].*
             CALL t010_b2_fill(g_sfb[l_ac1].sfb05,g_sfb[l_ac1].ecm04,g_sfb[l_ac1].pcl)
             CALL t010_bp2('')

        AFTER ROW 
           LET l_ac1 = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
           END IF
           LET g_success ='Y'
           BEGIN WORK 
           IF g_sfb[l_ac1].sel = 'Y' THEN 
              IF g_sfb_t.sel <> g_sfb[l_ac1].sel THEN 
                 FOR l_i = 1 TO g_rec_b
                    LET l_x = 0
                    SELECT COUNT(*) INTO l_x FROM tc_sfb_file,tc_sfa_file 
                     WHERE tc_sfb01=tc_sfa01
                       AND tc_sfbud02 = g_tc_sfb[l_i].tc_sfbud02
                       AND tc_sfbud05 = g_tc_sfb[l_i].tc_sfbud05
                       AND tc_sfbud04 = g_tc_sfb[l_i].tc_sfbud04
                       AND tc_sfa02 =g_today
                    IF l_x >0 THEN
                       CALL cl_err('','csf-016',0)
                       LET g_success = 'N'
                    ELSE 
                       LET l_a = 0  
                       SELECT MAX(tc_sfb02) INTO l_a FROM tc_sfb_file
                        WHERE tc_sfb01=g_tc_sfa.tc_sfa01
                       IF cl_null(l_a) OR l_a = 0 THEN 
                          LET l_a = 1
                       ELSE 
                          LET l_a = l_a +1
                       END IF 
                       INSERT INTO tc_sfb_file
                       VALUES(g_tc_sfa.tc_sfa01,l_a,g_tc_sfb[l_i].tc_sfb03,g_tc_sfb[l_i].tc_sfb04,g_tc_sfb[l_i].tc_sfb05,
                              g_tc_sfb[l_i].tc_sfb06,g_tc_sfb[l_i].tc_sfb07,g_tc_sfb[l_i].tc_sfb08,g_tc_sfb[l_i].tc_sfbud01,
                              g_tc_sfb[l_i].tc_sfbud02,g_tc_sfb[l_i].tc_sfbud03,g_tc_sfb[l_i].tc_sfbud04,g_tc_sfb[l_i].tc_sfbud05,
                              g_tc_sfb[l_i].tc_sfbud06,g_tc_sfb[l_i].tc_sfbud07,g_tc_sfb[l_i].tc_sfbud08,g_tc_sfb[l_i].tc_sfbud09,
                              g_tc_sfb[l_i].tc_sfbud10,g_tc_sfb[l_i].tc_sfbud11,g_tc_sfb[l_i].tc_sfbud12,g_tc_sfb[l_i].tc_sfbud13,
                              g_tc_sfb[l_i].tc_sfbud14,g_tc_sfb[l_i].tc_sfbud15,g_plant,g_legal)
                       IF SQLCA.sqlcode THEN   
                          CALL cl_err3("ins","tc_sfb_file",g_tc_sfb[l_i].tc_sfbud02,g_tc_sfb[l_i].tc_sfbud05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                          LET g_success = 'N'
                       END IF
                    END IF 
                 END FOR 
              END IF 
           ELSE 
              IF g_sfb_t.sel <> g_sfb[l_ac1].sel THEN
                 LET l_x = 0
                 SELECT COUNT(*) INTO l_x FROM tc_sfb_file 
                  WHERE tc_sfb01=g_tc_sfa.tc_sfa01
                    AND tc_sfbud02 = g_sfb[l_ac1].sfb05
                    AND tc_sfbud05 = g_sfb[l_ac1].ecm04
                 IF l_x > 0 THEN 
                    DELETE FROM tc_sfb_file WHERE tc_sfbud02 = g_sfb[l_ac1].sfb05
                                              AND tc_sfbud05 = g_sfb[l_ac1].ecm04
                    IF SQLCA.sqlcode THEN   
                       CALL cl_err3("delete","tc_sfb_file",g_sfb[l_ac1].sfb05,g_sfb[l_ac1].ecm04,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                       LET g_success = 'N'
                    END IF
                 END IF 
              END IF 
           END IF  
        IF g_success = 'Y' THEN 
           COMMIT WORK 
        ELSE 
           ROLLBACK WORK
        END IF

        AFTER FIELD pcl
           IF NOT cl_null(g_sfb[l_ac1].pcl) OR g_sfb[l_ac1].pcl>0 THEN
              IF g_sfb[l_ac1].pcl<>g_sfb_t.pcl THEN 
                 IF g_sfb[l_ac1].pcl > g_sfb[l_ac1].llbg THEN 
                    CALL cl_err('','csf-015',0)
                    NEXT FIELD pcl
                 END IF  
                 CALL t010_b2_fill(g_sfb[l_ac1].sfb05,g_sfb[l_ac1].ecm04,g_sfb[l_ac1].pcl)
                 CALL t010_bp2('')
              END IF 
           END IF 

        AFTER INPUT   
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF cl_confirm("9042") THEN
                 DELETE FROM  tc_sfa_file WHERE tc_sfa01 =g_tc_sfa.tc_sfa01
                 INITIALIZE g_tc_sfa.* TO NULL
                 CALL g_sfb.clear()
                 CALL g_tc_sfb.clear()
                 CLEAR FORM
              END IF
           END IF 
 
         ON CHANGE sel
            IF cl_null(g_sfb[l_ac1].sel) THEN 
               LET g_sfb[l_ac1].sel = 'Y'
            END IF
 
        # ON ACTION select_all   
        #    FOR l_i = 1 TO g_rec_b1 
        #       LET g_sfb[l_i].sel = 'Y'
        #       DISPLAY BY NAME g_sfb[l_i].sel
        #    END FOR
            
 
        # ON ACTION select_non   #全部不選
        #    FOR l_i = 1 TO g_rec_b1 
        #       LET g_sfb[l_i].sel = 'N'
        #       DISPLAY BY NAME g_sfb[l_i].sel
        #    END FOR
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", FALSE)
      IF l_a-l_tc_sfb02 = 0 OR g_success = 'N' THEN
         IF cl_confirm("9042") THEN
            DELETE FROM  tc_sfa_file WHERE tc_sfa01 =g_tc_sfa.tc_sfa01
            INITIALIZE g_tc_sfa.* TO NULL
            CALL g_sfb.clear()
            CALL g_tc_sfb.clear()
            CLEAR FORM
         END IF
      END IF

END FUNCTION 

FUNCTION t010_table()
DROP TABLE t010_tmp;
   CREATE TEMP TABLE t010_tmp(
        sel            LIKE type_file.chr1,
        sfb05          LIKE sfb_file.sfb05,   
        ecm04          LIKE ecm_file.ecm04,   
        ecm45          LIKE ecm_file.ecm45,   
        wipqty         LIKE type_file.num15_3,
        llbg           LIKE type_file.num15_3,
        pcl            LIKE type_file.num15_3)
END FUNCTION 

FUNCTION t010_b2_fill(p_sfb05,p_sgm04,p_pcl)
DEFINE p_wc2          STRING       #No.FUN-680102CHAR(200)
DEFINE l_sql          STRING 
DEFINE p_sfb05        LIKE sfb_file.sfb05
DEFINE p_sgm04        LIKE sgm_file.sgm04
DEFINE p_pcl          LIKE type_file.num15_3
DEFINE l_x            LIKE type_file.num5

    LET l_sql = "SELECT '',shm01,sfb01,sfb05,sgm03,sfb06,sgm06,sgm04,sgm45,sgm65,",
                "       0,CASE sgm54  WHEN 'Y' THEN (sgm291- sgm311-sgm312-sgm313-sgm314-sgm316-sgm317) ",
                "                   ELSE (sgm301+sgm302+sgm303+sgm304-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317) END CASE,",
                "       0,sgm58,'','','','','','','','',''",
                "  FROM shm_file,sfb_file,sgm_file",
                " WHERE sfb08>sfb09",
                "   AND sfb01= shm012",
                "   AND sfb87 = 'Y'",
                "   AND shm01 = sgm01",
                "   AND sfb05 ='",p_sfb05,"'",
                "   AND sgm04 ='",p_sgm04,"'",
                " ORDER BY shm01"

    PREPARE t010_pb2 FROM l_sql
    DECLARE tc_sfb_curs2 CURSOR FOR t010_pb2
 
    CALL g_tc_sfb.clear()
 
    LET g_rec_b = 0
    LET l_x = 0
    LET g_cnt = 1
    FOREACH tc_sfb_curs2 INTO g_tc_sfb[g_cnt].*   #單身 ARRAY 填充
      SELECT SUM(shb111+shb115+shb112+shb113) INTO g_tc_sfb[g_cnt].tc_sfbud08
        FROM shb_file 
       WHERE  shb16 = g_tc_sfb[g_cnt].tc_sfbud04
         AND shb06 = g_tc_sfb[g_cnt].tc_sfb04
         AND shb081 = g_tc_sfb[g_cnt].tc_sfbud05
      IF cl_null(g_tc_sfb[g_cnt].tc_sfbud08) THEN LET g_tc_sfb[g_cnt].tc_sfbud08 = 0 END IF 
      LET g_tc_sfb[g_cnt].tc_sfb02 = g_rec_b+1
      IF p_pcl >g_tc_sfb[g_cnt].tc_sfbud07-g_tc_sfb[g_cnt].tc_sfbud08 THEN 
         LET g_tc_sfb[g_cnt].tc_sfb08=g_tc_sfb[g_cnt].tc_sfbud07-g_tc_sfb[g_cnt].tc_sfbud08
         LET p_pcl = p_pcl-g_tc_sfb[g_cnt].tc_sfb08
      ELSE 
         IF l_x =0 THEN 
            LET g_tc_sfb[g_cnt].tc_sfb08 = p_pcl
            LET l_x = l_x +1
         END IF 
      END IF 
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_tc_sfb.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION 

FUNCTION t010_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
  #CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-C70184 mark
   DISPLAY ARRAY g_tc_sfb TO s_tc_sfb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()

   END DISPLAY
END FUNCTION

#str------add by guanyao160622
FUNCTION t010_pic()
DEFINE l_chr1      LIKE type_file.chr1    #TQC-C50221 add
DEFINE l_chr2      LIKE type_file.chr1    #CHI-C60033 add


     CALL cl_set_field_pic1(g_tc_sfa.tc_sfa04,"","","","","","","")
END FUNCTION 
FUNCTION t010_ins_sfp()
DEFINE l_sql           STRING 
DEFINE l_sfp           RECORD LIKE sfp_file.*   
DEFINE l_sfq           RECORD LIKE sfq_file.* 
DEFINE li_result       LIKE type_file.num5
DEFINE l_tc_sfb        RECORD  
       tc_sfb08        LIKE tc_sfb_file.tc_sfb08,
       tc_sfb03        LIKE tc_sfb_file.tc_sfb03,
       tc_sfbud05      LIKE tc_sfb_file.tc_sfbud05
       END RECORD 
DEFINE l_sfb08 	LIKE sfb_file.sfb08    #No.FUN-680121 DEC(15,3)
DEFINE l_sfb23 	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE l_sfb04	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
DEFINE l_sfb02	LIKE sfb_file.sfb02
DEFINE l_sfb06	LIKE sfb_file.sfb06
DEFINE l_sfb81  LIKE sfb_file.sfb81

   IF cl_null(g_tc_sfa.tc_sfa01) THEN
      CALL cl_err("",-400,0)
      RETURN  
   END IF 
   IF g_tc_sfa.tc_sfa04 != 'Y' THEN 
      CALL cl_err("",9029,0)
      RETURN
   END IF 
   ##单头资料
   LET g_success = 'Y'
   LET l_sfp.sfp02  =g_today
   LET l_sfp.sfp03  =g_today   
   LET l_sfp.sfp04  ='N'
   LET l_sfp.sfpconf='N' 
   LET l_sfp.sfp05  ='N'
   LET l_sfp.sfp06  ='1'
   LET l_sfp.sfp09  ='N'
   LET l_sfp.sfpuser=g_user 
   LET l_sfp.sfporiu = g_user 
   LET l_sfp.sfporig = g_grup
   LET l_sfp.sfpgrup=g_grup  
   LET l_sfp.sfpdate=g_today 
   LET l_sfp.sfp07  =g_grup  
   LET l_sfp.sfp15 = '0'     
   LET l_sfp.sfpmksg = "N"
   LET l_sfp.sfp16 = g_user
   LET l_sfp.sfpplant = g_plant 
   LET l_sfp.sfplegal = g_legal 

   SELECT smyslip INTO l_sfp.sfp01 FROM smy_file WHERE smysys = 'asf' AND smykind = '3' AND smy72 = '1'
   IF cl_null(l_sfp.sfp01) THEN 
      CALL cl_err('','csf-022',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
      RETURNING li_result,l_sfp.sfp01
   IF (NOT li_result) THEN
      CALL cl_err('','csf-022',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET g_sfp01=l_sfp.sfp01

   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF STATUS THEN
      CALL cl_err3("ins","sfp_file",l_sfp.sfp01,"",STATUS,"","",1)  #No.FUN-660128
      LET g_success = 'N'
      RETURN 
   END IF
   
   
   LET l_sql = "SELECT sum(tc_sfb08),tc_sfb03,tc_sfbud05 ",
               "  FROM tc_sfb_file WHERE tc_sfb01 ='",g_tc_sfa.tc_sfa01,"'",
               " GROUP BY tc_sfb03,tc_sfbud05",
               " ORDER BY tc_sfb03,tc_sfbud05"
   PREPARE t010_pb3 FROM l_sql
   DECLARE tc_sfb_curs3 CURSOR FOR t010_pb3
   FOREACH tc_sfb_curs3 INTO l_tc_sfb.* 
      ##第一单身
      LET l_sfq.sfq01 = l_sfp.sfp01
      LET l_sfq.sfq02 = l_tc_sfb.tc_sfb03
      LET l_sfq.sfq012 = ' '
      LET l_sfq.sfq04 = l_tc_sfb.tc_sfbud05
      LET l_sfq.sfq05= l_sfp.sfp02
      LET l_sfq.sfqplant= g_plant
      LET l_sfq.sfqlegal= g_legal
      SELECT sfb04,sfb23,sfb08,sfb06,sfb81,sfb02
        INTO  l_sfb04, l_sfb23, l_sfb08,
             l_sfb06,l_sfb81,l_sfb02
        FROM sfb_file
       WHERE sfb01 =l_tc_sfb.tc_sfb03
         AND sfb87 ='Y'
         
      IF STATUS THEN
         CALL cl_err3("sel","sfb_file",l_tc_sfb.tc_sfb03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
         LET g_success = 'N' 
         RETURN 
      END IF
 
      IF l_sfb04='1' THEN
         CALL cl_err('sfb04=1','asf-381',0)
         LET g_success = 'N' 
         RETURN
      END IF
      IF l_sfb04='8' THEN
         CALL cl_err('sfb04=8','asf-345',0)
         LET g_success = 'N' 
         RETURN
      END IF
 
      IF l_sfb81 > l_sfp.sfp02 THEN      #-->NO:0813
         CALL cl_err(l_tc_sfb.tc_sfb03,'asf-819',0)
         LET g_success = 'N' 
         RETURN
      END IF                             
 
      IF l_sfb02=13 THEN  #bugno:4863
         CALL cl_err('sfb02=13','asf-346',0)
         LET g_success = 'N' 
         RETURN
      END IF
      INSERT INTO sfq_file VALUES(l_sfq.*)
      IF STATUS THEN
         CALL cl_err3("ins","sfq_file",l_sfq.sfq02,"",STATUS,"","",1)  #No.FUN-660128
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH 

   CALL t010_ins()
   IF g_success = 'Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF 

END FUNCTION 

FUNCTION t010_ins()
DEFINE l_sfb    RECORD LIKE sfb_file.*
DEFINE b_sfq    RECORD LIKE sfq_file.*
DEFINE qty1,qty2	LIKE sfq_file.sfq03 
DEFINE l_i          LIKE type_file.num5

   INITIALIZE b_sfs.* TO NULL
   LET b_sfs.sfs02=0
   DELETE FROM sfs_file WHERE sfs01=g_sfp01
   DELETE FROM rvbs_file

   LET issue_type = '1'
   DECLARE t010_g_b_c CURSOR FOR
         SELECT * FROM sfq_file WHERE sfq01=g_sfp01
   FOREACH t010_g_b_c INTO b_sfq.*
      SELECT * INTO g_sfb_1.* FROM sfb_file WHERE sfb01=b_sfq.sfq02
      IF STATUS THEN 
         CALL cl_err3("sel","sfb_file",b_sfq.sfq02,"",STATUS,"","sel sfb:",1)  #No.FUN-660128
         RETURN
      END IF
      CALL t010_sfq03_chk(b_sfq.sfq02,b_sfq.sfq04,'',b_sfq.sfq014,'1')  
         RETURNING qty1,qty2
      IF qty1 IS NULL THEN LET qty1=0 END IF
      IF qty2 IS NULL THEN LET qty2=0 END IF
      LET l_i =l_i + 1
      IF g_sfb_1.sfb08<=(qty1-qty2+b_sfq.sfq03) THEN
         CALL t010_g_b0()  #全數發料
      ELSE
         CALL t010_g_b1()  #依套數
      END IF
   END FOREACH 
END FUNCTION 

FUNCTION t010_sfq03_chk(p_sfq02,p_sfq04,p_sfq012,p_sfq014,p_flag)
DEFINE p_sfq02       LIKE sfq_file.sfq02
DEFINE p_sfq04       LIKE sfq_file.sfq04
DEFINE p_sfq012      LIKE sfq_file.sfq012
DEFINE p_sfq014      LIKE sfq_file.sfq014      
DEFINE p_flag        LIKE type_file.chr1                 
DEFINE l_qty1        LIKE sfq_file.sfq03
DEFINE l_qty2        LIKE sfq_file.sfq03
DEFINE l_sql                  STRING
DEFINE l_sql_1,l_sql_2        STRING
DEFINE l_sql_3,l_sql_4        STRING
DEFINE l_sql1                   STRING
DEFINE l_sql1_1,l_sql1_2        STRING
DEFINE l_sql1_3,l_sql1_4        STRING
DEFINE l_sql2                   STRING
DEFINE l_sql2_1,l_sql2_2        STRING
DEFINE l_sql2_3,l_sql2_4        STRING
DEFINE qty1_1,qty1_2  LIKE sfq_file.sfq03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty1_3,qty1_4  LIKE sfq_file.sfq03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_1,qty2_2  LIKE sfq_file.sfq03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_3,qty2_4  LIKE sfq_file.sfq03   #已退按作業編號的套數和已發不按作業編號的套數

   IF cl_null(p_sfq04) THEN
      LET g_success = 'N'
      RETURN 
   END IF
   IF cl_null(p_sfq012) THEN
      LET p_sfq012 = ' '
   END IF
   LET l_sql = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
               "  WHERE sfq02 = '",p_sfq02,"'",
               "    AND sfq01 = sfp01 "
   #只計算已過帳的
   LET l_sql = l_sql CLIPPED,
              "    AND sfp04 ='Y'"
   #只輸入了作業編號——可以不考慮工藝段了
   IF NOT cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND sfq04 = '",p_sfq04,"' "
      #按作業編號空格+工藝段值
      LET l_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF
   ##-------------計算已發-------------##begin
   LET qty1_1 = 0
   LET qty1_2 = 0
   LET qty1_3 = 0
   LET qty1_4 = 0
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
     #LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      IF cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
         LET l_sql1_2 = l_sql1_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i501_sfq03_pre1_2 FROM l_sql1_2
      DECLARE i501_sfq03_curs1_2 CURSOR FOR i501_sfq03_pre1_2
      FOREACH i501_sfq03_curs1_2 INTO qty1_2
           IF STATUS THEN LET qty1_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
     #LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i501_sfq03_pre1_4 FROM l_sql1_4
      DECLARE i501_sfq03_curs1_4 CURSOR FOR i501_sfq03_pre1_4
      FOREACH i501_sfq03_curs1_4 INTO qty1_4
           IF STATUS THEN LET qty1_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty1_1) THEN LET qty1_1=0 END IF
   IF cl_null(qty1_2) THEN LET qty1_2=0 END IF
   IF cl_null(qty1_3) THEN LET qty1_3=0 END IF
   IF cl_null(qty1_4) THEN LET qty1_4=0 END IF
   LET l_qty1 = qty1_1 + qty1_2 + qty1_3 + qty1_4
   ##-------------計算已發-------------##end

   ##-------------計算已退-------------##begin
   LET qty2_1 = 0
   LET qty2_2 = 0
   LET qty2_3 = 0
   LET qty2_4 = 0
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
      LET l_sql2_2 = l_sql_2 CLIPPED," AND sfp06 = '6' AND sfp01 <> '",g_sfp01,"' "      
      IF cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
         LET l_sql2_2 = l_sql2_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i501_sfq03_pre2_2 FROM l_sql2_2
      DECLARE i501_sfq03_curs2_2 CURSOR FOR i501_sfq03_pre2_2
      FOREACH i501_sfq03_curs2_2 INTO qty2_2
           IF STATUS THEN LET qty2_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
      LET l_sql2_4 = l_sql_4 CLIPPED," AND sfp06 = '6' AND sfp01 <> '",g_sfp01,"' "   
      PREPARE i501_sfq03_pre2_4 FROM l_sql2_4
      DECLARE i501_sfq03_curs2_4 CURSOR FOR i501_sfq03_pre2_4
      FOREACH i501_sfq03_curs2_4 INTO qty2_4
           IF STATUS THEN LET qty2_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty2_1) THEN LET qty2_1=0 END IF
   IF cl_null(qty2_2) THEN LET qty2_2=0 END IF
   IF cl_null(qty2_3) THEN LET qty2_3=0 END IF
   IF cl_null(qty2_4) THEN LET qty2_4=0 END IF
   LET l_qty2 = qty2_1 + qty2_2 + qty2_3 + qty2_4
   ##-------------計算已退-------------##end

   RETURN l_qty1,l_qty2   
END FUNCTION 

FUNCTION t010_g_b0() 		# 全數發料 (除了消耗料件&代買料件)
  DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
  DEFINE l_mai_ware	LIKE img_file.img02              #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03            #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03

  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND sfa05>sfa06", 
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X','S') OR sfa11 IS NULL)", #CHI-980013 #FUN-9C0040 
              "   AND (sfa05-sfa065)>0"
 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i501_g_b0_pre FROM l_sql
  DECLARE i501_g_b0_c CURSOR FOR i501_g_b0_pre
 
  FOREACH i501_g_b0_c INTO g_sfa2.*,g_ima108
 
    LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
 
    LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
    #FUN-AC0074(S)
    CALL t010_issue_sie()
    IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
    #FUN-AC0074(E) 
    IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
    IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
     SELECT ima35,ima36,ima136,ima137
       INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file            #FUN-B80086  main改成mai
      WHERE ima01=g_sfa2.sfa03
    #FUN-AC0074 (E)
    CALL t010_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,'',FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai 
 
  END FOREACH
 
END FUNCTION

FUNCTION t010_issue_sie()
  DEFINE l_sie         RECORD LIKE sie_file.*
  DEFINE l_issue_qty1  LIKE sfq_file.sfq03
  DEFINE l_sql,l_where         STRING

    LET l_where =''    
    LET l_sql = "SELECT sie_file.* FROM ima_file, sfa_file, sie_file ",
                " WHERE sfa01 =  '",g_sfa2.sfa01 ,"'",
                "   AND sfa03 =  '",g_sfa2.sfa03 ,"'",
                "   AND sfa08 =  '",g_sfa2.sfa08 ,"'",
                "   AND sfa12 =  '",g_sfa2.sfa12 ,"'",
                "   AND sfa27 =  '",g_sfa2.sfa27 ,"'",
                "   AND sfa012=  '",g_sfa2.sfa012,"'",
                "   AND sfa013=  '",g_sfa2.sfa013,"'",
                "   AND ima01 = sfa03  AND sfa01=sie05 AND sfa27=sie01 ",
                "   AND sfa03 = sie08  AND sfa08=sie06 AND sfa12=sie07 ",
                "   AND sfa012= sie012 AND sfa013=sie013 ",
                "   AND sie11 > 0 AND (sie02 IS NOT NULL AND sie02 <> ' ')",l_where
    PREPARE i501_g_b0_pre1 FROM l_sql
    DECLARE i501_g_b0_c1 CURSOR FOR i501_g_b0_pre1
    FOREACH i501_g_b0_c1 INTO l_sie.*
      IF issue_qty1 <=0 THEN EXIT FOREACH END IF
       LET l_issue_qty1 = issue_qty1
       IF l_sie.sie11 > issue_qty1 THEN 
          LET issue_qty1 = issue_qty1
       ELSE  
          LET issue_qty1 = l_sie.sie11
       END IF 
       CALL t010_chk_img(l_sie.sie02,l_sie.sie03,l_sie.sie02,l_sie.sie03,l_sie.sie04,TRUE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 
       LET issue_qty1 = l_issue_qty1 - issue_qty2
       IF issue_qty1 < 0 THEN LET issue_qty1 = 0 END IF

    END FOREACH
END FUNCTION

FUNCTION t010_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,l_lot_no,l_sie_flag)	# 依 issue_qty1 尋找 img_file可用資料  #FUN-AC0074     #FUN-B80086  main改成mai
    DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
    DEFINE l_img10              LIKE img_file.img10    #No.MOD-910026
    DEFINE l_factor             LIKE img_file.img21    #No.MOD-940302 add
    DEFINE l_cnt                LIKE type_file.num5    #No.MOD-940302 add
    DEFINE l_n                  LIKE type_file.num5    #CHI-B90038 add
    define l_mai_ware	LIKE img_file.img02        #FUN-B80086  main改成mai
    define l_mai_loc	LIKE img_file.img03        #FUN-B80086  main改成mai
    define l_wip_ware	LIKE img_file.img02
    define l_wip_loc	LIKE img_file.img03
    DEFINE l_lot_no LIKE img_file.img04  #FUN-AC0074
    DEFINE l_sie_flag LIKE type_file.num5  #TRUE->依備置單產生  FALSE->不依備置產生
    DEFINE l_flag       LIKE type_file.chr1   #MOD-CB0046 add
    DEFINE l_img09      LIKE img_file.img09   #MOD-CB0046 add
    
    IF NOT cl_null(l_mai_ware) THEN       #FUN-B80086  main改成mai
       IF NOT s_chk_ware(l_mai_ware) THEN  #检查仓库是否属于当前门店     #FUN-B80086  main改成mai
          LET l_mai_ware = ' '                                           #FUN-B80086  main改成mai
       END IF
    END IF
    IF NOT cl_null(l_wip_ware) THEN
       IF NOT s_chk_ware(l_wip_ware) THEN  #检查仓库是否属于当前门店
          LET l_wip_ware = ' '
       END IF
    END IF
    #End Add No.FUN-AB0018
    IF g_ima108 = 'Y' THEN
       LET l_mai_ware = l_wip_ware      #FUN-B80086  main改成mai
       LET l_mai_loc  = l_wip_loc       #FUN-B80086  main改成mai
    END IF
    IF cl_null(l_mai_ware) THEN LET l_mai_ware='' END IF       #FUN-B80086  main改成mai
    IF cl_null(l_mai_loc ) THEN LET l_mai_loc =''  END IF       #FUN-B80086  main改成mai
    IF issue_type='1' THEN
       LET g_img.img01=g_sfa2.sfa03
       LET g_img.img02=l_mai_ware            #FUN-B80086  main改成mai
       LET g_img.img03=l_mai_loc             #FUN-B80086  main改成mai
       LET g_img.img04=l_lot_no  #FUN-AC0074
       LET issue_qty2=issue_qty1
       CALL t010_ins_sfs()
       LET img_qty = issue_qty1 #No.+238
       RETURN
    END IF
END FUNCTION

FUNCTION t010_ins_sfs()	# 依 issue_qty2 Insert sfs_file
DEFINE l_gfe03 LIKE gfe_file.gfe03 #MOD-640364
DEFINE l_tot   LIKE sfs_file.sfs05 #No.TQC-750232   
DEFINE l_count LIKE type_file.num5   #NO.FUN-A40053 add 
DEFINE l_ima64 LIKE ima_file.ima64 #add by guanyao160601
 
    SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01=g_sfa2.sfa12
    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
       LET l_gfe03=0
    END IF
    #IF gen_all ='Y' AND g_flag_sie01 = 'Y' THEN  
    #   SELECT COUNT(*) INTO l_count FROM sie_file WHERE sie01 = g_img.img01 
    #           AND sie02 = g_img.img02 AND sie03 = g_img.img03 
    #           AND sie04 = g_img.img04 AND sie05 = b_sfq.sfq02 
    #   IF l_count > 0 THEN 
    #      LET g_flag_sie01 = 'N'
    #      RETURN 
    #   END IF 
    # END IF 
    #FUN-A40053 --add --end 
    LET b_sfs.sfs01=g_sfp01
    LET b_sfs.sfs02=b_sfs.sfs02+1
    LET b_sfs.sfs03=b_sfq.sfq02
    LET b_sfs.sfs04=g_img.img01
    LET b_sfs.sfs05=issue_qty2 
    LET b_sfs.sfs06=g_sfa2.sfa12
    LET b_sfs.sfs05=s_digqty(issue_qty2,b_sfs.sfs06)  #FUN-D60039 add
    #str-----add by guanyao160601
    #LET b_sfs.sfs07=g_img.img02      #mark by guanyao160601
    LET b_sfs.sfsud02 = g_img.img02   #add by guanyao160601
    SELECT tc_aec01 INTO b_sfs.sfs07 FROM tc_aec_file WHERE tc_eca03 = g_sfa2.sfa08
    IF cl_null(b_sfs.sfs07) THEN 
       LET b_sfs.sfs07 = 'XBC'
    END IF 
    CALL t010_chk_ima64(b_sfs.sfs04, b_sfs.sfs05) RETURNING b_sfs.sfsud07
    #end-----add by guanyao160601
    LET b_sfs.sfs08=g_img.img03
    LET b_sfs.sfs09=g_img.img04
    LET b_sfs.sfs10=g_sfa2.sfa08
    LET b_sfs.sfs26=NULL
    LET b_sfs.sfs27=NULL
    LET b_sfs.sfs28=NULL
    LET b_sfs.sfs36=g_sfa2.sfa36   #FUN-950088 add
    IF g_sfa2.sfa26 MATCHES '[SUTZ9BC]' THEN  #FUN-A20037 add 'Z' #TQC-C20443 add '9'
       LET b_sfs.sfs26=g_sfa2.sfa26
       LET b_sfs.sfs27=g_sfa2.sfa27
       LET b_sfs.sfs28=g_sfa2.sfa28
    END IF
    IF g_sfa2.sfa26 = 'A' THEN LET  b_sfs.sfs26 = '9' END IF  #TQC-C20443 add
    IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
    IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
    IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
    
#FUN-A60028 --begin--
    LET b_sfs.sfs012 = g_sfa2.sfa012
    LET b_sfs.sfs013 = g_sfa2.sfa013
#FUN-A60028 --end--    

#FUN-A60028 --begin--
    IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
    IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#FUN-A60028 --end--  

#FUN-C70014 add begin--------------   
    LET b_sfs.sfs014 = b_sfq.sfq014  
    IF cl_null(b_sfs.sfs014) THEN LET b_sfs.sfs014 = ' ' END IF
#FUN-C70014 add end ---------------
    #IF g_sma.sma115 = 'Y' THEN
    #   CALL i501_set_du_by_origin()
    #END IF
    LET b_sfs.sfs930=t010_get_sfs930(b_sfs.sfs03) #FUN-670103
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27=b_sfs.sfs04
    END IF
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27 = ' '
    END IF
    IF cl_null(b_sfs.sfs28) THEN
       SELECT sfa28 INTO b_sfs.sfs28
         FROM sfa_file
        WHERE sfa01 = b_sfs.sfs03 
          AND sfa03 = b_sfs.sfs04
          AND sfa08 = b_sfs.sfs10
          AND sfa12 = b_sfs.sfs06
          AND sfa27 = b_sfs.sfs27
          AND sfa012= b_sfs.sfs012   #FUN-A60028
          AND sfa013= b_sfs.sfs013   #FUN-A60028 
    END IF
 
    LET b_sfs.sfsplant = g_plant #FUN-980008 add
    LET b_sfs.sfslegal = g_legal #FUN-980008 add

    INSERT INTO sfs_file VALUES(b_sfs.*)
    IF STATUS THEN 
       CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
       LET g_success = 'N' 
    END IF
    
    #CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
    
END FUNCTION

FUNCTION t010_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   #No.FUN-680121 DEC(15,3)
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   #No.FUN-680121 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN                     #CHI-C90017 add
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION

FUNCTION t010_get_sfs930(p_sfs03)
DEFINE p_sfs03 LIKE sfs_file.sfs03
DEFINE l_sfb98 LIKE sfb_file.sfb98 
    SELECT sfb98 INTO l_sfb98 FROM sfb_file
                             WHERE sfb01=p_sfs03
    IF SQLCA.sqlcode THEN
       LET l_sfb98=NULL
    END IF
       RETURN s_costcenter(l_sfb98)
END FUNCTION

FUNCTION t010_g_b1() 		# 依套數發料/退料(When sfp06=1/6)
  DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(1000)
  DEFINE s_u_flag	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02       #FUN-B80086  main改成mai
  DEFINE l_mai_loc	LIKE img_file.img03       #FUN-B80086  main改成mai
  DEFINE l_wip_ware	LIKE img_file.img02
  DEFINE l_wip_loc	LIKE img_file.img03
  #FUN-AC0074 (E)
  DEFINE l_bmd07        LIKE bmd_file.bmd07     #TQC-C30067 add
  DEFINE l_bmd10        LIKE bmd_file.bmd10     #TQC-C30067 add
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND sfa26 IN ('0','1','2','3','4','5','T','7','8','9','A')",    #bugno:7111 add '5T'  #FUN-A20037 add '7,8' #TQC-C20443 add ,'9' 'A'
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
              "   AND (sfa05-sfa065)>=0",    #應發-委外代買量>0   #No:9390   #No.MOD-570241 modify
              "    AND sfa11 <> 'S' "
 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY sfa03"
  PREPARE i501_g_b1_pre FROM l_sql
  DECLARE i501_g_b1_c CURSOR FOR i501_g_b1_pre
 
  FOREACH i501_g_b1_c INTO g_sfa.*,g_ima108	#原始料件(g_sfa)
    LET g_sfa.sfa05=g_sfa.sfa05-g_sfa.sfa065   #扣除委外代買量
 
    IF STATUS THEN CALL cl_err('fore sfa',STATUS,1) RETURN END IF
 
 
    LET issue_qty  =b_sfq.sfq03*g_sfa.sfa161		#原始料件應發/退數量

 
    IF g_sfa.sfa26 MATCHES '[01257]' THEN   #FUN-A20037 add '7'
       #若是全數代買時則不允許做退料
       IF g_sfa.sfa05 = 0 THEN 
          CONTINUE FOREACH
       END IF
       IF issue_qty>(g_sfa.sfa05-g_sfa.sfa06) THEN  #FUN-B50059
          LET issue_qty=(g_sfa.sfa05-g_sfa.sfa06)   #FUN-B50059
       END IF

       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 
       LET g_sfa2.* = g_sfa.*
 
       LET issue_qty1=issue_qty
 
       CALL t010_issue_sie()
       IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
 
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file           #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       CALL t010_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,'',FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
 
       CONTINUE FOREACH
 
    END IF
 
    # 當有替代狀況時, 須作以下處理:
    LET l_sql="SELECT * FROM sfa_file",
              " WHERE sfa01='",g_sfa.sfa01,"' AND sfa27='",g_sfa.sfa03,"'",
              "   AND sfa08='",g_sfa.sfa08,"' AND sfa12='",g_sfa.sfa12,"'",
              "   AND sfa012= '",g_sfa.sfa012,"' AND sfa013 = ",g_sfa.sfa013   #FUN-A60028 add
 
    SELECT MAX(sfa26) INTO s_u_flag FROM sfa_file	# 到底是 S 或 U ?
                WHERE sfa01=g_sfa.sfa01 AND sfa27=g_sfa.sfa03
                  AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
                  AND sfa012=g_sfa.sfa012 AND sfa013=g_sfa.sfa013   #FUN-A60028 add
    # U:先發取代件,再發原料件 S:先發原料件,再發替代件
    IF s_u_flag='U' OR s_u_flag = 'T' THEN     #bungo:711l add 'T'
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26 DESC, sfa03"
    ELSE
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26     , sfa03"
    END IF
    PREPARE g_b1_p2 FROM l_sql
    DECLARE g_b1_c2 CURSOR FOR g_b1_p2
    FOREACH g_b1_c2 INTO g_sfa2.*	             #應發(含替代)料件(g_sfa2
       LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
       IF STATUS THEN CALL cl_err('f sfa2',STATUS,1) RETURN END IF
       LET issue_qty=issue_qty*g_sfa2.sfa28
       #FUN-AC0074 (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file         #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 (E) 
       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 # issue_qty的計算應以sfq03* sfa161來計算才不會被改變,影響後續欠料數量的計算
	# 發料時
        IF g_sfa2.sfa05<=g_sfa2.sfa06 THEN CONTINUE FOREACH END IF #FUN-B50059
         IF issue_qty<=(g_sfa2.sfa05-g_sfa2.sfa06) THEN  #FUN-B50059
            LET issue_qty1=issue_qty
            #FUN-AC0074(S)
            CALL t010_issue_sie()
            IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
            #FUN-AC0074 (E)
            #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
            CALL t010_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,'',FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
            EXIT FOREACH
         ELSE
            LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
            #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
            CALL t010_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,'',FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
         END IF
    END FOREACH
  END FOREACH
END FUNCTION
#end------add by guanyao160622