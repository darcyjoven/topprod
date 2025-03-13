# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abaq102
# Descriptions...: 倉庫料件數量查詢
# Date & Author..: 91/11/06 By Carol
# Modify ........: 00/03/14 By Carol747:add img37 field
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-640006 06/04/04 By Claire 加入品名規格
# Modify.........: No.TQC-650115 06/05/25 By wujie  料件多屬性修改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6A0130 06/12/11 By Claire 調整品名規格位置,因轉出excel欄位不符
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-780080 07/09/19 By Pengu SQL使用OUTER未按照標準程序加上table.欄位
# Modify.........: No.MOD-810252 08/02/14 By Pengu 下*查詢所有資料時，單身ARRAY筆數會異常
# Modify.........: No.MOD-860056 08/06/13 By claire 單身加入construct
# Modify.........: No.CHI-890031 08/09/25 By claire 單身加入construct
# Modify.........: No.FUN-920152 09/03/06 By jan 倉庫，庫位，批號 開窗
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B90146 11/09/22 By johung 加大tm.wc、tm.wc2長度
# Modify.........: No.TQC-CC0003 12/12/03 By qirl 增加庫位名稱
IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
 
DEFINE
    tm          RECORD
               #wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
               #wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD,
    g_tc_ibb_m       RECORD
                tc_ibb03	 LIKE tc_ibb_file.tc_ibb03,# 料件編號
                tc_ibb04	 LIKE tc_ibb_file.tc_ibb04 # 倉庫編號
                END RECORD,
    g_tc_ibb_d       DYNAMIC ARRAY OF RECORD
                 tc_ibb06   LIKE tc_ibb_file.tc_ibb06,
               ima01      LIKE ima_file.ima01,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               ima25      LIKE ima_file.ima25,
               tc_ibb21   LIKE tc_ibb_file.tc_ibb21,
               tc_ibb05   LIKE tc_ibb_file.tc_ibb05,
               tc_ibb07   LIKE tc_ibb_file.tc_ibb07,
               tc_ibb17   LIKE tc_ibb_file.tc_ibb17,
               tc_ibb01   LIKE tc_ibb_file.tc_ibb01,
               chk1       LIKE type_file.chr1   
                END RECORD,
    l_img23     LIKE img_file.img23,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_argv2     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_sql       string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5       #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT

MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW abaq102_w AT p_row,p_col
         WITH FORM "aba/42f/abaq102"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q401_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q102_q() END IF
    CALL q102_menu()
    CLOSE WINDOW q102_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q102_cs()
DEFINE  l_cnt        LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF g_argv1 != ' '
      THEN LET tm.wc = "tc_ibb03 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
		    IF NOT cl_null(g_argv2) THEN
          LET tm.wc=tm.wc," AND tc_ibb04='",g_argv2,"'"
       END IF
      ELSE CLEAR FORM #清除畫面
   CALL g_tc_ibb_d.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           INITIALIZE g_tc_ibb_m.* TO NULL  #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030


           CONSTRUCT BY NAME tm.wc ON tc_ibb03,tc_ibb04   #add by huanglf160927
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
#str----add by huanglf160927
         #  LET g_tc_ibb_m.chk1 = 'N'
          # DISPLAY BY NAME g_tc_ibb_m.chk1 
#str----end by huanglf160927
              #No.FUN-580031 --end--       HCN
              #FUN-920152--BEGIN--
              ON ACTION controlp 
                 CASE 
                   WHEN INFIELD(tc_ibb03)  #倉庫
                       CALL cl_init_qry_var() 
                       #LET g_qryparam.state= "c"
                       LET g_qryparam.form ="cq_tc_ibb"  
                       #LET g_qryparam.arg1     = 'SW'        #倉庫類別
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_ibb03
                       NEXT FIELD tc_ibb03
                 END CASE
               #FUN-920152--END--
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
 #INPUT BY NAME g_tc_ibb_m.chk1 WITHOUT DEFAULTS

