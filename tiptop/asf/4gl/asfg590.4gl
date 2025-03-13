# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: asfg590.4gl
# Descriptions...: 成品模擬用料明細表(尾階)
# Date & Author..: 93/05/13 By Keith
# Modify.........: 94/02/15 By Apple
# Modify.........: 02/07/17 By Carol    #bugno:5414
# Modify.........: No:FUN-550112 05/05/26 By ching 特性BOM功能修改
# Modify.........: No:FUN-550067 05/06/01 By yoyo單據編號格式放大
# Modify.........: No:FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No:MOD-550112 05/05/19 By pengu '預計工單編號'表頭顯示時,應改為一列顯示比較好看
# Modify.........: No:TQC-5B0023 05/11/07 By kim 報表料號放大
# Modify.........: No:FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No:FUN-650193 06/06/01 By kim 2.0功能改善-主特性代碼
# Modify.........: No:FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No:FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No:FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No:FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No:TQC-720064 07/03/02 By Ray "語言"按鈕無法使用
# Modify.........: No:FUN-760046 07/06/27 By hellen CR報表修改
# Modify.........: No:MOD-7A0160 07/10/26 By Pengu temp table 的index大於255
# Modify.........: No:MOD-7A0160 07/10/26 By Pengu temp table 的index大於255
# Modify.........: No:TQC-7B0143 07/11/27 By Mandy FUNCTION alloc_bom名在$SUB/s_alloc.4gl內也有相同的FUNCTION 名,所以更名為r590_alloc_bom,否則r.l2不會過
# Modify.........: No:MOD-810145 08/03/23 By Pengu 在外量,未考慮單位換算率
# Modify.........: No:TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No:MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No:FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No:TQC-940142 09/05/11 By mike 創建臨時表時，欄位名稱有關鍵字use   
# Modify.........: No:FUN-940008 09/05/13 By hongmei 發料改善
# Modify.........: No:FUN-940083 09/05/15 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 By dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:FUN-A20044 10/03/19 By dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A60097 10/05/27 By Carrier main结构调整 & MOD-9B0175 追单
# Modify.........: No:MOD-A60068 10/06/10 By Sarah CALL s_shortqty()要多傳兩個參數sfa012,sfa013
# Modify.........: No:TQC-A60097 10/06/22 By liuxqa TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:TQC-B90144 11/09/21 By houlia 直接打印時判斷BOM是否有效
# Modify.........: No:TQC-C20061 12/02/10 By destiny 打印无资料
# Modify.........: No:CHI-C20050 12/08/22 By bart 畫面加一個選項,選擇要抓未確認、已確認、全部的資料
# Modify.........: No:FUN-CB0072 12/12/05 By dongsz CR轉GR
# Modify.........: No:FUN-CB0072 13/01/28 By chenying 單身在原有資料基礎上新增一筆時，跳轉到qty欄位報錯mfg3400 
# Modify.........: No:FUN-CB0072 13/01/29 By chenying 特性代碼不為NULL時，不重新通過ima_file抓取資料 

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_ver	LIKE sfx_file.sfx01        #No.FUN-680121 VARCHAR(1)
   DEFINE bst   LIKE type_file.chr1        #CHI-C20050
   DEFINE tm  RECORD                       # Print condition RECORD
              c   LIKE type_file.chr1      #No.FUN-680121 VARCHAR(1)# 是否僅列缺料(Y/N)
              END RECORD,
    g_bma DYNAMIC ARRAY OF RECORD
            cnt     LIKE type_file.num5,        #No.FUN-680121 SMALLINT
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            bma06   LIKE bma_file.bma06,        #FUN-650193
#           qty     LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(13,3)
            qty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044 
#           num     VARCHAR(10)
            num     LIKE bma_file.bma02         #No.FUN-680121 VARCHAR(16)#No.FUN-550067
        END RECORD,
    g_bma_t DYNAMIC ARRAY OF RECORD
            cnt     LIKE type_file.num5,        #No.FUN-680121 SMALLINT
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            bma06   LIKE bma_file.bma06,        #FUN-650193
#           qty     LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(13,3)
            qty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
#           num     VARCHAR(10)
            num     LIKE bma_file.bma02         #No.FUN-680121 VARCHAR(16)#No.FUN-550067
        END RECORD,
# genero  script marked     g_arrno         SMALLINT,
    g_minopseq      LIKE ecb_file.ecb03,
# genero  script marked     g_bma_arrno     SMALLINT,         #程式陣列的個數(Program array no)
# genero  script marked     g_bma_sarrno    SMALLINT,         #螢幕陣列的個數(Screen array no)
    g_bma_pageno    LIKE type_file.num5,           #No.FUN-680121 SMALLINT#目前單身頁數
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT #TQC-840066
#       l_time    LIKE type_file.chr8    	         #No.FUN-6A0090
    l_name          LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_name2         LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_sl            LIKE type_file.num5,           #No.FUN-680121 SMALLINT#目前處理的SCREEN LINE
    l_count         LIKE type_file.num5,           #No.FUN-680121 SMALLINT
    g_chr1          LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
    g_chr2          LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(40)
    g_yld           LIKE type_file.chr1            #No.FUN-680121 VARCHAR(01)
#   g_sql           string                         #No.FUN-580092 HCN #No.FUN-760046
 
 
DEFINE   g_cnt      LIKE type_file.num10           #No.FUN-680121 INTEGER
DEFINE   g_i        LIKE type_file.num5            #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_total    LIKE type_file.num5            #No.FUN-680121 SMALLINT
DEFINE   l_table    STRING                         #No.FUN-760046
DEFINE   g_str      STRING                         #No.FUN-760046
DEFINE   g_sql      STRING                         #No.FUN-760046
###GENGRE###START
TYPE sr1_t RECORD
    chr1 LIKE type_file.chr1,
    cnt LIKE type_file.num5,
    bma01 LIKE bma_file.bma01,
    bma06 LIKE bma_file.bma06,
    qty LIKE type_file.num15_3,
    num LIKE bma_file.bma02,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,   #FUN-CB0072 add
    count LIKE type_file.num5,
    bmb03 LIKE bmb_file.bmb03,
    xx05 LIKE sfa_file.sfa05,
    use1 LIKE type_file.num15_3,
    min LIKE sfa_file.sfa05,
    qty4 LIKE sfa_file.sfa05,      #FUN-CB0072 sfa03->sfa05
    qty1 LIKE sfa_file.sfa05,      #FUN-CB0072 sfa03->sfa05
    ima25 LIKE ima_file.ima25,
    unalc LIKE sfa_file.sfa25,
    qty2 LIKE sfa_file.sfa05,      #FUN-CB0072 sfa03->sfa05
    mark LIKE type_file.chr1,
   #order LIKE type_file.chr20,    #FUN-CB0072 add
    num1 LIKE type_file.num5       #FUN-CB0072 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A60097  --Begin
   LET g_pdate  = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-760046 --begin --CR
   LET g_sql = " chr1.type_file.chr1,",
               " cnt.type_file.num5,",
               " bma01.bma_file.bma01,",
               " bma06.bma_file.bma06,",
