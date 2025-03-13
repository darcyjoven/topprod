# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
##□ s_cralc for ammt100
##SYNTAX	CALL s_mm_cralc(p_wo,p_wo1,p_part,p_btflg,
##			p_woq,p_date,p_mps,p_yld,p_lvl,p_cnt,p_kind)
##			RETURNING l_cnt
##DESCRIPTION	產生產品備料資料
##PARAMETER	p_wo		開發執行單編號
##              p_wo1           執行工單編號
##		p_part		料件編號
##		p_btflg		是否展開下階(sma29)
##		p_woq		工單數量
##		p_date		有效日期
##		p_mps		MPS料件是否展開
##		p_yld		損耗率
##		p_lvl		展開階數       
##              p_cnt           已產生的項次
##		p_kind          型態(A:新增 B:追加)
##RETURNING	_cnt		備料筆數
##SYSTEM	MFG/ASF
# Date & Author..: 00/12/26 By Chien
 # Modify.........: #NO.MOD-490217 04/09/10 by yiting 料號欄位放大
 # Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE ROWID_NO INTEGER  應該轉為char(18)
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550054 05/05/28 By wujie 單據編號加大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0068 07/10/19 By rainy CHI-740001 bma_file判斷有效碼沒做 OUTER 轉換
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A50004 10/05/04 By liingyu call cralc_bom()增加一個參數
# Modify.........: No.FUN-A60079 10/06/25 By jan 還原TQC-A50004的處理
# Modify.........: No:FUN-A70034 10/07/20 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:FUN-BB0086 12/01/12 By tanxc 增加數量欄位小數取位 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_mmh         RECORD LIKE mmh_file.*,
    g_mmg         RECORD LIKE mmg_file.*,
    g_opseq       LIKE mmh_file.mmh08, #operation sequence number
    g_offset      LIKE mmh_file.mmh09, #offset
    g_ima55       LIKE ima_file.ima55,
    g_ima55_fac   LIKE ima_file.ima55_fac,
    g_ima86       LIKE ima_file.ima86,
    g_ima86_fac   LIKE ima_file.ima86_fac,
    g_btflg       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#blow through flag
#No.FUN-550054--begin
    g_wo          LIKE mmh_file.mmh01,          #No.FUN-680100 VARCHAR(16)#work order number
    g_wo1         LIKE mmh_file.mmh011,         #No.FUN-680100 VARCHAR(16)#work order number
#No.FUN-550054--end   
    g_level       LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_ccc         LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_ccc1        LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_SOUCode     LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_mps         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_yld         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_factor      LIKE pml_file.pml09,          #No.FUN-680100 DEC(16,8)#   top40
    g_date        LIKE type_file.dat,           #No.FUN-680100 DATE
    g_kind        LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_status        LIKE type_file.num5          #No.FUN-680100 SMALLINT
FUNCTION s_mm_cralc(p_wo,p_wo1,p_part,p_btflg,p_woq,p_date,p_mps,
                    p_yld,p_cnt,p_kind)
DEFINE
#No.FUN-55054--begin
    p_wo         LIKE type_file.chr20,           #No.FUN-680100 VARCHAR(19)#work order number
    p_wo1        LIKE type_file.chr20,           #No.FUN-680100 VARCHAR(19)#work order number
#No.FUN-55054--end   
    p_part       LIKE ima_file.ima01, #part number NO.MOD-490217
    p_btflg      LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#blow through flag
#    p_woq        LIKE ima_file.ima26,          #No.FUN-680100 DECIMAL(11,3)#work order quantity #FUN-A20044 
    p_woq        LIKE type_file.num15_3, #FUN-A20044 
    p_date       LIKE type_file.dat,           #No.FUN-680100 DATE#effective date
    p_mps        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#if MPS phantom, blow through flag (Y/N)
    p_yld        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#inflate yield factor (Y/N)
    p_cnt        LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    p_kind       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)                    
    l_ima562     LIKE ima_file.ima562
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
 
    WHENEVER ERROR CONTINUE
    MESSAGE ' Allocating ' 
    LET g_ccc    = 0
    LET g_date   = p_date
    LET g_btflg  = p_btflg
    LET g_wo     = p_wo
    LET g_wo1    = p_wo1
    LET g_opseq  = ' '
    LET g_offset = 0
    LET g_mps    = p_mps
    LET g_yld    = p_yld
    LET g_kind   = p_kind
    LET g_errno  = ' '
    LET g_ccc1   = p_cnt
    SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = p_wo AND mmg02 = p_wo1
    IF STATUS THEN 
