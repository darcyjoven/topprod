# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: axrq378.4gl
# Descriptions...: 銷貨收入明細查询
# Date & Author..: 98/12/23 By Billy
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能 
# Modify.........: No.FUN-C80092 12/09/27 By fengrui 最大筆數控制與excel導出處理
# Modify.........: No.FUN-C80092 12/10/5  By zm 增加插入明细资料功能以便比对axcq100销货收入差异
# Modify.........: No.FUN-C80102 12/10/15 By lujh 報表改善
# Modify.........: No.FUN-C80092 12/10/19 By fengrui 背景執行處理
# Modify.........: No.TQC-CC0122 12/12/25 By lujh 1、拿掉原幣含稅金額合計  2、未勾選顯示原幣時，單身匯率不顯示  3、明細頁簽排序修改 4、理由碼說明內容未帶出
# Modify.........: No.MOD-D20096 13/02/20 By yinhy 臨時表axrq3781缺少plant字段，抓取ccz資料時sql錯誤
# Modify.........: No.FUN-D20032 13/02/25 By wujie  1：抓ccc92/ccc91时，case ccc91=0 then 0改为then ccc23                                                 
#                                                   2：汇总页签的成本单价被累计了，应该算平均值
#                                                   3：汇总页签增加销货数量和销货单价
#                                                      其中销货数量根据单头汇总条件从axrq378_tmp中sum（omb12），单价=本币未税金额/数量，此两个栏位不做隐藏
#                                                   4：当勾选显示成本时，成本计算类型栏位必输
# Modify.........: No.FUN-D30049 13/03/18 By zhangweib 增加字段‘憑證編號’，‘憑證日期’，可下條件查詢
# Modify.........: No.TQC-D60039 13/06/07 By wangrr 1.抓取"部門名稱,員工姓名,品名,規格,說明內容,科目名稱"的值
#                                                   2.顯示畫面最下方的各個匯總值
#                                                   3.當雙擊匯總頁簽中資料顯示到明細頁簽不正確,沒有抓取憑證編號和憑證日期的資
#                                                   4.當點擊匯總頁簽時,畫面最下方的匯總金額應該根據匯總頁簽金額進行匯總
# Modify.........: No.FUN-D50083 13/07/04 By zhuhao 添加'顯示非成本倉'checkbox
# Modify.........: No.FUN-D60043 13/06/08 By yangtt 1.單頭增加選項，是否包含MISC
#                                                   2.如為N,按原邏輯，如為Y,則查OMB中MISC料號，顯示在明細頁簽及匯總頁簽中。


DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm    RECORD                                # Print condition RECORD
                wc      LIKE type_file.chr1000,       # Where condition #No.FUN-680123 VARCHAR(1000)
                bdate   LIKE type_file.dat,           #No.FUN-680123 DATE
                edate   LIKE type_file.dat,           #No.FUN-680123 DATE
                b       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                c       LIKE type_file.chr1,          #CHI-850016
                u       LIKE type_file.chr1,          #FUN-C80102  add
                a       LIKE type_file.chr1,          #FUN-C80102  add
                c1      LIKE type_file.chr1,          #FUN-C80102  add
                d       LIKE type_file.chr1,          #FUN-C80102  add
                e       LIKE type_file.chr1,          #FUN-C80102  add
                f       LIKE type_file.chr1,          #FUN-C80102  add
                g       LIKE type_file.chr20,         #FUN-C80102  add
                c3      LIKE type_file.chr1,          #FUN-D50083  add
                m       LIKE type_file.chr1,          #FUN-D60043  add
                g_auto_gen LIKE type_file.chr1,
                plant_1 LIKE azw_file.azw01,
                plant_2 LIKE azw_file.azw01,
                plant_3 LIKE azw_file.azw01,
                plant_4 LIKE azw_file.azw01,
                plant_5 LIKE azw_file.azw01,
                plant_6 LIKE azw_file.azw01,
                plant_7 LIKE azw_file.azw01,
                plant_8 LIKE azw_file.azw01
                END RECORD
   DEFINE g_ckk RECORD LIKE ckk_file.*
   DEFINE g_omb DYNAMIC ARRAY OF RECORD
#FUN-C80120--mod--str---
#               omb03   LIKE omb_file.omb03,
#               omb04   LIKE omb_file.omb04,
#               omb06   LIKE omb_file.omb06,
#               omb12   LIKE omb_file.omb12,
#               omb05   LIKE omb_file.omb05,
#               oma23   LIKE oma_file.oma23,
#               oma24   LIKE oma_file.oma24,
#               omb13   LIKE omb_file.omb13,
#               omb14t  LIKE omb_file.omb14t,
#               omb15   LIKE omb_file.omb15,
#               omb16t  LIKE omb_file.omb16t,
#               oma03   LIKE oma_file.oma03,
#               oma032  LIKE oma_file.oma032,
#               oma16   LIKE oma_file.oma16,
#               oga02   LIKE oga_file.oga02,
#               oma10   LIKE oma_file.oma10,
#               oma01   LIKE oma_file.oma01,
#               oma08   LIKE oma_file.oma08
                azp01   LIKE azp_file.azp01,
                oma03   LIKE oma_file.oma03,
                oma032  LIKE oma_file.oma032,
                oma68   LIKE oma_file.oma68, 
                oma69   LIKE oma_file.oma69,
                
                oma15   LIKE oma_file.oma15,
                gem02   LIKE gem_file.gem02,
                oma14   LIKE oma_file.oma14,
                gen02   LIKE gen_file.gen02,
                oma25   LIKE oma_file.oma25,

                oma26   LIKE oma_file.oma26,
                omb04   LIKE omb_file.omb04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                oma10   LIKE oma_file.oma10,
                
                oma02   LIKE oma_file.oma02,
                omb38   LIKE omb_file.omb38,
                omb31   LIKE omb_file.omb31,
                omb32   LIKE omb_file.omb32,
                omb40   LIKE omb_file.omb40,
                
                azf03   LIKE azf_file.azf03,
                omb39   LIKE omb_file.omb39,
                oma08   LIKE oma_file.oma08,
                oma33   LIKE oma_file.oma33,   #No.FUN-D30049   Add
                aba02   LIKE aba_file.aba02,   #No.FUN-D30049   Add
                
                oma01   LIKE oma_file.oma01,
                omb03   LIKE omb_file.omb03,
                omb33   LIKE omb_file.omb33,
                aag02   LIKE aag_file.aag02,  
                omb05   LIKE omb_file.omb05,
                
                omb12   LIKE omb_file.omb12,
                oma23   LIKE oma_file.oma23,
                oma24   LIKE oma_file.oma24,
                omb13   LIKE omb_file.omb13,
                omb14   LIKE omb_file.omb14,
                
                omb14t  LIKE omb_file.omb14t,
                oma54x  LIKE oma_file.oma54x,
                omb15   LIKE omb_file.omb15,
                omb16   LIKE omb_file.omb16,
                oma56x  LIKE oma_file.oma56x,
                
                omb16t  LIKE omb_file.omb16t,
                ccc92   LIKE ccc_file.ccc92,
                ccc62   LIKE ccc_file.ccc62,
                s1      LIKE type_file.num20_6,
                s2      LIKE type_file.num20_6,       #yinhy130708
                
                oga02   LIKE  oga_file.oga02,
                oga02a   LIKE  oga_file.oga02   #add by ly170810
                #s2      LIKE type_file.chr20 
#FUN-C80120--mod--end---
                END RECORD,  
#FUN-C80102--add--str---   
   g_omb_1      DYNAMIC ARRAY OF RECORD
                azp01   LIKE azp_file.azp01,
                oma03   LIKE oma_file.oma03,
                oma032  LIKE oma_file.oma032,
                oma68   LIKE oma_file.oma68,
                oma69   LIKE oma_file.oma69,
                oma15   LIKE oma_file.oma15,
                gem02   LIKE gem_file.gem02,
                oma14   LIKE oma_file.oma14,
                gen02   LIKE gen_file.gen02,
                oma25   LIKE oma_file.oma25,
                
                oma26   LIKE oma_file.oma26,
                omb04   LIKE omb_file.omb04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                oma08   LIKE oma_file.oma03,
                omb33   LIKE omb_file.omb33,
                aag02   LIKE aag_file.aag02,
                oma23   LIKE oma_file.oma25,
                omb14   LIKE omb_file.omb14,
                oma54x  LIKE oma_file.oma54x,
                
                omb14t  LIKE omb_file.omb14t,
                omb16   LIKE omb_file.omb16,
#No.FUN-D20032 --begin
                omb12   LIKE omb_file.omb12,
                omb15   LIKE omb_file.omb15,
#No.FUN-D20032 --end
                oma56x  LIKE oma_file.oma56x,
                omb16t  LIKE omb_file.omb16t,
                ccc92   LIKE ccc_file.ccc92,
                ccc62   LIKE ccc_file.ccc62,
                s1      LIKE type_file.num20_6,
                s2      LIKE type_file.num20_6         #yinhy130708
                #s2      LIKE type_file.chr20
                END RECORD,    
#FUN-C80102--add--end---   
   #FUN-C80092--add--str--
   g_omb_excel  DYNAMIC ARRAY OF RECORD
                #FUN-C80102--mark--str---  
                #omb03   LIKE omb_file.omb03,
                #omb04   LIKE omb_file.omb04,
                #omb06   LIKE omb_file.omb06,
                #omb12   LIKE omb_file.omb12,
                #omb05   LIKE omb_file.omb05,
                #oma23   LIKE oma_file.oma23,
                #oma24   LIKE oma_file.oma24,
                #omb13   LIKE omb_file.omb13,
                #omb14t  LIKE omb_file.omb14t,
                #omb15   LIKE omb_file.omb15,
                #omb16t  LIKE omb_file.omb16t,
                #oma03   LIKE oma_file.oma03,
                #oma032  LIKE oma_file.oma032,
                #oma16   LIKE oma_file.oma16,
                #oga02   LIKE oga_file.oga02,
                #oma10   LIKE oma_file.oma10,
                #oma01   LIKE oma_file.oma01,
                #oma08   LIKE oma_file.oma08
                #FUN-C80102--mark--end---  
                azp01   LIKE azp_file.azp01,
                oma03   LIKE oma_file.oma03,
                oma032  LIKE oma_file.oma032,
                oma68   LIKE oma_file.oma68, 
                oma69   LIKE oma_file.oma69, 
                oma15   LIKE oma_file.oma15,
                gem02   LIKE gem_file.gem02,
                oma14   LIKE oma_file.oma14,
                gen02   LIKE gen_file.gen02,
                oma25   LIKE oma_file.oma25,
                oma26   LIKE oma_file.oma26,
                omb04   LIKE omb_file.omb04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                oma10   LIKE oma_file.oma10,
                oma02   LIKE oma_file.oma02,
                omb38   LIKE omb_file.omb38,
                omb31   LIKE omb_file.omb31,
                omb32   LIKE omb_file.omb32,
                omb40   LIKE omb_file.omb40,
                azf03   LIKE azf_file.azf03,
                omb39   LIKE omb_file.omb39,
                oma08   LIKE oma_file.oma08,
                oma33   LIKE oma_file.oma33,   #No.FUN-D30049   Add
                aba02   LIKE aba_file.aba02,   #No.FUN-D30049   Add
                oma01   LIKE oma_file.oma01,
                omb03   LIKE omb_file.omb03,
                omb33   LIKE omb_file.omb33,
                aag02   LIKE aag_file.aag02,  
                omb05   LIKE omb_file.omb05,
                omb12   LIKE omb_file.omb12,
                oma23   LIKE oma_file.oma23,
                oma24   LIKE oma_file.oma24,
                omb13   LIKE omb_file.omb13,
                omb14   LIKE omb_file.omb14,
                omb14t  LIKE omb_file.omb14t,
                oma54x  LIKE oma_file.oma54x,
                omb15   LIKE omb_file.omb15,
                omb16   LIKE omb_file.omb16,
                oma56x  LIKE oma_file.oma56x,
                omb16t  LIKE omb_file.omb16t,
                ccc92   LIKE ccc_file.ccc92,
                ccc62   LIKE ccc_file.ccc62,
                s1      LIKE type_file.num20_6,
                s2      LIKE type_file.num20_6,   #yinhy130708
                oga02   LIKE oga_file.oga02,       #tianry add 
                oga02a   LIKE oga_file.oga02       # add ly270810  
                #s2      LIKE type_file.chr20 
                END RECORD,   
   #FUN-C80092--add--end--
          g_yy,g_mm     LIKE type_file.num5,                 #No.FUN-680123 SMALLINT
          m_dbs         ARRAY[10] OF LIKE type_file.chr20    #No.FUN-680123 ARRAY[10] OF VARCHAR(20)
   DEFINE   g_title LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(160)
   DEFINE   g_amt   LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
              t_rate  LIKE ima_file.ima18           #No.FUN-680123 DEC(9,3)
                     
DEFINE    g_cnt           LIKE type_file.num10,      #No.FUN-680123 INTEGER
          g_cnt1          LIKE type_file.num10,      #FUN-C80102  add
          g_rec_b         LIKE type_file.num10,      #單身筆數
          g_rec_b2        LIKE type_file.num10,      #單身筆數
          g_num 	  LIKE omb_file.omb12,       #数量
          g_tot1	  LIKE oma_file.oma54t,      #原币金額合計
          g_tot2	  LIKE oma_file.oma54t       #本币金額合計
DEFINE    g_head1         LIKE type_file.chr1000    #Dash line #No.FUN-680123 VARCHAR(100)
DEFINE    g_i             LIKE type_file.num5       #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE    i               LIKE type_file.num5       #No.FUN-680123 SMALLINT
DEFINE    l_table         STRING,                   ### CR11 ###
          g_str           STRING,                   ### CR11 ###
          g_sql           STRING                    ### CR11 ###
DEFINE    l_table1        STRING                    #CHI-B60008
DEFINE    g_order         LIKE type_file.chr100     #CHI-B60008
DEFINE    g_order0        LIKE type_file.chr100     #CHI-B60008
#FUN-BB0173 add START
DEFINE plant   ARRAY[8]  OF LIKE azp_file.azp01
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
           plant      LIKE azw_file.azw01           #plant
           END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1         #記錄是否為流通
DEFINE   g_azw01_1      LIKE azw_file.azw05
DEFINE   g_azw01_2      LIKE azw_file.azw05
#FUN-BB0173 add END
DEFINE   g_cka00        LIKE cka_file.cka00         #FUN-C80092
DEFINE   l_flag         LIKE type_file.chr1
DEFINE   g_bdate        DATE
DEFINE   g_edate        DATE
#FUN-C80102--add--str--
DEFINE   l_ac       LIKE type_file.num5    
DEFINE   l_ac1      LIKE type_file.num5
DEFINE   g_flag1        LIKE type_file.chr1   
DEFINE   g_action_flag  LIKE type_file.chr100 
DEFINE   g_filter_wc    STRING                
DEFINE   g_comb         ui.ComboBox           
DEFINE   g_cmd          LIKE type_file.chr1000 
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
DEFINE   g_wc2     STRING  
DEFINE   l_n       LIKE type_file.num5
#FUN-C80102--add--end--
 