#              " qty.ima_file.ima26,",    #NO.FUN-A20044 
               " qty.type_file.num15_3,", #NO.FUN-A20044 
               " num.bma_file.bma02,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",  #FUN-CB0072 add
               " count.type_file.num5,",
               " bmb03.bmb_file.bmb03,",
               " xx05.sfa_file.sfa05,",
              #" use.ima_file.ima26,",   #TQC-940142                                                                                
#              " use1.ima_file.ima26,",  #TQC-940142  
               " use1.type_file.num15_3,",#NO.FUN-A20044
               " min.sfa_file.sfa05,",
               " qty4.sfa_file.sfa05,",      #FUN-CB0072 sfa03->sfa05
               " qty1.sfa_file.sfa05,",      #FUN-CB0072 sfa03->sfa05
               " ima25.ima_file.ima25," ,
               " unalc.sfa_file.sfa25,",
               " qty2.sfa_file.sfa05,",      #FUN-CB0072 sfa03->sfa05
               " mark.type_file.chr1,",
              #" order.type_file.chr20,",    #FUN-CB0072 add
               " num1.type_file.num5"        #FUN-CB0072 add
 
   LET l_table = cl_prt_temptable('asfg590',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF               
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                    #FUN-CB0072 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-760046 --end --CR  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   #No.TQC-A60097  --End  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL asfg590_tm(0,0)                 # Input print condition
   ELSE
      CALL asfg590()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfg590_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,            #No.FUN-680121 VARCHAR(40)
          l_cmd     LIKE type_file.chr1000             #No.FUN-680121 CAHR(1100)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 2 END IF
   LET g_bma_pageno = 1                   #現在單身頁次
   LET p_row = 4 LET p_col =15
   OPEN WINDOW asfg590_w AT p_row,p_col
        WITH FORM "asf/42f/asfg590"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-650193................begin
   CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
   #FUN-650193................end
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_chr2 = ' '
   CALL r590_tmp()
WHILE TRUE
   LET g_chr1 = 'N'    # No:MOD-9B0175 add 
   CALL r590_b()
  #--------------No:MOD-9B0175 add                                              
   IF g_chr1 = 'Y' THEN                                                         
      CALL g_bma.clear()                                                        
      CALL g_bma_t.clear()                                                      
      DISPLAY ARRAY g_bma TO s_bma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)        
          BEFORE DISPLAY                                                        
             EXIT DISPLAY                                                       
      END DISPLAY                                                               
      CONTINUE WHILE                                                            
   END IF                                                                       
  #--------------No:MOD-9B0175 end
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfg590_w
      EXIT WHILE
   END IF
   IF cl_sure(0,0) THEN
      #--->是否只列印缺料部份
#     CALL cl_prtmsg(0,0,'mfg3514',g_lang) RETURNING tm.c
      CALL cl_confirm('mfg3514') RETURNING tm.c
      #--->是否扣除已發放尚未結案工單之下階用量
 
 #MOD-480595
{
      CALL cl_confirm('mfg3515') RETURNING g_chr1
      IF g_chr1 THEN
         LET g_chr1='Y'
         LET g_chr2 = g_x[25] CLIPPED
      ELSE
         LET g_chr1='N'
         LET g_chr2 = g_x[26] CLIPPED
      END IF
}
#--
      CALL cl_wait()
      DELETE FROM r590_t3
      CALL asfg590()
   END IF
   ERROR ""
END WHILE
   DROP TABLE r590_t3
   CLOSE WINDOW asfg590_w
END FUNCTION
 
FUNCTION r590_tmp()
 
   #bugno:5414...............................
  #No.FUN-680121-BEGIN
    CREATE TEMP TABLE r590_t2(
     xx03      LIKE ima_file.ima01,      #No.MOD-7A0160 modify
     xx05      LIKE bed_file.bed07,
     unalc     LIKE bed_file.bed07);
 #No.FUN-680121-END
  create unique index t2 on r590_t2  (xx03);
   IF SQLCA.sqlcode THEN CALL cl_err('create_r590_t2',SQLCA.sqlcode,1) END IF
   #bug end..................................
 
   #產生與sfa_file相同之暫存檔,需求資料
   #No.FUN-680121-BEGIN
   CREATE TEMP TABLE r590_t3(
     xx03      LIKE type_file.chr20, 
     xx05      LIKE bed_file.bed07);
  #No.FUN-680121-END
   create unique index t3 on r590_t3  (xx03);
   IF SQLCA.sqlcode THEN CALL cl_err('create_r590_t3',SQLCA.sqlcode,1) END IF
  #No.FUN-940008---Begin add                                                     
  CREATE TEMP TABLE r580_tmp1(                                                  
     sfa05     LIKE sfa_file.sfa05,                                             
     sfa06     LIKE sfa_file.sfa06,                                             
     sfa13     LIKE sfa_file.sfa13,                                             
     sfa03     LIKE sfa_file.sfa03);                                            
  IF SQLCA.sqlcode THEN CALL cl_err('temp error',SQLCA.sqlcode,1) END IF        
  #No.FUN-940008---End 
END FUNCTION
 
FUNCTION asfg590()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 CAHR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
#         l_qq      LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)
          l_qq      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_sfb11   LIKE sfb_file.sfb11,
          sr     RECORD
                 mark       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)
                 bmb03      LIKE bmb_file.bmb03,       #料件編號
                 ima02      LIKE ima_file.ima02,       #規格說明
                 ima021     LIKE ima_file.ima021,      #FUN-CB0072 add
                 ima25      LIKE ima_file.ima25,       #規格說明
                 xx05       LIKE sfa_file.sfa05,       #應發數量
#                use        LIKE ima_file.ima26,       #可用量
                 use        LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
                 minus      LIKE sfa_file.sfa05,       #缺料量
                #No.B017 010326 by plum 因ima7*已改為其他用途,在此改成別的變數
                 {
                 ima75      LIKE bed_file.bed07,        #No.FUN-680121 DECIMAL(12,3)#在製量
                 ima76      LIKE bed_file.bed07,        #No.FUN-680121 DECIMAL(12,3)#在外量
                 ima77      LIKE bed_file.bed07,        #No.FUN-680121 DECIMAL(12,3)#在途量
                 ima78      LIKE bed_file.bed07,        #No.FUN-680121 DECIMAL(12,3)#在驗量
                 }
                 qty1       LIKE sfa_file.sfa05,       #在製量   #FUN-CB0072 sfa03->sfa05
                 qty2       LIKE sfa_file.sfa05,       #在外量   #FUN-CB0072 sfa03->sfa05
                 qty3       LIKE sfa_file.sfa05,       #在途量  -> 不用  #FUN-CB0072 sfa03->sfa05
                 qty4       LIKE sfa_file.sfa05,       #在驗量   #FUN-CB0072 sfa03->sfa05
                #No.B017..end
                 unalc      LIKE sfa_file.sfa25        #未備料量
          END RECORD,
          l_mark    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_i,l_j   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_unalc       LIKE sfa_file.sfa25
 
   DEFINE l_temp RECORD               #bugno:5414
     xx03        LIKE ima_file.ima01,          #No.FUN-680121 VARCHAR(40){料件編號 }    #FUN-560011 #No.MOD-7A0160 modify
