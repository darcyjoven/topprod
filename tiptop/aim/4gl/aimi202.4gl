# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi202.4gl
# Descriptions...: 料件預設倉庫/存放位置關聯維護作業
# Date & Author..: 91/10/09 By Carol
# Modify.........: 92/06/18 新增 銷售領料優先順序 (imf07 ) By Lin
#                           發料/領料優先順序值越小,優先順序越高(By Jeans 說的)
# Modify.........: 97/06/23 新增 G.產生功能 By Melody
# Modify.........: No.MOD-480049 04/08/27 By Nicola "整批產生"時按"放棄"會EXIT PROGRAM
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 料件編號開窗
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6B0105 06/12/11 By claire 產生倉庫資料action的倉庫,儲位不能輸入,要隱藏
# Modify.........: No.MOD-6B0085 06/12/13 By pengu cl_err('','mfg1007',0)，改為對話框呈現
# Modify.........: No.MOD-6B0106 06/12/14 By pengu 整批產生的Action時，檢查倉庫時應該要檢查imd_file的imd01才是合理
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740338 07/04/27 By sherry 打印結果中“接下頁”的地方顯示“結束”字樣。
# Modify.........: No.FUN-780040 07/07/27 By zhoufeng 報表打印改為p_query產出
# Modify.........: No.TQC-790064 07/09/12 By sherry  查詢出來的筆數與筆數顯示不一致
# Modify.........: No.MOD-7A0200 07/10/31 By Pengu 使用整批產生時不可用倉應可用,不應列入條件
# Modify.........: No.TQC-7B0016 07/11/02 By wujie  單身刪除以后，還留有欄位值沒有清楚，而且刪除時沒有提示框
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90049 10/09/30 By huangtao 更新庫存時候，加入料號判斷
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By huangtao mod
# Modify.........: No.FUN-B10041 11/09/14 By jason 新增"刪除指定倉庫關聯資料"
# Modify.........: No:FUN-BB0083 11/12/06 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-CC0026 12/12/17 By qirl 增加欄位
# Modify.........: No.TQC-CC0051 12/12/10 By qirl 增加開窗
# Modify.........: No.TQC-CC0051 13/01/31 By xuxz 修復No.TQC-CC0051 12/12/10 By qirl 增加開窗 BUG
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/16 By fengrui 添加庫位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ima             RECORD LIKE ima_file.*,    #料件編號 (單頭)
    g_imf             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imf02         LIKE imf_file.imf02,       #倉庫編號
        imd02         LIKE imd_file.imd02,       #TQC-CC0051--add
        imf03         LIKE imf_file.imf03,       #存放位置
        ime03         LIKE ime_file.ime03,       #TQC-CC0051--add
        imf04         LIKE imf_file.imf04        #最高存量限制
                      END RECORD,
    g_imf_o           RECORD                     #程式變數 (舊值)
        imf02         LIKE imf_file.imf02,       #倉庫編號
        imd02         LIKE imd_file.imd02,       #TQC-CC0051--add
        imf03         LIKE imf_file.imf03,       #存放位置
        ime03         LIKE ime_file.ime03,       #TQC-CC0051--add
        imf04         LIKE imf_file.imf04        #最高存量限制
                      END RECORD,
    g_imf_t           RECORD                     #程式變數 (舊值)
        imf02         LIKE imf_file.imf02,       #倉庫編號
        imd02         LIKE imd_file.imd02,       #TQC-CC0051--add
        imf03         LIKE imf_file.imf03,       #存放位置
        ime03         LIKE ime_file.ime03,       #TQC-CC0051--add
        imf04         LIKE imf_file.imf04        #最高存量限制
                      END RECORD,
    g_wc,g_wc2,g_sql  STRING, #TQC-630166
    g_rec_b           LIKE type_file.num5,       #單身筆數  #No.FUN-690026 SMALLINT
    l_ac              LIKE type_file.num5,       #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_sl              LIKE type_file.num5        #目前處理的SCREEN LINE  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
#TQC-CC0026 
#主程式開始
MAIN
#DEFINE                                          #No.FUN-6A0074
#       l_time    LIKE type_file.chr8            #No.FUN-6A0074
 
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
 
 
    IF g_sma.sma12='N' THEN    #不是多倉儲管理,不可使用本作業
      #------------No.MOD-6B0085 modify
      #CALL cl_err('','mfg1007',0)
       CALL cl_err('','mfg1007',1)
      #------------No.MOD-6B0085 end
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET p_row = 4 LET p_col = 6
 
    OPEN WINDOW i202_w AT p_row,p_col          #顯示畫面
        WITH FORM "aim/42f/aimi202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL i202_menu()
 
    CLOSE WINDOW i202_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION i202_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_imf.clear()
 
    INITIALIZE g_ima.* TO NULL  #FUN-640213 add
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT g_wc  ON ima01 FROM imf01
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP    #FUN-4B0001
         CASE WHEN INFIELD(imf01)
