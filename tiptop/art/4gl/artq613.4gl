# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: artq613
# Descriptions...: 訂單出貨明細查詢
# Date & Author..: FUN-870007 09/08/25 By Zhangyajun
# Memo...........: 由axmq613客制而來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.TQC-A10035 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
                wc      string,  #FUN-870100                                         
                wc2     string
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,
            oea02   LIKE oea_file.oea02,
            oea03   LIKE oea_file.oea03,
            oea04   LIKE oea_file.oea04,
            oea032  LIKE oea_file.oea032,
            occ02   LIKE occ_file.occ02,
            oea14   LIKE oea_file.oea14,
            oea15   LIKE oea_file.oea15,
            oeaconf LIKE oea_file.oeaconf,
            oeahold LIKE oea_file.oeahold,
            oeaplant LIKE oea_file.oeaplant,
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb092  LIKE oeb_file.oeb092,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            #FUN-570175  --begin
            oeb913  LIKE oeb_file.oeb913,
            oeb915  LIKE oeb_file.oeb915,
            acd_q2  LIKE ogb_file.ogb12, #No.FUN-610020
            oeb910  LIKE oeb_file.oeb910,
            oeb912  LIKE oeb_file.oeb912,
            acd_q1  LIKE ogb_file.ogb12, #No.FUN-610020
            #FUN-570175  --end
            acd_q   LIKE ogb_file.ogb12,   #MOD-760017 modify type_file.num10, #No.FUN-610020  #No.FUN-680137 INTEGER
            oeb24   LIKE oeb_file.oeb24,   #MOD-760017 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb25   LIKE oeb_file.oeb25,   #MOD-760017 modify type_file.num10,         #No.FUN-680137 INTEGER
            unqty   LIKE oeb_file.oeb24,   #MOD-760017 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb70   LIKE oeb_file.oeb70,
            oeb06   LIKE oeb_file.oeb06,
           #oeb08   LIKE oeb_file.oeb08, #TQC-5A0109
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091,
            oeb16   LIKE oeb_file.oeb16
        END RECORD,
    g_oga DYNAMIC ARRAY OF RECORD
            oga02   LIKE oga_file.oga02,
            ogb01   LIKE ogb_file.ogb01,
            ogb03   LIKE ogb_file.ogb03,
            oga10   LIKE oga_file.oga10,
            acc_q   LIKE ogb_file.ogb12, #No.FUN-610020
            ogb12   LIKE ogb_file.ogb12,
            #FUN-570175  --begin
            ogb913  LIKE ogb_file.ogb913,
            ogb915  LIKE ogb_file.ogb915,
            acc_q2  LIKE ogb_file.ogb12, #No.FUN-610020
            ogb910  LIKE ogb_file.ogb910,
            ogb912  LIKE ogb_file.ogb912,
            acc_q1  LIKE ogb_file.ogb12, #No.FUN-610020
            #FUN-570175  --end
            ogb63   LIKE ogb_file.ogb63,
            ogb08   LIKE ogb_file.ogb08,
            ogb09   LIKE ogb_file.ogb09,
            ogb091  LIKE ogb_file.ogb091,
            ogb092  LIKE ogb_file.ogb092
        END RECORD,
    g_argv1         LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)
    g_argv2         LIKE oeb_file.oeb03,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next #No.FUN-680137 SMALLINT
     g_sql          STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE   g_sql1          STRING                
DEFINE   g_sql2          STRING             
DEFINE   g_sql3          STRING            
DEFINE   g_dbs LIKE azp_file.azp03
DEFINE g_chk_oeaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING
 
MAIN
     DEFINE     l_sl  LIKE type_file.num5          #No.FUN-680137 SMALLINT 
 
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
    LET g_argv1      = ARG_VAL(1)        #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)        #參數值(2)
    LET g_query_flag=1
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q613_w AT p_row,p_col
        WITH FORM "art/42f/artq613"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q613_def_form()
