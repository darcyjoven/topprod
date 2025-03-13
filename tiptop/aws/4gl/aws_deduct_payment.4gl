# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: aws_deduct_payment.4gl
# Descriptions...: 提供POS付款扣减的服務
# Date & Author..: 12/07/05 by suncx
# Modify.........: No.FUN-C50138 12/07/05 by suncx 新增程序
# Modify.........: No.TQC-C80097 12/08/15 by suncx 程序調整
# Modify.........: No.TQC-C80170 12/08/28 By suncx webservice服務DeductSPayment只有積分抵現時，會報-201錯誤
# Modify.........: No.TQC-C90019 12/09/05 By suncx 修正纍計消費次數及纍計消費金額計算錯誤的問題
# Modify.........: No:FUN-CA0090 12/10/23 by shiwuying 增加更新发卡退卡状态/更新换卡状态/更新充值储值/更新劵 的逻辑
# Modify.........: No:FUN-CB0028 12/10/23 by shiwuying 逻辑调整
# Modify.........: No:FUN-CB0118 12/11/26 by shiwuying Bug修正
# Modify.........: No:FUN-CB0104 12/11/29 By xumm 添加订单部分逻辑
# Modify.........: No:FUN-CC0057 12/12/25 By xumm 修改订单部分BUG
# Modify.........: No:FUN-CC0135 12/12/27 By xumm 添加会员是否升等否栏位
# Modify.........: No:FUN-D10039 13/01/09 By xumm 邏輯調整
# Modify.........: No.FUN-D10040 13/01/18 By xumm 更新券状态4为已用
# Modify.........: No.FUN-D10095 13/01/28 By xumm XML格式调整
# Modify.........: No.FUN-D30017 13/03/12 By xumm BUG修改

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_shop    LIKE azw_file.azw01, #门店编号
       g_sale_no LIKE lsm_file.lsm03, #POS銷售單號
      #g_type    LIKE lsm_file.lsm02, #销售状态 #FUN-CB0028
       g_type    LIKE type_file.chr10,#销售状态 #FUN-CB0028
       g_dbate   STRING,              #营业日期
       g_guid    LIKE rxu_file.rxu01
DEFINE g_flag    LIKE type_file.chr1
DEFINE l_date    LIKE type_file.dat,
       l_num     LIKE type_file.num10,
       l_legal   LIKE azw_file.azw02   #TQC-C80097
DEFINE g_lsm15   LIKE lsm_file.lsm15,  #來源類型
       g_lsn10   LIKE lsn_file.lsn10   #來源類型
DEFINE g_trans_day LIKE type_file.dat
DEFINE g_guid_ex   BOOLEAN   #guid是否已經存在
DEFINE g_rxu       RECORD LIKE rxu_file.*
DEFINE g_lpj DYNAMIC ARRAY OF RECORD
             lpj03 LIKE lpj_file.lpj03,
             lpj07 LIKE lpj_file.lpj07,
             lpj08 LIKE lpj_file.lpj08,
             lpj15 LIKE lpj_file.lpj15
             END RECORD
#FUN-CA0090 Begin---
DEFINE g_sql       STRING
DEFINE g_lpj07     LIKE lpj_file.lpj07
DEFINE g_lpj08     LIKE lpj_file.lpj08
DEFINE g_lpj13     LIKE lpj_file.lpj13
DEFINE g_lpj14     LIKE lpj_file.lpj14
DEFINE g_lpj15     LIKE lpj_file.lpj15
#FUN-CA0090 End-----

#[
# Description....: 提供POS付款扣减的服務(入口 function)
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_payment()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # POS付款扣减                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_deduct_payment_process()
    END IF
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION

#[
# Description....: 依據傳入資訊進行付款扣减操作
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_payment_process()
DEFINE l_i        LIKE type_file.num10,
       l_j        LIKE type_file.num10
DEFINE l_cnt      LIKE type_file.num10,
       l_cnt1     LIKE type_file.num10,
       l_cnt2     LIKE type_file.num10,
       l_cnt3     LIKE type_file.num10,
       l_cnt4     LIKE type_file.num10,
       l_cnt5     LIKE type_file.num10
      #FUN-CA0090 Begin---
      ,l_cnt6     LIKE type_file.num10, #发卡退卡资料笔数
       l_cnt7     LIKE type_file.num10, #换卡资料笔数
       l_cnt8     LIKE type_file.num10, #充值储值资料笔数
       l_cnt9     LIKE type_file.num10  #劵 资料笔数
      #FUN-CA0090 End-----
      ,l_cnt10    LIKE type_file.num10  #订单资料笔数   #FUN-CB0104 add
DEFINE l_node1    om.DomNode,
       l_node2    om.DomNode,
       l_node     om.DomNode
DEFINE l_card_no   LIKE lsn_file.lsn01,    #卡號
       l_amount    LIKE lsn_file.lsn04,    #扣款金额
       l_coupon_no LIKE lqe_file.lqe01,    #券號
       l_point     LIKE lpj_file.lpj12     #积分
DEFINE l_lpj06     LIKE lpj_file.lpj06,
       l_lqe17     LIKE lqe_file.lqe17,
       l_lpj12     LIKE lpj_file.lpj12,
       l_lph38     LIKE lph_file.lph38,
       l_lph39     LIKE lph_file.lph39
DEFINE l_sql       STRING
DEFINE l_len,l_x   LIKE type_file.num10
DEFINE l_guid2     LIKE rxu_file.rxu02
DEFINE l_master RECORD                    #回傳值必須宣告為一個 RECORD 變數
                GUID         STRING               #传输GUID
                END RECORD
DEFINE l_detail_card  DYNAMIC ARRAY OF RECORD
                      success      STRING,              #扣款成功否
                      Balance      LIKE lsn_file.lsn04, #储值卡余额
                      DeductAmount LIKE lsn_file.lsn04, #扣款金额
                      CardNO       LIKE lsn_file.lsn01, #储值卡卡号
                      GUID         STRING               #传输GUID
                  END RECORD,
       l_detail_coup  DYNAMIC ARRAY OF RECORD
                      success STRING,    #操作成功否
                      GUID    STRING     #传输GUID
                  END RECORD,
       l_detail_score DYNAMIC ARRAY OF RECORD
                      success STRING,              #操作成功否Y/N
                      Dcash   LIKE lpj_file.lpj06, #扣减金额
                      Dscore  LIKE lpj_file.lpj12, #扣减积分
                      GUID    STRING               #传输GUID
                  END RECORD,
       l_detail_point DYNAMIC ARRAY OF RECORD
                      success   STRING,              #积分成功否
                      POINT_QTY LIKE lpj_file.lpj12, #积分总额
                      GUID      STRING               #传输GUID
                  END RECORD
#FUN-CA0090 Begin---
DEFINE l_detail_updatecard DYNAMIC ARRAY OF RECORD
                      success   STRING,              #成功否
                      tf_Member_MemberNO LIKE lpk_file.lpk01,#会员编号
                      GUID      STRING               #传输GUID
                      END RECORD
DEFINE l_detail_updatechangecard DYNAMIC ARRAY OF RECORD
                      success   STRING,              #成功否
                      GUID      STRING               #传输GUID
                      END RECORD
DEFINE l_detail_updaterechargecard DYNAMIC ARRAY OF RECORD
                      success   STRING,              #成功否
                      GUID      STRING               #传输GUID
                      END RECORD
DEFINE l_detail_updatecoupon DYNAMIC ARRAY OF RECORD
                      success   STRING,              #成功否
                      GUID      STRING               #传输GUID
                      END RECORD
DEFINE l_updatecard   RECORD
                      begincard LIKE lpj_file.lpj03,             #开始卡号
                      endcard   LIKE lpj_file.lpj03,             #结束卡号
                      cardamt   LIKE lpj_file.lpj06,             #发卡工本费，退卡不给值
                      ctno      LIKE lpj_file.lpj02,             #卡种
                      password  LIKE lpj_file.lpj26,             #密码
                      tf_member_memberno    LIKE lpj_file.lpj01, #会员编号
                      tf_member_merbername  LIKE lpk_file.lpk04, #会员姓名
                      tf_member_menbergrade LIKE lpk_file.lpk11, #会员等级
                      tf_member_menbertype  LIKE lpk_file.lpk13, #会员类型
                      tf_member_mobile      LIKE lpk_file.lpk18, #手机
                      optype                LIKE type_file.chr1, #操作类型,0发卡1退卡
                      rechargeamt           LIKE lpj_file.lpj06, #发卡,客户给的金额;退卡，退给客户的
                      realamt               LIKE lpj_file.lpj06  #发卡,实际充值金额;退卡，卡余额
                      END RECORD
DEFINE l_lpk01        LIKE lpk_file.lpk01
DEFINE l_updatechangecard RECORD
                      oldcard        LIKE lpj_file.lpj03,   #原卡号
                      newcard        LIKE lpj_file.lpj03,   #新卡号
                      password       LIKE lpj_file.lpj03    #新卡密码
                      END RECORD
DEFINE l_updaterechargecard RECORD
                      cardno         LIKE lpj_file.lpj03,   #卡号
                      rechargeamt    LIKE lpj_file.lpj06,   #充值金额
                      realamt        LIKE lpj_file.lpj06    #实际充值金额
                      END RECORD
DEFINE l_updatecoupon RECORD
                      begincoupon    LIKE lqe_file.lqe01,   #开始劵号
                      endcoupon      LIKE lqe_file.lqe01,   #结束券号
                      couponamt      LIKE lrz_file.lrz02,   #金额,实际发劵金额或退劵金额
                      optype         LIKE type_file.chr1    #操作类型,0:发劵1:退劵
                      END RECORD
#FUN-CA0090 End-----
#FUN-CB0104-----add----str
DEFINE l_detail_updateorder DYNAMIC ARRAY OF RECORD
                      success   STRING,              #成功否
                      GUID      STRING               #传输GUID
                      END RECORD
DEFINE l_updateorder  RECORD
                      billtype       LIKE type_file.chr1,   #订单类型 0:总部配送1:异店取货
                      optype         LIKE type_file.chr1,   #操作类型 0:订转销1:订单退订
                      shop           LIKE azw_file.azw01,   #下订单门店编号
                      Saleno         LIKE oea_file.oea01,   #订单编号
                      GUID           STRING                 #传输GUID
                      END RECORD
