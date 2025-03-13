# Prog. Version..: '5.30.06-13.03.12(00010)'     #
     #
     # Pattern name...: s_alloc2.4gl
     # Descriptions...: 產生產品備料資料 (用於預測工單)
     # Date & Author..: 
     # Usage..........: CALL s_alloc(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,
     #                               p_mps,p_yld,p_lvl,p_minopseq,p_cw,p_altno)
#                  RETURNING l_cnt
# Input Parameter: p_wo      工單編號
#                  p_wotype  工單型態
#                  p_part    料件編號
#                  p_btflg   是否展開下階(sma29)
#                  p_woq     工單數量
#                  p_date    有效日期
#                  p_mps     MPS料件是否展開
#                  p_yld     損耗率
#                  p_lvl     展開階數       
#                  p_minopseq 最小序號
#                  p_altno    特性代碼
# Return code....: l_cnt     備料筆數
# Modify.........: 01/05/15 By Tommy 將bmb28代入sfa100
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-560002 05/06/03 By wujie  單據編號修改
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.TQC-610003 06/01/17 By Nicola 工單單身備料時多傳入參數－特性代碼, 並依特性代碼取 abmi600 資料展至工單單身(sfa_file)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-790089 07/09/17 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0067 07/10/19 By Pengu CHI-740001在SQL中加入bmaacti='Y'條件但未轉成OUTER語法
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-860164 08/06/13 By claire insert into sfa_file個數與schema不合(bmb31-sfa32代買料)
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.CHI-8A0002 08/10/06 By claire 備料若未發放顯示訊息,並不往下展
# Modify.........: No.TQC-8B0009 08/11/06 By Carrier 加入分量損耗率功能-abmi612設定
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-8C0002 08/12/01 By claire CHI-8A0002 考慮有特性代碼的設定 
# Modify.........: No.MOD-8C0148 08/12/16 By chenyu ima910沒有維護時，還是用sfb95
# Modify.........: No.MOD-910047 09/01/06 By chenyu INSERT INTO的語法改善
# Modify.........: No.FUN-940008 09/05/18 By hongmei 發料改善
# Modify.........: No.CHI-950037 09/06/12 By jan 在工單開立，產生備料時，需排除bmb14='不發料
# Modify.........: No.FUN-950088 09/07/01 By hongmei 將bml04帶到sfa36廠牌中
# Modify.........: No.TQC-970210 09/07/29 By dxfwo   s_cralc,s_cralc2,s_cralc3,s_cralc4,s_cralc5 沒有修改OUTER 問題 
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-9A0149 09/10/23 By lilingyu 抓取BOM資料時如果該料有多個特性代碼時會發生多取的情況
# Modify.........: No.CHI-980013 09/11/02 By jan 當bmb14='1'時,也要產生備料
# Modify.........: No:MOD-990114 09/11/11 By sabrina 還原TQC-8C0002的修正
# Modify.........: No:FUN-9C0040 10/01/28 By jan,當BOM單身性質為"回收料"時,產生工單備料時，"實際QPA"和"應發數量"為負值。
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A30093 10/04/15 By jan bmb14='3'時，產生工單備料時,sfa111為C
# Modify.........: No:FUN-A30003 10/04/16 By destiy 修改工单备料时损耗计算方法 
# Modify.........: No:TQC-A50052 10/05/17 By destiy 损耗率分量汇总计算时，实际QPA计算有误
# Modify.........: No:FUN-A60031 10/06/17 By destiy 重新计算损耗率                     
# Modify.........: No:FUN-A50066 10/06/10 By jan 新增依製程BOM展工單的處理
# Modify.........: No.FUN-A60076 10/06/25 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-A60080 10/07/07 By destiy 重新计算损耗率                     
# Modify.........: No:MOD-A80161 10/08/23 By sabrina 下階料的特性代碼應串料件主檔的主特性代碼(ima910)
#                                                    應由bmb01串bma01和ima01
# Modify.........: No:TQC-A80180 10/08/31 By destiny 参数设定为并行工艺，但工单不走工艺时应从abmi600中抓取bom资料
# Modify.........: No:TQC-B80104 11/08/17 By houlia 增加bmaacti控管 
# Modify.........: No:TQC-BB0174 11/11/18 By lilingyu 原發數量sfa04,應發數量sfa05可能出現NULL值，導致無法產生備料
# MOdify.........: No.FUN-BB0085 11/12/05 By xianghui 增加數量欄位小數取位
# Modify.........: No:MOD-BC0209 11/12/20 By ck2yuan 讓sfa29存上階的料號
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
    g_opseq      LIKE sfa_file.sfa08, #operation sequence number
    g_offset     LIKE sfa_file.sfa09, #offset
    g_ima86      LIKE ima_file.ima86, #offset
    g_ima55      LIKE ima_file.ima86, #offset
    g_ima86_fac  LIKE ima_file.ima86_fac, #offset
    g_btflg      LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01) #blow through flag
    g_wo         LIKE sfa_file.sfa01,             #No.FUN-680147 VARCHAR(16) #No.FUn-560002
    g_wotype     LIKE type_file.num5,             #No.FUN-680147 SMALLINT #work order type
    g_level      LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    g_ccc        LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    g_SOUCode    LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(01)
    g_mps        LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(01)
    g_yld        LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(01)
    g_cw         LIKE type_file.chr1000,          #No.FUN-680147 VARCHAR(100)
    g_minopseq   LIKE ecb_file.ecb03,
    g_date       LIKE type_file.dat               #No.FUN-680147 DATE
