# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 采购扫描转收货作业
# Date & Author..: 2016-03-16 hlf


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_pmm01    LIKE pmm_file.pmm01    #采购单号
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_pmn20    LIKE pmn_file.pmn20    #数量
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_sql      STRING
DEFINE o_pmn     DYNAMIC ARRAY OF RECORD                    #单身
                    pmn04a     LIKE pmn_file.pmn04,         #料件編號
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #已匹配数量
                 END RECORD

DEFINE o_pmn_t   RECORD                     #第一单身
                    pmn04a     LIKE pmn_file.pmn04,         #料件編號
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #已匹配数量
                 END RECORD

DEFINE g_cnt     LIKE type_file.num5
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
DEFINE g_ima101  LIKE ima_file.ima101
DEFINE g_pmm     RECORD LIKE pmm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_hlf     RECORD 
        rva01    LIKE rva_file.rva01
                 END RECORD
DEFINE m_mt_dlv   RECORD
            tc_sia01  LIKE tc_sia_file.tc_sia01,       #SRM 发货单号
            tc_sia03  LIKE tc_sia_file.tc_sia03,       #SRM 发货日期
            tc_sia09  LIKE tc_sia_file.tc_sia09,       #SRM 订单类型 REG:普通  SUB:委外
            tc_sia02  LIKE tc_sia_file.tc_sia02,       #ERP 供应商编码
            tc_sia06  LIKE tc_sia_file.tc_sia06,       #ERP 收货单号
            tc_sia08  LIKE tc_sia_file.tc_sia08        #SRM 单据状态 1：草稿 2：发放 3：已收货                  
               END RECORD
DEFINE l_sql1     STRING
DEFINE l_qty     LIKE pmn_file.pmn50
DEFINE l_qdf02   LIKE qdf_file.qdf02
DEFINE l_qcs22   LIKE qcs_file.qcs22
DEFINE l_qcd03   LIKE qcd_file.qcd03
DEFINE l_qcd05   LIKE qcd_file.qcd05
DEFINE l_qcs01        LIKE qcs_file.qcs01
DEFINE l_qcs02        LIKE qcs_file.qcs02
DEFINE l_qcs021       LIKE qcs_file.qcs021
DEFINE l_qcs03        LIKE qcs_file.qcs03
DEFINE l_qcs04        LIKE qcs_file.qcs04
DEFINE p_row,p_col    LIKE type_file.num5       
DEFINE g_flag         LIKE type_file.chr1       
DEFINE l_k            LIKE type_file.num5       
DEFINE l_flag         LIKE type_file.chr1
DEFINE l_type         LIKE type_file.chr20    
DEFINE l_correct      LIKE type_file.chr1     
DEFINE l_do           LIKE type_file.chr1
DEFINE l_rva     RECORD LIKE rva_file.*
DEFINE l_rvb     RECORD LIKE rvb_file.* 
DEFINE l_pmm     RECORD LIKE pmm_file.*
DEFINE l_pmn     RECORD LIKE pmn_file.*
DEFINE l_rvbs    RECORD LIKE rvbs_file.*
DEFINE l_qcs     RECORD LIKE qcs_file.*
DEFINE l_qcd     RECORD LIKE qcd_file.*
DEFINE l_ecm04    LIKE ecm_file.ecm04


#DEFINE   g_cnt  LIKE type_file.num5  #MOD-880015
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
FUNCTION aws_create_apmt110()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_apmt110_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE t001_file
     DROP TABLE t001_file1 
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
FUNCTION aws_create_apmt110_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_k        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfu01   LIKE sfu_file.sfu01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_pmm     RECORD LIKE pmm_file.*
    DEFINE l_pmn     RECORD LIKE pmn_file.* 
    DEFINE l_rva     RECORD LIKE rva_file.*
    DEFINE l_rvb     RECORD LIKE rvb_file.*
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
   DEFINE l_inaconf    LIKE ina_file.inaconf
   DEFINE l_ogb04      LIKE ogb_file.ogb04
   DEFINE l_ogb31      LIKE ogb_file.ogb31
   DEFINE l_ogb32      LIKE ogb_file.ogb32
   DEFINE l_sum_ogb12  LIKE ogb_file.ogb12
   DEFINE l_ogb12      LIKE ogb_file.ogb12
   DEFINE l_ogb01a     LIKE ogb_file.ogb01
   DEFINE l_ogb03a     LIKE ogb_file.ogb03
   DEFINE l_ogb01      LIKE ogb_file.ogb01
   DEFINE l_ogb03      LIKE ogb_file.ogb03
   DEFINE l_ima021     LIKE ima_file.ima021   
   DEFINE l_ogb12a     LIKE ogb_file.ogb12
   DEFINE l_sql        STRING
   DEFINE l_pmn04      LIKE pmn_file.pmn04   #料件编码
   DEFINE l_ima02      LIKE ima_file.ima02   #品名
   DEFINE l_pmn07      LIKE pmn_file.pmn07   #单位
   DEFINE l_lotnumber  LIKE type_file.chr50  #批号
   DEFINE l_barcode1   LIKE type_file.chr50  #条码
   DEFINE l_pmn20      LIKE pmn_file.pmn20   #单据数量
   DEFINE l_msg        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(40)
   DEFINE l_pmn01      LIKE pmn_file.pmn01
   DEFINE l_pmm01      LIKE pmm_file.pmm01
   DEFINE l_pmn02      LIKE pmn_file.pmn02
   DEFINE l_pmn02a     LIKE pmn_file.pmn02
   DEFINE l_pmn20a     LIKE pmn_file.pmn20
   DEFINE l_pmn20ab    LIKE pmn_file.pmn20
   DEFINE l_pmn20b     LIKE pmn_file.pmn20
   DEFINE l_sum        LIKE pmn_file.pmn20
   DEFINE l_sl         LIKE pmn_file.pmn20
   DEFINE l_sr         STRING
   DEFINE l_rvb87      LIKE rvb_file.rvb87
   DEFINE l_rvb29      LIKE rvb_file.rvb29
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07 
   DEFINE l_t001_file1      RECORD                    #单身
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    pmn02      LIKE pmn_file.pmn02,         #项次
                    pmn01      LIKE pmn_file.pmn01,         #采购单号
                    pmn02a     LIKE pmn_file.pmn02,         #采购单项次
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #匹配数量
                 END RECORD  
  DEFINE  l_t001_file     RECORD
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    barcode    LIKE type_file.chr50,        #条码
                    lotnumber  LIKE type_file.chr50,        #批号
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20      LIKE pmn_file.pmn20          #数量
                 END RECORD
   DROP TABLE t001_file
   DROP TABLE t001_file1 
   CREATE TEMP TABLE t001_file(
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    barcode    LIKE type_file.chr50,        #条码
                    lotnumber  LIKE type_file.chr50,        #批号
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20      LIKE pmn_file.pmn20)         #数量
   CREATE TEMP TABLE t001_file1(
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    pmn02      LIKE pmn_file.pmn02,         #项次
                    pmn01      LIKE pmn_file.pmn01,         #采购单号
                    pmn02a     LIKE pmn_file.pmn02,         #采购单项次
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20)         #匹配数量             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_hlf.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點

        LET g_pmm01 = aws_ttsrv_getRecordField(l_node1,"pmm01")     

        #----------------------------------------------------------------------#
        # 處理第一單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "t001_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_t001_file1.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"t001_file1")   #目前單身的 XML 節點

            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#

           LET l_t001_file1.pmm01  = g_pmm01
           LET l_t001_file1.pmn02  = aws_ttsrv_getRecordField(l_node3, "pmn02")
           LET l_t001_file1.pmn01  = aws_ttsrv_getRecordField(l_node3, "pmn01") 
           LET l_t001_file1.pmn02a = aws_ttsrv_getRecordField(l_node3, "pmn02a")   
           LET l_t001_file1.pmn04  = aws_ttsrv_getRecordField(l_node3, "pmn04")
           LET l_t001_file1.pmn20a = aws_ttsrv_getRecordField(l_node3, "pmn20a")
           LET l_t001_file1.pmn20b = aws_ttsrv_getRecordField(l_node3, "pmn20b") 

           INSERT INTO t001_file1 VALUES (l_t001_file1.pmm01,l_t001_file1.pmn02,l_t001_file1.pmn01,
           l_t001_file1.pmn02a,l_t001_file1.pmn04,l_t001_file1.pmn20a,l_t001_file1.pmn20b) 
        END FOR
        #----------------------------------------------------------------------#
        # 處理第二單身資料                                                         #
        #----------------------------------------------------------------------#        
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "t001_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_t001_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"t001_file")   #目前單身的 XML 節點

            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t001_file.pmm01     = g_pmm01
            LET l_t001_file.barcode   = aws_ttsrv_getRecordField(l_node2, "barcode")
            LET l_t001_file.lotnumber = aws_ttsrv_getRecordField(l_node2, "lotnumber")
            LET l_t001_file.pmn04     = aws_ttsrv_getRecordField(l_node2, "pmn04")
            LET l_t001_file.pmn20     = aws_ttsrv_getRecordField(l_node2, "pmn20")
            INSERT INTO t001_file VALUES (l_t001_file.pmm01,l_t001_file.barcode,l_t001_file.lotnumber,
            l_t001_file.pmn04,l_t001_file.pmn20)
        END FOR
    END FOR
    IF g_status.code='0' THEN 
       CALL t001_load()
       IF g_success = 'Y' THEN
         CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_hlf))
       ELSE
       	 IF g_status.code='0' THEN
       	 	   LET g_status.code = "-1"
             LET g_status.description = "接口存在错误,请联系程序员!"
       	 END IF
       END IF
    END IF 
