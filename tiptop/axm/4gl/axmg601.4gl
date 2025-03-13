# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmg601.4gl
# Descriptions...: Delivery Note 
# Date & Author..: No.FUN-6C0005 06/12/05 by rainy  ref. axmr600
# Modify.........: No.FUN-710090 07/02/27 By chenl 報表輸出至Crystal Reports功能
#                                                  注意，axmr600和axmg601共用一個axmr600.ttx數據類型文件，若對此ttx文件有所改動而影響程序，請一并修改其他共用ttx的相關程序。
# Modify.........: No.FUN-730014 07/03/06 By chenl s_addr傳回5個參數
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.FUN-860026 08/07/25 By baofei 增加子報表-列印批序號明細    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80088 10/08/17 By yinhy 畫面條件選項增加一個選項，Additional Description Category
# Modify.........: No.TQC-B30065 11/03/09 By zhangll l_sql -> STRING
# Modify.........: No.FUN-B40087 11/05/24 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN-B80089追單
# Modify.........: No.FUN-C10036 12/01/11 By xuxz MOD-BB0031,MOD-BB0046 追單
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/04/28 By wangrr GR程式優化
# Modify.........: No.FUN-C70051 12/07/12 By qiaozy gr添加款式明細選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
              wc      STRING,  #Mod No.TQC-B30065
              a       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print price
              d       LIKE type_file.chr1,        # No.FUN-690032 客戶料號
              b       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print memo
              c       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print Sub Item#      #No.FUN-5C0075
              e       LIKE type_file.chr1,        #FUN-740057 add              # 列印公司對內全名
              f       LIKE type_file.chr1,        #FUN-740057 add              # 列印公司對外全名
              g       LIKE type_file.chr1,        #No.FUN-860026 
              h       LIKE type_file.chr1,        #No.FUN-A80088 
              i       LIKE type_file.chr1,        #FUN-C70051--ADD I 
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)     # Input more condition(Y/N)
              END RECORD,
          g_m  ARRAY[40] OF LIKE oao_file.oao06,   #No.MOD-610046
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137  VARCHAR(72)
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
#FUN-6C0005
#No.FUN-710090--begin-- 
DEFINE  g_sql1      STRING
DEFINE  g_sql       STRING
DEFINE  g_str       STRING
DEFINE  l_table     STRING
DEFINE  l_table1    STRING
DEFINE  l_table2    STRING
DEFINE  l_table3    STRING                 #No.FUN-860026    
DEFINE  l_table4    STRING                 #No.FUN-A80088
DEFINE  l_table5    STRING                 #FUN-C70051--ADD----
DEFINE  l_table6    STRING                 #FUN-C70051--ADD--   
#No.FUN-710090--end--
 
###GENGRE###START
TYPE sr1_t RECORD
    oga01 LIKE oga_file.oga01,
    oga011 LIKE oga_file.oga011,
    oga02 LIKE oga_file.oga02,
    oga16 LIKE oga_file.oga16,
    oga021 LIKE oga_file.oga021,
    oga15 LIKE oga_file.oga15,
    gem02 LIKE gem_file.gem02,
    oga032 LIKE oga_file.oga032,
    oga033 LIKE oga_file.oga033,
    oga045 LIKE oga_file.oga45,
    oga03 LIKE oga_file.oga03,
    oga04 LIKE oga_file.oga04,
    oga14 LIKE oga_file.oga14,
    gen02 LIKE gen_file.gen02,
    occ02 LIKE occ_file.occ02,
    addr1 LIKE aaf_file.aaf03,
    addr2 LIKE aaf_file.aaf03,
    addr3 LIKE aaf_file.aaf03,
    ogb03 LIKE ogb_file.ogb03,
    ogb04 LIKE ogb_file.ogb04,
    donum LIKE type_file.chr30,      #FUN-C70051---CHR20---->CHR30
    ogb12 LIKE ogb_file.ogb12,
    ogb05 LIKE ogb_file.ogb05,
    ima02 LIKE ima_file.ima02,
    weight LIKE ogb_file.ogb12,
    ogb19 LIKE ogb_file.ogb19,
    ima021 LIKE ima_file.ima021,
    note LIKE type_file.chr37,
    str3 LIKE type_file.chr1000,
    ogb11 LIKE ogb_file.ogb11,
    oga09 LIKE oga_file.oga09,
    oaydesc LIKE oay_file.oaydesc,
    flag LIKE type_file.num5,
    ogb07 LIKE ogb_file.ogb07,
    l_count LIKE type_file.num5,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    ogc01 LIKE ogc_file.ogc01,
    i1 LIKE type_file.num5,
    loc LIKE type_file.chr37,
    ogc16 LIKE ogc_file.ogc16,#FUN-C10036 add ,
    ogc03 LIKE ogc_file.ogc03 #FUN-C10036 add
END RECORD

TYPE sr3_t RECORD
    ogc01 LIKE ogc_file.ogc01,
    i2 LIKE type_file.num5,
    ogc17 LIKE ogc_file.ogc17,
    ogc12 LIKE ogc_file.ogc12,
    ima02t LIKE ima_file.ima02
END RECORD

TYPE sr4_t RECORD
    rvbs01 LIKE rvbs_file.rvbs01,
    rvbs02 LIKE rvbs_file.rvbs02,
    rvbs03 LIKE rvbs_file.rvbs03,
    rvbs04 LIKE rvbs_file.rvbs04,
    rvbs06 LIKE rvbs_file.rvbs06,
    rvbs021 LIKE rvbs_file.rvbs021,
    ogb06 LIKE ogb_file.ogb06,
    ima021 LIKE ima_file.ima021,
    ogb05 LIKE ogb_file.ogb05,
    ogb12 LIKE ogb_file.ogb12,
    img09 LIKE img_file.img09
END RECORD

TYPE sr5_t RECORD
    imc01 LIKE imc_file.imc01,
    imc02 LIKE imc_file.imc02,
    imc03 LIKE imc_file.imc03,
    imc04 LIKE imc_file.imc04,
    oga01 LIKE oga_file.oga01,
    ogb03 LIKE ogb_file.ogb03
END RECORD

#FUN-C70051-----ADD----STR-----
TYPE sr6_t RECORD
    agd03_1  LIKE agd_file.agd03,
    agd03_2  LIKE agd_file.agd03,  
    agd03_3  LIKE agd_file.agd03,
    agd03_4  LIKE agd_file.agd03,
    agd03_5  LIKE agd_file.agd03,
    agd03_6  LIKE agd_file.agd03,
    agd03_7  LIKE agd_file.agd03,
    agd03_8  LIKE agd_file.agd03,
    agd03_9  LIKE agd_file.agd03,
    agd03_10 LIKE agd_file.agd03,
    agd03_11 LIKE agd_file.agd03,
    agd03_12 LIKE agd_file.agd03,
    agd03_13 LIKE agd_file.agd03,
    agd03_14 LIKE agd_file.agd03,
    agd03_15 LIKE agd_file.agd03,
    ogbslk04 LIKE ogbslk_file.ogbslk04
END RECORD

TYPE sr7_t RECORD
    imx01    LIKE imx_file.imx01, 
    number1  LIKE type_file.num5,
    number2  LIKE type_file.num5,
    number3  LIKE type_file.num5,
    number4  LIKE type_file.num5,
    number5  LIKE type_file.num5,
    number6  LIKE type_file.num5,
    number7  LIKE type_file.num5,
    number8  LIKE type_file.num5,
    number9  LIKE type_file.num5,
    number10 LIKE type_file.num5,
    number11 LIKE type_file.num5,
    number12 LIKE type_file.num5,
    number13 LIKE type_file.num5,
    number14 LIKE type_file.num5,
    number15 LIKE type_file.num5,
    ogbslk01 LIKE ogbslk_file.ogbslk01,
    ogbslk03 LIKE ogbslk_file.ogbslk03,
    ogbslk04 LIKE ogbslk_file.ogbslk04
END RECORD
#FUN-C70051-----ADD-----END----
###GENGRE###END

MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126   #FUN-C10036  mark
  
  #No.FUN-710090--begin--
    LET g_sql1="oga01.oga_file.oga01,",
               "oga011.oga_file.oga011,",
               "oga02.oga_file.oga02,",
               "oga16.oga_file.oga16,",
               "oga021.oga_file.oga021,",
               "oga15.oga_file.oga15,",
               "gem02.gem_file.gem02,",
               "oga032.oga_file.oga032,",
               "oga033.oga_file.oga033,",
               "oga045.oga_file.oga45,",
               "oga03.oga_file.oga03,",
               "oga04.oga_file.oga04,",
               "oga14.oga_file.oga14,",
               "gen02.gen_file.gen02,",
               "occ02.occ_file.occ02,",
               "addr1.aaf_file.aaf03,",
               "addr2.aaf_file.aaf03,",
               "addr3.aaf_file.aaf03,",
               "ogb03.ogb_file.ogb03,",
               "ogb04.ogb_file.ogb04,",
               "donum.type_file.chr30,",     #FUN-C70051---CHR20---->CHR30
               "ogb12.ogb_file.ogb12,",
               "ogb05.ogb_file.ogb05,",
               "ima02.ima_file.ima02,",
               "weight.ogb_file.ogb12,",
               "ogb19.ogb_file.ogb19,",
               "ima021.ima_file.ima021,",
               "note.type_file.chr37,",
               "str3.type_file.chr1000,",
               "ogb11.ogb_file.ogb11,",
               "oga09.oga_file.oga09,",      #FUN-740057 add