#    xx05        LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3){原發數量 }
     xx05        LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
#    unalc       LIKE ima_file.ima26           #No.FUN-680121 DECIMAL(12,3)
     unalc       LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
                 END RECORD
   DEFINE l_ima910   LIKE ima_file.ima910      #FUN-550112
   #FUN-940008--Begin add                                                       
   DEFINE l_sfa01     LIKE sfa_file.sfa01                                       
   DEFINE l_sfa03     LIKE sfa_file.sfa03                                       
   DEFINE l_sfa08     LIKE sfa_file.sfa08                                       
   DEFINE l_sfa12     LIKE sfa_file.sfa12                                       
   DEFINE l_sfa27     LIKE sfa_file.sfa27                                       
   DEFINE l_sfa05     LIKE sfa_file.sfa05                                       
   DEFINE l_sfa06     LIKE sfa_file.sfa06                                       
   DEFINE l_sfa13     LIKE sfa_file.sfa13                                       
   DEFINE l_sfa012    LIKE sfa_file.sfa012     #MOD-A60068 add
   DEFINE l_sfa013    LIKE sfa_file.sfa013     #MOD-A60068 add
   DEFINE l_short_qty LIKE sfa_file.sfa07                                       
   DEFINE l_sfa07     LIKE sfa_file.sfa07                                       
   DEFINE l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044   
   #FUN-940008---End
   DEFINE l_order     LIKE type_file.chr20     #FUN-CB0072 add
   DEFINE l_num1      LIKE type_file.num5      #FUN-CB0072 add
   DEFINE l_ima021    LIKE ima_file.ima021     #FUN-CB0072 add
 
#No.CUN-760046 --begin --CR
#  CALL cl_outnam('asfg590') RETURNING l_name
   CALL cl_del_data(l_table)
#No.FUN-760046 --end --CR
   
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
 
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
                  WHERE zz01 = 'asfg590'
     #LET g_len = 75       #No.FUN-550067 #TQC-5B0023 #FUN-650193
 
#No.FUN-760046 --begin --CR
#  LET g_len = 99       #FUN-650193
#  FOR g_i = 1 TO g_len  LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-760046 --end --CR
 
#No.FUN-760046 --begin --CR
#  START REPORT asfg590_rep TO l_name
   LET l_num1 = 3                               #FUN-CB0072 add
      FOR l_i = 1 TO g_bma.getLength()
          IF NOT cl_null(g_bma[l_i].bma01) THEN
            #LET l_order = g_bma[l_i].bma01,g_bma[l_i].cnt                      #FUN-CB0072 add 
#            OUTPUT TO REPORT asfg590_rep(g_bma[l_i].*)
             SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima02 = g_bma[l_i].ima02   #FUN-CB0072 add
             EXECUTE insert_prep USING
                     '0',g_bma[l_i].cnt,g_bma[l_i].bma01,g_bma[l_i].bma06,
                     g_bma[l_i].qty,g_bma[l_i].num,g_bma[l_i].ima02,l_ima021,'','',   #FUN-CB0072 add l_ima021
                     '','','','','','','','','',l_num1                          #FUN-CB0072 add l_num1                     
            #LET g_template = 'asfg590'          #FUN-CB0072 add
#add --end --07/06/28             
          END IF
      END FOR
#  FINISH REPORT asfg590_rep
#No.FUN-760046 --end --CR
 
#No.FUN-760046 -begin --CR
#  LET l_name2 ='asfg590x'
   LET l_count = 0
#  LET g_len=100 #TQC-5B0023
#  FOR g_i = 1 TO g_len  LET g_dash[g_i,g_i] = '=' END FOR ##TQC-5B0023
#  START REPORT asfg590_rep2 TO l_name2
      #--->彙總相同成品編號生產總數
      FOR l_i = 1 TO g_bma.getLength()
          IF cl_null(g_bma[l_i].bma01) THEN CONTINUE FOR END IF
          FOR l_j = l_i+1 TO g_bma.getLength()
             IF cl_null(g_bma[l_j].bma01) THEN CONTINUE FOR END IF
             IF g_bma[l_i].bma01 = g_bma[l_j].bma01 THEN
                LET g_bma[l_i].qty = g_bma[l_i].qty + g_bma[l_j].qty
                INITIALIZE g_bma[l_j].* TO NULL
             END IF
          END FOR
      END FOR
      #--->下階備料資料產生
      FOR l_i = 1 TO g_bma.getLength()
         IF g_bma[l_i].bma01 IS NULL OR g_bma[l_i].bma01 = ' ' THEN
              CONTINUE FOR
         END IF
        #FUN-650193...............begin
        ##FUN-550112
        #LET l_ima910=''
        #SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=g_bma[l_i].bma01
         LET l_ima910=g_bma[l_i].bma06
        #FUN-650193...............end
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #--
         DISPLAY 's_alloc:',l_i,'/',g_bma[l_i].bma01 AT 19,1
         CALL r590_alloc_bom(0,g_bma[l_i].bma01,l_ima910,g_bma[l_i].qty)   #FUN-550112 #TQC_7B0143
      END FOR
      #--->備料資料整理(考慮單位基準為庫存單位)
      #DROP TABLE r590_t2   #bugno:5414
 
#bugno:5414.....................................................
      #因為orcale無法使用這種方法insert into ,
      #所以改用FOREACH方式改寫
 
       DELETE FROM r590_t2
