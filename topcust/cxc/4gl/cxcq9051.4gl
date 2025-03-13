# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq905.4gl
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
                   ta_ccc01 LIKE ima_file.ima01,
                   ta_ccc02 LIKE ccc_file.ccc02,
                   ta_ccc03 LIKE ccc_file.ccc03,
                   ima06    LIKE ima_file.ima06 ,
                   ima02    LIKE ima_file.ima02 ,
                   ima021   LIKE ima_file.ima021,
                   ima39    LIKE ima_file.ima39 ,
                   ima25    LIKE ima_file.ima25 ,
                   ta_ccc18  DECIMAL(20,8),
                   ta_ccc19  DECIMAL(20,8),
                   ta_ccc19a DECIMAL(20,8),
                   ta_ccc19b DECIMAL(20,8),
                   ta_ccc19c DECIMAL(20,8),
                   ta_ccc19d DECIMAL(20,8),
                   ta_ccc31  DECIMAL(20,8),
                   ta_ccc32a DECIMAL(20,8),
                   ta_ccc32b DECIMAL(20,8),
                   ta_ccc32c DECIMAL(20,8),
                   ta_ccc32d DECIMAL(20,8),
                   ta_ccc32  DECIMAL(20,8),
                   ta_ccc98  DECIMAL(20,8),
                   ta_ccc99a DECIMAL(20,8),
                   ta_ccc99b DECIMAL(20,8),
                   ta_ccc99c DECIMAL(20,8),
                   ta_ccc99d DECIMAL(20,8),
                   ta_ccc99  DECIMAL(20,8),
                   ta_cccud01 DECIMAL(20,8),
                   ta_cccud02 DECIMAL(20,8),
                   ta_cccud03 DECIMAL(20,8),
                   ta_cccud04 DECIMAL(20,8),
                   ta_cccud05 DECIMAL(20,8),
                   ta_cccud06 DECIMAL(20,8),
                   ta_cccud07 DECIMAL(20,8),
                   ta_cccud08 DECIMAL(20,8),
                   ta_cccud09 DECIMAL(20,8),
                   ta_cccud10 DECIMAL(20,8),
                   ta_cccud11 DECIMAL(20,8),
                   ta_cccud12 DECIMAL(20,8),
                   ta_cccud12a DECIMAL(20,8),
                   ta_cccud13 DECIMAL(20,8),
                   ta_ccc27   DECIMAL(20,8),
                   ta_ccc27a DECIMAL(20,8),
                   ta_ccc27b DECIMAL(20,8),
                   ta_ccc27c DECIMAL(20,8),
                   ta_ccc27d DECIMAL(20,8),
                   ta_ccc27e DECIMAL(20,8),
                   ta_ccc25  DECIMAL(20,8),
                   ta_ccc25a DECIMAL(20,8),
                   ta_ccc25b DECIMAL(20,8),
                   ta_ccc25c DECIMAL(20,8),
                   ta_ccc25d DECIMAL(20,8),
                   ta_ccc25e DECIMAL(20,8),
                   ta_ccc217 DECIMAL(20,8),
                   ta_ccc217a DECIMAL(20,8),
                   ta_ccc217b DECIMAL(20,8),
                   ta_ccc217c DECIMAL(20,8),
                   ta_ccc217d DECIMAL(20,8),
                   ta_ccc217e DECIMAL(20,8),
                   ta_ccc81   DECIMAL(20,8),  # add by lixwz 190108
                   ta_ccc81a  DECIMAL(20,8),
                   ta_ccc81b  DECIMAL(20,8),
                   ta_ccc81c  DECIMAL(20,8),
                   ta_ccc81d  DECIMAL(20,8),
                   ta_ccc81e  DECIMAL(20,8)
                  END RECORD,
    g_detail_sum   RECORD
                   ta_ccc01 LIKE ima_file.ima01,
                   ta_ccc02 LIKE ccc_file.ccc02,
                   ta_ccc03 LIKE ccc_file.ccc03,
                   ima06    LIKE ima_file.ima06 ,
                   ima02    LIKE ima_file.ima02 ,
                   ima021   LIKE ima_file.ima021,
                   ima39    LIKE ima_file.ima39 ,
                   ima25    LIKE ima_file.ima25 ,
                   ta_ccc18   DECIMAL(20,8),
                   ta_ccc19   DECIMAL(20,8),
                   ta_ccc19a  DECIMAL(20,8),
                   ta_ccc19b  DECIMAL(20,8),
                   ta_ccc19c  DECIMAL(20,8),
                   ta_ccc19d  DECIMAL(20,8),
                   ta_ccc31   DECIMAL(20,8),
                   ta_ccc32a  DECIMAL(20,8),
                   ta_ccc32b  DECIMAL(20,8),
                   ta_ccc32c  DECIMAL(20,8),
                   ta_ccc32d  DECIMAL(20,8),
                   ta_ccc32   DECIMAL(20,8),
                   ta_ccc98   DECIMAL(20,8),
                   ta_ccc99a  DECIMAL(20,8),
                   ta_ccc99b  DECIMAL(20,8),
                   ta_ccc99c  DECIMAL(20,8),
                   ta_ccc99d  DECIMAL(20,8),
                   ta_ccc99   DECIMAL(20,8),
                   ta_cccud01 DECIMAL(20,8),
                   ta_cccud02 DECIMAL(20,8),
                   ta_cccud03 DECIMAL(20,8),
                   ta_cccud04 DECIMAL(20,8),
                   ta_cccud05 DECIMAL(20,8),
                   ta_cccud06 DECIMAL(20,8),
                   ta_cccud07 DECIMAL(20,8),
                   ta_cccud08 DECIMAL(20,8),
                   ta_cccud09 DECIMAL(20,8),
                   ta_cccud10 DECIMAL(20,8),
                   ta_cccud11 DECIMAL(20,8),
                   ta_cccud12 DECIMAL(20,8),
                   ta_cccud12a DECIMAL(20,8),
                   ta_cccud13 DECIMAL(20,8),
                   ta_ccc27   DECIMAL(20,8),
                   ta_ccc27a  DECIMAL(20,8),
                   ta_ccc27b  DECIMAL(20,8),
                   ta_ccc27c  DECIMAL(20,8),
                   ta_ccc27d  DECIMAL(20,8),
                   ta_ccc27e  DECIMAL(20,8),
                   ta_ccc25   DECIMAL(20,8),
                   ta_ccc25a  DECIMAL(20,8),
                   ta_ccc25b  DECIMAL(20,8),
                   ta_ccc25c  DECIMAL(20,8),
                   ta_ccc25d  DECIMAL(20,8),
                   ta_ccc25e  DECIMAL(20,8),
                   ta_ccc217  DECIMAL(20,8),
                   ta_ccc217a DECIMAL(20,8),
                   ta_ccc217b DECIMAL(20,8),
                   ta_ccc217c DECIMAL(20,8),
                   ta_ccc217d DECIMAL(20,8),
                   ta_ccc217e DECIMAL(20,8),
                   ta_ccc81   DECIMAL(20,8),    # add by lixwz 190108
                   ta_ccc81a  DECIMAL(20,8),
                   ta_ccc81b  DECIMAL(20,8),
                   ta_ccc81c  DECIMAL(20,8),
                   ta_ccc81d  DECIMAL(20,8),
                   ta_ccc81e  DECIMAL(20,8)
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
 
    OPEN WINDOW q905_w AT p_row,p_col
         WITH FORM "cxc/42f/cxcq905" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) THEN    #No.MOD-480150
       CALL q905_q()
    END IF
 
    CALL q905_menu()
    CLOSE WINDOW q905_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q905_curs()
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
      CONSTRUCT BY NAME tm.wc ON ta_ccc01,ima06,ima02,ima021,ima39
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
    PREPARE q905_prepare FROM g_sql
    DECLARE q905_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q905_prepare
 
 
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
    #PREPARE q905_sel FROM g_sql
    #EXECUTE q905_sel
