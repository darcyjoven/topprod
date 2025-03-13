# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq600.4gl
# Descriptions...: 料件儲位各期異動統計量查詢
# Date & Author..: 93/05/31 By Felicity  Tseng
# Modify.........: No.MOD-480051 04/08/11 By Nicola 單身不會即時更新
# Modify.........: No.FUN-4A0043 04/10/06 By Echo 料號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790058 07/09/10 By judy 匯出Excel多一空白行
# Modify.........: No.TQC-7B0004 07/11/07 By Carrier 把g_img_rowid對應的key值select出來
# Modify.........: No.FUN-930008 09/03/17 By ve007 新增”查詢批序號資料”功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AA0130 10/10/27 By destiny 单身资料为空时，点批序号库存资料按钮会荡出
# Modify.........: No:CHI-BC0020 11/12/26 By ck2yuan 在aimq600a新增合計數量欄位
# Modify.........: No:TQC-BB0080 12/01/10 By destiny 查询退出时报错 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm               RECORD
                      wc    LIKE type_file.chr1000, # Head Where condition-1  #No.FUN-690026 VARCHAR(500)
                      wc1   LIKE type_file.chr1000, # Head Where condition-2  #No.FUN-690026 VARCHAR(500)
                      wc2   LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)
                     END RECORD,
    g_img            RECORD
                      img01  LIKE img_file.img01, # 料件編號
                      img02  LIKE img_file.img02, # 倉庫編號
                      img03  LIKE img_file.img03, # 存放位置
                      img04  LIKE img_file.img04, # 批號
                      img09  LIKE img_file.img09  # 庫存單位
                     END RECORD,
    g_ima02          LIKE ima_file.ima02,  # 品名
    g_ima021         LIKE ima_file.ima021, # 品名
    g_ima25          LIKE ima_file.ima25,  # 單位
    g_imk            DYNAMIC ARRAY OF RECORD
                      imk05   LIKE imk_file.imk05,  #年度
                      imk06   LIKE imk_file.imk06,  #期別
                      imk081  LIKE imk_file.imk081, #入庫
                      imk082  LIKE imk_file.imk082, #出
                      imk083  LIKE imk_file.imk083, #銷貨
                      imk084  LIKE imk_file.imk084, #轉
                      imk085  LIKE imk_file.imk085, #調整
                      imk09   LIKE imk_file.imk09   #期未結存
                     END RECORD,
    g_query_flag     LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql            string,                 #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_ac           LIKE type_file.num5    #No.FUN-930008
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE      l_sl   LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
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
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q600_w AT p_row,p_col
         WITH FORM "aim/42f/aimq600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    #FOR g_i = 10 TO 19 DISPLAY '' AT g_i,1 END FOR
    #IF cl_chk_act_auth() THEN
    #   CALL q600_q()
    #END IF
    CALL q600_menu()
    CLOSE WINDOW q600_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   CLEAR FORM
   CALL g_imk.clear()
   CALL cl_opmsg('q')
   INITIALIZE g_img.* TO NULL    #FUN-640213 add
   INITIALIZE tm.* TO NULL		
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   CONSTRUCT BY NAME tm.wc ON img01, ima02,ima021,img02, img03, img04,img09
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       #### No.FUN-4A0043
       ON ACTION CONTROLP
           CASE
               WHEN INFIELD(img01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img01
                NEXT FIELD img01
           END CASE
      ### END  No.FUN-4A0043
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
     #LET INT_FLAG = 0 #TQC-BB0080
      RETURN
   END IF
   CONSTRUCT tm.wc1 ON imk05, imk06 FROM yy, mm
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN
      #LET INT_FLAG = 0 #TQC-BB0080
      RETURN
   END IF
 
    MESSAGE ' WAIT '
    LET g_sql= " SELECT img01,img02,img03,img04,",  #No.TQC-7B0004
               "        ima02,ima021,ima25 ",       #No.TQC-7B0004
               " FROM img_file,ima_file",
               " WHERE ima01 = img01 ",
               " AND ",tm.wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY img01"
    PREPARE q600_prepare FROM g_sql
    DECLARE q600_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q600_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) FROM img_file ",
               " WHERE ",tm.wc CLIPPED
    PREPARE q600_pp  FROM g_sql
    DECLARE q600_count   CURSOR FOR q600_pp
END FUNCTION
 
FUNCTION q600_menu()
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-930008 --begin--
         WHEN "query_lot_data"  #查詢批/序號資料
            LET g_ac = ARR_CURR()
            IF g_ac>0 THEN                                           #No.TQC-AA0130   
               CALL q600_q_imks(g_imk[g_ac].imk05,g_imk[g_ac].imk06)
            END IF                                                   #No.TQC-AA0130 
         #No.FUN-930008 --end--   
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q600_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN q600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q600_count
       FETCH q600_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q600_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04,   #No.TQC-7B0004
                                             g_ima02,g_ima021,g_ima25
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04,   #No.TQC-7B0004
                                             g_ima02,g_ima021,g_ima25
        WHEN 'F' FETCH FIRST    q600_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04,   #No.TQC-7B0004
                                             g_ima02,g_ima021,g_ima25
        WHEN 'L' FETCH LAST     q600_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04,   #No.TQC-7B0004
                                             g_ima02,g_ima021,g_ima25
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
            FETCH ABSOLUTE g_jump q600_cs INTO g_img.img01,
                                               g_img.img02,g_img.img03,g_img.img04,   #No.TQC-7B0004
                                               g_ima02,g_ima021,g_ima25
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.* TO NULL  #TQC-6B0105
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
    SELECT img01,img02,img03,img04,img09 INTO g_img.*
      FROM img_file
     WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","img_file",g_img.img01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q600_show()