DEFINE   g_cnt   LIKE type_file.num10             #No.FUN-680147 INTEGER
DEFINE   g_part         LIKE ima_file.ima01


FUNCTION s_cralc2(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
                  p_minopseq,p_cw,p_altno)
   DEFINE p_wo         LIKE sfa_file.sfa01,           #No.FUN-680147 VARCHAR(16) #No.FUN560002
          p_wotype     LIKE type_file.num5,           #No.FUN-680147 SMALLINT #work order type
          p_part       LIKE ima_file.ima01,           #part number #No.MOD-490217
          p_btflg      LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01) #blow through flag
          p_woq        LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(11,3) #work order quantity
          p_date       LIKE type_file.dat,            #No.FUN-680147 DATE #effective date
          p_mps        LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01) #if MPS phantom, blow through flag (Y/N)
          p_yld        LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01) #inflate yield factor (Y/N)
          p_minopseq   LIKE ecb_file.ecb03,
          l_ima562     LIKE ima_file.ima562,
          p_cw         LIKE type_file.chr1000,        #No.FUN-680147 VARCHAR(100)
          p_altno      LIKE bma_file.bma06            #No.TQC-610003
   DEFINE l_ima910     LIKE ima_file.ima910           #FUN-550112
   DEFINE l_ecm03_par  LIKE ecm_file.ecm03_par  #FUN-A50066
   DEFINE l_ecm11    LIKE ecm_file.ecm11        #FUN-A50066
   DEFINE l_ecm03    LIKE ecm_file.ecm03        #FUN-A50066
   DEFINE l_ecm012   LIKE ecm_file.ecm012       #FUN-A50066
   DEFINE l_sfb93    LIKE sfb_file.sfb93        #FUN-A50066
   DEFINE l_n        LIKE type_file.num5        #NO.TQC-A80180
   
    WHENEVER ERROR CALL cl_err_msg_log
    MESSAGE ' Allocating ' ATTRIBUTE(REVERSE)
    LET g_ccc=0
    LET g_date=p_date
    LET g_btflg=p_btflg
    LET g_wo=p_wo
    LET g_wotype=p_wotype
    LET g_opseq=' '
    LET g_offset=''
    LET g_mps=p_mps
    LET g_yld=p_yld
    LET g_errno=' '
    LET g_minopseq=p_minopseq
    LET g_cw=p_cw
    LET g_part=p_part
    
    IF cl_null(g_cw) THEN LET g_cw=" 1=1 " END IF
 
    SELECT ima562,ima55,ima86,ima86_fac
      INTO l_ima562,g_ima55,g_ima86,g_ima86_fac
      FROM ima_file
     WHERE ima01=p_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN RETURN 0 END IF
 
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
 
 
    #FUN-550112
    LET l_ima910=''
    SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
    #--
    SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_wo  #FUN-A50066
    #檢查該料件是否有產品結構
    SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb01=p_part
    IF g_cnt IS NULL OR g_cnt=0 THEN
        LET g_errno='asf-015'        #無產品結構
    ELSE
        IF g_sma.sma542 = 'Y' AND l_sfb93 = 'Y' THEN
           DECLARE ecm_cur CURSOR FOR
            SELECT distinct ecm03_par,ecm11,ecm03,ecm012 FROM ecm_file
             WHERE ecm01=g_wo 
               ORDER BY ecm03_par,ecm11,ecm012,ecm03
           FOREACH ecm_cur INTO l_ecm03_par,l_ecm11,l_ecm03,l_ecm012
                   CALL cralc_brb_bom2(0,p_part,p_altno,p_woq,1,l_ecm03_par,l_ecm11,l_ecm03,l_ecm012)
           END FOREACH
           #NO.TQC-A80180--begin
           SELECT COUNT(*) INTO l_n FROM sfa_file WHERE sfa01=g_sfb.sfb01
           IF l_n=0 THEN 
              CALL cralc_bom2(0,p_part,p_altno,p_woq,1)
           END IF  
           #NO.TQC-A80180--end
        ELSE
        #FUN-A50066--end--add--------------------------
           CALL cralc_bom2(0,p_part,p_altno,p_woq,1)  #FUN-550112  #No.TQC-610003  
        END IF  #FUN-A50066
        IF g_ccc=0 THEN
           LET g_errno='asf-014'
        END IF    #有BOM但無有效者
    END IF
    
    MESSAGE ""
    RETURN g_ccc
END FUNCTION
 