MAIN   
   DEFINE p_row,p_col  LIKE type_file.num5

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   LET p_row = 2 LET p_col = 18
 
   #FUN-C80092--mark--str--
   #OPEN WINDOW q378_w AT p_row,p_col WITH FORM "axr/42f/axrq378"
   #    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   #CALL cl_ui_init()
   #FUN-C80092--mark--end--


   #FUN-C80102--add--str--  
    INITIALIZE tm.* TO NULL
    LET tm.bdate = g_bdate
    LET tm.edate = g_edate
    LET tm.b= 'Y'
    LET tm.g_auto_gen = 'Y'
    LET tm.u = ' '  
    LET tm.a = ' '  
    LET tm.c = 'N'
    LET tm.c1= 'N'
    LET tm.d = 'N'
    #FUN-C80102--add--end--  
    LET tm.c3= 'N'  #FUN-D50083 add
    LET tm.m = 'N'  #FUN-D60043 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/03/06 TSD.Martin  *** ##
   LET g_sql =
       "oma03.oma_file.oma03  ,oma032.oma_file.oma032,", #帳款客戶編號,客戶簡稱
       "omb04.omb_file.omb04  ,occ21.occ_file.occ21,",   #機種(料號)  ,區域(國別)
       "oma01.oma_file.oma01  ,omb03.omb_file.omb03,",   #帳款編號    ,項次
       "omb05.omb_file.omb05  ,omb06.omb_file.omb06,",   #單位        ,品名   #MOD-860260 add omb05
       "omb12.omb_file.omb12  ,omb12_1.omb_file.omb12,", #數量        ,數量
       "omb15.omb_file.omb15  ,omb31.omb_file.omb31,",   #本幣單價    ,出貨單號
       "omb32.omb_file.omb32  ,oma23.oma_file.oma23,",   #出貨單號項次,幣別
       "oma24.oma_file.oma24  ,omb13.omb_file.omb13,",   #匯率        ,原幣單價
       "oma02.oma_file.oma02  ,oma08.oma_file.oma08,",   #立帳日      ,內/外銷
       "omb14t.omb_file.omb14t,omb14.omb_file.omb14,",   #原幣含稅金額,原幣未稅金額
       "omb16t.omb_file.omb16t,omb16.omb_file.omb16,",   #本幣含稅金額,原幣未稅金額
       "oma00.oma_file.oma00  ,oma10.oma_file.oma10,",
       "db.azp_file.azp02     ,l_geb02.geb_file.geb02,",
       "oma16.oma_file.oma16  ,oga02.oga_file.oga02,",   #出货单号   ,出货日期
       "oga02a.oga_file.oga02,",
       "oma161.oma_file.oma161,oma162.oma_file.oma162,", #訂金應收比率,出貨應收比率  #CHI-760014 add 
       "oma163.oma_file.oma163,",                        #尾款應收比率               #CHI-760014 add     
       "azi03.azi_file.azi03  ,azi04.azi_file.azi04,",   #MOD-7B0051
       "azi05.azi_file.azi05  ,azi03_1.azi_file.azi03,", #MOD-7B0051
       "azi04_1.azi_file.azi04,azi05_1.azi_file.azi05,", #MOD-7B0051
       "azi07.azi_file.azi07,",                          #MOD-870260 add
       "plant.azp_file.azp01"                            #No.FUN-8C0019
 
   LET l_table = cl_prt_temptable('axrq378',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #CHI-B60008 
      EXIT PROGRAM 
   END IF                  # Temp Table產生

   LET g_sql =
       "oma03.oma_file.oma03,",
       "oma02.oma_file.oma02,",
       "oma23.oma_file.oma23,",
       "omb04.omb_file.omb04,",
       "omb05.omb_file.omb05,",
       "occ21.occ_file.occ21,",
       "omb12.omb_file.omb12,",
       "omb16_after.omb_file.omb16,",
       "omb14_after.omb_file.omb14,",
       "omb16t_omb16.omb_file.omb16,",
       "azi05.azi_file.azi05,",
       "azi05_1.azi_file.azi05,",
       "plant.azp_file.azp01"      #MOD-D20096
   LET l_table1= cl_prt_temptable('axrq3781',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1= -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   
      EXIT PROGRAM 
   END IF                  # Temp Table產生
  #-CHI-B60008-end-
   #----------------------------------------------------------CR (1) ------------#

   #FUN-C80102--mark--str--
   #DROP TABLE axrq378_tmp    #總計
   #CREATE TEMP TABLE axrq378_tmp
   #  (curr LIKE azi_file.azi01,
   #   amt1 LIKE omb_file.omb12,
   #   amt2 LIKE omb_file.omb15,
   #   amt3 LIKE omb_file.omb13,
   #   amt4 LIKE omb_file.omb12)
   #FUN-C80102--mark--end--
 
   DROP TABLE axrq378_tmp1   #小計
   CREATE TEMP TABLE axrq378_tmp1
     (item LIKE type_file.chr1000,
      curr LIKE azi_file.azi01,
      amt1 LIKE omb_file.omb12,
      amt2 LIKE omb_file.omb15,
      amt3 LIKE omb_file.omb13,
      amt4 LIKE omb_file.omb12)
 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.b = ARG_VAL(10)
   LET tm.c = ARG_VAL(11)
   LET tm.g_auto_gen = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET plant[1] = g_plant
   LET plant[2] = ARG_VAL(16)
   LET plant[3] = ARG_VAL(17)
   LET plant[4] = ARG_VAL(18)
   LET plant[5] = ARG_VAL(19)
   LET plant[6] = ARG_VAL(20)
   LET plant[7] = ARG_VAL(21)
   LET plant[8] = ARG_VAL(22)

   FOR g_i = 1 TO 8
      IF NOT cl_null(plant[g_i])THEN
         CALL chk_plant(plant[g_i]) RETURNING g_azw01_1
         IF NOT cl_null(g_azw01_1) THEN
            IF cl_null(g_azw01_2) THEN
               LET g_azw01_2 = "'",g_azw01_1,"'"
            ELSE
               LET g_azw01_2 = g_azw01_2,"'",g_azw01_1,"'"
            END IF
         END IF
      END IF
   END FOR
   IF NOT cl_null(g_azw01_2) THEN
      CALL q378_legal_db(g_azw01_2)
   END IF

   IF cl_null(g_bgjob) OR g_bgjob='N' THEN                           #FUN-C80092 add
      OPEN WINDOW q378_w AT p_row,p_col WITH FORM "axr/42f/axrq378"  #FUN-C80092 add
         ATTRIBUTE (STYLE = g_win_style CLIPPED)                     #FUN-C80092 add
      CALL cl_ui_init()                                              #FUN-C80092 add
      CALL q378_tm(0,0)  #FUN-C80102
      CALL q378_menu()
   ELSE
      CALL q378()                                                    #FUN-C80092 add
   END IF 

   CLOSE WINDOW q378_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN

FUNCTION q378_menu()
    WHILE TRUE
    #FUN-C80102--add--str-- 
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q378_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q378_bp2()
         END IF
         IF cl_null(g_action_flag) THEN 
            CALL q378_bp("G")
         END IF 
      END IF 
    #FUN-C80102--add--end-- 
      #CALL q378_bp("G")    #FUN-C80102 mark
      CASE g_action_choice

      #FUN-C80102--add--str--
      WHEN "page1"
            CALL q378_bp("G")
         
      WHEN "page2"
            CALL q378_bp2()

      WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q378_filter_askkey()
               CALL q378_show()
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102
            END IF            

      WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q378_show() 
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102
            END IF
      #FUN-C80102--add--end--

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q378_tm(0,0)
            ELSE                          #FUN-C80102
               LET g_action_choice = " "  #FUN-C80102
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-C80102  add
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
            LET g_action_choice = " "  #FUN-C80102  add
         #FUN-C80102--mark--str--
         #WHEN "exporttoexcel"    
         #   IF cl_chk_act_auth() THEN
         #       CALL cl_export_to_excel
         #       (ui.Interface.getRootNode(),base.TypeInfo.create(g_omb_excel),'','')
         #    END IF 
         #FUN-C80102--mark--end-- 
         #FUN-C80102--add--str--  
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   #CALL cl_export_to_excel(page,base.TypeInfo.create(g_omb),'','') 
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_omb_excel),'','') 
                END IF
             END IF 
             IF g_action_flag = "page2" THEN 
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_omb_1),'','') 
                END IF
             END IF 
             LET g_action_choice = " "  
         #FUN-C80102--add--end-- 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q378_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col     LIKE type_file.num5,         #No.FUN-680123 SMALLINT
       l_cmd           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
DEFINE l_n             LIKE type_file.num5          #No.FUN-680123 SMALLINT
#FUN-BB0173 add START
DEFINE  l_cnt          LIKE type_file.num5
DEFINE  l_string       STRING
DEFINE  l_plant        LIKE azw_file.azw01
DEFINE  l_ac           LIKE type_file.num5  
DEFINE l_ccz28         LIKE ccz_file.ccz28    #FUN-C80102 add
#FUN-BB0173 add END
 
   --LET p_row = 2 LET p_col = 18
 --
   --OPEN WINDOW q378_w AT p_row,p_col WITH FORM "axr/42f/axrq378"
       --ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 --
   --CALL cl_ui_init()

   SELECT ccz01,ccz02,ccz28 INTO g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz28 FROM ccz_file 
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,g_bdate,g_edate
 
   CALL cl_opmsg('p')
   CALL q378_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   INITIALIZE tm.* TO NULL                # Default condition
   CLEAR FORM              #FUN-C80102  add
   CALL g_omb.clear()      #FUN-C80102  add
   CALL g_omb_1.clear()    #FUN-C80102  add
   LET tm.bdate = g_bdate
   LET tm.edate = g_edate
   LET tm.u = ' '          
   LET tm.a = '3'
   LET tm.b= 'Y'
   LET tm.g_auto_gen = 'Y'
   LET tm.c = 'N'
   LET tm.c1 = 'N' #FUN-C80102  add
   LET tm.d = 'N'  #FUN-C80102  add
   LET tm.c3 = 'N' #FUN-D50083  add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.m = 'N'   #FUN-D60043 add

   CALL cl_set_comp_entry("c1,e,f,g,c3",FALSE)              #FUN-C80102 add     #FUN-D50083 add c3
   CALL cl_set_comp_visible("oma56x,oma56x_1,omb14tsum",FALSE)          #FUN-C80102 add  #TQC-CC0122  add omb14tsum
   CALL cl_set_comp_visible("oma54x,oma54x_1,omb14t,omb14t_1,omb16t,omb16t_1",FALSE)    #TQC-CC0122  lujh add
   CALL cl_set_comp_visible("azp01",FALSE)         #FUN-C80102 add
   CALL cl_set_act_visible("revert_filter",FALSE)  #FUN-C80102 add
   LET g_comb = ui.ComboBox.forName("u")           #FUN-C80102 add
   CALL g_comb.removeItem('8')                     #FUN-C80102 add

   CALL q378_set_entry_1()
   CALL q378_set_no_entry_1()

 
