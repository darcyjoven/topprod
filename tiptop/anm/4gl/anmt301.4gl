# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Pattern name...: anmt301.4gl
# Descriptions...: 銀行對帳調節作業
# Date & Author..: #No.FUN-B30166 11/04/08 By lutingting
# Modify.........: #No.FUN-B50063 11/05/25 By xianghui 刪除時提取資料報400錯誤
# Modify.........: #No.FUN-B50159 11/06/03 By lutingting 開帳資料也要帶進單身
# Modify.........: #No.FUN-B60095 11/06/20 By lutingting 開帳資料的交易日期用年月來組,如2011年1月則顯示2011/01/01
# Modify.........: #No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: #No.TQC-C50173 12/05/21 By lutingting 手工對帳應可修正自動對帳的結果

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_naf         RECORD LIKE naf_file.*,      
       g_naf_t       RECORD LIKE naf_file.*,     
       g_naf_o       RECORD LIKE naf_file.*,    
       g_naf01_t     LIKE naf_file.naf01,  #對帳單號   
       g_naf02_t     LIKE naf_file.naf02,  #銀行編號  
       g_naf03_t     LIKE naf_file.naf03,  #年度 
       g_naf04_t     LIKE naf_file.naf04,  #期別
       g_nag         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           chk1      LIKE type_file.chr1,          # 對帳碼 
           nag04     LIKE nag_file.nag04,          # 對帳方式 
           nag02     LIKE nag_file.nag02,          # 對帳流水號
           nag03     LIKE nag_file.nag03,          # 企業賬流水號--隱藏
           nag05     LIKE nag_file.nag05,          # 異動單號
           nag06     LIKE nag_file.nag06,          # 異動項次
           nme05     LIKE nme_file.nme05,          # 摘要
           nme16     LIKE nme_file.nme16,          # 異動日期
           dc1       LIKE type_file.chr1,          # 借貸別 
           nme08     LIKE nme_file.nme08           # 异动金額
                     END RECORD,
       g_nag_t       RECORD  
           chk1      LIKE type_file.chr1,          # 對帳碼
           nag04     LIKE nag_file.nag04,          # 對帳方式
           nag02     LIKE nag_file.nag02,          # 對帳流水號
           nag03     LIKE nag_file.nag03,          # 企業賬流水號--隱藏
           nag05     LIKE nag_file.nag05,          # 異動單號
           nag06     LIKE nag_file.nag06,          # 異動項次
           nme05     LIKE nme_file.nme05,          # 摘要
           nme16     LIKE nme_file.nme16,          # 異動日期
           dc1       LIKE type_file.chr1,          # 借貸別
           nme08     LIKE nme_file.nme08           # 异动金額
                     END RECORD,
       g_nah         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           chk2      LIKE type_file.chr1,          # 對帳碼
           nah04     LIKE nah_file.nah04,          # 對賬方式
           nah02     LIKE nah_file.nah02,          # 對帳流水號
           nah03     LIKE nah_file.nah03,          # 銀行賬流水號--隱藏
           nmu01     LIKE nmu_file.nmu01,          # 交易日期
           dc2       LIKE nmu_file.nmu09,          # 借貸別
           nmu10     LIKE nmu_file.nmu10           # 交易金額
                     END RECORD,
       g_nah_t       RECORD       #程式變數(Program Variables)
           chk2      LIKE type_file.chr1,          # 對帳碼
           nah04     LIKE nah_file.nah04,          # 對賬方式
           nah02     LIKE nah_file.nah02,          # 對帳流水號
           nah03     LIKE nah_file.nah03,          # 銀行賬流水號--隱藏
           nmu01     LIKE nmu_file.nmu01,          # 交易日期
           dc2       LIKE nmu_file.nmu09,          # 借貸別
           nmu10     LIKE nmu_file.nmu10           # 交易金額
                     END RECORD,
       g_sql            STRING,                       #CURSOR暫存
       g_wc             STRING,                       #單頭CONSTRUCT結果
       g_wc2            STRING,                       #單身CONSTRUCT結果
       g_wc3            STRING,                       #單身CONSTRUCT結果
       g_rec_b          LIKE type_file.num10,          #單身筆數  
       g_rec_b1         LIKE type_file.num10,          #單身筆數 
       l_ac             LIKE type_file.num10           #目前處理的ARRAY CNT 
DEFINE p_row,p_col      LIKE type_file.num5     #
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_before_input_done LIKE type_file.num5  #
DEFINE g_cnt            LIKE type_file.num10    #
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg            LIKE ze_file.ze03       #
DEFINE g_curs_index     LIKE type_file.num10    #
DEFINE g_row_count      LIKE type_file.num10    #總筆數  
DEFINE g_jump           LIKE type_file.num10    #查詢指定的筆數 
DEFINE mi_no_ask        LIKE type_file.num5     #是否開啟指定筆視窗  
DEFINE g_year           LIKE type_file.chr20,
       g_month          LIKE type_file.chr20,
       g_day            LIKE type_file.chr20
DEFINE g_b_flag         STRING

#主程式開始
MAIN
DEFINE   p_row,p_col    LIKE type_file.num5    #No.FUN-680107 SMALLINT

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM naf_file WHERE naf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t301_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t301_w AT p_row,p_col WITH FORM "anm/42f/anmt301"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_set_comp_visible("nag03,nah03",FALSE)
   CALL t301_menu()
   CLOSE WINDOW t301_w                 #結束畫面

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION t301_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  

   CLEAR FORM 
   CALL g_nag.clear()
   CALL g_nah.clear() 
   
    DIALOG ATTRIBUTES(UNBUFFERED)   
       CONSTRUCT BY NAME g_wc ON naf01,naf02,naf03,naf04,nafconf

          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
       END CONSTRUCT

       CONSTRUCT g_wc2 ON 
                   nag04,nag02,nag05,nag06
              FROM s_nag[1].nag04,s_nag[1].nag02,s_nag[1].nag05,s_nag[1].nag06
 
		  BEFORE CONSTRUCT
		    CALL cl_qbe_display_condition(lc_qbe_sn)      

       END CONSTRUCT

       CONSTRUCT g_wc3 ON
                   nah04,nah02
              FROM s_nah[1].nah04,s_nah[1].nah02

                  BEFORE CONSTRUCT
                    CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT

          ON ACTION controlp
             CASE
                WHEN INFIELD(naf02) #银行账户
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_naf"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO naf02
                   NEXT FIELD naf02
                OTHERWISE EXIT CASE
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
         
          ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION accept
             EXIT DIALOG

          ON ACTION cancel
             LET INT_FLAG = TRUE
             EXIT DIALOG
      END DIALOG
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nafuser', 'nafgrup')
        
   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF 
   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1" END IF      
       
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT naf01 FROM naf_file",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY naf01"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE naf01 ",
                     "  FROM naf_file, nag_file",
                     " WHERE naf01 = nag01",
                     "   AND ", g_wc CLIPPED,
                     "   AND ",g_wc2 CLIPPED,
                     " ORDER BY naf01"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT naf01 ",
                     "  FROM naf_file, nah_file",
                     " WHERE naf01 = nah01",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY naf01"
      ELSE
         LET g_sql = "SELECT UNIQUE naf01 ",
                     "  FROM naf_file, nag_file,nah_file",
                     " WHERE naf01 = nag01 AND naf01 = nah01",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY naf01"
      END IF
   END IF
   
   PREPARE t301_prepare FROM g_sql
   DECLARE t301_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t301_prepare

   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(*) FROM naf_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT naf01) FROM naf_file,nag_file",
                   " WHERE naf01=nag01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(DISTINCT naf01) FROM naf_file,nah_file",
                   " WHERE naf01=nah01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc3 CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT naf01) FROM naf_file,nag_file,nah_file",
                   " WHERE naf01 = nag01 AND naf01 = nah01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   "   AND ",g_wc3 CLIPPED
      END IF
   END IF
   PREPARE t301_precount FROM g_sql
   DECLARE t301_count CURSOR FOR t301_precount  
  