DEFINE l_shop1        LIKE azw_file.azw01
DEFINE l_ECSFLG       LIKE type_file.chr1
DEFINE l_posdbs       LIKE ryg_file.ryg00
DEFINE l_db_links     LIKE ryg_file.ryg02
#FUN-CB0104-----add----end

    #調用基本的檢查
    CALL aws_pos_check() RETURNING g_success
    IF cl_null(g_success) THEN LET g_success ='N' END IF
    IF g_success = 'N' THEN RETURN END IF

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的資料                                             #
    #--------------------------------------------------------------------------#
    #LET l_cnt1 = aws_ttsrv_getMasterRecordLength("PAY")  #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***   #FUN-D10095 Mark
    LET l_cnt1 = aws_ttsrv_getTreeMasterRecordLength("Pay") #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ *** #FUN-D10095 Add
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    LET l_date = NULL
    LET l_num = 0
    BEGIN WORK
    CALL aws_pos_get_ConnectionMsg("guid") RETURNING g_guid
    LET g_guid_ex  = FALSE
    IF NOT cl_null(g_guid) THEN
       #CALL aws_ttsrv_addParameterGuid(g_guid)
       LET l_master.GUID = g_guid
       CALL aws_pos_guid_isExistence(g_guid) RETURNING g_guid_ex
    ELSE
       ROLLBACK WORK
       RETURN
    END IF
    LET g_lsm15 = '2'
    LET g_lsn10 = '2'
    FOR l_i = 1 TO l_cnt1
       #LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "PAY")  #目前處理Master的 XML 節點    #FUN-D10095 Mark
       LET l_node1 = aws_ttsrv_getTreeMasterRecord(l_i,"Pay") #目前處理Master的 XML 節點   #FUN-D10095 Add
       LET g_shop = aws_ttsrv_getRecordField(l_node1, "Shop")
       LET g_sale_no = aws_ttsrv_getRecordField(l_node1, "SaleNO")
       LET g_type = aws_ttsrv_getRecordField(l_node1, "Type")
       LET g_dbate = aws_ttsrv_getRecordField(l_node1, "BDate")
       LET g_trans_day = DATE (g_dbate)
       #LET l_master.GUID = aws_ttsrv_getRecordField(l_node1, "GUID")
       #----------------------------------------------------------------------#
       # 處理付款明細資料                                                        #
       #----------------------------------------------------------------------#
      #FUN-D10095 Mark&Add Begin ---
      #LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "Card")       #取得目前單頭共有幾筆儲值卡扣款資料
      #LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "Coupon")     #取得目前單頭共有幾筆券核銷資料
      #LET l_cnt4 = aws_ttsrv_getDetailRecordLength(l_node1, "Score")      #取得目前單頭共有幾筆積分抵現資料
      #LET l_cnt5 = aws_ttsrv_getDetailRecordLength(l_node1, "WritePoint") #取得目前單頭共有幾筆寫積分資料
      #FUN-CA0090 Begin---
      #LET l_cnt6 = aws_ttsrv_getDetailRecordLength(l_node1, "UpdateCard")          #取得目前單頭共有幾筆发卡退卡资料
      #LET l_cnt7 = aws_ttsrv_getDetailRecordLength(l_node1, "UpdateChangeCard")    #取得目前單頭共有幾筆换卡资料
      #LET l_cnt8 = aws_ttsrv_getDetailRecordLength(l_node1, "UpdateRechargeCard")  #取得目前單頭共有幾筆充值储值资料
      #LET l_cnt9 = aws_ttsrv_getDetailRecordLength(l_node1, "UpdateCoupon")        #取得目前單頭共有幾筆劵 资料
      #LET l_cnt10 = aws_ttsrv_getDetailRecordLength(l_node1, "UpdateOrderBill")    #取得目前單頭共有幾筆订单资料  #FUN-CB0104 add
       LET l_cnt2 = aws_ttsrv_getTreeRecordLength(l_node1,"Card")                   #取得目前單頭共有幾筆儲值卡扣款資料
       LET l_cnt3 = aws_ttsrv_getTreeRecordLength(l_node1,"Coupon")                 #取得目前單頭共有幾筆券核銷資料
       LET l_cnt4 = aws_ttsrv_getTreeRecordLength(l_node1,"Score")                  #取得目前單頭共有幾筆積分抵現資料
       LET l_cnt5 = aws_ttsrv_getTreeRecordLength(l_node1,"WritePoint")             #取得目前單頭共有幾筆寫積分資料
       LET l_cnt6 = aws_ttsrv_getTreeRecordLength(l_node1,"UpdateCard")             #取得目前單頭共有幾筆寫積分資料
       LET l_cnt7 = aws_ttsrv_getTreeRecordLength(l_node1,"UpdateChangeCard")       #取得目前單頭共有幾筆换卡资料
       LET l_cnt8 = aws_ttsrv_getTreeRecordLength(l_node1,"UpdateRechargeCard")     #取得目前單頭共有幾筆充值储值资料
       LET l_cnt9 = aws_ttsrv_getTreeRecordLength(l_node1,"UpdateCoupon")           #取得目前單頭共有幾筆劵 资料
       LET l_cnt10 = aws_ttsrv_getTreeRecordLength(l_node1,"UpdateOrderBill")       #取得目前單頭共有幾筆订单资料
      #FUN-D10095 Mark&Add End -----
      #IF l_cnt2 = 0 AND l_cnt3 = 0 AND l_cnt4 = 0 AND l_cnt5 = 0 THEN
       IF l_cnt2 = 0 AND l_cnt3 = 0 AND l_cnt4 = 0 AND l_cnt5 = 0 AND
       #   l_cnt6 = 0 AND l_cnt7 = 0 AND l_cnt8 = 0 AND l_cnt9 = 0 THEN                 #FUN-CC0057 mark
          l_cnt6 = 0 AND l_cnt7 = 0 AND l_cnt8 = 0 AND l_cnt9 = 0 AND l_cnt10 = 0 THEN  #FUN-CC0057 add
      #FUN-CA0090 End-----
          LET g_status.code = "-1"
          LET g_status.description = "No recordset processed!"
          ROLLBACK WORK
          RETURN
       END IF

       #鎖住需要更新的資料
      #CALL aws_deduct_payment_lock(l_node1,l_cnt2,l_cnt4,l_cnt3,l_cnt5)                      #FUN-CA0090
      #CALL aws_deduct_payment_lock(l_node1,l_cnt2,l_cnt4,l_cnt3,l_cnt5,l_cnt6,l_cnt7,l_cnt8,l_cnt9) #FUN-CA0090    #FUN-CB0104 mark
       CALL aws_deduct_payment_lock(l_node1,l_cnt2,l_cnt4,l_cnt3,l_cnt5,l_cnt6,l_cnt7,l_cnt8,l_cnt9,l_cnt10)        #FUN-CB0104 add
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
       #檢查並更新資料
       #1：儲值卡扣款資料檢查與更新
       FOR l_j=1 TO l_cnt2
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "Card")            #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "Card")               #FUN-D10095 Add
          LET l_detail_card[l_j].CardNO = aws_ttsrv_getRecordField(l_node2, "CardNO")
          LET l_detail_card[l_j].DeductAmount = aws_ttsrv_getRecordField(l_node2, "DeductAmount")
          LET l_detail_card[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_card[l_j].GUID
          #檢查儲值卡資料
          IF NOT g_guid_ex THEN
             CALL aws_deduct_payment_check_card(l_detail_card[l_j].CardNO,l_detail_card[l_j].DeductAmount)
             RETURNING l_lpj06
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex THEN
                LET l_detail_card[l_j].success = 'Y'
                SELECT rxu09,rxu10 INTO l_detail_card[l_j].Balance,l_detail_card[l_j].DeductAmount
                  FROM rxu_file
                 WHERE rxu01 = g_guid AND rxu02 = l_guid2
                IF SQLCA.sqlcode THEN
                    LET g_success = 'N'
                    LET g_status.sqlcode = sqlca.sqlcode
                    CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                    ROLLBACK WORK
                    RETURN
                END IF
                IF l_detail_card[l_j].DeductAmount < 0 THEN
                   LET l_detail_card[l_j].DeductAmount = -1*l_detail_card[l_j].DeductAmount
                END IF
             ELSE
                #更新儲值卡資料
                CALL aws_deduct_payment_upd_card(l_detail_card[l_j].CardNO,l_detail_card[l_j].DeductAmount,
                                                 l_detail_card[l_j].GUID,l_lpj06)
                RETURNING l_detail_card[l_j].Balance
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_card[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_card.deleteElement(l_j)

       #2：券核銷資料檢查與更新
       FOR l_j=1 TO l_cnt3
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "Coupon")    #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "Coupon")       #FUN-D10095 Add
          LET l_coupon_no = aws_ttsrv_getRecordField(l_node2, "CouponNO")
          LET l_detail_coup[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          IF NOT g_guid_ex THEN
             CALL aws_deduct_payment_chk_coup(l_coupon_no) RETURNING l_lqe17
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_coup[l_j].success='Y'
             ELSE
                CALL aws_deduct_payment_upd_coup(l_coupon_no,l_detail_coup[l_j].GUID,l_lqe17 )
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_coup[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_coup.deleteElement(l_j)

       #3：積分抵現資料檢查與更新
       FOR l_j=1 TO l_cnt4 
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "Score")     #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "Score")        #FUN-D10095 Add
          LET l_card_no = aws_ttsrv_getRecordField(l_node2, "CardNO")
          LET l_detail_score[l_j].Dcash = aws_ttsrv_getRecordField(l_node2, "Dcash")
          LET l_detail_score[l_j].Dscore = aws_ttsrv_getRecordField(l_node2, "Dscore")
          LET l_detail_score[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_score[l_j].GUID
          IF NOT g_guid_ex THEN
             CALL aws_deduct_payment_chk_mcard(l_card_no,'1',l_point) RETURNING  l_lpj12,l_lph38,l_lph39
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_score[l_j].success = 'Y'
                SELECT rxu10 INTO l_detail_score[l_j].Dscore FROM rxu_file
                 WHERE rxu01 = g_guid AND rxu02 = l_guid2
                IF sqlca.sqlcode THEN
                   LET g_status.sqlcode = sqlca.sqlcode
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
                END IF
                IF l_detail_score[l_j].Dscore < 0 THEN
                   LET l_detail_score[l_j].Dscore = -1 * l_detail_score[l_j].Dscore
                END IF
             ELSE
                CALL aws_deduct_payment_upd_score(l_card_no,l_detail_score[l_j].Dcash,l_detail_score[l_j].Dscore,
                                                  l_detail_score[l_j].GUID,l_lpj12,l_lph38,l_lph39)
                RETURNING l_detail_score[l_j].Dscore
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_score[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_score.deleteElement(l_j)

       #4：寫積分資料檢查與更新
       FOR l_j=1 TO l_cnt5
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "WritePoint")    #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "WritePoint")       #FUN-D10095 Add
          LET l_card_no = aws_ttsrv_getRecordField(l_node2, "CardNO")
          LET l_point = aws_ttsrv_getRecordField(l_node2, "POINT_QTY")
          LET l_amount = aws_ttsrv_getRecordField(l_node2, "TOT_AMT")
          LET l_detail_point[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_point[l_j].GUID
          IF NOT g_guid_ex THEN
             CALL aws_deduct_payment_chk_mcard(l_card_no,'2',l_point) RETURNING  l_lpj12,l_lph38,l_lph39
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_point[l_j].success = 'Y'
                SELECT rxu09 INTO l_detail_point[l_j].POINT_QTY FROM rxu_file
                 WHERE rxu01 = g_guid AND rxu02 = l_guid2
                IF sqlca.sqlcode THEN
                   LET g_status.sqlcode = sqlca.sqlcode
                   CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
                END IF
             ELSE
                CALL aws_deduct_payment_upd_point(l_card_no,l_detail_point[l_j].GUID,
                                                  l_amount,l_point,l_lpj12)
                RETURNING l_detail_point[l_j].POINT_QTY
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_point[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_point.deleteElement(l_j)

      #FUN-CA0090 Begin--- 
       #5：更新发卡退卡状态
       FOR l_j=1 TO l_cnt6
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "UpdateCard")             #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "UpdateCard")                #FUN-D10095 Add
          LET l_updatecard.begincard = aws_ttsrv_getRecordField(l_node2, "BeginCard")      #开始卡号
          LET l_updatecard.endcard = aws_ttsrv_getRecordField(l_node2, "EndCard")          #结束卡号
          LET l_updatecard.cardamt = aws_ttsrv_getRecordField(l_node2, "CardAMT")          #金额,实际发卡金额或退卡金额
          LET l_updatecard.ctno = aws_ttsrv_getRecordField(l_node2, "CTNO")                #卡种
          LET l_updatecard.PassWord = aws_ttsrv_getRecordField(l_node2, "PassWord")        #密码
          LET l_updatecard.tf_member_memberno = aws_ttsrv_getRecordField(l_node2, "tf_Member_MemberNO")       #会员编号
          LET l_updatecard.tf_member_merbername = aws_ttsrv_getRecordField(l_node2, "tf_Member_MerberName")   #会员姓名
          LET l_updatecard.tf_member_menbergrade = aws_ttsrv_getRecordField(l_node2, "tf_Member_MenberGrade") #会员等级
          LET l_updatecard.tf_member_menbertype = aws_ttsrv_getRecordField(l_node2, "tf_Member_MenberType")   #会员类型
          LET l_updatecard.tf_member_mobile = aws_ttsrv_getRecordField(l_node2, "tf_Member_Mobile")           #手机
          LET l_updatecard.optype = aws_ttsrv_getRecordField(l_node2, "OPType")                               #操作类型,0发卡1退卡
          LET l_updatecard.rechargeamt = aws_ttsrv_getRecordField(l_node2, "RechargeAMT")                     #充值金额
          LET l_updatecard.realamt = aws_ttsrv_getRecordField(l_node2, "RealAMT")                             #实际充值金额
          LET l_detail_updatecard[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_updatecard[l_j].GUID
          IF NOT g_guid_ex THEN
             IF NOT aws_chk_card('DeductPayment_1',l_updatecard.begincard,l_updatecard.endcard,l_updatecard.ctno,l_updatecard.optype+1,g_shop) THEN
                ROLLBACK WORK
                RETURN
             END IF 
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK 
             RETURN 
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_updatecard[l_j].success = 'Y'
                LET l_detail_updatecard[l_j].tf_Member_MemberNO = l_updatecard.tf_member_memberno
             ELSE
                CALL aws_deduct_payment_upd_updatecard(l_updatecard.*,l_detail_updatecard[l_j].GUID)
                   RETURNING l_lpk01
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_updatecard[l_j].success = 'Y'
                   LET l_detail_updatecard[l_j].tf_Member_MemberNO = l_lpk01
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_updatecard.deleteElement(l_j)

       #6：更新换卡状态
       FOR l_j=1 TO l_cnt7
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "UpdateChangeCard")     #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "UpdateChangeCard")        #FUN-D10095 Add
          LET l_updatechangecard.oldcard = aws_ttsrv_getRecordField(l_node2, "OldCard")  #原卡号
          LET l_updatechangecard.newcard = aws_ttsrv_getRecordField(l_node2, "NewCard")  #新卡号
          LET l_updatechangecard.password = aws_ttsrv_getRecordField(l_node2, "PassWord")#新卡密码
          LET l_detail_updatechangecard[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_updatechangecard[l_j].GUID
          IF NOT g_guid_ex THEN
             IF NOT aws_chk_card('DeductPayment_2',l_updatechangecard.oldcard,l_updatechangecard.oldcard,'','1',g_shop) THEN
                ROLLBACK WORK
                RETURN
             END IF
             IF NOT aws_chk_card('DeductPayment_2',l_updatechangecard.newcard,l_updatechangecard.newcard,'','2',g_shop) THEN
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN 
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_updatechangecard[l_j].success = 'Y'
             ELSE 
                CALL aws_deduct_payment_upd_updatechangecard(l_updatechangecard.*,l_detail_updatechangecard[l_j].GUID)
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_updatechangecard[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_updatechangecard.deleteElement(l_j)

       #7：更新充值储值
       FOR l_j=1 TO l_cnt8
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "UpdateRechargeCard")    #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "UpdateRechargeCard")       #FUN-D10095 Add
          LET l_updaterechargecard.cardno = aws_ttsrv_getRecordField(l_node2, "CardNO")   #卡号
          LET l_updaterechargecard.rechargeamt = aws_ttsrv_getRecordField(l_node2, "RechargeAMT") #充值金额
          LET l_updaterechargecard.realamt = aws_ttsrv_getRecordField(l_node2, "RealAMT") #实际充值金额
          LET l_detail_updaterechargecard[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_updaterechargecard[l_j].GUID
          IF NOT g_guid_ex THEN
             IF NOT aws_chk_card('DeductPayment_3',l_updaterechargecard.cardno,null,'','',g_shop) THEN
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN  
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_updaterechargecard[l_j].success = 'Y'
             ELSE 
                CALL aws_deduct_payment_upd_updaterechargecard(l_updaterechargecard.*,l_detail_updaterechargecard[l_j].GUID)
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_updaterechargecard[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_updaterechargecard.deleteElement(l_j)

       #8：更新劵
       FOR l_j=1 TO l_cnt9
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "UpdateCoupon")              #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "UpdateCoupon")                 #FUN-D10095 Add
          LET l_updatecoupon.begincoupon = aws_ttsrv_getRecordField(l_node2, "BeginCoupon")   #开始劵号
          LET l_updatecoupon.endcoupon = aws_ttsrv_getRecordField(l_node2, "EndCoupon")       #结束劵号
          LET l_updatecoupon.couponamt = aws_ttsrv_getRecordField(l_node2, "CouponAMT")       #金额,实际发劵金额或退劵金额
          LET l_updatecoupon.optype = aws_ttsrv_getRecordField(l_node2, "OPType")             #操作类型,0:发劵1:退劵
          LET l_detail_updatecoupon[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_updatecoupon[l_j].GUID
          IF NOT g_guid_ex THEN
             IF NOT aws_chk_coupon(l_updatecoupon.begincoupon,l_updatecoupon.endcoupon,l_updatecoupon.optype,g_shop) THEN
                LET g_success = 'N'
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_updatecoupon[l_j].success = 'Y'
             ELSE
                CALL aws_deduct_payment_upd_updatecoupon(l_updatecoupon.*,l_detail_updatecoupon[l_j].GUID)
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_updatecoupon[l_j].success = 'Y'
                END IF
             END IF
          END IF
       END FOR
       CALL l_detail_updatecoupon.deleteElement(l_j)
      #FUN-CA0090 End-----

       #FUN-CB0104--------add----------str
       #9：更新订单信息
       FOR l_j=1 TO l_cnt10
          #LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "UpdateOrderBill")       #FUN-D10095 Mark
          LET l_node2 = aws_ttsrv_getTreeRecord(l_node1, l_j, "UpdateOrderBill")          #FUN-D10095 Add
          LET l_updateorder.billtype = aws_ttsrv_getRecordField(l_node2, "BillType")      #订单类型
          LET l_updateorder.optype = aws_ttsrv_getRecordField(l_node2, "OPType")          #操作类型
          LET l_updateorder.shop = aws_ttsrv_getRecordField(l_node2, "Shop")              #下订门店
          LET l_updateorder.saleno = aws_ttsrv_getRecordField(l_node2, "SaleNo")          #订单单号
          LET l_updateorder.GUID = aws_ttsrv_getRecordField(l_node2, "GUID")              #GUID
          LET l_detail_updateorder[l_j].GUID = aws_ttsrv_getRecordField(l_node2, "GUID")
          LET l_guid2 = l_detail_updateorder[l_j].GUID
          IF NOT g_guid_ex THEN
             SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file WHERE ryg00 = 'ds_pos1'
             LET l_posdbs = s_dbstring(l_posdbs)
             LET l_db_links = aws_payment_dblinks(l_db_links)
             LET l_sql = " SELECT SHOP,ECSFLG ",
                         "   FROM ",l_posdbs,"td_Sale",l_db_links,         #中间库交易单主表
                         "  WHERE SaleNO = '",l_updateorder.saleno,"'",
                         "    AND SHOP = '",l_updateorder.shop,"'",
                         "    AND TYPE = '3'"
             PREPARE sel_shop_cs FROM l_sql
             EXECUTE sel_shop_cs INTO l_shop1,l_ECSFLG
             IF SQLCA.sqlcode = 100 THEN
                #訂單號不存在 
                CALL aws_pos_get_code('aws-924',l_updateorder.saleno,NULL,NULL)
                LET g_success = 'N'
                ROLLBACK WORK
                RETURN
             END IF
             IF l_shop1 <> l_updateorder.shop THEN
                #下訂門店沒有此訂單號
                CALL aws_pos_get_code('aws-925',l_updateorder.saleno,NULL,NULL)
                LET g_success = 'N'
                ROLLBACK WORK
                RETURN
             END IF 
             IF l_ECSFLG = 'Y' THEN
                #訂單已結案
                CALL aws_pos_get_code('aws-926',l_updateorder.saleno,NULL,NULL)
                LET g_success = 'N'
                ROLLBACK WORK
                RETURN
             END IF 
          END IF
          IF g_success = 'N' THEN
             ROLLBACK WORK
             RETURN
          ELSE
             IF g_guid_ex  THEN
                LET l_detail_updateorder[l_j].success = 'Y'
             ELSE
                #FUN-CC0057-----mark----str 
                #LET l_sql = " UPDATE ",l_posdbs,"td_Sale",l_db_links,
                #            "    SET ECSFLG = 'Y'",
                #            "  WHERE SaleNO = '",l_updateorder.saleno,"'",
                #            "    AND SHOP = '",l_updateorder.shop,"'",
                #            "    AND TYPE = '3'"
                #PREPARE upd_td_sale_cs FROM l_sql
                #EXECUTE upd_td_sale_cs
                #IF SQLCA.sqlcode THEN
                #   ROLLBACK WORK
                #   RETURN
                #ELSE
                #   LET l_detail_updateorder[l_j].success = 'Y'
                #END IF
                #FUN-CC0057-----mark----end
                #FUN-CC0057-----add-----str
                CALL aws_deduct_payment_upd_order(l_updateorder.saleno,l_updateorder.shop,l_detail_updateorder[l_j].GUID)
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   RETURN
                ELSE
                   LET l_detail_updateorder[l_j].success = 'Y'
                END IF
                #FUN-CC0057-----add-----end
             END IF
          END IF
       END FOR
       CALL l_detail_updateorder.deleteElement(l_j)
       #FUN-CB0104--------add----------end
       #TQC-C90019 mark begin---------------------------
       #IF NOT g_guid_ex THEN   #TQC-C90019 add
       #   LET l_len = g_lpj.getLength()
       #   FOR l_x = 1 TO l_len
       #       LET l_sql = " UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
       #                   "    SET lpj07 = lpj07 + ",g_lpj[l_x].lpj07,",",
       #                   "        lpj08 = '",g_lpj[l_x].lpj08,"',",
       #                   "        lpj15 = lpj15 + (",g_lpj[l_x].lpj15,")",
       #                   "  WHERE lpj03 = '",g_lpj[l_x].lpj03,"'"
       #       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       #       PREPARE upd_amt_pre7 FROM l_sql
       #       EXECUTE upd_amt_pre7
       #       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
       #          LET g_success = 'N'
       #          LET g_status.sqlcode = sqlca.sqlcode
       #          CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
       #       END IF
       #   END FOR
       #END IF   #TQC-C90019 add
       #TQC-C90019 mark end--------------------------------
       IF g_success = 'Y' THEN  #TQC-C80170 add
          #新增一笔返回的Master
          #LET  l_node = aws_ttsrv_addMasterRecord(base.Typeinfo.create(l_master),"PAY")                                                        #FUN-D10095 Mark
          LET  l_node = aws_ttsrv_addTreeMaster(base.Typeinfo.create(l_master),"Pay")                                                           #FUN-D10095 Add
          IF l_detail_card.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_card),"Card")                                                #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_card), "Card" , "1" , 1) RETURNING l_node2                      #FUN-D10095 Add
          END IF
          IF l_detail_coup.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_coup),"Coupon")                                              #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_coup), "Coupon" , "2" , 1) RETURNING l_node2                    #FUN-D10095 Add
          END IF
          IF l_detail_score.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_score),"Score")                                              #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_score), "Score" , "3" , 1) RETURNING l_node2                    #FUN-D10095 Add
          END IF
          IF l_detail_point.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_point),"WritePoint")                                         #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_point), "WritePoint" , "4" , 1) RETURNING l_node2               #FUN-D10095 Add
          END IF
         #FUN-CA0090 Begin---
          IF l_detail_updatecard.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_updatecard),"UpdateCard")                                    #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_updatecard), "UpdateCard" , "5" , 1) RETURNING l_node2          #FUN-D10095 Add
          END IF
          IF l_detail_updatechangecard.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_updatechangecard),"UpdateChangeCard")                        #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node,base.Typeinfo.create(l_detail_updatechangecard),"UpdateChangeCard","6",1) RETURNING l_node2    #FUN-D10095 Add
          END IF
          IF l_detail_updaterechargecard.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_updaterechargecard),"UpdateRechargeCard")                     #FUN-D10095 Mark 
             CALL aws_ttsrv_addTreeDetail(l_node,base.Typeinfo.create(l_detail_updaterechargecard),"UpdateRechargeCard","7",1) RETURNING l_node2 #FUN-D10095 Add
          END IF
          IF l_detail_updatecoupon.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_updatecoupon),"UpdateCoupon")                                 #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node,base.Typeinfo.create(l_detail_updatecoupon),"UpdateCoupon","8",1) RETURNING l_node2             #FUN-D10095 Add
          END IF
         #FUN-CA0090 End-----
          #FUN-CB0104  BEGIN----
          IF l_detail_updateorder.getLength() > 0 THEN
             #CALL aws_ttsrv_addDetailRecord(l_node, base.Typeinfo.create(l_detail_updateorder),"UpdateOrderBill")                               #FUN-D10095 Mark
             CALL aws_ttsrv_addTreeDetail(l_node, base.Typeinfo.create(l_detail_updateorder),"UpdateOrderBill","9",1) RETURNING l_node2          #FUN-D10095 Add
          END IF
          #FUN-CB0104  END-----
       END IF    #TQC-C80170 add
    END FOR
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION

