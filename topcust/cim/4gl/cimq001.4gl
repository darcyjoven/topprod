# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq001.4gl
# Descriptions...: 料件庫存數量查詢
# Date & Author..: 91/10/19 By Carol
#------MODIFICATIION-------MODIFICATION-------MODIFIACTION-------
# 1992/08/01 Jones
# 1992/09/24 Keith: 多加 img19,img36 for display!
# 1992/10/09 Jones: 查詢後的next option 為"next"
# 1992/10/13 Lee: 增加再補貨量的警示(ima99/mfg1025)
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bdate       DATE,
    g_edate       DATE,
    tm            RECORD
                   wc    STRING, #LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 CHAR(500) #No:MOD-A10034 modify
                   wc2   STRING  #LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 CHAR(500) #No:MOD-A10034 modify
                  END RECORD,
    g_ima37       LIKE ima_file.ima37,
    g_ima38       LIKE ima_file.ima38,
    g_imn         DYNAMIC ARRAY OF RECORD
                   imn03   LIKE imn_file.imn03,  #料号
                   ima02   LIKE ima_file.ima02,  #品名
                   ima021  LIKE ima_file.ima021,  #规格
                   imn04   LIKE imn_file.imn04,   #调拨出仓库
                   imn15   LIKE imn_file.imn15,   #调拨入仓
                   imn09   LIKE imn_file.imn09,   #单位
                   imn10   LIKE imn_file.imn10    #数量
                  END RECORD,
    g_cmd         LIKE type_file.chr1000,       #No.FUN-540025  #No.FUN-690026 VARCHAR(100)
    g_argv1       LIKE ima_file.ima01,          #INPUT ARGUMENT - 1
    g_query_flag  LIKE type_file.num5,          #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql         string, #WHERE CONDITION      #No.FUN-580092 HCN
    g_rec_b       LIKE type_file.num5           #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10      #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000    #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10      #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10      #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10      #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5       #No.FUN-690026 SMALLINT
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031 HCN
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE      l_sl   LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q001_w AT p_row,p_col
         WITH FORM "cim/42f/cimq001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL q001_menu()
    CLOSE WINDOW q001_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q001_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET tm.wc = "ima01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
  # CALL g_imn.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
          # INITIALIZE g_ima.* TO NULL      #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    {       CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON ACTION CONTROLP    #FUN-4B0043
                 IF INFIELD(ima01) THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
                 END IF
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT  }
          INPUT  BY NAME g_bdate,g_edate  WITHOUT DEFAULTS 
            BEFORE INPUT  
            LET g_bdate=g_today
            LET g_edate=g_today
            DISPLAY BY NAME g_bdate,g_edate

            AFTER  FIELD g_edate
              IF NOT cl_null(g_edate) THEN
                 IF g_edate< g_bdate THEN
                    CALL cl_err('','alm1038',1)
                    NEXT FIELD g_edate
                 END IF 
              END IF 
                      





          END INPUT 
          IF INT_FLAG THEN
             #LET INT_FLAG=0 #TQC-BB0080
             RETURN 
          END IF
          CALL q001_b_askkey()
          IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
  { IF tm.wc2=' 1=1' THEN
      LET g_sql=" SELECT ima01 FROM ima_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT UNIQUE ima_file.ima01 FROM ima_file,img_file ",
                " WHERE ima01=img01",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED
   END IF
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q001_prepare FROM g_sql
   DECLARE q001_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q001_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2=' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
                " WHERE ",tm.wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE ima01) FROM ima_file,img_file ",
                " WHERE ima01=img01",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED
   END IF
 
   PREPARE q001_pp  FROM g_sql
   DECLARE q001_count   CURSOR FOR q001_pp}
END FUNCTION
 
FUNCTION q001_b_askkey()
   CONSTRUCT tm.wc2 ON imn03,ima02,ima021,imn04,imn15,imn09,imn10  FROM
	   s_imn[1].imn03,s_imn[1].ima02,s_imn[1].ima021,s_imn[1].imn04,s_imn[1].imn15,s_imn[1].imn09,s_imn[1].imn10
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
 
     ON ACTION CONTROLP 
        CASE WHEN INFIELD(imn04)
             CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO imn04
             NEXT FIELD imn04
             WHEN INFIELD(imn15)
             CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO imn15
             NEXT FIELD imn15
        END CASE 



		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q001_menu()
 
   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q001_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    #OPEN q001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
   #    OPEN q001_count
  #     FETCH q001_count INTO g_row_count
  #     DISPLAY g_row_count TO FORMONLY.cnt