IF NOT cl_null(g_argv1) THEN CALL q613_q() END IF
    CALL q613_menu()
    CLOSE WINDOW q613_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q613_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE   l_zxy03 LIKE zxy_file.zxy03        #TQC-A10070 ADD
   DEFINE   l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
           IF NOT cl_null(g_argv2) AND g_argv2!=0 THEN
              LET tm.wc=tm.wc CLIPPED," AND oeb03=",g_argv2
           END IF
	   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
           CALL g_oga.clear()
           LET g_chk_oeaplant = TRUE
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
           INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON
                     oea01,oea02,oea03,oea032,oea04,
                     oea14,oea15,oeahold,oeaplant,oeaconf,oeb70,  
                     oeb03,oeb04,oeb06,oeb05,oeb12,oeb15,
                     oeb913,oeb915,oeb910,oeb912, #FUN-570175
                     oeb09,oeb091,oeb092, #TQC-5A0109
                     oeb16,oeb24,oeb25
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          AFTER FIELD oeaplant
            IF get_fldbuf(oeaplant) IS NOT NULL THEN
               LET g_chk_oeaplant = FALSE
            END IF
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(oea03) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
             WHEN INFIELD(oea04) #送貨客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04
             WHEN INFIELD(oea14) #人員   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea14
                  NEXT FIELD oea14
              WHEN INFIELD(oea15) #部門   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea15
                  NEXT FIELD oea15
              WHEN INFIELD(oeaplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azp"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeaplant
                  NEXT FIELD oeaplant
              WHEN INFIELD(oeb04) #產品編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb04
                  NEXT FIELD oeb04
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
          #CALL q613_b_askkey()   #No.MOD-5A0131
           IF INT_FLAG THEN RETURN END IF
   END IF
   IF g_chk_oeaplant THEN
      CALL q613_chk_auth()
   END IF
   MESSAGE ' WAIT '
   LET g_sql1 = NULL  
   LET g_sql2 = NULL 
   LET g_sql3 = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
   PREPARE pre_sel_azp FROM g_sql3
   DECLARE q613_DB_cs CURSOR FOR pre_sel_azp
   FOREACH q613_DB_cs INTO l_zxy03 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:q613_DB_cs',SQLCA.sqlcode,1)
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
     #TQC-A10070 ADD-------------
      #LET g_plant_new = l_zxy03
      #CALL s_gettrandbs()
      #LET g_dbs = g_dbs_tra
     #TQC-A10070 ADD------------- 
     #FUN-A50102 ---mark---end---
      LET g_sql=" SELECT oea01,oeb03,oeaplant ",
                #"   FROM ",s_dbstring(g_dbs),"oea_file,",s_dbstring(g_dbs),"oeb_file ", #FUN-A50102
                 "   FROM ",cl_get_target_table(l_zxy03, 'oea_file'),",",cl_get_target_table(l_zxy03, 'oeb_file'), #FUN-A50102
                "  WHERE oea01=oeb01 AND ",tm.wc CLIPPED," AND oeaplant='",l_zxy03,"' " ,
                "    AND oeaconf != 'X' "
      IF g_chk_oeaplant THEN
          LET g_sql = g_sql," AND oeaplant IN ",g_chk_auth
      END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_sql = g_sql CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
      #End:FUN-980030
 
      IF g_sql1 IS NULL  THEN
         LET g_sql1 = g_sql
      ELSE
         LET g_sql = g_sql1," UNION ALL ",g_sql
         LET g_sql1 = g_sql
      END IF
   END FOREACH
 
   LET g_sql=g_sql CLIPPED," ORDER BY oea01,oeb03"
 
   PREPARE q613_prepare FROM g_sql
   DECLARE q613_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q613_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
 
   LET g_sql2 = "SELECT COUNT(*) FROM ","(",g_sql1,")"
   PREPARE q613_pp FROM g_sql2
   DECLARE q613_cnt   CURSOR FOR q613_pp
 
END FUNCTION
 
FUNCTION q613_b_askkey()
   #FUN-570175  --begin
   CONSTRUCT tm.wc2 ON oga02,ogb01,ogb03,oga10,ogb12,ogb913,ogb915,ogb910,
                       ogb912,ogb63,ogb08,ogb09,ogb091,ogb092
                  FROM s_oga[1].oga02,s_oga[1].ogb01,s_oga[1].ogb03,
                       s_oga[1].oga10,s_oga[1].ogb12,s_oga[1].ogb913,
                       s_oga[1].ogb915,s_oga[1].ogb910,s_oga[1].ogb912,
                       s_oga[1].ogb63,s_oga[1].ogb08,s_oga[1].ogb09,
                       s_oga[1].ogb091,s_oga[1].ogb092
   #FUN-570175  --end
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
 
FUNCTION q613_menu()
 
   WHILE TRUE
      CALL q613_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q613_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oga),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q613_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q613_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q613_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q613_cnt
        FETCH q613_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q613_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q613_fetch(p_flag)
