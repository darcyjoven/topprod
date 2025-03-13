# Prog. Version..: '5.30.07-13.06.07(00010)'     #
# Pattern name.... axct325.4gl
# Descriptions.... 杂项进出差异分录结转作业
# Date & Author... 2010/07/03 By wujie #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-C20135 12/02/15 By yinhy 产生分錄底稿時增加部門，按是否部門管理賦值
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C70138 12/07/13 By yinhy 串查時增加傳參
# Modify.........: No:MOD-C90248 12/09/28 By wujie 通过关联ime区分同批下不同科目的资料
#                                                  产生分录时做截位
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.MOD-CC0003 12/12/03 By wujie 考虑ime09为空的情况
# Modify.........: No.FUN-CC0153 13/01/23 By wujie 调整增加cdl14项目编号cdl15WBS编号的影响
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D40131 13/04/18 By wujie 隐藏批量产生按钮
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D60081 13/06/18 By lujh 增加excel匯出功能,修改查詢時程序down出的問題
# Modify.........: No:FUN-D60095 13/06/20 By lujh 增加傳參
# Modify.........: No:MOD-DB0075 13/11/12 By suncx show()函数中，查询g_nppglno之前清空該變量 
# Modify.........: No:FUN-D80089 13/12/13 By fengmy 加入部门所属成本中心的判断

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
        cdl09            LIKE cdl_file.cdl09,
        aag02            LIKE aag_file.aag02,
        cdl10            LIKE cdl_file.cdl10,
        sum1             LIKE cdl_file.cdl10,
        diff             LIKE cdl_file.cdl10
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
        cdl09            LIKE cdl_file.cdl09,
        aag02            LIKE aag_file.aag02,
        cdl10            LIKE cdl_file.cdl10,
        sum1             LIKE cdl_file.cdl10,
        diff             LIKE cdl_file.cdl10
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
DEFINE  g_b_flag        LIKE type_file.chr1 
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_aag44         LIKE aag_file.aag44   #FUN-D40118 add
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
   DECLARE t325_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t325_w AT p_row,p_col WITH FORM "axc/42f/axct325"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t325_q()
   END IF
   #FUN-D60095--add--end--

   CALL t325_menu()
   CLOSE WINDOW t325_w               

#   CALL cl_used(g_prog,l_time,2)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN

#QBE 查詢資料
FUNCTION t325_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cdl.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_cdl_h.* TO NULL    
      IF cl_null(g_wc1) THEN  #FUN-D60095 add 
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON cdl04,cdl01,cdllegal,cdl02,cdl03,cdl12
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
         END CONSTRUCT  

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cdl01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdl01
                  NEXT FIELD cdl01
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
 
   LET g_sql = "SELECT UNIQUE cdl01,cdl02,cdl03,cdl04 ",
               "  FROM cdl_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND  ", g_wc1 CLIPPED,    #FUN-D60095 add
               " ORDER BY 1,2,3,4"

 
   PREPARE t325_prepare FROM g_sql
   DECLARE t325_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t325_prepare
 
END FUNCTION

FUNCTION t325_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t325_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t325_q()
            END IF
 
       # WHEN "delete"
       #    IF cl_chk_act_auth() THEN
       #       CALL t325_r()
       #    END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            CALL t325_b()
            
         WHEN "gen_entry"
            CALL t325_v()
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cdl_h.cdl01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF            
            CALL s_fsgl('CA',7,g_cdl_h.cdl12,0,g_cdl_h.cdl01,'1',g_cdl_h.cdlconf,l_npptype,g_cdl_h.cdl12)  

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t325_drill_down()
            END IF

         WHEN "confirm"
            CALL t325_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t325_firm1_upd()                   
            END IF
            CALL t325_show()         
         WHEN "undo_confirm" 
            CALL t325_firm2()
            CALL t325_show()

         WHEN "process_qry"  
            CALL cl_cmdrun_wait("axcp324")          

         WHEN "carry_voucher"
            IF g_cdl_h.cdlconf1 ='Y' THEN
               LET g_msg ="axcp301 ",g_cdl_h.cdl12," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl12 AND nppsys ='CA' AND npp00 =7 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
            END IF


         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdl_h.cdl01,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl12 AND nppsys ='CA' AND npp00 =7 AND npp011 =1
            DISPLAY g_nppglno TO nppglno

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end
        #FUN-D60081--add--str--
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cdl),'','')
            END IF
         #FUN-D60081--add--end--

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t325_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cdl_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cdl.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t325_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t325_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdl_h.* TO NULL
   ELSE
      CALL t325_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t325_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t325_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t325_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'P' FETCH PREVIOUS t325_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'F' FETCH FIRST    t325_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
      WHEN 'L' FETCH LAST     t325_cs INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
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
         FETCH ABSOLUTE g_jump t325_cs INTO g_cdl_h.cdl01
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
   SELECT  DISTINCT cdl01,cdl02,cdl03,cdl04,cdl12,cdllegal,cdlconf1 INTO g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl_h.cdl12,g_cdl_h.cdllegal,g_cdl_h.cdlconf1     
     FROM  cdl_file WHERE cdl01 = g_cdl_h.cdl01 AND cdl02 = g_cdl_h.cdl02 AND cdl03 = g_cdl_h.cdl03 AND cdl04 = g_cdl_h.cdl04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdl_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdl_h.* TO NULL
      RETURN
   ELSE   
      CALL t325_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t325_show()
