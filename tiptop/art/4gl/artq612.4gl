# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artq612.4gl
# Descriptions...: 客戶未交訂單查詢
# Date & Author..: FUN-870007 09/08/25 By Zhangyajun 
# Memo...........: 由axmq612客制而來
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-AB0025 10/12/20 By chenying Sybas調整
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds 
 
GLOBALS "../../config/top.global" 
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_occ   RECORD
			occ01	    LIKE occ_file.occ01,
			occ02	    LIKE occ_file.occ02,
			link 	    LIKE aab_file.aab01    #No.FUN-680137 VARCHAR(24)
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            oea01   LIKE oea_file.oea01,
            oea04   LIKE oea_file.oea04,
            oeb04   LIKE oeb_file.oeb04,
            oeb092  LIKE oeb_file.oeb092,
            oeb06   LIKE oeb_file.oeb06,
            oeb12   LIKE oeb_file.oeb12,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb23   LIKE oeb_file.oeb23,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            acc_q   LIKE ogb_file.ogb12,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb24   LIKE oeb_file.oeb24,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb25   LIKE oeb_file.oeb25,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            unqty   LIKE oeb_file.oeb12,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb16   LIKE oeb_file.oeb16,
            oeaplant      LIKE oea_file.oeaplant, 
            oeaplant_desc LIKE azp_file.azp02,  
            oea02       LIKE oea_file.oea02  
        END RECORD,
	g_occ261		LIKE occ_file.occ261,
	g_occ29			LIKE occ_file.occ29,
    g_argv1         LIKE occ_file.occ01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_sql          STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE   g_chk_oeaplant LIKE type_file.chr1
DEFINE   g_sql1 STRING
DEFINE   g_sql2 STRING
DEFINE   g_sql3 STRING
DEFINE   g_dbs LIKE azp_file.azp03
DEFINE   g_occ930 LIKE occ_file.occ930
DEFINE   g_chk_auth STRING
MAIN
DEFINE          l_sl		LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN   
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag=1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q612_w AT p_row,p_col
         WITH FORM "art/42f/artq612"   
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
IF NOT cl_null(g_argv1) THEN CALL q612_q() END IF
    CALL q612_menu()
    CLOSE WINDOW q612_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q612_cs()
   DEFINE   l_zxy03 LIKE zxy_file.zxy03   #TQC-A10070 ADD
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "occ01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oeb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B003
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON occ01,occ02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
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
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup') #FUN-980030
           IF INT_FLAG THEN RETURN END IF
           CALL q612_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql1 = NULL                                                                                                       
   LET g_sql2 = NULL                                                                                                        
   LET g_sql3 = "SELECT DISTINCT zxy03 FROM azp_file,zxy_file ",                                                           
                " WHERE zxy01 = '",g_user,"' "                                                                             
   PREPARE pre_sel_azp FROM g_sql3                                                                                          
   DECLARE q612_DB_cs CURSOR FOR pre_sel_azp                                                                           
   FOREACH q612_DB_cs INTO l_zxy03                                                                                         
      IF SQLCA.sqlcode THEN                                                                                                
         CALL cl_err('foreach:q612_DB_cs',SQLCA.sqlcode,1)                                                                 
         LET g_success = 'N'                                                                                               
         EXIT FOREACH                                                                                                      
      END IF   
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
     #FUN-A50102 ---mark---str---  
     #TQC-A10070 ADD--------------
      #LET g_plant_new = l_zxy03
      #CALL s_gettrandbs()
      #LET g_dbs = g_dbs_tra
     #TQC-A10070 ADD--------------
     #FUN-A50102 ---mark---end---                               
