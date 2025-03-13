# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Pattern name...: s_cralc3.4gl
# Descriptions...: 產生產品備料資料-->試產性工單使用
# Date & Author..: 00/01/07 By Kammy
# Usage..........: CALL s_cralc3(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,
#                                p_mps,p_yld,,p_ver,p_wk,p_altno)
#                       RETURNING l_cnt
# Input Parameter: p_wo      工單編號
#                  p_wotype  工單型態
#                  p_part    料件編號
#                  p_btflg   虛擬料件是否下階(sma29)
#                  p_woq     工單數量
#                  p_date    有效日期
#                  p_mps     MPS料件是否展開
#                  p_yld     損耗率
#                  p_ver     E-BOM版本
#                  p_wk      試產性工單是否展至尾階(sma883)
#                  p_altno   特性代碼
# Return code....: l_cnt     備料筆數
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-560002 05/06/03 by wujie  單據編號修改
# Modify.........: No.FUN-560027 05/06/16 By Mandy 增加主特性代碼
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.MOD-530184 05/07/14 By pengu  預產性工單未判斷最少發料套數(ima64)
# Modify.........: No.TQC-610003 06/01/17 By Nicola 工單單身備料時多傳入參數－特性代碼, 並依特性代碼取 abmi600 資料展至工單單身(sfa_file)
# Modify.........; NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-790089 07/09/17 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.MOD-7A0127 07/10/23 By Carol l_total,l_total2數量變數型態改用 like sfa_file.sfa05
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-8C0148 08/12/16 By chenyu ima910沒有維護時，還是用sfb95
# Modify.........: No.FUN-940008 09/05/18 By hongmei 發料改善
# Modify.........: No.MOD-920354 09/05/26 By Pengu 沒勾asms270試產工單展至尾階, 遇到X.虛擬料件還是要展下階
# Modify.........: No.FUN-950088 09/07/01 By hongmei 將bel04帶到sfa36廠牌中
# Modify.........: No.TQC-970210 09/07/29 By dxfwo   s_cralc,s_cralc2,s_cralc3,s_cralc4,s_cralc5 沒有修改OUTER 問題
# Modify.........: No.MOD-980203 09/08/22 By Smapmin 料號存在測試與正式料件時,備料量會變二倍
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDARD
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-A30003 10/03/25 By destiy 修改工单备料时损耗计算方法
# Modify.........: No:TQC-A50052 10/05/17 By destiy 损耗率分量汇总计算时，实际QPA计算有误
# Modify.........: No:FUN-A60031 10/06/17 By destiy 重新计算损耗率
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝
# Modify.........: No:FUN-AC0104 10/12/25 By destiy 重新计算损耗率
# Modify.........: No:FUN-B60142 11/07/04 By jan 損耗量計算公式調整(增加sam1411參數)
# Modify.........: No:TQC-B80104 11/08/17 By houlia 增加bmaacti控管 
# Modify.........: No:TQC-BB0174 11/11/18 By lilingyu 原發數量sfa04,應發數量sfa05可能出現NULL值，導致無法產生備料
# Modify.........: No.FUN-BB0085 11/12/12 By xianghui 增加數量欄位小數取位
# Modify.........: No:CHI-D10011 13/01/11 By bart 展正式BOM

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
    g_sfa        RECORD LIKE sfa_file.*,
    g_sfb        RECORD LIKE sfb_file.*,
    g_opseq      LIKE sfa_file.sfa08, #operation sequence number
    g_offset     LIKE sfa_file.sfa09, #offset
    g_ima55      LIKE ima_file.ima55,
    g_ima55_fac  LIKE ima_file.ima55_fac,
    g_ima86      LIKE ima_file.ima86,
    g_ima86_fac  LIKE ima_file.ima86_fac,
    g_btflg      LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)          #blow through flag
    g_wo         LIKE sfa_file.sfa01,           #No.FUN-680147 VARCHAR(16)          #No.FUN-560002
    g_wotype     LIKE sfa_file.sfa02,           #No.FUN-680147 SMALLINT #work order type
    g_level      LIKE type_file.num5,           #No.FUN-680147 SMALLINT
    g_ccc        LIKE type_file.num5,           #No.FUN-680147 SMALLINT
    g_SOUCode    LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
    g_mps        LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
    g_wk         LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
    g_yld        LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
    g_ver        LIKE bmp_file.bmp011,          #No.FUN-680147 VARCHAR(04)
    g_factor     LIKE bmp_file.bmp06,           #No.FUN-680147 DEC(16,8)          # top40
    g_date       LIKE type_file.dat             #No.FUN-680147 DATE
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680147 INTEGER
DEFINE   g_status        LIKE type_file.num5       #No.FUN-680147 SMALLINT
DEFINE   g_part          LIKE ima_file.ima01 
FUNCTION s_cralc3(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
                  p_ver,p_wk,p_altno)  #No.TQC-610003
