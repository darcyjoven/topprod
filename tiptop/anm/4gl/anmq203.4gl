# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: anmq203.4gl
# Descriptions...: 應收支票帳務查詢
# Date & Author..: 97/12/18 BY Star
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: No.FUN-550057 05/06/01 By wujie 單據編號加大
# Modify.........: No.TQC-5B0047 05/11/08 By Nicola 單身筆數錯誤
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740037 07/04/12 By Smapmin 單身資料重複顯示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770013 07/07/02 By Judy 匯出EXCEL的值多一空白行
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-CB0144 12/11/16 By Polly 調整類別desc的抓取
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE
       g_nmh RECORD LIKE nmh_file.*,
       g_ooa DYNAMIC ARRAY OF RECORD
            ooa01   LIKE ooa_file.ooa01,   #沖帳單號
            oob02   LIKE oob_file.oob02,   #項次
            ooa02   LIKE ooa_file.ooa02,   #沖帳日期
            ooa23   LIKE ooa_file.ooa23,   #幣別
            desc    LIKE ool_file.ool02,   #No.FUN-680107 VARCHAR(4)
            oob06   LIKE oob_file.oob06,   #參考單號
            oob14   LIKE oob_file.oob14,   #第二參考單號
            oob08   LIKE oob_file.oob08,   #匯率
            oob09   LIKE oob_file.oob09,   #原幣金額
            oob10   LIKE oob_file.oob10,   #本幣金額
            oob05   LIKE oob_file.oob05,   #工廠編號
            oob13   LIKE oob_file.oob13    #原始部門
       END RECORD,
       g_nma02      LIKE nma_file.nma02,
       g_rec_b      LIKE type_file.num5,             #單身筆數 #No.FUN-680107 SMALLINT
       g_wc         STRING,                          #No.FUN-580092 HCN     
       g_wc2        STRING,                          #No.FUN-580092 HCN     
       g_sql        STRING,                          #No.FUN-580092 HCN     
       l_ac         LIKE type_file.num5,             #No.FUN-680107 SMALLINT
#      g_argv1      VARCHAR(10)
       g_argv1      LIKE nmh_file.nmh01              #No.FUN-550057
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q203_w AT p_row,p_col
         WITH FORM "anm/42f/anmq203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_argv1 = ARG_VAL(1)  # 收票單號
    IF NOT cl_null(g_argv1)
       THEN CALL q203_q()
    END IF
 
    CALL q203_menu()
    CLOSE WINDOW q203_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION q203_cs()
    CLEAR FORM
   CALL g_ooa.clear()
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT nmh01 FROM nmh_file ", # 組合出 SQL 指令
          " WHERE nmh01 ='",g_argv1, "' ORDER BY nmh01"
    ELSE
   INITIALIZE g_nmh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON nmh31,nmh04,nmh02,nmh32,nmh03,nmh28,
                                 nmh01,nmh15,nmh16,nmh11,nmh30,nmh05,nmh09
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
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND nmhuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
       #End:FUN-980030
 
       LET g_sql="SELECT nmh01 FROM nmh_file ", # 組合出 SQL 指令
          " WHERE ",g_wc CLIPPED, " ORDER BY nmh01"
    END IF
 
    PREPARE q203_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q203_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q203_prepare
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM nmh_file WHERE nmh01 ='",g_argv1,"'"
    ELSE
        LET g_sql= "SELECT COUNT(*) FROM nmh_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE q203_pre_count FROM g_sql
    DECLARE q203_count CURSOR FOR q203_pre_count
END FUNCTION
 
