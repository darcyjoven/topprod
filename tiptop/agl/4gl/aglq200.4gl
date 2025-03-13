# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aglq200.4gl
# Descriptions...: 拋轉票來源查詢
# Date & Author..: 97/11/26 By CONNIE
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530286 05/03/25 By saki 將中文字轉成訊息檔多語言,權限設定
# Modify.........: No.FUN-5A0072 05/11/10 By ice 更新傳遞參數,為可以被saglt110調用
# Modify.........: NO.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/13 By sherry  會計科目加帳套
# Modify.........: No.TQC-740148 07/04/22 By sherry  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780127 07/08/21 By Sarah 1.明細查詢無法查aapt160,aapt260來源單據
#                                                  2.查詢時應將aba00納入CONSTRUCT組出來的tm.wc裡，而非另外用s_aba.aba00去指定要抓那個帳別的資料
# Modify.........: No.MOD-810007 08/01/08 By Smapmin 應收票據收票作業無法串查得到
# Modify.........: No.CHI-870020 08/07/14 By Sarah q200_detail()段增加aba06 = 'NM' AND npp00 = '11'條件,CALL anmt850
# Modify.........: No.CHI-870010 08/07/24 By Sarah q200_detail()段增加aba06 = 'LC'等相關條件
# Modify.........: No.CHI-8A0023 08/11/04 By Sarah q200_detail()段增加aba06 = 'AP ' AND npp00 = '4'條件,CALL aapt900
# Modify.........: No.MOD-920061 09/02/06 By Sarah q200_b_fill()段抓分錄底稿時,應只抓npp06是g_plant的資料出來
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()    
# Modify.........: No.MOD-980073 09/08/12 By mike aglq200須再加入串查到anmt740之功能，另單身備注資料亦須補上。
# Modify.........: No.MOD-980126 09/08/17 By Sarah aglq200須再加入串查到anmt710與anmt750之功能，另單身備注資料亦須補上。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/30 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.TQC-990152 09/10/09 By wujie  單身顯示的營運中心錯，應該是單身憑証所在的營運中心
# Modify.........: No:MOD-9A0196 09/10/30 By Sarah q200_detail()段增加串查aapt121/151/210/220/331
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:MOD-A50187 10/05/27 By Elva q200_detail()段增加串查gapq600,gnmq610,gnmq600,gxrq600,afai104
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No:TQC-AB0399 10/12/01 By wuxj 隐藏营运中心编号，跨DB改为不跨DB
# Modify.........: No:TQC-BB0021 11/12/20 By Dido 如為拋轉帳,則需在此查詢來源傳票 
# Modify.........: No:MOD-CA0180 12/10/25 By yinhy 增加備註欄位信息
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.TQC-D20046 13/02/25 By xuxz 發出商品問題修改
# Modify.........: No.MOD-D40027 13/04/03 By apo 依據沖帳性質ooa37來判定串查程式
# Modify.........: No.FUN-D60095 13/06/24 By max1  來源碼為CA時，增加串查
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm    RECORD
              wc  STRING		# Head Where condition   #No.FUN-680098  VARCHAR(600) #TQC-BB0021 mod 1000 -> STRING
             END RECORD,
       s_aba RECORD   LIKE aba_file.*      ,
       g_aba DYNAMIC ARRAY OF RECORD
              plant   LIKE azp_file.azp01,
              npp01   LIKE npp_file.npp01,
              npp02   LIKE npp_file.npp02,
              desc    LIKE ze_file.ze03       #No.FUN-680098  VARCHAR(40)
             END RECORD,
       t_aba DYNAMIC ARRAY OF RECORD
              npp00   LIKE npp_file.npp00,
              npp011  LIKE npp_file.npp011,
              azp03   LIKE azp_file.azp03,
              apa00   LIKE apa_file.apa00,
              apf00   LIKE apf_file.apf00,    #MOD-9A0196 add
              ooa37   LIKE ooa_file.ooa37     #MOD-D40027 add
             END RECORD,
       g_bookno        LIKE aba_file.aba00,   # INPUT ARGUMENT - 1
       g_aba01         LIKE aba_file.aba01,   #No.FUN-5A0072
       g_wc,g_sql      STRING,                #WHERE CONDITION   #No.FUN-580092 HCN        
       p_row,p_col     LIKE type_file.num5,   #No.FUN-680098  smallilnt
       g_rec_b         LIKE type_file.num5    #單身筆數   #No.FUN-680098 smallint
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680098  integer
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_msg           LIKE ze_file.ze03      #No.FUN-680098  VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680098 integer
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680098 integer
DEFINE g_jump          LIKE type_file.num10   #No.FUN-680098 integer
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680098 smallint
DEFINE l_dbs_tra       LIKE type_file.chr21   #FUN-980091
 