DEFINE
   p_wo     LIKE sfa_file.sfa01,           #No.FUN-680147 VARCHAR(16) #No.FUN-560002
   p_wotype LIKE type_file.num5,           #No.FUN-680147 SMALLINT #work order type
   p_part   like bmq_file.bmq01,           #part number  #No.MOD-490217
   p_code   like bmq_file.bmq910,          #主特性代碼   #FUN-560027 add
   p_btflg  LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01) #blow through flag
   p_woq    LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(11,3) #work order quantity
   p_date   LIKE type_file.dat,            #No.FUN-680147 DATE                   #effective date
   p_mps    LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)               #if MPS phantom, blow through flag (Y/N)
   p_yld    LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)              #inflate yield factor (Y/N)
   p_ver    LIKE bmp_file.bmp011,          #No.FUN-680147 VARCHAR(04)               #E-BOM version
   p_wk     LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)               #sma883
   p_altno  LIKE bma_file.bma06            #No.TQC-610003
 
   WHENEVER ERROR CALL cl_err_msg_log
   MESSAGE ' Allocating ' ATTRIBUTE(REVERSE)
   LET g_ccc  = 0
   LET g_date = p_date
   LET g_btflg= p_btflg
   LET g_wo   = p_wo
   LET g_wotype=p_wotype
   LET g_opseq =' '
   LET g_offset=0
   LET g_mps  = p_mps
   LET g_yld  = p_yld
   LET g_ver  = p_ver
   LET g_wk   = p_wk
   LET g_errno= ' '
   LET g_part=p_part
   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wo
   IF STATUS THEN 
      #CALL cl_err('sel sfb:',STATUS,1)  #FUN-670091
       CALL cl_err3("sel","sfb_file",p_wo,"",STATUS,"","",1) #FUN-670091
      RETURN 0 
   END IF
   #str-----mark by guanyao160704
   #LET p_code=''                                                      #FUN-560027 add
   #SELECT bmq910 INTO p_code                                          #FUN-560027 add
   # FROM bmq_file WHERE bmq01=p_part AND bmqacti='Y'                 
   #IF SQLCA.sqlcode THEN RETURN 0 END IF    
   #end----mark by guanyao160704
 
   IF p_code IS NULL THEN LET p_code = ' ' END IF                     #FUN-560027 add
                                                       
   #檢查該料件是否存在E-BOM中                                        
   SELECT COUNT(*) INTO g_cnt FROM bmp_file                          
    WHERE bmp01=p_part AND bmp011=p_ver                              
     #AND bmp28=p_code                                                #FUN-560027 add
      AND bmp28=p_altno     #No.TQC-610003
   IF g_cnt IS NULL OR g_cnt = 0 THEN
      LET g_errno='asf-015'
   ELSE
      CALL cralc_bom3(0,p_part,p_altno,p_woq,1,p_ver) #由BOM產生備料檔 #FUN-560027 add p_code #No.TQC-610003
      IF g_ccc=0
         THEN LET g_errno='asf-014'                       #有BOM但無有效者
         ELSE UPDATE sfb_file SET sfb23='Y' WHERE sfb01=p_wo
      END IF
   END IF
   
   MESSAGE ""
   RETURN g_ccc
 
END FUNCTION
 
FUNCTION cralc_bom3(p_level,p_key,p_key3,p_total,p_QPA,p_key2) #FUN-560027 add p_key3      #No.FUN-A30003
DEFINE
    p_level   LIKE type_file.num5,            #No.FUN-680147 SMALLINT #level code
    p_total   LIKE bmp_file.bmp06,            #No.FUN-680147 DECIMAL(13,5)
    p_QPA     LIKE bmb_file.bmb06,  #FUN-560230
    l_QPA     LIKE bmb_file.bmb06,  #FUN-560230
#MOD-7A0127-modify
#   l_total   LIKE bmp_file.bmp06,            #No.FUN-680147 DECIMAL(13,5)       #原發數量
#   l_total2  LIKE bmp_file.bmp06,            #No.FUN-680147 DECIMAL(13,5)      #應發數量
    l_total   LIKE sfa_file.sfa05,
    l_total2  LIKE sfa_file.sfa05,
#MOD-7A0127-modify-end
    p_key     LIKE bmo_file.bmo01,  #assembly part number
    p_key2    LIKE bmo_file.bmo011, #assembly part number
    p_key3    LIKE bmo_file.bmo06,  #FUN-560027 add
    arrno     LIKE type_file.num5,            #No.FUN-680147 SMALLINT            #BUFFER SIZE
    l_ac,l_i,l_x,l_s LIKE type_file.num5,     #No.FUN-680147 SMALLINT
    b_seq,l_double LIKE type_file.num10,      #No.FUN-680147 INTEGER #restart sequence (line number)
    sr ARRAY[500] OF RECORD  #array for storage
        sou        LIKE type_file.chr1,       #No.FUN-680147 VARCHAR(01)
        bmp02      LIKE bmp_file.bmp02, #SEQ
        bmp03      LIKE bmp_file.bmp03, #component part number
        bmp10      LIKE bmp_file.bmp10, #Issuing UOM
        bmp10_fac  LIKE bmp_file.bmp10_fac,#Issuing UOM to stock transfer rate
        bmp10_fac2 LIKE bmp_file.bmp10_fac2,#Issuing UOM to cost transfer rate
        bmp15      LIKE bmp_file.bmp15, #consumable part flag
        bmp16      LIKE bmp_file.bmp16, #substitable flag
        bmp06      LIKE bmp_file.bmp06, #QPA
        bmp08      LIKE bmp_file.bmp08, #yield
        bmp081     LIKE bmp_file.bmp081, #FUN-AC0104
        bmp082     LIKE bmp_file.bmp082, #FUN-AC0104
        bmp09      LIKE bmp_file.bmp09, #operation sequence number
        bmp18      LIKE bmp_file.bmp18, #days offset
        ima08      LIKE ima_file.ima08, #source code
        ima37      LIKE ima_file.ima37, #OPC
        ima25      LIKE ima_file.ima25, #UOM
        ima55      LIKE ima_file.ima55, #生產單位
        ima86      LIKE ima_file.ima86, #COST UNIT
        bmo01      LIKE bmo_file.bmo01, #No.MOD-490217 
        bma01      LIKE bma_file.bma01  #CHI-D10011
    END RECORD,
    g_sfa    RECORD  LIKE sfa_file.*,    #備料檔
    l_ima08  LIKE  ima_file.ima08, #source code
#    l_ima26  LIKE  ima_file.ima26, #QOH #FUN-A20044
    l_avl_stk_mpsmrp  LIKE  type_file.num15_3, #QOH #FUN-A20044
