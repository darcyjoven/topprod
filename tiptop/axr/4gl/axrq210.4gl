# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrq210.4gl
# Descriptions...: 未押匯出貨查詢
# Date & Author..: 96/01/26 By Danny
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
 # Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
 
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: NO.MOD-860078 08/06/09 by Yiting ON IDLE處理 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No.FUN-980091 09/09/04 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50098 10/05/27 By lutingting 展子孫改回不展子孫寫法 
# Modify.........: No.FUN-A50102 10/07/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C40020 12/04/05 By Polly 調整重復問題，改串oga27串olc01做為條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_ola           DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
                   #plant   LIKE azp_file.azp01,      #FUN-980091    #FUN-A50098
                    ola04   LIKE ola_file.ola04,
                    oga01   LIKE oga_file.oga01,
                    oga02   LIKE oga_file.oga02,
                    oga50   LIKE oga_file.oga50,
                    ogaconf LIKE oga_file.ogaconf,
                    ogapost LIKE oga_file.ogapost,
                    x       LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(01)
                    olc141  LIKE olc_file.olc141
                    END RECORD,
    b_date,e_date   LIKE type_file.dat,               #No.FUN-680123 DATE
     g_wc2,g_sql    string,                           #No.FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,              #單身筆數        #No.FUN-680123 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT #No.FUN-680123 SMALLINT
   #l_sl            SMALLINT                          #目前處理的SCREEN LINE  
    l_sl            LIKE type_file.num5               #No.FUN-680123 SMALLINT 
DEFINE #source      VARCHAR(10)                          #FUN-630043
        source      LIKE azp_file.azp01               #No.FUN-680123 VARCHAR(10)
DEFINE g_azp02      LIKE azp_file.azp02               #FUN-630043
 
DEFINE   g_cnt      LIKE type_file.num10              #No.FUN-680123 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0095
DEFINE p_row,p_col   LIKE type_file.num5              #No.FUN-680123 SMALLINT
    OPTIONS                                           #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW q210_w AT p_row,p_col WITH FORM "axr/42f/axrq210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#	CALL q210_q()
    CALL q210_menu()
    CLOSE WINDOW q210_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
FUNCTION q210_menu()
 
   WHILE TRUE
      CALL q210_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q210_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE # COMMAND KEY(esc) EXIT MENU
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ola),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q210_q()
   LET b_date = g_today
   LET e_date = g_today
   CLEAR FORM
   CALL g_ola.clear()
   CALL cl_opmsg('q')
 
      #FUN-630043
      LET source=g_plant 
      LET g_azp02=''
      DISPLAY BY NAME source
      SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
      DISPLAY g_azp02 TO FORMONLY.azp02
      LET g_plant_new=source    #FUN-A50098
      CALL s_getdbs()           #FUN-A50098
      IF g_aza.aza53='Y' THEN
         CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
         INPUT BY NAME source WITHOUT DEFAULTS
         AFTER FIELD source 
 
           ##GP5.2 add begin --check User是否有此plant的權限
            IF NOT s_chk_plant(source) THEN
                NEXT FIELD source
                END IF
           ##GP5.2 add end
 
            LET g_azp02=''
            SELECT azp02 INTO g_azp02 FROM azp_file
               WHERE azp01=source
            IF STATUS THEN
#              CALL cl_err(source,'100',0)   #No.FUN-660116
               CALL cl_err3("sel","azp_file",source,"","100","","",0)   #No.FUN-660116
               NEXT FIELD source
            END IF
            DISPLAY g_azp02 TO FORMONLY.azp02
            LET g_plant_new=source    #FUN-A50098
            CALL s_getdbs()           #FUN-A50098
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF  
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(source)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azp"
                    LET g_qryparam.default1 = source
                    CALL cl_create_qry() RETURNING source 
                    DISPLAY BY NAME source
                    NEXT FIELD source
            END CASE
 
            ON ACTION exit              #加離開功能genero
               LET INT_FLAG = 1
               EXIT INPUT
 
	 #--NO.MOD-860078 ------
            ON IDLE g_idle_seconds
        	CALL cl_on_idle()
		CONTINUE INPUT
	 
	    ON ACTION about         
		CALL cl_about()      
	  
	    ON ACTION help          
	       CALL cl_show_help()  
	  
	    ON ACTION controlg      
	       CALL cl_cmdask()     
	 #--NO.MOD-860078 end-------
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW q210_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
      END IF
      #FUN-630043
 
   INPUT BY NAME b_date,e_date WITHOUT DEFAULTS
 
      AFTER FIELD b_date
         IF cl_null(b_date) THEN
            NEXT FIELD b_date
         END IF
 
      AFTER FIELD e_date
         IF cl_null(e_date) THEN
            NEXT FIELD e_date
         END IF
         IF b_date > e_date THEN
            NEXT FIELD e_date
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW q210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL q210_b_askkey()
END FUNCTION
 
 
FUNCTION q210_b_askkey()
    CONSTRUCT g_wc2 ON ola04,oga01,oga02,oga50,ogaconf,ogapost
                  FROM s_ola[1].ola04,s_ola[1].oga01,s_ola[1].oga02,
                       s_ola[1].oga50,s_ola[1].ogaconf,s_ola[1].ogapost
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN#只能使用自己的資料
    #        LET g_wc2 = g_wc2 clipped," AND olauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc2 = g_wc2 clipped," AND olagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc2 = g_wc2 clipped," AND olagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('olauser', 'olagrup')
    #End:FUN-980030
 
 
    CALL q210_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q210_b_fill(p_wc2)                        #BODY FILL UP
