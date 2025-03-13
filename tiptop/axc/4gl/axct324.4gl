# Prog. Version..: '5.30.06-13.04.25(00007)'     #
# Pattern name.... axct324.4gl
# Descriptions.... 杂项进出分录结转作业
# Date & Author... 2010/07/09 By wujie #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C70138 12/07/13 By yinhy 串查時增加傳參
# Modify.........: No.FUN-CC0153 13/01/23 By wujie 单身增加cdl14项目编号cdl15WBS编号，aza08 =N时隐藏
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50097 13/05/13 By suncx 增加汇出excel功能
# Modify.........: No:FUN-D60073 13/07/04 By lixh1 添加單身查詢功能;添加頁脚金額統計
# Modify.........: No:FUN-D60095 13/06/20 By lujh 增加傳參
# Modify.........: No:FUN-D80089 13/12/12 By fengmy 加入部门所属成本中心的判断

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE
    g_cdl_h         RECORD LIKE cdl_file.*,    #(假單頭)
    g_cdl           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdl13            LIKE cdl_file.cdl13,
        cdl06            LIKE cdl_file.cdl06,
        azf03            LIKE azf_file.azf03,
        cdl05            LIKE cdl_file.cdl05,
        gem02            LIKE gem_file.gem02,
        cdl16            LIKE cdl_file.cdl16,   #FUN-D80089 add
        gem02_1          LIKE gem_file.gem02,   #FUN-D80089 add
        cdl07            LIKE cdl_file.cdl07,
        ima02            LIKE ima_file.ima02,  
        cdl08            LIKE cdl_file.cdl08,
        aag02            LIKE aag_file.aag02,
#No.FUN-CC0153 --begin
        cdl14            LIKE cdl_file.cdl14,
        cdl15            LIKE cdl_file.cdl15,
#No.FUN-CC0153 --end 
        cdl09            LIKE cdl_file.cdl09,
        aag02_2          LIKE aag_file.aag02,
        cdl10            LIKE cdl_file.cdl10
                    END RECORD,
    g_cdl_t         RECORD                 #程式變數 (舊值)
        cdl13            LIKE cdl_file.cdl13,
        cdl06            LIKE cdl_file.cdl06,
        azf03            LIKE azf_file.azf03,
        cdl05            LIKE cdl_file.cdl05,
        gem02            LIKE gem_file.gem02,
        cdl16            LIKE cdl_file.cdl16,   #FUN-D80089 add
        gem02_1          LIKE gem_file.gem02,   #FUN-D80089 add
        cdl07            LIKE cdl_file.cdl07,
        ima02            LIKE ima_file.ima02,  
        cdl08            LIKE cdl_file.cdl08,
        aag02            LIKE aag_file.aag02,
#No.FUN-CC0153 --begin
        cdl14            LIKE cdl_file.cdl14,
        cdl15            LIKE cdl_file.cdl15,
#No.FUN-CC0153 --end 
        cdl09            LIKE cdl_file.cdl09,
        aag02_2          LIKE aag_file.aag02,
        cdl10            LIKE cdl_file.cdl10
                    END RECORD,
    g_rec_b             LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
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
DEFINE  g_cdl10_tot     LIKE cdl_file.cdl10    #No.FUN-D60073 add
DEFINE  g_wc1               STRING    #FUN-D60095  add

MAIN
DEFINE l_time           LIKE type_file.chr8           
DEFINE p_row,p_col      LIKE type_file.num5  

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

#   CALL cl_used(g_prog,l_time,1)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   #FUN-D60095--add--str--
   LET g_wc1 = ARG_VAL(1)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
   #FUN-D60095--add--end--

   LET g_forupd_sql = "SELECT * FROM cdl_file WHERE cdl01 = ? AND cdl02 = ? AND cdl03 = ? AND cdl04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t324_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t324_w AT p_row,p_col WITH FORM "axc/42f/axct324"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
#No.FUN-CC0153 --begin
   CALL cl_set_comp_visible("cdl14,cdl15",g_aza.aza08 = 'Y')
#No.FJN-CC0153 --end

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t324_q()
   END IF
   #FUN-D60095--add--end--

   CALL t324_menu()
   CLOSE WINDOW t324_w               

#   CALL cl_used(g_prog,l_time,2)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

