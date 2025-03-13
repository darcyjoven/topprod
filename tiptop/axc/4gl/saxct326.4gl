# Prog. Version..: '5.30.06-13.04.25(00002)'     #
#
# Pattern name.... saxct326.4gl
# Descriptions.... 入库成本调整分录结转作业
# Date & Author... 2011/11/11 By elva #No.FUN-BB0038
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C90002 12/09/03  By minpp  拆成副程式saxct326，供axct326以及axct329共同使用
# Modify.........: No.FUN-CA0100 12/10/17 By minpp 抛转凭证与还原，去掉“电脑正在处理中”信息
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No:FUN-D60095 13/06/24 By max1   增加傳參
# Modify.........: No:FUN-D60081 13/06/18 By lujh 增加excel匯出功能
# Modify.........: No.TQC-D70025 13/07/05 By wujie 调用fsgl时要区分axct326还是axct329
# Modify.........: No.MOD-D80009 13/08/01 By wujie 凭证抛转还原时时要区分axct326还是axct329
# Modify.........: No.MOD-DB0003 13/11/01 By suncx 所有抓取npp_file的操作都應該區分axct326还是axct329

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-BB0038
#模組變數(Module Variables)
DEFINE
    g_cdm_h         RECORD LIKE cdm_file.*,    #(假單頭)
    g_cdm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdm05            LIKE cdm_file.cdm05,    
        cdm11            LIKE cdm_file.cdm11,
        cdm06            LIKE cdm_file.cdm06,
        ima02            LIKE ima_file.ima02,   
        cdm07            LIKE cdm_file.cdm07,
        aag02            LIKE aag_file.aag02,
        cdm09            LIKE cdm_file.cdm09
                    END RECORD,
    g_cdm_t         RECORD                 #程式變數 (舊值)
        cdm05            LIKE cdm_file.cdm05,  
        cdm11            LIKE cdm_file.cdm11,         
        cdm06            LIKE cdm_file.cdm06,
        ima02            LIKE ima_file.ima02,   
        cdm07            LIKE cdm_file.cdm07,
        aag02            LIKE aag_file.aag02,
        cdm09            LIKE cdm_file.cdm09
                    END RECORD,
    g_rec_b             LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
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
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_cdm00         LIKE cdm_file.cdm00     #FUN-C90002
DEFINE  g_wc1           STRING    #FUN-D60095  add
DEFINE  g_npp00         LIKE npp_file.npp00    #MOD-DB0003 add

#MAIN                                           #FUN-C90002
FUNCTION t326(p_argv1)                          #FUN-C90002
DEFINE l_time           LIKE type_file.chr8           
DEFINE p_row,p_col      LIKE type_file.num5 
DEFINE p_argv1          LIKE cdm_file.cdm00     #FUN-C90002
   #FUN-C90002---MARK--STR
   #OPTIONS                              
   #   INPUT NO WRAP                    
   #DEFER INTERRUPT                    

   #IF (NOT cl_user()) THEN
   #   EXIT PROGRAM
   #END IF
 
   #WHENEVER ERROR CONTINUE 
 
   #IF (NOT cl_setup("AXC")) THEN
   #   EXIT PROGRAM
   #END IF

   #FUN-D60095--add--str--
   LET g_wc1 = ARG_VAL(1)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
   #FUN-D60095--add--end--

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   #FUN-C90002---MARK--END
  #WHENEVER ERROR CONTINUE                           #FUN-C90002
   WHENEVER ERROR CALL cl_err_msg_log                #FUN-C90002
   LET g_cdm00 = p_argv1                             #FUN-C90002
   LET g_forupd_sql = "SELECT * FROM cdm_file WHERE cdm00 = '",g_cdm00,"' AND cdm01 = ? AND cdm02 = ? AND cdm03 = ? AND cdm04 = ? FOR UPDATE"   #FUN-C90002 add--cdm00
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t326_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t326_w AT p_row,p_col WITH FORM "axc/42f/axct326"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-C90002---add---str
    IF g_cdm00='2' THEN
       CALL cl_set_comp_visible('cdm11',FALSE)
    ELSE
       CALL cl_set_comp_visible('cdm11',TRUE)     
    END IF 
   #FUN-C90002---add---end
   IF g_cdm00='2' THEN LET g_npp00 = 8 ELSE LET g_npp00 =9 END IF #MOD-DB0003 add
  
   #FUN-D60095--add--str--
   IF NOT cl_null(g_wc1) THEN
      CALL t326_q()
   END IF
   #FUN-D60095--add--end--
   
   CALL t326_menu()
   CLOSE WINDOW t326_w               

   #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211   #FUN-C90002