FUNCTION cralc_bom2(p_level,p_key,p_key2,p_total,p_QPA)  #FUN-550112   
DEFINE
    p_level        LIKE type_file.num5,           #No.FUN-680147 SMALLINT #level code
    p_total        LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(13,5)
    p_QPA          LIKE bmb_file.bmb06,           #FUN-560230
    l_QPA          LIKE bmb_file.bmb06,           #FUN-560230
    l_total        LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(13,5)   #原發數量
    l_total2       LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(13,5)  #應發數量
    p_key          LIKE bma_file.bma01,           #assembly part number
    p_key2         LIKE ima_file.ima910,          #FUN-550112
    l_ac,l_i,l_x   LIKE type_file.num5,           #No.FUN-680147 SMALLINT
    arrno          LIKE type_file.num5,           #No.FUN-680147 SMALLINT #BUFFER SIZE
    b_seq,l_double LIKE type_file.num10,          #No.FUN-680147 INTEGER #restart sequence (line number)
    sr ARRAY[500] OF RECORD  #array for storage
        bmb02      LIKE bmb_file.bmb02, #SEQ
        bmb03      LIKE bmb_file.bmb03, #component part number
        bmb10      LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac  LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb10_fac2 LIKE bmb_file.bmb10_fac2,#Issuing UOM to cost transfer rate
        bmb15      LIKE bmb_file.bmb15, #consumable part flag
        bmb16      LIKE bmb_file.bmb16, #substitable flag
        bmb31      LIKE bmb_file.bmb31, #MOD-860164 add
        bmb06      LIKE bmb_file.bmb06, #QPA
        bmb08      LIKE bmb_file.bmb08, #yield
        bmb081      LIKE bmb_file.bmb081,#No.FUN-A60031
        bmb082      LIKE bmb_file.bmb082,#No.FUN-A60031        
        bmb09      LIKE bmb_file.bmb09, #operation sequence number
        bmb18      LIKE bmb_file.bmb18, #days offset
        bmb28      LIKE bmb_file.bmb28, #
        ima08      LIKE ima_file.ima08, #source code
        ima37      LIKE ima_file.ima37, #OPC
        ima25      LIKE ima_file.ima25, #UOM
        ima86      LIKE ima_file.ima86, #COST UNIT
        ima86_fac  LIKE ima_file.ima86_fac, #
        bma01      LIKE bma_file.bma01  #No.MOD-490217 
       ,bma05      LIKE bma_file.bma05, #CHI-8A0002 add
        bmb19      LIKE bmb_file.bmb19, #CHI-8A0002 add
        bmb14      LIKE bmb_file.bmb14  #CHI-980013 add
    END RECORD,
    g_sfa RECORD   LIKE sfa_file.*,    #備料檔
    l_ima08        LIKE ima_file.ima08, #source code
#    l_ima26        LIKE ima_file.ima26, #QOH #FUN-A20044
    l_avl_stk_mpsmrp       LIKE type_file.num15_3, #QOH #FUN-A20044
    l_SafetyStock  LIKE ima_file.ima27,
    l_SSqty        LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37, #OPC
    l_ima64        LIKE ima_file.ima64,    #Issue Pansize
    l_ima641       LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom          LIKE ima_file.ima25,        #Stock UOM
    l_chr          LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_sfa07        LIKE sfa_file.sfa07, #quantity owed
    l_sfa03        LIKE sfa_file.sfa03, #part No
    l_sfa11        LIKE sfa_file.sfa11, #consumable flag
#    l_qty          LIKE ima_file.ima26, #issuing to stock qty #FUN-A20044
    l_qty          LIKE type_file.num15_3, #issuing to stock qty #FUN-A20044
#    l_bal          LIKE ima_file.ima26, #balance (QOH-issue) #FUN-A20044
    l_bal          LIKE type_file.num15_3, #balance (QOH-issue) #FUN-A20044
    l_ActualQPA    LIKE bmb_file.bmb06,  #FUN-560230
    l_sfa12        LIKE sfa_file.sfa12,    #發料單位
    l_sfa13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c      LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_cmd          LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
