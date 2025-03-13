# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: s_cralc5.4gl
# Descriptions...: 產生產品備料資料(服飾程式專用)
# Date & Author..: 08/06/02 By ve007     #No.FUN-870117
# Usage..........: CALL s_cralc5(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,
#                               p_yld,p_lvl,p_minopseq,p_altno,p_bmb09)
#                       RETURNING l_cnt
# Input Parameter: p_wo        工單編號
#                  p_wotype    工單型態
#                  p_part      料件編號
#                  p_btflg     是否展開下階(sma29)
#                  p_woq       工單數量
#                  p_date      有效日期
#                  p_mps       MPS料件是否展開
#                  p_yld       損耗率
#                  p_lvl       展開階數       
#                  p_minopseq  最小序號
#                  p_altno     特性代碼
#                  p_bmb09     作業編號 
# Return code....: l_cnt       備料筆數
# Modify ........: No.MOD-880016 08/08/04 by ve007
# Modify ........: No.FUN-870117 08/09/28 by ve007 發料數量考慮分量損耗率
# Modify.........: No.TQC-8B0009 08/11/05 By Carrier 分量損耗率功能檢查及sma71位置檢查
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-8C0148 08/12/16 By chenyu ima910沒有維護時，還是用sfb95
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940008 09/05/18 By hongmei發料改善
# Modify.........: No.CHI-950037 09/06/12 By jan 在工單開立，產生備料時，需排除bmb14='不發料
# Modify.........: No.FUN-950088 09/07/01 By hongmei 將bml04帶到sfa36廠牌中
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-9A0083 09/10/26 By liuxqa ROWID的修改。
# Modify.........: No.CHI-980013 09/11/02 By jan 當bmb14='1'時,也要產生備料
# Modify.........: No:FUN-9C0040 10/01/28 By jan,當BOM單身性質為"回收料"時,產生工單備料時，"實際QPA"和"應發數量"為負值。
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No.MOD-A30166 10/03/23 By destiy 订单选配时,订单转工单作业,QPA应抓取选配的QPA(oeo06)
# Modify.........: No.FUN-A20044 10/03/24 By JIACHENCHAO 更改关于字段ima26*的相关语句
# Modify.........: No:MOD-A40061 10/04/13 By Sarah "扣除其他工單備料量"的計算忘了乘轉換率
# Modify.........: No.FUN-A30093 10/04/15 By jan bmb14='3'時，產生工單備料時,sfa11為'C'
# Modify.........: No:FUN-A30003 10/04/16 By destiy 修改工单备料时损耗计算方法 
# Modify.........: No:MOD-A40136 10/04/22 By Sarah cralc5_sou()在判斷庫存量夠不夠時,忘了乘單位換算率
# Modify.........: No:TQC-A50052 10/05/17 By destiy 损耗率分量汇总计算时，实际QPA计算有误
# Modify.........: No:MOD-A50131 10/05/24 By liuxqa cralc5_sou()在計算應發數量時，沒有考慮最小發料量和最小發料倍數.
# Modify.........: No:FUN-A60031 10/06/17 By destiy 重新计算损耗率
# Modify.........: No:FUN-A50066 10/06/18 By jan 新增依製程BOM展工單的處理
# Modify.........: No:FUN-A60086 10/06/25 By destiy 重新计算损耗率
# Modify.........: No.FUN-A60080 10/07/08 By destiny 重新计算损耗率  
# Modify.........: No:MOD-A80161 10/08/23 By sabrina 下階料的特性代碼應串料件主檔的主特性代碼(ima910)
#                                                    應由bmb01串bma01和ima01
# Modify.........: No:TQC-A80180 10/08/31 By destiny 参数设定为并行工艺，但工单不走工艺时应从abmi600中抓取bom资料
# Modify.........: No:FUN-AC0104 10/12/27 By destiny 損耗量計算公式調整
# Modify.........: No:FUN-B60142 11/07/04 By jan 損耗量計算公式調整(增加sam1411參數)
# Modify.........: No:TQC-B80104 11/08/17 By houlia 增加bmaacti控管 
# Modify.........: No:TQC-BB0174 11/11/18 By lilingyu 原發數量sfa04,應發數量sfa05可能出現NULL值，導致無法產生備料
# Modify.........: No:TQC-BB0186 11/11/21 By lixiang 對空值進行控管和賦值
# Modify.........: No.FUN-BB0085 11/12/12 By xianghui 增加數量欄位小數取位
# Modify.........: No:CHI-B90027 13/01/22 By Alberti 展備料時若此元件是尾階則不需詢問是否要展開工單

DATABASE ds
 
GLOBALS "../../config/top.global"    
DEFINE
    g_sfa        RECORD LIKE sfa_file.*,
    g_sfb        RECORD LIKE sfb_file.*,
    g_opseq      LIKE sfa_file.sfa08, #operation sequence number
    g_offset     LIKE sfa_file.sfa09, #offset
    g_ima55      LIKE ima_file.ima55,
    g_ima55_fac  LIKE ima_file.ima55_fac,
    g_ima86      LIKE ima_file.ima86,
    g_ima86_fac  LIKE ima_file.ima86_fac,
    g_wo         LIKE sfa_file.sfa01,          #No.FUN-680147 VARCHAR(16) #No.FUN-560002   r
    g_wotype     LIKE type_file.num5,          #No.FUN-680147 SMALLINT #work order type
    g_level      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    g_ccc        LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    g_SOUCode    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_mps        LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_yld        LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_minopseq   LIKE ecb_file.ecb03,
    g_factor     LIKE bmb_file.bmb06,          #No.FUN-680147 DEC(16,8)         #   top40
    g_date       LIKE type_file.dat,           #No.FUN-680147 DATE
    g_fs_insert  LIKE type_file.chr1,          #No.MOD-7B0075 add
    g_btflg      LIKE type_file.chr1 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680147 SMALLINT
DEFINE   g_status        LIKE type_file.num5   #No.FUN-680147 SMALLINT
FUNCTION s_cralc5(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
                 p_minopseq,p_altno,p_bmb09)   #No.TQC-610003
DEFINE
    p_wo         LIKE sfa_file.sfa01,          #No.FUN-680147 VARCHAR(16) #No.FUN-560002 
    p_wotype     LIKE type_file.num5,          #No.FUN-680147 SMALLINT #work order type
    p_part       LIKE ima_file.ima01,          #part number #No.MOD-490217
    p_btflg      LIKE type_file.chr1,
    p_woq        LIKE sfa_file.sfa04,          #No.FUN-680147 DECIMAL(11,3) #work order quantity
    p_date       LIKE type_file.dat,           #No.FUN-680147 DATE #effective date
    p_mps        LIKE type_file.chr1,
    p_yld        LIKE sma_file.sma71,
    p_minopseq   LIKE ecb_file.ecb03,
    p_altno      LIKE bma_file.bma06,          #No.TQC-610003
    p_bmb09      LIKE bmb_file.bmb09, 
    l_ima562     LIKE ima_file.ima562
   DEFINE l_ima910   LIKE ima_file.ima910      #FUN-550112
   DEFINE l_ecm03_par  LIKE ecm_file.ecm03_par  #FUN-A50066
   DEFINE l_ecm11    LIKE ecm_file.ecm11        #FUN-A50066
   DEFINE l_ecm03    LIKE ecm_file.ecm03        #FUN-A50066
   DEFINE l_ecm012   LIKE ecm_file.ecm012       #FUN-A50066
   DEFINE l_n        LIKE type_file.num5        #NO.TQC-A80180  
    WHENEVER ERROR CALL cl_err_msg_log
    MESSAGE ' Allocating ' ATTRIBUTE(REVERSE)
    LET g_ccc=0
    LET g_date=p_date
    LET g_btflg=p_btflg
    LET g_wo=p_wo
    LET g_wotype=p_wotype
    LET g_opseq=' '
    LET g_offset=0
    LET g_mps=p_mps
    LET g_yld=p_yld
    LET g_errno=' '
    LET g_minopseq=p_minopseq
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wo
    IF STATUS THEN 
       #CALL cl_err('sel sfb:',STATUS,1)  #FUN-670091
       CALL cl_err3("sel","gsb_file",p_wo,"",STATUS,"","",1) #FUN-670091
       RETURN 0 
    END IF
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
    IF p_wotype=5 OR p_wotype=11 OR p_wotype=8 THEN    #rework order or de-assembly order NO:7075 add p_wotype=8
        CALL cralc5_rd(p_part,p_woq)                   
    ELSE
        IF g_sma.sma542 = 'Y' AND g_sfb.sfb93 = 'Y' THEN
           DECLARE ecm_cur CURSOR FOR
            SELECT distinct ecm03_par,ecm11,ecm03,ecm012 FROM ecm_file
             WHERE ecm01=g_sfb.sfb01 
               ORDER BY ecm03_par,ecm11,ecm012,ecm03
           FOREACH ecm_cur INTO l_ecm03_par,l_ecm11,l_ecm03,l_ecm012
                   CALL cralc5_brb_bom(0,p_part,p_altno,p_woq,1,p_bmb09,l_ecm03_par,l_ecm11,l_ecm03,l_ecm012)
           END FOREACH
           #NO.TQC-A80180--begin
           SELECT COUNT(*) INTO l_n FROM sfa_file WHERE sfa01=g_sfb.sfb01
           IF l_n=0 THEN 
              CALL cralc5_bom(0,p_part,p_altno,p_woq,1,p_bmb09) 
           END IF  
           #NO.TQC-A80180--end
        ELSE
        #FUN-A50066--end--add--------------------------
           CALL cralc5_bom(0,p_part,p_altno,p_woq,1,p_bmb09) #FUN-550112  #由BOM產生備料檔  #No.TQC-610003
        END IF  #FUN-A50066
      ###--mark in 99/10/05 for tiptop4.0
      # CALL cralc5_sss()				#把多餘資料刪除
        CALL cralc5_oeo(p_part,p_woq)			#由S/O配件產生備料檔
    END IF
    IF g_ccc=0
       THEN LET g_errno='asf-014' 			#有BOM但無有效者
       ELSE UPDATE sfb_file SET sfb23='Y' WHERE sfb01=p_wo
    END IF
    
    MESSAGE ""
    RETURN g_ccc
END FUNCTION
 
#   2. 工單型態為再加工工單(5) 及拆件式工單(11)者, 其備料的料件為再加工
#      / 拆件料件本身的料件, 其產品結構不展開, 損耗率不計算
FUNCTION cralc5_rd(p_part,p_woq)
DEFINE p_part LIKE ima_file.ima01     #work order part
DEFINE p_woq  LIKE sfa_file.sfa04     #No.FUN-680147 DECIMAL(11,3)  #work order quantity
DEFINE l_sfai RECORD LIKE sfai_file.* #No.FUN-7B0018
DEFINE l_flag LIKE type_file.chr1     #No.FUN-7B0018
 
    IF cl_null(g_offset) THEN LET g_offset = 0 END IF
    IF cl_null(g_opseq)  THEN LET g_opseq  = ' ' END IF
    INITIALIZE g_sfa.* TO NULL
    LET g_sfa.sfa01 =g_wo
    LET g_sfa.sfa02 =g_wotype
    LET g_sfa.sfa03 =p_part
    LET g_sfa.sfa04 =p_woq
    LET g_sfa.sfa05 =p_woq
    LET g_sfa.sfa06 =0
    LET g_sfa.sfa061=0
    LET g_sfa.sfa062=0
    LET g_sfa.sfa063=0
    LET g_sfa.sfa064=0
    LET g_sfa.sfa065=0
    LET g_sfa.sfa066=0
#   LET g_sfa.sfa07 =0    #FUN-940008 mark
    LET g_sfa.sfa08 =g_opseq
    IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
    LET g_sfa.sfa09 =g_offset
    LET g_sfa.sfa11 ='N'
    LET g_sfa.sfa12 =g_ima55
    LET g_sfa.sfa13 =g_ima55_fac
    LET g_sfa.sfa14 =g_ima86
    LET g_sfa.sfa15 =g_ima86_fac
    LET g_sfa.sfa16 =1
    LET g_sfa.sfa161=1
    LET g_sfa.sfa25 =p_woq
    LET g_sfa.sfa26 ='0'
    LET g_sfa.sfa27 =p_part
    LET g_sfa.sfa28 =1
    LET g_sfa.sfa29 =p_part
    LET g_sfa.sfaacti ='Y'
    IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF  #FUN-A50066
    IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF  #FUN-A50066
 
    LET g_sfa.sfaplant=g_plant  #FUN-980012 add
    LET g_sfa.sfalegal=g_legal  #FUN-980012 add
 
    # No.+114 Tommy
    IF cl_null(g_sfa.sfa100) THEN
       LET g_sfa.sfa100 = 0 
    END IF
    # End Tommy

#TQC-BB0174 --begin--
    IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
    IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
    LET g_sfa.sfa04 =s_digqty(g_sfa.sfa04,g_sfa.sfa12)     #FUN-BB0085
    LET g_sfa.sfa05 =s_digqty(g_sfa.sfa05,g_sfa.sfa12)     #FUN-BB0085
    LET g_sfa.sfa25 =s_digqty(g_sfa.sfa25,g_sfa.sfa12)     #FUN-BB0085

    LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494
    INSERT INTO sfa_file VALUES(g_sfa.*)
    IF STATUS THEN 
       #CALL cl_err('ins sfa(1):',STATUS,1)   #FUN-670091
        CALL cl_err3("ins","sfa_file","","",STATUS,"","",1)  #FUN-670091
    #NO.FUN-7B0018 08/02/20 add --begin
    ELSE
      
          INITIALIZE l_sfai.* TO NULL
          LET l_sfai.sfai01 = g_sfa.sfa01
          LET l_sfai.sfai03 = g_sfa.sfa03
          LET l_sfai.sfai08 = g_sfa.sfa08
          LET l_sfai.sfai12 = g_sfa.sfa12
          LET l_sfai.sfai27 = g_sfa.sfa27      #No.FUN-870117
          LET l_sfai.sfai012= g_sfa.sfa012     #FUN-A50066
          LET l_sfai.sfai013= g_sfa.sfa013     #FUN-A50066     
          LET l_flag = s_ins_sfai(l_sfai.*,'')
     
    END IF
    #NO.FUN-7B0018 08/02/20 add --end
 
   # UPDATE ima_file set ima102 = ima102 + p_woq * g_ima55_fac
   #  WHERE ima01 = p_part 
    LET g_ccc=1