END FUNCTION
 
FUNCTION q600_show()
   DISPLAY BY NAME g_img.*   # 顯示單頭值
   DISPLAY g_ima02, g_ima021,g_ima25 TO ima02, ima021,ima25
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(2000)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
      LET l_sql =
           "SELECT imk05,imk06,imk081,imk082,imk083,imk084,imk085,imk09",
           " FROM  imk_file",
           " WHERE imk01 = '",g_img.img01,"'",
           "   AND imk02 = '",g_img.img02,"'",
           "   AND imk03 = '",g_img.img03,"'",
           "   AND imk04 = '",g_img.img04,"'",
           "   AND ",tm.wc1 CLIPPED,
#          "   AND ",tm.wc2 CLIPPED,
           " ORDER BY imk05,imk06 "
   PREPARE q600_pb FROM l_sql
   DECLARE q600_bcs                       #BODY CURSOR
       CURSOR FOR q600_pb
 
   FOR g_cnt = 1 TO g_imk.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_imk[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q600_bcs INTO g_imk[g_cnt].*
       IF g_cnt=1 THEN
          LET g_rec_b=SQLCA.SQLERRD[3]
       END IF
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(g_imk[g_cnt].imk081) THEN LET g_imk[g_cnt].imk081 = 0 END IF
       IF cl_null(g_imk[g_cnt].imk082) THEN LET g_imk[g_cnt].imk082 = 0 END IF
       IF cl_null(g_imk[g_cnt].imk083) THEN LET g_imk[g_cnt].imk083 = 0 END IF
       IF cl_null(g_imk[g_cnt].imk084) THEN LET g_imk[g_cnt].imk084 = 0 END IF
       IF cl_null(g_imk[g_cnt].imk085) THEN LET g_imk[g_cnt].imk085 = 0 END IF
       IF cl_null(g_imk[g_cnt].imk09) THEN LET g_imk[g_cnt].imk09 = 0 END IF
       LET g_cnt = g_cnt + 1
#      IF g_cnt > g_imk_arrno THEN
#         CALL cl_err('',9035,0)
#         EXIT FOREACH
#      END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_imk.deleteElement(g_cnt)   #TQC-790058
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_imk TO s_imk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480051
 
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
         CALL q600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      
      #No.FUN-930008 --begin--
      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         EXIT DISPLAY
      #No.FUN-930008 --end--
      
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
 
#No.FUN-930008 --begin--
FUNCTION q600_q_imks(l_imks05,l_imks06)
   DEFINE l_ac      LIKE type_file.num5
   DEFINE l_imks01  LIKE imks_file.imks01
   DEFINE l_imks02  LIKE imks_file.imks02
   DEFINE l_imks03  LIKE imks_file.imks03
   DEFINE l_imks04  LIKE imks_file.imks04
   DEFINE l_imks05  LIKE imks_file.imks05
   DEFINE l_imks06  LIKE imks_file.imks06
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE sum       LIKE type_file.num5    #CHI-BC0020 add
   DEFINE g_imks DYNAMIC ARRAY OF RECORD
                    imks10   LIKE imks_file.imks10,
                    imks11   LIKE imks_file.imks11,
                    imks081  LIKE imks_file.imks081,
                    imks082  LIKE imks_file.imks082,
                    imks083  LIKE imks_file.imks083,
                    imks084  LIKE imks_file.imks084,
                    imks085  LIKE imks_file.imks085,
                    imks09   LIKE imks_file.imks09,
                    imks12   LIKE imks_file.imks12
                 END RECORD
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = g_img.img01
   
   IF cl_null(l_ima918) THEN
      LET l_ima918="N"
   END IF
 
   IF cl_null(l_ima921) THEN
      LET l_ima921="N"
   END IF
 
   IF l_ima918 <> "Y" AND l_ima921 <> "Y" THEN
      RETURN
   END IF
 
   LET p_row = 6 LET p_col = 2
 
   OPEN WINDOW q600_q_imks_w AT p_row,p_col WITH FORM "aim/42f/aimq600a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq600a")
 
   DISPLAY g_img.img01,g_img.img02,g_img.img03,g_img.img04,l_imks05,l_imks06
        TO imks01,imks02,imks03,imks04,imks05,imks06 
 
   DECLARE q600_q_imks_c CURSOR FOR SELECT imks10,imks11,imks081,imks082,
                                           imks083,imks084,imks085,imks09,imks12
                                      FROM imks_file
                                     WHERE imks01 = g_img.img01
                                       AND imks02 = g_img.img02
                                       AND imks03 = g_img.img03
                                       AND imks04 = g_img.img04
                                       AND imks05 = l_imks05
                                       AND imks06 = l_imks06
                                     ORDER BY imks05,imks06 
 
   CALL g_imks.clear()
 
   LET g_cnt=1
   LET sum=0                      #CHI-BC0020 add 
   FOREACH q600_q_imks_c INTO g_imks[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach imks:',STATUS,1)
         EXIT FOREACH
      END IF
      LET sum=sum+g_imks[g_cnt].imks09   #CHI-BC0020 add 
      LET g_cnt=g_cnt+1
 
   END FOREACH
   DISPLAY sum TO FORMONLY.sum          #CHI-BC0020 add 
   DISPLAY ARRAY g_imks TO s_imks.*
 
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont() 
 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      AFTER DISPLAY 
         CONTINUE DISPLAY 
 
   END DISPLAY 
 
   CLOSE WINDOW q600_q_imks_w
 
END FUNCTION
#No.FUN-930008 --end--