DEFINE l_sfai      RECORD LIKE sfai_file.*      #No.FUN-7B0018
DEFINE l_flag      LIKE type_file.chr1          #No.FUN-7B0018
DEFINE l_bof06_1   LIKE bmb_file.bmb08          #No.TQC-8B0009
DEFINE l_bof06_2   LIKE bmb_file.bmb08          #No.TQC-8B0009
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
DEFINE l_bml04     LIKE bml_file.bml04     #廠商 #FUN-950088 add
DEFINE l_sfa11_a   LIKE sfa_file.sfa11     #CHI-980013
DEFINE l_bmaacti   LIKE bma_file.bmaacti   #TQC-B80104 add
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
#           "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,ima08,ima37,",
            # No.+114 Tommy
            "bmb15,bmb16,bmb31,bmb06/bmb07,bmb08,bmb081,bmb082,bmb09,bmb18,bmb28,ima08,ima37,",  #MOD-860164 add bmb31   #No.FUN-A60031 add bmb081,bmb082
           #MOD-A80161---modify---start---
           #" ima25,ima86,ima86_fac,bma01,bma05,bmb19,bmb14",  #CHI-8A0002 add bma05,bmb19 #CHI-980013 add bmb14
           #" FROM bmb_file,OUTER ima_file,OUTER bma_file ",
            " ima25,ima86,ima86_fac,'','',bmb19,bmb14",  #CHI-8A0002 add bma05,bmb19 #CHI-980013 add bmb14
            " FROM bmb_file,OUTER ima_file ",
           #MOD-A80161---modify---end---
            " WHERE bmb01='", p_key,"'"," AND bmb02>? ",  #NO:7075
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
           #"   AND bmb29 = bma_file.bma06 ",   #MOD-9A0149  #MOD-A80161 mark
           #" AND bmb03 = bma_file.bma01 ",                                                                                                  
           #" AND bmb03 = ima_file.ima01 ",                                                                                                  
           #" AND bmb03 = bma_file.bma01 ", #No.TQC-970210   #MOD-A80161 mark                                                                       
            " AND bmb03 = ima_file.ima01 ", #No.TQC-970210 
           #" AND bmb14 != '1'",  #CHI-950037	#CHI-980013
           #" AND bma_file.bmaacti = 'Y' ", #CHI-740001  #No.TQC-7A0067 modify  #MOD-A80161 mark
            " AND (bmb04 <='",g_date,
            "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
            "' OR bmb05 IS NULL)",
            " AND ",g_cw CLIPPED,
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
           #MOD-990114---mark---start---
           ##TQC-8C0002-begin-add
           #IF cl_null(sr[l_ac].bma05) THEN
           #   SELECT bma05 INTO sr[l_ac].bma05 FROM bma_file
           #    WHERE bma01 = p_key  
           #      AND bma06 = p_key2
           #END IF 
           ##TQC-8C0002-end-add
           #MOD-990114---mark---end---
           #TQC-B80104 --add
           LET l_bmaacti=''
            SELECT bmaacti INTO l_bmaacti FROM bma_file
             WHERE bma01 = p_key
               AND bma06 = p_key2
            IF l_bmaacti = 'N' THEN CONTINUE FOREACH END IF
            #TQC-B80104  --end
           #MOD-A80161---add---start---
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            SELECT bma01,bma05 INTO sr[l_ac].bma01,sr[l_ac].bma05
              FROM bma_file
             WHERE bma01=sr[l_ac].bmb03
               AND bma06=l_ima910[l_ac]
           #MOD-A80161---add---end---
            #CHI-8A0002-begin-add
            IF sr[l_ac].bmb19 <> '1' THEN
             IF cl_null(sr[l_ac].bma05) OR 
                (NOT cl_null(sr[l_ac].bma05)  AND sr[l_ac].bma05 > g_date) THEN
                CALL cl_err(sr[l_ac].bmb03,'abm-005',1)
                EXIT FOREACH
             END IF
            END IF
            #CHI-8A0002-end-add
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
                LET sr[l_ac].bmb10_fac=1
            END IF
            IF sr[l_ac].bmb16 IS NULL THEN    #若未定義, 則給予'正常'
                LET sr[l_ac].bmb16='0'
            END IF
            #FUN-8B0015--BEGIN--                                                                                                     
           #MOD-A80161---mark---start---
           #LET l_ima910[l_ac]=''
           #SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           #IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #MOD-A80161---mark---end---
           #IF l_ima910[l_ac]=' ' THEN LET l_ima910[l_ac]=p_key2 END IF  #No.MOD-8C0148 add   #MOD-990114 mark
            #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #operation sequence number
            IF sr[l_i].bmb09 IS NOT NULL
#               AND cl_null(g_opseq) 
                THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].bmb09
                LET g_offset=sr[l_i].bmb18
            END IF
            #無製程序號
#           IF g_opseq IS NULL THEN LET g_opseq=g_minopseq END IF
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
 
            LET g_SOUCode='0'
            IF sr[l_i].bmb16='2' THEN
                LET g_SOUCode=g_sma.sma67
            ELSE
                IF sr[l_i].bmb16='1' THEN        #UTE
                    LET g_SOUCode=g_sma.sma66    #保留安全庫存, 以備不時之需
                END IF
            END IF
            #No.FUN-A60031--begin--mark
            ##No.TQC-8B0009  --Begin
            #LET l_bof06_1 = 0                                                                                                       
            #LET l_bof06_2 = 0    
            #                                                                                      
            #SELECT bof06 INTO l_bof06_1 FROM bof_file                                                     
            # WHERE bof01 = p_key
            #   AND bof02 = '1'                                                                                          
            #   AND bof03 = sr[l_i].bmb03                                                                                
            #   AND bof04 <= p_total
            #   AND (bof05 >= p_total OR bof05 IS NULL)                                                              
            #IF l_bof06_1 >0 THEN                                                                                                    
            #   LET l_bmb08 = l_bof06_1                                                                                           
            #END IF    
            #                                                                                                                   
            #SELECT bof06 INTO l_bof06_2 FROM bof_file,ima_file                                                                         
            # WHERE bof01 = p_key
            #   AND bof02 = '2'                                                                                         
            #   AND bof03 = ima10                                                                                       
            #   AND ima01 = sr[l_i].bmb03                                                                               
            #   AND bof04 <= p_total
            #   AND (bof05 >= p_total OR bof05 IS NULL)                                                             
            #IF l_bof06_2 >0 THEN                                                                                                    
            #   LET l_bmb08 = l_bof06_2                                                                                           
            #END IF                                                                                                                                                  
            ##No.TQC-8B0009  --End  
            ##inflate yield
            #IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
            ##Actual QPA
           ##LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA  #No.TQC-8B0009 
            #LET l_ActualQPA=sr[l_i].bmb06*(1+sr[l_i].bmb08/100)*p_QPA  #No.TQC-8B0009
            #LET l_QPA=sr[l_i].bmb06 * p_QPA     ##94/12/16 Add 該行 Jackson
            #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA) 
            RETURNING l_total,l_QPA,l_ActualQPA
            #No.FUN-A60031--end                
            LET l_total2=l_total          
        #   LET l_sfa07=0     #FUN-940008 mark
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
        #       LET l_sfa07=l_total   #FUN-940008 mark
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
     #
     #      IF sr[l_i].ima08='X' THEN
     #          IF g_btflg='N' THEN #phantom
     #              CONTINUE FOR #do'nt blow through
     #          ELSE
     #              IF sr[l_i].ima37='1' AND g_mps='N' THEN #MPS part
     #                  CONTINUE FOR #do'nt blow through
     #              END IF
     #          END IF
     #          IF sr[l_i].bma01 IS NOT NULL THEN 
     #              CALL cralc_bom2(p_level,sr[l_i].bmb03,' ',  #FUN-550112
     #                  p_total*sr[l_i].bmb06,l_ActualQPA)
     #          END IF
     #      END IF
     #
