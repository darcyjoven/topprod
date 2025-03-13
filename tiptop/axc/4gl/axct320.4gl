# Prog. Version..: '5.30.06-13.04.25(00007)'     #
#
# Pattern name.... axct320.4gl
# Descriptions.... 工单发料分录结转作业
# Date & Author... 2010/07/02 By wujie #FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CB0120 12/12/28 By wangrr 增加欄位cde12工單類型
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No.FUN-D20040 13/02/19 By wujie 第一单身增加工单的部门厂商栏位
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D60081 13/06/18 By lujh 增加excel匯出功能
# Modify.........: No:FUN-D60095 13/06/24 By max1  增加傳參

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE
    g_cde_h         RECORD LIKE cde_file.*,    #(假單頭)
    g_cde           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cde06            LIKE cde_file.cde06,
        cde11            LIKE cde_file.cde11,
        cde07            LIKE cde_file.cde07,
        cde12            LIKE cde_file.cde12, #FUN-CB0120 add
        cde13            LIKE cde_file.cde13, #No.FUN-D20040
        cde08            LIKE cde_file.cde08,  
        cde09            LIKE cde_file.cde09,
        aag02            LIKE aag_file.aag02,
        cde10            LIKE cde_file.cde10
                    END RECORD,
    g_cde_t         RECORD                 #程式變數 (舊值)
        cde06            LIKE cde_file.cde06,
        cde11            LIKE cde_file.cde11,
        cde07            LIKE cde_file.cde07,
        cde12            LIKE cde_file.cde12, #FUN-CB0120 add
        cde13            LIKE cde_file.cde13, #No.FUN-D20040
        cde08            LIKE cde_file.cde08,  
        cde09            LIKE cde_file.cde09,
        aag02            LIKE aag_file.aag02,
        cde10            LIKE cde_file.cde10
                    END RECORD,
    g_cdf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdf07            LIKE cdf_file.cdf07,
        cdf08            LIKE cdf_file.cdf08,
        aag02_2          LIKE aag_file.aag02,
        cdf09            LIKE cdf_file.cdf09,   
        cdf09a           LIKE cdf_file.cdf09a,
        cdf09b           LIKE cdf_file.cdf09b,
        cdf09c           LIKE cdf_file.cdf09c,
        cdf09d           LIKE cdf_file.cdf09d,
        cdf09e           LIKE cdf_file.cdf09e,
        cdf09f           LIKE cdf_file.cdf09f,
        cdf09g           LIKE cdf_file.cdf09g,
        cdf09h           LIKE cdf_file.cdf09h
                    END RECORD,
    g_cdf_t         RECORD
        cdf07            LIKE cdf_file.cdf07,
        cdf08            LIKE cdf_file.cdf08,
        ccg02_2          LIKE aag_file.aag02,
        cdf09            LIKE cdf_file.cdf09,   
        cdf09a           LIKE cdf_file.cdf09a,
        cdf09b           LIKE cdf_file.cdf09b,
        cdf09c           LIKE cdf_file.cdf09c,
        cdf09d           LIKE cdf_file.cdf09d,
        cdf09e           LIKE cdf_file.cdf09e,
        cdf09f           LIKE cdf_file.cdf09f,
        cdf09g           LIKE cdf_file.cdf09g,
        cdf09h           LIKE cdf_file.cdf09h
                    END RECORD,
    g_wcg_sql           string,  #No.FUN-580092 HCN
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
    m_cde               RECORD LIKE cde_file.*,
    m_cdf               RECORD LIKE cdf_file.*,
    l_ac,l_ac1          LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
 
 
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

   LET g_forupd_sql = "SELECT * FROM cde_file WHERE cde01 = ? AND cde02 = ? AND cde03 = ? AND cde04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t320_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t320_w AT p_row,p_col WITH FORM "axc/42f/axct320"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t320_q()
   END IF
   #FUN-D60095--add--end--

   CALL t320_menu()
   CLOSE WINDOW t320_w               

#   CALL cl_used(g_prog,l_time,2)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

