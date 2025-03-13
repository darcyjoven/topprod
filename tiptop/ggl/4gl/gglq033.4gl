# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglq033.4gl
# Descriptions...: 合併前科目各期餘額查詢
# Date & Author..: No.FUN-950048 09/05/25 By jan
# Modify.........: No.FUN-950111 09/06/01 By lutingting選aag02時還應考慮asa09 
# Modify.........: No.FUN-960010 09/06/04 By lutingting畫面新增asr18,asr19
# Modify.........: No.FUN-970045 09/07/21 By chenmoyan 取消余額欄位
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641_asg,s_aaz641_asg
# Modify.........: No.FUN-A80092 10/09/07 By chenmoyan 增加 下層記帳幣別借方 下層記帳幣別貸方 下層功能幣別借方 下層功能幣別貸方
# Modify.........: NO.FUN-AB0028 10/11/07 BY yiting 加入餘額顯示
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0006 
#模組變數(Module Variables)                   #FUN-BB0036
DEFINE
     tm  RECORD
       	wc  	STRING 
        END RECORD,
    g_aag  RECORD
            asr01		LIKE asr_file.asr01,
            asr00		LIKE asr_file.asr00,
            asr05		LIKE asr_file.asr05,
            asr06		LIKE asr_file.asr06,
            asr12		LIKE asr_file.asr12,  
            aag02		LIKE aag_file.aag02,
            asr02		LIKE asr_file.asr02,
            asr03		LIKE asr_file.asr03,
            asr04 	LIKE asr_file.asr04, 
            asr041	LIKE asr_file.asr041,
            aag06		LIKE aag_file.aag06
        END RECORD,
    g_asr DYNAMIC ARRAY OF RECORD
            seq     LIKE ze_file.ze03,     
            asr08   LIKE asr_file.asr08,
            asr09   LIKE asr_file.asr09,
            amt1    LIKE type_file.num20_6,   #FUN-AB0028
            asr10   LIKE asr_file.asr10,
            asr11   LIKE asr_file.asr11,
            asr13   LIKE asr_file.asr13,   #FUN-A80092
            asr14   LIKE asr_file.asr14,   #FUN-A80092
            amt2    LIKE type_file.num20_6,   #FUN-AB0028
            asr15   LIKE asr_file.asr15,   #FUN-A80092
            asr16   LIKE asr_file.asr16,   #FUN-A80092
            amt3    LIKE type_file.num20_6,   #FUN-AB0028
#           l_tot   LIKE asr_file.asr08,   #No.FUN-970045
            asr18   LIKE asr_file.asr18,   #FUN-960010 ADD
            asr19   LIKE asr_file.asr19    #FUN-960010 ADD
        END RECORD,
    g_bookno        LIKE asr_file.asr00,      # INPUT ARGUMENT - 1
    g_wc,g_sql  STRING,         #TQC-630166   #WHERE CONDITION      
    p_row,p_col LIKE type_file.num5,          
    g_rec_b     LIKE type_file.num5   	      #單身筆數        
 
DEFINE   g_cnt           LIKE type_file.num10    #INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  
DEFINE   g_msg           LIKE type_file.chr1000  
 
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10 
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_bookno1      LIKE aza_file.aza81                                                                 
DEFINE   g_bookno2      LIKE aza_file.aza82      
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   l_table        STRING,                                                          
         g_str          STRING                                                               
DEFINE g_dbs_asg03      LIKE type_file.chr21
DEFINE g_plant_asg03    LIKE type_file.chr21   #FUN-A30122 add
MAIN
       DEFINE
          l_sl		LIKE type_file.num5  
 
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
 
### *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                                                                                                       
    LET g_sql = "asr00.asr_file.asr00,",                                                                                       
                "asr01.asr_file.asr01,",
                "asr02.asr_file.asr02,",
                "asr03.asr_file.asr03,",
                "asr05.asr_file.asr05,",
                "asr06.asr_file.asr06,",
                "asr12.asr_file.asr12,",
                "asr07.asr_file.asr07,",
                "asr08.asr_file.asr08,",
                "asr09.asr_file.asr09,",
                "l_aag02.aag_file.aag02,",
                "l_aag06.aag_file.aag06,",
