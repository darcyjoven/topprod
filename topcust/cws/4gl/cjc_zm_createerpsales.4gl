# Program name...: cjc_zm_createerpsales.4gl
# Descriptions...: 提供建立出货单服务
# Date & Author..: 2018/04/14 by jc

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此


FUNCTION cjc_zm_createerpsales()
 
  WHENEVER ERROR CONTINUE
 
  CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
  
  IF g_status.code = "0" THEN
    CALL cjc_zm_createerpsales_process()
  END IF
 
  CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
FUNCTION cjc_zm_createerpsales_process()
 DEFINE l_i        LIKE type_file.num10,
         l_j        LIKE type_file.num10,
         l_h        LIKE type_file.num10
  DEFINE l_sql      STRING        
  DEFINE l_cnt      LIKE type_file.num10,
         l_cnt1     LIKE type_file.num10,
         l_cnt2     LIKE type_file.num10,
         l_num      LIKE type_file.num15_3
  DEFINE l_oga      RECORD LIKE oga_file.*,
         l_oga_t    RECORD LIKE oga_file.*,
         l_ogb      RECORD LIKE ogb_file.*,
         l_ogb_t      RECORD LIKE ogb_file.*,
         l_gec      RECORD LIKE gec_file.*
  DEFINE l_node1    om.DomNode,
         l_node2    om.DomNode
  DEFINE l_flag     LIKE type_file.chr1,
         l_time     LIKE type_file.chr100,
         l_remark   LIKE type_file.chr1000
 
DEFINE g_flag       LIKE type_file.chr1 
DEFINE l_oaz    RECORD LIKE oaz_file.* 
DEFINE l_oeb    RECORD LIKE oeb_file.* ,
       l_occ    RECORD LIKE occ_file.*,
       l_ogb03   LIKE ogb_file.ogb03,
       l_oeb01  LIKE oeb_file.oeb01,
       l_oeb03  LIKE oeb_file.oeb03,
       l_oeb13  LIKE oeb_file.oeb13,
       l_tot_t    LIKE type_file.num15_3,
       l_tot    LIKE type_file.num15_3,
       l_num1   LIKE type_file.num15_3,
       l_msg    LIKE type_file.chr100 ,
       t_azi03  LIKE azi_file.azi03,
       t_azi04  LIKE azi_file.azi04,
       l_ogb31_t  LIKE ogb_file.ogb31,
       l_ogb32_t  LIKE ogb_file.ogb32,
       l_ogb12_sum  LIKE type_file.num15_3,
       l_type     LIKE type_file.chr5 ,
       l_oga01_t  LIKE oga_file.oga01,
       l_type_db  LIKE  type_file.chr5  

