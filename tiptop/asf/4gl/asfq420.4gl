# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfq420.4gl
# Descriptions...: 工單入庫查詢
# Date & Author..: 93/06/02 By Keith
# Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-6C0021 06/12/05 By claire 沒有單身資料串查入庫明細程式會當出 
# Modify.........: No.TQC-750041 07/05/15 By mike  報表格式修改
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-890121 08/10/20 By jan 在asfq420的“查詢入庫明細“將"匯出excel" 的功能加入PACKAGE
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D60038 13/06/06 By wangrr "工單單號""製造部門"增加開窗,單身增加部門名稱品名規格欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Head Where condition
        	wc2  	LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(600)# Body Where condition
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb01   LIKE sfb_file.sfb01,
            sfb82   LIKE sfb_file.sfb82,
            gem02   LIKE gem_file.gem02, #TQC-D60038
            sfb15   LIKE sfb_file.sfb15,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02, #TQC-D60038
            ima021  LIKE ima_file.ima021,#TQC-D60038
            sfb08   LIKE sfb_file.sfb08,
            sfb09   LIKE sfb_file.sfb09
        END RECORD,
    g_sfh DYNAMIC ARRAY OF RECORD
            sfh13   LIKE sfh_file.sfh13,
            sfh02   LIKE sfh_file.sfh02,
            sfh08   LIKE sfh_file.sfh08,
            sfh06   LIKE sfh_file.sfh06,
            sfh07   LIKE sfh_file.sfh07,
            sfh09   LIKE sfh_file.sfh09,
            sfh10   LIKE sfh_file.sfh10
        END RECORD,
    g_argv1     LIKE sfb_file.sfb01,              # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,          #No.FUN-680121 SMALLINT#第一次進入程式時即進入Query之後進入next
    g_wc,g_wc2,g_cmd  string, #WHERE CONDITION   #No.FUN-580092 HCN
    g_sql           string, #WHERE CONDITION     #No.FUN-580092 HCN
    g_cnt1          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,   #MOD-6C0021 add
    g_rec_b LIKE type_file.num5   		  #單身筆數        #No.FUN-680121 SMALLINT
 
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680121 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0090
      DEFINE   l_sl,p_row,p_col LIKE type_file.num5  #No.FUN-680121 SMALLINT #No.FUN-6A0090
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
    LET g_argv1      = ARG_VAL(1)          #參數值(1) W/O No.
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q420_w AT p_row,p_col
         WITH FORM "asf/42f/asfq420"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q420_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q420_q() END IF
    CALL q420_menu()
    CLOSE WINDOW q420_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION q420_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
      CLEAR FORM #清除畫面
      CALL g_sfb.clear()
      CALL g_sfh.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      IF cl_null(g_argv1) THEN
         CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
         CONSTRUCT BY NAME tm.wc ON sfb01, sfb02, sfb04, sfb82, sfb15
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         #TQC-D60038--add--str--
         ON ACTION controlp
            CASE
               WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form  = "q_sfb"
                  LET g_qryparam.where = " sfb04 IN ('4','5','6','7','8') AND sfb09 > 0 "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
               WHEN INFIELD(sfb82)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form  = "q_sfb821"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb82
                  NEXT FIELD sfb82
            END CASE
         #TQC-D60038--add--end
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         IF INT_FLAG THEN RETURN END IF
      END IF
#     CALL q420_b_askkey()
#     IF INT_FLAG THEN RETURN END IF
 
	MESSAGE 'SEARCHING'
    IF cl_null(g_argv1) THEN
       LET g_sql=" SELECT UNIQUE sfb01,sfb82,'',sfb15,sfb05,'','',sfb08,sfb09 ", #TQC-D60038 add 3''
                 " FROM sfb_file ",
                 " WHERE sfb04 IN ('4','5','6','7','8') ",
                 " AND sfb09 > 0  AND ",tm.wc CLIPPED
    ELSE
       LET g_sql=" SELECT UNIQUE sfb01,sfb82,'',sfb15,sfb05,'','',sfb08,sfb09 ", #TQC-D60038 add 3''
                 " FROM sfb_file ",
                 " WHERE sfb04 IN ('4','5','6','7','8') ",
                 " AND sfb09 > 0  AND sfb01= '",g_argv1,"'"
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_sql = g_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_sql = g_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_sql = g_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_sql = g_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
   PREPARE q420_prepare FROM g_sql
   DECLARE q420_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q420_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF cl_null(g_argv1) THEN
      LET g_sql=" SELECT COUNT(*) FROM sfb_file ",
              " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT COUNT(*) FROM sfb_file ",
                 " WHERE sfb01= '",g_argv1,"'"
   END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_sql = g_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_sql = g_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_sql = g_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    #End:FUN-980030
 
 
   PREPARE q420_pp  FROM g_sql
   DECLARE q420_count   CURSOR FOR q420_pp
END FUNCTION
 
FUNCTION q420_menu()
   DEFINE l_cmd     LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q420_bp("G")
      CASE g_action_choice
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL q420_q()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
##
        #MOD-6C0021-begin
         WHEN "qry_store_in"
            IF cl_chk_act_auth() THEN
              IF l_ac > 0 THEN
                 #No.FUN-890121--BEGIN--
                 LET l_cmd = "asfq4201 '",g_sfb[l_ac].sfb01,"' ",                                                                                
                               "'",g_sfb[l_ac].sfb05,"'"                                                                                 
                 CALL cl_cmdrun_wait(l_cmd)
