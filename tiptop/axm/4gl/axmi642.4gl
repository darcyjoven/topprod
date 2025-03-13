# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi642.4gl
# Descriptions...: 佣金料件資料維護作業
# Date & Author..: 02/11/22 By Maggie
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710115 07/03/28 By Judy 比率，基准無控管，可錄入負值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No:TQC-960212 10/11/09 By sabrina AFTER FIELD ofv02 時 判斷應該以ofv02為主 不應該是ofv01 (g_ofv.ofv01 != g_ofv_t.ofv01)
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80246 11/09/05 By Carrier CONSTRUCT时加入oriu/orig

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofv        RECORD LIKE ofv_file.*,
    g_ofv_t      RECORD LIKE ofv_file.*,
    g_ofv_o      RECORD LIKE ofv_file.*,
    g_ofv01_t           LIKE ofv_file.ofv01,
    g_ofv02_t           LIKE ofv_file.ofv02,
    g_argv1             LIKE ofv_file.ofv01,
     g_wc,g_sql         STRING, #No.FUN-580092 HCN 
    l_cmd               LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd            LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE g_buf            LIKE ima_file.ima01     #No.FUN-680137 VARCHAR(40)
 
DEFINE   g_forupd_sql STRING #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done    STRING
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)
    INITIALIZE g_ofv.* TO NULL
    INITIALIZE g_ofv_t.* TO NULL
    INITIALIZE g_ofv_o.* TO NULL
 
 
    LET g_forupd_sql = "SELECT * FROM ofv_file WHERE ofv01 =? AND ofv02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i642_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 4 LET p_col = 10
 
    OPEN WINDOW i642_w AT p_row,p_col
        WITH FORM "axm/42f/axmi642"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i642_q()
    END IF
 
    LET g_action_choice=""
    CALL i642_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i642_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i642_cs()
    LET g_wc = ""
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "ofv01 ='",g_argv1,"'"
    ELSE
       CLEAR FORM
   INITIALIZE g_ofv.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                      # 螢幕上取條件
           ofv01,ofv02,ofv03,ofv04,
           ofv05,ofv06,ofv07,ofv08,ofv09,
           ofv10,ofv11,ofv12,ofv13,ofv14,
           ofvuser,ofvgrup,ofvoriu,ofvorig,ofvmodu, ofvdate  #No.TQC-B80246
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ofs"
                 LET g_qryparam.default1 = g_ofv.ofv01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofv01
                 NEXT FIELD ofv01
              WHEN INFIELD(ofv02)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_ofv.ofv02
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_ofv.ofv02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ofv02
                 NEXT FIELD ofv02
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ofvuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ofvgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofvgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofvuser', 'ofvgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ofv01,ofv02 FROM ofv_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ofv01,ofv02"
    PREPARE i642_prepare FROM g_sql          # RUNTIME 編譯
    DECLARE i642_cs                        # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i642_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofv_file WHERE ",g_wc CLIPPED
    PREPARE i642_precount FROM g_sql
    DECLARE i642_count CURSOR FOR i642_precount
END FUNCTION
 
FUNCTION i642_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i642_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i642_q()
            END IF
            NEXT OPTION "next"
 
        ON ACTION next
           CALL i642_fetch('N')
 
        ON ACTION previous
           CALL i642_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i642_u()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i642_r()
            END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
            LET g_action_choice = "exit"
          EXIT MENU
 
        ON ACTION jump
           CALL i642_fetch('/')
 
        ON ACTION first
           CALL i642_fetch('F')
 
        ON ACTION last
            CALL i642_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ofv.ofv01 IS NOT NULL THEN
                  LET g_doc.column1 = "ofv01"
                  LET g_doc.column2 = "ofv02"
                  LET g_doc.value1 = g_ofv.ofv01
                  LET g_doc.value2 = g_ofv.ofv02
              CALL cl_doc()                            
               END IF                                        
            END IF                                           
         #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i642_cs
END FUNCTION
 
 
 