DEFINE l_azt02    LIKE azt_file.azt02

   LET g_nppglno = NULL  #MOD-DB0075
   DISPLAY BY NAME 
          g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,
          g_cdl_h.cdl12,g_cdl_h.cdllegal,g_cdl_h.cdlconf1
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdl_h.cdllegal
   CALL cl_set_field_pic(g_cdl_h.cdlconf1,"","","","","") 
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdl_h.cdl12 AND nppsys ='CA' AND npp00 =7 AND npp011 =1
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL t325_b_fill()                 #單身
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t325_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cdl_h.cdl01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cdl_h.cdlconf1 = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t325_cl USING g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04
   IF STATUS THEN
      CALL cl_err("OPEN t325_cl.", STATUS, 1)
      CLOSE t325_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t325_cl INTO g_cdl_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdl_h.cdl01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t325_show()
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
       WHERE npp01 = g_cdl_h.cdl12
         AND nppsys= 'CA'
         AND npp00 = 7
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cdl_h.cdl12
            AND nppsys= 'CA'
            AND npp00 = 7
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cdl_h.cdl01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cdl_h.cdl12
         AND npqsys= 'CA'
         AND npq00 = 7
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cdl_h.cdl12
            AND npqsys= 'CA'
            AND npq00 = 7
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
       WHERE tic04 = g_cdl_h.cdl12
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cdl_h.cdl12
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_cdl_h.cdl12,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056  --end
      INITIALIZE g_cdl_h.* TO NULL
      CLEAR FORM
      CALL g_cdl.clear()
      CALL t325_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t325_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t325_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t325_fetch('/')
      END IF
   END IF
   CLOSE t325_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cdl_h.cdl01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t325_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
       

   LET g_action_choice = ""
   IF g_cdl_h.cdl01 IS NULL THEN RETURN END IF
   IF g_cdl_h.cdlconf1 = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdl13,cdl06,'',cdl05,'',cdl16,'',cdl07,'',cdl09,'',cdl10,'','' ",   #FUN-D80089 add cdl16,''
  #LET g_forupd_sql = "SELECT cdl13,cdl06,'',cdl05,'',cdl07,'',cdl09,'',cdl10,'','' ", 
                      " FROM cdl_file",
                      " WHERE cdl01=? AND cdl02=? AND cdl03 = ? AND cdl04 = ? AND cdl05 = ? AND cdl06 = ? AND cdl07 = ? AND cdl13 = ? AND cdl14 = ? AND cdl15 = ? FOR UPDATE"    #No.FUN-CC0153 add cdl14,cdl15
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t325_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
             OPEN t325_b2cl USING g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl_t.cdl05,g_cdl_t.cdl06,g_cdl_t.cdl07,g_cdl_t.cdl13,g_cdl_h.cdl14,g_cdl_h.cdl15       #No.FUN-CC0153 add cdl14,cdl15
             IF STATUS THEN
                CALL cl_err("OPEN t325_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t325_b2cl INTO g_cdl[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdl_h.cdl02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdl[l_ac].aag02 FROM aag_file WHERE aag01 = g_cdl[l_ac].cdl09 AND aag00 = g_cdl_h.cdl01
             SELECT azf03 INTO g_cdl[l_ac].azf03 FROM azf_file WHERE azf01 = g_cdl[l_ac].cdl06 AND azf02 = '2'
             SELECT gem02 INTO g_cdl[l_ac].gem02 FROM gem_file WHERE gem01 = g_cdl[l_ac].cdl05
             SELECT gem02 INTO g_cdl[l_ac].gem02_1 FROM gem_file WHERE gem01 = g_cdl[l_ac].cdl16   #FUN-D80089 add
             SELECT ima02 INTO g_cdl[l_ac].ima02 FROM ima_file WHERE ima01 = g_cdl[l_ac].cdl07
            #SELECT SUM(tlfc907*(tlfc221+tlfc2231+tlfc2232+tlfc224+tlfc2241+tlfc2242+tlfc2243)) INTO g_cdl[l_ac].sum1 
             SELECT SUM(tlfc907*tlfc21) INTO g_cdl[l_ac].sum1 
               FROM tlf_file,tlfc_file 
              WHERE tlfctype = g_cdl_h.cdl04
                AND tlfc01 = tlf01 
                AND tlfc06 = tlf06 
                AND tlfc02 = tlf02 
                AND tlfc03 = tlf03
                AND tlfc13 = tlf13 
                AND tlfc902 = tlf902
                AND tlfc903 = tlf903
                AND tlfc904 = tlf904
                AND tlfc905 = tlf905
                AND tlfc906 = tlf906
                AND tlfc907 = tlf907 
              # AND tlfc00 = g_cdl_h.cdl01
                AND tlf01  = g_cdl[l_ac].cdl07 
                AND tlflegal = g_cdl_h.cdllegal
                AND tlf14 = g_cdl[l_ac].cdl06
                AND tlf19 = g_cdl[l_ac].cdl05
                AND YEAR(tlf06)  = g_cdl_h.cdl02
                AND MONTH(tlf06) = g_cdl_h.cdl03
                AND (tlf13 ='aimt301' OR tlf13 ='aimt311'
                      OR tlf13 ='aimt302' OR tlf13 ='aimt312' 
                      OR tlf13 ='aimt303' OR tlf13 ='aimt313' 
                      OR tlf13 ='atmt260' OR tlf13 ='atmt261')

#No.MOD-CC0001 --begin
              LET g_cdl[l_ac].cdl10 = cl_digcut(g_cdl[l_ac].cdl10,g_ccz.ccz26)
              LET g_cdl[l_ac].sum1 = cl_digcut(g_cdl[l_ac].sum1,g_ccz.ccz26)
#No.MOD-CC0001 --end                      
             IF cl_null(g_cdl[l_ac].sum1) THEN LET g_cdl[l_ac].sum1 =0 END IF 
             LET g_cdl[l_ac].diff = g_cdl[l_ac].sum1 - g_cdl[l_ac].cdl10
             NEXT FIELD cdl09
          END IF

       BEFORE INSERT  
       
       AFTER INSERT 
         
          
       AFTER FIELD cdl09           
          IF g_cdl[l_ac].cdl09 IS NULL THEN
             LET g_cdl[l_ac].cdl09 = g_cdl_t.cdl09
             NEXT FIELD cdl09
          END IF
          IF g_cdl_t.cdl09 IS NULL OR g_cdl[l_ac].cdl09 <> g_cdl_t.cdl09 THEN 
             SELECT aag02 INTO g_cdl[l_ac].aag02
               FROM aag_file 
              WHERE aag01 = g_cdl[l_ac].cdl09 
                AND aag00 = g_cdl_h.cdl01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdl[l_ac].cdl09,SQLCA.sqlcode,1)
                LET g_cdl[l_ac].cdl09 = g_cdl_t.cdl09
                NEXT FIELD cdl09
             END IF 
          END IF 
 

       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac      #FUN-D40030 Mark
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
             CLOSE t325_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D40030 Add
          CLOSE t325_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdl[l_ac].* = g_cdl_t.*
             CLOSE t325_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdl[l_ac].cdl05,-263,1)
             LET g_cdl[l_ac].* = g_cdl_t.*
          ELSE  
             UPDATE cdl_file SET cdl09 = g_cdl[l_ac].cdl09
              WHERE cdl01 = g_cdl_h.cdl01 
                AND cdl02 = g_cdl_h.cdl02
                AND cdl03 = g_cdl_h.cdl03
                AND cdl04 = g_cdl_h.cdl04 
                AND cdl05 = g_cdl_t.cdl05 
                AND cdl06 = g_cdl_t.cdl06
                AND cdl07 = g_cdl_t.cdl07
