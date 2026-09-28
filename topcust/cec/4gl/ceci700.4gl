IMPORT os
DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

DEFINE
  g_tc_ecm00           LIKE tc_ecm_file.tc_ecm00,
  g_tc_ecm00_t         LIKE tc_ecm_file.tc_ecm00,  
  g_tc_ecm01           LIKE tc_ecm_file.tc_ecm01,  
  g_tc_ecm01_t         LIKE tc_ecm_file.tc_ecm01,  
  g_tc_ecm02           LIKE tc_ecm_file.tc_ecm02, 
  g_tc_ecm02_t         LIKE tc_ecm_file.tc_ecm02, 
  g_tc_ecmacti         LIKE tc_ecm_file.tc_ecmacti, #資料有效碼
  --g_tc_ecmuser         LIKE tc_ecm_file.tc_ecmuser, #資料所有者
  --g_tc_ecmgrup         LIKE tc_ecm_file.tc_ecmgrup, #資料所有部門
  --g_tc_ecmmodu         LIKE tc_ecm_file.tc_ecmmodu, #資料修改者
  --g_tc_ecmdate         LIKE tc_ecm_file.tc_ecmdate, #最后修改日期
  l_cnt                LIKE type_file.num5,          #No.FUN-680136 SMALLINT
  g_tc_ecm             DYNAMIC ARRAY OF RECORD   #單身數組
           tc_ecm09    LIKE tc_ecm_file.tc_ecm09,
           tc_ecm03    LIKE tc_ecm_file.tc_ecm03,
           tc_ecm04    LIKE tc_ecm_file.tc_ecm04,
           tc_ecm05    LIKE tc_ecm_file.tc_ecm05,
           tc_ecm06    LIKE tc_ecm_file.tc_ecm06,
           tc_ecm07    LIKE tc_ecm_file.tc_ecm07,
           tc_ecm08    LIKE tc_ecm_file.tc_ecm08,
           tc_ecmacti  LIKE tc_ecm_file.tc_ecmacti
                    END RECORD,
  g_tc_ecm_t           RECORD   #單身數組舊值
           tc_ecm09    LIKE tc_ecm_file.tc_ecm09,
           tc_ecm03    LIKE tc_ecm_file.tc_ecm03,
           tc_ecm04    LIKE tc_ecm_file.tc_ecm04,
           tc_ecm05    LIKE tc_ecm_file.tc_ecm05,
           tc_ecm06    LIKE tc_ecm_file.tc_ecm06,
           tc_ecm07    LIKE tc_ecm_file.tc_ecm07,
           tc_ecm08    LIKE tc_ecm_file.tc_ecm08,
           tc_ecmacti  LIKE tc_ecm_file.tc_ecmacti
                    END RECORD,
  g_wc,g_wc2,g_sql  STRING,
  g_delete          LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
  g_rec_b           LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
  l_ac              LIKE type_file.num5           #No.FUN-680136 SMALLINT
DEFINE g_argv1      LIKE tc_ecm_file.tc_ecm00
DEFINE g_argv2      LIKE tc_ecm_file.tc_ecm01
DEFINE g_argv3      LIKE tc_ecm_file.tc_ecm02
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680136  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-680136 INTEGER                                                  #No.FUN-680136
DEFINE g_no_ask           LIKE type_file.num5          #No.FUN-680136 INTEGER   #No.FUN-6A0067

MAIN
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理  
 
    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ECN")) THEN #MOD-990167 AXM-->APM     
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    INITIALIZE g_tc_ecm TO NULL                                                
    INITIALIZE g_tc_ecm_t.* TO NULL                                                
 
    LET g_forupd_sql = "SELECT * FROM tc_ecm_file WHERE tc_ecm00 = ? AND tc_ecm01 = ? AND tc_ecm02 = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_crl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      
 
    OPEN WINDOW i700_w WITH FORM "cec/42f/ceci700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
   
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i700_q()
    END IF
 
    #CALL g_x.clear()
    #LET g_delete='N'
    #################
    LET g_action_choice=""
    #################
    CALL i700_menu()   
    CLOSE WINDOW i700_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i700_cs()
    CLEAR FORM
    CALL g_tc_ecm.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032

 IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
   LET g_sql =" SELECT tc_ecm00,tc_ecm01,tc_ecm02",
              " FROM tc_ecm_file",
              " WHERE  tc_ecm00 = '",g_argv1,"'  AND tc_ecm01 = '",g_argv2,"'",
              " GROUP BY tc_ecm00,tc_ecm01,tc_ecm02 ", 
              " ORDER BY tc_ecm01,tc_ecm02"