#    l_ima262 LIKE  ima_file.ima262,#QOH #FUN-A20044
    l_avl_stk LIKE  type_file.num15_3,#QOH #FUN-A20044
    l_SafetyStock LIKE ima_file.ima27,
    l_SSqty  LIKE  ima_file.ima27,
    l_ima37  LIKE  ima_file.ima37, #OPC
    l_ima108 LIKE  ima_file.ima108,
    l_ima64  LIKE  ima_file.ima64,    #Issue Pansize
    l_ima641 LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom    LIKE ima_file.ima25,        #Stock UOM
    l_chr    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    l_sfa07  LIKE sfa_file.sfa07, #quantity owed
    l_sfa03  LIKE sfa_file.sfa03, #part No
    l_sfa11  LIKE sfa_file.sfa11, #consumable flag
#    l_qty    LIKE ima_file.ima26, #issuing to stock qty #FUN-A20044
    l_qty    LIKE type_file.num15_3, #issuing to stock qty #FUN-A20044
    l_sfaqty LIKE sfa_file.sfa05,
    l_gfe03  LIKE gfe_file.gfe03, 
#    l_bal    LIKE ima_file.ima26, #balance (QOH-issue) #FUN-A20044
    l_bal    LIKE type_file.num15_3, #balance (QOH-issue) #FUN-A20044
    l_ActualQPA LIKE bmb_file.bmb06,  #FUN-560230
    l_sfa12  LIKE sfa_file.sfa12,    #發料單位
    l_sfa13  LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bel04  LIKE bel_file.bel04,    #指定廠商
    fs_insert  LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
    g_sw       LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c  LIKE type_file.num5,         #No.FUN-680147 SMALLINT 
    l_cmd      LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
DEFINE l_sfai  RECORD LIKE sfai_file.*      #No.FUN-7B0018
DEFINE l_flag  LIKE type_file.chr1          #No.FUN-7B0018
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
DEFINE l_bmaacti   LIKE bma_file.bmaacti   #TQC-B80104 add

    LET p_level = p_level + 1
    LET arrno = 500
    #-----MOD-980203---------
    #LET l_cmd=
    #        "SELECT '1',bmp02,bmp03,bmp10,bmp10_fac,bmp10_fac2,",
    #        "           bmp15,bmp16,bmp06/bmp07,bmp08,bmp09,bmp18,",
    #        "           ima08,ima37,ima25,ima55,",
    #        "           ima86,bmo01",
    #        " FROM bmp_file,ima_file,OUTER bmo_file",
    #        " WHERE bmp01='", p_key,"'",
    #        "   AND bmp011='", p_key2,"'",
    #        "   AND bmp28 ='", p_key3,"'", #FUN-560027 add
    #        #" AND bmp03 = bmo01",          #No.TQC-970210                                                                           
    #        " AND bmp03 = bmo_file.bmo01", #No.TQC-970210 
    #        " AND bmp03 = ima01",
    #        " UNION ",
    #        "SELECT '2',bmp02,bmp03,bmp10,bmp10_fac,bmp10_fac2,",
    #        "           bmp15,bmp16,bmp06/bmp07,bmp08,bmp09,bmp18,",
    #        "           bmq08,bmq37,bmq25,bmq55,",
    #        "           '',bmo01",
    #        " FROM bmp_file,bmq_file,OUTER bmo_file",
    #        " WHERE bmp01='", p_key,"'",
    #        "   AND bmp011='", p_key2,"'",
    #        "   AND bmp28 ='", p_key3,"'", #FUN-560027 add
    #        #" AND bmp03 = bmo01",          #No.TQC-970210                                                                           
    #        " AND bmp03 = bmo_file.bmo01", #No.TQC-970210
    #        " AND bmp03 = bmq01",
    #        " ORDER BY 2"
        #No.TQC-9B0015  --Begin
        LET l_cmd=
            "SELECT '',bmp02,bmp03,bmp10,bmp10_fac,bmp10_fac2,",
            "          bmp15,bmp16,bmp06/bmp07,bmp08,bmp081,bmp082,bmp09,bmp18,",  #FUN-AC0104 add bmp081,bmp082
            "          '','','','',",
            "          '',bmo01,bma01",  #CHI-D10011
            " FROM bmp_file LEFT OUTER JOIN bmo_file ",
            "               ON  bmp03 = bmo_file.bmo01",
            "               LEFT OUTER JOIN bma_file ",   #CHI-D10011
            "               ON  bmp03 = bma_file.bma01",  #CHI-D10011
            " WHERE bmp01='", p_key,"'",
            "   AND bmp011='", p_key2,"'",
            "   AND bmp28 ='", p_key3,"'", 
            " ORDER BY bmp02"
        #No.TQC-9B0015  --End  
    #-----END MOD-980203----- 
        PREPARE cralc_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur #USING b_seq    bugno:5721 marked.......
                INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmp03 CLIPPED
            #-----MOD-980203---------
            SELECT '1',ima08,ima37,ima25,ima55,ima86  
              INTO sr[l_ac].sou,sr[l_ac].ima08,sr[l_ac].ima37,
                   sr[l_ac].ima25,sr[l_ac].ima55,sr[l_ac].ima86
              FROM ima_file
             WHERE ima01 = sr[l_ac].bmp03
            IF STATUS THEN
               SELECT '2',bmq08,bmq37,bmq25,bmq55,''  
                 INTO sr[l_ac].sou,sr[l_ac].ima08,sr[l_ac].ima37,
                      sr[l_ac].ima25,sr[l_ac].ima55,sr[l_ac].ima86
                 FROM bmq_file
                WHERE bmq01 = sr[l_ac].bmp03
            END IF   
            #-----END MOD-980203-----
          #----97/08/20 modify 來源碼為'D'不應出來
            IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
          #------------------------------
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmp10_fac IS NULL OR sr[l_ac].bmp10_fac=0 THEN
                LET sr[l_ac].bmp10_fac=1
            END IF
            IF sr[l_ac].bmp16 IS NULL THEN    #若未定義, 則給予'正常'
                LET sr[l_ac].bmp16='0'
            END IF
            #TQC-B80104 --add
           LET l_bmaacti=''
            SELECT bmaacti INTO l_bmaacti FROM bma_file
             WHERE bma01 = p_key
               AND bma06 = p_key3
            IF l_bmaacti = 'N' THEN CONTINUE FOREACH END IF
            #TQC-B80104 --end
            #FUN-8B0015--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmp03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #IF l_ima910[l_ac]=' ' THEN LET l_ima910[l_ac]=p_key2 END IF   #No.MOD-8C0148 add   #MOD-980203
           #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #FUN-AC0104--begin--mark
            #若料件存在測試料件，且無下階料件則continue for
            #IF cl_null(sr[l_i].bmo01) AND sr[l_i].sou='2' THEN  #CHI-D10011
            IF cl_null(sr[l_i].bmo01) AND cl_null(sr[l_i].bma01) AND sr[l_i].sou='2' THEN  #CHI-D10011
               CONTINUE FOR
            END IF
            #FUN-AC0104--end--mark
            #operation sequence number
            IF sr[l_i].bmp09 IS NOT NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].bmp09
                LET g_offset=sr[l_i].bmp18
            END IF
            #-->無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
            #-->inflate yield
            #No.FUN-A60031--begin--mark
            #No.FUN-A30003--begin