#    CALL cl_err('sel mmg:',STATUS,1) #No.FUN-660094
     CALL cl_err3("sel","mmg_file",p_wo,p_wo1,STATUS,"","sel mmg:",1)        #NO.FUN-660094
    RETURN 0 END IF
    SELECT ima562,ima55,ima55_fac,ima86,ima86_fac INTO 
      l_ima562,g_ima55,g_ima55_fac,g_ima86,g_ima86_fac
        FROM ima_file
        WHERE ima01=p_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
    #FUN-550112
    LET l_ima910=''
    SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
    #--
    CALL cralc_mm_bom(0,p_part,l_ima910,p_woq,1)  #FUN-550112#由BOM產生備料檔
    IF g_ccc=0 THEN 
       LET g_errno='asf-014' 			#有BOM但無有效者 
    END IF
    
    MESSAGE ""
    RETURN g_ccc
END FUNCTION
 
FUNCTION cralc_mm_bom(p_level,p_key,p_key2,p_total,p_QPA)  #FUN-550112
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
DEFINE
    p_level    LIKE type_file.num5,          #No.FUN-680100 SMALLINT#level code
#    p_total    LIKE ima_file.ima26,         #No.FUN-680100 DECIMAL(13,5) #FUN-A20044  
    p_total    LIKE type_file.num15_3,        #FUN-A20044  
    p_QPA      LIKE bmb_file.bmb06,          #FUN-560230
    l_QPA      LIKE bmb_file.bmb06,          #FUN-560230
#    l_total    LIKE ima_file.ima26,         #No.FUN-680100 DECIMAL(13,5)#原發數量 #FUN-A20044
    l_total    LIKE type_file.num15_3,          #FUN-A20044
#    l_total2   LIKE ima_file.ima26,         #No.FUN-680100 DECIMAL(13,5)#應發數量 #FUN-A20044
    l_total2   LIKE type_file.num15_3,         #No.FUN-680100 DECIMAL(13,5)#應發數量 #FUN-A20044
    p_key      LIKE bma_file.bma01,          #assembly part number
    p_key2     LIKE ima_file.ima910,         #FUN-550112
    l_ac,l_i,l_x,l_s        LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    arrno                   LIKE type_file.num5,          #No.FUN-680100 SMALLINT#BUFFER SIZE
    #b_seq,l_double  INTEGER, #restart sequence (line number) #MOD-4A0041
     b_seq,l_double          LIKE type_file.num10,  #No.FUN-680100 INTEGER #restart sequence (line number)         #MOD-4A0041
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #SEQ
        bmb03 LIKE bmb_file.bmb03, #component part number
        bmb10 LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb10_fac2 LIKE bmb_file.bmb10_fac2,#Issuing UOM to cost transfer rate
        bmb15 LIKE bmb_file.bmb15, #consumable part flag
        bmb16 LIKE bmb_file.bmb16, #substitable flag
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #yield
        bmb09 LIKE bmb_file.bmb09, #operation sequence number
        bmb18 LIKE bmb_file.bmb18, #days offset
        bmb19 LIKE bmb_file.bmb19, #1.不展開 2.不展開但自動開立工單 3.展開:top40
        ima08 LIKE ima_file.ima08, #source code
        ima37 LIKE ima_file.ima37, #OPC
        ima25 LIKE ima_file.ima25, #UOM
        ima55 LIKE ima_file.ima55, #生產單位
        ima86 LIKE ima_file.ima86, #COST UNIT
        ima86_fac LIKE ima_file.ima86_fac, #
         bma01 LIKE bma_file.bma01, #NO.MOD-490217 
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
    END RECORD,
    g_mmh RECORD  LIKE mmh_file.*,    #備料檔
    l_ima08 LIKE  ima_file.ima08, #source code