ELSE 

   INITIALIZE g_tc_ecm00 TO NULL    #No.FUN-750051
   INITIALIZE g_tc_ecm01 TO NULL
   INITIALIZE g_tc_ecm02 TO NULL 
    CONSTRUCT g_wc ON tc_ecm00,tc_ecm01,tc_ecm02,tc_ecm09,tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,tc_ecm07,tc_ecm08,tc_ecmacti
                 FROM tc_ecm00,tc_ecm01,tc_ecm02,s_tc_ecm[1].tc_ecm09,s_tc_ecm[1].tc_ecm03,s_tc_ecm[1].tc_ecm04,s_tc_ecm[1].tc_ecm05,
                      s_tc_ecm[1].tc_ecm06,s_tc_ecm[1].tc_ecm07,s_tc_ecm[1].tc_ecm08,s_tc_ecm[1].tc_ecmacti
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(tc_ecm00)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_tc_ecm00"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_ecm00
              NEXT FIELD tc_ecm00        
           WHEN INFIELD(tc_ecm01)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_tc_ecm01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_ecm01
              NEXT FIELD tc_ecm01        
           WHEN INFIELD(tc_ecm02)
              CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_ecm02
              NEXT FIELD tc_ecm02
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('g_user', 'g_grup') #FUN-980030 huanglf
  
    IF INT_FLAG THEN RETURN END IF
  
    LET g_sql=" SELECT DISTINCT tc_ecm00,tc_ecm01,tc_ecm02 FROM tc_ecm_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY tc_ecm00,tc_ecm01,tc_ecm02 "
END IF 
    PREPARE i700_prepare FROM g_sql
    DECLARE i700_bcs SCROLL CURSOR WITH HOLD FOR i700_prepare
 IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN 
  #  LET g_sql=" SELECT COUNT(*)",
   #           " FROM tc_ecm_file WHERE tc_ecm00 = '",g_argv1,"'  AND tc_ecm01 = '",g_argv2,"'"

      LET g_sql=" SELECT COUNT(*)",
                " FROM ( SELECT tc_ecm00 FROM tc_ecm_file WHERE tc_ecm00 = '",g_argv1,"'  AND tc_ecm01 = '",g_argv2,"'",
                "  GROUP BY tc_ecm00,tc_ecm01,tc_ecm02)"
 ELSE 
    LET g_sql=" SELECT COUNT(*) ",
              "   FROM tc_ecm_file WHERE ",g_wc CLIPPED
 END IF              
    PREPARE i700_precount FROM g_sql
    DECLARE i700_count CURSOR FOR i700_precount
  
END FUNCTION

FUNCTION i700_menu()
    WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         --WHEN "insert" 
            --IF cl_chk_act_auth() THEN
               --CALL i700_a()
            --END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i700_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         --WHEN "delete" 
            --IF cl_chk_act_auth() THEN
               --CALL i700_r()
            --END IF
         --WHEN "reproduce"
            --IF cl_chk_act_auth() THEN
               --CALL i700_copy()
            --END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_tc_ecm),'','')
            END IF 
         #No.FUN-6A0162-------add--------str----
         --WHEN "related_document"  #相關文件
              --IF cl_chk_act_auth() THEN
                 --IF g_tc_ecm01 IS NOT NULL THEN
                 --LET g_doc.column1 = "tc_ecm01"
                 --LET g_doc.value1 = g_tc_ecm01
                 --CALL cl_doc()
               --END IF
         --END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
    END WHILE
END FUNCTION

--FUNCTION i700_a() 
    --IF s_shut(0) THEN RETURN END IF 
    --MESSAGE ""
    --CLEAR FORM
    --CALL g_tc_ecm.clear()
    --INITIALIZE g_tc_ecm00 LIKE tc_ecm_file.tc_ecm00
    --INITIALIZE g_tc_ecm01 LIKE tc_ecm_file.tc_ecm01
    --INITIALIZE g_tc_ecm02 LIKE tc_ecm_file.tc_ecm02
    --LET g_tc_ecm01_t = NULL
