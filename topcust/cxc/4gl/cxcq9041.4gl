# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq904.4gl
# Descriptions...: 料件BIN卡查詢 (依單據日期)
# Date & Author..: 93/05/25 By Felicity  Tseng
#No:181230         2018/12/30 By pulf 单身添加合计

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
    g_detail    DYNAMIC ARRAY OF     RECORD
                   ta_ccq01  LIKE ima_file.ima01,
                   ima02     LIKE ima_file.ima02,    
                   ima021    LIKE ima_file.ima021,   
                   ima39     LIKE ima_file.ima39,  
                   ta_ccq02  LIKE ccc_file.ccc02, 
                   ta_ccq03  LIKE ccc_file.ccc03, 
                   ta_ccq04  DECIMAL(20,8), 
                   ta_ccq05  LIKE ima_file.ima01, 
                   ima02_1   LIKE ima_file.ima02, 
                   ima021_1  LIKE ima_file.ima021,
                   ima39_1   LIKE ima_file.ima39,
                   ta_ccq11  DECIMAL(20,8), 
                   ta_ccq18  DECIMAL(20,8), 
                   sjhyje    DECIMAL(20,8),   
                   ta_ccq12a DECIMAL(20,8), 
                   ta_ccq12b DECIMAL(20,8), 
                   ta_ccq12c DECIMAL(20,8), 
                   ta_ccq12d DECIMAL(20,8), 
                   txje      DECIMAL(20,8),    
                   ta_ccq22a DECIMAL(20,8), 
                   ta_ccq22b DECIMAL(20,8), 
                   ta_ccq22c DECIMAL(20,8), 
                   ta_ccq22d DECIMAL(20,8), 
                   ta_ccq20  DECIMAL(20,8), 
                   ta_ccq21  DECIMAL(20,8), 
                   ta_ccq21a DECIMAL(20,8), 
                   ta_ccq21b DECIMAL(20,8), 
                   ta_ccq21c DECIMAL(20,8), 
                   ta_ccq21d DECIMAL(20,8)
                  END RECORD,
    g_detail_sum   RECORD
                   ta_ccq01  LIKE ima_file.ima01,
                   ima02     LIKE ima_file.ima02,    
                   ima021    LIKE ima_file.ima021,   
                   ima39     LIKE ima_file.ima39,  
                   ta_ccq02  LIKE ccc_file.ccc02, 
                   ta_ccq03  LIKE ccc_file.ccc03, 
                   ta_ccq04  DECIMAL(20,8), 
                   ta_ccq05  LIKE ima_file.ima01, 
                   ima02_1   LIKE ima_file.ima02, 
                   ima021_1  LIKE ima_file.ima021,
                   ima39_1   LIKE ima_file.ima39,
                   ta_ccq11  DECIMAL(20,8), 
                   ta_ccq18  DECIMAL(20,8), 
                   sjhyje    DECIMAL(20,8),   
                   ta_ccq12a DECIMAL(20,8), 
                   ta_ccq12b DECIMAL(20,8), 
                   ta_ccq12c DECIMAL(20,8), 
                   ta_ccq12d DECIMAL(20,8), 
                   txje      DECIMAL(20,8),    
                   ta_ccq22a DECIMAL(20,8), 
                   ta_ccq22b DECIMAL(20,8), 
                   ta_ccq22c DECIMAL(20,8), 
                   ta_ccq22d DECIMAL(20,8), 
                   ta_ccq20  DECIMAL(20,8), 
                   ta_ccq21  DECIMAL(20,8), 
                   ta_ccq21a DECIMAL(20,8), 
                   ta_ccq21b DECIMAL(20,8), 
                   ta_ccq21c DECIMAL(20,8), 
                   ta_ccq21d DECIMAL(20,8)
                  END RECORD,
    g_bdate       LIKE type_file.dat,     # 期初庫存  #No.FUN-690026 DATE
    #FUN-570246  --begin
    g_yy          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_mm          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_edate       LIKE type_file.dat,     #No.FUN-690026 DATE
    #FUN-570246  --end
    g_imk09       LIKE imk_file.imk09,    # 期初庫存
    g_ima02       LIKE ima_file.ima02,    # 品名    
    g_ima021      LIKE ima_file.ima02,    # 品名    
    g_ima08       LIKE ima_file.ima08,    # 來源碼  
    g_pia30       LIKE pia_file.pia30,    # 初盤量  
    g_pia50       LIKE pia_file.pia50,    # 複盤量  
    g_year        LIKE imk_file.imk05,    # 年度    
    g_month       LIKE imk_file.imk06,    # 期別    
    g_tlff_1      DYNAMIC ARRAY OF RECORD
                  tlf06   LIKE tlf_file.tlf06,  #產生日期             
                  cond    LIKE type_file.chr20, #異動狀況 #No.FUN-690026 VARCHAR(14)
                  tlf026  LIKE tlf_file.tlf026, #來源單號
                  tlf036  LIKE tlf_file.tlf036, #目的單號
                  tlf10   LIKE tlf_file.tlf10,  #異動數量
                  tlf11   LIKE tlf_file.tlf11,  #FROM單位
                  tlf024  LIKE tlf_file.tlf024, #FROM異動後數量
                  idd18 LIKE idd_file.idd18  #參考數量          #NO.FUN-7B0015
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
  
   IF (NOT cl_setup("AIM")) THEN
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
    #CALL s_yp(g_today) RETURNING g_yy,g_mm  #FUN-570246
    SELECT ccz01 ,ccz02 INTO g_yy,g_mm FROM ccz_file
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q904_w AT p_row,p_col
         WITH FORM "cxc/42f/cxcq904" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) THEN    #No.MOD-480150
       CALL q904_q()
    END IF
 
    CALL q904_menu()
    CLOSE WINDOW q904_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q904_curs()
   DEFINE   l_cnt   LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE   l_azm02 LIKE azm_file.azm02
 
   CLEAR FORM 
   CALL g_tlff_1.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   #FUN-570246  --begin