--WHILE TRUE
      #DISPLAY BY NAME tm.bdate,tm.edate,tm.u,tm.a,tm.b,tm.c,tm.g_auto_gen,tm.org,tm.c1    #FUN-C80102  add
      DIALOG ATTRIBUTE(UNBUFFERED)   #FUN-C80102  add
      #INPUT BY NAME tm.bdate,tm.edate,tm.b,tm.c,tm.g_auto_gen      #FUN-C80102   mark
      #    WITHOUT DEFAULTS                            #FUN-C80102   mark
      INPUT BY NAME tm.bdate,tm.edate,tm.u,tm.a,tm.d,tm.e,tm.f,tm.g,tm.b,tm.g_auto_gen,tm.c,tm.c1,tm.c3,tm.m   #FUN-C80102  add      #FUN-D50083 tm.c3   #FUN-D60043 add tm.m
           ATTRIBUTES (WITHOUT DEFAULTS)    #FUN-C80102  add
         BEFORE INPUT 
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         CALL q378_set_entry_1()
         CALL q378_set_no_entry_1()

      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
         CALL q378_set_entry_1()
         CALL q378_set_no_entry_1()

       #FUN-C80102--mark--str--
       #AFTER FIELD u #TQC-D60039 mark
       ON CHANGE u    #TQC-D60039
             IF NOT cl_null(tm.u) AND tm.c = 'Y' THEN
                CALL cl_set_comp_entry("c1",TRUE)
             ELSE
                CALL cl_set_comp_entry("c1",FALSE)
             END IF

       ON CHANGE d
          IF NOT cl_null(tm.d) THEN 
             IF tm.d = 'Y' THEN 
                CALL cl_set_comp_entry("e,f,g,c3",TRUE)   #FUN-D50083 add c3
                LET tm.e = '1' 
                SELECT ccz28 INTO l_ccz28 FROM ccz_file 
                LET tm.f = l_ccz28
                LET tm.c3 = 'Y'                           #FUN-D50083 add
                CALL cl_set_comp_required("f",TRUE)   #No.FUN-D20032
             ELSE
                CALL cl_set_comp_entry("e,f,g,c3",FALSE)  #FUN-D50083 add c3
                LET tm.e = '' 
                LET tm.f = ''
                LET tm.c3 = 'N'                           #FUN-D50083 add
                CALL cl_set_comp_required("f",FALSE)   #No.FUN-D20032
             END IF 
          END IF 

       AFTER FIELD f
          IF tm.f IS NOT NULL THEN
             IF tm.f NOT MATCHES '[12345]' THEN
                NEXT FIELD f
             END IF
             IF tm.f MATCHES'[12]' THEN
                CALL cl_set_comp_entry("g",FALSE)
                LET tm.g = ' '
             ELSE
                CALL cl_set_comp_entry("g",TRUE)
             END IF
          END IF

       BEFORE FIELD g
          IF tm.f MATCHES'[12]' THEN
             CALL cl_set_comp_entry("g",FALSE)
             LET tm.g = ' '
          ELSE
             CALL cl_set_comp_entry("g",TRUE)
          END IF
       #FUN-C80102--mark--add--

      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF

      #AFTER FIELD c  #FUN-C80102  mark
      ON CHANGE c     #FUN-C80102  add  
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         ELSE 
            #IF tm.c = 'N' THEN #TQC-D60039 mark
            IF NOT cl_null(tm.u) AND tm.c = 'Y'  THEN #TQC-D60039
               #CALL cl_set_comp_visible("oma23,oma24,omb13,omb14t",FALSE)   #FUN-C80102  mark
               #CALL cl_set_comp_entry("c1",FALSE)                           #FUN-C80102  add #TQC-D60039 mark
               CALL cl_set_comp_entry("c1",TRUE) #TQC-D60039
            ELSE 
               #CALL cl_set_comp_visible("oma23,oma24,omb13,omb14t",TRUE)    #FUN-C80102  mark
               #CALL cl_set_comp_entry("c1",TRUE)                            #FUN-C80102  add #TQC-D60039 mark
               CALL cl_set_comp_entry("c1",FALSE) #TQC-D60039
            END IF   

         END IF
         
     #-CHI-B60008-end-

      #ON ACTION CONTROLR
      #   CALL cl_show_req_fields()

      #FUN-C80102--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()    # Command execution

      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
         #CONTINUE INPUT   
 
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
 
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
 
      #ON ACTION exit
      #   LET INT_FLAG = 1
         #EXIT INPUT     

      #ON ACTION qbe_save
      #   CALL cl_qbe_save()
      

      #IF INT_FLAG THEN
      #   LET INT_FLAG = 0    
      #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      #   RETURN                  
      #END IF
      #FUN-C80102--mark--end--
 
   END INPUT

   #FUN-C80102--mark--str--
   #IF INT_FLAG THEN
   #   LET INT_FLAG = 0  CLOSE WINDOW q378_w    
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
   #   EXIT PROGRAM                            
   #END IF
   #FUN-C80102--mark--end--
   
   #CONSTRUCT tm.wc ON omb04,oma03,oma10,oma01,oma08         #FUN-C80102  mark
   #              FROM s_omb[1].omb04,s_omb[1].oma03,s_omb[1].oma10,s_omb[1].oma01,s_omb[1].oma08    #FUN-C80102  mark
   #FUN-C80102--add--str--
   CONSTRUCT tm.wc ON oma03,oma032,oma68,oma69,
                      oma15,gem02,oma14,gen02,
                      oma25,oma26,omb04,ima02,
                      ima021,oma10,oma02,omb38,
                      omb31,omb32,omb40,azf03,
                      omb39,oma08,oma33,aba02,oma01,omb03,    #NO.FUN-D30049  Add oma33,aba02
                      omb33,aag02,omb05,omb12,
                      oma23,oma24,omb13,omb14,
                      oma54x,omb14t,omb15,omb16,
                      omb16t,ccc92,ccc62,s1,s2
                 FROM s_omb[1].oma03,s_omb[1].oma032,s_omb[1].oma68,s_omb[1].oma69,
                      s_omb[1].oma15,s_omb[1].gem02,s_omb[1].oma14,s_omb[1].gen02,
                      s_omb[1].oma25,s_omb[1].oma26,s_omb[1].omb04,s_omb[1].ima02,
                      s_omb[1].ima021,s_omb[1].oma10,s_omb[1].oma02,s_omb[1].omb38,
                      s_omb[1].omb31,s_omb[1].omb32,s_omb[1].omb40,s_omb[1].azf03,
                      s_omb[1].omb39,s_omb[1].oma08,
                      s_omb[1].oma33,s_omb[1].aba02,    #NO.FUN-D30049  Add oma33,aba02
                      s_omb[1].oma01,s_omb[1].omb03,
                      s_omb[1].omb33,s_omb[1].aag02,s_omb[1].omb05,s_omb[1].omb12,
                      s_omb[1].oma23,s_omb[1].oma24,s_omb[1].omb13,s_omb[1].omb14,
                      s_omb[1].oma54x,s_omb[1].omb14t,s_omb[1].omb15,s_omb[1].omb16,
                      s_omb[1].omb16t,s_omb[1].ccc92,s_omb[1].ccc62,s_omb[1].s1,
                      s_omb[1].s2
   #FUN-C80102--add--end--
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
           #FUN-C80102--mark--str--
           #FOR l_n = 1 TO g_omb.getLength()
           #   INITIALIZE g_omb[l_n].* TO NULL
           #   DISPLAY g_omb[l_n].* TO s_omb[l_n].*
           #END FOR 
           #FUN-C80102--mark--end--
    END CONSTRUCT     #FUN-C80102  add
 
     ON ACTION locale
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_action_choice = "locale"
        #EXIT CONSTRUCT      #FUN-C80102  mark
        EXIT DIALOG          #FUN-C80102  add
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        #CONTINUE CONSTRUCT   #FUN-C80102  mark
        CONTINUE DIALOG       #FUN-C80102  add
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
     ON ACTION exit
        LET INT_FLAG = 1
        #EXIT CONSTRUCT      #FUN-C80102  mark
        EXIT DIALOG          #FUN-C80102  add

     #FUN-C80102--add--str--
     ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT DIALOG
            
     ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG 
     #FUN-C80102--add--end-- 
 
      ON ACTION CONTROLP
         IF INFIELD(g) THEN
            IF tm.f MATCHES '[45]' THEN
                 CALL cl_init_qry_var()
              CASE tm.f
                 WHEN '4'
                   LET g_qryparam.form = "q_pja"
                 WHEN '5'
                   LET g_qryparam.form = "q_imd09" 
                 OTHERWISE EXIT CASE
              END CASE
              LET g_qryparam.default1 = tm.g
              CALL cl_create_qry() RETURNING tm.g
              DISPLAY BY NAME tm.g
              NEXT FIELD g
            END IF
         END IF
         IF INFIELD(omb04) THEN   #TQC-6A0049
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO omb04    #TQC-6A0049
            NEXT FIELD omb04                        #TQC-6A0049
         END IF
         IF INFIELD(oma03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form = "q_occ"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO oma03
            NEXT FIELD oma03 
         END IF
         --IF INFIELD(oma18) THEN
            --CALL cl_init_qry_var()
            --LET g_qryparam.state    = "c"
            --LET g_qryparam.form = "q_aag"
            --CALL cl_create_qry() RETURNING g_qryparam.multiret 
            --DISPLAY g_qryparam.multiret TO oma18 
            --NEXT FIELD oma18 
         --END IF
         #FUN-C80102--add--str--
         CASE 
         WHEN INFIELD(oma68)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma68
               NEXT FIELD oma68
         WHEN INFIELD(oma15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem3"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma15
               NEXT FIELD oma15 
         WHEN INFIELD(oma14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen5"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma14
               NEXT FIELD oma14
          WHEN INFIELD(oma25)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma25"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma25
               NEXT FIELD oma25
          WHEN INFIELD(oma26)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma26"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma26
               NEXT FIELD oma26
          WHEN INFIELD(omb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima110"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omb04
               NEXT FIELD omb04
          WHEN INFIELD(omb40)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf4"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omb40
               NEXT FIELD omb40
         #No.FUN-D30049 ---start--- Add
          WHEN INFIELD(oma33)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aba02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma33
               NEXT FIELD oma33
         #No.FUN-D30049 ---end  --- Add
          WHEN INFIELD(oma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma01
               NEXT FIELD oma01
         END CASE 

         AFTER DIALOG 
         IF tm.c = 'Y' THEN
            #CALL cl_set_comp_visible("oma23,omb14,omb14t",TRUE)   #TQC-CC0122 lujh mark
            CALL cl_set_comp_visible("oma23,omb14",TRUE)    #TQC-CC0122 lujh add
         ELSE
            CALL cl_set_comp_visible("oma23,omb14,omb14t",FALSE)
         END IF   
         IF tm.d = 'Y' THEN 
            CALL cl_set_comp_visible("ccc92,ccc62,s1,s2",TRUE)
         ELSE
            CALL cl_set_comp_visible("ccc92,ccc62,s1,s2",FALSE)
         END IF 
         #FUN-C80102--add--end--
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
  #END CONSTRUCT   #FUN-C80102  
  END DIALOG       #FUN-C80102 add
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM        #FUN-C80102  add
      #RETURN             #FUN-C80102  mark
   END IF

 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axrq378'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrq378','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,    #CHI-850016
                         " '",tm.g_auto_gen CLIPPED,"'",
                         " '",plant[1] CLIPPED,"'",
                         " '",plant[2] CLIPPED,"'",
                         " '",plant[3] CLIPPED,"'",
                         " '",plant[4] CLIPPED,"'",
                         " '",plant[5] CLIPPED,"'",
                         " '",plant[6] CLIPPED,"'",
                         " '",plant[7] CLIPPED,"'",
                         " '",plant[8] CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
         CALL cl_cmdat('axrq378',g_time,l_cmd)    # Execute cmd at later time
      END IF
      --CLOSE WINDOW q378_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   #TQC-D60039--add--str--
   IF cl_null(tm.u) AND g_action_choice='query' THEN
      LET g_action_flag = 'page1'
   END IF
   #TQC-D60039--add--end
   CALL cl_wait()
   CALL q378()
   CALL q378_t()
   ERROR ""
--END WHILE
   --CLOSE WINDOW q378_w
END FUNCTION
 
FUNCTION q378()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
          l_sql     STRING ,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_oob09   LIKE oob_file.oob09,
          l_oob10   LIKE oob_file.oob10,
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l1_i      LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_dbs     LIKE azp_file.azp03,
          #FUN-C80102--mark--str--
          #sr        RECORD
          #          order1   LIKE   omb_file.omb04,      #No.FUN-680123 VARCHAR(40)
          #          order2   LIKE   omb_file.omb32,      #No.FUN-680123 VARCHAR(16)
          #          order3   LIKE   omb_file.omb04,      #No.FUN-680123 VARCHAR(12) 
          #          order4   LIKE   omb_file.omb04,      #No.FUN-680123 VARCHAR(12)
          #          oma03    LIKE   oma_file.oma03,      #帳款客戶編號
          #          oma032   LIKE   oma_file.oma032,     #客戶簡稱
          #          omb04    LIKE   omb_file.omb04,      #機種(料號)
          #          occ21    LIKE   occ_file.occ21,      #區域(國別)
          #          oma01    LIKE   oma_file.oma01,      #帳款編號
          #          omb03    LIKE   omb_file.omb03,      #項次
          #          omb05    LIKE   omb_file.omb05,      #單位   #MOD-860260 add
          #          omb06    LIKE   omb_file.omb06,      #品名
          #          omb12    LIKE   omb_file.omb12,      #數量
          #          omb12_1  LIKE   omb_file.omb12,      #數量
          #          omb15    LIKE   omb_file.omb15,      #本幣單價
          #          omb31    LIKE   omb_file.omb31,      #出貨單號
          #          omb32    LIKE   omb_file.omb32,      #出貨單號項次
          #          oma23    LIKE   oma_file.oma23,      #幣別
          #          oma24    LIKE   oma_file.oma24,      #匯率
          #          omb13    LIKE   omb_file.omb13,      #原幣單價
          #          oma02    LIKE   oma_file.oma02,      #立帳日
          #          oma08    LIKE   oma_file.oma08,      #內/外銷
          #          omb14t   LIKE   omb_file.omb14t,     #原幣含稅金額
          #          omb14    LIKE   omb_file.omb14,      #原幣未稅金額
          #          omb16t   LIKE   omb_file.omb16t,     #本幣含稅金額
          #          omb16    LIKE   omb_file.omb16,      #本幣未稅金額
          #          oma00    LIKE   oma_file.oma00,      #
          #          oma10    LIKE   oma_file.oma10,      #發票金額
          #          db       LIKE   azp_file.azp02,
          #          oma16    LIKE   oma_file.oma16,      #出货单号
          #          oga02    LIKE   oga_file.oga02,      #出货日期
          #          oma161   LIKE   oma_file.oma161,     #訂金應收比率  #CHI-760014 add 
          #          oma162   LIKE   oma_file.oma162,     #出貨應收比率  #CHI-760014 add  
          #          oma163   LIKE   oma_file.oma163,     #尾款應收比率  #CHI-760014 add  
          #          azi03    LIKE   azi_file.azi03,      #MOD-7B0051
          #          azi04    LIKE   azi_file.azi04,      #MOD-7B0051
          #          azi05    LIKE   azi_file.azi05,      #MOD-7B0051
          #          azi07    LIKE   azi_file.azi07       #MOD-870260 add
          #          END RECORD
          #FUN-C80102--mark--end--
          #FUN-C80102--add--str--
          sr         RECORD
                     azp01   LIKE azp_file.azp01,
                     oma03   LIKE oma_file.oma03,
                     oma032  LIKE oma_file.oma032,
                     oma68   LIKE oma_file.oma68, 
                     oma69   LIKE oma_file.oma69, 
                     oma15   LIKE oma_file.oma15,
                     gem02   LIKE gem_file.gem02,
                     oma14   LIKE oma_file.oma14,
                     gen02   LIKE gen_file.gen02,
                     oma25   LIKE oma_file.oma25,
                     oma26   LIKE oma_file.oma26,
                     omb04   LIKE omb_file.omb04,
                     ima02   LIKE ima_file.ima02,
                     ima021  LIKE ima_file.ima021,
                     oma10   LIKE oma_file.oma10,
                     oma02   LIKE oma_file.oma02,
                     omb38   LIKE omb_file.omb38,
                     omb31   LIKE omb_file.omb31,
                     omb32   LIKE omb_file.omb32,
                     omb40   LIKE omb_file.omb40,
                     azf03   LIKE azf_file.azf03,
                     omb39   LIKE omb_file.omb39,
                     oma08   LIKE oma_file.oma08,
                     oma33   LIKE oma_file.oma33,   #No.FUN-D30049   Add
                     aba02   LIKE aba_file.aba02,   #No.FUN-D30049   Add
                     oma01   LIKE oma_file.oma01,
                     omb03   LIKE omb_file.omb03,
                     omb33   LIKE omb_file.omb33,
                     aag02   LIKE aag_file.aag02,  
                     omb05   LIKE omb_file.omb05,
                     omb12   LIKE omb_file.omb12,
                     oma23   LIKE oma_file.oma23,
                     oma24   LIKE oma_file.oma24,
                     omb13   LIKE omb_file.omb13,
                     omb14   LIKE omb_file.omb14,
                     oma54x  LIKE oma_file.oma54x,
                     omb14t  LIKE omb_file.omb14t,
                     omb15   LIKE omb_file.omb15,
                     omb16   LIKE omb_file.omb16,
                     oma56x  LIKE oma_file.oma56x,
                     omb16t  LIKE omb_file.omb16t,
                     occ21   LIKE occ_file.occ21,
                     oma16   LIKE oma_file.oma16,
                     oga02   LIKE oga_file.oga02,
                     oga02a  LIKE oga_file.oga02, #add ly170810
                     oma00   LIKE oma_file.oma00,
                     oma161  LIKE oma_file.oma161,
                     oma162  LIKE oma_file.oma162,
                     azi03   LIKE azi_file.azi03,     
                     azi04   LIKE azi_file.azi04,      
                     azi05   LIKE azi_file.azi05,     
                     azi07   LIKE azi_file.azi07
                     END RECORD
         #FUN-C80102--add--end--
   DEFINE l_geb02   LIKE geb_file.geb02
   DEFINE l_msg     STRING   #FUN-C80092 
   #FUN-C80102--add--str--
   DEFINE  l_ccc92   LIKE ccc_file.ccc92,
           l_ccc91   LIKE ccc_file.ccc91,
           l_stb04   LIKE stb_file.stb04,
           l_stb05   LIKE stb_file.stb05,
           l_stb06   LIKE stb_file.stb06,
           l_stb06a  LIKE stb_file.stb06a,
           l_ccc62   LIKE ccc_file.ccc62,
           l_s1      LIKE type_file.num20_6,
           l_s2      LIKE type_file.chr20
   #FUN-C80102--add--end--
#No.FUN-D20032 --begin 
   DEFINE  l_omb04   LIKE omb_file.omb04 
   DEFINE  l_omb05   LIKE omb_file.omb05 
   DEFINE  l_tlf60   LIKE tlf_file.tlf60 
   DEFINE  l_fac     LIKE type_file.num5 
   DEFINE  l_flag    LIKE type_file.num5 
#No.FUN-D20032 --end 
   DEFINE l_sql1     STRING      #yinhy131108  
   DEFINE l_wc_oga      STRING      #yinhy131108
   DEFINE l_wc_oha      STRING      #yinhy131108
   
   CALL q378_table()
   DISPLAY TIME   #lujh test
   #FUN-C80092--add--by--free--str--
   IF g_bgjob = 'Y' THEN 
      #SELECT ccz01,ccz02,ccz28 INTO g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz28 FROM ccz_file WHERE czz00='0'  #MOD-D20096 mark
      SELECT ccz01,ccz02,ccz28 INTO g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'   #MOD-D20096
      IF cl_null(tm.wc) THEN LET tm.wc = ' 1=1' END IF 
      IF cl_null(tm.bdate) OR cl_null(tm.edate) THEN
         CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.bdate,tm.edate 
      END IF 
      IF cl_null(tm.b) THEN LET tm.b= 'Y' END IF
      IF cl_null(tm.c) THEN LET tm.c = 'N' END IF 
   END IF 
   #FUN-C80092--add--by--free--end--
   
   #FUN-C80092 -----------Begin-------------                     
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.b = '",tm.b,"'",";",
               "tm.c = '",tm.c,"'",";","tm.g_auto_gen = '",tm.g_auto_gen,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
   #FUN-C80092 -----------End--------------

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
  #-CHI-B60008-add-
   CALL cl_del_data(l_table1) 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"    #MOD-7B0051  #MOD-860260 add ?   #MOD-870260 add ? #FUN-8C0019 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092 
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
  #-CHI-B60008-end-
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
 
   LET g_yy = YEAR(tm.bdate)
   LET g_mm = MONTH(tm.bdate)

 
   LET g_pageno = 0
 
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
             " FROM axrq378_tmp1 ",
             " WHERE item=?  ",
             " GROUP BY curr ORDER BY curr "
   PREPARE q378_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE tmp_curs1 CURSOR FOR q378_pr1
 
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
             " FROM axrq378_tmp ",
             " GROUP BY curr ORDER BY curr "
   PREPARE q378_pr2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE tmp_curs2 CURSOR FOR q378_pr2
 
   DELETE FROM axrq378_tmp1
   DELETE FROM axrq378_tmp
   LET g_cnt=1
   LET g_num =0
   LET g_tot1=0
   LET g_tot2=0
   LET g_amt=0 LET t_rate=0
   LET g_pageno = 0
   IF tm.g_auto_gen='Y' THEN
      DELETE FROM ckl_file WHERE ckl07=g_ccz.ccz01 AND ckl08=g_ccz.ccz02 AND ckl01='317'
   END IF
#  FOR l_i = 1 to 8
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-BB0173 add START
    LET l_i = 1
    FOR l_i = 1 TO g_ary_i
       IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END
         #FUN-C80102--mark--str--
         #LET l_sql = " SELECT '','','','',",
         #            "        oma03,oma032,omb04,occ21,",
         #            "        oma01,omb03,omb05,omb06,omb12,omb12,omb15,",
         #            "        omb31,omb32,oma23,oma24,omb13,",
         #            "        oma02,oma08,omb14t,omb14,omb16t,",
         #            "        omb16,oma00,oma10, ",
         #            "        '',",
         #            "        oma16,'',oma161,oma162,oma163",
         #            " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
         #            " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),      #FUN-BB0173 add
         #            " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),      #FUN-BB0173 add
         #            " WHERE oma03 = occ01",

         #            "   AND oma01 = omb01 ",  
         #            "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142   
         #            "   AND omaconf = 'Y' ",
         #            "   AND omavoid = 'N' ",
         #            "   AND omb04[1,4] != 'MISC' ",    #No.9579
         #            "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
         #FUN-C80102--mark--end--
         #FUN-C80102--add--str--
         IF tm.d = 'N' THEN   
            LET l_sql = 
                        " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                        "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                        "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",   #No.FUN-D30049  Add oma33,aba02
#                       "        omb05,omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                        "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12 ,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",   #No.FUN-D20032
                        "        omb16,oma56x,omb16t,",
                        " 0 ccc92,0 ccc62,0 s1,0 s2",                   
                        " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                        " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                        " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),      #FUN-BB0173 add
                        " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),      #FUN-BB0173 add
                        " WHERE oma03 = occ01",
                        "   AND oma01 = omb01 ",  
                        "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142   
                        "   AND omaconf = 'Y' ",
                        "   AND omavoid = 'N' ",
                       #"   AND omb04[1,4] != 'MISC' ",    #No.9579     #FUN-D60043 mark
                        "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        END IF 
        IF tm.d = 'Y' THEN 
           IF tm.e = '1' THEN 
              #FUN-D50083--add--str--
              IF tm.c3 ='Y' THEN
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",  #No.FUN-D30049  Add
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  #No.FUN-D20032
#                             "        (case when ccc62 IS NULL then 0 else omb16 end) omb16,oma56x,omb16t,",   #mark by jiangln 160712
                             "        omb16,oma56x,omb16t,",   #add by jiangln 160712
                             "         nvl(ccc92,0) ccc92,nvl(ccc91,0) ccc91,",
                             "         nvl(ccc62,0) ccc62,",   
                             "         nvl(ccc23,0) ccc23 ",    
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left outer join ccc_file on ccc01 = omb04  and ccc02 = YEAR(oma02)",
                             " and ccc03 = MONTH(oma02) AND ccc07 = '",tm.f,"' AND ccc08 = '",tm.g,"' ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                            #"   AND omb04[1,4] != 'MISC' ",    #No.9579 #FUN-D60043 mark 
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
              ELSE
              #FUN-D50083--add--end--
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",  #No.FUN-D30049  Add oma33,aba02
#                            "        omb05,omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  #No.FUN-D20032
                             "        omb16,oma56x,omb16t,",
                             " ccc92,ccc91,ccc62,ccc23",   #No.FUN-D30049   Add  ccc23
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'), 
                             " on oma01 = omb01 ",    
                             " left outer join ccc_file on ccc01 = omb04  and ccc02 = YEAR(oma02)",
                             " and ccc03 = MONTH(oma02) ",     
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",  
                             "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142   
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                            #"   AND omb04[1,4] != 'MISC' ",    #No.9579  #FUN-D60043 mark
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
               END IF          #FUN-D50083 add
           END IF   
           IF tm.e = '2'  THEN 
              #FUN-D50083--add--str--
              IF tm.c3 ='Y' THEN
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",   #No.FUN-D30049  Add
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  #No.FUN-D20032
                             "        (case when ccc62 IS NULL then 0 else omb16 end) omb16,oma56x,omb16t,",
                             "         nvl(ccc12,0) ccc12,nvl(ccc62,0) ccc62,nvl(ccc11,0) ccc11 ",
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                             " left outer join ccc_file on ccc01 = omb04  and ccc02 = YEAR(oma02) ",
                             " and ccc03 = MONTH(oma02) AND ccc07 = '",tm.f,"' AND ccc08 = '",tm.g,"' ",
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                            #"   AND omb04[1,4] != 'MISC' ",    #No.9579 #FUN-D60043 mark 
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
              ELSE
              #FUN-D50083--add--end--
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",   #No.FUN-D30049  Add oma33,aba02
#                            "        omb05,omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,", #No.FUN-D20032
                             "        omb16,oma56x,omb16t,",
                             " ccc12,ccc62,ccc11",    
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'), 
                             " on oma01 = omb01 ",    
                             " left outer join ccc_file on ccc01 = omb04  and ccc02 = YEAR(oma02)", #TQC-D60039
                             " and ccc03 = MONTH(oma02) ", 
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                             " left outer join ccc_file on ccc01 = omb04  and ccc02 = YEAR(oma02) ",     #FUN-D50083 add
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",  
                             "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142   
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                            #"   AND omb04[1,4] != 'MISC' ",    #No.9579   #FUN-D60043 mark
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
              END IF         #FUN-D50083 add
           END IF    
           IF tm.e = '3' THEN 
              LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                          "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                          "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",  #No.FUN-D30049   Add
#                         "        omb05,omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                          "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  #No.FUN-D20032
                          "        omb16,oma56x,omb16t,",
                          " stb04,stb05,stb06,stb06a",       
                          " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  
                          " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      
                          " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                          " on oma01 = omb01 ",       
                          " left outer join stb_file on stb01 = omb04  and stb02 = YEAR(oma02)",
                          " and stb03 = MONTH(oma02) ",     
                          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",      #No.FUN-D30049   Add
                          " WHERE oma03 = occ01",
                          "   AND oma01 = omb01 ",  
                          "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142   
                          "   AND omaconf = 'Y' ",
                          "   AND omavoid = 'N' ",
                         #"   AND omb04[1,4] != 'MISC' ",    #No.9579   #FUN-D60043 mark
                          "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           END IF
#add by jiangln 160712 start-----
            IF tm.e = '4' THEN 
              IF tm.c3 ='Y' THEN
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  
                             "        omb16,oma56x,omb16t,",   
                             "         nvl(ta_ccc92,0) ccc92,nvl(ta_ccc91,0) ccc91,",
                             "         nvl(ta_ccc62,0) ccc62,",   
                             "         nvl(ta_ccc23,0) ccc23 ",    
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oga_file on oga01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04 and ta_ccc02 = YEAR(oga02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oga02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",     
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('11','12','13') ", 
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
#170728 luoyb str
                            ,"   AND oma02 > '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  
                             "        omb16,oma56x,omb16t,",   
                             "         nvl(ta_ccc92,0) ccc92,nvl(ta_ccc91,0) ccc91,",
                             "         nvl(ta_ccc62,0) ccc62,",   
                             "         nvl(ta_ccc23,0) ccc23 ",    
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oha_file on oha01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04  and ta_ccc02 = YEAR(oha02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oha02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",     
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('21') ", 
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                            ,"   AND oma02 > '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb16,oma56x,omb16t,",
                             "         nvl(tc_ccpd04,0)*omb12 ccc92,nvl(ta_ccc91,0) ccc91,",
                             "         nvl(tc_ccpd04,0)*omb12 ccc62,",
                             "         nvl(tc_ccpd04,0) ccc23 ",
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oga_file on oga01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04 and ta_ccc02 = YEAR(oga02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oga02) ",
                             " left outer join tc_ccpd_file on tc_ccpd01 = omb04  and tc_ccpd02 = YEAR(oga02)",
                             " and tc_ccpd03 = MONTH(oga02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('11','12','13') ",
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                            ,"   AND oma02 <= '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb16,oma56x,omb16t,",
                             "         nvl(tc_ccpd04,0)*omb12 ccc92,nvl(ta_ccc91,0) ccc91,",
                             "         nvl(tc_ccpd04,0)*omb12 ccc62,",
                             "         nvl(tc_ccpd04,0) ccc23 ",
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oha_file on oha01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04  and ta_ccc02 = YEAR(oha02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oha02) ",
                             " left outer join tc_ccpd_file on tc_ccpd01 = omb04  and tc_ccpd02 = YEAR(oha02)",
                             " and tc_ccpd03 = MONTH(oha02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('21') ",
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                            ,"   AND oma02 <= '17/01/31' "
#170728 luoyb end
              ELSE
                 LET l_sql = " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,", 
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  
                             "        omb16,oma56x,omb16t,",
                             " ta_ccc92,ta_ccc91,ta_ccc62,ta_ccc23",   
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'), 
                             " on oma01 = omb01 ",
                             " left join oga_file on oga01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04  and ta_ccc02 = YEAR(oga02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oga02) ",     
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",  
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",  
                             "   AND oma00 IN ('11','12','13') ", 
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
#170728 luoyb str
                            ,"   AND oma02 > '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,", 
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",  
                             "        omb16,oma56x,omb16t,",
                             " ta_ccc92,ta_ccc91,ta_ccc62,ta_ccc23",   
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'), 
                             " on oma01 = omb01 ",
                             " left join oha_file on oha01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04  and ta_ccc02 = YEAR(oha02)",  #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oha02) ",     
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",  
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",  
                             "   AND oma00 IN ('21') ", 
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
                            ,"   AND oma02 > '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb16,oma56x,omb16t,",
                             " nvl(tc_ccpd04,0)*omb12 ccc92,ta_ccc91,nvl(tc_ccpd04,0)*omb12 ccc62,nvl(tc_ccpd04,0) ccc23",
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oga_file on oga01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04  and ta_ccc02 = YEAR(oga02)", #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oga02) ",
                             " left outer join tc_ccpd_file on tc_ccpd01 = omb04  and tc_ccpd02 = YEAR(oga02)",
                             " and tc_ccpd03 = MONTH(oga02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('11','12','13') ",
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
                            ,"   AND oma02 <= '17/01/31' ",
                             " UNION ALL ",
                             " SELECT '' azp01,oma03,oma032,oma68,oma69,oma15,'' gem02,oma14,'' gen02,",
                             "        oma25,oma26,omb04,'' ima02,'' ima021,oma10,oma02,omb38,omb31,",
                             "        omb32,omb40,'' azf03,omb39,oma08,oma33,aba02,oma01,omb03,omb33,'' aag02,",
                             "        omb05,(case when omb38 ='3' then omb12*-1 else omb12 end) omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,omb15,",
                             "        omb16,oma56x,omb16t,",
                             " nvl(tc_ccpd04,0)*omb12 ccc92,ta_ccc91,nvl(tc_ccpd04,0)*omb12 ccc62,nvl(tc_ccpd04,0) ccc23",
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),
                             " ,",cl_get_target_table(g_ary[l_i].plant,'oma_file'),
                             " full join ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),
                             " on oma01 = omb01 ",
                             " left join oha_file on oha01 = omb31 ",
                             " left outer join ta_ccp_file on ta_ccc01 = omb04 and ta_ccc02 = YEAR(oha02)", #170728 luoyb oma02 -> oga02
                             " and ta_ccc03 = MONTH(oha02) ",
                             " left outer join tc_ccpd_file on tc_ccpd01 = omb04  and tc_ccpd02 = YEAR(oha02)",
                             " and tc_ccpd03 = MONTH(oha02) ",
                             " LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'aba_file')," ON aba01 = oma33",
                             " WHERE oma03 = occ01",
                             "   AND oma01 = omb01 ",
                             "   AND oma00 IN ('21') ",
                             "   AND omaconf = 'Y' ",
                             "   AND omavoid = 'N' ",
                             "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                             "   AND ccc07 = '",tm.f,"'",
                             "   AND ccc08 = '",tm.g,"'"
                            ,"   AND oma02 <= '17/01/31' "
#170728 luoyb end
               END IF  
           END IF   
#add by jiangln 160712 end------
        END IF 
        #FUN-C80102--add--end--
        IF tm.b = 'Y' THEN
           LET l_sql = l_sql,"   AND oma00 IN ('11','12','21') "       #MOD-880001
        ELSE
           LET l_sql = l_sql,"   AND oma00 IN ('12','13','21') "
        END IF
        #FUN-D60043--add--str--
        IF tm.m = 'N' THEN
           LET l_sql = l_sql,"  AND omb04[1,4] != 'MISC' "
        END IF
        #FUN-D60043--add--end--
       #只有大陸功能才有發票待扺
       IF g_aza.aza26 = '2' THEN
          LET l_sql = l_sql CLIPPED,
                      "   AND oma01 IN (SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file,",
#                               l_dbs CLIPPED," omb_file ",
                     #"  FROM oma_file,omb_file ",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),   #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),        #FUN-BB0173 add 
                      " WHERE oma01 = omb01 ",
                      "   AND ",tm.wc CLIPPED,
                      "  UNION ",
                      " SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file ",
                     #"  FROM oma_file ",   #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),     #FUN-BB0173 add
                      " WHERE oma01 IN (SELECT DISTINCT oot01 ",
#                     "  FROM ",l_dbs CLIPPED," oot_file ",
                     #"  FROM oot_file ",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oot_file'),  #FUN-BB0173 add
                      " WHERE oot03 IN (SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file,",
#                               l_dbs CLIPPED," omb_file ",
                     #"  FROM oma_file,omb_file ",
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                      "  ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),      #FUN-BB0173 add
                      " WHERE oma01 = omb01 ",
                      "   AND omaconf = 'Y' ",
                      "   AND omavoid = 'N' ",
                      "   AND ",tm.wc CLIPPED,
                      " ))) "
#          LET l_sql = l_sql CLIPPED,     #mark by jiangln 161102 ----重复传值
#                      "   AND ",tm.wc CLIPPED   #mark by jiangln 161102 ----重复传值
       ELSE
          LET l_sql = l_sql CLIPPED,
                      "   AND ",tm.wc CLIPPED
       END IF
 
       LET l_sql=l_sql CLIPPED," AND ",tm.wc CLIPPED   #MOD-930324 add

       #FUN-C80102--add--str--
       IF tm.d = 'N' THEN 
          LET l_sql = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                         " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                         " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,",   #No.FUN-D30049   Add oma33,aba02
                         " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                         " ccc92,ccc62,s1,s2",
                         "   FROM (",l_sql CLIPPED,") x "
          PREPARE q378_ins3 FROM l_sql
          EXECUTE q378_ins3
       END IF 
       
       IF tm.d ='Y'THEN 
          IF tm.e = '1' THEN
             LET l_sql = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                         " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                         " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,",   #No.FUN-D30049   Add oma33,aba02
                         " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
#No.FUN-D20032 --begin
                         " ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end))  ccc92,",
                         " ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12)  ccc62,",
                         " (omb16 - ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12))  s1, ",    
                         " (case when omb16=0 then 0 else (((omb16 - ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12))/omb16*100)) end)  s2 ",    #mark by jiangln 160708
#                        " ((case when ccc91=0 then 0  else ccc92 /ccc91 end))  ccc92,",
#                        " ((case when ccc91=0 then 0  else ccc92 /ccc91 end)*omb12)  ccc62,",
#                        " (omb16 - ((case when ccc91=0 then 0  else ccc92 /ccc91 end)*omb12))  s1, ",
#                        " (case when omb16=0 then 0 else (((omb16 - ((case when ccc91=0 then 0  else ccc92 /ccc91 end)*omb12))/omb16*100)) end)  s2 ",
#No.FUN-D20032 --end 
                         "   FROM (",l_sql CLIPPED,") x "
             PREPARE q378_ins FROM l_sql
             EXECUTE q378_ins
             SELECT count(*) INTO l_n FROM axrq378_tmp
          END IF
       
          IF tm.e = '2' THEN 
             LET l_sql = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                         " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                         " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,",   #No.FUN-D30049   Add oma33,aba02
                         " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                         " ( case when ccc11=0 then 0  else ccc12 /ccc11 end) as ccc92,",
                         " (( case when ccc11=0 then 0  else ccc12 /ccc11 end)*omb12) as ccc62,",
                         " (omb16 - (( case when ccc11=0 then 0  else ccc12 /ccc11 end)*omb12)) as s1, ",
                         " (case when omb16=0 then 0 else (((omb16 - ((case when ccc11=0 then 0  else ccc12 /ccc11 end)*omb12))/omb16*100)) end ) as s2",
                         "   FROM (",l_sql CLIPPED,") x "
             PREPARE q378_ins1 FROM l_sql
             EXECUTE q378_ins1
          END IF 
          IF tm.e = '3' THEN 
             LET l_sql = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                         " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                         " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,",   #No.FUN-D30049   Add oma33,aba02
                         " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                         " nvl((stb04 + stb05 + stb06 + stb06a),0) as ccc92,",
                         " nvl(((stb04 + stb05 + stb06 + stb06a)*omb12),0) as ccc62, ",
                         " nvl((omb16 - ((stb04 + stb05 + stb06 + stb06a)*omb12)),0) as s1,",
                         " ((case when omb16=0 then 0 else nvl(((omb16 - ((stb04 + stb05 + stb06 + stb06a)*omb12))/omb16*100),0) end )) s2 ",
                         "   FROM (",l_sql CLIPPED,") x "
             PREPARE q378_ins2 FROM l_sql
             EXECUTE q378_ins2
          END IF
       END IF 
#add by jiangln 160712 start------
          IF tm.e = '4' THEN
             LET l_sql = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                         " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                         " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,",  
                         " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
         #                " ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end))  ccc92,",
         #                " ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12)  ccc62,",
         #                " (omb16 - ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12))  s1, ",    
         #                " (case when omb16=0 then 0 else (((omb16 - ((case when ccc91=0 then ccc23  else ccc92 /ccc91 end)*omb12))/omb16*100)) end)  s2 ",   
                          " ccc23 ccc92,",
                          " ccc23*omb12  ccc62,",
                          " (omb16 - ccc23*omb12) s1, ",    
                          " (case when omb16=0 then 0 else (omb16 - ccc23*omb12)/omb16*100 end) s2 ",   
                          "   FROM (",l_sql CLIPPED,") x "
             PREPARE q378_ins4 FROM l_sql
             EXECUTE q378_ins4
             SELECT count(*) INTO l_n FROM axrq378_tmp
          END IF
#add by jiangln 160712 end--------

       #yinhy131107  --Begin
       LET l_wc_oga = tm.wc
       LET l_wc_oga=cl_replace_str(l_wc_oga, "oma03", "oga03")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "omb31", "oga01")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "omb38", "oga09")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "omb68", "oga18")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "oma15", "oga15")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "oma14", "oga14")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "oma25", "oga25")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "oma26", "oga26")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "omb04", "ogb04")
       LET l_wc_oga=cl_replace_str(l_wc_oga, "omb32", "ogb03")   #add by jiangln 160712
       #yinhy131107  --End

       #add by zhangym 130314 begin-----
       #出货类型为2换货出货时，也需要列进销货收入表中
          LET l_sql1 =  "SELECT '' azp01,oga03,oga032,oga18,occ02,oga15,'' gem02,oga14,'' gen02,oga25,oga26,ogb04,ima02, ",
                        "       ima021,ima12,'' azf03a,'' oma10,oga02,'','2' omb38,ogb01,ogb03,ogb1001,'' azf03,ogb1012,oga08, ",  #131018jiangxt add ima12,''
                        "       '' oma01,'' omb03,'' omb33,'' aag02,ogb916,ogb917, ",
                        "       oga23,oga24,ogb13,0 omb14,0 oma54x,0 omb14t,ogb13*oga24 omb15,0 omb16,0 oma56x,0 omb16t,0 ccc92,0 ccc62,",
                        "       0 s1,0 s2,''  ",
                        " FROM ",cl_get_target_table(g_ary[l_i].plant,'oga_file'),
                        " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),   
                        " ,",cl_get_target_table(g_ary[l_i].plant,'ogb_file'),    
                        " left outer join ",cl_get_target_table(g_ary[l_i].plant,'ima_file'),
                        " on ima01 = ogb04",      #131018jiangxt 
                        " WHERE oga18 = occ01",
                        "   AND oga01 = ogb01 ",  
                        "   AND oga00 = '2' ",   
                        "   AND oga09 IN ('2','3','4','6') ",
                        "   AND ogaconf = 'Y' ",
                        "   AND ogapost = 'Y' ",
                        "   AND ogb04[1,4] != 'MISC' ",
                        "   AND oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                        "   AND ",l_wc_oga CLIPPED 
                              
            LET l_sql1 = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oga03,oga032,oga18,occ02,oga15,gem02,oga14,",
                         " gen02,oga25,oga26,ogb04,ima02,ima021,ima12,azf03a,oma10,oga02,'',",  #131018jiangxt add ima12,azf03a
                         " omb38,ogb01,ogb03,ogb1001,azf03,ogb1012,oga08,oma01,",
                         " omb03,omb33,aag02,ogb916,ogb917,oga23,oga24,ogb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                         " ccc92,ccc62,s1,s2",
                         "   FROM (",l_sql1 CLIPPED,") x "
          PREPARE q378_ins31 FROM l_sql1
          EXECUTE q378_ins31

          #yinhy131107  --Begin
          LET l_wc_oha = tm.wc
          LET l_wc_oha=cl_replace_str(l_wc_oha, "oma03", "oha03")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "omb31", "oha01")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "omb68", "oha03")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "oma15", "oha15")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "oma14", "oha14")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "oma25", "oha25")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "oma26", "oha26")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "omb04", "ohb04")
          LET l_wc_oha=cl_replace_str(l_wc_oha, "omb32", "ohb32")   #add by jiangln 160712
          #yinhy131107  --End
                 
         #销退类型为2、3时，也需要列进销货收入表中
          LET l_sql1 =  "SELECT '' azp01,oha03,oha032,oha1001,occ02,oha15,'' gem02,oha14,'' gen02,oha25,oha26,ohb04,ima02, ",
                        "       ima021,ima12,'' azf03a,'' oma10,oha02,'3' omb38,ohb01,ohb03,ohb50,'' azf03,ohb1004,oha08,",  #131018jiangxt add ima12,''
                        "       '' oma01,'' omb03,'' omb33,'' aag02,ohb916,ohb917*-1, ",
                        "       oha23,oha24,ohb13,0 omb14,0 oma54x,0 omb14t,ohb13*oha24 omb15,0 omb16,0 oma56x,0 omb16t,0 ccc92,",
                        "      0 ccc62,",   
                      #  "   (case when omb38 = '3' then (case when ccc91=0 then ccc23  else ccc92 /ccc91 end) *(case when omb12 = 0 then 0 else omb12*(-1) end) else ((case when ccc91=0 then ccc23 else ccc92 /ccc91 end)*omb12) end) ccc62,",   #add by jiangln 160708
                        "       0 s1,0 s2,''",
                        " FROM ",cl_get_target_table(g_ary[l_i].plant,'oha_file'),  
                        " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),      
                        " ,",cl_get_target_table(g_ary[l_i].plant,'ohb_file'),      
                        " left outer join ",cl_get_target_table(g_ary[l_i].plant,'ima_file'),
                        " on ima01 = ohb04 ",   
                        " WHERE oha1001 = occ01",
                        "   AND oha01 = ohb01 ",  
                        "   AND oha09 IN ('2','3') ",
                        "   AND ohaconf = 'Y' ",
                        "   AND ohapost = 'Y' ",
                        "   AND ohb04[1,4] != 'MISC' ",    #No.9579
                        "   AND oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",    
                        "   AND ",l_wc_oha CLIPPED 
                        
            LET l_sql1 = " INSERT INTO axrq378_tmp ",
                         " SELECT azp01,oha03,oha032,oha1001,occ02,oha15,gem02,oha14,",
                         " gen02,oha25,oha26,ohb04,ima02,ima021,ima12,azf03a,oma10,oha02,",  #131018jiangxt add ima12,azf03a
                         " omb38,ohb01,ohb03,ohb50,azf03,ohb1004,oha08,oma01,",
                         " omb03,omb33,aag02,ohb916,ohb917,oha23,oha24,ohb13,",
                         " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                         " ccc92,ccc62,s1,s2",
                         "   FROM (",l_sql1 CLIPPED,") x "
          PREPARE q378_ins32 FROM l_sql1
          EXECUTE q378_ins32          
       #add by zhangym 130314 end-----   
   #TQC-D60039--add--str--
   END FOR
   UPDATE axrq378_tmp SET gem02=(SELECT gem02 FROM gem_file WHERE gem01=oma15)
   UPDATE axrq378_tmp SET gen02=(SELECT gen02 FROM gen_file WHERE gen01=oma14)
   UPDATE axrq378_tmp SET ima02=(SELECT ima02 FROM ima_file WHERE ima01=omb04),
                          ima021=(SELECT ima021 FROM ima_file WHERE ima01=omb04)
   UPDATE axrq378_tmp SET aag02=(SELECT DISTINCT aag02 FROM aag_file WHERE aag01=omb33)
   UPDATE axrq378_tmp SET azf03=(SELECT azf03 FROM azf_file WHERE azf01=omb40)
   #TQC-D60039--add--end
       IF tm.g_auto_gen='Y' THEN
          LET l_sql=" INSERT INTO ckl_file ",
                    " SELECT '317',omb31,omb32,omb04,omb12,omb16t,'",g_ccz.ccz01,"','",g_ccz.ccz02,"'",
                    " FROM axrq378_tmp  "
          PREPARE q378_pre4 FROM l_sql
          EXECUTE q378_pre4
       END IF

