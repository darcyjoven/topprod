# Prog. Version..: '5.30.06-13.04.25(00007)'     #
# Pattern name.... axct324_01_01.4gl
# Descriptions.... 杂项进出分录结转作业(旧值查看)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE
    g_tc_cdl_h         RECORD LIKE tc_cdl_file.*,    #(假單頭)
    g_tc_cdl           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_cdl13            LIKE tc_cdl_file.tc_cdl13,
        tc_cdl06            LIKE tc_cdl_file.tc_cdl06,
        azf03               LIKE azf_file.azf03,
        tc_cdl05            LIKE tc_cdl_file.tc_cdl05,
        gem02               LIKE gem_file.gem02,
        tc_cdl16            LIKE tc_cdl_file.tc_cdl16,   #FUN-D80089 add
        gem02_1             LIKE gem_file.gem02,   #FUN-D80089 add
        tc_cdl07            LIKE tc_cdl_file.tc_cdl07,
        ima02               LIKE ima_file.ima02,  
        tc_cdl08            LIKE tc_cdl_file.tc_cdl08,
        aag02               LIKE aag_file.aag02,
        tc_cdl14            LIKE tc_cdl_file.tc_cdl14,
        tc_cdl15            LIKE tc_cdl_file.tc_cdl15,
        tc_cdl09            LIKE tc_cdl_file.tc_cdl09,
        aag02_2             LIKE aag_file.aag02,
        tc_cdl10            LIKE tc_cdl_file.tc_cdl10
                    END RECORD,
    g_tc_cdl_t         RECORD                 #程式變數 (舊值)
        tc_cdl13            LIKE tc_cdl_file.tc_cdl13,
        tc_cdl06            LIKE tc_cdl_file.tc_cdl06,
        azf03               LIKE azf_file.azf03,
        tc_cdl05            LIKE tc_cdl_file.tc_cdl05,
        gem02               LIKE gem_file.gem02,
        tc_cdl16            LIKE tc_cdl_file.tc_cdl16,   #FUN-D80089 add
        gem02_1             LIKE gem_file.gem02,         #FUN-D80089 add
        tc_cdl07            LIKE tc_cdl_file.tc_cdl07,
        ima02               LIKE ima_file.ima02,  
        tc_cdl08            LIKE tc_cdl_file.tc_cdl08,
        aag02               LIKE aag_file.aag02,
        tc_cdl14            LIKE tc_cdl_file.tc_cdl14,
        tc_cdl15            LIKE tc_cdl_file.tc_cdl15,
        tc_cdl09            LIKE tc_cdl_file.tc_cdl09,
        aag02_2             LIKE aag_file.aag02,
        tc_cdl10            LIKE tc_cdl_file.tc_cdl10
                    END RECORD,
    g_rec_b             LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
    l_ac,l_ac1          LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
DEFINE g_cdi       RECORD LIKE cdi_file.*
DEFINE g_cdi_t     RECORD LIKE cdi_file.* 
 
#主程式開始
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_str           STRING     #No.FUN-670060
DEFINE  g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72) 
DEFINE  g_row_count     LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_jump          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT                                                                
DEFINE  g_wc,g_sql      string 
DEFINE  g_wc2           STRING                 #No.FUN-D60073 add
DEFINE  g_b_flag        LIKE type_file.chr1 
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_tc_cdl10_tot     LIKE tc_cdl_file.tc_cdl10    #No.FUN-D60073 add
DEFINE  g_wc1               STRING    #FUN-D60095  add

MAIN
DEFINE l_time           LIKE type_file.chr8           
DEFINE p_row,p_col      LIKE type_file.num5  
DEFINE l_tc_cdl01       LIKE tc_cdl_file.tc_cdl01
DEFINE l_tc_cdl02       LIKE tc_cdl_file.tc_cdl02
DEFINE l_tc_cdl03       LIKE tc_cdl_file.tc_cdl03
DEFINE l_tc_cdl04       LIKE tc_cdl_file.tc_cdl04

   OPTIONS                              
      INPUT NO WRAP                    
   DEFER INTERRUPT                    

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   #FUN-D60095--add--str--
   LET l_tc_cdl01 = ARG_VAL(1)
   LET l_tc_cdl02 = ARG_VAL(2)
   LET l_tc_cdl03 = ARG_VAL(3)
   LET l_tc_cdl04 = ARG_VAL(4)
   LET g_wc1 = " tc_cdl01 = '",l_tc_cdl01 CLIPPED,"'",
	             " AND tc_cdl02 = '",l_tc_cdl02 CLIPPED,"'",
	             " AND tc_cdl03 = '",l_tc_cdl03 CLIPPED,"'",
	             " AND tc_cdl04 = '",l_tc_cdl04 CLIPPED,"'"
   #FUN-D60095--add--end--

   LET g_forupd_sql = "SELECT * FROM tc_cdl_file WHERE tc_cdl01 = ? AND tc_cdl02 = ? AND tc_cdl03 = ? AND tc_cdl04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t324_01_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t324_01_w AT p_row,p_col WITH FORM "axc/42f/axct324_01"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
