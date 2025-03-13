# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aimq232.4gl
# Descriptions...: 料件BIN卡成本查詢 (依單據日期)
# Date & Author..: 01/04/30 By Tommy 入項成本抓原單據單價(採購入,雜入,同業借入)
#                                    出項成本則抓該月月加權平均成本
# Modify.........: No.MOD-480142 04/08/11 By Nicola 單身不會即時更新
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4C0010 04/12/02 By Mandy DEFINE 跟smydesc相關欄位放大CHAR(80)
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550029 05/05/26 By day  單據編號加大  
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730117 07/04/02 By Judy 匯出Excel的值有誤
# Modify.........: No.MOD-780249 07/09/18 By pengu 成本單價幣別應統一為本幣
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0025 09/12/21 By jan 單頭加‘成本分類’/單身加‘類別編號’ 欄位
# Modify.........: No:CHI-A80048 10/09/17 By Summer 來源碼、庫存單位、目前庫存欄位在查詢時，可開放查詢
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-BA0027 11/11/03 By jason INPUT時，改成打年度月份就好
# Modify.........: No:CHI-B50025 13/01/18 By Alberti 若抓不到成本單價應改抓開帳成本
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm           RECORD
                 wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)
                 wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)
                 END RECORD,
    g_img        RECORD
                 img01  LIKE img_file.img01, # 料件編號
                 img02  LIKE img_file.img02, # 倉庫編號
                 img03  LIKE img_file.img03, # 存放位置
                 img04  LIKE img_file.img04, # 批號
                 img09  LIKE img_file.img09, # 單位
                 img10  LIKE img_file.img10  # 目前庫存
                 END RECORD,
    g_bdate      LIKE type_file.dat,         # 期初庫存  #No.FUN-690026 DATE
    g_edate      LIKE type_file.dat,         #FUN_BA0027
    g_yy         LIKE type_file.num5,        #FUN-BA0027
    g_mm         LIKE type_file.num5,        #FUN-BA0027
    g_imk09      LIKE imk_file.imk09,        # 期初庫存
    g_ima02      LIKE ima_file.ima02,        # 品名    
    g_ima021     LIKE ima_file.ima02,        # 品名    
    g_ima08      LIKE ima_file.ima08,        # 來源碼  
    g_pia30      LIKE pia_file.pia30,        # 初盤量  
    g_pia50      LIKE pia_file.pia50,        # 複盤量  
    g_year       LIKE imk_file.imk05,        # 年度    
    g_month      LIKE imk_file.imk06,        # 期別    
    g_tlff_1     DYNAMIC ARRAY OF RECORD
                 tlfcost LIKE tlf_file.tlfcost, #CHI-9C0025
                 tlf06   LIKE tlf_file.tlf06,  #產生日期             
                 cond    LIKE type_file.chr1000,#異動狀況#MOD-4C0010 #No.FUN-690026 VARCHAR(80)
                 tlf026  LIKE tlf_file.tlf026, #來源單號
                 tlf10   LIKE tlf_file.tlf10,  #異動數量
                 tlf11   LIKE tlf_file.tlf11,  #FROM單位
                 ccc23   LIKE ccc_file.ccc23,
                 tlf21   LIKE tlf_file.tlf21,  
                 tlf024  LIKE tlf_file.tlf024  #FROM異動後數量
                 END RECORD,
    g_tlf13      LIKE tlf_file.tlf13, # 異動命令 
    g_tlf08      LIKE tlf_file.tlf08, # TIME
    g_tlf12      LIKE tlf_file.tlf12, # MOD-530179
    g_tlf02      LIKE tlf_file.tlf02, #
    g_tlf03      LIKE tlf_file.tlf03, #
    g_tlf031     LIKE tlf_file.tlf031, #
    g_tlf032     LIKE tlf_file.tlf032, #
    g_tlf033     LIKE tlf_file.tlf033, #
    g_tlf034     LIKE tlf_file.tlf034, # TO 異動後數量
    g_tlf035     LIKE tlf_file.tlf035, # TO 單位
    g_tlf036     LIKE tlf_file.tlf036, 
    g_tlf037     LIKE tlf_file.tlf037, 
    g_query_flag LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql        string,                #No.FUN-580092 HCN
    g_argv1      LIKE img_file.img01,   #No.FUN-690026 VARCHAR(20),
    i,m_cnt      LIKE type_file.num10,  #No.FUN-690026 INTEGER
    g_rec_b      LIKE type_file.num5    #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_type         LIKE type_file.chr1    #CHI-9C0025
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0074
   DEFINE     l_sl    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
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
    LET g_argv1=ARG_VAL(1)
    #LET g_msg=g_today USING 'yy/mm/dd' #FUN-570250 mark
    #LET g_msg[7,8]='01'   #FUN-BA0027 mark
    #LET g_bdate=DATE(g_msg) #FUN-570250 mark
    #LET g_bdate=g_today #FUN-570250 add     #FUN-BA0027 mark
    LET g_msg=MDY(g_today USING 'mm',1,g_today USING 'yy')   #FUN-BA0027
    CALL s_yp(g_today) RETURNING g_yy,g_mm   #FUN-BA0027
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q232_w AT p_row,p_col
         WITH FORM "aim/42f/aimq232" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'
    IF NOT cl_null(g_argv1) THEN CALL q232_q() END IF
    CALL q232_menu()
    CLOSE WINDOW q232_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q232_curs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   CLEAR FORM 
   CALL g_tlff_1.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   #DISPLAY g_bdate TO bdate     #FUN-BA0027 mark
   DISPLAY g_yy TO FORMONLY.yy   #FUN-BA0027
   DISPLAY g_mm TO FORMONLY.mm   #FUN-BA0027
   LET g_type = g_ccz.ccz28  #CHI-9C0025
   DISPLAY g_type TO type    #CHI-9C0025
   IF g_argv1<>' ' THEN
      DISPLAY g_argv1 TO img01
      LET tm.wc=" img01='",g_argv1,"'"
    ELSE
      INITIALIZE g_img.* TO NULL		#FUN-640213 add
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
     #CONSTRUCT BY NAME tm.wc ON img01, ima02,ima021,img02, img03, img04 #CHI-A80048 mark
      CONSTRUCT BY NAME tm.wc ON img01, ima02, ima021, ima08, img02, img03, img04, img09, img10 #CHI-A80048
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
     #FUN-530065                                                                 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(img01)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_img.img01                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO img01                                
            NEXT FIELD img01                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #FUN-530065
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   END IF
   #INPUT g_bdate,g_type WITHOUT DEFAULTS FROM bdate,type #CHI-9C0025 add type #FUN-BA0027 mark
   INPUT g_yy,g_mm,g_type WITHOUT DEFAULTS FROM yy,mm,type   #FUN-BA0027
      #FUN-BA0027 --START mark--
      #AFTER FIELD bdate
      #  IF cl_null(g_bdate) THEN
      #     CALL cl_err('','aim-372',0)
      #     NEXT FIELD bdate
      #  END IF
      #  IF DAY(g_bdate)!=1 THEN
      #     CALL cl_err('','aim-394',0)
      #     NEXT FIELD bdate
      #  END IF
      #FUN-BA0027 --END mark--
      #FUN-BA0027 --START--  
      BEFORE FIELD yy
        IF NOT cl_null(g_argv1) OR g_argv1 <> ' ' THEN
           EXIT INPUT
        END IF
      AFTER FIELD yy
         IF g_yy IS NULL OR g_yy < 999 OR g_yy>2100
            THEN NEXT FIELD yy
        END IF
     
      AFTER FIELD mm
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF   
      #FUN-BA0027 --END--   
      AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN       
        END IF
        #FUN-BA0027 --START mark--
        #IF cl_null(g_bdate) THEN
        #   CALL cl_err('','aim-372',0)
        #   NEXT FIELD bdate
        #END IF
        #FUN-BA0027 --END mark--
        #FUN-BA0027 --START--
        IF cl_null(g_yy) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD yy   
        END IF
        IF cl_null(g_mm) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD mm   
        END IF
        #FUN-BA0027 --END--
        
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #CALL s_yp(g_bdate) RETURNING g_year, g_month         #FUN-BA0027 mark    
    #LET g_month = g_month - 1                            #FUN-BA0027 mark 
    #IF g_month = 0 THEN LET g_month = 12 LET g_year = g_year - 1 END IF  #FUN-BA0027 mark    
    CALL s_lsperiod(g_yy,g_mm) RETURNING g_year,g_month   #FUN-BA0027
    CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate     #FUN-BA0027
    LET tm.wc2 = " tlf06 >= '",g_bdate,"'"
 
	MESSAGE ' WAIT ' 
    LET g_sql= " SELECT img01,img02,img03,img04,ima02,ima021,ima08,img10,imk09 ", #CHI-9C0025
              #CHI-A80048 mod --start--
              #" FROM img_file, OUTER ima_file, OUTER imk_file ",
              # " WHERE ima_file.ima01 = img_file.img01 ",
              # " AND   imk_file.imk01 = img_file.img01 ",
              # " AND   imk_file.imk02 = img_file.img02 ",
              # " AND   imk_file.imk03 = img_file.img03 ",
              # " AND   imk_file.imk04 = img_file.img04 ",
              # " AND   imk_file.imk05 ='",g_year,"'",
              # " AND   imk_file.imk06 ='",g_month,"'",
              # " AND ",tm.wc CLIPPED,
               "   FROM ima_file,img_file ",
               "        LEFT OUTER JOIN imk_file ON ",
               "        imk01 = img01 ",
               "    AND imk02 = img02 ",
               "    AND imk03 = img03 ",
               "    AND imk04 = img04 ",
               "    AND imk05 ='",g_year,"'",
               "    AND imk06 ='",g_month,"'",
               "  WHERE ",tm.wc CLIPPED,
               "    AND ima01 = img01 ",
              #CHI-A80048 mod --end--
               " ORDER BY img01"
    PREPARE q232_prepare FROM g_sql
    DECLARE q232_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q232_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) FROM img_file,ima_file ", #CHI-A80048 add ima_file
               " WHERE ",tm.wc CLIPPED,                   #CHI-A80048 add ,
               "   AND ima01=img01 "                      #CHI-A80048 add
    PREPARE q232_pp  FROM g_sql
    DECLARE q232_count   CURSOR FOR q232_pp
