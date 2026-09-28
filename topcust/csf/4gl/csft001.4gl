# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csft001.4gl
# Descriptions...: 簽核等級
# Date & Author..: 16/05/11 By guanyao
# Modify.........: MOD-160517-01 add by guanyao160517  增加收货单号，收货单项次
# Modify.........: MOD-160523-01 add by guanyao160523  增加版本号

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_sfp           RECORD LIKE tc_sfp_file.*,       
    g_tc_sfp_t         RECORD LIKE tc_sfp_file.*,       
    g_tc_sfp_o         RECORD LIKE tc_sfp_file.*,       
    g_tc_sfp01_t       LIKE tc_sfp_file.tc_sfp01,   
    g_tc_sfs           DYNAMIC ARRAY OF RECORD    
        tc_sfs02       LIKE tc_sfs_file.tc_sfs02,   
        tc_sfs03       LIKE tc_sfs_file.tc_sfs03,   
        ima02          LIKE ima_file.ima02, 
        ima021         LIKE ima_file.ima021,   
        tc_sfs04       LIKE tc_sfs_file.tc_sfs04,
        tc_sfs05       LIKE tc_sfs_file.tc_sfs05,
        tc_sfs06       LIKE tc_sfs_file.tc_sfs06,
        tc_sfsud01     LIKE tc_sfs_file.tc_sfsud01,
        tc_sfsud02     LIKE tc_sfs_file.tc_sfsud02,
        tc_sfsud03     LIKE tc_sfs_file.tc_sfsud03,
        tc_sfsud04     LIKE tc_sfs_file.tc_sfsud04,
        tc_sfsud05     LIKE tc_sfs_file.tc_sfsud05,
        tc_sfsud06     LIKE tc_sfs_file.tc_sfsud06,
        tc_sfsud07     LIKE tc_sfs_file.tc_sfsud07,
        tc_sfsud08     LIKE tc_sfs_file.tc_sfsud08,
        tc_sfsud09     LIKE tc_sfs_file.tc_sfsud09,
        tc_sfsud10     LIKE tc_sfs_file.tc_sfsud10,
        tc_sfsud11     LIKE tc_sfs_file.tc_sfsud11,
        tc_sfsud12     LIKE tc_sfs_file.tc_sfsud12,
        tc_sfsud13     LIKE tc_sfs_file.tc_sfsud13,
        tc_sfsud14     LIKE tc_sfs_file.tc_sfsud14,
        tc_sfsud15     LIKE tc_sfs_file.tc_sfsud15
                    END RECORD,
    g_tc_sfs_t         RECORD                 
        tc_sfs02       LIKE tc_sfs_file.tc_sfs02,   
        tc_sfs03       LIKE tc_sfs_file.tc_sfs03,   
        ima02          LIKE ima_file.ima02, 
        ima021         LIKE ima_file.ima021,   
        tc_sfs04       LIKE tc_sfs_file.tc_sfs04,
        tc_sfs05       LIKE tc_sfs_file.tc_sfs05,
        tc_sfs06       LIKE tc_sfs_file.tc_sfs06,
        tc_sfsud01     LIKE tc_sfs_file.tc_sfsud01,
        tc_sfsud02     LIKE tc_sfs_file.tc_sfsud02,
        tc_sfsud03     LIKE tc_sfs_file.tc_sfsud03,
        tc_sfsud04     LIKE tc_sfs_file.tc_sfsud04,
        tc_sfsud05     LIKE tc_sfs_file.tc_sfsud05,
        tc_sfsud06     LIKE tc_sfs_file.tc_sfsud06,
        tc_sfsud07     LIKE tc_sfs_file.tc_sfsud07,
        tc_sfsud08     LIKE tc_sfs_file.tc_sfsud08,
        tc_sfsud09     LIKE tc_sfs_file.tc_sfsud09,
        tc_sfsud10     LIKE tc_sfs_file.tc_sfsud10,
        tc_sfsud11     LIKE tc_sfs_file.tc_sfsud11,
        tc_sfsud12     LIKE tc_sfs_file.tc_sfsud12,
        tc_sfsud13     LIKE tc_sfs_file.tc_sfsud13,
        tc_sfsud14     LIKE tc_sfs_file.tc_sfsud14,
        tc_sfsud15     LIKE tc_sfs_file.tc_sfsud15
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #No.TQC-740021
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_str          STRING                              #No.FUN-760083 
DEFINE l_table        STRING                              #No.FUN-760083 
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL     
DEFINE g_chr          LIKE tc_sfp_file.tc_sfpconf        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_argv1        LIKE type_file.chr1
DEFINE g_argv2        LIKE pmn_file.pmn01
DEFINE g_argv3        LIKE pmn_file.pmn02
DEFINE g_argv4        LIKE pmn_file.pmn02
DEFINE g_argv5        LIKE pmm_file.pmm25
DEFINE g_err          LIKE type_file.chr1
 
 
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
    OPEN WINDOW t001_w WITH FORM "csf/42f/csft001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    LET g_argv5 = '1' # add by huanglf160913
#str----add by guanyao160517
    IF g_argv1 = '1' THEN 
       call cl_set_comp_visible('tc_sfp11,tc_sfp12',FALSE)
       call cl_set_comp_entry('tc_sfp03,tc_sfp04',TRUE)
    ELSE 
       IF g_argv4>0 THEN 
          call cl_set_comp_visible('tc_sfp11,tc_sfp12',FALSE)
          call cl_set_comp_entry('tc_sfp03,tc_sfp04',TRUE)
          #str----add by guanyao160616
          LET g_msg = "退料数量"
          CALL cl_set_comp_att_text("tc_sfp09",g_msg CLIPPED)
          LET g_msg = "应退数量"
          CALL cl_set_comp_att_text("tc_sfs04",g_msg CLIPPED)
          LET g_msg = "实退数量"
          CALL cl_set_comp_att_text("tc_sfs05",g_msg CLIPPED)
          #end----add by guanyao160616
       ELSE 
          call cl_set_comp_visible('tc_sfp11,tc_sfp12',TRUE)
          call cl_set_comp_entry('tc_sfp03,tc_sfp04',FALSE)
          #str----add by guanyao160616
          LET g_msg = "收发数量"
          CALL cl_set_comp_att_text("tc_sfp09",g_msg CLIPPED)
          LET g_msg = "应发数量"
          CALL cl_set_comp_att_text("tc_sfs04",g_msg CLIPPED)
          LET g_msg = "实发数量"
          CALL cl_set_comp_att_text("tc_sfs05",g_msg CLIPPED)
          #end----add by guanyao160616
       END IF  
    END IF 
#end----add by guanyao160517
    DROP TABLE t001_omb
    CREATE TEMP TABLE t001_omb(
       x_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       bmb02    LIKE bmb_file.bmb02,    #項次
       bmb03    LIKE bmb_file.bmb03,    #元件料號
       bmb06    LIKE bmb_file.bmb06,    #QPA/BASE
       bmb10    LIKE bmb_file.bmb10,
       bma01    LIKE bma_file.bma01)    #No.MOD-490217
    DELETE FROM t001_omb
        
    CALL g_tc_sfs.clear()
 
    LET g_forupd_sql = "SELECT * FROM tc_sfp_file WHERE tc_sfp01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_cl CURSOR FROM g_forupd_sql

    IF NOT cl_null(g_argv1) THEN 
       call cl_set_act_visible('insert,query',FALSE)
       call cl_set_act_visible('modify',FALSE)
       #str----add by guanyao160810
      IF g_argv1 = '1' THEN 
        IF g_argv5 = '1' THEN 
          CALL t001_ins_tc_sfp_1()
        ELSE 
          CALL t001_q()
        END IF 
      END IF
      IF g_argv1 = '2' THEN 
         CALL t001_ins_tc_sfp_2()
      END IF
      IF g_argv1 = '3' THEN 
         CALL t001_ins_tc_sfp_3()
      END IF 
      IF g_argv1 = '4' THEN 
         CALL t001_ins_tc_sfp_4()
      END IF 
      #end----add by guanyao160810
         #CALL t001_ins_tc_sfp(g_argv1,g_argv2,g_argv3,g_argv4)
    ELSE 
       call cl_set_act_visible('insert',FALSE)
       call cl_set_act_visible('modify,delete',FALSE)
    END IF 
 
    CALL t001_menu()
    CLOSE WINDOW t001_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION t001_cs()
 
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_sfs.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_tc_sfp.* TO NULL    #No.FUN-750051
   #str-----add by guanyao160810
   IF NOT cl_null(g_argv1)  THEN 
      LET g_wc = " tc_sfp06 = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
   ELSE 
   #end-----add by guanyao160810
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      tc_sfp00,tc_sfp01,tc_sfp02,tc_sfp03,tc_sfp04,tc_sfp05,tc_sfp06,tc_sfp07,tc_sfp08,tc_sfp09,tc_sfp10,
      tc_sfp11,tc_sfp12,tc_sfp13,  #add by guanyao160517#add by guanyao160523
      tc_sfpuser,tc_sfpgrup,tc_sfpmodu,tc_sfpdate,tc_sfpconf,
      tc_sfpud01,tc_sfpud02,tc_sfpud03,tc_sfpud04,tc_sfpud05,
      tc_sfpud06,tc_sfpud07,tc_sfpud08,tc_sfpud09,tc_sfpud10,
      tc_sfpud11,tc_sfpud12,tc_sfpud13,tc_sfpud14,tc_sfpud15
               
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_sfp03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_tc_sfp03_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_tc_sfp.tc_sfp03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfp03
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
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_sfpuser', 'tc_sfpgrup')
 
   CONSTRUCT g_wc2 ON tc_sfs02,tc_sfs03,tc_sfs04,tc_sfs05,tc_sfs06,
                      tc_sfsud01,tc_sfsud02,tc_sfsud03,tc_sfsud04,tc_sfsud05,
                      tc_sfsud06,tc_sfsud07,tc_sfsud08,tc_sfsud09,tc_sfsud10,
                      tc_sfsud11,tc_sfsud12,tc_sfsud13,tc_sfsud14,tc_sfsud15
        FROM s_tc_sfs[1].tc_sfs02,s_tc_sfs[1].tc_sfs03,s_tc_sfs[1].tc_sfs04,
             s_tc_sfs[1].tc_sfs05,s_tc_sfs[1].tc_sfs06,
             s_tc_sfs[1].tc_sfsud01,s_tc_sfs[1].tc_sfsud02,s_tc_sfs[1].tc_sfsud03,
             s_tc_sfs[1].tc_sfsud04,s_tc_sfs[1].tc_sfsud05,s_tc_sfs[1].tc_sfsud06,
             s_tc_sfs[1].tc_sfsud07,s_tc_sfs[1].tc_sfsud08,s_tc_sfs[1].tc_sfsud09,
             s_tc_sfs[1].tc_sfsud10,s_tc_sfs[1].tc_sfsud11,s_tc_sfs[1].tc_sfsud12,
             s_tc_sfs[1].tc_sfsud13,s_tc_sfs[1].tc_sfsud14,s_tc_sfs[1].tc_sfsud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
        # CASE
        #    WHEN INFIELD(tc_sfs03)
        #       CALL cl_init_qry_var()
        #       LET g_qryparam.form = "q_gen"
        #       LET g_qryparam.state = "c"
        #       CALL cl_create_qry() RETURNING g_qryparam.multiret
        #       DISPLAY g_qryparam.multiret TO tc_sfs03
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
   END IF 
   IF g_wc2 = " 1=1" THEN		
      LET g_sql = "SELECT  tc_sfp01 FROM tc_sfp_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_sfp01"
   ELSE					
      LET g_sql = "SELECT UNIQUE  tc_sfp01 ",
                  "  FROM tc_sfp_file LEFT OUTER JOIN tc_sfs_file ON tc_sfp01=tc_sfs01",
                  "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_sfp01"
   END IF
 
   PREPARE t001_prepare FROM g_sql
   DECLARE t001_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t001_prepare
 
   IF g_wc2 = " 1=1" THEN		
       LET g_sql="SELECT COUNT(*) FROM tc_sfp_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT tc_sfp01) FROM tc_sfp_file,tc_sfs_file WHERE ",
                 "tc_sfs01=tc_sfp01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t001_precount FROM g_sql
   DECLARE t001_count CURSOR FOR t001_precount
   OPEN t001_count
   FETCH t001_count INTO g_row_count
   CLOSE t001_count
 
END FUNCTION
 
 
 
FUNCTION t001_menu()
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_ACTION_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t001_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL t001_x()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_confirm()
            END IF
          WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_undo_confirm()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t001_b()
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
               IF g_tc_sfp.tc_sfp01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_sfp01"
                  LET g_doc.value1 = g_tc_sfp.tc_sfp01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sfs),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t001_a()