#QBE 查詢資料
FUNCTION t324_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cdl.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_cdl_h.* TO NULL     
      IF cl_null(g_wc1) THEN  #FUN-D60095 add
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON cdl04,cdl01,cdllegal,cdl02,cdl03,cdl11
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
         END CONSTRUCT  

         #FUN-D60073--add--str--
         CONSTRUCT g_wc2 ON cdl13,cdl06,cdl05,cdl16,cdl07,cdl08,  #FUN-D80089 add cdl16
                            cdl14,cdl15,cdl09,cdl10
              FROM s_cdl[1].cdl13,s_cdl[1].cdl06,s_cdl[1].cdl05,
                   s_cdl[1].cdl16,                                 #FUN-D80089 add
                   s_cdl[1].cdl07,s_cdl[1].cdl08,s_cdl[1].cdl14,
                   s_cdl[1].cdl15,s_cdl[1].cdl09,s_cdl[1].cdl10
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         END CONSTRUCT
         #FUN-D60073--add--end--

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cdl01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl01
                  NEXT FIELD cdl01

               #FUN-D60073--add--str--
               WHEN INFIELD(cdl13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_cdl13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl13
                  NEXT FIELD cdl13

               WHEN INFIELD(cdl06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.arg1  = "2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl06
                  NEXT FIELD cdl06

               WHEN INFIELD(cdl05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl05
                  NEXT FIELD cdl05
   
               #FUN-D80089--add--str--
               WHEN INFIELD(cdl16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl16
                  NEXT FIELD cdl16
               #FUN-D80089--add--end--

               WHEN INFIELD(cdl07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_tlf"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl07
                  NEXT FIELD cdl07

               WHEN INFIELD(cdl08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl08
                  NEXT FIELD cdl08

               WHEN INFIELD(cdl09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl09
                  NEXT FIELD cdl09

               WHEN INFIELD(cdl14)      #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pja2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl14
                  NEXT FIELD cdl14

               WHEN INFIELD(cdl15)      #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pjb4"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl15
                  NEXT FIELD cdl15
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

   LET g_sql = "SELECT UNIQUE cdl01,cdl02,cdl03,cdl04 ",
               "  FROM cdl_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND ", g_wc1 CLIPPED,    #FUN-D60095 add
               " ORDER BY 1,2,3,4"

 
   PREPARE t324_prepare FROM g_sql
   DECLARE t324_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t324_prepare
 
END FUNCTION

FUNCTION t324_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t324_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t324_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t324_r()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            CALL t324_b()
            
         WHEN "gen_entry"
            CALL t324_v()
				
				 #C200602-11911#1 adds    
         WHEN "gen_money"   #查看旧数据  mod by cathree 20201220
         IF cl_chk_act_auth() THEN
            CALL t324_gen()   #ADD-11911
         END IF
         #C200602-11911#1 adde
#No.MOD-D50097 --begin
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cdl),'','')
            END IF
#No.MOD-D50097 --end
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cdl_h.cdl01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF            
            CALL s_fsgl('CA',6,g_cdl_h.cdl11,0,g_cdl_h.cdl01,'1',g_cdl_h.cdlconf,l_npptype,g_cdl_h.cdl11)  

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t324_drill_down()
            END IF

         WHEN "confirm"
            CALL t324_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t324_firm1_upd()                   
            END IF
            CALL t324_show()         
         WHEN "undo_confirm" 
            CALL t324_firm2()
            CALL t324_show()

         WHEN "process_qry"  
            CALL cl_cmdrun_wait("axcp324")

         WHEN "carry_voucher"
            IF g_cdl_h.cdlconf ='Y' THEN
               LET g_msg ="axcp301 ",g_cdl_h.cdl11," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl11 AND nppsys ='CA' AND npp00 =6 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
            END IF


         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdl_h.cdl01,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl11 AND nppsys ='CA' AND npp00 =6 AND npp011 =1
            DISPLAY g_nppglno TO nppglno                      

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t324_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cdl_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cdl.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t324_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t324_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdl_h.* TO NULL
   ELSE
      CALL t324_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t324_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t324_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t324_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'P' FETCH PREVIOUS t324_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'F' FETCH FIRST    t324_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'L' FETCH LAST     t324_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
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
         FETCH ABSOLUTE g_jump t324_cs INTO g_cdl_h.cdl01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdl_h.cdl01,SQLCA.sqlcode,0)
      INITIALIZE g_cdl_h.* TO NULL  #TQC-6B0105
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
   SELECT  DISTINCT cdl01,cdl02,cdl03,cdl04,cdl11,cdllegal,cdlconf INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl_h.cdl11,g_cdl_h.cdllegal,g_cdl_h.cdlconf     
     FROM  cdl_file WHERE cdl01 = g_cdl_h.cdl01 AND cdl02 = g_cdl_h.cdl02 AND cdl03 = g_cdl_h.cdl03 AND cdl04 = g_cdl_h.cdl04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdl_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdl_h.* TO NULL
      RETURN
   ELSE   
      CALL t324_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t324_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME 
          g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,
          g_cdl_h.cdl11,g_cdl_h.cdllegal,g_cdl_h.cdlconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdl_h.cdllegal
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl11 AND nppsys ='CA' AND npp00 =6 AND npp011 =1
   CALL cl_set_field_pic(g_cdl_h.cdlconf,"","","","","")
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL t324_b_fill()                 #單身
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t324_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cdl_h.cdl01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cdl_h.cdlconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t324_cl USING g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl.", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_cdl_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdl_h.cdl01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t324_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "cdl01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 =  g_cdl_h.cdl01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM cdl_file
       WHERE cdl01 = g_cdl_h.cdl01 
         AND cdl02 = g_cdl_h.cdl02
         AND cdl03 = g_cdl_h.cdl03
         AND cdl04 = g_cdl_h.cdl04
      IF l_cnt > 0 THEN
         DELETE FROM cdl_file 
          WHERE cdl01 = g_cdl_h.cdl01
            AND cdl02 = g_cdl_h.cdl02
            AND cdl03 = g_cdl_h.cdl03
            AND cdl04 = g_cdl_h.cdl04
            
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdl_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","del cdl.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_cdl_h.cdl11
         AND nppsys= 'CA'
         AND npp00 = 6
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cdl_h.cdl11
            AND nppsys= 'CA'
            AND npp00 = 6
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cdl_h.cdl11
         AND npqsys= 'CA'
         AND npq00 = 6
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cdl_h.cdl11
            AND npqsys= 'CA'
            AND npq00 = 6
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      #FUN-B40056  --begin
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_cdl_h.cdl11
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cdl_h.cdl11
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_cdl_h.cdl11,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056  --end
      INITIALIZE g_cdl_h.* TO NULL
      CLEAR FORM
      CALL g_cdl.clear()
      CALL t324_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t324_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t324_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t324_fetch('/')
      END IF
   END IF
   CLOSE t324_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cdl_h.cdl01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t324_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
#No.FUN-CC0153 --begin
DEFINE l_pjb09         LIKE pjb_file.pjb09
DEFINE l_pjb11         LIKE pjb_file.pjb11
#No.FUN-CC0153 --end  
       

   LET g_action_choice = ""
   IF g_cdl_h.cdl01 IS NULL THEN RETURN END IF
   IF g_cdl_h.cdlconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdl13,cdl06,'',cdl05,'',cdl16,'',cdl07,'',cdl08,'',cdl14,cdl15,cdl09,'',cdl10 ",    #No.FUN-CC0153 add cdl14,cdl15  #FUN-D80089 add cdl16,''
                      " FROM cdl_file",
                      " WHERE cdl01=? AND cdl02=? AND cdl03 = ? AND cdl04 = ? AND cdl05 = ? AND cdl06 = ? AND cdl07 = ? AND cdl13 = ? AND cdl14 = ? AND cdl15 = ?  FOR UPDATE"   #No.FUN-CC0153 add cdl14,cdl15
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t324_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdl WITHOUT DEFAULTS FROM s_cdl.*
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
             LET g_cdl_t.* = g_cdl[l_ac].*  #BACKUP
             OPEN t324_b2cl USING g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl_t.cdl05,g_cdl_t.cdl06,g_cdl_t.cdl07,g_cdl_t.cdl13,g_cdl_t.cdl14,g_cdl_t.cdl15    #No.FUN-CC0153 add cdl14,cdl15
             IF STATUS THEN
                CALL cl_err("OPEN t324_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t324_b2cl INTO g_cdl[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdl_h.cdl02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdl[l_ac].aag02 FROM aag_file WHERE aag01 = g_cdl[l_ac].cdl08 AND aag00 = g_cdl_h.cdl01
             SELECT aag02 INTO g_cdl[l_ac].aag02_2 FROM aag_file WHERE aag01 = g_cdl[l_ac].cdl09 AND aag00 = g_cdl_h.cdl01
             SELECT azf03 INTO g_cdl[l_ac].azf03 FROM azf_file WHERE azf01 = g_cdl[l_ac].cdl06 AND azf02 = '2'
             SELECT gem02 INTO g_cdl[l_ac].gem02 FROM gem_file WHERE gem01 = g_cdl[l_ac].cdl05
             SELECT gem02 INTO g_cdl[l_ac].gem02_1 FROM gem_file WHERE gem01 = g_cdl[l_ac].cdl16       #FUN-D80089 add
             SELECT ima02 INTO g_cdl[l_ac].ima02 FROM ima_file WHERE ima01 = g_cdl[l_ac].cdl07
             NEXT FIELD cdl08
          END IF

       BEFORE INSERT  
       
       AFTER INSERT 
         

       AFTER FIELD cdl08           
          IF g_cdl[l_ac].cdl08 IS NULL THEN
             LET g_cdl[l_ac].cdl08 = g_cdl_t.cdl08
             NEXT FIELD cdl08
          END IF
          IF g_cdl_t.cdl08 IS NULL OR g_cdl[l_ac].cdl08 <> g_cdl_t.cdl08 THEN 
             SELECT aag02 INTO g_cdl[l_ac].aag02
               FROM aag_file 
              WHERE aag01 = g_cdl[l_ac].cdl08 
                AND aag00 = g_cdl_h.cdl01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdl[l_ac].cdl08,SQLCA.sqlcode,1)
                LET g_cdl[l_ac].cdl08 = g_cdl_t.cdl08
                NEXT FIELD cdl08
             END IF 
          END IF 
          
       AFTER FIELD cdl09           
          IF g_cdl[l_ac].cdl09 IS NULL THEN
             LET g_cdl[l_ac].cdl09 = g_cdl_t.cdl09
             NEXT FIELD cdl09
          END IF
          IF g_cdl_t.cdl09 IS NULL OR g_cdl[l_ac].cdl09 <> g_cdl_t.cdl09 THEN 
             SELECT aag02 INTO g_cdl[l_ac].aag02_2
               FROM aag_file 
              WHERE aag01 = g_cdl[l_ac].cdl09 
                AND aag00 = g_cdl_h.cdl01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdl[l_ac].cdl09,SQLCA.sqlcode,1)
                LET g_cdl[l_ac].cdl09 = g_cdl_t.cdl09
                NEXT FIELD cdl09
             END IF 
          END IF 
 
#No.FUN-CC0153 --begin
       AFTER FIELD cdl14
          IF NOT cl_null(g_cdl[l_ac].cdl14) THEN
          	 IF p_cmd = 'a' OR (p_cmd = 'u' AND g_cdl[l_ac].cdl14 <> g_cdl_t.cdl14) THEN 
                SELECT COUNT(*) INTO g_cnt FROM pja_file
                 WHERE pja01 = g_cdl[l_ac].cdl14
                   AND pjaacti = 'Y'
                   AND pjaclose = 'N'          
                IF g_cnt = 0 THEN
                   CALL cl_err(g_cdl[l_ac].cdl14,'asf-984',0)
                   NEXT FIELD cdl14
                END IF
                IF cl_null(g_cdl[l_ac].cdl15) THEN
                   NEXT FIELD cdl15
                END IF
             END IF 
          ELSE
             NEXT FIELD cdl09    #IF 專案沒輸入資料，不可輸入WBS/活動,直接跳到下個欄位
          END IF
 
       BEFORE FIELD cdl15
         IF cl_null(g_cdl[l_ac].cdl14) THEN
            NEXT FIELD cdl14
         END IF
 
       AFTER FIELD cdl15
          IF NOT cl_null(g_cdl[l_ac].cdl15) THEN
          	 IF p_cmd = 'a' OR (p_cmd = 'u' AND g_cdl[l_ac].cdl14 <> g_cdl_t.cdl14) THEN 
                SELECT COUNT(*) INTO g_cnt FROM pjb_file
                 WHERE pjb01 = g_cdl[l_ac].cdl14
                   AND pjb02 = g_cdl[l_ac].cdl15
                   AND pjbacti = 'Y'
                IF g_cnt = 0 THEN
                   CALL cl_err(g_cdl[l_ac].cdl15,'apj-051',0)
                   LET g_cdl[l_ac].cdl15 = g_cdl_t.cdl15
                   NEXT FIELD cdl15
                END IF
                SELECT pjb09,pjb11
                  INTO l_pjb09,l_pjb11 
                  FROM pjb_file
                 WHERE pjb01 = g_cdl[l_ac].cdl14
                   AND pjb02 = g_cdl[l_ac].cdl15
                   AND pjbacti = 'Y'
                 IF SQLCA.sqlcode = 100 THEN
                      LET g_errno = SQLCA.sqlcode USING '-------'
                      CALL cl_err(g_cdl[l_ac].cdl15,g_errno,0)
                      LET g_cdl[l_ac].cdl15 = g_cdl_t.cdl15
                      NEXT FIELD cdl15
                 END IF
                
                CASE WHEN l_pjb09 !='Y' 
                          CALL cl_err(g_cdl[l_ac].cdl15,'apj-090',0)
                          LET g_cdl[l_ac].cdl15 = g_cdl_t.cdl15
                          NEXT FIELD cdl15
                     WHEN l_pjb11 !='Y'
                          CALL cl_err(g_cdl[l_ac].cdl15,'apj-090',0)
                          LET g_cdl[l_ac].cdl15 = g_cdl_t.cdl15
                          NEXT FIELD cdl15
                END CASE
             END IF 
          ELSE
             IF NOT cl_null(g_cdl[l_ac].cdl14) THEN
                NEXT FIELD cdl15
             END IF
          END IF
#No.FUN-CC0153 --end

       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac     #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D40030--add--str--
             IF p_cmd = 'u' THEN
                LET g_cdl[l_ac].* = g_cdl_t.*
             ELSE
                CALL g_cdl.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF
             #FUN-D40030--add--end--
             CLOSE t324_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 Add
          CLOSE t324_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdl[l_ac].* = g_cdl_t.*
             CLOSE t324_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdl[l_ac].cdl05,-263,1)
             LET g_cdl[l_ac].* = g_cdl_t.*
          ELSE  
             UPDATE cdl_file SET cdl09 = g_cdl[l_ac].cdl09,
                                 cdl08 = g_cdl[l_ac].cdl08
              WHERE cdl01 = g_cdl_h.cdl01 
                AND cdl02 = g_cdl_h.cdl02
                AND cdl03 = g_cdl_h.cdl03
                AND cdl04 = g_cdl_h.cdl04 
                AND cdl05 = g_cdl_t.cdl05 
                AND cdl06 = g_cdl_t.cdl06
                AND cdl07 = g_cdl_t.cdl07
#No.FUN-CC0153 --begin
                AND cdl13 = g_cdl_t.cdl13
                AND cdl14 = g_cdl_t.cdl14
                AND cdl15 = g_cdl_t.cdl15
#No.FUN-CC0153 --end

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdl_file",g_cdl_h.cdl01,g_cdl_h.cdl02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdl[l_ac].* = g_cdl_t.*
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
          IF INFIELD(cdl09) AND l_ac > 1 THEN
          END IF
 

       ON ACTION CONTROLP
          IF INFIELD(cdl08) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdl_h.cdl01
             LET g_qryparam.default1 = g_cdl[l_ac].cdl08
             CALL cl_create_qry() RETURNING g_cdl[l_ac].cdl08
             DISPLAY g_cdl[l_ac].cdl08 TO cdl08
             NEXT FIELD cdl08
          END IF  

          IF INFIELD(cdl09) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdl_h.cdl01
             LET g_qryparam.default1 = g_cdl[l_ac].cdl09
             CALL cl_create_qry() RETURNING g_cdl[l_ac].cdl09
             DISPLAY g_cdl[l_ac].cdl09 TO cdl09
             NEXT FIELD cdl09
          END IF  
#No.FUN-CC0153 --begin
          IF INFIELD(cdl14) THEN   #專案
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_pja2"
             CALL cl_create_qry() RETURNING g_cdl[l_ac].cdl14
             DISPLAY BY NAME g_cdl[l_ac].cdl14
             NEXT FIELD cdl14
          END IF 
          IF INFIELD(cdl15) THEN   #WBS
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_pjb4"
             LET g_qryparam.arg1 = g_cdl[l_ac].cdl14
             CALL cl_create_qry() RETURNING g_cdl[l_ac].cdl15
             DISPLAY BY NAME g_cdl[l_ac].cdl15
             NEXT FIELD cdl15
          END IF 
#No.FUN-CC0153 --end
 
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
  
   CLOSE t324_b2cl
 
END FUNCTION
 
FUNCTION t324_b_fill()
    
 
   LET g_sql =  "SELECT cdl13,cdl06,'',cdl05,'',cdl16,'',cdl07,'',cdl08,'',cdl14,cdl15,cdl09,'',cdl10  ",   #No.FUN-CC0153  #FUN-D80089 add cdl16,''
                "  FROM cdl_file",
                " WHERE cdl01 ='",g_cdl_h.cdl01,"'",
                "   AND cdl02 ='",g_cdl_h.cdl02,"'",
                "   AND cdl03 ='",g_cdl_h.cdl03,"'",
                "   AND cdl04 ='",g_cdl_h.cdl04,"'",
                "   AND  ", g_wc2 CLIPPED,  #FUN-D60073 add
                " ORDER BY 1,2,3,5"
    PREPARE t324_pb FROM g_sql
    DECLARE cdl_curs CURSOR FOR t324_pb
 
    CALL g_cdl.clear()
    LET g_cnt = 1
    LET g_cdl10_tot = 0
    FOREACH cdl_curs INTO g_cdl[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cdl[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cdl[g_cnt].cdl08 AND aag00 = g_cdl_h.cdl01
       SELECT aag02 INTO g_cdl[g_cnt].aag02_2 FROM aag_file WHERE aag01 = g_cdl[g_cnt].cdl09 AND aag00 = g_cdl_h.cdl01
       SELECT azf03 INTO g_cdl[g_cnt].azf03 FROM azf_file WHERE azf01 = g_cdl[g_cnt].cdl06 AND azf02 = '2'
       SELECT gem02 INTO g_cdl[g_cnt].gem02 FROM gem_file WHERE gem01 = g_cdl[g_cnt].cdl05
       SELECT gem02 INTO g_cdl[g_cnt].gem02_1 FROM gem_file WHERE gem01 = g_cdl[g_cnt].cdl16   #FUN-D80089 add
       SELECT ima02 INTO g_cdl[g_cnt].ima02 FROM ima_file WHERE ima01 = g_cdl[g_cnt].cdl07
       IF NOT cl_null(g_cdl[g_cnt].cdl10) THEN LET g_cdl10_tot = g_cdl10_tot + g_cdl[g_cnt].cdl10 END IF #FUN-D60073 add
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdl.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_cdl10_tot TO FORMONLY.cdl10_tot  #FUN-D60073
END FUNCTION

FUNCTION t324_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()
   
      DISPLAY ARRAY g_cdl TO s_cdl.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)         
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
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t324_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t324_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t324_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t324_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t324_fetch('L')
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

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
                  
      ON ACTION gen_entry 
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 			#C200602-11911#1 adds
 			 ON ACTION gen_money
         LET g_action_choice="gen_money"
         EXIT DISPLAY  
      #C200602-11911#1 adde   
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
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
                                                         
      ON ACTION drill_down1                                                      
         LET g_action_choice="drill_down1"                                       
         EXIT DISPLAY     
      ON ACTION confirm #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
                   
      ON ACTION undo_confirm #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 
 
       ON action process_qry 
         LET g_action_choice="process_qry"
         EXIT DISPLAY          

      ON action carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY 

      ON action undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY 

#No.FUN-CC0001 --begin
      ON action voucher_qry
         LET g_action_choice="voucher_qry"
         EXIT DISPLAY 
#No.FUN-CC0001 --end

      AFTER DISPLAY
         CONTINUE DISPLAY   
                        
   END DISPLAY
      
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

 
FUNCTION t324_v()
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype,
                           yy          LIKE type_file.num5,
                           mm          LIKE type_file.num5,
                           b           LIKE aaa_file.aaa01
                           END RECORD 

   IF g_cdl_h.cdlconf ='Y' THEN RETURN END IF 
   LET tm.b = g_cdl_h.cdl01
   LET tm.yy = g_cdl_h.cdl02
   LET tm.mm = g_cdl_h.cdl03
   LET tm.tlfctype = g_cdl_h.cdl04
   LET g_success ='Y'
   CALL p324_gl_1(tm.*)
   IF g_success ='N' THEN 
      RETURN  
   END IF 
   CALL t324_show()
   MESSAGE " "
END FUNCTION

                                                         
FUNCTION t324_drill_down()                                                      
   DEFINE l_flag     LIKE type_file.chr1   #MOD-C70138
   IF cl_null(l_ac1) OR l_ac1 = 0 THEN RETURN END IF                                                                              
   IF cl_null(g_cdl[l_ac1].cdl07) THEN RETURN END IF                                   
   #No.MOD-C70138  --Begin
   LET l_flag = '+'
   IF g_cdl[l_ac1].cdl10 < 0 THEN
      LET l_flag = '-'
   END IF
   #No.MOD-C70138  --End
   LET g_msg = "axcq770 '",g_cdl[l_ac1].cdl07,"' '",g_cdl_h.cdl02,"' '",g_cdl_h.cdl03,"'
               '",g_cdl[l_ac1].cdl13,"' '",g_cdl[l_ac1].cdl06,"' '",g_cdl[l_ac1].cdl05,"'  '",l_flag,"'"   #MOD-C70138 
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t324_count()
 
   DEFINE l_cdl   DYNAMIC ARRAY of RECORD        # 程式變數
          cdl01          LIKE cdl_file.cdl01, 
          cdl02          LIKE cdl_file.cdl02,          
          cdl03          LIKE cdl_file.cdl03,
          cdl04          LIKE cdl_file.cdl04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE cdl01,cdl02,cdl03,cdl04 FROM cdl_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED,
              "   AND ",g_wc1 CLIPPED    #FUN-D60095 add  
   PREPARE t324_precount FROM g_sql
   DECLARE t324_count CURSOR FOR t324_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t324_count INTO l_cdl[li_cnt].*  
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

FUNCTION t324_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
#CHI-C30107 -------------- add ------------------- begin
    IF g_cdl_h.cdlconf ='Y' THEN LET g_success ='N' RETURN END IF
    IF g_cdl_h.cdl01 IS NULL THEN LET g_success ='N' RETURN END IF
    IF NOT cl_confirm('aap-222') THEN
       LET g_success ='N'
       RETURN
    END IF
    SELECT * INTO g_cdl_h.* FROM cdl_file
     WHERE cdl01 = g_cdl_h.cdl01
       AND cdl02 = g_cdl_h.cdl02
       AND cdl03 = g_cdl_h.cdl03
       AND cdl04 = g_cdl_h.cdl04
       AND cdl05 = g_cdl_h.cdl05
       AND cdl06 = g_cdl_h.cdl06
       AND cdl07 = g_cdl_h.cdl07
       AND cdl13 = g_cdl_h.cdl13
#CHI-C30107 -------------- add ------------------- end
    IF g_cdl_h.cdlconf ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cdl_h.cdl01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cdl_h.cdl01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cdl_h.cdl11,'CA',1,l_flg,g_cdl_h.cdl01)    
END FUNCTION 

FUNCTION t324_firm1_upd()
#CHI-C30107 --------------- mark ------------- begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 --------------- mark ------------- end
    LET g_cdl_h.cdlconf ='Y' 
    UPDATE cdl_file SET cdlconf ='Y' 
     WHERE cdl01 = g_cdl_h.cdl01
       AND cdl02 = g_cdl_h.cdl02
       AND cdl03 = g_cdl_h.cdl03
       AND cdl04 = g_cdl_h.cdl04
END FUNCTION 

FUNCTION t324_firm2()
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cdl_h.cdlconf ='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cdl_h.cdlconf ='N' 
    UPDATE cdl_file SET cdlconf ='N' 
     WHERE cdl01 = g_cdl_h.cdl01
       AND cdl02 = g_cdl_h.cdl02
       AND cdl03 = g_cdl_h.cdl03
       AND cdl04 = g_cdl_h.cdl04
   
END FUNCTION 


FUNCTION t324_gen()
DEFINE l_sql STRING
DEFINE l_jine  LIKE cdl_file.cdl10
DEFINE l_ccc01 LIKE cdl_file.cdl07
DEFINE l_wc    STRING 
	#LET l_sql= " select sum(jine),ta_ccc01 from (",
  #            #cxcq901
  #              " SELECT (ta_ccc22a4-ta_ccc42) jine,ta_ccc01 FROM cxcq901_file ",  #add jine by lifang 200705
  #              " LEFT JOIN cdl_file ON cdl07=ta_ccc01 AND cdl02=ta_ccc02 AND cdl03=ta_ccc03 ",
  #              " WHERE cdl01 ='",g_cdl_h.cdl01,"'",
  #              "   AND cdl02 ='",g_cdl_h.cdl02,"'",
  #              "   AND cdl03 ='",g_cdl_h.cdl03,"'",
  #              "   AND cdl04 ='",g_cdl_h.cdl04,"'",
  #              "   AND cdl11 = '",g_cdl_h.cdl11,"'",   #add by lifang 200705
  #              " UNION ",
  #            #cxcq902
  #            #--mark by lifang 200705 begin#
  #            #  " SELECT (ta_ccc217 * ta_cccud07)-(ta_ccc81 * -1 * ta_cccud07),ta_ccc01 FROM ta_ccp_file ",
  #            #  " LEFT JOIN cdl_file ON cdl07=ta_ccc01 AND cdl02=ta_ccc02 AND cdl03=ta_ccc03 ",
  #            #  "  WHERE cdl01 ='",g_cdl_h.cdl01,"'",
  #            #--mark by lifang 200705 end#
  #            #--add by lifang 200705 begin#
  #              " SELECT ((ta_ccc217 * ta_cccud07)-(ta_ccc81 * -1 * ta_cccud07)) jine,ta_ccc01 ",
  #              "  FROM ta_ccp_file, ",                                 
  #              " (SELECT CCH04, SUM(BZXH) BZXH FROM ex_ccg_result ",      
  #              " WHERE yym = '",g_cdl_h.cdl02,"'",
  #              "   AND mmy = '",g_cdl_h.cdl03,"'",
  #              " AND INSTR(cch04, '.') > 0 ",                                       
  #              " AND SUBSTR(cch04, 1, 1) <> 'K' ",                                   
  #              " GROUP BY CCH04) HYB,  ",                                           
  #              " (SELECT YJLH, SUM(BZXH * LJYL) BZXH1 ",                                
  #              " FROM ex_ccg_WGD, EX_BOM_CP ",                                       
  #              "   WHERE CCH04 = CPLH  ",                                               
  #              "  AND ex_bom_cp.yy = yym AND ex_bom_cp.mm = mmy ",                   
  #              "  AND yym = '",g_cdl_h.cdl02,"'",
  #              "  AND mmy = '",g_cdl_h.cdl03,"'",
  #              "  AND to_char(sxrq1, 'yyyyMM') <= TO_CHAR(to_date(",g_cdl_h.cdl02,"||",g_cdl_h.cdl03,",'yyyyMM'), 'yyyyMM') ",
  #              "  AND nvl(to_char(sxrq2, 'yyyyMM'), TO_CHAR(SYSDATE + 1, 'yyyyMM')) > TO_CHAR(to_date(",g_cdl_h.cdl02,"||",g_cdl_h.cdl03,",'yyyyMM'), 'yyyyMM') ",
  #              "  AND INSTR(YJLH, '.') > 1  ",                                       
  #              "  GROUP BY YJLH) HYC,cdl_file ",                                                
  #              " WHERE  INSTR(ta_ccc01, '.') > 0  ",                                           
  #              " AND ta_ccc01 = HYB.cch04(+)  ",                                           
  #              " AND ta_ccc01 = HYC.YJLH(+) ",                                                                                               
  #              " AND (ta_ccc211 <> 0 OR ta_ccc217 <> 0  OR ta_ccc18<>0  OR ta_ccc214 <> 0 ",
  #              "       OR ta_ccc11 <> 0 OR ta_ccc31 <> 0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 ",
  #              "       or ta_ccc41 <> 0 OR ta_ccc43 <> 0 OR ta_ccc61 <> 0 OR ta_ccc91 <> 0 ", 
  #              "       OR ta_ccc213 <> 0  OR ta_ccc81<>0 OR ta_ccc98<>0)  ",
  #              " AND ta_ccc02 = '",g_cdl_h.cdl02,"'",
  #              " AND  ta_ccc03 = '",g_cdl_h.cdl03,"'",
  #              " AND cdl07=ta_ccc01 ",
  #              " AND cdl02=ta_ccc02  ",
  #              " AND cdl03=ta_ccc03 ",
  #              " AND cdl01 ='",g_cdl_h.cdl01,"'",
  #            #--add by lifang 200705 end#
  #              "   AND cdl02 ='",g_cdl_h.cdl02,"'",
  #              "   AND cdl03 ='",g_cdl_h.cdl03,"'",
  #              "   AND cdl04 ='",g_cdl_h.cdl04,"'",
  #              "   AND cdl11 = '",g_cdl_h.cdl11,"'",   #add by lifang 200705
  #               " UNION ",  
  #           #cxcq905
  #              " SELECT (ta_ccc217a- ta_ccc81a) jine,ta_ccc01 FROM cxcq905_file ",  #add jine by lifang 200705
  #              " LEFT JOIN cdl_file ON cdl07=ta_ccc01 AND cdl02=ta_ccc02 AND cdl03=ta_ccc03 ",
	#        " WHERE cdl01 ='",g_cdl_h.cdl01,"'",
  #              "   AND cdl02 ='",g_cdl_h.cdl02,"'",
  #              "   AND cdl03 ='",g_cdl_h.cdl03,"'",
  #              "   AND cdl04 ='",g_cdl_h.cdl04,"'",
  #              "   AND cdl11 = '",g_cdl_h.cdl11,"'",   #add by lifang 200705
  #               " UNION ",
  #           #cxcq906
  #              " SELECT (zrje-zfje) jine ,ta_ccc01 FROM cxcq906_file ",    #add jine by lifang 200705
  #              " LEFT JOIN cdl_file ON cdl07=ta_ccc01 AND cdl02=ta_ccc02 AND cdl03=ta_ccc03 ",
	#							" WHERE cdl01 ='",g_cdl_h.cdl01,"'",
  #              "   AND cdl02 ='",g_cdl_h.cdl02,"'",
  #              "   AND cdl03 ='",g_cdl_h.cdl03,"'",
  #              "   AND cdl04 ='",g_cdl_h.cdl04,"'"  
  #             ,"   AND cdl11 = '",g_cdl_h.cdl11,"')",   #add by lifang 200705
  #              " GROUP BY ta_ccc01 order by ta_ccc01 "                          #add by lifang 200705
  #                
  #  PREPARE gen_pb FROM l_sql
  #  DECLARE gen_curs CURSOR FOR gen_pb
  #  FOREACH gen_curs INTO l_jine,l_ccc01
  #  
  #        UPDATE cdl_file SET cdl10=l_jine 
	#		     WHERE cdl01 = g_cdl_h.cdl01
	#		       AND cdl02 = g_cdl_h.cdl02
	#		       AND cdl03 = g_cdl_h.cdl03
	#		       AND cdl04 = g_cdl_h.cdl04 
	#		       AND cdl07 = l_ccc01   
  #                             AND cdl11 = g_cdl_h.cdl11  #add by lifang 200705 
	#	END FOREACH
	
   LET l_wc = " '",g_cdl_h.cdl01 CLIPPED,"'",
	            " '",g_cdl_h.cdl02 CLIPPED,"'",
	            " '",g_cdl_h.cdl03 CLIPPED,"'",
	            " '",g_cdl_h.cdl04 CLIPPED,"'"
	
   LET g_msg = "axct324_01 ",l_wc
   CALL cl_cmdrun(g_msg) 

END FUNCTION 