#No.FUN-D20032 --begin
#       LET l_sql=" UPDATE axrq378_tmp ",         #lujh 1219 mod
#                    " SET omb12 = omb12*-1,",
#                    "     omb14 = omb14*-1,",
#                    "     omb14t = omb14t*-1,",
#                    "     omb16 = omb16*-1,",
#                    "     omb16t = omb16t*-1",
#                    " WHERE omb38='3'"           #lujh 1219 mod
#       PREPARE q378_pre5 FROM l_sql
#       EXECUTE q378_pre5
#       #FUN-C80102--add--end--
#No.FUN-D20032 --end
      #TQC-D60039--mark--str-- 
      # CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      # PREPARE q378_prepare1 FROM l_sql
      # IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      #    CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      #    EXIT PROGRAM 
      # END IF
      # DECLARE q378_curs1 CURSOR FOR q378_prepare1

      #-MOD-B50224-add-
      # LET l_sql = "SELECT geb02 ",                                                                              
      #             "  FROM geb_file",
      #             " WHERE geb01= ? "
      # PREPARE geb_prepare2 FROM l_sql                                                                                          
      # DECLARE geb_c2  CURSOR FOR geb_prepare2                                                                                 

       #LET l_sql = "SELECT azi03,azi04,azi07 ",  
       #            "  FROM azi_file",
       #            " WHERE azi01= ? "    
       #PREPARE azi_prepare2 FROM l_sql                                                                                          
       #DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
      #-MOD-B50224-end-

       #LET l_sql = "SELECT oga02",
       #            "  FROM oga_file",
       #            " WHERE oga01= ? "
       #PREPARE oga_prepare1 FROM l_sql                                                                                          
       #DECLARE oga_c1  CURSOR FOR oga_prepare1
       #TQC-D60039--mark--end
       
       #FUN-C80102--mark--str--
       # FOREACH q378_curs1 INTO sr.*
       #   IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
       #      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
       #      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
       #      EXIT PROGRAM 
       #   END IF

       #   #FUN-C80102--mark--str--
       #   IF tm.d = 'Y' THEN 
       #      IF tm.e = '1' THEN 
       #         SELECT ccc92,ccc91 INTO l_ccc92,l_ccc91 FROM ccc_file 
       #          WHERE ccc01 = sr.omb04 
       #            AND ccc02 = YEAR(sr.oma02)
       #            AND ccc03 = MONTH(sr.oma02) 
       #            AND ccc07 = tm.f
       #            AND ccc08 = tm.g
       #          LET l_ccc92 = l_ccc92/l_ccc91
       #          LET l_ccc62 = l_ccc92 * sr.omb12
       #          LET l_s1 = sr.omb16 - l_ccc62
       #          LET l_s2 = l_s1/sr.omb16*100,'%'
       #      END IF 
       #      IF tm.e = '2' THEN 
       #         SELECT ccc12,ccc11 INTO l_ccc92,l_ccc91 FROM ccc_file 
       #          WHERE ccc01 = sr.omb04 
       #            AND ccc02 = YEAR(sr.oma02)
       #            AND ccc03 = MONTH(sr.oma02) 
       #            AND ccc07 = tm.f
       #            AND ccc08 = tm.g
       #         IF l_ccc92 < 0 THEN 
       #             LET l_ccc92 = l_ccc92 * -1
       #         END IF
       #         IF l_ccc91 < 0 THEN 
       #             LET l_ccc91 = l_ccc91 * -1
       #          END IF
       #         LET l_ccc92 = l_ccc92/l_ccc91
       #         LET l_ccc62 = l_ccc92 * sr.omb12
       #         LET l_s1 = sr.omb16 - l_ccc62
       #         LET l_s2 = l_s1/sr.omb16*100,'%'
       #      END IF 
       #      IF tm.e = '3' THEN 
       #         SELECT stb04,stb05,stb06,stb06a
       #           INTO l_stb04,l_stb05,l_stb06,l_stb06a FROM stb_file 
       #          WHERE stb01 = sr.omb04 
       #            AND stb02 = YEAR(sr.oma02)
       #            AND stb03 = MONTH(sr.oma02) 
       #         LET l_ccc92 = l_stb04 + l_stb05 + l_stb06 + l_stb06a
       #         IF l_ccc92 < 0 THEN 
       #             LET l_ccc92 = l_ccc92 * -1
       #         END IF
       #         LET l_ccc62 = l_ccc92 * sr.omb12
       #         LET l_s1 = sr.omb16 - l_ccc62
       #         LET l_s2 = l_s1/sr.omb16*100,'%'
       #      END IF 
       #   END IF 
       #   #FUN-C80102--mark--str--
 
       #   IF sr.oma00='21' THEN
       #      LET sr.omb12=sr.omb12*-1   #MOD-6A0095
       #      LET sr.omb14=sr.omb14*-1   #No.FUN-5B0139
       #      LET sr.omb14t=sr.omb14t*-1
       #      LET sr.omb16=sr.omb16*-1
       #      LET sr.omb16t=sr.omb16t*-1
       #   END IF
       #   #FUN-C80102--mark--str--
       #   #IF sr.oma00 = '21' AND sr.omb12_1 = 0 THEN
       #   #   LET sr.omb12_1 = 1
       #   #END IF
       #   #FUN-C80102--mark--end--
       #   LET g_amt=g_amt+sr.omb16t
       #   LET l_geb02 = '' 

       #   OPEN geb_c2  USING sr.occ21                 #MOD-B50224 mod USING 
       #   FETCH geb_c2 INTO l_geb02
 
       #   OPEN azi_c2  USING sr.oma23                   #MOD-B50224 mod USING 
       #   FETCH azi_c2 INTO sr.azi03,sr.azi04,sr.azi07  #MOD-940138 add sr.azi07
       #    SELECT azi05 INTO sr.azi05 FROM azi_file WHERE azi01=g_aza.aza17

       #   OPEN oga_c1  USING sr.oma16 
       #   FETCH oga_c1 INTO sr.oga02
       #   
       #   IF tm.b = 'N' THEN 
       #      LET sr.oma162=sr.oma161+sr.oma162
       #      LET sr.oma161=0
       #   END IF
       #   #FUN-C80092--modify--str--  #g_omb->g_omb_excel
       #   LET g_omb_excel[g_cnt].omb03  = sr.omb03
       #   LET g_omb_excel[g_cnt].omb04  = sr.omb04
       #   #LET g_omb_excel[g_cnt].omb06  = sr.omb06
       #   LET g_omb_excel[g_cnt].omb12  = sr.omb12
       #   LET g_omb_excel[g_cnt].omb05  = sr.omb05
       #   LET g_omb_excel[g_cnt].oma23  = sr.oma23
       #   LET g_omb_excel[g_cnt].oma24  = sr.oma24
       #   LET g_omb_excel[g_cnt].omb13  = sr.omb13
       #   LET g_omb_excel[g_cnt].omb14t = sr.omb14t
       #   LET g_omb_excel[g_cnt].omb15  = sr.omb15
       #   LET g_omb_excel[g_cnt].omb16t = sr.omb16t
       #   LET g_omb_excel[g_cnt].oma03  = sr.oma03
       #   LET g_omb_excel[g_cnt].oma032 = sr.oma032
       #   LET g_omb_excel[g_cnt].oma16  = sr.oma16
       #   LET g_omb_excel[g_cnt].oga02  = sr.oga02
       #   LET g_omb_excel[g_cnt].oma10  = sr.oma10
       #   LET g_omb_excel[g_cnt].oma01  = sr.oma01
       #   LET g_omb_excel[g_cnt].oma08  = sr.oma08

       #   LET g_num  = g_num  + g_omb_excel[g_cnt].omb12
       #   LET g_tot1 = g_tot1 + g_omb_excel[g_cnt].omb14t
       #   LET g_tot2 = g_tot2 + g_omb_excel[g_cnt].omb16t
       #   #FUN-C80092--modify--end-- 
  
       #   IF tm.g_auto_gen='Y' THEN
       #      INSERT INTO ckl_file VALUES('317',sr.omb31,sr.omb32,sr.omb04,sr.omb12,sr.omb16t,g_ccz.ccz01,g_ccz.ccz02)
       #   END IF

       #   #FUN-C80102--mark--str--
       #   #FUN-C80092--add--str--
       #   #IF g_cnt <= g_max_rec THEN
       #   #   LET g_omb[g_cnt].* = g_omb_excel[g_cnt].*    #FUN-C80102  mark
       #   #END IF 
       #   #FUN-C80092--add--end--
       #   
       #   #LET g_cnt = g_cnt + 1 
       #   #FUN-C80102--mark--end--
       #   
       #   #FUN-C80092--mark--str--
       #   #IF g_cnt > g_max_rec THEN
       #   #   CALL cl_err( '', 9035, 0 )
       #   #   EXIT FOREACH
       #   #END IF
       #   #FUN-C80092--mark--end--
       #   #FUN-C80092--add--str--
       #   INSERT INTO axrq378_tmp VALUES(sr.azp01,sr.oma03,sr.oma032,sr.oma68, 
       #                                  sr.oma69,sr.oma15,sr.gem02,sr.oma14,
       #                                  sr.gen02,sr.oma25,sr.oma26,sr.omb04,
       #                                  sr.ima02,sr.ima021,sr.oma10,sr.oma02,
       #                                  sr.omb38,sr.omb31,sr.omb32,sr.omb40,
       #                                  sr.azf03,sr.omb39,sr.oma08,sr.oma01,
       #                                  sr.omb03,sr.omb33,sr.aag02,sr.omb05,
       #                                  sr.omb12,sr.oma23,sr.oma24,sr.omb13,
       #                                  sr.omb14,sr.oma54x,sr.omb14t,sr.omb15,
       #                                  sr.omb16,sr.oma56x,sr.omb16t,l_ccc92,
       #                                  l_ccc62,l_s1,l_s2)
       #    #FUN-C80092--add--end--
       #END FOREACH
       #FUN-C80102--mark--end--
       
       #CALL g_omb.deleteElement(g_cnt)  #TQC-770016  #FUN-C80092 mark
       #FUN-C80102--mark--str--
       #FUN-C80092--add--str--
       #IF g_cnt <= g_max_rec THEN
       #   CALL g_omb.deleteElement(g_cnt)
       #END IF 
       #CALL g_omb_excel.deleteElement(g_cnt)
       #FUN-C80092--add--end--
       #LET g_rec_b=g_cnt-1
       #FUN-C80092--add--str--
       #IF g_rec_b > g_max_rec THEN  #FUN-C80092
       #IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
       #   CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
       #   LET g_rec_b = g_max_rec
       #END IF
       #FUN-C80092--add--end--
       #DISPLAY g_num TO FORMONLY.omb12sum
       #DISPLAY g_tot1 TO FORMONLY.omb14tsum
       #DISPLAY g_tot2 TO FORMONLY.omb16tsum
       #DISPLAY g_rec_b TO FORMONLY.cn2
       #FUN-C80102--mark--end--
