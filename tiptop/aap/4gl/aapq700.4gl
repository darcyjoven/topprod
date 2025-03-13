# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapq700.4gl
# Descriptions...: 信用狀修改記錄查詢
# Date & Author..: 95/12/12 By Danny
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: No.MOD-650011 06/05/03 By Smapmin 若由其他程式串接過來,無法即時顯示資料
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能			
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多出一空白行
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780041 07/08/08 By Smapmin sql語法修正.筆數修正
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/09 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A60056 10/06/28 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:CHI-AA0015 10/11/05 By Summer all00與alc02原為vachar(1)改為Number(5)
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
        	wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(600)
        	wc2  	LIKE type_file.chr1000		# Body Where condition  #No.FUN-690028 VARCHAR(600)
        END RECORD,
    g_hhh   RECORD
        	all_date  	LIKE type_file.dat,     #No.FUN-690028 DATE
        	#all01   VARCHAR(20),    #FUN-660117 remark
        	#all00   VARCHAR(1)      #FUN-660117 remark
        	all01  	LIKE all_file.all01, #FUN-660117
        	all00  	LIKE all_file.all00  #FUN-660117
        END RECORD,
    g_all DYNAMIC ARRAY OF RECORD
            all02   LIKE all_file.all02,
            all44   LIKE all_file.all44,    #FUN-A60056
            all04   LIKE all_file.all04,
            all05   LIKE all_file.all05,
            all11   LIKE all_file.all11,
            pmn041  LIKE pmn_file.pmn041,
#NO.FUN-710029 start---
            all83   LIKE all_file.all83, 
            all85   LIKE all_file.all85,
            all80   LIKE all_file.all80,
            all82   LIKE all_file.all82,
#NO.FUN-710029 end---
            pmn07   LIKE pmn_file.pmn07,
            all06   LIKE all_file.all06,
            all07   LIKE all_file.all07,
            all08   LIKE all_file.all08
        END RECORD,
    g_argv1         LIKE all_file.all01,      # No.FUN-690028 VARCHAR(20),	# LC No
    g_argv2         LIKE type_file.chr1,      # No.FUN-690028 VARCHAR(1),	# 修改次數
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-690028 SMALLINT
     g_wc,g_wc2,g_sql  string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10       # No.FUN-690028 INTEGER 		  #單身筆數
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
MAIN
   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間  #No.FUN-690028 VARCHAR(8)
          l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(2) Part#
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q700_w AT p_row,p_col
        WITH FORM "aap/42f/aapq700" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q700_q()
#    END IF
 
    #NO.FUN-710029 start--
    CALL q700_def_form()
    #NO.FUN-710029 end----
 
    #-----MOD-650011---------
    IF NOT cl_null(g_argv1) THEN
       CALL q700_q()
    END IF
    #-----END MOD-650011-----
    CALL q700_menu()
    CLOSE WINDOW q700_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
 
