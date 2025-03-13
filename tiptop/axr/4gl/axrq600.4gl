# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrq600.4gl
# Descriptions...: 客戶別跨工廠應收帳務查詢
# Date & Author..: 92/12/26 By Letter
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-5C0014 06/05/29 By rainy  顯示INVOICE NO.
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6C0147 06/12/26 By Rayven 匯出EXCEL匯出的值多一行空白，指定筆彈出的輸入框格式有誤
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-860078 08/06/09 by Yiting ON IDLE處理 
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.TQC-9C0099 09/12/15 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CKP
DEFINE   mi_curs_index   LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-580092 HCN #No.FUN-680123 INTEGER
DEFINE   mi_jump         LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680123 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5         #No.FUN-680123 SMALLINT
DEFINE   g_forupd_sql    STRING                      #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(400)
DEFINE   g_oma_t         RECORD LIKE oma_file.*      #FUN-630043
DEFINE   l_ac            LIKE type_file.num5         #FUN-630043  #No.FUN-680123 SMALLINT
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	 wc     LIKE type_file.chr1000,      # Head Where condition #No.FUN-680123 VARCHAR(500)
                 wc2    LIKE type_file.chr1000       # Body Where condition #No.FUN-680123 VARCHAR(500)
        END RECORD,
#單頭
    g_occ  RECORD
            occ01	LIKE occ_file.occ01,         # 客戶代號
            occ02	LIKE occ_file.occ02,         # 客戶簡稱
            aza17 	LIKE aza_file.aza17          # 本幣幣別
        END RECORD,
 
#單身
    g_oma DYNAMIC ARRAY OF RECORD                    # SCREEN RECORD
	    plant   LIKE azp_file.azp01,             #No.FUN-680123 VARCHAR(10)
	    oma02   LIKE oma_file.oma02,
            oma01   LIKE oma_file.oma01,
            oma23   LIKE oma_file.oma23,
            oma54t  LIKE oma_file.oma54t,
           #amt_1   DEC(20,6),                      #FUN-4C0013
            amt_1   LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
           #amt_2   DEC(20,6),                      #FUN-4C0013
            amt_2   LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
            oma10   LIKE oma_file.oma10,            #FUN-630043
            oma67   LIKE oma_file.oma67,            #FUN-5C0014
            oma00   LIKE oma_file.oma00             #FUN-630043
        END RECORD,
 
    g_argv1         LIKE occ_file.occ01,            #INPUT ARGUMENT - 1
    g_sql           string,                         #WHERE CONDITION  #No.FUN-580092 HCN
   #l_plant         DYNAMIC ARRAY OF VARCHAR(21),      # 工廠編號
    l_plant         DYNAMIC ARRAY OF LIKE azp_file.azp01,    #No.FUN-680123 VARCHAR(21)
    g_rec_b         LIKE type_file.num5   	    #單身筆數  #No.FUN-680123 SMALLINT 
DEFINE  p_row,p_col,g_plant_cnt    LIKE type_file.num5         #No.FUN-680123 SMALLINT
 
MAIN
#   DEFINE l_time	LIKE type_file.chr8    		       #計算被使用時間 #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
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
   #UI
    LET p_row = 5 LET p_col = 16
 
 OPEN WINDOW q600_w AT p_row,p_col
 
      WITH FORM "axr/42f/axrq600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
 
   CALL cl_ui_init()
 
    #IF cl_prichk('Q') THEN CALL q600_q() END IF
    CALL q600_menu()    #中文
    CLOSE WINDOW q600_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-680123 SMALLINT 
 
 WHILE TRUE
   CLEAR FORM          #清除畫面
   CALL cl_opmsg('q')
INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON occ01,occ02       # 螢幕上取單頭條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION locale
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
  IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
  END IF
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  EXIT WHILE
 END WHILE
 
   MESSAGE ' WAIT '
      LET g_sql=" SELECT occ01 FROM occ_file ",
                " WHERE ",tm.wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
   #End:FUN-980030
 
   #LET g_sql = g_sql clipped," ORDER BY occ01"
   PREPARE q600_prepare FROM g_sql
   DECLARE q600_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q600_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM occ_file "
   PREPARE q600_pp  FROM g_sql
   DECLARE q600_cnt   CURSOR FOR q600_pp
