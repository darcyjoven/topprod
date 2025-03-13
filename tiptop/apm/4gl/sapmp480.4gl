# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp480.4gl
# Descriptions...: 採購單 BOM 展開
# Date & Author..: Jackson
# Modify.........: No.FUN-550095 05/06/02 By Mandy
# Modify.........: No.FUN-560084 05/06/18 By Carrier 雙單位內容修改
# Modify.........: No.FUN-560165 05/06/22 By Mandy (A18)請購單無法依 BOM 展開尾階 (料號：A123456789B123456789C123456789D123456789)
# Modify.........: No.FUN-560165 05/06/22 By Mandy 因為料號已放大,所以在程式spmp480.4gl 組SQL的l_cmd也要跟著放大,否則l_cmd會被截斷
# Modify.........: No.MOD-560162 05/06/22 By Mandy 依BOM輸入時，BOM應可增加查詢選取之功能。
# Modify.........: No.MOD-560115 05/06/19 By kim FUNCTION chk_part() check 加秀cl_err('料件必須是自製件')
# Modify.........: No.MOD-5B0321 05/11/29 By Rosayu 單身輸入方式－－＞依BOM產生時，未考慮委外件，造成委外件無法展下階
# Modify.........: No.MOD-640191 06/04/09 By Mandy 預設統購否pml190抓ima913
# Mofify.........: No.FUN-640121 06/04/20 By Sarah 畫面增加特性代碼(ima910)欄位以供輸入
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-660126 06/06/26 By Clinton 1.apmp480 元件之入庫/到廠/交貨日期應一併推算!
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-690047 06/09/28 By Sarah pml38預設等於pmk45
# Modify.........: No.TQC-6A0011 06/10/12 By Mandy MOD-640191修正有筆誤
# Modify.........: NO.CHI-6A0016 06/10/27 by Yiting pml191/pml192要有預設值
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.MOD-7B0202 07/12/03 By Carol SQL加條件check bma06
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-870124 08/08/01 By jan 服飾作業新增欄位
# Modify.........: No.FUN-880072 08/08/19 By jan 服飾作業過單
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980136 09/08/19 By Smapmin pml91為空時,要給一個空白
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 流通零售修改
# Modify.........: No.MOD-980213 09/08/28 By Dido 單身專案預設請購單頭專案代號
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0155 09/10/28 By liuxqa order修改。
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No:MOD-9C0329 09/12/23 By Smapmin 料號變數清空
# Modify.........: No:MOD-A10048 10/01/08 By Smapmin ima45/ima46若為空時,default為0
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-A70034 10/07/21 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:TQC-AB0397 10/11/30 By wangxin 給pml91默認值
# Modify.........: No:MOD-B40136 11/04/19 By Summer 開窗是使用q_bma,改為以bmb_file為主join ima_file的q_bmb10
# Modify.........: No:MOD-B50091 11/05/13 By Summer 請購單需管制時需對供應商管制
# Modify.........: No:FUN-910088 11/11/25 By chenjing 增加數量欄位小數取位
# Modify.........: No:CHI-B70008 12/02/29 By Summer 請購單身依BOM展開,可展開P part
# Modify.........: No:MOD-BC0065 12/02/29 By Summer 請購單身依BOM展開,可展開X虛擬料件
# Modify.........: No:MOD-C70076 12/07/06 By SunLM 添加采购料件单位与发料单位转换率
# Modify.........: No:MOD-C80149 12/10/18 By Nina 增加串bma_file,並排除無效BOM

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_pml        RECORD LIKE pml_file.*,     
    tm  RECORD	
          part   LIKE ima_file.ima01,
          ima910 LIKE ima_file.ima910,    #FUN-640121 add
          qty    LIKE sfb_file.sfb08,
          idate  LIKE type_file.dat,      #No.FUN-680136 DATE
          pmlislk01  LIKE pmli_file.pmlislk01,#No.FUN-870124
          a      LIKE type_file.chr1   	  #No.FUN-680136 VARCHAR(1)
        END RECORD,
    #No.FUN-560084  --begin
    g_cnt        LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    g_factor     LIKE img_file.img21,
    g_ima44      LIKE ima_file.ima44,
    g_ima25      LIKE ima_file.ima25,
    g_ima906     LIKE ima_file.ima906,
    g_ima907     LIKE ima_file.ima907,
    #No.FUN-560084  --end   
    g_ccc        LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    g_argv1      LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
    g_pmk13      LIKE pmk_file.pmk13,     #FUN-670051 #MOD-B50091 add ,
    g_pmk09      LIKE pmk_file.pmk09,     #MOD-B50091 add
    g_pmk22      LIKE pmk_file.pmk22      #MOD-B50091 add
 