FUNCTION i642_a()
    DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137  VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofv.* LIKE ofv_file.*
    LET g_ofv01_t = NULL
    LET g_ofv02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ofv.ofv03 = '1'
        LET g_ofv.ofv04 = 0
        LET g_ofv.ofv05 = 0
        LET g_ofv.ofv06 = 0
        LET g_ofv.ofv07 = 0
        LET g_ofv.ofv08 = 0
        LET g_ofv.ofv09 = 0
        LET g_ofv.ofv10 = 0
        LET g_ofv.ofv11 = 0
        LET g_ofv.ofv12 = 0
        LET g_ofv.ofv13 = 0
        LET g_ofv.ofv14 = 0
        LET g_ofv.ofvuser = g_user
        LET g_ofv.ofvoriu = g_user #FUN-980030
        LET g_ofv.ofvorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ofv.ofvgrup = g_grup
        LET g_ofv.ofvdate = g_today
        #FUN-980010 add plant & legal 
        LET g_ofv.ofvplant = g_plant 
        LET g_ofv.ofvlegal = g_legal 
        #FUN-980010 end plant & legal 
        LET g_ofv_t.*=g_ofv.*
        CALL i642_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofv.ofv01 IS NULL THEN               # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ofv_file VALUES(g_ofv.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ofv_file",g_ofv.ofv01,g_ofv.ofv02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
           SELECT ofv01,ofv02 INTO g_ofv.ofv01,g_ofv.ofv02 FROM ofv_file
            WHERE ofv01 = g_ofv.ofv01
              AND ofv02 = g_ofv.ofv02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i642_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_ofs02         LIKE ofs_file.ofs02,
        l_ima02         LIKE ima_file.ima02,
        l_ima021        LIKE ima_file.ima021
 
   INPUT BY NAME g_ofv.ofvoriu,g_ofv.ofvorig,
        g_ofv.ofv01,g_ofv.ofv02,g_ofv.ofv03,g_ofv.ofv04,
        g_ofv.ofv05,g_ofv.ofv06,g_ofv.ofv07,g_ofv.ofv08,g_ofv.ofv09,
        g_ofv.ofv10,g_ofv.ofv11,g_ofv.ofv12,g_ofv.ofv13,g_ofv.ofv14,
        g_ofv.ofvuser,g_ofv.ofvgrup,g_ofv.ofvmodu, g_ofv.ofvdate
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i642_set_entry(p_cmd)
           CALL i642_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD ofv01
            IF NOT cl_null(g_argv1) THEN
               LET g_ofv.ofv01 = g_argv1
               DISPLAY BY NAME g_ofv.ofv01
               SELECT ofs02 INTO l_ofs02 FROM ofs_file
                WHERE ofs01 = g_ofv.ofv01
               DISPLAY l_ofs02 TO FORMONLY.ofs02
               NEXT FIELD ofv02
            END IF
 
        AFTER FIELD ofv01
          IF g_ofv.ofv01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofv.ofv01 != g_ofv_t.ofv01) THEN
               SELECT ofs02 INTO l_ofs02 FROM ofs_file
                WHERE ofs01 = g_ofv.ofv01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ofv.ofv01,'axm-641',0)    #無此佣金代號   #No.FUN-660167
                  CALL cl_err3("sel","ofs_file",g_ofv.ofv01,"","axm-641","","",1)  #No.FUN-660167
                  NEXT FIELD ofv01
               END IF
               DISPLAY l_ofs02 TO FORMONLY.ofs02
            END IF
          END IF
 
        AFTER FIELD ofv02
        IF g_ofv.ofv02 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_ofv.ofv02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_ofv.ofv02= g_ofv_t.ofv02
               NEXT FIELD ofv02
            END IF