MAIN
      DEFINE    l_sl		LIKE type_file.num5          #No.FUN-680098         smallint
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680098         smallint
 
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
 
 
    LET s_aba.aba00   = ARG_VAL(1)          #參數值(1) Part#   No.FUN-740020
    LET g_aba01       = ARG_VAL(2)          #No.FUN-5A0072
 
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW aglq200_w AT p_row,p_col
         WITH FORM "agl/42f/aglq200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("plant",FALSE)    #TQC-AB0399 add
 
    IF NOT cl_null(s_aba.aba00) OR NOT cl_null(s_aba.aba00) THEN   #No.FUN-5A0072    #No.FUN-740020
       CALL q200_q()
    END IF
 
    CALL q200_menu()
    CLOSE WINDOW aglq200_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q200_cs()
   DEFINE   l_cnt     LIKE type_file.num5          #No.FUN-680098  smallint
 
   CLEAR FORM #清除畫面
   CALL g_aba.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   IF NOT cl_null(g_aba01) THEN
      LET tm.wc = "aba01 = '",g_aba01,"' "
      IF NOT cl_null(s_aba.aba00) THEN
         LET tm.wc = tm.wc," AND aba00 = '",s_aba.aba00,"' "
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
      INITIALIZE s_aba.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON            # 螢幕上取單頭條件
         aba01,aba02,aba11,aba00,aba06,aba08,aba09,abapost   #No.FUN-740020
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp                                                                                                            
            CASE                                                                                                                       
              WHEN INFIELD(aba00) #異動碼類型代號                                                                                      
                   CALL cl_init_qry_var()                                                                                                
                   LET g_qryparam.form  = "q_aaa"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
                   DISPLAY g_qryparam.multiret TO aba00                                                                                  
                   NEXT FIELD aba00   
              OTHERWISE EXIT CASE                                                                                                      
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
      IF INT_FLAG THEN RETURN END IF
   END IF  #No.FUN-5A0072
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
 
   LET g_sql="SELECT aba01,aba00 FROM aba_file",           #MOD-780127 add aba00
             " WHERE ",tm.wc CLIPPED,     #No.FUN-740020   #MOD-780127 mod
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba06 NOT IN ('GL','RV','AC','CE') "
   PREPARE q200_prepare FROM g_sql
   DECLARE q200_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q200_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM aba_file ",
             " WHERE ",tm.wc CLIPPED,     #No.FUN-740020   #MOD-780127 mod
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba06 NOT IN ('GL','RV','AC','CE') "
   PREPARE q200_prepare_cnt FROM g_sql
   DECLARE q200_count CURSOR FOR q200_prepare_cnt
 
END FUNCTION
 
FUNCTION q200_menu()
 
   WHILE TRUE
      CALL q200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q200_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aba),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q200_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q200_count
       FETCH q200_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10      #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q200_cs INTO s_aba.aba01,s_aba.aba00   #MOD-780127 add aba00
        WHEN 'P' FETCH PREVIOUS q200_cs INTO s_aba.aba01,s_aba.aba00   #MOD-780127 add aba00
        WHEN 'F' FETCH FIRST    q200_cs INTO s_aba.aba01,s_aba.aba00   #MOD-780127 add aba00
        WHEN 'L' FETCH LAST     q200_cs INTO s_aba.aba01,s_aba.aba00   #MOD-780127 add aba00
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
            FETCH ABSOLUTE g_jump q200_cs INTO s_aba.aba01,s_aba.aba00   #MOD-780127 add aba00
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(s_aba.aba01,SQLCA.sqlcode,0)
        INITIALIZE s_aba.* TO NULL  #TQC-6B0105
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
 
    CALL q200_show()
END FUNCTION
 