#            LET l_bof06_1 = 0                                                                                                       
#            LET l_bof06_2 = 0                                                                                                 
#            SELECT bof06 INTO l_bof06_1 FROM bof_file                                                                                                                                           
#                         WHERE bof01 = p_key                                                                                 
#                           AND bof02 = '1'                                                                                          
#                           AND bof04 <= g_sfb.sfb08                                                                                 
#                           AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)                                                              
#                           AND bof03 = sr[l_i].bmp03                                                                                
#            IF l_bof06_1 >0 THEN                                                                                                    
#              LET sr[l_i].bmp08 = l_bof06_1                                                                                
#            END IF                                                                                                       
#            SELECT bof06 INTO l_bof06_2 FROM bof_file,ima_file    
#                          WHERE bof01 = p_key                                                                               
#                            AND bof02 = '2'                                                                                         
#                            AND bof04 <= g_sfb.sfb08                                                                                
#                            AND (bof05 >= g_sfb.sfb08 OR bof05 IS NULL)                                                             
#                            AND bof03 = ima10                                                                                       
#                            AND ima01 = sr[l_i].bmp03                                                                               
#            IF l_bof06_2 >0 THEN                                                                                                    
#              LET sr[l_i].bmp08 = l_bof06_2                                                                     
#            END IF         
            #No.FUN-A60031--end
            IF g_yld='N' THEN LET sr[l_i].bmp08=0 END IF
            #-->Actual QPA
##------99/07/16 modify 應發數量算法
            #FUN-AC0104--begin
            #LET l_ActualQPA=(sr[l_i].bmp06*(1+sr[l_i].bmp08/100))*p_QPA
            #LET l_QPA=sr[l_i].bmp06 * p_QPA     ##94/12/06 Add 該行 Jackson
            #LET l_total=sr[l_i].bmp06*p_total*((100+sr[l_i].bmp08))/100            
            CALL cralc3_rate(p_key,sr[l_i].bmp03,p_total,sr[l_i].bmp081,sr[l_i].bmp08,sr[l_i].bmp082,sr[l_i].bmp06,p_QPA) 
            RETURNING l_total,l_QPA,l_ActualQPA
            #FUN-AC0104--end