#[
# Description....: 依據傳入資訊進行儲值卡检查操作操作
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_payment_check_card(p_card_no,p_amt)
   DEFINE p_card_no     LIKE lsn_file.lsn01
   DEFINE p_amt         LIKE lsn_file.lsn04 #扣款金额
   DEFINE l_sql         STRING
   DEFINE l_lpj RECORD
                lpj05   LIKE lpj_file.lpj05,     #有效期止
                lpj06   LIKE lpj_file.lpj06,     #儲值卡餘額
                lpj09   LIKE lpj_file.lpj09,     #卡狀態
                lph03   LIKE lph_file.lph03,     #可儲值否
                lnk05   LIKE lnk_file.lnk05
            END RECORD

   LET l_sql = " SELECT lpj05,lpj06,lpj09,lph03,lnk05",
               "   FROM ",cl_get_target_table(g_shop,"lpj_file"),
               "   LEFT JOIN ",cl_get_target_table(g_shop,"lph_file")," ON lph01=lpj02 ",
               "   LEFT JOIN ",cl_get_target_table(g_shop,"lnk_file")," ON lnk01=lpj02 ",
               "         AND lnk02 = '1' AND lnk03 ='",g_shop,"'",
               "  WHERE lpj03 = '",p_card_no,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   TRY
      PREPARE sel_lpj_pre FROM l_sql
      EXECUTE sel_lpj_pre INTO l_lpj.*
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   IF sqlca.sqlcode AND g_success = "Y" THEN
      LET g_success = "N"
      IF sqlca.sqlcode = 100 THEN
         CALL aws_pos_get_code('aws-911',p_card_no,NULL,NULL) #儲值卡不存在
      ELSE
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
      END IF
   END IF

   #判断儲值卡在本门店能否使用
   IF g_success = "Y" AND (cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N') THEN
      CALL aws_pos_get_code('aws-912',p_card_no,NULL,NULL)         #儲值卡在本门店不能使用
      LET g_success = "N"
   END IF

   #判断儲值卡是否失效
   IF g_success = "Y" AND (NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_trans_day) THEN
      CALL aws_pos_get_code('aws-913',p_card_no,NULL,NULL)         #儲值卡失效
      LET g_success = "N"
   END IF

   #检查儲值卡状态
   IF g_success = "Y" AND l_lpj.lpj09 <> '2' THEN
      CALL aws_pos_get_code('aws-914',p_card_no,l_lpj.lpj09,'2')  #儲值卡状态不符合
      LET g_success = "N"
   END IF

   #检查儲值卡是否可儲值
   IF g_success = "Y" AND (cl_null(l_lpj.lph03) OR l_lpj.lph03 = 'N') THEN
      CALL aws_pos_get_code('aws-915',p_card_no,NULL,NULL)         #儲值卡不可儲值
      LET g_success = "N"
   END IF

   #檢查卡餘額是否足夠扣減
   IF cl_null(l_lpj.lpj06) THEN LET l_lpj.lpj06 = 0 END IF
  #FUN-CB0028 Begin---
  #IF g_success = "Y" AND g_type MATCHES '[03]' THEN
   IF g_success = "Y" AND 
      g_type = '0' OR g_type = '3' OR g_type = '5' OR
      g_type = '7' OR g_type = '12' OR g_type = '16' THEN
  #FUN-CB0028 End-----
      IF l_lpj.lpj06 - p_amt < 0 THEN
         CALL aws_pos_get_code('aws-923',p_card_no,NULL,NULL)         #卡余额不够扣减
         LET g_success = "N"
      END IF
   END IF
   RETURN l_lpj.lpj06
END FUNCTION

#[
# Description....: 依據傳入資訊進行礼券检查操作操作
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_payment_chk_coup(p_coup_no)
   DEFINE p_coup_no   LIKE lqe_file.lqe01
   DEFINE l_sql       STRING
   DEFINE l_lnk05     LIKE lnk_file.lnk05,
          l_lqe17     LIKE lqe_file.lqe17,
          l_lqe21     LIKE lqe_file.lqe21

   LET l_sql = "SELECT lqe17,lqe21,lnk05",
               "  FROM ",cl_get_target_table(g_shop,"lqe_file"),
               "  LEFT JOIN ",cl_get_target_table(g_shop,"lpx_file")," ON lpx01=lqe02",
               "  LEFT JOIN ",cl_get_target_table(g_shop,"lnk_file")," ON lnk01=lpx01",
               "        AND lnk02 = '2' AND lnk03 ='",g_shop,"'",
               " WHERE lqe01 = '",p_coup_no,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   TRY
      PREPARE sel_lqe_pre FROM l_sql
      EXECUTE sel_lqe_pre INTO l_lqe17,l_lqe21,l_lnk05
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   IF sqlca.sqlcode AND g_success = "Y" THEN
      LET g_success = "N"
      IF sqlca.sqlcode = 100 THEN
         CALL aws_pos_get_code('aws-916',p_coup_no,NULL,NULL) #禮券不存在
      ELSE
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
      END IF
   END IF
   #判斷該券能否在此門店使用
   IF g_success = "Y" AND (cl_null(l_lnk05) OR l_lnk05='N') THEN
      CALL aws_pos_get_code('aws-917',p_coup_no,NULL,NULL)         #券在本门店不能使用
      LET g_success = "N"
   END IF

   #券是否失效
   IF g_success = "Y" AND l_lqe21 < g_trans_day THEN
      CALL aws_pos_get_code('aws-918',p_coup_no,NULL,NULL)     #券已經失效
      LET g_success = "N"
   END IF

   #檢查券的狀態
   CASE
     #FUN-CB0028 Begin---
     #WHEN g_type MATCHES '[03]'
      WHEN g_type = '0' OR g_type = '3' OR g_type = '5' OR
           g_type = '7' OR g_type = '12' OR g_type = '16'
     #FUN-CB0028 End-----
         IF g_success = "Y" AND l_lqe17 NOT MATCHES '[1]' THEN
            CALL aws_pos_get_code('aws-919',p_coup_no,l_lqe17,'1')     #券狀態不符合
            LET g_success = "N"
         END IF
      OTHERWISE
         IF g_success = "Y" AND l_lqe17 NOT MATCHES '[45]' THEN
            CALL aws_pos_get_code('aws-919',p_coup_no,l_lqe17,'1')     #券狀態不符合
            LET g_success = "N"
         END IF
   END CASE
   RETURN l_lqe17
END FUNCTION

#[
# Description....: 依據傳入資訊進行會員卡检查操作操作
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
FUNCTION aws_deduct_payment_chk_mcard(p_card_no,p_type,p_point)
   DEFINE p_card_no     LIKE lsn_file.lsn01,
          p_type        STRING,    #區分是寫積分還是積分抵現，1：積分抵現 2：寫積分
          p_point       LIKE lpj_file.lpj12
   DEFINE l_sql         STRING
   DEFINE l_lpj RECORD
                lpj05   LIKE lpj_file.lpj05,
                lpj09   LIKE lpj_file.lpj09,
                lpj12   LIKE lpj_file.lpj12,
                lpkacti LIKE lpk_file.lpkacti,
                lph06   LIKE lph_file.lph06,
                lph37   LIKE lph_file.lph37,
                lph38   LIKE lph_file.lph38,
                lph39   LIKE lph_file.lph39,
                lnk05   LIKE lnk_file.lnk05
            END RECORD
   #按條件查詢會員卡信息
   LET l_sql = " SELECT lpj05,lpj09,lpj12,lpkacti,lph06,lph37,lph38,lph39,lnk05 ",
               "   FROM ",cl_get_target_table(g_shop,"lpj_file"),
               "   LEFT JOIN ",cl_get_target_table(g_shop,"lpk_file")," ON lpk01=lpj01 ",
               "   LEFT JOIN ",cl_get_target_table(g_shop,"lph_file")," ON lph01=lpj02 ",
               "   LEFT JOIN ",cl_get_target_table(g_shop,"lnk_file")," ON lnk01=lpj02 ",
               "         AND lnk02 = '1' AND lnk03 ='",g_shop,"'",
               "  WHERE lpj03 = '",p_card_no,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   TRY
      PREPARE sel_lpj_pre1 FROM l_sql
      EXECUTE sel_lpj_pre1 INTO l_lpj.*
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   IF g_success = "Y" AND sqlca.sqlcode THEN
      LET g_success = "N"
      IF sqlca.sqlcode = 100 THEN
         CALL aws_pos_get_code('aws-905',p_card_no,NULL,NULL) #卡不存在
      ELSE
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL) #ERP系統錯誤
      END IF
   END IF
   #判断会员卡在本门店能否使用
   IF g_success = "Y" AND (cl_null(l_lpj.lnk05) OR l_lpj.lnk05='N') THEN
      LET g_success = "N"
      CALL aws_pos_get_code('aws-906',p_card_no,NULL,NULL)         #会员卡在本门店不能使用
   END IF

   #判断会员卡是否失效
   IF g_success = "Y" AND ((NOT cl_null(l_lpj.lpj05) AND l_lpj.lpj05 <= g_trans_day) OR cl_null(l_lpj.lpkacti) OR
      l_lpj.lpkacti = 'N') THEN
      LET g_success = "N"
      CALL aws_pos_get_code('aws-907',p_card_no,NULL,NULL)         #会员卡失效
   END IF
   #检查会员卡状态
   IF g_success = "Y" AND l_lpj.lpj09 <> '2' THEN
      LET g_success = "N"
      CALL aws_pos_get_code('aws-908',p_card_no,l_lpj.lpj09,'2')  #会员卡状态不符合
   END IF

   IF p_type="2" THEN  #FUN-D10040 Mod
      #检查会员卡是否可积分
      IF g_success = "Y" AND (cl_null(l_lpj.lph06) OR l_lpj.lph06 = 'N') THEN
         CALL aws_pos_get_code('aws-910',p_card_no,NULL,NULL)         #会员卡不可积分
         LET g_success = 'N'
      END IF
      #檢查積分是否足夠扣減
      IF g_success = "Y" AND g_type MATCHES '[12]' THEN #FUN-D10040 Mod
         IF cl_null(l_lpj.lpj12) OR l_lpj.lpj12 - p_point < 0 THEN
            CALL aws_pos_get_code('aws-909',p_card_no,NULL,NULL)    #积分扣减失败，该卡积分不够扣减
            LET g_success = 'N'
         END IF
      END IF
   END IF

   IF p_type="1" THEN  #FUN-D10040 Mod
     #FUN-D10040 Add Begin ---
      #检查会员卡是否可积分
      IF g_success = "Y" AND (cl_null(l_lpj.lph06) OR l_lpj.lph06 = 'N') THEN
         CALL aws_pos_get_code('aws-910',p_card_no,NULL,NULL)         #会员卡不可积分
         LET g_success = 'N'
      END IF
     #FUN-D10040 Add End -----
      #检查会员卡是否可积分抵現
      IF g_success= "Y" AND (cl_null(l_lpj.lph37) OR l_lpj.lph37 = 'N') THEN
         LET g_success = "N"
         CALL aws_pos_get_code('aws-920',p_card_no,NULL,NULL)         #会员卡不积分抵現
      END IF
   END IF

   RETURN l_lpj.lpj12,l_lpj.lph38,l_lpj.lph39