#
#     #plum
#     #IF g_chr1 = 'Y' THEN
#         SELECT xx03,xx05,SUM((sfa05-sfa06)*sfa13) unalc
#           FROM r590_t3,  OUTER (sfa_file, sfb_file)
#          WHERE  sfa_file.sfa03 = r590_t3.xx03   AND sfa05 > sfa06
#            AND sfa01 = sfb01 AND sfb04 != 8 AND sfb87!='X'
#            AND ((sfa05 > (sfa06+sfa07)) OR (sfa07 > 0)) #plum
#            AND sfb02 != 11    #拆件式工單
#          GROUP BY xx03,xx05
#          INTO TEMP r590_t2
#     #ELSE
#     #   SELECT xx03, xx05,   0 unalc
#     #     FROM r590_t3
#     #     INTO TEMP r590_t2
#     #END IF
#
#FUN-940008---Begin 
      DELETE FROM r590_tmp1                                                     
      LET l_sql = "SELECT sfa05,sfa06,sfa13,sfa03,sfa01,sfa08,sfa12,sfa27,sfa012,sfa013",   #MOD-A60068 add sfa012,sfa013
                  "  FROM sfa_file,sfb_file",
                  " WHERE sfa05 > sfa06 AND sfa01 = sfb01",
                  "   AND sfb04 != '8' AND sfb87! = 'X' AND sfb02!=11"
      PREPARE r590_tmp1_pre FROM l_sql
      DECLARE r590_tmp1_dec CURSOR FOR r590_tmp1_pre
      FOREACH r590_tmp1_dec INTO l_sfa05,l_sfa06,l_sfa13,l_sfa03,
                                 l_sfa01,l_sfa08,l_sfa12,l_sfa27,
                                 l_sfa012,l_sfa013   #MOD-A60068 add
         CALL s_shortqty(l_sfa01,l_sfa03,l_sfa08,l_sfa12,l_sfa27,
                         l_sfa012,l_sfa013)  #MOD-A60068 add l_sfa012,l_sfa013
              RETURNING l_short_qty                                             
         LET l_sfa07 = l_short_qty                                              
         IF l_sfa05 <= l_sfa06+l_sfa07 THEN                                     
            CONTINUE FOREACH                                                    
         END IF                                                                 
         IF l_sfa07 <= 0 THEN                                                   
            CONTINUE FOREACH                                                    
         END IF
         INSERT INTO r580_tmp1 VALUES(l_sfa05,l_sfa06,l_sfa13,l_sfa03)          
         IF SQLCA.SQLCODE THEN CALL cl_err(1,sqlca.sqlcode,1) END IF            
      END FOREACH
LET g_sql=" SELECT xx03,xx05,SUM((tmp.sfa05-tmp.sfa06)*tmp.sfa13)",
          "   FROM r590_t3 LEFT OUTER JOIN ",
          " (select sfa03,sfa05,sfa06,sfa13",
          "    from sfa_file,sfb_file",
          "   where sfa05  > sfa06 ",
          "     and sfa01  = sfb01 ",
          "     and sfb04 != '8' ",
          "   and sfb87 != 'X'",
          #"   and (sfa05 > (sfa06+sfa07) or sfa07 > 0) ", #TQC-C20061 #sfa07为原来欠料量现已改为动态计算已无用 
          "   and sfa05 > sfa06 ",  #TQC-C20061
          "   and sfb02 != 11 ",
          ") tmp  ON xx03 = tmp.sfa03",
#         " WHERE xx03 = tmp.sfa03(+) ",
          " GROUP BY xx03,xx05 "
PREPARE r590_rep2_cs1_p FROM g_sql
DECLARE r590_rep2_cs1 CURSOR FOR r590_rep2_cs1_p
#FUN-940008---End
      FOREACH r590_rep2_cs1 INTO l_temp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach r590_rep2_cs1',SQLCA.sqlcode,1)   
            EXIT FOREACH
         END IF
         INSERT INTO r590_t2 VALUES(l_temp.xx03,l_temp.xx05,l_temp.unalc)
      END FOREACH
#bugno end..................................................................
 
