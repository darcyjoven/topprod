# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglq022.4gl
# Descriptions...: 合併前科目異動碼沖帳餘額查詢
# Date & Author..: 01/09/19 BY Debbie Hsu
# Modify.........: No.MOD-490198 04/09/15 By Nicola 單身抓不到資料
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: NO.FUN-580072 05/08/17 BY yiting 增加幣別欄
# Modify.........: No.FUN-590124 05/10/27 By Dido aag02科目名稱放
# Modify.........: NO.TQC-5B0064 05/11/08 By Niocla 報表修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680025 06/08/24 By bnlent voucher類型報表轉template1
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/04 By mike    會計科目加帳套
# Modify.........: NO.FUN-750076 07/05/18 BY yiting add ass15
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760044 07/06/15 By Sarah 將版本欄位隱藏
# Modify.........: No.FUN-770069 07/10/17 By Sarah 列印報表後導致程式異常(不應該用g_ass接報表資料),output to report與report的傳/收參數不同
# Modify.........: No.FUN-830093 08/03/24 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-910001 09/01/02 By Sarah ass01(群組代號)增加開窗功能
# Modify.........: No.FUN-920066 09/05/19 By jan "族群帳別"改show上層公司的合并之後帳別
# Modify.........: No.FUN-920071 09/05/20 By jan 查詢時_cs( )應修改目前查不出對應資料
# Modify.........: NO.FUN-950048 09/05/18 BY jan 拿掉 ass15 欄位
# Modify.........: No.FUN-950111 09/06/01 By lutingting 選aag02時要加asa09得判斷
# Modify.........: No.FUN-960010 09/06/04 By lutingting 畫面新增欄位ass16,ass17
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970045 09/07/21 By chenmoyan 取消余額欄位
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.FUN-A80034 10/08/09 By wujie   追21区FUN-A30122
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 修改A80034 追單 
# Modify.........: No.FUN-A80092 10/09/07 By chenmoyan 增加 下層記帳幣別借方 下層記帳幣別貸方 下層功能幣別借方 下層功能幣別貸方
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0006 
#模組變數(Module Variables)            #FUN-BB0036
DEFINE
     tm  RECORD
       	wc  	STRING         #TQC-630166 		# Head Where condition
        END RECORD,
    g_ass1  RECORD
            ass01   LIKE ass_file.ass01,
            ass00   LIKE ass_file.ass00,
            ass05   LIKE ass_file.ass05,
            ass06   LIKE ass_file.ass06,
            ass07   LIKE ass_file.ass07,
            ass08   LIKE ass_file.ass08,
            ass14   LIKE ass_file.ass14,  #NO.FUN-580072
            ass02   LIKE ass_file.ass02,
            ass03   LIKE ass_file.ass03,
            ass04   LIKE ass_file.ass04,
            ass041  LIKE ass_file.ass041
            END RECORD,
    g_ass DYNAMIC ARRAY OF RECORD
            seq     LIKE ze_file.ze03, #No.FUN-680098  char(4) 
            ass10   LIKE ass_file.ass10,
            ass11   LIKE ass_file.ass11,
            amt1    LIKE type_file.num20_6,#FUN-AB0028
            ass18   LIKE ass_file.ass18,   #No.FUN-A80092
            ass19   LIKE ass_file.ass19,   #No.FUN-A80092
            amt2    LIKE type_file.num20_6,#FUN-AB0028
            ass20   LIKE ass_file.ass20,   #No.FUN-A80092
            ass21   LIKE ass_file.ass21,   #No.FUN-A80092
            amt3    LIKE type_file.num20_6,#FUN-AB0028
