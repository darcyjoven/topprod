# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
##□ s_cralc
##SYNTAX	CALL s_mm_cralc(p_wo,p_wo1,p_part,p_btflg,
##			p_woq,p_date,p_mps,p_yld,p_lvl)
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
##RETURNING	_cnt		備料筆數
##SYSTEM	MFG/ASF
# Date & Author..: 00/12/26 By Chien
 # Modify.........: #NO.MOD-490217 04/09/10 by yiting 料號欄位放大
 # Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE rowid_NO INTEGER  應該轉為char(18)
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.FUN-830132 08/03/28 By hellen 行業別拆分表INSERT/DELETE
# Modify.........: No.FUN-870051 08/07/17 By sherry 增加被替代料(sfa27)為Key
# Modify.........: No.CHI-950037 09/06/22 By jan 在工單開立，產生備料時，需排除bmb14='不發料'的資料
# Modify.........: No.FUN-950088 09/07/01 By hongmei bml04廠牌帶到sfa36中
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980013 09/11/03 By jan 當bmb14='1'時,也要產生備料
# Modify.........: No:FUN-9C0040 10/01/28 By jan,當BOM單身性質為"回收料"時,產生備料時，"實際QPA"和"應發數量"為負值。
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A30093 10/04/15 By jan bmb14='3'時，產生工單備料時,sfa11為'C'
# Modify.........: No.MOD-A60197 10/06/30 By liuxqa sfa012,sfa013 賦初值。

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfa         RECORD LIKE sfa_file.*,
    g_mmg         RECORD LIKE mmg_file.*,
    g_opseq       LIKE sfa_file.sfa10, #operation sequence number
    g_offset      LIKE sfa_file.sfa09, #offset
    g_ima55       LIKE ima_file.ima55,
    g_ima55_fac   LIKE ima_file.ima55_fac,
    g_ima86       LIKE ima_file.ima86,
    g_ima86_fac   LIKE ima_file.ima86_fac,
    g_btflg       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#blow through flag
    g_wo          LIKE sfa_file.sfa01,          #No.FUN-680100 VARCHAR(10)#work order number
    g_wo1         LIKE sfa_file.sfa01,          #No.FUN-680100 VARCHAR(10)#work order number
    g_level       LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_ccc         LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_SOUCode     LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_mps         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_yld         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_factor      LIKE pml_file.pml09,          #No.FUN-680100 DEC(16,8)#   top40
    g_date        LIKE type_file.dat            #No.FUN-680100 DATE
 
DEFINE   g_status        LIKE type_file.num5    #No.FUN-680100 SMALLINT
FUNCTION s_mma_cralc(p_wo,p_wo1,p_part,p_btflg,p_woq,p_date,p_mps,p_yld)
DEFINE
    p_wo         LIKE mmg_file.mmg01,          #No.FUN-680100 VARCHAR(10)#work order number
    p_wo1        LIKE mmg_file.mmg02,          #No.FUN-680100 VARCHAR(10)#work order number
    p_part       LIKE ima_file.ima01,          #part number NO.MOD-490217
    p_btflg      LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#blow through flag
    p_woq        LIKE bmr_file.bmr09,          #No.FUN-680100 DECIMAL(11,3)#work order quantity
    p_date       LIKE type_file.dat,           #No.FUN-680100 DATE#effective date
    p_mps        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#if MPS phantom, blow through flag (Y/N)
    p_yld        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#inflate yield factor (Y/N)
    l_ima562     LIKE ima_file.ima562
 
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
    LET g_errno  = ' '
 
    SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = p_wo AND mmg02 = p_wo1
    IF STATUS THEN 
#    CALL cl_err('sel mmg:',STATUS,1)  #No.FUN-660094
     CALL cl_err3("sel","mmg_file",p_wo,p_wo1,STATUS,"","sel mmg",1)        #NO.FUN-660094
    RETURN 0 END IF
    SELECT ima562,ima55,ima55_fac,ima86,ima86_fac INTO 
      l_ima562,g_ima55,g_ima55_fac,g_ima86,g_ima86_fac
        FROM ima_file
        WHERE ima01=p_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
    CALL cralc_bom(0,p_part,p_woq,1)		#由BOM產生備料檔
    IF g_ccc=0 THEN 
       LET g_errno='asf-014' 			#有BOM但無有效者 
    END IF
    
    MESSAGE ""
    RETURN g_ccc
END FUNCTION
 
