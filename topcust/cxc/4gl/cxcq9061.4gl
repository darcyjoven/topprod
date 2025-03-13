# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq906.4gl
# Descriptions...: 料件BIN卡查詢 (依單據日期)
# Date & Author..: 93/05/25 By Felicity  Tseng
#No:181231         2018/12/31 By pulf 菜单栏添加合计

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
                  ta_ccc01     LIKE ima_file.ima01,
                  ta_ccc02     LIKE ccc_file.ccc02,
                  ta_ccc03     LIKE ccc_file.ccc03,
                  ima02        LIKE ima_file.ima02,
                  ima021       LIKE ima_file.ima021,
                  ima39        LIKE ima_file.ima39,
                  ima25        LIKE ima_file.ima25,
                  ta_ccc11     DECIMAL(20,8),
                  ta_ccc12     DECIMAL(20,8),
                  ta_ccc12a    DECIMAL(20,8),
                  ta_ccc12b    DECIMAL(20,8),
                  ta_ccc12c    DECIMAL(20,8),
                  ta_ccc12d    DECIMAL(20,8),
                  bqrsl        DECIMAL(20,8),
                  bqrje        DECIMAL(20,8),
                  bqrcl        DECIMAL(20,8),
                  bqrrg        DECIMAL(20,8),
                  bqrzf        DECIMAL(20,8),
                  bqrjg        DECIMAL(20,8),
                  scly         DECIMAL(20,8),
                  sclyh        DECIMAL(20,8),
                  sclyc        DECIMAL(20,8),
                  sclyr        DECIMAL(20,8),
                  sclyz        DECIMAL(20,8),
                  sclyj        DECIMAL(20,8),
                  jcsl         DECIMAL(20,8),
                  jcje         DECIMAL(20,8),
                  bqccl        DECIMAL(20,8),
                  bqcrg        DECIMAL(20,8),
                  bqczf        DECIMAL(20,8),
                  bqcjg        DECIMAL(20,8),
                  ta_ccc27     DECIMAL(20,8),
                  fgrje        DECIMAL(20,8),
                  fgrc         DECIMAL(20,8),
                  fgrr         DECIMAL(20,8),
                  fgrz         DECIMAL(20,8),
                  fgrj         DECIMAL(20,8),
                  ta_ccc25     DECIMAL(20,8),
                  fglje        DECIMAL(20,8),
                  fglc         DECIMAL(20,8),
                  fglr         DECIMAL(20,8),
                  fglz         DECIMAL(20,8),
                  fglj         DECIMAL(20,8),
                  ta_ccc214    DECIMAL(20,8),
                  zrje         DECIMAL(20,8),
                  zrc          DECIMAL(20,8),
                  zrr          DECIMAL(20,8),
                  zrz          DECIMAL(20,8),
                  zrj          DECIMAL(20,8),
                  ta_ccc41     DECIMAL(20,8),
                  zfje         DECIMAL(20,8),
                  zfc          DECIMAL(20,8),
                  zfr          DECIMAL(20,8),
                  zfz          DECIMAL(20,8),
                  zfj          DECIMAL(20,8),
                  ta_ccc61     DECIMAL(20,8),
                  xhje         DECIMAL(20,8),
                  xhc          DECIMAL(20,8),
                  xhr          DECIMAL(20,8),
                  xhz          DECIMAL(20,8),
                  xhj          DECIMAL(20,8),
                  sltz         DECIMAL(20,8),
                  cltz         DECIMAL(20,8),
                  rgtz         DECIMAL(20,8),
                  zftz         DECIMAL(20,8),
                  jgtz         DECIMAL(20,8),
                  tzhz         DECIMAL(20,8)
                  END RECORD,
     g_detail_sum  RECORD
                  ta_ccc01     LIKE ima_file.ima01,
                  ta_ccc02     LIKE ccc_file.ccc02,
                  ta_ccc03     LIKE ccc_file.ccc03,
                  ima02        LIKE ima_file.ima02,
                  ima021       LIKE ima_file.ima021,
                  ima39        LIKE ima_file.ima39,
                  ima25        LIKE ima_file.ima25,
                  ta_ccc11     DECIMAL(20,8),
                  ta_ccc12     DECIMAL(20,8),
                  ta_ccc12a    DECIMAL(20,8),
                  ta_ccc12b    DECIMAL(20,8),
                  ta_ccc12c    DECIMAL(20,8),
                  ta_ccc12d    DECIMAL(20,8),
                  bqrsl        DECIMAL(20,8),
                  bqrje        DECIMAL(20,8),
                  bqrcl        DECIMAL(20,8),
                  bqrrg        DECIMAL(20,8),
                  bqrzf        DECIMAL(20,8),
                  bqrjg        DECIMAL(20,8),
                  scly         DECIMAL(20,8),
                  sclyh        DECIMAL(20,8),
                  sclyc        DECIMAL(20,8),
                  sclyr        DECIMAL(20,8),
                  sclyz        DECIMAL(20,8),
                  sclyj        DECIMAL(20,8),
                  jcsl         DECIMAL(20,8),
                  jcje         DECIMAL(20,8),
                  bqccl        DECIMAL(20,8),
                  bqcrg        DECIMAL(20,8),
                  bqczf        DECIMAL(20,8),
                  bqcjg        DECIMAL(20,8),
                  ta_ccc27     DECIMAL(20,8),
                  fgrje        DECIMAL(20,8),
                  fgrc         DECIMAL(20,8),
                  fgrr         DECIMAL(20,8),
                  fgrz         DECIMAL(20,8),
                  fgrj         DECIMAL(20,8),
                  ta_ccc25     DECIMAL(20,8),
                  fglje        DECIMAL(20,8),
                  fglc         DECIMAL(20,8),
                  fglr         DECIMAL(20,8),
                  fglz         DECIMAL(20,8),
                  fglj         DECIMAL(20,8),
                  ta_ccc214    DECIMAL(20,8),
                  zrje         DECIMAL(20,8),
                  zrc          DECIMAL(20,8),
                  zrr          DECIMAL(20,8),
                  zrz          DECIMAL(20,8),
                  zrj          DECIMAL(20,8),
                  ta_ccc41     DECIMAL(20,8),
                  zfje         DECIMAL(20,8),
                  zfc          DECIMAL(20,8),
                  zfr          DECIMAL(20,8),
                  zfz          DECIMAL(20,8),
                  zfj          DECIMAL(20,8),
                  ta_ccc61     DECIMAL(20,8),
                  xhje         DECIMAL(20,8),
                  xhc          DECIMAL(20,8),
                  xhr          DECIMAL(20,8),
                  xhz          DECIMAL(20,8),
                  xhj          DECIMAL(20,8),
                  sltz         DECIMAL(20,8),
                  cltz         DECIMAL(20,8),
                  rgtz         DECIMAL(20,8),
                  zftz         DECIMAL(20,8),
                  jgtz         DECIMAL(20,8),
                  tzhz         DECIMAL(20,8)
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
DEFINE  g_npp01       LIKE npp_file.npp01
DEFINE  g_npp       LIKE npp_file.npp01
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_nppglno1      LIKE npp_file.nppglno
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
  
   IF (NOT cl_setup("CXC")) THEN
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
     SELECT npp01 INTO g_npp01 
     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  AND npp01 LIKE '%A600%0906' 
     
    SELECT npp01 INTO g_npp 
     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  AND npp01 LIKE '%A601%9061' 
     
 #  LET g_bdate=DATE(g_msg)  #FUN-570246
    #CALL s_yp(g_today) RETURNING g_yy,g_mm  #FUN-570246
    SELECT ccz01 ,ccz02 INTO g_yy,g_mm FROM ccz_file
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q906_w AT p_row,p_col
         WITH FORM "cxc/42f/cxcq906" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) THEN    #No.MOD-480150
       CALL q906_q()
    END IF
 
    CALL q906_menu()
    CLOSE WINDOW q906_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q906_curs()
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
      CONSTRUCT BY NAME tm.wc ON ta_ccc01,ima02,ima021,ima39
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
   LET g_sql = "select * from cxcq907_file"
   LET g_sql = g_sql," where ta_cct02 =",g_yy," and tc_cct03 =",g_mm," and ",tm.wc
    PREPARE q906_prepare FROM g_sql
    DECLARE q906_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q906_prepare
 
 
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
    #PREPARE q906_sel FROM g_sql
    #EXECUTE q906_sel