#QBE 查詢資料
FUNCTION q700_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690028 SMALLINT
 
   IF NOT cl_null(g_argv1)
      #THEN LET tm.wc = "all01='",g_argv1,"' AND all00='",g_argv2,"'" #CHI-AA0015 mark
      THEN LET tm.wc = "all01='",g_argv1,"' AND all00=",g_argv2 #CHI-AA0015
	   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
           CALL g_all.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL		  # Default condition
           CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   INITIALIZE g_hhh.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON all01, all00 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON ACTION controlp
                 CASE 
                    WHEN INFIELD(all01) # APO
                         CALL q_ala(TRUE,TRUE,g_hhh.all01) 
                              RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO all01
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
 
           
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
           CALL q700_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
   IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN
      LET g_sql=" SELECT '',all01,all00 FROM all_file",
                #" WHERE ",tm.wc CLIPPED,   #MOD-640018
                " WHERE all00 <> 0 AND ",tm.wc CLIPPED,   #MOD-640018 #CHI-AA0015 mod '0'->0
                #-----MOD-780041---------
                " GROUP BY all01,all00",  
                " ORDER BY all01,all00"
                #" GROUP BY 1,2,3",  
                #" ORDER BY 1,2 "
                #-----END MOD-780041-----
   ELSE
      LET g_sql=" SELECT '',all01,all00 FROM all_file",
                #" WHERE ",tm.wc CLIPPED,   #MOD-640018
                " WHERE all00 <> 0 AND ",tm.wc CLIPPED,   #MOD-640018 #CHI-AA0015 mod '0'->0
                "   AND ",tm.wc2 CLIPPED,
                #-----MOD-780041---------
                " GROUP BY all01,all00",  
                " ORDER BY all01,all00"
                #" GROUP BY 1,2,3",  
                #" ORDER BY 1,2 "
                #-----END MOD-780041-----
   END IF
   PREPARE q700_prepare FROM g_sql
   DECLARE q700_cs SCROLL CURSOR FOR q700_prepare
 
   #-----MOD-780041---------
   #IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN
   #   LET g_sql=" SELECT COUNT(*) FROM all_file",
   #             #" WHERE ",tm.wc CLIPPED   #MOD-640018
   #             " WHERE all00 <> '0' AND ",tm.wc CLIPPED   #MOD-640018
   #ELSE
   #   LET g_sql=" SELECT COUNT(*) FROM all_file",
   #             #" WHERE ",tm.wc CLIPPED,   #MOD-640018
   #             " WHERE all00 <> '0' AND ",tm.wc CLIPPED,   #MOD-640018
   #             "   AND ",tm.wc2 CLIPPED
   #END IF
   #PREPARE q700_pre_count FROM g_sql
   #DECLARE q700_count CURSOR FOR q700_pre_count 
   #-----END MOD-780041-----
END FUNCTION
 
FUNCTION q700_b_askkey()
   CONSTRUCT tm.wc2 ON all02,all44,all04,all05    #FUN-A60056 add all44
                  FROM s_all[1].all02,s_all[1].all44,s_all[1].all04,s_all[1].all05    #FUN-A60056 add all44
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN
      #FUN-A60056--add--str--
      ON ACTION controlp
         CASE
           WHEN INFIELD(all44) 
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azw"
             LET g_qryparam.state = "c"
             LET g_qryparam.where = "azw02 = '",g_legal,"'"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO all44
             NEXT FIELD all44
         END CASE
      #FUN-A60056--add--end
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION q700_menu()
 
   WHILE TRUE
      CALL q700_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q700_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_all),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   #DEFINE x   VARCHAR(20)
    CALL cl_opmsg('q')
 #  DISPLAY '   ' TO FORMONLY.cnt     #85-10-17
    CALL q700_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET g_cnt = 0 
    #OPEN q700_count   #MOD-780041
    #FETCH q700_count INTO g_row_count   #MOD-780041
    CALL q700_count()   #MOD-780041
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q700_cs INTO g_hhh.*
       WHEN 'P' FETCH PREVIOUS q700_cs INTO g_hhh.*
       WHEN 'F' FETCH FIRST    q700_cs INTO g_hhh.*
       WHEN 'L' FETCH LAST     q700_cs INTO g_hhh.*
       WHEN '/'
             IF NOT mi_no_ask THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
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
             FETCH ABSOLUTE g_jump q700_cs INTO g_hhh.*
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN CALL cl_err(g_hhh.all01,SQLCA.sqlcode,0) 
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
 
    CALL q700_show()
END FUNCTION
 