#
    #LET g_sql=" SELECT COUNT(*) FROM x "
    ##TQC-C10121--end
    #PREPARE q905_pp  FROM g_sql
    #DECLARE q905_count   CURSOR FOR q905_pp
END FUNCTION
 
FUNCTION q905_b_askkey()
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
 
 
FUNCTION q905_menu()
 
   WHILE TRUE
      CALL q905_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
         CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
               CALL q905_q()
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
 
FUNCTION q905_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q905_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
   # OPEN q905_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   # IF SQLCA.sqlcode THEN
   #    CALL cl_err('',SQLCA.sqlcode,0)
   # ELSE
       #OPEN q905_count
       #FETCH q905_count INTO g_row_count
       #DISPLAY g_row_count TO FORMONLY.cnt  
      # CALL q905_fetch('F')                 # 讀出TEMP第一筆並顯示
      #CALL q905_show()
      CALL q905_b_fill()
    
	MESSAGE ''
END FUNCTION
 
 
FUNCTION q905_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   DEFINE l_tlf10   like tlf_file.tlf10     #No.MOD-590345 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03     #No.MOD-910006 add
 
   LET l_sql ="select * from cxcq905_file  "
   LET l_sql = l_sql," WHERE ",tm.wc," AND ta_ccc02='",g_yy,"' AND ta_ccc03='",g_mm,"'"
    PREPARE q905_pb FROM l_sql
    DECLARE q905_bcs                       #BODY CURSOR
        CURSOR FOR q905_pb
 
    CALL g_detail.clear()
 
    LET g_rec_b=0
    LET m_cnt = 1
    LET g_cnt = 1
    LET g_detail_sum.ta_ccc18   = 0
    LET g_detail_sum.ta_ccc19   = 0
    LET g_detail_sum.ta_ccc19a  = 0
    LET g_detail_sum.ta_ccc19b  = 0
    LET g_detail_sum.ta_ccc19c  = 0
    LET g_detail_sum.ta_ccc19d  = 0
    LET g_detail_sum.ta_ccc31   = 0
    LET g_detail_sum.ta_ccc32a  = 0
    LET g_detail_sum.ta_ccc32b  = 0
    LET g_detail_sum.ta_ccc32c  = 0
    LET g_detail_sum.ta_ccc32d  = 0
    LET g_detail_sum.ta_ccc32   = 0
    LET g_detail_sum.ta_ccc98   = 0
    LET g_detail_sum.ta_ccc99a  = 0
    LET g_detail_sum.ta_ccc99b  = 0
    LET g_detail_sum.ta_ccc99c  = 0
    LET g_detail_sum.ta_ccc99d  = 0
    LET g_detail_sum.ta_ccc99   = 0
    LET g_detail_sum.ta_cccud01 = 0
    LET g_detail_sum.ta_cccud02 = 0
    LET g_detail_sum.ta_cccud03 = 0
    LET g_detail_sum.ta_cccud04 = 0
    LET g_detail_sum.ta_cccud05 = 0
    LET g_detail_sum.ta_cccud06 = 0
    LET g_detail_sum.ta_cccud07 = 0
    LET g_detail_sum.ta_cccud08 = 0
    LET g_detail_sum.ta_cccud09 = 0
    LET g_detail_sum.ta_cccud10 = 0
    LET g_detail_sum.ta_cccud11 = 0
    LET g_detail_sum.ta_cccud12 = 0
    LET g_detail_sum.ta_cccud12a =0
    LET g_detail_sum.ta_cccud13 = 0
    LET g_detail_sum.ta_ccc27   = 0
    LET g_detail_sum.ta_ccc27a  = 0
    LET g_detail_sum.ta_ccc27b  = 0
    LET g_detail_sum.ta_ccc27c  = 0
    LET g_detail_sum.ta_ccc27d  = 0
    LET g_detail_sum.ta_ccc27e  = 0
    LET g_detail_sum.ta_ccc25   = 0
    LET g_detail_sum.ta_ccc25a  = 0
    LET g_detail_sum.ta_ccc25b  = 0
    LET g_detail_sum.ta_ccc25c  = 0
    LET g_detail_sum.ta_ccc25d  = 0
    LET g_detail_sum.ta_ccc25e  = 0
    LET g_detail_sum.ta_ccc217  = 0
    LET g_detail_sum.ta_ccc217a = 0
    LET g_detail_sum.ta_ccc217b = 0
    LET g_detail_sum.ta_ccc217c = 0
    LET g_detail_sum.ta_ccc217d = 0
    LET g_detail_sum.ta_ccc217e = 0
    LET g_detail_sum.ta_ccc81a  = 0
    LET g_detail_sum.ta_ccc81b  = 0
    LET g_detail_sum.ta_ccc81c  = 0
    LET g_detail_sum.ta_ccc81d  = 0
    LET g_detail_sum.ta_ccc81e  = 0
    FOREACH q905_bcs INTO g_detail[g_cnt].* 
       
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
      #No:181230 mark begin-------