#
    #LET g_sql=" SELECT COUNT(*) FROM x "
    ##TQC-C10121--end
    #PREPARE q906_pp  FROM g_sql
    #DECLARE q906_count   CURSOR FOR q906_pp
END FUNCTION
 
FUNCTION q906_b_askkey()
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
 
 
FUNCTION q906_menu()
 DEFINE l_ccz12  LIKE ccz_file.ccz12  
 DEFINE l_npptype  LIKE npp_file.npptype
 DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
 DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
 DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025 
 DEFINE l_aba19  LIKE aba_file.aba19
 DEFINE l_npp01   LIKE npp_file.npp01
 
   WHILE TRUE
      CALL q906_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
         CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
               CALL q906_q()
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
	    #CALL cl_cmdrun(g_cmd CLIPPED)
         #No.FUN-540025  --end 
         #C200522-11911#1 adds    
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
               CALL q906_v0()   #ADD-11911
            END IF
         #C200522-11911#1 adde
         #C200522-11911#1 adds    
         WHEN "gen_entry2"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
               CALL q9061_v0()   #ADD-11911
            END IF
         #C200522-11911#1 adde
         #C200522-11911#1 adds   
         WHEN "entry_sheet"                         
               LET l_npptype =0  
               IF cl_null(g_yy) OR cl_null(g_mm) THEN RETURN END IF 
               LET l_npp01= 'A','600','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','0906'
               SELECT npp01 INTO g_npp
                 FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0' 
                  AND npp01=l_npp01 
              IF cl_null(g_npp) THEN CONTINUE WHILE END IF                  
            CALL s_fsgl('CA',2,g_npp,0,g_plant,'1','N',l_npptype,g_npp)  
          #C200522-11911#1 adde  
          
         
          #C200522-11911#1 adds   
          WHEN "entry_sheet2"             
               LET l_npptype =0  
               IF cl_null(g_yy) OR cl_null(g_mm) THEN RETURN END IF 
               LET l_npp01= 'A','601','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','9061'
               SELECT npp01 INTO g_npp01
                 FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0' 
                  AND npp01=l_npp01 
              IF cl_null(g_npp01) THEN CONTINUE WHILE END IF            
           CALL s_fsgl('CA',2,g_npp01,0,g_plant,'1','N',l_npptype,g_npp01)  
          #C200522-11911#1 adde  
           
             #C200616-11911#1 add  
         WHEN "carry_voucher"
               IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
                LET l_npp01= 'A','600','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','0906'
               SELECT nppglno INTO g_nppglno
                 FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0' 
                  AND npp01=l_npp01 
                 #AND npp01 LIKE '%A800%0907'
               IF NOT cl_null(g_nppglno) THEN 
                 CALL cl_err('','axm-275',1)   #已抛转凭证,不可重复生成!
                 CONTINUE WHILE
               END IF       
               
              # LET g_msg ="cxcp301 ",l_npp01," '' '' '' ", #C20201110-12628 mark by litty
                LET g_msg ="axcp301 ",l_npp01," '' '' '' ", #C20201110-12628 add by litty
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = l_npp01 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
               DISPLAY g_nppglno TO nppglno 
            #END IF      

         WHEN "undo_carry_voucher"
             IF cl_chk_act_auth() THEN
                  IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
                  LET l_npp01= 'A','600','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','0906'
                  SELECT nppglno INTO g_nppglno
                    FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
                     AND npp01=l_npp01
                 #   AND npp01 LIKE '%A600%0906'
                 IF cl_null(g_nppglno) THEN CONTINUE WHILE END IF