END FUNCTION
 
 
#中文的MENU
FUNCTION q600_menu()
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         #FUN-630043
         WHEN "qry_axrt300"
           IF cl_chk_act_auth() THEN
              LET g_msg="axrt300 '",g_oma_t.oma01,"'"
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
         #END FUN-630043
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
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
 
 
FUNCTION q600_q()
    #CKP
     LET g_row_count = 0 #No.FUN-580092 HCN
    LET mi_curs_index = 0
     CALL cl_navigator_setting( mi_curs_index, g_row_count ) #No.FUN-580092 HCN
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q600_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q600_cnt
        FETCH q600_cnt INTO g_row_count #No.FUN-580092 HCN
        DISPLAY g_row_count TO cnt #No.FUN-580092 HCN
       CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680123 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680123 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_occ.occ01
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_occ.occ01
        WHEN 'F' FETCH FIRST    q600_cs INTO g_occ.occ01
        WHEN 'L' FETCH LAST     q600_cs INTO g_occ.occ01
        WHEN '/'
         #CKP
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             PROMPT g_msg CLIPPED,': ' FOR mi_jump #CKP
	     #--NO.MOD-860078 ------
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
             
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
             
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
            #--NO.MOD-860078 end-----
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         #CKP
         END IF
 
         FETCH ABSOLUTE mi_jump q600_cs INTO g_occ.occ01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
        RETURN
    END IF
     #CKP
     CASE p_flag
        WHEN 'F' LET mi_curs_index = 1
        WHEN 'P' LET mi_curs_index = mi_curs_index - 1
        WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
        WHEN '/' LET mi_curs_index = mi_jump
     END CASE
      CALL cl_navigator_setting( mi_curs_index, g_row_count ) #No.FUN-580092 HCN
 
    SELECT occ01,occ02
      INTO g_occ.occ01,g_occ.occ02
      FROM occ_file
     WHERE occ01 = g_occ.occ01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
        RETURN
    END IF
    CALL q600_show()
END FUNCTION
 
FUNCTION q600_show()
   LET g_occ.aza17=g_aza.aza17
   DISPLAY BY NAME g_occ.*   # 顯示單頭值
   CALL q600_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_b_fill()                                 #BODY FILL UP
   DEFINE  l_dbs             LIKE type_file.chr21      #No.FUN-680123 VARCHAR(21)
   DEFINE  l_sql             LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000)
          #tot_1,tot_2       DEC(20,6),                #FUN-4C0013
           tot_1,tot_2       LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
           g_cnt2            LIKE type_file.num5,      #No.FUN-680123 SMALLINT
           g_oma00           LIKE   oma_file.oma00,
           g_oma08,g_oma08d  LIKE   oma_file.oma08,
           g_oma09,g_oma09d  LIKE   oma_file.oma09,
           g_oma23d          LIKE   oma_file.oma23,
           g_oma58,g_oma58d  LIKE   oma_file.oma58,
           exT,exTd          LIKE   ooz_file.ooz17
 
 
   CALL g_oma.clear()
 
   LET g_rec_b=0
   LET g_cnt2 = 0
   LET tot_1   = 0
   LET tot_2   =0
 
#  SELECT COUNT(azp03) INTO g_plant_cnt   #FUN-980020 mark
   SELECT COUNT(azp01) INTO g_plant_cnt   #FUN-980020
     FROM azp_file
    WHERE azp053 != 'N'
      AND azp03 IS NOT NULL
      AND azp03 <> ' '
      AND azp01 IN( SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)  #FUN-980020 <--加上過濾user權限
 
#  LET g_sql="SELECT azp03 FROM azp_file",  #FUN-980020 mark
   LET g_sql="SELECT azp01 FROM azp_file",  #FUN-980020
             " WHERE azp053 != 'N' ", #no.7431
             "   AND azp03 IS NOT NULL ",
             "   AND azp03 <> ' '      ",
             "   AND azp01 IN( SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"  #FUN-980020 <--加上過濾user權限
   LET g_cnt=1
   PREPARE q600_p1 FROM g_sql
   DECLARE q600_plant CURSOR FOR q600_p1
   FOREACH q600_plant INTO l_plant[g_cnt]
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    Let g_cnt=g_cnt+1
   END FOREACH
 
   LET g_cnt2=1
   FOR g_cnt = 1 TO g_plant_cnt
 
   #LET l_dbs=s_dbstring(l_plant[g_cnt] CLIPPED)  #TQC-950020
#FUN-980020--begin
   #LET l_dbs=s_dbstring(l_plant[g_cnt] CLIPPED) #TQC-950020  
    LET g_plant_new = l_plant[g_cnt]  
    CALL s_getdbs()
    LET l_dbs = g_dbs_new
