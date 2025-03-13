# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aski011.4gl
# Descriptions...: 裁剪布料預算表維護作業
# Date & Author..: 08/08/12 by ve007  FUN-870117 FUN-8B0009
# Modify.........: No.FUN-8A0145 08/10/31 by hongmei 欄位類型修改
# Modify.........: No.FUN-8A0151 08/11/01 by hongmei mark output
# Modify.........: No.TQC-8C0056 08/12/22 By alex 修改LOCK CURSOR串接REF table問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940111 09/05/08 By mike SELECT agd03回傳值不唯一,INSERT skv_file KEY值不可為空  
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modifu.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 新增料號管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_value     ARRAY[20] OF RECORD
                   fname    LIKE type_file.chr5,      #欄位名稱s01-s20
                   imandx   LIKE type_file.chr8,      #
                   visible  LIKE type_file.chr1,      #欄位可見否
                   valuen   LIKE type_file.chr3,      #屬性編碼
                   nvalue   LIKE type_file.chr20,     #欄位屬性名
                   value    DYNAMIC ARRAY OF LIKE skw_file.skw07  #DEC(15,3)#存放當前欄位值 FUN-8A0145
                   END RECORD
DEFINE 
    g_sku           RECORD LIKE sku_file.*,
    g_sku_t         RECORD LIKE sku_file.*,
    g_sku_o         RECORD LIKE sku_file.*,
    b_skv           RECORD LIKE skv_file.*,
    g_sla           RECORD LIKE sla_file.*, 
    g_ima02         LIKE ima_file.ima02,
    g_gen02         LIKE gen_file.gen02,
    g_agd03         LIKE agd_file.agd03,
    g_eca02         LIKE eca_file.eca02,
    g_yy,g_mm       LIKE type_file.num5,       #
    g_skw04_t       LIKE skw_file.skw04,
    g_skv        DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                        skv03          LIKE skv_file.skv03,
                        skv13          LIKE skv_file.skv13,
                        ima02_2        LIKE ima_file.ima02,
                        skv04          LIKE skv_file.skv04,
                        skv06          LIKE skv_file.skv06,
                        agd03_3        LIKE agd_file.agd03,
                        ss01           LIKE skw_file.skw07,   #DECIMAL(15,3), 
                        ss02           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss03           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss04           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss05           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss06           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss07           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss08           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss09           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss10           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss11           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss12           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss13           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss14           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss15           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss16           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss17           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss18           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss19           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss20           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        skv07          LIKE skv_file.skv07,
                        skv08          LIKE skv_file.skv08,
                        skv09          LIKE skv_file.skv09,
                        skv10          LIKE skv_file.skv10,
                        skv11          LIKE skv_file.skv11
                        END RECORD,
    g_skv_t             RECORD
                        skv03          LIKE skv_file.skv03,
                        skv13          LIKE skv_file.skv13,
                        ima02_2        LIKE ima_file.ima02,
                        skv04          LIKE skv_file.skv04,
                        skv06          LIKE skv_file.skv06,
                        agd03_3        LIKE agd_file.agd03,
                        ss01           LIKE skw_file.skw07,   #DECIMAL(15,3), 
                        ss02           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss03           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss04           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss05           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss06           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss07           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss08           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss09           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss10           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss11           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss12           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss13           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss14           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss15           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss16           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss17           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss18           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss19           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        ss20           LIKE skw_file.skw07,   #DECIMAL(15,3),
                        skv07          LIKE skv_file.skv07,
                        skv08          LIKE skv_file.skv08,
                        skv09          LIKE skv_file.skv09,
                        skv10          LIKE skv_file.skv10,
                        skv11          LIKE skv_file.skv11
                        END RECORD
  DEFINE g_skw   DYNAMIC ARRAY OF RECORD
                     skw03        LIKE skw_file.skw03,
                     skw04        LIKE skw_file.skw04,
                     skw05        LIKE skw_file.skw05,
                     agd03        LIKE agd_file.agd03,
                     skw08        LIKE skw_file.skw08,
                     agd03_2      LIKE agd_file.agd03,
                     s01          LIKE skw_file.skw07,  #DECIMAL(15,3), 
                     s02          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s03          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s04          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s05          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s06          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s07          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s08          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s09          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s10          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s11          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s12          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s13          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s14          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s15          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s16          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s17          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s18          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s19          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s20          LIKE skw_file.skw07   #DECIMAL(15,3)
          END RECORD,
        g_skw_t    RECORD
                     skw03        LIKE skw_file.skw03,
                     skw04        LIKE skw_file.skw04,
                     skw05        LIKE skw_file.skw05,
                     agd03        LIKE agd_file.agd03,
                     skw08        LIKE skw_file.skw08,
                     agd03_2      LIKE agd_file.agd03,
                     s01          LIKE skw_file.skw07,  #DECIMAL(15,3), 
                     s02          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s03          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s04          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s05          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s06          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s07          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s08          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s09          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s10          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s11          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s12          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s13          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s14          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s15          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s16          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s17          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s18          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s19          LIKE skw_file.skw07,  #DECIMAL(15,3),
                     s20          LIKE skw_file.skw07   #DECIMAL(15,3)
          END RECORD
 DEFINE   g_sw          LIKE type_file.num5,
    g_flag              LIKE type_file.chr1,
    g_wc,g_wc2,g_wc3,g_sql  STRING, 
    h_qty		LIKE ima_file.ima271,
    g_t1                LIKE type_file.chr5,     
    g_buf               LIKE type_file.chr50,      
    sn1,sn2             LIKE type_file.num5,
    g_j,g_j1            LIKE type_file.num5,
    l_ac_t              LIKE type_file.num5,
    l_code              LIKE type_file.num5,
    g_rec_b,g_rec_d     LIKE type_file.num5,              #單身筆數
    g_void              LIKE type_file.chr1,
    l_ac                LIKE type_file.num5,              #目前處理的ARRAY CNT
    l_acd               LIKE type_file.num5,
    g_argv1	            LIKE type_file.chr18,             #單號 
    g_cmd               LIKE type_file.chr1000
 
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_chr          LIKE type_file.chr1
DEFINE g_cnt          LIKE type_file.num5
DEFINE g_i            LIKE type_file.num5           #count/index for any purpose
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num5
DEFINE g_curs_index   LIKE type_file.num5
DEFINE g_jump         LIKE type_file.num5
DEFINE g_no_ask      LIKE type_file.num5
DEFINE l_skx  DYNAMIC ARRAY OF RECORD
                    skx03              LIKE skx_file.skx03,
                    skx07              LIKE skx_file.skx07,
                    ima02_7            LIKE ima_file.ima02,
                    skx04              LIKE skx_file.skx04,
                    skx05              LIKE skx_file.skx05,
                    skx06              LIKE skx_file.skx06
                    END RECORD
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1=ARG_VAL(1)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
 
    SELECT * INTO g_sla.* FROM sla_file 
     
    IF (NOT cl_setup("ASK")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET g_wc2=' 1=1'
    LET g_wc3=' 1=1'
    
    LET g_forupd_sql = "SELECT * FROM sku_file WHERE sku01 = ? AND sku02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i011_cl CURSOR FROM g_forupd_sql     #TQC-8C0056
 
    INITIALIZE g_sku.* TO NULL
    INITIALIZE g_sku_t.* TO NULL
    INITIALIZE g_sku_o.* TO NULL
 
    OPEN WINDOW i011_w WITH FORM "ask/42f/aski011"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL i011_menu()
 
    CLOSE WINDOW i011_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i011_cs()
 
       CLEAR FORM                             #清除畫面
       CALL g_skw.clear()
       CALL g_skv.clear()
 
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           sku01,sku02,sku07,sku05,sku03,skuuser,skugrup,skumodu,skudate,skuconf,sku09,sku10,sku11
       
        BEFORE CONSTRUCT
               INITIALIZE g_sku.* TO NULL
 
        ON ACTION controlp                  
          CASE 
	    WHEN INFIELD(sku01) #查詢單據
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
  	         LET g_qryparam.form = "q_oea99"
 	         CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret to sku01
                 NEXT FIELD sku01
 
	    WHEN INFIELD(sku02)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
# 	         LET g_qryparam.form = "q_ima14"
#	         CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima14","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret to sku02
                 NEXT FIELD sku02
           
          WHEN INFIELD(sku05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form  = "q_agd1"
                 LET g_qryparam.arg1  = g_sla.sla03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret to sku05
                 NEXT FIELD sku05 
 
           WHEN INFIELD(sku07) #查詢布料
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_ima"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                 DISPLAY g_qryparam.multiret to sku07
                 NEXT FIELD sku07
              
           WHEN INFIELD(sku09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sku09
                 NEXT FIELD sku09
 
           WHEN INFIELD(sku10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sku10
                 NEXT FIELD sku10
         
           WHEN INFIELD(sku11)
                 CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sku11
                 NEXT FIELD sku11 
 
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
 
       
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skuuser', 'skugrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
 
 
       LET g_sql = "SELECT sku01,sku02 FROM sku_file",
                   " WHERE  ", g_wc CLIPPED,
                   " ORDER BY sku01,sku02 "
 
    PREPARE i011_prepare FROM g_sql
    DECLARE i011_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i011_prepare
 
        LET g_sql="SELECT COUNT(*) FROM sku_file ",
                  "WHERE  ",g_wc CLIPPED
 
    PREPARE i011_precount FROM g_sql
    DECLARE i011_count CURSOR FOR i011_precount
END FUNCTION
 
FUNCTION i011_menu()
  DEFINE  l_n        LIKE type_file.num5
 
   WHILE TRUE
      CALL i011_bp("G")
      CASE g_action_choice
         WHEN "insert"  
            IF cl_chk_act_auth() THEN
               CALL i011_a() 
            END IF
         WHEN "query"  
            IF cl_chk_act_auth() THEN 
               CALL i011_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i011_r() 
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL i011_u() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               IF g_sku.skuconf ='N' THEN
                 CALL i011_b()
               ELSE
                 IF g_sku.skuconf ='Y' THEN
                   CALL cl_err(' ',9022,0)
                 END IF
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
	    LET g_action_choice = ""
 
         WHEN "sets"   
            IF cl_chk_act_auth() THEN
               IF g_sku.skuconf ='N' THEN
                 SELECT count(*) INTO l_n  FROM skw_file
                 WHERE skw01=g_sku.sku01
                   AND skw02=g_sku.sku02
                 IF l_n = 0 THEN
                     CALL i011_p()
                 END IF
                 CALL i011_d() 
                 CALL i011_b()
               ELSE
                 IF g_sku.skuconf ='Y' THEN
                   CALL cl_err(' ',9022,0)
                 END IF
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
            LET g_action_choice = ""
 
         WHEN "confirm"
           IF cl_chk_act_auth() AND NOT cl_null(g_sku.sku01) THEN
             CALL i011_y() 
           END IF 
 
         WHEN "undo_confirm"
           IF cl_chk_act_auth() AND NOT cl_null(g_sku.sku01) THEN
             CALL i011_z()
           END IF
      
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i011_a()
    DEFINE  li_result  LIKE type_file.num5     
    DEFINE  l_n        LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_skw.clear()
    CALL g_skv.clear()
    INITIALIZE g_sku.* TO NULL
    LET g_sku_o.* = g_sku.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sku.sku03 =g_today
        LET g_sku.skuuser=g_user
        LET g_sku.skugrup=g_grup
        LET g_sku.skudate=g_today
        LET g_sku.skuconf ='N'
        LET g_sku.skuplant = g_plant #FUN-980008 add
        LET g_sku.skulegal = g_legal #FUN-980008 add
        DISPLAY BY NAME g_sku.skuconf
        BEGIN WORK
        CALL i011_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_sku.* TO NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0) 
           ROLLBACK WORK 
           RETURN
        END IF
        IF g_sku.sku01 IS NULL THEN CONTINUE WHILE END IF
        IF g_sku.sku02 IS NULL THEN CONTINUE WHILE END IF
 
        DISPLAY BY NAME g_sku.sku01,g_sku.sku02
 
        LET g_sku.skuoriu = g_user      #No.FUN-980030 10/01/04
        LET g_sku.skuorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sku_file VALUES (g_sku.*) 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
           CALL cl_err('ins sku: ',SQLCA.SQLCODE,1)   #FUN-B80030 ADD
           ROLLBACK WORK
          # CALL cl_err('ins sku: ',SQLCA.SQLCODE,1)   #FUN-B80030 MARK
           CONTINUE WHILE 
        ELSE
           COMMIT WORK
           CALL cl_flow_notify(g_sku.sku01,'I')
        END IF
 
        SELECT sku01,sku02 INTO g_sku.sku01,g_sku.sku02 FROM sku_file 
         WHERE sku01 = g_sku.sku01
           AND sku02 = g_sku.sku02
 
        LET g_sku_t.* = g_sku.*
 
        CALL g_skw.clear()
        LET g_rec_d = 0
	
	      SELECT count(*) INTO l_n  FROM skw_file
         WHERE skw01=g_sku.sku01
           AND skw02=g_sku.sku02
        IF l_n = 0 THEN
           CALL i011_p()
        END IF
 
        CALL i011_d()                   #輸入單身
        IF g_success = "N" THEN 
           EXIT WHILE 
        END IF 
        CALL i011_b()
 
        SELECT COUNT(*) INTO g_i FROM skw_file 
         WHERE skw01=g_sku.sku01
        IF g_i>0 THEN
           IF g_smy.smyprint='Y' THEN
        END IF
        END IF
        EXIT WHILE
 
    END WHILE
 
END FUNCTION
 
FUNCTION i011_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sku.sku01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_sku.skuconf ='Y' THEN
      CALL cl_err(' ',9022,0) 
      RETURN 
    END IF
    SELECT * 
      INTO g_sku.* 
      FROM sku_file 
     WHERE sku01=g_sku.sku01
       AND sku02=g_sku.sku02
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sku_o.* = g_sku.*
    BEGIN WORK
    OPEN i011_cl USING g_sku.sku01,g_sku.sku02
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i011_cl
       ROLLBACK WORK
       RETURN
    ELSE 
       FETCH i011_cl INTO g_sku.*                   # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)  # 資料被他人LOCK
          CLOSE i011_cl 
          ROLLBACK WORK 
          RETURN
       END IF
    END IF
    CALL i011_show()
    WHILE TRUE
        LET g_sku.skumodu=g_user
        LET g_sku.skudate=g_today
        CALL i011_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sku.*=g_sku_t.*
            CALL i011_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE sku_file SET * = g_sku.* WHERE sku01 = g_sku_o.sku01 AND sku02 = g_sku_o.sku02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('up sku: ',SQLCA.SQLCODE,1)
           CONTINUE WHILE
        END IF
        IF g_sku.sku01 != g_sku_t.sku01 
	OR g_sku.sku02 != g_sku_t.sku02  THEN 
	  CALL i011_chkkey() 
	END IF
        EXIT WHILE
    END WHILE
    CLOSE i011_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sku.sku01,'U')
END FUNCTION
 
FUNCTION i011_chkkey()
      UPDATE skw_file 
         SET skw01=g_sku.sku01,
	     skw02=g_sku.sku02 
       WHERE skw01=g_sku_t.sku01
         AND skw02=g_sku_t.sku02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd skw01: ',SQLCA.SQLCODE,1)
         LET g_sku.*=g_sku_t.* 
	 CALL i011_show() 
	 ROLLBACK WORK 
	 RETURN
      END IF
END FUNCTION
 
FUNCTION i011_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1               #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1               #判斷必要欄位是否有輸入
  DEFINE li_result,l_cnt LIKE type_file.num5         
 
    INPUT BY NAME g_sku.sku01,g_sku.sku02,g_sku.sku07,g_sku.sku05,
                  g_sku.sku03,g_sku.sku11,g_sku.sku09,g_sku.sku10,
                  g_sku.skumemo,g_sku.skuuser,g_sku.skugrup,
                  g_sku.skumodu,g_sku.skudate
           WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i011_set_entry(p_cmd)
            CALL i011_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE 
 
 
        AFTER FIELD sku01  
            IF NOT cl_null(g_sku.sku01) THEN 
               LET l_cnt = 0
               LET l_cnt = 0
               SELECT count(*) INTO  l_cnt FROM sfb_file
                WHERE sfb85 = g_sku.sku01
               IF l_cnt <=0 THEN
               	  CALL cl_err('','ask-082',1)
               	  NEXT FIELD sku01
               END IF                                   
               IF NOT cl_null(g_sku.sku02) THEN
                  LET l_cnt = 0 
 
                   SELECT COUNT(*) INTO l_cnt FROM slg_file,sfci_file
                    WHERE slg01 = sfcislk01
                      AND slg02 = g_sku.sku02 
                      AND sfci01 = g_sku.sku01
 
                  IF l_cnt <=0 THEN
                     CALL cl_err('','ask-083',1)
                     NEXT FIELD sku01
                  END IF
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt
                    FROM sku_file
                   WHERE sku01 =g_sku.sku01
                     AND sku02 =g_sku.sku02
                  IF l_cnt <=0 THEN
                     CALL cl_err('','-239',1)
                     NEXT FIELD sku01
                  END IF
               END IF
               DISPLAY BY NAME g_sku.sku01
            END IF
 
    	  AFTER FIELD sku02
    	     IF NOT cl_null(g_sku.sku02) THEN
#FUN-AB0025 ---------------------start----------------------------
                IF NOT s_chk_item_no(g_sku.sku02,"") THEN
                   CALL cl_err('',g_errno,1)
                   LET g_sku.sku02=g_sku_t.sku02 
                   NEXT FIELD sku02
                END IF
#FUN-AB0025 ---------------------end-------------------------------
    	        LET l_cnt = 0
    	        SELECT COUNT(*) INTO l_cnt FROM ima_file
    	         WHERE ( ima130 IS NULL OR ima130 <>'2') 
    	           AND imaacti = 'Y' 
                 AND (imaag IS NOT NULL AND imaag <> '@CHILD')
                 AND ima01 = g_sku.sku02
	      
              IF l_cnt <= 0 THEN
                 CALL cl_err('','ask-081',1)
                 NEXT FIELD sku02
              END IF
              IF NOT cl_null(g_sku.sku01) THEN
                 LET l_cnt = 0 
 
                   SELECT COUNT(*) INTO l_cnt FROM slg_file,sfci_file
                    WHERE slg01 = sfcislk01
                      AND slg02 = g_sku.sku02 
                      AND sfci01 = g_sku.sku01
 
                 IF l_cnt <=0 THEN
                    CALL cl_err('','ask-083',1)
                    NEXT FIELD sku02
                 END IF
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM sku_file
                  WHERE sku01 =g_sku.sku01
                    AND sku02 =g_sku.sku02
                 IF l_cnt > 0 THEN
                    CALL cl_err('','-239',1)
                    NEXT FIELD sku01
                 END IF
              END IF
              SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_sku.sku02
              DISPLAY g_ima02 TO ima02
	         END IF
 
        AFTER FIELD sku03
           IF NOT cl_null(g_sku.sku03) THEN 
              IF g_sma.sma53 IS NOT NULL AND g_sku.sku03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sku03
              END IF
              CALL s_yp(g_sku.sku03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52) THEN #不可大于現行年月
                 CALL cl_err('','mfg6091',0) 
              END IF
           END IF
        
        AFTER FIELD sku05
          IF NOT cl_null(g_sku.sku05) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM agd_file
               WHERE agd02=g_sku.sku05
              IF l_cnt <= 0 THEN
                 CALL cl_err(' ','agd-001',0)
                 NEXT FIELD sku05
              END IF
              SELECT  agd03 INTO g_agd03 FROM agd_file
               WHERE agd02=g_sku.sku05
                 AND agd01=g_sla.sla03 #TQC-940111  
              DISPLAY g_agd03 TO agd03_1
          END IF
        
        AFTER FIELD sku07
          IF NOT cl_null(g_sku.sku07) THEN
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_sku.sku07,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_sku.sku07= g_sku_t.sku07
                NEXT FIELD sku07
             END IF
#FUN-AA0059 ---------------------end-------------------------------
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
                WHERE ima01 = g_sku.sku07 
              IF l_cnt = 0 THEN
                 CALL cl_err('','mfg0002',1)
                 NEXT FIELD sku07
              END IF
              SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_sku.sku07
              DISPLAY g_ima02 TO ima02_1
          END IF
 
         AFTER FIELD sku09
          IF NOT cl_null(g_sku.sku09) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM gen_file
                WHERE gen01 = g_sku.sku09
              IF l_cnt = 0 THEN
                 CALL cl_err(' ','aap-038',0)
                 NEXT FIELD sku09
              END IF
              SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_sku.sku09
              DISPLAY g_gen02 TO gen02
           END IF
 
         AFTER FIELD sku10
          IF NOT cl_null(g_sku.sku10) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM gen_file
                WHERE gen01 = g_sku.sku10
              IF l_cnt = 0 THEN
                 CALL cl_err(' ','aap-038',0)
                 NEXT FIELD sku10
              END IF
              SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_sku.sku10
              DISPLAY g_gen02 TO gen02_1
           END IF
 
        AFTER FIELD sku11
          IF NOT cl_null(g_sku.sku11) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM eca_file
                WHERE eca01 = g_sku.sku11
              IF l_cnt = 0 THEN
                CALL cl_err(' ','mfg4011',0)
                 NEXT FIELD sku11
              END IF
              SELECT eca02 INTO g_eca02 FROM eca_file WHERE eca01=g_sku.sku11
              DISPLAY g_eca02 TO eca02 
           END IF        
 
        ON ACTION controlp                  
          CASE 
              WHEN INFIELD(sku01) #查詢單據
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oea99"
                     LET g_qryparam.default1 = g_sku.sku01
                     CALL cl_create_qry() RETURNING g_sku.sku01 
                     DISPLAY g_sku.sku01 TO sku01
 
              WHEN INFIELD(sku02)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima30"
#                    LET g_qryparam.default1 = g_sku.sku02
#                    CALL cl_create_qry() RETURNING g_sku.sku02 
                     CALL q_sel_ima(FALSE, "q_ima30","",g_sku.sku02,"","","","","",'' ) 
                      RETURNING   g_sku.sku02
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_sku.sku02 TO sku02
 
            WHEN INFIELD(sku05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_agd1"
                   LET g_qryparam.arg1     = g_sla.sla03
                   LET g_qryparam.default1 = g_sku.sku05
                   CALL cl_create_qry() RETURNING g_sku.sku05
                   NEXT FIELD sku05
            
            WHEN INFIELD(sku07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_skf05"     #No.FUN-8B0009   
                 LET g_qryparam.arg1     = g_sku.sku02   #NO.FUN-8B0009
                 CALL cl_create_qry() RETURNING g_sku.sku07 
                 NEXT FIELD sku07
            
            WHEN INFIELD(sku09)
                  CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_sku.sku09
                 CALL cl_create_qry() RETURNING g_sku.sku09 
                 NEXT FIELD sku09
                  
            WHEN INFIELD(sku10)
                  CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_sku.sku10
                 CALL cl_create_qry() RETURNING g_sku.sku10 
                 NEXT FIELD sku10
 
            WHEN INFIELD(sku11)
                 CALL q_eca(FALSE,TRUE,g_sku.sku11)
                        RETURNING g_sku.sku11
                 DISPLAY BY NAME g_sku.sku11 
                 NEXT FIELD sku11
 
               OTHERWISE EXIT CASE
          END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
    
    END INPUT
END FUNCTION
 
FUNCTION i011_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("sku01,sku02",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i011_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("sku01,sku02",FALSE) 
    END IF 
 
END FUNCTION
 
FUNCTION i011_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i011_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sku.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i011_cs               # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sku.* TO NULL
    ELSE
        OPEN i011_count
        FETCH i011_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i011_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i011_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                #處理方式
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i011_cs INTO g_sku.sku01,g_sku.sku02
        WHEN 'P' FETCH PREVIOUS i011_cs INTO g_sku.sku01,g_sku.sku02
        WHEN 'F' FETCH FIRST    i011_cs INTO g_sku.sku01,g_sku.sku02
        WHEN 'L' FETCH LAST     i011_cs INTO g_sku.sku01,g_sku.sku02
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i011_cs INTO g_sku.sku01,g_sku.sku02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_sku.* FROM sku_file WHERE sku01 = g_sku.sku01 AND sku02 = g_sku.sku02
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
        INITIALIZE g_sku.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_sku.skuuser #FUN-4C0053
        LET g_data_group = g_sku.skugrup #FUN-4C0053
    END IF
    CALL i011_show()
END FUNCTION
 
FUNCTION i011_show()
    LET g_sku_t.* = g_sku.*                #保存單頭舊值
    DISPLAY BY NAME
	g_sku.sku01,g_sku.sku02,
	g_sku.sku07,g_sku.sku05,
	g_sku.sku03,g_sku.sku09,
        g_sku.sku10,g_sku.sku11,
        g_sku.skumemo,g_sku.skuconf,
	g_sku.skuuser,g_sku.skugrup,
	g_sku.skumodu,g_sku.skudate
    SELECT ima02 INTO g_ima02 FROM ima_file
     WHERE ima01 = g_sku.sku02
    DISPLAY g_ima02 TO ima02
    
    SELECT ima02 INTO g_ima02 FROM ima_file
     WHERE ima01 = g_sku.sku07
    DISPLAY g_ima02 TO ima02_1
 
    SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_sku.sku09
    DISPLAY g_gen02 TO gen02
  
    SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_sku.sku10
    DISPLAY g_gen02 TO gen02_1
   
    SELECT agd03 INTO g_agd03 FROM agd_file 
    WHERE agd02=g_sku.sku05
      AND agd01=g_sla.sla03 #TQC-940111   
    DISPLAY g_agd03 TO agd03_1
    
    SELECT eca02 INTO g_eca02 FROM eca_file WHERE eca01=g_sku.sku11
    DISPLAY g_eca02 TO eca02
    
    CALL i011_d_fill(g_wc2)
    CALL i011_b_fill(g_wc3) 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i011_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_sku.sku01 IS NULL OR g_sku.sku02 IS NULL  THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
    SELECT * INTO g_sku.* 
      FROM sku_file 
     WHERE sku01=g_sku.sku01
       AND sku02=g_sku.sku02
 
    BEGIN WORK
 
    OPEN i011_cl USING g_sku.sku01,g_sku.sku02
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN 
    ELSE 
       FETCH i011_cl INTO g_sku.*
       IF SQLCA.sqlcode THEN 
          CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
          ROLLBACK WORK
          RETURN 
       END IF
    END IF
    CALL i011_show()
    IF cl_delh(20,16) THEN
        MESSAGE "Delete sku,skw!"
        DELETE FROM sku_file 
	      WHERE sku01 = g_sku.sku01
	        AND sku02 = g_sku.sku02
        IF SQLCA.SQLERRD[3]=0 THEN 
	   CALL cl_err('No sku deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK 
	   RETURN
        END IF
        DELETE FROM skw_file 
	 WHERE skw01 = g_sku.sku01
	   AND skw02 = g_sku.sku02
        IF SQLCA.SQLCODE THEN 
	   CALL cl_err('No skw deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK 
	   RETURN
        END IF
 
        DELETE FROM skv_file 
         WHERE skv01 = g_sku.sku01
           AND skv02 = g_sku.sku02
        IF SQLCA.SQLCODE  THEN 
           CALL cl_err('No skv deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK 
           RETURN
        END IF
 
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add azoplant,azolegal
           VALUES ('aski011',g_user,g_today,g_msg,g_sku.sku01,'delete',g_plant,g_legal) #FUN-980008 add g_plant,g_legal
        CLEAR FORM
        CALL g_skw.clear()
    	INITIALIZE g_sku.* TO NULL
        CALL g_skv.clear() 
        MESSAGE ""
         OPEN i011_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i011_cs
            CLOSE i011_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH i011_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i011_cs
            CLOSE i011_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i011_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i011_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i011_fetch('/')
         END IF
    END IF
    CLOSE i011_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sku.sku01,'D')
     
END FUNCTION
 
 
FUNCTION i011_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY ARRAY g_skw TO s_skw.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY   
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_skv TO s_skv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET  l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
      ON ACTION first
         CALL i011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
                              
      ON ACTION previous
         CALL i011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                  
                              
      ON ACTION jump
         CALL i011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                  
                              
      ON ACTION last
         CALL i011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION sets
         LET g_action_choice="sets"
         EXIT DISPLAY
 
      ON ACTION confirm 
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm 
         LET g_action_choice="undo_confirm"
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i011_c()
 DEFINE l_msg         STRING,
        l_sql         STRING,        #NO.FUN-910082  
        i             LIKE type_file.num5,
        l_sfc91       LIKE sfc_file.sfc91,  
	      l_slg04       LIKE slg_file.slg04,
	      l_sfcislk01   LIKE sfci_file.sfcislk01,
        l_ocq05       LIKE ocq_file.ocq05
 
     CALL cl_set_comp_visible('skw03,skw04,skw05',TRUE)
 
     FOR i = 1 TO 20
        LET l_msg = 's',i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
     END FOR
 
 
          SELECT sfcislk01 INTO l_sfcislk01 FROM sfci_file
           WHERE sfci01 = g_sku.sku01
 
 
          LET l_sql=" SELECT slg04 ",
                    "   FROM slg_file ",
                    "  WHERE slg01 = '",l_sfcislk01,"'",
	                  "    AND slg02 = '",g_sku.sku02,"'",
	                  " ORDER BY slg03 "
 
     PREPARE i100f_tmp1 FROM l_sql
     DECLARE tmp1_cur1 CURSOR FOR i100f_tmp1
   
     LET i=1
     LET g_j = 1
     CALL g_value.clear()
     FOREACH tmp1_cur1 INTO l_slg04
        IF STATUS THEN 
           CALL cl_err('foreach slg04',STATUS,0)   
           EXIT FOREACH                         
        END IF        
 
        SELECT DISTINCT ocq05 INTO l_ocq05
          FROM ocq_file
         WHERE ocq04 = l_slg04 
 
         
        LET g_value[i].valuen = l_slg04 
        LET l_slg04=l_ocq05
 
        LET l_msg = 's',i USING '&&'
        CALL cl_set_comp_att_text(l_msg ,l_slg04)
        CALL cl_set_comp_visible(l_msg,TRUE)
        LET g_value[i].fname = l_msg
        LET g_value[i].visible = 'Y' 
        LET g_value[i].imandx = 'imandx',i USING '&&'
        LET g_value[i].nvalue = l_slg04
       
        LET i = i + 1
        IF i = 21 THEN EXIT FOREACH END IF  #防止下標溢出
     END FOREACH
     LET g_j = i-1
     FOR i = i TO 20
        LET l_msg = 's',i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        LET g_value[i].fname = l_msg 
        LET g_value[i].visible = 'N'
        LET g_value[i].imandx = 'imandx',i USING '&&'
        LET g_value[i].nvalue = ''
     END FOR
 
END FUNCTION
 
FUNCTION i011_c1() 
 DEFINE l_msg         STRING,
        l_sql         STRING,       #NO.FUN-910082  
        i             LIKE type_file.num5,
        l_sfc91       LIKE sfc_file.sfc91,  
	      l_slg04  LIKE slg_file.slg04,
	      l_sfcislk01   LIKE sfci_file.sfcislk01,
        l_ocq05       LIKE ocq_file.ocq05
 
     CALL cl_set_comp_visible('skw03,skw04,skw06,skw07,skw08,skw09,skw10,skw11',TRUE)
 
     FOR i = 1 TO 20
        LET l_msg = 'ss',i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
     END FOR
          SELECT sfcislk01 INTO l_sfcislk01 FROM sfci_file
           WHERE sfci01 = g_sku.sku01
 
 
          LET l_sql=" SELECT slg04 ",
                    "   FROM slg_file ",
                    "  WHERE slg01 = '",l_sfcislk01,"'",
                    "    AND slg02 = '",g_sku.sku02,"'",
                    " ORDER BY slg03 "
     PREPARE i100f_tmp2 FROM l_sql
     DECLARE tmp1_cur2 CURSOR FOR i100f_tmp2
   
     LET i=1
     LET g_j = 1
     CALL g_value.clear()
     FOREACH tmp1_cur2 INTO l_slg04
        IF STATUS THEN 
           CALL cl_err('foreach slg04',STATUS,0)   
           EXIT FOREACH                         
        END IF        
        
        SELECT DISTINCT ocq05 INTO l_ocq05
          FROM ocq_file
         WHERE ocq04 = l_slg04 
           
        LET g_value[i].valuen = ' '     #TQC-940111   
        LET l_slg04=l_ocq05
      
        LET l_msg = 'ss',i USING '&&'
        CALL cl_set_comp_att_text(l_msg ,l_slg04)
        CALL cl_set_comp_visible(l_msg,TRUE)
        LET g_value[i].fname = l_msg
        LET g_value[i].visible = 'Y' 
        LET g_value[i].imandx = 'imandx',i USING '&&'
        LET g_value[i].nvalue = l_slg04
       
        LET i = i + 1
        IF i = 21 THEN EXIT FOREACH END IF  #防止下標溢出
     END FOREACH
     LET g_j1 = i-1
     FOR i = i TO 20
        LET l_msg = 'ss',i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        LET g_value[i].fname = l_msg 
        LET g_value[i].visible = 'N'
        LET g_value[i].imandx = 'imandx',i USING '&&'
        LET g_value[i].nvalue = ''
     END FOR
 
END FUNCTION
 
FUNCTION i011_d()
  DEFINE    l_n,l_cnt,i,l_acd_t LIKE type_file.num5,
            l_sql3        STRING ,      #NO.FUN-910082  
	          l_skw03_t    LIKE   skw_file.skw03,
	          l_skw04_t    LIKE   skw_file.skw04,
	          l_skw05_t    LIKE   skw_file.skw05,
            l_skw08_t    LIKE   skw_file.skw08
 
     CALL i011_c()
  
     INPUT ARRAY g_skw WITHOUT DEFAULTS FROM s_skw.*    
     ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED,INSERT ROW=TRUE,
               DELETE ROW=TRUE,APPEND ROW=TRUE)        
                                                      
     BEFORE INPUT                                    
       IF g_rec_d != 0 THEN                         
          CALL fgl_set_arr_curr(l_acd)              
       END IF           
       
     BEFORE INSERT
       LET g_rec_d = ARR_COUNT()
       LET g_skw[l_acd].s01 = 0
       LET g_skw[l_acd].s02 = 0
       LET g_skw[l_acd].s03 = 0
       LET g_skw[l_acd].s04 = 0
       LET g_skw[l_acd].s05 = 0
       LET g_skw[l_acd].s06 = 0
       LET g_skw[l_acd].s07 = 0
       LET g_skw[l_acd].s08 = 0
       LET g_skw[l_acd].s09 = 0
       LET g_skw[l_acd].s10 = 0
       LET g_skw[l_acd].s11 = 0
       LET g_skw[l_acd].s12 = 0
       LET g_skw[l_acd].s13 = 0
       LET g_skw[l_acd].s14 = 0
       LET g_skw[l_acd].s15 = 0
       LET g_skw[l_acd].s16 = 0
       LET g_skw[l_acd].s17 = 0
       LET g_skw[l_acd].s18 = 0
       LET g_skw[l_acd].s19 = 0
       LET g_skw[l_acd].s20 = 0
       NEXT FIELD skw03
 
     BEFORE ROW
       LET l_acd = ARR_CURR()   
       LET g_rec_d = ARR_COUNT()
       LET l_skw03_t = g_skw[l_acd].skw03
       LET l_skw04_t = g_skw[l_acd].skw04
       LET l_skw05_t = g_skw[l_acd].skw05
       LET l_skw08_t = g_skw[l_acd].skw08
 
     AFTER INSERT
       IF INT_FLAG THEN         
          CALL cl_err('',9001,0)        
          LET INT_FLAG = 0 
          CANCEL INSERT    
       END IF
       LET i= 1
 
       FOR i = 1 TO g_j
 
        	INSERT INTO skw_file(skw01,skw02,skw03,skw04,skw05,skw06,skw07,skw08,skwplant,skwlegal) #FUN-980008 add skwplant,skwlegal
        	  VALUES(g_sku.sku01,g_sku.sku02,g_skw[l_acd].skw03,g_skw[l_acd].skw04,
        	         g_skw[l_acd].skw05,g_value[i].nvalue,g_value[i].value[l_acd],
        	         g_skw[l_acd].skw08,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
          IF SQLCA.sqlcode THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
          ELSE 
             MESSAGE ' INSERT skw_file O.K. '
          END IF
       END FOR
 
       LET g_rec_d = g_rec_d + 1
       DISPLAY g_rec_d TO FORMONLY.cn2
 
     BEFORE DELETE
       IF NOT cl_delb(0,0) THEN  
          CANCEL DELETE
       END IF
       DELETE FROM skw_file
        WHERE skw01 =g_sku.sku01
          AND skw02 =g_sku.sku02
          AND skw03 =l_skw03_t
       IF SQLCA.sqlcode THEN
           CALL cl_err('del sagf',SQLCA.sqlcode,0)
           ROLLBACK WORK
           CANCEL DELETE
       END IF
       LET g_rec_d=g_rec_d-1
       DISPLAY g_rec_d TO FORMONLY.cn2
       COMMIT WORK
 
     ON ROW CHANGE              
       IF INT_FLAG THEN   
          CALL cl_err('',9001,0)
          EXIT INPUT                 
       END IF   
       FOR i = 1 TO g_j
          IF NOT  cl_null(g_value[i].value[l_acd]) THEN
	           UPDATE skw_file SET
	                  skw03 = g_skw[l_acd].skw03,
	                  skw04 = g_skw[l_acd].skw04,
	                  skw05 = g_skw[l_acd].skw05,
	                  skw07 = g_value[i].value[l_acd],
                    skw08 = g_skw[l_acd].skw08
	            WHERE skw01 =g_sku.sku01
	              AND skw02 =g_sku.sku02
                AND skw03 =l_skw03_t
	              AND skw04 =l_skw04_t
	              AND skw05 =l_skw05_t
	              AND skw06 =g_value[i].valuen
 
             IF SQLCA.sqlcode THEN
	              CALL cl_err('',SQLCA.sqlcode,1)
	              EXIT FOR
	              LET g_success = 'N'
             ELSE 
	              MESSAGE ' UPDATE skw_file O.K. '
             END IF
          END IF
       END FOR      
 
 
     AFTER ROW
       LET l_acd =  ARR_CURR()
       LET l_acd_t = l_acd
       IF INT_FLAG THEN   
          CALL cl_err('',9001,0)                    
          EXIT INPUT                 
       END IF 
       
 
        BEFORE FIELD skw03                            #default 序號
           IF g_skw[l_acd].skw03 is null OR g_skw[l_acd].skw03 = 0 THEN
              SELECT MAX(skw03) +1 INTO g_skw[l_acd].skw03
                FROM skw_file
               WHERE skw01 = g_sku.sku01
                 AND skw02 = g_sku.sku02
              IF g_skw[l_acd].skw03 is null THEN
                 LET g_skw[l_acd].skw03 = 1
              END IF
           END IF
 
        AFTER FIELD skw03                        #check 序號是否重復
          IF cl_null(g_skw[l_acd].skw03) THEN
             LET g_skw[l_acd].skw03 = 1
          ELSE
             IF g_skw[l_acd].skw03 != l_skw03_t OR l_skw03_t IS NULL THEN
                SELECT count(*) INTO l_n FROM skw_file
                 WHERE skw01 = g_sku.sku01
                   AND skw02 = g_sku.sku02
                   AND skw03 = g_skw[l_acd].skw03
                IF l_n > 0 THEN
                   LET g_skw[l_acd].skw03 = l_skw03_t
                   CALL cl_err('',-239,0)
                   NEXT FIELD skw03
                END IF
             END IF
          END IF
 
	     AFTER FIELD skw04
	        IF NOT cl_null(g_skw[l_acd].skw04) THEN
	           SELECT COUNT(*) INTO l_cnt
	             FROM geb_file
	            WHERE geb01 = g_skw[l_acd].skw04
             IF l_cnt <= 0 THEN
                CALL cl_err(g_skw[l_acd].skw04,'aom-152',1)
                NEXT FIELD skw04
             END IF
	        END IF
 
       AFTER FIELD skw05
         IF NOT cl_null(g_skw[l_acd].skw05) THEN
             SELECT COUNT(*) INTO l_cnt
               FROM agd_file
              WHERE agd02=g_skw[l_acd].skw05
               IF l_cnt <= 0 THEN
                 CALL cl_err(' ','agd-002',0)
                 NEXT FIELD skw05
               END IF
            SELECT agd03 INTO g_skw[l_acd].agd03 FROM agd_file
              WHERE agd02=g_skw[l_acd].skw05
                AND agd01=g_sla.sla03 #TQC-940111  
            DISPLAY g_skw[l_acd].agd03 TO agd03
           END IF
       
       AFTER FIELD skw08
         IF NOT cl_null(g_skw[l_acd].skw08) THEN
             SELECT COUNT(*) INTO l_cnt
               FROM agd_file
               WHERE agd02=g_skw[l_acd].skw08
               IF l_cnt <= 0 THEN
                 CALL cl_err(' ','agd-001',0) 
                 NEXT FIELD skw08
               END IF
            SELECT agd03 INTO g_skw[l_acd].agd03_2 FROM agd_file
              WHERE agd02=g_skw[l_acd].skw08
                AND agd01=g_sla.sla03 #TQC-940111   
            DISPLAY g_skw[l_acd].agd03_2 TO agd03_2
         END IF
 
     AFTER FIELD s01
       IF NOT cl_null(g_skw[l_acd].s01) THEN                  
          IF g_skw[l_acd].s01 < 0 THEN
             CALL cl_err(g_skw[l_acd].s01,'ask-084',0)
             NEXT FIELD s01
          END IF
          LET g_value[1].value[l_acd] = g_skw[l_acd].s01
       END IF
 
     AFTER FIELD s02
       IF NOT cl_null(g_skw[l_acd].s02) THEN                  
          IF g_skw[l_acd].s02 < 0 THEN
             CALL cl_err(g_skw[l_acd].s02,'ask-084',0)
             NEXT FIELD s02
          END IF
          LET g_value[2].value[l_acd] = g_skw[l_acd].s02
       END IF
 
     AFTER FIELD s03
       IF NOT cl_null(g_skw[l_acd].s03) THEN                  
          IF g_skw[l_acd].s03 < 0 THEN
             CALL cl_err(g_skw[l_acd].s03,'ask-084',0)
             NEXT FIELD s03
          END IF
          LET g_value[3].value[l_acd] = g_skw[l_acd].s03
       END IF
 
     AFTER FIELD s04
       IF NOT cl_null(g_skw[l_acd].s04) THEN 
          IF g_skw[l_acd].s04 < 0 THEN
             CALL cl_err(g_skw[l_acd].s04,'ask-084',0)
             NEXT FIELD s04
          END IF
          LET g_value[4].value[l_acd] = g_skw[l_acd].s04
       END IF
 
     AFTER FIELD s05
       IF NOT cl_null(g_skw[l_acd].s05) THEN 
          IF g_skw[l_acd].s05 < 0 THEN
             CALL cl_err(g_skw[l_acd].s05,'ask-084',0)
             NEXT FIELD s05
          END IF
          LET g_value[5].value[l_acd] = g_skw[l_acd].s05
       END IF
 
     AFTER FIELD s06
       IF NOT cl_null(g_skw[l_acd].s06) THEN 
          IF g_skw[l_acd].s06 < 0 THEN
             CALL cl_err(g_skw[l_acd].s06,'ask-084',0)
             NEXT FIELD s06
          END IF
          LET g_value[6].value[l_acd] = g_skw[l_acd].s06
       END IF
 
     AFTER FIELD s07
       IF NOT cl_null(g_skw[l_acd].s07) THEN 
          IF g_skw[l_acd].s07 < 0 THEN
             CALL cl_err(g_skw[l_acd].s07,'ask-084',0)
             NEXT FIELD s07
          END IF
          LET g_value[7].value[l_acd] = g_skw[l_acd].s07
       END IF
 
     AFTER FIELD s08
       IF NOT cl_null(g_skw[l_acd].s08) THEN 
          IF g_skw[l_acd].s08 < 0 THEN
             CALL cl_err(g_skw[l_acd].s08,'ask-084',0)
             NEXT FIELD s08
          END IF
          LET g_value[8].value[l_acd] = g_skw[l_acd].s08
       END IF
 
     AFTER FIELD s09
       IF NOT cl_null(g_skw[l_acd].s09) THEN 
          IF g_skw[l_acd].s09 < 0 THEN
             CALL cl_err(g_skw[l_acd].s09,'ask-084',0)
             NEXT FIELD s09
          END IF
          LET g_value[9].value[l_acd] = g_skw[l_acd].s09
       END IF
 
     AFTER FIELD s10
       IF NOT cl_null(g_skw[l_acd].s10) THEN 
          IF g_skw[l_acd].s10 < 0 THEN
             CALL cl_err(g_skw[l_acd].s10,'ask-084',0)
             NEXT FIELD s10
          END IF
          LET g_value[10].value[l_acd] = g_skw[l_acd].s10
       END IF
 
     AFTER FIELD s11
       IF NOT cl_null(g_skw[l_acd].s11) THEN 
          IF g_skw[l_acd].s11 < 0 THEN
             CALL cl_err(g_skw[l_acd].s11,'ask-084',0)
             NEXT FIELD s11
          END IF
          LET g_value[11].value[l_acd] = g_skw[l_acd].s11
       END IF
 
     AFTER FIELD s12
       IF NOT cl_null(g_skw[l_acd].s12) THEN 
          IF g_skw[l_acd].s12 < 0 THEN
             CALL cl_err(g_skw[l_acd].s12,'ask-084',0)
             NEXT FIELD s12
          END IF
          LET g_value[12].value[l_acd] = g_skw[l_acd].s12
       END IF
 
     AFTER FIELD s13
       IF NOT cl_null(g_skw[l_acd].s13) THEN 
          IF g_skw[l_acd].s13 < 0 THEN
             CALL cl_err(g_skw[l_acd].s13,'ask-084',0)
             NEXT FIELD s13
          END IF
          LET g_value[13].value[l_acd] = g_skw[l_acd].s13
       END IF
 
     AFTER FIELD s14
       IF NOT cl_null(g_skw[l_acd].s14) THEN 
          IF g_skw[l_acd].s14 < 0 THEN
             CALL cl_err(g_skw[l_acd].s14,'ask-084',0)
             NEXT FIELD s14
          END IF
          LET g_value[14].value[l_acd] = g_skw[l_acd].s14
       END IF
 
     AFTER FIELD s15
       IF NOT cl_null(g_skw[l_acd].s15) THEN 
          IF g_skw[l_acd].s15 < 0 THEN
             CALL cl_err(g_skw[l_acd].s15,'ask-084',0)
             NEXT FIELD s15
          END IF
          LET g_value[15].value[l_acd] = g_skw[l_acd].s15
       END IF
 
     AFTER FIELD s16
       IF NOT cl_null(g_skw[l_acd].s16) THEN 
          IF g_skw[l_acd].s16 < 0 THEN
             CALL cl_err(g_skw[l_acd].s16,'ask-084',0)
             NEXT FIELD s16
          END IF
          LET g_value[16].value[l_acd] = g_skw[l_acd].s16
       END IF
 
     AFTER FIELD s17
       IF NOT cl_null(g_skw[l_acd].s17) THEN 
          IF g_skw[l_acd].s17 < 0 THEN
             CALL cl_err(g_skw[l_acd].s17,'ask-084',0)
             NEXT FIELD s17
          END IF
          LET g_value[17].value[l_acd] = g_skw[l_acd].s17
       END IF
 
     AFTER FIELD s18
       IF NOT cl_null(g_skw[l_acd].s18) THEN 
          IF g_skw[l_acd].s18 < 0 THEN
             CALL cl_err(g_skw[l_acd].s18,'ask-084',0)
             NEXT FIELD s18
          END IF
          LET g_value[18].value[l_acd] = g_skw[l_acd].s18
       END IF
 
     AFTER FIELD s19
       IF NOT cl_null(g_skw[l_acd].s19) THEN 
          IF g_skw[l_acd].s19 < 0 THEN
             CALL cl_err(g_skw[l_acd].s19,'ask-084',0)
             NEXT FIELD s19
          END IF
          LET g_value[19].value[l_acd] = g_skw[l_acd].s19
       END IF
 
     AFTER FIELD s20
       IF NOT cl_null(g_skw[l_acd].s20) THEN 
          IF g_skw[l_acd].s20 < 0 THEN
             CALL cl_err(g_skw[l_acd].s20,'ask-084',0)
             NEXT FIELD s20
          END IF
          LET g_value[20].value[l_acd] = g_skw[l_acd].s20
       END IF
 
 
        ON ACTION controlp
           CASE 
	        WHEN INFIELD(skw04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_geb"
                     LET g_qryparam.default1 = g_skw[l_acd].skw04
                     CALL cl_create_qry() RETURNING g_skw[l_acd].skw04
                     DISPLAY BY NAME g_skw[l_acd].skw04  #No.MOD-490371
                     NEXT FIELD skw04
                  
	        WHEN INFIELD(skw05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_agd1"
                     LET g_qryparam.arg1     = g_sla.sla02
                     LET g_qryparam.default1 = g_skw[l_acd].skw05
                     CALL cl_create_qry() RETURNING g_skw[l_acd].skw05
                     DISPLAY BY NAME g_skw[l_acd].skw05 
                     NEXT FIELD skw05
             
                WHEN INFIELD(skw08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_agd1"
                     LET g_qryparam.arg1     = g_sla.sla03
                     LET g_qryparam.default1 = g_skw[l_acd].skw08
                     CALL cl_create_qry() RETURNING g_skw[l_acd].skw08 
                     NEXT FIELD skw08
           END CASE
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       RETURN 1 
    END IF   
 
    END INPUT
 
END FUNCTION
 
FUNCTION i011_d_fill(p_wc2)
  DEFINE 
       p_wc2           STRING       #NO.FUN-910082 
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
  DEFINE l_mm    LIKE type_file.chr1
  DEFINE j       LIKE type_file.num5
  DEFINE l_ocq04     LIKE ocq_file.ocq04
  CALL i011_c()
 
  FOR j = 1 TO g_j
    SELECT DISTINCT ocq04 INTO l_ocq04
      FROM ocq_file
     WHERE ocq06 = '1'
    LET g_value[j].nvalue = l_ocq04
  END FOR
 
  LET l_sql =" SELECT skw03,skw04,skw05,' ',skw08,' ',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ",
	     "   FROM skw_file ",
	     "  WHERE skw01 = '",g_sku.sku01,"'",
	     "    AND skw02 = '",g_sku.sku02,"'",
	     " GROUP BY skw03,skw04,skw05,skw08 ",
	     " ORDER BY skw03"
 
     PREPARE i100f_tmp3 FROM l_sql
     DECLARE tmp3_cur3 CURSOR FOR i100f_tmp3
   
     CALL i011_d_title()
     CALL g_skw.clear()
     LET g_cnt = 1
     LET g_rec_d = 0
     FOREACH tmp3_cur3 INTO g_skw[g_cnt].*
        IF STATUS THEN 
           CALL cl_err('foreach color:',STATUS,0)   
           EXIT FOREACH                         
        END IF
 
        SELECT agd03 INTO g_skw[g_cnt].agd03 FROM agd_file
          WHERE agd02=g_skw[g_cnt].skw05
            AND agd01=g_sla.sla03 #TQC-940111  
        SELECT agd03 INTO g_skw[g_cnt].agd03_2 FROM agd_file
          WHERE agd02=g_skw[g_cnt].skw08
	    AND agd01=g_sla.sla03 #TQC-940111 
        FOR j = 1 TO g_j
      	   CASE 
      	       WHEN j = 1
      	         SELECT skw07 INTO  g_skw[g_cnt].s01
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s01
      	       WHEN j = 2   
      	         SELECT skw07 INTO  g_skw[g_cnt].s02
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s02
      	       WHEN j = 3   
      	         SELECT skw07 INTO  g_skw[g_cnt].s03
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		        LET g_value[j].value[g_cnt] = g_skw[g_cnt].s03
      	       WHEN j = 4   
      	         SELECT skw07 INTO  g_skw[g_cnt].s04
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s04
      	       WHEN j = 5   
      	         SELECT skw07 INTO  g_skw[g_cnt].s05
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s05
      	       WHEN j = 6   
      	         SELECT skw07 INTO  g_skw[g_cnt].s06
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s06
      	       WHEN j = 7   
      	         SELECT skw07 INTO  g_skw[g_cnt].s07
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		        LET g_value[j].value[g_cnt] = g_skw[g_cnt].s07
      	       WHEN j = 8   
      	         SELECT skw07 INTO  g_skw[g_cnt].s08
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s08
      	       WHEN j = 9   
      	         SELECT skw07 INTO  g_skw[g_cnt].s09
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s09
      	       WHEN j = 10   
      	         SELECT skw07 INTO  g_skw[g_cnt].s10
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s10
      	       WHEN j = 11   
      	         SELECT skw07 INTO  g_skw[g_cnt].s11
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s11
      	       WHEN j = 12   
      	         SELECT skw07 INTO  g_skw[g_cnt].s12
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s12
      	       WHEN j = 13   
      	         SELECT skw07 INTO  g_skw[g_cnt].s13
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s13
      	       WHEN j = 14   
      	         SELECT skw07 INTO  g_skw[g_cnt].s14
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		        LET g_value[j].value[g_cnt] = g_skw[g_cnt].s14
      	       WHEN j = 15  
      	         SELECT skw07 INTO  g_skw[g_cnt].s15
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s15
      	       WHEN j = 16   
      	         SELECT skw07 INTO  g_skw[g_cnt].s16
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		        LET g_value[j].value[g_cnt] = g_skw[g_cnt].s16
      	       WHEN j = 17  
      	         SELECT skw07 INTO  g_skw[g_cnt].s17
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		        LET g_value[j].value[g_cnt] = g_skw[g_cnt].s17
      	       WHEN j = 18  
      	         SELECT skw07 INTO  g_skw[g_cnt].s18
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s18
      	       WHEN j = 19   
      	         SELECT skw07 INTO  g_skw[g_cnt].s19
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		       LET g_value[j].value[g_cnt] = g_skw[g_cnt].s19
      	       WHEN j = 20   
      	         SELECT skw07 INTO  g_skw[g_cnt].s20
      		         FROM skw_file
      	          WHERE skw01 = g_sku.sku01 
      		          AND skw02 = g_sku.sku02		    
      		          AND skw03 = g_skw[g_cnt].skw03		    
      		          AND skw06 = g_value[j].valuen
      		      LET g_value[j].value[g_cnt] = g_skw[g_cnt].s20	   
      	   END CASE
	      END FOR
 
        LET g_cnt =  g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
     END FOREACH
 
     CALL g_skw.deleteElement(g_cnt)
     LET g_rec_d = g_cnt - 1
     DISPLAY g_rec_d TO FORMONLY.cn2
     DISPLAY ARRAY g_skw TO s_skw.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
     END DISPLAY
 
     LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i011_b()
  DEFINE    l_msg        STRING,
            l_n,l_cnt,i,l_ac_t LIKE type_file.num5,
            l_sql        STRING,       #NO.FUN-910082  
	          l_skv03_t    LIKE   skv_file.skv03,
	          l_skv04_t    LIKE   skv_file.skv04,
	          l_skv06_t    LIKE   skv_file.skv06,
	          l_skv07_t    LIKE   skv_file.skv07,
	          l_skv08_t    LIKE   skv_file.skv08,
	          l_skv09_t    LIKE   skv_file.skv09,
	          l_skv10_t    LIKE   skv_file.skv10,
	          l_skv11_t    LIKE   skv_file.skv11,
	          l_skv13_t    LIKE   skv_file.skv13
 
     CALL i011_c1()
  
     INPUT ARRAY g_skv WITHOUT DEFAULTS FROM s_skv.*    
     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,INSERT ROW=TRUE,
               DELETE ROW=TRUE,APPEND ROW=TRUE)        
                                                      
     BEFORE INPUT                                    
       IF g_rec_b != 0 THEN                         
          CALL fgl_set_arr_curr(l_ac)              
       END IF           
 
     BEFORE INSERT
       LET g_rec_b = ARR_COUNT()
       LET g_skv[l_ac].ss01 = 0
       LET g_skv[l_ac].ss02 = 0
       LET g_skv[l_ac].ss03 = 0
       LET g_skv[l_ac].ss04 = 0
       LET g_skv[l_ac].ss05 = 0
       LET g_skv[l_ac].ss06 = 0
       LET g_skv[l_ac].ss07 = 0
       LET g_skv[l_ac].ss08 = 0
       LET g_skv[l_ac].ss09 = 0
       LET g_skv[l_ac].ss10 = 0
       LET g_skv[l_ac].ss11 = 0
       LET g_skv[l_ac].ss12 = 0
       LET g_skv[l_ac].ss13 = 0
       LET g_skv[l_ac].ss14 = 0
       LET g_skv[l_ac].ss15 = 0
       LET g_skv[l_ac].ss16 = 0
       LET g_skv[l_ac].ss17 = 0
       LET g_skv[l_ac].ss18 = 0
       LET g_skv[l_ac].ss19 = 0
       LET g_skv[l_ac].ss20 = 0
       NEXT FIELD skv03
 
     BEFORE ROW
       LET l_ac = ARR_CURR()   
       LET g_rec_b = ARR_COUNT()   
       LET l_skv03_t = g_skv[l_ac].skv03
       LET l_skv04_t = g_skv[l_ac].skv04
       LET l_skv06_t = g_skv[l_ac].skv06
       LET l_skv07_t = g_skv[l_ac].skv07
       LET l_skv08_t = g_skv[l_ac].skv08
       LET l_skv09_t = g_skv[l_ac].skv09
       LET l_skv10_t = g_skv[l_ac].skv10
       LET l_skv11_t = g_skv[l_ac].skv11
       LET l_skv13_t = g_skv[l_ac].skv13
     
     AFTER INSERT
       IF INT_FLAG THEN         
          CALL cl_err('',9001,0)        
          LET INT_FLAG = 0 
          CANCEL INSERT    
       END IF
       LET i= 1
 
       FOR i = 1 TO g_j1
 
	INSERT INTO skv_file(skv01,skv02,skv03,skv04,skv05,skv06,skv07,skv08,
	                     skv09,skv10,skv11,skv12,skv13,skvplant,skvlegal) #FUN-980008 add skvplant,skvlegal
	  VALUES(g_sku.sku01,g_sku.sku02,g_skv[l_ac].skv03,g_skv[l_ac].skv04,
	         g_value[i].valuen,g_skv[l_ac].skv06,g_skv[l_ac].skv07,
	         g_skv[l_ac].skv08,g_skv[l_ac].skv09,g_skv[l_ac].skv10,
	         g_skv[l_ac].skv11,g_value[i].value[l_ac],g_skv[l_ac].skv13,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               ELSE 
                  MESSAGE ' INSERT skv_file O.K. '
               END IF
       END FOR
 
       LET g_rec_b = g_rec_b + 1
       DISPLAY g_rec_b TO FORMONLY.cn2
 
     BEFORE DELETE
       IF NOT cl_delb(0,0) THEN  
          CANCEL DELETE
       END IF
       	 DELETE FROM skv_file
	 WHERE skv01 =g_sku.sku01
	   AND skv02 =g_sku.sku02
           AND skv03 =l_skv03_t
	IF SQLCA.sqlcode THEN
	    CALL cl_err('del sagf',SQLCA.sqlcode,0)
	    ROLLBACK WORK
	    CANCEL DELETE
	END IF
	LET g_rec_b=g_rec_b-1
	DISPLAY g_rec_b TO FORMONLY.cn2
	COMMIT WORK
 
     ON ROW CHANGE              
       IF INT_FLAG THEN   
          CALL cl_err('',9001,0)            
          EXIT INPUT                 
       END IF   
       FOR i = 1 TO g_j1
        IF  cl_null(g_value[i].value[l_ac]) THEN
         SELECT skv12 INTO g_value[i].value[l_ac] FROM skv_file 
           WHERE skv01 =g_sku.sku01
           AND skv02 =g_sku.sku02
           AND skv03 =l_skv03_t
           AND skv05 =g_value[i].valuen
        END IF
 
	 UPDATE skv_file SET
	   skv03 = g_skv[l_ac].skv03,
	   skv04 = g_skv[l_ac].skv04,
	   skv06 = g_skv[l_ac].skv06,
	   skv07 = g_skv[l_ac].skv07,
	   skv08 = g_skv[l_ac].skv08,
	   skv09 = g_skv[l_ac].skv09,
	   skv10 = g_skv[l_ac].skv10,
	   skv11 = g_skv[l_ac].skv11,
	   skv12 = g_value[i].value[l_ac],
           skv13 = g_skv[l_ac].skv13
	 WHERE skv01 =g_sku.sku01
	   AND skv02 =g_sku.sku02
           AND skv03 =l_skv03_t
	   AND skv05 =g_value[i].valuen
 
         IF SQLCA.sqlcode THEN
	  CALL cl_err('',SQLCA.sqlcode,1)
	  EXIT FOR
	  LET g_success = 'N'
         ELSE 
	  MESSAGE ' UPDATE skv_file O.K. '
         END IF
 
      END FOR      
 
 
     AFTER ROW
       LET l_ac =  ARR_CURR()
       LET l_ac_t = l_ac
       IF INT_FLAG THEN   
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0                    
          EXIT INPUT                 
       END IF 
       
 
        BEFORE FIELD skv03                            #default 序號
	  IF g_skv[l_ac].skv03 is null OR g_skv[l_ac].skv03 = 0 THEN
		SELECT MAX(skv03) +1 INTO g_skv[l_ac].skv03
		  FROM skv_file
		 WHERE skv01 = g_sku.sku01
	           AND skv02 = g_sku.sku02
		IF g_skv[l_ac].skv03 is null THEN
		  LET g_skv[l_ac].skv03 = 1
		END IF
	  END IF
 
     AFTER FIELD skv03                        #check 序號是否重復
       IF cl_null(g_skv[l_ac].skv03) THEN
          LET g_skv[l_ac].skv03 = 1
       ELSE
          IF g_skv[l_ac].skv03 != l_skv03_t OR
             l_skv03_t IS NULL THEN
             SELECT count(*) INTO l_n FROM skv_file
              WHERE skv01 = g_sku.sku01
                AND skv02 = g_sku.sku02
                AND skv03 = g_skv[l_ac].skv03 
             IF l_n > 0 THEN
                LET g_skv[l_ac].skv03 = l_skv03_t
                CALL cl_err('',-239,0)
                NEXT FIELD skv03
             ELSE
               DISPLAY g_skv[l_ac].skv03 TO skv03
             END IF
          END IF
       END IF
 
     AFTER FIELD skv04
       IF cl_null(g_skv[l_ac].skv04) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv04
       ELSE
        DISPLAY g_skv[l_ac].skv04 TO skv04
       END IF
     
     AFTER FIELD skv06
         IF cl_null(g_skv[l_ac].skv06) THEN
           CALL cl_err(' ','mfg3018',0)
           NEXT FIELD skv06
         ELSE
             SELECT COUNT(*) INTO l_cnt
               FROM agd_file
              WHERE agd02=g_skv[l_ac].skv06
               IF l_cnt <= 0 THEN
                 CALL cl_err(' ','agd-002',0)
                 NEXT FIELD skv06
               END IF
            SELECT agd03 INTO g_skv[l_ac].agd03_3 FROM agd_file
              WHERE agd02=g_skv[l_ac].skv06
                AND agd01=g_sla.sla03 #TQC-940111   
            DISPLAY g_skv[l_ac].skv06 TO skv06
            DISPLAY g_skv[l_ac].agd03_3 TO agd03_3
         END IF
	   
     AFTER FIELD skv07
       IF cl_null(g_skv[l_ac].skv07) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv07
       ELSE
         DISPLAY g_skv[l_ac].skv07 TO skv07
       END IF
 
     AFTER FIELD skv08
       IF cl_null(g_skv[l_ac].skv08) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv08
       ELSE
         DISPLAY g_skv[l_ac].skv08 TO skv08
       END IF
 
     AFTER FIELD skv10
       IF cl_null(g_skv[l_ac].skv10) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv10
       ELSE
         DISPLAY g_skv[l_ac].skv10 TO skv10
       END IF
 
     AFTER FIELD skv11
       IF cl_null(g_skv[l_ac].skv11) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv11
       ELSE
         DISPLAY g_skv[l_ac].skv11 TO skv11
       END IF
 
     AFTER FIELD skv13
       IF NOT cl_null(g_skv[l_ac].skv13) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skv[l_ac].skv13,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skv[l_ac].skv13= g_skv_t.skv13
               NEXT FIELD skv13
            END IF
#FUN-AA0059 ---------------------end-------------------------------
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
                WHERE ima01 = g_skv[l_ac].skv13
              IF l_cnt = 0 THEN
                 CALL cl_err('','mfg0002',1)
                 NEXT FIELD skv13
              END IF
          SELECT ima02 INTO g_skv[l_ac].ima02_2 
            FROM ima_file WHERE ima01 = g_skv[l_ac].skv13
          DISPLAY g_skv[l_ac].ima02_2 TO ima02_2
          DISPLAY g_skv[l_ac].skv13 TO skv13
        END IF
 
     AFTER FIELD ss01
       IF NOT cl_null(g_skv[l_ac].ss01) THEN                  
          IF g_skv[l_ac].ss01 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss01,'ask-084',0)
             NEXT FIELD ss01
          END IF
          LET g_value[1].value[l_ac] = g_skv[l_ac].ss01
       END IF
 
     AFTER FIELD ss02
       IF NOT cl_null(g_skv[l_ac].ss02) THEN                  
          IF g_skv[l_ac].ss02 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss02,'ask-084',0)
             NEXT FIELD ss02
          END IF
          LET g_value[2].value[l_ac] = g_skv[l_ac].ss02
       END IF
 
     AFTER FIELD ss03
       IF NOT cl_null(g_skv[l_ac].ss03) THEN                  
          IF g_skv[l_ac].ss03 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss03,'ask-084',0)
             NEXT FIELD ss03
          END IF
          LET g_value[3].value[l_ac] = g_skv[l_ac].ss03
       END IF
 
     AFTER FIELD ss04
       IF NOT cl_null(g_skv[l_ac].ss04) THEN 
          IF g_skv[l_ac].ss04 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss04,'ask-084',0)
             NEXT FIELD ss04
          END IF
          LET g_value[4].value[l_ac] = g_skv[l_ac].ss04
       END IF
 
     AFTER FIELD ss05
       IF NOT cl_null(g_skv[l_ac].ss05) THEN 
          IF g_skv[l_ac].ss05 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss05,'ask-084',0)
             NEXT FIELD ss05
          END IF
          LET g_value[5].value[l_ac] = g_skv[l_ac].ss05
       END IF
 
     AFTER FIELD ss06
       IF NOT cl_null(g_skv[l_ac].ss06) THEN 
          IF g_skv[l_ac].ss06 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss06,'ask-084',0)
             NEXT FIELD ss06
          END IF
          LET g_value[6].value[l_ac] = g_skv[l_ac].ss06
       END IF
 
     AFTER FIELD ss07
       IF NOT cl_null(g_skv[l_ac].ss07) THEN 
          IF g_skv[l_ac].ss07 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss07,'ask-084',0)
             NEXT FIELD ss07
          END IF
          LET g_value[7].value[l_ac] = g_skv[l_ac].ss07
       END IF
 
     AFTER FIELD ss08
       IF NOT cl_null(g_skv[l_ac].ss08) THEN 
          IF g_skv[l_ac].ss08 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss08,'ask-084',0)
             NEXT FIELD ss08
          END IF
          LET g_value[8].value[l_ac] = g_skv[l_ac].ss08
       END IF
 
     AFTER FIELD ss09
       IF NOT cl_null(g_skv[l_ac].ss09) THEN 
          IF g_skv[l_ac].ss09 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss09,'ask-084',0)
             NEXT FIELD ss09
          END IF
          LET g_value[9].value[l_ac] = g_skv[l_ac].ss09
       END IF
 
     AFTER FIELD ss10
       IF NOT cl_null(g_skv[l_ac].ss10) THEN 
          IF g_skv[l_ac].ss10 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss10,'ask-084',0)
             NEXT FIELD ss10
          END IF
          LET g_value[10].value[l_ac] = g_skv[l_ac].ss10
       END IF
 
     AFTER FIELD ss11
       IF NOT cl_null(g_skv[l_ac].ss11) THEN 
          IF g_skv[l_ac].ss11 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss11,'ask-084',0)
             NEXT FIELD ss11
          END IF
          LET g_value[11].value[l_ac] = g_skv[l_ac].ss11
       END IF
 
     AFTER FIELD ss12
       IF NOT cl_null(g_skv[l_ac].ss12) THEN 
          IF g_skv[l_ac].ss12 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss12,'ask-084',0)
             NEXT FIELD ss12
          END IF
          LET g_value[12].value[l_ac] = g_skv[l_ac].ss12
       END IF
 
     AFTER FIELD ss13
       IF NOT cl_null(g_skv[l_ac].ss13) THEN 
          IF g_skv[l_ac].ss13 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss13,'ask-084',0)
             NEXT FIELD ss13
          END IF
          LET g_value[13].value[l_ac] = g_skv[l_ac].ss13
       END IF
 
     AFTER FIELD ss14
       IF NOT cl_null(g_skv[l_ac].ss14) THEN 
          IF g_skv[l_ac].ss14 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss14,'ask-084',0)
             NEXT FIELD ss14
          END IF
          LET g_value[14].value[l_ac] = g_skv[l_ac].ss14
       END IF
 
     AFTER FIELD ss15
       IF NOT cl_null(g_skv[l_ac].ss15) THEN 
          IF g_skv[l_ac].ss15 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss15,'ask-084',0)
             NEXT FIELD ss15
          END IF
          LET g_value[15].value[l_ac] = g_skv[l_ac].ss15
       END IF
 
     AFTER FIELD ss16
       IF NOT cl_null(g_skv[l_ac].ss16) THEN 
          IF g_skv[l_ac].ss16 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss16,'ask-084',0)
             NEXT FIELD ss16
          END IF
          LET g_value[16].value[l_ac] = g_skv[l_ac].ss16
       END IF
 
     AFTER FIELD ss17
       IF NOT cl_null(g_skv[l_ac].ss17) THEN 
          IF g_skv[l_ac].ss17 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss17,'ask-084',0)
             NEXT FIELD ss17
          END IF
          LET g_value[17].value[l_ac] = g_skv[l_ac].ss17
       END IF
 
     AFTER FIELD ss18
       IF NOT cl_null(g_skv[l_ac].ss18) THEN 
          IF g_skv[l_ac].ss18 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss18,'ask-084',0)
             NEXT FIELD ss18
          END IF
          LET g_value[18].value[l_ac] = g_skv[l_ac].ss18
       END IF
 
     AFTER FIELD ss19
       IF NOT cl_null(g_skv[l_ac].ss19) THEN 
          IF g_skv[l_ac].ss19 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss19,'ask-084',0)
             NEXT FIELD ss19
          END IF
          LET g_value[19].value[l_ac] = g_skv[l_ac].ss19
       END IF
 
     AFTER FIELD ss20
       IF NOT cl_null(g_skv[l_ac].ss20) THEN 
          IF g_skv[l_ac].ss20 < 0 THEN
             CALL cl_err(g_skv[l_ac].ss20,'ask-084',0)
             NEXT FIELD ss20
          END IF
          LET g_value[20].value[l_ac] = g_skv[l_ac].ss20
       END IF
    
    AFTER FIELD skv09
    IF cl_null(g_skv[l_ac].skv09) THEN
         CALL cl_err(' ','mfg3018',0)
         NEXT FIELD skv09
    ELSE
       DISPLAY g_skv[l_ac].skv09 TO skv09
       LET g_skv[l_ac].skv10 = g_skv[l_ac].ss01+g_skv[l_ac].ss02
             +g_skv[l_ac].ss03+g_skv[l_ac].ss04+g_skv[l_ac].ss05
             +g_skv[l_ac].ss06+g_skv[l_ac].ss07+g_skv[l_ac].ss08
             +g_skv[l_ac].ss09+g_skv[l_ac].ss10+g_skv[l_ac].ss11
             +g_skv[l_ac].ss12+g_skv[l_ac].ss13+g_skv[l_ac].ss14
             +g_skv[l_ac].ss15+g_skv[l_ac].ss16+g_skv[l_ac].ss17
             +g_skv[l_ac].ss18+g_skv[l_ac].ss19+g_skv[l_ac].ss20
       
       IF g_skv[l_ac].skv10 IS NULL THEN LET g_skv[l_ac].skv10=0 END IF
       LET g_skv[l_ac].skv10=g_skv[l_ac].skv10*g_skv[l_ac].skv09
       DISPLAY g_skv[l_ac].skv10 TO skv10
 
       LET g_skv[l_ac].skv11=g_skv[l_ac].skv08*g_skv[l_ac].skv09
       DISPLAY g_skv[l_ac].skv11 TO skv11
     END IF
 
     ON ACTION controlp
           CASE
                WHEN INFIELD(skv06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_agd1"
                     LET g_qryparam.arg1     = g_sla.sla02
                     LET g_qryparam.default1 = g_skv[l_ac].skv06
                     CALL cl_create_qry() RETURNING g_skv[l_ac].skv06
                     DISPLAY BY NAME g_skv[l_ac].skv06
                     NEXT FIELD skv06
 
                WHEN INFIELD(skv13)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.default1 = g_skv[l_ac].skv13
#                CALL cl_create_qry() RETURNING g_skv[l_ac].skv13 
                 CALL q_sel_ima(FALSE, "q_ima","",g_skv[l_ac].skv13,"","","","","",'' ) 
                    RETURNING g_skv[l_ac].skv13  
#FUN-AA0059---------mod------------end-----------------
                 NEXT FIELD skv13
 
           END CASE
        ON ACTION CONTROLO   
           IF INFIELD(skv03) AND l_ac >= 1 THEN
              LET g_skv[l_ac].* = g_skv[l_ac-1].*
              LET g_skv[l_ac].skv03 = NULL
              NEXT FIELD skv03
           END IF 
 
    END INPUT
 
END FUNCTION
 
 
FUNCTION i011_b_fill(p_wc2)
  DEFINE 
         p_wc2           STRING       #NO.FUN-910082 
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082  
  DEFINE l_mm    LIKE type_file.chr1
  DEFINE j       LIKE type_file.num5
  CALL i011_c1()
  LET l_sql =" SELECT skv03,skv13,ima02,skv04,skv06,' ',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,skv07,skv08,skv09,skv10,skv11 ",
	     "   FROM skv_file,OUTER ima_file ",
	     "  WHERE skv01 = '",g_sku.sku01,"'",
	     "    AND skv02 = '",g_sku.sku02,"'",
	     "    AND skv_file.skv13 = ima_file.ima01 ",
	     " GROUP BY skv03,skv13,ima02,skv04,skv06,skv07,skv08,skv09,skv10,skv11 ",
	     "  ORDER BY skv03"
 
     PREPARE i100f_tmp5 FROM l_sql
     DECLARE tmp3_cur5 CURSOR FOR i100f_tmp5
   
     CALL g_skv.clear()
     LET g_cnt = 1
     LET g_rec_b = 0
     FOREACH tmp3_cur5 INTO g_skv[g_cnt].*
        IF STATUS THEN 
           CALL cl_err('foreach skv:',STATUS,0)   
           EXIT FOREACH                         
        END IF
 
        SELECT agd03 INTO g_skv[g_cnt].agd03_3 FROM agd_file
          WHERE agd02=g_skv[g_cnt].skv06
            AND agd01=g_sla.sla03 #TQC-940111    
	FOR j = 1 TO g_j1
	   CASE 
	       WHEN j = 1 
	         SELECT skv12 INTO  g_skv[g_cnt].ss01
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss01
	       WHEN j = 2   
	         SELECT skv12 INTO  g_skv[g_cnt].ss02
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss02
	       WHEN j = 3   
	         SELECT skv12 INTO  g_skv[g_cnt].ss03
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss03
	       WHEN j = 4   
	         SELECT skv12 INTO  g_skv[g_cnt].ss04
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss04
	       WHEN j = 5   
	         SELECT skv12 INTO  g_skv[g_cnt].ss05
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss05
	       WHEN j = 6   
	         SELECT skv12 INTO  g_skv[g_cnt].ss06
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss06
	       WHEN j = 7   
	         SELECT skv12 INTO  g_skv[g_cnt].ss07
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss07
	       WHEN j = 8   
	         SELECT skv12 INTO  g_skv[g_cnt].ss08
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss08
	       WHEN j = 9   
	         SELECT skv12 INTO  g_skv[g_cnt].ss09
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss09
	       WHEN j = 10   
	         SELECT skv12 INTO  g_skv[g_cnt].ss10
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss10
	       WHEN j = 11   
	         SELECT skv12 INTO  g_skv[g_cnt].ss11
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss11
	       WHEN j = 12   
	         SELECT skv12 INTO  g_skv[g_cnt].ss12
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss12
	       WHEN j = 13   
	         SELECT skv12 INTO  g_skv[g_cnt].ss13
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss13
	       WHEN j = 14   
	         SELECT skv12 INTO  g_skv[g_cnt].ss14
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss14
	       WHEN j = 15  
	         SELECT skv12 INTO  g_skv[g_cnt].ss15
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss15
	       WHEN j = 16   
	         SELECT skv12 INTO  g_skv[g_cnt].ss16
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss16
	       WHEN j = 17  
	         SELECT skv12 INTO  g_skv[g_cnt].ss17
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss17
	       WHEN j = 18  
	         SELECT skv12 INTO  g_skv[g_cnt].ss18
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss18
	       WHEN j = 19   
	         SELECT skv12 INTO  g_skv[g_cnt].ss19
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss19
	       WHEN j = 20   
	         SELECT skv12 INTO  g_skv[g_cnt].ss20
		   FROM skv_file
	          WHERE skv01 = g_sku.sku01 
		    AND skv02 = g_sku.sku02		    
		    AND skv03 = g_skv[g_cnt].skv03		    
		    AND skv05 = g_value[j].valuen
		    LET g_value[j].value[g_cnt] = g_skv[g_cnt].ss20
 
	   END CASE
	END FOR
 
        LET g_cnt =  g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
     END FOREACH
 
     CALL g_skv.deleteElement(g_cnt)
     LET g_rec_b = g_cnt - 1
     DISPLAY g_rec_b TO FORMONLY.cn2
     DISPLAY ARRAY g_skv TO s_skv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
     END DISPLAY
 
     LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i011_y()
    DEFINE l_cnt  LIKE type_file.num5
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM skw_file
    WHERE skw01=g_sku.sku01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
     
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM skv_file
    WHERE skv01=g_sku.sku01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
  IF g_sku.skuconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
  
  BEGIN WORK
   OPEN i011_cl USING g_sku.sku01,g_sku.sku02
   IF STATUS THEN
      CALL cl_err("OPEN i011_cl:", STATUS, 1)
      CLOSE i011_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i011_cl INTO g_sku.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
     CLOSE i011_cl
     ROLLBACK WORK
     RETURN
   END IF
   
   UPDATE sku_file SET skuconf = 'Y' WHERE sku01 = g_sku.sku01 AND sku02 = g_sku.sku02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   ELSE
      LET g_success = 'Y'
   END IF
   
   IF g_success = 'Y' THEN
      LET g_sku.skuconf = 'Y'
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      LET g_sku.skuconf = 'N'
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   DISPLAY BY NAME g_sku.skuconf
   CALL i011_show()
   
END FUNCTION
 
FUNCTION i011_z()
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
  IF g_sku.skuconf = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
  BEGIN WORK
   OPEN i011_cl USING g_sku.sku01,g_sku.sku02
   IF STATUS THEN
      CALL cl_err("OPEN i011_cl:", STATUS, 1)
      CLOSE i011_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i011_cl INTO g_sku.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_sku.sku01,SQLCA.sqlcode,0)
     CLOSE i011_cl
     ROLLBACK WORK
     RETURN
   END IF
 
   UPDATE sku_file SET skuconf = 'N' WHERE sku01 = g_sku.sku01 AND sku02 = g_sku.sku02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   ELSE
     LET g_success = 'Y'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_sku.skuconf = 'N'
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      LET g_sku.skuconf = 'Y'
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   DISPLAY BY NAME g_sku.skuconf
   CALL i011_show()
