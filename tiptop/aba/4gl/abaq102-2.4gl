# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq102.4gl
# Descriptions...: 料件BIN卡查詢 (依單據日期)
# Date & Author..: 93/05/25 By Felicity  Tseng
# Modify.........: No.MOD-480045 04/08/11 By Nicola 單身不會即時更新
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: NO.MOD-480150 04/09/13 By Nicola 有傳參數但未直接進入 "查詢" 狀態
# Modify.........: No.FUN-4A0053 04/10/05 By Yuna 料件編號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-520048 05/02/14 By ching g_bdate改用MDY
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.MOD-530724 05/03/29 By kim 前期期末若抓不到時,應以 0 進行計算
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-540025 05/06/06 By Carrier 雙單位內容修改  
# Modify.........: No.FUN-570246 05/07/27 By Elva 起始日期調整成輸入年度期別查詢
# Modify.........: No.MOD-570234 05/07/19 By pengu 當庫存雜入9999999999(10個9)右邊BIN卡查詢看不到值
# Modify.........: No.MOD-590345 05/11/21 By pengu 在計算異動量時會照成小數誤差
# Modify.........: No.TQC-5C0080 05/12/21 By 取tlf_file時應是所有參考年度月份以後的資料，而不是只有該月的資料
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0162 07/01/08 By claire 轉excel時單身會多一筆空白
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7B0015 08/01/21 By lilingyu 加入ACTION"刻號庫存明細查詢" 
# Modify.........: No.FUN-7B0015 08/01/21 By lilingyu 單身最后加入"參考數量"欄位 
# Modify.........: No.FUN-830065 08/03/21 By lilingyu 畫面加相關文件ACTION
# Modify.........: No.FUN-890125 08/10/08 By Jerry 修正若程式寫法為SELECT .....,ROWID寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-8C0060 08/12/05 By claire 單身加入異動日排序
# Modify.........: No.MOD-910006 09/01/05 By chenyu 對算出來的"異動后庫存"要根據對應單位進行截位
# Modify.........: No.TQC-920092 09/01/05 By chenyu mark MOD-910006
# Modify.........: No.CHI-970039 09/07/21 By mike 取消ima02與ima021的CONSTRUCT
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0006 09/11/02 BY Carrier SQL STANDARDIZE
# Modify.........: No:MOD-A30160 10/07/16 By Pengu ICD產業查詢顆BIN號庫存時會異常
# Modify.........: No:TQC-A80095 10/08/15 By destiny foreach时缺少一个变量接收 
# Modify.........: No:CHI-A80048 10/09/20 By Summer 品名、規格、來源碼、庫存單位、目前庫存欄位在查詢時，可開放查詢
# Modify.........: No:FUN-B40039 11/04/26 By shiwuying 增加库存参数 
# Modify.........: No:TQC-BB0080 12/01/10 By destiny 查询退出时报错
# Modify.........: No:TQC-C10121 12/01/31 By destiny sql条件错误
# Modify.........: No:TQC-CC0058 12/12/11 By yuhuabao 料號開窗選擇資料過多會導致-201的錯誤
# Modify.........: No:TQC-CC0094 12/12/18 By qirl 增加欄位，欄位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm            RECORD
#                 wc     LIKE type_file.chr1000,		# Head Where condition  #No.FUN-690026 VARCHAR(500) #TQC-CC0058 mark
#                 wc2    LIKE type_file.chr1000		# Body Where condition  #No.FUN-690026 VARCHAR(500)         #TQC-CC0058 mark
                  wc     STRING,                        #TQC-CC0058 add
                  wc2    STRING                         #TQC-CC0058 add
                  END RECORD,
    g_tc_ibb_m         RECORD
                  tc_ibb03	 LIKE tc_ibb_file.tc_ibb03,# 料件編號
                  tc_ibb04	 LIKE tc_ibb_file.tc_ibb04 # 倉庫編號
                  END RECORD,
    g_bdate       LIKE type_file.dat,     # 期初庫存  #No.FUN-690026 DATE
    #FUN-570246  --begin
    g_yy          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_mm          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_edate       LIKE type_file.dat,     #No.FUN-690026 DATE
    #FUN-570246  --end
    g_imk09       LIKE imk_file.imk09,    # 期初庫存
    g_ima02       LIKE ima_file.ima02,    # 品名    
    g_ima021      LIKE ima_file.ima021,    # 品名    
    g_ima08       LIKE ima_file.ima08,    # 來源碼  
    g_pia30       LIKE pia_file.pia30,    # 初盤量  
    g_pia50       LIKE pia_file.pia50,    # 複盤量  
    g_year        LIKE imk_file.imk05,    # 年度    
    g_month       LIKE imk_file.imk06,    # 期別    
    g_tc_ibb_d      DYNAMIC ARRAY OF RECORD
                  tc_ibb06   LIKE tc_ibb_file.tc_ibb06,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               ima25      LIKE ima_file.ima25,
               tc_ibb21   LIKE tc_ibb_file.tc_ibb21,
               tc_ibb05   LIKE tc_ibb_file.tc_ibb05,
               tc_ibb07   LIKE tc_ibb_file.tc_ibb07,
               tc_ibb17   LIKE tc_ibb_file.tc_ibb17,
               tc_ibb01   LIKE tc_ibb_file.tc_ibb01               
                  END RECORD,
    g_cmd         LIKE type_file.chr1000,#No.FUN-540025  #No.FUN-690026 VARCHAR(200)
    g_tlf13       LIKE tlf_file.tlf13,   # 異動命令 
    g_tlf08       LIKE tlf_file.tlf08,   # TIME
    g_tlf12       LIKE tlf_file.tlf12,   #MOD-530179
    g_tlf03       LIKE tlf_file.tlf03,   #
    g_tlf031      LIKE tlf_file.tlf031,  #
    g_tlf032      LIKE tlf_file.tlf032,  #
    g_tlf033      LIKE tlf_file.tlf033,  #
    g_tlf034      LIKE tlf_file.tlf034,  # TO 異動後數量
    g_tlf035      LIKE tlf_file.tlf035,  # TO 單位
    g_tlf02       LIKE tlf_file.tlf02,   #No.TQC-A80095
    g_query_flag  LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql         string,                #No.FUN-580092 HCN
    g_argv1       LIKE img_file.img01,   #NO.MOD-490217
    g_argv2       LIKE img_file.img02,   #FUN-B40039
    l_ac          LIKE type_file.num5,   #No:MOD-A30160 add
    i,m_cnt       LIKE type_file.num10,  #No.FUN-690026 INTEGER
    g_rec_b       LIKE type_file.num5    #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8    #No.FUN-6A0074
   DEFINE      l_sl   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
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
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)   #FUN-B40039
 
   #LET g_msg=g_today USING 'yy/mm/dd'
   #LET g_msg[7,8]='01'
 
     #MOD-520048
    LET g_msg=MDY(g_today USING 'mm',
                  1,
                  g_today USING 'yy')
    #--
 
 #  LET g_bdate=DATE(g_msg)  #FUN-570246
   # CALL s_yp(g_today) RETURNING g_yy,g_mm  #FUN-570246
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q102_w AT p_row,p_col
         WITH FORM "aba/42f/abaq102" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) THEN    #No.MOD-480150
       CALL q102_q()
    END IF
 
    CALL q102_menu()
    CLOSE WINDOW q102_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q102_curs()
   DEFINE   l_cnt   LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE   l_azm02 LIKE azm_file.azm02
 
   CLEAR FORM 
   CALL g_tc_ibb_d.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   #FUN-570246  --begin