--
    --CALL cl_opmsg('a')
    --WHILE TRUE
        --CALL i700_i("a")     #輸入單頭
        --IF INT_FLAG THEN     #使用者不玩了 
           --LET g_tc_ecm01 = NULL
           --CLEAR FORM
           --LET INT_FLAG = 0
           --CALL cl_err('',9001,0)
           --EXIT WHILE
        --END IF
        --LET g_rec_b=0
        --CALL i700_b()                    
        --LET g_tc_ecm01_t = g_tc_ecm01         
        --EXIT WHILE
    --END WHILE        
--END FUNCTION 

FUNCTION i700_u()
    IF g_tc_ecm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_tc_ecm00_t = g_tc_ecm00
    LET g_tc_ecm01_t = g_tc_ecm01
    LET g_tc_ecm02_t = g_tc_ecm02
    WHILE TRUE
        CALL i700_i("u")                      #
        IF INT_FLAG THEN
            LET g_tc_ecm00=g_tc_ecm00_t
            DISPLAY g_tc_ecm00 TO tc_ecm00
            LET g_tc_ecm01=g_tc_ecm01_t
            DISPLAY g_tc_ecm01 TO tc_ecm01          #ATTRIBUTE(YELLOW) #蟲 Y
            LET g_tc_ecm02=g_tc_ecm02_t
            DISPLAY g_tc_ecm02 TO tc_ecm02
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tc_ecm00 != g_tc_ecm00_t OR g_tc_ecm01 != g_tc_ecm01_t OR g_tc_ecm02 != g_tc_ecm02_t THEN #欄位更改         
            UPDATE tc_ecm_file SET tc_ecm00  = g_tc_ecm00,
                                   tc_ecm01  = g_tc_ecm01,
                                   tc_ecm02  = g_tc_ecm02
                WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01 = g_tc_ecm01_t AND tc_ecm02 = g_tc_ecm02_t       
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_ecm_file",g_tc_ecm01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    #############
    #############
END FUNCTION 