END FUNCTION

FUNCTION t001_load() 
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_msg        LIKE type_file.chr50 
   
   BEGIN WORK
   CALL t001_rva_rvb(g_pmm01)
   IF g_success = "Y" THEN
      CALL t110sub_y_upd(g_rva.rva01,TRUE,'N',' ',g_rva.rva10,' ','1')
   END IF
      CALL p001_chk()
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF
END FUNCTION


FUNCTION t001_rva_rvb(p_pmm01)
	DEFINE l_oga00     LIKE oga_file.oga00
	DEFINE p_pmm01     LIKE pmm_file.pmm01
	DEFINE l_sql       STRING
	DEFINE p_oga01     LIKE oga_file.oga01
	DEFINE l_oga09     LIKE oga_file.oga09
	DEFINE l_factor    LIKE ogb_file.ogb15_fac
	DEFINE l_poz00     LIKE poz_file.poz00
	DEFINE l_ogb01a    LIKE ogb_file.ogb01
	DEFINE l_ogb03a    LIKE ogb_file.ogb03
	DEFINE l_n         LIKE type_file.num5
	DEFINE l_t         LIKE type_file.num5
	DEFINE l_ogb12a    LIKE ogb_file.ogb12
	DEFINE l_ima491    LIKE ima_file.ima491
  DEFINE l_rvbi      RECORD LIKE rvbi_file.*   #No.FUN-7B0018
  DEFINE l_rvb87     LIKE rvb_file.rvb87       #No.MOD-8A0067
  DEFINE l_rvb29     LIKE rvb_file.rvb29       #No.MOD-930082
  DEFINE l_flag      LIKE type_file.chr1       #No.FUN-940083
  DEFINE l_fac       LIKE rvb_file.rvb90_fac   #No.FUN-940083
  DEFINE l_rtz08     LIKE rtz_file.rtz08       #FUN-B40098
  DEFINE l_rtz07     LIKE rtz_file.rtz07       #FUN-B60150 ADD
  DEFINE l_smyapr    LIKE smy_file.smyapr  #FUN-9C0076 add
  DEFINE l_pmm01     LIKE pmm_file.pmm01
  DEFINE l_barcode   LIKE type_file.chr50
  DEFINE l_lotnumber LIKE type_file.chr50
  DEFINE l_pmn04     LIKE pmn_file.pmn04
  DEFINE l_pmn20     LIKE pmn_file.pmn20
  DEFINE l_rvb07     LIKE rvb_file.rvb07
  DEFINE l_rvb02     LIKE rvb_file.rvb02
  DEFINE l_iba       RECORD LIKE iba_file.*
  DEFINE l_ibb       RECORD LIKE ibb_file.*
  DEFINE l_tc_codesys01 LIKE tc_codesys_file.tc_codesys01
  DEFINE l_tc_codesys02 LIKE tc_codesys_file.tc_codesys02
  DEFINE l_t1         LIKE oay_file.oayslip #FUN-9C0076 add
  DEFINE l_pmn      RECORD                    #单身
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    pmn02      LIKE pmn_file.pmn02,         #项次
                    pmn01      LIKE pmn_file.pmn01,         #采购单号
                    pmn02a     LIKE pmn_file.pmn02,         #采购单项次
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #匹配数量
                 END RECORD        
  
	INITIALIZE g_pmm.* TO NULL
	INITIALIZE m_mt_dlv.* TO NULL
	INITIALIZE g_rva.* TO NULL
	INITIALIZE g_rvb.* TO NULL
	INITIALIZE l_iba.* TO NULL
	INITIALIZE l_ibb.* TO NULL
	INITIALIZE l_pmn.* TO NULL 
   

  LET l_sql =" SELECT tc_sia01,tc_sia03,tc_sia09,tc_sia02,tc_sia06,tc_sia08",
             " FROM tc_sia_file",
             " WHERE tc_sia01='",p_pmm01,"'",
             " AND tc_sia08<>'1'"
              PREPARE t001_m_mt_dlv FROM l_sql
              EXECUTE t001_m_mt_dlv INTO m_mt_dlv.*              
	LET g_rva.rvaprsw = 'Y'  #MOD-820128
  LET g_rva.rva04   = 'N'  #MOD-810256
  SELECT tc_codesys01,tc_codesys02 INTO l_tc_codesys01,l_tc_codesys02 
  FROM tc_codesys_file WHERE tc_codesys00='0'
  CASE m_mt_dlv.tc_sia09
     WHEN "REG"   LET g_rva.rva10 = 'REG'  LET l_t1 = l_tc_codesys01
     WHEN "SUB"   LET g_rva.rva10 = 'SUB'  LET l_t1 = l_tc_codesys02
     OTHERWISE    LET g_rva.rva10 = 'REG'  LET l_t1 = l_tc_codesys01
  END CASE
  
  LET g_rva.rva05 = m_mt_dlv.tc_sia02  #供应商编码
  LET g_rva.rva06 = g_today
  LET g_rva.rva21 = NULL           
  LET g_rva.rvaconf = 'N'
  LET g_rva.rvaspc = '0'                            
  LET g_rva.rvauser=g_user
  LET g_rva.rvagrup=g_grup
  LET g_rva.rvadate=g_today
  LET g_rva.rvaacti='Y'
  LET g_rva.rvaplant=g_plant   
  LET g_rva.rvalegal=g_legal     
  LET g_rva.rva32 = '0'             #簽核狀況  
  LET g_rva.rva33 = g_user          #申請人  
  LET g_rva.rvaud06 = m_mt_dlv.tc_sia01  #SRM单号
  LET g_rva.rvaprno='0'
  LET g_rva.rvaud02=g_pmm01 #add huxy160418 送货单

  SELECT smyapr INTO l_smyapr FROM smy_file
   WHERE smysys='apm' AND smykind='3' AND smyslip=l_t1
  LET g_rva.rvamksg = l_smyapr      #是否簽核

  
  CALL s_auto_assign_no("apm",l_t1,g_rva.rva06,"3","rva_file","rva01","","","")
    RETURNING li_result,g_rva.rva01
  IF (NOT li_result) THEN
     LET g_success = 'N'
     RETURN
  END IF
  LET g_hlf.rva01 = g_rva.rva01

  LET g_rva.rva00 = '1'            #FUN-940083 add
  LET g_rva.rva29 = '1'            #FUN-960130 add  #NO.FUN-9B0016
  LET g_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
  LET g_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO rva_file VALUES(g_rva.*)
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL s_errmsg('','','',SQLCA.sqlcode,1)      
     LET g_success = 'N'
     RETURN
  ELSE 
  	# 回写中间表
  	 UPDATE tc_sia_file SET tc_sia08='3',tc_sia06=g_rva.rva01
  	 WHERE tc_sia01=m_mt_dlv.tc_sia01
     IF SQLCA.sqlcode THEN
        CALL s_errmsg("","","发货单号:"||m_mt_dlv.tc_sia01,SQLCA.sqlcode,1)      
        LET g_success = 'N'
        RETURN
     END IF
  END IF

   LET l_sql=" select * from t001_file1",
             " where pmn20b>0",
             " order by pmm01,pmn02"
     PREPARE t001_ipb4 FROM l_sql
     DECLARE t001_ic4 CURSOR FOR t001_ipb4
     FOREACH t001_ic4 INTO l_pmn.*
        IF STATUS THEN
          EXIT FOREACH
        END IF
   SELECT * INTO g_pmn.* FROM pmn_file WHERE pmn01=l_pmn.pmn01 AND pmn02=l_pmn.pmn02a
   LET  g_rvb.rvb01 = g_rva.rva01
   LET  g_rvb.rvb04 = g_pmn.pmn01
   LET  g_rvb.rvb03 = g_pmn.pmn02
   LET  g_rvb.rvb05 = g_pmn.pmn04
   LET  g_rvb.rvb06 = 0
   
   SELECT MAX(rvb02) INTO g_rvb.rvb02 FROM rvb_file WHERE rvb01=g_rva.rva01
   IF g_rvb.rvb02 IS NULL THEN LET g_rvb.rvb02 = 0 END IF
   LET g_rvb.rvb02 = g_rvb.rvb02 + 1 #项次
   #目前看来有问题，暂时mark str