#  DISPLAY g_bdate TO bdate
   #DISPLAY g_yy TO FORMONLY.yy
   #DISPLAY g_mm TO FORMONLY.mm
   #FUN-570246  --end
    IF NOT cl_null(g_argv1) OR g_argv1<>' ' THEN      # No.MOD-570234
       DISPLAY g_argv1 TO img01
       LET tm.wc=" tc_ibb03='",g_argv1,"'"
      #FUN-B40039 Begin---
       IF NOT cl_null(g_argv2) THEN
          LET tm.wc=tm.wc," AND tc_ibb04='",g_argv2,"'"
       END IF
      #FUN-B40039 End-----
    ELSE
      INITIALIZE g_tc_ibb_m.* TO NULL   #FUN-640213 add		
     #CONSTRUCT BY NAME tm.wc ON img01, img02, img03, img04 #CHI-970039 delete ima02,ima021 #CHI-A80048 mark
      CONSTRUCT BY NAME tm.wc ON tc_ibb03, tc_ibb04   #CHI-A80048
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         #--No.FUN-4A0053--------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(tc_ibb03) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_rva06"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO tc_ibb03
         	  NEXT FIELD tc_ibb03
##---TQC-CC0094--add---star----
#             WHEN INFIELD(img02)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_img021"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO img02
#                  NEXT FIELD img02
#             WHEN INFIELD(img03)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_img03"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO img03
#                  NEXT FIELD img03
#             WHEN INFIELD(ima08)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_ima7"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ima08
#                  NEXT FIELD ima08
##---TQC-CC0094--add---end--
            OTHERWISE EXIT CASE
            END CASE
         #--END---------------
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN 
         #LET INT_FLAG = 0 #TQC-BB0080
         RETURN 
      END IF
   END IF
   #FUN-570246  --begin
 # INPUT g_bdate WITHOUT DEFAULTS FROM bdate
  # INPUT g_yy,g_mm WITHOUT DEFAULTS FROM yy,mm
  #   AFTER FIELD bdate
  #     IF cl_null(g_bdate) THEN
  #        CALL cl_err('','aim-372',0)
  #        NEXT FIELD bdate
  #     END IF
  #     IF DAY(g_bdate)!=1 THEN
  #        CALL cl_err('','aim-394',0)
  #        NEXT FIELD bdate
  #     END IF
 #--No.MOD-570234 add
  #    BEFORE FIELD yy
   #     IF NOT cl_null(g_argv1) OR g_argv1 <> ' ' THEN
    #       EXIT INPUT
     #   END IF
