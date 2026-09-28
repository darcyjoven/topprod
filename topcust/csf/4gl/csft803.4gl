IMPORT os

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
DEFINE g_tc_hla      RECORD LIKE tc_hla_file.* #签核等级（单头）
DEFINE g_tc_hla_t    RECORD LIKE tc_hla_file.* #签核等级（单头，旧值备份）
DEFINE g_tc_hla_o    RECORD LIKE tc_hla_file.* #签核等级（单头，旧值备份）
DEFINE g_tc_hla01_t LIKE tc_hla_file.tc_hla01#签核等级（单头，旧值备份）
DEFINE g_tc_hlb  DYNAMIC ARRAY OF RECORD
    sel           LIKE type_file.chr1,
    tc_hlb02      LIKE tc_hlb_file.tc_hlb02,
    tc_hlb03      LIKE tc_hlb_file.tc_hlb03,
    tc_hlb04      LIKE tc_hlb_file.tc_hlb04,
    tc_hlb05      LIKE tc_hlb_file.tc_hlb05,
    tc_hlb06      LIKE tc_hlb_file.tc_hlb06,
    tc_hlb07      LIKE tc_hlb_file.tc_hlb07,
    tc_hlbud02    LIKE tc_hlb_file.tc_hlbud02
                  END RECORD
DEFINE g_tc_hlb_t RECORD 
    sel           LIKE type_file.chr1,
    tc_hlb02      LIKE tc_hlb_file.tc_hlb02,
    tc_hlb03      LIKE tc_hlb_file.tc_hlb03,
    tc_hlb04      LIKE tc_hlb_file.tc_hlb04,
    tc_hlb05      LIKE tc_hlb_file.tc_hlb05,
    tc_hlb06      LIKE tc_hlb_file.tc_hlb06,
    tc_hlb07      LIKE tc_hlb_file.tc_hlb07,
    tc_hlbud02    LIKE tc_hlb_file.tc_hlbud02
                  END RECORD
DEFINE g_tc_hlb_o RECORD 
    sel           LIKE type_file.chr1, 
    tc_hlb02      LIKE tc_hlb_file.tc_hlb02,
    tc_hlb03      LIKE tc_hlb_file.tc_hlb03,
    tc_hlb04      LIKE tc_hlb_file.tc_hlb04,
    tc_hlb05      LIKE tc_hlb_file.tc_hlb05,
    tc_hlb06      LIKE tc_hlb_file.tc_hlb06,
    tc_hlb07      LIKE tc_hlb_file.tc_hlb07,
    tc_hlbud02    LIKE tc_hlb_file.tc_hlbud02
    
                  END RECORD
