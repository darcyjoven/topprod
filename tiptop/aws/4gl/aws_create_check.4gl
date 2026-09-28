# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 更新检验单数据
# Date & Author..: 2016-03-20 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_rvv32    LIKE rvv_file.rvv32    #仓库
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_rvv17    LIKE rvv_file.rvv17    #本次数量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql      STRING
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_rec_b_1 LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num10
DEFINE l_ac_t    LIKE type_file.num10
DEFINE li_step   LIKE type_file.num5
DEFINE g_img07   LIKE img_file.img07
DEFINE g_img09   LIKE img_file.img09
DEFINE g_img10   LIKE img_file.img10
DEFINE g_ima906  LIKE ima_file.ima906
DEFINE g_flag    LIKE type_file.chr1
DEFINE g_pmm     RECORD LIKE pmm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_qcs     RECORD LIKE qcs_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_sr     RECORD 
        rvu01    LIKE rvu_file.rvu01
                 END RECORD

END GLOBALS

#[
# Description....: 提供建立完工入庫單資料的服務(入口 function)
# Date & Author..: 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_check()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_check_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

END FUNCTION

#[
# Description....: 依據傳入資訊新增 ERP 完工入庫單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_check_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfu_file.sfuconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_flag1    LIKE type_file.chr1       #FUN-B70074
    DEFINE l_success    CHAR(1)
   DEFINE l_factor     DECIMAL(16,8)
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_img10      LIKE img_file.img10
   DEFINE l_ima108     LIKE ima_file.ima108
   DEFINE l_n          SMALLINT
   DEFINE l_length     LIKE type_file.num5
   DEFINE p_cmd        LIKE type_file.chr1    #處理狀態
   DEFINE l_t          LIKE type_file.num5
   DEFINE l_sql        STRING
   DEFINE l_msg        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(40)
   DEFINE l_qcd        RECORD LIKE qcd_file.*
   DEFINE l_qcs        RECORD LIKE qcs_file.*
   DEFINE l_qctt04     LIKE qctt_file.qctt04
   DEFINE l_qct05      LIKE qct_file.qct05
   DEFINE l_qct08      LIKE qct_file.qct08
   DEFINE l_qct14      LIKE qct_file.qct14
   DEFINE l_qct15      LIKE qct_file.qct15
   DEFINE l_avg           LIKE qctt_file.qctt04
   DEFINE l_sum           LIKE qctt_file.qctt04
   DEFINE l_stddev        LIKE qctt_file.qctt04
   DEFINE l_k_max         LIKE qctt_file.qctt04
   DEFINE l_k_min         LIKE qctt_file.qctt04
   DEFINE l_f             LIKE qctt_file.qctt04
   DEFINE l_chkqty        LIKE type_file.num15_3
   DEFINE l_rvb331        LIKE rvb_file.rvb331
   DEFINE l_rvb332        LIKE rvb_file.rvb332
   DEFINE l_ima906        LIKE ima_file.ima906
   DEFINE l_rvb33         LIKE rvb_file.rvb33
   DEFINE l_rvb07         LIKE rvb_file.rvb07
   DEFINE l_rvb30         LIKE rvb_file.rvb30  #MOD-640512
   DEFINE l_rvbs          RECORD LIKE rvbs_file.*  #No.FUN-850100
   DEFINE l_rvbs10        LIKE rvbs_file.rvbs10  #No.FUN-850100
   DEFINE l_rvbs09         LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_qcs091         LIKE qcs_file.qcs091    #FUN-870040
   DEFINE l_qcs38          LIKE qcs_file.qcs38     #FUN-870040
   DEFINE l_qcs41          LIKE qcs_file.qcs41     #FUN-870040
   DEFINE l_qct03          LIKE qct_file.qct03     #MOD-AB0143 add
   DEFINE l_qct04          LIKE qct_file.qct04     #MOD-AB0143 add
   DEFINE l_rvb90          LIKE rvb_file.rvb90
   DEFINE des1             LIKE ze_file.ze03       #No.TQC-610007
   DEFINE l_qct11          LIKE qct_file.qct11     #MOD-AB0143 add
   DEFINE l_check_file1      RECORD                    #单身
                    qct01      LIKE qct_file.qct01,         #收货单号
                    qct02      LIKE qct_file.qct02,         #项次
                    qct021     LIKE qct_file.qct021,        #顺序
                    qct03      LIKE qct_file.qct03,         #行序
                    qcs021     LIKE qcs_file.qcs021,        #料件编码
                    ima02      LIKE ima_file.ima02,         #品名
                    qct04      LIKE qct_file.qct04,         #检验项目
                    azf03      LIKE azf_file.azf03,         #项目说明
                    qct11      LIKE qct_file.qct11,         #抽样数量
                    qct09      LIKE qct_file.qct09,         #AC
                    qct10      LIKE qct_file.qct10,         #RE
                    qct07      LIKE qct_file.qct07          #不良数
                 END RECORD  
  DEFINE  l_check_file     RECORD
                    qct01      LIKE qct_file.qct01,         #收货单号
                    qct02      LIKE qct_file.qct02,         #项次
                    qct021     LIKE qct_file.qct021,        #顺序
                    qct03      LIKE qct_file.qct03,         #行序
                    qce01      LIKE qce_file.qce01,         #不良原因
                    qce03      LIKE qce_file.qce03,         #说明
                    qcu05      LIKE qcu_file.qcu05          #数量
                 END RECORD

    LET g_success = 'Y'
    INITIALIZE l_qcs.* TO NULL
    
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    BEGIN WORK
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_check_file1.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點

        LET l_check_file1.qct01  = aws_ttsrv_getRecordField(l_node1, "qct01")   #取得此筆單檔資料的欄位值
        LET l_check_file1.qct02  = aws_ttsrv_getRecordField(l_node1, "qct02")
        LET l_check_file1.qct021 = aws_ttsrv_getRecordField(l_node1, "qct021") 
        LET l_check_file1.qct03  = aws_ttsrv_getRecordField(l_node1, "qct03")   
        LET l_check_file1.qcs021 = aws_ttsrv_getRecordField(l_node1, "qcs021")
        LET l_check_file1.ima02  = aws_ttsrv_getRecordField(l_node1, "ima02")
        LET l_check_file1.qct04  = aws_ttsrv_getRecordField(l_node1, "qct04")
        LET l_check_file1.azf03  = aws_ttsrv_getRecordField(l_node1, "azf03")
        LET l_check_file1.qct11  = aws_ttsrv_getRecordField(l_node1, "qct11")
        LET l_check_file1.qct09  = aws_ttsrv_getRecordField(l_node1, "qct09")
        LET l_check_file1.qct10  = aws_ttsrv_getRecordField(l_node1, "qct10")
        LET l_check_file1.qct07  = aws_ttsrv_getRecordField(l_node1, "qct07")
        SELECT * INTO g_qcz.* FROM qcz_file
        CALL t110_get_qcd07(l_check_file1.qct01,l_check_file1.qct02,l_check_file1.qcs021,l_check_file1.qct04) RETURNING l_qcd.qcd07,l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062
        SELECT qct05,qct14,qct15 INTO l_qct05,l_qct14,l_qct15 FROM qct_file 
        WHERE qct01 = l_check_file1.qct01
          AND qct02 = l_check_file1.qct02
          AND qct021= l_check_file1.qct021
          AND qct03 = l_check_file1.qct03
        IF l_qcd.qcd05 ='4' THEN
            SELECT SUM(qctt04) INTO l_qctt04
              FROM qctt_file
             WHERE qctt01 = l_check_file1.qct01
               AND qctt02 = l_check_file1.qct02
               AND qctt021= l_check_file1.qct021
               AND qctt03 = l_check_file1.qct03
            IF cl_null(l_qctt04) THEN 
               LET l_qctt04 = 0
            END IF  
            LET l_avg = l_qctt04 / l_check_file1.qct11
            
            LET l_sum = 0 
            DECLARE qctt_sel CURSOR FOR 
              SELECT qctt04 FROM qctt_file
              WHERE qctt01 = l_check_file1.qct01
                AND qctt02 = l_check_file1.qct02
                AND qctt021= l_check_file1.qct021
                AND qctt03 = l_check_file1.qct03
            FOREACH qctt_sel INTO l_qctt04
              LET l_sum = l_sum + ((l_qctt04 - l_avg)*(l_qctt04 - l_avg))
            END FOREACH 
            LET l_stddev = s_power(l_sum/(l_check_file1.qct11 -1),2)
            LET l_k_max  = (l_qcd.qcd062 - l_avg)/l_stddev
            LET l_k_min  = (l_avg - l_qcd.qcd061)/l_stddev
            LET l_f      = l_stddev/(l_qcd.qcd062 - l_qcd.qcd061)
            IF cl_null(l_qcd.qcd061) OR cl_null(l_qcd.qcd061) THEN 
               IF cl_null(l_qcd.qcd061) THEN 
                  IF l_k_max >= l_qct14 THEN 
                     LET l_qct08 ='1'
                  ELSE
                  	 LET l_qct08 ='2'
                  END IF
               ELSE
                  IF l_k_min >= l_qct14 THEN 
                     LET l_qct08 ='1'
                  ELSE
                  	 LET l_qct08 ='2'
                  END IF 
               END IF 
            ELSE
            	 IF l_k_min >= l_qct14 AND l_k_max >= l_qct14 AND l_f >= l_qct15 THEN 
                  LET l_qct08 ='1'
               ELSE 
               	  LET l_qct08 ='2'
               END IF
            END IF
            UPDATE qct_file SET qct08=l_qct08,
                                qct07=l_check_file1.qct07
            WHERE qct01 = l_check_file1.qct01
              AND qct02 = l_check_file1.qct02
              AND qct021= l_check_file1.qct021
              AND qct03 = l_check_file1.qct03
        ELSE
