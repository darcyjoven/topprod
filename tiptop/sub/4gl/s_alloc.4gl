# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_alloc.4gl
# Descriptions...: 產生產品備料資料
# Date & Author..: 93/01/06 By David
# Usage..........: CALL s_alloc(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,
#                               p_mps,p_yld,p_lvl,p_minopseq) RETURNING l_cnt
# Input parameter: p_wo       工單編號
#                  p_wotype   工單型態
#                  p_part     料件編號
#                  p_btflg    是否展開下階(sma29)
#                  p_woq      工單數量
#                  p_date     有效日期
#                  p_mps      MPS料件是否展開
#                  p_yld      損耗率
#                  p_lvl      展開階數       
#                  p_minopseq 最小序號
# Return Code....: l_cnt      備料筆數
# Memo...........: This subrutine is copied from s_cralc for 
#                  subcontract work order
# 94/12/16 大地震:應發數量為BOM展出量,且不考慮庫存及取替代
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE NO INTEGER  應該轉為LIKE type_file.chr20  	#No.FUN-680147
# Modify.........: No.MOD-4A0041 在convert 作業中 才會做正確的轉換
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->LIKE pml_file.pml09 	#No.FUN-680147
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-920351 09/02/25 By claire INSERT INTO sfa_file個數與schema不符
# Modify.........: No.FUN-940008 09/05/18 By hongmei 欠料量修改
# Modify.........: No.CHI-950037 09/06/22 By jan 在工單開立，產生備料時，需排除bmb14='不發料'的資料
# Modify.........: No.FUN-950088 09/07/01 By hongmei 將bml04帶到sfa36廠牌中
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-980013 09/11/02 By jan 當bmb14='1'時,也要產生備料
# Modify.........: No:FUN-9C0040 10/01/28 By jan,當BOM單身性質為"回收料"時,產生備料時，"實際QPA"和"應發數量"為負值。
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A30093 10/04/15 By jan bmb14='3'時，產生工單備料時,sfa11為'C'
# Modify.........: No:FUN-A60027 10/06/12 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用 
# Modify.........: No:MOD-A10086 10/08/03 By Pengu 調整g_opseq變數的default值
# Modify.........: No.FUN-BB0085 11/12/05 By xianghui 增加數量欄位小數取位
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
         g_opseq      LIKE sfa_file.sfa08,      #operation sequence number
         g_offset     LIKE sfa_file.sfa09,      #offset
         g_ima86      LIKE ima_file.ima86,      #offset
         g_ima86_fac  LIKE ima_file.ima86_fac,  #offset
         g_btflg      LIKE type_file.chr1,      #blow through flag 	#No.FUN-680147 VARCHAR(1)
         g_wo         LIKE sfa_file.sfa01,      #work order number   --No.FUN-560002 	#No.FUN-680147 VARCHAR(16)
         g_wotype     LIKE type_file.num5,      #work order type 	#No.FUN-680147 SMALLINT
         g_level      LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
         level        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
         g_lvl        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
         g_ccc        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
         g_SOUCode    LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
         g_mps        LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
         g_yld        LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
         g_minopseq   LIKE ecb_file.ecb03,
         g_date       LIKE type_file.dat     	#No.FUN-680147 DATE
DEFINE   g_cnt        LIKE type_file.num10     	#No.FUN-680147 INTEGER
 
FUNCTION s_alloc(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
                 p_lvl,p_minopseq)
DEFINE
       p_wo         LIKE sfa_file.sfa01,   #work order number  --No.FUN-560002 	#No.FUN-680147 VARCHAR(16)
       p_wotype     LIKE type_file.num5,   #work order type 	#No.FUN-680147 SMALLINT
       p_part       LIKE ima_file.ima01,   #part number #No.MOD-490217
       p_btflg      LIKE type_file.chr1,   #blow through flag 	#No.FUN-680147 VARCHAR(1)
       p_woq        LIKE oeb_file.oeb12,   #work order quantity 	#No.FUN-680147 DECIMAL(11,3)
       p_date       LIKE type_file.dat,    #effective date 	#No.FUN-680147 DATE
       p_mps        LIKE type_file.chr1,   #if MPS phantom, blow through flag (Y/N) 	#No.FUN-680147 VARCHAR(1)
       p_yld        LIKE type_file.chr1,   #inflate yield factor (Y/N) 	#No.FUN-680147 VARCHAR(1)
       p_minopseq   LIKE ecb_file.ecb03,
       p_lvl        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
       l_ima562     LIKE ima_file.ima562
DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
 
    WHENEVER ERROR CALL cl_err_msg_log
    MESSAGE ' Allocating ' ATTRIBUTE(REVERSE)
    LET g_ccc=0
    LET g_date=p_date
    LET g_btflg=p_btflg
    LET g_wo=p_wo
    LET g_wotype=p_wotype
    LET g_opseq= ' '    #No:MOD-A10086 modify
    LET g_offset=''
    LET g_mps=p_mps
    #No.FUN-A70034  --Begin
    IF cl_null(p_lvl) THEN LET p_lvl = 0 END IF
    #No.FUN-A70034  --End  
    LET g_lvl=p_lvl+1
    LET g_yld=p_yld
    LET g_errno=' '
    LET level = 0 
    LET g_minopseq=p_minopseq
    SELECT ima562,ima86,ima86_fac INTO l_ima562,g_ima86,g_ima86_fac
        FROM ima_file
        WHERE ima01=p_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
    #檢查該料件是否有產品結構
    SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb01=p_part
    IF g_cnt IS NULL OR g_cnt=0 THEN
        LET g_errno='asf-015'        #無產品結構
    ELSE
        #FUN-550112
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part  
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        #--
        CALL alloc_bom(0,p_part,l_ima910,p_woq,1)  #FUN-550112
        IF g_ccc=0 THEN
            LET g_errno='asf-014'
        END IF    #有BOM但無有效者
    END IF
    
    MESSAGE ""
    RETURN g_ccc
END FUNCTION
 
FUNCTION alloc_bom(p_level,p_key,p_key2,p_total,p_QPA)  #FUN-550112
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
DEFINE
    p_level        LIKE type_file.num5,         #level code 	#No.FUN-680147 SMALLINT
    p_total        LIKE oeb_file.oeb13, 	#No.FUN-680147 DECIMAL(20,6)
    p_QPA          LIKE bmb_file.bmb06,         #No.FUN-560230
    l_QPA          LIKE bmb_file.bmb06,         #No.FUN-560230
    l_total        LIKE sfa_file.sfa04,         #原發數量 	#No.FUN-680147 DECIMAL(13,5)
    l_total2       LIKE sfa_file.sfa05,         #應發數量 	#No.FUN-680147 DECIMAL(13,5)
    p_key          LIKE bma_file.bma01,         #assembly part number
    p_key2         LIKE ima_file.ima910,        #FUN-550112
    l_ac,l_i,l_x   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    arrno          LIKE type_file.num5,         #BUFFER SIZE 	#No.FUN-680147 SMALLINT
    b_seq,l_double LIKE type_file.num10,        #restart sequence (line number) #MOD-4A0041 	#No.FUN-680147 INTEGER
    sr ARRAY[500] OF RECORD  #array for storage
        bmb02      LIKE bmb_file.bmb02, #SEQ
        bmb03      LIKE bmb_file.bmb03, #component part number
        bmb10      LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac  LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb10_fac2 LIKE bmb_file.bmb10_fac2,#Issuing UOM to cost transfer rate
        bmb15      LIKE bmb_file.bmb15, #consumable part flag
        bmb16      LIKE bmb_file.bmb16, #substitable flag
        bmb06      LIKE bmb_file.bmb06, #QPA
        bmb08      LIKE bmb_file.bmb08, #yield
        bmb09      LIKE bmb_file.bmb09, #operation sequence number
        bmb18      LIKE bmb_file.bmb18, #days offset
        bmb14      LIKE bmb_file.bmb14, #CHI-980013
        ima08      LIKE ima_file.ima08, #source code
        ima37      LIKE ima_file.ima37, #OPC
        ima25      LIKE ima_file.ima25, #UOM
        ima86      LIKE ima_file.ima86, #COST UNIT
        ima86_fac  LIKE ima_file.ima86_fac, #
        bma01      LIKE bma_file.bma01,  #No.MOD-490217
        level      LIKE type_file.num5,  	#No.FUN-680147 SMALLINT
        #No.FUN-A70034  --Begin
        bmb081     LIKE bmb_file.bmb081,
        bmb082     LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
                   END RECORD,
    g_sfa          RECORD LIKE sfa_file.*,    #備料檔
    l_ima08        LIKE ima_file.ima08, #source code
