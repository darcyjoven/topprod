# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axrq320.4gl
# Descriptions...: 客戶應收帳款查詢
# Date & Author..: 95/02/09 By Nick
#                  查詢時,輸入單身條件無作用、客戶編號加簡稱為Unique
# Modify.........: No.8522 03/10/20 By Kitty 加show本幣,合計改show本幣
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-5C0014 06/05029 By rainy 顯示發票號碼及INVOICE NO.
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-920050 09/09/18 By mike 將客戶(occ01)改為可開窗挑選,使用q_occ查詢代號  
# Modify.........: No:FUN-A30028 10/03/30 By wujie  增来源单据联查
#                                                   增加原/本币应收/已付金额 
# Modify.........: No:TQC-BB0209 11/11/24 By yinhy 將"應收合計" ,"應衝合計"分別改為"本币应收金额合计"，"本币已冲金额合计"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	 wc     LIKE type_file.chr1000, # Head Where condition #No.FUN-680123 VARCHAR(1000)
                 wc2    LIKE type_file.chr1000  # Body Where condition #No.FUN-680123 VARCHAR(1000)
        END RECORD,
    g_occ   RECORD
			occ01	LIKE occ_file.occ01,
			occ02	LIKE occ_file.occ02,
		        link    LIKE occ_file.occ29    #No.FUN-680123 VARCHAR(24)  
        END RECORD,
    g_oma DYNAMIC ARRAY OF RECORD
            oma00   LIKE oma_file.oma00,
            oma01   LIKE oma_file.oma01,
            oma02   LIKE oma_file.oma02,
            oma11   LIKE oma_file.oma11,
            oma16   LIKE oma_file.oma16,
            oma23   LIKE oma_file.oma23,
            oma54t  LIKE oma_file.oma54t,
            oma55   LIKE oma_file.oma55,
            balance LIKE oma_file.oma55,         #No.FUN-A30028
            oma56t  LIKE oma_file.oma56t,        #No:8522
            oma57   LIKE oma_file.oma57,         #No:8522
            balance1 LIKE oma_file.oma57,         #No.FUN-A30028
            omaconf LIKE oma_file.omaconf,
            oma66   LIKE oma_file.oma66,         #FUN-630043
            oma10   LIKE oma_file.oma10,         #FUN-5C0014
            oma67   LIKE oma_file.oma67          #FUN-5C0014
        END RECORD,
	g_occ261		LIKE occ_file.occ261,
	g_occ29			LIKE occ_file.occ29,
        g_argv1                 LIKE occ_file.occ01,
       #g_query_flag            SMALLINT,               #第一次進入程式時即進入Query之後進入next
        g_query_flag            LIKE type_file.num5,    #No.FUN-680123 SMALLINT
        g_wc,g_wc2,g_sql        string,                 #WHERE CONDITION  #No.FUN-580092 HCN     
	g_rec_b                 LIKE type_file.num10,   #單身筆數  #No.FUN-680123 INTEGER
	g_tot1			LIKE oma_file.oma54t,   #應收金額合計
	g_tot2			LIKE oma_file.oma54t    #已沖金額合計
DEFINE  g_cnt                   LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE  g_msg                   LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(72)
DEFINE  g_row_count             LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE  g_curs_index            LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE  g_jump                  LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE  mi_no_ask               LIKE type_file.num5     #No.FUN-680123 SMALLINT 
 