##-----------------------------
            LET l_total2=l_total
      #     LET l_sfa07=0   #FUN-940008 mark
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
      #         LET l_sfa07=l_total   #FUN-940008 mark
                LET l_sfa11='R'
            ELSE
                IF sr[l_i].bmp15='Y' THEN #comsumable
                    LET l_sfa11='E'
                ELSE 
                    IF sr[l_i].ima08 MATCHES '[UV]' THEN
                        LET l_sfa11=sr[l_i].ima08
                    END IF
                END IF #consumable
            END IF
            IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
               LET sr[l_i].bmp10 = sr[l_i].ima25
               LET l_total = l_total*sr[l_i].bmp10_fac    #原發
               LET l_total2 = l_total2*sr[l_i].bmp10_fac    #應發
               LET sr[l_i].bmp10_fac = 1
            END IF
           
            #---No.MOD-530184 add
            SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
             WHERE ima01 = sr[l_i].bmp03
            IF l_ima641 != 0 AND l_total2 < l_ima641 THEN
               LET l_total2 = l_ima641
            END IF
            IF l_ima64 != 0 THEN
               LET l_double = (l_total2 / l_ima64) + 0.999999
               LET l_total2 = l_double * l_ima64
            END IF
            #---end
 
            LET l_bel04 = NULL
            SELECT bel04 INTO l_bel04 FROM bel_file
             WHERE bel01 = sr[l_i].bmp03
               AND bel02 = p_key 
               AND bel03 = 1
               AND bel011 = p_key2
 
            LET fs_insert='Y'
            IF cl_null(sr[l_i].bma01) THEN  #CHI-D10011
               #若有下階且參數設定為試產性工單展至尾階
              #---------No.MOD-920354 modify
              #IF NOT cl_null(sr[l_i].bmo01) AND g_wk='Y' THEN
               IF NOT cl_null(sr[l_i].bmo01) AND (g_wk='Y'
                   OR (g_wk ='N' AND sr[l_i].ima08 = 'X')) THEN
              #---------No.MOD-920354 end
                  IF sr[l_i].ima08!='X'  OR (sr[l_i].ima08='X'AND g_btflg='Y') OR
                     (sr[l_i].ima37='1' AND g_mps='Y') THEN
 
                     IF sr[l_i].ima08='M' OR sr[l_i].ima08='X' THEN
                        #發料單位 -> 生產單位 factor  for top40
                        CALL s_umfchk(sr[l_i].bmp03,sr[l_i].bmp10,
                             sr[l_i].ima55) RETURNING g_status,g_factor  
 
                        LET sr[l_i].bmp06=sr[l_i].bmp06*g_factor
                        LET l_ActualQPA=(sr[l_i].bmp06+sr[l_i].bmp08/100)*p_QPA
 
                        #CALL cralc_bom3(p_level,sr[l_i].bmp03,' ',                  #FUN-560027 add ' ' #FUN-8B0015
                        #                p_total*sr[l_i].bmp06,l_ActualQPA,g_ver)
                        #CALL cralc_bom3(p_level,sr[l_i].bmp03,l_ima910[l_i],         #FUN-8B0015       #No.FUN-A30003
                        #                p_total*sr[l_i].bmp06,l_ActualQPA,g_ver)                       #No.FUN-A30003
                        CALL cralc_bom3(p_level,sr[l_i].bmp03,l_ima910[l_i],         #FUN-8B0015        #No.FUN-A30003
                                        p_total*sr[l_i].bmp06,l_ActualQPA,g_ver)                        #No.FUN-A30003 
                        LET fs_insert = 'N'
                    END IF
                  END IF
                  LET g_ccc = g_ccc + 1
               END IF
            #CHI-D10011---begin   
            ELSE 
               IF NOT cl_null(sr[l_i].bma01) AND (g_wk='Y'
                   OR (g_wk ='N' AND sr[l_i].ima08 = 'X')) THEN

                   IF sr[l_i].ima08!='X'  OR (sr[l_i].ima08='X'AND g_btflg='Y') OR
                     (sr[l_i].ima37='1' AND g_mps='Y') THEN
 
                     IF sr[l_i].ima08='M' OR sr[l_i].ima08='X' THEN
  
                        CALL s_umfchk(sr[l_i].bmp03,sr[l_i].bmp10,
                             sr[l_i].ima55) RETURNING g_status,g_factor  
 
                        LET sr[l_i].bmp06=sr[l_i].bmp06*g_factor
                        LET l_ActualQPA=(sr[l_i].bmp06+sr[l_i].bmp08/100)*p_QPA

                        CALL cralc_bom3_1(p_level,sr[l_i].bmp03,l_ima910[l_i],        
                                          p_total*sr[l_i].bmp06,l_ActualQPA,g_ver)                  
                        LET fs_insert = 'N'
                    END IF
                  END IF
                  LET g_ccc = g_ccc + 1
               END IF
            END IF 
            #CHI-D10011---end
            #---若非正式料件則不insert---
            IF sr[l_i].sou='2' THEN LET fs_insert='N' END IF
            #------
            IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
            LET l_uuc=0
            IF fs_insert = 'Y' THEN
               INITIALIZE g_sfa.* TO NULL            
               LET g_sfa.sfa01 =g_wo
               LET g_sfa.sfa02 =g_wotype
               LET g_sfa.sfa03 =sr[l_i].bmp03
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
               LET g_sfa.sfa12 =sr[l_i].bmp10
               LET g_sfa.sfa13 =sr[l_i].bmp10_fac
               LET g_sfa.sfa14 =sr[l_i].ima86
               LET g_sfa.sfa15 =sr[l_i].bmp10_fac2
               LET g_sfa.sfa16 =l_QPA
               LET g_sfa.sfa161=l_ActualQPA
               LET g_sfa.sfa25 =l_uuc
               LET g_sfa.sfa26 =sr[l_i].bmp16
               LET g_sfa.sfa27 =sr[l_i].bmp03
               LET g_sfa.sfa28 =1
               LET g_sfa.sfa29 =p_key
               LET g_sfa.sfa31 =l_bel04
               LET g_sfa.sfa36 =l_bel04   #FUN-950088 add
               # No.+114 Tommy
               IF cl_null(g_sfa.sfa100) THEN
                  LET g_sfa.sfa100 = 0
               END IF
               # End Tommy
               LET g_sfa.sfaacti ='Y'
               LET g_sfa.sfa161 = g_sfa.sfa05/g_sfb.sfb08           #No.FUN-A30003 
               LET g_sfa.sfaplant =g_plant #FUN-980012 add
               LET g_sfa.sfalegal =g_legal #FUN-980012 add
#FUN-A70125 --begin--
              IF cl_null(g_sfa.sfa012) THEN
                 LET g_sfa.sfa012 = ' '
              END IF 
              IF cl_null(g_sfa.sfa013) THEN
                 LET g_sfa.sfa013 = 0 
              END IF 
#FUN-A70125 --end--

#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
               LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)    #FUN-BB0085
               LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)    #FUN-BB0085

               INSERT INTO sfa_file VALUES(g_sfa.*)
               IF SQLCA.SQLCODE THEN    #Duplicate
                 #IF SQLCA.SQLCODE=-239 THEN                 #TQC-790089 mark
                  IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #TQC-790089 mod
                    #因為相同的料件可能有不同的發料單位, 故宜換算之
                    SELECT sfa13 INTO l_sfa13
                      FROM sfa_file
                     WHERE sfa01 = g_wo
                       AND sfa03 = sr[l_i].bmp03
                       AND sfa08 = g_opseq
                       AND sfa27 = sr[l_i].bmp03 #CHI-7B0034
                    LET l_sfa13 = sr[l_i].bmp10_fac/l_sfa13
                    LET l_total = l_total*l_sfa13
                    LET l_total2 = l_total2*l_sfa13
                    LET l_total = s_digqty(l_total,sr[l_i].bmp10)    #FUN-BB0085
                    LET l_total2= s_digqty(l_total2,sr[l_i].bmp10)   #FUN-BB0085
                    UPDATE sfa_file
                        SET sfa04=sfa04+l_total,
                            sfa05=sfa05+l_total2,
                           #sfa16=sfa16+sr[l_i].bmp06,  ##94/12/06 Jackson
                            sfa16=sfa16+l_QPA,         
                            sfa161=sfa161+l_ActualQPA
                        WHERE sfa01=g_wo AND sfa03=sr[l_i].bmp03
                            AND sfa08=g_opseq AND sfa12=sr[l_i].bmp10
                            AND sfa27=sr[l_i].bmp03 #CHI-7B0034
                    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                       ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                       CONTINUE FOR
                    END IF
                  END IF
               #NO.FUN-7B0018 08/02/25 add --begin
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_sfai.* TO NULL
                     LET l_sfai.sfai01 = g_sfa.sfa01
                     LET l_sfai.sfai03 = g_sfa.sfa03
                     LET l_sfai.sfai08 = g_sfa.sfa08
                     LET l_sfai.sfai12 = g_sfa.sfa12
                     LET l_sfai.sfai27 = g_sfa.sfa27 #CHI-7B0034
                     LET l_sfai.sfai012 = ' '        #FUN-A60027
                     LET l_sfai.sfai013 =  0         #FUN-A60027  
                     LET l_flag = s_ins_sfai(l_sfai.*,'')
                  END IF
               #NO.FUN-7B0018 08/02/25 add --end
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
           LET b_seq = sr[l_x].bmp02
        END IF
    END WHILE
    #-->避免 'X' PART 重複計算
    IF p_level >1 THEN RETURN END IF