END FUNCTION
 
FUNCTION cralc5_bom(p_level,p_key,p_key2,p_total,p_QPA,p_bmb09)  #FUN-550112
DEFINE
    p_level        LIKE type_file.num5,          #No.FUN-680147 SMALLINT #level code
    p_total        LIKE bmb_file.bmb06,          #No.FUN-680147 DECIMAL(13,5)
    p_QPA          LIKE bmb_file.bmb06,  #FUN-560230
    l_QPA          LIKE bmb_file.bmb06,  #FUN-560230
    l_total        LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #原發數量
    l_total2       LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #應發數量
    p_key          LIKE bma_file.bma01,  #assembly part number
    p_bmb09        LIKE bmb_file.bmb09,         
    p_key2	   LIKE ima_file.ima910,   #FUN-550112
    l_ac,l_i,l_x,l_s LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    arrno          LIKE type_file.num5,          #No.FUN-680147 SMALLINT #BUFFER SIZE
    b_seq,l_double LIKE type_file.num10,         #No.FUN-680147 INTEGER #restart sequence (line number)
    sr ARRAY[500] OF RECORD  #array for storage
       bmb02       LIKE bmb_file.bmb02, #SEQ
       bmb03       LIKE bmb_file.bmb03, #component part number
       bmb10       LIKE bmb_file.bmb10, #Issuing UOM
       bmb10_fac   LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
       bmb10_fac2  LIKE bmb_file.bmb10_fac2,#Issuing UOM to cost transfer rate
       bmb15       LIKE bmb_file.bmb15, #consumable part flag
       bmb16       LIKE bmb_file.bmb16, #substitable flag
       bmb06       LIKE bmb_file.bmb06, #QPA
       bmb08       LIKE bmb_file.bmb08, #yield
       bmb081      LIKE bmb_file.bmb081,#No.FUN-A60031
       bmb082      LIKE bmb_file.bmb082,#No.FUN-A60031       
       bmb09       LIKE bmb_file.bmb09, #operation sequence number
       bmb18       LIKE bmb_file.bmb18, #days offset
       bmb19       LIKE bmb_file.bmb19, #1.不展開 2.不展開但自動開立工單 3.展開:top40
       bmb28       LIKE bmb_file.bmb28, #允許發料誤差
       bmb25       LIKE bmb_file.bmb25, #倉庫      #No.MOD-780059 add     
       bmb26       LIKE bmb_file.bmb26, #儲位      #No.MOD-780059 add     
       bmb14       LIKE bmb_file.bmb14, #CHI-980013
       ima08       LIKE ima_file.ima08, #source code
       ima37       LIKE ima_file.ima37, #OPC
       ima25       LIKE ima_file.ima25, #UOM
       ima55       LIKE ima_file.ima55, #生產單位
       ima86       LIKE ima_file.ima86, #COST UNIT
       ima86_fac   LIKE ima_file.ima86_fac, #
       bmb07       LIKE bmb_file.bmb07, #底數   #bugno:6513 add
       bmb31       LIKe bmb_file.bmb31,    #No.MOD-840433 addyy
        bma01       LIKE bma_file.bma01 #No.MOD-490217 
                   END RECORD,
    g_sfa RECORD  LIKE sfa_file.*,    #備料檔
    l_ima02        LIKE ima_file.ima02,
    l_ima08        LIKE ima_file.ima08, #source code
#    l_ima26        LIKE ima_file.ima26, #QOH #FUN-A20044
    l_avl_stk_mpsmrp        LIKE type_file.num15_3, #FUN-A20044
#    l_ima262       LIKE ima_file.ima262, #QOH #FUN-A20044
    l_avl_stk       LIKE type_file.num15_3, #FUN-A20044
    l_unavl_stk    LIKE type_file.num15_3, #FUN-A20044
    l_SafetyStock  LIKE ima_file.ima27,
    l_SSqty        LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37, #OPC
    l_ima108       LIKE ima_file.ima108,
    l_ima64        LIKE ima_file.ima64,    #Issue Pansize
    l_ima641       LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom          LIKE ima_file.ima25,        #Stock UOM
    l_chr          LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_sfa07        LIKE sfa_file.sfa07, #quantity owed
    l_sfa03        LIKE sfa_file.sfa03, #part No
    l_sfa11        LIKE sfa_file.sfa11, #consumable flag
#    l_qty          LIKE ima_file.ima26, #issuing to stock qty #FUN-A20044
    l_qty          LIKE type_file.num15_3, #FUN-A20044
    l_sfaqty       LIKE sfa_file.sfa05,
    l_gfe03        LIKE gfe_file.gfe03, 
#    l_bal          LIKE ima_file.ima26, #balance (QOH-issue) #FUN-A20044
    l_bal          LIKE type_file.num15_3, #balance (QOH-issue) #FUN-A20044
    l_ActualQPA    LIKE bmb_file.bmb06,  #FUN-560230
    l_bmb06        LIKE bmb_file.bmb06,  #FUN-560230
    l_sfa12        LIKE sfa_file.sfa12,    #發料單位
    l_sfa13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bml04        LIKE bml_file.bml04,    #指定廠商
    fs_insert      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_fs_insert    LIKE type_file.chr1,          #No.MOD-830161 add
    l_t_fs_insert    LIKE type_file.chr1,          #No.MOD-830161 add
    g_sw           LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_cmd          LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
DEFINE l_sfai      RECORD LIKE sfai_file.*       #No.FUN-7B0018
DEFINE l_flag      LIKE type_file.chr1           #No.FUN-7B0018
DEFINE l_bof06_1   LIKE bof_file.bof06           #No.FUN-870117
DEFINE l_bof06_2   LIKE bof_file.bof06           #No.FUN-870117
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
#DEFINE l_rowid     LIKE type_file.chr18   #No.FUN-9A0083 mark 
DEFINE l_sfa11_a   LIKE sfa_file.sfa11           #CHI-980013
DEFINE l_bmaacti   LIKE bma_file.bmaacti   #TQC-B80104 add

    LET p_level = p_level + 1
    LET arrno = 500
    IF cl_null(p_bmb09) THEN 
        LET l_cmd=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
#           "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,",   #top40
#bugno:6513 "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,bmb28,",   #top40
            "bmb15,bmb16,bmb06,bmb08,bmb081,bmb082,bmb09,bmb18,bmb19,bmb28,",   #top40   #No.FUN-A60031
            "bmb25,bmb26,bmb14,",             #No.MOD-780059 add  #CHI-980013 add bmb14
            "ima08,ima37,ima25,ima55,",                           #top40
           #MOD-A80161---modify---start---
           #" ima86,ima86_fac,bmb07,bmb31,bma01",  #bugno:6513 add bmb07   #No.MOD-840433 add bmb31
           #" FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 LEFT OUTER JOIN bma_file ON bmb03 = bma01 AND bma_file.bmaacti='Y' ",  #NO.FUN-9A0083 mod 
            " ima86,ima86_fac,bmb07,bmb31,''",  
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 ", 
           #MOD-A80161---modify---end---
            " WHERE bmb01='", p_key,"' AND bmb02>?",
            "   AND bmb29 ='",p_key2,"' ",   #FUN-550112
           #"   AND bmb29 = bma_file.bma06", #CHI-740019  #MOD-A80161 mark
            #" AND bmb03 = bma_file.bma01",    #No.FUN-9A0083 mark
            #" AND bmb03 = ima_file.ima01",
           #" AND bmb14 != '1'",  #CHI-950037  #CHI-980013
            #" AND bma_file.bmaacti = 'Y'", #CHI-740001  #No.TQC-7A0067 modify  #No.FUN-9A0083 mark
            " AND (bmb04 <='",g_date,
            "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
            "' OR bmb05 IS NULL)",
            " ORDER BY 1"
     ELSE   
     	LET l_cmd=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
#           "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,",   #top40
#bugno:6513 "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,bmb19,bmb28,",   #top40
            "bmb15,bmb16,bmb06,bmb08,bmb081,bmb082,bmb09,bmb18,bmb19,bmb28,",   #top40  #No.FUN-A60031
            "bmb25,bmb26,bmb14,",             #No.MOD-780059 add #CHI-980013 add bmb14
            "ima08,ima37,ima25,ima55,",                           #top40
           #MOD-A80161---modify---start---
           #" ima86,ima86_fac,bmb07,bmb31,bma01",  #bugno:6513 add bmb07   #No.MOD-840433 add bmb31
           #" FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03=ima01 LEFT OUTER JOIN bma_file ON bmb03 = bma01 AND bma_file.bmaacti='Y' ", #NO.FUN-9A0083 mod
            " ima86,ima86_fac,bmb07,bmb31,''",  
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03=ima01 ",
           #MOD-A80161---modify---end--- 
            " WHERE bmb01='", p_key,"' AND bmb02>?",
            "   AND bmb29 ='",p_key2,"' ",   #FUN-550112
           #"   AND bmb29 = bma_file.bma06", #CHI-740019  #MOD-A80161 mark
            #" AND bmb03 = bma_file.bma01",    #FUN-9A0083 
            #" AND bmb03 = ima_file.ima01",
            #" AND bmb14 != '1'",  #CHI-950037 	#CHI-980013
            #" AND bma_file.bmaacti = 'Y'", #CHI-740001  #No.TQC-7A0067 modify FUN-9A0083 mark
            " AND (bmb04 <='",g_date,
            "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
            "' OR bmb05 IS NULL)",     
            " AND bmb09 = '",p_bmb09,"'", 
            " ORDER BY 1"
        END IF     
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
            #TQC-B80104 --add
           LET l_bmaacti=''
            SELECT bmaacti INTO l_bmaacti FROM bma_file
             WHERE bma01 = p_key
               AND bma06 = p_key2
            IF l_bmaacti = 'N' THEN CONTINUE FOREACH END IF
            #TQC-B80104  --end
            #FUN-8B0015--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           IF l_ima910[l_ac]=' ' THEN LET l_ima910[l_ac]=p_key2 END IF  #No.MOD-8C0148 add
          #MOD-A80161---add---start---
           SELECT bma01 INTO sr[l_ac].bma01
             FROM bma_file
            WHERE bma01=sr[l_ac].bmb03
              AND bma06=l_ima910[l_ac]
          #MOD-A80161---add---end---
           #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
        #MOD-7B0075---add---str---
        #若無下階料,工單展開選項為'3:展開'時的設定
        IF l_x = 0 THEN 
           #-------No.MOD-830161 modify
           #LET g_fs_insert = 'Y'
            LET l_fs_insert = 'Y'
           #-------No.MOD-830161 end
        END IF
       #---------No.MOD-830161 modify
        LET l_t_fs_insert = l_fs_insert
        LET g_fs_insert = l_fs_insert
       #---------No.MOD-830161 end
        #MOD-7B0075---add---end---
 
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
#bugno:6513 modify ......................................................
#            LET l_ActualQPA=(sr[l_i].bmb06*(1+sr[l_i].bmb08/100))*p_QPA
#            LET l_QPA=sr[l_i].bmb06 * p_QPA     ##94/12/06 Add 該行 Jackson
#            LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
            #No.FUN-870117 --begin--
            #No.FUN-A60031--begin--mark