#     LET g_sql=" SELECT UNIQUE occ01 ",          #TQC-AB0025 mark                                                  
      LET g_sql=" SELECT DISTINCT occ01 ",          #TQC-AB0025 add                                                    
                   #" FROM ",s_dbstring(g_dbs),"occ_file,", #FUN-A50102
                   #         s_dbstring(g_dbs),"oea_file,",s_dbstring(g_dbs),"oeb_file ", #FUN-A50102   
                   " FROM ",cl_get_target_table(l_zxy03, 'occ_file'),",",                                              #FUN-A50102
                            cl_get_target_table(l_zxy03, 'oea_file'),",",cl_get_target_table(l_zxy03, 'oeb_file'), #FUN-A50102         
                   " WHERE occ01=oea03 AND oea01=oeb01 AND oeaplant=oebplant ",
                   " AND ",tm.wc CLIPPED,
                   " AND ",tm.wc2 CLIPPED,
                   " AND oeb12>(oeb24-oeb25)",                                                                 
                   " AND oeb70='N'",                                                                                               
                   " AND oeaconf = 'Y' " 
      IF g_chk_oeaplant THEN
         LET g_sql = g_sql," AND oeaplant IN ",g_chk_auth
      END IF
      IF g_sql1 IS NULL THEN 
         LET g_sql1=g_sql
      ELSE
         LET g_sql1=g_sql1," UNION  ",g_sql 
      END IF
   END FOREACH
 
   PREPARE q612_prepare FROM g_sql1
   DECLARE q612_cs                         #SCROLL CURSOR
    SCROLL CURSOR FOR q612_prepare
 
  #取合乎條件筆數
  #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql2=" SELECT COUNT(*) FROM  ","(",g_sql1,")"
 
   PREPARE q612_pp  FROM g_sql2
   DECLARE q612_cnt   CURSOR FOR q612_pp
END FUNCTION
 
FUNCTION q612_b_askkey()
 
   LET g_chk_oeaplant = TRUE
   CONSTRUCT tm.wc2 ON oea01,oea04,oeb04,oeb092,oeb06,oeb12,oeb23,
                       oeb24,oeb25,oeb15,oeb16,oeaplant,oea02     
                  FROM s_oeb[1].oea01, s_oeb[1].oea04,s_oeb[1].oeb04,
                       s_oeb[1].oeb092,s_oeb[1].oeb06,s_oeb[1].oeb12,
                       s_oeb[1].oeb23, s_oeb[1].oeb24,s_oeb[1].oeb25,
                       s_oeb[1].oeb15, s_oeb[1].oeb16,s_oeb[1].oeaplant, 
                       s_oeb[1].oea02 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      AFTER FIELD oeaplant
            IF get_fldbuf(oeaplant) IS NOT NULL THEN
               LET g_chk_oeaplant = FALSE
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
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oeaplant)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeaplant
               NEXT FIELD oeaplant
         END CASE
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF g_chk_oeaplant THEN
      CALL q612_chk_auth()
   END IF
END FUNCTION
 
FUNCTION q612_menu()
 
   WHILE TRUE
      CALL q612_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q612_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q612_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q612_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q612_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q612_cnt
        FETCH q612_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q612_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q612_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
    CASE p_flag
        WHEN 'N' FETCH NEXT     q612_cs INTO g_occ.occ01
        WHEN 'P' FETCH PREVIOUS q612_cs INTO g_occ.occ01
        WHEN 'F' FETCH FIRST    q612_cs INTO g_occ.occ01
        WHEN 'L' FETCH LAST     q612_cs INTO g_occ.occ01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q612_cs INTO g_occ.occ01
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
     WHERE occ01=g_occ.occ01
    
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)     #No.FUN-660167
        CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660167
    #    RETURN
    END IF
 
    CALL q612_show()
END FUNCTION
 
