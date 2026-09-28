# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 调拨更新状态作业
# Date & Author..: 2016/4/21 11:35:42 shenran


DATABASE ds

GLOBALS "../../config/top.global"


GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


GLOBALS
DEFINE g_imm01    LIKE imm_file.imm01    #调拨单号
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_pmn20    LIKE pmn_file.pmn20    #数量
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_sql      STRING
DEFINE g_cnt1     LIKE type_file.num10
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
DEFINE g_imm     RECORD LIKE imm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_yy,g_mm LIKE type_file.num5
DEFINE g_sw      LIKE type_file.num5   #No.FUN-690026 SMALLINT
DEFINE g_factor  LIKE img_file.img21
DEFINE g_forupd_sql         STRING
DEFINE g_debit,g_credit    LIKE img_file.img26
DEFINE g_ima25,g_ima25_2   LIKE ima_file.ima25
DEFINE g_img10,g_img10_2   LIKE img_file.img10
DEFINE b_imn    RECORD LIKE imn_file.*


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
FUNCTION aws_create_aimt324mei()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_aimt324mei_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE t324_file1 
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
FUNCTION aws_create_aimt324mei_process()
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
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07
   DEFINE l_t324_file1      RECORD                          #单身
                    imm01      LIKE imm_file.imm01,         #调拨单
                    imn02      LIKE imn_file.imn02,         #项次
                    imn03      LIKE imn_file.imn03,         #料件
                    imn10      LIKE imn_file.imn10,         #申请数量
                    imn22a     LIKE imn_file.imn10          #实际数量
                 END RECORD  
   DROP TABLE t324_file1  
   CREATE TEMP TABLE t324_file1(
                    imm01      LIKE imm_file.imm01,         #调拨单
                    imn02      LIKE imn_file.imn02,         #项次
                    imn03      LIKE imn_file.imn03,         #料件
                    imn10      LIKE imn_file.imn10,         #申请数量
                    imn22a     LIKE imn_file.imn10)         #实际数量             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'

    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
       
        LET l_t324_file1.imm01  = aws_ttsrv_getRecordField(l_node1,"imm01")
        LET g_imm01             = l_t324_file1.imm01
        LET l_t324_file1.imn02  = aws_ttsrv_getRecordField(l_node1,"imn02") 
        LET l_t324_file1.imn03  = aws_ttsrv_getRecordField(l_node1,"imn03") 
        LET l_t324_file1.imn10  = aws_ttsrv_getRecordField(l_node1,"imn10") 
        LET l_t324_file1.imn22a = aws_ttsrv_getRecordField(l_node1,"imn22a")     

        INSERT INTO t324_file1 VALUES (l_t324_file1.*)

    END FOR
    IF g_status.code='0' THEN
       CALL t324_loadmei()
       
       IF g_success = 'N' THEN
       	 IF g_status.code='0' THEN
       	 	   LET g_status.code = "-1"
             LET g_status.description = "接口存在错误,请联系程序员!"
       	 END IF
       END IF
    END IF
END FUNCTION