#C20201110-12628 mark by litty-s                 
#                   CALL s_get_bookno(g_yy) RETURNING l_flag,l_bookno1,l_bookno2  
#                   
#                 LET l_aba19=''
#                 SELECT aba19 INTO l_aba19 FROM  aba_file WHERE aba00=l_bookno1 AND aba01=g_nppglno  
#                 IF l_aba19 = 'Y' THEN
#                    CALL cl_err(g_nppglno,'cxc-900',1)
#                    RETURN
#                 END IF 
#                 
#                 BEGIN WORK
#                 LET g_success='Y'
#                 UPDATE aba_file SET aba19='X',aba20='0' WHERE aba01=g_nppglno  AND aba00=l_bookno1
#                  IF STATUS OR SQLCA.SQLCODE THEN
#                      CALL cl_err3("upd","aba_file",g_nppglno,'',SQLCA.sqlcode,"","upd aba:",1)  #No.FUN-660122
#                      LET g_success = 'N' 
#                      ROLLBACK WORK
#                      CONTINUE WHILE 
#                  END IF 
#                  IF g_success='Y' THEN     
#                     UPDATE npp_file SET nppglno ='' WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
#                      AND npp01=l_npp01
#                     IF STATUS OR SQLCA.SQLCODE THEN
#                        CALL cl_err3("upd","npp_file",l_npp01,'',SQLCA.sqlcode,"","upd npp:",1)  #No.FUN-660122
#                        LET g_success = 'N' 
#                        ROLLBACK WORK
#                        CONTINUE WHILE 
#                     END IF 
#                  END IF 
#                  COMMIT WORK 
#                  CALL cl_err('','cxc-889',1)   #还原成功
#C20201110-12628 mark by litty-e
#C20201110-12628 remark by litty-s    
               LET g_msg ="axcp302 '",g_plant,"' '",g_plant,"' '",g_nppglno CLIPPED,"' 'Y'"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_npp01 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
#C20201110-12628 remark by litty-e                 
             END IF
            
            #C200616-11911#1 add 
             
             #C200616-11911#1 add  
         WHEN "carry_voucher2"
               IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
                LET l_npp01= 'A','601','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','9061'
               SELECT nppglno INTO g_nppglno1
                 FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0' 
                  AND npp01=l_npp01 
                 #AND npp01 LIKE '%A601%9061'
               IF NOT cl_null(g_nppglno1) THEN 
                 CALL cl_err('','axm-275',1)   #已抛转凭证,不可重复生成!
                 CONTINUE WHILE
               END IF        
               # LET g_msg ="cxcp301 ",l_npp01," '' '' '' ", #C20201110-12628 mark by litty
               LET g_msg ="axcp301 ",l_npp01," '' '' '' ", #C20201110-12628 add by litty
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno1 FROM npp_file WHERE npp01 = l_npp01 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
              # DISPLAY g_nppglno1 TO nppglno1 
            #END IF      

         WHEN "undo_carry_voucher2"
           IF cl_chk_act_auth() THEN
                  IF cl_null(g_yy) OR cl_null(g_mm) THEN CONTINUE WHILE END IF 
                  LET l_npp01= 'A','601','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','9061'
                  SELECT nppglno INTO g_nppglno1
                    FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
                     AND npp01=l_npp01
                 #   AND npp01 LIKE '%A600%0906'
                 IF cl_null(g_nppglno1) THEN CONTINUE WHILE END IF
                 #C20201110-12628 mark by litty -s 