MAIN
#   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間 #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
    DEFINE
	  l_sl          LIKE type_file.num10            #No.FUN-680123 INTEGER 
   DEFINE p_row,p_col   LIKE type_file.num5             #No.FUN-680123 SMALLINT
   OPTIONS                                              #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                     #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   LET g_query_flag =1
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW q320_w AT p_row,p_col
       WITH FORM "axr/42f/axrq320"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q320_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q320_q() END IF
    CALL q320_menu()
    CLOSE WINDOW q320_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION q320_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-680123 SMALLINT 
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "occ01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
           CALL g_oma.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON occ01,occ02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
     #FUN-920050   ---START                                                                                                         
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(occ01)                                                                                                     
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = 'q_occ'                                                                                        
               LET g_qryparam.state  = "c"                                                                                          
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO occ01                                                                                 
               NEXT FIELD occ01                                                                                                     
            OTHERWISE EXIT CASE                                                                                                     
         END CASE                                                                                                                   
     #FUN-920050   ---END      
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
           #====>資料權限的檢查
           #Begin:FUN-980030
           #           IF g_priv2='4' THEN#只能使用自己的資料
           #               LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
           #           END IF
           #           IF g_priv3='4' THEN                           #只能使用相同群的資料
           #               LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
           #           END IF
 
           #           IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
           #               LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
           #           END IF
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
           #End:FUN-980030
 
 
           CALL q320_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
 
   IF tm.wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql=" SELECT occ01 FROM occ_file ",
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY occ01"
   ELSE					# 若單身有輸入條件
      LET g_sql=" SELECT occ01 FROM occ_file ",
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY occ01"
      LET g_sql = "SELECT UNIQUE occ01 ",
                   "  FROM occ_file, oma_file",
                   " WHERE occ01 = oma03",
                   "   AND ", tm.wc CLIPPED, " AND ",tm.wc2 CLIPPED,
                   " ORDER BY occ01"
   END IF
 
   PREPARE q320_prepare FROM g_sql
   DECLARE q320_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q320_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
    IF tm.wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql=" SELECT COUNT(*) FROM occ_file ",
              " WHERE ",tm.wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT occ01) FROM occ_file,oma_file WHERE ",
                  "oma03=occ01 AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED
    END IF
   PREPARE q320_pp  FROM g_sql
   DECLARE q320_cnt   CURSOR FOR q320_pp
END FUNCTION
 
FUNCTION q320_b_askkey()
   CONSTRUCT tm.wc2 ON oma00,oma01,oma02,oma11,oma16,oma23,oma54t,oma55,oma56t,oma57,omaconf,oma66,oma10,oma67    #No:8522  #FUN-630043 #FUN-5C0014
                  FROM s_oma[1].oma00,s_oma[1].oma01,s_oma[1].oma02,
                       s_oma[1].oma11,s_oma[1].oma16,s_oma[1].oma23,
	               s_oma[1].oma54t,s_oma[1].oma55,s_oma[1].oma56t,s_oma[1].oma57,s_oma[1].omaconf,s_oma[1].oma66,s_oma[1].oma10,s_oma[1].oma67  #FUN-630043   #No:8522 #FUN-5C0014 add oma10,oma67
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION q320_menu()
DEFINE    l_ac    LIKE type_file.num5    #No.FUN-A30028 
 
   WHILE TRUE
      CALL q320_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q320_q()
            END IF
#           NEXT OPTION "next"
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#No.FUN-A30028 --begin
         WHEN "qry_oma"
            LET l_ac = ARR_CURR()
            IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
               LET g_msg = "axrt300 '",g_oma[l_ac].oma01,"'"
               CALL cl_cmdrun(g_msg)
            END IF
#No.FUN-A30028 --end
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_oma),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q320_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q320_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q320_cnt
       FETCH q320_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q320_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q320_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680123 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680123 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q320_cs INTO g_occ.occ01
        WHEN 'P' FETCH PREVIOUS q320_cs INTO g_occ.occ01
        WHEN 'F' FETCH FIRST    q320_cs INTO g_occ.occ01
        WHEN 'L' FETCH LAST     q320_cs INTO g_occ.occ01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump q320_cs INTO g_occ.occ01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
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
	SELECT occ01,occ02,occ261,occ29
	  INTO g_occ.occ01,g_occ.occ02,g_occ261,g_occ29
	  FROM occ_file
	 WHERE occ01 = g_occ.occ01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)    #No.FUN-660116
        CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660116
        RETURN
    END IF
 
    CALL q320_show()
