# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapq600.4gl
# Descriptions...: 廠商別跨工廠應付帳務查詢
# Date & Author..: 92/12/26 By Letter
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-660027 06/06/07 By Smapmin 查詢後若單身沒有資料,就會直接當掉
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/24 By douzh l_time轉g_time
# Modify.........: No.FUN-690080 06/10/25 By ice 查詢帳款,增加13,17類型的判斷與關聯
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify ........: No.TQC-6C0172 06/12/27 By wujie 匯出excel多余一行空行 
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740050 07/04/11 By Judy "指定筆"中無"確定"等按等按鈕
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860021 08/06/10 By Sarah CONSTRUCT,PROMPT段漏了ON IDLE控制
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.TQC-960326 09/06/25 By destiny 賬款明細增加16,23,26 
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CKP
DEFINE   mi_curs_index  LIKE type_file.num10       # No.FUN-690028 INTEGER
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-580092 HCN  #No.FUN-690028 INTEGER
DEFINE   mi_jump        LIKE type_file.num10       # No.FUN-690028 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
DEFINE   g_i LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(400)   #
DEFINE   g_apa_t         RECORD LIKE apa_file.*   #FUN-630043
DEFINE   l_ac LIKE type_file.num5    #FUN-630043  #No.FUN-690028 SMALLINT
 
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690028 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000		# Body Where condition  #No.FUN-690028 VARCHAR(500)
        END RECORD,
#單頭
    g_pmc  RECORD
            pmc01		LIKE pmc_file.pmc01, # 客戶代號
            pmc03		LIKE pmc_file.pmc03, # 客戶簡稱
            aza17 		LIKE aza_file.aza17  # 本幣幣別
        END RECORD,
 
#單身
    g_apa DYNAMIC ARRAY OF RECORD                # SCREEN RECORD
	    #plant       VARCHAR(10),       #FUN-660117 remark
	    plant   LIKE azp_file.azp01, #FUN-660117
	    apa02   LIKE apa_file.apa02,
            apa01   LIKE apa_file.apa01,
            pa13    LIKE apa_file.apa13,
            apa34f  LIKE apa_file.apa34f,
            amt_1   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
            amt_2   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
	    apa08   LIKE apa_file.apa08,  #FUN-630043
	    apa00   LIKE apa_file.apa00   #FUN-630043
        END RECORD,
 
    g_argv1     LIKE pmc_file.pmc01,      # INPUT ARGUMENT - 1
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-690028 SMALLINT
     g_sql          string,         #WHERE CONDITION  #No.FUN-580092 HCN
    #l_plant         DYNAMIC ARRAY OF  VARCHAR(20),          # 工廠編號 #FUN-660117 remark
    l_plant         DYNAMIC ARRAY OF LIKE azp_file.azp03, # 工廠編號 #FUN-660117
    l_azp01         DYNAMIC ARRAY OF LIKE azp_file.azp01, #FUN-980020
    g_rec_b     LIKE type_file.num5           		  #單身筆數  #No.FUN-690028 SMALLINT
DEFINE p_row,p_col,g_plant_cnt    LIKE type_file.num5        # No.FUN-690028 SMALLINT
 
 
MAIN
   DEFINE l_time	LIKE type_file.chr8    		       #計算被使用時間  #No.FUN-690028 VARCHAR(8)
 
   OPTIONS                                 #改變一些系統預設值
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
 
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   #UI
    LET p_row = 5 LET p_col = 16
 
 OPEN WINDOW q600_w AT p_row,p_col
 
      WITH FORM "aap/42f/aapq600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
    #IF cl_prichk('Q') THEN CALL q600_q() END IF
    CALL q600_menu()    #中文
    CLOSE WINDOW q600_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   CLEAR FORM          #清除畫面
   CALL cl_opmsg('q')
INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON pmc01,pmc03       # 螢幕上取單頭條件
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--HCN
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--HCN
 
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE CONSTRUCT    #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END CONSTRUCT
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF INT_FLAG THEN RETURN END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT pmc01 FROM pmc_file ",
             " WHERE ",tm.wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND pmcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
   #End:FUN-980030
 
   PREPARE q600_prepare FROM g_sql
   DECLARE q600_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q600_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM pmc_file "
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
         WHEN "qry_aapt110"
           IF cl_chk_act_auth() THEN
              CASE g_apa_t.apa00
                WHEN '11'
                     LET g_msg="aapt110 '",g_apa_t.apa01,"'"
                WHEN '12'
                     LET g_msg="aapt120 '",g_apa_t.apa01,"'"
                WHEN '15'
                     LET g_msg="aapt150 '",g_apa_t.apa01,"'"
                WHEN '21'
                     LET g_msg="aapt210 '",g_apa_t.apa01,"'"
                WHEN '22'
                     LET g_msg="aapt220 '",g_apa_t.apa01,"'"
                #No.FUN-690080 --Begin
                WHEN '13'
                     LET g_msg="aapt121 '",g_apa_t.apa01,"'"
                WHEN '17'
                     LET g_msg="aapt151 '",g_apa_t.apa01,"'"
                #No.FUN-690080 --End
                #No.TQC-960326 --beging                                                                                             
                WHEN '16'                                                                                                           
                     LET g_msg="aapt160 '",g_apa_t.apa01,"'"                                                                        
                WHEN '23'                                                                                                           
                     LET g_msg="aapq230 '",g_apa_t.apa01,"'"                                                                        
                WHEN '26'                                                                                                           
                     LET g_msg="aapt260 '",g_apa_t.apa01,"'"                                                                        
                #No.TQC-960326 --end 
              END CASE
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
         WHEN "qry_aapq106"
           IF cl_chk_act_auth() THEN
              LET g_msg="aapq106 '",g_apa_t.apa01,"'"
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
         #END FUN-630043
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
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
         DISPLAY g_row_count TO cnt   #No.FUN-580092 HCN
        CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690028 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690028 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    q600_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     q600_cs INTO g_pmc.pmc01
        WHEN '/'
         #CKP
             IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                PROMPT g_msg CLIPPED,': ' FOR mi_jump #CKP
                   ON IDLE g_idle_seconds  #TQC-860021
                      CALL cl_on_idle()    #TQC-860021
 
                   ON ACTION about         #TQC-860021
                      CALL cl_about()      #TQC-860021
 
                   ON ACTION help          #TQC-860021
                      CALL cl_show_help()  #TQC-860021
 
                   ON ACTION controlg      #TQC-860021
                      CALL cl_cmdask()     #TQC-860021
                END PROMPT                 #TQC-860021
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
             #CKP
             END IF
             FETCH ABSOLUTE mi_jump q600_cs INTO g_pmc.pmc01
             LET mi_no_ask = FALSE
    END CASE
 
    IF sqlca.sqlcode THEN
       CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
       INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
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
 
    SELECT pmc01,pmc03
      INTO g_pmc.pmc01,g_pmc.pmc03
      FROM pmc_file
     WHERE pmc01 = g_pmc.pmc01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660122
       CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660122
       RETURN
    END IF
    CALL q600_show()
END FUNCTION
 
FUNCTION q600_show()
   LET g_pmc.aza17=g_aza.aza17
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_b_fill()        #BODY FILL UP
  #DEFINE l_dbs             LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)   #FUN-A50102
   DEFINE l_sql             LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(1000)
          tot_1,tot_2       LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
          g_cnt2            LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
          g_apa02             LIKE   apa_file.apa02,
          g_apa13             LIKE   apa_file.apa13,
          g_apa14             LIKE   apa_file.apa14,
          exT,exTd            LIKE   ooz_file.ooz17
 
 
  CALL g_apa.clear()
  CALL l_plant.clear()
  CALL l_azp01.clear()       #FUN-980020
 
   LET g_rec_b=0
   LET g_cnt2 = 0
   LET tot_1   = 0
   LET tot_2   =0
 
#FUN-A50102--mod--str--
#  SELECT COUNT(azp03) INTO g_plant_cnt
#    FROM azp_file
#   WHERE azp053 != 'N'
#     AND azp03 IS NOT NULL
#     AND azp03 <> ' '
   SELECT COUNT(azw01) INTO g_plant_cnt
     FROM azw_file
    WHERE azwacti = 'Y'
      AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)
#FUN-A50102--mod--end
 
#  LET g_sql="SELECT azp03 FROM azp_file",        #FUN-980020 mark
#FUN-A50102--mod--str--
#  LET g_sql="SELECT azp01,azp03 FROM azp_file",  #FUN-980020
#            " WHERE azp053 != 'N' ", #no.7431
#            "   AND azp03 IS NOT NULL ",
#            "   AND azp03 <> ' '      "
   LET g_sql="SELECT azw01 FROM azw_file ",
             " WHERE azwacti = 'Y'",
             "   AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')"
#FUN-A50102--mod--end
   PREPARE q600_p1 FROM g_sql
   DECLARE q600_plant CURSOR FOR q600_p1
   LET g_cnt=1