#FUN-980020--end
    LET g_sql="SELECT UNIQUE ' ',oma02,oma01,oma23,oma54t,' ',oma55,oma10,oma67,oma00,",  #FUN-630043 #FUN-5C0015 add oma67
              "             oma08,oma09 ",                                          #FUN-630043
              #" FROM ",l_dbs CLIPPED,"occ_file,",
              #"      ",l_dbs CLIPPED,"oma_file ",
              " FROM ",cl_get_target_table(g_plant_new,'occ_file'),",", #FUN-A50102
              "      ",cl_get_target_table(g_plant_new,'oma_file'),     #FUN-A50102
              " WHERE ",tm.wc CLIPPED,
              "   AND oma03='",g_occ.occ01 CLIPPED,"'"
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
    PREPARE q600_pb1 FROM g_sql
    DECLARE oma_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q600_pb1
 
    FOREACH oma_cs INTO g_oma[g_cnt2].*,g_oma08,g_oma09
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
      # 匯率計算
        LET g_oma08d=''
        LET g_oma09d=''
        LET g_oma23d=''
        LET g_oma58d=''
        LET l_sql  = "SELECT oma08,oma09,oma23 ",
                     #" FROM ",l_dbs CLIPPED,"oma_file ",
                     " FROM ",cl_get_target_table(g_plant_new,'oma_file'),     #FUN-A50102
                     " WHERE oma01='",g_oma[g_cnt2].oma01,"' "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oma58_p1 FROM l_sql
        DECLARE oma58_c1 CURSOR FOR oma58_p1
        OPEN oma58_c1
        FETCH oma58_c1 INTO g_oma08d,g_oma09d,g_oma23d
        IF SQLCA.sqlcode THEN
           LET g_oma08d = ' '
           LET g_oma09d = ' '
           LET g_oma23d = ' '
        END IF
        CLOSE oma58_c1
        IF g_oma08d='1' THEN
         SELECT ooz17 INTO exTd FROM ooz_file
        ELSE
         SELECT ooz63 INTO exTd FROM ooz_file
        END IF
       #CALL s_currm(g_oma23d,g_oma09d,exTD,l_dbs) RETURNING g_oma58d  #TQC-9C0099
        CALL s_currm(g_oma23d,g_oma09d,exTD,l_plant[g_cnt]) RETURNING g_oma58d#TQC-9C0099
 
      # 待抵帳款)則金額應秀負號
        IF g_oma[g_cnt2].oma00[1,1]='2' THEN
           LET g_oma[g_cnt2].oma54t=g_oma[g_cnt2].oma54t * -1
           LET g_oma[g_cnt2].amt_2 =g_oma[g_cnt2].amt_2 * -1
        END IF
#FUN-980020--begin
#       SELECT azp01 INTO g_oma[g_cnt2].plant FROM azp_file
#        WHERE azp03=l_plant[g_cnt]
        LET g_oma[g_cnt2].plant=l_plant[g_cnt]
#FUN-980020--end
        LET g_oma[g_cnt2].amt_1=g_oma[g_cnt2].oma54t * g_oma58d
        LET g_oma[g_cnt2].amt_2=g_oma[g_cnt2].amt_2 * g_oma58d
 
        LET tot_1   = tot_1 + g_oma[g_cnt2].amt_1    # tot_1
        LET tot_2   = tot_2 + g_oma[g_cnt2].amt_2    # tot_2
        IF g_cnt2 > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
        LET g_cnt2 = g_cnt2 + 1
    END FOREACH
    CALL g_oma.deleteElement(g_cnt2)  #No.TQC-6C0147
   END FOR
 
    LET g_rec_b=(g_cnt2-1)
    DISPLAY BY NAME tot_1,tot_2
   #DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rec_b !=0 THEN
       LET g_oma_t.oma01=g_oma[g_rec_b].oma01  #FUN-630043
    END IF
END FUNCTION
 
FUNCTION q600_bp(p_ud)
 
 
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN  #No.TQC-6C0147 mark
   IF p_ud <> "G" THEN  #No.TQC-6C0147
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE (COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         #FUN-630043
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL cl_show_fld_cont()
         LET g_oma_t.oma01 = g_oma[l_ac].oma01
         #END FUN-630043
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #FUN-630043
      ON ACTION qry_axrt300
         LET g_action_choice="qry_axrt300"
         EXIT DISPLAY
      #END FUN-630043
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#No.TQC-6C0147 --start--
#     ON ACTION accept
#        LET g_action_choice="detail"
#        EXIT DISPLAY
#No.TQC-6C0147 --end--
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
 
      ON ACTION first
         CALL q600_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION previous
         CALL q600_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)         #No.TQC-6C0147
         CALL q600_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN         #No.TQC-6C0147
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF  #No.TQC-6C0147
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION next
         CALL q600_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION last
         CALL q600_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         ACCEPT DISPLAY   #FUN-530067(smin)
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