#No.FUN-CC0153 --begin
   CALL cl_set_comp_visible("tc_cdl14,tc_cdl15",g_aza.aza08 = 'Y')
#No.FJN-CC0153 --end

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t324_01_q()
   END IF
   #FUN-D60095--add--end--

   CALL t324_01_menu()
   CLOSE WINDOW t324_01_w               

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

#QBE 查詢資料
FUNCTION t324_01_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_cdl.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_tc_cdl_h.* TO NULL     
      IF cl_null(g_wc1) THEN  #FUN-D60095 add
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON tc_cdl04,tc_cdl01,tc_cdllegal,tc_cdl02,tc_cdl03,tc_cdl11
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
         END CONSTRUCT  

         #FUN-D60073--add--str--
         CONSTRUCT g_wc2 ON tc_cdl13,tc_cdl06,tc_cdl05,tc_cdl16,tc_cdl07,tc_cdl08,  #FUN-D80089 add tc_cdl16
                            tc_cdl14,tc_cdl15,tc_cdl09,tc_cdl10
              FROM s_tc_cdl[1].tc_cdl13,s_tc_cdl[1].tc_cdl06,s_tc_cdl[1].tc_cdl05,
                   s_tc_cdl[1].tc_cdl16,                                 #FUN-D80089 add
                   s_tc_cdl[1].tc_cdl07,s_tc_cdl[1].tc_cdl08,s_tc_cdl[1].tc_cdl14,
                   s_tc_cdl[1].tc_cdl15,s_tc_cdl[1].tc_cdl09,s_tc_cdl[1].tc_cdl10
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         END CONSTRUCT
         #FUN-D60073--add--end--

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tc_cdl01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl01
                  NEXT FIELD tc_cdl01

               #FUN-D60073--add--str--
               WHEN INFIELD(tc_cdl13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_tc_cdl13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl13
                  NEXT FIELD tc_cdl13

               WHEN INFIELD(tc_cdl06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.arg1  = "2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl06
                  NEXT FIELD tc_cdl06

               WHEN INFIELD(tc_cdl05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl05
                  NEXT FIELD tc_cdl05
   
               #FUN-D80089--add--str--
               WHEN INFIELD(tc_cdl16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl16
                  NEXT FIELD tc_cdl16
               #FUN-D80089--add--end--

               WHEN INFIELD(tc_cdl07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_tlf"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl07
                  NEXT FIELD tc_cdl07

               WHEN INFIELD(tc_cdl08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl08
                  NEXT FIELD tc_cdl08

               WHEN INFIELD(tc_cdl09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl09
                  NEXT FIELD tc_cdl09

               WHEN INFIELD(tc_cdl14)      #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pja2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl14
                  NEXT FIELD tc_cdl14

               WHEN INFIELD(tc_cdl15)      #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pjb4"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_cdl15
                  NEXT FIELD tc_cdl15
               #FUN-D60073--add--end--

               OTHERWISE EXIT CASE
            END CASE
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
          


         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION accept
               EXIT DIALOG
         
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG 
          
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG 
      END DIALOG  
     END IF    #FUN-D60095 add
   IF cl_null(g_wc) THEN
      LET g_wc =' 1=1' 
   END IF  

   IF cl_null(g_wc2) THEN LET g_wc2 =' 1=1' END IF  #FUN-D60073 add
 
   #FUN-D60095--add--str--
   IF cl_null(g_wc1) THEN
      LET g_wc1 = '1=1'
   END IF
   #FUN-D60095--add--end--

   LET g_sql = "SELECT UNIQUE tc_cdl01,tc_cdl02,tc_cdl03,tc_cdl04 ",
               "  FROM tc_cdl_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND ", g_wc1 CLIPPED,    #FUN-D60095 add
               " ORDER BY 1,2,3,4"

 
   PREPARE t324_01_prepare FROM g_sql
   DECLARE t324_01_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t324_01_prepare
 
END FUNCTION

FUNCTION t324_01_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t324_01_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t324_01_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_cdl),'','')
            END IF

#         WHEN "drill_down1"
#            IF cl_chk_act_auth() THEN
#               CALL t324_01_drill_down()
#            END IF

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t324_01_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_cdl_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_cdl.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t324_01_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t324_01_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_cdl_h.* TO NULL
   ELSE
      CALL t324_01_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t324_01_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t324_01_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t324_01_cs INTO g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04
      WHEN 'P' FETCH PREVIOUS t324_01_cs INTO g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04
      WHEN 'F' FETCH FIRST    t324_01_cs INTO g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04
      WHEN 'L' FETCH LAST     t324_01_cs INTO g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,'. ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
 
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
 
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t324_01_cs INTO g_tc_cdl_h.tc_cdl01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_cdl_h.tc_cdl01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_cdl_h.* TO NULL  #TQC-6B0105
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
   SELECT  DISTINCT tc_cdl01,tc_cdl02,tc_cdl03,tc_cdl04,tc_cdl11,tc_cdllegal,tc_cdlconf INTO g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04,g_tc_cdl_h.tc_cdl11,g_tc_cdl_h.tc_cdllegal,g_tc_cdl_h.tc_cdlconf     
     FROM  tc_cdl_file WHERE tc_cdl01 = g_tc_cdl_h.tc_cdl01 AND tc_cdl02 = g_tc_cdl_h.tc_cdl02 AND tc_cdl03 = g_tc_cdl_h.tc_cdl03 AND tc_cdl04 = g_tc_cdl_h.tc_cdl04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_cdl_file",g_tc_cdl_h.tc_cdl01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_tc_cdl_h.* TO NULL
      RETURN
   ELSE   
      CALL t324_01_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t324_01_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME 
          g_tc_cdl_h.tc_cdl01,g_tc_cdl_h.tc_cdl02,g_tc_cdl_h.tc_cdl03,g_tc_cdl_h.tc_cdl04,
          g_tc_cdl_h.tc_cdl11,g_tc_cdl_h.tc_cdllegal,g_tc_cdl_h.tc_cdlconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_tc_cdl_h.tc_cdllegal
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_tc_cdl_h.tc_cdl11 AND nppsys ='CA' AND npp00 =6 AND npp011 =1
   CALL cl_set_field_pic(g_tc_cdl_h.tc_cdlconf,"","","","","")
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL t324_01_b_fill()                 #單身
END FUNCTION
 
FUNCTION t324_01_b_fill()
    
 
   LET g_sql =  "SELECT tc_cdl13,tc_cdl06,'',tc_cdl05,'',tc_cdl16,'',tc_cdl07,'',tc_cdl08,'',tc_cdl14,tc_cdl15,tc_cdl09,'',tc_cdl10  ",   #No.FUN-CC0153  #FUN-D80089 add tc_cdl16,''
                "  FROM tc_cdl_file",
                " WHERE tc_cdl01 ='",g_tc_cdl_h.tc_cdl01,"'",
                "   AND tc_cdl02 ='",g_tc_cdl_h.tc_cdl02,"'",
                "   AND tc_cdl03 ='",g_tc_cdl_h.tc_cdl03,"'",
                "   AND tc_cdl04 ='",g_tc_cdl_h.tc_cdl04,"'",
                "   AND  ", g_wc2 CLIPPED,  #FUN-D60073 add
                " ORDER BY 1,2,3,5"
    PREPARE t324_01_pb FROM g_sql
    DECLARE tc_cdl_curs CURSOR FOR t324_01_pb
 
    CALL g_tc_cdl.clear()
    LET g_cnt = 1
    LET g_tc_cdl10_tot = 0
    FOREACH tc_cdl_curs INTO g_tc_cdl[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_tc_cdl[g_cnt].aag02 FROM aag_file WHERE aag01 = g_tc_cdl[g_cnt].tc_cdl08 AND aag00 = g_tc_cdl_h.tc_cdl01
       SELECT aag02 INTO g_tc_cdl[g_cnt].aag02_2 FROM aag_file WHERE aag01 = g_tc_cdl[g_cnt].tc_cdl09 AND aag00 = g_tc_cdl_h.tc_cdl01
       SELECT azf03 INTO g_tc_cdl[g_cnt].azf03 FROM azf_file WHERE azf01 = g_tc_cdl[g_cnt].tc_cdl06 AND azf02 = '2'
       SELECT gem02 INTO g_tc_cdl[g_cnt].gem02 FROM gem_file WHERE gem01 = g_tc_cdl[g_cnt].tc_cdl05
       SELECT gem02 INTO g_tc_cdl[g_cnt].gem02_1 FROM gem_file WHERE gem01 = g_tc_cdl[g_cnt].tc_cdl16   #FUN-D80089 add
       SELECT ima02 INTO g_tc_cdl[g_cnt].ima02 FROM ima_file WHERE ima01 = g_tc_cdl[g_cnt].tc_cdl07
       IF NOT cl_null(g_tc_cdl[g_cnt].tc_cdl10) THEN LET g_tc_cdl10_tot = g_tc_cdl10_tot + g_tc_cdl[g_cnt].tc_cdl10 END IF #FUN-D60073 add
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_cdl.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_tc_cdl10_tot TO FORMONLY.cdl10_tot  #FUN-D60073
END FUNCTION

FUNCTION t324_01_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()
   
      DISPLAY ARRAY g_tc_cdl TO s_tc_cdl.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)         
      BEFORE DISPLAY
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
                        
         BEFORE ROW
            LET l_ac = ARR_CURR() 
            LET l_ac1 = l_ac
            CALL cl_show_fld_cont()                                  
  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t324_01_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t324_01_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t324_01_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t324_01_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t324_01_fetch('L')
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
   
      ON ACTION accept
         LET g_action_choice="detail"        #No.FUN-A60024
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY

#No.MOD-D50097 --begin
      ON ACTION exporttoexcel                       #匯出Excel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#No.MOD-D50097 --end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
                                                         
   #   ON ACTION drill_down1                                                      
   #      LET g_action_choice="drill_down1"                                       
   #      EXIT DISPLAY     

      AFTER DISPLAY
         CONTINUE DISPLAY   
                        
   END DISPLAY
      
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                           
FUNCTION t324_01_drill_down()                                                      
   DEFINE l_flag     LIKE type_file.chr1   #MOD-C70138
   IF cl_null(l_ac1) OR l_ac1 = 0 THEN RETURN END IF                                                                              
   IF cl_null(g_tc_cdl[l_ac1].tc_cdl07) THEN RETURN END IF                                   
   #No.MOD-C70138  --Begin
   LET l_flag = '+'
   IF g_tc_cdl[l_ac1].tc_cdl10 < 0 THEN
      LET l_flag = '-'
   END IF
   #No.MOD-C70138  --End
   LET g_msg = "axcq770 '",g_tc_cdl[l_ac1].tc_cdl07,"' '",g_tc_cdl_h.tc_cdl02,"' '",g_tc_cdl_h.tc_cdl03,"'
               '",g_tc_cdl[l_ac1].tc_cdl13,"' '",g_tc_cdl[l_ac1].tc_cdl06,"' '",g_tc_cdl[l_ac1].tc_cdl05,"'  '",l_flag,"'"   #MOD-C70138 
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t324_01_count()
 
   DEFINE l_tc_cdl   DYNAMIC ARRAY of RECORD        # 程式變數
          tc_cdl01          LIKE tc_cdl_file.tc_cdl01, 
          tc_cdl02          LIKE tc_cdl_file.tc_cdl02,          
          tc_cdl03          LIKE tc_cdl_file.tc_cdl03,
          tc_cdl04          LIKE tc_cdl_file.tc_cdl04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE tc_cdl01,tc_cdl02,tc_cdl03,tc_cdl04 FROM tc_cdl_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED,
              "   AND ",g_wc1 CLIPPED    #FUN-D60095 add  
   PREPARE t324_01_precount FROM g_sql
   DECLARE t324_01_count CURSOR FOR t324_01_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t324_01_count INTO l_tc_cdl[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b 
END FUNCTION