#  FOREACH q600_plant INTO l_plant[g_cnt]                 #FUN-980020 mark
#  FOREACH q600_plant INTO l_azp01[g_cnt],l_plant[g_cnt]  #FUN-980020   #FUN-A50102
   FOREACH q600_plant INTO l_azp01[g_cnt]                 #FUN-A50102
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)   
       EXIT FOREACH
    END IF
    Let g_cnt=g_cnt+1
   END FOREACH
 
   LET g_cnt2=1
   FOR g_cnt = 1 TO g_plant_cnt
 
   #LET l_dbs=l_plant[g_cnt] CLIPPED,"."         #TQC-940178 MARK
   #LET l_dbs=s_dbstring(l_plant[g_cnt] CLIPPED) #TQC-940178 ADD   #FUN-A50102 
    LET g_sql="SELECT UNIQUE ' ',apa02,apa01,apa13,   ",
              "              apa34f,' ',apa35f,apa08,apa00  ",
             #FUN-A50102--mod--str--
             #"   FROM  ",l_dbs CLIPPED,"pmc_file,   ",
             #"         ",l_dbs CLIPPED,"apa_file    ",
              "   FROM  ",cl_get_target_table(l_azp01[g_cnt],'pmc_file'),",",
              "         ",cl_get_target_table(l_azp01[g_cnt],'apa_file'),
             #FUN-A50102--mod--end
              "  WHERE ",tm.wc CLIPPED,
              "    AND apa06='",g_pmc.pmc01 CLIPPED,"' "
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,l_azp01[g_cnt]) RETURNING g_sql   #FUN-A50102
    PREPARE q600_pb1 FROM g_sql
    DECLARE apa_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q600_pb1
 
    FOREACH apa_cs INTO g_apa[g_cnt2].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
      # Login USER Plant匯率計算
        LET g_apa02=''
        LET g_apa13=''
        LET g_apa14=''
        LET l_sql  = "SELECT apa02,apa13 ",
                    #" FROM ",l_dbs CLIPPED,"apa_file ",   #FUN-A50102
                     " FROM ",cl_get_target_table(l_azp01[g_cnt],'apa_file'),   #FUN-A50102
                     " WHERE apa01='",g_apa[g_cnt2].apa01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_azp01[g_cnt]) RETURNING l_sql   #FUN-A50102
        PREPARE apa14_p1 FROM l_sql
        DECLARE apa14_c1 CURSOR FOR apa14_p1
        OPEN apa14_c1
        FETCH apa14_c1 INTO g_apa02,g_apa13
        IF SQLCA.sqlcode THEN
           LET g_apa02 = ' '
           LET g_apa13 = ' '
        END IF
        CLOSE apa14_c1
#       CALL s_currm(g_apa13,g_apa02,'S',l_dbs) RETURNING g_apa14              #FUN-980020 mark
        CALL s_currm(g_apa13,g_apa02,'S',l_azp01[g_cnt]) RETURNING g_apa14     #FUN-980020
 
      # (待抵帳款)則金額應秀負號
        IF g_apa[g_cnt2].apa00[1,1]='2' THEN
           LET g_apa[g_cnt2].apa34f=g_apa[g_cnt2].apa34f * -1
           LET g_apa[g_cnt2].amt_2 =g_apa[g_cnt2].amt_2 * -1
        END IF
 
       #FUN-A50102--mod--str--
       #SELECT azp01 INTO g_apa[g_cnt2].plant FROM azp_file
       # WHERE azp03=l_plant[g_cnt]
        LET g_apa[g_cnt2].plant=l_azp01[g_cnt]
       #FUN-A50102--mod--end
       #LET g_apa[g_cnt2].plant=l_plant[g_cnt]
        LET g_apa[g_cnt2].amt_1=g_apa[g_cnt2].apa34f * g_apa14
        LET g_apa[g_cnt2].amt_2=g_apa[g_cnt2].amt_2 * g_apa14
 
        LET tot_1   = tot_1 + g_apa[g_cnt2].amt_1    # tot_1
        LET tot_2   = tot_2 + g_apa[g_cnt2].amt_2    # tot_2
        LET g_cnt2 = g_cnt2 + 1
        IF g_cnt2 > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
   END FOR
#No.TQC-6C0172--begin                                                                                                               
    CALL g_apa.deleteElement(g_cnt2)                                                                                                
#No.TQc-6C0172--end 
    LET g_rec_b=(g_cnt2-1)
    DISPLAY BY NAME tot_1,tot_2
   #DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rec_b > 0 THEN   #TQC-660027
       LET g_apa_t.apa01=g_apa[g_rec_b].apa01  #FUN-630043
       LET g_apa_t.apa00=g_apa[g_rec_b].apa00  #FUN-630043
    #-----TQC-660027---------
    ELSE
       LET g_apa_t.apa01=''
       LET g_apa_t.apa00=''
    END IF    
    #-----END TQC-660027-----
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   IF p_ud <> "G" THEN   #TQC-660027
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apa TO s_apa.*
 
      BEFORE ROW
         #FUN-630043
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL cl_show_fld_cont()
         LET g_apa_t.apa01 = g_apa[l_ac].apa01
         LET g_apa_t.apa00 = g_apa[l_ac].apa00
         #END FUN-630043
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #FUN-630043
      ON ACTION qry_aapt110
         LET g_action_choice="qry_aapt110"
         EXIT DISPLAY
 
      ON ACTION qry_aapq106
         LET g_action_choice="qry_aapq106"
         EXIT DISPLAY
      #END FUN-630043
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
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
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      #FUN-4B0009
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
         CALL cl_set_act_visible("accept,cancel", TRUE)   #TQC-740050
         CALL q600_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
         CALL fgl_set_arr_curr(1)  ######add in 040505
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