#No.FUN-A80063 --end 
            #在判定合格或退貨時，應先將缺點數乘上CR/MA/MI權數
             CASE l_qct05
                 WHEN "1"
                       LET l_chkqty = l_check_file1.qct07*g_qcz.qcz02/g_qcz.qcz021  #No.TQC-750209 modify
                 WHEN "2"
                       LET l_chkqty = l_check_file1.qct07*g_qcz.qcz03/g_qcz.qcz031  #No.TQC-750209 modify 
                 WHEN "3" 
                       LET l_chkqty = l_check_file1.qct07*g_qcz.qcz04/g_qcz.qcz041  #No.TQC-750209 modify 
                 OTHERWISE
                       LET l_chkqty = l_check_file1.qct07                           #No.TQC-750209 modify
             END CASE
            #MOD-D30018 add start -----
             IF l_chkqty = 0 THEN
                LET l_qct08='1'
             ELSE
            #MOD-D30018 add end   -----
                IF l_chkqty>=l_check_file1.qct10 THEN           #No.TQC-750209 modify
                   LET l_qct08='2'
                ELSE
                   LET l_qct08='1'
                END IF
             END IF #MOD-D30018 add
            UPDATE qct_file SET qct08=l_qct08,
                                qct07=l_check_file1.qct07
             WHERE qct01 = l_check_file1.qct01
               AND qct02 = l_check_file1.qct02
               AND qct021= l_check_file1.qct021
               AND qct03 = l_check_file1.qct03
        END IF        #No.FUN-A80063    
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "Detail")       #取得目前單頭共有幾筆單身資料
        #IF l_cnt2 = 0 THEN
           #LET g_status.code = "mfg-009"   #必須有單身資料
           #EXIT FOR
           #CONTINUE FOR
        #END IF