FUNCTION cralc_bom(p_level,p_key,p_total,p_QPA)
DEFINE
    p_level    LIKE type_file.num5,          #No.FUN-680100 SMALLINT#level code
    p_total    LIKE smh_file.smh103,         #No.FUN-680100 DECIMAL(13,5)
    p_QPA      LIKE bmb_file.bmb06,          #FUN-560230
    l_QPA      LIKE bmb_file.bmb06,          #FUN-560230
    l_total    LIKE smh_file.smh103,         #No.FUN-680100 DECIMAL(13,5)#原發數量
    l_total2   LIKE smh_file.smh103,         #No.FUN-680100 DECIMAL(13,5)#應發數量
    p_key      LIKE bma_file.bma01,          #assembly part number
    l_ac,l_i,l_x,l_s        LIKE type_file.num5,                      #No.FUN-680100 SMALLINT
    arrno                   LIKE type_file.num5,                      #No.FUN-680100 SMALLINT#BUFFER SIZE
    #l_rowid,b_seq,l_double  INTEGER, #restart sequence (line number) #MOD-4A0041
     b_seq,l_double          LIKE type_file.num10,  #No.FUN-680100 INTEGER, #restart sequence (line number)         #MOD-4A0041
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
        bmb14 LIKE bmb_file.bmb14, #CHI-980013
        ima08 LIKE ima_file.ima08, #source code
        ima37 LIKE ima_file.ima37, #OPC
        ima25 LIKE ima_file.ima25, #UOM
        ima55 LIKE ima_file.ima55, #生產單位
        ima86 LIKE ima_file.ima86, #COST UNIT
        ima86_fac LIKE ima_file.ima86_fac, #
         bma01 LIKE bma_file.bma01   #NO.MOD-490217 
    END RECORD,
    g_sfa RECORD  LIKE sfa_file.*,    #備料檔
    l_ima08 LIKE  ima_file.ima08, #source code
#    l_ima26 LIKE  ima_file.ima26, #QOH #FUN-A20044
    l_avl_stk_mpsmrp LIKE  type_file.num15_3, #FUN-A20044
    l_unavl_stk   LIKE type_file.num15_3, #FUN-A20044
    l_avl_stk     LIKE type_file.num15_3, #FUN-A20044
    l_SafetyStock LIKE ima_file.ima27,
    l_SSqty LIKE  ima_file.ima27,
    l_ima37 LIKE  ima_file.ima37, #OPC
    l_ima108 LIKE  ima_file.ima108,
    l_ima64 LIKE  ima_file.ima64,    #Issue Pansize
    l_ima641 LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom LIKE ima_file.ima25,        #Stock UOM
    l_chr LIKE type_file.chr1,        #No.FUN-680100 VARCHAR(1)
    l_sfa07 LIKE sfa_file.sfa07, #quantity owed
    l_sfa03 LIKE sfa_file.sfa03, #part No
    l_sfa11 LIKE sfa_file.sfa11, #consumable flag
#    l_qty LIKE ima_file.ima26, #issuing to stock qty #FUN-A20044
    l_qty LIKE type_file.num15_3,#FUN-A20044
    l_sfaqty  LIKE sfa_file.sfa05,
    l_gfe03   LIKE gfe_file.gfe03, 
#    l_bal LIKE ima_file.ima26, #balance (QOH-issue) #FUN-A20044
    l_bal LIKE type_file.num15_3,#FUN-A20044
    l_ActualQPA LIKE bmb_file.bmb06,   #FUN-560230
    l_sfa12 LIKE sfa_file.sfa12,    #發料單位
    l_sfa13 LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bml04 LIKE bml_file.bml04,    #指定廠商
    fs_insert  LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_sw       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    l_unaloc,l_uuc LIKE sfa_file.sfa25,      #unallocated quantity
    l_cnt,l_c  LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    l_cmd LIKE type_file.chr1000             #No.FUN-680100 VARCHAR(400)
DEFINE l_sfai  RECORD LIKE sfai_file.*       #No.FUN-830132
DEFINE l_sfa11_a  LIKE sfa_file.sfa11        #CHI-980013
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
            "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,",   #top40
            "bmb14,",  #CHI-980013 
            "ima08,ima37,ima25,ima55,",                           #top40
            " ima86,ima86_fac,bma01",
#           " FROM bmb_file,OUTER ima_file,OUTER bma_file",                    #09/10/20 xiaofeizhu Mark
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 ",       #09/10/20 xiaofeizhu Add
            " LEFT OUTER JOIN bma_file ON bmb01 = bma01 ",                     #09/10/20 xiaofeizhu Add
            " WHERE bmb01='", p_key,"' AND bmb02>?",
            " AND bmb01 = bma_file.bma01",
            " AND bmb03 = ima_file.ima01",
           #" AND bmb14 != '1'",  #CHI-950037 #CHI-980013
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
            #-->inflate yield
            IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
            #-->Actual QPA