END FUNCTION
#CHI-D10011---begin  展BOM
FUNCTION cralc_bom3_1(p_level,p_key,p_key3,p_total,p_QPA,p_key2)
DEFINE
    p_level   LIKE type_file.num5,           
    p_total   LIKE bmp_file.bmp06,           
    p_QPA     LIKE bmb_file.bmb06, 
    l_QPA     LIKE bmb_file.bmb06,  
    l_total   LIKE sfa_file.sfa05,
    l_total2  LIKE sfa_file.sfa05,
    p_key     LIKE bmo_file.bmo01,  
    p_key2    LIKE bmo_file.bmo011,
    p_key3    LIKE bmo_file.bmo06,  
    arrno     LIKE type_file.num5,            
    l_ac,l_i,l_x LIKE type_file.num5,     
    b_seq,l_double LIKE type_file.num10,     
    sr ARRAY[500] OF RECORD 
        sou        LIKE type_file.chr1,      
        bmb02      LIKE bmb_file.bmb02, 
        bmb03      LIKE bmb_file.bmb03, 
        bmb10      LIKE bmb_file.bmb10, 
        bmb10_fac  LIKE bmb_file.bmb10_fac,
        bmb10_fac2 LIKE bmb_file.bmb10_fac2,
        bmb15      LIKE bmb_file.bmb15, 
        bmb16      LIKE bmb_file.bmb16,
        bmb06      LIKE bmb_file.bmb06, 
        bmb08      LIKE bmb_file.bmb08, 
        bmb081     LIKE bmb_file.bmb081,
        bmb082     LIKE bmb_file.bmb082, 
        bmb09      LIKE bmb_file.bmb09, 
        bmb18      LIKE bmb_file.bmb18, 
        ima08      LIKE ima_file.ima08, 
        ima37      LIKE ima_file.ima37, 
        ima25      LIKE ima_file.ima25, 
        ima55      LIKE ima_file.ima55, 
        ima86      LIKE ima_file.ima86, 
        bma01      LIKE bma_file.bma01  
    END RECORD,
    g_sfa    RECORD  LIKE sfa_file.*,    #備料檔
    l_ima64  LIKE  ima_file.ima64,    #Issue Pansize
    l_ima641 LIKE ima_file.ima641,    #Minimum Issue QTY
    l_sfa11  LIKE sfa_file.sfa11, #consumable flag
    l_ActualQPA LIKE bmb_file.bmb06,  
    l_sfa13  LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bel04  LIKE bel_file.bel04,    #指定廠商
    fs_insert  LIKE type_file.chr1,   
    l_uuc LIKE sfa_file.sfa25,    
    l_cmd      LIKE type_file.chr1000     