FUNCTION t324_loadmei()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_sql       STRING
   DEFINE l_msg       LIKE type_file.chr50
   DEFINE l_imm      RECORD                          #单身
              imm01      LIKE imm_file.imm01,         #调拨单
              imn02      LIKE imn_file.imn02,         #项次
              imn03      LIKE imn_file.imn03,         #料件
              imn10      LIKE imn_file.imn10,         #申请数量
              imn22a     LIKE imn_file.imn10          #实际数量
                    END RECORD
   
   BEGIN WORK

   LET l_sql=" select * from t324_file1",
             " where imn22a>0",
             " order by imm01,imn02"
     PREPARE t324_ipb4 FROM l_sql
     DECLARE t324_ic4 CURSOR FOR t324_ipb4
     FOREACH t324_ic4 INTO l_imm.*
        IF STATUS THEN
          #EXIT FOREACH
          LET g_status.code = "-1"
          LET g_status.description = "抓取数据失败!"
          RETURN 
        END IF
        UPDATE imn_file SET imn22=l_imm.imn22a
                          #  imnud07=l_imm.imn10
        WHERE imn01 = l_imm.imm01
         AND  imn02 = l_imm.imn02
     END FOREACH
   LET g_prog='aimt324'
   CALL t324_postmei()
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION t324_postmei()
   DEFINE l_cnt    LIKE type_file.num10   #No.FUN-690026 INTEGER
   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
   DEFINE l_imn10  LIKE imn_file.imn10
   DEFINE l_imn29  LIKE imn_file.imn29
   DEFINE l_imn03  LIKE imn_file.imn03
   DEFINE l_qcs01  LIKE qcs_file.qcs01
   DEFINE l_qcs02  LIKE qcs_file.qcs02
   DEFINE l_imd11  LIKE imd_file.imd11   #MOD-A70068
   DEFINE l_imd11_1 LIKE imd_file.imd11   #MOD-B10114 add
   DEFINE l_qcs091 LIKE qcs_file.qcs091
 
   SELECT * INTO g_imm.* FROM imm_file
    WHERE imm01 = g_imm01
   IF g_imm.imm01 IS NULL THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "请先选取欲处理的资料！!"
      RETURN
   END IF
   IF g_imm.immconf = 'N' THEN #FUN-660029
   	   LET g_success ='N'
       LET g_status.code = "-1"
       LET g_status.description = "本资料尚未审核，不可过账!"
       RETURN
   END IF

   IF g_imm.imm03 = 'Y' THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "此资料已过账!"
      RETURN
   END IF

   IF g_imm.immconf = 'X' THEN #FUN-660029
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "此笔资料已作废!"
      RETURN
   END IF

   IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "异动日期不可小於关账日期, 请重新录入!"
      RETURN
   END IF

   CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "您所录入的日期其年度大於当前使用会计年度!"
      RETURN
   ELSE
      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
         LET g_success ='N'
         LET g_status.code = "-1"
         LET g_status.description = "您所录入的日期其月份大於当前使用会计期间!"
         RETURN
      END IF
   END IF


   LET l_cnt=0

   SELECT COUNT(*) INTO l_cnt
     FROM imn_file
    WHERE imn01 = g_imm.imm01 

   IF l_cnt = 0 OR l_cnt IS NULL THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "单身未录入资料, 不可审核或过账!"      
      RETURN
   END IF

   LET l_sql = "SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
               " WHERE imn01= '",g_imm.imm01,"'"
   PREPARE t324_curs1 FROM l_sql

   DECLARE t324_pre1 CURSOR FOR t324_curs1

   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
      IF l_imn29='Y' THEN
         LET l_qcs091=0
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01 = l_qcs01
            AND qcs02 = l_qcs02
            AND qcs14 = 'Y'

         IF cl_null(l_qcs091) THEN
            LET l_qcs091 = 0
         END IF

         IF l_qcs091 < l_imn10 THEN
              LET g_success ='N'
              LET g_status.code = "-1"
              LET g_status.description = "合格量必须大於异动量!"
              RETURN
         END IF
      END IF
   END FOREACH

   DECLARE t324_s1_c CURSOR FOR
     SELECT * FROM imn_file WHERE imn01=g_imm.imm01                                                                      


   FOREACH t324_s1_c INTO b_imn.*
      IF STATUS THEN EXIT FOREACH END IF

     #撥入倉
      LET l_imd11 = ''
      SELECT imd11 INTO l_imd11 FROM imd_file 
       WHERE imd01 = b_imn.imn15
     #MOD-B10114---modify---start---
     #IF l_imd11 = 'N' OR l_imd11 IS NULL THEN   
     #撥出倉
      LET l_imd11_1 = ''
      SELECT imd11 INTO l_imd11_1 FROM imd_file 
       WHERE imd01 = b_imn.imn04
      IF l_imd11_1 = 'Y' AND (l_imd11 = 'N' OR l_imd11 IS NULL) THEN 
     #MOD-B10114---modify---end---
         CALL t324_chk_avl_stkmei(b_imn.*)     
         IF g_success='N' THEN
            RETURN
         END IF
      END IF   
      #-----END MOD-A70068-----

      IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
      
      
      SELECT *
        FROM img_file WHERE img01=b_imn.imn03 AND
                            img02=b_imn.imn15 AND
                            img03=b_imn.imn16 AND
                            img04=b_imn.imn17
      IF SQLCA.sqlcode THEN
            CALL s_add_img(b_imn.imn03,b_imn.imn15,
                           b_imn.imn16,b_imn.imn17,
                           g_imm.imm01      ,b_imn.imn02,
                           g_imm.imm02)
      END IF

      IF NOT s_stkminus(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
                        b_imn.imn10,1,g_imm.imm02) THEN
           LET g_success ='N'
           LET g_status.code = "-1"
           LET g_status.description = "s_stkminus函数报错!"
           RETURN
      END IF

      #-->撥出更新
      IF t324_tmei(b_imn.*) THEN
           LET g_success ='N'
           LET g_status.code = "-1"
           LET g_status.description = "t324_tmei函数报错!"
           RETURN
      END IF
