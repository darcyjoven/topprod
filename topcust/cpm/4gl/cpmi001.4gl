# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: cpmi001.4gl
# Descriptions...: 委外申请单
# Date & Author..: 16/06/20  by guanyao
# Modify.........: ly170810 增加PNL  tc_pmmud07及报表打印


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_pmm_1 RECORD
         tc_pmm01  LIKE tc_pmm_file.tc_pmm01,
         tc_pmm02  LIKE tc_pmm_file.tc_pmm02,
         tc_pmm06  LIKE tc_pmm_file.tc_pmm06,
         sgm45     LIKE sgm_file.sgm45,
         tc_pmm11  LIKE tc_pmm_file.tc_pmm11,
    #str---add by huanglf 160726
         tc_pmmud04 LIKE tc_pmm_file.tc_pmmud04,
         tc_pmmud05 LIKE tc_pmm_file.tc_pmmud05
    #end---add by huanglf 160726
         ,tc_pmmud13 LIKE tc_pmm_file.tc_pmmud13   #add by guanyao160826
         END RECORD,
       g_tc_pmm_1_t  RECORD
         tc_pmm01  LIKE tc_pmm_file.tc_pmm01,
         tc_pmm02  LIKE tc_pmm_file.tc_pmm02,
         tc_pmm06  LIKE tc_pmm_file.tc_pmm06,
         sgm45     LIKE sgm_file.sgm45,
         tc_pmm11  LIKE tc_pmm_file.tc_pmm11,
     #str---add by huanglf 160726
         tc_pmmud04 LIKE tc_pmm_file.tc_pmmud04,
         tc_pmmud05 LIKE tc_pmm_file.tc_pmmud05
    # end---add by huanglf 160726
         ,tc_pmmud13 LIKE tc_pmm_file.tc_pmmud13   #add by guanyao160826
                  END RECORD,
       g_tc_pmm    DYNAMIC ARRAY OF RECORD
         tc_pmmud10   LIKE tc_pmm_file.tc_pmmud10,
         tc_pmm03     LIKE tc_pmm_file.tc_pmm03,
         tc_pmm08     LIKE tc_pmm_file.tc_pmm08,
         tc_pmm04     LIKE tc_pmm_file.tc_pmm04,
         tc_pmm05     LIKE tc_pmm_file.tc_pmm05,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_pmm07     LIKE tc_pmm_file.tc_pmm07,
         pmc03         LIKE pmc_file.pmc03,
         tc_pmm09     LIKE tc_pmm_file.tc_pmm09,
         tc_pmm10     LIKE tc_pmm_file.tc_pmm10,
         tc_pmmacti   LIKE tc_pmm_file.tc_pmmacti,
         tc_pmmud01   LIKE tc_pmm_file.tc_pmmud01,
         tc_pmmud02   LIKE tc_pmm_file.tc_pmmud02,
         tc_pmmud03   LIKE tc_pmm_file.tc_pmmud03,
      #   tc_pmmud04   LIKE tc_pmm_file.tc_pmmud04,
      #   tc_pmmud05   LIKE tc_pmm_file.tc_pmmud05,
         tc_pmmud06   LIKE tc_pmm_file.tc_pmmud06,
         tc_pmmud07   LIKE tc_pmm_file.tc_pmmud07,
         tc_pmmud08   LIKE tc_pmm_file.tc_pmmud08,
         tc_pmmud09   LIKE tc_pmm_file.tc_pmmud09,
         tc_pmmud11   LIKE tc_pmm_file.tc_pmmud11,
         tc_pmmud12   LIKE tc_pmm_file.tc_pmmud12,
         #tc_pmmud13   LIKE tc_pmm_file.tc_pmmud13,   #mark by guanyao160826
         tc_pmmud14   LIKE tc_pmm_file.tc_pmmud14,
         tc_pmmud15   LIKE tc_pmm_file.tc_pmmud15
                   END RECORD,
       g_tc_pmm_t  RECORD
         tc_pmmud10   LIKE tc_pmm_file.tc_pmmud10,
         tc_pmm03     LIKE tc_pmm_file.tc_pmm03,
         tc_pmm08     LIKE tc_pmm_file.tc_pmm08,
         tc_pmm04     LIKE tc_pmm_file.tc_pmm04,
         tc_pmm05     LIKE tc_pmm_file.tc_pmm05,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_pmm07     LIKE tc_pmm_file.tc_pmm07,
         pmc03         LIKE pmc_file.pmc03,
         tc_pmm09     LIKE tc_pmm_file.tc_pmm09,
         tc_pmm10     LIKE tc_pmm_file.tc_pmm10,
         tc_pmmacti   LIKE tc_pmm_file.tc_pmmacti,
         tc_pmmud01   LIKE tc_pmm_file.tc_pmmud01,
         tc_pmmud02   LIKE tc_pmm_file.tc_pmmud02,
         tc_pmmud03   LIKE tc_pmm_file.tc_pmmud03,
       #  tc_pmmud04   LIKE tc_pmm_file.tc_pmmud04,
       #  tc_pmmud05   LIKE tc_pmm_file.tc_pmmud05,
         tc_pmmud06   LIKE tc_pmm_file.tc_pmmud06,
         tc_pmmud07   LIKE tc_pmm_file.tc_pmmud07,
         tc_pmmud08   LIKE tc_pmm_file.tc_pmmud08,
         tc_pmmud09   LIKE tc_pmm_file.tc_pmmud09,
         tc_pmmud11   LIKE tc_pmm_file.tc_pmmud11,
         tc_pmmud12   LIKE tc_pmm_file.tc_pmmud12,
         #tc_pmmud13   LIKE tc_pmm_file.tc_pmmud13,   #mark by guanyao160826
         tc_pmmud14   LIKE tc_pmm_file.tc_pmmud14,
         tc_pmmud15   LIKE tc_pmm_file.tc_pmmud15
                  END RECORD,

       g_tc_pmm_2 RECORD LIKE tc_pmm_file.*,

       g_wc        STRING,
       g_wc2       STRING,                       #單身CONSTRUCT結果
       g_rec_b     LIKE type_file.num5,
       l_ac        LIKE type_file.num5,
       l_ac_t      LIKE type_file.num5,
       g_sql       STRING,
       g_sql1      STRING

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                 LIKE azb_file.azbacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE g_multi_tc_pmm03  STRING
DEFINE l_z LIKE type_file.num5
DEFINE l_z_t LIKE type_file.num5
DEFINE g_flag LIKE type_file.chr1
#str---add by huanglf160726
DEFINE l_tc_pmmud02  LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03  LIKE tc_pmm_file.tc_pmmud03
DEFINE g_tc_pmm06_1 LIKE tc_pmm_file.tc_pmm06
#end---add by huanglf160726
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_tc_pmm_1.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_pmm_file WHERE tc_pmm01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
  
   OPEN WINDOW i001_w WITH FORM "cpm/42f/cpmi001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
  
 # CALL cl_set_comp_required("tc_pmm09",FALSE)  #str---add by huanglf160721
   LET l_z = 1
   LET g_action_choice = ""
   CALL i001_menu()

   CLOSE WINDOW i001_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i001_cs()

    CLEAR FORM
    INITIALIZE g_tc_pmm_1.* TO NULL      
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_pmm01,tc_pmm02,tc_pmm06,tc_pmmud04,tc_pmmud05,tc_pmm03,tc_pmm04,tc_pmm05,tc_pmm07,tc_pmm08,tc_pmm09,tc_pmm10,tc_pmmacti,
        tc_pmmud01,tc_pmmud02,tc_pmmud03,tc_pmmud06,tc_pmmud07,tc_pmmud08,tc_pmmud09,
        tc_pmmud10,tc_pmmud11,tc_pmmud12,tc_pmmud13,tc_pmmud14,tc_pmmud15
        FROM tc_pmm01,tc_pmm02,tc_pmm06,tc_pmmud04,tc_pmmud05,
             s_tc_pmm[1].tc_pmm03,s_tc_pmm[1].tc_pmm04,s_tc_pmm[1].tc_pmm05,s_tc_pmm[1].tc_pmm07,
             s_tc_pmm[1].tc_pmm08,s_tc_pmm[1].tc_pmm09,s_tc_pmm[1].tc_pmm10,s_tc_pmm[1].tc_pmmacti,s_tc_pmm[1].tc_pmmud01,
             s_tc_pmm[1].tc_pmmud02,s_tc_pmm[1].tc_pmmud03,
             s_tc_pmm[1].tc_pmmud06,s_tc_pmm[1].tc_pmmud07,s_tc_pmm[1].tc_pmmud08,s_tc_pmm[1].tc_pmmud09,
            # s_tc_pmm[1].tc_pmmud10,s_tc_pmm[1].tc_pmmud11,s_tc_pmm[1].tc_pmmud12,s_tc_pmm[1].tc_pmmud13,  #mark by guanyao160826
             s_tc_pmm[1].tc_pmmud10,s_tc_pmm[1].tc_pmmud11,s_tc_pmm[1].tc_pmmud12,tc_pmmud13,               #add by guanyao160826
             s_tc_pmm[1].tc_pmmud14,s_tc_pmm[1].tc_pmmud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_pmm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_pmm01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_pmm_1.tc_pmm01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_pmm01
                 NEXT FIELD tc_pmm01
              WHEN INFIELD(tc_pmm06)
                 #str-----add by guanyao160803
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_pmm06
                 NEXT FIELD tc_pmm06
                 #end-----add by guanyao160803
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "cq_tc_pmm06"
                 #LET g_qryparam.state = "c"
                 #LET g_qryparam.default1 = g_tc_pmm_1.tc_pmm06
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #DISPLAY g_qryparam.multiret TO tc_pmm06
                 #NEXT FIELD tc_pmm06
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

    LET g_sql="SELECT DISTINCT tc_pmm01,tc_pmm11 FROM tc_pmm_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tc_pmm01"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i001_prepare
    DROP TABLE x

    LET g_sql="SELECT DISTINCT tc_pmm01 FROM tc_pmm_file ",
              " WHERE ",g_wc CLIPPED,
              " INTO TEMP x"
    PREPARE i001_ins_temp_pre FROM g_sql
    EXECUTE i001_ins_temp_pre
    
    LET g_sql=
        "SELECT COUNT(*) FROM x "
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION

FUNCTION i001_menu()

   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i001_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF

        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i001_r()
           END IF

        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i001_u()
           END IF

#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i001_x()
#           END IF

        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i001_copy()
           END IF

        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i001_confirm()
           END IF 

        WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i001_undo_confirm()
           END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF

        WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF

         #str-----add by guanyao160810
         WHEN "ins_issue"
            IF cl_chk_act_auth() THEN
               CALL i001_ins_issue()
            END IF
         #end-----add by guanyao160810
            
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_pmm),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_pmm_1.tc_pmm01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_pmm01"
                 LET g_doc.value1 = g_tc_pmm_1.tc_pmm01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i001_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_pmm TO s_tc_pmm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
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
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION last
         CALL i001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
      
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
         
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

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY 

      #str----add by guanyao160810
      ON ACTION ins_issue
         LET g_action_choice="ins_issue"
         EXIT DISPLAY  
      #end----add by guanyao160810
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i001_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_pmm_1.* TO NULL            #No.FUN-6A0015
    CALL g_tc_pmm.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i001_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_pmm_1.* TO NULL
    ELSE
        CALL i001_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i001_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i001_cs INTO g_tc_pmm_1.tc_pmm01
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_tc_pmm_1.tc_pmm01
        WHEN 'F' FETCH FIRST    i001_cs INTO g_tc_pmm_1.tc_pmm01
        WHEN 'L' FETCH LAST     i001_cs INTO g_tc_pmm_1.tc_pmm01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101

      ON ACTION help          #MOD-4C0101
         CALL cl_show_help()  #MOD-4C0101

      ON ACTION controlg      #MOD-4C0101
         CALL cl_cmdask()     #MOD-4C0101

               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i001_cs INTO g_tc_pmm_1.tc_pmm01
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_pmm_1.* TO NULL  #TQC-6B0105
        LET g_tc_pmm_1.tc_pmm01 = NULL      #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 #No.FUN-4A0089
    END IF

    CALL i001_show()                   # 重新顯示