END FUNCTION

#[
# Description....: 依據傳入資訊進行更改前資料鎖定操作
# Date & Author..: 2012/07/05 by suncx
# Parameter......: none
# Return.........: none
#]
#FUNCTION aws_deduct_payment_lock(p_node,p_cnt1,p_cnt2,p_cnt3,p_cnt4)
#FUNCTION aws_deduct_payment_lock(p_node,p_cnt1,p_cnt2,p_cnt3,p_cnt4,p_cnt5,p_cnt6,p_cnt7,p_cnt8) #FUN-CA0090   #FUN-CB0104 mark
FUNCTION aws_deduct_payment_lock(p_node,p_cnt1,p_cnt2,p_cnt3,p_cnt4,p_cnt5,p_cnt6,p_cnt7,p_cnt8,p_cnt9)         #FUN-CB0104 add
   DEFINE p_node     om.DomNode,
          p_cnt1     LIKE type_file.num10,
          p_cnt2     LIKE type_file.num10,
          p_cnt3     LIKE type_file.num10,
          p_cnt4     LIKE type_file.num10
         #FUN-CA0090 Begin---
         ,p_cnt5     LIKE type_file.num10,
          p_cnt6     LIKE type_file.num10,
          p_cnt7     LIKE type_file.num10,
          p_cnt8     LIKE type_file.num10
         #FUN-CA0090 End-----
         ,p_cnt9     LIKE type_file.num10    #FUN-CB0104 add
   DEFINE l_node     om.DomNode
   DEFINE l_j        INTEGER
   DEFINE l_sql      STRING
   DEFINE l_card_no  STRING,
          l_order_no STRING,    #FUN-CB0104 add
          l_coup_no  STRING
   DEFINE l_card_wc  STRING,
          l_order_wc STRING,    #FUN-CB0104 add
          l_coup_wc  STRING
   DEFINE l_posdbs   LIKE ryg_file.ryg00 #FUN-CB0104 add
   DEFINE l_db_links LIKE ryg_file.ryg02 #FUN-CB0104 add

   #儲值卡資料
   FOR l_j = 1 TO p_cnt1
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "Card")  #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "Card")     #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "CardNO")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR

   #券資料
   FOR l_j = 1 TO p_cnt2
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "Coupon")  #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "Coupon")     #FUN-D10095 Add 
      LET l_coup_no = aws_ttsrv_getRecordField(l_node, "CouponNO")
      IF cl_null(l_coup_wc) THEN
         LET l_coup_wc = "'",l_coup_no,"'"
      ELSE
         IF l_coup_wc.getIndexOf(l_coup_no,1) <= 0 THEN
            LET l_coup_wc = l_coup_wc,",'",l_coup_no,"'"
         END IF
      END IF
   END FOR

   #積分抵現資料
   FOR l_j = 1 TO p_cnt3
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "Score")   #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "Score")      #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "CardNO")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR

   #積分資料
   FOR l_j = 1 TO p_cnt4
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "WritePoint") #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "WritePoint")    #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "CardNO")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR

  #FUN-CA0090 Begin---
   #储值卡充值
   FOR l_j = 1 TO p_cnt7
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "UpdateRechargeCard")  #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "UpdateRechargeCard")     #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "OldCard")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR
   #发卡退卡
   FOR l_j = 1 TO p_cnt5
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "UpdateCard")          #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "UpdateCard")             #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "BeginCard")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR
   #换卡
   FOR l_j = 1 TO p_cnt6
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "UpdateChangeCard")    #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "UpdateChangeCard")       #FUN-D10095 Add
      LET l_card_no = aws_ttsrv_getRecordField(l_node, "OldCard")
      IF cl_null(l_card_wc) THEN
         LET l_card_wc = "'",l_card_no,"'"
      ELSE
         IF l_card_wc.getIndexOf(l_card_no,1) <= 0 THEN
            LET l_card_wc = l_card_wc,",'",l_card_no,"'"
         END IF
      END IF
   END FOR
   #收券 退券
   FOR l_j = 1 TO p_cnt8
      #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "UpdateCoupon")        #FUN-D10095 Mark
      LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "UpdateCoupon")           #FUN-D10095 Add
      LET l_coup_no = aws_ttsrv_getRecordField(l_node, "BeginCoupon")
      IF cl_null(l_coup_wc) THEN
         LET l_coup_wc = "'",l_coup_no,"'"
      ELSE
         IF l_coup_wc.getIndexOf(l_coup_no,1) <= 0 THEN
            LET l_coup_wc = l_coup_wc,",'",l_coup_no,"'"
         END IF
      END IF
   END FOR
  #FUN-CA0090 End-----

   #FUN-CB0104   BEGIN-----
   #订单
   FOR l_j = 1 TO p_cnt9
       #LET l_node = aws_ttsrv_getDetailRecord(p_node, l_j, "UpdateOrderBill")    #FUN-D10095 Mark
       LET l_node = aws_ttsrv_getTreeRecord(p_node, l_j, "UpdateOrderBill")       #FUN-D10095 Add
       LET l_order_no = aws_ttsrv_getRecordField(l_node, "SaleNo")
       IF cl_null(l_order_wc) THEN
         LET l_order_wc = "'",l_order_no,"'"
      ELSE
         IF l_order_wc.getIndexOf(l_order_no,1) <= 0 THEN
            LET l_order_wc = l_order_wc,",'",l_order_no,"'"
         END IF
      END IF
   END FOR
   #FUN-CB0104   END-------
   #定義鎖CURSOR
   IF NOT cl_null(l_card_wc) THEN
      LET l_sql = "SELECT * FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj03 IN (",l_card_wc,") FOR UPDATE"
      LET l_sql=cl_forupd_sql(l_sql)
      DECLARE lpj_cl CURSOR FROM l_sql
      OPEN lpj_cl
      IF STATUS THEN
         LET g_status.sqlcode = STATUS
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = "N"
      END IF
   END IF
   IF NOT cl_null(l_coup_wc) THEN
      LET l_sql = "SELECT * FROM ",cl_get_target_table(g_shop,"lqe_file"),
                  " WHERE lqe01 IN (",l_coup_wc,") FOR UPDATE"
      LET l_sql = cl_forupd_sql(l_sql)
      DECLARE lqe_cl CURSOR FROM l_sql
      OPEN lqe_cl
      IF STATUS THEN
         LET g_status.sqlcode = STATUS
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = "N"
      END IF
   END IF
   SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file WHERE ryg00 = 'ds_pos1'
   LET l_posdbs = s_dbstring(l_posdbs)
   LET l_db_links = aws_payment_dblinks(l_db_links)
   IF NOT cl_null(l_order_wc) THEN
      #LET l_sql = "SELECT * FROM ",l_posdbs,"td_Sale",l_db_links,       #FUN-D10095 Mark
      LET l_sql = "SELECT SaleNO FROM ",l_posdbs,"td_Sale",l_db_links,   #FUN-D10095 Add
                  "  WHERE SaleNO IN (",l_order_wc,") FOR UPDATE"
      LET l_sql = cl_forupd_sql(l_sql)
      DECLARE oea_cl CURSOR FROM l_sql
      OPEN oea_cl
      IF STATUS THEN
         LET g_status.sqlcode = STATUS
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = "N"
      END IF
   END IF
   #IF cl_null(l_card_wc) AND cl_null(l_coup_wc) THEN                           #FUN-CB0104 mark
   IF cl_null(l_card_wc) AND cl_null(l_coup_wc) AND cl_null(l_order_wc) THEN    #FUN-CB0104 add
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = "N"
   END IF
END FUNCTION