#    l_ima26        LIKE ima_file.ima26, #QOH #FUN-A20044
    l_avl_stk_mpsmrp       LIKE type_file.num15_3,  #FUN-A20044
    l_SafetyStock  LIKE ima_file.ima27,
    l_SSqty        LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37, #OPC
    l_ima64        LIKE ima_file.ima64,     #Issue Pansize
    l_ima641       LIKE ima_file.ima641,    #Minimum Issue QTY
#    l_ima262       LIKE ima_file.ima262,    #Minimum Issue QTY #FUN-A20044
    l_avl_stk,l_unavl_stk      LIKE type_file.num15_3,    #FUN-A20044
    l_uom          LIKE ima_file.ima25,     #Stock UOM
    l_chr          LIKE type_file.chr1,     #No.FUN-680147 VARCHAR(1)
    l_sfa07        LIKE sfa_file.sfa07,     #quantity owed
    l_sfa11        LIKE sfa_file.sfa11,     #consumable flag
#    l_qty          LIKE ima_file.ima26,     #issuing to stock qty#FUN-A20044
    l_qty          LIKE type_file.num15_3,  #FUN-A20044
#    l_bal          LIKE ima_file.ima26,     #balance (QOH-issue) #FUN-A20044
    l_bal          LIKE type_file.num15_3,  #FUN-A20044
    l_ActualQPA    LIKE bmb_file.bmb06,     #No.FUN-560230
    l_sfa12        LIKE sfa_file.sfa12,     #發料單位
    l_sfa13        LIKE sfa_file.sfa13,     #發料/庫存單位換算率
    l_unaloc,l_uuc LIKE sfa_file.sfa25,     #unallocated quantity
    l_cmd          LIKE type_file.chr1000   #No.FUN-680147 VARCHAR(1000)
DEFINE l_sfai      RECORD LIKE sfai_file.*  #No.FUN-7B0018
DEFINE b_sfai      RECORD LIKE sfai_file.*  #No.FUN-7B0018
DEFINE k_sfai      RECORD LIKE sfai_file.*  #No.FUN-7B0018
DEFINE l_flag      LIKE type_file.chr1      #No.FUN-7B0018
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
DEFINE l_bml04     LIKE bml_file.bml04      #FUN-950088 add
DEFINE l_sfa03     LIKE sfa_file.sfa03      #FUN-A20044

LET p_level = p_level + 1
LET level = level + 1
LET arrno = 500
LET l_cmd=
        "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
        "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb14,ima08,ima37,ima25, ", #CHI-980013 add bmb14
        " ima86,ima86_fac,bma01,0, ",
        " bmb081,bmb082 ",     #No.FUN-A70034
        " FROM bmb_file,OUTER ima_file,OUTER bma_file",
        " WHERE bmb01='", p_key,"' AND bmb02>?",
        "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            " AND bma_file.bma01 = bmb03  AND ima_file.ima01 = bmb03 ",
       #" AND bmb14 != '1'",  #CHI-950037  #CHI-980013
        " AND (bmb04 <='",g_date,
        "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
        "' OR bmb05 IS NULL)",
        " ORDER BY 1"
PREPARE alloc_ppp FROM l_cmd
IF SQLCA.sqlcode THEN
   CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
DECLARE alloc_cur CURSOR FOR alloc_ppp
 