#FUN-AA0059 ---------------------end-------------------------------

          IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
           #(p_cmd = "u" AND g_ofv.ofv01 != g_ofv_t.ofv01) THEN    #TQC-960212 mark 
            (p_cmd = "u" AND g_ofv.ofv02 != g_ofv_t.ofv02) THEN    #TQC-960212 add 
             SELECT ima02,ima021 INTO l_ima02,l_ima021
               FROM ima_file WHERE ima01 = g_ofv.ofv02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ofv.ofv02,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("sel","ima_file",g_ofv.ofv02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                NEXT FIELD ofv02
             END IF
             DISPLAY l_ima02 TO FORMONLY.ima02
             DISPLAY l_ima021 TO FORMONLY.ima021
 
             SELECT COUNT(*) INTO l_n FROM ofv_file
              WHERE ofv01 = g_ofv.ofv01 AND ofv02 = g_ofv.ofv02
             IF l_n > 0 THEN                  # Duplicated
                CALL cl_err(g_ofv.ofv01,-239,0)
                LET g_ofv.ofv01 = g_ofv_t.ofv01
                DISPLAY BY NAME g_ofv.ofv01
                NEXT FIELD ofv01
             END IF
          END IF
        END IF
 
        AFTER FIELD ofv03
	  IF g_ofv.ofv03 NOT MATCHES '[1234]' THEN
             NEXT FIELD ofv03
          END IF
#TQC-710115.....begin                                                           
        AFTER FIELD ofv04                                                       
          IF g_ofv.ofv04 < 0 OR g_ofv.ofv04 > 100 THEN   
             CALL cl_err(g_ofv.ofv04,'axm-986',0)                               
             NEXT FIELD ofv04                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv05                                                       
          IF g_ofv.ofv05 < 0 THEN   
             CALL cl_err(g_ofv.ofv05,'mfg5034',0)                               
             NEXT FIELD ofv05                                                   
          END IF
                                                                                
        AFTER FIELD ofv06                                                       
          IF g_ofv.ofv06 < 0 OR g_ofv.ofv06 > 100 THEN   
             CALL cl_err(g_ofv.ofv06,'axm-986',0)                               
             NEXT FIELD ofv06                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv07                                                       
          IF g_ofv.ofv07 < 0 THEN   
             CALL cl_err(g_ofv.ofv07,'mfg5034',0)                               
             NEXT FIELD ofv07                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv08                                                       
          IF g_ofv.ofv08 < 0 OR g_ofv.ofv08 > 100 THEN   
             CALL cl_err(g_ofv.ofv08,'axm-986',0)                               
             NEXT FIELD ofv08                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv09
          IF g_ofv.ofv09 < 0 THEN   
             CALL cl_err(g_ofv.ofv09,'mfg5034',0)                               
             NEXT FIELD ofv09                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv10                                                       
          IF g_ofv.ofv10 < 0 OR g_ofv.ofv10 > 100 THEN   
             CALL cl_err(g_ofv.ofv10,'axm-986',0)                               
             NEXT FIELD ofv10                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv11                                                       
          IF g_ofv.ofv11 < 0 THEN   
             CALL cl_err(g_ofv.ofv11,'mfg5034',0)                               
             NEXT FIELD ofv11                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv12                                                       
          IF g_ofv.ofv12 < 0 OR g_ofv.ofv12 > 100 THEN   
             CALL cl_err(g_ofv.ofv12,'axm-986',0)                               
             NEXT FIELD ofv12                                                   
          END IF
                                                                                
        AFTER FIELD ofv13                                                       
          IF g_ofv.ofv13 < 0 THEN   
             CALL cl_err(g_ofv.ofv13,'mfg5034',0)                               
             NEXT FIELD ofv13                                                   
          END IF                                                                
                                                                                
        AFTER FIELD ofv14                                                       
          IF g_ofv.ofv14 < 0 OR g_ofv.ofv14 > 100 THEN   
             CALL cl_err(g_ofv.ofv14,'axm-986',0)                               
             NEXT FIELD ofv14                                                   
          END IF                                                                
#TQC-710115.....end
 
        AFTER INPUT
           LET g_ofv.ofvuser = s_get_data_owner("ofv_file") #FUN-C10039
           LET g_ofv.ofvgrup = s_get_data_group("ofv_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ofv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ofs"
                 LET g_qryparam.default1 = g_ofv.ofv01
                 CALL cl_create_qry() RETURNING g_ofv.ofv01
#                 CALL FGL_DIALOG_SETBUFFER( g_ofv.ofv01 )
                 DISPLAY BY NAME g_ofv.ofv01
                 NEXT FIELD ofv01
              WHEN INFIELD(ofv02)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_ofv.ofv02
#                 CALL cl_create_qry() RETURNING g_ofv.ofv02
                CALL q_sel_ima(FALSE, "q_ima","",g_ofv.ofv02,"","","","","",'' ) 
                  RETURNING  g_ofv.ofv02

#FUN-AA0059---------mod------------end-----------------
#                 CALL FGL_DIALOG_SETBUFFER( g_ofv.ofv02 )
                 DISPLAY BY NAME g_ofv.ofv02
                 NEXT FIELD ofv02
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
# END IF
END FUNCTION
 
FUNCTION i642_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ofv.* TO NULL              #No.FUN-6A0020
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i642_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i642_count
    FETCH i642_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i642_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)
        INITIALIZE g_ofv.* TO NULL
    ELSE
        CALL i642_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i642_fetch(p_flofv)
    DEFINE
        p_flofv      LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1) 
 
    CASE p_flofv
        WHEN 'N' FETCH NEXT     i642_cs INTO g_ofv.ofv01,g_ofv.ofv02
        WHEN 'P' FETCH PREVIOUS i642_cs INTO g_ofv.ofv01,g_ofv.ofv02
        WHEN 'F' FETCH FIRST    i642_cs INTO g_ofv.ofv01,g_ofv.ofv02
        WHEN 'L' FETCH LAST     i642_cs INTO g_ofv.ofv01,g_ofv.ofv02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i642_cs
                  INTO g_ofv.ofv01,g_ofv.ofv02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)
        INITIALIZE g_ofv.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flofv
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofv.* FROM ofv_file             # 重讀DB,因TEMP有不被更新特性
       WHERE ofv01 = g_ofv.ofv01 AND ofv02=g_ofv.ofv02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofv_file",g_ofv.ofv01,g_ofv.ofv02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofv.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofv.ofvuser      #FUN-4C0057
       LET g_data_group = g_ofv.ofvgrup      #FUN-4C0057
       LET g_data_plant = g_ofv.ofvplant #FUN-980030
       CALL i642_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i642_show()
    DEFINE l_ofs02         LIKE ofs_file.ofs02,
           l_ima02         LIKE ima_file.ima02,
           l_ima021        LIKE ima_file.ima021
 
    LET g_ofv_t.* = g_ofv.*
    DISPLAY BY NAME g_ofv.ofvoriu,g_ofv.ofvorig,
        g_ofv.ofv01,g_ofv.ofv02,g_ofv.ofv03,g_ofv.ofv04,g_ofv.ofv05,
        g_ofv.ofv06,g_ofv.ofv07,g_ofv.ofv08,g_ofv.ofv09,g_ofv.ofv10,
        g_ofv.ofv11,g_ofv.ofv12,g_ofv.ofv13,g_ofv.ofv14,
        g_ofv.ofvuser,g_ofv.ofvgrup,g_ofv.ofvmodu,g_ofv.ofvdate
    SELECT ofs02 INTO l_ofs02 FROM ofs_file WHERE ofs01 = g_ofv.ofv01
    DISPLAY l_ofs02 TO FORMONLY.ofs02
    SELECT ima02,ima021 INTO l_ima02,l_ima021
      FROM ima_file WHERE ima01 = g_ofv.ofv02
    DISPLAY l_ima02  TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i642_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ofv.ofv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ofv.* FROM ofv_file
     WHERE ofv01=g_ofv.ofv01 AND ofv02=g_ofv.ofv02
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofv01_t = g_ofv.ofv01
    LET g_ofv02_t = g_ofv.ofv02
    LET g_ofv_o.*=g_ofv.*
    BEGIN WORK
 
    OPEN i642_cl USING g_ofv.ofv01,g_ofv.ofv02
    IF STATUS THEN
       CALL cl_err("OPEN i642_cl:", STATUS, 1)
       CLOSE i642_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i642_cl INTO g_ofv.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofv.ofvmodu=g_user                     #修改者
    LET g_ofv.ofvdate = g_today                  #修改日期
    CALL i642_show()                             # 顯示最新資料
    WHILE TRUE
        LET g_ofv_t.*=g_ofv.*
        CALL i642_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofv.*=g_ofv_t.*
            CALL i642_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofv_file SET ofv_file.* = g_ofv.*    # 更新DB
            WHERE ofv01 = g_ofv_t.ofv01 AND ofv02=g_ofv_t.ofv02               # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofv_file",g_ofv01_t,g_ofv02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i642_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i642_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofv.ofv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i642_cl USING g_ofv.ofv01,g_ofv.ofv02
    IF STATUS THEN
       CALL cl_err("OPEN i642_cl:", STATUS, 1)
       CLOSE i642_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i642_cl INTO g_ofv.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i642_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ofv02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofv.ofv01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ofv.ofv02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofv_file WHERE ofv01 = g_ofv.ofv01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofv.ofv01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofv_file",g_ofv.ofv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       INITIALIZE g_ofv.* TO NULL
       OPEN i642_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i642_cs
          CLOSE i642_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 

       FETCH i642_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i642_cs
          CLOSE i642_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i642_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i642_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i642_fetch('/')
       END IF
    END IF
    CLOSE i642_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i642_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofv01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i642_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofv01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