#                   CALL s_get_bookno(g_yy) RETURNING l_flag,l_bookno1,l_bookno2  
#                   
#                 LET l_aba19=''
#                 SELECT aba19 INTO l_aba19 FROM  aba_file WHERE aba00=l_bookno1 AND aba01=g_nppglno1  
#                 IF l_aba19 = 'Y' THEN
#                    CALL cl_err(g_nppglno1,'cxc-900',1)
#                    RETURN
#                 END IF 
#                 
#                 BEGIN WORK
#                 LET g_success='Y'
#                 UPDATE aba_file SET aba19='X',aba20='0' WHERE aba01=g_nppglno1  AND aba00=l_bookno1
#                  IF STATUS OR SQLCA.SQLCODE THEN
#                      CALL cl_err3("upd","aba_file",g_nppglno1,'',SQLCA.sqlcode,"","upd aba:",1)  #No.FUN-660122
#                      LET g_success = 'N' 
#                      ROLLBACK WORK
#                      CONTINUE WHILE 
#                  END IF 
#                  IF g_success='Y' THEN     
#                     UPDATE npp_file SET nppglno ='' WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
#                      AND npp01=l_npp01
#                     IF STATUS OR SQLCA.SQLCODE THEN
#                        CALL cl_err3("upd","npp_file",l_npp01,'',SQLCA.sqlcode,"","upd npp:",1)  #No.FUN-660122
#                        LET g_success = 'N' 
#                        ROLLBACK WORK
#                        CONTINUE WHILE 
#                     END IF 
#                  END IF 
#                  COMMIT WORK 
#                  CALL cl_err('','cxc-889',1)   #还原成功
                  #C20201110-12628 mark by litty -e 
                #C20201110-12628 remark by litty -s     
               LET g_msg ="axcp302 '",g_plant,"' '",g_plant,"' '",g_nppglno CLIPPED,"' 'Y'"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_npp01 AND nppsys ='CA' AND npp00 =2 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
               #C20201110-12628 remark by litty -e  
            END IF
            #C200616-11911#1 add 
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
 
FUNCTION q906_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q906_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
   # OPEN q906_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   # IF SQLCA.sqlcode THEN
   #    CALL cl_err('',SQLCA.sqlcode,0)
   # ELSE
       #OPEN q906_count
       #FETCH q906_count INTO g_row_count
       #DISPLAY g_row_count TO FORMONLY.cnt  
      # CALL q906_fetch('F')                 # 讀出TEMP第一筆並顯示
      #CALL q906_show()
      CALL q906_b_fill()
    
	MESSAGE ''
END FUNCTION
 
 
FUNCTION q906_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   DEFINE l_tlf10   like tlf_file.tlf10     #No.MOD-590345 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03     #No.MOD-910006 add
 
   LET l_sql ="select * from cxcq906_file  "
   LET l_sql = l_sql," WHERE ",tm.wc," AND ta_ccc02='",g_yy,"' AND ta_ccc03='",g_mm,"'"
    PREPARE q906_pb FROM l_sql
    DECLARE q906_bcs                       #BODY CURSOR
        CURSOR FOR q906_pb
 
    CALL g_detail.clear()
 
    LET g_rec_b=0
    LET m_cnt = 1
    LET g_cnt = 1
    LET g_detail_sum.ta_ccc11 = 0 
    LET g_detail_sum.ta_ccc12 = 0 
    LET g_detail_sum.ta_ccc12a= 0 
    LET g_detail_sum.ta_ccc12b= 0 
    LET g_detail_sum.ta_ccc12c= 0 
    LET g_detail_sum.ta_ccc12d= 0 
    LET g_detail_sum.bqrsl    = 0 
    LET g_detail_sum.bqrje    = 0 
    LET g_detail_sum.bqrcl    = 0 
    LET g_detail_sum.bqrrg    = 0 
    LET g_detail_sum.bqrzf    = 0 
    LET g_detail_sum.bqrjg    = 0 
    LET g_detail_sum.scly     = 0 
    LET g_detail_sum.sclyh    = 0 
    LET g_detail_sum.sclyc    = 0 
    LET g_detail_sum.sclyr    = 0 
    LET g_detail_sum.sclyz    = 0 
    LET g_detail_sum.sclyj    = 0 
    LET g_detail_sum.jcsl     = 0 
    LET g_detail_sum.jcje     = 0 
    LET g_detail_sum.bqccl    = 0 
    LET g_detail_sum.bqcrg    = 0 
    LET g_detail_sum.bqczf    = 0 
    LET g_detail_sum.bqcjg    = 0 
    LET g_detail_sum.ta_ccc27 = 0 
    LET g_detail_sum.fgrje    = 0 
    LET g_detail_sum.fgrc     = 0 
    LET g_detail_sum.fgrr     = 0 
    LET g_detail_sum.fgrz     = 0 
    LET g_detail_sum.fgrj     = 0 
    LET g_detail_sum.ta_ccc25 = 0 
    LET g_detail_sum.fglje    = 0 
    LET g_detail_sum.fglc     = 0 
    LET g_detail_sum.fglr     = 0 
    LET g_detail_sum.fglz     = 0 
    LET g_detail_sum.fglj     = 0 
    LET g_detail_sum.ta_ccc214= 0 
    LET g_detail_sum.zrje     = 0 
    LET g_detail_sum.zrc      = 0 
    LET g_detail_sum.zrr      = 0 
    LET g_detail_sum.zrz      = 0 
    LET g_detail_sum.zrj      = 0 
    LET g_detail_sum.ta_ccc41 = 0 
    LET g_detail_sum.zfje     = 0 
    LET g_detail_sum.zfc      = 0 
    LET g_detail_sum.zfr      = 0 
    LET g_detail_sum.zfz      = 0 
    LET g_detail_sum.zfj      = 0 
    LET g_detail_sum.ta_ccc61 = 0 
    LET g_detail_sum.xhje     = 0 
    LET g_detail_sum.xhc      = 0 
    LET g_detail_sum.xhr      = 0 
    LET g_detail_sum.xhz      = 0 
    LET g_detail_sum.xhj      = 0 
    LET g_detail_sum.sltz     = 0 
    LET g_detail_sum.cltz     = 0 
    LET g_detail_sum.rgtz     = 0 
    LET g_detail_sum.zftz     = 0 
    LET g_detail_sum.jgtz     = 0 
    LET g_detail_sum.tzhz     = 0 
    FOREACH q906_bcs INTO g_detail[g_cnt].* 
       
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
      #No:181231 mark begin--------