FUNCTION i700_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
         l_n             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         l_gen02         LIKE gen_file.gen02,
         l_no            LIKE type_file.num5
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    INPUT g_tc_ecm00,g_tc_ecm01,g_tc_ecm02 WITHOUT DEFAULTS FROM tc_ecm00,tc_ecm01,tc_ecm02
 
        BEFORE INPUT
            LET g_before_input_done = FALSE 
            CALL i700_set_entry(p_cmd) 
            CALL i700_set_no_entry(p_cmd) 
            LET g_before_input_done = TRUE


        AFTER FIELD tc_ecm00
              IF g_tc_ecm00 IS NULL OR g_tc_ecm00=' ' THEN
               CALL cl_err("","apm-317",0)
            END IF
         IF g_tc_ecm00 IS NOT NULL AND (p_cmd='a' OR (g_tc_ecm01!=g_tc_ecm01_t)) THEN
               SELECT COUNT(*) INTO l_n FROM tc_ecm_file
                  WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
                  IF l_n >=1 THEN     #判断主键是否重复
                     CALL cl_err(g_tc_ecm00,"atm-310",0)
                     NEXT FIELD tc_ecm00
                  END IF
         END IF  
        AFTER FIELD tc_ecm01
            IF g_tc_ecm01 IS NULL OR g_tc_ecm01=' ' THEN
               CALL cl_err("","apm-317",0)
            END IF
         IF g_tc_ecm01 IS NOT NULL AND (p_cmd='a' OR (g_tc_ecm01!=g_tc_ecm01_t)) THEN
               SELECT COUNT(*) INTO l_n FROM tc_ecm_file
                  WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
                  IF l_n >=1 THEN     #判断主键是否重复
                     CALL cl_err(g_tc_ecm01,"atm-310",0)
                     NEXT FIELD tc_ecm01
                  END IF
         END IF  

        
        AFTER FIELD tc_ecm02
            IF g_tc_ecm02 IS NULL OR g_tc_ecm02=' ' THEN
               CALL cl_err("","apm-317",0)
            END IF
         IF g_tc_ecm02 IS NOT NULL AND (p_cmd='a' OR (g_tc_ecm02!=g_tc_ecm02_t)) THEN
               SELECT COUNT(*) INTO l_n FROM tc_ecm_file
                  WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
                  IF l_n >=1 THEN     #判断主键是否重复
                     CALL cl_err(g_tc_ecm02,"atm-310",0)
                     NEXT FIELD tc_ecm02
                  END IF
         END IF  

        

 
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(tc_ecm01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ima"
                   LET g_qryparam.default1 = g_tc_ecm01
                   CALL cl_create_qry() RETURNING g_tc_ecm01 
                   DISPLAY g_tc_ecm01 TO tc_ecm01
                   NEXT FIELD tc_ecm01

                
                WHEN INFIELD(tc_ecm02)
                 CALL q_ecd(FALSE,TRUE,g_tc_ecm02)
                 RETURNING g_tc_ecm02
                 DISPLAY g_tc_ecm02 TO tc_ecm02
                 NEXT FIELD tc_ecm02        
            END CASE
   
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
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END INPUT
END FUNCTION

FUNCTION i700_q()
  DEFINE l_tc_ecm01  LIKE tc_ecm_file.tc_ecm01,
         l_cnt    LIKE type_file.num10               #No.FUN-680136 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_ecm00 TO NULL 
    INITIALIZE g_tc_ecm01 TO NULL     #No.FUN-6A0162
    INITIALIZE g_tc_ecm02 TO NULL 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_ecm.clear()
 
    CALL i700_cs()                 #去得查詢條件 
    IF INT_FLAG THEN               #使用者不玩了  
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i700_bcs                  #從DB產生合乎條件的TEMP(0-30秒)  
    IF SQLCA.sqlcode THEN           
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecm01 TO NULL
    ELSE
        OPEN i700_count                                                     
        FETCH i700_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  

        CALL i700_fetch('F')        #讀取TEMP的第一筆并顯示  
    END IF
END FUNCTION

FUNCTION i700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1         #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i700_bcs INTO g_tc_ecm00,g_tc_ecm01,g_tc_ecm02
        WHEN 'P' FETCH PREVIOUS i700_bcs INTO g_tc_ecm00,g_tc_ecm01,g_tc_ecm02
        WHEN 'F' FETCH FIRST    i700_bcs INTO g_tc_ecm00,g_tc_ecm01,g_tc_ecm02
        WHEN 'L' FETCH LAST     i700_bcs INTO g_tc_ecm00,g_tc_ecm01,g_tc_ecm02
        WHEN '/' 
         IF (NOT g_no_ask) THEN   #No.FUN-6A0067
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
         FETCH ABSOLUTE g_jump i700_bcs INTO g_tc_ecm00,g_tc_ecm01,g_tc_ecm02
         LET g_no_ask = FALSE             #No.FUN-6A0067
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_tc_ecm01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecm01 TO NULL  #TQC-6B0105
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
    OPEN i700_count
    FETCH i700_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i700_show()
END FUNCTION

FUNCTION i700_show()
DEFINE l_gen02         LIKE gen_file.gen02

    --SELECT tc_ecm01,tc_ecm02
      --INTO g_tc_ecm01,g_tc_ecm02
      --FROM tc_ecm_file 
    --WHERE tc_ecm01=g_tc_ecm01  AND tc_ecm02 = g_tc_ecm02
    DISPLAY g_tc_ecm00 TO tc_ecm00
    DISPLAY g_tc_ecm01 TO tc_ecm01  #ATTRIBUTE(YELLOW)    #單頭
    DISPLAY g_tc_ecm02 TO tc_ecm02 

    CALL i700_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

--FUNCTION i700_r()
    --IF s_shut(0) THEN RETURN END IF                #檢查權限
    --IF g_tc_ecm01 IS NULL THEN 
       --CALL cl_err("",-400,0)                 #No.FUN-6A0162
       --RETURN
    --END IF
    --IF cl_delh(0,0) THEN                   #確認一下 
        --INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        --LET g_doc.column1 = "tc_ecm01"      #No.FUN-9B0098 10/02/24
        --LET g_doc.value1 = g_tc_ecm01       #No.FUN-9B0098 10/02/24
        --CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        --DELETE FROM tc_ecm_file WHERE tc_ecm01 = g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
        --IF SQLCA.sqlcode THEN
            --CALL cl_err3("del","tc_ecm_file",g_tc_ecm01,"",SQLCA.sqlcode,"",
                         --"BODY DELETE",1)  #No.FUN-660104
        --ELSE
            --CLEAR FORM
            --CALL g_tc_ecm.clear()
            --LET g_delete='Y'
            --LET g_tc_ecm01 = NULL
            --LET g_cnt=SQLCA.SQLERRD[3]
            --MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            --OPEN i700_count                                                     
            #FUN-B50063-add-start--
            --IF STATUS THEN
               --CLOSE i700_bcs
               --CLOSE i700_count
               --COMMIT WORK
               --RETURN
            --END IF
            #FUN-B50063-add-end-- 
            --FETCH i700_count INTO g_row_count                 
            #FUN-B50063-add-start--
            --IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               --CLOSE i700_bcs
               --CLOSE i700_count
               --COMMIT WORK
               --RETURN
            --END IF
            #FUN-B50063-add-end--
            --DISPLAY g_row_count TO FORMONLY.cnt               
            --OPEN i700_bcs                                      
            --IF g_curs_index = g_row_count + 1 THEN            
               --LET g_jump = g_row_count                       
               --CALL i700_fetch('L')                           
            --ELSE                                              
               --LET g_jump = g_curs_index                      
               --LET g_no_ask = TRUE         #No.FUN-6A0067                   
               --CALL i700_fetch('/')                           
            --END IF
        --END IF
    --END IF
--END FUNCTION

FUNCTION i700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用         #No.FUN-680136 SMALLINT
    l_ac_o          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_rows          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_success       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_tc_ecm09        LIKE tc_ecm_file.tc_ecm09,  
    l_tc_ecm03        LIKE tc_ecm_file.tc_ecm03,  
    l_tc_ecm04        LIKE tc_ecm_file.tc_ecm04,
    l_tc_ecm05        LIKE tc_ecm_file.tc_ecm05,   
    l_tc_ecm06        LIKE tc_ecm_file.tc_ecm06,   
    l_tc_ecm07        LIKE tc_ecm_file.tc_ecm07,  
    l_tc_ecm08        LIKE tc_ecm_file.tc_ecm08, 
    l_tc_ecmacti      LIKE tc_ecm_file.tc_ecmacti, 
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否        #No.FUN-680136 SMALLINT
 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_tc_ecm01) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tc_ecm09,tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,tc_ecm07,tc_ecm08,tc_ecmacti ",
                       "   FROM tc_ecm_file  ",
                       "   WHERE tc_ecm00=?  AND tc_ecm01=?   ",
                       "   AND tc_ecm02=? AND tc_ecm09 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_tc_ecm WITHOUT DEFAULTS FROM s_tc_ecm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #CALL i700_set_entry_b()
            #CALL i700_set_no_entry_b()
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
          
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_tc_ecm_t.* = g_tc_ecm[l_ac].*      #BACKUP
                OPEN i700_bcl USING g_tc_ecm00,g_tc_ecm01,g_tc_ecm02,g_tc_ecm_t.tc_ecm09
                IF STATUS THEN
                   CALL cl_err("OPEN i700_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i700_bcl INTO g_tc_ecm[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_tc_ecm_t.tc_ecm09,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   #ELSE
                      #SELECT tc_ecm02 INTO g_tc_ecm[l_ac].tc_ecm04_tc_ecm02 FROM tc_ecm_file
                      # WHERE tc_ecm01 = g_tc_ecm[l_ac].tc_ecm04
                      #LET g_tc_ecm_t.*=g_tc_ecm[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_ecm[l_ac].* TO NULL      #900423
            LET g_tc_ecm_t.* = g_tc_ecm[l_ac].*         #輸入新資料
            LET g_tc_ecm[l_ac].tc_ecmacti = 'Y'
            DISPLAY BY NAME g_tc_ecm[l_ac].tc_ecmacti 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_ecm09
 
    AFTER INSERT

       
      
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tc_ecm_file(tc_ecm00,tc_ecm01,tc_ecm02,tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,
                                    tc_ecm07,tc_ecm08,tc_ecmacti,tc_ecm09)
                          VALUES(g_tc_ecm00,g_tc_ecm01,g_tc_ecm02,g_tc_ecm[l_ac].tc_ecm03,
                                 g_tc_ecm[l_ac].tc_ecm04,g_tc_ecm[l_ac].tc_ecm05,g_tc_ecm[l_ac].tc_ecm06,
                                 g_tc_ecm[l_ac].tc_ecm07,g_tc_ecm[l_ac].tc_ecm08,'Y',g_tc_ecm[l_ac].tc_ecm09)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_ecm_file",g_tc_ecm01,g_tc_ecm[l_ac].tc_ecm09,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD tc_ecm09
           IF g_tc_ecm[l_ac].tc_ecm09 IS NULL THEN
               SELECT MAX(tc_ecm09)+1 INTO g_tc_ecm[l_ac].tc_ecm09 
                 FROM tc_ecm_file WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02=g_tc_ecm02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","tc_ecm_file",g_tc_ecm01,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD tc_ecm09
               END IF 
               IF g_tc_ecm[l_ac].tc_ecm09 IS NULL THEN
                  LET g_tc_ecm[l_ac].tc_ecm09=1
               END IF
            END IF 
 
        AFTER FIELD tc_ecm09
            IF g_tc_ecm[l_ac].tc_ecm09 != g_tc_ecm_t.tc_ecm09 OR g_tc_ecm_t.tc_ecm09 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM tc_ecm_file 
                WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02 AND tc_ecm09=g_tc_ecm[l_ac].tc_ecm09
               IF l_n>=1 THEN
                  CALL cl_err(g_tc_ecm[l_ac].tc_ecm09,"asf-406",1)
                  LET g_tc_ecm[l_ac].tc_ecm09=g_tc_ecm_t.tc_ecm09
                  NEXT FIELD tc_ecm09
               END IF
            END IF
 

              
 
        BEFORE DELETE                            #刪除單身
            IF g_tc_ecm_t.tc_ecm09 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM tc_ecm_file
                 WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01 = g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
                     AND  tc_ecm09 = g_tc_ecm_t.tc_ecm09 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tc_ecm_file",'',"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1 
          
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_ecm[l_ac].* = g_tc_ecm_t.*
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_ecm[l_ac].tc_ecm03,-263,1)
               LET g_tc_ecm[l_ac].* = g_tc_ecm_t.*
            ELSE
               UPDATE tc_ecm_file SET tc_ecm00 = g_tc_ecm00,
                                      tc_ecm01 = g_tc_ecm01,
                                      tc_ecm02 = g_tc_ecm02,
                                      tc_ecm03=g_tc_ecm[l_ac].tc_ecm03,
                                      tc_ecm04=g_tc_ecm[l_ac].tc_ecm04,
                                      tc_ecm05=g_tc_ecm[l_ac].tc_ecm05,
                                      tc_ecm06=g_tc_ecm[l_ac].tc_ecm06,
                                      tc_ecm07=g_tc_ecm[l_ac].tc_ecm07,
                                      tc_ecm08=g_tc_ecm[l_ac].tc_ecm08,
                                      tc_ecmacti=g_tc_ecm[l_ac].tc_ecmacti
                WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01 = g_tc_ecm01 
                  AND tc_ecm02 = g_tc_ecm02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_ecm_file",'',"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_tc_ecm[l_ac].* = g_tc_ecm_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
 
    AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac           #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_ecm[l_ac].* = g_tc_ecm_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_tc_ecm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac           #FUN-D30034 add
            CLOSE i700_bcl
            COMMIT WORK