#str----add by huanglf160927
  #      IF g_tc_ibb_m.chk1 = 'Y' THEN 
   #         CALL cl_set_comp_visible("img04",TRUE) 
    #    END IF 
#str----end by huanglf160927
          #CHI-890031-begin-modify
          #CONSTRUCT tm.wc2 ON img01 FROM s_img[1].img01

           CONSTRUCT tm.wc2 ON tc_ibb06,ima01,ima02,ima21,ima25,tc_ibb21,tc_ibb05,tc_ibb07,tc_ibb17,tc_ibb01                        #DEV-D30055 add
              FROM s_tc_ibb[1].tc_ibb06,s_ima[1].ima02,s_ima[1].ima21,s_ima[1].ima25,
                   s_tc_ibb[1].tc_ibb21,s_tc_ibb[1].tc_ibb05,s_tc_ibb[1].tc_ibb07,s_tc_ibb[1].tc_ibb17,
                   s_tc_ibb[1].tc_ibb01  #DEV-D30055 add
     
          #CHI-890031-end-modify
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		      LET g_tc_ibb_d[1].chk1 = 'Y'
           DISPLAY BY NAME g_tc_ibb_d[1].chk1 
		#No.FUN-580031 --end--       HCN
#No.TQC-650115--begin
              #ON ACTION CONTROLP    #FUN-4B0043                                                                                     
               #  IF INFIELD(img01) THEN                                                                                             
                #    CALL cl_init_qry_var()                                                                                          
                 #   LET g_qryparam.form = "q_ima"                                                                                   
                  #  LET g_qryparam.state = "c"                                                                                      
                   # CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    #DISPLAY g_qryparam.multiret TO img01                                                                            
                    #NEXT FIELD img01                                                                                                
                 #END IF   
                 #FUN-920152--BEGIN--
                # IF INFIELD(img03) THEN
                 #   CALL cl_init_qry_var()
                  #  LET g_qryparam.form     = "q_ime" 
                   # LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #DISPLAY g_qryparam.multiret TO img03
                    #NEXT FIELD img03
                # END IF 
                 #FUN-920152--END--
#No.TQC-650115--end   
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
   END IF


  IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN #MOD-860056 add
   LET g_sql=" SELECT tc_ibb03,tc_ibb04 FROM tc_ibb_file ",  #MOD-860056 modify
             " WHERE ",tm.wc CLIPPED  #modify by huanglf160927
  #MOD-860056-begin-add
  ELSE 
   LET g_sql=" SELECT UNIQUE tc_ibb03,tc_ibb04 FROM tc_ibbfile ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED
  END IF 
  #MOD-860056-end-add
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imduser', 'imdgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY tc_ibb03"
   PREPARE q401_prepare FROM g_sql
   DECLARE q401_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q401_prepare
 
   # 取合乎條件筆數
  IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN #MOD-860056 add
   LET g_sql=" SELECT COUNT(*) FROM tc_ibb_file ",
              " WHERE ",tm.wc CLIPPED
  #MOD-860056-begin-add
  ELSE 
   LET g_sql=" SELECT COUNT(DISTINCT tc_ibb03) FROM tc_ibb_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED
  END IF 
  #MOD-860056-end-add
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q401_pp  FROM g_sql
   DECLARE q401_count   CURSOR FOR q401_pp
END FUNCTION
 
FUNCTION q102_b_askkey()
   CONSTRUCT tm.wc2 ON tc_ibb06 FROM s_tc_ibb[1].tc_ibb06
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
 
FUNCTION q102_menu()
 
   WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF
         WHEN "tmdy"
            IF cl_chk_act_auth() THEN
               CALL abaq102_create()
            END IF
             WHEN "bbdy"
            IF cl_chk_act_auth() THEN
               CALL abaq102_create_1()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ibb_d),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