#  END FOR
  # END FOR  #FUN-BB0173 add #TQC-D60039 mark

   #yinhy130708  --Begin
   #IF tm.g_auto_gen = 'Y' THEN
   #   CALL s_ckk_fill('','317','axc-462',g_yy,g_mm,g_prog,g_ccz.ccz28,g_num,g_tot2,g_tot2,0,0,0,0,0,0,0,l_msg,g_user,g_today,g_time,'Y')
   #         RETURNING g_ckk.*  #FUN-C80092 g_ccz->g_yy/mm
   #   IF NOT s_ckk(g_ckk.*,'') THEN END IF
   #END IF
   #yinhy130708  --End
  #-CHI-B60008-add-
   LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma161/100) omb16_after,",
             "       SUM(omb14*oma161/100) omb14_after,SUM((omb16t-omb16)*oma161/100) omb16t_omb16,",
             "       azi05,azi05_1,plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='11'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma162/100) omb16_after,",
             "       SUM(omb14*oma162/100) omb14_after,SUM((omb16t-omb16)*oma162/100) omb16t_omb16,",
             "       azi05,azi05_1, plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='12'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma163/100) omb16_after,",
             "       SUM(omb14*oma163/100) omb14_after,SUM(omb16t-omb16) omb16t_omb16,",
             "       azi05,azi05_1, plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='13'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16) omb16_after,",
             "       SUM(omb14) omb14_after,SUM(omb16t-omb16) omb16t_omb16,",
             "       azi05,azi05_1,plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE (oma00!='11' AND oma00!='12' AND oma00!='13') ",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant"   #FUN-BB0173 add plant
   PREPARE insert_prep1 FROM l_sql
   IF STATUS THEN
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   
      EXIT PROGRAM
   END IF
   EXECUTE insert_prep1
  #-CHI-B60008-end-
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092 
   DISPLAY TIME   #lujh test
END FUNCTION
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION q378_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("Group1",FALSE)
     LET g_flag = TRUE  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION q378_legal_db(p_string)
DEFINE p_string  STRING
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw09   LIKE azw_file.azw09
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_sql     STRING
   IF cl_null(p_string) THEN
      LET p_string = g_plant
   END IF
   LET g_ary_i = 1
   LET g_errno = ' '

   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
               "  WHERE azw01 IN ( ",p_string," ) "
   PREPARE r140_azw01_pre FROM l_sql
   DECLARE r140_azw01_cs CURSOR FOR r140_azw01_pre
   FOREACH r140_azw01_cs INTO g_ary[g_ary_i].plant
      LET g_ary_i = g_ary_i + 1
   END FOREACH
   LET g_ary_i = g_ary_i - 1

END FUNCTION

FUNCTION q378_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   #IF p_ud <> "G" THEN    #FUN-C80102  mark
   IF p_ud <> "G" OR g_action_choice = "detail" THEN    #FUN-C80102  mark
      RETURN
   END IF

   LET g_action_flag = 'page1'  #FUN-C80102 
   DISPLAY g_rec_b TO FORMONLY.cn2  #TQC-D60039

   #FUN-C80102--add--str---  
   IF g_action_choice = "page1"  AND NOT cl_null(tm.u) AND g_flag1 != '1' THEN
      CALL q378_b_fill_1()
   END IF
   #FUN-C80102--add--end---
   #TQC-D60039--add--str--
   IF g_action_choice = "page1" AND cl_null(tm.u) AND g_flag1='2' THEN
      CALL q378_b_fill_1()
   END IF
   #TQC-D60039--add--end
 
   LET g_action_choice = " "
   LET g_flag1 = ' '   #FUN-C80102  ad
   CALL cl_set_act_visible("accept,cancel", FALSE)

   #FUN-C80102--add---str--
   DISPLAY BY NAME tm.u,tm.c,tm.c1
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.c,tm.c1 FROM u,c,c1 ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.c = 'Y' THEN
               CALL cl_set_comp_entry("c1",TRUE)
            ELSE
               CALL cl_set_comp_entry("c1",FALSE)
            END IF
            
            IF NOT cl_null(tm.u)  THEN 
               CALL q378_b_fill_2()
               CALL q378_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q378_b_fill_1()
               CALL g_omb_1.clear()
               #TQC-D60039--mark--str--
               #DISPLAY 0  TO FORMONLY.cn2
               #DISPLAY 0  TO FORMONLY.omb12sum
               #DISPLAY 0  TO FORMONLY.omb14tsum
               ##DISPLAY 0  TO FORMONLY.omb16tsum   #TQC-CC0122  lujh mark
               #DISPLAY 0  TO FORMONLY.omb16sum     #TQC-CC0122  lujh add
               #DISPLAY 0  TO FORMONLY.ccc62sum
               #DISPLAY 0  TO FORMONLY.s1_sum
               #DISPLAY 0  TO FORMONLY.s2_sum
               #TQC-D60039--mark--end
            END IF
            DISPLAY BY NAME tm.u
            EXIT DIALOG

          ON CHANGE c
             IF NOT cl_null(tm.u) AND tm.c = 'Y' THEN
                CALL cl_set_comp_entry("c1",TRUE)
             ELSE
                CALL cl_set_comp_entry("c1",FALSE)
             END IF
             CALL q378()
             CALL q378_t()
             EXIT DIALOG

          ON CHANGE c1
             CALL q378_b_fill_2()
             CALL q378_set_visible()
             CALL cl_set_comp_visible("page1", FALSE)
             CALL ui.interface.refresh()
             CALL cl_set_comp_visible("page1", TRUE)
             LET g_action_choice = "page2"

      END INPUT  
   #FUN-C80102--add--end--
   
   #DISPLAY ARRAY g_omb TO s_omb.*          #FUN-C80102 mark
   #FUN-C80102--add--str--
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b)    
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
   END DISPLAY  
   #FUN-C80102--add--end--
   
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add 

#FUN-C80102--add--str--
      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q378_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 
  
#FUN-C80102--add--end--
 
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add 
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY   #FUN-C80102 mark
         CONTINUE DIALOG     #FUN-C80102 add
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY       #FUN-C80102 mark
         EXIT DIALOG         #FUN-C80102 add
 
      #AFTER DISPLAY         #FUN-C80102 mark
      #   CONTINUE DISPLAY   #FUN-C80102 mark
   #END DISPLAY    #FUN-C80102 mark
   END DIALOG      #FUN-C80102 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end

FUNCTION q378_set_entry_1()
    CALL cl_set_comp_entry("g_auto_gen",TRUE)
END FUNCTION

FUNCTION q378_set_no_entry_1()
    IF tm.bdate <> g_bdate OR tm.edate <> g_edate  THEN
       CALL cl_set_comp_entry("g_auto_gen",FALSE)
       LET tm.g_auto_gen = 'N'
       DISPLAY BY NAME tm.g_auto_gen
    END IF
    CALL cl_set_comp_visible("azp01_1",FALSE) #yinhy130510
END FUNCTION