#No.FUN-CC0153 --begin
                AND cdl13 = g_cdl_t.cdl13
                AND cdl14 = g_cdl_h.cdl14
                AND cdl15 = g_cdl_h.cdl15
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
          IF INFIELD(cdl09) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdl_h.cdl01
             LET g_qryparam.default1 = g_cdl[l_ac].cdl09
             CALL cl_create_qry() RETURNING g_cdl[l_ac].cdl09
             DISPLAY g_cdl[l_ac].cdl09 TO cdl09
             NEXT FIELD cdl09
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
  
   CLOSE t325_b2cl
 
END FUNCTION
 
FUNCTION t325_b_fill()
    
 
   LET g_sql =  "SELECT cdl13,cdl06,'',cdl05,'',cdl16,'',cdl07,'',cdl09,'',cdl10,'',''  ",   #FUN-D80089 add cdl16,''
  #LET g_sql =  "SELECT cdl13,cdl06,'',cdl05,'',cdl07,'',cdl09,'',cdl10,'',''  ",   #FUN-D80089 add cdl16,''
                "  FROM cdl_file",
                " WHERE cdl01 ='",g_cdl_h.cdl01,"'",
                "   AND cdl02 ='",g_cdl_h.cdl02,"'",
                "   AND cdl03 ='",g_cdl_h.cdl03,"'",
                "   AND cdl04 ='",g_cdl_h.cdl04,"'",
                " ORDER BY 1,2,3,5"
    PREPARE t325_pb FROM g_sql
    DECLARE cdl_curs CURSOR FOR t325_pb
 
    CALL g_cdl.clear()
    LET g_cnt = 1
    FOREACH cdl_curs INTO g_cdl[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cdl[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cdl[g_cnt].cdl09 AND aag00 = g_cdl_h.cdl01
       SELECT azf03 INTO g_cdl[g_cnt].azf03 FROM azf_file WHERE azf01 = g_cdl[g_cnt].cdl06 AND azf02 = '2'
       SELECT gem02 INTO g_cdl[g_cnt].gem02 FROM gem_file WHERE gem01 = g_cdl[g_cnt].cdl05
       SELECT gem02 INTO g_cdl[g_cnt].gem02_1 FROM gem_file WHERE gem01 = g_cdl[g_cnt].cdl16   #FUN-D80089 add
       SELECT ima02 INTO g_cdl[g_cnt].ima02 FROM ima_file WHERE ima01 = g_cdl[g_cnt].cdl07
      #SELECT SUM(tlfc907*(tlfc221+tlfc2231+tlfc2232+tlfc224+tlfc2241+tlfc2242+tlfc2243)) INTO g_cdl[g_cnt].sum1 
       SELECT SUM(tlfc907*tlfc21) INTO g_cdl[g_cnt].sum1 
        #FROM tlf_file,tlfc_file LEFT OUTER JOIN ime_file ON tlf902 = ime01 AND tlf903 = ime02 AND ime09 = g_cdl[g_cnt].cdl09   #NO.MOD-C90248 add ime_file   MOD-CC0003 left join
         FROM tlfc_file,tlf_file LEFT OUTER JOIN ime_file ON tlf902 = ime01 AND tlf903 = ime02 AND ime09 = g_cdl[g_cnt].cdl09   #FUN-D70120 修正LEFT JOIN错误
          AND imeacti = 'Y'    #FUN-D40103
        WHERE tlfctype = g_cdl_h.cdl04
          AND tlfc01 = tlf01 
          AND tlfc06 = tlf06 
          AND tlfc02 = tlf02 
          AND tlfc03 = tlf03
          AND tlfc13 = tlf13 
          AND tlfc902 = tlf902
          AND tlfc903 = tlf903
          AND tlfc904 = tlf904
          AND tlfc905 = tlf905
          AND tlfc906 = tlf906
          AND tlfc907 = tlf907 
          AND tlf01  = g_cdl[g_cnt].cdl07 
          AND tlflegal = g_cdl_h.cdllegal
          AND tlf14 = g_cdl[g_cnt].cdl06
          AND tlf19 = g_cdl[g_cnt].cdl05
          AND YEAR(tlf06)  = g_cdl_h.cdl02
          AND MONTH(tlf06) = g_cdl_h.cdl03
          --AND tlf904 = g_cdl[g_cnt].cdl13   #NO.MOD-C90248  #mark by dengsy161209
          AND (tlf13 ='aimt301' OR tlf13 ='aimt311'
                OR tlf13 ='aimt302' OR tlf13 ='aimt312' 
                OR tlf13 ='aimt303' OR tlf13 ='aimt313' 
                OR tlf13 ='atmt260' OR tlf13 ='atmt261')
                
       IF cl_null(g_cdl[g_cnt].sum1) THEN LET g_cdl[g_cnt].sum1 =0 END IF 
     #FUN-D60081--mark--str--
#No.MOD-CC0001 --begin
       #LET g_cdl[l_ac].cdl10 = cl_digcut(g_cdl[l_ac].cdl10,g_ccz.ccz26)
       #LET g_cdl[l_ac].sum1 = cl_digcut(g_cdl[l_ac].sum1,g_ccz.ccz26)
#No.MOD-CC0001 --end
       #FUN-D60081--mark--end--
       #FUN-D60081--add--str--
       LET g_cdl[g_cnt].cdl10 = cl_digcut(g_cdl[g_cnt].cdl10,g_ccz.ccz26)
       LET g_cdl[g_cnt].sum1 = cl_digcut(g_cdl[g_cnt].sum1,g_ccz.ccz26)
       #FUN-D60081--add--end--

       LET g_cdl[g_cnt].diff = g_cdl[g_cnt].sum1 - g_cdl[g_cnt].cdl10
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdl.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t325_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_set_act_visible("process_qry", FALSE)   #No.MOD-D40131
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
 
   #只能从axct324删除
   #  ON ACTION delete
   #     LET g_action_choice="delete"
   #     EXIT DISPLAY
 
      ON ACTION first
         CALL t325_fetch('F')
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t325_fetch('P')
         EXIT DISPLAY
 
      ON ACTION jump
         CALL t325_fetch('/')
         EXIT DISPLAY
 
      ON ACTION next
         CALL t325_fetch('N')
         EXIT DISPLAY
 
      ON ACTION last
         CALL t325_fetch('L')
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
     
      #FUN-D60081--add--str--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-D60081--add--end--

      AFTER DISPLAY
         CONTINUE DISPLAY   
                        
   END DISPLAY
      
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

 
FUNCTION t325_v()
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype,
                           yy          LIKE type_file.num5,
                           mm          LIKE type_file.num5,
                           b           LIKE aaa_file.aaa01
                           END RECORD 

   IF g_cdl_h.cdlconf1 ='Y' THEN RETURN END IF 
   LET tm.b = g_cdl_h.cdl01
   LET tm.yy = g_cdl_h.cdl02
   LET tm.mm = g_cdl_h.cdl03
   LET tm.tlfctype = g_cdl_h.cdl04
   LET g_success ='Y'
   CALL p325_gl(tm.*)
   IF g_success ='N' THEN 
      RETURN  
   END IF  
   CALL t325_show()
   MESSAGE " "
END FUNCTION

                                                         
FUNCTION t325_drill_down()                                                      
   DEFINE l_flag  LIKE type_file.chr1   #MOD-C70138
   IF cl_null(l_ac1) OR l_ac1 = 0 THEN RETURN END IF                                                                              
   IF cl_null(g_cdl[l_ac1].cdl07) THEN RETURN END IF                                   
   #No.MOD-C70138  --Begin
   LET l_flag = '+'
   IF g_cdl[l_ac1].cdl10 < 0 THEN
      LET l_flag = '-'
   END IF
   #No.MOD-C70138  --End
   LET g_msg = "axcq770 '",g_cdl[l_ac1].cdl07,"' '",g_cdl_h.cdl02,"' '",g_cdl_h.cdl03,"'
                '",g_cdl[l_ac1].cdl13,"' '",g_cdl[l_ac1].cdl06,"' '",g_cdl[l_ac1].cdl05,"'  '",l_flag,"'"  #MOD-C70138

   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t325_count() 
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
   PREPARE t325_precount FROM g_sql
   DECLARE t325_count CURSOR FOR t325_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t325_count INTO l_cdl[li_cnt].*  
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

FUNCTION p325_gl(tm)
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_cdl       RECORD LIKE cdl_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz22     LIKE ccz_file.ccz22
DEFINE l_ccz23     LIKE ccz_file.ccz23    #MOD-C20135
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_cdl01     LIKE cdl_file.cdl01
DEFINE l_cdl02     LIKE cdl_file.cdl02
DEFINE l_cdl03     LIKE cdl_file.cdl03
DEFINE l_cdl04     LIKE cdl_file.cdl04 
DEFINE l_cdl05     LIKE cdl_file.cdl05
DEFINE l_cdl16     LIKE cdl_file.cdl16    #FUN-D80089 add
DEFINE l_cdl08     LIKE cdl_file.cdl08
DEFINE l_cdl09     LIKE cdl_file.cdl09
DEFINE l_cdl10     LIKE cdl_file.cdl10
DEFINE l_cdl12     LIKE cdl_file.cdl12
DEFINE l_diff      LIKE cdl_file.cdl10
DEFINE g_wc        STRING 
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype,
                           yy          LIKE type_file.num5,
                           mm          LIKE type_file.num5,
                           b           LIKE aaa_file.aaa01
                           END RECORD 
DEFINE l_n,l_i     LIKE type_file.num5
DEFINE l_sumc      LIKE npq_file.npq07
DEFINE l_sumd      LIKE npq_file.npq07
DEFINE l_sumfc     LIKE npq_file.npq07f
DEFINE l_sumfd     LIKE npq_file.npq07f
DEFINE l_aag05     LIKE aag_file.aag05
DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add

   INITIALIZE l_cdl.* TO NULL

   LET g_success = 'N' 
   #delete cdl16 by dengsy161209
   #change cdl05 to cdl16 by dengsy161209
   DROP TABLE cdl_file_tmp
   CREATE TEMP TABLE cdl_file_tmp (
        cdl01   LIKE cdl_file.cdl01,
        cdl02   LIKE cdl_file.cdl02,
        cdl03   LIKE cdl_file.cdl03,
        cdl04   LIKE cdl_file.cdl04,
        cdl16   LIKE cdl_file.cdl16,
        cdl09   LIKE cdl_file.cdl09,
        diff    LIKE cdl_file.cdl10); #FUN-D80089  change cdl05 to cdl16 暫時先mark
           
   SELECT ccz12,ccz22,ccz23 INTO l_ccz12,l_ccz22,l_ccz23 FROM ccz_file  #MOD-C20135
   
   LET l_i =1
   FOR l_i =1 TO g_cdl.getlength()
       IF g_cdl[l_i].diff = 0 THEN CONTINUE FOR END IF  
       SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = g_cdl_h.cdl01 AND aag01 = g_cdl[l_i].cdl09
       IF l_aag05 = 'Y' THEN 
         #INSERT INTO cdl_file_tmp VALUES (g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl[l_i].cdl05,g_cdl[l_i].cdl09,g_cdl[l_i].diff)  #FUN-D80089 mark   #FUN-D80089 remark
          INSERT INTO cdl_file_tmp VALUES (g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,g_cdl[l_i].cdl16,g_cdl[l_i].cdl09,g_cdl[l_i].diff)   #FUN-D80089 add  #FUN-D80089 mark
       ELSE 
          INSERT INTO cdl_file_tmp VALUES (g_cdl_h.cdl01,g_cdl_h.cdl02,g_cdl_h.cdl03,g_cdl_h.cdl04,'',g_cdl[l_i].cdl09,g_cdl[l_i].diff)  
       END IF 
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL s_errmsg('nppsys','CA','insert cdl_file_tmp',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
       END IF
   END FOR 

   LET l_sql = "SELECT DISTINCT cdl01,cdl02,cdl03,cdl04,cdllegal ",
               "  FROM cdl_file ",
               " WHERE cdl01 ='",tm.b CLIPPED,"'",
               "   AND cdl02 ='",tm.yy CLIPPED,"'",
               "   AND cdl03 ='",tm.mm CLIPPED,"'",
               "   AND cdl04 ='",tm.tlfctype CLIPPED,"'"

   PREPARE p325_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p325_c3 CURSOR FOR p325_p3

  #LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl05,SUM(diff) ",   #FUN-D80089 mark  #FUN-D80089 remark
   LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl16,SUM(diff) ",    #FUN-D80089 add #FUN-D80089 mark
               "  FROM cdl_file_tmp ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ",
              #" GROUP BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl05 ",   #FUN-D80089 mark    #FUN-D80089 remark
              #" ORDER BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl05 "    #FUN-D80089 mark    #FUN-D80089 remark
               " GROUP BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl16 ",    #FUN-D80089 add   #FUN-D80089 mark
               " ORDER BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl16 "     #FUN-D80089 add   #FUN-D80089 mark

   PREPARE p325_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p325_c4 CURSOR FOR p325_p4
      
   FOREACH p325_c3 INTO l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdllegal  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      IF l_cdl.cdl01 = l_ccz12 THEN 
         LET l_npp.npptype =0
      ELSE
         LET l_npp.npptype =1
      END IF  
      LET l_date = MDY(l_cdl.cdl03,1,l_cdl.cdl02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.npp00    = 7
      LET l_npp.npp01    = 'F',l_cdl.cdl04 CLIPPED,l_cdl.cdl01 CLIPPED,'-',l_cdl.cdl02 USING '&&&&',l_cdl.cdl03 CLIPPED USING '&&','0001'
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      LET l_npp.npp06    = g_plant         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = l_cdl.cdl01
      LET l_npp.npplegal = l_cdl.cdllegal
      
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 7
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
         AND nppglno IS NOT NULL 
         
      IF l_n >0 THEN  
         CALL cl_err(l_npp.npp01,'axm-275',1)
         LET g_success ='N' 
         RETURN 
      END IF 
                
      DELETE FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 7
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
      
      INSERT INTO npp_file VALUES(l_npp.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nppsys','CA','insert npp_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH 

   #insert npq_file 單身
   DELETE FROM npq_file
    WHERE npqsys  = 'CA'
      AND npq00   = 7
      AND npq01   = l_npp.npp01
      AND npq011  = 1
      AND npqtype = l_npp.npptype
      
   #FUN-B40056 --begin
   DELETE FROM tic_file
    WHERE tic04 = l_npp.npp01
   #FUN-B40056 --end

   LET l_npq02 = 1

   FOREACH p325_c4 USING  l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04
                   #INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl09,l_cdl05,l_diff   #FUN-D80089 mark
                    INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl09,l_cdl16,l_diff    #FUN-D80089 add
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqsys ='CA'
      LET l_npq.npq00  = 7
      LET l_npq.npq01  =l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq02 = l_npq02
      LET l_npq.npq03 = l_cdl09
      LET l_npq.npq04 = ''
     #LET l_npq.npq05 = l_cdl05   #FUN-D80089 mark
      LET l_npq.npq05 = l_cdl16    #FUN-D80089 add
      IF l_diff >0 THEN 
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f = l_diff  
         LET l_npq.npq07  = l_diff
      ELSE 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07f = l_diff*(-1)  
         LET l_npq.npq07  = l_diff*(-1)
      END IF   
    # LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
    # LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
#No.MOD-C90248 --begin
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_npq.npq24  
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)   
#No.MOD-C90248 --end
      LET l_npq.npq08 = NULL
      LET l_npq.npq11 = ' '
      LET l_npq.npq12 = ' '
      LET l_npq.npq13 = ' '
      LET l_npq.npq14 = ' '
      LET l_npq.npq15 = NULL
      LET l_npq.npq21 = NULL
      LET l_npq.npq22 = NULL
      LET l_npq.npq24 = g_aza.aza17
      LET l_npq.npq25 = 1
      LET l_npq.npq30 = l_npp.npp06
      LET l_npq.npq31 = ' '
      LET l_npq.npq32 = ' '
      LET l_npq.npq33 = ' '
      LET l_npq.npq34 = ' '
      LET l_npq.npq35 = ' '
      LET l_npq.npq36 = ' '
      LET l_npq.npq37 = ' '
      LET l_npq.npqtype = l_npp.npptype
      LET l_npq.npqlegal =l_npp.npplegal
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = l_cdl.cdl01 
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,l_cdl.cdl01) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES(l_npq.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_npq02 = l_npq02 + 1 
      LET g_success ='Y'
   END FOREACH   

   IF NOT cl_null(l_npp.npp01) AND g_success ='Y' THEN
      LET l_cdl.cdl12 = l_npp.npp01
      UPDATE cdl_file SET cdl12 = l_cdl.cdl12 
       WHERE cdl01 = l_cdl.cdl01
         AND cdl02 = l_cdl.cdl02
         AND cdl03 = l_cdl.cdl03
         AND cdl04 = l_cdl.cdl04
      LET g_cdl_h.cdl12 = l_npp.npp01
   END IF   
#尾差
   SELECT SUM(npq07) INTO l_sumc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 7
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07) INTO l_sumd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 7
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '2'

   SELECT SUM(npq07f) INTO l_sumfc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 7
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07f) INTO l_sumfd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 7
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '2'

   IF cl_null(l_sumc) THEN LET l_sumc =0 END IF 
   IF cl_null(l_sumd) THEN LET l_sumd =0 END IF 
   IF cl_null(l_sumfc) THEN LET l_sumfc =0 END IF 
   IF cl_null(l_sumfd) THEN LET l_sumfd =0 END IF 

   IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 7
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccz22         
         LET l_npq.npq04 = ''
         IF NOT cl_null(l_aag05) AND l_aag05 = 'N' THEN  #MOD-C20135
            LET l_npq.npq05 = NULL
         #No.MOD-C20135  --Begin
         ELSE
            LET l_npq.npq05 = l_ccz23
         END IF
         #No.MOD-C20135  --End
         IF l_sumc - l_sumd >0 THEN
            LET l_npq.npq06 = '2'
            LET l_npq.npq07f = l_sumfc - l_sumfd 
            LET l_npq.npq07  = l_sumc  - l_sumd         
         ELSE 
            LET l_npq.npq06 = '1'        
            LET l_npq.npq07f = l_sumfd - l_sumfc 
            LET l_npq.npq07  = l_sumd  - l_sumc
         END IF 
         LET l_npq.npq08 = NULL
         LET l_npq.npq11 = ' '
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
         LET l_npq.npq24 = g_aza.aza17
#No.MOD-C90248 --begin
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_npq.npq24  
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  
         LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)   
#No.MOD-C90248 --end
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_cdl.cdl01
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,l_cdl.cdl01) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1   
   END IF 
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   IF g_success ='Y' THEN CALL cl_err('','abm-019',0) END IF 
   IF g_success ='N' THEN CALL cl_err('','aap-129',0) END IF 
