# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_cralc6.4gl
# Descriptions...: 依合拼版資料產生備料資料
# Date & Author..: 91/12/23 By jan(FUN-A80054)
# Usage..........: CALL s_cralc6(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
#                               p_edg01,p_edg02,p_sfd07)
#                       RETURNING l_cnt
# Input Parameter: p_wo        工單編號
#                  p_wotype    工單型態
#                  p_part      料件編號
#                  p_btflg     是否展開下階(sma29)
#                  p_woq       工單數量
#                  p_date      有效日期
#                  p_mps       MPS料件是否展開
#                  p_yld       損耗率
#                  p_edg01     PBI單號
#                  p_edg02     PBI項次
#                  p_sfd07     被取代製程段      
# Modify.........: No:FUN-A90056 10/09/23 By sabrina  補過單
# Modify.........: No:FUN-A30093 10/09/30 By jan bmb14='3'時，產生工單備料時，sfa11為'C'
# Modify.........: No:TQC-BB0174 11/11/18 By lilingyu 原發數量sfa04,應發數量sfa05可能出現NULL值，導致無法產生備料
# Modify.........: No.FUN-BB0085 11/12/12 By xianghui 增加數量欄位小數取位

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
    g_btflg      LIKE type_file.chr1,         
    g_wo         LIKE sfa_file.sfa01,         
    g_wotype     LIKE type_file.num5,         
    g_level      LIKE type_file.num5,         
    g_ccc        LIKE type_file.num5,         
    g_SOUCode    LIKE type_file.chr1,         
    g_mps        LIKE type_file.chr1,         
    g_yld        LIKE type_file.chr1,         
    g_factor     LIKE bmb_file.bmb06,         
    g_date       LIKE type_file.dat,          
    g_fs_insert  LIKE type_file.chr1          
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  
FUNCTION s_cralc6(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
                 p_edg01,p_edg02,p_sfd07)  
DEFINE
    p_wo         LIKE sfa_file.sfa01,     
    p_wotype     LIKE type_file.num5,     
    p_part       LIKE ima_file.ima01,     
    p_btflg      LIKE type_file.chr1,     
    p_woq        LIKE sfa_file.sfa04,     
    p_date       LIKE type_file.dat,      
    p_mps        LIKE type_file.chr1,     
    p_yld        LIKE type_file.chr1,     
    p_edg01      LIKE edg_file.edg01,
    p_edg02      LIKE edg_file.edg02,
    p_sfd07      LIKE sfd_file.sfd07,
    l_ima562     LIKE ima_file.ima562
   DEFINE l_ima910   LIKE ima_file.ima910    
   DEFINE l_n        LIKE type_file.num5   
   DEFINE l_edg03    LIKE edg_file.edg03
 
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
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wo
    IF STATUS THEN 
       CALL cl_err3("sel","sfb_file",p_wo,"",STATUS,"","",1) 
       LET g_success = 'N'
       RETURN 
    END IF
    SELECT ima562,ima55,ima55_fac,ima86,ima86_fac INTO 
      l_ima562,g_ima55,g_ima55_fac,g_ima86,g_ima86_fac
        FROM ima_file
        WHERE ima01=p_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN LET g_success='N' RETURN END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
                                                  
    LET l_ima910=''
    SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
    IF p_wotype=5 OR p_wotype=11 OR p_wotype=8 THEN    
        RETURN                   
    ELSE
       DECLARE edg_cur CURSOR FOR
        SELECT distinct edg03 FROM edg_file
         WHERE edg01=p_edg01
           AND edg02=p_edg02 
           ORDER BY edg03
       FOREACH edg_cur INTO l_edg03
         CALL cralc_edh_bom(0,p_part,p_edg01,p_edg02,l_edg03,p_sfd07,p_woq,1)
       END FOREACH
    END IF
    IF g_ccc=0
       THEN LET g_errno='asf-014' 			#有BOM但無有效者
       ELSE UPDATE sfb_file SET sfb23='Y' WHERE sfb01=p_wo
    END IF
    
END FUNCTION