#           summ    LIKE ass_file.ass10,   #No.FUN-970045
            ass16   LIKE ass_file.ass16,   #FUN-960010 add
            ass17   LIKE ass_file.ass17    #FUN-960010 add
        END RECORD,
    m_cnt           LIKE type_file.num10,   #No.FUN-680098    INTEGER
    g_argv1         LIKE ass_file.ass00,    # INPUT ARGUMENT - 1
    g_bookno        LIKE aaa_file.aaa01,    #帳別  #No.FUN-670039
    g_wc,g_sql      STRING,                 #TQC-630166             #WHERE CONDITION
    l_total         LIKE ass_file.ass10,
    p_row,p_col     LIKE type_file.num5,                  #No.FUN-680098  SMALLINT
    g_rec_b         LIKE type_file.num5     #單身筆數     #No.FUN-680098  SMALLINT    
 
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680098    INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose  #No.FUN-680098     SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10     #No.FUN-680098    INTEGER
DEFINE   g_curs_index    LIKE type_file.num10     #No.FUN-680098    INTEGER 
DEFINE   g_jump          LIKE type_file.num10     #No.FUN-680098    INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680098    SMALLINT 
DEFINE   g_bookno1       LIKE aza_file.aza81      #No.FUN-740020    
DEFINE   g_bookno2       LIKE aza_file.aza82      #No.FUN-740020 
DEFINE   g_flag          LIKE type_file.chr1      #No.FUN-740020
DEFINE   l_table         STRING,                  ### FUN-830093 ###                                                                  
         g_str           STRING                   ### FUN-830093 ###
