# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ceci610
# Descriptions...: 
# Date & Author..: 16/16/02  By guanyao160802

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING,     
                 a   LIKE type_file.chr10       #合計選項  #FUN-D10105                 
              END RECORD        
   DEFINE l_where         STRING 
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE l_table         STRING   
   DEFINE g_msg           LIKE type_file.chr1000
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10   
   DEFINE g_tc_shc       RECORD LIKE tc_shc_file.*
   DEFINE g_tc_shc_t       RECORD LIKE tc_shc_file.*

   DEFINE g_tc_shb02_t    LIKE tc_shb_file.tc_shb02   
   DEFINE g_sfb,g_sfb_t,g_sfb_excel   DYNAMIC ARRAY OF RECORD  
       check             LIKE type_file.chr1,
       tc_shc01          LIKE tc_shc_file.tc_shc01,
       tc_shc02          LIKE tc_shc_file.tc_shc02,
       tc_shc03          LIKE tc_shc_file.tc_shc03,
       tc_shc04          LIKE tc_shc_file.tc_shc04,
       tc_shc05          LIKE tc_shc_file.tc_shc05,
       ima02             LIKE ima_file.ima02,
       ima021            LIKE ima_file.ima021,
       ecbud06           LIKE  ecb_file.ecbud06,
       tc_shc06          LIKE tc_shc_file.tc_shc06,
       tc_shc07          LIKE tc_shc_file.tc_shc07,
       tc_shc08          LIKE tc_shc_file.tc_shc08,
       ecd02             LIKE ecd_file.ecd02,
       tc_shc09          LIKE tc_shc_file.tc_shc09,
       eca02             LIKE eca_file.eca02,
       tc_shc10          LIKE tc_shc_file.tc_shc10,
       tc_shc11          LIKE tc_shc_file.tc_shc11,
       gen02             LIKE gen_file.gen02,
       tc_shc12          LIKE tc_shc_file.tc_shc12,
       tc_shc13          LIKE tc_shc_file.tc_shc13,
       ecg02             LIKE ecg_file.ecg02,
       tc_shc14          LIKE tc_shc_file.tc_shc14,
       tc_shc15          LIKE tc_shc_file.tc_shc15,
       tc_shc16          LIKE tc_shc_file.tc_shc16,
       tc_shb17          LIKE tc_shb_file.tc_shb17,
       tc_shbud02        LIKE tc_shb_file.tc_shbud02,
       tc_shbud09        LIKE tc_shb_file.tc_shbud09,
       tc_shb121         LIKE tc_shb_file.tc_shb121,
       tc_shb122         LIKE tc_shb_file.tc_shb122
                         END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5    
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
   DEFINE   w    ui.Window      
   DEFINE   f    ui.Form       
   DEFINE   page om.DomNode 
   DEFINE g_gen01     LIKE gen_file.gen01
     
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW i610_w AT 5,10
        WITH FORM "cec/42f/ceci610" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)


   
   CALL i610_table()  
   CALL i610_q()   
   CALL i610_menu()
   DROP TABLE ceci610_tmp;
   DROP TABLE ceci610_tmp_1;
   CLOSE WINDOW i610_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i610_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
      CALL  i610_bp('G')
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()    
            END IF    
            LET g_action_choice = " "
         #WHEN "data_filter"       #資料過濾
         #   IF cl_chk_act_auth() THEN
         #      CALL i610_filter_askkey()
         #      CALL i610()        #重填充新臨時表
         #      CALL i610_show()
         #   END IF            
         #   LET g_action_choice = " "
         #WHEN "revert_filter"     # 過濾還原
         #   IF cl_chk_act_auth() THEN
         #      CALL cl_set_act_visible("revert_filter",FALSE) 
         #      CALL i610()        #重填充新臨時表
         #      CALL i610_show() 
         #   END IF             
         #   LET g_action_choice = " "
         
        WHEN "insert"
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i610_a()
            END IF
        WHEN "modify"
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i610_u()
            END IF
         WHEN "delete_tc"
            IF cl_chk_act_auth() THEN
               CALL i610_delete_tc()    
            END IF    
            LET g_action_choice = " "
         WHEN "update_tc"
            IF cl_chk_act_auth() THEN
               CALL i610_update_tc()    
            END IF    
            LET g_action_choice = " "
         WHEN "detail"
            IF cl_chk_act_auth() THEN                      #判断g_user是否有执行权限
               CALL i610_b()                               #点击"单身"或按"B"进入此函数
            END IF 
            LET g_action_choice = " "
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "sfb01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION



FUNCTION i610_a()

    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_sfb.clear()
 
       
    LET g_tc_shb02_t = NULL
    
    CALL cl_opmsg('a')
    WHILE TRUE
      
        CALL i610_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
        INITIALIZE g_tc_shc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_shb.tc_shc02 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        
        IF g_tc_shb.tc_shc01='1'   THEN 
         INSERT INTO tc_shc_file (tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,tc_shc06,tc_shc07,tc_shc08,tc_shc09,tc_shc10,tc_shc11,tc_shc12,tc_shc13,tc_shc15,tc_shc16,tc_shcud09)
            VALUES('1',g_tc_shb.tc_shc02,g_tc_shb.tc_shc03,g_tc_shb.tc_shc04,g_tc_shb.tc_shc05,g_tc_shb.tc_shc06,g_tc_shb.tc_shc07,g_tc_shb.tc_shc08,g_tc_shb.tc_shc09,g_tc_shb.tc_shc10,g_tc_shb.tc_shc11,g_tc_shb.tc_shc12,g_tc_shb.tc_shc13,g_tc_shb.tc_shc15,g_tc_shb.tc_shc16,g_tc_shb.tc_shbud09)
        END IF 

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_shb_file",g_tc_shb.sfb02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF

        
        IF g_tc_shb._shc01='2'  THEN 
        INSERT INTO tc_shc_file (tc_shb01,tc_shb02,tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb08,tc_shb09,tc_shb10,tc_shb11,tc_shb12,tc_shb13,tc_shb15,tc_shb16,tc_shb17,tc_shbud02,tc_shcud09)
          VALUES('1',g_tc_shb.tc_shc02,g_tc_shb.tc_shc03,g_tc_shb.tc_shc04,g_tc_shb.tc_shc05,g_tc_shb.tc_shc06,g_tc_shb.tc_shc07,g_tc_shb.tc_shc08,g_tc_shb.tc_shc09,g_tc_shb.tc_shc10,g_tc_shb.tc_shc11,g_tc_shb.tc_shc12,g_tc_shb.tc_shc13,g_tc_shb.tc_shc15,g_tc_shb.tc_shc16,g_tc_shb.tc_shb17,g_tc_shb.tc_shbud02,g_tc_shb.tc_shbud09)
        END IF 

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_shc_file",g_tc_shb.sfb02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        
        IF g_tc_shb._shc01='3'  THEN 
          INSERT INTO tc_shc_file (tc_shb01,tc_shb02,tc_shb03,tc_shb04,tc_shb05,tc_shb06,tc_shb07,tc_shb08,tc_shb09,tc_shb10,tc_shb11,tc_shb12,tc_shb13,tc_shb15,tc_shb16,tc_shb17,tc_shbud02,tc_shcud09)        
          VALUES('2',g_tc_shb.tc_shc02,g_tc_shb.tc_shc03,g_tc_shb.tc_shc04,g_tc_shb.tc_shc05,g_tc_shb.tc_shc06,g_tc_shb.tc_shc07,g_tc_shb.tc_shc08,g_tc_shb.tc_shc09,g_tc_shb.tc_shc10,g_tc_shb.tc_shc11,g_tc_shb.tc_shc12,g_tc_shb.tc_shc13,g_tc_shb.tc_shc15,g_tc_shb.tc_shc16,g_tc_shb.tc_shb17,g_tc_shb.tc_shbud02,g_tc_shb.tc_shbud09)
        END IF 

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_shb_file",g_tc_shb.sfb02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        
        IF g_tc_shb.tc_shc01='4'   THEN 
         INSERT INTO tc_shc_file (tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,tc_shc06,tc_shc07,tc_shc08,tc_shc09,tc_shc10,tc_shc11,tc_shc12,tc_shc13,tc_shc15,tc_shc16,tc_shcud09)
         VALUES('2',g_tc_shb.tc_shc02,g_tc_shb.tc_shc03,g_tc_shb.tc_shc04,g_tc_shb.tc_shc05,g_tc_shb.tc_shc06,g_tc_shb.tc_shc07,g_tc_shb.tc_shc08,g_tc_shb.tc_shc09,g_tc_shb.tc_shc10,g_tc_shb.tc_shc11,g_tc_shb.tc_shc12,g_tc_shb.tc_shc13,g_tc_shb.tc_shc15,g_tc_shb.tc_shc16,g_tc_shb.tc_shbud09)
        END IF 
       
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_shc_file",g_tc_shb.sfb02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i610_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gen03       LIKE gen_file.gen03
   DEFINE l_gen04       LIKE gen_file.gen04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME
      g_sfb.tc_shc01,g_sfb.tc_shc02,g_sfb.tc_shc03,
      g_sfb.tc_shc04,g_sfb.tc_shc05,g_sfb.tc_shc06,g_sfb.tc_shc07,g_sfb.tc_shc08,
      g_sfb.tc_shc09,g_sfb.tc_shc10,g_sfb.tc_shc11,g_sfb.tc_shc12,g_sfb.tc_shc13,
      g_sfb.tc_shc14,g_sfb.tc_shc15,g_sfb.tc_shc16,g_sfb.tc_shb17,g_sfb.tc_shbud02,
      g_sfb.tc_shbud09,g_sfb.tc_shb121
 
   INPUT BY NAME
      g_sfb.tc_shc01,g_sfb.tc_shc02,g_sfb.tc_shc03,
      g_sfb.tc_shc04,g_sfb.tc_shc05,g_sfb.tc_shc06,g_sfb.tc_shc07,g_sfb.tc_shc08,
      g_sfb.tc_shc09,g_sfb.tc_shc10,g_sfb.tc_shc11,g_sfb.tc_shc12,g_sfb.tc_shc13,
      g_sfb.tc_shc14,g_sfb.tc_shc15,g_sfb.tc_shc16,g_sfb.tc_shb17,g_sfb.tc_shbud02,
      g_sfb.tc_shbud09,g_sfb.tc_shb121
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i010_set_entry(p_cmd)
          CALL i010_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
     AFTER FIELD tc_shc01
         IF g_tc_shb.tc_shc01 IS  NULL THEN
           
                  DISPLAY BY NAME g_tc_shb.tc_shc01
                  NEXT FIELD tc_shc01
    
         END IF

         
      AFTER FIELD tc_shc02
         IF g_sfb.tc_shc02 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_sfb.tc_shc02 != g_sfb.tc_shc02_t) THEN # 若輸入或更改且改KEY
            IF g_tc_shb.tc_shc01='1' OR g_tc_shb.tc_shc01='4'  THEN 
              SELECT count(*) INTO l_n FROM tc_shc_file WHERE tc_shc02 = g_sfb.tc_shc02
              IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_sfb.tc_shc02,-239,1)
                  LET g_tc_shb02 = g_tc_shb02_t
                  DISPLAY BY NAME g_sfb.tc_shc02
                  NEXT FIELD tc_shc02
               END IF
            END IF 

           IF g_tc_shb.tc_shc01='2' OR g_tc_shb.tc_shc01='3'  THEN 
            
               SELECT count(*) INTO l_n FROM tc_shb_file WHERE tc_shb02  = g_sfb.tc_shc02
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_sfb.tc_shc02,-239,1)
                  LET g_tc_shb02 = g_tc_shb02_t
                  DISPLAY BY NAME g_sfb.tc_shc02
                  NEXT FIELD tc_shc02
               END IF
            END  IF 
            END IF
         END IF
 
      AFTER INPUT
        
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_sfb.tc_shc01 IS NULL THEN
               DISPLAY BY NAME g_sfb.tc_shc01
               LET l_input='Y'
            END IF
             IF g_sfb.tc_shc02 IS NULL THEN
               DISPLAY BY NAME g_sfb.tc_shc02
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD  tc_shc01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(tc_shc02) THEN
            LET g_sfb.* = g_sfb_t.*
           call i610_b_fill()
            NEXT FIELD tc_shc02
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_shc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc03
                  NEXT FIELD tc_shc03
               WHEN INFIELD(tc_shc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc04_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc04
                  NEXT FIELD tc_shc04
               WHEN INFIELD(tc_shc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc05
                  NEXT FIELD tc_shc05
               WHEN INFIELD(tc_shc08)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc08
                  NEXT FIELD tc_shc08
               WHEN INFIELD(tc_shc09)
                  CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc09
                  NEXT FIELD tc_shc09
               WHEN INFIELD(tc_shc11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc11
                  NEXT FIELD tc_shc11
               WHEN INFIELD(tc_shc13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_ecg"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc13
                  NEXT FIELD tc_shc13
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 

FUNCTION i610_u()
DEFINE g_forupd_sql                 STRING 

    IF g_sfb.tc_shc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    
    IF g_sfb.tc_shc01='1' OR   g_sfb.tc_shc01='4' THEN 
       LET g_forupd_sql = "SELECT * FROM tc_shc_file WHERE tc_shc02 = ? FOR UPDATE "  
     ELSE
      LET g_forupd_sql = "SELECT  * FROM tc_shb_file WHERE  tc_shb02 = ? FOR UPDATE " 
    END IF  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i610_cl CURSOR FROM g_forupd_sql 


        CALL cl_opmsg('u')
    LET g_tc_shb02_t = g_sfb.tc_shc02
    BEGIN WORK
    
    OPEN i610_cl USING g_sfb.tc_shc02
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i610_cl INTO g_tc_shb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfb.sfb02,SQLCA.sqlcode,1)
        RETURN
    END IF
    
    #CALL i010_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i610_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sfb.*=g_sfb_t.*
            # i610_b_fill()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         IF g_sfb.tc_shc01='1' OR   g_sfb.tc_shc01='4' THEN 

        UPDATE tc_shc_file 
        SET tc_shc12=g_sfb.tc_shc12,
            tc_shcud09=g_sfb.tc_shbud09
            #WHERE azb01 = g_azb.azb01     #MOD-BB0113 mark
            WHERE tc_shc02 = g_tc_shb02_t    #MOD-BB0113 add
        END IF 

        IF g_sfb.tc_shc01='2' OR   g_sfb.tc_shc01='3' THEN 
        UPDATE tc_shb_file 
        SET tc_shb12=g_sfb.tc_shb12,
            tc_shb17=g_sfb.tc_shb17,
            tc_shbud02=g_sfb.tc_shbud02,
            tc_shbud09=g_sfb.tc_shbud09
            #WHERE azb01 = g_azb.azb01     #MOD-BB0113 mark
            WHERE tc_shb02 = g_tc_shb02_t    #MOD-BB0113 add
        END IF 
        
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","azb_file",g_azb.azb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i610_cl
    COMMIT WORK
END FUNCTION



FUNCTION i610_b()
DEFINE l_ac    LIKE type_file.num5
DEFINE i    LIKE type_file.num5

  INPUT ARRAY g_sfb  WITHOUT DEFAULTS FROM s_tc_shc.*
       ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)

    BEFORE ROW
       LET l_ac = ARR_CURR()


    ON ROW CHANGE 
       IF INT_FLAG THEN 
          EXIT INPUT 
       END IF 
    ON ACTION sel_all
          FOR i = 1 TO g_rec_b
             LET g_sfb[i].check = 'Y'
          END FOR 

       ON ACTION unsel_all
          FOR i = 1 TO g_rec_b
             LET g_sfb[i].check= 'N'
          END FOR  

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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
END FUNCTION 

 
FUNCTION i610_b_fill()
DEFINE l_wc2    STRING 

    LET l_wc2 = cl_replace_str(tm.wc2,'tc_shc','tc_shb')

   LET g_sql =  "SELECT 'N',CASE tc_shc01 WHEN '1' THEN 1 ELSE 4 END tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,",
                "       ima02,ima021,ta_ecd05,tc_shc06,tc_shc07,tc_shc08,ecd02,tc_shc09,eca02,tc_shc10,tc_shc11,gen02,tc_shc12,tc_shc13,",
                "       ecg02,tc_shc14,tc_shc15,tc_shc16,0 tc_shb121,0 tc_shb122",
                "  FROM tc_shc_file LEFT JOIN gen_file ON gen01 = tc_shc11",
                "                   LEFT JOIN ima_file ON ima01 = tc_shc05",
                "                   LEFT JOIN ecd_file ON ecd01 = tc_shc08",
                "                   LEFT JOIN eca_file ON eca01 = tc_shc09",
                "                   LEFT JOIN ecg_file ON ecg01 = tc_shc13",
                " WHERE ",tm.wc2 CLIPPED,
                " UNION",
                " SELECT 'N',CASE tc_shb01 WHEN '1' THEN 2 ELSE 3 END tc_shc01,tc_shb02,tc_shb03 tc_shc03,tc_shb04 tc_shc04,tc_shb05,",
                "        ima02,ima021,ta_ecd05,tc_shb06 tc_shc06,tc_shb07,tc_shb08,ecd02,tc_shb09,eca02,tc_shb10,tc_shb11,gen02,tc_shb12,tc_shb13,",
                "        ecg02,tc_shb14,tc_shb15,tc_shb16,tc_shb121,tc_shb122",
                "   FROM tc_shb_file LEFT JOIN gen_file ON gen01 = tc_shb11",
                "                    LEFT JOIN ima_file ON ima01 = tc_shb05",
                "                    LEFT JOIN ecd_file ON ecd01 = tc_shb08",
                "                    LEFT JOIN eca_file ON eca01 = tc_shb09",
                "                    LEFT JOIN ecg_file ON ecg01 = tc_shb13",
                " WHERE ",l_wc2 CLIPPED,
                "  ORDER BY tc_shc03,tc_shc06,tc_shc01"   


   PREPARE ceci610_pb FROM g_sql
   DECLARE sfb_curs  CURSOR FOR ceci610_pb        #CURSOR


   CALL g_sfb.clear()
   CALL g_sfb_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH sfb_curs INTO g_sfb_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      

      IF g_cnt < = g_max_rec THEN
         LET g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
      END IF
      IF g_cnt > g_max_rec THEN 
         CONTINUE FOREACH 
      END IF 
      LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_sfb.deleteElement(g_cnt)
   END IF
   CALL g_sfb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION


FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_sfb TO s_tc_shc.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         LET g_action_choice = "detail"
         EXIT DIALOG

      ON ACTION detail 
         LET g_action_choice = "detail"
         EXIT DIALOG
   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION delete_tc
         LET g_action_choice="delete_tc"
         EXIT DIALOG

      ON ACTION update_tc
         LET g_action_choice="update_tc"
         EXIT DIALOG
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i610_cs()
   DEFINE  l_cnt           LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     
   DEFINE  li_chk_bookno   LIKE type_file.num5
 
   CLEAR FORM   #清除畫面
   CALL g_sfb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  
   DIALOG ATTRIBUTE(UNBUFFERED)    

         CONSTRUCT tm.wc2 ON tc_shc02,tc_shc03,tc_shc04,tc_shc05,tc_shc06,tc_shc07,tc_shc08,tc_shc09,tc_shc10, tc_shc11,tc_shc12,tc_shc13,
                             tc_shc14,tc_shc15,tc_shc16

                        FROM s_tc_shc[1].tc_shc02,s_tc_shc[1].tc_shc03,s_tc_shc[1].tc_shc04,s_tc_shc[1].tc_shc05,s_tc_shc[1].tc_shc06,
                             s_tc_shc[1].tc_shc07,s_tc_shc[1].tc_shc08,s_tc_shc[1].tc_shc09,s_tc_shc[1].tc_shc10,s_tc_shc[1].tc_shc11,
                             s_tc_shc[1].tc_shc12,s_tc_shc[1].tc_shc13,s_tc_shc[1].tc_shc14,s_tc_shc[1].tc_shc15,s_tc_shc[1].tc_shc16

              
            BEFORE CONSTRUCT
               CALL cl_qbe_init()


         END CONSTRUCT
         #出貨單欄位

         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_shc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc03
                  NEXT FIELD tc_shc03
               WHEN INFIELD(tc_shc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc04_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc04
                  NEXT FIELD tc_shc04
               WHEN INFIELD(tc_shc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc05
                  NEXT FIELD tc_shc05
               WHEN INFIELD(tc_shc08)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc08
                  NEXT FIELD tc_shc08
               WHEN INFIELD(tc_shc09)
                  CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc09
                  NEXT FIELD tc_shc09
               WHEN INFIELD(tc_shc11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc11
                  NEXT FIELD tc_shc11
               WHEN INFIELD(tc_shc13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_ecg"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc13
                  NEXT FIELD tc_shc13
            END CASE
       
          
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION qbe_select
    	    CALL cl_qbe_select() 

         ON ACTION ACCEPT
            ACCEPT DIALOG 

         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG    
   END DIALOG                                                                                                                                                                     
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      DELETE FROM axci610_tmp
   END IF

END FUNCTION 

FUNCTION i610_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i610_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL i610_b_fill()  
END FUNCTION

FUNCTION i610_table()
   #DROP TABLE ceci610_tmp;  #FUN-D10105 mark
   CREATE TEMP TABLE ceci610_tmp(
       tc_shc01          LIKE tc_shc_file.tc_shc01,
       tc_shc02          LIKE tc_shc_file.tc_shc02,
       tc_shc03          LIKE tc_shc_file.tc_shc03,
       tc_shc04          LIKE tc_shc_file.tc_shc04,
       tc_shc05          LIKE tc_shc_file.tc_shc05,
       ima02             LIKE ima_file.ima02,
       ima021            LIKE ima_file.ima021,
       ecbud06           LIKE ecb_file.ecbud06,
       tc_shc06          LIKE tc_shc_file.tc_shc06,
       tc_shc07          LIKE tc_shc_file.tc_shc07,
       tc_shc08          LIKE tc_shc_file.tc_shc08,
       ecd02             LIKE ecd_file.ecd02,
       tc_shc09          LIKE tc_shc_file.tc_shc09,
       eca02             LIKE eca_file.eca02,
       tc_shc10          LIKE tc_shc_file.tc_shc10,
       tc_shc11          LIKE tc_shc_file.tc_shc11,
       gen02             LIKE gen_file.gen02,
       tc_shc12          LIKE tc_shc_file.tc_shc12,
       tc_shc13          LIKE tc_shc_file.tc_shc13,
       ecg02             LIKE ecg_file.ecg02,
       tc_shc14          LIKE tc_shc_file.tc_shc14,
       tc_shc15          LIKE tc_shc_file.tc_shc15,
       tc_shc16          LIKE tc_shc_file.tc_shc16,
       tc_shb121         LIKE tc_shb_file.tc_shb121,
       tc_shb122         LIKE tc_shb_file.tc_shb122,
       rowno             LIKE type_file.num10)  
    CREATE TEMP TABLE ceci610_tmp_1(
       tc_shc02       LIKE tc_shc_file.tc_shc02,
       tc_shc03       LIKE tc_shc_file.tc_shc03,
       tc_shc06       LIKE tc_shc_file.tc_shc06)
END FUNCTION 

FUNCTION i610_delete_tc()
DEFINE i             LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5
DEFINE l_tc_shc02    LIKE tc_shc_file.tc_shc02
DEFINE l_tc_shc03    LIKE tc_shc_file.tc_shc03
DEFINE l_tc_shc06    LIKE tc_shc_file.tc_shc06

     DELETE FROM ceci610_tmp_1
     LET l_n = 0
     FOR i  = 1 TO g_rec_b 
        IF g_sfb[i].check = 'Y' THEN 
           LET l_n = l_n +1
           INSERT INTO ceci610_tmp_1 VALUES (g_sfb[i].tc_shc02,g_sfb[i].tc_shc03,g_sfb[i].tc_shc06)
        END IF 
     END FOR 
     IF l_n <1 THEN 
        RETURN 
     ELSE
        IF NOT cl_confirm('cec-014') THEN
           RETURN
        END IF
     END IF 
     
     LET g_success = 'Y'
     BEGIN WORK 
     DECLARE i610_del CURSOR WITH HOLD FOR SELECT tc_shc02,tc_shc03,tc_shc06 FROM ceci610_tmp_1 ORDER BY tc_shc06 DESC 
     FOREACH i610_del INTO l_tc_shc02,l_tc_shc03,l_tc_shc06 
        #str----add by guanyao160904]
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM tc_shc_file WHERE tc_shc03 = l_tc_shc03 AND tc_shc06 > l_tc_shc06
        IF l_x > 0 THEN 
           CALL cl_err('','cec-024',0)
           LET g_success = 'N' 
           EXIT FOREACH 
        END IF 
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM tc_shb_file WHERE tc_shb03 = l_tc_shc03 AND tc_shb06 >l_tc_shc06
        IF l_x > 0 THEN 
           CALL cl_err('','cec-024',0)
           LET g_success = 'N' 
           EXIT FOREACH 
        END IF 
        LET l_x =0
        SELECT COUNT(*) INTO l_x FROM sfp_file WHERE sfpud04 = l_tc_shc02
        IF l_x > 0 THEN 
           CALL cl_err('','cec-026',0)
           LET g_success = 'N' 
           EXIT FOREACH 
        END IF 
        #end----add by guanyao160904
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM shb_file WHERE shb16 = l_tc_shc03 AND shb06 = l_tc_shc06
        IF l_x > 0 THEN 
           CALL cl_err('','cec-013',0)
           LET g_success = 'N' 
           EXIT FOREACH 
        END IF 
        LET l_x = 0
        SELECT count(*) INTO l_x FROM tc_shc_file WHERE tc_shc02 =l_tc_shc02
        IF l_x >0 THEN 
           DELETE FROM  tc_shc_file WHERE tc_shc02  = l_tc_shc02
           IF STATUS THEN
              CALL cl_err3("del","tc_shc_file",l_tc_shc02,"",STATUS,"","delete tc_shc_file:",1)  #No.FUN-660128
              LET g_success='N'
              EXIT FOREACH         
           END IF
        ELSE 
           DELETE FROM  tc_shb_file WHERE tc_shb02  = l_tc_shc02
           IF STATUS THEN
              CALL cl_err3("del","tc_shb_file",l_tc_shc02,"",STATUS,"","delete tc_shb_file:",1)  #No.FUN-660128
              LET g_success='N'
              EXIT FOREACH         
           END IF
        END IF  
     END FOREACH 

     IF g_success = 'Y' THEN 
        COMMIT WORK 
        CALL cl_getmsg('cec-016',g_lang) RETURNING g_msg
        CALL cl_msgany(0,0,g_msg)
     ELSE 
        ROLLBACK WORK 
     END IF 
     CALL i610_b_fill()
     
END FUNCTION 

FUNCTION i610_update_tc()
DEFINE i             LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5
DEFINE l_tc_shc02    LIKE tc_shc_file.tc_shc02
DEFINE l_tc_shc03    LIKE tc_shc_file.tc_shc03
DEFINE l_tc_shc06    LIKE tc_shc_file.tc_shc06

     DELETE FROM ceci610_tmp_1
     LET l_n = 0
     FOR i  = 1 TO g_rec_b 
        IF g_sfb[i].check = 'Y' THEN 
           LET l_n = l_n +1
           INSERT INTO ceci610_tmp_1 VALUES (g_sfb[i].tc_shc02,g_sfb[i].tc_shc03,g_sfb[i].tc_shc06)
        END IF 
     END FOR 
     IF l_n <1 THEN 
        RETURN 
     ELSE
        IF NOT cl_confirm('cec-018') THEN
           RETURN
        END IF
     END IF 
     CALL i610_tm()
     IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
     END IF 
     LET g_success = 'Y'
     BEGIN WORK 
     DECLARE i610_del1 CURSOR WITH HOLD FOR SELECT tc_shc02,tc_shc03,tc_shc06 FROM ceci610_tmp_1 
     FOREACH i610_del1 INTO l_tc_shc02,l_tc_shc03,l_tc_shc06 
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM shb_file WHERE shb16 = l_tc_shc03 AND shb06 = l_tc_shc06
        IF l_x > 0 THEN 
           CALL cl_err('','cec-013',0)
           LET g_success = 'N' 
           EXIT FOREACH 
        END IF 
        LET l_x = 0
        SELECT count(*) INTO l_x FROM tc_shc_file WHERE tc_shc02 =l_tc_shc02
        IF l_x >0 THEN 
           UPDATE tc_shc_file SET tc_shc11 = g_gen01 WHERE tc_shc02  = l_tc_shc02
           IF STATUS THEN
              CALL cl_err3("upd","tc_shc_file",l_tc_shc02,"",STATUS,"","upd tc_shc_file:",1)  #No.FUN-660128
              LET g_success='N'
              EXIT FOREACH         
           END IF
        ELSE 
           UPDATE tc_shb_file SET tc_shb11 = g_gen01 WHERE tc_shb02  = l_tc_shc02
           IF STATUS THEN
              CALL cl_err3("upd","tc_shb_file",l_tc_shc02,"",STATUS,"","upd tc_shb_file:",1)  #No.FUN-660128
              LET g_success='N'
              EXIT FOREACH         
           END IF
        END IF  
     END FOREACH 

     IF g_success = 'Y' THEN 
        COMMIT WORK 
        CALL cl_getmsg('cec-017',g_lang) RETURNING g_msg
        CALL cl_msgany(0,0,g_msg)
     ELSE 
        ROLLBACK WORK 
     END IF 
     CALL i610_b_fill()
END FUNCTION 
FUNCTION i610_tm()
DEFINE l_x       LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02


   OPEN WINDOW i610_tm AT 5,10
        WITH FORM "cec/42f/ceci610_s" ATTRIBUTE(STYLE = g_win_style)  
   CALL cl_ui_init()

   INPUT g_gen01 FROM gen01 

       AFTER FIELD gen01
          IF NOT cl_null(g_gen01) THEN 
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM gen_file WHERE gen01=g_gen01
             IF cl_null(l_x) OR l_x = 0 THEN 
                CALL cl_err('','cec-015',0)
                NEXT FIELD gen01
             END IF  
             SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_gen01
             DISPLAY l_gen02 TO gen02
          END IF 

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION controlp
          CASE 
             WHEN INFIELD(gen01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen" 
               LET g_qryparam.default1 = g_gen01
               CALL cl_create_qry() RETURNING g_gen01
               DISPLAY g_gen01 TO  gen01
               SELECT gen02 INTO l_gen02 FROM gen_file 
                WHERE gen01 = g_gen01 
               DISPLAY l_gen02 TO gen02 
               NEXT FIELD gen01
               
               
            END CASE 

   END INPUT 

   IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       LET g_gen01 = ''
       CLOSE WINDOW i610_tm
       LET INT_FLAG = 0
       RETURN 
    END IF 
    CLOSE WINDOW i610_tm
END FUNCTION 