#     LET l_sql = " SELECT '',xx03,ima02,ima25,xx05,ima262,", #NO.FUN-A20044 
                  LET l_sql = " SELECT '',xx03,ima02,ima021,ima25,xx05,0,",      #NO.FUN-A20044 #FUN-CB0072 add ima021 
                              " 0,0,0,0,0,unalc",
                              "  FROM r590_t2, OUTER ima_file",
                              "  WHERE  r590_t2.xx03  = ima_file.ima01  "
      PREPARE out1_pre FROM l_sql
      DECLARE out1_cur CURSOR WITH HOLD FOR out1_pre
 
      FOREACH out1_cur INTO sr.*
         IF STATUS THEN CALL cl_err('for 1_cur:',STATUS,1) EXIT FOREACH END IF
         CALL s_getstock(sr.bmb03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
         LET sr.use = l_n3                                    #NO.FUN-A20044           
         #--->qty1工單在製量,須包含委外
         SELECT SUM(sfb08-sfb09-sfb11) INTO sr.qty1
           FROM sfb_file
          WHERE sfb05 = sr.bmb03 AND sfb04 < '8'
            AND sfb02 != 11                      #拆件式工單
            AND sfb08 > (sfb09+sfb11) AND sfb87!='X'
         IF sr.qty1 IS NULL THEN LET sr.qty1 = 0 END IF
 
         #--->qty2在外量
        #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO sr.qty2 FROM pmn_file  #No.MOD-810145 modify #FUN-940083
         SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO sr.qty2 FROM pmn_file  #FUN-940083 
          WHERE pmn04 = sr.bmb03
#           AND pmn20 > (pmn50-pmn55) AND pmn16 <= '2'        #No.FUN-9A0068 mark
            AND pmn20 > (pmn50-pmn55-pmn58) AND pmn16 <= '2'  #No.FUN-9A0068 
            AND pmn011 !='SUB'
         IF sr.qty2 IS NULL THEN LET sr.qty2 = 0 END IF
 
         #--->qty4在驗量
         #------IQC在驗量
         SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO sr.qty4
           FROM rva_file,rvb_file,pmn_file
          WHERE rvb05 = sr.bmb03
            AND rvb01 = rva01 AND rvaconf <> 'X'
            AND rvb04 = pmn01
            AND rvb03 = pmn02
            AND rvb07 > (rvb29+rvb30)
         IF sr.qty4 IS NULL THEN LET sr.qty4 = 0 END IF
 
         #------FQC在驗量
           SELECT SUM(sfb11) INTO l_sfb11 FROM sfb_file
            WHERE sfb05 = sr.bmb03
              AND sfb02 != '7'    #委外工單
              AND sfb04 < '8' AND sfb87!='X'
         IF l_sfb11 IS NULL THEN LET l_sfb11 = 0 END IF
         LET sr.qty4 = sr.qty4 + l_sfb11
 
         IF sr.unalc IS NULL OR sr.unalc = ' '
         THEN LET sr.unalc = 0
         END IF
         #--->是否僅列印缺料資料(可用量 - (原發數量 + 未備料量))
          LET l_qq = sr.use - (sr.xx05  + sr.unalc)
#         IF tm.c MATCHES '[yY]' THEN
         IF tm.c THEN
              LET sr.mark = 'N'
              IF l_qq >= 0 THEN CONTINUE FOREACH END IF
              LET sr.minus = l_qq * -1
         ELSE IF l_qq <= 0 THEN
                   LET sr.minus = l_qq * -1
                   LET sr.mark = 'Y'
              ELSE LET sr.mark = 'N'
                   LET sr.minus= 0
              END IF
         END IF
#        OUTPUT TO REPORT asfg590_rep2(sr.*)
         LET l_count = l_count + 1    #add by hellen No.FUN-760046
        #LET l_order = l_count,sr.bmb03            #FUN-CB0072 add
         EXECUTE insert_prep USING 
                 '1','','','','','',sr.ima02,sr.ima021,l_count,sr.bmb03,sr.xx05,sr.use, 
                 sr.minus,sr.qty4,sr.qty1,sr.ima25,sr.unalc,sr.qty2,sr.mark,l_num1     #FUN-CB0072 add l_num1 
        #LET g_template = 'asfg590_1'          #FUN-CB0072 add
   END FOREACH
   
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3('asfg590','asfg590',l_sql,'')
    CALL asfg590_grdata()    ###GENGRE###
#  FINISH REPORT asfg590_rep2
#  LET l_cmd = "chmod 777 ", l_name2
#  RUN l_cmd
#  LET l_cmd='cat ',l_name2,'>>',l_name
#  RUN l_cmd  WITHOUT WAITING
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-760046 --end --CR
END FUNCTION
 
#No.FUN-760046 --begin --CR
{ 
REPORT asfg590_rep(sr)
 DEFINE  sr  RECORD
              cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              bma01   LIKE bma_file.bma01,
              ima02   LIKE ima_file.ima02,
              bma06   LIKE bma_file.bma06, #FUN-650193
              qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)
#             num     VARCHAR(10)
             num      LIKE bma_file.bma02           #No.FUN-680121 VARCHAR(16)#No.FUN_550067
         END RECORD,
         l_last_sw    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER BY sr.bma01,sr.cnt
   FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF cl_null(g_towhom) THEN
          PRINT '';
      ELSE
          PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
       #PRINT COLUMN 73,g_x[24] CLIPPED       #No.MOD-550112
      PRINT g_x[11] CLIPPED,
            COLUMN 6,g_x[12] CLIPPED,
           #COLUMN 46,g_x[13] CLIPPED,
            COLUMN 47,g_x[28] CLIPPED, #FUN-650193
            COLUMN 68,g_x[14] CLIPPED,
           #COLUMN 71,g_x[15] CLIPPED         #No.MOD-550112
            COLUMN 84,g_x[24] CLIPPED,g_x[15] CLIPPED   #No.MOD-550112
      PRINT COLUMN 6,g_x[13] CLIPPED
     #PRINT '--- -------------------- ------------------------------ ',
     #      '------------- ----------------'     #No.FUN-550067
      PRINT '---- ---------------------------------------- ',
            '-------------------- --------------- ----------------'
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN 01,sr.cnt using '###&',' ',
            COLUMN 06,sr.bma01 CLIPPED,' ',
           #COLUMN 46,sr.ima02 CLIPPED,' ',
            COLUMN 47,sr.bma06 CLIPPED,' ',
            COLUMN 68,cl_numfor(sr.qty,14,3),' ',
            COLUMN 84,sr.num
      PRINT COLUMN 06,sr.ima02 CLIPPED
 
ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT
}
{ 
REPORT asfg590_rep2(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,            #No.FUN-680121 VARCHAR(1)
          sr     RECORD
                 mark       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)
                 bmb03      LIKE bmb_file.bmb03,       #料件編號
                 ima02      LIKE ima_file.ima02,       #規格說明
                 ima25      LIKE ima_file.ima25,       #庫存單位
                 xx05       LIKE sfa_file.sfa05,       #應發數量
                 use        LIKE ima_file.ima26,       #可用量
                 minus      LIKE sfa_file.sfa05,       #缺料量
                #No.B017 010326 by plum 因ima7*已改為其他用途,在此改成別的變數
                 
#                ima75      LIKE bed_file.bed07,       #No.FUN-680121 DECIMAL(12,3)#在製量
#                ima76      LIKE bed_file.bed07,       #No.FUN-680121 DECIMAL(12,3)#在外量
#                ima77      LIKE bed_file.bed07,       #No.FUN-680121 DECIMAL(12,3)#在途量
#                ima78      LIKE bed_file.bed07,       #No.FUN-680121 DECIMAL(12,3)#在驗量
                 qty1       LIKE sfa_file.sfa03,       #在製量
                 qty2       LIKE sfa_file.sfa03,       #在外量
                 qty3       LIKE sfa_file.sfa03,       #在途量  -> 不用
                 qty4       LIKE sfa_file.sfa03,       #在驗量
                #No.B017..end
                 unalc      LIKE sfa_file.sfa25        #未備料量
          END RECORD,
          l_unalc       LIKE sfa_file.sfa25,
          l_qq          LIKE sfa_file.sfa25,
          l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   OUTPUT  TOP MARGIN g_top_margin
           LEFT MARGIN g_left_margin
           BOTTOM MARGIN g_bottom_margin
           PAGE LENGTH g_page_line
 
   ORDER BY sr.bmb03
   FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF cl_null(g_towhom) THEN
          PRINT '';
      ELSE
          PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
 #--------------------------------------No.MOD-550112-----------------------
      PRINT g_x[11] CLIPPED,
            COLUMN 6,g_x[16] CLIPPED,
            COLUMN 47,g_x[17] CLIPPED,
            COLUMN 58,g_x[18] CLIPPED,
            COLUMN 69,g_x[19] CLIPPED,
            COLUMN 80,g_x[23] CLIPPED,
            COLUMN 91,g_x[20] CLIPPED
      PRINT COLUMN 6,g_x[13] CLIPPED,
            COLUMN 69,g_x[27] CLIPPED,
            COLUMN 80,g_x[22] CLIPPED,
            COLUMN 91,g_x[21] CLIPPED
     #PRINT '---- ----------------------- ---------- ---------- ',
     #      '---------- ---------- ----------'
      PRINT '---- ---------------------------------------- ---------- ',
            '---------- ---------- ---------- ----------'
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET l_count = l_count + 1
      IF sr.mark ='Y' THEN PRINT '*'; END IF
      PRINT COLUMN 1,l_count using'###&',              #項次 #FUN-590118
            COLUMN 6,sr.bmb03 CLIPPED,                 #料件編號
            COLUMN 47,sr.xx05  using'######&.&&',' ',  #應發量
                      sr.use   using'######&.&&',' ',  #可用量
                      sr.minus using'######&.&&',' ',  #缺料量
                      sr.qty4 using'######&.&&',' ',  #在驗量
                      sr.qty1 using'######&.&&'       #在製量
      PRINT COLUMN 6,sr.ima02 CLIPPED,' ',            #品名規格
                     sr.ima25 CLIPPED,                #庫存單位
            COLUMN 69,sr.unalc using'######&.&&',     #工單未備量
            COLUMN 80,sr.qty2 using'######&.&&'       #在外量
 #--------------------------------------No.MOD-550112-----------------------
 
   ON LAST ROW
      PRINT g_chr2 CLIPPED
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_chr2 CLIPPED
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 3 LINE
      END IF
END REPORT
}
#No.FUN-760046 --end --CR
 
#FUNCTION alloc_bom(p_level,p_key,p_key2,p_total)   #FUN-550112 #TQC-7B0143
FUNCTION r590_alloc_bom(p_level,p_key,p_key2,p_total)   #FUN-550112 #TQC-7B0143
#No.FUN-A70034  --Begin
   DEFINE l_total_1    LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA        LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA  LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  