DEFINE g_dbs_asg03     LIKE type_file.chr21       #FUN-920066  add
DEFINE g_plant_asg03   LIKE type_file.chr21       #FUN-A30122 add
MAIN
       DEFINE
          l_sl		LIKE type_file.num5      #No.FUN-680098    SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
    LET g_sql = "ass01.ass_file.ass01,",    #FUN-950048 mod
                "ass00.ass_file.ass00,",                                                                                            
                "ass05.ass_file.ass05,",                                                                                            
                "ass06.ass_file.ass06,",                                                                                            
                "ass07.ass_file.ass07,",                                                                                            
                "ass08.ass_file.ass08,",                                                                                            
                "ass14.ass_file.ass14,",                                                                                            
                "ass02.ass_file.ass02,",                                                                                            
                "ass03.ass_file.ass03,",                                                                                            
                "ass04.ass_file.ass04,",                                                                                            
                "ass041.ass_file.ass041,",
                "ass09.ass_file.ass09,",
                "ass10.ass_file.ass10,",
                "ass11.ass_file.ass11,",
                "l_aag02.aag_file.aag02,",
                "m_cnt.type_file.num10,",
                "ass16.ass_file.ass16,",   #FUN-960010 add                                                                                           
                "ass17.ass_file.ass17"     #FUN-960010 add
    LET l_table = cl_prt_temptable('gglq022',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      #FUN-950048 add                                                                   
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                                       
                "        ?, ?, ?, ?, ?, ?, ?, ?,?)"               #No.FUN-970045                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
    LET g_bookno = ARG_VAL(1)
    IF cl_null(g_bookno) THEN LET  g_bookno=g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW q003_w AT p_row,p_col WITH FORM "ggl/42f/gglq022"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q003_menu()
    CLOSE FORM q003_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q003_cs()
   DEFINE   l_cnt like type_file.num5        #No.FUN-680098     SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_ass.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INITIALIZE g_ass1.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             ass01,ass00,ass02,ass03,ass04,ass041,  #NO.FUN-750076 #FUN-950048 拿掉ass15
             ass08,ass14,ass05,ass06,ass07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ass01) #族群編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ass"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ass01
                    NEXT FIELD ass01
               WHEN INFIELD(ass05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_aag"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ass05
               WHEN INFIELD(ass14) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_ass1.ass14
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ass14
                    NEXT FIELD ass14
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
    LET g_sql="SELECT UNIQUE ass00,ass01,ass02,ass03,ass04,ass041,ass05, ",  #FUN-950048 拿掉ass15
              "              ass06,ass07,ass08,ass14 ",
              "  FROM ass_file ",
              " WHERE ",tm.wc CLIPPED,
              " ORDER BY ass01,ass02,ass03,ass04,ass05,ass06,ass07,ass08 "  #FUN-950048 拿掉ass15
   PREPARE q003_prepare FROM g_sql
   DECLARE q003_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q003_prepare
 
   DROP TABLE x
   LET g_sql="SELECT UNIQUE ass01,ass00,ass02,ass03,ass04,ass041,ass05, ",   #NO.FUN-750076 #FUN-950048 拿掉ass15
             "       ass06,ass07,ass08,ass14 FROM ass_file ",            #FUN-920066 mod
             "  WHERE ",tm.wc CLIPPED,
             "   INTO TEMP x"
   PREPARE q003_prepare_pre FROM g_sql
   EXECUTE q003_prepare_pre
   DECLARE q003_count CURSOR FOR
    SELECT COUNT(*) FROM x
END FUNCTION
 
FUNCTION q003_menu()
   WHILE TRUE
      CALL q003_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q003_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q003_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ass),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q003_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
   CALL g_ass.clear()
    CALL q003_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN q003_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q003_count
       FETCH q003_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q003_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q003_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098   VARCHAR(1)    
    l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098  INTEGER  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q003_cs INTO g_ass1.ass00,g_ass1.ass01,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                                             g_ass1.ass02,g_ass1.ass03,
                                             g_ass1.ass04,g_ass1.ass041,
                                             g_ass1.ass05,g_ass1.ass06,
                                             g_ass1.ass07,g_ass1.ass08,
                                             g_ass1.ass14  #NO.FUN-580072
        WHEN 'P' FETCH PREVIOUS q003_cs INTO g_ass1.ass00,g_ass1.ass01,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                                             g_ass1.ass02,g_ass1.ass03,
                                             g_ass1.ass04,g_ass1.ass041,
                                             g_ass1.ass05,g_ass1.ass06,
                                             g_ass1.ass07,g_ass1.ass08,
                                             g_ass1.ass14  #NO.FUN-580072
        WHEN 'F' FETCH FIRST    q003_cs INTO g_ass1.ass00,g_ass1.ass01,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                                             g_ass1.ass02,g_ass1.ass03,
                                             g_ass1.ass04,g_ass1.ass041,
                                             g_ass1.ass05,g_ass1.ass06,
                                             g_ass1.ass07,g_ass1.ass08,
                                             g_ass1.ass14   #NO.FUN-580072
        WHEN 'L' FETCH LAST     q003_cs INTO g_ass1.ass00,g_ass1.ass01,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                                             g_ass1.ass02,g_ass1.ass03,
                                             g_ass1.ass04,g_ass1.ass041,
                                             g_ass1.ass05,g_ass1.ass06,
                                             g_ass1.ass07,g_ass1.ass08,
                                             g_ass1.ass14   #NO.FUN-580072
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
            FETCH ABSOLUTE g_jump q003_cs INTO g_ass1.ass00,g_ass1.ass01,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                                               g_ass1.ass02,g_ass1.ass03,
                                               g_ass1.ass04,g_ass1.ass041,
                                               g_ass1.ass05,g_ass1.ass06,
                                               g_ass1.ass07,g_ass1.ass08,
                                               g_ass1.ass14  #NO.FUN-580072
            LET mi_no_ask = FALSE
     END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ass1.ass02,SQLCA.sqlcode,0)
       INITIALIZE g_ass1.* TO NULL  #TQC-6B0105
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
    CALL s_get_bookno(g_ass1.ass08)  RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag='1' THEN   #抓不到帳套
       CALL cl_err(g_ass1.ass08,'aoo-081',1)
    END IF
    CALL q003_show()
END FUNCTION
 
