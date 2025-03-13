# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq401
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
    g_imd       RECORD
                imd01  LIKE imd_file.imd01,
                imd02  LIKE imd_file.imd02,
                chk1   LIKE type_file.chr1  #add by huanglf160927
                END RECORD,
    g_img       DYNAMIC ARRAY OF RECORD
                img01   LIKE img_file.img01,
                ima02   LIKE ima_file.ima02,  #MOD-6A0130
                ima021  LIKE ima_file.ima021, #MOD-6A0130
                imaud10 LIKE ima_file.imaud10,#add by guanyao160913
                img03   LIKE img_file.img03,
                ime03   LIKE ime_file.ime03,   #TQC-CC0003
                img04   LIKE img_file.img04,
                img09   LIKE img_file.img09,
                img10   LIKE img_file.img10,
                img10_1 LIKE img_file.img10,  #add by guanyao160913
                img19   LIKE img_file.img19,
                img36   LIKE img_file.img36,
                img37   LIKE img_file.img37,
                img18   LIKE img_file.img18
               #ima02   LIKE ima_file.ima02, #FUN-640006  #MOD-6A0130 mark
               #ima021  LIKE ima_file.ima021 #FUN-640006  #MOD-6A0130 mark
                END RECORD,
    l_img23     LIKE img_file.img23,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
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
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW aimq401_w AT p_row,p_col
         WITH FORM "aim/42f/aimq401"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q401_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q401_q() END IF
    CALL q401_menu()
    CLOSE WINDOW q400_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q401_cs()
DEFINE  l_cnt        LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF g_argv1 != ' '
      THEN LET tm.wc = "imd01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_img.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           INITIALIZE g_imd.* TO NULL  #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030


           CONSTRUCT BY NAME tm.wc ON imd01   #add by huanglf160927
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
#str----add by huanglf160927
           LET g_imd.chk1 = 'N'
           DISPLAY BY NAME g_imd.chk1 
#str----end by huanglf160927
              #No.FUN-580031 --end--       HCN
              #FUN-920152--BEGIN--
              ON ACTION controlp 
                 CASE 
                   WHEN INFIELD(imd01)  #倉庫
                       CALL cl_init_qry_var() 
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form ="q_imd"  
                       LET g_qryparam.arg1     = 'SW'        #倉庫類別
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO imd01
                       NEXT FIELD imd01
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
 INPUT BY NAME g_imd.chk1 WITHOUT DEFAULTS

#str----add by huanglf160927
        IF g_imd.chk1 = 'Y' THEN 
            CALL cl_set_comp_visible("img04",TRUE) 
        END IF 
#str----end by huanglf160927
          #CHI-890031-begin-modify
          #CONSTRUCT tm.wc2 ON img01 FROM s_img[1].img01

           CONSTRUCT tm.wc2 ON img01,img03,img04,img09,img10,img19,img36,img37,img18
                     FROM s_img[1].img01,s_img[1].img03,s_img[1].img04,s_img[1].img09,
                          s_img[1].img10,s_img[1].img19,s_img[1].img36,s_img[1].img37,s_img[1].img18
     
          #CHI-890031-end-modify
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
#No.TQC-650115--begin
              ON ACTION CONTROLP    #FUN-4B0043                                                                                     
                 IF INFIELD(img01) THEN                                                                                             
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_ima"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO img01                                                                            
                    NEXT FIELD img01                                                                                                
                 END IF   
                 #FUN-920152--BEGIN--
                 IF INFIELD(img03) THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_ime" 
                    LET g_qryparam.state    = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO img03
                    NEXT FIELD img03
                 END IF 
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
   LET g_sql=" SELECT imd01 FROM imd_file ",  #MOD-860056 modify
             " WHERE ",tm.wc CLIPPED  #modify by huanglf160927
  #MOD-860056-begin-add
  ELSE 
   LET g_sql=" SELECT UNIQUE imd01 FROM imd_file,img_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND img02 = imd01 "
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
 
   LET g_sql = g_sql clipped," ORDER BY imd01"
   PREPARE q401_prepare FROM g_sql
   DECLARE q401_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q401_prepare
 
   # 取合乎條件筆數
  IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN #MOD-860056 add
   LET g_sql=" SELECT COUNT(*) FROM imd_file ",
              " WHERE ",tm.wc CLIPPED
  #MOD-860056-begin-add
  ELSE 
   LET g_sql=" SELECT COUNT(DISTINCT imd01) FROM imd_file,img_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND img02 = imd01 "
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
 
FUNCTION q401_b_askkey()
   CONSTRUCT tm.wc2 ON img01 FROM s_img[1].img01
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
 
FUNCTION q401_menu()
 
   WHILE TRUE
      CALL q401_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q401_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q401_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
#str----add by huanglf160927
    LET g_imd.chk1 = 'N'
    DISPLAY BY NAME g_imd.chk1 
#str----end by huanglf160927
    CALL q401_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q401_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q401_count
       FETCH q401_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q401_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q401_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q401_cs INTO g_imd.imd01 #MOD-860056 modify
        WHEN 'P' FETCH PREVIOUS q401_cs INTO g_imd.imd01 #MOD-860056 modify
        WHEN 'F' FETCH FIRST    q401_cs INTO g_imd.imd01 #MOD-860056 modify
        WHEN 'L' FETCH LAST     q401_cs INTO g_imd.imd01 #MOD-860056 modify
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
            FETCH ABSOLUTE g_jump q401_cs INTO g_imd.imd01 #MOD-860056 modify
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
        INITIALIZE g_imd.* TO NULL  #TQC-6B0105
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
	SELECT imd01, imd02
	  INTO g_imd.*
	  FROM imd_file
	 WHERE imd01 = g_imd.imd01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","imd_file",g_imd.imd01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q401_show()