DEFINE
	p_level LIKE type_file.num5,                #No.FUN-680121 SMALLINT#階層
	p_key   LIKE bma_file.bma01,                #料件
        p_key2	LIKE ima_file.ima910,               #FUN-550112
	p_total LIKE smh_file.smh103,               #No.FUN-680121 SMALLINT#總數
	sr DYNAMIC ARRAY OF RECORD
		bmb02 LIKE bmb_file.bmb02,              #項次
		bmb03 LIKE bmb_file.bmb03,              #元件
		bmb10 LIKE bmb_file.bmb10,              #發料單位
		bmb10_fac LIKE bmb_file.bmb10_fac,      #發料/料件主檔
		bmb06 LIKE bmb_file.bmb06,              #組成用量
		bmb08 LIKE bmb_file.bmb08,              #損耗率
		bmb16 LIKE bmb_file.bmb16,              #取/替代特性
		ima08 LIKE ima_file.ima08,              #來源碼
		ima25 LIKE ima_file.ima25,              #庫存單位
		ima37 LIKE ima_file.ima37,              #補貨政策
		ima64 LIKE ima_file.ima64,              #發料倍量
		ima641 LIKE ima_file.ima641,            #最少發料量
		bma01  LIKE type_file.chr20,            #No.FUN-680121 VARCHAR(20)#是否有bom
                level LIKE type_file.num5,                  #No.FUN-680121 SMALLINT
                #No.FUN-A70034  --Begin
                bmb081 LIKE bmb_file.bmb081,
                bmb082 LIKE bmb_file.bmb082 
                #No.FUN-A70034  --End  
	END RECORD,
    b_seq       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    arrno       LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_pan       LIKE ima_file.ima64,
    l_double    LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_tot,l_i   LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_times     LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
    l_totqty    LIKE sfa_file.sfa05,
	l_total     LIKE sfa_file.sfa25
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
	IF p_level > 20 THEN
		CALL cl_err('','mfg2733',1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   CALL cl_gre_drop_temptable(l_table)            #FUN-CB0072 add
   EXIT PROGRAM
   
    END IF
    LET p_level = p_level + 1
    LET arrno   = 600
	LET l_times = 1
    LET b_seq   = 0
    WHILE TRUE
        LET l_cmd=
    	   "SELECT bmb02,bmb03,bmb10,bmb10_fac,",
           "(bmb06/bmb07),bmb08,bmb16,ima08,ima25,ima37,ima64,ima641,",
           " bma01,0,",
           " bmb081,bmb082", #No.FUN-A70034
           #" FROM bmb_file,OUTER ima_file,OUTER bma_file",  #TQC-C20061
           " FROM bmb_file LEFT OUTER JOIN ima_file ON ima01 = bmb03 ", #TQC-C20061
           " LEFT OUTER JOIN bma_file ON bma01 = bmb03 AND bmaacti = 'Y' ", #TQC-C20061
           " WHERE bmb01='", p_key,"' ",
           "   AND bmb02 > '",b_seq,"'",
           "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
           #"   AND bmaacti = 'Y'",    #TQC-B90144 add  #TQC-C20061
           #"   AND  bma_file.bma01 = bmb_file.bmb03   AND  ima_file.ima01 = bmb_file.bmb03  ", #TQC-C20061
           "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ",
           "   AND (bmb05 >'",g_today,"' OR bmb05 IS NULL)",
           " ORDER BY bmb02"
       PREPARE alloc_ppp FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
       DECLARE alloc_cur CURSOR FOR alloc_ppp
 
       LET l_ac = 1
       CALL sr.clear()
       FOREACH alloc_cur INTO sr[l_ac].*
	    	LET g_total=g_total+1
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
       END FOREACH
       LET l_tot=l_ac-1
       FOR l_i = 1 TO l_tot
           #No.FUN-A70034  --Begin
          #CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,0)               #TQC-C20061
           CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,sr[l_i].bmb06)   #TQC-C20061
                RETURNING l_total_1,l_QPA,l_ActualQPA
           #No.FUN-A70034  --End  
           IF sr[l_i].bma01 IS NOT NULL AND sr[l_i].bma01 != ' ' THEN
               #CALL r590_alloc_bom(p_level,sr[l_i].bmb03,' ',p_total*sr[l_i].bmb06) #TQC-7B0143#FUN-8B0035
               #No.FUN-A70034  --Begin
               #CALL r590_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06) #FUN-8B0035
               CALL r590_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total_1)
               #No.FUN-A70034  --End  
           ELSE
              #--->原發數量 = BOM 中的標準用量 + 損耗率
               
              #No.FUN-A70034  --Begin
              #LET l_total  = (p_total * sr[l_i].bmb06 * sr[l_i].bmb10_fac)
              #                       *  ( 1 + (sr[l_i].bmb08/100))
              LET l_total  = l_total_1 * sr[l_i].bmb10_fac
              #No.FUN-A70034  --End  
              IF l_total IS NULL OR l_total = ' '
              THEN LET l_total = 0
              END IF
{
              #--->考慮最小發料數量
              IF l_totqty  < sr[l_i].ima641
              THEN LET l_total = sr[l_i].ima641
              ELSE LET l_total = l_totqty
              END IF
 
              #--->考慮發料倍量
              IF sr[l_i].ima64 > 0
              THEN LET l_pan = (l_total MOD sr[l_i].ima64)
                   IF l_pan !=0
                   THEN LET l_double=(l_totqty /sr[l_i].ima64) + 1
                   ELSE LET l_double= l_totqty /sr[l_i].ima64
                   END IF
                   LET l_total  = l_double * sr[l_i].ima64
              ELSE LET l_total = l_totqty
              END IF
}
              INSERT INTO r590_t3
                     VALUES(sr[l_i].bmb03,    #料件編號
                            l_total)          #原發數量
              IF SQLCA.sqlcode THEN
                 UPDATE r590_t3  SET  xx05 = xx05  + l_total
                                 WHERE xx03  = sr[l_i].bmb03
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
                  THEN 
#                   CALL cl_err('ckp# error',SQLCA.sqlcode,1)   #No.FUN-660128
                   CALL cl_err3("upd","r590_t3",sr[l_i].bmb03,"",SQLCA.sqlcode,"","ckp# error",1)    #No.FUN-660128
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                   CALL cl_gre_drop_temptable(l_table)            #FUN-CB0072 add
                       EXIT PROGRAM
                 END IF
              END IF
          END IF
      END FOR
      # BOM單身已讀完
      IF l_tot < arrno OR l_tot=0 THEN
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_tot].bmb02
         LET l_times=l_times+1
      END IF
  END WHILE
END FUNCTION
 
