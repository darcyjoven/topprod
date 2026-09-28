# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 采购扫描转收货作业
# Date & Author..: 2016-03-16 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


GLOBALS
DEFINE g_pmm01    LIKE pmm_file.pmm01    #采购单号
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_pmn20    LIKE pmn_file.pmn20    #数量
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_sql      STRING
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
FUNCTION aws_create_apmt110mei()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_apmt110mei_process()
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
FUNCTION aws_create_apmt110mei_process()
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
   DEFINE l_t001_file1      RECORD                          #单身
                    pmm01      LIKE pmm_file.pmm01,         #到货单
                    pmn02      LIKE pmn_file.pmn02,         #项次
                    pmn01      LIKE pmn_file.pmn01,         #采购单号
                    pmn02a     LIKE pmn_file.pmn02,         #采购单项次
                    pmn04      LIKE pmn_file.pmn04,         #料件
                    pmn20a     LIKE pmn_file.pmn20,         #需求数量
                    pmn20b     LIKE pmn_file.pmn20          #匹配数量
                 END RECORD  
   DROP TABLE t001_file1 
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

        LET g_pmm01             = aws_ttsrv_getRecordField(l_node1,"tc_sib01")
        LET l_t001_file1.pmm01  = g_pmm01
        LET l_t001_file1.pmn02  = aws_ttsrv_getRecordField(l_node1,"tc_sib02") 
        LET l_t001_file1.pmn01  = aws_ttsrv_getRecordField(l_node1,"tc_sib03") 
        LET l_t001_file1.pmn02a = aws_ttsrv_getRecordField(l_node1,"tc_sib04") 
        LET l_t001_file1.pmn04  = aws_ttsrv_getRecordField(l_node1,"ima01") 
        LET l_t001_file1.pmn20a = aws_ttsrv_getRecordField(l_node1,"tc_sib05") 
        LET l_t001_file1.pmn20b = aws_ttsrv_getRecordField(l_node1,"tc_sib05a")     

        INSERT INTO t001_file1 VALUES (l_t001_file1.*) 

    END FOR
    IF g_status.code='0' THEN 
       CALL t001_loadmei()
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

FUNCTION t001_loadmei() 
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_msg        LIKE type_file.chr50 
   
   BEGIN WORK
   CALL t001_rva_rvbmei(g_pmm01)

   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF
END FUNCTION


FUNCTION t001_rva_rvbmei(p_pmm01)
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
  LET g_rva.rvaud06 = m_mt_dlv.tc_sia01  #送货单号
  LET g_rva.rvaprno='0'

  SELECT smyapr INTO l_smyapr FROM smy_file
   WHERE smysys='apm' AND smykind='3' AND smyslip=l_t1
  LET g_rva.rvamksg = l_smyapr      #是否簽核

  LET g_rva.rvacrat=g_today
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
   CALL p220_get_rvb39mei(g_rvb.rvb04,g_rvb.rvb05,g_rvb.rvb19)
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

END FUNCTION

FUNCTION p220_get_rvb39mei(p_rvb04,p_rvb05,p_rvb19)
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







	
