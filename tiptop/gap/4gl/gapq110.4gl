# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: gapq110.4gl
# Descriptions...: 應付帳款發票查詢
# Date & Author..: 05/09/29 by zm 
# Modify.........: No.TQC-640175 06/04/21 By Ray 流程訊息通知功能
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690080 06/09/29 By huchenghao 零用金修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0094 06/11/16 By Elva 報表打印制表日期有誤
# Modify.........: No.TQC-790126 07/09/24 By dxfwo運行程序，點帳款資料按鈕或雙擊單身即退出程序
# Modify.........: No.TQC-790156 07/09/27 By chenl  修改sql錯誤
# Modify.........: No.CHI-7C0004 07/12/04 By Smapmin 增加發票編號欄位
# Modify.........: No.MOD-810035 08/01/03 By Smapmin 單別改以動態方式抓取
# Modify.........: No.TQC-890019 08/09/12 By Sarah 修復FUN-880095增加參數,導致r.l2 gapq110失敗問題
# Modify.........: No.MOD-970177 09/07/20 By mike 將所有apk04改成apa06      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-BA0014 11/10/06 By Dido JOIN 欄位調整 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_apk   DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
            apk01   LIKE apk_file.apk01, 
            apk02   LIKE apk_file.apk02,
           #apk04   LIKE apk_file.apk04, #MOD-970177                                                                                
            apa06   LIKE apa_file.apa06, #MOD-970177 
            pmc03   LIKE pmc_file.pmc03,
            apk05   LIKE apk_file.apk05,
            apk03   LIKE apk_file.apk03,   #CHI-7C0004
	    apk11   LIKE apk_file.apk11,
	    apk29   LIKE apk_file.apk29,
	    apk08   LIKE apk_file.apk08,
	    apk07   LIKE apk_file.apk07, 
	    apk06   LIKE apk_file.apk06 
            END RECORD,
    g_apk_t RECORD                     #程式變數 (舊值)
            apk01   LIKE apk_file.apk01, 
            apk02   LIKE apk_file.apk02,
           #apk04   LIKE apk_file.apk04, #MOD-970177                                                                                
            apa06   LIKE apa_file.apa06, #MOD-970177 
            pmc03   LIKE pmc_file.pmc03,
            apk05   LIKE apk_file.apk05,
            apk03   LIKE apk_file.apk03,   #CHI-7C0004
	    apk11   LIKE apk_file.apk11,
	    apk29   LIKE apk_file.apk29,
	    apk08   LIKE apk_file.apk08,
	    apk07   LIKE apk_file.apk07, 
	    apk06   LIKE apk_file.apk06 
            END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(300)
    g_rec_b         LIKE type_file.num5,     #NO FUN-690009 SMALLINT   #單身筆數
    g_apk01         LIKE apk_file.apk01,
    g_apykind       LIKE apy_file.apykind,
    g_apyslip       LIKE apy_file.apyslip,
    l_ac            LIKE type_file.num5,     #NO FUN-690009 SMALLINT   #目前處理的ARRAY CNT
    g_msg           LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(300)
    l_apkacti       LIKE type_file.chr1      #NO FUN-690009 VARCHAR(1)
 
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10     #NO FUN-690009 INTEGER  
DEFINE g_i          LIKE type_file.num5      #NO FUN-690009 SMALLINT   #count/index for any purpose
DEFINE g_argv1      STRING                   #No.TQC-640175
DEFINE g_argv2      STRING                   #No.TQC-640175
DEFINE g_argv3      STRING                   #TQC-890019 add
DEFINE g_argv4      STRING                   #TQC-890019 add
 
MAIN
   OPTIONS                             #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                     #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0097
 
   OPEN WINDOW q110_w WITH FORM "gap/42f/gapq110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
        
   LET g_wc2 = '1=1' 
   CALL q110_b_fill(g_wc2)
 
   CALL q110_menu()
 
   CLOSE WINDOW q110_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0097
END MAIN
 