#FUN-C80102--add--str--
FUNCTION q378_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_omb.clear()
   CALL g_omb_1.clear()
   #CALL cl_set_comp_visible("oma23,omb14,oma54x,omb14t",TRUE)  #TQC-CC0122 lujh mark
   CALL cl_set_comp_visible("oma23,omb14,",TRUE)                #TQC-CC0122 lujh add
   #DISPLAY BY NAME tm.u,tm.org,tm.d1,tm.d2,tm.c
   CONSTRUCT l_wc  ON oma03,oma032,oma68,oma69,oma15,gem02,oma14,gen02,oma25,oma26,omb04,
                      ima02,ima021,oma10,oma02,omb38,omb31,omb32,omb40,azf03,omb39,oma08,
                      oma01,omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,omb14,oma54x,omb14t,
                      omb15,omb16,omb16t,ccc92,ccc62,s1,s2
                 FROM s_omb[1].oma03,s_omb[1].oma032,s_omb[1].oma68,s_omb[1].oma69,
                      s_omb[1].oma15,s_omb[1].gem02,s_omb[1].oma14,s_omb[1].gen02,
                      s_omb[1].oma25,s_omb[1].oma26,s_omb[1].omb04,s_omb[1].ima02,
                      s_omb[1].ima021,s_omb[1].oma10,s_omb[1].oma02,s_omb[1].omb38,
                      s_omb[1].omb31,s_omb[1].omb32,s_omb[1].omb40,s_omb[1].azf03,
                      s_omb[1].omb39,s_omb[1].oma08,s_omb[1].oma01,s_omb[1].omb03,
                      s_omb[1].omb33,s_omb[1].aag02,s_omb[1].omb05,s_omb[1].omb12,
                      s_omb[1].oma23,s_omb[1].oma24,s_omb[1].omb13,s_omb[1].omb14,
                      s_omb[1].oma54x,s_omb[1].omb14t,s_omb[1].omb15,s_omb[1].omb16,
                      s_omb[1].omb16t,s_omb[1].ccc92,s_omb[1].ccc62,s_omb[1].s1,
                      s_omb[1].s2
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
   AFTER CONSTRUCT 
         IF tm.c = 'Y' THEN
            #CALL cl_set_comp_visible("oma23,omb14,oma54x,omb14t",TRUE)  #TQC-CC0122 lujh mark
            CALL cl_set_comp_visible("oma23,omb14",TRUE)                 #TQC-CC0122 lujh add
         ELSE
            CALL cl_set_comp_visible("oma23,omb14,oma54x,omb14t",FALSE)
         END IF
         IF tm.d = 'Y' THEN 
            CALL cl_set_comp_visible("ccc92,ccc62,s1,s2",TRUE)
         ELSE
            CALL cl_set_comp_visible("ccc92,ccc62,s1,s2",FALSE)
         END IF    

    ON ACTION CONTROLP
         IF INFIELD(omb04) THEN   
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO omb04    
            NEXT FIELD omb04                        
         END IF
         IF INFIELD(oma03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form = "q_occ"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO oma03
            NEXT FIELD oma03 
         END IF
         CASE 
         WHEN INFIELD(oma68)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma68
               NEXT FIELD oma68
         WHEN INFIELD(oma15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem3"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma15
               NEXT FIELD oma15 
         WHEN INFIELD(oma14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen5"
               LET g_qryparam.plant = g_plant
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma14
               NEXT FIELD oma14
          WHEN INFIELD(oma25)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma25"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma25
               NEXT FIELD oma25
          WHEN INFIELD(oma26)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma26"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma26
               NEXT FIELD oma26
          WHEN INFIELD(omb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima110"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omb04
               NEXT FIELD omb04
          WHEN INFIELD(omb40)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf4"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omb40
               NEXT FIELD omb40
          WHEN INFIELD(oma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oma02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oma01
               NEXT FIELD oma01
         END CASE 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()
	 
   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
  
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION

FUNCTION q378_b_fill_2()
DEFINE l_oma23  LIKE oma_file.oma23
DEFINE g_tot1   LIKE oma_file.oma56t
DEFINE g_tot2   LIKE oma_file.oma56t
DEFINE g_tot3   LIKE oma_file.oma56t
DEFINE g_tot4   LIKE oma_file.oma56t
DEFINE g_tot5   LIKE oma_file.oma56t
DEFINE g_tot6   LIKE oma_file.oma56t
DEFINE g_tot7   LIKE ccc_file.ccc62
DEFINE g_tot8   LIKE ccc_file.ccc62
DEFINE g_tot9   LIKE type_file.chr20

   CALL g_omb_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   LET g_tot1 = 0
   LET g_tot2 = 0
   LET g_tot3 = 0
   LET g_tot4 = 0
   LET g_tot5 = 0
   LET g_tot6 = 0
   LET g_tot4 = 0
   LET g_tot5 = 0
   LET g_tot6 = 0
   LET g_tot7 = 0
   LET g_tot8 = 0
   LET g_tot9 = 0

   IF tm.c1 = "Y" THEN
      LET g_sql = " SELECT distinct oma23 FROM axrq378_tmp ORDER BY oma23"

      PREPARE q378_bp_d FROM g_sql
      DECLARE q378_curs_d CURSOR FOR q378_bp_d
      FOREACH q378_curs_d INTO l_oma23
         CALL q378_get_sum(l_oma23)
         LET g_tot1 = g_tot1 + g_omb_1[g_cnt].omb14
         LET g_tot2 = g_tot2 + g_omb_1[g_cnt].oma54x
         LET g_tot3 = g_tot3 + g_omb_1[g_cnt].omb14t
         LET g_tot4 = g_tot4 + g_omb_1[g_cnt].omb16
         LET g_tot5 = g_tot5 + g_omb_1[g_cnt].oma56x
         LET g_tot6 = g_tot6 + g_omb_1[g_cnt].omb16t
         LET g_tot7 = g_tot6 + g_omb_1[g_cnt].ccc62
         LET g_tot8 = g_tot8 + g_omb_1[g_cnt].s1
         LET g_cnt = g_cnt + 1
      #   IF g_cnt > g_max_rec THEN
      #      CALL cl_err( '', 9035, 0 )
      #      EXIT FOREACH
      #   END IF 
      END FOREACH
      LET g_tot9 = g_tot8/g_tot4*100
      DISPLAY g_tot3 TO FORMONLY.omb14tsum
      #DISPLAY g_tot6 TO FORMONLY.omb16tsum    #TQC-CC0122  lujh mark
      DISPLAY g_tot4 TO FORMONLY.omb16sum      #TQC-CC0122  lujh add
      DISPLAY g_tot7 TO FORMONLY.ccc62sum
      DISPLAY g_tot8 TO FORMONLY.s1_sum
      DISPLAY g_tot9 TO FORMONLY.s2_sum
   ELSE
      CALL q378_get_sum('')
   END IF      
 
END FUNCTION

FUNCTION q378_table()
   DROP TABLE axrq378_tmp;
      CREATE TEMP TABLE axrq378_tmp(
                azp01   LIKE azp_file.azp01,
                oma03   LIKE oma_file.oma03,
                oma032  LIKE oma_file.oma032,
                oma68   LIKE oma_file.oma68, 
                oma69   LIKE oma_file.oma69, 
                oma15   LIKE oma_file.oma15,
                gem02   LIKE gem_file.gem02,
                oma14   LIKE oma_file.oma14,
                gen02   LIKE gen_file.gen02,
                oma25   LIKE oma_file.oma25,
                oma26   LIKE oma_file.oma26,
                omb04   LIKE omb_file.omb04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                oma10   LIKE oma_file.oma10,
                oma02   LIKE oma_file.oma02,
                omb38   LIKE omb_file.omb38,
                omb31   LIKE omb_file.omb31,
                omb32   LIKE omb_file.omb32,
                omb40   LIKE omb_file.omb40,
                azf03   LIKE azf_file.azf03,
                omb39   LIKE omb_file.omb39,
                oma08   LIKE oma_file.oma08,
                oma33   LIKE oma_file.oma33,   #No.FUN-D30049   Add
                aba02   LIKE aba_file.aba02,   #No.FUN-D30049   Add
                oma01   LIKE oma_file.oma01,
                omb03   LIKE omb_file.omb03,
                omb33   LIKE omb_file.omb33,
                aag02   LIKE aag_file.aag02,  
                omb05   LIKE omb_file.omb05,
                omb12   LIKE omb_file.omb12,
                oma23   LIKE oma_file.oma23,
                oma24   LIKE oma_file.oma24,
                omb13   LIKE omb_file.omb13,
                omb14   LIKE omb_file.omb14,
                oma54x  LIKE oma_file.oma54x,
                omb14t  LIKE omb_file.omb14t,
                omb15   LIKE omb_file.omb15,
                omb16   LIKE omb_file.omb16,
                oma56x  LIKE oma_file.oma56x,
                omb16t  LIKE omb_file.omb16t,
                ccc92   LIKE ccc_file.ccc92,
                ccc62   LIKE ccc_file.ccc62,
                s1      LIKE type_file.num20_6,
                s2      LIKE type_file.num20_6 )
     
END FUNCTION

FUNCTION q378_get_sum(p_oma23)
DEFINE p_oma23 LIKE oma_file.oma23
DEFINE l_tot1   LIKE oma_file.oma56t
DEFINE l_tot2   LIKE oma_file.oma56t
DEFINE l_tot3   LIKE oma_file.oma56t
DEFINE l_tot4   LIKE oma_file.oma56t
DEFINE l_tot5   LIKE oma_file.oma56t
DEFINE l_tot6   LIKE oma_file.oma56t
DEFINE l_tot7   LIKE ccc_file.ccc62
DEFINE l_tot8   LIKE ccc_file.ccc62
DEFINE l_tot9   LIKE type_file.chr20
DEFINE l_tot10  LIKE type_file.chr20
DEFINE l_cnt    LIKE type_file.num5   #No.FUN-D20032

LET l_tot1 = 0 
LET l_tot2 = 0 
LET l_tot3 = 0 
LET l_tot4 = 0 
LET l_tot5 = 0 
LET l_tot6 = 0
LET l_tot7 = 0 
LET l_tot8 = 0 
LET l_tot9 = 0 
LET l_tot10 = 0 
LET g_cnt = 1

  CASE tm.u 
     WHEN "1"
        IF tm.c = 'Y' THEN 
           LET g_sql = "SELECT '',oma03,'',oma68,'','','','','','','','','','','','','',",
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",   #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
           LET g_sql = "SELECT '',oma03,'',oma68,'','','','','','','','','','','','','',",
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",     #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma03,oma68,oma23 ",
                       " ORDER BY oma03,oma68,oma23 "      
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma03,oma68 ",
                       " ORDER BY oma03,oma68 " 
        END IF 
        
        PREPARE q378_pb1 FROM g_sql
        DECLARE q378_curs_1 CURSOR FOR q378_pb1
        FOREACH q378_curs_1 INTO g_omb_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT distinct oma032 INTO g_omb_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_omb_1[g_cnt].oma03
           SELECT distinct oma69 INTO g_omb_1[g_cnt].oma69 FROM oma_file WHERE oma68 = g_omb_1[g_cnt].oma68
           #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
           LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100         #yinhy130708

           IF tm.c1 = "N" THEN  
              LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
              LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
              LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
           END IF
           IF tm.c1 ="Y" THEN
              LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
              LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
              LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
              LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
              LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
              LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
           END IF
           IF tm.d = 'Y' THEN 
              LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
              LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
              LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
           END IF 
           LET g_cnt = g_cnt + 1
    #       IF g_cnt > g_max_rec THEN
    #          CALL cl_err( '', 9035, 0 )
    #          EXIT FOREACH
    #       END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

     WHEN "2"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '','','','','',oma15,'','','','','','','','','','','', ",
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",       #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",    
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
           LET g_sql = "SELECT '','','','','',oma15,'','','','','','','','','','','', ",
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",         #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma15,oma23 ",
                       " ORDER BY oma15,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma15 ",
                       " ORDER BY oma15 "
        END IF 
        
        PREPARE q378_pb2 FROM g_sql
        DECLARE q378_curs_2 CURSOR FOR q378_pb2
        FOREACH q378_curs_2 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct gem02 INTO g_omb_1[g_cnt].gem02 FROM gem_file WHERE gem01 = g_omb_1[g_cnt].oma15
         #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
         LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100          #yinhy130708
        
        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF 
        LET g_cnt = g_cnt + 1
      #  IF g_cnt > g_max_rec THEN
      #     CALL cl_err( '', 9035, 0 )
      #     EXIT FOREACH
      #  END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

     WHEN "3"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '','','','','',oma15,'',oma14,'','','','','','','','','', ",  
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
            LET g_sql = "SELECT '','','','','',oma15,'',oma14,'','','','','','','','','', ",  
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma15,oma14,oma23 ",
                       " ORDER BY oma15,oma14,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma15,oma14 ",
                       " ORDER BY oma15,oma14 "
        END IF      
        
        PREPARE q378_pb3 FROM g_sql
        DECLARE q378_curs_3 CURSOR FOR q378_pb3
        FOREACH q378_curs_3 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct gem02 INTO g_omb_1[g_cnt].gem02 FROM gem_file WHERE gem01 = g_omb_1[g_cnt].oma15
        SELECT distinct gen02 INTO g_omb_1[g_cnt].gen02 FROM gen_file WHERE gen01 = g_omb_1[g_cnt].oma14
         #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
         LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100       #yinhy130708
        
        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF
        LET g_cnt = g_cnt + 1
     #   IF g_cnt > g_max_rec THEN
     #      CALL cl_err( '', 9035, 0 )
     #      EXIT FOREACH
     #   END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

     WHEN "4"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '','','','','','','','','','','',omb04,'','','','','', ",  
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",       #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
           LET g_sql = "SELECT '','','','','','','','','','','',omb04,'','','','','', ",  
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",         #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY omb04,oma23 ",
                       " ORDER BY omb04,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY omb04 ",
                       " ORDER BY omb04 "
        END IF 
        
        PREPARE q378_pb4 FROM g_sql
        DECLARE q378_curs_4 CURSOR FOR q378_pb4
#No.FUN-D20032 --begin
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT COUNT(*)  ",     
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED,
                       "    AND omb04 = ? ",
                       "    AND oma23 = ? "
        ELSE
           LET g_sql = "SELECT COUNT(*)  ",     
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED,
                       "    AND omb04 = ?"
        END IF 
        PREPARE q378_pb41 FROM g_sql
        DECLARE q378_curs_41 CURSOR FOR q378_pb41
#No.FUN-D20032 --end
        FOREACH q378_curs_4 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
#No.FUN-D20032 --begin
        IF tm.c = 'Y' THEN
           OPEN q378_curs_41 USING g_omb_1[g_cnt].omb04,p_oma23
        ELSE
           OPEN q378_curs_41 USING g_omb_1[g_cnt].omb04
        END IF
        FETCH q378_curs_41 INTO l_cnt
        LET g_omb_1[g_cnt].ccc92 = g_omb_1[g_cnt].ccc92/l_cnt
        LET g_omb_1[g_cnt].omb15 = cl_digcut(g_omb_1[g_cnt].omb15,2)
#No.FUN-D20032 --end
        SELECT distinct ima02,ima021 INTO g_omb_1[g_cnt].ima02,g_omb_1[g_cnt].ima021 FROM ima_file WHERE ima01 = g_omb_1[g_cnt].omb04
        #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
        LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100        #yinhy130708
        
        
        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF
        LET g_cnt = g_cnt + 1
      #  IF g_cnt > g_max_rec THEN
      #     CALL cl_err( '', 9035, 0 )
      #     EXIT FOREACH
      #  END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

     WHEN "5"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '','','','','','','','','','','','','','',oma08,'','', ",
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t), ",       #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
           LET g_sql = "SELECT '','','','','','','','','','','','','','',oma08,'','', ",
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t), ",        #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma08,oma23 ",
                       " ORDER BY oma08,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma08 ",
                       " ORDER BY oma08 "
        END IF 

        PREPARE q378_pb5 FROM g_sql
        DECLARE q378_curs_5 CURSOR FOR q378_pb5
        FOREACH q378_curs_5 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'  #yinhy130708
        LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100       #yinhy130708
        
        #TQC-CC0122--mark--str--
        #CASE g_omb_1[g_cnt].oma08
        #  WHEN  '1'
        #       LET g_omb_1[g_cnt].oma08  = cl_getmsg('axr-809',g_lang)
        #  WHEN  '2' 
        #       LET g_omb_1[g_cnt].oma08  = cl_getmsg('axr-810',g_lang) 
        #  WHEN  '3' 
        #       LET g_omb_1[g_cnt].oma08  = cl_getmsg('axr-811',g_lang)
        #END CASE
        #TQC-CC0122--mark--end--

        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF
        LET g_cnt = g_cnt + 1
      #  IF g_cnt > g_max_rec THEN
      #     CALL cl_err( '', 9035, 0 )
      #     EXIT FOREACH
      #  END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

    WHEN "6"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '','','','','','','','','','','','','','','',omb33,'', ",
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",        #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc,
                       "    AND omb33 IS NOT NULL"   #130106  lujh add
        ELSE
           LET g_sql = "SELECT '','','','','','','','','','','','','','','',omb33,'', ",
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",         #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",  
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc,
                       "    AND omb33 IS NOT NULL"   #130106  lujh add
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY omb33,oma23 ",
                       " ORDER BY omb33,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY omb33 ",
                       " ORDER BY omb33 "
        END IF 
        
        PREPARE q378_pb6 FROM g_sql
        DECLARE q378_curs_6 CURSOR FOR q378_pb6
        FOREACH q378_curs_6 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct aag02 INTO g_omb_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_omb_1[g_cnt].omb33
        #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
        LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100       #yinhy130708
        
        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF
        LET g_cnt = g_cnt + 1
      #  IF g_cnt > g_max_rec THEN
      #     CALL cl_err( '', 9035, 0 )
      #     EXIT FOREACH
      #  END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100

    WHEN "7"
        IF tm.c = 'Y' THEN
           LET g_sql = "SELECT '',oma03,'','','','','','','','','','','','','',omb33,'', ",
                       " oma23,SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",         #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",    
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        ELSE
           LET g_sql = "SELECT '',oma03,'','','','','','','','','','','','','',omb33,'', ",
                       " '',SUM(omb14),SUM(oma54x),SUM(omb14t),SUM(omb16),SUM(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END ,SUM(oma56x),SUM(omb16t),",         #No.FUN-D20032 add sum(omb12),CASE WHEN SUM(omb12) = 0 THEN 0 ELSE SUM(omb16)/SUM(omb12) END 
                       " SUM(ccc92),SUM(ccc62),SUM(s1),''",   
                       "  FROM axrq378_tmp ",
                       "  WHERE ",g_filter_wc CLIPPED
        END IF 
        
        IF tm.c1 = "Y" THEN LET g_sql = g_sql CLIPPED," AND  oma23 = '",p_oma23,"' " END IF
        IF tm.c = 'Y' THEN
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma03,omb33,oma23 ",
                       " ORDER BY oma03,omb33,oma23 "
        ELSE
           LET g_sql = g_sql CLIPPED,
                       " GROUP BY oma03,omb33 ",
                       " ORDER BY oma03,omb33 "
        END IF 
        
        PREPARE q378_pb7 FROM g_sql
        DECLARE q378_curs_7 CURSOR FOR q378_pb7
        FOREACH q378_curs_7 INTO g_omb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT distinct aag02 INTO g_omb_1[g_cnt].aag02 FROM aag_file WHERE aag01 = g_omb_1[g_cnt].omb33
        SELECT distinct oma032 INTO g_omb_1[g_cnt].oma032 FROM oma_file WHERE oma03 = g_omb_1[g_cnt].oma03
        #LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100,'%'
        LET g_omb_1[g_cnt].s2 = g_omb_1[g_cnt].s1/g_omb_1[g_cnt].omb16*100        #yinhy130708
        
        IF tm.c1 = "N" THEN
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.c1 ="Y" THEN
           LET l_tot1 = l_tot1 + g_omb_1[g_cnt].omb14
           LET l_tot2 = l_tot2 + g_omb_1[g_cnt].oma54x
           LET l_tot3 = l_tot3 + g_omb_1[g_cnt].omb14t
           LET l_tot4 = l_tot4 + g_omb_1[g_cnt].omb16
           LET l_tot5 = l_tot5 + g_omb_1[g_cnt].oma56x
           LET l_tot6 = l_tot6 + g_omb_1[g_cnt].omb16t
        END IF
        IF tm.d = 'Y' THEN 
            LET l_tot7 = l_tot7 + g_omb_1[g_cnt].ccc62
            LET l_tot8 = l_tot8 + g_omb_1[g_cnt].s1
            LET l_tot10 = l_tot10 + g_omb_1[g_cnt].ccc92
        END IF
        LET g_cnt = g_cnt + 1
     #   IF g_cnt > g_max_rec THEN
     #      CALL cl_err( '', 9035, 0 )
     #      EXIT FOREACH
     #   END IF
        END FOREACH
        LET l_tot9 = l_tot8/l_tot4*100
    END CASE
    #IF tm.c1 = 'N' THEN 
      #DISPLAY l_tot3 TO FORMONLY.omb14tsum
      #DISPLAY l_tot6 TO FORMONLY.omb16tsum       #TQC-CC0122  lujh mark
    IF g_action_flag='page2' THEN #TQC-D60039   
      DISPLAY l_tot4 TO FORMONLY.omb16sum         #TQC-CC0122  lujh add
    END IF  #TQC-D60039
    #END IF
    #IF tm.d = 'Y' THEN  #TQC-D60039 mark
    IF tm.d = 'Y' AND  g_action_flag='page2' THEN #TQC-D60039
       DISPLAY l_tot7 TO FORMONLY.ccc62sum
       DISPLAY l_tot8 TO FORMONLY.s1_sum
       DISPLAY l_tot9 TO FORMONLY.s2_sum
    END IF 
    
    IF tm.c1 = 'Y' THEN 
       LET g_omb_1[g_cnt].oma23  = cl_getmsg('amr-003',g_lang)
       LET g_omb_1[g_cnt].omb14  = l_tot1
       LET g_omb_1[g_cnt].oma54x = l_tot2
       LET g_omb_1[g_cnt].omb14t = l_tot3
       LET g_omb_1[g_cnt].omb16  = l_tot4
       LET g_omb_1[g_cnt].oma56x = l_tot5
       LET g_omb_1[g_cnt].omb16t = l_tot6
       LET g_omb_1[g_cnt].ccc62 = l_tot7
       LET g_omb_1[g_cnt].s1 =  l_tot8
       #LET g_omb_1[g_cnt].s2 =  l_tot9,'%'     #yinhy130708
       LET g_omb_1[g_cnt].s2 =  l_tot9          #yinhy130708
       LET g_omb_1[g_cnt].ccc92 = l_tot10
    END IF      
    DISPLAY ARRAY g_omb_1 TO s_omb_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY
    IF tm.c1 != 'Y' THEN   
       CALL g_omb_1.deleteElement(g_cnt)
       LET g_rec_b2 = g_cnt - 1
    ELSE
       LET g_rec_b2 = g_cnt 
    END IF
    IF g_rec_b2 <> '0' THEN 
       DISPLAY g_rec_b2 TO FORMONLY.cn2   
    END IF 
END FUNCTION

FUNCTION q378_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_tot11   LIKE omb_file.omb12
DEFINE l_tot21   LIKE oma_file.oma56t
DEFINE l_tot31   LIKE oma_file.oma56t
DEFINE l_tot41   LIKE oma_file.oma56t
DEFINE l_tot51   LIKE oma_file.oma56t
DEFINE l_tot61   LIKE oma_file.oma56t
DEFINE l_tot71   LIKE oma_file.oma56t
DEFINE l_tot81   LIKE ccc_file.ccc62
DEFINE l_tot91   LIKE ccc_file.ccc62
DEFINE l_tot10   LIKE type_file.chr20
DEFINE l_tot01   LIKE oma_file.oma56t
DEFINE l_mm1     STRING
DEFINE l_mm2     STRING
DEFINE l_yy      STRING
DEFINE l_s2      LIKE type_file.num20_6    #lujh TQC-CC0122  add
DEFINE l_tmp     LIKE type_file.num10      #lujh TQC-CC0122  add

   LET l_tot11 = 0
   LET l_tot21 = 0
   LET l_tot31 = 0
   LET l_tot41 = 0
   LET l_tot51 = 0
   LET l_tot61 = 0
   LET l_tot71 = 0
   LET l_tot81 = 0
   LET l_tot91 = 0
   LET l_tot10 = 0
   LET l_tot01 = 0
   CASE tm.u
      WHEN '1'
         IF tm.c = 'Y' THEN 
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma03 = '",g_omb_1[p_ac].oma03,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'",
                        "   AND oma68 = '",g_omb_1[p_ac].oma68,"'",
                        " ORDER BY oma03,oma68,oma23 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma03 = '",g_omb_1[p_ac].oma03,"'",
                        "   AND oma68 = '",g_omb_1[p_ac].oma68,"'",
                        " ORDER BY oma03,oma68 "
         END IF 

        PREPARE axrq378_pb_detail1 FROM g_sql
        DECLARE omb_curs_detail1  CURSOR FOR axrq378_pb_detail1        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail1 INTO g_omb[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)       #yinhy130708
           
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH
        LET l_tot10 = l_tot91/l_tot01*100
        

      WHEN '2'
         IF tm.c = 'Y' THEN 
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma15 = '",g_omb_1[p_ac].oma15,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'",
                        " ORDER BY oma15,oma23 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma15 = '",g_omb_1[p_ac].oma15,"'",
                        " ORDER BY oma15 "
         END IF 

        PREPARE axrq378_pb_detail2 FROM g_sql
        DECLARE omb_curs_detail2  CURSOR FOR axrq378_pb_detail2        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail2 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)       #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH 
        LET l_tot10 = l_tot91/l_tot01*100

      WHEN '3'
         IF tm.c = 'Y' THEN 
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma23 = '",g_omb_1[p_ac].oma23,"'",
                        "   AND oma14 = '",g_omb_1[p_ac].oma14,"' ",
                        " ORDER BY oma14,oma23 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma14 = '",g_omb_1[p_ac].oma14,"' ",
                        " ORDER BY oma14 "
         END IF 
         

        PREPARE axrq378_pb_detail3 FROM g_sql
        DECLARE omb_curs_detail3  CURSOR FOR axrq378_pb_detail3        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail3 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)         #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH 
        LET l_tot10 = l_tot91/l_tot01*100
    
      WHEN '4'
         IF tm.c = 'Y' THEN 
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE omb04 = '",g_omb_1[p_ac].omb04,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'",
                        " ORDER BY omb04,oma032 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE omb04 = '",g_omb_1[p_ac].omb04,"'",
                        " ORDER BY omb04,oma032 "
         END IF 
         

        PREPARE axrq378_pb_detail4 FROM g_sql
        DECLARE omb_curs_detail4  CURSOR FOR axrq378_pb_detail4        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail4 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"    
           LET g_omb[g_cnt].s2 = (l_tmp/100)         #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH
        LET l_tot10 = l_tot91/l_tot01*100

     WHEN '5'
         IF tm.c = 'Y' THEN 
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma08 = '",g_omb_1[p_ac].oma08,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'",
                        " ORDER BY oma08,oma032 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma08 = '",g_omb_1[p_ac].oma08,"'",
                        " ORDER BY oma08,oma032 "
         END IF 
         

        PREPARE axrq378_pb_detail5 FROM g_sql
        DECLARE omb_curs_detail5  CURSOR FOR axrq378_pb_detail5        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail5 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)          #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH
        LET l_tot10 = l_tot91/l_tot01*100

     WHEN '6'
         IF tm.c = 'Y' THEN
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp "
            #TQC-D60039--MOD--str--
                       #" WHERE omb33 = '",g_omb_1[p_ac].omb33,"'",
            IF cl_null(g_omb_1[p_ac].omb33) THEN
               LET g_sql=g_sql," WHERE trim(omb33) IS NULL"
            ELSE
               LET g_sql=g_sql," WHERE omb33 = '",g_omb_1[p_ac].omb33,"'"
            END IF
            LET g_sql=g_sql,
            #TQC-D60039--MOD--end
                        "   AND oma23 = '",g_omb_1[p_ac].oma23,"'",
                        " ORDER BY omb33,oma032 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp "
                        #" WHERE omb33 = '",g_omb_1[p_ac].omb33,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'",  #TQC-CC0122 mark
            #TQC-D60039--MOD--str--
                       #" WHERE omb33 = '",g_omb_1[p_ac].omb33,"'",    #TQC-CC0122 add
            IF cl_null(g_omb_1[p_ac].omb33) THEN
               LET g_sql=g_sql," WHERE trim(omb33) IS NULL"
            ELSE
               LET g_sql=g_sql," WHERE omb33 = '",g_omb_1[p_ac].omb33,"'"
            END IF
            LET g_sql=g_sql,
            #TQC-D60039--MOD--end
                        " ORDER BY omb33,oma032 "
         END IF 
         
        PREPARE axrq378_pb_detail6 FROM g_sql
        DECLARE omb_curs_detail6  CURSOR FOR axrq378_pb_detail6        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail6 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)          #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH
        LET l_tot10 = l_tot91/l_tot01*100

      WHEN '7'
         IF tm.c = 'Y' THEN
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma03 = '",g_omb_1[p_ac].oma03,"' AND oma23 = '",g_omb_1[p_ac].oma23,"'"
            #TQC-D60039--MOD--str--
                       #"   AND omb33 = '",g_omb_1[p_ac].omb33,"'",
            IF cl_null(g_omb_1[p_ac].omb33) THEN
               LET g_sql=g_sql," AND trim(omb33) IS NULL"
            ELSE
               LET g_sql=g_sql," AND omb33 = '",g_omb_1[p_ac].omb33,"'"
            END IF
            LET g_sql=g_sql,
            #TQC-D60039--MOD--end
                        " ORDER BY oma03,omb33,oma032 "
         ELSE
            LET g_sql = "SELECT azp01,oma03,oma032,oma68,oma69,oma15,gem02,oma14,",
                        " gen02,oma25,oma26,omb04,ima02,ima021,oma10,oma02,",
                        " omb38,omb31,omb32,omb40,azf03,omb39,oma08,oma33,aba02,oma01,", #TQC-D60039 add oma33,aba02
                        " omb03,omb33,aag02,omb05,omb12,oma23,oma24,omb13,",
                        " omb14,oma54x,omb14t,omb15,omb16,oma56x,omb16t,",
                        " ccc92,ccc62,s1,s2 ",
                        " FROM axrq378_tmp ",
                        " WHERE oma03 = '",g_omb_1[p_ac].oma03,"'"
            #TQC-D60039--MOD--str--
                       #"   AND omb33 = '",g_omb_1[p_ac].omb33,"'",
            IF cl_null(g_omb_1[p_ac].omb33) THEN
               LET g_sql=g_sql," AND trim(omb33) IS NULL"
            ELSE
               LET g_sql=g_sql," AND omb33 = '",g_omb_1[p_ac].omb33,"'"
            END IF
            LET g_sql=g_sql,
            #TQC-D60039--MOD--end
                        " ORDER BY oma03,omb33,oma032 "
         END IF 
         

        PREPARE axrq378_pb_detail7 FROM g_sql
        DECLARE omb_curs_detail7  CURSOR FOR axrq378_pb_detail7        #CURSOR
        CALL g_omb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH omb_curs_detail7 INTO g_omb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           SELECT aag02 INTO g_omb[g_cnt].aag02  FROM aag_file WHERE aag01 = g_omb[g_cnt].omb33 #TQC-D60039
           #TQC-CC0122--add--str--
           LET l_s2 = g_omb[g_cnt].s2
           LET l_tmp = l_s2 * 100
           #LET g_omb[g_cnt].s2 = (l_tmp/100),"%"
           LET g_omb[g_cnt].s2 = (l_tmp/100)         #yinhy130708
           #TQC-CC0122--add--end--
           LET l_tot11 = l_tot11 + g_omb[g_cnt].omb12
           LET l_tot21 = l_tot21 + g_omb[g_cnt].omb14t
           LET l_tot31 = l_tot31 + g_omb[g_cnt].omb16t
           LET l_tot81 = l_tot81 + g_omb[g_cnt].ccc62
           LET l_tot91 = l_tot91 + g_omb[g_cnt].s1
           LET l_tot01 = l_tot01 + g_omb[g_cnt].omb16
           LET g_cnt = g_cnt + 1  
        END FOREACH
        LET l_tot10 = l_tot91/l_tot01*100
   END CASE
   DISPLAY l_tot11 TO FORMONLY.omb12sum
   DISPLAY l_tot21 TO FORMONLY.omb14tsum
   #DISPLAY l_tot31 TO FORMONLY.omb16tsum      #TQC-CC0122  lujh mark
   DISPLAY l_tot01 TO FORMONLY.omb16sum        #TQC-CC0122  lujh add
   DISPLAY l_tot81 TO FORMONLY.ccc62sum
   DISPLAY l_tot91 TO FORMONLY.s1_sum
   DISPLAY l_tot10 TO FORMONLY.s2_sum
   CALL g_omb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2   