DEFINE  p_wc2           LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(1000)
        l_olc01         LIKE olc_file.olc01,
        l_olc12         LIKE olc_file.olc12
#DEFINE l_plant   LIKE azp_file.azp01    #FUN-980091       #FUN-A50098
#DEFINE l_dbs     LIKE azp_file.azp03    #FUN-980091       #FUN-A50098
#DEFINE l_plt_list STRING                #FUN-980091       #FUN-A500985
 
    FOR g_cnt = 1 TO g_ola.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ola[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1 
    MESSAGE "Searching!"

#FUN-A50098--mark--str--改回不展子孫 ,抓取單頭來源營運中心得資料 
##(1)跨資料庫的Foreach應為為以Transaction DB 作Foreach
# LET g_sql="SELECT DISTINCT '',azw05 FROM azw_file,azp_file",
#           " WHERE azw05 = azp03 ",
#           "   AND azp053 != 'N' ",
#           "   AND azp03 IS NOT NULL ",
#           "   AND azp03 <> ' '      ",
#           "   AND azw01 IN ( SELECT zxy03 FROM zxy_file ",
#           "                   WHERE zxy01 ='",g_user CLIPPED,"')",
#           " ORDER BY azw05 "
#PREPARE azp_p FROM g_sql
#DECLARE azp_c CURSOR FOR azp_p
#FOREACH azp_c INTO l_plant,l_dbs  
#   IF STATUS THEN CALL cl_err('Foreach azp:',STATUS,1) EXIT FOREACH END IF
#   MESSAGE l_plant CLIPPED,' ',l_dbs CLIPPED   #FUN-A50098
#
#  #Mod FUN-980091 09/09/04 By TSD.apple-------------------(S)
#   #(2)於FOREACH中， 將此Transaction DB裡有權限的Plant抓出
#   CALL s_getplantlist(l_dbs) RETURNING l_plt_list
#   LET l_dbs=s_dbstring(l_dbs CLIPPED)
#  #Mod FUN-980091 09/08/24 By TSD.apple-------------------(E)
#FUN-A50098--mark--end
#FUN-A50102----modify---start--- 
{
##No.2951 modify 1998/12/23
#    LET g_sql = "SELECT DISTINCT ola04,oga01,oga02,oga50,ogaconf,ogapost,'N',",
#                "       olc141,olc01,olc12 ",
#               #"  FROM ola_file,olb_file,oga_file,ogb_file,OUTER olc_file ",  #FUN-630043
#               #FUN-630043
#               "  FROM ",g_dbs_new CLIPPED,"ola_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"olc_file ON ",g_dbs_new CLIPPED,"ola_file.ola04=",g_dbs_new,"olc_file.olc04,",
#               "       ",g_dbs_new CLIPPED,"olb_file,",
#               "       ",g_dbs_new CLIPPED,"oga_file,",
#               "       ",g_dbs_new CLIPPED,"ogb_file",
#               #END FUN-630043
#       		" WHERE ", p_wc2 CLIPPED,            #單身條件
#                "   AND olb04 = ogb31 ",   #訂單單號
#                "   AND olb05 = ogb32 ",   #訂單項次
#                "   AND ogb01 = oga01",
#                "   AND olb01 = ola01",
#       		"   AND olaconf = 'Y' ",             #L/C已確認
#                "   AND ola40 = 'N' ",               #未結案
#                "   AND ola09 > ola10",              #信用狀金額>已押匯金額
#        	"   AND oga09 IN ('2','8') ",        #出貨單  #No.FUN-610020
#                 "  AND oga65='N' ",  #No.FUN-610020
#        	"   AND oga02 BETWEEN '",b_date,"'",
#        	"   AND '",e_date,"'",
#        	" ORDER BY ola04,oga01 "
##------------------------------------
}
#FUN-A50102----modify---end---
 
#Mod FUN-980091 09/09/04 By TSD.apple----------------------
#-------1.add ogaplant   2.將 g_dbs_new 換成l_dbs----------
   #LET g_sql = "SELECT DISTINCT ogaplant,ola04,oga01,oga02,oga50,ogaconf,ogapost,'N',",      #FUN-A50098
    LET g_sql = "SELECT DISTINCT ola04,oga01,oga02,oga50,ogaconf,ogapost,'N',",               #FUN-A50098 del plant
                "       olc141,olc01,olc12 ",
              #FUN-A50098--mod--str--
              #"  FROM ",l_dbs CLIPPED,"ola_file,",
              #"       ",l_dbs CLIPPED,"olb_file,",
              #"       ",l_dbs CLIPPED,"oga_file,",
              #"       ",l_dbs CLIPPED,"ogb_file,",
              #"       OUTER ",l_dbs CLIPPED,"olc_file",
              #"  FROM ",cl_get_target_table(source,"ola_file"),              #MOD-C40020 mark
               "  FROM ",cl_get_target_table(source,"ola_file"),",",          #MOD-C40020 add
              #"  LEFT OUTER JOIN ",cl_get_target_table(source,"olc_file"),   #MOD-C40020 mark
              #"               ON ola04=olc04,",                              #MOD-C40020 mark
               "       ",cl_get_target_table(source,"olb_file"),",",
              #"       ",cl_get_target_table(source,"oga_file"),",",          #MOD-C40020 mark
               "       ",cl_get_target_table(source,"oga_file"),              #MOD-C40020 add
               "  LEFT OUTER JOIN ",cl_get_target_table(source,"olc_file"),   #MOD-C40020 add
               "               ON oga27=olc01,",                              #MOD-C40020 add
               "       ",cl_get_target_table(source,"ogb_file"),
              #FUN-A50098--mod--end
               #END FUN-630043
       		" WHERE ", p_wc2 CLIPPED,            #單身條件
                "   AND olb04 = ogb31 ",   #訂單單號
                "   AND olb05 = ogb32 ",   #訂單項次
                "   AND ogb01 = oga01",
                "   AND olb01 = ola01",
       		"   AND olaconf = 'Y' ",             #L/C已確認
                "   AND ola40 = 'N' ",               #未結案
                "   AND ola09 > ola10",              #信用狀金額>已押匯金額
        	"   AND oga09 IN ('2','8') ",        #出貨單  #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
        	"   AND oga02 BETWEEN '",b_date,"'",
        	"   AND '",e_date,"'",
        	" ORDER BY ola04,oga01 "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
 
      #FUN-A50098--mod--str--不展PLANT
      ##Mod FUN-980091 09/09/04 By TSD.apple(3)自動展到各階有權限的plantt---(S)
      # CALL cl_bef_sel(g_sql,l_plt_list) RETURNING g_sql
      ##Mod FUN-980091 09/09/04 By TSD.apple(3)自動展到各階有權限的plantt---(E)
       CALL cl_parse_qry_sql(g_sql,source) RETURNING g_sql
      #FUN-A50098--mod--end
 
    PREPARE q210_pb FROM g_sql
    DECLARE ola_curs CURSOR FOR q210_pb
 
#Mod FUN-980091 09/09/04 By TSD.apple 必須移到最上頭-----------------
#   FOR g_cnt = 1 TO g_ola.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_ola[g_cnt].* TO NULL
#   END FOR
#   LET g_cnt = 1
#   MESSAGE "Searching!"
#---End-------------------------------------------------
 
    FOREACH ola_curs INTO g_ola[g_cnt].*,l_olc01,l_olc12
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF NOT cl_null(l_olc01) AND cl_null(l_olc12) AND
           NOT cl_null(g_ola[g_cnt].olc141) THEN  #不能押匯
           LET g_ola[g_cnt].x = 'Y'
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
#END FOREACH   #End azp_c cursor    #FUN-A50098 mark 
 
    #CKP
    CALL g_ola.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
 
FUNCTION q210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ola TO s_ola.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ####################################################ATTRIBUTE(COUNT=g_rec_b)######################
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