#   LET  l_rvb87 = 0
#   LET  l_rvb29 = 0
#   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file
#    WHERE rvb04 = g_pmn.pmn01 AND rvb03 = g_pmn.pmn02
#      AND rva01 = rvb01 AND rvaconf = 'N'
#   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
# 
#   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file
#    WHERE rvb04 = g_pmn.pmn01 AND rvb03 = g_pmn.pmn02
#      AND rva01 = rvb01 AND rvaconf = 'N'
#   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
#   #LET l_rvb07 = g_pmn.pmn20-g_pmn.pmn50+g_pmn.pmn55+g_pmn.pmn58-l_rvb87+l_rvb29
#   LET l_rvb07 = g_pmn.pmn20-g_pmn.pmn50+g_pmn.pmn55+g_pmn.pmn58+l_rvb29
#   IF l_rvb07 <= 0 THEN
#      LET g_success = 'N'
#      RETURN
#   END IF
#   IF l_pmn.pmn20b > l_rvb07 THEN 
#     # 录入的实收数量大于该采购单号的可收数量
#      LET g_success = 'N'
#      RETURN
#   END IF
   #目前看来有问题，暂时mark end 
   LET  g_rvb.rvb07 = l_pmn.pmn20b
   LET  g_rvb.rvbud07 = l_pmn.pmn02   #SRM行序
   LET  g_rvb.rvb08 = g_rvb.rvb07
   LET  g_rvb.rvb09 = 0
   LET  g_rvb.rvb10 = g_pmn.pmn31
   LET  g_rvb.rvb10t = g_pmn.pmn31t
   LET  g_rvb.rvb11 = 0
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = g_rvb.rvb05
   IF cl_null(l_ima491) THEN
      LET l_ima491 = 0
   END IF
   IF l_ima491 > 0 THEN
      CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb.rvb12
   ELSE
      IF cl_null(g_rvb.rvb12) THEN
         LET g_rvb.rvb12 = g_rva.rva06
      END IF
   END IF
   LET  g_rvb.rvb13 = NULL
   LET  g_rvb.rvb14 = NULL
   LET  g_rvb.rvb15 = 0
   LET  g_rvb.rvb16 = 0
   LET  g_rvb.rvb17 = NULL
   LET  g_rvb.rvb18 = '10'
   LET  g_rvb.rvb19 = g_pmn.pmn65
   LET  g_rvb.rvb20 = NULL
   LET  g_rvb.rvb21 = NULL
   LET  g_rvb.rvb25 = g_pmn.pmn71
   LET  g_rvb.rvb27  = 0     #NO USE
   LET  g_rvb.rvb28  = 0     #NO USE
   LET  g_rvb.rvb29  = 0     #退補量
   LET  g_rvb.rvb30  = 0     #入庫量
   LET  g_rvb.rvb31  = g_rvb.rvb07  
   LET  g_rvb.rvb32  = 0     #NO USE
   LET  g_rvb.rvb33  = 0     #入庫量
   LET  g_rvb.rvb331  = 0    #允收量
   LET  g_rvb.rvb332  = 0    #允收量
   LET  g_rvb.rvb34 = g_pmn.pmn41
   LET  g_rvb.rvb35 = 'N'   #樣品否
   LET  g_rvb.rvb89 = g_pmn.pmn89      #VIM收貨否
   LET  g_rvb.rvb051 = g_pmn.pmn041    #品名規格
   LET  g_rvb.rvb90 = g_pmn.pmn07      #收貨單位
   IF g_rvb.rvb89 = 'Y' THEN
      SELECT pmc915,pmc916 INTO g_rvb.rvb36,g_rvb.rvb37
        FROM pmc_file
        WHERE pmc01 = g_rvb.rvb05
   ELSE   
      LET  g_rvb.rvb36 = g_pmn.pmn52
      LET  g_rvb.rvb37 = g_pmn.pmn54
      IF cl_null(g_rvb.rvb36) AND cl_null(g_rvb.rvb37)  THEN
         SELECT ima35,ima36 INTO g_rvb.rvb36,g_rvb.rvb37
           FROM ima_file
         WHERE ima01=g_rvb.rvb05
      END IF
   END IF                 #FUN-940083 add 
   LET  g_rvb.rvb38 = g_pmn.pmn56
   CALL p220_get_rvb39(g_rvb.rvb04,g_rvb.rvb05,g_rvb.rvb19) 
        RETURNING g_rvb.rvb39
   LET  g_rvb.rvb40 = ''    #檢驗日期 no.7143
 
   LET  g_rvb.rvb80 = g_pmn.pmn80 
   LET  g_rvb.rvb81 = g_pmn.pmn81 
   LET  g_rvb.rvb82 = g_pmn.pmn82 
   LET  g_rvb.rvb83 = g_pmn.pmn83 
   LET  g_rvb.rvb84 = g_pmn.pmn84 
   LET  g_rvb.rvb85 = g_pmn.pmn85 
   LET  g_rvb.rvb86 = g_pmn.pmn86 
      
   LET  g_rvb.rvb87 = g_rvb.rvb07
   LET  g_rvb.rvb88 = g_rvb.rvb87 * g_rvb.rvb10
   LET  g_rvb.rvb88t= g_rvb.rvb87 * g_rvb.rvb10t
   LET  g_rvb.rvb930 = g_pmn.pmn930 
   IF g_rvb.rvb38 IS NULL THEN
      LET g_rvb.rvb38=' '
   END IF
   IF g_rvb.rvb37 IS NULL THEN
      LET g_rvb.rvb37=' '
   END IF
   SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
   FROM img_file   #採購單位,庫存數量,庫存單位
   WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
   AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
   IF STATUS=100 AND (g_rvb.rvb36 IS NOT NULL AND g_rvb.rvb36 <> ' ') THEN
      CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                     g_rvb.rvb37,g_rvb.rvb38,
                     g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
   END IF
   SELECT img09 INTO g_img09
      FROM img_file           #庫存單位
      WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
        AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
   CALL s_umfchk(g_rvb.rvb05,g_rvb.rvb90,g_img09)
        RETURNING l_flag,l_fac 
   IF l_flag THEN
      LET g_rvb.rvb90_fac = 1
   ELSE 
      LET g_rvb.rvb90_fac = l_fac
   END IF
          
   LET  g_rvb.rvbplant = g_plant   #FUN-980006 add
   LET  g_rvb.rvblegal = g_legal   #FUN-980006 add
   LET  g_rvb.rvb42 =  ' '          #FUN-960130 add
   INSERT INTO rvb_file VALUES(g_rvb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p220_ins_rvb():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_rvbi.* TO NULL
         LET l_rvbi.rvbi01 = g_rvb.rvb01
         LET l_rvbi.rvbi02 = g_rvb.rvb02
         IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
     IF g_success = 'Y' THEN 
  	 #回写中间表
     UPDATE tc_sib_file SET tc_sib07=tc_sib07+g_rvb.rvb07 WHERE tc_sib01=l_pmn.pmm01 AND tc_sib02=l_pmn.pmn02
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        LET g_success = 'N'
     END IF
  END IF
  IF NOT cl_null(g_rvb.rvb36) THEN
    IF g_sma.sma886[7,7] ='Y' THEN
      SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
        FROM img_file   #採購單位,庫存數量,庫存單位
       WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
         AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
      IF STATUS=100 AND (g_rvb.rvb36 IS NOT NULL AND g_rvb.rvb36 <> ' ') THEN
          CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                         g_rvb.rvb37,g_rvb.rvb38,
                         g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
      END IF
      SELECT ima906 INTO g_ima906 FROM ima_file
       WHERE ima01=g_rvb.rvb05
      IF g_ima906 = '2' THEN
        IF NOT cl_null(g_rvb.rvb83) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb83) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb83,g_rvb.rvb84,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
        IF NOT cl_null(g_rvb.rvb80) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb80) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb80,g_rvb.rvb81,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
      END IF
 
      IF g_ima906 = '3' THEN
        IF NOT cl_null(g_rvb.rvb83) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb83) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb83,g_rvb.rvb84,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
      END IF
    END IF
  END IF
 END FOREACH
  LET l_sql=" select pmm01,barcode,lotnumber,pmn04,pmn20 from t001_file"
            PREPARE t001_ipb_iba FROM l_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            LET l_pmm01=''
            LET l_pmn04=''
            LET l_pmn20=''
            FOREACH t001_iba INTO l_pmm01,l_barcode,l_lotnumber,l_pmn04,l_pmn20
              IF STATUS THEN
               EXIT FOREACH
              END IF
              SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_barcode
              SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_barcode
              IF cl_null(l_n) THEN LET l_n=0 END IF
              IF cl_null(l_t) THEN LET l_t=0 END IF
              IF l_n=0 AND l_t=0 THEN
                    LET l_iba.iba01=l_barcode
                    INSERT INTO iba_file VALUES(l_iba.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_iba():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'
                        RETURN
                    END IF
                    LET l_ibb.ibb01=l_barcode    #条码编号
                    LET l_ibb.ibb02='K'          #条码产生时机点
                    LET l_ibb.ibb03=g_rvb.rvb01  #来源单号
                    LET l_ibb.ibb04=0            #来源项次
                    LET l_ibb.ibb05=0            #包号
                    LET l_ibb.ibb06=l_pmn04      #料号
                    LET l_ibb.ibb11='Y'          #使用否         
                    LET l_ibb.ibb12=0            #打印次数
                    LET l_ibb.ibb13=0            #检验批号(分批检验顺序)
                    LET l_ibb.ibbacti='Y'        #资料有效码
        #            LET l_ibb.ibb17=l_lotnumber  #批号
        #            LET l_ibb.ibb14=l_pmn20      #数量
        #            LET l_ibb.ibb20=g_today      #生成日期
                    INSERT INTO ibb_file VALUES(l_ibb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_ibb():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'
                        RETURN
                    END IF
              ELSE
              	#CONTINUE FOREACH #mark huxy160417
                #add huxy160417------------Beg-----------------
                UPDATE ibb_file SET ibb03 = g_rvb.rvb01
                 WHERE ibb01 = l_barcode
                #add huxy160417------------End-----------------
              END IF
            END FOREACH
END FUNCTION

FUNCTION p220_get_rvb39(p_rvb04,p_rvb05,p_rvb19)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,    
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915   #FUN-710060 add
   DEFINE l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
          l_pmh22   LIKE pmh_file.pmh22    #No.CHI-8C0017    
  
  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
   IF l_ima915='2' OR l_ima915='3' THEN 
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04
       
      IF g_pmm.pmm02='SUB' THEN
         LET l_pmh22='2'
           IF g_pmn.pmn43 = 0 OR cl_null(g_pmn.pmn43) THEN    #NO.TQC-920098
            LET l_pmh21 =' '
         ELSE
           IF NOT cl_null(g_pmn.pmn18) THEN
            SELECT sgm04 INTO l_pmh21 FROM sgm_file
             WHERE sgm01=g_pmn.pmn18
               AND sgm02=g_pmn.pmn41
               AND sgm03=g_pmn.pmn43
               AND sgm012 = g_pmn.pmn012   #FUN-A60076 
           ELSE
            SELECT ecm04 INTO l_pmh21 FROM ecm_file 
             WHERE ecm01=g_pmn.pmn41
               AND ecm03=g_pmn.pmn43
               AND ecm012 = g_pmn.pmn012    #FUN-A60027
           END IF
         END IF     #NO.TQC-910033
      ELSE
         LET l_pmh22='1'
         LET l_pmh21=' '
      END IF
 
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=g_rva.rva05
         AND pmh13=l_pmm22
         AND pmh21 = l_pmh21                                                      #CHI-8C0017
         AND pmh22 = l_pmh22                                                      #CHI-8C0017
         AND pmh23 = ' '                                             #No.CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021         
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
END FUNCTION

FUNCTION p001_chk()  
DEFINE l_ima906  LIKE ima_file.ima906 
DEFINE l_yn      LIKE type_file.num5    
DEFINE l_cnt     LIKE type_file.num5       
DEFINE l_ac_num  LIKE type_file.num5
DEFINE l_re_num  LIKE type_file.num5 
DEFINE l_qct11   LIKE qct_file.qct11
DEFINE l_qct14   LIKE qct_file.qct14
DEFINE l_qct15   LIKE qct_file.qct15
DEFINE l_q       LIKE qcs_file.qcs22
#DEFINE l_ima101  LIKE ima_file.ima101  #MOD-D20123 mark
DEFINE l_qcs03_t  LIKE qcs_file.qcs03 
DEFINE seq        LIKE qct_file.qct07 
DEFINE l_s        LIKE type_file.chr1 
DEFINE l_n        LIKE type_file.chr1 
DEFINE l_m        LIKE type_file.chr1 
DEFINE l_t        LIKE type_file.chr1 
DEFINE l_ima918   LIKE ima_file.ima918       #TQC-B90236 
DEFINE l_ima921   LIKE ima_file.ima921       #TQC-B90236
DEFINE l_rvbs04   LIKE rvbs_file.rvbs04      #TQC-B90236
DEFINE l_rvbs06   LIKE rvbs_file.rvbs06      #TQC-B90236
DEFINE l_rvbs06s  LIKE rvbs_file.rvbs06      #TQC-B90236
DEFINE l_qcs22s   LIKE qcs_file.qcs22        #TQC-B90236
DEFINE l_ima44    LIKE ima_file.ima44        #FUN-BB0085
DEFINE l_str      STRING   #FUN-C30064
DEFINE l_sql      STRING
DEFINE tm      RECORD
               wc     LIKE type_file.chr1000,    
               qc     LIKE type_file.chr1     #TQC-B90236
              END RECORD

   
   LET l_sql =" SELECT * FROM rva_file",
              " WHERE rvaconf='Y'",
              " AND rva01='",g_rva.rva01,"'" 
   PREPARE p001_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_c1 CURSOR FOR p001_p1
   
   LET l_sql1 ="SELECT * FROM rvb_file  ",
              " WHERE rvb01=? and rvb19='1' AND rvb39='Y' "
   PREPARE p001_p11 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_c11 CURSOR FOR p001_p11
#No.TQC-B90236----add--begin----------   
   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11a FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11a error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs CURSOR FOR p001_p11a

   LET l_sql1 ="SELECT rvbs04,SUM(rvbs06) FROM rvbs_file  ",
               " WHERE rvbs01 = ? AND rvbs02=? AND rvbs09=1 AND rvbs13 = 0 ",  #TQC-C30012 modify and -> where
               "   AND rvbs00[1,7] <>'aqct110'  GROUP BY rvbs04"
   PREPARE p001_p11b FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11b error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs1 CURSOR FOR p001_p11b

   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs04=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11c FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11c error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs2 CURSOR FOR p001_p11c
#No.TQC-B90236----add--end------------
   LET g_success = 'Y'

   LET l_s = 'N'
   LET l_str = NULL  #FUN-C30064
   FOREACH p001_c1 into l_rva.*
      FOREACH p001_c11 using l_rva.rva01 into l_rvb.*


   #產生QC單頭資料
             LET l_m = 'Y'
             LET l_s = 'Y'
             LET l_qcs.qcs00 = '1'											
             LET l_qcs.qcs01 = l_rva.rva01											
             LET l_qcs.qcs02 = l_rvb.rvb02											
             LET l_qcs.qcs021 =l_rvb.rvb05											
             LET l_qcs.qcs03 = l_rva.rva05											
             LET l_qcs.qcs04 = g_today											
             LET l_qcs.qcs041 = TIME

#No.TQC-B90236---mark---begin--------------------             
            #SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file 
            #WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02											
             
            #IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF											
            #SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file 
            #WHERE qcs00='1' AND qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02 AND qcs14 <>'X'			
             								
            #IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF             
            #LET l_qcs.qcs06 = l_rvb.rvb07 - l_qcs22							
#No.TQC-B90236---mark---end----------------------
             SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.* 
              FROM pmm_file,pmn_file
             WHERE pmm01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03	
               AND pmm01=pmn01  #MOD-C90134 add
             										
             LET l_ecm04=' '     #MOD-C70225 add
             LET l_type='1'      #MOD-C70225 add

             IF l_pmm.pmm02='SUB' THEN											
               LET l_type = '2'											
                IF cl_null(l_pmn.pmn43) OR l_pmn.pmn43=0 THEN											
                  LET  l_ecm04=' '											
                ELSE											
                   SELECT ecm04 INTO l_ecm04 FROM ecm_file 											
                    WHERE ecm01=l_pmn.pmn41 AND ecm03=l_pmn.pmn43 AND ecm012=l_pmn.pmn012											
                END IF											
             END IF				
             			
             SELECT bmj10 INTO l_qcs.qcs10
                FROM bmj_file  
                WHERE bmj01=l_qcs.qcs021 
                AND (bmj02 IS NULL OR bmj02=l_pmn.pmn123 OR bmj02=' ')
                AND bmj03=l_qcs.qcs03 
                AND (bmj10 IS NOT NULL AND bmj10<>' ')
             
             SELECT pmn63 INTO l_qcs.qcs16 
               FROM pmn_file 
               WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03								
            
             SELECT pmh16 INTO l_qcs.qcs17
               FROM pmh_file 
              WHERE pmh01=l_qcs.qcs021 
             	AND pmh02=l_qcs.qcs03 
             	AND pmh21=l_ecm04 
             	AND pmh22=l_type 
             	AND pmh23=' '							
            										
             SELECT pmh09 INTO l_qcs.qcs21
               FROM pmh_file 
              WHERE pmh01=l_qcs.qcs021 
             	AND pmh02=l_qcs.qcs03 
             	AND pmh21=l_ecm04 
             	AND pmh22=l_type 
             	AND pmh23=' '							
             #MOD-BA0036 add --start--
             IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN 
             SELECT pmc906,pmc907 INTO l_qcs.qcs21,l_qcs.qcs17
               FROM pmc_file
                WHERE pmc01 = l_qcs.qcs03

                IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN 
                   SELECT ima100,ima102 INTO l_qcs.qcs21,l_qcs.qcs17
                      FROM ima_file WHERE ima01=l_qcs.qcs021
                   IF STATUS THEN
                      LET l_qcs.qcs21=' '
                      LET l_qcs.qcs17=' '
                   END IF
                END IF
             END IF
             #MOD-BA0036 add --end--
           										
             LET l_qcs.qcs13 = g_user											
             LET l_qcs.qcs14 = 'N'
#No.TQC-B90236----mark---begin-----           
             #LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22											
             #IF l_qcs.qcs22 = 0 THEN 
             #    LET l_s = 'N'
             #    CONTINUE FOREACH 
             #END IF				
             							
             #LET l_qcs22 = l_qcs.qcs06 #MOD-B70290 add
             #LET l_qcs.qcs30 = l_rvb.rvb80											
             #LET l_qcs.qcs31 = l_rvb.rvb81											
             #LET l_qcs.qcs32 = l_rvb.rvb82											
             #LET l_qcs.qcs33 = l_rvb.rvb83											
             #LET l_qcs.qcs34 = l_rvb.rvb84											
             #LET l_qcs.qcs35 = l_rvb.rvb85	
             
             #SELECT ima906 INTO l_ima906
             #  FROM ima_file  
             # WHERE ima01 = l_qcs.qcs021
                               										
             #IF g_sma.sma115 = 'Y' AND l_qcs22 <> 0 THEN											
             #   IF l_ima906 = '3' THEN											
             #      LET l_qcs.qcs32 = l_qcs.qcs22											
             #      IF l_qcs.qcs34 <> 0 THEN											
             #         LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34											
             #      ELSE											
             #         LET l_qcs.qcs35 = 0											
             #      END IF											
             #   ELSE											
             #      LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34											
             #      LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34											
             #   END IF											
             #END IF											
             #LET l_qcs.qcs09 = '1'											
             #LET l_qcs.qcs091 = l_qcs.qcs22											
             #LET l_qcs.qcs36 = l_qcs.qcs30											
             #LET l_qcs.qcs37 = l_qcs.qcs31											
             #LET l_qcs.qcs38 = l_qcs.qcs32											
             #LET l_qcs.qcs39 = l_qcs.qcs33											
             #LET l_qcs.qcs40 = l_qcs.qcs34											
             #LET l_qcs.qcs41 = l_qcs.qcs35
#No.TQC-B90236----mark---end----------             
             LET l_qcs.qcsspc ='0'											
             LET l_qcs.qcsprno = 0											
             LET l_qcs.qcsacti = 'Y'											
             LET l_qcs.qcsuser = g_user											
             LET l_qcs.qcsgrup = g_grup											
             LET l_qcs.qcsdate = g_today											
             LET l_qcs.qcsplant = g_plant											
             LET l_qcs.qcslegal = g_legal											
             LET l_qcs.qcsoriu = g_user											
             LET l_qcs.qcsorig = g_grup											
             LET l_qcs.qcs15 = ''                       #MOD-B70274 add
#No.TQC-B90236----add---begin-------
             SELECT ima918 INTO l_ima918 FROM ima_file
              WHERE ima01 = l_qcs.qcs021
             LET tm.qc = 'N'
             IF tm.qc='Y' AND l_ima918='Y' THEN
                FOREACH p001_rvbs1 USING l_qcs.qcs01,l_qcs.qcs02 INTO l_rvbs04,l_rvbs06    #依製造批號抓取資料
                    SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file 
                     WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                    IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF
                    #抓取已產生的資料
                    SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                     WHERE qcs01 =l_qcs.qcs01
                       AND qcs02 =l_qcs.qcs02
                       AND rvbs13=qcs05
                       AND qcs01 = rvbs01
                       AND qcs02 = rvbs02
                       AND rvbs04 = l_rvbs04
                       AND rvbs00[1,7] = 'aqct110'
                       AND qcs14 !='X'
                       AND qcs00 = '1'
                       AND rvbs09 = 1
                    IF cl_null(l_rvbs06s) THEN
                       LET l_rvbs06s=0
                    END IF
                    LET l_qcs.qcs22 = (l_rvbs06- l_rvbs06s)/l_rvb.rvb90_fac  
                    IF l_qcs.qcs22 = 0 THEN
                       LET l_s = 'N'
                       CONTINUE FOREACH
                    END IF
                    
                    LET l_qcs22 = l_qcs.qcs22
                    LET l_qcs.qcs30 = l_rvb.rvb80
                    LET l_qcs.qcs31 = l_rvb.rvb81
                    LET l_qcs.qcs32 = l_rvb.rvb82
                    LET l_qcs.qcs33 = l_rvb.rvb83
                    LET l_qcs.qcs34 = l_rvb.rvb84
                    LET l_qcs.qcs35 = l_rvb.rvb85
                
                    SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file    #FUN-BB0085  add ima44
                     WHERE ima01 = l_qcs.qcs021
                    IF l_ima906 = '3' THEN
                       LET l_qcs.qcs32 = l_qcs.qcs22
                       IF l_qcs.qcs34 <> 0 THEN
                          LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
                       ELSE
                          LET l_qcs.qcs35 = 0
                       END IF
                    ELSE
                       IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN   #No.MOD-CC0009
                          LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
                          LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
                       END IF                                                                    #No.MOD-CC0009
                    END IF
                    LET l_qcs.qcs09 = '1'
                    LET l_qcs.qcs091 = l_qcs.qcs22
                    LET l_qcs.qcs36 = l_qcs.qcs30
                    LET l_qcs.qcs37 = l_qcs.qcs31
                    LET l_qcs.qcs38 = l_qcs.qcs32
                    LET l_qcs.qcs39 = l_qcs.qcs33
                    LET l_qcs.qcs40 = l_qcs.qcs34
                    LET l_qcs.qcs41 = l_qcs.qcs35
                    #FUN-BB0085-add-str--
                    LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
                    LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
                    LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
                    LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
                    LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
                    LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)
                    #FUN-BB0085-add-end--

                    INSERT INTO qcs_file VALUES l_qcs.*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("","","","",SQLCA.SQLCODE,"","",1)
                       LET g_success = 'N'
                       EXIT FOREACH
                    END IF
                    
                    #寫入批序號資料
                    FOREACH p001_rvbs2 USING l_qcs.qcs01,l_qcs.qcs02,l_rvbs04 INTO l_rvbs.*  #抓取批序號資料
                       #抓取已產生的資料
                       SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                        WHERE qcs01 =l_qcs.qcs01
                          AND qcs02 =l_qcs.qcs02
                          AND rvbs13=qcs05
                          AND qcs01 = rvbs01
                          AND qcs02 = rvbs02
                          AND rvbs03 = l_rvbs.rvbs03
                          AND rvbs04 = l_rvbs.rvbs04
                          AND rvbs08 = l_rvbs.rvbs08
                          AND rvbs00[1,7] = 'aqct110'
                          AND qcs14 !='X'
                          AND qcs00 = '1'
                          AND rvbs09 = 1
                       IF cl_null(l_rvbs06s) THEN
                          LET l_rvbs06s=0
                       END IF
                       
                       LET l_rvbs.rvbs00 = 'aqct110'
                       LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06s
                       LET l_rvbs.rvbs10 = 0
                       LET l_rvbs.rvbs11 = 0
                       LET l_rvbs.rvbs12 = 0
                       LET l_rvbs.rvbs13 = l_qcs.qcs05
                       LET l_rvbs.rvbsplant = g_plant
                       LET l_rvbs.rvbslegal = g_legal

                       INSERT INTO rvbs_file VALUES (l_rvbs.*)
                    END FOREACH
                END FOREACH
             ELSE    #不拆分
                SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file
                 WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF

                SELECT SUM(qcs22) INTO l_qcs22s FROM qcs_file
                 WHERE qcs00='1' AND qcs01= l_rva.rva01 
                   AND qcs02 = l_rvb.rvb02 AND qcs14 <>'X'
                IF cl_null(l_qcs22s) THEN LET l_qcs22s = 0 END IF
                LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22s
                IF l_qcs.qcs22 = 0 THEN
                   LET l_s = 'N'
                   CONTINUE FOREACH
                END IF

                LET l_qcs22 = l_qcs.qcs22
                LET l_qcs.qcs30 = l_rvb.rvb80
                LET l_qcs.qcs31 = l_rvb.rvb81
                LET l_qcs.qcs32 = l_rvb.rvb82
                LET l_qcs.qcs33 = l_rvb.rvb83
                LET l_qcs.qcs34 = l_rvb.rvb84
                LET l_qcs.qcs35 = l_rvb.rvb85

                SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file     #FUN-BB0085 add ima44
                 WHERE ima01 = l_qcs.qcs021

                IF g_sma.sma115 = 'Y' AND l_qcs22s <> 0 THEN
                   IF l_ima906 = '3' THEN
                      LET l_qcs.qcs32 = l_qcs.qcs22
                      IF l_qcs.qcs34 <> 0 THEN
                         LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
                      ELSE
                         LET l_qcs.qcs35 = 0
                      END IF
                   ELSE
                      IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN   #No.MOD-CC0009
                         LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
                         LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
                      END IF                                                                    #No.MOD-CC0009
                   END IF
                END IF
                LET l_qcs.qcs09 = '1'
                LET l_qcs.qcs091 = l_qcs.qcs22
                LET l_qcs.qcs36 = l_qcs.qcs30
                LET l_qcs.qcs37 = l_qcs.qcs31
                LET l_qcs.qcs38 = l_qcs.qcs32
                LET l_qcs.qcs39 = l_qcs.qcs33
                LET l_qcs.qcs40 = l_qcs.qcs34
                LET l_qcs.qcs41 = l_qcs.qcs35
                #FUN-BB0085-add-str--
                LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
                LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
                LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
                LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
                LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
                LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)
                #FUN-BB0085-add-end--