#               "oaydesc.oay_file.oaydesc"   #FUN-740057 add
               "oaydesc.oay_file.oaydesc,",  #No.FUN-860026
               "flag.type_file.num5,",       #No.FUN-860026 
               "ogb07.ogb_file.ogb07,",      #No.FUN-A80088 
               "l_count.type_file.num5,",      #No.FUN-A80088
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('axmg601',g_sql1) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036  mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF
 
   LET g_sql1="ogc01.ogc_file.ogc01,",
              "i1.type_file.num5,",
              "loc.type_file.chr37,",
              "ogc16.ogc_file.ogc16,",#FUN-C10036 add ,
              "ogc03.ogc_file.ogc03" #FUN-C10036 add
   LET l_table1 = cl_prt_temptable('axmg6011',g_sql1) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087   #FUN-C10036  mark                                                      
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF
   LET g_sql1 ="ogc01.ogc_file.ogc01,",
              "i2.type_file.num5,",
              "ogc17.ogc_file.ogc17,",
              "ogc12.ogc_file.ogc12,",
              "ima02t.ima_file.ima02"
   LET l_table2 = cl_prt_temptable('axmg6012',g_sql1) CLIPPED
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036  mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087 #FUN-C10036  mark
      EXIT PROGRAM 
   END IF
 
  #No.FUN-710090--end--
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                      
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb12.ogb_file.ogb12,",                                                                                             
               "img09.img_file.img09"                                                                                               
   LET l_table3 = cl_prt_temptable('axmg6013',g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087    #FUN-C10036  mark                                                     
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                                                                                       
#No.FUN-860026---end  
   #No.FUN-A80088 --start--
   LET g_sql1 = "imc01.imc_file.imc01,",
                "imc02.imc_file.imc02,",
                "imc03.imc_file.imc03,",
                "imc04.imc_file.imc04,",
                "oga01.oga_file.oga01,",
                "ogb03.ogb_file.ogb03"
    LET l_table4 = cl_prt_temptable('axmg6014',g_sql1) CLIPPED
    IF l_table4 = -1 THEN 
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087   #FUN-C10036  mark                                                      
       #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087  #FUN-C10036  mark
       EXIT PROGRAM
    END IF
   #No.FUN-A80088 --end--  
#FUN-C70051-----ADD----STR-----
    LET g_sql1="agd03_1.agd_file.agd03,agd03_2.agd_file.agd03,",
             "agd03_3.agd_file.agd03,agd03_4.agd_file.agd03,",
             "agd03_5.agd_file.agd03,agd03_6.agd_file.agd03,",
             "agd03_7.agd_file.agd03,agd03_8.agd_file.agd03,",
             "agd03_9.agd_file.agd03,agd03_10.agd_file.agd03,",
             "agd03_11.agd_file.agd03,agd03_12.agd_file.agd03,",
             "agd03_13.agd_file.agd03,agd03_14.agd_file.agd03,",
             "agd03_15.agd_file.agd03,ogbslk04.ogbslk_file.ogbslk04"
   LET l_table5 = cl_prt_temptable('axmg6015',g_sql1) CLIPPED 
   IF l_table5 = -1 THEN 
      EXIT PROGRAM 
   END IF 
   LET g_sql1="imx01.imx_file.imx01,number1.type_file.num5,", 
             "number2.type_file.num5,",
             "number3.type_file.num5,",
             "number4.type_file.num5,",
             "number5.type_file.num5,",
             "number6.type_file.num5,",
             "number7.type_file.num5,",
             "number8.type_file.num5,",
             "number9.type_file.num5,",
             "number10.type_file.num5,number11.type_file.num5,",
             "number12.type_file.num5,number13.type_file.num5,",
             "number14.type_file.num5,number15.type_file.num5,",
             "ogbslk01.ogbslk_file.ogbslk01,",
             "ogbslk03.ogbslk_file.ogbslk03,ogbslk04.ogbslk_file.ogbslk04"
   LET l_table6 = cl_prt_temptable('axmg6016',g_sql1) CLIPPED 
   IF l_table6 = -1 THEN 
      EXIT PROGRAM 
   END IF
#FUN-C70051-----ADD----END-----   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add

   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(10)
   LET tm.e    = ARG_VAL(11)   #FUN-740057 add
   LET tm.f    = ARG_VAL(12)   #FUN-740057 add
   LET tm.g    = ARG_VAL(13)   #No.FUN-860026 
   LET tm.h    = ARG_VAL(14)   #No.FUN-A80088 
   LET tm.i    = ARG_VAL(19)  #FUN-C70051--ADD---
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc) THEN
      CALL axmg601_tm(0,0)             # Input print condition
   ELSE
     #LET tm.wc="oga01 ='",tm.wc CLIPPED,"' " CLIPPED    #No.TQC-610089 mark
      LET tm.a = "1"    #No.MOD-580084
      CALL axmg601()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
   #FUN-C70051--ADD--L_TABLE5,l_table6
END MAIN
 
FUNCTION axmg601_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmg601_w AT p_row,p_col WITH FORM "axm/42f/axmg601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#No.FUN-5C0075--begin
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
#No.FUN-5C0075--end
   #FUN-C70051------ADD---STR---
   IF s_industry('slk') AND g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("i",TRUE)
      CALL cl_set_comp_visible("d,b,c,e,f,h,g,more",FALSE)
   ELSE
      CALL cl_set_comp_visible("i",FALSE)
      CALL cl_set_comp_visible("d,b,c,e,f,h,g,more",TRUE) 
   END IF
   #FUN-C70051----ADD----END---- 
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
   LET tm.i ='Y'    #FUN-C70051---ADD--
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         #### No.FUN-4A0020
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = "2','3','4','6','7','8"   #No.TQC-5B0095 #No.FUN-610020
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
            END CASE
         ### END  No.FUN-4A0020
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmg601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6) #FUN-C70051---
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#FUN-C70051---ADD-STR-------
      IF s_industry('slk') AND g_azw.azw04='2' THEN
         LET tm.a = '1'
         LET tm.d = 'N'   
         LET tm.b = 'N'
         LET tm.c = 'N'   
         LET tm.e = 'N'
         LET tm.f = 'N'  
         LET tm.g = 'N' 
         LET tm.h = 'N'
         LET tm.i = 'Y'
      ELSE
#FUN-C70051---ADD-END-----
      LET tm.a = '1'
      LET tm.d = 'N'   #FUN-690032 add
      LET tm.b = 'Y'
      LET tm.c = 'N'   #No.FUN-5C0075
      LET tm.e = 'Y'   #FUN-740057 add
      LET tm.f = 'Y'   #FUN-740057 add
      LET tm.g = 'N'  #No.FUN-860026  
      LET tm.h = 'N'  #No.FUN-A80088
         LET tm.i = 'Y'                                    #FUN-C70051---ADD---
      END IF                                               #FUN-C70051---ADD-
      INPUT BY NAME tm.a,tm.d,tm.b,tm.c,tm.e,tm.f,tm.g,tm.h,tm.i,tm.more WITHOUT DEFAULTS   #No.FUN-5C0075  #FUN-690032 add tm.d   #FUN-740057 add tm.e,tm.f  #No.FUN-860026  add tm.g  #FUN-A80088 add tm.h
         #FUN-C70051---ADD TM.I----
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
               NEXT FIELD a
            END IF
 
        #FUN-690032 add--begin
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
        #FUN-690032 add--end 
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
#No.FUN-5C0075--begin
        AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
             NEXT FIELD c
          END IF
#No.FUN-5C0075--end
 
        #str FUN-740057 add
        AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN 
               NEXT FIELD e 
            END IF
   
        AFTER FIELD f
            IF cl_null(tm.f) OR tm.f NOT MATCHES '[YN]' THEN 
               NEXT FIELD f 
            END IF
        #end FUN-740057 add
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD g    #列印批序號明細                                                                                              
         IF tm.g NOT MATCHES "[YN]" OR cl_null(tm.g)                                                                                
            THEN NEXT FIELD g                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
        #FUN-A80088 add--begin
         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES '[YN]' THEN
               NEXT FIELD h
            END IF
        #FUN-A80088 add--end 
        #FUN-C70051----ADD----STR-----
        AFTER FIELD i
            IF cl_null(tm.i) OR tm.i NOT MATCHES '[YN]' THEN
               NEXT FIELD i
            END IF
        #FUN-C70051----ADD----END-----      
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmg601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)  #FUN-C70051---
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'axmg601'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmg601','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,  #FUN-690032 add
                       #---------
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                       #------------No.TQC-610089 end
                        " '",tm.e CLIPPED,"'" ,                #FUN-740057 add
                        " '",tm.f CLIPPED,"'" ,                #FUN-740057 add
                        " '",tm.g CLIPPED,"'" ,                #No.FUN-860026
                        " '",tm.h CLIPPED,"'" ,                #No.FUN-A80088
                        " '",tm.i CLIPPED,"'" ,                #FUN-C70051---ADD--
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmg601',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axmg601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6) #FUN-C70051--ADD--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL axmg601()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axmg601_w
 
END FUNCTION
 
FUNCTION axmg601()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   #LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
     #     l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,  #Mod No.TQC-B30065
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_count   LIKE type_file.num5,          #No.FUN-A80088 
          sr        RECORD
                       oga01     LIKE oga_file.oga01,
                       oaydesc   LIKE oay_file.oaydesc,
                       oga02     LIKE oga_file.oga02,
                       oga021    LIKE oga_file.oga021,
                       oga011    LIKE oga_file.oga011,
                       oga14     LIKE oga_file.oga14,
                       oga15     LIKE oga_file.oga15,
                       oga16     LIKE oga_file.oga16,
                       oga032    LIKE oga_file.oga032,
                       oga03     LIKE oga_file.oga03,
                       oga033    LIKE oga_file.oga033,   #統一編號
                       oga45     LIKE oga_file.oga45,    #聯絡人
                       occ02     LIKE occ_file.occ02,
                       oga04     LIKE oga_file.oga04,
                       oga044    LIKE oga_file.oga044,
                       ogb03     LIKE ogb_file.ogb03,
                       ogb07     LIKE ogb_file.ogb07,   #No.FUN-A80088
                       ogb31     LIKE ogb_file.ogb31,
                       ogb32     LIKE ogb_file.ogb32,
                       ogb04     LIKE ogb_file.ogb04,
                       ogb092    LIKE ogb_file.ogb092,
                       ogb05     LIKE ogb_file.ogb05,
                       ogb12     LIKE ogb_file.ogb12,
                       ogb06     LIKE ogb_file.ogb06,
                       ogb11     LIKE ogb_file.ogb11,
                       ogb17     LIKE ogb_file.ogb17,
                       ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
                       ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                       ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                       ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                       ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                       ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
                       ima18     LIKE ima_file.ima18
                    END RECORD,
         #No.FUN-A80088  --start--
           sr1        RECORD
                      imc01     LIKE imc_file.imc01,
                      imc02     LIKE imc_file.imc02,
                      imc03     LIKE imc_file.imc03,
                      imc04     LIKE imc_file.imc04
                      END RECORD
          #No.FUN-A80088  --end--
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
  #No.FUN-710090--begin--
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
   DEFINE         l_addr1    LIKE aaf_file.aaf03
   DEFINE         l_addr2    LIKE aaf_file.aaf03
   DEFINE         l_addr3    LIKE aaf_file.aaf03
   DEFINE         l_addr4    LIKE aaf_file.aaf03      #No.FUN-730014
   DEFINE         l_addr5    LIKE aaf_file.aaf03      #No.FUN-730014
   DEFINE         l_gen02    LIKE gen_file.gen02
   DEFINE         l_oag02    LIKE oag_file.oag02
   DEFINE         l_gem02    LIKE gem_file.gem02
   DEFINE         l_ogb12    LIKE ogb_file.ogb12
   DEFINE         l_str2     STRING
   DEFINE         l_str3     LIKE type_file.chr1000
   DEFINE         l_ogc      RECORD
                          ogc09     LIKE ogc_file.ogc09,
                          ogc091    LIKE ogc_file.ogc091,
                          ogc16     LIKE ogc_file.ogc16,
                          ogc092    LIKE ogc_file.ogc092,#FUN-C10036 add ,
                          ogc03    LIKE ogc_file.ogc03 #FUN-C10036 add
                       END RECORD
   DEFINE         l_loc      LIKE type_file.chr37
   DEFINE         l_weight   LIKE ogb_file.ogb12
   DEFINE         l_donum    LIKE type_file.chr30        #FUN-C70051---CHR20---->CHR30 
   DEFINE         l_ima906    LIKE ima_file.ima906
   DEFINE         l_ima021    LIKE ima_file.ima021  
   DEFINE         l_ima02     LIKE ima_file.ima02
   DEFINE         l_ogb915    STRING
   DEFINE         l_ogb912    STRING
   DEFINE         l_note      LIKE type_file.chr37
   DEFINE         l_oga09     LIKE oga_file.oga09
   DEFINE         l_oaz23     LIKE oaz_file.oaz23
   DEFINE         g_ogc       RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD
   DEFINE l_zo12   LIKE zo_file.zo12   #FUN-740057 add
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                                                                                  
     DEFINE        flag        LIKE type_file.num5