#put BOM data into buffer
LET b_seq=0
WHILE TRUE
   LET l_ac = 1
   FOREACH alloc_cur USING b_seq INTO sr[l_ac].*
      MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
      #若換算率有問題, 則設為1
      IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
         LET sr[l_ac].bmb10_fac=1.0
      END IF
      IF sr[l_ac].ima08 = 'X' THEN
         LET sr[l_ac].level = level -1
      ELSE
         LET sr[l_ac].level = level
      END IF
      IF sr[l_ac].bmb16 IS NULL THEN    #若未定義, 則給予'正常'
         LET sr[l_ac].bmb16='0'
      END IF
      #FUN-8B0015--BEGIN--
      LET l_ima910[l_ac]=''
      SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
      IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
      #FUN-8B0015--END-- 
      LET l_ac = l_ac + 1    #check limitation
      IF l_ac > arrno THEN EXIT FOREACH END IF
   END FOREACH
   LET l_x=l_ac-1
   #insert into allocation file
   FOR l_i = 1 TO l_x
       #No.FUN-A70034  --Begin
       CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA)
            RETURNING l_total_1,l_QPA,l_ActualQPA
       LET l_QPA_1 = l_ActualQPA
       #No.FUN-A70034  --End  

       #operation sequence number
       IF sr[l_i].bmb09 IS NOT NULL AND g_opseq IS NULL THEN
          LET g_level=p_level
          LET g_opseq=sr[l_i].bmb09
          LET g_offset=sr[l_i].bmb18
       END IF
       #無製程序號
       IF g_opseq IS NULL THEN LET g_opseq=g_minopseq END IF
       IF g_offset IS NULL THEN LET g_offset=0 END IF
       LET g_SOUCode='0'
       IF sr[l_i].bmb16='2' THEN
          LET g_SOUCode=g_sma.sma67
       ELSE
          IF sr[l_i].bmb16='1' THEN        #UTE
             LET g_SOUCode=g_sma.sma66    #保留安全庫存, 以備不時之需
          END IF
       END IF
       #inflate yield
       IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
       #No.FUN-A70034  --Begin
       #Actual QPA
       #LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
       #LET l_QPA=sr[l_i].bmb06 * p_QPA     ##94/12/16 Add 該行 Jackson
       #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
       LET l_total= l_total_1
       LET l_total2=l_total
       #No.FUN-A70034  --End  
       LET l_sfa07=0
       LET l_sfa11='N'
       IF sr[l_i].ima08='R' THEN #routable part
          LET l_sfa07=l_total
          LET l_sfa11='R'
       ELSE
          IF sr[l_i].bmb15='Y' THEN #comsumable
             LET l_sfa11='E'
          ELSE 
             IF sr[l_i].ima08 MATCHES '[UV]' THEN
                LET l_sfa11=sr[l_i].ima08
             END IF
          END IF #consumable
       END IF
       IF sr[l_i].bmb14 = '1' THEN  #CHI-980013
          LET l_sfa11 = 'X'         #CHI-980013
       END IF                       #CHI-980013
       IF sr[l_i].bmb14 = '2' THEN  #FUN-9C0040
          LET l_sfa11 = 'S'         #FUN-9C0040
       END IF                       #FUN-9C0040
       IF sr[l_i].bmb14 = '3' THEN  #FUN-A30093 
          LET l_sfa11 = 'C'         #FUN-A30093
       END IF                       #FUN-A30093
       IF g_sma.sma78='1' THEN        #使用庫存單位
          LET sr[l_i].bmb10=sr[l_i].ima25
          LET l_total=l_total*sr[l_i].bmb10_fac    #原發
          LET l_total2=l_total2*sr[l_i].bmb10_fac    #應發
          LET sr[l_i].bmb10_fac=1.0
       END IF
       LET l_total =s_digqty(l_total,sr[l_i].bmb10)     #FUN-BB0085
       LET l_total2=s_digqty(l_total2,sr[l_i].bmb10)    #FUN-BB0085
 
       #FUN-950088---Begin                                                      
       LET l_bml04=NULL                                                         
                                                                                
       DECLARE bml_cur CURSOR FOR                                               
       SELECT bml04 FROM bml_file                                               
        WHERE bml01=sr[l_i].bmb03                                               
          AND (bml02=p_key OR bml02='ALL')                                      
        ORDER BY bml03   #CHI-980013 add

      #OPEN bml_cur       #CHI-980013
      #FETCH bml_cur INTO l_bml04         #CHI-980013
       FOREACH bml_cur INTO l_bml04       #CHI-980013  
         EXIT FOREACH                     #CHI-980013 
       END FOREACH                        #CHI-980013
       LET g_sfa.sfa36 =l_bml04                                                 
       #FUN-950088---End
 
       IF sr[l_i].ima08 != 'M' AND sr[l_i].ima08 != 'X'  THEN
                LET g_ccc=g_ccc+1
                LET l_uuc=0
          #MOD-920351-begin-add
          #INSERT INTO sfa_file
          IF l_sfa11 = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF   #CHI-980013
          INSERT INTO sfa_file(sfa01,sfa02,sfa03,sfa04,sfa05,sfa06,
                               sfa061,sfa062,sfa063,sfa064,sfa065,
                               sfa066,sfa07,sfa08,sfa09,sfa10,
                               sfa11,sfa12,sfa13,sfa14,sfa15,
                               sfa16,sfa161,sfa25,sfa26,sfa27,
                               sfa28,sfa29,sfa30,sfa31,sfa91,
                               sfa92,sfa93,sfa94,sfa95,sfa96,
                               sfa97,sfa98,sfa99,sfa100,sfaacti,sfa32,sfaplant,sfalegal,sfa012,sfa013)#FUN-A60027 addsfa012,sfa013 #FUN-980012 add sfaplant,sfalegal
          #MOD-920351-end-add
          #     1,       2,            3,      4,
          VALUES(g_wo,g_wotype,sr[l_i].bmb03,l_total,
          #      5, 6,                   7,    8,       9,
          l_total2, 0,0,0,0,0,0,0,0,g_opseq,g_offset,  #FUN-940008 l_sfa07-->0
          #10,     11,           12,               13,
           ' ', l_sfa11,sr[l_i].bmb10,sr[l_i].bmb10_fac,
          #14,                 15,           16,      
          sr[l_i].ima86, sr[l_i].bmb10_fac2,l_QPA,            
          #161        
          l_ActualQPA,
          #25,  26, 27           28 29 30  31
         #l_uuc,sr[l_i].bmb16,
          l_uuc,'0',sr[l_i].bmb03,1,' ',' ',' ',
           #91
             '','','','','','','','','',0,'Y','N',g_plant,g_legal,' ',0)  #MOD-920351 add 'N' #FUN-980012 add 'N',g_plant,g_legal #No.FUN-A70034
            IF SQLCA.SQLCODE THEN    #Duplicate
              #IF SQLCA.SQLCODE=-239 THEN                 #TQC-790089 mark
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #TQC-790089 mod
                  #因為相同的料件可能有不同的發料單位, 故宜換算之
                  SELECT sfa13 INTO l_sfa13
                  FROM sfa_file
			  WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
			      AND sfa08=g_opseq
			      AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                  AND sfa012='' AND sfa013=0  #FUN-A60027 add
                  
	          LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
	          LET l_total=l_total*l_sfa13
	          LET l_total2=l_total2*l_sfa13
                  LET l_total=s_digqty(l_total,sr[l_i].bmb10)    #FUN-BB0085
                  LET l_total2=s_digqty(l_total2,sr[l_i].bmb10)  #FUN-BB0085
	          UPDATE sfa_file SET sfa04=sfa04+l_total,
	        		      sfa05=sfa05+l_total2,
                                     #No.FUN-A70034  --Begin
	        		      #sfa16=sfa16+sr[l_i].bmb06,
	        		      sfa16=sfa16+l_QPA,
                                      #No.FUN-A70034  --End  
	        		      sfa161=sfa161+l_ActualQPA
	        		WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
	        		  AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
	                          AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                      AND sfa012='' AND sfa013=0  #FUN-A60027 add
	       ELSE
	          ERROR 'ALC2: Insert Failed because of ', SQLCA.SQLCODE
	       END IF
            #NO.FUN-7B0018 08/02/25 add --begin
            ELSE
               IF NOT s_industry('std') THEN
                  INITIALIZE l_sfai.* TO NULL
                  LET l_sfai.sfai01 = g_wo
                  LET l_sfai.sfai03 = sr[l_i].bmb03
                  LET l_sfai.sfai08 = g_opseq
                  LET l_sfai.sfai12 = sr[l_i].bmb10
                  LET l_sfai.sfai012 = ''    #FUN-A60027 add
                  LET l_sfai.sfai013 = 0     #FUN-A60027 add
                  LET l_flag = s_ins_sfai(l_sfai.*,'')
               END IF
            #NO.FUN-7B0018 08/02/25 add --end
	    END IF
         END IF
         IF sr[l_i].ima08 = 'M' AND  sr[l_i].level = g_lvl  THEN
            LET g_ccc=g_ccc+1
	    LET l_uuc=0	
          IF l_sfa11 = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF   #CHI-980013
	  # INSERT INTO sfa_file  #FUN-980012 mark
          INSERT INTO sfa_file(sfa01,sfa02,sfa03,sfa04,sfa05,sfa06,
                               sfa061,sfa062,sfa063,sfa064,sfa065,
                               sfa066,sfa07,sfa08,sfa09,sfa10,
                               sfa11,sfa12,sfa13,sfa14,sfa15,
                               sfa16,sfa161,sfa25,sfa26,sfa27,
                               sfa28,sfa29,sfa30,sfa31,sfa91,
                               sfa92,sfa93,sfa94,sfa95,sfa96,
                               sfa97,sfa98,sfa99,sfa100,sfaacti,sfa32,sfaplant,sfalegal,sfa012,sfa013)#FUN-A60027 addsfa012,sfa013 #FUN-980012 add sfaplant,sfalegal
	  #      1,       2,            3,      4,
          VALUES(g_wo,g_wotype,sr[l_i].bmb03,l_total,
          #      5, 6,                   7,    8,       9,
          l_total2, 0,0,0,0,0,0,0,0,g_opseq,g_offset,  #FUN-940008 l_sfa07-->0
          #10,     11,           12,               13,
           ' ', l_sfa11,sr[l_i].bmb10,sr[l_i].bmb10_fac,
          #14,                 15,           16,      
          sr[l_i].ima86, sr[l_i].bmb10_fac2,l_QPA,            
          #161        
          l_ActualQPA,
          #25,  26, 27           28 29 30  31
         #l_uuc,sr[l_i].bmb16,
          l_uuc,'0',sr[l_i].bmb03,1,' ',' ',' ',
           #91
             #'','','','','','','','','',0,'Y') #FUN-980012 mark
             '','','','','','','','','',0,'Y','N',g_plant,g_legal,' ',0)  #FUN-980012 add 'N',g_plant,g_legal #No.FUN-A70034
          IF SQLCA.SQLCODE THEN    #Duplicate
            #IF SQLCA.SQLCODE=-239 THEN                 #TQC-790089 mark
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #TQC-790089 mod
                #因為相同的料件可能有不同的發料單位, 故宜換算之
                SELECT sfa13 INTO l_sfa13
                             FROM sfa_file
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                              AND sfa08=g_opseq
                              AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                              AND sfa012='' AND sfa013=0  #FUN-A60027 add
                LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                LET l_total=l_total*l_sfa13
                LET l_total2=l_total2*l_sfa13
                LET l_total=s_digqty(l_total,sr[l_i].bmb10)    #FUN-BB0085
                LET l_total2=s_digqty(l_total2,sr[l_i].bmb10)  #FUN-BB0085
                UPDATE sfa_file SET sfa04=sfa04+l_total,
                                    sfa05=sfa05+l_total2,
                                    #No.FUN-A70034  --Begin
                                    #sfa16=sfa16+sr[l_i].bmb06,
                                    sfa16=sfa16+l_QPA,
                                    #No.FUN-A70034  --End  
                                    sfa161=sfa161+l_ActualQPA
                              WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                                AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                                AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                                AND sfa012='' AND sfa013=0  #FUN-A60027 add
            ELSE
                ERROR 'ALC2: Insert Failed because of ', SQLCA.SQLCODE
            END IF
          #NO.FUN-7B0018 08/02/25 add --begin
          ELSE
             IF NOT s_industry('std') THEN
                INITIALIZE b_sfai.* TO NULL
                LET b_sfai.sfai01 = g_wo
                LET b_sfai.sfai03 = sr[l_i].bmb03
                LET b_sfai.sfai08 = g_opseq
                LET b_sfai.sfai12 = sr[l_i].bmb10
                LET b_sfai.sfai27 = sr[l_i].bmb03 #CHI-7B0034
                LET b_sfai.sfai012 = ''    #FUN-A60027 add
                LET b_sfai.sfai013 = 0     #FUN-A60027 add
                LET l_flag = s_ins_sfai(b_sfai.*,'')
             END IF
          #NO.FUN-7B0018 08/02/25 add --end
          END IF
       END IF
       IF sr[l_i].ima08 ='M' AND  sr[l_i].level < g_lvl  THEN
          IF sr[l_i].bma01 IS NOT NULL THEN 
            #CALL alloc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #FUN-8B0015
            #       p_total*sr[l_i].bmb06,l_ActualQPA)
             #No.FUN-A70034  --Begin
             #CALL alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
             #       p_total*sr[l_i].bmb06,l_ActualQPA)
             CALL alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                    l_total_1,l_QPA_1)
             #No.FUN-A70034  --End  
            ELSE
                LET g_ccc=g_ccc+1
                LET l_uuc=0
                IF l_sfa11 = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF   #CHI-980013
             #INSERT INTO sfa_file  #FUN-980012 mark
          INSERT INTO sfa_file(sfa01,sfa02,sfa03,sfa04,sfa05,sfa06,
                               sfa061,sfa062,sfa063,sfa064,sfa065,
                               sfa066,sfa07,sfa08,sfa09,sfa10,
                               sfa11,sfa12,sfa13,sfa14,sfa15,
                               sfa16,sfa161,sfa25,sfa26,sfa27,
                               sfa28,sfa29,sfa30,sfa31,sfa91,
                               sfa92,sfa93,sfa94,sfa95,sfa96,
                               sfa97,sfa98,sfa99,sfa100,sfaacti,sfa32,sfaplant,sfalegal,sfa012,sfa013)#FUN-A60027 addsfa012,sfa013 #FUN-980012 add sfaplant,sfalegal 
             #       1,       2,            3,      4,
             VALUES(g_wo,g_wotype,sr[l_i].bmb03,l_total,
             #      5, 6,                   7,    8,       9,
             l_total2, 0,0,0,0,0,0,0,0,g_opseq,g_offset,   #FUN-940008 l_sfa07-->0
             #10,     11,           12,               13,
              ' ', l_sfa11,sr[l_i].bmb10,sr[l_i].bmb10_fac,
             #14,                 15,           16,      
             #No.FUN-A70034  --Begin
             #sr[l_i].ima86, sr[l_i].bmb10_fac2,sr[l_i].bmb06,
             sr[l_i].ima86, sr[l_i].bmb10_fac2,l_QPA,
             #No.FUN-A70034  --End  
             #161        
             l_ActualQPA,
            #25,  26, 27           28 29 30  31
           #l_uuc,sr[l_i].bmb16,
            l_uuc,'0',sr[l_i].bmb03,1,' ',' ',' ',
              #91
                #'','','','','','','','','',0,'Y')  #FUN-980012 mark
                '','','','','','','','','',0,'Y','N',g_plant,g_legal,' ',0)  #FUN-980012 add g_plant,g_legal  #No.FUN-A70034
 
             IF SQLCA.SQLCODE THEN    #Duplicate
               #IF SQLCA.SQLCODE=-239 THEN                #TQC-790089 mark
                IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790089 mod
                  #因為相同的料件可能有不同的發料單位, 故宜換算之
                   SELECT sfa13 INTO l_sfa13
                   FROM sfa_file
                   WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                        AND sfa08=g_opseq
                        AND sfa012='' AND sfa013=0  #FUN-A60027 add
                   LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                   LET l_total=l_total*l_sfa13
                   LET l_total2=l_total2*l_sfa13
                   LET l_total=s_digqty(l_total,sr[l_i].bmb10)    #FUN-BB0085
                   LET l_total2=s_digqty(l_total2,sr[l_i].bmb10)  #FUN-BB0085
                   UPDATE sfa_file
                   SET sfa04=sfa04+l_total,
                       sfa05=sfa05+l_total2,
                       #No.FUN-A70034  --Begin
                       #sfa16=sfa16+sr[l_i].bmb06,
                       sfa16=sfa16+l_QPA,
                       #No.FUN-A70034  --End  
                       sfa161=sfa161+l_ActualQPA
                   WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                   AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                   AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                   AND sfa012='' AND sfa013=0  #FUN-A60027 add
                ELSE
                   ERROR 'ALC2: Insert Failed because of ', SQLCA.SQLCODE
                END IF
             #NO.FUN-7B0018 08/02/25 add --begin
             ELSE
                IF NOT s_industry('std') THEN
                   INITIALIZE k_sfai.* TO NULL
                   LET k_sfai.sfai01 = g_wo
                   LET k_sfai.sfai03 = sr[l_i].bmb03
                   LET k_sfai.sfai08 = g_opseq
                   LET k_sfai.sfai12 = sr[l_i].bmb10
                   LET k_sfai.sfai27 = sr[l_i].bmb03 #CHI-7B0034
                   LET k_sfai.sfai012 = ''    #FUN-A60027 add
                   LET k_sfai.sfai013 = 0     #FUN-A60027 add
                   LET l_flag = s_ins_sfai(k_sfai.*,'')
                END IF
             #NO.FUN-7B0018 08/02/25 add --end
             END IF
          END IF
       END IF
       IF sr[l_i].ima08='X' THEN
          IF g_btflg='N' THEN #phantom
             CONTINUE FOR #do'nt blow through
          ELSE
             IF sr[l_i].ima37='1' AND g_mps='N' THEN 
                CONTINUE FOR #do'nt blow through
                ELSE
                 IF sr[l_i].bma01 IS NOT NULL THEN 
                      LET level = level -1 
                    #CALL alloc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #FUN-8B0015
                     #No.FUN-A70034  --Begin
                     #CALL alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                     #p_total*sr[l_i].bmb06,l_ActualQPA)
                     CALL alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                     l_total_1,l_QPA_1)
                     #No.FUN-A70034  --End  
                 END IF
             END IF
          END IF
       END IF
       IF g_level=p_level THEN
          LET g_opseq=''
          LET g_offset=''
       END IF
    END FOR
    IF l_x < arrno OR l_ac=1 THEN #nothing left
       EXIT WHILE
    ELSE
       LET b_seq = sr[l_x].bmb02
    END IF