#             END IF      #TQC-C30012
                SELECT COUNT(*) INTO l_n                       
                  FROM qcs_file WHERE qcs01 = l_rva.rva01
                                  AND qcs14 != 'X'              #MOD-C30382 add
                SELECT SUM(qcs22) INTO l_q FROM qcs_file
                 WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02 
                   AND qcs14 != 'X'                             #MOD-C30382 add
             
                IF l_q >=l_rvb.rvb07 AND l_n >=1 THEN
                   CALL cl_err('','aqc-335',1)
                   LET l_t = 'N'
                   EXIT FOREACH                     
                ELSE
                   LET l_t = 'Y'
                END IF
   
                INSERT INTO qcs_file VALUES l_qcs.*									
                IF SQLCA.sqlcode THEN	
                   CALL cl_err3("","","","",SQLCA.SQLCODE,"","",1)																					
                   LET g_success = 'N'											
                   EXIT FOREACH											
                END IF
                SELECT ima921 INTO l_ima921 FROM ima_file
                 WHERE ima01 = l_qcs.qcs021
                IF l_ima918="Y" OR l_ima921="Y" THEN 
                   FOREACH p001_rvbs USING l_qcs.qcs01,l_qcs.qcs02 INTO l_rvbs.*  #抓取批序號資料
                      #抓取已產生的資料
                      SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                       WHERE qcs01 =l_qcs.qcs01
                         AND qcs02 =l_qcs.qcs02
                         AND rvbs13=qcs05
                         AND qcs01 = rvbs01
                         AND qcs02 = rvbs02
                         AND rvbs03 = l_rvbs.rvbs03
                         AND rvbs04 = l_rvbs.rvbs04
                         AND rvbs08 = l_rvbs.rvbs08
                         AND rvbs00[1,7] = 'aqct110'
                         AND qcs14 !='X'
                         AND qcs00 = '1'
                         AND rvbs09 = 1
                      IF cl_null(l_rvbs06s) THEN
                         LET l_rvbs06s=0
                      END IF

                      LET l_rvbs.rvbs00 = 'aqct110'
                      LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06s
                      LET l_rvbs.rvbs10 = 0
                      LET l_rvbs.rvbs11 = 0
                      LET l_rvbs.rvbs12 = 0
                      LET l_rvbs.rvbs13 = l_qcs.qcs05
                      LET l_rvbs.rvbsplant = g_plant 
                      LET l_rvbs.rvbslegal = g_legal 

                      INSERT INTO rvbs_file VALUES (l_rvbs.*)
                   END FOREACH
                END IF
             END IF      #TQC-C30012 add