#            LET l_bof06_1 = 0
#            LET l_bof06_2 = 0           
#            SELECT bof06 INTO l_bof06_1 FROM bof_file              
#                         #WHERE bof01 = g_sfb.sfb05                                #No.FUN-A30003                                                          
#                          WHERE bof01 = p_key                                      #No.FUN-A30003
#                           AND bof02 = '1'
#                           AND bof04 <= g_sfb.sfb08
#                           AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)
#                           AND bof03 = sr[l_i].bmb03
#               IF SQLCA.sqlcode =100 THEN 
#                  SELECT bof06 INTO l_bof06_1 FROM bof_file,imx_file   
#                         WHERE bof01 = imx00
#                           #AND imx000 = g_sfb.sfb05                                     #No.FUN-A30003
#                           AND imx000 = p_key                                            #No.FUN-A30003
#                           AND bof02 = '1'
#                           AND bof04 <= g_sfb.sfb08
#                           AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)
#                           AND bof03 = sr[l_i].bmb03 
#                   IF SQLCA.sqlcode =100 THEN 
#                     SELECT bof06 INTO l_bof06_1 FROM bof_file,imx_file    
#                           #WHERE bof01 =  g_sfb.sfb05                                      #No.FUN-A30003
#                           WHERE bof01 =  p_key                                             #No.FUN-A30003
#                             AND bof02 = '1'
#                             AND bof04 <= g_sfb.sfb08
#                             AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)
#                             AND bof03 = imx00
#                             AND imx000 = sr[l_i].bmb03 
#                     IF SQLCA.sqlcode =100 THEN 
#                       SELECT bof06 INTO l_bof06_1 FROM bof_file,imx_file     
#                             WHERE bof01 = imx00
#                              #AND imx000 = g_sfb.sfb05                                       #No.FUN-A30003
#                               AND imx000 = p_key                                             #No.FUN-A30003
#                               AND bof02 = '1'
#                               AND bof04 <= g_sfb.sfb08
#                               AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)
#                               AND bof03 = (SELECT imx00 FROM imx_file
#                               WHERE  imx000 = sr[l_i].bmb03 )
#                      END IF 
#                    END IF
#                 END IF                                           
#            IF l_bof06_1 >0 THEN 
#              LET sr[l_i].bmb08 = l_bof06_1                                                                                  #No.FUN-A30003 
#            END IF            
#
#            SELECT bof06 INTO l_bof06_2 FROM bof_file,ima_file               
#                          #WHERE bof01 = g_sfb.sfb05                                          #No.FUN-A30003
#                           WHERE bof01 = p_key             
#                            AND bof02 = '2'
#                            AND bof04 <= g_sfb.sfb08
#                            AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)
#                            AND bof03 = ima10
#                            AND ima01 = sr[l_i].bmb03
#            IF l_bof06_2 >0 THEN 
#              LET sr[l_i].bmb08 = l_bof06_2                             
#            END IF 
#            #No.FUN-870117 --end--
#            IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF  #No.TQC-8B0009
#            LET l_bmb06 = sr[l_i].bmb06 / sr[l_i].bmb07 
#            LET l_ActualQPA=(l_bmb06*(1+sr[l_i].bmb08/100))*p_QPA
#            LET l_QPA=l_bmb06 * p_QPA     ##94/12/06 Add 該行 Jackson
#            LET l_total=l_bmb06*p_total*((100+sr[l_i].bmb08))/100
             LET l_bmb06=sr[l_i].bmb06/sr[l_i].bmb07
             CALL cralc5_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,l_bmb06,p_QPA) 
             RETURNING l_total,l_QPA,l_ActualQPA
             #No.FUN-A60031--end
#bugno:6513 end.............................................................
##-----------------------------
            LET l_total2=l_total
#           LET l_sfa07=0   #FUN-940008 mark
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
#               LET l_sfa07=l_total  #FUN-940008 mark
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
            IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
                LET sr[l_i].bmb10=sr[l_i].ima25
                LET l_total=l_total*sr[l_i].bmb10_fac    #原發
                LET l_total2=l_total2*sr[l_i].bmb10_fac    #應發
                LET sr[l_i].bmb10_fac=1
            END IF
 
            LET l_bml04=NULL
 
            DECLARE bml_cur CURSOR FOR
            SELECT bml04,bml03 FROM bml_file
             WHERE bml01=sr[l_i].bmb03 
               AND (bml02=p_key OR bml02='ALL')
               ORDER BY bml03
 
           #OPEN bml_cur    #CHI-980013
 
           #FETCH bml_cur INTO l_bml04,g_i    #CHI-980013
            FOREACH bml_cur INTO l_bml04,g_i  #CHI-980013
               EXIT FOREACH                   #CHI-980013  
            END FOREACH                       #CHI-980013 
 
            IF sr[l_i].ima08!='X' OR g_btflg='N' OR
               (sr[l_i].ima08='X' AND g_btflg='Y' AND sr[l_i].bma01 IS NULL) OR
                (sr[l_i].ima37='1' AND g_mps='N') THEN #MPS part
 
                LET fs_insert = 'Y'
                 IF sr[l_i].ima08 = 'M' OR sr[l_i].ima08='X' OR sr[l_i].ima08='S' THEN     #No.MOD-530799 add ima08='S'
## add for top40:(bmb19):'1.不展開 2.不展開但自動開立工單 3.展開'
                   CASE
                      WHEN sr[l_i].bmb19='1'     #不展開
                           LET fs_insert = 'Y'
                      WHEN sr[l_i].bmb19='2'     #不展開但自動開立工單
                           LET fs_insert = 'Y'
                      WHEN sr[l_i].bmb19='3'     #展開
                           #發料單位 -> 生產單位 factor  for top40
                           #No.FUN-A60031--begin--mark
                           #CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                           #     sr[l_i].ima55) RETURNING g_status,g_factor
                           LET l_ActualQPA=l_ActualQPA*g_factor
                           LET l_total=l_total*g_factor
                           #No.FUN-A60031--end
                          #bugno:7475 modify........................................
                          #LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor
                           #LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor/sr[l_i].bmb07   #No.FUN-A60031--mark
                           
                          #bugno:7475 end........................................
 
                        #----------------No.TQC-620149 modify
                         #LET l_ActualQPA=
                         #           (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
                         #No.FUN-A60031--begin--mark
                          #LET l_ActualQPA=
                          #           (sr[l_i].bmb06*(sr[l_i].bmb08/100))*p_QPA
                         #No.FUN-A60031--end
                         #CALL cralc5_bom(p_level,sr[l_i].bmb03,' ',   #FUN-550112
                         #p_total*sr[l_i].bmb06,l_ActualQPA)
                         #LET g_fs_insert = 'N' #MOD-7B0075 add   #No.MOD-830161 mark 
                         #CALL cralc5_bom(p_level,sr[l_i].bmb03,' ',  #FUN-8B0015 mark
                         #l_total,l_ActualQPA,p_bmb09)
                         #NO.FUN-A60080--begin--mark
                         #CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],#FUN-8B0015
                         #l_total,l_ActualQPA,p_bmb09)
                         CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],
                         l_total,l_QPA,p_bmb09)
                         #NO.FUN-A60080--end
                     #-----------------No.TQC-620149 end
                          #MOD-7B0075----mos---str---
                          #LET fs_insert = 'N'
                           LET fs_insert = g_fs_insert
                           LET g_fs_insert = l_t_fs_insert   #No.MOD-830161 add
                          #MOD-7B0075----mos---end---
 
#---------------------### 01/04/11 開窗詢問是否展開 ----------------------
                      WHEN sr[l_i].bmb19 = '4'
 
                      OPEN WINDOW cl_sure_w AT 15,16 WITH 5 ROWS,50 COLUMNS  
                      ATTRIBUTES( STYLE = g_win_style ) 
 
                       DISPLAY sr[l_i].bmb03 at 1,10           #MOD-480492
#                      SELECT ima02,ima262 INTO l_ima02,l_ima262   #FUN-A20044
                      SELECT ima02 INTO l_ima02   #FUN-A20044
                        FROM ima_file       
                       WHERE ima01 = sr[l_i].bmb03
                       CALL s_getstock(sr[l_i].bmb03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
                      IF SQLCA.sqlcode THEN    
                         LET l_ima02 = ''     
                       #  LET l_ima262 = ''    #FUN-A20044
                         LET l_avl_stk = ''    #FUN-A20044
                      END IF 
 #MOD-480492 modify ...........................................................
                       DISPLAY l_ima02 at 2,10                 #MOD-480492
#                       DISPLAY "Stock Qty:",l_ima262 at 3,10   #MOD-480492-->:改用半型及diplsy位置改變 #FUN-A20044
                       DISPLAY "Stock Qty:",l_avl_stk at 3,10   #FUN-A20044

                       #CHI-B90027---add---start---
                      LET l_cnt=0
                      SELECT COUNT(*) INTO l_cnt FROM bma_file
                       WHERE bma01=sr[l_i].bmb03
                      IF l_cnt>0 THEN
                      #CHI-B90027---add---end---
 
                      CALL cl_confirm("sub-051") RETURNING g_sw
                       END IF                     #CHI-B90027 add 
 
                      CLOSE WINDOW cl_sure_w
 
#                     IF g_sw MATCHES '[yY]' THEN
                       IF g_sw THEN                #MOD-480492
                         #發料單位 -> 生產單位 factor  for top40
                         CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                              sr[l_i].ima55) RETURNING g_status,g_factor
                        #bugno:7475 modify........................................
                        #LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor
                        #No.FUN-A60031--begin--mark
                         #LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor/ sr[l_i].bmb07
                         LET l_ActualQPA=l_ActualQPA*g_factor
                         LET l_total=l_total*g_factor
                         #No.FUN-A60031--end
                        #bugno:7475 end........................................
                     #----------------No.TQC-620149 modify
                        #LET l_ActualQPA= 
                        #         (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
                        #CALL cralc5_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112
                        #      p_total*sr[l_i].bmb06,l_ActualQPA)
                         #No.FUN-A60031--begin--mark
                         #LET l_ActualQPA= 
                         #         (sr[l_i].bmb06*(sr[l_i].bmb08/100))*p_QPA
                         #No.FUN-A60031--end  
                         #CALL cralc5_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112#FUN-8B0015 mark
                         #               l_total,l_ActualQPA,p_bmb09)
                         #NO.FUN-A60080--begin
                         #CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                         #               l_total,l_ActualQPA,p_bmb09)
                         CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i], 
                                        l_total,l_QPA,p_bmb09)               
                         #NO.FUN-A60080--end               
                     #----------------No.TQC-620149 end
                          LET fs_insert = 'N'
                      ELSE
                          LET fs_insert = 'Y'
                      END IF
 #MOD-480492 end ...........................................................
#---------------------end --------------------------------------
                      OTHERWISE
                           LET fs_insert = 'Y'
                   END CASE
                END IF
                IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
                LET l_uuc=0
                IF fs_insert = 'Y' THEN
                INITIALIZE g_sfa.* TO NULL
                LET g_sfa.sfa01 =g_wo
                LET g_sfa.sfa02 =g_wotype
                LET g_sfa.sfa03 =sr[l_i].bmb03
                LET g_sfa.sfa04 =l_total
                LET g_sfa.sfa05 =l_total2
                LET g_sfa.sfa06 =0
                LET g_sfa.sfa061=0
                LET g_sfa.sfa062=0
                LET g_sfa.sfa063=0
                LET g_sfa.sfa064=0
                LET g_sfa.sfa065=0
                LET g_sfa.sfa066=0
          #     LET g_sfa.sfa07 =0   #FUN-940008 mark
                LET g_sfa.sfa08 =g_opseq
                IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
                LET g_sfa.sfa09 =g_offset
                LET g_sfa.sfa11 =l_sfa11
                LET g_sfa.sfa12 =sr[l_i].bmb10
                LET g_sfa.sfa13 =sr[l_i].bmb10_fac
                LET g_sfa.sfa14 =sr[l_i].ima86
                LET g_sfa.sfa15 =sr[l_i].bmb10_fac2
                LET g_sfa.sfa16 =l_QPA
                LET g_sfa.sfa161=l_ActualQPA
                LET g_sfa.sfa25 =l_uuc
                LET g_sfa.sfa26 =sr[l_i].bmb16
                LET g_sfa.sfa27 =sr[l_i].bmb03
                LET g_sfa.sfa28 =1
                LET g_sfa.sfa29 =p_key
               #----------No.MOD-780059 modify
               #LET g_sfa.sfa31 =l_bml04
                LET g_sfa.sfa30 =sr[l_i].bmb25
                LET g_sfa.sfa31 =sr[l_i].bmb26
                LET g_sfa.sfa36 =l_bml04   #FUN-950088 add
               #----------No.MOD-780059 end
               #-------------No.MOD-840433 add
                LET g_sfa.sfa32 = sr[l_i].bmb31
                IF g_sfb.sfb02 = '7' THEN 
                   IF g_sfa.sfa32 = 'Y' THEN
                      LET g_sfa.sfa065 = g_sfa.sfa05
                   END IF
                END IF
               #-------------No.MOD-840433 end
                LET g_sfa.sfaacti ='Y'
                LET g_sfa.sfaplant=g_plant  #FUN-980012 add
                LET g_sfa.sfalegal=g_legal  #FUN-980012 add
                # No.+114 Tommy
                LET g_sfa.sfa100 =sr[l_i].bmb28
                IF cl_null(g_sfa.sfa100) THEN
                   LET g_sfa.sfa100 = 0
                END IF
                # End Tommy