FUNCTION p480(p_argv1)
 
   DEFINE l_time  LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          l_sql   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
          l_n1    LIKE type_file.num5,    #No.FUN-870124
          p_argv1 LIKE pml_file.pml01     #採購單號
 
   WHENEVER ERROR CONTINUE
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN 
       CALL cl_err(p_argv1,'mfg3527',0) 
       RETURN
    END IF
    LET g_ccc=0
    LET g_pml.pml01  = p_argv1
    #FUN-670051...............begin
    SELECT pmk13 INTO g_pmk13 FROM pmk_file
                             WHERE pmk01=p_argv1
    IF SQLCA.sqlcode THEN LET g_pmk13=NULL END IF
    #FUN-670051...............end
    LET tm.part = ''   #MOD-9C0329
    LET tm.qty=0
    LET tm.idate=g_today
    LET tm.a='N'
   #SELECT pmk02,pmk25 INTO g_pml.pml011,g_pml.pml16                     #FUN-690047 mark
    SELECT pmk02,pmk25,pmk45,pmk05 INTO g_pml.pml011,g_pml.pml16,g_pml.pml38,g_pml.pml12   #FUN-690047	#MOD-980213
      FROM pmk_file
     WHERE pmk01=g_pml.pml01
    IF SQLCA.SQLCODE THEN