#               "l_tot.asr_file.asr08,",    #No.FUN-970045
                "asr18.asr_file.asr18,",    #FUN-960010 add
                "asr19.asr_file.asr19"      #FUN-960010 add
    LET l_table = cl_prt_temptable('gglq033',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,            #TQC-A40133 mark                                                                
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod                                                                        
                " VALUES(?, ?, ?, ?, ?, ?, ?,                                                              
                         ?, ?, ?, ?, ?, ? ,?)"     #No.FUN-970045                                                      
#                        ?, ?, ?, ?, ?, ? ,?,?)"   #FUN-960010 add ?,? #No.FUN-970045                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW q005_w AT p_row,p_col WITH FORM 'ggl/42f/gglq033'
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)
 
IF NOT cl_null(g_bookno) THEN CALL q005_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
 
    CALL q005_menu()
    CLOSE WINDOW q005_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q005_cs()
   DEFINE   l_cnt LIKE type_file.num5 
 
   CLEAR FORM #清除畫面
   CALL g_asr.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		 # Default condition
   CALL cl_set_head_visible("","YES")   
 
   INITIALIZE g_aag.* TO NULL   
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             asr01,asr00,asr02,asr03,asr04,asr041,asr05,asr06,asr12 
             
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asr01) #族群編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_atc"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO asr01
                    NEXT FIELD asr01
               WHEN INFIELD(asr05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_aag"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO asr05
               WHEN INFIELD(asr12) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_aag.asr12
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO asr12
                    NEXT FIELD asr12
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
   IF g_priv2='4' THEN                           #只能使用自己的資料
       LET tm.wc = tm.wc clipped," AND asruser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
       LET tm.wc = tm.wc clipped," AND asrgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
 
   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET tm.wc = tm.wc clipped," AND asrgrup IN ",cl_chk_tgrup_list()
   END IF
 
 
   LET g_sql=" SELECT DISTINCT asr01,asr02,asr03,asr04,asr041,", 
             "   asr05,asr06,asr12,asr00 ",
             "   FROM asr_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY asr01,asr02"  
   PREPARE q005_prepare FROM g_sql
   DECLARE q005_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q005_prepare
 
   #====>取合乎條件筆數
   LET g_sql=" SELECT UNIQUE asr01,asr02,asr03,asr04,asr041,", 
             "   asr05,asr06,asr12,asr00 ", 
             "   FROM asr_file ",
             "     WHERE ",tm.wc CLIPPED,
             "     INTO TEMP x "
   DROP TABLE x
   PREPARE q005_prepare_x FROM g_sql
   EXECUTE q005_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q005_prepare_cnt FROM g_sql
   DECLARE q005_count CURSOR FOR q005_prepare_cnt
END FUNCTION
 
FUNCTION q005_menu()
 
   WHILE TRUE
      CALL q005_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q005_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q005_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q005_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q005_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q005_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q005_count
       FETCH q005_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q005_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q005_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式  
    l_abso          LIKE type_file.num10       #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q005_cs INTO g_aag.asr01,g_aag.asr02,g_aag.asr03, 
                                             g_aag.asr04,g_aag.asr041,g_aag.asr05,
                                             g_aag.asr06,g_aag.asr12,g_aag.asr00
        WHEN 'P' FETCH PREVIOUS q005_cs INTO g_aag.asr01,g_aag.asr02,g_aag.asr03, 
                                             g_aag.asr04,g_aag.asr041,g_aag.asr05, 
                                             g_aag.asr06,g_aag.asr12,g_aag.asr00
        WHEN 'F' FETCH FIRST    q005_cs INTO g_aag.asr01,g_aag.asr02,g_aag.asr03, 
                                             g_aag.asr04,g_aag.asr041,g_aag.asr05, 
                                             g_aag.asr06,g_aag.asr12,g_aag.asr00
        WHEN 'L' FETCH LAST     q005_cs INTO g_aag.asr01,g_aag.asr02,g_aag.asr03,
                                             g_aag.asr04,g_aag.asr041,g_aag.asr05,
                                             g_aag.asr06,g_aag.asr12,g_aag.asr00
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
            FETCH ABSOLUTE g_jump q005_cs INTO g_aag.asr01,g_aag.asr02,g_aag.asr03,
                                           g_aag.asr04,g_aag.asr041,g_aag.asr05,g_aag.asr06,g_aag.asr12,g_aag.asr00
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.asr01,SQLCA.sqlcode,0)
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
    CALL s_get_bookno(g_aag.asr06)  RETURNING g_flag,g_bookno1,g_bookno2                                                           
    IF g_flag='1' THEN   #抓不到帳套                                                                                                
       CALL cl_err(g_aag.asr06,'aoo-081',1)                                                                                        
    END IF                                                                                                                          
    CALL q005_show()