#       CALL q001_fetch('F')                  # 讀出TEMP第一筆並顯示
       CALL q001_show()
    END IF
	MESSAGE ''
END FUNCTION
 {
FUNCTION q001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q001_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q001_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q001_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q001_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump q001_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
#	SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima26,ima261,ima262,ima37,ima38  #FUN-A20044
        SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,'','','',ima37,ima38             #FUN-A20044
	  INTO g_ima.*,g_ima37,g_ima38
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING g_ima.avl_stk_mpsmrp,g_ima.unavl_stk,g_ima.avl_stk   #FUN-A20044 
    CALL q001_show()
END FUNCTION
 }
FUNCTION q001_show()
   DISPLAY BY NAME g_bdate,g_edate
   CALL q001_b_fill() #單身
#	IF g_ima37='0' AND g_ima38!=0 AND
# 	g_ima.ima262 < g_ima38 THEN           #FUN-A20044
#               g_ima.avl_stk < g_ima38 THEN  #FUN-A20044
#		CALL cl_err(g_ima.ima01,'mfg1025',0)
#	END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q001_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE tot       LIKE img_file.img10    #MOD-530179
   DEFINE  l_str    STRING
   LET l_str=tm.wc2
   
   CALL cl_replace_str(l_str,"imn03","tc_imq05") RETURNING l_str
   CALL cl_replace_str(l_str,"imn04","tc_imq06") RETURNING l_str
   CALL cl_replace_str(l_str,"imn15","tc_imq10") RETURNING l_str
   CALL cl_replace_str(l_str,"imn09","tc_imq13") RETURNING l_str
   CALL cl_replace_str(l_str,"imn10","tc_imq14") RETURNING l_str

   LET l_sql =
        "SELECT imn03,'','',imn04,imn15,imn09,imn10 ",
        " FROM  imn_file,imm_file",
        " WHERE ((imn04!='XBC' AND imn15='XBC') OR (imn04='XBC' AND imn15!='XBC')) AND imm01=imn01 AND imm03='Y' ", 
        " AND imm02 BETWEEN TO_DATE('",g_bdate,"','YY/MM/DD') AND TO_DATE('",g_edate,"','YY/MM/DD') AND ",tm.wc2 CLIPPED,
        " UNION ",
        " SELECT tc_imq05,'','',tc_imq06,tc_imq10,tc_imq13,tc_imq14 ",
        " FROM tc_imq_file,tc_imm_file  ",
        " WHERE ((tc_imq06!='XBC' AND tc_imq10='XBC') OR (tc_imq06='XBC' AND tc_imq10!='XBC')) AND tc_imm03='Y' AND tc_imm01=tc_imq01",
        " AND tc_imm02 BETWEEN TO_DATE('",g_bdate,"','YY/MM/DD') AND TO_DATE('",g_edate,"','YY/MM/DD') AND tc_imm01=tc_imq01 AND ", l_str CLIPPED
        
    PREPARE q001_pb FROM l_sql
    DECLARE q001_bcs                       #BODY CURSOR
        CURSOR FOR q001_pb
 
    FOR g_cnt = 1 TO g_imn.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_imn[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    LET tot   = 0
    FOREACH q001_bcs INTO g_imn[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO g_imn[g_cnt].ima02,g_imn[g_cnt].ima021 FROM ima_file WHERE ima01=g_imn[g_cnt].imn03

        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_imn_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    DISPLAY BY NAME tot
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         #No.FUN-540025  --begin
         IF g_sma.sma115 = 'N' THEN
            CALL cl_set_act_visible("du_detail",FALSE)
         ELSE
            CALL cl_set_act_visible("du_detail",TRUE)
         END IF
         #No.FUN-540025  --end
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
    {  ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 }
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
 
      ON ACTION accept
#        LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION du_detail     #No.FUN-540025
         LET g_action_choice = 'du_detail'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