FUNCTION q203_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL q203_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q203_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ooa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q203_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q203_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ooa.clear()
        RETURN
    END IF
    OPEN q203_count
    FETCH q203_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q203_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL
    ELSE
        CALL q203_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q203_fetch(p_flnmh)
    DEFINE
        p_flnmh         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flnmh
        WHEN 'N' FETCH NEXT     q203_cs INTO g_nmh.nmh01
        WHEN 'P' FETCH PREVIOUS q203_cs INTO g_nmh.nmh01
        WHEN 'F' FETCH FIRST    q203_cs INTO g_nmh.nmh01
        WHEN 'L' FETCH LAST     q203_cs INTO g_nmh.nmh01
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
            FETCH ABSOLUTE g_jump q203_cs INTO g_nmh.nmh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnmh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_nmh.* FROM nmh_file    # 重讀DB,因TEMP有不被更新特性
       WHERE nmh01 = g_nmh.nmh01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
    ELSE
 
        CALL q203_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q203_show() #TQC-840066
 
    DISPLAY BY NAME         g_nmh.nmh31,g_nmh.nmh04,g_nmh.nmh02,
                            g_nmh.nmh32,g_nmh.nmh03,g_nmh.nmh28,
                            g_nmh.nmh01,g_nmh.nmh15,g_nmh.nmh16,
                            g_nmh.nmh11,g_nmh.nmh30,g_nmh.nmh05,
                            g_nmh.nmh09
 
   CALL q203_nmh15('d')
   CALL q203_nmh16('d')
   CALL q203_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q203_nmh16(p_cmd)  #業務員代號
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_nmh.nmh16
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-007'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION q203_nmh15(p_cmd)  #部門代號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_nmh.nmh15
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-007'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION q203_b_fill()              #BODY FILL UP
 DEFINE  l_azp03  LIKE azp_file.azp03
 DEFINE  l_ooa01  LIKE ooa_file.ooa01  # 沖帳單號
 DEFINE  l_oob04  LIKE oob_file.oob04
 DEFINE  l_oob06  LIKE oob_file.oob06
 
    CALL g_ooa.clear()
 
    LET g_cnt = 1
 
    LET g_sql =
        "SELECT UNIQUE ooa01 ",
#TQC-940177   ---start   
       #" FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",
       #         s_dbstring(g_dbs CLIPPED)," oob_file ",
       # " FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ", 
       #          s_dbstring(g_dbs CLIPPED)," oob_file ", 
       # " FROM ",cl_get_target_table(g_plant,'ooa_file'),",", #FUN-A50102
       #          cl_get_target_table(g_plant,'oob_file'),     #FUN-A50102 
       " FROM ooa_file,oob_file  ",  #FUN-A50102
#TQC-940177   ---end 
        " WHERE oob01 = ooa01 ",
        "   AND ooaconf !='X' ",  #010804增
        "   AND oob06 = '",g_nmh.nmh01,"' ", # 參考單號
        "   AND oob03 = '1'   ", # 借方
        " ORDER BY 1 "
 
 	# CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    # CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
    PREPARE q203_pb FROM g_sql
    DECLARE ooa_curs                      #SCROLL CURSOR
        CURSOR FOR q203_pb
 
    FOREACH ooa_curs INTO l_ooa01         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        # 1.利用沖帳單號, 帶出此張單據的貸方, 且類別為 2
        LET g_sql =
            "SELECT UNIQUE oob06 ",
#TQC-940177   ---start   
           #" FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",
           #         s_dbstring(g_dbs CLIPPED)," oob_file ",
           # " FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",    
           #          s_dbstring(g_dbs CLIPPED)," oob_file ", 
           #" FROM ",cl_get_target_table(g_plant,'ooa_file'),",", #FUN-A50102
           #         cl_get_target_table(g_plant,'oob_file'),     #FUN-A50102      
           " FROM ooa_file,oob_file  ",    #FUN-A50102
#TQC-940177   ---end               
            " WHERE oob01 = ooa01 ",
            "   AND ooaconf != 'X' ",  #018004增
            "   AND ooa01 = '",l_ooa01,"' ",
            "   AND oob03 = '2'   ", # 貸方
            "   AND oob04 IN ('1','2') ", # 應收or轉暫收(溢收)
            " ORDER BY 1 "
 
 	 #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     #CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
        PREPARE q203_pb1 FROM g_sql
        DECLARE ooa_curs1                      #SCROLL CURSOR
            CURSOR FOR q203_pb1
        FOREACH ooa_curs1 INTO l_oob06
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
           END IF
           #-----MOD-740037---------
           LET g_sql =
                "SELECT ooa01,oob02,ooa02,ooa23,'',oob06,oob14,oob08,oob09,",
                "       oob10,oob05,oob13,oob04 ",                             #MOD-CB0144 add oob14