FUNCTION aws_deduct_payment_upd_card(p_card_no,p_amt,p_guid,p_lpj06)
   DEFINE p_card_no     LIKE lsn_file.lsn01
   DEFINE p_amt         LIKE lsn_file.lsn04 #扣款金额
   DEFINE p_guid        STRING
   DEFINE l_sql         STRING
   DEFINE l_balance     LIKE lsn_file.lsn04  #储值卡余额 扣款完之后的余额
   DEFINE p_lpj06       LIKE lpj_file.lpj06,
          l_lpj07       LIKE lpj_file.lpj07,   #纍計消費次數  #TQC-C90019 add
          l_lpj15       LIKE lpj_file.lpj15    #纍計消費金額  #TQC-C90019 add
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_lsn04       LIKE lsn_file.lsn04,  #本次異動金額
          l_lsn02       LIKE lsn_file.lsn02   #單據类型
   TRY
     #FUN-CB0028 Begin---
     #CASE
     #   WHEN g_type MATCHES '[03]'   #扣減餘額
     #      LET l_lsn04 = -1*p_amt
     #      IF g_type = '0' THEN LET l_lsn02 = '7' END IF   #銷售單
     #      IF g_type = '3' THEN LET l_lsn02 = '6' END IF   #訂單
     #   WHEN g_type MATCHES '[124]'   #增加餘額
     #      LET l_lsn04 = p_amt
     #      IF g_type MATCHES '[12]' THEN LET l_lsn02 = '8' END IF   #銷退單
     #      IF g_type = '4' THEN LET l_lsn02 = '9' END IF            #預收退回
     #   OTHERWISE
     #      RETURN
     #END CASE
      CASE g_type
         WHEN '0'   #銷售單
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '7'
         WHEN '3'   #訂單
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '6'
         WHEN '1'   #銷退單
            LET l_lsn04 = p_amt
            LET l_lsn02 = '8'
         WHEN '2'   #銷退單
            LET l_lsn04 = p_amt
            LET l_lsn02 = '8'
         WHEN '4'   #預收退回
            LET l_lsn04 = p_amt
            LET l_lsn02 = '9'
         WHEN '5'   #充值
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '3'
         WHEN '7'   #售卡
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '2'
         WHEN '8'   #退卡
            LET l_lsn04 = p_amt
            LET l_lsn02 = '4'
         WHEN '12'  #售券
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '7'
         WHEN '13'  #退券
            LET l_lsn04 = p_amt
            LET l_lsn02 = '8'
         WHEN '16'  #换卡
            LET l_lsn04 = -1*p_amt
            LET l_lsn02 = '5'
         OTHERWISE    
            RETURN 0
      END CASE
     #FUN-CB0028 End-----
      #TQC-C90019 add begin---------------------------------
      LET l_lpj07 = 0
      LET l_lpj15 = 0
      IF NOT aws_deduct_payment_isMemberCard(p_card_no) THEN
        #LET l_lpj07 = 1        #FUN-CA0090 #储值卡不更新累计消费次数
        #LET l_lpj15 = l_lsn04              #FUN-D30017 Mark
         LET l_lpj15 = l_lsn04*(-1)         #FUN-D30017 Add
      END IF
      #IF g_success = 'N' THEN RETURN END IF   #FUN-D10039 MARK
      IF g_success = 'N' THEN RETURN 0 END IF  #FUN-D10039 ADD
      #TQC-C90019 add end-----------------------------------
      LET l_sql = " UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
                  "    SET lpj06 = lpj06 + (",l_lsn04,"),",
                  "        lpj07 = lpj07 + (",l_lpj07,"),",   #TQC-C90019 add
                  "        lpj15 = lpj15 + (",l_lpj15,"),",   #TQC-C90019 add
                  "        lpj08 = '",g_trans_day,"'",        #TQC-C90019 add
                  "  WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE upd_amt_pre FROM l_sql
      EXECUTE upd_amt_pre
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF

      #寫儲值卡金額異動檔
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_shop
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_shop,"lsn_file"),
                  " WHERE lsn01='",p_card_no,"' AND lsn02='",l_lsn02,"' ",
                  "   AND lsnstore = '",g_shop,"'", #FUN-CB0118
                  "   AND lsn03='",g_sale_no,"' AND lsn10='2'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lsn_prep2 FROM l_sql
      EXECUTE sel_lsn_prep2 INTO l_cnt
      IF l_cnt = 0 THEN
         LET l_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsn_file"),
                     "(lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsn09,lsn10,lsnlegal,lsnplant,lsnstore)", #FUN-CB0118 Add lsnstore
                     "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?) " #FUN-CB0118
         PREPARE insert_lsn_prep FROM  l_sql
         EXECUTE insert_lsn_prep USING p_card_no,l_lsn02,g_sale_no,l_lsn04,
                                      #g_trans_day,l_num,l_num,g_lsn10,l_legal,g_shop        #FUN-CB0118
                                       g_trans_day,'100',l_num,g_lsn10,l_legal,g_shop,g_shop #FUN-CB0118
      ELSE
         LET l_sql = "UPDATE ",cl_get_target_table(g_shop,"lsn_file"),
                    #"   SET lsn04 = lsn04 + ",p_amt,                                        #FUN-D30017 Mark
                     "   SET lsn04 = lsn04 + ",l_lsn04,                                      #FUN-D30017 Add
                     " WHERE lsn01='",p_card_no,"' AND lsn02='",l_lsn02,"' ",
                     "   AND lsnstore = '",g_shop,"'", #FUN-CB0118
                     "   AND lsn03='",g_sale_no,"' AND lsn10='2'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE upd_lsn_prep2 FROM l_sql
         EXECUTE upd_lsn_prep2
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF
      #重新獲取餘額
      LET l_sql = "SELECT lpj06 FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj06_pre2 FROM l_sql
      EXECUTE sel_lpj06_pre2 INTO l_balance
      IF SQLCA.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         #寫rxu_file
         CALL aws_deduct_payment_init_rxu(p_guid,'4',p_card_no,p_lpj06,l_balance,l_lsn04,0)
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) THEN
            LET g_success = g_flag
         ELSE
            LET g_success = 'N'
         END IF
      END IF
      #TQC-C90019 mark begin------------------------------------
      #IF g_success = 'Y' THEN
      #   CALL aws_deduct_payment_setLpjArray(p_card_no,-1*l_lsn04)
      #END IF
      #TQC-C90019 mark end--------------------------------------
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   RETURN l_balance
END FUNCTION

FUNCTION aws_deduct_payment_upd_coup(p_coup_no,p_guid,p_lqe17)
   DEFINE p_coup_no   LIKE lqe_file.lqe01
   DEFINE l_sql       STRING
   DEFINE p_guid      STRING
   DEFINE p_lqe17     LIKE lqe_file.lqe17
   DEFINE l_state     LIKE lqe_file.lqe17

   TRY
      LET l_sql = " UPDATE ",cl_get_target_table(g_shop,"lqe_file")
      CASE
        #FUN-CB0028 Begin---
        #WHEN g_type MATCHES '[03]'
         WHEN g_type = '0' OR g_type = '3' OR g_type = '5' OR 
              g_type = '7' OR g_type = '12' OR g_type = '16'
        #FUN-CB0028 End-----
            LET l_state = '4'
            #LET l_sql = l_sql,"  SET lqe17 = '4', lqe18 = '",g_shop,"',",  #FUN-D10040 mark
            #                  "      lqe19 = '",g_trans_day,"'",           #FUN-D10040 mark
            LET l_sql = l_sql,"  SET lqe17 = '4', lqe24 = '",g_shop,"',",   #FUN-D10040 add
                              "      lqe25 = '",g_trans_day,"'",            #FUN-D10040 add
                              "WHERE lqe17 = '1' "
         OTHERWISE
            LET l_state = '1'
            #LET l_sql = l_sql,"  SET lqe17 = '1',lqe18 = '',lqe19 = '' ",  #FUN-D10040 mark
            LET l_sql = l_sql,"  SET lqe17 = '1',lqe24 = '',lqe25 = '' ",   #FUN-D10040 add
                              "WHERE lqe17 IN('4','5') "
      END CASE
      LET l_sql = l_sql," AND lqe01 = '",p_coup_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE upd_amt_pre1 FROM l_sql
      EXECUTE upd_amt_pre1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF

      #寫rxu_file
      IF g_success = 'Y' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'5',p_coup_no,p_lqe17,l_state,NULL,0)
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) THEN
            LET g_success = g_flag
         ELSE
            LET g_success = 'N'
         END IF
      END IF
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
END FUNCTION

FUNCTION aws_deduct_payment_upd_score(p_card_no,p_amt,p_score,p_guid,p_lpj12,p_lph38,p_lph39)
   DEFINE l_sql         STRING
   DEFINE p_card_no     LIKE lsn_file.lsn01
   DEFINE p_amt         LIKE lsn_file.lsn04 #扣款金额
   DEFINE p_score       LIKE lpj_file.lpj12
   DEFINE p_guid        STRING
   DEFINE p_lpj12       LIKE lpj_file.lpj12
   DEFINE p_lph38       LIKE lph_file.lph38,
          p_lph39       LIKE lph_file.lph39
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_lpj12       LIKE lpj_file.lpj12
   DEFINE l_lsm04       LIKE lsm_file.lsm04,  #本次異動積分
          l_lsm02       LIKE lsm_file.lsm02,  #單據类型
          l_lsm08       LIKE lsm_file.lsm08,
          l_lpj07       LIKE lpj_file.lpj07   #纍計消費次數  #TQC-C90019 add
   TRY
      #更新積分
      CASE
         WHEN g_type MATCHES '[03]'   #扣減積分
            LET p_score = (p_amt/p_lph39)*p_lph38
            LET l_lsm04 = -1*p_score
            IF g_type = '0' THEN LET l_lsm02 = '9' END IF   #銷售單積分抵現
            IF g_type = '3' THEN LET l_lsm02 = 'B' END IF   #訂單積分抵現
         WHEN g_type MATCHES '[124]'
            IF p_score <= 0 OR cl_null(p_score) THEN
               LET p_score = (p_amt/p_lph39)*p_lph38
            END IF
            LET l_lsm04 = p_score
            IF g_type MATCHES '[12]' THEN LET l_lsm02 = 'A' END IF   #銷退單積分抵現
            IF g_type = '4' THEN LET l_lsm02 = 'C' END IF            #退訂單積分抵現
         OTHERWISE                   
           #RETURN                                                   #FUN-D30017 Mark
            RETURN 0                                                 #FUN-D30017 Add
      END CASE
      #TQC-C90019 add begin---------------------------------
      LET l_lpj07 = 0
      IF NOT aws_deduct_payment_isMemberCard(p_card_no) THEN
         LET l_lpj07 = 1
      END IF
      #IF g_success = 'N' THEN RETURN END IF   #FUN-D10039 MARK
      IF g_success = 'N' THEN RETURN 0 END IF  #FUN-D10039 ADD
      #TQC-C90019 add end-----------------------------------
      LET l_sql = " UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
                  "    SET lpj12 = lpj12 + (",l_lsm04,"),",
                  "        lpj13 = lpj13 - (",l_lsm04,"),",
                  "        lpj07 = lpj07 + (",l_lpj07,"),",  #TQC-C90019 add
                  "        lpj08 = '",g_trans_day,"'",       #TQC-C90019 add
                  "  WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE upd_point_pre FROM l_sql
      EXECUTE upd_point_pre
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
      END IF

      #寫積分異動檔
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_shop
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_shop,"lsm_file"),
                  " WHERE lsm01='",p_card_no,"' AND lsm02='",l_lsm02,"' ",
                  "   AND lsm03='",g_sale_no,"' AND lsm05='",g_trans_day,"'",
                  "   AND lsmstore = '",g_shop,"'", #FUN-CB0118
                  "   AND lsm15='2'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lsm_prep2 FROM l_sql
      EXECUTE sel_lsm_prep2 INTO l_cnt
      LET l_lsm08 = 0
      IF l_cnt = 0 THEN
         LET l_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsm_file"),
                     "        (lsm01,lsm02,lsm03,lsm04,lsm05, lsm06,lsm07,lsm08,lsmlegal,lsmplant,",#FUN-CB0118
                     "         lsm09,lsm10,lsm11,lsm12,lsm13, lsm14,lsm15,lsmstore)",               #FUN-CB0118
                     "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE insert_lsm_prep2 FROM l_sql
         EXECUTE insert_lsm_prep2 USING p_card_no,l_lsm02,g_sale_no,l_lsm04,g_trans_day,l_date,g_shop,l_lsm08,
                                       l_legal,g_shop,l_num,l_num,l_num,l_num,l_num,l_date,g_lsm15,g_shop #FUN-CB0118
      ELSE
         LET l_sql = "UPDATE ",cl_get_target_table(g_shop,"lsm_file"),
                    #"   SET lsm04 = lsm04 + ",p_score,                                             #FUN-D30017 Mark
                     "   SET lsm04 = lsm04 + ",l_lsm04,                                             #FUN-D30017 Add
                     " WHERE lsm01='",p_card_no,"' AND lsm02='",l_lsm02,"' ",
                     "   AND lsm03='",g_sale_no,"' AND lsm05='",g_trans_day,"'",
                     "   AND lsmstore = '",g_shop,"'", #FUN-CB0118
                     "   AND lsm15='2'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE upd_lsm_prep2 FROM l_sql
         EXECUTE upd_lsm_prep2
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
      END IF

      #重新獲取積分
      LET l_sql = "SELECT lpj12 FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj12_pre FROM l_sql
      EXECUTE sel_lpj12_pre INTO l_lpj12
      IF SQLCA.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
      END IF
      #寫rxu_file
      IF g_success = 'Y' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'3',p_card_no,p_lpj12,l_lpj12,l_lsm04,0)
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) THEN
            LET g_success = g_flag
         ELSE
            LET g_success = 'N'
         END IF
      END IF
      #TQC-C90019 mark begin------------------------------------
      #IF g_success = 'Y' THEN
      #   CALL aws_deduct_payment_setLpjArray(p_card_no,NULL)
      #END IF
      #TQC-C90019 mark end--------------------------------------
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   RETURN p_score
END FUNCTION