END FUNCTION

FUNCTION q378_b_fill_3()
DEFINE l_oma03   LIKE oma_file.oma03
DEFINE g_tot11   LIKE oma_file.oma56t
DEFINE g_tot21   LIKE oma_file.oma56t
DEFINE g_tot31   LIKE oma_file.oma56t
DEFINE g_tot41   LIKE ccc_file.ccc62
DEFINE g_tot51   LIKE ccc_file.ccc62
DEFINE g_tot61   LIKE type_file.chr20
DEFINE g_tot71   LIKE oma_file.oma56t
DEFINE l_s2      LIKE type_file.num20_6
DEFINE l_tmp     LIKE type_file.num10
DEFINE l_msg     STRING                    #yinhy130708
DEFINE l_ima31_fac LIKE ima_file.ima31_fac   #add by jiangln 160709
DEFINE l_ima25  LIKE ima_file.ima25   #add by jiangln 160709
DEFINE l_cnt    LIKE type_file.num10   #add by jiangln 160712
DEFINE g_cnt    LIKE type_file.num10   #add by jiangln 160712
DEFINE l_yy     LIKE type_file.num10   #add by jiangln 160712
DEFINE l_mm     LIKE type_file.num10   #add by jiangln 160712
DEFINE l_yyy    LIKE type_file.num10   #add by jiangln 160712
DEFINE l_mmm    LIKE type_file.num10   #add by jiangln 160712

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   LET g_sql = "SELECT * FROM axrq378_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               #" ORDER BY oma01,oma02,oma03 "
               " ORDER BY oma03,omb04,omb31,omb32,oma01,omb03"    #TQC-CC0122 add

   PREPARE axrq378_pb1 FROM g_sql
   DECLARE omb_curs1  CURSOR FOR axrq378_pb1        #CURSOR

   CALL g_omb.clear()
   LET g_cnt = 1
   LET g_cnt1 = 1
   LET g_rec_b = 0

   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0
   LET g_tot61 = 0
   LET g_tot71 = 0
   

   CALL g_omb_excel.clear()  #add by jiangln 160712
   FOREACH omb_curs1 INTO g_omb_excel[g_cnt1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      #TQC-CC0122--add--str--
      #TQC-D60039--mark--str--
      #SELECT gem02 INTO g_omb_excel[g_cnt1].gem02 FROM gem_file WHERE gem01 = g_omb_excel[g_cnt1].oma15
      #SELECT gen02 INTO g_omb_excel[g_cnt1].gen02 FROM gen_file WHERE gen01 = g_omb_excel[g_cnt1].oma14
      #SELECT ima02,ima021 INTO g_omb_excel[g_cnt1].ima02,g_omb_excel[g_cnt1].ima021 FROM ima_file WHERE ima01 = g_omb_excel[g_cnt1].omb04
      #TQC-D60039--mark--end
      SELECT aag02 INTO g_omb_excel[g_cnt1].aag02 FROM aag_file WHERE aag01 = g_omb_excel[g_cnt1].omb33
      #SELECT azf03 INTO g_omb_excel[g_cnt1].azf03 FROM azf_file WHERE azf01 = g_omb_excel[g_cnt1].omb40 #TQC-D60039  
      #TQC-CC0122--add--end--
#add by jiangln 160709 start-------
#add by jiangln 160712 start------
      IF tm.e = '4' THEN
         IF g_omb_excel[g_cnt1].omb38 = '2' THEN 
          SELECT substr(to_char(oga02,'yyyymmdd'),1,4),substr(to_char(oga02,'yyyymmdd'),5,2) INTO l_yy,l_mm FROM oga_file WHERE oga01 = g_omb_excel[g_cnt1].omb31
         END IF
        IF g_omb_excel[g_cnt1].omb38 = '3' THEN 
          SELECT substr(to_char(oha02,'yyyymmdd'),1,4),substr(to_char(oha02,'yyyymmdd'),5,2) INTO l_yy,l_mm FROM oha_file WHERE oha01 = g_omb_excel[g_cnt1].omb31
        END IF
          SELECT substr(to_char(tm.bdate,'yyyymmdd'),1,4),substr(to_char(tm.bdate,'yyyymmdd'),5,2) INTO l_yyy,l_mmm FROM dual
          IF (l_yy != l_yyy OR l_mm != l_mmm) THEN
#170802 luoyb mark
#                SELECT ccc23 INTO g_omb_excel[g_cnt1].ccc92 FROM ccc_file WHERE ccc01 = g_omb_excel[g_cnt1].omb04 AND ccc02 = l_yy AND ccc03 = l_mm
#                IF cl_null(g_omb_excel[g_cnt1].ccc92) THEN 
#                    LET g_omb_excel[g_cnt1].ccc92 = 0
#                END IF 
          END IF 
      END IF
#add by jiangln 160712 end-----
      SELECT ima25 INTO l_ima25 FROM ima_file
       WHERE ima01 = g_omb_excel[g_cnt1].omb04
      CALL s_umfchk(g_omb_excel[g_cnt1].omb04,g_omb_excel[g_cnt1].omb05,l_ima25) RETURNING g_cnt,l_ima31_fac
      IF g_cnt = 1 THEN LET l_ima31_fac = 1 END IF
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM ogb_file 
       WHERE ogb01 = g_omb_excel[g_cnt1].omb31 AND ogb03 = g_omb_excel[g_cnt1].omb32 AND ogb09 IN (SELECT jce02 FROM jce_file)
      IF l_cnt>0 THEN
        LET g_omb_excel[g_cnt1].ccc92 = 0
        LET g_omb_excel[g_cnt1].ccc62 = 0
      END IF 
      IF g_omb_excel[g_cnt1].omb38 = '3' THEN
         IF g_omb_excel[g_cnt1].omb16 >0 THEN 
          LET g_omb_excel[g_cnt1].omb16 = g_omb_excel[g_cnt1].omb16*(-1)
         END IF 
         IF g_omb_excel[g_cnt1].omb12 >0 THEN 
          LET g_omb_excel[g_cnt1].omb12 = g_omb_excel[g_cnt1].omb12*(-1)
          LET g_omb_excel[g_cnt1].ccc62 = g_omb_excel[g_cnt1].ccc92*g_omb_excel[g_cnt1].omb12*l_ima31_fac
         ELSE
            IF g_omb_excel[g_cnt1].omb12 <0 THEN 
                LET g_omb_excel[g_cnt1].ccc62 = g_omb_excel[g_cnt1].ccc92*g_omb_excel[g_cnt1].omb12*l_ima31_fac
            ELSE
                LET g_omb_excel[g_cnt1].ccc62 = 0
            END IF     
         END IF 
      ELSE 
         IF tm.e = '4' THEN 
          LET g_omb_excel[g_cnt1].ccc62 = g_omb_excel[g_cnt1].ccc92*g_omb_excel[g_cnt1].omb12*l_ima31_fac
         ELSE
          LET g_omb_excel[g_cnt1].ccc62 = g_omb_excel[g_cnt1].ccc62*l_ima31_fac
         END IF 
      END IF 
      LET g_omb_excel[g_cnt1].s1 = (g_omb_excel[g_cnt1].omb16-g_omb_excel[g_cnt1].ccc62)
      IF g_omb_excel[g_cnt1].omb38 = '3' AND ((g_omb_excel[g_cnt1].s1 >0 AND g_omb_excel[g_cnt1].ccc62<0) OR (g_omb_excel[g_cnt1].s1 <0 AND g_omb_excel[g_cnt1].ccc62 <0 )) THEN
        LET g_omb_excel[g_cnt1].s2=g_omb_excel[g_cnt1].s1/g_omb_excel[g_cnt1].omb16*100*(-1)
      ELSE
        IF g_omb_excel[g_cnt1].omb16 = 0 THEN
            LET g_omb_excel[g_cnt1].s2 = 100   #add by jiangln 160712
        ELSE
            LET g_omb_excel[g_cnt1].s2=g_omb_excel[g_cnt1].s1/g_omb_excel[g_cnt1].omb16*100
        END IF 
      END IF 
      LET g_tot11 = g_tot11 + g_omb_excel[g_cnt1].omb12
      LET g_tot41 = g_tot41 + g_omb_excel[g_cnt1].ccc62
      LET g_tot51 = g_tot51 + g_omb_excel[g_cnt1].s1
      #LET g_tot61 = g_tot61 + g_omb_excel[g_cnt1].s2
#add by jiangln 160709 end-------
      LET l_s2 = g_omb_excel[g_cnt1].s2
      LET l_tmp = l_s2 * 100
      #LET g_omb_excel[g_cnt1].s2 = cl_digcut(l_s2,2)
      #LET g_omb_excel[g_cnt1].s2 = (l_tmp/100) , "%"
      LET g_omb_excel[g_cnt1].s2 = (l_tmp/100)         #yinhy130708
#add by jiangln 160712 start------
      UPDATE axrq378_tmp SET omb12 = g_omb_excel[g_cnt1].omb12,
                             omb16 = g_omb_excel[g_cnt1].omb16,
                             ccc92 = g_omb_excel[g_cnt1].ccc92,
                             ccc62 = g_omb_excel[g_cnt1].ccc62,
                             s1    = g_omb_excel[g_cnt1].s1,
                             s2    = g_omb_excel[g_cnt1].s2
                       WHERE omb04 = g_omb_excel[g_cnt1].omb04
                         AND oma03 = g_omb_excel[g_cnt1].oma03
                         AND omb31 = g_omb_excel[g_cnt1].omb31
                         AND omb32 = g_omb_excel[g_cnt1].omb32
                         AND oma01 = g_omb_excel[g_cnt1].oma01   #tianry add 
                         AND omb03 = g_omb_excel[g_cnt1].omb03
#add by jiangln 160712 end---------
      IF g_cnt1 < = g_max_rec THEN
         LET g_cnt = g_cnt1
         LET g_omb[g_cnt].* = g_omb_excel[g_cnt1].*
      END IF 
      
      LET g_cnt1 = g_cnt1 + 1
   END FOREACH
 #  IF g_cnt1 > g_max_rec THEN
 #     CALL cl_err( '', 9035, 0 )
 #  END IF
   SELECT SUM(omb14t),SUM(omb16t),SUM(omb16)
     INTO g_tot21,g_tot31,g_tot71 
     FROM axrq378_tmp
    ORDER BY oma01,oma02,oma03
   LET g_tot61 = g_tot51/g_tot71*100
   DISPLAY g_tot11 TO FORMONLY.omb12sum
   #IF tm.c = 'Y' THEN 
      DISPLAY g_tot21 TO FORMONLY.omb14tsum
   #ELSE
   #   DISPLAY 0 TO FORMONLY.omb14tsum
   #END IF 
   #DISPLAY g_tot31 TO FORMONLY.omb16tsum    #TQC-CC0122  lujh mark
   #DISPLAY g_tot71 TO FORMONLY.omb16tsum     #TQC-CC0122  lujh add #TQC-D60039 mark
   DISPLAY g_tot71 TO FORMONLY.omb16sum      #TQC-D60039
   DISPLAY g_tot41 TO FORMONLY.ccc62sum
   DISPLAY g_tot51 TO FORMONLY.s1_sum
   DISPLAY g_tot61 TO FORMONLY.s2_sum
   
   CALL g_omb.deleteElement(g_cnt1)
   LET g_rec_b = g_cnt 
   DISPLAY g_rec_b TO FORMONLY.cn2
   #No.yinhy130708  --Begin
   #FUN-C80092 -----------Begin-------------                     
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.b = '",tm.b,"'",";",
               "tm.c = '",tm.c,"'",";","tm.g_auto_gen = '",tm.g_auto_gen,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
   #FUN-C80092 -----------End--------------
   IF tm.g_auto_gen = 'Y' THEN
      CALL s_ckk_fill('','317','axc-462',g_yy,g_mm,g_prog,g_ccz.ccz28,g_tot11,g_tot71,g_tot71,0,0,0,0,0,0,0,l_msg,g_user,g_today,g_time,'Y')
            RETURNING g_ckk.*  #FUN-C80092 g_ccz->g_yy/mm
      IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF
   #No.yinhy130708  --End
END FUNCTION

FUNCTION q378_bp2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.u TO u
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   #TQC-D60039--add--str---
   IF cl_null(tm.u) OR (NOT cl_null(tm.u) AND g_action_flag = 'page1') THEN
      LET g_action_flag = 'page2'
      CALL q378_b_fill_2()
   END IF
   #TQC-D60039--add--end
   LET g_flag1 = ' '
   LET g_action_flag = 'page2' 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.u,tm.c,tm.c1 FROM u,c,c1 ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE u
            IF NOT cl_null(tm.u) AND tm.c = 'Y' THEN
               CALL cl_set_comp_entry("c1",TRUE)
            ELSE
               CALL cl_set_comp_entry("c1",FALSE)
            END IF
            IF NOT cl_null(tm.u)  THEN
               CALL q378_b_fill_2()
               CALL q378_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q378_b_fill_1()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_omb_1.clear()  
               #TQC-D60039--mark--str--
               #DISPLAY 0  TO FORMONLY.cn2
               #DISPLAY 0  TO FORMONLY.omb12sum
               #DISPLAY 0  TO FORMONLY.omb14tsum
               ##DISPLAY 0  TO FORMONLY.omb16tsum    #TQC-CC0122  lujh mark
               #DISPLAY 0  TO FORMONLY.omb16sum      #TQC-CC0122  lujh add
               #DISPLAY 0  TO FORMONLY.ccc62sum
               #DISPLAY 0  TO FORMONLY.s1_sum
               #DISPLAY 0  TO FORMONLY.s2_sum
               #TQC-D60039--mark--end
            END IF
            DISPLAY tm.u TO u 
            EXIT DIALOG

          ON CHANGE c
             IF NOT cl_null(tm.u) AND tm.c = 'Y' THEN
               CALL cl_set_comp_entry("c1",TRUE)
             ELSE
               CALL cl_set_comp_entry("c1",FALSE)
             END IF
             CALL q378()
             CALL q378_t()
             EXIT DIALOG

          ON CHANGE c1
             CALL q378_b_fill_2()
             CALL q378_set_visible()
             LET g_action_choice = "page2"

      END INPUT

      DISPLAY ARRAY g_omb_1 TO s_omb_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION page1
         LET g_action_choice="page1"
         LET g_flag1='2'  #TQC-D60039
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q378_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         IF l_ac1 > 0  THEN
            CALL q378_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag1 = '1'              
            EXIT DIALOG 
         END IF
        

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 


      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG  

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about
         CALL cl_about()


      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
    
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q378_show()
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
   DISPLAY tm.u TO u
   DISPLAY tm.a TO a
   DISPLAY tm.b TO b
   DISPLAY tm.c TO c
   DISPLAY tm.g_auto_gen TO g_auto_gen
   DISPLAY tm.c1 TO c1 
   DISPLAY tm.d TO d 
   DISPLAY tm.e TO e
   DISPLAY tm.f TO f  
   DISPLAY tm.g TO g 
   DISPLAY tm.c3 TO c3  #FUN-D50083 add
   DISPLAY tm.m TO m    #FUN-D60043 add
   
   CALL q378_b_fill_3()    #add by jiangln 160712
   CALL q378_b_fill_1()
   CALL q378_b_fill_2()
   IF cl_null(tm.u)  THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   ELSE
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
   END IF

   CALL q378_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q378_set_visible()

   CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,gem02_1,oma14_1,gen02_1",TRUE) 
   CALL cl_set_comp_visible("oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,oma08_11,omb33_1,aag02_1",TRUE)
   CASE tm.u
        WHEN "1"  CALL cl_set_comp_visible("azp01_1,oma15_1,gem02_1,oma14_1,gen02_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,oma08_11,omb33_1,aag02_1",FALSE)  
        WHEN "2"  CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma14_1,gen02_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,oma08_11,omb33_1,aag02_1",FALSE)
        WHEN "3"  CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,ima08_1,omb33_1,aag02_1",FALSE)
        WHEN "4"  CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,gem02_1,oma14_1,gen02_1,oma25_1,oma26_1,oma08_11,omb33_1,aag02_1",FALSE)
        WHEN "5"  CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,gem02_1,oma14_1,gen02_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,omb33_1,aag02_1",FALSE) 
        WHEN "6"  CALL cl_set_comp_visible("azp01_1,oma03_1,oma032_1,oma68_1,oma69_1,oma15_1,gem02_1,oma14_1,gen02_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,oma08_11",FALSE)
        WHEN "7"  CALL cl_set_comp_visible("azp01_1,oma68_1,oma69_1,oma15_1,gem02_1,oma14_1,gen02_1,oma25_1,oma26_1,omb04_1,ima02_1,ima021_1,oma08_11",FALSE)
   END CASE
END FUNCTION

FUNCTION q378_t()
   IF tm.c = 'Y' THEN 
      #CALL cl_set_comp_visible("oma23,omb13,omb14,oma54x,omb14t,oma24",TRUE)  #TQC-CC0122 add oma24  #TQC-CC0122 lujh mark
      #CALL cl_set_comp_visible("oma23_1,omb14_1,oma54x_1,omb14t_1",TRUE)   #TQC-CC0122 lujh mark
      CALL cl_set_comp_visible("oma23,omb13,omb14,oma24",TRUE)     #TQC-CC0122 lujh add
      CALL cl_set_comp_visible("oma23_1,omb14_1",TRUE)             #TQC-CC0122 lujh add
   ELSE
      CALL cl_set_comp_visible("oma23,omb13,omb14,oma54x,omb14t,oma24",FALSE)  #TQC-CC0122 add oma24
      CALL cl_set_comp_visible("oma23_1,omb14_1,oma54x_1,omb14t_1",FALSE) 
   END  IF 
   IF tm.d = 'Y' THEN 
      CALL cl_set_comp_visible("ccc92_1,ccc62_1,s1_1,s2_1",TRUE) 
   ELSE
      CALL cl_set_comp_visible("ccc92_1,ccc62_1,s1_1,s2_1",FALSE) 
   END IF 
   CLEAR FORM
   CALL g_omb.clear()
   CALL q378_show()
   CALL cl_show_fld_cont()
END FUNCTION
#FUN-C80102--add--end--  

#add by jiangln 160612 start----
FUNCTION q378_b_fill_1()
DEFINE l_oma03   LIKE oma_file.oma03
DEFINE g_tot11   LIKE oma_file.oma56t
DEFINE g_tot21   LIKE oma_file.oma56t
DEFINE g_tot31   LIKE oma_file.oma56t
DEFINE g_tot41   LIKE ccc_file.ccc62
DEFINE g_tot51   LIKE ccc_file.ccc62
DEFINE g_tot61   LIKE type_file.chr20
DEFINE g_tot71   LIKE oma_file.oma56t
DEFINE l_s2      LIKE type_file.num20_6
DEFINE l_tmp     LIKE type_file.num10
DEFINE l_msg     STRING                 
DEFINE l_ima31_fac LIKE ima_file.ima31_fac  
DEFINE l_ima25  LIKE ima_file.ima25  

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   LET g_sql = "SELECT * FROM axrq378_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               " ORDER BY oma03,omb04,omb31,omb32,oma01,omb03"   

   PREPARE axrq378_pb3 FROM g_sql
   DECLARE omb_curs3  CURSOR FOR axrq378_pb3    

   CALL g_omb.clear()
   LET g_cnt = 1
   LET g_cnt1 = 1
   LET g_rec_b = 0

   LET g_tot11 = 0
   LET g_tot21 = 0
   LET g_tot31 = 0
   LET g_tot41 = 0
   LET g_tot51 = 0
   LET g_tot61 = 0
   LET g_tot71 = 0

   FOREACH omb_curs3 INTO g_omb_excel[g_cnt1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      SELECT aag02 INTO g_omb_excel[g_cnt1].aag02 FROM aag_file WHERE aag01 = g_omb_excel[g_cnt1].omb33
      #tianry add 161123
      SELECT b.oga02  INTO g_omb_excel[g_cnt1].oga02 FROM oga_file a,oga_file b 
      WHERE a.oga011=b.oga01 AND a.oga01=g_omb_excel[g_cnt1].omb31

       #ly 170810 签收日期

      IF g_omb_excel[g_cnt1].omb31[1,3]='XRP' THEN 
        SELECT oga02 INTO g_omb_excel[g_cnt1].oga02a FROM oga_file   
        WHERE oga01=g_omb_excel[g_cnt1].omb31 
      END IF   
      IF cl_null(g_omb_excel[g_cnt1].oga02) THEN 
         SELECT oga02  INTO g_omb_excel[g_cnt1].oga02 FROM oga_file 
         WHERE oga01=g_omb_excel[g_cnt1].omb31
      END IF 
      
      IF cl_null(g_omb_excel[g_cnt1].oga02) THEN 
         SELECT oha02 INTO g_omb_excel[g_cnt1].oga02 FROM oha_file WHERE oha01=g_omb_excel[g_cnt1].omb31
      END IF 
      #tianry add end 
#add by jiangln 160709 start-------
      LET g_tot11 = g_tot11 + g_omb_excel[g_cnt1].omb12
      LET g_tot41 = g_tot41 + g_omb_excel[g_cnt1].ccc62
      LET g_tot51 = g_tot51 + g_omb_excel[g_cnt1].s1
#add by jiangln 160709 end-------
      LET l_s2 = g_omb_excel[g_cnt1].s2
      LET l_tmp = l_s2 * 100
      LET g_omb_excel[g_cnt1].s2 = (l_tmp/100)         

      IF g_cnt1 < = g_max_rec THEN
         LET g_cnt = g_cnt1
         LET g_omb[g_cnt].* = g_omb_excel[g_cnt1].*
      END IF 
      
      LET g_cnt1 = g_cnt1 + 1
   END FOREACH
 #  IF g_cnt1 > g_max_rec THEN
 #     CALL cl_err( '', 9035, 0 )
 #  END IF
   SELECT SUM(omb14t),SUM(omb16t),SUM(omb16)
     INTO g_tot21,g_tot31,g_tot71 
     FROM axrq378_tmp
    ORDER BY oma01,oma02,oma03
   LET g_tot61 = g_tot51/g_tot71*100
   DISPLAY g_tot11 TO FORMONLY.omb12sum
   DISPLAY g_tot21 TO FORMONLY.omb14tsum
   DISPLAY g_tot71 TO FORMONLY.omb16sum     
   DISPLAY g_tot41 TO FORMONLY.ccc62sum
   DISPLAY g_tot51 TO FORMONLY.s1_sum
   DISPLAY g_tot61 TO FORMONLY.s2_sum
   
   CALL g_omb.deleteElement(g_cnt1)
   LET g_rec_b = g_cnt 
   DISPLAY g_rec_b TO FORMONLY.cn2
                 
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.b = '",tm.b,"'",";",
               "tm.c = '",tm.c,"'",";","tm.g_auto_gen = '",tm.g_auto_gen,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00

   IF tm.g_auto_gen = 'Y' THEN
      CALL s_ckk_fill('','317','axc-462',g_yy,g_mm,g_prog,g_ccz.ccz28,g_tot11,g_tot71,g_tot71,0,0,0,0,0,0,0,l_msg,g_user,g_today,g_time,'Y')
            RETURNING g_ckk.* 
      IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF

END FUNCTION
#add by jiangln 160712 end------