#--end
 
#      AFTER FIELD yy
 #        IF g_yy IS NULL OR g_yy < 999 OR g_yy>2100
  #          THEN NEXT FIELD yy
   #      END IF
     
    #  AFTER FIELD mm
#No.TQC-720032 -- begin --
     #    IF NOT cl_null(g_mm) THEN
      #      SELECT azm02 INTO g_azm.azm02 FROM azm_file
       #       WHERE azm01 = g_yy
        #    IF g_azm.azm02 = 1 THEN
         #      IF g_mm > 12 OR g_mm < 1 THEN
          #        CALL cl_err('','agl-020',0)
           #       NEXT FIELD mm
            #   END IF
           # ELSE
            #   IF g_mm > 13 OR g_mm < 1 THEN
             #     CALL cl_err('','agl-020',0)
              #    NEXT FIELD mm
               #END IF
            #END IF
         #END IF
#         IF g_mm IS NULL OR g_mm <1 OR g_mm>13  
#            THEN NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
 
     # AFTER INPUT
        #IF INT_FLAG THEN
          # LET INT_FLAG = 0
         #  RETURN       
        #END IF
       # IF cl_null(g_yy) THEN
      #     CALL cl_err('','aim-372',0)
     #      NEXT FIELD yy   
    #    END IF
   #     IF cl_null(g_mm) THEN
  #         CALL cl_err('','aim-372',0)
 #          NEXT FIELD mm   
#        END IF
   #FUN-570246  --end
      # ON IDLE g_idle_seconds
       #   CALL cl_on_idle()
        #  CONTINUE INPUT
 
      #ON ACTION about         #MOD-4C0121
       #  CALL cl_about()      #MOD-4C0121
 
 #     ON ACTION help          #MOD-4C0121
  #       CALL cl_show_help()  #MOD-4C0121
 
   #   ON ACTION controlg      #MOD-4C0121
    #     CALL cl_cmdask()     #MOD-4C0121
 
    
    #END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #FUN-570246  --begin
 #  CALL s_yp(g_bdate) RETURNING g_year, g_month
   # CALL s_lsperiod(g_yy,g_mm) RETURNING g_year,g_month
   # CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate
    #LET tm.wc2 = " tlf06 >= '",g_bdate,"'"           #No.TQC-5C0080 delete mark
 #  LET tm.wc2 = " tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'"   #No.TQC-5C0080 mark
   #FUN-570246  --end
 
	MESSAGE ' WAIT ' 
 
  #  LET g_sql= " SELECT img01,ima02,ima021,ima08,img10,imk09 ",
     #No.TQC-9B0006  --Begin