#      CALL cl_err(g_pml.pml01,sqlca.sqlcode,2)   #No.FUN-660129
       CALL cl_err3("sel","pmk_file",g_pml.pml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN
    END IF
 
WHILE TRUE 
    #-->條件畫面輸入
    OPEN WINDOW p480_w AT 6,30 WITH FORM "apm/42f/apmp480" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmp480")
#No.FUN-870124--BEGIN--
    IF NOT s_industry('slk') THEN
        CALL cl_set_comp_visible("pmlislk01",FALSE)   
    END IF
#No.FUN-870124--END----
       
 
    CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')   #FUN-640121 add
 
    INPUT BY NAME tm.* WITHOUT DEFAULTS
       AFTER FIELD part
          IF NOT chk_part() THEN NEXT FIELD part END IF
      #start FUN-640121 add
       AFTER FIELD ima910
          IF cl_null(tm.ima910) THEN 
             LET tm.ima910 = ' ' 
          ELSE
             SELECT COUNT(*) INTO g_cnt FROM bma_file
              WHERE bma01=tm.part AND bma06=tm.ima910
             IF g_cnt = 0 THEN
                CALL cl_err('','abm-618',0)
                NEXT FIELD ima910
             END IF
          END IF
      #end FUN-640121 add
       AFTER FIELD qty
          IF cl_null(tm.qty) OR tm.qty<=0 THEN NEXT FIELD qty END IF
       AFTER FIELD idate
          IF cl_null(tm.idate) OR tm.idate < g_today 
             THEN NEXT FIELD idate END IF
#No.FUN-870124--BEGIN
       AFTER  FIELD pmlislk01
         SELECT count(*) INTO l_n1 FROM skd_file
          WHERE skd01 = tm.pmlislk01
            AND skd04 = 'Y'
         IF l_n1 = 0 THEN
            CALL cl_err('','mfg420',0)
            NEXT FIELD pmlislk01
         END IF
#No.FUN-870124--END--
       AFTER FIELD a
          IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN NEXT FIELD a END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       #MOD-560162 add
       ON ACTION controlp
          CASE
             WHEN INFIELD(part)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_bmb10" #MOD-B40136 mod q_bma->q_bmb10
                LET g_qryparam.default1 = tm.part
                CALL cl_create_qry() RETURNING tm.part
                DISPLAY tm.part TO FORMONLY.part
                NEXT FIELD part
              #No.FUN-870124--BEGIN--
             WHEN INFIELD(pmlislk01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_skd1"
                LET g_qryparam.default1 = tm.pmlislk01
                CALL cl_create_qry() RETURNING tm.pmlislk01
                DISPLAY tm.pmlislk01 TO FORMONLY.pmlislk01
                NEXT FIELD pmlislk01
              #No.FUN-870124--END--
 
             OTHERWISE EXIT CASE
          END CASE
       #MOD-560162(end)
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-580031 --start--
       BEFORE INPUT
           CALL cl_qbe_init()
       #No.FUN-580031 ---end---
 
       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p480_w RETURN END IF
    CALL p480_init()
    CALL p480_bom()
    CLOSE WINDOW p480_w
    EXIT WHILE
END WHILE          
END FUNCTION
 
FUNCTION p480_init()
   DEFINE l_ima491   LIKE ima_file.ima491   #No.TQC-640132
   DEFINE l_ima49    LIKE ima_file.ima49    #No.TQC-640132
   
    LET g_pml.pml02=0
    LET g_pml.pml03=' '
    LET g_pml.pml06=' '
    LET g_pml.pml10=' '
    LET g_pml.pml11='N'
    LET g_pml.pml121=' '
    LET g_pml.pml122=' '
    LET g_pml.pml123=' '
    LET g_pml.pml13=0  
    LET g_pml.pml14=g_sma.sma886[1,1]
    LET g_pml.pml15=g_sma.sma886[2,2]
    LET g_pml.pml18=""
    LET g_pml.pml20=0  
    LET g_pml.pml21=0  
    LET g_pml.pml23='Y'
    LET g_pml.pml30=0  
    LET g_pml.pml31=0  
    LET g_pml.pml32=0  
    LET g_pml.pml33=tm.idate
    LET g_pml.pml34=tm.idate
    LET g_pml.pml35=tm.idate
   #LET g_pml.pml38='Y'     #FUN-690047 mark
    LET g_pml.pml40=' '
    LET g_pml.pml41=' '
    LET g_pml.pml43=0
    LET g_pml.pml431=0
    LET g_pml.pml44=0
END FUNCTION
 
FUNCTION chk_part()
  DEFINE  l_ima08    LIKE ima_file.ima08,
          l_imaacti  LIKE ima_file.imaacti,
          l_cnt      LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_err      LIKE type_file.num5       #No.FUN-680136 SMALLINT
 
         LET l_err=1
        #檢查該料件是否存在           
         SELECT ima08,imaacti INTO l_ima08,l_imaacti FROM ima_file
          WHERE ima01=tm.part
             CASE 
               #WHEN l_ima08 != 'M' #MOD-5B0321 mark
              #WHEN l_ima08 NOT MATCHES '[MS]'  #MOD-5B0321 add #CHI-B70008 mark
              #WHEN l_ima08 NOT MATCHES '[MSP]'  #CHI-B70008    #MOD-BC0065 mark
               WHEN l_ima08 NOT MATCHES '[MSPX]' #CHI-B70008    #MOD-BC0065
                     CALL cl_err(tm.part,'apm-025',2) #MOD-560115
                    LET l_err=0
               WHEN l_imaacti = 'N'
                    CALL cl_err(tm.part,'mfg0301',2)
                    LET l_err=0
               WHEN SQLCA.SQLCODE = 100
                    CALL cl_err(tm.part,'mfg0002',2)
                    LET l_err=0
               WHEN SQLCA.SQLCODE != 0
                    CALL cl_err(tm.part,sqlca.sqlcode,2)
                    LET l_err=0
            END CASE    
         IF l_err THEN
            #檢查該料件是否有產品結構
            SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=tm.part
            IF SQLCA.SQLCODE THEN 
                CALL cl_err(tm.part,sqlca.sqlcode,2)
                LET l_err=0
            END IF
            IF l_cnt=0 OR cl_null(l_cnt) THEN
                CALL cl_err(tm.part,'mfg2602',2)
                LET l_err=0
            END IF
         END IF
    RETURN l_err
END FUNCTION
 
###展BOM
 
 FUNCTION p480_bom()
   DEFINE l_ima562     LIKE ima_file.ima562,
          l_ima910     LIKE ima_file.ima910, #FUN-550095 add
          l_ima55      LIKE ima_file.ima55, 
          l_ima86      LIKE ima_file.ima86, 
          l_ima86_fac  LIKE ima_file.ima86_fac
 
    SELECT ima562,ima55,ima86,ima86_fac,ima910 INTO  #FUN-550095 add ima910
      l_ima562,l_ima55,l_ima86,l_ima86_fac,l_ima910  #FUN-550095 add ima910
        FROM ima_file
      # WHERE ima01=p_part AND imaacti='Y'
        WHERE ima01=tm.part AND imaacti='Y'
   #IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF SQLCA.sqlcode THEN RETURN END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF #FUN-550095 add
   #start FUN-640121 add
    IF tm.ima910 != ' ' THEN
       LET l_ima910 = tm.ima910
    END IF
   #end FUN-640121 add
    CALL p480_bom2(0,tm.part,l_ima910,tm.qty,1)
       IF g_ccc=0 THEN
           LET g_errno='asf-014'
       END IF    #有BOM但無有效者
    
    MESSAGE ""
  # RETURN g_ccc
    RETURN      
END FUNCTION
 
FUNCTION p480_bom2(p_level,p_key,p_key2,p_total,p_QPA) #FUN-550095 add p_key2
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
 
DEFINE
    p_level      LIKE type_file.num5,         #level code    #No.FUN-680136 SMALLINT
    p_total      LIKE sfb_file.sfb08,         #No.FUN-680136 DECIMAL(13,5)
#    p_QPA        LIKE ima_file.ima26, 	      #No.FUN-680136 DECIMAL(16,8) #FUN-A20044
    p_QPA        LIKE type_file.num15_3,      #FUN-A20044
#    l_QPA        LIKE ima_file.ima26,         #No.FUN-680136 DECIMAL(11,7) #FUN-A20044
    l_QPA        LIKE type_file.num15_3,        #FUN-A20044
    l_total      LIKE sfb_file.sfb08,         #原發數量      #No.FUN-680136 DECIMAL(13,5)
    l_total2     LIKE sfb_file.sfb08,         #應發數量      #No.FUN-680136 DECIMAL(13,5)
    p_key        LIKE bma_file.bma01,         #assembly part number
    p_key2       LIKE bma_file.bma06,         #FUN-550095 add
    l_ac,l_i,l_x LIKE type_file.num5,         #No.FUN-680136 SMALLINT
    arrno        LIKE type_file.num5,         #BUFFER SIZE #No.FUN-680136 SMALLINT
    b_seq,l_double LIKE type_file.num10,      #restart sequence (line number) 	#No.FUN-680147
    l_ima45      LIKE ima_file.ima45,
    l_ima46      LIKE ima_file.ima46,
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #項次
        bmb03 LIKE bmb_file.bmb03, #料號                     
        bmb16 LIKE bmb_file.bmb16, #取替代碼
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #損耗率
        bmb10 LIKE bmb_file.bmb10, #發料單位
        bmb10_fac LIKE bmb_file.bmb10_fac, #換算率
        ima08 LIKE ima_file.ima08, #來源碼
        ima02 LIKE ima_file.ima02, #品名規格
        ima05 LIKE ima_file.ima05, #版本  
        ima44 LIKE ima_file.ima44, #採購單位
        ima25 LIKE ima_file.ima25, #庫存單位 
        ima44_fac LIKE ima_file.ima44_fac,  #採購單位/庫存單位 換算率
        ima49  LIKE ima_file.ima49,  #到廠前置期
        ima491 LIKE ima_file.ima491, #入庫前置期
        bma01 LIKE bma_file.bma01, #項次
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
    END RECORD,
    l_ima08     LIKE ima_file.ima08,        #source code
#    l_ima26     LIKE ima_file.ima26,        #QOH #FUN-A20044
    l_avl_stk_mpsmrp     LIKE type_file.num15_3,         #FUN-A20044
    l_chr       LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
    l_ActualQPA LIKE bmb_file.bmb06,        #No.FUN-680136 DECIMAL(11,7)
    l_cnt,l_c   LIKE type_file.num5,        #No.FUN-680136 SMALLINT
   #l_cmd       LIKE type_file.chr1000,     #FUN-560165  #No.FUN-680136 VARCHAR(400)
    l_cmd       LIKE type_file.chr1000,     #FUN-560165  #No.FUN-680136 VARCHAR(1000)
    l_status    LIKE type_file.num5,   	    #No.FUN-680136 SMALLINT
    l_factor    LIKE ima_file.ima31_fac     #No.FUN-680136 DECIMAL(16,8)
DEFINE  l_ima908     LIKE ima_file.ima908   #No.TQC-6B0124 add
#No.FUN-560084  --begin
DEFINE  l_ima44      LIKE ima_file.ima44
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
#No.FUN-560084  --end
DEFINE l_pmli   RECORD LIKE pmli_file.*     #NO.FUN-7B0018
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035  
DEFINE  l_ima915     LIKE ima_file.ima915   #MOD-B50091 add
DEFINE  l_ima55      LIKE ima_file.ima55    #MOD-C70076 add
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",
                  "        ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,bma01,",
                  "        bmb081,bmb082 ", #No.FUN-A70034
                  #"   FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03=ima01 LEFT OUTER JOIN bma_file ON bmb03=bma01 AND bmb29=bma06 ",  #TQC-9A0155 mod  #MOD-C80149 mark
                  "   FROM bmb_file, ima_file, bma_file ",  #MOD-C80149 add
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ?",
                  "    AND bmb03 = ima01 AND bmb01 = bma01 AND bmb29=bma06 ", #MOD-C80149 add
                  "    AND bmb29='",p_key2,"'", #FUN-550095 add
                  #"    AND bmb_file.bmb03 = bma_file.bma01",      #TQC-9A0155 mark
                  #"    AND bmb_file.bmb29 = bma_file.bma06",      #MOD-7B0202-add #TQC-9A0155mark
                  #"    AND bmb_file.bmb03 = ima_file.ima01",      #TQC-9A0155 mark
                  "    AND (bmb04 <='",tm.idate,"' OR bmb04 IS NULL) ", 
                  "    AND (bmb05 >'",tm.idate,"' OR bmb05 IS NULL)", 
                  "    AND bmaacti = 'Y'", #MOD-C80149 add
                  #" ORDER BY 1"   #TQC-9A0155
                  " ORDER BY bmb03" #TQC-9A0155 mod
        PREPARE bom_p FROM l_cmd
        DECLARE bom_cs CURSOR FOR bom_p
       #IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF
 
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH bom_cs USING b_seq INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
                LET sr[l_ac].bmb10_fac=1
            END IF
            IF cl_null(sr[l_ac].bmb16) THEN    #若未定義, 則給予'正常'
                LET sr[l_ac].bmb16='0'
            ELSE
               IF sr[l_ac].bmb16='2' THEN LET sr[l_ac].bmb16='1' END IF
            END IF
            #FUN-8B0035--BEGIN--                                                                                                    
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
 
            #No.FUN-A70034  --Begin
            ##inflate yield
            #IF g_sma.sma71='N' THEN LET sr[l_i].bmb08=0 END IF
            ##Actual QPA
            #LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
            #LET l_QPA=sr[l_i].bmb06 * p_QPA
            #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100  #量

            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA)
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_QPA_1 = l_ActualQPA
            LET l_total = l_total_1
            #No.FUN-A70034  --End  
   
           #IF g_sma.sma78='1' THEN        #使用庫存單位
           #    LET l_total=l_total*sr[l_i].bmb10_fac
           #END IF
 
            IF sr[l_i].ima08='X' THEN       ###為 X PART 由參數決定
               #------------No.FUN-670041 mosify
               #IF g_sma.sma29='N' THEN #phantom
               #    CONTINUE FOR #do'nt blow through
               #ELSE
               #   #IF sr[l_i].ima37='1' AND g_mps='N' THEN #MPS part
               #   #    CONTINUE FOR #do'nt blow through
               #   #END IF
               #END IF
               #------------No.FUN-670041 end
                IF sr[l_i].bma01 IS NOT NULL THEN 
                   #CALL p480_bom2(p_level,sr[l_i].bmb03,' ',     #FUN-550095 add ' '#FUN-8B0035
                    #No.FUN-A70034  --Begin
                    #CALL p480_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],     #FUN-8B0035
                    #    p_total*sr[l_i].bmb06,l_ActualQPA)
                    #添加转换率
                    #MOD-C70076 add begin---------
                    SELECT ima55 INTO l_ima55 FROM ima_file
                     WHERE ima01 = sr[l_i].bmb03
                    CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,l_ima55) 
                         RETURNING l_status,l_factor   
                    LET l_total = l_total*l_factor
                    LET l_QPA_1   = l_QPA_1 * l_factor   
                    #添加转换率
                    #MOD-C70076 add end---------                     
                    CALL p480_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],     #FUN-8B0035
                         l_total,l_QPA_1)
                    #No.FUN-A70034  --End  
                END IF
            END IF
 
 
            IF sr[l_i].ima08='M' OR 
               sr[l_i].ima08='S' THEN     ###為 M PART 由人決定
               IF tm.a='Y' THEN
                  IF sr[l_i].bma01 IS NOT NULL THEN 
                    #CALL p480_bom2(p_level,sr[l_i].bmb03,' ',    #FUN-550095 add ' '#FUN-8B0035
                     #No.FUN-A70034  --Begin
                     #CALL p480_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    #FUN-8B0035
                     #     p_total*sr[l_i].bmb06,l_ActualQPA)
                     #MOD-C70076 add begin---------
                     SELECT ima55 INTO l_ima55 FROM ima_file
                      WHERE ima01 = sr[l_i].bmb03
                     CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,l_ima55) 
                          RETURNING l_status,l_factor   
                     LET l_total = l_total*l_factor
                     LET l_QPA_1   = l_QPA_1 * l_factor   
                     #添加转换率
                     #MOD-C70076 add end---------
                     CALL p480_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    #FUN-8B0035
                          l_total,l_QPA_1)
                     #No.FUN-A70034  --End  
                  ELSE
                      CONTINUE FOR
                  END IF
               ELSE
                  CONTINUE FOR
               END IF
            END IF
            IF NOT(sr[l_i].ima08='X' OR sr[l_i].ima08='M' OR
                   sr[l_i].ima08='S') 
               THEN  
              LET g_ccc=g_ccc+1
              #SELECT MAX(pml02) INTO g_pml.pml02
              #  FROM pml_file
              # WHERE pml01=g_pml.pml01
               LET g_pml.pml04=sr[l_i].bmb03
               LET g_pml.pml041=sr[l_i].ima02
               LET g_pml.pml05=NULL  #no.4649
               LET g_pml.pml07=sr[l_i].ima44
               LET g_pml.pml08=sr[l_i].ima25
               LET g_pml.pml09=sr[l_i].ima44_fac
               IF sr[l_i].bmb16='0' THEN
                  LET g_pml.pml42='0'
               ELSE
                  LET g_pml.pml42='1'
               END IF
               #---------- modi in 00/01/19 NO:1077 ------------------
               CALL s_umfchk(g_pml.pml04,sr[l_i].bmb10,sr[l_i].ima44)
                    RETURNING l_status,l_factor
               IF l_status THEN
                  CALL cl_err(g_pml.pml04,'mfg1206',1)
                  CONTINUE FOR
               END IF
               LET g_pml.pml20=l_total * l_factor
               LET g_pml.pml20 = s_digqty(g_pml.pml20,g_pml.pml07)   #FUN-910088--add--
               #------------------------------------------------------

               #MOD-B50091 add --start--
               #請購料件/供應商控制
               IF (g_pml.pml04 != 'MISC') THEN
                  SELECT pmk09,pmk22 INTO g_pmk09,g_pmk22 
                    FROM pmk_file
                   WHERE pmk01=g_pml.pml01
                  IF SQLCA.sqlcode THEN
                     LET g_pmk09=NULL 
                     LET g_pmk22=NULL 
                  END IF
                  SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pml.pml04 
                  IF l_ima915='1' OR l_ima915='3' AND NOT cl_null(g_pmk09) AND NOT cl_null(g_pmk22) THEN
                     CALL p480_pmh()
                     IF NOT cl_null(g_errno) THEN
                        CONTINUE FOR
                     END IF
                  END IF
               END IF
               #MOD-B50091 add--end--
 
             ### 寫進 pml_file
               SELECT COUNT(*) INTO l_cnt FROM pml_file
                WHERE pml01=g_pml.pml01 AND pml04=g_pml.pml04
               IF l_cnt > 0 THEN   #Duplicate   數量相加
                  #No.FUN-560084  --begin
                  SELECT ima25,ima44,ima906,ima907 
                    INTO g_ima25,g_ima44,g_ima906,g_ima907
                    FROM ima_file WHERE ima01=g_pml.pml04
                  IF SQLCA.sqlcode =100 THEN                                                  
                     IF g_pml.pml04 MATCHES 'MISC*' THEN                                
                        SELECT ima25,ima44,ima906,ima907 
                          INTO g_ima25,g_ima44,g_ima906,g_ima907                               
                          FROM ima_file WHERE ima01='MISC'                                    
                     END IF                                                                   
                  END IF                                                                      
                  IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF
                  IF g_ima906 = '3' THEN
                     LET g_factor = 1
                     CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83)
                          RETURNING g_cnt,g_factor
                     IF g_cnt = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET g_pml.pml85 = g_pml.pml20*g_factor
                     LET g_pml.pml85 = s_digqty(g_pml.pml85,g_pml.pml83)   #FUN-910088--add--
                  END IF
                 #--------------No.TQC-6B0124 add
                 #判斷若使用多單位時，單位一的數量default建議請購量
                 #否則單位一數量不default任何值
                  IF g_sma.sma115 = 'Y' THEN 
                     LET g_pml.pml82 = g_pml.pml20
                     LET g_pml.pml82 = s_digqty(g_pml.pml82,g_pml.pml80)    #FUN-910088--add--
                  ELSE 
                     LET g_pml.pml82 = 0
                  END IF
                 
                 CALL p480_set_pml87(g_pml.pml04,g_pml.pml07,
                                    g_pml.pml86,g_pml.pml20)
                                    RETURNING g_pml.pml87
                 LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)    #FUN-910088--add--
                 #--------------No.TQC-6B0124 end
                  UPDATE pml_file SET pml20=pml20+g_pml.pml20,
                                      pml82=pml82+g_pml.pml82,     #No.TQC-6B0124 modify
                                      pml87=pml87+g_pml.pml87,     #No.TQC-6B0124 modify
                                      pml85=pml85+g_pml.pml85 
                   WHERE pml01=g_pml.pml01 AND pml04=g_pml.pml04
                  #No.FUN-560084  --end  
               ELSE
                  LET g_pml.pml02=g_pml.pml02+1
                  #No.FUN-560084  --begin
                  IF g_sma.sma115 = 'Y' THEN
                     SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
                       FROM ima_file 
                      WHERE ima01=g_pml.pml04
                     LET g_pml.pml80=g_pml.pml07
                     LET l_factor = 1
                     CALL s_umfchk(g_pml.pml04,g_pml.pml80,l_ima44)
                          RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN
                        LET l_factor = 1
                     END IF
                     LET g_pml.pml81=l_factor
                     LET g_pml.pml82=g_pml.pml20
                     LET g_pml.pml83=l_ima907
                     LET l_factor = 1
                     CALL s_umfchk(g_pml.pml04,g_pml.pml83,l_ima44)
                          RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN
                        LET l_factor = 1
                     END IF
                     LET g_pml.pml84=l_factor
                     LET g_pml.pml85=0
                     IF l_ima906 = '3' THEN
                        LET l_factor = 1
                        CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83)
                             RETURNING l_cnt,l_factor
                        IF l_cnt = 1 THEN
                           LET l_factor = 1
                        END IF
                        LET g_pml.pml85=g_pml.pml82*l_factor
                        LET g_pml.pml85 = s_digqty(g_pml.pml85,g_pml.pml83)   #FUN-910088--add--
                     END IF
                  END IF
                 #----------No.TQC-6B0124 modify
                 #LET g_pml.pml86=g_pml.pml07
                 #LET g_pml.pml87=g_pml.pml20
                  SELECT ima908 INTO l_ima908
                    FROM ima_file 
                   WHERE ima01=g_pml.pml04
                  IF cl_null(l_ima908) THEN LET l_ima908 = g_pml.pml07 END IF
                 
                  IF g_sma.sma116 NOT MATCHES '[13]' THEN
                     LET g_pml.pml86 = g_pml.pml07
                  ELSE
                     LET g_pml.pml86 = l_ima908
                  END IF
                  CALL p480_set_pml87(g_pml.pml04,g_pml.pml07,
                                      g_pml.pml86,g_pml.pml20) RETURNING g_pml.pml87
                  LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)   #FUN-910088--add--
                 #----------No.TQC-6B0124 end
                  #No.FUN-560084  --end   
                  #MOD-640191 -----add-----
                  #預設統購否pml190
                  IF cl_null(g_pml.pml190) THEN