END FUNCTION
 
FUNCTION q232_b_askkey()
   CONSTRUCT tm.wc2 ON tlfcost,tlf06,tlf026,tlf10,tlf11,tlf21,tlf024 FROM  #CHI-9C0025
	   s_tlf[1].tlfcost,s_tlf[1].tlf06,s_tlf[1].tlf026,  #CHI-9C0025
	   s_tlf[1].tlf10,s_tlf[1].tlf11,s_tlf[1].tlf21,s_tlf[1].tlf024
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
 
FUNCTION q232_menu()
 
   WHILE TRUE
      CALL q232_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q232_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlff),'','')  #TQC-730117 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlff_1),'','')#TQC-730117
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q232_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q232_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q232_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q232_count
       FETCH q232_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q232_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q232_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q232_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04, #CHI-9C0025
                                             g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
        WHEN 'P' FETCH PREVIOUS q232_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04, #CHI-9C0025
                                             g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
        WHEN 'F' FETCH FIRST    q232_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04, #CHI-9C0025
                                             g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
        WHEN 'L' FETCH LAST     q232_cs INTO g_img.img01,
                                             g_img.img02,g_img.img03,g_img.img04, #CHI-9C0025
                                             g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
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
            FETCH ABSOLUTE g_jump q232_cs INTO g_img.img01,
                                               g_img.img02,g_img.img03,g_img.img04, #CHI-9C0025
                                               g_ima02,
                                               g_ima021,g_ima08,g_img.img10,g_imk09
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.*  TO NULL  #TQC-6B0105
        INITIALIZE g_ima02  TO NULL  #TQC-6B0105
        INITIALIZE g_ima021 TO NULL  #TQC-6B0105
        INITIALIZE g_ima08  TO NULL  #TQC-6B0105
        INITIALIZE g_imk09  TO NULL  #TQC-6B0105
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
 
	SELECT img01,img02,img03,img04,img09,img10
	  INTO g_img.* 
	  FROM img_file
      WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("sel","img_file",g_img.img01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
           RETURN
        END IF
 
    CALL q232_show()
END FUNCTION
 
FUNCTION q232_show()
   DISPLAY BY NAME g_img.*   # 顯示單頭值
   DISPLAY g_imk09 TO imk09
   IF g_imk09 IS NULL THEN LET g_imk09=0 END IF
   CALL q232_b_fill() #單身
   DISPLAY g_ima02, g_ima021,g_ima08,g_yy,g_mm  #FUN-BA0027 mark g_bdate add g_yy,g_mm
           TO ima02, ima021, ima08,yy,mm        #FUN-BA0027 mark bdate add yy,mm
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q232_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,  #No.FUN-690026 VARCHAR(1000)
          l_nouse   LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
   DEFINE l_pmm42   LIKE pmm_file.pmm42      #No.MOD-780249 add
   DEFINE l_yy      LIKE type_file.num5      #No:CHI-B50025 add
   DEFINE l_mm      LIKE type_file.num5      #No:CHI-B50025 add
 
   LET l_sql =
       #"SELECT tlf06,smydesc[1,8],tlf026,tlf10,tlf11,ccc23,tlf21,tlf024,",
        "SELECT tlfcost,tlf06,smydesc,tlf026,tlf10,tlf11,ccc23,tlf21,tlf024,", #MOD-4C0010#CHI-9C0025 add tlfcost
        "       tlf03,tlf031,tlf032,tlf033,tlf034,tlf035,tlf13,tlf08,",
        "       tlf12,tlf02,tlf036,tlf037 ",
       #" FROM  tlf_file,OUTER ccc_file,smy_file",  #CHI-9C0025
        " FROM  tlf_file LEFT OUTER JOIN ccc_file ON ccc01=tlf01 AND ccc02=YEAR(tlf06) ", #CHI-9C0025
        "  AND  ccc03=MONTH(tlf06) AND ccc07 = '",g_type,"' AND ccc08=tlfcost,smy_file",  #CHI-9C0025
        " WHERE tlf01 = '",g_img.img01,"'",
       #"   AND ccc_file.ccc01 = tlf_file.tlf01 ",      #CHI-9C0025
       #"   AND ccc_file.ccc02 = YEAR(tlf_file.tlf06) ",#CHI-9C0025
       #"   AND ccc_file.ccc03 = MONTH(tlf_file.tlf06) ",#CHI-9C0025
       #"   AND ccc07 = '1' ",            #No.FUN-840041 #CHI-9C0025
#No.FUN-550029--begin
#       "   AND tlf905[1,3] = smy_file.smyslip ",
        "   AND tlf905 like trim(smyslip) || '-%' ",
#No.FUN-550029--end   
        "   AND (tlf907 <> 0)  AND tlf902 = '",g_img.img02 ,"'",
        "   AND tlf903 = '",g_img.img03,"'",
        "   AND tlf904 = '",g_img.img04,"'",
    #   "   AND (tlf02 BETWEEN 50 AND 59  OR tlf03 BETWEEN 50 AND 59)", 
    #   "   AND ((tlf021 = '",g_img.img02,"'", 
    #           " AND tlf022 = '",g_img.img03,"'",
    #           " AND tlf023 = '",g_img.img04,"' )", 
    #           " OR ",
    #           "(tlf031 = '",g_img.img02,"'", 
    #           " AND tlf032 = '",g_img.img03,"'",
    #           " AND tlf033 = '",g_img.img04,"' ) )", 
        "  AND ",tm.wc2 CLIPPED,   #CHI-9C0025
        " ORDER BY tlfcost,tlf06,tlf08 "  #CHI-9C0025
    PREPARE q232_pb FROM l_sql
    DECLARE q232_bcs                       #BODY CURSOR
        CURSOR FOR q232_pb
 
    FOR g_cnt = 1 TO g_tlff_1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_tlff_1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET m_cnt = 1
    FOREACH q232_bcs INTO g_tlff_1[m_cnt].*,g_tlf03,
                          g_tlf031,g_tlf032,g_tlf033,g_tlf034,g_tlf035,g_tlf13,
                          g_tlf08,g_tlf12,g_tlf02,g_tlf036,g_tlf037
        IF m_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
            #-----------------No:CHI-B50025 add
        IF cl_null(g_tlff_1[m_cnt].ccc23) THEN
           LET l_yy = YEAR(g_tlff_1[m_cnt].tlf06)
           LET l_mm = MONTH(g_tlff_1[m_cnt].tlf06)
           IF l_mm = 12 THEN 
              LET l_yy = l_yy - 1
              LET l_mm = 12
           ELSE 
              LET l_mm = l_mm - 1
           END IF
           SELECT cca23 INTO g_tlff_1[m_cnt].ccc23 FROM cca_file
                  WHERE cca01 = g_img.img01 AND cca02 = l_yy
                    AND cca03 = l_mm AND cca06 = '1'
           IF SQLCA.sqlcode OR STATUS THEN
              LET g_tlff_1[m_cnt].ccc23 = ''
              LET g_tlff_1[m_cnt].tlf21 = ''
           ELSE 
              LET g_tlff_1[m_cnt].tlf21 = g_tlff_1[m_cnt].ccc23 * g_tlff_1[m_cnt].tlf10 * g_tlf12
           END IF
        END IF
       #-----------------No:CHI-B50025 end
        ###### 採購入庫抓原單價
        IF g_tlf13 = 'apmt150' THEN
           SELECT apb081,apb101
             INTO g_tlff_1[m_cnt].ccc23,g_tlff_1[m_cnt].tlf21 
             FROM apb_file
            WHERE apb21 = g_tlf036 AND apb22 = g_tlf037
           IF SQLCA.sqlcode OR STATUS THEN
              LET g_tlff_1[m_cnt].ccc23 = ''
              LET g_tlff_1[m_cnt].tlf21 = ''
           END IF
           IF cl_null(g_tlff_1[m_cnt].ccc23) AND cl_null(g_tlff_1[m_cnt].tlf21) THEN
              SELECT rvv38/rvv35_fac,rvv39
                INTO g_tlff_1[m_cnt].ccc23,g_tlff_1[m_cnt].tlf21 
                FROM rvv_file
               WHERE rvv01 = g_tlf036 AND rvv02 = g_tlf037
              IF SQLCA.sqlcode OR STATUS THEN
                 LET g_tlff_1[m_cnt].ccc23 = ''
                 LET g_tlff_1[m_cnt].tlf21 = ''
              END IF
             #-------------No.MOD-780249 add
              SELECT pmm42 INTO l_pmm42
                FROM rvb_file,pmm_file,rva_file,rvv_file
               WHERE rvv01 = g_tlf036 AND rvv02 = g_tlf037
                 AND rvb01=rvv04 AND rvb02=rvv05
                 AND pmm01=rvb04 AND rva01 = rvb01
                 AND rvaconf <> 'X' AND pmm18 <> 'X'
              IF STATUS <> 0 THEN
                 LET l_pmm42= 1
              END IF
              IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
              LET g_tlff_1[m_cnt].ccc23=g_tlff_1[m_cnt].ccc23*l_pmm42
              LET g_tlff_1[m_cnt].tlf21=g_tlff_1[m_cnt].tlf21*l_pmm42
             #-------------No.MOD-780249 end
           END IF
        END IF
        ###### 雜項入庫抓原單價
        IF g_tlf13 = 'aimt302' THEN
          #SELECT inb13/inb08_fac,inb14    #FUN-AB0089
           SELECT COALESCE(inb13/inb08_fac,0)+COALESCE(inb132/inb08_fac,0)+COALESCE(inb133/inb08_fac,0)+
                  COALESCE(inb134/inb08_fac,0)+COALESCE(inb135/inb08_fac,0)+COALESCE(inb136/inb08_fac,0)+   #FUN-AB0089
                  COALESCE(inb137/inb08_fac,0)+COALESCE(inb138/inb08_fac,0),inb14                              #FUN-AB0089
             INTO g_tlff_1[m_cnt].ccc23,g_tlff_1[m_cnt].tlf21 
             FROM inb_file
            WHERE inb01 = g_tlf036 AND inb03 = g_tlf037
           IF SQLCA.sqlcode OR STATUS THEN
              LET g_tlff_1[m_cnt].ccc23 = ''
              LET g_tlff_1[m_cnt].tlf21 = ''
           END IF
        END IF
        ###### 借料入庫抓原單價
        IF g_tlf13 = 'aimt306' THEN
           SELECT imp09/imp14_fac,imp04*imp09/imp14_fac
             INTO g_tlff_1[m_cnt].ccc23,g_tlff_1[m_cnt].tlf21 
             FROM imp_file
            WHERE imp01 = g_tlf036 AND imp02 = g_tlf037
           IF SQLCA.sqlcode OR STATUS THEN
              LET g_tlff_1[m_cnt].ccc23 = ''
              LET g_tlff_1[m_cnt].tlf21 = ''
           END IF
        END IF
        ######
        IF g_tlf13 = 'aimp880' THEN
           SELECT pia30,pia50 INTO g_pia30,g_pia50 FROM pia_file
             WHERE pia02=g_img.img01 AND pia03=g_img.img02
               AND pia04=g_img.img03 AND pia05=g_img.img04
               AND (pia01=g_tlff_1[m_cnt].tlf026 OR pia01=g_tlf036)
           IF NOT cl_null(g_pia50) THEN LET g_pia30 = g_pia50 END IF
           IF g_tlf036 ='Physical'
              THEN LET g_tlf036=g_pia30
#             ELSE LET g_tlff_1[m_cnt].tlf026=g_pia30
           END IF
           IF g_tlff_1[m_cnt].tlf026='Physical' THEN
              LET g_tlff_1[m_cnt].tlf026=g_tlf036
           END IF
        END IF
        IF g_tlf031 = g_img.img02 AND g_tlf032 = g_img.img03 AND
           g_tlf033 = g_img.img04 AND g_tlf13 != 'apmt1071'
           THEN LET g_tlff_1[m_cnt].tlf024 = g_tlf034
           ELSE LET g_tlff_1[m_cnt].tlf10 = g_tlff_1[m_cnt].tlf10 * -1
                IF (g_tlf13='aimt324' OR g_tlf13='aimt720')
                    THEN LET g_tlf12=1
                END IF
        END IF
        IF g_tlff_1[m_cnt].tlf10 IS NULL THEN LET g_tlff_1[m_cnt].tlf10=0 END IF
        IF g_tlf12 IS NULL THEN LET g_tlf12=0 END IF
        LET g_imk09 = g_imk09 + g_tlff_1[m_cnt].tlf10 * g_tlf12
        LET g_tlff_1[m_cnt].tlf024 = g_imk09
#       CALL s_command (g_tlf13) RETURNING l_nouse,g_tlff_1[m_cnt].cond
        IF cl_null(g_tlff_1[m_cnt].cond)
           THEN LET g_tlff_1[m_cnt].cond=g_tlf13 END IF
        LET m_cnt = m_cnt + 1
#       IF m_cnt > g_tlff_arrno THEN
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
    LET g_rec_b = m_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q232_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tlff_1 TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480142
 
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
         CALL q232_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q232_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q232_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q232_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q232_fetch('L')
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
  #    LET l_ac = ARR_CURR()
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
 