END FUNCTION

FUNCTION t301_menu()

   WHILE TRUE
      CALL t301_bp("G") 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t301_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t301_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t301_r()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "confirm"    #审核
            IF cl_chk_act_auth() THEN
               CALL t301_y()
            END IF
         WHEN "unconfirm"    #取消审核
            IF cl_chk_act_auth() THEN
               CALL t301_z()
            END IF   
         WHEN "reconciliation"    #自动对账
            IF cl_chk_act_auth() THEN
               CALL t301_auto()
            END IF
         WHEN "hand"          #手工对账
            IF cl_chk_act_auth() THEN
               CALL t301_hand()
            END IF
         WHEN "Comparison"       #对照
             IF cl_chk_act_auth() THEN
               CALL t301_comp()
            END IF 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t301_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   DIALOG ATTRIBUTES(UNBUFFERED)   
   DISPLAY ARRAY g_nag TO s_nag.* ATTRIBUTE(COUNT=g_rec_b1)
     BEFORE DISPLAY
        CALL cl_set_act_visible("accept,cancel",FALSE )  
         LET g_b_flag='1'
        CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
              
   END DISPLAY
   
   DISPLAY ARRAY g_nah TO s_nah.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
   END DISPLAY 
   
   BEFORE DIALOG   
       ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION first
         CALL t301_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL t301_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t301_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t301_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t301_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG


      ON ACTION cancel
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

      ON ACTION confirm   #审核
         LET g_action_choice="confirm"
         EXIT DIALOG

      ON ACTION unconfirm   #取消审核
         LET g_action_choice="unconfirm"
         EXIT DIALOG

      ON ACTION reconciliation   #自动对账
         LET g_action_choice="reconciliation"
         EXIT DIALOG

      ON ACTION hand
         LET g_action_choice = "hand"
         EXIT DIALOG

      ON ACTION Comparison   #对照
         LET g_action_choice="Comparison"
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION

FUNCTION t301_nag_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           VARCHAR(200)
DEFINE l_sum1          LIKE nme_file.nme08, 
       l_sum2          LIKE nme_file.nme08, 
       l_sum3          LIKE nme_file.nme08, 
       l_sum4          LIKE nme_file.nme08, 
       l_sum5          LIKE nme_file.nme08
#FUN-B60095--add--str--
DEFINE l_year          LIKE type_file.chr4
DEFINE l_month         LIKE type_file.chr4
#FUN-B60095--add--end

    IF g_naf.nafconf = 'Y' THEN
       LET g_sql =
           "SELECT '',nag04,nag02,nme27,nme12,nme21,nme05,nme16,nmc03,nme08 ",
           "  FROM nme_file,nag_file,nmc_file ",
           " WHERE nme01 = '",g_naf.naf02,"' ",   #銀行編號
           "   AND nme03 = nmc01 ",
           "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",
           "   AND nme20 ='Y' ",
           "   AND ",p_wc2 CLIPPED,
           "   AND nme12=nag05 AND nme21=nag06 ",
           "   AND nme27=nag03 AND nag01='",g_naf.naf01,"'",
           " ORDER BY nme16 "    #FUN-B50159   #FUN-B60095取消mark
#FUN-B60095--mark--str--
#          #FUN-B50159--add--str--
#          ," UNION ",
#          "SELECT '',nag04,nag02,nai08,'',0,nai07,cast(substr(nai08,1,8) as date),nai05,nai06 ",
#          "  FROM nai_file,nag_file ",
#          " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
#          "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '1'",
#          "   AND nai09 = 'Y' ",
#          "   AND nai08=nag03 AND nag01 = '",g_naf.naf01,"'"
#          #FUN-B50159--add--end
#FUN-B60095--mark--end
    ELSE
       LET g_sql =
           "SELECT '',nag04,nag02,nme27,nme12,nme21,nme05,nme16,nmc03,nme08 ",
           "  FROM nme_file LEFT OUTER JOIN nag_file ",
           "                  ON nme12=nag05 AND nme21=nag06 AND nme27=nag03 AND nag01='",g_naf.naf01,"'",
           "  ,nmc_file ", 
           " WHERE nme01 = '",g_naf.naf02,"' ",   #銀行編號
           "   AND nme03 = nmc01 ",
           "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",
           "   AND (nme20 <>'Y' OR nme20 IS NULL)",
           "   AND ",p_wc2 CLIPPED,
           " ORDER BY nme16 "    #FUN-B50159   #FUN-B60095 取消mark 
#FUN-B60095--MARK--STR--
#          #FUN-B50159--add--str--
#          ," UNION ",
#          "SELECT '',nag04,nag02,nai08,'',0,nai07,cast(substr(nai08,1,8) as date),nai05,nai06 ",
#          "  FROM nai_file LEFT OUTER JOIN nag_file ON nai08=nag03 AND nag01 = '",g_naf.naf01,"'",
#          " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
#          "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '1'",
#          "   AND (nai09 <>'Y' OR nai09 IS NULL )"
#          #FUN-B50159--add--end
#FUN-B60095--mark--end
    END IF 

    PREPARE t301_nag_pre FROM g_sql
    DECLARE t301_nag_cs CURSOR FOR t301_nag_pre

    CALL g_nag.clear()
    LET g_rec_b1 = 1
     
    LET l_sum1 = 0
    LET l_sum2 = 0
    LET l_sum3 = 0
    LET l_sum4 = 0
     
    FOREACH t301_nag_cs INTO g_nag[g_rec_b1].* 
        IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF
        IF cl_null(g_nag[g_rec_b1].nag04) THEN 
           LET g_nag[g_rec_b1].chk1 = 'N' 
        ELSE
           LET g_nag[g_rec_b1].chk1 = 'Y'
        END IF 
        CASE g_nag[g_rec_b1].dc1
           WHEN '1'  
              LET l_sum1= l_sum1 + g_nag[g_rec_b1].nme08
              CASE g_nag[g_rec_b1].chk1
                 WHEN 'Y'
                    LET l_sum3= l_sum3 + g_nag[g_rec_b1].nme08
              END CASE 
           WHEN '2' 
              LET l_sum2= l_sum2 + g_nag[g_rec_b1].nme08
              CASE g_nag[g_rec_b1].chk1
                 WHEN 'Y'
                    LET l_sum4= l_sum4 + g_nag[g_rec_b1].nme08
              END CASE      
         END CASE 

        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_nag.deleteElement(g_rec_b1)
    #LET g_rec_b1=g_rec_b1-1   #FUN-B60095