#                      SELECT ima913 INTO g_pml.pml190
                       SELECT ima913,ima914 INTO g_pml.pml190,g_pml.pml191   #NO.CHI-6A0016
                        FROM ima_file
                       WHERE ima01 = g_pml.pml04
                      IF STATUS = 100 THEN
                         #LET g_pml.pml04 = 'N'  #TQC-6A0011
                          LET g_pml.pml190 = 'N' #TQC-6A0011
                      END IF
                  END IF
                  #MOD-640191 -----end-----
                  LET g_pml.pml192 = 'N'    #NO.CHI-6A0016
                  #TQC-660126---
                  CALL s_aday(g_pml.pml35,-1,sr[l_i].ima491) RETURNING g_pml.pml34
                  CALL s_aday(g_pml.pml34,-1,sr[l_i].ima49) RETURNING g_pml.pml33
                  #TQC-660126---
                  #FUN-670051...............begin
                  LET g_pml.pml930=s_costcenter(g_pmk13)
                  #FUN-670051...............end
                  LET g_pml.pmlplant = g_plant #FUN-980006
                  LET g_pml.pmllegal = g_legal #FUN-980006
                  IF cl_null(g_pml.pml91) THEN LET g_pml.pml91 = 'N' END IF   #TQC-980136  #TQC-AB0397 add 'N'
                  LET g_pml.pml49 = '1' #No.FUN-870007
                  LET g_pml.pml50 = '1' #No.FUN-870007
                  LET g_pml.pml54 = '2' #No.FUN-870007
                  LET g_pml.pml56 = '1' #No.FUN-870007
                  LET g_pml.pml92 = 'N' #FUN-9B0023
                  INSERT INTO pml_file VALUES(g_pml.*)
                  #NO.FUN-7B0018 08/01/31 add --begin
                  IF SQLCA.SQLCODE THEN 
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                  ELSE   #No.FUN-830132
                     IF NOT s_industry('std') THEN
                        INITIALIZE l_pmli.* TO NULL
                        LET l_pmli.pmli01 = g_pml.pml01
                        LET l_pmli.pmli02 = g_pml.pml02
                        LET l_pmli.pmlislk01 = tm.pmlislk01   #No.FUN-870124
                        IF NOT s_ins_pmli(l_pmli.*,'') THEN
                           ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                        END IF
                     END IF
                  #NO.FUN-7B0018 08/01/31 add --end
                  END IF
               END IF
               #NO.FUN-7B0018 08/01/31 add --begin