######
            #FUN-950088---Begin                                                 
            DECLARE bml_cur CURSOR FOR                                          
            SELECT bml04 FROM bml_file                                          
             WHERE bml01=sr[l_i].bmb03                                          
               AND (bml02=p_key OR bml02='ALL')                                 
            ORDER BY bml03                #CHI-980013
           #OPEN bml_cur   #CHI-980013
           #FETCH bml_cur INTO l_bml04    #CHI-980013
            FOREACH bml_cur INTO l_bml04  #CHI-980013
              EXIT FOREACH                #CHI-980013
            END FOREACH                   #CHI-980013
            #FUN-950088---End
 
            IF sr[l_i].bma01 IS NOT NULL THEN 
                #CALL cralc_bom2(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #FUN-8B0015
                #    p_total*sr[l_i].bmb06,l_ActualQPA)           
                #NO.FUN-A60080--begin--mark
                #CALL cralc_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],
                #          l_total,l_ActualQPA)          
                CALL cralc_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],
                          l_total,l_QPA)              
                #NO.FUN-A60080--end                             
            ELSE  
               IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
               LET g_ccc=g_ccc+1
               LET l_uuc=0
               CASE WHEN sr[l_i].bmb16 = '0' LET sr[l_i].bmb16 = '0' 
                    WHEN sr[l_i].bmb16 = '1' LET sr[l_i].bmb16 = '1' 
                    WHEN sr[l_i].bmb16 = '2' LET sr[l_i].bmb16 = '1' 
               END CASE
#bugno:5541 add ......................................................
               IF sr[l_i].bmb16 !='0'  THEN  #表有取替代的情況
                  LET l_QPA=0
                  LET l_ActualQPA=0
               END IF 
#bugno:5541 end ......................................................
               #No.MOD-910047 add --begin
               INITIALIZE g_sfa.* TO NULL           
               LET g_sfa.sfa01  = g_wo
               LET g_sfa.sfa02  = g_wotype
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
          #    LET g_sfa.sfa07  = l_sfa07 #FUN-940008 mark
               LET g_sfa.sfa08  = g_opseq
               LET g_sfa.sfa09  = g_offset 
               LET g_sfa.sfa10  = ' '
               LET g_sfa.sfa11  = l_sfa11
               LET g_sfa.sfa12  = sr[l_i].bmb10
               LET g_sfa.sfa13  = sr[l_i].bmb10_fac
               LET g_sfa.sfa14  = sr[l_i].ima86
               LET g_sfa.sfa15  = sr[l_i].bmb10_fac2
               LET g_sfa.sfa16  = l_QPA
               LET g_sfa.sfa161 = l_ActualQPA
               LET g_sfa.sfa25  = l_uuc
               LET g_sfa.sfa26  = sr[l_i].bmb16
               LET g_sfa.sfa27  = sr[l_i].bmb03
               LET g_sfa.sfa28  = 1
               LET g_sfa.sfa100 = sr[l_i].bmb28
               LET g_sfa.sfaacti= 'Y'
               LET g_sfa.sfa32  = sr[l_i].bmb31
               LET g_sfa.sfa36  = l_bml04  #FUN-950088 add
               LET g_sfa.sfaplant  = g_plant  #FUN-980012 add
               LET g_sfa.sfalegal  = g_legal  #FUN-980012 add
               LET g_sfa.sfa29 = p_key        #MOD-BC0209 add
               IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF   #No.FUN-A60031
               IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF   #No.FUN-A60031            

#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
               LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)  #FUN-BB0085
               LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)  #FUN-BB0085

               IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  #CHI-980013 
               INSERT INTO sfa_file VALUES(g_sfa.*)
               #No.MOD-910047 add --end
              #No.MOD-910047 mark --begin
              #INSERT INTO sfa_file
              #        #     1,       2,            3,      4,
              #    VALUES(g_wo,g_wotype,sr[l_i].bmb03,l_total,
              #    #      5, 6,            7,       8,       9,
              #    l_total2, 0,0,0,0,0,0,0,l_sfa07,g_opseq,g_offset,
              #    #10,     11,           12,               13,
              #    ' ', l_sfa11,sr[l_i].bmb10,sr[l_i].bmb10_fac,
              #    #14,                 15,           16,      
              #    sr[l_i].ima86, sr[l_i].bmb10_fac2,l_QPA,           
              #    #161        
              #    l_ActualQPA,
              #    #25,  26,           27,          28,29,30,31,
              #    l_uuc,sr[l_i].bmb16,sr[l_i].bmb03,1,'','','',