FUNCTION cralc_edh_bom(p_level,p_key,p_edg01,p_edg02,p_edg03,p_sfd07,p_total,p_QPA)  
DEFINE
    p_level        LIKE type_file.num5,          
    p_total        LIKE edh_file.edh06, 
    p_QPA          LIKE edh_file.edh06,  
    l_QPA          LIKE edh_file.edh06, 
    l_total        LIKE sfa_file.sfa07,    #原發數量
    l_total2       LIKE sfa_file.sfa07,    #應發數量
    l_total3       LIKE sfa_file.sfa07, 
    p_key          LIKE bra_file.bra01,  
    p_edg01        LIKE edg_file.edg01,
    p_edg02        LIKE edg_file.edg02,
    p_edg03        LIKE edg_file.edg03,
    p_sfd07        LIKE sfd_file.sfd07, 
    l_ac,l_i,l_x,l_s LIKE type_file.num5,
    arrno          LIKE type_file.num5, 
    b_seq,l_double LIKE type_file.num10, 
    sr ARRAY[500] OF RECORD  #array for storage
       edh02       LIKE edh_file.edh02, #SEQ
       edh03       LIKE edh_file.edh03, #component part number
       edh10       LIKE edh_file.edh10, #Issuing UOM
       edh10_fac   LIKE edh_file.edh10_fac,#Issuing UOM to stock transfer rate
       edh10_fac2  LIKE edh_file.edh10_fac2,#Issuing UOM to cost transfer rate
       edh15       LIKE edh_file.edh15, #consumable part flag
       edh16       LIKE edh_file.edh16, #substitable flag
       edh06       LIKE edh_file.edh06, #QPA
       edh08       LIKE edh_file.edh08, #yield
       edh081     LIKE edh_file.edh081,
       edh082     LIKE edh_file.edh082,
       edh09       LIKE edh_file.edh09, #operation sequence number
       edh18       LIKE edh_file.edh18, #days offset
       edh19       LIKE edh_file.edh19, #1.不展開 2.不展開但自動開立工單 3.展開:top40
       edh28       LIKE edh_file.edh28, #允許發料誤差
       edh25       LIKE edh_file.edh25, #倉庫   
       edh26       LIKE edh_file.edh26, #儲位   
       edh14       LIKE edh_file.edh14, 
       ima08       LIKE ima_file.ima08, #source code
       ima37       LIKE ima_file.ima37, #OPC
       ima25       LIKE ima_file.ima25, #UOM
       ima55       LIKE ima_file.ima55, #生產單位
       ima86       LIKE ima_file.ima86, #COST UNIT
       ima86_fac   LIKE ima_file.ima86_fac, #
       edh07       LIKE edh_file.edh07, #底數  
       edh31       LIKe edh_file.edh31,   
       edh29       LIKE edh_file.edh29,
       edh013      LIKE edh_file.edh013 
                   END RECORD,
    g_sfa RECORD  LIKE sfa_file.*,         #備料檔
    l_ima08        LIKE ima_file.ima08,    #source code
    l_SafetyStock  LIKE ima_file.ima27,
    l_ima37        LIKE ima_file.ima37,    #OPC
    l_ima108       LIKE ima_file.ima108,
    l_ima64        LIKE ima_file.ima64,    #Issue Pansize
    l_ima641       LIKE ima_file.ima641,   #Minimum Issue QTY
    l_chr          LIKE type_file.chr1,    #No.FUN-680147 VARCHAR(1)
    l_sfa03        LIKE sfa_file.sfa03,    #part No
    l_sfa11        LIKE sfa_file.sfa11,    #consumable flag
    l_sfaqty       LIKE sfa_file.sfa05,
    l_gfe03        LIKE gfe_file.gfe03, 
    l_ActualQPA    LIKE edh_file.edh06, 
    l_edh06        LIKE edh_file.edh06, 
    l_sfa13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_bml04        LIKE bml_file.bml04,    #指定廠商
    fs_insert      LIKE type_file.chr1, 
    l_fs_insert    LIKE type_file.chr1, 
    l_t_fs_insert    LIKE type_file.chr1, 
    g_sw           LIKE type_file.chr1,  
    l_unaloc,l_uuc LIKE sfa_file.sfa25,    #unallocated quantity
    l_cnt,l_c      LIKE type_file.num5, 
    l_cmd          LIKE type_file.chr1000  