#    l_ima26 LIKE  ima_file.ima26, #QOH #FUN-A20044 
    l_avl_stk_mpsmrp LIKE  type_file.num15_3, #FUN-A20044
    l_unavl_stk  LIKE type_file.num15_3, #FUN-A20044 
#    l_ima262 LIKE ima_file.ima262, #QOH  #FUN-A20044
    l_avl_stk LIKE type_file.num15_3,  #FUN-A20044
    l_SafetyStock LIKE ima_file.ima27,
    l_SSqty LIKE  ima_file.ima27,
    l_ima37 LIKE  ima_file.ima37, #OPC
    l_ima108 LIKE  ima_file.ima108,
    l_ima64 LIKE  ima_file.ima64,     #Issue Pansize
    l_ima641 LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom LIKE ima_file.ima25,        #Stock UOM
    l_chr LIKE type_file.chr1,        #No.FUN-680100 VARCHAR(1)
    l_mmh07 LIKE mmh_file.mmh07, #quantity owed
    l_mmh03 LIKE mmh_file.mmh03, #part No
    l_mmh11 LIKE mmh_file.mmh11, #consumable flag
#    l_qty LIKE ima_file.ima26, #issuing to stock qty #FUN-A20044
    l_qty LIKE type_file.num15_3, #FUN-A20044
    l_mmhqty  LIKE mmh_file.mmh05,
    l_gfe03   LIKE gfe_file.gfe03, 
#    l_bal LIKE ima_file.ima26, #balance (QOH-issue) #FUN-A20044
    l_bal LIKE type_file.num15_3, #FUN-A20044
    l_ActualQPA LIKE bmb_file.bmb06,  #FUN-560230
    l_mmh12 LIKE mmh_file.mmh12,    #發料單位
    l_mmh13 LIKE mmh_file.mmh13,    #發料/庫存單位換算率
    l_bml04 LIKE bml_file.bml04,    #指定廠商
    fs_insert  LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_sw       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    l_unaloc,l_uuc LIKE mmh_file.mmh25,      #unallocated quantity
    l_cnt,l_c  LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    l_cmd LIKE type_file.chr1000             #No.FUN-680100 VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            #No.FUN-A70034  --Begin
            #"SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
            #"bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,",   #top40
            #"ima08,ima37,ima25,ima55,",                           #top40
            #" ima86,ima86_fac,bma01 ",
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
            "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,",   #top40
            "ima08,ima37,ima25,ima55,",                           #top40
            " ima86,ima86_fac,bma01,bmb081,bmb082 ",
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima_file.ima01 LEFT OUTER JOIN bma_file ON bmb01 = bma_file.bma01",
            #No.FUN-A70034  --End
            " WHERE bmb01='", p_key,"' AND bmb02>?",
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            " AND bma_file.bmaacti = 'Y'",  #CHI-740001   #TQC-7A0068
            " AND (bmb04 <='",g_date,
            "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
            "' OR bmb05 IS NULL)",
            " ORDER BY 1"
        PREPARE cralc_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur USING b_seq INTO sr[l_ac].*
            IF g_kind = 'B' THEN
               SELECT COUNT(*) INTO g_cnt FROM mmh_file
                WHERE mmh01  = g_wo
                  AND mmh011 = g_wo1
                  AND mmh03  = sr[l_ac].bmb03
                  AND mmh08 = g_opseq
                  AND mmh12 = sr[l_ac].bmb10
               IF g_cnt > 0 THEN
                  CONTINUE FOREACH
               END IF
            END IF
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
          #----97/08/20 modify 來源碼為'D'不應出來
            IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
          #------------------------------
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
                LET sr[l_ac].bmb10_fac=1
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
            #operation sequence number
            IF sr[l_i].bmb09 IS NOT NULL THEN
                #AND g_opseq IS NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].bmb09
                LET g_offset=sr[l_i].bmb18
            END IF
            #-->無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF


            #No.FUN-A70034  --Begin
            ##-->inflate yield
            #IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
            #-->Actual QPA