#  DISPLAY g_bdate TO bdate
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
   #FUN-570246  --end
    IF NOT cl_null(g_argv1) OR g_argv1<>' ' THEN      # No.MOD-570234
       DISPLAY g_argv1 TO img01
       LET tm.wc=" img01='",g_argv1,"'"
      #FUN-B40039 Begin---
       IF NOT cl_null(g_argv2) THEN
          LET tm.wc=tm.wc," AND img02='",g_argv2,"'"
       END IF
      #FUN-B40039 End-----
    ELSE

      INPUT g_yy,g_mm WITHOUT DEFAULTS FROM yy,mm
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
      BEFORE FIELD yy
        IF NOT cl_null(g_argv1) OR g_argv1 <> ' ' THEN
           EXIT INPUT
        END IF
#--end
 
      AFTER FIELD yy
         IF g_yy IS NULL OR g_yy < 999 OR g_yy>2100
            THEN NEXT FIELD yy
         END IF
     
      AFTER FIELD mm
#No.TQC-720032 -- begin --
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
#         IF g_mm IS NULL OR g_mm <1 OR g_mm>13  
#            THEN NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN       
        END IF
        IF cl_null(g_yy) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD yy   
        END IF
        IF cl_null(g_mm) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD mm   
        END IF
   #FUN-570246  --end
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


      #INITIALIZE g_detail.* TO NULL   #FUN-640213 add		
     #CONSTRUCT BY NAME tm.wc ON img01, img02, img03, img04 #CHI-970039 delete ima02,ima021 #CHI-A80048 mark
      CONSTRUCT BY NAME tm.wc ON ta_ccq01,ima02,ima021,ima39
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         #--No.FUN-4A0053--------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(ta_ccq01) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO img01
         	  NEXT FIELD img01             
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

    #CALL s_lsperiod(g_yy,g_mm) RETURNING g_year,g_month
    #CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate
    #LET tm.wc2 = " tlf06 >= '",g_bdate,"'"           #No.TQC-5C0080 delete mark
 
	MESSAGE ' WAIT ' 
 
  #  LET g_sql= " SELECT img01,ima02,ima021,ima08,img10,imk09 ",
     #No.TQC-9B0006  --Begin
   LET g_sql = "
     SELECT ta_ccq01 ,
       a.ima02 ima02,
       a.ima021 ima021,
       a.ima39 ima39,
       TA_CCQ02 ,
       TA_CCQ03 ,
       TA_CCQ04 ,
       TA_CCQ05 ,
       b.ima02 ima02_1,
       b.ima021 ima021_1,
       b.ima39 ima39_1,
       TA_CCQ11 ,
       TA_CCQ18 ,
       TA_CCQ12a + TA_CCQ12b + TA_CCQ12c + TA_CCQ12d sjhyje,
       TA_CCQ12a ,
       TA_CCQ12b ,
       TA_CCQ12c ,
       TA_CCQ12d ,
       TA_CCQ22a + TA_CCQ22b + TA_CCQ22c + TA_CCQ22d txje,
       TA_CCQ22A ,
       TA_CCQ22B ,
       TA_CCQ22C ,
       TA_CCQ22D ,
       ta_ccq20 ,
       ta_ccq21 ,
       ta_ccq21a ,
       ta_ccq21b ,
       ta_ccq21c ,
       ta_ccq21d
  FROM ta_ccq_file, ima_file a, ima_file b, gfe_file, ta_ccp_file
 WHERE ta_ccq01 = a.ima01
   AND ta_ccq05 = b.ima01
   AND ta_ccq01 = ta_ccc01
   AND ta_ccq02 = ta_ccc02
   AND ta_ccq03 = ta_ccc03
   AND INSTR(TA_CCQ05, '.') = 0
   AND b.ima25 = gfe01
     ",tm.wc
    PREPARE q904_prepare FROM g_sql
    DECLARE q904_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q904_prepare
 
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    #TQC-C10121--begin
#    LET g_sql=" SELECT COUNT(*) FROM img_file,ima_file ", #CHI-A80048 add ima_file
#               " WHERE ",tm.wc CLIPPED,                   #CHI-A80048 add ,
#              "   AND ima01=img01 "                      #CHI-A80048 add
    #DROP TABLE x
    #LET g_sql= " SELECT img01,img02,img03,img04,ima02,ima021,ima08,img10,imk09 ",
    #           "   FROM ima_file,img_file LEFT OUTER JOIN imk_file ON ",
    #           "        imk01 = img01 AND imk02 = img02 ",
    #           "    AND imk03 = img03 AND imk04 = img04 ",
    #           "    AND imk05 ='",g_year,"' AND imk06 ='",g_month,"'",
    #           "  WHERE ",tm.wc CLIPPED,"    AND ima01=img01 ",
    #           " INTO temp x "
    #PREPARE q904_sel FROM g_sql
    #EXECUTE q904_sel