FUNCTION q003_show()
 DEFINE  l_aag02         LIKE aag_file.aag02
 
   DISPLAY BY NAME g_ass1.ass00,g_ass1.ass01,g_ass1.ass02,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                   g_ass1.ass03,g_ass1.ass04,g_ass1.ass041,
                   g_ass1.ass05,g_ass1.ass06,g_ass1.ass07,g_ass1.ass08,
                   g_ass1.ass14  #NO.FUN-580072
 
   CALL q003_ass00('d',g_ass1.ass02,g_ass1.ass01)      #FUN-950111
 
   CALL q003_b_fill() #單身
 
   CALL cl_show_fld_cont()               #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q003_ass00(p_cmd,p_ass02,p_ass01)   #FUN-950111 add
  DEFINE p_cmd     LIKE type_file.chr1, 
         p_ass02   LIKE ass_file.ass02,     
         l_asg03   LIKE asg_file.asg03,                        
         l_aag02   LIKE aag_file.aag02,
         p_ass01   LIKE ass_file.ass01        #FUN-950111 add
  DEFINE l_asg04   LIKE asg_file.asg04        #FUN-950111 add                                                                   
  DEFINE l_asa09   LIKE asa_file.asa09        #FUN-950111 add 
  
    LET g_errno = ' '
 
    SELECT asg03,asg04 INTO l_asg03,l_asg04   #FUN-950111 add asg04    
      FROM asg_file
     WHERE asg01 = p_ass02
    
     LET g_plant_new = l_asg03      #營運中心
     CALL s_getdbs()
     LET g_dbs_asg03 = g_dbs_new    #所屬DB
 
#No.FUN-A80034 --beatk
#     IF l_asg04 = 'N' THEN   #不使用tipop
#        LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#        LET g_plant_new = g_plant   #FUN-A50102
#     ELSE
#        SELECT asa09 INTO l_asa09 FROM asa_file
#         WHERE asa01 = p_ass01    #族群
#           AND asa02 = p_ass02    #上層公司編號
#        IF l_asa09 = 'Y' THEN
#           SELECT asg03 INTO l_asg03 FROM asg_file
#            WHERE asg01 = p_ass02
#           LET g_plant_new = l_asg03
#           CALL s_getdbs()
#           LET g_dbs_asg03 = g_dbs_new
#        ELSE
#           LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#           LET g_plant_new = g_plant   #FUN-A50102
#        END IF   
#     END IF 
#    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A50102
#     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#     PREPARE q003_pre FROM g_sql
#     DECLARE q003_cur CURSOR FOR q003_pre
#     OPEN q003_cur
#     FETCH q003_cur INTO g_ass1.ass00    #合併後帳別
#     IF cl_null(g_ass1.ass00) THEN
#         CALL cl_err(l_asg03,'agl-601',1)
#     END IF
   # CALL s_aaz641_asg(p_ass01,p_ass02) RETURNING g_dbs_asg03        #FUN-A30012 mark
   # CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_ass1.ass00           #FUN-A30012 mark
     CALL s_aaz641_asg(p_ass01,p_ass02) RETURNING g_plant_asg03      #FUN-A30122 add
     CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_ass1.ass00         #FUN-A30122 add
     LET g_plant_new = g_plant_asg03                                 #FUN-A30122 add 
#FUN-A80034 --End 
    #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102 
     LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102 
                 " WHERE aag01 = '",g_ass1.ass05,"'",                
                 "   AND aagacti = 'Y' ",
                 "   AND aag00 = '",g_ass1.ass00,"'"                
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
     PREPARE q003_pre_1 FROM g_sql
     DECLARE q003_cur_1 CURSOR FOR q003_pre_1
     OPEN q003_cur_1
     FETCH q003_cur_1 INTO l_aag02 
 
     IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
 
     DISPLAY l_aag02 TO aag02
     DISPLAY BY NAME g_ass1.ass00
 
