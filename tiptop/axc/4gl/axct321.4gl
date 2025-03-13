# Prog. Version..: '5.30.06-13.04.25(00009)'     #
# Pattern name.... axct321.4gl
# Descriptions.... 工单发料分录结转作业
# Date & Author... 2010/07/02 By wujie #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:FUN-BB0038 11/11/14 By elva 成本改善
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C70264 12/07/27 By yinhy 刪除時報語法錯誤
# Modify.........: No.FUN-CB0120 12/12/28 By wangrr 增加欄位cdg13工單類型
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No.FUN-D20040 13/02/19 By wujie 第一单身增加工单的部门厂商栏位
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50021 13/05/16 By fengmy 刪除時未考慮cdg00,cdh00 
# Modify.........: No:FUN-D60081 13/06/18 By lujh 增加excel匯出功能
# Modify.........: No:FUN-D60095 13/06/24 By max1 增加傳參
# Modify.........: No.MOD-D70099 13/07/15 By wujie 增加cdg08为key栏位
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE
    g_cdg_h         RECORD LIKE cdg_file.*,    #(假單頭)
    g_cdg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdg06            LIKE cdg_file.cdg06,
        cdg12            LIKE cdg_file.cdg12, 
        cdg07            LIKE cdg_file.cdg07,
        cdg13            LIKE cdg_file.cdg13,  #FUN-CB0120
        cdg14            LIKE cdg_file.cdg14,  #No.FUN-D20040
        cdg08            LIKE cdg_file.cdg08,
        ima02            LIKE ima_file.ima02,  
        cdg09            LIKE cdg_file.cdg09,
        aag02            LIKE aag_file.aag02,
        cdg10            LIKE cdg_file.cdg10,
        cdg11            LIKE cdg_file.cdg11,
        cdg11a           LIKE cdg_file.cdg11a,
        cdg11b           LIKE cdg_file.cdg11b,
        cdg11c           LIKE cdg_file.cdg11c,
        cdg11d           LIKE cdg_file.cdg11d,
        cdg11e           LIKE cdg_file.cdg11e,
        cdg11f           LIKE cdg_file.cdg11f,
        cdg11g           LIKE cdg_file.cdg11g,
        cdg11h           LIKE cdg_file.cdg11h
                    END RECORD,
    g_cdg_t         RECORD                 #程式變數 (舊值)
        cdg06            LIKE cdg_file.cdg06,
        cdg12            LIKE cdg_file.cdg12,
        cdg07            LIKE cdg_file.cdg07,
        cdg13            LIKE cdg_file.cdg13,  #FUN-CB0120
        cdg14            LIKE cdg_file.cdg14,  #No.FUN-D20040
        cdg08            LIKE cdg_file.cdg08,
        ima02            LIKE ima_file.ima02,  
        cdg09            LIKE cdg_file.cdg09,
        aag02            LIKE aag_file.aag02,
        cdg10            LIKE cdg_file.cdg10,
        cdg11            LIKE cdg_file.cdg11,
        cdg11a           LIKE cdg_file.cdg11a,
        cdg11b           LIKE cdg_file.cdg11b,
        cdg11c           LIKE cdg_file.cdg11c,
        cdg11d           LIKE cdg_file.cdg11d,
        cdg11e           LIKE cdg_file.cdg11e,
        cdg11f           LIKE cdg_file.cdg11f,
        cdg11g           LIKE cdg_file.cdg11g,
        cdg11h           LIKE cdg_file.cdg11h
                    END RECORD,
    g_cdh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdh07            LIKE cdh_file.cdh07,
        ima02_2          LIKE ima_file.ima02,
        cdh08            LIKE cdh_file.cdh08,
        aag02_2          LIKE aag_file.aag02, 
        cdh09            LIKE cdh_file.cdh09,
        cdh10            LIKE cdh_file.cdh10,   
        cdh10a           LIKE cdh_file.cdh10a,
        cdh10b           LIKE cdh_file.cdh10b,
        cdh10c           LIKE cdh_file.cdh10c,
        cdh10d           LIKE cdh_file.cdh10d,
        cdh10e           LIKE cdh_file.cdh10e,
        cdh10f           LIKE cdh_file.cdh10f,
        cdh10g           LIKE cdh_file.cdh10g,
        cdh10h           LIKE cdh_file.cdh10h
                    END RECORD,
    g_cdh_t         RECORD
        cdh07            LIKE cdh_file.cdh07,
        ima02_2          LIKE ima_file.ima02,
        cdh08            LIKE cdh_file.cdh08,
        ccg02_2          LIKE aag_file.aag02,
        cdh09            LIKE cdh_file.cdh09,
        cdh10            LIKE cdh_file.cdh10,   
        cdh10a           LIKE cdh_file.cdh10a,
        cdh10b           LIKE cdh_file.cdh10b,
        cdh10c           LIKE cdh_file.cdh10c,
        cdh10d           LIKE cdh_file.cdh10d,
        cdh10e           LIKE cdh_file.cdh10e,
        cdh10f           LIKE cdh_file.cdh10f,
        cdh10g           LIKE cdh_file.cdh10g,
        cdh10h           LIKE cdh_file.cdh10h
                    END RECORD,
    g_wcg_sql           string,  #No.FUN-580092 HCN
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
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
DEFINE  g_b_flag        LIKE type_file.chr1 
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_argv1         LIKE cdi_file.cdi00  #FUN-BB0038
DEFINE  g_wc1           STRING    #FUN-D60095  add

MAIN
DEFINE l_time           LIKE type_file.chr8           
DEFINE p_row,p_col      LIKE type_file.num5  

   OPTIONS                              
      INPUT NO WRAP                    
   DEFER INTERRUPT                    

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CONTINUE 
 
   #FUN-BB0038 --begin
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1='2' THEN
      LET g_prog='axct327'
   ELSE
      LET g_prog='axct328'
   END IF
   #FUN-BB0038 --end

   #FUN-D60095--add--str--
   LET g_wc1 = ARG_VAL(2)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
   #FUN-D60095--add--end-- 

   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