#
    #LET g_sql=" SELECT COUNT(*) FROM x "
    ##TQC-C10121--end
    #PREPARE q904_pp  FROM g_sql
    #DECLARE q904_count   CURSOR FOR q904_pp
END FUNCTION
 
FUNCTION q904_b_askkey()
   CONSTRUCT tm.wc2 ON tlf06,tlf026,tlf036,tlf10,tlf11,tlf024 FROM
	   s_tlf[1].tlf06,s_tlf[1].tlf026,s_tlf[1].tlf036,
	   s_tlf[1].tlf10,s_tlf[1].tlf11,s_tlf[1].tlf024
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
 
 
FUNCTION q904_menu()
 
   WHILE TRUE
      CALL q904_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
         CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
               CALL q904_q()
            END IF
            
         #NO.FUN-7B0015 --START--
         #WHEN "ic_detail"
           #IF g_img.img02 IS NOT NULL AND g_img.img04 IS NOT NULL THEN     #No:MOD-A30160 modify
           # LET g_cmd="aicq027 '",g_img.img01,"' '",g_img.img02,"' '",
           #            g_img.img03,"' '",g_img.img04,"' '",
           #            g_tlff_1[l_ac].tlf06,"' '",g_tlff_1[l_ac].tlf036,"' '",   #No:MOD-A30160 modify
           #            g_yy,"' '",g_mm,"' "
           # CALL cl_cmdrun(g_cmd CLIPPED)
           #END IF 
         #NO.FUN-7B0015 --END----
           
          #NO.FUN-830065 --Begin
           #WHEN "related_document"
           #   LET g_action_choice="related_document"
           #   IF cl_chk_act_auth() THEN
           #      IF g_img.img01 IS NOT NULL THEN
           #         LET g_doc.column1="img01"
           #         LET g_doc.value1=g_img.img01
           #         CALL cl_doc()
           #      END IF 
           #   END IF   
          #NO.FUN-830065 --End
          
 
      #   #No.FUN-540025  --begin
      #   WHEN "du_bin_detail" 
	   # LET g_cmd = "aimq233 '",g_img.img01,"' '",g_img.img02,"' '",g_img.img03,"' '",g_img.img04,"' ",g_yy," ",g_mm 
	   # CALL cl_cmdrun(g_cmd CLIPPED)
         #No.FUN-540025  --end   
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_detail),'','')   #TQC-6B0162 modify 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q904_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q904_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
   # OPEN q904_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   # IF SQLCA.sqlcode THEN
   #    CALL cl_err('',SQLCA.sqlcode,0)
   # ELSE
       #OPEN q904_count
       #FETCH q904_count INTO g_row_count
       #DISPLAY g_row_count TO FORMONLY.cnt  
      # CALL q904_fetch('F')                 # 讀出TEMP第一筆並顯示
      #CALL q904_show()
      CALL q904_b_fill()
    
	MESSAGE ''