FUNCTION aws_deduct_payment_upd_point(p_card_no,p_guid,p_amt,p_point,p_lpj12)
   DEFINE p_card_no     LIKE lsn_file.lsn01
   DEFINE p_amt         LIKE lsn_file.lsn04
   DEFINE p_point       LIKE lpj_file.lpj12
   DEFINE p_lpj12       LIKE lpj_file.lpj12
   DEFINE p_guid        STRING
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_sql         STRING
   DEFINE l_lpj12       LIKE lpj_file.lpj12
   DEFINE l_lsm04       LIKE lsm_file.lsm04,  #本次異動積分
          l_lsm02       LIKE lsm_file.lsm02,  #單據类型
          l_lsm08       LIKE lsm_file.lsm08
   TRY
      #更新積分
      CASE
         WHEN g_type MATCHES '[03]'   #積分增加
            LET l_lsm04 = p_point
            LET l_lsm08 = p_amt
            IF g_type = '0' THEN LET l_lsm02 = '7' END IF   #銷售單積分
            IF g_type = '3' THEN LET l_lsm02 = 'X' END IF   #訂單積分 目前先給X
         WHEN g_type MATCHES '[124]'  #積分減少
            LET l_lsm04 = -1*p_point
            LET l_lsm08 = -1*p_amt
            IF g_type MATCHES '[12]' THEN LET l_lsm02 = '8' END IF   #銷退單積分
            IF g_type = '4' THEN LET l_lsm02 = 'Y' END IF   #退訂單積分 目前先給X
         OTHERWISE
           #RETURN         #FUN-D30017 Mark
            RETURN 0       #FUN-D30017 Add
      END CASE
      LET l_sql = " UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
                  "    SET lpj12 = lpj12 + (",l_lsm04,"),",
                  "        lpj14 = lpj14 + (",l_lsm04,"),",
                  "        lpj07 = COALESCE(lpj07,0) + 1,",   #TQC-C90019 add
                  "        lpj15 = lpj15 + (",l_lsm08,"),",   #TQC-C90019 add
                  "        lpj08 = '",g_trans_day,"'",        #TQC-C90019 add
                  "  WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE upd_point_pre4 FROM l_sql
      EXECUTE upd_point_pre4
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF

      #寫積分異動檔
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_shop
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_shop,"lsm_file"),
                  " WHERE lsm01='",p_card_no,"' AND lsm02='",l_lsm02,"' ",
                  "   AND lsmstore = '",g_shop,"'", #FUN-CB0118
                  "   AND lsm03='",g_sale_no,"' AND lsm05='",g_trans_day,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lsm_prep1 FROM l_sql
      EXECUTE sel_lsm_prep1 INTO l_cnt
      IF l_cnt = 0 THEN
         LET l_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsm_file"),
                     "        (lsm01,lsm02,lsm03,lsm04,lsm05, lsm06,lsm07,lsm08,lsmlegal,lsmplant,",#FUN-CB0118
                     "         lsm09,lsm10,lsm11,lsm12,lsm13, lsm14,lsm15,lsmstore)",               #FUN-CB0118
                     "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) " #FUN-CB0118
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE insert_lsm_prep1 FROM l_sql
         EXECUTE insert_lsm_prep1 USING p_card_no,l_lsm02,g_sale_no,l_lsm04,g_trans_day,l_date,g_shop,l_lsm08,
                                       l_legal,g_shop,l_num,l_num,l_num,l_num,l_num,l_date,g_lsm15,g_shop #FUN-CB0118 Add g_shop
      ELSE
         LET l_sql = "UPDATE ",cl_get_target_table(g_shop,"lsm_file"),
                    #FUN-D30017-------Mark&Add-------Str
                    #"   SET lsm04 = lsm04 + ",p_point,",",
                    #"       lsm08 = lsm08 + ",p_amt,     
                     "   SET lsm04 = lsm04 + ",l_lsm04,                      
                     "       lsm08 = lsm08 + ",l_lsm08,  
                    #FUN-D30017-------Mark&Add-------End
                     " WHERE lsm01='",p_card_no,"' AND lsm02='",l_lsm02,"' ",
                     "   AND lsmstore = '",g_shop,"'", #FUN-CB0118
                     "   AND lsm03='",g_sale_no,"' AND lsm05='",g_trans_day,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE upd_lsm_prep1 FROM l_sql
         EXECUTE upd_lsm_prep1
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF
      #重新獲取積分
      LET l_sql = "SELECT lpj12 FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj03 = '",p_card_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj12_pre3 FROM l_sql
      EXECUTE sel_lpj12_pre3 INTO l_lpj12
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF

      #寫rxu_file
      IF g_success = 'Y' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'2',p_card_no,p_lpj12,l_lpj12,l_lsm04,l_lsm08)
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) THEN
            LET g_success = g_flag
         ELSE
            LET g_success = 'N'
         END IF
      END IF
      #TQC-C90019 mark begin------------------------------------
      #IF g_success = 'Y' THEN
      #   CALL aws_deduct_payment_setLpjArray(p_card_no,l_lsm08)
      #END IF
      #TQC-C90019 mark end--------------------------------------
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
   RETURN l_lpj12
END FUNCTION

FUNCTION aws_deduct_payment_init_rxu(p_rxu02,p_rxu06,p_rxu07,p_rxu08,p_rxu09,p_rxu10,p_rxu15)
DEFINE p_rxu02 LIKE rxu_file.rxu02,
       p_rxu06 LIKE rxu_file.rxu06,
       p_rxu07 LIKE rxu_file.rxu07,
       p_rxu08 LIKE rxu_file.rxu08,
       p_rxu09 LIKE rxu_file.rxu09,
       p_rxu10 LIKE rxu_file.rxu10,
       p_rxu15 LIKE rxu_file.rxu15

   INITIALIZE g_rxu.* TO NULL
   LET g_rxu.rxu01 = g_guid
   LET g_rxu.rxu02 = p_rxu02
   LET g_rxu.rxu03 = g_shop
   LET g_rxu.rxu04 = g_sale_no
   LET g_rxu.rxu05 = g_service
   LET g_rxu.rxu06 = p_rxu06
   LET g_rxu.rxu07 = p_rxu07
   LET g_rxu.rxu08 = p_rxu08
   LET g_rxu.rxu09 = p_rxu09
   LET g_rxu.rxu10 = p_rxu10
   LET g_rxu.rxu11 = g_today
   LET g_rxu.rxu12 = g_time
   LET g_rxu.rxu13 = aws_pos_get_ConnectionMsg("mach")
   LET g_rxu.rxu14 = g_type
   LET g_rxu.rxu15 = p_rxu15
   LET g_rxu.rxuacti = 'Y'
   IF cl_null(g_rxu.rxu02) THEN LET g_rxu.rxu02 = ' ' END IF
   IF cl_null(g_rxu.rxu15) THEN LET g_rxu.rxu15 = 0 END IF

END FUNCTION

#TQC-C90019 mark begin------------------------------------
#FUNCTION aws_deduct_payment_setLpjArray(p_lpj03,p_lpj15)
#DEFINE l_i,l_j INTEGER
#DEFINE l_is    BOOLEAN
#DEFINE p_lpj03 LIKE lpj_file.lpj03,
#       p_lpj15 LIKE lpj_file.lpj15
#
#    LET l_i = g_lpj.getLength()
#    IF l_i > 0 THEN
#       LET l_is = FALSE
#       FOR l_j = 1 TO l_i
#           IF g_lpj[l_j].lpj03 = p_lpj03 THEN
#               LET g_lpj[l_j].lpj15 = 0   #TQC-C80170 add
#               IF NOT cl_null(p_lpj15) THEN
#                  LET g_lpj[l_j].lpj15 = p_lpj15
#               END IF
#               LET l_is = TRUE
#           END IF
#       END FOR
#       IF NOT l_is THEN
#           LET l_i = l_i+1
#           LET g_lpj[l_i].lpj03 = p_lpj03
#           LET g_lpj[l_i].lpj07 = 1
#           LET g_lpj[l_i].lpj08 = g_trans_day
#           LET g_lpj[l_i].lpj15 = p_lpj15
#           IF cl_null(g_lpj[l_i].lpj15) THEN LET g_lpj[l_i].lpj15 = 0 END IF  #TQC-C80170 add
#       END IF
#    ELSE
#        LET g_lpj[1].lpj03 = p_lpj03
#        LET g_lpj[1].lpj07 = 1
#        LET g_lpj[1].lpj08 = g_trans_day
#        LET g_lpj[1].lpj15 = p_lpj15
#        IF cl_null(g_lpj[1].lpj15) THEN LET g_lpj[1].lpj15 = 0 END IF    #TQC-C80170 add
#    END IF
#END FUNCTION
#TQC-C90019 mark end--------------------------------------

#TQC-C90019 add begin--------------------------------------
#判斷卡是否是會員卡
FUNCTION aws_deduct_payment_isMemberCard(p_cardno)
DEFINE p_cardno LIKE lpj_file.lpj03
DEFINE l_lpj01  LIKE lpj_file.lpj01
DEFINE l_sql    STRING 
   TRY 
      #FUN-D10039-------mark---str
      #LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(g_shop,"lpj_file"),
      #            "                  ,",cl_get_target_table(g_shop,"lpk_file"),
      #            "  WHERE lpj03 = '",p_cardno,"' AND lpj01=lpk01"
      #FUN-D10039-------mark---end
      #FUN-D10039-------add----str
      LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(g_shop,"lpj_file")," LEFT OUTER JOIN ",
                                        cl_get_target_table(g_shop,"lpk_file")," ON (lpj01=lpk01)",
                  "  WHERE lpj03 = '",p_cardno,"'"
      #FUN-D10039-------add----end
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE sel_lpj01_pre FROM l_sql
      EXECUTE sel_lpj01_pre INTO l_lpj01
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         LET g_success = "N"
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         RETURN FALSE 
      END IF
   CATCH 
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      RETURN FALSE
   END TRY 
   IF cl_null(l_lpj01) THEN 
      RETURN FALSE
   ELSE 
      RETURN TRUE 
   END IF 
END FUNCTION
#TQC-C90019 add end----------------------------------------

#FUN-CA0090 Begin---
FUNCTION aws_deduct_payment_upd_updatecard(p_updatecard,p_guid)
 DEFINE p_updatecard RECORD
                     begincard LIKE lpj_file.lpj03,             #开始卡号
                     endcard   LIKE lpj_file.lpj03,             #结束卡号
                     cardamt   LIKE lpj_file.lpj06,             #工本费，退卡不给值
                     ctno      LIKE lpj_file.lpj02,             #卡种
                     PassWord  LIKE lpj_file.lpj26,             #密码
                     tf_member_memberno    LIKE lpj_file.lpj01, #会员编号
                     tf_member_merbername  LIKE lpk_file.lpk04, #会员姓名
                     tf_member_menbergrade LIKE lpk_file.lpk11, #会员等级
                     tf_member_menbertype  LIKE lpk_file.lpk13, #会员类型
                     tf_member_mobile      LIKE lpk_file.lpk18, #手机
                     optype                LIKE type_file.chr1, #操作类型,0发卡1退卡
                     rechargeamt           LIKE lpj_file.lpj06, #发卡,客户给的金额;退卡，退给客户的
                     realamt               LIKE lpj_file.lpj06  #发卡,实际充值金额;退卡，卡余额
                     END RECORD
 DEFINE p_guid       LIKE rxu_file.rxu02
 DEFINE l_lpk01      LIKE lpk_file.lpk01
 DEFINE l_name       LIKE ima_file.ima02
 DEFINE l_legal      LIKE azw_file.azw02
 DEFINE l_lsn02      LIKE lsn_file.lsn02
 DEFINE l_lsn04      LIKE lsn_file.lsn04
 DEFINE l_lsn09      LIKE lsn_file.lsn09
 
   CALL s_getlegal(g_shop) RETURNING l_legal

   #如果会员编号为空，表示POS新增的会员，需要自动编号，回传会员编号给POS，否则表示erp已有此会员编号
   IF cl_null(p_updatecard.tf_member_memberno) AND NOT cl_null(p_updatecard.tf_member_merbername) AND #FUN-CB0028
      p_updatecard.optype = '0' THEN
      IF g_aza.aza109 = 'Y' THEN
         CALL s_auno(l_lpk01,'8','') RETURNING l_lpk01,l_name
      END IF
      IF cl_null(l_lpk01) THEN
         LET l_lpk01 = p_updatecard.begincard
      END IF
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lpk_file"),
                  "   (lpk01,lpk04,lpk10,lpk13,lpk18,lpk21,lpkpos) ",  #FUN-CC0135 add lpk21
                  "VALUES(?,?,?,?,?,?,?)"                              #FUN-CC0135 add 1 ?
      PREPARE ins_lpk_p FROM g_sql
      EXECUTE ins_lpk_p USING l_lpk01,p_updatecard.tf_member_merbername,
                              p_updatecard.tf_member_menbergrade,p_updatecard.tf_member_menbertype,
                              p_updatecard.tf_member_mobile,'Y','1'    #FUN-CC0135 add 'Y'
      IF SQLCA.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
         RETURN ''
      END IF
   ELSE
      LET l_lpk01 = p_updatecard.tf_member_memberno
   END IF

   #FUN-CB0028 Begin---
    IF cl_null(p_updatecard.ctno) AND p_updatecard.optype = '1' THEN
       LET g_sql = "SELECT lpj01,lpj02 FROM ",cl_get_target_table(g_shop,"lpj_file"),
                   " WHERE lpj03 = '",p_updatecard.begincard,"' "
       PREPARE sel_lpj02 FROM g_sql
       EXECUTE sel_lpj02 INTO l_lpk01,p_updatecard.ctno
    END IF
   #FUN-CB0028 End-----
   IF p_updatecard.optype = '0' THEN
      LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
                  "   SET lpj01 = ?,lpj06 = ?,lpj09 = ?,lpj11 = ?,lpj04 = ?,",
                  "       lpj05 = ?,lpj17 = ?,lpj26 = ?,lpjpos = '2' ",
                  " WHERE lpj02 = '",p_updatecard.ctno,"'",
                  "   AND lpj03 BETWEEN '",p_updatecard.begincard,"' AND '",p_updatecard.endcard,"'"
      PREPARE upd_lpj_p FROM g_sql
      EXECUTE upd_lpj_p USING l_lpk01,p_updatecard.realamt,'2','100',g_today,
                              '',g_shop,p_updatecard.password
   ELSE
      LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
                  "   SET lpj06 = 0,lpj09 = ?,lpj21 = ?,lpj22 = ?,lpjpos = ? ",
                  " WHERE lpj02 = '",p_updatecard.ctno,"'",
                  "   AND lpj03 BETWEEN '",p_updatecard.begincard,"' AND '",p_updatecard.endcard,"'"
      PREPARE upd_lpj_p1 FROM g_sql
      EXECUTE upd_lpj_p1 USING '4',g_today,g_shop,'2'
   END IF
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN l_lpk01
   END IF
   IF p_updatecard.realamt > 0 THEN  #FUN-CB0028
      IF p_updatecard.optype = '0' THEN
         LET l_lsn02 = '2'
         LET l_lsn09 = p_updatecard.realamt - p_updatecard.rechargeamt
         LET l_lsn04 = p_updatecard.realamt
      ELSE
         LET l_lsn02 = '4'
         LET l_lsn09 = 0
         LET l_lsn04 = p_updatecard.rechargeamt*(-1)
      END IF
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsn_file"),
                  "       (lsn01,lsn02,lsn03,lsn04,lsn05,",
                  "        lsn06,lsn07,lsn08,lsn09,lsn10,",
                  "        lsnlegal,lsnplant,lsnstore) ",
                  "SELECT lpj03,'",l_lsn02,"','",g_sale_no,"','",l_lsn04,"','",g_today,"',",
                  "       '',100,' ','",l_lsn09,"','2',",
                  "       '",l_legal,"','",g_shop,"','",g_shop,"' ",
                  "  FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj02 = '",p_updatecard.ctno,"'",
                  "   AND lpj03 BETWEEN '",p_updatecard.begincard,"' AND '",p_updatecard.endcard,"'"
      PREPARE ins_lsn_p1 FROM g_sql
      EXECUTE ins_lsn_p1 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
         LET g_success = 'N'
         RETURN l_lpk01
      END IF
   END IF  #FUN-CB0028
   
   IF g_success = 'Y' THEN
      #寫rxu_file
      IF p_updatecard.optype = '0' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'6',p_updatecard.begincard,p_updatecard.begincard,p_updatecard.endcard,l_lsn04,0)
      ELSE
         CALL aws_deduct_payment_init_rxu(p_guid,'7',p_updatecard.begincard,'2','4',p_updatecard.realamt,0)
      END IF
      CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
      IF NOT cl_null(g_flag) THEN
         LET g_success = g_flag
      ELSE
         LET g_success = 'N'
      END IF
   END IF

   RETURN l_lpk01