#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
               LET g_sfa.sfa04 =s_digqty(g_sfa.sfa04,g_sfa.sfa12)     #FUN-BB0085
               LET g_sfa.sfa05 =s_digqty(g_sfa.sfa05,g_sfa.sfa12)     #FUN-BB0085
                LET g_sfa.sfa161=g_sfa.sfa05/g_sfb.sfb08 #重計實際QPA NO.3494
                IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  #CHI-980013 

                IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF  #FUN-A50066
                IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF  #FUN-A50066
                INSERT INTO sfa_file VALUES(g_sfa.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                   #IF SQLCA.SQLCODE=-239 THEN                #TQC-790089 mark
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790089 mod
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                            FROM sfa_file
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                                AND sfa08=g_opseq
                        LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                        LET l_total=l_total*l_sfa13
                        LET l_total2=l_total2*l_sfa13
                        #CHI-980013--begin--add--
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                           AND sfa27=sr[l_i].bmb03 
                           AND sfa012=g_sfa.sfa012  #FUN-A50066
                           AND sfa013=g_sfa.sfa013  #FUN-A50066
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET g_sfa.sfa161 = 0 END IF
                         #CHI-980013--end--add
                        LET l_total = s_digqty(l_total,g_sfa.sfa012)   #FUN-BB0085
                        LET l_total2= s_digqty(l_total2,g_sfa.sfa012)  #FUN-BB0085
                        UPDATE sfa_file
                            SET sfa04=sfa04+l_total,
                                sfa05=sfa05+l_total2,
                               #sfa16=sfa16+sr[l_i].bmb06,  ##94/12/06 Jackson
                                sfa16=sfa16+l_QPA,         
                               #sfa161=sfa161+l_ActualQPA   No.3494 
                                sfa161=g_sfa.sfa161
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                                AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                              AND sfa27=sr[l_i].bmb03  #CHI-980013
                              AND sfa012=g_sfa.sfa012  #FUN-A50066
                              AND sfa013=g_sfa.sfa013  #FUN-A50066
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                           ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                           CONTINUE FOR
                        END IF
                    END IF
                #NO.FUN-7B0018 08/02/20 add --begin
                ELSE                  
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = g_sfa.sfa01
                      LET l_sfai.sfai03 = g_sfa.sfa03
                      LET l_sfai.sfai08 = g_sfa.sfa08
                      LET l_sfai.sfai12 = g_sfa.sfa12
                      LET l_sfai.sfai27 = g_sfa.sfa27      #No.FUN-870117
                      LET l_sfai.sfai012= g_sfa.sfa012  #FUN-A50066
                      LET l_sfai.sfai013= g_sfa.sfa013  #FUN-A50066
                      LET l_flag = s_ins_sfai(l_sfai.*,'')
                   
                END IF
                #NO.FUN-7B0018 08/02/20 add --end
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
                   # CALL cralc5_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #FUN-8B0015
                       # p_total*sr[l_i].bmb06,l_ActualQPA)  #No.MOD-5B0298 mark
                   #     p_total*l_bmb06,l_ActualQPA,p_bmb09)    #No.MOD-5B0298 add #FUN-8B0015
                    #NO.FUN-A60080--begin
                    #CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0015
                    #    p_total*l_bmb06,l_ActualQPA,p_bmb09)    #No.FUN-8B0015
                    CALL cralc5_bom(p_level,sr[l_i].bmb03,l_ima910[l_i], 
                        p_total*l_bmb06,l_QPA,p_bmb09)    
                    #NO.FUN-A60080--end    
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
        SELECT sfa_file.*,        #NO.FUN-9A0083 mod
#            ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
            ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
        FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03 = ima01      #FUN-9A0083 mod
        WHERE sfa01=g_wo 
 
#    FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_ima262,   #No.FUN-9A0083 mod #FUN-A20044
    FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_avl_stk,   #No.FUN-9A0083 mod #FUN-A20044
                         l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
        SELECT sfa03 INTO l_sfa03  FROM sfa_file
        WHERE sfa01=g_wo 
        CALL s_getstock(l_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET g_opseq=g_sfa.sfa08
       #--------------------------------- ima108,ima64,ima641應於料表或調撥處理
       #IF l_ima108 ='Y' THEN ELSE LET l_ima64=0 LET l_ima641=0 END IF
       #LET l_ima64=0 LET l_ima641=0
       #------------------------------------------------------------------
                              #bugno:7111 add 'T'
#        IF g_sfa.sfa26 MATCHES '[SUT]' THEN CONTINUE FOREACH END IF #Roger960608    #FUN-A20037
         IF g_sfa.sfa26 MATCHES '[SUTZ]' THEN CONTINUE FOREACH END IF                #FUN-A20037
       #----來源碼為'D'者不應出現
        IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF  #97/08/20 modify
        MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
        LET l_sfa03 = g_sfa.sfa03
 
        #Inflate With Minimum Issue Qty And Issue Pansize
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
        IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
           LET g_sfa.sfa05=l_ima641
        END IF
        IF l_ima64!=0 THEN
           LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999
           LET g_sfa.sfa05=l_double*l_ima64
        END IF
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF #FUN-9C0040
 
        #-->考慮單位小數取位 
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sfa.sfa12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         CALL cl_digcut(g_sfa.sfa05,l_gfe03) RETURNING l_sfaqty
         LET g_sfa.sfa05 =  l_sfaqty
       
#        IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A2044
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A2044
#        LET l_ima26=l_ima262 #FUN-A2044
        LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A2044
#        IF l_ima26<0 THEN LET l_ima26=0 END IF #FUN-A2044
        IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A2044
  ###
  ###   IF l_SafetyStock IS NULL THEN LET l_SafetyStock = 0 END IF
  ###   LET l_SSqty = l_ima26 - l_qty - l_SafetyStock
  ###   IF g_sma.sma884 ='Y' THEN
  ###      IF g_SOUCode='1' THEN    #完全取/替代
  ###         IF l_SSqty < 0 THEN    #若庫存量-安全庫存不敷使用, 則另找來源
  ###            LET l_bal=l_qty * -1
  ###            LET l_qty=0        #備料量為零
  ###            IF g_sfa.sfa26='1' THEN    #完全UTE
  ###               LET l_total2=0        #應發數量為零
  ###            END IF
  ###         END IF
  ###      END IF
  ###   END IF
  ###   IF l_SSqty < 0 AND l_qty>0 THEN
  ###      LET l_qty=l_ima26 - l_SafetyStock
  ###   END IF
       
#       IF l_ima26 >= g_sfa.sfa05  THEN       #庫存足夠
#          UPDATE sfa_file SET sfa05 = g_sfa.sfa05
#                 WHERE rowid=l_rowid
#       ELSE
#       原來庫存不足才找取代, 現在改為只要有取代, 先備取代料, 再備新料
        CASE
         WHEN g_sfa.sfa26='1' AND g_sma.sma66='Y'	## UTE:先備舊料,再備新料
              LET l_bal=g_sfa.sfa05	            	##應發量
              LET l_unaloc=0
              LET l_s=0                             	##取替代是否成功#
              CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
              g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
              g_sfa.sfa13,g_sfa.sfa15,l_bal,
              g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s  #FUN-A50066
              IF l_s THEN       ##發生取代
                 LET g_sfa.sfa26='3'            # 原來'2' 970620 Roger
                 LET l_total2=l_unaloc
              ELSE 
                   LET g_sfa.sfa26='1'
                   LET l_total2=g_sfa.sfa05
#                   LET l_unaloc=g_sfa.sfa05-l_ima26 #FUN-A20044
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp #FUN-A20044
              END IF
         WHEN g_sfa.sfa26='2' AND g_sma.sma67='Y'	##先備正料,再備替代料
             #---------No.FUN-680016 modify
             #LET l_total2=g_sfa.sfa05/g_sfa.sfa13
              LET l_total2=g_sfa.sfa05
             #---------No.FUN-680016 modify
              #-------------------------- 扣除其他工單備料量(971021 Roger)
              #SELECT SUM(sfa05-sfa06-sfa065) INTO l_qty  #MOD-530031          #MOD-A40061 mark
               SELECT SUM((sfa05-sfa06-sfa065)*sfa13) INTO l_qty  #MOD-530031  #MOD-A40061
                FROM sfa_file,sfb_file
               WHERE sfa03=g_sfa.sfa03
                 AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04<>'8'
                  AND sfb87<>'X'                          #MOD-530031
                 AND sfa01<>g_wo
              IF l_qty IS NULL THEN LET l_qty=0 END IF
#              LET l_ima26=l_ima26-l_qty #FUN-A20044
              LET l_avl_stk_mpsmrp=l_avl_stk_mpsmrp-l_qty #FUN-A20044
#              IF l_ima26 < 0 THEN LET l_ima26=0 END IF #FUN-A20044
              IF l_avl_stk_mpsmrp < 0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
              #------------------------------------------------------------
#              LET l_bal=l_total2-l_ima26  #FUN-A20044
              LET l_bal=l_total2-l_avl_stk_mpsmrp  #FUN-A20044
              LET l_unaloc=0
              LET l_s=0                             	##取替代是否成功#
              IF l_bal>0 THEN
                CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
                g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
                g_sfa.sfa13,g_sfa.sfa15,l_bal,
                g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s  #FUN-A50066
              END IF
              IF l_s THEN       ##發生替代
                 LET g_sfa.sfa26='4'            # 原來'2' 970620 Roger
#                 LET l_total2=(l_ima26+l_unaloc) #FUN-A20044
                 LET l_total2=(l_avl_stk_mpsmrp+l_unaloc) #FUN-A20044
              ELSE 
                   LET g_sfa.sfa26='2'          # 原來'1' 970620 Roger 
                   LET l_total2=g_sfa.sfa05
#                   LET l_unaloc=g_sfa.sfa05-l_ima26 #FUN-A20044
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp #FUN-A20044
              END IF
#FUN-A20037 --begin--
         WHEN g_sfa.sfa26='7' AND g_sma.sma67='Y'	
              LET l_total2=g_sfa.sfa05
               SELECT SUM(sfa05-sfa06-sfa065) INTO l_qty 
                FROM sfa_file,sfb_file
               WHERE sfa03=g_sfa.sfa03
                 AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04<>'8'
                  AND sfb87<>'X'                        
                 AND sfa01<>g_wo
              IF l_qty IS NULL THEN LET l_qty=0 END IF
#              LET l_ima26=l_ima26-l_qty #FUN-A20044
              LET l_avl_stk_mpsmrp=l_avl_stk_mpsmrp-l_qty #FUN-A20044
#              IF l_ima26 < 0 THEN LET l_ima26=0 END IF #FUN-A20044
              IF l_avl_stk_mpsmrp < 0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
              #------------------------------------------------------------
#              LET l_bal=l_total2-l_ima26 #FUN-A20044
              LET l_bal=l_total2-l_avl_stk_mpsmrp #FUN-A20044
              LET l_unaloc=0
              LET l_s=0                             
              IF l_bal>0 THEN
                CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
                g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
                g_sfa.sfa13,g_sfa.sfa15,l_bal,
                g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s  #FUN-A50066
              END IF
              IF l_s THEN      
                 LET g_sfa.sfa26='8'            
#                 LET l_total2=(l_ima26+l_unaloc) #FUN-A20044
                 LET l_total2=(l_avl_stk_mpsmrp+l_unaloc) #FUN-A20044
              ELSE 
                   LET g_sfa.sfa26='7'         
                   LET l_total2=g_sfa.sfa05
#                   LET l_unaloc=g_sfa.sfa05-l_ima26 #FUN-A20044
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp #FUN-A20044
              END IF
#FUN-A20037 --end--              
         OTHERWISE
              LET l_total2=g_sfa.sfa05
#              LET l_unaloc=g_sfa.sfa05-l_ima26 #FUN-A20044
              LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp #FUN-A20044
        END CASE
           IF l_unaloc < 0 THEN LET l_unaloc=0 END IF
           LET l_total2 =s_digqty(l_total2,g_sfa.sfa012)          #FUN-BB0085
           LET l_unaloc =s_digqty(l_unaloc,g_sfa.sfa012)          #FUN-BB0085
           LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494 
           IF g_sfa.sfa11 = 'X' THEN LET l_total2 = 0 LET g_sfa.sfa161 = 0 END IF  #CHI-980013
           UPDATE sfa_file SET sfa05 = l_total2,
                               sfa25 = l_unaloc,
                               sfa26 = g_sfa.sfa26,
                               sfa161= g_sfa.sfa161  #NO.3494
                  WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03 AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12 AND sfa27 = g_sfa.sfa27    #NO.FUN-9A0083 mod
                    AND sfa012= g_sfa.sfa012 AND sfa013= g_sfa.sfa013  #FUN-A50066
    END FOREACH
END FUNCTION
 
##處理取替代 
FUNCTION cralc5_sou(p_part,p_sou,p_offset,p_qpa,
    p_isuom,p_i2s,p_i2c,p_needqty,p_consumable,p_upart,p_sfa012,p_sfa013)  #FUN-A50066
DEFINE
    p_part       LIKE ima_file.ima01, #source part number
    p_upart      LIKE ima_file.ima01, #(上階料號)              
    p_sou        LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1) #file type S/U
    p_offset     LIKE bmb_file.bmb18, #offset
    p_qpa        LIKE bmb_file.bmb06, #quantity per assembly
    p_isuom      LIKE bmb_file.bmb10, #issuing UOM
    p_i2s        LIKE bmb_file.bmb10_fac, #issuing UOM to stocking conversion factor
    p_i2c        LIKE bmb_file.bmb10_fac2, #issuing UOM to cost conversion factor
#    p_needqty    LIKE ima_file.ima26, #qty needed #FUN-A20044
    p_needqty    LIKE type_file.num15_3, #qty needed #FUN-A20044
    p_consumable LIKE bmb_file.bmb15,
    l_bmd03      LIKE bmd_file.bmd03, #line item
    l_bmd04      LIKE bmd_file.bmd04, #target part number
    l_bmd07      LIKE bmd_file.bmd07, #QPA
#    l_qoh        LIKE ima_file.ima262, #QOH #FUN-A20044
    l_qoh        LIKE type_file.num15_3, #QOH #FUN-A20044
#    l_ima262     LIKE ima_file.ima262,            #FUN-A20044
    l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk     LIKE type_file.num15_3,            #FUN-A20044
    l_ima27      LIKE ima_file.ima27, 
    l_sc         LIKE ima_file.ima08,    #Source Code
#    l_qty,l_sqty LIKE ima_file.ima262, #issuing to stock qty #FUN-A20044
    l_qty,l_sqty LIKE type_file.num15_3, #issuing to stock qty #FUN-A20044
    l_total      LIKE sfa_file.sfa05,
    l_sfa26      LIKE sfa_file.sfa26, #source flag
    l_sfa11      LIKE sfa_file.sfa11, #flag
    l_sfa13      LIKE sfa_file.sfa13, #Conversion Rate
    l_first      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_i          LIKE type_file.num5,            #筆數        #No.FUN-680147 SMALLINT
    ss_qty,tt_qty      LIKE sfa_file.sfa13,        #No.FUN-680147 DECIMAL(12,3)
    l_unaloc,l_uqty    LIKE sfa_file.sfa25  #unallocated quantity
DEFINE l_sfai    RECORD LIKE sfai_file.*  #No.FUN-7B0018
DEFINE l_flag    LIKE type_file.chr1      #No.FUN-7B0018
DEFINE l_ima64   LIKE ima_file.ima64      #No.MOD-A50131 add
DEFINE l_ima641   LIKE ima_file.ima641      #No.MOD-A50131 add
DEFINE l_double  LIKE type_file.num10      #No.MOD-A50131 add
DEFINE l_gfe03   LIKE gfe_file.gfe03       #No.MOD-A50131 add
DEFINE l_sfaqty  LIKE sfa_file.sfa05       #No.MOD-A50131 add
DEFINE p_sfa012  LIKE sfa_file.sfa012      #FUN-A50066
DEFINE p_sfa013  LIKE sfa_file.sfa013      #FUN-A50066

    
    LET l_unaloc=p_needqty #unallocated qty
    DECLARE sou_cur CURSOR FOR
#        SELECT bmd03,bmd04,bmd07,ima262,ima27,ima08 #FUN-A20044
        SELECT bmd03,bmd04,bmd07,0,ima27,ima08 #FUN-A20044
            FROM bmd_file LEFT OUTER JOIN ima_file ON bmd04 = ima01     #FUN-9A0083 mod
            #WHERE ima_file.ima01=bmd04   #FUN-9A0083 mod
             WHERE bmd01=p_part
                AND bmd02=p_sou
                AND (bmd08=p_upart OR bmd08='ALL')
                AND (bmd05<=g_date OR bmd05 IS NULL)    #effective date
                AND (bmd06>=g_date OR bmd06 IS NULL)    #ineffective date
                AND bmdacti = 'Y'                                           #CHI-910021
            ORDER BY 1
    #-->原為元件替代(bmd_file) -> 改為元件加主件替代(bmd_file)
 
    IF p_sou='1' THEN
        LET l_sfa26='U'
    ELSE
#FUN-A20037 --begin--
        IF p_sou = '7' THEN 
           LET l_sfa26 = 'Z'
        ELSE        	   
#FUN-A20037 --end--    	
          LET l_sfa26='S'
        END IF     #FUN-A20037   
    END IF
 
    LET l_i=0
#    FOREACH sou_cur INTO l_bmd03,l_bmd04,l_bmd07,l_ima262,l_ima27,l_sc #FUN-A20044
    FOREACH sou_cur INTO l_bmd03,l_bmd04,l_bmd07,l_avl_stk,l_ima27,l_sc #FUN-A20044
     CALL s_getstock(l_bmd04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
 
        IF l_bmd07 IS NULL OR l_bmd07 <=0 THEN LET l_bmd07=1 END IF
#        IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A20044
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A20044
        IF cl_null(l_ima27)  THEN LET l_ima27=0  END IF
#        LET l_qoh=l_ima262 #FUN-A20044
        LET l_qoh=l_avl_stk #FUN-A20044
        IF p_sou='1' THEN
#           LET l_qoh=l_ima262-l_ima27	# UTE(取代料)應保留安全存量 #FUN-A20044
           LET l_qoh=l_avl_stk-l_ima27	# UTE(取代料)應保留安全存量 #FUN-A20044
        END IF
        IF l_qoh <=0 OR l_qoh IS NULL THEN CONTINUE FOREACH END IF
        #-------------------------- 扣除其他工單備料量(971021 Roger)
        #SELECT SUM(sfa05-sfa06-sfa065) INTO l_qty  #MOD-530031          #MOD-A40061 mark
         SELECT SUM((sfa05-sfa06-sfa065)*sfa13) INTO l_qty  #MOD-530031  #MOD-A40061
          FROM sfa_file,sfb_file
         WHERE sfa03=l_bmd04 AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04<>'8'
            AND sfb87<>'X'                          #MOD-530031
           AND sfa01<>g_wo
        IF l_qty IS NULL THEN LET l_qty=0 END IF
        LET l_qoh=l_qoh-l_qty
        IF l_qoh <=0 THEN CONTINUE FOREACH END IF
        #------------------------------------------------------------
 
        #換算成所真正需要的數量
        LET l_unaloc=l_unaloc*l_bmd07
    ### IF l_sfa26='U' THEN LET l_sqty=l_unaloc END IF    #UTE時的應發
 
    ### #使用完全取/替代時, 若該料件的現有庫存量不足使用, 則不考慮之
    ### IF g_SOUCode='1' AND l_qoh<l_unaloc THEN
    ###     IF l_sfa26='S' THEN        #完全替代, 量不足, 不用
    ###         CONTINUE FOREACH
    ###     END IF
    ### END IF
 
    ### #在UTE時, 若完全取代, 並量不足時, 則需產生一筆資料
    ### #在下列情形才計算應發數量: 1.部份取/替代時
    ### # 2.完全取/替代時, 並量充足時
    ### LET l_qty=0
    ### IF g_SOUCode!='1' OR l_sfa26!='U' OR l_qoh>=l_unaloc THEN
    ###     IF l_qoh < l_unaloc THEN
    ###         LET l_qty=l_qoh
    ###     ELSE
    ###         LET l_qty= l_unaloc
    ###     END IF
    ### END IF
 
    ### IF l_sfa26='S' THEN LET l_sqty=l_qty END IF        #SUB時的應發
 
    ### LET l_unaloc=l_unaloc-l_qty
       #IF l_qoh >= l_unaloc THEN            #庫存量夠時   #MOD-A40136 mark
        IF l_qoh >= l_unaloc*p_i2s THEN      #庫存量夠時   #MOD-A40136
           LET l_total=l_unaloc              #應發量
           LET l_unaloc=0
        ELSE
           LET l_total=l_qoh                 #應發量
           LET l_unaloc=l_unaloc-l_qoh       #庫存不足繼續找取替代
        END IF
 
    ### LET l_uqty=0            #SUB時的未備皆為零
    ### IF l_sfa26='U' THEN
    ###     LET l_uqty=l_unaloc
    ###     LET l_unaloc=0        #UTE 未備料量完全由UTE承擔
    ### END IF

#MOD-A50131 add --begin
        SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file WHERE ima01 = l_bmd04
        IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
        #check 最少發料量
         IF l_ima641 != 0 AND l_total < l_ima641 THEN
            LET l_total = l_ima641
         END IF
         IF l_ima64 != 0 THEN
            LET l_double = (l_total/l_ima64) + 0.999999
            LET l_total = l_double * l_ima64
         END IF
        #考慮單位小數取位
        SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = p_isuom
        IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
        CALL cl_digcut(l_total,l_gfe03) RETURNING l_sfaqty
        LET l_total = l_sfaqty
#MOD-A50131 add --end
 
        #Source Flag
        LET l_sfa11='N'
        IF p_consumable='E' THEN #comsumable
            LET l_sfa11='E'
        ELSE 
            IF l_sc MATCHES '[UVR]' THEN
                LET l_sfa11=l_sc
            END IF
        END IF
        IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
        LET ss_qty=l_sqty/p_i2s
        LET tt_qty=l_uqty/p_i2s   
        IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
        IF g_offset IS NULL THEN LET g_offset = 0 END IF
        SELECT ima86 INTO g_ima86 FROM ima_file WHERE ima01 = l_bmb04
        LET g_sfa.sfa01 =g_wo
        LET g_sfa.sfa02 =g_wotype
        LET g_sfa.sfa03 =l_bmd04
        LET g_sfa.sfa04 =0
        LET g_sfa.sfa05 =l_total
        LET g_sfa.sfa06 =0
        LET g_sfa.sfa061=0
        LET g_sfa.sfa062=0
        LET g_sfa.sfa063=0
        LET g_sfa.sfa064=0
        LET g_sfa.sfa065=0
        LET g_sfa.sfa066=0
 #      LET g_sfa.sfa07 =0   #FUN-940008 mark
        LET g_sfa.sfa08 =g_opseq
        IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
        LET g_sfa.sfa09 =p_offset
        LET g_sfa.sfa11 =l_sfa11
        LET g_sfa.sfa12 =p_isuom
        LET g_sfa.sfa13 =p_i2s
        LET g_sfa.sfa14 =g_ima86
        LET g_sfa.sfa15 =p_i2c
        LET g_sfa.sfa16 =0
        LET g_sfa.sfa161=0
        LET g_sfa.sfa25 =l_total
        LET g_sfa.sfa26 =l_sfa26
        LET g_sfa.sfa27 =p_part
        LET g_sfa.sfa28 =l_bmd07
        LET g_sfa.sfa29 =p_upart
        # No.+114 Tommy
        IF cl_null(g_sfa.sfa100) THEN
           LET g_sfa.sfa100 = 0 
        END IF
        # End Tommy
        LET g_sfa.sfaacti ='Y'
        LET g_sfa.sfaplant=g_plant  #FUN-980012 add
        LET g_sfa.sfalegal=g_legal  #FUN-980012 add
        LET g_sfa.sfa012 = p_sfa012   #FUN-A50066
        LET g_sfa.sfa013 = p_sfa013   #FUN-A50066

#TQC-BB0174 --begin--
        IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
        IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
        LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)   #FUN-BB0085
        LET g_sfa.sfa25 = s_digqty(g_sfa.sfa25,g_sfa.sfa12)   #FUN-BB0085

#bugno:5541 marked 取替代料之QPA=0...........
     #  LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494
        INSERT INTO sfa_file VALUES(g_sfa.*)
        IF SQLCA.SQLCODE THEN
           #IF SQLCA.SQLCODE=-239 THEN                #TQC-790089 mark
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790089 mod
                #因為相同的料件可能有不同的發料單位, 故宜換算之
                SELECT sfa13 INTO l_sfa13
                    FROM sfa_file
                    WHERE sfa01=g_wo AND sfa03=l_bmd04
                        AND sfa08=g_opseq
                LET l_sfa13=p_i2s/l_sfa13
                LET l_total=l_total*l_sfa13
            ### LET ss_qty=ss_qty*l_sfa13
            ### LET tt_qty=tt_qty*l_sfa13
                LET l_total = s_digqty(l_total,g_sfa.sfa012)     #FUN-BB0085
                UPDATE sfa_file SET
                    sfa05=sfa05+l_total,
                    sfa25=sfa25+l_total,
                    sfa28=sfa28+l_bmd07,
                    sfa161=g_sfa.sfa161  #NO.3494
                    WHERE sfa01=g_wo AND sfa03=l_bmd04
                      AND sfa08=g_opseq
                      AND sfa27=p_part         #FUN-A50066
                      AND sfa012=g_sfa.sfa012  #FUN-A50066
                      AND sfa013=g_sfa.sfa013  #FUN-A50066
            ELSE
                #CALL cl_err('ins sfa(3)',STATUS,1)  #FUN-670091
                 CALL cl_err3("ins","sfa_file",g_wo,"",STATUS,"","",1) #FUN-670091
            END IF
        #NO.FUN-7B0018 08/02/20 add --begin
        ELSE
           
              INITIALIZE l_sfai.* tO NULL
              LET l_sfai.sfai01 = g_sfa.sfa01
              LET l_sfai.sfai03 = g_sfa.sfa03
              LET l_sfai.sfai08 = g_sfa.sfa08
              LET l_sfai.sfai12 = g_sfa.sfa12
              LET l_sfai.sfai27 = g_sfa.sfa27    #No.FUN-870117
              LET l_sfai.sfai012= g_sfa.sfa012   #FUN-A50066
              LET l_sfai.sfai013= g_sfa.sfa013   #FUN-A50066
              LET l_flag = s_ins_sfai(l_sfai.*,'')
           
        #NO.FUN-7B0018 08/02/20 add --end
        END IF
        LET g_ccc=g_ccc+1
        LET l_i=l_i+1
        IF l_sfa26='U' THEN LET l_unaloc=l_unaloc/l_bmd07   #取代僅有一筆
           EXIT FOREACH END IF
     #替代時,量分配完了,就不用再找了
        IF l_unaloc = 0 THEN  EXIT FOREACH      
           ELSE LET l_unaloc=l_unaloc/l_bmd07 END IF
    END FOREACH
 
    RETURN l_unaloc,l_i
END FUNCTION
 
#------------------------------------- 970625 By Roger 由S/O配件產生備料檔
FUNCTION cralc5_oeo(p_part,p_woq)
   DEFINE p_part	LIKE bmb_file.bmb01      #No.MOD-490217
   DEFINE p_woq		LIKE sfa_file.sfa04      #No.FUN-680147 DEC(15,3)
   DEFINE l_oeo		RECORD LIKE oeo_file.*
   DEFINE l_sfai        RECORD LIKE sfai_file.*  #No.FUN-7B0018
   DEFINE l_flag        LIKE type_file.chr1      #No.FUN-7B0018
 
   IF g_sfb.sfb22 IS NULL THEN RETURN END IF
   DECLARE cralc5_oeo_c CURSOR FOR
       SELECT * FROM oeo_file 
        WHERE oeo01=g_sfb.sfb22 AND oeo03=g_sfb.sfb221
          AND oeo08='1'  #no.7168
   FOREACH cralc5_oeo_c INTO l_oeo.*
    IF STATUS THEN CALL cl_err('fore oeo',STATUS,1) EXIT FOREACH END IF
    LET g_sfa.sfa01 =g_wo
    LET g_sfa.sfa02 =g_wotype
    LET g_sfa.sfa03 =l_oeo.oeo04
    LET g_sfa.sfa04 =p_woq*l_oeo.oeo06
    LET g_sfa.sfa05 =p_woq*l_oeo.oeo06
    LET g_sfa.sfa06 =0
    LET g_sfa.sfa061=0
    LET g_sfa.sfa062=0
    LET g_sfa.sfa063=0
    LET g_sfa.sfa064=0
    LET g_sfa.sfa065=0
    LET g_sfa.sfa066=0
#   LET g_sfa.sfa07 =0   #FUN-940008 mark
    LET g_sfa.sfa08 =' '
    LET g_sfa.sfa09 =0
    LET g_sfa.sfa11 ='N'
    SELECT ima70 INTO g_sfa.sfa11 FROM ima_file WHERE ima01=g_sfa.sfa03
    LET g_sfa.sfa12 =l_oeo.oeo05
    LET g_sfa.sfa13 =1
    LET g_sfa.sfa14 =l_oeo.oeo05
    LET g_sfa.sfa15 =1
#   LET g_sfa.sfa16 =1            #No.MOD-A30166
#   LET g_sfa.sfa161=1            #No.MOD-A30166
    LET g_sfa.sfa16=l_oeo.oeo06   #No.MOD-A30166
    LET g_sfa.sfa161=l_oeo.oeo06  #No.MOD-A30166
    LET g_sfa.sfa25 =p_woq
  # LET g_sfa.sfa26 ='0'
#bugno:6089 add..........................................
    LET g_sfa.sfa26 ='' 
    DECLARE bmb16_cs CURSOR FOR 
      SELECT bmb16 FROM bmb_file 
       WHERE bmb01 IN (SELECT bmb03 FROM bmb_file,ima_file 
                        WHERE bmb01=p_part 
                          AND bmb03=ima01 
                          AND ima08='D' 
                      ) 
         AND bmb03=l_oeo.oeo04 
    FOREACH bmb16_cs INTO g_sfa.sfa26 
      MESSAGE '' 
    END FOREACH 
    IF cl_null(g_sfa.sfa26) THEN LET g_sfa.sfa26='0' END IF 
#bugno:6089 end..........................................
    LET g_sfa.sfa27 =l_oeo.oeo04
    LET g_sfa.sfa28 =1
    LET g_sfa.sfa29 =p_part
    LET g_sfa.sfaacti ='Y'
    LET g_sfa.sfaplant=g_plant  #FUN-980012 add
    LET g_sfa.sfalegal=g_legal  #FUN-980012 add
    # No.+114 Tommy
    IF cl_null(g_sfa.sfa100) THEN
       LET g_sfa.sfa100 = 0 
    END IF
    # End Tommy

#TQC-BB0174 --begin--
    IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
    IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
    LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)   #FUN-BB0085
    LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)   #FUN-BB0085
    LET g_sfa.sfa25 = s_digqty(g_sfa.sfa25,g_sfa.sfa12)   #FUN-BB0085

    LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494
    IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF  #FUN-A50066
    IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF  #FUN-A50066
    INSERT INTO sfa_file VALUES(g_sfa.*)
    IF STATUS THEN 
       #CALL cl_err('ins sfa(from oeo):',STATUS,1) #FUN-670091
        CALL cl_err3("ins","sfa_file","","",STATUS,"","",1) #FUN-670091
    #NO.FUN-7B0018 08/02/20 add --begin
    ELSE
       
          INITIALIZE l_sfai.* tO NULL
          LET l_sfai.sfai01 = g_sfa.sfa01
          LET l_sfai.sfai03 = g_sfa.sfa03
          LET l_sfai.sfai08 = g_sfa.sfa08
          LET l_sfai.sfai12 = g_sfa.sfa12
          LET l_sfai.sfai27 = g_sfa.sfa27      #No.FUN-870117
          LET l_sfai.sfai012= g_sfa.sfa012     #FUN-A50066
          LET l_sfai.sfai013= g_sfa.sfa013     #FUN-A50066
          LET l_flag = s_ins_sfai(l_sfai.*,'')
      
    END IF
    #NO.FUN-7B0018 08/02/20 add --end
   END FOREACH