#No.TQC-6C0019  --begin
   # AFTER INPUT 
        #SELECT SUM(tc_ecm05) INTO l_tc_ecm05 FROM tc_ecm_file WHERE tc_ecm01=g_tc_ecm01
        #IF l_tc_ecm05 <>100 THEN
           #CALL cl_err(' ','agl-107',0)
           #NEXT FIELD tc_ecm05
        #END IF
#No.TQC-6C0019  --end  
          
 
        #ON ACTION CONTROLP
           #CASE
              #WHEN INFIELD(tc_ecm04)
                  # CALL cl_init_qry_var()
                  # LET g_qryparam.form ="q_tc_ecm"
                   #LET g_qryparam.default1 = g_tc_ecm[l_ac].tc_ecm04
                   #CALL cl_create_qry() RETURNING g_tc_ecm[l_ac].tc_ecm04
                   #NEXT FIELD tc_ecm04
           #END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
#        ON ACTION CONTROLO                        #沿用所有欄位                                                                     
#           IF INFIELD(tc_ecm03) AND l_ac > 1 THEN                                                                                      
#               LET g_tc_ecm[l_ac].* = g_tc_ecm[l_ac-1].* 
#               LET g_tc_ecm[l_ac].tc_ecm03 = g_rec_b+1
#               NEXT FIELD tc_ecm03                                                                                                     
#           END IF      
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
    CLOSE i700_bcl
    COMMIT WORK

    IF g_action_choice = "detail" THEN
       RETURN
    END IF
   
    SELECT COUNT(*) INTO l_n FROM tc_ecm_file WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01=g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
    IF l_n = 0 THEN
       CALL i700_delall() 
    END IF
 