END FUNCTION
 
FUNCTION i011_p()
  DEFINE i      LIKE type_file.num5
  DEFINE l_sql  STRING
  DEFINE l_skw   RECORD      LIKE skw_file.*,
         l_skw_t RECORD      LIKE skw_file.*
 
  INITIALIZE l_skw.* TO NULL
  INITIALIZE l_skw_t.* TO NULL
 
  LET l_sql="SELECT ' ',' ',' ', oeaslk01,oeb04[19,21],oeb04[15,17],sum(oeb12),oeb04[10,13],' ' ",
            "   FROM oeb_file,oea_file,OUTER sfb_file,sfc_file,oebi_file,sfci_file ",
            "  WHERE oeb01=oea01 AND oeaconf='Y' ",
            "    AND oeb01 = oebi01 AND oebi03 = oeb03 ",             
            "    AND sfc01='",g_sku.sku01,"'",
            "    AND sfc01 = sfci01 ",
            "    AND oebislk01=sfcislk01 ",
            "    AND oeb04[1,8]='",g_sku.sku02,"'",
            "    AND oeb_file.oeb01=sfb_file.sfb22 AND oeb_file.oeb03=sfb_file.sfb221 ",
            " GROUP BY oeaslk01,oeb04[19,21],oeb04[15,17],oeb04[10,13] ", 
            " ORDER BY oeaslk01,oeb04[19,21],oeb04[10,13] "
 
     PREPARE i100f_p FROM l_sql
     DECLARE p_cur CURSOR FOR i100f_p
     LET i=0
     LET l_skw_t.skw04 = ' '
     LET l_skw_t.skw05 = ' '
     LET l_skw_t.skw08 = ' '
     FOREACH p_cur INTO l_skw.*
       IF STATUS THEN
         CALL cl_err('foreach ta_oea007',STATUS,0)
         EXIT FOREACH
       END IF
       LET l_skw.skw01=g_sku.sku01
       LET l_skw.skw02=g_sku.sku02
       IF  l_skw.skw04 != l_skw_t.skw04 THEN
           LET i=i+1
       ELSE
          IF l_skw.skw05 != l_skw_t.skw05 THEN
             LET i=i+1
          ELSE
             IF l_skw.skw08 != l_skw_t.skw08 THEN
                LET i=i+1
             END IF
          END IF
       END IF
       LET l_skw.skw03=i
       LET l_skw.skwplant = g_plant #FUN-980008 add
       LET l_skw.skwlegal = g_legal #FUN-980008 add
       INSERT INTO skw_file VALUES (l_skw.*)
       LET l_skw_t.*=l_skw.*
     END FOREACH
     CALL i011_d_fill('1=1')