DEFINE l_sfai      RECORD LIKE sfai_file.* 
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910
DEFINE l_sfa11_a   LIKE sfa_file.sfa11  
DEFINE l_total_1      LIKE sfa_file.sfa07   
DEFINE l_ActualQPA_1  LIKE edh_file.edh06     

    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            "SELECT edh02,edh03,edh10,edh10_fac,edh10_fac2,",
            "edh15,edh16,edh06,edh08,edh081,edh082,edh09,edh18,edh19,edh28,", 
            "edh25,edh26,edh14,", 
            "ima08,ima37,ima25,ima55,", 
            " ima86,ima86_fac,edh07,edh31,edh29,edh013", 
            " FROM edh_file LEFT OUTER JOIN ima_file ON ima01 = edh03 ",
            " WHERE edh01='", p_edg01,"' AND edh02>?",
            "   AND edh011 = ",p_edg02,
            "   AND edh013 = ",p_edg03,
            " AND (edh04 <='",g_date,
            "' OR edh04 IS NULL) AND (edh05 >'",g_date,
            "' OR edh05 IS NULL)",
            " ORDER BY 1"
        PREPARE cralc_edh_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('cralc_edh_ppp:',SQLCA.sqlcode,1) LET g_success = 'N' RETURN  END IF   
        DECLARE cralc_edh_cur CURSOR FOR cralc_edh_ppp
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_edh_cur USING b_seq INTO sr[l_ac].*
            #---- 來源碼為'D'不應出來
            IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
            #------------------------------
            #若換算率有問題, 則設為1
            IF sr[l_ac].edh10_fac IS NULL OR sr[l_ac].edh10_fac=0 THEN
                LET sr[l_ac].edh10_fac=1
            END IF
            IF sr[l_ac].edh16 IS NULL THEN    #若未定義, 則給予'正常'
               LET sr[l_ac].edh16='0'
            END IF
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].edh03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
        #MOD-7B0075---add---str---
        #若無下階料,工單展開選項為'3:展開'時的設定
        IF l_x = 0 THEN 
            LET l_fs_insert = 'Y'
        END IF
        LET l_t_fs_insert = l_fs_insert
        LET g_fs_insert = l_fs_insert
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            #operation sequence number
            IF sr[l_i].edh09 IS NOT NULL THEN
                LET g_level=p_level
                LET g_opseq=sr[l_i].edh09
                LET g_offset=sr[l_i].edh18
            END IF
            #-->無製程序號
            IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
            IF g_offset IS NULL THEN LET g_offset=0 END IF
            #-->inflate yield
            IF g_yld='N' THEN LET sr[l_i].edh08=0  END IF
            #-->Actual QPA
           #No.FUN-870117 --begin--                                                                                                
                              
            IF g_yld='N' THEN LET sr[l_i].edh08=0  END IF
            LET l_edh06=sr[l_i].edh06/sr[l_i].edh07
            CALL cralc_rate(p_key,sr[l_i].edh03,p_total,sr[l_i].edh081,sr[l_i].edh08,sr[l_i].edh082,l_edh06,p_QPA) 
            RETURNING l_total,l_QPA,l_ActualQPA
            LET l_total2=l_total
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
                LET l_sfa11='R'
            ELSE
                IF sr[l_i].edh15='Y' THEN #comsumable
                    LET l_sfa11='E'
                ELSE 
                    IF sr[l_i].ima08 MATCHES '[UV]' THEN
                        LET l_sfa11=sr[l_i].ima08
                    END IF
                END IF #consumable
            END IF
            IF sr[l_i].edh14 = '1' THEN 
               LET l_sfa11 = 'X'  
            END IF 
            IF sr[l_i].edh14 = '2' THEN 
               LET l_sfa11 = 'S' 
            END IF  
            IF sr[l_i].edh14 = '3' THEN   #FUN-A30093
               LET l_sfa11 = 'C'          #FUN-A30093
            END IF                        #FUN-A30093
            IF g_sfb.sfb39='2' THEN LET l_sfa11='E' END IF
 
            IF g_sma.sma78='1' THEN        #使用庫存單位
                LET sr[l_i].edh10=sr[l_i].ima25
                LET l_total=l_total*sr[l_i].edh10_fac    #原發
                LET l_total2=l_total2*sr[l_i].edh10_fac    #應發
                LET sr[l_i].edh10_fac=1
            END IF
            LET l_bml04=NULL
 
            DECLARE bml_cur1 CURSOR FOR
            SELECT bml04,bml03 FROM bml_file
             WHERE bml01=sr[l_i].edh03 
               AND (bml02=p_key OR bml02='ALL')
               ORDER BY bml03
 
            FOREACH bml_cur1 INTO l_bml04,g_i 
               EXIT FOREACH    
            END FOREACH  
 
 
            LET fs_insert = 'Y'
            IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
            LET l_uuc=0
            IF fs_insert = 'Y' AND sr[l_i].ima08 != 'X' THEN
                INITIALIZE g_sfa.* TO NULL
                LET g_sfa.sfa04 =l_total
                LET g_sfa.sfa05 =l_total2
                LET g_sfa.sfa161=l_ActualQPA  
                LET g_sfa.sfa01 =g_wo
                LET g_sfa.sfa02 =g_wotype
                LET g_sfa.sfa03 =sr[l_i].edh03      
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
                LET g_sfa.sfa12 =sr[l_i].edh10
                LET g_sfa.sfa13 =sr[l_i].edh10_fac
                LET g_sfa.sfa14 =sr[l_i].ima86
                LET g_sfa.sfa15 =sr[l_i].edh10_fac2
                LET g_sfa.sfa16 =l_QPA
                LET g_sfa.sfa25 =l_uuc
                LET g_sfa.sfa26 =sr[l_i].edh16
                LET g_sfa.sfa27 =sr[l_i].edh03
                LET g_sfa.sfa28 =1
                LET g_sfa.sfa29 =p_key
                LET g_sfa.sfa30 =sr[l_i].edh25
                LET g_sfa.sfa31 =sr[l_i].edh26
                LET g_sfa.sfa36 =l_bml04  
                LET g_sfa.sfa32 = sr[l_i].edh31
                LET g_sfa.sfa012=p_sfd07
                LET g_sfa.sfa013=sr[l_i].edh013
                IF g_sfb.sfb02 = '7' THEN 
                   IF g_sfa.sfa32 = 'Y' THEN
                      LET g_sfa.sfa065 = g_sfa.sfa05
                   END IF
                END IF
                LET g_sfa.sfaacti ='Y'
                LET g_sfa.sfaplant=g_plant 
                LET g_sfa.sfalegal=g_legal
                LET g_sfa.sfa100 =sr[l_i].edh28
                IF cl_null(g_sfa.sfa100) THEN
                   LET g_sfa.sfa100 = 0
                END IF