#No.TQC-B90236----add---end---------

   #產生QC單身資料

             LET l_s = 'Y'
             LET l_flag = ' '		
             
			 LET l_yn = 0   #MOD-BB0073 add
                                    
             SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn											
               FROM qcc_file,ecm_file,rvb_file,pmn_file											
              WHERE rvb01 = l_qcs.qcs01											
                AND rvb02 = l_qcs.qcs02											
                AND rvb04 = pmn01											
                AND rvb03 = pmn02											
                AND pmn41 = ecm01											
                AND pmn46 = ecm03											
                AND qcc01 = l_qcs.qcs021											
                AND qcc011 = ecm04											
                AND qcc08 IN ('1','9')											
                AND ecm012 = pmn012											
              GROUP BY ecm04											
            #SELECT ima101 INTO l_ima101 #MOD-D20123 mark
             SELECT ima101 INTO g_ima101 #MOD-D20123 add
               FROM ima_file 
             #WHERE ima01 = l_qcs021     #MOD-D20123 mark
              WHERE ima01 = l_qcs.qcs021 #MOD-D20123 add
											
             IF cl_null(l_yn) OR l_yn<=0 THEN											
                SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn											
                  FROM qcc_file,ecm_file,rvb_file,pmn_file											
                 WHERE rvb01 = l_qcs.qcs01											
                   AND rvb02 = l_qcs.qcs02											
                   AND rvb04 = pmn01											
                   AND rvb03 = pmn02											
                   AND pmn41 = ecm01											
                   AND pmn46 = ecm03											
                   AND qcc01 = '*'											
                   AND qcc011 = ecm04											
                   AND qcc08 IN ('1','9')											
                   AND ecm012 = pmn012											
                 GROUP BY ecm04											
											
                 IF cl_null(l_yn) OR l_yn<=0 THEN											
                    SELECT sgm04,COUNT(*) INTO l_ecm04,l_yn											
                      FROM qcc_file,sgm_file,rvb_file,pmn_file											
                     WHERE rvb01=l_qcs.qcs01											
                       AND rvb02=l_qcs.qcs02											
                       AND rvb04=pmn01											
                       AND rvb03=pmn02											
                       AND pmn41=sgm02											
                       AND pmn32=sgm03											
                       AND sgm012 = pmn012											
                       AND qcc01=l_qcs.qcs021											
                       AND qcc011=sgm04											
                       AND qcc08 IN ('1','9')											
                     GROUP BY sgm04											
                END IF											
             END IF											
											
             IF l_yn > 0 THEN											
                LET l_flag = '1'          #--製程委外抓站別檢驗項目											
             ELSE											
                LET l_sql = " SELECT COUNT(*) FROM qcd_file ",											
                            " WHERE qcd01 = ? ",											
                            " AND qcd08 in ('1','9') "											
                PREPARE qcd_sel FROM l_sql											
                EXECUTE qcd_sel USING l_qcs.qcs021 INTO l_yn											
											
                IF l_yn > 0 THEN          #--- 料件檢驗項目											
                   LET l_flag = '2'											
                ELSE											
                   LET l_flag = '3'       #--- 材料類別檢驗項目											
                END IF											
             END IF											
											
             CASE l_flag											
                WHEN '1'											
                   LET l_sql = "SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062, ",											
                               "       qccacti,qccuser,qccgrup,qccmodu,qccdate ",											
                               "  FROM qcc_file ",											
                               " WHERE qcc01 = ? ",											
                               "   AND qcc011 = ? ",											
                               "   AND qcc08 IN ('1','9') ",											
                               " ORDER BY qcc02"											
                   PREPARE qcc_cur1 FROM l_sql											
                   DECLARE qcc_cur CURSOR FOR qcc_cur1											
                   DECLARE qcc_cur2 SCROLL CURSOR FOR qcc_cur1	
											
                   OPEN qcc_cur2 USING l_qcs.qcs021,l_ecm04											
                   FETCH FIRST qcc_cur2 INTO l_qcd.*											
                   IF SQLCA.sqlcode = 100 THEN											
                      LET l_qcs021 = '*'											
                   ELSE											
                      LET l_qcs021 = l_qcs.qcs021											
                   END IF											
											
                   LET seq = 1                 #MOD-AC0311
                   FOREACH qcc_cur USING l_qcs021,l_ecm04 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                             RETURNING l_ac_num,l_re_num											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03 = l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN											
                            LET l_qct11 = 0											
                         END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)											
                            AND qdf01 = l_qcd.qcd03											
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 =單頭.ima101  #MOD-BA0036 mark
                         #WHERE qdg01 =l_ima101     #MOD-BA0036 #MOD-D20123 mark
                          WHERE qdg01 =g_ima101     #MOD-D20123 add
                            AND qdg02 = l_qcd.qcd03											
                            AND qdg03 = l_qdf02											
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
											
                      IF l_qct11 > l_qcs.qcs22 THEN											
                         LET l_qct11 = l_qcs.qcs22											
                      END IF											
											
                      IF cl_null(l_qct11) THEN											
                         LET l_qct11 = 0											
                      END IF											
											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                         VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,											
                                l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                0,'1',l_ac_num,l_re_num,l_qct11,											
                                l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                l_qct14,l_qct15,											
                                g_plant,g_legal)											
                      LET seq = seq + 1											
                   END FOREACH											
                WHEN '2'											
                   LET l_sql = "  SELECT * FROM qcd_file",											
                               "  WHERE qcd01 = ? ",											
                               "    AND qcd08 IN ('1','9') ",											
                               "   ORDER BY qcd02"											
                   PREPARE qcd_cur1 FROM l_sql											
                   DECLARE qcd_cur CURSOR FOR qcd_cur1											
											
                   LET seq = 1            #MOD-AC0311
                   FOREACH qcd_cur USING l_qcs.qcs021 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                             RETURNING l_ac_num,l_re_num											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03 = l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN											
                            LET l_qct11 = 0											
                         END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE qdf03 <= l_qcs.qcs22 
                            AND qdf04 >= l_qcs.qcs22											
                            AND qdf01 = l_qcd.qcd03											
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 = l_ima101 #MOD-D20123 mark											
                          WHERE qdg01 = g_ima101 #MOD-D20123 add
                            AND qdg02 = l_qcd.qcd03											
                            AND qdg03 = l_qdf02											
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
											
                      IF l_qct11 > l_qcs.qcs22 THEN											
                         LET l_qct11 = l_qcs.qcs22											
                      END IF											
             											
                      IF cl_null(l_qct11) THEN											
                         LET l_qct11 = 0											
                      END IF											
											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                                    #VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,	#MOD-AC0311										
                                     VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,    #MOD-AC0311
                                            l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                            0,'1',l_ac_num,l_re_num,l_qct11,											
                                            l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                            l_qct14,l_qct15,											
                                            g_plant,g_legal)											
                      LET seq = seq + 1											
                   END FOREACH											
                WHEN '3'      #--- 材料類別檢驗項目											
                   LET l_sql = " SELECT qck_file.* FROM qck_file,ima_file ",											
                               "  WHERE qck01 = ima109 AND ima01 = ?",											
                               "    AND qck08 IN ('1','9') ",											
                               "  ORDER BY qck02"											
                   PREPARE qck_cur1 FROM l_sql											
                   DECLARE qck_cur CURSOR FOR qck_cur1											
 
                   LET seq = 1         #MOD-AC0311											
                   FOREACH qck_cur USING l_qcs.qcs021 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                              RETURNING l_ac_num,l_re_num											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num=0 LET l_re_num=1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03=l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN LET l_qct11=0 END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11											
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)											
                            AND qdf01 = l_qcd.qcd03											
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 = l_ima101 #MOD-D20123 mark											
                          WHERE qdg01 = g_ima101 #MOD-D20123 add
                            AND qdg02 = l_qcd.qcd03											
                            AND qdg03 = l_qdf02											
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
                      IF l_qct11 > l_qcs.qcs22 THEN 
                         LET l_qct11=l_qcs.qcs22 
                      END IF											
                      IF cl_null(l_qct11) THEN 
                         LET l_qct11=0 
                      END IF											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                                     VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,											
                                            l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                            0,'1',l_ac_num,l_re_num,l_qct11,											
                                            l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                            l_qct14,l_qct15,											
                                            g_plant,g_legal)											
                      LET seq=seq+1											
                   END FOREACH											
             END CASE											
         END FOREACH
      END FOREACH								