DEFINE l_dbs     LIKE tqb_file.tqb05     #FUN-870100
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q613_cs INTO g_oea.oea01,
                                            g_oea.oeb03,g_oea.oeaplant
       WHEN 'P' FETCH PREVIOUS q613_cs INTO g_oea.oea01,
                                            g_oea.oeb03,g_oea.oeaplant
       WHEN 'F' FETCH FIRST    q613_cs INTO g_oea.oea01,
                                            g_oea.oeb03,g_oea.oeaplant
       WHEN 'L' FETCH LAST     q613_cs INTO g_oea.oea01,
                                            g_oea.oeb03,g_oea.oeaplant
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q613_cs INTO g_oea.oea01,g_oea.oeb03,g_oea.oeaplant
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
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
 
  #TQC-A10070 MARK AND ADD -----------------------------------
   #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_oea.oeaplant 
  #FUN-A50102 ---mark---str--- 
    #LET g_plant_new = g_oea.oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra
  #FUN-A50102 ---mark---end---
  #TQC-A10070 MARK AND ADD -----------------------------------
    LET g_sql = " SELECT DISTINCT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold,oeaplant, ",  #No.TQC-A10035
                "        oeb03,oeb04,oeb092,oeb05,oeb12,oeb913,oeb915,0, ",
                "        oeb910,oeb912,0,0,oeb24,oeb25,(oeb12-oeb24+oeb25-oeb26), ",
                "        oeb15,oeb70,oeb06,oeb09,oeb091,oeb16 ",
                #"   FROM ",s_dbstring(l_dbs),"oea_file,",s_dbstring(l_dbs),"oeb_file ", #FUN-A50102
                 "   FROM ",cl_get_target_table(g_oea.oeaplant, 'oea_file'),",",cl_get_target_table(g_oea.oeaplant, 'oeb_file'), #FUN-A50102
                "  WHERE oea01= '",g_oea.oea01,"' ",
                "    AND oeb03= '",g_oea.oeb03,"' ",
                "    AND oea01=oeb01 ",
                "    AND oeaplant = '",g_oea.oeaplant,"' " 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea.oeaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q613_db_prepare FROM g_sql
    EXECUTE q613_db_prepare INTO g_oea.*
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oea_file,oeb_file",g_oea.oea01,g_oea.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
    #No.FUN-610020  --Begin
    SELECT SUM(ogb12),SUM(ogb915),SUM(ogb912)
      INTO g_oea.acd_q,g_oea.acd_q2,g_oea.acd_q1
      FROM ogb_file,oga_file,oea_file,oeb_file
     WHERE ogb31 = g_oea.oea01 AND ogb32 = g_oea.oeb03
       AND ogb01 = oga01
       AND oeb01 = oea01
       AND oeb01 = ogb31 AND oeb03 = ogb32
       AND oea65 = 'Y'
       AND ogaconf = 'Y' AND ogapost = 'Y'
       AND oga09 = '8'  
    IF cl_null(g_oea.acd_q2) THEN LET g_oea.acd_q2 = 0 END IF
    IF cl_null(g_oea.acd_q1) THEN LET g_oea.acd_q1 = 0 END IF
    IF cl_null(g_oea.acd_q ) THEN LET g_oea.acd_q  = 0 END IF
    IF cl_null(g_oea.oeb910) THEN LET g_oea.acd_q1 = NULL END IF
    IF cl_null(g_oea.oeb913) THEN LET g_oea.acd_q2 = NULL END IF
    #No.FUN-610020  --End
 
    CALL q613_show()
END FUNCTION
 
FUNCTION q613_show()
DEFINE l_azp02 LIKE azp_file.azp02
 
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO oeaconf
       DISPLAY '!' TO oeb70
   END IF
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_oea.oeaplant
   DISPLAY l_azp02 TO oeaplant_desc
   CALL q613_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q613_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oga09   LIKE oga_file.oga09  #No.FUN-610020
 
#TQC-A10070 MARK&ADD--------------------------------------
  #SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_oea.oeaplant 
  #FUN-A50102 ---mark---str--- 
   #LET g_plant_new = g_oea.oeaplant
   #CALL s_gettrandbs()
   #LET g_dbs = g_dbs_tra
  #FUN-A50102 ---mark---end--- 