#No.FUN-860026---end 
#FUN-C70051-----ADD-----STR----
   DEFINE l_num_t        RECORD
                  number1       LIKE type_file.num5,
                  number2       LIKE type_file.num5,
                  number3       LIKE type_file.num5,
                  number4       LIKE type_file.num5,
                  number5       LIKE type_file.num5,
                  number6       LIKE type_file.num5,
                  number7       LIKE type_file.num5,
                  number8       LIKE type_file.num5,
                  number9       LIKE type_file.num5,
                  number10      LIKE type_file.num5,
                  number11      LIKE type_file.num5,
                  number12      LIKE type_file.num5,
                  number13      LIKE type_file.num5,
                  number14      LIKE type_file.num5,
                  number15      LIKE type_file.num5
                  END RECORD
                  
DEFINE l_ogbslk03 LIKE ogbslk_file.ogbslk03
DEFINE l_ogb04    LIKE ogb_file.ogb04
DEFINE l_imx_t  RECORD
       agd03_1  LIKE agd_file.agd03,
       agd03_2  LIKE agd_file.agd03,  
       agd03_3  LIKE agd_file.agd03,
       agd03_4  LIKE agd_file.agd03,
       agd03_5  LIKE agd_file.agd03,
       agd03_6  LIKE agd_file.agd03,
       agd03_7  LIKE agd_file.agd03,
       agd03_8  LIKE agd_file.agd03,
       agd03_9  LIKE agd_file.agd03,
       agd03_10 LIKE agd_file.agd03,
       agd03_11 LIKE agd_file.agd03,
       agd03_12 LIKE agd_file.agd03,
       agd03_13 LIKE agd_file.agd03,
       agd03_14 LIKE agd_file.agd03,
       agd03_15 LIKE agd_file.agd03
                END RECORD

DEFINE l_n           LIKE type_file.num5
DEFINE l_ima151      LIKE ima_file.ima151
DEFINE  l_num   DYNAMIC ARRAY OF RECORD
                 number  LIKE type_file.num5
                END RECORD
DEFINE  l_imx   DYNAMIC ARRAY OF RECORD
                imx01    LIKE type_file.chr10
                END RECORD
DEFINE  l_sql2  STRING
DEFINE  l_imx02 LIKE imx_file.imx02
DEFINE  l_imx01 LIKE imx_file.imx01
DEFINE  l_agd04 LIKE agd_file.agd04
DEFINE  l_i     LIKE type_file.num5
DEFINE  l_agd03 LIKE agd_file.agd03
DEFINE  l_ps    LIKE sma_file.sma46
DEFINE  l_ima01 LIKE ima_file.ima01 
#FUN-C70051-----ADD-----END-----

  #No.FUN-710090--end--
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)   #No.FUN-860026  
   CALL cl_del_data(l_table4)   #No.FUN-A80088
   CALL cl_del_data(l_table5)   #FUN-C70051---
   CALL cl_del_data(l_table6)   #FUN-C70051--- 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #str FUN-740057 add
   SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
   IF cl_null(l_zo12) THEN
      SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
   END IF
   #end FUN-740057 add
 
   #MOD-540174..................begin
#  DECLARE axmr600_za_cur CURSOR FOR
#          SELECT za02,za05 FROM za_file
#           WHERE za01 = "axmr600" AND za03 = g_rlang
#  FOREACH axmr600_za_cur INTO g_i,l_za05
#     LET g_x[g_i] = l_za05
#  END FOREACH
   #MOD-540174..................end
  #No.FUN-710090--begin--
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmg601'  #No.FUN-710090 mark
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmg601'
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                                                              ?,?,?,?,   ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "  # No.FUN-C40020 add 4?  #FUN-740057 add ?,?   #No.FUN-860026 add ,?  #FUN-A80088 add 2?
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-C10036    add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
      EXIT PROGRAM
   END IF
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," values(?,?,?,?,?) "#FUN-C10036 add ?
   PREPARE insert1 FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)             
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-C10036    add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
      EXIT PROGRAM
   END IF   
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED," values(?,?,?,?,?) "
   PREPARE insert2 FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-C10036    add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
      EXIT PROGRAM
   END IF  
  #LET g_len = 134           #No.FUN-570176                    #No.FUN-710090 mark  
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR      #No.FUN-710090 mark 
  #No.FUN-710090--end--
#No.FUN-860026---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep3 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END 
#No.FUN-A80088---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep4 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep4:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
        EXIT PROGRAM                                                                          
     END IF 
#FUN-C70051-----ADD-----STR----
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep5 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep5:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
        EXIT PROGRAM                                                                          
     END IF
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                                 
     PREPARE insert_prep6 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep6:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)#FUN-C70051---ADD--
        EXIT PROGRAM                                                                          
     END IF
#FUN-C70051-----ADD-----END----     
#No.FUN-A80088---END
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
   IF tm.i='N' THEN
   LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,ogb07,   ",   #No.FUN-A80088 add ogb07
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18",        #No.FUN-580004 #TQC-5B0127 add ogb916 AND FUN-5C0075
" FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE  ltrim(rtrim(oay_file.oayslip)) || '-%' LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 WHERE oga01 = ogb01 ", 
#No.FUN-550070--end
             "   AND oga09 != '1' AND  oga09 != '5' AND oga09 !='9'", #No.FUN-610020
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " #01/08/20 mandy
   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "          
#FUN-C70051----ADD----STR------             
   ELSE
      IF s_industry('slk') AND g_azw.azw04='2' THEN
      LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogbslk03,ogbslk07,   ",
             "       ogbslk31,ogbslk32,ogbslk04,ogbslk092,ogbslk05,ogbslk12,ogbslk06,ogbslk11,'N','N',ogbslk15,ogbslk16,'','','',ima18",
" FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE  ltrim(rtrim(oay_file.oayslip)) || '-%' LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogbslk_file LEFT OUTER JOIN ima_file ON ogbslk_file.ogbslk04 = ima_file.ima01 WHERE oga01 = ogbslk01 ",
             "   AND oga09 != '1' AND  oga09 != '5' AND oga09 !='9'",
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' "
      LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogbslk03 "         
      ELSE
         LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,ogb07,   ",   #No.FUN-A80088 add ogb07
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18",        #No.FUN-580004 #TQC-5B0127 add ogb916 AND FUN-5C0075
" FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE  ltrim(rtrim(oay_file.oayslip)) || '-%' LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 WHERE oga01 = ogb01 ", 
#No.FUN-550070--end
             "   AND oga09 != '1' AND  oga09 != '5' AND oga09 !='9'", #No.FUN-610020
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " #01/08/20 mandy
   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 " 
      END IF
   END IF
#FUN-C70051----ADD-----END---   
 
   PREPARE axmg601_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6) #FUN-C70051----ADD---
      EXIT PROGRAM
   END IF
 
   DECLARE axmg601_curs1 CURSOR FOR axmg601_prepare1
#FUN-C50008--add--str
   LET g_sql = "SELECT ogc12,ogc17 ",
               "  FROM ogc_file",
               " WHERE ogc01 = ?"
   PREPARE ogc_prepare FROM g_sql
   DECLARE ogc_cs CURSOR FOR ogc_prepare
 
   DECLARE r920_c  CURSOR  FOR
      SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file
       WHERE rvbs01 = ? AND rvbs02 = ?
         AND rvbs00 <> 'aqct800' 
       ORDER BY  rvbs04
   DECLARE imc_cur CURSOR FOR
      SELECT * FROM imc_file     
         WHERE imc01=? AND imc02=? ORDER BY imc03
 #FUN-C50008--add--end
 ##No.FUN-710090--begin-- mark
 # #CALL cl_outnam('axmg601') RETURNING l_name    #No.FUN-710090 mark
 
 #  #FUN-580004--begin
 #  SELECT sma115 INTO g_sma115 FROM sma_file
 #  IF g_sma115 = "Y" THEN
 #     LET g_zaa[34].zaa06 = "N"
 #    #LET g_zaa[45].zaa06 = "N" #FUN-5A0181 mark
 #  ELSE
 #     LET g_zaa[34].zaa06 = "Y"
 #    #LET g_zaa[45].zaa06 = "Y" #FUN-5A0181 mark
 #  END IF
 
 ##FUN-690032 add--begin  #列印客戶料號
 # IF tm.d = 'N' THEN
 #    LET g_zaa[56].zaa06 = 'Y'
 # ELSE
 #    LET g_zaa[56].zaa06 = 'N'
 # END IF
 ##FUN-690032 add--end
 
 #  CALL cl_prt_pos_len()
 #  #No.FUN-580004--end
 
 #  START REPORT axmg601_rep TO l_name
 
 #  LET g_pageno = 0
    CALL g_show_msg.clear() #FUN-650020
 ##No.FUN-710090--end--  
 
   FOREACH axmg601_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ogb092 IS NULL THEN
         LET sr.ogb092 = ' '
      END IF
  #No.FUN-710090--begin--
         SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
         IF STATUS THEN
            LET l_gen02 = ''
         END IF
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
         IF STATUS THEN
            LET l_gem02 = ''
         END IF
 
         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
              RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5   #No.FUN-730014  addr4/addr5
         IF SQLCA.SQLCODE THEN
            LET l_addr1 = ''
            LET l_addr2 = ''
            LET l_addr3 = ''
            LET l_addr4 = ''     #o.FUN-730014 
            LET l_addr5 = ''     #o.FUN-730014  
         END IF
         
 