DEFINE l_ret RECORD
           success LIKE type_file.chr1,
           code    LIKE type_file.chr10,
           msg     STRING
            END RECORD
  {IF NOT cl_getscmparameter() THEN
           LET g_status.code = "-1"
           LET g_status.description = "该营运中心未设置和SCM对接，请检查设置！"
           RETURN
  END IF}

  LET l_cnt1 = aws_ttsrv_getMasterRecordLength("INVENTORY_DETAILS")
  IF l_cnt1 = 0 THEN
    LET g_status.code = "-1"
    LET g_status.description = "No recordset processed!"
    RETURN
  END IF

  SELECT * INTO l_oaz.* FROM oaz_file 


  
    
  BEGIN WORK

  FOR l_i = 1 TO l_cnt1       
    LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "INVENTORY_DETAILS")        #目前處理單檔的 XML 節點
    LET l_oga.ogaplant = aws_ttsrv_getRecordField(l_node1, "GROUP_ID_CODE")         #营运中心
    LET l_oga.ogaud01 = aws_ttsrv_getRecordField(l_node1, "CODE"),"-",aws_ttsrv_getRecordField(l_node1, "UPDATE_NUM") ,"-",aws_ttsrv_getRecordField(l_node1, "STATUS")   #来源SCM单号 
    LET l_time = aws_ttsrv_getRecordField(l_node1, "CREATED_ON")         #过账日期
    LET l_oga.oga02 = l_time[1,10]
    LET l_time = aws_ttsrv_getRecordField(l_node1, "SOURCE_CREATED_ON")         #录入日期
    LET l_oga.oga69 = l_time[1,10]
    LET l_oga.oga14 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_ID_CODE")         #人员
    LET l_type = aws_ttsrv_getRecordField(l_node1, "SOURCE_DOC_TYPE_ID_CODE")         #出货类型
    LET l_oga.oga15 = aws_ttsrv_getRecordField(l_node1, "APPLICANT_DEPARTMENT_ID_CODE")         #部门
    LET l_oga.oga03 = aws_ttsrv_getRecordField(l_node1, "CUSTOMER_ID_CODE")         #客户
    LET l_oga.ogauser = aws_ttsrv_getRecordField(l_node1, "CREATED_BY_CODE")         #出货人员
    LET l_oga.oga011    = aws_ttsrv_getRecordField(l_node1, "RE_SOURCE_ID_CODE")         #来源单号   通知单号
    LET l_type_db    = aws_ttsrv_getRecordField(l_node1, "CH_OUT_TYPE")         #来源单号   通知单号
    SELECT COUNT(*) INTO l_cnt FROM oga_file WHERE oga01 =  l_oga.oga011  AND oga09 = '1'   
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
    IF (cl_null(l_oga.oga011) OR l_cnt = 0) AND (l_type <>'DO3' OR cl_null(l_type))THEN
          LET g_status.code = "-1"
          LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
          LET g_status.description = "出货通知单号:",l_oga.oga011 CLIPPED,"，无对应的出货通知单，请检查！"
          EXIT FOR
    ELSE 
       IF NOT cl_null(l_oga.oga011) AND l_type <>'DO3'  THEN 
         SELECT * INTO l_oga_t.* FROM oga_file WHERE oga01= l_oga.oga011 
            LET l_oga.oga03 = l_oga_t.oga03 
            IF cl_null(l_oga.oga03) THEN 
                  LET g_status.code = "-1"
                  LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
                  LET g_status.description = "客户编号不能为空！"
                  EXIT FOR
            END IF 
               #初始化
            LET l_oga.oga00 = l_oga_t.oga00
            LET l_oga.oga08 = l_oga_t.oga08
            LET l_oga.oga04 = l_oga_t.oga04
            LET l_oga.oga18 = l_oga_t.oga18
            LET l_oga.oga05 = l_oga_t.oga05
            LET l_oga.oga06 = l_oga_t.oga06
            LET l_oga.oga07 = l_oga_t.oga07
            LET l_oga.oga08 = l_oga_t.oga08
            LET l_oga.oga09 = '2'
            LET l_oga.oga161 = l_oga_t.oga161
            LET l_oga.oga162 = l_oga_t.oga162
            LET l_oga.oga163 = 0
            LET l_oga.oga20 = 'Y'
            LET l_oga.oga14 = l_oga_t.oga14
            LET l_oga.oga15 = l_oga_t.oga15
       ELSE 
                  
               #初始化
            LET l_oga.oga00 = '1'
            LET l_oga.oga08 = '1'
            LET l_oga.oga04 = l_oga.oga03
            LET l_oga.oga18 = l_oga.oga03
            LET l_oga.oga05 = '1'
            LET l_oga.oga06 = '0'
            LET l_oga.oga07 = 'N'
            LET l_oga.oga08 = '1'
            LET l_oga.oga09 = '3'   #出货单类型
            LET l_oga.oga161 = 0
            LET l_oga.oga162 = 100
            LET l_oga.oga163 = 0
            LET l_oga.oga20 = 'Y'
       END IF 
    END IF 
    #add by shawn 191004 --begin 
    LET l_sql = " select oga01 from oga_file where ogaud01 like '",l_oga.ogaud01 CLIPPED ,"' and rownum=1"
    PREPARE pre_oga_t FROM l_sql
    EXECUTE pre_oga_t INTO l_oga01_t
    IF NOT cl_null(l_oga01_t) THEN
      LET g_status.code = 0
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = l_oga01_t
      RETURN 
    END IF
    #--end 
    


    SELECT count(*) INTO l_cnt FROM occ_file WHERE occ01= l_oga.oga03
    IF cl_null(l_cnt) THEN LET l_cnt  = 0 END IF 
    IF l_cnt =0 THEN 
          LET g_status.code = "-1"
          LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
          LET g_status.description = "客户不存在！"
          EXIT FOR
    END IF  
    SELECT * INTO l_occ.* FROM occ_file WHERE occ01= l_oga.oga03 
    LET l_oga.oga13 = l_occ.occ67 
    #SELECT gen03 INTO l_oga.oga15 FROM gen_file WHERE gen01= l_occ.occ04 
    #LET l_oga.oga14 = l_occ.occ04  
    LET l_oga.oga21 = l_occ.occ41
    LET l_oga.oga032 = l_occ.occ02 
    SELECT * INTO l_gec.* FROM gec_file WHERE gec01=l_occ.occ41
    IF STATUS  THEN 
          LET g_status.code = "-1"
          LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
          LET g_status.description = "税别不存在！"
          EXIT FOR
    END IF  
    LET l_oga.oga211 = l_gec.gec04  
    LET l_oga.oga212 = 'B'
    LET l_oga.oga213 = l_gec.gec07 
    #modify by shawn 200419--- begin ---  
    IF NOT cl_null(l_oga.oga011) THEN 
        SELECT oga23,oga24 INTO l_oga.oga23,l_oga.oga24 FROM oga_file WHERE oga01= l_oga.oga011 AND oga09 = '1'
    END IF 
    IF cl_null(l_oga.oga23) THEN 
        LET l_oga.oga23 = l_occ.occ42 
    END IF 
    
  #  CALL s_rate(l_oga.oga23,l_oga.oga24) RETURNING l_oga.oga24
    IF cl_null(l_oga.oga24) THEN 
      LET l_oga.oga24 =1 
    END IF 
    #---end ---- 
    LET l_oga.oga25 = l_occ.occ43 
    
    LET l_oga.oga30 = 'N'
    LET l_oga.oga31  = l_occ.occ44
    LET l_oga.oga32  = l_occ.occ45 
    LET l_oga.oga50  =   0 #金额
    LET l_oga.oga52  =   0 #金额
    LET l_oga.oga53  =   0 #金额
    LET l_oga.oga54  =   0 #金额
    LET l_oga.oga903  =  'N'
    LET l_oga.oga909  =  'N'
    LET l_oga.ogaconf = 'N'
    LET l_oga.ogapost = 'N'
    LET l_oga.ogaprsw = '0'
    LET l_oga.ogamksg = 'N'
    LET l_oga.ogauser = g_user
    LET l_oga.ogagrup = g_grup
    
    
   # LET l_oga.oga21 = NULL
    LET l_oga.oga29 = '1'
    LET l_oga.oga32 = '0'
    LET l_oga.ogamksg = 'N'
    LET l_oga.ogadate = TODAY
    LET l_oga.oga55 = '0'
    LET l_oga.oga65 = 'N'
    #LET l_oga.ogaprno = 0
    LET l_oga.oga1005 = 'Y'
    LET l_oga.ogaspc = '0'
    LET l_oga.oga94 = 'N'
    LET l_oga.ogaoriu = g_user
    LET l_oga.ogaorig = g_grup
    LET l_oga.ogacond = TODAY 
    LET l_oga.ogaconu = g_user 
    LET l_oga.ogalegal = l_oga.ogaplant
    #LET l_oga.ogaacti='Y'
    LET l_oga.ogaprsw = 'Y' 
    LET l_oga.oga85 = ' '
    LET l_oga.oga57 = '1'

     SELECT azi03,azi04 INTO t_azi03,t_azi04
      FROM azi_file
     WHERE azi01=l_oga.oga23

    #----------------------------------------------------------------------#
    # 自動取號                                                       #
    #----------------------------------------------------------------------#  
    --IF l_oga.oga10 <> 'SUB' THEN 
    LET l_oga.oga01 = ''
    IF l_type_db = 'Y' THEN 
         LET l_oga.oga01 = 'XRD'
    END IF 
    IF l_type_db = 'C' THEN
         LET l_oga.oga01 = 'XRY' 
    END IF 
    #SELECT smyslip INTO l_oga.oga01    #抓取单别
    #FROM smy_file
    #WHERE smysys = 'aim' AND smykind = '8'  -- AND smy72 = l_oga.oga10 
    #  AND smyacti = 'Y' AND smyauno = 'Y' AND rownum <= 1 AND smykind LIKE 'XRD'
    IF cl_null(l_oga.oga01) THEN 
    	LET g_status.code = "-1"
    	LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
    	LET g_status.description = "无有效出货单别！"
    	EXIT FOR
    END IF 
        CALL s_auto_assign_no("axm",l_oga.oga01,l_oga.oga69,"","INVENTORY_DETAILS","oga01","","","")
             RETURNING l_flag, l_oga.oga01
        IF NOT l_flag THEN
            LET g_status.code = "-1"
            LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
            LET g_status.description = "出货单取号失败！"
          EXIT FOR
        END IF
    #181114 --- 
    LET l_oga.oga021 = ''
    LET l_oga.oga72 = ''
    #----------------------------------------------------------------------#
    # 執行單頭 INSERT SQL                                                  #
    #----------------------------------------------------------------------#
    INSERT INTO oga_file VALUES (l_oga.*)
    IF SQLCA.SQLCODE THEN
      LET g_status.code = "-1"
      LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
      LET g_status.description = "insert oga_file失败！"
      EXIT FOR
    END IF


     #----------------------------------------------------------------------#
    # 處理單身資料                                                         #
    #----------------------------------------------------------------------#
    LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "INVENTORY_DETAILS")       #取得目前單頭共有幾筆單身資料
    IF l_cnt2 = 0 THEN
      LET g_status.code = "-1"   #必須有單身資料
      LET g_status.description = "ogb_file无资料!"
      EXIT FOR
    END IF
    
    FOR l_j = 1 TO l_cnt2
          LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "INVENTORY_DETAILS")   #目前單身的 XML 節點
          LET l_ogb.ogb01 = l_oga.oga01
          LET l_num = 0 
          LET l_ogb03 = aws_ttsrv_getRecordField(l_node2, "SEQ_NUM")         #取得此筆單檔資料的欄位值
          LET l_ogb.ogb04 = aws_ttsrv_getRecordField(l_node2,"PRODUCT_ID_CODE")   
          SELECT ima02  INTO l_ogb.ogb06 FROM ima_file WHERE ima01 = l_ogb.ogb04 
          #LET l_ogb.ogb06  = aws_ttsrv_getRecordField(l_node2,"materialName") 
          LET l_ogb.ogb05  = aws_ttsrv_getRecordField(l_node2,"UNIT_ID_CODE") 
          LET l_ogb.ogb12  = aws_ttsrv_getRecordField(l_node2,"QUANTITY") 
          LET l_ogb.ogb912  = aws_ttsrv_getRecordField(l_node2,"QUANTITY") 
          LET l_ogb.ogb09  = aws_ttsrv_getRecordField(l_node2,"WAREHOUSE_ID_CODE") 
          IF cl_null(l_ogb.ogb09) THEN 
                LET g_status.code = "-1"
                LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
                LET g_status.description = "仓库不能为空，请检查！"
                EXIT FOR
          END IF 
          SELECT count(*) INTO l_cnt FROM imd_file WHERE imd01= l_ogb.ogb09 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
          IF  l_cnt  = 0 THEN
                LET g_status.code = "-1"
                LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
                LET g_status.description = "仓库在ERP中不存在，请检查！"
                EXIT FOR
          END IF  
          LET l_ogb.ogb091  = aws_ttsrv_getRecordField(l_node2,"LOCATION_ID_CODE") 
          IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091 = ' ' END IF 
          LET l_ogb.ogb092  = aws_ttsrv_getRecordField(l_node2,"LOT_NUM") 
          LET l_ogb.ogb41  = aws_ttsrv_getRecordField(l_node2,"REMARKS") 
          LET l_ogb31_t    = l_oga.oga011                                            #通知单号  #aws_ttsrv_getRecordField(l_node2,"RE_SOURCE_ID_CODE")   #来源销售订单号  
          LET l_ogb32_t    = aws_ttsrv_getRecordField(l_node2,"RE_SOURCE_SEQ_NUM")   #来源通知单项次


     #批号管理 ima159 = 1 带批号，否则不带批号  --begin ---- 
      {SELECT count(*) INTO l_cnt FROM ima_file WHERE ima159 = '1'  AND ima01=l_ogb.ogb04
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN 
          LET l_ogb.ogb092 = ' '
      END IF }
      #--end---   
          IF (cl_null(l_ogb31_t) OR cl_null(l_ogb32_t)) AND l_type <>'DO3' THEN 
                LET g_status.code = "-1"
                LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
                LET g_status.description = "来源出货通知单单号",l_ogb31_t CLIPPED ,"或者项次",l_ogb32_t CLIPPED ,"为空，请检查！"
                EXIT FOR
          END IF 
          SELECT ogb_file.* INTO l_ogb_t.* FROM ogb_file,oga_file  
          WHERE  oga01 = ogb01 AND ogb01 = l_ogb31_t AND ogb03 = l_ogb32_t AND oga09 = '1' 
          IF cl_null(l_ogb_t.ogb01) AND l_type <>'DO3'  THEN 
                LET g_status.code = "-1"
                LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
                LET g_status.description =  "来源出货通知单单号",l_ogb31_t CLIPPED ,"或者项次",l_ogb32_t CLIPPED ,"不存在，请检查！"
                EXIT FOR
          END IF 
          LET l_oeb01 = l_ogb_t.ogb31 
          LET l_oeb03 = l_ogb_t.ogb32 
          #写入单身
           SELECT * INTO l_oeb.* FROM oeb_file WHERE oeb01=l_oeb01 AND oeb03 = l_oeb03 
            LET l_ogb.ogb13     =l_oeb.oeb13

            IF l_oga.oga213 = 'N' THEN
                LET l_ogb.ogb14 = l_ogb.ogb12 * l_ogb.ogb13
                CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
                LET l_ogb.ogb14t= l_ogb.ogb14 * (1+ l_oga.oga211/100)
                CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
             ELSE
                LET l_ogb.ogb14t = l_ogb.ogb12 * l_ogb.ogb13
                CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
                LET l_ogb.ogb14= l_ogb.ogb14t * (1+ l_oga.oga211/100)
                CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
             END IF
           LET l_ogb.ogb15     = l_oeb.oeb05 
           LET l_ogb.ogb15_fac     = l_oeb.oeb05_fac 
           LET l_ogb.ogb05_fac     = l_oeb.oeb05_fac
           IF cl_null(l_ogb.ogb05_fac) THEN LET l_ogb.ogb05_fac = 1 END IF 
           IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac = 1 END IF 
           IF cl_null(l_ogb.ogb13) THEN LET l_ogb.ogb13 = 0 END IF 
           IF cl_null(l_ogb.ogb14) THEN LET l_ogb.ogb14 = 0 END IF 
           IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t = 0 END IF 
           
            LET l_ogb.ogb16     = l_ogb.ogb12
            LET l_ogb.ogb17     = 'N'
            LET l_ogb.ogb18     = l_ogb.ogb12
            LET l_ogb.ogb19     = 'N'
            LET l_ogb.ogb31     = l_oeb01
            LET l_ogb.ogb32     = l_oeb03
            LET l_ogb.ogb50 = 0
            LET l_ogb.ogb51 = 0
            LET l_ogb.ogb52 = 0
            LET l_ogb.ogb53 = 0
            LET l_ogb.ogb54 = 0
            LET l_ogb.ogb55 = 0
            LET l_ogb.ogb60 = 0 
            LET l_ogb.ogb63 = 0 
            LET l_ogb.ogb64 = 0 
            LET l_ogb.ogb910 = l_oeb.oeb05
            LET l_ogb.ogb911  =1 
            LET l_ogb.ogb916 = l_ogb.ogb05
            LET l_ogb.ogb917  =l_ogb.ogb12 
            #LET l_ogb.ogb1001='1001'
            LET l_ogb.ogb1005 = '1'
            LET l_ogb.ogb1003 = g_today 
            LET l_ogb.ogb1006 = 100
            LET l_ogb.ogb1012 = 'N'
            LET l_ogb.ogb1014 = 'N'
            LET l_ogb.ogb44 = '1'
            LET l_ogb.ogb47 = 0
            LET l_ogb.ogb37 = 0 
            LET l_ogb.ogbplant = l_oga.ogaplant
            LET l_ogb.ogblegal = l_oga.ogaplant
            LET l_ogb.ogb37 = l_ogb.ogb14t
            SELECT oea10 INTO l_ogb.ogbud02 FROM oea_file WHERE oea01 = l_ogb.ogb31
            #LET l_ogb.ogbud02 = l_ogb03
            LET l_ogb.ogb03 = l_j
            SELECT oeb1001 INTO l_ogb.ogb1001 FROM oeb_file WHERE oeb01=l_oeb.oeb01 AND oeb03 = l_oeb.oeb03 
            INSERT INTO ogb_file values(l_ogb.*)
       IF SQLCA.SQLCODE THEN
        LET g_status.code = "-1"
        LET g_status.sqlcode = SQLCA.SQLCODE USING '-----'
        LET g_status.description = "insert ogb_file失败！"
        EXIT FOR
      END IF
    END FOR
  END FOR
  
  #全部處理都成功才 COMMIT WORK
  IF g_status.code = "0" THEN
    LET g_status.description = l_oga.oga01
    COMMIT WORK
    CALL p300_oga(l_oga.oga01)
  ELSE
    ROLLBACK WORK
  END IF
    
  
END FUNCTION