#        DELETE FROM qcu_file WHERE qcu01  = l_check_file1.qct01 
#                               AND qcu02  = l_check_file1.qct02
#                               AND qcu021 = l_check_file1.qct021
#                               AND qcu03  = l_check_file1.qct03

#add--huxy160416---------Beg----------------
               LET l_check_file.qct01  = l_check_file1.qct01
               LET l_check_file.qct02  = l_check_file1.qct02
               LET l_check_file.qct021 = l_check_file1.qct021
               LET l_check_file.qct03  = l_check_file1.qct03
#add--huxy160416---------End----------------
        IF l_cnt2 > 0 THEN  #单身存在数据则继续
           FOR l_j = 1 TO l_cnt2
               INITIALIZE l_check_file.* TO NULL
               LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"Detail")   #目前單身的 XML 節點
               LET l_check_file.qct01  = l_check_file1.qct01
               LET l_check_file.qct02  = l_check_file1.qct02
               LET l_check_file.qct021 = l_check_file1.qct021
               LET l_check_file.qct03  = l_check_file1.qct03
               LET l_check_file.qce01  = aws_ttsrv_getRecordField(l_node2, "qce01")
               LET l_check_file.qce03  = aws_ttsrv_getRecordField(l_node2, "qce03")
               LET l_check_file.qcu05  = aws_ttsrv_getRecordField(l_node2, "qcu05")                   
               #------------------------------------------------------------------#
               # NODE資料傳到RECORD                                               #
               #------------------------------------------------------------------#
           
               INSERT INTO qcu_file VALUES (l_check_file.qct01,l_check_file.qct02,l_check_file.qct021,
               l_check_file.qct03,l_check_file.qce01,l_check_file.qcu05,'','',g_plant,g_legal)
               IF STATUS THEN
   	             LET g_status.code = -1
                 LET g_status.sqlcode = SQLCA.SQLCODE
                 LET g_status.description="插入qcu_file有错误!"
                 LET g_success='N'
                 EXIT FOR
                 RETURN
               END IF
           END FOR
        END IF 
    END FOR
    SELECT COUNT(*) INTO l_cnt FROM qct_file
        WHERE qct01 = l_check_file1.qct01
          AND qct02 = l_check_file1.qct02
          AND qct021 = l_check_file1.qct021
          AND qct08 = '2'
        IF l_cnt > 0 THEN
           LET l_qcs.qcs09='2'
        ELSE
        	 LET l_qcs.qcs09='1' 
        END IF
        SELECT qcs22,qcs30,qcs31,qcs32,qcs33,qcs34,qcs35
        INTO l_qcs.qcs22,l_qcs.qcs30,l_qcs.qcs31,l_qcs.qcs32,l_qcs.qcs34,l_qcs.qcs35
        FROM qcs_file
        WHERE qcs01=l_check_file.qct01
          AND qcs02=l_check_file.qct02
          AND qcs05=l_check_file.qct021

        LET l_qcs.qcs091=l_qcs.qcs22
        LET l_qcs.qcs36 = l_qcs.qcs30
        LET l_qcs.qcs37 = l_qcs.qcs31
        LET l_qcs.qcs38 = l_qcs.qcs32
        LET l_qcs.qcs39 = l_qcs.qcs33
        LET l_qcs.qcs40 = l_qcs.qcs34
        LET l_qcs.qcs41 = l_qcs.qcs35
        IF l_qcs.qcs09='2' THEN
           LET l_qcs.qcs091 = 0 #bugno:4135 :2.退貨->合格量=0
           LET l_qcs.qcs38  = 0  #No.FUN-610075
           LET l_qcs.qcs41  = 0  #No.FUN-610075
        END IF
        UPDATE qcs_file SET qcs091 = l_qcs.qcs091,
                            qcs09  = l_qcs.qcs09,
                            qcs36  = l_qcs.qcs36,   #No.FUN-610075
                            qcs37  = l_qcs.qcs37,   #No.FUN-610075
                            qcs38  = l_qcs.qcs38,   #No.FUN-610075
                            qcs39  = l_qcs.qcs39,   #No.FUN-610075
                            qcs40  = l_qcs.qcs40,   #No.FUN-610075
                            qcs41  = l_qcs.qcs41,    #No.FUN-610075
                            qcs14  = 'Y',
                            qcs15  = g_today
       WHERE qcs01 = l_check_file1.qct01
         AND qcs02 = l_check_file1.qct02
         AND qcs05 = l_check_file1.qct021
          IF STATUS THEN
   	          LET g_status.code = -1
              LET g_status.sqlcode = SQLCA.SQLCODE
              LET g_status.description="更新qcs_file有错误!"
              LET g_success='N'
              RETURN
          END IF
    SELECT * INTO g_qcs.* FROM qcs_file WHERE qcs01=l_check_file1.qct01
       AND qcs02 = l_check_file1.qct02 AND qcs05 = l_check_file1.qct021  #add huxy160418
      IF g_qcs.qcs09 = '2' OR g_qcs.qcs09 = '3' THEN      #MOD-C30557    #FUN-CC0015 add qcs09=3
         CALL t110_qc()                                   #MOD-C30557
      END IF
     #------ 是否與採購勾稽(modi in 01/06/04) ------
     SELECT * INTO g_sma.* FROM sma_file
     IF g_sma.sma886[8,8] = 'Y' AND g_qcs.qcs00 = '1' THEN
        UPDATE rvb_file SET rvb40 = g_qcs.qcs04   #No.MOD-590083
         WHERE rvb01 = g_qcs.qcs01
           AND rvb02 = g_qcs.qcs02
    
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = -1
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description="更新rvb_file有错误!"
            LET g_success='N'
            RETURN
        END IF
    
        CASE g_qcs.qcs09
           WHEN '1'
              CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
           WHEN '2'
              CALL cl_getmsg('apm-244',g_lang) RETURNING des1        #No:7706
           WHEN '3'
              CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
        END CASE
    
        UPDATE rvb_file SET rvb41 = des1 #檢驗結果
         WHERE rvb01 = g_qcs.qcs01
           AND rvb02 = g_qcs.qcs02
    
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = -1
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description="更新rvb_file有错误!"
            LET g_success='N'
            RETURN
        END IF
    
        SELECT rvb33,rvb07,rvb331,rvb332 ,rvb30              #FUN-5C0022 add rvb331  ,rvb332    #MOD-640512 add rvb30
            INTO l_rvb33,l_rvb07,l_rvb331,l_rvb332,l_rvb30   #FUN-5C0022 add rvb331  ,rvb332   #MOD-640512 add rvb30
          FROM rvb_file
         WHERE rvb01 = g_qcs.qcs01
           AND rvb02 = g_qcs.qcs02
    
        IF cl_null(l_rvb33) THEN
           LET l_rvb33 = 0
        END IF
    
        IF cl_null(l_rvb331) THEN  #FUN-5C0022 add
           LET l_rvb331 = 0
        END IF
    
        IF cl_null(l_rvb332) THEN  #FUN-5C0022 add
           LET l_rvb332 = 0
        END IF
    
        IF cl_null(l_rvb07) THEN
           LET l_rvb07 = 0
        END IF
    
        LET l_rvb33 = l_rvb33 + g_qcs.qcs091
        IF g_sma.sma115 = 'Y' THEN #使用雙單位
           LET l_rvb331 = l_rvb331 + g_qcs.qcs38
           LET l_rvb332 = l_rvb332 + g_qcs.qcs41
        ELSE
           LET l_rvb331 = l_rvb331 + 0
           LET l_rvb332 = l_rvb332 + 0
        END IF
    
        #FUN-BB0085-add-str---
        SELECT rvb90 INTO l_rvb90 FROM rvb_file
         WHERE rvb01 = g_qcs.qcs01
           AND rvb02 = g_qcs.qcs02
        LET l_rvb33 = s_digqty(l_rvb33,l_rvb90)   
        #FUN-BB0085-add-end---
        UPDATE rvb_file SET rvb33 = l_rvb33,
               rvb331 = l_rvb331, #FUN-5C0022 add
               rvb332 = l_rvb332, #FUN-5C0022 add
               rvb31 = l_rvb33 - l_rvb30   #MOD-640512
         WHERE rvb01 = g_qcs.qcs01
           AND rvb02 = g_qcs.qcs02
    
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_status.code = -1
            LET g_status.sqlcode = SQLCA.SQLCODE
            LET g_status.description="更新rvb_file有错误!"
            LET g_success='N'
            RETURN
        END IF
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
    	 IF g_status.code='0' THEN
            LET g_status.code = "-1"
            LET g_status.description = "接口程序存在错误，请程序员检查，谢谢!"
       END IF
    	 ROLLBACK WORK
    END IF 