#                CALL q420_qry(g_sfb[l_ac].sfb01,g_sfb[l_ac].sfb05)
                 #No.FUN-890121--END--
              END IF 
            END IF
 
         WHEN "qry_wip_detail"
            IF cl_chk_act_auth() THEN
              IF l_ac > 0 THEN
                 LET g_cmd = "asfq430 '",g_sfb[l_ac].sfb01,"' '2'"
                 CALL cl_cmdrun(g_cmd)
              END IF 
            END IF
        #MOD-6C0021-end
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION q420_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
  # DISPLAY '   ' TO FORMONLY.cnt
    CALL q420_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q420_show()
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q420_show()
   CALL q420_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q420_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
    CALL g_sfb.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q420_cs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_sfb[g_cnt].sfb08 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb08 = 0
        END IF
        IF g_sfb[g_cnt].sfb09 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb09 = 0
        END IF
      #TQC-D60038--add--str--
      SELECT gem02 INTO g_sfb[g_cnt].gem02 FROM gem_file WHERE gem01=g_sfb[g_cnt].sfb82
      SELECT ima02,ima021 INTO g_sfb[g_cnt].ima02,g_sfb[g_cnt].ima021
      FROM ima_file WHERE ima01=g_sfb[g_cnt].sfb05
      #TQC-D60038--add--end
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
    DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
    END DISPLAY
 
END FUNCTION
 
FUNCTION q420_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)
        #   l_ac          LIKE type_file.num5,          #No.FUN-680121 SMALLINT  #MOD-6C0021 mark
            l_n           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_sl          LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         #LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION qry_store_in
        #MOD-6C0021-begin-add
         #IF NOT cl_null(g_sfb[l_ac].sfb01) THEN
         #   CALL q420_qry(g_sfb[l_ac].sfb01,g_sfb[l_ac].sfb05)
         #END IF
         LET g_action_choice="qry_store_in"
         EXIT DISPLAY
        #MOD-6C0021-end-add
      
      ON ACTION qry_wip_detail
        #MOD-6C0021-begin-add
         # IF NOT cl_null(g_sfb[l_ac].sfb01) THEN
         #    LET g_cmd = "asfq430 '",g_sfb[l_ac].sfb01,"' '2'"
         #    CALL cl_cmdrun(g_cmd)
         # END IF
         LET g_action_choice="qry_wip_detail"
         EXIT DISPLAY
        #MOD-6C0021-end-add
 
       #--No.MOD-4A0012--#
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #-------END-------#
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END      
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-890121--BEGIN--MARK--
{FUNCTION q420_qry(p_sfb01,p_sfb05)
  DEFINE
      l_qq     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      p_sfb01  LIKE sfb_file.sfb01,
      p_sfb05  LIKE sfb_file.sfb05
 
    OPEN WINDOW q4201_w AT 2,2
         WITH FORM "asf/42f/asfq4201"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asfq4201")
 
 
    DISPLAY p_sfb01 TO sfb01
    DISPLAY p_sfb05 TO sfb05
 
    LET g_sql=" SELECT sfh13,sfh02,sfh08,sfh06,sfh07,sfh09,sfh10 ",
              " FROM sfh_file ",
              " WHERE sfh01 = '",p_sfb01,"'",
              " AND sfh03 IN ('2','3')"
    PREPARE q420_prepare1 FROM g_sql
    DECLARE q420_cs1                         #SCROLL CURSOR
            SCROLL CURSOR FOR q420_prepare1
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q420_cs1                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q420_dis()
        CALL q421_bbp('G')
    END IF
    CLOSE WINDOW q4201_w
 END FUNCTION
 
 FUNCTION q420_dis()
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
    CALL g_sfh.clear()
    LET g_cnt1 = 1
    FOREACH q420_cs1 INTO g_sfh[g_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_sfh[g_cnt1].sfh06 IS NULL THEN
  	       LET g_sfh[g_cnt1].sfh06 = 0
        END IF
        LET g_cnt1 = g_cnt1 + 1
    END FOREACH
    LET g_cnt1 = g_cnt1 - 1
  END FUNCTION
 
FUNCTION q421_bbp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)   #MOD-6C0021 modify true->false
   DISPLAY ARRAY g_sfh TO s_sfh.* ATTRIBUTE(COUNT=g_cnt1,UNBUFFERED)
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      #   LET l_sl = SCR_LINE()
#No.TQC-750041  --BEGIN--
 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#
#No.TQC-750041  --END--
     #MOD-6C0021-begin-add
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   #LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
   
        #No.FUN-890121--BEGIN--
        ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            IF cl_chk_act_auth() THEN                                                                                               
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               LET page = f.FindNode("Page","page01")
              CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfh),'','')
            END IF
        #No.FUN-890121--END--
       ON ACTION cancel
       #  LET g_action_choice="exit"
          LET INT_FLAG = FALSE
          EXIT DISPLAY
 
       ON ACTION exit
          LET INT_FLAG = FALSE
          EXIT DISPLAY
 
     #MOD-6C0021-end-add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)   
END FUNCTION}
#No.FUN-890121--END--MARK--