END FUNCTION
 
FUNCTION q005_show()
   DISPLAY g_aag.asr00 TO asr00
   DISPLAY g_aag.asr01 TO asr01
   DISPLAY g_aag.asr02 TO asr02
   DISPLAY g_aag.asr03 TO asr03
   DISPLAY g_aag.asr04  TO asr04  
   DISPLAY g_aag.asr041 TO asr041
   DISPLAY g_aag.asr05 TO asr05
   DISPLAY g_aag.asr06 TO asr06
   DISPLAY g_aag.asr12 TO asr12 
   CALL q005_asr01('d')
   CALL q005_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q005_asr01(p_cmd)
    DEFINE
           p_cmd      LIKE type_file.chr1, 
           l_aag02    LIKE aag_file.aag02,
           l_aag06    LIKE aag_file.aag06,
           l_aagacti  LIKE aag_file.aagacti
    DEFINE l_asg03    LIKE asg_file.asg03 
    DEFINE l_asg04    LIKE asg_file.asg04         #FUN-950111 add 
    DEFINE l_asa09    LIKE asa_file.asa09         #FUN-950111 add 
 
    LET g_errno = ' '
    IF g_aag.asr05 IS NULL THEN
        LET l_aag02=NULL
    ELSE
    #FUN-A30122 --------------------------------mark start-------------------------------
    #   SELECT asg03,asg04 INTO l_asg03,l_asg04   #FUN-950111 add asg04    
    #     FROM asg_file
    #    WHERE asg01 = g_aag.asr02  
    #    
    #    LET g_plant_new = l_asg03      #營運中心
    #    CALL s_getdbs()
    #    LET g_dbs_asg03 = g_dbs_new    #所屬DB
    #    
    #    #FUN-950111--mod--str--
    #    IF cl_null(l_asg04) OR l_asg04 = 'N'   THEN #不使用tiptop                                                                                      
    #       LET g_dbs_asg03  = s_dbstring(g_dbs CLIPPED)                                                                               
    #       LET g_plant_new = g_plant   #FUN-A50102
    #    ELSE                                                                                                                       
    #       SELECT asa09 INTO l_asa09 FROM asa_file                                                                                 
    #        WHERE asa01 = g_aag.asr01   #族群                                                                                      
    #          AND asa02 = g_aag.asr02   #上層公司編號                                                                              
    #       IF l_asa09 = 'Y' THEN                                                                                                   
    #          SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = g_aag.asr02                                                    
    #          LET g_plant_new = l_asg03    #營運中心                                                                               
    #          CALL s_getdbs()                                                                                                      
    #          LET g_dbs_asg03 = g_dbs_new    #所屬DB                                                                                  
    #       ELSE                                                                                                                    
    #          LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)                                                                             
    #          LET g_plant_new = g_plant   #FUN-A50102
    #       END IF                                                                                                                  
    #    END IF
    #    #FUN-950111--mod--end 
 
    #   #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",   #FUN-A50102
    #    LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
    #                " WHERE aaz00 = '0'"
    #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
    #    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    #    PREPARE q005_pre FROM g_sql
    #    DECLARE q005_cur CURSOR FOR q005_pre
    #    OPEN q005_cur
    #    FETCH q005_cur INTO g_aag.asr00    #合併後帳別
    #FUN-A30122 -----------------------------------------------mark end---------------------------------
         CALL s_aaz641_asg(g_aag.asr01,g_aag.asr02) RETURNING g_plant_asg03              #FUN-A30122 add
         CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aag.asr00                          #FUN-A30122 add
         LET g_plant_new = g_plant_asg03                                                 #FUN-A30122 add  
        #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102 
         LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                     " WHERE aag01 = '",g_aag.asr05,"'",                
                     "   AND aagacti = 'Y' ",
                     "   AND aag00 = '",g_aag.asr00,"'"                
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE q005_pre_1 FROM g_sql
         DECLARE q005_cur_1 CURSOR FOR q005_pre_1
         OPEN q005_cur_1
         FETCH q005_cur_1 INTO l_aag02 
        
         IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
 
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
 
