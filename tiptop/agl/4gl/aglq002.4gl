# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq002.4gl
# Descriptions...: 合併後科目各期餘額查詢
# Date & Author..: 01/09/19 By Debbie Hsu
# Modify.........: No:9512 04/05/03 By Mandy 承bugno:8004的錯誤,COUNT 總筆數不正確
# Modify.........: No:9754 04/07/15 By Kitty 在單身顯示資料的SQL要加上年度
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: NO.FUN-580072 05/08/17 BY yiting  增加幣別欄位
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By lora    會計科目加帳套 
# Modify.........: NO.FUN-750076 07/05/18 BY Yiting add axh13
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760044 07/06/15 By Sarah 將版本欄位隱藏
# Modify.........: No.FUN-830093 08/03/24 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-970045 09/07/21 By chenmoyan 取消余額欄位
# Modify.........: No.FUN-910001 09/01/02 By hongmei axh01(群組代號)增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-950048 09/05/22 BY jan 拿掉axh13
# Modify.........: No:FUN-950111 09/10/29 抓取aag02時應判斷axa09
# Modify.........: No:FUN-9B0022 09/11/04 5.2SQL转标准语法
# Modify.........: No:FUN-920092 09/11/06 by yiting "單頭科目"未show 
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.FUN-A80034 10/08/09 By wujie   追21区FUN-A30122
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 修改A80034 追單 
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0006 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
#      	wc   VARCHAR(500) 	# Head Where condition
       	wc  	STRING           #TQC-630166      
        END RECORD,
    g_aag  RECORD
           #axh13   LIKE axh_file.axh13,  #NO.FUN-750076 #FUN-950048
            axh01		LIKE axh_file.axh01,
            axh00		LIKE axh_file.axh00,
            axh05		LIKE axh_file.axh05,
            axh06		LIKE axh_file.axh06,
            axh12		LIKE axh_file.axh12,  #NO.FUN-580072
            aag02		LIKE aag_file.aag02,
            axh02		LIKE axh_file.axh02,
            axh03		LIKE axh_file.axh03,
            axh04 		LIKE axh_file.axh04,   #No:8004
            axh041		LIKE axh_file.axh041,
            aag06		LIKE aag_file.aag06
        END RECORD,
    g_axh DYNAMIC ARRAY OF RECORD
            seq     LIKE ze_file.ze03,      #No.FUN-680098  VARCHAR(4) 
            axh08   LIKE axh_file.axh08,
            axh09   LIKE axh_file.axh09,
            amt     LIKE type_file.num20_6,    #FUN-AB0028
            axh10   LIKE axh_file.axh10,
            axh11   LIKE axh_file.axh11     #No.FUN-970045
#           l_tot   LIKE axh_file.axh08     #No.FUN-970045
        END RECORD,
    g_bookno        LIKE axh_file.axh00,      # INPUT ARGUMENT - 1
#   g_wc,g_sql  VARCHAR(1000),     #WHERE CONDITION
    g_wc,g_sql  STRING,         #TQC-630166    #WHERE CONDITION      
    p_row,p_col LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    g_rec_b     LIKE type_file.num5   	      #單身筆數        #No.FUN-680098  SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098     SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098  VARCHAR(72) 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   g_bookno1       LIKE aza_file.aza81      #No.FUN-740020                                                                    
DEFINE   g_bookno2       LIKE aza_file.aza82      #No.FUN-740020                                                                    
DEFINE   g_flag          LIKE type_file.chr1      #No.FUN-740020
DEFINE   l_table         STRING,                ### FUN-830093 ###                                                                  
         g_str           STRING                 ### FUN-830093 ###                                                                  
DEFINE   g_dbs_axz03     STRING                   #No.FUN-9B0022
DEFINE   g_plant_axz03   LIKE type_file.chr21     #FUN-A30122 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0073
       DEFINE
          l_sl		LIKE type_file.num5        #No.FUN-680098   SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