#      LET g_detail_sum.ta_ccc18   = g_detail_sum.ta_ccc18   + g_detail[g_cnt].ta_ccc18   
#      LET g_detail_sum.ta_ccc19   = g_detail_sum.ta_ccc19   + g_detail[g_cnt].ta_ccc19   
#      LET g_detail_sum.ta_ccc19a  = g_detail_sum.ta_ccc19a  + g_detail[g_cnt].ta_ccc19a  
#      LET g_detail_sum.ta_ccc19b  = g_detail_sum.ta_ccc19b  + g_detail[g_cnt].ta_ccc19b  
#      LET g_detail_sum.ta_ccc19c  = g_detail_sum.ta_ccc19c  + g_detail[g_cnt].ta_ccc19c  
#      LET g_detail_sum.ta_ccc19d  = g_detail_sum.ta_ccc19d  + g_detail[g_cnt].ta_ccc19d  
#      LET g_detail_sum.ta_ccc31   = g_detail_sum.ta_ccc31   + g_detail[g_cnt].ta_ccc31   
#      LET g_detail_sum.ta_ccc32a  = g_detail_sum.ta_ccc32a  + g_detail[g_cnt].ta_ccc32a  
#      LET g_detail_sum.ta_ccc32b  = g_detail_sum.ta_ccc32b  + g_detail[g_cnt].ta_ccc32b  
#      LET g_detail_sum.ta_ccc32c  = g_detail_sum.ta_ccc32c  + g_detail[g_cnt].ta_ccc32c  
#      LET g_detail_sum.ta_ccc32d  = g_detail_sum.ta_ccc32d  + g_detail[g_cnt].ta_ccc32d  
#      LET g_detail_sum.ta_ccc32   = g_detail_sum.ta_ccc32   + g_detail[g_cnt].ta_ccc32   
#      LET g_detail_sum.ta_ccc98   = g_detail_sum.ta_ccc98   + g_detail[g_cnt].ta_ccc98   
#      LET g_detail_sum.ta_ccc99a  = g_detail_sum.ta_ccc99a  + g_detail[g_cnt].ta_ccc99a  
#      LET g_detail_sum.ta_ccc99b  = g_detail_sum.ta_ccc99b  + g_detail[g_cnt].ta_ccc99b  
#      LET g_detail_sum.ta_ccc99c  = g_detail_sum.ta_ccc99c  + g_detail[g_cnt].ta_ccc99c  
#      LET g_detail_sum.ta_ccc99d  = g_detail_sum.ta_ccc99d  + g_detail[g_cnt].ta_ccc99d  
#      LET g_detail_sum.ta_ccc99   = g_detail_sum.ta_ccc99   + g_detail[g_cnt].ta_ccc99   
#      LET g_detail_sum.ta_cccud01 = g_detail_sum.ta_cccud01 + g_detail[g_cnt].ta_cccud01 
#      LET g_detail_sum.ta_cccud02 = g_detail_sum.ta_cccud02 + g_detail[g_cnt].ta_cccud02 
#      LET g_detail_sum.ta_cccud03 = g_detail_sum.ta_cccud03 + g_detail[g_cnt].ta_cccud03 
#      LET g_detail_sum.ta_cccud04 = g_detail_sum.ta_cccud04 + g_detail[g_cnt].ta_cccud04 
#      LET g_detail_sum.ta_cccud05 = g_detail_sum.ta_cccud05 + g_detail[g_cnt].ta_cccud05 
#      LET g_detail_sum.ta_cccud06 = g_detail_sum.ta_cccud06 + g_detail[g_cnt].ta_cccud06 
#      LET g_detail_sum.ta_cccud07 = g_detail_sum.ta_cccud07 + g_detail[g_cnt].ta_cccud07 
#      LET g_detail_sum.ta_cccud08 = g_detail_sum.ta_cccud08 + g_detail[g_cnt].ta_cccud08 
#      LET g_detail_sum.ta_cccud09 = g_detail_sum.ta_cccud09 + g_detail[g_cnt].ta_cccud09 
#      LET g_detail_sum.ta_cccud10 = g_detail_sum.ta_cccud10 + g_detail[g_cnt].ta_cccud10 
#      LET g_detail_sum.ta_cccud11 = g_detail_sum.ta_cccud11 + g_detail[g_cnt].ta_cccud11 
#      LET g_detail_sum.ta_cccud12 = g_detail_sum.ta_cccud12 + g_detail[g_cnt].ta_cccud12 
#      LET g_detail_sum.ta_cccud12a = g_detail_sum.ta_cccud12a + g_detail[g_cnt].ta_cccud12a 
#      LET g_detail_sum.ta_cccud13 = g_detail_sum.ta_cccud13 + g_detail[g_cnt].ta_cccud13 
#      LET g_detail_sum.ta_ccc27   = g_detail_sum.ta_ccc27   + g_detail[g_cnt].ta_ccc27   
#      LET g_detail_sum.ta_ccc27a  = g_detail_sum.ta_ccc27a  + g_detail[g_cnt].ta_ccc27a  
#      LET g_detail_sum.ta_ccc27b  = g_detail_sum.ta_ccc27b  + g_detail[g_cnt].ta_ccc27b  
#      LET g_detail_sum.ta_ccc27c  = g_detail_sum.ta_ccc27c  + g_detail[g_cnt].ta_ccc27c  
#      LET g_detail_sum.ta_ccc27d  = g_detail_sum.ta_ccc27d  + g_detail[g_cnt].ta_ccc27d  
#      LET g_detail_sum.ta_ccc27e  = g_detail_sum.ta_ccc27e  + g_detail[g_cnt].ta_ccc27e  
#      LET g_detail_sum.ta_ccc25   = g_detail_sum.ta_ccc25   + g_detail[g_cnt].ta_ccc25   
#      LET g_detail_sum.ta_ccc25a  = g_detail_sum.ta_ccc25a  + g_detail[g_cnt].ta_ccc25a  
#      LET g_detail_sum.ta_ccc25b  = g_detail_sum.ta_ccc25b  + g_detail[g_cnt].ta_ccc25b  
#      LET g_detail_sum.ta_ccc25c  = g_detail_sum.ta_ccc25c  + g_detail[g_cnt].ta_ccc25c  
#      LET g_detail_sum.ta_ccc25d  = g_detail_sum.ta_ccc25d  + g_detail[g_cnt].ta_ccc25d  
#      LET g_detail_sum.ta_ccc25e  = g_detail_sum.ta_ccc25e  + g_detail[g_cnt].ta_ccc25e  
#      LET g_detail_sum.ta_ccc217  = g_detail_sum.ta_ccc217  + g_detail[g_cnt].ta_ccc217  
#      LET g_detail_sum.ta_ccc217a = g_detail_sum.ta_ccc217a + g_detail[g_cnt].ta_ccc217a 
#      LET g_detail_sum.ta_ccc217b = g_detail_sum.ta_ccc217b + g_detail[g_cnt].ta_ccc217b 
#      LET g_detail_sum.ta_ccc217c = g_detail_sum.ta_ccc217c + g_detail[g_cnt].ta_ccc217c 
#      LET g_detail_sum.ta_ccc217d = g_detail_sum.ta_ccc217d + g_detail[g_cnt].ta_ccc217d 
#      LET g_detail_sum.ta_ccc217e = g_detail_sum.ta_ccc217e + g_detail[g_cnt].ta_ccc217e 
#      LET g_detail_sum.ta_ccc81a  = g_detail_sum.ta_ccc81a  + g_detail[g_cnt].ta_ccc81a  
#      LET g_detail_sum.ta_ccc81b  = g_detail_sum.ta_ccc81b  + g_detail[g_cnt].ta_ccc81b  
#      LET g_detail_sum.ta_ccc81c  = g_detail_sum.ta_ccc81c  + g_detail[g_cnt].ta_ccc81c  
#      LET g_detail_sum.ta_ccc81d  = g_detail_sum.ta_ccc81d  + g_detail[g_cnt].ta_ccc81d  
#      LET g_detail_sum.ta_ccc81e  = g_detail_sum.ta_ccc81e  + g_detail[g_cnt].ta_ccc81e  
      #No:181230 mark end--------
      LET g_cnt = g_cnt + 1
      LET m_cnt = m_cnt + 1
 END FOREACH
    CALL g_detail.deleteElement(m_cnt)    #TQC-6B0162 add
    LET g_rec_b = m_cnt - 1
    #LET  g_detail_sum.ta_ccc01 = '合计:'
    #LET g_detail[g_cnt].* = g_detail_sum.*
    DISPLAY g_rec_b TO FORMONLY.cn2
    #No:181230 add begin------
    LET l_sql = " SELECT SUM(ta_ccc19a),SUM(ta_ccc19b),SUM(ta_ccc19c),SUM(ta_ccc19d),SUM(ta_ccc19), ",
                " SUM(ta_ccc32a),SUM(ta_ccc32b),SUM(ta_ccc32c),SUM(ta_ccc32d),SUM(ta_ccc32), ",
                " SUM(ta_ccc99a),SUM(ta_ccc99b),SUM(ta_ccc99c),SUM(ta_ccc99d),SUM(ta_ccc99), ",
                " SUM(ta_cccud02),SUM(ta_cccud03),SUM(ta_cccud04),SUM(ta_cccud05),SUM(ta_cccud06), ",
                " SUM(ta_cccud07),SUM(ta_cccud08),SUM(ta_cccud09),SUM(ta_cccud10),SUM(ta_cccud11), ",
                " SUM(ta_cccud12),SUM(ta_cccud12a), ",
                " SUM(ta_ccc27a),SUM(ta_ccc27b),SUM(ta_ccc27c),SUM(ta_ccc27d),SUM(ta_ccc27e), ",
                " SUM(ta_ccc25a),SUM(ta_ccc25b),SUM(ta_ccc25c),SUM(ta_ccc25d),SUM(ta_ccc25e), ",
                " SUM(ta_ccc217a),SUM(ta_ccc217b),SUM(ta_ccc217c),SUM(ta_ccc217d),SUM(ta_ccc217e), ",
                " SUM(ta_ccc81), ",
                " SUM(ta_ccc81a),SUM(ta_ccc81b),SUM(ta_ccc81c),SUM(ta_ccc81d),SUM(ta_ccc81e) ",
                " FROM cxcq905_file WHERE ",tm.wc,
                " AND ta_ccc02='",g_yy,"' AND ta_ccc03='",g_mm,"'"
    PREPARE q905_pb1 FROM l_sql
    EXECUTE q905_pb1 INTO g_detail_sum.ta_ccc19a, g_detail_sum.ta_ccc19b,g_detail_sum.ta_ccc19c,g_detail_sum.ta_ccc19d,g_detail_sum.ta_ccc19,
                          g_detail_sum.ta_ccc32a, g_detail_sum.ta_ccc32b,g_detail_sum.ta_ccc32c,g_detail_sum.ta_ccc32d,g_detail_sum.ta_ccc32,
                          g_detail_sum.ta_ccc99a, g_detail_sum.ta_ccc99b,g_detail_sum.ta_ccc99c,g_detail_sum.ta_ccc99d,g_detail_sum.ta_ccc99,
                          g_detail_sum.ta_cccud02, g_detail_sum.ta_cccud03,g_detail_sum.ta_cccud04,g_detail_sum.ta_cccud05,g_detail_sum.ta_cccud06,
                          g_detail_sum.ta_cccud07, g_detail_sum.ta_cccud08,g_detail_sum.ta_cccud09,g_detail_sum.ta_cccud10,g_detail_sum.ta_cccud11,
                          g_detail_sum.ta_cccud12, g_detail_sum.ta_cccud12a,
                          g_detail_sum.ta_ccc27a, g_detail_sum.ta_ccc27b,g_detail_sum.ta_ccc27c,g_detail_sum.ta_ccc27d,g_detail_sum.ta_ccc27e,
                          g_detail_sum.ta_ccc25a, g_detail_sum.ta_ccc25b,g_detail_sum.ta_ccc25c,g_detail_sum.ta_ccc25d,g_detail_sum.ta_ccc25e,
                          g_detail_sum.ta_ccc217a, g_detail_sum.ta_ccc217b,g_detail_sum.ta_ccc217c,g_detail_sum.ta_ccc217d,g_detail_sum.ta_ccc217e,
                          g_detail_sum.ta_ccc81,
                          g_detail_sum.ta_ccc81a, g_detail_sum.ta_ccc81b,g_detail_sum.ta_ccc81c,g_detail_sum.ta_ccc81d,g_detail_sum.ta_ccc81e
   
    DISPLAY g_detail_sum.ta_ccc19a TO FORMONLY.ta_ccc19a_sum
    DISPLAY g_detail_sum.ta_ccc19b TO FORMONLY.ta_ccc19b_sum
    DISPLAY g_detail_sum.ta_ccc19c TO FORMONLY.ta_ccc19c_sum
    DISPLAY g_detail_sum.ta_ccc19d TO FORMONLY.ta_ccc19d_sum
    DISPLAY g_detail_sum.ta_ccc19  TO FORMONLY.ta_ccc19_sum 
    DISPLAY g_detail_sum.ta_ccc32a TO FORMONLY.ta_ccc32a_sum    
    DISPLAY g_detail_sum.ta_ccc32b TO FORMONLY.ta_ccc32b_sum     
    DISPLAY g_detail_sum.ta_ccc32c TO FORMONLY.ta_ccc32c_sum     
    DISPLAY g_detail_sum.ta_ccc32d TO FORMONLY.ta_ccc32d_sum     
    DISPLAY g_detail_sum.ta_ccc32  TO FORMONLY.ta_ccc32_sum   
    DISPLAY g_detail_sum.ta_ccc99a TO FORMONLY.ta_ccc99a_sum     
    DISPLAY g_detail_sum.ta_ccc99b TO FORMONLY.ta_ccc99b_sum     
    DISPLAY g_detail_sum.ta_ccc99c TO FORMONLY.ta_ccc99c_sum    
    DISPLAY g_detail_sum.ta_ccc99d TO FORMONLY.ta_ccc99d_sum
    DISPLAY g_detail_sum.ta_ccc99  TO FORMONLY.ta_ccc99_sum
    DISPLAY g_detail_sum.ta_cccud02 TO FORMONLY.ta_cccud02_sum
    DISPLAY g_detail_sum.ta_cccud03 TO FORMONLY.ta_cccud03_sum
    DISPLAY g_detail_sum.ta_cccud04 TO FORMONLY.ta_cccud04_sum
    DISPLAY g_detail_sum.ta_cccud05 TO FORMONLY.ta_cccud05_sum
    DISPLAY g_detail_sum.ta_cccud06 TO FORMONLY.ta_cccud06_sum
    DISPLAY g_detail_sum.ta_cccud07 TO FORMONLY.ta_cccud07_sum
    DISPLAY g_detail_sum.ta_cccud08 TO FORMONLY.ta_cccud08_sum
    DISPLAY g_detail_sum.ta_cccud09 TO FORMONLY.ta_cccud09_sum
    DISPLAY g_detail_sum.ta_cccud10 TO FORMONLY.ta_cccud10_sum
    DISPLAY g_detail_sum.ta_cccud11 TO FORMONLY.ta_cccud11_sum
    DISPLAY g_detail_sum.ta_cccud12 TO FORMONLY.ta_cccud12_sum
    DISPLAY g_detail_sum.ta_cccud12a TO FORMONLY.ta_cccud12a_sum
    DISPLAY g_detail_sum.ta_ccc27a  TO FORMONLY.ta_ccc27a_sum
    DISPLAY g_detail_sum.ta_ccc27b  TO FORMONLY.ta_ccc27b_sum
    DISPLAY g_detail_sum.ta_ccc27c  TO FORMONLY.ta_ccc27c_sum
    DISPLAY g_detail_sum.ta_ccc27d  TO FORMONLY.ta_ccc27d_sum
    DISPLAY g_detail_sum.ta_ccc27e  TO FORMONLY.ta_ccc27e_sum
    DISPLAY g_detail_sum.ta_ccc25a  TO FORMONLY.ta_ccc25a_sum
    DISPLAY g_detail_sum.ta_ccc25b  TO FORMONLY.ta_ccc25b_sum
    DISPLAY g_detail_sum.ta_ccc25c  TO FORMONLY.ta_ccc25c_sum
    DISPLAY g_detail_sum.ta_ccc25d  TO FORMONLY.ta_ccc25d_sum
    DISPLAY g_detail_sum.ta_ccc25e  TO FORMONLY.ta_ccc25e_sum
    DISPLAY g_detail_sum.ta_ccc217a TO FORMONLY.ta_ccc217a_sum
    DISPLAY g_detail_sum.ta_ccc217b TO FORMONLY.ta_ccc217b_sum
    DISPLAY g_detail_sum.ta_ccc217c TO FORMONLY.ta_ccc217c_sum
    DISPLAY g_detail_sum.ta_ccc217d TO FORMONLY.ta_ccc217d_sum
    DISPLAY g_detail_sum.ta_ccc217e TO FORMONLY.ta_ccc217e_sum
    DISPLAY g_detail_sum.ta_ccc81  TO FORMONLY.ta_ccc81_sum      # add by lixwz 190108
    DISPLAY g_detail_sum.ta_ccc81a TO FORMONLY.ta_ccc81a_sum
    DISPLAY g_detail_sum.ta_ccc81b TO FORMONLY.ta_ccc81b_sum
    DISPLAY g_detail_sum.ta_ccc81c TO FORMONLY.ta_ccc81c_sum
    DISPLAY g_detail_sum.ta_ccc81d TO FORMONLY.ta_ccc81d_sum
    DISPLAY g_detail_sum.ta_ccc81e TO FORMONLY.ta_ccc81e_sum
    #No:181230 add end--------