END FUNCTION
 
 
FUNCTION q003_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING,        #TQC-630166
          l_n       LIKE type_file.num5        #No.FUN-680098   smallint 
   DEFINE l_total1  LIKE ass_file.ass11        #FUN-AB0028
   DEFINE l_total2  LIKE ass_file.ass11        #FUN-AB0028
   DEFINE l_total3  LIKE ass_file.ass11        #FUN-AB0028

   LET l_total1 = 0    #FUN-AB0028
   LET l_total2 = 0    #FUN-AB0028
   LET l_total3 = 0    #FUN-AB0028

   LET l_sql =
        #"SELECT '',ass10, ass11,ass18,ass19,ass20,ass21,ass16,ass17",                #No.FUN-970045 #FUN-A80092 add ass18~ass21
        "SELECT '',ass10, ass11,(ass10-ass11),ass18,ass19,(ass18-ass19),ass20,ass21,(ass20-ass21),ass16,ass17",  #FUN-AB0028
        " FROM  ass_file",
        " WHERE ass05 = '",g_ass1.ass05,"'",
        " AND ass00 = '",g_ass1.ass00,"' AND ass01 = '",g_ass1.ass01,"'",
        " AND ass02 = '",g_ass1.ass02,"' AND ass03 = '",g_ass1.ass03,"'",
        " AND ass04 = '",g_ass1.ass04,"' AND ass041= '",g_ass1.ass041,"'",
        " AND ass05 = '",g_ass1.ass05,"' AND ass06 = '",g_ass1.ass06,"'",
        " AND ass07 = '",g_ass1.ass07,"' AND ass08 = '",g_ass1.ass08,"'",
        " AND ass14 = '",g_ass1.ass14,"'",  #NO.FUN-580072
        " AND ass09 =?"
    PREPARE q003_pb FROM l_sql
    DECLARE q003_bcs                       #BODY CURSOR
        CURSOR FOR q003_pb
 
    CALL g_ass.clear()
    LET g_rec_b=0
    LET g_cnt = 0
    LET l_total = 0
    FOR g_cnt = 1 TO 14
        LET g_i = g_cnt - 1
        OPEN q003_bcs USING g_i    #由第０期開始抓
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
        FETCH q003_bcs INTO g_ass[g_cnt].*
        IF SQLCA.SQLCODE THEN         #No.MOD-490198
           LET g_ass[g_cnt].ass10 = 0
           LET g_ass[g_cnt].ass11 = 0
           LET g_ass[g_cnt].ass18 = 0 #FUN-A80092 add
           LET g_ass[g_cnt].ass19 = 0 #FUN-A80092 add
           LET g_ass[g_cnt].ass20 = 0 #FUN-A80092 add
           LET g_ass[g_cnt].ass21 = 0 #FUN-A80092 add
        END IF
        IF g_i = 0 THEN
           CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
           LET g_ass[g_cnt].seq = g_msg clipped
        ELSE 
           LET g_ass[g_cnt].seq = g_i
        END IF
        IF cl_null(g_ass[g_cnt].amt1) THEN LET g_ass[g_cnt].amt1 = 0  END IF  #FUN-AB0028
        IF cl_null(g_ass[g_cnt].amt2) THEN LET g_ass[g_cnt].amt2 = 0  END IF  #FUN-AB0028
        IF cl_null(g_ass[g_cnt].amt3) THEN LET g_ass[g_cnt].amt3 = 0  END IF  #FUN-AB0028
        CLOSE q003_bcs
    END FOR
    LET g_rec_b=g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q003_bp(p_ud)
   DEFINE   p_ud    LIKE type_file.chr1       #No.FUN-680098    VARCHAR(1)   
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ass TO s_ass.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q003_fetch('L')
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q003_out()
    DEFINE
        l_i            	LIKE type_file.num5,       #No.FUN-680098     smallint
        l_sql1          STRING,        #TQC-630166
        l_name          LIKE type_file.chr20,    # External(Disk) file name   #No.FUN-680098    VARCHAR(20)
        l_ass  RECORD
                ass01   LIKE ass_file.ass01,
                ass00   LIKE ass_file.ass00,
                ass05   LIKE ass_file.ass05,
                ass06   LIKE ass_file.ass06,
                ass07   LIKE ass_file.ass07,
                ass08   LIKE ass_file.ass08,
                ass14   LIKE ass_file.ass14,    #NO.FUN-580072
                ass02   LIKE ass_file.ass02,
                ass03   LIKE ass_file.ass03,
                ass04   LIKE ass_file.ass04,
                ass041  LIKE ass_file.ass041,
                ass09   LIKE ass_file.ass09     #FUN-770069 add 10/19
               END RECORD,
        l_ass1 DYNAMIC ARRAY OF RECORD
                ass10   LIKE ass_file.ass10,
                ass11   LIKE ass_file.ass11,
                seq     LIKE ze_file.ze03,
                ass16   LIKE ass_file.ass16,   #FUN-960010 ADD
                ass17   LIKE ass_file.ass17    #FUN-960010 ADD
               END RECORD,
        l_chr    LIKE type_file.chr1       #No.FUN-680098