### *** FUN-830093 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   #LET g_sql = "axh13.axh_file.axh13,",         #FUN-950048 mark      
    LET g_sql = "axh00.axh_file.axh00,",         #FUN-950048                                                                                   
                "axh01.axh_file.axh01,",
                "axh02.axh_file.axh02,",
                "axh03.axh_file.axh03,",
                "axh05.axh_file.axh05,",
                "axh06.axh_file.axh06,",
                "axh12.axh_file.axh12,",
                "axh07.axh_file.axh07,",
                "axh08.axh_file.axh08,",
                "axh09.axh_file.axh09,",
                "l_aag02.aag_file.aag02,",
                "l_aag06.aag_file.aag06"                      #No.FUN-970045
#               "l_tot.axh_file.axh08"                        #No.FUN-970045
    LET l_table = cl_prt_temptable('aglq002',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                     
                " VALUES(?, ?, ?, ?, ?, ?, ?, ",                                                              
#                        ?, ?, ?, ?, ?, ?, ?)"             #No.FUN-970045                                                 
                "        ?, ?, ?, ?, ?)"                   #No.FUN-970045 #FUN-950048                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW q002_w AT p_row,p_col WITH FORM 'agl/42f/aglq002'
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q002_q()
#    END IF
IF NOT cl_null(g_bookno) THEN CALL q002_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
 
    CALL q002_menu()
    CLOSE WINDOW q002_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q002_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
   CLEAR FORM #清除畫面
   CALL g_axh.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		 # Default condition
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             #axh01,axh00,axh02,axh03,axh04,axh041,axh05,axh06  #NO.FUN-580072
             #axh01,axh00,axh02,axh03,axh04,axh041,axh05,axh06,axh12
            #axh13,axh01,axh00,axh02,axh03,axh04,axh041,axh05,axh06,axh12  #NO.FUN-750076 #FUN-950048 mark 
             axh01,axh00,axh02,axh03,axh04,axh041,axh05,axh06,axh12  #NO.FUN-750076 #FUN-950048
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               #str FUN-910001 add
                WHEN INFIELD(axh01) #族群編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_axh"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO axh01
                     NEXT FIELD axh01
               #end FUN-910001 add
                WHEN INFIELD(axh05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO axh05
                #--NO.FUN-580072
                WHEN INFIELD(axh12) #幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_aag.axh12
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO axh12
                     NEXT FIELD axh12
                #--end
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   #LET g_sql=" SELECT DISTINCT axh01,axh02,axh03,axh04,axh041,", #No:8004
   LET g_sql=" SELECT DISTINCT axh01,axh02,axh03,axh04,axh041,", #No:8004  #NO.FUN-750076 #FUN-950048 拿掉axh13
             #"   axh05,axh06,axh00 ",  #NO.FUN-580072 MARK
             "   axh05,axh06,axh12,axh00 ",
             "   FROM axh_file ",
             " WHERE ",tm.wc CLIPPED,
             #" ORDER BY axh01,axh02"
             " ORDER BY axh01,axh02"  #NO.FUN-750076 #FUN-950048 拿掉axh13
   PREPARE q002_prepare FROM g_sql
   DECLARE q002_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q002_prepare
 
   #====>取合乎條件筆數
  #LET g_sql=" SELECT UNIQUE axh00,axh01,axh02 FROM axh_file,aag_file ", #No:9512
  #LET g_sql=" SELECT UNIQUE axh01,axh02,axh03,axh04,axh041,", #No:9512
  #LET g_sql=" SELECT UNIQUE axh13,axh01,axh02,axh03,axh04,axh041,", #No:9512  #no.FUN-750076 #FUN-950048 mark
   LET g_sql=" SELECT UNIQUE axh01,axh02,axh03,axh04,axh041,", #No:9512  #no.FUN-750076 #FUN-950048
             #"   axh05,axh06,axh00 ",          #NO.FUN-580072 MARK    #No:9512
             "   axh05,axh06,axh12,axh00 ",                          #No:9512
             "   FROM axh_file ",
             "     WHERE ",tm.wc CLIPPED,
             "     INTO TEMP x "
   DROP TABLE x
   PREPARE q002_prepare_x FROM g_sql
   EXECUTE q002_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q002_prepare_cnt FROM g_sql
   DECLARE q002_count CURSOR FOR q002_prepare_cnt
END FUNCTION
 
FUNCTION q002_menu()
 
   WHILE TRUE
      CALL q002_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q002_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q002_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q002_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q002_count
       FETCH q002_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10       #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        #WHEN 'N' FETCH NEXT     q002_cs INTO g_aag.axh01,g_aag.axh02,g_aag.axh03,
        WHEN 'N' FETCH NEXT     q002_cs INTO # g_aag.axh13, #FUN-950048 拿掉axh13
                                             g_aag.axh01,g_aag.axh02,g_aag.axh03,  #NO.FUN-750076
                                             g_aag.axh04,g_aag.axh041,g_aag.axh05,  #No:8004
                                             #g_aag.axh06,g_aag.axh00  #NO.FUN-580072 mark
                                             g_aag.axh06,g_aag.axh12,g_aag.axh00
        #WHEN 'P' FETCH PREVIOUS q002_cs INTO g_aag.axh01,g_aag.axh02,g_aag.axh03,
        WHEN 'P' FETCH PREVIOUS q002_cs INTO #g_aag.axh13,  #FUN-950048 拿掉axh13
                                             g_aag.axh01,g_aag.axh02,g_aag.axh03,  #NO.FUN-750076
                                             g_aag.axh04,g_aag.axh041,g_aag.axh05,  #No:8004
                                             #g_aag.axh06,g_aag.axh00  #NO.FUN-580072 mark
                                             g_aag.axh06,g_aag.axh12,g_aag.axh00
        #WHEN 'F' FETCH FIRST    q002_cs INTO g_aag.axh01,g_aag.axh02,g_aag.axh03,
        WHEN 'F' FETCH FIRST    q002_cs INTO #g_aag.axh13, #FUN-950048 拿掉axh13
                                             g_aag.axh01,g_aag.axh02,g_aag.axh03,  #NO.FUN-750076
                                             g_aag.axh04,g_aag.axh041,g_aag.axh05,  #No:8004
                                             #g_aag.axh06,g_aag.axh00  #NO.FUN-580072 mark
                                             g_aag.axh06,g_aag.axh12,g_aag.axh00
        #WHEN 'L' FETCH LAST     q002_cs INTO g_aag.axh01,g_aag.axh02,g_aag.axh03,
        WHEN 'L' FETCH LAST     q002_cs INTO #g_aag.axh13, #FUN-950048 拿掉axh13
                                             g_aag.axh01,g_aag.axh02,g_aag.axh03,  #NO.FUN-750076
                                             g_aag.axh04,g_aag.axh041,g_aag.axh05,  #No:8004
                                             #g_aag.axh06,g_aag.axh00  #NO.FUN-580072 mark
                                             g_aag.axh06,g_aag.axh12,g_aag.axh00
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
            #FETCH ABSOLUTE g_jump q002_cs INTO g_aag.axh01,g_aag.axh02,g_aag.axh03,
            FETCH ABSOLUTE g_jump q002_cs INTO #g_aag.axh13, #FUN-950048 拿掉axh13
                                            g_aag.axh01,g_aag.axh02,g_aag.axh03,  #NO.FUN-750076
                                           #g_aag.axh04,g_aag.axh041,g_aag.axh05,g_aag.axh06,g_aag.axh00 #No:8004 #NO.FUN-580072 MARK
                                            g_aag.axh04,g_aag.axh041,g_aag.axh05,g_aag.axh06,g_aag.axh12,g_aag.axh00
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.axh01,SQLCA.sqlcode,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
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
    #No.FUN-740020   --BEGIN--                                                                                                      
    CALL s_get_bookno(g_aag.axh06)  RETURNING g_flag,g_bookno1,g_bookno2                                                           
    IF g_flag='1' THEN   #抓不到帳套                                                                                                
       CALL cl_err(g_aag.axh06,'aoo-081',1)                                                                                        
    END IF                                                                                                                          
    #No.FUN-740020    --END-- 
    CALL q002_show()
END FUNCTION
 
FUNCTION q002_show()
  #DISPLAY g_aag.axh13 TO axh13  #no.FUN-750076  #FUN-950048 mark
   DISPLAY g_aag.axh00 TO axh00
   DISPLAY g_aag.axh01 TO axh01
   DISPLAY g_aag.axh02 TO axh02
   DISPLAY g_aag.axh03 TO axh03
   DISPLAY g_aag.axh04  TO axh04   #No:8004
   DISPLAY g_aag.axh041 TO axh041
   DISPLAY g_aag.axh05 TO axh05
   DISPLAY g_aag.axh06 TO axh06
   DISPLAY g_aag.axh12 TO axh12   #NO.FUN-580072
   CALL q002_axh01('d')
   CALL q002_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q002_axh01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
           l_aag02 LIKE aag_file.aag02,
           l_aag06 LIKE aag_file.aag06,
           l_aagacti LIKE aag_file.aagacti
    DEFINE l_axz03    LIKE axz_file.axz03         #FUN-920092 add
    DEFINE l_axz04    LIKE axz_file.axz04         #FUN-950111 add
    DEFINE l_axa09    LIKE axa_file.axa09         #FUN-950111 add
 
    LET g_errno = ' '
    IF g_aag.axh05 IS NULL THEN
        LET l_aag02=NULL
    ELSE
       #FUN-920092---mod---str---
       #SELECT aag02,aag06,aagacti
       #  INTO l_aag02,l_aag06,l_aagacti
       #  FROM aag_file WHERE aag01 = g_aag.axh05
       #                  AND aag00 = g_aaz.aaz64    #No.FUN-740020 #FUN-760053   
#No.FUN-A80034 --begin
#        SELECT axz03,axz04 INTO l_axz03,l_axz04      #FUN-950111 add axz04
#          FROM axz_file
#         WHERE axz01 = g_aag.axh02  
#
#         LET g_plant_new = l_axz03      #營運中心
#         CALL s_getdbs()
#         LET g_dbs_axz03 = g_dbs_new    #所屬DB
#
#         #FUN-950111--mod--str--
#         IF l_axz04 = 'N'   THEN #不使用tiptop
#            LET g_dbs_axz03  = s_dbstring(g_dbs CLIPPED)
#            LET g_plant_new = g_plant   #FUN-A50102
#         ELSE
#            SELECT axa09 INTO l_axa09 FROM axa_file
#             WHERE axa01 = g_aag.axh01   #族群
#               AND axa02 = g_aag.axh02   #上層公司編號    
#            IF l_axa09 = 'Y' THEN
#               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = g_aag.axh02
#               LET g_plant_new = l_axz03    #營運中心
#               CALL s_getdbs()
#               LET g_dbs_axz03 = g_dbs_new    #所屬DB
#            ELSE
#               LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#               LET g_plant_new = g_plant  #FUN-A50102
#            END IF         
#         END IF 
#         #FUN-950111--mod--end
#        #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
#         LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                     " WHERE aaz00 = '0'"
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#         PREPARE q002_pre FROM g_sql
#         DECLARE q002_cur CURSOR FOR q002_pre
#         OPEN q002_cur
#         FETCH q002_cur INTO g_aag.axh00    #合併後帳別
#         IF cl_null(g_aag.axh00) THEN
#             CALL cl_err(g_aag.axh02,'agl-601',1)
#         END IF
       # CALL s_aaz641_dbs(g_aag.axh01,g_aag.axh02) RETURNING g_dbs_axz03     #FUN-A30122 mark
       # CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aag.axh00                 #FUN-A30122 mark
         CALL s_aaz641_dbs(g_aag.axh01,g_aag.axh02) RETURNING g_plant_axz03   #FUN-A30122
         CALL s_get_aaz641(g_plant_axz03) RETURNING g_aag.axh00               #FUN-A30122 
         LET g_plant_new = g_plant_axz03                                      #FUN-A30122
#FUN-A80034 --End        
        #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",   #FUN-950111 mark  #FUN-A50102
         LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102 
                     " WHERE aag01 = '",g_aag.axh05,"'",                
                     "   AND aagacti = 'Y' ",
                     "   AND aag00 = '",g_aag.axh00,"'"                
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE q002_pre_1 FROM g_sql
         DECLARE q002_cur_1 CURSOR FOR q002_pre_1
         OPEN q002_cur_1
         FETCH q002_cur_1 INTO l_aag02 
        
         IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
       #FUN-920092---mod---end---

        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
            LET l_aag06 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
       LET g_aag.aag06 = l_aag06
    END IF
 
END FUNCTION
 
FUNCTION q002_b_fill()              #BODY FILL UP
#  DEFINE l_sql     VARCHAR(400),
   DEFINE l_sql     STRING,        #TQC-630166   
          l_n       LIKE type_file.num5           #No.FUN-680098 smallint#No.FUN-970045
#         l_tot   LIKE axh_file.axh08             #No.FUN-970045
   DEFINE l_total   LIKE axh_file.axh09   #FUN-AB0028
 
   LET l_sql =
#       "SELECT '',axh08, axh09, axh10, axh11,0", #No.FUN-970045
        #"SELECT '',axh08, axh09, axh10, axh11 ",  #No.FUN-970045
        "SELECT '',axh08, axh09, (axh08-axh09),axh10, axh11",   #No.FUN-970045    #FUN-AB0028 mod
        " FROM  axh_file",
        " WHERE axh01 = '",g_aag.axh01,"' AND axh00='",g_aag.axh00,"' ",
        " AND axh02 = '",g_aag.axh02,"' AND axh03='",g_aag.axh03,"' ",
        " AND axh04 = '",g_aag.axh04,"' AND axh041='",g_aag.axh041,"' ",
        " AND axh05 = '",g_aag.axh05,"' AND axh07 = ?",
        " AND axh06 = ",g_aag.axh06," ",                #No:9754
        " AND axh12 = '",g_aag.axh12,"' "                #No.FUN-580072 
      # " AND axh13 = '",g_aag.axh13,"'"                 #NO.FUN-750076 #FUN-950048 mark
    PREPARE q002_pb FROM l_sql
    DECLARE q002_bcs                       #BODY CURSOR
        CURSOR FOR q002_pb
 
    FOR g_cnt = 1 TO g_axh.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_axh[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 0
    IF g_aag.aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
#   LET l_tot = 0                                #No.FUN-970045
    LET l_total = 0    #FUN-AB0028
    FOR g_cnt = 1 TO 14
        LET g_i = g_cnt - 1
        OPEN q002_bcs USING g_i
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
        FETCH q002_bcs INTO g_axh[g_cnt].*
           IF SQLCA.sqlcode = 100 THEN
              LET g_axh[g_cnt].axh08 = 0
              LET g_axh[g_cnt].axh09 = 0
              LET g_axh[g_cnt].axh10 = 0
              LET g_axh[g_cnt].axh11 = 0
#             LET g_axh[g_cnt].l_tot = l_tot      #No.FUN-970045
           END IF
           IF g_i = 0 THEN
                CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
                LET g_axh[g_cnt].seq = g_msg clipped
           ELSE LET g_axh[g_cnt].seq = g_i
           END IF
#No.FUN-970045--begin
#          LET g_axh[g_cnt].l_tot = l_tot +
#            (g_axh[g_cnt].axh08 - g_axh[g_cnt].axh09) * l_n
#          LET l_tot = g_axh[g_cnt].l_tot
#No.FUN-970045--end
        IF cl_null(g_axh[g_cnt].amt) THEN LET g_axh[g_cnt].amt = 0  END IF  #FUN-AB0028
    END FOR
    LET g_rec_b=g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axh TO s_axh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q002_fetch('L')
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q002_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680098 smallint
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
        l_axh  RECORD
               #axh13   LIKE axh_file.axh13,    #NO.FUN-750076 #FUN-950048 mark
                axh00	LIKE axh_file.axh00,
                axh01	LIKE axh_file.axh01,
                axh02	LIKE axh_file.axh02,
                axh03	LIKE axh_file.axh03,
                axh04 	LIKE axh_file.axh04, #No:8004
                axh041	LIKE axh_file.axh041,
                axh05	LIKE axh_file.axh05,
                axh06	LIKE axh_file.axh06,
                axh12	LIKE axh_file.axh12, #NO.FUN-580072
                axh07	LIKE axh_file.axh07,
                axh08   LIKE axh_file.axh08,
                axh09   LIKE axh_file.axh09,
                axh10   LIKE axh_file.axh10,
                axh11   LIKE axh_file.axh11
        END RECORD,
        l_chr           LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1) 
DEFINE  l_aag02         LIKE aag_file.aag02          #No.FUN-830093                                                                              
DEFINE  l_aag06         LIKE aag_file.aag06          #No.FUN-830093
DEFINE  l_axz03         LIKE axz_file.axz03          #FUN-950111
DEFINE  l_axz04         LIKE axz_file.axz04          #FUN-950111
DEFINE  l_axa09         LIKE axa_file.axa09          #FUN-950111
 
    IF tm.wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('aglq002') RETURNING l_name                           #FUN-830093 mark
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
			AND aaf02 = g_lang
#    SELECT azi05 INTO g_azi05 FROM azi_file   #總計之小數位數           #CHI-6A0004
#           WHERE azi01 = g_aza.aza17          #CHI-6A0004
#    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)  # NO.FUN-660123  #CHI-6A0004
#       CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0)   #NO.FUN-660123 #CHI-6A0004
#    END IF                                    #CHI-6A0004
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglq002'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 855555 END IF          #FUN-830093 mark 
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                #FUN-830093 mark 
    #LET g_sql="SELECT axh00,axh01,axh02,axh03,axh04,axh041,",  #No:8004
    LET g_sql="SELECT axh00,axh01,axh02,axh03,axh04,axh041,",  #No:8004  #NO.FUN-750076 #FUN-950048 拿掉axh13
              #" axh05,axh06,axh07,axh08,", #NO.FUN-580072 MARK
              " axh05,axh06,axh12,axh07,axh08,",
              " axh09,axh10,axh11 FROM axh_file,aag_file ",   # 組合出 SQL 指令
              #" WHERE aag01=axh05 AND aag00=axh00 ",tm.wc CLIPPED,   #No.FUN-740020
              " WHERE aag01=axh05 AND aag00=axh00 ",
              "   AND ",tm.wc CLIPPED,   #NO.FUN-750076
              #" ORDER BY axh00,axh01,axh02,axh05,axh06,axh07 "
              " ORDER BY axh00,axh01,axh02,axh05,axh06,axh07 "  #NO.FUN-750076 #FUN-950048 拿掉axh13
    PREPARE q002_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q002_co CURSOR FOR q002_p1
 
#   START REPORT q002_rep TO l_name                                        #FUN-830093 mark 
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830093 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     #------------------------------ CR (2) ------------------------------# 
 
    FOREACH q002_co INTO l_axh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
      #FUN-950111--mod--str--
      #SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file                                                                   
      # WHERE aag01=l_axh.axh05 AND aagacti='Y' AND aag00=l_axh.axh00  
      IF l_axh.axh05 IS NULL THEN                                                                                                     
         LET l_aag02=NULL                                                                                                            
      ELSE                                                                                                                            
#No.FUN-A80034 --begin
#        SELECT axz03,axz04 INTO l_axz03,l_axz04 
#          FROM axz_file                                                                                                             
#         WHERE axz01 = l_axh.axh02                                                                                                  
#                                                                                                                                    
#         LET g_plant_new = l_axz03      #營運中心                                                                                   
#         CALL s_getdbs()                                                                                                            
#         LET g_dbs_axz03 = g_dbs_new    #所屬DB                                                                                     
#                                                                                                                                    
#         IF l_axz04 = 'N'   THEN #不使用tiptop                                                                                      
#            LET g_dbs_axz03  = s_dbstring(g_dbs CLIPPED)                                                                               
#            LET g_plant_new = g_plant  #FUN-A50102
#         ELSE                                                                                                                       
#            SELECT axa09 INTO l_axa09 FROM axa_file                                                                                 
#             WHERE axa01 = l_axh.axh01   #族群                                                                                      
#               AND axa02 = l_axh.axh02   #上層公司編號                                                                              
#            IF l_axa09 = 'Y' THEN      
#               SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = l_axh.axh02                                                    
#               LET g_plant_new = l_axz03    #營運中心                                                                               
#               CALL s_getdbs()                                                                                                      
#               LET g_dbs_axz03 = g_dbs_new    #所屬DB                                                                                  
#            ELSE                                                                                                                    
#               LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)                                                                             
#               LET g_plant_new = g_plant   #FUN-A50102
#            END IF                                                                                                                  
#         END IF                                                                                                                     
#                                                                                                                                    
#        #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
#         LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102                                                                
#                     " WHERE aaz00 = '0'"                                                                                           
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#         PREPARE q002_pre1 FROM g_sql                                                                                                
#         DECLARE q002_cur1 CURSOR FOR q002_pre1                                                                                       
#         OPEN q002_cur1                                                                                                              
#         FETCH q002_cur1 INTO l_axh.axh00    #合并後帳別                                                                             
#         IF cl_null(l_axh.axh00) THEN                                                                                               
#             CALL cl_err(l_axh.axh02,'agl-601',1)                                                                                   
#         END IF
       # CALL s_aaz641_dbs(l_axh.axh01,l_axh.axh02) RETURNING g_dbs_axz03     #FUN-A30122 mark
       # CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axh.axh00                 #FUN-A30122 mark
         CALL s_aaz641_dbs(l_axh.axh01,l_axh.axh02) RETURNING g_plant_axz03   #FUN-A30122 add
         CALL s_get_aaz641(g_plant_axz03) RETURNING l_axh.axh00               #FUN-A30122 add
         LET g_plant_new = g_plant_axz03                                      #FUN-A30122 add  
#FUN-A80034 --End
     
        #LET g_sql = "SELECT aag02,aag06 FROM ",g_dbs_axz03,"aag_file", #FUN-A50102
         LET g_sql = "SELECT aag02,aag06 FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102 
                     " WHERE aag01 = '",l_axh.axh05,"'",                                                                            
                     "   AND aagacti = 'Y' ",                                                                                       
                     "   AND aag00 = '",l_axh.axh00,"'"                                                                             
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE q002_pre_2 FROM g_sql                                                                                              
         DECLARE q002_cur_2 CURSOR FOR q002_pre_2                                                                                   
         OPEN q002_cur_2                                                                                                            
         FETCH q002_cur_2 INTO l_aag02,l_aag06                                                                                                                         
         IF SQLCA.sqlcode  THEN LET l_aag02 = '' LET l_aag06 = '' END IF 
     END IF  
     #FUN-950111--mod--end
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830093 *** ##                                                   
         EXECUTE insert_prep USING                                                                                                
                #l_axh.axh13, #FUN-950048 拿掉axh13
                 l_axh.axh00,l_axh.axh01,l_axh.axh02,l_axh.axh03,                                                                                     
                 l_axh.axh05,l_axh.axh06,l_axh.axh12,l_axh.axh07,l_axh.axh08,                                                                     
#                l_axh.axh09,l_aag02,l_aag06,'0'                            #No.FUN-970045
                 l_axh.axh09,l_aag02,l_aag06                                #No.FUN-970045
                                                               
     #------------------------------ CR (3) ------------------------------#
#       OUTPUT TO REPORT q002_rep(l_axh.*)                                  #FUN-830093 mark 
    END FOREACH
 
#   FINISH REPORT q002_rep                                                  #FUN-830093 mark 
 
    CLOSE q002_co
    ERROR ""
#No.FUN-830093--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'axh01,axh00,axh02,axh03,axh04,axh041,axh05,axh06,axh12')  #FUN-950048 拿掉axh13                                                                                 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-830093--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830093 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_azi05                                                                                
    CALL cl_prt_cs3('aglq002','aglq002',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
#   CALL cl_prt(l_name,' ','1',g_len)                                        #FUN-830093 mark 
END FUNCTION
 
#NO.FUN-830093 -Mark--Begin--#
#REPORT q002_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,        #No.FUN-680098  VARCHAR(1)  
#       sr     RECORD
#               axh13   LIKE axh_file.axh13,   #NO.FUN-750076
#               axh00	LIKE axh_file.axh00,
#               axh01	LIKE axh_file.axh01,
#               axh02	LIKE axh_file.axh02,
#               axh03	LIKE axh_file.axh03,
#               axh04 	LIKE axh_file.axh04,  #No:8004
#               axh041	LIKE axh_file.axh041,
#               axh05	LIKE axh_file.axh05,
#               axh06	LIKE axh_file.axh06,
#               axh12	LIKE axh_file.axh12,  #NO.FUN-580072 MARK
#               axh07   LIKE axh_file.axh07,
#               axh08   LIKE axh_file.axh08,
#               axh09   LIKE axh_file.axh09,
#               axh10   LIKE axh_file.axh10,
#               axh11   LIKE axh_file.axh11
#       END RECORD,
#       l_aag02         LIKE aag_file.aag02,
#       l_aag06         LIKE aag_file.aag06,
#       l_tot           LIKE axh_file.axh08,
#       l_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   #ORDER BY sr.axh00,sr.axh01,sr.axh02,sr.axh03,sr.axh06,sr.axh05
#   ORDER BY sr.axh13,sr.axh00,sr.axh01,sr.axh02,sr.axh03,sr.axh06,sr.axh05  #NO.FUN-750076
 
#   FORMAT
#       PAGE HEADER
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#         # PRINT g_x[39] CLIPPED,sr.axh13 CLIPPED      #NO.FUN-750076   #FUN-760044 mark
#           PRINT g_x[11] CLIPPED,sr.axh01 CLIPPED,      #MOD-4A0338
#                 COLUMN 26,g_x[12] CLIPPED,sr.axh02 CLIPPED,
#                 COLUMN 50,g_x[13] CLIPPED,sr.axh03 CLIPPED,
#                 COLUMN 70,g_x[14] CLIPPED,sr.axh00 CLIPPED
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                 COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
 
#       #BEFORE GROUP OF sr.axh01
#       BEFORE GROUP OF sr.axh13      #NO.FUN-750076
#           SKIP TO TOP OF PAGE
 
#       BEFORE GROUP OF sr.axh05
#           #No.TQC-6A0093  --Begin
#           PRINT COLUMN 01,g_x[31] CLIPPED,COLUMN 26,g_x[32] CLIPPED,
#                 COLUMN 77,g_x[33] CLIPPED,COLUMN 86,g_x[34] CLIPPED
#           PRINT '------------------------ ',
#                 '-------------------------------------------------- ',
#                 '-------- ----'
#           #No.TQC-6A0093  --End
#           #No.FUN-740020   --begin--                                                                                               
#          CALL s_get_bookno(sr.axh06)  RETURNING g_flag,g_bookno1,g_bookno2                                                        
#          #No.FUN-740020   --end--       
#           SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
#            WHERE aag01=sr.axh05 AND aagacti='Y' AND aag00=sr.axh00   # No.FUN-740020
#FUN-590124
#           #No.TQC-6A0093  --Begin
#           PRINT COLUMN 01,sr.axh05 CLIPPED, COLUMN 26,l_aag02 CLIPPED,
#                 COLUMN 77,sr.axh06 USING '####',
#                 COLUMN 86,sr.axh12   #NO.FUN-580072
#           #No.TQC-6A0093  --End  
#           PRINT sr.axh05 CLIPPED, COLUMN 26,l_aag02 CLIPPED,
#                 COLUMN 53,sr.axh06 USING '####',
#                  COLUMN 62,sr.axh12   #NO.FUN-580072
#FUN-590124 End
#           #No.TQC-6A0093  --Begin
#           PRINT COLUMN 08,g_x[35] CLIPPED,COLUMN 16,g_x[36] CLIPPED,
#                 COLUMN 38,g_x[37] CLIPPED,COLUMN 60,g_x[38] CLIPPED
#           PRINT COLUMN 08,'------  --------------------  --------------------  ',
#                           '--------------------'
#           #No.TQC-6A0093  --End  
#           LET l_tot = 0
#
#       ON EVERY ROW
#           IF l_aag06 = '1' THEN
#              LET l_tot = l_tot +(sr.axh08 - sr.axh09)
#           ELSE
#              LET l_tot = l_tot +(sr.axh09 - sr.axh08)
#           END IF
#           IF sr.axh07 = 0 THEN
#               PRINT COLUMN 8,g_x[25] CLIPPED;    #MOD-4A0338(END)
#           ELSE
#              PRINT COLUMN 8,sr.axh07 USING '######';  #No.TQC-6A0093
#           END IF
#           #No.TQC-6A0093  --Begin
#           PRINT COLUMN 16,cl_numfor(sr.axh08,19,g_azi05) CLIPPED,
#                 COLUMN 38,cl_numfor(sr.axh09,19,g_azi05) CLIPPED,
#                 COLUMN 60,cl_numfor(l_tot,19,g_azi05) CLIPPED
#           #No.TQC-6A0093  --End  
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   #TQC-630166
#                   #IF g_wc[001,080] > ' ' THEN
#       	    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(tm.wc)
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0093
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0093
#           ELSE
#               PRINT ''
#               PRINT g_x[4] CLIPPED  #No.TQC-6A0093
#           END IF
#END REPORT
#NO.FUN-830093 -Mark--End--#
#Patch....NO.TQC-610035 <002,003,004> #