##------99/07/16 modify 應發數量算法
            #LET l_ActualQPA=(sr[l_i].bmb06*(1+sr[l_i].bmb08/100))*p_QPA
            #LET l_QPA=sr[l_i].bmb06 * p_QPA     ##94/12/06 Add 該行 Jackson
            #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100

            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA)
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_QPA_1 = l_ActualQPA
            LET l_total=l_total_1
            #No.FUN-A70034  --End  
##-----------------------------
            LET l_total2=l_total
 
            LET l_mmh07=0
            LET l_mmh11='N'
            IF sr[l_i].ima08='R' THEN #routable part
                LET l_mmh07=l_total
                LET l_mmh11='R'
            ELSE
                IF sr[l_i].bmb15='Y' THEN #comsumable
                    LET l_mmh11='E'
                ELSE 
                    IF sr[l_i].ima08 MATCHES '[UV]' THEN
                        LET l_mmh11=sr[l_i].ima08
                    END IF
                END IF #consumable
            END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
                LET sr[l_i].bmb10=sr[l_i].ima25
                LET l_total=l_total*sr[l_i].bmb10_fac    #原發
                LET l_total2=l_total2*sr[l_i].bmb10_fac    #應發
                LET sr[l_i].bmb10_fac=1
            END IF
 
            LET l_bml04=NULL
            SELECT bml04 INTO l_bml04 FROM bml_file
             WHERE bml01=sr[l_i].bmb03 AND bml02=p_key AND bml03=1
 
            IF sr[l_i].ima08!='X' OR g_btflg='N' OR
               (sr[l_i].ima08='X' AND g_btflg='Y' AND sr[l_i].bma01 IS NULL) OR
                (sr[l_i].ima37='1' AND g_mps='N') THEN #MPS part
 
                LET fs_insert = 'Y'
                IF sr[l_i].ima08 = 'M' OR sr[l_i].ima08='X' THEN