END FUNCTION
 
FUNCTION cralc5_sss()
   DEFINE r1,r2		LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE l_sfa		RECORD LIKE sfa_file.*
 
   BEGIN WORK
   DECLARE sss_c CURSOR WITH HOLD FOR
       SELECT sfa_file.* FROM sfa_file             #NO.FUN-9A0083 Mod 
#              WHERE sfa01=g_wo AND sfa26 IN ('3','4','6') AND sfa05=0       #FUN-A20037 
               WHERE sfa01=g_wo AND sfa26 IN ('3','4','6','8') AND sfa05=0   #FUN-A20037 
   FOREACH sss_c INTO g_sfa.*                      #NO.FUN-9A0083 mod
       LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494 
       DECLARE sss_c2 CURSOR WITH HOLD FOR
           SELECT sfa_file.* FROM sfa_file       #NO.FUN-9A0083 mod
              WHERE sfa01=g_sfa.sfa01
                AND sfa27=g_sfa.sfa27
                AND sfa08=g_sfa.sfa08
                AND sfa12=g_sfa.sfa12 
#                AND sfa26 IN ('S','U') AND sfa05>0        #FUN-A20037 
                 AND sfa26 IN ('S','U','Z') AND sfa05>0    #FUN-A20037 
       FOREACH sss_c2 INTO l_sfa.*               #NO.FUN-9A0083
          LET l_sfa.sfa27 =l_sfa.sfa03
          LET l_sfa.sfa26 =g_sfa.sfa26
          LET l_sfa.sfa161=g_sfa.sfa161
         #MESSAGE 'upd:', l_sfa.sfa27, l_sfa.sfa26, l_sfa.sfa161
          UPDATE sfa_file SET *=l_sfa.* WHERE sfa01 = g_sfa.sfa01 AND sfa03=g_sfa.sfa03 AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12 AND sfa27 = g_sfa.sfa27  #NO.FUN-9A0083 mod 
          EXIT FOREACH
       END FOREACH
   END FOREACH
   COMMIT WORK