#TQC-A10070 MARK&ADD--------------------------------------

   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT DISTINCT oga02,ogb01,ogb03,oga10,0,ogb12,ogb913,ogb915,0,ogb910,", #No.FUN-610020
        "       ogb912,0,(ogb63+ogb64),ogb08,ogb09,ogb091,ogb092,oga09 ",   #No.FUN-610020
        #"  FROM ",s_dbstring(g_dbs),"oga_file,",s_dbstring(g_dbs),"ogb_file ", #FUN-A50102
         "  FROM ",cl_get_target_table(g_oea.oeaplant, 'oga_file'),",",cl_get_target_table(g_oea.oeaplant, 'ogb_file'), #FUN-A50102
        " WHERE ogb31='",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND ogb32=",g_oea.oeb03,
        "   AND oga01=ogb01 ",
        "   AND oga09 IN ('2','4','6') ",  #No.FUN-610020
        "   AND ogapost='Y'",
        " ORDER BY oga02"   #No.FUN-610020 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea.oeaplant) RETURNING g_sql  #FUN-A50102    
    PREPARE q613_pb FROM l_sql
    DECLARE q613_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q613_pb
    CALL g_oga.clear()
    LET g_cnt = 1
    FOREACH q613_bcs INTO g_oga[g_cnt].*,l_oga09  #No.FUN-610020
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oga[g_cnt].ogb12 IS NULL THEN
  	       LET g_oga[g_cnt].ogb12 = 0
        END IF
        IF NOT cl_null(g_oga[g_cnt].ogb913) AND cl_null(g_oga[g_cnt].ogb915) THEN
  	       LET g_oga[g_cnt].ogb915 = 0
        END IF
        IF NOT cl_null(g_oga[g_cnt].ogb910) AND cl_null(g_oga[g_cnt].ogb912) THEN
  	       LET g_oga[g_cnt].ogb912 = 0
        END IF
        IF g_oga[g_cnt].ogb63 IS NULL THEN
  	       LET g_oga[g_cnt].ogb63 = 0
        END IF
 
        LET g_sql="SELECT SUM(ogb12),SUM(ogb915),SUM(ogb912)",
                  #"  FROM ",s_dbstring(g_dbs),"oga_file,",s_dbstring(g_dbs),"ogb_file", #FUN-A50102
                   "  FROM ",cl_get_target_table(g_oea.oeaplant, 'oga_file'),",",cl_get_target_table(g_oea.oeaplant, 'ogb_file'), #FUN-A50102
                  " WHERE oga01 = ogb01",
                  "   AND ogaconf = 'Y' AND ogapost = 'Y'",
                  "   AND oga09 = '8'",   
                  "   AND oga011= '",g_oga[g_cnt].ogb01,"'",
                  "   AND ogb03 = ",g_oga[g_cnt].ogb03 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_oea.oeaplant) RETURNING g_sql  #FUN-A50102
        PREPARE sum_cs FROM g_sql
        EXECUTE sum_cs INTO g_oga[g_cnt].acc_q,g_oga[g_cnt].acc_q2,g_oga[g_cnt].acc_q1
           IF cl_null(g_oga[g_cnt].acc_q2) THEN LET g_oga[g_cnt].acc_q2 = 0 END IF
           IF cl_null(g_oga[g_cnt].acc_q1) THEN LET g_oga[g_cnt].acc_q1 = 0 END IF
           IF cl_null(g_oga[g_cnt].acc_q ) THEN LET g_oga[g_cnt].acc_q  = 0 END IF
           IF cl_null(g_oga[g_cnt].ogb910) THEN LET g_oga[g_cnt].acc_q1 = NULL END IF
           IF cl_null(g_oga[g_cnt].ogb913) THEN LET g_oga[g_cnt].acc_q2 = NULL END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oga.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q613_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q613_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q613_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q613_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q613_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q613_fetch('L')
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
         CALL q613_def_form()     #FUN-610067
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-----FUN-610067---------
FUNCTION q613_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("ogb910,ogb912,ogb913,ogb915",FALSE)
       CALL cl_set_comp_visible("acc_q2,acc_q1",FALSE) #No.FUN-610020
       CALL cl_set_comp_visible("acd_q2,acd_q1",FALSE) #No.FUN-610020
       CALL cl_set_comp_visible("group03",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
       CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
       CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acd_q1",g_msg CLIPPED)
    END IF
END FUNCTION
 
FUNCTION q613_chk_auth()
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03 LIKE azp_file.azp03      #TQC-B90175 add 
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