#     LET g_sql= " SELECT img01,img02,img03,img04,ima02,ima021,ima08,img10,imk09 ",#FUN-890125          
#              #CHI-A80048 mod --start--
#              # " FROM img_file, OUTER ima_file, OUTER imk_file ",
#              # " WHERE ima_file.ima01 = img_file.img01 ",
#              # " AND   imk_file.imk01 = img_file.img01 ",
#              # " AND   imk_file.imk02 = img_file.img02 ",
#              # " AND   imk_file.imk03 = img_file.img03 ",
#              # " AND   imk_file.imk04 = img_file.img04 ",
#              # " AND   imk_file.imk05 =",g_year,
#              # " AND   imk_file.imk06 =",g_month,
#              # " AND ",tm.wc CLIPPED,
#               "   FROM ima_file,img_file ",
#               "        LEFT OUTER JOIN imk_file ON ",
#               "        imk01 = img01 ",
#               "    AND imk02 = img02 ",
#               "    AND imk03 = img03 ",
#               "    AND imk04 = img04 ",
#               "    AND imk05 ='",g_year,"'",   
#               "    AND imk06 ='",g_month,"'",  
#               "  WHERE ",tm.wc CLIPPED,
#               "    AND ima01=img01 ",           #TQC-C10121
#               #"    AND ima01 = img01 ",         #TQC-C10121
#              #CHI-A80048 mod --end--
#               " ORDER BY img01"
     #No.TQC-9B0006  --End  
     LET g_sql=" select tc_ibb03,tc_ibb04 from tc_ibb_file where ",tm.wc CLIPPED,
               " order by tc_ibb03"
    PREPARE q102_prepare FROM g_sql
    DECLARE q102_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q102_prepare
 
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    #TQC-C10121--begin
#    LET g_sql=" SELECT COUNT(*) FROM img_file,ima_file ", #CHI-A80048 add ima_file
#               " WHERE ",tm.wc CLIPPED,                   #CHI-A80048 add ,
#              "   AND ima01=img01 "                      #CHI-A80048 add
    DROP TABLE x
     LET g_sql=" select tc_ibb03,tc_ibb04 from tc_ibb_file where ",tm.wc CLIPPED,
               " INTO temp x"
               
#    LET g_sql= " SELECT img01,img02,img03,img04,ima02,ima021,ima08,img10,imk09 ",
#               "   FROM ima_file,img_file LEFT OUTER JOIN imk_file ON ",
#               "        imk01 = img01 AND imk02 = img02 ",
#               "    AND imk03 = img03 AND imk04 = img04 ",
#               "    AND imk05 ='",g_year,"' AND imk06 ='",g_month,"'",
#               "  WHERE ",tm.wc CLIPPED,"    AND ima01=img01 ",
#               " INTO temp x "
    PREPARE q102_sel FROM g_sql
    EXECUTE q102_sel

    LET g_sql=" SELECT COUNT(*) FROM x "
    #TQC-C10121--end
    PREPARE q102_pp  FROM g_sql
    DECLARE q102_count   CURSOR FOR q102_pp
END FUNCTION
 
FUNCTION q102_b_askkey()
   CONSTRUCT tm.wc2 ON tc_ibb06,ima02,ima21,ima25,tc_ibb21,tc_ibb05,tc_ibb07,tc_ibb17,tc_ibb01                        #DEV-D30055 add
              FROM s_tc_ibb[1].tc_ibb06,s_ima[1].ima02,s_ima[1].ima21,s_ima[1].ima25,
                   s_tc_ibb[1].tc_ibb21,s_tc_ibb[1].tc_ibb05,s_tc_ibb[1].tc_ibb07,s_tc_ibb[1].tc_ibb17,
                   s_tc_ibb[1].tc_ibb01    #DEV-D30055 add
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
         CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
               CALL q102_q()
            END IF
            
         #NO.FUN-7B0015 --START--
        WHEN "ic_detail"
#           IF g_img.img02 IS NOT NULL AND g_img.img04 IS NOT NULL THEN     #No:MOD-A30160 modify
#            LET g_cmd="aicq027 '",g_img.img01,"' '",g_img.img02,"' '",
#                       g_img.img03,"' '",g_img.img04,"' '",
#                       g_tlff_1[l_ac].tlf06,"' '",g_tlff_1[l_ac].tlf036,"' '",   #No:MOD-A30160 modify
#                       g_yy,"' '",g_mm,"' "
            CALL cl_cmdrun(g_cmd CLIPPED)