END FUNCTION
FUNCTION t110_get_qcd07(p_qcs01,p_qcs02,p_qcs021,p_qct04)
	 DEFINE p_qcs01       LIKE qcs_file.qcs01
	 DEFINE p_qcs02       LIKE qcs_file.qcs02
	 DEFINE p_qcs021      LIKE qcs_file.qcs021
   DEFINE p_qct04       LIKE qct_file.qct04
   DEFINE l_qcd05       LIKE qcd_file.qcd05
   DEFINE l_qcd07       LIKE qcd_file.qcd07
   DEFINE l_qcd061      LIKE qcd_file.qcd061
   DEFINE l_qcd062      LIKE qcd_file.qcd062

   LET l_qcd07  = 'N'
   LET l_qcd05  = ''
   LET l_qcd061 = ''
   LET l_qcd062 = ''
   LET g_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
               "   FROM qcc_file,ecm_file,rvb_file,pmn_file ",
               "  WHERE rvb01= ?    AND rvb02= ?",
               "    AND rvb04=pmn01 AND rvb03=pmn02  ",
               "    AND pmn41=ecm01 AND pmn46=ecm03 ",
               "    AND qcc01= ?    AND qcc011=ecm04 ",
               "    AND qcc02= ?",
               "    AND ecm012=pmn012 "    
      LET g_sql = g_sql CLIPPED," AND qcc08 in ('1','9')"

   PREPARE qcc_sel2 FROM g_sql  
   EXECUTE qcc_sel2 USING p_qcs01,p_qcs02,p_qcs021,p_qct04
      INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                                          
   IF STATUS=100 THEN
      EXECUTE qcc_sel2 USING p_qcs01,p_qcs02,'*',p_qct04
         INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07
      IF STATUS=100 THEN
         LET g_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
                     " FROM qcd_file ",
                     " WHERE qcd01=? AND qcd02=? " 
            LET g_sql = g_sql CLIPPED," AND qcd08 in ('1','9')"
         PREPARE qcd_sel2 FROM g_sql  
         EXECUTE qcd_sel2 USING p_qcs021,p_qct04
            INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
         IF STATUS=100 THEN
            LET g_sql = " SELECT qck05,qck061,qck062,qck07  ",
                        "   FROM qck_file,ima_file ",
                        "  WHERE ima01=? AND qck01=ima109 ",
                        "    AND qck02 = ?"

               LET g_sql = g_sql CLIPPED," AND qck08 in ('1','9')"  
            PREPARE qck_sel2 FROM g_sql  
            EXECUTE qck_sel2 USING p_qcs021,p_qct04
               INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
            IF STATUS=100 THEN
               LET l_qcd07  = 'N'
               LET l_qcd05  = ''
               LET l_qcd061 = ''
               LET l_qcd062 = ''
            END IF
         END IF
      END IF    
   END IF

   RETURN l_qcd07,l_qcd05,l_qcd061,l_qcd062