#FUN-B60095--add--str--
    IF g_naf.nafconf = 'Y' THEN
       LET g_sql =
           #"SELECT '',nag04,nag02,nai08,'',0,nai07,substr(nai08,1,8),nai05,nai06 ",
           "SELECT '',nag04,nag02,nai08,'',0,nai07,'',nai05,nai06,nai03,nai04 ",
           "  FROM nai_file,nag_file ",
           " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
           "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '1'",
           "   AND nai09 = 'Y' ",
           "   AND nai08=nag03 AND nag01 = '",g_naf.naf01,"'"
    ELSE
       LET g_sql =
           #"SELECT '',nag04,nag02,nai08,'',0,nai07,substr(nai08,1,8),nai05,nai06 ",
           "SELECT '',nag04,nag02,nai08,'',0,nai07,'',nai05,nai06,nai03,nai04 ",
           "  FROM nai_file LEFT OUTER JOIN nag_file ON nai08=nag03 AND nag01 = '",g_naf.naf01,"'",
           " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
           "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '1'",
           "   AND (nai09 <>'Y' OR nai09 IS NULL )"
    END IF

    PREPARE t301_nag_pre1 FROM g_sql
    DECLARE t301_nag_cs1 CURSOR FOR t301_nag_pre1
    FOREACH t301_nag_cs1 INTO g_nag[g_rec_b1].*,l_year,l_month
        IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF
        LET g_nag[g_rec_b1].nme16 = MDY(l_month,01,l_year)
        IF cl_null(g_nag[g_rec_b1].nag04) THEN
           LET g_nag[g_rec_b1].chk1 = 'N'
        ELSE
           LET g_nag[g_rec_b1].chk1 = 'Y'
        END IF
        CASE g_nag[g_rec_b1].dc1
           WHEN '1'
              LET l_sum1= l_sum1 + g_nag[g_rec_b1].nme08
              CASE g_nag[g_rec_b1].chk1
                 WHEN 'Y'
                    LET l_sum3= l_sum3 + g_nag[g_rec_b1].nme08
              END CASE
           WHEN '2'
              LET l_sum2= l_sum2 + g_nag[g_rec_b1].nme08
              CASE g_nag[g_rec_b1].chk1
                 WHEN 'Y'
                    LET l_sum4= l_sum4 + g_nag[g_rec_b1].nme08
              END CASE
         END CASE

        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_nag.deleteElement(g_rec_b1)
    LET g_rec_b1=g_rec_b1-1
#FUN-B60095--add--end

   LET l_sum5 = l_sum3+l_sum4
   DISPLAY l_sum1 TO FORMONLY.a1    #收入合計
   DISPLAY l_sum2 TO FORMONLY.b1    #支出合計
   DISPLAY l_sum5 TO FORMONLY.c1    #已對賬合計

END FUNCTION


FUNCTION t301_nah_fill(p_wc3)              #BODY FILL UP
DEFINE p_wc3           VARCHAR(200)
DEFINE l_sum1          LIKE nme_file.nme08,
       l_sum2          LIKE nme_file.nme08,
       l_sum3          LIKE nme_file.nme08,
       l_sum4          LIKE nme_file.nme08,
       l_sum5          LIKE nme_file.nme08