END FUNCTION
 
FUNCTION q401_show()
   DISPLAY BY NAME g_imd.*   # 顯示單頭值
   CALL q401_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q401_b_fill()              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)   #MOD-B90146 mark
   DEFINE l_sql,l_sql1,l_sql2     STRING                                                #MOD-B90146


 IF g_imd.chk1 = 'N' THEN 
   LET l_sql =
        "SELECT img01, ima02, ima021,imaud10, img03,'', img04, img09, img10, ",  #MOD-6A0130 modify  #add imaud10 by guanyao160913
        "       case when imaud10>0 then img10/imaud10 else 0 end case ,",     #add imaud10 by guanyao160913
        " img19, img36, img37,img18 ",
       #" ,ima02, ima021",          #FUN-640006  #MOD-6A0130 mark
        " FROM  img_file,OUTER ima_file",  #FUN-640006   #No.TQC-780080 add
        " WHERE img02 = '",g_imd.imd01,"' AND ", tm.wc2 CLIPPED,
        " AND   img_file.img01 = ima_file.ima01 AND img10!=0",   #FUN-640006
        " ORDER BY img01 "
    PREPARE q401_pb FROM l_sql
    DECLARE q401_bcs                       #BODY CURSOR
        CURSOR FOR q401_pb
ELSE 

   LET l_sql1 =
        "SELECT img01,ima02,ima021,imaud10,img03,'', '', '', sum(img10), ",  #MOD-6A0130 modify  #add imaud10 by guanyao160913
        "       '' ,",     #add imaud10 by guanyao160913
        " '', '', '' ,'' ",
       #" ,ima02, ima021",          #FUN-640006  #MOD-6A0130 mark
        " FROM  img_file,ima_file",  #FUN-640006   #No.TQC-780080 add
        " WHERE img02 = '",g_imd.imd01,"' AND ", tm.wc2 CLIPPED,
        " AND   img_file.img01 = ima_file.ima01 AND img10!=0",   #FUN-640006
        " GROUP BY img01,img03,ima02,ima021,imaud10 ",
        " ORDER BY img01 "
    PREPARE q401_pb1 FROM l_sql1
    DECLARE q401_bcs1                       #BODY CURSOR
        CURSOR FOR q401_pb1
END IF 
 
   #---------------No:MMOD-810252 modify
   #FOR g_cnt = 1 TO g_img.getLength()           #單身 ARRAY 乾洗
   #   INITIALIZE g_img[g_cnt].* TO NULL
   #END FOR
    CALL g_img.clear()
   #---------------No:MMOD-810252 end
    LET g_rec_b=0
    LET g_cnt = 1
IF g_imd.chk1 = 'N' THEN 
    FOREACH q401_bcs INTO g_img[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#--TQC-CC0003--add----star---
        SELECT ime03  INTO g_img[g_cnt].ime03 FROM ime_file WHERE ime02 = g_img[g_cnt].img03 
                AND ime01 = g_imd.imd01  #add by guanyao160802
        DISPLAY g_img[g_cnt].ime03 TO ime03
#--TQC-CC0003--add----end----
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_img_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      --IF g_cnt > g_max_rec THEN
         --CALL cl_err( '', 9035, 0 )
	 --EXIT FOREACH
      --END IF
      # genero shell add g_max_rec check END
    END FOREACH
ELSE
     FOREACH q401_bcs1 INTO g_img[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

    IF g_img[g_cnt].imaud10>0 THEN 
       LET g_img[g_cnt].img10_1 = g_img[g_cnt].img10/g_img[g_cnt].imaud10
    ELSE 
       LET g_img[g_cnt].img10_1 = 0
    END IF 
    LET l_sql2 =
        "SELECT img09, ",  #MOD-6A0130 modify  #add imaud10 by guanyao160913
        " img19, img36, img37,img18 ",
        " FROM  img_file,ima_file", 
        " WHERE img02 = '",g_imd.imd01,"' AND ", tm.wc2 CLIPPED,
        " AND   img_file.img01 = ima_file.ima01",   #FUN-640006
        " AND   img01 = '",g_img[g_cnt].img01,"' AND img03 = '",g_img[g_cnt].img03,"'"
    PREPARE q401_pb2 FROM l_sql2
    EXECUTE q401_pb2 INTO g_img[g_cnt].img09,g_img[g_cnt].img19,g_img[g_cnt].img36,g_img[g_cnt].img37,g_img[g_cnt].img18
#--TQC-CC0003--add----star---
        SELECT ime03  INTO g_img[g_cnt].ime03 FROM ime_file WHERE ime02 = g_img[g_cnt].img03 
                AND ime01 = g_imd.imd01  #add by guanyao160802
        DISPLAY g_img[g_cnt].ime03 TO ime03
#--TQC-CC0003--add----end----
        LET g_cnt = g_cnt + 1
      --IF g_cnt > g_max_rec THEN
         --CALL cl_err( '', 9035, 0 ) #modify by huanglf160927
	 --EXIT FOREACH
      --END IF
    END FOREACH
END IF 
    CALL g_img.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q401_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL q401_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q401_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q401_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q401_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q401_fetch('L')
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
 