END FUNCTION
 
FUNCTION skx_fetch()
  DEFINE i        LIKE type_file.num5
  DEFINE l_sql    STRING
 
  LET l_sql = " SELECT skx03,skx07,ima02,skx04,skx05,skx06 ",
              "  FROM skx_file,OUTER ima_file ",
              " WHERE ima_file.ima01 = skx_file.skx07 ",
              "   AND skx01 = '",g_sku.sku01,"'",
              "   AND skx02 = '",g_sku.sku02,"'",
              " ORDER by skx03 "
 
  PREPARE skx_pre FROM l_sql
   DECLARE skx_c CURSOR FOR skx_pre
   CALL l_skx.clear()
 
   LET g_cnt = 1
   FOREACH skx_c INTO l_skx[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach skx',STATUS,0) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL l_skx.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
   LET i = 1
END FUNCTION 
 
FUNCTION i011_d_title()
DEFINE 
    l_i             LIKE type_file.num5,
    l_j             LIKE type_file.num5,
    l_msg           LIKE type_file.chr1000,
    l_mag           LIKE type_file.chr1000,
    l_chr           LIKE type_file.chr3,
    l_sla02         LIKE sla_file.sla02,
    l_sla03         LIKE sla_file.sla03
    
     CALL cl_set_comp_visible("skw05,agd03,skw08,agd03_2",FALSE)
     
    SELECT sla02,sla03 INTO l_sla02,l_sla03 FROM sla_file
 
     IF NOT cl_null(l_sla02) THEN 
    	 SELECT agc02 INTO l_mag FROM agc_file WHERE agc01 = l_sla02
         CALL cl_set_comp_att_text("skw05",l_mag CLIPPED)   
         CALL cl_set_comp_visible("skw05,agd03",TRUE) 
    END IF           
   
    IF NOT cl_null(l_sla03) THEN 
    	 SELECT agc02 INTO l_mag FROM agc_file WHERE agc01 = l_sla03
         CALL cl_set_comp_att_text("skw08",l_mag CLIPPED)   
         CALL cl_set_comp_visible("skw08,agd03_2",TRUE) 
    END IF           
 
END FUNCTION    
 
#No.FUN-9C0072 精簡程式碼