END FUNCTION
 
 
FUNCTION q904_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   DEFINE l_tlf10   like tlf_file.tlf10     #No.MOD-590345 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03     #No.MOD-910006 add
 
   LET l_sql ="select * from cxcq904_file  "
   LET l_sql = l_sql," WHERE ",tm.wc," AND ta_ccq02='",g_yy,"' AND ta_ccq03='",g_mm,"'"
    PREPARE q904_pb FROM l_sql
    DECLARE q904_bcs                       #BODY CURSOR
        CURSOR FOR q904_pb
 
    CALL g_detail.clear()
 
    LET g_rec_b=0
    LET m_cnt = 1
    LET g_cnt = 1
    LET g_detail_sum.ta_ccq02  = 0
    LET g_detail_sum.ta_ccq03  = 0
    LET g_detail_sum.ta_ccq04  = 0
    LET g_detail_sum.ta_ccq05  = 0
    LET g_detail_sum.ta_ccq11  = 0
    LET g_detail_sum.ta_ccq18  = 0
    LET g_detail_sum.sjhyje    = 0
    LET g_detail_sum.ta_ccq12a = 0
    LET g_detail_sum.ta_ccq12b = 0
    LET g_detail_sum.ta_ccq12c = 0
    LET g_detail_sum.ta_ccq12d = 0
    LET g_detail_sum.txje      = 0
    LET g_detail_sum.ta_ccq22a = 0
    LET g_detail_sum.ta_ccq22b = 0
    LET g_detail_sum.ta_ccq22c = 0
    LET g_detail_sum.ta_ccq22d = 0
    LET g_detail_sum.ta_ccq20  = 0
    LET g_detail_sum.ta_ccq21  = 0
    LET g_detail_sum.ta_ccq21a = 0
    LET g_detail_sum.ta_ccq21b = 0
    LET g_detail_sum.ta_ccq21c = 0
    LET g_detail_sum.ta_ccq21d = 0
    FOREACH q904_bcs INTO g_detail[g_cnt].* 
       
      IF m_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF 
      #No:181230 mark begin--------