#      LET g_detail_sum.ta_ccc11 = g_detail_sum.ta_ccc11 + g_detail[g_cnt].ta_ccc11 
#      LET g_detail_sum.ta_ccc12 = g_detail_sum.ta_ccc12 + g_detail[g_cnt].ta_ccc12 
#      LET g_detail_sum.ta_ccc12a= g_detail_sum.ta_ccc12a+ g_detail[g_cnt].ta_ccc12a
#      LET g_detail_sum.ta_ccc12b= g_detail_sum.ta_ccc12b+ g_detail[g_cnt].ta_ccc12b
#      LET g_detail_sum.ta_ccc12c= g_detail_sum.ta_ccc12c+ g_detail[g_cnt].ta_ccc12c
#      LET g_detail_sum.ta_ccc12d= g_detail_sum.ta_ccc12d+ g_detail[g_cnt].ta_ccc12d
#      LET g_detail_sum.bqrsl    = g_detail_sum.bqrsl    + g_detail[g_cnt].bqrsl    
#      LET g_detail_sum.bqrje    = g_detail_sum.bqrje    + g_detail[g_cnt].bqrje    
#      LET g_detail_sum.bqrcl    = g_detail_sum.bqrcl    + g_detail[g_cnt].bqrcl    
#      LET g_detail_sum.bqrrg    = g_detail_sum.bqrrg    + g_detail[g_cnt].bqrrg    
#      LET g_detail_sum.bqrzf    = g_detail_sum.bqrzf    + g_detail[g_cnt].bqrzf    
#      LET g_detail_sum.bqrjg    = g_detail_sum.bqrjg    + g_detail[g_cnt].bqrjg    
#      LET g_detail_sum.scly     = g_detail_sum.scly     + g_detail[g_cnt].scly     
#      LET g_detail_sum.sclyh    = g_detail_sum.sclyh    + g_detail[g_cnt].sclyh    
#      LET g_detail_sum.sclyc    = g_detail_sum.sclyc    + g_detail[g_cnt].sclyc    
#      LET g_detail_sum.sclyr    = g_detail_sum.sclyr    + g_detail[g_cnt].sclyr    
#      LET g_detail_sum.sclyz    = g_detail_sum.sclyz    + g_detail[g_cnt].sclyz    
#      LET g_detail_sum.sclyj    = g_detail_sum.sclyj    + g_detail[g_cnt].sclyj    
#      LET g_detail_sum.jcsl     = g_detail_sum.jcsl     + g_detail[g_cnt].jcsl     
#      LET g_detail_sum.jcje     = g_detail_sum.jcje     + g_detail[g_cnt].jcje     
#      LET g_detail_sum.bqccl    = g_detail_sum.bqccl    + g_detail[g_cnt].bqccl    
#      LET g_detail_sum.bqcrg    = g_detail_sum.bqcrg    + g_detail[g_cnt].bqcrg    
#      LET g_detail_sum.bqczf    = g_detail_sum.bqczf    + g_detail[g_cnt].bqczf    
#      LET g_detail_sum.bqcjg    = g_detail_sum.bqcjg    + g_detail[g_cnt].bqcjg    
#      LET g_detail_sum.ta_ccc27 = g_detail_sum.ta_ccc27 + g_detail[g_cnt].ta_ccc27 
#      LET g_detail_sum.fgrje    = g_detail_sum.fgrje    + g_detail[g_cnt].fgrje    
#      LET g_detail_sum.fgrc     = g_detail_sum.fgrc     + g_detail[g_cnt].fgrc     
#      LET g_detail_sum.fgrr     = g_detail_sum.fgrr     + g_detail[g_cnt].fgrr     
#      LET g_detail_sum.fgrz     = g_detail_sum.fgrz     + g_detail[g_cnt].fgrz     
#      LET g_detail_sum.fgrj     = g_detail_sum.fgrj     + g_detail[g_cnt].fgrj     
#      LET g_detail_sum.ta_ccc25 = g_detail_sum.ta_ccc25 + g_detail[g_cnt].ta_ccc25 
#      LET g_detail_sum.fglje    = g_detail_sum.fglje    + g_detail[g_cnt].fglje    
#      LET g_detail_sum.fglc     = g_detail_sum.fglc     + g_detail[g_cnt].fglc     
#      LET g_detail_sum.fglr     = g_detail_sum.fglr     + g_detail[g_cnt].fglr     
#      LET g_detail_sum.fglz     = g_detail_sum.fglz     + g_detail[g_cnt].fglz     
#      LET g_detail_sum.fglj     = g_detail_sum.fglj     + g_detail[g_cnt].fglj     
#      LET g_detail_sum.ta_ccc214= g_detail_sum.ta_ccc214+ g_detail[g_cnt].ta_ccc214
#      LET g_detail_sum.zrje     = g_detail_sum.zrje     + g_detail[g_cnt].zrje     
#      LET g_detail_sum.zrc      = g_detail_sum.zrc      + g_detail[g_cnt].zrc      
#      LET g_detail_sum.zrr      = g_detail_sum.zrr      + g_detail[g_cnt].zrr      
#      LET g_detail_sum.zrz      = g_detail_sum.zrz      + g_detail[g_cnt].zrz      
#      LET g_detail_sum.zrj      = g_detail_sum.zrj      + g_detail[g_cnt].zrj      
#      LET g_detail_sum.ta_ccc41 = g_detail_sum.ta_ccc41 + g_detail[g_cnt].ta_ccc41 
#      LET g_detail_sum.fje      = g_detail_sum.fje      + g_detail[g_cnt].fje      
#      LET g_detail_sum.zfc      = g_detail_sum.zfc      + g_detail[g_cnt].zfc      
#      LET g_detail_sum.zfr      = g_detail_sum.zfr      + g_detail[g_cnt].zfr      
#      LET g_detail_sum.zfz      = g_detail_sum.zfz      + g_detail[g_cnt].zfz      
#      LET g_detail_sum.zfj      = g_detail_sum.zfj      + g_detail[g_cnt].zfj      
#      LET g_detail_sum.ta_ccc61 = g_detail_sum.ta_ccc61 + g_detail[g_cnt].ta_ccc61 
#      LET g_detail_sum.hje      = g_detail_sum.hje      + g_detail[g_cnt].hje      
#      LET g_detail_sum.xhc      = g_detail_sum.xhc      + g_detail[g_cnt].xhc      
#      LET g_detail_sum.xhr      = g_detail_sum.xhr      + g_detail[g_cnt].xhr      
#      LET g_detail_sum.xhz      = g_detail_sum.xhz      + g_detail[g_cnt].xhz      
#      LET g_detail_sum.xhj      = g_detail_sum.xhj      + g_detail[g_cnt].xhj      
#      LET g_detail_sum.sltz     = g_detail_sum.sltz     + g_detail[g_cnt].sltz     
#      LET g_detail_sum.cltz     = g_detail_sum.cltz     + g_detail[g_cnt].cltz     
#      LET g_detail_sum.rgtz     = g_detail_sum.rgtz     + g_detail[g_cnt].rgtz     
#      LET g_detail_sum.zftz     = g_detail_sum.zftz     + g_detail[g_cnt].zftz     
#      LET g_detail_sum.jgtz     = g_detail_sum.jgtz     + g_detail[g_cnt].jgtz     
#      LET g_detail_sum.tzhz     = g_detail_sum.tzhz     + g_detail[g_cnt].tzhz     
      #No:181231 mark end-------
      LET g_cnt = g_cnt + 1
      LET m_cnt = m_cnt + 1
 END FOREACH
    #CALL g_detail.deleteElement(m_cnt)    #TQC-6B0162 add
    LET g_rec_b = m_cnt - 1
   # LET g_detail_sum.ta_ccc01 = '合计:'     #No:181231 mark
   # LET g_detail[g_cnt].* = g_detail_sum.*  #No:181231 mark
    DISPLAY g_rec_b TO FORMONLY.cn2
    #No:181231 add begin------
    LET l_sql = " SELECT SUM(ta_ccc11),SUM(ta_ccc12),SUM(ta_ccc12a),SUM(ta_ccc12b),SUM(ta_ccc12c),SUM(ta_ccc12d), ",
                " SUM(bqrsl),SUM(bqrje),SUM(bqrcl),SUM(bqrrg),SUM(bqrzf),SUM(bqrjg), ",
                " SUM(scly),SUM(sclyh),SUM(sclyc),SUM(sclyr),SUM(sclyz),SUM(sclyj), ",
                " SUM(jcsl),SUM(jcje),SUM(bqccl),SUM(bqcrg),SUM(bqczf),SUM(bqcjg), ",
                " SUM(ta_ccc27),SUM(fgrje),SUM(fgrc),SUM(fgrr),SUM(fgrz),SUM(fgrj), ",
                " SUM(ta_ccc25),SUM(fglje),SUM(fglc),SUM(fglr),SUM(fglz),SUM(fglj), ",
                " SUM(ta_ccc214),SUM(zrje),SUM(zrc),SUM(zrr),SUM(zrz),SUM(zrj), ",
                " SUM(ta_ccc41),SUM(zfje),SUM(zfc),SUM(zfr),SUM(zfz),SUM(zfj), ",
                " SUM(ta_ccc61),SUM(xhje),SUM(xhc),SUM(xhr),SUM(xhz),SUM(xhj), ",
                " SUM(sltz),SUM(cltz),SUM(rgtz),SUM(zftz),SUM(jgtz),SUM(tzhz) ",
                " FROM cxcq906_file WHERE ",tm.wc,
                " AND ta_ccc02='",g_yy,"' AND ta_ccc03='",g_mm,"'"
    PREPARE q906_pb1 FROM l_sql
    EXECUTE q906_pb1 INTO g_detail_sum.ta_ccc11,g_detail_sum.ta_ccc12,g_detail_sum.ta_ccc12a,g_detail_sum.ta_ccc12b,g_detail_sum.ta_ccc12c,g_detail_sum.ta_ccc12d,
                          g_detail_sum.bqrsl,g_detail_sum.bqrje,g_detail_sum.bqrcl,g_detail_sum.bqrrg,g_detail_sum.bqrzf,g_detail_sum.bqrjg,
                          g_detail_sum.scly,g_detail_sum.sclyh,g_detail_sum.sclyc,g_detail_sum.sclyr,g_detail_sum.sclyz,g_detail_sum.sclyj,
                          g_detail_sum.jcsl,g_detail_sum.jcje,g_detail_sum.bqccl,g_detail_sum.bqcrg,g_detail_sum.bqczf,g_detail_sum.bqcjg,
                          g_detail_sum.ta_ccc27,g_detail_sum.fgrje,g_detail_sum.fgrc,g_detail_sum.fgrr,g_detail_sum.fgrz,g_detail_sum.fgrj,    
                          g_detail_sum.ta_ccc25,g_detail_sum.fglje,g_detail_sum.fglc,g_detail_sum.fglr,g_detail_sum.fglz,g_detail_sum.fglj,
                          g_detail_sum.ta_ccc214,g_detail_sum.zrje,g_detail_sum.zrc,g_detail_sum.zrr,g_detail_sum.zrz,g_detail_sum.zrj,
                          g_detail_sum.ta_ccc41,g_detail_sum.zfje,g_detail_sum.zfc,g_detail_sum.zfr,g_detail_sum.zfz,g_detail_sum.zfj,
                          g_detail_sum.ta_ccc61,g_detail_sum.xhje,g_detail_sum.xhc,g_detail_sum.xhr,g_detail_sum.xhz,g_detail_sum.xhj,
                          g_detail_sum.sltz,g_detail_sum.cltz,g_detail_sum.rgtz,g_detail_sum.zftz,g_detail_sum.jgtz,g_detail_sum.tzhz
                          
    DISPLAY g_detail_sum.ta_ccc11  TO FORMONLY.ta_ccc11_sum 
    DISPLAY g_detail_sum.ta_ccc12  TO FORMONLY.ta_ccc12_sum
    DISPLAY g_detail_sum.ta_ccc12a TO FORMONLY.ta_ccc12a_sum
    DISPLAY g_detail_sum.ta_ccc12b TO FORMONLY.ta_ccc12b_sum
    DISPLAY g_detail_sum.ta_ccc12c TO FORMONLY.ta_ccc12c_sum
    DISPLAY g_detail_sum.ta_ccc12d TO FORMONLY.ta_ccc12d_sum
    DISPLAY g_detail_sum.bqrsl     TO FORMONLY.bqrsl_sum    
    DISPLAY g_detail_sum.bqrje     TO FORMONLY.bqrje_sum    
    DISPLAY g_detail_sum.bqrcl     TO FORMONLY.bqrcl_sum    
    DISPLAY g_detail_sum.bqrrg     TO FORMONLY.bqrrg_sum    
    DISPLAY g_detail_sum.bqrzf     TO FORMONLY.bqrzf_sum    
    DISPLAY g_detail_sum.bqrjg     TO FORMONLY.bqrjg_sum    
    DISPLAY g_detail_sum.scly      TO FORMONLY.scly_sum     
    DISPLAY g_detail_sum.sclyh     TO FORMONLY.sclyh_sum    
    DISPLAY g_detail_sum.sclyc     TO FORMONLY.sclyc_sum    
    DISPLAY g_detail_sum.sclyr     TO FORMONLY.sclyr_sum    
    DISPLAY g_detail_sum.sclyz     TO FORMONLY.sclyz_sum    
    DISPLAY g_detail_sum.sclyj     TO FORMONLY.sclyj_sum    
    DISPLAY g_detail_sum.jcsl      TO FORMONLY.jcsl_sum     
    DISPLAY g_detail_sum.jcje      TO FORMONLY.jcje_sum     
    DISPLAY g_detail_sum.bqccl     TO FORMONLY.bqccl_sum    
    DISPLAY g_detail_sum.bqcrg     TO FORMONLY.bqcrg_sum    
    DISPLAY g_detail_sum.bqczf     TO FORMONLY.bqczf_sum    
    DISPLAY g_detail_sum.bqcjg     TO FORMONLY.bqcjg_sum    
    DISPLAY g_detail_sum.ta_ccc27  TO FORMONLY.ta_ccc27_sum 
    DISPLAY g_detail_sum.fgrje     TO FORMONLY.fgrje_sum    
    DISPLAY g_detail_sum.fgrc      TO FORMONLY.fgrc_sum     
    DISPLAY g_detail_sum.fgrr      TO FORMONLY.fgrr_sum     
    DISPLAY g_detail_sum.fgrz      TO FORMONLY.fgrz_sum     
    DISPLAY g_detail_sum.fgrj      TO FORMONLY.fgrj_sum     
    DISPLAY g_detail_sum.ta_ccc25  TO FORMONLY.ta_ccc25_sum 
    DISPLAY g_detail_sum.fglje     TO FORMONLY.fglje_sum    
    DISPLAY g_detail_sum.fglc      TO FORMONLY.fglc_sum     
    DISPLAY g_detail_sum.fglr      TO FORMONLY.fglr_sum     
    DISPLAY g_detail_sum.fglz      TO FORMONLY.fglz_sum     
    DISPLAY g_detail_sum.fglj      TO FORMONLY.fglj_sum     
    DISPLAY g_detail_sum.ta_ccc214 TO FORMONLY.ta_ccc214_sum
    DISPLAY g_detail_sum.zrje      TO FORMONLY.zrje_sum     
    DISPLAY g_detail_sum.zrc       TO FORMONLY.zrc_sum      
    DISPLAY g_detail_sum.zrr       TO FORMONLY.zrr_sum      
    DISPLAY g_detail_sum.zrz       TO FORMONLY.zrz_sum      
    DISPLAY g_detail_sum.zrj       TO FORMONLY.zrj_sum      
    DISPLAY g_detail_sum.ta_ccc41  TO FORMONLY.ta_ccc41_sum 
    DISPLAY g_detail_sum.zfje      TO FORMONLY.zfje_sum      
    DISPLAY g_detail_sum.zfc       TO FORMONLY.zfc_sum      
    DISPLAY g_detail_sum.zfr       TO FORMONLY.zfr_sum      
    DISPLAY g_detail_sum.zfz       TO FORMONLY.zfz_sum      
    DISPLAY g_detail_sum.zfj       TO FORMONLY.zfj_sum      
    DISPLAY g_detail_sum.ta_ccc61  TO FORMONLY.ta_ccc61_sum 
    DISPLAY g_detail_sum.xhje      TO FORMONLY.xhje_sum      
    DISPLAY g_detail_sum.xhc       TO FORMONLY.xhc_sum      
    DISPLAY g_detail_sum.xhr       TO FORMONLY.xhr_sum      
    DISPLAY g_detail_sum.xhz       TO FORMONLY.xhz_sum      
    DISPLAY g_detail_sum.xhj       TO FORMONLY.xhj_sum      
    DISPLAY g_detail_sum.sltz      TO FORMONLY.sltz_sum     
    DISPLAY g_detail_sum.cltz      TO FORMONLY.cltz_sum     
    DISPLAY g_detail_sum.rgtz      TO FORMONLY.rgtz_sum     
    DISPLAY g_detail_sum.zftz      TO FORMONLY.zftz_sum     
    DISPLAY g_detail_sum.jgtz      TO FORMONLY.jgtz_sum     
    DISPLAY g_detail_sum.tzhz      TO FORMONLY.tzhz_sum     
    #No:181231 add end--------     
                                   