END FUNCTION

FUNCTION p001_defqty(l_def,l_rate,l_qcd03,l_qcd05)											#對送驗量做四捨五入								
#DEFINE      l_ima915  LIKE ima_file.ima915   #MOD-C70226 mark
DEFINE      l_pmh09   LIKE pmh_file.pmh09
DEFINE      l_pmh15   LIKE pmh_file.pmh15
DEFINE      l_pmh16   LIKE pmh_file.pmh16
DEFINE      l_qcb04   LIKE qcb_file.qcb04
DEFINE      l_qca03   LIKE qca_file.qca03
DEFINE      l_qca04   LIKE qca_file.qca04
DEFINE      l_qca05   LIKE qca_file.qca05
DEFINE      l_qca06   LIKE qca_file.qca06
DEFINE      l_qdg04   LIKE qdg_file.qdg04
DEFINE      l_def     LIKE type_file.num5
#DEFINE      l_rate    LIKE type_file.num5
DEFINE      l_rate    LIKE qcd_file.qcd04   #MOD-B70290 
DEFINE l_qcd03   LIKE qcd_file.qcd03
DEFINE l_qcd05   LIKE qcd_file.qcd05
DEFINE l_sql      STRING



   LET l_qty = l_qcs22											
   LET l_qcs22 = l_qty											
  #MOD-C70226 str mark-----
  #LET l_ima915 = ''											
  #SELECT ima915 INTO l_ima915 FROM ima_file											
  # WHERE ima01=l_qcs.qcs021											
  #IF cl_null(l_ima915) THEN											
  #   LET l_ima915 = '0'											
  #END IF		
  #MOD-C70226 end mark-----									
											
   LET l_sql="SELECT pmh09,pmh15,pmh16 FROM pmh_file",											
             " WHERE pmh01 ='", l_qcs.qcs021,"'",											
             "   AND pmh02 ='", l_qcs.qcs03,"'",											
             "   AND pmh21 ='", l_ecm04,"'",											
             "   AND pmh22 ='", l_type,"'",											
             "   AND pmh23 = ' ' "											
   PREPARE pmh_cur2_pre FROM l_sql											
   DECLARE pmh_cur2 CURSOR FOR pmh_cur2_pre											
											
   OPEN pmh_cur2											
   FETCH pmh_cur2 INTO l_pmh09,l_pmh15,l_pmh16											
  #IF STATUS OR l_ima915 = '0' THEN           #MOD-C70226 mark
   IF STATUS THEN                             #MOD-C70226 add											
      SELECT pmc906,pmc905,pmc907											
        INTO l_pmh09,l_pmh15,l_pmh16											
        FROM pmc_file											
       WHERE pmc01 = l_qcs.qcs03											
      IF STATUS OR cl_null(l_pmh09) OR cl_null(l_pmh15)											
         OR cl_null(l_pmh16) THEN											
         SELECT ima100,ima101,ima102											
           INTO l_pmh09,l_pmh15,l_pmh16											
           FROM ima_file											
          WHERE ima01 = l_qcs.qcs021											
         IF STATUS THEN											
            LET l_pmh09=''											
            LET l_pmh15=''											
            LET l_pmh16=''											
            RETURN 0											
         END IF											
      END IF											
   END IF											
											
   LET l_qcs.qcs17 = l_pmh16											
   IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF											
   IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF											
   IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF											
											
   IF l_pmh15='1' THEN											
      SELECT qcb04											
        INTO l_qcb04											
        FROM qca_file,qcb_file											
       WHERE (l_qcs22 BETWEEN qca01 AND qca02)											
         AND qcb02 = l_rate											
         AND qca03 = qcb03											
         AND qca07 = l_qcs.qcs17											
         AND qcb01 = l_qcs.qcs21											
											
      IF NOT cl_null(l_qcb04) THEN											
         SELECT UNIQUE qca03,qca04,qca05,qca06											
           INTO l_qca03,l_qca04,l_qca05,l_qca06											
           FROM qca_file											
          WHERE qca03=l_qcb04											
         IF STATUS THEN											
            LET l_qca03 = 0											
            LET l_qca04 = 0											
            LET l_qca05 = 0											
            LET l_qca06 = 0											
         END IF											
      END IF											
   END IF											
											
   IF l_pmh15 = '2' THEN											
      SELECT qcb04 INTO l_qcb04											
        FROM qch_file,qcb_file											
       WHERE (l_qcs22 BETWEEN qch01 AND qch02)											
         AND qcb02 = l_rate											
         AND qch03 = qcb03											
         AND qch07 = l_qcs.qcs17											
         AND qcb01 = l_qcs.qcs21											
											
      IF NOT cl_null(l_qcb04) THEN											
         SELECT UNIQUE qch03,qch04,qch05,qch06											
           INTO l_qca03,l_qca04,l_qca05,l_qca06											
           FROM qch_file											
          WHERE qch03=l_qcb04											
         IF STATUS THEN											
            LET l_qca03 = 0											
            LET l_qca04 = 0											
            LET l_qca05 = 0											
            LET l_qca06 = 0											
         END IF											
      END IF											
   END IF											
											
   IF l_qcs22 = 1 THEN											
      LET l_qca04 = 1											
      LET l_qca05 = 1											
      LET l_qca06 = 1											
   END IF											
											
     CASE l_qcd.qcd05											