END FUNCTION
#No.FUN-870117
#No.MOD-880016

#No.FUN-A60031--begin
#传入值 主件料号，元件料号，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
#返回值 元件备料量，标准QPA,实际QPA
FUNCTION cralc5_rate(p_bmb01,p_bmb03,p_total,p_bmb081,p_bmb08,p_bmb082,p_bmb06,p_QPA)
DEFINE  l_n         LIKE type_file.num5,
        l_n1        LIKE type_file.num5,
        l_n2        LIKE type_file.num5,
        l_n3        LIKE type_file.num5,
        sr          DYNAMIC ARRAY OF RECORD 
                    bof04   LIKE bof_file.bof04,
                    bof05   LIKE bof_file.bof05,
                    bof06   LIKE bof_file.bof06,
                    bof07   LIKE bof_file.bof07
                    END RECORD,
       sr1          DYNAMIC ARRAY OF RECORD
                    total LIKE sfa_file.sfa05      
                    END RECORD,
       l_QPA        LIKE bmb_file.bmb06, 
       l_ActualQPA  LIKE bmb_file.bmb06,
       l_total      LIKE sfa_file.sfa05,
       t_total      LIKE sfa_file.sfa05,
       p_bmb01      LIKE bmb_file.bmb01,
       p_bmb03      LIKE bmb_file.bmb03,                       
       p_total      LIKE sfa_file.sfa05,
       p_bmb081     LIKE bmb_file.bmb081,
       p_bmb08      LIKE bmb_file.bmb08,
       p_bmb082     LIKE bmb_file.bmb082,
       p_bmb06      LIKE bmb_file.bmb06,
       p_bmb07      LIKE bmb_file.bmb07,          
       p_QPA        LIKE bmb_file.bmb06,
       l_sql        STRING,             
       l_a          LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_cnt        LIKE type_file.num5,
       l_b          LIKE type_file.num5,
       l_c          LIKE type_file.num5,
       l_t          LIKE type_file.num5,
       l_max1       LIKE bof_file.bof04,
       l_max2       LIKE bof_file.bof05,
       l_max3       LIKE bof_file.bof06,
       l_max4       LIKE bof_file.bof07,      
       l_bof06      LIKE bof_file.bof06,
       l_bof07      LIKE bof_file.bof07 
