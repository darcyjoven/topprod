# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aapq105.4gl
# Descriptions...: 入庫請款資料查詢
# Date & Author..: 97/12/16 By Melody
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0097 05/01/06 By Nicola 報表架構修改
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-650131 06/06/01 by rainy 按列印後出現英文畫面
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/09/29 By hongmei 零用金修改
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 結束位置有誤
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/20 By Rayven 匯出EXCEL匯出的值多一空白行
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780046 07/09/10 By sherry  新增時，請款人員帶不到資料，把cpf_file換成gen_file                             
# Modify.........: No.FUN-7A0025 07/10/09 By johnray 修改報表功能，使用p_query打印報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/09 By destiny display xxx.*改為display對應欄位
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:MOD-CC0259 12/12/27 By Polly 調整權限控管條件抓取 

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   tm      RECORD
              wc      LIKE type_file.chr1000     # Head Where condition  #No.FUN-690028 VARCHAR(600)
           END RECORD,
   g_heada  RECORD
              #cpf01    LIKE cpf_file.cpf01,       #No.FUN-690080
              #cpf02    LIKE cpf_file.cpf02,       #No.FUN-690080
              #cpf29    LIKE cpf_file.cpf29,       #No.FUN-690080
              #No.CHI-780046---Begin
              gen01    LIKE gen_file.gen01,       
              gen02    LIKE gen_file.gen02,       
              gen03    LIKE gen_file.gen03,       
              #No.CHI-780046---End
              gem02   LIKE gem_file.gem02        #No.FUN-690080
              #cpf44   LIKE cpf_file.cpf44        #No.FUN-690080   #TQC-B90211
           END RECORD,
   g_body  DYNAMIC ARRAY OF RECORD
              apa01   LIKE apa_file.apa01,
              apf02   LIKE apf_file.apf02,
              apa34   LIKE apa_file.apa34,
              aph05   LIKE aph_file.aph05,
              apa19   LIKE apa_file.apa19,
              apo02   LIKE apo_file.apo02,
              apa100  LIKE apa_file.apa100       #FUN-630043
           END RECORD,
   g_wc,g_wc2,g_sql   STRING,  #WHERE CONDITION
   g_rec_b            LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
   l_ac               LIKE type_file.num5                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   l_cmd          LIKE type_file.chr1000 #No.FUN-7A0025
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0055
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW q105_w AT p_row,p_col
     WITH FORM "aap/42f/aapq105"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL q105_menu()
 
   CLOSE WINDOW q105_w
 
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
END MAIN
 
FUNCTION q105_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_body.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  # Default condition
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_heada.* TO NULL    #No.FUN-750051
   #CONSTRUCT BY NAME tm.wc ON cpf01,cpf02,cpf29,cpf44    #No.FUN-690080    #No.CHI-780046
   CONSTRUCT BY NAME tm.wc ON gen01,gen02,gen03           #No.CHI-780046
 
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
 
       #No.FUN-690080  begin    
      ON ACTION CONTROLP
         CASE
            #WHEN INFIELD(cpf01) # Employee CODE       #No.CHI-780046
            WHEN INFIELD(gen01) # Employee CODE        #No.CHI-780046   
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_cpf4"          #No.CHI-780046 
               LET g_qryparam.form ="q_gen"            #No.CHI-780046  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO cpf01   #No.CHI-780046
               DISPLAY g_qryparam.multiret TO gen01    #No.CHI-780046
               #NEXT FIELD cpf01                       #No.CHI-780046
               NEXT FIELD gen01                        #No.CHI-780046
            #WHEN INFIELD(cpf29)                       #No.CHI-780046 
            WHEN INFIELD(gen03)                        #No.CHI-780046
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state = "c"                                       
               LET g_qryparam.form ="q_gem"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               #DISPLAY g_qryparam.multiret TO cpf29   #No.CHI-780046                          
               DISPLAY g_qryparam.multiret TO gen03    #No.CHI-780046                           
               #NEXT FIELD cpf29                       #No.CHI-780046          
               NEXT FIELD gen03                        #No.CHI-780046
            OTHERWISE EXIT CASE                                    
         END CASE
       #No.FUN-690080 end   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
   #   END IF
  #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')        #MOD-CC0259 mark
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gen01', 'gen03')            #MOD-CC0259 add
   #End:FUN-980030
 
 
   MESSAGE ' WAIT '
     #No.FUN-690080 begin
   #No.CHI-780046---Begin
   #LET g_sql=" SELECT UNIQUE(cpf01) FROM cpf_file ",
   #          "  WHERE ",tm.wc CLIPPED,
          #  "    AND pmc14 = '3'",
   #          "  ORDER BY cpf01"
     #No.FUN-690080 end
   #No.CHI-780046---Begin
   LET g_sql=" SELECT UNIQUE(gen01) FROM gen_file ",
             "  WHERE ",tm.wc CLIPPED,
             "  ORDER BY gen01"
   #No.CHI-780046---End
   PREPARE q105_prepare FROM g_sql
   DECLARE q105_cs SCROLL CURSOR WITH HOLD FOR q105_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值   
   #LET g_sql=" SELECT COUNT(*) FROM cpf_file",    #No.FUN-690080
   LET g_sql=" SELECT COUNT(*) FROM gen_file",    #No.FUN-690080 #No.CHI-780046
           # "  WHERE pmc14 = '3'                 #No.FUN-690080
             "  WHERE ",tm.wc CLIPPED
   PREPARE q105_pp FROM g_sql
   DECLARE q105_cnt CURSOR FOR q105_pp
 