#      LET g_detail_sum.ta_ccq04  = g_detail_sum.ta_ccq04  + g_detail[g_cnt].ta_ccq04 
#      LET g_detail_sum.ta_ccq05  = g_detail_sum.ta_ccq05  + g_detail[g_cnt].ta_ccq05  
#      LET g_detail_sum.ta_ccq11  = g_detail_sum.ta_ccq11  + g_detail[g_cnt].ta_ccq11 
#      LET g_detail_sum.ta_ccq18  = g_detail_sum.ta_ccq18  + g_detail[g_cnt].ta_ccq18 
#      LET g_detail_sum.sjhyje    = g_detail_sum.sjhyje    + g_detail[g_cnt].sjhyje   
#      LET g_detail_sum.ta_ccq12a = g_detail_sum.ta_ccq12a + g_detail[g_cnt].ta_ccq12a
#      LET g_detail_sum.ta_ccq12b = g_detail_sum.ta_ccq12b + g_detail[g_cnt].ta_ccq12b
#      LET g_detail_sum.ta_ccq12c = g_detail_sum.ta_ccq12c + g_detail[g_cnt].ta_ccq12c
#      LET g_detail_sum.ta_ccq12d = g_detail_sum.ta_ccq12d + g_detail[g_cnt].ta_ccq12d
#      LET g_detail_sum.txje      = g_detail_sum.txje      + g_detail[g_cnt].txje     
#      LET g_detail_sum.ta_ccq22a = g_detail_sum.ta_ccq22a + g_detail[g_cnt].ta_ccq22a
#      LET g_detail_sum.ta_ccq22b = g_detail_sum.ta_ccq22b + g_detail[g_cnt].ta_ccq22b
#      LET g_detail_sum.ta_ccq22c = g_detail_sum.ta_ccq22c + g_detail[g_cnt].ta_ccq22c
#      LET g_detail_sum.ta_ccq22d = g_detail_sum.ta_ccq22d + g_detail[g_cnt].ta_ccq22d
#      LET g_detail_sum.ta_ccq20  = g_detail_sum.ta_ccq20  + g_detail[g_cnt].ta_ccq20 
#      LET g_detail_sum.ta_ccq21  = g_detail_sum.ta_ccq21  + g_detail[g_cnt].ta_ccq21 
#      LET g_detail_sum.ta_ccq21a = g_detail_sum.ta_ccq21a + g_detail[g_cnt].ta_ccq21a
#      LET g_detail_sum.ta_ccq21b = g_detail_sum.ta_ccq21b + g_detail[g_cnt].ta_ccq21b
#      LET g_detail_sum.ta_ccq21c = g_detail_sum.ta_ccq21c + g_detail[g_cnt].ta_ccq21c
#      LET g_detail_sum.ta_ccq21d = g_detail_sum.ta_ccq21d + g_detail[g_cnt].ta_ccq21d
      LET g_cnt = g_cnt + 1
      #No:181230 mark end---------
      LET m_cnt = m_cnt + 1
 END FOREACH
     CALL g_detail.deleteElement(m_cnt)    #TQC-6B0162 add
     LET g_rec_b = m_cnt - 1
    #LET g_detail_sum.ta_ccq01 = '合计:'
    #LET g_detail[g_cnt].* = g_detail_sum.*
    DISPLAY g_rec_b TO FORMONLY.cn2
    #No:181230 add begin---
    LET l_sql = " SELECT SUM(sjhyje),SUM(ta_ccq12a),SUM(ta_ccq12b),SUM(ta_ccq12c),SUM(ta_ccq12d),SUM(txje) FROM cxcq904_file WHERE ",tm.wc,
                " AND ta_ccq02='",g_yy,"' AND ta_ccq03='",g_mm,"'"
    PREPARE q904_pb1 FROM l_sql
    EXECUTE q904_pb1 INTO g_detail_sum.sjhyje, g_detail_sum.ta_ccq12a,g_detail_sum.ta_ccq12b,g_detail_sum.ta_ccq12c,g_detail_sum.ta_ccq12d,
                          g_detail_sum.txje
    DISPLAY g_detail_sum.sjhyje TO FORMONLY.sjhyje_sum
    DISPLAY g_detail_sum.ta_ccq12a TO FORMONLY.ta_ccq12a_sum
    DISPLAY g_detail_sum.ta_ccq12b TO FORMONLY.ta_ccq12b_sum
    DISPLAY g_detail_sum.ta_ccq12c TO FORMONLY.ta_ccq12c_sum
    DISPLAY g_detail_sum.ta_ccq12d TO FORMONLY.ta_ccq12d_sum
    DISPLAY g_detail_sum.txje TO FORMONLY.txje_sum
    #No:181230 add end-----