#TQC-940177   ---start  
               #" FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",
               #         s_dbstring(g_dbs CLIPPED)," oob_file ",
               # " FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",     
               #          s_dbstring(g_dbs CLIPPED)," oob_file ", 
               #" FROM ",cl_get_target_table(g_plant,'ooa_file'),",", #FUN-A50102
               #         cl_get_target_table(g_plant,'oob_file'),     #FUN-A50102 
               " FROM ooa_file,oob_file  ",  #FUN-A50102
#TQC-940177   ---end      
                " WHERE oob01 = ooa01 ",
                "   AND ooaconf !='X' ",  #010804增
                "   AND ooa01 = '",l_ooa01,"' ",
                "   AND oob06 = '",l_oob06,"' ",
                "   AND oob03 = '2'   ", # 貸方 
                " ORDER BY 1,2 "
           
 	 #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     #CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
           PREPARE q203_pb2 FROM g_sql
           DECLARE ooa_curs2 CURSOR FOR q203_pb2    #SCROLL CURSOR
           FOREACH ooa_curs2 INTO g_ooa[g_cnt].*,l_oob04
             #SELECT ool02 INTO g_ooa[g_cnt].desc FROM ool_file                   #MOD-CB0144 mark
             # WHERE ool01 = l_oob04                                              #MOD-CB0144 mark
              CALL s_oob04('2',l_oob04) RETURNING g_ooa[g_cnt].desc               #MOD-CB0144 add
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err( '', 9035, 0 )
                 EXIT FOREACH
              END IF
           END FOREACH
           ## 2.利用參考單號(oob06=oob06), 得知, 共有那幾張單據
           #LET g_sql =
           #    "SELECT UNIQUE ooa01 ",
           #    " FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",
           #             s_dbstring(g_dbs CLIPPED)," oob_file ",
           #    " WHERE oob01 = ooa01 ",
           #    "   AND ooaconf !='X' ",  #010804增
           #    "   AND oob06 = '",l_oob06,"' ",
           #    "   AND oob03 IN ('1','2') ", # 貸方
           #    " ORDER BY 1 "
           #
           #PREPARE q203_pb2 FROM g_sql
           #DECLARE ooa_curs2                      #SCROLL CURSOR
           #    CURSOR FOR q203_pb2
           #FOREACH ooa_curs2 INTO l_ooa01
           #   IF SQLCA.sqlcode THEN
           #       CALL cl_err('foreach:',SQLCA.sqlcode,1)
           #       EXIT FOREACH
           #   END IF
           #   LET g_sql =
           #        "SELECT ooa01,oob02,ooa02,ooa23,'',oob06,oob14,oob08,oob09,",
           #        "       oob10,oob05,oob13 ",
           #        " FROM ",s_dbstring(g_dbs CLIPPED)," ooa_file, ",
           #                 s_dbstring(g_dbs CLIPPED)," oob_file ",
           #        " WHERE oob01 = ooa01 ",
           #        "   AND ooaconf !='X' ",  #010804增
           #        "   AND ooa01 = '",l_ooa01,"' ",
           #        "   AND oob03 = '2'   ", # 貸方
           #        " ORDER BY 1,2 "
           #
           #   PREPARE q203_pb3 FROM g_sql
           #   DECLARE ooa_curs3 CURSOR FOR q203_pb3    #SCROLL CURSOR
           #
           # # LET g_cnt = 1  #No.TQC-5B0047 Mark
           #   FOREACH ooa_curs3 INTO g_ooa[g_cnt].*,l_oob04
           #      SELECT ool02 INTO g_ooa[g_cnt].desc FROM ool_file
           #       WHERE ool01 = l_oob04
           #      LET g_cnt = g_cnt + 1
           #      IF g_cnt > g_max_rec THEN
           #         CALL cl_err( '', 9035, 0 )
           #         EXIT FOREACH
           #      END IF
           #   END FOREACH
           #END FOREACH
           #-----END MOD-740037-----
        END FOREACH
    END FOREACH
    CALL g_ooa.deleteElement(g_cnt)  #TQC-770013
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q203_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooa TO s_ooa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
        CALL cl_show_fld_cont()                   #No.FUN-550037
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q203_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q203_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q203_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q203_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q203_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
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
 