DEFINE l_sfai  RECORD LIKE sfai_file.*      
DEFINE l_flag  LIKE type_file.chr1      
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910        
DEFINE l_bmaacti   LIKE bma_file.bmaacti   

    LET p_level = p_level + 1
    LET arrno = 500

        LET l_cmd=
            "SELECT '',bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
            "          bmb15,bmb16,bmb06/bmb07,bmb08,bmb081,bmb082,bmb09,bmb18,",  
            "          '','','','',",
            "          '',bma01",
            " FROM bmb_file LEFT OUTER JOIN bma_file ",
            "               ON  bmb03 = bma_file.bma01",
            " WHERE bmb01='", p_key,"'",
            "   AND bmb29 ='", p_key3,"'", 
            " ORDER BY bmb02"

        PREPARE cralc_ppp1 FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur1 CURSOR FOR cralc_ppp1
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur1 
                INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED

           LET l_bmaacti=''
            SELECT bmaacti INTO l_bmaacti FROM bma_file
             WHERE bma01 = p_key
               AND bma06 = p_key3
            IF l_bmaacti = 'N' THEN CONTINUE FOREACH END IF

            SELECT '1',ima08,ima37,ima25,ima55,ima86  
              INTO sr[l_ac].sou,sr[l_ac].ima08,sr[l_ac].ima37,
                   sr[l_ac].ima25,sr[l_ac].ima55,sr[l_ac].ima86
              FROM ima_file
             WHERE ima01 = sr[l_ac].bmb03
            IF STATUS THEN
               SELECT '2',bmq08,bmq37,bmq25,bmq55,''  
                 INTO sr[l_ac].sou,sr[l_ac].ima08,sr[l_ac].ima37,
                      sr[l_ac].ima25,sr[l_ac].ima55,sr[l_ac].ima86
                 FROM bmq_file
                WHERE bmq01 = sr[l_ac].bmb03
            END IF   

          #來源碼為'D'不應出來
            IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
          #------------------------------
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
                LET sr[l_ac].bmb10_fac=1
            END IF
            IF sr[l_ac].bmb16 IS NULL THEN    #若未定義, 則給予'正常'
                LET sr[l_ac].bmb16='0'
            END IF

            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF

            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #若料件存在測試料件，且無下階料件則continue for
            IF cl_null(sr[l_i].bma01) AND sr[l_i].sou='2' THEN
               CONTINUE FOR
            END IF
            #operation sequence number
            IF sr[l_i].bmb09 IS NOT NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].bmb09
                LET g_offset=sr[l_i].bmb18
            END IF
            #-->無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
            IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
         
            CALL cralc3_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA) 
            RETURNING l_total,l_QPA,l_ActualQPA

            LET l_total2=l_total
            LET l_sfa11='N'
            
            IF sr[l_i].ima08='R' THEN #routable part
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
            IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
               LET sr[l_i].bmb10 = sr[l_i].ima25
               LET l_total = l_total*sr[l_i].bmb10_fac    #原發
               LET l_total2 = l_total2*sr[l_i].bmb10_fac    #應發
               LET sr[l_i].bmb10_fac = 1
            END IF
           
            SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
             WHERE ima01 = sr[l_i].bmb03
            IF l_ima641 != 0 AND l_total2 < l_ima641 THEN
               LET l_total2 = l_ima641
            END IF
            IF l_ima64 != 0 THEN
               LET l_double = (l_total2 / l_ima64) + 0.999999
               LET l_total2 = l_double * l_ima64
            END IF
 
            LET l_bel04 = NULL
            SELECT bel04 INTO l_bel04 FROM bel_file
             WHERE bel01 = sr[l_i].bmb03
               AND bel02 = p_key 
               AND bel03 = 1
               AND bel011 = p_key2
 
            LET fs_insert='Y'
 
            #若有下階且參數設定為試產性工單展至尾階
            IF NOT cl_null(sr[l_i].bma01) AND (g_wk='Y'
                OR (g_wk ='N' AND sr[l_i].ima08 = 'X')) THEN
               IF sr[l_i].ima08!='X'  OR (sr[l_i].ima08='X'AND g_btflg='Y') OR
                  (sr[l_i].ima37='1' AND g_mps='Y') THEN
 
                  IF sr[l_i].ima08='M' OR sr[l_i].ima08='X' THEN
                     #發料單位 -> 生產單位 factor  for top40
                     CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                          sr[l_i].ima55) RETURNING g_status,g_factor  
 
                     LET sr[l_i].bmb06=sr[l_i].bmb06*g_factor
                     LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA

                     CALL cralc_bom3_1(p_level,sr[l_i].bmb03,l_ima910[l_i],  
                                     p_total*sr[l_i].bmb06,l_ActualQPA,g_ver)     
                     LET fs_insert = 'N'
                 END IF
               END IF
               LET g_ccc = g_ccc + 1
            END IF
            #---若非正式料件則不insert---
            IF sr[l_i].sou='2' THEN LET fs_insert='N' END IF
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
               LET g_sfa.sfa31 =l_bel04
               LET g_sfa.sfa36 =l_bel04  
               IF cl_null(g_sfa.sfa100) THEN
                  LET g_sfa.sfa100 = 0
               END IF
               LET g_sfa.sfaacti ='Y'
               LET g_sfa.sfa161 = g_sfa.sfa05/g_sfb.sfb08          
               LET g_sfa.sfaplant =g_plant 
               LET g_sfa.sfalegal =g_legal 

              IF cl_null(g_sfa.sfa012) THEN
                 LET g_sfa.sfa012 = ' '
              END IF 
              IF cl_null(g_sfa.sfa013) THEN
                 LET g_sfa.sfa013 = 0 
              END IF 

               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF

               INSERT INTO sfa_file VALUES(g_sfa.*)
               IF SQLCA.SQLCODE THEN    #Duplicate
                  IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   
                    #因為相同的料件可能有不同的發料單位, 故宜換算之
                    SELECT sfa13 INTO l_sfa13
                      FROM sfa_file
                     WHERE sfa01 = g_wo
                       AND sfa03 = sr[l_i].bmb03
                       AND sfa08 = g_opseq
                       AND sfa27 = sr[l_i].bmb03 
                    LET l_sfa13 = sr[l_i].bmb10_fac/l_sfa13
                    LET l_total = l_total*l_sfa13
                    LET l_total2 = l_total2*l_sfa13
                    UPDATE sfa_file
                        SET sfa04=sfa04+l_total,
                            sfa05=sfa05+l_total2,
                            sfa16=sfa16+l_QPA,         
                            sfa161=sfa161+l_ActualQPA
                        WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                            AND sfa08=g_opseq AND sfa12=sr[l_i].bmb10
                            AND sfa27=sr[l_i].bmb03 
                    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                       ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                       CONTINUE FOR
                    END IF
                  END IF
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_sfai.* TO NULL
                     LET l_sfai.sfai01 = g_sfa.sfa01
                     LET l_sfai.sfai03 = g_sfa.sfa03
                     LET l_sfai.sfai08 = g_sfa.sfa08
                     LET l_sfai.sfai12 = g_sfa.sfa12
                     LET l_sfai.sfai27 = g_sfa.sfa27 
                     LET l_sfai.sfai012 = ' '        
                     LET l_sfai.sfai013 =  0         
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
 
        IF l_x < arrno OR l_ac=1 THEN 
           EXIT WHILE
        ELSE
           LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    #-->避免 'X' PART 重複計算
    IF p_level >1 THEN RETURN END IF