END FUNCTION

FUNCTION i001_show()
    SELECT tc_pmm01,tc_pmm02,tc_pmm06,sgm45,tc_pmm11,tc_pmmud04,tc_pmmud05,tc_pmmud13
      INTO g_tc_pmm_1.* 
      FROM tc_pmm_file LEFT JOIN sgm_file ON sgm04 = tc_pmm06
     WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01

    LET g_tc_pmm_1_t.* = g_tc_pmm_1.*
    DISPLAY BY NAME g_tc_pmm_1.*
    CALL i001_pic()
    
    CALL i001_b_fill(' 1=1')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i001_a()
DEFINE l_y       LIKE type_file.chr20 
DEFINE l_m       LIKE type_file.chr20
DEFINE l_str       LIKE type_file.chr20
DEFINE l_tmp       LIKE type_file.chr20 

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tc_pmm_1.* TO NULL
    CALL g_tc_pmm.clear()
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE 
        CALL cl_set_comp_entry("tc_pmmud05",FALSE)
        LET g_tc_pmm_1.tc_pmm02 = g_today
        LET g_tc_pmm_1.tc_pmm11 = 'N'
        LET l_z = 1 
        LET l_y =YEAR(g_today)
        LET l_y = l_y[3,4] USING '&&' 
        LET l_m =MONTH(g_today)
        LET l_m = l_m USING '&&' 
        LET l_str='T01-',l_y clipped,l_m CLIPPED
        SELECT max(substr(tc_pmm01,9,12)) INTO l_tmp FROM tc_pmm_file
         WHERE substr(tc_pmm01,1,8)=l_str
        IF cl_null(l_tmp) THEN 
           LET l_tmp = '0001' 
        ELSE 
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&'     
        END IF 
        LET g_tc_pmm_1.tc_pmm01 = l_str clipped,l_tmp
#str---add by huanglf160726
        LET g_tc_pmm_1.tc_pmmud04 = 'N'  