#mark by shenran 暂时不考虑多单位 str
#      IF g_sma.sma115 = 'Y' THEN
#         CALL t324_upd_s(b_imn.*)
#      END IF
#mark by shenran 暂时不考虑多单位 end

      #-->撥入更新
      IF t324_tmei2mei(b_imn.*) THEN
          LET g_success ='N'
          LET g_status.code = "-1"
          LET g_status.description = "t324_tmei2mei函数报错!"
          RETURN
      END IF
#mark by shenran 暂时不考虑多单位 str
#      IF g_sma.sma115 = 'Y' THEN
#         CALL t324_upd_t(b_imn.*)
#      END IF
#mark by shenran 暂时不考虑多单位 end
 
   END FOREACH
  
   UPDATE imm_file SET imm03 = 'Y',
                       imm04 = 'Y'
    WHERE imm01 = g_imm.imm01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "更新imm_file有误!"
      RETURN
   END IF


END FUNCTION


FUNCTION t324_chk_avl_stkmei(p_imn)   
  DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3
  DEFINE l_oeb12   LIKE oeb_file.oeb12
  DEFINE l_qoh     LIKE oeb_file.oeb12 
  DEFINE p_imn     RECORD LIKE imn_file.*   
  DEFINE l_ima25   LIKE ima_file.ima25

      
     CALL s_getstock(p_imn.imn03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
     SELECT SUM(oeb905*oeb05_fac)
      INTO l_oeb12
      FROM oeb_file,oea_file   
     WHERE oeb04=p_imn.imn03
       AND oeb19= 'Y'
       AND oeb70= 'N'  
       AND oea01 = oeb01 AND oeaconf !='X' 
    IF l_oeb12 IS NULL THEN
        LET l_oeb12 = 0
    END IF
    LET l_qoh = l_avl_stk - l_oeb12
    SELECT ima25 INTO l_ima25 FROM ima_file
      WHERE ima01 = b_imn.imn03
    CALL s_umfchk(b_imn.imn03,p_imn.imn09,l_ima25)
         RETURNING g_sw,g_factor
    IF l_qoh < p_imn.imn10*g_factor AND g_sma.sma894[4,4]='N' THEN 

       LET g_success ='N'
       LET g_status.code = "-1"
       LET g_status.description = "调拨量 > (库存量-备置量) 无法调拨, 请重新输入!"
       RETURN
    END IF 

END FUNCTION

#-->撥出更新
FUNCTION t324_tmei(p_imn)
DEFINE p_imn   RECORD LIKE imn_file.*,
       l_img   RECORD
               img16      LIKE img_file.img16,
               img23      LIKE img_file.img23,
               img24      LIKE img_file.img24,
               img09      LIKE img_file.img09,
               img21      LIKE img_file.img21
               END RECORD,
       l_qty   LIKE img_file.img10,
       l_factor  LIKE ima_file.ima31_fac  #MOD-A70117 add


    IF cl_null(p_imn.imn05) THEN LET p_imn.imn05=' ' END IF
    IF cl_null(p_imn.imn06) THEN LET p_imn.imn06=' ' END IF

    LET g_forupd_sql =
        "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
        " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06
    IF SQLCA.sqlcode THEN
       CALL cl_err("img_lock fail:", STATUS, 1)   #NO.TQC-93015
       LET g_success = 'N'
       RETURN 1
    ELSE
       FETCH img_lock INTO l_img.*,g_debit,g_img10
       IF SQLCA.sqlcode THEN
          CALL cl_err("sel img_file", STATUS, 1)   #NO.TQC-930155
          LET g_success = 'N'
          RETURN 1
       END IF
    END IF

   #str MOD-A70117 add
    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING g_cnt1,l_factor
    IF g_cnt1 = 1 THEN
       CALL cl_err('','mfg3075',1)
       LET g_success = 'N'
       RETURN 1
    END IF
    LET l_qty = p_imn.imn10 * l_factor
   #end MOD-A70117 add

#-->更新倉庫庫存明細資料
   #CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,p_imn.imn10,g_imm.imm02,  #FUN-8C0084  #MOD-A70117 mark
    CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,l_qty,g_imm.imm02,  #FUN-8C0084        #MOD-A70117
        '','','','',p_imn.imn01,p_imn.imn02,'','','','','','','','','','','','')   #No:FUN-860045

    IF g_success = 'N' THEN RETURN 1 END IF