#str----add by huanglf160927
   # LET g_tc_ibb_m.chk1 = 'N'
    #DISPLAY BY NAME g_tc_ibb_m.chk1 
#str----end by huanglf160927
    CALL q102_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q401_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q401_count
       FETCH q401_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q401_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04 #MOD-860056 modify
        WHEN 'P' FETCH PREVIOUS q401_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04 #MOD-860056 modify
        WHEN 'F' FETCH FIRST    q401_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04 #MOD-860056 modify
        WHEN 'L' FETCH LAST     q401_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04 #MOD-860056 modify
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
            FETCH ABSOLUTE g_jump q401_cs INTO g_tc_ibb_m.tc_ibb03 #MOD-860056 modify
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ibb_m.tc_ibb03,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ibb_m.* TO NULL  #TQC-6B0105
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
	SELECT distinct tc_ibb03,tc_ibb04
	  INTO g_tc_ibb_m.*
	  FROM tc_ibb_file
	 WHERE tc_ibb03 = g_tc_ibb_m.tc_ibb03 AND tc_ibb04=g_tc_ibb_m.tc_ibb04
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_tc_ibb_m.imd01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","tc_ibb_file",g_tc_ibb_m.tc_ibb03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
   DISPLAY BY NAME g_tc_ibb_m.*   # 顯示單頭值
   CALL q102_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)   #MOD-B90146 mark
   DEFINE l_sql,l_sql1,l_sql2     STRING                                                #MOD-B90146


 #IF g_tc_ibb_m.chk1 = 'N' THEN 
   LET l_sql ="SELECT tc_ibb06,ima01,ima02,ima021,ima25,tc_ibb21,tc_ibb05,tc_ibb07,tc_ibb17,tc_ibb01,'Y' ",
                  "  FROM tc_ibb_file ",
                  "  left join ima_file on ima01=tc_ibb06",
                  " WHERE tc_ibb01<>' ' AND ",tm.wc,
                  "  ORDER BY tc_ibb01 " 
    PREPARE q401_pb FROM l_sql
    DECLARE q401_bcs                       #BODY CURSOR
        CURSOR FOR q401_pb

 
   #---------------No:MMOD-810252 modify
   #FOR g_cnt = 1 TO g_tc_ibb_d.getLength()           #單身 ARRAY 乾洗
   #   INITIALIZE g_tc_ibb_d[g_cnt].* TO NULL
   #END FOR
    CALL g_tc_ibb_d.clear()
   #---------------No:MMOD-810252 end
    LET g_rec_b=0
    LET g_cnt = 1