DEFINE g_wc     STRING #单头SELECT的where条件
DEFINE g_wc2    STRING #单身SELECT的where条件
DEFINE g_sql    STRING #CURSOR用的SQL暂存字符串
DEFINE g_rec_b      LIKE type_file.num5
DEFINE l_ac         LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr  LIKE type_file.chr1
DEFINE g_chr2  LIKE type_file.chr1
DEFINE g_cnt  LIKE type_file.num10
DEFINE g_i    LIKE type_file.num5
DEFINE g_msg  LIKE ze_file.ze03
DEFINE g_curs_index LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5
DEFINE g_t1         LIKE oay_file.oayslip    
DEFINE g_sheet      LIKE oay_file.oayslip        #單別 (沿 用)
DEFINE g_ydate      LIKE type_file.dat           #單據日期(沿用)
       
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
  IF (NOT cl_user()) THEN               
      EXIT PROGRAM                        
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF(NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_tc_hla.* TO NULL
   LET g_forupd_sql="SELECT * FROM tc_hla_file WHERE tc_hla01=? FOR UPDATE"
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DEClARE t803_cl CURSOR FROM g_forupd_sql
   OPEN WINDOW t803_w WITH FORM"csf/42f/csft803"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
   LET g_action_choice=""
   CALL t803_menu()
   CLOSE WINDOW t803_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t803_cs()
    DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
    DEFINE l_gen02 LIKE gen_file.gen02
    CLEAR  FORM    
    INITIALIZE g_tc_hla.* TO NULL
    CONSTRUCT BY NAME g_wc ON 
        tc_hla01,tc_hla02,tc_hla03,tc_hla04,tc_hla05,
        tc_hla06,tc_hla07,tc_hla08,
        tc_hla09,tc_hla10,tc_hla11
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
    ON ACTION controlp
       CASE
          WHEN INFIELD(tc_hla01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_tc_hla01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_hla01
            NEXT FIELD tc_hla01
          WHEN INFIELD(tc_hla07)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_tc_hla07"       
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_hla07
            NEXT FIELD tc_hla07
        WHEN INFIELD(tc_hla08)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_tc_hla08"       
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_hla08
            NEXT FIELD tc_hla08

          WHEN INFIELD(tc_hla09)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_tc_hla09"       
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_hla09
            NEXT FIELD tc_hla09

          WHEN INFIELD(tc_hla10)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_tc_hla10"       
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_hla10
            NEXT FIELD tc_hla10
          OTHERWISE
            EXIT CASE
        END CASE

    
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
    ON ACTION about
        CALL cl_about()
    ON ACTION generate_link
        CALL cl_generate_shortcut()
    ON ACTION help
        CALL cl_show_help()
    ON  ACTION controlg
        CALL cl_cmdask()
    ON ACTION qbe_save
        CALL cl_qbe_save()
    ON ACTION qbe_select                          
        CALL cl_qbe_list() RETURNING lc_qbe_sn      
        CALL cl_qbe_display_condition(lc_qbe_sn)    
 
  END CONSTRUCT 
  IF INT_FLAG THEN
         RETURN
      END IF
  LET g_wc=g_wc CLIPPED,cl_get_extra_cond('g_user','g_grup')#整合权限过滤设定
                                                    #若本table 无此栏位
  LET g_sql="SELECT tc_hla01 FROM tc_hla_file"," WHERE ",g_wc CLIPPED," ORDER BY tc_hla01"
  #LET g_wc2="1=1"
  CONSTRUCT g_wc2 ON tc_hlb02,tc_hlb03,tc_hlb04,#屏幕上取单身条件
                     tc_hlb05,tc_hlb06,tc_hlb07
     FROM s_tc_hlb.tc_hlb02,s_tc_hlb.tc_hlb03,
          s_tc_hlb.tc_hlb04,s_tc_hlb.tc_hlb05,s_tc_hlb.tc_hlb06,s_tc_hlb.tc_hlb07

   BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)   
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(tc_hlb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tc_hla07"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_hlb04
                  NEXT FIELD tc_hlb04
              WHEN INFIELD(tc_hlb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tc_hla08"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_hlb05
                  NEXT FIELD tc_hlb05
              WHEN INFIELD(tc_hlb06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tc_hla09"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_hlb06
                  NEXT FIELD tc_hlb05
              WHEN INFIELD(tc_hlb07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tc_hla10"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_hlb07
                  NEXT FIELD tc_hlb07
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
    
         ON ACTION qbe_save                       
            CALL cl_qbe_save()
            
      END CONSTRUCT
  IF INT_FLAG THEN
         RETURN
      END IF
  IF g_wc2=" 1=1" THEN                  # 若单身未输入条件
      LET g_sql = "SELECT  tc_hla01 FROM tc_hla_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_hla01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  tc_hla01 ",
                  "  FROM tc_hla_file, tc_hlb_file ",
                  " WHERE tc_hla01 = tc_hlb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_hla01"
   END IF

  PREPARE t803_prepare FROM g_sql
  DECLARE t803_cs
      SCROLL CURSOR WITH HOLD FOR t803_prepare
  LET g_sql="SELECT COUNT(*) FROM tc_hla_file WHERE ",g_wc CLIPPED
  IF  g_wc2=" 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tc_hla_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tc_hla01) FROM tc_hla_file,tc_hlb_file WHERE ",
                "tc_hla01=tc_hlb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t803_precount FROM g_sql
   DECLARE t803_count CURSOR FOR t803_precount

END FUNCTION

FUNCTION t803_menu()
 WHILE TRUE
      CALL t803_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t803_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t803_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            IF g_tc_hla.tc_hla04 = 'N' THEN
               CALL t803_r()
             END IF 
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t803_u()
            END IF
 
         --WHEN "invalid"
            --IF cl_chk_act_auth() THEN
               --CALL t803_x()
            --END IF
 
         --WHEN "reproduce"
            --IF cl_chk_act_auth() THEN
               --CALL t803_copy()
            --END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t803_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         --WHEN "output"
            --IF cl_chk_act_auth() THEN
               --CALL t803_out()
            --END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_hlb),'','')
            END IF

         --WHEN "allquery"
             --CALL t803_allquery()
             
         WHEN "related_document"                    
            IF cl_chk_act_auth() THEN
              IF g_tc_hla.tc_hla01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_hla01"
                 LET g_doc.value1 = g_tc_hla.tc_hla01
                 CALL cl_doc()
               END IF
            END IF
        
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
             LET g_success = 'Y'
             CALL t803_y_chk()
             SELECT * INTO g_tc_hla.* FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01
             CALL t803_show()
           END IF
               
         --WHEN "undo_confirm"
           --IF cl_chk_act_auth() THEN
             --LET g_success = 'Y'
             --CALL t803_z()
             --SELECT * INTO g_tc_hla.* FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01
             --CALL t803_show()
           --END IF
           
      END CASE
   END WHILE
   
END FUNCTION

FUNCTION t803_bp(p_ud)
   DEFINE  p_ud   LIKE type_file.chr1  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_hlb TO s_tc_hlb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
    BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      --ON ACTION controlp
       --CASE
          --WHEN INFIELD(tc_hlb03)
            --CALL cl_init_qry_var()
            --LET g_qryparam.form = "cq_tc_hlb03"
            --LET g_qryparam.state = "c"
            --LET g_qryparam.default1 = g_tc_hlb[l_ac].tc_hlb03
            --CALL cl_create_qry() RETURNING g_qryparam.multiret
            --DISPLAY g_qryparam.multiret TO tc_hlb03
            --NEXT FIELD tc_hlb03
        --END CASE
        
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
         CALL t803_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t803_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

      ON ACTION jump
         CALL t803_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

 
      ON ACTION next
         CALL t803_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL t803_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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

      --ON ACTION allquery
         --LET g_action_choice="allquery"
         --EXIT DISPLAY
 
   {   ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                    
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  
         END IF
    } 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 

      --ON ACTION undo_confirm
         --LET g_action_choice="undo_confirm"
         --EXIT DISPLAY
         
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
 
      ON ACTION exporttoexcel                             
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                            
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                    
         LET g_action_choice="related_document"          
         EXIT DISPLAY         
         
    
    #    &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   

FUNCTION t803_bp_refresh()
  DISPLAY ARRAY g_tc_hlb TO s_tc_hlb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION


--FUNCTION t803_out()
--END FUNCTION

--FUNCTION t803_allquery()
--END FUNCTION

FUNCTION t803_a()
   DEFINE li_result   LIKE type_file.num5  
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
   DEFINE l_tc_hlb01  LIKE tc_hlb_file.tc_hlb01
   DEFINE l_tc_hla01  LIKE tc_hla_file.tc_hla01
   DEFINE l_year      LIKE type_file.chr30
   DEFINE l_month     LIKE type_file.chr30
   DEFINE l_number    LIKE type_file.chr30
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_hlb.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_hla.* LIKE tc_hla_file.*             #DEFAULT 設定
   LET g_tc_hla01_t = NULL
  # IF g_ydate IS NULL THEN
  #    LET g_tc_hla.tc_hla01 = NULL
  #    LET g_tc_hla.tc_hla04 = g_today
  # ELSE                                          #使用上筆資料值
  #    LET g_tc_hla.tc_hla01 = g_sheet                  #採購詢價單別
  #    LET g_tc_hla.tc_hla04 = g_ydate                  #收貨日期
  # END IF
 
   #預設值及將數值類變數清成零
   LET g_tc_hla_t.* = g_tc_hla.*
   LET g_tc_hla_o.* = g_tc_hla.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_hla.tc_hla02 = g_today
      SELECT gen02 INTO g_tc_hla.tc_hla03 FROM gen_file WHERE gen01 = g_user
      LET g_tc_hla.tc_hla04 = 'N'
                
      CALL t803_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_hla.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',901,0)
         EXIT WHILE
      END IF
 
      --IF cl_null(g_tc_hla.tc_hla01) THEN       # KEY 不可空白
         --CONTINUE WHILE
      --END IF
 

      BEGIN WORK
       LET l_tc_hla01 = 'DHU'
       LET l_year = YEAR(g_today)
       LET l_month = MONTH(g_today)

       LET l_year = l_year[3,4]
       LET l_month = l_month USING '&&' 
    

       LET l_tc_hla01 = 'DHU-' CLIPPED,l_year CLIPPED,l_month CLIPPED
       SELECT MAX(substr(tc_hla01,9,4)) INTO l_number FROM tc_hla_file WHERE substr(tc_hla01,1,8)=l_tc_hla01
       IF cl_null(l_number) THEN
          LET l_number = 0
       ELSE 
          LET l_number = l_number+1
       END IF 
       LET l_number = l_number USING '&&&&'
       LET l_tc_hla01 = l_tc_hla01 CLIPPED,l_number CLIPPED
       LET g_tc_hla.tc_hla01 = l_tc_hla01
       DISPLAY BY NAME g_tc_hla.tc_hla01
 
      INSERT INTO tc_hla_file VALUES (g_tc_hla.*)
 
                        
 
      IF SQLCA.sqlcode THEN                             
         CALL cl_err3("ins","tc_hla_file",g_tc_hla.tc_hla01,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                    
         CALL cl_flow_notify(g_tc_hla.tc_hla01,'I')          
      END IF                                            
 
      SELECT tc_hla01 INTO g_tc_hla.tc_hla01 FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01

      LET g_tc_hla01_t = g_tc_hla.tc_hla01                       #保留舊值
      LET g_tc_hla_t.* = g_tc_hla.*
      LET g_tc_hla_o.* = g_tc_hla.*
      CALL g_tc_hlb.clear()
 
      LET g_rec_b = 0  
      CALL t803_b_askkey()
      CALL t803_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t803_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_hla.tc_hla01 IS NULL THEN
      CALL cl_err('',-40,0)
      RETURN
   END IF
 
   SELECT * INTO g_tc_hla.* FROM tc_hla_file
    WHERE tc_hla01 = g_tc_hla.tc_hla01
 
   IF g_tc_hla.tc_hla04 ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_hla.tc_hla01,'mfg100',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_hla01_t = g_tc_hla.tc_hla01
   
   CALL t803_show()
   CALL t803_b()
   CALL t803_bp_refresh()
 
END FUNCTION



FUNCTION t803_i(p_cmd)

   DEFINE l_pmc05     LIKE pmc_file.pmc05
   DEFINE l_pmc30     LIKE pmc_file.pmc30
   DEFINE l_n         LIKE type_file.num5    
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
   DEFINE li_result   LIKE type_file.num5    
 

  
  CALL cl_set_comp_required("tc_hla07,tc_hla08,tc_hla09,tc_hla10",TRUE)

   DISPLAY BY NAME 
   g_tc_hla.tc_hla01,g_tc_hla.tc_hla02,g_tc_hla.tc_hla03,g_tc_hla.tc_hla04,g_tc_hla.tc_hla05,g_tc_hla.tc_hla06,
   g_tc_hla.tc_hla07,g_tc_hla.tc_hla08,g_tc_hla.tc_hla09,g_tc_hla.tc_hla10,g_tc_hla.tc_hla11

   INPUT BY NAME  g_tc_hla.tc_hla02,g_tc_hla.tc_hla03,g_tc_hla.tc_hla04,g_tc_hla.tc_hla05,
                  g_tc_hla.tc_hla06,g_tc_hla.tc_hla07,g_tc_hla.tc_hla08,
                  g_tc_hla.tc_hla09,g_tc_hla.tc_hla10,g_tc_hla.tc_hla11
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
       #  CALL t803_set_entry(p_cmd)
       #  CALL t803_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_hla01")
         #LET g_tc_hla.tc_hla04 = 'N'
          CALL cl_set_comp_entry("tc_hla04",FALSE)
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_hla07) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tc_hlb04"
               LET g_qryparam.default1 = g_tc_hla.tc_hla07
               CALL cl_create_qry() RETURNING g_tc_hla.tc_hla07
               DISPLAY BY NAME g_tc_hla.tc_hla07
               NEXT FIELD tc_hla07

            WHEN INFIELD (tc_hla08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tc_hlb05"
               LET g_qryparam.default1 = g_tc_hla.tc_hla08
               CALL cl_create_qry() RETURNING g_tc_hla.tc_hla08
               DISPLAY BY NAME g_tc_hla.tc_hla08
               NEXT FIELD tc_hla08

            WHEN INFIELD (tc_hla09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tc_hlb06"
               LET g_qryparam.default1 = g_tc_hla.tc_hla09
               CALL cl_create_qry() RETURNING g_tc_hla.tc_hla09
               DISPLAY BY NAME g_tc_hla.tc_hla09
               NEXT FIELD tc_hla09   

            WHEN INFIELD (tc_hla10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tc_hlb07"
               LET g_qryparam.default1 = g_tc_hla.tc_hla10
               CALL cl_create_qry() RETURNING g_tc_hla.tc_hla10
               DISPLAY BY NAME g_tc_hla.tc_hla10
               NEXT FIELD tc_hla10
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION





FUNCTION t803_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_hlb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t803_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0      INITIALIZE g_tc_hla.* TO NULL
      RETURN
   END IF
 
   OPEN t803_cs                          
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_hla.* TO NULL
   ELSE
      OPEN t803_count
      FETCH t803_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t803_fetch('F')                 
   END IF
 
END FUNCTION
 
FUNCTION t803_fetch(p_flag)

   DEFINE p_flag     LIKE type_file.chr1                  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t803_cs INTO g_tc_hla.tc_hla01
      WHEN 'P' FETCH PREVIOUS t803_cs INTO g_tc_hla.tc_hla01
      WHEN 'F' FETCH FIRST    t803_cs INTO g_tc_hla.tc_hla01
      WHEN 'L' FETCH LAST     t803_cs INTO g_tc_hla.tc_hla01
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
            FETCH ABSOLUTE g_jump t803_cs INTO g_tc_hla.tc_hla01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_hla.tc_hla01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_hla.* TO NULL               
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_tc_hla.* FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_hla_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_tc_hla.* TO NULL
      RETURN
   END IF
 
 
   CALL t803_show()
 
END FUNCTION
 
FUNCTION t803_show()
 
    LET g_tc_hla_t.* = g_tc_hla.*                
    LET g_tc_hla_o.* = g_tc_hla.*                
    DISPLAY BY NAME g_tc_hla.tc_hla01,g_tc_hla.tc_hla02, g_tc_hla.tc_hla03,g_tc_hla.tc_hla04,
                    g_tc_hla.tc_hla05,g_tc_hla.tc_hla06,g_tc_hla.tc_hla07,g_tc_hla.tc_hla08,
                    g_tc_hla.tc_hla09,g_tc_hla.tc_hla10, g_tc_hla.tc_hla11
  
    CALL t803_b_fill(g_wc2)                 #單身
    CALL t803_pic()
    CALL cl_show_fld_cont()                   #No.FUN-55037 hmf
END FUNCTION


FUNCTION t803_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_hla.tc_hla01 IS NULL THEN
      CALL cl_err("",-40,0)
      RETURN
   END IF
 
   SELECT * INTO g_tc_hla.* FROM tc_hla_file
    WHERE tc_hla01=g_tc_hla.tc_hla01
   BEGIN WORK
 
   OPEN t803_cl USING g_tc_hla.tc_hla01
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t803_cl INTO g_tc_hla.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_hla.tc_hla01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t803_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "tc_hla01"         
       LET g_doc.value1 = g_tc_hla.tc_hla01      
       CALL cl_del_doc()                
      DELETE FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01
      DELETE FROM tc_hlb_file WHERE tc_hlb01 = g_tc_hla.tc_hla01
      CLEAR FORM
      CALL g_tc_hlb.clear()
      OPEN t803_count
      #FUN-B5065-add-start--
      IF STATUS THEN
         CLOSE t803_cs
         CLOSE t803_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B5065-add-end--
      FETCH t803_count INTO g_row_count
      #FUN-B5065-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t803_cs
         CLOSE t803_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B5065-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t803_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t803_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A067
         CALL t803_fetch('/')
      END IF
   END IF
 
   CLOSE t803_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_hla.tc_hla01,'D')
END FUNCTION

FUNCTION t803_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_n1            LIKE type_file.num5,        
    l_n2            LIKE type_file.num5,        
    l_n3            LIKE type_file.num5,         
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_misc          LIKE gef_file.gef01,               
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5                 #可刪除否  

DEFINE  l_s      LIKE type_file.chr100 
DEFINE  l_m      LIKE type_file.chr100 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr100 
DEFINE  l_m1     LIKE type_file.chr100 
DEFINE  i1       LIKE type_file.num5
DEFINE l_case    STRING                  #FUN-C2068 add
DEFINE l_case1   STRING                  #FUN-C2068 add
DEFINE l_tc_hlb  RECORD LIKE tc_hlb_file.*
DEFINE l_sel     LIKE type_file.chr1
DEFINE l_num1    LIKE type_file.num5
DEFINE l_sql1    STRING

 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_hla.tc_hla01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tc_hla.* FROM tc_hla_file
     WHERE tc_hla01=g_tc_hla.tc_hla01
 
    --IF g_tc_hla.tc_hla04 ='N' THEN    #檢查資料是否為無效
       --CALL cl_err(g_tc_hla.tc_hla01,'mfg100',0)
       --RETURN
    --END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT '',tc_hlb02,tc_hlb03,tc_hlb04,tc_hlb05,tc_hlb06,tc_hlb07,tc_hlbud02 ",
                       "  FROM tc_hlb_file",
                       "  WHERE tc_hlb01=? AND tc_hlb02=? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t803_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_hlb WITHOUT DEFAULTS FROM s_tc_hlb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW='N',DELETE ROW='N',
                    APPEND ROW='N')
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
          
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           CALL cl_set_comp_entry("tc_hlb01,tc_hlb02,tc_hlb03,tc_hlb04,tc_hlb05,tc_hlb06,tc_hlb07",FALSE)

           BEGIN WORK
 
           OPEN t803_cl USING g_tc_hla.tc_hla01
           IF STATUS THEN
              CALL cl_err("OPEN t803_cl:", STATUS, 1)
              CLOSE t803_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t803_cl INTO g_tc_hla.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_hla.tc_hla01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t803_cl
              ROLLBACK WORK
              RETURN
           END IF
 
            IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              
              LET g_tc_hlb_t.* = g_tc_hlb[l_ac].*  #BACKUP
              LET g_tc_hlb_o.* = g_tc_hlb[l_ac].*  #BACKUP
              #LET g_tc_hlb09_t = g_tc_hlb[l_ac].tc_hlb09   #FUN-91088--add--
              OPEN t803_bcl USING g_tc_hla.tc_hla01,g_tc_hlb_t.tc_hlb02
              IF STATUS THEN
                 CALL cl_err("OPEN t803_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 --FETCH t803_bcl INTO g_tc_hlb[l_ac].*
                 --IF SQLCA.sqlcode THEN
                    --CALL cl_err(g_tc_hlb_t.tc_hlb02,SQLCA.sqlcode,1)
                    --LET l_lock_sw = "Y"
                 --END IF
    
              END IF
           END IF

 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',901,0)
              LET INT_FLAG = 0
              LET g_tc_hlb[l_ac].* = g_tc_hlb_t.*
              CLOSE t803_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_hlb[l_ac].tc_hlb02,-263,1)
              LET g_tc_hlb[l_ac].* = g_tc_hlb_t.*
           ELSE
              SELECT COUNT(*) INTO l_num1 FROM t803_temp 
              WHERE tc_hlb03 = g_tc_hlb[l_ac].tc_hlb03

              IF l_num1 > 0 THEN 
                    UPDATE t803_temp SET sel = 'Y'
                    WHERE tc_hlb01 = g_tc_hla.tc_hla01 AND tc_hlb03 = g_tc_hlb_t.tc_hlb03
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_hlb_file",g_tc_hla.tc_hla01,g_tc_hlb_t.tc_hlb02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                     LET g_tc_hlb[l_ac].* = g_tc_hlb_t.*
                  END IF
              ELSE 
                    UPDATE t803_temp SET sel = 'Y'
                    WHERE tc_hlb01 = g_tc_hla.tc_hla01 AND tc_hlb03 = g_tc_hlb_t.tc_hlb03
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_hlb_file",g_tc_hla.tc_hla01,g_tc_hlb_t.tc_hlb02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                     LET g_tc_hlb[l_ac].* = g_tc_hlb_t.*
                  END IF
              END IF 
         END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',901,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET  g_tc_hlb[l_ac].* = g_tc_hlb_t.*
              #FUN-D3034---add---str---
              ELSE
                 CALL g_tc_hlb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D3034---add---end---
              END IF
              CLOSE t803_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           LET l_ac_t = l_ac        #FUN-D3034 add

        AFTER INPUT 
         LET l_sql1 = "SELECT * FROM t803_temp WHERE sel = 'Y' "
             LET l_cnt = 1
             PREPARE t803_pre_p3 FROM l_sql1
             DECLARE t803_cl_c3 CURSOR WITH HOLD FOR t803_pre_p3
             FOREACH t803_cl_c3 INTO l_tc_hlb.tc_hlb01,l_sel,l_tc_hlb.tc_hlb02,l_tc_hlb.tc_hlb03,
                                     l_tc_hlb.tc_hlb04,l_tc_hlb.tc_hlb05,l_tc_hlb.tc_hlb06,l_tc_hlb.tc_hlb07,
                                     l_tc_hlb.tc_hlbud02
                LET l_tc_hlb.tc_hlb02 = l_cnt
                INSERT INTO tc_hlb_file VALUES(l_tc_hlb.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","tc_hlb_file",g_tc_hla.tc_hla01,g_tc_hlb[l_ac].tc_hlb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
                   ROLLBACK WORK
                   CONTINUE FOREACH
                END IF 
                LET l_cnt = l_cnt + 1
             END FOREACH
                 
         #  CLOSE t803_bcl
         #  COMMIT WORK
 
        --ON ACTION CONTROLO                        #沿用所有欄位
           --IF INFIELD(tc_hlb02) AND l_ac > 1 THEN
              --LET g_tc_hlb[l_ac].* = g_tc_hlb[l_ac-1].*
              --LET g_tc_hlb[l_ac].tc_hlb02 = g_rec_b + 1
              --NEXT FIELD tc_hlb02
           --END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
 
        --ON ACTION controlp
           --CASE
             --WHEN INFIELD(tc_hlb03) 
               --CALL cl_init_qry_var()
               --LET g_qryparam.form ="q_ima01"   
               --LET g_qryparam.default1 = g_tc_hlb[l_ac].tc_hlb03
               --CALL cl_create_qry() RETURNING g_tc_hlb[l_ac].tc_hlb03
               --DISPLAY BY NAME g_tc_hlb[l_ac].tc_hlb03
             #  CALL t803_tc_hlb03('d')
               --NEXT FIELD tc_hlb03
 --
               --OTHERWISE EXIT CASE
            --END CASE
 
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
 
      ON ACTION controls                           #No.FUN-6B032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B032
    END INPUT

 
    CLOSE t803_bcl
    COMMIT WORK
    CALL t803_show()
    CALL t803_delHeader()     #CHI-C3002 add
 
END FUNCTION



FUNCTION t803_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tc_hla_file WHERE tc_hla01 = g_tc_hla.tc_hla01
         INITIALIZE g_tc_hla.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

FUNCTION t803_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE    ima_file.ima02 
DEFINE l_imaacti    LIKE    ima_file.imaacti
 
   LET g_sql = "SELECT 'Y',tc_hlb02,tc_hlb03,tc_hlb04,tc_hlb05,tc_hlb06,tc_hlb07,tc_hlbud02",
               " FROM tc_hlb_file",    #No.FUN-55019
               " WHERE tc_hlb01 ='",g_tc_hla.tc_hla01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_hlb02 "
   DISPLAY g_sql
 
   PREPARE t803_pb FROM g_sql
   DECLARE tc_hlb_cs CURSOR FOR t803_pb
 
   CALL g_tc_hlb.clear()
   LET g_cnt = 1
 
   FOREACH tc_hlb_cs INTO g_tc_hlb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_hlb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION


FUNCTION t803_b_fill_1(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE    ima_file.ima02 
DEFINE l_imaacti  LIKE    ima_file.imaacti
DEFINE l_num1     LIKE    type_file.num5
DEFINE l_tc_hlb01 LIKE    tc_hlb_file.tc_hlb01

  CALL create_t803_temp()
  CALL cl_replace_str(p_wc2,"tc_hlb03","shm01") RETURNING p_wc2
  CALL cl_replace_str(p_wc2,"tc_hlbud02","shm012") RETURNING p_wc2
  
   LET g_sql = " SELECT '','',shm01,'','','','',shm012",
               " FROM shm_file,sfb_file WHERE shm05 = '",g_tc_hla.tc_hla07,"'",
               " AND sfb01 = shm012" 
                  
             
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY shm01 "

 
   PREPARE t803_pb1 FROM g_sql
   DECLARE tc_hlb_cs1 CURSOR FOR t803_pb1
 
   CALL g_tc_hlb.clear()
   LET g_cnt = 1
 
   FOREACH tc_hlb_cs1 INTO g_tc_hlb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      LET l_num1 = 0
      SELECT COUNT(*) INTO l_num1 FROM tc_hlb_file WHERE tc_hlb01 = g_tc_hlb[g_cnt].tc_hlb03
      IF l_num1 > 0  THEN
        LET g_tc_hlb[g_cnt].sel = 'Y'
      ELSE 
        LET g_tc_hlb[g_cnt].sel = 'N'
      END IF 
      LET l_tc_hlb01 = g_tc_hla.tc_hla01
      LET g_tc_hlb[g_cnt].tc_hlb02 = g_cnt
      LET g_tc_hlb[g_cnt].tc_hlb04 = g_tc_hla.tc_hla07
      LET g_tc_hlb[g_cnt].tc_hlb05 = g_tc_hla.tc_hla08
      LET g_tc_hlb[g_cnt].tc_hlb06 = g_tc_hla.tc_hla09
      LET g_tc_hlb[g_cnt].tc_hlb07 = g_tc_hla.tc_hla10
      INSERT INTO t803_temp VALUES(l_tc_hlb01,g_tc_hlb[g_cnt].*)
      LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_hlb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION



FUNCTION t803_y_chk()
   DEFINE  l_n LIKE type_file.num5
   DEFINE  l_sql1,l_sql2 STRING 
   DEFINE  l_tc_hlb RECORD LIKE tc_hlb_file.*
   DEFINE  l_sgm    RECORD LIKE sgm_file.*
   
   LET g_success = 'Y'
   SELECT * INTO g_tc_hla.* FROM tc_hla_file 
   WHERE tc_hla01=g_tc_hla.tc_hla01 

   IF g_tc_hla.tc_hla04='Y' THEN
      CALL cl_err('',9023,0)
      LET g_success='N'
      RETURN
   END IF

  
   IF cl_null(g_tc_hla.tc_hla01) THEN
      CALL cl_err('','9033',0)
      LET g_success = 'N'
      RETURN 
   END IF

   IF NOT cl_confirm('aap-017') THEN 
        RETURN 
   END IF
   
   LET g_tc_hla_t.* = g_tc_hla.*
   BEGIN WORK

   OPEN t803_cl USING g_tc_hla.tc_hla01
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:",STATUS,1)
      CLOSE t803_cl
      RETURN
   END IF

   FETCH t803_cl INTO g_tc_hla.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_hla.tc_hla01,SQLCA.sqlcode,0)
      CLOSE t803_cl
      RETURN  
    END IF

   LET l_sql1 = "SELECT * FROM tc_hlb_file WHERE tc_hlb01 = '",g_tc_hla.tc_hla01,"'"
   PREPARE t803_pre_p4 FROM l_sql1
   DECLARE t803_cl_c4  CURSOR WITH HOLD FOR t803_pre_p4
   FOREACH t803_cl_c4 INTO l_tc_hlb.* 
       CALL t803_sgm(l_tc_hlb.tc_hlb01,l_tc_hlb.tc_hlb03)
   END FOREACH 
   
   UPDATE tc_hla_file SET tc_hla04 = 'Y',tc_hla05 = g_today,tc_hla06 = g_user
             WHERE tc_hla01 = g_tc_hla.tc_hla01

  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
        CALL cl_err3("upd","tc_hla_file",g_tc_hla.tc_hla01,"",SQLCA.sqlcode,"","",0)
        LET g_success = 'N'
  END IF 
  IF g_success = 'N' THEN ROLLBACK WORK END IF 
  IF g_success = 'Y' THEN COMMIT WORK 
  CALL cl_set_act_visible("modify,delete,invalid", FALSE)   #修改、删除、有效/无效都不可做，出现“核”的图片
  END IF
 END FUNCTION



FUNCTION t803_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(200)

    CONSTRUCT g_wc2 ON tc_hlb03,tc_hlbud02
            FROM s_tc_hlb[1].tc_hlb03,s_tc_hlb[1].tc_hlbud02

            BEFORE CONSTRUCT
                CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_hlb03) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="cq_tc_hlb04"
               LET g_qryparam.arg1 = g_tc_hla.tc_hla07
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_hlb03
               NEXT FIELD tc_hlb03


            WHEN INFIELD (tc_hlbud02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="cq_tc_hlb05"
               LET g_qryparam.arg1 = g_tc_hla.tc_hla07
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_hlbud02
               NEXT FIELD tc_hlbud02
            OTHERWISE EXIT CASE
          END CASE

      ON ACTION qbe_select
         CALL cl_qbe_select()
         
      ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t803_b_fill_1(g_wc2)
END FUNCTION

FUNCTION  create_t803_temp()
  DROP TABLE t803_temp 
  CREATE TEMP TABLE t803_temp( 
    tc_hlb01      LIKE tc_hlb_file.tc_hlb01,
    sel           LIKE type_file.chr1,
    tc_hlb02      LIKE tc_hlb_file.tc_hlb02,
    tc_hlb03      LIKE tc_hlb_file.tc_hlb03,
    tc_hlb04      LIKE tc_hlb_file.tc_hlb04,
    tc_hlb05      LIKE tc_hlb_file.tc_hlb05,
    tc_hlb06      LIKE tc_hlb_file.tc_hlb06,
    tc_hlb07      LIKE tc_hlb_file.tc_hlb07,
    tc_hlbud02    LIKE tc_hlb_file.tc_hlbud02)
END FUNCTION 



FUNCTION t803_pic()
    IF g_tc_hla.tc_hla04='Y' THEN 
        LET g_chr='Y' 
    ELSE 
        LET g_chr='N' 
    END IF
    
    CALL cl_set_field_pic(g_tc_hla.tc_hla04,g_chr,"","","","" )
END FUNCTION



FUNCTION t803_sgm(l_tc_hlb01,l_tc_hlb03)
DEFINE
    p_part   LIKE ima_file.ima01,
    l_ecm    RECORD LIKE ecm_file.*, 
    l_sgm    RECORD LIKE sgm_file.*,
    l_tc_hlb RECORD LIKE tc_hlb_file.*,
    l_tc_ceb RECORD LIKE tc_ceb_file.*,
    l_sgm03,l_sgn03 LIKE type_file.num5          #No.FUN-680147 SMALLINT
DEFINE l_sfb08   LIKE sfb_file.sfb08      #FUN-A60095
DEFINE l_shm08   LIKE sfb_file.sfb08      
DEFINE g_runcard   LIKE shm_file.shm01,
       g_wono      LIKE sfb_file.sfb01,
       g_part      LIKE sfb_file.sfb05,
       g_primary   LIKE sfb_file.sfb06,
       g_woq       LIKE sfb_file.sfb08
DEFINE l_sql2      STRING 
DEFINE l_ecm03     LIKE ecm_file.ecm03
DEFINE l_tc_hlb01  LIKE tc_hlb_file.tc_hlb01
DEFINE l_tc_hlb03  LIKE tc_hlb_file.tc_hlb03
DEFINE l_shb06     LIKE shb_file.shb06


   SELECT * INTO l_tc_hlb.* FROM tc_hlb_file WHERE tc_hlb01 = l_tc_hlb01 AND tc_hlb03  = l_tc_hlb03  
   
   SELECT MAX(shb06) INTO l_shb06 FROM shb_file WHERE shb16 = l_tc_hlb.tc_hlb03
   IF cl_null(l_shb06) THEN
      LET l_shb06 = 0
   END IF 
   DELETE FROM sgm_file WHERE sgm01 = l_tc_hlb.tc_hlb03 AND sgm03 > l_shb06

   SELECT sfb01,sfb05,sfb06,sfb08  INTO g_wono,g_part,g_primary,g_woq  FROM sfb_file 
   WHERE sfb01 = l_tc_hlb.tc_hlbud02

   SELECT shm01,sfb08,shm08 INTO g_runcard,l_sfb08,l_shm08 FROM sfb_file,shm_file 
   WHERE shm01=l_tc_hlb.tc_hlbud02 AND shm012=sfb01 

   LET l_sql2 = " SELECT * FROM tc_ceb_file ",
                " WHERE tc_ceb01 = '",g_tc_hla.tc_hla07,"' AND tc_ceb02 = '",g_tc_hla.tc_hla08,"'",
                " AND tc_cebud11 = '",g_tc_hla.tc_hla09,"'",
                " AND tc_ceb03 >'",l_shb06,"'"
   PREPARE t803_pre_p5 FROM l_sql2
   DECLARE t803_cl_c5  CURSOR WITH HOLD FOR t803_pre_p5
   FOREACH t803_cl_c5 INTO  l_tc_ceb.*

      INITIALIZE l_ecm.* TO NULL  
      SELECT * INTO l_ecm.* FROM ecm_file
      WHERE ecm01=g_wono  AND ecm11=g_primary AND ecm03 = l_tc_ceb.tc_ceb03 AND ecmacti='Y'
      ORDER BY ecm012,ecm03  

      IF cl_null(l_ecm.ecm01) THEN
        SELECT MAX(ecm03) INTO l_ecm03  FROM ecm_file
        WHERE ecm01 = g_wono AND ecm11 = g_primary AND ecm03 <= l_tc_ceb.tc_ceb03 AND ecmacti = 'Y'

        SELECT * INTO l_ecm.* FROM ecm_file
        WHERE ecm01=g_wono  AND ecm11=g_primary AND ecm03 = l_ecm03 AND ecmacti='Y'
        ORDER BY ecm012,ecm03  
      END IF
      
       INITIALIZE l_sgm.* TO NULL  
        LET l_sgm.sgm03 = l_tc_ceb.tc_ceb03 
        LET l_sgm.sgm01 = l_tc_hlb.tc_hlb03
        LET l_sgm.sgm02  =  g_wono  
        LET l_sgm.sgm03_par = g_part
        LET l_sgm.sgm014 = l_ecm.ecm014
        LET l_sgm.sgm015 = l_ecm.ecm015
        IF l_sgm.sgm015 IS NULL THEN
           LET l_sgm.sgm015 = ' '
        END IF 

        LET l_sgm.sgm04 = l_tc_ceb.tc_ceb04
        LET l_sgm.sgm05 = l_tc_ceb.tc_ceb07
        LET l_sgm.sgm06 = l_tc_ceb.tc_ceb08

   
        LET l_sgm.sgm07      =  0 LET l_sgm.sgm08      =  0           
        LET l_sgm.sgm09      =  0 LET l_sgm.sgm10      =  0
        
        LET l_sgm.sgm11      =  l_tc_hlb.tc_hlb05    #製程編號
        LET l_sgm.sgm13      =  l_tc_ceb.tc_ceb18    #固定工時(秒)
        LET l_sgm.sgm14      =  l_tc_ceb.tc_ceb19    #標準工時(秒)
        LET l_sgm.sgm15      =  l_tc_ceb.tc_ceb20    #固定機時(秒)
        LET l_sgm.sgm16      =  l_tc_ceb.tc_ceb21    #標準機時(秒)
        LET l_sgm.sgm49      =  l_tc_ceb.tc_ceb38    #製程人力
        SELECT ecd02 INTO l_sgm.sgm45 FROM ecd_file 
        WHERE ecd01 = l_sgm.sgm04
        LET l_sgm.sgm45      =  l_sgm.sgm45          #作業名稱
        LET l_sgm.sgm52      =  l_ecm.ecm52          #SUB 否
        LET l_sgm.sgm53      =  l_tc_ceb.tc_ceb40    #PQC 否
        LET l_sgm.sgm54      =  l_tc_ceb.tc_ceb41    #Check in 否
        LET l_sgm.sgm55      =  l_tc_ceb.tc_ceb42    #Check in Hold 否
        LET l_sgm.sgm56      =  l_tc_ceb.tc_ceb43    #Check Out Hold 否
       #LET l_sgm.sgm57      =  l_ecm.ecm57    #FUN-A60095    
        LET l_sgm.sgm58      =  l_tc_ceb.tc_ceb45       
       #LET l_sgm.sgm59      =  l_ecm.ecm59    #FUN-A60095   
        LET l_sgm.sgm012     =  l_ecm.ecm012   #FUN-A60076
        LET l_sgm.sgm011     =  l_ecm.ecm011   #FUN-A60095
        LET l_sgm.sgm12      =  l_tc_ceb.tc_ceb52     #FUN-A60095
        LET l_sgm.sgm34      =  l_tc_ceb.tc_ceb14    #FUN-A60095
        LET l_sgm.sgm62      =  l_tc_ceb.tc_ceb46    #FUN-A60095
        LET l_sgm.sgm63      =  l_tc_ceb.tc_ceb51     #FUN-A60095
        LET l_sgm.sgm64      =  l_tc_ceb.tc_ceb53    #FUN-A60095
        LET l_sgm.sgm65      =  l_shm08
        LET l_sgm.sgm65      =  s_digqty(l_sgm.sgm65,l_sgm.sgm58)  #FUN-BB0085
        IF cl_null(l_sgm.sgm65) THEN LET l_sgm.sgm65 = 0 END IF #FUN-A60095 
        LET l_sgm.sgm66      =  l_ecm.ecm66    #FUN-A80102
        LET l_sgm.sgm67      =  l_ecm.ecm67    #FUN-A80102
        LET l_sgm.sgm291     =  0           
        LET l_sgm.sgm292     =  0           
    
       IF NOT s_schdat_chk_min_ecm03(g_wono,l_ecm.ecm012,l_ecm.ecm03) THEN #CHECK最初製程否
            LET l_sgm.sgm301 = g_woq * l_sgm.sgm62/l_sgm.sgm63
            LET l_sgm.sgm301 = s_digqty(l_sgm.sgm301,l_sgm.sgm58)   
            LET g_cnt = 3
        ELSE
            LET l_sgm.sgm301     =  0           
        END IF
   
        LET l_sgm.sgm302     =  0    
        LET l_sgm.sgm303     =  0    LET l_sgm.sgm304     =  0    
        LET l_sgm.sgm311     =  0           
        LET l_sgm.sgm312     =  0    LET l_sgm.sgm313     =  0           
        LET l_sgm.sgm314     =  0    LET l_sgm.sgm315     =  0     
        LET l_sgm.sgm316     =  0    LET l_sgm.sgm317     =  0     
        LET l_sgm.sgm321     =  0    LET l_sgm.sgm322     =  0           

        LET l_sgm.sgm50      =  l_ecm.ecm50 
        LET l_sgm.sgm51      =  l_ecm.ecm51
     
        LET l_sgm.sgmacti    =  'Y'           
        LET l_sgm.sgmuser    =  g_user         
        LET l_sgm.sgmgrup    =  g_grup        
        LET l_sgm.sgmmodu    =  ''           
        LET l_sgm.sgmdate    =  g_today      
 
        LET l_sgm.sgmplant =  g_plant   #FUN-980012 add
        LET l_sgm.sgmlegal =  g_legal   #FUN-980012 add

        IF cl_null(l_sgm.sgm012) THEN LET l_sgm.sgm012 = ' ' END IF #FUN-A60095
        IF cl_null(l_sgm.sgm66) THEN LET l_sgm.sgm66='Y' END IF     #TQC-B80022

        LET l_sgm.ta_sgm01 = l_ecm.ta_ecm01
        LET l_sgm.ta_sgm02 = l_ecm.ta_ecm02
        LET l_sgm.ta_sgm03 = l_ecm.ta_ecm03       


        INSERT INTO sgm_file VALUES(l_sgm.*)
         
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tc_hlb_file",l_tc_hlb.tc_hlb03,l_sgm.sgm03,SQLCA.sqlcode,"","",1) #No.FUN-660129
             ROLLBACK WORK
             CONTINUE FOREACH
         END IF 
       END FOREACH 
END FUNCTION