#-->若庫存異動後其庫存量小於等於零時將該筆資料刪除
    CALL s_delimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06) #FUN-8C0084
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)


    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql

    OPEN ima_lock USING p_imn.imn03
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF

    FETCH ima_lock INTO g_ima25  #,g_ima86 #FUN-560183
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF

#-->料件庫存單位數量
    LET l_qty=p_imn.imn10 * l_img.img21
    IF cl_null(l_qty)  THEN RETURN 1 END IF

    IF s_udima(p_imn.imn03,             #料件編號
                           l_img.img23,             #是否可用倉儲
                           l_img.img24,             #是否為MRP可用倉儲
                           l_qty,                   #調撥數量(換算為料件庫存單位)
                           l_img.img16,             #最近一次撥出日期
                           -1)                      #表撥出
     THEN RETURN 1
        END IF
    IF g_success = 'N' THEN RETURN 1 END IF

#-->將已鎖住之資料釋放出來
    CLOSE img_lock
    CLOSE ima_lock
    RETURN 0
END FUNCTION
FUNCTION t324_tmei2mei(p_imn)
DEFINE
    p_imn      RECORD LIKE imn_file.*,
    l_img      RECORD
               img16      LIKE img_file.img16,
               img23      LIKE img_file.img23,
               img24      LIKE img_file.img24,
               img09      LIKE img_file.img09,
               img21      LIKE img_file.img21,
               img19      LIKE img_file.img19,
               img27      LIKE img_file.img27,
               img28      LIKE img_file.img28,
               img35      LIKE img_file.img35,
               img36      LIKE img_file.img36
               END RECORD,
    l_factor   LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
    l_qty      LIKE img_file.img10

    LET g_forupd_sql =
        "SELECT img15,img23,img24,img09,img21,img19,img27,",         #MOD-970033 img16 modify img15
               "img28,img35,img36,img26,img10 FROM img_file ",
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img2_lock CURSOR FROM g_forupd_sql

    OPEN img2_lock USING p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img2 fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF

    FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img2 fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF

#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima2_lock CURSOR FROM g_forupd_sql

    OPEN ima2_lock USING p_imn.imn03
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF
    FETCH ima2_lock INTO g_ima25_2  #,g_ima86_2 #FUN-560183
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF

    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING g_cnt1,l_factor
    IF g_cnt1 = 1 THEN
       CALL cl_err('','mfg3075',1)
       LET g_success = 'N'
       RETURN 1
    END IF
    LET l_qty = p_imn.imn10 * l_factor

     CALL s_upimg(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,+1,l_qty,g_imm.imm02,      #FUN-8C0084
        p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
        p_imn.imn01,p_imn.imn02,l_img.img09,l_qty,      l_img.img09,
        1,  l_img.img21,1,
        g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
        l_img.img36)

    IF g_success = 'N' THEN RETURN 1 END IF

#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    LET l_qty = p_imn.imn22 * l_img.img21
    IF s_udima(p_imn.imn03,            #料件編號
                           l_img.img23,            #是否可用倉儲
                           l_img.img24,            #是否為MRP可用倉儲
                           l_qty,                  #發料數量(換算為料件庫存單位)
                           l_img.img16,            #最近一次發料日期
                           +1)                     #表收料
         THEN RETURN  1 END IF
    IF g_success = 'N' THEN RETURN 1 END IF
#-->產生異動記錄檔
    #---- 97/06/20 insert 兩筆至 tlf_file 一出一入
    CALL t324_log_2mei(1,0,'1',p_imn.*)
    CALL t324_log_2mei(1,0,'0',p_imn.*)
    CLOSE img2_lock
    CLOSE ima2_lock
    RETURN 0
END FUNCTION
#處理異動記錄
FUNCTION t324_log_2mei(p_stdc,p_reason,p_code,p_imn)
DEFINE
    p_stdc          LIKE type_file.num5,      #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,      #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr1,      #出/入庫  #No.FUN-690026 VARCHAR(1)
    p_imn           RECORD LIKE imn_file.*