FUNCTION r590_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680121 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否        #No.FUN-680121 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)#Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_insert        LIKE type_file.chr1,          #No.FUN-680121 CAHR(1)#可新增否
    l_update        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可更改否 (含取消)
    l_possible      LIKE type_file.num5,          #No.FUN-680121 SMALLINT#用來設定判斷重複的可能性
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_pt            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    i,j             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_jump          LIKE type_file.num5,          #No.FUN-680121 SMALLINT#判斷是否跳過AFTER ROW的處理
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL g_bma.clear()
    CALL g_bma_t.clear()
    LET g_ver='00'
    LET bst = '3'  #CHI-C20050
    INPUT BY NAME g_ver,bst WITHOUT DEFAULTS   #CHI-C20050
       ON ACTION locale
          CALL cl_dynamic_locale()     #No.TQC-720064
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
 
#No.FUN-760046 --begin
       ON ACTION CONTROLG
          CALL cl_cmdask()
#No.FUN-760046 --end
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
    END INPUT
 
    IF INT_FLAG THEN RETURN END IF
    CALL r590_b_fill()
    LET l_insert='Y'
    LET l_update='Y'
    CALL cl_opmsg('b')
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE
        LET l_exit_sw = "y"                #正常結束,除非 ^N
        LET g_bma_pageno = 1
        INPUT ARRAY g_bma WITHOUT DEFAULTS FROM s_bma.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            IF l_ac < l_ac_t THEN
                let l_jump = 1
                NEXT FIELD cnt             #跳下一ROW
            ELSE
                LET l_ac_t = 0
                let l_jump = 0
            END IF
            LET l_modify_flag = 'N'        #DEFAULT
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_sl = SCR_LINE()
            LET l_n  = ARR_COUNT()
 
            LET p_cmd='a'  #輸入新資料
            IF l_ac <= l_n then                   #DISPLAY NEWEST  
                DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt  
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bma[l_ac].* TO NULL      #900423
            LET g_bma_t[l_ac].* = g_bma[l_ac].*
            DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt
 
        BEFORE FIELD cnt                          #default 項次
            IF g_bma[l_ac].cnt IS NULL OR g_bma[l_ac].cnt = 0 THEN
               LET l_pt = 'N'
               LET g_bma[l_ac].cnt = 1
               FOR i = 1 TO g_bma.getLength()
                   IF cl_null(g_bma[i].cnt)  OR i = l_ac THEN
                      CONTINUE FOR
                   ELSE
                      IF g_bma[i].cnt >= g_bma[l_ac].cnt THEN
                         LET g_bma[l_ac].cnt = g_bma[i].cnt
                         LET l_pt = 'Y'
                      END IF
                   END IF
               END FOR
               IF l_pt = 'Y' THEN
                  LET g_bma[l_ac].cnt = g_bma[l_ac].cnt + 1
               END IF
               DISPLAY g_bma[l_ac].cnt TO s_bma[l_sl].cnt
               NEXT FIELD cnt  #FUN-CB0072 130128
            END IF
 
       #BEFORE FIELD qty  #FUN-650193
        AFTER FIELD bma01 #FUN-650193
            IF cl_null(g_bma[l_ac].bma01) THEN
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               DISPLAY g_bma[l_ac].bma01 TO s_bma[l_sl].bma01
               NEXT FIELD bma01
            END IF
            #--->讀取品名規格
            SELECT ima02 INTO g_bma[l_ac].ima02 FROM ima_file
                            WHERE ima01 = g_bma[l_ac].bma01
            IF SQLCA.sqlcode THEN
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               LET g_bma[l_ac].ima02 = g_bma_t[l_ac].ima02
               DISPLAY g_bma[l_ac].bma01 TO s_bma[l_sl].bma01
#              CALL cl_err('','mfg3403',0)   #No.FUN-660128
               CALL cl_err3("sel","ima_file",g_bma[l_ac].bma01,"","mfg3403","","",0)    #No.FUN-660128
               NEXT FIELD bma01
            END IF
            DISPLAY g_bma[l_ac].ima02 TO s_bma[l_sl].ima02
            #--->檢查是否存在於BOM 單頭檔
            IF bst = '3' THEN  #CHI-C20050
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
            #CHI-C20050---begin
            END IF  
            IF bst = '1' THEN
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
                               AND bma10 = '0'
            END IF 
            IF bst = '2' THEN
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
                               AND bma10 <> '0'
            END IF 
            #CHI-C20050---end
            IF l_cnt = 0 THEN
               IF bst = '3' THEN  #CHI-C20050
                  CALL cl_err('','mfg3399',0)
               #CHI-C20050---begin
               END IF
               IF bst = '1' THEN
                  CALL cl_err('','asf-281',0)
               END IF 
               IF bst = '2' THEN
                  CALL cl_err('','asf-282',0)
               END IF 
               #CHI-C20050---end
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               DISPLAY g_bma[l_ac].bma01 TO s_bma[l_sl].bma01
               NEXT FIELD bma01
            END IF
            IF cl_null(g_bma[l_ac].bma06) THEN #FUN-CB0072 130129
               #FUN-650193................begin
               SELECT ima910 INTO g_bma[l_ac].bma06 FROM ima_file
                  WHERE ima01=g_bma[l_ac].bma01
               DISPLAY g_bma[l_ac].bma06 TO s_bma[l_sl].bma06
               #FUN-650193................end
            END IF   #FUN-CB0072 130129 

        AFTER FIELD qty
            IF g_bma[l_ac].qty <= 0 OR cl_null(g_bma[l_ac].qty)
            THEN CALL cl_err('','mfg3400',0)
                 NEXT FIELD qty
             END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bma[l_ac].cnt) THEN   #No:MOD-9B0175 modify
#              IF (NOT cl_delete()) THEN
               IF NOT s_delarr(0,0) THEN
                  CANCEL DELETE
#                 LET l_exit_sw = "n"
#                 LET l_ac_t = l_ac
#                 EXIT INPUT
               END IF
            END IF
 
        AFTER DELETE
          LET l_n = ARR_COUNT()
          INITIALIZE g_bma[l_n+1].* TO NULL
          LET l_jump = 1
 
        AFTER ROW
            IF NOT l_jump THEN
                DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*
                IF g_bma[l_ac].bma01 IS NULL THEN
                    INITIALIZE g_bma[l_ac].* TO NULL
                    DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*
                END IF
                IF g_bma[l_ac].qty IS NULL OR g_bma[l_ac].qty <=0
                THEN
                   #---------------No:MOD-9B0175 modify                         
                   #INITIALIZE g_bma[l_ac].* TO NULL                            
                   #DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*                      
                    CALL cl_err('','mfg3400',0)                                 
                    NEXT FIELD qty                                              
                   #---------------No:MOD-9B0175 end 
                END IF
                IF p_cmd='u' THEN
                   LET g_bma_t[l_ac].* = g_bma[l_ac].*          # 900423
                END IF
            END IF
 
 
        ON ACTION CONTROLO
            IF l_ac>1 THEN
               LET g_bma[l_ac].*=g_bma[l_ac-1].*
               DISPLAY g_bma[l_ac].* TO s_bma[l_sl].*
            END IF
 
        ON ACTION clear_detail
            IF cl_confirm('abx-080') THEN   #No:MOD-9B0175 add 
               CALL g_bma.clear()
               LET l_exit_sw = "n"
               EXIT INPUT
            END IF          #No:MOD-9B0175 add
 
        ON ACTION CONTROLN
            LET l_exit_sw = "n"
            EXIT INPUT
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bma01)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = 'q_bma10'         #No:MOD-9B0175 modif  #FUN-CB0072 mark
                    LET g_qryparam.form = 'q_bma10_1'       #FUN-CB0072 add
                    LET g_qryparam.default1 = g_bma[l_ac].bma01
                    CALL cl_create_qry() RETURNING g_bma[l_ac].bma01