#FUN-B60095--add--str--
DEFINE l_year          LIKE type_file.chr4
DEFINE l_month         LIKE type_file.chr4
#FUN-B60095--add--end

    IF g_naf.nafconf = 'Y' THEN
       LET g_sql =
           "SELECT '',nah04,nah02,nmu23,nmu01,nmu09,nmu10 ",
           "  FROM nmu_file,nah_file", 
           " WHERE nmu03 = '",g_naf.naf02,"' ",   #銀行編號
           "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",
           "   AND nmu24 ='Y' ",
           "   AND nmu23=nah03 AND nah01='",g_naf.naf01,"'",
           "   AND ",p_wc3 CLIPPED,
           " ORDER BY nmu01 "    
    ELSE
       LET g_sql =
           "SELECT '',nah04,nah02,nmu23,nmu01,nmu09,nmu10 ",   #FUN-B50159
           "  FROM nmu_file LEFT OUTER JOIN nah_file ",
           "                  ON nmu23=nah03 AND nah01='",g_naf.naf01,"'",
           " WHERE nmu03 = '",g_naf.naf02,"' ",   #銀行編號
           "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",
           "   AND (nmu24 <>'Y' OR nmu24 IS NULL)",
           "   AND ",p_wc3 CLIPPED,
           " ORDER BY nmu01 " 
    END IF 

    PREPARE t301_nah_pre FROM g_sql
    DECLARE t301_nah_cs CURSOR FOR t301_nah_pre

    CALL g_nah.clear()
    LET g_rec_b = 1

    LET l_sum1 = 0
    LET l_sum2 = 0
    LET l_sum3 = 0
    LET l_sum4 = 0

     FOREACH t301_nah_cs INTO g_nah[g_rec_b].*
        IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF
        IF cl_null(g_nah[g_rec_b].nah04) THEN
           LET g_nah[g_rec_b].chk2 = 'N' 
        ELSE
           LET g_nah[g_rec_b].chk2 = 'Y'
        END IF
        CASE g_nah[g_rec_b].dc2
           WHEN '1'
              LET l_sum1= l_sum1 + g_nah[g_rec_b].nmu10
              CASE g_nah[g_rec_b].chk2
                 WHEN 'Y'
                    LET l_sum3= l_sum3 + g_nah[g_rec_b].nmu10
              END CASE
           WHEN '-1'
              LET l_sum2= l_sum2 + g_nah[g_rec_b].nmu10
              CASE g_nah[g_rec_b].chk2
                 WHEN 'Y'
                    LET l_sum4= l_sum4 + g_nah[g_rec_b].nmu10
              END CASE
         END CASE

        LET g_rec_b = g_rec_b + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_nah.deleteElement(g_rec_b)
    LET g_rec_b=g_rec_b-1

   #FUN-B50159--add--str--
   IF g_naf.nafconf = 'Y' THEN
      LET g_sql = 
           #"SELECT '',nah04,nah02,nai08,cast(substr(nai08,1,8) as date),(CASE WHEN nai05=1 THEN '1' ELSE '-1' END ),nai06 ",   #FUN-B60095
           "SELECT '',nah04,nah02,nai08,substr(nai08,1,8),(CASE WHEN nai05=1 THEN '1' ELSE '-1' END ),nai06,nai03,nai04 ",
           "  FROM nai_file,nah_file",
           " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
           "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '2'",
           "   AND nai09 = 'Y'",
           "   AND nai08 = nah03 AND nah01 = '",g_naf.naf01,"'"
   ELSE
      LET g_sql = 
           #"SELECT '',nah04,nah02,nai08,cast(substr(nai08,1,8) as date),(CASE WHEN nai05=1 THEN '1' ELSE '-1' END ),nai06 ",
           "SELECT '',nah04,nah02,nai08,substr(nai08,1,8),(CASE WHEN nai05=1 THEN '1' ELSE '-1' END ),nai06,nai03,nai04 ",
           "  FROM nai_file LEFT OUTER JOIN nah_file ON nai08 = nah03 AND nah01 = '",g_naf.naf01,"'",
           " WHERE (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
           "   AND nai02 = '",g_naf.naf02,"' AND nai01 = '2'",
           "   AND (nai09 <> 'Y' OR nai09 IS NULL)"
   END IF 
   LET g_rec_b = g_rec_b+1
   PREPARE sel_nai_curs FROM g_sql
   DECLARE sel_nai_cs CURSOR FOR sel_nai_curs
   FOREACH sel_nai_cs INTO g_nah[g_rec_b].*,l_year,l_month   #FUN-B60095 ADD YEAR,MONTH
        IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF
        #FUN-B60095--add--str--
        LET g_nah[g_rec_b].nmu01 = MDY(l_month,01,l_year)
        #FUN-B60095--add-end
        IF cl_null(g_nah[g_rec_b].nah04) THEN
           LET g_nah[g_rec_b].chk2 = 'N'
        ELSE
           LET g_nah[g_rec_b].chk2 = 'Y'
        END IF
        CASE g_nah[g_rec_b].dc2
           WHEN '1'
              LET l_sum1= l_sum1 + g_nah[g_rec_b].nmu10
              CASE g_nah[g_rec_b].chk2
                 WHEN 'Y'
                    LET l_sum3= l_sum3 + g_nah[g_rec_b].nmu10
              END CASE
           WHEN '-1'
              LET l_sum2= l_sum2 + g_nah[g_rec_b].nmu10
              CASE g_nah[g_rec_b].chk2
                 WHEN 'Y'
                    LET l_sum4= l_sum4 + g_nah[g_rec_b].nmu10
              END CASE
         END CASE

        LET g_rec_b = g_rec_b + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nah.deleteElement(g_rec_b)
    LET g_rec_b=g_rec_b-1
   #FUN-B50159--add--end
   LET l_sum5 = l_sum3+l_sum4
   DISPLAY l_sum1 TO FORMONLY.a2    #收入合計
   DISPLAY l_sum2 TO FORMONLY.b2    #支出合計
   DISPLAY l_sum5 TO FORMONLY.c2    #已對賬合計

END FUNCTION

FUNCTION t301_a()

   MESSAGE ""
   CLEAR FORM
   CALL g_nag.clear()
   LET g_wc = NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_naf.* LIKE naf_file.*             #DEFAULT 設定

   #預設值及將數值類變數清成零
   LET g_naf_t.* = g_naf.*
   LET g_naf_o.* = g_naf.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_naf.nafuser=g_user
      LET g_naf.nafgrup=g_grup
      LET g_naf.nafdate=g_today
      LET g_naf.nafconf = 'N'
      LET g_naf.naflegal = g_legal

      CALL t301_i("a")                   #輸入單頭

      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_naf.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_naf.naf01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF

      BEGIN WORK

      INSERT INTO naf_file VALUES (g_naf.*)

      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","naf_file",g_naf.naf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK 
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_naf.naf01,'I')
      END IF

      LET g_naf01_t = g_naf.naf01        #保留舊值
      LET g_naf_t.* = g_naf.*
      LET g_naf_o.* = g_naf.*
      CALL g_nag.clear()
      CALL g_nah.clear()

      LET g_rec_b = 0

      CALL t301_nag_fill('1=1')    #企業帳
      CALL t301_nah_fill('1=1')
      EXIT WHILE
   END WHILE

END FUNCTION


FUNCTION t301_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5,
          p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_cnt       LIKE type_file.num5
DEFINE    l_nma03     LIKE nma_file.nma03        
DEFINE l_year     LIKE type_file.chr4
DEFINE l_month    LIKE type_file.chr4
DEFINE l_day      LIKE type_file.chr4
DEFINE l_dt       LIKE type_file.chr20
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_naf.nafconf,g_naf.nafuser,g_naf.nafmodu,g_naf.nafgrup,
                   g_naf.nafdate

   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_naf.naf01,g_naf.naf02,g_naf.naf03,g_naf.naf04
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE

#对账单号依年月日+3位流水号自动生成
      IF p_cmd='a' THEN  #只有输入状态才需自动编号
         LET l_year = YEAR(g_today) USING '&&&&'
         LET l_month = MONTH(g_today) USING '&&'
         LET l_day = DAY(g_today) USING  '&&'
         LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
         SELECT MAX(naf01) + 1 INTO g_naf.naf01 FROM naf_file
          WHERE naf01[1,8] = l_dt
         IF cl_null(g_naf.naf01) THEN
            LET g_naf.naf01 = l_dt,'000000000001'
         END IF
         DISPLAY BY NAME g_naf.naf01
      END IF

      AFTER FIELD naf02
         IF NOT cl_null(g_naf.naf02) THEN
            CALL t301_naf02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_naf.naf02,g_errno,0)
               NEXT FIELD naf02
            END IF 
         END IF
    
      AFTER FIELD naf03
         IF NOT cl_null(g_naf.naf03) THEN
            SELECT COUNT(*) INTO l_cnt FROM naf_file
             WHERE naf02 = g_naf.naf02
               AND naf03 = g_naf.naf03
               AND naf04 = g_naf.naf04
            IF l_cnt>0 THEN
               CALL cl_err(g_naf.naf03,-239,0)
               NEXT FIELD naf03
            END IF 
         END IF 

      AFTER FIELD naf04
         IF NOT cl_null(g_naf.naf04) THEN
            SELECT COUNT(*) INTO l_cnt FROM naf_file
             WHERE naf02 = g_naf.naf02
               AND naf03 = g_naf.naf03
               AND naf04 = g_naf.naf04
            IF l_cnt>0 THEN
               CALL cl_err(g_naf.naf04,-239,0)
               NEXT FIELD naf04
            END IF
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 

      ON ACTION controlp
         CASE
            WHEN INFIELD(naf02) #银行账户
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nma1"
               LET g_qryparam.default1 = g_naf.naf02           
               CALL cl_create_qry() RETURNING g_naf.naf02
               DISPLAY BY NAME g_naf.naf02
               CALL t301_naf02('d')
               NEXT FIELD naf02
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
 