DEFINE
    l_img09         LIKE img_file.img09,
    l_factor        LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
    l_qty           LIKE img_file.img10

    LET l_qty=0
    SELECT img09 INTO l_img09 FROM img_file
       WHERE img01=p_imn.imn03 AND img02=p_imn.imn15
         AND img03=p_imn.imn16 AND img04=p_imn.imn17
    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img09) RETURNING g_cnt1,l_factor
    IF g_cnt1 = 1 THEN
       CALL cl_err('','mfg3075',1)
       LET g_success = 'N'
       RETURN 1
    END IF
    LET l_qty = p_imn.imn10 * l_factor


#----來源----
    LET g_tlf.tlf01=p_imn.imn03                 #異動料件編號
    LET g_tlf.tlf02=50                          #來源為倉庫(撥出)
    LET g_tlf.tlf020=g_plant                    #工廠別
    LET g_tlf.tlf021=p_imn.imn04                #倉庫別
    LET g_tlf.tlf022=p_imn.imn05                #儲位別
    LET g_tlf.tlf023=p_imn.imn06                #批號
    LET g_tlf.tlf024=g_img10 - p_imn.imn10      #異動後庫存數量
    LET g_tlf.tlf025=p_imn.imn09                #庫存單位(ima_file or img_file)
    LET g_tlf.tlf026=p_imn.imn01                #調撥單號
    LET g_tlf.tlf027=p_imn.imn02                #項次
#----目的----
    LET g_tlf.tlf03=50                          #資料目的為(撥入)
    LET g_tlf.tlf030=g_plant                    #工廠別
    LET g_tlf.tlf031=p_imn.imn15                #倉庫別
    LET g_tlf.tlf032=p_imn.imn16                #儲位別
    LET g_tlf.tlf033=p_imn.imn17                #批號
     LET g_tlf.tlf034=g_img10_2 + l_qty          #異動後庫存量    #-No:MOD-57002
    LET g_tlf.tlf035=p_imn.imn20                #庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=p_imn.imn01                #參考號碼
    LET g_tlf.tlf037=p_imn.imn02                #項次

    #---- 97/06/20 調撥作業來源目的碼
    IF p_code='1' THEN #-- 出
       LET g_tlf.tlf02=50
       LET g_tlf.tlf03=99
       LET g_tlf.tlf030=' '
       LET g_tlf.tlf031=' '
       LET g_tlf.tlf032=' '
       LET g_tlf.tlf033=' '
       LET g_tlf.tlf034=0
       LET g_tlf.tlf035=' '
       LET g_tlf.tlf036=' '
       LET g_tlf.tlf037=0
       LET g_tlf.tlf10=p_imn.imn10                 #調撥數量
       LET g_tlf.tlf11=p_imn.imn09                 #撥出單位
       LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
       LET g_tlf.tlf930=p_imn.imn9301  #FUN-670093
    ELSE               #-- 入
       LET g_tlf.tlf02=99
       LET g_tlf.tlf03=50
       LET g_tlf.tlf020=' '
       LET g_tlf.tlf021=' '
       LET g_tlf.tlf022=' '
       LET g_tlf.tlf023=' '
       LET g_tlf.tlf024=0
       LET g_tlf.tlf025=' '
       LET g_tlf.tlf026=' '
       LET g_tlf.tlf027=0
       LET g_tlf.tlf10=p_imn.imn22                 #調撥數量
       LET g_tlf.tlf11=p_imn.imn20                 #撥入單位
       LET g_tlf.tlf12=1                           #撥入/撥出庫存轉換率
       LET g_tlf.tlf930=p_imn.imn9302  #FUN-670093
    END IF

#--->異動數量
    LET g_tlf.tlf04=' '                         #工作站
    LET g_tlf.tlf05=' '                         #作業序號
    LET g_tlf.tlf06=g_imm.imm02                 #發料日期
    LET g_tlf.tlf07=g_today                     #異動資料產生日期
    LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                      #產生人
    LET g_tlf.tlf13='aimt324'                   #異動命令代號
    LET g_tlf.tlf14=p_imn.imn28                 #異動原因
    LET g_tlf.tlf15=g_debit                     #借方會計科目
    LET g_tlf.tlf16=g_credit                    #貸方會計科目
    LET g_tlf.tlf17=g_imm.imm09                 #remark
    CALL s_imaQOH(p_imn.imn03)
         RETURNING g_tlf.tlf18                  #異動後總庫存量
   #LET g_tlf.tlf19= ' '                        #異動廠商/客戶編號      #MOD-A80004 mark
    LET g_tlf.tlf19= g_imm.imm14                #異動廠商/客戶編號      #MOD-A80004 add
    LET g_tlf.tlf20= ' '                        #project no.
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
	