END FUNCTION      #FUN-C90002   
#END MAIN         #FUN-C90002

#QBE 查詢資料
FUNCTION t326_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cdm.clear()

 
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_cdm_h.* TO NULL    
        IF cl_null(g_wc1) THEN  #FUN-D60095 add 
         CONSTRUCT BY NAME g_wc ON cdm04,cdm01,cdmlegal,cdm02,cdm03,cdm10
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
  

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cdm01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdm01
                  NEXT FIELD cdm01
               OTHERWISE EXIT CASE
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
         
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION accept
               EXIT CONSTRUCT
         
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT CONSTRUCT 
          
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT CONSTRUCT 
      END CONSTRUCT 
     END IF    #FUN-D60095 add   
   
   IF cl_null(g_wc) THEN
      LET g_wc =' 1=1' 
   END IF  

 #FUN-D60095--add--str--
   IF cl_null(g_wc1) THEN
      LET g_wc1 = '1=1'
   END IF
   #FUN-D60095--add--end--
 
   LET g_sql = "SELECT UNIQUE cdm01,cdm02,cdm03,cdm04 ",
               "  FROM cdm_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND  ", g_wc1 CLIPPED,    #FUN-D60095 add
               "    AND cdm00 = '",g_cdm00,"'",           #FUN-C90002
               " ORDER BY cdm01,cdm02,cdm03,cdm04"

 
   PREPARE t326_prepare FROM g_sql
   DECLARE t326_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t326_prepare
 
END FUNCTION

FUNCTION t326_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t326_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc1 = NULL   #FUN-D60095 add
               CALL t326_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t326_r()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t326_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "gen_entry"
            CALL t326_v()
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cdm_h.cdm01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF             
#No.TQC-D70025 --begin
#            CALL s_fsgl('CA',9,g_cdm_h.cdm10,0,g_cdm_h.cdm01,'1',g_cdm_h.cdmconf,l_npptype,g_cdm_h.cdm10) 
            IF g_cdm00='2' THEN                   #FUN-C90002           
               CALL s_fsgl('CA',8,g_cdm_h.cdm10,0,g_cdm_h.cdm01,'1',g_cdm_h.cdmconf,l_npptype,g_cdm_h.cdm10) 
            ELSE                                  #FUN-C90002
               CALL s_fsgl('CA',9,g_cdm_h.cdm10,0,g_cdm_h.cdm01,'1',g_cdm_h.cdmconf,l_npptype,g_cdm_h.cdm10) 
            END IF 
#No.TQC-D70025 --end

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t326_drill_down()
            END IF

         WHEN "confirm"
            CALL t326_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t326_firm1_upd()                   
            END IF
            CALL t326_show()         

         WHEN "undo_confirm" 
            CALL t326_firm2()
            CALL t326_show()

         WHEN "process_qry" 
            IF g_cdm00='2' THEN                   #FUN-C90002           
               CALL cl_cmdrun_wait("axcp329")     #FUN-C90002
            ELSE                                  #FUN-C90002
               CALL cl_cmdrun_wait("axcp326")
            END IF                                #FUN-C90002    
 
         WHEN "carry_voucher"
            IF g_cdm_h.cdmconf ='Y' THEN
               LET g_msg ="axcp301 ",g_cdm_h.cdm10," '' '' '' ",
                          "'' '' '' 'N' '' ''"
             # CALL cl_wait()         #FUN-CA0100
               CALL cl_cmdrun_wait(g_msg)
#No.MOD-D80009 --begin
               IF g_cdm00 = '2' THEN
                  SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =8 AND npp011 =1
               ELSE
                  SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =9 AND npp011 =1
               END IF
#No.MOD-D80009 --end
               DISPLAY g_nppglno TO nppglno
            END IF

         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdm_h.cdm01,"' '",g_nppglno CLIPPED,"' 'Y'"
           #CALL cl_wait()           #FUN-CA0100
            CALL cl_cmdrun_wait(g_msg)