END FUNCTION
 
FUNCTION q905_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   #No:181230 mark begin-------
#   DISPLAY
#       g_detail_sum.ta_ccc18   ,g_detail_sum.ta_ccc19   ,g_detail_sum.ta_ccc19a  ,g_detail_sum.ta_ccc19b  ,g_detail_sum.ta_ccc19c  ,g_detail_sum.ta_ccc19d  ,g_detail_sum.ta_ccc31   ,g_detail_sum.ta_ccc32a  ,g_detail_sum.ta_ccc32b  ,
#       g_detail_sum.ta_ccc32c  ,g_detail_sum.ta_ccc32d  ,g_detail_sum.ta_ccc32   ,g_detail_sum.ta_ccc98   ,g_detail_sum.ta_ccc99a  ,g_detail_sum.ta_ccc99b  ,g_detail_sum.ta_ccc99c  ,g_detail_sum.ta_ccc99d  ,
#       g_detail_sum.ta_ccc99   ,g_detail_sum.ta_cccud01 ,g_detail_sum.ta_cccud02 ,g_detail_sum.ta_cccud03 ,g_detail_sum.ta_cccud04 ,g_detail_sum.ta_cccud05 ,g_detail_sum.ta_cccud06 ,
#       g_detail_sum.ta_cccud07 ,g_detail_sum.ta_cccud08 ,g_detail_sum.ta_cccud09 ,g_detail_sum.ta_cccud10 ,g_detail_sum.ta_cccud11 ,g_detail_sum.ta_cccud12 ,
#       g_detail_sum.ta_cccud12a,g_detail_sum.ta_cccud13 ,g_detail_sum.ta_ccc27   ,g_detail_sum.ta_ccc27a  ,g_detail_sum.ta_ccc27b  ,
#       g_detail_sum.ta_ccc27c  ,g_detail_sum.ta_ccc27d  ,g_detail_sum.ta_ccc27e  ,g_detail_sum.ta_ccc25   ,g_detail_sum.ta_ccc25a  ,g_detail_sum.ta_ccc25b  ,g_detail_sum.ta_ccc25c  ,
#       g_detail_sum.ta_ccc25d  ,g_detail_sum.ta_ccc25e  ,g_detail_sum.ta_ccc217  ,g_detail_sum.ta_ccc217a ,g_detail_sum.ta_ccc217b ,g_detail_sum.ta_ccc217c ,
#       g_detail_sum.ta_ccc217d ,g_detail_sum.ta_ccc217e ,g_detail_sum.ta_ccc81a  ,g_detail_sum.ta_ccc81b  ,g_detail_sum.ta_ccc81c  ,g_detail_sum.ta_ccc81d  ,g_detail_sum.ta_ccc81e
#       TO
#       ta_ccc18_sum,ta_ccc19_sum,ta_ccc19a_sum,ta_ccc19b_sum,ta_ccc19c_sum,ta_ccc19d_sum,ta_ccc31_sum,ta_ccc32a_sum,ta_ccc32b_sum,
#       ta_ccc32c_sum,ta_ccc32d_sum,ta_ccc32_sum,ta_ccc98_sum,ta_ccc99a_sum,ta_ccc99b_sum,ta_ccc99c_sum,ta_ccc99d_sum,
#       ta_ccc99_sum,ta_cccud01_sum,ta_cccud02_sum,ta_cccud03_sum,ta_cccud04_sum,ta_cccud05_sum,ta_cccud06_sum,
#       ta_cccud07_sum,ta_cccud08_sum,ta_cccud09_sum,ta_cccud10_sum,ta_cccud11_sum,ta_cccud12_sum,
#       ta_cccud12a_sum,ta_cccud13_sum,ta_ccc27_sum,ta_ccc27a_sum,ta_ccc27b_sum,
#       ta_ccc27c_sum,ta_ccc27d_sum,ta_ccc27e_sum,ta_ccc25_sum,ta_ccc25a_sum,ta_ccc25b_sum,ta_ccc25c_sum,
#       ta_ccc25d_sum,ta_ccc25e_sum,ta_ccc217_sum,ta_ccc217a_sum,ta_ccc217b_sum,ta_ccc217c_sum,
#       ta_ccc217d_sum,ta_ccc217e_sum,ta_ccc81a_sum,ta_ccc81b_sum,ta_ccc81c_sum,ta_ccc81d_sum,ta_ccc81e
#   #No:11230 mark end-------  
 
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
      #   CALL q905_fetch('F')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF
      #     ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      #                        
 #
      #ON ACTION previous
      #   CALL q905_fetch('P')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION jump
      #   CALL q905_fetch('/')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505 
                              
 
      #ON ACTION next
      #   CALL q905_fetch('N')
      #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
      #     IF g_rec_b != 0 THEN
      #   CALL fgl_set_arr_curr(1)  ######add in 040505
      #     END IF 
                              
 
      #ON ACTION last
      #   CALL q905_fetch('L')
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
 