FUNCTION q612_show()
   LET g_occ.link = g_occ261 CLIPPED,'-',g_occ29 CLIPPED
   IF SQLCA.SQLCODE THEN LET g_occ.occ02=' ' END IF
   DISPLAY BY NAME g_occ.*
   CALL q612_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q612_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oeb03   LIKE oeb_file.oeb03  #No.FUN-610020
   DEFINE l_zxy03   LIKE zxy_file.zxy03   #TQC-A10070 ADD 
   DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
  CALL g_oeb.clear()
  LET g_sql1=''
  LET g_sql = "SELECT DISTINCT zxy03 FROM azp_file,zxy_file ",                                                            
              " WHERE zxy01 = '",g_user,"' "                                                                              
   PREPARE pre_sel_azp1 FROM g_sql
   DECLARE q612_DB_cs1 CURSOR FOR pre_sel_azp1
   FOREACH q612_DB_cs1 INTO l_zxy03 
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
    #FUN-A50102 ---mark---str---
     #TQC-A10070 ADD--------------------
      #LET g_plant_new = l_zxy03
      #CALL s_gettrandbs()
      #LET g_dbs = g_dbs_tra
     #TQC-A10070 ADD--------------------
    #FUN-A50102 ---mark---end---
      LET l_sql =
        "SELECT oea01,oea04,oeb04,oeb092,oeb06,oeb12,oeb23,0,oeb24,oeb25,",
        "       0,oeb15,oeb16,oeaplant,'',oea02,oeb03 ",   
        #"  FROM ",s_dbstring(g_dbs),"oea_file,",s_dbstring(g_dbs),"oeb_file ",#FUN-A50102
         "  FROM ",cl_get_target_table(l_zxy03, 'oea_file'),",",cl_get_target_table(l_zxy03, 'oeb_file'),#FUN-A50102
        " WHERE oea01 =oeb01 AND oeb12>(oeb24-oeb25) AND oea03 = '",
	      g_occ.occ01,"'"," AND ",tm.wc2 CLIPPED,
        "   AND oeb70='N'",
        "   AND oeaconf = 'Y' " 
        IF g_chk_oeaplant THEN
         LET l_sql = l_sql," AND oeaplant IN ",g_chk_auth
        END IF
        IF g_sql1 IS NULL THEN
           LET g_sql1=l_sql
        ELSE
           LET g_sql1=g_sql1," UNION  ",l_sql
        END IF
   END FOREACH
       PREPARE q612_pb FROM g_sql1
       DECLARE q612_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q612_pb
       LET g_cnt = 1
       FOREACH q612_bcs INTO g_oeb[g_cnt].*,l_oeb03  #No.FUN-610020
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
           END IF
           IF g_oeb[g_cnt].oeb12 IS NULL THEN LET g_oeb[g_cnt].oeb12 = 0 END IF
           IF g_oeb[g_cnt].oeb23 IS NULL THEN LET g_oeb[g_cnt].oeb23 = 0 END IF
           IF g_oeb[g_cnt].oeb24 IS NULL THEN LET g_oeb[g_cnt].oeb24 = 0 END IF
           IF g_oeb[g_cnt].oeb25 IS NULL THEN LET g_oeb[g_cnt].oeb25 = 0 END IF
           LET g_oeb[g_cnt].unqty = g_oeb[g_cnt].oeb12 -
                                    g_oeb[g_cnt].oeb24 + g_oeb[g_cnt].oeb25
          #No.FUN-610020  --Begin
          LET g_sql=" SELECT SUM(ogb12) ",
                    #"   FROM ",s_dbstring(g_dbs),"ogb_file,",s_dbstring(g_dbs),"oga_file,", #FUN-A50102
                    #           s_dbstring(g_dbs),"oea_file,",s_dbstring(g_dbs),"oeb_file ",  #FUN-A50102
                    "   FROM ",cl_get_target_table(l_zxy03, 'ogb_file'),",",cl_get_target_table(l_zxy03, 'oga_file'),",",  #FUN-A50102
                               cl_get_target_table(l_zxy03, 'oea_file'),",",cl_get_target_table(l_zxy03, 'oeb_file'),  #FUN-A50102           
                    "  WHERE ogb31 = ? AND ogb32 = ? ",
                    "    AND ogb01 = oga01 ",
                    "    AND oeb01 = oea01 ",
                    "    AND oeb01 = ogb31 AND oeb03 = ogb32 ",
                    "    AND oea65 = 'Y' ",
                    "    AND ogaconf = 'Y' AND ogapost = 'Y' ",
                    "    AND oga09 = '8'   AND oga65 = 'Y' " 
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
           CALL cl_parse_qry_sql(g_sql, l_zxy03) RETURNING g_sql    #FUN-A50102         
           PREPARE sum_ogb12_pre FROM g_sql
           EXECUTE sum_ogb12_pre INTO g_oeb[g_cnt].acc_q USING g_oeb[g_cnt].oea01,l_oeb03
           IF cl_null(g_oeb[g_cnt].acc_q) THEN LET g_oeb[g_cnt].acc_q = 0 END IF
           SELECT azp02 INTO g_oeb[g_cnt].oeaplant_desc FROM azp_file
            WHERE azp01 = g_oeb[g_cnt].oeaplant 
           LET g_cnt = g_cnt + 1
         # genero shell add g_max_rec check START
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
        # genero shell add g_max_rec check END
        END FOREACH
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q612_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q612_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q612_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q612_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q612_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q612_fetch('L')
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
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
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
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q612_chk_auth()
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03  LIKE azp_file.azp03      #TQC-B90175 add 
      LET g_chk_auth = ''
      DECLARE q611_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q611_zxy_cs INTO l_zxy03
#TQC-B90175 add START------------------------------
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
      IF NOT cl_chk_schema_has_built(l_azp03) THEN
         CONTINUE FOREACH
      END IF
#TQC-B90175 add END--------------------------------
        IF g_chk_auth IS NULL THEN
           LET g_chk_auth = "'",l_zxy03,"'"
        ELSE
           LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
        END IF
      END FOREACH
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
END FUNCTION
#No.FUN-870007