## add for top40:(bmb19):'1.不展開 2.不展開但自動開立工單 3.展開'
                   CASE
                      WHEN sr[l_i].bmb19='1'     #不展開
                           LET fs_insert = 'Y'
                      WHEN sr[l_i].bmb19='2'     #不展開但自動開立工單
                           LET fs_insert = 'Y'
                      WHEN sr[l_i].bmb19='3'     #展開
                           #發料單位 -> 生產單位 factor  for top40
                           CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                                sr[l_i].ima55) RETURNING g_status,g_factor  
                           #No.FUN-A70034  --Begin
                           #LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor
                           #LET l_ActualQPA=
                           #           (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
                           #CALL cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                           #p_total*sr[l_i].bmb06,l_ActualQPA)                        #TQC-A50004 #FUN-A60079
                           #CALL cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                           #p_total*sr[l_i].bmb06,l_QPA_1,g_date)

                           LET l_total = l_total * g_factor
                           CALL cralc_mm_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total,l_QPA_1)
                           #No.FUN-A70034  --End  
                           LET fs_insert = 'N'
                      OTHERWISE
                           LET fs_insert = 'Y'
                   END CASE
                END IF
                IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
                LET l_uuc=0
                IF fs_insert = 'Y' THEN
                INITIALIZE g_mmh.* TO NULL
                LET g_mmh.mmh01  = g_wo
                LET g_mmh.mmh011 = g_wo1
                LET g_mmh.mmh02  = (g_ccc + g_ccc1) + 1 
                LET g_mmh.mmh03  = sr[l_i].bmb03
                LET g_mmh.mmh04  = l_total
                LET g_mmh.mmh05  = l_total2
                LET g_mmh.mmh06  = 0
                LET g_mmh.mmh061 = 0
                LET g_mmh.mmh062 = 0
                LET g_mmh.mmh063 = 0
                LET g_mmh.mmh064 = 0
                LET g_mmh.mmh065 = 0
                LET g_mmh.mmh066 = 0
                LET g_mmh.mmh07  = 0
                LET g_mmh.mmh08 = g_opseq
                IF cl_null(g_mmh.mmh08) THEN LET g_mmh.mmh08=' ' END IF
                LET g_mmh.mmh09 = g_offset
                LET g_mmh.mmh11 = l_mmh11
                LET g_mmh.mmh12 = sr[l_i].bmb10
                #No.FUN-BB0086--add--begin--
                LET g_mmh.mmh04 = s_digqty(g_mmh.mmh04,g_mmh.mmh12)
                LET g_mmh.mmh05 = s_digqty(g_mmh.mmh05,g_mmh.mmh12)
                #No.FUN-BB0086--add--end--
                LET g_mmh.mmh13 = sr[l_i].bmb10_fac
                LET g_mmh.mmh14 = sr[l_i].ima86
                LET g_mmh.mmh15 = sr[l_i].bmb10_fac2
                LET g_mmh.mmh16 = l_QPA
                LET g_mmh.mmh161= l_ActualQPA
                LET g_mmh.mmh25 = l_uuc
                LET g_mmh.mmh25 = s_digqty(g_mmh.mmh25,g_mmh.mmh12)   #No.FUN-BB0086
                LET g_mmh.mmh26 = 0
                LET g_mmh.mmh27 = sr[l_i].bmb03
                LET g_mmh.mmh28 = 1
                LET g_mmh.mmh29 = p_key
             #  LET g_mmh.mmh30 = g_mmd.mmd16
             #  LET g_mmh.mmh31 = ' '
                SELECT ima35,ima36 INTO g_mmh.mmh30,g_mmh.mmh31 FROM ima_file
                 WHERE ima01 = g_mmh.mmh03
             #  LET g_mmh.mmh30 = g_mmg.mmg15
             #  LET g_mmh.mmh31 = g_mmg.mmg16
                LET g_mmh.mmhacti ='Y'
                LET g_mmh.mmhplant = g_plant #FUN-980004 add
                LET g_mmh.mmhlegal = g_legal #FUN-980004 add
                INSERT INTO mmh_file VALUES(g_mmh.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                   #IF SQLCA.SQLCODE=-239 THEN               #TQC-790091 mark
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT mmh13 INTO l_mmh13
                            FROM mmh_file
                            WHERE mmh01=g_wo AND mmh03=sr[l_i].bmb03
                                AND mmh08=g_opseq
                        LET l_mmh13=sr[l_i].bmb10_fac/l_mmh13
                        LET l_total=l_total*l_mmh13
                        LET l_total2=l_total2*l_mmh13
                        #No.FUN-BB0086--add--begin--
                        LET l_total = s_digqty(l_total,g_mmh.mmh12)
                        LET l_total2 = s_digqty(l_total2,g_mmh.mmh12)
                        #No.FUN-BB0086--add--end--
                        UPDATE mmh_file
                            SET mmh04=mmh04+l_total,
                                mmh05=mmh05+l_total2,
                               #mmh16=mmh16+sr[l_i].bmb06,  ##94/12/06 Jackson
                                mmh16=mmh16+l_QPA,         
                                mmh161=mmh161+l_ActualQPA
                            WHERE mmh01=g_wo AND mmh03=sr[l_i].bmb03
                                AND mmh08=g_opseq AND mmh12=sr[l_i].bmb10
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                           ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                           CONTINUE FOR
                        END IF
                    END IF
                END IF
              END IF
              LET g_ccc = g_ccc + 1
            END IF
 
            IF sr[l_i].ima08='X' THEN
                IF g_btflg='N' THEN #phantom
                    CONTINUE FOR #do'nt blow through
                ELSE
                    IF sr[l_i].ima37='1' AND g_mps='N' THEN #MPS part
                        CONTINUE FOR #do'nt blow through
                    END IF
                END IF
                IF sr[l_i].bma01 IS NOT NULL THEN 
                   #CALL cralc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #FUN-8B0015
                   #No.FUN-A70034  --Begin
                   #CALL cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                   #    p_total*sr[l_i].bmb06,l_ActualQPA)                        #TQC-A50004 #FUN-A60079
                   #   #p_total*sr[l_i].bmb06,l_ActualQPA,p_total*sr[l_i].bmb06)  #TQC-A50004 #FUN-A60079
                   #CALL cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],
                   #    p_total*sr[l_i].bmb06,l_QPA_1,g_date)
                   CALL cralc_mm_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total,l_QPA_1)
                   #No.FUN-A70034  --End  
                END IF
            END IF
            IF g_level=p_level THEN
                LET g_opseq=' '
                LET g_offset=''
            END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    #-->避免 'X' PART 重複計算
    IF p_level >1 THEN RETURN END IF
 
    #-->重新把資料拿出來處理
    DECLARE cr_cr2 CURSOR FOR
        SELECT mmh_file.*,