#   CALL cl_used(g_prog,l_time,1)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   #FUN-BB0038 --begin
   LET g_forupd_sql = "SELECT * FROM cdg_file WHERE cdg01 = ? AND cdg02 = ? AND cdg03 = ? AND cdg04 = ? "
   IF g_argv1='2' THEN
      #LET g_forupd_sql = g_forupd_sql CLIPPED," cdg00='2' FOR UPDATE"       #MOD-C70264 mark
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdg00='2' FOR UPDATE"    #MOD-C70264
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
      #LET g_forupd_sql = g_forupd_sql CLIPPED," cdg00='1' FOR UPDATE"       #MOD-C70264 mark
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdg00='1' FOR UPDATE"    #MOD-C70264
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   END IF
  #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   #FUN-BB0038 --end
   DECLARE t321_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t321_w AT p_row,p_col WITH FORM "axc/42f/axct321"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      CALL cl_set_act_visible("drill_down1",FALSE)
   END IF
   #FUN-BB0038 --end

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t321_q()
   END IF
   #FUN-D60095--add--end--

   CALL t321_menu()
   CLOSE WINDOW t321_w               

#   CALL cl_used(g_prog,l_time,2)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

#QBE 查詢資料
FUNCTION t321_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cdg.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_cdg_h.* TO NULL    
      IF cl_null(g_wc1) THEN  #FUN-D60095 add 
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON cdg04,cdg01,cdglegal,cdg02,cdg03,cdg05,cdgoriu,cdgorig
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
         END CONSTRUCT  

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cdg01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdg01
                  NEXT FIELD cdg01
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
   
   #FUN-D60095--add--str--
   IF cl_null(g_wc1) THEN
      LET g_wc1 = '1=1'
   END IF
   #FUN-D60095--add--end--
 
   LET g_sql = "SELECT UNIQUE cdg01,cdg02,cdg03,cdg04 ",
               "  FROM cdg_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND ", g_wc1 CLIPPED    #FUN-D60095 add
   #FUN-BB0038 --begin
   IF g_argv1='2' THEN
      LET g_sql = g_sql CLIPPED," AND cdg00='2'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND cdg00='1'"
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY 1,2,3,4"
   #FUN-BB0038 --end
 
   PREPARE t321_prepare FROM g_sql
   DECLARE t321_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t321_prepare
 
END FUNCTION