DEFINE  l_aag02 LIKE aag_file.aag02
DEFINE l_asg03    LIKE asg_file.asg03         #FUN-950111 add                                                                   
DEFINE l_asg04    LIKE asg_file.asg04         #FUN-950111 add                                                                   
DEFINE l_asa09    LIKE asa_file.asa09         #FUN-950111 add 
    IF tm.wc IS NULL THEN
       CALL cl_err('',-400,0) 
       RETURN
    END IF
    CALL cl_wait()
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
                                                AND aaf02 = g_lang
    LET g_sql="SELECT UNIQUE ass01,ass00,ass05,ass06,ass07,ass08,ass14,",  #NO.FUN-750076 #FUN-950048 拿掉ass15
              "       ass02,ass03,ass04,ass041,'' ", # 組合出 SQL 指令 #FUN-770069      10/19
              " FROM ass_file,aag_file ",   #FUN-770069      10/19
              " WHERE aag01=ass05 AND aag00=ass00 AND ",tm.wc CLIPPED  #FUN-770069      10/19
    PREPARE q003_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q003_co CURSOR FOR q003_p1
 
    LET l_sql1 = " SELECT ass10,ass11,(ass10-ass11),ass16,ass17",   #FUN-960010 add ass16,ass17
                 " FROM ass_file" ,
                 " WHERE ass00 = ? AND ass01 = ? AND ass02 = ? ",  #no.FUN-750076 #FUN-950048
                 "   AND ass03 = ?  AND ass04 = ? AND ass041= ? ",
                 "   AND ass05 = ?  AND ass06 = ? AND ass07 = ? ",
                 "   AND ass08 = ?  AND ass09 = ? ",
                 "   AND ass14 = ? "  #NO.FUN-580072
 
    PREPARE q003_p2 FROM l_sql1               # RUNTIME 編譯
    DECLARE q003_c1 CURSOR FOR q003_p2
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830093 *** ##                                                    
     CALL cl_del_data(l_table)                                             
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830093                                                         
     #------------------------------ CR (2) ------------------------------#
 
    LET l_total = 0
    LET m_cnt = 0
    FOREACH q003_co INTO l_ass.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_total=0
      FOR g_cnt=1 TO l_ass1.getLength()        #FUN-770069 mod 10/19 g_ass->l_ass1
          INITIALIZE l_ass1[g_cnt].* TO NULL   #FUN-770069 mod 10/19 g_ass->l_ass1
      END FOR
      FOR g_cnt = 1 TO 14                 #FUN-770069      10/19
          LET l_ass.ass09 = g_cnt - 1   #FUN-770069      10/19
          OPEN q003_c1 USING l_ass.ass00,l_ass.ass01,l_ass.ass02,l_ass.ass03,  #NO.FUN-750076 #FUN-950048 拿掉ass15
                             l_ass.ass04,l_ass.ass041,l_ass.ass05,l_ass.ass06,
                             l_ass.ass07,l_ass.ass08,l_ass.ass09,  #FUN-770069      10/19
                             l_ass.ass14  #NO.FUN-580072
                                                                                                     