FUNCTION q700_show()
   DEFINE tot2       LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   IF g_hhh.all00=0  #CHI-AA0015 mod '0'->0
      THEN SELECT ala08 INTO g_hhh.all_date
             FROM ala_file WHERE ala01=g_hhh.all01
      ELSE SELECT alc08 INTO g_hhh.all_date
             FROM alc_file WHERE alc01=g_hhh.all01 AND alc02=g_hhh.all00 AND
                                 alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                                 AND alcfirm <> 'X' #CHI-C80041
   END IF
   #No.FUN-9A0024--begin
   #DISPLAY BY NAME g_hhh.*
   DISPLAY BY NAME g_hhh.all_date,g_hhh.all01,g_hhh.all00
   #No.FUN-9A0024--end 
   CALL q700_b_fill() 
   SELECT SUM(all08) INTO tot2 FROM all_file
    WHERE all01=g_hhh.all01 AND all00=g_hhh.all00 AND
          all00 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   DISPLAY BY NAME tot2
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q700_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       #FUN-A60056--mod--str--add all44,將pmn_file相關欄位放在FOREACH中以all44跨庫選取
       ##"SELECT all02,all04,all05,all11,pmn041,pmn07,all06,all07,all08",
       #"SELECT all02,all04,all05,all11,pmn041,",
       #"       all83,all85,all80,all82,",  #FUN-710029
       #"       pmn07,all06,all07,all08",
       #"  FROM all_file LEFT OUTER JOIN pmn_file ON all_file.all04 = pmn_file.pmn01 AND all_file.all05 = pmn_file.pmn02",
       #" WHERE all01='",g_hhh.all01,"' AND all00='",g_hhh.all00,"'",
       #"   AND all00 <> '0' ",   #MOD-640018
       #"   AND ",tm.wc2 CLIPPED,
       #" ORDER BY 1"
        "SELECT all02,all44,all04,all05,all11,'',", 
        "       all83,all85,all80,all82,",
        "       '',all06,all07,all08",
        "  FROM all_file ",
       #" WHERE all01='",g_hhh.all01,"' AND all00='",g_hhh.all00,"'", #CHI-AA0015 mark
        " WHERE all01='",g_hhh.all01,"' AND all00=",g_hhh.all00, #CHI-AA0015
        "   AND all00 <> 0 ",  #CHI-AA0015 mod '0'->0 
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1"
       #FUN-A60056--mod--end
    PREPARE q700_pb FROM l_sql
    DECLARE q700_bcs CURSOR WITH HOLD FOR q700_pb
 
    FOR g_cnt = 1 TO g_all.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_all[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q700_bcs INTO g_all[g_cnt].*
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_hhh.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      #FUN-A60056--add--str--
      LET g_sql = "SELECT pmn041,pmn07 ",
                  "  FROM ",cl_get_target_table(g_all[g_cnt].all44,'pmn_file'),
                  " WHERE pmn01 = '",g_all[g_cnt].all04,"'",
                  "   AND pmn02 = '",g_all[g_cnt].all05,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_all[g_cnt].all44) RETURNING g_sql
      PREPARE sel_pmn041 FROM g_sql
      EXECUTE sel_pmn041 INTO g_all[g_cnt].pmn041,g_all[g_cnt].pmn07
      #FUN-A60056--add--end
      LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_all.deleteElement(g_cnt)  #No.TQC-6B0104
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_all TO s_all.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q700_fetch('L')
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
         CALL q700_def_form()      #NO.FUN-710029
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0009
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#NO.FUN-710029 start-------------------
FUNCTION q700_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("all80,all82,all83,all85",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all82",g_msg CLIPPED)
   END IF
END FUNCTION
#FUN-710029 end-------------------------
 
#-----MOD-780041---------
FUNCTION q700_count()
   DEFINE l_cnt SMALLINT
 
   IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN
      LET g_sql=" SELECT COUNT(*) FROM all_file",   
                " WHERE all00 <> 0 AND ",tm.wc CLIPPED, #CHI-AA0015 mod '0'->0
                "   GROUP BY all00,all01" 
   ELSE
      LET g_sql=" SELECT COUNT(*) FROM all_file",   
                " WHERE all00 <> 0 AND ",tm.wc CLIPPED, #CHI-AA0015 mod '0'->0 
                "   AND ",tm.wc2 CLIPPED,
                "   GROUP BY all00,all01" 
   END IF
   PREPARE q700_pre_count FROM g_sql
   DECLARE q700_count CURSOR FOR q700_pre_count 
   FOREACH q700_count INTO l_cnt
     LET g_row_count = g_row_count + 1 
   END FOREACH
END FUNCTION
#-----END MOD-780041-----