#             #    '','','','','','','','','','Y')
              #    # No.+114 Tommy
              #    '','','','','','','','','',sr[l_i].bmb28,'Y',sr[l_i].bmb31,  #MOD-860164 add bmb31
              #    '','','','','','','','','','','','','','','')  #No.TQC-8B0009 自定義字段
              #No.MOD-910047 mark --end
               IF SQLCA.SQLCODE THEN    #Duplicate
                  #IF SQLCA.SQLCODE=-239 THEN               #TQC-790089 mark
                   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790089 mod
                       #因為相同的料件可能有不同的發料單位, 故宜換算之
                       SELECT sfa13 INTO l_sfa13
                           FROM sfa_file
                           WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                               AND sfa08=g_opseq
                               AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                       LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                       LET l_total=l_total*l_sfa13
                       LET l_total2=l_total2*l_sfa13
                       LET l_total=s_digqty(l_total,sr[l_i].bmb10)     #FUN-BB0085
                       LET l_total2=s_digqty(l_total2,sr[l_i].bmb10)   #FUN-BB0085
                       #CHI-980013--begin--add--
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file 
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                           AND sfa27=sr[l_i].bmb03
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF 
                        #CHI-980013--end--add-- 
                       UPDATE sfa_file
                           SET sfa04=sfa04+l_total,
                               sfa05=sfa05+l_total2,
                               sfa16=sfa16+sr[l_i].bmb06,
                               sfa161=sfa161+l_ActualQPA
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                           AND sfa27=sr[l_i].bmb03 #CHI-7B0034
                   ELSE
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                   END IF
               #NO.FUN-7B0018 08/02/25 add --begin
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_sfai.* TO NULL
                     LET l_sfai.sfai01 = g_wo
                     LET l_sfai.sfai03 = sr[l_i].bmb03
                     LET l_sfai.sfai08 = g_opseq
                     LET l_sfai.sfai12 = sr[l_i].bmb10
                     LET l_sfai.sfai27 = sr[l_i].bmb03 #CHI-7B0034
                     LET l_sfai.sfai012 = ' '          #FUN-A60076
                     LET l_sfai.sfai013 = 0            #FUN-A60076
                     LET l_flag = s_ins_sfai(l_sfai.*,'')
                  END IF
               #NO.FUN-7B0018 08/02/25 add --end
               END IF
             END IF
###### 
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
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
     END IF
       
END FUNCTION

#FUN-A50066--begin--add--------------------
FUNCTION cralc_brb_bom2(p_level,p_key,p_key2,p_total,p_QPA,p_ecm03_par,p_ecm11,p_ecm03,p_ecm012)  
DEFINE
    p_level        LIKE type_file.num5,
    p_total        LIKE oeb_file.oeb12,
    p_QPA          LIKE brb_file.brb06,
    l_QPA          LIKE brb_file.brb06,
    l_total        LIKE oeb_file.oeb12,
    l_total2       LIKE oeb_file.oeb12,
    p_key          LIKE bra_file.bra01,
    p_key2         LIKE ima_file.ima910,
    l_ac,l_i,l_x   LIKE type_file.num5,
    arrno          LIKE type_file.num5,
    b_seq,l_double LIKE type_file.num10, 
    sr ARRAY[500] OF RECORD  #array for storage
        brb02      LIKE brb_file.brb02, #SEQ
        brb03      LIKE brb_file.brb03, #component part number
        brb10      LIKE brb_file.brb10, #Issuing UOM
        brb10_fac  LIKE brb_file.brb10_fac,#Issuing UOM to stock transfer rate
        brb10_fac2 LIKE brb_file.brb10_fac2,#Issuing UOM to cost transfer rate
        brb15      LIKE brb_file.brb15, #consumable part flag
        brb16      LIKE brb_file.brb16, #substitable flag
        brb31      LIKE brb_file.brb31, 
        brb06      LIKE brb_file.brb06, #QPA
        brb08      LIKE brb_file.brb08, #yield
        brb081      LIKE brb_file.brb081,
        brb082      LIKE brb_file.brb082,    
        brb09      LIKE brb_file.brb09, #operation sequence number
        brb18      LIKE brb_file.brb18, #days offset
        brb28      LIKE brb_file.brb28, #
        ima08      LIKE ima_file.ima08, #source code
        ima37      LIKE ima_file.ima37, #OPC
        ima25      LIKE ima_file.ima25, #UOM
        ima86      LIKE ima_file.ima86, #COST UNIT
        ima86_fac  LIKE ima_file.ima86_fac, #
        bra01      LIKE bra_file.bra01  
       ,bra05      LIKE bra_file.bra05, 
        brb19      LIKE brb_file.brb19, 
        brb14      LIKE brb_file.brb14,
        brb29      LIKE brb_file.brb29,
        brb011     LIKE brb_file.brb011,
        brb012     LIKE brb_file.brb012,
        brb013     LIKE brb_file.brb013  
    END RECORD,
    g_sfa RECORD   LIKE sfa_file.*,    #備料檔
    l_ima08        LIKE ima_file.ima08, #source code
    l_avl_stk_mpsmrp       LIKE type_file.num15_3, 
    l_SafetyStock  LIKE ima_file.ima27,
    l_SSqty        LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37,  #OPC
    l_ima64        LIKE ima_file.ima64,  #Issue Pansize
    l_ima641       LIKE ima_file.ima641, #Minimum Issue QTY
    l_uom          LIKE ima_file.ima25,  #Stock UOM
    l_chr          LIKE type_file.chr1,  #No.FUN-680147 VARCHAR(1)
    l_sfa07        LIKE sfa_file.sfa07,  #quantity owed
    l_sfa03        LIKE sfa_file.sfa03,  #part No
    l_sfa11        LIKE sfa_file.sfa11,  #consumable flag
    l_qty          LIKE type_file.num15_3, #issuing to stock qty 
    l_bal          LIKE type_file.num15_3, #balance (QOH-issue) 
    l_ActualQPA    LIKE brb_file.brb06,  
    l_sfa12        LIKE sfa_file.sfa12,    #發料單位
    l_sfa13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c      LIKE type_file.num5,
    l_cmd          LIKE type_file.chr1000 