#IF g_tc_ibb_m.chk1 = 'N' THEN 
    FOREACH q401_bcs INTO g_tc_ibb_d[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
      END IF
#--TQC-CC0003--add----star---
  #      SELECT ime03  INTO g_tc_ibb_d[g_cnt].ime03 FROM ime_file WHERE ime02 = g_tc_ibb_d[g_cnt].img03 
   #             AND ime01 = g_tc_ibb_m.imd01  #add by guanyao160802
    #    DISPLAY g_tc_ibb_d[g_cnt].ime03 TO ime03
#--TQC-CC0003--add----end----
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_tc_ibb_d_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH

    CALL g_tc_ibb_d.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ibb_d TO s_tc_ibb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
          ON ACTION tmdy
         LET g_action_choice="tmdy"
         EXIT DISPLAY
          ON ACTION bbdy
         LET g_action_choice="bbdy"
         EXIT DISPLAY
      ON ACTION first
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q102_fetch('L')
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
#        LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 FUNCTION abaq102_create_1()
DEFINE g_sql,l_table         STRING
DEFINE g_str          STRING
#DEFINE l_imaf063      LIKE imaf_t.imaf063
DEFINE l_success      LIKE type_file.num5
#DEFINE l_oofg_return DYNAMIC ARRAY OF RECORD
 #         oofg019     LIKE oofg_t.oofg019,   #field
  #        oofg020     LIKE oofg_t.oofg020    #value
   #                  END RECORD
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_i            LIKE type_file.num10
DEFINE l_datechr      LIKE type_file.chr10
DEFINE l_chr          LIKE type_file.chr100
#add by liudong 170425

DEFINE l_int          LIKE type_file.num10
#DEFINE l_mod          LIKE bcaa_t.bcaa009
DEFINE l_pidstr       STRING
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima21 LIKE ima_file.ima021
DEFINE l_tc_ibb17 LIKE tc_ibb_file.tc_ibb17
DEFINE l_tc_ibb07 LIKE tc_ibb_file.tc_ibb07
DEFINE l_tc_ibb01 LIKE tc_ibb_file.tc_ibb01

#end by liudong 170425
#CREATE TEMP TABLE l_table(
 #    ima02    VARCHAR(1000) ,
  #   ima021    VARCHAR(1000),
   #  tc_ibb17    VARCHAR(1000),  
    # tc_ibb07    FLOAT,
     #tc_ibb01    VARCHAR(1000))

#取条码档数据
    LET g_sql ="ima01.ima_file.ima01, ", 
             "ima02.ima_file.ima02,    ",      #工单编号                                        #建立临时表的表结构  改程序的时候这里需要增加栏
             "ima021.ima_file.ima021,    ",      #品名
             "tc_ibb17.tc_ibb_file.tc_ibb17,  ",      #规格
             "tc_ibb07.tc_ibb_file.tc_ibb07,    ",      #应发数量
             "tc_ibb01.tc_ibb_file.tc_ibb01    "      #条码编号
    LET l_table = cl_prt_temptable('abar102',g_sql) CLIPPED   #通过g-SQL架构创建临时表 
   IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,         #g_cr_db_str和l_table串起来形成表名称  into后面的有个空格不能少
               " VALUES(?,?,?,?,?,?)"                            #上面增加几个栏位 这里需要增加几个问号  #add by dym170728
   PREPARE insert_prep FROM g_sql                      #声明游标
   IF STATUS THEN                                           #    
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM            #检查声明的游标格式
   END IF  
   SELECT TO_CHAR(g_today,'yyyymmdd')||'01' INTO l_datechr FROM DUAL
   LET l_pidstr = l_datechr,FGL_GETPID() USING '<<<<<' 
   LET l_cnt = 0

  # LET l_str = l_str,"pm;gg;ph;qty;barcode_no\n"
    FOR l_i=1 TO  g_cnt
       LET l_ima01=g_tc_ibb_d[l_i].ima01   
       LET l_ima02=g_tc_ibb_d[l_i].ima02
       LET l_ima21=g_tc_ibb_d[l_i].ima021
       LET l_tc_ibb17=g_tc_ibb_d[l_i].tc_ibb17
       LET l_tc_ibb07=g_tc_ibb_d[l_i].tc_ibb07
       LET l_tc_ibb01=g_tc_ibb_d[l_i].tc_ibb01
       IF NOT cl_null(l_tc_ibb01)THEN 
         EXECUTE insert_prep USING l_ima01,l_ima02,l_ima21,l_tc_ibb17,l_tc_ibb07,l_tc_ibb01
         #LET l_str = l_str,l_ima02,';',l_ima21,';',l_tc_ibb17,';',l_tc_ibb07 USING '<<<<<',';',l_tc_ibb01,'\n'
       END IF 
    END FOR 
    
         LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
         CALL cl_prt_cs3('abaq102','abaq102',g_sql,g_str)
  
      #每一笔收货单产生一个文档
#      CALL abaq012_create_txt(l_str,l_datechr,l_pidstr CLIPPED)
 #        RETURNING l_success
      
  #    IF l_success THEN
   #      CALL abaq012_create_bat()
    #  END IF 
END FUNCTION
FUNCTION abaq102_create()
DEFINE g_sql,l_table         STRING
DEFINE l_str          STRING
#DEFINE l_imaf063      LIKE imaf_t.imaf063
DEFINE l_success      LIKE type_file.num5
#DEFINE l_oofg_return DYNAMIC ARRAY OF RECORD
 #         oofg019     LIKE oofg_t.oofg019,   #field
  #        oofg020     LIKE oofg_t.oofg020    #value
   #                  END RECORD
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_i            LIKE type_file.num10
DEFINE l_datechr      LIKE type_file.chr10
DEFINE l_chr          LIKE type_file.chr100
#add by liudong 170425

DEFINE l_int          LIKE type_file.num10
#DEFINE l_mod          LIKE bcaa_t.bcaa009
DEFINE l_pidstr       STRING
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima21 LIKE ima_file.ima021
DEFINE l_tc_ibb17 LIKE tc_ibb_file.tc_ibb17
DEFINE l_tc_ibb07 LIKE tc_ibb_file.tc_ibb07
DEFINE l_tc_ibb01 LIKE tc_ibb_file.tc_ibb01

#end by liudong 170425
#CREATE TEMP TABLE l_table(
 #    ima02    VARCHAR(1000) ,
  #   ima021    VARCHAR(1000),
   #  tc_ibb17    VARCHAR(1000),  
    # tc_ibb07    FLOAT,
     #tc_ibb01    VARCHAR(1000))

#取条码档数据
    #LET g_sql ="ima01.ima_file.ima01,",
      #           "ima02.ima_file.ima02,    ",      #工单编号                                        #建立临时表的表结构  改程序的时候这里需要增加栏
          #   "ima021.ima_file.ima021,    ",      #品名
       #      "tc_ibb17.tc_ibb_file.tc_ibb17,  ",      #规格
      #       "tc_ibb07.tc_ibb_file.tc_ibb07,    ",      #应发数量
     #        "tc_ibb01.tc_ibb_file.tc_ibb01    "      #条码编号
    #LET l_table = cl_prt_temptable('abar102',g_sql) CLIPPED   #通过g-SQL架构创建临时表 
   #IF l_table=-1 THEN EXIT PROGRAM END IF
    #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,         #g_cr_db_str和l_table串起来形成表名称  into后面的有个空格不能少
   #            " VALUES(?,?,?,?,?)"                            #上面增加几个栏位 这里需要增加几个问号  #add by dym170728
  # PREPARE insert_prep FROM g_sql                      #声明游标
   IF STATUS THEN                                           #    
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM            #检查声明的游标格式
   END IF  
   SELECT TO_CHAR(g_today,'yyyymmdd')||'01' INTO l_datechr FROM DUAL
   LET l_pidstr = l_datechr,FGL_GETPID() USING '<<<<<' 
   LET l_cnt = 0

   LET l_str = l_str,"pm;gg;ph;qty;barcode_no\n"
    FOR l_i=1 TO  g_cnt   
       LET l_ima01=g_tc_ibb_d[l_i].ima01
       LET l_ima02=g_tc_ibb_d[l_i].ima02
       LET l_ima21=g_tc_ibb_d[l_i].ima021
       LET l_tc_ibb17=g_tc_ibb_d[l_i].tc_ibb17
       LET l_tc_ibb07=g_tc_ibb_d[l_i].tc_ibb07
       LET l_tc_ibb01=g_tc_ibb_d[l_i].tc_ibb01
       IF NOT cl_null(l_tc_ibb01)THEN 
  #       EXECUTE insert_prep USING l_ima02,l_ima21,l_tc_ibb17,l_tc_ibb07,l_tc_ibb01
         LET l_str = l_str,l_ima02,';',l_ima21,';',l_tc_ibb17,';',l_tc_ibb07 USING '<<<<<',';',l_tc_ibb01,'\n'
       END IF 
    END FOR 
    
 #        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#         CALL cl_prt_cs3('abaq102','abaq102',g_sql,g_str)
  
      #每一笔收货单产生一个文档
      CALL abaq012_create_txt(l_str,l_datechr,l_pidstr CLIPPED)
         RETURNING l_success
      
      IF l_success THEN
         CALL abaq012_create_bat()
      END IF 
END FUNCTION
FUNCTION abaq012_create_txt(p_str,p_datechr,p_cnt)
DEFINE p_str                  STRING
DEFINE p_datechr              LIKE type_file.chr10
DEFINE p_cnt                  LIKE type_file.chr100
DEFINE l_channel              base.Channel
DEFINE l_str                  STRING
DEFINE l_file_name            STRING
DEFINE l_file_name_txt        STRING
DEFINE l_file_name_u          STRING
DEFINE l_file_name_bat        STRING
DEFINE l_server               STRING
DEFINE l_server_tt            STRING
DEFINE l_client               STRING
DEFINE l_client_download      STRING
DEFINE l_client_download_tt   STRING
DEFINE l_client_BarTender     STRING
DEFINE l_client_btw           STRING
DEFINE l_target_file          STRING
   
   #檔案名稱
   LET l_file_name = "abaq012-",p_cnt
   #LET l_file_name="abaq012"
   LET l_file_name = os.Path.join( FGL_GETENV("TEMPDIR"),l_file_name)
                    
   
   #Client下載路徑
   LET l_client = "C:\\tiptop\\BarTender"
   LET l_target_file = l_client,"\\abaq012.txt"
   
   #產生TXT
   LET l_file_name_txt = l_file_name CLIPPED,".txt"
   RUN 'rm '||l_file_name_txt                                  #add by liudong 170425
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_file_name_txt, "w")
   CALL l_channel.setDelimiter("")
   #LET l_str = "pm;gg;tzm;ph;qty;dw;barcode_no\n"
   #CALL l_channel.write(l_str)
   CALL l_channel.write(p_str)
   CALL l_channel.close()
   
   
   #转换成utf-8格式
   #RUN 'iconv -f en_US.utf8 -t UTF-8 <'||l_file_name_txt||' >'||l_file_name_u
   #下载文件到终端电脑
   CALL FGL_PUTFILE(l_file_name_txt,l_target_file)
   
   
   
   RETURN TRUE