END FUNCTION
 
#中文的MENU
FUNCTION q105_menu()
 
   WHILE TRUE
      CALL q105_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q105_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
#No.FUN-7A0025 -- modify --
               #CALL q105_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET l_cmd = 'p_query "aapq105" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
#No.FUN-7A0025 -- end modify --
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_body),'','')
            END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q105_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL q105_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN q105_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q105_cnt
      FETCH q105_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt
 
      CALL q105_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION q105_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      #No.CHI-780046---Begin 
      #WHEN 'N' FETCH NEXT     q105_cs INTO g_heada.cpf01    #No.FUN-690080 
      #WHEN 'P' FETCH PREVIOUS q105_cs INTO g_heada.cpf01
      #WHEN 'F' FETCH FIRST    q105_cs INTO g_heada.cpf01
      #WHEN 'L' FETCH LAST     q105_cs INTO g_heada.cpf01
      WHEN 'N' FETCH NEXT     q105_cs INTO g_heada.gen01    #No.FUN-690080 
      WHEN 'P' FETCH PREVIOUS q105_cs INTO g_heada.gen01
      WHEN 'F' FETCH FIRST    q105_cs INTO g_heada.gen01
      WHEN 'L' FETCH LAST     q105_cs INTO g_heada.gen01
      #No.CHI-780046---End 
      WHEN '/'
         IF NOT mi_no_ask THEN
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
 
         #FETCH ABSOLUTE g_jump q105_cs INTO g_heada.cpf01     #No.FUN-690080  #No.CHI-780046
         FETCH ABSOLUTE g_jump q105_cs INTO g_heada.gen01      #No.CHI-780046   
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_heada.cpf01,SQLCA.sqlcode,0)             #No.FUN-690080  #No.CHI-780046
      CALL cl_err(g_heada.gen01,SQLCA.sqlcode,0)              #No.CHI-780046
      INITIALIZE g_heada.* TO NULL  #TQC-6B0105
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
       #No.FUN-690080 begin
   #No.CHI-780046---Begin
   #SELECT cpf01,cpf02,cpf29,cpf44
   #  INTO g_heada.cpf01,g_heada.cpf02,g_heada.cpf29,g_heada.cpf44
   #  FROM cpf_file
   # WHERE cpf01 = g_heada.cpf01
   SELECT gen01,gen02,gen03
     INTO g_heada.gen01,g_heada.gen02,g_heada.gen03
     FROM gen_file
    WHERE gen01 = g_heada.gen01 
  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gen_file",g_heada.gen01,"",SQLCA.sqlcode,"","",0)   #No.CHI-780046 
      RETURN
   END IF
   #LET g_heada.cpf44 = ' '   #TQC-B90211
   #SELECT cpf44 INTO g_heada.cpf44 FROM cpf_file WHERE cpf01 = g_heada.gen01    #TQC-B90211
   #No.CHI-780046---End
       #No.FUN-690080 end
   CALL q105_show()
 
END FUNCTION
 
FUNCTION q105_show()
   #No.CHI-780046---Begin
   #SELECT cpf29 INTO g_heada.cpf29 FROM cpf_file   #No.FUN-690080
   # WHERE gen01=g_heada.cpf01
   SELECT gen03 INTO g_heada.gen03 FROM gen_file   
    WHERE gen01=g_heada.gen01
   #No.CHI-780046---End
 {  IF STATUS THEN
    #  LET g_heada.gen03=''
   END IF}
 
   SELECT gem02 INTO g_heada.gem02 FROM gem_file
    #WHERE gem01=g_heada.cpf29         #No.FUN-690080  #No.CHI-780046
    WHERE gem01=g_heada.gen03          #No.CHI-780046
   IF STATUS THEN
      LET g_heada.gem02=''
   END IF
   #No.FUN-9A0024--begin  