END FUNCTION                       
                                   
FUNCTION q906_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
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
      #   CALL q906_fetch('F')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF
      #     ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      #                        
 #
      #ON ACTION previous
      #   CALL q906_fetch('P')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION jump
      #   CALL q906_fetch('/')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505 
                              
 
      #ON ACTION next
      #   CALL q906_fetch('N')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION last
      #   CALL q906_fetch('L')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
      #C200522-11911#1 adds
      ON ACTION gen_entry #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY 
         
      ON ACTION gen_entry2 #會計分錄產生
         LET g_action_choice="gen_entry2"
         EXIT DISPLAY                          
 				#C200522-11911#1 adde
 				
 			#C200522-11911#1 adds
      ON ACTION entry_sheet #會計分錄
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY                       
 			#C200522-11911#1 adde 
 				#C200522-11911#1 adds
      ON ACTION entry_sheet2 #會計分錄
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY                       
 			#C200522-11911#1 adde                      
     #C200616-11911#1 adds
 				 ON action carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY 

      ON action undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      ON action carry_voucher2
         LET g_action_choice="carry_voucher2"
         EXIT DISPLAY 

      ON action undo_carry_voucher2
         LET g_action_choice="undo_carry_voucher2"
         EXIT DISPLAY
         #C200616-11911#1 adde 	
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
 
      #ON ACTION du_bin_detail     #No.FUN-540025
      #   LET g_action_choice = 'du_bin_detail'
      #   EXIT DISPLAY
 
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
 