END FUNCTION

FUNCTION aws_deduct_payment_upd_updatechangecard(p_updatechangecard,p_guid)
 DEFINE p_updatechangecard RECORD
                     oldcard        LIKE lpj_file.lpj03,   #原卡号
                     newcard        LIKE lpj_file.lpj03,   #新卡号
                     password       LIKE lpj_file.lpj03    #新卡密码
                     END RECORD
 DEFINE p_guid       LIKE rxu_file.rxu02
 DEFINE l_lpj        RECORD LIKE lpj_file.*

   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_shop,"lpj_file"),
               " WHERE lpj03 = '",p_updatechangecard.oldcard,"'"
   PREPARE sel_oldlpj_p FROM g_sql
   EXECUTE sel_oldlpj_p INTO l_lpj.*

   #写lsm_file和lsn_file
   CALL t616_ins_lsm(p_updatechangecard.*)

   LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
               "   SET lpj01 = ?,",
               "       lpj04 = ?,",
               "       lpj05 = ?,",
               "       lpj06 = ?,",
               "       lpj07 = ?,",
               "       lpj08 = ?,",
               "       lpj11 = ?,",
               "       lpj12 = ?,",
               "       lpj13 = ?,",
               "       lpj14 = ?,",
               "       lpj15 = ?,",
               "       lpj17 = ?,",
               "       lpj09 = '2',",
               "       lpj26 = ?,",
               "       lpjpos = '2'",
               " WHERE lpj03 = '",p_updatechangecard.newcard,"'"
   PREPARE upd_newlpj_p FROM g_sql
   EXECUTE upd_newlpj_p USING l_lpj.lpj01,g_today,    l_lpj.lpj05,l_lpj.lpj06,
                              g_lpj07,    g_lpj08,    l_lpj.lpj11,l_lpj.lpj12,
                              g_lpj13,    g_lpj14,    g_lpj15,g_shop,p_updatechangecard.password
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF

   LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
               "   SET lpj09 = '4',",
               "       lpj21 = ?,",
               "       lpj22 = ?,",
               "       lpjpos = ? ",
               " WHERE lpj03 = '",p_updatechangecard.oldcard,"'"
   PREPARE upd_oldlpj_p FROM g_sql
   EXECUTE upd_oldlpj_p USING g_today,g_shop,'2'
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF
   
   IF g_success = 'Y' THEN
      #寫rxu_file
      CALL aws_deduct_payment_init_rxu(p_guid,'8',p_updatechangecard.oldcard,p_updatechangecard.oldcard,p_updatechangecard.newcard,l_lpj.lpj06,0)
      CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
      IF NOT cl_null(g_flag) THEN
         LET g_success = g_flag
      ELSE
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION

#將新卡資訊寫入 almq618 
FUNCTION t616_ins_lsm(p_updatechangecard)
 DEFINE p_updatechangecard RECORD
                     oldcard        LIKE lpj_file.lpj03,   #原卡号
                     newcard        LIKE lpj_file.lpj03,   #新卡号
                     password       LIKE lpj_file.lpj03    #新卡密码
                     END RECORD
 DEFINE l_lsm        RECORD LIKE lsm_file.*
 DEFINE l_sql        STRING
 DEFINE l_lsm09      LIKE lsm_file.lsm09
 DEFINE l_lsm10      LIKE lsm_file.lsm10 
 DEFINE l_lsm11      LIKE lsm_file.lsm11
 DEFINE l_lsm12      LIKE lsm_file.lsm12
 DEFINE l_lsm13      LIKE lsm_file.lsm13
 DEFINE l_lsm14      LIKE lsm_file.lsm14
 DEFINE l_plant      LIKE azw_file.azw01 
 DEFINE l_lsm09_1    LIKE lsm_file.lsm09
 DEFINE l_lsm10_1    LIKE lsm_file.lsm10
 DEFINE l_lsm11_1    LIKE lsm_file.lsm11
 DEFINE l_lsm12_1    LIKE lsm_file.lsm12
 DEFINE l_lsm13_1    LIKE lsm_file.lsm13
 DEFINE l_legal      LIKE azw_file.azw02

   CALL s_getlegal(g_shop) RETURNING l_legal

   LET g_lpj07 = 0
   LET g_lpj13 = 0
   LET g_lpj14 = 0
   LET g_lpj15 = 0
   LET l_lsm09 = 0
   LET l_lsm10 = 0
   LET l_lsm11 = 0
   LET l_lsm12 = 0
   LET l_lsm13 = 0 
   LET l_lsm14 = NULL
   LET l_lsm09_1 = 0
   LET l_lsm10_1 = 0
   LET l_lsm11_1 = 0
   LET l_lsm12_1 = 0
   LET l_lsm13_1 = 0
   LET l_lsm.lsm01 = p_updatechangecard.newcard
   LET l_lsm.lsm02 = '4'
   LET l_lsm.lsm15 = '2'
   LET l_lsm.lsm03 = g_sale_no
   LET l_lsm.lsm04 = 0
   LET l_lsm.lsm05 = g_today
   LET l_lsm.lsm06 = NULL
   LET l_lsm.lsm08 = 0
   LET l_lsm.lsm09 = 0
   LET l_lsm.lsm10 = 0
   LET l_lsm.lsm11 = 0 
   LET l_lsm.lsm12 = 0
   LET l_lsm.lsm13 = 0
   LET l_lsm.lsm14 = NULL  
   LET l_lsm.lsmplant = g_shop
   LET l_lsm.lsmlegal = l_legal
   LET l_lsm.lsmstore = g_shop  #FUN-CB0118
  #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",l_legal,"'"
  #PREPARE t616_db FROM l_sql
  #DECLARE t616_cdb CURSOR FOR t616_db
  #FOREACH t616_cdb INTO l_plant
     #1.開帳，2.補積分，3.積分清零，4.換卡，5.積分換物，6.積分換券，7出貨單，8.銷退單，9.出貨單積分抵現，A.銷退積分抵現
     #累計消費次數
      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"'",
                  "    AND lsm02 IN ('7', '8') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm09 FROM l_sql
      EXECUTE t616_lsm09 INTO l_lsm09
      IF cl_null(l_lsm09) THEN LET l_lsm09 = 0 END IF
     
      LET l_lsm09_1 = 0
      LET l_sql = " SELECT lsm09 FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"' AND lsm02 IN ('1','4') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm09_1 FROM l_sql
      EXECUTE t616_lsm09_1 INTO l_lsm09_1
      IF cl_null(l_lsm09_1) THEN LET l_lsm09_1 = 0 END IF
      LET l_lsm.lsm09 = l_lsm.lsm09 + l_lsm09 + l_lsm09_1   
      LET g_lpj07 = l_lsm.lsm09
      
     #累計消費金額  
      LET l_sql = " SELECT SUM(lsm08) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"'",
                  "    AND lsm02 IN ('2', '3', '4','7', '8') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm10 FROM l_sql
      EXECUTE t616_lsm10 INTO l_lsm10
      IF cl_null(l_lsm10) THEN LET l_lsm10 = 0 END IF

      LET l_lsm10_1 = 0
      LET l_sql = " SELECT SUM(lsm10) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"' AND lsm02 = '1'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm10_1 FROM l_sql
      EXECUTE t616_lsm10_1 INTO l_lsm10_1
      IF cl_null(l_lsm10_1) THEN LET l_lsm10_1 = 0 END IF
      LET l_lsm.lsm10 = l_lsm.lsm10 + l_lsm10 + l_lsm10_1 
      LET g_lpj15 = l_lsm.lsm10

     #累計消費積分
      LET l_sql = " SELECT SUM(lsm04) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"'",
                  "    AND lsm02 IN ('2', '3', '7', '8') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm11 FROM l_sql
      EXECUTE t616_lsm11 INTO l_lsm11
      IF cl_null(l_lsm11) THEN LET l_lsm11 = 0 END IF

      LET l_lsm11_1 = 0 
      LET l_sql = " SELECT SUM(lsm11) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"' AND lsm02 IN ('1','2') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm11_1 FROM l_sql
      EXECUTE t616_lsm11_1 INTO l_lsm11_1
      IF cl_null(l_lsm11_1) THEN LET l_lsm11_1 = 0 END IF
      LET l_lsm.lsm11 = l_lsm.lsm11 + l_lsm11 + l_lsm11_1
      LET g_lpj14 = l_lsm.lsm11
      
     #已兌換積分
      LET l_sql = " SELECT SUM(lsm04) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"'",
                  "    AND lsm02 IN ('5', '6', '9', 'A') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm13 FROM l_sql
      EXECUTE t616_lsm13 INTO l_lsm13
      IF cl_null(l_lsm13) THEN LET l_lsm13 = 0 END IF

      LET l_lsm13_1 = 0
      LET l_sql = " SELECT SUM(lsm13) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"' AND lsm02 IN ('1','2') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm13_1 FROM l_sql
      EXECUTE t616_lsm13_1 INTO l_lsm13_1
      IF cl_null(l_lsm13_1) THEN LET l_lsm13_1 = 0 END IF
      LET l_lsm.lsm13 = l_lsm.lsm13 + l_lsm13 + l_lsm13_1
      LET g_lpj13 = l_lsm.lsm13

     #最後消費日
      LET l_sql = " SELECT MAX(lsm05) FROM ",cl_get_target_table(l_plant,'lsm_file'),
                  "  WHERE lsm01 = '",p_updatechangecard.oldcard,"'",
                  "    AND lsm02 IN ('1','2', '3','4', '7', '8') "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE t616_lsm14 FROM l_sql
      EXECUTE t616_lsm14 INTO l_lsm14
      IF NOT cl_null(l_lsm14) THEN
         IF NOT cl_null(l_lsm.lsm14) THEN
            IF l_lsm14 > l_lsm.lsm14 THEN
               LET l_lsm.lsm14 = l_lsm14
            END IF
         ELSE
            LET l_lsm.lsm14 = l_lsm14
         END IF
      END IF
      LET g_lpj08 = l_lsm.lsm14
  #END FOREACH

  #剩餘積分
   LET l_sql = " SELECT SUM(lsm12) FROM ",cl_get_target_table(l_plant,'lsm_file'),
               "  WHERE lsm01 = '",p_updatechangecard.oldcard,"' AND lsm02 IN ('1','2') "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
   PREPARE t616_lsm12_1 FROM l_sql
   EXECUTE t616_lsm12_1 INTO l_lsm12_1
   IF cl_null(l_lsm12_1) THEN LET l_lsm12_1 = 0 END IF
   LET l_lsm.lsm12 = l_lsm.lsm11 + l_lsm.lsm13 + l_lsm12_1

   
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsm_file"),
               "       (lsm01,lsm02,lsm03,lsm04,lsm05,",
               "        lsm06,lsm07,lsm08,lsm09,lsm10,",
               "        lsm11,lsm12,lsm13,lsm14,lsm15,",
               "        lsmlegal,lsmplant,lsmstore) ",   #FUN-CB0118 Add lsmstore
               "VALUES (?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)" #FUN-CB0118
   PREPARE ins_lsn_p3 FROM g_sql
   EXECUTE ins_lsn_p3 USING l_lsm.lsm01,l_lsm.lsm02,l_lsm.lsm03,l_lsm.lsm04,l_lsm.lsm05,
                            l_lsm.lsm06,l_lsm.lsm07,l_lsm.lsm08,l_lsm.lsm09,l_lsm.lsm10,
                            l_lsm.lsm11,l_lsm.lsm12,l_lsm.lsm13,l_lsm.lsm14,l_lsm.lsm15,
                            l_lsm.lsmlegal,l_lsm.lsmplant,l_lsm.lsmstore
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   ELSE
      CALL t616_ins_lsn(p_updatechangecard.*) 
   END IF
END FUNCTION