FUNCTION t301_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_nag.clear()


   CALL t301_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_naf.* TO NULL
      RETURN
   END IF

   OPEN t301_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_naf.* TO NULL
   ELSE
      OPEN t301_count
      FETCH t301_count INTO g_row_count
   #  DISPLAY g_row_count TO FORMONLY.cnt

      CALL t301_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t301_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式

   CASE p_flag
      WHEN 'N' FETCH NEXT     t301_cs INTO g_naf.naf01
      WHEN 'P' FETCH PREVIOUS t301_cs INTO g_naf.naf01
      WHEN 'F' FETCH FIRST    t301_cs INTO g_naf.naf01
      WHEN 'L' FETCH LAST     t301_cs INTO g_naf.naf01
      WHEN '/'
      IF (NOT mi_no_ask) THEN
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
      FETCH ABSOLUTE g_jump t301_cs INTO g_naf.naf01
      LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_naf.naf01,SQLCA.sqlcode,0)
      INITIALIZE g_naf.* TO NULL
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

   SELECT * INTO g_naf.* FROM naf_file WHERE naf01 = g_naf.naf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","naf_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_naf.* TO NULL
      RETURN
   END IF


   CALL t301_show()

END FUNCTION

#將資料顯示在畫面上
FUNCTION t301_show()

   LET g_naf_t.* = g_naf.*                #保存單頭舊值
   LET g_naf_o.* = g_naf.*                #保存單頭舊值
   DISPLAY BY NAME g_naf.naf01,g_naf.naf02,g_naf.naf03,
                   g_naf.naf04,g_naf.nafconf,g_naf.nafuser,
                   g_naf.nafgrup,g_naf.nafmodu,g_naf.nafdate
 
   CALL t301_naf02('d')
   IF cl_null(g_wc3) THEN LET g_wc3='1=1' END IF
   IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF
   CALL t301_nag_fill(g_wc2)                 #單身
   CALL t301_nah_fill(g_wc3)                #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t301_r()
DEFINE l_cnt  LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_naf.naf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_naf.nafconf = 'Y' THEN
      CALL cl_err(g_naf.naf01,'anm-105',2)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM nag_file,nah_file
    WHERE nag01 = nah01 AND nag01 = g_naf.naf01
      AND nag02 = nah02
   IF l_cnt>0 THEN
      IF NOT cl_confirm('anm-619') THEN RETURN END IF 
   END IF 

   BEGIN WORK

   OPEN t301_cl USING g_naf.naf01
   IF STATUS THEN
      CALL cl_err("OPEN t301_cl:", STATUS, 1)
      CLOSE t301_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t301_cl INTO g_naf.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_naf.naf01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t301_show()

   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM naf_file WHERE naf01 = g_naf.naf01
      DELETE FROM nag_file WHERE nag01 = g_naf.naf01
      DELETE FROM nah_file WHERE nah01 = g_naf.naf01
      CLEAR FORM
      CALL g_nag.clear()
      CALL g_nah.clear()
      
      OPEN t301_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t301_cs
         CLOSE t301_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t301_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t301_cs
         CLOSE t301_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t301_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t301_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t301_fetch('/')
      END IF
   END IF

   CLOSE t301_cl
   COMMIT WORK
   CALL cl_flow_notify(g_naf.naf01,'D')
END FUNCTION


FUNCTION t301_naf02(p_cmd)
DEFINE l_nmaacti LIKE nma_file.nmaacti
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_nma03   LIKE nma_file.nma03

    LET g_errno = ' ' 
    SELECT nmaacti,nma03 INTO l_nmaacti,l_nma03 FROM nma_file
     WHERE nma01 = g_naf.naf02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                   LET l_nma03 = NULL
        WHEN l_nmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_nma03 TO nma03
   END IF

END FUNCTION