#QBE 查詢資料
FUNCTION t320_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cde.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_cde_h.* TO NULL    
       IF cl_null(g_wc1) THEN  #FUN-D60095 add 
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON cde04,cde01,cdelegal,cde02,cde03,cde05,cdeoriu,cdeorig
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
         END CONSTRUCT  

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cde01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cde01
                  NEXT FIELD cde01
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
 
   LET g_sql = "SELECT UNIQUE cde01,cde02,cde03,cde04 ",
               "  FROM cde_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND ", g_wc1 CLIPPED,    #FUN-D60095 add
               " ORDER BY 1,2,3,4"

 
   PREPARE t320_prepare FROM g_sql
   DECLARE t320_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t320_prepare
 
END FUNCTION

FUNCTION t320_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t320_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t320_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t320_r()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            CASE g_b_flag
                WHEN '1' CALL t320_b()
                WHEN '2' CALL t320_b2()
            END CASE 

         WHEN "gen_entry"
            CALL t320_v()
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cde_h.cde01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF            
            CALL s_fsgl('CA',2,g_cde_h.cde05,0,g_cde_h.cde01,'1',g_cde_h.cdeconf,l_npptype,g_cde_h.cde05)  

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t320_drill_down()
            END IF
         WHEN "confirm"
            CALL t320_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t320_firm1_upd()                   
            END IF
            CALL t320_show()         
         WHEN "undo_confirm" 
            CALL t320_firm2()
            CALL t320_show() 
         WHEN "process_qry"  
            CALL cl_cmdrun_wait("axcp320")
            
         WHEN "carry_voucher"
            IF g_cde_h.cdeconf ='Y' THEN
               LET g_msg ="axcp301 ",g_cde_h.cde05," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cde_h.cde05 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
               DISPLAY g_nppglno TO nppglno 
            END IF      

         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cde_h.cde01,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cde_h.cde05 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
            DISPLAY g_nppglno TO nppglno       

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end
         #FUN-D60081--add--str--
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cde),base.TypeInfo.create(g_cdf),'')
            END IF
         #FUN-D60081--add--end--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cde_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cde.clear()
   CALL g_cdf.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t320_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t320_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cde_h.* TO NULL
   ELSE
      CALL t320_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t320_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t320_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t320_cs INTO g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
      WHEN 'P' FETCH PREVIOUS t320_cs INTO g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
      WHEN 'F' FETCH FIRST    t320_cs INTO g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
      WHEN 'L' FETCH LAST     t320_cs INTO g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
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
         FETCH ABSOLUTE g_jump t320_cs INTO g_cde_h.cde01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cde_h.cde01,SQLCA.sqlcode,0)
      INITIALIZE g_cde_h.* TO NULL  #TQC-6B0105
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
   SELECT  DISTINCT cde01,cde02,cde03,cde04,cde05,cdelegal,cdeconf,cdeoriu,cdeorig INTO g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04,g_cde_h.cde05,g_cde_h.cdelegal,g_cde_h.cdeconf,g_cde_h.cdeoriu,g_cde_h.cdeorig
     FROM  cde_file WHERE cde01 = g_cde_h.cde01 AND cde02 = g_cde_h.cde02 AND cde03 = g_cde_h.cde03 AND cde04 = g_cde_h.cde04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cde_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cde_h.* TO NULL
      RETURN
   ELSE   
      CALL t320_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t320_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME g_cde_h.cdeoriu,g_cde_h.cdeorig,
          g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04,
          g_cde_h.cde05,g_cde_h.cdelegal,g_cde_h.cdeconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cde_h.cdelegal
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cde_h.cde05 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL cl_set_field_pic(g_cde_h.cdeconf,"","","","","")
   CALL cl_show_fld_cont() 
   CALL t320_b_fill()                 #單身
   CALL t320_b2_fill()                #單身
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t320_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cde_h.cde01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cde_h.cdeconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t320_cl USING g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl.", STATUS, 1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t320_cl INTO g_cde_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cde_h.cde01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t320_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "cde01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 =  g_cde_h.cde01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM cde_file
       WHERE cde01 = g_cde_h.cde01 
         AND cde02 = g_cde_h.cde02
         AND cde03 = g_cde_h.cde03
         AND cde04 = g_cde_h.cde04
      IF l_cnt > 0 THEN
         DELETE FROM cde_file 
          WHERE cde01 = g_cde_h.cde01
            AND cde02 = g_cde_h.cde02
            AND cde03 = g_cde_h.cde03
            AND cde04 = g_cde_h.cde04
            
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cde_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","del cde.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM cdf_file 
       WHERE cdf01 = g_cde_h.cde01
         AND cdf02 = g_cde_h.cde02
         AND cdf03 = g_cde_h.cde03
         AND cdf04 = g_cde_h.cde04
         
      IF l_cnt > 0 THEN
         DELETE FROM cdf_file 
          WHERE cdf01 = g_cde_h.cde01
            AND cdf02 = g_cde_h.cde02
            AND cdf03 = g_cde_h.cde03
            AND cdf04 = g_cde_h.cde04

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdf_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","del cdf.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_cde_h.cde05
         AND nppsys= 'CA'
         AND npp00 = 2
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cde_h.cde05
            AND nppsys= 'CA'
            AND npp00 = 2
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cde_h.cde05
         AND npqsys= 'CA'
         AND npq00 = 2
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cde_h.cde05
            AND npqsys= 'CA'
            AND npq00 = 2
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
   #FUN-B40056 --Begin
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_cde_h.cde05
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cde_h.cde05
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("del","tic_file",g_cde_h.cde01,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   #FUN-B40056 --end
      INITIALIZE g_cde_h.* TO NULL
      CLEAR FORM
      CALL g_cde.clear()
      CALL g_cdf.clear()
      CALL t320_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t320_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t320_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t320_fetch('/')
      END IF
   END IF
   CLOSE t320_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cde_h.cde01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t320_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
       

   LET g_action_choice = ""
   IF g_cde_h.cde01 IS NULL THEN RETURN END IF
   CALL cl_opmsg('b')
   IF g_cde_h.cdeconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF
 
   LET g_forupd_sql = "SELECT cde06,cde11,cde07,cde12,cde13,cde08,cde09,'',cde10", #FUN-CB0120 add cde12  FUN-D20040 add cde13
                      " FROM cde_file",
                      " WHERE cde01=? AND cde02=? AND cde03 = ? AND cde04 = ? AND cde06 = ? AND cde07 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t320_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cde WITHOUT DEFAULTS FROM s_cde.*
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
             LET g_cde_t.* = g_cde[l_ac].*  #BACKUP
             OPEN t320_b2cl USING g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04,g_cde_t.cde06,g_cde_t.cde07
             IF STATUS THEN
                CALL cl_err("OPEN t320_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t320_b2cl INTO g_cde[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cde_h.cde02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cde[l_ac].aag02 FROM aag_file WHERE aag01 = g_cde[l_ac].cde09 AND aag00 = g_cde_h.cde01
             NEXT FIELD cde09
          END IF

       BEFORE INSERT  
       
       AFTER INSERT 
         
       AFTER FIELD cde09           
          IF g_cde[l_ac].cde09 IS NULL THEN
             LET g_cde[l_ac].cde09 = g_cde_t.cde09
             NEXT FIELD cde09
          END IF
          IF g_cde_t.cde09 IS NULL OR g_cde[l_ac].cde09 <> g_cde_t.cde09 THEN 
             SELECT aag02 INTO g_cde[l_ac].aag02
               FROM aag_file 
              WHERE aag01 = g_cde[l_ac].cde09 
                AND aag00 = g_cde_h.cde01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cde[l_ac].cde09,SQLCA.sqlcode,1)
                LET g_cde[l_ac].cde09 = g_cde_t.cde09
                NEXT FIELD cde09
             END IF 
          END IF 
 

       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac     #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D40030--add--str--
             IF p_cmd = 'u' THEN
                LET g_cde[l_ac].* = g_cde_t.*
             ELSE
                CALL g_cde.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"  
                   LET l_ac = l_ac_t
                   LET g_b_flag = '1'
                END IF
             END IF
             #FUN-D40030--add--end--
             CLOSE t320_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 Add  
          CLOSE t320_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cde[l_ac].* = g_cde_t.*
             CLOSE t320_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cde[l_ac].cde07,-263,1)
             LET g_cde[l_ac].* = g_cde_t.*
          ELSE  
             UPDATE cde_file SET cde09 = g_cde[l_ac].cde09
              WHERE cde01 = g_cde_h.cde01 
                AND cde02 = g_cde_h.cde02
                AND cde03 = g_cde_h.cde03
                AND cde04 = g_cde_h.cde04 
                AND cde06 = g_cde_t.cde06 
                AND cde07 = g_cde_t.cde07

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cde_file",g_cde_h.cde01,g_cde_h.cde02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cde[l_ac].* = g_cde_t.*
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
          IF INFIELD(cde09) AND l_ac > 1 THEN
          END IF
 

       ON ACTION CONTROLP
          IF INFIELD(cde09) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cde_h.cde01
             LET g_qryparam.default1 = g_cde[l_ac].cde09
             CALL cl_create_qry() RETURNING g_cde[l_ac].cde09
             DISPLAY g_cde[l_ac].cde09 TO cde09
             NEXT FIELD cde09
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
  
   CLOSE t320_b2cl
 