FUNCTION t616_ins_lsn(p_updatechangecard)
 DEFINE p_updatechangecard RECORD
                     oldcard        LIKE lpj_file.lpj03,   #原卡号
                     newcard        LIKE lpj_file.lpj03,   #新卡号
                     password       LIKE lpj_file.lpj03    #新卡密码
                     END RECORD
 DEFINE l_lsn        RECORD LIKE lsn_file.*
 DEFINE l_sql        STRING
 DEFINE l_lsn04      LIKE lsn_file.lsn04
 DEFINE l_lsn09      LIKE lsn_file.lsn09
 DEFINE l_plant      LIKE azw_file.azw02
 DEFINE l_legal      LIKE azw_file.azw02

   CALL s_getlegal(g_shop) RETURNING l_legal

   LET l_lsn04 = 0
   LET l_lsn09 = 0 
   LET l_lsn.lsn01 = p_updatechangecard.newcard
   LET l_lsn.lsn02 = '5'
   LET l_lsn.lsn10 = '2'
   LET l_lsn.lsn03 = g_sale_no
   LET l_lsn.lsn04 = 0
   LET l_lsn.lsn05 = g_today
   LET l_lsn.lsn06 = NULL
   LET l_lsn.lsn07 = 100 
   LET l_lsn.lsn08 = ' ' 
   LET l_lsn.lsn09 = 0
   LET l_lsn.lsnlegal = l_legal 
   LET l_lsn.lsnplant = g_shop
   LET l_lsn.lsnstore = g_shop
  #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",l_legal,"'"
  #PREPARE q619_db FROM l_sql
  #DECLARE q619_cdb CURSOR FOR q619_db
  #FOREACH q619_cdb INTO l_plant   
  #  #本次異動金額
  #   LET l_sql = " SELECT SUM(lsn04) FROM ",cl_get_target_table(l_plant,'lsn_file'),
  #               "  WHERE lsn01 = '",p_updatechangecard.oldcard,"' ",
  #               "    AND lsnstore = '",l_plant,"'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
  #   PREPARE t616_lsn04 FROM l_sql
  #   EXECUTE t616_lsn04 INTO l_lsn04 
  #   IF cl_null(l_lsn04) THEN LET l_lsn04 = 0 END IF
  #   LET l_lsn.lsn04 = l_lsn.lsn04 + l_lsn04  

  #  #加值金額
  #   LET l_sql = " SELECT SUM(lsn09) FROM ",cl_get_target_table(l_plant,'lsn_file'),
  #               "  WHERE lsn01 = '",p_updatechangecard.oldcard,"' ",
  #               "    AND lsnstore = '",l_plant,"'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
  #   PREPARE t616_lsn09 FROM l_sql
  #   EXECUTE t616_lsn09 INTO l_lsn09  
  #   IF cl_null(l_lsn09) THEN LET l_lsn09 = 0 END IF
  #   LET l_lsn.lsn09 = l_lsn.lsn09 + l_lsn09 
  #
  #END FOREACH
  #本次異動金額
   LET l_sql = " SELECT SUM(lsn04) FROM ",cl_get_target_table(g_shop,'lsn_file'),
               "  WHERE lsn01 = '",p_updatechangecard.oldcard,"' "
   PREPARE t616_lsn04 FROM l_sql
   EXECUTE t616_lsn04 INTO l_lsn.lsn04 
   IF cl_null(l_lsn.lsn04) THEN LET l_lsn.lsn04 = 0 END IF

  #加值金額
   LET l_sql = " SELECT SUM(lsn09) FROM ",cl_get_target_table(g_shop,'lsn_file'),
               "  WHERE lsn01 = '",p_updatechangecard.oldcard,"' "
   PREPARE t616_lsn09 FROM l_sql
   EXECUTE t616_lsn09 INTO l_lsn.lsn09  
   IF cl_null(l_lsn.lsn09) THEN LET l_lsn.lsn09 = 0 END IF

   LET l_sql = " SELECT lph08  FROM ",cl_get_target_table(g_shop,'lph_file'),
               "  WHERE lph01 = lpj02 ",
               "    AND lpj03 = '",p_updatechangecard.newcard,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_shop) RETURNING l_sql
   PREPARE t616_lsn07 FROM l_sql
   EXECUTE t616_lsn07 INTO l_lsn.lsn07
   IF cl_null(l_lsn.lsn07) THEN LET l_lsn.lsn07 = 100 END IF
   
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsn_file"),
               "       (lsn01,lsn02,lsn03,lsn04,lsn05,",
               "        lsn06,lsn07,lsn08,lsn09,lsn10,",
               "        lsnlegal,lsnplant,lsnstore) ",
               "VALUES (?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"
   PREPARE ins_lsn_p4 FROM g_sql
   EXECUTE ins_lsn_p4 USING l_lsn.lsn01,l_lsn.lsn02,l_lsn.lsn03,l_lsn.lsn04,l_lsn.lsn05,
                            l_lsn.lsn06,l_lsn.lsn07,l_lsn.lsn08,l_lsn.lsn09,l_lsn.lsn10,
                            l_lsn.lsnlegal,l_lsn.lsnplant,l_lsn.lsnstore
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION aws_deduct_payment_upd_updaterechargecard(p_updaterechargecard,p_guid)
 DEFINE p_updaterechargecard RECORD
                     cardno         LIKE lpj_file.lpj03,   #卡号
                     rechargeamt    LIKE lpj_file.lpj06,   #充值金额
                     realamt        LIKE lpj_file.lpj06    #实际充值金额
                     END RECORD
 DEFINE p_guid       LIKE rxu_file.rxu02
 DEFINE l_legal      LIKE azw_file.azw02
 DEFINE l_lpj06      LIKE lpj_file.lpj06
 DEFINE l_lsn09      LIKE lsn_file.lsn09

   CALL s_getlegal(g_shop) RETURNING l_legal

   LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lpj_file"),
               "   SET lpj06 = COALESCE(lpj06,0) + ?,",
               "       lpjpos = ? ",
               " WHERE lpj03 = '",p_updaterechargecard.cardno,"'"
   PREPARE upd_lpj06_p FROM g_sql
   EXECUTE upd_lpj06_p USING p_updaterechargecard.realamt,'2'
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF

   LET l_lsn09 = p_updaterechargecard.realamt-p_updaterechargecard.rechargeamt
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_shop,"lsn_file"),
               "       (lsn01,lsn02,lsn03,lsn04,lsn05,",
               "        lsn06,lsn07,lsn08,lsn09,lsn10,",
               "        lsnlegal,lsnplant,lsnstore) ",
               "VALUES (?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"
   PREPARE ins_lsn_p FROM g_sql
   EXECUTE ins_lsn_p USING p_updaterechargecard.cardno,'3',g_sale_no,p_updaterechargecard.realamt,g_today,
                           '','100',' ',l_lsn09,'2',
                           l_legal,g_shop,g_shop
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF

   
   IF g_success = 'Y' THEN
      LET g_sql = "SELECT COALESCE(lpj06,0) FROM ",cl_get_target_table(g_shop,"lpj_file"),
                  " WHERE lpj03 = '",p_updaterechargecard.cardno,"'"
      PREPARE sel_lpj06_p FROM g_sql
      EXECUTE sel_lpj06_p INTO l_lpj06
      #寫rxu_file
      CALL aws_deduct_payment_init_rxu(p_guid,'9',p_updaterechargecard.cardno,l_lpj06,l_lpj06+p_updaterechargecard.realamt,p_updaterechargecard.realamt,0)
      CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
      IF NOT cl_null(g_flag) THEN
         LET g_success = g_flag
      ELSE
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION

FUNCTION aws_deduct_payment_upd_updatecoupon(p_updatecoupon,p_guid)
 DEFINE p_updatecoupon RECORD
                     begincoupon    LIKE lqe_file.lqe01,   #开始劵号
                     endcoupon      LIKE lqe_file.lqe01,   #结束券号
                     couponamt      LIKE lrz_file.lrz02,   #金额,实际发劵金额或退劵金额
                     optype         LIKE type_file.chr1    #操作类型,0:发劵1:退劵
                     END RECORD
 DEFINE p_guid       LIKE rxu_file.rxu02

   IF p_updatecoupon.optype = '0' THEN
      LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lqe_file"),
                  "   SET lqe06 = ?,",
                  "       lqe07 = ?,",
                  "       lqe17 = '1' ",
                  " WHERE lqe01 BETWEEN ? AND ? "
      PREPARE upd_lqe_p1 FROM g_sql
      EXECUTE upd_lqe_p1 USING g_shop,g_today,p_updatecoupon.begincoupon,p_updatecoupon.endcoupon
   ELSE
      LET g_sql = "UPDATE ",cl_get_target_table(g_shop,"lqe_file"),
                  "   SET lqe09 = ?,",
                  "       lqe10 = ?,",
                  "       lqe17 = '2' ",
                  " WHERE lqe01 BETWEEN ? AND ? "
      PREPARE upd_lqe_p2 FROM g_sql
      EXECUTE upd_lqe_p2 USING g_shop,g_today,p_updatecoupon.begincoupon,p_updatecoupon.endcoupon
   END IF
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_status.sqlcode = sqlca.sqlcode
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      LET g_success = 'N'
      RETURN
   END IF
   IF g_success = 'Y' THEN
      #寫rxu_file
      IF p_updatecoupon.optype = '0' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'10',p_updatecoupon.begincoupon,p_updatecoupon.begincoupon,p_updatecoupon.endcoupon,'',0)
      ELSE
         CALL aws_deduct_payment_init_rxu(p_guid,'11',p_updatecoupon.begincoupon,p_updatecoupon.begincoupon,p_updatecoupon.endcoupon,'',0)
      END IF
      CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
      IF NOT cl_null(g_flag) THEN
         LET g_success = g_flag
      ELSE
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION

FUNCTION aws_chk_coupon(p_bgift,p_egift,p_optype,p_shop)
 DEFINE p_bgift          LIKE lqe_file.lqe01
 DEFINE p_egift          LIKE lqe_file.lqe01
 DEFINE p_shop           LIKE azw_file.azw01
 DEFINE p_optype         LIKE type_file.chr1
 DEFINE l_lpx21          LIKE lpx_file.lpx21
 DEFINE l_lpx22          LIKE lpx_file.lpx22
 DEFINE l_lqe02          LIKE lqe_file.lqe02
 DEFINE l_cnt            LIKE type_file.num5
 DEFINE l_num            LIKE type_file.num5
 DEFINE l_lqe            RECORD
               lqe01     LIKE lqe_file.lqe01,
               lqe02     LIKE lqe_file.lqe02,
               lnk03     LIKE lnk_file.lnk03,
               lpx15     LIKE lpx_file.lpx15,
               lqe21     LIKE lqe_file.lqe21,
               lqe17     LIKE lqe_file.lqe17,
               lrz02     LIKE lrz_file.lrz02,
               lqe09     LIKE lqe_file.lqe09,
               lqe13     LIKE lqe_file.lqe13
                         END RECORD

   LET g_sql = "SELECT lpx21,lpx22 FROM ",cl_get_target_table(p_shop,"lpx_file"),",",
                                          cl_get_target_table(p_shop,"lqe_file"),
               " WHERE lqe02 = lpx01",
               "   AND lqe01 = '",p_bgift,"'"
   PREPARE sel_lpx_per FROM g_sql
   EXECUTE sel_lpx_per INTO l_lpx21,l_lpx22
   #Error_16:礼券msg不存在!
   IF SQLCA.sqlcode = 100 THEN
      CALL aws_pos_get_code('aws-916',p_bgift,NULL,NULL)
      RETURN FALSE
   END IF
   LET l_num = p_egift[l_lpx22+1,l_lpx21] - p_bgift[l_lpx22+1,l_lpx21] + 1
   
   LET g_sql = "SELECT lqe01,lqe02,lnk03,lpx15,lqe21,lqe17,lrz02,lqe09,lqe13",
               "  FROM ",cl_get_target_table(p_shop,"lpx_file"),",",
                         cl_get_target_table(p_shop,"lqe_file"),"  LEFT OUTER JOIN ",
                         cl_get_target_table(p_shop,"lnk_file")," ON (lqe02 = lnk01 AND lnk02 = '2' AND ",
               "                                                     lnk03 ='",p_shop,"' AND lnk05 = 'Y') LEFT OUTER JOIN ",
                         cl_get_target_table(p_shop,"lrz_file")," ON (lqe03 = lrz01) ",
               " WHERE lqe02 = lpx01",
               "   AND lqe01 BETWEEN '",p_bgift,"' AND '",p_egift,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE sel_lqe_per FROM g_sql
   DECLARE sel_lqe_cs CURSOR FOR sel_lqe_per
   LET l_cnt = 0
   FOREACH sel_lqe_cs INTO l_lqe.*
      #Error_17:礼券msg在本门店不能使用!
      IF cl_null(l_lqe.lnk03) OR (l_lqe.lqe17='2' AND l_lqe.lqe09<>p_shop) OR (l_lqe.lqe17='5' AND l_lqe.lqe13<>p_shop) THEN
         CALL aws_pos_get_code('aws-917',l_lqe.lqe01,NULL,NULL)
         RETURN FALSE
      END IF
      #Error_18:礼券msg已失效!
      IF (NOT cl_null(l_lqe.lqe21) AND l_lqe.lqe21 < g_today) OR l_lqe.lpx15 = 'N' THEN
         CALL aws_pos_get_code('aws-918',l_lqe.lqe01,NULL,NULL)
         RETURN FALSE
      END IF
      #Error_19:礼券msg状态为：
      IF p_optype = '0' THEN     #发券
         IF l_lqe.lqe17 <> '5' AND l_lqe.lqe17 <> '2' THEN
            CALL aws_pos_get_code('aws-919',l_lqe.lqe01,l_lqe.lqe17,'1')
            RETURN FALSE
         END IF
      END IF
      IF p_optype = '1' THEN     #退券
         IF l_lqe.lqe17 <> '1' THEN
            CALL aws_pos_get_code('aws-919',l_lqe.lqe01,l_lqe.lqe17,'1')
            RETURN FALSE
         END IF
      END IF
      #Error_30:礼券msg与其他劵种不一致！
      IF l_lqe02 <> l_lqe.lqe02 THEN
         CALL aws_pos_get_code('aws-930',l_lqe.lqe01,NULL,NULL)
         RETURN FALSE
      END IF
      LET l_lqe02 = l_lqe.lqe02
      IF cl_null(l_lqe.lrz02) THEN
         LET l_lqe.lrz02 = 0
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   #Error_16:礼券msg不存在!
   IF l_cnt = 0 OR l_cnt <> l_num THEN
      CALL aws_pos_get_code('aws-916',l_lqe.lqe01,NULL,NULL)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-CA0090 End-----

#FUN-CB0104-----add---str
FUNCTION aws_payment_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION
#FUN-CB0104-----add---end
#FUN-CC0057-----add---str
FUNCTION aws_deduct_payment_upd_order(p_orderno,p_shop,p_guid)
DEFINE p_orderno      LIKE oea_file.oea01
DEFINE p_shop         LIKE rtz_file.rtz01
DEFINE l_sql          STRING
DEFINE p_guid         STRING
DEFINE l_posdbs       LIKE ryg_file.ryg00
DEFINE l_db_links     LIKE ryg_file.ryg02
   TRY
      SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file WHERE ryg00 = 'ds_pos1'
      LET l_posdbs = s_dbstring(l_posdbs)
      LET l_db_links = aws_payment_dblinks(l_db_links)
      LET l_sql = " UPDATE ",l_posdbs,"td_Sale",l_db_links,
                  "    SET ECSFLG = 'Y'",
                  "  WHERE SaleNO = '",p_orderno,"'",
                  "    AND SHOP = '",p_shop,"'",
                  "    AND TYPE = '3'"
      PREPARE upd_td_sale_cs FROM l_sql
      EXECUTE upd_td_sale_cs
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
         LET g_success = 'N'
         LET g_status.sqlcode = sqlca.sqlcode
         CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
      END IF

      #寫rxu_file
      IF g_success = 'Y' THEN
         CALL aws_deduct_payment_init_rxu(p_guid,'13',p_orderno,NULL,NULL,NULL,0)
         CALL aws_pos_ins_rxu(g_rxu.*) RETURNING g_flag
         IF NOT cl_null(g_flag) THEN
            LET g_success = g_flag
         ELSE
            LET g_success = 'N'
         END IF
      END IF
   CATCH
      IF sqlca.sqlcode THEN
         LET g_status.sqlcode = sqlca.sqlcode
      END IF
      LET g_success = "N"
      CALL aws_pos_get_code('aws-901',NULL,NULL,NULL)   #ERP系統錯誤
   END TRY
END FUNCTION
#FUN-CC0057-----add---end
#No.FUN-C50138