FUNCTION t321_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t321_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t321_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t321_r()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            CASE g_b_flag
                WHEN '1' CALL t321_b()
                WHEN '2' CALL t321_b2()
            END CASE 

         WHEN "gen_entry"
            CALL t321_v()
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cdg_h.cdg01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF            
            CALL s_fsgl('CA',3,g_cdg_h.cdg05,0,g_cdg_h.cdg01,'1',g_cdg_h.cdgconf,l_npptype,g_cdg_h.cdg05)  

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t321_drill_down()
            END IF

         WHEN "DL+OH+SUB"
            CALL t321_DL_maintain()          

         WHEN "confirm"
            CALL t321_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t321_firm1_upd()                   
            END IF
            CALL t321_show()         

         WHEN "undo_confirm" 
            CALL t321_firm2()
            CALL t321_show()

         WHEN "process_qry"  
            IF g_argv1 = '2' THEN CALL cl_cmdrun_wait("axcp327")
                             ELSE CALL cl_cmdrun_wait("axcp328")
            END IF
          # LET g_msg ="axcp321 '",g_argv1,"'"  
          # CALL cl_cmdrun_wait(g_msg)

         WHEN "carry_voucher"
            IF g_cdg_h.cdgconf ='Y' THEN
               LET g_msg ="axcp301 ",g_cdg_h.cdg05," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdg_h.cdg05 AND nppsys ='CA' AND npp00 =3 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
            END IF

         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdg_h.cdg01,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdg_h.cdg05 AND nppsys ='CA' AND npp00 =3 AND npp011 =1
            DISPLAY g_nppglno TO nppglno

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end
        #FUN-D60081--add--str--
         WHEN "exporttoexcel"
            LET g_action_choice = 'exporttoexcel'
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cdg),base.TypeInfo.create(g_cdh),'')
            END IF
         #FUN-D60081--add--end--

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t321_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cdg_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cdg.clear()
   CALL g_cdh.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t321_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t321_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdg_h.* TO NULL
   ELSE
      CALL t321_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t321_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t321_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t321_cs INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
      WHEN 'P' FETCH PREVIOUS t321_cs INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
      WHEN 'F' FETCH FIRST    t321_cs INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
      WHEN 'L' FETCH LAST     t321_cs INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
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
         FETCH ABSOLUTE g_jump t321_cs INTO g_cdg_h.cdg01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdg_h.cdg01,SQLCA.sqlcode,0)
      INITIALIZE g_cdg_h.* TO NULL  #TQC-6B0105
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
   #MOD-D50021--begin
   IF g_argv1='2' THEN
      SELECT  DISTINCT cdg01,cdg02,cdg03,cdg04,cdg05,cdglegal,cdgconf,cdgoriu,cdgorig INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,g_cdg_h.cdg05,g_cdg_h.cdglegal,g_cdg_h.cdgconf,g_cdg_h.cdgoriu,g_cdg_h.cdgorig
        FROM  cdg_file WHERE cdg01 = g_cdg_h.cdg01 AND cdg02 = g_cdg_h.cdg02 AND cdg03 = g_cdg_h.cdg03 AND cdg04 = g_cdg_h.cdg04
         AND  cdg00='2'
   ELSE
      SELECT  DISTINCT cdg01,cdg02,cdg03,cdg04,cdg05,cdglegal,cdgconf,cdgoriu,cdgorig INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,g_cdg_h.cdg05,g_cdg_h.cdglegal,g_cdg_h.cdgconf,g_cdg_h.cdgoriu,g_cdg_h.cdgorig
        FROM  cdg_file WHERE cdg01 = g_cdg_h.cdg01 AND cdg02 = g_cdg_h.cdg02 AND cdg03 = g_cdg_h.cdg03 AND cdg04 = g_cdg_h.cdg04
         AND  cdg00='1'
   END IF
  #SELECT  DISTINCT cdg01,cdg02,cdg03,cdg04,cdg05,cdglegal,cdgconf,cdgoriu,cdgorig INTO g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,g_cdg_h.cdg05,g_cdg_h.cdglegal,g_cdg_h.cdgconf,
  #  FROM  cdg_file WHERE cdg01 = g_cdg_h.cdg01 AND cdg02 = g_cdg_h.cdg02 AND cdg03 = g_cdg_h.cdg03 AND cdg04 = g_cdg_h.cdg04
   #MOD-D50021--end
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdg_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdg_h.* TO NULL
      RETURN
   ELSE   
      CALL t321_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t321_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME g_cdg_h.cdgoriu,g_cdg_h.cdgorig,
          g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,
          g_cdg_h.cdg05,g_cdg_h.cdglegal,g_cdg_h.cdgconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdg_h.cdglegal
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdg_h.cdg05 AND nppsys ='CA' AND npp00 =3 AND npp011 =1
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL cl_set_field_pic(g_cdg_h.cdgconf,"","","","","")
   CALL t321_b_fill()                 #單身
   CALL t321_b2_fill()                #單身
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t321_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cdg_h.cdg01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cdg_h.cdgconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t321_cl USING g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
   IF STATUS THEN
      CALL cl_err("OPEN t321_cl.", STATUS, 1)
      CLOSE t321_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t321_cl INTO g_cdg_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdg_h.cdg01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t321_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "cdg01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 =  g_cdg_h.cdg01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      LET l_cnt = 0
      #MOD-D50021--begin
      IF g_argv1='2' THEN
         SELECT COUNT(*) INTO l_cnt 
           FROM cdg_file
          WHERE cdg01 = g_cdg_h.cdg01 
            AND cdg02 = g_cdg_h.cdg02
            AND cdg03 = g_cdg_h.cdg03
            AND cdg04 = g_cdg_h.cdg04
            AND cdg00 = '2'
      ELSE
         SELECT COUNT(*) INTO l_cnt 
           FROM cdg_file
          WHERE cdg01 = g_cdg_h.cdg01 
            AND cdg02 = g_cdg_h.cdg02
            AND cdg03 = g_cdg_h.cdg03
            AND cdg04 = g_cdg_h.cdg04
            AND cdg00 = '1'
      END IF
     #SELECT COUNT(*) INTO l_cnt 
     #  FROM cdg_file
     # WHERE cdg01 = g_cdg_h.cdg01 
     #   AND cdg02 = g_cdg_h.cdg02
     #   AND cdg03 = g_cdg_h.cdg03
     #   AND cdg04 = g_cdg_h.cdg04
      #MOD-D50021--end
      IF l_cnt > 0 THEN
         #MOD-D50021--begin
         IF g_argv1='2' THEN
            DELETE FROM cdg_file
             WHERE cdg01 = g_cdg_h.cdg01
               AND cdg02 = g_cdg_h.cdg02
               AND cdg03 = g_cdg_h.cdg03
               AND cdg04 = g_cdg_h.cdg04
               AND cdg00 = '2'
         ELSE
            DELETE FROM cdg_file
             WHERE cdg01 = g_cdg_h.cdg01
               AND cdg02 = g_cdg_h.cdg02
               AND cdg03 = g_cdg_h.cdg03
               AND cdg04 = g_cdg_h.cdg04
               AND cdg00 = '1'
         END IF
        # DELETE FROM cdg_file
        #  WHERE cdg01 = g_cdg_h.cdg01
        #    AND cdg02 = g_cdg_h.cdg02
        #    AND cdg03 = g_cdg_h.cdg03
        #    AND cdg04 = g_cdg_h.cdg04
         #MOD-D50021--end
            
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdg_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","del cdg.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      #MOD-D50021--begin
      IF g_argv1='2' THEN
         SELECT COUNT(*) INTO l_cnt
           FROM cdh_file
          WHERE cdh01 = g_cdg_h.cdg01
            AND cdh02 = g_cdg_h.cdg02
            AND cdh03 = g_cdg_h.cdg03
            AND cdh04 = g_cdg_h.cdg04
            AND cdh00 ='2'
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM cdh_file
          WHERE cdh01 = g_cdg_h.cdg01
            AND cdh02 = g_cdg_h.cdg02
            AND cdh03 = g_cdg_h.cdg03
            AND cdh04 = g_cdg_h.cdg04
            AND cdh00 ='1'
      END IF
     # SELECT COUNT(*) INTO l_cnt
     #   FROM cdh_file
     #  WHERE cdh01 = g_cdg_h.cdg01
     #    AND cdh02 = g_cdg_h.cdg02
     #    AND cdh03 = g_cdg_h.cdg03
     #    AND cdh04 = g_cdg_h.cdg04
      #MOD-D50021--end
         
      IF l_cnt > 0 THEN
         #MOD-D50021--begin
         IF g_argv1='2' THEN
            DELETE FROM cdh_file
             WHERE cdh01 = g_cdg_h.cdg01
               AND cdh02 = g_cdg_h.cdg02
               AND cdh03 = g_cdg_h.cdg03
               AND cdh04 = g_cdg_h.cdg04
               AND cdh00 = '2'
         ELSE
            DELETE FROM cdh_file
             WHERE cdh01 = g_cdg_h.cdg01
               AND cdh02 = g_cdg_h.cdg02
               AND cdh03 = g_cdg_h.cdg03
               AND cdh04 = g_cdg_h.cdg04
               AND cdh00 = '1'
         END IF
        # DELETE FROM cdh_file
        #  WHERE cdh01 = g_cdg_h.cdg01
        #    AND cdh02 = g_cdg_h.cdg02
        #    AND cdh03 = g_cdg_h.cdg03
        #    AND cdh04 = g_cdg_h.cdg04
         #MOD-D50021--end

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdh_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","del cdf",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add

      LET l_cnt = 0
      #MOD-D50021--begin
      IF g_argv1='2' THEN
         SELECT COUNT(*) INTO l_cnt
           FROM cdi_file
          WHERE cdi01 = g_cdg_h.cdg01
            AND cdi02 = g_cdg_h.cdg02
            AND cdi03 = g_cdg_h.cdg03
            AND cdi04 = g_cdg_h.cdg04
            AND cdi00 = '2'
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM cdi_file
          WHERE cdi01 = g_cdg_h.cdg01
            AND cdi02 = g_cdg_h.cdg02
            AND cdi03 = g_cdg_h.cdg03
            AND cdi04 = g_cdg_h.cdg04
            AND cdi00 = '1'
      END IF
     # SELECT COUNT(*) INTO l_cnt
     #   FROM cdi_file
     #  WHERE cdi01 = g_cdg_h.cdg01
     #    AND cdi02 = g_cdg_h.cdg02
     #    AND cdi03 = g_cdg_h.cdg03
     #    AND cdi04 = g_cdg_h.cdg04
      #MOD-D50021--end
         
      IF l_cnt > 0 THEN
         #MOD-D50021--begin
         IF g_argv1='2' THEN
            DELETE FROM cdi_file
             WHERE cdi01 = g_cdg_h.cdg01
               AND cdi02 = g_cdg_h.cdg02
               AND cdi03 = g_cdg_h.cdg03
               AND cdi04 = g_cdg_h.cdg04
               AND cdi00 = '2'
         ELSE
            DELETE FROM cdi_file
             WHERE cdi01 = g_cdg_h.cdg01
               AND cdi02 = g_cdg_h.cdg02
               AND cdi03 = g_cdg_h.cdg03
               AND cdi04 = g_cdg_h.cdg04
               AND cdi00 = '1'
         END IF
        # DELETE FROM cdi_file
        #  WHERE cdi01 = g_cdg_h.cdg01
        #    AND cdi02 = g_cdg_h.cdg02
        #    AND cdi03 = g_cdg_h.cdg03
        #    AND cdi04 = g_cdg_h.cdg04
         #MOD-D50021--end

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdi_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","del cdi.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_cdg_h.cdg05
         AND nppsys= 'CA'
         AND npp00 = 3
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cdg_h.cdg05
            AND nppsys= 'CA'
            AND npp00 = 3
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cdg_h.cdg05
         AND npqsys= 'CA'
         AND npq00 = 3
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cdg_h.cdg05
            AND npqsys= 'CA'
            AND npq00 = 3
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_cdg_h.cdg01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      #FUN-B40056  --begin
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_cdg_h.cdg05
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cdg_h.cdg05
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_cdg_h.cdg05,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056  --end
      INITIALIZE g_cdg_h.* TO NULL
      CLEAR FORM
      CALL g_cdg.clear()
      CALL g_cdh.clear()
      CALL t321_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t321_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t321_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t321_fetch('/')
      END IF
   END IF
   CLOSE t321_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cdg_h.cdg01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t321_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
       

   LET g_action_choice = ""
   IF g_cdg_h.cdg01 IS NULL THEN RETURN END IF
   IF g_cdg_h.cdgconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdg06,cdg12,cdg07,cdg13,cdg14,cdg08,'',cdg09,'',", #FUN-CB0120 add cdg13   #No.FUN-D20040 add cdg14
                      "       cdg10,cdg11,cdg11a,cdg11b,cdg11c,cdg11d,",
                      "       cdg11e,cdg11f,cdg11g,cdg11h ", 
                      " FROM cdg_file",
   #FUN-BB0038 --begin
                     #" WHERE cdg01=? AND cdg02=? AND cdg03 = ? AND cdg04 = ? AND cdg06 = ? AND cdg07 = ? FOR UPDATE"
                      " WHERE cdg01=? AND cdg02=? AND cdg03 = ? AND cdg04 = ? AND cdg06 = ? AND cdg07 = ? AND cdg08 = ? "   #No.MOD-D70099 add cdg08
   IF g_argv1='2' THEN
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdg00='2' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdg00='1' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   END IF
   #FUN-BB0038 --end
   DECLARE t321_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdg WITHOUT DEFAULTS FROM s_cdg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_cdg_t.* = g_cdg[l_ac].*  #BACKUP
             OPEN t321_b2cl USING g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,g_cdg_t.cdg06,g_cdg_t.cdg07,g_cdg_t.cdg08   #No.MOD-D70099 ad cdg08 
             IF STATUS THEN
                CALL cl_err("OPEN t321_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t321_b2cl INTO g_cdg[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdg_h.cdg02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdg[l_ac].aag02 FROM aag_file WHERE aag01 = g_cdg[l_ac].cdg09 AND aag00 = g_cdg_h.cdg01
             SELECT ima02 INTO g_cdg[l_ac].ima02 FROM ima_file WHERE ima01 = g_cdg[l_ac].cdg08
             NEXT FIELD cdg09
          END IF

       BEFORE INSERT  
       
       AFTER INSERT 
         
       AFTER FIELD cdg09           
          IF g_cdg[l_ac].cdg09 IS NULL THEN
             LET g_cdg[l_ac].cdg09 = g_cdg_t.cdg09
             NEXT FIELD cdg09
          END IF
          IF g_cdg_t.cdg09 IS NULL OR g_cdg[l_ac].cdg09 <> g_cdg_t.cdg09 THEN 
             SELECT aag02 INTO g_cdg[l_ac].aag02
               FROM aag_file 
              WHERE aag01 = g_cdg[l_ac].cdg09 
                AND aag00 = g_cdg_h.cdg01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdg[l_ac].cdg09,SQLCA.sqlcode,1)
                LET g_cdg[l_ac].cdg09 = g_cdg_t.cdg09
                NEXT FIELD cdg09
             END IF 
          END IF 
 

       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac       #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D40030--add--str--
             IF p_cmd = 'u' THEN
                LET g_cdg[l_ac].* = g_cdg_t.*
             ELSE
                CALL g_cdg.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                   LET g_b_flag = '1'
                END IF
             END IF
             #FUN-D40030--add--end--
             CLOSE t321_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac       #FUN-D40030 Add
          CLOSE t321_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdg[l_ac].* = g_cdg_t.*
             CLOSE t321_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdg[l_ac].cdg07,-263,1)
             LET g_cdg[l_ac].* = g_cdg_t.*
          ELSE  
             UPDATE cdg_file SET cdg09 = g_cdg[l_ac].cdg09
              WHERE cdg01 = g_cdg_h.cdg01 
                AND cdg02 = g_cdg_h.cdg02
                AND cdg03 = g_cdg_h.cdg03
                AND cdg04 = g_cdg_h.cdg04 
                AND cdg06 = g_cdg_t.cdg06 
                AND cdg07 = g_cdg_t.cdg07
                AND cdg08 = g_cdg_t.cdg08   #No.MOD-D70099

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdg_file",g_cdg_h.cdg01,g_cdg_h.cdg02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdg[l_ac].* = g_cdg_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
    
 
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(cdg09) AND l_ac > 1 THEN
          END IF
 

       ON ACTION CONTROLP
          IF INFIELD(cdg09) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdg_h.cdg01
             LET g_qryparam.default1 = g_cdg[l_ac].cdg09
             CALL cl_create_qry() RETURNING g_cdg[l_ac].cdg09
             DISPLAY g_cdg[l_ac].cdg09 TO cdg09
             NEXT FIELD cdg09
          END IF  
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
 
       ON IDLE g_idle_seconds
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
   END INPUT
  
   CLOSE t321_b2cl
 