END FUNCTION
 
FUNCTION q904_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY g_detail_sum.ta_ccq04,g_detail_sum.ta_ccq05,g_detail_sum.ta_ccq11,g_detail_sum.ta_ccq18,g_detail_sum.sjhyje,
            g_detail_sum.ta_ccq12a,g_detail_sum.ta_ccq12b,g_detail_sum.ta_ccq12c,g_detail_sum.ta_ccq12d,g_detail_sum.txje,
            g_detail_sum.ta_ccq22a,g_detail_sum.ta_ccq22b,g_detail_sum.ta_ccq22c,g_detail_sum.ta_ccq22d,g_detail_sum.ta_ccq20,
            g_detail_sum.ta_ccq21,g_detail_sum.ta_ccq21a,g_detail_sum.ta_ccq21b,g_detail_sum.ta_ccq21c,g_detail_sum.ta_ccq21d
         TO ta_ccq04_sum,ta_ccq05_sum,ta_ccq11_sum,ta_ccq18_sum,sjhyje_sum,
            ta_ccq12a_sum,ta_ccq12b_sum,ta_ccq12c_sum,ta_ccq12d_sum,txje_sum,
            ta_ccq22a_sum,ta_ccq22b_sum,ta_ccq22c_sum,ta_ccq22d_sum,ta_ccq20_sum,
            ta_ccq21_sum,ta_ccq21a_sum,ta_ccq21b_sum,ta_ccq21c_sum,ta_ccq21d_sum
            
    DISPLAY ARRAY g_detail TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480045
 
     #No.FUN-540025  --begin
     BEFORE DISPLAY 
          
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     #No.FUN-540025  --end    
 
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
      #ON ACTION ic_detail
      #   LET g_action_choice="ic_detail"
      #   EXIT   DISPLAY
      #NO.FUN-7B0015 ---END----      
 
       #NO.FUN-830065 --Begin--
       #ON ACTION related_document 
       #   LET g_action_choice="related_document"
       #   EXIT DISPLAY  
       ##NO.FUN-830065 --END--
    
 
      #ON ACTION first
      #   CALL q904_fetch('F')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF
      #     ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      #                        
 #
      #ON ACTION previous
      #   CALL q904_fetch('P')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION jump
      #   CALL q904_fetch('/')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505 
                              
 
      #ON ACTION next
      #   CALL q904_fetch('N')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION last
      #   CALL q904_fetch('L')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
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
 
     # ON ACTION du_bin_detail     #No.FUN-540025
     #   LET g_action_choice = 'du_bin_detail'
     #    EXIT DISPLAY
 
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
 