#FUN-AA0059 --Begin--
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form = "q_imf01"
#          #    LET g_qryparam.form = "q_ima"
           #   LET g_qryparam.state = "c"
           #   CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_imf01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO imf01
              NEXT FIELD imf01
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
 
    CALL g_imf.clear()
    CONSTRUCT g_wc2 ON imf02,imf03,imf04  # 螢幕上取條件
            FROM s_imf[1].imf02,s_imf[1].imf03,s_imf[1].imf04
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(imf02)
                  #CALL q_imd(10,3,g_imf[1].imf02,"A") RETURNING g_imf[1].imf02
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_imd"
                    LET g_qryparam.default1 = g_imf[1].imf02  #MOD-4A0213
                    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imf02
                WHEN INFIELD(imf03)
                  #CALL q_ime(10,3,g_imf[1].imf03,g_imf[1].imf02,'A') RETURNING g_imf[1].imf03
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ime"
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imf03
                OTHERWISE
                   EXIT CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN
	 LET g_sql = "SELECT  ima01 FROM ima_file ",
           	     " WHERE ", g_wc CLIPPED,
		     "  AND imaacti = 'Y'",
                     "  AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') ",                    #FUN-AB0059
               	     " ORDER BY ima01"
    ELSE
	 LET g_sql = "SELECT UNIQUE ima_file.ima01 ",
                     "  FROM ima_file,imf_file",
               	     " WHERE ima01=imf01 AND ", g_wc CLIPPED,
		     "   AND ",g_wc2 CLIPPED,
		     "   AND imaacti = 'Y'",
                     "  AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') ",                    #FUN-AB0059
               	     " ORDER BY ima01"
    END IF
 
    PREPARE i202_prepare FROM g_sql
    DECLARE i202_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i202_prepare
 
    IF g_wc2 = " 1=1" THEN
        #LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED     #No.TQC-790064   
        LET g_sql="SELECT COUNT(*) FROM ima_file WHERE imaacti = 'Y' AND ",g_wc CLIPPED  #No.TQC-790064      
                  ," AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') "                    #FUN-AB0059
    ELSE
        LET g_sql="SELECT COUNT(*) FROM ima_file,imf_file WHERE ",
	          #"ima01=imf01 AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED   #No.TQC-790064 
	          "ima01=imf01 AND  imaacti = 'Y' AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED  #No.TQC-790064 
                  ," AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') "                    #FUN-AB0059
    END IF
    PREPARE i202_precount FROM g_sql
    DECLARE i202_count CURSOR FOR i202_precount
END FUNCTION
 
FUNCTION i202_menu()
DEFINE   l_cmd LIKE type_file.chr1000                           #No.FUN-780040                                      
   WHILE TRUE
      CALL i202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i202_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i202_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
#              CALL i202_out()                                   #No.FUN-780040
               #No.FUN-780040 --start--
               IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF
               IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF
               LET l_cmd = 'p_query "aimi202" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
               #No.FUN-780040 --end--
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "整批產生"
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i202_gen()
            END IF
       #@WHEN "產生倉庫資料"
         WHEN "gen_w_h_data"
            IF cl_chk_act_auth() THEN
               CALL i202_ins_img()
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imf),'','')
            END IF
         #No.FUN-680046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN                     
               IF g_ima.ima01 IS NOT NULL THEN           
                 LET g_doc.column1 = "imf01"             
                 LET g_doc.value1 = g_ima.ima01         
                 CALL cl_doc()                          
               END IF                                   
           END IF      
         #No.FUN-680046-------add--------end----
         #FUN-B10041 --START--
         WHEN "batch_delete"   #刪除指定倉庫關聯資料
            IF cl_chk_act_auth() THEN
               CALL i202_batch_delete()
            END IF
         #FUN-B10041 --END--
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
   CALL g_imf.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i202_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        OPEN i202_count
        FETCH i202_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i202_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式   #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數 #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i202_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS i202_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    i202_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     i202_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            FETCH ABSOLUTE g_jump i202_cs INTO g_ima.ima01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660156 MARK
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        INITIALIZE g_ima.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_ima.imauser #FUN-4C0053
        LET g_data_group = g_ima.imagrup #FUN-4C0053
    END IF
 
 
    CALL i202_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i202_show()
    DISPLAY g_ima.ima01 TO imf01
    DISPLAY BY NAME                              # 顯示單頭值
        g_ima.ima02,g_ima.ima021,g_ima.ima05,g_ima.ima08,g_ima.ima25
 
    CALL i202_b_fill(g_wc2)                 #單身