#TQC-BB0174 --begin--
               IF cl_null(g_sfa.sfa04) THEN LET g_sfa.sfa04 = 0 END IF
               IF cl_null(g_sfa.sfa05) THEN LET g_sfa.sfa05 = 0 END IF
#TQC-BB0174 --end--
                LET g_sfa.sfa04 = s_digqty(g_sfa.sfa04,g_sfa.sfa12)     #FUN-BB0085
                LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)     #FUN-BB0085

                LET g_sfa.sfa161=g_sfa.sfa05/g_sfb.sfb08 #重計實際QPA NO.3494
                IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END  IF    
                IF cl_null(g_sfa.sfa012) THEN
                   LET g_sfa.sfa012=' ' 
                   LET g_sfa.sfa013=0
                END IF  
                INSERT INTO sfa_file VALUES(g_sfa.*)
                   IF SQLCA.SQLCODE THEN    #Duplicate
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                            FROM sfa_file
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].edh03
                              AND sfa08=g_opseq
                        LET l_sfa13=sr[l_i].edh10_fac/l_sfa13
                        LET l_total=l_total*l_sfa13
                        LET l_total2=l_total2*l_sfa13
                        LET l_total3=g_sfa.sfa065 * l_sfa13  
                        IF cl_null(l_total3) THEN LET l_total3 = 0 END IF   
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file
                         WHERE sfa01=g_wo AND sfa03=sr[l_i].edh03
                           AND sfa08=g_opseq AND sfa12=sr[l_i].edh10
                           AND sfa27=sr[l_i].edh03
                           AND sfa012=g_sfa.sfa012
                           AND sfa013=g_sfa.sfa013
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 END IF
                        LET l_total = s_digqty(l_total,sr[l_i].edh10)     #FUN-BB0085
                        LET l_total2= s_digqty(l_total2,sr[l_i].edh10)    #FUN-BB0085
                        LET l_total3= s_digqty(l_total3,sr[l_i].edh10)    #FUN-BB0085
                        UPDATE sfa_file
                            SET sfa04=sfa04+l_total,
                                sfa05=sfa05+l_total2,
                                sfa065=sfa065+l_total3,  
                                sfa16=sfa16+l_QPA,         
                                sfa161=g_sfa.sfa161
                            WHERE sfa01=g_wo AND sfa03=sr[l_i].edh03
                                AND sfa08=g_opseq AND sfa12=sr[l_i].edh10
                                AND sfa27=sr[l_i].edh03 
                                AND sfa012=g_sfa.sfa012
                                AND sfa013=g_sfa.sfa013
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                           LET g_success='N'
                           CONTINUE FOR
                        END IF
                    ELSE
                       CALL cl_err('ins sfa',SQLCA.SQLCODE,1) LET g_success= 'N' RETURN
                    END IF
                ELSE
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = g_sfa.sfa01
                      LET l_sfai.sfai03 = g_sfa.sfa03
                      LET l_sfai.sfai08 = g_sfa.sfa08
                      LET l_sfai.sfai12 = g_sfa.sfa12
                      LET l_sfai.sfai27 = g_sfa.sfa27
                      LET l_sfai.sfai012 = g_sfa.sfa012 
                      LET l_sfai.sfai013 = g_sfa.sfa013
                      LET l_flag = s_ins_sfai(l_sfai.*,'')
                   END IF
                END IF
            END IF
            LET g_ccc = g_ccc + 1
            IF sr[l_i].ima08='X' THEN
                IF g_btflg='N' THEN #phantom
                    CONTINUE FOR #do'nt blow through
                ELSE
                    IF sr[l_i].ima37='1' AND g_mps='N' THEN #MPS part
                        CONTINUE FOR #do'nt blow through
                    END IF
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
            LET b_seq = sr[l_x].edh02
        END IF
    END WHILE
    
    DECLARE cr_cr3 CURSOR FOR
        SELECT sfa_file.*,
            ima08,ima27,ima37,ima108,ima64,ima641
        FROM sfa_file,OUTER ima_file                                                                                          
        WHERE sfa01=g_wo AND ima_file.ima01=sfa03  
 
    FOREACH cr_cr3 INTO g_sfa.*,l_ima08,
                        l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641
        SELECT sfa03 INTO l_sfa03  FROM sfa_file,OUTER ima_file  WHERE sfa01=g_wo AND ima_file.ima01=sfa03  
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET g_opseq=g_sfa.sfa08
        IF g_sfa.sfa26 MATCHES '[SUTZ]' THEN CONTINUE FOREACH END IF 
       #----來源碼為'D'者不應出現
        IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF  
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
       
        LET g_sfa.sfa05 = s_digqty(g_sfa.sfa05,g_sfa.sfa12)          #FUN-BB0085
        LET g_sfa.sfa161 = g_sfa.sfa05 / g_sfb.sfb08 #重計實際QPA NO.3494 
        IF g_sfa.sfa11 = 'X' THEN LET g_sfa.sfa05 = 0 LET g_sfa.sfa161 = 0 END IF  
        UPDATE sfa_file SET sfa05 = g_sfa.sfa05,
                            sfa161= g_sfa.sfa161 
         WHERE sfa01=g_sfa.sfa01 AND sfa03=g_sfa.sfa03 AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
           AND sfa27=g_sfa.sfa27 AND sfa012=g_sfa.sfa012 AND sfa013=g_sfa.sfa013
    END FOREACH
END FUNCTION
#FUN-A90056