#              IF SQLCA.SQLCODE THEN 
#                    ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
#              END IF
               #NO.FUN-7B0018 08/01/31 add --end
            END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
     END IF
 
 
    #重新把資料拿出來處理 (考慮最少採購量及倍量)
    DECLARE p480_cs CURSOR FOR
        SELECT pml_file.*,ima45,ima46
        FROM pml_file LEFT OUTER JOIN ima_file ON pml04 = ima01     #TQC-9A0155 mod
        WHERE pml01=g_pml.pml01
         # AND pml_file.pml04=ima_file.ima01   #TQC-9A0155 mark
         #ORDER BY 2       #No.TQC-9A0155 mark
         ORDER BY pml01     #No.TQC-9A0155 mod 
        FOREACH p480_cs INTO g_pml.*,l_ima45,l_ima46
           #No.+045 010403 by plum
             #IF SQLCA.SQLCODE THEN CALL cl_err(sqlca.sqlcode,'foreach p480_cs',2)   #No.FUN-660129
           IF SQLCA.SQLCODE THEN 
              CALL cl_err('foreach p480_cs',SQLCA.SQLCODE,2)   #No.FUN-660129
              EXIT FOREACH END IF
           #-----MOD-A10048---------
           IF cl_null(l_ima45) THEN LET l_ima45 = 0 END IF
           IF cl_null(l_ima46) THEN LET l_ima46 = 0 END IF
           #-----END MOD-A10048-----
           #-->考慮最少採購量/倍量
           IF g_pml.pml20 > 0 THEN
              IF g_pml.pml20 > l_ima46 THEN
                 IF l_ima45 > 0 THEN
                    IF ((g_pml.pml20*1000) MOD (l_ima45*1000)) != 0
                       THEN LET l_double = (g_pml.pml20/l_ima45) + 1
                       LET g_pml.pml20=l_double*l_ima45
                    END IF
                 END IF
              ELSE 
                LET g_pml.pml20=l_ima46
              END IF
              LET g_pml.pml20 = s_digqty(g_pml.pml20,g_pml.pml07)   #FUN-910088--add--
           ELSE
              LET g_pml.pml20=0
           END IF
           #No.FUN-560084  --begin
           SELECT ima44,ima906,ima907 INTO g_ima44,g_ima906,g_ima907
             FROM ima_file WHERE ima01=g_pml.pml04
           IF g_ima906 = '3' THEN
              LET g_factor = 1
              CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83)
                   RETURNING g_cnt,g_factor
              IF g_cnt = 1 THEN
                 LET g_factor = 1
              END IF
              LET g_pml.pml85 = g_pml.pml20*g_factor
              LET g_pml.pml85 = s_digqty(g_pml.pml85,g_pml.pml83)    #FUN-910088--add--
           END IF
          #--------------No.TQC-6B0124 add
          #判斷若使用多單位時，單位一的數量default建議請購量
          #否則單位一數量不default任何值
           IF g_sma.sma115 = 'Y' THEN 
              LET g_pml.pml82 = g_pml.pml20
              LET g_pml.pml82 = s_digqty(g_pml.pml82,g_pml.pml80)   #FUN-910088--add--
           ELSE 
              LET g_pml.pml82 = 0
           END IF
          
          CALL p480_set_pml87(g_pml.pml04,g_pml.pml07,
                             g_pml.pml86,g_pml.pml20)
                             RETURNING g_pml.pml87
          LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)    #FUN-910088--add--
          #--------------No.TQC-6B0124 end
           UPDATE pml_file SET pml20=g_pml.pml20,
                               pml82=g_pml.pml82,     #No.TQC-6B0124 modify
                               pml87=g_pml.pml87,     #No.TQC-6B0124 modify
                               pml85=g_pml.pml85
            WHERE pml01=g_pml.pml01 AND pml02=g_pml.pml02
           #No.FUN-560084  --end   
        END FOREACH