END FUNCTION 

FUNCTION t110_qc()
DEFINE l_sum_qco11     LIKE type_file.num10,
       l_sum_qco15     LIKE type_file.num10,
       l_sum_qco18     LIKE type_file.num10,
       l_qco13         LIKE qco_file.qco13,
       l_qco15         LIKE qco_file.qco15,
       l_qco16         LIKE qco_file.qco16,
       l_qco18         LIKE qco_file.qco18,
       l_factor        LIKE type_file.num10,
       l_flag          LIKE type_file.chr1,
       l_sql           STRING,
       l_n             LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
   IF l_n = 0 THEN RETURN END IF

   SELECT SUM(qco11*qco19) INTO l_sum_qco11
     FROM qco_file,qcl_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
      AND qco03 = qcl01
     #AND qcl05 <> '3'      #FUN-CC0013 mark
   IF cl_null(l_sum_qco11) THEN LET l_sum_qco11 = 0 END IF
   IF l_sum_qco11 = 0 THEN RETURN END IF
   LET l_sql = "SELECT qco13,qco15,qco16,qco18 ",
               "  FROM qco_file,qcl_file       ",
               " WHERE qco03 = qcl01           ",
               "   AND qco01 = '",g_qcs.qcs01,"' ",
               "   AND qco02 = '",g_qcs.qcs02,"' ",
               "   AND qco05 = '",g_qcs.qcs05,"' "     #FUN-CC0013 mark ,
              #"   AND qcl05 <> '3' "                  #FUN-CC0013 mark
   PREPARE qco_pre FROM l_sql
   DECLARE qco_cur CURSOR FOR qco_pre
   FOREACH qco_cur INTO l_qco13,l_qco15,l_qco16,l_qco18
      CALL s_umfchk(g_qcs.qcs021,l_qco13,g_qcs.qcs30) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco15 = l_qco15 * l_factor
      LET l_qco15 = s_digqty(l_qco15,g_qcs.qcs30)

      CALL s_umfchk(g_qcs.qcs021,l_qco16,g_qcs.qcs33) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco18 = l_qco18 * l_factor
      LET l_qco18 = s_digqty(l_qco18,g_qcs.qcs33)

      LET l_sum_qco15 = l_sum_qco15 + l_qco15
      LET l_sum_qco18 = l_sum_qco18 + l_qco18
   END FOREACH

   UPDATE qcs_file
      SET qcs09  = '1',
          qcs091 = l_sum_qco11,
          qcs38  = l_sum_qco15,
          qcs41  = l_sum_qco18
    WHERE qcs01  = g_qcs.qcs01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
   END IF

END FUNCTION



	
