# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: axrr800.4gl
# Descriptions...: 客戶開票明細表 
# Date & Author..: No.FUN-C60033 12/06/11 By minpp
# Modify.........: TQC-D60018 13/06/21 By yangtt 出貨單號/銷退單號(omf11),發票號碼(omf01)添加開窗功能

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
          wc      LIKE type_file.chr1000,
          flag    LIKE type_file.chr1,
          more    LIKE type_file.chr1
          END  RECORD
DEFINE  g_str   STRING 
DEFINE  g_i     LIKE type_file.num10
DEFINE  g_change_lang    LIKE type_file.chr1
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
   LET tm.flag = ARG_VAL(8)
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL r800_tm()         # Input print condition
         ELSE CALL axrr800()            # Read data and create out-file
      END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   
END MAIN           

FUNCTION r800_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd          LIKE type_file.chr1000     
DEFINE li_chk_bookno  LIKE type_file.num5    

LET p_row = 4 LET p_col = 16
   OPEN WINDOW axrr800_w AT p_row,p_col
     WITH FORM "axr/42f/axrr800"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 

     CALL cl_ui_init()
     INITIALIZE tm.* TO NULL
     LET g_pdate = g_today
     LET g_rlang = g_lang
     LET g_bgjob = 'N'
     LET g_copies = '1' 

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
             CALL cl_qbe_init()
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
       LET INT_FLAG = 0
       CLOSE WINDOW axrr800_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axrr800'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axrr800','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,    
                        "'",tm.wc CLIPPED,"'",
                        "'",g_bgjob,"'",
                        "'",g_towhom,"'",
                        "'",g_rlang,"'",
                        "'",g_prtway,"'",
                        "'",g_copies,"'",
                        "'",tm.flag,"'"
            CALL cl_cmdat('axrr800',g_time,l_cmd)
          END IF 
        CLOSE WINDOW axrr800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF    

      CALL cl_wait()
      CALL axrr800()

      ERROR ""
   END WHILE

   CLOSE WINDOW axrr800_w

END FUNCTION  

FUNCTION axrr800()
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
                   omf19x  LIKE omf_file.omf19x,
                   omf19t  LIKE omf_file.omf19t
                   END RECORD  
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       LET l_sql=" SELECT omf03,omf01,omf10,omf11,omf12,omf13,omf14,omf15 ,",
                 " omf16,omf17,omf18,omf07,omf19,omf19x,omf19t ",
                 " FROM omf_file ",       
                 " WHERE ", tm.wc CLIPPED 
      LET g_str=''
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
      IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'omf05,omf10,omf11,omf03,omf01')
      RETURNING tm.wc
   END IF
   LET g_str=tm.wc,";",tm.flag   
   CALL cl_prt_cs1('axrr800','axrr800',l_sql,g_str)
     
END FUNCTION
#FUN-C60033
                         
            
    