END WHILE
 
    IF p_level >1 THEN RETURN END IF
    #重新把資料拿出來處理
    DECLARE cr_cr2 CURSOR FOR
        SELECT sfa_file.*,
#            ima08,ima262,ima37,ima64,ima641,ima25 #FUN-A20044
            ima08,0,ima37,ima64,ima641,ima25 #FUN-A20044
        FROM sfa_file,OUTER ima_file
        WHERE sfa01=g_wo AND ima_file.ima01=sfa03
 
    FOREACH cr_cr2 INTO g_sfa.*,
#        l_ima08,l_ima262,l_ima37,l_ima64,l_ima641,l_uom #FUN-A20044
        l_ima08,l_avl_stk,l_ima37,l_ima64,l_ima641,l_uom #FUN-A20044
         SELECT sfa03 INTO l_sfa03 FROM sfa_file WHERE sfa01=g_wo  #FUN-A20044
        CALL s_getstock(l_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
        MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
 
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
        IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
           LET g_sfa.sfa05=l_ima641
        END IF
        IF l_ima64!=0 THEN
           LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999999
           LET g_sfa.sfa05=l_double*l_ima64
        END IF
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
#        IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A20044
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A20044
#        LET l_ima26=l_ima262 #FUN-A20044
        LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A20044
        LET l_qty=g_sfa.sfa05
        LET l_total2=l_qty
#        LET l_bal=l_ima26-l_qty #FUN-A20044
        LET l_bal=l_avl_stk_mpsmrp-l_qty #FUN-A20044
#        IF l_qty > l_ima262 THEN #FUN-A20044
        IF l_qty > l_avl_stk THEN #FUN-A20044
           LET l_unaloc=0
        ELSE
#           LET l_unaloc=l_qty-l_ima262 #FUN-A20044
           LET l_unaloc=l_qty-l_avl_stk #FUN-A20044
        END IF
        CASE WHEN g_sfa.sfa26 = '0' LET g_sfa.sfa26 = '0' 
             WHEN g_sfa.sfa26 = '1' LET g_sfa.sfa26 = '1' 
             WHEN g_sfa.sfa26 = '2' LET g_sfa.sfa26 = '1' 
             WHEN g_sfa.sfa26 = '5' LET g_sfa.sfa26 = '1'  #bugno:7111 add
             WHEN g_sfa.sfa26 = '7' LET g_sfa.sfa26 = '1'  #FUN-A20037
        END CASE
        IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 END IF  #CHI-980013
        LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)      #FUN-BB0085
        LET l_unaloc =s_digqty(l_unaloc,g_sfa.sfa12)             #FUN-BB0085
        UPDATE sfa_file
            SET sfa05=g_sfa.sfa05,
                sfa25=l_unaloc,
                sfa26=g_sfa.sfa26
            WHERE sfa01=g_sfa.sfa01 AND sfa03=g_sfa.sfa03 AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
            AND sfa012='' AND sfa013=0  #FUN-A60027 add
        
    END FOREACH
END FUNCTION