#MOD-AC0311 ---------------Begin--------------
#       WHEN '1' OR '2'											
#          CASE l_pmh09											
#             WHEN 'N'											
#                RETURN l_qca04											
#             WHEN 'T'											
#                RETURN l_qca05											
#             WHEN 'R'											
#                RETURN l_qca06											
#             OTHERWISE											
#                RETURN 0											
#          END CASE											
# 
#       WHEN '3' OR '4'	
#          CASE l_pmh09											
#             WHEN 'N'											
#                LET l_qcd03 = l_qcd.qcd03											
#             WHEN 'T'											
#                LET l_qcd03 = l_qcd.qcd03+1											
#                IF l_qcd03 = 8 THEN											
#                   LET l_qcd03 = 'T'											
#                END IF											
#             WHEN 'R'											
#                LET l_qcd03 = l_qcd.qcd03-1											
#                IF l_qcd03 = 0 THEN											
#                   LET l_qcd03 = 'R'											
#                END IF											
#             OTHERWISE											
#                RETURN 0											
#          END CASE			
        WHEN '1' 
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
        WHEN '2'
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
        WHEN '3'
           CASE l_pmh09
              WHEN 'N'
                 LET l_qcd03 = l_qcd.qcd03
              WHEN 'T'
                 LET l_qcd03 = l_qcd.qcd03+1
                 IF l_qcd03 = 8 THEN
                    LET l_qcd03 = 'T'
                 END IF
              WHEN 'R'
                 LET l_qcd03 = l_qcd.qcd03-1
                 IF l_qcd03 = 0 THEN
                    LET l_qcd03 = 'R'
                 END IF
              OTHERWISE
                 RETURN 0
           END CASE
           SELECT qdf02 INTO l_qdf02
             FROM qdf_file
           #WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 mark
            WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
              AND qdf01 = l_qcd03
           SELECT qdg04 INTO l_qdg04
             FROM qdg_file
           #WHERE qdg01 = l_ima101 #MOD-D20123 mark
            WHERE qdg01 = g_ima101 #MOD-D20123 add
              AND qdg02 = l_qcd03
              AND qdg03 = l_qdf02
           IF STATUS THEN
              LET l_qdg04 = 0
           END IF
           RETURN l_qdg04
        WHEN '4'
           CASE l_pmh09
              WHEN 'N'
                 LET l_qcd03 = l_qcd.qcd03
              WHEN 'T'
                 LET l_qcd03 = l_qcd.qcd03+1
                 IF l_qcd03 = 8 THEN
                    LET l_qcd03 = 'T'
                 END IF
              WHEN 'R'
                 LET l_qcd03 = l_qcd.qcd03-1
                 IF l_qcd03 = 0 THEN
                    LET l_qcd03 = 'R'
                 END IF
              OTHERWISE
                 RETURN 0
           END CASE
#MOD-AC0311 --------------End------------------								
           SELECT qdf02 INTO l_qdf02											
             FROM qdf_file											
           #WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)	#MOD-D20123 mark										
            WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
              AND qdf01 = l_qcd03											
           SELECT qdg04 INTO l_qdg04											
             FROM qdg_file											
           #WHERE qdg01 = l_ima101 #MOD-D20123 mark											
            WHERE qdg01 = g_ima101 #MOD-D20123 add
              AND qdg02 = l_qcd03											
              AND qdg03 = l_qdf02											
           IF STATUS THEN											
              LET l_qdg04 = 0											
           END IF											
           RETURN l_qdg04											
     END CASE											
 END FUNCTION





	