#TQC-5B0127--add
 
      SELECT ima02,ima021,ima906 #FUN-650005 add ima02
        INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
        FROM ima_file
       WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                  END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
      LET l_donum = sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###'
      LET l_weight = sr.ogb12*sr.ima18
      LET l_note = l_str2 clipped
#TQC-5B0127--end
         #No.FUN-610020  --Begin 打印客戶驗退數量
         IF l_oga09 = '8' THEN
            SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
             WHERE oga01 = ogb01 AND oga011 = sr.oga011
               AND ogb03 = sr.ogb03 AND oga09 = '9'
            IF SQLCA.sqlcode = 0 THEN
               IF g_sma115 = "Y" THEN
                  CASE l_ima906
                     WHEN "2"
                         CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                         LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                             LET l_str3 = l_ogb912, l_ogb.ogb910 CLIPPED
                         ELSE
                            IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
                               CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                               LET l_str3 = l_str3 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
                            END IF
                           END IF
                     WHEN "3"
                         IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                             LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         END IF
                  END CASE
               END IF
               IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
                    #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
                     IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
                        CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
                        LET l_str3 = l_str3 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
                     END IF
               END IF
               LET l_str3=l_str3 CLIPPED,(21-LENGTH(l_str3 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
            END IF
         END IF
         #No.FUN-610020  --End
         IF tm.a ='1' THEN
            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
               WHEN 'Y'
                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092,ogc03  FROM ogc_file ",#FUN-C10036 add ogc03
                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
               WHEN 'N'
                 #FUN-C70051----ADD----STR---- 
                  IF s_industry('slk') AND g_azw.azw04='2' AND tm.i='Y' THEN
                     LET l_sql=" SELECT ogbslk09,ogbslk091,ogbslk16,ogbslk092,ogbslk03 FROM ogbslk_file",
                               " WHERE ogbslk01 = '",sr.oga01,"' AND ogbslk03 ='",sr.ogb03,"'"
                  ELSE
                 #FUN-C70051----ADD----END---
                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092,ogb03 FROM ogb_file",#FUN-C10036 add ogb03
                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
                  END IF    #FUN-C70051----ADD--- 
            END CASE
         ELSE
            LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
                      " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
                      "   AND img10 > 0 "
         END IF
 
         PREPARE g601_p2 FROM l_sql
         DECLARE g601_c2 CURSOR FOR g601_p2
         LET i=1
         FOREACH g601_c2 INTO l_ogc.*
           LET l_loc = "(",l_ogc.ogc09 clipped
           IF l_ogc.ogc091 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc091 clipped
           END IF
           IF l_ogc.ogc092 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc092 clipped
           END IF
           LET l_loc = l_loc clipped,")"
           IF STATUS THEN EXIT FOREACH END IF
           IF tm.a ='1' THEN
              EXECUTE insert1 USING sr.oga01,i,l_loc,l_ogc.ogc16,l_ogc.ogc03 #FUN-C10036 add ,l_ogc.ogc03   
           ELSE  
            	EXECUTE insert1 USING sr.ogb04,i,l_loc,l_ogc.ogc16,l_ogc.ogc03 #FUN-C10036 add ,l_ogc.ogc03  
           END IF
           LET i = i+1
        END FOREACH
#No.FUN-5C0075--begin
        SELECT oaz23 INTO l_oaz23 FROM oaz_file
        IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
        #FUN-C50008--mark--str
            #LET g_sql = "SELECT ogc12,ogc17 ",
            #            "  FROM ogc_file",
            #            " WHERE ogc01 = '",sr.oga01,"'"
         #PREPARE ogc_prepare FROM g_sql
         #DECLARE ogc_cs CURSOR FOR ogc_prepare
        #FUN-C50008--mark--end
         LET i = 1
        #FOREACH ogc_cs INTO g_ogc.*  #FUN-C50008 mark--
         FOREACH ogc_cs USING sr.oga01 INTO g_ogc.*  #FUN-C50008 add
            SELECT ima02 INTO l_ima02 FROM ima_file
             WHERE ima01 = g_ogc.ogc17 
             EXECUTE insert2 USING sr.oga01,i,g_ogc.ogc17,g_ogc.ogc12,l_ima02                
            LET i = i+1
         END FOREACH
         END IF
#No.FUN-5C0075--end           
#No.FUN-860026---begin                                                                                                              
    LET flag = 0                                                                                                                                 
    SELECT img09 INTO l_img09  FROM img_file,ogb_file                                                                               
               WHERE img01 = sr.ogb04                                                                                               
               AND img02 = ogb09 AND img03 = ogb091                                                                                 
               AND img04 = ogb092 AND ogb01 = sr.oga01                                                                              
               AND ogb03 = sr.ogb03 
 #FUN-C50008--mark--str                                                                                                   
   #DECLARE r920_c  CURSOR  FOR                                                                                                     
   #        SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
   #               WHERE rvbs01 = sr.oga01 AND rvbs02 = sr.ogb03                                                                     
   #                 AND rvbs00 <> 'aqct800' #FUN-C10036 add
   #               ORDER BY  rvbs04                                                                                                  
   # FOREACH  r920_c INTO l_rvbs.*   
#FUN-C50008--mark--end
     FOREACH  r920_c USING sr.oga01,sr.ogb03 INTO l_rvbs.*   #FUN-C50008 add 
         LET flag = 1                                                                                            
         EXECUTE insert_prep3 USING  sr.oga01,sr.ogb03,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     l_ima02,l_ima021,sr.ogb05,sr.ogb12,                                                            
                                     l_img09
                                    # ,"",  l_img_blob,"N",""  # No.FUN-C40020 add  #FUN-C50008 mark-- 簽核欄位應添加在主報表                                                                                    
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end  
      #No.FUN-A80088  --start  列印額外品名規格說明
      IF tm.f = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=sr.ogb04 AND imc02=sr.ogb07
          IF l_count !=0  THEN
      #FUN-C50008--mark--str
           #DECLARE imc_cur CURSOR FOR
           #SELECT * FROM imc_file    
           #  WHERE imc01=sr.ogb04 AND imc02=sr.ogb07 
           #ORDER BY imc03                                        
           #FOREACH imc_cur INTO sr1.*
      #FUN-C50008--mark--end 
            FOREACH imc_cur USING sr.ogb04,sr.ogb07 INTO sr1.*  #FUN-C50008 add                             
              EXECUTE insert_prep4 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oga01,sr.ogb03
            END FOREACH
          END IF
       END IF    
       #No.FUN-A80088  --end
       EXECUTE insert_prep USING sr.oga01,sr.oga011,sr.oga02,sr.oga16,sr.oga021,sr.oga15,
                                 l_gem02,sr.oga032,sr.oga033,sr.oga45,sr.oga03,sr.oga04,
                                 sr.oga14,l_gen02,sr.occ02,l_addr1,
                                 l_addr2,l_addr3,sr.ogb03,sr.ogb04,l_donum,
                                 sr.ogb12,sr.ogb05,l_ima02,l_weight,sr.ogb19,
                                 l_ima021,l_note,l_str3,sr.ogb11,
                                 l_oga09,sr.oaydesc,flag,sr.ogb07,l_count    #FUN-740057 add   #No.FUN-860026  add flag  #FUN-A80088 add sr.ogb07,l_count
                                 ,"",  l_img_blob,"N",""   #FUN-C50008 add ',"",  l_img_blob,"N",""'簽核欄位
     #OUTPUT TO REPORT axmg601_rep(sr.*)  #No.FUN-710090 mark
#FUN-C70051-----ADD----STR----
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr.ogb04
      IF l_ima151='Y' AND tm.i='Y' AND sr.ogb12>0 THEN
         LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",sr.ogb04,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",sr.ogb04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_sr2_pre FROM l_sql
           DECLARE g410_slk_sr2_cs CURSOR FOR g410_slk_sr2_pre 
           LET l_imx02 = NULL 
           INITIALIZE l_imx_t.* TO NULL
           LET l_i = 1
           FOR l_i = 1 TO 15
               LET l_imx[l_i].imx01 =NULL
           END FOR
           LET l_i = 1
           FOREACH g410_slk_sr2_cs INTO l_imx02,l_agd04
              LET l_imx[l_i].imx01=' '  
              SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
               WHERE agd01 = ima941 AND agd02 = l_imx02 
                 AND ima01 = sr.ogb04 
              LET l_i = l_i + 1
           END FOREACH 
           FOR l_i = 1 TO 15 
              IF cl_null(l_imx[l_i].imx01) THEN
                 LET l_imx[l_i].imx01 = ' '
              END IF
           END FOR 
           LET l_imx_t.agd03_1 = l_imx[1].imx01
           LET l_imx_t.agd03_2 = l_imx[2].imx01
           LET l_imx_t.agd03_3 = l_imx[3].imx01
           LET l_imx_t.agd03_4 = l_imx[4].imx01
           LET l_imx_t.agd03_5 = l_imx[5].imx01
           LET l_imx_t.agd03_6 = l_imx[6].imx01
           LET l_imx_t.agd03_7 = l_imx[7].imx01
           LET l_imx_t.agd03_8 = l_imx[8].imx01
           LET l_imx_t.agd03_9 = l_imx[9].imx01
           LET l_imx_t.agd03_10 = l_imx[10].imx01
           LET l_imx_t.agd03_11 = l_imx[11].imx01
           LET l_imx_t.agd03_12 = l_imx[12].imx01
           LET l_imx_t.agd03_13 = l_imx[13].imx01
           LET l_imx_t.agd03_14 = l_imx[14].imx01
           LET l_imx_t.agd03_15 = l_imx[15].imx01
           EXECUTE insert_prep5 USING 
           l_imx_t.*,sr.ogb04
#子報表2
           LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
                " WHERE imx00 = '",sr.ogb04,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",sr.ogb04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_colslk_pre FROM l_sql
           DECLARE g410_slk_colslk_cs CURSOR FOR g410_slk_colslk_pre
           LET l_imx01 = NULL

           FOREACH g410_slk_colslk_cs INTO l_imx01,l_agd04
              SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
               WHERE agd01 = ima940 AND agd02 = l_imx01
                 AND ima01 = sr.ogb04 
   
              LET l_sql2 = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
                   " WHERE imx00 = '",sr.ogb04,"'",
                   "   AND imx02=agd02",
                   "   AND agd01 IN ",
                   " (SELECT ima941 FROM ima_file WHERE ima01='",sr.ogb04,"')",
                   " ORDER BY agd04"
              PREPARE g410_slk_sr3_pre FROM l_sql2
              DECLARE g410_slk_sr3_cs CURSOR FOR g410_slk_sr3_pre
              LET l_imx02 = NULL
              LET l_i = 1
              FOR l_i = 1 TO 15
                 LET l_num[l_i].number =NULL
              END FOR
              LET l_i = 1
              FOREACH g410_slk_sr3_cs INTO l_imx02,l_agd04
                 LET l_imx[l_i].imx01=' '
                 SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
                  WHERE agd01 = ima941 AND agd02 = l_imx02
                    AND ima01 = sr.ogb04
          
                 SELECT sma46 INTO l_ps FROM sma_file
                 IF cl_null(l_ps) THEN LET l_ps = ' ' END IF
                 LET l_ima01 = sr.ogb04,l_ps,l_imx01,l_ps,l_imx02
                 SELECT count(*) INTO l_n FROM ogb_file WHERE ogb01=sr.oga01 AND ogb04=l_ima01
                 IF l_n>0 THEN
                    SELECT ogb12 INTO l_num[l_i].number
                      FROM ogb_file,ogbslk_file,ogbi_file 
                     WHERE ogb01=ogbi01 AND ogb03=ogbi03
                       AND ogbslk01=ogbi01 AND ogbislk02=sr.ogb03
                       AND ogb01=sr.oga01 AND ogb04=l_ima01
                 ELSE
                    LET l_num[l_i].number=0
                 END IF     
                 LET l_i=l_i+1   
                 LET l_imx02=null 
              END FOREACH
              LET l_num_t.number1=l_num[1].number
              LET l_num_t.number2=l_num[2].number
              LET l_num_t.number3=l_num[3].number
              LET l_num_t.number4=l_num[4].number
              LET l_num_t.number5=l_num[5].number
              LET l_num_t.number6=l_num[6].number
              LET l_num_t.number7=l_num[7].number 
              LET l_num_t.number8=l_num[8].number
              LET l_num_t.number9=l_num[9].number
              LET l_num_t.number10=l_num[10].number
              LET l_num_t.number11=l_num[11].number
              LET l_num_t.number12=l_num[12].number 
              LET l_num_t.number13=l_num[13].number
              LET l_num_t.number14=l_num[14].number
              LET l_num_t.number15=l_num[15].number
              IF cl_null(l_num_t.number1) THEN LET l_num_t.number1=0 END IF
              IF cl_null(l_num_t.number2) THEN LET l_num_t.number2=0 END IF
              IF cl_null(l_num_t.number3) THEN LET l_num_t.number3=0 END IF
              IF cl_null(l_num_t.number4) THEN LET l_num_t.number4=0 END IF
              IF cl_null(l_num_t.number5) THEN LET l_num_t.number5=0 END IF
              IF cl_null(l_num_t.number6) THEN LET l_num_t.number6=0 END IF
              IF cl_null(l_num_t.number7) THEN LET l_num_t.number7=0 END IF
              IF cl_null(l_num_t.number8) THEN LET l_num_t.number8=0 END IF
              IF cl_null(l_num_t.number9) THEN LET l_num_t.number9=0 END IF
              IF cl_null(l_num_t.number10) THEN LET l_num_t.number10=0 END IF
              IF cl_null(l_num_t.number11) THEN LET l_num_t.number11=0 END IF
              IF cl_null(l_num_t.number12) THEN LET l_num_t.number12=0 END IF
              IF cl_null(l_num_t.number13) THEN LET l_num_t.number13=0 END IF
              IF cl_null(l_num_t.number14) THEN LET l_num_t.number14=0 END IF
              IF cl_null(l_num_t.number15) THEN LET l_num_t.number15=0 END IF
              IF  l_num_t.number1=0 AND l_num_t.number2=0 AND
              l_num_t.number3=0 AND l_num_t.number4=0 AND
              l_num_t.number5=0 AND l_num_t.number6=0 AND 
              l_num_t.number7=0 AND
              l_num_t.number8=0 AND
              l_num_t.number9=0 AND
              l_num_t.number10=0 AND 
              l_num_t.number11=0 AND
              l_num_t.number12=0 AND
              l_num_t.number13=0 AND
              l_num_t.number14=0 AND
              l_num_t.number15=0 THEN
                 CONTINUE FOREACH
              ELSE 
                 EXECUTE insert_prep6 USING 
              l_imx01,l_num_t.*,sr.oga01,sr.ogb03,sr.ogb04
              END IF
           END FOREACH 
        END IF
#FUN-C70051------ADD----END----     
   END FOREACH
 
  #str FUN-740057 mark   #報表轉CR後g_x不用了,直接去CR組這個字串
  #IF l_oga09 = '7' THEN
  #   LET g_str = sr.oaydesc CLIPPED," ",g_x[26]
  #ELSE
  #   IF l_oga09 = '8' THEN
  #      LET g_str = sr.oaydesc CLIPPED," ",g_x[27]
  #   ELSE
  #   	 LET g_str = sr.oaydesc CLIPPED," ",g_x[1]
  #   END IF
  #END IF
  #end FUN-740057 mark
  
   LET g_str = '1' 
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'oga01,oga02')                                            
      RETURNING tm.wc 
   ELSE
      LET tm.wc = ''
   END IF 
   LET g_str = g_str CLIPPED,";",tm.wc
   LET g_str = g_str CLIPPED,";",tm.c,";",tm.d,";",l_oaz23 CLIPPED,";",l_oga09
#   LET g_str = g_str ,";",tm.e,";",tm.f,";",l_zo12   #FUN-740057 add #No.FUN-860026
 
###GENGRE###   LET g_str = g_str ,";",tm.e,";",tm.f,";",l_zo12,";",tm.g,";",tm.h   #FUN-740057 add  #No.FUN-860026  #FUN-A80088 add tm.h
   LET g_msg=NULL
   IF g_oaz.oaz141 = "1" THEN
      CALL s_ccc_logerr() #FUN-650020
      LET g_oga01=sr.oga01 #FUN-650020
      CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
      IF g601_err_ana(g_showmsg) THEN
         
      END IF
      IF g_errno = 'N' THEN
         CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
      END IF
   END IF
#No.FUN-860026---begin
#   LET g_sql1= " SELECT A.*,B.i1,B.loc,B.ogc16,C.i2,C.ogc17,C.ogc12,C.ima02t ",
# #TQC-730088## "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
#               "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A, ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B, ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
#               " WHERE A.oga01 = B.ogc01(+)",
#               " AND A.oga01 = C.ogc01(+)"
###GENGRE###  LET g_sql1= " SELECT A.*,B.i1,B.loc,B.ogc16,C.i2,C.ogc17,C.ogc12,C.ima02t ",
###GENGRE###"   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.oga01 = B.ogc01 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON A.oga01 = C.ogc01 | ",
###GENGRE###               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED ,"|",
###GENGRE###               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED       #No.FUN-A80088 add
#No.FUN-860026---end
 # CALL cl_prt_cs3('axmg601',g_sql1,g_str)      #TQC-730088
###GENGRE###   CALL cl_prt_cs3('axmg601','axmg601',g_sql1,g_str)    
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "oga01"    # No.FUN-C40020 add
#FUN-C70051-----ADD-----STR----
    IF s_industry('slk') AND g_azw.azw04='2' AND tm.i='Y' THEN
       LET g_template="axmg601_slk"
       CALL axmg601_slk_grdata()
    ELSE   
       LET g_template="axmg601"
#FUN-C70051-----ADD-----END----- 
       CALL axmg601_grdata()    ###GENGRE###
    END IF                     #FUN-C70051-----ADD-----
  #FINISH REPORT axmg601_rep   #No.FUN-710090 mark
  #No.FUN-710090--end--
 
   #FUN-650020...............begin
   IF g_show_msg.getlength()>0 THEN
      CALL cl_get_feldname("oga01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("oga03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
   END IF
   #FUN-650020...............end
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710090 mark
 
END FUNCTION
 
#No.FUN-710090--begin-- mark
#REPORT axmg601_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr           RECORD
#                          oga01     LIKE oga_file.oga01,
#                          oaydesc   LIKE oay_file.oaydesc,
#                          oga02     LIKE oga_file.oga02,
#                          oga021    LIKE oga_file.oga021,
#                          oga011    LIKE oga_file.oga011,
#                          oga14     LIKE oga_file.oga14,
#                          oga15     LIKE oga_file.oga15,
#                          oga16     LIKE oga_file.oga16,
#                          oga032    LIKE oga_file.oga032,
#                          oga03     LIKE oga_file.oga03,
#                          oga033    LIKE oga_file.oga033,  #統一編號
#                          oga45     LIKE oga_file.oga45,   #聯絡人
#                          occ02     LIKE occ_file.occ02,
#                          oga04     LIKE oga_file.oga04,
#                          oga044    LIKE oga_file.oga044,
#                          ogb03     LIKE ogb_file.ogb03,
#                          ogb31     LIKE ogb_file.ogb31,
#                          ogb32     LIKE ogb_file.ogb32,
#                          ogb04     LIKE ogb_file.ogb04,
#                          ogb092    LIKE ogb_file.ogb092,
#                          ogb05     LIKE ogb_file.ogb05,
#                          ogb12     LIKE ogb_file.ogb12,
#                          ogb06     LIKE ogb_file.ogb06,
#                          ogb11     LIKE ogb_file.ogb11,
#                          ogb17     LIKE ogb_file.ogb17,
#                          ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
#                          ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
#                          ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
#                          ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
#                          ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
#                          ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
#                          ima18     LIKE ima_file.ima18
#                       END RECORD,
#            l_ogc      RECORD
#                          ogc09     LIKE ogc_file.ogc09,
#                          ogc091    LIKE ogc_file.ogc091,
#                          ogc16     LIKE ogc_file.ogc16,
#                          ogc092    LIKE ogc_file.ogc092
#                       END RECORD,
#           #MOD-680081-begin
#           #l_buf      ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)
#           #l_buf3     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
#           #l_buf4     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
#           #l_buf2     ARRAY[10] OF LIKE ogc_file.ogc16,
#            l_buf   DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf3  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf4  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf2  DYNAMIC  ARRAY OF LIKE ogc_file.ogc16,
#           #MOD-680081-end
#            l_flag     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
#            l_addr1    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_addr2    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_addr3    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_gen02    LIKE gen_file.gen02,
#            l_oag02    LIKE oag_file.oag02,
#            l_gem02    LIKE gem_file.gem02,
#            l_ogb12    LIKE ogb_file.ogb12,
#            l_sql      LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(1000)
#            i,j,l_n    LIKE type_file.num5        #No.FUN-680137 SMALLINT
##No.FUN-580004--begin
#   DEFINE  l_ogb915    STRING
#   DEFINE  l_ogb912    STRING
#   DEFINE  l_str2      STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
#   DEFINE  l_ima021    LIKE ima_file.ima021 #TQC-5B0127
##No.FUN-580004--end
#   DEFINE  l_oga09     LIKE oga_file.oga09
#   DEFINE  l_ogb       RECORD LIKE ogb_file.*
##No.FUN-5C0075--begin
# DEFINE
##     g_ogg        RECORD
##                  ogg10 LIKE ogg_file.ogg10,
##                  ogg12 LIKE ogg_file.ogg12,
##                  ogg17 LIKE ogg_file.ogg17
##             END RECORD,
#      g_ogc        RECORD
#                   ogc12 LIKE ogc_file.ogc12,
#                   ogc17 LIKE ogc_file.ogc17
#              END RECORD,
#      l_oaz23  LIKE oaz_file.oaz23,
#      l_ima02  LIKE ima_file.ima02,
#      g_sql    LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
##No.FUN-5C0075--end
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 5
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.oga01,sr.ogb03
#
#   FORMAT
#      PAGE HEADER
#         LET g_pageno= g_pageno+1
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED           #No.FUN-580004
#         PRINT g_x[11] CLIPPED,sr.oga01 CLIPPED,
#               COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#         #No.FUN-610020  -Begin
#         SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
#         IF l_oga09 = '7' THEN
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[26]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[26]
#         ELSE
#            IF l_oga09 = '8' THEN
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[27]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[27]
#            ELSE
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[1]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[1]
#            END IF
#         END IF
#         #No.FUN-610020  -End
#         LET g_msg=NULL
#         IF g_oaz.oaz141 = "1" THEN
#            CALL s_ccc_logerr() #FUN-650020
#            LET g_oga01=sr.oga01 #FUN-650020
#            CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
#            #FUN-650020...............begin
#            IF g601_err_ana(g_showmsg) THEN
#               
#            END IF
#            #FUN-650020...............end
#            IF g_errno = 'N' THEN
#               CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
#            END IF
#         END IF
#         PRINT g_msg CLIPPED
#         LET l_last_sw = 'n'                    #FUN-550127
#
#      BEFORE GROUP OF sr.oga01
#         SKIP TO TOP OF PAGE
#
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#         IF STATUS THEN
#            LET l_gen02 = ''
#         END IF
#
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#         IF STATUS THEN
#            LET l_gem02 = ''
#         END IF
#
#         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
#              RETURNING l_addr1,l_addr2,l_addr3
#         IF SQLCA.SQLCODE THEN
#            LET l_addr1 = ''
#            LET l_addr2 = ''
#            LET l_addr3 = ''
#         END IF
#
#         PRINT g_x[12] CLIPPED,sr.oga02 CLIPPED,
#               COLUMN 28,g_x[13] CLIPPED,sr.oga032 CLIPPED,sr.oga033 CLIPPED, ##TQC-5B0110&051112 ##
#               sr.oga45 CLIPPED,##sr.oga032 CLIPPED,
#               COLUMN 71,'(',sr.oga03 CLIPPED,')'
#         PRINT g_x[14] CLIPPED,sr.oga021,
#               COLUMN 28,g_x[15] CLIPPED,sr.occ02 CLIPPED, ##TQC-5B0110&051112 ##
#               COLUMN 71,'(',sr.oga04 CLIPPED,')'
#         PRINT g_x[16] CLIPPED,sr.oga011,
#               COLUMN 28,g_x[17] CLIPPED,l_addr1 ##TQC-5B0110&051112 ##
#         PRINT g_x[18] CLIPPED,sr.oga16,
#               COLUMN 35,l_addr2
#         PRINT g_x[19] CLIPPED,l_gen02 CLIPPED,
#               COLUMN 28,g_x[20] CLIPPED,l_gem02 CLIPPED, #MOD-560074 19->26 ##TQC-5B0110&051112 ##
#               COLUMN 35,l_addr3
#
#         IF tm.b = 'Y'  THEN     #列印備註於表頭
#            CALL g601_oao(sr.oga01,0,'1')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n]  CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
#
#         PRINT g_dash[1,g_len]
##no.FUN-550070-begin
##no.FUN-580004--begin
#         #FUN-650005...............begin
#         #FUN-5A0143 add
#         #PRINTX name = H1 g_x[31],g_x[32],g_x[35],g_x[36],g_x[38],g_x[40]
#         #PRINTX name = H2 g_x[39],g_x[51],g_x[37],g_x[47],g_x[48],g_x[52]    #No.FUN-5C0075
#         #PRINTX name = H3 g_x[43],g_x[33],g_x[34]
#         #PRINTX name = H4 g_x[50],g_x[41]
#         #FUN-5A0143 end
#         PRINTX name = H1 g_x[31],g_x[32],g_x[52],g_x[35],g_x[36],g_x[40]
#         PRINTX name = H2 g_x[39],g_x[33],g_x[34]
#         PRINTX name = H3 g_x[43],g_x[41]
#         PRINTX name = H4 g_x[50],g_x[51]
#        #FUN-690032 --begin
#         PRINTX name = H5 g_x[55],g_x[56]
#        #H5->H6 
#        #PRINTX name = H5 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
#         PRINTX name = H6 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
#        #FUN-690032 --end 
#        #FUN-650005...............end
#         PRINT g_dash1
##no.FUN-580004--end
#
#      ON EVERY ROW
#        #MOD-680081-begin-add
#         #FOR i = 1 TO 10
#         #    INITIALIZE l_buf[i]  TO NULL
#         #    INITIALIZE l_buf2[i] TO NULL
#         #    INITIALIZE l_buf3[i] TO NULL   #FUN-5A0143 add
#         #    INITIALIZE l_buf4[i]  TO NULL  #FUN-5A0143 add
#         #END FOR
#          CALL l_buf.clear()
#          CALL l_buf2.clear()
#          CALL l_buf3.clear()
#          CALL l_buf4.clear()
#        #MOD-680081-end-add
#
#         IF tm.a ='1' THEN
#            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
#               WHEN 'Y'
#                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
#                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
#               WHEN 'N'
#                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
#                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
#            END CASE
#         ELSE
#            LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
#                      " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
#                      "   AND img10 > 0 "
#         END IF
#
#         PREPARE g601_p2 FROM l_sql
#         DECLARE g601_c2 CURSOR FOR g601_p2
#         #FUN-650005...............begin  #本段移到下面去做
#         #LET i = 1
#         #FOREACH g601_c2 INTO l_ogc.*
#         #   IF STATUS THEN EXIT FOREACH END IF
#         #   LET l_buf[i][ 1,10]=l_ogc.ogc09  #FUN-5A0143 add
#         #   LET l_buf3[i]=l_ogc.ogc091       #FUN-5A0143add
#         #   LET l_buf4[i]=l_ogc.ogc092       #FUN-5A0143add
#         #   LET l_buf2[i]=l_ogc.ogc16
#         #   LET i=i+1
#         #   IF i > 10 THEN LET i=10 EXIT FOREACH END IF
#         #END FOREACH
#         #FUN-650005...............end
#         IF tm.b = 'Y'  THEN     #列印備註於單身前
#            CALL g601_oao(sr.oga01,sr.ogb03,'1')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n]  CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
##TQC-5B0127--add
#
#      SELECT ima02,ima021,ima906 #FUN-650005 add ima02
#        INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
#        FROM ima_file
#       WHERE ima01=sr.ogb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                   END IF
#                  END IF
#            WHEN "3"
#                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
#            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
#               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
#               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
#            END IF
#      END IF
##TQC-5B0127--end
#
##no.FUN-570176--start--
##no.FUN-580004--begin
#         #FUN-5A0143 add
#         PRINTX name = D1
#               #FUN-650005...............begin
#               #COLUMN g_c[31],sr.ogb03 USING '####',
#               #COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
#               #COLUMN g_c[35],sr.ogb05,
#               #COLUMN g_c[36],sr.ogb12 USING '###,###,##&.###',
#               #COLUMN g_c[38],l_buf2[1] USING '###,###,##&.###',
#               #COLUMN g_c[40],sr.ima18*sr.ogb12 USING '#####.###'
#               COLUMN g_c[31],cl_numfor(sr.ogb03,31,0),
#               COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
#               COLUMN g_c[52],sr.ogb19,
#               COLUMN g_c[35],sr.ogb05,
#               COLUMN g_c[36],cl_numfor(sr.ogb12,36,3),
#               COLUMN g_c[40],cl_numfor(sr.ima18*sr.ogb12,40,3)
#               #FUN-650005...............end
#         #FUN-5A0143 end
#         #FUN-5A0143 add
#         PRINTX name = D2
#               #FUN-650005...............begin
#               #COLUMN g_c[39], '',
#               #COLUMN g_c[37],l_buf[1] CLIPPED,
#               #COLUMN g_c[47],l_buf3[1] CLIPPED,
#               #COLUMN g_c[48],l_buf4[1] CLIPPED,
#               #COLUMN g_c[52],sr.ogb19
#                COLUMN g_c[33],sr.ogb04 CLIPPED,
#                COLUMN g_c[34],l_str2 CLIPPED
#               #FUN-650005...............end
#         #FUN-5A0143 end
#         #FUN-5A0143 add
#         PRINTX name = D3
#              #FUN-650005...............begin
#              #COLUMN g_c[33],sr.ogb04 CLIPPED,
#              #COLUMN g_c[34],l_str2 CLIPPED
#               COLUMN g_c[41],l_ima02 CLIPPED
#              #FUN-650005...............end
#         PRINTX name = D4
#              #FUN-650005...............begin
#              #COLUMN g_c[41],sr.ogb06 CLIPPED
#              COLUMN g_c[51],l_ima021 CLIPPED
#              #FUN-650005...............end
#
#         PRINTX name = D5 COLUMN g_c[56],sr.ogb11 CLIPPED  #FUN-690032 add
#
#         #FUN-650005...............begin     
#         #FOR j = 3 TO i
#         #    PRINTX name = D2
#         #          COLUMN g_c[37],l_buf[j] CLIPPED,
#         #          COLUMN g_c[47],l_buf3[j] CLIPPED,
#         #          COLUMN g_c[48],l_buf4[j] CLIPPED
#         #    PRINTX name = D1
#         #          COLUMN g_c[38],l_buf2[j] USING '###,###,##&.###'
#         ##FUN-5A0143 end
#         #END FOR
#          LET i=0
#          FOREACH g601_c2 INTO l_ogc.*
#             IF STATUS THEN EXIT FOREACH END IF
#            
#            #FUN-690032 D5->D6
#            #PRINTX name = D5
#             PRINTX name = D6
#                   COLUMN g_c[37],l_ogc.ogc09,
#                   COLUMN g_c[47],l_ogc.ogc091,
#                   COLUMN g_c[48],l_ogc.ogc092,
#                   COLUMN g_c[38],cl_numfor(l_ogc.ogc16,38,3)
#             LET i=i+1
#            #IF i > 10 THEN LET i=10 EXIT FOREACH END IF   #MOD-680081 add
#          END FOREACH         
#         #FUN-650005...............end
##no.FUN-580004--end
#         #No.FUN-610020  --Begin 打印客戶驗退數量
#         IF l_oga09 = '8' THEN
#            SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
#             WHERE oga01 = ogb01 AND oga011 = sr.oga011
#               AND ogb03 = sr.ogb03 AND oga09 = '9'
#            IF SQLCA.sqlcode = 0 THEN
#               IF g_sma115 = "Y" THEN
#                  CASE l_ima906
#                     WHEN "2"
#                         CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
#                         LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
#                         IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
#                             CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
#                             LET l_str2 = l_ogb912, l_ogb.ogb910 CLIPPED
#                         ELSE
#                            IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
#                               CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
#                               LET l_str2 = l_str2 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
#                            END IF
#                           END IF
#                     WHEN "3"
#                         IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
#                             CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
#                             LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
#                         END IF
#                  END CASE
#               END IF
#               IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
#                    #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
#                     IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
#                        CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
#                        LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
#                     END IF
#               END IF
#               LET l_str2=l_str2 CLIPPED,(21-LENGTH(l_str2 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
#               PRINTX name = D3
#                     COLUMN g_c[33],g_x[28] CLIPPED,
#                     COLUMN g_c[34],l_str2 CLIPPED
#               PRINTX name = D2
#                     COLUMN g_c[37],l_ogb.ogb09,
#                     COLUMN g_c[47],l_ogb.ogb091,
#                     COLUMN g_c[48],l_ogb.ogb092
#            END IF
#         END IF
#         #No.FUN-610020  --End
#
##No.FUN-5C0075--begin
#            SELECT oaz23 INTO l_oaz23 FROM oaz_file
#            IF l_oaz23 = 'Y' AND tm.c = 'Y' THEN
#              PRINTX name = S1
#                    COLUMN g_c[32],g_x[23],
#                    COLUMN g_c[36],g_x[24]
#            END IF
#            IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
#               LET g_sql = "SELECT ogc12,ogc17 ",
#                           "  FROM ogc_file",
#                           " WHERE ogc01 = '",sr.oga01,"'"
#            PREPARE ogc_prepare FROM g_sql
#            DECLARE ogc_cs CURSOR FOR ogc_prepare
#            FOREACH ogc_cs INTO g_ogc.*
#               SELECT ima02 INTO l_ima02 FROM ima_file
#                WHERE ima01 = g_ogc.ogc17
#               PRINTX name = D1
#                     COLUMN g_c[32],g_ogc.ogc17,
#                     COLUMN g_c[36],g_ogc.ogc12 USING '###,###,##&.###'
#               PRINTX name = D1
#                     COLUMN g_c[32],l_ima02
#            END FOREACH
#            END IF
##No.FUN-5C0075--end
##no.FUN-570176--end--
#         IF tm.b = 'Y'  THEN     #列印備註於單身後
#            CALL g601_oao(sr.oga01,sr.ogb03,'2')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n] CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
#
#      AFTER GROUP OF sr.oga01
#         LET l_ogb12= GROUP SUM(sr.ogb12)
##no.FUN-580004--begin
#         #PRINT  COLUMN g_c[36],'---------------',COLUMN g_c[40],'--------------------' #FUN-650005
#         #PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],COLUMN g_c[40],g_dash2[1,g_w[40]] #FUN-650005
##no.FUN-570176--start--
#         #FUN-5A0143 add
#         PRINTX name = D1 COLUMN g_c[35],g_x[21] CLIPPED,
#                          COLUMN g_c[36],l_ogb12 USING '###,###,##&.###',
#                          COLUMN g_c[40]-7,g_x[22] ClIPPED,
#                          COLUMN g_c[40],GROUP SUM(sr.ima18*sr.ogb12) USING '#####.###';
#         #FUN-5A0143 end
##no.FUN-580004--end
##no.FUN-570176--end--
##no.FUN-550070-end
# 
#         PRINT ''
#         IF tm.b = 'Y'  THEN     #列印備註於表尾
#            CALL g601_oao(sr.oga01,0,'2')
#            FOR l_n = 1 TO 40
#                IF NOT cl_null(g_m[l_n]) THEN
#                   PRINT g_m[l_n] CLIPPED
#                ELSE
#                   LET l_n = 40
#                END IF
#            END FOR
#         END IF
### FUN-550127
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
##     PRINT g_x[4] CLIPPED,COLUMN 41,g_x[5]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#         ELSE
#            PRINT
#            PRINT
#         END IF
#      ELSE
#         PRINT g_x[4]
#         PRINT g_memo
#      END IF
### END FUN-550127
#
#END REPORT
#No.FUN-710090--end-- mark
 
FUNCTION g601_oao(l_p1,l_p3,l_p5)
   DEFINE l_p1   LIKE oao_file.oao01,
          l_p3   LIKE oao_file.oao03,
          l_p5   LIKE oao_file.oao05,
          l_n    LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   FOR l_n = 1 TO 40
      LET g_m[l_n] = ''
   END FOR
 
   DECLARE g601_c5 CURSOR FOR SELECT oao06 FROM oao_file
                               WHERE oao01 = l_p1
                                 AND oao03 = l_p3
                                 AND oao05 = l_p5
 
   LET l_n = 1
 
   FOREACH g601_c5 INTO g_m[l_n]
      LET l_n = l_n + 1
   END FOREACH
 
END FUNCTION
 
FUNCTION g601_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oga03    LIKE oga_file.oga03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oga03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oga03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oga01   = g_oga01
   LET g_show_msg[li_newerrno].oga03   = lc_oga03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#Patch....NO.TQC-610037 <> #

###GENGRE###START
FUNCTION axmg601_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg601")
        IF handler IS NOT NULL THEN
            START REPORT axmg601_rep TO XML HANDLER handler
          #  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-B40087 mark
            LET l_sql = "SELECT A.*,B.*,C.* ",
                        "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN 
                        ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " B ON A.oga01 = B.ogc01 AND A.ogb03 = B.ogc03 LEFT OUTER JOIN ",#FUN-C10036 add AND A.ogb03 = B.ogc03
                         g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON A.oga01 = C.ogc01 ",     #FUN-B40087 add
                        " ORDER BY oga01,ogb03"             #FUN-B40087 add
          
            DECLARE axmg601_datacur1 CURSOR FROM l_sql
            FOREACH axmg601_datacur1 INTO sr1.*,sr2.*,sr3.*
                OUTPUT TO REPORT axmg601_rep(sr1.*,sr2.*,sr3.*)
            END FOREACH
            FINISH REPORT axmg601_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg601_rep(sr1,sr2,sr3)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE l_lineno      LIKE type_file.num5
    #FUN-B40087--------add--------str----
    DEFINE l_gem021      STRING
    DEFINE l_gen02       STRING
    DEFINE l_occ021      STRING
    DEFINE l_oga0321     STRING
    DEFINE l_sum_weigh   LIKE ogb_file.ogb12 
    DEFINE l_sum_ogb12   LIKE ogb_file.ogb12
    DEFINE l_sql         STRING
    DEFINE l_oaz23       LIKE oaz_file.oaz23
    DEFINE l_oga09       LIKE oga_file.oga09
    DEFINE l_display     STRING
    DEFINE l_title       STRING
    DEFINE l_zo12        LIKE zo_file.zo12
    DEFINE l_flag        LIKE type_file.num5
    #FUN-B40087--------add--------end----
    #FUN-C70051----ADD---STR---
    DEFINE l_display1     LIKE type_file.chr1
    DEFINE sr6   sr6_t
    DEFINE sr7   sr7_t
    DEFINE l_ima151       LIKE ima_file.ima151
    #FUN-C70051----ADD----END----

    
    ORDER EXTERNAL BY sr1.oga01,sr1.ogb03,sr2.i1,sr3.i2
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oga01
            LET l_lineno = 0
            #FUN-B40087--------add--------str----
            SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
            IF cl_null(l_zo12) THEN
               SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
            END IF
            PRINTX l_zo12
            IF sr1.oga09 = "7" THEN
               LET l_title = "Delivery Note - Need Client QC"
            ELSE
               IF sr1.oga09 = "8" THEN
                  LET l_title = "Delivery Note - After Client QC" 
               ELSE
                  LET l_title = "Delivery Note"
               END IF
            END IF
            PRINTX l_title
            LET l_gem021 = sr1.oga15,' ',sr1.gem02
            PRINTX l_gem021
            LET l_gen02 = sr1.oga14,' ',sr1.gen02
            PRINTX l_gen02
            LET l_occ021 = sr1.occ02,'(',sr1.oga04,')'
            PRINTX l_occ021
            LET l_oga0321 = sr1.oga032,' ',sr1.oga033,' ',sr1.oga045,'(',sr1.oga03,')'
            PRINTX l_oga0321
            #FUN-B40087--------add--------end----
        BEFORE GROUP OF sr1.ogb03
            #FUN-B40087--------add--------str----
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE imc01 = '",sr1.ogb04 CLIPPED,"'",
                        "  AND imc02 = '",sr1.ogb07 CLIPPED,"'",
                        "  AND oga01 = '",sr1.oga01 CLIPPED,"'",
                        "  AND ogb03 = ",sr1.ogb03 CLIPPED
            START REPORT axmg601_subrep02
            DECLARE axmg601_repcur2 CURSOR FROM l_sql
            FOREACH axmg601_repcur2 INTO sr5.*
                OUTPUT TO REPORT axmg601_subrep02(sr5.*)
            END FOREACH
            FINISH REPORT axmg601_subrep02
 
            #FUN-B40087--------add--------end----
        BEFORE GROUP OF sr2.i1
        BEFORE GROUP OF sr3.i2
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40087--------add--------str----
            LET l_sql = "SELECT MAX(flag) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE oga01='",sr1.oga01 CLIPPED,"'"
            PREPARE l_prep1 FROM l_sql
            EXECUTE l_prep1 INTO l_flag
            PRINTX l_flag
            #FUN-B40087--------add--------end----

            PRINTX sr1.*
            PRINTX sr2.*
            PRINTX sr3.*

        AFTER GROUP OF sr2.i1
        AFTER GROUP OF sr1.oga01
            #FUN-B40087--------add--------str----
            SELECT oaz23 INTO l_oaz23 FROM oaz_file
            PRINTX l_oaz23
            SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr1.oga01
            IF NOT cl_null(sr3.ogc17) THEN
               IF tm.c = "Y" AND l_oaz23 = "Y" THEN
                  LET l_display = "Y"
               ELSE 
                  LET l_display = "N"
               END IF
            ELSE
               LET l_display = "N"
            END IF
            PRINTX l_display
            LET l_sum_weigh = GROUP SUM(sr1.weight)
            PRINTX l_sum_weigh
            LET l_sum_ogb12 = GROUP SUM(sr1.ogb12)
            PRINTX l_sum_ogb12

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE rvbs01 = '",sr1.oga01 CLIPPED,"'",
                        "   AND rvbs02 =",sr1.ogb03 CLIPPED
            START REPORT axmg601_subrep01
            DECLARE axmg601_repcur1 CURSOR FROM l_sql
            FOREACH axmg601_repcur1 INTO sr4.*
                OUTPUT TO REPORT axmg601_subrep01(sr4.*)
            END FOREACH
            FINISH REPORT axmg601_subrep01
            #FUN-B40087--------add--------end----
        AFTER GROUP OF sr1.ogb03

        
        ON LAST ROW

END REPORT
#FUN-B40087--------add--------str----
#FUN-C70051-----ADD----STR-----
FUNCTION axmg601_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg601")
        IF handler IS NOT NULL THEN
            START REPORT axmg601_slk_rep TO XML HANDLER handler
          #  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-B40087 mark
            LET l_sql = "SELECT A.*,B.*,C.* ",
                        "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN 
                        ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " B ON A.oga01 = B.ogc01 AND A.ogb03 = B.ogc03 LEFT OUTER JOIN ",#FUN-C10036 add AND A.ogb03 = B.ogc03
                         g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON A.oga01 = C.ogc01 ",     #FUN-B40087 add
                        " ORDER BY oga01,ogb03"             #FUN-B40087 add
          
            DECLARE axmg601_slk_datacur1 CURSOR FROM l_sql
            FOREACH axmg601_slk_datacur1 INTO sr1.*,sr2.*,sr3.*
                OUTPUT TO REPORT axmg601_slk_rep(sr1.*,sr2.*,sr3.*)
            END FOREACH
            FINISH REPORT axmg601_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg601_slk_rep(sr1,sr2,sr3)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_gem021      STRING
    DEFINE l_gen02       STRING
    DEFINE l_occ021      STRING
    DEFINE l_oga0321     STRING
    DEFINE l_sum_weigh   LIKE ogb_file.ogb12 
    DEFINE l_sum_ogb12   LIKE ogb_file.ogb12
    DEFINE l_sql         STRING
    DEFINE l_oaz23       LIKE oaz_file.oaz23
    DEFINE l_oga09       LIKE oga_file.oga09
    DEFINE l_display     STRING
    DEFINE l_title       STRING
    DEFINE l_zo12        LIKE zo_file.zo12
    DEFINE l_flag        LIKE type_file.num5
    DEFINE l_display1     LIKE type_file.chr1
    DEFINE sr6   sr6_t
    DEFINE sr7   sr7_t
    DEFINE l_ima151       LIKE ima_file.ima151

    
    ORDER EXTERNAL BY sr1.oga01,sr1.ogb03,sr2.i1,sr3.i2
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oga01
            LET l_lineno = 0
            SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
            IF cl_null(l_zo12) THEN
               SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
            END IF
            PRINTX l_zo12
            IF sr1.oga09 = "7" THEN
               LET l_title = "Delivery Note - Need Client QC"
            ELSE
               IF sr1.oga09 = "8" THEN
                  LET l_title = "Delivery Note - After Client QC" 
               ELSE
                  LET l_title = "Delivery Note"
               END IF
            END IF
            PRINTX l_title
            LET l_gem021 = sr1.oga15,' ',sr1.gem02
            PRINTX l_gem021
            LET l_gen02 = sr1.oga14,' ',sr1.gen02
            PRINTX l_gen02
            LET l_occ021 = sr1.occ02,'(',sr1.oga04,')'
            PRINTX l_occ021
            LET l_oga0321 = sr1.oga032,' ',sr1.oga033,' ',sr1.oga045,'(',sr1.oga03,')'
            PRINTX l_oga0321
        BEFORE GROUP OF sr1.ogb03
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE imc01 = '",sr1.ogb04 CLIPPED,"'",
                        "  AND imc02 = '",sr1.ogb07 CLIPPED,"'",
                        "  AND oga01 = '",sr1.oga01 CLIPPED,"'",
                        "  AND ogb03 = ",sr1.ogb03 CLIPPED
            START REPORT axmg601_subrep02
            DECLARE axmg601_slk_repcur2 CURSOR FROM l_sql
            FOREACH axmg601_slk_repcur2 INTO sr5.*
                OUTPUT TO REPORT axmg601_subrep02(sr5.*)
            END FOREACH
            FINISH REPORT axmg601_subrep02
 
        BEFORE GROUP OF sr2.i1
        BEFORE GROUP OF sr3.i2
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_sql = "SELECT MAX(flag) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE oga01='",sr1.oga01 CLIPPED,"'"
            PREPARE l_slkprep1 FROM l_sql
            EXECUTE l_slkprep1 INTO l_flag
            PRINTX l_flag

            PRINTX sr1.*
            PRINTX sr2.*
            PRINTX sr3.*
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr1.ogb04
            IF tm.i='Y' AND l_ima151='Y' AND sr1.ogb12>0 THEN
               LET l_display1 = 'Y'
            ELSE 
               LET l_display1 = 'N'
            END IF 
            PRINTX l_display1   
            LET l_sql = "SELECT distinct * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE ogbslk04 = '",sr1.ogb04 CLIPPED,"'"
               START REPORT axmg601_subrep05
               DECLARE axmg601_repcur5 CURSOR FROM l_sql
               FOREACH axmg601_repcur5 INTO sr6.*
                  OUTPUT TO REPORT axmg601_subrep05(sr6.*)
               END FOREACH
               FINISH REPORT axmg601_subrep05

#子報表2
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
                        " WHERE ogbslk01 = '",sr1.oga01 CLIPPED,"'",
                        " AND ogbslk03 = ",sr1.ogb03 CLIPPED
               START REPORT axmg601_subrep06
               DECLARE axmg601_repcur6 CURSOR FROM l_sql
               FOREACH axmg601_repcur6 INTO sr7.*
                   OUTPUT TO REPORT axmg601_subrep06(sr7.*,sr6.*)
               END FOREACH
               FINISH REPORT axmg601_subrep06

        AFTER GROUP OF sr2.i1
        AFTER GROUP OF sr1.oga01
            SELECT oaz23 INTO l_oaz23 FROM oaz_file
            PRINTX l_oaz23
            SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr1.oga01
            IF NOT cl_null(sr3.ogc17) THEN
               IF tm.c = "Y" AND l_oaz23 = "Y" THEN
                  LET l_display = "Y"
               ELSE 
                  LET l_display = "N"
               END IF
            ELSE
               LET l_display = "N"
            END IF
            PRINTX l_display
            LET l_sum_weigh = GROUP SUM(sr1.weight)
            PRINTX l_sum_weigh
            LET l_sum_ogb12 = GROUP SUM(sr1.ogb12)
            PRINTX l_sum_ogb12

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE rvbs01 = '",sr1.oga01 CLIPPED,"'",
                        "   AND rvbs02 =",sr1.ogb03 CLIPPED
            START REPORT axmg601_subrep01
            DECLARE axmg601_slk_repcur1 CURSOR FROM l_sql
            FOREACH axmg601_slk_repcur1 INTO sr4.*
                OUTPUT TO REPORT axmg601_subrep01(sr4.*)
            END FOREACH
            FINISH REPORT axmg601_subrep01
        AFTER GROUP OF sr1.ogb03

        
        ON LAST ROW

END REPORT
#FUN-C70051-----ADD----END-----
REPORT axmg601_subrep01(sr4)
    DEFINE sr4 sr4_t
    DEFINE l_sum_rvbs06  LIKE rvbs_file.rvbs06

    ORDER EXTERNAL BY sr4.rvbs02

    FORMAT

        BEFORE GROUP OF sr4.rvbs02

        ON EVERY ROW
            PRINTX sr4.*

        AFTER GROUP OF sr4.rvbs02
            LET l_sum_rvbs06 = GROUP SUM(sr4.rvbs06)
            PRINTX l_sum_rvbs06

END REPORT

REPORT axmg601_subrep02(sr5)
    DEFINE sr5 sr5_t

    FORMAT
        ON EVERY ROW
            PRINTX sr5.*
END REPORT
#FUN-B40087--------add--------end----
#FUN-C70051----ADD----STR---
REPORT axmg601_subrep05(sr6)
    DEFINE sr6 sr6_t

    FORMAT
        ON EVERY ROW
            PRINTX sr6.*

END REPORT
REPORT axmg601_subrep06(sr7,sr6)
    DEFINE sr7 sr7_t
    DEFINE sr6 sr6_t
    DEFINE l_color  LIKE agd_file.agd03

    FORMAT
        ON EVERY ROW
        SELECT agd03 INTO l_color FROM agd_file,ima_file
           WHERE agd01 = ima940 AND agd02 = sr7.imx01
             AND ima01 = sr7.ogbslk04
            PRINTX l_color 
            PRINTX sr7.*
            PRINTX sr6.*   
END REPORT
#FUN-C70051-----ADD----END--
###GENGRE###END