DEFINE l_sfai      RECORD LIKE sfai_file.* 
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_bof06_1   LIKE brb_file.brb08 
DEFINE l_bof06_2   LIKE brb_file.brb08 
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910 
DEFINE l_bml04     LIKE bml_file.bml04     #廠商
DEFINE l_sfa11_a   LIKE sfa_file.sfa11 
DEFINE p_ecm03_par LIKE ecm_file.ecm03_par
DEFINE p_ecm11     LIKE ecm_file.ecm11
DEFINE p_ecm012    LIKE ecm_file.ecm012
DEFINE p_ecm03     LIKE ecm_file.ecm03

    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            "SELECT brb02,brb03,brb10,brb10_fac,brb10_fac2,",
            "brb15,brb16,brb31,brb06/brb07,brb08,brb081,brb082,brb09,brb18,brb28,ima08,ima37,",  
            " ima25,ima86,ima86_fac,bra01,bra05,brb19,brb14,brb29,brb011,brb012,brb013", 
            " FROM brb_file,OUTER ima_file,OUTER bra_file ",
            " WHERE brb01='", p_key,"'"," AND brb02>? ",  
            "   AND brb29 ='",p_key2,"' ", 
            "   AND brb29 = bra_file.bra06 ",                                                                                              
            "   AND brb03 = bra_file.bra01 ",                                                                         
            "   AND brb03 = ima_file.ima01 ", 
            "   AND brb011= bra_file.bra011 ",
            "   AND brb012= bra_file.bra012 ",
            "   AND brb013= bra_file.bra013 ",
            "   AND brb011 = '",p_ecm11,"'",
            "   AND brb012 = '",p_ecm012,"'",
            "   AND brb013 = ",p_ecm03,
            "   AND bra_file.braacti = 'Y' ", 
            "   AND (brb04 <='",g_date,
            "' OR brb04 IS NULL) AND (brb05 >'",g_date,
            "' OR brb05 IS NULL)",
            " AND ",g_cw CLIPPED,
            " ORDER BY 1"
        PREPARE cralc_ppp1 FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('cralc_ppp1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur1 CURSOR FOR cralc_ppp1
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur1 USING b_seq INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].brb03 CLIPPED
            IF sr[l_ac].brb19 <> '1' THEN
             IF cl_null(sr[l_ac].bra05) OR 
                (NOT cl_null(sr[l_ac].bra05)  AND sr[l_ac].bra05 > g_date) THEN
                CALL cl_err(sr[l_ac].brb03,'abm-005',1)
                EXIT FOREACH
             END IF
            END IF
            #若換算率有問題, 則設為1
            IF sr[l_ac].brb10_fac IS NULL OR sr[l_ac].brb10_fac=0 THEN
                LET sr[l_ac].brb10_fac=1
            END IF
            DECLARE i301_bmb16_c CURSOR FOR
               SELECT bmb16 FROM bmb_file        
                WHERE bmb01=p_key
                  AND bmb29=sr[l_ac].brb29  
                  AND bmb03=sr[l_ac].brb03
                  AND (bmb04<=g_date OR bmb04 IS NULL)
                  AND (g_date<bmb05 OR bmb05 IS NULL)
                  
               FOREACH i301_bmb16_c INTO sr[l_ac].brb16
                 IF sr[l_ac].brb16 IS NULL THEN    #若未定義, 則給予'正常'
                    LET sr[l_ac].brb16='0'
                 END IF
                 EXIT FOREACH
               END FOREACH                                                                                             
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].brb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #operation sequence number
            IF sr[l_i].brb09 IS NOT NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].brb09
                LET g_offset=sr[l_i].brb18
            END IF
            #無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
 
            LET g_SOUCode='0'
            IF sr[l_i].brb16='2' THEN
                LET g_SOUCode=g_sma.sma67
            ELSE
                IF sr[l_i].brb16='1' THEN        #UTE
                    LET g_SOUCode=g_sma.sma66    #保留安全庫存, 以備不時之需
                END IF
            END IF
            CALL cralc_rate(p_key,sr[l_i].brb03,p_total,sr[l_i].brb081,sr[l_i].brb08,sr[l_i].brb082,sr[l_i].brb06,p_QPA) 
            RETURNING l_total,l_QPA,l_ActualQPA               
            LET l_total2=l_total          
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
                LET l_sfa11='R'
            ELSE
                IF sr[l_i].brb15='Y' THEN #comsumable
                    LET l_sfa11='E'
                ELSE 
                    IF sr[l_i].ima08 MATCHES '[UV]' THEN
                        LET l_sfa11=sr[l_i].ima08
                    END IF
                END IF #consumable
            END IF
            IF sr[l_i].brb14 = '1' THEN 
               LET l_sfa11 = 'X' 
            END IF 
            IF sr[l_i].brb14 = '2' THEN 
               LET l_sfa11 = 'S'
            END IF
            IF sr[l_i].brb14 = '3' THEN
               LET l_sfa11 = 'C' 
            END IF 
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
                LET sr[l_i].brb10=sr[l_i].ima25
                LET l_total=l_total*sr[l_i].brb10_fac    #原發
                LET l_total2=l_total2*sr[l_i].brb10_fac    #應發
                LET sr[l_i].brb10_fac=1
            END IF
                                                           
            DECLARE bml_cur1 CURSOR FOR                                          
            SELECT bml04 FROM bml_file                                          
             WHERE bml01=sr[l_i].brb03                                          
               AND (bml02=p_key OR bml02='ALL')                                 
            ORDER BY bml03    
            FOREACH bml_cur1 INTO l_bml04 
              EXIT FOREACH
            END FOREACH 
 
 
               IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
               LET g_ccc=g_ccc+1
               LET l_uuc=0
               CASE WHEN sr[l_i].brb16 = '0' LET sr[l_i].brb16 = '0' 
                    WHEN sr[l_i].brb16 = '1' LET sr[l_i].brb16 = '1' 
                    WHEN sr[l_i].brb16 = '2' LET sr[l_i].brb16 = '1' 
               END CASE
               IF sr[l_i].brb16 !='0'  THEN  #表有取替代的情況
                  LET l_QPA=0
                  LET l_ActualQPA=0
               END IF 
               INITIALIZE g_sfa.* TO NULL           
               LET g_sfa.sfa01  = g_wo
               LET g_sfa.sfa02  = g_wotype
               LET g_sfa.sfa03  = sr[l_i].brb03
               LET g_sfa.sfa04  = l_total
               LET g_sfa.sfa05  = l_total2
               LET g_sfa.sfa06  = 0
               LET g_sfa.sfa061 = 0
               LET g_sfa.sfa062 = 0
               LET g_sfa.sfa063 = 0
               LET g_sfa.sfa064 = 0
               LET g_sfa.sfa065 = 0
               LET g_sfa.sfa066 = 0
               LET g_sfa.sfa08  = g_opseq
               LET g_sfa.sfa09  = g_offset 
               LET g_sfa.sfa10  = ' '
               LET g_sfa.sfa11  = l_sfa11
               LET g_sfa.sfa12  = sr[l_i].brb10
               LET g_sfa.sfa13  = sr[l_i].brb10_fac
               LET g_sfa.sfa14  = sr[l_i].ima86
               LET g_sfa.sfa15  = sr[l_i].brb10_fac2
               LET g_sfa.sfa16  = l_QPA
               LET g_sfa.sfa161 = l_ActualQPA
               LET g_sfa.sfa25  = l_uuc
               LET g_sfa.sfa26  = sr[l_i].brb16
               LET g_sfa.sfa27  = sr[l_i].brb03
               LET g_sfa.sfa28  = 1
               LET g_sfa.sfa100 = sr[l_i].brb28
               LET g_sfa.sfaacti= 'Y'
               LET g_sfa.sfa32  = sr[l_i].brb31
               LET g_sfa.sfa36  = l_bml04  
               LET g_sfa.sfa012=sr[l_i].brb012
               LET g_sfa.sfa013=sr[l_i].brb013
               LET g_sfa.sfaplant  = g_plant  
               LET g_sfa.sfalegal  = g_legal  
               IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF  
               IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF         