DEFINE l_bmb081     LIKE bmb_file.bmb081   #FUN-B60142


   IF cl_null(p_bmb08) THEN LET p_bmb08=0 END IF    #TQC-BB0186
   IF cl_null(p_bmb081) THEN LET p_bmb081=0 END IF  #TQC-BB0186
   IF cl_null(p_bmb082) THEN LET p_bmb082=1 END IF  #TQC-BB0186
       
   SELECT COUNT(*) INTO l_n FROM bof_file WHERE bof01 = p_bmb01                                                                                  
                  AND bof02 = '1' AND bof03 = p_bmb03        
   SELECT COUNT(*) INTO l_n1 FROM bof_file,imx_file   
                   WHERE bof01 = imx00 AND imx000 = p_bmb01                                            
                     AND bof02 = '1' AND bof03 = p_bmb03                  
   SELECT COUNT(*) INTO l_n2 FROM bof_file,imx_file    
                   WHERE bof01 =  p_bmb01 AND bof02 = '1'
                     AND bof03 = imx00 AND imx000 = p_bmb03 
   SELECT COUNT(*) INTO l_n3 FROM bof_file,imx_file     
                   WHERE bof01 = imx00 AND imx000 =p_bmb01                                           
                     AND bof02 = '1'
                     AND bof03 = (SELECT imx00 FROM imx_file
                               WHERE  imx000 = p_bmb03 )
                               
   #FUN-B60142--begin--add---
   IF l_n>0 THEN 
      SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
       WHERE bof01 = p_bmb01 AND bof02 = '1' AND bof03 = p_bmb03                                                                                
         AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                              
   ELSE                  
      IF l_n1>0 THEN 
   	 SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
           WHERE bof01 = imx00 AND imx000 = p_bmb01                                            
             AND bof02 = '1' AND bof03 = p_bmb03 
             AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                        
      ELSE
         IF l_n2>0 THEN 
            SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
              WHERE bof01 =  p_bmb01 AND bof02 = '1'
                AND bof03 = imx00 AND imx000 = p_bmb03 
                AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                                                   
   	 ELSE 
            IF l_n3>0 THEN 
               SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
                WHERE bof01 = imx00 AND imx000 =p_bmb01                                           
                  AND bof02 = '1' AND bof03 = (SELECT imx00 FROM imx_file WHERE  imx000 = p_bmb03 )                                                                                  
                  AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                              	
   	    ELSE                                                                                                         
               SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file,ima_file                                                           
                WHERE bof01 = p_bmb01 AND bof02 = '2' AND bof03 = ima10                                                                                       
                  AND ima01 = p_bmb03 AND bof04 <= p_total
                  AND (bof05 >= p_total OR bof05 IS NULL)    
            END IF
         END IF    
      END IF   
   END IF
   IF cl_null(l_bof06) THEN  LET l_bof06=0 END IF
   IF cl_null(l_bof07) THEN  LET l_bof07=0 END IF 
   #FUN-B60142--end--add---
                                                                       
   #损耗分量计算               
   IF g_sma.sma71='Y' AND g_sma.sma141='Y' THEN                
      IF l_n>0 THEN 
         LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file WHERE bof01 = '",p_bmb01 CLIPPED,"' ",                                                                                
                   "  AND bof02 = '1' AND bof03 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 " 
      ELSE 
      	 IF l_n1>0 THEN 
      	    LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file,imx_file WHERE bof01 = '",p_bmb01 CLIPPED,"' AND bof01 = imx00 ",                                                                                
                        " AND bof02 = '1' AND bof03 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 " 
      	 ELSE
            IF l_n2>0 THEN 
               LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file,imx_file WHERE bof01 = '",p_bmb01 CLIPPED,"' AND bof02 = '1' ",                                                                                
                        " AND bof03 = imx00 AND imx000 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 " 
            ELSE
               IF l_n3>0 THEN 
                  LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file,imx_file WHERE bof01 = imx00 AND imx000 = '",p_bmb01 CLIPPED,"' ",                                        
                  " AND bof02 = '1' AND bof03 = (SELECT imx00 FROM imx_file WHERE  imx000 = '",p_bmb03 CLIPPED,"' ) ORDER BY bof05 "                  
               ELSE   
               LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file,ima_file WHERE bof01 = '",p_bmb01 CLIPPED,"' ",                                                                                 
                         "  AND bof02 = '2' AND bof03 = ima10 AND ima01 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 "     
             END IF   
           END IF 
         END IF              	
      END IF                                                                                
      PREPARE cralc5_rate_p1 FROM l_sql 
      DECLARE cralc5_rate_c1 CURSOR FOR cralc5_rate_p1 
      LET l_cnt=1
      FOREACH cralc5_rate_c1 INTO sr[l_cnt].bof04,sr[l_cnt].bof05,sr[l_cnt].bof06,sr[l_cnt].bof07
         IF cl_null(sr[l_cnt].bof06) THEN 
            LET sr[l_cnt].bof06=0
         END IF 
         IF cl_null(sr[l_cnt].bof07) THEN 
            LET sr[l_cnt].bof07=0
         END IF          
         LET l_cnt=l_cnt+1
      END FOREACH    
      CALL sr.deleteElement(l_cnt) 
      LET l_c=l_cnt-1
      #按照生产数量区间从小到大排序
      #NO.FUN-A60080--begin
      #FOR l_a=1 TO l_c
      #FOR l_b=1 TO l_c-1
      #    IF sr[l_b].bof05>sr[l_b+1].bof05 THEN 
      #       LET l_max1=sr[l_b].bof04
      #       LET l_max2=sr[l_b].bof05
      #       LET l_max3=sr[l_b].bof06
      #       LET l_max4=sr[l_b].bof07
      #       LET sr[l_b].bof04=sr[l_b+1].bof04
      #       LET sr[l_b].bof05=sr[l_b+1].bof05
      #       LET sr[l_b].bof06=sr[l_b+1].bof06
      #       LET sr[l_b].bof07=sr[l_b+1].bof07
      #       LET sr[l_b+1].bof04=l_max1
      #       LET sr[l_b+1].bof05=l_max2
      #       LET sr[l_b+1].bof06=l_max3
      #       LET sr[l_b+1].bof07=l_max4
      #    END IF 
      #END FOR 
      #END FOR 
      #NO.FUN-A60080--end
      LET t_total=p_total
      #计算在每一个生产数量区间内的元件数量
      FOR l_a=1 TO l_c
        #FUN-B60142--begin--add----
         IF g_sma.sma1411 = 'Y' THEN
            IF l_a = 1 THEN
               LET l_bmb081=p_bmb081*(1+sr[l_a].bof06/100)
            ELSE
               LET l_bmb081=p_bmb081*(sr[l_a].bof06/100)
            END IF
         ELSE
            IF l_a = 1 THEN
               LET l_bmb081=p_bmb081*(1+l_bof06/100)
            ELSE
               LET l_bmb081=0
            END IF
         END IF
        #FUN-B60142--end--add----
        #IF t_total>sr[l_a].bof05 THEN  #FUN-B60142
         IF p_total>sr[l_a].bof05 THEN  #FUN-B60142
           #LET t_total=t_total-sr[l_a].bof05                    #FUN-B60142
            LET t_total=t_total-(sr[l_a].bof05-sr[l_a].bof04+1)  #FUN-B60142
           #LET sr1[l_a].total=p_bmb081*(1+sr[l_a].bof06/100)+p_bmb06*sr[l_a].bof05*(p_bmb08/(p_bmb082*100))*(1+sr[l_a].bof07/100) #FUN-AC0104
           #LET sr1[l_a].total=p_bmb081*(1+sr[l_a].bof06/100)+p_bmb06*sr[l_a].bof05*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100) #FUN-AC0104 #FUN-B60142
            LET sr1[l_a].total=l_bmb081+p_bmb06*(sr[l_a].bof05-sr[l_a].bof04+1)*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100)     #FUN-B60142
            IF l_a=l_c THEN 
              #LET sr1[l_c+1].total=p_bmb081*1+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*1    #FUN-B60142
               LET sr1[l_c+1].total=p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*1               #FUN-B60142             
            END IF 
         ELSE 
           #LET sr1[l_a].total=p_bmb081*(1+sr[l_a].bof06/100)+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100) #FUN-B60142
            LET sr1[l_a].total=l_bmb081+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100) #FUN-B60142
            EXIT FOR 
         END IF 
      END FOR 
      LET l_total=0
      FOR l_t=1 TO sr1.getLength()
          LET l_total=l_total+sr1[l_t].total
      END FOR 
      IF l_total=0 THEN 
         LET l_total=p_bmb081*1+p_bmb06*p_total*(p_bmb08/100/(p_bmb082))*1
      END IF       
      LET l_total=l_total+p_total*p_bmb06   #NO.FUN-A60080
      LET l_ActualQPA=l_total/p_total
      LET l_QPA=p_bmb06*p_QPA 
   END IF 
   #损耗不分量计算
   IF g_sma.sma71='Y' AND g_sma.sma141='N' THEN 
     #FUN-B60142--begin--mark---
     #IF l_n>0 THEN 
     #   SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
     #    WHERE bof01 = p_bmb01 AND bof02 = '1' AND bof03 = p_bmb03                                                                                
     #      AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                              
     #   IF cl_null(l_bof06) THEN                                                                                                    
     #      LET l_bof06=0                                                                                           
     #   END IF    
     #   IF cl_null(l_bof07)THEN                          
     #     LET l_bof07=0                                                                       
     #   END IF            
     #ELSE                  
     #	 IF l_n1>0 THEN 
     #	    SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
     #           WHERE bof01 = imx00 AND imx000 = p_bmb01                                            
     #             AND bof02 = '1' AND bof03 = p_bmb03 
     #             AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)  
     #      IF cl_null(l_bof06) THEN                                                                                                    
     #         LET l_bof06=0                                                                                           
     #      END IF    
     #      IF cl_null(l_bof07)THEN                          
     #        LET l_bof07=0                                                                       
     #      END IF                         
     #	 ELSE
     #      IF l_n2>0 THEN 
     #         SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
     #           WHERE bof01 =  p_bmb01 AND bof02 = '1'
     #             AND bof03 = imx00 AND imx000 = p_bmb03 
     #             AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                              
     #        IF cl_null(l_bof06) THEN                                                                                                    
     #           LET l_bof06=0                                                                                           
     #        END IF    
     #        IF cl_null(l_bof07)THEN                          
     #          LET l_bof07=0                                                                      
     #        END IF                           
     #	   ELSE 
     #        IF l_n3>0 THEN 
     #          SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
     #           WHERE bof01 = imx00 AND imx000 =p_bmb01                                           
     #             AND bof02 = '1' AND bof03 = (SELECT imx00 FROM imx_file WHERE  imx000 = p_bmb03 )                                                                                  
     #             AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                              
     #          IF cl_null(l_bof06) THEN                                                                                                    
     #             LET l_bof06=0                                                                                           
     #          END IF    
     #          IF cl_null(l_bof07)THEN                          
     #            LET l_bof07=0                                                                       
     #          END IF        	
     #	 		 ELSE                                                                                                         
     #          SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file,ima_file                                                           
     #           WHERE bof01 = p_bmb01 AND bof02 = '2' AND bof03 = ima10                                                                                       
     #             AND ima01 = p_bmb03 AND bof04 <= p_total
     #             AND (bof05 >= p_total OR bof05 IS NULL)    
     #          IF cl_null(l_bof06) THEN                                                                                                    
     #             LET l_bof06=0                                                                                           
     #          END IF    
     #          IF cl_null(l_bof07)THEN                          
     #            LET l_bof07=0                                                                       
     #          END IF
     #       END IF    
     #     END IF   
     #   END IF
     #END IF 
     #FUN-B60142--end--mark---- 
      LET l_QPA=p_bmb06*p_QPA  
      LET l_total=p_bmb081*(1+l_bof06/100)+ p_bmb06*p_total*(p_bmb08/100/(p_bmb082))*(1+l_bof07/100)     
      LET l_total=l_total+p_total*p_bmb06    #No.FUN-A60086  
      LET l_ActualQPA=l_total/p_total
   END IF    
   #不考虑损耗
   IF g_sma.sma71='N' THEN 
      LET l_QPA=p_bmb06 * p_QPA
      LET l_ActualQPA=l_QPA
      LET l_total=p_total*p_bmb06
   END IF 
   RETURN l_total,l_QPA,l_ActualQPA
   
END FUNCTION 
#No.FUN-A60031--end

#FUN-A50066--begin--add-------------------
FUNCTION cralc5_brb_bom(p_level,p_key,p_key2,p_total,p_QPA,p_brb09,p_ecm03_par,p_ecm11,p_ecm03,p_ecm012)  
DEFINE
    p_level        LIKE type_file.num5,  
    p_total        LIKE brb_file.brb06, 
    p_QPA          LIKE brb_file.brb06, 
    l_QPA          LIKE brb_file.brb06,  
    l_total        LIKE sfa_file.sfa07,
    l_total2       LIKE sfa_file.sfa07,
    p_key          LIKE bra_file.bra01,
    p_brb09        LIKE brb_file.brb09,         
    p_key2	   LIKE ima_file.ima910,   
    l_ac,l_i,l_x,l_s LIKE type_file.num5, 
    arrno          LIKE type_file.num5,
    b_seq,l_double LIKE type_file.num10, 
    sr ARRAY[500] OF RECORD  #array for storage
       brb02       LIKE brb_file.brb02, #SEQ
       brb03       LIKE brb_file.brb03, #component part number
       brb10       LIKE brb_file.brb10, #Issuing UOM
       brb10_fac   LIKE brb_file.brb10_fac,#Issuing UOM to stock transfer rate
       brb10_fac2  LIKE brb_file.brb10_fac2,#Issuing UOM to cost transfer rate
       brb15       LIKE brb_file.brb15, #consumable part flag
       brb16       LIKE brb_file.brb16, #substitable flag
       brb06       LIKE brb_file.brb06, #QPA
       brb08       LIKE brb_file.brb08, #yield
       brb081      LIKE brb_file.brb081,
       brb082      LIKE brb_file.brb082,    
       brb09       LIKE brb_file.brb09, #operation sequence number
       brb18       LIKE brb_file.brb18, #days offset
       brb19       LIKE brb_file.brb19, #1.不展開 2.不展開但自動開立工單 3.展開:top40
       brb28       LIKE brb_file.brb28, #允許發料誤差
       brb25       LIKE brb_file.brb25, #倉庫         
       brb26       LIKE brb_file.brb26, #儲位          
       brb14       LIKE brb_file.brb14, 
       ima08       LIKE ima_file.ima08, #source code
       ima37       LIKE ima_file.ima37, #OPC
       ima25       LIKE ima_file.ima25, #UOM
       ima55       LIKE ima_file.ima55, #生產單位
       ima86       LIKE ima_file.ima86, #COST UNIT
       ima86_fac   LIKE ima_file.ima86_fac, #
       brb07       LIKE brb_file.brb07, #底數   
       brb31       LIKe brb_file.brb31, 
       bra01       LIKE bra_file.bra01,
       brb29       LIKE brb_file.brb29,
       brb011      LIKE brb_file.brb011,
       brb012      LIKE brb_file.brb012,
       brb013      LIKE brb_file.brb013 
                   END RECORD,
    g_sfa RECORD  LIKE sfa_file.*,    #備料檔
    l_ima02        LIKE ima_file.ima02,
    l_ima08        LIKE ima_file.ima08, #source code
    l_avl_stk_mpsmrp  LIKE type_file.num15_3,
    l_avl_stk       LIKE type_file.num15_3,
    l_unavl_stk    LIKE type_file.num15_3,
    l_SafetyStock  LIKE ima_file.ima27,
    l_SSqty        LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37,  #OPC
    l_ima108       LIKE ima_file.ima108,
    l_ima64        LIKE ima_file.ima64,  #Issue Pansize
    l_ima641       LIKE ima_file.ima641, #Minimum Issue QTY
    l_uom          LIKE ima_file.ima25,  #Stock UOM
    l_sfa07        LIKE sfa_file.sfa07, #quantity owed
    l_sfa03        LIKE sfa_file.sfa03, #part No
    l_sfa11        LIKE sfa_file.sfa11, #consumable flag
    l_qty          LIKE type_file.num15_3, 
    l_sfaqty       LIKE sfa_file.sfa05,
    l_gfe03        LIKE gfe_file.gfe03, 
    l_bal          LIKE type_file.num15_3, #balance (QOH-issue) 
    l_ActualQPA    LIKE brb_file.brb06, 
    l_brb06        LIKE brb_file.brb06, 
    l_sfa12        LIKE sfa_file.sfa12,    #發料單位
    l_sfa13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bml04        LIKE bml_file.bml04,    #指定廠商
    fs_insert      LIKE type_file.chr1, 
    l_fs_insert    LIKE type_file.chr1, 
    l_t_fs_insert    LIKE type_file.chr1,
    g_sw           LIKE type_file.chr1,
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c      LIKE type_file.num5, 
    l_cmd          LIKE type_file.chr1000 