# genero  script marked     LET g_imf_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i202_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態           #No.FUN-690026 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(60)
    l_factor	    LIKE ima_file.ima63_fac,
    l_flag	    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_ime10         LIKE ime_file.ime10,    #發料優先順序
    l_ime11         LIKE ime_file.ime11,    #發料優先順序
    l_sw            LIKE type_file.chr1,    #wip or storage  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否        #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否        #No.FUN-690026 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_ima.* FROM ima_file
     WHERE ima01=g_ima.ima01
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ima.ima01,'mfg1000',0)   
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
    #" SELECT imf02,imf03,imf04 ",#TQC-CC0051 mark by xuxz
     " SELECT imf02,'',imf03,'',imf04",#TQC-CC0051 add by xuxz
     "   FROM imf_file ",
     "   WHERE imf01 = ? ",
     "    AND imf02 = ? ",
     "    AND imf03 = ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_imf WITHOUT DEFAULTS FROM s_imf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_imf_t.* = g_imf[l_ac].*  #BACKUP
              LET g_imf_o.* = g_imf[l_ac].*  #BACKUP
              BEGIN WORK
 
              OPEN i202_bcl USING g_ima.ima01,g_imf_t.imf02,g_imf_t.imf03
              IF STATUS THEN
                 CALL cl_err("OPEN i202_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i202_bcl INTO g_imf[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_imf_t.imf02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_imf[l_ac].imf03 IS NULL THEN
              LET g_imf[l_ac].imf03 = ' '
           END IF
           INSERT INTO imf_file (imf01,imf02,imf03,imf04)
                VALUES(g_ima.ima01,g_imf[l_ac].imf02,g_imf[l_ac].imf03,
	               g_imf[l_ac].imf04)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_imf[l_ac].imf02,SQLCA.sqlcode,0)   #No.FUN-660156
               CALL cl_err3("ins","imf_file",g_ima.ima01,g_imf[l_ac].imf02,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_imf[l_ac].* TO NULL      #900423
           LET g_imf[l_ac].imf04 = 999999999   #Body default
           LET g_imf_t.* = g_imf[l_ac].*         #新輸入資料
           LET g_imf_o.* = g_imf[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD imf02
 
        AFTER FIELD imf02
	    IF NOT cl_null(g_imf[l_ac].imf02) THEN
              #No.B052 010326 by plum
              #SELECT * FROM imd_file WHERE imd01 = g_imf[l_ac].imf02
               SELECT * FROM imd_file
                  WHERE imd01 = g_imf[l_ac].imf02 AND imdacti='Y'
              #TQC-CC0051--add
               SELECT imd02 INTO g_imf[l_ac].imd02 FROM imd_file
                  WHERE imd01 = g_imf[l_ac].imf02 AND imdacti='Y'
             #TQC-CC0051--add
              #No.B052 ...end
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_imf[l_ac].imf02,'mfg1100',0)  #No.FUN-660156 MARK
                  CALL cl_err3("sel","imf_file",g_imf[l_ac].imf02,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660156
                  LET g_imf[l_ac].imf02 = g_imf_o.imf02
                  DISPLAY g_imf[l_ac].imf02 TO s_imf[l_sl].imf02
                  NEXT FIELD imf02
	       END IF
            END IF
	    LET g_imf_o.imf02 = g_imf[l_ac].imf02
            LET g_imf_o.imd02 = g_imf[l_ac].imd02     #TQC-CC0051--add
	 IF NOT cl_null(g_imf[l_ac].imf02) THEN                                                #FUN-D40103 add
               IF NOT s_imechk(g_imf[l_ac].imf02,g_imf[l_ac].imf03) THEN NEXT FIELD imf03 END IF  #FUN-D40103 ad
	END IF
 
        AFTER FIELD imf03
            IF g_imf[l_ac].imf03 IS NULL THEN
                LET g_imf[l_ac].imf03 = ' '
            END IF
	#FUN-D40103--add--str--
            IF NOT s_imechk(g_imf[l_ac].imf02,g_imf[l_ac].imf03) THEN 
               LET g_imf[l_ac].imf03 = g_imf_o.imf03
               NEXT FIELD imf03
            END IF 
            #FUN-D40103--add--end--
            IF (g_imf[l_ac].imf02 !=g_imf_t.imf02)
              OR (g_imf[l_ac].imf03 !=g_imf_t.imf03 OR
                  g_imf[l_ac].imf03 != ' '      AND g_imf_t.imf03 IS NULL)
                 THEN
	#FUN-D40103--mark--str--
        #           SELECT ime01 FROM ime_file        # location is not null
        #            WHERE ime02 = g_imf[l_ac].imf03
        #              AND ime01 = g_imf[l_ac].imf02
        #      #TQC-CC0051--add
        #           SELECT ime03 INTO g_imf[l_ac].ime03 FROM ime_file       
        #            WHERE ime02 = g_imf[l_ac].imf03
         #             AND ime01 = g_imf[l_ac].imf02
         #     #TQC-CC0051--add
         #             IF SQLCA.sqlcode THEN
     	 #              LET g_msg = g_imf[l_ac].imf02 CLIPPED, ' + ',
         #  				   g_imf[l_ac].imf03 CLIPPED
#        #                    CALL cl_err(g_msg,'mfg1101',0)   #No.FUN-660156 MARK
         #                    CALL cl_err3("sel","ime_file",g_msg,"",
         #                                  "mfg1101","","",1)  #No.FUN-660156
         #                    LET g_imf[l_ac].imf03 = g_imf_o.imf03
         #                    NEXT FIELD imf03
         #              END IF
	#FUN-D40103--mark--end--         
           SELECT count(*) INTO l_n FROM imf_file
                      WHERE imf01=g_ima.ima01
                        AND imf02=g_imf[l_ac].imf02
                        AND imf03=g_imf[l_ac].imf03
                    IF l_n >0 THEN
                             CALL cl_err(g_msg,-239,0)
                             LET g_imf[l_ac].imf03 = g_imf_o.imf03
                             NEXT FIELD imf02
                    END IF
 
             END IF
	    LET g_imf_o.imf03 = g_imf[l_ac].imf03
            LET g_imf_o.ime03 = g_imf[l_ac].ime03     #TQC-CC0051--add
 
        AFTER FIELD imf04
           #FUN-BB0083---add---str
            LET g_imf[l_ac].imf04 = s_digqty(g_imf[l_ac].imf04,g_ima.ima25)  
            DISPLAY BY NAME g_imf[l_ac].imf04
           #FUN-BB0083---add---end
	    IF NOT cl_null(g_imf[l_ac].imf04) THEN
               IF g_imf[l_ac].imf04 <0 THEN
		   LET g_imf[l_ac].imf04 = 0
                   NEXT FIELD imf04
               END IF
            ELSE
		LET g_imf[l_ac].imf04 = 0
	    END IF
 
        BEFORE DELETE                            #是否取消單身
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
#No.TQC-7B0016 --begin
            IF NOT cl_delb(0,0) THEN                                                                                              
               CANCEL DELETE                                                                                                      
            END IF 
#No.TQC-7B0016 --end
            DELETE FROM imf_file
                WHERE imf01 = g_ima.ima01 AND
                      imf02 = g_imf_t.imf02 AND
                      imf03 = g_imf_t.imf03
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_imf_t.imf02,SQLCA.sqlcode,0)  #No.FUN-660156 MARK
                CALL cl_err3("del","ime_file",g_ima.ima01,g_imf_t.imf02,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imf[l_ac].* = g_imf_t.*
               CLOSE i202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_imf[l_ac].imf02,-263,1)
                LET g_imf[l_ac].* = g_imf_t.*
            ELSE
                IF g_imf[l_ac].imf03 IS NULL THEN
                    LET g_imf[l_ac].imf03 = ' '
                END IF
                UPDATE imf_file
                     SET
                   imf02 = g_imf[l_ac].imf02,
                   imf03 = g_imf[l_ac].imf03,
                   imf04 = g_imf[l_ac].imf04
                 WHERE imf01 = g_ima.ima01
                   AND imf02 = g_imf_t.imf02
                   AND imf03 = g_imf_t.imf03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_imf[l_ac].imf02,SQLCA.sqlcode,0)   #No.FUN-660156 MARK
                   CALL cl_err3("upd","imf_file",g_ima.ima01,g_imf_t.imf02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    LET g_imf[l_ac].* = g_imf_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_imf[l_ac].* = g_imf_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_imf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i202_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(imf02)
                  #CALL q_imd(10,3,g_imf[l_ac].imf02,"A") RETURNING g_imf[l_ac].imf02
                  #CALL FGL_DIALOG_SETBUFFER( g_imf[l_ac].imf02 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_imd"
                   LET g_qryparam.default1 = g_imf[l_ac].imf02
                    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   CALL cl_create_qry() RETURNING g_imf[l_ac].imf02
                   DISPLAY g_imf[l_ac].imf02 TO imf02
#                  CALL FGL_DIALOG_SETBUFFER( g_imf[l_ac].imf02 )
                WHEN INFIELD(imf03)
                  #CALL q_ime(10,3,g_imf[l_ac].imf03,g_imf[l_ac].imf02,'A') RETURNING g_imf[l_ac].imf03
                  #CALL FGL_DIALOG_SETBUFFER( g_imf[l_ac].imf03 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ime"
                    LET g_qryparam.arg1     = g_imf[l_ac].imf02 #倉庫編號 #MOD-4A0063
                    LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                   LET g_qryparam.default1 = g_imf[l_ac].imf03
                   CALL cl_create_qry() RETURNING g_imf[l_ac].imf03
                   DISPLAY g_imf[l_ac].imf03 TO imf03
#                  CALL FGL_DIALOG_SETBUFFER( g_imf[l_ac].imf03 )
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION mntn_warehouse
               LET l_cmd = "aimi200 " CLIPPED
               CALL cl_cmdrun(l_cmd)
 
        ON ACTION mntn_location
               LET l_cmd = "aimi201 '",g_imf[l_ac].imf02,"'"
               CALL cl_cmdrun(l_cmd)
 
      # ON ACTION CONTROLN
      #     CALL i202_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(imf02) AND l_ac > 1 THEN
                LET g_imf[l_ac].* = g_imf[l_ac-1].*
                DISPLAY g_imf[l_ac].* TO s_imf[l_ac].*
                NEXT FIELD imf02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------ 
 
        END INPUT
 
    CLOSE i202_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
  # CLEAR imf06                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON imf02,imf03,imf04
            FROM s_imf[1].imf02,s_imf[1].imf03,s_imf[1].imf04
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i202_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i202_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
       #"SELECT imf02,imf03,imf04 ",#TQC-CC0051 mark by xuxz
        "SELECT imf02,'',imf03,'',imf04 ",#TQC-CC0051 add by xuxz 
        " FROM imf_file",
        " WHERE imf01 ='",g_ima.ima01,
        "' AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY imf02"
    PREPARE i202_pb FROM g_sql
    DECLARE imf_curs                       #SCROLL CURSOR
        CURSOR FOR i202_pb
 
    CALL g_imf.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH imf_curs INTO g_imf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
              #TQC-CC0051--add
               SELECT imd02 INTO g_imf[g_cnt].imd02 FROM imd_file
                  WHERE imd01 = g_imf[g_cnt].imf02 AND imdacti='Y'
            LET g_imf_o.imd02 = g_imf[g_cnt].imd02     #TQC-CC0051--add
                   SELECT ime03 INTO g_imf[g_cnt].ime03 FROM ime_file
                    WHERE ime02 = g_imf[g_cnt].imf03
                      AND ime01 = g_imf[g_cnt].imf02
			AND imeacti = 'Y'                #FUN-D40103  add
            LET g_imf_o.ime03 = g_imf[g_cnt].ime03     #TQC-CC0051--add
              #TQC-CC0051--add
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_imf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imf TO s_imf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
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
    #@ON ACTION 整批產生
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
    #@ON ACTION 產生倉庫資料
      ON ACTION gen_w_h_data
         LET g_action_choice="gen_w_h_data"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
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
 
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document             #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY    
     
      #FUN-B10041 --START--
      ON ACTION batch_delete
         LET g_action_choice="batch_delete"
         EXIT DISPLAY
      #FUN-B10041 --END--

       # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------ 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i202_copy()
DEFINE
    l_oldno         LIKE ima_file.ima01,
    l_newno         LIKE ima_file.ima01
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM imf01
	    BEFORE FIELD imf01
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(7,17,l_newno) RETURNING l_newno
	                 DISPLAY l_newno TO imf01
            END IF
 
        AFTER FIELD imf01
            IF l_newno IS NULL THEN
                NEXT FIELD imf01
            END IF
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD imf01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            SELECT count(*) INTO g_cnt FROM ima_file
             WHERE ima01 = l_newno AND imaacti = 'Y'
            IF g_cnt = 0 THEN
               CALL cl_err(l_newno,'mfg1201',0)
              #No.B069 010326 by plum
              #NEXT FIELD ima01
               NEXT FIELD imf01
              #No.B069 ..end
            END IF
            SELECT count(*) INTO g_cnt FROM imf_file
                WHERE imf01 = l_newno
            IF g_cnt > 0
               THEN
                    CALL cl_err('','mfg1202',0)
                    NEXT FIELD imf01
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
        DISPLAY  g_ima.ima01 TO imf01
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM imf_file         #單身複製
        WHERE imf01=g_ima.ima01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660156 MARK
        CALL cl_err3("ins","x",g_ima.ima01,"",
                      SQLCA.sqlcode,"","",1)  #No.FUN-660156
        RETURN
    END IF
    UPDATE x
        SET imf01=l_newno
    UPDATE x SET imf03=' ' WHERE imf03 is null AND imf01=l_newno
    UPDATE x SET imf02=' ' WHERE imf02 is null AND imf01=l_newno
 
    INSERT INTO imf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156 MARK
        CALL cl_err3("ins","imf_file",g_ima.ima01,"",
                      SQLCA.sqlcode,"","",1)  #No.FUN-660156
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_ima.ima01
    LET g_ima.ima01 = l_newno
    SELECT ima01 INTO g_ima.ima01 FROM ima_file WHERE ima01 = l_newno
    CALL i202_b()
    #LET g_ima.ima01 = l_oldno  #FUN-C30027
    #SELECT ima01 INTO g_ima.ima01 FROM ima_file WHERE ima01 = l_oldno  #FUN-C30027
    CALL i202_show()
    DISPLAY g_ima.ima01 TO imf01
END FUNCTION
#No.FUN-780040 --start--
{FUNCTION i202_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD
        imf01       LIKE imf_file.imf01,   #料件編號
        imf02       LIKE imf_file.imf02,   #倉庫編號
        imf03       LIKE imf_file.imf03,   #存放位置
        imf04       LIKE imf_file.imf04    #最高存量限制
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #  #No.FUN-690026 VARCHAR(40)
 
    IF cl_null(g_wc) THEN
        LET g_wc=" ima01='",g_ima.ima01,"'"
        LET g_wc2 = ' 1=1'
    END IF
    CALL cl_wait()
    CALL cl_outnam('aimi202') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT imf01,imf02,imf03,imf04",
          " FROM imf_file,ima_file ",
          " WHERE imf01=ima01 AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED,
          " AND imaacti = 'Y'",
         #No.B019 010326 by plum
         #" ORDER BY imf06"
          " ORDER BY imf01,imf02,imf03,imf04"
         #No.B019 ..end
    DISPLAY g_sql
    PREPARE i202_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.SQLCODE THEN
       CALL cl_err('pare: ',SQLCA.SQLCODE,0)
       RETURN
    END IF
    DECLARE i202_co CURSOR FOR i202_p1
 
    START REPORT i202_rep TO l_name
 
    FOREACH i202_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i202_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i202_rep
 
    CLOSE i202_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i202_rep(sr)
DEFINE l_ima02      LIKE ima_file.ima02    #FUN-510017
DEFINE l_ima021     LIKE ima_file.ima021   #FUN-510017
DEFINE l_trailer_sw LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
       l_i          LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       sr           RECORD
        imf01       LIKE imf_file.imf01,   #料件編號
        imf02       LIKE imf_file.imf02,   #倉庫編號
        imf03       LIKE imf_file.imf03,   #存放位置
        imf04       LIKE imf_file.imf04    #最高存量限制
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.imf01,sr.imf02,sr.imf03,sr.imf04
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1
         #  LET l_trailer_sw = 'y'
            LET l_trailer_sw = 'n'     #No.TQC-740338
 
	BEFORE GROUP OF sr.imf01
            SELECT ima02,ima021 INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = sr.imf01
            IF SQLCA.sqlcode THEN
                LET l_ima02  = NULL
                LET l_ima021 = NULL
            END IF
	    PRINT  COLUMN g_c[31],sr.imf01,
	           COLUMN g_c[32],l_ima02,
	           COLUMN g_c[33],l_ima021;
	BEFORE GROUP OF sr.imf02
	    PRINT COLUMN g_c[34],sr.imf02 ;
	BEFORE GROUP OF sr.imf03
	    PRINT COLUMN g_c[35], sr.imf03 ;
 
        ON EVERY ROW
	    PRINT COLUMN g_c[36], cl_numfor(sr.imf04,36,3)
 
	AFTER  GROUP OF sr.imf01
	    PRINT
        ON LAST ROW
            PRINT g_dash
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED
         #  LET l_trailer_sw = 'n'
            LET l_trailer_sw = 'y'    #No.TQC-740338
        PAGE TRAILER
         #  IF l_trailer_sw = 'y' THEN
            IF l_trailer_sw = 'n' THEN      #No.TQC-740338
                PRINT g_dash
          #     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED    #No.TQC-740338
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUn-780040 --end--
 
#---- 97/06/23 新增 G.產生功能
FUNCTION i202_gen()
   DEFINE l_wc    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
   DEFINE g_stk   LIKE imf_file.imf02,   #FUN-660078
          g_loc   LIKE imf_file.imf03,    #FUN-660078
          g_imf04 LIKE imf_file.imf04    #TQC-CC0051--add
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   LET p_row = 6 LET p_col = 10
   OPEN WINDOW i202_w1 AT p_row,p_col         #顯示畫面
        WITH FORM "aim/42f/aimi2021"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimi2021")
   
   
   CONSTRUCT l_wc ON ima01,ima06,ima09,ima10,ima11,ima12
                FROM ima01,ima06,ima09,ima10,ima11,ima12
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN

 #TQC-CC0051--add
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima011"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01 
               NEXT FIELD ima01 
            WHEN INFIELD(ima06)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            WHEN INFIELD(ima09)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima09_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            WHEN INFIELD(ima10)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima10_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima10
               NEXT FIELD ima10
            WHEN INFIELD(ima11)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima11_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima12_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            OTHERWISE EXIT CASE
         END CASE
 #TQC-CC0051--add
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
 
 ### 00/06/14 modify by connie
 #  IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i202_w1 RETURN END IF
 
   LET g_stk = ' '
   LET g_loc = ' '
   LET g_imf04 = ' '  #TQC-CC0051--add
   INPUT g_stk,g_loc,g_imf04 FROM g_stk,g_loc,g_imf04     #TQC-CC0051--add
     AFTER FIELD g_stk
         IF g_stk IS NULL OR g_stk=' ' THEN
            NEXT FIELD g_stk
         END IF
        #------------No.MOD-6B0106 modify
        #SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_stk  
         SELECT COUNT(*) INTO l_cnt FROM imd_file  
                WHERE imd01=g_stk  AND imdacti = 'Y'     #No.MOD-7A0200 modify
        #------------No.MOD-6B0106 end 
         IF l_cnt=0 THEN
            CALL cl_err(g_stk,'mfg1100',0)
            NEXT FIELD g_stk
         END IF
	 IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF  #FUN-D40103 add
 
      AFTER FIELD g_loc
	#FUN-D40103--mark--str--
        # IF g_loc IS NOT NULL AND g_loc !=' ' THEN
        #    SELECT COUNT(*) INTO l_cnt FROM ime_file
        #       WHERE ime01=g_stk AND ime02=g_loc
        #    IF l_cnt=0 THEN
        #       CALL cl_err(g_loc,'mfg1101',0)
        #       NEXT FIELD g_loc
        #    END IF
        # END IF
	#FUN-D40103--mark--end--
         IF g_loc IS NULL THEN LET g_loc=' ' END IF
 	  IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF  #FUN-D40103 add

#TQC-CC0051--add
      AFTER FIELD g_imf04
         IF g_imf04 IS NOT NULL AND g_imf04 !=' ' THEN
            LET g_imf04 = g_imf04 
         END IF
         IF g_imf04 IS NULL THEN LET g_imf04=999999999  END IF
#TQC-CC0051--add
 
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(g_stk)
              #CALL q_imd(5,11,g_stk,'A') RETURNING g_stk
              #CALL FGL_DIALOG_SETBUFFER( g_stk )
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imd"
               LET g_qryparam.default1 = g_stk
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_stk
#               CALL FGL_DIALOG_SETBUFFER( g_stk )
               DISPLAY BY NAME g_stk
               NEXT FIELD g_stk
            WHEN INFIELD(g_loc)
              #CALL q_ime(5,11,g_loc,g_stk,'A') RETURNING g_loc
              #CALL FGL_DIALOG_SETBUFFER( g_loc )
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ime"
               LET g_qryparam.default1 = g_loc
                LET g_qryparam.arg1     = g_stk             #倉庫編號 #MOD-4A0063
                LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
               CALL cl_create_qry() RETURNING g_loc
#               CALL FGL_DIALOG_SETBUFFER( g_loc )
               DISPLAY BY NAME g_loc
               NEXT FIELD g_loc
            OTHERWISE EXIT CASE
         END CASE
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
      CLOSE WINDOW i202_w1
       RETURN         #No.MOD-480049
   END IF
 
   CALL cl_wait()
   LET l_cnt=0
   LET l_sql = "SELECT * FROM ima_file WHERE 1=1 AND ",l_wc CLIPPED
   PREPARE i2021_prepare FROM l_sql
   DECLARE i2021_cs CURSOR FOR i2021_prepare
   FOREACH i2021_cs INTO l_ima.*
#FUN-AB0059 ---------------------start----------------------------
       IF NOT s_chk_item_no(l_ima.ima01,"") THEN
          CONTINUE FOREACH
       END IF
#FUN-AB0059 ---------------------end-------------------------------
       SELECT COUNT(*) INTO l_cnt FROM imf_file
          WHERE imf01=l_ima.ima01 AND imf02=g_stk AND imf03=g_loc
       IF l_cnt=0 THEN
          IF g_loc IS NULL THEN LET g_loc=' ' END IF
          INSERT INTO imf_file (imf01,imf02,imf03,imf04)
                        VALUES (l_ima.ima01,g_stk,g_loc,g_imf04)
       END IF
   END FOREACH
 
   SLEEP 1
   ERROR ""
   CLOSE WINDOW i202_w1
END FUNCTION
 
### 單筆產生改為多筆產生 ,00/06/14 by connie
FUNCTION i202_ins_img()
   DEFINE l_img     RECORD LIKE img_file.*
   DEFINE l_imf     RECORD LIKE imf_file.*,
          l_n       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_ima71   LIKE ima_file.ima71,    #儲存有效天數
          l_ima25   LIKE ima_file.ima25,    #庫存單位
          g_buf     LIKE gfe_file.gfe02
   DEFINE l_wc      LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
   DEFINE g_stk     LIKE imf_file.imf02,    #FUN-660078
          g_loc     LIKE imf_file.imf03     #FUN-660078
   DEFINE l_ima     RECORD LIKE ima_file.*  
   DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
   DEFINE l_cnt     LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   LET INT_FLAG = 0
   LET p_row = 6 LET p_col = 18
   OPEN WINDOW i202_w1 AT p_row,p_col        #顯示畫面
        WITH FORM "aim/42f/aimi2021"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_set_comp_visible("g_stk,g_loc,group02",FALSE)  #MOD-6B0105 add
 
   CALL cl_ui_locale("aimi2021")
 
   CONSTRUCT l_wc ON ima01,ima06,ima09,ima10,ima11,ima12
                FROM ima01,ima06,ima09,ima10,ima11,ima12
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
  #TQC-CC0051--add
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima011"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            WHEN INFIELD(ima06)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            WHEN INFIELD(ima09)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima09_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            WHEN INFIELD(ima10)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima10_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima10
               NEXT FIELD ima10
            WHEN INFIELD(ima11)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima11_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima12_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            OTHERWISE EXIT CASE
         END CASE
 #TQC-CC0051--add
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW i202_w1 RETURN
   END IF
 
   CALL cl_wait()
   BEGIN WORK
   LET g_success='Y'
   LET l_cnt=0
   LET l_sql = "SELECT * FROM ima_file WHERE 1=1 AND ",l_wc CLIPPED
   PREPARE i2022_prepare FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare ima',SQLCA.SQLCODE,1)
      CLOSE WINDOW i202_w1 RETURN
   END IF
  #No.B019 010326 by plum
  #DECLARE i2022_cs CURSOR FOR i2021_prepare
   DECLARE i2022_cs CURSOR FOR i2022_prepare
  #No.B019 ..end
   FOREACH i2022_cs INTO g_ima.*
#FUN-AB0059 ---------------------start----------------------------
       IF NOT s_chk_item_no(g_ima.ima01,"") THEN
          CONTINUE FOREACH
       END IF
#FUN-AB0059 ---------------------end-------------------------------
     DECLARE insimg_cs CURSOR FOR
      SELECT * FROM imf_file WHERE imf01=g_ima.ima01
     FOREACH insimg_cs INTO l_imf.*
       SELECT COUNT(*) INTO l_n FROM img_file
        WHERE img01 = l_imf.imf01 AND img02 = l_imf.imf02
          AND img03 = l_imf.imf03 AND img04 = ' '
       IF l_n > 0 THEN CONTINUE FOREACH END IF
       LET l_img.img01 = l_imf.imf01
       LET l_img.img02 = l_imf.imf02
       LET l_img.img03 = l_imf.imf03
 
       SELECT ima25,ima71 INTO l_ima25,l_ima71 FROM ima_file
        WHERE ima01=l_img.img01
       IF SQLCA.sqlcode OR cl_null(l_ima71) THEN LET l_ima71=0 END IF
 
       LET l_img.img04 = ' '
       LET l_img.img08 = 0
       LET l_img.img09 = l_ima25
       LET l_img.img10 = 0
       LET l_img.img13 = null    #No.7304
       LET l_img.img14 = g_today
       LET l_img.img15 = g_today
       LET l_img.img16 = g_today
       LET l_img.img17 = g_today
       IF l_ima71 = 0                            #儲存有效天數
          THEN LET l_img.img18 = g_lastdat
          ELSE LET l_img.img18 = g_today + l_ima71
       END IF
       LET l_img.img20 = 1                       #轉換率
       LET l_img.img21 = 1                       #轉換率
       SELECT ime04,ime05,ime06,ime07,ime09
         INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26
         FROM ime_file
        WHERE ime01 = l_img.img02 AND ime02 = l_img.img03
	 AND imeacti = 'Y'    #FUN-D40103 add
       IF STATUS = 100 THEN
          LET l_img.img22='S'                    #倉儲類別
          LET l_img.img23='Y'                    #是否為可用倉儲
          LET l_img.img24='N'                    #是否為MRP可用倉儲
          LET l_img.img25='N'                    #保稅與否
       END IF
      #LET l_img.img27 = l_imf.imf06
      #LET l_img.img28 = l_imf.imf07
       LET l_img.img37 = g_today
       IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
       IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
       IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
       #No.FUN-980004 S
       LET l_img.imgplant = g_plant
       LET l_img.imglegal = g_legal
       #No.FUN-980004 E
       IF s_internal_item( l_img.img01,g_plant ) AND NOT s_joint_venture( l_img.img01 ,g_plant) THEN  #FUN-A90049 add
          INSERT INTO img_file VALUES (l_img.*)
      #No.+035 010329 by plum modi 判斷status-> sqlca.sqlcode
      #IF STATUS THEN
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins img',SQLCA.SQLCODE,1) LET g_success='N' EXIT FOREACH
          CALL cl_err3("ins","img_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
          LET g_success='N' EXIT FOREACH           
       ELSE
          MESSAGE 'Insert img:',l_img.img02 CLIPPED,'/',l_img.img03
       END IF
       END IF         #FUN-A90049 add
     END FOREACH
     IF g_success = "N" THEN EXIT FOREACH END IF
   END FOREACH
   IF g_success='Y' THEN
      MESSAGE 'Insert Ok!'
      COMMIT WORK CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK CALL cl_rbmsg(1)
   END IF
   CALL cl_set_comp_visible("g_stk,g_loc,group02",TRUE)  #MOD-6B0105 add
   CLOSE WINDOW i202_w1
END FUNCTION
 
#FUN-B10041 --START--
FUNCTION i202_batch_delete()
   DEFINE l_wc    LIKE type_file.chr1000
   DEFINE l_wc2   LIKE type_file.chr1000
   DEFINE l_sql   LIKE type_file.chr1000
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_imf01 LIKE imf_file.imf01
   DEFINE l_wh    LIKE imf_file.imf02

   LET p_row = 6 LET p_col = 10
   OPEN WINDOW i202_w2 AT p_row,p_col         #顯示畫面
        WITH FORM "aim/42f/aimi2022"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aimi2022")

   WHILE TRUE    
      CONSTRUCT l_wc ON imf01,imf02 FROM imf01,wh
   
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION about
            CALL cl_about()
   
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION controlg
            CALL cl_cmdask()
   
	     ON ACTION qbe_select
            CALL cl_qbe_select()
   
         ON ACTION qbe_save
		      CALL cl_qbe_save()
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imf01)                  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.default1 = l_imf01                        
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imf01 
               WHEN INFIELD(wh)                  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd"
                  LET g_qryparam.default1 = l_wh  
                  LET g_qryparam.arg1     = 'SW'       
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wh                
               OTHERWISE
                  EXIT CASE
            END CASE          
      END CONSTRUCT      
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i202_w2
         RETURN
      END IF

      IF cl_null(l_wc) OR l_wc = " 1=1" THEN 
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF 
   
      IF NOT cl_delete() THEN
         CONTINUE WHILE 
      END IF 
   
      #檢查庫存資料明細檔
      LET l_cnt=0      
      LET l_wc2 = cl_replace_str(l_wc,"imf","img")         
      LET l_sql = "SELECT COUNT(*) FROM img_file WHERE img10 <> 0 AND ",l_wc2 CLIPPED
      
      PREPARE i2022_p1 FROM l_sql
      DECLARE i2022_c1 CURSOR FOR i2022_p1
      OPEN i2022_c1
      FETCH i2022_c1 INTO l_cnt   
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('fetch i2022_c1',SQLCA.sqlcode,1)
         CLOSE i2022_c1
         CONTINUE WHILE
      END IF
      CLOSE i2022_c1
      IF l_cnt > 0 THEN
         CALL cl_err('','aim-165',1)
         CONTINUE WHILE
      END IF 
   
      #檢查多單位庫存明細檔
      LET l_cnt=0      
      LET l_wc2 = cl_replace_str(l_wc,"imf","imgg")      
      LET l_sql = "SELECT COUNT(*) FROM imgg_file WHERE imgg10 <> 0 AND ",l_wc2 CLIPPED
      
      PREPARE i2022_p2 FROM l_sql
      DECLARE i2022_c2 CURSOR FOR i2022_p2
      OPEN i2022_c2
      FETCH i2022_c2 INTO l_cnt
      IF SQLCA.SQLCODE THEN 
         CALL cl_err("fetch i2022_c2",SQLCA.sqlcode,1)      
         CLOSE i2022_c2
         CONTINUE WHILE  
      END IF  
      CLOSE i2022_c1
      IF l_cnt > 0 THEN
         CALL cl_err('','aim-165',1)
         CONTINUE WHILE
      END IF 

      #刪除料件預設倉庫/存放位置資料檔
      LET l_sql = "DELETE FROM imf_file where ", l_wc CLIPPED   
      PREPARE i2022_p3 FROM l_sql
      EXECUTE i2022_p3
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete imf_file error',SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
      IF SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('','agl-118',1)
         CONTINUE WHILE
      END IF 
      
      EXIT WHILE 
   END WHILE
   ERROR "DELETE O.K"
   CLOSE WINDOW i202_w2
END FUNCTION

#FUN-B10041 --END--