END FUNCTION

FUNCTION t321_b2()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
DEFINE l_cdg           RECORD LIKE cdg_file.*

   LET g_action_choice = ""
   IF g_cdg_h.cdg01 IS NULL THEN RETURN END IF
   IF g_cdg_h.cdgconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdh07,'',cdh08,'',cdh09,cdh10,cdh10a,cdh10b,cdh10c,cdh10d,cdh10e,cdh10f,cdh10g,cdh10h ", 
                      " FROM cdh_file",
   #FUN-BB0038 --begin
                     #" WHERE cdh01=? AND cdh02=? AND cdh03 = ? AND cdh04 = ? and cdh05 = ? AND cdh06 = ? AND cdh07 = ? FOR UPDATE"
                      " WHERE cdh01=? AND cdh02=? AND cdh03 = ? AND cdh04 = ? and cdh05 = ? AND cdh06 = ? AND cdh07 = ? "
   IF g_argv1='2' THEN
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdh00='2' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdh00='1' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   END IF
   #FUN-BB0038 --end
   DECLARE t321_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdh WITHOUT DEFAULTS FROM s_cdh.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
           OPEN t321_cl USING g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
           IF STATUS THEN
              CALL cl_err("OPEN t321_cl.", STATUS, 1)
              CLOSE t321_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t321_cl INTO l_cdg.*              # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_cdg_h.cdg01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t321_cl
              ROLLBACK WORK
              RETURN
           END IF

          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_cdh_t.* = g_cdh[l_ac].*  #BACKUP
             OPEN t321_bcl USING g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04,g_cdg_h.cdg06,g_cdg_h.cdg07,g_cdh_t.cdh07
             IF STATUS THEN
                CALL cl_err("OPEN t321_bcl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t321_bcl INTO g_cdh[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdh_t.cdh07,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdh[l_ac].aag02_2 FROM aag_file WHERE aag01 = g_cdh[l_ac].cdh08 AND aag00 = g_cdg_h.cdg01
             SELECT ima02 INTO g_cdh[l_ac].ima02_2 FROM ima_file WHERE ima01 = g_cdh[l_ac].cdh07
             NEXT FIELD cdh08
          END IF
 
       BEFORE INSERT
 
       AFTER INSERT
 
       AFTER FIELD cdh08           
          IF g_cdh[l_ac].cdh08 IS NULL THEN
             LET g_cdh[l_ac].cdh08 = g_cdh_t.cdh08
             NEXT FIELD cdg08
          END IF
          IF g_cdh_t.cdh08 IS NULL OR g_cdh[l_ac].cdh08 <> g_cdh_t.cdh08 THEN 
             SELECT aag02 INTO g_cdh[l_ac].aag02_2
               FROM aag_file 
              WHERE aag01 = g_cdh[l_ac].cdh08 
                 AND aag00 = g_cdg_h.cdg01

             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdh[l_ac].cdh08,SQLCA.sqlcode,1)
                LET g_cdh[l_ac].cdh08 = g_cdh_t.cdh08
                NEXT FIELD cdh08
             END IF 
          END IF 
 
       BEFORE DELETE                            #是否取消單身
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdh[l_ac].* = g_cdh_t.*
             CLOSE t321_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdh[l_ac].cdh07,-263,1)
             LET g_cdh[l_ac].* = g_cdh_t.*
          ELSE                                                                                                              
             UPDATE cdh_file SET cdh08 = g_cdh[l_ac].cdh08
              WHERE cdh01 = g_cdg_h.cdg01 
                AND cdh02 = g_cdg_h.cdg02
                AND cdh03 = g_cdg_h.cdg03
                AND cdh04 = g_cdg_h.cdg04
                AND cdh05 = g_cdg_h.cdg06
                AND cdh06 = g_cdg_h.cdg07
                AND cdh07 = g_cdh_t.cdh07
                
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdh_file",g_cdh_t.cdh07,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdh[l_ac].* = g_cdh_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
    
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac     #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_cdh[l_ac].* = g_cdh_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_cdh.deleteElement(l_ac)
                IF g_rec_b2 != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                   LET g_b_flag = '2'
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE t321_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 Add
          CLOSE t321_bcl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(cdh08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag02"
               LET g_qryparam.arg1 = g_cdg_h.cdg01 
               LET g_qryparam.default1 = g_cdh[l_ac].cdh08
               CALL cl_create_qry() RETURNING g_cdh[l_ac].cdh08 
               DISPLAY g_cdh[l_ac].cdh08 TO cdh08
               NEXT FIELD cdh08
             OTHERWISE
                EXIT CASE
       END CASE
 
 
       ON ACTION CONTROLO                        #沿用所有欄位
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
     
   CLOSE t321_bcl
 
END FUNCTION
 
FUNCTION t321_b_fill()
    
 
   LET g_sql =  "SELECT cdg06,cdg12,cdg07,cdg13,cdg14,cdg08,'',cdg09,'',", #FUN-CB0120 add cdg13   No.FUN-D20040 add cdg14
                "       cdg10,cdg11,cdg11a,cdg11b,cdg11c,cdg11d,",
                "       cdg11e,cdg11f,cdg11g,cdg11h ",
                "  FROM cdg_file",
                " WHERE cdg01 ='",g_cdg_h.cdg01,"'",
                "   AND cdg02 ='",g_cdg_h.cdg02,"'",
                "   AND cdg03 ='",g_cdg_h.cdg03,"'",
                "   AND cdg04 ='",g_cdg_h.cdg04,"'" 
   #FUN-BB0038 --begin
   IF g_argv1='2' THEN
      LET g_sql = g_sql CLIPPED," AND cdg00='2'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND cdg00='1'"
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY 1,2,3,5"
   #FUN-BB0038 --end
    PREPARE t321_pb FROM g_sql
    DECLARE cdg_curs CURSOR FOR t321_pb
 
    CALL g_cdg.clear()
    LET g_cnt = 1
    FOREACH cdg_curs INTO g_cdg[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cdg[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cdg[g_cnt].cdg09 AND aag00 = g_cdg_h.cdg01
       SELECT ima02 INTO g_cdg[g_cnt].ima02 FROM ima_file WHERE ima01 = g_cdg[g_cnt].cdg08
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdg.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t321_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()

   DIALOG ATTRIBUTES(UNBUFFERED) 
   
      DISPLAY ARRAY g_cdg TO s_cdg.*  ATTRIBUTE(COUNT=g_rec_b)         
      BEFORE DISPLAY
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='1'
                        
         BEFORE ROW
            LET l_ac = ARR_CURR() 
            LET l_ac1 = l_ac
            CALL cl_show_fld_cont()      
            LET g_cdg_h.cdg06 = g_cdg[l_ac].cdg06
            LET g_cdg_h.cdg07 = g_cdg[l_ac].cdg07
            CALL t321_b2_fill()
         
         AFTER DISPLAY
            CONTINUE DIALOG
                        
      END DISPLAY
      
      DISPLAY ARRAY g_cdh TO s_cdh.*  ATTRIBUTE(COUNT=g_rec_b2)       
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL cl_show_fld_cont()
            LET g_b_flag='2'
            
         BEFORE ROW
            LET l_ac = ARR_CURR()    
      
      END DISPLAY 
  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
 
      ON ACTION first
         CALL t321_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL t321_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL t321_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL t321_fetch('N')
         EXIT DIALOG
 
      ON ACTION last
         CALL t321_fetch('L')
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG
                  
      ON ACTION gen_entry 
         LET g_action_choice="gen_entry"
         EXIT DIALOG
 
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"        #No.FUN-A60024
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
                                                         
      ON ACTION drill_down1                                                      
         LET g_action_choice="drill_down1"                                       
         EXIT DIALOG     
      
      ON ACTION DL_OH_SUB_maintain  
         LET g_action_choice="DL+OH+SUB"                                       
         EXIT DIALOG  

      ON ACTION confirm #確認
         LET g_action_choice="confirm"
         EXIT DIALOG
          
      ON ACTION undo_confirm #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DIALOG

      ON action process_qry 
         LET g_action_choice="process_qry"
         EXIT DIALOG 

      ON action carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DIALOG

      ON action undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DIALOG

#No.FUN-CC0001 --begin
      ON action voucher_qry
         LET g_action_choice="voucher_qry"
         EXIT DIALOG
#No.FUN-CC0001 --end
               
      #FUN-D60081--add--str--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      #FUN-D60081--add--end--
   
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t321_b2_fill()              #BODY FILL UP

    LET g_sql = "SELECT cdh07,'',cdh08,'',cdh09,cdh10,cdh10a,cdh10b,cdh10c,cdh10d,cdh10e,cdh10f,cdh10g,cdh10h",   
                "  FROM cdh_file",
                " WHERE cdh01 ='",g_cdg_h.cdg01,"'",
                "   AND cdh02 ='",g_cdg_h.cdg02,"'",
                "   AND cdh03 ='",g_cdg_h.cdg03,"'",
                "   AND cdh04 ='",g_cdg_h.cdg04,"'",
                "   AND cdh05 ='",g_cdg_h.cdg06,"'",
                "   AND cdh06 ='",g_cdg_h.cdg07,"'" 
   #FUN-BB0038 --begin
   IF g_argv1='2' THEN
      LET g_sql = g_sql CLIPPED," AND cdh00='2'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND cdh00='1'"
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY cdh07,cdh08"
   #FUN-BB0038 --end
    PREPARE t321_pb2 FROM g_sql
    DECLARE cdh_curs CURSOR FOR t321_pb2
 
    CALL g_cdh.clear()
    LET g_cnt = 1
    FOREACH cdh_curs INTO g_cdh[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach.',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT aag02 INTO g_cdh[g_cnt].aag02_2 FROM aag_file
          WHERE aag01 = g_cdh[g_cnt].cdh08 
            AND aag00 = g_cdg_h.cdg01
       SELECT ima02 INTO g_cdh[g_cnt].ima02_2 FROM ima_file WHERE ima01 = g_cdh[g_cnt].cdh07
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_cdh.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION

 
FUNCTION t321_v()
DEFINE  l_wc        STRING

   IF g_cdg_h.cdgconf ='Y' THEN RETURN END IF
   LET l_wc = "cdg01 ='",g_cdg_h.cdg01,"' AND cdg02 ='",g_cdg_h.cdg02,"' AND cdg03 ='",g_cdg_h.cdg03,"' AND cdg04 = '",g_cdg_h.cdg04,"'"
   LET g_success ='Y'
   CALL p321_gl(g_argv1,l_wc,g_cdg_h.cdg01)  #FUN-BB0038 add g_argv1
   IF g_success ='N' THEN 
      RETURN  
   END IF 
   CALL t321_show()
   MESSAGE " "
END FUNCTION

                                                         
FUNCTION t321_drill_down()                                                      
   IF cl_null(l_ac1) THEN RETURN END IF                                                                              
   IF cl_null(g_cdg[l_ac1].cdg07) THEN RETURN END IF                                   
   LET g_msg = "axcq772 '",g_cdg[l_ac1].cdg07,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t321_count()
 
   DEFINE l_cdg   DYNAMIC ARRAY of RECORD        # 程式變數
          cdg01          LIKE cdg_file.cdg01, 
          cdg02          LIKE cdg_file.cdg02,          
          cdg03          LIKE cdg_file.cdg03,
          cdg04          LIKE cdg_file.cdg04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE cdg01,cdg02,cdg03,cdg04 FROM cdg_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED,
              "   AND ",g_wc1 CLIPPED    #FUN-D60095 add
   #FUN-BB0038 --begin
   IF g_argv1='2' THEN
      LET g_sql = g_sql CLIPPED," AND cdg00='2'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND cdg00='1'"
   END IF
   #FUN-BB0038 --end
   PREPARE t321_precount FROM g_sql
   DECLARE t321_count CURSOR FOR t321_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t321_count INTO l_cdg[li_cnt].*  
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

FUNCTION t321_DL_maintain()
DEFINE p_row,p_col      LIKE type_file.num5  

   IF g_rec_b = 0 THEN RETURN END IF 
   IF g_cdg_h.cdgconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF
   #FUN-BB0038 --begin
   LET g_forupd_sql = "SELECT * FROM cdi_file WHERE cdi01 = ? AND cdi02 = ? AND cdi03 = ? AND cdi04 = ? "
   IF g_argv1='2' THEN
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdi00='2' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   ELSE
      LET g_forupd_sql = g_forupd_sql CLIPPED," AND cdi00='1' FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   END IF
   #FUN-BB0038 --end
   DECLARE t321_cdi_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t321_cdi_w AT p_row,p_col WITH FORM "axc/42f/axct321_cdi"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   BEGIN WORK    
   OPEN t321_cdi_cl USING g_cdg_h.cdg01,g_cdg_h.cdg02,g_cdg_h.cdg03,g_cdg_h.cdg04
   IF STATUS THEN
      CALL cl_err("OPEN t321_cdi_cl.", STATUS, 1)
      CLOSE t321_cdi_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t321_cdi_cl INTO g_cdi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdi.cdi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF   

   CALL t321_cdi_show()
   INPUT BY NAME g_cdi.cdi05,g_cdi.cdi06,g_cdi.cdi07,g_cdi.cdi08,g_cdi.cdi09,g_cdi.cdi10,g_cdi.cdi11
       WITHOUT DEFAULTS
 
      BEFORE INPUT
 
      AFTER FIELD cdi05
          IF g_cdi.cdi05 IS NULL THEN
             LET g_cdi.cdi05 = g_cdi_t.cdi05
             NEXT FIELD cdi05
          END IF
          IF g_cdi_t.cdi05 IS NULL OR g_cdi.cdi05 <> g_cdi_t.cdi05 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi05 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi05,SQLCA.sqlcode,1)
                LET g_cdi.cdi05 = g_cdi_t.cdi05
                NEXT FIELD cdi05
             END IF 
             CALL t321_cdi_show()
          END IF 

      AFTER FIELD cdi06
          IF g_cdi.cdi06 IS NULL THEN
             LET g_cdi.cdi06 = g_cdi_t.cdi06
             NEXT FIELD cdi06
          END IF
          IF g_cdi_t.cdi06 IS NULL OR g_cdi.cdi06 <> g_cdi_t.cdi06 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi06 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi06,SQLCA.sqlcode,1)
                LET g_cdi.cdi06 = g_cdi_t.cdi06
                NEXT FIELD cdi06
             END IF 
             CALL t321_cdi_show()
          END IF 
          
      AFTER FIELD cdi07
          IF g_cdi.cdi07 IS NULL THEN
             LET g_cdi.cdi07 = g_cdi_t.cdi07
             NEXT FIELD cdi07
          END IF
          IF g_cdi_t.cdi07 IS NULL OR g_cdi.cdi07 <> g_cdi_t.cdi07 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi07 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi07,SQLCA.sqlcode,1)
                LET g_cdi.cdi07 = g_cdi_t.cdi07
                NEXT FIELD cdi07
             END IF 
             CALL t321_cdi_show()
          END IF  

      AFTER FIELD cdi08
          IF g_cdi.cdi08 IS NULL THEN
             LET g_cdi.cdi08 = g_cdi_t.cdi08
             NEXT FIELD cdi08
          END IF
          IF g_cdi_t.cdi08 IS NULL OR g_cdi.cdi08 <> g_cdi_t.cdi08 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi08 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi08,SQLCA.sqlcode,1)
                LET g_cdi.cdi08 = g_cdi_t.cdi08
                NEXT FIELD cdi08
             END IF 
             CALL t321_cdi_show()
          END IF 

      AFTER FIELD cdi09
          IF g_cdi.cdi09 IS NULL THEN
             LET g_cdi.cdi09 = g_cdi_t.cdi09
             NEXT FIELD cdi09
          END IF
          IF g_cdi_t.cdi09 IS NULL OR g_cdi.cdi09 <> g_cdi_t.cdi09 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi09 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi09,SQLCA.sqlcode,1)
                LET g_cdi.cdi09 = g_cdi_t.cdi09
                NEXT FIELD cdi09
             END IF 
             CALL t321_cdi_show()
          END IF 

      AFTER FIELD cdi10
          IF g_cdi.cdi10 IS NULL THEN
             LET g_cdi.cdi10 = g_cdi_t.cdi10
             NEXT FIELD cdi10
          END IF
          IF g_cdi_t.cdi10 IS NULL OR g_cdi.cdi10 <> g_cdi_t.cdi10 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi10 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi10,SQLCA.sqlcode,1)
                LET g_cdi.cdi10 = g_cdi_t.cdi10
                NEXT FIELD cdi10
             END IF 
             CALL t321_cdi_show()
          END IF 

      AFTER FIELD cdi11
          IF g_cdi.cdi11 IS NULL THEN
             LET g_cdi.cdi11 = g_cdi_t.cdi11
             NEXT FIELD cdi11
          END IF
          IF g_cdi_t.cdi11 IS NULL OR g_cdi.cdi11 <> g_cdi_t.cdi11 THEN 
             SELECT aag02 
               FROM aag_file 
              WHERE aag01 = g_cdi.cdi11 
                AND aag00 = g_cdi.cdi01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdi.cdi11,SQLCA.sqlcode,1)
                LET g_cdi.cdi11 = g_cdi_t.cdi11
                NEXT FIELD cdi11
             END IF 
             CALL t321_cdi_show()
          END IF 
          
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #No.MOD-C70264  --Begin
       ON ACTION cancel
          LET INT_FLAG = FALSE
          EXIT INPUT
       #No.MOD-C70264  --End
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cdi05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi05
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi05
               DISPLAY BY NAME g_cdi.cdi05
               NEXT FIELD cdi05
            WHEN INFIELD(cdi06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi06
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi06
               DISPLAY BY NAME g_cdi.cdi06
               NEXT FIELD cdi06
            WHEN INFIELD(cdi07) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi07
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi07
               DISPLAY BY NAME g_cdi.cdi07
               NEXT FIELD cdi07
            WHEN INFIELD(cdi08) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi08
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi08
               DISPLAY BY NAME g_cdi.cdi08
               NEXT FIELD cdi08
            WHEN INFIELD(cdi09) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi09
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi09
               DISPLAY BY NAME g_cdi.cdi09
               NEXT FIELD cdi09
            WHEN INFIELD(cdi10) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi10
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi10
               DISPLAY BY NAME g_cdi.cdi10
               NEXT FIELD cdi10
            WHEN INFIELD(cdi11) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_cdi.cdi11
               LET g_qryparam.arg1 = g_cdi.cdi01
               CALL cl_create_qry() RETURNING g_cdi.cdi11
               DISPLAY BY NAME g_cdi.cdi11
               NEXT FIELD cdi11
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   AFTER INPUT 
      IF cl_null(g_cdi.cdi05) THEN  
         NEXT FIELD cdi05
       END IF 
      IF cl_null(g_cdi.cdi06) THEN  
         NEXT FIELD cdi06     
      END IF 
      IF cl_null(g_cdi.cdi07) THEN  
         NEXT FIELD cdi07
       END IF 
      IF cl_null(g_cdi.cdi08) THEN  
         NEXT FIELD cdi08
       END IF 
      IF cl_null(g_cdi.cdi09) THEN  
         NEXT FIELD cdi09
       END IF 
      IF cl_null(g_cdi.cdi10) THEN  
         NEXT FIELD cdi10
       END IF 
      IF cl_null(g_cdi.cdi11) THEN  
         NEXT FIELD cdi11
       END IF 
      UPDATE cdi_file SET cdi05 = g_cdi.cdi05,
                          cdi06 = g_cdi.cdi06,
                          cdi07 = g_cdi.cdi07, 
                          cdi08 = g_cdi.cdi08, 
                          cdi09 = g_cdi.cdi09, 
                          cdi10 = g_cdi.cdi10, 
                          cdi11 = g_cdi.cdi11 
       WHERE cdi01 = g_cdi.cdi01
         AND cdi02 = g_cdi.cdi02 
         AND cdi03 = g_cdi.cdi03         
         AND cdi04 = g_cdi.cdi04 

       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
          CALL cl_err3("upd","cdi_file",g_cdi.cdi01,g_cdi.cdi02,SQLCA.sqlcode,"","",1)           
          ROLLBACK WORK
       ELSE
          MESSAGE 'UPDATE cdi_file O.K'
          COMMIT WORK
       END IF 
   END INPUT   
   
   CLOSE WINDOW t321_cdi_w 
END FUNCTION 

FUNCTION t321_cdi_show()
DEFINE l_aag02_1       LIKE aag_file.aag02
DEFINE l_aag02_2       LIKE aag_file.aag02
DEFINE l_aag02_3       LIKE aag_file.aag02
DEFINE l_aag02_4       LIKE aag_file.aag02
DEFINE l_aag02_5       LIKE aag_file.aag02
DEFINE l_aag02_6       LIKE aag_file.aag02
DEFINE l_aag02_7       LIKE aag_file.aag02

   LET g_cdi_t.* = g_cdi.*
   DISPLAY BY NAME g_cdi.cdi05,g_cdi.cdi06,g_cdi.cdi07,g_cdi.cdi08,g_cdi.cdi09,g_cdi.cdi10,g_cdi.cdi11,
                   g_cdi.cdi12b,g_cdi.cdi12c,g_cdi.cdi12d,g_cdi.cdi12e,g_cdi.cdi12f,g_cdi.cdi12g,g_cdi.cdi12h
   SELECT aag02 INTO l_aag02_1 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi05
   SELECT aag02 INTO l_aag02_2 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi06
   SELECT aag02 INTO l_aag02_3 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi07
   SELECT aag02 INTO l_aag02_4 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi08
   SELECT aag02 INTO l_aag02_5 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi09
   SELECT aag02 INTO l_aag02_6 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi10
   SELECT aag02 INTO l_aag02_7 FROM aag_file WHERE aag00 = g_cdi.cdi01 AND aag01 = g_cdi.cdi11
   DISPLAY l_aag02_1 TO FORMONLY.aag02_1
   DISPLAY l_aag02_2 TO FORMONLY.aag02_2
   DISPLAY l_aag02_3 TO FORMONLY.aag02_3
   DISPLAY l_aag02_4 TO FORMONLY.aag02_4
   DISPLAY l_aag02_5 TO FORMONLY.aag02_5
   DISPLAY l_aag02_6 TO FORMONLY.aag02_6
   DISPLAY l_aag02_7 TO FORMONLY.aag02_7
                      
END FUNCTION 

FUNCTION t321_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
#CHI-C30107 --------------- add -------------- begin
    IF g_cdg_h.cdgconf ='Y' THEN LET g_success ='N' RETURN END IF
    IF g_cdg_h.cdg01 IS NULL THEN LET g_success ='N' RETURN END IF
    IF NOT cl_confirm('aap-222') THEN
       LET g_success ='N'
       RETURN
    END IF
    SELECT * INTO g_cdg_h.* FROM cdg_file 
     WHERE cdg01 = g_cdg_h.cdg01
       AND cdg02 = g_cdg_h.cdg02
       AND cdg03 = g_cdg_h.cdg03
       AND cdg04 = g_cdg_h.cdg04 
       AND cdg06 = g_cdg_h.cdg06
       AND cdg07 = g_cdg_h.cdg07
#CHI-C30107 --------------- add -------------- end
    IF g_cdg_h.cdgconf ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cdg_h.cdg01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cdg_h.cdg01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cdg_h.cdg05,'CA',1,l_flg,g_cdg_h.cdg01)    
END FUNCTION 

FUNCTION t321_firm1_upd()
#CHI-C30107 ----------- mark ------------ begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 ----------- mark ------------ end

    LET g_cdg_h.cdgconf ='Y' 
    UPDATE cdg_file SET cdgconf ='Y' 
     WHERE cdg01 = g_cdg_h.cdg01
       AND cdg02 = g_cdg_h.cdg02
       AND cdg03 = g_cdg_h.cdg03
       AND cdg04 = g_cdg_h.cdg04
END FUNCTION 

FUNCTION t321_firm2()
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cdg_h.cdgconf ='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cdg_h.cdgconf ='N' 
    UPDATE cdg_file SET cdgconf ='N' 
     WHERE cdg01 = g_cdg_h.cdg01
       AND cdg02 = g_cdg_h.cdg02
       AND cdg03 = g_cdg_h.cdg03
       AND cdg04 = g_cdg_h.cdg04
   
END FUNCTION 