#No.MOD-D80009 --begin
            IF g_cdm00 = '2' THEN
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =8 AND npp011 =1
            ELSE
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =9 AND npp011 =1
            END IF
#No.MOD-D80009 --end
            DISPLAY g_nppglno TO nppglno

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end
 
         #FUN-D60081--add--str--
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cdm),'','')
            END IF
         #FUN-D60081--add--end--

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t326_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cdm_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cdm.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t326_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t326_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdm_h.* TO NULL
   ELSE
      CALL t326_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t326_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t326_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t326_cs INTO g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04
      WHEN 'P' FETCH PREVIOUS t326_cs INTO g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04
      WHEN 'F' FETCH FIRST    t326_cs INTO g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04
      WHEN 'L' FETCH LAST     t326_cs INTO g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04
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
         FETCH ABSOLUTE g_jump t326_cs INTO g_cdm_h.cdm01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdm_h.cdm01,SQLCA.sqlcode,0)
      INITIALIZE g_cdm_h.* TO NULL  #TQC-6B0105
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
   SELECT  DISTINCT cdm01,cdm02,cdm03,cdm04,cdm10,cdmlegal,cdmconf 
     INTO  g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04,g_cdm_h.cdm10,g_cdm_h.cdmlegal,g_cdm_h.cdmconf
     FROM  cdm_file 
    WHERE  cdm00 = g_cdm00     #FUN-C90002
      AND  cdm01 = g_cdm_h.cdm01 
      AND  cdm02 = g_cdm_h.cdm02 
      AND  cdm03 = g_cdm_h.cdm03 
      AND  cdm04 = g_cdm_h.cdm04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdm_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdm_h.* TO NULL
      RETURN
   ELSE   
      CALL t326_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t326_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME 
          g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04,
          g_cdm_h.cdm10,g_cdm_h.cdmlegal,g_cdm_h.cdmconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdm_h.cdmlegal
  #SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =9 AND npp011 =1
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =g_npp00 AND npp011 =1  #MOD-DB0003 9 -> g_npp00
   CALL cl_set_field_pic(g_cdm_h.cdmconf,"","","","","")
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL t326_b_fill()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t326_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =g_npp00 AND npp011 =1 #MOD-DB0003 add
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cdm_h.cdm01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cdm_h.cdmconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t326_cl USING g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04
   IF STATUS THEN
      CALL cl_err("OPEN t326_cl.", STATUS, 1)
      CLOSE t326_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t326_cl INTO g_cdm_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdm_h.cdm01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t326_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL                       
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM cdm_file
       WHERE cdm00 = g_cdm00              #FUN-C90002
         AND cdm01 = g_cdm_h.cdm01 
         AND cdm02 = g_cdm_h.cdm02
         AND cdm03 = g_cdm_h.cdm03
         AND cdm04 = g_cdm_h.cdm04
      IF l_cnt > 0 THEN
         DELETE FROM cdm_file 
          WHERE cdm00 = g_cdm00              #FUN-C90002
            AND cdm01 = g_cdm_h.cdm01
            AND cdm02 = g_cdm_h.cdm02
            AND cdm03 = g_cdm_h.cdm03
            AND cdm04 = g_cdm_h.cdm04
            
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdm_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","del cdm.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_cdm_h.cdm10
         AND nppsys= 'CA'
        #AND npp00 = 9
         AND npp00 = g_npp00  #MOD-DB0003 9 -> g_npp00
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cdm_h.cdm10
            AND nppsys= 'CA'
           #AND npp00 = 9
            AND npp00 = g_npp00  #MOD-DB0003 9 -> g_npp00
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cdm_h.cdm10
         AND npqsys= 'CA'
         AND npq00 = 9
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cdm_h.cdm10
            AND npqsys= 'CA'
            AND npq00 = 9
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      #FUN-B40056  --begin
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_cdm_h.cdm10
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cdm_h.cdm10
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_cdm_h.cdm10,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056  --end
      INITIALIZE g_cdm_h.* TO NULL
      CLEAR FORM
      CALL g_cdm.clear()
      CALL t326_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t326_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t326_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t326_fetch('/')
      END IF
   END IF
   CLOSE t326_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cdm_h.cdm01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t326_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5,     #MOD-650097  #No.FUN-690028 SMALLINT
       l_aag03         LIKE aag_file.aag03,
       l_aag07         LIKE aag_file.aag07 
      
       

   LET g_action_choice = ""
   IF g_cdm_h.cdm01 IS NULL THEN RETURN END IF
   IF g_cdm_h.cdmconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdm05,cdm11,cdm06,'',cdm07,'',cdm09", 
                      " FROM cdm_file",
                      " WHERE cdm00 = '",g_cdm00,"'AND cdm01=? AND cdm02=? AND cdm03 = ? AND cdm04 = ? AND cdm05 = ? AND cdm06 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t326_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdm WITHOUT DEFAULTS FROM s_cdm.*
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
             LET g_cdm_t.* = g_cdm[l_ac].*  #BACKUP
             OPEN t326_b2cl USING g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04,g_cdm_t.cdm05,g_cdm_t.cdm06
             IF STATUS THEN
                CALL cl_err("OPEN t326_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t326_b2cl INTO g_cdm[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdm_h.cdm02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdm[l_ac].aag02 FROM aag_file WHERE aag01 = g_cdm[l_ac].cdm07 AND aag00 = g_cdm_h.cdm01 
             SELECT ima02 INTO g_cdm[l_ac].ima02 FROM ima_file WHERE ima01 = g_cdm[l_ac].cdm06 
             NEXT FIELD cdm07
          END IF
         
       AFTER FIELD cdm07           
          IF g_cdm[l_ac].cdm07 IS NULL THEN
             LET g_cdm[l_ac].cdm07 = g_cdm_t.cdm07
             NEXT FIELD cdm07
          END IF
          IF g_cdm_t.cdm07 IS NULL OR g_cdm[l_ac].cdm07 <> g_cdm_t.cdm07 THEN 
             SELECT aag02,aag03,aag07 INTO g_cdm[l_ac].aag02,l_aag03,l_aag07
               FROM aag_file 
              WHERE aag01 = g_cdm[l_ac].cdm07 
                AND aag00 = g_cdm_h.cdm01             
             IF STATUS THEN 
                CALL cl_err(g_cdm[l_ac].cdm07,SQLCA.sqlcode,1)
                LET g_cdm[l_ac].cdm07 = g_cdm_t.cdm07
                NEXT FIELD cdm07
             END IF  
             IF l_aag07='1' THEN 
                CALL cl_err(g_cdm[l_ac].cdm07,'agl-015',0) 
                NEXT FIELD cdm07
             END IF  
             IF l_aag03!='2' THEN
                CALL cl_err(g_cdm[l_ac].cdm07,'agl-201',0) 
                NEXT FIELD cdm07 
             END IF
          END IF  

       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t326_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t326_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdm[l_ac].* = g_cdm_t.*
             CLOSE t326_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdm[l_ac].cdm06,-263,1)
             LET g_cdm[l_ac].* = g_cdm_t.*
          ELSE  
             UPDATE cdm_file SET cdm07 = g_cdm[l_ac].cdm07
              WHERE cdm00 = g_cdm00              #FUN-C90002
                AND cdm01 = g_cdm_h.cdm01 
                AND cdm02 = g_cdm_h.cdm02
                AND cdm03 = g_cdm_h.cdm03
                AND cdm04 = g_cdm_h.cdm04 
                AND cdm05 = g_cdm_t.cdm05
                AND cdm06 = g_cdm_t.cdm06 

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdm_file",g_cdm_h.cdm01,g_cdm_h.cdm02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdm[l_ac].* = g_cdm_t.*
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

       ON ACTION CONTROLP
          IF INFIELD(cdm07) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdm_h.cdm01
             LET g_qryparam.default1 = g_cdm[l_ac].cdm07 
             LET g_qryparam.where = " aag03 IN ('2') AND aag01 LIKE '",g_cdm[l_ac].cdm07 CLIPPED,"%'" 
             CALL cl_create_qry() RETURNING g_cdm[l_ac].cdm07
             DISPLAY g_cdm[l_ac].cdm07 TO cdm07
             NEXT FIELD cdm07
          END IF  
          
       ON ACTION CONTROLZ
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
  
   CLOSE t326_b2cl
 