#           END IF 
#         #NO.FUN-7B0015 --END----
#           
#          #NO.FUN-830065 --Begin
#           WHEN "related_document"
#              LET g_action_choice="related_document"
#              IF cl_chk_act_auth() THEN
#                 IF g_img.img01 IS NOT NULL THEN
#                    LET g_doc.column1="img01"
#                    LET g_doc.value1=g_img.img01
#                    CALL cl_doc()
#                 END IF 
#              END IF   
          #NO.FUN-830065 --End
          
 
         #No.FUN-540025  --begin
         WHEN "du_bin_detail" 
	    LET g_cmd = "abaq102 '",g_tc_ibb_m.tc_ibb03,"' '",g_tc_ibb_m.tc_ibb04
	    CALL cl_cmdrun(g_cmd CLIPPED)
         #No.FUN-540025  --end   
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ibb_d),'','')   #TQC-6B0162 modify 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q102_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q102_count
       FETCH q102_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q102_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04                                         
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04                                       
        WHEN 'F' FETCH FIRST    q102_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04                                         
        WHEN 'L' FETCH LAST     q102_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04                                           
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
            FETCH ABSOLUTE g_jump q102_cs INTO g_tc_ibb_m.tc_ibb03,g_tc_ibb_m.tc_ibb04                                      
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ibb_m.tc_ibb03,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ibb_m.*  TO NULL  #TQC-6B0105
        #INITIALIZE g_ima02  TO NULL  #TQC-6B0105
        #INITIALIZE g_ima021 TO NULL  #TQC-6B0105
        #INITIALIZE g_ima08  TO NULL  #TQC-6B0105
       # INITIALIZE g_imk09  TO NULL  #TQC-6B0105
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
 
	SELECT tc_ibb03,tc_ibb04    #TQC-CC0094--add-''''
	  INTO g_tc_ibb_m.* 
	  FROM tc_ibb_file
      WHERE tc_ibb03 = g_tc_ibb_m.tc_ibb03 
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tc_ibb_m.tc_ibb03,SQLCA.sqlcode,0)
            RETURN
        END IF
 
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
   DISPLAY BY NAME g_tc_ibb_m.*   # 顯示單頭值
   #IF g_imk09 IS NULL THEN 
    #  LET g_imk09=0 
   #END IF
  #--TQC-CC0094--add--star---
  #SELECT imd02 INTO g_img.imd02 FROM imd_file WHERE imd01 = g_img.img02
  #SELECT ime03 INTO g_img.ime03 FROM ime_file WHERE ime02 = g_img.img03
  # DISPLAY g_img.imd02 TO imd02
   #DISPLAY g_img.ime03 TO ime03
  #--TQC-CC0094--add--end---
  # DISPLAY g_imk09 TO imk09
   CALL q102_b_fill() #單身
   #DISPLAY g_ima02, g_ima021,g_ima08, g_yy,g_mm   #FUN-570246
    #       TO ima02, ima021, ima08, yy,mm              #FUN-570246
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   DEFINE l_tlf10   like tlf_file.tlf10     #No.MOD-590345 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03     #No.MOD-910006 add
 
   LET l_sql =
       g_sql ="SELECT tc_ibb06,ima02,ima021,ima25,tc_ibb21,tc_ibb05,tc_ibb07,tc_ibb17,tc_ibb01 ",
                  "  FROM tc_ibb_file ",
                  "  left join ima_file on ima01=tc_ibb06",
                  " WHERE tc_ibb01<>' ' AND tc_ibb03=",g_tc_ibb_m.tc_ibb003,"AND tc_ibb_04=",g_tc_ibb_m.tc_ibb004,"",
                  "  ORDER BY tc_ibb01 " 
       
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs                       #BODY CURSOR
        CURSOR FOR q102_pb
 
    CALL g_tc_ibb_d.clear()
 #  FOR g_cnt = 1 TO g_tlff.getLength()           #單身 ARRAY 乾洗
 #     INITIALIZE g_tlff_1[g_cnt].* TO NULL
 #  END FOR
    LET g_rec_b=0
    LET m_cnt = 1
    FOREACH q102_bcs INTO g_tc_ibb_d[m_cnt].*
  
      #NO.FUN-7B0015  --Begin--
#      IF s_industry("icd") THEN
#         SELECT SUM(idd18) INTO g_tlff_1[m_cnt].idd18 FROM idd_file                                                              
#           WHERE idd01=g_img.img01
#             AND idd02=g_img.img02                                                                         
#             AND idd03=g_img.img03
#             AND idd04=g_img.img04                                                                         
#             AND idd10=g_tlff_1[m_cnt].tlf036                                                                                    
#             AND idd08=g_tlff_1[m_cnt].tlf06       
#      END IF
#      #NO.FUN-7B0015  --End--
       
      IF m_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