END FUNCTION
FUNCTION abaq012_create_bat()
   DEFINE l_channel     base.Channel,
          l_url         STRING,
          l_destination STRING,
          l_source      STRING,
          l_filename    STRING,
          l_cmd         STRING,
          l_bat         STRING,
          l_btw         STRING,
          g_cmd         STRING
   DEFINE li_status     like type_file.num5

   ## 檔案路徑
   LET l_bat = os.Path.join( FGL_GETENV("TEMPDIR"),"abaq012.bat")   

      LET l_btw = "abaq012.btw"   
 


   ## 先產生一個.bat檔
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_bat,"w" )
   CALL l_channel.setDelimiter("")

   LET l_cmd = 'cd C:\\Program Files (x86)\\Seagull\\BarTender Suite \n bartend.exe  /F=',
               'C:\\tiptop\\BarTender\\', l_btw CLIPPED,' /D=C:\\tiptop\\BarTender\\abaq012.txt /PD /X '


   #CALL l_channel.write(l_cmd)
   CALL l_channel.writeLine(l_cmd)  #110721 DSC.charlies
   CALL l_channel.close()

   ## 把產生的.bat放到指定的目錄下
   LET l_destination = "C:\\tiptop\\BarTender\\" CLIPPED,"abaq012.bat"
   #LET l_source = FGL_GETENV("$TEMPDIR"),l_bat CLIPPED
   CALL FGL_PUTFILE(l_bat, l_destination)

   ## 執行.bat檔
   CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  [l_destination],
                                  [li_status])
END FUNCTION