END FUNCTION

FUNCTION t325_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
#CHI-C30107 --------------- add --------------- begin
    IF g_cdl_h.cdlconf1 ='Y' THEN LET g_success ='N' RETURN END IF
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
#CHI-C30107 --------------- add --------------- end
    IF g_cdl_h.cdlconf1 ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cdl_h.cdl01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cdl_h.cdl01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cdl_h.cdl12,'CA',1,l_flg,g_cdl_h.cdl01)    
END FUNCTION 

FUNCTION t325_firm1_upd()
#CHI-C30107 ------------- mark --------------- begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 ------------- mark --------------- end
    LET g_cdl_h.cdlconf1 ='Y' 
    UPDATE cdl_file SET cdlconf1 ='Y' 
     WHERE cdl01 = g_cdl_h.cdl01
       AND cdl02 = g_cdl_h.cdl02
       AND cdl03 = g_cdl_h.cdl03
       AND cdl04 = g_cdl_h.cdl04
END FUNCTION 

FUNCTION t325_firm2()
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cdl_h.cdlconf1 ='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cdl_h.cdlconf1 ='N' 
    UPDATE cdl_file SET cdlconf1 ='N' 
     WHERE cdl01 = g_cdl_h.cdl01
       AND cdl02 = g_cdl_h.cdl02
       AND cdl03 = g_cdl_h.cdl03
       AND cdl04 = g_cdl_h.cdl04
   
END FUNCTION 