END FUNCTION

FUNCTION i700_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000             #No.FUN-680136 VARCHAR(200)
 
 CONSTRUCT l_wc ON tc_ecm09,tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,tc_ecm07,tc_ecm08,tc_ecmacti #屏幕上取條件
       FROM s_tc_ecm[1].tc_ecm09,s_tc_ecm[1].tc_ecm03,s_tc_ecm[1].tc_ecm04,s_tc_ecm[1].tc_ecm05,s_tc_ecm[1].tc_ecm06,
            s_tc_ecm[1].tc_ecm07,s_tc_ecm[1].tc_ecm08,s_tc_ecm[1].tc_ecmacti
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
       ON ACTION qbe_select
           CALL cl_qbe_select() 
           
       ON ACTION qbe_save
           CALL cl_qbe_save()
 
       ON ACTION about         
          CALL cl_about()      
  
       ON ACTION help          
          CALL cl_show_help()  
  
       ON ACTION controlg      
          CALL cl_cmdask()     
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i700_b_fill(l_wc)
END FUNCTION

FUNCTION i700_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT tc_ecm09,tc_ecm03,tc_ecm04,tc_ecm05,tc_ecm06,tc_ecm07,tc_ecm08,tc_ecmacti",
                "  FROM tc_ecm_file ",
                " WHERE tc_ecm00 = '",g_tc_ecm00,"'",
                " AND tc_ecm01 = '",g_tc_ecm01,"'",
                " AND tc_ecm02 = '",g_tc_ecm02,"'",
    #           "   AND ",p_wc CLIPPED ,    #No.TQC-6C0019
                " ORDER BY tc_ecm09"
    PREPARE i700_prepare2 FROM g_sql      
    DECLARE tc_ecm_cs CURSOR FOR i700_prepare2
    CALL g_tc_ecm.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH tc_ecm_cs INTO g_tc_ecm[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
        CALL g_tc_ecm.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1     
       #LET g_cnt = 0
END FUNCTION


FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ecm TO s_tc_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
         
      ON ACTION first 
         CALL i700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
 
      ON ACTION detail
         LET g_action_choice="detail"
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

      ON ACTION invalid
         LET g_action_choice="invalid"
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i700_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("tc_ecm01",TRUE) 
       CALL cl_set_comp_entry("tc_ecm02",TRUE)   
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i700_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
      IF p_cmd = 'u' AND g_chkey = 'Y' THEN                                    
           CALL cl_set_comp_entry("tc_ecm01",FALSE) 
          CALL cl_set_comp_entry("tc_ecm02",FALSE)              
       END IF                                                                   
   END IF                                                                       
END FUNCTION
 
 
FUNCTION i700_delall()                                                                                                              
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料                                                            
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED                       
      #IF cl_delb(0,0) THEN                       
          DELETE FROM tc_ecm_file WHERE tc_ecm00 = g_tc_ecm00 AND tc_ecm01 = g_tc_ecm01 AND tc_ecm02 = g_tc_ecm02
          CLEAR FORM 
          CALL g_tc_ecm.clear() 
      #END IF                                                                                                                       
    END IF                                                                                                                          
END FUNCTION    