END FUNCTION
 
FUNCTION q320_show()
   LET g_occ.link = g_occ261 CLIPPED,'-',g_occ29 CLIPPED
   IF SQLCA.SQLCODE THEN LET g_occ.occ02=' ' END IF
   DISPLAY BY NAME g_occ.*  # 顯示單頭值
   CALL q320_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q320_b_fill()                        #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
#       "SELECT oma00,oma01,oma02,oma11,oma16,oma23,oma54t,oma55,oma56t,oma57,omaconf,oma66,oma10,oma67 ",   #No:8522 #FUN-5C0014 add oma10,oma67
        "SELECT oma00,oma01,oma02,oma11,oma16,oma23,oma54t,oma55,'',oma56t,oma57,'',omaconf,oma66,oma10,oma67 ",   #No:8522 #FUN-5C0014 add oma10,oma67     #No.FUN-A30028 add '',''
        "  FROM oma_file ",
        " WHERE oma03 = '",g_occ.occ01,"'"," AND oma54t > oma55 AND ",tm.wc2 CLIPPED,
        "   AND omavoid = 'N'",
        " ORDER BY oma02 "
    PREPARE q320_pb FROM l_sql
    DECLARE q320_bcs                       #BODY CURSOR
        CURSOR FOR q320_pb
    CALL g_oma.clear()
    LET g_cnt = 1
    LET g_tot1= 0
    LET g_tot2= 0
    FOREACH q320_bcs INTO g_oma[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oma[g_cnt].oma54t IS NULL THEN
  	       LET g_oma[g_cnt].oma54t = 0
        END IF
        IF g_oma[g_cnt].oma55 IS NULL THEN
  	       LET g_oma[g_cnt].oma55 = 0
        END IF
        #No:8522
        IF g_oma[g_cnt].oma56t IS NULL THEN
               LET g_oma[g_cnt].oma56t = 0
        END IF
        IF g_oma[g_cnt].oma57 IS NULL THEN
               LET g_oma[g_cnt].oma57 = 0
        END IF
        #---
      # IF g_oma[g_cnt].oma00='21' THEN
      #No.+445 010719 by linda mod
        IF g_oma[g_cnt].oma00 MATCHES '2*'  THEN
           LET g_oma[g_cnt].oma54t=g_oma[g_cnt].oma54t*(-1)
           LET g_oma[g_cnt].oma55=g_oma[g_cnt].oma55*(-1)    #No:8522
           LET g_oma[g_cnt].oma56t=g_oma[g_cnt].oma56t*(-1)  #No:8522
           LET g_oma[g_cnt].oma57=g_oma[g_cnt].oma57*(-1)    #No:8522
        END IF
#No.FUN-A30028 --begin
        LET g_oma[g_cnt].balance  = g_oma[g_cnt].oma54t - g_oma[g_cnt].oma55
        LET g_oma[g_cnt].balance1 = g_oma[g_cnt].oma56t - g_oma[g_cnt].oma57
#No.FUN-A30028 --end
        #No.TQC-BB0209  --Begin
        #LET g_tot1 = g_tot1 + g_oma[g_cnt].oma54t
        #LET g_tot2 = g_tot2 + g_oma[g_cnt].oma55
        LET g_tot1 = g_tot1 + g_oma[g_cnt].oma56t
        LET g_tot2 = g_tot2 + g_oma[g_cnt].oma57
        #No.TQC-BB0209  --End
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oma.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_tot1 TO tot01
    DISPLAY g_tot2 TO tot02
END FUNCTION
 
FUNCTION q320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q320_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#No.FUN-A30028 --begin
      ON ACTION qry_oma
         LET g_action_choice = 'qry_oma'
         EXIT DISPLAY
#No.FUN-A30028 --end
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