END FUNCTION

#MOD-B50091 add --start--
#系統參數設料件/供應商須存在
FUNCTION p480_pmh()  #供應廠商
   DEFINE l_pmhacti   LIKE pmh_file.pmhacti
   DEFINE l_pmh05     LIKE pmh_file.pmh05

   LET g_errno = " "

   SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05
     FROM pmh_file
    WHERE pmh01 = g_pml.pml04
      AND pmh02 = g_pmk09
      AND pmh13 = g_pmk22
      AND pmh22 = '1' AND pmh21 =' '
      AND pmh23 = ' '        
      AND pmhacti = 'Y' 

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg0031'
         LET l_pmhacti = NULL
      WHEN l_pmhacti = 'N'
         LET g_errno = '9028'
      WHEN l_pmh05 MATCHES '[12]'
         LET g_errno = 'mfg3043' 
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION
#MOD-B50091 add --end--
 
#-----------------------No.TQC-6B0124 add
#此FUNCTION主要目的是在換算計價數量
FUNCTION p480_set_pml87(p_pml04,p_pml07,p_pml86,p_pml20)
   DEFINE   l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE img_file.img21
   DEFINE   p_pml04  LIKE pml_file.pml04,
            p_pml07  LIKE pml_file.pml07,
            p_pml86  LIKE pml_file.pml86,
            p_pml20  LIKE pml_file.pml20 
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=p_pml04
    IF SQLCA.sqlcode =100 THEN
       IF p_pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac1=1
    LET l_qty1=p_pml20
    CALL s_umfchk(p_pml04,p_pml07,l_ima44)
          RETURNING g_cnt,l_fac1
    IF g_cnt = 1 THEN
       LET l_fac1 = 1
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
 
    LET l_tot=l_qty1*l_fac1
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
    LET l_factor = 1
    CALL s_umfchk(p_pml04,l_ima44,p_pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    RETURN l_tot
END FUNCTION
#-----------------------No.TQC-6B0124 end
#No.FUN-880072