END FUNCTION
 
FUNCTION t326_b_fill()
    
 
   LET g_sql =  "SELECT cdm05,cdm11,cdm06,'',cdm07,'',cdm09 ",
                "  FROM cdm_file",
                " WHERE cdm00 = '",g_cdm00,"'",           #FUN-C90002
                "   AND cdm01 ='",g_cdm_h.cdm01,"'",
                "   AND cdm02 ='",g_cdm_h.cdm02,"'",
                "   AND cdm03 ='",g_cdm_h.cdm03,"'",
                "   AND cdm04 ='",g_cdm_h.cdm04,"'",
                " ORDER BY cdm05,cdm11,cdm06,cdm07"
    PREPARE t326_pb FROM g_sql
    DECLARE cdm_curs CURSOR FOR t326_pb
 
    CALL g_cdm.clear()
    LET g_cnt = 1
    FOREACH cdm_curs INTO g_cdm[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cdm[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cdm[g_cnt].cdm07 AND aag00 = g_cdm_h.cdm01
       SELECT ima02 INTO g_cdm[g_cnt].ima02 FROM ima_file WHERE ima01 = g_cdm[g_cnt].cdm06 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdm.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t326_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()

      DISPLAY ARRAY g_cdm TO s_cdm.*  ATTRIBUTE(COUNT=g_rec_b)         
      BEFORE DISPLAY
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
                        
         BEFORE ROW
         LET l_ac = ARR_CURR() 
         LET l_ac1 = l_ac
         CALL cl_show_fld_cont()      
         LET g_cdm_h.cdm05 = g_cdm[l_ac].cdm05
  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t326_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION previous
         CALL t326_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t326_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION next
         CALL t326_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION last
         CALL t326_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

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
 
      ON ACTION drill_down1
         LET g_action_choice="drill_down1"
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
         EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution                                                    

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
        
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t326_v()
DEFINE  l_wc        STRING
   IF g_cdm_h.cdmconf ='Y' THEN RETURN END IF 
   LET l_wc = "cdm01 ='",g_cdm_h.cdm01,"' AND cdm02 ='",g_cdm_h.cdm02,"' AND cdm03 ='",g_cdm_h.cdm03,"' AND cdm04 = '",g_cdm_h.cdm04,"'"
   LET g_success ='Y'
   CALL p326_gl(g_cdm_h.cdm04,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm01,g_cdm00)     #FUN-C90002--ADD--g_cdm00
   IF g_success ='N' THEN 
      RETURN  
   END IF 
#wujie 130705 --begin
   SELECT  DISTINCT cdm01,cdm02,cdm03,cdm04,cdm10,cdmlegal,cdmconf 
     INTO  g_cdm_h.cdm01,g_cdm_h.cdm02,g_cdm_h.cdm03,g_cdm_h.cdm04,g_cdm_h.cdm10,g_cdm_h.cdmlegal,g_cdm_h.cdmconf
     FROM  cdm_file 
    WHERE  cdm00 = g_cdm00     #FUN-C90002
      AND  cdm01 = g_cdm_h.cdm01 
      AND  cdm02 = g_cdm_h.cdm02 
      AND  cdm03 = g_cdm_h.cdm03 
      AND  cdm04 = g_cdm_h.cdm04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdm_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdm_h.* TO NULL
      RETURN
   ELSE   
      CALL t326_show()
   END IF
#wujie 130705 --end
END FUNCTION                                                                                                                         

FUNCTION t326_count()  
   DEFINE l_cdm   DYNAMIC ARRAY of RECORD        # 程式變數
          cdm01          LIKE cdm_file.cdm01, 
          cdm02          LIKE cdm_file.cdm02,          
          cdm03          LIKE cdm_file.cdm03,
          cdm04          LIKE cdm_file.cdm04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE cdm01,cdm02,cdm03,cdm04 FROM cdm_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED ,
              "   AND ",g_wc1 CLIPPED,    #FUN-D60095 add
              "    AND cdm00='",g_cdm00,"'"               #FUN-C90002
   PREPARE t326_precount FROM g_sql
   DECLARE t326_count CURSOR FOR t326_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t326_count INTO l_cdm[li_cnt].*  
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

FUNCTION t326_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
    #CHI-C30107 --------------- add -------------- begin
    IF g_cdm_h.cdmconf ='Y' THEN LET g_success ='N' RETURN END IF
    IF g_cdm_h.cdm01 IS NULL THEN 
       CALL cl_err('',-400,0)          #FUN-CA0100   
       LET g_success ='N' 
       RETURN 
    END IF
    IF NOT cl_confirm('aap-222') THEN
       LET g_success ='N'
       RETURN
    END IF
    SELECT * INTO g_cdm_h.* FROM cdm_file 
     WHERE cdm01 = g_cdm_h.cdm01
       AND cdm02 = g_cdm_h.cdm02
       AND cdm03 = g_cdm_h.cdm03
       AND cdm04 = g_cdm_h.cdm04
#wujie 130626 --begin
       AND cdm05 = g_cdm_h.cdm05
       AND cdm05 = g_cdm_h.cdm06
       AND cdm11 = g_cdm_h.cdm11
       AND cdm00 = g_cdm_h.cdm00
#wujie 130626 --end
#CHI-C30107 --------------- add -------------- end
    IF g_cdm_h.cdmconf ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cdm_h.cdm01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cdm_h.cdm01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cdm_h.cdm10,'CA',1,l_flg,g_cdm_h.cdm01)    
END FUNCTION 

FUNCTION t326_firm1_upd()

#CHI-C30107 -------------- mark -------------- begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 -------------- mark -------------- end
    LET g_cdm_h.cdmconf ='Y' 
    UPDATE cdm_file SET cdmconf ='Y' 
     WHERE cdm00 = g_cdm00              #FUN-C90002
       AND cdm01 = g_cdm_h.cdm01
       AND cdm02 = g_cdm_h.cdm02
       AND cdm03 = g_cdm_h.cdm03
       AND cdm04 = g_cdm_h.cdm04 
    IF SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
       CALL cl_err3("upd","cdm_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","upd cdm.",1)  #No.FUN-660122
       RETURN
    END IF      
END FUNCTION 

FUNCTION t326_firm2()
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdm_h.cdm10 AND nppsys ='CA' AND npp00 =g_npp00 AND npp011 =1 #MOD-DB0003 add
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cdm_h.cdmconf ='N' THEN RETURN END IF
   #FUN-CA0100--add--str
   IF g_cdm_h.cdm01 IS NULL THEN
       CALL cl_err('',-400,0)         
       LET g_success ='N'
       RETURN
    END IF
   #FUN-CA0100--add---end
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cdm_h.cdmconf ='N' 
    UPDATE cdm_file SET cdmconf ='N' 
     WHERE cdm00 = g_cdm00              #FUN-C90002
       AND cdm01 = g_cdm_h.cdm01
       AND cdm02 = g_cdm_h.cdm02
       AND cdm03 = g_cdm_h.cdm03
       AND cdm04 = g_cdm_h.cdm04
    IF SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
       CALL cl_err3("upd","cdm_file",g_cdm_h.cdm01,"",SQLCA.sqlcode,"","upd cdm.",1)  #No.FUN-660122
       RETURN
    END IF  
END FUNCTION 

FUNCTION t326_drill_down()
DEFINE l_cdm06     LIKE cdm_file.cdm06    #FUN-C90002
DEFINE l_cdm05     LIKE cdm_file.cdm05    #FUN-C90002
   IF cl_null(l_ac1) THEN RETURN END IF
   IF g_cdm00='1'  THEN                                   #FUN-C90002
      IF cl_null(g_cdm[l_ac1].cdm11) THEN RETURN END IF
      LET g_msg = "axct002 '",g_cdm[l_ac1].cdm06,"' '",g_cdm_h.cdm02,"' '",g_cdm_h.cdm03,"' '",g_cdm[l_ac1].cdm11,"' '", 
                   g_cdm_h.cdm04,"' '",g_cdm[l_ac1].cdm05,"'"
   #FUN-C90002---ADD---STR
   ELSE
      LET g_msg = "axcq329 '",g_cdm[l_ac1].cdm06,"' '",g_cdm_h.cdm02,"' '",g_cdm_h.cdm03,"'  '", 
                  g_cdm_h.cdm04,"' '",g_cdm[l_ac1].cdm05,"'"               
   END IF                 
   #FUN-C90002---ADD--END                                                              
   CALL cl_cmdrun(g_msg)
END FUNCTION