DEFINE l_y       LIKE type_file.chr20 
DEFINE l_m       LIKE type_file.chr20
DEFINE l_str       LIKE type_file.chr20
DEFINE l_tmp       LIKE type_file.chr20 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_sfs.clear()
    INITIALIZE g_tc_sfp.* LIKE tc_sfp_file.*             #DEFAULT 設定
    LET g_tc_sfp01_t = NULL
    LET g_tc_sfp_o.* = g_tc_sfp.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tc_sfp.tc_sfp02=g_today
        LET g_tc_sfp.tc_sfpuser=g_user
        LET g_tc_sfp.tc_sfpgrup=g_grup
        LET g_tc_sfp.tc_sfpdate=g_today
        LET g_tc_sfp.tc_sfpconf = 'N'
        LET g_tc_sfp.tc_sfp00='1'
        LET g_tc_sfp.tc_sfp13='1'
        
        LET l_y =YEAR(g_today)
        LET l_y = l_y[3,4] USING '&&' 
        LET l_m =MONTH(g_today)
        LET l_m = l_m USING '&&' 
        LET l_str='XXX-',l_y clipped,l_m CLIPPED
        SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
         WHERE substr(tc_sfp01,1,8)=l_str
        IF cl_null(l_tmp) THEN 
           LET l_tmp = '0001' 
        ELSE 
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&'     
        END IF 
        LET g_tc_sfp.tc_sfp01 = l_str clipped,l_tmp
        
        CALL t001_i("a")                
        IF INT_FLAG THEN                   
            INITIALIZE g_tc_sfp.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tc_sfp.tc_sfp01 IS NULL THEN          
            CONTINUE WHILE
        END IF
        LET g_tc_sfp.tc_sfpplant = g_plant
        LET g_tc_sfp.tc_sfplegal = g_legal
        INSERT INTO tc_sfp_file VALUES (g_tc_sfp.*)
        IF SQLCA.sqlcode THEN   
            CALL cl_err3("ins","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT tc_sfp01 INTO g_tc_sfp.tc_sfp01 FROM tc_sfp_file
            WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
        LET g_tc_sfp01_t = g_tc_sfp.tc_sfp01        #保留舊值
        LET g_tc_sfp_t.* = g_tc_sfp.*
 
        CALL g_tc_sfs.clear()
        LET g_rec_b = 0 
        CALL t001_ins_tc_sfs()
        CALL t001_b_fill(" 1=1")
        CALL t001_b()                   
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t001_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01=g_tc_sfp.tc_sfp01
    IF g_tc_sfp.tc_sfpconf ='Y' THEN    
       CALL cl_err(g_tc_sfp.tc_sfp01,9027,0)
       RETURN
    END IF
    IF g_tc_sfp.tc_sfpconf ='X' THEN    
       CALL cl_err(g_tc_sfp.tc_sfp01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_sfp01_t = g_tc_sfp.tc_sfp01
    LET g_tc_sfp_o.* = g_tc_sfp.*
    BEGIN WORK
 
    OPEN t001_cl USING g_tc_sfp.tc_sfp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_tc_sfp.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    WHILE TRUE
        LET g_tc_sfp01_t = g_tc_sfp.tc_sfp01
        LET g_tc_sfp.tc_sfpmodu=g_user
        LET g_tc_sfp.tc_sfpdate=g_today
        CALL t001_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_sfp.*=g_tc_sfp_t.*
            CALL t001_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tc_sfp.tc_sfp01 != g_tc_sfp01_t THEN            # 更改單號
            UPDATE tc_sfs_file SET tc_sfs01 = g_tc_sfp.tc_sfp01
                WHERE tc_sfs01 = g_tc_sfp01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('tc_sfs',SQLCA.sqlcode,0)    #No.FUN-660131
                CALL cl_err3("upd","tc_sfs_file",g_tc_sfp01_t,"",SQLCA.sqlcode,"","tc_sfs",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        UPDATE tc_sfp_file SET tc_sfp_file.* = g_tc_sfp.*
            WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5                         #No.FUN-680102 SMALLINT
   DEFINE l_x        LIKE type_file.num5
   DEFINE l_pmc03    LIKE pmc_file.pmc03
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030

   DISPLAY BY NAME g_tc_sfp.tc_sfp00,
      g_tc_sfp.tc_sfp01,g_tc_sfp.tc_sfpuser,g_tc_sfp.tc_sfpgrup,g_tc_sfp.tc_sfpmodu,g_tc_sfp.tc_sfpdate,
      g_tc_sfp.tc_sfpconf
       
   INPUT BY NAME 
      g_tc_sfp.tc_sfp02,g_tc_sfp.tc_sfp11,g_tc_sfp.tc_sfp12,g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04, #add tc_sfp11,tc_sfp12 by guanyao0517
      g_tc_sfp.tc_sfp05,g_tc_sfp.tc_sfp06,g_tc_sfp.tc_sfp07,g_tc_sfp.tc_sfp08,
      g_tc_sfp.tc_sfp09,g_tc_sfp.tc_sfp10,
      g_tc_sfp.tc_sfpuser,g_tc_sfp.tc_sfpgrup,g_tc_sfp.tc_sfpmodu,g_tc_sfp.tc_sfpdate,
      g_tc_sfp.tc_sfpud01,g_tc_sfp.tc_sfpud02,g_tc_sfp.tc_sfpud03,g_tc_sfp.tc_sfpud04,
      g_tc_sfp.tc_sfpud05,g_tc_sfp.tc_sfpud06,g_tc_sfp.tc_sfpud07,g_tc_sfp.tc_sfpud08,
      g_tc_sfp.tc_sfpud09,g_tc_sfp.tc_sfpud10,g_tc_sfp.tc_sfpud11,g_tc_sfp.tc_sfpud12,
      g_tc_sfp.tc_sfpud13,g_tc_sfp.tc_sfpud14,g_tc_sfp.tc_sfpud15
      WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t001_set_entry(p_cmd)
         CALL t001_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#str----add by guanyao160517
      AFTER FIELD tc_sfp11
         IF NOT cl_null(g_tc_sfp.tc_sfp11) THEN 
            IF g_tc_sfp.tc_sfp11 != g_tc_sfp_t.tc_sfp11 OR
                  g_tc_sfp_t.tc_sfp11 IS NULL THEN
               LET l_x = 0
               SELECT COUNT(*) INTO l_x FROM rva_file 
                WHERE rva01 = g_tc_sfp.tc_sfp11
                  AND rva10 = 'SUB'
                  AND rvaconf = 'Y'
               IF cl_null(l_x) OR l_x = 0 THEN 
                  CALL cl_err('','csf-007',0)
                  NEXT FIELD tc_sfp11
               END IF
               IF NOT cl_null(g_tc_sfp_t.tc_sfp12) THEN
                  LET g_err = 'Y'
                  CALL t001_tc_sfp11(g_tc_sfp.tc_sfp11,g_tc_sfp.tc_sfp12)
                  IF g_err = 'N' THEN 
                     NEXT FIELD tc_sfp11
                  END IF 
               END IF   
            END IF 
         END IF 

      AFTER FIELD tc_sfp12
         IF NOT cl_null(g_tc_sfp.tc_sfp12) THEN 
            IF NOT cl_null(g_tc_sfp.tc_sfp11) THEN
               LET g_err = 'Y' 
               CALL t001_tc_sfp11(g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04)
               IF g_err = 'N' THEN 
                  NEXT FIELD tc_sfp012
               END IF
            END IF 
         END IF
#end----add by guanyao160517

      AFTER FIELD tc_sfp03
         IF NOT cl_null(g_tc_sfp.tc_sfp03) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM pmm_file 
             WHERE pmm01 = g_tc_sfp.tc_sfp03 
               AND pmm18 = 'Y' 
               AND pmm02 = 'SUB'
            IF cl_null(l_x) OR l_x = 0 THEN 
                CALL cl_err('',g_errno,0)
                NEXT FIELD tc_sfp03
            END IF
            IF NOT cl_null(g_tc_sfp.tc_sfp04) THEN 
               LET g_err = 'Y'
               CALL t001_tc_sfp03(g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04)
               IF g_err = 'N' THEN 
                  NEXT FIELD tc_sfp03
               END IF 
            END IF 
         END IF

      AFTER FIELD tc_sfp04
         IF NOT cl_null(g_tc_sfp.tc_sfp04) THEN 
            IF NOT cl_null(g_tc_sfp.tc_sfp03) THEN
               LET g_err = 'Y' 
               CALL t001_tc_sfp03(g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04)
               IF g_err = 'N' THEN 
                  NEXT FIELD tc_sfp04
               END IF
            END IF 
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_tc_sfp.tc_sfpuser = s_get_data_owner("tc_sfp_file") #FUN-C10039
         LET g_tc_sfp.tc_sfpgrup = s_get_data_group("tc_sfp_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_sfp03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_tc_sfp03"
               LET g_qryparam.default1 = g_tc_sfp.tc_sfp03
               LET g_qryparam.default2 = g_tc_sfp.tc_sfp04
               CALL cl_create_qry() RETURNING g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04
               DISPLAY BY NAME g_tc_sfp.tc_sfp03
               DISPLAY BY NAME g_tc_sfp.tc_sfp04
               NEXT FIELD tc_sfp03
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
 
FUNCTION t001_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tc_sfp03,tc_sfp04",TRUE)
      END IF
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tc_sfp03,tc_sfp04",FALSE)
      END IF
 
END FUNCTION

FUNCTION t001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    INITIALIZE g_tc_sfp.* TO NULL                #FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tc_sfs.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t001_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN t001_count
    FETCH t001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
 
    OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfp.* TO NULL
    ELSE
        CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t001_cs INTO g_tc_sfp.tc_sfp01
        WHEN 'P' FETCH PREVIOUS t001_cs INTO g_tc_sfp.tc_sfp01
        WHEN 'F' FETCH FIRST    t001_cs INTO g_tc_sfp.tc_sfp01
        WHEN 'L' FETCH LAST     t001_cs INTO g_tc_sfp.tc_sfp01
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
            FETCH ABSOLUTE g_jump t001_cs INTO g_tc_sfp.tc_sfp01 --改g_jump
            LET g_no_ask = FALSE
 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfp.* TO NULL  #TQC-6B0105
        LET g_tc_sfp.tc_sfp01 = NULL      #TQC-6B0105
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

    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_tc_sfp.* TO NULL
        RETURN
    ELSE                                   
       LET g_data_owner=g_tc_sfp.tc_sfpuser       
       LET g_data_group=g_tc_sfp.tc_sfpgrup
    END IF
 
    CALL t001_show()
END FUNCTION
 
FUNCTION t001_show()
    DEFINE l_pmc03    LIKE pmc_file.pmc03
    DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680102 SMALLINT
    LET g_tc_sfp_t.* = g_tc_sfp.*                      #保存單頭舊值
    DISPLAY BY NAME                               
        g_tc_sfp.tc_sfp00,g_tc_sfp.tc_sfp01,g_tc_sfp.tc_sfp02,g_tc_sfp.tc_sfp03,
        g_tc_sfp.tc_sfp04,g_tc_sfp.tc_sfp05,g_tc_sfp.tc_sfp06,g_tc_sfp.tc_sfp07,
        g_tc_sfp.tc_sfp08,g_tc_sfp.tc_sfp09,g_tc_sfp.tc_sfp10,g_tc_sfp.tc_sfp11,g_tc_sfp.tc_sfp12,#add tc_sfp11,tc_sfp12 by guanyao160517 
        g_tc_sfp.tc_sfp13,   #add by guanyao160523
        g_tc_sfp.tc_sfpuser,g_tc_sfp.tc_sfpgrup,g_tc_sfp.tc_sfpmodu,
        g_tc_sfp.tc_sfpdate,g_tc_sfp.tc_sfpconf,
        g_tc_sfp.tc_sfpud01,g_tc_sfp.tc_sfpud02,g_tc_sfp.tc_sfpud03,g_tc_sfp.tc_sfpud04,
        g_tc_sfp.tc_sfpud05,g_tc_sfp.tc_sfpud06,g_tc_sfp.tc_sfpud07,g_tc_sfp.tc_sfpud08,
        g_tc_sfp.tc_sfpud09,g_tc_sfp.tc_sfpud10,g_tc_sfp.tc_sfpud11,g_tc_sfp.tc_sfpud12,
        g_tc_sfp.tc_sfpud13,g_tc_sfp.tc_sfpud14,g_tc_sfp.tc_sfpud15 
    SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_tc_sfp.tc_sfp05
    DISPLAY l_pmc03 TO pmc03
    CALL t001_b_fill(g_wc2)                
    CALL t001_pic()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t001_r()
DEFINE l_x   LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_x FROM ina_file WHERE ina10 = g_tc_sfp.tc_sfp01
    IF l_x > 0 THEN 
       CALL cl_err('','csf-002',0)
       RETURN 
    END IF 
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
    IF g_tc_sfp.tc_sfpconf = 'Y' THEN 
       CALL cl_err('','9023',0)
       RETURN 
    END IF
    IF g_tc_sfp.tc_sfpconf = 'X' THEN 
       CALL cl_err('','aom-000',0)
       RETURN 
    END IF  
    BEGIN WORK
 
    OPEN t001_cl USING g_tc_sfp.tc_sfp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_tc_sfp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tc_sfp01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tc_sfp.tc_sfp01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM tc_sfp_file WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
         DELETE FROM tc_sfs_file WHERE tc_sfs01 = g_tc_sfp.tc_sfp01
         INITIALIZE g_tc_sfp.* TO NULL
         CLEAR FORM
         CALL g_tc_sfs.clear()
 
         OPEN t001_count
         IF STATUS THEN
            CLOSE t001_cs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         FETCH t001_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t001_cs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t001_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t001_fetch('/')
         END IF
 
    END IF
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION

FUNCTION t001_x()
DEFINE l_tc_sfpconf    LIKE tc_sfp_file.tc_sfpconf
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_tc_sfp.tc_sfpconf = 'Y' THEN 
       CALL cl_err('','9023',0)
       RETURN 
    END IF
    BEGIN WORK
 
    OPEN t001_cl USING g_tc_sfp.tc_sfp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_tc_sfp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    IF g_tc_sfp.tc_sfpconf = 'X' THEN 
       LET l_tc_sfpconf = 'N' 
    ELSE 
       LET l_tc_sfpconf = 'Y'
    END IF 
    IF cl_exp(0,0,l_tc_sfpconf) THEN                   #確認一下
        LET g_chr=g_tc_sfp.tc_sfpconf
        IF g_tc_sfp.tc_sfpconf='N' THEN
            LET g_tc_sfp.tc_sfpconf='X'
        ELSE
            LET g_tc_sfp.tc_sfpconf='N'
        END IF
        UPDATE tc_sfp_file                   
            SET tc_sfpconf=g_tc_sfp.tc_sfpconf
            WHERE tc_sfp01=g_tc_sfp.tc_sfp01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_tc_sfp.tc_sfpconf=g_chr
        END IF
        DISPLAY BY NAME g_tc_sfp.tc_sfpconf 
    END IF
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION

FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)              #可刪除否
 
    LET g_ACTION_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01=g_tc_sfp.tc_sfp01
    IF g_tc_sfp.tc_sfpconf ='X' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_sfp.tc_sfp01,'aom-000',0)
       RETURN
    END IF
    IF g_tc_sfp.tc_sfpconf = 'Y' THEN 
       CALL cl_err(g_tc_sfp.tc_sfp01,'9023',0)
       RETURN
    END IF 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_sfs02,tc_sfs03,'','',tc_sfs04,tc_sfs05,tc_sfs06,tc_sfsud01,",
                       "       tc_sfsud02,tc_sfsud03,tc_sfsud04,tc_sfsud05,tc_sfsud06,tc_sfsud07,",
                       "       tc_sfsud08,tc_sfsud09,tc_sfsud10,tc_sfsud11,tc_sfsud12,tc_sfsud13,",
                       "       tc_sfsud14,tc_sfsud15",
                       "  FROM tc_sfs_file ",
                       " WHERE tc_sfs01=? AND tc_sfs02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_sfs WITHOUT DEFAULTS FROM s_tc_sfs.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'          
 
            BEGIN WORK
            OPEN t001_cl USING g_tc_sfp.tc_sfp01
            IF STATUS THEN
               CALL cl_err("OPEN t001_cl:", STATUS, 1)
               CLOSE t001_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t001_cl INTO g_tc_sfp.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t001_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_tc_sfs_t.* = g_tc_sfs[l_ac].*  #BACKUP
                OPEN t001_bcl USING g_tc_sfp.tc_sfp01,g_tc_sfs_t.tc_sfs02
                IF STATUS THEN
                   CALL cl_err("OPEN t001_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t001_bcl INTO g_tc_sfs[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_tc_sfs_t.tc_sfs02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   SELECT ima02,ima021 
                     INTO g_tc_sfs[l_ac].ima02,g_tc_sfs[l_ac].ima021
                     FROM ima_file WHERE ima01 =g_tc_sfs[l_ac].tc_sfs03
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_tc_sfs[l_ac].* TO NULL      #900423
            LET g_tc_sfs_t.* = g_tc_sfs[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_sfs02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO tc_sfs_file(tc_sfs01,tc_sfs02,tc_sfs03,tc_sfs04)
                         VALUES(g_tc_sfp.tc_sfp01,g_tc_sfs[l_ac].tc_sfs02,g_tc_sfs[l_ac].tc_sfs03,
                                g_tc_sfs[l_ac].tc_sfs04)
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_sfs_file",g_tc_sfs[l_ac].tc_sfs02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD tc_sfs02                        #default 序號
            IF g_tc_sfs[l_ac].tc_sfs02 IS NULL OR
               g_tc_sfs[l_ac].tc_sfs02 = 0 THEN
                 SELECT max(tc_sfs02)+1               #MOD-540144
                   INTO g_tc_sfs[l_ac].tc_sfs02
                   FROM tc_sfs_file
                   WHERE tc_sfs01 = g_tc_sfp.tc_sfp01
                IF g_tc_sfs[l_ac].tc_sfs02 IS NULL THEN
                    LET g_tc_sfs[l_ac].tc_sfs02 = 1
                END IF
            END IF
 
        AFTER FIELD tc_sfs02                        #check 序號是否重複
            IF NOT cl_null(g_tc_sfs[l_ac].tc_sfs02) THEN
               IF g_tc_sfs[l_ac].tc_sfs02 != g_tc_sfs_t.tc_sfs02 OR
                  g_tc_sfs_t.tc_sfs02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tc_sfs_file
                    WHERE tc_sfs01 = g_tc_sfp.tc_sfp01 AND
                          tc_sfs02 = g_tc_sfs[l_ac].tc_sfs02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_tc_sfs[l_ac].tc_sfs02 = g_tc_sfs_t.tc_sfs02
                      NEXT FIELD tc_sfs02
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_sfs_t.tc_sfs02 > 0 AND
               g_tc_sfs_t.tc_sfs02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM tc_sfs_file
                WHERE tc_sfs01 = g_tc_sfp.tc_sfp01 AND
                      tc_sfs02 = g_tc_sfs_t.tc_sfs02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tc_sfs_file",g_tc_sfs_t.tc_sfs02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete Ok"
               CLOSE t001_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_sfs[l_ac].* = g_tc_sfs_t.*
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_sfs[l_ac].tc_sfs02,-263,1)
               LET g_tc_sfs[l_ac].* = g_tc_sfs_t.*
            ELSE
               UPDATE tc_sfs_file SET tc_sfs05=g_tc_sfs[l_ac].tc_sfs05 
                WHERE tc_sfs01=g_tc_sfp.tc_sfp01 
                  AND tc_sfs02=g_tc_sfs_t.tc_sfs02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_sfs_file",g_tc_sfs[l_ac].tc_sfs02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_tc_sfs[l_ac].* = g_tc_sfs_t.*
                  CLOSE t001_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t001_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_sfs[l_ac].* = g_tc_sfs_t.*
               ELSE
                  CALL g_tc_sfs.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_ACTION_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF

               END IF
               CLOSE t001_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac                #FUN-D40030 Add
           CLOSE t001_bcl
           COMMIT WORK
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(tc_sfs03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_tc_sfs[l_ac].tc_sfs03
                     CALL cl_create_qry() RETURNING g_tc_sfs[l_ac].tc_sfs03
                     DISPLAY BY NAME g_tc_sfs[l_ac].tc_sfs03
                     NEXT FIELD tc_sfs03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_sfs02) AND l_ac > 1 THEN
               LET g_tc_sfs[l_ac].* = g_tc_sfs[l_ac-1].*
               SELECT max(tc_sfs02)+1 INTO g_tc_sfs[l_ac].tc_sfs02 FROM tc_sfs_file
                WHERE tc_sfs01 = g_tc_sfp.tc_sfp01
               DISPLAY BY NAME g_tc_sfs[l_ac].tc_sfs02, g_tc_sfs[l_ac].tc_sfs03
               NEXT FIELD tc_sfs02
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
 
    LET g_tc_sfp.tc_sfpmodu = g_user
    LET g_tc_sfp.tc_sfpdate = g_today
    UPDATE tc_sfp_file SET tc_sfpmodu = g_tc_sfp.tc_sfpmodu,tc_sfpdate = g_tc_sfp.tc_sfpdate
     WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
    DISPLAY BY NAME g_tc_sfp.tc_sfpmodu,g_tc_sfp.tc_sfpdate
 
    CLOSE t001_bcl
    CLOSE t001_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t001_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2          STRING       #No.FUN-680102CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 =" 1=1"  END IF #MOD-8A0032
    LET g_sql =
        "SELECT tc_sfs02,tc_sfs03,ima02,ima021,tc_sfs04,tc_sfs05,tc_sfs06,tc_sfsud01,",
        "       tc_sfsud02,tc_sfsud03,tc_sfsud04,tc_sfsud05,tc_sfsud06,tc_sfsud07,tc_sfsud08,",
        "       tc_sfsud09,tc_sfsud10,tc_sfsud11,tc_sfsud12,tc_sfsud13,tc_sfsud14,tc_sfsud15",
        " FROM tc_sfs_file LEFT JOIN ima_file ON ima01 = tc_sfs03 ",
        " WHERE tc_sfs01 ='",g_tc_sfp.tc_sfp01,"' AND ",p_wc2 CLIPPED,                     
        " ORDER BY tc_sfs02"
    PREPARE t001_pb FROM g_sql
    DECLARE tc_sfs_curs                       #SCROLL CURSOR
        CURSOR FOR t001_pb
 
    CALL g_tc_sfs.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH tc_sfs_curs INTO g_tc_sfs[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_sfs.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION

FUNCTION t001_confirm()
DEFINE l_x     LIKE type_file.num5
DEFINE g_t1    LIKE smy_file.smyslip   #add by guanyao160810 

IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01= g_tc_sfp.tc_sfp01
    LET g_t1=s_get_doc_no(g_tc_sfp.tc_sfp01)  #add by guanyao160810
    IF g_tc_sfp.tc_sfpconf = 'Y' THEN 
       CALL cl_err('','9023',0)
       RETURN 
    END IF 
    IF g_tc_sfp.tc_sfpconf = 'X' THEN 
       CALL cl_err('','9024',0)
       RETURN 
    END IF
    #str-----add by guanyao160705
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01 = g_tc_sfp.tc_sfp01
    IF l_x = 0 OR cl_null(l_x) THEN
       CALL cl_err('','csf-034',0)
       RETURN  
    END IF 
    #end-----add by guanyao160705
    BEGIN WORK
    LET  g_success = 'Y' 
    OPEN t001_cl USING g_tc_sfp.tc_sfp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_tc_sfp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    IF cl_confirm('axm-108') THEN                  #確認一下
        UPDATE tc_sfp_file                   
            SET tc_sfpconf='Y'
            WHERE tc_sfp01=g_tc_sfp.tc_sfp01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        END IF
    ELSE 
       RETURN 
    END IF
    #str-----add by guanyao160705
    IF g_t1 !='ZZZ' THEN 
    IF g_success = 'Y' THEN 
       CALL t001_ins_ina(g_tc_sfp.tc_sfp00,g_tc_sfp.tc_sfp01)
    END IF
    END IF 
    #end-----add by guanyao160705
    CLOSE t001_cl
    IF g_success = 'Y' THEN 
       COMMIT WORK
       LET g_tc_sfp.tc_sfpconf = 'Y'
       DISPLAY BY NAME g_tc_sfp.tc_sfpconf
    ELSE
       ROLLBACK WORK 
    END IF 
    CALL t001_show()

END FUNCTION 

FUNCTION t001_undo_confirm()
DEFINE l_ina01       LIKE ina_file.ina01
DEFINE l_inaconf     LIKE ina_file.inaconf
DEFINE l_inapost     LIKE ina_file.inapost 
DEFINE l_prog_1      LIKE type_file.chr10
DEFINE l_pmm25       LIKE pmm_file.pmm25    #add by guanyao160707
DEFINE l_x           LIKE type_file.num5    #add by guanyao160707
DEFINE g_t1    LIKE smy_file.smyslip   #add by guanyao160810 

IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfp.tc_sfp01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01= g_tc_sfp.tc_sfp01
    LET g_t1=s_get_doc_no(g_tc_sfp.tc_sfp01)  #add by guanyao160810
    IF g_tc_sfp.tc_sfpconf = 'N' THEN 
       RETURN 
    END IF 
    IF g_tc_sfp.tc_sfpconf = 'X' THEN 
       CALL cl_err('','9024',0)
       RETURN 
    END IF
    #str--------add by guanyao160707
    IF g_tc_sfp.tc_sfp00= '1' THEN 
       IF g_tc_sfp.tc_sfp13>0 THEN 
          LET l_pmm25 ='' 
          SELECT pnaconf INTO l_pmm25 FROM pna_file WHERE pna01 = g_tc_sfp.tc_sfp03 AND pna02 = g_tc_sfp.tc_sfp13
          IF l_pmm25 = 'Y' THEN 
             CALL cl_err('','cpm-044',0)
             RETURN 
          END IF  
       ELSE
          LET l_pmm25 = ''
          SELECT pmm25 INTO l_pmm25 FROM pmm_file WHERE pmm01 =  g_tc_sfp.tc_sfp03  
          IF l_pmm25 !='1' THEN 
             CALL cl_err('','csf-037',0)
             RETURN 
          END IF  
       END IF 
    ELSE 
       IF g_tc_sfp.tc_sfp13>0 THEN 
          LET l_pmm25 ='' 
          SELECT pnaconf INTO l_pmm25 FROM pna_file WHERE pna01 = g_tc_sfp.tc_sfp03 AND pna02 = g_tc_sfp.tc_sfp13
          IF l_pmm25 = 'Y' THEN 
             CALL cl_err('','cpm-044',0)
             RETURN 
          END IF
       ELSE           
          LET l_x = 0
          SELECT COUNT(*) INTO l_x FROM rvu_file 
           WHERE rvu01 = g_tc_sfp.tc_sfp11 
             AND rvuconf='Y'
          IF l_x >0 THEN 
             CALL cl_err('','cpm-040',0)
             RETURN 
          END IF 
       END IF 
    END IF  
    #end--------add by guanyao160707
    BEGIN WORK
    LET g_success = 'Y' 
 
    OPEN t001_cl USING g_tc_sfp.tc_sfp01
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_tc_sfp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfp.tc_sfp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    IF cl_confirm('axm-109') THEN                  #確認一下
        UPDATE tc_sfp_file                   
            SET tc_sfpconf='N'
            WHERE tc_sfp01=g_tc_sfp.tc_sfp01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        END IF
    ELSE 
       RETURN 
    END IF
    #str------add by guanyao160513
    IF g_t1 !='ZZZ' THEN 
    IF g_success = 'Y' THEN 
       LET l_prog_1 = g_prog
       IF g_tc_sfp.tc_sfp00 = '1' THEN        
          LET g_prog = 'aimt302'
       ELSE 
          LET g_prog = 'aimt301'
       END IF 
       LET l_ina01 = ''
       LET l_inaconf = ''
       LET l_inapost = ''
       SELECT ina01,inaconf,inapost INTO l_ina01,l_inaconf,l_inapost FROM ina_file WHERE ina10 = g_tc_sfp.tc_sfp01
          IF l_inaconf <> 'Y' THEN 
             CALL cl_err('','csf-035',0)
             LET g_success = 'N' 
          END IF 
          IF l_inapost <>'Y' THEN 
             CALL cl_err('','csf-036',0)
             LET g_success = 'N' 
          END IF 
          CALL t001_ina_undo_post(l_ina01)
          IF g_success = 'Y' THEN 
             CALL t370sub_z(l_ina01,'N',TRUE)
             IF g_success='Y' THEN 
                CALL t001_ina_r(l_ina01) 
             END IF  
          END IF 
       LET g_prog = l_prog_1
    END IF 
    END IF 
#end------add by guanyao160513
    CLOSE t001_cl
    IF g_success = 'Y' THEN 
       COMMIT WORK
       LET g_tc_sfp.tc_sfpconf = 'N'
       DISPLAY BY NAME g_tc_sfp.tc_sfpconf
    ELSE 
       ROLLBACK WORK 
    END IF 
    CALL t001_show()

END FUNCTION 
 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_ACTION_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_ACTION_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sfs TO s_tc_sfs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_ACTION_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_ACTION_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_ACTION_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_ACTION_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST                             
      ON ACTION invalid
         LET g_ACTION_choice="invalid"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_ACTION_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_ACTION_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_ACTION_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_ACTION_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output
         LET g_ACTION_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_ACTION_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_ACTION_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_ACTION_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_ACTION_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_ACTION_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
       ON ACTION related_document  #No.MOD-470515
         LET g_ACTION_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_ACTION_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t001_ins_tc_sfs()
DEFINE l_bma06     LIKE bma_file.bma06
DEFINE l_bmb06     LIKE bmb_file.bmb06
DEFINE l_bmb03     LIKE bmb_file.bmb03
DEFINE l_bmb10     LIKE bmb_file.bmb10
DEFINE l_sql       STRING 
DEFINE l_x         LIKE type_file.num5
  
    SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
    LET l_bma06=''
    SELECT bma06 INTO l_bma06 FROM bma_file WHERE bma01 = g_tc_sfp.tc_sfp08
    DELETE FROM t001_omb
    CALL t001_bom(0,g_tc_sfp.tc_sfp08,l_bma06,g_tc_sfp.tc_sfp09)
    LET l_sql = " SELECT bmb03,bmb06,bmb10 FROM t001_omb"
    PREPARE t001_omb_pb FROM l_sql
    DECLARE t001_omb_curs CURSOR FOR t001_omb_pb
    LET l_bmb03 =''
    LET l_bmb06 =''
    LET l_bmb10 =''
    LET l_x = 1
    FOREACH t001_omb_curs INTO l_bmb03,l_bmb06,l_bmb10
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       INSERT INTO tc_sfs_file(tc_sfs01,tc_sfs02,tc_sfs03,tc_sfs04,tc_sfs05,tc_sfs06)
            VALUES(g_tc_sfp.tc_sfp01,l_x,l_bmb03,l_bmb06,l_bmb06,l_bmb10)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","tc_sfs_file",l_x,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       END IF 
       LET l_x = l_x + 1
    END FOREACH 
END FUNCTION 

FUNCTION t001_bom(p_level,p_key,p_key2,p_total)
   DEFINE p_level	LIKE type_file.num5,
          p_key		LIKE bma_file.bma01,
          p_key2        LIKE ima_file.ima910,  
          p_total       LIKE oqa_file.oqa10,
          l_fac         LIKE bmb_file.bmb10_fac,
          l_gfe03       LIKE gfe_file.gfe03,
          m_ac,m	LIKE type_file.num5,    
          arrno		LIKE type_file.num5,    
          l_chr		LIKE type_file.chr1,   
          sr1 DYNAMIC ARRAY OF RECORD           #每階存放資料
              level	LIKE type_file.num5,    #No.FUN-680137 SMALLINT
              bmb02     LIKE bmb_file.bmb02,    #項次
              bmb03     LIKE bmb_file.bmb03,    #元件料號
              bmb10     LIKE bmb_file.bmb10,    #元件料號No.8746
              bmb06     LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08     LIKE bmb_file.bmb08,
              bmb081    LIKE bmb_file.bmb081,
              bmb082    LIKE bmb_file.bmb082,
              bmb13     LIKE bmb_file.bmb13,    #插件位置
              bma01     LIKE bma_file.bma01,    #No.MOD-490217
              ima02     LIKE ima_file.ima02,
              ima021    LIKE ima_file.ima021,
              ima25     LIKE ima_file.ima25,
              ima55     LIKE ima_file.ima55,     #No.8746
              ima08     LIKE ima_file.ima08
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(600)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE l_total       LIKE sfa_file.sfa07 
    DEFINE l_ActualQPA   LIKE bmb_file.bmb06 
    DEFINE l_QPA         LIKE bmb_file.bmb06
    DEFINE l_x           LIKE type_file.num5
    
 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) RETURN END IF
    LET p_level = p_level + 1
    LET arrno = 600	
    LET l_cmd= "SELECT 0,bmb02,bmb03,bmb10,(bmb06/bmb07),bmb08,bmb081,bmb082,bmb13,bma01,",   #yemy 20130513
               "       ima02,ima021,ima25,ima55,ima08 ",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03=bma_file.bma01 ",
               "                                        AND bmb_file.bmb29=bma_file.bma06 ", #MOD-930084
               "                LEFT OUTER JOIN ima_file ON bmb_file.bmb03=ima_file.ima01 ",   #MOD-A50052
               " WHERE bmb01='", p_key,"'",
               "   AND (bmb03 LIKE 'E%' OR bmb03 LIKE 'K%' OR (ima06 = 'BCP' AND bmb03 NOT LIKE '%-%')) ",  #add by guanyao160810  #add ) by guanyao160825
               "   AND bmb29 ='",p_key2,"' "  #FUN-550110  #str--add byhuanglf160824
    #No.MOD-A60134  --End  
    #---->生效日及失效日的判斷
    LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED," ORDER BY bmb02"
    PREPARE t310_precur FROM l_cmd
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE t310_cur CURSOR FOR t310_precur
    LET m_ac = 1
    CALL sr1.clear()
    FOREACH t310_cur INTO sr1[m_ac]. *     	# 先將BOM單身存入BUFFER
        LET l_ima910[m_ac]=''
        SELECT ima910 INTO l_ima910[m_ac] FROM ima_file WHERE ima01=sr1[m_ac].bmb03
        IF cl_null(l_ima910[m_ac]) THEN LET l_ima910[m_ac]=' ' END IF
        LET m_ac = m_ac + 1
        IF m_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR m = 1 TO m_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr1[m].level = p_level
        CALL cralc_rate(p_key,sr1[m].bmb03,p_total,sr1[m].bmb081,sr1[m].bmb08,sr1[m].bmb082,sr1[m].bmb06,1)
             RETURNING l_total,l_QPA,l_ActualQPA
        LET sr1[m].bmb06=l_total
        #str-----add by guanyao160803
        #LET l_x = 0
        #SELECT COUNT(*) INTO l_x  FROM bma_file WHERE bma01= sr1[m].bmb03
        #IF cl_null(l_x) OR l_x = 0 THEN 
        #end-----add by guanyao160803
           INSERT INTO t001_omb VALUES (sr1[m].level,sr1[m].bmb02,sr1[m].bmb03,sr1[m].bmb06,sr1[m].bmb10,sr1[m].bma01)           
        #END IF #mark by guanyao160803
        #CALL t001_bom(p_level,sr1[m].bmb03,l_ima910[m],sr1[m].bmb06)   #mark by guanyao160726
        
    END FOR
END FUNCTION 

FUNCTION t001_tc_sfp03(p_tc_sfp03,p_tc_sfp04)
DEFINE l_x          LIKE type_file.num5
DEFINE p_tc_sfp03   LIKE tc_sfp_file.tc_sfp03
DEFINE p_tc_sfp04   LIKE tc_sfp_file.tc_sfp04
DEFINE l_pmc03      LIKE pmc_file.pmc03

     LET l_x = 0
     SELECT COUNT(*) INTO l_x FROM pmm_file,pmn_file 
      WHERE pmm01 = p_tc_sfp03 
        AND pmn02 = p_tc_sfp04
        AND pmm18 = 'Y' 
        AND pmm02 = 'SUB'
        AND pmn01 = pmm01
     IF cl_null(l_x) OR l_x = 0 THEN 
        CALL cl_err('','csf-005',0)
        LET g_err = 'N'
        RETURN
     END IF
     LET l_x =0
     SELECT count(*) INTO l_x FROM tc_sfp_file 
      WHERE tc_sfp03 = p_tc_sfp03
        AND tc_sfp04 = p_tc_sfp04
        AND tc_sfpconf = 'Y'   #add by guanyao160517
        AND tc_sfp00 ='1'      #add by guanyao160517
     IF l_x > 0 THEN
        CALL cl_err('','csf-003',0)
        LET g_err = 'N'
        RETURN
     END IF 
     #SELECT pmm09,pmc03,pmn41,pmnud04,pmn04,pmn20    #mark by guanyao160801
     SELECT pmm09,pmc03,pmn41,pmn18,pmn04,pmn20     #add by guanyao160801
       INTO g_tc_sfp.tc_sfp05,l_pmc03,g_tc_sfp.tc_sfp06,g_tc_sfp.tc_sfp07,g_tc_sfp.tc_sfp08,g_tc_sfp.tc_sfp09
       FROM pmn_file,pmm_file LEFT JOIN pmc_file ON pmc01 = pmm09
      WHERE pmn01= pmm01 
        AND pmm01= p_tc_sfp03
        AND pmn02= p_tc_sfp04
     DISPLAY BY NAME g_tc_sfp.tc_sfp05
     DISPLAY l_pmc03 TO pmc03
     DISPLAY BY NAME g_tc_sfp.tc_sfp06
     DISPLAY BY NAME g_tc_sfp.tc_sfp07
     DISPLAY BY NAME g_tc_sfp.tc_sfp08
     DISPLAY BY NAME g_tc_sfp.tc_sfp09
END FUNCTION 

#str---add by guanyao160517
FUNCTION t001_tc_sfp11(p_tc_sfp11,p_tc_sfp12)
DEFINE p_tc_sfp11        LIKE tc_sfp_file.tc_sfp11
DEFINE p_tc_sfp12        LIKE tc_sfp_file.tc_sfp12
DEFINE l_x               LIKE type_file.num5
DEFINE l_pmc03           LIKE pmc_file.pmc03 

    LET l_x = 0
    SELECT COUNT(*) INTO l_x  FROM rva_file,rvb_file 
     WHERE rva01 = rvb01
       AND rvb01 = p_tc_sfp11
       AND rvb02 = p_tc_sfp12
       AND rva10 = 'SUB'
       AND rvaconf = 'Y' 
    IF cl_null(l_x) OR l_x = 0 THEN 
       CALL cl_err('','csf-007',0)
       LET g_err = 'N'
       RETURN
    END IF
    LET l_x = 0 
    SELECT COUNT(*) INTO l_x FROM tc_sfp_file 
     WHERE tc_sfp11 = p_tc_sfp11
       AND tc_sfp12 = p_tc_sfp12
       AND tc_sfpconf = 'Y' 
       AND tc_sfp00 = '2' 
    IF l_x > 0 THEN 
       CALL cl_err('','csf-008',0)
       LET g_err = 'N' 
       RETURN 
    END IF 
    #SELECT rvb04,rvb03,rva05,pmc03,rvb34,pmnud04,rvb05,rvb07 #mark by guanyao160801
    SELECT rvb04,rvb03,rva05,pmc03,rvb34,pmnud18,rvb05,rvb07  #add by guanyao160801
      INTO g_tc_sfp.tc_sfp03,g_tc_sfp.tc_sfp04,g_tc_sfp.tc_sfp05,l_pmc03,g_tc_sfp.tc_sfp06,
           g_tc_sfp.tc_sfp07,g_tc_sfp.tc_sfp08,g_tc_sfp.tc_sfp09
      FROM rvb_file,pmn_file,rva_file LEFT JOIN pmc_file ON pmc01 = rva05
     WHERE rva01 =p_tc_sfp11
       AND rvb02 =p_tc_sfp12
       AND rva01 =rvb01
       AND pmn01 =rvb04
       AND pmn02 =rvb03
    DISPLAY BY NAME g_tc_sfp.tc_sfp03
    DISPLAY BY NAME g_tc_sfp.tc_sfp04
    DISPLAY BY NAME g_tc_sfp.tc_sfp05
    DISPLAY l_pmc03 TO pmc03
    DISPLAY BY NAME g_tc_sfp.tc_sfp06
    DISPLAY BY NAME g_tc_sfp.tc_sfp07
    DISPLAY BY NAME g_tc_sfp.tc_sfp08
    DISPLAY BY NAME g_tc_sfp.tc_sfp09


END FUNCTION 
#end---add by guanyao160517

FUNCTION t001_ins_tc_sfp(p_argv1,p_argv2,p_argv3,p_argv4)
DEFINE p_argv1        LIKE type_file.chr1
DEFINE p_argv2        LIKE pmn_file.pmn01
DEFINE p_argv3        LIKE pmn_file.pmn02
DEFINE p_argv4        LIKE pmn_file.pmn02  #add by guanyao160523
DEFINE l_tc_sfp       RECORD LIKE tc_sfp_file.*
DEFINE l_tc_sfp01     LIKE tc_sfp_file.tc_sfp01
DEFINE l_y            LIKE type_file.chr20 
DEFINE l_m            LIKE type_file.chr20
DEFINE l_str          LIKE type_file.chr20
DEFINE l_tmp          LIKE type_file.chr20
DEFINE l_x            LIKE type_file.num5

   LET l_tc_sfp01 = ''
   IF g_argv1 = '1' THEN 
      SELECT tc_sfp01 INTO l_tc_sfp01 FROM tc_sfp_file 
       WHERE tc_sfp03 = p_argv2 
       AND tc_sfp04 = p_argv3 
       AND tc_sfp13 = p_argv4 #add by guanyao160523                                                      
   END IF 
   IF g_argv1= '2' THEN 
      #str----add by guanyao160707  #采购单版本更新的时候还是采购单
      IF p_argv4 > 0 THEN
         SELECT tc_sfp01 INTO l_tc_sfp01 FROM tc_sfp_file 
          WHERE tc_sfp03 = p_argv2 
            AND tc_sfp04 = p_argv3 
            AND tc_sfp13 = p_argv4 #add by guanyao160523       
      ELSE  
      #end----add by guanyao160707
         SELECT tc_sfp01 INTO l_tc_sfp01 FROM tc_sfp_file 
          WHERE tc_sfp11 = p_argv2 
            AND tc_sfp12 = p_argv3 
            AND tc_sfp13 = p_argv4 #add by guanyao160523 
      END IF 
   END IF 
   IF NOT cl_nulL(l_tc_sfp01) THEN
      LET g_tc_sfp.tc_sfp01 = l_tc_sfp01
      SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = g_tc_sfp.tc_sfp01
      CALL t001_show()
   ELSE 
      #自动编码----
      LET l_y =YEAR(g_today)
      LET l_y = l_y[3,4] USING '&&' 
      LET l_m =MONTH(g_today)
      LET l_m = l_m USING '&&' 
      IF g_argv1 = '1' THEN
         LET l_str='XXX-',l_y clipped,l_m CLIPPED
      END IF 
      IF g_argv1 = '2' THEN
         LET l_str='YYY-',l_y clipped,l_m CLIPPED
      END IF
      SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
       WHERE substr(tc_sfp01,1,8)=l_str
      IF cl_null(l_tmp) THEN 
         LET l_tmp = '0001' 
      ELSE 
         LET l_tmp = l_tmp + 1
         LET l_tmp = l_tmp USING '&&&&'     
      END IF 
      LET l_tc_sfp.tc_sfp01 = l_str clipped,l_tmp
      #------
      LET l_tc_sfp.tc_sfp02 = g_today
      IF g_argv1 = '2' THEN 
         #str--add by guanyao160523
         IF p_argv4>0 THEN 
            LET l_tc_sfp.tc_sfp03 = p_argv2
            LET l_tc_sfp.tc_sfp04 = p_argv3
         ELSE 
         #end--add by guanyao160523
            LET l_tc_sfp.tc_sfp11 = p_argv2
            LET l_tc_sfp.tc_sfp12 = p_argv3
         END IF 
      END IF 
      IF g_argv1 = '1' THEN  
         LET l_tc_sfp.tc_sfp03 = p_argv2
         LET l_tc_sfp.tc_sfp04 = p_argv3
      END IF 
      LET l_tc_sfp.tc_sfp02=g_today
      LET l_tc_sfp.tc_sfpuser=g_user
      LET l_tc_sfp.tc_sfpgrup=g_grup
      LET l_tc_sfp.tc_sfpdate=g_today
      LET l_tc_sfp.tc_sfpconf = 'N'
      LET l_tc_sfp.tc_sfp00=g_argv1
      IF g_argv1 = '1' THEN
         #str-----add by guanyao160523
         IF p_argv4>0 THEN 
            #SELECT pmm09,pmn41,pmnud04,pmn04   #mark by guanyao160801 
            SELECT pmm09,pmn41,pmn18,pmn04      #add by guanyao160801
              INTO l_tc_sfp.tc_sfp05,l_tc_sfp.tc_sfp06,l_tc_sfp.tc_sfp07,l_tc_sfp.tc_sfp08
              FROM pmn_file,pmm_file 
             WHERE pmn01= pmm01 
               AND pmm01= l_tc_sfp.tc_sfp03 
               AND pmn02= l_tc_sfp.tc_sfp04 
            SELECT pnb20a INTO l_tc_sfp.tc_sfp09
              FROM pnb_file 
             WHERE pnb01 = l_tc_sfp.tc_sfp03 
               AND pnb02 = g_argv4
               AND pnb03 = l_tc_sfp.tc_sfp04
         ELSE  
         #end-----add by guanyao160523
            #SELECT pmm09,pmn41,pmnud04,pmn04,pmn20  #mark by guanyao160801 
            SELECT pmm09,pmn41,pmn18,pmn04,pmn20  #add by guanyao160801 
              INTO l_tc_sfp.tc_sfp05,l_tc_sfp.tc_sfp06,l_tc_sfp.tc_sfp07,l_tc_sfp.tc_sfp08,l_tc_sfp.tc_sfp09
              FROM pmn_file,pmm_file 
             WHERE pmn01= pmm01 
               AND pmm01= l_tc_sfp.tc_sfp03 
               AND pmn02= l_tc_sfp.tc_sfp04
         END IF 
      END IF 
      IF g_argv1 = '2' THEN 
         #str-----add by guanyao160523
         IF p_argv4>0 THEN 
            #SELECT pmm09,pmn41,pmnud04,pmn04    #mark by guanyao160801
            SELECT pmm09,pmn41,pmn18,pmn04    #mark by guanyao160801
              INTO l_tc_sfp.tc_sfp05,l_tc_sfp.tc_sfp06,l_tc_sfp.tc_sfp07,l_tc_sfp.tc_sfp08
              FROM pmn_file,pmm_file 
             WHERE pmn01= pmm01 
               AND pmm01= l_tc_sfp.tc_sfp03 
               AND pmn02= l_tc_sfp.tc_sfp04 
            SELECT pnb20a INTO l_tc_sfp.tc_sfp09
              FROM pnb_file 
             WHERE pnb01 = l_tc_sfp.tc_sfp03 
               AND pnb02 = g_argv4
               AND pnb03 = l_tc_sfp.tc_sfp04
         ELSE
         #end-----add by guanyao160523 
            #SELECT rvb04,rvb03,rva05,rvb34,pmnud04,rvb05,rvb07   #mark by guanyao160801
            SELECT rvb04,rvb03,rva05,rvb34,pmn18,rvb05,rvb07    #add by guanyao160801
              INTO l_tc_sfp.tc_sfp03,l_tc_sfp.tc_sfp04,l_tc_sfp.tc_sfp05,l_tc_sfp.tc_sfp06,
                   l_tc_sfp.tc_sfp07,l_tc_sfp.tc_sfp08,l_tc_sfp.tc_sfp09
              FROM rvb_file,pmn_file,rva_file LEFT JOIN pmc_file ON pmc01 = rva05
             WHERE rva01 =l_tc_sfp.tc_sfp11
               AND rvb02 =l_tc_sfp.tc_sfp12
               AND rva01 =rvb01
               AND pmn01 =rvb04
               AND pmn02 =rvb03
         END IF 
      END IF 
      LET l_tc_sfp.tc_sfp13 = p_argv4
      LET l_tc_sfp.tc_sfpplant = g_plant
      LET l_tc_sfp.tc_sfplegal = g_legal
      INSERT INTO tc_sfp_file VALUES (l_tc_sfp.*)
      IF SQLCA.sqlcode THEN   
         CALL cl_err3("ins","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
         RETURN
      END IF
      SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = l_tc_sfp.tc_sfp01
      CALL t001_ins_tc_sfs()
      SELECT count(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01= g_tc_sfp.tc_sfp01 
      IF cl_null(l_x) OR l_x = 0 THEN 
         CALL cl_err('','csf-004',0)
         DELETE FROM tc_sfp_file WHERE tc_sfp01= g_tc_sfp.tc_sfp01 
         RETURN 
      END IF 
      CALL t001_show()
   END IF 
END FUNCTION 

FUNCTION t001_pic()
DEFINE l_chr1      LIKE type_file.chr1    #TQC-C50221 add
DEFINE l_chr2      LIKE type_file.chr1    #CHI-C60033 add


     CALL cl_set_field_pic1(g_tc_sfp.tc_sfpconf,"","","","","","","")
END FUNCTION

#str----add by guanyao160705
FUNCTION t001_ins_ina(p_tc_sfp00,p_tc_sfp01)
DEFINE l_tc_sfs    RECORD LIKE tc_sfs_file.*
DEFINE l_ina       RECORD LIKE ina_file.*
DEFINE l_inb       RECORD LIKE inb_file.*
DEFINE li_result   LIKE type_file.num5
DEFINE p_tc_sfp01  LIKE tc_sfp_file.tc_sfp01
DEFINE p_tc_sfp00  LIKE tc_sfp_file.tc_sfp00
DEFINE l_slip      LIKE smy_file.smyslip
DEFINE l_i         LIKE type_file.num5
DEFINE l_to_prog   LIKE type_file.chr10
DEFINE l_x         LIKE type_file.num5
DEFINE l_a         LIKE type_file.chr1
DEFINE l_z         LIKE type_file.chr1
DEFINE l_inb15     LIKE inb_file.inb15
DEFINE l_chr       LIKE type_file.chr20
DEFINE l_tc_sfs05  LIKE tc_sfs_file.tc_sfs05  #add by guanyao160920
DEFINE l_img10_sum LIKE img_file.img10        #add by guanyao160920
DEFINE l_img       RECORD LIKE img_file.*     #add by guanyao160920
DEFINE l_sql       STRING 
   
   LET g_success = 'Y'
   IF p_tc_sfp00 = '1' THEN 
      LET l_a = '2'
      LET l_z = '3'
   ELSE 
      LET l_a = '1'
      LET l_z = '1'
   END IF 
   SELECT smyslip INTO l_slip FROM smy_file WHERE smysys = 'aim' AND smykind = l_a  
   IF cl_null(l_slip) THEN 
      CALL cl_err('','cpm-008',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   CALL s_check_no("aim",l_slip,'',l_a,"ina_file","ina01","")
      RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-009',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina02  =g_today
   LET l_ina.ina03  =g_today
   CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,l_a,"ina_file","ina01","","","") 
     RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-010',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina00  =l_z
   LET l_ina.ina04  =g_grup  
   LET l_ina.inapost='N'
   LET l_ina.inaconf='N'     #FUN-660079
   LET l_ina.inaspc ='0'     #FUN-680010
   LET l_ina.inauser=g_user
   LET l_ina.inaoriu = g_user 
   LET l_ina.inaorig = g_grup 
   LET l_ina.inagrup=g_grup
   LET l_ina.inadate=g_today
   LET l_ina.ina08 = '0'           #開立  #FUN-550047
   LET l_ina.inamksg = 'N'         #簽核否#FUN-550047
   LET l_ina.ina12='N'       #No.FUN-870100
   LET l_ina.inapos='N'       #No.FUN-870100
   LET l_ina.inacont=''       #No.FUN-870100
   LET l_ina.inaconu=''       #No.FUN-870100
   LET l_ina.ina11=g_user
   LET l_ina.ina08 = 'N'
   LET l_ina.ina13 = ' '
   LET l_ina.ina10=p_tc_sfp01
   LET l_ina.inaplant = g_plant #FUN-980004 add
   LET l_ina.inalegal = g_legal
   INSERT INTO ina_file VALUES(l_ina.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",l_ina.ina01,"",SQLCA.sqlcode,"","ins ina",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   #str----add by guanyao160518
   UPDATE tc_sfp_file SET tc_sfp10 = l_ina.ina01
    WHERE tc_sfp01 = l_ina.ina10
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","tc_sfp_file",l_ina.ina10,"",SQLCA.sqlcode,"","ins tc_sfp",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   #end----add by guanyao160518
   LET l_i = 1
   DECLARE p610_sub_tc_sfp CURSOR FOR 
         SELECT * FROM tc_sfs_file 
          WHERE tc_sfs01 =p_tc_sfp01 
     FOREACH p610_sub_tc_sfp INTO l_tc_sfs.*
        LET l_inb15 = ''
        SELECT imd01 INTO l_inb15 FROM imd_file WHERE imd01 = g_tc_sfp.tc_sfp05
        IF cl_null(l_inb15) THEN 
           CALL t001_ins_imd(g_tc_sfp.tc_sfp05)
        END IF 
        IF g_success = 'N' THEN 
           EXIT FOREACH 
           RETURN  
        END IF 
        #str------add by guanyao160920根据仓储批带出数量
        IF l_ina.ina00 = '1' THEN 
           LET l_sql = "SELECT * FROM img_file WHERE img01 ='",l_tc_sfs.tc_sfs03 CLIPPED,"'",
                       "   AND img02 ='",g_tc_sfp.tc_sfp05,"'",
                       "   AND img03 = ' '",
                       "   AND img18 >='",g_today,"' ",
                       "   AND img10 >0 "
   	       PREPARE i511_img_p FROM l_sql
           DECLARE i511_img_c CURSOR FOR i511_img_p
           LET l_img10_sum = 0
           FOREACH i511_img_c INTO l_img.*
              INITIALIZE l_inb.* TO NULL
      	      LET l_img10_sum = l_img10_sum + l_img.img10
              IF l_img10_sum >= l_tc_sfs.tc_sfs05 THEN 
                 LET l_tc_sfs05 = l_tc_sfs.tc_sfs05-(l_img10_sum-l_img.img10)
              ELSE 
                 LET l_tc_sfs05 = l_img.img10
              END IF  
              LET l_inb.inb01= l_ina.ina01
              LET l_inb.inb03= l_i
              LET l_inb.inb04= l_img.img01
              LET l_inb.inb05= l_img.img02
              LET l_inb.inb06= l_img.img03
              LET l_inb.inb07= l_img.img04
              LET l_inb.inb08= l_img.img09
              LET l_inb.inb08_fac = '1'
              LET l_inb.inb09 =l_tc_sfs05
              LET l_inb.inb16 =l_tc_sfs05
              LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)
              LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)
              LET l_inb.inb10  = 'N'
              LET l_inb.inb11 = p_tc_sfp01
              LET l_inb.inb12 = ''
              LET l_inb.inb13 = 0 
              LET l_inb.inb15 ='Z02'
              LET l_inb.inb908 = ''
              LET l_inb.inb909 = ''
              LET l_inb.inb132 = 0
              LET l_inb.inb133 = 0
              LET l_inb.inb134 = 0
              LET l_inb.inb135 = 0
              LET l_inb.inb136 = 0
              LET l_inb.inb137 = 0
              LET l_inb.inb138 = 0
              LET l_inb.inblegal = g_legal   #MOD-A50144 add
              LET l_inb.inbplant = g_plant
              INSERT INTO inb_file VALUES(l_inb.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"","ins inb",1) 
                 LET g_success = 'N' 
                 CONTINUE FOREACH 
              END IF
              LET l_i = l_i +1
              IF l_tc_sfs05 =l_tc_sfs.tc_sfs05-(l_img10_sum-l_img.img10) THEN 
                 EXIT FOREACH 
              END IF 
           END FOREACH 
        ELSE 
        #end------add by guanyao160920
        LET l_inb.inb01= l_ina.ina01
        LET l_inb.inb03= l_i
        LET l_inb.inb04= l_tc_sfs.tc_sfs03
        LET l_inb.inb05=g_tc_sfp.tc_sfp05
        LET l_inb.inb06=' '
        SELECT to_char(g_tc_sfp.tc_sfp02,'yymmdd') INTO l_chr FROM dual 
        LET l_inb.inb07=g_tc_sfp.tc_sfp05 CLIPPED,'-',l_chr
        LET l_inb.inb08=l_tc_sfs.tc_sfs06
        LET l_inb.inb08_fac = '1'
        LET l_inb.inb09 =l_tc_sfs.tc_sfs05
        LET l_inb.inb16 =l_tc_sfs.tc_sfs05
        LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)
        LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)
        LET l_inb.inb10  = 'N'
        LET l_inb.inb11 = p_tc_sfp01
        LET l_inb.inb12 = ''
        LET l_inb.inb13 = 0
        IF l_z ='1' THEN 
           LET l_inb.inb15 ='Z02'
        ELSE 
           LET l_inb.inb15 ='Z01'
        END IF 
        LET l_inb.inb908 = ''
        LET l_inb.inb909 = ''
        LET l_inb.inb132 = 0
        LET l_inb.inb133 = 0
        LET l_inb.inb134 = 0
        LET l_inb.inb135 = 0
        LET l_inb.inb136 = 0
        LET l_inb.inb137 = 0
        LET l_inb.inb138 = 0
        LET l_inb.inblegal = g_legal   #MOD-A50144 add
        LET l_inb.inbplant = g_plant
        INSERT INTO inb_file VALUES(l_inb.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"","ins inb",1) 
           LET g_success = 'N' 
           CONTINUE FOREACH 
        END IF 
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM img_file 
         WHERE img01=l_inb.inb04
           AND img02=l_inb.inb05
           AND img03=l_inb.inb06
           AND img04=l_inb.inb07
        IF cl_null(l_x) OR l_x = 0 THEN 
           CALL s_add_img(l_inb.inb04,l_inb.inb05,
                          l_inb.inb06,l_inb.inb07,
                          l_ina.ina01,l_inb.inb03,l_ina.ina02)
           IF g_errno='N' THEN
              CALL cl_err('','cpm-011',1)
              LET g_success = 'N'    
           END IF
        END IF 
        LET l_i = l_i +1
        END IF #add by guanyao160920
     END FOREACH

     LET l_to_prog = g_prog
     IF l_a = '1' THEN 
        LET g_prog = 'aimt302'   
     ELSE 
        LET g_prog = 'aimt301'
     END IF 
     IF g_success = 'Y' THEN
        CALL t370sub_y_chk(l_ina.ina01,l_z,'N') #FUN-B50138  #TQC-C40079 add Y
        IF g_success = "Y" THEN
           CALL t370sub_y_upd(l_ina.ina01,'Y',TRUE) #FUN-B50138
           IF g_success = "Y" THEN
              CALL t370sub_s_chk(l_ina.ina01,'Y',TRUE,'')    #CALL 原確認的 check 段 #FUN-B50138
              IF g_success = "Y" THEN
                   CALL t370sub_s_upd(l_ina.ina01,l_z,TRUE)       #CALL 原確認的 update 段#FUN-B50138
              END IF
           END IF
        END IF
     END IF 
     LET g_prog=l_to_prog   
END FUNCTION 

FUNCTION t001_ina_undo_post(p_ina01)
DEFINE p_ina01      LIKE ina_file.ina01
DEFINE l_ina        RECORD LIKE ina_file.*
DEFINE l_ccz        RECORD LIKE ccz_file.*
DEFINE l_cnt             LIKE type_file.num5    
DEFINE l_azw04           LIKE azw_file.azw04    
DEFINE l_n               LIKE type_file.num5       
DEFINE l_yy,l_mm         LIKE type_file.num5    
DEFINE l_inb03           LIKE inb_file.inb03  
DEFINE l_inb05           LIKE inb_file.inb05  
DEFINE l_inb06           LIKE inb_file.inb06  
DEFINE l_flag            LIKE type_file.chr1  
DEFINE l_flag1           LIKE type_file.chr1  

     SELECT * INTO l_ina.* FROM ina_file WHERE ina01= p_ina01
     IF g_sma.sma53 IS NOT NULL AND l_ina.ina02 <= g_sma.sma53 THEN  
        CALL cl_err('','aim-885',1)       
        LET g_success = 'N'
        RETURN 
     ELSE                                                            #FUN-AC0074
        IF NOT cl_null(l_ina.ina103) THEN
           CALL cl_err(' ','aim-019',1)
           LET g_success = 'N'
           RETURN 
        ELSE
           IF NOT cl_null(l_ina.ina13) THEN                          
              CALL cl_err('','axm-744' ,1)
              LET g_success = 'N'
              RETURN
           ELSE
              LET l_n = 0
              SELECT COUNT(*)  INTO  l_n FROM lrj_file WHERE lrj16 = l_ina.ina01
              IF cl_null(l_n) OR l_n = 0 THEN
                 SELECT COUNT(*)  INTO  l_n FROM lrl_file WHERE lrl14 = l_ina.ina01
              END IF
              IF l_n > 0 THEN
                 CALL cl_err('','axm_119',0)
                 LET g_success = 'N'
                 RETURN
              ELSE 
                 IF g_sma.sma53 IS NOT NULL AND l_ina.ina02 <= g_sma.sma53 THEN
                    CALL cl_err('','mfg9999',0)
                    LET g_success = 'N'
                    RETURN
                 END IF
     
                 CALL s_yp(l_ina.ina02) RETURNING l_yy,l_mm
 
                 IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
                    CALL cl_err(l_yy,'mfg6090',0)
                    LET g_success = 'N'
                    RETURN
                 ELSE
                    IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
                       CALL cl_err(l_mm,'mfg6091',0)
                       LET g_success = 'N'
                       RETURN
                    END IF
                 END IF
            
                 IF NOT cl_null(l_ina.ina10) THEN
                    SELECT COUNT(*) INTO l_cnt FROM pie_file 
                     WHERE pie01 = l_ina.ina10 
                    IF l_cnt > 0 THEN                              
                       CALL cl_err('','aim-164' ,1)
                       LET g_success = 'N'
                       RETURN
                    END IF 
                 END IF                                                 
                    
                 SELECT azw04 INTO l_azw04
                   FROM azw_file
                  WHERE azw01 = l_ina.inaplant
                 SELECT COUNT(*) INTO l_cnt
                   FROM lpy_file
                  WHERE lpy01 = '3' 
                    AND lpy02 = l_ina.ina10
                 IF l_azw04 = '2' AND l_cnt > 0 THEN    
                    CALL cl_err('','aim-986',0)
                    LET g_success = 'N'
                    RETURN
                 END IF 

                 LET l_flag = 'Y'
                 DECLARE t370_z_c1 CURSOR FOR SELECT inb03,inb05,inb06 FROM inb_file 
                                               WHERE inb01=l_ina.ina01
                 CALL s_showmsg_init()   
                 FOREACH t370_z_c1 INTO l_inb03,l_inb05,l_inb06                              
                    CALL s_incchk(l_inb05,l_inb06,g_user) 
                       RETURNING l_flag1
                    IF l_flag1 = FALSE THEN
                       LET l_flag='N'
                       LET g_showmsg=l_inb03,"/",l_inb05,"/",l_inb06,"/",g_user
                       CALL s_errmsg('inb03,inb05,inb06,inc03',g_showmsg,'','asf-888',1)
                    END IF
                 END FOREACH

                 CALL s_showmsg()
                  
                 IF l_flag='N' THEN
                   LET g_success = 'N'
                   RETURN
                 END IF
    
                 SELECT * INTO l_ccz.* FROM ccz_file WHERE ccz00='0'
                    IF l_ccz.ccz28  = '6' AND NOT cl_null(l_ina.ina01) THEN
                       CALL cl_err('','apm-936',1)
                       LET g_success = 'N'
                       RETURN
                    END IF

                    LET g_success = 'Y'    
                    IF g_tc_sfp.tc_sfp00 = '1' THEN 
                       CALL p379sub_p2(l_ina.ina01,-1,'Y')
                    END IF 
                    IF g_tc_sfp.tc_sfp00 = '2' THEN 
                       CALL p379sub_p2(l_ina.ina01,+1,'Y')
                    END IF 
                 END IF     
              END IF                                                                    
           END IF
        END IF      
        
           
END FUNCTION

FUNCTION t001_ina_r(p_ina01)
DEFINE p_ina01    LIKE ina_file.ina01
DEFINE l_ina        RECORD LIKE ina_file.*
DEFINE l_i,l_cnt    LIKE type_file.num5,   #FUN-810045
           l_pja26      LIKE pja_file.pja26,   #FUN-810045
           l_act        LIKE type_file.chr1    #FUN-810045
    DEFINE l_flag       LIKE type_file.chr1    #No.FUN-830056
    #FUN-BC0104-add-str--
    DEFINE l_inb03  LIKE inb_file.inb03
    DEFINE l_inb44  LIKE inb_file.inb44
    DEFINE l_inb45  LIKE inb_file.inb45
    DEFINE l_inb46  LIKE inb_file.inb46
    DEFINE l_inb47  LIKE inb_file.inb47
    DEFINE l_inb48  LIKE inb_file.inb48
    DEFINE l_flagg  LIKE type_file.chr1
    DEFINE l_qcl05  LIKE qcl_file.qcl05
    DEFINE l_type1  LIKE type_file.chr1
    DEFINE l_cn     LIKE  type_file.num5
    DEFINE l_c      LIKE  type_file.num5
    DEFINE l_inb04   LIKE inb_file.inb04
    DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
           inb44    LIKE  inb_file.inb44,
           inb45    LIKE  inb_file.inb45,
           inb48    LIKE  inb_file.inb48,
           inb46    LIKE  inb_file.inb46,
           inb47    LIKE  inb_file.inb47,
           flagg    LIKE  type_file.chr1
           ,inb04   LIKE  inb_file.inb04
                    END RECORD
DEFINE l_crmStatus LIKE type_file.num10  #FUN-B10016 add
DEFINE l_crmDesc   STRING 
 
    IF p_ina01 IS NULL THEN 
       CALL cl_err('',-400,0)
       LET g_success = 'N' 
       RETURN  
    END IF   
    SELECT * INTO l_ina.* FROM ina_file WHERE ina01=p_ina01
    IF l_ina.inaconf = 'Y' THEN 
       CALL cl_err('',9023,0) 
       LET g_success = 'N' 
       RETURN 
    END IF 
    IF l_ina.inaconf = 'X' THEN 
       CALL cl_err('',9024,0)
       LET g_success = 'N'  
       RETURN 
    END IF 
    IF l_ina.ina08 matches '[Ss1]' THEN         
         CALL cl_err('','mfg3557',0)
         LET g_success = 'N'  
         RETURN       
    END IF

    LET g_forupd_sql = "SELECT * FROM ina_file WHERE ina01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t370_cl CURSOR FROM g_forupd_sql
    OPEN t370_cl USING l_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t370_cl:", STATUS, 1)
       CLOSE t370_cl
       LET g_success = 'N'
       RETURN           
    END IF
    FETCH t370_cl INTO l_ina.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ina.ina01,SQLCA.sqlcode,0)
       CLOSE t370_cl
       LET g_success = 'N'
       RETURN             
    END IF
    LET g_doc.column1 = "ina01"         
    LET g_doc.value1 = l_ina.ina01      
    CALL cl_del_doc()                                            
 
	DELETE FROM ina_file WHERE ina01 = l_ina.ina01 
    IF SQLCA.SQLERRD[3]=0 THEN 
       CALL cl_err3("del","ina_file",l_ina.ina01,"",SQLCA.sqlcode,"",
                    "No ina deleted",1)  
       LET g_success = 'N' 
       RETURN     
    END IF
    LET l_cn =1
    DECLARE upd_qco20 CURSOR FOR
     SELECT inb03,inb04 FROM inb_file WHERE inb01 = l_ina.ina01
    FOREACH upd_qco20 INTO l_inb03,l_inb04
       CALL s_iqctype_inb(l_ina.ina01,l_inb03) RETURNING l_inb44,l_inb45,l_inb46,l_inb48,l_inb47,l_flagg
       LET l_inb_a[l_cn].inb44 = l_inb44
       LET l_inb_a[l_cn].inb45 = l_inb45
       LET l_inb_a[l_cn].inb46 = l_inb46
       LET l_inb_a[l_cn].inb48 = l_inb48
       LET l_inb_a[l_cn].inb47 = l_inb47
       LET l_inb_a[l_cn].flagg = l_flagg
       LET l_inb_a[l_cn].inb04 = l_inb04
       LET l_cn = l_cn + 1
    END FOREACH
        DELETE FROM inb_file WHERE inb01 = l_ina.ina01      
        FOR l_c=1 TO l_cn-1
           IF l_inb_a[l_c].flagg = 'Y' THEN
              CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
              IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
              IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb44,l_inb_a[l_c].inb45,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN
                 LET g_success = 'N'     
                 RETURN
              END IF
           END IF
        END FOR
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
           VALUES ('aimt370',g_user,g_today,g_msg,l_ina.ina01,'delete',g_plant,g_legal) 
        FOR l_i = 1 TO l_cn-1
            CASE
              WHEN l_ina.ina00 MATCHES '[1256]'  #出庫
                LET l_act = "1"
              WHEN l_ina.ina00 MATCHES '[34]'    #入庫 #MOD-960086
                LET l_act = "2"
            END CASE
            IF NOT s_lot_del(g_prog,l_ina.ina01,'',0,l_inb_a[l_cn].inb04,'DEL') THEN    #
              LET g_success = 'N'
              RETURN       
            END IF
        END FOR

   #FUN-B10016 add str -------
   #若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發雜收/發單
    IF NOT cl_null(l_ina.ina10) AND l_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
       CALL aws_crmcli('x','restatus','1',l_ina.ina01,'1') RETURNING l_crmStatus,l_crmDesc
       IF l_crmStatus <> 0 THEN
          CALL cl_err(l_crmDesc,'!',1)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    CLOSE t370_cl
END FUNCTION  

FUNCTION t001_ins_imd(p_tc_sfp05)
DEFINE p_tc_sfp05        LIKE tc_sfp_file.tc_sfp05
DEFINE l_imd             RECORD LIKE imd_file.*
DEFINE l_jce             RECORD LIKE jce_file.*
DEFINE l_x               LIKE type_file.num5
DEFINE l_jceacti         LIKE jce_file.jceacti

    INITIALIZE l_imd.* TO NULL 
    INITIALIZE l_jce.* TO NULL 
    LET l_imd.imd01 = p_tc_sfp05
    SELECT pmc03 INTO l_imd.imd02 FROM pmc_file WHERE pmc01 = p_tc_sfp05
    LET l_imd.imd10='S'        
    LET l_imd.imd11='N'             
    LET l_imd.imd12='N'             
    LET l_imd.imd13='N'             
    LET l_imd.imdacti='Y'
    LET l_imd.imd17='N'             
    LET l_imd.imd22='N'             
    LET l_imd.imd23='N'             
    LET l_imd.imd18='0'             
    LET l_imd.imd19='N'             
    LET l_imd.imd14=0
    LET l_imd.imd15=0
    LET l_imd.imd20 = g_plant 
    LET l_imd.imdpos = 'N'
    LET l_imd.imduser = g_user
    LET l_imd.imddate = g_today
    LET l_imd.imdoriu = g_user
    LET l_imd.imdorig = g_grup
    INSERT INTO imd_file VALUES (l_imd.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imd_file",p_tc_sfp05,l_imd.imd02,
                    SQLCA.sqlcode,"","",1) 
       LET g_success = 'N' 
       RETURN 
    END IF 

    IF g_success ='Y' THEN 
       LET l_x = 0
       SELECT COUNT(*) INTO l_x FROM jce_file WHERE jce02 =p_tc_sfp05 AND jce01 =p_tc_sfp05
       IF cl_null(l_x) OR l_x = 0 THEN 
          LET l_jce.jce01 = p_tc_sfp05
          LET l_jce.jce02 = p_tc_sfp05
          LET l_jce.jceacti = 'Y'
          LET l_jce.jceuser = g_user
          LET l_jce.jcedate = g_today
          LET l_jce.jceoriu = g_user
          LET l_jce.jceorig = g_grup
          INSERT INTO jce_file VALUES (l_jce.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","jce_file",p_tc_sfp05,p_tc_sfp05,
                          SQLCA.sqlcode,"","",1) 
             LET g_success = 'N' 
             RETURN 
          END IF 
       ELSE 
          LET l_jceacti = ''
          SELECT jceacti INTO l_jceacti FROM jce_file WHERE jce01 = p_tc_sfp05 AND jce02 =p_tc_sfp05
          IF l_jceacti != 'Y' THEN 
             UPDATE jce_file SET jceacti = 'Y' WHERE jce02 = p_tc_sfp05 AND jce01 =p_tc_sfp05
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","jce_fiel",p_tc_sfp05,p_tc_sfp05,
                             SQLCA.sqlcode,"","",1) 
                LET g_success = 'N' 
                RETURN 
             END IF 
          END IF 
       END IF 
    END IF 