#end---add by huanglf160726        
        LET g_tc_pmm_1.tc_pmmud13 = 'N'    #add by guanyao160826
        CALL i001_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tc_pmm_1.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_pmm_1.tc_pmm01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF 
        LET g_rec_b = 0
        CALL i001_b_fill('1=1')
        CALL i001_b()
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i001_i(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_y           LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5

   DISPLAY BY NAME g_tc_pmm_1.*
   
   INPUT BY NAME
      g_tc_pmm_1.tc_pmm06,g_tc_pmm_1.tc_pmm02,g_tc_pmm_1.tc_pmmud04,g_tc_pmm_1.tc_pmmud05,
      g_tc_pmm_1.tc_pmmud13  #add by guanyao160826
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          --CALL i001_set_entry(p_cmd) #huanglf160722
           --CALL i001_set_no_entry(p_cmd)
           CALL cl_set_comp_required("tc_pmm06",TRUE)
          LET g_before_input_done = TRUE
      
      AFTER FIELD tc_pmm06
        IF NOT cl_null(g_tc_pmm_1.tc_pmm06) THEN 
           IF g_tc_pmm_1_t.tc_pmm06 != g_tc_pmm_1.tc_pmm06 OR
                  g_tc_pmm_1_t.tc_pmm06 IS NULL THEN
              #str-----add by guanyao160803
              SELECT COUNT(*) INTO l_x FROM ecd_file WHERE ecd01 = g_tc_pmm_1.tc_pmm06 AND ecdacti = 'Y'
              IF l_x = 0 OR cl_null(l_x) THEN 
                 CALL cl_err('','cpm-034',0)
                 NEXT FIELD tc_pmm06
              END IF
              #end-----add by guanyao160803
              #str---mark by jixf 160803 8月3号海洋让拿掉此管控
              #SELECT COUNT(*) INTO l_x FROM sgm_file WHERE sgm04 = g_tc_pmm_1.tc_pmm06
              #IF l_x = 0 OR cl_null(l_x) THEN 
              #   CALL cl_err('','cpm-034',0)
              #   NEXT FIELD tc_pmm06
              #END IF 
              #end---mark by jixf 160803
              #SELECT sgm45 INTO g_tc_pmm_1.sgm45 FROM sgm_file WHERE sgm04 = g_tc_pmm_1.tc_pmm06
              #str---add by jixf 160803
              SELECT ecd02 INTO g_tc_pmm_1.sgm45 FROM ecd_file WHERE ecd01=g_tc_pmm_1.tc_pmm06
              #end---add by jixf 160803
              DISPLAY BY NAME g_tc_pmm_1.sgm45
           END IF 
        END IF 
#str---add by huanglf160726
    AFTER FIELD tc_pmmud04
     IF g_tc_pmm_1.tc_pmmud04 = 'Y' THEN 
         CALL cl_set_comp_entry("tc_pmmud05",TRUE)
         CALL cl_set_comp_required("tc_pmmud05",TRUE)
     ELSE 
         CALL cl_set_comp_required("tc_pmmud05",FALSE)
         CALL cl_set_comp_entry("tc_pmmud05",FALSE)
     END IF 
#str---end by huanglf160726
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
          #str-----add by guanyao160803
           WHEN INFIELD(tc_pmm06)
              CALL q_ecd(FALSE,TRUE,g_tc_pmm_1.tc_pmm06)
                RETURNING g_tc_pmm_1.tc_pmm06
              DISPLAY BY NAME g_tc_pmm_1.tc_pmm06    
              NEXT FIELD tc_pmm06
          #str-----add by guanyao160803
          #str-----add by guanyao160803
          #    CALL cl_init_qry_var()
          #    LET g_qryparam.form = "cq_tc_pmm06"
          #    LET g_qryparam.default1 = g_tc_pmm_1.tc_pmm06
          #    CALL cl_create_qry() RETURNING g_tc_pmm_1.tc_pmm06
          #    DISPLAY BY NAME g_tc_pmm_1.tc_pmm06
          #    NEXT FIELD tc_pmm06
          #end-----add by guanyao160803
    #str---add by huanglf160726
           WHEN INFIELD(tc_pmmud05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_pmm06"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_tc_pmm_1.tc_pmmud05
              CALL cl_create_qry() RETURNING g_tc_pmm_1.tc_pmmud05
              DISPLAY BY NAME g_tc_pmm_1.tc_pmmud05
              NEXT FIELD tc_pmmud05
    #end---add by huanglf160726
           OTHERWISE
              EXIT CASE
           END CASE

   ON ACTION CONTROLZ
      CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
            
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
            
      ON ACTION help          #MOD-4C0101
         CALL cl_show_help()  #MOD-4C0101
            
   END INPUT

END FUNCTION

FUNCTION i001_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("tc_pmm01",TRUE) 
    END IF
END FUNCTION

FUNCTION i001_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_pmm01",FALSE) 
   END IF
END FUNCTION

FUNCTION i001_b()
DEFINE
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_n             LIKE type_file.num5,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5
DEFINE l_a           LIKE type_file.num5
DEFINE l_y           LIKE type_file.num5
DEFINE l_n1          LIKE type_file.num5
DEFINE l_sql2        STRING 
DEFINE l_sum         LIKE tc_pmm_file.tc_pmm09
DEFINE l_wip           LIKE type_file.num15_3  #add by guanyao160801
    LET g_action_choice = ""
     CALL cl_set_comp_required("tc_pmm09",TRUE) #str----add by huanglf160722
    IF s_shut(0) THEN
       RETURN
    END IF
    #str--add by huanglf160722
    IF g_tc_pmm_1.tc_pmm01 !=g_tc_pmm_1_t.tc_pmm01 THEN 
       LET l_z = 1
    END IF 
    
    IF g_tc_pmm_1.tc_pmm01 IS NULL THEN
       RETURN
    END IF

     IF g_tc_pmm_1.tc_pmm11 = 'Y' THEN
       
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_pmmud10,tc_pmm03,tc_pmm08,tc_pmm04,tc_pmm05,'','',tc_pmm07,'',tc_pmm09,tc_pmm10,",
                       "       tc_pmmacti,tc_pmmud01,tc_pmmud02,tc_pmmud03,tc_pmmud06,tc_pmmud07,",
                       "       tc_pmmud08,tc_pmmud09,tc_pmmud11,tc_pmmud12,tc_pmmud14,tc_pmmud15",
                       "  FROM tc_pmm_file",
                       "  WHERE tc_pmm01= ? AND tc_pmmud10 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_pmm WITHOUT DEFAULTS FROM s_tc_pmm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

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

           BEGIN WORK

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_pmm_t.* = g_tc_pmm[l_ac].*
              OPEN i001_bcl USING g_tc_pmm_1.tc_pmm01,g_tc_pmm_t.tc_pmmud10
              IF STATUS THEN
                 CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i001_bcl INTO g_tc_pmm[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_pmm_t.tc_pmmud10,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT pmc03 INTO g_tc_pmm[l_ac].pmc03 FROM pmc_file WHERE pmc01= g_tc_pmm[l_ac].tc_pmm07
                 SELECT ima02,ima021 INTO g_tc_pmm[l_ac].ima02,g_tc_pmm[l_ac].ima021
                   FROM ima_file 
                  WHERE ima01  = g_tc_pmm[l_ac].tc_pmm05
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_pmm[l_ac].* TO NULL      #900423
           LET g_tc_pmm[l_ac].tc_pmmacti = 'Y'
           LET g_tc_pmm_t.* = g_tc_pmm[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD tc_pmmud10 

        BEFORE FIELD  tc_pmmud10
           IF g_tc_pmm[l_ac].tc_pmmud10 IS NULL OR g_tc_pmm[l_ac].tc_pmmud10 =0 THEN 
              SELECT max(tc_pmmud10)+1 INTO g_tc_pmm[l_ac].tc_pmmud10 FROM tc_pmm_file 
              WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
                IF g_tc_pmm[l_ac].tc_pmmud10 IS NULL  THEN 
                   LET g_tc_pmm[l_ac].tc_pmmud10 = 1 
                END IF 
            END IF 
            
        #str----add by guanyao160801
        AFTER FIELD tc_pmm09
           IF NOT cl_null(g_tc_pmm[l_ac].tc_pmm09) THEN
              IF g_tc_pmm[l_ac].tc_pmm09 = 0 THEN 
                 CALL cl_err('tc_pmm09','cpm-047',0)
                 NEXT FIELD tc_pmm09 
              END IF  
              IF g_tc_pmm[l_ac].tc_pmm09 < 0 THEN 
                 CALL cl_err('tc_pmm09','axm1154',0)
                 NEXT FIELD tc_pmm09 
              END IF 
              LET l_wip = 0
              #str----mark  by guanyao160824
              #SELECT sgm301+sgm302+sgm303+sgm304-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317 
              #  INTO l_wip
              #  FROM sgm_file 
              # WHERE sgm01 = g_tc_pmm[l_ac].tc_pmm03
              #   AND sgm03 = g_tc_pmm[l_ac].tc_pmm08
              #str----add by guanyao160826
              IF g_tc_pmm_1.tc_pmmud13 = 'Y' THEN 
                 SELECT SUM(shm08) INTO l_wip FROM shm_file WHERE shm01 = g_tc_pmm[l_ac].tc_pmm03
              ELSE 
              #end----add by guanyao160826
             #start --mod ly 180103 简化报工无扫入、扫出
              {
              SELECT SUM(tc_shc12) INTO l_wip FROM tc_shc_file 
               WHERE tc_shc03 = g_tc_pmm[l_ac].tc_pmm03
                 AND tc_shc06 = g_tc_pmm[l_ac].tc_pmm08
                 AND tc_shc01 = '1'
              END IF 
              #end----mark by guanyao160824
               }
              SELECT SUM(tc_shb12) INTO l_wip FROM tc_shb_file
               WHERE tc_shb03 = g_tc_pmm[l_ac].tc_pmm03
                 AND tc_shb06 = g_tc_pmm[l_ac].tc_pmm08
                 AND tc_shb01 = '1'
              END IF

                IF cl_null(l_wip) THEN 
                   LET l_wip = 0
                END IF
                IF g_tc_pmm[l_ac].tc_pmm09 >l_wip THEN 
                   CALL cl_err('tc_pmm09','cpm-049',0)
                   NEXT FIELD tc_pmm09
                END IF 
           END IF 
        #end----add by guanyao160801

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_pmm_file(tc_pmm01,tc_pmm02,tc_pmmud04,tc_pmmud05,tc_pmm03,tc_pmm04,tc_pmm05,tc_pmm06,tc_pmm07,tc_pmm08,tc_pmm09,tc_pmm10,tc_pmm11,
                                   tc_pmmud01,tc_pmmud02,tc_pmmud03,tc_pmmud06,tc_pmmud07,tc_pmmud08,
                                   tc_pmmud09,tc_pmmud10,tc_pmmud11,tc_pmmud12,tc_pmmud13,tc_pmmud14,tc_pmmud15,
                                   tc_pmmacti,tc_pmmdate,tc_pmmgrup,tc_pmmmodu,tc_pmmuser,tc_pmmplant,tc_pmmlegal)
           VALUES(g_tc_pmm_1.tc_pmm01,g_tc_pmm_1.tc_pmm02,g_tc_pmm_1.tc_pmmud04,g_tc_pmm_1.tc_pmmud05,g_tc_pmm[l_ac].tc_pmm03,g_tc_pmm[l_ac].tc_pmm04,
                  g_tc_pmm[l_ac].tc_pmm05,g_tc_pmm_1.tc_pmm06,g_tc_pmm[l_ac].tc_pmm07,g_tc_pmm[l_ac].tc_pmm08,
                  g_tc_pmm[l_ac].tc_pmm09,g_tc_pmm[l_ac].tc_pmm10,g_tc_pmm_1.tc_pmm11,g_tc_pmm[l_ac].tc_pmmud01,
                  g_tc_pmm[l_ac].tc_pmmud02,g_tc_pmm[l_ac].tc_pmmud03,
                  g_tc_pmm[l_ac].tc_pmmud06,g_tc_pmm[l_ac].tc_pmmud07,g_tc_pmm[l_ac].tc_pmmud08,g_tc_pmm[l_ac].tc_pmmud09,
                  g_tc_pmm[l_ac].tc_pmmud10,g_tc_pmm[l_ac].tc_pmmud11,g_tc_pmm[l_ac].tc_pmmud12,g_tc_pmm_1.tc_pmmud13,
                  g_tc_pmm[l_ac].tc_pmmud14,g_tc_pmm[l_ac].tc_pmmud15,'N',g_today,g_grup,'',g_user,g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_pmm_file",g_tc_pmm_1.tc_pmm01,'',SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF
         
        AFTER FIELD tc_pmmud10
           IF NOT cl_null(g_tc_pmm[l_ac].tc_pmmud10) THEN 
              IF g_tc_pmm_t.tc_pmmud10 ! = g_tc_pmm[l_ac].tc_pmmud10 OR 
                 g_tc_pmm_t.tc_pmmud10 IS NULL THEN 
                SELECT count(*) INTO l_a FROM tc_pmm_file 
                 WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01 
                   AND tc_pmmud10 = g_tc_pmm[l_ac].tc_pmmud10
                IF l_a >0 THEN 
                   CALL cl_err('','cpm-011',0)
                   NEXT FIELD tc_pmmud10
                END IF 
             END IF 
          END  IF

        AFTER FIELD tc_pmm03
           IF NOT cl_null(g_tc_pmm[l_ac].tc_pmm03) THEN  
              IF g_tc_pmm[l_ac].tc_pmm03 != g_tc_pmm_t.tc_pmm03 OR
                  g_tc_pmm_t.tc_pmm03 IS NULL THEN
                 IF g_tc_pmm_1.tc_pmmud04 <>'Y' THEN #add by guanyao160824
                    SELECT COUNT(*) INTO l_x FROM sgm_file WHERE sgm04 = g_tc_pmm_1.tc_pmm06 AND sgm01 = g_tc_pmm[l_ac].tc_pmm03
                    IF cl_null(l_x) OR l_x = 0 THEN 
                       CALL cl_err('','cpm-035',0)
                       NEXT FIELD tc_pmm03
                    END IF 
                 ELSE 
                    
                 END IF #add by guanyao160824

                #SELECT COUNT(*) INTO l_y FROM tc_pmm_file WHERE tc_pmm06 = g_tc_pmm_1.tc_pmm06 AND tc_pmm03 = g_tc_pmm[l_ac].tc_pmm03
                # IF l_y > 0 THEN 
                ##    CALL cl_err('','cpm-046',0)
                #    NEXT FIELD tc_pmm03
                # END IF 

                 SELECT sgm03,sgm02,sgm03_par,ima02,ima021,ta_sgm01,ta_sgm02
                   INTO g_tc_pmm[l_ac].tc_pmm08,g_tc_pmm[l_ac].tc_pmm04,g_tc_pmm[l_ac].tc_pmm05 
                       ,g_tc_pmm[l_ac].ima02,g_tc_pmm[l_ac].ima021
                       ,g_tc_pmm[l_ac].tc_pmmud02,g_tc_pmm[l_ac].tc_pmmud03 #add by guanyao160829                      
                   FROM sgm_file LEFT JOIN ima_file ON ima01 =  sgm03_par
                  WHERE sgm04 = g_tc_pmm_1.tc_pmm06 
                  AND sgm01 = g_tc_pmm[l_ac].tc_pmm03
              #ly170810    
         #start mod ly 简化报工180103 
         {  
          SELECT SUM(tc_shc12),SUM(tc_shcud09) INTO g_tc_pmm[l_ac].tc_pmm09 ,g_tc_pmm[l_ac].tc_pmmud07
            FROM tc_shc_file 
               WHERE tc_shc01 = '1' AND tc_shc03 = g_tc_pmm[l_ac].tc_pmm03 
               AND tc_shc08 = g_tc_pmm_1.tc_pmm06
          }

          SELECT SUM(tc_shb12),SUM(tc_shbud09) INTO g_tc_pmm[l_ac].tc_pmm09 ,g_tc_pmm[l_ac].tc_pmmud07
            FROM tc_shb_file
               WHERE tc_shb01 = '1' AND tc_shb03 = g_tc_pmm[l_ac].tc_pmm03
               AND tc_shb08 = g_tc_pmm_1.tc_pmm06

         #end ly180103
            IF cl_null(g_tc_pmm[l_ac].tc_pmm09) THEN LET g_tc_pmm[l_ac].tc_pmm09 = 0 END IF
            IF cl_null(g_tc_pmm[l_ac].tc_pmmud07) THEN LET g_tc_pmm[l_ac].tc_pmmud07 = 0 END IF
            
            SELECT SUM(tc_pmm09) INTO l_sum FROM tc_pmm_file WHERE tc_pmm03=g_tc_pmm[l_ac].tc_pmm03 
                AND tc_pmm06=g_tc_pmm_1.tc_pmm06 AND tc_pmm11 != 'X'
            IF cl_null(l_sum) THEN LET l_sum = 0 END IF
            LET g_tc_pmm[l_ac].tc_pmm09 = g_tc_pmm[l_ac].tc_pmm09 - l_sum
            IF g_tc_pmm[l_ac].tc_pmm09 < 0 THEN LET g_tc_pmm[l_ac].tc_pmm09 = 0 END IF
            IF g_tc_pmm[l_ac].tc_pmm09 = 0 THEN 
               CALL cl_err('','cpm-047',1)
               NEXT FIELD tc_pmm03
            END IF
            #str-----mark by guanyao160829
            #str---add by huanglf160721  #str---add by huanglf160726
            # IF g_tc_pmm_1.tc_pmmud05 IS NOT NULL THEN 
            #    CALL i001_tc_pmm03(g_tc_pmm_1.tc_pmmud05)
            #    LET  g_tc_pmm[l_ac].tc_pmmud02 = l_tc_pmmud02
            #    LET  g_tc_pmm[l_ac].tc_pmmud03 = l_tc_pmmud03
            # ELSE 
            #    SELECT ecbud02,ecbud03 INTO g_tc_pmm[l_ac].tc_pmmud02,g_tc_pmm[l_ac].tc_pmmud03
            #    FROM ecb_file WHERE ecb01 = g_tc_pmm[l_ac].tc_pmm05 AND ecb03 = g_tc_pmm[l_ac].tc_pmm08
            #END IF 
            #end---add by huanglf160721
            #end-----mark by guanyao160829
                 DISPLAY BY NAME g_tc_pmm[l_ac].tc_pmm08,g_tc_pmm[l_ac].tc_pmm04,g_tc_pmm[l_ac].tc_pmm05 
                                ,g_tc_pmm[l_ac].ima02,g_tc_pmm[l_ac].ima021,g_tc_pmm[l_ac].tc_pmmud02,g_tc_pmm[l_ac].tc_pmmud03
                                ,g_tc_pmm[l_ac].tc_pmm09,g_tc_pmm[l_ac].tc_pmmud07
               #str---add by huanglf160721
               #str------mark by guanyao160824
                 #str---add by huanglf160726
                #     CALL i001_tc_pmmud05(g_tc_pmm_1.tc_pmmud05)
                #        LET l_sql2 = "SELECT COUNT(*) FROM sgm_file WHERE " ,g_sql1," AND sgm04 = '",g_tc_pmm_1.tc_pmm06,"'"," AND sgm01 = '",g_tc_pmm[l_ac].tc_pmm03,"'"
                #     PREPARE i001_pre2 FROM l_sql2
                #     EXECUTE i001_pre2 INTO l_n1  
                #         IF l_n1>0 THEN 
                #            MESSAGE '合并的作业编号在该LOT单号中存在！'
                #               NEXT FIELD  tc_pmm03
                #         END IF 
                 #end---add by huanglf160726
                #end------mark by guanyao160824 
                 END IF
           END IF 
        AFTER FIELD tc_pmm07
           IF NOT cl_null(g_tc_pmm[l_ac].tc_pmm07) THEN 
              IF g_tc_pmm[l_ac].tc_pmm07 != g_tc_pmm_t.tc_pmm07 OR
                  g_tc_pmm_t.tc_pmm07 IS NULL THEN
                 SELECT COUNT(*) INTO l_x FROM pmc_file WHERE pmc01= g_tc_pmm[l_ac].tc_pmm07
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err('','cpm-036',0)
                    NEXT FIELD tc_pmm07
                 END IF
                 SELECT pmc03 INTO g_tc_pmm[l_ac].pmc03 FROM pmc_file WHERE pmc01= g_tc_pmm[l_ac].tc_pmm07
                 DISPLAY BY NAME g_tc_pmm[l_ac].pmc03
              END IF 
           END IF 

     #str---add by huanglf 160721
      # AFTER FIELD tc_pmm09

      #            IF g_tc_pmm[l_ac].tc_pmm09 = 0 THEN
      #             MESSAGE '数量需大于0！' 
      #            NEXT FIELD  tc_pmm09
      #            END IF 
              
        
      #end---add  by huanglf 160721 

          
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tc_pmm_t.tc_pmmud10 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_pmm_file
               WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
                 AND tc_pmmud10 = g_tc_pmm_t.tc_pmmud10
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_pmm_file",g_tc_pmm_1.tc_pmm01,'',SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              LET l_z = l_z - 1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tc_pmm[l_ac].* = g_tc_pmm_t.*
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_pmm[l_ac].tc_pmm04,-263,1)
              LET g_tc_pmm[l_ac].* = g_tc_pmm_t.*
           ELSE
              UPDATE tc_pmm_file SET tc_pmmud10 = g_tc_pmm[l_ac].tc_pmmud10,
                                     tc_pmm03=g_tc_pmm[l_ac].tc_pmm03,
                                     tc_pmm08=g_tc_pmm[l_ac].tc_pmm08,
                                     tc_pmm04=g_tc_pmm[l_ac].tc_pmm04,
                                     tc_pmm05=g_tc_pmm[l_ac].tc_pmm05,
                                     tc_pmm07=g_tc_pmm[l_ac].tc_pmm07,
                                     tc_pmm09=g_tc_pmm[l_ac].tc_pmm09,
                                     tc_pmm10=g_tc_pmm[l_ac].tc_pmm10,
                                     tc_pmmud01=g_tc_pmm[l_ac].tc_pmmud01,
                                     tc_pmmud02=g_tc_pmm[l_ac].tc_pmmud02,
                                     tc_pmmud03=g_tc_pmm[l_ac].tc_pmmud03,
                                     #tc_pmmud04=g_tc_pmm[l_ac].tc_pmmud04,
                                     #tc_pmmud05=g_tc_pmm[l_ac].tc_pmmud05,
                                     tc_pmmud06=g_tc_pmm[l_ac].tc_pmmud06,
                                     tc_pmmud07=g_tc_pmm[l_ac].tc_pmmud07,
                                     tc_pmmud08=g_tc_pmm[l_ac].tc_pmmud08,
                                     tc_pmmud09=g_tc_pmm[l_ac].tc_pmmud09,
                                     tc_pmmud11=g_tc_pmm[l_ac].tc_pmmud11,
                                     tc_pmmud12=g_tc_pmm[l_ac].tc_pmmud12,
                                     tc_pmmud14=g_tc_pmm[l_ac].tc_pmmud14,
                                     tc_pmmud15=g_tc_pmm[l_ac].tc_pmmud15
               WHERE tc_pmm01=g_tc_pmm_1.tc_pmm01
                 AND tc_pmmud10 = g_tc_pmm_t.tc_pmmud10
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_pmm_file",g_tc_pmm_1.tc_pmm01,'',SQLCA.sqlcode,"","",1)
                 LET g_tc_pmm[l_ac].* = g_tc_pmm_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_pmm[l_ac].* = g_tc_pmm_t.*
              END IF
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i001_bcl
           COMMIT WORK                
                                  
        ON ACTION CONTROLZ        
           CALL cl_show_req_fields()
                                  
        ON ACTION CONTROLG        
           CALL cl_cmdask()       
                 
        ON ACTION controlp
           CASE
             WHEN INFIELD(tc_pmm03) #廠商編號
               --CALL cl_init_qry_var()
               --LET g_qryparam.form ="cq_tc_pmm03"   #MOD-920024 q_pmc2-->q_pmc1
               --LET g_qryparam.arg1 = g_tc_pmm_1.tc_pmm06
               --LET g_qryparam.default1 = g_tc_pmm[l_ac].tc_pmm03
               --LET g_qryparam.default2 = g_tc_pmm[l_ac].tc_pmm08
               --CALL cl_create_qry() RETURNING g_tc_pmm[l_ac].tc_pmm03,g_tc_pmm[l_ac].tc_pmm08
               --DISPLAY BY NAME g_tc_pmm[l_ac].tc_pmm03,g_tc_pmm[l_ac].tc_pmm08
               --NEXT FIELD tc_pmm03
      #str---add by huanglf160722
             IF g_tc_pmm_1.tc_pmmud05 IS NOT NULL THEN 
                CALL cq_ecd(TRUE,TRUE,g_tc_pmm_1.tc_pmm06,g_tc_pmm_1.tc_pmmud05)
                   RETURNING g_multi_tc_pmm03  
              #CALL cl_init_qry_var()
              #LET g_qryparam.form ="cq_tc_pmm03_1"        #MOD-C60053 add
              #LET g_qryparam.state = 'c'
              #CALL i001_tc_pmmud05(g_tc_pmm_1.tc_pmmud05)
              #LET g_qryparam.where = g_sql1 
              #LET g_qryparam.default1 = g_tc_pmm[l_ac].tc_pmm03 
              #LET g_qryparam.default2 = g_tc_pmm[l_ac].tc_pmm08
              #CALL cl_create_qry() RETURNING g_multi_tc_pmm03
 
             ELSE   
                CALL cl_init_qry_var()
                LET g_qryparam.form ="cq_tc_pmm03"        #MOD-C60053 add
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = g_tc_pmm_1.tc_pmm06  #huanglf
                LET g_qryparam.default1 = g_tc_pmm[l_ac].tc_pmm03 
                LET g_qryparam.default2 = g_tc_pmm[l_ac].tc_pmm08
                CALL cl_create_qry() RETURNING g_multi_tc_pmm03
      END IF 
            IF NOT cl_null(g_multi_tc_pmm03) THEN 
                CALL i001_multi_tc_pmm03(g_multi_tc_pmm03)
                CALL i001_b_fill(" 1=1")
                CALL i001_b()
      #end---add by huanglf160722
                    EXIT INPUT 
            END IF 
            
             WHEN INFIELD(tc_pmm07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.default1 = g_tc_pmm[l_ac].tc_pmm07
               CALL cl_create_qry() RETURNING g_tc_pmm[l_ac].tc_pmm07
               DISPLAY BY NAME g_tc_pmm[l_ac].tc_pmm07
               NEXT FIELD tc_pmm07
           END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
               
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
                 
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
                  
      ON ACTION help          #MOD-4C0101
         CALL cl_show_help()  #MOD-4C0101
                    
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
              
    CLOSE i001_bcl 
    COMMIT WORK  

END FUNCTION

FUNCTION i001_b_fill(p_wc2)
DEFINE p_wc2  STRING
IF cl_null(g_wc) THEN 
LET g_wc = ' 1=1'
END  IF 

   LET g_sql = "SELECT tc_pmmud10,tc_pmm03,tc_pmm08,tc_pmm04,tc_pmm05,'','',tc_pmm07,'',tc_pmm09,tc_pmm10,",
                       "       tc_pmmacti,tc_pmmud01,tc_pmmud02,tc_pmmud03,tc_pmmud06,tc_pmmud07,",
                       "       tc_pmmud08,tc_pmmud09,tc_pmmud11,tc_pmmud12,tc_pmmud14,tc_pmmud15",
               "  FROM tc_pmm_file",
               " WHERE tc_pmm01 = '",g_tc_pmm_1.tc_pmm01,"' ",
               "  AND ", g_wc CLIPPED

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_pmmud10 "
   DISPLAY g_sql

   PREPARE i001_pb FROM g_sql
   DECLARE tc_pmm_cs CURSOR FOR i001_pb

   CALL g_tc_pmm.clear()
   LET g_cnt = 1

   FOREACH tc_pmm_cs INTO g_tc_pmm[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT pmc03 INTO g_tc_pmm[g_cnt].pmc03 FROM pmc_file WHERE pmc01= g_tc_pmm[g_cnt].tc_pmm07
       SELECT ima02,ima021 INTO g_tc_pmm[g_cnt].ima02,g_tc_pmm[g_cnt].ima021
         FROM ima_file 
        WHERE ima01  = g_tc_pmm[g_cnt].tc_pmm05
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_pmm.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i001_copy()
DEFINE      l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE tc_pmm_file.tc_pmm01,
            l_old01   LIKE tc_pmm_file.tc_pmm01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_tc_pmm_1.tc_pmm01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_before_input_done = FALSE
    --CALL i001_set_entry('a')
    LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01 WITHOUT DEFAULTS FROM tc_pmm01  #No.FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     AFTER FIELD tc_pmm02
        
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
     { ON ACTION controlp 
         CASE
              WHEN INFIELD(tc_pmm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_jmb"
                 LET g_qryparam.default1 = l_new01
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY BY NAME l_new01
                 SELECT tc_jmb002 INTO l_tc_jmb002 FROM tc_jmb_file
                    WHERE tc_jmb001=l_new01
                 DISPLAY l_tc_jmb002 TO FORMONLY.tc_pmm01_desc   
                 NEXT FIELD tc_pmm01
             WHEN INFIELD(tc_pmm02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_jmb"
                 LET g_qryparam.default1 = l_new02
                 CALL cl_create_qry() RETURNING l_new02
                 DISPLAY BY NAME l_new02
                 SELECT tc_jmb002 INTO l_tc_jmb002 FROM tc_jmb_file
                    WHERE tc_jmb001=l_new02
                 DISPLAY l_tc_jmb002 TO FORMONLY.tc_pmm02_desc 
                 NEXT FIELD tc_pmm02
                OTHERWISE
                 EXIT CASE
           END CASE}
         
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tc_pmm_1.tc_pmm01 TO tc_pmm01  
      RETURN
   END IF
 
   DROP TABLE x

   SELECT * FROM tc_pmm_file 
     WHERE tc_pmm01=g_tc_pmm_1.tc_pmm01
   INTO TEMP x

 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_tc_pmm_1.tc_pmm01,'',SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET tc_pmm01 = l_new01                  
 
   INSERT INTO tc_pmm_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tc_pmm_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    
      DROP TABLE x
      SELECT * FROM tc_pmm_file 
       WHERE tc_pmm01=g_tc_pmm_1.tc_pmm01 
        INTO TEMP x
      UPDATE x
         SET tc_pmm01 = l_new01                 
      INSERT INTO tc_pmm_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_tc_pmm_1.tc_pmm01
   LET g_tc_pmm_1.tc_pmm01 = l_new01
   CALL i001_u()
   CALL i001_b()
   LET g_tc_pmm_1.tc_pmm01 = l_old01
   CALL i001_show()

END FUNCTION

FUNCTION i001_u()
DEFINE  l_cnt   LIKE type_file.num5     #NO FUN-690009 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   
   IF g_tc_pmm_1.tc_pmm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_tc_pmm_1.tc_pmm11 = 'Y' THEN 
      CALL cl_err('',1208,0)
      RETURN
   END IF 

   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN i001_cl USING g_tc_pmm_1.tc_pmm01         
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i001_cs
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH i001_cl INTO g_tc_pmm_1.tc_pmm01

      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0)  # 資料被他人LOCK
         CLOSE i001_cl ROLLBACK WORK RETURN
      END IF
   END IF
   LET g_tc_pmm_1_t.* = g_tc_pmm_1.* 
   CALL i001_show()
   WHILE TRUE 
      CALL i001_i("u")                                  
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_pmm_1.*=g_tc_pmm_1_t.*
         CALL i001_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE tc_pmm_file SET tc_pmm_file.tc_pmm06 = g_tc_pmm_1.tc_pmm06
                       WHERE tc_pmm_file.tc_pmm01 = g_tc_pmm_1_t.tc_pmm01    
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_pmm_file",g_tc_pmm_1_t.tc_pmm01,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF

      EXIT WHILE
   END WHILE
   CLOSE i001_cl
   COMMIT WORK
   CALL i001_b_fill('1=1')
END FUNCTION

FUNCTION i001_r()
    IF g_tc_pmm_1.tc_pmm01 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF
    

   BEGIN WORK 
   OPEN i001_cl USING g_tc_pmm_1.tc_pmm01
   IF STATUS THEN
      CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0)
      CLOSE i001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i001_cl INTO g_tc_pmm_1.tc_pmm01,g_tc_pmm_1.tc_pmm11
   IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
      CALL cl_err(g_tc_pmm_1.tc_pmm01,SQLCA.sqlcode,0) 
      RETURN 
   END IF
  
    IF g_tc_pmm_1.tc_pmm11  THEN
       CALL cl_err("",'abm-881',2)
      RETURN
    END  IF

   CALL i001_show()

   IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "tc_pmm01"       #FUN-C60033
       LET g_doc.value1 = g_tc_pmm_1.tc_pmm01  #FUN-C60033
       CALL cl_del_doc()       
       DELETE FROM tc_pmm_file WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01  and tc_pmm11<>'Y'  #ly1122
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_pmm_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
        CALL g_tc_pmm.clear()
       MESSAGE ""
       OPEN i001_count #MOD-D60152 add
       FETCH i001_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
    
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i001_fetch('/')
       END IF

    END IF 
   CLOSE i001_cl
   COMMIT WORK
END FUNCTION 

FUNCTION i001_confirm()  
 DEFINE l_sql     STRING 
 DEFINE l_sgm52   LIKE sgm_file.sgm52
 DEFINE l_tc_pmm08  LIKE tc_pmm_file.tc_pmm08
 DEFINE l_tc_pmm09  LIKE tc_pmm_file.tc_pmm09
 DEFINE l_tc_pmm03  LIKE tc_pmm_file.tc_pmm03
 DEFINE l_wip       LIKE type_file.num15_3    #add by guanyao160801
 
   IF g_tc_pmm_1.tc_pmm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   #str---add by huanglf160727
   SELECT DISTINCT tc_pmm01,tc_pmm02,tc_pmm06,
          tc_pmm11,tc_pmmud04,tc_pmmud05,tc_pmmud13
   INTO g_tc_pmm_1.tc_pmm01,g_tc_pmm_1.tc_pmm02,g_tc_pmm_1.tc_pmm06,
        g_tc_pmm_1.tc_pmm11,g_tc_pmm_1.tc_pmmud04,g_tc_pmm_1.tc_pmmud05
        ,g_tc_pmm_1.tc_pmmud13   #add by guanyao160826
   FROM tc_pmm_file WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
   #SELECT tc_pmmud05 INTO g_tc_pmm_1.tc_pmmud05 FROM tc_pmm_file WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
   IF g_tc_pmm_1.tc_pmm11='Y' THEN
      CALL cl_err("",9023,1)
      RETURN
   END IF
   IF cl_confirm('aap-222') THEN
      LET g_success = 'Y'    #FUN-9A0056 add
      BEGIN WORK
      UPDATE tc_pmm_file
         SET tc_pmm11 = 'Y',
             tc_pmmdate = g_today,
             tc_pmmacti = 'Y'  
       WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_pmm_file",g_tc_pmm_1.tc_pmm01,"",SQLCA.sqlcode,"",
                      "tc_pmm11",1)  
         LET g_success = 'N'    
      ELSE
         LET l_sql = " SELECT distinct sgm52,tc_pmm03,tc_pmm08,tc_pmm09 FROM sgm_file,tc_pmm_file ",
                     "  WHERE sgm01 = tc_pmm03 ",
                     "    AND tc_pmm01 = '",g_tc_pmm_1.tc_pmm01,"'",
                     "    AND tc_pmm08 = sgm03"
         PREPARE i001_confirm_pb FROM l_sql
         DECLARE i001_confirm_cs CURSOR FOR i001_confirm_pb
         LET l_sgm52 = ''
         LET l_tc_pmm03 = ''
         LET l_tc_pmm08 = ''
         FOREACH i001_confirm_cs INTO l_sgm52,l_tc_pmm03,l_tc_pmm08,l_tc_pmm09
            IF  l_tc_pmm09 IS NULL OR l_tc_pmm09 = 0 THEN 
             LET g_success = 'N'
               CALL cl_err('','cpm-047',1)
             EXIT FOREACH
            END IF 
            #str----add by guanyao160801
            LET l_wip = 0
            #str----mark by guanyao160824
            #SELECT sgm301+sgm302+sgm303+sgm304-sgm311-sgm312-sgm313-sgm314-sgm316-sgm317
            #  INTO l_wip
            #  FROM sgm_file WHERE sgm01 = l_tc_pmm03
            #   AND sgm03 = l_tc_pmm08
             #str----add by guanyao160826
              IF g_tc_pmm_1.tc_pmmud13 = 'Y' THEN 
                 SELECT SUM(shm08) INTO l_wip FROM shm_file WHERE shm01 = l_tc_pmm03
              ELSE 
              #end----add by guanyao160826
           #mod ly 180103
            {  
           SELECT SUM(tc_shc12) INTO l_wip FROM tc_shc_file 
               WHERE tc_shc03 = l_tc_pmm03
                 AND tc_shc06 = l_tc_pmm08
                 AND tc_shc01 = '1'
            END IF 
            }
            SELECT SUM(tc_shb12) INTO l_wip FROM tc_shb_file
               WHERE tc_shb03 = l_tc_pmm03
                 AND tc_shb06 = l_tc_pmm08
                 AND tc_shb01 = '1'
            END IF

            #end----mark by guanyao160824
            IF cl_null(l_wip) THEN 
               LET l_wip = 0
            END IF 
            IF l_wip< l_tc_pmm09 THEN 
               LET g_success = 'N'
               CALL cl_err('','cpm-049',1)
               EXIT FOREACH
            END IF 
            #str-----mark by guanyao160803
            #IF NOT cl_null(g_tc_pmm_1.tc_pmmud05) THEN 
            #   UPDATE sgm_file SET sgm301 = sgm301 - l_tc_pmm09,sgm321 = sgm321+l_tc_pmm09
            #    WHERE sgm01 = l_tc_pmm03
            #      AND sgm03 = l_tc_pmm08
            #   IF SQLCA.sqlcode THEN
            #      CALL cl_err3("upd","sgm_file",l_tc_pmm03,l_tc_pmm08,SQLCA.sqlcode,"",
            #                   "sgm52",1)  
            #      LET g_success = 'N'
            #      EXIT FOREACH 
            #   END IF 
            #END IF 
            #end----add by guanyao160801
            #end-----mark by guanyao160803
            IF l_sgm52 = 'N' THEN 
               UPDATE sgm_file SET sgm52 = 'Y' 
                WHERE sgm01 = l_tc_pmm03
                  AND sgm03 = l_tc_pmm08
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sgm_file",l_tc_pmm03,l_tc_pmm08,SQLCA.sqlcode,"",
                               "sgm52",1)  
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF 
            END IF 
         END FOREACH 
      END IF
 #str---add by huanglf160721
      IF g_success = 'Y' THEN 
         CALL i001_shm01(g_tc_pmm_1.tc_pmmud05)    
      END IF 
 #end---add by huanglf160721
      IF g_success = 'Y' THEN 
         COMMIT WORK 
      ELSE 
         ROLLBACK WORK
         RETURN 
      END IF 
   END IF 
   
   CALL i001_show()
END FUNCTION 

FUNCTION i001_undo_confirm()

DEFINE l_imaag    LIKE ima_file.imaag    #No.TQC-640171
 DEFINE l_sql     STRING 
 DEFINE l_sgm52   LIKE sgm_file.sgm52
 DEFINE l_ecb39   LIKE ecb_file.ecb39
 DEFINE l_tc_pmm08  LIKE tc_pmm_file.tc_pmm08
 DEFINE l_tc_pmm03  LIKE tc_pmm_file.tc_pmm03
 DEFINE l_tc_pmm11  LIKE tc_pmm_file.tc_pmm11
 DEFINE l_num       LIKE type_file.num5
 DEFINE l_num1      LIKE type_file.num5
 DEFINE l_tc_pmm09  LIKE tc_pmm_file.tc_pmm09   #add by guanyao160801
 DEFINE l_tc_pmm08_1 LIKE tc_pmm_file.tc_pmm08  #add by guanyao160801
 DEFINE l_tc_pmm03_1 LIKE tc_pmm_file.tc_pmm03  #add by guanyao160801

  SELECT tc_pmm01,tc_pmm02,tc_pmm06,
          tc_pmm11,tc_pmmud04,tc_pmmud05
   INTO g_tc_pmm_1.tc_pmm01,g_tc_pmm_1.tc_pmm02,g_tc_pmm_1.tc_pmm06,
        g_tc_pmm_1.tc_pmm11,g_tc_pmm_1.tc_pmmud04,g_tc_pmm_1.tc_pmmud05
   FROM tc_pmm_file WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
   
   IF g_tc_pmm_1.tc_pmm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_tc_pmm_1.tc_pmm11 != 'Y' THEN 
      CALL cl_err('','atm-365',0)
   ELSE
      IF cl_confirm('aap-224') THEN
         LET g_success = 'Y'   
         BEGIN WORK
         UPDATE tc_pmm_file
            SET tc_pmm11 = 'N',
                tc_pmmdate = g_today #str---add by huanglf160824
              #  tc_pmmacti = 'N' 
          WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_pmm_file",g_tc_pmm_1.tc_pmm01,"",SQLCA.sqlcode,"",
                         "tc_pmm11",1)  
            LET g_success = 'N'        
         ELSE
            #str-----mark by guanyao160803
            #str-----add by guanyao160801
            #DECLARE i001_sgm321 CURSOR FOR SELECT tc_pmm03,tc_pmm08,tc_pmm09 FROM tc_pmm_file WHERE tc_pmm01 =  g_tc_pmm_1.tc_pmm01
            #LET l_tc_pmm03_1 = ''
            #LET l_tc_pmm08_1 =''
            #LET l_tc_pmm09 =''
            #FOREACH i001_sgm321 INTO l_tc_pmm03_1,l_tc_pmm08_1,l_tc_pmm09
            #   IF NOT cl_null(g_tc_pmm_1.tc_pmmud05) THEN 
            #      UPDATE sgm_file SET sgm301 = sgm301 + l_tc_pmm09,sgm321 = sgm321-l_tc_pmm09
            #       WHERE sgm01 = l_tc_pmm03_1
            #         AND sgm03 = l_tc_pmm08_1
            #      IF SQLCA.sqlcode THEN
            #         CALL cl_err3("upd","sgm_file",l_tc_pmm03_1,l_tc_pmm08_1,SQLCA.sqlcode,"",
            #                      "sgm52",1)  
            #         LET g_success = 'N'
            #         EXIT FOREACH 
            #      END IF 
            #   END IF 
            #END FOREACH 
               #end-----add by guanyao160801
            #end-----mark by guanyao160803
            LET l_sql = "SELECT DISTINCT sgm52,ecb39,tc_pmm03,tc_pmm08,tc_pmm11,tc_pmud06",
                        "  FROM sgm_file,tc_pmm_file,shm_file,ecb_file ",#str---add by huanglf1607
                        " WHERE tc_pmm03 = sgm01",
                        "   AND tc_pmm08 = sgm03",
                        "   AND shm01 = sgm01",
                        "   AND shm05 = ecb01",
                        "   AND shm06 = ecb02",
                        "   AND sgm03 = ecb03"
            PREPARE i001_undo_confirm_pb FROM l_sql
            DECLARE i001_undo_confirm_cs CURSOR FOR i001_undo_confirm_pb
            LET l_sgm52 = ''
            LET l_ecb39 = ''
            LET l_tc_pmm03 = ''
            LET l_tc_pmm08 = ''
            FOREACH i001_undo_confirm_cs INTO l_sgm52,l_ecb39,l_tc_pmm03,l_tc_pmm08,l_tc_pmm11
               IF l_ecb39 = 'N' THEN 
                  IF  l_sgm52 = 'Y' THEN 
                     SELECT  COUNT(*) INTO l_num FROM tc_pmm_file WHERE tc_pmm03= l_tc_pmm03 and tc_pmm08=l_tc_pmm08 AND tc_pmm11='Y'
                     IF l_num=0 THEN 
                        UPDATE sgm_file SET sgm52 = 'N' 
                         WHERE sgm03 = l_tc_pmm08
                           AND sgm01 = l_tc_pmm03
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","sgm_file",l_tc_pmm03,l_tc_pmm08,SQLCA.sqlcode,"",
                                        "sgm52",1)  
                           LET g_success = 'N'
                           EXIT FOREACH 
                        END IF 
                     END IF 
                  END IF 
               END IF 
            END FOREACH 
         END IF
         #str---add by huanglf160727
         IF g_success ='Y' THEN 
            CALL i001_shm01_1(g_tc_pmm_1.tc_pmmud05)
         END IF 
         #end---add by huanglf160727
        SELECT COUNT(*) INTO l_num1 FROM tc_pmm_file WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01 AND tc_pmmud06 IS NOT NULL 
        IF l_num1>0 THEN
           LET g_success = 'N' 
        END IF 
         IF g_success = 'N' THEN
            ROLLBACK WORK
            RETURN
         ELSE
            COMMIT WORK
         END IF
      END IF
   END IF
   CALL i001_show()
END FUNCTION 

FUNCTION i001_pic()
DEFINE l_chr1      LIKE type_file.chr1    #TQC-C50221 add
DEFINE l_chr2      LIKE type_file.chr1    #CHI-C60033 add


     CALL cl_set_field_pic1(g_tc_pmm_1.tc_pmm11,"","","","","","","")
END FUNCTION 


#str---add by huanglf160721
FUNCTION i001_out()
   DEFINE l_cmd       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2  LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(50)
          l_prog        LIKE zz_file.zz01,
          l_prtway    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 

   IF cl_null(g_tc_pmm_1.tc_pmm01) THEN
     CALL cl_err('','-400',1)
      RETURN
   END IF
LET l_wc='tc_pmm01="',g_tc_pmm_1.tc_pmm01,'"'

 MENU ""
       ON ACTION wx01
          
              LET l_prog='cpmr006' 
              IF NOT cl_null(l_prog) THEN
     
              LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
                    CALL cl_cmdrun(l_cmd)
              END  IF

        ON ACTION wx02
          
              LET l_prog='cpmr007' 
              IF NOT cl_null(l_prog) THEN
     
              LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"

                      CALL cl_cmdrun(l_cmd)
              END  IF  
    
     

       ON ACTION exit
          EXIT MENU

       ON ACTION cancel
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE   #MOD-570244 mars
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    
    
END FUNCTION
#end---add by huanglf160721 


#str---add by huanglf160722
FUNCTION i001_multi_tc_pmm03(p_multi_tc_pmm03)
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmm       RECORD LIKE tc_pmm_file.*
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_ima021  LIKE ima_file.ima021
DEFINE   temptext       STRING
DEFINE l_shm01       LIKE type_file.chr1000
DEFINE   tok         base.StringTokenizer
DEFINE l_slip       LIKE smy_file.smyslip
DEFINE l_cnt        LIKE type_file.num5
DEFINE g_sfb        RECORD LIKE sfb_file.*
DEFINE l_ima55      LIKE ima_file.ima55
DEFINE l_ima906     LIKE ima_file.ima906
DEFINE l_ima907     LIKE ima_file.ima907
DEFINE l_ima153        LIKE ima_file.ima153      #MOD-A80079 add

DEFINE tmp_qty    LIKE sfv_file.sfv09
DEFINE l_over_qty       LIKE sfv_file.sfv09
DEFINE  l_errno  LIKE type_file.chr20,         #No:MOD-780278 add
        l_factor LIKE ima_file.ima31_fac
DEFINE l_x LIKE type_file.num5
DEFINE l_y LIKE type_file.num5
DEFINE l_z_t LIKE type_file.num5
DEFINE l_num1 LIKE type_file.num5
DEFINE l_num2 LIKE type_file.num5
DEFINE l_sql1 STRING 
DEFINE i  LIKE type_file.num5
DEFINE l_n  LIKE type_file.num5
DEFINE l_sum  LIKE tc_pmm_file.tc_pmm09

LET  i = 1
#LET l_z_t = l_z
SELECT MAX(tc_pmmud10) INTO l_z FROM tc_pmm_file WHERE tc_pmm01 =g_tc_pmm_1.tc_pmm01
LET l_z = l_z + 1  # add by huanglf160912
IF cl_null(l_z) OR l_z = 0 THEN 
   LET l_z = 1
END IF  
 CALL cl_set_comp_required("tc_pmm09",TRUE)
LET g_success = 'Y'  
CALL s_showmsg_init()
    LET tok = base.StringTokenizer.create(p_multi_tc_pmm03,"|")
    WHILE tok.hasMoreTokens()
      LET temptext=tok.nextToken()
      #end---add by huanglf160726
      #str----add by guanyao160804
      INITIALIZE l_tc_pmm.* TO NULL
      LET l_shm01 = temptext

  IF g_tc_pmm_1.tc_pmmud04 = 'Y' THEN 
      SELECT sgm01,sgm02,sgm03,sgm03_par,sgm04,ta_sgm01,ta_sgm02
        INTO l_tc_pmm.tc_pmm03,l_tc_pmm.tc_pmm04,l_tc_pmm.tc_pmm08,l_tc_pmm.tc_pmm05,l_tc_pmm.tc_pmm06
            ,l_tc_pmm.tc_pmmud02,l_tc_pmm.tc_pmmud03  #add by guanyao160829
        FROM sgm_file 
       WHERE sgm01||sgm03 = l_shm01    
      #str----mark by guanyao160826
      IF g_tc_pmm_1.tc_pmmud13 = 'Y' THEN 
         SELECT SUM(shm08) INTO l_tc_pmm.tc_pmm09 FROM shm_file,sgm_file
          WHERE shm01=sgm01
            AND sgm01||sgm03 = l_shm01
      ELSE 
      #end----mark by guanyao160826
      #ly 180103
      {
      SELECT SUM(tc_shc12) INTO l_tc_pmm.tc_pmm09 FROM tc_shc_file 
       WHERE tc_shc01 = '1' AND tc_shc03||tc_shc06 = l_shm01
      }
      SELECT SUM(tc_shb12) INTO l_tc_pmm.tc_pmm09 FROM tc_shb_file
       WHERE tc_shb01 = '1' AND tc_shb03||tc_shb06 = l_shm01

      END IF 
  ELSE 
       #str---add by huanglf160824
        SELECT sgm01,sgm02,sgm03,sgm03_par,sgm04,ta_sgm01,ta_sgm02
        INTO l_tc_pmm.tc_pmm03,l_tc_pmm.tc_pmm04,l_tc_pmm.tc_pmm08,l_tc_pmm.tc_pmm05,l_tc_pmm.tc_pmm06
             ,l_tc_pmm.tc_pmmud02,l_tc_pmm.tc_pmmud03  #add by guanyao160829
        FROM sgm_file 
        WHERE sgm01 = l_shm01 AND sgm04 = g_tc_pmm_1.tc_pmm06
       #str----mark by guanyao160826
       IF g_tc_pmm_1.tc_pmmud13 = 'Y' THEN 
         SELECT SUM(shm08) INTO l_tc_pmm.tc_pmm09 FROM shm_file
          WHERE shm01=l_shm01
       ELSE 
       #end----mark by guanyao160826
      #ly 180104
        {  
       SELECT SUM(tc_shc12) INTO l_tc_pmm.tc_pmm09 FROM tc_shc_file 
       WHERE tc_shc01 = '1' AND tc_shc03 = l_shm01 AND tc_shc08 = g_tc_pmm_1.tc_pmm06
       
        }
        SELECT SUM(tc_shb12) INTO l_tc_pmm.tc_pmm09 FROM tc_shb_file
       WHERE tc_shb01 = '1' AND tc_shb03 = l_shm01 AND tc_shb08 = g_tc_pmm_1.tc_pmm06
       END  IF
       SELECT SUM(tc_pmm09) INTO l_sum FROM tc_pmm_file WHERE tc_pmm03=l_shm01 
              AND tc_pmm06=g_tc_pmm_1.tc_pmm06 AND tc_pmm11 != 'X'
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       LET l_tc_pmm.tc_pmm09 = l_tc_pmm.tc_pmm09 - l_sum
       IF (l_sum) < 0 THEN LET l_sum = 0 END IF
   END IF 
   #IF  g_tc_pmm_1.tc_pmmud13='N' THEN       
       #SELECT COUNT(*) INTO l_n FROM tc_shb_file WHERE tc_shb03 = l_shm01 AND tc_shb08 = g_tc_pmm_1.tc_pmm06
       #IF l_n>0 THEN 
       #   LET g_success = 'N'
       #   CALL cl_err('','cpm-051',1)
       #END IF 
   #END IF
     #str----add by guanyao160824
       IF l_tc_pmm.tc_pmm09 = 0 OR cl_null(l_tc_pmm.tc_pmm09) THEN 
          LET g_success = 'N'
          CALL cl_err('','cpm-047',1)
       END IF 
     #end----add by guanyao160824
        
       #str---end by huanglf160824
      #end----add by guanyao160804
      #INITIALIZE l_tc_pmm.* TO NULL
      LET l_tc_pmm.tc_pmmud10 = l_z
      LET l_tc_pmm.tc_pmm01 = g_tc_pmm_1.tc_pmm01
      LET l_tc_pmm.tc_pmm02 = g_tc_pmm_1.tc_pmm02
      LET l_tc_pmm.tc_pmmud04 = g_tc_pmm_1.tc_pmmud04
      LET l_tc_pmm.tc_pmmud05 = g_tc_pmm_1.tc_pmmud05
      LET l_tc_pmm.tc_pmmud13 = g_tc_pmm_1.tc_pmmud13
    #str-----add by guanyao160804
    #IF g_tc_pmm_1.tc_pmmud05 IS NOT NULL THEN 
    #  LET l_tc_pmm.tc_pmm06 = g_tc_pmm06_1
    #ELSE 
    #  LET l_tc_pmm.tc_pmm06 = g_tc_pmm_1.tc_pmm06
    #END IF 
    #end-----add by guanyao160804
      LET l_tc_pmm.tc_pmm11 = g_tc_pmm_1.tc_pmm11
      #LET l_tc_pmm.tc_pmm03 = temptext   #mark by guanyao160804
      LET l_tc_pmm.tc_pmmplant = g_plant
      LET l_tc_pmm.tc_pmmlegal = g_legal
      LET l_tc_pmm.tc_pmmacti = 'Y'
      #LET l_tc_pmm.tc_pmm09 = 0

   #str-----mark by guanyao160804
        #str---add by huanglf160726
   #   CALL i001_tc_pmmud05(g_tc_pmm_1.tc_pmmud05)
   #   LET l_sql1 = "SELECT COUNT(*) FROM sgm_file WHERE ",g_sql1," AND sgm04 = '",g_tc_pmm_1.tc_pmm06,"'"," AND sgm01 = '",l_tc_pmm.tc_pmm03,"'"
   #    PREPARE i001_pre1 FROM l_sql1
   #    EXECUTE i001_pre1 INTO l_num1  
   #    IF l_num1>0 THEN 
   #      #  MESSAGE '合并的作业编号在该LOT单号中存在！'
   #         CALL s_errmsg("tc_pmm03",l_tc_pmm.tc_pmm03,"",'cpm-048',1) 
   #         LET g_success = 'N'
   #       #  RETURN 
   #    END IF 
   # IF g_tc_pmm_1.tc_pmmud05 IS NOT NULL THEN 
   #    CALL i001_tc_pmmud05(g_tc_pmm_1.tc_pmmud05)
   # END IF 
   # 
   #   SELECT COUNT(*) INTO l_x FROM sgm_file 
   #   WHERE sgm04 = l_tc_pmm.tc_pmm06 AND sgm01 = l_tc_pmm.tc_pmm03
   #      IF cl_null(l_x) OR l_x = 0 THEN 
   #          CALL s_errmsg("tc_pmm03",l_tc_pmm.tc_pmm03,"",'cpm-035',1) 
   #          LET g_success = 'N'
   #              END IF 
   #   SELECT COUNT(*) INTO l_y FROM tc_pmm_file 
   #   WHERE tc_pmm06 = l_tc_pmm_1.tc_pmm06 AND tc_pmm03 = l_tc_pmm.tc_pmm03
   #      IF l_y > 0 THEN #huanglf
   #         CALL s_errmsg("tc_pmm03",l_tc_pmm.tc_pmm03,"",'cpm-046',1) 
   #         LET g_success = 'N'
   #      END IF 
   #
   #   SELECT sgm03,sgm02,sgm03_par
   #         INTO l_tc_pmm.tc_pmm08,l_tc_pmm.tc_pmm04,l_tc_pmm.tc_pmm05 
   #   FROM sgm_file 
   #          WHERE sgm04 = l_tc_pmm.tc_pmm06 
   #               AND sgm01 = l_tc_pmm.tc_pmm03
   #         #str---add by huanglf160721
   #         IF g_tc_pmm_1.tc_pmmud05 IS NULL THEN  
   #             SELECT ecbud02,ecbud03 INTO l_tc_pmm.tc_pmmud02,l_tc_pmm.tc_pmmud03
   #             FROM ecb_file WHERE ecb01 = l_tc_pmm.tc_pmm05 AND ecb03 = l_tc_pmm.tc_pmm08
   #         ELSE 
   #end-----mark by guanyao160804
                --SELECT ecbud02,ecbud03 INTO l_tc_pmm.tc_pmmud02,l_tc_pmm.tc_pmmud03
                --FROM ecb_file WHERE ecb01 = l_tc_pmm.tc_pmm05 AND ecb03 = l_tc_pmm.tc_pmm08
                #str-----mark by guanyao160829
                #CALL i001_tc_pmm03_1(g_tc_pmm_1.tc_pmmud05,l_tc_pmm.tc_pmm03)
                #LET l_tc_pmm.tc_pmmud02 = l_tc_pmmud02
                #LET l_tc_pmm.tc_pmmud03 = l_tc_pmmud03
                #end-----mark by guanyao160829
    #        END IF 
            #end---add by huanglf160721
            LET l_tc_pmm.tc_pmm06 = g_tc_pmm_1.tc_pmm06
    #str---add by huanglf160824
     SELECT COUNT(*) INTO l_num2 FROM tc_pmm_file 
     WHERE tc_pmm01 = g_tc_pmm_1.tc_pmm01 AND tc_pmm03 = l_tc_pmm.tc_pmm03 AND tc_pmm08 = l_tc_pmm.tc_pmm08
       IF l_num2>0 THEN 
          LET g_success = 'N'
          CALL cl_err('','cpm-053',0)
          RETURN 
       END IF 
      INSERT INTO tc_pmm_file VALUES(l_tc_pmm.*)
    #str---end by huanglf160824
      IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_pmm_file",l_tc_pmm.tc_pmm03,l_tc_pmm.tc_pmm06,SQLCA.sqlcode,"","ins tc_pmm",1)  #No.FUN-660128
            LET g_success = 'N'
      END IF 
    LET l_z = l_z+1
    END WHILE 
    
IF g_success = 'Y' THEN 
    COMMIT WORK 
ELSE
    ROLLBACK WORK 
    #LET l_z = l_z_t
    CALL s_showmsg()
END IF 
END FUNCTION 
#end---add by huanglf160722


#str---add by huanglf160726
FUNCTION i001_tc_pmmud05(l_tc_pmmud05)
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext1       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT

LET i = 1
LET g_sql1 = ''
    LET tok = base.StringTokenizer.create(l_tc_pmmud05,"|")
    WHILE tok.hasMoreTokens()
    LET temptext1=tok.nextToken()
    IF i = 1 THEN
       LET g_sql1 = "sgm01 in (select sgm01 from sgm_file where sgm04 = '",temptext1,"')",
                    "  AND sgm01 not in (select tc_pmm03 from tc_pmm_file where tc_pmm06 = '",temptext1,"')"  #add by guanyao160729
       LET g_tc_pmm06_1 = temptext1
    ELSE 
      LET g_sql1 = g_sql1," AND sgm01 in (select sgm01 from sgm_file where sgm04 = '",temptext1,"')",
                          "  AND sgm01 not in (select tc_pmm03 from tc_pmm_file where tc_pmm06 = '",temptext1,"')"#add by guanyao160729
    END IF 
    
    LET i = i + 1
   
    END WHILE 
    #LET g_sql1 = g_sql1," AND shm01||shm03 not in (select tc_pmm03||tc_pmm08 from tc_pmm_file)"   #add by guanyao160728
    #LET g_sql1 = g_sql1," AND shm01 not in (select tc_pmm03 from tc_pmm_file)"   #add by guanyao160728
    LET i = 1
END FUNCTION 
#end---add by huanglf160726


#str---add by huanglf160726
FUNCTION i001_tc_pmm03(l_tc_pmmud05)
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext1       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT
--DEFINE l_tc_pmmud02  LIKE tc_pmm_file.tc_pmmud02
--DEFINE l_tc_pmmud03  LIKE tc_pmm_file.tc_pmmud03
DEFINE l_tc_pmmud02_1 LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03_1 LIKE tc_pmm_file.tc_pmmud03
DEFINE l_sgm04_1   LIKE sgm_file.sgm04
LET i = 1

    LET tok = base.StringTokenizer.create(l_tc_pmmud05,"|")
    WHILE tok.hasMoreTokens()
    LET temptext1=tok.nextToken()
    LET l_sgm04_1=temptext1
    IF i = 1 THEN
    SELECT ta_sgm01,ta_sgm02 INTO l_tc_pmmud02_1,l_tc_pmmud03_1 FROM sgm_file WHERE sgm01 = g_tc_pmm[l_ac].tc_pmm03 AND sgm04 = l_sgm04_1 
     LET l_tc_pmmud02 = l_tc_pmmud02_1 
     LET l_tc_pmmud03 = l_tc_pmmud03_1
    ELSE 
      SELECT ta_sgm01,ta_sgm02 INTO l_tc_pmmud02_1,l_tc_pmmud03_1 FROM sgm_file WHERE sgm01 = g_tc_pmm[l_ac].tc_pmm03 AND sgm04 = l_sgm04_1 
     LET l_tc_pmmud02 = l_tc_pmmud02,"/",l_tc_pmmud02_1 
     LET l_tc_pmmud03 = l_tc_pmmud03,"/",l_tc_pmmud03_1
    END IF 
    LET i = i + 1
   
    END WHILE 
    LET i = 1
END FUNCTION 

#end---add by huanglf160726


#str---add by huanglf160726
FUNCTION i001_tc_pmm03_1(l_tc_pmmud05,l_tc_pmm03)
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext1       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT
--DEFINE l_tc_pmmud02  LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmm03  LIKE tc_pmm_file.tc_pmm03
DEFINE l_tc_pmmud02_1 LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03_1 LIKE tc_pmm_file.tc_pmmud03
DEFINE l_tc_pmmud02_2 LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03_2 LIKE tc_pmm_file.tc_pmmud03
DEFINE l_sgm04_1   LIKE sgm_file.sgm04

LET i = 1

    LET tok = base.StringTokenizer.create(l_tc_pmmud05,"|")
    WHILE tok.hasMoreTokens()
    LET temptext1=tok.nextToken()
    LET l_sgm04_1=temptext1
    IF i = 1 THEN
  SELECT ta_sgm01,ta_sgm02 INTO l_tc_pmmud02_1,l_tc_pmmud03_1 FROM sgm_file WHERE sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04_1
     LET l_tc_pmmud02 = l_tc_pmmud02_1 
     LET l_tc_pmmud03 = l_tc_pmmud03_1
    ELSE 
  SELECT ta_sgm01,ta_sgm02 INTO l_tc_pmmud02_1,l_tc_pmmud03_1 FROM sgm_file WHERE sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04_1
     LET l_tc_pmmud02 = l_tc_pmmud02,"/",l_tc_pmmud02_1 
     LET l_tc_pmmud03 = l_tc_pmmud03,"/",l_tc_pmmud03_1
    END IF 
    LET i = i + 1
   
    END WHILE 
    LET i = 1
END FUNCTION 

#end---add by huanglf160726



#str---add by huanglf160726
FUNCTION i001_shm01(l_tc_pmmud05)  #更改asfi310
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext2       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT
DEFINE l_tc_pmmud02_1 LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03_1 LIKE tc_pmm_file.tc_pmmud03
DEFINE l_tc_pmm03 LIKE tc_pmm_file.tc_pmm03
DEFINE l_sql STRING 
DEFINE l_sgm04 LIKE sgm_file.sgm04
DEFINE l_ecd02       LIKE ecd_file.ecd02  #add by guanyao160801
DEFINE l_tc_pmm08    LIKE tc_pmm_file.tc_pmm08
DEFINE l_tc_pmmud10  LIKE tc_pmm_file.tc_pmmud10
DEFINE l_sgm03       LIKE sgm_file.sgm03

     LET g_success = 'Y'  
     LET i = 1
     CALL s_showmsg_init()
     LET l_sql = "SELECT tc_pmm03,tc_pmm08,tc_pmmud10 FROM tc_pmm_file WHERE tc_pmm01 = '",g_tc_pmm_1.tc_pmm01,"'"
     PREPARE pre_pmm FROM l_sql
     DECLARE dec_pmm CURSOR FOR pre_pmm

     FOREACH dec_pmm INTO l_tc_pmm03,l_tc_pmm08,l_tc_pmmud10
     CALL s_showmsg_init()
     LET tok = base.StringTokenizer.create(l_tc_pmmud05,"|")
     WHILE tok.hasMoreTokens()
        LET temptext2 = tok.nextToken()
        LET l_sgm04 = temptext2
        IF i = 1 THEN
           #str-----add by guanyao160801
           LET l_ecd02 = ''
           SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01= g_tc_pmm_1.tc_pmm06
           #end-----add by guanyao160801
           LET l_sgm03 = ''
           SELECT sgm03 INTO l_sgm03 FROM sgm_file WHERE sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04
           INSERT INTO tc_sgm_file_o SELECT * FROM sgm_file WHERE sgm01=l_tc_pmm03 AND sgm04 = l_sgm04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_sgm_file",l_tc_pmm03,l_sgm03,SQLCA.sqlcode,"",
                           "ins tc_sgm_file",1)  
              LET g_success = 'N'
              EXIT WHILE 
           END IF
           UPDATE sgm_file SET ta_sgm02 = l_tc_pmmud02 ,ta_sgm03 = l_tc_pmmud03 , sgm04 = g_tc_pmm_1.tc_pmm06
                               ,sgm52 = 'Y',sgm45 = l_ecd02 
            WHERE sgm01=l_tc_pmm03 AND sgm04 = l_sgm04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","sgm_file",l_tc_pmm03,l_sgm04,SQLCA.sqlcode,"",
                           "sgm52",1)  
              LET g_success = 'N'
              EXIT WHILE 
           END IF
        ELSE 
           INSERT INTO tc_sgm_file_o SELECT * FROM sgm_file WHERE sgm01=l_tc_pmm03 AND sgm04 = l_sgm04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_sgm_file",l_tc_pmm03,l_tc_pmm08,SQLCA.sqlcode,"",
                           "ins tc_sgm_file",1)  
              LET g_success = 'N'
              EXIT WHILE 
           END IF
           DELETE FROM sgm_file WHERE sgm01=l_tc_pmm03 AND sgm04 = l_sgm04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","sgm_file",l_tc_pmm03,l_sgm04,SQLCA.sqlcode,"",
                           "sgm52",1)  
              LET g_success = 'N'
              EXIT WHILE 
           END IF
        END IF 
        LET i = i + 1
    END WHILE 
    LET i = 1
  END FOREACH 

  IF g_success = 'Y' THEN 
    COMMIT WORK 
  ELSE
    ROLLBACK WORK 
    CALL s_showmsg()
  END IF 