END FUNCTION

FUNCTION t320_b2()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
DEFINE l_cde           RECORD LIKE cde_file.*

   LET g_action_choice = ""
   IF g_cde_h.cde01 IS NULL THEN RETURN END IF
   IF g_cde_h.cdeconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdf07,cdf08,'',cdf09,cdf09a,cdf09b,cdf09c,cdf09d,cdf09e,cdf09f,cdf09g,cdf09h ", 
                      " FROM cdf_file",
                      " WHERE cdf01=? AND cdf02=? AND cdf03 = ? AND cdf04 = ? and cdf05 = ? AND cdf06 = ? AND cdf07 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t320_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdf WITHOUT DEFAULTS FROM s_cdf.*
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
           OPEN t320_cl USING g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04
           IF STATUS THEN
              CALL cl_err("OPEN t320_cl.", STATUS, 1)
              CLOSE t320_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t320_cl INTO l_cde.*              # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_cde_h.cde01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t320_cl
              ROLLBACK WORK
              RETURN
           END IF

          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_cdf_t.* = g_cdf[l_ac].*  #BACKUP
             OPEN t320_bcl USING g_cde_h.cde01,g_cde_h.cde02,g_cde_h.cde03,g_cde_h.cde04,g_cde_h.cde06,g_cde_h.cde07,g_cdf_t.cdf07
             IF STATUS THEN
                CALL cl_err("OPEN t320_bcl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t320_bcl INTO g_cdf[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdf_t.cdf07,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdf[l_ac].aag02_2 FROM aag_file WHERE aag01 = g_cdf[l_ac].cdf08 AND aag00 = g_cde_h.cde01
             NEXT FIELD cdf08
          END IF
 
       BEFORE INSERT
 
       AFTER INSERT
 
       AFTER FIELD cdf08           
          IF g_cdf[l_ac].cdf08 IS NULL THEN
             LET g_cdf[l_ac].cdf08 = g_cdf_t.cdf08
             NEXT FIELD cde08
          END IF
          IF g_cdf_t.cdf08 IS NULL OR g_cdf[l_ac].cdf08 <> g_cdf_t.cdf08 THEN 
             SELECT aag02 INTO g_cdf[l_ac].aag02_2
               FROM aag_file 
              WHERE aag01 = g_cdf[l_ac].cdf08 
                 AND aag00 = g_cde_h.cde01

             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdf[l_ac].cdf08,SQLCA.sqlcode,1)
                LET g_cdf[l_ac].cdf08 = g_cdf_t.cdf08
                NEXT FIELD cdf08
             END IF 
          END IF 
 
       BEFORE DELETE                            #是否取消單身
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdf[l_ac].* = g_cdf_t.*
             CLOSE t320_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdf[l_ac].cdf07,-263,1)
             LET g_cdf[l_ac].* = g_cdf_t.*
          ELSE                                                                                                              
             UPDATE cdf_file SET cdf08 = g_cdf[l_ac].cdf08
              WHERE cdf01 = g_cde_h.cde01 
                AND cdf02 = g_cde_h.cde02
                AND cdf03 = g_cde_h.cde03
                AND cdf04 = g_cde_h.cde04
                AND cdf05 = g_cde_h.cde06
                AND cdf06 = g_cde_h.cde07
                AND cdf07 = g_cdf_t.cdf07
                
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdf_file",g_cdf_t.cdf07,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdf[l_ac].* = g_cdf_t.*
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
                LET g_cdf[l_ac].* = g_cdf_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_cdf.deleteElement(l_ac)
                IF g_rec_b2 != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                   LET g_b_flag = '2'
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE t320_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 Add
          CLOSE t320_bcl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(cdf08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag02"
               LET g_qryparam.arg1 = g_cde_h.cde01 
               LET g_qryparam.default1 = g_cdf[l_ac].cdf08
               CALL cl_create_qry() RETURNING g_cdf[l_ac].cdf08 
               DISPLAY g_cdf[l_ac].cdf08 TO cdf08
               NEXT FIELD cdf08
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
     
   CLOSE t320_bcl
 
END FUNCTION
 
FUNCTION t320_b_fill()
    
 
   LET g_sql =  "SELECT cde06,cde11,cde07,cde12,cde13,cde08,cde09,'',cde10 ", #FUN-CB0120 add cde12 FUN-D20040 add cde13
                "  FROM cde_file",
                " WHERE cde01 ='",g_cde_h.cde01,"'",
                "   AND cde02 ='",g_cde_h.cde02,"'",
                "   AND cde03 ='",g_cde_h.cde03,"'",
                "   AND cde04 ='",g_cde_h.cde04,"'",
                " ORDER BY 1,2,3,4"
    PREPARE t320_pb FROM g_sql
    DECLARE cde_curs CURSOR FOR t320_pb
 
    CALL g_cde.clear()
    LET g_cnt = 1
    FOREACH cde_curs INTO g_cde[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cde[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cde[g_cnt].cde09 AND aag00 = g_cde_h.cde01

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cde.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_cde TO s_cde.*  ATTRIBUTE(COUNT=g_rec_b)         
      BEFORE DISPLAY
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='1'
                        
         BEFORE ROW
         LET l_ac = ARR_CURR() 
         LET l_ac1 = l_ac
         CALL cl_show_fld_cont()      
         LET g_cde_h.cde06 = g_cde[l_ac].cde06
         LET g_cde_h.cde07 = g_cde[l_ac].cde07
         CALL t320_b2_fill()
         
         AFTER DISPLAY
            CONTINUE DIALOG
      
      
      END DISPLAY
      
      DISPLAY ARRAY g_cdf TO s_cdf.*  ATTRIBUTE(COUNT=g_rec_b2)       
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
         CALL t320_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL t320_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL t320_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL t320_fetch('N')
         EXIT DIALOG
 
      ON ACTION last
         CALL t320_fetch('L')
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

FUNCTION t320_b2_fill()              #BODY FILL UP

    LET g_sql = "SELECT cdf07,cdf08,'',cdf09,cdf09a,cdf09b,cdf09c,cdf09d,cdf09e,cdf09f,cdf09g,cdf09h",   
                "  FROM cdf_file",
                " WHERE cdf01 ='",g_cde_h.cde01,"'",
                "   AND cdf02 ='",g_cde_h.cde02,"'",
                "   AND cdf03 ='",g_cde_h.cde03,"'",
                "   AND cdf04 ='",g_cde_h.cde04,"'",
                "   AND cdf05 ='",g_cde_h.cde06,"'",
                "   AND cdf06 ='",g_cde_h.cde07,"'",
                " ORDER BY cdf07,cdf08"
    PREPARE t320_pb2 FROM g_sql
    DECLARE cdf_curs CURSOR FOR t320_pb2
 
    CALL g_cdf.clear()
    LET g_cnt = 1
    FOREACH cdf_curs INTO g_cdf[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach.',STATUS,1)
          EXIT FOREACH
       END IF
          SELECT aag02 INTO g_cdf[g_cnt].aag02_2 FROM aag_file
             WHERE aag01 = g_cdf[g_cnt].cdf08 
               AND aag00 = g_cde_h.cde01

       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_cdf.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION

 
FUNCTION t320_v()
DEFINE  l_wc        STRING
   IF g_cde_h.cdeconf ='Y' THEN RETURN END IF 
   LET l_wc = "cde01 ='",g_cde_h.cde01,"' AND cde02 ='",g_cde_h.cde02,"' AND cde03 ='",g_cde_h.cde03,"' AND cde04 = '",g_cde_h.cde04,"'"
   LET g_success ='Y'
   CALL p320_gl(l_wc,g_cde_h.cde01)
   IF g_success ='N' THEN 
      RETURN  
   END IF  
   CALL t320_show()
   MESSAGE " "
END FUNCTION

                                                         
FUNCTION t320_drill_down()                                                      
   IF cl_null(l_ac1) THEN RETURN END IF                                                                              
   IF cl_null(g_cde[l_ac1].cde07) THEN RETURN END IF                                   
   LET g_msg = "axcq771 '",g_cde[l_ac1].cde07,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t320_count()
 
   DEFINE l_cde   DYNAMIC ARRAY of RECORD        # 程式變數
          cde01          LIKE cde_file.cde01, 
          cde02          LIKE cde_file.cde02,          
          cde03          LIKE cde_file.cde03,
          cde04          LIKE cde_file.cde04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE cde01,cde02,cde03,cde04 FROM cde_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED,
              "   AND ", g_wc1 CLIPPED    #FUN-D60095 add 
   PREPARE t320_precount FROM g_sql
   DECLARE t320_count CURSOR FOR t320_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t320_count INTO l_cde[li_cnt].*  
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

FUNCTION t320_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
#CHI-C30107 ---------- add ---------- begin
    IF g_cde_h.cdeconf ='Y' THEN LET g_success ='N' RETURN END IF
    IF g_cde_h.cde01 IS NULL THEN LET g_success ='N' RETURN END IF
    IF NOT cl_confirm('aap-222') THEN
       LET g_success ='N'
       RETURN
    END IF
    SELECT * INTO g_cde_h.* FROM cde_file
                           WHERE cde01 = g_cde_h.cde01
                             AND cde02 = g_cde_h.cde02
                             AND cde03 = g_cde_h.cde03
                             AND cde04 = g_cde_h.cde04
                             AND cde06 = g_cde_h.cde06
                             AND cde07 = g_cde_h.cde07
#CHI-C30107 ---------- add ---------- end
    IF g_cde_h.cdeconf ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cde_h.cde01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cde_h.cde01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cde_h.cde05,'CA',1,l_flg,g_cde_h.cde01)    
END FUNCTION 

FUNCTION t320_firm1_upd()
#CHI-C30107 ------------- mark ------------ begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 ------------- mark ------------ end

    LET g_cde_h.cdeconf ='Y' 
    UPDATE cde_file SET cdeconf ='Y' 
     WHERE cde01 = g_cde_h.cde01
       AND cde02 = g_cde_h.cde02
       AND cde03 = g_cde_h.cde03
       AND cde04 = g_cde_h.cde04
END FUNCTION 

FUNCTION t320_firm2()
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cde_h.cdeconf ='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cde_h.cdeconf ='N' 
    UPDATE cde_file SET cdeconf ='N' 
     WHERE cde01 = g_cde_h.cde01
       AND cde02 = g_cde_h.cde02
       AND cde03 = g_cde_h.cde03
       AND cde04 = g_cde_h.cde04
   
END FUNCTION 