#审核
FUNCTION t301_y()
DEFINE l_success  LIKE type_file.chr1
DEFINE i          LIKE type_file.num5
   LET l_success='Y'


   IF NOT cl_confirm('aap-017') THEN RETURN END IF
   CALL s_showmsg_init()
   BEGIN WORK
   LET g_success = 'Y'
   FOR i=1 TO g_rec_b1
     IF g_nag[i].chk1='Y' THEN
        UPDATE nme_file SET nme20 = 'Y'
         WHERE nme12 = g_nag[i].nag05
           AND nme21 = g_nag[i].nag06
           AND nme27 = g_nag[i].nag03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #FUN-B50159--mod--str--
           UPDATE nai_file SET nai09 = 'Y'
            WHERE nai08 = g_nag[i].nag03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #LET g_showmsg = g_nag[i].nag05,"/",g_nag[i].nag06
              #CALL s_errmsg('nme12,nme21 ',g_showmsg,'upd nme',SQLCA.sqlcode,1)   
              CALL s_errmsg('nai08 ',g_nag[i].nag03,'upd nai',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF 
           #FUN-B50159--mod--end
        END IF 
     END IF
   END FOR

   FOR i=1 TO g_rec_b
     IF g_nah[i].chk2='Y' THEN
        UPDATE nmu_file SET nmu24 = 'Y'
         WHERE nmu23 = g_nah[i].nah03 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #FUN-B50159--mod--str--
           UPDATE nai_file SET nai09 = 'Y' WHERE nai08 = g_nah[i].nah03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #CALL s_errmsg('nmu24 ',g_nah[i].nah03,'upd nmu',SQLCA.sqlcode,1)
              CALL s_errmsg('nai08',g_nah[i].nah03,'upd nai',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF 
           #FUN-B50159--mod--end
        END IF
     END IF
   END FOR

   UPDATE naf_file SET nafconf='Y' WHERE naf01=g_naf.naf01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                     
      CALL s_errmsg('naf01 ',g_naf.naf01,'upd naf',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 

   IF g_success = 'Y'  THEN 
      COMMIT WORK
      LET g_naf.nafconf = 'Y'
      DISPLAY BY NAME g_naf.nafconf
   ELSE
      ROLLBACK WORK
   END IF 
   CALL s_showmsg()
   CALL t301_show()
END FUNCTION 

FUNCTION t301_z()
DEFINE i LIKE type_file.num5

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   CALL s_showmsg_init()
   BEGIN WORK
   LET g_success = 'Y'
   FOR i=1 TO g_rec_b1
     IF g_nag[i].chk1='Y' THEN
        UPDATE nme_file SET nme20 = 'N'
         WHERE nme12 = g_nag[i].nag05
           AND nme21 = g_nag[i].nag06 
           AND nme27 = g_nag[i].nag03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #FUN-B50159--mod--str--
           UPDATE nai_file SET nai09 = 'N'
            WHERE nai08 = g_nag[i].nag03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL s_errmsg('nai08',g_nag[i].nag03,'upd nai',SQLCA.sqlcode,1)   
              LET g_success = 'N'
           END IF 
           #FUN-B50159--mod--end
        END IF 
     END IF
   END FOR

   FOR i=1 TO g_rec_b
     IF g_nah[i].chk2='Y' THEN
        UPDATE nmu_file SET nmu24 = 'N'
         WHERE nmu23 = g_nah[i].nah03 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #FUN-B50159--mod--str--
           UPDATE nai_file SET nai09 = 'N'
            WHERE nai08 = g_nah[i].nah03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL s_errmsg('nai08 ',g_nah[i].nah03,'upd nai',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF 
           #FUN-B50159--mod--end
        END IF
     END IF
   END FOR

   UPDATE naf_file SET nafconf='N' WHERE naf01=g_naf.naf01
   IF SQLCA.sqlcode THEN                     
      CALL s_errmsg('naf01 ',g_naf.naf01,'upd naf',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 

   IF g_success = 'Y'  THEN 
      COMMIT WORK
      LET g_naf.nafconf = 'N'
      DISPLAY BY NAME g_naf.nafconf
   ELSE
      ROLLBACK WORK
   END IF 
   CALL s_showmsg()
   CALL t301_show()
END FUNCTION 

#自动对帐
FUNCTION t301_auto()
DEFINE l_sql      STRING
DEFINE i,j        LIKE type_file.num10
DEFINE l_nag      RECORD LIKE nag_file.* 
DEFINE l_nah      RECORD LIKE nah_file.* 
DEFINE l_cnt      LIKE type_file.num10 
DEFINE l_year     LIKE type_file.chr4
DEFINE l_month    LIKE type_file.chr4
DEFINE l_day      LIKE type_file.chr4
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_date1    LIKE type_file.chr20
DEFINE l_time     LIKE type_file.chr20

    IF g_naf.nafconf = 'Y' THEN CALL cl_err(g_naf.naf01,'anm-339',0) RETURN END IF 
    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()
#依借贷+金额
#企业帐    
    FOR i=1 TO g_rec_b1 
      IF g_nag[i].chk1='Y'  THEN CONTINUE FOR END IF 

      FOR j=1 TO g_rec_b
        IF g_nah[j].chk2='Y'  THEN CONTINUE FOR END IF 
        #IF (g_nag[i].dc1='1' AND g_nah[j].dc2='-1') OR 
        #   (g_nag[i].dc1='2' AND g_nah[j].dc2='1')               
        IF (g_nag[i].dc1='1' AND g_nah[j].dc2='1') OR 
           (g_nag[i].dc1='2' AND g_nah[j].dc2='-1')               
        THEN 
           #IF g_nag[i].nme08=g_nah[j].nmu10 THEN   #TQC-C50173 
           IF g_nag[i].nme08=g_nah[j].nmu10 AND g_nah[j].chk2='N' THEN #TQC-C50173 

              LET g_nah[j].chk2 = 'Y'  #TQC-C50173
              #對帳流水號
              LET l_date1 = g_today
              #LET l_year = YEAR(l_date1)USING '&&&&'
              #LET l_month = MONTH(l_date1) USING '&&'
              LET l_year = g_naf.naf03
              LET l_month = g_naf.naf04 USING '&&'
              LET l_day = DAY(l_date1) USING  '&&'
              LET l_time = TIME(CURRENT)
              LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                           l_time[1,2],l_time[4,5],l_time[7,8]
              SELECT MAX(nag02) + 1 INTO g_nag[i].nag02 FROM nag_file
               WHERE nag02[1,14] = l_dt
                 AND nag01 = g_naf.naf01
              IF cl_null(g_nag[i].nag02) THEN
                 LET g_nag[i].nag02 = l_dt,'000001'
              END IF
              LET g_nah[j].nah02 = g_nag[i].nag02

              INSERT INTO nag_file(nag01,nag02,nag03,nag04,nag05,nag06,naglegal) 
              VALUES(g_naf.naf01,g_nag[i].nag02,g_nag[i].nag03,
                     '1',g_nag[i].nag05,g_nag[i].nag06,g_legal)
              IF SQLCA.sqlcode THEN
                 CALL s_errmsg('nag01 ',g_naf.naf01,'ins nag',SQLCA.sqlcode,1)
                 LET g_success = 'N'
              END IF
              INSERT INTO nah_file(nah01,nah02,nah03,nah04,nahlegal)
              VALUES(g_naf.naf01,g_nag[i].nag02,g_nah[j].nah03,'1',g_legal)
              IF SQLCA.sqlcode THEN
                 CALL s_errmsg('nah01 ',g_naf.naf01,'ins nah',SQLCA.sqlcode,1)
                 LET g_success = 'N'
              END IF
              EXIT FOR
           END IF 
        END IF 
      END FOR 
    END FOR 
  
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF 
    CALL s_showmsg()
    CALL t301_show()   
END FUNCTION 

FUNCTION t301_hand()
DEFINE l_sum1_comp LIKE nme_file.nme08
DEFINE l_sum2_comp LIKE nme_file.nme08
DEFINE l_sum1_bank LIKE nme_file.nme08
DEFINE l_sum2_bank LIKE nme_file.nme08
DEFINE i,j         LIKE type_file.num5
DEFINE l_year      LIKE type_file.chr4
DEFINE l_month     LIKE type_file.chr4
DEFINE l_day       LIKE type_file.chr4
DEFINE l_dt        LIKE type_file.chr20
DEFINE l_date1     LIKE type_file.chr20
DEFINE l_time      LIKE type_file.chr20
DEFINE l_nag02     LIKE nag_file.nag02
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_nag       RECORD
           chk1    LIKE type_file.chr1,     
           nag04   LIKE nag_file.nag04,    
           nag02   LIKE nag_file.nag02,   
           nag03   LIKE nag_file.nag03,  
           nag05   LIKE nag_file.nag05, 
           nag06   LIKE nag_file.nag06,        
           nme05   LIKE nme_file.nme05,       
           nme16   LIKE nme_file.nme16,      
           dc1     LIKE type_file.chr1,     
           nme08   LIKE nme_file.nme08     
                   END RECORD,
       l_nah       RECORD  
           chk2    LIKE type_file.chr1,    
           nah04   LIKE nah_file.nah04,   
           nah02   LIKE nah_file.nah02,  
           nah03   LIKE nah_file.nah03, 
           nmu01   LIKE nmu_file.nmu01,    
           dc2     LIKE nmu_file.nmu09,   
           nmu10   LIKE nmu_file.nmu10   
                   END RECORD


    IF g_naf.nafconf = 'Y' THEN CALL cl_err(g_naf.naf01,'anm-339',0) RETURN END IF
    DIALOG ATTRIBUTES(UNBUFFERED)
       INPUT ARRAY g_nag  FROM s_nag.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            LET g_nag_t.* = g_nag[l_ac].* 

         AFTER FIELD chk1
            IF g_nag_t.chk1 = 'Y' AND g_nag[l_ac].chk1 = 'N' THEN
           #TQC-C50173--mod--str--
           #   CALL cl_err('','anm-346',0)
           #   LET g_nag[l_ac].chk1 = g_nag_t.chk1
               LET g_nag[l_ac].nag04 =  NULL
           #TQC-C50173--mod--end
            END IF 
       END INPUT

       INPUT ARRAY g_nah FROM s_nah.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            LET g_nah_t.*=g_nah[l_ac].*

         AFTER FIELD chk2
            IF g_nah_t.chk2 = 'Y' AND g_nah[l_ac].chk2 = 'N' THEN
           #TQC-C50173--mod-str--
           #   CALL cl_err('','anm-346',0)
           #   LET g_nah[l_ac].chk2 = g_nah_t.chk2
               LET g_nah[l_ac].nah04=NULL 
           #TQC-C50173--mod--end
            END IF
       END INPUT

       ON ACTION accept
          ACCEPT DIALOG

       ON ACTION cancel
          EXIT DIALOG


       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

    END DIALOG

    CALL t301_create_temp()

    FOR i= 1 TO g_rec_b1
        IF g_nag[i].nag04 = '1' THEN CONTINUE FOR END IF  
       #TQC-C50173--mark--str--
       #IF g_nag[i].chk1 = 'Y' THEN
       #   SELECT COUNT(*) INTO l_cnt FROM nag_file WHERE nag01 = g_naf.naf01
       #      AND nag02 = g_nag[i].nag02
       #   IF l_cnt<=0 THEN
       #      INSERT INTO t301_nag(chk1,nag04,nag02,nag03,nag05,nag06,nme05,
       #                           nme16,dc1,nme08)
       #       VALUES(g_nag[i].chk1,g_nag[i].nag04,g_nag[i].nag02,g_nag[i].nag03,
       #              g_nag[i].nag05,g_nag[i].nag06,g_nag[i].nme05,g_nag[i].nme16,
       #              g_nag[i].dc1,g_nag[i].nme08)
       #   END IF
       #END IF 
       #TQC-C50173--mark--end
       #TQC-C50173--add--str--
       IF g_nag[i].chk1 = 'N' AND NOT cl_null(g_nag[i].nag02) THEN  ##取消對帳
          DELETE FROM nag_file WHERE nag01 = g_naf.naf01 AND nag02 = g_nag[i].nag02
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nag01 ',g_naf.naf01,'del nag',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          DELETE FROM nah_file WHERE nah01 = g_naf.naf01 AND nah02 = g_nag[i].nag02
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nah01 ',g_naf.naf01,'del nah',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       ELSE
          IF g_nag[i].chk1 = 'Y' AND cl_null(g_nag[i].nag02) THEN ##第一次對帳 
             INSERT INTO t301_nag(chk1,nag04,nag02,nag03,nag05,nag06,nme05,
                                   nme16,dc1,nme08)
               VALUES(g_nag[i].chk1,g_nag[i].nag04,g_nag[i].nag02,g_nag[i].nag03,
                      g_nag[i].nag05,g_nag[i].nag06,g_nag[i].nme05,g_nag[i].nme16,
                      g_nag[i].dc1,g_nag[i].nme08)
          ELSE
             IF g_nag[i].chk1 = 'Y' AND NOT cl_null(g_nag[i].nag02) AND cl_null(g_nag[i].nag04) THEN ##重新對帳
                DELETE FROM nag_file WHERE nag01 = g_naf.naf01 AND nag02 = g_nag[i].nag02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('nag01 ',g_naf.naf01,'del nag',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
                DELETE FROM nah_file WHERE nah01 = g_naf.naf01 AND nah02 = g_nag[i].nag02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('nah01 ',g_naf.naf01,'del nah',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
                INSERT INTO t301_nag(chk1,nag04,nag02,nag03,nag05,nag06,nme05,
                                   nme16,dc1,nme08)
                VALUES(g_nag[i].chk1,g_nag[i].nag04,g_nag[i].nag02,g_nag[i].nag03,
                       g_nag[i].nag05,g_nag[i].nag06,g_nag[i].nme05,g_nag[i].nme16,
                       g_nag[i].dc1,g_nag[i].nme08) 
             END IF 
          END IF 
       END IF 
       #TQC-C50173--add--end
    END FOR
    FOR j= 1 TO g_rec_b
        IF g_nah[j].nah04 = '1' THEN CONTINUE FOR END IF
       #TQC-C50173--mark--str--
       #IF g_nah[j].chk2 = 'Y' THEN
       #   SELECT COUNT(*) INTO l_cnt FROM nah_file WHERE nah01 = g_naf.naf01
       #      AND nah02 = g_nah[j].nah02
       #   IF l_cnt<=0 THEN
       #      INSERT INTO t301_nah(chk2,nah04,nah02,nah03,nmu01,dc2,nmu10)
       #       VALUES(g_nah[j].chk2,g_nah[j].nah04,g_nah[j].nah02,g_nah[j].nah03,
       #              g_nah[j].nmu01,g_nah[j].dc2,g_nah[j].nmu10)
       #   END IF 
       #END IF 
       #TQC-C50173--mark--end
       #TQC-C50173--add--str--
       IF g_nah[j].chk2 = 'N' AND NOT cl_null(g_nah[j].nah02) THEN  ##取消對帳
          DELETE FROM nah_file WHERE nah01 = g_naf.naf01 AND nah02 = g_nah[j].nah02
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nah01 ',g_naf.naf01,'del nah',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          DELETE FROM nag_file WHERE nag01 = g_naf.naf01 AND nag02 = g_nah[j].nah02
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nag01 ',g_naf.naf01,'del nag',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       ELSE
          IF g_nah[j].chk2 = 'Y' AND cl_null(g_nah[j].nah02) THEN ##第一次對帳
             INSERT INTO t301_nah(chk2,nah04,nah02,nah03,nmu01,dc2,nmu10)
              VALUES(g_nah[j].chk2,g_nah[j].nah04,g_nah[j].nah02,g_nah[j].nah03,
                     g_nah[j].nmu01,g_nah[j].dc2,g_nah[j].nmu10)
          ELSE
             IF g_nah[j].chk2 = 'Y' AND NOT cl_null(g_nah[j].nah02) AND cl_null(g_nah[j].nah04) THEN ##重
                DELETE FROM nah_file WHERE nah01 = g_naf.naf01 AND nah02 = g_nah[j].nah02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('nah01 ',g_naf.naf01,'del nah',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
                DELETE FROM nag_file WHERE nag01 = g_naf.naf01 AND nag02 = g_nah[j].nah02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('nag01 ',g_naf.naf01,'del nag',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
                INSERT INTO t301_nah(chk2,nah04,nah02,nah03,nmu01,dc2,nmu10)
                 VALUES(g_nah[j].chk2,g_nah[j].nah04,g_nah[j].nah02,g_nah[j].nah03,
                        g_nah[j].nmu01,g_nah[j].dc2,g_nah[j].nmu10)
             END IF
          END IF
       END IF
       #TQC-C50173--add--end
    END FOR
    SELECT SUM(nme08) INTO l_sum1_comp FROM t301_nag
     WHERE dc1 = '1'
    IF cl_null(l_sum1_comp) THEN LET l_sum1_comp = 0 END IF 
    SELECT SUM(nme08) INTO l_sum2_comp FROM t301_nag
     WHERE dc1 = '2'
    IF cl_null(l_sum2_comp) THEN LET l_sum2_comp = 0 END IF 
    SELECT SUM(nmu10) INTO l_sum1_bank FROM t301_nah
     WHERE dc2 = '1'
    IF cl_null(l_sum1_bank) THEN LET l_sum1_bank = 0 END IF 
    SELECT SUM(nmu10) INTO l_sum2_bank FROM t301_nah
     WHERE dc2 = '-1'
    IF cl_null(l_sum2_bank) THEN LET l_sum2_bank = 0 END IF 

    INITIALIZE l_nag.* TO NULL
    INITIALIZE l_nah.* TO NULL

    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()
    IF (l_sum1_comp = l_sum1_bank) AND (l_sum2_comp = l_sum2_bank) THEN
       #對帳流水號
       LET l_date1 = g_today
       #LET l_year = YEAR(l_date1)USING '&&&&'
       #LET l_month = MONTH(l_date1) USING '&&'
       LET l_year = g_naf.naf03
       LET l_month = g_naf.naf04 USING '&&'
       LET l_day = DAY(l_date1) USING  '&&'
       LET l_time = TIME(CURRENT)
       LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                    l_time[1,2],l_time[4,5],l_time[7,8]
       SELECT MAX(nag02) + 1 INTO l_nag02 FROM nag_file
        WHERE nag02[1,14] = l_dt
          AND nag01 = g_naf.naf01
       IF cl_null(l_nag02) THEN
          LET l_nag02 = l_dt,'000001'
       END IF

       DECLARE t301_sel_nag CURSOR FOR
        SELECT * FROM t301_nag
       FOREACH t301_sel_nag INTO l_nag.* 
          IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF 
          INSERT INTO nag_file(nag01,nag02,nag03,nag04,nag05,nag06,naglegal)
             VALUES(g_naf.naf01,l_nag02,l_nag.nag03,
                     '2',l_nag.nag05,l_nag.nag06,g_legal)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nag01 ',g_naf.naf01,'ins nag',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF 
       END FOREACH

       DECLARE t301_sel_nah CURSOR FOR
        SELECT * FROM t301_nah
       FOREACH t301_sel_nah INTO l_nah.*
          IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLca.sqlcode,1) EXIT FOREACH END IF
          INSERT INTO nah_file(nah01,nah02,nah03,nah04,nahlegal)
             VALUES(g_naf.naf01,l_nag02,l_nah.nah03,'2',g_legal)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('nah01 ',g_naf.naf01,'ins nah',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
       END FOREACH
    ELSE
       CALL cl_err('','anm-338',0)
       CALL t301_show()
       RETURN
    END IF  

    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF 

    CALL s_showmsg()
    CALL t301_show()
END FUNCTION

FUNCTION t301_create_temp()
    DROP TABLE t301_nag
    CREATE TEMP TABLE t301_nag(
           chk1      LIKE type_file.chr1, 
           nag04     LIKE nag_file.nag04,
           nag02     LIKE nag_file.nag02, 
           nag03     LIKE nag_file.nag03, 
           nag05     LIKE nag_file.nag05, 
           nag06     LIKE nag_file.nag06, 
           nme05     LIKE nme_file.nme05, 
           nme16     LIKE nme_file.nme16, 
           dc1       LIKE type_file.chr1, 
           nme08     LIKE nme_file.nme08);
    DROP TABLE t301_nah
    CREATE TEMP TABLE t301_nah(
           chk2      LIKE type_file.chr1, 
           nah04     LIKE nah_file.nah04, 
           nah02     LIKE nah_file.nah02,
           nah03     LIKE nah_file.nah03, 
           nmu01     LIKE nmu_file.nmu01, 
           dc2       LIKE nmu_file.nmu09, 
           nmu10     LIKE nmu_file.nmu10);

     
END FUNCTION

FUNCTION t301_comp()
DEFINE l_nag04 LIKE nag_file.nag04
DEFINE l_nah04 LIKE nah_file.nah04

     IF g_b_flag='1' OR g_b_flag IS NULL THEN
      #FUN-B50159--mod--str--
      #CALL cl_init_qry_var()
      #LET g_qryparam.form ="q_nah"
      #LET g_qryparam.arg1 =g_naf.naf01
      #LET g_qryparam.arg2 = g_nag[l_ac].nag02
      #LET g_qryparam.arg3 = g_naf.naf02
      #LET g_qryparam.construct = 'N'
      #CALL cl_create_qry()
      #RETURNING l_nah04
      CALL q_nah(FALSE,FALSE,g_naf.naf01,g_nag[l_ac].nag02,g_naf.naf02)
           RETURNING l_nah04
      #FUN-B50159--mod--end
     ELSE 
      #FUN-B50159--mod--str--
      #CALL cl_init_qry_var()
      #LET g_qryparam.form ="q_nag"
      #LET g_qryparam.arg1 =g_naf.naf01
      #LET g_qryparam.arg2 =g_nah[l_ac].nah02
      #LET g_qryparam.arg3 = g_naf.naf02
      #LET g_qryparam.construct = 'N'
      #CALL cl_create_qry()
      #RETURNING l_nag04
      CALL q_nag(FALSE,FALSE,g_naf.naf01,g_nah[l_ac].nah02,g_naf.naf02)
           RETURNING l_nag04
      #FUN-B50159--mod--end
     END IF
END FUNCTION 
#FUN-B30166