END FUNCTION 

#end---add by huanglf160726



#str---add by huanglf160727
FUNCTION i001_shm01_1(l_tc_pmmud05)  #更改asfi310
DEFINE p_multi_tc_pmm03    STRING 
DEFINE l_tc_pmmud05  LIKE tc_pmm_file.tc_pmmud05
DEFINE l_sgm   RECORD LIKE sgm_file.*
DEFINE l_length    LIKE type_file.num5
DEFINE   temptext3       STRING
DEFINE   tok         base.StringTokenizer
DEFINE i             SMALLINT
DEFINE l_tc_pmmud02_1 LIKE tc_pmm_file.tc_pmmud02
DEFINE l_tc_pmmud03_1 LIKE tc_pmm_file.tc_pmmud03
DEFINE l_tc_pmm03 LIKE tc_pmm_file.tc_pmm03
DEFINE l_tc_pmm04 LIKE tc_pmm_file.tc_pmm04
DEFINE l_tc_pmm05 LIKE tc_pmm_file.tc_pmm05
#str----add by guanyao160801
DEFINE l_ecm52    LIKE ecm_file.ecm52
DEFINE l_ecm45    LIKE ecm_file.ecm45
DEFINE l_ecm03    LIKE ecm_file.ecm03
DEFINE l_tc_pmm08 LIKE tc_pmm_file.tc_pmm08
DEFINE l_sgm65    LIKE sgm_file.sgm65 
#end----add by guanyao160801