FUNCTION q110_menu()
 
   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q110_q() 
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #LET g_msg = "gapr110 \"",g_wc2 CLIPPED,"\" " CLIPPED   #TQC-610053
               #LET g_msg =  "gapr110 '' '' '",g_lang,"' 'Y' '' '' "," \"",g_wc2 CLIPPED,"\" '' '' '' " CLIPPED    #TQC-610053 #TQC-6B0094
               LET g_msg =  "gapr110 '",g_today,"' '' '",g_lang,"' 'Y' '' '' "," \"",g_wc2 CLIPPED,"\" '' '' '' " CLIPPED    #TQC-610053  #TQC-6B0094
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "Invoice Detail" 
            #借用全局變量g_dash傳遞參數
            IF cl_null(l_ac) OR l_ac = 0 THEN    #No.TQC-790126  查詢無資料,l_ac為零為空時，則會報錯
            ELSE                                 #No.TQC-790126  
            LET g_dash = g_apk[l_ac].apk01
            #LET g_apyslip = g_dash[1,3]   #MOD-810035
            LET g_apyslip = g_dash[1,g_doc_len]   #MOD-810035
            SELECT apykind INTO g_apykind 
              FROM apy_file
             WHERE apyslip = g_apyslip
            IF (NOT cl_setup("AAP")) THEN
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
            CALL t110(g_apykind,g_argv1,g_argv2,g_argv3,g_argv4)  #TQC-640175   #TQC-890019 add g_argv3,g_argv4
            END IF                                #No.TQC-790126 
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q110_q()
   CALL q110_b_askkey()
END FUNCTION
 
FUNCTION q110_b_askkey()
 
   CLEAR FORM
   CALL g_apk.clear()
   #CONSTRUCT g_wc2 ON apk01,apk02,apk04,pmc03,apk05,apk11,apk29,apk08,apk07,apk06   #CHI-7C0004
  #CONSTRUCT g_wc2 ON apk01,apk02,apk04,pmc03,apk05,apk03,apk11,apk29,apk08,apk07,apk06   #CHI-7C0004 #MOD-970177   
   CONSTRUCT g_wc2 ON apk01,apk02,apa06,pmc03,apk05,apk03,apk11,apk29,apk08,apk07,apk06   #MOD-970177
     #FROM s_apk[1].apk01,s_apk[1].apk02,s_apk[1].apk04,s_apk[1].pmc03, #MOD-970177
      FROM s_apk[1].apk01,s_apk[1].apk02,s_apk[1].apa06,s_apk[1].pmc03, #MOD-970177       
           #s_apk[1].apk05,s_apk[1].apk11,s_apk[1].apk29,s_apk[1].apk08,   #CHI-7C0004
           s_apk[1].apk05,s_apk[1].apk03,s_apk[1].apk11,s_apk[1].apk29,s_apk[1].apk08,   #CHI-7C0004
	   s_apk[1].apk07,s_apk[1].apk06
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(apk01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_m_apa5"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apk01    
               NEXT FIELD apk01
           
           #WHEN INFIELD(apk04) #MOD-970177                                                                                         
            WHEN INFIELD(apa06) #MOD-970177   
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06    #MOD-970177 apk04-->apa06    
               NEXT FIELD apa06  #MOD-970177 apk04-->apa06    
 
            WHEN INFIELD(apk11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gec"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apk11
               NEXT FIELD apk11
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
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('apkuser', 'apkgrup') #FUN-980030
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL q110_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q110_b_fill(p_wc2)            #BODY FILL UP
   DEFINE   p_wc2   LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(200)
 
  #LET g_sql = " SELECT apk01,apk02,apk04,pmc03,apk05,apk11,apk29,apk08,apk07,apk06 ",   #No.TQC-790156 mark
   #LET g_sql = " SELECT apk01,apk02,apa06,pmc03,apk05,apk11,apk29,apk08,apk07,apk06 ",   #No.TQC-790156    #CHI-7C0004
   LET g_sql = " SELECT apk01,apk02,apa06,pmc03,apk05,apk03,apk11,apk29,apk08,apk07,apk06 ", #CHI-7C0004
              #"   FROM apa_file,apk_file LEFT OUTER JOIN pmc_file ON apk_file.apk04=pmc_file.pmc01", #No.FUN-690080 #MOD-BA0014 mark
               "   FROM apa_file LEFT OUTER JOIN pmc_file ON apa_file.apa06=pmc_file.pmc01,apk_file ",               #MOD-BA0014 
               "  WHERE apk01 = apa01  ",                   #No.FUN-690080
              #"    AND apa06 = pmc01 ",                    #No.TQC-790156 add #MOD-BA0014 mark
               "    AND apkacti = 'Y' ",
               "    AND apa00 NOT IN ('13','17','25')",     #No.FUN-690080
               "    AND ",p_wc2 CLIPPED,
               " ORDER BY apk01 "
   PREPARE q110_pb FROM g_sql
   DECLARE apk_curs CURSOR FOR q110_pb
 
   CALL g_apk.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH apk_curs INTO g_apk[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '',9035,0)
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_apk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO FUN-690009 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apk TO s_apk.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="Invoice Detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION account_detail
         LET g_action_choice="Invoice Detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