END FUNCTION 
#end----add by guanyao160705
#str----add by guanyao160810
FUNCTION t001_ins_tc_sfp_1()
DEFINE l_x            LIKE type_file.num5
DEFINE l_pmn04        LIKE pmn_file.pmn04
DEFINE l_pmn20        LIKE pmn_file.pmn20
DEFINE l_y            LIKE type_file.chr20 
DEFINE l_m            LIKE type_file.chr20
DEFINE l_str          LIKE type_file.chr20
DEFINE l_tmp          LIKE type_file.chr20
DEFINE l_sql          STRING  
DEFINE l_tc_sfp       RECORD LIKE tc_sfp_file.*
DEFINE l_pmm09        LIKE pmm_file.pmm09

     LET l_x = ''
     SELECT COUNT(*) INTO l_x FROM tc_sfp_file WHERE tc_sfp06 = g_argv2 
     IF l_x > 0 THEN 
     ELSE 
        BEGIN WORK 
        LET g_success = 'Y' 
        LET l_pmm09 = ''
        SELECT pmm09 INTO l_pmm09 FROM pmm_file WHERE pmm01 = g_argv2
        LET l_sql =" SELECT pmn04,SUM(pmn20) FROM pmn_file,sgm_file,ecd_file ",
                   "  WHERE pmn18 = sgm01 ",
                   "    AND pmn32 = sgm03 ",
                   "    AND sgm04 = ecd01 ",
                   "    AND ecd02 LIKE '%SMT%'",
                   "    AND pmn01 = '",g_argv2,"'",
                   "  GROUP BY pmn04 "
        PREPARE t001_ins_1 FROM l_sql
        DECLARE t001_ins_1_curs CURSOR FOR t001_ins_1
        FOREACH t001_ins_1_curs INTO l_pmn04,l_pmn20
           #自动编码----
           LET l_y =YEAR(g_today)
           LET l_y = l_y[3,4] USING '&&' 
           LET l_m =MONTH(g_today)
           LET l_m = l_m USING '&&' 
           LET l_str='XXX-',l_y CLIPPED,l_m CLIPPED
           SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
            WHERE substr(tc_sfp01,1,8)=l_str
           IF cl_null(l_tmp) THEN 
              LET l_tmp = '0001' 
           ELSE 
              LET l_tmp = l_tmp + 1
              LET l_tmp = l_tmp USING '&&&&'     
           END IF 
           LET l_tc_sfp.tc_sfp01 = l_str CLIPPED,l_tmp
           #------
           LET l_tc_sfp.tc_sfp05=l_pmm09
           LET l_tc_sfp.tc_sfp03=g_argv2
           LET l_tc_sfp.tc_sfp08=l_pmn04
           LET l_tc_sfp.tc_sfp09=l_pmn20
           LET l_tc_sfp.tc_sfp02=g_today
           LET l_tc_sfp.tc_sfp06=g_argv2
           LET l_tc_sfp.tc_sfpuser=g_user
           LET l_tc_sfp.tc_sfpgrup=g_grup
           LET l_tc_sfp.tc_sfpdate=g_today
           LET l_tc_sfp.tc_sfpconf = 'N'
           LET l_tc_sfp.tc_sfp00=g_argv1
           LET l_tc_sfp.tc_sfp13 = g_argv4
           LET l_tc_sfp.tc_sfpplant = g_plant
           LET l_tc_sfp.tc_sfplegal = g_legal
           INSERT INTO tc_sfp_file VALUES (l_tc_sfp.*)
           IF SQLCA.sqlcode THEN   
              CALL cl_err3("ins","tc_sfp_file",l_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_success = 'N'
           END IF
           SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = l_tc_sfp.tc_sfp01
           CALL t001_ins_tc_sfs()
           SELECT COUNT(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01= g_tc_sfp.tc_sfp01 
           IF cl_null(l_x) OR l_x = 0 THEN 
              CALL cl_err('','csf-004',0)
              LET g_success = 'N'
           END IF
        END FOREACH 
        IF g_success = 'Y' THEN 
           COMMIT WORK 
        ELSE 
           ROLLBACK WORK 
        END IF 
     END IF 
     CALL t001_q()
END FUNCTION 

FUNCTION t001_ins_tc_sfp_2()
DEFINE l_x            LIKE type_file.num5
DEFINE l_rvb05        LIKE rvb_file.rvb05
DEFINE l_rvb07        LIKE rvb_file.rvb07
DEFINE l_y            LIKE type_file.chr20 
DEFINE l_m            LIKE type_file.chr20
DEFINE l_str          LIKE type_file.chr20
DEFINE l_tmp          LIKE type_file.chr20
DEFINE l_sql          STRING  
DEFINE l_tc_sfp       RECORD LIKE tc_sfp_file.*
DEFINE l_rva05        LIKE rva_file.rva05

     LET l_x = ''
     SELECT COUNT(*) INTO l_x FROM tc_sfp_file WHERE tc_sfp06 = g_argv2 
     IF l_x > 0 THEN 
     ELSE 
        BEGIN WORK 
        LET l_rva05 = ''
        SELECT rva05 INTO l_rva05 FROM rva_file WHERE rva01 = g_argv2
        LET g_success = 'Y' 
        LET l_sql =" SELECT rvb05,SUM(rvb07) FROM rvb_file,pmn_file,sgm_file,ecd_file ",
                   "  WHERE pmn18 = sgm01 ",
                   "    AND pmn32 = sgm03 ",
                   "    AND rvb04 = pmn01",
                   "    AND rvb03 = pmn02",
                   "    AND sgm04 = ecd01 ",
                   "    AND ecd02 LIKE '%SMT%'",
                   "    AND rvb01 = '",g_argv2,"'",
                   "  GROUP BY rvb05 "
        PREPARE t001_ins_2 FROM l_sql
        DECLARE t001_ins_2_curs CURSOR FOR t001_ins_2
        FOREACH t001_ins_2_curs INTO l_rvb05,l_rvb07
           #自动编码----
           LET l_y =YEAR(g_today)
           LET l_y = l_y[3,4] USING '&&' 
           LET l_m =MONTH(g_today)
           LET l_m = l_m USING '&&' 
           LET l_str='YYY-',l_y CLIPPED,l_m CLIPPED
           SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
            WHERE substr(tc_sfp01,1,8)=l_str
           IF cl_null(l_tmp) THEN 
              LET l_tmp = '0001' 
           ELSE 
              LET l_tmp = l_tmp + 1
              LET l_tmp = l_tmp USING '&&&&'     
           END IF 
           LET l_tc_sfp.tc_sfp01 = l_str CLIPPED,l_tmp
           #------
           LET l_tc_sfp.tc_sfp05=l_rva05
           LET l_tc_sfp.tc_sfp11=g_argv2
           LET l_tc_sfp.tc_sfp08=l_rvb05
           LET l_tc_sfp.tc_sfp09=l_rvb07
           LET l_tc_sfp.tc_sfp02=g_today
           LET l_tc_sfp.tc_sfp06=g_argv2
           LET l_tc_sfp.tc_sfpuser=g_user
           LET l_tc_sfp.tc_sfpgrup=g_grup
           LET l_tc_sfp.tc_sfpdate=g_today
           LET l_tc_sfp.tc_sfpconf = 'N'
           LET l_tc_sfp.tc_sfp00=g_argv1
           LET l_tc_sfp.tc_sfp13 = g_argv4
           LET l_tc_sfp.tc_sfpplant = g_plant
           LET l_tc_sfp.tc_sfplegal = g_legal
           INSERT INTO tc_sfp_file VALUES (l_tc_sfp.*)
           IF SQLCA.sqlcode THEN   
              CALL cl_err3("ins","tc_sfp_file",l_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_success = 'N'
           END IF
           SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = l_tc_sfp.tc_sfp01
           CALL t001_ins_tc_sfs()
           SELECT COUNT(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01= g_tc_sfp.tc_sfp01 
           IF cl_null(l_x) OR l_x = 0 THEN 
              CALL cl_err('','csf-004',0)
              LET g_success = 'N'
           END IF
        END FOREACH 
        IF g_success = 'Y' THEN 
           COMMIT WORK 
        ELSE 
           ROLLBACK WORK 
        END IF 
     END IF 
     CALL t001_q()
END FUNCTION

FUNCTION t001_ins_tc_sfp_3()
DEFINE l_x            LIKE type_file.num5
DEFINE l_tc_pmm05     LIKE tc_pmm_file.tc_pmm05
DEFINE l_tc_pmm09     LIKE tc_pmm_file.tc_pmm09
DEFINE l_y            LIKE type_file.chr20 
DEFINE l_m            LIKE type_file.chr20
DEFINE l_str          LIKE type_file.chr20
DEFINE l_tmp          LIKE type_file.chr20
DEFINE l_sql          STRING  
DEFINE l_tc_sfp       RECORD LIKE tc_sfp_file.*

     LET l_x = ''
     SELECT COUNT(*) INTO l_x FROM tc_sfp_file WHERE tc_sfp06 = g_argv2 
     IF l_x > 0 THEN 
     ELSE 
        BEGIN WORK 
        LET g_success = 'Y' 
        LET l_sql = "SELECT tc_pmm05,SUM(tc_pmm09) FROM tc_pmm_file WHERE tc_pmm01 = '",g_argv2,"'",
                    " GROUP BY tc_pmm05"
        PREPARE t001_ins_3 FROM l_sql
        DECLARE t001_ins_3_curs CURSOR FOR t001_ins_3
        FOREACH t001_ins_3_curs INTO l_tc_pmm05,l_tc_pmm09
           #自动编码----
           LET l_y =YEAR(g_today)
           LET l_y = l_y[3,4] USING '&&' 
           LET l_m =MONTH(g_today)
           LET l_m = l_m USING '&&' 
           LET l_str='ZZZ-',l_y CLIPPED,l_m CLIPPED
           SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
            WHERE substr(tc_sfp01,1,8)=l_str
           IF cl_null(l_tmp) THEN 
              LET l_tmp = '0001' 
           ELSE 
              LET l_tmp = l_tmp + 1
              LET l_tmp = l_tmp USING '&&&&'     
           END IF 
           LET l_tc_sfp.tc_sfp01 = l_str CLIPPED,l_tmp
           #------
           LET l_tc_sfp.tc_sfp08=l_tc_pmm05
           LET l_tc_sfp.tc_sfp09=l_tc_pmm09
           LET l_tc_sfp.tc_sfp02=g_today
           LET l_tc_sfp.tc_sfp06=g_argv2
           LET l_tc_sfp.tc_sfpuser=g_user
           LET l_tc_sfp.tc_sfpgrup=g_grup
           LET l_tc_sfp.tc_sfpdate=g_today
           LET l_tc_sfp.tc_sfpconf = 'N'
           LET l_tc_sfp.tc_sfp00=g_argv1
           LET l_tc_sfp.tc_sfp13 = g_argv4
           LET l_tc_sfp.tc_sfpplant = g_plant
           LET l_tc_sfp.tc_sfplegal = g_legal
           INSERT INTO tc_sfp_file VALUES (l_tc_sfp.*)
           IF SQLCA.sqlcode THEN   
              CALL cl_err3("ins","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_success = 'N'
           END IF
           SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = l_tc_sfp.tc_sfp01
           CALL t001_ins_tc_sfs()
           SELECT count(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01= g_tc_sfp.tc_sfp01 
           IF cl_null(l_x) OR l_x = 0 THEN 
              CALL cl_err('','csf-004',0)
              LET g_success = 'N'
           END IF
        END FOREACH 
        IF g_success = 'Y' THEN 
           COMMIT WORK 
        ELSE 
           ROLLBACK WORK 
        END IF 
     END IF 
     CALL t001_q()
END FUNCTION 

FUNCTION t001_ins_tc_sfp_4()
DEFINE l_x            LIKE type_file.num5
DEFINE l_pnb20a       LIKE pnb_file.pnb20b
DEFINE l_pnb04a       LIKE pnb_file.pnb04a
DEFINE l_y            LIKE type_file.chr20 
DEFINE l_m            LIKE type_file.chr20
DEFINE l_str          LIKE type_file.chr20
DEFINE l_tmp          LIKE type_file.chr20
DEFINE l_sql          STRING  
DEFINE l_tc_sfp       RECORD LIKE tc_sfp_file.*
DEFINE l_sum          LIKE type_file.num15_3

     LET l_x = ''
     SELECT COUNT(*) INTO l_x FROM tc_sfp_file WHERE tc_sfp06 = g_argv2 
     IF l_x > 0 THEN 
     ELSE 
        BEGIN WORK 
        LET g_success = 'Y' 
        LET l_sql = "SELECT pnb04a,SUM(pnb20a) FROM pnb_file,pmn_file,sgm_file,ecd_file ",
                    " WHERE pnb01 = '",g_argv2,"'",
                    "   AND pnb02 = '",g_argv4,"'",
                    "   AND pnb01 = pmn01",
                    "   AND pnb03 = pmn02",
                    "   AND pmn18 = sgm01",
                    "   AND pmn32 = sgm03",
                    "   AND sgm04 = ecd01",
                    "   AND ecd02 LIKE '%SMT%'",
                    " GROUP BY pnb91"
        PREPARE t001_ins_4 FROM l_sql
        DECLARE t001_ins_4_curs CURSOR FOR t001_ins_4
        FOREACH t001_ins_4_curs INTO l_pnb04a,l_pnb20a
           SELECT SUM(pnb20b) INTO l_sum FROM pnb_file 
            WHERE pnb04b = l_pnb04a
           IF cl_null(l_sum) THEN 
              LET l_sum = 0
           END IF 
           IF l_pnb20a > l_sum THEN 
              LET l_tc_sfp.tc_sfp00 = '1'
           ELSE 
              LET l_tc_sfp.tc_sfp00 = '2'
           END IF 
           IF l_pnb20a = l_sum THEN 
              CONTINUE FOREACH 
           END  IF 
           #自动编码----
           LET l_y =YEAR(g_today)
           LET l_y = l_y[3,4] USING '&&' 
           LET l_m =MONTH(g_today)
           LET l_m = l_m USING '&&' 
           IF l_tc_sfp.tc_sfp00 = '1' THEN 
              LET l_str='XXX-',l_y CLIPPED,l_m CLIPPED
           ELSE 
              LET l_str='YYY-',l_y CLIPPED,l_m CLIPPED
           END IF 
           SELECT max(substr(tc_sfp01,9,4)) INTO l_tmp FROM tc_sfp_file
            WHERE substr(tc_sfp01,1,8)=l_str
           IF cl_null(l_tmp) THEN 
              LET l_tmp = '0001' 
           ELSE 
              LET l_tmp = l_tmp + 1
              LET l_tmp = l_tmp USING '&&&&'     
           END IF 
           LET l_tc_sfp.tc_sfp01 = l_str CLIPPED,l_tmp
           #------
           LET l_tc_sfp.tc_sfp08=l_pnb04a
           LET l_tc_sfp.tc_sfp09=l_pnb20a
           LET l_tc_sfp.tc_sfp02=g_today
           LET l_tc_sfp.tc_sfp06=g_argv2
           LET l_tc_sfp.tc_sfpuser=g_user
           LET l_tc_sfp.tc_sfpgrup=g_grup
           LET l_tc_sfp.tc_sfpdate=g_today
           LET l_tc_sfp.tc_sfpconf = 'N'
           #LET l_tc_sfp.tc_sfp00=g_argv1
           LET l_tc_sfp.tc_sfp13 = g_argv4
           LET l_tc_sfp.tc_sfpplant = g_plant
           LET l_tc_sfp.tc_sfplegal = g_legal
           INSERT INTO tc_sfp_file VALUES (l_tc_sfp.*)
           IF SQLCA.sqlcode THEN   
              CALL cl_err3("ins","tc_sfp_file",g_tc_sfp.tc_sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_success = 'N'
           END IF
           SELECT * INTO g_tc_sfp.* FROM tc_sfp_file WHERE tc_sfp01 = l_tc_sfp.tc_sfp01
           CALL t001_ins_tc_sfs()
           SELECT count(*) INTO l_x FROM tc_sfs_file WHERE tc_sfs01= g_tc_sfp.tc_sfp01 
           IF cl_null(l_x) OR l_x = 0 THEN 
              CALL cl_err('','csf-004',0)
              LET g_success = 'N'
           END IF
        END FOREACH 
        IF g_success = 'Y' THEN 
           COMMIT WORK 
        ELSE 
           ROLLBACK WORK 
        END IF 
     END IF 
     CALL t001_q()
END FUNCTION
#end----add by guanyao160810