FUNCTION q005_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING,      
          l_n       LIKE type_file.num5   #No.FUN-970045
#         l_tot     LIKE asr_file.asr08   #No.FUN-970045
   DEFINE l_total1  LIKE ass_file.ass11        #FUN-AB0028
   DEFINE l_total2  LIKE ass_file.ass11        #FUN-AB0028
   DEFINE l_total3  LIKE ass_file.ass11        #FUN-AB0028

   LET l_total1 = 0    #FUN-AB0028
   LET l_total2 = 0    #FUN-AB0028
   LET l_total3 = 0    #FUN-AB0028
 
   LET l_sql =
#       "SELECT '',asr08, asr09, asr10, asr11,(asr08-asr09),asr18,asr19",   #FUN-960010 add asr18,asr19#No.FUN-970045
        #"SELECT '',asr08, asr09, asr10, asr11,asr13,asr14,asr15,asr16,asr18,asr19",                 #No.FUN-970045 #FUN-A80092 add asr13~asr16
        "SELECT '',asr08, asr09,(asr08-asr09), asr10, asr11,asr13,asr14,(asr13-asr14),asr15,asr16,(asr15-asr16),asr18,asr19",  #FUN-AB0028        
        " FROM  asr_file",
        " WHERE asr01 = '",g_aag.asr01,"' AND asr00='",g_aag.asr00,"' ",
        " AND asr02 = '",g_aag.asr02,"' AND asr03='",g_aag.asr03,"' ",
        " AND asr04 = '",g_aag.asr04,"' AND asr041='",g_aag.asr041,"' ",
        " AND asr05 = '",g_aag.asr05,"' AND asr07 = ?",
        " AND asr06 = ",g_aag.asr06," ", 
        " AND asr12 = '",g_aag.asr12,"' "
    PREPARE q005_pb FROM l_sql
    DECLARE q005_bcs                       #BODY CURSOR
        CURSOR FOR q005_pb
 
    FOR g_cnt = 1 TO g_asr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_asr[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 0
    IF g_aag.aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
#   LET l_tot = 0                                #No.FUN-970045
    FOR g_cnt = 1 TO 14
        LET g_i = g_cnt - 1
        OPEN q005_bcs USING g_i
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
        FETCH q005_bcs INTO g_asr[g_cnt].*
           IF SQLCA.sqlcode = 100 THEN
              LET g_asr[g_cnt].asr08 = 0
              LET g_asr[g_cnt].asr09 = 0
              LET g_asr[g_cnt].asr10 = 0
              LET g_asr[g_cnt].asr11 = 0
              LET g_asr[g_cnt].asr13 = 0    #FUN-A80092 add
              LET g_asr[g_cnt].asr14 = 0    #FUN-A80092 add
              LET g_asr[g_cnt].asr15 = 0    #FUN-A80092 add
              LET g_asr[g_cnt].asr16 = 0    #FUN-A80092 add
#             LET g_asr[g_cnt].l_tot = 0    #No.FUN-970045
              LET g_asr[g_cnt].asr18 = 0    #FUN-960010 add
              LET g_asr[g_cnt].asr19 = 0    #FUN-960010 add 
              LET g_asr[g_cnt].amt1 = 0     #FUN-AB0028
              LET g_asr[g_cnt].amt2 = 0     #FUN-AB0028
              LET g_asr[g_cnt].amt3 = 0     #FUN-AB0028
           END IF
           IF g_i = 0 THEN
                CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
                LET g_asr[g_cnt].seq = g_msg clipped
           ELSE LET g_asr[g_cnt].seq = g_i
           END IF
          #LET g_asr[g_cnt].l_tot = l_tot +
          #  (g_asr[g_cnt].asr08 - g_asr[g_cnt].asr09) * l_n
          #LET l_tot = g_asr[g_cnt].l_tot
#          LET l_tot = l_tot + g_asr[g_cnt].l_tot      #No.FUN-970045
#          LET g_asr[g_cnt].l_tot = l_tot              #No.FUN-970045
        IF cl_null(g_asr[g_cnt].amt1) THEN LET g_asr[g_cnt].amt1 = 0  END IF  #FUN-AB0028
        IF cl_null(g_asr[g_cnt].amt2) THEN LET g_asr[g_cnt].amt2 = 0  END IF  #FUN-AB0028
        IF cl_null(g_asr[g_cnt].amt3) THEN LET g_asr[g_cnt].amt3 = 0  END IF  #FUN-AB0028
    END FOR
    LET g_rec_b=g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asr TO s_asr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY 
 
 
      ON ACTION previous
         CALL q005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY 
 
 
      ON ACTION jump
         CALL q005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	       ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL q005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY 
 
 
      ON ACTION last
         CALL q005_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	       ACCEPT DISPLAY 
 
 
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
      LET INT_FLAG=FALSE 		
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
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q005_out()
    DEFINE
        l_i             LIKE type_file.num5, 
        l_name          LIKE type_file.chr20,
        l_asr  RECORD
                asr00	LIKE asr_file.asr00,
                asr01	LIKE asr_file.asr01,
                asr02	LIKE asr_file.asr02,
                asr03	LIKE asr_file.asr03,
                asr04 	LIKE asr_file.asr04,
                asr041	LIKE asr_file.asr041,
                asr05	LIKE asr_file.asr05,
                asr06	LIKE asr_file.asr06,
                asr12	LIKE asr_file.asr12, 
                asr07	LIKE asr_file.asr07,
                asr08   LIKE asr_file.asr08,
                asr09   LIKE asr_file.asr09,
                asr10   LIKE asr_file.asr10,
                asr11   LIKE asr_file.asr11,
                asr18   LIKE asr_file.asr18,   #FUN-960010 add
                asr19   LIKE asr_file.asr19    #FUN-960010 add
        END RECORD,
        l_chr           LIKE type_file.chr1 
DEFINE  l_aag02         LIKE aag_file.aag02                                                                            
DEFINE  l_aag06         LIKE aag_file.aag06 
DEFINE  l_asg03         LIKE asg_file.asg03   #FUN-950111
DEFINE  l_asg04         LIKE asg_file.asg04   #FUN-950111
DEFINE  l_asa09         LIKE asa_file.asa09   #FUN-950111
    IF tm.wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
			AND aaf02 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglq033'
    LET g_sql="SELECT asr00,asr01,asr02,asr03,asr04,asr041,", 
              " asr05,asr06,asr12,asr07,asr08,",
              " asr09,asr10,asr11,asr18,asr19 FROM asr_file,aag_file ",   # 組合出 SQL 指令   #FUN-960010 add asr18,asr19
              " WHERE aag01=asr05 AND aag00=asr00 ",
              "   AND ",tm.wc CLIPPED, 
              " ORDER BY asr00,asr01,asr02,asr05,asr06,asr07 " 
    PREPARE q005_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q005_co CURSOR FOR q005_p1
 
   
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     #------------------------------ CR (2) ------------------------------# 
 
    FOREACH q005_co INTO l_asr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF            
                                           
#FUN-A30122 ------------------mark start----------------------------
#       SELECT asg03,asg04 INTO l_asg03,l_asg04  
#         FROM asg_file
#        WHERE asg01 = l_asr.asr02   
#        
#        #FUN-950111--mod--str--
#        LET g_plant_new = l_asg03      #營運中心                                                                                   
#        CALL s_getdbs()                                                                                                            
#        LET g_dbs_asg03 = g_dbs_new    #所屬DB 
#
#        IF l_asg04 = 'N'   THEN #不使用tiptop                                                                                      
#           LET g_dbs_asg03  = s_dbstring(g_dbs CLIPPED)                                                                               
#           LET g_plant_new = g_plant   #FUN-A50102
#        ELSE                                                                                                                       
#           SELECT asa09 INTO l_asa09 FROM asa_file                                                                                 
#            WHERE asa01 = l_asr.asr01   #族群                                                                                      
#              AND asa02 = l_asr.asr02   #上層公司編號                                                                              
#           IF l_asa09 = 'Y' THEN                                                                                                   
#              SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = l_asr.asr02                                                    
#              LET g_plant_new = l_asg03    #營運中心                                                                               
#              CALL s_getdbs()                                                                                                      
#              LET g_dbs_asg03 = g_dbs_new    #所屬DB                                                                                  
#           ELSE                                                                                                                    
#              LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)                                                                             
#              LET g_plant_new = g_plant   #FUN-A50102
#           END IF                                                                                                                  
#        END IF
#      
#       #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A50102                                                                
#        LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
#                    " WHERE aaz00 = '0'"                                                                                           
#        CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#        PREPARE q005_pre_3 FROM g_sql                                                                                                
#        DECLARE q005_cur_3 CURSOR FOR q005_pre_3                                                                                       
#        OPEN q005_cur_3                                                                                                              
#        FETCH q005_cur_3 INTO l_asr.asr00    #合并後帳別                                                                             
#        IF cl_null(l_asr.asr00) THEN                                                                                               
#            CALL cl_err(l_asr.asr02,'agl-601',1)                                                                                   
#        END IF 
#FUN-A30122 ----------------------------------mark end--------------------------------------------------
         CALL s_aaz641_asg(l_asr.asr01,l_asr.asr02) RETURNING g_plant_asg03             #FUN-A30122 add
         CALL s_get_aaz641_asg(g_plant_asg03) RETURNING l_asr.asr00                         #FUN-A30122 add
         LET g_plant_new = g_plant_asg03                                                #FUN-A30122 add      
 
        #LET g_sql = "SELECT aag02,aag06 FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
         LET g_sql = "SELECT aag02,aag06 FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                     " WHERE aag01 = '",l_asr.asr05,"'",                
                     "   AND aagacti = 'Y' ",
                     "   AND aag00 = '",l_asr.asr00,"'"                
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE q005_pre_2 FROM g_sql
         DECLARE q005_cur_2 CURSOR FOR q005_pre_2
         OPEN q005_cur_2
         FETCH q005_cur_2 INTO l_aag02,l_aag06 
        
         IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
      #SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file                                                                   
      #WHERE aag01=l_asr.asr05 AND aagacti='Y' AND aag00=l_asr.asr00  
      #FUN-950111--mod--end
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##                                                   
         EXECUTE insert_prep USING                                                                                                                                                                                   
                 l_asr.asr00,l_asr.asr01,l_asr.asr02,l_asr.asr03,                                                                         
                 l_asr.asr05,l_asr.asr06,l_asr.asr12,l_asr.asr07,l_asr.asr08,                                                                     
                 l_asr.asr09,l_aag02,l_aag06,l_asr.asr18,l_asr.asr19       #No.FUN-970045                                                                           
#                l_asr.asr09,l_aag02,l_aag06,'0',l_asr.asr18,l_asr.asr19   #FUN-960010 add asr18,asr19 #No.FUN-970045                                                                           
     #------------------------------ CR (3) ------------------------------#
    END FOREACH
 
    CLOSE q005_co
    ERROR ""                                                                                                           
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'asr01,asr00,asr02,asr03,asr04,asr041,asr05,asr06,asr12')                                                                          
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                                                                                                                                      
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##                                                                   
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_azi05                                                                                                   
    CALL cl_prt_cs3('gglq033','gglq033',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
END FUNCTION                                                                                                                        
#FUN-950048  