#No.FUN-A80034 --beatk
#           SELECT asg03,asg04 FROM asg_file WHERE asg01 = l_ass.ass02
#           LET g_plant_new = l_asg03
#           CALL s_getdbs()
#           LET g_dbs_asg03 = g_dbs_new
#           IF l_asg04 = 'N' THEN
#              LET  g_dbs_asg03  = s_dbstring(g_dbs CLIPPED)
#              LET g_plant_new = g_plant  #FUN-A50102
#           ELSE
#              SELECT asa09 INTO l_asa09 FROM asa_file 
#               WHERE asa01 = l_ass.ass01
#                 AND asa02 = l_ass.ass02
#              IF l_asa09 = 'Y'  THEN
#                 SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = l_ass.ass02
#                 LET g_plant_new = l_asg03
#                 CALL s_getdbs()
#                 LET g_dbs_asg03 = g_dbs_new
#              ELSE
#                 LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#                 LET g_plant_new = g_plant  #FUN-A50102
#              END IF 
#           END IF
#          
#          #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",   #FUN-A50102                                                                    
#           LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102 
#                       " WHERE aaz00 = '0'"                                                                                               
#           CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#           PREPARE q003_pre1 FROM g_sql                                                                                                    
#           DECLARE q003_cur1 CURSOR FOR q003_pre                                                                                           
#           OPEN q003_cur1                                                                                                                  
#           FETCH q003_cur1 INTO l_ass.ass00    #合并後帳別                                                                                
         # CALL s_aaz641_asg(l_ass.ass01,l_ass.ass02) RETURNING g_dbs_asg03         #FUN-A30122 mark
         # CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_ass.ass00                     #FUN-A30122 mark
           CALL s_aaz641_asg(l_ass.ass01,l_ass.ass02) RETURNING g_plant_asg03       #FUN-A30122 add
           CALL s_get_aaz641_asg(g_plant_asg03) RETURNING l_ass.ass00                   #FUN-A30122 add
           LET g_plant_new = g_plant_asg03                                          #FUN-A30122 add
#FUN-A80034 --End
           IF cl_null(l_ass.ass00) THEN                                                                                                  
               CALL cl_err(l_asg03,'agl-601',1)                                                                                           
           END IF                                                                                                                         
                                                                                                                                    
          #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file", #FUN-A50102 
           LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
                       " WHERE aag01 = '",l_ass.ass05,"'",                                                                               
                       "   AND aagacti = 'Y' ",                                                                                           
                       "   AND aag00 = '",l_ass.ass00,"'"                                                                                
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
           PREPARE q003_pre_2 FROM g_sql                                                                                                  
           DECLARE q003_cur_2 CURSOR FOR q003_pre_2                                                                                       
           OPEN q003_cur_2                                                                                                                
           FETCH q003_cur_2 INTO l_aag02 
 
           IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF                                                                           
          FETCH q003_c1 INTO l_ass1[g_cnt].*   #FUN-770069 mod 10/19 g_ass->l_ass1
          IF SQLCA.sqlcode THEN
             LET l_ass1[g_cnt].ass10 = 0    #FUN-770069 mod 10/19 g_ass->l_ass1
             LET l_ass1[g_cnt].ass11 = 0    #FUN-770069 mod 10/19 g_ass->l_ass1
          END IF
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830093 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 l_ass.ass01,l_ass.ass00,l_ass.ass05,l_ass.ass06,l_ass.ass07, #FUN-950048 拿掉ass15
                 l_ass.ass08,l_ass.ass14,l_ass.ass02,l_ass.ass03,l_ass.ass04,l_ass.ass041,
                 l_ass.ass09,l_ass1[g_cnt].ass10,l_ass1[g_cnt].ass11,l_aag02,m_cnt,  #No.FUN-970045
                 l_ass1[g_cnt].ass16,l_ass1[g_cnt].ass17   #FUN-960010 add
     #------------------------------ CR (3) ------------------------------#
 
          LET m_cnt = m_cnt + 1                                                            #FUN-830093 add
         CLOSE q003_bcs
     END FOR
    END FOREACH
    CLOSE q003_co
    ERROR ""
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'ass01,ass00,ass02,ass03,ass04,ass041,ass08,ass14,ass05,ass06,ass07')  #FUN-950048 拿掉ass15                                      
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830093 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_azi04                                                                                                   
    CALL cl_prt_cs3('gglq022','gglq022',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
