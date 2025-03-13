# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axrq800.4gl
# Descriptions...:客戶開票明細表 
# Date & Author..: FUN-C60033 12/06/11 By minpp
# Modify.........: TQC-D60018 13/06/21 By yangtt 出貨單號/銷退單號(omf11),發票號碼(omf01)添加開窗功能

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
         wc  LIKE type_file.chr1000,
         flag LIKE type_file.chr1,
         more  LIKE type_file.chr1
         END  RECORD
DEFINE    g_omf   DYNAMIC ARRAY OF RECORD
                omf03   LIKE omf_file.omf03,
                omf01   LIKE omf_file.omf01,
                omf10   LIKE omf_file.omf10,
                omf11   LIKE omf_file.omf11,
                omf12   LIKE omf_file.omf12,
                omf13   LIKE omf_file.omf13,
                omf14   LIKE omf_file.omf14,
                omf15   LIKE omf_file.omf15,
                omf16   LIKE omf_file.omf16,
                omf17   LIKE omf_file.omf17,
                omf18   LIKE omf_file.omf18,
                omf07   LIKE omf_file.omf07,
                omf19   LIKE omf_file.omf19,
                omf19x  LIKE omf_file.omf19x,
                omf19t  LIKE omf_file.omf19t
                END RECORD
DEFINE   g_sql           STRING 
DEFINE   g_str           STRING
DEFINE   g_cnt    LIKE type_file.num10 
DEFINE   g_rec_b  LIKE type_file.num10
DEFINE   g_change_lang    LIKE type_file.chr1
MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("axr")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE tm.* TO NULL
   LET tm.wc = ARG_VAL(1) 
   LET g_bgjob  = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)        # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   

   LET tm.flag='N'
   LET tm.more='N'  
   LET g_bgjob  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang

   OPEN WINDOW q800_w AT 5,10
           WITH FORM "axr/42f/axrq800" ATTRIBUTE(STYLE = g_win_style)

      CALL cl_ui_init()

      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL q800_tm()         # Input print condition
         ELSE CALL q800()            # Read data and create out-file
      END IF

      CALL q800_menu()
      CLOSE WINDOW q800_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   
END MAIN 

FUNCTION q800_menu()
   WHILE TRUE
      CALL q800_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q800_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q800_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q800_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omf TO s_omf.* ATTRIBUTE(COUNT=g_rec_b)   
     BEFORE ROW
         CALL cl_show_fld_cont()                  

      ON ACTION query
         LET g_action_choice="query"
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

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION q800_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_n            LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01

   OPEN WINDOW q800_w1 AT p_row,p_col
        WITH FORM "axr/42f/axrr800"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL 
   LET tm.flag= 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.more = 'N'
WHILE TRUE
   DIALOG ATTRIBUTE(unbuffered)
   INPUT BY NAME tm.flag,tm.more ATTRIBUTE(WITHOUT DEFAULTS)
   BEFORE INPUT 
      LET tm.flag='N'
      LET tm.more = 'N'
      DISPLAY tm.flag TO flag
      DISPLAY tm.more TO more
   END INPUT
   CONSTRUCT BY NAME tm.wc ON omf05,omf10,omf11,omf03,omf01
    BEFORE CONSTRUCT
             #CALL cl_qbe_init()
    END CONSTRUCT
       ON ACTION controlp
         CASE
           WHEN INFIELD(omf05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_occ"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO omf05
            NEXT FIELD omf05
           #TQC-D60018---add---str--
           WHEN INFIELD(omf11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_omf11"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO omf11
              NEXT FIELD omf11
           WHEN INFIELD(omf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_omf01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO omf01
              NEXT FIELD omf01
           #TQC-D60018---add---end--
        END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about        
         CALL cl_about()     

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()     

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG

      ON ACTION locale
         LET g_change_lang = TRUE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      END DIALOG
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q800_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM

   END IF
   CALL cl_wait()
   CALL q800()
   ERROR ""
   EXIT WHILE
END WHILE
   CLOSE WINDOW q800_w1     
   IF tm.flag='Y' THEN
      CALL cl_set_comp_visible("omf10,omf11,omf12,omf13,omf14,omf15,omf16,omf17,omf18",TRUE)
   ELSE
      CALL cl_set_comp_visible("omf10,omf11,omf12,omf13,omf14,omf15,omf16,omf17,omf18",FALSE)
   END IF  
   DISPLAY g_rec_b TO FORMONLY.cn2 
END FUNCTION 

 FUNCTION q800()
  
  CALL g_omf.clear()
  LET g_cnt = 1   
  LET g_sql=" SELECT omf03,omf01,omf10,omf11,omf12,omf13,omf14,omf15,omf16,omf17 ,",
             " omf18,omf07,omf19,omf19x,omf19t ",
             " FROM omf_file ",
             " WHERE ",tm.wc CLIPPED
   PREPARE q800_p1  FROM g_sql
   DECLARE q800_cs1 CURSOR FOR q800_p1
   FOREACH q800_cs1 INTO g_omf[g_cnt].* 
      IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF 

   END FOREACH
   CALL g_omf.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION



FUNCTION q800_out()
  DEFINE l_name      LIKE type_file.chr20,
       l_sql       LIKE type_file.chr1000,          # RDSQL STATEMENT     
       l_chr       LIKE type_file.chr1,            
       l_order     ARRAY[5] OF LIKE type_file.chr20,  #排列順序  
       l_i         LIKE type_file.num5,          
       sr          RECORD
                   omf03   LIKE omf_file.omf03,
                   omf01   LIKE omf_file.omf01,
                   omf10   LIKE omf_file.omf10,
                   omf11   LIKE omf_file.omf11,
                   omf12   LIKE omf_file.omf12,
                   omf13   LIKE omf_file.omf13,
                   omf14   LIKE omf_file.omf14,
                   omf15   LIKE omf_file.omf15,
                   omf16   LIKE omf_file.omf16,
                   omf17   LIKE omf_file.omf17,
                   omf18   LIKE omf_file.omf18,
                   omf07   LIKE omf_file.omf07,
                   omf19   LIKE omf_file.omf19,
                   omf19x  LIKE omf_file.omf19x
                   END RECORD  
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       LET l_sql=" SELECT omf03,omf01,omf10,omf11,omf12,omf13,omf14,omf15 ,",
                 " omf16,omf17,omf18,omf07,omf19,omf19x,omf19t ",
                 " FROM omf_file ",       
                 " WHERE " ,tm.wc CLIPPED 
      LET g_str=''
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
      IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'omf05,omf10,omf11,omf03,omf01')
      RETURNING tm.wc
   END IF
   LET g_str=tm.wc,";",tm.flag   
   CALL cl_prt_cs1('axrq800','axrq800',l_sql,g_str)
     
END FUNCTION
#FUN-C60033