FUNCTION q200_show()
   SELECT * INTO s_aba.* FROM aba_file
    WHERE aba01 = s_aba.aba01 
      AND aba00 = s_aba.aba00   #No.FUN-740020
   DISPLAY BY NAME s_aba.aba01,s_aba.aba02,s_aba.aba06,s_aba.abapost,
                   s_aba.aba11,s_aba.aba08,s_aba.aba09,s_aba.aba00     #No.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
   DISPLAY "!" TO abapost
   END IF
   CALL q200_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q200_b_fill()              #BODY FILL UP
   DEFINE g_azp     RECORD LIKE azp_file.*
   DEFINE l_plant   LIKE azp_file.azp03
   DEFINE l_sql1,l_sql2        STRING,   #No.FUN-680098 VARCHAR(400) #TQC-BB0021 mod 1000 -> STRING
          l_str,l_str1,l_str2  LIKE type_file.chr20      #No.FUN-680098 VARCHAR(20) 
   DEFINE lc_msg    LIKE ze_file.ze03
   DEFINE lc_code   LIKE ze_file.ze01
   DEFINE l_aba00   LIKE aba_file.aba00         #TQC-BB0021
   DEFINE l_aba01   LIKE aba_file.aba01         #TQC-BB0021
   DEFINE l_cdj00   LIKE cdj_file.cdj00         #TQC-D20046 add
   DEFINE l_cdg00   LIKE cdg_file.cdg00         #FUN-D60095 add

   FOR g_cnt = 1 TO g_aba.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_aba[g_cnt].* TO NULL
       INITIALIZE t_aba[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
 
  #-TQC-BB0021-add- 
   SELECT aba00,aba01 INTO l_aba00,l_aba01
    FROM aba_file
    WHERE aba16 = s_aba.aba00
      AND aba17 = s_aba.aba01
   IF NOT cl_null(l_aba00) THEN
      LET s_aba.aba00 = l_aba00
      LET s_aba.aba01 = l_aba01
   END IF
  #-TQC-BB0021-end- 
#TQC-AB0399 ---begin---
#  DECLARE a_curs CURSOR FOR
#   SELECT * FROM azp_file
#    WHERE azp053 != 'N'       #no.7431 ERP資料庫
#      AND azp01 IN(SELECT azw01 FROM azw_file WHERE azwacti = 'Y')  #FUN-A50102
#  FOREACH a_curs INTO g_azp.*
#
#      LET g_plant_new = g_azp.azp01
#      CALL s_gettrandbs()
#      LET l_dbs_tra = g_dbs_tra
#      LET g_azp.azp03 = s_dbstring(g_azp.azp03 CLIPPED)
#TQC--AB0399 ---END---
       LET l_sql1 =
          # "SELECT '",g_azp.azp01,"',npp01,npp02,' ',npp00,npp011,' ',' ',' ' ",    #No.TQC-990152  #MOD-9A0196 add ' '
          #"  FROM ",s_dbstring(g_azp.azp03),"npp_file ",            #TQC-950003 ADD #FUN-A50102       
        #  "  FROM ",cl_get_target_table(g_azp.azp01,'npp_file'),    #FUN-A50102   #TQC-AB0399
          #"SELECT '',npp01,npp02,' ',npp00,npp011,' ',' ',' ' ",    #MOD-D40027 mark   #TQC-AB0399
           "SELECT '',npp01,npp02,' ',npp00,npp011,' ',' ',' ',' '", #MOD-D40027
           "  FROM npp_file ",                                                     #TQC-AB0399
           " WHERE npp06 = '",g_plant,"'",      #MOD-920061 mark
           "   AND npp07 = '",s_aba.aba00,"'",  # npp_file add index  ??? #No.FUN-740020
           "   AND nppglno = '",s_aba.aba01,"'",
           " ORDER BY 1,2"
       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1   #FUN-A50102
       CALL cl_parse_qry_sql(l_sql1,g_azp.azp01) RETURNING l_sql1   #FUN-A50102
       PREPARE q200_pb FROM l_sql1
       DECLARE q200_bcs                       #BODY CURSOR
           CURSOR FOR q200_pb
       FOREACH q200_bcs INTO g_aba[g_cnt].*,t_aba[g_cnt].*
           LET l_str = ' '
           IF g_cnt=1 THEN
               LET g_rec_b=SQLCA.SQLERRD[3]
           END IF
        #  LET t_aba[g_cnt].azp03 = g_azp.azp03   #TQC-AB0399
           CASE
               WHEN s_aba.aba06 = 'NM' AND t_aba[g_cnt].npp00 = '1'
                   #FUN-A50102--mod--str--
                   #LET l_sql2 = "SELECT npl03 FROM ",s_dbstring(g_azp.azp03),   #TQC-950003 add  
                   #    "npl_file WHERE npl01 = '",g_aba[g_cnt].npp01,"'"        #TQC-950003 ADD   
                  # LET l_sql2 = "SELECT npl03 FROM ",cl_get_target_table(g_azp.azp01,'npl_file'),
                    LET l_sql2 = "SELECT npl03 FROM npl_file ",    #TQC-AB0399
                                 " WHERE npl01 = '",g_aba[g_cnt].npp01,"'"
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2   #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2   #FUN-A50102
                   #FUN-A50102--mod--end
                    PREPARE e_str1 FROM l_sql2
                    IF SQLCA.SQLCODE THEN
                       EXIT FOREACH
                    END IF
                    DECLARE b1_curs CURSOR FOR e_str1
                    OPEN b1_curs
                    FETCH b1_curs INTO l_str
                     CASE                            # MOD-530286
                       WHEN l_str = '1'
                            LET lc_code = "agl-401"
                       WHEN l_str = '6'
                            LET lc_code = "agl-402"
                       WHEN l_str = '7'
                            LET lc_code = "agl-403"
                       WHEN l_str = '8'
                            LET lc_code = "agl-404"
                       WHEN l_str = '9'
                            LET lc_code = "agl-405"
                    END CASE
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b1_curs
               WHEN s_aba.aba06 = 'NM' AND t_aba[g_cnt].npp00 = '2'
                   #FUN-A50102--mod--str--
                   #LET l_sql2 = "SELECT npn03 FROM ",s_dbstring(g_azp.azp03),   #TQC-950003 ADD                                    
                   #    "npn_file WHERE npn01 = '",g_aba[g_cnt].npp01,"'"        #TQC-950003 ADD  
                   #LET l_sql2 = "SELECT npn03 FROM ",cl_get_target_table(g_azp.azp01,'npn_file'),
                    LET l_sql2 = "SELECT npn03 FROM npn_file ",  #TQC-AB0399
                                 " WHERE npn01 = '",g_aba[g_cnt].npp01,"'" 
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2  #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2  #FUN-A50102
                   #FUN-A50102--mod--end
                    PREPARE e_str2 FROM l_sql2
                    DECLARE b2_curs CURSOR FOR e_str2
                    OPEN b2_curs
                    FETCH b2_curs INTO l_str
                     CASE                                # MOD-530286
                       WHEN l_str = '2'
#                           LET g_aba[g_cnt].desc = "應收票據異動-託收"
                            LET lc_code = "agl-407"
                       WHEN l_str = '3'
#                           LET g_aba[g_cnt].desc = "應收票據異動-質押"
                            LET lc_code = "agl-408"
                       WHEN l_str = '4'
#                           LET g_aba[g_cnt].desc = "應收票據異動-貼現"
                            LET lc_code = "agl-409"
                       WHEN l_str = '6'
#                           LET g_aba[g_cnt].desc = "應收票據異動-撤票"
                            LET lc_code = "agl-410"
                       WHEN l_str = '7'
#                           LET g_aba[g_cnt].desc = "應收票據異動-退票"
                            LET lc_code = "agl-411"
                       WHEN l_str = '8'
#                           LET g_aba[g_cnt].desc = "應收票據異動-兌現"
                            LET lc_code = "agl-412"
                       OTHERWISE   #MOD-810007
                            LET lc_code = "agl-406"   #MOD-810007
                    END CASE
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b2_curs
               WHEN s_aba.aba06 = 'NM' AND t_aba[g_cnt].npp00 = '3'
                    LET lc_code = "agl-413"
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'NM' AND t_aba[g_cnt].npp00 = '6'                                                                 
                    LET lc_code = "anm-959"                                                                                         
                    SELECT ze03 INTO lc_msg FROM ze_file                                                                            
                     WHERE ze01 = lc_code AND ze02 = g_lang                                                                         
                    LET g_aba[g_cnt].desc = lc_msg     
               WHEN s_aba.aba06 ='NM' AND t_aba[g_cnt].npp00 = '16'
                    LET lc_code = "anm-213"
                    SELECT ze03 INTO lc_msg FROM ze_file                        
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 ='NM' AND t_aba[g_cnt].npp00 = '7'
                    LET lc_code = "anm-641"
                    SELECT ze03 INTO lc_msg FROM ze_file                        
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'AP' AND t_aba[g_cnt].npp00 = '1'
                   #FUN-A50102--mod--str--
                   #LET l_sql2 = "SELECT apa07,apa00 FROM ",s_dbstring(g_azp.azp03),   #TQC-950003 ADD                              
                   #    "apa_file WHERE apa01 = '",g_aba[g_cnt].npp01,"'"              #TQC-950003 ADD    
                   #LET l_sql2 = "SELECT apa07,apa00 FROM ",cl_get_target_table(g_azp.azp01,'apa_file'),
                    LET l_sql2 = "SELECT apa07,apa00 FROM apa_file ", #TQC-AB0399 
                                 " WHERE apa01 = '",g_aba[g_cnt].npp01,"'"
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2   #FUN-A50102
                   #FUN-A50102--mod--end
                    PREPARE e_str3 FROM l_sql2
                    DECLARE b3_curs CURSOR FOR e_str3
                    OPEN b3_curs
                    FETCH b3_curs INTO l_str,t_aba[g_cnt].apa00
                    CLOSE b3_curs
                    CASE
                       WHEN t_aba[g_cnt].apa00 = '11'
#                           LET l_str2 = '進貨發票'
                            LET lc_code = "agl-415"
                       WHEN t_aba[g_cnt].apa00 = '12'
#                           LET l_str2 = '雜項發票'
                            LET lc_code = "agl-416"
                       WHEN t_aba[g_cnt].apa00 = '15'
#                           LET l_str2 = '預付申請'
                            LET lc_code = "agl-417"
                       WHEN t_aba[g_cnt].apa00 = '21'
#                           LET l_str2 = '進貨折讓'
                            LET lc_code = "agl-418"
                    END CASE
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-414" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    SELECT ze03 INTO l_str2 FROM ze_file
                     WHERE ze01 = lc_code AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = g_aba[g_cnt].desc CLIPPED,l_str2 CLIPPED,"-",l_str CLIPPED
               WHEN s_aba.aba06 = 'AP' AND t_aba[g_cnt].npp00 = '3'
                  #FUN-A50102--mod--str--
                  # LET l_sql2 = "SELECT apf12,apf00 FROM ",s_dbstring(g_azp.azp03),    #TQC-950003 ADD  #MOD-9A0196 add apf00
                  #     "apf_file WHERE apf01 = '",g_aba[g_cnt].npp01,"'"         #TQC-950003 ADD       
                  # LET l_sql2 = "SELECT apf12,apf00 FROM ",cl_get_target_table(g_azp.azp01,'apf_file'),
                    LET l_sql2 = "SELECT apf12,apf00 FROM apf_file ", #TQC-AB0399
                                 " WHERE apf01 = '",g_aba[g_cnt].npp01,"'"
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2
                  #FUN-A50102--mod--end
                    PREPARE e_str4 FROM l_sql2
                    DECLARE b4_curs CURSOR FOR e_str4
                    OPEN b4_curs
                    FETCH b4_curs INTO l_str,t_aba[g_cnt].apf00   #MOD-9A0196 add apf00
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-419" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b4_curs
               WHEN s_aba.aba06 = 'LC' AND t_aba[g_cnt].npp00 = '4'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-420" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'LC' AND t_aba[g_cnt].npp00 = '5'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-421" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'AR' AND t_aba[g_cnt].npp00 = '1'
                   #FUN-A50102--mod--str--
                   #LET l_sql2 = "SELECT occ02 FROM ",s_dbstring(l_dbs_tra),   #FUN-980091
                   #    "oga_file ,",s_dbstring(g_azp.azp03),"occ_file ",      #TQC-950003 ADD  
                    LET l_sql2 = "SELECT occ02 ",
                                #TQC-AB0399 ---BEGIN---
                                #"  FROM ",cl_get_target_table(g_azp.azp01,'oga_file'),
                                #"      ,",cl_get_target_table(g_azp.azp01,'occ_file'),
                                 "  FROM oga_file,occ_file ",
                                #TQC-AB0399 ---end --
                   #FUN-A50102--mod--end
                        " WHERE oga01 = '",g_aba[g_cnt].npp01,"'" ,
                        "AND oga04 = occ01 "
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2   #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql2,g_plant_new) RETURNING l_sql2 #FUN-980091
                    PREPARE e_str5 FROM l_sql2
                    DECLARE b5_curs CURSOR FOR e_str5
                    OPEN b5_curs
                    FETCH b5_curs INTO l_str
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-422" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b5_curs
               WHEN s_aba.aba06 = 'AR' AND t_aba[g_cnt].npp00 = '2'
                  #FUN-A50102--mod--str--
                  # LET l_sql2 = "SELECT oma032 FROM ",s_dbstring(g_azp.azp03),     #TQC-950003 ADD                                 
                  #     "oma_file WHERE oma01 = '",g_aba[g_cnt].npp01,"'"           #TQC-950003 ADD 
                  # LET l_sql2 = "SELECT oma032 FROM ",cl_get_target_table(g_azp.azp01,'oma_file'),
                    LET l_sql2 = "SELECT oma032 FROM oma_file ", #TQC-AB0399 
                                 " WHERE oma01 = '",g_aba[g_cnt].npp01,"'" 
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2   #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2 #FUN-A50102
                  #FUN-A50102--mod--end
                    PREPARE e_str6 FROM l_sql2
                    DECLARE b6_curs CURSOR FOR e_str6
                    OPEN b6_curs
                    FETCH b6_curs INTO l_str
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-423" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b6_curs
               WHEN s_aba.aba06 = 'AR' AND t_aba[g_cnt].npp00 = '3'
                   #FUN-A50102--mod--str--
                   #LET l_sql2 = "SELECT ooa032 FROM ",s_dbstring(g_azp.azp03),   #TQC-950003 ADD                                   
                   #    "ooa_file WHERE ooa01 = '",g_aba[g_cnt].npp01,"'"         #TQC-950003 ADD         
                   #LET l_sql2 = "SELECT ooa032 FROM ",cl_get_target_table(g_azp.azp01,'ooa_file'),
                   #LET l_sql2 = "SELECT ooa032 FROM ooa_file ",       #MOD-D40027 mark   #TQC-AB0399 
                    LET l_sql2 = "SELECT ooa032,ooa37 FROM ooa_file ", #MOD-D40027 
                                 " WHERE ooa01 = '",g_aba[g_cnt].npp01,"'"
                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2   #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql2,g_azp.azp01) RETURNING l_sql2 #FUN-A50102
                   #FUN-A50102--mod--end
                    PREPARE e_str7 FROM l_sql2
                    DECLARE b7_curs CURSOR FOR e_str7
                    OPEN b7_curs
                   #FETCH b7_curs INTO l_str                      #MOD-D40027 mark
                    FETCH b7_curs INTO l_str,t_aba[g_cnt].ooa37   #MOD-D40027 
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-424" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
                    CLOSE b7_curs
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '1'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-425" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '7'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-426" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '8'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-427" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '4'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-428" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '5'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-429" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '6'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-430" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               WHEN s_aba.aba06 = 'FA' AND t_aba[g_cnt].npp00 = '9'
                    SELECT ze03 INTO lc_msg FROM ze_file
                     WHERE ze01 = "agl-431" AND ze02 = g_lang
                    LET g_aba[g_cnt].desc = lc_msg
               #No.MOD-CA0180  --Begin
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '8'
                    LET g_aba[g_cnt].desc = 'axcq310'
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '2'
                    LET g_aba[g_cnt].desc = 'axct320'
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '3'
               # LET g_aba[g_cnt].desc = 'axct328'   #mark by max1 13/06/24
              #FUN-D60095--add--str--
                  SELECT DISTINCT cdg00 INTO l_cdg00 FROM cdg_file
                     WHERE cdg05 = g_aba[g_cnt].npp01
                  IF l_cdg00 = '1' THEN 
                     LET g_aba[g_cnt].desc = 'axct328'
                  ELSE
                     LET g_aba[g_cnt].desc = 'axct327'
                  END IF 
                  #FUN-D60095--add--end--
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '4'
                    #TQC-D20046-add-str
                    SELECT DISTINCT cdj00 INTO l_cdj00 FROM cdj_file
                     WHERE cdj13 = g_aba[g_cnt].npp01
                    #TQC-D20046-add--end
                    IF l_cdj00 = 1 THEN
                    #TQC-D20046-add--end
                       LET g_aba[g_cnt].desc = 'axct322'
                    #TQC-D20046-add--str
                    ELSE
                       LET g_aba[g_cnt].desc = 'axct330'
                    END IF
                    #TQC-D20046-add--end
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '6'
                    LET g_aba[g_cnt].desc = 'axct324'
               WHEN s_aba.aba06 = 'CA' AND t_aba[g_cnt].npp00 = '7'
                    LET g_aba[g_cnt].desc = 'axct325'
               #No.MOD-CA0180  --End
           END CASE
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
       END FOREACH
#   END FOREACH     #TQC-AB0399  MARK 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
    DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
 
FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         CALL q200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q200_fetch('L')
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
 
      #@ON ACTION 明細查詢
      ON ACTION query_details
          LET g_action_choice="query_details"            # MOD-530286
         IF cl_chk_act_auth() THEN
             LET g_action_choice = NULL
             LET g_i = ARR_CURR()
             IF g_aba[g_i].npp01 <> ' ' AND g_aba[g_i].npp01 IS NOT NULL THEN
                CALL q200_detail()
             END IF
         ELSE
             LET g_action_choice = NULL
         END IF
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
END FUNCTION
 
FUNCTION q200_detail()
   DEFINE l_cmd     LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(200) 
   DEFINE l_sql     STRING       #MOD-810007     #TQC-BB0021 mod 1000 -> STRING
   DEFINE l_str     LIKE type_file.chr20         #MOD-810007
   DEFINE l_yy      LIKE type_file.num5    #MOD-A50187 
   DEFINE l_mm      LIKE type_file.num5    #MOD-A50187
   DEFINE l_wc      LIKE type_file.chr1000   #MOD-A50187   
   DEFINE l_cdj00   LIKE cdj_file.cdj00   #FUN-D60095 add 
   DEFINE l_msg     STRING                #FUN-D60095 add 
   DEFINE l_cdg00   LIKE cdg_file.cdg00   #FUN-D60095 add 
 
   CASE
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '1'
          LET l_cmd =  "anmt150 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '2'
          SELECT nmz02p INTO g_nmz.nmz02p FROM nmz_file 
          LET g_plant_new = g_nmz.nmz02p
          CALL s_getdbs()
          LET l_sql = "SELECT npn03 FROM ",g_dbs_new CLIPPED,
              "npn_file WHERE npn01 = '",g_aba[g_i].npp01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE e_str8 FROM l_sql
          DECLARE b8_curs CURSOR FOR e_str8
          OPEN b8_curs
          FETCH b8_curs INTO l_str
          IF l_str <> '1' THEN 
             LET l_cmd =  "anmt250 ","'",g_aba[g_i].npp01,"' "
          ELSE
             LET l_cmd =  "anmt200 ","'",g_aba[g_i].npp01,"' "
          END IF 
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '3'
          LET l_cmd =  "anmt302 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '6'        #MOD-980073                                                                     
          LET l_cmd =  "anmt740 ","'",g_aba[g_i].npp01,"' "    #MOD-980073 
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '16'
          LET l_cmd =  "anmt710 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '7'
          LET l_cmd =  "anmt750 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '11'
          LET l_cmd =  "anmt850 ","'",g_aba[g_i].npp01,"' "
     #MOD-A50187 --begin
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '13'     
          LET l_yy=g_aba[g_i].npp01[3,6]
          LET l_mm=g_aba[g_i].npp01[7,8]
          LET l_wc = 'oox00 = "NM" AND oox01 = ',l_yy,' AND oox02 = ',l_mm
          LET l_cmd = "gnmq600 '",l_wc CLIPPED,"'"
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '14'     
          LET l_yy=g_aba[g_i].npp01[3,6]
          LET l_mm=g_aba[g_i].npp01[7,8]
          LET l_wc = ' oox01 = ',l_yy,' AND oox02 = ',l_mm
          LET l_cmd = "gnmq610 '1' '",l_wc CLIPPED,"'"
     WHEN s_aba.aba06 = 'NM' AND t_aba[g_i].npp00 = '15'     
          LET l_yy=g_aba[g_i].npp01[3,6]
          LET l_mm=g_aba[g_i].npp01[7,8]
          LET l_wc = ' oox01 = ',l_yy,' AND oox02 = ',l_mm
          LET l_cmd = "gnmq610 '2' '",l_wc CLIPPED,"'"
     #MOD-A50187 --end
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND
          t_aba[g_i].apa00 ='11'
          LET l_cmd =  "aapt110 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND
          t_aba[g_i].apa00 ='12'
          LET l_cmd =  "aapt120 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND   #MOD-9A0196 add
          t_aba[g_i].apa00 ='13'                              #MOD-9A0196 add
          LET l_cmd =  "aapt121 ","'",g_aba[g_i].npp01,"' "   #MOD-9A0196 add
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND
          t_aba[g_i].apa00 ='15'
          LET l_cmd =  "aapt150 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND   #MOD-9A0196 add
          t_aba[g_i].apa00 ='17'                              #MOD-9A0196 add
          LET l_cmd =  "aapt151 ","'",g_aba[g_i].npp01,"' "   #MOD-9A0196 add
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND   #MOD-9A0196 add
          t_aba[g_i].apa00 ='21'                              #MOD-9A0196 add
          LET l_cmd =  "aapt210 ","'",g_aba[g_i].npp01,"' "   #MOD-9A0196 add
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND   #MOD-9A0196 add
          t_aba[g_i].apa00 ='22'                              #MOD-9A0196 add
          LET l_cmd =  "aapt220 ","'",g_aba[g_i].npp01,"' "   #MOD-9A0196 add
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '3' AND
          t_aba[g_i].apf00 = '33'                             #MOD-9A0196 add
          LET l_cmd =  "aapt330 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '3' AND   #MOD-9A0196 add
          t_aba[g_i].apf00 = '34'                             #MOD-9A0196 add
          LET l_cmd =  "aapt331 ","'",g_aba[g_i].npp01,"' "   #MOD-9A0196 add
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '4'
          LET l_cmd =  "aapt900 ","'",g_aba[g_i].npp01,"' "
     #MOD-A50187 --begin
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '5'     
          LET l_yy=g_aba[g_i].npp01[3,6]
          LET l_mm=g_aba[g_i].npp01[7,8]
          LET l_wc = 'oox00 = "AP" AND oox01 = ',l_yy,' AND oox02 = ',l_mm
          LET l_cmd = "gapq600 '",l_wc CLIPPED,"'"
     #MOD-A50187 --end
     #暫估
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND
          t_aba[g_i].apa00 ='16'
          LET l_cmd =  "aapt160 ","'",g_aba[g_i].npp01,"' "
     #暫估退貨
     WHEN s_aba.aba06 = 'AP' AND t_aba[g_i].npp00 = '1' AND
          t_aba[g_i].apa00 ='26'
          LET l_cmd =  "aapt260 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=4 AND t_aba[g_i].npp011=0
          LET l_cmd =  "aapt720 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=4 AND t_aba[g_i].npp011=1
          LET l_cmd =  "aapt810 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=4 AND t_aba[g_i].npp011=2
          LET l_cmd =  "aapt820 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=5 AND t_aba[g_i].npp011=0
          LET l_cmd =  "aapt711 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=6
          LET l_cmd =  "aapt740 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=7
          LET l_cmd =  "aapt741 ","'",g_aba[g_i].npp01,"' '",t_aba[g_i].npp011,"' "
     WHEN s_aba.aba06 = 'LC' AND t_aba[g_i].npp00=9 AND t_aba[g_i].npp011=0
          LET l_cmd =  "aapt750 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '1'
          LET l_cmd =  "axmt620 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '2'
          LET l_cmd =  "axrt300 ","'",g_aba[g_i].npp01,"' '' '",t_aba[g_i].npp00,"' " #TQC-630066
    #WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '3'       #MOD-D40027 mark
    #     LET l_cmd =  "axrt400 ","'",g_aba[g_i].npp01,"' ''" #MOD-D40027 mark   #TQC-630066
    #--MOD-D40027--(S)
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '3' AND t_aba[g_i].ooa37 ='1'
          LET l_cmd =  "axrt400 ","'",g_aba[g_i].npp01,"' ''" 
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '3' AND t_aba[g_i].ooa37 ='2'
          LET l_cmd =  "axrt410 ","'",g_aba[g_i].npp01,"' ''" 
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '3' AND t_aba[g_i].ooa37 ='3'
          LET l_cmd =  "axrt401 ","'",g_aba[g_i].npp01,"' ''" 
    #--MOD-D40027--(E)
     #MOD-A50187 --begin
     WHEN s_aba.aba06 = 'AR' AND t_aba[g_i].npp00 = '4'
          LET l_yy=g_aba[g_i].npp01[3,6]
          LET l_mm=g_aba[g_i].npp01[7,8]
          LET l_wc = 'oox00 = "AR" AND oox01 = ',l_yy,' AND oox02 = ',l_mm
          LET l_cmd = "gxrq600 '",l_wc CLIPPED,"'"
     #MOD-A50187 --end
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '1'
          LET l_cmd =  "afat101 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '7'
          LET l_cmd =  "afat105 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '8'
          LET l_cmd =  "afat106 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '4'
          LET l_cmd =  "afat110 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '5'
          LET l_cmd =  "afat108 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '6'
          LET l_cmd =  "afat109 ","'",g_aba[g_i].npp01,"' "
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '9'
          LET l_cmd =  "afat107 ","'",g_aba[g_i].npp01,"' "
     #MOD-A50187 --begin
     WHEN s_aba.aba06 = 'FA' AND t_aba[g_i].npp00 = '10'
          LET l_cmd =  "afai104 'FA' '10' '",g_aba[g_i].npp01,"'"
     #MOD-A50187 --end

    #FUN-D60095--add--str--
     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '8'
         LET l_msg =' cdb13="',g_aba[g_i].npp01,'"'
         LET l_cmd =  "axcq310 '",l_msg,"' "
                    
     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '2'
         LET l_msg =' cde05="',g_aba[g_i].npp01,'"'
         LET l_cmd =  "axct320 '",l_msg,"' "
                   
     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '3'
         LET l_msg =' cdg05="',g_aba[g_i].npp01,'"'
         
         #FUN-D60095--add--str--
         SELECT DISTINCT cdg00 INTO l_cdg00 FROM cdg_file
          WHERE cdg05 = g_aba[g_i].npp01
         IF l_cdg00 = '1' THEN 
            LET l_cmd =  "axct321  '1' '",l_msg,"' "  #axct328调用的axct321 ‘1’
         ELSE
            LET l_cmd =  "axct321  '2' '",l_msg,"' "  #axct327调用的axct321 ‘2’
         END IF 
         #FUN-D60095--add--end--
                   
     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '4'
         SELECT DISTINCT cdj00 INTO l_cdj00 FROM cdj_file
          WHERE cdj13 = g_aba[g_i].npp01
         LET l_msg =' cdj13="',g_aba[g_i].npp01,'"'                             
         IF l_cdj00 = 1 THEN  
            LET l_cmd =  "axct322 '",l_msg,"' "
         ELSE
            LET l_cmd =  "axct330 '",l_msg,"' "
         END IF
                   
     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '6'
         LET l_msg =' cdl11="',g_aba[g_i].npp01,'"' 
         LET l_cmd =  "axct324 '",l_msg,"' "

     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '7'
         LET l_msg =' cdl12="',g_aba[g_i].npp01,'"' 
         LET l_cmd =  "axct325 '",l_msg,"' "

     WHEN s_aba.aba06 = 'CA' AND t_aba[g_i].npp00 = '9'
         LET l_msg =' cdm10="',g_aba[g_i].npp01,'"'
         LET l_cmd =  "axct329 ","'",l_msg,"' "
     #FUN-D60095--add--end--
   END CASE
   IF cl_null(l_cmd) THEN RETURN END IF   #MOD-9A0196 add
   CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
END FUNCTION
#No.FUN-9C0072 精簡程式碼