#            ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
            ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
        FROM mmh_file LEFT OUTER JOIN ima_file ON ima_file.ima01=mmh03
        WHERE mmh01=g_wo  AND mmh02 = g_wo1 
 
#    FOREACH cr_cr2 INTO g_mmh.*,l_ima08,l_ima262, #FUN-A20044
    FOREACH cr_cr2 INTO g_mmh.*,l_ima08,l_avl_stk, #FUN-A20044
                        l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
       CALL s_getstock(g_mmh.mmh03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET g_opseq=g_mmh.mmh08
       #--------------------------------- ima108,ima64,ima641應於料表或調撥處理
       #IF l_ima108 ='Y' THEN ELSE LET l_ima64=0 LET l_ima641=0 END IF
       #LET l_ima64=0 LET l_ima641=0
       #------------------------------------------------------------------
        IF g_mmh.mmh26 MATCHES '[SU]' THEN CONTINUE FOREACH END IF #Roger960608
       #----來源碼為'D'者不應出現
        IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF  #97/08/20 modify
        MESSAGE '--> ',g_mmh.mmh03,g_mmh.mmh08
        LET l_mmh03 = g_mmh.mmh03
 
        #Inflate With Minimum Issue Qty And Issue Pansize
### tony 00/10/25 QPA為負時不考慮發料批量 ####################################
        IF l_ima641 != 0 AND g_mmh.mmh05 < l_ima641 AND g_mmh.mmh161>0 THEN
#       IF l_ima641 != 0 AND g_mmh.mmh05 < l_ima641 THEN
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            LET g_mmh.mmh05=l_ima641
        END IF
### tony 00/10/25 QPA為負時不考慮發料倍量 ####################################
        IF l_ima64!=0 AND g_mmh.mmh05>0 THEN
#       IF l_ima64!=0 THEN
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            LET l_double=(g_mmh.mmh05/l_ima64)+ 0.999999
            LET g_mmh.mmh05=l_double*l_ima64
        END IF
 
        #-->考慮單位小數取位 
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_mmh.mmh12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         CALL cl_digcut(g_mmh.mmh05,l_gfe03) RETURNING l_mmhqty
         LET g_mmh.mmh05 =  l_mmhqty
       
#        IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A20044
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A20044
#        LET l_ima26=l_ima262 #FUN-A20044
        LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A20044
#        IF l_ima26<0 THEN LET l_ima26=0 END IF #FUN-A20044
        IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
#       原來庫存不足才找取代, 現在改為只要有取代, 先備取代料, 再備新料
        LET l_total2=g_mmh.mmh05
#        LET l_unaloc=g_mmh.mmh05-l_ima26 #FUN-A20044
        LET l_unaloc=g_mmh.mmh05-l_avl_stk_mpsmrp #FUN-A20044
        IF l_unaloc < 0 THEN LET l_unaloc=0 END IF
        #No.FUN-BB0086--add--begin--
        LET l_total2 = s_digqty(l_total2,g_mmh.mmh12)
        LET l_unaloc = s_digqty(l_unaloc,g_mmh.mmh12)
        #No.FUN-BB0086--add--end--
        UPDATE mmh_file SET mmh05 = l_total2,
                            mmh25 = l_unaloc
#            WHERE mmh01 = g_mmh.mmh01 AND mmh011 = g_mmh.mmg011 AND mmh03 = g_mmh.mmh03 AND mmh08 = g_mmh.mmh08 AND mmh12 = g_mmh.mmh12  #09/10/20 xiaofeizhu Mark
             WHERE mmh01 = g_mmh.mmh01 AND mmh011 = g_mmh.mmh011 AND mmh03 = g_mmh.mmh03 AND mmh08 = g_mmh.mmh08 AND mmh12 = g_mmh.mmh12  #09/10/20 xiaofeizhu Add  
    END FOREACH
END FUNCTION