##------99/07/16 modify 應發數量算法
            LET l_ActualQPA=(sr[l_i].bmb06*(1+sr[l_i].bmb08/100))*p_QPA
            LET l_QPA=sr[l_i].bmb06 * p_QPA     ##94/12/06 Add 該行 Jackson
            LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
##-----------------------------
            LET l_total2=l_total
 
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
                LET sr[l_i].bmb10_fac=1
            END IF
 
            LET l_bml04=NULL
            #CHI-980013--begin--mod
            #SELECT bml04 INTO l_bml04 FROM bml_file
            # WHERE bml01=sr[l_i].bmb03 AND bml02=p_key AND bml03=1
            DECLARE bml_cur CURSOR FOR
             SELECT bml04 FROM bml_file
              WHERE bml01=sr[l_i].bmb03
                AND (bml02=p_key OR bml02='ALL')
              ORDER BY bml03
            FOREACH bml_cur INTO l_bml04
              EXIT FOREACH
            END FOREACH
            #CHI-980013--end--mod-- 
 
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
                           LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor
                           LET l_ActualQPA=
                                      (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
                           CALL cralc_bom(p_level,sr[l_i].bmb03,
                           p_total*sr[l_i].bmb06,l_ActualQPA)
                           LET fs_insert = 'N'
                      OTHERWISE
                           LET fs_insert = 'Y'
                   END CASE
                END IF
                IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
                LET l_uuc=0
                IF fs_insert = 'Y' THEN
                INITIALIZE g_sfa.* TO NULL
                LET g_sfa.sfa01  = g_wo
                LET g_sfa.sfa02  = g_ccc + 1
                LET g_sfa.sfa03  = sr[l_i].bmb03
                LET g_sfa.sfa04  = l_total
                LET g_sfa.sfa05  = l_total2
                LET g_sfa.sfa06  = 0
                LET g_sfa.sfa061 = 0
                LET g_sfa.sfa062 = 0
                LET g_sfa.sfa063 = 0
                LET g_sfa.sfa064 = 0
                LET g_sfa.sfa065 = 0
                LET g_sfa.sfa066 = 0
                LET g_sfa.sfa07  = 0
                LET g_sfa.sfa08 = g_opseq
                IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
                LET g_sfa.sfa09 = g_offset
                LET g_sfa.sfa11 = l_sfa11
                LET g_sfa.sfa12 = sr[l_i].bmb10
                LET g_sfa.sfa13 = sr[l_i].bmb10_fac
                LET g_sfa.sfa14 = sr[l_i].ima86
                LET g_sfa.sfa15 = sr[l_i].bmb10_fac2
                LET g_sfa.sfa16 = l_QPA
                LET g_sfa.sfa161= l_ActualQPA
                LET g_sfa.sfa25 = l_uuc
                LET g_sfa.sfa26 = 0
                LET g_sfa.sfa27 = sr[l_i].bmb03
                LET g_sfa.sfa28 = 1
                LET g_sfa.sfa29 = p_key
                LET g_sfa.sfa30 = g_mmd.mmd16
                LET g_sfa.sfa31 = ' '
                LET g_sfa.sfaacti ='Y'
                LET g_sfa.sfa100  = 0
                LET g_sfa.sfa36   = l_bml04   #FUN-950088 add
                LET g_sfa.sfaplant = g_plant #FUN-980004 add
                LET g_sfa.sfalegal = g_legal #FUN-980004 add
                LET g_sfa.sfa012 = ' '       #MOD-A60197 add
                LET g_sfa.sfa013 = 0         #MOD-A60197 add 
                IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  #CHI-980013
                INSERT INTO sfa_file VALUES(g_sfa.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                   #IF SQLCA.SQLCODE=-239 THEN               #TQC-790091 mark
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                            FROM sfa_file
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                                AND sfa08=g_opseq
                                AND sfa27 = sr[l_i].bmb03     #No.FUN-870051
                        LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                        LET l_total=l_total*l_sfa13
                        LET l_total2=l_total2*l_sfa13
                        #CHI-980013--begin--add-
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                           AND sfa27 = sr[l_i].bmb03 
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF
                        #CHI-980013--end--add--
                        UPDATE sfa_file
                            SET sfa04=sfa04+l_total,
                                sfa05=sfa05+l_total2,
                               #sfa16=sfa16+sr[l_i].bmb06,  ##94/12/06 Jackson
                                sfa16=sfa16+l_QPA,         
                                sfa161=sfa161+l_ActualQPA
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                                AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                                AND sfa27 = sr[l_i].bmb03     #No.FUN-870051
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                           ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                           CONTINUE FOR
                        END IF
                    END IF
                #No.FUN-830132 080328 add --begin
                ELSE
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = g_sfa.sfa01
                      LET l_sfai.sfai03 = g_sfa.sfa03
                      LET l_sfai.sfai08 = g_sfa.sfa08
                      LET l_sfai.sfai12 = g_sfa.sfa12
                      LET l_sfai.sfai27 = g_sfa.sfa27      #No.FUN-870051 
                      IF NOT s_ins_sfai(l_sfai.*,'') THEN
                         ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                         CONTINUE FOR
                      END IF
                   END IF
                #No.FUN-830132 080328 add --end
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
                    CALL cralc_bom(p_level,sr[l_i].bmb03,
                        p_total*sr[l_i].bmb06,l_ActualQPA)
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
#      SELECT sfa_file.rowid,sfa_file.*,                                        #09/10/20 xiaofeizhu Mark
       SELECT sfa_file.*,                                                       #09/10/20 xiaofeizhu Add   
#            ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
            ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
#        FROM sfa_file,OUTER ima_file                                           #09/10/20 xiaofeizhu Mark
         FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03=ima01                  #09/10/20 xiaofeizhu Add
#       WHERE sfa01=g_wo  AND sfa02 = g_wo1 AND ima_file.ima01=sfa03            #09/10/20 xiaofeizhu Mark
        WHERE sfa01=g_wo  AND sfa02 = g_wo1                                     #09/10/20 xiaofeizhu Add
#   FOREACH cr_cr2 INTO l_rowid,g_sfa.*,l_ima08,l_ima262,                       #09/10/20 xiaofeizhu Mark
#    FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_ima262,                               #09/10/20 xiaofeizhu Add   #FUN-A20044
    FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_avl_stk,                               #FUN-A20044
                        l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
       CALL s_getstock(g_sfa.sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET g_opseq=g_sfa.sfa08
       #--------------------------------- ima108,ima64,ima641應於料表或調撥處理
       #IF l_ima108 ='Y' THEN ELSE LET l_ima64=0 LET l_ima641=0 END IF
       #LET l_ima64=0 LET l_ima641=0
       #------------------------------------------------------------------
        IF g_sfa.sfa26 MATCHES '[SUZ]' THEN CONTINUE FOREACH END IF #Roger960608   #FUN-A20037 add 'Z'
       #----來源碼為'D'者不應出現
        IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF  #97/08/20 modify
        MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
        LET l_sfa03 = g_sfa.sfa03
 
        #Inflate With Minimum Issue Qty And Issue Pansize
### tony 00/10/25 QPA為負時不考慮發料批量 ####################################
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
        IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 AND g_sfa.sfa161>0 THEN
#       IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
           LET g_sfa.sfa05=l_ima641
        END IF
### tony 00/10/25 QPA為負時不考慮發料倍量 ####################################
        IF l_ima64!=0 AND g_sfa.sfa05>0 THEN
#       IF l_ima64!=0 THEN
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
           LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999
           LET g_sfa.sfa05=l_double*l_ima64
        END IF
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
        #-->考慮單位小數取位 
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sfa.sfa12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         CALL cl_digcut(g_sfa.sfa05,l_gfe03) RETURNING l_sfaqty
         LET g_sfa.sfa05 =  l_sfaqty
       
#        IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A20044 
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A20044 
#        LET l_ima26=l_ima262 #FUN-A20044
        LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A20044
#        IF l_ima26<0 THEN LET l_ima26=0 END IF #FUN-A20044
        IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
#       原來庫存不足才找取代, 現在改為只要有取代, 先備取代料, 再備新料
        LET l_total2=g_sfa.sfa05
#        LET l_unaloc=g_sfa.sfa05-l_ima26 #FUN-A20044
        LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp #FUN-A20044
        IF l_unaloc < 0 THEN LET l_unaloc=0 END IF
        IF g_sfa.sfa11 = 'X' THEN LET l_total2 = 0 END IF  #CHI-980013
        UPDATE sfa_file SET sfa05 = l_total2,
                            sfa25 = l_unaloc
#               WHERE rowid=l_rowid                                              #09/10/20 xiaofeizhu Mark
                WHERE sfa01=g_sfa.sfa01                                          #09/10/20 xiaofeizhu Add
                  AND sfa03=g_sfa.sfa03                                          #09/10/20 xiaofeizhu Add
                  AND sfa08=g_sfa.sfa08                                          #09/10/20 xiaofeizhu Add
                  AND sfa12=g_sfa.sfa12                                          #09/10/20 xiaofeizhu Add
    END FOREACH
END FUNCTION