#  DISPLAY BY NAME g_heada.*
   DISPLAY BY NAME g_heada.gen01,g_heada.gen02,g_heada.gen03,g_heada.gem02 
                   #g_heada.cpf44   #TQC-B90211
   #No.FUN-9A0024--end 
   CALL q105_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q105_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
   #No.CHI-780046---Begin
   #LET l_sql = "SELECT apa01,apf02,apa34,aph05,apa19,'',apa100 ",       #FUN-630043
   #            "  FROM cpf_file,apa_file,apf_file,aph_file, apg_file",  #No.FUN-690080
   #            " WHERE cpf01 = '",g_heada.cpf01,"' ",                   #No.FUN-690080
   #          # "   AND pmc14 = '3' ",
   #            "   AND cpf01 = apa06 ",                                 #No.FUN-690080
   #            "   AND apa01 = apg04 AND apf01 = apg01 AND apf01 = aph01 ",
   #            "   AND apa42 = 'N' ",
   #            "   AND apf41 <> 'X' ",
   #            " ORDER BY apa01,apf02 "
   LET l_sql = "SELECT apa01,apf02,apa34,aph05,apa19,'',apa100 ",       #FUN-630043
               "  FROM gen_file,apa_file,apf_file,aph_file, apg_file",  #No.FUN-690080
               " WHERE gen01 = '",g_heada.gen01,"' ",                   #No.FUN-690080
             # "   AND pmc14 = '3' ",
               "   AND gen01 = apa06 ",                                 #No.FUN-690080
               "   AND apa01 = apg04 AND apf01 = apg01 AND apf01 = aph01 ",
               "   AND apa42 = 'N' ",
               "   AND apf41 <> 'X' ",
               " ORDER BY apa01,apf02 "
   #No.CHI-780046---End
   PREPARE q105_pb FROM l_sql
   DECLARE q105_bcs CURSOR FOR q105_pb
 
   CALL g_body.clear()
   LET g_rec_b=0
   LET g_cnt = 1
 
   FOREACH q105_bcs INTO g_body[g_cnt].*
      IF g_cnt=1 THEN
         LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT apo02 INTO g_body[g_cnt].apo02 FROM apo_file
       WHERE apo01=g_body[g_cnt].apa19
      IF STATUS THEN
         LET g_body[g_cnt].apo02=''
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_body.deleteElement(g_cnt)  #No.TQC-6B0104
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_body TO s_pmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#       BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q105_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q105_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CALL q105_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
         CALL cl_set_act_visible("accept,cancel", FALSE)
 
      ON ACTION next
         CALL q105_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q105_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
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
#No.FUN-7A0025 --mark--
{FUNCTION q105_out()
   DEFINE
      l_name   LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(12)
      l_sql    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(1000)
      #l_apydesc       VARCHAR(10),              #FUN-660117 remark
      l_apydesc       LIKE apy_file.apydesc,  #FUN-660117
      l_apa01         LIKE type_file.chr2,      # No.FUN-690028 VARCHAR(2)
      sr  RECORD
       #     pmc03    LIKE pmc_file.pmc03,
#No.FUN-7A0025 -- add --
             gen01    LIKE gen_file.gen01,
             gen02    LIKE gen_file.gen02,
#No.FUN-7A0025 -- end add --
             apa01    LIKE apa_file.apa01,
             apa02    LIKE apa_file.apa02,
             apa34    LIKE apa_file.apa34,
             apf02    LIKE apf_file.apf02,
             aph05    LIKE aph_file.aph05,
#             apa06    LIKE apa_file.apa06,    #No.FUN-7A0025 -- mark --
             apa01a   LIKE apa_file.apa01      # No.FUN-690028 VARCHAR(15)
      END RECORD
 
 
   OPEN WINDOW q105_outut at 10,21
     WITH FORM "aap/42f/aapq1052"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapq1052"); #TQC-650131
 
   LET INT_FLAG=0
 
   CONSTRUCT g_wc2 on apa02,apa07 FROM apa02,apa07
 
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
 
   IF INT_FLAG then
      CLOSE WINDOW q105_outut                 #結束畫面
      RETURN
   END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('aapq105') RETURNING l_name 
   START REPORT q105_rep TO l_name                 
 
   #No.CHI-780046---Begin
   #LET l_sql= "SELECT apa01,apa02,apa34,apf02,aph05,apa06,'' ",
   #           "  FROM cpf_file,apa_file,apf_file,aph_file,apg_file ",       #No.FUN-690080
   #           " WHERE cpf01 = apa06 ",                                      #No.FUN-690080
   #       #   "   AND pmc14 = '3'",
   #           "   AND apa01 = apg04 AND apf01 = apg01 AND apf01 = aph01 ",
   #           "   AND apf41 <> 'X' ",
   #           "   AND ", g_wc2 CLIPPED
#   LET l_sql= "SELECT gen01,gen02,apa01,apa02,apa34,apf02,aph05,apa06,'' ", #No.FUN-7A0025 -- mark --
   LET l_sql= "SELECT gen01,gen02,apa01,apa02,apa34,apf02,aph05",            #No.FUN-7A0025 -- add --
              "  FROM gen_file,apa_file,apf_file,aph_file,apg_file ",       
              " WHERE gen01 = apa06 ",                                
              "   AND apa01 = apg04 AND apf01 = apg01 AND apf01 = aph01 ",
              "   AND apf41 <> 'X' ",
              "   AND ", g_wc2 CLIPPED
   #No.CHI-780046---End
   PREPARE stm_outut_win FROM l_sql
   DECLARE cur_outut_win CURSOR FOR stm_outut_win
 
   FOREACH cur_outut_win INTO sr.*
      # 此處字符串截位應考慮單據類別檔的定義,否則可能抓錯數據 --by johnray
      LET l_apa01 = sr.apa01[1,2]
      SELECT apydesc INTO l_apydesc FROM apy_file
       WHERE apyslip[1,2] = l_apa01
      IF STATUS THEN
         LET l_apydesc=''
      ELSE
         LET sr.apa01a = sr.apa01 CLIPPED,"(",l_apydesc,")"
      END IF
 
      OUTPUT TO REPORT q105_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT q105_rep         
 
   CLOSE cur_outut_win
   CLOSE WINDOW q105_outut                 #結束畫面
 
   ERROR ""
 
   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
REPORT q105_rep(sr)
   DEFINE
      l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      sr RECORD
          # pmc03    LIKE pmc_file.pmc03,
#No.FUN-7A0025 -- add --
            gen01    LIKE gen_file.gen01,
            gen02    LIKE gen_file.gen02,
#No.FUN-7A0025 -- end add --
            apa01    LIKE apa_file.apa01,
            apa02    LIKE apa_file.apa02,
            apa34    LIKE apa_file.apa34,
            apf02    LIKE apf_file.apf02,
            aph05    LIKE aph_file.aph05,
#            apa06    LIKE apa_file.apa06,    #No.FUN-7A0025 -- mark --
            apa01a   LIKE apa_file.apa01      # No.FUN-690028 VARCHAR(15)
      END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT   MARGIN 0
      BOTTOM MARGIN g_bottom_margin
      PAGE   LENGTH g_page_line
 
  # ORDER BY sr.pmc03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1] CLIPPED
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
  #      LET l_trailer_sw = 'y'   #TQC-6A0088
         LET l_trailer_sw = 'n'   #TQC-6A0088
 
#      BEFORE GROUP OF sr.pmc03
#         PRINT COLUMN g_c[31],sr.apa06,
#               COLUMN g_c[32],sr.pmc03;
#      
      ON EVERY ROW
#No.FUN-7A0025 -- add --
         PRINT COLUMN g_c[31],sr.gen01,
               COLUMN g_c[32],sr.gen02,
#No.FUN-7A0025 -- end add --
               COLUMN g_c[33],sr.apa01a,
               COLUMN g_c[34],sr.apa02,
               COLUMN g_c[35],cl_numfor(sr.apa34,35,g_azi04),
               COLUMN g_c[36],sr.apf02,
               COLUMN g_c[37],cl_numfor(sr.aph05,37,g_azi04)
#TQC-6A0088--begin--                                                                                                                
     ON LAST ROW                                                                                                                    
           PRINT g_dash[1,g_len]                                                                                                    
           LET l_trailer_sw = 'y'                                                                                                   
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED                                    
#TQC-6A0088--end--
 
      PAGE TRAILER
      #  IF l_trailer_sw = 'y' THEN   #TQC-6A0088
         IF l_trailer_sw = 'n' THEN   #TQC-6A0088
            PRINT g_dash[1,g_len]
        #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED   #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-7A0025 --end--