#                    CALL FGL_DIALOG_SETBUFFER( g_bma[l_ac].bma01 )
                    DISPLAY g_bma[l_ac].bma01 TO s_bma[l_sl].bma01
                OTHERWISE
                    EXIT CASE
            END CASE
 
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
 
       #---------------No:MOD-9B0175 add                                        
        ON ACTION cancel                                                        
           LET INT_FLAG = 0                                                     
           IF cl_end2(2) THEN                                                   
              LET g_chr1 = 'Y'                                                  
              LET INT_FLAG = 0                                                  
              EXIT INPUT                                                        
           ELSE                                                                 
              LET INT_FLAG = 1                                                  
              EXIT INPUT                                                        
           END IF                                                               
         #---------------No:MOD-9B0175 end 

          ON ACTION exit
            #---------------No:MOD-9B0175 add                                   
             LET INT_FLAG = 0                                                   
             IF cl_end2(2) THEN                                                 
                LET g_chr1 = 'Y'                                                
                LET INT_FLAG = 0                                                
                EXIT INPUT                                                      
             ELSE                                                               
            #---------------No:MOD-9B0175 end
                LET INT_FLAG = 1
                EXIT INPUT
             END IF    #No:MOD-9B0175 add
        END INPUT
 
        DELETE FROM sfx_file WHERE sfx01=g_ver
        FOR g_i = 1 TO g_bma.getLength()
           IF g_bma[g_i].bma01 IS NULL THEN
              CONTINUE FOR
           END IF
           INSERT INTO sfx_file (sfx01,sfx02,sfx03)
              VALUES (g_ver,g_bma[g_i].bma01,g_bma[g_i].qty)
        END FOR
 
        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE
 
END FUNCTION
 
FUNCTION r590_b_fill()
   DEFINE i LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_sql     STRING               #CHI-C20050
   #CHI-C20050---begin
   #DECLARE r590_bc CURSOR FOR
   #    SELECT 0,sfx02,ima02,ima910,sfx03  #FUN-650193 add ima910
   #      FROM sfx_file, OUTER ima_file
   #      WHERE sfx01 = g_ver
   #        AND  sfx_file.sfx02 = ima_file.ima01 
   #      ORDER BY 2
   #CHI-C20050---end
   #CHI-C20050---begin
   IF bst = '3' THEN
   LET l_sql = " SELECT 0,sfx02,ima02,ima910,sfx03 ",
               " FROM sfx_file, OUTER ima_file ",
               " WHERE sfx01 = '",g_ver,"'",
               "   AND sfx_file.sfx02 = ima_file.ima01 ",
               " ORDER BY 2 "
   END IF 
   IF bst = '1' THEN 
   LET l_sql = " SELECT 0,sfx02,ima02,ima910,sfx03 ",
               " FROM sfx_file, OUTER ima_file ",
               " WHERE sfx01 = '",g_ver,"'",
               "   AND sfx_file.sfx02 = ima_file.ima01 ",
               " AND  EXISTS (SELECT 1 FROM bma_file ",
               "               WHERE bma01 = sfx02 ",
               "                AND bma06 = ima910 ",
               "                AND bma10 = '0') ",
               " ORDER BY 2 "
   END IF  
   IF bst = '2' THEN 
   LET l_sql = " SELECT 0,sfx02,ima02,ima910,sfx03 ",
               " FROM sfx_file, OUTER ima_file ",
               " WHERE sfx01 = '",g_ver,"'",
               "   AND sfx_file.sfx02 = ima_file.ima01 ",
               " AND  EXISTS (SELECT 1 FROM bma_file ",
               "               WHERE bma01 = sfx02 ",
               "                AND bma06 = ima910 ",
               "                AND bma10 <> '0') ",
               " ORDER BY 2 "
   END IF 
   PREPARE r590_pb FROM l_sql
   DECLARE r590_bc CURSOR FOR r590_pb
   CALL g_bma.clear()
   #CHI-C20050---end
   LET i = 1
   FOREACH r590_bc INTO g_bma[i].*
     IF STATUS THEN EXIt FOREACH END IF
     LET g_bma[i].cnt = i
     LET g_bma_t[i].* = g_bma[i].*
     LET i = i+1
     IF i > 400 THEN EXIT FOREACH END IF
     IF i     > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
     END IF
   END FOREACH
   CALL g_bma.deleteElement(i)
   CALL SET_COUNT(i-1)
   LET g_rec_b=i-1
END FUNCTION
#Patch....NO.TQC-610037 <001> #
#TQC-A60097



###GENGRE###START
FUNCTION asfg590_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg590")
        IF handler IS NOT NULL THEN
            START REPORT asfg590_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                 #     ," ORDER BY chr1,order,cnt"           #FUN-CB0072 add
                       ," ORDER BY chr1,bma01,cnt,count,bmb03"      #FUN-CB0072 add
          
            DECLARE asfg590_datacur1 CURSOR FROM l_sql
            FOREACH asfg590_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg590_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg590_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg590_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_mark   LIKE type_file.chr1       #FUN-CB0072 add
    DEFINE l_ima02_ima021_ima25 STRING        #FUN-CB0072 add
    DEFINE l_qty1_fmt    STRING               #FUN-CB0072 add
    DEFINE l_qty2_fmt    STRING               #FUN-CB0072 add
    DEFINE l_qty4_fmt    STRING               #FUN-CB0072 add
    
    ORDER EXTERNAL BY sr1.chr1
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.chr1

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
           
           #FUN-CB0072--add--str---
            IF sr1.mark = 'Y' THEN
               LET l_mark = '*'
            ELSE 
               LET l_mark = ' '
            END IF
            PRINTX l_mark
            LET l_ima02_ima021_ima25 = sr1.ima02,'  ',sr1.ima021,'  ',sr1.ima25
            PRINTX l_ima02_ima021_ima25

            LET l_qty1_fmt = cl_gr_numfmt('sfa_file','sfa03',sr1.num1)
            LET l_qty2_fmt = cl_gr_numfmt('sfa_file','sfa03',sr1.num1)
            LET l_qty4_fmt = cl_gr_numfmt('sfa_file','sfa03',sr1.num1)
            PRINTX l_qty1_fmt,l_qty2_fmt,l_qty4_fmt
           #FUN-CB0072--add--end---
 
            PRINTX sr1.*

        AFTER GROUP OF sr1.chr1

        
        ON LAST ROW

END REPORT
###GENGRE###END