#        IF g_tlf13 = 'aimp880' THEN
#           SELECT pia30,pia50 INTO g_pia30,g_pia50 FROM pia_file
#             WHERE pia02=g_img.img01 AND pia03=g_img.img02
#               AND pia04=g_img.img03 AND pia05=g_img.img04
#               AND (pia01=g_tlff_1[m_cnt].tlf026 OR pia01=g_tlff_1[m_cnt].tlf036)
#           IF NOT cl_null(g_pia50) THEN LET g_pia30 = g_pia50 END IF
#           IF g_tlff_1[m_cnt].tlf036 ='Physical'
#              THEN LET g_tlff_1[m_cnt].tlf036=g_pia30
#              ELSE LET g_tlff_1[m_cnt].tlf026=g_pia30
#           END IF
#        END IF
#        IF g_tlf031 = g_img.img02 AND g_tlf032 = g_img.img03 AND
#           g_tlf033 = g_img.img04 AND g_tlf13 != 'apmt1071'
#           THEN LET g_tlff_1[m_cnt].tlf024 = g_tlf034
#           ELSE LET g_tlff_1[m_cnt].tlf10 = g_tlff_1[m_cnt].tlf10 * -1
#                IF (g_tlf13='aimt324' OR g_tlf13='aimt720')
#                    THEN LET g_tlf12=1
#                END IF
#        END IF
#        IF g_tlff_1[m_cnt].tlf10 IS NULL THEN LET g_tlff_1[m_cnt].tlf10=0 END IF
#        IF g_tlf12 IS NULL THEN LET g_tlf12=0 END IF
#         IF g_imk09 IS NULL THEN LET g_imk09=0 END IF  #MOD-530724
# 
#      #---No.MOD-590345
#        LET l_tlf10=g_tlff_1[m_cnt].tlf10 * g_tlf12
#        #TQC-920092-begin-mark 
#        ##No.MOD-910006 add --begin
#        #SELECT gfe03 INTO l_gfe03 FROM gfe_file
#        # WHERE gfe01 = g_img.img09 AND gfeacti = 'Y'
#        #IF NOT cl_null(l_gfe03) THEN
#        #   LET l_tlf10 = cl_digcut(l_tlf10,l_gfe03)
#        #END IF
#        ##No.MOD-910006 add --end
#        #TQC-920092-end-mark 
#      # LET g_imk09 = g_imk09 + g_tlff_1[m_cnt].tlf10 * g_tlf12
#        LET g_imk09 = g_imk09 + l_tlf10
#      #---No.MOD-590345 end
# 
#        LET g_tlff_1[m_cnt].tlf024 = g_imk09
#        CALL s_command (g_tlf13) RETURNING l_nouse,g_tlff_1[m_cnt].cond
#        IF cl_null(g_tlff_1[m_cnt].cond)
#           THEN LET g_tlff_1[m_cnt].cond=g_tlf13 END IF
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
    CALL g_tc_ibb_d.deleteElement(m_cnt)    #TQC-6B0162 add
    LET g_rec_b = m_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tc_ibb_d TO s_tc_ibb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480045
 
     #No.FUN-540025  --begin
     BEFORE DISPLAY
        # IF g_sma.sma115 = 'N' THEN
         #   CALL cl_set_act_visible("du_bin_detail",FALSE)
         #ELSE
          #  CALL cl_set_act_visible("du_bin_detail",TRUE)
         #END IF
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     #No.FUN-540025  --end   
      
         #NO.FUN-7B0015 --START--
      #   IF NOT s_industry("icd") THEN
       #     CALL cl_set_act_visible("ic_detail",FALSE)
          #  CALL cl_set_comp_visible("idd18",FALSE)
        # END IF 
         #NO.FUN-7B0015 --END--        
 
      BEFORE ROW
         CALL cl_show_fld_cont()                        #No.FUN-560228
         LET l_ac = ARR_CURR()                          #No:MOD-A30160 add
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
   
      #NO.FUN-7B0015 --START---
      ON ACTION ic_detail
         LET g_action_choice="ic_detail"
         EXIT DISPLAY 
      #NO.FUN-7B0015 ---END----      
 
       #NO.FUN-830065 --Begin--
       ON ACTION related_document 
          LET g_action_choice="related_document"
          EXIT DISPLAY  
       #NO.FUN-830065 --END--
    
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION du_bin_detail     #No.FUN-540025
         LET g_action_choice = 'du_bin_detail'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end          
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