END FUNCTION
#CHI-D10011---end
#FUN-AC0104--begin
#传入值 主件料号，元件料号，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
#返回值 元件备料量，标准QPA,实际QPA
FUNCTION cralc3_rate(p_bmb01,p_bmb03,p_total,p_bmb081,p_bmb08,p_bmb082,p_bmb06,p_QPA)
DEFINE  l_n         LIKE type_file.num5,
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
DEFINE l_bmb081     LIKE bmb_file.bmb081  #FUN-B60142
       
   IF cl_null(p_bmb08) THEN LET p_bmb08=0 END IF    #FUN-A60088
   IF cl_null(p_bmb081) THEN LET p_bmb081=0 END IF  #FUN-A60088
   IF cl_null(p_bmb082) THEN LET p_bmb082=1 END IF  #FUN-A60088
   SELECT COUNT(*) INTO l_n FROM bof_file WHERE bof01 = p_bmb01                                                                                  
                  AND bof02 = '1' AND bof03 = p_bmb03 
   #FUN-B60142--begin--add---
   IF l_n>0 THEN 
      SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file                                                  
       WHERE bof01 = p_bmb01 AND bof02 = '1' AND bof03 = p_bmb03                                                                                
         AND bof04 <= p_total AND (bof05 >= p_total OR bof05 IS NULL)                                                                  
   ELSE                                                                                                                          
      SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file,ima_file                                                           
       WHERE bof01 = p_bmb01 AND bof02 = '2' AND bof03 = ima10                                                                                       
         AND ima01 = p_bmb03 AND bof04 <= p_total
         AND (bof05 >= p_total OR bof05 IS NULL)    
   END IF 
   IF cl_null(l_bof06) THEN LET l_bof06=0 END IF
   IF cl_null(l_bof07) THEN LET l_bof07=0 END IF
   #FUN-B60142--end--add-----
   #损耗分量计算               
   IF g_sma.sma71='Y' AND g_sma.sma141='Y' THEN                
      IF l_n>0 THEN 
         LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file WHERE bof01 = '",p_bmb01 CLIPPED,"' ",                                                                                
                   "  AND bof02 = '1' AND bof03 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 " 
      ELSE 
         LET l_sql="SELECT bof04,bof05,bof06,bof07 FROM bof_file,ima_file WHERE bof01 = '",p_bmb01 CLIPPED,"' ",                                                                                 
                   "  AND bof02 = '2' AND bof03 = ima10 AND ima01 = '",p_bmb03 CLIPPED,"' ORDER BY bof05 "     	
      END IF                                                                                
      PREPARE cralc3_rate_p1 FROM l_sql 
      DECLARE cralc3_rate_c1 CURSOR FOR cralc3_rate_p1 
      LET l_cnt=1
      FOREACH cralc3_rate_c1 INTO sr[l_cnt].bof04,sr[l_cnt].bof05,sr[l_cnt].bof06,sr[l_cnt].bof07
         IF cl_null(sr[l_cnt].bof06) THEN 
            LET sr[l_cnt].bof06=0
         END IF 
         IF cl_null(sr[l_cnt].bof07) THEN 
            LET sr[l_cnt].bof07=0
         END IF          
         LET l_cnt=l_cnt+1
      END FOREACH    
      CALL sr.deleteElement(l_cnt) 
      #LET l_c=sr.getLength()
      LET l_c=l_cnt-1
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
        #IF t_total>sr[l_a].bof05 THEN   #FUN-B60142
         IF p_total>sr[l_a].bof05 THEN   #FUN-B60142
           #LET t_total=t_total-sr[l_a].bof05                    #FUN-B60142
            LET t_total=t_total-(sr[l_a].bof05-sr[l_a].bof04+1)  #FUN-B60142
           #LET sr1[l_a].total=p_bmb081*(1+sr[l_a].bof06/100)+p_bmb06*sr[l_a].bof05*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100) #FUN-AC0104 #FUN-B60142
            LET sr1[l_a].total=l_bmb081+p_bmb06*(sr[l_a].bof05-sr[l_a].bof04+1)*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100)  #FUN-B60142
            IF l_a=l_c THEN 
              #LET sr1[l_c+1].total=p_bmb081*1+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*1  #FUN-B60142
               LET sr1[l_c+1].total=p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*1             #FUN-B60142
            END IF 
         ELSE 
           #LET sr1[l_a].total=p_bmb081*(1+sr[l_a].bof06/100)+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100) #FUN-B60142
            LET sr1[l_a].total=l_bmb081+p_bmb06*t_total*(p_bmb08/100/(p_bmb082))*(1+sr[l_a].bof07/100)  #FUN-B60142
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
      LET l_total=l_total+p_total*p_bmb06    #No.FUN-A60080
      LET l_ActualQPA=l_total/p_total
      LET l_QPA=p_bmb06*p_QPA                #No.FUN-A60080
   END IF 
   #损耗不分量计算
  #IF g_sma.sma71='Y' AND g_sma.sma141='N' THEN  #TQC-AB0125
   IF g_sma.sma71='Y' AND (g_sma.sma141<>'Y' OR cl_null(g_sma.sma141)) THEN #TQC-AB0125 
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
      #   SELECT bof06,bof07 INTO l_bof06,l_bof07 FROM bof_file,ima_file                                                           
      #    WHERE bof01 = p_bmb01 AND bof02 = '2' AND bof03 = ima10                                                                                       
      #      AND ima01 = p_bmb03 AND bof04 <= p_total
      #      AND (bof05 >= p_total OR bof05 IS NULL)    
      #   IF cl_null(l_bof06) THEN                                                                                                    
      #      LET l_bof06=0                                                                                           
      #   END IF    
      #   IF cl_null(l_bof07)THEN                          
      #     LET l_bof07=0                                                                      
      #   END IF 
      #END IF 
      #FUN-B60142--end--mark----
      LET l_QPA=p_bmb06*p_QPA  
     #LET l_total=p_bmb081*(1+l_bof06/100)+ p_bmb06*p_total*(p_bmb08/(p_bmb082*100))*(1+l_bof07/100)     
      LET l_total=p_bmb081*(1+l_bof06/100)+ p_bmb06*p_total*(p_bmb08/100/(p_bmb082))*(1+l_bof07/100)   
      LET l_total=l_total+p_total*p_bmb06   #No.FUN-A60086
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
#FUN-AC0104--end