#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
               LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)   #FUN-BB0085
               LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)   #FUN-BB0085

               IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  
               INSERT INTO sfa_file VALUES(g_sfa.*)
               IF SQLCA.SQLCODE THEN    #Duplicate
                   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                       #因為相同的料件可能有不同的發料單位, 故宜換算之
                       SELECT sfa13 INTO l_sfa13
                           FROM sfa_file
                           WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                               AND sfa08=g_opseq
                               AND sfa27=sr[l_i].brb03 
                               AND sfa012=g_sfa.sfa012
                               AND sfa013=g_sfa.sfa013
                       LET l_sfa13=sr[l_i].brb10_fac/l_sfa13
                       LET l_total=l_total*l_sfa13
                       LET l_total2=l_total2*l_sfa13
                       LET l_total=s_digqty(l_total,sr[l_i].brb10)           #FUN-BB0085
                       LET l_total2=s_digqty(l_total2,sr[l_i].brb10)         #FUN-BB0085
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file 
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].brb10
                           AND sfa27=sr[l_i].brb03
                           AND sfa012=g_sfa.sfa012
                           AND sfa013=g_sfa.sfa013
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET l_ActualQPA = 0 END IF 
                       UPDATE sfa_file
                           SET sfa04=sfa04+l_total,
                               sfa05=sfa05+l_total2,
                               sfa16=sfa16+sr[l_i].brb06,
                               sfa161=sfa161+l_ActualQPA
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].brb10
                           AND sfa27=sr[l_i].brb03
                           AND sfa012=g_sfa.sfa012
                           AND sfa013=g_sfa.sfa013
                   ELSE
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                   END IF
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_sfai.* TO NULL
                     LET l_sfai.sfai01 = g_wo
                     LET l_sfai.sfai03 = sr[l_i].brb03
                     LET l_sfai.sfai08 = g_opseq
                     LET l_sfai.sfai12 = sr[l_i].brb10
                     LET l_sfai.sfai27 = sr[l_i].brb03 
                     LET l_sfai.sfai012= g_sfa.sfa012 
                     LET l_sfai.sfai013= g_sfa.sfa013
                     LET l_flag = s_ins_sfai(l_sfai.*,'')
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
            LET b_seq = sr[l_x].brb02
        END IF
    END WHILE
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
     END IF
       
END FUNCTION
#FUN-A50066--end--add----------------