DEFINE l_sfai      RECORD LIKE sfai_file.* 
DEFINE l_flag      LIKE type_file.chr1 
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910    
DEFINE l_sfa11_a   LIKE sfa_file.sfa11        
DEFINE p_ecm03_par    LIKE ecm_file.ecm03_par
DEFINE p_ecm11        LIKE ecm_file.ecm11
DEFINE p_ecm012       LIKE ecm_file.ecm012
DEFINE p_ecm03        LIKE ecm_file.ecm03   

    LET p_level = p_level + 1
    LET arrno = 500
    IF cl_null(p_brb09) THEN 
        LET l_cmd=
            "SELECT brb02,brb03,brb10,brb10_fac,brb10_fac2,",
            "brb15,brb16,brb06,brb08,brb081,brb082,brb09,brb18,brb19,brb28,",  
            "brb25,brb26,brb14,", 
            "ima08,ima37,ima25,ima55,",
            " ima86,ima86_fac,brb07,brb31,bra01,brb29,brb011,brb012,brb013", 
            " FROM brb_file LEFT OUTER JOIN ima_file ON brb03 = ima01 ",
            " LEFT OUTER JOIN bra_file ON brb03 = bra01 AND brb29=bra06 AND bra_file.braacti='Y' AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 ",  
            " WHERE brb01='", p_key,"' AND brb02>?",
            "   AND brb29 ='",p_key2,"' ",  
            "   AND brb011 = '",p_ecm11,"'",
            "   AND brb012 = '",p_ecm012,"'",
            "   AND brb013 = ",p_ecm03,
            "   AND (brb04 <='",g_date,
            "' OR brb04 IS NULL) AND (brb05 >'",g_date,
            "' OR brb05 IS NULL)",
            " ORDER BY 1"
     ELSE   
     	LET l_cmd=
            "SELECT brb02,brb03,brb10,brb10_fac,brb10_fac2,",
            "brb15,brb16,brb06,brb08,brb081,brb082,brb09,brb18,brb19,brb28,",  
            "brb25,brb26,brb14,",  
            "ima08,ima37,ima25,ima55,",  
            " ima86,ima86_fac,brb07,brb31,bra01,brb29,brb011,brb012,brb013",
            " FROM brb_file LEFT OUTER JOIN ima_file ON brb03=ima01 ",
            " LEFT OUTER JOIN bra_file ON brb03 = bra01 AND brb29=bra06 AND bra_file.braacti='Y' AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 ", 
            " WHERE brb01='", p_key,"' AND brb02>?",
            "   AND brb29 ='",p_key2,"' ",
            "   AND brb011 = '",p_ecm11,"'",
            "   AND brb012 = '",p_ecm012,"'",
            "   AND brb013 = ",p_ecm03,
            "   AND (brb04 <='",g_date,
            "' OR brb04 IS NULL) AND (brb05 >'",g_date,
            "' OR brb05 IS NULL)",     
            " AND brb09 = '",p_brb09,"'", 
            " ORDER BY 1"
        END IF     
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
            #來源碼為'D'不應出來
            IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
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
           IF l_ima910[l_ac]=' ' THEN LET l_ima910[l_ac]=p_key2 END IF  #No.MOD-8C0148 add
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
        #若無下階料,工單展開選項為'3:展開'時的設定
        IF l_x = 0 THEN 
            LET l_fs_insert = 'Y'
        END IF
        LET l_t_fs_insert = l_fs_insert
        LET g_fs_insert = l_fs_insert
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #operation sequence number
            IF sr[l_i].brb09 IS NOT NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].brb09
                LET g_offset=sr[l_i].brb18
            END IF
            #-->無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
            IF g_yld='N' THEN LET sr[l_i].brb08=0 END IF
             LET l_brb06=sr[l_i].brb06/sr[l_i].brb07
             CALL cralc5_rate(p_key,sr[l_i].brb03,p_total,sr[l_i].brb081,sr[l_i].brb08,sr[l_i].brb082,l_brb06,p_QPA) 
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
            IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
                LET sr[l_i].brb10=sr[l_i].ima25
                LET l_total=l_total*sr[l_i].brb10_fac    #原發
                LET l_total2=l_total2*sr[l_i].brb10_fac    #應發
                LET sr[l_i].brb10_fac=1
            END IF
 
            LET l_bml04=NULL
 
            DECLARE bml_cur1 CURSOR FOR
            SELECT bml04,bml03 FROM bml_file
             WHERE bml01=sr[l_i].brb03 
               AND (bml02=p_key OR bml02='ALL')
               ORDER BY bml03
            FOREACH bml_cur1 INTO l_bml04,g_i 
               EXIT FOREACH 
            END FOREACH
 
            IF sr[l_i].ima08!='X' OR g_btflg='N' OR
               (sr[l_i].ima08='X' AND g_btflg='Y' AND sr[l_i].bra01 IS NULL) OR
                (sr[l_i].ima37='1' AND g_mps='N') THEN #MPS part
 
                LET fs_insert = 'Y'
                IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
                LET l_uuc=0
                IF fs_insert = 'Y' THEN
                INITIALIZE g_sfa.* TO NULL
                LET g_sfa.sfa01 =g_wo
                LET g_sfa.sfa02 =g_wotype
                LET g_sfa.sfa03 =sr[l_i].brb03
                LET g_sfa.sfa04 =l_total
                LET g_sfa.sfa05 =l_total2
                LET g_sfa.sfa06 =0
                LET g_sfa.sfa061=0
                LET g_sfa.sfa062=0
                LET g_sfa.sfa063=0
                LET g_sfa.sfa064=0
                LET g_sfa.sfa065=0
                LET g_sfa.sfa066=0
                LET g_sfa.sfa08 =g_opseq
                IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
                LET g_sfa.sfa09 =g_offset
                LET g_sfa.sfa11 =l_sfa11
                LET g_sfa.sfa12 =sr[l_i].brb10
                LET g_sfa.sfa13 =sr[l_i].brb10_fac
                LET g_sfa.sfa14 =sr[l_i].ima86
                LET g_sfa.sfa15 =sr[l_i].brb10_fac2
                LET g_sfa.sfa16 =l_QPA
                LET g_sfa.sfa161=l_ActualQPA
                LET g_sfa.sfa25 =l_uuc
                LET g_sfa.sfa26 =sr[l_i].brb16
                LET g_sfa.sfa27 =sr[l_i].brb03
                LET g_sfa.sfa28 =1
                LET g_sfa.sfa29 =p_key
                LET g_sfa.sfa30 =sr[l_i].brb25
                LET g_sfa.sfa31 =sr[l_i].brb26
                LET g_sfa.sfa36 =l_bml04   
                LET g_sfa.sfa32 = sr[l_i].brb31
                LET g_sfa.sfa012=sr[l_i].brb012
                LET g_sfa.sfa013=sr[l_i].brb013
                IF g_sfb.sfb02 = '7' THEN 
                   IF g_sfa.sfa32 = 'Y' THEN
                      LET g_sfa.sfa065 = g_sfa.sfa05
                   END IF
                END IF
                LET g_sfa.sfaacti ='Y'
                LET g_sfa.sfaplant=g_plant  
                LET g_sfa.sfalegal=g_legal  
                LET g_sfa.sfa100 =sr[l_i].brb28
                IF cl_null(g_sfa.sfa100) THEN
                   LET g_sfa.sfa100 = 0
                END IF
#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
                LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)   #FUN-BB0085
                LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)   #FUN-BB0085
                LET g_sfa.sfa161=g_sfa.sfa05/g_sfb.sfb08 #重計實際QPA NO.3494
                IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  
                IF cl_null(g_sfa.sfa012) THEN LET g_sfa.sfa012=' ' END IF  
                IF cl_null(g_sfa.sfa013) THEN LET g_sfa.sfa013=0   END IF 
                INSERT INTO sfa_file VALUES(g_sfa.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                            FROM sfa_file
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                                AND sfa08=g_opseq
                        LET l_sfa13=sr[l_i].brb10_fac/l_sfa13
                        LET l_total=l_total*l_sfa13
                        LET l_total2=l_total2*l_sfa13
                        #CHI-980013--begin--add--
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].brb10
                           AND sfa27=sr[l_i].brb03 
                           AND sfa012=g_sfa.sfa012
                           AND sfa013=g_sfa.sfa013
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET g_sfa.sfa161 = 0 END IF
                         #CHI-980013--end--add
                        LET l_total = s_digqty(l_total,g_sfa.sfa012)       #FUN-BB0085
                        LET l_total2= s_digqty(l_total2,g_sfa.sfa012)      #FUN-BB0085
                        UPDATE sfa_file
                            SET sfa04=sfa04+l_total,
                                sfa05=sfa05+l_total2,
                                sfa16=sfa16+l_QPA,         
                                sfa161=g_sfa.sfa161
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].brb03
                              AND sfa08=g_opseq AND sfa12=sr[l_i].brb10
                              AND sfa27=sr[l_i].brb03
                              AND sfa012=g_sfa.sfa012
                              AND sfa013=g_sfa.sfa013
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                           ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                           CONTINUE FOR
                        END IF
                    END IF
                ELSE                  
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = g_sfa.sfa01
                      LET l_sfai.sfai03 = g_sfa.sfa03
                      LET l_sfai.sfai08 = g_sfa.sfa08
                      LET l_sfai.sfai12 = g_sfa.sfa12
                      LET l_sfai.sfai27 = g_sfa.sfa27  
                      LET l_sfai.sfai012= g_sfa.sfa012
                      LET l_sfai.sfai013= g_sfa.sfa013
                      LET l_flag = s_ins_sfai(l_sfai.*,'')
                   
                END IF
              END IF
              LET g_ccc = g_ccc + 1
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
    #-->避免 'X' PART 重複計算
    IF p_level >1 THEN RETURN END IF
 
    #-->重新把資料拿出來處理
    DECLARE cr_cr4 CURSOR FOR
        SELECT sfa_file.*,    
            ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 
        FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03 = ima01 
        WHERE sfa01=g_wo 
 
    FOREACH cr_cr4 INTO g_sfa.*,l_ima08,l_avl_stk,   
                         l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
        SELECT sfa03 INTO l_sfa03  FROM sfa_file
        WHERE sfa01=g_wo 
        CALL s_getstock(l_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET g_opseq=g_sfa.sfa08
        IF g_sfa.sfa26 MATCHES '[SUTZ]' THEN CONTINUE FOREACH END IF 
       #----來源碼為'D'者不應出現
        IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF  #97/08/20 modify
        MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
        LET l_sfa03 = g_sfa.sfa03
 
        #Inflate With Minimum Issue Qty And Issue Pansize
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF 
        IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
           LET g_sfa.sfa05=l_ima641
        END IF
        IF l_ima64!=0 THEN
           LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999
           LET g_sfa.sfa05=l_double*l_ima64
        END IF
        IF g_sfa.sfa11 = 'S' THEN   LET g_sfa.sfa05=g_sfa.sfa05 * (-1)  END IF
 
        #-->考慮單位小數取位 
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sfa.sfa12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         CALL cl_digcut(g_sfa.sfa05,l_gfe03) RETURNING l_sfaqty
         LET g_sfa.sfa05 =  l_sfaqty
       
        IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF 
        LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A2044
        IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF 
        CASE
         WHEN g_sfa.sfa26='1' AND g_sma.sma66='Y'	## UTE:先備舊料,再備新料
              LET l_bal=g_sfa.sfa05	            	##應發量
              LET l_unaloc=0
              LET l_s=0                             	##取替代是否成功#
              CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
              g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
              g_sfa.sfa13,g_sfa.sfa15,l_bal,
              g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s
              IF l_s THEN       ##發生取代
                 LET g_sfa.sfa26='3'            # 原來'2' 
                 LET l_total2=l_unaloc
              ELSE 
                   LET g_sfa.sfa26='1'
                   LET l_total2=g_sfa.sfa05
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp 
              END IF
         WHEN g_sfa.sfa26='2' AND g_sma.sma67='Y'	##先備正料,再備替代料
              LET l_total2=g_sfa.sfa05
              #-------------------------- 扣除其他工單備料量(971021 Roger)
               SELECT SUM((sfa05-sfa06-sfa065)*sfa13) INTO l_qty  
                FROM sfa_file,sfb_file
               WHERE sfa03=g_sfa.sfa03
                 AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04<>'8'
                  AND sfb87<>'X'
                 AND sfa01<>g_wo
              IF l_qty IS NULL THEN LET l_qty=0 END IF
              LET l_avl_stk_mpsmrp=l_avl_stk_mpsmrp-l_qty #FUN-A20044
              IF l_avl_stk_mpsmrp < 0 THEN LET l_avl_stk_mpsmrp=0 END IF 
              #------------------------------------------------------------
              LET l_bal=l_total2-l_avl_stk_mpsmrp  #FUN-A20044
              LET l_unaloc=0
              LET l_s=0                             	##取替代是否成功#
              IF l_bal>0 THEN
                CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
                g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
                g_sfa.sfa13,g_sfa.sfa15,l_bal,
                g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s
              END IF
              IF l_s THEN       ##發生替代
                 LET g_sfa.sfa26='4'            # 原來'2' 970620 Roger
                 LET l_total2=(l_avl_stk_mpsmrp+l_unaloc) 
              ELSE 
                   LET g_sfa.sfa26='2'          # 原來'1' 970620 Roger 
                   LET l_total2=g_sfa.sfa05
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp 
              END IF
         WHEN g_sfa.sfa26='7' AND g_sma.sma67='Y'	
              LET l_total2=g_sfa.sfa05
               SELECT SUM(sfa05-sfa06-sfa065) INTO l_qty 
                FROM sfa_file,sfb_file
               WHERE sfa03=g_sfa.sfa03
                 AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04<>'8'
                  AND sfb87<>'X'                        
                 AND sfa01<>g_wo
              IF l_qty IS NULL THEN LET l_qty=0 END IF
              LET l_avl_stk_mpsmrp=l_avl_stk_mpsmrp-l_qty #FUN-A20044
              IF l_avl_stk_mpsmrp < 0 THEN LET l_avl_stk_mpsmrp=0 END IF 
              #------------------------------------------------------------
              LET l_bal=l_total2-l_avl_stk_mpsmrp #FUN-A20044
              LET l_unaloc=0
              LET l_s=0                             
              IF l_bal>0 THEN
                CALL cralc5_sou(g_sfa.sfa03,g_sfa.sfa26,
                g_sfa.sfa09,g_sfa.sfa161,g_sfa.sfa12,
                g_sfa.sfa13,g_sfa.sfa15,l_bal,
                g_sfa.sfa11,g_sfa.sfa29,g_sfa.sfa012,g_sfa.sfa013) RETURNING l_unaloc,l_s
              END IF
              IF l_s THEN      
                 LET g_sfa.sfa26='8'            
                 LET l_total2=(l_avl_stk_mpsmrp+l_unaloc) 
              ELSE 
                   LET g_sfa.sfa26='7'         
                   LET l_total2=g_sfa.sfa05
                   LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp
              END IF              
         OTHERWISE
              LET l_total2=g_sfa.sfa05
              LET l_unaloc=g_sfa.sfa05-l_avl_stk_mpsmrp 
        END CASE
           IF l_unaloc < 0 THEN LET l_unaloc=0 END IF
           LET l_total2 = s_digqty(l_total2,g_sfa.sfa12)     #FUN-BB0085
           LET l_unaloc = s_digqty(l_unaloc,g_sfa.sfa12)     #FUN-BB0085
           LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494 
           IF g_sfa.sfa11 = 'X' THEN LET l_total2 = 0 LET g_sfa.sfa161 = 0 END IF 
           UPDATE sfa_file SET sfa05 = l_total2,
                               sfa25 = l_unaloc,
                               sfa26 = g_sfa.sfa26,
                               sfa161= g_sfa.sfa161  
                  WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03 AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12 AND sfa27 = g_sfa.sfa27    
                    AND sfa012=g_sfa.sfa012 AND sfa013=g_sfa.sfa013  #FUN-A50066
    END FOREACH
END FUNCTION
#FUN-A50066--end--add-----------------------------------------