FUNCTION q906_v0()
		DEFINE  l_wc        STRING
	  DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
    DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
    DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
    DEFINE l_npp01     LIKE npp_file.npp01		

	   LET l_wc = " ta_ccc02 ='",g_yy,"' AND ta_ccc03 ='",g_mm,"' "

#	    SELECT npp01 INTO g_npp01 
#     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  AND npp01 LIKE '%A600%0906'

    LET l_npp01= 'A','600','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','0906'
    SELECT npp01,nppglno INTO g_npp,g_nppglno
     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
      AND npp01=l_npp01
     #AND npp01 LIKE '%A601%9061'
    IF NOT cl_null(g_nppglno) THEN 
       CALL cl_err('','axc-050',1)   #已抛转凭证,分录底稿资料不可再更改 !!
      RETURN
    END IF          
    
    LET g_success ='Y'
    IF NOT cl_null(g_npp) THEN 
      IF NOT s_ask_entry(g_npp) THEN RETURN END IF 
    END IF 
	   CALL p906_gl(l_wc,g_plant)  RETURNING g_npp
   IF g_success ='N' THEN 
      RETURN  
   END IF  
   
   MESSAGE " "
END FUNCTION

FUNCTION q9061_v0()
		DEFINE  l_wc        STRING
	  DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
    DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
    DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
    DEFINE l_npp01   LIKE npp_file.npp01
    
	   LET l_wc = " ta_ccc02 ='",g_yy,"' AND ta_ccc03 ='",g_mm,"' "
	   

#	   SELECT npp01 INTO g_npp 
#     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  AND npp01 LIKE '%A601%9061'
       
	  LET l_npp01= 'A','601','-',g_yy USING '&&&&',g_mm CLIPPED USING '&&','9061'
    SELECT npp01,nppglno INTO g_npp01,g_nppglno1
     FROM npp_file WHERE nppsys='CA' AND npp00='2' AND npptype='0'  
      AND npp01=l_npp01
     #AND npp01 LIKE '%A601%9061'
    IF NOT cl_null(g_nppglno1) THEN 
       CALL cl_err('','axc-050',1)   #已抛转凭证,分录底稿资料不可再更改 !!
      RETURN
    END IF           
	
    LET g_success ='Y'
    IF NOT cl_null(g_npp01) THEN 
      IF NOT s_ask_entry(g_npp01) THEN RETURN END IF 
    END IF 
      
	   CALL p9061_gl(l_wc,g_plant) RETURNING g_npp01
   IF g_success ='N' THEN 
      RETURN  
   END IF  
   
   MESSAGE " "
END FUNCTION