DEFINE l_sql STRING 
DEFINE l_sgm04 LIKE sgm_file.sgm04
DEFINE l_tc_pmmud10   LIKE tc_pmm_file.tc_pmmud10
LET g_success = 'Y'  
LET i = 1
CALL s_showmsg_init()
  LET l_sql = "SELECT tc_pmm03,tc_pmm04,tc_pmm05,tc_pmm08,tc_pmmud10 FROM tc_pmm_file WHERE tc_pmm01 = '",g_tc_pmm_1.tc_pmm01,"'"
  PREPARE pre_pmm1 FROM l_sql
  DECLARE dec_pmm1 CURSOR FOR pre_pmm1


  FOREACH dec_pmm1 INTO l_tc_pmm03,l_tc_pmm04,l_tc_pmm05,l_tc_pmm08,l_tc_pmmud10
    LET tok = base.StringTokenizer.create(l_tc_pmmud05,"|")
    WHILE tok.hasMoreTokens()
    LET temptext3 = tok.nextToken()
    LET l_sgm04 = temptext3
    LET l_sgm.sgm01 = l_tc_pmm03
    LET l_sgm.sgm02 = l_tc_pmm04
    LET l_sgm.sgm03_par = l_tc_pmm05
    LET l_sgm.sgm012 = ' '
    LET l_sgm.sgmplant = g_plant
    LET l_sgm.sgmlegal = g_legal
    IF i = 1 THEN
        SELECT ta_ecm01,ta_ecm02,ecm45,ecm52,ecm03  
          INTO  l_tc_pmmud02,l_tc_pmmud03,
                l_ecm45,l_ecm52,l_ecm03   #add ecm45 by guanyao160801
        FROM   ecm_file
        WHERE  ecm01=l_tc_pmm04 AND ecm04 = l_sgm04

         #UPDATE sgm_file SET ta_sgm02 = l_tc_pmmud02 ,ta_sgm03 = l_tc_pmmud03 , sgm04 = l_sgm04
         #                    ,sgm45 = l_ecm45,sgm52 =l_ecm52    #add by guanyao160801
         #WHERE sgm01=l_tc_pmm03 AND sgm04 = g_tc_pmm_1.tc_pmm06
         #IF SQLCA.sqlcode THEN
         #   CALL cl_err3("upd","sgm_file",g_tc_pmm_1.tc_pmm06,'',SQLCA.sqlcode,"",
         #                "sgm52",1)  
         #   LET g_success = 'N'
         #   EXIT FOREACH 
         #END IF
         DELETE FROM sgm_file WHERE sgm01=l_tc_pmm03 AND sgm04 = g_tc_pmm_1.tc_pmm06 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("delete","sgm_file",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
         INSERT INTO sgm_file SELECT * FROM tc_sgm_file_o WHERE sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04
         IF SQLCA.sqlcode THEN
            CALL cl_err3("INSERT","sgm_file",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
         DELETE FROM tc_sgm_file_o WHERE sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04
        IF SQLCA.sqlcode THEN
            CALL cl_err3("delete","tc_sgm_file",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 

    
    ELSE  
       INSERT INTO sgm_file SELECT * FROM tc_sgm_file_o WHERE  sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04
       IF SQLCA.sqlcode THEN
            CALL cl_err3("INSERT","sgm_file",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
       {SELECT ecm03,ecm04,ecm45,ecm05,ecm52,ecm321,ecm53,ecm54,ecm67,
               ecm06,ecm13,ecm14,ecm15,ecm16,ecm49,ecm50,ecm51,ecm55,ecm56,
               ecm58,ecm62,ecm63,ecm65,ecm12,ecm34,ecm64,ta_ecm01,ta_ecm02,ta_ecm03
               ,ecm66,ecm11      #add by guanyao160801
        INTO  l_sgm.sgm03,l_sgm.sgm04,l_sgm.sgm45,l_sgm.sgm05,l_sgm.sgm52,l_sgm.sgm321,l_sgm.sgm53,l_sgm.sgm54,l_sgm.sgm67,
              l_sgm.sgm06,l_sgm.sgm13,l_sgm.sgm14,l_sgm.sgm15,l_sgm.sgm16,l_sgm.sgm49,l_sgm.sgm50,l_sgm.sgm51,l_sgm.sgm55,l_sgm.sgm56,
              l_sgm.sgm58,l_sgm.sgm62,l_sgm.sgm63,l_sgm.sgm65,l_sgm.sgm12,l_sgm.sgm34,l_sgm.sgm64,l_sgm.ta_sgm01,l_sgm.ta_sgm02,l_sgm.ta_sgm03
             ,l_sgm.sgm66,l_sgm.sgm11 #add by guanyao160801
        FROM   ecm_file
        WHERE  ecm01=l_tc_pmm04 AND ecm04 = l_sgm04
        #str-----add by guanyao160801
        LET l_sgm.sgm07      =  0 LET l_sgm.sgm08      =  0           
        LET l_sgm.sgm09      =  0 LET l_sgm.sgm10      =  0
        LET l_sgm.sgm291     =  0           
        LET l_sgm.sgm292     =  0 
        LET l_sgm.sgm301     =  0  
        LET l_sgm.sgm302     =  0    
        LET l_sgm.sgm303     =  0    LET l_sgm.sgm304     =  0    
        LET l_sgm.sgm311     =  0           
        LET l_sgm.sgm312     =  0    LET l_sgm.sgm313     =  0           
        LET l_sgm.sgm314     =  0    LET l_sgm.sgm315     =  0     
        LET l_sgm.sgm316     =  0    LET l_sgm.sgm317     =  0     
        LET l_sgm.sgm321     =  0    LET l_sgm.sgm322     =  0
        IF cl_null(l_sgm.sgm66) THEN LET l_sgm.sgm66='Y' END IF   
        LET l_sgm.sgmacti    =  'Y'           
        LET l_sgm.sgmuser    =  g_user         
        LET l_sgm.sgmgrup    =  g_grup        
        LET l_sgm.sgmmodu    =  ''           
        LET l_sgm.sgmdate    =  g_today  
        #LET l_sgm.sgm03 = (l_sgm.sgm03-l_ecm03)+l_tc_pmm08 
        LET l_sgm.sgm65 =l_sgm65
        SELECT tc_sgm02 INTO l_sgm.sgm03 FROM tc_sgm_file WHERE tc_sgm01 = l_sgm.sgm01 AND tc_sgm03 = g_tc_pmm_1.tc_pmm01
           AND tc_sgm04 = l_tc_pmmud10 AND tc_sgm06 = l_sgm04
        INSERT INTO sgm_file VALUES (l_sgm.*) 
        #end-----add by guanyao160801
       #str-----mark by guanyao160801
       # INSERT INTO sgm_file (sgm01,sgm02,sgm03,sgm03_par,sgm04,sgm45,sgm05,sgm52,sgm321,sgm53,sgm54,sgm67,sgm06,
       #                       sgm13,sgm14,sgm15,sgm16,sgm49,sgm50,sgm51,sgm55,sgm56,sgm58,
       #                       sgm62,sgm63,sgm65,sgm12,sgm34,sgm64,ta_sgm01,ta_sgm02,ta_sgm03,sgm012,sgmplant,sgmlegal)
       # VALUES (l_sgm.sgm01,l_sgm.sgm02,l_sgm.sgm03,l_sgm.sgm03_par,l_sgm.sgm04,l_sgm.sgm45,l_sgm.sgm05,l_sgm.sgm52,l_sgm.sgm321,l_sgm.sgm53,l_sgm.sgm54,l_sgm.sgm67,l_sgm.sgm06,
       #         l_sgm.sgm13,l_sgm.sgm14,l_sgm.sgm15,l_sgm.sgm16,l_sgm.sgm49,l_sgm.sgm50,l_sgm.sgm51,l_sgm.sgm55,l_sgm.sgm56,l_sgm.sgm58,
       #         l_sgm.sgm62,l_sgm.sgm63,l_sgm.sgm65,l_sgm.sgm12,l_sgm.sgm34,l_sgm.sgm64,l_sgm.ta_sgm01,l_sgm.ta_sgm02,l_sgm.ta_sgm03,
       #         l_sgm.sgm012,l_sgm.sgmplant,l_sgm.sgmlegal)
       #end-----mark by guanyao160801
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sgm_file",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF }
         DELETE FROM tc_sgm_file_o WHERE  sgm01 = l_tc_pmm03 AND sgm04 = l_sgm04
        IF SQLCA.sqlcode THEN
            CALL cl_err3("delete","tc_sgm_file_o",l_tc_pmm04,l_sgm04,SQLCA.sqlcode,"",
                         "sgm52",1)  
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
      
    END IF 
    
    LET i = i + 1
   
    END WHILE 
    LET i = 1
  END FOREACH 

  IF g_success = 'Y' THEN 
    COMMIT WORK 
  ELSE
    ROLLBACK WORK 
    CALL s_showmsg()
  END IF 

END FUNCTION 

#end---add by huanglf160727
#str-----add by guanyao160810
FUNCTION i001_ins_issue()
DEFINE l_x     LIKE type_file.num5
DEFINE l_cmd   STRING 

    IF cl_null(g_tc_pmm_1.tc_pmm01) THEN
       CALL cl_err('',-400,0)
       RETURN 
    END IF 
    SELECT tc_pmm11 INTO g_tc_pmm_1.tc_pmm11 FROM pmm_file WHERE pmm01= g_pmm.pmm01

    --IF g_tc_pmm_1.tc_pmm11 <>'Y' THEN 
       --CALL cl_err('','csf-006',0)
       --RETURN 
    --END IF 


    LET l_x = ARR_CURR()
    LET l_cmd = ''
    LET l_cmd = "csft001",
                " '3' '",g_tc_pmm_1.tc_pmm01 CLIPPED,"'",
                " ''",
                " '0' " 
    CALL cl_cmdrun_wait(l_cmd)
END FUNCTION 
#end-----add by guanyao160810
